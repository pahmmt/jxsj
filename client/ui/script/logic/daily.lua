Ui.tbLogic.tbDaily = {}

local tbDaily = Ui.tbLogic.tbDaily
local tbTimer = Ui.tbLogic.tbTimer
local TIME_SETTING = Env.GAME_FPS * 20 -- Ë¢ÐÂÊ±¼ä

function tbDaily:Init() end

function tbDaily:OnStart()
  --self.TimerId = tbTimer:Register(TIME_SETTING, self.OnTimer, self);
end

function tbDaily:IsFreeDaily()
  if GblTask:GetUiFunSwitch(Ui.UI_DAILY) == 0 then
    return 0
  end
  return 1
end

function tbDaily:OnTimer()
  if UiManager:WindowVisible(Ui.UI_DAILY) == 0 and self:IsFreeDaily() == 1 then
    Ui(Ui.UI_DAILY):OnEnterUrlHide()
  end
  tbTimer:Close(self.TimerId)
end
