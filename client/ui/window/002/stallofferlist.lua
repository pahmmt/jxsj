local uiStallSaleList = Ui:GetClass("stallofferlist")

local BUTTON_CLOSE = "BtnClose"
local LIST_ITEM = "LstItem"

function uiStallSaleList:Init()
  self.tbItemList = nil
end

function uiStallSaleList:OnOpen(tbList)
  if not tbList then
    return 0
  end
  self.tbItemList = tbList
  Lst_Clear(self.UIGROUP, LIST_ITEM)
  for i = 1, #self.tbItemList do
    Lst_SetCell(self.UIGROUP, LIST_ITEM, i, 0, self.tbItemList[i])
  end
end

function uiStallSaleList:OnButtonClick(szWnd, nParam)
  if szWnd == BUTTON_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end
end
