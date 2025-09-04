-- 摆摊贩卖价格设置

local uiStallMarkPrice = Ui:GetClass("stallmarkprice")

uiStallMarkPrice.TXT_ITEMNAME = "TxtItemName" -- 物品名字
uiStallMarkPrice.EDT_PRICE = "EdtPrice" -- 价格编辑
uiStallMarkPrice.TXT_ITEMNUM = "TxtItemNum" -- 物品数量
uiStallMarkPrice.TXT_TOTALPRICE = "TxtTotalPrice" -- 总价格
uiStallMarkPrice.BTN_ACCEPT = "BtnAccept" -- 确定按钮
uiStallMarkPrice.BTN_CANCEL = "BtnCancel" -- 取消按钮
uiStallMarkPrice.BTN_CLOSE = "BtnClose" -- 关闭按钮

function uiStallMarkPrice:Init()
  self.tbArg = nil -- 附加参数
  self.tbRange = {}
  self.nItemNum = 0
end

function uiStallMarkPrice:OnOpen(tbParam, ...)
  Txt_SetTxt(self.UIGROUP, self.TXT_ITEMNUM, tbParam.nNum or "")
  Txt_SetTxt(self.UIGROUP, self.TXT_ITEMNAME, tbParam.szName or "")

  self.tbArg = arg
  local nNum = tbParam.nNum and tonumber(tbParam.nNum) or 0
  self.nItemNum = nNum
  local nPrice = tbParam.nPrice and tonumber(tbParam.nPrice) or 0
  -- 设置整数取值范围
  self.tbRange = tbParam.tbRange or { 0, 1000000000 }
  if self.tbRange[1] and (self.tbRange[1] < 0) then
    self.tbRange[1] = 0
  end

  Edt_SetType(self.UIGROUP, self.EDT_PRICE, 0)
  if tbParam.nMaxLen then
    Edt_SetMaxLen(self.UIGROUP, self.EDT_PRICE, tbParam.nMaxLen) -- 设置编辑框字符串长度限制
  end
  local nMin = self.tbRange[1]
  local nMax = self.tbRange[2]
  if nMin and (nMin >= 0) and (nPrice < nMin) then
    nPrice = nMin
  end
  if nMax and (nMax >= 0) and (nPrice > nMax) then
    nPrice = nMax
  end
  Edt_SetInt(self.UIGROUP, self.EDT_PRICE, nPrice) -- 设置编辑框默认数字
  Txt_SetTxt(self.UIGROUP, self.TXT_TOTALPRICE, nPrice * nNum) -- 设置提示文字
  Wnd_SetFocus(self.UIGROUP, self.EDT_PRICE)
end

function uiStallMarkPrice:OnClose() end

function uiStallMarkPrice:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_ACCEPT then
    if UiManager:WindowVisible(Ui.UI_STALLSALESETTING) ~= 1 then -- 摆摊界面已关闭，不需要做什么
      UiManager:CloseWindow(self.UIGROUP)
      return
    end
    local nPrice = Edt_GetInt(self.UIGROUP, self.EDT_PRICE)
    local bNotClose = Ui(Ui.UI_ITEMBOX):StallMarkPrice(nPrice, unpack(self.tbArg))
    if bNotClose ~= 1 then
      UiManager:CloseWindow(self.UIGROUP) -- 如果回调返回值不为1则关闭本窗口
    end
  elseif (szWnd == self.BTN_CANCEL) or (szWnd == self.BTN_CLOSE) then
    if UiManager:WindowVisible(Ui.UI_STALLSALESETTING) ~= 1 then
      UiManager:CloseWindow(self.UIGROUP)
      return
    end
    local nPrice = Edt_GetInt(self.UIGROUP, self.EDT_PRICE)
    local bNotClose = Ui(Ui.UI_ITEMBOX):CancelStallMarkPrice(nPrice, unpack(self.tbArg))
    if bNotClose ~= 1 then
      UiManager:CloseWindow(self.UIGROUP) -- 如果回调返回值不为1则关闭本窗口
    end
  end
end

function uiStallMarkPrice:OnEditEnter(szWnd) end

function uiStallMarkPrice:OnEditChange(szWnd)
  if szWnd == self.EDT_PRICE then
    if Edt_GetTxt(self.UIGROUP, self.EDT_PRICE) == "" then
      return -- 空串时不限制数字上下限
    end
    -- 数字编辑框控制范围
    local nOrgInt = Edt_GetInt(self.UIGROUP, self.EDT_PRICE)
    local nInt = nOrgInt
    local nMin = self.tbRange[1]
    local nMax = self.tbRange[2]
    print("nMinnmax:", nMin, nMax)
    if nMin and (nMin >= 0) and (nInt < nMin) then
      nInt = nMin
    end
    if nMax and (nMax >= 0) and (nInt > nMax) then
      nInt = nMax
    end
    if nInt ~= nOrgInt then
      Edt_SetInt(self.UIGROUP, self.EDT_PRICE, nInt)
    end
    Txt_SetTxt(self.UIGROUP, self.TXT_TOTALPRICE, Item:FormatMoney(nInt * self.nItemNum))
  end
end
