-- 文件名　：messagepush_def.lua
-- 创建者　：huangxiaoming
-- 创建时间：2012-11-2 15:29:00
-- 描  述  ：推送界面 客户端服务端公用逻辑

Require("\\script\\event\\specialevent\\messagepush\\messagepush_def.lua")

local tbMessagePush = SpecialEvent.tbMessagePush or {}
SpecialEvent.tbMessagePush = tbMessagePush

function tbMessagePush:SetOpenState(nState)
  self.IS_OPEN = nState
end
-- 一生一次的任务变量
function tbMessagePush:AchieveLifeTask(nIndex, pPlayer)
  self:SetTaskValueByIndex(self.TASK_GROUP_LIFE, 1, nIndex, 1, pPlayer)
end

function tbMessagePush:GetLifeTask(nIndex, pPlayer)
  return self:GetTaskValueByIndex(self.TASK_GROUP_LIFE, 1, nIndex, pPlayer)
end

function tbMessagePush:ResetLifeTask(nIndex, pPlayer)
  self:SetTaskValueByIndex(self.TASK_GROUP_LIFE, 1, nIndex, 0, pPlayer)
end

-- 每月一次的任务变量
function tbMessagePush:AchieveMonthTask(nIndex, pPlayer)
  self:UpdateMonthTask(pPlayer)
  self:SetTaskValueByIndex(self.TASK_GROUP_MONTH, 2, nIndex, 1, pPlayer)
end

function tbMessagePush:GetMonthTask(nIndex, pPlayer)
  self:UpdateMonthTask()
  return self:GetTaskValueByIndex(self.TASK_GROUP_MONTH, 2, nIndex, pPlayer)
end

-- 重置一下指定位，不需判断月份
function tbMessagePush:ResetMonthTask(nIndex, pPlayer)
  self:SetTaskValueByIndex(self.TASK_GROUP_MONTH, 2, nIndex, 0, pPlayer)
end

function tbMessagePush:UpdateMonthTask(pPlayer)
  pPlayer = pPlayer or me
  local nTaskMonth = pPlayer.GetTask(self.TASK_GROUP_MONTH, 1)
  local nMonth = tonumber(GetLocalDate("%Y%m"))
  if nMonth ~= nTaskMonth then
    for i = 2, self.MAX_TASK_COUNT_LIFE + 1 do
      pPlayer.SetTask(self.TASK_GROUP_MONTH, i, 0)
    end
    pPlayer.SetTask(self.TASK_GROUP_MONTH, 1, nMonth)
  end
end

-- 每周一次的任务变量
function tbMessagePush:AchieveWeekTask(nIndex, pPlayer)
  self:UpdateWeekTask(pPlayer)
  self:SetTaskValueByIndex(self.TASK_GROUP_WEEK, 2, nIndex, 1, pPlayer)
end

function tbMessagePush:GetWeekTask(nIndex, pPlayer)
  self:UpdateWeekTask(pPlayer)
  return self:GetTaskValueByIndex(self.TASK_GROUP_WEEK, 2, nIndex, pPlayer)
end

function tbMessagePush:ResetWeekTask(nIndex, pPlayer)
  self:SetTaskValueByIndex(self.TASK_GROUP_WEEK, 2, nIndex, 1, pPlayer)
end

function tbMessagePush:UpdateWeekTask(pPlayer)
  pPlayer = pPlayer or me
  local nTaskWeek = pPlayer.GetTask(self.TASK_GROUP_WEEK, 1)
  local nWeek = Lib:GetLocalWeek()
  if nWeek ~= nTaskWeek then
    for i = 2, self.MAX_TASK_COUNT_WEEK + 1 do
      pPlayer.SetTask(self.TASK_GROUP_WEEK, i, 0)
    end
    pPlayer.SetTask(self.TASK_GROUP_WEEK, 1, nWeek)
  end
end

-- 每日一次的任务变量
function tbMessagePush:AchieveDayTask(nIndex, pPlayer)
  self:UpdateDayTask(pPlayer)
  self:SetTaskValueByIndex(self.TASK_GROUP_DAY, 2, nIndex, 1, pPlayer)
end

function tbMessagePush:GetDayTask(nIndex, pPlayer)
  self:UpdateDayTask(pPlayer)
  return self:GetTaskValueByIndex(self.TASK_GROUP_DAY, 2, nIndex, pPlayer)
end

function tbMessagePush:ResetDayTask(nIndex, pPlayer)
  self:SetTaskValueByIndex(self.TASK_GROUP_DAY, 2, nIndex, 1, pPlayer)
end

function tbMessagePush:UpdateDayTask(pPlayer)
  pPlayer = pPlayer or me
  local nTaskDay = pPlayer.GetTask(self.TASK_GROUP_DAY, 1)
  local nDay = Lib:GetLocalDay()
  if nDay ~= nTaskDay then
    for i = 2, self.MAX_TASK_COUNT_DAY + 1 do
      pPlayer.SetTask(self.TASK_GROUP_DAY, i, 0)
    end
    pPlayer.SetTask(self.TASK_GROUP_DAY, 1, nDay)
  end
end

-- 获取指定任务索引的值
function tbMessagePush:GetTaskValueByIndex(nGroupId, nBeginTaskId, nIndex, pPlayer)
  pPlayer = pPlayer or me
  local nBitIndex = math.mod(nIndex, 32)
  local nTaskId = 0
  if nBitIndex == 0 then
    nTaskId = nBeginTaskId + math.floor(nIndex / 32) - 1
    nBitIndex = 31
  else
    nTaskId = nBeginTaskId + math.floor(nIndex / 32)
    nBitIndex = nBitIndex - 1
  end
  local nTaskValue = pPlayer.GetTask(nGroupId, nTaskId)
  return Lib:LoadBits(nTaskValue, nBitIndex, nBitIndex)
end

-- 设置指定任务索引的值
function tbMessagePush:SetTaskValueByIndex(nGroupId, nBeginTaskId, nIndex, nValue, pPlayer)
  if nValue ~= 0 and nValue ~= 1 then
    assert(false)
    return 0
  end
  pPlayer = pPlayer or me
  local nBitIndex = math.mod(nIndex, 32)
  local nTaskId = 0
  if nBitIndex == 0 then
    nTaskId = nBeginTaskId + math.floor(nIndex / 32) - 1
    nBitIndex = 31
  else
    nTaskId = nBeginTaskId + math.floor(nIndex / 32)
    nBitIndex = nBitIndex - 1
  end
  local nTaskValue = pPlayer.GetTask(nGroupId, nTaskId)
  local nNewTaskValue = Lib:SetBits(nTaskValue, nValue, nBitIndex, nBitIndex)
  if nNewTaskValue ~= nTaskValue then -- 相等就少设置一遍，设置了任务变量都是要同步的
    pPlayer.SetTask(nGroupId, nTaskId, nNewTaskValue)
  end
  return 1
end

-- 完成藏宝图活动任务
function tbMessagePush:AchieveTreasure(nTreasureId, nLevel, pPlayer)
  if self:GetLifeTask(29, pPlayer) == 0 then
    self:AchieveLifeTask(29, pPlayer)
  end
end

-- 完成逍遥谷活动任务
function tbMessagePush:AchieveXoyo(nDifficuty, pPlayer)
  if self:GetLifeTask(30, pPlayer) == 0 then
    self:AchieveLifeTask(30, pPlayer)
  end
end

-- 完成祈福任务
function tbMessagePush:AchievePray(pPlayer)
  if self:GetLifeTask(22, pPlayer) == 0 then
    self:AchieveLifeTask(22, pPlayer)
  end
end

-- 完成义军任务
function tbMessagePush:AchieveLaobao(pPlayer)
  if self:GetLifeTask(16, pPlayer) == 0 then
    self:AchieveLifeTask(16, pPlayer)
  end
end
