------------------------------------------------------
-- 文件名　：exchangestone.lua
-- 创建者　：dengyong
-- 创建时间：2011-05-26 14:23:48
-- 描  述  ：原石兑换界面
------------------------------------------------------

local uiExchangeStone = Ui:GetClass("exchangestone")
local tbObject = Ui.tbLogic.tbObject
local tbTempItem = Ui.tbLogic.tbTempItem

local tbSelectList = {
  { "紫色原石", "purple" },
  { "红色原石", "red" },
  { "橙色原石", "orange" },
  { "金色原石", "gold" },
}

local tbOrgStoneCont = { bShowCd = 0, bUse = 0, nRoom = Item.ROOM_STONE_EXCHANGE_ORG, bSendToGift = 1 }
local tbResultStoneCont = { bShowCd = 1, bUse = 0, bLink = 0, bSwitch = 0 }
local DISPLAY_OBJ_LEN = 4
local RESULT_OBJ_LENGTH = 41
local RESULT_OBJ_HSPEC = 9
local RESULT_OBJ_VSPEC = 4
local IMG_HIGHLIGHT_LEN = 36

uiExchangeStone.COMBOBOX_STONE_COLOR = "CmbStoneColor"
uiExchangeStone.OBJ_ORG_STONE = "ObjOrgStone"
uiExchangeStone.OBJ_RESULT_STONE = "ObjResultStone"
uiExchangeStone.IMG_CELLLIGHT = "ImgCellLight"
uiExchangeStone.BTN_OK = "BtnOK"
uiExchangeStone.BTN_CANCEL = "BtnCancel"
uiExchangeStone.BTN_CLOSE = "BtnClose"

function tbOrgStoneCont:CheckSwitchItem(pDrop, pPick, nX, nY)
  -- 放入操作总是能成功
  if not pDrop then
    return 1
  end

  local nStoneType = pDrop.GetStoneType()
  if nStoneType ~= Item.STONE_GEM then
    me.Msg("只能放入原石！")
    return 0
  end

  local bLegal, tbFeature, n = Ui(Ui.UI_EXCHANGE_STONE):GetOrgStoneExchangeFeature()
  if bLegal ~= 1 or (tbFeature and Item.tbStone:IsExchangeFeatureMatch(pDrop, tbFeature) ~= 1) then
    me.Msg("您放入的原石特征不同，只有放入三块同等级的普通原石或三块同等级的特殊原石才能进行兑换。")
    return 0
  end

  return 1
end

-- 重写基类鼠标左键点击格子事件
function tbResultStoneCont:OnObjGridSwitch(nX, nY)
  Ui(Ui.UI_EXCHANGE_STONE):ClickResultStoneObj(nX, nY)
end

function uiExchangeStone:Init()
  self.nComboSelect = 1 -- 兑换颜色选择项
  self.tbDisplayItemList = {} -- 显示的可转换原石临时道具列表
  self.nSelectResult = -1 -- 选择兑换成的原石所有OBJ的索引

  self:ResetComboColorSelList()
end

-- 创建OBJ
function uiExchangeStone:OnCreate()
  self.tbOrgStoneObjCont = tbObject:RegisterContainer(
    self.UIGROUP,
    self.OBJ_ORG_STONE,
    3,
    1,
    tbOrgStoneCont, -- 不可使用
    "itemroom"
  )
  self.tbResultStoneObjCont = tbObject:RegisterContainer(
    self.UIGROUP,
    self.OBJ_RESULT_STONE,
    DISPLAY_OBJ_LEN,
    DISPLAY_OBJ_LEN,
    tbResultStoneCont, -- 不可使用
    "award"
  )
end

-- 释放OBJ
function uiExchangeStone:OnDestroy()
  tbObject:UnregContainer(self.tbOrgStoneObjCont)
  tbObject:UnregContainer(self.tbResultStoneObjCont)
end

-- 窗口打开事件
function uiExchangeStone:OnOpen()
  UiManager:SetUiState(UiManager.UIS_STONE_EXCHAGNE)
  self:UpdateComboBox()
  Wnd_SetEnable(self.UIGROUP, self.BTN_OK, 0)

  UiManager:OpenWindow(Ui.UI_ITEMBOX)
end

-- 窗口关闭事件，注意要释放UI状态和释放临时道具对象
function uiExchangeStone:OnClose()
  me.ApplyStoneOperation(Item.tbStone.emSTONE_OPERATION_NONE)

  UiManager:ReleaseUiState(UiManager.UIS_STONE_EXCHAGNE)

  self.tbOrgStoneObjCont:ClearRoom()

  self:ReleaseDisplayStones()
end

-- 点击按钮事件
function uiExchangeStone:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_CANCEL then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_OK then
    if self.tbDisplayItemList[self.nSelectResult + 1] then
      local pTempItem = self.tbDisplayItemList[self.nSelectResult + 1]
      local nSelInfo = Item.tbStone:ReParseGDPLToHoleFormat(pTempItem.TbGDPL()) -- 这是格式化好的选择的原石的GDPL

      local nSelColorIndex = self.tbDisplayColor[self.nComboSelect] or 0

      local tbMsg = {}
      tbMsg.szMsg = string.format("确定要兑换成<color=yellow>%s<color>吗？", pTempItem.szName)
      tbMsg.nOptCount = 2
      function tbMsg:Callback(nOptIndex, nSelColorIndex, nSelInfo)
        if nOptIndex == 2 then
          me.ApplyStoneOperation(Item.tbStone.emSTONE_OPERATION_EXCHANGE, nSelColorIndex, nSelInfo)
        end
      end
      UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nSelColorIndex, nSelInfo)
      return
    else
      me.Msg("请先选择需要兑换的原石。")
    end
  end
end

-- 设置下拉框下拉列表项
function uiExchangeStone:UpdateComboBox()
  ClearComboBoxItem(self.UIGROUP, self.COMBOBOX_STONE_COLOR)

  for i, nColorIndex in pairs(self.tbDisplayColor) do
    ComboBoxAddItem(self.UIGROUP, self.COMBOBOX_STONE_COLOR, i, tbSelectList[nColorIndex][1])
  end
  ComboBoxSelectItem(self.UIGROUP, self.COMBOBOX_STONE_COLOR, 0)
end

-- 下拉框选项改变事件
function uiExchangeStone:OnComboBoxIndexChange(szWnd, nIndex)
  if self.nComboSelect ~= nIndex + 1 then
    self.nComboSelect = nIndex + 1
    self.nSelectResult = -1

    self:UpdateResultObjInfo(1)
    self:Updateselectresulteffect()
  end
end

-- 可兑换原石列表选择事件
function uiExchangeStone:ClickResultStoneObj(nX, nY)
  local nClick = nX + nY * DISPLAY_OBJ_LEN

  if nClick == self.nSelectResult then
    self.nSelectResult = -1
  else
    self.nSelectResult = nClick
  end

  self:Updateselectresulteffect()
end

function uiExchangeStone:RegisterMessage()
  local tbRegMsg = {}
  tbRegMsg = Lib:MergeTable(tbRegMsg, self.tbOrgStoneObjCont:RegisterMessage())
  tbRegMsg = Lib:MergeTable(tbRegMsg, self.tbResultStoneObjCont:RegisterMessage())

  return tbRegMsg
end

function uiExchangeStone:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_ITEM, self.OnSyncItem },
    { UiNotify.emUIEVENT_OBJ_STATE_USE, self.StateRecvUse },
    { UiNotify.emCOREEVENT_STONE_EXCHANGE_REUSTL, self.OnResult },
  }
  tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbOrgStoneObjCont:RegisterEvent())
  tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbResultStoneObjCont:RegisterEvent())
  return tbRegEvent
end

function uiExchangeStone:OnSyncItem(nRoom, nX, nY)
  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    return
  end

  if nRoom == Item.ROOM_STONE_EXCHANGE_ORG then
    self:UpdateResultObjInfo()
  end
end

-- 操作结果返回函数
function uiExchangeStone:OnResult(nResult)
  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    return
  end

  if nResult == 1 then
    -- 播放动画
    --	Wnd_Show(self.UIGROUP, IMG_EFFECT);
    --	Img_PlayAnimation(self.UIGROUP, IMG_EFFECT);	-- 播放动画特效
    me.Msg("原石兑换操作成功！")
  elseif nResult == 0 then
    me.Msg("很遗憾，您的此次原石兑换失败！")
  else
    me.Msg("无法进行原石兑换！")
  end

  -- 清除选择效果
  if self.nSelectResult ~= -1 then
    self.nSelectResult = -1
    self:Updateselectresulteffect()
  end
end

-- 放入成品原石后，根据原石特征显示可兑换原石列表
-- bForce为1表示强制更新，不用计算COMBOBOX_STONE_COLOR的显示情况
function uiExchangeStone:UpdateResultObjInfo(bForce)
  bForce = bForce or 0

  local bLegal, tbFeature, nStoneCount = self:GetOrgStoneExchangeFeature()
  if bLegal ~= 1 or nStoneCount ~= 3 then
    -- 清空结果原石列表
    self.tbDisplayItemList = {}
    self.tbResultStoneObjCont:ClearObj()
    self:ResetComboColorSelList()
  else
    -- 过滤combox中的颜色选择列表，把没有兑换信息的颜色踢除掉
    if bForce ~= 1 then
      self:FilterComboColorSelList(tbFeature)
    end

    -- 先清空
    self.tbResultStoneObjCont:ClearObj()

    if not self.tbDisplayColor or Lib:CountTB(self.tbDisplayColor) == 0 or not self.tbDisplayColor[self.nComboSelect] then
      return
    end

    -- 再重新计算
    local tbItemInfo = Item.tbStone:GetExchangeList(tbFeature)
    if not tbItemInfo or Lib:CountTB(tbItemInfo) == 0 then
      return
    end

    local nColorIndex = self.tbDisplayColor[self.nComboSelect]
    local szSelectColor = tbSelectList[nColorIndex][2]
    local tbDisplayeList = tbItemInfo[szSelectColor]

    -- 过滤掉原来的原石
    tbDisplayeList = self:FilterDisplayList(tbDisplayeList)

    self:CreateDisplayStones(tbDisplayeList)
    self:ShowSelectableStones()
  end
end

-- 获取兑换石的信息，三个原石必须具有相同的兑换特征
-- 如果格子里的原石兑换特征匹配，返回1和特征；否则返回0
function uiExchangeStone:GetOrgStoneExchangeFeature()
  local szGDPL = nil
  local tbFeature = nil
  local bLegal = 1 --  0表示原石类型不匹配，1表示匹配
  local nStoneCount = 0

  for i = 0, Item.ROOM_STONE_EXCHANGE_ORG_WIDTH - 1 do
    local pItem = me.GetItem(Item.ROOM_STONE_EXCHANGE_ORG, i, 0)
    if pItem then
      nStoneCount = nStoneCount + 1

      local bChange, tb = Item.tbStone:GetStoneExchangeFeature(pItem)
      if bChange ~= 1 then
        bLegal = 0
        tbFeature = nil
        break
      end

      if not tbFeature then
        tbFeature = tb
      end

      if Item.tbStone:IsExchangeFeatureMatch(tbFeature, tb) ~= 1 then
        bLegal = 0
        tbFeature = nil
        break
      end
    end
  end

  return bLegal, tbFeature, nStoneCount
end

-- 创建显示的可选择原石临时道具列表
function uiExchangeStone:CreateDisplayStones(tbDisplayeList)
  self:ReleaseDisplayStones()
  self.tbDisplayItemList = {}

  for _, tbGDPL in pairs(tbDisplayeList or {}) do
    local pTempItem = tbTempItem:Create(tbGDPL[1], tbGDPL[2], tbGDPL[3], tbGDPL[4])

    table.insert(self.tbDisplayItemList, pTempItem)
  end
end

-- 释放可选择原石临时道具列表
function uiExchangeStone:ReleaseDisplayStones()
  for _, pTempItem in pairs(self.tbDisplayItemList) do
    if pTempItem then
      tbTempItem:Destroy(pItem)
    end
  end
end

-- 显示可选择兑换的原石列表
function uiExchangeStone:ShowSelectableStones()
  if Lib:CountTB(self.tbDisplayItemList) > 16 then
    --UiManager:OpenWindow("UI_INFOBOARD", "可兑换的原石列表起过了16个！");
  end
  for i, pTempItem in pairs(self.tbDisplayItemList) do
    if pTempItem then
      local nX = (i - 1) % DISPLAY_OBJ_LEN
      local nY = math.floor((i - 1) / DISPLAY_OBJ_LEN)
      local tbObj = {}

      tbObj.nType = Ui.OBJ_TEMPITEM
      tbObj.pItem = pTempItem
      tbObj.nCount = 1

      self.tbResultStoneObjCont:SetObj(tbObj, nX, nY)
    end
  end
end

-- 选定结果按钮后的表现操作
function uiExchangeStone:Updateselectresulteffect()
  if self.nSelectResult < 0 or not self.tbDisplayItemList or not self.tbDisplayItemList[self.nSelectResult + 1] then
    Wnd_Hide(self.UIGROUP, self.IMG_CELLLIGHT)
    Wnd_SetEnable(self.UIGROUP, self.BTN_OK, 0)
    return
  end

  -- 实际显示的坐标要偏移OBJ_RESULT_STONE的原点坐标
  local nBeginX, nBeginY = Wnd_GetPos(self.UIGROUP, self.OBJ_RESULT_STONE)

  -- 选中的格子索引
  local nY = math.floor(self.nSelectResult / DISPLAY_OBJ_LEN)
  local nX = self.nSelectResult - nY * DISPLAY_OBJ_LEN

  -- 图片重心偏移
  local nXOff = math.floor((RESULT_OBJ_LENGTH - IMG_HIGHLIGHT_LEN) / 2 * (nX + 1))
  local nYOff = math.floor((RESULT_OBJ_LENGTH - IMG_HIGHLIGHT_LEN) / 2 * (nY + 1))

  -- 相对于MAIN的最终坐标
  local nDisplayX = nBeginX + nX * RESULT_OBJ_LENGTH + nX * RESULT_OBJ_HSPEC + 2
  local nDisplayY = nBeginY + nY * RESULT_OBJ_LENGTH + nY * RESULT_OBJ_VSPEC + 2

  Wnd_Show(self.UIGROUP, self.IMG_CELLLIGHT)
  Wnd_SetPos(self.UIGROUP, self.IMG_CELLLIGHT, nDisplayX, nDisplayY)
  Wnd_SetEnable(self.UIGROUP, self.BTN_OK, 1)
end

-- 支持右键放入原石
function uiExchangeStone:StateRecvUse(szUiGroup)
  if szUiGroup == self.szUiGroup then
    return
  end

  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    return
  end

  local tbObj = Ui.tbLogic.tbMouse:GetObj()
  if not tbObj then
    return
  end

  self.tbOrgStoneObjCont:SpecialStateRecvUse()
end

-- 把兑换列表中与原来的原石相同的去掉
function uiExchangeStone:FilterDisplayList(tbList)
  if not tbList then
    return
  end

  for i = 0, Item.ROOM_STONE_EXCHANGE_ORG_WIDTH - 1 do
    local pItem = me.GetItem(Item.ROOM_STONE_EXCHANGE_ORG, i, 0)
    if pItem then
      tbList = Item.tbStone:FilterExchangeList(tbList, pItem)
    end
  end

  return tbList
end

-- 过滤掉combox中没有对应颜色下没有兑换列表的项
function uiExchangeStone:FilterComboColorSelList(tbFeature)
  self.tbDisplayColor = {}

  local tbList = Item.tbStone:GetExchangeList(tbFeature) or {}
  local tbItemInfo = tbList
  for szColor, tbColorList in pairs(tbList) do
    tbItemInfo[szColor] = self:FilterDisplayList(tbColorList)
  end

  if not tbItemInfo or Lib:CountTB(tbItemInfo) == 0 then
    return
  end

  for i, tbInfo in pairs(tbSelectList) do
    local szColor = tbInfo[2]
    if tbItemInfo[szColor] and Lib:CountTB(tbItemInfo[szColor]) > 0 then
      table.insert(self.tbDisplayColor, i)
    end
  end

  if self.nSelectResult ~= -1 then
    self.nSelectResult = -1
    self:Updateselectresulteffect()
  end
  self:UpdateComboBox()
end

-- 重置combox选择项
function uiExchangeStone:ResetComboColorSelList()
  -- 重置combox颜色选择项全显示
  self.tbDisplayColor = {}
  for i, tbInfo in pairs(tbSelectList) do
    table.insert(self.tbDisplayColor, #self.tbDisplayColor + 1, i)
  end

  if self.nSelectResult ~= -1 then
    self.nSelectResult = -1
    self:Updateselectresulteffect()
  end

  self:UpdateComboBox()
end
