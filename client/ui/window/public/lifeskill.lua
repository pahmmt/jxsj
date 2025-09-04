-----------------------------------------------------
--文件名		：	lifeskill.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-06-01
--功能描述		：	生活技能界面脚本。
------------------------------------------------------

local uiLifeSkill = Ui:GetClass("lifeskill")

local CLOSE_WINDOW_BUTTON = "BtnClose"
local PRODUCE_BUTTON = "BtnAccept"
local IMG_HIGHLIGHT = "zImgHightLight"

local TXT_MKP = "Txt_MKP" -- 精力值
local TXT_GTP = "Txt_GTP" -- 活力值

local SKILL_WND = -- 生活技能控件表，详细参见战斗技能的
  {
    {
      { "Obj2_1", "Txt2_1", 0, "Txt2_Level_1" },
      { "Obj2_2", "Txt2_2", 0, "Txt2_Level_2" },
      { "Obj2_3", "Txt2_3", 0, "Txt2_Level_3" },
      { "Obj2_4", "Txt2_4", 0, "Txt2_Level_4" },
      { "Obj2_5", "Txt2_5", 0, "Txt2_Level_5" },
      { "Obj2_6", "Txt2_6", 0, "Txt2_Level_6" },
    },
    {
      { "Obj1_1", "Txt1_1", 0, "Txt1_Level_1" },
      { "Obj1_2", "Txt1_2", 0, "Txt1_Level_2" },
      { "Obj1_3", "Txt1_3", 0, "Txt1_Level_3" },
      { "Obj1_4", "Txt1_4", 0, "Txt1_Level_4" },
      { "Obj1_5", "Txt1_5", 0, "Txt1_Level_5" },
      { "Obj1_6", "Txt1_6", 0, "Txt1_Level_6" },
    },
  }

function uiLifeSkill:Init()
  self.m_CurSel = nil -- 当前选择的技能
end

function uiLifeSkill:WriteStatLog()
  Log:Ui_SendLog("F8生活技能界面", 1)
end

function uiLifeSkill:PreOpen()
  if me.IsAccountLock() ~= 0 then
    Account:OpenLockWindow()
    UiNotify:OnNotify(UiNotify.emCOREEVENT_SET_POPTIP, 44)
    me.Msg("你的账号正在锁定状态，不能使用生活技能！")
    return 0
  end
  return 1
end

function uiLifeSkill:OnOpen()
  self:WriteStatLog()
  Ui(Ui.UI_SIDEBAR):WndOpenCloseCallback(self.UIGROUP, 1)
  for _, WndGroup in ipairs(SKILL_WND) do
    for _, item in ipairs(WndGroup) do
      ObjBox_Clear(self.UIGROUP, item[1])
      Txt_SetTxt(self.UIGROUP, item[2], "")
      Txt_SetTxt(self.UIGROUP, item[4], "")
    end
  end
  self:Update()
  if self.m_CurSel == nil then
    Wnd_SetEnable(self.UIGROUP, PRODUCE_BUTTON, 0)
    Wnd_Hide(self.UIGROUP, IMG_HIGHLIGHT)
  end
end

function uiLifeSkill:OnClose()
  Ui(Ui.UI_SIDEBAR):WndOpenCloseCallback(self.UIGROUP, 0)
end

function uiLifeSkill:OnButtonClick(szWnd, nParam)
  if szWnd == CLOSE_WINDOW_BUTTON then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == PRODUCE_BUTTON then
    if self.m_CurSel == nil then
      return
    end
    if self.m_CurSel.uId == 11 then
      UiManager:OpenWindow(Ui.UI_EQUIPBREAKUP)
      UiManager:CloseWindow(self.UIGROUP)
      UiManager:CloseWindow(Ui.UI_PRODUCE)
    else
      UiManager:OpenWindow(Ui.UI_PRODUCE, self.m_CurSel.uId)
    end
  end
end

function uiLifeSkill:OnObjSwitch(szWnd, uGenre, uId, nX, nY)
  if uId > 0 then
    Wnd_SetPos(self.UIGROUP, IMG_HIGHLIGHT, Wnd_GetPos(self.UIGROUP, szWnd))
    Wnd_SetEnable(self.UIGROUP, PRODUCE_BUTTON, uId > 0 and 1 or 0)
    Wnd_Show(self.UIGROUP, IMG_HIGHLIGHT)
  end

  -- TODO:考虑去掉高亮
  Wnd_Hide(self.UIGROUP, IMG_HIGHLIGHT)

  if uId <= 0 then
    return
  end

  if uId == 11 then
    UiManager:OpenWindow(Ui.UI_EQUIPBREAKUP)
    UiManager:CloseWindow(self.UIGROUP)
    UiManager:CloseWindow(Ui.UI_PRODUCE)
  else
    UiManager:OpenWindow(Ui.UI_PRODUCE, uId)
  end
end

function uiLifeSkill:OnMouseEnter(szWnd)
  if szWnd == IMG_HIGHLIGHT then
    if self.szHightLightTip then
      Wnd_ShowMouseHoverInfo(self.UIGROUP, IMG_HIGHLIGHT, "", self.szHightLightTip)
    end
  end
end

function uiLifeSkill:OnObjHover(szWnd, uGenre, uId, nX, nY)
  if uId > 0 then
    local szTip = LifeSkill.tbLifeSkillDatas[uId].Desc
    Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, "", szTip)
  end
end

function uiLifeSkill:Update()
  local tbSkillList = me.GetLifeSkillList()
  if not tbSkillList or #tbSkillList == 0 then
    return 0
  end

  for _, tbSkill in ipairs(tbSkillList) do
    self:OnAddLifeSkill(tbSkill.nSkillId, tbSkill.nLevel, tbSkill.nExp)
  end

  Txt_SetTxt(self.UIGROUP, TXT_MKP, "当前精力值：" .. me.dwCurMKP)
  Txt_SetTxt(self.UIGROUP, TXT_GTP, "当前活力值：" .. me.dwCurGTP)
end

function uiLifeSkill:OnAddLifeSkill(nSkillId, nSkillLevel, nSkillCurExp)
  local nSkillType = LifeSkill.tbLifeSkillDatas[nSkillId].Gene
  local nX = nSkillType + 1

  local nY = 1
  if nSkillId == 11 then -- TODO: 特殊处理
    nY = 6
  end
  if nSkillId > 5 then
    nY = nSkillId - 5
  else
    nY = nSkillId
  end
  local obSkill = SKILL_WND[nX][nY]

  ObjBox_HoldObject(self.UIGROUP, obSkill[1], Ui.CGOG_LIFESKILL, nSkillId, 0, 0)
  Txt_SetTxt(self.UIGROUP, obSkill[2], LifeSkill.tbLifeSkillDatas[nSkillId].Name)
  Txt_SetTxt(self.UIGROUP, obSkill[4], "等级：" .. me.GetSingleLifeSkill(nSkillId).nLevel)

  -- 拆解技能的特殊处理
  if nSkillId == 11 then
    Txt_SetTxt(self.UIGROUP, obSkill[4], "等级：- ")
  end
end

function uiLifeSkill:OnDelLifeSkill(nSkillId)
  local nSkillType = LifeSkill.tbLifeSkillDatas[nSkillId].Gene
  local nX = nSkillType + 1
  local nY = 1
  if nSkillId > 5 then
    nY = nSkillId - 5
  else
    nY = nSkillId
  end

  local obSkill = SKILL_WND[nX][nY]
  ObjBox_Clear(self.UIGROUP, obSkill[1])
  Txt_SetTxt(self.UIGROUP, obSkill[2], "")
  Txt_SetTxt(self.UIGROUP, obSkill[4], "")
end

function uiLifeSkill:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_ADDLIFESKILL, self.OnAddLifeSkill },
    { UiNotify.emCOREEVENT_DELLIFESKILL, self.OnDelLifeSkill },
  }
  return tbRegEvent
end
