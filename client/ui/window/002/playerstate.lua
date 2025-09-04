-----------------------------------------------------
--文件名		：	playerstate.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-04-19
--功能描述		：	主角头像界面
------------------------------------------------------

local tbPlayerState = Ui:GetClass("playerstate")
local tbTimer = Ui.tbLogic.tbTimer
local TXT_LEVEL = "TxtLevel"
local TXT_LIFE = "TxtLife"
local TXT_MANA = "TxtMana"
local TXT_STAMINA = "TxtStamina"
local TXT_NAME = "TxtName"
local IMG_PORTRAIT = "ImgPortrait"
local PRG_LIFE = "ImgPartLife"
local PRG_MANA = "ImgPartMana"
local PRG_STAMINA = "ImgPartStamina"
local IMG_SCHOOLCOURSES = "ImgSchoolCourses"
local BTN_INTERACT = "BtnInteract"
local IMG_BGRES = "ImgBgRes"
local IMG_BGRESBG = "ImgBgResBg"
local BTN_EASY_STATE = "BtnEasyState"
local POPTIP_DELAYTIME = Env.GAME_FPS * 30 -- 泡泡延时显示时间

local tbSchollcourseRes = {
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

local tbSkillCountResOffSet = -- 控制不同数量的背景图跟技能图标的偏移坐标
  {
    [1] = { { 9, 0 } },
    [2] = { { -2, -1 }, { 9, 0 } },
    [3] = { { -2, -1 }, { 9, 0 }, { 0, 0 } },
  }

local tbSkillCountBgResPath = {
  [2817] = "\\image\\ui\\002a\\playerstate\\jiangumubeijing1.spr",
  [2818] = "\\image\\ui\\002a\\playerstate\\jiangumubeijing2.spr",
  [2846] = "\\image\\ui\\002a\\playerstate\\zhengumubeijing.spr",
}

local tbSkillCountResPath = {
  [2817] = "\\image\\ui\\002a\\playerstate\\jin.spr",
  [2818] = "\\image\\ui\\002a\\playerstate\\jue.spr",
  [2846] = "\\image\\ui\\002a\\playerstate\\cuncunsi.spr",
}

local tbBuffCountResPath = {
  [2817] = "\\image\\ui\\002a\\playerstate\\number_yellow.spr",
  [2818] = "\\image\\ui\\002a\\playerstate\\number_blue.spr",
  [2846] = "\\image\\ui\\002a\\playerstate\\number_blue.spr",
}
-- 技能资源显示
local tbSkillCountRes = {
  [Env.FACTION_ID_GUMU] = { -- skillid, path
    [1] = { 2817, 2818 },
    [2] = { 2846 },
  },
}

local tbMenuItem = { "离开队伍", "战斗力 ", "自动战斗", "解锁  " }

function tbPlayerState:OnOpen()
  self:UpdateAll()
  self.tbMenuFun = {
    { self.CmdLeaveTeam },
    { self.CmdViewFightPower },
    { self.CmdAutoFight },
    { self.CmdOnLock },
  }
  if UiManager:WindowVisible(Ui.UI_EASY_PLAYERSTATE) == 1 then
    UiManager:CloseWindow(Ui.UI_EASY_PLAYERSTATE)
  end
end

function tbPlayerState:CmdLeaveTeam()
  me.TeamLeave()
end

function tbPlayerState:CmdViewFightPower()
  if UiManager:WindowVisible(Ui.UI_FIGHTPOWER) == 1 then
    UiManager:CloseWindow(Ui.UI_FIGHTPOWER)
  else
    if 1 == Player.tbFightPower:IsFightPowerValid() then
      UiManager:SwitchWindow(Ui.UI_FIGHTPOWER)
    else
      Ui:ServerCall("UI_TASKTIPS", "Begin", "战斗力系统还未开放，敬请期待")
    end
  end
end

function tbPlayerState:CmdAutoFight()
  UiManager:SwitchWindow(Ui.UI_AUTOFIGHT)
end

function tbPlayerState:CmdOnLock()
  UiManager:SwitchWindow(Ui.UI_LOCKACCOUNT)
end

function tbPlayerState:OnMouseEnter(szWnd) end

function tbPlayerState:OnMouseLeave(szWnd)
  Wnd_HideMouseHoverInfo()
end

function tbPlayerState:UpdateAll()
  self:UpdateLife()
  self:UpdateMana()
  self:UpdateStamina()
  self:UpdateLevel()
  self:UpdatePortrait()
  self:UpdateName()
  self:UpdateSchoolCourses()
end

function tbPlayerState:UpdateLife()
  Prg_SetPos(self.UIGROUP, PRG_LIFE, me.nCurLife / me.nMaxLife * 1000)
  Txt_SetTxt(self.UIGROUP, TXT_LIFE, me.nCurLife .. "/" .. me.nMaxLife)
end

function tbPlayerState:UpdateMana()
  Prg_SetPos(self.UIGROUP, PRG_MANA, me.nCurMana / me.nMaxMana * 1000)
  Txt_SetTxt(self.UIGROUP, TXT_MANA, me.nCurMana .. "/" .. me.nMaxMana)
end

function tbPlayerState:UpdateStamina()
  Prg_SetPos(self.UIGROUP, PRG_STAMINA, me.nCurStamina / me.nMaxStamina * 1000)
  Txt_SetTxt(self.UIGROUP, TXT_STAMINA, me.nCurStamina .. "/" .. me.nMaxStamina)
end

function tbPlayerState:UpdateLevel()
  Txt_SetTxt(self.UIGROUP, TXT_LEVEL, me.nLevel .. "级")
end

function tbPlayerState:UpdatePortrait()
  local szSpr = GetPortraitSpr(me.nPortrait, me.nSex, 1)
  Img_SetImage(self.UIGROUP, IMG_PORTRAIT, 1, szSpr)
end

function tbPlayerState:UpdateName()
  Txt_SetTxt(self.UIGROUP, TXT_NAME, me.szName)
end

function tbPlayerState:UpdateSchoolCourses()
  Img_SetImage(self.UIGROUP, IMG_SCHOOLCOURSES, 1, tbSchollcourseRes[me.nFaction])
  self:UpdateSkillCountRes()
end

function tbPlayerState:UpdateSkillCountRes()
  if UiVersion ~= Ui.Version002 then
    return
  end
  local nFaction = me.nFaction
  local nRouteId = me.nRouteId
  local nShowCount = 0
  if tbSkillCountRes[nFaction] and tbSkillCountRes[nFaction][nRouteId] then
    nShowCount = #tbSkillCountRes[nFaction][nRouteId]
    for i = 1, nShowCount do
      local nSkillId = tbSkillCountRes[nFaction][nRouteId][i]
      local nSkillLevel = 0
      local tbBuffList = me.GetBuffList()
      local nFlag = 0
      for j = 1, #tbBuffList do
        local tbInfo = me.GetBuffInfo(tbBuffList[j].uId)
        if tbInfo then
          if tbInfo.nSkillId == nSkillId then
            nFlag = 1
            nSkillLevel = tbInfo.nLevel
            break
          end
        end
      end
      local nBuffCount = 0
      local nMaxBuffCount = -1
      if nFlag == 1 then
        nBuffCount, nMaxBuffCount = self:GetBuffCount(nSkillId)
      end
      local szImageBgRes = IMG_BGRES .. i
      local szImageBgResBg = IMG_BGRESBG .. i
      local szImageBgResCount = szImageBgRes .. "Count"
      local szImageResBgCountPath = tbSkillCountBgResPath[nSkillId]
      local szImageResCountPath = tbSkillCountResPath[nSkillId]
      local szBuffCountResPath = tbBuffCountResPath[nSkillId]
      local tbOffset = tbSkillCountResOffSet[nShowCount][i]
      if nBuffCount > 0 then
        Wnd_Show(self.UIGROUP, szImageBgResBg)
        Wnd_Show(self.UIGROUP, szImageBgRes)
        Wnd_Show(self.UIGROUP, szImageBgResCount)
        Wnd_SetPos(self.UIGROUP, szImageBgRes, tbOffset[1], tbOffset[2])
        Img_SetImage(self.UIGROUP, szImageBgResBg, 1, szImageResBgCountPath)
        Img_SetImage(self.UIGROUP, szImageBgRes, 1, szImageResCountPath)
        if nBuffCount == nMaxBuffCount then
          Img_SetFrame(self.UIGROUP, szImageBgRes, 2)
        else
          Img_SetFrame(self.UIGROUP, szImageBgRes, 1)
        end
        Img_SetImage(self.UIGROUP, szImageBgResCount, 1, szBuffCountResPath)
        Img_SetFrame(self.UIGROUP, szImageBgResCount, nBuffCount - 1)
      else
        Wnd_Show(self.UIGROUP, szImageBgResBg)
        Wnd_Show(self.UIGROUP, szImageBgRes)
        Wnd_Hide(self.UIGROUP, szImageBgResCount)
        Wnd_SetPos(self.UIGROUP, szImageBgRes, tbOffset[1], tbOffset[2])
        Img_SetImage(self.UIGROUP, szImageBgResBg, 1, szImageResBgCountPath)
        Img_SetImage(self.UIGROUP, szImageBgRes, 1, szImageResCountPath)
        Img_SetFrame(self.UIGROUP, szImageBgRes, 0)
      end
    end
  end
  for i = nShowCount + 1, 3 do
    Wnd_Hide(self.UIGROUP, IMG_BGRESBG .. i)
    Wnd_Hide(self.UIGROUP, IMG_BGRES .. i)
    Wnd_Hide(self.UIGROUP, IMG_BGRES .. i .. "Count")
  end
end

function tbPlayerState:GetBuffCount(nSkillId)
  local tbStateInfo = KFightSkill.GetStateInfo(nSkillId)
  if not tbStateInfo then
    return 0, -1
  end
  for szDesc, tbMagic in pairs(tbStateInfo.tbWholeMagic) do
    if szDesc == "superposemagic" and tbMagic[2] > 0 then
      return tbMagic[2], tbMagic[1] -- 返回当前次数和最大次数
    end
  end
  return 0, -1
end

function tbPlayerState:OnButtonClick(szWnd, nParam)
  if szWnd == BTN_INTERACT then
    self:ShowMenuItem(szWnd, nParam)
  elseif szWnd == BTN_EASY_STATE then
    local tbPos = {}
    local nOrgX, nOrgY = Wnd_GetPos(self.UIGROUP)
    UiManager:CloseWindow(self.UIGROUP)
    UiManager:OpenWindow(Ui.UI_EASY_PLAYERSTATE)
    Wnd_SetPos(Ui.UI_EASY_PLAYERSTATE, "Main", nOrgX, nOrgY + 17)
  end
end

function tbPlayerState:OnPopUpMenu(szWnd, nParam)
  if szWnd == IMG_SCHOOLCOURSES then
    self:ShowMenuItem(szWnd, nParam)
  end
end

function tbPlayerState:ShowMenuItem(szWnd, nParam)
  if me.nTeamId > 0 then
    DisplayPopupMenu(self.UIGROUP, szWnd, 4, nParam, tbMenuItem[1], 1, tbMenuItem[2], 2, tbMenuItem[3], 3, tbMenuItem[4], 4)
  else
    DisplayPopupMenu(self.UIGROUP, szWnd, 3, nParam, tbMenuItem[2], 2, tbMenuItem[3], 3, tbMenuItem[4], 4)
  end
end

function tbPlayerState:OnMenuItemSelected(szWnd, nItemId, nListIndex)
  if szWnd == IMG_SCHOOLCOURSES or szWnd == BTN_INTERACT then
    if nItemId and nItemId <= #tbMenuItem then
      if self.tbMenuFun[nItemId] then
        self.tbMenuFun[nItemId][1](self)
      end
    end
  end
end

function tbPlayerState:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_LIFE, self.UpdateLife },
    { UiNotify.emCOREEVENT_SYNC_MANA, self.UpdateMana },
    { UiNotify.emCOREEVENT_SYNC_STAMINA, self.UpdateStamina },
    { UiNotify.emCOREEVENT_SYNC_SEX, self.UpdatePortrait },
    { UiNotify.emCOREEVENT_SYNC_PORTRAIT, self.UpdatePortrait },
    { UiNotify.emCOREEVENT_SYNC_LEVEL, self.UpdateLevel },
    { UiNotify.emCOREEVENT_SYNC_FACTION, self.UpdateSchoolCourses },
    { UiNotify.emCOREEVENT_CHANGE_FACTION_FINISHED, self.UpdateSchoolCourses },
    { UiNotify.emCOREEVENT_SYNC_ROUTE, self.UpdateSchoolCourses },
    { UiNotify.emCOREEVENT_BUFF_CHANGE, self.UpdateSkillCountRes },
  }
  return tbRegEvent
end
