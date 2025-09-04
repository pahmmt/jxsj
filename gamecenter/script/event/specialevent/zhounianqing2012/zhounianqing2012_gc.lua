-- zhouchenfei
-- 2012/9/24 15:30:59
-- 烟花活动
if not MODULE_GC_SERVER then
  return 0
end

Require("\\script\\event\\specialevent\\zhounianqing2012\\zhounianqing2012_public.lua")

local ZhouNianQing2012 = SpecialEvent.ZhouNianQing2012

ZhouNianQing2012.nEventTimer_Time = 5 * 60

function ZhouNianQing2012:OnRegScheduleEventTask()
  local nNowDate = tonumber(os.date("%Y%m%d", GetTime()))
  if nNowDate > self.nEventEndTime then
    return 0
  end

  local nTaskId = KScheduleTask.AddTask("2012周年庆氛围活动开启", "SpecialEvent", "XiaoTianDeng_CallOut_TimerFrame")
  assert(nTaskId > 0)
  for i, tbTimeFrame in ipairs(self.tbXiaoTianDengEventTime) do
    KScheduleTask.RegisterTimeTask(nTaskId, tbTimeFrame[1], i)
  end

  local nTaskId = KScheduleTask.AddTask("2012周年庆氛围活动开启", "SpecialEvent", "DaTianDeng_CallOut_TimerFrame")
  assert(nTaskId > 0)
  for i, tbTimeFrame in ipairs(self.tbDaTianDengEventTime) do
    KScheduleTask.RegisterTimeTask(nTaskId, tbTimeFrame[1], i)
  end
end

function ZhouNianQing2012:OnStartXiaoTianDengEvent()
  if self.nZhouNianQing2012EventTimerId and self.nZhouNianQing2012EventTimerId > 0 then
    --防止重复timer启动
    Timer:Close(self.nZhouNianQing2012EventTimerId)
    self.nZhouNianQing2012EventTimerId = 0
  end

  if self:IsOpenEvent() == 0 then
    self.nZhouNianQing2012EventTimerId = 0
    return 0
  end

  self.nEventStep = 0
  self.nZhouNianQing2012EventTimerId = Timer:Register(self.nEventTimer_Time * 18, self.ZhouNianQing2012EventTime, self)
  self:ZhouNianQing2012EventTime()
end

function ZhouNianQing2012:OnStartZhouNianQing2012Event()
  local szAnncone = string.format("2012周年庆活动开始啦，请大家到汴京、凤翔、临安，找大天灯许愿吧！")
  Dialog:GlobalNewsMsg_Center(szAnncone)
  Dialog:GlobalNewsMsg_GC(szAnncone)
end

function ZhouNianQing2012:ZhouNianQing2012EventTime()
  if self:IsOpenEvent() == 0 then
    GlobalExcute({ "SpecialEvent.ZhouNianQing2012:OnClearXiaoTianDeng" })
    self.nZhouNianQing2012EventTimerId = 0
    return 0
  end

  if self:IsOpenXiaoTianDengEventTime() == 0 then
    GlobalExcute({ "SpecialEvent.ZhouNianQing2012:OnClearXiaoTianDeng" })
    self.nZhouNianQing2012EventTimerId = 0
    return 0
  end

  local nMod = math.fmod(self.nEventStep, 3)
  if nMod == 0 then
    GlobalExcute({ "SpecialEvent.ZhouNianQing2012:OnAddXiaoTianDeng" })
  elseif nMod == 2 then
    GlobalExcute({ "SpecialEvent.ZhouNianQing2012:OnClearXiaoTianDeng" })
  end
  self.nEventStep = self.nEventStep + 1
  return
end

function ZhouNianQing2012:OnGCStartEvent()
  self:OnRegScheduleEventTask()
end

function SpecialEvent:XiaoTianDeng_CallOut_TimerFrame()
  local nFlag, szError = ZhouNianQing2012:IsOpenEvent()
  if 1 ~= nFlag then
    return 0
  end
  ZhouNianQing2012:OnStartXiaoTianDengEvent()
end

function SpecialEvent:DaTianDeng_CallOut_TimerFrame()
  local nFlag, szError = ZhouNianQing2012:IsOpenEvent()
  if 1 ~= nFlag then
    return 0
  end
  ZhouNianQing2012:OnStartZhouNianQing2012Event()
end

GCEvent:RegisterGCServerStartFunc(ZhouNianQing2012.OnGCStartEvent, ZhouNianQing2012)
