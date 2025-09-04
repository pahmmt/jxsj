Ui.tbLogic.tbPassPodTime = {}

local tbPassPodTime = Ui.tbLogic.tbPassPodTime
local tbTimer = Ui.tbLogic.tbTimer
local TIME_SETTING = Env.GAME_FPS * 30 -- Ë¢ÐÂÊ±¼ä

function tbPassPodTime:Init()
  self.nLockTimeMin = 1.5
  self.TimerId = 0
end

function tbPassPodTime:Clear()
  tbTimer:Close(self.TimerId)
  self.TimerId = 0
end

function tbPassPodTime:OnStart()
  self.TimerId = tbTimer:Register(TIME_SETTING, self.OnTimer, self)
end

function tbPassPodTime:OnTimer()
  if self.nLockTimeMin > 0 then
    self.nLockTimeMin = self.nLockTimeMin - 0.5
    UiNotify:OnNotify(UiNotify.emUIEVENT_PASSPODTIME_REFRESH)
  end

  if self.nLockTimeMin == 0 then
    tbTimer:Close(self.TimerId)
    self.TimerId = 0
  end
end

function tbPassPodTime:IsReady()
  if self.nLockTimeMin == 0 then
    return 1
  else
    return 0
  end
end

function tbPassPodTime:GetLeaveTime()
  return self.nLockTimeMin
end
