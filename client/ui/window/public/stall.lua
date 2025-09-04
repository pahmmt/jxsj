-----------------------------------------------------
--文件名		：	stall.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-03-17
--功能描述		：	出售摊位界面脚本。
------------------------------------------------------

local uiStall = Ui:GetClass("stall")
local tbPreViewMgr = Ui.tbLogic.tbPreViewMgr

uiStall.CLOSE_WINDOW_BUTTON = "BtnClose"
uiStall.STALL_TITLE_TEXT = "TxtTitle"
uiStall.OTHER_STALL_CONTAINER = "ObjOtherStallItems"
uiStall.TXT_ADV = "TxtAdv"
uiStall.TXT_PLAYNAME = "TxtPlayName"

function uiStall:Init()
  self.m_szOwnerName = ""
  self.m_tbOtherItems = {}
  self.m_szTxtAdv = ""
end

function uiStall:GetItemInfo()
  self.m_szOwnerName, self.m_szTxtAdv, self.m_tbOtherItems = me.GetOtherStallInfo()
  if (not self.m_szOwnerName) or not self.m_tbOtherItems then
    UiManager:CloseWindow(self.UIGROUP)
    return
  end
  Txt_SetTxt(Ui.UI_STALL, self.STALL_TITLE_TEXT, "贩卖摊位")
  Txt_SetTxt(Ui.UI_STALL, self.TXT_ADV, self.m_szTxtAdv)
  Txt_SetTxt(Ui.UI_STALL, self.TXT_PLAYNAME, self.m_szOwnerName)
  ObjMx_Clear(Ui.UI_STALL, self.OTHER_STALL_CONTAINER)

  for i = 1, #self.m_tbOtherItems do
    ObjMx_AddObject(Ui.UI_STALL, self.OTHER_STALL_CONTAINER, Ui.CGOG_ITEM, self.m_tbOtherItems[i].uId, self.m_tbOtherItems[i].nX, self.m_tbOtherItems[i].nY)
  end
  UiManager:SetUiState(UiManager.UIS_STALL_BUY)
end

function uiStall:OnOpen()
  self:GetItemInfo()
  UiManager:OpenWindow(Ui.UI_ITEMBOX)
end

function uiStall:OnClose()
  UiManager:ReleaseUiState(UiManager.UIS_STALL_BUY)
  UiManager:CloseWindow(Ui.UI_STALLBUY)
  me.ClearStallStatus()
end

function uiStall:OnButtonClick(szWnd, nParam)
  if szWnd == self.CLOSE_WINDOW_BUTTON then
    UiManager:CloseWindow(Ui.UI_STALL)
  end
end

function uiStall:OnObjHover(szWnd, uGenre, uId, nX, nY)
  local pItem = KItem.GetItemObj(uId)
  if not pItem then
    return 0
  end
  Wnd_ShowMouseHoverInfo(Ui.UI_STALL, szWnd, pItem.GetCompareTip(Item.TIPS_STALL))
end

function uiStall:OnObjPreView(szWnd, uGenre, uId, nX, nY)
  local pItem = KItem.GetItemObj(uId)
  tbPreViewMgr:SetPreViewItem(pItem)
end

function uiStall:OnObjSwitch(szWnd, uGenre, uId, nX, nY)
  local pItem = KItem.GetItemObj(uId)
  if uId > 0 then
    for i = 1, #self.m_tbOtherItems do
      if self.m_tbOtherItems[i].uId == uId then
        UiManager:OpenWindow(Ui.UI_STALLBUY, self.m_tbOtherItems[i])
        break
      end
    end
  end
end

function uiStall:OnStallActionSuccess()
  uiStall:OnStallAction(1)
end

function uiStall:OnStallAction(nParam)
  if nParam > 0 then
    if UiManager:WindowVisible(Ui.UI_STALL) ~= 1 then
      UiManager:OpenWindow(Ui.UI_STALL)
    else
      self:OnOpen()
    end
  else
    UiManager:CloseWindow(Ui.UI_STALL)
  end
end

function uiStall:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_BUY_FROM_STALL, self.OnStallAction },
    { UiNotify.emCOREEVENT_CLOSE_STALL, self.OnStallAction },
    { UiNotify.emCOREEVENT_STALL_BUY_SUCCESS, self.OnStallActionSuccess },
  }
  return tbRegEvent
end
