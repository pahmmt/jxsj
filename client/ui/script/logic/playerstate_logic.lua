Ui.tbLogic.tbPlayerState = {}
local tbPlayerState = Ui.tbLogic.tbPlayerState

tbPlayerState.LOCKSTATE = 1
tbPlayerState.UNLOCKSTATE = 2

function tbPlayerState:Init()
  UiNotify:RegistNotify(UiNotify.emCOREEVENT_CHANGEWAITGETITEMSTATE, self.OnChangePlayerState, self)
end

function tbPlayerState:OnChangePlayerState(nState)
  if nState == self.UNLOCKSTATE then
    UiManager:CloseWindow(Ui.UI_LOCKSTATE)
  elseif nState == self.LOCKSTATE then
    UiManager:OpenWindow(Ui.UI_LOCKSTATE)
  end
end

function tbPlayerState:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_CHANGEWAITGETITEMSTATE, self.OnChangePlayerState },
  }
  return tbRegEvent
end
