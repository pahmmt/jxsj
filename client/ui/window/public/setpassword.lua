local uiSetPassword = Ui:GetClass("setpassword")

local BTN_ENTER = "BtnEnter"
local BTN_CANCEL = "BtnCancel"
local BTN_FINDPASS = "BtnFindPass"
local BTN_CLOSE = "BtnClose"
local TXT_ORG = "TxtOrgPwd"
local EDIT_ORG = "EdtOrg"
local EDIT_NEW1 = "EdtNew1"
local EDIT_NEW2 = "EdtNew2"
local PWD_MAXLENS = 6
local TXT_NOTE = "TxtNote"
local NOTE = "请设定账号锁密码，密码只允许使用数字0-9，长度为6个字符，" .. "请一定要牢记此密码，万一忘记，请点击“申请自助解锁”按钮。"
function uiSetPassword:Init()
  --self.bFirstSetModel = 1;
  self.szCurForceEdit = ""
  self.tbPwd = { 1, 1, 1 }
  self:UpdatePwdShow()
  self.tbPos = { 100000, 100000, 100000 }
end

function uiSetPassword:OnOpen(nParam)
  if nParam == 1 then
    self.bFirstSetModel = 1
    self.szCurForceEdit = EDIT_NEW1
  else
    self.bFirstSetModel = 0
    self.szCurForceEdit = EDIT_ORG
  end

  if UiManager:WindowVisible(Ui.UI_UNLOCK) == 1 then
    UiManager:CloseWindow(Ui.UI_UNLOCK)
  end
  self:Init()
  TxtEx_SetText(self.UIGROUP, TXT_NOTE, NOTE)
  self:Update()

  self.nNameId = KLib.String2Id(tostring(me.GetNpc().dwId))

  if Player.bApplyingJiesuo == 1 then
    Btn_SetTxt(self.UIGROUP, BTN_FINDPASS, "取消自助解锁")
  else
    Btn_SetTxt(self.UIGROUP, BTN_FINDPASS, "申请自助解锁")
  end
end

function uiSetPassword:ShowMiniKeyBoard()
  self.nr1 = MathRandom(63)
  self.nr2 = MathRandom(63)
  self.nr3 = MathRandom(65535) / 65536
  UiManager:OpenWindow(Ui.UI_MINIKEYBOARD)
  local x, y = Wnd_GetPos(Ui.UI_MINIKEYBOARD, "Main")
  y = MathRandom(10) * 30
  Wnd_SetPos(Ui.UI_MINIKEYBOARD, "Main", x, y)
end

function uiSetPassword:CheckPwd()
  if self.bFirstSetModel ~= 1 then
    if self.tbPwd[1] < 1000000 or self.tbPwd[1] > 1999999 then
      me.Msg("原密码必须是6位！")
      return 0
    end
  end

  if self.tbPwd[2] < 1000000 or self.tbPwd[2] > 1999999 then
    me.Msg("新密码必须是6位！")
    return 0
  end

  if self.tbPwd[2] ~= self.tbPwd[3] then
    me.Msg("新密码两次输入不匹配！")
    return 0
  end

  return 1
end

function uiSetPassword:EncryptPsw()
  return (self.tbPwd[2] % 1000000) * 64 + 32 + self.nr2 * 67108864
end

function uiSetPassword:OnEnter()
  local bRightPwd = self:CheckPwd()
  if bRightPwd == 1 then
    local nPsw = self:EncryptPsw()
    local nDivValue = nPsw / self.nr3
    if math.abs(nDivValue * self.nr3 - nPsw) < 1 then
      nDivValue = nPsw
      self.nr3 = 1
    end
    if self.bFirstSetModel == 1 then
      me.CallServerScript({ "AccountCmd", Account.SET_PSW, 0, nDivValue, self.nr3 })
    else
      me.CallServerScript({ "AccountCmd", Account.SET_PSW, (self.tbPwd[1] * 64 + 32) / self.nr2, nDivValue, self.nr3 })
    end

    UiManager:CloseWindow(Ui.UI_MINIKEYBOARD)
    UiManager:CloseWindow(self.UIGROUP)
    return
  end
  self:Init()
end

function uiSetPassword:OnButtonClick(szWndName, nParam)
  if szWndName == BTN_ENTER then
    self:OnEnter()
  end

  if szWndName == BTN_CANCEL then
    UiManager:CloseWindow(Ui.UI_MINIKEYBOARD)
    UiManager:CloseWindow(self.UIGROUP)
  end

  if szWndName == BTN_FINDPASS then
    local tbMsg = {}
    if Player.bApplyingJiesuo == 1 then -- 取消自助解锁申请
      tbMsg.szMsg = "您确定保留账户锁吗？选择“确定”，账户锁将继续保护您的帐号安全。"
      tbMsg.nOptCount = 2
      function tbMsg:Callback(nOptIndex)
        if nOptIndex == 2 then
          me.CallServerScript({ "AccountCmd", Account.JIESUO_CANCEL })
        end
      end
      UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
      UiManager:CloseWindow(Ui.UI_MINIKEYBOARD)
      UiManager:CloseWindow(self.UIGROUP)
    else
      tbMsg.szMsg = "您确定申请取消密码保护？申请将在5天后生效。"
      tbMsg.nOptCount = 2
      function tbMsg:Callback(nOptIndex)
        if nOptIndex == 2 then
          me.CallServerScript({ "AccountCmd", Account.JIESUO_APPLY })
        end
      end
      UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
      UiManager:CloseWindow(Ui.UI_MINIKEYBOARD)
      UiManager:CloseWindow(self.UIGROUP)
    end
  end

  if szWndName == BTN_CLOSE then
    UiManager:CloseWindow(Ui.UI_MINIKEYBOARD)
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiSetPassword:OnEditFocus(szWndName)
  if szWndName == EDIT_ORG or szWndName == EDIT_NEW1 or szWndName == EDIT_NEW2 then
    self:ShowMiniKeyBoard()
    self:SetEditForce(szWndName)
  end
end

function uiSetPassword:Update()
  if self.bFirstSetModel == 1 then
    Wnd_Hide(self.UIGROUP, TXT_ORG)
    Wnd_Hide(self.UIGROUP, EDIT_ORG)
  else
    Wnd_Show(self.UIGROUP, TXT_ORG)
    Wnd_Show(self.UIGROUP, EDIT_ORG)
  end
end

function uiSetPassword:SetEditForce(szWndName)
  if self.bFirstSetModel == 1 then
    if szWndName == EDIT_ORG then
      return
    end
  end
  self.szCurForceEdit = szWndName
end

function uiSetPassword:OnClose()
  --self:Init();
end

function uiSetPassword:KeyProc(szKey)
  if self.szCurForceEdit == EDIT_ORG then
    self:ProcessPwd(1, szKey)
  end

  if self.szCurForceEdit == EDIT_NEW1 then
    self:ProcessPwd(2, szKey)
  end

  if self.szCurForceEdit == EDIT_NEW2 then
    self:ProcessPwd(3, szKey)
  end
  self:UpdatePwdShow()
end

function uiSetPassword:ProcessPwd(nPwdType, nKey)
  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    return
  end
  --local nKey = self.tbChar2Num[szKey];
  if not nKey then
    return
  end
  if nKey == 0 and self.tbPwd[nPwdType] == 1 then
    me.Msg("密码不能以0开头！")
    return
  end
  if nKey ~= -1 then
    if self.tbPwd[nPwdType] >= 1000000 or self.tbPos[nPwdType] < 1 then
      return
    end
    self.tbPwd[nPwdType] = self.tbPwd[nPwdType] * 10 + (nKey + math.floor(self.nNameId / self.tbPos[nPwdType]) % 10) % 10
    self.tbPos[nPwdType] = self.tbPos[nPwdType] / 10
  elseif self.tbPwd[nPwdType] >= 10 then
    self.tbPwd[nPwdType] = math.floor(self.tbPwd[nPwdType] / 10)
    self.tbPos[nPwdType] = self.tbPos[nPwdType] * 10
  end
end

function uiSetPassword:BuildStarByCount(nCount)
  local szStar = ""
  if nCount > 0 then
    for i = 1, nCount do
      szStar = szStar .. "*"
    end
  end
  return szStar
end

function uiSetPassword:UpdatePwdShow()
  local szPwdStar = self:BuildStarByCount(math.ceil(math.log10(1 + self.tbPwd[1])) - 1)
  Edt_SetTxt(self.UIGROUP, EDIT_ORG, szPwdStar)

  local szPwdStar = self:BuildStarByCount(math.ceil(math.log10(1 + self.tbPwd[2])) - 1)
  Edt_SetTxt(self.UIGROUP, EDIT_NEW1, szPwdStar)

  local szPwdStar = self:BuildStarByCount(math.ceil(math.log10(1 + self.tbPwd[3])) - 1)
  Edt_SetTxt(self.UIGROUP, EDIT_NEW2, szPwdStar)
end

function uiSetPassword:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emUIEVENT_MINIKEY_SEND, self.KeyProc },
  }
  return tbRegEvent
end
