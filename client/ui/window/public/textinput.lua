-----------------------------------------------------
--文件名		：	textinput.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-8-20
--功能描述		：	通用输入框。
------------------------------------------------------

local uiTextInput = Ui:GetClass("textinput")

uiTextInput.EDT_TEXT = "EdtText"
uiTextInput.TXT_TITLE = "TxtTitle"
uiTextInput.BTN_ACCEPT = "BtnAccept"
uiTextInput.BTN_CANCEL = "BtnCancel"
uiTextInput.BTN_CLOSE = "BtnClose"

function uiTextInput:Init()
  self.tbTable = nil -- fnAccept和fnCancel所属的Table
  self.fnAccept = nil -- 输入确认时的回调
  self.fnCancel = nil -- 输入取消时的回调
  self.nType = 2 -- 输入框类型 0:数字 1:英文 2:中英文
  self.tbRange = {} -- 可填的整数值范围（仅当编辑框类型为0时有效）
  self.tbArg = nil -- 附加参数
end

-- tbParam格式：
-- {
--    tbTable		: fnAccept和fnCancel所属的Table，即调用fnAccept和fnCancel的第一个参数
--    fnAccept		: 输入确认时的回调
--    fnCancel		: 输入取消时的回调
--    nType			: 输入框类型 0:数字 1:英文 2:中英文
--    tbRange		: 可填的整数值范围（仅当编辑框类型为0时有效）
--    nMaxLen		: 字符串长度限制
--    varDefault	: 默认值，类型为0时为数字，否则为字符串
--    szTitle		: 标题文字
-- }

function uiTextInput:OnOpen(tbParam, ...)
  Txt_SetTxt(self.UIGROUP, self.TXT_TITLE, tbParam.szTitle or "") -- 设置标题文字

  self.tbTable = tbParam.tbTable
  self.fnAccept = tbParam.fnAccept
  self.fnCancel = tbParam.fnCancel
  self.nType = tbParam.nType or 2
  self.tbArg = arg

  -- 设置整数取值范围
  self.tbRange = tbParam.tbRange or { 0, nil }
  if self.tbRange[1] and (self.tbRange[1] < 0) then
    self.tbRange[1] = 0
  end

  Edt_SetType(self.UIGROUP, self.EDT_TEXT, self.nType) -- 设置编辑框类型

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
    Edt_SetTxt(self.UIGROUP, self.EDT_TEXT, szDefault) -- 设置编辑框默认文字
  end

  Wnd_SetFocus(self.UIGROUP, self.EDT_TEXT) -- 设置编辑框默认文字
end

function uiTextInput:OnButtonClick(szWnd, nParam)
  local szText = Edt_GetTxt(self.UIGROUP, self.EDT_TEXT)
  if szWnd == self.BTN_ACCEPT then
    local bNotClose = 0
    if self.fnAccept == nil or self.tbTable == nil then
      if self.nType == 0 then
        me.CallServerScript({ "DlgCmd", "InputNum", tonumber(szText) })
      else
        me.CallServerScript({ "DlgCmd", "InputTxt", szText })
      end
    else
      bNotClose = self.fnAccept(self.tbTable, szText, unpack(self.tbArg))
    end
    if bNotClose ~= 1 then
      UiManager:CloseWindow(self.UIGROUP)
    end
  elseif (szWnd == self.BTN_CANCEL) or (szWnd == self.BTN_CLOSE) then
    local bNotClose = 0
    if self.fnCancel then
      bNotClose = self.fnCancel(self.tbTable, szText, unpack(self.tbArg))
    end
    if bNotClose ~= 1 then
      UiManager:CloseWindow(self.UIGROUP)
    end
  end
end

function uiTextInput:OnEditEnter(szWnd)
  if szWnd == self.EDT_TEXT then
    self:OnButtonClick(self.BTN_ACCEPT, 0)
  end
end

function uiTextInput:OnEditChange(szWnd)
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
