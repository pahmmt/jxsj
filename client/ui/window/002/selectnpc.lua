-- ====================== 文件信息 ======================

-- 选择玩家或NPC状态界面脚本
-- Edited by peres
-- 2007/09/28 PM 00:33

-- 她的眼泪轻轻地掉落下来
-- 抚摸着自己的肩头，寂寥的眼神
-- 是，褪掉繁华和名利带给的空洞安慰，她只是一个一无所有的女子
-- 不爱任何人，亦不相信有人会爱她

-- ======================================================

local tbSelectNpc = Ui:GetClass("selectnpc")
local tbTimer = Ui.tbLogic.tbTimer

tbSelectNpc.MAIN = "Main"
tbSelectNpc.IMG_PARTNER = "ImgPartner"
tbSelectNpc.IMG_PLAYER_PORTRAIT = "ImgPortrait"
tbSelectNpc.PROGRESS_LIFE = "ImgPartLife"
tbSelectNpc.PROGRESS_MANA = "ImgPartMana"
tbSelectNpc.IMG_SCHOOLCOURSES = "ImgSchoolCourses"
tbSelectNpc.TEXT_LEVEL = "TxtLevel"
tbSelectNpc.TEXT_LIFE = "TxtLife"
tbSelectNpc.TEXT_MANA = "TxtMana"
tbSelectNpc.TEXT_NAME = "TxtName"
tbSelectNpc.BTN_INTERACT = "BtnInteract"
tbSelectNpc.BTN_CARRIERACTION = "BtnCarrierAction"
tbSelectNpc.IMG_KINBADGE = "Img_KinBadge"

tbSelectNpc.szMainPage = "\\image\\ui\\002a\\selectnpc\\bg_npc"

tbSelectNpc.tbTZSPR = {
  [1] = "\\image\\ui\\002a\\playerstate\\icon_huangxin.spr",
  [2] = "\\image\\ui\\002a\\playerstate\\icon_lanxin.spr",
}

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

local tbMenuItem = { "查看玩家", "加为好友 ", "与其交易", " 跟随  " }

--怪物五行SPR路径
tbSelectNpc.SPR_NPC_PORTRAIT_GOLD = "\\image\\ui\\002a\\playerstate\\wuxing_icon\\jin.spr"
tbSelectNpc.SPR_NPC_PORTRAIT_WOOD = "\\image\\ui\\002a\\playerstate\\wuxing_icon\\mu.spr"
tbSelectNpc.SPR_NPC_PORTRAIT_WATER = "\\image\\ui\\002a\\playerstate\\wuxing_icon\\shui.spr"
tbSelectNpc.SPR_NPC_PORTRAIT_FIRE = "\\image\\ui\\002a\\playerstate\\wuxing_icon\\huo.spr"
tbSelectNpc.SPR_NPC_PORTRAIT_EARTH = "\\image\\ui\\002a\\playerstate\\wuxing_icon\\tu.spr"
tbSelectNpc.SKILLID_STATE = 379
tbSelectNpc.REFRESHTIME = Env.GAME_FPS / 2 -- 定时刷新时间，1/2 秒

function tbSelectNpc:Init()
  self.nTimerId = 0
  self.pPlayerInfo = nil
end

function tbSelectNpc:OnOpen(pNpc)
  if not pNpc then
    return 0
  end
  if pNpc.GetPlayerKinBadge() > 0 then
    Img_SetImage(self.UIGROUP, "Main", 1, self.szMainPage .. "2.spr")
  else
    Img_SetImage(self.UIGROUP, "Main", 1, self.szMainPage .. "1.spr")
  end
  Wnd_Hide(self.UIGROUP, self.IMG_PARTNER)
  self.pPlayerInfo = pNpc
  if self.pPlayerInfo and self.pPlayerInfo.nKind >= 0 and self.pPlayerInfo.nKind <= 3 then
    if self.pPlayerInfo.nKind == 1 then
      Wnd_SetEnable(self.UIGROUP, self.BTN_INTERACT, 1)
      self.nIsPlayer = 1
    else
      Wnd_SetEnable(self.UIGROUP, self.BTN_INTERACT, 0)
      self.nIsPlayer = 0
      local nType = self:GetPartnerType(pNpc)
      if nType ~= 0 then
        Img_SetImage(self.UIGROUP, self.IMG_PARTNER, 1, self.tbTZSPR[nType])
        Wnd_Show(self.UIGROUP, self.IMG_PARTNER)
      end
    end
  end
  local TK_PLAYERCARRIERSKILLS_TASKGROUP = 2200
  local TK_PLAYERISINNEWBATTLE = 1 -- PLAYER TASK 是否在战场
  --NPC是载具，显示上下载具按钮
  if pNpc.IsCarrier() == 1 then
    if me.GetTask(TK_PLAYERCARRIERSKILLS_TASKGROUP, TK_PLAYERISINNEWBATTLE) == 1 then
      -- 用NPC名字来判断阵营- -
      local tbName2Power = {
        ["宋"] = 1,
        ["金"] = 2,
      }
      local szPower = string.sub(pNpc.szName, 1, 2)
      if tbName2Power[szPower] then
        local nPlayerPower = me.GetCurCamp()
        if tbName2Power[szPower] == nPlayerPower then
          if me.IsInCarrier() ~= 1 or me.GetCarrierNpc().dwId == pNpc.dwId then
            Wnd_Show(self.UIGROUP, self.BTN_CARRIERACTION)
            local _, _, nAbsX, nAbsY = Wnd_GetPos(self.UIGROUP, self.BTN_CARRIERACTION)
            Tutorial:ShowWindowEx(4, nAbsX, nAbsY, -40, 26)
          end
        end
      end
    end
  end
  self.pPlayerInfo.AddTaskState(self.SKILLID_STATE) -- 画圈圈
  self:TimerRegister()
  self:UpdatePlayerState()
  return 1
end

function tbSelectNpc:OnClose()
  if self.nTimerId and (self.nTimerId ~= 0) then
    tbTimer:Close(self.nTimerId)
    self.nTimerId = 0
  end
  if self.pPlayerInfo then
    self.pPlayerInfo.RemoveTaskState(self.SKILLID_STATE)
  end
  UiManager:CloseWindow(Ui.UI_WEDDING)
end

function tbSelectNpc:UpdatePlayerState()
  local pNpc = KNpc.GetById(self.pPlayerInfo.dwId)
  if pNpc == nil then
    UiManager:CloseWindow(self.UIGROUP)
    return
  end
  self.pPlayerInfo = pNpc
  self:UpdateLife()
  self:UpdateMana()
  self:UpdateLevel()
  self:UpdateName()
  self:UpdatePortrait()
  self:UpdateKinBadge()
end

function tbSelectNpc:UpdateKinBadge()
  if self.pPlayerInfo.GetPlayerKinBadge() > 0 and Kin.tbKinBadge[self.pPlayerInfo.GetPlayerKinBadge()] then
    Img_SetImage(self.UIGROUP, self.IMG_KINBADGE, 1, Kin.tbKinBadge[self.pPlayerInfo.GetPlayerKinBadge()].QueueBadge)
  end
end

function tbSelectNpc:UpdateLife()
  Prg_SetPos(self.UIGROUP, self.PROGRESS_LIFE, self.pPlayerInfo.nCurLife / self.pPlayerInfo.nMaxLife * 1000)
  Txt_SetTxt(self.UIGROUP, self.TEXT_LIFE, self.pPlayerInfo.nCurLife .. "/" .. self.pPlayerInfo.nMaxLife)
end

function tbSelectNpc:UpdateMana()
  local nMaxMana = 0
  if self.pPlayerInfo.nMaxMana == 0 or self.pPlayerInfo.nMaxMana == nil then
    nMaxMana = 100
  else
    nMaxMana = self.pPlayerInfo.nMaxMana
  end
  Prg_SetPos(self.UIGROUP, self.PROGRESS_MANA, self.pPlayerInfo.nCurMana / nMaxMana * 1000)
  --Txt_SetTxt(self.UIGROUP, self.TEXT_MANA, self.pPlayerInfo.nCurMana.."/"..self.pPlayerInfo.nMaxMana);
end

function tbSelectNpc:UpdateLevel()
  Txt_SetTxt(self.UIGROUP, self.TEXT_LEVEL, self.pPlayerInfo.nLevel .. "级")
end

function tbSelectNpc:UpdateName()
  Txt_SetTxt(self.UIGROUP, self.TEXT_NAME, self.pPlayerInfo.szName)
end

function tbSelectNpc:UpdatePortrait()
  local nSex = self.pPlayerInfo.nSex
  local nSeries = self.pPlayerInfo.nSeries
  if nSex >= 0 then -- NPC无性别
    local szSpr = GetPortraitSpr(self.pPlayerInfo.nPortrait, nSex, 1)
    Img_SetImage(self.UIGROUP, self.IMG_PLAYER_PORTRAIT, 1, szSpr)
    Img_SetImage(self.UIGROUP, self.IMG_SCHOOLCOURSES, 1, tbSchollcourseRes[self.pPlayerInfo.nFaction])
  else
    Img_SetImage(self.UIGROUP, self.IMG_PLAYER_PORTRAIT, 1, "")
    if nSeries == 1 then
      Img_SetImage(self.UIGROUP, self.IMG_SCHOOLCOURSES, 1, self.SPR_NPC_PORTRAIT_GOLD)
    elseif nSeries == 2 then
      Img_SetImage(self.UIGROUP, self.IMG_SCHOOLCOURSES, 1, self.SPR_NPC_PORTRAIT_WOOD)
    elseif nSeries == 3 then
      Img_SetImage(self.UIGROUP, self.IMG_SCHOOLCOURSES, 1, self.SPR_NPC_PORTRAIT_WATER)
    elseif nSeries == 4 then
      Img_SetImage(self.UIGROUP, self.IMG_SCHOOLCOURSES, 1, self.SPR_NPC_PORTRAIT_FIRE)
    elseif nSeries == 5 then
      Img_SetImage(self.UIGROUP, self.IMG_SCHOOLCOURSES, 1, self.SPR_NPC_PORTRAIT_EARTH)
    else
      Img_SetImage(self.UIGROUP, self.IMG_SCHOOLCOURSES, 1, "")
    end
  end
end

-- 点击快捷按键处理
function tbSelectNpc:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_INTERACT then
    self:ShowMenuItem(szWnd, nParam)
  end
  if szWnd == self.BTN_CARRIERACTION then
    UiManager:OnNKeyDown()
  end
end

function tbSelectNpc:ShowMenuItem(szWnd, nParam)
  DisplayPopupMenu(self.UIGROUP, szWnd, 4, nParam, tbMenuItem[1], 1, tbMenuItem[2], 2, tbMenuItem[3], 3, tbMenuItem[4], 4)
end

function tbSelectNpc:OnPopUpMenu(szWnd, nParam)
  if szWnd == self.IMG_SCHOOLCOURSES and self.nIsPlayer == 1 then
    self:ShowMenuItem(szWnd, nParam)
  end
end

function tbSelectNpc:OnMenuItemSelected(szWnd, nItemId, nListIndex)
  if szWnd == self.IMG_SCHOOLCOURSES or szWnd == self.BTN_INTERACT then
    if nItemId == 1 then
      local bSucess = ProcessNpcById(self.pPlayerInfo.dwId, UiManager.emACTION_VIEWITEM)
      if bSucess == 0 then
        UiManager:CloseWindow(Ui.UI_VIEWPLAYER)
        me.Msg("虽然您很想查看该玩家，但无奈距离太远了！")
      end
    elseif nItemId == 2 then
      ProcessNpcById(self.pPlayerInfo.dwId, UiManager.emACTION_MAKEFRIEND)
    elseif nItemId == 3 then
      ProcessNpcById(self.pPlayerInfo.dwId, UiManager.emACTION_TRADE)
    elseif nItemId == 4 then
      ProcessNpcById(self.pPlayerInfo.dwId, UiManager.emACTION_FOLLOW)
    end
  end
end

-- 定时刷新
function tbSelectNpc:TimerRegister()
  self.nTimerId = tbTimer:Register(self.REFRESHTIME, self.OnTimer, self)
end

function tbSelectNpc:OnTimer()
  if self.pPlayerInfo then
    self:UpdatePlayerState()
  end
end

-- 获取选中NPC能变成同伴的类型
-- 不能变成同伴，不能转真元的同伴，能转真元的同伴
function tbSelectNpc:GetPartnerType(pNpc)
  if not Partner or not Partner.tbPersuadeInfo[pNpc.nTemplateId] then
    return 0 -- 不能转同伴
  end

  local nPartTempId = Partner.tbPersuadeInfo[pNpc.nTemplateId]
  if not nPartTempId or not Item.tbZhenYuanSetting.tbPartnerToZhenYuan[nPartTempId] then
    return 1 -- 不能转真元的同伴
  else
    return 2 -- 能转真元的同伴
  end

  return 0
end
