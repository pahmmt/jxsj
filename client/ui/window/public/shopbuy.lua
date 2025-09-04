------------------------------------------------------
--文件名		：	shopbuy.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间	：	2007-3-27
--功能描述	：	商店中的购买界面脚本。
------------------------------------------------------

local tbShopBuy = Ui:GetClass("shopbuy")

local BTN_ACCEPT = "BtnAccept"
local BTN_CANCEL = "BtnCancel"
local TXT_ITEM = "TxtItem"
local EDT_NUMBER = "EdtNumber"
local TXT_PRICE = "TxtMoney"
local BTN_ADD = "BtnAdd"
local BTN_DEC = "BtnDec"
local BTN_CLOSE = "BtnClose"

function tbShopBuy:Init()
  self.nPrice = 0
  self.szItemName = 0
  self.nNum = 0
  self.nMaxNumber = 0
  self.szUnit = "" -- 货币单位（例如：“个五行魂石”）
  self.szUnitName = "" -- 货币单位的名称（例如：“五行魂石”）
end

function tbShopBuy:OnOpen(tbObj)
  Wnd_SetFocus(self.UIGROUP, EDT_NUMBER)
  self.tbObj = tbObj
  self.szItemName = tbObj.pItem.szName
  local tbGoods = me.GetShopBuyItemInfo(tbObj.uId)
  self.nPrice = tbGoods.nPrice
  if (not self.nPrice) or not self.szItemName then
    me.Msg("获取物品价格失败！")
    return 0
  end

  local pItem = self.tbObj.pItem
  if me.CalcFreeSameItemCountInBags(pItem) < 1 then
    self.nNum = 0
  else
    self.nNum = 1
  end

  local nCurrencyType = me.nCurrencyType

  --初始化货币单位
  self.szUnit = Item.tbTipPriceUnit[nCurrencyType]
  if nCurrencyType == 3 then
    self.szUnitName = Shop:GetItemCoinUnit(tbGoods.ItemCoinIndex)
    self.szUnit = string.format(self.szUnit, self.szUnitName)
  elseif nCurrencyType == 10 then
    self.szUnitName = Shop:GetValueCoinUnit(tbGoods.ValueCoinIndex)
    self.szUnit = string.format(self.szUnit, self.szUnitName)
  else
    self.szUnitName = self.szUnit
  end

  local nCurrency = 0
  -- TODO: xyf 获得特定类型的货币数量
  if nCurrencyType == 1 then
    nCurrency = me.nCashMoney
  elseif nCurrencyType == 3 then
    local nCoinItemIndex = me.GetItemCoinIndex(tbObj.uId)
    nCurrency = me.GetCashCoin(nCoinItemIndex) --金币替代物品
  elseif nCurrencyType == 4 then
    nCurrency = me.GetTask(2001, 9)
  elseif nCurrencyType == 7 then
    nCurrency = me.GetBindMoney()
  elseif nCurrencyType == 8 then
    nCurrency = me.GetMachineCoin()
  elseif nCurrencyType == 10 then
    local nValueCoinIndex = me.GetValueCoinIndex(tbObj.uId)
    nCurrency = me.GetValueCoin(nValueCoinIndex) -- 数值货币
  end

  self.nMaxNumber = math.floor(nCurrency / self.nPrice)
  if nCurrencyType == 9 then -- 客户端不知道帮会建设资金
    self.nMaxNumber = 9999999 -- TODO:不限制个数
  end
  self:UpdatePanel()
  --新手任务指引
  Tutorial:CheckSepcialEvent("shopbuy", { self.szItemName })
end

function tbShopBuy:OnButtonClick(szWnd, nParam)
  local pItem = self.tbObj.pItem
  if szWnd == BTN_ACCEPT then
    if pItem then
      if Shop:CheckCanBuy(self.tbObj.uId) == 1 then
        me.ShopBuyItem(self.tbObj.uId, self.nNum)
      end
      UiManager:CloseWindow(self.UIGROUP)
    end
  elseif szWnd == BTN_CANCEL then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == BTN_ADD then
    Edt_SetInt(self.UIGROUP, EDT_NUMBER, self.nNum + 1)
  elseif szWnd == BTN_DEC then
    Edt_SetInt(self.UIGROUP, EDT_NUMBER, self.nNum - 1)
  elseif szWnd == BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function tbShopBuy:OnEditChange(szWndName, nParam)
  if szWndName == EDT_NUMBER then
    local nNum = Edt_GetInt(self.UIGROUP, EDT_NUMBER)
    if nNum == self.nNum then -- 防止死循环
      return
    end

    if nNum < 0 then
      nNum = 0
    elseif nNum > self.nMaxNumber then
      nNum = self.nMaxNumber
    end
    local pItem = self.tbObj.pItem
    local nCap = me.CalcFreeSameItemCountInBags(pItem)
    if nNum > nCap then
      nNum = nCap
    end

    self.nNum = nNum
    self:UpdatePanel()
  end
end

function tbShopBuy:OnEditEnter(szWnd)
  if szWnd == EDT_NUMBER then
    self:OnButtonClick(BTN_ACCEPT, 0)
  end
end

function tbShopBuy:UpdatePanel()
  Txt_SetTxt(self.UIGROUP, TXT_ITEM, self.szItemName)
  Edt_SetInt(self.UIGROUP, EDT_NUMBER, self.nNum)
  local szPrice = Item:FormatMoney(self.nPrice * self.nNum)

  --增加显示价格单位

  Txt_SetTxt(self.UIGROUP, TXT_PRICE, szPrice .. "<color=blue>" .. self.szUnit .. "<color>")

  Wnd_Show(self.UIGROUP, EDT_NUMBER)
  Wnd_Show(self.UIGROUP, TXT_PRICE)
  Wnd_SetEnable(self.UIGROUP, BTN_ACCEPT, self.nNum)

  if self.nMaxNumber == 0 then
    Txt_SetTxt(self.UIGROUP, TXT_ITEM, string.format("您的%s不足！", self.szUnitName))
    Wnd_Hide(self.UIGROUP, EDT_NUMBER)
    Wnd_Hide(self.UIGROUP, TXT_PRICE)
    Wnd_SetEnable(self.UIGROUP, BTN_ACCEPT, 0)
    return
  end

  local nEnable = 0
  if self.nNum > 0 then
    nEnable = 1
  end
  Wnd_SetEnable(self.UIGROUP, BTN_ACCEPT, nEnable)
end

function tbShopBuy:OnMoneyChanged()
  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    return
  end
  UpdatePanel()
end

function tbShopBuy:OnChangeMap()
  UiManager:CloseWindow(self.UIGROUP)
end

function tbShopBuy:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_MONEY_CHANGED, self.OnMoneyChanged },
    { UiNotify.emCOREEVENT_SYNC_CURRENTMAP, self.OnChangeMap },
  }
  return tbRegEvent
end
