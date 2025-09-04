-----------------------------------------------------
--文件名		：	shop.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间	：	2007-03-17
--功能描述	：	商店功能脚本。
------------------------------------------------------

local uiShop = Ui:GetClass("shop")
local tbObject = Ui.tbLogic.tbObject
local tbMsgInfo = Ui.tbLogic.tbMsgInfo
local tbTempData = Ui.tbLogic.tbTempData

uiShop.CLOSE_WINDOW_BUTTON = "BtnClose"
uiShop.NEXT_PAGE_BUTTON = "BtnNext"
uiShop.PREVIOUS_PAGE_BUTTON = "BtnPrevious"
uiShop.BUTTON_PAGE_RECYCLE = "BtnItemToRec"
uiShop.BUTTON_PAGE_BUY = "BtnItemToBuy"
uiShop.PAGE_NUMBER_TEXT = "TxtPageNum"
uiShop.OBJ_BUY = "ObjShop"
uiShop.OBJ_RECYCLE = "ObjRecycle"

uiShop.BUTTON_PEPAIR_ALL = "BtnRepairAll"
uiShop.BUTTON_PEPAIREX_ALL = "BtnRepairExAll"
uiShop.BUTTON_PEPAIREX = "BtnRepairEx"

uiShop.BUY_WIDTH = 5
uiShop.BUY_HEIGHT = 8

uiShop.tbBtn2State = {
  { "BtnBuy", UiManager.UIS_TRADE_BUY },
  { "BtnSale", UiManager.UIS_TRADE_SELL },
  { "BtnRepair", UiManager.UIS_TRADE_REPAIR, Ui.UI_PLAYERPANEL },
  { "BtnRepairEx", UiManager.UIS_TRADE_REPAIR_EX, Ui.UI_PLAYERPANEL },
}

local tbBuyCont = { bLink = 0 }
local tbRecycleCont = { nRoom = Item.ROOM_RECYCLE, bLink = 0 }

function tbRecycleCont:SwitchObj(nX, nY)
  local tbObj = self:GetObj(nX, nY)
  if (not tbObj) or (tbObj.nRoom ~= Item.ROOM_RECYCLE) then
    return 0
  end
  local pItem = me.GetItem(Item.ROOM_RECYCLE, nX, nY)
  if not pItem then
    Ui:Output("[ERR] Object机制内部错误！")
    return 0
  end
  local nPrice = me.GetRecycleItemPrice(pItem)
  local nBindMoney = me.GetBindMoney() or 0
  local nDestPrice = pItem.IsBind() == 1 and (me.nCashMoney + nBindMoney) or me.nCashMoney
  if nPrice and (nPrice <= nDestPrice) then
    local tbMsg = {}
    if 1 == pItem.IsBind() then
      local nCostBindMoney = nPrice > nBindMoney and nBindMoney or nPrice
      local nCostMoney = nPrice - nCostBindMoney

      --拼接消耗绑定及非绑定银两的格式化字符串, 考虑没有绑定银两时的提示
      local subMsg1 = nCostBindMoney > 0 and "<color=yellow>%d<color>绑定银两" or ""
      local subMsg2 = nCostMoney > 0 and "<color=yellow>%d<color>银两" or ""
      if nCostBindMoney > 0 and nCostMoney > 0 then
        subMsg2 = "以及" .. subMsg2
      end
      local szMsgFmt = string.format(subMsg1, nCostBindMoney)
      szMsgFmt = szMsgFmt .. string.format(subMsg2, nCostMoney)

      tbMsg.szMsg = string.format("确定要花" .. szMsgFmt .. "回购[%s]吗？", pItem.szName)
    else
      tbMsg.szMsg = string.format("确定要花<color=yellow>%d<color>银两回购[%s]吗？", nPrice, pItem.szName)
    end

    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex, nX, nY)
      if nOptIndex == 2 then
        local pItem = me.GetRecycleItem(nX, nY)
        if not pItem then
          me.Msg("物品不存在！")
          return 0
        end
        me.BuyRecycleItem(pItem)
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nX, nY)
  else
    me.Msg("您的银两不足！")
  end
  return 0 -- 永远不允许拿起
end

function tbBuyCont:SwitchObj(nX, nY)
  local tbObj = self:GetObj(nX, nY)
  if not tbObj or not tbObj.pItem then
    return 0
  end

  if UiManager:GetUiState(UiManager.UIS_TRADE_BUY) == 1 then
    local nPass, szReplyMsg = Shop:CheckCanBuy(tbObj.uId)
    if nPass == 1 then
      local bOK, szMsg = me.ShopBuyItem(tbObj.uId, 1)
      if bOK ~= 1 then
        local tbMsg = {}
        tbMsg.szMsg = szMsg
        tbMsg.nOptCount = 1
        tbMsgInfo:AddMsg(szMsg, tbMsg)
      end
    else
      me.Msg(szReplyMsg)
    end
  elseif UiManager:GetUiState(UiManager.UIS_TRADE_SELL) == 1 then
  elseif UiManager:GetUiState(UiManager.UIS_TRADE_REPAIR) == 1 then
  elseif UiManager:GetUiState(UiManager.UIS_TRADE_REPAIR_EX) == 1 then
  else
    local nShiftKey = GetKeyState(UiManager.VK_SHIFT)
    if nShiftKey >= 0 then
      UiManager:OpenWindow(Ui.UI_SHOPBUY, tbObj)
    else
      local nPass, szReplyMsg = Shop:CheckCanBuy(tbObj.uId)
      if nPass == 1 then
        local bOK, szMsg = me.ShopBuyItem(tbObj.uId, 1)
        if bOK ~= 1 then
          local tbMsg = {}
          tbMsg.szMsg = szMsg
          tbMsg.nOptCount = 1
          tbMsgInfo:AddMsg(szMsg, tbMsg)
        end
      else
        me.Msg(szReplyMsg)
      end
    end
  end
  return 0 -- 永远不允许拿起
end

function uiShop:Init()
  self.m_nCurPageNumber = 0
  self.m_nCurShopState = 0
end

function uiShop:OnCreate()
  self.tbBuyCont = tbObject:RegisterContainer(self.UIGROUP, self.OBJ_BUY, self.BUY_WIDTH, self.BUY_HEIGHT, tbBuyCont)
  self.tbRecycleCont = tbObject:RegisterContainer(self.UIGROUP, self.OBJ_RECYCLE, Item.ROOM_RECYCLE_WIDTH, Item.ROOM_RECYCLE_HEIGHT, tbRecycleCont, "itemroom")
end

function uiShop:OnDestroy()
  tbObject:UnregContainer(self.tbBuyCont)
  tbObject:UnregContainer(self.tbRecycleCont)
end

function uiShop:OnSetForbidSpeRepair(nForbid)
  tbTempData.nForbidSpeRepair = nForbid
end

function uiShop:OnOpen()
  UiManager:SetUiState(UiManager.UIS_TRADE_NPC)

  local nShopId = me.GetShopId()
  local tbShopItems = me.GetShopItemList()

  for i, tbGoods in ipairs(tbShopItems) do
    Shop:CreateDemoItem(nShopId, tbGoods.nId)
  end
  Shop:ReadItemCoinUnitInfo()
  Shop:ReadValueCoinUnitInfo()

  self:UpdateShopItem()
  self.tbRecycleCont:UpdateRoom()
  Wnd_Show(self.UIGROUP, self.OBJ_BUY)
  Wnd_Hide(self.UIGROUP, self.OBJ_RECYCLE)
  Btn_Check(self.UIGROUP, self.BUTTON_PAGE_BUY, 1)
  Btn_Check(self.UIGROUP, self.BUTTON_PAGE_RECYCLE, 0)

  Wnd_SetEnable(self.UIGROUP, self.BUTTON_PEPAIREX_ALL, 1)
  if tbTempData.nForbidSpeRepair == 1 then
    Wnd_SetEnable(self.UIGROUP, self.BUTTON_PEPAIREX_ALL, 0)
    Wnd_SetEnable(self.UIGROUP, self.BUTTON_PEPAIREX, 0)
  end

  --	Wnd_SetEnable(self.UIGROUP, self.BUTTON_PEPAIR_ALL, Ui(Ui.UI_PLAYERPANEL):NeedRepair(1));
  --	Wnd_SetEnable(self.UIGROUP, self.BUTTON_PEPAIREX_ALL, Ui(Ui.UI_PLAYERPANEL):NeedRepair(2));

  UiManager:OpenWindow(Ui.UI_ITEMBOX)
end

function uiShop:OnClose()
  local nShopId = me.GetShopId()
  Shop:ClearDemoItem(nShopId)

  me.ShopExit()
  if self.tbBtn2State[self.m_nCurShopState] then -- 释放已有状态
    UiManager:ReleaseUiState(self.tbBtn2State[self.m_nCurShopState][2])
  end
  UiManager:ReleaseUiState(UiManager.UIS_TRADE_NPC)
  UiManager:CloseWindow(Ui.UI_SHOPSELL)
  UiManager:CloseWindow(Ui.UI_SHOPBUY)
  self.tbBuyCont:ClearObj()
end

function uiShop:UpdateBtnState()
  for i, tbCont in ipairs(self.tbBtn2State) do
    if UiManager:GetUiState(tbCont[2]) == 1 then
      Btn_Check(self.UIGROUP, tbCont[1], 1)
    else
      Btn_Check(self.UIGROUP, tbCont[1], 0)
    end
  end
end

function uiShop:OnButtonClick(szWnd, nParam)
  if szWnd == self.CLOSE_WINDOW_BUTTON then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.NEXT_PAGE_BUTTON then
    self.m_nCurPageNumber = self.m_nCurPageNumber + 1
    self:UpdateShopItem()
  elseif szWnd == self.PREVIOUS_PAGE_BUTTON then
    self.m_nCurPageNumber = self.m_nCurPageNumber - 1
    self:UpdateShopItem()
  elseif szWnd == self.BUTTON_PAGE_BUY then
    Wnd_Show(self.UIGROUP, self.OBJ_BUY)
    Wnd_Hide(self.UIGROUP, self.OBJ_RECYCLE)
    Btn_Check(self.UIGROUP, self.BUTTON_PAGE_BUY, 1)
    Btn_Check(self.UIGROUP, self.BUTTON_PAGE_RECYCLE, 0)
    self.m_nCurPageNumber = 0
    self:UpdateShopItem()
  elseif szWnd == self.BUTTON_PAGE_RECYCLE then
    Wnd_Show(self.UIGROUP, self.OBJ_RECYCLE)
    Wnd_Hide(self.UIGROUP, self.OBJ_BUY)
    Btn_Check(self.UIGROUP, self.BUTTON_PAGE_BUY, 0)
    Btn_Check(self.UIGROUP, self.BUTTON_PAGE_RECYCLE, 1)
    Txt_SetTxt(self.UIGROUP, self.PAGE_NUMBER_TEXT, "1/1")

  -- 全部普通修理
  elseif szWnd == self.BUTTON_PEPAIR_ALL then
    -- 先打开窗口
    UiManager:OpenWindow(Ui.UI_PLAYERPANEL)

    local tbMsg = {}
    tbMsg.szMsg = "你是否要修理全部装备？"
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex)
      if nOptIndex == 2 then
        -- Ui(Ui.UI_PLAYERPANEL):RepairAll();
        UiNotify:OnNotify(UiNotify.emUIEVENT_REPAIRALL_SEND)
      else
        UiManager:CloseWindow(Ui.UI_PLAYERPANEL)
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)

  -- 全部特殊修理
  elseif szWnd == self.BUTTON_PEPAIREX_ALL then
    -- 先打开窗口
    UiManager:OpenWindow(Ui.UI_PLAYERPANEL)

    local tbMsg = {}
    tbMsg.szMsg = "你是否要特修全部装备？"
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex)
      if nOptIndex == 2 then
        -- Ui(Ui.UI_PLAYERPANEL):RepairExAll();
        UiNotify:OnNotify(UiNotify.emUIEVENT_REPAIREXALL_SEND)
      else
        UiManager:CloseWindow(Ui.UI_PLAYERPANEL)
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
  else
    for i = 1, #self.tbBtn2State do
      if szWnd == self.tbBtn2State[i][1] then
        if i == self.m_nCurShopState then
          UiManager:ReleaseUiState(self.tbBtn2State[i][2])
          self.m_nCurShopState = 0
        else
          if self.tbBtn2State[self.m_nCurShopState] then -- 释放已有状态
            UiManager:ReleaseUiState(self.tbBtn2State[self.m_nCurShopState][2])
            Btn_Check(self.UIGROUP, self.tbBtn2State[self.m_nCurShopState][1], 0)
          end
          UiManager:SetUiState(self.tbBtn2State[i][2])
          self.m_nCurShopState = i
          if self.tbBtn2State[i][3] then
            UiManager:OpenWindow(self.tbBtn2State[i][3])
          end
        end
        Btn_Check(self.UIGROUP, szWnd, self.m_nCurShopState)
        break
      end
    end
  end
end

function uiShop:OnObjHover(szWnd, uGenre, uId, nX, nY)
  local pItem = KItem.GetItemObj(uId)
  if not pItem then
    return 0
  end
  Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, pItem.GetCompareTip(Item.TIPS_SHOP))
end

function uiShop:UpdateShopItem()
  local nShopId = me.GetShopId()
  local tbShopItems = me.GetShopItemList()
  local nItemCount = #tbShopItems
  local nPageCapacity = uiShop.BUY_WIDTH * uiShop.BUY_HEIGHT
  local nPageCount = math.floor(nItemCount / nPageCapacity)

  if self.m_nCurPageNumber < 0 then
    self.m_nCurPageNumber = 0
  elseif self.m_nCurPageNumber > nPageCount then
    self.m_nCurPageNumber = nPageCount
  end

  local nStartIndex = self.m_nCurPageNumber * nPageCapacity
  local nEndIndex = math.min(nStartIndex + nPageCapacity, nItemCount)

  self.tbBuyCont:ClearObj()
  if tbShopItems then
    for i = nStartIndex, nEndIndex - 1 do
      local nPosX = math.floor(i % nPageCapacity % uiShop.BUY_WIDTH)
      local nPosY = math.floor(i % nPageCapacity / uiShop.BUY_WIDTH)
      local nPage = math.floor(i / nPageCapacity)
      if nPage == self.m_nCurPageNumber then
        local tbObj = {}
        tbObj.nType = Ui.OBJ_TEMPITEM
        tbObj.uId = tbShopItems[i + 1].nId
        tbObj.pItem = Shop:GetDemoItem(nShopId, tbObj.uId)

        if tbObj.pItem ~= nil then
          self.tbBuyCont:SetObj(tbObj, nPosX, nPosY)
        end
      end
    end
  end

  Txt_SetTxt(self.UIGROUP, self.PAGE_NUMBER_TEXT, (self.m_nCurPageNumber + 1) .. "/" .. (nPageCount + 1))
end

function uiShop:OnNpcTrade(nParam)
  if nParam > 0 then
    UiManager:OpenWindow(Ui.UI_SHOP)
  else
    UiManager:CloseWindow(Ui.UI_SHOP)
  end
end

function uiShop:OnChangeMap()
  UiManager:CloseWindow(self.UIGROUP)
end

function uiShop:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_NPC_TRADE, self.OnNpcTrade },
    { UiNotify.emCOREEVENT_SYNC_CURRENTMAP, self.OnChangeMap },
  }
  Lib:MergeTable(tbRegEvent, self.tbBuyCont:RegisterEvent())
  Lib:MergeTable(tbRegEvent, self.tbRecycleCont:RegisterEvent())
  return tbRegEvent
end

function uiShop:RegisterMessage()
  local tbRegMsg = {}
  Lib:MergeTable(tbRegMsg, self.tbBuyCont:RegisterMessage())
  Lib:MergeTable(tbRegMsg, self.tbRecycleCont:RegisterMessage())
  return tbRegMsg
end
