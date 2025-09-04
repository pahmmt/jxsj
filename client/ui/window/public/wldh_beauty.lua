-- 文件名　：wldh_beauty.lua
-- 创建者　：zounan
-- 创建时间：2010-05-19 20:02:19
-- 描述　  ：武林大会选美 (选秀)上线提示

local Ui_WldhBeauy = Ui:GetClass("wldh_beauty")
Ui_WldhBeauy.BTN_CLOSE = "BtnClose"
Ui_WldhBeauy.IE_WND = "IEWnd"
Ui_WldhBeauy.szGameType = 1

function Ui_WldhBeauy:OnOpen(szHttp)
  local szRetUrl = szHttp
  local szMd5 = me.MD5WithGameStrAndAccount()
  szRetUrl = string.format("%s%s|%s|%s", szRetUrl, self.szGameType, me.szAccount, szMd5)
  szRetUrl = string.lower(szRetUrl)
  IE_Navigate(self.UIGROUP, self.IE_WND, szRetUrl)
  --Wnd_SetFocus(self.UIGROUP, self.EDIT_SEARCH);
end

function Ui_WldhBeauy:OnEscExclusiveWnd()
  UiManager:CloseWindow(self.UIGROUP)
end

function Ui_WldhBeauy:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end
end
