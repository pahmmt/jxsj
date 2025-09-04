-------------------------------------------------------
-- 文件名　：drift_mine_show.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2010-12-03 15:05:14
-- 文件描述：
-------------------------------------------------------

local uiDriftMineShow = Ui:GetClass("drift_mine_show")

uiDriftMineShow.BTN_RETURN = "BtnReturn"
uiDriftMineShow.BTN_CLOSE = "BtnClose"
uiDriftMineShow.BTN_PAGEUP = "BtnPageUp"
uiDriftMineShow.BTN_PAGEDOWN = "BtnPageDown"
uiDriftMineShow.TXT_LIST_HEAD = "TxtListHead"
uiDriftMineShow.TXT_LIST_REPLY = {
  [1] = "TxtListReply1",
  [2] = "TxtListReply2",
  [3] = "TxtListReply3",
  [4] = "TxtListReply4",
}

function uiDriftMineShow:OnOpen(nIndex, tbInfo)
  if not tbInfo then
    return 0
  end
  self.nIndex = nIndex
  self.tbInfo = tbInfo
  self.nPage = 1
  self:UpdateList(self.nPage)
end

function uiDriftMineShow:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_RETURN then
    if self.tbInfo then
      UiManager:CloseWindow(self.UIGROUP)
      UiManager:OpenWindow(Ui.UI_DRIFT_MINE, self.tbInfo)
    end
  elseif szWnd == self.BTN_PAGEDOWN then
    if self.nPage and self.tbInfo and self.nIndex then
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

function uiDriftMineShow:UpdateList(nPage)
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
