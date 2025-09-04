local uiOfferMarkPrice = Ui:GetClass("offermarkprice")

uiOfferMarkPrice.ACCEPT_BUTTON = "BtnAccept"
uiOfferMarkPrice.CANCEL_BUTTON = "BtnCancel"
uiOfferMarkPrice.ITEM_TEXT = "TxtItem"
uiOfferMarkPrice.NUMBER_EDIT = "EdtNumber"
uiOfferMarkPrice.PRICE_EDIT = "EdtPrice"
uiOfferMarkPrice.ADD_NUMBER_BUTTON = "BtnAdd"
uiOfferMarkPrice.DEC_NUMBER_BUTTON = "BtnDec"
uiOfferMarkPrice.BUTTON_CLOSE = "BtnClose"
uiOfferMarkPrice.TXT_TOTALPRICE = "TxtTotalPrice"

function uiOfferMarkPrice:Init()
  self.nFreeMoney = 0
  self.nNum = 0
  self.nPrice = 0
  self.tbOfferItems = {} -- 用于记录收购的物品,包括已经标过价的,为了计算收购总额
  self.pItem = nil
end

function uiOfferMarkPrice:OnOpen(pItem)
  if not pItem then
    return 0
  end

  local nOfferMoneySum = 0
  Wnd_SetFocus(self.UIGROUP, self.NUMBER_EDIT)
  self.pItem = pItem

  local nPrice, nCount = me.GetOfferReq(self.pItem)
  self.nPrice = nPrice or 0
  self.nNum = nCount or 0

  for i = 1, #self.tbOfferItems do
    if self.tbOfferItems[i][2] ~= nil then
      nOfferMoneySum = nOfferMoneySum + self.tbOfferItems[i][2]
    end
  end

  self.nFreeMoney = me.nCashMoney - nOfferMoneySum
  self:UpdatePanel()
end

function uiOfferMarkPrice:OnButtonClick(szWnd, nParam)
  if szWnd == self.ACCEPT_BUTTON then
    if UiManager:WindowVisible(Ui.UI_OFFERBUYSETTING) ~= 1 then -- 摆摊界面已关闭，不需要做什么
      UiManager:CloseWindow(self.UIGROUP)
      return
    end
    self:OnSetItemPrice()
    UiManager:CloseWindow(self.UIGROUP)
    UiManager:OpenWindow(Ui.UI_OFFERBUYSETTING, 1)
    Ui(Ui.UI_ITEMBOX):MoveMarkPriceItem2OfferBuy()
  elseif szWnd == self.CANCEL_BUTTON or szWnd == self.BUTTON_CLOSE then
    if UiManager:WindowVisible(Ui.UI_OFFERBUYSETTING) ~= 1 then -- 摆摊界面已关闭，不需要做什么
      UiManager:CloseWindow(self.UIGROUP)
      return
    end
    UiManager:CloseWindow(self.UIGROUP)
    UiManager:OpenWindow(Ui.UI_OFFERBUYSETTING, 1)
    Ui(Ui.UI_ITEMBOX):MoveMarkPriceItem2OfferBuy()
  end
end

function uiOfferMarkPrice:OnEditEnter(szWnd)
  if (szWnd == self.NUMBER_EDIT) or (szWnd == self.PRICE_EDIT) then
    self:OnButtonClick(self.ACCEPT_BUTTON, 0)
  end
end

function uiOfferMarkPrice:UpdatePanel()
  Txt_SetTxt(self.UIGROUP, self.ITEM_TEXT, self.pItem.szName)
  Edt_SetTxt(self.UIGROUP, self.PRICE_EDIT, self.nPrice)
  Edt_SetTxt(self.UIGROUP, self.NUMBER_EDIT, self.nNum)
end

function uiOfferMarkPrice:OnEditChange(szWndName, nParam)
  if szWndName == self.NUMBER_EDIT then
    local nCurNum = Edt_GetInt(self.UIGROUP, self.NUMBER_EDIT)
    if nCurNum == self.nNum then
      return
    end
    if nCurNum < 0 then
      nCurNum = 0
    end

    if nCurNum * self.nPrice > self.nFreeMoney then -- 判断钱够不够
      nCurNum = math.floor(self.nFreeMoney / self.nPrice)
    end
    if nCurNum > 0 then --判断背包空间
      local nTotal = me.CalcFreeSameItemCountInBags(self.pItem)
      if nCurNum > nTotal then
        nCurNum = nTotal
      end
    end
    self.nNum = nCurNum
  elseif szWndName == self.PRICE_EDIT then
    local nCurPrice = Edt_GetInt(self.UIGROUP, self.PRICE_EDIT)
    if nCurPrice == self.nPrice then
      return
    end
    if nCurPrice < 0 then
      nCurPrice = 0
    end

    if nCurPrice * self.nNum > self.nFreeMoney then
      self.nPrice = math.floor(self.nFreeMoney / self.nNum)
    else
      self.nPrice = nCurPrice
    end
  end
  Txt_SetTxt(self.UIGROUP, self.TXT_TOTALPRICE, Item:FormatMoney(self.nPrice * self.nNum))
  self:UpdatePanel()
end

function uiOfferMarkPrice:OnSetItemPrice()
  local nSum = self.nPrice * self.nNum
  if self.nPrice >= 1000000000 then
    me.Msg("物品收购单价不能超过10亿两。")
    return 0
  end
  local nRetCode = me.MarkOfferItemPrice(self.pItem.nIndex, self.nPrice, self.nNum)

  if nRetCode == 1 then -- 保存本次设定
    local i = 1
    for i = 1, #self.tbOfferItems do
      if self.tbOfferItems[i][1] == self.pItem.nIndex then
        self.tbOfferItems[i][2] = nSum
        return
      end
    end
    self.tbOfferItems[i + 1] = {}
    self.tbOfferItems[i + 1][1] = self.pItem.nIndex
    self.tbOfferItems[i + 1][2] = nSum
  end
end
