local uiPayOnline = Ui:GetClass("payonline")

uiPayOnline.BTN_CLOSE = "BtnClose"
uiPayOnline.WEBSITE = Mail.IVER_szWebSite
uiPayOnline.REFRESH_THRESHOLD = 15 --打开页面，经过指定时间不关，即判定为有充值。单位秒

uiPayOnline.tbRefreshInterval = { 10, 60, 10 * 60, 60 * 60 } --刷新金币时间间隔，单位秒

function uiPayOnline:Init() end

function uiPayOnline:OnRecvZoneOpen(szZoneName)
  if 1 == IVER_g_nTwVersion or 1 == IVER_g_nMyVersion then
    OpenWebSite(GetPayUrl())
    self.nOpenTime = GetTime()
    self:Close()
    return
  end
  local tbLogin = Ui.tbLogic.tbLogin
  if tbLogin:GetLoginWay() == tbLogin.LOGINWAY_YY then
    local szServerId = string.sub(szZoneName, 2) or ""
    ShellExecute(GetYyPayUrl(szServerId))
    return
  end

  -- 新浪的充值页面
  if SINA_CLIENT then
    OpenWebSite(GetPayUrl())
    self.nOpenTime = GetTime()
    self:Close()
    return
  end

  self.szZoneName = szZoneName
  UiManager:OpenWindow(Ui.UI_PAYONLINE, szZoneName)
end

function uiPayOnline:PreOpen()
  if GblTask:GetUiFunSwitch(Ui.UI_PAYONLINE) == 1 then
    return 1
  else
    local szWebSite = GetPayUrl() .. string.format("?action=initQuery&account=%s&gateway=%s", me.szAccount, self.szZoneName or "")
    if 1 == IVER_g_nTwVersion or 1 == IVER_g_nMyVersion or SINA_CLIENT then
      szWebSite = GetPayUrl()
    end
    OpenWebSite(szWebSite)
    return 0
  end
end

function uiPayOnline:RefreshMoney()
  local nReturn = 0
  me.CallServerScript({ "ApplyAccountInfo" }) --刷新金币数

  self.nRefreshCount = self.nRefreshCount + 1

  if self.nRefreshCount > #self.tbRefreshInterval then
    self.nTimerIdRefreshMoney = nil
    nReturn = 0
  else
    nReturn = self.tbRefreshInterval[self.nRefreshCount] * Env.GAME_FPS
  end

  return nReturn
end

function uiPayOnline:OnOpen(szZoneName)
  local szWebSite = GetPayUrl()
  szWebSite = szWebSite .. string.format("?action=initQuery&account=%s&gateway=%s", me.szAccount, szZoneName)
  if 1 == IVER_g_nTwVersion or 1 == IVER_g_nMyVersion or SINA_CLIENT then
    OpenWebSite(GetPayUrl())
    self.nOpenTime = GetTime()
    self:Close()
    return
  else
    IE_Navigate(self.UIGROUP, "IEWnd", szWebSite)
    self.nOpenTime = GetTime()
  end
end

function uiPayOnline:OnEscExclusiveWnd()
  self:Close()
end

function uiPayOnline:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    self:Close()
    return
  end
end

function uiPayOnline:Close()
  local nCloseTime = GetTime()

  if GblTask:GetUiFunSwitch("PAYONLINE_REFRESH_MONEY") == 1 and nCloseTime - self.nOpenTime >= self.REFRESH_THRESHOLD then
    if not self.nPrevCoin then
      self.nPrevCoin = me.GetJbCoin()
    end

    if self.nTimerIdRefreshMoney then
      Timer:Close(self.nTimerIdRefreshMoney)
      self.nTimerIdRefreshMoney = nil
    end

    self.nRefreshCount = 0
    self.nTimerIdRefreshMoney = Timer:Register(1, self.RefreshMoney, self)
  end

  UiManager:CloseWindow(self.UIGROUP)
end

function uiPayOnline:OnCoinChanged()
  if not self.nPrevCoin then
    self.nPrevCoin = me.GetJbCoin()
    return
  end

  local nCoin = me.GetJbCoin()
  if nCoin > self.nPrevCoin then
    if self.nTimerIdRefreshMoney then
      Timer:Close(self.nTimerIdRefreshMoney)
      self.nTimerIdRefreshMoney = nil
    end
  end

  self.nPrevCoin = nCoin
end

function uiPayOnline:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_JBCOIN_CHANGED, self.OnCoinChanged },
  }
  return tbRegEvent
end

--??DoScript("\\ui\\script\\window\\payonline.lua")

--?? Ui: ReLoad("window\\payonline.lua", Ui.UI_PAYONLINE)
