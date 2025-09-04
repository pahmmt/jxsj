local uiCover = Ui:GetClass("cover")

function uiCover:OnOpen() end

function uiCover:OnActived(szUiGroup)
  if szUiGroup ~= self.UIGROUP then
    return
  end
  UiCallback:HideMsgPad()
  UiManager:OpenWindow(Ui.UI_MSGPAD)
end

function uiCover:OnClose() end

function uiCover:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emUIEVENT_WND_ACTIVED, self.OnActived },
  }
  return tbRegEvent
end
