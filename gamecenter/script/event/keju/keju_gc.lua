-- 文件名　：keju_gc.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-10-24 15:23:02
-- 功能说明：剑侠世界科举考试

if not MODULE_GC_SERVER then
  return
end

Require("\\script\\event\\keju\\keju_def.lua")

SpecialEvent.JxsjKeju = SpecialEvent.JxsjKeju or {}
local JxsjKeju = SpecialEvent.JxsjKeju

--记录参加的名单
function JxsjKeju:AttendEvent_GC(nType, nId)
  self.tbAttendList[nId] = 1
  GlobalExcute({ "SpecialEvent.JxsjKeju:AttendEvent_GS", nType, nId })
end

--开启科举之前的提示
function SpecialEvent:JxsjKeju_ReadyMsg()
  local nNowTime = tonumber(GetLocalDate("%H%M"))
  local nWeek = tonumber(GetLocalDate("%w"))
  if JxsjKeju.tbEventWeeklyType[nWeek] == 1 and ((nNowTime < JxsjKeju.tbReadyTime[1][2] and nNowTime >= JxsjKeju.tbReadyTime[1][1]) or (nNowTime < JxsjKeju.tbReadyTime[3][2] and nNowTime >= JxsjKeju.tbReadyTime[3][1])) then
    GlobalExcute({ "SpecialEvent.JxsjKeju:Msg2World2GS", 1 })
  elseif JxsjKeju.tbEventWeeklyType[nWeek] == 2 and nNowTime < JxsjKeju.tbReadyTime[2][2] and nNowTime >= JxsjKeju.tbReadyTime[2][1] then
    GlobalExcute({ "SpecialEvent.JxsjKeju:Msg2World2GS", 2 })
  end
end

--开启科举活动
function SpecialEvent:JxsjKeju_Start(nIndex)
  local nWeek = tonumber(GetLocalDate("%w"))
  if (JxsjKeju.tbEventWeeklyType[nWeek] == 1 and nIndex ~= 2) or (JxsjKeju.tbEventWeeklyType[nWeek] == 2 and nIndex == 2) then
    self.JxsjKeju:StartEvent(JxsjKeju.tbEventWeeklyType[nWeek], nIndex)
  end
end

function SpecialEvent:OnReadyEvent(nIndex)
  local nWeek = tonumber(GetLocalDate("%w"))
  local nType = JxsjKeju.tbEventWeeklyType[nWeek]
  if JxsjKeju:CheckIsOpen(1) == 0 then
    return
  end
  --成绩单重置
  JxsjKeju.tbJxsjKejuGrade[nType] = {}
  JxsjKeju.tbJxsjKejuGradeEx = {}
  --参与人员名单
  JxsjKeju.tbAttendList = {}
  --流水号初始化
  JxsjKeju.nJourNum = 0
  --初始化试题库
  local nFlag = JxsjKeju:GetDayQuestion(nType, nIndex)
  if nFlag == 0 then
    print("题库出错，科举考试终止。")
    GlobalExcute({ "SpecialEvent.JxsjKeju:Msg2World2GS", 3 })
    return
  end
  --科举类型
  JxsjKeju.nQuestionType = nType
  GlobalExcute({ "SpecialEvent.JxsjKeju:OnReadyEvent_GS", nType, nIndex })
end

--活动开始
function JxsjKeju:StartEvent(nType, nIndex)
  --通知gs开始考试了
  GlobalExcute({ "SpecialEvent.JxsjKeju:StartEvent_GS", nType })
  self:AskPlayerQuestion(nType)
  Timer:Register(self.nTimeAsk, self.AskPlayerQuestion, self, nType)
end

--结束科举
function JxsjKeju:EndEvent(nType)
  --存成绩单
  self:SaveBuffer()

  --告诉gs结束
  GlobalExcute({ "SpecialEvent.JxsjKeju:EndEvent_GS", nType })

  --乡试第一名特殊奖励发放
  if nType == 1 and self.tbJxsjKejuGrade[nType] and self.tbJxsjKejuGrade[nType][1] then
    local nPlayerId = KGCPlayer.GetPlayerIdByRoleId(self.tbJxsjKejuGrade[nType][1][1])
    if nPlayerId then
      local szName = KGCPlayer.GetPlayerName(nPlayerId)
      if szName then
        local szScript = [=[
					Achievement:FinishAchievement(me, 510);
					me.AddTitle(16,2,1,1);
					me.SetCurTitle(16,2,1,1);
					me.AddSkillState(879,3, 2, 2 * 3600*18, 1, 0, 1);
					me.Msg('恭喜您获得乡试第一名。');
					Dbg:WriteLog("JxsjKeju", "XiangshiFirstOther", "乡试第一名额外奖励");
				]=]
        SpecialEvent.CompensateGM:AddOnLine("", "", szName, 0, 0, szScript, 1)
      end
    end
  end
end

--统计每个人的成绩
function JxsjKeju:GradeStatistics_GC(szRoleId, nGrade, nGradeFlag)
  local tbGradeList = self.tbJxsjKejuGrade[self.nQuestionType]
  if self.nQuestionType == 1 then
    if not tbGradeList[1] or tbGradeList[1][2] < nGrade then
      self.tbJxsjKejuGrade[self.nQuestionType][1] = { szRoleId, nGrade }
    else
      return
    end
    if self.tbJxsjKejuGrade[1] and self.tbJxsjKejuGrade[1][2] then
      self.tbJxsjKejuGrade[1][2] = nil
    end
    GlobalExcute({ "SpecialEvent.JxsjKeju:GradeStatistics_GS", 1, 1, szRoleId, nGrade })
  elseif self.nQuestionType == 2 then
    local nNum = self.tbJxsjKejuGradeEx[szRoleId]
    if not nNum then
      nNum = #self.tbJxsjKejuGrade[self.nQuestionType] + 1
    end
    self.tbJxsjKejuGrade[self.nQuestionType][nNum] = { szRoleId, nGrade }
    self.tbJxsjKejuGradeEx[szRoleId] = nNum
    GlobalExcute({ "SpecialEvent.JxsjKeju:GradeStatistics_GS", 2, nNum, szRoleId, nGrade })
  end
end

--活动期间gs重启同步成绩单（防止gs宕机的情况）
function JxsjKeju:OnRecConnectEvent(nConnectId)
  local nNowTime = tonumber(GetLocalDate("%H%M"))
  local nWeek = tonumber(GetLocalDate("%w"))
  if self.tbEventWeeklyType[nWeek] == 1 and ((nNowTime > self.tbStartTime[1] and nNowTime < self.tbEndTime[1]) or (nNowTime > self.tbStartTime[3] and nNowTime < self.tbEndTime[3])) or (self.tbEventWeeklyType[nWeek] == 2 and nNowTime < self.tbStartTime[2] and nNowTime < self.tbEndTime[2]) then
    self:SaveBuffer()
    GSExcute(nConnectId or -1, { "SpecialEvent.JxsjKeju:SynGradeList_GS", self.nJourNum, self.nQuestionType })

    --分帧同步参与名单（每帧同步200个人员）
    local nCount = 0
    local nGroupId = 1
    local tbSync = {}
    for nId, _ in ipairs(self.tbAttendList) do
      tbSync[nGroupId] = tbSync[nGroupId] or {}
      tbSync[nGroupId][nId] = 1
      nCount = nCount + 1
      if nCount >= 200 then
        Timer:Register(Env.GAME_FPS * nGroupId, self.SyncAttendList, self, tbSync[nGroupId], nConnectId or -1)
        nGroupId = nGroupId + 1
        nCount = 0
      end
    end
    if nCount > 0 and nCount < 200 then
      self.SyncAttendList(tbSync[nGroupId], nConnectId or -1)
    end
  end
end

function JxsjKeju:SyncAttendList(tbAttendList, nConnectId)
  GSExcute(nConnectId, { "SpecialEvent.JxsjKeju:SynGradeListEx_GS", tbAttendList })
  return 0
end

--获取每日的题目
function JxsjKeju:GetDayQuestion(nType, nIndex)
  self.tbQuestionDay = {}
  local tbRandQuestion = {}
  local nNum = KGblTask.SCGetDbTaskInt(DBTASK_JXSJ_KEJU_WEEKGRADE)
  if nType == 1 then
    local tbQuestion = self.tbQuestion[1][nNum]
    if not tbQuestion then
      return 0
    end
    local tbOldQuestion = self.tbOldQuestion[nNum]
    if not tbOldQuestion then
      return 0
    end
    local nWeek = tonumber(GetLocalDate("%w"))
    if nWeek <= 0 or nWeek >= 6 then
      return 0
    end
    local nStart = 0
    local nEnd = 0
    local nOldStart = 0
    local nOldEnd = 0
    for i = 1, nWeek do
      nEnd = nEnd + self.tbWeekRule[i][1] * 2
      nOldEnd = nOldEnd + self.tbWeekRule[i][2] * 2 * 3
    end
    if nIndex <= 1 then
      nEnd = nEnd - self.tbWeekRule[nWeek][1]
      nOldEnd = nOldEnd - self.tbWeekRule[nWeek][2] * 3
    end
    nStart = nEnd - self.tbWeekRule[nWeek][1] + 1
    nOldStart = nOldEnd - self.tbWeekRule[nWeek][2] * 3 + 1
    --乡试的新题
    for j = 1, 3 do
      local tbDayQuestion = {}
      for i = nStart, nEnd do
        table.insert(tbDayQuestion, tbQuestion[i])
      end
      for i = nOldStart + (j - 1) * self.tbWeekRule[nWeek][2], nOldStart + j * self.tbWeekRule[nWeek][2] - 1 do
        table.insert(tbDayQuestion, tbOldQuestion[i])
      end
      Lib:SmashTable(tbDayQuestion)
      Lib:MergeTable(self.tbQuestionDay, tbDayQuestion)
    end
  elseif nType == 2 then
    self.tbQuestionDay = Lib:CopyTB1(self.tbQuestion[2][nNum])
    if not self.tbQuestionDay then
      return 0
    end
    --殿试可随机的老题范围
    tbRandQuestion = self.tbQuestion[1][nNum]
    Lib:MergeTable(tbRandQuestion, self.tbOldQuestion[nNum])
    if not tbRandQuestion or #tbRandQuestion <= 0 then
      return 0
    end
    --随即老题
    Lib:SmashTable(tbRandQuestion)
    for i = 1, self.tbWeeklyRule[2] do
      table.insert(self.tbQuestionDay, { unpack(tbRandQuestion[i]) })
    end
    Lib:SmashTable(self.tbQuestionDay)
  end
  return 1
end

--每40秒服务器出题
function JxsjKeju:AskPlayerQuestion(nType)
  self.nJourNum = self.nJourNum + 1 --流水号先加1
  self:SortWeekGrade(nType)
  local nNum = math.fmod(self.nJourNum, #self.tbQuestionDay)
  if nNum == 0 then
    nNum = #self.tbQuestionDay
  end
  local nTime = tonumber(GetLocalDate("%H%M%S"))
  --如果下一道题的出题时间在结束时间外，就停止出题，并显示活动已经截止。
  if self:CheckIsOpen(2) == 0 or (nType == 2 and self.nJourNum > self.tbQuestionCountPre[nType]) then
    self:EndEvent(nType)
    --周六的殿试之后换届
    if nType == 2 then
      local nNum = KGblTask.SCGetDbTaskInt(DBTASK_JXSJ_KEJU_WEEKGRADE)
      KGblTask.SCSetDbTaskInt(DBTASK_JXSJ_KEJU_WEEKGRADE, nNum + 1)
    end
    return 0
  end
  if not self.tbQuestionDay[nNum] then
    return 0
  end
  GlobalExcute({ "SpecialEvent.JxsjKeju:AskPlayerQuestion_GS", self.tbQuestionDay[nNum], self.nJourNum })
  return
end

--启动注册定时事件
function JxsjKeju:ServerStartFun()
  --周1到周5启动服务器后，需要校正科举的届数，保持全服务器一直（因为周6要变化届数，所以周末不做，主要是开新服的时候校正用）
  local nNum = KGblTask.SCGetDbTaskInt(DBTASK_JXSJ_KEJU_WEEKGRADE)
  local nEventStartWeek = Lib:GetLocalWeek(Lib:GetDate2Time(20121204))
  local nNowWeek = Lib:GetLocalWeek(GetTime())
  local nNowWeekly = tonumber(os.date("%w", GetTime()))
  if nNowWeekly >= 1 and nNowWeekly <= 5 and nNum ~= nNowWeek - nEventStartWeek then
    KGblTask.SCSetDbTaskInt(DBTASK_JXSJ_KEJU_WEEKGRADE, nNowWeek - nEventStartWeek)
  end

  local nReadyMsgTaskId = KScheduleTask.AddTask("科举考试公告", "SpecialEvent", "JxsjKeju_ReadyMsg")
  local nId = 0
  for i, tb in ipairs(self.tbReadyTime) do
    for j = tb[1], tb[1] + 10, 3 do
      nId = nId + 1
      KScheduleTask.RegisterTimeTask(nReadyMsgTaskId, j, nId)
    end
  end

  local nReadyTaskId = KScheduleTask.AddTask("科举考试初始化", "SpecialEvent", "OnReadyEvent")
  for i, tb in ipairs(self.tbReadyTime) do
    KScheduleTask.RegisterTimeTask(nReadyTaskId, tb[1], i)
  end

  local nStartTaskId = KScheduleTask.AddTask("科举考试开始", "SpecialEvent", "JxsjKeju_Start")
  for i, nTime in ipairs(self.tbStartTime) do
    KScheduleTask.RegisterTimeTask(nStartTaskId, nTime, i)
  end

  --载入最近一个月的题目
  self:LoadQuestion()

  self:LoadBuffer()
end

GCEvent:RegisterGCServerStartFunc(SpecialEvent.JxsjKeju.ServerStartFun, SpecialEvent.JxsjKeju)
GCEvent:RegisterGS2GCServerStartFunc(SpecialEvent.JxsjKeju.OnRecConnectEvent, SpecialEvent.JxsjKeju)
