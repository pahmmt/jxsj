local uiLimitTimeNotify = Ui:GetClass("limittimenotify")
local BTN_CLOSE = "BtnClose"
local BTN_FILLINFO = "BtnFillInfo"
local TXT_INFO = "TxtInfo"

function uiLimitTimeNotify:Init() end

function uiLimitTimeNotify:OnOpen(bHasInfo, nRemainTime)
  if bHasInfo == 0 then
    Wnd_SetVisible(self.UIGROUP, BTN_FILLINFO, 1)
    local szFormat = "您的帐号由于实名信息填写不足，处于防沉迷状态，<enter><enter>将于%s后强制下线。"
    local szMsg = string.format(szFormat, self:FormatTime(nRemainTime))
    Txt_SetTxt(self.UIGROUP, TXT_INFO, szMsg)
  else
    local szFormat = "由于你是防沉迷帐号，将于%s后强制下线。"
    local szMsg = string.format(szFormat, self:FormatTime(nRemainTime))
    Txt_SetTxt(self.UIGROUP, TXT_INFO, szMsg)
    Wnd_SetVisible(self.UIGROUP, BTN_FILLINFO, 0)
  end
end

function uiLimitTimeNotify:OnButtonClick(szWnd, nParam)
  if szWnd == BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == BTN_FILLINFO then
    if Ui.tbLogic.tbLogin.nLoginWay == self.LOGINWAY_YY then
      UiManager:OpenWindow(Ui.UI_LIMITPLAY, GetYyLimitUrl(), 1)
    else
      UiManager:OpenWindow(Ui.UI_LIMITPLAY, GetLimitUrl(), 1)
    end
    UiManager:CloseWindow(self.UIGROUP)
  end
end

-- 格式化时间，返回文字描述
function uiLimitTimeNotify:FormatTime(nSecond)
  if type(nSecond) ~= "number" then
    return ""
  end
  local nHour = math.floor(nSecond / 3600)
  local nMinute = math.ceil((nSecond % 3600) / 60)
  local szMsg = ""
  if nHour > 0 then
    if nMinute ~= 0 then
      return string.format("%s小时%s分钟", nHour, nMinute)
    else
      return string.format("%s小时", nHour)
    end
  else
    return string.format("%s分钟", nMinute)
  end
end
