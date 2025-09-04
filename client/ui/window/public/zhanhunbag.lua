-----------------------------------------------------
--文件名		：	zhanhunbag.lua
--创建者		：	zhaoyu
--创建时间		：	2010/7/9 10:03:34
--功能描述		：  战魂包
------------------------------------------------------
local uiZhanHunBag = Ui:GetClass("zhanhunbag")
local tbObject = Ui.tbLogic.tbObject
local tbPreViewMgr = Ui.tbLogic.tbPreViewMgr

uiZhanHunBag.IMG_CELLLIGHT = "ImgCellLight"
uiZhanHunBag.OBJ_CELL1 = "Obj1"
uiZhanHunBag.OBJ_CELL2 = "Obj2"
uiZhanHunBag.bShow = 0

-- 装备栏
local EQUIP_OBJ_CONFIGER = {
  { Item.EQUIP_MELEE_WEAPON, 2, 1 },
  { Item.EQUIP_RANGE_WEAPON, 2, 1 },
  { Item.EQUIP_ARMOR, 1, 2 },
  { Item.EQUIP_RING, 2, 3 },
  { Item.EQUIP_NECKLACE, 2, 2 },
  { Item.EQUIP_AMULET, 2, 5 },
  { Item.EQUIP_BOOTS, 1, 5 },
  { Item.EQUIP_BELT, 1, 3 },
  { Item.EQUIP_HELM, 1, 1 },
  { Item.EQUIP_CUFF, 1, 4 },
  { Item.EQUIP_PENDANT, 2, 4 },
}

local tbZhanHunCont1 = { bUse = 0, nRoom = Item.ROOM_EQUIPEX2, bSendToGift = 1 }
local tbZhanHunCont2 = { nOffsetX = 5, bUse = 0, nRoom = Item.ROOM_EQUIPEX2, bSendToGift = 1 }

-- 创建期，创建OBJ容器
function uiZhanHunBag:OnCreate()
  self.tbObjCont1 = tbObject:RegisterContainer(
    self.UIGROUP,
    self.OBJ_CELL1,
    5,
    1,
    tbZhanHunCont1, -- 不可使用
    "equiproom"
  )
  self.tbObjCont2 = tbObject:RegisterContainer(
    self.UIGROUP,
    self.OBJ_CELL2,
    5,
    1,
    tbZhanHunCont2, -- 不可使用
    "equiproom"
  )
end

function uiZhanHunBag:OnKillFocus(szWnd)
  UiManager:CloseWindow(self.UIGROUP)
end

-- 销毁OBJ容器
function uiZhanHunBag:OnDestroy()
  tbObject:UnregContainer(self.tbObjCont1)
  tbObject:UnregContainer(self.tbObjCont2)
end

function uiZhanHunBag:OnClose()
  --self.tbObjCont:ClearRoom();
end

-- 鼠标进入技能View时触发
function uiZhanHunBag:OnObjGridEnter(szWnd, nX, nY)
  if Wnd_Visible(self.UIGROUP, "Main") == 0 then
    return
  end

  if szWnd == self.OBJ_SKILL_PREVIEW then
    local nOffset = 0
    if nY > 0 then
      nOffset = 5
    else
      nOffset = 1
    end
    local uId = nX + nOffset + nY
    if self.tbSkillIds[uId] then
      Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, FightSkill:GetDesc(self.tbSkillIds[uId].nId, self.tbSkillIds[uId].nLevel))
    end
  end
end

-- 打开界面
function uiZhanHunBag:OnOpen()
  self.bShow = 1
  self:UpdateEquip()
  self.bShow = 0
end

-- 更新同伴装备显示
function uiZhanHunBag:UpdateEquip(bShow)
  if Wnd_Visible(self.UIGROUP, "Main") == 0 and self.bShow == 0 then
    return
  end
  self.tbObjCont1:UpdateRoom()
  self.tbObjCont2:UpdateRoom()
end

-- 同伴装备没有耐久。。。
function uiZhanHunBag:UpdateEquipDur() end

-- 按键点击
function uiZhanHunBag:OnButtonClick(szWnd, nParam) end

-- 注册事件更新回调
function uiZhanHunBag:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_ITEM, self.UpdateEquip },
  }
  tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbObjCont1:RegisterEvent())
  tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbObjCont2:RegisterEvent())
  return tbRegEvent
end

-- 注册技能界面OBJ的消息回调
function uiZhanHunBag:RegisterMessage()
  local tbRegMsg = self.tbObjCont1:RegisterMessage()
  tbRegMsg = Lib:MergeTable(tbRegMsg, self.tbObjCont2:RegisterMessage())
  return tbRegMsg
end

function uiZhanHunBag:SetEquipPosHighLight(tbObj)
  if not tbObj then
    Wnd_Hide(self.UIGROUP, self.IMG_CELLLIGHT)
    return
  end
  if not (tbObj.nRoom and tbObj.nX and tbObj.nY) then
    return
  end
  local pItem = me.GetItem(tbObj.nRoom, tbObj.nX, tbObj.nY)
  if (not pItem) or not pItem.nEquipPos or (pItem.nEquipPos >= 10) then
    Wnd_Hide(self.UIGROUP, self.IMG_CELLLIGHT)
    return
  end
  local nPosition = pItem.nEquipPos
  local nY = math.floor(nPosition / 5)
  local nX = nPosition - nY * 5
  Wnd_Show(self.UIGROUP, self.IMG_CELLLIGHT)
  Wnd_SetPos(self.UIGROUP, self.IMG_CELLLIGHT, nX * 37 + 3, nY * 37)
end

function uiZhanHunBag:ReleaseEquipPosHighLight()
  if self.m_szHighLightEquipPos == nil then
    return
  end
  Img_SetFrame(self.UIGROUP, self.m_szHighLightEquipPos, 1)
  self.m_szHighLightEquipPos = nil
end
