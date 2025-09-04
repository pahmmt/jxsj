------------------------------------------------------
-- 文件名　：exchangestone.lua
-- 创建者　：huangxiaoming
-- 创建时间：2011-10-27 17:33:48
-- 描  述  ：强化选择角色身上装备
------------------------------------------------------

local tbEnhanceSelectEquip = Ui:GetClass("enhanceselectequip")
local tbObject = Ui.tbLogic.tbObject
local tbTempItem = Ui.tbLogic.tbTempItem
local tbMouse = Ui.tbLogic.tbMouse

tbEnhanceSelectEquip.BTN_CLOSE = "BtnClose"
tbEnhanceSelectEquip.OBJ_EQUIP = "ObjEquip"

local MAP_OBJPOS2EQUIP = {
  [0] = Item.EQUIPPOS_HEAD,
  [1] = Item.EQUIPPOS_WEAPON,
  [2] = Item.EQUIPPOS_BODY,
  [3] = Item.EQUIPPOS_NECKLACE,
  [4] = Item.EQUIPPOS_BELT,
  [5] = Item.EQUIPPOS_RING,
  [6] = Item.EQUIPPOS_CUFF,
  [7] = Item.EQUIPPOS_PENDANT,
  [8] = Item.EQUIPPOS_FOOT,
  [9] = Item.EQUIPPOS_AMULET,
}

local tbMappingEquipCont = { bShowCd = 1, bUse = 0, bLink = 0, bSwitch = 0 }

local OBJ_EQUIP_HEIGTH = 5
local OBJ_EQUIP_WIDTH = 2

-- 重写基类鼠标左键点击格子事件
function tbMappingEquipCont:OnObjGridSwitch(nX, nY)
  Ui(Ui.UI_ENHANCESELECTEQUIP):SelectEquip(nX, nY)
end

function tbEnhanceSelectEquip:Init() end

function tbEnhanceSelectEquip:OnCreate()
  self.tbMappingEquipCont = tbObject:RegisterContainer(self.UIGROUP, self.OBJ_EQUIP, OBJ_EQUIP_WIDTH, OBJ_EQUIP_HEIGTH, tbMappingEquipCont, "award")
end

function tbEnhanceSelectEquip:OnDestroy()
  tbObject:UnregContainer(self.tbMappingEquipCont)
end

function tbEnhanceSelectEquip:ClearObj()
  for y = 0, OBJ_EQUIP_HEIGTH - 1 do
    for x = 0, OBJ_EQUIP_WIDTH - 1 do
      local tbObj = self:GetObj(x, y)
      if tbObj and tbObj.pItem then
        tbTempItem:Destroy(tbObj.pItem)
      end
    end
  end

  self._tbBase.ClearObj(self)
end

-- 要更随目标的位置
function tbEnhanceSelectEquip:OnOpen(szTargetGroup, nX, nY)
  if tbMouse.tbObj then -- 鼠标有道具不让打开
    return 0
  end
  self:UpdateEquipCont()
  self.szTargetGroup = szTargetGroup -- 目标窗口
  self.nX = nX
  self.nY = nY
end

function tbEnhanceSelectEquip:PostOpen()
  if self.nX and self.nY then
    Wnd_SetPos(self.UIGROUP, "Main", self.nX, self.nY)
  end
end

function tbEnhanceSelectEquip:OnClose()
  self.tbMappingEquipCont:ClearObj()
end

function tbEnhanceSelectEquip:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

-- 更新装备列表
function tbEnhanceSelectEquip:UpdateEquipCont()
  self.tbMappingEquipCont:ClearObj()
  for nKey, nEquipPos in pairs(MAP_OBJPOS2EQUIP) do
    local pItem = me.GetItem(Item.ROOM_EQUIP, nEquipPos, 0)
    local pEnhanceItem = me.GetItem(Item.ROOM_ENHANCE_EQUIP, 0, 0)
    if pItem then
      if not pEnhanceItem or pItem.nIndex ~= pEnhanceItem.nIndex then
        local tbHoleStone = {}
        for i = 0, 2 do
          tbHoleStone[i * 2 + 1], tbHoleStone[(i + 1) * 2] = pItem.GetHoleStone(i + 1)
        end
        local pTempItem = tbTempItem:Create(pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel, pItem.nSeries, pItem.nEnhTimes, pItem.nLucky, nil, pItem.nVersion, pItem.dwRandSeed, pItem.nIndex, pItem.nStrengthen, pItem.nCount, pItem.nCurDur, pItem.nMaxDur, pItem.GetRandomInfo(), tbHoleStone)
        local tbObj = {}
        tbObj.nType = Ui.OBJ_TEMPITEM
        tbObj.pItem = pTempItem
        tbObj.nCount = 1
        self.tbMappingEquipCont:SetObj(tbObj, math.mod(nKey, 2), math.floor(nKey / 2))
      end
    end
  end
end

function tbEnhanceSelectEquip:SelectEquip(nX, nY)
  if UiManager:WindowVisible(self.szTargetGroup) ~= 1 then
    return
  end
  local nIndex = nX + nY * 2
  local pDrop = me.GetItem(Item.ROOM_EQUIP, MAP_OBJPOS2EQUIP[nIndex], 0)
  if pDrop then
    local tbObj = {}
    tbObj.nType = Ui.OBJ_OWNITEM
    tbObj.pItem = pDrop
    tbObj.nRoom = Item.ROOM_EQUIP
    tbObj.nX = MAP_OBJPOS2EQUIP[nIndex]
    tbObj.nY = 0

    local nRet = Ui(self.szTargetGroup):SelectBodyEquip(tbObj)
    if 1 == nRet then
      UiManager:CloseWindow(self.UIGROUP)
    end
  end
end

function tbEnhanceSelectEquip:RegisterEvent()
  local tbRegEvent = self.tbMappingEquipCont:RegisterEvent()
  return tbRegEvent
end

function tbEnhanceSelectEquip:RegisterMessage()
  local tbRegMsg = self.tbMappingEquipCont:RegisterMessage()
  return tbRegMsg
end
