-----------------------------------------------------
--文件名		：	tongdispense.lua
--创建者		：	zhengyuhua
--创建时间		：	2007-10-15
--功能描述		：	帮会分发资金界面
------------------------------------------------------

local uiTongDispense = Ui:GetClass("tongdispense")

uiTongDispense.EDIT_FUN_PERSON = "EdtFunPerson"
uiTongDispense.TEXT_FUN_TOTAL = "TxtFunTotal"
uiTongDispense.BUTTON_OK = "BtnOk"
uiTongDispense.BUTTON_CANCEL = "BtnCancel"
uiTongDispense.BUTTON_CLOSE = "BtnClose"
uiTongDispense.LIST_CROWD = "LstCrowdList"

function uiTongDispense:OnOpen(tbParam)
  self.tbParam = tbParam
  self.nPerson = 0
  Lst_Clear(self.UIGROUP, self.LIST_CROWD)
  for i = 1, 5 do
    Lst_SetCell(self.UIGROUP, self.LIST_CROWD, i, 1, Tong.tbCrowdTitle[i] .. "（" .. self.tbParam[i] .. "人）")
  end
  local nKey = Lst_GetCurKey(self.UIGROUP, self.LIST_CROWD)
  if nKey == 0 then
    self.nPerson = 0
  else
    self.nPerson = self.tbParam[nKey]
  end
  Txt_SetTxt(self.UIGROUP, self.TEXT_FUN_TOTAL, "0")
  Edt_SetInt(self.UIGROUP, self.EDIT_FUN_PERSON, 0)
end

function uiTongDispense:OnEditChange(szWnd, nParam)
  if szWnd == self.EDIT_FUN_PERSON then
    local nFunPerson = Edt_GetInt(self.UIGROUP, self.EDIT_FUN_PERSON)
    Txt_SetTxt(self.UIGROUP, self.TEXT_FUN_TOTAL, tostring(nFunPerson * self.nPerson))
  end
end

function uiTongDispense:OnButtonClick(szWnd, nParam)
  if (szWnd == self.BUTTON_CANCEL) or (szWnd == self.BUTTON_CLOSE) then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BUTTON_OK then
    local nFunPerson = Edt_GetInt(self.UIGROUP, self.EDIT_FUN_PERSON)
    local nKey = Lst_GetCurKey(self.UIGROUP, self.LIST_CROWD)
    if (nKey == 0) or not nFunPerson then
      return 0
    end
    local tbMsg = {}
    tbMsg.nOptCount = 2
    if self.tbParam.nType == Tong.DISPENSE_FUND then
      tbMsg.szMsg = "你确定给群体[" .. Tong.tbCrowdTitle[nKey] .. "]每人发放资金" .. nFunPerson .. "吗？"
      function tbMsg:Callback(nOptIndex, nKey, nFunPerson)
        if nOptIndex == 2 then
          me.CallServerScript({ "TongCmd", "DispenseFund", nKey, nFunPerson })
        end
      end
    elseif self.tbParam.nType == Tong.DISPENSE_OFFER then
      tbMsg.szMsg = "你确定要给群体[" .. Tong.tbCrowdTitle[nKey] .. "]每人发放贡献度" .. nFunPerson .. "点吗？"
      function tbMsg:Callback(nOptIndex, nKey, nFunPerson)
        if nOptIndex == 2 then
          --					me.CallServerScript({ "TongCmd", "DispenseOffer", nKey, nFunPerson });
        end
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nKey, nFunPerson)
  end
end

function uiTongDispense:OnListSel(szWnd, nParam)
  if szWnd == self.LIST_CROWD then
    if nParam == 0 then
      self.nPerson = 0
      return 0
    end
    self.nPerson = self.tbParam[nParam]
    self:OnEditChange(self.EDIT_FUN_PERSON, 0)
  end
end
