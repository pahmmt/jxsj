------------------------------------------------------
--文件名		：	stallbuy.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间	：	2007-3-15
--功能描述	：	贩卖摊位中的购买界面脚本。
------------------------------------------------------

local uiStallBuy = Ui:GetClass("stallbuy")

uiStallBuy.ACCEPT_BUTTON = "BtnAccept"
uiStallBuy.CANCEL_BUTTON = "BtnCancel"
uiStallBuy.ITEM_TEXT = "TxtItem"
uiStallBuy.NUMBER_EDIT = "EdtNumber"
uiStallBuy.PRICE_TEXT = "TxtMoney"
uiStallBuy.ADD_NUMBER_BUTTON = "BtnAdd"
uiStallBuy.DEC_NUMBER_BUTTON = "BtnDec"
uiStallBuy.BUTTON_CLOSE = "BtnClose"

function uiStallBuy:Init()
  self.tbItem = {}
  self.nNumber = -1
  self.nMaxNumber = 0
  self.nCashMoney = 0
  self.nItemIdx = 0
end

function uiStallBuy:PreOpen()
  if me.IsAccountLock() ~= 0 then
    UiNotify:OnNotify(UiNotify.emCOREEVENT_SET_POPTIP, 44)
    me.Msg("你的账号处于锁定状态，无法进行该操作！")
    Account:OpenLockWindow()
    return 0
  end
  return 1
end

function uiStallBuy:OnOpen(tbItem)
  Wnd_SetFocus(self.UIGROUP, self.NUMBER_EDIT)
  self.tbItem = tbItem
  local pItem = KItem.GetItemObj(self.tbItem.uId)
  self.tbItem.szItemName = pItem.szName
  self.nCashMoney = me.nCashMoney
  self.nItemIdx = pItem.nIndex
  self.nMaxNumber = self.tbItem.nNum

  self:UpdatePanel()
end

function uiStallBuy:OnButtonClick(szWnd, nParam)
  if szWnd == self.ACCEPT_BUTTON then
    self:CheckButton()
  elseif szWnd == self.BUTTON_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.CANCEL_BUTTON then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.ADD_NUMBER_BUTTON then
    Edt_SetInt(self.UIGROUP, self.NUMBER_EDIT, self.nNumber + 1)
  elseif szWnd == self.DEC_NUMBER_BUTTON then
    Edt_SetInt(self.UIGROUP, self.NUMBER_EDIT, self.nNumber - 1)
  end
end

function uiStallBuy:CheckButton()
  local nMoney = self.tbItem.nPrice * self.nNumber
  if nMoney >= 100000 then
    local tbMsg = {}
    tbMsg.szMsg = "你确定花<color=yellow>" .. Item:FormatMoney2Style(nMoney) .. "银两(" .. Item:FormatMoney(nMoney) .. "银两)<color>购买" .. self.tbItem.szItemName .. "？"
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex, uId, nNumber)
      if nOptIndex == 2 then
        me.StallBuyItem(uId, nNumber)
        UiManager:CloseWindow(self.UIGROUP)
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, self.tbItem.uId, self.nNumber)
  else
    me.StallBuyItem(self.tbItem.uId, self.nNumber)
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiStallBuy:OnEditEnter(szWnd)
  if szWnd == self.NUMBER_EDIT then
    self:OnButtonClick(self.ACCEPT_BUTTON, 0)
  end
end

function uiStallBuy:OnEditChange(szWndName, nParam)
  if szWndName == self.NUMBER_EDIT then
    local nNum = Edt_GetInt(self.UIGROUP, self.NUMBER_EDIT)
    if nNum == self.nNumber then -- 防止死循环
      return
    end
    if nNum < 0 then
      nNum = 0
    elseif nNum > self.nMaxNumber then
      nNum = self.nMaxNumber
    end

    local nFreeCell = me.CalcFreeSameItemCountInBags(KItem.GetItemObj(self.nItemIdx))
    if nNum > nFreeCell then
      nNum = nFreeCell
    end
    self.nNumber = nNum

    local nEnable = 0
    if (self.tbItem.uId > 0) and (self.nNumber > 0) then
      nEnable = 1
    end
    Wnd_SetEnable(self.UIGROUP, self.ACCEPT_BUTTON, nEnable)

    local szPrice = Item:FormatMoney(self.tbItem.nPrice * self.nNumber)
    Txt_SetTxt(self.UIGROUP, self.PRICE_TEXT, szPrice .. "<color=blue>银两<color>")
    Edt_SetInt(self.UIGROUP, self.NUMBER_EDIT, self.nNumber)
  end
end

function uiStallBuy:UpdatePanel()
  Wnd_Show(self.UIGROUP, self.NUMBER_EDIT)
  Wnd_Show(self.UIGROUP, self.PRICE_TEXT)
  Txt_SetTxt(self.UIGROUP, self.ITEM_TEXT, self.tbItem.szItemName)
  Wnd_SetEnable(self.UIGROUP, self.ACCEPT_BUTTON, self.tbItem.nNum)

  if self.nMaxNumber == 0 then
    Txt_SetTxt(self.UIGROUP, self.ITEM_TEXT, "您的银两不足！")
    Wnd_Hide(self.UIGROUP, self.NUMBER_EDIT)
    Wnd_Hide(self.UIGROUP, self.PRICE_TEXT)
    Wnd_SetEnable(self.UIGROUP, self.ACCEPT_BUTTON, 0)
    return
  end

  Edt_SetInt(self.UIGROUP, self.NUMBER_EDIT, self.nMaxNumber)
end
