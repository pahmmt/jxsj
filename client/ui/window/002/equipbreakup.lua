local uiEquipBreakUp = Ui:GetClass("equipbreakup")
local tbObject = Ui.tbLogic.tbObject
local tbMouse = Ui.tbLogic.tbMouse
local tbTempItem = Ui.tbLogic.tbTempItem

local TXT_GTPCOST = "TxtGTPCost"
local TXT_GTP = "TxtGTP"
local BTN_BREAKUP = "BtnBreakUp"
local BTN_CLOSE = "BtnClose"
local OBJ_BREAKUP_EQUIP = "ObjBreakUpEquip"
local OBJ_STUFF_ITEM = "ObjStuffEquip"
local TXT_STUFFEQUIP = "TxtStuffequip"

local OBJSTUFF_ROW = 1
local OBJSTUFF_LINE = 2

function uiEquipBreakUp:Init()
  self.bEnable = 0
end

local tbEquipCont = { bUse = 0, nRoom = Item.ROOM_BREAKUP }
local tbStuffCont = { bShowCd = 0, bUse = 0, bLink = 0, bSwitch = 0 }

function tbEquipCont:CheckSwitchItem(pDrop, pPick, nX, nY)
  if not pDrop then
    self.nGTPCost = 0
    self.tbStuff = {}
    return 1
  end

  if pDrop.IsBind() == 1 then
    me.Msg("已绑定装备不能拆解！")
    return 0
  end

  if pDrop.nGenre ~= 1 then
    me.Msg("只有普通装备才可以拆解！")
    return 0
  end

  if (pDrop.nDetail < Item.MIN_COMMON_EQUIP) or (pDrop.nDetail > Item.MAX_COMMON_EQUIP) then
    me.Msg("参与五行激活的装备才能拆解！")
    return 0
  end

  if pDrop.nEnhTimes > 0 then
    me.Msg("已被强化过装备不能拆解！")
    return 0
  end

  local nGTPCost, tbStuff, tbExp = Item:CalcBreakUpStuff(pDrop)
  if (nGTPCost <= 0) or (#tbStuff <= 0) then
    me.Msg("该装备品质太低，无法拆出任何有用的材料！")
    return 0
  end

  self.nGTPCost = nGTPCost
  self.tbStuff = tbStuff
  self.tbExp = tbExp
  return 1
end

function uiEquipBreakUp:OnCreate()
  self.tbEquipCont = tbObject:RegisterContainer(self.UIGROUP, OBJ_BREAKUP_EQUIP, Item.ROOM_BREAKUP_WIDTH, Item.ROOM_BREAKUP_HEIGHT, tbEquipCont, "itemroom")
  self.tbStuffCont = tbObject:RegisterContainer(self.UIGROUP, OBJ_STUFF_ITEM, OBJSTUFF_ROW, OBJSTUFF_LINE, tbStuffCont)
end

function uiEquipBreakUp:OnDestroy()
  tbObject:UnregContainer(self.tbEquipCont)
  tbObject:UnregContainer(self.tbStuffCont)
end

function uiEquipBreakUp:OnOpen()
  UiManager:OpenWindow(Ui.UI_ITEMBOX) -- 总是打开主背包
  UiManager:SetUiState(UiManager.UIS_EQUIP_BREAKUP)
  self.tbStuffCont.tbCount = {}
  self.tbStuffCont.nGTPCost = 0
  self.tbStuffCont.tbStuff = {}
  self.tbStuffCont.tbExp = {}
  self:UpdateWnd()
  self:UpdateGTP()
end

function uiEquipBreakUp:OnClose()
  self.tbEquipCont:ClearRoom()
  self.tbStuffCont:ClearObj()
  UiManager:ReleaseUiState(UiManager.UIS_EQUIP_BREAKUP)
end

function tbStuffCont:FormatItem(tbItem)
  local tbObj = {}
  local pItem = tbItem.pItem
  if not pItem then
    return
  end
  tbObj.szBgImage = pItem.szIconImage
  tbObj.bShowSubScript = 1 -- 总显示下标数字
  return tbObj
end

function tbStuffCont:UpdateItem(tbItem, nX, nY)
  local pItem = tbItem.pItem
  local nCount = self.tbCount[nY] or 0
  ObjGrid_ChangeSubScript(self.szUiGroup, self.szObjGrid, tostring(nCount), nX, nY)
  local nColor = (me.CanUseItem(pItem) ~= 1) and 0x60ff0000 or 0
  ObjGrid_ChangeBgColor(self.szUiGroup, self.szObjGrid, nColor, nX, nY)
  ObjGrid_SetTransparency(self.szUiGroup, self.szObjGrid, pItem.szTransparencyIcon, nX, nY)
end

function uiEquipBreakUp:ViewBreakUpResult()
  for i = 1, OBJSTUFF_LINE do
    local tbStuff = self.tbEquipCont.tbStuff[i]
    if tbStuff then
      local pItem = tbTempItem:Create(tbStuff.nGenre, tbStuff.nDetail, tbStuff.nParticular, tbStuff.nLevel, tbStuff.nSeries)
      local tbObj = nil
      if pItem then
        tbObj = {}
        tbObj.nType = Ui.OBJ_TEMPITEM
        tbObj.pItem = pItem
        self.tbStuffCont.tbCount[i - 1] = tbStuff.nCount
      end
      self.tbStuffCont:SetObj(tbObj, 0, i - 1)
      Txt_SetTxt(self.UIGROUP, TXT_STUFFEQUIP .. i, pItem.szName)
    end
  end
end

function uiEquipBreakUp:OnSyncItem(nRoom, nX, nY)
  if nRoom == Item.ROOM_BREAKUP then
    local pEquip = me.GetItem(nRoom)
    self:OnUpdate()
    if not pEquip then
      self.bEnable = 0
      for i = 1, OBJSTUFF_LINE do
        Txt_SetTxt(self.UIGROUP, TXT_STUFFEQUIP .. i, "")
      end
    else
      self.bEnable = 1
      self:ViewBreakUpResult()
    end
    self:UpdateWnd()
  end
end

function uiEquipBreakUp:OnUpdate()
  for i = 0, OBJSTUFF_ROW - 1 do
    local tbObj = self.tbStuffCont:GetObj(i)
    if tbObj then
      tbTempItem:Destroy(tbObj.pItem)
    end
  end
  self.tbStuffCont:ClearObj()
end

function uiEquipBreakUp:CheckApply()
  if me.dwCurGTP < self.tbEquipCont.nGTPCost then
    me.Msg("您的活力值不够！")
    return 0
  end
  if me.CanAddItemIntoBag(unpack(self.tbEquipCont.tbStuff)) ~= 1 then
    me.Msg("您的背包空间不够！")
    return 0
  end
  return 1
end

function uiEquipBreakUp:OnButtonClick(szWnd, nParam)
  if szWnd == BTN_BREAKUP then
    if self:CheckApply() == 1 then
      me.ApplyBreakUp()
    end
  elseif szWnd == BTN_CLOSE then
    UiManager:CloseWindow(Ui.UI_EQUIPBREAKUP)
    -- 关了这个窗口之后打开生活技能窗口
    UiManager:OpenWindow(Ui.UI_LIFESKILL)
  end
end

function uiEquipBreakUp:UpdateWnd()
  Txt_SetTxt(self.UIGROUP, TXT_GTPCOST, self.tbEquipCont.nGTPCost)
  Wnd_SetEnable(self.UIGROUP, BTN_BREAKUP, self.bEnable)
end

function uiEquipBreakUp:OnResult(bSuccess)
  if bSuccess == 1 then
    me.Msg("拆解成功！")
    self.bEnable = 0
    self.tbEquipCont.nGTPCost = 0
    self.tbEquipCont:ClearObj()
    self:OnUpdate()
    self:UpdateWnd()
    return 1
  else
    me.Msg("拆解失败！")
    return 0
  end
end

function uiEquipBreakUp:UpdateGTP()
  Txt_SetTxt(self.UIGROUP, TXT_GTP, me.dwCurGTP)
end

function uiEquipBreakUp:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_ITEM, self.OnSyncItem }, -- 角色道具同步事件
    { UiNotify.emCOREEVENT_BREAKUP_RESULT, self.OnResult }, -- 拆解结果通知
    { UiNotify.emCOREEVENT_SYNC_GTP, self.UpdateGTP }, -- 活力值改变
  }
  tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbEquipCont:RegisterEvent())
  tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbStuffCont:RegisterEvent())
  return tbRegEvent
end

function uiEquipBreakUp:RegisterMessage()
  local tbRegMsg = Lib:MergeTable(self.tbEquipCont:RegisterMessage(), self.tbStuffCont:RegisterMessage())
  return tbRegMsg
end
