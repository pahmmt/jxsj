-- 通用带文字条的文字输入框

local uiTextInput_Banner = Ui:GetClass("textinput_banner")

uiTextInput_Banner.EDT_TEXT = "EdtText" -- 文字编辑框
uiTextInput_Banner.TXT_TITLE = "TxtTitle" -- 标题文字
uiTextInput_Banner.TXT_BANNER = "TxtBanner" -- 栏目文字
uiTextInput_Banner.TXT_TIP = "TxtTip" -- 提示文字
uiTextInput_Banner.BTN_ACCEPT = "BtnAccept" -- 确定按钮
uiTextInput_Banner.BTN_CANCEL = "BtnCancel" -- 取消按钮
uiTextInput_Banner.BTN_CLOSE = "BtnClose" -- 关闭按钮
uiTextInput_Banner.BTN_INC = "BtnInc" -- 递增按钮
uiTextInput_Banner.BTN_DEC = "BtnDec" -- 递减按钮

function uiTextInput_Banner:Init()
  self.tbTable = nil -- fnAccept和fnCancel所属的Table
  self.fnAccept = nil -- 输入确认时的回调
  self.fnCancel = nil -- 输入取消时的回调
  self.nType = 2 -- 编辑框类型 0:数字 1:英文 2:中英文
  self.bIncDec = 0 -- 具有加减按钮（仅当编辑框类型为0时有效）
  self.tbRange = {} -- 可填的整数值范围（仅当编辑框类型为0时有效）
  self.tbArg = nil -- 附加参数
end

function uiTextInput_Banner:OnOpen(tbParam, ...)
  Txt_SetTxt(self.UIGROUP, self.TXT_TITLE, tbParam.szTitle or "") -- 设置标题文字
  Txt_SetTxt(self.UIGROUP, self.TXT_BANNER, tbParam.szBanner or "") -- 设置栏目文字
  Txt_SetTxt(self.UIGROUP, self.TXT_TIP, tbParam.szTip or "") -- 设置提示文字

  self.tbTable = tbParam.tbTable
  self.fnAccept = tbParam.fnAccept
  self.fnCancel = tbParam.fnCancel
  self.nType = tbParam.nType or 2 -- 设置编辑框数据类型
  self.bIncDec = (self.nType == 0) and tbParam.bIncDec
  self.tbArg = arg

  -- 设置整数取值范围
  self.tbRange = tbParam.tbRange or { 0, nil }
  if self.tbRange[1] and (self.tbRange[1] < 0) then
    self.tbRange[1] = 0
  end

  Edt_SetType(self.UIGROUP, self.EDT_TEXT, self.nType)

  if tbParam.nMaxLen then
    Edt_SetMaxLen(self.UIGROUP, self.EDT_TEXT, tbParam.nMaxLen) -- 设置编辑框字符串长度限制
  end

  if self.nType == 0 then
    local nDefalut = tbParam.varDefault and tonumber(tbParam.varDefault) or 0
    local nMin = self.tbRange[1]
    local nMax = self.tbRange[2]
    if nMin and (nMin >= 0) and (nDefalut < nMin) then
      nDefalut = nMin
    end
    if nMax and (nMax >= 0) and (nDefalut > nMax) then
      nDefalut = nMax
    end
    Edt_SetInt(self.UIGROUP, self.EDT_TEXT, nDefalut) -- 设置编辑框默认数字
  else
    local szDefault = tbParam.varDefault and tostring(tbParam.varDefault) or ""
    Edt_SetTxt(self.UIGROUP, self.EDT_TEXT, tbParam.szDefault) -- 设置编辑框默认文字
  end

  -- 显示或隐藏加减按钮
  if self.bIncDec == 1 then
    Wnd_Show(self.UIGROUP, self.BTN_INC)
    Wnd_Show(self.UIGROUP, self.BTN_DEC)
  else
    Wnd_Hide(self.UIGROUP, self.BTN_INC)
    Wnd_Hide(self.UIGROUP, self.BTN_DEC)
  end

  Wnd_SetFocus(self.UIGROUP, self.EDT_TEXT)
end

function uiTextInput_Banner:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_ACCEPT then
    local bNotClose = 0
    if self.fnAccept then
      if self.nType == 0 then
        local nInt = Edt_GetInt(self.UIGROUP, self.EDT_TEXT)
        bNotClose = self.fnAccept(self.tbTable, nInt, unpack(self.tbArg))
      else
        local szText = Edt_GetTxt(self.UIGROUP, self.EDT_TEXT)
        bNotClose = self.fnAccept(self.tbTable, szText, unpack(self.tbArg))
      end
    end
    if bNotClose ~= 1 then
      UiManager:CloseWindow(self.UIGROUP) -- 如果回调返回值不为1则关闭本窗口
    end
  elseif (szWnd == self.BTN_CANCEL) or (szWnd == self.BTN_CLOSE) then
    local bNotClose = 0
    if self.fnCancel then
      if self.nType == 0 then
        local nInt = Edt_GetInt(self.UIGROUP, self.EDT_TEXT)
        bNotClose = self.fnCancel(self.tbTable, nInt, unpack(self.tbArg))
      else
        local szText = Edt_GetTxt(self.UIGROUP, self.EDT_TEXT)
        bNotClose = self.fnCancel(self.tbTable, szText, unpack(self.tbArg))
      end
    end
    if bNotClose ~= 1 then
      UiManager:CloseWindow(self.UIGROUP) -- 如果回调返回值不为1则关闭本窗口
    end
  elseif szWnd == self.BTN_INC then
    local nInt = Edt_GetInt(self.UIGROUP, self.EDT_TEXT) + 1
    local nMax = self.tbRange[2]
    if (not nMax) or (nMax < 0) or (nInt <= nMax) then
      Edt_SetInt(self.UIGROUP, self.EDT_TEXT, nInt)
    end
  elseif szWnd == self.BTN_DEC then
    local nInt = Edt_GetInt(self.UIGROUP, self.EDT_TEXT) - 1
    local nMin = self.tbRange[1]
    if (not nMin) or (nMin < 0) or (nInt >= nMin) then
      Edt_SetInt(self.UIGROUP, self.EDT_TEXT, nInt)
    end
  end
end

function uiTextInput_Banner:OnEditEnter(szWnd)
  if szWnd == self.EDT_TEXT then
    self:OnButtonClick(self.BTN_ACCEPT, 0)
  end
end

function uiTextInput_Banner:OnEditChange(szWnd)
  if szWnd == self.EDT_TEXT then
    if self.nType ~= 0 then
      return
    end
    if Edt_GetTxt(self.UIGROUP, self.EDT_TEXT) == "" then
      return -- 空串时不限制数字上下限
    end
    -- 数字编辑框控制范围
    local nOrgInt = Edt_GetInt(self.UIGROUP, self.EDT_TEXT)
    local nInt = nOrgInt
    local nMin = self.tbRange[1]
    local nMax = self.tbRange[2]
    if nMin and (nMin >= 0) and (nInt < nMin) then
      nInt = nMin
    end
    if nMax and (nMax >= 0) and (nInt > nMax) then
      nInt = nMax
    end
    if nInt ~= nOrgInt then
      Edt_SetInt(self.UIGROUP, self.EDT_TEXT, nInt)
    end
  end
end
