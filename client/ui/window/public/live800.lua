-- 文件名　：live800.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-11-28 12:31:15
-- 功能说明：live800
--??UiManager:OpenWindow("UI_LIVE800")

local uiLive800 = Ui:GetClass("live800")
uiLive800.IE_URL = "IE_URL"
uiLive800.Btn_Close = "Btn_Close"

uiLive800.szUrl = "http://chat.kefu.xoyo.com/live800/chatClient/chatbox.jsp?companyID=8910&configID=10&info=%s&enterurl=【剑侠世界】【%s】【%s】剑"

function uiLive800:OnOpen()
  local szEncode = string.upper(UrlEncode(AnsiToUtf8(string.format("%s%s%s%skingsoft@321!", me.szAccount, me.szName, me.szName, GetTime() * 1000))))
  local szHashCode = string.upper(StringToMD5(szEncode))
  local szInfo = AnsiToUtf8(string.format("userId=%s&loginname=%s&name=%s&hashCode=%s&timestamp=%s", me.szAccount, me.szName, me.szName, szHashCode, GetTime() * 1000))
  local szUrl = string.format(AnsiToUtf8(self.szUrl), UrlEncode(szInfo), AnsiToUtf8(GetServerName()), AnsiToUtf8(me.szName))
  IE_Navigate(self.UIGROUP, self.IE_URL, szUrl)
end

function uiLive800:OnButtonClick(szWnd, nParam)
  if szWnd == self.Btn_Close then
    IE_Navigate(self.UIGROUP, self.IE_URL, "http://jxsj.xoyo.com/")
    UiManager:CloseWindow(self.UIGROUP)
  end
end
