local uiLookerEsc = Ui:GetClass("lookeresc")
uiLookerEsc.BUTTON_CLOSE = "BtnEscLooker"

function uiLookerEsc:OnOpen() end

function uiLookerEsc:OnClose() end

function uiLookerEsc:OnButtonClick(szWnd, nParam)
  if szWnd == self.BUTTON_CLOSE then
    me.CallServerScript({ "ApplyEscLooker" })
    UiManager:CloseWindow(self.UIGROUP)
  end
end
