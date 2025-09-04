-------------------------------------------------------
-- 文件名　：drift_mark_show.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2010-12-03 15:09:42
-- 文件描述：
-------------------------------------------------------

local uiDriftMarkShow = Ui:GetClass("drift_mark_show")

uiDriftMarkShow.BTN_RETURN = "BtnReturn"
uiDriftMarkShow.BTN_DEMARK = "BtnDemark"
uiDriftMarkShow.BTN_CLOSE = "BtnClose"
uiDriftMarkShow.BTN_PAGEUP = "BtnPageUp"
uiDriftMarkShow.BTN_PAGEDOWN = "BtnPageDown"
uiDriftMarkShow.TXT_LIST_HEAD = "TxtListHead"
uiDriftMarkShow.TXT_LIST_REPLY = {
  [1] = "TxtListReply1",
  [2] = "TxtListReply2",
  [3] = "TxtListReply3",
  [4] = "TxtListReply4",
}

function uiDriftMarkShow:OnOpen(nIndex, tbInfo)
  if not tbInfo or not nIndex then
    return 0
  end
  self.nIndex = nIndex
  self.tbInfo = tbInfo
  self.nPage = 1
  self:UpdateList(self.nPage)
end

function uiDriftMarkShow:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_RETURN then
    if self.tbInfo then
      UiManager:CloseWindow(self.UIGROUP)
      UiManager:OpenWindow(Ui.UI_DRIFT_MARK, self.tbInfo)
    end
  elseif szWnd == self.BTN_DEMARK then
    if self.nIndex and self.tbInfo and self.tbInfo[self.nIndex] then
      me.CallServerScript({ "ApplyDriftDemarkMsg", self.tbInfo[self.nIndex].nIndex })
    end
  elseif szWnd == self.BTN_PAGEDOWN then
    if self.nPage and self.tbInfo and self.nIndex and self.tbInfo[self.nIndex] then
      local tbInfo = self.tbInfo[self.nIndex]
      if tbInfo and self.nPage <= math.floor(#tbInfo.tbReply / 4) then
        self.nPage = self.nPage + 1
        self:UpdateList(self.nPage)
      end
    end
  elseif szWnd == self.BTN_PAGEUP then
    if self.nPage and self.nPage > 1 then
      self.nPage = self.nPage - 1
      self:UpdateList(self.nPage)
    end
  end
end

function uiDriftMarkShow:UpdateList(nPage)
  if self.tbInfo and self.nIndex then
    local tbInfo = self.tbInfo[self.nIndex]
    if tbInfo then
      local szHead = string.format("<color=yellow>%s<color>", tbInfo.szHead)
      Txt_SetTxt(self.UIGROUP, self.TXT_LIST_HEAD, szHead)
      if tbInfo.tbReply then
        for i = 1, 4 do
          local szMsg = tbInfo.tbReply[(nPage - 1) * 4 + i]
          if szMsg then
            Txt_SetTxt(self.UIGROUP, self.TXT_LIST_REPLY[i], szMsg)
          else
            Txt_SetTxt(self.UIGROUP, self.TXT_LIST_REPLY[i], "")
          end
        end
      end
    end
  end
end
