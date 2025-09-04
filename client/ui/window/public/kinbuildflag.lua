-- 文件名　：kinbuildflag.lua
-- 创建者　：fenghewen
-- 创建时间：2008-12-2 14:11:16

local uiBuiudFlag = Ui:GetClass("kinbuildflag")

uiBuiudFlag.BUTTON_CONFIRM = "Btn_Confirm"
uiBuiudFlag.BUTTON_CANCEL = "Btn_Cancel"
uiBuiudFlag.BUTTON_CLOSE_WINDOW = "Btn_Close"
uiBuiudFlag.CMB_HOUR = "Cmb_Hour"
uiBuiudFlag.CMB_MIN = "Cmb_Min"

uiBuiudFlag.tbHour = { "  19", "  20", "  21", "  22", "  23" }

uiBuiudFlag.tbMin = { "  30", "  00", "  15", "  45" }

uiBuiudFlag.nHourSelected = 19
uiBuiudFlag.nMinSelected = 30

function uiBuiudFlag:OnOpen()
  -- 填充下拉菜单
  ClearComboBoxItem(self.UIGROUP, self.CMB_HOUR)
  for i = 1, #self.tbHour do
    ComboBoxAddItem(self.UIGROUP, self.CMB_HOUR, i, self.tbHour[i])
  end
  ComboBoxSelectItem(self.UIGROUP, self.CMB_HOUR, 0)

  ClearComboBoxItem(self.UIGROUP, self.CMB_MIN)
  for i = 1, #self.tbMin do
    ComboBoxAddItem(self.UIGROUP, self.CMB_MIN, i, self.tbMin[i])
  end
  ComboBoxSelectItem(self.UIGROUP, self.CMB_MIN, 0)
end

function uiBuiudFlag:OnClose() end

function uiBuiudFlag:OnButtonClick(szWnd, nParam)
  if szWnd == self.BUTTON_CANCEL or szWnd == self.BUTTON_CLOSE_WINDOW then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BUTTON_CONFIRM then
    UiManager:CloseWindow(self.UIGROUP)

    me.CallServerScript({
      "KinCmd",
      "CheckBuildFlagOrderTime",
      self.nHourSelected,
      self.nMinSelected,
      me.nId,
      me.dwKinId,
    })
  end
end

function uiBuiudFlag:OnComboBoxIndexChange(szWnd, nIndex)
  if szWnd == self.CMB_HOUR then
    self.nHourSelected = tonumber(uiBuiudFlag.tbHour[nIndex + 1])
  end
  if szWnd == self.CMB_MIN then
    self.nMinSelected = tonumber(uiBuiudFlag.tbMin[nIndex + 1])
  end
end
