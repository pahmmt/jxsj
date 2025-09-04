------------------------------------------------------
--文件名		：	offersell.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-3-15
--功能描述		：	收购摊位中的出售界面脚本。
------------------------------------------------------

local uiOfferSell = Ui:GetClass("offersell")

uiOfferSell.ACCEPT_BUTTON = "BtnAccept"
uiOfferSell.CANCEL_BUTTON = "BtnCancel"
uiOfferSell.ITEM_TEXT = "TxtItem"
uiOfferSell.NUMBER_EDIT = "EdtNumber"
uiOfferSell.PRICE_TEXT = "TxtMoney"
uiOfferSell.ADD_NUMBER_BUTTON = "BtnAdd"
uiOfferSell.DEC_NUMBER_BUTTON = "BtnDec"
uiOfferSell.CLOSE_BUTTON = "BtnClose"

function uiOfferSell:Init()
  self.m_tbItem = {}
  self.m_nMaxNumber = 0
end

function uiOfferSell:OnOpen(tbItem)
  Wnd_SetFocus(self.UIGROUP, self.NUMBER_EDIT)
  self.m_tbItem = tbItem

  local pItem = KItem.GetItemObj(self.m_tbItem.uId)
  if not pItem then
    return
  end

  self.m_tbItem.szItemName = pItem.szName
  self.m_nMaxNumber = me.GetCanOfferSellCountInBag(pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel, pItem.nSeries)

  self.m_nMaxNumber = math.min(self.m_tbItem.nNum, self.m_nMaxNumber)
  self.m_tbItem.nNum = self.m_nMaxNumber

  Txt_SetTxt(self.UIGROUP, self.ITEM_TEXT, self.m_tbItem.szItemName)

  self:UpdatePanel()
end

function uiOfferSell:OnButtonClick(szWnd, nParam)
  if szWnd == self.ACCEPT_BUTTON then
    me.OfferSellItem(KItem.GetItemObj(self.m_tbItem.uId), self.m_tbItem.nNum)
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.CANCEL_BUTTON or szWnd == self.CLOSE_BUTTON then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.ADD_NUMBER_BUTTON then
    Edt_SetInt(self.UIGROUP, self.NUMBER_EDIT, self.m_tbItem.nNum + 1)
  elseif szWnd == self.DEC_NUMBER_BUTTON then
    Edt_SetInt(self.UIGROUP, self.NUMBER_EDIT, self.m_tbItem.nNum - 1)
  end
end

function uiOfferSell:OnEditEnter(szWnd)
  if szWnd == self.NUMBER_EDIT then
    self:OnButtonClick(self.ACCEPT_BUTTON, 0)
  end
end

function uiOfferSell:OnEditChange(szWndName, nParam)
  if szWndName == self.NUMBER_EDIT then
    local nNum = Edt_GetInt(self.UIGROUP, self.NUMBER_EDIT)
    if nNum == self.m_tbItem.nNum then -- 防止死循环
      return
    end
    if nNum < 0 then
      nNum = 0
    end
    if nNum < self.m_nMaxNumber then
      self.m_tbItem.nNum = nNum
    else
      self.m_tbItem.nNum = self.m_nMaxNumber
    end
    self:UpdatePanel()
  end
end

function uiOfferSell:UpdatePanel()
  local szPrice = Item:FormatMoney(self.m_tbItem.nPrice * self.m_tbItem.nNum)
  Txt_SetTxt(self.UIGROUP, self.PRICE_TEXT, szPrice .. "<color=blue>银两<color>")
  Edt_SetInt(self.UIGROUP, self.NUMBER_EDIT, self.m_tbItem.nNum)

  Wnd_SetEnable(self.UIGROUP, self.ACCEPT_BUTTON, self.m_tbItem.nNum)
end
