-------------------------------------------------------
-- 文件名　：drift_pick.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2010-12-02 15:00:18
-- 文件描述：
-------------------------------------------------------

local uiDriftPick = Ui:GetClass("drift_pick")

uiDriftPick.BTN_RETURN = "BtnReturn"
uiDriftPick.BTN_REPLY = "BtnReply"
uiDriftPick.BTN_MARK = "BtnMark"
uiDriftPick.BTN_CLOSE = "BtnClose"
uiDriftPick.BTN_PAGEUP = "BtnPageUp"
uiDriftPick.BTN_PAGEDOWN = "BtnPageDown"
uiDriftPick.TXT_LIST_HEAD = "TxtListHead"
uiDriftPick.TXT_LIST_REPLY = {
  [1] = "TxtListReply1",
  [2] = "TxtListReply2",
  [3] = "TxtListReply3",
  [4] = "TxtListReply4",
}

function uiDriftPick:OnOpen(nIndex, tbInfo, nReply)
  if not nIndex or not tbInfo then
    return 0
  end
  self.nIndex = nIndex
  self.tbInfo = tbInfo
  self.nPage = 1
  self:UpdateList(self.nPage)
  if nReply == 1 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_REPLY, 0)
  end
end

function uiDriftPick:OnClose()
  me.CallServerScript({ "ApplyDriftReturnMsg", self.nIndex })
end

function uiDriftPick:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_RETURN then
    if self.nIndex then
      UiManager:CloseWindow(self.UIGROUP)
      UiManager:OpenWindow(Ui.UI_DRIFT_MAIN)
    end
  elseif szWnd == self.BTN_REPLY then
    if self.nIndex then
      UiManager:OpenWindow(Ui.UI_DRIFT_REPLY, self.nIndex)
    end
  elseif szWnd == self.BTN_MARK then
    if self.nIndex then
      me.CallServerScript({ "ApplyDriftMarkMsg", self.nIndex })
    end
  elseif szWnd == self.BTN_PAGEDOWN then
    if self.nPage and self.tbInfo and self.nPage <= math.floor(#self.tbInfo.tbReply / 4) then
      self.nPage = self.nPage + 1
      self:UpdateList(self.nPage)
    end
  elseif szWnd == self.BTN_PAGEUP then
    if self.nPage and self.nPage > 1 then
      self.nPage = self.nPage - 1
      self:UpdateList(self.nPage)
    end
  end
end

function uiDriftPick:UpdateList(nPage)
  if self.tbInfo then
    local szHead = string.format("<color=yellow>%s<color>", self.tbInfo.szHead)
    Txt_SetTxt(self.UIGROUP, self.TXT_LIST_HEAD, szHead)
    if self.tbInfo.tbReply then
      for i = 1, 4 do
        local szMsg = self.tbInfo.tbReply[(nPage - 1) * 4 + i]
        if szMsg then
          Txt_SetTxt(self.UIGROUP, self.TXT_LIST_REPLY[i], szMsg)
        else
          Txt_SetTxt(self.UIGROUP, self.TXT_LIST_REPLY[i], "")
        end
      end
    end
  end
end
