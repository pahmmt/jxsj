local uiChatTab = Ui:GetClass("chattab")
local tbMsgChannel = Ui.tbLogic.tbMsgChannel

local tbTab2BtnCtlName = {
  [tbMsgChannel.TAB_COMMON] = "TabCommon",
  [tbMsgChannel.TAB_PRIVATE] = "TabPrivate",
  [tbMsgChannel.TAB_FRIEND] = "TabFriend",
  [tbMsgChannel.TAB_TONG] = "TabTongKin",
  [tbMsgChannel.TAB_OTHER] = "TabOther",
  [tbMsgChannel.TAB_CUSTOM] = "TabCustom",
  [tbMsgChannel.TAB_TRANSFER] = "TabTransfer", -- 全局服聊天
}

local tbSwitchTabSort = {
  [1] = tbMsgChannel.TAB_COMMON,
  [2] = tbMsgChannel.TAB_PRIVATE,
  [3] = tbMsgChannel.TAB_TONG,
  [4] = tbMsgChannel.TAB_FRIEND,
  [5] = tbMsgChannel.TAB_OTHER,
  [6] = tbMsgChannel.TAB_CUSTOM,
  [7] = tbMsgChannel.TAB_TRANSFER,
}

local tbAutoScrolPosTop = { 17, -2 } --滚屏按钮的Y位置根据跨服动态调整
local szBtnAutoScroll = "BtnAutoScrol"

local nFlashTimes = 4

local tbMenu = {
  [1] = "保存信息",
  [2] = "清空屏幕",
}

function uiChatTab:Init()
  self.nCurFlashTime = 0
  self.szActiveTabName = ""
end

function uiChatTab:OnOpen()
  local bAutoScroll = Ui(Ui.UI_MSGPAD):GetAutoScroll()
  Btn_Check(self.UIGROUP, szBtnAutoScroll, bAutoScroll)

  local tbTempData = Ui.tbLogic.tbTempData
  local szTabName = tbTempData.szCurTab
  if szTabName == "" then
    self:OnActive(tbMsgChannel.TAB_COMMON)
  else
    self:OnActive(szTabName)
  end
  self:UpdateTransferTab()
end

function uiChatTab:OnClose()
  Ui.tbLogic.tbTempData.szCurTab = self.szActiveTabName
end

function uiChatTab:OnButtonRDown(szWnd)
  for szTabName, szBtnCtlName in pairs(tbTab2BtnCtlName) do
    if szBtnCtlName == szWnd then
      DisplayPopupMenu(self.UIGROUP, szWnd, 2, 0, tbMenu[1], 1, tbMenu[2], 2)
    end
  end
end

function uiChatTab:CancelAllCheck()
  for szTabName, szBtnCtlName in pairs(tbTab2BtnCtlName) do
    Btn_Check(self.UIGROUP, szBtnCtlName, 0)
  end
end

function uiChatTab:OnActive(szTabName)
  Btn_Check(self.UIGROUP, szBtnAutoScroll, 1)
  Ui(Ui.UI_MSGPAD):SetAutoScroll(1)
  if UiManager:WindowVisible(Ui.UI_CHATNEWMSG) == 1 then
    UiManager:CloseWindow(Ui.UI_CHATNEWMSG)
  end
  self:CancelAllCheck()
  self.szActiveTabName = szTabName
  Btn_Check(self.UIGROUP, tbTab2BtnCtlName[szTabName], 1)
  UiNotify:OnNotify(UiNotify.emUIEVENT_CHAT_ONACTIVE_TAB, szTabName)
end

function uiChatTab:OnButtonClick(szWnd)
  if szWnd == tbTab2BtnCtlName[tbMsgChannel.TAB_PRIVATE] then
    self:CancelFlashPrivateTab()
  end

  if szWnd == szBtnAutoScroll then
    local bAutoScroll = Btn_GetCheck(self.UIGROUP, szBtnAutoScroll)
    Ui(Ui.UI_MSGPAD):SetAutoScroll(bAutoScroll, 1)
    return
  end

  for szTabName, szBtnCtlName in pairs(tbTab2BtnCtlName) do
    if szBtnCtlName == szWnd then
      self:OnActive(szTabName)
      break
    end
  end
end

function uiChatTab:OnMenuItemSelected(szWnd, nItemId, nParam)
  for szTabName, szBtnCtlName in pairs(tbTab2BtnCtlName) do
    if szBtnCtlName == szWnd then
      if nItemId == 1 then
        Ui(Ui.UI_MSGPAD):OnSaveTabLog(szTabName)
      elseif nItemId == 2 then
        Ui(Ui.UI_MSGPAD):ClearTabMsg(szTabName)
      end
    end
  end
end

function uiChatTab:SwitchPrivateMsgMode()
  for i, szTabName in ipairs(tbSwitchTabSort) do
    if szTabName == self.szActiveTabName then
      if i < #tbSwitchTabSort then
        self:OnActive(tbSwitchTabSort[i + 1])
      else
        self:OnActive(tbSwitchTabSort[1])
      end
      break
    end
  end
end

function uiChatTab:FlashPrivateTab()
  Img_PlayAnimation(self.UIGROUP, tbTab2BtnCtlName[tbMsgChannel.TAB_PRIVATE], 1, 200, 1, 2)
end

function uiChatTab:CancelFlashPrivateTab()
  Img_StopAnimation(self.UIGROUP)
end

function uiChatTab:OnAnimationLoop(szWnd)
  if szWnd == tbTab2BtnCtlName[tbMsgChannel.TAB_PRIVATE] then
    self.nCurFlashTime = self.nCurFlashTime + 1
    if self.nCurFlashTime >= nFlashTimes then
      Img_StopAnimation(self.UIGROUP, szWnd)
      self.nCurFlashTime = 0
    end
  end
end

function uiChatTab:UpdateTransferTab()
  --换地图时更新一次跨服聊天标签状态,同时调整滚屏按钮位置
  if Player:GetTransferStatus() == 1 then
    Wnd_Show(self.UIGROUP, tbTab2BtnCtlName[tbMsgChannel.TAB_TRANSFER])
    local nAutoScrollLeft, nAutoScrollTop = Wnd_GetPos(self.UIGROUP, szBtnAutoScroll)
    Wnd_SetPos(self.UIGROUP, szBtnAutoScroll, nAutoScrollLeft, tbAutoScrolPosTop[2])
  else
    Wnd_Hide(self.UIGROUP, tbTab2BtnCtlName[tbMsgChannel.TAB_TRANSFER])
    local nAutoScrollLeft, nAutoScrollTop = Wnd_GetPos(self.UIGROUP, szBtnAutoScroll)
    Wnd_SetPos(self.UIGROUP, szBtnAutoScroll, nAutoScrollLeft, tbAutoScrolPosTop[1])
  end
end
