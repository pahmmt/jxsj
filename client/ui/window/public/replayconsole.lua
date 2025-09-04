local replayconsole = Ui:GetClass("replayconsole")
local tbTimer = Ui.tbLogic.tbTimer
local BTN_PAUSEPLAY = "BtnPausePlay"
local BTN_STOPPLAY = "BtnStopPlay"
local BTN_SPEEDUP = "BtnSpeedUp"
local BTN_SPEEDDOWN = "BtnSpeedDown"
local BTN_CONTINUEPLAY = "BtnContinuePlay"
local BTN_SPEEDNORMAL = "BtnSpeedNormal"
local TXT_SPEED = "TxtSpeed"

local SPR_BTN_PLAY = "\\image\\ui\\001a\\recplayer\\btn_play.spr"
local SPR_BTN_PAUSE = "\\image\\ui\\001a\\recplayer\\btn_pause.spr"
local MAX_HIGHSPEED = 4
local MIN_LOWSPEED = -4
local enum_Replay_Playing = 5

function replayconsole:Init() end

function replayconsole:OnOpen()
  self:UpdateSpeedState()
end

function replayconsole:OnClose() end

function replayconsole:UpdateSpeedState()
  local nSpeed = GetReplaySpeed()
  if nSpeed then
    Txt_SetTxt(self.UIGROUP, TXT_SPEED, "²¥·ÅËÙÂÊ X " .. nSpeed)

    if nSpeed == MAX_HIGHSPEED then
      Wnd_SetEnable(self.UIGROUP, BTN_SPEEDUP, 0)
    else
      Wnd_SetEnable(self.UIGROUP, BTN_SPEEDUP, 1)
    end

    if nSpeed == MIN_LOWSPEED then
      Wnd_SetEnable(self.UIGROUP, BTN_SPEEDDOWN, 0)
    else
      Wnd_SetEnable(self.UIGROUP, BTN_SPEEDDOWN, 1)
    end
  end
end

function replayconsole:OnButtonClick(szWnd, nParam)
  if szWnd == BTN_PAUSEPLAY then
    local nState = GetReplayState()
    if nState == enum_Replay_Playing then
      local bPause = IsReplayPaused()
      if bPause then
        if bPause == 0 then
          Replay("pause")
          Img_SetImage(self.UIGROUP, BTN_PAUSEPLAY, 1, SPR_BTN_PLAY)
        elseif bPause == 1 then
          Replay("continue")
          Img_SetImage(self.UIGROUP, BTN_PAUSEPLAY, 1, SPR_BTN_PAUSE)
        end
      end
    end
  elseif szWnd == BTN_CONTINUEPLAY then
    Replay("continue")
  elseif szWnd == BTN_STOPPLAY then
    Replay("stop")
  elseif szWnd == BTN_SPEEDUP then
    Replay("speedup")
    self:UpdateSpeedState()
  elseif szWnd == BTN_SPEEDDOWN then
    Replay("slowdown")
    self:UpdateSpeedState()
  elseif szWnd == BTN_SPEEDNORMAL then
    SetNormalSpeed()
    self:UpdateSpeedState()
  end
end
-----------------------------------------------------------
