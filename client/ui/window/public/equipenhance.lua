-----------------------------------------------------
--文件名		：	uiEquipEnhance.lua
--创建者		：	tongxuehu@kingsoft.com
--创建时间		：	2008-03-05
--功能描述		：	装备强化/玄晶剥离界面
------------------------------------------------------

local uiEquipEnhance = Ui:GetClass("equipenhance")
local tbObject = Ui.tbLogic.tbObject
local tbMouse = Ui.tbLogic.tbMouse
local tbTempItem = Ui.tbLogic.tbTempItem

local TXT_TITLE = "TxtTitle"
local TXT_MESSAGE = "TxtMessage"
local BTN_CONFIRM = "BtnOk"
local BTN_CLOSE = "BtnClose"
local BTN_CANCEL = "BtnCancel"
local IMG_EFFECT = "ImgEffect"
local OBJ_EQUIP = "ObjEquip"
local OBJ_ENHITEM = "ObjEnhItem"
local OBJ_PREVIEW = "ObjPreview"
local OBJ_PRE_REFINE = "ObjPreRefine"
local LIST_MAGIC_SELECT = "LstMagicSelect"
local BTN_SELECTEQUIP = "BtnSelectEquip"

local PREVIEW_WIDTH = 4
local PREVIEW_HEIGHT = 4

local ENHITEM_CLASS = "xuanjing" -- 强化道具类型：玄晶
local ENHANCE_DISCOUNT = "enhancediscount" --强化道具类型：强化优惠符
local ENHITEM_INDEX = { nGenre = Item.SCRIPTITEM, nDetail = 1, nParticular = 114 } -- 玄晶

uiEquipEnhance.pTempItem = nil
local tbUnUseItem = {}
local bRecastItemBindType = 0

local MODE_TEXT = {
  [Item.ENHANCE_MODE_ENHANCE] = "装备强化",
  [Item.ENHANCE_MODE_PEEL] = "玄晶剥离",
  [Item.ENHANCE_MODE_COMPOSE] = "玄晶合成",
  [Item.ENHANCE_MODE_UPGRADE] = "印鉴升级",
  [Item.ENHANCE_MODE_REFINE] = "装备炼化",
  [Item.ENHANCE_MODE_STRENGTHEN] = "装备改造",
  [Item.ENHANCE_MODE_ENHANCE_TRANSFER] = "强化转移",
  [Item.ENHANCE_MODE_EQUIP_RECAST] = "装备重铸",
  [Item.ENHANCE_MODE_STONE_BREAKUP] = "原石拆解",
  [Item.ENHANCE_MODE_WEAPON_PEEL] = "青铜武器剥离",
  [Item.ENHANCE_MODE_CAST] = "装备精铸",
}

local tbReCastTips = {
  [Item.emEQUIP_RECAST_CURRENCY_MONEY] = { "普通银两", "两" },
  [Item.emEQUIP_RECAST_CURRENCY_LONGHUN] = { "龙纹银币", "个" },
}

function uiEquipEnhance:Init()
  self.nMode = Item.ENHANCE_MODE_NONE
  self.tbTempItem = {}
  self.bShowBindMsg = 0
  self.bShowTimeMsg = 0
  self.nMoneyEnoughFlag = 0
  self.bShowWarnning = 1
  -- by zhangjinpin@kingsoft
  self.bShowLowForbidden = 0
  self.bShowHighForbidden = 0
end

local tbEquipCont = { bUse = 0, nRoom = Item.ROOM_ENHANCE_EQUIP, bSendToGift = 1 }
local tbEnhItemCont = { bUse = 0, nRoom = Item.ROOM_ENHANCE_ITEM, bSendToGift = 1 }
local tbPreviewCont = { bUse = 0, bLink = 0, bSwitch = 0, bShowCd = 0, bSendToGift = 1 }
local tbPreRefineCont = { bUse = 0, bLink = 0, bSwitch = 0, bShowCd = 0, bSendToGift = 1 }

function tbEquipCont:CheckSwitchItem(pDrop, pPick, nX, nY)
  Ui(Ui.UI_EQUIPENHANCE):UpdateList(pDrop)
  if not pDrop then
    if self.nMode == Item.ENHANCE_MODE_STONE_BREAKUP then
      Wnd_SetTip(Ui(Ui.UI_EQUIPENHANCE).UIGROUP, OBJ_EQUIP, "在此处放入3级或3级以上原石")
    end
    return 1 -- 只是把东西拿出来，总是成功
  end

  if (self.nMode == Item.ENHANCE_MODE_COMPOSE) or (self.nMode == Item.ENHANCE_MODE_CAST) then
    me.Msg((MODE_TEXT[self.nMode] or "") .. "，不允许在这格子上放任何东西！")
    return 0
  end

  if 1 ~= pDrop.IsEquip() and self.nMode ~= Item.ENHANCE_MODE_STONE_BREAKUP then
    me.Msg("只能放置需要" .. MODE_TEXT[self.nMode] .. "的装备！")
    return 0
  end

  if self.nMode == Item.ENHANCE_MODE_ENHANCE then -- 处于强化操作状态
    if 1 == pDrop.IsWhite() then
      me.Msg("该物品不能强化！")
      return 0
    end
    if pDrop.GetLockIntervale() > 0 and Ui(Ui.UI_EQUIPENHANCE).nMoneyType == Item.BIND_MONEY then
      me.Msg("该装备只能用不绑银和不绑玄强化！")
      return 0
    end
    if pDrop.nEnhTimes >= Item:CalcMaxEnhanceTimes(pDrop) then
      me.Msg("该装备已经强化到极限了！")
      return 0
    end
    local nOpen = KGblTask.SCGetDbTaskInt(DBTASK_ENHANCESIXTEEN_OPEN)
    if nOpen == 1 and pDrop.nEnhTimes >= Item.nEnhTimesLimitOpen - 1 then
      me.Msg("强16功能暂不开放。")
      return 0
    end
    if (pDrop.nDetail < Item.MIN_COMMON_EQUIP) or (pDrop.nDetail > Item.MAX_COMMON_EQUIP) then
      me.Msg("参与五行激活的装备才能强化！")
      return 0
    end
  elseif self.nMode == Item.ENHANCE_MODE_PEEL then -- 处于剥离操作状态
    if 1 == pDrop.IsWhite() then
      me.Msg("该物品不能剥离！")
      return 0
    end
    if pDrop.nEnhTimes <= 0 then
      me.Msg("未强化过装备不能剥离！")
      return 0
    end
    if (pDrop.nDetail < Item.MIN_COMMON_EQUIP) or (pDrop.nDetail > Item.MAX_COMMON_EQUIP) then
      me.Msg("参与五行激活的装备才能进行剥离！")
      return 0
    end
  elseif self.nMode == Item.ENHANCE_MODE_UPGRADE then
    if pDrop.nDetail ~= Item.EQUIP_SIGNET then
      me.Msg("只能放入印鉴进行升级")
      return 0
    end
  elseif self.nMode == Item.ENHANCE_MODE_STRENGTHEN then
    if 1 == pDrop.IsWhite() then
      me.Msg("该物品不能改造！")
      return 0
    end
    if pDrop.GetLockIntervale() > 0 and Ui(Ui.UI_EQUIPENHANCE).nMoneyType == Item.BIND_MONEY then
      me.Msg("该装备只能用不绑银和不绑玄改造！")
      return 0
    end
    if pDrop.nEnhTimes <= 0 then
      me.Msg("未强化过装备不能改造！")
      return 0
    end
    if (pDrop.nDetail < Item.MIN_COMMON_EQUIP) or (pDrop.nDetail > Item.MAX_COMMON_EQUIP) then
      me.Msg("参与五行激活的装备才能进行改造！")
      return 0
    end
  elseif self.nMode == Item.ENHANCE_MODE_ENHANCE_TRANSFER then
    if 1 == pDrop.IsWhite() then
      me.Msg("参与五行激活的装备才能进行转移！")
      Ui(Ui.UI_EQUIPENHANCE):UpdateItem()
      return 0
    end
    if (pDrop.nDetail < Item.MIN_COMMON_EQUIP) or (pDrop.nDetail > Item.MAX_COMMON_EQUIP) then
      me.Msg("参与五行激活的装备才能进行转移！")
      Ui(Ui.UI_EQUIPENHANCE):UpdateItem()
      return 0
    end
    if pDrop.nEnhTimes == Item:CalcMaxEnhanceTimes(pDrop) then
      me.Msg("该装备已强化到极限，不可被强化转移！")
      Ui(Ui.UI_EQUIPENHANCE):UpdateItem()
      return 0
    end
    if Item.tbTransferEquip.nType and Item.tbTransferEquip.nType ~= Item:GetEquipType(pDrop) then
      me.Msg("只能进行同类型装备间的强化转移！")
      Ui(Ui.UI_EQUIPENHANCE):UpdateItem()
      return 0
    end
  elseif self.nMode == Item.ENHANCE_MODE_STONE_BREAKUP then
    if pDrop.GetStoneType() ~= Item.STONE_GEM then
      me.Msg("原石才可拆解！")
      return 0
    end
    if pDrop.nLevel < Item.tbStone.STONE_BREAKUP_LEVEL_LIMIT then
      me.Msg(string.format("%d级及%d级以上的原石才能拆解！", Item.tbStone.STONE_BREAKUP_LEVEL_LIMIT, Item.tbStone.STONE_BREAKUP_LEVEL_LIMIT))
      return 0
    end
    Wnd_SetTip(Ui(Ui.UI_EQUIPENHANCE).UIGROUP, OBJ_EQUIP, "")
  elseif self.nMode == Item.ENHANCE_MODE_WEAPON_PEEL then
    local bIsQinTongWep = Item:CheckIsQinTongWep(pDrop)
    if 1 ~= bIsQinTongWep then
      me.Msg("只有青铜武器才可以剥离。")
      return 0
    end
  end
  return 1
end

--获取itemroom里已经放入的数量
function tbEnhItemCont:GetItemCount()
  local nCount = 0
  for j = 0, Item.ROOM_ENHANCE_ITEM_HEIGHT - 1 do
    for i = 0, Item.ROOM_ENHANCE_ITEM_WIDTH - 1 do
      local pEnhItem = me.GetEnhanceItem(i, j)
      if pEnhItem then
        nCount = nCount + 1
      end
    end
  end
  return nCount
end

function tbEnhItemCont:CheckSwitchItem(pDrop, pPick, nX, nY)
  if not pDrop then
    --拿出来的是强化优惠符要做计数操作
    if pPick and pPick.szClass == ENHANCE_DISCOUNT then
      Item.nDisCountEnhance = Item.nDisCountEnhance - 1
      if Item.nDisCountEnhance < 0 then
        Item.nDisCountEnhance = 0
      end
    end
    return 1 -- 只是把东西拿出来，总是成功
  end
  local pEquip = me.GetEnhanceEquip()
  local tbEnhUi = Ui(Ui.UI_EQUIPENHANCE)
  if tbEnhUi.nMode == Item.ENHANCE_MODE_REFINE then
    return 1
  end
  if tbEnhUi.nMode == Item.ENHANCE_MODE_CAST then
    if (pDrop.IsExEquip() ~= 1 or pDrop.nEquipCategory == 0) and pDrop.IsCastStuff() == 0 then
      me.Msg("只能放入精铸石和卓越或以上品质的龙魂系列装备！")
      return 0
    end
    return 1
  end
  if tbEnhUi.nMode == Item.ENHANCE_MODE_EQUIP_RECAST then
    if tbEnhUi.pTempItem then --已经重铸，不能再放入任何东西
      return 0
    end
    if self:GetItemCount() + 1 > 2 then
      me.Msg("请不要放入过多的材料!")
      return 0
    end
    if pDrop.IsEquip() == 1 then
      if pDrop.nDetail < Item.MIN_COMMON_EQUIP or pDrop.nDetail > Item.MAX_COMMON_EQUIP then
        me.Msg("参与五行激活的装备才能进行重铸！")
        return 0
      end
      if pDrop.nGenre == 1 then
        me.Msg("该装备不能参与重铸！")
        return 0
      end
    end
    if pDrop.szClass == Item.RECAST_ITEM_CLASS or pDrop.IsEquip() == 1 then
      return 1
    else
      me.Msg("只能放置重铸的装备和重铸符！")
      return 0
    end
  end
  if tbEnhUi.nMode == Item.ENHANCE_MODE_ENHANCE_TRANSFER then
    if pDrop.IsEquip() == 1 then
      if pDrop.nDetail < Item.MIN_COMMON_EQUIP or pDrop.nDetail > Item.MAX_COMMON_EQUIP then
        me.Msg("参与五行激活的装备才能进行转移！")
        return 0
      elseif pEquip and Item:GetEquipType(pEquip) ~= Item:GetEquipType(pDrop) then
        me.Msg("只能进行同类型装备间的强化转移！")
        return 0
      elseif pEquip and pEquip.nEnhTimes >= pDrop.nEnhTimes then
        me.Msg("被转移的装备强化等级需低于要转移的装备！")
        return 0
      elseif pEquip and pDrop.nEnhTimes > Item:CalcMaxEnhanceTimes(pEquip) then
        me.Msg("转移装备的强化等级不能高于被转移装备的最大强化等级！")
        return 0
      elseif pDrop.nLevel > 9 and pDrop.nEnhTimes < 8 then
        me.Msg("不可以转移强化小于8级且装备等级为10级的装备")
        return 0
      elseif pDrop.nEnhTimes < 8 then
        Item.nTransferLowEquit = 1
        return 1
      else
        Item.nTransferLowEquit = 0
        return 1
      end
    elseif pDrop.szClass ~= Item.ENHANCE_TRANSFER and pDrop.szClass ~= ENHITEM_CLASS then
      me.Msg("只能放置需要转移的装备或玄晶或强化传承符！")
      return 0
    elseif pDrop.szClass == Item.ENHANCE_TRANSFER or pDrop.szClass == ENHITEM_CLASS then
      return 1
    end
  end
  if tbEnhUi.nMode == Item.ENHANCE_MODE_STRENGTHEN then
    if (pDrop.szClass == Item.STRENGTHEN_STUFF_CLASS) or Item.STRENGTHEN_RECIPE_CALSS[pDrop.szClass] then
      return 1
    else
      me.Msg("只能放置需要的玄晶或改造符")
      return 0
    end
  end
  if pDrop.szClass == Item.UPGRADE_ITEM_CLASS and tbEnhUi.nMode == Item.ENHANCE_MODE_UPGRADE then
    return 1
  elseif tbEnhUi.nMode == Item.ENHANCE_MODE_UPGRADE then
    me.Msg("只能放置魂石")
    return 0
  end
  if tbEnhUi.nMode == Item.ENHANCE_MODE_ENHANCE then
    if pDrop.szClass ~= ENHANCE_DISCOUNT and pDrop.szClass ~= ENHITEM_CLASS then
      me.Msg("只能放置需要的玄晶或强化优惠符！")
      return 0
    end
    --放下的是优惠符
    Item.nDisCountEnhance = Item.nDisCountEnhance or 0
    if pDrop.szClass == ENHANCE_DISCOUNT then
      if Item.nDisCountEnhance >= 1 then
        me.Msg("每次只能放入一个强化优惠符。")
        return 0
      end
      Item.nDisCountEnhance = Item.nDisCountEnhance + 1
    end
    --拿起的是优惠符
    if pPick and pPick.szClass == ENHANCE_DISCOUNT then
      if Item.nDisCountEnhance < 1 then
        Item.nDisCountEnhance = 1
      end
      Item.nDisCountEnhance = Item.nDisCountEnhance - 1
    end
    return 1
  end
  if pDrop.szClass ~= ENHITEM_CLASS then
    me.Msg("只能放置需要的玄晶！")
    return 0
  end
  if tbEnhUi.nMode == Item.ENHANCE_MODE_COMPOSE then
    if pDrop.nLevel >= 12 then
      me.Msg("只有12级以下玄晶才能合成")
      return 0
    end
  end

  return 1
end

function tbPreviewCont:FormatItem(tbItem)
  local tbObj = {}
  local pItem = tbItem.pItem
  if not pItem then
    return
  end
  tbObj.szBgImage = pItem.szIconImage
  tbObj.bShowSubScript = 1 -- 总显示下标数字
  return tbObj
end

function tbPreviewCont:UpdateItem(tbItem, nX, nY)
  local pItem = tbItem.pItem
  if Ui(Ui.UI_EQUIPENHANCE).nMode ~= Item.ENHANCE_MODE_STONE_BREAKUP then
    local nCount = 0
    if self.tbEnhItem and self.tbEnhItem[pItem.nLevel] then
      nCount = self.tbEnhItem[pItem.nLevel]
    end
    --和氏玉特殊处理
    if pItem.nGenre == 22 and pItem.nDetail == 1 and pItem.nParticular == 81 and pItem.nLevel == 1 then
      nCount = 5
    end
    ObjGrid_ChangeSubScript(self.szUiGroup, self.szObjGrid, tostring(nCount or ""), nX, nY)
  end

  local nColor = (me.CanUseItem(pItem) ~= 1) and 0x60ff0000 or 0
  ObjGrid_ChangeBgColor(self.szUiGroup, self.szObjGrid, nColor, nX, nY)
  ObjGrid_SetTransparency(self.szUiGroup, self.szObjGrid, pItem.szTransparencyIcon, nX, nY)
end

function uiEquipEnhance:OnCreate()
  self.tbEquipCont = tbObject:RegisterContainer(self.UIGROUP, OBJ_EQUIP, Item.ROOM_ENHANCE_EQUIP_WIDTH, Item.ROOM_ENHANCE_EQUIP_HEIGHT, tbEquipCont, "itemroom")
  self.tbEnhItemCont = tbObject:RegisterContainer(self.UIGROUP, OBJ_ENHITEM, Item.ROOM_ENHANCE_ITEM_WIDTH, Item.ROOM_ENHANCE_ITEM_HEIGHT, tbEnhItemCont, "itemroom")
  self.tbPreviewCont = tbObject:RegisterContainer(self.UIGROUP, OBJ_PREVIEW, PREVIEW_WIDTH, PREVIEW_HEIGHT, tbPreviewCont)
  self.tbPreRefineCont = tbObject:RegisterContainer(self.UIGROUP, OBJ_PRE_REFINE, 1, 1, tbPreRefineCont)
end

function uiEquipEnhance:OnDestroy()
  tbObject:UnregContainer(self.tbEquipCont)
  tbObject:UnregContainer(self.tbEnhItemCont)
  tbObject:UnregContainer(self.tbPreviewCont)
end

function uiEquipEnhance:OnOpen(nMode, nMoneyType)
  self.pTempItem = nil
  self.pEquip = nil
  Wnd_SetTip(self.UIGROUP, OBJ_EQUIP, "")
  if nMode == Item.ENHANCE_MODE_ENHANCE then
    UiManager:SetUiState(UiManager.UIS_EQUIP_ENHANCE)
    Wnd_Show(self.UIGROUP, OBJ_EQUIP)
    Wnd_Show(self.UIGROUP, OBJ_ENHITEM)
    if UiVersion == Ui.Version002 then
      Wnd_Show(self.UIGROUP, BTN_SELECTEQUIP)
    end
  elseif nMode == Item.ENHANCE_MODE_PEEL then
    UiManager:SetUiState(UiManager.UIS_EQUIP_PEEL)
    Wnd_Show(self.UIGROUP, OBJ_EQUIP)
    Wnd_Show(self.UIGROUP, OBJ_PREVIEW)
    if UiVersion == Ui.Version002 then
      Wnd_Show(self.UIGROUP, BTN_SELECTEQUIP)
    end
  elseif nMode == Item.ENHANCE_MODE_COMPOSE then
    UiManager:SetUiState(UiManager.UIS_EQUIP_COMPOSE)
    Wnd_Show(self.UIGROUP, OBJ_EQUIP)
    Wnd_Show(self.UIGROUP, OBJ_ENHITEM)
  elseif nMode == Item.ENHANCE_MODE_UPGRADE then
    UiManager:SetUiState(UiManager.UIS_EQUIP_UPGRADE)
    Wnd_Show(self.UIGROUP, OBJ_EQUIP)
    Wnd_Show(self.UIGROUP, OBJ_ENHITEM)
  elseif nMode == Item.ENHANCE_MODE_REFINE then
    UiManager:SetUiState(UiManager.UIS_EQUIP_REFINE)
    Wnd_Show(self.UIGROUP, OBJ_PRE_REFINE)
    Wnd_Show(self.UIGROUP, OBJ_ENHITEM)
  elseif nMode == Item.ENHANCE_MODE_STRENGTHEN then
    UiManager:SetUiState(UiManager.UIS_EQUIP_STRENGTHEN)
    Wnd_Show(self.UIGROUP, OBJ_EQUIP)
    Wnd_Show(self.UIGROUP, OBJ_ENHITEM)
    if UiVersion == Ui.Version002 then
      Wnd_Show(self.UIGROUP, BTN_SELECTEQUIP)
    end
  elseif nMode == Item.ENHANCE_MODE_ENHANCE_TRANSFER then
    UiManager:SetUiState(UiManager.UIS_EQUIP_TRANSFER)
    Wnd_Show(self.UIGROUP, OBJ_EQUIP)
    Wnd_Show(self.UIGROUP, OBJ_ENHITEM)
    if UiVersion == Ui.Version002 then
      Wnd_Show(self.UIGROUP, BTN_SELECTEQUIP)
    end
  elseif nMode == Item.ENHANCE_MODE_EQUIP_RECAST then
    local pTemp1 = self:CreateTempItem(18, 1, 75, 1)
    local pTemp2 = self:CreateTempItem(18, 1, 95, 1)
    if not pTemp1 and not pTemp2 then
      me.Msg("您的客户端存在异常，请重启客户端!")
      return 0
    end
    table.insert(tbUnUseItem, pTemp1)
    table.insert(tbUnUseItem, pTemp2)
    UiManager:SetUiState(UiManager.UIS_EQUIP_RECAST)
    Wnd_Show(self.UIGROUP, OBJ_PRE_REFINE)
    Wnd_Show(self.UIGROUP, OBJ_ENHITEM)
  elseif nMode == Item.ENHANCE_MODE_STONE_BREAKUP then
    UiManager:SetUiState(UiManager.UIS_STONE_BREAK_UP)
    Wnd_Show(self.UIGROUP, OBJ_EQUIP)
    Wnd_Show(self.UIGROUP, OBJ_PREVIEW)
    Wnd_SetTip(self.UIGROUP, OBJ_EQUIP, "在此处放入3级或3级以上原石")
  elseif nMode == Item.ENHANCE_MODE_WEAPON_PEEL then
    UiManager:SetUiState(UiManager.UIS_WEAPON_PEEL)
    Wnd_Show(self.UIGROUP, OBJ_EQUIP)
    Wnd_Show(self.UIGROUP, OBJ_PREVIEW)
    if UiVersion == Ui.Version002 then
      Wnd_Show(self.UIGROUP, BTN_SELECTEQUIP)
    end
  elseif nMode == Item.ENHANCE_MODE_CAST then
    UiManager:SetUiState(UiManager.UIS_EQUIP_CAST)
    Wnd_Show(self.UIGROUP, OBJ_PRE_REFINE)
    --Wnd_Show(self.UIGROUP, OBJ_ENHITEM);

    Wnd_Show(self.UIGROUP, OBJ_EQUIP)
    Wnd_Show(self.UIGROUP, OBJ_ENHITEM)
  else
    return 0
  end
  UiManager:OpenWindow(Ui.UI_ITEMBOX)
  Txt_SetTxt(self.UIGROUP, TXT_TITLE, MODE_TEXT[nMode])
  self.nMode = nMode
  self.nMoneyType = nMoneyType
  self.tbEquipCont.nMode = nMode
  self:UpdateItem()
  self:UpdateList()
  --新手任务指引
  Tutorial:CheckSepcialEvent("equipenhance")
end

function uiEquipEnhance:OnClose()
  if self.nMode ~= Item.ENHANCE_MODE_STONE_BREAKUP then
    me.ApplyEnhance(Item.ENHANCE_MODE_NONE, 0) -- 通知服务端取消强化/剥离操作
  else
    me.ApplyStoneOperation(Item.tbStone.emSTONE_OPERATION_NONE)
  end

  self.tbEquipCont:ClearRoom()
  self.tbEnhItemCont:ClearRoom()
  self.tbPreviewCont:ClearObj()
  if self.nMode == Item.ENHANCE_MODE_ENHANCE then
    UiManager:ReleaseUiState(UiManager.UIS_EQUIP_ENHANCE)
  elseif self.nMode == Item.ENHANCE_MODE_PEEL then
    UiManager:ReleaseUiState(UiManager.UIS_EQUIP_PEEL)
  elseif self.nMode == Item.ENHANCE_MODE_COMPOSE then
    UiManager:ReleaseUiState(UiManager.UIS_EQUIP_COMPOSE)
  elseif self.nMode == Item.ENHANCE_MODE_UPGRADE then
    UiManager:ReleaseUiState(UiManager.UIS_EQUIP_UPGRADE)
  elseif self.nMode == Item.ENHANCE_MODE_REFINE then
    UiManager:ReleaseUiState(UiManager.UIS_EQUIP_REFINE)
  elseif self.nMode == Item.ENHANCE_MODE_EQUIP_RECAST then
    for _, pTemp in pairs(tbUnUseItem) do
      tbTempItem:Destroy(pTemp)
    end
    UiManager:ReleaseUiState(UiManager.UIS_EQUIP_RECAST)
  elseif self.nMode == Item.ENHANCE_MODE_STRENGTHEN then
    UiManager:ReleaseUiState(UiManager.UIS_EQUIP_STRENGTHEN)
  elseif self.nMode == Item.ENHANCE_MODE_ENHANCE_TRANSFER then
    UiManager:ReleaseUiState(UiManager.UIS_EQUIP_TRANSFER)
  elseif self.nMode == Item.ENHANCE_MODE_STONE_BREAKUP then
    UiManager:ReleaseUiState(UiManager.UIS_STONE_BREAK_UP)
  elseif self.nMode == Item.ENHANCE_MODE_WEAPON_PEEL then
    UiManager:ReleaseUiState(UiManager.UIS_WEAPON_PEEL)
  elseif self.nMode == Item.ENHANCE_MODE_CAST then
    UiManager:ReleaseUiState(UiManager.UIS_EQUIP_CAST)
  end
  Lst_Clear(self.UIGROUP, LIST_MAGIC_SELECT)
  self.nRefineSelected = nil
  self.pEquip = nil
  tbTempItem:Destroy(self.pTempItem)
  self:DeleteTempAllStuff()
  Item.tbTransferEquip.nNewEnhanceTimes = nil
  Item.tbTransferEquip.nNewStrengthen = nil
  Item.tbTransferEquip.nType = nil
  bRecastItemBindType = 0
  Item.nDisCountEnhance = 0
  if UiVersion == Ui.Version002 then
    if UiManager:WindowVisible(Ui.UI_ENHANCESELECTEQUIP) == 1 then
      UiManager:CloseWindow(Ui.UI_ENHANCESELECTEQUIP)
    end
  end
end

function uiEquipEnhance:UpdateList(pEquip)
  --	if pEquip and self.nMode == Item.ENHANCE_MODE_UPGRADE and pEquip.szClass == Item.UPGRADE_EQUIP_CLASS then
  --		local tbAttrib = pEquip.GetBaseAttrib();
  --		Lst_Clear(self.UIGROUP, LIST_MAGIC_SELECT);
  --		for i, tbMA in ipairs(tbAttrib) do
  --			local szDesc = FightSkill:GetMagicDesc(tbAttrib[i].szName, tbAttrib[i].tbValue, nil, 1);
  --			if szDesc ~= "" then
  --				Lst_SetCell(self.UIGROUP, LIST_MAGIC_SELECT, i, 1, szDesc);
  --			end
  --		end
  --	elseif self.tbProduce and self.tbTempItem and self.nMode == Item.ENHANCE_MODE_REFINE then
  --		for i, pItem in pairs(self.tbTempItem) do
  --			Lst_SetCell(self.UIGROUP, LIST_MAGIC_SELECT, i, 1, pItem.szName);
  --		end
  --	elseif self.nMode == Item.ENHANCE_MODE_EQUIP_RECAST and self.pTempItem and self.pEquip then
  --		Lst_SetCell(self.UIGROUP, LIST_MAGIC_SELECT, 1, 1, "原装备: " .. self.pEquip.szName);
  --		Lst_SetCell(self.UIGROUP, LIST_MAGIC_SELECT, 2, 1, "新装备: " .. self.pTempItem.szName);
  --	else
  --		Lst_Clear(self.UIGROUP, LIST_MAGIC_SELECT);
  --	end
end

function uiEquipEnhance:OnListSel(szWnd, nParam)
  --	if nParam <= 0 then
  --		return;
  --	end
  --	if szWnd == LIST_MAGIC_SELECT then
  --		if self.nMode == Item.ENHANCE_MODE_UPGRADE then
  --			self:UpdateItem();
  --		elseif self.nMode == Item.ENHANCE_MODE_REFINE then
  --			local nIndex = 1;
  --			if self.tbProduce and #self.tbProduce > 1 then
  --				nIndex = Lst_GetCurKey(self.UIGROUP, LIST_MAGIC_SELECT);
  --				if nIndex == 0 or not self.tbProduce or not self.tbProduce[nIndex] then
  --					return 0;
  --				end
  --				self.nRefineSelected = nIndex;
  --			end
  --			self:UpdateRefinePreview(nParam);
  --		elseif self.nMode == Item.ENHANCE_MODE_EQUIP_RECAST then
  --			self:UpdateRecastPreview(nParam);
  --		end
  --	end
end

function uiEquipEnhance:OnButtonClick(szWnd, nParam)
  if szWnd == BTN_CONFIRM then
    Item.nDisCountEnhance = 0
    if self.nMode == Item.ENHANCE_MODE_CAST then
      -- 不绑定装备精铸提示精铸绑定
      local tbMsg = {}
      tbMsg.szMsg = string.format("精铸后装备会强制绑定，是否要继续精铸？")
      tbMsg.nOptCount = 2
      function tbMsg:Callback(nOptIndex, nMode, nMoneyType)
        if nOptIndex == 2 then
          me.ApplyEnhance(nMode, nMoneyType)
        end
      end
      UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, self.nMode, self.nMoneyType)
      return
    end
    if self.nMode == Item.ENHANCE_MODE_STONE_BREAKUP then
      local pItem = me.GetItem(Item.ROOM_ENHANCE_EQUIP, 0, 0)
      if not pItem then
        me.Msg("请放入要拆解的原石！")
        return
      end

      if Item.tbStone:CanBreakUp(pItem, me) ~= 1 then
        return
      end

      local tbMsg = {}
      tbMsg.szMsg = string.format("你确定要花费<color=yellow>%s<color>银两来拆解<color=yellow>%s<color>吗？", Item:FormatMoney(Item.tbStone.BREAKUP_COST_MONEY), pItem.szName)
      tbMsg.nOptCount = 2
      function tbMsg:Callback(nOptIndex)
        if nOptIndex == 2 then
          me.ApplyStoneOperation(Item.tbStone.emSTONE_OPERATION_BREAKUP)
        end
      end
      UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
      return
    end
    if self.nMoneyEnoughFlag == 0 then
      local szMoney = ""
      if self.nMode == Item.ENHANCE_MODE_ENHANCE_TRANSFER then
        szMoney = "银两"
      elseif self.nMoneyType == Item.BIND_MONEY and self.nMode ~= Item.ENHANCE_MODE_PEEL and self.nMode ~= Item.ENHANCE_MODE_WEAPON_PEEL then
        szMoney = "绑定银两"
      else
        szMoney = "银两"
      end

      me.Msg("您的" .. szMoney .. "不足以支付" .. MODE_TEXT[self.nMode] .. "的费用，无法进行" .. MODE_TEXT[self.nMode] .. "。")
      return
    -- 增加不可强化的判定提示：by zhangjinpin@kingsoft
    elseif (self.bShowHighForbidden == 1 or self.bShowLowForbidden == 1) and self.nMode == Item.ENHANCE_MODE_ENHANCE then
      local tbMsg = {}
      tbMsg.szMsg = ""
      if self.bShowHighForbidden == 1 and self.nMode == Item.ENHANCE_MODE_ENHANCE then
        tbMsg.szMsg = "您放入的玄晶过多，请勿浪费。"
      elseif self.bShowLowForbidden == 1 and self.nMode == Item.ENHANCE_MODE_ENHANCE then
        tbMsg.szMsg = "本次强化成功率过低，不可强化。"
      end
      tbMsg.nOptCount = 1
      UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, self.nMode, self.nMoneyType)
    elseif self.bShowBindMsg == 1 or (self.bShowWarnning == 1 and self.nMode == Item.ENHANCE_MODE_ENHANCE) then
      local tbMsg = {}
      local szReason = ""
      tbMsg.szMsg = ""
      if self.bShowWarnning == 1 and self.nMode == Item.ENHANCE_MODE_ENHANCE then
        tbMsg.szMsg = "您这次强化<color=red>成功率不足100%<color>，"
      end
      if self.bShowBindMsg == 1 then
        if self.nMoneyType == Item.BIND_MONEY then
          szReason = "绑定银两"
        else
          szReason = "绑定的玄晶"
        end
        if self.nMode == Item.ENHANCE_MODE_ENHANCE then
          tbMsg.szMsg = tbMsg.szMsg .. string.format("使用<color=red>%s<color>强化装备，该装备与您<color=red>绑定<color>，", szReason)
        elseif self.nMode == Item.ENHANCE_MODE_COMPOSE then
          tbMsg.szMsg = tbMsg.szMsg .. string.format("您使用了<color=red>%s<color>进行玄晶合成，合成后的玄晶也将<color=red>绑定<color>，", szReason)
        elseif self.nMode == Item.ENHANCE_MODE_STRENGTHEN then
          tbMsg.szMsg = tbMsg.szMsg .. string.format("使用<color=red>%s<color>改在装备，该装备与您<color=red>绑定<color>，", szReason)
        end
      end
      tbMsg.szMsg = tbMsg.szMsg .. "是否继续？"
      tbMsg.nOptCount = 2
      function tbMsg:Callback(nOptIndex, nMode, nMoneyType, nProb)
        if nOptIndex == 2 then
          me.ApplyEnhance(nMode, nMoneyType, (nProb or 0))
        end
      end
      UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, self.nMode, self.nMoneyType, self.nProb)
    elseif self.nMode == Item.ENHANCE_MODE_UPGRADE then
      local nMagicIndex = Lst_GetCurKey(self.UIGROUP, LIST_MAGIC_SELECT)
      if nMagicIndex == 0 then
        return 0
      end
      me.ApplyUpgradeSignet(nMagicIndex, self.nMoneyType)
    elseif self.nMode == Item.ENHANCE_MODE_REFINE then
      local nIndex = 1
      if self.tbProduce and #self.tbProduce > 1 then
        nIndex = Lst_GetCurKey(self.UIGROUP, LIST_MAGIC_SELECT)
        if nIndex == 0 or not self.tbProduce or not self.tbProduce[nIndex] then
          return 0
        end
      end
      local szMsg = "炼化后的装备会<color=green>强制与您绑定<color>，你是否要继续炼化？"
      self:UpdateMoneyFlag(self.tbProduce[nIndex].nFee + Item:CalcRefineMoney(self.pEquip))
      if self.nMoneyEnoughFlag == 1 then
        szMsg = "<color=red>将消费银两来代替绑银不足部分，<color>" .. szMsg
      end

      local tbMsg = {}
      tbMsg.szMsg = szMsg
      tbMsg.nOptCount = 2
      function tbMsg:Callback(nOptIndex, nIdx)
        if nOptIndex == 2 then
          me.ApplyRefine(nIdx)
        end
      end
      UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, self.tbProduce[nIndex].nIdx)
    elseif self.nMode == Item.ENHANCE_MODE_ENHANCE then
      me.ApplyEnhance(self.nMode, self.nMoneyType, (self.nProb or 0))
    elseif self.nMode == Item.ENHANCE_MODE_STRENGTHEN then
      local tbMsg = {}
      tbMsg.szMsg = ""
      if self.bShowHighForbidden == 1 then
        tbMsg.szMsg = "您放入的玄晶过多，请勿浪费。"
        tbMsg.nOptCount = 1
        UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, self.nMode, self.nMoneyType)
      elseif self.bShowBindMsg == 1 then
        local tbMsg = {}
        local szReason = ""
        tbMsg.szMsg = ""
        if self.nMoneyType == Item.BIND_MONEY then
          szReason = "绑定银两"
        else
          szReason = "绑定的玄晶"
        end

        tbMsg.szMsg = tbMsg.szMsg .. string.format("使用<color=red>%s<color>改在装备，该装备与您<color=red>绑定<color>，", szReason)

        tbMsg.szMsg = tbMsg.szMsg .. "是否继续？"
        tbMsg.nOptCount = 2
        function tbMsg:Callback(nOptIndex, nMode, nMoneyType, nProb)
          if nOptIndex == 2 then
            me.ApplyEnhance(nMode, nMoneyType, (nProb or 0))
          end
        end
        UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, self.nMode, self.nMoneyType, self.nProb)
      end
      me.ApplyEnhance(self.nMode, self.nMoneyType, (nProb or 0))
    elseif self.nMode == Item.ENHANCE_MODE_ENHANCE_TRANSFER then
      local tbMsg = {}
      tbMsg.szMsg = ""
      if self.bShowHighForbidden == 1 then
        tbMsg.szMsg = "您放入的玄晶过多，请勿浪费。"
        tbMsg.nOptCount = 1
        UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, self.nMode, self.nMoneyType)
      end
      tbMsg.szMsg = "转移后的装备会<color=green>强制与您绑定<color>，"
      if self.nMoneyEnoughFlag == 1 then
        tbMsg.szMsg = "<color=red>将消费银两来代替绑银不足部分，<color>"
      end
      tbMsg.szMsg = tbMsg.szMsg .. "是否继续？"
      tbMsg.nOptCount = 2
      function tbMsg:Callback(nOptIndex, nMode, nMoneyType, nProb)
        if nOptIndex == 2 then
          me.ApplyEnhance(nMode, nMoneyType, (nProb or 0))
        end
      end
      UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, self.nMode, self.nMoneyType, self.nProb)
    elseif self.nMode == Item.ENHANCE_MODE_EQUIP_RECAST then
      if not self.pTempItem then
        local tbMsg = {}
        tbMsg.szMsg = ""
        if bRecastItemBindType == 1 then
          tbMsg.szMsg = "重铸后的装备会<color=green>强制与您绑定<color>，"
        end
        if self.nMoneyEnoughFlag == 1 then
          tbMsg.szMsg = tbMsg.szMsg .. string.format("<color=red>本次重铸将扣除您的%s，<color>", tbReCastTips[self.nRecastMoneyType][1])
        end
        tbMsg.szMsg = tbMsg.szMsg .. "是否继续？"
        tbMsg.nOptCount = 2
        function tbMsg:Callback(nOptIndex, nMode, nMoneyType, nProb)
          if nOptIndex == 2 then
            me.ApplyEnhance(nMode, nMoneyType, (nProb or 0))
          end
        end
        UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, self.nMode, self.nMoneyType, self.nProb)
      else
        if not self.pEquip then
          me.Msg("要重铸的装备已经不存在!")
          me.CallServerScript({ "ReceiveRecastError", 1 })
          UiManager:CloseWindow(self.UIGROUP)
          return 0
        end
        local nIndex = Lst_GetCurKey(self.UIGROUP, LIST_MAGIC_SELECT)
        local tbTemp = { self.pEquip, self.pTempItem }
        local tbMsg = {}
        tbMsg.szMsg = "<color=yellow>确定选择该装备，是否继续？选择取消可以返回重新选择。<color>"
        tbMsg.szTitle = "提  示"
        tbMsg.tgObj = {}
        tbMsg.tgObj.nType = Ui.OBJ_TEMPITEM
        tbMsg.tgObj.pItem = tbTemp[nIndex]
        tbMsg.nOptCount = 2
        function tbMsg:Callback(nOptIndex, tbMsg, tbFun, szUiGroup)
          if nOptIndex == 2 then
            if not tbFun then
              return 0
            end
            me.CallServerScript(tbFun)
            UiManager:CloseWindow(szUiGroup)
          end
        end
        local tbFun = { "ConfirmRecast", 1, self.pEquip.dwId, nIndex }
        UiManager:OpenWindow(Ui.UI_MSGBOXWITHOBJ2, tbMsg, tbFun, self.UIGROUP)
      end
    elseif self.nMode == Item.ENHANCE_MODE_WEAPON_PEEL then
      local tbMsg = {}
      tbMsg.szMsg = ""
      tbMsg.szMsg = "请确认剥离青铜武器？"
      tbMsg.nOptCount = 2
      function tbMsg:Callback(nOptIndex, nMode, nMoneyType, nProb)
        if nOptIndex == 2 then
          me.ApplyEnhance(nMode, nMoneyType, (nProb or 0))
        end
      end
      UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, self.nMode, self.nMoneyType, self.nProb)
    else
      me.ApplyEnhance(self.nMode, self.nMoneyType)
    end
  elseif (szWnd == BTN_CANCEL) or (szWnd == BTN_CLOSE) then
    if self.nMode == Item.ENHANCE_MODE_EQUIP_RECAST and self.pTempItem then
      local tbMsg = {}
      tbMsg.szMsg = "<color=red>取消后，重铸的新装备消失，原装备保留。<color>"
      tbMsg.szMsg = tbMsg.szMsg .. "是否继续？"
      tbMsg.nOptCount = 2
      function tbMsg:Callback(nOptIndex, tbFun, szUiGroup)
        if nOptIndex == 2 then
          me.CallServerScript(tbFun)
          UiManager:CloseWindow(szUiGroup)
        end
      end
      local tbFun = { "ConfirmRecast", 0, self.pEquip.dwId, 1 }
      UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, tbFun, self.UIGROUP)
    else
      UiManager:CloseWindow(self.UIGROUP)
    end
  elseif szWnd == BTN_SELECTEQUIP then
    UiManager:OpenWindow(Ui.UI_ENHANCESELECTEQUIP)
  end
end

function uiEquipEnhance:ShowMsgBox(nMode, nMoneyType)
  local tbTimeMsg = {}
  tbTimeMsg.szMsg = "您使用了<color=red>有时间限制<color>的玄晶进行合成，合成后的玄晶也将<color=red>带有使用期限<color>，确定继续合成？"
  tbTimeMsg.nOptCount = 2
  function tbTimeMsg:Callback(nOptIndex, nMode, nMoneyType)
    if nOptIndex == 2 then
      me.ApplyEnhance(nMode, nMoneyType)
    end
  end
end

function uiEquipEnhance:UpdateEnhance(pEquip)
  --
  --	if self.nMode == Item.ENHANCE_MODE_ENHANCE_TRANSFER then
  --		Wnd_SetEnable(self.UIGROUP, BTN_CONFIRM, 1);
  --	end
  --
  --	if pEquip and (pEquip.nEnhTimes >= Item:CalcMaxEnhanceTimes(pEquip)) then	-- 在刚刚执行完最高级别强化操作时容器里的装备是不能再进行强化的
  --		Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, "◆您的装备已经成功地被强化到了极限！");
  --		return;
  --	end
  --
  --	local tbEnhItem = {};
  --	for j = 0, Item.ROOM_ENHANCE_ITEM_HEIGHT - 1 do
  --		for i = 0, Item.ROOM_ENHANCE_ITEM_WIDTH - 1 do
  --			local pEnhItem = me.GetEnhanceItem(i, j);
  --			if pEnhItem and (pEnhItem.szClass == ENHITEM_CLASS or pEnhItem.szClass == ENHANCE_DISCOUNT) then
  --				table.insert(tbEnhItem, pEnhItem);
  --			end
  --		end
  --	end
  --
  --	if (not pEquip) and (#tbEnhItem <= 0) then
  --		local szReason = ""
  --		if self.nMoneyType == Item.BIND_MONEY then
  --			szReason = "目前是用绑定银两进行强化，强化成功后装备会与您绑定"
  --		else
  --			szReason = "请注意，使用绑定的玄晶强化未绑定的装备时，该装备也会被绑定。"
  --		end
  --		Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, string.format("◆请把要强化的装备放到上面的格子，玄晶放入下面的格子，然后点击“确定”进行强化。\n<color=yellow>%s", szReason));
  --	elseif (not pEquip) and (#tbEnhItem > 0) then
  --		Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, "◆请在上面的格子中放入需要强化的装备。");
  --	elseif pEquip and (#tbEnhItem <= 0) then
  --		Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, "◆请在下面的格子中放入玄晶。");
  --	else
  --		-- by zhangjinpin@kingsoft
  --		local nProb, nMoney, bBind, _, nValue, nTrueProb = Item:CalcEnhanceProb(pEquip, tbEnhItem, self.nMoneyType);
  --
  --		self.nProb = nProb;
  --		self:UpdateMoneyFlag(nMoney);
  --		local szMsg = string.format(
  --			"◆本次强化需要收取<color=yellow>%s银两<color>%s%d两%s。(目前银两汇率是<color=yellow>%d<color>)\n◆强化成功率预测：%d%%。\n",
  --			(self.nMoneyType == Item.NORMAL_MONEY) and "普通" or "绑定",
  --			(self.nMoneyEnoughFlag == 1) and "" or "<color=red>",
  --			nMoney,
  --			(self.nMoneyEnoughFlag == 1) and "" or "<color>",
  --			Item:GetJbPrice() * 100,
  --			nProb
  --		);
  --
  --		-- *******合服优惠，合服7天后过期*******
  --		if GetTime() < KGblTask.SCGetDbTaskInt(DBTASK_COZONE_TIME) + 7 * 24 * 60 * 60 then
  --			szMsg = "<color=yellow>◆合并服务器优惠活动，你强化装备将减少20%费用\n<color>"..szMsg;
  --		end
  --		-- *************************************
  --
  --		-- by zhangjinpin@kingsoft
  --		if nProb < 10 then
  --			self.bShowLowForbidden = 1;
  --		else
  --			self.bShowLowForbidden = 0;
  --		end
  --
  --		if (nTrueProb > 120 and nValue > 16796) then
  --			self.bShowHighForbidden = 1;
  --		else
  --			self.bShowHighForbidden = 0;
  --		end
  --
  --		if nProb < 100 then
  --			szMsg = szMsg .. "◆若想提高成功率，可以放入更多的玄晶。\n";
  --
  --		end
  --		if nProb < 100 and pEquip.nEnhTimes >= 11 then
  --			self.bShowWarnning = 1;
  --		else
  --			self.bShowWarnning = 0;
  --		end
  --		if pEquip.IsBind() == 1 then	-- 装备本身绑定的不提示
  --			self.bShowBindMsg = 0;
  --		else
  --			self.bShowBindMsg = bBind;
  --		end
  --		local szTime = me.GetItemAbsTimeout(pEquip) or me.GetItemRelTimeout(pEquip);
  --		if szTime then
  --			self.bShowTimeMsg = 1;
  --		else
  --			self.bShowTimeMsg = 0;
  --		end
  --		Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, szMsg);
  --		if (#tbEnhItem > 0 ) then
  --			Wnd_SetEnable(self.UIGROUP, BTN_CONFIRM, 1);
  --		end
  --	end
end

function uiEquipEnhance:UpdatePeel(pEquip)
  --
  --	self.tbPreviewCont:ClearObj();		-- 先清除预览容器内容
  --	self:DeleteTempAllStuff();				-- 释放先前所占用的临时道具
  --
  --	if (not pEquip) then
  --		Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, "◆请把需要剥离的已强化装备放到上面的格子，下面的格子将能看到剥离后的结果。");
  --		return;
  --	end
  --
  --	Wnd_SetEnable(self.UIGROUP, BTN_CONFIRM, 1);
  --
  --	if (pEquip.nEnhTimes <= 0) then		-- 在刚刚执行完剥离操作时容器里的装备是不能剥离的
  --		Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, "◆您的装备已经成功地执行了玄晶剥离操作。");
  --		return;
  --	end
  --
  --	local tbEnhItem, nMoney, nBind = Item:CalcPeelItem(pEquip);
  --	if (not tbEnhItem) then
  --		return;
  --	end
  --	self:UpdateMoneyFlag(nMoney);
  --	local szMsg = string.format(
  --		"◆玄晶剥离会使装备<color=yellow>恢复到未强化状态<color>，同时您还将获得下面格子中的玄晶。\n" ..
  --		"◆本次剥离将<color=yellow>返还%d两<color>，请确认背包中有足够的空间，然后点击“确定”进行剥离。\n" ..
  --		"◆<color=yellow>注意：剥离所得玄晶为绑定状态<color>\n",
  --		nMoney);
  --
  --	self.tbPreviewCont.tbEnhItem = tbEnhItem;
  --	Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, szMsg);
  --
  --	local nX = 0;
  --	local nY = 0;
  --
  --	for nLevel, nCount in pairs(tbEnhItem) do
  --		if nCount > 0 then
  --			self:AddTempEnhItem(nLevel, nX, nY);
  --			if nX < Item.ROOM_ENHANCE_ITEM_WIDTH then
  --				nX = nX + 1;
  --			else
  --				nX = 0;
  --				nY = nY + 1;
  --			end
  --			if nY > Item.ROOM_ENHANCE_ITEM_HEIGHT then
  --				break;
  --			end
  --		end
  --	end
end

function uiEquipEnhance:UpdateStoneBreakUp(pStone)
  self.tbPreviewCont:ClearObj() -- 先清除预览容器内容
  self:DeleteTempAllStuff() -- 释放先前所占用的临时道具

  if not pStone then
    local szTxt = "◆请把需要拆解的原石放到上面的格子，下面的格子将能看到拆解后的结果。"
    szTxt = szTxt .. "\n◆拆解原石需要花费<color=yellow>" .. Item:FormatMoney(Item.tbStone.BREAKUP_COST_MONEY) .. "<color>银两<color=yellow>（优先扣除绑定银两）<color>。"
    Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, szTxt)
    return
  end

  Wnd_SetEnable(self.UIGROUP, BTN_CONFIRM, 1)

  if pStone.GetStoneType() ~= Item.STONE_GEM or pStone.nLevel < Item.tbStone.STONE_BREAKUP_LEVEL_LIMIT then
    return
  end

  local tbRes = Item.tbStone:GetBreakUpList(pStone)
  if not tbRes or not tbRes.nCount or not tbRes.tbGDPL then
    return
  end

  local nX = 0
  local nY = 0
  for i = 1, tbRes.nCount do
    local pTempItem = tbTempItem:Create(unpack(tbRes.tbGDPL))
    table.insert(self.tbTempItem, pTempItem)

    local tbObj = {}
    tbObj.nType = Ui.OBJ_TEMPITEM
    tbObj.pItem = pTempItem
    self.tbPreviewCont:SetObj(tbObj, nX, nY)

    if nX < Item.ROOM_ENHANCE_ITEM_WIDTH then
      nX = nX + 1
    else
      nX = 0
      nY = nY + 1
    end
    if nY > Item.ROOM_ENHANCE_ITEM_HEIGHT then
      break
    end
  end
end

function uiEquipEnhance:UpdateCompose()
  --	local tbEnhItem = {};
  --	local bMaxLevelForbid = 0;
  --	for j = 0, Item.ROOM_ENHANCE_ITEM_HEIGHT - 1 do
  --		for i = 0, Item.ROOM_ENHANCE_ITEM_WIDTH - 1 do
  --			local pEnhItem = me.GetEnhanceItem(i, j);
  --			if pEnhItem and (pEnhItem.szClass == ENHITEM_CLASS) then
  --				table.insert(tbEnhItem, pEnhItem);
  --			end
  --		end
  --	end
  --
  --	if (#tbEnhItem <= 0) then
  --		Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, "◆请在下面的格子中放入玄晶。");
  --	else
  --		local nMinLevel, nMinLevelRate, nMaxLevel, nMaxLevelRate, nFee, bBind, tbAbsTime = Item:GetComposeBudget(tbEnhItem, self.nMoneyType);
  --		local nMaxLevelInComItem = Item:GetComItemMaxLevel(tbEnhItem);
  --		if nMinLevel <= 0 then
  --			return 0;
  --		end
  --		self:UpdateMoneyFlag(nFee);
  --
  --		if self.nMinLevel == 0 then
  --			Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, "◆合成物中有非玄晶道具，不能合成！");
  --			Wnd_SetEnable(self.UIGROUP, BTN_CONFIRM, 0);
  --		else
  --			local nMinRate = math.ceil(100 * nMinLevelRate / (nMinLevelRate + nMaxLevelRate));
  --			local szMsg = string.format("◆本次合成需要收取<color=yellow>%s银两<color>%s%d两%s。(目前银两汇率是<color=yellow>%d<color>)\n◆合成预测：\n  %d%%获得%d级玄晶 ",
  --				(self.nMoneyType == Item.NORMAL_MONEY) and "普通" or "绑定",
  --				(self.nMoneyEnoughFlag == 1) and "" or "<color=red>",
  --				nFee,
  --				(self.nMoneyEnoughFlag == 1) and "" or "<color>",
  --				Item:GetJbPrice() * 100,
  --				nMinRate,
  --				nMinLevel
  --			);
  --			if nMaxLevelInComItem == nMinLevel and (100 - nMinRate) < 1 then
  --				bMaxLevelForbid = 1;
  --			end
  --
  --			if nMaxLevel > 0 then
  --				szMsg = szMsg..string.format("\n  %d%%获得%d级玄晶", 100 - nMinRate, nMaxLevel)
  --			end
  --
  --			if tbAbsTime then
  --				szMsg = szMsg..string.format("\n◆合成物有效至 <color=yellow>%d年%d月%d日%d时%d分<color>", unpack(tbAbsTime));
  --			end
  --			if nMaxLevel == 12 and nMinLevelRate == 0 then
  --				szMsg = szMsg .. "\n◆你已经可以合成最高级的玄晶了\n";
  --			elseif bMaxLevelForbid == 1 then
  --				szMsg = szMsg .. "\n◆当前合成率无法合成更高级的玄晶\n";
  --			else
  --				szMsg = szMsg .. "\n◆若想获得更高级玄晶，可以放入更多的玄晶\n";
  --			end
  --			self.bShowBindMsg = bBind;
  --
  --			Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, szMsg);
  --
  --			if (#tbEnhItem > 0) and bMaxLevelForbid == 0 then
  --				Wnd_SetEnable(self.UIGROUP, BTN_CONFIRM, 1);
  --			else
  --				Wnd_SetEnable(self.UIGROUP, BTN_CONFIRM, 0);
  --			end
  --		end
  --	end
end

function uiEquipEnhance:UpdateUpgrade(pEquip)
  --	if not pEquip then
  --		Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, "◆请在上方的格子中放入印鉴！");
  --		return;
  --	end
  --	local nMagicIndex = Lst_GetCurKey(self.UIGROUP, LIST_MAGIC_SELECT);
  --	if nMagicIndex == 0 then
  --		Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, "◆请选择升级哪条属性:");
  --		return 0;
  --	end
  --	local nCurLevel, nCurExp, nCurUpGradeExp = Item:CalcUpgrade(pEquip, nMagicIndex, 0);
  --	if nCurLevel >= Item.tbMAX_SIGNET_LEVEL[pEquip.nLevel] then
  --		Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, "◆该属性已升级到极限！");
  --		return;
  --	end
  --	local nItemNum = 0;
  --	for j = 0, Item.ROOM_ENHANCE_ITEM_HEIGHT - 1 do
  --		for i = 0, Item.ROOM_ENHANCE_ITEM_WIDTH - 1 do
  --			local pItem = me.GetEnhanceItem(i, j);
  --			if pItem and pItem.szClass == Item.UPGRADE_ITEM_CLASS then
  --				nItemNum = nItemNum + pItem.nCount;
  --			end
  --		end
  --	end
  --	if nItemNum == 0 then
  --		Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, "◆请放入五行魂石:");
  --		return 0;
  --	end
  --	local tbAttrib = pEquip.GetBaseAttrib();
  --	local szDesc = FightSkill:GetMagicDesc(tbAttrib[nMagicIndex].szName, tbAttrib[nMagicIndex].tbValue, nil, 1);
  --	local nLevel, nExp, nUpgradeExp = Item:CalcUpgrade(pEquip, nMagicIndex, nItemNum);
  --	local szIsFull = tonumber(nUpgradeExp);
  --	if (nLevel >=  Item.tbMAX_SIGNET_LEVEL[pEquip.nLevel]) then
  --		szIsFull = "<属性已经到上限>"
  --	end
  --	local szMsg = string.format("◆%s(%d/%d)\n<color=gold>  →增加%d点(%d/%s)<color>", szDesc, nCurExp, nCurUpGradeExp, nLevel, nExp, szIsFull);
  --
  --	Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, szMsg);
  --	self.nMoneyEnoughFlag = 1;
  --	Wnd_SetEnable(self.UIGROUP, BTN_CONFIRM, 1);
end

function uiEquipEnhance:UpdateRefine()
  --	self.tbPreRefineCont:ClearObj();		-- 先清除预览容器内容
  --	self:DeleteTempAllStuff();				-- 释放先前所占用的临时道具
  --	Lst_Clear(self.UIGROUP, LIST_MAGIC_SELECT);
  --	local tbRefineItem = {};
  --	for j = 0, Item.ROOM_ENHANCE_ITEM_HEIGHT - 1 do
  --		for i = 0, Item.ROOM_ENHANCE_ITEM_WIDTH - 1 do
  --			local pEnhItem = me.GetEnhanceItem(i, j);
  --			if pEnhItem then
  --				table.insert(tbRefineItem, pEnhItem);
  --			end
  --		end
  --	end
  --	if #tbRefineItem == 0 then
  --		Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, "◆请把需要炼化的装备、改造图放至下面的格子里:");
  --		return;
  --	end
  --
  --	local pEquip, pRefineItem, tbProduce, tbRefineStuff, tbRequireItem, nRefineDegree = Item:CalcRefineItem(tbRefineItem);
  --	self.pEquip = pEquip;
  --	self.nRefineDegree = nRefineDegree;
  --	if (not pEquip) then
  --		Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, "◆目前的材料不能炼化出任何装备！");
  --		return;
  --	end
  --
  --	self.tbProduce = tbProduce;
  --	for _, tbProduceItem in pairs(tbProduce) do
  --		local tbTaskData = Item:GetItemTaskData(pEquip) or {};
  --		if pEquip.IsExEquip() == 1 then
  --			tbTaskData = Item:SetItemTaskValue(tbTaskData, Item.TASKDATA_MAIN_EQUIPEX, Item.ITEM_TASKVAL_EX_SUBID_ExRefLevel, tbProduceItem.tbEquip[5]);
  --		end
  --		tbTaskData = Item:FullFilTable(tbTaskData);
  --
  --		-- 创建临时道具对象
  --		local pItem = tbTempItem:Create(
  --			tbProduceItem.tbEquip[1],
  --			tbProduceItem.tbEquip[2],
  --			tbProduceItem.tbEquip[3],
  --			tbProduceItem.tbEquip[4],
  --			pEquip.nSeries,
  --			pEquip.nEnhTimes,
  --			pEquip.nLucky,
  --			nil,
  --			0,
  --			pEquip.dwRandSeed,
  --			pEquip.nIndex,
  --			pEquip.nStrengthen,
  --			pEquip.nCount,
  --			pEquip.nCurDur,
  --			pEquip.nMaxDur,
  --			pEquip.GetRandomInfo(),
  --			tbTaskData
  --			);
  --		if not pItem then
  --			return;
  --		end
  --		table.insert(self.tbTempItem, pItem);	-- 为了释放而记录之
  --	end
  --
  --	if #tbProduce > 1 then
  --		local szMsg = "◆请选择你希望炼化的装备:";
  --		if nRefineDegree ~= 100 and #tbProduce > 0 then
  --			szMsg = "◆炼化度：<color=gold>"..nRefineDegree.."%<color> （不足100%，需要补充玄晶）\n"..szMsg;
  --		else
  --			szMsg = "◆炼化度：<color=gold>100%<color>\n"..szMsg;
  --		end
  --
  --		Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, szMsg);
  --		self:UpdateList();
  --
  --		if self.nRefineSelected ~= nil then
  --			Lst_SetCurKey(self.UIGROUP, LIST_MAGIC_SELECT, self.nRefineSelected);
  --			return;
  --		end
  --	elseif #tbProduce == 0 then
  --		print("#tbProduce == 0");
  --	else
  --		self:UpdateRefinePreview(1);
  --	end
end

function uiEquipEnhance:UpdateRefinePreview(nIndex)
  --	local pItem = self.tbTempItem[nIndex]
  --	if not pItem or not self.tbProduce or not self.tbProduce[nIndex] then
  --		return;
  --	end
  --
  --	local tbObj = {};
  --	tbObj.nType = Ui.OBJ_TEMPITEM;
  --	tbObj.pItem = pItem;
  --	self.tbPreRefineCont:SetObj(tbObj, nX, nY);
  --	self:UpdateMoneyFlag(self.tbProduce[nIndex].nFee + Item:CalcRefineMoney(self.pEquip));
  --
  --	local szRefineDegreeMsg = "◆炼化度：<color=gold>"..self.nRefineDegree.."%<color>";
  --	if self.nRefineDegree ~= 100 then
  --		szRefineDegreeMsg = szRefineDegreeMsg.."（不足100%，需要补充玄晶）\n";
  --	else
  --		szRefineDegreeMsg = szRefineDegreeMsg.."\n";
  --		Wnd_SetEnable(self.UIGROUP, BTN_CONFIRM, 1);
  --	end
  --
  --	local szMsg = string.format("◆本次炼化需要收取<color=yellow>银两<color>%s%d两%s。(优先使用绑定银两)\n",
  --			(self.nMoneyEnoughFlag > 0) and "" or "<color=red>",
  --			self.tbProduce[nIndex].nFee + Item:CalcRefineMoney(self.pEquip),
  --			(self.nMoneyEnoughFlag > 0) and "" or "<color>");
  --
  --	-- *******合服优惠，合服7天后过期*******
  --	if GetTime() < KGblTask.SCGetDbTaskInt(DBTASK_COZONE_TIME) + 7 * 24 * 60 * 60 then
  --		szMsg = szMsg .. "<color=yellow>◆合并服务器优惠活动，你炼化装备将减少20%费用\n<color>";
  --	end
  --	-- *************************************
  --
  --	Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, szRefineDegreeMsg..szMsg);
end

-- 装备改造界面更新
function uiEquipEnhance:UpdateStrengthen(pEquip)
  --	local tbStrItem = {};
  --	for j = 0, Item.ROOM_ENHANCE_ITEM_HEIGHT - 1 do
  --		for i = 0, Item.ROOM_ENHANCE_ITEM_WIDTH - 1 do
  --			local pStrItem = me.GetEnhanceItem(i, j);
  --			if pStrItem then
  --				table.insert(tbStrItem, pStrItem);
  --			end
  --		end
  --	end
  --
  --	if (not pEquip) and (#tbStrItem <= 0) then
  --		local szReason = "";
  --		if self.nMoneyType == Item.BIND_MONEY then
  --			szReason = "目前是用绑定银两进行改造，改造成功后装备会与您绑定";
  --		else
  --			szReason = "请注意，使用绑定的玄晶改造未绑定的装备时，该装备也会被绑定。";
  --		end
  --		Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, string.format("◆请把要改造的装备放到上面的格子，玄晶放入下面的格子，然后点击“确定”进行改造。\n<color=yellow>%s", szReason));
  --	elseif (not pEquip) and (#tbStrItem > 0) then
  --		Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, "◆请在上面的格子中放入需要改造的装备。");
  --	elseif Item:CheckStrengthenEquip(pEquip) ~= 1 then
  --		local _, szMsg = Item:CheckStrengthenEquip(pEquip)
  --		Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, "<color=yellow>◆"..szMsg.."<color>");
  --	elseif pEquip and (#tbStrItem <= 0) then
  --		Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, "◆请在下面的格子中放入玄晶和对应的改造符。");
  --	elseif Item:CalStrengthenStuff(pEquip, tbStrItem) == 0 then
  --		Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, "◆请在下面的格子中放入玄晶和对应的改造符。");
  --	else
  --		local nRes, szMsg, nValue, bBind, tbStuffItem, pStrengthenRecipe = Item:CalStrengthenStuff(pEquip, tbStrItem);
  --		local nProb, nMoney, nTrueProb = Item:CalcProb(pEquip, nValue, Item.ENHANCE_MODE_STRENGTHEN);
  --		if self.nMoneyType == Item.BIND_MONEY then
  --			bBind = 1;
  --		end
  --		self.nProb = nProb;
  --		self:UpdateMoneyFlag(nMoney);
  --		local szMsg = string.format(
  --			"◆本次改造需要收取<color=yellow>%s银两<color>%s%d两%s。(目前银两汇率是<color=yellow>%d<color>)\n◆当前改造度为：%d%%。\n",
  --			(self.nMoneyType == Item.NORMAL_MONEY) and "普通" or "绑定",
  --			(self.nMoneyEnoughFlag == 1) and "" or "<color=red>",
  --			nMoney,
  --			(self.nMoneyEnoughFlag == 1) and "" or "<color>",
  --			Item:GetJbPrice() * 100,
  --			nProb
  --		);
  --
  --		-- *******合服优惠，合服7天后过期*******
  --		if GetTime() < KGblTask.SCGetDbTaskInt(DBTASK_COZONE_TIME) + 7 * 24 * 60 * 60 then
  --			szMsg = "<color=yellow>◆合并服务器优惠活动，你改造装备将减少20%费用\n<color>"..szMsg;
  --		end
  --		-- *************************************
  --
  --		if (nTrueProb > 120) then
  --			self.bShowHighForbidden = 1;
  --		else
  --			self.bShowHighForbidden = 0;
  --		end
  --
  --		if nProb < 100 then
  --			szMsg = szMsg .. "◆若想提高改造度，可以放入更多的玄晶。\n";
  --		end
  --
  --		if pEquip.IsBind() == 1 then	-- 装备本身绑定的不提示
  --			self.bShowBindMsg = 0;
  --		else
  --			self.bShowBindMsg = bBind;
  --		end
  --		local szTime = me.GetItemAbsTimeout(pEquip) or me.GetItemRelTimeout(pEquip);
  --		if szTime then
  --			self.bShowTimeMsg = 1;
  --		else
  --			self.bShowTimeMsg = 0;
  --		end
  --		Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, szMsg);
  --		if (nProb == 100 and pStrengthenRecipe) then
  --			Wnd_SetEnable(self.UIGROUP, BTN_CONFIRM, 1);
  --		end
  --	end
end

--更新强化转移
function uiEquipEnhance:UpdateEnhanceTransfer(pEquip)
  --	local tbTransferItem = {};
  --	for j = 0, Item.ROOM_ENHANCE_ITEM_HEIGHT - 1 do
  --		for i = 0, Item.ROOM_ENHANCE_ITEM_WIDTH - 1 do
  --			local pItem = me.GetEnhanceItem(i, j);
  --			if pItem then
  --				table.insert(tbTransferItem, pItem);
  --			end
  --		end
  --	end
  --	local nRet,szCheckMsg = Item:CheckDropItem(tbTransferItem);
  --	local pRegionEquip,bHasTransferItem = Item:GetRegionEquip(tbTransferItem);
  --	--print("drop",Item.tbTransferEquip.nNewEnhanceTimes,Item.tbTransferEquip.nNewStrengthen,Item.tbTransferEquip.nType)
  --	if (not pEquip) and (#tbTransferItem <= 0) then
  --		local szReason = "";
  --		Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, string.format("◆请把要被转移的装备放到上面的格子，玄晶和转移的装备放入下面的格子，加入强化传承符可以减少玄晶损耗，然后点击“确定”进行转移。\n<color=yellow>%s", szReason));
  --	elseif nRet ~= 1 then
  --		Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, "◆" .. szCheckMsg);
  --	elseif (not pEquip) and (#tbTransferItem > 0) then
  --		Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, "◆请在上面的格子中放入要被转移的装备。");
  --	elseif pEquip and (#tbTransferItem <= 0) then
  --		Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, "◆请在下面的格子中放入玄晶和要转移的装备,也可加入强化传承符。");
  --	elseif pEquip and pEquip.nEnhTimes == 16 then
  --		Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, "◆您的装备已被转移至极限。");
  --	elseif pRegionEquip and pEquip then
  --		local nProb =  Item:CalcTransferProb(pEquip,tbTransferItem);
  --		local nTransferDiscount = me.GetSkillState(2220);
  --		local nOtherRebate = Item:CheckHasOtherRebate(pEquip,tbTransferItem);
  --		local nMoney = Item:CalcTransferCost(pEquip,pRegionEquip,bHasTransferItem, nOtherRebate)
  --		----强化传承优惠100%折扣
  --		if ((nTransferDiscount == 1 and nOtherRebate == 0) or (nOtherRebate == 1  and pEquip.nLevel <= Item.nDisCount and pRegionEquip.nLevel <= Item.nDisCount)) and bHasTransferItem == 1 then
  --			--非返还不扣钱
  --			if nMoney > 0 then
  --				nMoney = 0;
  --			end
  --			--转移度不够直接设为1
  --			if nProb < 1 then
  --				nProb = 1;
  --			end
  --		end
  --		self.nProb = math.floor(nProb * 100);
  --		if self.nProb < 0 then
  --			self.nProb = 0;
  --		end
  --		self:UpdateMoneyFlag(nMoney);
  --		local szMsg = "";
  --		if nMoney >= 0 then
  --			szMsg = string.format("◆本次转移需要<color=yellow>银两<color>%s%d两%s。(优先使用绑定银两)\n目前银两汇率是<color=yellow>%d<color>)\n◆当前转移度为：<color=yellow>%d%%<color>。\n",
  --			(self.nMoneyEnoughFlag > 0) and "" or "<color=red>",
  --			nMoney,
  --			(self.nMoneyEnoughFlag > 0) and "" or "<color>",
  --			Item:GetJbPrice() * 100,
  --			self.nProb);
  --		else
  --			szMsg = string.format("◆本次转移将返还<color=yellow>绑银<color>%d两。\n◆当前转移度为：<color=yellow>%d%%<color>。\n",
  --			math.abs(nMoney),
  --			self.nProb);
  --		end
  --
  --		-- *******合服优惠，合服7天后过期*******
  --		if GetTime() < KGblTask.SCGetDbTaskInt(DBTASK_COZONE_TIME) + 7 * 24 * 60 * 60 then
  --			szMsg = "<color=yellow>◆合并服务器优惠活动，你转移装备将减少20%费用\n<color>"..szMsg;
  --		end
  --		-- *************************************
  --
  --		if (self.nProb >= 120) then
  --			self.bShowHighForbidden = 1;
  --			szMsg = szMsg .. "◆当前转移度过高，不可进行转移。\n"
  --		else
  --			self.bShowHighForbidden = 0;
  --		end
  --
  --		if self.nProb < 100 then
  --			szMsg = szMsg .. "◆若想提高转移度，可以放入更多的玄晶。\n";
  --		end
  --		local szTime = me.GetItemAbsTimeout(pEquip) or me.GetItemRelTimeout(pEquip);
  --		if szTime then
  --			self.bShowTimeMsg = 1;
  --		else
  --			self.bShowTimeMsg = 0;
  --		end
  --		if (self.nProb >= 100 and self.nProb < 120) then
  --			Wnd_SetEnable(self.UIGROUP, BTN_CONFIRM, 1);
  --		end
  --		if pEquip.nLevel > 9 and pRegionEquip.nEnhTimes < 8 then
  --			szMsg = szMsg.."<color=red>◆10级装备转移需要强化等级大于8的装备。<color>\n"
  --			Wnd_SetEnable(self.UIGROUP, BTN_CONFIRM, 0);
  --		elseif Item.nTransferLowEquit == 1 and Item.bHasOtherTransferItem ~= 1 then
  --			szMsg = szMsg.."<color=red>◆您放入的装备为强化小于8的装备，需要免费转移符才能转移。<color>\n"
  --			Wnd_SetEnable(self.UIGROUP, BTN_CONFIRM, 0);
  --		end
  --		Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, szMsg);
  --	end
  --	if pRegionEquip then
  --		Item.tbTransferEquip.nNewEnhanceTimes = pRegionEquip.nEnhTimes;
  --		Item.tbTransferEquip.nNewStrengthen = pRegionEquip.nStrengthen;
  --		Item.tbTransferEquip.nType = Item:GetEquipType(pRegionEquip);
  --	elseif not pRegionEquip then
  --		Item.tbTransferEquip.nNewEnhanceTimes = nil;
  --		Item.tbTransferEquip.nNewStrengthen = nil;
  --		Item.tbTransferEquip.nType = nil;
  --	end
end

--更新装备重铸
function uiEquipEnhance:UpdateRecast()
  --	if self.pTempItem then
  --		self.tbEnhItemCont:ClearRoom();
  --	else
  --		Lst_Clear(self.UIGROUP, LIST_MAGIC_SELECT);
  --		self.tbPreRefineCont:ClearObj();		-- 先清除预览容器内容
  --	end
  --	local tbRecastItem = {};
  --	for j = 0, Item.ROOM_ENHANCE_ITEM_HEIGHT - 1 do
  --		for i = 0, Item.ROOM_ENHANCE_ITEM_WIDTH - 1 do
  --			local pEnhItem = me.GetEnhanceItem(i, j);
  --			if pEnhItem then
  --				table.insert(tbRecastItem, pEnhItem);
  --			end
  --		end
  --	end
  --	if #tbRecastItem == 0 and not self.pTempItem then
  --		Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, "◆请把需要重铸的装备、重铸符放至下面的格子里:");
  --		return 0;
  --	end
  --	local nRet = Item:CheckDropRecastItem(tbRecastItem);
  --	if nRet == 0 then
  --		Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, "◆目前的材料不能进行重铸操作！");
  --		return 0;
  --	end
  --
  --	local pOldEquip = Item:GetOldEquip(tbRecastItem);
  --	local nMoney, nMoneyType = Item:CalcRecastMoney(pOldEquip);
  --	self.nRecastMoneyType = nMoneyType or Item.emEQUIP_RECAST_CURRENCY_MONEY;
  --	if not pOldEquip then
  --		Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, "◆目前的材料不能进行重铸操作！");
  --		return 0;
  --	end
  --	local pRecastItem = Item:GetRecastItem(tbRecastItem);
  --	bRecastItemBindType = pRecastItem.IsBind();
  --	self.pEquip = pOldEquip;
  --	self:UpdateMoneyFlag(nMoney);
  --	local szMsg = "";
  --	if pOldEquip.nEnhTimes < 8 then
  --		szMsg = szMsg .. "<color=yellow>◆您放入的装备强化等级过低，建议对高强化的装备进行重铸，以免浪费。<color>\n";
  --	end
  --	szMsg = szMsg .. string.format("◆本次重铸需要收取<color=yellow>%s<color>%s%d%s%s。",
  --		tbReCastTips[self.nRecastMoneyType][1],
  --		(self.nMoneyEnoughFlag > 0) and "" or "<color=red>",
  --		nMoney,
  --		tbReCastTips[self.nRecastMoneyType][2],
  --		(self.nMoneyEnoughFlag > 0) and "" or "<color>"
  --		);
  --	Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, szMsg);
  --	if self.nMoneyEnoughFlag == 1 then
  --		Wnd_SetEnable(self.UIGROUP, BTN_CONFIRM, 1);
  --	end
end

--更新重铸后的视图显示,nIndex ,1为旧装备，2为新装备
function uiEquipEnhance:UpdateRecastPreview(nIndex)
  --	if nIndex == 0 then
  --		self.tbEnhItemCont:ClearRoom();
  --		Lst_Clear(self.UIGROUP, LIST_MAGIC_SELECT);
  --		self.tbPreRefineCont:ClearObj();		-- 先清除预览容器内容
  --	end
  --	local pItem = self.pEquip;
  --	if not pItem or not self.pTempItem then
  --		return;
  --	end
  --	self.nMoneyEnoughFlag = 1;	--第二次点确定不判断银两是否足够
  --	if nIndex and nIndex > 0 then
  --		local tbItem = {pItem,self.pTempItem};
  --		local tbObj = {};
  --		tbObj.nType = Ui.OBJ_TEMPITEM;
  --		tbObj.pItem = tbItem[nIndex];
  --		self.tbPreRefineCont:SetObj(tbObj, nX, nY);
  --		Wnd_SetEnable(self.UIGROUP, BTN_CONFIRM, 1);
  --	end
  --	Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, "<color=yellow>◆请确定要选择的装备：<color>\n<color=yellow>◆若新装备属性低于原装备，可以选择取消放弃保留原装备<color>");
  --	self:UpdateList();
end

function uiEquipEnhance:UpdateItem()
  local pEquip = me.GetEnhanceEquip()
  Wnd_SetEnable(self.UIGROUP, BTN_CONFIRM, 0)
  --	if self.nMode == Item.ENHANCE_MODE_ENHANCE then
  --		self:UpdateEnhance(pEquip);
  --	elseif self.nMode == Item.ENHANCE_MODE_PEEL then
  --		self:UpdatePeel(pEquip);
  --	elseif self.nMode == Item.ENHANCE_MODE_COMPOSE then
  --		self:UpdateCompose();
  --	elseif self.nMode == Item.ENHANCE_MODE_UPGRADE then
  --		self:UpdateUpgrade(pEquip);
  --	elseif self.nMode == Item.ENHANCE_MODE_REFINE then
  --		self:UpdateRefine();
  --	elseif self.nMode == Item.ENHANCE_MODE_STRENGTHEN then
  --		self:UpdateStrengthen(pEquip);
  --	elseif self.nMode == Item.ENHANCE_MODE_EQUIP_RECAST then
  --		self:UpdateRecast();
  --	elseif self.nMode == Item.ENHANCE_MODE_ENHANCE_TRANSFER then
  --		self:UpdateEnhanceTransfer(pEquip);
  --	elseif
  if self.nMode == Item.ENHANCE_MODE_STONE_BREAKUP then
    self:UpdateStoneBreakUp(pEquip)
  --	elseif self.nMode == Item.ENHANCE_MODE_WEAPON_PEEL then
  --		self:UpdateWeaponPeel(pEquip);
  elseif self.nMode == Item.ENHANCE_MODE_CAST then
    self:UpdateCast(pEquip)
  end
end

function uiEquipEnhance:OnSyncItem(nRoom, nX, nY)
  if (nRoom == Item.ROOM_ENHANCE_EQUIP) or (nRoom == Item.ROOM_ENHANCE_ITEM) then
    if 1 == UiManager:WindowVisible(self.UIGROUP) then
      self:UpdateItem()
    end
  end
end

function uiEquipEnhance:AddTempEnhItem(nLevel, nX, nY)
  local pItem = tbTempItem:Create(ENHITEM_INDEX.nGenre, ENHITEM_INDEX.nDetail, ENHITEM_INDEX.nParticular, nLevel) -- 创建临时道具对象

  if not pItem then
    return
  end

  table.insert(self.tbTempItem, pItem) -- 为了释放而记录之

  local tbObj = {}
  tbObj.nType = Ui.OBJ_TEMPITEM
  tbObj.pItem = pItem
  self.tbPreviewCont:SetObj(tbObj, nX, nY)
end

function uiEquipEnhance:DeleteTempAllStuff()
  for _, pTemp in pairs(self.tbTempItem) do
    tbTempItem:Destroy(pTemp)
  end
  self.tbTempItem = {}
end

function uiEquipEnhance:OnAnimationOver(szWnd)
  if szWnd == IMG_EFFECT then
    Wnd_Hide(self.UIGROUP, IMG_EFFECT) -- 播放完毕，隐藏图像

    self.tbPreRefineCont:ClearObj()
  end
end

function uiEquipEnhance:OnResult(nMode, nResult)
  if nMode == Item.ENHANCE_MODE_ENHANCE or nMode == Item.ENHANCE_MODE_PEEL or nMode == Item.ENHANCE_MODE_COMPOSE or nMode == Item.ENHANCE_MODE_UPGRADE or nMode == Item.ENHANCE_MODE_REFINE or nMode == Item.ENHANCE_MODE_STRENGTHEN or nMode == Item.ENHANCE_MODE_ENHANCE_TRANSFER or nMode == Item.ENHANCE_MODE_EQUIP_RECAST or nMode == Item.ENHANCE_MODE_WEAPON_PEEL or nMode == Item.ENHANCE_MODE_BREAKUP_XUAN or nMode == Item.ENHANCE_MODE_YINJIAN_RECAST then
    return
  end

  self.tbEnhItemCont:ClearRoom()

  --	if nMode == Item.ENHANCE_MODE_ENHANCE then
  --		if (nResult == 1) then
  --			Wnd_Show(self.UIGROUP, IMG_EFFECT);
  -- 			Img_PlayAnimation(self.UIGROUP, IMG_EFFECT);	-- 播放动画特效
  --			me.Msg("你的装备强化成功！");
  --		elseif (nResult == 0) then
  --			me.Msg("很遗憾，您这次装备强化失败了。");
  --		else
  --			me.Msg("无法进行装备强化！");
  --		end
  --	elseif nMode == Item.ENHANCE_MODE_PEEL then
  --		if (nResult == 1) then
  --			me.Msg("玄晶剥离操作成功！");
  --		elseif (nResult == 0) then
  --			me.Msg("很遗憾，您这次玄晶剥离失败了。");
  --		else
  --			me.Msg("无法进行玄晶剥离！");
  --		end
  --	elseif nMode == Item.ENHANCE_MODE_COMPOSE then
  --		if nResult > 0 then
  --			me.Msg("你成功合成一个"..nResult.."级玄晶！");
  --		end
  --	elseif nMode == Item.ENHANCE_MODE_UPGRADE then
  --		if nResult > 0 then
  --			Wnd_Show(self.UIGROUP, IMG_EFFECT);
  -- 			Img_PlayAnimation(self.UIGROUP, IMG_EFFECT);	-- 播放动画特效
  -- 			local pEquip = me.GetEnhanceEquip();
  -- 			self:UpdateList(pEquip);
  --			me.Msg("你的印鉴升级成功！");
  --		end
  --	elseif nMode == Item.ENHANCE_MODE_STRENGTHEN then
  --		if (nResult > 0) then
  --			Wnd_Show(self.UIGROUP, IMG_EFFECT);
  -- 			Img_PlayAnimation(self.UIGROUP, IMG_EFFECT);	-- 播放动画特效
  --			me.Msg("你的装备改造成功！");
  --		elseif (nResult == 0) then
  --			me.Msg("装备改造失败！");
  --		end
  --	elseif nMode == Item.ENHANCE_MODE_ENHANCE_TRANSFER then
  --		if (nResult > 0) then
  --			Wnd_Show(self.UIGROUP, IMG_EFFECT);
  -- 			Img_PlayAnimation(self.UIGROUP, IMG_EFFECT);	-- 播放动画特效
  --			me.Msg("你的装备转移成功！");
  --		elseif (nResult == 0) then
  --			me.Msg("装备转移失败！");
  --		end
  --	elseif
  if nMode == Item.ENHANCE_MODE_STONE_BREAKUP then
    if nResult > 0 then
      me.Msg("原石拆解操作成功！")
    elseif nResult == 0 then
      me.Msg("很遗憾，您此次原石拆解操作失败了")
    else
      me.Msg("无法进行原石拆解！")
    end
  --	elseif nMode == Item.ENHANCE_MODE_WEAPON_PEEL then
  --		if (nResult == 1) then
  --			me.Msg("青铜武器剥离操作成功！");
  --		elseif (nResult == 0) then
  --			me.Msg("很遗憾，您这次青铜武器剥离失败了。");
  --		else
  --			me.Msg("无法进行青铜武器剥离！");
  --		end
  elseif nMode == Item.ENHANCE_MODE_CAST then
    if nResult == 1 then
      local tbObj = {}
      tbObj.nType = Ui.OBJ_TEMPITEM
      tbObj.pItem = self.pCastEquip
      self.tbPreRefineCont:SetObj(tbObj, nX, nY)
      --me.SetItem(self.pCastEquip, Item.ROOM_ENHANCE_EQUIP, 0, 0);
      --local tbPos = me.GetItemPos(self.pCastEquip);
      --me.SwitchItem(tbPos.nRoom, tbPos.nX, tbPos.nY, Item.ROOM_ENHANCE_EQUIP, 0, 0);
      Wnd_Show(self.UIGROUP, IMG_EFFECT)
      Img_PlayAnimation(self.UIGROUP, IMG_EFFECT) -- 播放动画特效
      me.Msg("装备精铸操作成功！")
      self.pCastEquip = nil
      return
    elseif nResult == 0 then
      me.Msg("很遗憾，您此次装备精铸操作失败了！")
    else
      me.Msg("无法进行装备精铸！")
    end
    self.pCastEquip = nil
  end
  self:UpdateItem()
end

function uiEquipEnhance:UpdateMoneyFlag(nMoney)
  if self.nMode == Item.ENHANCE_MODE_PEEL then -- 剥离不扣钱
    self.nMoneyEnoughFlag = 1
  elseif self.nMode == Item.ENHANCE_MODE_REFINE or self.nMode == Item.ENHANCE_MODE_ENHANCE_TRANSFER then -- 炼化和转移不区分绑定和非绑定银两
    if me.GetBindMoney() >= nMoney then
      self.nMoneyEnoughFlag = 2
    else
      self.nMoneyEnoughFlag = (me.nCashMoney + me.GetBindMoney() >= nMoney) and 1 or 0
    end
  elseif self.nMoneyType == Item.BIND_MONEY then
    self.nMoneyEnoughFlag = (me.GetBindMoney() >= nMoney) and 1 or 0
  elseif self.nMode == Item.ENHANCE_MODE_WEAPON_PEEL then -- 剥离不扣钱
    self.nMoneyEnoughFlag = 1
  elseif self.nMode == Item.ENHANCE_MODE_EQUIP_RECAST then
    if self.nRecastMoneyType == Item.emEQUIP_RECAST_CURRENCY_LONGHUN then
      local nCount = me.GetItemCountInBags(unpack(Item.tbLonghunCurrencyItemId))
      self.nMoneyEnoughFlag = (nCount >= nMoney) and 1 or 0
    else
      self.nMoneyEnoughFlag = (me.nCashMoney >= nMoney) and 1 or 0
    end
  else
    self.nMoneyEnoughFlag = (me.nCashMoney >= nMoney) and 1 or 0
  end
end

function uiEquipEnhance:StateRecvUse(szUiGroup)
  if szUiGroup == self.UIGROUP then
    return
  end

  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    return
  end

  local tbObj = tbMouse:GetObj()
  if not tbObj then
    return
  end
  local pItem = me.GetItem(tbObj.nRoom, tbObj.nX, tbObj.nY)

  --	if self.nMode == Item.ENHANCE_MODE_ENHANCE then				-- 装备强化
  --		if (pItem.IsEquip() == 1) then
  --			self.tbEquipCont:ClearRoom();
  --			self.tbEquipCont:SpecialStateRecvUse();
  --		else
  --			self.tbEnhItemCont:SpecialStateRecvUse();
  --		end
  --	elseif self.nMode == Item.ENHANCE_MODE_REFINE then			-- 装备炼化
  --
  --		self.tbEnhItemCont:SpecialStateRecvUse();
  --
  --	elseif (self.nMode == Item.ENHANCE_MODE_COMPOSE) then		-- 玄晶合成
  --
  --		self.tbEnhItemCont:SpecialStateRecvUse();
  --
  --	elseif (self.nMode == Item.ENHANCE_MODE_PEEL) then 			-- 玄晶剥离
  --		--if (pItem.IsEquip() == 1) then
  --			self.tbEquipCont:ClearRoom();
  --			self.tbPreviewCont:ClearObj();
  --		--end
  --		self.tbEquipCont:SpecialStateRecvUse();
  --
  --	elseif (self.nMode == Item.ENHANCE_MODE_UPGRADE) then		-- 印鉴升级
  --
  --		if (pItem.nDetail == Item.EQUIP_SIGNET) then
  --			self.tbEquipCont:SpecialStateRecvUse();
  --		else
  --			self.tbEnhItemCont:SpecialStateRecvUse();
  --		end
  --
  --	elseif (self.nMode == Item.ENHANCE_MODE_STRENGTHEN) then	-- 装备改造
  --		if (pItem.IsEquip() == 1) then
  --			self.tbEquipCont:ClearRoom();
  --			self.tbEquipCont:SpecialStateRecvUse();
  --		else
  --			self.tbEnhItemCont:SpecialStateRecvUse();
  --		end
  --	elseif self.nMode == Item.ENHANCE_MODE_ENHANCE_TRANSFER then	--强化转移
  --		if (pItem.IsEquip() == 1) then
  --			self.tbEquipCont:ClearRoom();
  --			self.tbEquipCont:SpecialStateRecvUse();
  --		else
  --			self.tbEnhItemCont:SpecialStateRecvUse();
  --		end
  --	elseif self.nMode == Item.ENHANCE_MODE_EQUIP_RECAST then	--装备重铸
  --		self.tbEnhItemCont:SpecialStateRecvUse();
  --	elseif
  if self.nMode == Item.ENHANCE_MODE_STONE_BREAKUP then
    self.tbEquipCont:ClearRoom()
    self.tbPreviewCont:ClearObj()
    Wnd_SetEnable(self.UIGROUP, BTN_CONFIRM, 0)
    self.tbEquipCont:SpecialStateRecvUse()
  --	elseif (self.nMode == Item.ENHANCE_MODE_WEAPON_PEEL) then 			-- 玄晶剥离
  --		self.tbEquipCont:ClearRoom();
  --		self.tbPreviewCont:ClearObj();
  --		self.tbEquipCont:SpecialStateRecvUse();
  elseif self.nMode == Item.ENHANCE_MODE_CAST then
    self.tbEquipCont:ClearRoom()
    self.tbPreviewCont:ClearObj()
    self.tbEnhItemCont:SpecialStateRecvUse()
  end
end

function uiEquipEnhance:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_ITEM, self.OnSyncItem }, -- 角色道具同步事件
    { UiNotify.emCOREEVENT_ENHANCE_RESULT, self.OnResult }, -- 同步强化/剥离操作结果
    { UiNotify.emCOREEVENT_MONEY_CHANGED, self.UpdateItem }, -- 金钱发生改变
    { UiNotify.emUIEVENT_OBJ_STATE_USE, self.StateRecvUse },
    { UiNotify.emCOREEVENT_RECAST_RESULT, self.OnReCastResult }, -- 重铸发生变化
  }
  Lib:MergeTable(tbRegEvent, self.tbEquipCont:RegisterEvent())
  Lib:MergeTable(tbRegEvent, self.tbEnhItemCont:RegisterEvent())
  Lib:MergeTable(tbRegEvent, self.tbPreviewCont:RegisterEvent())
  Lib:MergeTable(tbRegEvent, self.tbPreRefineCont:RegisterEvent())
  return tbRegEvent
end

function uiEquipEnhance:RegisterMessage()
  local tbRegMsg = {}
  Lib:MergeTable(tbRegMsg, self.tbEquipCont:RegisterMessage())
  Lib:MergeTable(tbRegMsg, self.tbEnhItemCont:RegisterMessage())
  Lib:MergeTable(tbRegMsg, self.tbPreviewCont:RegisterMessage())
  Lib:MergeTable(tbRegMsg, self.tbPreRefineCont:RegisterMessage())
  return tbRegMsg
end

function uiEquipEnhance:OnReCastResult(nResult, nNewSeed, ...)
  do
    return
  end
  if nResult == 1 then
    local tbRandMa = {}
    if not self.pEquip then
      me.Msg("你要重铸的装备已经不存在！")
      me.CallServerScript({ "ReceiveRecastError", 1 })
      UiManager:CloseWindow(self.UIGROUP)
      return 0
    end
    if not nNewSeed then
      me.Msg("您的客户端存在异常！")
      me.CallServerScript({ "ReceiveRecastError", 1 })
      UiManager:CloseWindow(self.UIGROUP)
      return 0
    end
    for i = 1, Item.emITEM_COUNT_RANDOM do
      tbRandMa[i] = arg[i]
    end
    for _, pTemp in pairs(tbUnUseItem) do
      tbTempItem:Destroy(pTemp)
    end

    local tbTaskData = Item:GetItemTaskData(self.pEquip) or {}
    tbTaskData = Item:FullFilTable(tbTaskData)
    self.pTempItem = self:CreateTempItem(self.pEquip.nGenre, self.pEquip.nDetail, self.pEquip.nParticular, self.pEquip.nLevel, self.pEquip.nSeries, self.pEquip.nEnhTimes, self.pEquip.nLucky, self.pEquip.GetGenInfo(), 0, KLib.Number2UInt(nNewSeed), -1, self.pEquip.nStrengthen, 0, 1000, 1000, tbRandMa, tbTaskData)
    if not self.pTempItem then
      me.Msg("你的装备重铸失败！")
      me.CallServerScript({ "ReceiveRecastError", 1 })
      UiManager:CloseWindow(self.UIGROUP)
      return 0
    end
    me.Msg("你的装备重铸成功，请确定要选择的装备！")
    self:UpdateRecastPreview(0)
    Lst_SetCurKey(self.UIGROUP, LIST_MAGIC_SELECT, 1) --默认选择原装备
  else
    tbTempItem:Destroy(self.pTempItem) --如果返回失败，则清楚临时道具
    me.Msg("你的装备重铸失败！")
    self:UpdateRecastPreview(0)
    return 0
  end
end

function uiEquipEnhance:CreateTempItem(...)
  local pItem = tbTempItem:Create(unpack(arg))
  if not pItem then
    return
  end
  return pItem
end

--青铜武器剥离
function uiEquipEnhance:UpdateWeaponPeel(pEquip)
  self.tbPreviewCont:ClearObj() -- 先清除预览容器内容
  self:DeleteTempAllStuff() -- 释放先前所占用的临时道具

  if not pEquip then
    Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, "◆请把需要剥离的青铜武器放到上面的格子，下面的格子将能看到剥离后的结果。")
    return
  end

  Wnd_SetEnable(self.UIGROUP, BTN_CONFIRM, 1)

  local bIsQinTongWep, tbEquipInfo = Item:CheckIsQinTongWep(pEquip)
  if bIsQinTongWep ~= 1 then -- 在刚刚执行完剥离操作时容器里的装备是不能剥离的
    Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, "◆您的青铜武器已经成功剥离。")
    return
  end

  local szMsg = string.format("◆青铜武器剥离会使装备<color=yellow>恢复到未炼化状态<color>。\n" .. "◆本次剥离将<color=yellow>返还5个和氏玉<color>，请确认背包中有足够的空间，然后点击“确定”进行剥离。\n" .. "◆<color=yellow>注意：剥离所得和氏玉为绑定状态<color>\n", nMoney)

  Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, szMsg)

  self:UpdateMoneyFlag(0)

  --和氏璧
  local pItemEx = tbTempItem:Create(22, 1, 81, 1) -- 创建临时道具对象

  if pItemEx then
    table.insert(self.tbTempItem, pItemEx) -- 为了释放而记录之

    local tbObj = {}
    tbObj.nType = Ui.OBJ_TEMPITEM
    tbObj.pItem = pItemEx
    tbObj.szBindType = "获取绑定"
    self.tbPreviewCont:SetObj(tbObj, 0, 0)
  end
end

-- 装备精铸，用了跟炼化一样的uiobj容器
function uiEquipEnhance:UpdateCast(pItem)
  self.tbPreRefineCont:ClearObj() -- 先清除预览容器内容
  self:DeleteTempAllStuff() -- 释放先前所占用的临时道具
  if pItem then
    me.Msg("装备精铸，请不要在上面的格子内放入东西！")
    return
  end

  local tbCastItem = {}
  for j = 0, Item.ROOM_ENHANCE_ITEM_HEIGHT - 1 do
    for i = 0, Item.ROOM_ENHANCE_ITEM_WIDTH - 1 do
      local pEnhItem = me.GetEnhanceItem(i, j)
      if pEnhItem then
        table.insert(tbCastItem, pEnhItem)
      end
    end
  end

  local pEquip, pStuff = Item:AnaylizeCastItemList(tbCastItem)
  if not pEquip or not pStuff then
    Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, "◆请把卓越或以上品质的龙魂系列装备和对应部件的精铸石放入下方格子中:")
    return
  else
    local nRes, nCastLevel = Item:CheckCanCast(pEquip, pStuff)
    if nRes ~= 1 then
      Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, "◆<color=red>只能放入卓越或以上品质的龙魂系列装备和对应部件的精铸石方可精铸。<color>\n如果装备已经精铸过，则需要放入更高级的精铸石！")
      return
    end

    local nEnhId = Item:GetExCastEnhId(pEquip.nDetail, nCastLevel)
    local tbTaskData = Item:GetItemTaskData(pEquip) or {}
    tbTaskData = Item:SetItemTaskValue(tbTaskData, Item.TASKDATA_MAIN_EQUIPEX, Item.ITEM_TASKVAL_EX_SUBID_ENHID, nEnhId)
    tbTaskData = Item:SetItemTaskValue(tbTaskData, Item.TASKDATA_MAIN_EQUIPEX, Item.ITEM_TASKVAL_EX_SUBID_CastLevel, nCastLevel)
    tbTaskData = Item:FullFilTable(tbTaskData)

    -- 创建临时道具对象
    local pTemp = tbTempItem:Create(pEquip.nGenre, pEquip.nDetail, pEquip.nParticular, pEquip.nLevel, pEquip.nSeries, pEquip.nEnhTimes, pEquip.nLucky, nil, 0, pEquip.dwRandSeed, pEquip.nIndex, pEquip.nStrengthen, pEquip.nCount, pEquip.nCurDur, pEquip.nMaxDur, pEquip.GetRandomInfo(), tbTaskData)
    if not pTemp then
      return
    end
    table.insert(self.tbTempItem, pTemp) -- 为了释放而记录之

    local tbObj = {}
    tbObj.nType = Ui.OBJ_TEMPITEM
    tbObj.pItem = pTemp
    self.tbPreRefineCont:SetObj(tbObj, nX, nY)

    --local szCastMsg = "◆纯天然无消耗无污染，你还在等什么？赶快点击确定精铸吧！";
    local szCastMsg = "◆<color=green>你已放入全部所需物品，点击确定即可完成精铸！<color>"
    Txt_SetTxt(self.UIGROUP, TXT_MESSAGE, szCastMsg)
    Wnd_SetEnable(self.UIGROUP, BTN_CONFIRM, 1)

    self.pCastEquip = pEquip

    --local tb = pEquip.GetTempTable();
    --tb.nTempCastLevel = nCastLevel;
    --self.pCastEquip = pEquip;
  end
end
