-----------------------------------------------------
--文件名		：	skillbar.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间	：	2007-04-19
--功能描述	：	左右键技能面板脚本。
------------------------------------------------------

local uiSkillBar = Ui:GetClass("skillbar")
local tbObject = Ui.tbLogic.tbObject

uiSkillBar.OBJ_SKILL = "ObjSkill"
uiSkillBar.DATA_KEY = "ImmeSkill"
uiSkillBar.PROCESSANGER = "WndProgressAnger"

uiSkillBar.ANGERDIR = "\\image\\ui\\001a\\main\\angerskill\\bg_main_full.spr"
uiSkillBar.UNANGERDIR = "\\image\\ui\\001a\\main\\angerskill\\bg_main.spr"
uiSkillBar.ANGERPROGRESS = "\\image\\ui\\001a\\main\\angerskill\\progress_full.spr"
uiSkillBar.UNANGERPROGRESS = "\\image\\ui\\001a\\main\\angerskill\\progress.spr"

uiSkillBar.WEAPONSKILLIDLIMIT = 10
uiSkillBar.TASK_ID = 10
uiSkillBar.TASK_GROUP = 4 -- 快捷栏任务变量组号

uiSkillBar.MAXANGER = 10000
uiSkillBar.ANGERTIME = 30
uiSkillBar.FRAMETIME = Env.GAME_FPS

local tbCont = { bShowCd = 1, bUse = 0, bLink = 0, bSwitch = 0 } -- 不允许链接操作

function uiSkillBar:OnCreate()
  self.tbCont = tbObject:RegisterContainer(self.UIGROUP, self.OBJ_SKILL, 2, 1, tbCont)
end

function uiSkillBar:UpdateAllObj()
  self.tbCont:Update(0)
  self.tbCont:Update(1)
end

function uiSkillBar:OnDestroy()
  tbObject:UnregContainer(self.tbCont)
end
function uiSkillBar:OnOpen()
  self:Update()
  self:OnSetUnAngerProgress()
  self:OnSetAngerProgress()
  for i = 0, 1 do
    ObjGrid_ShowSubScript(self.UIGROUP, self.OBJ_SKILL, 1, i, 0)
  end
  self.nSkillStateTimer = Timer:Register(3, self.UpdateAllObj, self)
end

function uiSkillBar:OnClose()
  if self.nSkillStateTimer then
    Timer:Close(self.nSkillStateTimer)
    self.nSkillStateTimer = nil
  end
end

function uiSkillBar:OnSetUnAngerProgress()
  local nNowAnger, nTime = FightSkill:GetAngerState()
  Prg_SetPos(self.UIGROUP, self.PROCESSANGER, nNowAnger / self.MAXANGER * 1000)
end

function uiSkillBar:OnSetAngerProgress()
  local nNowAnger, nTime = FightSkill:GetAngerState()
  local nNowTime = GetTime()
  if nTime > 0 and nNowTime >= nTime then
    if nNowTime - nTime < self.ANGERTIME then
      local nAngerProgress = self.ANGERTIME - (nNowTime - nTime)
      Prg_SetTime(self.UIGROUP, self.PROCESSANGER, nAngerProgress * self.FRAMETIME / self.FRAMETIME * 1000, 1)
    else
      self:ResetAngerWindow()
    end
  else
    self:ResetAngerWindow()
  end
end

function uiSkillBar:ResetAngerWindow()
  Prg_Reset(self.UIGROUP, self.PROCESSANGER)
  self:OnSetUnAngerProgress()
end

function uiSkillBar:OnObjGridSwitch(szWnd, nX, nY)
  if self._disable_switch_skill then
    return
  end
  --在载具上不允许改变技能
  --TODO: 可以改变skilltree信息，这样就不用锁死
  if me.IsInCarrier() == 1 then
    return
  end

  if szWnd == self.OBJ_SKILL then
    if nX == 0 then
      UiManager:SwitchWindow(Ui.UI_SKILLTREE, "LEFT")
    elseif nX == 1 then
      UiManager:SwitchWindow(Ui.UI_SKILLTREE, "RIGHT")
    end
  end
end

local nLastErr
local nLastMsgTime
local nLastPopoTime
function uiSkillBar:OnUseSkillFailed(nErr, nSkillId)
  local nMsgTimeSpan = 3 -- 红字消息3秒间隔
  local nPopoTimeSpan = 10 -- 弹出提示10秒间隔
  local szSkillName = ""
  if nSkillId then
    szSkillName = FightSkill:GetSkillName(nSkillId)
  end
  local tbMsg = {

    [FightSkill.USESKILL_FAILED.emFIGHTSKILL_USEFAILED_NONE] = "",
    [FightSkill.USESKILL_FAILED.emFIGHTSKILL_USEFAILED_NOSKILL] = "不存在此技能！",
    [FightSkill.USESKILL_FAILED.emFIGHTSKILL_USEFAILED_NOHAVE] = "您尚未习得该技能！",
    [FightSkill.USESKILL_FAILED.emFIGHTSKILL_USEFAILED_NOTARGET] = "该技能必须指定目标施放！", -- 没有目标
    [FightSkill.USESKILL_FAILED.emFIGHTSKILL_USEFAILED_NOMANA] = "内力不足！", -- 没有蓝
    [FightSkill.USESKILL_FAILED.emFIGHTSKILL_USEFAILED_FIGHTSTATEERR] = "战斗状态不正确！", -- 战斗状态不对
    [FightSkill.USESKILL_FAILED.emFIGHTSKILL_USEFAILED_FACTIONERR] = "门派不对，不能使用该技能！", -- 门派不对
    [FightSkill.USESKILL_FAILED.emFIGHTSKILL_USEFAILED_ROUTEERR] = "门派路线不对，不能使用该技能！", -- 路线不对
    [FightSkill.USESKILL_FAILED.emFIGHTSKILL_USEFAILED_WEAPONERR] = "您当前装备的武器不适合您想使用的武功！", -- 武器不对
    [FightSkill.USESKILL_FAILED.emFIGHTSKILL_USEFAILED_TARGERERR] = "目标不正确！", -- 目标不对
    [FightSkill.USESKILL_FAILED.emFIGHTSKILL_USEFAILED_DOMAINERR] = "变身后只能使用指定技能!", -- 不是变身后拥有的技能
    [FightSkill.USESKILL_FAILED.emFIGHTSKILL_USEFAILED_RIDESTATEERR] = "此技能受骑马状态限制！", -- 骑马状态不对
    [FightSkill.USESKILL_FAILED.emFIGHTSKILL_USEFAILED_ANGERLIMIT] = "必须在狂怒状态下才能使用该技能！", -- 怒气技能限制
    [FightSkill.USESKILL_FAILED.emFIGHTSKILL_USEFAILED_FORBITSKILL] = "当前状态不能释放技能！", -- 处于禁止释放技能
    [FightSkill.USESKILL_FAILED.emFIGHTSKILL_USEFAILED_FORBITMOVE] = "此技能只能在可以移动的状态下释放！", -- 处于禁止移动
    [FightSkill.USESKILL_FAILED.emFIGHTSKILL_USEFAILED_CDERR] = "技能处于冷却时间！", -- CD时间未到
    [FightSkill.USESKILL_FAILED.emFIGHTSKILL_USEFAILED_RADIUSERR] = "目标太远！", -- 距离太远
    [FightSkill.USESKILL_FAILED.emFIGHTSKILL_USEFAILED_NOSTEAL] = "目标没有可以偷取的技能！", -- 没有可以偷取的技能，偷取失败
    [FightSkill.USESKILL_FAILED.emFIGHTSKILL_USEFAILED_PKVALUE] = "PK值过高，无法使用技能",
    [FightSkill.USESKILL_FAILED.emFIGHTSKILL_USEFAILED_NOBUFFLAYERS] = string.format("<color=gold>%s<color>状态层数不足", szSkillName),
    [FightSkill.USESKILL_FAILED.emFIGHTSKILL_USEFAILED_NOENOUGHBUFFLAYERS] = string.format("<color=gold>%s<color>状态层数不足", szSkillName),
  }

  if nErr == FightSkill.USESKILL_FAILED.emFIGHTSKILL_USEFAILED_WEAPONERR then
    if tbMsg[nErr] and not (nLastErr == nErr and GetTime() - nLastMsgTime < nMsgTimeSpan) then
      nLastMsgTime = GetTime()
      local szMsg = "<color=cyan>" .. tbMsg[nErr] .. "<color>"
      UiManager:OpenWindow("UI_INFOBOARD", szMsg)
    end
    if tbMsg[nErr] and not (nLastErr == nErr and GetTime() - nLastPopoTime < nPopoTimeSpan) then
      nLastPopoTime = GetTime()
      PopoTip:ShowPopo(19, tbMsg[nErr])
    end
  else
    if tbMsg[nErr] then
      local szMsg = "<color=cyan>" .. tbMsg[nErr] .. "<color>"
      UiManager:OpenWindow("UI_INFOBOARD", szMsg)
    end
  end
  nLastErr = nErr
end

function uiSkillBar:Update()
  self.tbCont:ClearObj()
  local nLeftSkill = nil
  local nRightSkill = nil
  -- 玩家是否在载具上
  if me.IsInCarrier() == 1 then
    local pCarrier = me.GetCarrierNpc()
    if pCarrier.CanSetLeftRightSkill() == 1 then
      nLeftSkill = me.GetTask(Item.TSKGID_LEFTRIGHT_CARRIER, Item.TSKID_LEFT_FLAG_CARRIER)
      nRightSkill = me.GetTask(Item.TSKGID_LEFTRIGHT_CARRIER, Item.TSKID_RIGHT_FLAG_CARRIER)
    end
  end
  local tbLeftSkill = {}
  tbLeftSkill.nType = Ui.OBJ_FIGHTSKILL
  tbLeftSkill.nSkillId = nLeftSkill or me.nLeftSkill

  local tbRightSkill = {}
  tbRightSkill.nType = Ui.OBJ_FIGHTSKILL
  tbRightSkill.nSkillId = nRightSkill or me.nRightSkill

  self.tbCont:SetObj(tbLeftSkill, 0, 0)
  self.tbCont:SetObj(tbRightSkill, 1, 0)

  ObjBox_Clear(self.UIGROUP, self.OBJ_LEFTSKILL or "Main")
  ObjBox_HoldObject(self.UIGROUP, self.OBJ_LEFTSKILL or "Main", Ui.CGOG_SKILL_SHORTCUT, nLeftSkill or me.nLeftSkill)
  ObjBox_Clear(self.UIGROUP, self.OBJ_RIGHTSKILL)
  ObjBox_HoldObject(self.UIGROUP, self.OBJ_RIGHTSKILL or "Main", Ui.CGOG_SKILL_SHORTCUT, nRightSkill or me.nRightSkill)

  UiManager:CloseWindow("UI_SKILLTREE")
end

function uiSkillBar:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_FIGHT_SKILL_CHANGED, self.Update },
    { UiNotify.emCOREEVENT_ANGEREVENT, self.OnSetAngerProgress },
    { UiNotify.emCOREEVENT_SETANGEREVENT, self.OnSetUnAngerProgress },
    { UiNotify.emCOREEVENT_CHANGEACTIVEAURA, self.Update },
    { UiNotify.emCOREEVENT_USESKLL_FAILED, self.OnUseSkillFailed },
  }
  return Lib:MergeTable(tbRegEvent, self.tbCont:RegisterEvent())
end

function uiSkillBar:RegisterMessage()
  local tbRegMsg = self.tbCont:RegisterMessage()
  return tbRegMsg
end
