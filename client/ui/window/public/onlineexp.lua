local uiOnlineExp = Ui:GetClass("onlineexp")
local tbTempData = Ui.tbLogic.tbTempData
uiOnlineExp.BUTTON_CLOSE = "BtnCloseOnlineExp"

function uiOnlineExp:OnOpen()
  tbTempData.nOnlineWnd = 1
end

function uiOnlineExp:OnClose()
  tbTempData.nOnlineWnd = 0

  local nOnlineState = Player.tbOnlineExp:GetOnlineState(me)

  local nStallState = me.nStallState
  if nStallState == Player.STALL_STAT_STALL_SELL or nStallState == Player.STALL_STAT_OFFER_BUY then -- 摆摊中
    me.Msg("摆摊后无法开启或结束在线托管，所以请先结束摆摊再开启或结束在线托管")
    return
  end

  if 1 == nOnlineState then
    me.CallServerScript({ "ApplyUpdateOnlineState", 0 })
  end
end

function uiOnlineExp:OnButtonClick(szWnd, nParam)
  if szWnd == self.BUTTON_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end
end
