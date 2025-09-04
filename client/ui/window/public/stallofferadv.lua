-----------------------------------------------------
--文件名		：	stallofferadv.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-3-15
--功能描述		：	设置贩售广告。
------------------------------------------------------

local uiStallOfferAdv = Ui:GetClass("stallofferadv")

uiStallOfferAdv.ADV_Edit = "EdtAdvertisement"
uiStallOfferAdv.ACCEPT_BUTTON = "BtnAccept"
uiStallOfferAdv.CANCEL_BUTTON = "BtnCancel"
uiStallOfferAdv.CLOSE_BUTTON = "BtnClose"

function uiStallOfferAdv:Init()
  self.m_szAdvContent = ""
end

function uiStallOfferAdv:OnOpen()
  Wnd_SetFocus(self.UIGROUP, self.ADV_Edit)
  self.m_szAdvContent = me.GetAdv()
  Edt_SetTxt(self.UIGROUP, self.ADV_Edit, self.m_szAdvContent)
end

function uiStallOfferAdv:OnButtonClick(szWnd, nParam)
  if szWnd == self.ACCEPT_BUTTON then
    local szNewAdv = Edt_GetTxt(self.UIGROUP, self.ADV_Edit)
    if not szNewAdv then
      return
    end
    if szNewAdv ~= self.m_szAdvContent then
      me.SetAdv(szNewAdv)
    end
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.CANCEL_BUTTON then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.CLOSE_BUTTON then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiStallOfferAdv:OnEditEnter(szWnd)
  if szWnd == self.ADV_Edit then
    self:OnButtonClick(self.ACCEPT_BUTTON, 0)
  end
end

function uiStallOfferAdv:OnInputStallAdv(nParam)
  UiManager:OpenWindow(Ui.UI_STALLOFFERADV)
end

function uiStallOfferAdv:OnInputOfferAdv(nParam)
  UiManager:OpenWindow(Ui.UI_STALLOFFERADV)
end

function uiStallOfferAdv:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_STALL_INPUT_ADV, self.OnInputStallAdv },
    { UiNotify.emCOREEVENT_OFFER_INPUT_ADV, self.OnInputOfferAdv },
  }
  return tbRegEvent
end
