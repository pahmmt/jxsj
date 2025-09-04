-----------------------------------------------------
--文件名		：	uiRenascencePanel.lua
--创建者		：	liuchang@kingsoft.net
--创建时间	：	2007-3-15
--功能描述	：	重生面板脚本。
------------------------------------------------------

local uiRenascencePanel = Ui:GetClass("renascencepanel")

uiRenascencePanel.BTN_ACCEPT_CURE = "btnAcceptCure"
uiRenascencePanel.BTN_TAKEN_DRUG = "btnTakenDrug"
uiRenascencePanel.BTN_LOCAL_TREATMENT = "btnLocalTreatment"
uiRenascencePanel.BTN_GO_HOME = "btnGoHome"

function uiRenascencePanel:OnOpen()
  Wnd_SetEnable(self.UIGROUP, self.BTN_ACCEPT_CURE, 0)
end

function uiRenascencePanel:OnButtonClick(szWndName, nParam)
  if me.IsDead() ~= 1 then
    UiManager:CloseWindow(Ui.UI_RENASCENCEPANEL)
    return
  end

  if szWndName == self.BTN_LOCAL_TREATMENT then -- 本地复活
    me.SendClientCmdRevive(1)
  elseif szWndName == self.BTN_GO_HOME then --回城
    me.SendClientCmdRevive(0)
  elseif szWndName == self.BTN_ACCEPT_CURE then -- 接受治疗
    me.SendClientCmdRevive(2)
  end
end

function uiRenascencePanel:WhenGetCure(nLifeP, nManaP, nStaminaP)
  Wnd_SetEnable(self.UIGROUP, self.BTN_ACCEPT_CURE, 1)
end

function uiRenascencePanel:OnPlayerRevival()
  UiManager:CloseWindow(Ui.UI_RENASCENCEPANEL)
end

function uiRenascencePanel:OnPlayerDeath(szPlayer)
  -- pMsg->nConfirmType == SMCT_UI_RENASCENCE && g_QuitButtonWnd.GetIfVisible() == FALSE
  -- 关闭黑屏效果
  me.Msg("你已身受重伤！")
  UiManager:CloseWindow(Ui.UI_GUTMODEL)
  UiManager:CloseWindow(Ui.UI_GUTSAY)
  UiManager:CloseWindow(Ui.UI_GUTAWARD)
  UiManager:CloseWindow(Ui.UI_GUTTALK)
  UiManager:CloseWindow(Ui.UI_DAILY)
  UiManager:CloseWindow(Ui.UI_HELPSPRITE)
  UiManager:CloseWindow(Ui.UI_PAYONLINE)
  UiManager:OpenWindow(self.UIGROUP)
end

function uiRenascencePanel:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_PLAYER_DEATH, self.OnPlayerDeath },
    { UiNotify.emCOREEVENT_PLAYER_REVIVE, self.OnPlayerRevival },
    { UiNotify.emCOREEVENT_GET_CURE, self.WhenGetCure },
  }
  return tbRegEvent
end
