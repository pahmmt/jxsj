------------------------------------------------------
-- 文件名　：other_equip.lua
-- 创建者　：dengyong
-- 创建时间：2011-09-15 11:45:34
-- 描  述  ：新UI 备用/同伴装备界面
------------------------------------------------------
local uiOtherEquip = Ui:GetClass("other_equip")
local tbObject = Ui.tbLogic.tbObject

local TXT_TITLE = "TxtTitle"
local BTN_CLOSE = "BtnClose"

local BACKUP_EQUIPMENT = -- 备用装备控件表
  {
    { Item.EQUIPEXPOS_HEAD, "ObjHead", "TxtHead", "ImgHead" },
    { Item.EQUIPEXPOS_BODY, "ObjBody", "TxtBody", "ImgBody" },
    { Item.EQUIPEXPOS_BELT, "ObjBelt", "TxtBelt", "ImgBelt" },
    { Item.EQUIPEXPOS_WEAPON, "ObjWeapon", "TxtWeapon", "ImgWeapon" },
    { Item.EQUIPEXPOS_FOOT, "ObjFoot", "TxtFoot", "ImgFoot" },
    { Item.EQUIPEXPOS_CUFF, "ObjCuff", "TxtCuff", "ImgCuff" },
    { Item.EQUIPEXPOS_AMULET, "ObjAmulet", "TxtAmulet", "ImgAmulet" },
    { Item.EQUIPEXPOS_RING, "ObjRing", "TxtRing", "ImgRing" },
    { Item.EQUIPEXPOS_NECKLACE, "ObjNecklace", "TxtNecklace", "ImgNecklace" },
    { Item.EQUIPEXPOS_PENDANT, "ObjPendant", "TxtPendant", "ImgPendant" },
  }

local tbObjDisplayOrder = {
  Item.EQUIPEXPOS_HEAD,
  Item.EQUIPEXPOS_BODY,
  Item.EQUIPEXPOS_BELT,
  Item.EQUIPEXPOS_CUFF,
  Item.EQUIPEXPOS_FOOT,
  Item.EQUIPEXPOS_WEAPON,
  Item.EQUIPEXPOS_NECKLACE,
  Item.EQUIPEXPOS_RING,
  Item.EQUIPEXPOS_PENDANT,
  Item.EQUIPEXPOS_AMULET,
}

local PARTNER_EQUIPMENT_TIP = -- 备用装备控件表
  {
    [Item.EQUIPEXPOS_HEAD] = { "ObjHead", "ImgHead", "同伴装备之武器，主要强化角色攻击能力。" },
    [Item.EQUIPEXPOS_BODY] = { "ObjBody", "ImgBody", "同伴装备之衣服，主要强化角色防御能力。" },
    [Item.EQUIPEXPOS_BELT] = { "ObjBelt", "ImgBelt", "同伴装备之戒指，强化角色攻击力+防御力。" },
    [Item.EQUIPEXPOS_CUFF] = { "ObjCuff", "ImgCuff", "同伴装备之护腕，强化角色防御力+攻击力。" },
    [Item.EQUIPEXPOS_FOOT] = { "ObjFoot", "ImgFoot", "同伴装备之护身符，大幅度提升角色攻击能力。" },
  }

-- 不是按格子的顺序，是按tbObjDisplayOrder中的顺序
local tbRoomTextList = {
  [1] = { "帽子", "衣服", "腰带", "护腕", "鞋子", "武器", "项链", "戒指", "腰坠", "护身符" },
  [2] = { "武器", "衣服", "戒指", "护腕", "护身符" },
}

local tbTitleTxt = { "备用装备", "同伴装备" }

-- 从模式1切到模式2，相关obj在界面上要做如下偏移
local tbObjOffset = { 29, 0 }
local MAIN_OFFSET_FROM_PLAYERPANEL = 11
uiOtherEquip.nObjCount = 0

local tbBackGroundIamge = {
  [1] = { "\\image\\ui\\002a\\other_equip\\bg_other_equip.spr", 140, 262 },
  [2] = { "\\image\\ui\\002a\\other_equip\\bg_tongban_equip.spr", 140, 262 },
}

function uiOtherEquip:Init()
  self.nObjCount = 0
end

function uiOtherEquip:OnCreate()
  self:CreateObjRoom()
end

-- nModel: 1备用装备，2同伴装备
function uiOtherEquip:OnOpen(nModel)
  self.nModel = nModel

  if self.nModel == 1 then
    self.nObjCount = Item.EQUIPPOS_PENDANT + 1
  else
    self.nObjCount = Item.PARTNEREQUIP_NUM
  end

  self:UpdateWindow()
  self:UpdateTextList()
  self:UpdateEquipment()
  self:UpdateEquipDur()
end

-- 让窗口始终贴着F1面板显示
function uiOtherEquip:PostOpen()
  -- 始终右边紧贴着F1面板显示
  local nX, nY = Wnd_GetPos(Ui.UI_PLAYERPANEL, "Main")
  local nWidth, nHeight = Wnd_GetSize(Ui.UI_PLAYERPANEL, "Main")
  -- 为了统一处理，这里都用备用装备的大小来计算
  local nMyWidth, nMyHeight = Wnd_GetSize(self.UIGROUP, "Main")
  local nCalWidth, nCalHeight = tbBackGroundIamge[1][2], tbBackGroundIamge[1][3]

  local nNewX, nNewY
  local nScreenWidth, nScreenHeight = unpack(Env.DISPLAY_RESOLUTION[GetUiMode()])

  if nX + nWidth - MAIN_OFFSET_FROM_PLAYERPANEL + nCalWidth <= nScreenWidth then
    -- 紧贴着右边
    nNewX = nX + nWidth - MAIN_OFFSET_FROM_PLAYERPANEL
  elseif nX + MAIN_OFFSET_FROM_PLAYERPANEL >= nCalWidth then
    -- 右边不能显示完整，紧贴着左边
    nNewX = nX + MAIN_OFFSET_FROM_PLAYERPANEL - nMyWidth
  else
    -- 左右两边都不能完整显式，哪边空间大就贴哪边
    if nX + nWidth / 2 > nScreenWidth / 2 then
      nNewX = nX + MAIN_OFFSET_FROM_PLAYERPANEL - nMyWidth
    else
      nNewX = nX + nWidth - MAIN_OFFSET_FROM_PLAYERPANEL
    end
  end

  nNewY = nY + (nHeight - nCalHeight) / 2

  if nNewX and nNewY then
    Wnd_SetPos(self.UIGROUP, "Main", nNewX, nNewY)
  end
end

-- 关闭
function uiOtherEquip:OnClose()
  for _, tbCont in pairs(self.tbEquipCont) do
    tbCont:ClearRoom()
  end
end

function uiOtherEquip:OnDestroy()
  for _, tbCont in pairs(self.tbEquipCont) do
    tbObject:UnregContainer(tbCont)
  end
end

function uiOtherEquip:OnButtonClick(szWnd, wParam)
  if szWnd == BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
    Ui(Ui.UI_PLAYERPANEL).nShowEquipEx = 0
    Ui(Ui.UI_PLAYERPANEL).nShowPartnerEquip = 0
  end
end

----------------------------------------------------------------------------------------

function uiOtherEquip:CreateObjRoom()
  self.tbEquipCont = {}
  for _, tb in ipairs(BACKUP_EQUIPMENT) do
    --for i = 1, self.nObjCount do
    --	local tb = BACKUP_EQUIPMENT[i];
    local nPos = tb[1]
    self.tbEquipCont[nPos] = tbObject:RegisterContainer(self.UIGROUP, tb[2], 1, 1, { nOffsetX = nPos }, "equiproom")
  end
end

-- 两种模式下的显式内容不同，这里特做此处理
function uiOtherEquip:UpdateWindow()
  Img_SetImage(self.UIGROUP, "Main", 1, tbBackGroundIamge[self.nModel][1]) --spr
  Wnd_SetSize(self.UIGROUP, "Main", tbBackGroundIamge[self.nModel][2], tbBackGroundIamge[self.nModel][3])

  -- 前5个格子修改属性
  for i = 1, Item.PARTNEREQUIP_NUM do
    local nIndex = tbObjDisplayOrder[i]
    local tbCont = self.tbEquipCont[nIndex]
    if self.nModel == 1 then
      tbCont.nRoom = Item.ROOM_EQUIPEX
      tbCont.nOffsetX = nIndex
    else
      tbCont.nRoom = Item.ROOM_PARTNEREQUIP
      tbCont.nOffsetX = i - 1
    end
    tbCont:UpdateRoom()

    -- 在界面上的位置需要做偏移
    local tb = BACKUP_EQUIPMENT[nIndex + 1]
    local nX, nY, nAX, nAY = Wnd_GetPos(self.UIGROUP, tb[4])
    if self.nModel == 2 then
      Wnd_SetPos(self.UIGROUP, tb[4], nX + tbObjOffset[1], nY + tbObjOffset[2])
    end
  end

  -- 显示/隐藏后五个obj格子
  for i = Item.PARTNEREQUIP_NUM + 1, #tbObjDisplayOrder do
    local tb = BACKUP_EQUIPMENT[tbObjDisplayOrder[i] + 1]
    if self.nModel == 1 then
      Wnd_Show(self.UIGROUP, tb[4])
    else
      Wnd_Hide(self.UIGROUP, tb[4])
    end
  end

  self:UpdateCellEquipTips()
end

-- 更新各obj的文字提示
function uiOtherEquip:UpdateTextList()
  local tbText = tbRoomTextList[self.nModel]

  for i = 1, #tbText do
    local nObjIndex = tbObjDisplayOrder[i] + 1
    Txt_SetTxt(self.UIGROUP, BACKUP_EQUIPMENT[nObjIndex][3], tbText[i])
  end

  Txt_SetTxt(self.UIGROUP, TXT_TITLE, tbTitleTxt[self.nModel])
end

function uiOtherEquip:UpdateCellEquipTips()
  for _, tbCont in pairs(self.tbEquipCont) do
    local tbTips = PARTNER_EQUIPMENT_TIP[nPos]
    if tbTips then
      Wnd_SetTip(self.UIGROUP, tbTips[2], "")
    end
  end

  if self.nModel == 2 then
    -- nRoomType = Item.ROOM_PARTNEREQUIP;
    for nPos, tbCont in pairs(self.tbEquipCont) do
      local tbTips = PARTNER_EQUIPMENT_TIP[nPos]
      if tbTips then
        local pItem = me.GetItem(Item.ROOM_PARTNEREQUIP, tbCont.nOffsetX, tbCont.nOffsetY)
        if pItem then
          Wnd_SetTip(self.UIGROUP, tbTips[2], "")
        else
          Wnd_SetTip(self.UIGROUP, tbTips[2], tbTips[3])
        end
      end
    end
  end
end

function uiOtherEquip:UpdateEquipment()
  local nRoomType = Item.ROOM_EQUIPEX
  if self.nModel == 2 then
    nRoomType = Item.ROOM_PARTNEREQUIP
  end

  for _, tbCont in pairs(self.tbEquipCont) do
    tbCont.nRoom = nRoomType
    tbCont:UpdateRoom()
  end

  self:UpdateCellEquipTips()
end

function uiOtherEquip:UpdateEquipDur()
  if self.nModel == 1 then
    for _, tbCont in pairs(self.tbEquipCont) do
      if tbCont then
        local pItem = me.GetItem(tbCont.nRoom, tbCont.nOffsetX, tbCont.nOffsetY)
        if pItem then
          if tbCont.nOffsetX >= Item.EQUIPEXPOS_HEAD and tbCont.nOffsetX <= Item.EQUIPEXPOS_PENDANT then
            ObjGrid_ShowSubScript(tbCont.szUiGroup, tbCont.szObjGrid, 1, 0, 0)
            local nPerDur = math.ceil((pItem.nCurDur / pItem.nMaxDur) * 100)
            if nPerDur > 0 and nPerDur <= 10 then
              ObjGrid_ChangeSubScriptColor(tbCont.szUiGroup, tbCont.szObjGrid, "Red")
            elseif nPerDur > 10 and nPerDur <= 60 then
              ObjGrid_ChangeSubScriptColor(tbCont.szUiGroup, tbCont.szObjGrid, "yellow")
            elseif nPerDur > 60 then
              ObjGrid_ChangeSubScriptColor(tbCont.szUiGroup, tbCont.szObjGrid, "green")
            end

            local szDur = tostring(nPerDur) .. "%"
            ObjGrid_ChangeSubScript(tbCont.szUiGroup, tbCont.szObjGrid, szDur, 0, 0)
          end
        end
      end
    end
  end
end

function uiOtherEquip:OnSyncItem()
  self:UpdateCellEquipTips()
end

function uiOtherEquip:SetEquipPosHighLight(tbObj)
  local nRet = 1
  if not tbObj or tbObj.nType ~= Ui.OBJ_OWNITEM then
    self:ReleaseEquipPosHighLight()
    return
  end
  local pItem = me.GetItem(tbObj.nRoom, tbObj.nX, tbObj.nY)
  if not pItem then
    return
  end
  local nEquipPos = pItem.nEquipPos < Item.EQUIPPOS_NUM and pItem.nEquipPos or pItem.nEquipPos - Item.EQUIPPOS_NUM

  if (not pItem) or not pItem.nEquipPos or (nEquipPos >= self.nObjCount) then
    self:ReleaseEquipPosHighLight()
    return
  end

  if (pItem.nGenre == Item.EQUIP_PARTNER and self.nModel ~= 2) or (pItem.nGenre ~= Item.EQUIP_PARTNER and self.nModel == 2) then
    self:ReleaseEquipPosHighLight()
    return
  end

  local tbEquipWnd = BACKUP_EQUIPMENT[nEquipPos + 1]
  if not tbEquipWnd then
    self:ReleaseEquipPosHighLight()
    return
  end
  if self.nModel == 2 then
    tbEquipWnd = BACKUP_EQUIPMENT[tbObjDisplayOrder[nEquipPos + 1] + 1]
  end
  self.szHighLightEquipPos = tbEquipWnd[4]

  Img_SetFrame(self.UIGROUP, self.szHighLightEquipPos, 0)
end

function uiOtherEquip:ReleaseEquipPosHighLight()
  if self.szHighLightEquipPos == nil then
    return
  end

  Img_SetFrame(self.UIGROUP, self.szHighLightEquipPos, 1)
  self.szHighLightEquipPos = nil
end

----------------------------------------------------------------------------------------

function uiOtherEquip:RegisterMessage()
  local tbRegMsg = {}
  for _, tbEquip in pairs(self.tbEquipCont) do
    tbRegMsg = Lib:MergeTable(tbRegMsg, tbEquip:RegisterMessage())
  end
  return tbRegMsg
end

function uiOtherEquip:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_ITEM, self.OnSyncItem },
  }
  for _, tbEquip in pairs(self.tbEquipCont) do
    tbRegEvent = Lib:MergeTable(tbRegEvent, tbEquip:RegisterEvent())
  end

  return tbRegEvent
end
