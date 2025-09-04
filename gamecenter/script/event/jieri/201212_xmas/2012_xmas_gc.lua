------------------------------------------------------
-- 文件名　：2012_xmas_gc.lua
-- 创建者　：dengyong
-- 创建时间：2012-12-11 11:27:45
-- 描  述  ：
------------------------------------------------------
if not MODULE_GC_SERVER then
  return
end

SpecialEvent.Xmas2012 = SpecialEvent.Xmas2012 or {}
local Xmas2012 = SpecialEvent.Xmas2012

Xmas2012.START_DAY = 20121218
Xmas2012.END_DAY = 20130103
Xmas2012.bEventStarted = 0

-- 只判断天数
function Xmas2012:IsEventOpen()
  -- 12.18至1.13
  local nDay = tonumber(os.date("%Y%m%d", GetTime()))
  if nDay < self.START_DAY or nDay > self.END_DAY then
    return 0
  end

  return 1
end

function Xmas2012:OnGCStarted()
  -- 活动开启前10分钟持续的公告提示
  local nTaskId = KScheduleTask.AddTask("每日圣诞赛跑提醒", "SpecialEvent", "Xmas2012_PreDayRaceStart")
  KScheduleTask.RegisterTimeTask(nTaskId, 1050, 1)

  -- 每天开启活动
  nTaskId = KScheduleTask.AddTask("每日圣诞赛跑开启", "SpecialEvent", "Xmas2012_OnDayRaceStart")
  KScheduleTask.RegisterTimeTask(nTaskId, 1100, 1)

  -- 每天关闭活动
  nTaskId = KScheduleTask.AddTask("每日圣诞赛跑关闭", "SpecialEvent", "Xmas2012_OnDayRaceEnd")
  KScheduleTask.RegisterTimeTask(nTaskId, 2300, 1)

  -- 每天删除NPC
  nTaskId = KScheduleTask.AddTask("每日圣诞赛跑清除NPC", "SpecialEvent", "Xmas2012_PostDayRaceEnd")
  KScheduleTask.RegisterTimeTask(nTaskId, 2330, 1)
end

-- 每天10:50到11:00每2min1次【世界公告】
function SpecialEvent:Xmas2012_PreDayRaceStart()
  if Xmas2012:IsEventOpen() == 0 then
    return
  end

  GlobalExcute({ "SpecialEvent.Xmas2012:PreDayRaceStart" })

  -- 间隔两分钟，提示
  self.nXmas12RaceTimer = Timer:Register(2 * 60 * 18, self.Xmas2012_OnRaceTip_Timer, self)
  self.nXmas12RaceTimerTimes = 4
  Dialog:GlobalMsg2SubWorld_GC("<color=pink>某神秘场地降落了无数圣诞彩星，派送狂欢即将开始，与临安、凤翔、襄阳的雪人滚滚对话即可进入活动场地！<color>")
end

function SpecialEvent:Xmas2012_OnRaceTip_Timer()
  Dialog:GlobalMsg2SubWorld_GC("<color=pink>某神秘场地降落了无数圣诞彩星，派送狂欢即将开始，与临安、凤翔、襄阳的雪人滚滚对话即可进入活动场地！<color>")
  self.nXmas12RaceTimerTimes = self.nXmas12RaceTimerTimes - 1
  if self.nXmas12RaceTimerTimes <= 0 then
    self.nXmas12RaceTimer = nil
    return 0
  end
end

-- 每天11:00【世界公告】
function SpecialEvent:Xmas2012_OnDayRaceStart()
  if Xmas2012:IsEventOpen() == 0 then
    return
  end

  if self.nXmas12RaceTimer then
    Timer:Close(self.nXmas12RaceTimer)
    self.nXmas12RaceTimer = 0
  end

  GlobalExcute({ "SpecialEvent.Xmas2012:OnDayRaceStart" })
  Dialog:GlobalMsg2SubWorld_GC("<color=pink>派送狂欢开始了。驾着小鹿，拉着雪橇，狂欢圣诞节尽在此！与临安、凤翔、襄阳的雪人滚滚处对话可进入活动场地<color>")
end

function SpecialEvent:Xmas2012_OnDayRaceEnd()
  if Xmas2012:IsEventOpen() == 0 then
    return
  end

  GlobalExcute({ "SpecialEvent.Xmas2012:OnDayRaceEnd" })
end

function SpecialEvent:Xmas2012_PostDayRaceEnd()
  if Xmas2012:IsEventOpen() == 0 then
    return
  end

  GlobalExcute({ "SpecialEvent.Xmas2012:PostDayRaceEnd" })
end

function Xmas2012:StartEvent()
  if self:IsEventOpen() == 0 then
    return
  end
  self.bEventStarted = 1
  GlobalExcute({ "SpecialEvent.Xmas2012:StartRaceEvent" })
end

function Xmas2012:OnRecConnectEvent(nConnectId)
  if self:IsEventOpen() == 0 then
    return
  end
  if self.bEventStarted == 0 then
    return
  end

  GSExecute(nConnectId, { "SpecialEvent.Xmas2012:StartRaceEvent" })
end

if tonumber(os.date("%Y%m%d", GetTime())) <= Xmas2012.END_DAY then
  GCEvent:RegisterGCServerStartFunc(SpecialEvent.Xmas2012.OnGCStarted, SpecialEvent.Xmas2012)
  GCEvent:RegisterGS2GCServerStartedFunc(SpecialEvent.Xmas2012.OnRecConnectEvent, SpecialEvent.Xmas2012)
  GCEvent:RegisterAllServerStartFunc(SpecialEvent.Xmas2012.StartEvent, SpecialEvent.Xmas2012)
end
