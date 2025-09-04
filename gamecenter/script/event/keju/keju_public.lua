-- 文件名　：keju_public.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-10-24 15:22:59
-- 功能说明：剑侠世界科举考试

if MODULE_GAMECLIENT then
  return
end

Require("\\script\\event\\keju\\keju_def.lua")

SpecialEvent.JxsjKeju = SpecialEvent.JxsjKeju or {}
local JxsjKeju = SpecialEvent.JxsjKeju

function JxsjKeju:SaveBuffer()
  SetGblIntBuf(DBTASK_JXSJ_KEJU_WEEKGRADE, 0, 1, self.tbJxsjKejuGrade)
end

--周成绩单
function JxsjKeju:LoadBuffer()
  local tbBuffer = GetGblIntBuf(DBTASK_JXSJ_KEJU_WEEKGRADE, 0)
  if tbBuffer and type(tbBuffer) == "table" then
    self.tbJxsjKejuGrade = tbBuffer
    self.tbJxsjKejuGrade[1] = self.tbJxsjKejuGrade[1] or {}
    self.tbJxsjKejuGrade[2] = self.tbJxsjKejuGrade[2] or {}
  end
end

--题库
function JxsjKeju:LoadQuestion()
  local tbFile = Lib:LoadTabFile(self.szQuesetionFilePath)
  if not tbFile then
    print("【科举考试】读取文件错误，文件不存在", self.szQuesetionFilePath)
    return
  end

  local nDeviation = 56 --改动题目规则时，题目回滚了56题，所以这里需要做下偏移处理
  local tbTypeAllNum = { 0, 0 }

  for nId, tbParam in ipairs(tbFile) do
    if nId > 1 then
      local nType = tonumber(tbParam.Type) or 0
      if tbTypeAllNum[nType] then
        tbTypeAllNum[nType] = tbTypeAllNum[nType] + 1
      end
    end
  end

  local tbOldQuestion = {}
  local tbOtherQuesiton = {}
  tbOldQuestion[1] = {}
  tbOldQuestion[2] = {}
  tbOldQuestion[3] = {}
  tbOldQuestion[4] = {}
  local nNum = KGblTask.SCGetDbTaskInt(DBTASK_JXSJ_KEJU_WEEKGRADE)
  --开始的题目数
  local nStartNum = math.fmod(self.nWeekQuestionCount * nNum + 1 + nDeviation, tbTypeAllNum[1])
  nStartNum = math.fmod(nStartNum, tbTypeAllNum[1])
  if nStartNum == 0 then
    nStartNum = tbTypeAllNum[1]
  end
  --一个月内每个周的结束题目数
  local tbEndNum = {
    self.nWeekQuestionCount * (nNum + 1) + nDeviation,
    self.nWeekQuestionCount * (nNum + 2) + nDeviation,
    self.nWeekQuestionCount * (nNum + 3) + nDeviation,
    self.nWeekQuestionCount * (nNum + 4) + nDeviation,
  }

  for i = 1, 4 do
    tbEndNum[i] = math.fmod(tbEndNum[i], tbTypeAllNum[1])
    if tbEndNum[i] == 0 then
      tbEndNum[i] = tbTypeAllNum[1]
    end
  end

  local tbType2Dis = {
    self.tbQuestionCountPre[1] * nNum + 1,
    self.tbQuestionCountPre[1] * (nNum + 1),
    self.tbQuestionCountPre[1] * (nNum + 2),
    self.tbQuestionCountPre[1] * (nNum + 3),
    self.tbQuestionCountPre[1] * (nNum + 4),
  }

  for i = 1, 5 do
    tbType2Dis[i] = math.fmod(tbType2Dis[i], tbTypeAllNum[2])
    if tbType2Dis[i] == 0 then
      tbType2Dis[i] = tbTypeAllNum[2]
    end
  end
  local nXSQuestionIndex = 1
  local nDSQuestionIndex = 1
  for nId, tbParam in ipairs(tbFile) do
    if nId > 1 then
      local nType = tonumber(tbParam.Type) or 0
      local szAnswerId = tbParam.AnswerId or ""
      local szQuestionType = tbParam.QuestionType or ""
      local szQuestion = tbParam.Question or ""
      local szChoice_1 = tbParam.Choice_1 or ""
      local szChoice_2 = tbParam.Choice_2 or ""
      local szChoice_3 = tbParam.Choice_3 or ""
      local szChoice_4 = tbParam.Choice_4 or ""
      local nAnswerId = self:GetAnswerId(szAnswerId)
      szQuestionType = TOOLS_DecryptBase64(szQuestionType)
      szQuestion = TOOLS_DecryptBase64(szQuestion)
      szChoice_1 = TOOLS_DecryptBase64(szChoice_1)
      szChoice_2 = TOOLS_DecryptBase64(szChoice_2)
      szChoice_3 = TOOLS_DecryptBase64(szChoice_3)
      szChoice_4 = TOOLS_DecryptBase64(szChoice_4)
      if nAnswerId > 0 and nAnswerId <= 4 and szQuestionType ~= "" and szQuestion ~= "" and szChoice_1 ~= "" then
        if nType == 1 then
          self.tbQuestion[1][nNum] = self.tbQuestion[1][nNum] or {}
          self.tbQuestion[1][nNum + 1] = self.tbQuestion[1][nNum + 1] or {}
          self.tbQuestion[1][nNum + 2] = self.tbQuestion[1][nNum + 2] or {}
          self.tbQuestion[1][nNum + 3] = self.tbQuestion[1][nNum + 3] or {}
          if (nStartNum <= tbEndNum[1] and nXSQuestionIndex >= nStartNum and nXSQuestionIndex <= tbEndNum[1]) or (nStartNum > tbEndNum[1] and ((nXSQuestionIndex >= nStartNum and nXSQuestionIndex <= tbTypeAllNum[1]) or (nXSQuestionIndex <= tbEndNum[1]))) then
            table.insert(self.tbQuestion[1][nNum], { szQuestionType, nAnswerId, szQuestion, szChoice_1, szChoice_2, szChoice_3, szChoice_4 })
          elseif (tbEndNum[1] <= tbEndNum[2] and nXSQuestionIndex > tbEndNum[1] and nXSQuestionIndex <= tbEndNum[2]) or (tbEndNum[1] > tbEndNum[2] and ((nXSQuestionIndex > tbEndNum[1] and nXSQuestionIndex <= tbTypeAllNum[1]) or (nXSQuestionIndex <= tbEndNum[2]))) then
            table.insert(self.tbQuestion[1][nNum + 1], { szQuestionType, nAnswerId, szQuestion, szChoice_1, szChoice_2, szChoice_3, szChoice_4 })
          elseif (tbEndNum[2] <= tbEndNum[3] and nXSQuestionIndex > tbEndNum[2] and nXSQuestionIndex <= tbEndNum[3]) or (tbEndNum[2] > tbEndNum[3] and ((nXSQuestionIndex > tbEndNum[2] and nXSQuestionIndex <= tbTypeAllNum[1]) or (nXSQuestionIndex <= tbEndNum[3]))) then
            table.insert(self.tbQuestion[1][nNum + 2], { szQuestionType, nAnswerId, szQuestion, szChoice_1, szChoice_2, szChoice_3, szChoice_4 })
          elseif (tbEndNum[3] <= tbEndNum[4] and nXSQuestionIndex > tbEndNum[3] and nXSQuestionIndex <= tbEndNum[4]) or (tbEndNum[3] > tbEndNum[4] and ((nXSQuestionIndex > tbEndNum[3] and nXSQuestionIndex <= tbTypeAllNum[1]) or (nXSQuestionIndex <= tbEndNum[4]))) then
            table.insert(self.tbQuestion[1][nNum + 3], { szQuestionType, nAnswerId, szQuestion, szChoice_1, szChoice_2, szChoice_3, szChoice_4 })
          elseif nXSQuestionIndex < nStartNum then
            table.insert(tbOldQuestion[1], { szQuestionType, nAnswerId, szQuestion, szChoice_1, szChoice_2, szChoice_3, szChoice_4 })
          else
            table.insert(tbOtherQuesiton, { szQuestionType, nAnswerId, szQuestion, szChoice_1, szChoice_2, szChoice_3, szChoice_4 })
          end
          nXSQuestionIndex = nXSQuestionIndex + 1
        elseif nType == 2 then
          self.tbQuestion[2][nNum] = self.tbQuestion[2][nNum] or {}
          self.tbQuestion[2][nNum + 1] = self.tbQuestion[2][nNum + 1] or {}
          self.tbQuestion[2][nNum + 2] = self.tbQuestion[2][nNum + 2] or {}
          self.tbQuestion[2][nNum + 3] = self.tbQuestion[2][nNum + 3] or {}
          if (tbType2Dis[1] <= tbType2Dis[2] and nDSQuestionIndex >= tbType2Dis[1] and nDSQuestionIndex <= tbType2Dis[2]) or (tbType2Dis[1] > tbType2Dis[2] and ((nDSQuestionIndex >= tbType2Dis[1] and nDSQuestionIndex <= tbTypeAllNum[2]) or (nDSQuestionIndex <= tbType2Dis[2]))) then
            table.insert(self.tbQuestion[2][nNum], { szQuestionType, nAnswerId, szQuestion, szChoice_1, szChoice_2, szChoice_3, szChoice_4 })
          elseif (tbType2Dis[2] <= tbType2Dis[3] and nDSQuestionIndex > tbType2Dis[2] and nDSQuestionIndex <= tbType2Dis[3]) or (tbType2Dis[2] > tbType2Dis[3] and ((nDSQuestionIndex > tbType2Dis[2] and nDSQuestionIndex <= tbTypeAllNum[2]) or (nDSQuestionIndex <= tbType2Dis[3]))) then
            table.insert(self.tbQuestion[2][nNum + 1], { szQuestionType, nAnswerId, szQuestion, szChoice_1, szChoice_2, szChoice_3, szChoice_4 })
          elseif (tbType2Dis[3] <= tbType2Dis[4] and nDSQuestionIndex > tbType2Dis[3] and nDSQuestionIndex <= tbType2Dis[4]) or (tbType2Dis[3] > tbType2Dis[4] and ((nDSQuestionIndex > tbType2Dis[3] and nDSQuestionIndex <= tbTypeAllNum[2]) or (nDSQuestionIndex <= tbType2Dis[4]))) then
            table.insert(self.tbQuestion[2][nNum + 2], { szQuestionType, nAnswerId, szQuestion, szChoice_1, szChoice_2, szChoice_3, szChoice_4 })
          elseif (tbType2Dis[4] <= tbType2Dis[5] and nDSQuestionIndex > tbType2Dis[4] and nDSQuestionIndex <= tbType2Dis[5]) or (tbType2Dis[4] > tbType2Dis[5] and ((nDSQuestionIndex > tbType2Dis[4] and nDSQuestionIndex <= tbTypeAllNum[2]) or (nDSQuestionIndex <= tbType2Dis[5]))) then
            table.insert(self.tbQuestion[2][nNum + 3], { szQuestionType, nAnswerId, szQuestion, szChoice_1, szChoice_2, szChoice_3, szChoice_4 })
          end
          nDSQuestionIndex = nDSQuestionIndex + 1
        end
      end
    end
  end
  --再生成旧题的题库（每天的题目都是6*12，计算）
  if #tbOldQuestion[1] < self.nFirstAddNum * 3 * 2 * 5 then
    for i = 1, self.nFirstAddNum * 3 * 2 * 5 do
      table.insert(tbOldQuestion[1], tbOtherQuesiton[#tbOtherQuesiton + i - self.nFirstAddNum * 3 * 2 * 5])
    end
  end
  Lib:SmashTable(tbOldQuestion[1])
  Lib:MergeTable(tbOldQuestion[2], tbOldQuestion[1])
  Lib:MergeTable(tbOldQuestion[2], self.tbQuestion[1][nNum])
  Lib:SmashTable(tbOldQuestion[2])
  Lib:MergeTable(tbOldQuestion[3], tbOldQuestion[2])
  Lib:MergeTable(tbOldQuestion[3], self.tbQuestion[1][nNum + 1])
  Lib:SmashTable(tbOldQuestion[3])
  Lib:MergeTable(tbOldQuestion[4], tbOldQuestion[3])
  Lib:MergeTable(tbOldQuestion[4], self.tbQuestion[1][nNum + 2])
  Lib:SmashTable(tbOldQuestion[4])

  self.tbOldQuestion[nNum] = self.tbOldQuestion[nNum] or {}
  self.tbOldQuestion[nNum + 1] = self.tbOldQuestion[nNum + 1] or {}
  self.tbOldQuestion[nNum + 2] = self.tbOldQuestion[nNum + 2] or {}
  self.tbOldQuestion[nNum + 3] = self.tbOldQuestion[nNum + 3] or {}

  for i = 1, 4 do
    for j = 1, self.nFirstAddNum * 3 * 2 * 5 do --每次播3轮，每天2次，每周5天
      local nIndex = math.fmod(j, #tbOldQuestion[i])
      if nIndex == 0 then
        nIndex = #tbOldQuestion[i]
      end
      table.insert(self.tbOldQuestion[nNum + i - 1], { unpack(tbOldQuestion[i][nIndex]) })
    end
  end
end

function JxsjKeju:GetAnswerId(szAnswerId)
  szAnswerId = TOOLS_DecryptBase64(szAnswerId)
  return tonumber(string.sub(szAnswerId, 13, string.len(szAnswerId))) or 0
end

function JxsjKeju:CheckIsOpenUi(pPlayer)
  return pPlayer.GetTask(self.nTaskGroup, self.nOpenUiFalg)
end

--检查是不是在考官跟前
function JxsjKeju:CheckIsNear(pPlayer)
  local nMapId, nXPos, nYPos = pPlayer.GetWorldPos()
  local tbNpcPos = self.tbKaoguanPoint[self.nQuestionType]
  if not tbNpcPos then
    return 0
  end
  for _, tbPos in ipairs(tbNpcPos) do
    if nMapId == tbPos[1] and (nXPos - tbPos[2]) * (nXPos - tbPos[2]) + (nYPos - tbPos[3]) * (nYPos - tbPos[3]) <= 1000 then
      return 1
    end
  end
  return 0
end

--检查是不是已经答完题了
function JxsjKeju:CheckIsOver(pPlayer)
  local nGradePre = pPlayer.GetTask(self.nTaskGroup, self.nGradePre)
  local nDatePre = pPlayer.GetTask(self.nTaskGroup, self.nGradeDate)
  local nDateNow = tonumber(GetLocalDate("%Y%m%d"))
  if nDatePre ~= nDateNow then
    nGradePre = 0
  end
  local nAllCount = math.floor(nGradePre / 10000)
  local bQuestionIsRight = 0
  local bIsFirstAnswer = 0
  Setting:SetGlobalObj(pPlayer)
  bQuestionIsRight = self:CheckQuestionIsRight()
  bIsFirstAnswer = self:CheckIsFirstAnswer()
  Setting:RestoreGlobalObj()
  if nAllCount > self.tbQuestionCountPre[self.nQuestionType] or (nAllCount == self.tbQuestionCountPre[self.nQuestionType] and (bQuestionIsRight == 0 or bIsFirstAnswer == 0)) then
    return 1
  end
  return 0
end

--检查答题流水号和问答流水号是否是当前题目
function JxsjKeju:CheckQuestionIsRight()
  local nNowDate = tonumber(GetLocalDate("%m%d%H"))
  --询问的题目跟当前题目是否一致
  local nAskJourFlag = me.GetTask(self.nTaskGroup, self.nAskJourNum)
  local nAskDate = math.floor(nAskJourFlag / 1000)
  local nAskJourNum = math.fmod(nAskJourFlag, 1000)
  if nAskJourNum ~= self.nJourNum or nAskDate ~= nNowDate then
    return 0
  end
  return 1
end

function JxsjKeju:CheckIsFirstAnswer()
  --回答题目是否是本题第一次
  local nAnswerJourFlag = me.GetTask(self.nTaskGroup, self.nAnswerJourNum)
  local nAnswerJourNum = math.floor(nAnswerJourFlag / 100)
  if nAnswerJourNum == self.nJourNum then
    return 0
  end
  return 1
end

--检查活动是否开始nType 1表示从准备时间算起，2表示从正式开启算起
function JxsjKeju:CheckIsOpen(nType)
  local nTime = tonumber(GetLocalDate("%H%M"))
  local nWeek = tonumber(GetLocalDate("%w"))
  local nEventType = self.tbEventWeeklyType[nWeek]
  if nEventType <= 0 then
    return 0
  end
  local tbStartTB = { self.tbReadyTime[1][1], self.tbReadyTime[2][1], self.tbReadyTime[3][1] }
  if nType == 2 then
    tbStartTB = self.tbStartTime
  end
  if nEventType == 1 and (nTime < tbStartTB[1] or (nTime >= self.tbEndTime[1] and nTime < tbStartTB[3]) or nTime >= self.tbEndTime[3]) then
    return 0
  end
  if nEventType == 2 and (nTime < tbStartTB[2] or nTime >= self.tbEndTime[2]) then
    return 0
  end
  return 1
end

--检查当天是不是已经参加过了
function JxsjKeju:CheckIsAttended(pPlayer)
  local nGradePre = pPlayer.GetTask(self.nTaskGroup, self.nGradePre)
  local nDatePre = pPlayer.GetTask(self.nTaskGroup, self.nGradeDate)
  local nDateNow = tonumber(GetLocalDate("%Y%m%d"))
  if nDateNow == nDatePre then
    return 1
  end
  return 0
end

--检查是不是在名单参加名单中
function JxsjKeju:CheckIsAttending(nId)
  return self.tbAttendList[nId]
end

--是不是有乡试奖励没有领取
function JxsjKeju:HasAward()
  local nDayGradeDate = me.GetTask(self.nTaskGroup, self.nGradeDate)
  local nGradePre = me.GetTask(self.nTaskGroup, self.nGradePre)
  local nGradeTime = me.GetTask(self.nTaskGroup, self.nGradeTime)
  local nGetAwardDay = me.GetTask(self.nTaskGroup, self.nGetAwardDay)
  local nWeek = tonumber(os.date("%w", Lib:GetDate2Time(nDayGradeDate)))
  local nGrade = math.fmod(nGradePre, 10000) + nGradeTime
  --积分不是今天的，也不是殿试的同时要没有领取并且是够资格的
  if nDayGradeDate ~= tonumber(GetLocalDate("%Y%m%d")) and nDayGradeDate > nGetAwardDay and self.tbEventWeeklyType[nWeek] ~= 2 and nGrade >= self.nMinAwardGradeType1 then
    return 1
  end
  return 0
end

--排周末的积分情况
function JxsjKeju:SortWeekGrade(nType)
  if nType ~= 2 then
    return
  end
  table.sort(self.tbJxsjKejuGrade[nType], self._Cmp)
  for i, tb in ipairs(self.tbJxsjKejuGrade[nType]) do
    self.tbJxsjKejuGradeEx[tb[1]] = i
  end
end

function JxsjKeju:SortWeekGradeList(nNum)
  self.tbJxsjKejuGrade_Week[nNum] = {}
  local nAllNum = #self.tbJxsjKejuGrade[2]
  for i, tb in ipairs(self.tbJxsjKejuGrade[2]) do
    if tb[2] < self.nMinAwardGradeType2 then
      nAllNum = i - 1
      break
    end
  end
  local tbLadder = { { 1, 3 } }
  tbLadder[4] = { math.floor(nAllNum * 0.5) + 1, nAllNum }
  tbLadder[3] = { math.floor(nAllNum * 0.2) + 1, math.floor(nAllNum * 0.5) }
  tbLadder[2] = { 4, math.floor(nAllNum * 0.2) }
  if nAllNum > 0 then
    for i = 1, nAllNum do
      local tb = self.tbJxsjKejuGrade[2][i]
      for j = 1, 4 do
        if tbLadder[j][2] >= tbLadder[j][1] and i <= tbLadder[j][2] and i >= tbLadder[j][1] then
          self.tbJxsjKejuGrade_Week[nNum][tb[1]] = { j, i, tb[2] }
          break
        end
      end
    end
    for i = nAllNum + 1, #self.tbJxsjKejuGrade[2] do
      local tb = self.tbJxsjKejuGrade[2][i]
      self.tbJxsjKejuGrade_Week[nNum][tb[1]] = { 0, i, tb[2] }
    end
  end
end
