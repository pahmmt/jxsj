-------------------------------------------------------
-- 文件名　：drift_reply.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2010-12-03 15:16:30
-- 文件描述：
-------------------------------------------------------

local uiDriftReply = Ui:GetClass("drift_reply")

uiDriftReply.BTN_BACK = "BtnBack"
uiDriftReply.BTN_SEND = "BtnSend"
uiDriftReply.BTN_CLOSE = "BtnClose"
uiDriftReply.EDT_INPUT = "EdtInput"

function uiDriftReply:OnOpen(nIndex)
  self.nIndex = nIndex
end

function uiDriftReply:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_BACK then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_SEND then
    local szMsg = Edt_GetTxt(self.UIGROUP, self.EDT_INPUT)
    if szMsg and self.nIndex then
      me.CallServerScript({ "ApplyDriftReplyMsg", self.nIndex, szMsg })
    end
  end
end
