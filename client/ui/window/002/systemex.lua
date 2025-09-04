local tbTempData = Ui.tbLogic.tbTempData
local uiSystemEx = Ui:GetClass("systemex")

uiSystemEx.BTN_GAMESETTING = "BtnGameSetting" -- 游戏设置
uiSystemEx.BTN_RETURN = "BtnReturn" -- 返回游戏
uiSystemEx.BTN_ONLINEEXP = "BtnOnlineExp" -- 在线托管
uiSystemEx.BTN_EXIT = "BtnExit" -- 退出游戏
uiSystemEx.BTN_RETURNROLESELECT = "BtnReturnRoleSelect" -- 重选角色
uiSystemEx.BTN_RETURNLOGIN = "BtnReturnLogin" -- 返回登录界面
uiSystemEx.BTN_CAMERA = "BtnCamera" -- 录像

local enum_Replay_Recing = 1
local enum_Replay_Saving = 2

function uiSystemEx:OnOpen()
  Ui(Ui.UI_SIDEBAR):WndOpenCloseCallback(self.UIGROUP, 1)
  self:UpdateRecPlayState()
end

function uiSystemEx:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_GAMESETTING then
    UiManager:SwitchWindow(Ui.UI_SYSTEM)
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_RETURN then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_ONLINEEXP then
    self:UpdateOnlineState()
  elseif szWnd == self.BTN_EXIT then
    if IVER_g_nTwVersion == 1 then
      UiManager:OpenWindow(Ui.UI_EXITCONFIRM)
    else
      self:QuitGame("Exit")
    end
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_RETURNROLESELECT then
    Relogin()
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_RETURNLOGIN then
    Logout()
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_CAMERA then
    local nState = GetReplayState()
    if nState == enum_Replay_Recing then
      Replay("endrec")
      UiManager:OpenWindow(Ui.UI_INFOBOARD, "<color=green>结束录像<color>")
    else
      UiManager:OpenWindow(Ui.UI_INFOBOARD, "<color=green> 开始录制游戏录像")
      Replay("rec")
    end
    self:UpdateRecPlayState()
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiSystemEx:UpdateRecPlayState()
  local nState = GetReplayState()
  if nState == enum_Replay_Recing then
    Btn_SetTxt(self.UIGROUP, self.BTN_CAMERA, "停止录像")
    if UiManager:WindowVisible(Ui.UI_EXITKINESCOPE) ~= 1 then
      UiManager:OpenWindow(Ui.UI_EXITKINESCOPE)
    end
  else
    Btn_SetTxt(self.UIGROUP, self.BTN_CAMERA, "开始录像")
    if UiManager:WindowVisible(Ui.UI_EXITKINESCOPE) == 1 then
      UiManager:CloseWindow(Ui.UI_EXITKINESCOPE)
    end
  end
end

function uiSystemEx:QuitGame(szWishFun)
  if not szWishFun then
    szWishFun = "ExitGame"
  end
  if UiManager.IVER_nOpenWanLiu == 0 or (me.nLevel >= 20) then
    loadstring(szWishFun .. "()")()
  else
    UiManager:OpenWindow(Ui.UI_DETAIN)
  end
end

function uiSystemEx:UpdateOnlineState()
  local nOnlineState = Player.tbOnlineExp:GetOnlineState(me)

  local nStallState = me.nStallState
  if nStallState == Player.STALL_STAT_STALL_SELL or nStallState == Player.STALL_STAT_OFFER_BUY then -- 摆摊中
    me.Msg("摆摊后无法开启或结束在线托管，所以请先结束摆摊再开启或结束在线托管")
    return
  end

  if 1 == nOnlineState then
    me.CallServerScript({ "ApplyUpdateOnlineState", 0 })
  else
    local nRestTime = Player.tbOffline:GetLeftOfflineTime(me)
    if nRestTime <= 0 then
      me.Msg("公告：您今日的剩余托管时间为0，不能开启在线托管。")
      return
    end

    local nRestBaiju = Player.tbOffline:GetRemainBaijuTime(me)
    if nRestBaiju <= 0 then
      me.Msg("公告：您的白驹时间不足，不能开启在线托管。")
      return
    end
    AutoAi.Sit()
    me.CallServerScript({ "ApplyUpdateOnlineState", 1 })
  end
end

function uiSystemEx:OnClose()
  Ui(Ui.UI_SIDEBAR):WndOpenCloseCallback(self.UIGROUP, 0)
end

function uiSystemEx:OnRefreshOnlineBtnState()
  local nState = Player.tbOnlineExp:GetOnlineState()
  local szMsg = ""
  if 1 == nState then
    szMsg = "结束托管"
  else
    szMsg = "在线托管"
  end
  Btn_SetTxt(self.UIGROUP, self.BTN_ONLINEEXP, szMsg)
end

function uiSystemEx:OnRefreshOnlineState()
  self:OnRefreshOnlineBtnState()
  local nState = Player.tbOnlineExp:GetOnlineState()
  if 1 == nState then
    if not tbTempData.nOnlineWnd or tbTempData.nOnlineWnd == 0 then
      UiManager:OpenWindow(Ui.UI_ONLINEEXP)
    end
  else
    if tbTempData.nOnlineWnd and tbTempData.nOnlineWnd == 1 then
      UiManager:CloseWindow(Ui.UI_ONLINEEXP)
    end
  end
end

function uiSystemEx:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_UPDATEONLINEEXPSTATE, self.OnRefreshOnlineState },
  }
  return tbRegEvent
end
