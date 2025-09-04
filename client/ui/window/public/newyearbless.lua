local uiNewYearBless = Ui:GetClass("newyearbless")
uiNewYearBless.TXT_CONTENT = "TxtContent"
uiNewYearBless.BTN_QUIT = "BtnQuit"

function uiNewYearBless:OnOpen(szText)
  szText = szText or ""
  Txt_SetTxt(self.UIGROUP, self.TXT_CONTENT, "    " .. szText)
end

function uiNewYearBless:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_QUIT then
    UiManager:CloseWindow(self.UIGROUP)
  end
end
