-- 幸运大转盘
-- 2012/12/6 10:57:16
-- zhouchenfei

-- 玩家点开始后，就已经决定了是什么
-- 根据玩家的结果，随机出图案，记录到图案表里
-- 当玩家点完5次后

Require("\\script\\event\\jieri\\201212_xmas\\xmaxlottery\\xmaxlottery_def.lua")

SpecialEvent.XmasLottery2012 = SpecialEvent.XmasLottery2012 or {}
local XmasLottery2012 = SpecialEvent.XmasLottery2012

XmasLottery2012.tbRandomTable = {
  [1] = { 0, 0, 0, 500, 1500, 8000 },
  [2] = { 0, 0, 500, 1000, 2500, 6000 },
  [3] = { 0, 1000, 1000, 2000, 2000, 4000 },
  [4] = { 0, 2000, 2500, 3500, 2000, 0 },
  [5] = { 500, 4000, 4000, 1500, 0, 0 },
  [6] = { 2000, 5500, 2500, 0, 0, 0 },
}

XmasLottery2012.tbAwardResultSequence = {
  [1] = 5,
  [2] = 4,
  [3] = 3,
  [4] = 2,
  [5] = 1,
  [6] = 0,
}

XmasLottery2012.tbAwardCoin = {
  [1] = 100,
  [2] = 300,
  [3] = 700,
  [4] = 1300,
  [5] = 2300,
}

XmasLottery2012.tbWaZiRandom = { 2000, 4000, 5000, 6000, 7000, 9000 }

XmasLottery2012.nMaxRandomNum = 10000

XmasLottery2012.nRandom_BindCoinAward = 2000

XmasLottery2012.tbBuyRingCoin = {
  [1] = { 635, 10, "1个圣诞铃铛（10金/个）" },
  [2] = { 636, 500, "1个圣诞铃铛·箱（500金/箱）" },
}

function XmasLottery2012:IsMapOk(nMapId)
  local szMapClass = GetMapType(nMapId) or ""
  if szMapClass == "village" then
    return 1
  end
  if szMapClass == "city" then
    return 1
  end
  return 0
end

function XmasLottery2012:IsCanDoLucky(pPlayer)
  if not pPlayer then
    return 0, "玩家不存在"
  end

  if self:IsGameOpen() ~= 1 then
    return 0, "不在活动期间，不能开始游戏！"
  end

  if self:IsMapOk(pPlayer.nMapId) ~= 1 then
    return 0, "只能在城市或者新手村游戏！"
  end

  if pPlayer.nLevel < self.MIN_JOIN_LEVEL then
    return 0, string.format("您的等级不足%s级，不能参加幸运翻！", self.MIN_JOIN_LEVEL)
  end

  local nIsDuringOnDoLucky = self:IsDuringOnDoLucky(pPlayer)
  if nIsDuringOnDoLucky ~= self.DEF_STEP_GET_CARD then
    return 0, "不在这一局游戏中，无法翻牌！"
  end

  local nRound = self:GetPlayerCurRound(pPlayer)
  if nRound >= self.LOTTERY_MAX_ROUND then
    return 0, "您已经完成了5轮点击，去领奖励或者重新开一局吧！"
  end

  return 1
end

-- 获取序列结果
function XmasLottery2012:GetRandomResult(nRound)
  local tbRandomList = self.tbRandomTable[nRound]
  if not tbRandomList then
    return 0
  end

  local nRandom = MathRandom(self.nMaxRandomNum)
  local nAddRandom = 0
  for nIndex, nOneRandom in pairs(tbRandomList) do
    nAddRandom = nAddRandom + nOneRandom
    if nRandom <= nAddRandom then
      return nIndex
    end
  end
  return 0
end

-- 获取小序列
function XmasLottery2012:GetRandomSmallSequ(nResult)
  if not nResult then
    return nil
  end

  local tbSequ = {}
  local tbSmallCount = {}

  for i = 1, self.LOTTERY_MAX_ROUND do
    local nRandom = 1
    if i > (self.LOTTERY_MAX_ROUND - nResult + 1) then
      nRandom = MathRandom(2, self.LOTTERY_ITEM_NUM)
    end
    tbSequ[#tbSequ + 1] = nRandom
    if not tbSmallCount[nRandom] then
      tbSmallCount[nRandom] = 0
    end
    tbSmallCount[nRandom] = tbSmallCount[nRandom] + 1
  end
  Lib:SmashTable(tbSequ)
  return tbSequ, tbSmallCount
end

function XmasLottery2012:GetOneRandomItem(tbBigRandom)
  local nRandom = MathRandom(self.nMaxRandomNum)
  local nRet = 6
  local nTotalRandom = 0
  for i, nRand in pairs(tbBigRandom) do
    nTotalRandom = nTotalRandom + nRand
    if nRandom <= nTotalRandom then
      return i
    end
  end
  return nRet
end

-- 获取随机序列，这个是点开始后给玩家看的
function XmasLottery2012:GetRandomBigSequ(nResult, nRound)
  local tbSmallSequ, tbBigSeqNumList = self:GetRandomSmallSequ(nResult)
  if not tbSmallSequ then
    return nil
  end

  local tbBigRandom = {}
  tbBigRandom[1] = self.tbWaZiRandom[nRound] or 0
  for i = 2, self.LOTTERY_ITEM_NUM do
    tbBigRandom[i] = math.floor((10000 - tbBigRandom[1]) / 5)
  end

  for i = 1, self.LOTTERY_MAX_BIG_SEQU - self.LOTTERY_MAX_ROUND do
    local nRandom = self:GetOneRandomItem(tbBigRandom)
    if not tbBigSeqNumList[nRandom] then
      tbBigSeqNumList[nRandom] = 0
    end
    tbBigSeqNumList[nRandom] = tbBigSeqNumList[nRandom] + 1
  end
  return tbSmallSequ, tbBigSeqNumList
end

-- 获取结果序列，这个是结果序列
function XmasLottery2012:GetResultBigSequ(tbSmallResult, tbBigSeqNumList)
  if not tbSmallResult or not tbBigSeqNumList then
    return nil
  end

  local tbRandomResultSeq = {}
  local tbRandomBigSequ = {}

  for _, tbInfo in pairs(tbSmallResult) do
    tbBigSeqNumList[tbInfo[1]] = tbBigSeqNumList[tbInfo[1]] - 1
  end

  for nRandomIndex, nCount in pairs(tbBigSeqNumList) do
    if nCount > 0 then
      for i = 1, nCount do
        tbRandomBigSequ[#tbRandomBigSequ + 1] = nRandomIndex
      end
    end
  end

  Lib:SmashTable(tbRandomBigSequ)

  for _, tbInfo in pairs(tbSmallResult) do
    tbRandomResultSeq[tbInfo[2]] = tbInfo[1]
  end

  local nLen = #tbRandomBigSequ
  local nIndex = 1
  local nSquIndex = 1
  local nErrorCount = 0

  while 1 do
    if nIndex > self.LOTTERY_MAX_BIG_SEQU or nSquIndex > nLen then
      break
    end

    if nErrorCount > 1000 then
      return nil
    end

    if tbRandomBigSequ[nSquIndex] > 0 then
      if not tbRandomResultSeq[nIndex] then
        tbRandomResultSeq[nIndex] = tbRandomBigSequ[nSquIndex]
        nSquIndex = nSquIndex + 1
      end
      nIndex = nIndex + 1
    else
      nSquIndex = nSquIndex + 1
    end
    nErrorCount = nErrorCount + 1
  end
  return tbRandomResultSeq
end

function XmasLottery2012:SetNumListTask(pPlayer, tbCount, nTaskId)
  if not pPlayer or not tbCount or not nTaskId or nTaskId <= 0 then
    return 0
  end
  local nSaveNum = 0
  for nIndex, nCount in pairs(tbCount) do
    local nBegin = (nIndex - 1) * 5
    nSaveNum = Lib:SetBits(nSaveNum, nCount, nBegin, nBegin + 4)
  end
  pPlayer.SetTask(self.TASK_GROUP_ID, nTaskId, nSaveNum)
  return 1
end

function XmasLottery2012:SaveBigNumList(pPlayer, tbBigNumList)
  if not pPlayer then
    return 0
  end
  return self:SetNumListTask(pPlayer, tbBigNumList, self.TASKID_SAVE_BIG_RANDOMNUM)
end

function XmasLottery2012:SetOneTempItemIndex(pPlayer, nPos, nItemIndex)
  if not pPlayer or not nItemIndex or not nPos then
    return 0
  end
  local nBegin = (nPos - 1) * 5
  local nSaveNum = pPlayer.GetTask(self.TASK_GROUP_ID, self.TASKID_RANDOM_RESULT)
  nSaveNum = Lib:SetBits(nSaveNum, nItemIndex, nBegin, nBegin + 4)
  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASKID_RANDOM_RESULT, nSaveNum)
  return 1
end

function XmasLottery2012:GetOneTempItemIndex(pPlayer, nPos)
  if not pPlayer or not nPos then
    return nil
  end
  local nBegin = (nPos - 1) * 5
  local nSaveNum = pPlayer.GetTask(self.TASK_GROUP_ID, self.TASKID_RANDOM_RESULT)
  local nItemIndex = Lib:LoadBits(nSaveNum, nBegin, nBegin + 4)
  return nItemIndex
end

function XmasLottery2012:SetPlayerLuckyLotteryOneResult(pPlayer, nRound, nPos, nRandomItem)
  if not pPlayer or not nPos or not nRandomItem or not nRound or nRound <= 0 then
    return 0
  end
  local nBegin = math.fmod((nRound - 1), 2) * 16
  local nTaskId = self.TASKID_AWARD_RESULT_SYNC_1 + math.floor((nRound - 1) / 2)
  local nSaveNum = me.GetTask(self.TASK_GROUP_ID, nTaskId)
  local nSaveValue = nPos * 100 + nRandomItem
  nSaveNum = Lib:SetBits(nSaveNum, nSaveValue, nBegin, nBegin + 15)
  me.SetTask(self.TASK_GROUP_ID, nTaskId, nSaveNum)
  return 1
end

function XmasLottery2012:SetPlayerCurRound(pPlayer, nRound)
  if not pPlayer then
    return nil
  end

  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASKID_LOTTERY_ROUND, nRound)
  return 1
end

function XmasLottery2012:SaveBigSeqResult(pPlayer, tbBigResult)
  if not pPlayer or not tbBigResult or #tbBigResult <= 0 then
    return 0
  end

  local tbTaskToValue = {}
  for i = self.TASKID_SQU_LOTTERY_POS_1, self.TASKID_SQU_LOTTERY_POS_3 do
    tbTaskToValue[i] = 0
  end

  for nIndex, nItemIndex in pairs(tbBigResult) do
    local nTaskId = math.floor((nIndex - 1) / 10) + self.TASKID_SQU_LOTTERY_POS_1
    local nBegin = math.fmod((nIndex - 1), 10) * 3
    local nSaveNum = tbTaskToValue[nTaskId]
    nSaveNum = Lib:SetBits(nSaveNum, nItemIndex, nBegin, nBegin + 2)
    tbTaskToValue[nTaskId] = nSaveNum
  end

  for nTaskId, nValue in pairs(tbTaskToValue) do
    pPlayer.SetTask(self.TASK_GROUP_ID, nTaskId, nValue)
  end
  return 1
end

function XmasLottery2012:SetPlayerAwardType(pPlayer, nType)
  if not pPlayer then
    return 0
  end
  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASKID_AWARD_FINISH, nType)
  return 1
end

function XmasLottery2012:FinishOneLottery(pPlayer)
  if not pPlayer then
    return 0
  end
  local tbSmallResult = self:GetResultCardSmallSeq(pPlayer)
  local tbBigNumList = self:LoadBigNumList(pPlayer)
  local tbBigResult = self:GetResultBigSequ(tbSmallResult, tbBigNumList)
  self:SaveBigSeqResult(pPlayer, tbBigResult)
  local nType = pPlayer.GetTask(self.TASK_GROUP_ID, self.TASKID_AWARD_TYPE)
  self:SetPlayerAwardType(pPlayer, nType)
  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASKID_GAME_STEP, self.DEF_STEP_NOGAME)
  StatLog:WriteStatLog("stat_info", "shengdanjie_2012", "card_finish", pPlayer.nId, nType)
end

function XmasLottery2012:SetPlayerTodayGameCount(pPlayer, nCount)
  if not pPlayer then
    return 0
  end
  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASKID_DALIY_TOTAL_ROUND, nCount)
end

function XmasLottery2012:IsCanStartGame(pPlayer)
  if not pPlayer then
    return 0, "玩家不存在"
  end

  if self:IsGameOpen() ~= 1 then
    return 0, "不在活动期间，不能开始游戏！"
  end

  if pPlayer.nLevel < self.MIN_JOIN_LEVEL then
    return 0, string.format("您的等级不足%s级，不能参加幸运翻！", self.MIN_JOIN_LEVEL)
  end

  if pPlayer.nFaction <= 0 then
    return 0, "您尚未加入门派，请入门派后再来！"
  end

  if self:IsMapOk(pPlayer.nMapId) ~= 1 then
    return 0, "只能在城市或者新手村游戏！"
  end

  local nIsDuringOnDoLucky = self:IsDuringOnDoLucky(pPlayer)
  if nIsDuringOnDoLucky ~= self.DEF_STEP_NOGAME then
    return 0, "上一局游戏未结束无法开启！"
  end

  local nAwardType = self:GetPlayerAwardType(pPlayer)
  if nAwardType > 0 then
    return 0, "您还有奖励未领取，请先领取奖励！"
  end

  local nCount = self:GetPlayerTodayGameCount(pPlayer)
  if nCount >= self.LOTTERY_MAX_DALIY_COUNT then
    return 0, "今天次数已经用完，请明天再来吧！"
  end
  return 1
end

function XmasLottery2012:ResetGameTaskValue(pPlayer)
  if not pPlayer then
    return 0
  end
  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASKID_RANDOM_RESULT, 0)
  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASKID_AWARD_TYPE, 0)
  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASKID_AWARD_FINISH, 0)
  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASKID_SAVE_BIG_RANDOMNUM, 0)
  for i = self.TASKID_SQU_LOTTERY_POS_1, self.TASKID_SQU_LOTTERY_POS_3 do
    pPlayer.SetTask(self.TASK_GROUP_ID, i, 0)
  end

  for i = self.TASKID_AWARD_RESULT_SYNC_1, self.TASKID_AWARD_RESULT_SYNC_3 do
    pPlayer.SetTask(self.TASK_GROUP_ID, i, 0)
  end
end

function XmasLottery2012:OnSureStartGame(nPlayerId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return
  end
  local nFlag, szMsg = self:IsCanStartGame(pPlayer)
  if 0 == nFlag then
    pPlayer.Msg(szMsg)
    return 0
  end

  local nDaliyRound = self:GetPlayerTodayGameCount(pPlayer)
  local nNeedItemCount = self.tbRoundNeedItemNum[nDaliyRound + 1]
  local nHaveCount = pPlayer.GetItemCountInBags(unpack(self.tbGameJoinItem))
  if nHaveCount < nNeedItemCount then
    local szMsg = string.format("您背包中的圣诞铃铛不足%s个，无法开始！", nNeedItemCount)
    Dialog:SendBlackBoardMsg(pPlayer, szMsg)
    pPlayer.Msg(szMsg)
    return 0
  end

  local nRet = pPlayer.ConsumeItemInBags2(nNeedItemCount, unpack(self.tbGameJoinItem))
  if nRet ~= 0 then
    Dbg:WriteLog("XmasLottery2012  扣除圣诞铃铛物品失败", pPlayer.szName)
    return
  end

  StatLog:WriteStatLog("stat_info", "shengdanjie_2012", "card_tool", pPlayer.nId, nNeedItemCount)

  self:ResetGameTaskValue(pPlayer)

  local nResultType = self:GetRandomResult(nDaliyRound + 1)

  if nResultType <= 0 then
    Dbg:WriteLog("XmasLottery2012 随机结果失败", pPlayer.szName)
    assert(nResultType > 0)
    return
  end

  self:SetPlayerTodayGameCount(pPlayer, nDaliyRound + 1)
  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASKID_GAME_STEP, self.DEF_STEP_GET_CARD) -- 开启游戏
  self:SetPlayerCurRound(pPlayer, 0) -- 将一局轮数设置0

  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASKID_AWARD_TYPE, nResultType)

  local tbSmallSeq, tbBigNumList = self:GetRandomBigSequ(nResultType, nDaliyRound + 1)

  -- 保存随机结果
  for i, nItemIndex in pairs(tbSmallSeq) do
    self:SetOneTempItemIndex(pPlayer, i, nItemIndex)
  end

  -- 保存最后大盘随机结果
  self:SaveBigNumList(pPlayer, tbBigNumList)

  local tbRandomBigSequ = {}
  for nRandomIndex, nCount in pairs(tbBigNumList) do
    if nCount > 0 then
      for i = 1, nCount do
        tbRandomBigSequ[#tbRandomBigSequ + 1] = nRandomIndex
      end
    end
  end

  Lib:SmashTable(tbRandomBigSequ)
  self:SaveBigSeqResult(pPlayer, tbRandomBigSequ)

  me.CallClientScript({ "Ui:ServerCall", "UI_LUCKYFAN", "StartGame" })
end

--------------------------------------------------------
-- 开始游戏入口，包括扣圣诞铃铛开始
--------------------------------------------------------
function XmasLottery2012:ApplyStartLuckyGame()
  local nFlag, szMsg = self:IsCanStartGame(me)
  if 0 == nFlag then
    Dialog:Say(szMsg)
    return 0
  end

  local nDaliyRound = self:GetPlayerTodayGameCount(me)
  local nNeedItemCount = self.tbRoundNeedItemNum[nDaliyRound + 1]
  local nHaveCount = me.GetItemCountInBags(unpack(self.tbGameJoinItem))
  if nHaveCount < nNeedItemCount then
    local szMsg = string.format("本轮需要<color=pink>%s个圣诞铃铛<color>方能开启，是否要直接购买圣诞铃铛？", nNeedItemCount)
    Dialog:Say(szMsg, {
      { "购买圣诞铃铛（10金币/个）", self.BuyMaxRing, self, 1 },
      { "购买铃铛·箱（500金币/箱）", self.BuyMaxRing, self, 2 },
      { "我再考虑考虑" },
    })
    return 0
  end

  local szMsg = string.format("本轮是第<color=yellow>%s<color>轮，需要消耗<color=yellow>%s个圣诞铃铛<color>，你确定从你背包中扣除<color=yellow>%s个圣诞铃铛<color>吗？", nDaliyRound + 1, nNeedItemCount, nNeedItemCount)
  Dialog:Say(szMsg, {
    { "确定开始", self.OnSureStartGame, self, me.nId },
    { "我再考虑考虑" },
  })
end

function XmasLottery2012:BuyMaxRing(nIndex)
  local nBuyRingCoin = self.tbBuyRingCoin[nIndex][2]
  if me.nCoin < nBuyRingCoin then
    Dialog:Say(string.format("您的金币不足%s个！", nBuyRingCoin), { { "我知道啦" } })
    return
  end
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("背包空间不足1格。", { { "我知道啦" } })
    return
  end

  Dialog:Say(string.format("你确定购买<color=yellow>%s<color>吗？", self.tbBuyRingCoin[nIndex][3]), {
    { "确定购买", self.OnSureBuyItem, self, me.szName, nIndex },
    { "在考虑考虑" },
  })
end

function XmasLottery2012:OnSureBuyItem(szPlayerName, nIndex)
  if szPlayerName ~= me.szName then
    Dialog:Say("购买异常！")
    return 0
  end
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("背包空间不足1格。", { { "我知道啦" } })
    return
  end

  local nBuyRingCoin = self.tbBuyRingCoin[nIndex][2]
  if me.nCoin < nBuyRingCoin then
    Dialog:Say(string.format("您的金币不足%s个！", nBuyRingCoin), { { "我知道啦" } })
    return
  end
  StatLog:WriteStatLog("stat_info", "shengdanjie_2012", "tool_buy", me.nId, string.format("%s,%s", self.tbBuyRingCoin[nIndex][1], 1))
  me.ApplyAutoBuyAndUse(self.tbBuyRingCoin[nIndex][1], 1, 0)
end

--------------------------------------------------------
-- 点击一次卡牌，获取一个结果
--------------------------------------------------------
function XmasLottery2012:ApplyGetOneLuckyItem(nPos)
  local nIsCanDoLucky, szMsg = self:IsCanDoLucky(me)
  if 0 == nIsCanDoLucky then
    Dialog:Say(szMsg)
    return 0
  end

  local nRound = self:GetPlayerCurRound(me) + 1
  local nRandomItem = self:GetOneTempItemIndex(me, nRound)
  if not nRandomItem or nRandomItem <= 0 then
    print("XmasLottery2012", "ApplyGetOneLuckyItem random fail ", me.szName, nRound)
    assert(false)
    return 0
  end
  self:SetPlayerLuckyLotteryOneResult(me, nRound, nPos, nRandomItem)

  self:SetPlayerCurRound(me, nRound)
  if nRound >= self.LOTTERY_MAX_ROUND then
    self:FinishOneLottery(me)
  end

  me.CallClientScript({ "Ui:ServerCall", "UI_LUCKYFAN", "UpdatePanel" })
  return 1
end

--------------------------------------------------------
-- 点击一次卡牌，获取一个结果
--------------------------------------------------------
function XmasLottery2012:ApplyGetLuckyGameAward()
  local nIsCanGetAward, szMsg = self:IsCanGetAward(me)
  if nIsCanGetAward == 0 then
    Dialog:Say(szMsg)
    return 0
  end

  local nAwardType = self:GetPlayerAwardType(me)
  local tbAward = self.tbAwardItemList[nAwardType]

  if not tbAward then
    Dialog:Say("奖励异常")
    return 0
  end

  self:SetPlayerAwardType(me, 0)

  local pItem = me.AddItem(unpack(tbAward))
  if not pItem then
    return 0
  end
  pItem.Bind(1)
  pItem.SetTimeOut(0, GetTime() + 30 * 3600 * 24)
  pItem.Sync()

  local nRound = self:GetPlayerTodayGameCount(me)
  pItem.SetGenInfo(1, nRound)
  Dbg:WriteLog("XmasLottery2012", "ApplyGetLuckyGameAward", me.szName, "AddItem", pItem.szName)
  me.CallClientScript({ "Ui:ServerCall", "UI_LUCKYFAN", "UpdatePanel" })
  StatLog:WriteStatLog("stat_info", "shengdanjie_2012", "card_getbox", me.nId, nAwardType)
  return 1
end

function XmasLottery2012:IsCanGetAward(pPlayer)
  if not pPlayer then
    return 0, "玩家异常"
  end

  if self:IsGameOpen() ~= 1 then
    return 0, "不在活动期间，不能领奖。"
  end

  local nAwardFlag = self:GetPlayerAwardType(pPlayer)
  if nAwardFlag <= 0 then
    return 0, "您没有奖励可以领取！"
  end

  if self:IsMapOk(pPlayer.nMapId) ~= 1 then
    return 0, "只有在城市、门派或者新手村才能领取奖励！"
  end

  if pPlayer.CountFreeBagCell() < 1 then
    return 0, "您的背包空间不足1格，请整理背包！"
  end

  return 1
end

function XmasLottery2012:ApplyLuckyFan_ActiveGameStep()
  local nCurStep = self:GetLuckyFanOneRoundStep(me)
  if self.DEF_STEP_NOGAME == nCurStep then
    local nAwardFinish = self:GetPlayerAwardType(me)
    if nAwardFinish > 0 then
      self:ApplyGetLuckyGameAward()
      return 0
    end
    self:ApplyStartLuckyGame()
    --	elseif (self.DEF_STEP_SHOW_BEGIN_CARD == nCurStep) then
    --		me.SetTask(self.TASK_GROUP_ID, self.TASKID_GAME_STEP, self.DEF_STEP_GET_CARD);
    --		me.CallClientScript({"Ui:ServerCall", "UI_LUCKYFAN", "UpdatePanel"});
  end
end

function XmasLottery2012:ApplyLuckyFan_GetOneResultCard(nPos)
  self:ApplyGetOneLuckyItem(nPos)
end

function XmasLottery2012:OnDaliyEvent_PlayerLuckyFanEvent()
  self:SetPlayerTodayGameCount(me, 0)
end

PlayerSchemeEvent:RegisterGlobalDailyEvent({ XmasLottery2012.OnDaliyEvent_PlayerLuckyFanEvent, XmasLottery2012 })
