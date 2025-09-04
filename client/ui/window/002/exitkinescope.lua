local uiReplayEsc = Ui:GetClass("exitkinescope")

uiReplayEsc.BUTTON_CLOSE = "BtnEscReplayRecing"
local enum_Replay_Recing = 1
local enum_Replay_Saving = 2

function uiReplayEsc:OnOpen() end

function uiReplayEsc:OnClose() end

function uiReplayEsc:OnButtonClick(szWnd, nParam)
  if szWnd == self.BUTTON_CLOSE then
    local nState = GetReplayState()
    if nState == enum_Replay_Recing then
      Replay("endrec")
      UiManager:OpenWindow(Ui.UI_INFOBOARD, "<color=green>½áÊøÂ¼Ïñ<color>")
    end
    UiManager:CloseWindow(self.UIGROUP)
  end
end
