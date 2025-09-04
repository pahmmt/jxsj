-------------------------------------------------------------------
--File		: kingame_npc.lua
--Author	: zhengyuhua
--Date		: 2008-5-13 10:24
--Describe	: 家族关卡定义脚本
-------------------------------------------------------------------

local DYN_MAP_ID_START = 65535 --动态地图起始

-- 进入副本对话逻辑
function KinGame:OnEnterDialog(bConfirm)
  -- 城市的地图ID，每个城市有开副本的上限限制
  local nKinId, nMemberId = me.GetKinMember()
  local cKin = KKin.GetKin(nKinId)
  local nRet = Kin:CheckSelfRight(nKinId, nMemberId, 2)
  local nRet2 = Kin:HaveFigure(nKinId, nMemberId, 3)
  local bIsOldPAction = EventManager.ExEvent.tbPlayerCallBack:IsOpen(me, 2) -- 是否是老玩家在召回期间参见活动
  local nNpcServerCityId = KinGame2:GetSeverCity() --npc所在server的城市map
  local tbOpt = {
    --{"我想修改家族关卡的活动时间及地点", self.ChangeGameSetting, self, 0},
    { "勾魂玉", self.OnBuyCallBossItem, self, 1 },
    { "购买家族声望装备", self.OpenReputeShop, self },
    { "我想用古铜钱换取奖励", self.OnFinalAward, self },
    { "<color=yellow>我想用古金币换取奖励<color>", self.OnFinalAward_New, self },
    { "来谈谈钱袋的事情吧", self.GameExplain, self, 2 },
    { "活动说明", self.GameExplain, self, 1 },
    { "结束对话" },
  }
  if HomeLand:GetMapIdByKinId(nKinId) <= 0 and me.nMapId >= DYN_MAP_ID_START then
    local szMsg = "    你们的家族排名跌出排名前200，家族领地已被收回，我可以送你回到城市！"
    local tbBackOpt = {}
    tbBackOpt[#tbBackOpt + 1] = { "我要回城市", Npc:GetClass("chefu").SelectMap, Npc:GetClass("chefu"), "city" }
    tbBackOpt[#tbBackOpt + 1] = { "我在待一会" }
    Dialog:Say(szMsg, tbBackOpt)
    return 0
  end
  if 0 == bIsOldPAction then -- 老玩家在召回期间参加活动可以不论任何身份都能参加
    if not cKin or nRet2 ~= 1 then
      Dialog:Say("看来你还不是一个家族的正式成员，等你成为<color=red>家族正式成员<color>再来找我吧。", unpack(tbOpt))
      return 0
    end
  elseif not cKin then
    Dialog:Say("看来你还没有加入家族，等你加入家族再来找我吧。", unpack(tbOpt))
    return 0
  end
  -- 原有进入流程太乱，新流程搬出来，进行改变
  -- 如果有家园并且开放150级了，才能进行新流程
  if HomeLand:GetMapIdByKinId(nKinId) > 0 and TimeFrame:GetState("OpenLevel150") == 1 then
    self:OnEnterDialog_New(bConfirm)
    return 0
  end
  if HomeLand:GetMapIdByKinId(nKinId) == me.nMapId and TimeFrame:GetState("OpenLevel150") ~= 1 then
    Dialog:Say("    石鼓书院，需要您所在的服务器开放150级等级上限后才能开启哦！若想开启神秘宝库副本，去各大城市里找我，我会带你们过去的！", unpack(tbOpt))
    return 0
  end
  local tbData = Kin:GetKinData(nKinId)
  if tbData.nApplyKinGameMap and tbData.nApplyKinGameMap ~= nNpcServerCityId then
    local szCity = GetMapNameFormId(tbData.nApplyKinGameMap)
    local szMsg = string.format("你们的老大刚跟我在“%s”达成了协议，这里行动不方便，要去那个家族关卡的话就去“%s”找我吧！", szCity, szCity)
    Dialog:Say(szMsg, unpack(tbOpt))
    return 0
  end
  if tbData.nApplyKinGameMap == nNpcServerCityId then
    local tbGame = KinGame:GetGameObjByKinId(nKinId)
    if not tbGame then
      Dialog:Say("请稍候……")
      return
    end
    if tbGame:IsStart() == 1 and tbGame:FindLogOutPlayer(me.nId) ~= 1 then
      Dialog:Say("你们家族的人已经进去开启了机关关闭了入口，现在谁也进不去了！", tbOpt)
      return 0
    end
    local tbIsBagIn = { "好的，送我过去吧。", self.JoinGame, self }
    local tbFind = me.FindItemInBags(unpack(self.QIANDAI_ITEM))
    if #tbFind < 1 then
      tbFind = me.FindItemInRepository(unpack(self.QIANDAI_ITEM))
      if #tbFind < 1 then
        tbIsBagIn = { "好的，送我过去吧。", self.GiveQianDai, self, 1 }
      end
    end
    Dialog:Say("准备好了吗？我现在就带你过去神秘地下宫殿。", {
      tbIsBagIn,
      unpack(tbOpt),
    })
    return 0
  end
  local nTime = cKin.GetKinGameTime()
  local nDegree = cKin.GetKinGameDegree()
  if os.date("%W%w", nTime) == os.date("%W%w", GetTime()) then
    Dialog:Say("嗯？不是刚回来吗？你还想去不成？", tbOpt)
    me.Msg("本活动一天只能进行1次，请明天再来吧。")
    return 0
  end
  if os.date("%W", nTime) == os.date("%W", GetTime()) and nDegree >= KinGame.MAX_WEEK_DEGREE then
    Dialog:Say(string.format("   这个星期搞到了不少好东西吧！不过行有行规，探险这种危险的事情，去太频繁的话会出事的！\n   一个星期去了<color=red>%d次<color>就不敢再去了。", KinGame.MAX_WEEK_DEGREE), tbOpt)
    me.Msg(string.format("该活动一周内只能开启%d次,请下周再来吧。", KinGame.MAX_WEEK_DEGREE))
    return 0
  end
  if nRet == 1 and bConfirm ~= 1 then
    if self:GetCityGameNum(nNpcServerCityId) >= self.MAX_GAME then
      Dialog:Say("嘘~！这里似乎有人在偷听！我们换个城市再聊吧！", tbOpt)
      me.Msg("该城市的活动场地已满！")
      return 0
    end
    Dialog:Say("   我最近发现了一座神秘的地下宫殿！我倒了一辈子的斗，都没见过这么大的，可惜里面机关重重，我一个人就算进去怕且也不能活着出来。看起来你们家族有这个实力，你们要去么？我只要能跟着去看看就满足了。\n   不过要注意的是<color=green>里面的机关需要6个人才会开启，如果人不够的话是无法进入这个地下宫殿的。<color>", {
      { "好！带我们的人过去吧！", self.OnEnterDialog, self, 1 },
      unpack(tbOpt),
    })
    return 0
  elseif nRet == 1 then
    local tbData_New = Kin:GetKinData(nKinId)
    if tbData_New and tbData_New.nApplyKinGameMap then
      Dialog:Say("你们家族关卡已经申请成功了！")
      return 0
    end
    if me.CountFreeBagCell() < 1 then
      me.Msg("你的背包空间不足！")
      return 0
    end
    local pItem = me.AddItemEx(unpack(self.OPEN_KEY_ITEM))
    if pItem then
      me.SetItemTimeout(pItem, self.KEY_ITME_TIME)
      pItem.Sync()
    end
    GCExcute({ " KinGame:ApplyKinGame_GC", nKinId, nMemberId, nNpcServerCityId, me.nId })
    Dialog:Say("   这个我仿制的大门钥匙给你，这个地宫只要有人进去10分钟后入口就会关闭，外面的人就进不来了。就是说你有10分钟时间聚集人手，不过如果你们人都齐了的话你也可以用我给你的钥匙提前开启机关。\n    准备好了再来找我吧！")
    return 0
  else
    Dialog:Say("   我最近发现了一座神秘的地下宫殿！我倒了一辈子的斗，都没见过这么大的，可惜里面机关重重，我一个人就算进去怕且也不能活着出来。你们家族如果有实力的话我可以带你们去！\n   <color=red>让你们族长来见我吧！", tbOpt)
    return 0
  end
end

-- 详细说明
function KinGame:GameExplain(nType)
  if nType == 1 then
    Dialog:Say(string.format("   本活动为家族活动，必须为正式家族成员才能参加，并且需要家族的族长或副族长开启，开启后你有10分钟时间进入副本，10分种后活动自动开始，这时将不能再进入。本活动最少参加人数为6人，如果人数不够的话活动将取消。活动难度与奖励将随参加人数而调整，就是说参加的人数越多每个人所能拿到的奖励就越多。\n   <color=green>注意：本活动每个星期能开启%d次，但一天只能开启1次，活动最大时间为2小时，就是说无论是否完成2小时后在神秘地宫的所有玩家将会被传送回城市。<color>", KinGame.MAX_WEEK_DEGREE))
  elseif nType == 2 then
    Dialog:Say("你是说那个钱袋啊，这种钱袋上有我秀上的标记，给你这个是我信任你的证明，如果你搞不见了我可以再给你一个。不过要记得，想找我换宝箱的话就把钱袋带在身上以示诚意！", {
      { "我上次把钱袋搞丢了，你能再给我一个吗？", self.GiveQianDai, self },
      { "结束对话" },
    })
  end
end

-- 给予钱袋
function KinGame:GiveQianDai(bJoinGame)
  local tbFind1 = me.FindItemInBags(unpack(self.QIANDAI_ITEM))
  local tbFind2 = me.FindItemInRepository(unpack(self.QIANDAI_ITEM))
  if #tbFind1 > 0 or #tbFind2 > 0 then
    Dialog:Say("你的钱袋并没有弄丢呀")
    return 0
  end
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("这个钱袋你拿着，在地宫里有许多古铜钱，如果你能收集到一些的话我不会亏待你的。\n   <color=red>哎呀，你的背包已经满了，放不下我给你的钱袋，先整理下包包吧<color>")
    return 0
  end
  me.AddItem(unpack(self.QIANDAI_ITEM))
  local tbOpt = { { "好！" } }
  if bJoinGame == 1 then
    tbOpt = { "好！", self.JoinGame, self }
  end
  Dialog:Say("这个钱袋你拿着，在地宫里有许多古铜钱，如果你能收集到一些的话我不会亏待你的。", tbOpt)
end

function KinGame:OnFinalAward()
  local tbFind1 = me.FindItemInBags(unpack(self.QIANDAI_ITEM))
  if #tbFind1 < 1 then
    Dialog:Say("你的钱袋不在身上哦！等你把钱袋拿来再跟我换吧。")
    return 0
  end
  local szMsg = "我果然没看错，你们是一群有实力的人啊！这个地下宫殿里的古铜钱相信你拿到不少了吧？我愿意用我珍藏的宝箱跟你换！"
  local tbOpt = {
    { "用100个古铜钱换取宝箱", self.GiveFinalAward, self },
    { "结束对话" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function KinGame:GiveFinalAward()
  local pPlayer = me
  local nCount = pPlayer.GetTask(KinGame.TASK_GROUP_ID, KinGame.TASK_BAG_ID)
  if nCount < 100 then
    Dialog:Say("我需要100个古铜钱，等你收集够了再给我吧，不然我可要忙死了。")
    return 0
  end

  local nFreeCount, tbExecute = SpecialEvent.ExtendAward:DoCheck("KinGame", pPlayer, nCount, 1)
  if me.CountFreeBagCell() < 1 + nFreeCount then
    me.Msg("您背包空间不足。")
    return 0
  end

  pPlayer.SetTask(KinGame.TASK_GROUP_ID, KinGame.TASK_BAG_ID, nCount - 100)
  local nAddExp = self.LevelBaseExp[pPlayer.nLevel] * 30 * 2
  pPlayer.AddExp(nAddExp)
  pPlayer.AddItem(unpack(self.ZHENCHANGBAOXIANG_ITEM))

  SpecialEvent.ExtendAward:DoExecute(tbExecute)
  -- 江湖威望改为击杀boss时获取，by zhangjinpin@kingsoft
  --pPlayer.AddKinReputeEntry(5, "kingame");
  Dialog:Say("这些古铜钱货色不错，这些是你的奖励，收下吧。")
end

function KinGame:ShowInfo(nRoomId, nMapId)
  local tbGame = self:GetGameObjByMapId(nMapId)
  Lib:ShowTB1(tbGame.tbRoom[nRoomId].tbNextLock)
end

function KinGame:UnLock(nRoomId, nMapId)
  local tbGame = self:GetGameObjByMapId(nMapId)
  tbGame.tbRoom[nRoomId]:UnLock()
end

function KinGame:OpenReputeShop()
  local nFaction = me.nFaction
  if nFaction <= 0 or me.GetCamp() == 0 then
    Dialog:Say("非白名玩家才能购买家族装备")
    return 0
  end
  me.OpenShop(self.REPUTE_SHOP_ID[nFaction], 1, 100, me.nSeries) --使用声望购买
end

function KinGame:OnBuyCallBossItem(nStep, nItemLevel, szItemLevel)
  local nKinId, nMemberId = me.GetKinMember()
  local nRet, cKin = Kin:CheckSelfRight(nKinId, nMemberId, 2)
  local szInfo = "  勾魂玉是一种特殊的宝物，在家族关卡中使用它，就可以召唤出一位武林高手，战胜他就能获得宝物。\n  <color=green>初级勾魂玉可以召唤出55级武林高手\n  中级勾魂玉可以召唤出75级武林高手<color>\n购买勾魂玉，需要花费家族的古银币。每周日24：00，会根据你家族的总威望值，赠送你们古银币。满1000点总威望可以获得100个，满2000点总威望可获得150个，满4000威望可获得200个。\n"
  local tbOpt = { { "结束对话" } }
  if cKin and nStep == 1 then
    szInfo = szInfo .. string.format("你的家族当前累计的古银币数量为:\n <color=red>%d/%d<color>", cKin.GetKinGuYinBi(), Kin.MAX_GU_YIN_BI)
    if nRet == 1 then
      tbOpt = {
        { string.format("购买初级勾魂玉(%d古银币)", self.GOU_HUN_YU_COST[1]), self.OnBuyCallBossItem, self, 2, 1, "初级" },
        { string.format("购买中级勾魂玉(%d古银币)", self.GOU_HUN_YU_COST[2]), self.OnBuyCallBossItem, self, 2, 2, "中级" },
        { "结束对话" },
      }
    else
      szInfo = szInfo .. "\n  只有家族族长或副族长才能购买，让他们来找我吧。"
    end
  elseif nRet == 1 and nStep >= 2 then
    if cKin.GetKinGuYinBi() < self.GOU_HUN_YU_COST[nItemLevel] then
      szInfo = "你的银币好像不够哦，攒够了再来买吧"
      nRet = 0
    end
    if me.CountFreeBagCell() <= 0 then
      szInfo = "你的背包不足！"
      nRet = 0
    end
    if nStep == 2 and nRet == 1 then
      szInfo = string.format("你要购买1个%s勾魂玉，将会花费%d个古银币，你确定要购买吗？", szItemLevel, self.GOU_HUN_YU_COST[nItemLevel])
      tbOpt = {
        { "确定购买", self.OnBuyCallBossItem, self, 3, nItemLevel, szItemLevel },
        { "我再考虑一下" },
      }
    elseif nStep == 3 and nRet == 1 then
      me.AddWaitGetItemNum(1) -- 角色锁定
      return GCExcute({ "KinGame:BuyCallBossItem_GC", nKinId, nMemberId, nItemLevel })
    end
  end
  Dialog:Say(szInfo, tbOpt)
end

function KinGame:ChangeGameSetting(bConfirm)
  local szInfo = "我没有听错吧？既然是这样，那么请您准备好100000两银两，以便我来为您安排相关的事项。"
  local tbOpt = {
    { "我准备好了100000两银两。剩下的事就麻烦您了。", self.ChangeGameSetting, self, 1 },
    { "我再考虑考虑吧。" },
  }

  if bConfirm == 0 then
    Dialog:Say(szInfo, tbOpt)
    return 0
  end

  -- 弹出修改对话框
  local nKinId, nMemberId = me.GetKinMember()
  local cKin = KKin.GetKin(nKinId)
  local nOrderTime1 = 0
  local nOrderTime2 = 0
  local nOrderTime3 = 0
  local nOrderMapId = 0
  cKin.SetKinGameOrderTime1(nOrderTime1)
  cKin.SetKinGameOrderTime2(nOrderTime2)
  cKin.SetKinGameOrderTime3(nOrderTime3)
  cKin.SetKinGameOrderMapId(nOrderMapId)

  KinGame:ApplyKinGame(nKinId, cKin.GetKinGameOrderMapId())
end

function KinGame:GameExplain_New(nType)
  if nType == 1 then
    local szMsg = "你想了解哪个活动？"
    local tbOpt = {}
    tbOpt[#tbOpt + 1] = { "石鼓书院", self.GameExplain_New, self, 3 }
    tbOpt[#tbOpt + 1] = { "神秘宝库", self.GameExplain, self, 1 }
    Dialog:Say(szMsg, tbOpt)
  elseif nType == 2 then
    Dialog:Say("你是说那个古金币袋子啊，这种钱袋是家族高级关卡专用(石鼓书院)钱袋，给你这个是我信任你的证明，如果你搞不见了我可以再给你一个。不过要记得，想找我换石鼓残卷的话就把钱袋带在身上以示诚意！", {
      { "我上次把钱袋搞丢了，你能再给我一个吗？", self.GiveQianXiang, self },
      { "结束对话" },
    })
  elseif nType == 3 then
    Dialog:Say(string.format("   本关卡为家族高级关卡，必须为正式家族成员才能参加，并且需要家族的族长或副族长开启，开启后你有10分钟时间进入副本，10分种后活动自动开始，这时将不能再进入。本关卡最少参加人数为8人，最多为40人。\n   石鼓书院进入后，在大门处开启时，可进行关卡难度的选择，难度越高，获得奖励将会越高。\n   <color=green>注意：本关卡只能从家族领地的马穿山进入，每个星期能开启%d次，但一天只能开启1次，活动最大时间为2小时，就是说无论是否完成，2小时后所有玩家将会被传送回城市。<color>", KinGame.MAX_WEEK_DEGREE))
  end
end

function KinGame:OnEnterDialog_New(bConfirm)
  -- 城市的地图ID，每个城市有开副本的上限限制
  local nKinId, nMemberId = me.GetKinMember()
  local cKin = KKin.GetKin(nKinId)
  local nRet = Kin:CheckSelfRight(nKinId, nMemberId, 2)
  local nRet2 = Kin:HaveFigure(nKinId, nMemberId, 3)
  local bIsOldPAction = EventManager.ExEvent.tbPlayerCallBack:IsOpen(me, 2) -- 是否是老玩家在召回期间参见活动
  local nNpcServerCityId = KinGame2:GetSeverCity()
  local tbOpt = {
    --{"我想修改家族关卡的活动时间及地点", self.ChangeGameSetting, self, 0},
    { "勾魂玉", self.OnBuyCallBossItem, self, 1 },
    { "购买家族声望装备", self.OpenReputeShop, self },
    { "我想用古铜钱换取奖励", self.OnFinalAward, self },
    { "<color=yellow>我想用古金币换取奖励<color>", self.OnFinalAward_New, self },
    { "来谈谈钱袋的事情吧", self.GameExplain, self, 2 },
    { "<color=yellow>来谈谈古金币袋的事情吧<color>", self.GameExplain_New, self, 2 },
    { "活动说明", self.GameExplain_New, self, 1 },
    { "结束对话" },
  }
  if 0 == bIsOldPAction then -- 老玩家在召回期间参加活动可以不论任何身份都能参加
    if not cKin or nRet2 ~= 1 then
      Dialog:Say("看来你还不是一个家族的正式成员，等你成为<color=red>家族正式成员<color>再来找我吧。", unpack(tbOpt))
      return 0
    end
  elseif not cKin then
    Dialog:Say("看来你还没有加入家族，等你加入家族再来找我吧。", unpack(tbOpt))
    return 0
  end

  local tbData = Kin:GetKinData(nKinId)
  --新家族关卡的判断
  if tbData.nIsNewGame and tbData.nIsNewGame == 1 then
    self:EnterNewGame(tbOpt)
    return 0
  end
  if tbData.nApplyKinGameMap and tbData.nApplyKinGameMap ~= nNpcServerCityId then
    local szCity = GetMapNameFormId(tbData.nApplyKinGameMap)
    local szMsg = string.format("你们的老大刚跟我在“%s”达成了协议，这里行动不方便，要去那个家族关卡的话就去“%s”找我吧！", szCity, szCity)
    Dialog:Say(szMsg, unpack(tbOpt))
    return 0
  end
  if tbData.nApplyKinGameMap and HomeLand:GetMapIdByKinId(nKinId) == me.nMapId then
    local szCity = GetMapNameFormId(tbData.nApplyKinGameMap)
    local szMsg = string.format("神秘宝库副本已经开启了，快去<color=yellow>“%s”<color>找我，我会带你们过去的!", szCity)
    Dialog:Say(szMsg, unpack(tbOpt))
    return 0
  end
  if tbData.nApplyKinGameMap == nNpcServerCityId then
    local tbGame = KinGame:GetGameObjByKinId(nKinId)
    if not tbGame then
      Dialog:Say("请稍候……")
      return
    end
    if tbGame:IsStart() == 1 and tbGame:FindLogOutPlayer(me.nId) ~= 1 then
      Dialog:Say("你们家族的人已经进去开启了机关关闭了入口，现在谁也进不去了！", tbOpt)
      return 0
    end
    local tbIsBagIn = { "好的，送我过去吧。", self.JoinGame, self }
    local tbFind = me.FindItemInBags(unpack(self.QIANDAI_ITEM))
    if #tbFind < 1 then
      tbFind = me.FindItemInRepository(unpack(self.QIANDAI_ITEM))
      if #tbFind < 1 then
        tbIsBagIn = { "好的，送我过去吧。", self.GiveQianDai, self, 1 }
      end
    end
    Dialog:Say("准备好了吗？我现在就带你过去神秘地下宫殿。", {
      tbIsBagIn,
      unpack(tbOpt),
    })
    return 0
  end
  local nTime = cKin.GetKinGameTime()
  local nDegree = cKin.GetKinGameDegree()
  if os.date("%W%w", nTime) == os.date("%W%w", GetTime()) then
    Dialog:Say("嗯？不是刚回来吗？你还想去不成？", tbOpt)
    me.Msg("本活动一天只能进行1次，请明天再来吧。")
    return 0
  end
  if os.date("%W", nTime) == os.date("%W", GetTime()) and nDegree >= KinGame.MAX_WEEK_DEGREE then
    Dialog:Say(string.format("   这个星期搞到了不少好东西吧！不过行有行规，探险这种危险的事情，去太频繁的话会出事的！\n   一个星期去了<color=red>%d次<color>就不敢再去了。", KinGame.MAX_WEEK_DEGREE), tbOpt)
    me.Msg(string.format("该活动一周内只能开启%d次,请下周再来吧。", KinGame.MAX_WEEK_DEGREE))
    return 0
  end
  if nRet == 1 and bConfirm ~= 1 then
    local nGameNum = self:GetCityGameNum(nNpcServerCityId) + KinGame2:GetCityGameNum(nNpcServerCityId)
    if nGameNum >= self.MAX_GAME then
      Dialog:Say("嘘~！这里似乎有人在偷听！我们换个城市再聊吧！", tbOpt)
      me.Msg("这里的活动场地已满！")
      return 0
    end
    Dialog:Say("   我最近发现了一座神秘的书院！听说这里的儒生们维护理学，个个武功不凡，莫非书院中有什么不可告人的秘密？\n   不过要注意的是<color=green>要进入书院必须从家族专属领地进入，并且需要8个人才会开启，如果人不够的话是无法进入这座神秘书院的。<color>", {
      { "好！带我们的人过去吧！", self.OnEnterDialog_New, self, 1 },
      unpack(tbOpt),
    })
    return 0
  elseif nRet == 1 then
    local szMsg = "   这个我仿制的大门钥匙给你，这个副本只要有人进去10分钟后入口就会关闭，外面的人就进不来了。就是说你有10分钟时间聚集人手，不过如果你们人都齐了的话你也可以用我给你的钥匙提前开启机关。\n    准备好了再来找我吧！"
    local tbOptSelect = {}
    if me.nMapId ~= HomeLand:GetMapIdByKinId(nKinId) then
      tbOptSelect[#tbOptSelect + 1] = { "神秘宝库", self.SelectGame, self, 0, nNpcServerCityId }
    end
    tbOptSelect[#tbOptSelect + 1] = { "石鼓书院", self.SelectGame, self, 1, nNpcServerCityId }
    tbOptSelect[#tbOptSelect + 1] = { "我再考虑下" }
    Dialog:Say(szMsg, tbOptSelect)
    return 0
  else
    Dialog:Say("   我最近发现了一座神秘的书院！听说这里的儒生们维护理学，个个武功不凡，莫非书院中有什么不可告人的秘密？\n   不过要注意的是要进入书院必须从<color=green>家族专属领地<color>进入。<color>\n   <color=red>让你们族长来见我吧！<color>", tbOpt)
    return 0
  end
end

--选择副本
function KinGame:SelectGame(bIsNew, nMapId)
  local nKinId, nMemberId = me.GetKinMember()
  local tbData = Kin:GetKinData(nKinId)
  if tbData and tbData.nApplyKinGameMap then
    Dialog:Say("你们家族关卡已经申请成功了！")
    return 0
  end
  if me.CountFreeBagCell() < 1 then
    me.Msg("你的背包空间不足！")
    return 0
  end
  if not bIsNew or bIsNew == 0 then
    GCExcute({ "KinGame:ApplyKinGame_GC", nKinId, nMemberId, nMapId, me.nId })
    local pItem = me.AddItemEx(unpack(self.OPEN_KEY_ITEM))
    if pItem then
      me.SetItemTimeout(pItem, self.KEY_ITME_TIME)
      pItem.Sync()
    end
    return 0
  elseif bIsNew == 1 then
    if me.nMapId == HomeLand:GetMapIdByKinId(nKinId) then
      GCExcute({ "KinGame2:ApplyKinGame_GC", nKinId, nMemberId, nMapId, me.nId })
      local pItem = me.AddItemEx(unpack(self.OPEN_KEY_ITEM))
      if pItem then
        me.SetItemTimeout(pItem, self.KEY_ITME_TIME)
        pItem.Sync()
      end
      return 0
    else
      local szMsg = "想要开启石鼓书院的大门，必须要到<color=green>家族领地<color>里去找我！要我送你过去么!"
      local tbOpt = {}
      tbOpt[#tbOpt + 1] = { "送我过去吧!", HomeLand.OnEnterDialog, HomeLand }
      tbOpt[#tbOpt + 1] = { "先不过去了！" }
      Dialog:Say(szMsg, tbOpt)
      return 0
    end
  else
    return 0
  end
end

--进入新家族关卡的选项
function KinGame:EnterNewGame(tbOpt)
  if not tbOpt then
    tbOpt = {}
  end
  local nKinId, nMemberId = me.GetKinMember()
  local cKin = KKin.GetKin(nKinId)
  local nNpcServerCityId = KinGame2:GetSeverCity()
  local tbData = Kin:GetKinData(nKinId)
  --if tbData.nApplyKinGameMap and HomeLand:GetMapIdByKinId(nKinId) ~= me.nMapId then --tbData.nApplyKinGameMap ~= nNpcServerCityId and
  if tbData.nApplyKinGameMap and HomeLand:GetMapIdByKinId(nKinId) ~= me.nMapId then
    local szMsg = string.format("   想要进入神秘的石鼓书院，请到你们的<color=green>家族领地<color>找我，在那我会带你们过去的！")
    Dialog:Say(szMsg, unpack(tbOpt))
    return 0
  end
  if tbData.nApplyKinGameMap == nNpcServerCityId and HomeLand:GetMapIdByKinId(nKinId) == me.nMapId then
    --if tbData.nApplyKinGameMap == nNpcServerCityId then
    local tbGame = KinGame2:GetGameObjByKinId(nKinId)
    if not tbGame then
      Dialog:Say("请稍候……")
      return
    end
    if me.nLevel < KinGame2.MIN_LEVEL then --小于80级不能进入
      Dialog:Say("低于80级的玩家，是无法去探索这神秘的石鼓书院的！", tbOpt)
      return 0
    end
    if tbGame:IsStart() == 1 and tbGame:FindLogOutPlayer(me.nId) ~= 1 then
      Dialog:Say("你们家族的人已经进去开启了机关关闭了入口，现在谁也进不去了！", tbOpt)
      return 0
    end
    if tbGame:GetPlayerCount() >= KinGame2.MAX_PLAYER then
      Dialog:Say(string.format("你们家族的进入书院的人已经达到%s人，现在无法进入！", KinGame2.MAX_PLAYER), tbOpt)
      return 0
    end
    local tbIsBagIn = { "<color=yellow>送我去石鼓书院<color>", KinGame2.JoinGame, KinGame2 }
    local tbFind = me.FindItemInBags(unpack(KinGame2.QIANXIANG_ITEM))
    if #tbFind < 1 then
      tbFind = me.FindItemInRepository(unpack(KinGame2.QIANXIANG_ITEM))
      if #tbFind < 1 then
        tbIsBagIn = { "<color=yellow>送我去石鼓书院<color>", self.GiveQianXiang, self, 1 }
      end
    end
    Dialog:Say("准备好了吗？我现在就带你过去这座神秘的书院。", {
      tbIsBagIn,
      unpack(tbOpt),
    })
    return 0
  end
end

--给予钱箱
function KinGame:GiveQianXiang(bJoinGame)
  local tbFind1 = me.FindItemInBags(unpack(KinGame2.QIANXIANG_ITEM))
  local tbFind2 = me.FindItemInRepository(unpack(KinGame2.QIANXIANG_ITEM))
  if #tbFind1 > 0 or #tbFind2 > 0 then
    Dialog:Say("你的钱箱并没有弄丢呀")
    return 0
  end
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("请准备好至少一格背包空间！")
    return 0
  end
  me.AddItem(unpack(KinGame2.QIANXIANG_ITEM))
  local tbOpt = { { "好！" } }
  if bJoinGame == 1 then
    tbOpt = { "好！", KinGame2.JoinGame, KinGame2 }
  end
  Dialog:Say("这个古金币袋子价值不菲，它可以帮助你搜集石鼓书院里的好宝贝，可千万别弄丢了哦！", tbOpt)
end

--新的金币兑换
function KinGame:OnFinalAward_New()
  local tbFind1 = me.FindItemInBags(unpack(KinGame2.QIANXIANG_ITEM))
  if #tbFind1 < 1 then
    Dialog:Say("你身上并没有古金币袋子啊！")
    return 0
  end
  local szMsg = "这里有些石鼓书院的残卷，这些看似破旧的书籍里有着不为人知的秘密！"
  local tbOpt = {
    { "用100个古金币换取石鼓残卷", self.GiveFinalAward_New, self },
    { "结束对话" },
  }
  Dialog:Say(szMsg, tbOpt)
end

--新的金币兑换
function KinGame:GiveFinalAward_New()
  local pPlayer = me
  local nCount = pPlayer.GetTask(KinGame2.TASK_GROUP_ID, KinGame2.TASK_GOLD_COIN)
  if nCount < 100 then
    Dialog:Say("我需要100个古金币，等你收集够了再给我吧，不然我可要忙死了。")
    return 0
  end

  local nFreeCount, tbExecute = SpecialEvent.ExtendAward:DoCheck("KinGame", pPlayer, nCount, 2)
  if me.CountFreeBagCell() < 1 + nFreeCount then
    me.Msg("您背包空间不足。")
    return 0
  end

  pPlayer.SetTask(KinGame2.TASK_GROUP_ID, KinGame2.TASK_GOLD_COIN, nCount - 100)
  local nAddExp = self.LevelBaseExp[pPlayer.nLevel] * 30 * 2
  pPlayer.AddExp(nAddExp)
  pPlayer.AddItem(unpack(KinGame2.KIN_XUNZHANG))

  SpecialEvent.ExtendAward:DoExecute(tbExecute)
  local tbOpt = {}
  tbOpt[#tbOpt + 1] = { "返回上一页", self.OnFinalAward_New, self }
  tbOpt[#tbOpt + 1] = { "结束对话" }
  Dialog:Say("若你能参透残卷，或许能得到价值不菲的奖励哦！", tbOpt)
end
