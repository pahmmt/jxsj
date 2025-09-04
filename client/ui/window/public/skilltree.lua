-----------------------------------------------------
--文件名		：	skilltree.lua
--创建者		：	wuwuei1, tongxuehu
--创建时间		：	2007-04-19
--功能描述		：	左右键技能选择板
------------------------------------------------------
local uiSkillTree = Ui:GetClass("skilltree")
local tbSaveData = Ui.tbLogic.tbSaveData

uiSkillTree.OBJ_SKILLTREE = "ObjSkillTree"
uiSkillTree.MAX_NUM_P_LINE = 8
uiSkillTree.DATA_KEY = "KeyConfigure"

uiSkillTree.MAIN_HEIGHT = 84
uiSkillTree.LINEHEIGHT = 42
uiSkillTree.MAIN_WIDTH = 330

function uiSkillTree:Init()
  self.nPos = 0
  self.bShow = 0
  self.nSkillNum = 0
  self.tbKeyMap = {}
  self.bAutoFightModel = 0
  self.bAutoFightRightSkill = 0
  tbSaveData:RegistLoadCallback(self.LoadConfiure, self) -- TODO: 临时写法
end

function uiSkillTree:WriteStatLog(szField)
  Log:Ui_SendLog(szField, 1)
end

function uiSkillTree:OnOpen(szLeftOrRight)
  if szLeftOrRight == "AUTOLEFTSKILL" then
    self:UpdateSkill()
    self.bAutoFightModel = 1
  elseif szLeftOrRight == "AUTORIGHTSKILL" then
    self.bAutoFightRightSkill = 1
    self:UpdateSkill()
    self.bAutoFightModel = 1
  else
    if szLeftOrRight == nil then
      szLeftOrRight = "LEFT"
    end
    if szLeftOrRight == "LEFT" then
      self.nPos = 0
    else
      self.nPos = 1
    end
    self.tbKeyMap = self:LoadSkillTask()
    self:UpdateSkill()
  end
end

function uiSkillTree:OnKillFocus(szWnd)
  UiManager:CloseWindow(self.UIGROUP)
end

function uiSkillTree:OnObjHover(szWnd, uGenre, uId, nX, nY)
  if szWnd == self.OBJ_SKILLTREE then
    if uId > 0 then
      Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, me.GetFightSkillTip(uId, 0, 0))
    end
  end
end

function uiSkillTree:OnObjSwitch(szWnd, uGenre, uId, nX, nY)
  self:WriteStatLog("鼠标左右键技能更改")
  if self.bAutoFightModel == 0 then
    if self.nPos == 0 then
      me.nLeftSkill = uId
    elseif self.nPos == 1 then
      me.nRightSkill = uId
    end
    self.bShow = 0
    UiManager:CloseWindow(Ui.UI_SKILLTREE)
  elseif self.bAutoFightModel == 1 then
    local nLeftId, nRightId
    if self.bAutoFightRightSkill == 0 then
      nLeftId = uId
      nRightId = -1
    elseif self.bAutoFightRightSkill == 1 then
      nLeftId = -1
      nRightId = uId
    end
    UiNotify:OnNotify(UiNotify.emUIEVENT_SELECT_SKILL, nLeftId, nRightId)
    UiManager:CloseWindow(Ui.UI_SKILLTREE)
  end
end

function uiSkillTree:UpdateSkill()
  local tbSkills = me.GetImmeSkillList(self.nPos)

  --门派或路线需求不符合则不显示在左右键面板中
  local Skills = {}
  for i = 1, #tbSkills do
    local tbInfo = KFightSkill.GetSkillInfo(tbSkills[i], 10)
    local bLimitF, bLimitR = 0, 0
    if 0 > tbInfo.nFactionLimited then
      bLimitF = 1
    elseif tbInfo.nFactionLimited > 0 and tbInfo.nFactionLimited == me.nFaction then
      bLimitF = 1
    end
    if 0 > tbInfo.nRouteLimited then
      bLimitR = 1
    elseif tbInfo.nRouteLimited > 0 and tbInfo.nRouteLimited == me.nRouteId then
      bLimitR = 1
    end
    if bLimitF * bLimitR == 1 then
      Skills[#Skills + 1] = tbSkills[i]
    end
  end

  if Skills == nil then
    return
  end

  self.nSkillNum = #Skills

  if self.nSkillNum == 0 then
    self.bShow = 0
    UiManager:CloseWindow(Ui.UI_SKILLTREE)
    return
  end

  local nLine = math.floor((self.nSkillNum - 1) / self.MAX_NUM_P_LINE)
  ObjMx_SetUnitSize(self.UIGROUP, self.OBJ_SKILLTREE, self.MAX_NUM_P_LINE, nLine + 1)

  ObjMx_Clear(self.UIGROUP, self.OBJ_SKILLTREE)

  local nCol = self.MAX_NUM_P_LINE
  local nLine = 0
  local i = 1
  while i < self.nSkillNum + 1 do
    local szKey = nil
    for nKey in pairs(self.tbKeyMap) do
      if self.tbKeyMap[nKey][1] == Skills[i] and self.tbKeyMap[nKey][2] == self.nPos then
        szKey = UiShortcutAlias:GetSkillShortcut(nKey)
      end
    end
    ObjMx_AddObject(self.UIGROUP, self.OBJ_SKILLTREE, Ui.CGOG_SKILL_SHORTCUT, Skills[i], nCol - 1, nLine, szKey)
    nCol = nCol - 1
    if nCol < 1 then
      nCol = self.MAX_NUM_P_LINE
      nLine = nLine + 1
    end
    i = i + 1
  end

  local nObjPosX = 0
  local nObjPosY = 42 * 3 - (nLine + 1) * self.LINEHEIGHT
  local nMainHeight = (nLine + 1) * self.LINEHEIGHT
  if nLine == 0 then
    nObjPosX = nObjPosX - 20 * (self.MAX_NUM_P_LINE - self.nSkillNum)
  end
  Wnd_SetPos(self.UIGROUP, self.OBJ_SKILLTREE, nObjPosX, nObjPosY)
  Wnd_SetSize(self.UIGROUP, self.OBJ_SKILLTREE, self.MAIN_WIDTH, nMainHeight)
end

function uiSkillTree:OnSetShortcutSkill(nKey) --TODO: 按键过快会导致nKey 为nil
  if self.bAutoFightModel ~= 1 then
    local tbSkill = ObjMx_GetMouseOverObj(self.UIGROUP, self.OBJ_SKILLTREE)
    if not tbSkill then
      return
    end
    if not tbSkill.uId then
      return
    end

    for _nKey in pairs(self.tbKeyMap) do
      if (self.tbKeyMap[_nKey][1] == tbSkill.uId) and (self.tbKeyMap[_nKey][2] == self.nPos) then
        self.tbKeyMap[_nKey] = { 999, 10 } --设置为一个不存在的值
        self:SaveSkillTask(_nKey)
      end
    end
    self.tbKeyMap[nKey] = { tbSkill.uId, self.nPos }
    self:SaveSkillTask(nKey)
    self:UpdateSkill()
    self:WriteStatLog("快捷键更改")
  end
end

function uiSkillTree:UseShortcutSkill(nKey)
  local tbSkillKey = self:LoadSkillKey(nKey)
  if tbSkillKey then
    if UiShortcutAlias.m_nControlMode == 2 then
      local tbInfo = KFightSkill.GetSkillInfo(tbSkillKey[1], 1)
      if not tbInfo then
        return
      end
      if tbInfo.nIsAure == 1 then
        me.nRightSkill = tbSkillKey[1]
      else
        UseSkill(tbSkillKey[1])
      end
    else
      if tbSkillKey[2] == 0 then
        me.nLeftSkill = tbSkillKey[1]
      elseif tbSkillKey[2] == 1 then
        me.nRightSkill = tbSkillKey[1]
      end
    end
  end
end

function uiSkillTree:LoadConfiure()
  self.tbKeyMap = self:LoadSkillTask()
end

function uiSkillTree:LoadSkillKey(nKey)
  local tbSkillKey = {}
  local nHigh = me.GetTask(FightSkill.TSKGID_LEFT_RIGHT_SKILL, nKey + 1)
  local uId = Lib:LoadBits(nHigh, 0, 15)
  local nPos = Lib:LoadBits(nHigh, 16, 23)

  tbSkillKey[nKey] = { uId, nPos }
  return tbSkillKey[nKey]
end

function uiSkillTree:LoadSkillTask()
  local tbSkillKey = {}
  for nPosition = 1, FightSkill.SKILLTREE_KEY_COUNT do
    local nHigh = me.GetTask(FightSkill.TSKGID_LEFT_RIGHT_SKILL, nPosition)
    local uId = Lib:LoadBits(nHigh, 0, 15)
    local nPos = Lib:LoadBits(nHigh, 16, 23)
    tbSkillKey[nPosition - 1] = { uId, nPos }
  end
  return tbSkillKey
end

function uiSkillTree:SaveSkillTask(nKey)
  if (nKey < 0) and (nKey > FightSkill.SKILLTREE_KEY_COUNT) then
    return
  end
  local tbSkillKey = self.tbKeyMap[nKey]
  local nHigh = Lib:SetBits(tbSkillKey[1], tbSkillKey[2], 16, 23)
  me.SetTask(FightSkill.TSKGID_LEFT_RIGHT_SKILL, nKey + 1, nHigh)
end

function uiSkillTree:SaveAll()
  local tbSkillKey = {}
  for nKey = 0, FightSkill.SKILLTREE_KEY_COUNT do
    tbSkillKey = self.tbKeyMap[nKey]
    local nHigh = Lib:SetBits(tbSkillKey[1], tbSkillKey[2], 16, 23)
    me.SetTask(FightSkill.TSKGID_LEFT_RIGHT_SKILL, nKey + 1, nHigh)
  end
end
