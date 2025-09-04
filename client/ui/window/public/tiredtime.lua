local tbTiredTime = Ui:GetClass("tiredtime")
local PRG_TRIEDTIME = "ImgTriedTimeProgress"

function tbTiredTime:OnOpen()
  self:UpdateTiredTime()
end

function tbTiredTime:OnMouseEnter(szWnd)
  if szWnd == PRG_TRIEDTIME then
    local nTiredTime = me.GetTiredOnlineTime()
    local nHour = math.floor(nTiredTime / 3600)
    local nMinute = math.floor((nTiredTime - (nHour * 3600)) / 60)
    local szMsg = string.format("当前在线时间: %d时%d分", nHour, nMinute)
    Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, "沉迷系统", szMsg)
  end
end

function tbTiredTime:OnMouseLeave(szWnd)
  Wnd_HideMouseHoverInfo()
end

function tbTiredTime:UpdateTiredTime()
  Prg_SetPos(self.UIGROUP, PRG_TRIEDTIME, me.GetTiredOnlineTime() / me.GetMaxTiredOnlineTime() * 1000)
end

function tbTiredTime:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_TIREDTIME, self.UpdateTiredTime },
  }
  return tbRegEvent
end
