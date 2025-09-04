-------------------------------------------------------
-- 文件名　：chatfilter.lua
-- 创建者　：wangzhiguang
-- 创建时间：2011-06-17
-- 文件描述：客户端对收到的聊天信息进行过滤
-------------------------------------------------------

local uiChatFilter = Ui:GetClass("chatfilter")

uiChatFilter.BTN_CLOSE = "BtnClose"
uiChatFilter.BTN_PRE_PAGE = "BtnLeft"
uiChatFilter.BTN_NEXT_PAGE = "BtnRight"
uiChatFilter.BTN_ADD_FILTER = "BtnAddFilter"
uiChatFilter.TEXT_CUR_PAGE = "TxtPage"
uiChatFilter.LIST_FILTER = "ListFilter"

uiChatFilter.BTN_NEAR = "BtnNear"
uiChatFilter.BTN_WORLD = "BtnWorld"
uiChatFilter.BTN_CITY = "BtnCity"
uiChatFilter.BTN_PRIVATE = "BtnPrivate"
uiChatFilter.BTN_FACTION = "BtnFaction"
uiChatFilter.BTN_KIN_TONG = "BtnKinTong"

uiChatFilter.tbButton2ChatType = {
  [uiChatFilter.BTN_NEAR] = { ChatFilter.CHAT_TYPE_NEAR, "近" },
  [uiChatFilter.BTN_WORLD] = { ChatFilter.CHAT_TYPE_WORLD, "公" },
  [uiChatFilter.BTN_CITY] = { ChatFilter.CHAT_TYPE_CITY, "城" },
  [uiChatFilter.BTN_PRIVATE] = { ChatFilter.CHAT_TYPE_PRIVATE, "私" },
  [uiChatFilter.BTN_FACTION] = { ChatFilter.CHAT_TYPE_FACTION, "派" },
  [uiChatFilter.BTN_KIN_TONG] = { ChatFilter.CHAT_TYPE_KIN_TONG, "帮" },
}

uiChatFilter.COUNT_PER_PAGE = 19
uiChatFilter.MAX_FILTER_LENGTH = 16
uiChatFilter.nCurrentPage = 1

function uiChatFilter:OnOpen()
  self.nCurrentPage = 1
  self.tbFilter = {}
  self:Render()
end

function uiChatFilter:Render()
  Txt_SetTxt(self.UIGROUP, self.TEXT_CUR_PAGE, self.nCurrentPage)
  self:UpdateFilterList()
  self:UpdateFilteredCount()
end

function uiChatFilter:UpdateFilterList()
  Lst_Clear(self.UIGROUP, self.LIST_FILTER)
  local tbFilter = ChatFilter:GetFilterList()
  local nStart = (self.nCurrentPage - 1) * self.COUNT_PER_PAGE + 1
  local nEnd = nStart + self.COUNT_PER_PAGE - 1
  local szFilter, nIndex
  for i = nStart, nEnd do
    szFilter = tbFilter[i]
    if szFilter and #szFilter > 0 then
      nIndex = i % self.COUNT_PER_PAGE
      if nIndex == 0 then
        nIndex = self.COUNT_PER_PAGE
      end
      self.tbFilter[nIndex] = szFilter
      if #szFilter > self.MAX_FILTER_LENGTH then
        szFilter = string.sub(szFilter, 1, self.MAX_FILTER_LENGTH - 2) .. ".."
      end
      Lst_SetCell(self.UIGROUP, self.LIST_FILTER, nIndex, 1, szFilter)
    else
      break
    end
  end
end

function uiChatFilter:UpdateFilteredCount()
  local nCount, nChatType, szPrefix, szBtnText, bEnableBtn
  for szWndBtn, tbInner in pairs(self.tbButton2ChatType) do
    nChatType = tbInner[1]
    szPrefix = tbInner[2]
    nCount = ChatFilter:GetFilteredCount(nChatType)
    if nCount > 0 then
      szBtnText = string.format("%s %d", szPrefix, nCount)
      bEnableBtn = 1
    else
      szBtnText = szPrefix
      bEnableBtn = 0
    end
    Btn_SetTxt(self.UIGROUP, szWndBtn, szBtnText)
    Wnd_SetEnable(self.UIGROUP, szWndBtn, bEnableBtn)
  end
end

function uiChatFilter:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_PRE_PAGE then
    if self.nCurrentPage == 1 then
      return
    end
    self.nCurrentPage = self.nCurrentPage - 1
    self:Render()
  elseif szWnd == self.BTN_NEXT_PAGE then
    local tbFilter = ChatFilter:GetFilterList()
    if self.nCurrentPage * self.COUNT_PER_PAGE >= #tbFilter then
      return
    end
    self.nCurrentPage = self.nCurrentPage + 1
    self:Render()
  elseif szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_ADD_FILTER then
    ChatFilter:OpenInputDialog(szChatText)
  else
    local tbInner = self.tbButton2ChatType[szWnd]
    if tbInner then
      local nChatType = tbInner[1]
      ChatFilter:ShowFilterHistory(nChatType)
    end
  end
end

function uiChatFilter:OnListSel(szWnd, nParam)
  if nParam == 0 then
    return 0
  end
end

function uiChatFilter:OnListRClick(szWnd, nParam)
  if nParam == 0 then
    return
  end
  if szWnd == self.LIST_FILTER then
    DisplayPopupMenu(self.UIGROUP, szWnd, 1, nParam, "删除")
  end
end

function uiChatFilter:OnMenuItemSelected(szWnd, nItemId, nItemIndex)
  if szWnd ~= self.LIST_FILTER or nItemId == 65535 then
    return
  end
  local szFilter = self.tbFilter[nItemIndex]
  ChatFilter:RemoveFilter(szFilter)
  self:UpdateFilterList()
end

function uiChatFilter:OnListOver(szWnd, nItemIndex)
  if szWnd == self.LIST_FILTER and nItemIndex > 0 then
    local szFilter = self.tbFilter[nItemIndex]
    if #szFilter > self.MAX_FILTER_LENGTH then
      Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, "<color=yellow>过滤关键字：<color>", "\n" .. szFilter)
    end
  end
end
