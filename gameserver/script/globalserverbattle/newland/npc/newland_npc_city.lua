-------------------------------------------------------
-- 文件名　：newland_npc_city.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2010-09-06 16:51:04
-- 文件描述：城市npc
-------------------------------------------------------

if not MODULE_GAMESERVER then
  return
end

Require("\\script\\globalserverbattle\\newland\\newland_def.lua")

local tbNpc = Npc:GetClass("newland_npc_city")

-------------------------------------------------------
-- 1. 打开报名界面
-- 2. 传送到英雄岛
-- 3. 查询跨服绑银
-- 4. 领取征战奖励
-- 5. 兑换同伴装备
-------------------------------------------------------

function tbNpc:OnDialog()
  -- 活动是否开启
  if Newland:CheckIsOpen() ~= 1 then
    Dialog:Say("一去萧萧数十州，相逢非复少年头。")
    return 0
  end

  -- 区服是否开启跨服功能
  local nTransferId = Transfer:GetMyTransferId(me)
  if not Transfer.tbGlobalMapId[nTransferId] then
    Dialog:Say("一去萧萧数十州，相逢非复少年头。")
    return 0
  end

  if Newland:OpenTimeFrame() == 0 then
    Dialog:Say("本服开放103天后方能报名跨服城战。")
    return 0
  end

  local tbOpt = {}
  local szMsg = "铁浮城已千疮百孔，急待它真正的主人出现！您就是那位英雄吗？"

  -- 届数校验
  Newland:RectifySession(me)

  -- 帮会首领选项
  if Newland:GetPeriod() == Newland.PERIOD_SIGNUP then
    table.insert(tbOpt, { "<color=yellow>跨服城战报名<color>", self.SignupWar, self })
  elseif Newland:GetPeriod() == Newland.PERIOD_WAR_OPEN then
    table.insert(tbOpt, { "报名帮会列表", self.ShowGroup, self })
  end

  -- 传送至英雄岛
  if Newland:GetPeriod() == Newland.PERIOD_WAR_OPEN then
    table.insert(tbOpt, 1, { "<color=yellow>前往英雄岛参战<color>", self.AttendWar, self })
  else
    table.insert(tbOpt, { "<color=gray>前往英雄岛<color>", self.AttendWar, self })
  end

  -- 领取奖励
  if Newland:GetPeriod() == Newland.PERIOD_WAR_REST and Newland:GetSession() ~= 0 then
    table.insert(tbOpt, { "<color=yellow>跨服城战奖励<color>", self.ShowAllAward, self })
  end

  -- 查询和兑换
  table.insert(tbOpt, { "查询跨服绑银", self.QueryGlobalMoney, self })
  table.insert(tbOpt, { "查询历届城主", self.QueryCastleHistory, self })

  for szZone, tbHistory in pairs(Newland.tbCastleHistoryBuffer) do
    if Newland.tbZoneId2Name[szZone] then
      table.insert(tbOpt, { string.format("查询原<color=yellow>%s<color>历届城主", Newland.tbZoneId2Name[szZone]), self.QueryCastleOldHistory, self, szZone })
    end
  end

  table.insert(tbOpt, { "兑换同伴装备", self.ExchageEquip, self })
  table.insert(tbOpt, { "提炼同伴碎片", self.SplitAtom, self })
  table.insert(tbOpt, { "了解跨服城战", self.WarHelp, self })
  table.insert(tbOpt, { "查询跨服战区列表", self.QueryGlobalArea, self })
  table.insert(tbOpt, { "我知道了" })

  Dialog:Say(szMsg, tbOpt)
end

--打开战区界面
function tbNpc:QueryGlobalArea()
  me.CallClientScript({ "UiManager:OpenWindow", "UI_GLOBAL_AREA" })
end

-- 帮会报名
function tbNpc:SignupWar()
  -- 是否报名期
  if Newland:GetPeriod() ~= Newland.PERIOD_SIGNUP then
    Dialog:Say("<color=yellow>对不起，现在不是报名阶段，无法报名。<color>")
    return 0
  end

  -- 打开报名界面
  local nCaptain = Newland:CheckTongCaptain(me)
  me.CallClientScript({ "UiManager:OpenWindow", "UI_TIEFUCHENGENROLL" })
  me.CallClientScript({ "Ui:ServerCall", "UI_TIEFUCHENGENROLL", "OnRecvData", nCaptain, Newland.tbSignupBuffer })
end

-- 报名帮会列表
function tbNpc:ShowGroup()
  if Newland:GetPeriod() ~= Newland.PERIOD_WAR_OPEN then
    return 0
  end

  local tbList = {}
  for szTongName, tbInfo in pairs(Newland.tbSignupBuffer) do
    if tbInfo.nSuccess == 1 then
      tbList[szTongName] = tbInfo
    end
  end

  me.CallClientScript({ "UiManager:OpenWindow", "UI_TIEFUCHENGENROLL" })
  me.CallClientScript({ "Ui:ServerCall", "UI_TIEFUCHENGENROLL", "OnRecvData", 0, tbList })
  me.CallClientScript({ "Ui:ServerCall", "UI_TIEFUCHENGENROLL", "DisableAll" })
end

-- 传送到侠客岛
function tbNpc:AttendWar()
  -- 等级限制
  if me.nLevel < 100 then
    Dialog:Say(string.format("<color=yellow>对不起，您的等级不足。<color><enter>%s", Newland.CONDITION_JOIN_NEWLAMD))
    return 0
  end

  -- 门派限制
  if me.nFaction <= 0 then
    Dialog:Say(string.format("<color=yellow>对不起，您还未加入门派。<color><enter>%s", Newland.CONDITION_JOIN_NEWLAMD))
    return 0
  end

  -- 判断披风(混天)
  local pItem = me.GetItem(Item.ROOM_EQUIP, Item.EQUIPPOS_MANTLE, 0)
  if not pItem or pItem.nLevel < Newland.MANTLE_LEVEL then
    Dialog:Say(string.format("<color=yellow>此去极其凶险，您没有足以保护自己的披风，怎能匆忙应战？<color><enter>%s", Newland.CONDITION_JOIN_NEWLAMD))
    return 0
  end

  -- 判断帮会
  local pTong = KTong.GetTong(me.dwTongId)
  if not pTong then
    Dialog:Say(string.format("<color=yellow>此去极其凶险，您尚未加入帮会，怎能匆忙应战？<color><enter>%s", Newland.CONDITION_JOIN_NEWLAMD))
    return 0
  end

  -- 记录帮会名字
  Newland:SetTongName()

  -- 传送到跨服服务器(里面已经做了一些判断)
  Transfer:NewWorld2GlobalMap(me)
end

-- 查询跨服绑银
function tbNpc:QueryGlobalMoney()
  local nMoney = KGCPlayer.OptGetTask(me.nId, KGCPlayer.TSK_CURRENCY_MONEY)
  local szMsg = ""
  if nMoney >= 0 then
    szMsg = string.format("您当前的跨服绑银数量为<color=gold>%s<color>。\n此乃所有跨服活动唯一专用货币，若要获取更多，可按<color=yellow>Ctrl + G<color>打开奇珍阁，购买“跨服活动专用绑银”。", nMoney)
  else
    szMsg = "对不起，暂时无法查询。"
  end
  Dialog:Say(szMsg, { "返回上一层", self.OnDialog, self })
end

-- 城战奖励相关
function tbNpc:ShowAllAward()
  local tbOpt = {
    { "购买个人宝箱", self.GetSingleAward, self },
    { "领取经验威望", self.GetExtraAward, self },
    { "<color=yellow>宝箱里有什么<color>", self.AboutAwardXiang, self },
    { "我知道了" },
  }

  if Newland:CheckCastleOwner(me.szName) ~= 1 then
    table.insert(tbOpt, 1, { "<color=gray>购买城主宝箱<color>", self.BuyCastleBox, self })
    table.insert(tbOpt, 1, { "<color=gray>领取城主奖励<color>", self.GetCastleAward, self })
  else
    table.insert(tbOpt, 1, { "<color=yellow>购买城主宝箱<color>", self.BuyCastleBox, self })
    table.insert(tbOpt, 1, { "<color=yellow>领取城主奖励<color>", self.GetCastleAward, self })
  end

  Dialog:Say("这里可以领取城主奖励、领取经验威望，优惠购买城主和个人宝箱。", tbOpt)
end

-- 领取城主奖励
function tbNpc:GetCastleAward()
  local nCastleBox = Newland:CheckCastleAward(me)
  if nCastleBox <= 0 then
    return 0
  end

  local szMsg = string.format("恭喜您！根据您的帮会排名，可以领取丰厚的城主奖励！")
  local tbOpt = {
    { "确定领取", Newland.GetCastleAward_GS, Newland, me.szName },
    { "我再想想" },
  }
  Dialog:Say(szMsg, tbOpt)
end

-- 购买城主宝箱
function tbNpc:BuyCastleBox()
  local nSellBox = Newland:CheckSellBox(me)
  if nSellBox <= 0 then
    return 0
  end

  local szMsg = string.format("恭喜您！可以优惠购买<color=yellow>%s个辉煌战功箱<color>！<enter><enter>每购买一个需要<color=yellow>%s两<color>跨服绑银，您要购买几个？", nSellBox, Item:FormatMoney(Newland.CASTLE_BOX_PRICE))
  local tbOpt = {
    { "我要购买", self.OnBuyCastleBox, self, nSellBox },
    { "我再想想" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:OnBuyCastleBox(nSellBox)
  Dialog:AskNumber("请输入购买的数量：", nSellBox, Newland.BuyCastleBox_GS, Newland)
end

-- 领取积分奖励
function tbNpc:GetSingleAward()
  local nSingleBox, nPoint = Newland:CheckSingleAward(me)
  if nSingleBox <= 0 then
    return 0
  end

  local szMsg = string.format("恭喜您！您剩余的铁浮城荣誉点数为<color=yellow>%s<color>，可以优惠购买<color=yellow>%s个卓越战功箱<color>！<enter><enter>每购买一个需要<color=yellow>%s两<color>跨服绑银，您要购买几个？", nPoint, nSingleBox, Item:FormatMoney(Newland.NORMAL_BOX_PRICE))
  local tbOpt = {
    { "我要购买", self.OnGetSingleAward, self, nSingleBox },
    { "我再想想" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:OnGetSingleAward(nSingleBox)
  Dialog:AskNumber("请输入购买的数量：", nSingleBox, Newland.GetSingleAward_GS, Newland)
end

function tbNpc:AboutAwardXiang()
  local szMsg = [[
驻守铁浮城的佑鲁氏族工匠们由于冶炼技术上的精进，现在已经可以为我们提供以下装备了：
卓越战功箱有几率开出：
	1、	<color=yellow>碧血战衣、碧血之刃、碧血护身符碎片<color>
	2、	<color=yellow>金鳞战衣、金鳞之刃、金鳞护身符碎片<color>
	3、	7级玄晶（绑定）
	4、	8级玄晶（绑定）
	5、	9级玄晶（绑定）

辉煌战功箱有几率开出：
	1、	<color=yellow>碧血护身符碎片<color>
	2、	<color=yellow>金鳞战衣、金鳞之刃、金鳞护身符碎片<color>
	3、	<color=yellow>丹心战衣、丹心之刃、丹心护身符碎片<color>

	]]
  local tbOpt = {
    { "返回上层", self.ShowAllAward, self },
    { "我知道了" },
  }
  Dialog:Say(szMsg, tbOpt)
end

-- 领取经验威望
function tbNpc:GetExtraAward()
  local nTimes = Newland:CheckExtraAward(me)
  if nTimes <= 0 then
    return 0
  end

  local szMsg = string.format("恭喜您！可以领取<color=yellow>%s<color>经验和<color=yellow>%s<color>点威望！", Newland.PLAYER_WAR_EXP * nTimes, Newland.PLAYER_WAR_REPUTE * nTimes)
  local tbOpt = {
    { "确定领取", Newland.GetExtraAward_GS, Newland },
    { "我再想想" },
  }
  Dialog:Say(szMsg, tbOpt)
end

-- 查询历届城主
function tbNpc:QueryCastleHistory(nFrom)
  local tbHistory = Newland.tbCastleBuffer.tbHistory
  if not tbHistory then
    Dialog:Say("查询不到任何有关城主的记录。")
    return 0
  end

  local nMaxSession = 0
  for nIndex, _ in pairs(tbHistory) do
    nMaxSession = math.max(nMaxSession, nIndex)
  end

  local tbOpt = { { "我知道了" } }
  local szMsg = "\n历届城主名单：\n\n"
  local nCount = 8
  local nLast = nFrom or nMaxSession
  while nCount > 0 and nLast > 0 do
    if tbHistory[nLast] then
      local szSession = (nLast <= 10) and string.format("第%s届", Lib:Transfer4LenDigit2CnNum(nLast)) or string.format("%s届", Lib:Transfer4LenDigit2CnNum(nLast))
      szMsg = szMsg .. string.format("<color=green>%s：<color=yellow>%s%s<color>\n", Lib:StrFillC(szSession, 8), Lib:StrFillC(tbHistory[nLast].szCaptainName, 17), Lib:StrFillC(ServerEvent:GetServerNameByGateway(tbHistory[nLast].szGateway), 8))
      nCount = nCount - 1
    end
    nLast = nLast - 1
  end
  if nCount == 0 and nLast > 0 then
    table.insert(tbOpt, 1, { "下一页", self.QueryCastleHistory, self, nLast })
  end

  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:QueryCastleOldHistory(szZone, nFrom)
  local tbCastleHistoryBuffer = Newland.tbCastleHistoryBuffer
  if not tbCastleHistoryBuffer then
    Dialog:Say("查询不到任何有关区服记录。")
    return 0
  end

  local tbHistory = tbCastleHistoryBuffer[szZone]
  if not tbHistory then
    Dialog:Say("查询不到任何有关城主的记录。")
    return 0
  end

  local szZoneName = Newland.tbZoneId2Name[szZone]

  if not szZoneName then
    szZoneName = "未知大区"
  end

  local nMaxSession = 0
  for nIndex, _ in pairs(tbHistory) do
    nMaxSession = math.max(nMaxSession, nIndex)
  end

  local tbOpt = { { "我知道了" } }
  local szMsg = string.format("\n%s历届城主名单：\n\n", szZoneName)
  local nCount = 8
  local nLast = nFrom or nMaxSession
  while nCount > 0 and nLast > 0 do
    if tbHistory[nLast] then
      local szSession = (nLast <= 10) and string.format("第%s届", Lib:Transfer4LenDigit2CnNum(nLast)) or string.format("%s届", Lib:Transfer4LenDigit2CnNum(nLast))
      szMsg = szMsg .. string.format("<color=green>%s：<color=yellow>%s%s<color>\n", Lib:StrFillC(szSession, 8), Lib:StrFillC(tbHistory[nLast].szCaptainName, 17), Lib:StrFillC(ServerEvent:GetServerNameByGateway(tbHistory[nLast].szGateway), 8))
      nCount = nCount - 1
    end
    nLast = nLast - 1
  end
  if nCount == 0 and nLast > 0 then
    table.insert(tbOpt, 1, { "下一页", self.QueryCastleOldHistory, self, szZone, nLast })
  end

  Dialog:Say(szMsg, tbOpt)
end

-------------------------------------------------------
-- 兑换同伴装备
-------------------------------------------------------

-- 装备碎片与同伴装备的兑换关系
tbNpc.tbExchangeInfo = {
  [941] = { 5, 19, 1, 1 },
  [942] = { 5, 19, 1, 2 },
  [943] = { 5, 19, 1, 3 },
  [944] = { 5, 20, 1, 1 },
  [945] = { 5, 20, 1, 2 },
  [946] = { 5, 20, 1, 3 },
  [947] = { 5, 23, 1, 1 },
  [948] = { 5, 23, 1, 2 },
  [949] = { 5, 23, 1, 3 },
  [1237] = { 5, 22, 1, 1 },
  [1238] = { 5, 22, 1, 2 },
  [1239] = { 5, 22, 1, 3 },
  [1240] = { 5, 21, 1, 1 },
  [1241] = { 5, 21, 1, 2 },
  [1242] = { 5, 21, 1, 3 },
}

function tbNpc:ExchageEquip()
  local szMsg = "这里可以用同伴碎片或结晶，兑换相应的同伴装备。"
  local tbOpt = {
    { "碎片兑换同伴装备", self.ExchangePartnerEq, self },
    { "结晶兑换同伴装备", self.ExchangeJade, self },
    { "我再想想" },
  }
  Dialog:Say(szMsg, tbOpt)
end

-- 第一步选取要换取的装备等级
-- 第二步放入对应类型对应数量的装备碎片
-- 第三步对放入的碎片类型和数量进行匹配判断
-- 第四步删除要兑换的碎片并添加对应的同伴装备
function tbNpc:ExchangePartnerEq(nStep, nLevel, tbItemObj, tbAddItemInfo)
  if me.IsAccountLock() ~= 0 then
    Dialog:Say("你的账号处于锁定状态，无法进行该操作！")
    return 0
  end
  nStep = nStep or 1
  nLevel = nLevel or 0

  local tbLevelInfo = {
    [1] = "碧血",
    [2] = "金鳞",
    [3] = "丹心",
  }

  local szLevel = tbLevelInfo[nLevel] or ""
  local szMsg, tbOpt = "", {}

  if nStep == 1 then
    szMsg = "在跨服城战和楼兰古城中有机会获得不同装备的装备碎片，您要用装备碎片换取哪个级别的同伴装备？"
    tbOpt = {
      { "1级碧血装备", self.ExchangePartnerEq, self, 2, 1 },
      { "2级金鳞装备", self.ExchangePartnerEq, self, 2, 2 },
      { "3级丹心装备", self.ExchangePartnerEq, self, 2, 3 },
      { "我再看看" },
    }
    Dialog:Say(szMsg, tbOpt)
  elseif nStep == 2 then
    if nLevel < 1 or nLevel > 3 then
      return
    end

    szMsg = "在跨服城战和楼兰古城中有机会获得不同装备的装备碎片，"
    szMsg = szMsg .. string.format("<color=green>您可以换取%s之刃、%s战衣、%s护腕、%s戒指、%s护身符。", szLevel, szLevel, szLevel, szLevel, szLevel)
    szMsg = szMsg .. "<color>每件装备需要<color=red>50个对应的装备碎片<color>。"
    Dialog:OpenGift(szMsg, nil, { self.ExchangePartnerEq, self, 3, nLevel })
  elseif nStep == 3 then
    szMsg, tbOpt = self:GetPartnerEquipExchangeInfo(tbItemObj, nLevel)
    Dialog:Say(szMsg, tbOpt)
  elseif nStep == 4 then
    local nToDelCount = 50
    local szSuiPianName = ""
    local nBind = 0

    for i, tbItem in pairs(tbItemObj) do
      local pItem = tbItem[1]
      if pItem.IsBind() == 1 then
        nBind = 1
      end

      if szSuiPianName == "" then
        szSuiPianName = pItem.szName
      end

      if pItem.nCount > nToDelCount then
        if pItem.SetCount(pItem.nCount - nToDelCount, Item.emITEM_DATARECORD_REMOVE) == 1 then
          nToDelCount = 0
        end
      else
        local nCount = pItem.nCount
        if me.DelItem(tbItem[1], Player.emKLOSEITEM_EXCHANGE_PARTEQ) == 1 then
          nToDelCount = nToDelCount - nCount
        end
      end

      if nToDelCount <= 0 then
        break
      end
    end

    if nToDelCount <= 0 then
      local szItemName = KItem.GetNameById(unpack(tbAddItemInfo))
      local pAddItem = me.AddItem(unpack(tbAddItemInfo))
      if pAddItem then
        if nBind == 1 then
          pAddItem.Bind(1)
          pAddItem.Sync()
        end
        me.Msg(string.format("恭喜！您获得了一件%s！", szItemName))
        Dbg:WriteLog("Newland", "跨服城战", me.szAccount, me.szName, string.format("兑换同伴装备：%s", szItemName))
        StatLog:WriteStatLog("stat_info", "partnerequip", "compound", me.nId, me.GetHonorLevel(), szItemName, 1)
      else
        Dbg:WriteLog("Newland", "跨服城战", me.szAccount, me.szName, string.format("兑换同伴装备失败：%s", szItemName))
      end
    elseif nToDelCount < 50 then
      Dbg:WriteLog(string.format("玩家%s用碎片兑换同伴装备失败，扣除了%s%d个！", me.szName, szSuiPianName, 50 - nToDelCount))
    end
  end
end

-- 获得碎片与装备之间的兑换关系
function tbNpc:GetPartnerEquipExchangeInfo(tbItemObj, nLevel)
  local nCount = 0
  local nParticular = 0
  local szMsg, tbOpt = "", {}

  for i, tbItem in pairs(tbItemObj) do
    local pItem = tbItem[1]

    if not self.tbExchangeInfo[pItem.nParticular] or self.tbExchangeInfo[pItem.nParticular][4] ~= nLevel then
      szMsg = "<color=red>您放入的物品不对<color>，每件装备需要50个对应的装备碎片。"
      break
    elseif nParticular ~= pItem.nParticular then
      if nParticular == 0 then
        nParticular = pItem.nParticular
      else
        szMsg = "一次只能换取一件同伴装备，所以请只放入一种类型的装备碎片！"
        break
      end
    end

    nCount = nCount + pItem.nCount
  end

  if nCount < 50 and szMsg == "" then
    szMsg = "<color=red>您放入的物品数量不足<color>, 每件装备需要50个对应的装备碎片。"
  end

  if szMsg == "" then
    szMsg = string.format("您确定要用50个%s换取<color=red>%s<color>", KItem.GetNameById(18, 1, nParticular, 1), KItem.GetNameById(unpack(self.tbExchangeInfo[nParticular])))
    tbOpt = {
      { "我确定", self.ExchangePartnerEq, self, 4, nLevel, tbItemObj, self.tbExchangeInfo[nParticular] },
      { "我再想想" },
    }
  end

  return szMsg, tbOpt
end

tbNpc.tbJadeList = {
  [1] = { "碧血之刃", { 5, 19, 1, 1 }, 150 },
  [2] = { "碧血战衣", { 5, 20, 1, 1 }, 100 },
  [3] = { "碧血护身符", { 5, 23, 1, 1 }, 1000 },
}

function tbNpc:ExchangeJade()
  local szMsg = "你要兑换那种同伴装备？"
  local tbOpt = {}
  for i, tbInfo in ipairs(self.tbJadeList) do
    table.insert(tbOpt, { tbInfo[1], self.DoExchangeJade, self, i })
  end
  tbOpt[#tbOpt + 1] = { "我再想想" }
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:DoExchangeJade(nType, nSure)
  if not nType or not self.tbJadeList[nType] then
    return 0
  end
  local tbInfo = self.tbJadeList[nType]
  if not nSure then
    local szMsg = string.format("你打算兑换<color=yellow>%s<color>，需要消耗<color=yellow>%s个<color>结晶，确定吗？", tbInfo[1], tbInfo[3])
    local tbOpt = {
      { "<color=yellow>确定<color>", self.DoExchangeJade, self, nType, 1 },
      { "我再想想" },
    }
    Dialog:Say(szMsg, tbOpt)
    return 0
  end
  local nFind = me.GetItemCountInBags(unpack(Newland.JADE_ID))
  if nFind < tbInfo[3] then
    Dialog:Say(string.format("你身上的结晶不足<color=yellow>%s个<color>，无法兑换<color=yellow>%s<color>", tbInfo[3], tbInfo[1]))
    return 0
  end
  local nNeedSpace = 1
  if me.CountFreeBagCell() < nNeedSpace then
    Dialog:Say(string.format("请留出<color=yellow>%s格<color>背包空间。", nNeedSpace))
    return 0
  end
  local nRet = me.ConsumeItemInBags2(tbInfo[3], 18, 1, 1491, 1)
  if nRet ~= 0 then
    Dbg:WriteLog("Newland", "跨服城战", me.szAccount, me.szName, string.format("扣除%s个结晶失败", tbInfo[3]))
  end
  me.AddItem(unpack(tbInfo[2]))
  Dbg:WriteLog("Newland", "跨服城战", me.szAccount, me.szName, string.format("兑换同伴装备：%s", tbInfo[1]))
end

function tbNpc:SplitAtom()
  Dialog:OpenGift("请放入同伴装备碎片<color=yellow>（只有碧血战衣、碧血之刃、碧血护身符碎片可以提炼）<color>", nil, { self.DoSplitAtom, self })
end

function tbNpc:DoSplitAtom(tbItem, nSure)
  local tbList = {
    [1] = { "碧血之刃碎片", { 18, 1, 941, 1 }, 3 },
    [2] = { "碧血战衣碎片", { 18, 1, 944, 1 }, 2 },
    [3] = { "碧血护身符碎片", { 18, 1, 947, 1 }, 20 },
  }

  local nBind = 0
  local nValue = 0
  for _, tbTmpItem in pairs(tbItem) do
    local pItem = tbTmpItem[1]
    local szKey = string.format("%s,%s,%s,%s", pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel)
    for _, tbInfo in pairs(tbList) do
      if szKey == string.format("%s,%s,%s,%s", unpack(tbInfo[2])) then
        nValue = nValue + tbInfo[3] * pItem.nCount
        nBind = pItem.IsBind() or 0
      end
    end
  end

  if nValue <= 0 then
    Dialog:Say("请放入正确的同伴碎片。")
    return 0
  end

  local nNeed = KItem.GetNeedFreeBag(Newland.JADE_ID[1], Newland.JADE_ID[2], Newland.JADE_ID[3], Newland.JADE_ID[4], { bForceBind = nBind }, nValue)
  if me.CountFreeBagCell() < nNeed then
    Dialog:Say(string.format("请留出%s格背包空间。", nNeed))
    return 0
  end

  if me.nCashMoney < nValue * 10000 then
    Dialog:Say(string.format("你身上的银两不足：%s。", nValue * 10000))
    return 0
  end

  if not nSure then
    local szMsg = string.format("你打算提炼<color=yellow>%s个<color>结晶吗？本次提炼将消耗<color=yellow>%s<color>银两", nValue, nValue * 10000)
    local tbOpt = {
      { "<color=yellow>确定<color>", self.DoSplitAtom, self, tbItem, 1 },
      { "我再想想" },
    }
    Dialog:Say(szMsg, tbOpt)
    return 0
  end

  for _, tbTmpItem in pairs(tbItem) do
    local pItem = tbTmpItem[1]
    local szKey = string.format("%s,%s,%s,%s", pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel)
    for _, tbInfo in pairs(tbList) do
      if szKey == string.format("%s,%s,%s,%s", unpack(tbInfo[2])) then
        if me.DelItem(pItem) ~= 1 then
          Dbg:WriteLog("Newland", "跨服城战", me.szAccount, me.szName, string.format("扣除同伴碎片失败：%s", pItem.szName))
          return 0
        end
      end
    end
  end
  me.AddStackItem(Newland.JADE_ID[1], Newland.JADE_ID[2], Newland.JADE_ID[3], Newland.JADE_ID[4], nil, nValue)
  me.CostMoney(nValue * 10000, Player.emKEARN_EVENT)
  Dbg:WriteLog("Newland", "跨服城战", me.szAccount, me.szName, string.format("提炼同伴结晶：%s个", nValue))
end

-------------------------------------------------------
-- 跨服城战帮助
-------------------------------------------------------

-- 帮助对话
function tbNpc:WarHelp()
  local szMsg = "铁浮城宝座虚位以待，谁能坐得长久也未为可知……<enter><color=gold>更多请按F12-详细帮助-跨服城战<color>"
  local tbOpt = {
    { "城战简介", self.OnWarHelp, self, 1 },
    { "城战时间", self.OnWarHelp, self, 2 },
    { "城战报名", self.OnWarHelp, self, 3 },
    { "城战流程", self.OnWarHelp, self, 4 },
    { "城战积分", self.OnWarHelp, self, 5 },
    { "城战奖励", self.OnWarHelp, self, 6 },
    { "常见问题", self.OnWarHelp, self, 7 },
    { "我知道了" },
  }

  Dialog:Say(szMsg, tbOpt)
end

-- 帮助子类
function tbNpc:OnWarHelp(nIndex)
  local szMsg = ""

  if nIndex == 1 then
    szMsg = [[
<color=green>【城战简介】<color>

    世人从古图《清明上河图》中，发现了一座藏宝甚丰的古城，这座城池名叫“<color=yellow>铁浮城<color>”。一时间，江湖风云突变，英雄骤起，都只为这传说中的<color=yellow>铁浮城王座<color>而来……
    
    铁浮城争夺战已经拉开帷幕，<color=yellow>全区<color>的各路英雄豪杰们，请不要错过良机，各大主城的<color=yellow>铁浮城远征大将<color>将带您揭开跨服城战之序幕！
    
    <color=green>相关NPC：<color><color=yellow>铁浮城远征大将<color>（城市）
    <color=red>注意：<color>开启150等级上限后，开启跨服城战。
    
    <color=gold>详情请查阅F12帮助锦囊-详细帮助-跨服城战<color>
]]
  elseif nIndex == 2 then
    szMsg = [[
<color=green>【城战时间】<color>

    <color=yellow>报名：<color>周四00：00--周六19：29
    <color=yellow>准备：<color>周六19：30--周六19：59
    <color=yellow>战斗：<color>周六20：00--周六21：29
    <color=yellow>领奖：<color>周六21：30--下周三23：59

<color=gold>详情请查阅F12帮助锦囊-详细帮助-跨服城战<color>
]]
  elseif nIndex == 3 then
    szMsg = string.format(
      [[
<color=green>【城战报名】<color>

    1、拥有超过30名装备有<color=yellow>%s<color>或%s以上披风的任意玩家的帮会，由帮会首领前往<color=yellow>铁浮城远征大将<color>处选择“帮会申请”，即为帮会报名。
    
    2、在报名期间内，该帮会必须有<color=yellow>30名以上<color>装备有<color=yellow>%s<color>或者更高等级披风、且等级大于100并加入门派的玩家前来登记，才可使帮会获得参战资格。过期若人数不满30，则报名无效。
    
    3、参战帮会上限为<color=yellow>45个<color>，若符合条件帮会超过45个，则之后报名无效。若报名成功帮会少于<color=yellow>4个<color>，则无法开启跨服城战。
    
    4、获得参战资格帮会的帮众，等级大于100且加入门派并装备有%s或%s以上披风即可动身前往铁浮城参战。

<color=gold>详情请查阅F12帮助锦囊-详细帮助-跨服城战<color>
]],
      Newland.MIN_MANTLE_LEVEL_NAME,
      Newland.MIN_MANTLE_LEVEL_NAME,
      Newland.MIN_MANTLE_LEVEL_NAME,
      Newland.MIN_MANTLE_LEVEL_NAME,
      Newland.MIN_MANTLE_LEVEL_NAME
    )
  elseif nIndex == 4 then
    szMsg = [[
<color=green>【准备期】<color>
    1、准备期可从各大主城的<color=yellow>铁浮城远征大将<color>处进入<color=yellow>英雄岛<color>，并从英雄岛的<color=yellow>铁浮城传送人<color>处进入<color=yellow>铁浮城外围<color>等待。
    2、30分钟准备期内，可以布置战局、用跨服绑银购买药品等。

<color=green>【城战期】<color>
    <color=yellow>1、外围争夺战<color>
    20:00城战打响，各帮会进入外围地图。需要注意的是，依据参战帮会数量，每张外围地图只会容纳最多3个帮会，所有的帮会会在<color=yellow>不同的外围地图<color>争夺外围资源。只有在外围地图攻占<color=yellow>三根（包括三）以上龙柱（每张地图共五根）<color>，该帮会成员才<color=yellow>有资格进入内城（进入不限制披风等级）<color>。

    <color=yellow>2、内城争夺战<color>
    进入内城后，同样有五根龙柱资源供大家争夺，只有某帮会占据其中三根或以上，该帮会成员才具有进入王座的资格。

    <color=yellow>3、王座争夺战<color>
    所有帮会将会在同一张地图上争夺王座，<color=yellow>占领王座需要读条<color>。王座地图内同样有四根龙柱资源供大家争夺。
]]
  elseif nIndex == 5 then
    szMsg = [[
    <color=green>如何获得个人积分？<color>
    1、击败敌对玩家可获得个人积分。
    2、每次占领龙柱会一次性获得一定数量的个人积分。
    3、守护在本帮已经夺取的龙柱周围、或者占领王座每隔一段时间也会获得一定的个人积分。

    <color=green>如何获得帮会积分？<color>
    每次占领龙柱或者王座，根据占领的时间，会增加帮会的帮会积分。

    <color=green>积分有何用途？<color>
    1、21:30跨服城战结束，届时<color=yellow>帮会积分最多<color>的帮会获得本次城战胜利，该帮帮会首领成为本周<color=yellow>铁浮城主<color>。
    2、依据个人积分以及帮会积分排名，<color=yellow>个人积分达到500<color>的玩家城战结束后会获得一定量的<color=yellow>铁浮城荣誉<color>。依据荣誉点数的多少，可在各服<color=yellow>铁浮城远征大将<color>处以<color=yellow>每个5万跨服绑银<color>的价格购买一定数量的<color=yellow>卓越战功箱<color>。
]]
  elseif nIndex == 6 then
    szMsg = [[
<color=green>【城主专属奖励】<color>
    称号：<color=yellow>铁浮城主·傲世凌天<color>
    购买以下物品的特权：<color=yellow>凌天披风、凌天神驹<color>

<color=green>【城主雕像】<color>
    跨服城战结束后，自动为城主在凤翔府竖立雄伟雕像。
    
<color=green>【城主勇士奖励】<color>
    称号：<color=gold>铁浮勇士·群雄逐日<color>
    购买以下物品的特权：<color=gold>逐日披风、逐日神驹<color>
    
<color=green>【辉煌战功箱】<color>
    辉煌战功箱（不绑定）由城主在我这里领取、购买，自行分配。
    打开辉煌战功箱有机会获得<color=yellow>1~3级同伴装备碎片<color>！
    
<color=green>【卓越战功箱】<color>
    依据铁浮城荣誉点，可在我这里购买卓越战功箱。
    打开卓越战功箱有机会获得<color=yellow>1~2级同伴装备碎片<color>、7级以上高级玄晶！
    
<color=green>【同伴装备】<color>
    打开战功箱有机会获得<color=yellow>同伴装备碎片<color>！集齐50个同种碎片，即可在我这里换取一件完整的同伴装备。
    
<color=green>【经验和威望】<color>
    个人积分大于500的侠士在城战结束后在我这里领取500万经验的奖励和50点威望奖励。
]]
  elseif nIndex == 7 then
    szMsg = [[
    <color=green>问：如何查看详细战况？<color>
    答：按<color=yellow> ~ <color>键。

    <color=green>问：为何我无法完成城主和侍卫任务？<color>
    答：完成任务需要缴纳一定物品。
    城主任务：<color=yellow>10和氏璧、299月影之石<color>
    侍卫任务：<color=yellow>3和氏璧、99月影之石<color>。
    
    <color=gold>更多问题请查阅F12帮助锦囊-详细帮助-跨服城战<color>
]]
  end

  Dialog:Say(szMsg, { "返回上一层", self.WarHelp, self })
end
