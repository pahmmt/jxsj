-----------------------------------------------------
--文件名		：	fightskill.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-03-05
--功能描述		：	战斗技能界面脚本。
------------------------------------------------------

local uiFightSkill = Ui:GetClass("fightskill")
local tbObject = Ui.tbLogic.tbObject

uiFightSkill.CLOSE_WINDOW_BUTTON = "BtnClose"
uiFightSkill.ACCEPT_BUTTON = "BtnAccept"
uiFightSkill.CANCEL_BUTTON = "BtnCancel"
uiFightSkill.BTN_LVUP = "BtnLvup"
uiFightSkill.BTN_LVDOWN = "BtnLvdown"
uiFightSkill.SKILL_POINT_TEXT = "TxtPoint"
uiFightSkill.PAGE_SET_MAIN = "PageSetMain"
uiFightSkill.Fight_Skill_OBJECT = "ObjFightSkill"
uiFightSkill.Common_Skill_OBJECT = "ObjCommonSkill"
uiFightSkill.BTN_PAGEUP = "BtnPageUp"
uiFightSkill.BTN_PAGEDOWN = "BtnPageDown"
uiFightSkill.TXTPAGE = "TxtPage"
uiFightSkill.TXTCOMMONPAGE = "TxtCommonPage"
uiFightSkill.BTN_COMMON_PAGEUP = "BtnCommonPageUp"
uiFightSkill.BTN_COMMON_PAGEDOWN = "BtnCommonPageDown"

uiFightSkill.IMG_CHOOSE_FACTION = "ImgChooseFaction"
uiFightSkill.BTN_CHOOSE_FACTION = "BtnChooseFaction"
uiFightSkill.BTN_CHANGE_FACTION = "BtnChangeFaction"

uiFightSkill.IMG_BG_COMMON = "BgCommonImage"
uiFightSkill.IMG_BG_FACTION = "BgFactionImage"
uiFightSkill.IMG_ZHEZHAO = "ImageKombatDisable"

uiFightSkill.Fight_OBJECT_LINE = 6
uiFightSkill.Fight_OBJECT_ROW = 4

uiFightSkill.Common_OBJECT_LINE = 6
uiFightSkill.Common_OBJECT_ROW = 4

uiFightSkill.MAXCOUNTS = 12

uiFightSkill.PAGE_WND = { -- 	页按钮				页名				6行之每行技能个数
  { "BtnKombatPage1", "PageKombat", { 0, 0, 0, 0, 0, 0 } },
  { "BtnKombatPage2", "PageKombat", { 0, 0, 0, 0, 0, 0 } },
  { "BtnKombatPage3", "PageKombat", { 0, 0, 0, 0, 0, 0 } },
  { "BtnPage4", "Page4", { 0, 0, 0, 0, 0, 0 } },
}

uiFightSkill.WND_FACTION_BG = "BgFactionImage"
uiFightSkill.FACTION_BG = {
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
uiFightSkill.tbIconFaction = {
  [Env.FACTION_ID_NOFACTION] = "\\image\\ui\\002a\\playerstate\\school_icon2\\wumenpai.spr",
  [Env.FACTION_ID_SHAOLIN] = "\\image\\ui\\002a\\playerstate\\school_icon2\\shaolin.spr",
  [Env.FACTION_ID_TIANWANG] = "\\image\\ui\\002a\\playerstate\\school_icon2\\tianwang.spr",
  [Env.FACTION_ID_TANGMEN] = "\\image\\ui\\002a\\playerstate\\school_icon2\\tangmen.spr",
  [Env.FACTION_ID_WUDU] = "\\image\\ui\\002a\\playerstate\\school_icon2\\wudu.spr",
  [Env.FACTION_ID_EMEI] = "\\image\\ui\\002a\\playerstate\\school_icon2\\ermei.spr",
  [Env.FACTION_ID_CUIYAN] = "\\image\\ui\\002a\\playerstate\\school_icon2\\cuiyan.spr",
  [Env.FACTION_ID_GAIBANG] = "\\image\\ui\\002a\\playerstate\\school_icon2\\gaibang.spr",
  [Env.FACTION_ID_TIANREN] = "\\image\\ui\\002a\\playerstate\\school_icon2\\tianren.spr",
  [Env.FACTION_ID_WUDANG] = "\\image\\ui\\002a\\playerstate\\school_icon2\\wudang.spr",
  [Env.FACTION_ID_KUNLUN] = "\\image\\ui\\002a\\playerstate\\school_icon2\\kunlun.spr",
  [Env.FACTION_ID_MINGJIAO] = "\\image\\ui\\002a\\playerstate\\school_icon2\\mingjiao.spr",
  [Env.FACTION_ID_DALIDUANSHI] = "\\image\\ui\\002a\\playerstate\\school_icon2\\duanshi.spr",
  [Env.FACTION_ID_GUMU] = "\\image\\ui\\002a\\playerstate\\school_icon2\\gumu.spr",
}

uiFightSkill.tbFrame_Choose_Img_State = {
  [0] = 0,
  [1] = 2,
}

uiFightSkill.tbFrame_Choose_Btn_State = {
  [0] = 1,
  [1] = 0,
}

uiFightSkill.COUNT_CHOOSE_FACTION = 4

local tbSkillBaseCont = { bShowCd = 0, bUse = 0 }

function tbSkillBaseCont:DropMouse(tbMouseObj, nX, nY)
  return 0
end

function tbSkillBaseCont:SwitchMouse(tbMouseObj, tbObj, nX, nY)
  return 0
end

function tbSkillBaseCont:PickMouse(tbObj, nX, nY)
  if self:CanPick(nX, nY) ~= 1 then
    return
  end
  local tbContObj = self:GetObj(nX, nY)
  local tbMouse = Ui.tbLogic.tbMouse
  tbMouse:SetObj(tbContObj, self, nX, nY)
end

local tbFightSkillCont = Lib:CopyTB1(tbSkillBaseCont)
local tbCommonSkillCont = Lib:CopyTB1(tbSkillBaseCont)

tbFightSkillCont.SKILL_WND = -- 该表数据项的位置和内容不能轻易修改
  {
    -- PageKombatSkill
    [1] = { --  1			2		   3  4  5  6				7			8		9		10
      --	Obj name	Lv Txt	   nReqLvl 	LvUpBtn			nTmpLvl		skill.uId(hide)
      --							  nLvl										skill.nMaxLevel(hide)
      --								 nLvlEx											skill.nInitiative
      {
        { "0", "Txt1_1_1", 0, 0, 0, "BtnLvup1_1_1", 0, [12] = "TxtName1_1_1", [13] = "BtnLvdown1_1_1", [14] = "Imgbg1_1_1" },
        { "1", "Txt1_1_2", 0, 0, 0, "BtnLvup1_1_2", 0, [12] = "TxtName1_1_2", [13] = "BtnLvdown1_1_2", [14] = "Imgbg1_1_2" },
      },
      {
        { "0", "Txt1_2_1", 0, 0, 0, "BtnLvup1_2_1", 0, [12] = "TxtName1_2_1", [13] = "BtnLvdown1_2_1", [14] = "Imgbg1_2_1" },
        { "1", "Txt1_2_2", 0, 0, 0, "BtnLvup1_2_2", 0, [12] = "TxtName1_2_2", [13] = "BtnLvdown1_2_2", [14] = "Imgbg1_2_2" },
      },
      {
        { "0", "Txt1_3_1", 0, 0, 0, "BtnLvup1_3_1", 0, [12] = "TxtName1_3_1", [13] = "BtnLvdown1_3_1", [14] = "Imgbg1_3_1" },
        { "1", "Txt1_3_2", 0, 0, 0, "BtnLvup1_3_2", 0, [12] = "TxtName1_3_2", [13] = "BtnLvdown1_3_2", [14] = "Imgbg1_3_2" },
      },
      {
        { "0", "Txt1_4_1", 0, 0, 0, "BtnLvup1_4_1", 0, [12] = "TxtName1_4_1", [13] = "BtnLvdown1_4_1", [14] = "Imgbg1_4_1" },
        { "1", "Txt1_4_2", 0, 0, 0, "BtnLvup1_4_2", 0, [12] = "TxtName1_4_2", [13] = "BtnLvdown1_4_2", [14] = "Imgbg1_4_2" },
      },
      {
        { "0", "Txt1_5_1", 0, 0, 0, "BtnLvup1_5_1", 0, [12] = "TxtName1_5_1", [13] = "BtnLvdown1_5_1", [14] = "Imgbg1_5_1" },
        { "1", "Txt1_5_2", 0, 0, 0, "BtnLvup1_5_2", 0, [12] = "TxtName1_5_2", [13] = "BtnLvdown1_5_2", [14] = "Imgbg1_5_2" },
      },
      {
        { "0", "Txt1_6_1", 0, 0, 0, "BtnLvup1_6_1", 0, [12] = "TxtName1_6_1", [13] = "BtnLvdown1_6_1", [14] = "Imgbg1_6_1" },
        { "1", "Txt1_6_2", 0, 0, 0, "BtnLvup1_6_2", 0, [12] = "TxtName1_6_2", [13] = "BtnLvdown1_6_2", [14] = "Imgbg1_6_2" },
      },
    },
  }

tbFightSkillCont.SKILL_WND[2] = tbFightSkillCont.SKILL_WND[1]
tbFightSkillCont.SKILL_WND[3] = tbFightSkillCont.SKILL_WND[1]

tbFightSkillCont.bSimTong = 0
tbFightSkillCont.nCurPage = 1

function tbFightSkillCont:CanPick(nX, nY)
  local nPage = self.nCurPage
  local nLine = nY + 1
  local nRow = nX + 1
  if self.bSimTong ~= 1 and nPage and nLine and nRow then
    local tbSkill = self.SKILL_WND[nPage][nLine][nRow]
    if tbSkill and tbSkill[4] + tbSkill[5] > 0 and tbSkill[10] == 1 then
      return 1
    end
  end
  return 0
end

function tbFightSkillCont:EnterFightSkill(tbFightSkill, nX, nY)
  local nSkillId = tbFightSkill.nSkillId
  if nSkillId <= 0 then
    return
  end
  local nPage = self.nCurPage
  local nLine = nY + 1
  local nRow = nX + 1
  if nPage and nLine and nRow then
    Wnd_ShowMouseHoverInfo(self.szUiGroup, self.szObjGrid, me.GetFightSkillTip(nSkillId, self.SKILL_WND[nPage][nLine][nRow][7], 1))
  end
end

-- Page4 common skill
tbCommonSkillCont.SKILL_WND = {
  {
    { "0", "Txt4_1_1", 0, 0, 0, [12] = "TxtName4_1_1", [14] = "Imgbg4_1_1" },
    { "1", "Txt4_1_2", 0, 0, 0, [12] = "TxtName4_1_2", [14] = "Imgbg4_1_2" },
  },
  {
    { "0", "Txt4_2_1", 0, 0, 0, [12] = "TxtName4_2_1", [14] = "Imgbg4_2_1" },
    { "1", "Txt4_2_2", 0, 0, 0, [12] = "TxtName4_2_2", [14] = "Imgbg4_2_2" },
  },
  {
    { "0", "Txt4_3_1", 0, 0, 0, [12] = "TxtName4_3_1", [14] = "Imgbg4_3_1" },
    { "1", "Txt4_3_2", 0, 0, 0, [12] = "TxtName4_3_2", [14] = "Imgbg4_3_2" },
  },
  {
    { "0", "Txt4_4_1", 0, 0, 0, [12] = "TxtName4_4_1", [14] = "Imgbg4_4_1" },
    { "1", "Txt4_4_2", 0, 0, 0, [12] = "TxtName4_4_2", [14] = "Imgbg4_4_2" },
  },
  {
    { "0", "Txt4_5_1", 0, 0, 0, [12] = "TxtName4_5_1", [14] = "Imgbg4_5_1" },
    { "1", "Txt4_5_2", 0, 0, 0, [12] = "TxtName4_5_2", [14] = "Imgbg4_5_2" },
  },
  {
    { "0", "Txt4_6_1", 0, 0, 0, [12] = "TxtName4_6_1", [14] = "Imgbg4_6_1" },
    { "1", "Txt4_6_2", 0, 0, 0, [12] = "TxtName4_6_2", [14] = "Imgbg4_6_2" },
  },
}

uiFightSkill.FACTION_BG = {
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
  "common.spr",
}

function tbCommonSkillCont:CanPick(nX, nY)
  local nLine = nY + 1
  local nRow = nX + 1
  if nLine and nRow then
    local tbSkill = self.SKILL_WND[nLine][nRow]
    if tbSkill and tbSkill[4] + tbSkill[5] > 0 and tbSkill[10] == 1 then
      return 1
    end
  end
  return 0
end

function uiFightSkill:OnCreate()
  self.tbFightSkillCont = tbObject:RegisterContainer(self.UIGROUP, self.Fight_Skill_OBJECT, self.Fight_OBJECT_ROW, self.Fight_OBJECT_LINE, tbFightSkillCont)
  self.tbCommonSkillCont = tbObject:RegisterContainer(self.UIGROUP, self.Common_Skill_OBJECT, self.Common_OBJECT_ROW, self.Common_OBJECT_LINE, tbCommonSkillCont)
end

function uiFightSkill:OnDestroy()
  tbObject:UnregContainer(self.tbFightSkillCont)
  tbObject:UnregContainer(self.tbCommonSkillCont)
end

function uiFightSkill:Init()
  self.m_nCurPageNum = 4
  self.m_nSimRouteId = 0 -- 模拟投点的路线
  self.m_bSimTong = 0 -- 是否在模拟投点状态
  self.nCommInsidePage = 1
  self.nCurCommInsidePage = 1
end

-----------------------------------------------------------

--写log
function uiFightSkill:WriteStatLog()
  Log:Ui_SendLog("F3技能界面", 1)
end

function uiFightSkill:OnOpen()
  self.nLastClickChooseBtn = 0
  self.tbFactionList = self:GetGerneFactionInfo(me)
  self.nCurShowFactionPage = self:GetPageIndexByFactionId(me.nFaction)
  self:WriteStatLog()
  Ui(Ui.UI_SIDEBAR):WndOpenCloseCallback(self.UIGROUP, 1)
  if me.nRouteId > 0 and me.nRouteId < #self.PAGE_WND then
    self.m_nCurPageNum = me.nRouteId
  end
  self:Refresh()
  --新手任务指引
  Tutorial:CheckSepcialEvent("FightSkill")
end

function uiFightSkill:GetFactionIdByPageIndex(nPage)
  local nFaction = 0
  if self.tbFactionList then
    nFaction = self.tbFactionList[nPage] or 0
  end
  return nFaction
end

function uiFightSkill:GetPageIndexByFactionId(nMyFaction)
  if not self.tbFactionList or #self.tbFactionList <= 0 then
    return 1
  end
  for nIndex, nFactionId in pairs(self.tbFactionList) do
    if nMyFaction == nFactionId then
      return nIndex
    end
  end
  return 1
end

function uiFightSkill:GetFactionImgByPageIndex(nPage)
  local nFaction = self:GetFactionIdByPageIndex(nPage)

  if nFaction <= 0 then
    return
  end

  local szImg = self.tbIconFaction[nFaction]
  return szImg
end

function uiFightSkill:GetFightSkillListByFaction(nFaction, nRouteId)
  local tbResult = {}

  if nFaction <= 0 or nRouteId <= 0 then
    return
  end

  local tbSkillList = me.GetFightSkillListEx(nFaction, nRouteId)
  for i, nSkillId in pairs(tbSkillList) do
    local tbSkill = {}
    tbSkill.nGenre = 0
    tbSkill.uId = nSkillId
    tbSkill.nReqLevel = 0
    tbSkill.nLevel = 0
    tbSkill.nLevelEx = 0
    tbSkill.nMaxLevel = 0
    tbSkill.nInitiative = 0
    tbResult[i] = tbSkill
  end
  return tbResult
end

function uiFightSkill:GetFightSkillList(nCurShowFactionPage, nRouteId)
  if nRouteId < 0 then
    return me.GetFightSkillList(-1)
  end

  local nMyPage = self:GetPageIndexByFactionId(me.nFaction)
  if nMyPage == nCurShowFactionPage then
    return me.GetFightSkillList(nRouteId)
  end

  local nChooseFaction = self:GetFactionIdByPageIndex(nCurShowFactionPage)
  if nChooseFaction <= 0 then
    return nil
  end

  local tbFactionSkillList = self:GetFightSkillListByFaction(nChooseFaction, nRouteId)

  if not tbFactionSkillList then
    return nil
  end

  local tbFuxiuFactionSkillLevel, nStoreRouteId = Faction:GetStoreFactionSkillList(me, nChooseFaction)
  if tbFuxiuFactionSkillLevel then
    for i, tbSkill in pairs(tbFactionSkillList) do
      if tbFuxiuFactionSkillLevel[tbSkill.uId] then
        tbSkill.nLevel = tbFuxiuFactionSkillLevel[tbSkill.uId]
      end
    end
  end

  return tbFactionSkillList
end

function uiFightSkill:GetGerneFactionInfo(pPlayer)
  local tbFactionList = Faction:GetGerneFactionInfo(pPlayer)
  if not tbFactionList[1] then
    tbFactionList[1] = pPlayer.nFaction
  end
  return tbFactionList
end

function uiFightSkill:OnClose()
  Ui(Ui.UI_SIDEBAR):WndOpenCloseCallback(self.UIGROUP, 0)
end

function uiFightSkill:OnButtonClick(szWnd, nParam)
  if szWnd == self.CLOSE_WINDOW_BUTTON then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.ACCEPT_BUTTON then
    self:PreAccept()
  elseif szWnd == self.CANCEL_BUTTON then
    self:Refresh()
  elseif string.sub(szWnd, 1, 7) == self.BTN_LVUP then
    local x = tonumber(string.sub(szWnd, 10, 10))
    local y = tonumber(string.sub(szWnd, 12, 12))
    self:OnSkillLvUp(x, y)
    Wnd_SetEnable(self.UIGROUP, self.CANCEL_BUTTON, 1)
    Wnd_SetEnable(self.UIGROUP, self.ACCEPT_BUTTON, 1)
  elseif string.sub(szWnd, 1, 9) == self.BTN_LVDOWN then
    local x = tonumber(string.sub(szWnd, 12, 12))
    local y = tonumber(string.sub(szWnd, 14, 14))
    self:OnSkillLvDown(x, y)
  elseif szWnd == self.PAGE_WND[4][1] then
    self.m_nCurPageNum = 4
    self:Refresh()
  elseif string.sub(szWnd, 1, 13) == "BtnKombatPage" then
    self.m_nCurPageNum = tonumber(string.sub(szWnd, 14, 14))
    self.tbFightSkillCont.nCurPage = self.m_nCurPageNum
    self.nCurCommInsidePage = 1
    self:Refresh()
  elseif szWnd == self.BTN_COMMON_PAGEDOWN or szWnd == self.BTN_PAGEDOWN then
    if self.nCurCommInsidePage < self.nCommInsidePage then
      self.nCurCommInsidePage = self.nCurCommInsidePage + 1
      self:Refresh()
    end
  elseif szWnd == self.BTN_COMMON_PAGEUP or szWnd == self.BTN_PAGEUP then
    if self.nCurCommInsidePage > 1 then
      self.nCurCommInsidePage = self.nCurCommInsidePage - 1
      self:Refresh()
    end
  elseif szWnd == self.BTN_CHANGE_FACTION then
    self:ChangeFaction()
  end

  for i = 1, self.COUNT_CHOOSE_FACTION do
    local szBtnChoose = self.BTN_CHOOSE_FACTION .. i
    if szWnd == szBtnChoose then
      self.nLastClickChooseBtn = i
      self.nCurShowFactionPage = i
      local nFaction = self:GetFactionIdByPageIndex(i)
      local nRouteId = Faction:GetStoreFactionRoute(me, nFaction)

      if nFaction == me.nFaction then
        nRouteId = me.nRouteId
      end

      self.m_nCurPageNum = nRouteId
      if not self.m_nCurPageNum or self.m_nCurPageNum <= 0 then
        self.m_nCurPageNum = 4
      end
      self.nCurCommInsidePage = 1
      self:Refresh()
    end
  end
end

function uiFightSkill:ChangeFaction()
  local nPageIndex = self.nCurShowFactionPage
  local nFaction = self:GetFactionIdByPageIndex(nPageIndex)
  if nFaction <= 0 then
    return 0
  end

  if nFaction == me.nFaction then
    return 0
  end

  local nIsCanSwitch = Faction:IsCanSwitchFaction(me, nFaction)
  if 0 == nIsCanSwitch then
    return 0
  end

  local tbMsg = {}
  tbMsg.szMsg = "确定要切换门派吗？\n<color=green>切换后参加义军任务、宋金战场、家族关卡、白虎堂等活动时将获得新门派对应的五行声望，同时在特定NPC处只能购买新门派对应的五行声望装备。<color>"
  tbMsg.nOptCount = 2
  function tbMsg:Callback(nOptIndex, nFaction)
    if nOptIndex == 2 then
      me.CallServerScript({ "ApplySwitchFaction", nFaction })
    end
  end
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nFaction)
end

function uiFightSkill:GetCurPageRemainFightSkillPoint(nPage)
  local nFactionId = me.nFaction
  if self.tbFactionList and self.tbFactionList[nPage] then
    nFactionId = self.tbFactionList[nPage]
  end

  if nFactionId == me.nFaction then
    return me.nRemainFightSkillPoint
  end

  return me.nRemainFightSkillPoint
end

function uiFightSkill:Refresh()
  local nFaction = self:GetFactionIdByPageIndex(self.nCurShowFactionPage)
  if nFaction == 0 then
    self.m_nCurPageNum = 4
  end
  self.nSkillPoint = self:GetCurPageRemainFightSkillPoint(self.nCurShowFactionPage)
  PgSet_ActivePage(self.UIGROUP, self.PAGE_SET_MAIN, self.PAGE_WND[self.m_nCurPageNum][2])
  self.m_nSimRouteId = 0
  self.m_bSimTong = 0

  Wnd_SetEnable(self.UIGROUP, self.CANCEL_BUTTON, 0)
  Wnd_SetEnable(self.UIGROUP, self.ACCEPT_BUTTON, 0)

  Wnd_SetVisible(self.UIGROUP, self.ACCEPT_BUTTON, 1)
  Wnd_SetVisible(self.UIGROUP, self.CANCEL_BUTTON, 1)
  Wnd_SetEnable(self.UIGROUP, self.BTN_CHANGE_FACTION, 0)
  Wnd_SetVisible(self.UIGROUP, self.BTN_CHANGE_FACTION, 0)

  local tbRoutes = KPlayer.GetFactionInfo(nFaction).tbRoutes

  for x = 1, #self.tbFightSkillCont.SKILL_WND do
    if tbRoutes[x] and me.nFaction ~= 0 then
      Wnd_Show(self.UIGROUP, self.PAGE_WND[x][1])
      if x == 1 then
        Btn_SetTxt(self.UIGROUP, self.PAGE_WND[x][1], tbRoutes[x].szName)
      elseif x == 2 then
        Btn_SetTxt(self.UIGROUP, self.PAGE_WND[x][1], tbRoutes[x].szName)
      else
        Btn_SetTxt(self.UIGROUP, self.PAGE_WND[x][1], tbRoutes[x].szName)
      end
    else
      Wnd_Hide(self.UIGROUP, self.PAGE_WND[x][1])
    end
  end

  self:SetPageState()
  self:CleanPage(self.m_nCurPageNum)
  self:UpdateFactionButton()

  if self.m_nCurPageNum == #self.PAGE_WND then
    self:UpdateCommonSkill()
  else
    self:UpdateKombatSkill()
  end

  self:UpDateBgImage()
  self:HideAllSubBtn()
  self:UpdateSkillPoint()
  local nActiveFactionPageIndex = self:GetPageIndexByFactionId(me.nFaction)
  if nActiveFactionPageIndex == self.nCurShowFactionPage then
    Wnd_SetVisible(self.UIGROUP, self.IMG_ZHEZHAO, 0)
    Wnd_SetEnable(self.UIGROUP, self.IMG_ZHEZHAO, 0)
  else
    Wnd_SetVisible(self.UIGROUP, self.IMG_ZHEZHAO, 1)
    Wnd_SetEnable(self.UIGROUP, self.IMG_ZHEZHAO, 1)
  end
end

function uiFightSkill:UpDateBgImage()
  local szPath = "\\image\\ui\\001a\\skill\\fightskill_bg\\"
  local szBgImage = ""
  local nFaction = self:GetFactionIdByPageIndex(self.nCurShowFactionPage)

  if nFaction ~= 0 then
    szBgImage = szPath .. uiFightSkill.FACTION_BG[nFaction]
    Img_SetImage(self.UIGROUP, self.IMG_BG_FACTION, 1, szBgImage)
  end
end

function uiFightSkill:UpdateFactionButton()
  for i = 1, self.COUNT_CHOOSE_FACTION do
    local szBtnChoose = self.BTN_CHOOSE_FACTION .. i
    local szImgChoose = self.IMG_CHOOSE_FACTION .. i
    Img_SetImage(self.UIGROUP, szBtnChoose, 1, self.tbIconFaction[0])
    Img_SetFrame(self.UIGROUP, szImgChoose, self.tbFrame_Choose_Img_State[0])
    Img_SetFrame(self.UIGROUP, szBtnChoose, self.tbFrame_Choose_Btn_State[0])
    Wnd_SetEnable(self.UIGROUP, szBtnChoose, 0)
  end

  local nMyFactionPage = self:GetPageIndexByFactionId(me.nFaction)
  for i = 1, Faction.MAX_MODIFY_TIME do
    local szFactionImg = self:GetFactionImgByPageIndex(i)
    if szFactionImg then
      local szBtnChoose = self.BTN_CHOOSE_FACTION .. i
      Wnd_SetEnable(self.UIGROUP, szBtnChoose, 1)
      Img_SetImage(self.UIGROUP, szBtnChoose, 1, szFactionImg)
      Img_SetFrame(self.UIGROUP, szBtnChoose, self.tbFrame_Choose_Btn_State[0])
    end
  end

  if nMyFactionPage ~= self.nCurShowFactionPage then
    local nOtherFactionId = self:GetFactionIdByPageIndex(self.nCurShowFactionPage)
    local nIsCanSwitch = Faction:IsCanSwitchFaction(me, nOtherFactionId)
    Wnd_SetVisible(self.UIGROUP, self.CANCEL_BUTTON, 0)
    Wnd_SetVisible(self.UIGROUP, self.BTN_CHANGE_FACTION, 1)
    Wnd_SetVisible(self.UIGROUP, self.ACCEPT_BUTTON, 0)
    print("UpdateFactionButton 11 ", nIsCanSwitch, nOtherFactionId)
    if nIsCanSwitch == 0 then
      Wnd_SetEnable(self.UIGROUP, self.BTN_CHANGE_FACTION, 0)
    else
      Wnd_SetEnable(self.UIGROUP, self.BTN_CHANGE_FACTION, 1)
    end
  end

  Img_SetFrame(self.UIGROUP, self.IMG_CHOOSE_FACTION .. self.nCurShowFactionPage, self.tbFrame_Choose_Img_State[1])
  Img_SetFrame(self.UIGROUP, self.BTN_CHOOSE_FACTION .. nMyFactionPage, self.tbFrame_Choose_Btn_State[1])
end

function uiFightSkill:UpdateCommonSkill()
  self:CleanPage(self.m_nCurPageNum)
  local tbSkill = self:GetFightSkillList(self.nCurShowFactionPage, -1)

  if #tbSkill > self.MAXCOUNTS then
    Wnd_SetEnable(self.UIGROUP, self.BTN_COMMON_PAGEUP, 1)
    Wnd_SetEnable(self.UIGROUP, self.BTN_COMMON_PAGEDOWN, 1)
    self.nCommInsidePage = math.floor(#tbSkill / self.MAXCOUNTS) + 1
  else
    Txt_SetTxt(self.UIGROUP, self.TXTPAGE, "1/1")
    Wnd_SetEnable(self.UIGROUP, self.BTN_COMMON_PAGEUP, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_COMMON_PAGEDOWN, 0)
  end

  if self.nCurCommInsidePage == 1 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_COMMON_PAGEUP, 0)
  end

  if self.nCurCommInsidePage == self.nCommInsidePage then
    Wnd_SetEnable(self.UIGROUP, self.BTN_COMMON_PAGEDOWN, 0)
  end

  Txt_SetTxt(self.UIGROUP, self.TXTCOMMONPAGE, self.nCurCommInsidePage .. "/" .. self.nCommInsidePage)
  if tbSkill then
    local nLine = 0
    local nCount = 0
    if #tbSkill >= self.nCurCommInsidePage * self.MAXCOUNTS then
      nCount = self.MAXCOUNTS
    elseif math.mod(#tbSkill, self.MAXCOUNTS) > 0 then
      nCount = math.mod(#tbSkill, self.MAXCOUNTS)
    end
    for i = 1, nCount do
      if math.mod(i, 2) == 0 then
        nLine = math.floor(i / 2)
      else
        nLine = math.floor(i / 2) + 1
      end
      self:AddSkillToPage(nLine, tbSkill[i + (self.nCurCommInsidePage - 1) * 12])
    end
  end
end

function uiFightSkill:ShowSkillPage(tbSkill)
  if tbSkill == nil then
    return
  end

  if #tbSkill > self.MAXCOUNTS then
    Wnd_SetEnable(self.UIGROUP, self.BTN_PAGEUP, 1)
    Wnd_SetEnable(self.UIGROUP, self.BTN_PAGEDOWN, 1)
    local nPage = math.ceil(#tbSkill / self.MAXCOUNTS)
    self.nCommInsidePage = nPage
    --self.nCurCommInsidePage = 1;
    Txt_SetTxt(self.UIGROUP, self.TXTPAGE, self.nCurCommInsidePage .. "/" .. nPage)
  else
    Txt_SetTxt(self.UIGROUP, self.TXTPAGE, "1/1")
    Wnd_SetEnable(self.UIGROUP, self.BTN_PAGEUP, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_PAGEDOWN, 0)
  end

  if self.nCurCommInsidePage == 1 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_PAGEUP, 0)
  end

  if self.nCurCommInsidePage == self.nCommInsidePage then
    Wnd_SetEnable(self.UIGROUP, self.BTN_PAGEDOWN, 0)
  end

  local nStart = (self.nCurCommInsidePage - 1) * 12 + 1
  for i = nStart, nStart + 11 do
    if not tbSkill[i] then
      return
    end
    local nReqLevel = tbSkill[i].nReqLevel
    local nLine = 0
    if nReqLevel == nil then
      return
    end
    if math.mod(i, 2) == 0 then
      nLine = math.floor(i / 2)
    else
      nLine = math.floor(i / 2) + 1
    end
    if nLine > 6 then
      nLine = nLine % 6
      nLine = (nLine == 0) and 6 or nLine
    end
    self:AddSkillToPage(nLine, tbSkill[i])
  end
end

function uiFightSkill:AddSkillToPage(nLine, tbSkill)
  if (not nLine) or not tbSkill then
    return
  end
  local nPage = self.m_nCurPageNum
  local nOffset = self.PAGE_WND[nPage][3][nLine] + 1 -- 在第nLine行的第nOffset列

  self.PAGE_WND[nPage][3][nLine] = nOffset

  if nPage == 4 then
    if not self.tbCommonSkillCont.SKILL_WND[nLine][nOffset] then
      return
    end
    self.tbCommonSkillCont.SKILL_WND[nLine][nOffset][3] = tbSkill.nReqLevel
    self.tbCommonSkillCont.SKILL_WND[nLine][nOffset][4] = tbSkill.nLevel
    self.tbCommonSkillCont.SKILL_WND[nLine][nOffset][5] = tbSkill.nLevelEx
    self.tbCommonSkillCont.SKILL_WND[nLine][nOffset][7] = 0

    self.tbCommonSkillCont.SKILL_WND[nLine][nOffset][8] = tbSkill.uId
    self.tbCommonSkillCont.SKILL_WND[nLine][nOffset][9] = tbSkill.nMaxLevel
    self.tbCommonSkillCont.SKILL_WND[nLine][nOffset][10] = tbSkill.nInitiative

    if self:CanUpSkill(self.tbCommonSkillCont.SKILL_WND[nLine][nOffset]) == 1 then
      Wnd_Show(self.UIGROUP, self.tbCommonSkillCont.SKILL_WND[nLine][nOffset][6])
    else
      if self.tbCommonSkillCont.SKILL_WND[nLine][nOffset][6] then
        Wnd_Hide(self.UIGROUP, self.tbCommonSkillCont.SKILL_WND[nLine][nOffset][6])
      end
    end

    if tbSkill.nLevel > 0 or tbSkill.nLevelEx > 0 then
      Wnd_Show(self.UIGROUP, self.tbCommonSkillCont.SKILL_WND[nLine][nOffset][2])
      local szLevel = tbSkill.nLevel
      if tbSkill.nLevelEx > 0 then
        szLevel = szLevel .. "<color=cyan>+" .. tbSkill.nLevelEx .. "<color>"
      end
      Txt_SetTxt(self.UIGROUP, self.tbCommonSkillCont.SKILL_WND[nLine][nOffset][2], "等级: " .. szLevel)
    else
      if self.tbCommonSkillCont.SKILL_WND[nLine][nOffset][2] then
        Wnd_Hide(self.UIGROUP, self.tbCommonSkillCont.SKILL_WND[nLine][nOffset][2])
      end
    end

    local szSkillName = KFightSkill.GetSkillName(tbSkill.uId)
    Txt_SetTxt(self.UIGROUP, self.tbCommonSkillCont.SKILL_WND[nLine][nOffset][12], szSkillName)
    local tbSkillInfo = KFightSkill.GetSkillInfo(tbSkill.uId, 1)
    if tbSkillInfo.nSkillType == 3 then
      Wnd_Show(self.UIGROUP, self.tbCommonSkillCont.SKILL_WND[nLine][nOffset][14])
      Img_SetImage(self.UIGROUP, self.tbCommonSkillCont.SKILL_WND[nLine][nOffset][14], 1, szPathBeidongSkillImg)
    else
      Wnd_Show(self.UIGROUP, self.tbCommonSkillCont.SKILL_WND[nLine][nOffset][14])
      Img_SetImage(self.UIGROUP, self.tbCommonSkillCont.SKILL_WND[nLine][nOffset][14], 1, szPathZhudongSkillImg)
    end
    local tbObj = nil
    tbObj = {}
    tbObj.nType = Ui.OBJ_FIGHTSKILL
    tbObj.nSkillId = self.tbCommonSkillCont.SKILL_WND[nLine][nOffset][8]
    self.tbCommonSkillCont:SetObj(tbObj, nOffset - 1, nLine - 1)
  else
    if not self.tbFightSkillCont.SKILL_WND[nPage][nLine][nOffset] then
      return
    end
    self.tbFightSkillCont.SKILL_WND[nPage][nLine][nOffset][3] = tbSkill.nReqLevel
    self.tbFightSkillCont.SKILL_WND[nPage][nLine][nOffset][4] = tbSkill.nLevel
    self.tbFightSkillCont.SKILL_WND[nPage][nLine][nOffset][5] = tbSkill.nLevelEx
    self.tbFightSkillCont.SKILL_WND[nPage][nLine][nOffset][8] = tbSkill.uId
    self.tbFightSkillCont.SKILL_WND[nPage][nLine][nOffset][9] = tbSkill.nMaxLevel
    self.tbFightSkillCont.SKILL_WND[nPage][nLine][nOffset][10] = tbSkill.nInitiative

    local nAddPoint = self:GetBackupAddPoint(nLine, nOffset)
    if self.nSkillPoint >= nAddPoint and nAddPoint > 0 then
      self.tbFightSkillCont.SKILL_WND[nPage][nLine][nOffset][7] = nAddPoint
      self.nSkillPoint = self.nSkillPoint - nAddPoint
      Wnd_Show(self.UIGROUP, self.tbFightSkillCont.SKILL_WND[nPage][nLine][nOffset][13])
      Wnd_SetEnable(self.UIGROUP, self.ACCEPT_BUTTON, 1)
      Wnd_SetEnable(self.UIGROUP, self.CANCEL_BUTTON, 1)
    end

    if self:CanUpSkill(self.tbFightSkillCont.SKILL_WND[nPage][nLine][nOffset]) == 1 then
      Wnd_Show(self.UIGROUP, self.tbFightSkillCont.SKILL_WND[nPage][nLine][nOffset][6])
    else
      if self.tbFightSkillCont.SKILL_WND[nPage][nLine][nOffset][6] then
        Wnd_Hide(self.UIGROUP, self.tbFightSkillCont.SKILL_WND[nPage][nLine][nOffset][6])
      end
    end

    if tbSkill.nLevel > 0 or tbSkill.nLevelEx > 0 or nAddPoint > 0 then
      Wnd_Show(self.UIGROUP, self.tbFightSkillCont.SKILL_WND[nPage][nLine][nOffset][2])
      local szLevel = tbSkill.nLevel
      if nAddPoint > 0 then
        szLevel = szLevel .. "+" .. nAddPoint
      end
      if tbSkill.nLevelEx > 0 then
        szLevel = szLevel .. "<color=cyan>+" .. tbSkill.nLevelEx .. "<color>"
      end
      Txt_SetTxt(self.UIGROUP, self.tbFightSkillCont.SKILL_WND[nPage][nLine][nOffset][2], "等级: " .. szLevel)
    else
      if self.tbFightSkillCont.SKILL_WND[nPage][nLine][nOffset][2] then
        Wnd_Hide(self.UIGROUP, self.tbFightSkillCont.SKILL_WND[nPage][nLine][nOffset][2])
      end
    end

    local szSkillName = KFightSkill.GetSkillName(tbSkill.uId)
    Txt_SetTxt(self.UIGROUP, self.tbFightSkillCont.SKILL_WND[nPage][nLine][nOffset][12], szSkillName)
    --local szSkillName = KFightSkill.GetSkillName(tbSkill.uId);
    --Txt_SetTxt(self.UIGROUP, self.tbFightSkillCont.SKILL_WND[nPage][nLine][nOffset][8], szSkillName);
    --print(szSkillName);
    local tbSkillInfo = KFightSkill.GetSkillInfo(tbSkill.uId, 1)
    Txt_SetTxt(self.UIGROUP, self.tbFightSkillCont.SKILL_WND[nPage][nLine][nOffset][12] .. "_a", tbSkillInfo.szProperty)
    if tbSkillInfo.nSkillType == 3 then
      Wnd_Show(self.UIGROUP, self.tbFightSkillCont.SKILL_WND[nPage][nLine][nOffset][14])
      Img_SetImage(self.UIGROUP, self.tbFightSkillCont.SKILL_WND[nPage][nLine][nOffset][14], 1, szPathBeidongSkillImg)
    else
      Wnd_Show(self.UIGROUP, self.tbFightSkillCont.SKILL_WND[nPage][nLine][nOffset][14])
      Img_SetImage(self.UIGROUP, self.tbFightSkillCont.SKILL_WND[nPage][nLine][nOffset][14], 1, szPathZhudongSkillImg)
    end
    local tbObj = nil
    tbObj = {}
    tbObj.nType = Ui.OBJ_FIGHTSKILL
    tbObj.nSkillId = self.tbFightSkillCont.SKILL_WND[nPage][nLine][nOffset][8]
    self.tbFightSkillCont:SetObj(tbObj, nOffset - 1, nLine - 1)
  end
end

function uiFightSkill:UpdateKombatSkill()
  self:CleanPage(self.m_nCurPageNum)
  local tbKombatSkill = self:GetFightSkillList(self.nCurShowFactionPage, self.m_nCurPageNum)
  if tbKombatSkill == nil then
    return
  end
  self:ShowSkillPage(tbKombatSkill)
end

function uiFightSkill:CleanPage(nPage)
  local x = nPage
  if x ~= 4 then
    for y = 1, #self.tbFightSkillCont.SKILL_WND[x] do
      for z = 1, #self.tbFightSkillCont.SKILL_WND[x][y] do
        if self.tbFightSkillCont.SKILL_WND[x][y][z][2] then
          Wnd_Hide(self.UIGROUP, self.tbFightSkillCont.SKILL_WND[x][y][z][2])
        end
        self.tbFightSkillCont.SKILL_WND[x][y][z][3] = 0
        self.tbFightSkillCont.SKILL_WND[x][y][z][4] = 0
        self.tbFightSkillCont.SKILL_WND[x][y][z][5] = 0
        if self.tbFightSkillCont.SKILL_WND[x][y][z][6] then
          Wnd_Hide(self.UIGROUP, self.tbFightSkillCont.SKILL_WND[x][y][z][6])
        end
        self.tbFightSkillCont.SKILL_WND[x][y][z][7] = 0
        self.tbFightSkillCont.SKILL_WND[x][y][z][9] = 0
        self.tbFightSkillCont.SKILL_WND[x][y][z][10] = 0
      end
    end
  elseif x == 4 then
    for y = 1, #tbCommonSkillCont.SKILL_WND do
      for z = 1, #self.tbCommonSkillCont.SKILL_WND[y] do
        if self.tbCommonSkillCont.SKILL_WND[y][z][2] then
          Wnd_Hide(self.UIGROUP, self.tbCommonSkillCont.SKILL_WND[y][z][2])
        end

        if self.tbCommonSkillCont.SKILL_WND[y][z][12] then
          Txt_SetTxt(self.UIGROUP, self.tbCommonSkillCont.SKILL_WND[y][z][12], "")
        end
        self.tbCommonSkillCont.SKILL_WND[y][z][3] = 0
        self.tbCommonSkillCont.SKILL_WND[y][z][4] = 0
        self.tbCommonSkillCont.SKILL_WND[y][z][5] = 0
        if self.tbCommonSkillCont.SKILL_WND[y][z][6] then
          Wnd_Hide(self.UIGROUP, self.tbCommonSkillCont.SKILL_WND[y][z][6])
        end
        self.tbCommonSkillCont.SKILL_WND[y][z][7] = 0
        self.tbCommonSkillCont.SKILL_WND[y][z][9] = 0
        self.tbCommonSkillCont.SKILL_WND[y][z][10] = 0
      end
    end
  end

  for y = 1, #self.PAGE_WND[x][3] do
    self.PAGE_WND[x][3][y] = 0
  end
  for i = 1, 6 do
    for j = 1, 2 do
      Txt_SetTxt(self.UIGROUP, "TxtName1_" .. i .. "_" .. j, "")
      Txt_SetTxt(self.UIGROUP, "TxtName1_" .. i .. "_" .. j .. "_a", "")
      Wnd_Hide(self.UIGROUP, "Imgbg1_" .. i .. "_" .. j)
      Wnd_Hide(self.UIGROUP, "Imgbg4_" .. i .. "_" .. j)
    end
  end
  self.tbFightSkillCont:ClearObj()
  self.tbCommonSkillCont:ClearObj()
end

function uiFightSkill:SetPageState()
  Btn_Check(self.UIGROUP, self.PAGE_WND[1][1], 0)
  Btn_Check(self.UIGROUP, self.PAGE_WND[2][1], 0)
  Btn_Check(self.UIGROUP, self.PAGE_WND[3][1], 0)
  Btn_Check(self.UIGROUP, self.PAGE_WND[4][1], 0)
  Btn_Check(self.UIGROUP, self.PAGE_WND[self.m_nCurPageNum][1], 1)
  Wnd_Hide(self.UIGROUP, self.PAGE_WND[1][2])
  Wnd_Hide(self.UIGROUP, self.PAGE_WND[4][2])
  Wnd_Show(self.UIGROUP, self.PAGE_WND[self.m_nCurPageNum][2])
end

function uiFightSkill:UpdateSkillPoint()
  Txt_SetTxt(self.UIGROUP, self.SKILL_POINT_TEXT, self.nSkillPoint)
end

function uiFightSkill:OnSkillLvUp(x, y)
  if x == nil or y == nil then
    return
  end

  self.m_bSimTong = 1
  local nPage = self.m_nCurPageNum

  if me.nRouteId == nil or me.nRouteId == 0 then -- 没有路线
    self.m_nSimRouteId = self.m_nCurPageNum
  end

  local tbSkill = self.tbFightSkillCont.SKILL_WND[nPage][x][y]
  tbSkill[7] = tbSkill[7] + 1 -- 模拟投点+1
  self.nSkillPoint = self.nSkillPoint - 1 -- 技能点模拟-1
  self:UpdateSkillPoint()
  Wnd_Show(self.UIGROUP, tbSkill[13]) -- 显示减按钮
  -- 重设显示等级
  local szLevel = tbSkill[4]
  if tbSkill[7] > 0 then
    szLevel = szLevel .. "+" .. tbSkill[7]
  end

  if tbSkill[5] > 0 then
    szLevel = szLevel .. "<color=cyan>+" .. tbSkill[5] .. "<color>"
  end

  Txt_SetTxt(self.UIGROUP, tbSkill[2], "等级: " .. szLevel)
  Wnd_Show(self.UIGROUP, tbSkill[2])

  if self.nSkillPoint <= 0 then -- 投完了
    self:HideAllAddBtn()
    return
  end

  if self:CanUpSkill(tbSkill) == 1 then
    Wnd_Show(self.UIGROUP, tbSkill[6])
  else
    Wnd_Hide(self.UIGROUP, tbSkill[6])
  end
end

function uiFightSkill:OnSkillLvDown(x, y)
  if x == nil or y == nil then
    return
  end

  self.m_bSimTong = 1
  local nPage = self.m_nCurPageNum

  if me.nRouteId == nil or me.nRouteId == 0 then -- 没有路线
    self.m_nSimRouteId = self.m_nCurPageNum
  end

  local tbSkill = self.tbFightSkillCont.SKILL_WND[nPage][x][y]
  tbSkill[7] = tbSkill[7] - 1 -- 模拟投点-1
  self.nSkillPoint = self.nSkillPoint + 1 -- 技能点模拟+1
  self:UpdateSkillPoint()
  if tbSkill[7] <= 0 then
    Wnd_Hide(self.UIGROUP, tbSkill[13])
  end
  -- 重设显示等级
  local szLevel = tbSkill[4]
  if tbSkill[7] > 0 then
    szLevel = szLevel .. "+" .. tbSkill[7]
  end

  if tbSkill[5] > 0 then
    szLevel = szLevel .. "<color=cyan>+" .. tbSkill[5] .. "<color>"
  end

  Txt_SetTxt(self.UIGROUP, tbSkill[2], "等级: " .. szLevel)
  Wnd_Show(self.UIGROUP, tbSkill[2])

  if self.nSkillPoint <= 0 then -- 投完了
    self:HideAllAddBtn()
    return
  else
    self:ShowAllAddBtn()
    return
  end

  if self:CanUpSkill(tbSkill) == 1 then
    Wnd_Show(self.UIGROUP, tbSkill[6])
  else
    Wnd_Hide(self.UIGROUP, tbSkill[6])
  end
end

function uiFightSkill:CanUpSkill(tbSkill)
  local nReqLevel = tbSkill[3]
  local nTmpLevel = tbSkill[7]
  local nLevel = tbSkill[4] + nTmpLevel
  local nMaxLevel = tbSkill[9]
  -- 潜能点限制
  if self.nSkillPoint == 0 then
    return 0
  -- 路线限制
  elseif me.nRouteId ~= 0 and me.nRouteId ~= self.m_nCurPageNum then
    return 0
  -- 公共技能
  elseif self.m_nCurPageNum == 4 then
    return 0
  --	elseif self.m_nSimRouteId ~= 0 and self.m_nSimRouteId ~= self.m_nCurPageNum then
  --		return 0;
  -- 等级限制
  elseif nLevel >= nMaxLevel then
    return 0
  elseif nReqLevel + nLevel > me.nLevel then
    return 0
    --elseif (nReqLevel >= 120) then
    --	return 0;
  end
  local nResult = FightSkill:CheckCanAddSkillPoint(me.GetNpc(), tbSkill[8])
  return nResult
end

-- 是否高亮
function uiFightSkill:IsHighLight(tbSkill)
  local nReqLevel = tbSkill[3]

  if me.nRouteId ~= 0 and me.nRouteId ~= self.m_nCurPageNum then
    return 0
  elseif nReqLevel > me.nLevel then
    return 0
  end

  return 1
end

function uiFightSkill:HideAllSubBtn()
  local tPage = self.tbFightSkillCont.SKILL_WND[self.m_nCurPageNum]
  if tPage then
    for nX = 1, #tPage do
      for nY = 1, #tPage[nX] do
        if tPage[nX][nY][7] == 0 then
          Wnd_Hide(self.UIGROUP, tPage[nX][nY][13])
        end
      end
    end
  end
end

function uiFightSkill:HideAllAddBtn()
  local tPage = self.tbFightSkillCont.SKILL_WND[self.m_nCurPageNum]
  for nX = 1, #tPage do
    for nY = 1, #tPage[nX] do
      Wnd_Hide(self.UIGROUP, tPage[nX][nY][6])
    end
  end
end

function uiFightSkill:ShowAllAddBtn()
  local tPage = self.tbFightSkillCont.SKILL_WND[self.m_nCurPageNum]
  local nPage = self.m_nCurPageNum
  for nX = 1, #tPage do
    for nY = 1, #tPage[nX] do
      local tbSkill = self.tbFightSkillCont.SKILL_WND[nPage][nX][nY]
      if self:CanUpSkill(tbSkill) == 1 then
        Wnd_Show(self.UIGROUP, tbSkill[6])
      else
        Wnd_Hide(self.UIGROUP, tbSkill[6])
      end
    end
  end
end

function uiFightSkill:PreAccept()
  if me.nRouteId == 0 then -- 提示确定路线
    local tbMsg = {}
    tbMsg.szMsg = "是否确定选择该路线?"
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex, fnRefresh, fnAccept, tbSelf)
      if nOptIndex == 1 then
        fnRefresh(tbSelf)
      elseif nOptIndex == 2 then
        fnAccept(tbSelf)
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, self.Refresh, self.OnAccept, self)
    if me.nLevel < 60 then
      UiNotify:OnNotify(UiNotify.emCOREEVENT_SET_POPTIP, 28) -- TODO: 临时做法
    end
  else
    self:OnAccept()
  end
end

function uiFightSkill:OnAccept()
  local nRoute = self.m_nCurPageNum
  local tPage = self.tbFightSkillCont.SKILL_WND[self.m_nCurPageNum]
  local nPoint = 0
  for nX = 1, #tPage do
    for nY = 1, #tPage[nX] do
      nPoint = tPage[nX][nY][7]
      if nPoint > 0 then
        me.LevelUpFightSkill(nRoute, tPage[nX][nY][8], nPoint)
      end
    end
  end
  self:Refresh()
end

function uiFightSkill:UpdateSkillCallback(nSkill)
  if UiManager:WindowVisible(Ui.UI_FIGHTSKILL) ~= 0 then
    self:BackUpEnviroment()
  end

  self.nSkillPoint = nSkill
  me.SetTask(2062, 4, me.GetActiveAuraSkill())
  if UiManager:WindowVisible(Ui.UI_FIGHTSKILL) ~= 0 then
    self:Refresh()
    self:RealseBackupEnviroment()
  end
end

function uiFightSkill:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_FIGHT_SKILL_POINT, self.UpdateSkillCallback },
    { UiNotify.emCOREEVENT_CHANGEACTIVEAURA, self.UpdateSkillCallback },
  }
  tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbFightSkillCont:RegisterEvent())
  tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbCommonSkillCont:RegisterEvent())
  return tbRegEvent
end

function uiFightSkill:RegisterMessage()
  local tbRegMsg = Lib:MergeTable(self.tbFightSkillCont:RegisterMessage(), self.tbCommonSkillCont:RegisterMessage())
  return tbRegMsg
end
function uiFightSkill:BackUpEnviroment()
  if self.m_nCurPageNum == #self.PAGE_WND or self.m_nCurPageNum == 4 then
    return
  end

  self.tbBackUp = {}

  local nTempAddPoint = 0

  local tbPageSkill = self.tbFightSkillCont.SKILL_WND[self.m_nCurPageNum]
  for x, tbXSkill in pairs(tbPageSkill) do
    for y, tbSkill in pairs(tbXSkill) do
      -- 合法性判断，一旦不合法，清空备份
      nTempAddPoint = nTempAddPoint + tbSkill[7]
      if nTempAddPoint > me.nRemainFightSkillPoint then
        self.tbBackUp = nil
        return
      end

      self.tbBackUp[x] = self.tbBackUp[x] or {}
      self.tbBackUp[x][y] = tbSkill[7]
    end
  end

  if #self.tbBackUp == 0 then
    self.tbBackUp = nil
  end
end

function uiFightSkill:RealseBackupEnviroment()
  self.tbBackUp = nil
end

function uiFightSkill:GetBackupAddPoint(x, y)
  --print("GetBackupAddPoint", x, y);
  if not self.tbBackUp or not self.tbBackUp[x] or not self.tbBackUp[x][y] then
    return 0
  end

  return self.tbBackUp[x][y]
end

function uiFightSkill:OnMouseEnter(szWnd)
  for i = 1, self.COUNT_CHOOSE_FACTION do
    local szBtnChoose = self.BTN_CHOOSE_FACTION .. i
    if szWnd == szBtnChoose then
      local szImgChoose = self.IMG_CHOOSE_FACTION .. i
      Img_SetFrame(self.UIGROUP, szImgChoose, self.tbFrame_Choose_Img_State[1])
    end
  end
end

function uiFightSkill:OnMouseLeave(szWnd)
  for i = 1, self.COUNT_CHOOSE_FACTION do
    local szBtnChoose = self.BTN_CHOOSE_FACTION .. i
    if szWnd == szBtnChoose then
      local szImgChoose = self.IMG_CHOOSE_FACTION .. i
      if i == self.nCurShowFactionPage then
        Img_SetFrame(self.UIGROUP, szImgChoose, self.tbFrame_Choose_Img_State[1])
      else
        Img_SetFrame(self.UIGROUP, szImgChoose, self.tbFrame_Choose_Img_State[0])
      end
    end
  end
end
