Require("\\script\\task\\xiakedaily\\xiakedaily_def.lua")

-- 获取本周完成次数
function XiakeDaily:GetTask(nTaskId)
  return me.GetTask(self.TASK_GROUP, nTaskId)
end

function XiakeDaily:SetTask(nTaskId, nValue)
  me.SetTask(self.TASK_GROUP, nTaskId, nValue)
end

function XiakeDaily:GetWeekTimes()
  local nTaskWeek = self:GetTask(self.TASK_WEEK)
  local nTaskDay = KGblTask.SCGetDbTaskInt(DBTASK_XIAKEDAILY_TASK_DAY)
  local nSec = Lib:GetDate2Time(nTaskDay)
  local nWeek = Lib:GetLocalWeek(nSec)
  if nWeek ~= nTaskWeek then
    return 0
  end
  return self:GetTask(self.TASK_WEEK_COUNT)
end

-- 检查当天能否做侠客,必须当周未满五次，且当天为完成
function XiakeDaily:CheckCanAttend()
  if XiakeDaily:GetWeekTimes() >= self.WEEK_MAX_TIMES then
    return 0
  end
  local nTaskDay = KGblTask.SCGetDbTaskInt(DBTASK_XIAKEDAILY_TASK_DAY)
  if XiakeDaily:GetTask(self.TASK_ACCEPT_DAY) < nTaskDay then
    return 1
  end
  if XiakeDaily:GetTask(self.TASK_STATE) == 2 then
    return 0
  end
  return 1
end
