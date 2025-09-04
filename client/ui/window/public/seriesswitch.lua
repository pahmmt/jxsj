local tbSeriesSwitch = Ui:GetClass("seriesswitch")
local tbObject = Ui.tbLogic.tbObject
local tbMouse = Ui.tbLogic.tbMouse

local tbEquipCont = { nRoom = Item.ROOM_EQUIP }

function tbEquipCont:EndSwitchMouse(tbMouseObj, tbObj, nX, nY)
  Ui(Ui.UI_SERIESSWITCH):UpdateActiveInfo()
end

local BTN_CLOSE = "BtnClose"
local BTN_SWITCH = "BtnSwitch"
local TXT_NAME = "TxtName" -- Ö÷½ÇÃû×Ö
local TXT_STATE_HURT = "TxtStateHurt" -- Ö÷½Ç×´Ì¬£º¼õÊÜÉË
local TXT_STATE_SLOWALL = "TxtStateSlowAll" -- Ö÷½Ç×´Ì¬£º¼õ³Ù»º
local TXT_STATE_WEAK = "TxtStateWeak" -- Ö÷½Ç×´Ì¬£º¼õÐéÈõ
local TXT_STATE_BURN = "TxtStateBurn" -- Ö÷½Ç×´Ì¬£º¼õ×ÆÉË
local TXT_STATE_STUN = "TxtStateStun" -- Ö÷½Ç×´Ì¬£º¼õÑ£ÔÎ
local TXT_GENERAL_RESIST = "TxtGeneralResist" -- Ö÷½Ç¿¹ÐÔ£ºÆÕ·À
local TXT_POISON_RESIST = "TxtPoisonResist" -- Ö÷½Ç¿¹ÐÔ£º¶¾·À
local TXT_COLD_RESIST = "TxtColdResist" -- Ö÷½Ç¿¹ÐÔ£º±ù·À
local TXT_FIRE_RESIST = "TxtFireResist" -- Ö÷½Ç¿¹ÐÔ£º»ð·À
local TXT_LIGHT_RESIST = "TxtLightResist" -- Ö÷½Ç¿¹ÐÔ£ºÀ×·À
local TXT_ATTACK_RATE = "TxtAttackRate" -- Ö÷½ÇÊôÐÔ£ºÃüÖÐ
local TXT_DEFENSE = "TxtDefense" -- Ö÷½ÇÊôÐÔ£ºÉÁ±Ü
local TXT_RUN_SPEED = "TxtRunSpeed" -- Ö÷½ÇÊôÐÔ£ºÅÜËÙ
local TXT_ATTACK_SPEED = "TxtAttackSpeed" -- Ö÷½ÇÊôÐÔ£º¹¥ËÙ
local TXT_LEFTDAMAGE = "TxtLeftDamage" -- Ö÷½ÇÊôÐÔ£º×ó¼ü¹¥»÷Á¦
local TXT_RIGHTDAMAGE = "TxtRightDamage" -- Ö÷½ÇÊôÐÔ£ºÓÒ¼ü¹¥»÷Á¦

local SELF_EQUIPMENT = -- ×°±¸¿Ø¼þ±í
  {
    { Item.EQUIPPOS_HEAD, "ObjHead", "ImgHead", "1" },
    { Item.EQUIPPOS_BODY, "ObjBody", "ImgBody", "5" },
    { Item.EQUIPPOS_BELT, "ObjBelt", "ImgBelt", "4" },
    { Item.EQUIPPOS_WEAPON, "ObjWeapon", "ImgWeapon", "a" },
    { Item.EQUIPPOS_FOOT, "ObjFoot", "ImgFoot", "2" },
    { Item.EQUIPPOS_CUFF, "ObjCuff", "ImgCuff", "3" },
    { Item.EQUIPPOS_AMULET, "ObjAmulet", "ImgAmulet", "b" },
    { Item.EQUIPPOS_RING, "ObjRing", "ImgRing", "d" },
    { Item.EQUIPPOS_NECKLACE, "ObjNecklace", "ImgNecklace", "e" },
    { Item.EQUIPPOS_PENDANT, "ObjPendant", "ImgPendant", "c" },
  }

function tbSeriesSwitch:Init()
  self.szHighLightEquipPos = nil
end

function tbSeriesSwitch:OnCreate()
  self.tbEquipCont = {}
  for i, tb in ipairs(SELF_EQUIPMENT) do
    local nPos = tb[1]
    local tbCont = tbObject:RegisterContainer(self.UIGROUP, tb[2], 1, 1, tbEquipCont, "equiproom")
    tbCont.nOffsetX = nPos
    self.tbEquipCont[nPos] = tbCont
  end
end

function tbSeriesSwitch:OnDestroy()
  for _, tbCont in pairs(self.tbEquipCont) do
    tbObject:UnregContainer(tbCont)
  end
end

function tbSeriesSwitch:OnOpen()
  self:UpdateName()
  self:UpdateState()
  self:UpdateResist()
  self:UpdateAttrib()
  self:UpdateDamageInfo()
  self:UpdateEquipment()
  self:UpdateActiveInfo()
end

function tbSeriesSwitch:OnClose()
  for _, tbCont in pairs(self.tbEquipCont) do
    tbCont:ClearRoom()
  end
end

function tbSeriesSwitch:OnMouseEnter(szWnd)
  local szTip = ""
  if szWnd == TEXT_BASIC_AS then
    szTip = me.GetAttackSpeedTip()
  elseif szWnd == TXT_GENERAL_RESIST then
    szTip = me.GetResistTip(Env.SERIES_METAL)
  elseif szWnd == TXT_POISON_RESIST then
    szTip = me.GetResistTip(Env.SERIES_WOOD)
  elseif szWnd == TXT_COLD_RESIST then
    szTip = me.GetResistTip(Env.SERIES_WATER)
  elseif szWnd == TXT_FIRE_RESIST then
    szTip = me.GetResistTip(Env.SERIES_FIRE)
  elseif szWnd == TXT_LIGHT_RESIST then
    szTip = me.GetResistTip(Env.SERIES_EARTH)
  elseif szWnd == TXT_STATE_HURT then
    szTip = me.GetStateTip(Npc.STATE_HURT)
  elseif szWnd == TXT_STATE_SLOWALL then
    szTip = me.GetStateTip(Npc.STATE_SLOWALL)
  elseif szWnd == TXT_STATE_WEAK then
    szTip = me.GetStateTip(Npc.STATE_WEAK)
  elseif szWnd == TXT_STATE_BURN then
    szTip = me.GetStateTip(Npc.STATE_BURN)
  elseif szWnd == TXT_STATE_STUN then
    szTip = me.GetStateTip(Npc.STATE_STUN)
  end
  if szTip ~= "" then
    Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, "", szTip)
  end
end

function tbSeriesSwitch:OnMouseLeave(szWnd)
  Wnd_HideMouseHoverInfo()
end

function tbSeriesSwitch:UpdateName()
  Txt_SetTxt(self.UIGROUP, TXT_NAME, me.szName)
end

function tbSeriesSwitch:UpdateState()
  local pNpc = me.GetNpc()
  Txt_SetTxt(self.UIGROUP, TXT_STATE_HURT, "¼õÊÜÉË£º" .. pNpc.GetState(Npc.STATE_HURT).nResistTime)
  Txt_SetTxt(self.UIGROUP, TXT_STATE_SLOWALL, "¼õ³Ù»º£º" .. pNpc.GetState(Npc.STATE_SLOWALL).nResistTime)
  Txt_SetTxt(self.UIGROUP, TXT_STATE_WEAK, "¼õÐéÈõ£º" .. pNpc.GetState(Npc.STATE_WEAK).nResistTime)
  Txt_SetTxt(self.UIGROUP, TXT_STATE_BURN, "¼õ×ÆÉË£º" .. pNpc.GetState(Npc.STATE_BURN).nResistTime)
  Txt_SetTxt(self.UIGROUP, TXT_STATE_STUN, "¼õÑ£ÔÎ£º" .. pNpc.GetState(Npc.STATE_STUN).nResistTime)
end

function tbSeriesSwitch:UpdateResist()
  Txt_SetTxt(self.UIGROUP, TXT_GENERAL_RESIST, "ÆÕ·À£º" .. me.nGR)
  Txt_SetTxt(self.UIGROUP, TXT_POISON_RESIST, "¶¾·À£º" .. me.nPR)
  Txt_SetTxt(self.UIGROUP, TXT_COLD_RESIST, "±ù·À£º" .. me.nCR)
  Txt_SetTxt(self.UIGROUP, TXT_FIRE_RESIST, "»ð·À£º" .. me.nFR)
  Txt_SetTxt(self.UIGROUP, TXT_LIGHT_RESIST, "À×·À£º" .. me.nLR)
end

function tbSeriesSwitch:UpdateAttrib()
  local nLeft = me.nLeftAR
  local nRight = me.nRightAR
  if nLeft < 0 then
    nLeft = "-"
  end
  if nRight < 0 then
    nRight = "-"
  end
  Txt_SetTxt(self.UIGROUP, TXT_ATTACK_RATE, "ÃüÖÐ£º" .. nLeft .. "/" .. nRight)
  Txt_SetTxt(self.UIGROUP, TXT_DEFENSE, "ÉÁ±Ü£º" .. me.nDefense)
  Txt_SetTxt(self.UIGROUP, TXT_RUN_SPEED, "ÅÜËÙ£º" .. me.nRunSpeed)
  Txt_SetTxt(self.UIGROUP, TXT_ATTACK_SPEED, "¹¥ËÙ£º" .. me.nAttackSpeed .. "/" .. me.nCastSpeed)
end

function tbSeriesSwitch:UpdateDamageInfo()
  local nLeft = me.nLeftDamageMin
  local nRight = me.nLeftDamageMax
  if nLeft < 0 then
    nLeft = 0
  end
  if nRight < 0 then
    nRight = 0
  end
  Txt_SetTxt(self.UIGROUP, TXT_LEFTDAMAGE, "×ó¼üÉ±ÉË£º\t" .. nLeft .. " - " .. nRight)
  nLeft = me.nRightDamageMin
  nRight = me.nRightDamageMax
  if nLeft < 0 then
    nLeft = 0
  end
  if nRight < 0 then
    nRight = 0
  end
  Txt_SetTxt(self.UIGROUP, TXT_RIGHTDAMAGE, "ÓÒ¼üÉ±ÉË£º\t" .. nLeft .. " - " .. nRight)
end

function tbSeriesSwitch:OnButtonClick(szWndName, nParam)
  if szWndName == BTN_CLOSE then
    UiManager:OpenWindow(Ui.UI_PLAYERPANEL)
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWndName == BTN_SWITCH then
    UiManager:OpenWindow(Ui.UI_PLAYERPANEL)
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function tbSeriesSwitch:GetEquipWndTableItem(nPosition)
  for _, tbEquipItem in ipairs(SELF_EQUIPMENT) do
    if tbEquipItem[1] == nPosition then
      return tbEquipItem
    end
  end
end

function tbSeriesSwitch:UpdateEquipment()
  for i, tbCont in pairs(self.tbEquipCont) do
    tbCont:UpdateRoom()
  end
end

function tbSeriesSwitch:GetEquipPos(szWnd)
  for _, tbEquipItem in ipairs(SELF_EQUIPMENT) do
    if tbEquipItem[2] == szWnd then
      return tbEquipItem[1]
    end
  end
end

function tbSeriesSwitch:UpdateActiveInfo()
  for _, tbEquipItem in ipairs(SELF_EQUIPMENT) do
    local nEquipPos = tbEquipItem[1]
    local nActive1, nActive2 = KItem.GetEquipActive(nEquipPos)
    self:CheckActiveLine(nActive1, nEquipPos)
    self:CheckActiveLine(nActive2, nEquipPos)
  end
end

function tbSeriesSwitch:CheckActiveLine(nSrc, nDest)
  if (not nSrc) or not nDest then
    return
  end

  nSrc = nSrc + 1
  nDest = nDest + 1

  local szLine = "ALine_" .. SELF_EQUIPMENT[nSrc][4] .. "_" .. SELF_EQUIPMENT[nDest][4]
  local nSrcType = SELF_EQUIPMENT[nSrc][1]
  local nDestType = SELF_EQUIPMENT[nDest][1]
  local pSrc = me.GetEquip(nSrcType)
  local pDest = me.GetEquip(nDestType)

  if (not pSrc) or not pDest then
    Img_SetFrame(self.UIGROUP, szLine, 1)
    return
  end

  if pSrc.nSeries == KMath.AccruedSeries(pDest.nSeries) then
    Img_SetFrame(self.UIGROUP, szLine, 0)
  else
    Img_SetFrame(self.UIGROUP, szLine, 1)
  end
end

function tbSeriesSwitch:SyncEquipment(nRoom, nX, nY)
  if nRoom == Item.ROOM_EQUIP then
    self:UpdateActiveInfo()
  end
end

function tbSeriesSwitch:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_STATE, self.UpdateState },
    { UiNotify.emCOREEVENT_SYNC_DAMAGE, self.UpdateDamageInfo },
    { UiNotify.emCOREEVENT_SYNC_DEFENSE, self.UpdateAttrib },
    { UiNotify.emCOREEVENT_SYNC_RUNSPEED, self.UpdateAttrib },
    { UiNotify.emCOREEVENT_SYNC_RESIST, self.UpdateResist },
    { UiNotify.emCOREEVENT_SYNC_ATTACKRATE, self.UpdateAttrib },
    { UiNotify.emCOREEVENT_SYNC_ATTACKSPEED, self.UpdateAttrib },
    { UiNotify.emCOREEVENT_SYNC_ITEM, self.SyncEquipment },
  }
  for _, tbEquip in pairs(self.tbEquipCont) do
    tbRegEvent = Lib:MergeTable(tbRegEvent, tbEquip:RegisterEvent())
  end
  return tbRegEvent
end

function tbSeriesSwitch:RegisterMessage()
  local tbRegMsg = {}
  for _, tbEquip in pairs(self.tbEquipCont) do
    tbRegMsg = Lib:MergeTable(tbRegMsg, tbEquip:RegisterMessage())
  end
  return tbRegMsg
end
