-------------------------------------------------------
-- 文件名　：drift_main.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2010-12-02 14:59:16
-- 文件描述：
-------------------------------------------------------

local uiDriftMain = Ui:GetClass("drift_main")

uiDriftMain.TXT_NEW_LEFT = "TxtNewLeft"
uiDriftMain.TXT_PICK_LEFT = "TxtPickLeft"
uiDriftMain.BTN_NEW = "BtnNew"
uiDriftMain.BTN_PICK = "BtnPick"
uiDriftMain.BTN_MINE = "BtnMine"
uiDriftMain.BTN_MARK = "BtnMark"
uiDriftMain.BTN_CLOSE = "BtnClose"

function uiDriftMain:OnOpen()
  local nNewLeft = 2 - me.GetTask(2149, 1)
  local nPickLeft = 10 - me.GetTask(2149, 2)
  if nNewLeft <= 0 then
    nNewLeft = 0
    Wnd_SetEnable(self.UIGROUP, self.BTN_NEW, 0)
  end
  if nPickLeft <= 0 then
    nPickLeft = 0
    Wnd_SetEnable(self.UIGROUP, self.BTN_PICK, 0)
  end
  Txt_SetTxt(self.UIGROUP, self.TXT_NEW_LEFT, string.format("今日剩余次数：<color=yellow>%s<color>", nNewLeft))
  Txt_SetTxt(self.UIGROUP, self.TXT_PICK_LEFT, string.format("今日剩余次数：<color=yellow>%s<color>", nPickLeft))
end

function uiDriftMain:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_NEW then
    me.CallServerScript({ "ApplyDriftApplyNewMsg" })
  elseif szWnd == self.BTN_PICK then
    me.CallServerScript({ "ApplyDriftPickMsg" })
  elseif szWnd == self.BTN_MINE then
    me.CallServerScript({ "ApplyDriftMineMsg" })
  elseif szWnd == self.BTN_MARK then
    me.CallServerScript({ "ApplyDriftMymarkMsg" })
  end
end
