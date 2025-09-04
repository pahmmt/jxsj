------------------------------------------------------
-- 文件名　：switchpanel.lua
-- 创建者　：dengyong
-- 创建时间：2011-05-09 16:57:27
-- 描  述  ：切换装备五行界面
------------------------------------------------------

local tbUiSwitchPanel = Ui:GetClass("switchpanel")
local tbTempItem = Ui.tbLogic.tbTempItem

tbUiSwitchPanel.BTN_CLOSE = "BtnClose"
tbUiSwitchPanel.BTN_OK = "BtnOK"
tbUiSwitchPanel.BTN_CANCEL = "BtnCancel"
tbUiSwitchPanel.BTN_CANCEL_SWITCH = "BtnCancelSwitch"
tbUiSwitchPanel.BTN_ADDTO_SWITCH = "BtnAddToSwitch"

tbUiSwitchPanel.TXTEX_EQUIP_POS_NAME = "TxtExEquipPosName"
tbUiSwitchPanel.TXTEX_EQUIP_POS_NAME2 = "TxtExEquipPosName2"

tbUiSwitchPanel.COMBOBOX_ROUTE = "ComboBoxEdtRoute"
tbUiSwitchPanel.COMBOBOX_EQUIP_TYPE = "ComboBoxEdtEquipType"

tbUiSwitchPanel.LIST_ORG_EQUIP = "LstOrgEquip"
tbUiSwitchPanel.LIST_NEW_EQUIP = "LstNewEquip"

-- 控制装备列表在LIST控件上的显示顺序
local tbEquipPosDisplayeOrder = {
  Item.EQUIPPOS_WEAPON,
  Item.EQUIPPOS_NECKLACE,
  Item.EQUIPPOS_RING,
  Item.EQUIPPOS_PENDANT,
  Item.EQUIPPOS_AMULET,
  Item.EQUIPPOS_HEAD,
  Item.EQUIPPOS_BODY,
  Item.EQUIPPOS_BELT,
  Item.EQUIPPOS_CUFF,
  Item.EQUIPPOS_FOOT,
}

local tbEquipPosName = {
  [Item.EQUIPPOS_HEAD] = "帽  子：",
  [Item.EQUIPPOS_BODY] = "衣  服：",
  [Item.EQUIPPOS_BELT] = "腰  带：",
  [Item.EQUIPPOS_WEAPON] = "武  器：",
  [Item.EQUIPPOS_FOOT] = "鞋  子：",
  [Item.EQUIPPOS_CUFF] = "护  腕：",
  [Item.EQUIPPOS_AMULET] = "护身符：",
  [Item.EQUIPPOS_RING] = "戒  指：",
  [Item.EQUIPPOS_NECKLACE] = "项  链：",
  [Item.EQUIPPOS_PENDANT] = "腰  坠：",
}

local LIST_PAGE_MAX_NUM = 10 -- list控件单页最多显示item数
local COMBO_EQUIPTYPE_LIMITSTR = "防具和首饰"

local tbListKeyDisplayType = {
  "不转换",
  "无装备",
  "无法转换",
}

function tbUiSwitchPanel:Init()
  self.nComBoRoute = 1 -- 默认选择第1项
  self.nComboEquipType = 1

  self.nOrgListSel = 0
  self.nNewListSel = 0

  self.nOrgShowPage = 0
  self.nNewShowPage = 0

  self.nOrgEquipCount = 0
  self.nNewEquipCount = 0

  self.tbSwitchInfo = {}
  for i = Item.EQUIPPOS_HEAD, Item.EQUIPPOS_PENDANT do
    self.tbSwitchInfo[i + 1] = 1 -- 默认都需要切换
  end

  self.tbOrgEquipList = {} -- 原来的装备列表
  self.tbNewEquipList = {} -- 可切换的装备列表
end

function tbUiSwitchPanel:OnOpen()
  UiManager:SetUiState(UiManager.UIS_SWITCH_EQUIP_SERIES)

  self:Update()
end

function tbUiSwitchPanel:OnClose()
  UiManager:ReleaseUiState(UiManager.UIS_SWITCH_EQUIP_SERIES)
  self:OnClickCancel()

  self.nComBoRoute = 1 -- 默认选择第1项
  self.nComboEquipType = 1

  self.nOrgListSel = 0
  self.nNewListSel = 0

  self.nOrgShowPage = 0
  self.nNewShowPage = 0

  self:__ReleaseTempItem()
end

function tbUiSwitchPanel:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_OK then
    self:OnClickOK()
  elseif szWnd == self.BTN_CANCEL then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_ADDTO_SWITCH then
    local nIndex = self.nOrgShowPage * LIST_PAGE_MAX_NUM + self.nOrgListSel
    if nIndex > Lib:CountTB(self.tbOrgEquipList) then
      return
    end

    local tbItemInfo1 = self.tbOrgEquipList[nIndex]
    local tbItemInfo2 = self.tbNewEquipList[nIndex]
    if not tbItemInfo1 or not tbItemInfo1.pItem or not tbItemInfo2 or not tbItemInfo2.pItem then
      return
    end

    local nEquipPos = tbEquipPosDisplayeOrder[nIndex]
    if self.tbSwitchInfo[nEquipPos + 1] ~= 1 then
      self.tbSwitchInfo[nEquipPos + 1] = 1
      self:UpdateNewEquipList(self.nNewShowPage)
    end
  elseif szWnd == self.BTN_CANCEL_SWITCH then
    local nIndex = self.nNewShowPage * LIST_PAGE_MAX_NUM + self.nNewListSel
    if nIndex > Lib:CountTB(self.tbNewEquipList) then
      return
    end

    local tbItemInfo1 = self.tbOrgEquipList[nIndex]
    local tbItemInfo2 = self.tbNewEquipList[nIndex]
    if not tbItemInfo1 or not tbItemInfo1.pItem or not tbItemInfo2 or not tbItemInfo2.pItem then
      return
    end

    local nEquipPos = tbEquipPosDisplayeOrder[nIndex]
    if self.tbSwitchInfo[nEquipPos + 1] ~= 0 then
      self.tbSwitchInfo[nEquipPos + 1] = 0
      self:UpdateNewEquipList(self.nNewShowPage)
    end
  end
end

-- 两个LIST关联单击选中事件
function tbUiSwitchPanel:OnListSel(szWnd, nParam)
  if szWnd == self.LIST_ORG_EQUIP then
    self.nOrgListSel = nParam
    -- 需要判断，不能死循环
    if self.nNewListSel ~= nParam then
      Lst_SetCurKey(self.UIGROUP, self.LIST_NEW_EQUIP, nParam)
    end
  elseif szWnd == self.LIST_NEW_EQUIP then
    self.nNewListSel = nParam
    -- 需要判断，不能死循环
    if self.nOrgListSel ~= nParam then
      Lst_SetCurKey(self.UIGROUP, self.LIST_ORG_EQUIP, nParam)
    end
  end
end

function tbUiSwitchPanel:OnListOver(szWnd, nIndex)
  local szTitle, szTip, szViewImage

  local pItem = nil
  if szWnd == self.LIST_ORG_EQUIP then
    local tbInfo = self.tbOrgEquipList[nIndex] or {}
    pItem = tbInfo.pItem or nil
  elseif szWnd == self.LIST_NEW_EQUIP then
    local nEquipPos = tbEquipPosDisplayeOrder[nIndex]
    local bSwitch = 0
    if nEquipPos then
      bSwitch = self.tbSwitchInfo[nEquipPos + 1] or 0
    end

    if bSwitch == 1 then
      local tbInfo = self.tbNewEquipList[nIndex] or {}
      pItem = tbInfo.pItem or nil
    end
  end

  if not pItem then
    return
  end

  Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, pItem.GetCompareTip(Item.TIPS_NORMAL))
end

function tbUiSwitchPanel:OnComboBoxIndexChange(szWnd, nIndex)
  if szWnd == self.COMBOBOX_ROUTE then
    self.nComBoRoute = nIndex + 1
  elseif szWnd == self.COMBOBOX_EQUIP_TYPE then
    self.nComboEquipType = nIndex + 1
  end

  self:ApplyNewEquipList(0)
end

function tbUiSwitchPanel:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_ITEM, self.OnOrgEquipChanged },
  }

  return tbRegEvent
end

function tbUiSwitchPanel:RegisterMessage()
  local tbRegMsg = {}
  return tbRegMsg
end

function tbUiSwitchPanel:Update()
  -- 每个item项的key值是对应装备的位置
  self.tbOrgEquipList = {}
  self.nOrgEquipCount = 0
  for i, nPos in pairs(tbEquipPosDisplayeOrder) do
    local pEquip = me.GetItem(Item.ROOM_EQUIP, nPos)
    table.insert(self.tbOrgEquipList, { nListKey = i, pItem = pEquip })
    if pEquip then
      self.nOrgEquipCount = self.nOrgEquipCount + 1
    end
  end

  self:UpdateEquipPosName()
  self:UpdateMyFactionRoute()
  self:UpdateComboBox()
  self:ApplyNewEquipList(0)
  self:UpdateOrgEquipList(0)
end

-- 更新的原装备LIST的显示
function tbUiSwitchPanel:UpdateOrgEquipList(nPage)
  self:ShowPage(self.LIST_ORG_EQUIP, nPage)
end

-- 指定显示某个LIST的某一页
function tbUiSwitchPanel:ShowPage(szWnd, nPage)
  local nFromIdx, nEndIdx = 0, 0
  local tbDisplayInfo = {}

  if szWnd == self.LIST_ORG_EQUIP then
    tbDisplayInfo = self.tbOrgEquipList
    self.nOrgShowPage = nPage
  elseif szWnd == self.LIST_NEW_EQUIP then
    tbDisplayInfo = self.tbNewEquipList
    self.nNewShowPage = nPage
  end

  nFromIdx = LIST_PAGE_MAX_NUM * nPage + 1
  nEndIdx = nFromIdx + LIST_PAGE_MAX_NUM

  if nFromIdx > #tbDisplayInfo then
    return
  end

  if nEndIdx > #tbDisplayInfo then
    nEndIdx = #tbDisplayInfo
  end

  Lst_Clear(self.UIGROUP, szWnd)
  for i = nFromIdx, nEndIdx do
    local tbInfo = tbDisplayInfo[i]
    if not tbInfo then
      break
    end

    -- list上一个item的显示内容状态，0表示显示道具名，否则从tbListKeyDisplayType里面获取
    local nDisplayeState = self:GetListKeyDisplayeState(szWnd, i)

    local szPreFix = " "
    if nDisplayeState == 0 then
      Lst_SetCell(self.UIGROUP, szWnd, tbInfo.nListKey, 0, tbInfo.pItem and szPreFix .. tbInfo.pItem.szName or szPreFix)
    else
      local szDisplay = string.format("%s<color=yellow>%s<color>", szPreFix, tbListKeyDisplayType[nDisplayeState] or "")
      Lst_SetCell(self.UIGROUP, szWnd, tbInfo.nListKey, 0, szDisplay)
    end
  end
end

-- 更新装备位置名称文本框
function tbUiSwitchPanel:UpdateEquipPosName()
  local szEquipPosName = ""
  for _, nPos in pairs(tbEquipPosDisplayeOrder) do
    local szName = tbEquipPosName[nPos] or " "
    szEquipPosName = szEquipPosName .. szName .. "\n"
  end

  TxtEx_SetText(self.UIGROUP, self.TXTEX_EQUIP_POS_NAME, szEquipPosName)
  TxtEx_SetText(self.UIGROUP, self.TXTEX_EQUIP_POS_NAME2, szEquipPosName)
end

-- 更新下拉框菜单
function tbUiSwitchPanel:UpdateComboBox()
  ClearComboBoxItem(self.UIGROUP, self.COMBOBOX_ROUTE)

  for i, tbInfo in pairs(self.tbFactionRoute) do
    local nFaction = tbInfo[1]
    local nRoute = tbInfo[2]
    local nIndex = (nFaction - 1) * 2 + nRoute

    local szRouteName = Player.tbRouteName[nIndex]

    if i == 1 then
      szRouteName = szRouteName .. "（主修）"
    end

    ComboBoxAddItem(self.UIGROUP, self.COMBOBOX_ROUTE, i, szRouteName)
  end
  ComboBoxSelectItem(self.UIGROUP, self.COMBOBOX_ROUTE, 0)

  ClearComboBoxItem(self.UIGROUP, self.COMBOBOX_EQUIP_TYPE)
  for i, szType in pairs(Item.tbEquipType) do
    ComboBoxAddItem(self.UIGROUP, self.COMBOBOX_EQUIP_TYPE, i, szType .. COMBO_EQUIPTYPE_LIMITSTR)
  end
  ComboBoxSelectItem(self.UIGROUP, self.COMBOBOX_EQUIP_TYPE, 0)
end

-- 获取切换装备列表，并显示LIST
function tbUiSwitchPanel:ApplyNewEquipList(nPage)
  self:RefreshNewEquipItem(nPage)
  self:UpdateNewEquipList(nPage)
end

-- 更新切换装备列表
function tbUiSwitchPanel:UpdateNewEquipList(nPage)
  self:ShowPage(self.LIST_NEW_EQUIP, nPage)
end

-- 根据原有装备信息获取切换装备信息，创建临时道具
-- 如果临时道具创建失败，返回退出UI
function tbUiSwitchPanel:RefreshNewEquipItem()
  self:__ReleaseTempItem()
  self.tbNewEquipList = {}
  self.nNewEquipCount = 0

  local nSelectFaction, nSelectRoute, nEquipType = self:GetComboSelectInfo()

  if not nSelectRoute or not nSelectFaction then
    return
  end

  for i, tbInfo in pairs(self.tbOrgEquipList) do
    local pItem = tbInfo.pItem
    if pItem and pItem.IsWhite() ~= 1 then
      local szGDPL = string.format("%d_%d_%d_%d", pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel)

      local tbMatchGDPLs = Item:GetMatchEquip(szGDPL, nSelectFaction, nSelectRoute, Item.tbEquipType[nEquipType], tbEquipPosDisplayeOrder[i])

      local tbGDPL = nil
      if tbMatchGDPLs then
        tbGDPL = tbMatchGDPLs[1]
      end

      local pTempItem = nil

      if tbGDPL then
        local tbBase = KItem.GetEquipBaseProp(unpack(tbGDPL))
        local nSeries = tbBase.nSeries
        pTempItem = tbTempItem:Create(tbGDPL[1], tbGDPL[2], tbGDPL[3], tbGDPL[4], nSeries, pItem.nEnhTimes, pItem.nLucky, nil, 0, pItem.dwRandSeed, pItem.nIndex, pItem.nStrengthen)

        if not pTempItem then
          Dialog:Say("临时道具创建失败！")
          UiManager:CloseWindow(self.UIGROUP)
          return
        else
          if pItem.IsBind() == 1 then
            pTempItem.Bind(pItem.IsBind())
          end
        end
      end

      table.insert(self.tbNewEquipList, { nListKey = i, pItem = pTempItem })
      if pTempItem then
        self.nNewEquipCount = self.nNewEquipCount + 1
      end
    else
      table.insert(self.tbNewEquipList, { nListKey = i, pItem = nil })
    end
  end
end

-- 获取当前选中的门派和路线和内外功系别
function tbUiSwitchPanel:GetComboSelectInfo()
  -- 选定的门派路线

  local nSelectFaction, nSelectRoute
  if self.tbComboIndexToRouteIndex[self.nComBoRoute] then
    local nFactionRouteIndex = self.tbComboIndexToRouteIndex[self.nComBoRoute]
    if self.tbFactionRoute[nFactionRouteIndex] then
      nSelectFaction = self.tbFactionRoute[nFactionRouteIndex][1]
      nSelectRoute = self.tbFactionRoute[nFactionRouteIndex][2]
    end
  end

  -- 选定的装备类型
  local nEquipType = self.nComboEquipType

  return nSelectFaction, nSelectRoute, nEquipType
end

-- 释放掉创建的临时道具
function tbUiSwitchPanel:__ReleaseTempItem()
  for _, tbInfo in pairs(self.tbNewEquipList) do
    local pItem = tbInfo.pItem
    if pItem then
      tbTempItem:Destroy(pItem)
    end
  end
end

function tbUiSwitchPanel:OnClickOK()
  if self.nOrgEquipCount <= 0 or self.nNewEquipCount <= 0 then
    me.Msg("你当前没有装备或者装备都不能转换！")
    return
  end

  local nSwitchCount = self:CalSwitchCount()
  if nSwitchCount <= 0 then
    me.Msg("没有可转换的装备！")
    return
  end

  local nFaction, nRoute = self:GetComboSelectInfo()
  local nEquipType = self.nComboEquipType

  if not nFaction or not nRoute then
    me.Msg("请先选择欲转换成的门派路线！")
    return
  end

  local tbApplyInfo = {}
  tbApplyInfo.nFaction = nFaction
  tbApplyInfo.nRoute = nRoute
  tbApplyInfo.nEquipType = nEquipType

  tbApplyInfo.tbSwitchInfo = self.tbSwitchInfo

  me.CallServerScript({ "ItemSwitchEquipCmd", "OnSwitchOK", tbApplyInfo })
end

function tbUiSwitchPanel:OnClickCancel()
  me.CallServerScript({ "ItemSwitchEquipCmd", "OnSwitchCancel" })
end

function tbUiSwitchPanel:OnOrgEquipChanged(nRoom)
  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    return
  end

  -- 是主装备栏的装备发生改变了地刷新
  if nRoom == Item.ROOM_EQUIP then
    self:Update()
  end
end

-- 获取自己所修的所有职业
function tbUiSwitchPanel:UpdateMyFactionRoute()
  self.tbFactionRoute = {}
  self.tbComboIndexToRouteIndex = {}

  local nCurFaction = me.nFaction
  local nCurRoute = me.nRouteId

  if Faction:IsInit(me) == 1 then
    local tbGerneFaction = Faction:GetGerneFactionInfo(me)
    for i, nFaction in pairs(tbGerneFaction) do
      local nRoute = 0
      -- 当前应用的门派最好从角色变量取，不要从任务变量取
      if nFaction ~= nCurFaction then
        local nFactionGroupId = Faction.tbFactionRecGroupId[nFaction]
        nRoute = me.GetTask(nFactionGroupId, Faction.TSKID_FACTION_ROUTE)
      else
        nRoute = nCurRoute
      end

      if nRoute ~= 0 then
        table.insert(self.tbFactionRoute, i, { nFaction, nRoute })
        table.insert(self.tbComboIndexToRouteIndex, i)
      end
    end
  end

  if (Faction:IsInit(me) ~= 1) or Lib:CountTB(self.tbFactionRoute) == 0 then
    if nCurRoute ~= 0 then
      table.insert(self.tbFactionRoute, 1, { nCurFaction, nCurRoute })
      table.insert(self.tbComboIndexToRouteIndex, 1)
    end
  end
end

-- 获取LIST上各个KEY的显示值
-- 返回值：0显示道具名字，1有装备不转换，2无装备，3有装备无法转换
function tbUiSwitchPanel:GetListKeyDisplayeState(szWnd, nIndex)
  -- 无装备
  if not self.tbOrgEquipList[nIndex] or not self.tbOrgEquipList[nIndex].pItem then
    return 2
  end

  if szWnd == self.LIST_NEW_EQUIP then
    if not self.tbNewEquipList[nIndex] or not self.tbNewEquipList[nIndex].pItem then -- 有装备无法转换
      return 3
    else -- 显示装备名字或者不转换
      local nEquipPos = tbEquipPosDisplayeOrder[nIndex]
      local nState = 1 - (self.tbSwitchInfo[nEquipPos + 1] or 0)
      return nState
    end
  end

  return 0
end

-- 计算当前条件下可转换装备个数
function tbUiSwitchPanel:CalSwitchCount()
  local nSwitchCount = 0

  for nIndex, tbInfo in pairs(self.tbNewEquipList) do
    if tbInfo.pItem then
      local nEquipPos = tbEquipPosDisplayeOrder[nIndex]
      local bSwitch = self.tbSwitchInfo[nEquipPos + 1]

      nSwitchCount = bSwitch == 1 and nSwitchCount + 1 or nSwitchCount
    end
  end

  return nSwitchCount
end
