-----------------------------------------------------
--文件名		：	deletekin.lua
--创建者		：	zhengyuhua
--创建时间		：	2007-10-09
--功能描述		：	删除家族界面
------------------------------------------------------

local uiDeleteKin = Ui:GetClass("deletekin")

local BUTTON_CLOSE = "BtnClose"
local BUTTON_OK = "BtnOk"
local BUTTON_CANCEL = "BtnCancel"
local LIST_KIN = "LstKin"

function uiDeleteKin:Init()
  self.tbKin = nil
  self.tbIndexToId = nil
end

function uiDeleteKin:OnOpen(tbKin, tbIndexToId)
  if (not tbKin) or not tbIndexToId then
    return 0
  end
  self.tbKin = tbKin
  self.tbIndexToId = tbIndexToId
  Lst_Clear(self.UIGROUP, LIST_KIN)
  for i in pairs(self.tbIndexToId) do
    if self.tbIndexToId[i] and self.tbKin[self.tbIndexToId[i]] then
      Lst_SetCell(self.UIGROUP, LIST_KIN, i, 0, self.tbKin[self.tbIndexToId[i]].szKinName)
    end
  end
end

function uiDeleteKin:OnButtonClick(szWnd, nParam)
  if szWnd == BUTTON_OK then
    local nIndex = Lst_GetCurKey(self.UIGROUP, LIST_KIN)
    if nIndex == 0 then
      return 0
    end
    local tbMsg = {}
    tbMsg.szMsg = "你确定要发起开除家族[" .. self.tbKin[self.tbIndexToId[nIndex]].szKinName .. "]吗？"
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex, nKinId)
      if nOptIndex == 2 then
        me.CallServerScript({ "TongCmd", "FireKin", nKinId })
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, self.tbIndexToId[nIndex])
  elseif szWnd == BUTTON_CANCEL then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == BUTTON_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end
end
