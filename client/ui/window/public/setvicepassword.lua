local uiSetVicePassword = Ui:GetClass("setvicepassword")

local BTN_ENTER = "BtnEnter"
local BTN_CANCEL = "BtnCancel"
local BTN_CLOSE = "BtnClose"
local EDIT_ORG = "EdtOrg"
local EDIT_NEW1 = "EdtNew1"
local EDIT_NEW2 = "EdtNew2"
local TXT_NOTE = "TxtNote"
local NOTE = "使用金山通行证登陆游戏可对副密码进行设定。副密码由数字、字母及常见符号构成，最短8字符，最长为32字符，且不能与主密码相同。"
local tbMessageOnEnter = {
  [0] = "副密码设置成功！",
  [1] = "原密码错误，请重新输入！",
  [2] = "两次输入的副密码不一致！",
  [3] = "副密码长度错误！长度最短为8，最长为32。",
  [4] = "新密码和原密码不能相同！",
}

function uiSetVicePassword:OnOpen(nParam)
  self:Reset()
end

function uiSetVicePassword:Reset()
  Edt_SetTxt(self.UIGROUP, EDIT_ORG, "")
  Edt_SetTxt(self.UIGROUP, EDIT_NEW1, "")
  Edt_SetTxt(self.UIGROUP, EDIT_NEW2, "")
  TxtEx_SetText(self.UIGROUP, TXT_NOTE, NOTE)
end

-- 点了确认后的处理
function uiSetVicePassword:OnEnter()
  local nRetCode, szVicePassword = CheckSetVicePasswordInput(self.UIGROUP, EDIT_ORG, EDIT_NEW1, EDIT_NEW2)

  if nRetCode == 0 then
    me.CallServerScript({ "ProcessVicePasswordSetting", szVicePassword }) -- 输入合法，到服务器修改副密码
  else
    Dialog:Say(tbMessageOnEnter[nRetCode])
  end

  self:Reset()
end

function uiSetVicePassword:OnButtonClick(szWndName, nParam)
  if szWndName == BTN_ENTER then
    self:OnEnter()
  elseif szWndName == BTN_CANCEL then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWndName == BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiSetVicePassword:OnClose()
  self:Reset()
end
