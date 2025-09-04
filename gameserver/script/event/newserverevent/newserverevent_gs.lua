-- 文件名　：newserverevent_gs.lua
-- 创建者　：zhangjunjie
-- 创建时间：2011-11-09 17:17:33
-- 描述：新服固定活动gs

if not MODULE_GAMESERVER then
  return
end

Require("\\script\\event\\newserverevent\\newserverevent_def.lua")

SpecialEvent.NewServerEvent = SpecialEvent.NewServerEvent or {}
local NewServerEvent = SpecialEvent.NewServerEvent

--活动是否在开启时间段
function NewServerEvent:IsEventOpen()
  local nHasOpenTime = TimeFrame:GetServerOpenDay()
  if nHasOpenTime > self.nEndDate then
    return 0
  end
  return 1
end

function NewServerEvent:OnNewEvent()
  local szMsg = "为了庆祝新服开启，开服前两周内我这有些活动你们可以参加哦！"
  local tbOpt = {}
  tbOpt[#tbOpt + 1] = { "家族活动相关", self.GetCallBossItem, self }
  tbOpt[#tbOpt + 1] = { "购买玫瑰花瓣", self.BuyRoseLeaves, self }
  tbOpt[#tbOpt + 1] = { "我再想想" }
  Dialog:Say(szMsg, tbOpt)
end

----------------------------家族活动------------------------
function NewServerEvent:StartAnnounceKinEvent()
  if self.nAnnounceKinEventTimer and self.nAnnounceKinEventTimer > 0 then
    Timer:Close(self.nAnnounceKinEventTimer)
    self.nAnnounceKinEventTimer = 0
  end
  self:AnnounceKinEvent(self.szAnnounceKinEvent)
  self.nAnnounceKinEventCount = 1 --活动开始后公告的次数
  self.nAnnounceKinEventTimer = Timer:Register(self.nAnnounceKinEventDelay, self.OnAnnounceKinEvent, self)
end

function NewServerEvent:OnAnnounceKinEvent()
  self.nAnnounceKinEventCount = self.nAnnounceKinEventCount + 1
  if self.nAnnounceKinEventCount >= self.nAnnounceKinEventMaxCount then
    self.nAnnounceKinEventCount = 0
    self.nAnnounceKinEventTimer = 0
    return 0
  else
    self:Announce(self.szAnnounceKinEvent)
    return self.nAnnounceKinEventDelay
  end
end

function NewServerEvent:AnnounceKinEvent(szMsg)
  if not szMsg or #szMsg <= 0 then
    return 0
  end
  KDialog.NewsMsg(0, Env.NEWSMSG_NORMAL, szMsg)
  KDialog.Msg2SubWorld(szMsg)
end

--上次获取召唤令时间
function NewServerEvent:SetLastGetItemTime_GS(nKinId)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  cKin.SetLastGetCallBossTime(GetTime())
end

--设置当天获得令牌的个数
function NewServerEvent:SetFreeCallBossItemCount_GS(nKinId, nCount)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  if not nCount then
    nCount = 0
  end
  cKin.SetFreeCallBossItemCount(nCount)
end

function NewServerEvent:SetBuyCallBossItemCount_GS(nKinId, nCount)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  if not nCount then
    nCount = 0
  end
  cKin.SetBuyCallBossItemCount(nCount)
end

--设置当天召唤boss的次数
function NewServerEvent:SetCallBossCount_GS(nKinId, nCount)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  if not nCount then
    nCount = 0
  end
  cKin.SetCallBossCount(nCount)
end

function NewServerEvent:CanBuyBossItem()
  if me.IsAccountLock() ~= 0 then
    Dialog:Say("你的账号处于锁定状态，无法进行该操作！")
    Account:OpenLockWindow(me)
    return
  end
  local nKinId, nMemberId = me.GetKinMember()
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    Dialog:Say("你没有家族，无法进行购买！")
    return 0
  end
  local nGetCount = cKin.GetBuyCallBossItemCount()
  if nGetCount >= self.nBuyBossMaxCount then
    Dialog:Say(string.format("你们家族当天购买的令牌数量已经达到上限，每个家族每天最多可购买<color=yellow>%s<color>个令牌", self.nBuyBossMaxCount))
    return 0
  end
  if me.nCoin < self.nCallBossNeedCoin then
    Dialog:Say("您的金币不足，无法进行购买。")
    return 0
  end
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("需要<color=yellow>1格<color>背包空间，整理下再来！")
    return 0
  end
  return 1
end

function NewServerEvent:IsHaveFigure()
  local nKinId, nMemberId = me.GetKinMember()
  local cKin = KKin.GetKin(nKinId)
  local nRet = Kin:CheckSelfRight(nKinId, nMemberId, 1) -- 只有族长才能购买
  if not cKin then
    Dialog:Say("你没有家族，无法进行令牌的领取或购买！")
    return 0
  end
  if nRet ~= 1 then
    Dialog:Say("你没有权限，请家族族长前来领取或者购买令牌！")
    return 0
  end
  return 1
end

function NewServerEvent:CanGetFreeItem()
  local nKinId, nMemberId = me.GetKinMember()
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    Dialog:Say("你没有家族，无法领取令牌！")
    return 0
  end
  local nGetCount = cKin.GetFreeCallBossItemCount()
  if nGetCount >= self.nFreeBossMaxCount then
    Dialog:Say(string.format("你们家族当天免费领取的令牌数量已经达到上限，每个家族每天最多可免费领取<color=yellow>%s<color>个牌子", self.nFreeBossMaxCount))
    return 0
  end
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("需要<color=yellow>1格<color>背包空间，整理下再来！")
    return 0
  end
  return 1
end

function NewServerEvent:GetCallBossItem()
  if 1 then
    Dialog:Say("请到家族领地找萧汜开启家族挑战！")
    return 0
  end

  if self:IsEventOpen() ~= 1 then
    Dialog:Say("该活动已经截止。")
    return 0
  end
  local nRet = self:IsHaveFigure()
  if nRet ~= 1 then
    return 0
  end
  local cKin = KKin.GetKin(me.dwKinId)
  local nLastGetTime = cKin.GetLastGetCallBossTime()
  local nTime = GetTime()
  if os.date("%Y%m%d", nLastGetTime) ~= os.date("%Y%m%d", nTime) then
    GCExcute({ "SpecialEvent.NewServerEvent:ClearCallBossData_GC", me.dwKinId }) --每日清空下
  end
  local szMsg = "    各大家族的族长每天可以免费领取4个令牌！"
  local tbOpt = {}
  tbOpt[#tbOpt + 1] = { "领取每天免费令牌", self.GetFreeCallBossItem, self }
  --tbOpt[#tbOpt + 1] = {"购买令牌",self.BuyCallBossItem,self};
  tbOpt[#tbOpt + 1] = { "我再想想" }
  Dialog:Say(szMsg, tbOpt)
  return 1
end

function NewServerEvent:GetFreeCallBossItem()
  local nRet = self:IsHaveFigure()
  if nRet ~= 1 then
    return 0
  end
  local nCanGet = self:CanGetFreeItem()
  if nCanGet ~= 1 then
    return 0
  end
  local pItem = me.AddItem(unpack(self.tbCallBossGDPL))
  if pItem then
    local cKin = KKin.GetKin(me.dwKinId)
    local nGetCount = cKin.GetFreeCallBossItemCount()
    pItem.SetGenInfo(1, 0) --标记是免费领取的
    GCExcute({ "SpecialEvent.NewServerEvent:SetFreeCallBossItemCount_GC", me.dwKinId, nGetCount + 1 })
  else
    Dbg:WriteLog("New Server Event", "Give Free Call Boss Item Failed", me.szName)
  end
end

function NewServerEvent:BuyCallBossItem()
  local nRet = self:IsHaveFigure()
  if nRet ~= 1 then
    return 0
  end
  local nCanBuy = self:CanBuyBossItem()
  if nCanBuy ~= 1 then
    return 0
  end
  local szMsg = string.format("每个家族每天可以购买<color=yellow>%s<color>个召唤令牌，您确定要以<color=yellow>%s<color>的价格购买召唤令牌么？", self.nBuyBossMaxCount, self.nCallBossNeedCoin)
  local tbOpt = {}
  tbOpt[#tbOpt + 1] = { "确定购买", self.SureBuy, self }
  tbOpt[#tbOpt + 1] = { "我再想想" }
  Dialog:Say(szMsg, tbOpt)
end

function NewServerEvent:SureBuy()
  local nRet = self:IsHaveFigure()
  if nRet ~= 1 then
    return 0
  end
  local nCanBuy = self:CanBuyBossItem()
  if nCanBuy ~= 1 then
    return 0
  end
  local bRet = me.ApplyAutoBuyAndUse(self.nCallBossWareId, 1, 1)
  if bRet == 1 then
    Dialog:Say("购买成功。")
    StatLog:WriteStatLog("stat_info", "kin_boss", "buy", me.nId, 1) --记录购买数据埋点
    return 1
  else
    Dialog:Say("购买失败。")
    Dbg:WriteLog("New Server Event", "Buy Call Boss Item Failed", me.szName)
    return 0
  end
end
-----------------------------------------------------------------------------

-------------------------献花活动--------------------------------------------
--买花
function NewServerEvent:BuyRoseLeaves()
  if self:IsEventOpen() ~= 1 then
    Dialog:Say("该活动已经截止。")
    return 0
  end
  local szMsg = string.format("    你可以花费<color=yellow>%s绑定银两<color>购买玫瑰花瓣，男性和女性都可以购买并且制作，如果女性玩家制作了，可以交易给男性玩家使用。男性玩家每天最多可以馈赠<color=yellow>%s<color>朵玫瑰，女性玩家每天最多可以接受<color=yellow>%s<color>朵玫瑰的馈赠。", self.nFlowerLeavesCost, self.nCanGiveFlowerMaxCount, self.nCanGetFlowerMaxCount)
  local tbOpt = {}
  tbOpt[#tbOpt + 1] = { "确定购买", self.SureBuyRoseLeaves, self }
  tbOpt[#tbOpt + 1] = { "我再想想" }
  Dialog:Say(szMsg, tbOpt)
end

function NewServerEvent:SureBuyRoseLeaves()
  local nRet, szError = self:CheckCanBuyRoseLeaves()
  if nRet ~= 1 then
    Dialog:Say(szError)
    return 0
  end
  if me.CostBindMoney(self.nFlowerLeavesCost) == 1 then
    local pItem = me.AddItem(unpack(self.tbFlowerLeavesGDPL))
    if not pItem then
      Dbg:WriteLog("New Server Event", "Give FlowerLeaves Failed", me.szName)
    end
  else
    Dbg:WriteLog("New Server Event", "Cost Bind Money Failed,Not Give FlowerLeaves", me.szName)
  end
end

function NewServerEvent:CheckCanBuyRoseLeaves()
  if me.nLevel < self.nCanGiveFlowerLevel then
    return 0, string.format("等级未达到<color=yellow>%s<color>级的玩家无法购买玫瑰花瓣！", self.nCanGiveFlowerLevel)
  end
  if me.GetBindMoney() < self.nFlowerLeavesCost then
    return 0, string.format("你身上的绑定银两不足<color=yellow>%s<color>，无法购买玫瑰花瓣！", self.nFlowerLeavesCost)
  end
  if me.CountFreeBagCell() < 1 then
    return 0, "请保证留出<color=yellow>1格<color>背包空间！"
  end
  return 1
end

---------------------------派利活动
function NewServerEvent:StartWelFare()
  if self:IsEventOpen() ~= 1 then
    return 0
  end
  self.tbWelFareCityMap = {}
  for nMapId, _ in pairs(self.tbWelFareAiPosInfo) do
    if IsMapLoaded(nMapId) == 1 then
      table.insert(self.tbWelFareCityMap, nMapId)
    end
  end
  if #self.tbWelFareCityMap > 0 then
    self:StartAddWelfareNpc()
  end
  if self.nAnnounceTimer and self.nAnnounceTimer > 0 then
    Timer:Close(self.nAnnounceTimer)
    self.nAnnounceTimer = 0
  end
  self:Announce(self.szAnnounceBegin)
  self.nAnnounceCount = 1 --活动开始后公告的次数
  self.nAnnounceTimer = Timer:Register(self.nWerFareAnnounceDelay, self.OnAnnounceWelFare, self)
end

function NewServerEvent:Announce(szMsg)
  if not szMsg or #szMsg <= 0 then
    return 0
  end
  KDialog.NewsMsg(0, Env.NEWSMSG_NORMAL, szMsg)
  KDialog.Msg2SubWorld(szMsg)
end

function NewServerEvent:OnAnnounceWelFare()
  self.nAnnounceCount = self.nAnnounceCount + 1
  if self.nAnnounceCount >= self.nWerFareAnnounceCount then
    self:Announce(self.szAnnounceEnd)
    self.nAnnounceCount = 0
    self.nAnnounceTimer = 0
    return 0
  else
    self:Announce(self.szAnnounceBegin)
    return self.nWerFareAnnounceDelay
  end
end

function NewServerEvent:StartAnnounceBefore()
  self:Announce(self.szAnnounceBefore)
  self.nAnnounceBeforeCount = 1 --活动开始后公告的次数
  if self.nAnnounceBeforeTimer and self.nAnnounceBeforeTimer > 0 then
    Timer:Close(self.nAnnounceBeforeTimer)
    self.nAnnounceBeforeTimer = 0
  end
  self.nAnnounceBeforeTimer = Timer:Register(self.nWelFareAnnounceBeforeDelay, self.OnAnnounceWelFareBefore, self)
end

function NewServerEvent:OnAnnounceWelFareBefore()
  self.nAnnounceBeforeCount = self.nAnnounceBeforeCount + 1
  if self.nAnnounceBeforeCount >= self.nWelFareAnnounceBeforeCount then
    self.nAnnounceBeforeCount = 0
    self.nAnnounceBeforeTimer = 0
    return 0
  else
    self:Announce(self.szAnnounceBefore)
    return self.nWelFareAnnounceBeforeDelay
  end
end

function NewServerEvent:StartAddWelfareNpc()
  if self:IsEventOpen() ~= 1 then
    return 0
  end
  if #self.tbWelFareCityMap <= 0 then
    return 0
  end
  self.tbGiveExpCount = {} --已经给过几次经验了
  self.tbGiveBoxCount = {} --已经给过多少次宝箱了
  self.tbWelFareNpcId = {} --记录年兽id
  local nTemplateId = self.nWelFareNpcTemplateId
  for _, nMapId in pairs(self.tbWelFareCityMap) do
    local tbAiPosInfo = self.tbWelFareAiPosInfo[nMapId]
    if not tbAiPosInfo then
      return 0
    end
    self.tbGiveExpCount[nMapId] = 0 --已经给过几次经验了
    self.tbGiveBoxCount[nMapId] = 0 --已经给过多少次宝箱了
    self.tbWelFareNpcId[nMapId] = 0 --记录年兽id
    local tbStartPos = tbAiPosInfo[1] --出生点就是ai点的第一个
    local pNpc = KNpc.Add2(nTemplateId, 50, -1, nMapId, tbStartPos[1] / 32, tbStartPos[2] / 32)
    if not pNpc then
      Dbg:WriteLog("New Server Event", "Add WelFare Npc Failed!", nMapId)
      return 0
    else
      self.tbWelFareNpcId[nMapId] = pNpc.dwId
      self:SetNpcBeginWelFare(pNpc.dwId, 1)
    end
  end
end

function NewServerEvent:SetNpcBeginWelFare(nId, nStartPos, nRestTime)
  local pNpc = KNpc.GetById(nId)
  if not pNpc then
    return 0
  end
  local tbAiPos = self.tbWelFareAiPosInfo[pNpc.nMapId]
  if not tbAiPos then
    return 0
  end
  pNpc.AI_ClearPath()
  local nOtherPos = MathRandom(nStartPos + math.floor(#tbAiPos / 6), nStartPos + math.floor(#tbAiPos / 2))
  if nOtherPos <= #tbAiPos - 1 then
    for i = nStartPos, nOtherPos do
      pNpc.AI_AddMovePos(tbAiPos[i][1], tbAiPos[i][2])
    end
  else
    for i = nStartPos, #tbAiPos - 1 do
      pNpc.AI_AddMovePos(tbAiPos[i][1], tbAiPos[i][2])
    end
    if nOtherPos > #tbAiPos then
      for j = 1, nOtherPos - #tbAiPos do
        pNpc.AI_AddMovePos(tbAiPos[j][1], tbAiPos[j][2])
      end
      nOtherPos = nOtherPos - #tbAiPos
    end
  end
  pNpc.SetActiveForever(1)
  pNpc.SetNpcAI(9, 0, 0, 0, 0, 0, 0, 0)
  pNpc.GetTempTable("Npc").tbOnArrive = { self.OnWelFareNpcArrive, self, pNpc.dwId, nOtherPos }
  pNpc.GetTempTable("Npc").nGiveExpTimer = Timer:Register(self.nWelFareGiveExpDelay, self.OnGiveExp, self, pNpc.dwId)
  pNpc.GetTempTable("Npc").nGiveBoxTimer = Timer:Register(self.nWelFareAddBoxDelay, self.OnGiveBox, self, pNpc.dwId)
  pNpc.GetTempTable("Npc").nWelFareExistTimer = Timer:Register((nRestTime or self.nWelFareDelay), self.OnWelFareEnd, self, pNpc.dwId, pNpc.nMapId)
end

function NewServerEvent:OnWelFareNpcArrive(nId, nOtherPos)
  local pNpc = KNpc.GetById(nId)
  if not pNpc then
    return 0
  end
  local nMapId, nX, nY = pNpc.GetWorldPos()
  local nEndTimerId = pNpc.GetTempTable("Npc").nWelFareExistTimer
  if not nEndTimerId then
    return 0
  end
  local nRestTime = Timer:GetRestTime(nEndTimerId)
  Timer:Close(nEndTimerId)
  pNpc.Delete()
  local pNpcEx = KNpc.Add2(self.nWelFareNpcDialogTemplateId, 50, -1, nMapId, nX, nY)
  if pNpcEx then
    Timer:Register(self.nDialogNpcTime, self.DeletDialog, self, pNpcEx.dwId, nOtherPos, nRestTime)
    pNpcEx.GetTempTable("Npc").nGiveExpTimer = Timer:Register(self.nWelFareGiveExpDelay, self.OnGiveExp, self, pNpcEx.dwId)
    pNpcEx.GetTempTable("Npc").nGiveBoxTimer = Timer:Register(self.nWelFareAddBoxDelay, self.OnGiveBox, self, pNpcEx.dwId)
  end
end

function NewServerEvent:DeletDialog(nId, nOtherPos, nRestTime)
  local pNpc = KNpc.GetById(nId)
  if not pNpc then
    return 0
  end
  local nMapId, nX, nY = pNpc.GetWorldPos()
  pNpc.Delete()
  if nRestTime <= self.nDialogNpcTime then
    return 0
  end
  local pNpcEx = KNpc.Add2(self.nWelFareNpcTemplateId, 50, -1, nMapId, nX, nY)
  if pNpcEx then
    self.tbWelFareNpcId[nMapId] = pNpc.dwId
    self:SetNpcBeginWelFare(pNpcEx.dwId, nOtherPos, nRestTime - self.nDialogNpcTime)
  end
  return 0
end

--给经验
function NewServerEvent:OnGiveExp(nId)
  local pNpc = KNpc.GetById(nId)
  if not pNpc then
    return 0
  end
  local tbPlayer, nCount = KNpc.GetAroundPlayerList(nId, self.nWelFareGetPrizeRange)
  if nCount > 0 then
    for _, pPlayer in pairs(tbPlayer) do
      if pPlayer and pPlayer.nTeamId > 0 then
        local nAddExp = pPlayer.GetBaseAwardExp() * self.nWelFareGiveExpRate
        local nAddExpPer = nAddExp / self.nWelFareGiveExpCount
        pPlayer.AddExp(nAddExpPer)
      end
    end
  end
  self.tbGiveExpCount[pNpc.nMapId] = self.tbGiveExpCount[pNpc.nMapId] + 1
  if self.tbGiveExpCount[pNpc.nMapId] >= self.nWelFareGiveExpCount then
    self.tbGiveExpCount[pNpc.nMapId] = 0 --给经验次数清零
    return 0
  else
    return self.nWelFareGiveExpDelay
  end
end

--给箱子
function NewServerEvent:OnGiveBox(nId)
  local pNpc = KNpc.GetById(nId)
  if not pNpc then
    return 0
  end
  local tbGetBoxList = self:GetCanGetBoxPlayerList(nId)
  if #tbGetBoxList > 0 then
    for _, pPlayer in pairs(tbGetBoxList) do
      if pPlayer then
        local pItem = pPlayer.AddItem(unpack(self.nWelFareBoxGDPL))
        if pItem then --成功了记变量
          local nGetCount = pPlayer.GetTask(self.nTaskId, self.nWelFareGetBoxCountGroupId)
          local szMsg = string.format("恭喜你获得了小龙女赐予的宝箱")
          Dialog:SendBlackBoardMsg(pPlayer, szMsg)
          pPlayer.SetTask(self.nTaskId, self.nWelFareGetBoxCountGroupId, nGetCount + 1)
          SpecialEvent.tbGoldBar:AddTask(pPlayer, 8) --金牌联赛福禄神兽迎新派利
        else
          Dbg:WriteLog("New Server Event", "Give Welfare Box Failed", pPlayer.szName)
        end
      end
    end
  end
  self.tbGiveBoxCount[pNpc.nMapId] = self.tbGiveBoxCount[pNpc.nMapId] + 1
  local _, x, y = pNpc.GetWorldPos()
  pNpc.CastSkill(self.nWelSkillId, 1, x * 32, y * 32, 1) --放一个特效
  if self.tbGiveBoxCount[pNpc.nMapId] >= self.nWelFareGiveBoxCount then
    self.tbGiveBoxCount[pNpc.nMapId] = 0 --给箱子次数清零
    return 0
  else
    return self.nWelFareAddBoxDelay
  end
end

--获取获得箱子的玩家列表
function NewServerEvent:GetCanGetBoxPlayerList(nId)
  local tbCanGetBoxPlayerList = {} --可以获得宝箱的玩家列表
  local pNpc = KNpc.GetById(nId)
  if not pNpc then
    return tbCanGetBoxPlayerList
  end
  local tbPlayer, nCount = KNpc.GetAroundPlayerList(nId, self.nWelFareGetPrizeRange)
  if nCount <= 0 then
    return tbCanGetBoxPlayerList
  end
  local tbReachConditionPlayer = {} --符合条件的玩家
  for nIndex, pPlayer in pairs(tbPlayer) do
    if pPlayer then
      local nLastGetTime = pPlayer.GetTask(self.nTaskId, self.nWelFareGetBoxTimeGroupId)
      if os.date("%Y%m%d", GetTime()) ~= os.date("%Y%m%d", nLastGetTime) then --隔天清零
        pPlayer.SetTask(self.nTaskId, self.nWelFareGetBoxTimeGroupId, GetTime())
        pPlayer.SetTask(self.nTaskId, self.nWelFareGetBoxCountGroupId, 0)
      end
      local nGetCount = pPlayer.GetTask(self.nTaskId, self.nWelFareGetBoxCountGroupId)
      local nFreeCell = pPlayer.CountFreeBagCell()
      local nLevel = pPlayer.nLevel
      local nFaction = pPlayer.nFaction
      if nFreeCell >= self.nWelFareNeedCell and nGetCount < self.nWelFareGetBoxMaxCount and nLevel >= self.nWelFareBaseLevel and nFaction > 0 and pPlayer.nTeamId > 0 then --补充组队的玩家才能获得
        table.insert(tbReachConditionPlayer, pPlayer) --将符合条件的玩家先加进去
      end
    end
  end
  if #tbReachConditionPlayer <= self.nWelFareGetBoxPlayerCount then --如果符合条件的玩家小于一次选择数量，这些玩家都可以获得
    return tbReachConditionPlayer
  end
  for i = 1, self.nWelFareGetBoxPlayerCount do
    local nPos = MathRandom(#tbReachConditionPlayer)
    local pPlayer = tbReachConditionPlayer[nPos]
    if pPlayer then
      table.insert(tbCanGetBoxPlayerList, pPlayer)
    end
    table.remove(tbReachConditionPlayer, nPos)
  end
  return tbCanGetBoxPlayerList
end

--派利结束
function NewServerEvent:OnWelFareEnd(nId, nMapId)
  local pNpc = KNpc.GetById(nId)
  self.tbWelFareNpcId[nMapId] = 0
  if pNpc then
    pNpc.Delete()
  end
  return 0
end
