if not MODULE_GAMECLIENT then
  return
end
--关闭
do
  return
end

--组队完成后弹出确认框的key
AutoTeam.MSG_INFO_KEY = "AutoTeamConfirm"

function AutoTeam:JoinAutoTeam(nTeamType)
  me.CallServerScript({
    "AutoTeamCmd",
    "JoinAutoTeam",
    nTeamType,
  })
end

function AutoTeam:LeaveAutoTeam()
  me.CallServerScript({
    "AutoTeamCmd",
    "LeaveAutoTeam",
  })
end

--移除玩家参与组队的回调
function AutoTeam:RemovePlayer()
  self:ClearData()
  local uiTeam = assert(Ui(Ui.UI_TEAM))
  uiTeam:RefreshAutoTeam()
  UiManager:OpenWindow(Ui.UI_TASKTRACK)
end

function AutoTeam:ProcessTeamData(tbTeam)
  if tbTeam then
    self.nCurrentTeamType = tbTeam.nTeamType
    self.tbAutoTeamData = tbTeam
    self:ShowTaskTrack(tbTeam)
  else
    self:ClearData()
  end
  local uiTeam = assert(Ui(Ui.UI_TEAM))
  uiTeam:RefreshAutoTeam()
end

function AutoTeam:OnTeamDone(tbTeam)
  self:ProcessTeamData(tbTeam)
  self:ShowConfirmMsg()
end

function AutoTeam:ShowConfirmMsg()
  local tbMsg = {}
  tbMsg.szTitle = "确认组队"
  tbMsg.nOptCount = 2
  tbMsg.tbOptTitle = { "拒绝", "确认" }
  tbMsg.nTimeout = self.CONFIRM_COUNTDOWN_SECONDS
  tbMsg.szMsg = "恭喜你，队伍已匹配完成。是否同意组队并传送至活动报名点？"
  function tbMsg:Callback(nOptIndex, varParm1, varParam2, ...)
    if nOptIndex == 1 then
      AutoTeam:SendConfirmation(AutoTeam.CONFIRM_REFUSE)
    elseif nOptIndex == 2 then
      AutoTeam:SendConfirmation(AutoTeam.CONFIRM_OK)
    end
  end

  Ui.tbLogic.tbMsgInfo:DelMsg(self.MSG_INFO_KEY)
  Ui.tbLogic.tbMsgInfo:AddMsg(self.MSG_INFO_KEY, tbMsg)
end

function AutoTeam:SendConfirmation(nConfirmCode)
  me.CallServerScript({
    "AutoTeamCmd",
    "OnClientConfirm",
    nConfirmCode,
  })
end

function AutoTeam:ClearData()
  self.tbAutoTeamData = nil
  self.nCurrentTeamType = nil
  Ui.tbLogic.tbMsgInfo:DelMsg(self.MSG_INFO_KEY)
  self:HideTaskTrack()
end

function AutoTeam:OnEnterGame()
  self:ClearData()
end

function AutoTeam:OpenUi()
  if UiManager:WindowVisible(Ui.UI_TEAM) ~= 1 then
    UiManager:OpenWindow(Ui.UI_TEAM, 1)
  else
    local uiTeam = Ui(Ui.UI_TEAM)
    uiTeam:ShowAutoTeamPage()
  end
end

function AutoTeam:ShowTaskTrack(tbTeam)
  local uiTaskTrack = Ui(Ui.UI_TASKTRACK)
  local szTeamType = self:GetTeamTypeName(tbTeam.nTeamType)
  local szMsg = string.format("\n\n\n<color=yellow>自动组队中：<color=white>%s\n\n<color=green>当前列队人数：<color=white>%d<color>", szTeamType, #tbTeam.tbMember)

  local n = 0
  for _, tbMemberInfo in ipairs(tbTeam.tbMember) do
    if tbMemberInfo.bConfirmed == 1 then
      n = n + 1
    end
  end
  if n > 0 then
    szMsg = szMsg .. string.format("\n\n<color=green>已确认人数：<color=white>%d<color>", n)
  end

  uiTaskTrack:SetTxtMsg(szMsg, 2)
end

function AutoTeam:HideTaskTrack()
  local uiTaskTrack = Ui(Ui.UI_TASKTRACK)
  uiTaskTrack:SetTxtMsg("", 2)
end
