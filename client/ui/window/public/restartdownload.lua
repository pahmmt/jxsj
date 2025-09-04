local uiRestartdownload = Ui:GetClass("restartdownload")

local TXT_SPPED_VALUE = "TxtSpeed2"
local TXT_PERCENT_VALUE = "TxtPercent2"
local BTN_RESTART = "BtnRestart"

function uiRestartdownload:OnOpen(...)
  self:UpdateDisplay(...)
  UiManager:SetUiState(UiManager.UIS_RESTART_DOWNLOADER)
end

function uiRestartdownload:OnClose()
  UiManager:ReleaseUiState(UiManager.UIS_RESTART_DOWNLOADER)
end

function uiRestartdownload:UpdateDisplay(...)
  local nPercent, nSpeed = unpack(arg)
  nSpeed = math.floor(nSpeed * 100 / 1024) / 100

  Txt_SetTxt(self.UIGROUP, TXT_SPPED_VALUE, nSpeed .. "KB/S")
  Txt_SetTxt(self.UIGROUP, TXT_PERCENT_VALUE, nPercent .. "%")
end

function uiRestartdownload:OnButtonClick(szWnd, nParam)
  if szWnd == BTN_RESTART then
    StartDownloaderOnForce()
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiRestartdownload:OnCheckDownloadFailed(...)
  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    UiManager:OpenWindow(self.UIGROUP, ...)
  else
    self:UpdateDisplay(...)
  end
end

-- register event
function uiRestartdownload:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_CHECK_DOWNLOADINFO_4_RESTART, self.OnCheckDownloadFailed, self },
  }
  return tbRegEvent
end

-- register message
function uiRestartdownload:RegisterMessage()
  local tbRegMsg = {}
  return tbRegMsg
end
