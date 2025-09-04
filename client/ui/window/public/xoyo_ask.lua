-------------------------------------------------------
-- 文件名　: xoyo_ask.lua
-- 创建者　: zhangjinpin@kingsoft
-- 创建时间: 2011-06-02 09:46:14
-- 文件描述:
-------------------------------------------------------

local uiXoyoAsk = Ui:GetClass("xoyo_ask")

uiXoyoAsk.BTN_CLOSE = "BtnClose"
uiXoyoAsk.IE_WND = "IEWnd"

function uiXoyoAsk:OnOpen()
  Wnd_Show(self.UIGROUP, self.IE_WND)

  local szUrl = UiManager.IVER_szHelp_JXASK_URL
  local szGameId = "8"
  local szGameStr = "ask.client.jxsj"
  local szPassPort = me.szAccount
  local szZoneServer = GetServerName()
  local szRoleName = me.szName

  szZoneServer = string.gsub(szZoneServer, "^【.*%s+([^ ]*)】.*$", "%1")
  szZoneServer = string.gsub(szZoneServer, "^([^ ]*)%s+%-%s+.*$", "%1")
  szZoneServer = string.gsub(szZoneServer, "^%s*(.-)%s*$", "%1")

  local szVerify = string.format("%s&&%s&&%s&&%s", szGameStr, szPassPort, szZoneServer, szRoleName)
  local szMD5 = StringToMD5(szVerify)
  szMD5 = string.lower(szMD5)
  local szKey = string.format("%s||%s||%s||%s||%s", szGameId, szPassPort, szZoneServer, szRoleName, szMD5)
  local szBase64 = TOOLS_EncryptBase64(szKey)
  local szEncode = UrlEncode(szBase64)

  IE_Navigate(self.UIGROUP, self.IE_WND, szUrl .. szEncode)
end

function uiXoyoAsk:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end
end
