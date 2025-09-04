-------------------------------------------------------
-- 文件名　：drift_new.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2010-12-02 14:59:47
-- 文件描述：
-------------------------------------------------------

local uiDriftNew = Ui:GetClass("drift_new")

uiDriftNew.BTN_BACK = "BtnBack"
uiDriftNew.BTN_SEND = "BtnSend"
uiDriftNew.BTN_CLOSE = "BtnClose"
uiDriftNew.EDT_INPUT = "EdtInput"

function uiDriftNew:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_BACK then
    UiManager:CloseWindow(self.UIGROUP)
    UiManager:OpenWindow(Ui.UI_DRIFT_MAIN)
  elseif szWnd == self.BTN_SEND then
    local szMsg = Edt_GetTxt(self.UIGROUP, self.EDT_INPUT)
    if szMsg then
      me.CallServerScript({ "ApplyDriftAddNewMsg", szMsg })
    end
  end
end
