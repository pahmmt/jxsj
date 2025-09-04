-- 文件名　：chaotingyushi.lua
-- 创建者　：furuilei
-- 创建时间：2009-06-16 09:50:36

Require("\\script\\domainbattle\\task\\domaintask_def.lua")

local tbChaoTingYuShi = Npc:GetClass("chaotingyushi")
--=======================================================================
tbChaoTingYuShi.tbFollowInsertItem = { 18, 1, 379, 1 }
tbChaoTingYuShi.tbBuChangItem = { 18, 1, 205, 1 } -- 补偿奖励的物品
tbChaoTingYuShi.BUCHANG_ITEM_HUMSHI_COUNT = 4 -- 补偿物品奖励魂石个数

tbChaoTingYuShi.TASK_GROUP = 2097
tbChaoTingYuShi.TASK_ID_COUNT = 10 -- 玩家缴纳的霸主之印数量

tbChaoTingYuShi.TASK_ID_FLAG_GET_BUCHANG_STATUARY = Domain.DomainTask.TASK_ID_FLAG_GET_BUCHANG_STATUARY -- 玩家获得雕像补偿的时间

tbChaoTingYuShi.tbAward = {
  -- 需要缴纳的霸主之印数量	物品名称		物品ID
  { nCount = 500, szName = "十级玄晶（绑定）", tbItem = { 18, 1, 114, 10 } },
  { nCount = 140, szName = "九级玄晶（绑定）", tbItem = { 18, 1, 114, 9 } },
  { nCount = 40, szName = "八级玄晶（绑定）", tbItem = { 18, 1, 114, 8 } },
  { nCount = 10, szName = "七级玄晶（绑定）", tbItem = { 18, 1, 114, 7 } },
  { nCount = 3, szName = "六级玄晶（绑定）", tbItem = { 18, 1, 114, 6 } },
}
--=======================================================================
tbChaoTingYuShi.nCount = {}

tbChaoTingYuShi.BUCHANG_STATUARY_BAZHUZHIYIN_COUNT = Domain.DomainTask.BUCHANG_STATUARY_BAZHUZHIYIN_COUNT

function tbChaoTingYuShi:OnDialog()
  local tbOpt = {
    { "缴纳霸主之印", self.TakeInItem, self },
    { "查看排名", self.GetAwardInfo, self },
    { "领取奖励", self.GetAward, self },
    { "树立雕像", self.BuildStatuary, self, me.szName },
    { "领取崇敬度奖励", self.GiveRevereAward, self, me.szName },
  }
  local szMsg = "我正在收集散落在我大宋国疆土上的霸主之印。\n如果有你有幸得到的话，可以交予我，我会向圣上禀明你的功劳，给予你一定的赏赐，收集的数量越多，奖励也越多。\n圣上已颁下圣旨：“诸位英豪以搜集最多霸主之印者为最优，不仅可上殿听封，还可立其雕像，彰其功德。”"
  local nState = Domain.DomainTask:CheckState()
  if 2 == nState then
    if Domain.DomainTask:CheckBuChangState() == 1 then
      table.insert(tbOpt, { "领取霸主之印补偿", self.OnGiveBuChangJiangli, self, me.szName })
    end

    local tbTemp = { "前往观礼", me.NewWorld, 1541, 1579, 3260 }
    table.insert(tbOpt, 2, tbTemp)
    szMsg = "皇上在朝圣阁举行授予仪式表彰贤良，想要观礼的请上殿。"
  end
  table.insert(tbOpt, { "只是看看" })
  Dialog:Say(szMsg, tbOpt)
end

function tbChaoTingYuShi:TakeInItem()
  local tbOpt = {
    { "我要缴纳", self.SureTakeInItem, self },
    { "只是看看" },
  }
  local szMsg = "听说你已经收集到不少霸主之印了。\n你确定要交给我吗？"
  Dialog:Say(szMsg, tbOpt)
end

-- 放入物品
function tbChaoTingYuShi:SureTakeInItem()
  local nState = Domain.DomainTask:CheckState()
  if 0 == nState then
    Dialog:Say("活动还没有开放，不能缴纳霸主之印。")
    return
  end
  if 2 == nState then
    Dialog:Say("活动已经结束，不能缴纳霸主之印。")
    return
  end
  if 1 ~= nState then
    return
  end
  Dialog:OpenGift("我要缴纳", nil, { self.OnOpenGiftOk, self })
end

-- 获取奖励
function tbChaoTingYuShi:GetAward()
  local szMsg, tbAward = self:GetAwardMsg(me)
  local tbOpt = {
    { "我要领奖", self.SureGetAward, self, tbAward },
    { "我再想想" },
  }
  Dialog:Say(szMsg, tbOpt)
end

-- 计算玩家能够领取的奖励
function tbChaoTingYuShi:CalcAward(nSum)
  if nSum < 0 then
    return
  end
  local tbAwardCount = {}
  local nLevelCount = 0
  for i, v in ipairs(self.tbAward) do
    if nSum == 0 or v.nCount == 0 then
      break
    end
    nLevelCount = math.floor(nSum / v.nCount)
    nSum = nSum % v.nCount
    if not tbAwardCount[i] then
      tbAwardCount[i] = {}
    end
    tbAwardCount[i].nCount = nLevelCount
    tbAwardCount[i].szName = v.szName
    tbAwardCount[i].tbItem = v.tbItem
  end
  return tbAwardCount
end

function tbChaoTingYuShi:SureGetAward(tbAward)
  local nState = Domain.DomainTask:CheckState()
  if 0 == nState then
    Dialog:Say("活动还没有开始，没有奖励发放给你。")
    return
  end
  if 1 == nState then
    Dialog:Say("活动还没有结束，等活动结束之后再来领取奖励吧。")
    return
  end
  if 2 ~= nState then
    return
  end
  local nSum = 0
  for i, v in ipairs(tbAward) do
    nSum = nSum + v.nCount
  end
  if me.CountFreeBagCell() < nSum then
    Dialog:Say(string.format("您的背包空间不够，需要<color=yellow>%s<color>格背包空间", nSum))
    return
  end
  for i, v in ipairs(tbAward) do
    for i = 1, v.nCount do
      me.AddItemEx(v.tbItem[1], v.tbItem[2], v.tbItem[3], v.tbItem[4], nil, Player.emKITEMLOG_TYPE_BAZHUZHIYIN_AWARD)
    end
    Item:CheckXJRecord(Item.emITEM_XJRECORD_EVENT, "霸主之印收集奖励", { v.tbItem[1], v.tbItem[2], v.tbItem[3], v.tbItem[4], 0, v.nCount })
  end

  Dbg:WriteLogEx(Dbg.LOG_INFO, "Domain", "chaotingyushi", string.format("%s缴纳了%s霸主之印，领取奖励", me.szName, me.GetTask(self.TASK_GROUP, self.TASK_ID_COUNT)))
  me.SetTask(self.TASK_GROUP, self.TASK_ID_COUNT, 0)
  PlayerHonor:SetPlayerHonorByName(me.szName, PlayerHonor.HONOR_CLASS_KAIMENTASK, 0, 0)
end

-- 使用排行榜提供的接口来显示玩家排名
function tbChaoTingYuShi:GetAwardInfo()
  local nState = Domain.DomainTask:CheckState()
  if 2 == nState then
    Dialog:Say("活动已经结束，现在不提供排名查询功能。")
    return
  end
  local nPlayerRank = PlayerHonor:GetPlayerHonorRankByName(me.szName, PlayerHonor.HONOR_CLASS_KAIMENTASK, 0)
  local nPlayerCount = me.GetTask(self.TASK_GROUP, self.TASK_ID_COUNT)
  local nTongId = me.dwTongId
  if nTongId <= 0 then
    Dialog:Say("您当前没有所属帮会，不能缴纳霸主之印和查看排名。")
    return
  end
  local cTong = KTong.GetTong(nTongId)
  if not cTong then
    return
  end
  local szMsg = ""
  if nPlayerRank > 0 then
    szMsg = string.format("您目前已经缴纳了霸主之印<color=yellow>%s<color>个，当前排第<color=yellow>%s<color>名。", nPlayerCount, nPlayerRank)
  else
    szMsg = string.format("您目前已经缴纳了霸主之印<color=yellow>%s<color>个，但是因为数量不足或者排行榜没有更新而没有进入排行榜，要继续努力啊。", nPlayerCount)
  end
  local nTongCount = cTong.GetDomainBaZhu()
  szMsg = szMsg .. string.format("您当前所属帮会已经缴纳霸主之印<color=yellow>%s<color>个。", nTongCount)
  Dialog:Say(szMsg)
end

function tbChaoTingYuShi:Init()
  if not self.nCount then
    self.nCount = {}
  end
  self.nCount[me.nId] = 0
end

-- 点击确认按钮
function tbChaoTingYuShi:OnOpenGiftOk(tbItemObj)
  self:Init()
  local bForbidItem = 0
  for _, pItem in pairs(tbItemObj) do
    if self:ChechItem(pItem) == 0 then
      bForbidItem = 1
    end
  end
  if bForbidItem == 1 then
    me.Msg("存在不符合的物品!")
    return 0
  end
  local nTongId = me.dwTongId
  if nTongId <= 0 then
    Dialog:Say("你没有所属帮会，不能缴纳霸主之印。")
    return 0
  end
  local cTong = KTong.GetTong(nTongId)
  if not cTong then
    return 0
  end
  for _, pItem in pairs(tbItemObj) do
    if me.DelItem(pItem[1], Player.emKLOSEITEM_BAZHUZHIYIN_TAKEIN) ~= 1 then
      return 0
    end
  end
  self:UpdateCount()

  return 1
end

-- 检测物品是否符合条件
function tbChaoTingYuShi:ChechItem(pItem)
  local bForbidItem = 1
  local szFollowItem = string.format("%s,%s,%s,%s", unpack(self.tbFollowInsertItem))
  local szItem = string.format("%s,%s,%s,%s", pItem[1].nGenre, pItem[1].nDetail, pItem[1].nParticular, pItem[1].nLevel)

  if szFollowItem ~= szItem then
    bForbidItem = 0
  end
  if not self.nCount[me.nId] then
    self.nCount[me.nId] = pItem[1].nCount
  else
    self.nCount[me.nId] = self.nCount[me.nId] + pItem[1].nCount
  end
  return bForbidItem
end

-- 检查玩家是否是缴纳霸主之印最多的玩家
function tbChaoTingYuShi:IsFirst(pPlayer)
  local bFirst = 0
  --	local szName = KGblTask.SCGetDbTaskStr(DBTASK_BAZHUZHIYIN_MAX);
  local nFlag = Domain.tbStatuary:CheckStatuaryState(pPlayer.szName, Domain.tbStatuary.TYPE_EVENT_NORMAL)
  if 1 == nFlag then
    bFirst = 1
  end
  return bFirst
end

-- 更新玩家和帮会缴纳的霸主之印的数量
function tbChaoTingYuShi:UpdateCount()
  local nTongId = me.dwTongId
  if nTongId <= 0 then
    return 0
  end
  local cTong = KTong.GetTong(nTongId)
  if not cTong then
    return 0
  end
  if not self.nCount[me.nId] or self.nCount[me.nId] <= 0 then
    return 0
  end
  local nCurCount = me.GetTask(self.TASK_GROUP, self.TASK_ID_COUNT)
  return GCExcute({ "Domain:UpdateBaZhuZhiYin_GC", me.szName, nTongId, nCurCount, self.nCount[me.nId] })
end

-- 获取玩家的奖励情况
function tbChaoTingYuShi:GetAwardMsg(pPlayer)
  if not pPlayer then
    return
  end
  local nPlayerCount = pPlayer.GetTask(self.TASK_GROUP, self.TASK_ID_COUNT)
  local tbAward = self:CalcAward(nPlayerCount)
  if not tbAward then
    return
  end
  local szMsg = string.format("您目前已经缴纳霸主之印<color=yellow>%s<color>个，可以领取如下奖励\n", nPlayerCount)
  for i, v in ipairs(tbAward) do
    if v.nCount > 0 then
      szMsg = szMsg .. string.format("<color=yellow>%s    %s个<color>\n", v.szName, v.nCount)
    end
  end
  szMsg = szMsg .. "<color=red>注意：玩家奖励需要在活动结束之后才能领取。<color>"
  return szMsg, tbAward
end

function tbChaoTingYuShi:GiveRevereAward(szName)
  local tbOpt = {
    { "我确定要领取", self.SureGiveRevereAward, self, szName },
    { "我再想想" },
  }
  local nRevere = Domain.tbStatuary:GetRevere(szName, Domain.tbStatuary.TYPE_EVENT_NORMAL)
  local szMsg = string.format("你现在的崇敬度是<color=yellow>%d<color>，确定要领取崇敬度奖励吗？", nRevere)
  Dialog:Say(szMsg, tbOpt)
end

-- get horse
function tbChaoTingYuShi:SureGiveRevereAward(szName)
  -- todo: bag space check
  --	local nFlag = Domain.tbStatuary:CheckStatuaryState(szName, Domain.tbStatuary.TYPE_EVENT_NORMAL);
  --	if (nFlag ~= 2) then
  --		Dialog:Say("你当前还没有树立雕像，无法领取奖励。");
  --		return;
  --	end

  local nRevere = Domain.tbStatuary:GetRevere(szName, Domain.tbStatuary.TYPE_EVENT_NORMAL)
  if nRevere < 1500 then
    Dialog:Say("你当前雕像累计的崇敬度不够<color=yellow>1500<color>点，不能领取到奖励。")
    return
  end

  if me.CountFreeBagCell() < 1 then
    Dialog:Say("您的背包空间不够，需要1格背包空间。")
    return
  end

  Dbg:WriteLogEx(Dbg.LOG_INFO, "Domain", "chaotingyushi", string.format("Award %s a horse", me.szName))

  Domain.tbStatuary:DecreaseRevere(szName, Domain.tbStatuary.TYPE_EVENT_NORMAL, 1500)
  local pItem = me.AddItem(1, 12, 12, 4)
  if not pItem then
    Dbg:WriteLogEx(Dbg.LOG_INFO, "Domain", "chaotingyushi", string.format("Add %s a horse item failed", me.szName))
  end
  local a, b = pItem.GetTimeOut()
  pItem.Bind(1) -- 强制绑定
  if b == 0 then
    me.SetItemTimeout(pItem, os.date("%Y/%m/%d/%H/%M/00", GetTime() + 3600 * 24 * 30))
    pItem.Sync()
  end
  local szMsg = "在雕像树立的这段时间内，你的成就得到了广大民众的认可，累计突破了1500点崇敬度。通过了圣上对你的考验。" .. "特此，授予你120级的特殊坐骑，并扣除你1500点崇敬度。" .. "之后，只要你的崇敬度继续累积到1500点，仍然可以来我处领取120级的特殊坐骑。"
  Dialog:Say(szMsg, { "关闭" })
end

-- 树立雕像
function tbChaoTingYuShi:BuildStatuary(szName)
  if not szName or me.szName ~= szName then
    return
  end
  local nState = Domain.DomainTask:CheckState()
  if 0 == nState then
    Dialog:Say("活动还没有开始，不能树立雕像。")
  end
  if 1 == nState then
    Dialog:Say("活动还没有结束，不能树立雕像。")
  end
  if 2 ~= nState then
    return
  end
  local nFlag = Domain.tbStatuary:CheckStatuaryState(me.szName, Domain.tbStatuary.TYPE_EVENT_NORMAL)
  local szMsg = ""
  if 0 == nFlag then
    szMsg = "你当前的成就不符合树立雕像的权力。\n只有收集霸主之印最多的角色，才有资格树立雕像。"
    Dialog:Say(szMsg)
    return
  elseif nFlag == 2 then
    Dialog:Say("你已经树立雕像，不能再树立了。")
    return
  elseif nFlag == 1 then
    local bFinishTask = me.GetTask(1024, 62)
    if 1 ~= bFinishTask then
      Dialog:Say("你需要完成<color=yellow>英雄授予<color>仪式才能树立雕像。\n<color=red>从礼部侍郎处前往观礼，在朝圣阁与礼部尚书对话可进行英雄授予仪式。<color>")
      return
    end
    szMsg = string.format("圣上已颁下圣旨：“诸位英豪以搜集最多霸主之印者为最优，不仅可上殿听封，还可立其雕像，彰其功德。”\n你在霸主之战活动中，为圣上搜集了最多的霸主之印。获得了树立雕像的资格。\
    \n树立雕像，需要花费<color=yellow>10000<color>个五行魂石的成本。\
    \n雕像被树立后，会收到民众的膜拜或唾弃。被膜拜后，会增加雕像的崇敬度。\
    如果雕像的崇敬度累计达到<color=yellow>1500<color>点，表示你的成就已得到广大民众普遍的认可，那么你就可以来我这里领取最终的奖励：由皇上钦赐的<color=yellow>120级特殊坐骑<color>。")
  elseif nFlag == 3 then
    Dialog:Say("雕像位置不足，无法树立雕像！")
    return
  end

  Dialog:Say(szMsg, {
    { "我要树立自己的雕像", self.SureBuildStatuary, self },
    { "我再想想" },
  })
end

function tbChaoTingYuShi:SureBuildStatuary()
  -- 获取玩家的主修门派
  local nFaction = Faction:GetGerneFactionInfo(me)[1]
  if not nFaction then
    nFaction = me.nFaction
  end

  if Player.FACTION_NONE == nFaction then
    Dialog:Say("你还没有加入门派，不能树立雕像。")
    return
  end
  if Player.FACTION_NUM < nFaction then
    return
  end
  local nStoneCount = me.GetItemCountInBags(18, 1, 205, 1)
  if nStoneCount < 10000 then
    Dialog:Say("树立雕像所需的五行魂石不足！")
    return
  end
  self:WriteLog("BuildStatuary", string.format("%s use series stone %d success!", me.szName, 10000))
  local nResult = Domain.tbStatuary:AddStatuary(me.szName, Domain.tbStatuary.TYPE_EVENT_NORMAL, nFaction, me.nSex)
  if 0 == nResult then
    self:WriteLog("BuildStatuary", string.format("%s BuildStatuary Failed!", me.szName))
    return
  end
  if 1 == me.ConsumeItemInBags2(10000, 18, 1, 205, 1) then
    self:WriteLog("BuildStatuary", string.format("%s use series stone %d failed!", me.szName, 10000))
    return
  end
end

function tbChaoTingYuShi:WriteLog(...)
  if MODULE_GAMESERVER then
    Dbg:WriteLogEx(Dbg.LOG_INFO, "Domain", "tbChaoTingYuShi", unpack(arg))
  end
end

-- 用于补偿霸主之印活动结束后剩余未交的霸主之印
function tbChaoTingYuShi:OnGiveBuChangJiangli(szPlayerName)
  if not szPlayerName then
    return 0
  end

  local nState, szMsg = Domain.DomainTask:CheckBuChangState()
  if 0 == nState then
    Dialog:Say(szMsg)
    return 0
  end

  self.CONTEXT_CHANGE_HUNSHI = "1个霸主之印可以换取4个绑定魂石"
  Dialog:OpenGift(self.CONTEXT_CHANGE_HUNSHI, nil, { self.OnBuChangOpenGiftOk, self })
end

function tbChaoTingYuShi:OnBuChangOpenGiftOk(tbItemObj)
  local bForbidItem = 0
  local nBaZhuCount = 0
  local szFollowItem = string.format("%s,%s,%s,%s", unpack(self.tbFollowInsertItem))

  for _, pItem in pairs(tbItemObj) do
    local szItem = string.format("%s,%s,%s,%s", pItem[1].nGenre, pItem[1].nDetail, pItem[1].nParticular, pItem[1].nLevel)
    if szFollowItem ~= szItem then
      bForbidItem = 1
      break
    end
    nBaZhuCount = nBaZhuCount + pItem[1].nCount
  end
  if bForbidItem == 1 then
    me.Msg("存在不符合的物品!")
    return 0
  end
  local nTongId = me.dwTongId
  if nBaZhuCount <= 0 then
    Dialog:Say("没有提交霸主之印。")
    return 0
  end

  local nFreeCount = me.CountFreeBagCell()
  local nHunshi = nBaZhuCount * self.BUCHANG_ITEM_HUMSHI_COUNT
  local nHunFree = math.ceil(nHunshi / 5000)
  if nHunFree <= 0 then
    Dialog:Say("没有霸主之印可以兑换！")
    return 0
  end

  if nHunFree > nFreeCount then
    Dialog:Say(string.format("您的背包空间不足，您需要%s个空间格子。", nHunFree))
    return 0
  end

  if 1 == me.ConsumeItemInBags2(nBaZhuCount, unpack(self.tbFollowInsertItem)) then
    self:WriteLog("OnBuChangOpenGiftOk", me.szName, "give bazhuzhiyin failed!")
    return 0
  end
  local nGetNum = me.AddStackItem(self.tbBuChangItem[1], self.tbBuChangItem[2], self.tbBuChangItem[3], self.tbBuChangItem[4], { bForceBind = 1 }, nHunshi)
  self:WriteLog("OnBuChangOpenGiftOk", me.szName .. ",应该获得魂石数量：", nHunshi, "实际获得魂石数量：", nGetNum)

  return 1
end
