-----------------------------------------------------
--文件名		：	tongrequestlist.lua
--创建者		：	zhengyuhua
--创建时间		：	2007-10-22
--功能描述		：	帮会申请列表
------------------------------------------------------

local uiTongRequestList = Ui:GetClass("tongrequestlist")

uiTongRequestList.CLOSE_WINDOW_BUTTON = "BtnClose"
uiTongRequestList.LIST_REQUEST = "LstRequest"
uiTongRequestList.BUTTON_ACCEPT = "BtnAccept"
uiTongRequestList.BUTTON_REFUSE = "BtnRefuse"

function uiTongRequestList:OnOpen()
  self:UpdateList()
end

function uiTongRequestList:UpdateList()
  Lst_Clear(self.UIGROUP, self.LIST_REQUEST)
  local tbRequestList = me.TongRequest_GetRequestList()
  if not tbRequestList then -- 为空表示无数据，不需要插列表;
    return 0
  end
  for nKey, tbTable in pairs(tbRequestList) do
    Lst_SetCell(self.UIGROUP, self.LIST_REQUEST, nKey, 1, tbTable.szMsg)
  end
end

function uiTongRequestList:OnButtonClick(szWnd, nParam)
  if szWnd == self.CLOSE_WINDOW_BUTTON then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BUTTON_ACCEPT then
    local nKey = Lst_GetCurKey(self.UIGROUP, self.LIST_REQUEST)
    if nKey == 0 then
      return 0
    end
    self:OnHandleRequest(nKey, 1)
  elseif szWnd == self.BUTTON_REFUSE then
    local nKey = Lst_GetCurKey(self.UIGROUP, self.LIST_REQUEST)
    if nKey == 0 then
      return 0
    end
    self:OnHandleRequest(nKey, 0)
  end
end

function uiTongRequestList:OnHandleRequest(nKey, nAccept)
  local tbRequest = me.TongRequest_DelRequest(nKey)
  if tbRequest then
    if tbRequest.nTimerId then --	关闭计时器
      Player:CloseTimer(tbRequest.nTimerId)
    end
  end
  me.CallServerScript({ "TongCmd", "AcceptExclusiveEvent", nKey, nAccept })
  self:UpdateList()
end
