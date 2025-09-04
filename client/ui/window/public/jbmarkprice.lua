-----------------------------------------------------
--文件名		：	jbmarkprice.lua
--创建者		：	zouying@kingsoft.net
--创建时间		：	2008-03-11
--功能描述		：	金币交易设定价格。
------------------------------------------------------

local uiJbMarkPrice = Ui:GetClass("jbmarkprice")

uiJbMarkPrice.SELLTYPE = 0
uiJbMarkPrice.BUYTYPE = 1

uiJbMarkPrice.TXTTITLE = "TxtTitle"
uiJbMarkPrice.BTNCLOSE = "BtnClose"
uiJbMarkPrice.BTNCANCEL = "BtnCancel"
uiJbMarkPrice.BTNACCEPT = "BtnAccept"
uiJbMarkPrice.EDTPRICE = "EdtPrice"
uiJbMarkPrice.EDTNUM = "EdtNumber"
uiJbMarkPrice.BTNCLOSE = "BtnClose"
uiJbMarkPrice.TXT_TOTALNUM = "TxtTotalNum"
uiJbMarkPrice.TXT_TAXNUM = "TxtTaxNum"

uiJbMarkPrice.MAXPRICE = 3000
uiJbMarkPrice.MAXNUMBER = 99999

function uiJbMarkPrice:Init()
  self.nBillType = nil
  self.nPrice = 0
  self.nCount = 0
  self.nTotal = 0
  self.nTax = 0
end

function uiJbMarkPrice:OnOpen(nParam)
  self.nBillType = nParam
  local tbInfo = me.GetExchangeInfo()
  local szTitle = ""
  self.nTax = 0
  if nParam == self.SELLTYPE then
    szTitle = "卖出金币"
    if tbInfo then
      self.nTax = tbInfo.nTax
    end
  elseif nParam == self.BUYTYPE then
    szTitle = "买入金币"
  end
  Txt_SetTxt(self.UIGROUP, self.TXTTITLE, szTitle)
  Wnd_SetFocus(self.UIGROUP, self.EDTPRICE)
  Edt_SetTxt(self.UIGROUP, self.EDTPRICE, 0)
  Edt_SetTxt(self.UIGROUP, self.EDTNUM, 0)
  Txt_SetTxt(self.UIGROUP, self.TXT_TOTALNUM, 0)
  Txt_SetTxt(self.UIGROUP, self.TXT_TAXNUM, 0)
end

function uiJbMarkPrice:OnClose() end

function uiJbMarkPrice:OnEscExclusiveWnd(szWnd)
  UiManager:CloseWindow(self.UIGROUP)
end

function uiJbMarkPrice:OnEditEnter(szWnd)
  if szWnd == self.EDT_TEXT then
    self:OnButtonClick(self.BTNACCEPT, 0)
  end
end

function uiJbMarkPrice:OnButtonClick(szWnd)
  if szWnd == self.BTNCLOSE or szWnd == self.BTNCANCEL then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTNACCEPT then
    if JbExchange.IsClose == 1 then
      local szMsg = "<color=red>现在是休市时间，不能提交。<color>"
      UiManager:OpenWindow(Ui.UI_INFOBOARD, szMsg)
      return
    end
    self:ProcessAddBill()
  end
end

function uiJbMarkPrice:ProcessAddBill()
  if self.nBillType == self.BUYTYPE and self.nTotal > me.nCashMoney then
    local szMsg = "<color=red>身上没那么多钱， 挂单失败！<color>"
    UiManager:OpenWindow(Ui.UI_INFOBOARD, szMsg)
    return
  end
  local tbMyData = me.GetPlayerBillInfo()
  if not tbMyData then
    return
  end
  if self.nBillType == self.SELLTYPE then
    local nCoinCnt = tbMyData.nCoinCount
    if self.nCount > nCoinCnt then
      local szMsg = "<color=red>身上没那么多金币， 挂单失败！<color>"
      UiManager:OpenWindow(Ui.UI_INFOBOARD, szMsg)
      return
    end
  end
  if tbMyData.nCashMoney + self.nTotal > 2000000000 then
    local szMsg = "<color=red>总价与帐户银两相加超过官府许可，挂单失败。<color>"
    UiManager:OpenWindow(Ui.UI_INFOBOARD, szMsg)
    return
  end

  local nRet = me.CallServerScript({ "JbExchangeCmd", "ApplyAddBill", self.nPrice, self.nCount, self.nBillType })
  if nRet == nil then
    local szMsg = "<color=red>挂单失败！<color>"
    UiManager:OpenWindow(Ui.UI_INFOBOARD, szMsg)
    return
  end

  me.CallServerScript({ "JbExchangeCmd", "ApplyBillList" })
  me.CallServerScript({ "JbExchangeCmd", "ApplyPlayerBillInfo" })
  UiManager:CloseWindow(self.UIGROUP)
end

function uiJbMarkPrice:OnEditChange(szWndName, nParam)
  local nCurPrice = 0
  local nCurNum = 0
  if szWndName == self.EDTNUM then
    nCurNum = Edt_GetInt(self.UIGROUP, self.EDTNUM)
    if nCurNum == self.nCount then
      return
    end
    if nCurNum < 0 then
      nCurNum = 0
    elseif nCurNum > self.MAXNUMBER then
      nCurNum = self.MAXNUMBER
    end
    self.nCount = nCurNum
  elseif szWndName == self.EDTPRICE then
    nCurPrice = Edt_GetInt(self.UIGROUP, self.EDTPRICE)
    if nCurPrice == self.nPrice then
      return
    end
    if nCurPrice < 0 then
      nCurPrice = 0
    elseif nCurPrice > self.MAXPRICE then
      nCurPrice = self.MAXPRICE
    end
    self.nPrice = nCurPrice
  end
  local nTemp = (100 - self.nTax) / 100
  self.nTotal = math.floor(self.nPrice * self.nCount * nTemp)
  local nTax = self.nPrice * self.nCount - self.nTotal
  Edt_SetTxt(self.UIGROUP, self.EDTNUM, self.nCount)
  Edt_SetTxt(self.UIGROUP, self.EDTPRICE, self.nPrice)
  local szTotal = Item:FormatMoney(self.nTotal)
  Txt_SetTxt(self.UIGROUP, self.TXT_TOTALNUM, szTotal)
  local szTax = Item:FormatMoney(nTax)
  Txt_SetTxt(self.UIGROUP, self.TXT_TAXNUM, szTax)
end
