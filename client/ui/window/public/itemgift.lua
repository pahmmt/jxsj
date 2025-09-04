-----------------------------------------------------
--文件名		：	uiItemGift.lua
--创建者		：	wuwei
--创建时间		：	2007-4-10
--功能描述		：	给予界面
------------------------------------------------------

local uiItemGift = Ui:GetClass("itemgift")
local tbObject = Ui.tbLogic.tbObject
local tbMouse = Ui.tbLogic.tbMouse

uiItemGift.OBJ_GIFT = "ObjGift"
uiItemGift.TITLE_TEXT = "TxtTitle"
uiItemGift.MESSAGE_TEXT = "TxtMessage"
uiItemGift.CONFIRM_BUTTON = "BtnOk"
uiItemGift.CLOSE_WINDOW_BUTTON = "BtnClose"

local ROOM_GIFT_WIDTH = 5
local ROOM_GIFT_HEIGHT = 4

local tbGiftCont = { bUse = 0, nRoom = Item.ROOM_GIFT, bSendToGift = 1 } -- 不可使用

function tbGiftCont:CheckSwitchItem(pDrop, pPick, nX, nY)
  if self.tbGift.OnSwitch then
    return self.tbGift:OnSwitch(pPick, pDrop, nX + self.nOffsetX, nY + self.nOffsetY)
  else
    return 1
  end
end

function uiItemGift:Init()
  self.nOption = 0
end

function uiItemGift:OnCreate()
  self.tbGiftCont = tbObject:RegisterContainer(self.UIGROUP, self.OBJ_GIFT, ROOM_GIFT_WIDTH, ROOM_GIFT_HEIGHT, tbGiftCont, "itemroom")
end

function uiItemGift:OnDestroy()
  tbObject:UnregContainer(self.tbGiftCont)
end

function uiItemGift:OnOpen(tbGift)
  self.tbGiftCont.tbGift = tbGift
  UiManager:SetUiState(UiManager.UIS_ACTION_GIFT)
  self:UpdateInfo()
  self.tbGiftCont:UpdateRoom()
  if tbGift then
    Tutorial:CheckSepcialEvent("ItemGift", { tbGift._szContent })
  end
end

function uiItemGift:OnClose()
  if (self.nOption < 1) or (self.nOption > 2) then
    self.nOption = 2
  end
  me.SubmitGift(self.nOption)
  self.tbGiftCont:ClearRoom()
  UiManager:ReleaseUiState(UiManager.UIS_ACTION_GIFT)
end

function uiItemGift:OnButtonClick(szWnd, nParam)
  if szWnd == self.CONFIRM_BUTTON then
    self.nOption = 1
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.CLOSE_WINDOW_BUTTON then
    self.nOption = 2
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiItemGift:UpdateInfo()
  local tbGift = self.tbGiftCont.tbGift
  if tbGift then -- TODO:xiaoyufei 装备强化更新同时也会掉这里，但是此时tbGift为nil
    tbGift:OnUpdate()
    Txt_SetTxt(self.UIGROUP, self.TITLE_TEXT, tbGift._szTitle or "")
    TxtEx_SetText(self.UIGROUP, self.MESSAGE_TEXT, tbGift._szContent or "")
  end
end

function uiItemGift:OnSyncItem(nRoom, nX, nY)
  if nRoom == Item.ROOM_GIFT then
    self:UpdateInfo()
  end
end

function uiItemGift:StateRecvUse(szUiGroup)
  if szUiGroup == self.UIGROUP then
    return
  end

  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    return
  end
  if szUiGroup == self.UIGROUP then
    return
  end
  self.tbGiftCont:SpecialStateRecvUse()
end

function uiItemGift:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_ITEM, self.OnSyncItem, self }, -- 角色道具同步事件
    { UiNotify.emUIEVENT_OBJ_STATE_USE, self.StateRecvUse, self },
  }
  return Lib:MergeTable(tbRegEvent, self.tbGiftCont:RegisterEvent())
end

function uiItemGift:RegisterMessage()
  return self.tbGiftCont:RegisterMessage()
end
