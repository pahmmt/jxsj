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
local tbViewPlayerMgr = Ui.tbLogic.tbViewPlayerMgr

tbSelectNpc.MAIN = "Main"
tbSelectNpc.IMG_PARTNER = "ImgPartner"
tbSelectNpc.IMG_PLAYER_PORTRAIT = "ImgPortrait"
tbSelectNpc.PROGRESS_LIFE = "ImgPartLife"
tbSelectNpc.PROGRESS_MANA = "ImgPartMana"
tbSelectNpc.TEXT_LEVEL = "TxtLevel"
tbSelectNpc.TEXT_LIFE = "TxtLife"
tbSelectNpc.TEXT_MANA = "TxtMana"
tbSelectNpc.TEXT_NAME = "TxtName"
tbSelectNpc.WND_SHORTCUR = "ShortCut"
tbSelectNpc.BTN_LOOK = "Btn_Look"
tbSelectNpc.BTN_FRIEND = "Btn_Friend"
tbSelectNpc.BTN_TRADE = "Btn_Trade"
tbSelectNpc.BTN_FOLLOW = "Btn_Follow"

tbSelectNpc.tbBGSPR = {
  [1] = "\\image\\ui\\001a\\main\\bg_selectplayer_tong.spr",
  [2] = "\\image\\ui\\001a\\main\\bg_selectplayer_zhen.spr",
}

--怪物五行SPR路径
tbSelectNpc.SPR_NPC_PORTRAIT_GOLD = "\\image\\icon\\npc\\portrait\\portrait_npc_gold" .. UiManager.IVER_szVnSpr
tbSelectNpc.SPR_NPC_PORTRAIT_WOOD = "\\image\\icon\\npc\\portrait\\portrait_npc_wood" .. UiManager.IVER_szVnSpr
tbSelectNpc.SPR_NPC_PORTRAIT_WATER = "\\image\\icon\\npc\\portrait\\portrait_npc_water" .. UiManager.IVER_szVnSpr
tbSelectNpc.SPR_NPC_PORTRAIT_FIRE = "\\image\\icon\\npc\\portrait\\portrait_npc_fire" .. UiManager.IVER_szVnSpr
tbSelectNpc.SPR_NPC_PORTRAIT_EARTH = "\\image\\icon\\npc\\portrait\\portrait_npc_earth" .. UiManager.IVER_szVnSpr
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
  Wnd_Hide(self.UIGROUP, self.IMG_PARTNER)
  self.pPlayerInfo = pNpc
  if self.pPlayerInfo and self.pPlayerInfo.nKind >= 0 and self.pPlayerInfo.nKind <= 3 then
    -- 区分是玩家还是NPC，玩家的话则显示四个快捷键
    if self.pPlayerInfo.nKind == 1 then
      Wnd_Show(self.UIGROUP, self.WND_SHORTCUR)
    else
      Wnd_Hide(self.UIGROUP, self.WND_SHORTCUR)
      local nType = self:GetPartnerType(pNpc)
      if nType ~= 0 then
        Img_SetImage(self.UIGROUP, self.MAIN, 1, self.tbBGSPR[nType])
        Wnd_Show(self.UIGROUP, self.IMG_PARTNER)
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
  Txt_SetTxt(self.UIGROUP, self.TEXT_LEVEL, self.pPlayerInfo.nLevel)
end

function tbSelectNpc:UpdateName()
  Txt_SetTxt(self.UIGROUP, self.TEXT_NAME, self.pPlayerInfo.szName)
end

function tbSelectNpc:UpdatePortrait()
  local nSex = self.pPlayerInfo.nSex

  if nSex < 0 then -- NPC无性别，判断战斗npc的头像按五行划分（edited by kenmasterwu）
    local nKind = self.pPlayerInfo.nKind
    local nSeries = self.pPlayerInfo.nSeries
    if self.pPlayerInfo and nKind == 0 then
      if nSeries == 1 then
        Img_SetImage(self.UIGROUP, self.IMG_PLAYER_PORTRAIT, 1, self.SPR_NPC_PORTRAIT_GOLD)
      elseif nSeries == 2 then
        Img_SetImage(self.UIGROUP, self.IMG_PLAYER_PORTRAIT, 1, self.SPR_NPC_PORTRAIT_WOOD)
      elseif nSeries == 3 then
        Img_SetImage(self.UIGROUP, self.IMG_PLAYER_PORTRAIT, 1, self.SPR_NPC_PORTRAIT_WATER)
      elseif nSeries == 4 then
        Img_SetImage(self.UIGROUP, self.IMG_PLAYER_PORTRAIT, 1, self.SPR_NPC_PORTRAIT_FIRE)
      elseif nSeries == 5 then
        Img_SetImage(self.UIGROUP, self.IMG_PLAYER_PORTRAIT, 1, self.SPR_NPC_PORTRAIT_EARTH)
      else
        Img_SetImage(self.UIGROUP, self.IMG_PLAYER_PORTRAIT, 1, "")
      end
    else
      Img_SetImage(self.UIGROUP, self.IMG_PLAYER_PORTRAIT, 1, "")
    end
    return
  end
  local szSpr, nType = tbViewPlayerMgr:GetPortraitSpr(self.pPlayerInfo.szName, self.pPlayerInfo.nPortrait, nSex)
  Img_SetImage(self.UIGROUP, self.IMG_PLAYER_PORTRAIT, nType, szSpr)
end

-- 点击快捷按键处理
function tbSelectNpc:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_LOOK then
    local bSucess = ProcessNpcById(self.pPlayerInfo.dwId, UiManager.emACTION_VIEWITEM)
    if bSucess == 0 then
      UiManager:CloseWindow(Ui.UI_VIEWPLAYER)
      me.Msg("虽然您很想查看该玩家，但无奈距离太远了！")
    end
  elseif szWnd == self.BTN_FRIEND then
    ProcessNpcById(self.pPlayerInfo.dwId, UiManager.emACTION_MAKEFRIEND)
  elseif szWnd == self.BTN_TRADE then
    ProcessNpcById(self.pPlayerInfo.dwId, UiManager.emACTION_TRADE)
  elseif szWnd == self.BTN_FOLLOW then
    ProcessNpcById(self.pPlayerInfo.dwId, UiManager.emACTION_FOLLOW)
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
