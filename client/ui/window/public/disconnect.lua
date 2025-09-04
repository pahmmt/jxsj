local tbDisconnect = Ui:GetClass("disconnect")

local IMG_BACKGROUND = "ImgBackgroud"
local TXT_MSG = "TxtMsg"
local BTN_CONFIRM = "BtnConfirm"

function tbDisconnect:OnOpen()
  ForbitGameSpace(1)
end

function tbDisconnect:OnClose()
  ForbitGameSpace(0)
end

function tbDisconnect:OnButtonClick(szWnd, nParam)
  if szWnd == BTN_CONFIRM then
    UiManager:CloseWindow(self.UIGROUP)
    Ui.nExitMode = Ui.EXITMODE_SELSVR -- 退出到服务器列表
    Ui:Disconnect()
  end
end
