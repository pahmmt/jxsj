local tbReport = Ui:GetClass("report")

local BTN_ACCEPT = "BtnAccept"
local BTN_CANCEL = "BtnCancel"
local BTN_CLOSE = "BtnClose"
local TXT_TITLE = "TxtTitle"
local TXT_CONTENT = "TxtContent"

function tbReport:Init()
  self.tbParam = {}
end

function tbReport:OnOpen(tbParam, szTitle)
  if tbParam then
    self.tbParam = tbParam
    local szContent = self.tbParam:OnShow()
    Txt_SetTxt(self.UIGROUP, TXT_CONTENT, szContent)
    Txt_SetTxt(self.UIGROUP, TXT_TITLE, szTitle)
  end
end

function tbReport:OnEscExclusiveWnd(szWnd)
  UiManager:CloseWindow(self.UIGROUP)
end

function tbReport:OnButtonClick(szWnd, nParam)
  if szWnd == BTN_ACCEPT then
    self.tbParam:OnAccept()
    UiManager:CloseWindow(self.UIGROUP)
  elseif (szWnd == BTN_CANCEL) or (szWnd == BTN_CLOSE) then
    self.tbParam:OnCancel()
    UiManager:CloseWindow(self.UIGROUP)
  end
end
