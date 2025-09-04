-----------------------------------------------------
--文件名		：	offer.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-03-17
--功能描述		：	收购摊位界面脚本。
------------------------------------------------------

local uiOffer = Ui:GetClass("offer")

uiOffer.CLOSE_WINDOW_BUTTON = "BtnClose"
uiOffer.OFFER_TITLE_TEXT = "TxtTitle"
uiOffer.OTHER_OFFER_CONTAINER = "ObjOtherOfferItems"
uiOffer.TXT_ADV = "TxtAdv"
uiOffer.TXT_PLAYNAME = "TxtPlayName"

function uiOffer:Init()
  self.m_szTxtAdv = ""
  self.m_szOwnerName = ""
  self.m_tbOtherItems = {}
  self.m_nStateHandle = 0
end

function uiOffer:OfferItemChangedCallback(nAction, uGenre, uId, nX, nY)
  self:UpdateItems()
end

function uiOffer:OnOpen()
  self:UpdateItems()
  UiManager:SetUiState(UiManager.UIS_OFFER_SELL)
  UiManager:OpenWindow(Ui.UI_ITEMBOX)
end

function uiOffer:OnClose()
  UiManager:ReleaseUiState(UiManager.UIS_OFFER_SELL)
  UiManager:CloseWindow(Ui.UI_OFFERSELL)
  me.ClearStallStatus()
end

function uiOffer:OnButtonClick(szWnd, nParam)
  if szWnd == self.CLOSE_WINDOW_BUTTON then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiOffer:UpdateItems()
  self.m_szOwnerName, self.m_szTxtAdv, self.m_tbOtherItems = me.GetOtherOfferInfo() -- TODO: xyf 这里获取道具的方式应该统一

  if (not self.m_szOwnerName) or not self.m_tbOtherItems then
    UiManager:CloseWindow(self.UIGROUP)
    return
  end

  Txt_SetTxt(self.UIGROUP, self.OFFER_TITLE_TEXT, "收购摊位")
  Txt_SetTxt(self.UIGROUP, self.TXT_ADV, self.m_szTxtAdv)
  Txt_SetTxt(self.UIGROUP, self.TXT_PLAYNAME, self.m_szOwnerName)

  ObjMx_SetContainerId(self.UIGROUP, self.OTHER_OFFER_CONTAINER, Ui.UOC_STALL_OTHER)
  ObjMx_Clear(self.UIGROUP, self.OTHER_OFFER_CONTAINER)

  for i = 1, #self.m_tbOtherItems do
    ObjMx_AddObject(self.UIGROUP, self.OTHER_OFFER_CONTAINER, Ui.CGOG_ITEM, self.m_tbOtherItems[i].uId, self.m_tbOtherItems[i].nX, self.m_tbOtherItems[i].nY)
  end
end

function uiOffer:OnObjHover(szWnd, uGenre, uId, nX, nY)
  local pItem = KItem.GetItemObj(uId)
  if not pItem then
    return 0
  end
  Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, pItem.GetCompareTip(Item.TIPS_OFFER))
end

function uiOffer:OnObjSwitch(szWnd, uGenre, uId, nX, nY)
  if uId > 0 then
    for i = 1, #self.m_tbOtherItems do
      if self.m_tbOtherItems[i].uId == uId then
        UiManager:OpenWindow(Ui.UI_OFFERSELL, self.m_tbOtherItems[i])
        break
      end
    end
  end
end

function uiOffer:OnOfferActionSuccess()
  self:OnOfferAction(1)
end

function uiOffer:OnOfferAction(nParam)
  if nParam > 0 then
    if UiManager:WindowVisible(Ui.UI_OFFER) ~= 1 then
      UiManager:OpenWindow(Ui.UI_OFFER)
    else
      self:OnOpen()
    end
  else
    UiManager:CloseWindow(Ui.UI_OFFER)
  end
end

function uiOffer:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SELL_FROM_OFFER, self.OnOfferAction },
    { UiNotify.emCOREEVENT_CLOSE_OFFER, self.OnOfferAction },
    { UiNotify.emCOREEVENT_STALL_SELL_SUCCESS, self.OnOfferActionSuccess },
  }
  return tbRegEvent
end
