-----------------------------------------------------
--文件名		：	kinrequestlist.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-7-26
--功能描述		：	家族请求列表。
------------------------------------------------------

local uiKinRepRcord = Ui:GetClass("kinreprecord")

uiKinRepRcord.BTN_CLOSE = "BtnClose"
uiKinRepRcord.TXT_RECORD = "TxtRecord"
uiKinRepRcord.TXT_PAGEINFO = "TxtPage"
uiKinRepRcord.BTN_PREPAGE = "BtnPrePage"
uiKinRepRcord.BTN_NEXTPAGE = "BtnNextPage"
uiKinRepRcord.TXT_TITLE = "TxtTitle"

function uiKinRepRcord:OnOpen(tbRecord, nRoomType, nCurPage, nMaxPage)
  self.tbRecord = tbRecord
  self.nCurPage = nCurPage
  self.nMaxPage = nMaxPage
  self.nRoomType = nRoomType
  self:UpdatePageNumber()
  self:UpdateList()
  if nRoomType == KinRepository.REPTYPE_FREE then
    Txt_SetTxt(self.UIGROUP, self.TXT_TITLE, "公共仓库记录")
  else
    Txt_SetTxt(self.UIGROUP, self.TXT_TITLE, "权限仓库记录")
  end
end

function uiKinRepRcord:UpdateList()
  local tbTypeName = { [0] = "取出了", [1] = "存入了" }
  for i = 1, 10 do
    if self.tbRecord[i] then
      local szItemName = KItem.GetNameById(self.tbRecord[i].nGenre, self.tbRecord[i].nDetailType, self.tbRecord[i].nParticularType, self.tbRecord[i].nLevel)
      local tbTempTime = os.date("*t", self.tbRecord[i].nTime)
      local szTime = string.format("[%s月%s日 %s:%s]", self:FillZeroNumber(tbTempTime.month), self:FillZeroNumber(tbTempTime.day), self:FillZeroNumber(tbTempTime.hour), self:FillZeroNumber(tbTempTime.min))
      local nType = self.tbRecord[i].nType
      if nType == 0 then
        szItemName = "<color=red>" .. szItemName .. "<color>"
      else
        szItemName = "<color=green>" .. szItemName .. "<color>"
      end
      local szCount = ""
      if self.tbRecord[i].nCount > 1 then
        szCount = "*" .. self.tbRecord[i].nCount
      end
      local szMsg = string.format("%s.%s <color=yellow>%s<color>%s%s%s", self:FillSpaceNumber(i), szTime, self.tbRecord[i].szPlayerName, tbTypeName[nType], szItemName, szCount)
      Txt_SetTxt(self.UIGROUP, self.TXT_RECORD .. i, szMsg)
    else
      Txt_SetTxt(self.UIGROUP, self.TXT_RECORD .. i, "")
    end
  end
end

function uiKinRepRcord:FillZeroNumber(nNumber)
  if nNumber < 10 then
    return "0" .. nNumber
  end
  return nNumber
end

function uiKinRepRcord:FillSpaceNumber(nNumber)
  if nNumber < 10 then
    return " " .. nNumber
  end
  return nNumber
end

function uiKinRepRcord:UpdatePageNumber()
  Wnd_SetEnable(self.UIGROUP, self.BTN_PREPAGE, (self.nCurPage == 1) and 0 or 1)
  Wnd_SetEnable(self.UIGROUP, self.BTN_NEXTPAGE, (self.nCurPage == self.nMaxPage) and 0 or 1)
  Txt_SetTxt(self.UIGROUP, self.TXT_PAGEINFO, string.format("%d/%d", self.nCurPage, self.nMaxPage))
end

function uiKinRepRcord:Update(tbRecord, nRoomType, nCurPage, nMaxPage)
  if UiManager:WindowVisible(Ui.UI_KINREPRECORD) ~= 1 then
    UiManager:OpenWindow(Ui.UI_KINREPRECORD, tbRecord, nRoomType, nCurPage, nMaxPage)
  else
    self:OnOpen(tbRecord, nRoomType, nCurPage, nMaxPage)
  end
end

function uiKinRepRcord:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_PREPAGE then
    me.CallServerScript({ "KinCmd", "ApplyViewRecord", self.nRoomType, self.nCurPage - 1 })
  elseif szWnd == self.BTN_NEXTPAGE then
    me.CallServerScript({ "KinCmd", "ApplyViewRecord", self.nRoomType, self.nCurPage + 1 })
  elseif szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end
end
