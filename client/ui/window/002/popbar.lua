-----------------------------------------------------
--文件名		：	popbar.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-04-19
--功能描述		：	功能工具条脚本。
------------------------------------------------------

local uiPopBar = Ui:GetClass("popbar")

uiPopBar.BTN_SIT = "BtnSit"
uiPopBar.BTN_RUN = "BtnRun"
uiPopBar.BTN_MOUNT = "BtnMount"
uiPopBar.BTN_AUTOFIGHT = "BtnAutoFight"
uiPopBar.SWITCHSTATUS_RUN = "run" --跑步
uiPopBar.SWITCHSTATUS_SIT = "sit" --打坐
uiPopBar.SWITCHSTATUS_TRADE = "trade" --交易
uiPopBar.SWITCHSTATUS_MOUNT = "horse" --马
uiPopBar.SWITCHSTATUS_SHOWNAME = "showplayername" --显示玩家名字
uiPopBar.SWITCHSTATUS_SHOWHP = "showplayerlife" --显示玩家生命
uiPopBar.SWITCHSTATUS_SHOWMP = "showplayermana" --显示玩家内力
uiPopBar.SWITCHSTATUS_SHOWPLAYERNUM = "showplayernumber" --界面显示玩家数字

function uiPopBar:Init() end

--写log
function uiPopBar:WriteStatLog(szField)
  Log:Ui_SendLog(szField, 1)
end

function uiPopBar:OnOpen()
  self:UpdateDoingState()
  self:UpdateRunState()
  self:UpdateHorseState()
  self:UpdateAutoFightState()
end

function uiPopBar:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_SIT then
    Switch(self.SWITCHSTATUS_SIT)
    self:UpdateDoingState()
  elseif szWnd == self.BTN_RUN then
    Switch(self.SWITCHSTATUS_RUN)
    self:UpdateRunState()
  elseif szWnd == self.BTN_MOUNT then
    Switch(self.SWITCHSTATUS_MOUNT)
    self:UpdateHorseState()
  elseif szWnd == self.BTN_AUTOFIGHT then
    me.AutoFight(1 - me.nAutoFightState)
    self:UpdateAutoFightState()
  end
end

function uiPopBar:UpdateHorseState()
  local bChecked = me.GetNpc().IsRideHorse()
  Btn_Check(self.UIGROUP, self.BTN_MOUNT, bChecked)
end

function uiPopBar:UpdateDoingState()
  local bChecked = 0
  if me.GetNpc().nDoing == Npc.DO_SIT then
    bChecked = 1
  end
  Btn_Check(self.UIGROUP, self.BTN_SIT, bChecked)
end

function uiPopBar:UpdateRunState()
  local bChecked = me.IsRunStatus()
  Btn_Check(self.UIGROUP, self.BTN_RUN, bChecked)
end

function uiPopBar:UpdateAutoFightState()
  local bChecked = me.nAutoFightState
  Btn_Check(self.UIGROUP, self.BTN_AUTOFIGHT, bChecked)
end

-- 保证同旧版本的快捷键（Ctrl+H）保持一致
function uiPopBar:ChangeToNextModel()
  Ui(Ui.UI_PKMODEL):ChangeToNextModel()
end

function uiPopBar:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_RIDEHORSE, self.UpdateHorseState },
    { UiNotify.emCOREEVENT_SYNC_DOING, self.UpdateDoingState },
    { UiNotify.emCOREEVENT_SYNC_RUNSTATUS, self.UpdateRunState },
    { UiNotify.emCOREEVENT_AUTO_FIGHT_STATE, self.UpdateAutoFightState },
  }
  return tbRegEvent
end
