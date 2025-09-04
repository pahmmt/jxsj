local uiViewFightSkill = Ui:GetClass("viewfightskill")
local tbObject = Ui.tbLogic.tbObject

uiViewFightSkill.CLOSE_WINDOW_BUTTON = "BtnClose"

uiViewFightSkill.PAGE_SET_MAIN = "PageSetMain"

uiViewFightSkill.View_Skill_Object = "ObjFightSkillView"
uiViewFightSkill.BTN_PAGEUP = "BtnPageUp"
uiViewFightSkill.BTN_PAGEDOWN = "BtnPageDown"
uiViewFightSkill.TXTPAGE = "TxtPage"

uiViewFightSkill.View_OBJECT_LINE = 6
uiViewFightSkill.View_OBJECT_ROW = 4

uiViewFightSkill.MAXCOUNTS = 12

uiViewFightSkill.PAGE_WND = { -- 	页按钮				页名				6行之每行技能个数
  { "BtnKombatPage1", "PageKombat", { 0, 0, 0, 0, 0, 0 } },
}

uiViewFightSkill.WND_FACTION_BG = "BgFactionImage"
uiViewFightSkill.FACTION_BG = {
  "shaolin.spr",
  "tianwang.spr",
  "tangmen.spr",
  "wudu.spr",
  "emei.spr",
  "cuiyan.spr",
  "gaibang.spr",
  "tianren.spr",
  "wudang.spr",
  "kunlun.spr",
  "mingjiao.spr",
  "dali.spr",
}

local szPathBeidongSkillImg = "\\image\\ui\\002a\\fightskill\\bg_passiveskill.spr"
local szPathZhudongSkillImg = "\\image\\ui\\002a\\fightskill\\bg_initiativeskill.spr"

local tbViewSkillCont = { bShowCd = 0, bUse = 0 }
tbViewSkillCont.nCurPage = 1

tbViewSkillCont.SKILL_WND = {
  -- PageViewSkill
  [1] = { --等级控件  等级  技能名字控件
    {
      { "Txt1_1_1", 0, [12] = "TxtName1_1_1", [14] = "Imgbg1_1_1" },
      { "Txt1_1_2", 0, [12] = "TxtName1_1_2", [14] = "Imgbg1_1_2" },
    },
    {
      { "Txt1_2_1", 0, [12] = "TxtName1_2_1", [14] = "Imgbg1_2_1" },
      { "Txt1_2_2", 0, [12] = "TxtName1_2_2", [14] = "Imgbg1_2_2" },
    },
    {
      { "Txt1_3_1", 0, [12] = "TxtName1_3_1", [14] = "Imgbg1_3_1" },
      { "Txt1_3_2", 0, [12] = "TxtName1_3_2", [14] = "Imgbg1_3_2" },
    },
    {
      { "Txt1_4_1", 0, [12] = "TxtName1_4_1", [14] = "Imgbg1_4_1" },
      { "Txt1_4_2", 0, [12] = "TxtName1_4_2", [14] = "Imgbg1_4_2" },
    },
    {
      { "Txt1_5_1", 0, [12] = "TxtName1_5_1", [14] = "Imgbg1_5_1" },
      { "Txt1_5_2", 0, [12] = "TxtName1_5_2", [14] = "Imgbg1_5_2" },
    },
    {
      { "Txt1_6_1", 0, [12] = "TxtName1_6_1", [14] = "Imgbg1_6_1" },
      { "Txt1_6_2", 0, [12] = "TxtName1_6_2", [14] = "Imgbg1_6_2" },
    },
  },
}

function tbViewSkillCont:PickMouse(tbObj, nX, nY)
  return
end

function tbViewSkillCont:DropMouse(tbMouseObj, nX, nY)
  return 0
end

function tbViewSkillCont:SwitchMouse(tbMouseObj, tbObj, nX, nY)
  return 0
end

function tbViewSkillCont:CanPick(nX, nY)
  return 0
end

function tbViewSkillCont:EnterFightSkill(tbFightSkill, nX, nY)
  local nSkillId = tbFightSkill.nSkillId
  if nSkillId <= 0 then
    return
  end
  local nPage = self.nCurPage
  local nLine = nY + 1
  local nRow = nX + 1
  if nPage and nLine and nRow then
    local szTitle, szMsg = FightSkill:GetDesc(nSkillId, self.SKILL_WND[nPage][nLine][nRow][2], 0, nil, nil, 1)
    if not szTitle or not szMsg then
      szTitle = ""
      szMsg = ""
    end
    Wnd_ShowMouseHoverInfo(self.szUiGroup, self.szObjGrid, szTitle, szMsg)
  end
end

function uiViewFightSkill:OnCreate()
  self.tbViewSkillCont = tbObject:RegisterContainer(self.UIGROUP, self.View_Skill_Object, self.View_OBJECT_LINE, self.View_OBJECT_LINE, tbViewSkillCont)
end

function uiViewFightSkill:OnDestroy()
  tbObject:UnregContainer(self.tbViewSkillCont)
end

function uiViewFightSkill:Init()
  self.nCurPageNum = 1 -- PAGE控件的页数

  self.nSkillListCurPageNum = 1 -- 当前激活PAGE页面下，显示技能列表的第几页
  self.nSkillListMaxPageNum = 1 -- 当前激活PAGE页面下，技能列表共能显示多少页
  self.tbViewSkill = {}
end

function uiViewFightSkill:OnOpen()
  local tbViewSkill = me.GetPlayerSkillList()
  self.tbViewSkill = tbViewSkill
  local nSkillCount = 0
  for i = 1, #self.tbViewSkill do
    if self.tbViewSkill[i].nSkillId ~= 0 then
      nSkillCount = nSkillCount + 1
    end
  end
  self.nSkillListMaxPageNum = math.ceil(nSkillCount / self.MAXCOUNTS)

  self:UpdateViewPage()
end

function uiViewFightSkill:OnClose()
  self:Init()
end

function uiViewFightSkill:OnButtonClick(szWnd, nParam)
  if szWnd == self.CLOSE_WINDOW_BUTTON then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_PAGEDOWN then
    if self.nSkillListCurPageNum < self.nSkillListMaxPageNum then
      self.nSkillListCurPageNum = self.nSkillListCurPageNum + 1
      self:UpdateViewPage()
    end
  elseif szWnd == self.BTN_PAGEUP then
    if self.nSkillListCurPageNum > 1 then
      self.nSkillListCurPageNum = self.nSkillListCurPageNum - 1
      self:UpdateViewPage()
    end
  end
end

function uiViewFightSkill:UpDateBgImage(nFaction)
  local szPath = "\\image\\ui\\001a\\skill\\fightskill_bg\\"
  local szBgImage = ""

  if nFaction ~= 0 then
    szBgImage = szPath .. self.FACTION_BG[nFaction]
  else
    szBgImage = szPath .. "common.spr"
  end
  Img_SetImage(self.UIGROUP, self.WND_FACTION_BG, 1, "")
  Img_SetImage(self.UIGROUP, self.WND_FACTION_BG, 1, szBgImage)
end

function uiViewFightSkill:ClearPage(nPage)
  local x = nPage
  for y = 1, #self.tbViewSkillCont.SKILL_WND[x] do
    for z = 1, #self.tbViewSkillCont.SKILL_WND[x][y] do
      self.tbViewSkillCont.SKILL_WND[x][y][z][2] = 0
      Txt_SetTxt(self.UIGROUP, self.tbViewSkillCont.SKILL_WND[x][y][z][1], "")
      Txt_SetTxt(self.UIGROUP, self.tbViewSkillCont.SKILL_WND[x][y][z][12], "")
      Txt_SetTxt(self.UIGROUP, self.tbViewSkillCont.SKILL_WND[x][y][z][12] .. "_a", "")
      Wnd_Hide(self.UIGROUP, self.tbViewSkillCont.SKILL_WND[x][y][z][14])
    end
  end

  for y = 1, #self.PAGE_WND[x][3] do
    self.PAGE_WND[nPage][3][y] = 0
  end
  self.tbViewSkillCont:ClearObj()
end

function uiViewFightSkill:UpdateViewPage()
  PgSet_ActivePage(self.UIGROUP, self.PAGE_SET_MAIN, self.PAGE_WND[self.nCurPageNum][2])
  local tbViewSkill = self.tbViewSkill --me.GetPlayerSkillList();
  Txt_SetTxt(self.UIGROUP, self.TXTPAGE, string.format("%d/%d", self.nSkillListCurPageNum, self.nSkillListMaxPageNum))
  --Wnd_SetEnable(self.UIGROUP, self.BTN_PAGEUP, 0)
  --Wnd_SetEnable(self.UIGROUP, self.BTN_PAGEDOWN, 0)

  if not tbViewSkill then
    print("get skill error")
  end
  local nRoute = tbViewSkill.nRoute
  local nFaction = tbViewSkill.nFaction
  --self:UpDateBgImage(nFaction);
  if not nFaction or nFaction == 0 or nRoute == 0 then
    return
  end

  local tbRoutes = KPlayer.GetFactionInfo(nFaction).tbRoutes
  local szRouteName = tbRoutes[nRoute].szName

  self:ClearPage(self.nCurPageNum)

  Btn_SetTxt(self.UIGROUP, self.PAGE_WND[self.nCurPageNum][1], szRouteName)

  local nBeginIndex = (self.nSkillListCurPageNum - 1) * self.MAXCOUNTS + 1
  for i = nBeginIndex, #tbViewSkill do
    -- 最多只显示一页，12个技能！
    if i - nBeginIndex >= self.MAXCOUNTS then
      break
    end

    local nSkillId = tbViewSkill[i].nSkillId
    local nLine = 0
    if nSkillId == 0 then
      break
    end

    if math.mod(i - nBeginIndex + 1, 2) == 0 then
      nLine = math.floor((i - nBeginIndex + 1) / 2)
    else
      nLine = math.floor((i - nBeginIndex + 1) / 2) + 1
    end
    self:AddSkillToViewPage(nLine, tbViewSkill[i])
  end

  self:UpdatePageButtonState()
end

function uiViewFightSkill:AddSkillToViewPage(nLine, tbSkill)
  if (not nLine) or not tbSkill then
    return
  end

  local nPage = self.nCurPageNum

  local nOffset = self.PAGE_WND[nPage][3][nLine] + 1 -- 在第nLine行的第nOffset列
  self.PAGE_WND[nPage][3][nLine] = nOffset

  Wnd_Show(self.UIGROUP, self.tbViewSkillCont.SKILL_WND[nPage][nLine][nOffset][1])
  local szLevel = tbSkill.nSkillLevel

  self.tbViewSkillCont.SKILL_WND[nPage][nLine][nOffset][2] = tbSkill.nSkillLevel

  Txt_SetTxt(self.UIGROUP, self.tbViewSkillCont.SKILL_WND[nPage][nLine][nOffset][1], "等级: " .. szLevel)
  local szSkillName = KFightSkill.GetSkillName(tbSkill.nSkillId)
  Txt_SetTxt(self.UIGROUP, self.tbViewSkillCont.SKILL_WND[nPage][nLine][nOffset][12], szSkillName)
  local tbSkillInfo = KFightSkill.GetSkillInfo(tbSkill.nSkillId, 1)
  Txt_SetTxt(self.UIGROUP, self.tbViewSkillCont.SKILL_WND[nPage][nLine][nOffset][12] .. "_a", tbSkillInfo.szProperty)
  if tbSkillInfo.nSkillType == 3 then
    Wnd_Show(self.UIGROUP, self.tbViewSkillCont.SKILL_WND[nPage][nLine][nOffset][14])
    Img_SetImage(self.UIGROUP, self.tbViewSkillCont.SKILL_WND[nPage][nLine][nOffset][14], 1, szPathBeidongSkillImg)
  else
    Wnd_Show(self.UIGROUP, self.tbViewSkillCont.SKILL_WND[nPage][nLine][nOffset][14])
    Img_SetImage(self.UIGROUP, self.tbViewSkillCont.SKILL_WND[nPage][nLine][nOffset][14], 1, szPathZhudongSkillImg)
  end

  local tbObj = nil
  tbObj = {}
  tbObj.nType = Ui.OBJ_FIGHTSKILL
  tbObj.nSkillId = tbSkill.nSkillId
  self.tbViewSkillCont:SetObj(tbObj, nOffset - 1, nLine - 1)
end

-- 更新上一页、下一页按钮的有效失效状态
function uiViewFightSkill:UpdatePageButtonState()
  if self.nSkillListCurPageNum <= 1 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_PAGEUP, 0)
  elseif self.nSkillListCurPageNum > 1 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_PAGEUP, 1)
  end

  if self.nSkillListCurPageNum >= self.nSkillListMaxPageNum then
    Wnd_SetEnable(self.UIGROUP, self.BTN_PAGEDOWN, 0)
  elseif self.nSkillListCurPageNum < self.nSkillListMaxPageNum then
    Wnd_SetEnable(self.UIGROUP, self.BTN_PAGEDOWN, 1)
  end
end

function uiViewFightSkill:RegisterEvent()
  local tbRegEvent = {}
  tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbViewSkillCont:RegisterEvent())
  return tbRegEvent
end

function uiViewFightSkill:RegisterMessage()
  local tbRegMsg = self.tbViewSkillCont:RegisterMessage()
  return tbRegMsg
end
