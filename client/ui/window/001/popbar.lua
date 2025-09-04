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
uiPopBar.BTN_PK = "BtnPk"
uiPopBar.BTN_REC = "BtnRec"
uiPopBar.SWITCHSTATUS_RUN = "run" --跑步
uiPopBar.SWITCHSTATUS_SIT = "sit" --打坐
uiPopBar.SWITCHSTATUS_TRADE = "trade" --交易
uiPopBar.SWITCHSTATUS_MOUNT = "horse" --马
uiPopBar.SWITCHSTATUS_SHOWNAME = "showplayername" --显示玩家名字
uiPopBar.SWITCHSTATUS_SHOWHP = "showplayerlife" --显示玩家生命
uiPopBar.SWITCHSTATUS_SHOWMP = "showplayermana" --显示玩家内力
uiPopBar.SWITCHSTATUS_SHOWPLAYERNUM = "showplayernumber" --界面显示玩家数字
uiPopBar.IMG_DISMOUNT = "\\image\\ui\\001a\\main\\btn_pop_dismount.spr"
uiPopBar.IMG_MOUNT = "\\image\\ui\\001a\\main\\btn_pop_mount.spr"
uiPopBar.IMG_RUN = "\\image\\ui\\001a\\main\\btn_pop_run.spr"
uiPopBar.IMG_WALK = "\\image\\ui\\001a\\main\\btn_pop_walk.spr"

uiPopBar.PKMODE = {
  [Player.emKPK_STATE_PRACTISE] = { "练功模式", 0xFF7BD794, "\\image\\ui\\002a\\pkmodel\\anneal.spr" },
  [Player.emKPK_STATE_CAMP] = { "阵营模式", 0xFFFFC352, "\\image\\ui\\002a\\pkmodel\\camp_pk.spr" },
  [Player.emKPK_STATE_TONG] = { "帮会模式", 0xFF399ED6, "\\image\\ui\\002a\\pkmodel\\tong_pk.spr" },
  [Player.emKPK_STATE_KIN] = { "家族模式", 0xFF399ED6, "\\image\\ui\\002a\\pkmodel\\tong_pk.spr" },
  [Player.emKPK_STATE_BUTCHER] = { "屠杀模式", 0xFFF7595A, "\\image\\ui\\002a\\pkmodel\\butcher.spr" },
  [Player.emKPK_STATE_UNION] = { "联盟模式", 0xFF399ED6, "\\image\\ui\\002a\\pkmodel\\tong_pk.spr" },
  [Player.emKPK_STATE_EXTENSION] = { "自定义模式", 0xFFFFC352, "\\image\\ui\\002a\\pkmodel\\camp_pk.spr" },
}

local enum_Replay_Recing = 1
local enum_Replay_Saving = 2

local SPR_BTN_REC = "\\image\\ui\\001a\\recplayer\\btn_rec.spr"
local SPR_BTN_STOPREC = "\\image\\ui\\001a\\recplayer\\btn_stoprec.spr"

function uiPopBar:Init()
  self.nBtn = 0
  self.bExclusive = 0
  self.fnLButton = nil
  self.fnRButton = nil
end

--写log
function uiPopBar:WriteStatLog(szField)
  Log:Ui_SendLog(szField, 1)
end

function uiPopBar:OnOpen()
  self:UpdatePKModel(1)
  self:UpdateRecPlayState()
end

function uiPopBar:OnButtonClick(szWnd, nParam)
  self:ReleaseAllAction()
  if szWnd == self.BTN_SIT then
    Switch(self.SWITCHSTATUS_SIT)
  elseif szWnd == self.BTN_RUN then
    Switch(self.SWITCHSTATUS_RUN)
  elseif szWnd == self.BTN_MOUNT then
    Switch(self.SWITCHSTATUS_MOUNT)
  elseif szWnd == self.BTN_PK then
    if me.IsFreshPlayer() == 1 then
      UiManager:OpenWindow(Ui.UI_INFOBOARD, "50级以下的玩家或白名玩家不能切换战斗模式！")
      return
    end
    local nKinId, _ = 0
    nKinId, _ = me.GetKinMember()
    UiManager:SwitchWindow(Ui.UI_FIGHTMODE)
  elseif szWnd == self.BTN_REC then
    local nState = GetReplayState()
    if nState == enum_Replay_Recing then
      Replay("endrec")
    else
      UiManager:OpenWindow(Ui.UI_INFOBOARD, "<color=green> 开始录制游戏录像！<color>")
      Replay("rec")
    end
    self:UpdateRecPlayState()
  elseif nParam > 0 then
  end
end

function uiPopBar:UpdateRecPlayState()
  local nState = GetReplayState()
  if nState == enum_Replay_Recing then
    Img_SetImage(self.UIGROUP, self.BTN_REC, 1, SPR_BTN_STOPREC)
    Wnd_SetTip(self.UIGROUP, self.BTN_REC, "停止录像")
  else
    Img_SetImage(self.UIGROUP, self.BTN_REC, 1, SPR_BTN_REC)
    Wnd_SetTip(self.UIGROUP, self.BTN_REC, "开始录像")
  end
end

function uiPopBar:ReleaseAllAction()
  return
end

function uiPopBar:UpdateHorseState()
  local bChecked = me.GetNpc().IsRideHorse()
  if bChecked == 1 then
    Img_SetImage(self.UIGROUP, self.BTN_MOUNT, 1, self.IMG_DISMOUNT)
  else
    Img_SetImage(self.UIGROUP, self.BTN_MOUNT, 1, self.IMG_MOUNT)
  end
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
  if bChecked == 1 then
    Img_SetImage(self.UIGROUP, self.BTN_RUN, 1, self.IMG_WALK)
  else
    Img_SetImage(self.UIGROUP, self.BTN_RUN, 1, self.IMG_RUN)
  end
end

function uiPopBar:UpdatePKModel()
  if me.nPkModel == Player.emKPK_STATE_PRACTISE then
    me.Msg("PK状态变为练功模式！")
  elseif me.nPkModel == Player.emKPK_STATE_CAMP then
    me.Msg("PK状态变为阵营模式！")
  elseif me.nPkModel == Player.emKPK_STATE_TONG then
    local nKinId = me.GetKinMember()
    if me.dwTongId > 0 then
      me.Msg("PK状态变为帮会模式！")
      self.PKMODE[me.nPkModel][1] = "帮会模式"
    elseif nKinId and nKinId > 0 then
      me.Msg("PK状态变为家族模式！")
      self.PKMODE[me.nPkModel][1] = "家族模式"
    elseif nKinId and nKinId <= 0 and me.dwTongId <= 0 then
      return
    end
  elseif me.nPkModel == Player.emKPK_STATE_BUTCHER then
    me.Msg("PK状态变为屠杀模式！")
  elseif me.nPkModel == Player.emKPK_STATE_UNION then
    me.Msg("PK状态变为联盟模式")
  elseif me.nPkModel == Player.emKPK_STATE_EXTENSION then
    me.Msg("PK状态变为自定义模式")
  elseif me.nPkModel == Player.emKPK_STATE_KIN then
    me.Msg("PK状态变为家族模式！")
  end

  Btn_SetTxt(self.UIGROUP, self.BTN_PK, self.PKMODE[me.nPkModel][1])
  Btn_SetTextColor(self.UIGROUP, self.BTN_PK, self.PKMODE[me.nPkModel][2])
  Img_SetImage(self.UIGROUP, self.BTN_PK, 1, self.PKMODE[me.nPkModel][3])
end

function uiPopBar:ChangeToNextModel()
  if me.IsFreshPlayer() == 1 then
    UiManager:OpenWindow(Ui.UI_INFOBOARD, "50级以下的玩家或白名玩家不能切换战斗模式！")
    return
  end

  local tbSel = {
    --Player.emKPK_STATE_PRACTISE,
    Player.emKPK_STATE_CAMP,
    Player.emKPK_STATE_TONG,
    --Player.emKPK_STATE_KIN,
    Player.emKPK_STATE_BUTCHER,
  }
  local nNowSel = 0
  for i, v in ipairs(tbSel) do
    if v == me.nPkModel then
      nNowSel = i
      break
    end
  end
  nNowSel = nNowSel % #tbSel + 1

  -- 注意顺序，逻辑上暗示家族在帮会的后面了，不然代码难写
  local nKinId, _ = me.GetKinMember()
  if nKinId == 0 and tbSel[nNowSel] == Player.emKPK_STATE_TONG then
    nNowSel = nNowSel % #tbSel + 1
  end
  --	if (tbSel[nNowSel] == Player.emKPK_STATE_KIN) then
  --		local nKinId, _ = me.GetKinMember();
  --		if (nKinId == 0) then
  --			nNowSel = nNowSel % #tbSel + 1;
  --		end
  --	end

  me.nPkModel = tbSel[nNowSel]

  self:WriteStatLog("PK状态切换")
end

function uiPopBar:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_RIDEHORSE, self.UpdateHorseState },
    { UiNotify.emCOREEVENT_SYNC_DOING, self.UpdateDoingState },
    { UiNotify.emCOREEVENT_SYNC_RUNSTATUS, self.UpdateRunState },
    { UiNotify.emCOREEVENT_SYNC_PK_MODEL, self.UpdatePKModel },
  }
  return tbRegEvent
end
