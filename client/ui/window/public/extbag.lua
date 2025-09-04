local tbExtBag = Ui:GetClass("extbag")
local tbObject = Ui.tbLogic.tbObject
local IMAGES = Ui.tbLogic.tbExtBagLayout.IMAGES

local OBJ_EXTBAG_4CELL = "ObjExtBag4Cell"
local OBJ_EXTBAG_6CELL = "ObjExtBag6Cell"
local OBJ_EXTBAG_8CELL = "ObjExtBag8Cell"
local OBJ_EXTBAG_10CELL = "ObjExtBag10Cell"
local OBJ_EXTBAG_12CELL = "ObjExtBag12Cell"
local OBJ_EXTBAG_15CELL = "ObjExtBag15Cell"
local OBJ_EXTBAG_18CELL = "ObjExtBag18Cell"
local OBJ_EXTBAG_20CELL = "ObjExtBag20Cell"
local OBJ_EXTBAG_24CELL = "ObjExtBag24Cell"

local WNDINFO = {
  [Item.EXTBAG_4CELL] = {
    szWnd = OBJ_EXTBAG_4CELL,
    szImg = IMAGES[Item.EXTBAG_4CELL],
    nWidth = Item.EXTBAG_WIDTH_4CELL,
    nHeight = Item.EXTBAG_HEIGHT_4CELL,
  },
  [Item.EXTBAG_6CELL] = {
    szWnd = OBJ_EXTBAG_6CELL,
    szImg = IMAGES[Item.EXTBAG_6CELL],
    nWidth = Item.EXTBAG_WIDTH_6CELL,
    nHeight = Item.EXTBAG_HEIGHT_6CELL,
  },
  [Item.EXTBAG_8CELL] = {
    szWnd = OBJ_EXTBAG_8CELL,
    szImg = IMAGES[Item.EXTBAG_8CELL],
    nWidth = Item.EXTBAG_WIDTH_8CELL,
    nHeight = Item.EXTBAG_HEIGHT_8CELL,
  },
  [Item.EXTBAG_10CELL] = {
    szWnd = OBJ_EXTBAG_10CELL,
    szImg = IMAGES[Item.EXTBAG_10CELL],
    nWidth = Item.EXTBAG_WIDTH_10CELL,
    nHeight = Item.EXTBAG_HEIGHT_10CELL,
  },
  [Item.EXTBAG_12CELL] = {
    szWnd = OBJ_EXTBAG_12CELL,
    szImg = IMAGES[Item.EXTBAG_12CELL],
    nWidth = Item.EXTBAG_WIDTH_12CELL,
    nHeight = Item.EXTBAG_HEIGHT_12CELL,
  },
  [Item.EXTBAG_15CELL] = {
    szWnd = OBJ_EXTBAG_15CELL,
    szImg = IMAGES[Item.EXTBAG_15CELL],
    nWidth = Item.EXTBAG_WIDTH_15CELL,
    nHeight = Item.EXTBAG_HEIGHT_15CELL,
  },
  [Item.EXTBAG_18CELL] = {
    szWnd = OBJ_EXTBAG_18CELL,
    szImg = IMAGES[Item.EXTBAG_18CELL],
    nWidth = Item.EXTBAG_WIDTH_18CELL,
    nHeight = Item.EXTBAG_HEIGHT_18CELL,
  },
  [Item.EXTBAG_20CELL] = {
    szWnd = OBJ_EXTBAG_20CELL,
    szImg = IMAGES[Item.EXTBAG_20CELL],
    nWidth = Item.EXTBAG_WIDTH_20CELL,
    nHeight = Item.EXTBAG_HEIGHT_20CELL,
  },
  [Item.EXTBAG_24CELL] = {
    szWnd = OBJ_EXTBAG_24CELL,
    szImg = IMAGES[Item.EXTBAG_24CELL],
    nWidth = Item.EXTBAG_WIDTH_24CELL,
    nHeight = Item.EXTBAG_HEIGHT_24CELL,
  },
}

local STATE_USE = -- 该表注册所有需要鼠标右键快速放物品的状态
  {
    UiManager.UIS_ACTION_GIFT, -- 给予界面状态
    UiManager.UIS_EQUIP_BREAKUP, -- 装备拆解状态
    UiManager.UIS_EQUIP_ENHANCE, -- 装备强化
    UiManager.UIS_EQUIP_PEEL, -- 玄晶剥离
    UiManager.UIS_EQUIP_COMPOSE, -- 玄晶合成
    UiManager.UIS_EQUIP_UPGRADE, -- 印鉴升级
    UiManager.UIS_EQUIP_REFINE, -- 装备炼化
    UiManager.UIS_EQUIP_STRENGTHEN, -- 装备改造
    UiManager.UIS_OPEN_REPOSITORY, -- 打开储物箱
    UiManager.UIS_ZHENYUAN_XIULIAN, -- 真元修炼
    UiManager.UIS_ZHENYUAN_REFINE, -- 真元炼化
    UiManager.UIS_EQUIP_TRANSFER, -- 强化转移
    UiManager.UIS_EQUIP_RECAST, -- 装备重铸
    UiManager.UIS_HOLE_MAKEHOLE, -- 装备打孔
    UiManager.UIS_HOLE_MAKEHOLEEX, -- 高级装备打孔
    UiManager.UIS_HOLE_ENCHASE, -- 宝石镶嵌
    UiManager.UIS_STONE_EXCHAGNE, -- 宝石兑换
    UiManager.UIS_STONE_BREAK_UP, -- 宝石拆解
    UiManager.UIS_WEAPON_PEEL, -- 青铜武器剥离
    UiManager.UIS_TRADE_PLAYER, -- 交易状态
    UiManager.UIS_OPEN_KINREPOSITORY, -- 打开家族仓库
  }

local tbExtBagCont = { bSendToGift = 1 }

function tbExtBag:Init()
  self.nType = 0
  self.nPos = -1
  self.tbExtBagCont = nil
end

function tbExtBagCont:CanSendStateUse()
  local bCanSendUse = 0
  for i, nState in ipairs(STATE_USE) do
    if UiManager:GetUiState(nState) == 1 then
      bCanSendUse = 1
      break
    end
  end
  return bCanSendUse
end

function tbExtBag:OnOpen(nPos)
  local pExtBag = me.GetExtBag(nPos)
  local nRoom = Item.EXTBAGPOS2ROOM[nPos]
  if (not pExtBag) or not nRoom then
    return 0
  end

  local nType = pExtBag.nDetail
  local tbInfo = WNDINFO[nType]
  if not tbInfo then
    return 0
  end

  self.nPos = nPos
  self.nType = nType
  tbExtBagCont.nRoom = nRoom
  self.tbExtBagCont = tbObject:RegisterContainer(
    self.UIGROUP,
    tbInfo.szWnd,
    tbInfo.nWidth,
    tbInfo.nHeight,
    tbExtBagCont, -- 在这里设上容器的nRoom
    "itemroom"
  )

  local tbRegEvent = self.tbExtBagCont:RegisterEvent()
  for _, tbEvent in pairs(tbRegEvent) do
    UiNotify:RegistNotify(tbEvent[1], tbEvent[2], tbEvent[3])
  end

  Img_SetImage(self.UIGROUP, UiManager.WND_MAIN, 1, tbInfo.szImg)
  Wnd_Show(self.UIGROUP, tbInfo.szWnd)
  self:UpdateItem()
  return 1
end

function tbExtBag:OnClose()
  if self.tbExtBagCont then
    self.tbExtBagCont:ClearRoom()
    tbObject:UnregContainer(self.tbExtBagCont)
  end
end

function tbExtBag:RegisterMessage()
  local tbRegMessage = {}
  if self.tbExtBagCont then
    tbRegMessage = Lib:MergeTable(tbRegMessage, self.tbExtBagCont:RegisterMessage())
  end
  return tbRegMessage
end

function tbExtBag:UpdateItem()
  local tbInfo = WNDINFO[self.nType]
  local nRoom = Item.EXTBAGPOS2ROOM[self.nPos]
  if (not tbInfo) or not nRoom then
    return
  end
  self.tbExtBagCont:UpdateRoom()
end
