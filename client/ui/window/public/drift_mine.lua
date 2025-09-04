-------------------------------------------------------
-- 文件名　：drift_mine.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2010-12-02 15:01:18
-- 文件描述：
-------------------------------------------------------
local uiDriftMine = Ui:GetClass("drift_mine")

uiDriftMine.BTN_RETURN = "BtnReturn"
uiDriftMine.BTN_CLOSE = "BtnClose"
uiDriftMine.BTN_PAGEUP = "BtnPageUp"
uiDriftMine.BTN_PAGEDOWN = "BtnPageDown"
uiDriftMine.TXT_LIST = {
  [1] = "TxtListReply1",
  [2] = "TxtListReply2",
  [3] = "TxtListReply3",
  [4] = "TxtListReply4",
  [5] = "TxtListReply5",
}
uiDriftMine.SHOW_LIST = {
  [1] = "BtnShow1",
  [2] = "BtnShow2",
  [3] = "BtnShow3",
  [4] = "BtnShow4",
  [5] = "BtnShow5",
}

function uiDriftMine:OnOpen(tbInfo)
  if not tbInfo then
    return 0
  end
  self.tbInfo = tbInfo
  self.nPage = 1
  self:UpdateList(self.nPage)
end

function uiDriftMine:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_RETURN then
    UiManager:CloseWindow(self.UIGROUP)
    UiManager:OpenWindow(Ui.UI_DRIFT_MAIN)
  elseif szWnd == self.BTN_PAGEDOWN then
    if self.nPage and self.tbInfo and self.nPage <= math.floor(#self.tbInfo / 5) then
      self.nPage = self.nPage + 1
      self:UpdateList(self.nPage)
    end
  elseif szWnd == self.BTN_PAGEUP then
    if self.nPage and self.nPage > 1 then
      self.nPage = self.nPage - 1
      self:UpdateList(self.nPage)
    end
  else
    for nIndex, szKey in pairs(self.SHOW_LIST) do
      if szWnd == szKey and self.tbInfo and self.nPage then
        UiManager:CloseWindow(self.UIGROUP)
        UiManager:OpenWindow(Ui.UI_DRIFT_MINE_SHOW, nIndex + (self.nPage - 1) * 5, self.tbInfo)
      end
    end
  end
end

function uiDriftMine:UpdateList(nPage)
  if self.tbInfo then
    for i = 1, 5 do
      if self.tbInfo[(nPage - 1) * 5 + i] then
        local szMsg = self.tbInfo[(nPage - 1) * 5 + i].szHead
        if szMsg then
          if string.len(szMsg) > 40 then
            szMsg = string.sub(szMsg, 1, 40) .. "..."
          end
          Txt_SetTxt(self.UIGROUP, self.TXT_LIST[i], string.format("<color=yellow>%s<color>", szMsg))
        else
          Txt_SetTxt(self.UIGROUP, self.TXT_LIST[i], "")
        end
        Wnd_SetEnable(self.UIGROUP, self.SHOW_LIST[i], 1)
      else
        Txt_SetTxt(self.UIGROUP, self.TXT_LIST[i], "")
        Wnd_SetEnable(self.UIGROUP, self.SHOW_LIST[i], 0)
      end
    end
  end
end
