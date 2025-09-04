local UiUnLock = Ui:GetClass("unlock")

local BTN_ENTER = "BtnEnter"
local BTN_CANCEL = "BtnCancel"
local BTN_FINDPASS = "BtnFindPass"
local EDIT_PWD = "EdtPwd"
local BTN_CLOSE = "BtnClose"
local PWD_MAXLENS = 6
local TXT_NOTE = "TxtNote"
local TXT_PWD = "TxtPwd"
local NOTE = "请输入解锁密码，如果忘记密码，请点击“申请自助解锁”按钮。"
local CARD_POS_NOTE = "请输入下方黄字代码在密保卡上对应位置的数字。如显示G5H4D2，则顺序输入G5、H4、D2三个位置的数字即可。"

function UiUnLock:Init()
  self.nPwd = 1
  self.nPos = 100000
  self:UpdatePwdShow()
end

function UiUnLock:OnOpen()
  if UiManager:WindowVisible(Ui.UI_SETPASSWORD) == 1 then
    UiManager:CloseWindow(Ui.UI_SETPASSWORD)
  end
  self:Init()
  if me.GetPasspodMode() == Account.PASSPODMODE_ZPMATRIX then
    local szMatrixPosition = me.GetMatrixPosition()
    TxtEx_SetText(self.UIGROUP, TXT_NOTE, CARD_POS_NOTE)
    TxtEx_SetText(self.UIGROUP, TXT_PWD, "    <color=yellow>" .. szMatrixPosition .. "<color>")
  else
    TxtEx_SetText(self.UIGROUP, TXT_NOTE, NOTE)
    TxtEx_SetText(self.UIGROUP, TXT_PWD, "    <color=green>密码：<color>")
  end

  self.nNameId = KLib.String2Id(tostring(me.GetNpc().dwId))
  if Player.bApplyingJiesuo == 1 then
    Btn_SetTxt(self.UIGROUP, BTN_FINDPASS, "取消自助解锁")
  else
    Btn_SetTxt(self.UIGROUP, BTN_FINDPASS, "申请自助解锁")
  end
end

function UiUnLock:OnEditFocus(szWndName)
  if szWndName == EDIT_PWD then
    self:ShowMiniKeyBoard()
  end
end

function UiUnLock:CheckPwd()
  if self.nPwd < 1000000 or self.nPwd > 1999999 then
    me.Msg("密码必须是6位！")
    return 0
  end
  return 1
end

function UiUnLock:EncryptPsw()
  return (self.nPwd % 1000000) * 64 + 32 + self.nr2 * 67108864
end

function UiUnLock:OnEnter()
  local bRightPwd = self:CheckPwd()
  if bRightPwd == 1 then
    local nPsw = self:EncryptPsw()
    local nDivValue = nPsw / self.nr3
    if math.abs(nDivValue * self.nr3 - nPsw) < 1 then
      me.CallServerScript({ "AccountCmd", Account.UNLOCK, nDivValue, self.nr3 })
    else
      me.CallServerScript({ "AccountCmd", Account.UNLOCK, nPsw })
    end
    UiManager:CloseWindow(Ui.UI_MINIKEYBOARD)
    UiManager:CloseWindow(self.UIGROUP)
    return
  end
  self:Init()
end

function UiUnLock:ShowMiniKeyBoard()
  self.nr1 = MathRandom(63)
  self.nr2 = MathRandom(63)
  self.nr3 = MathRandom(65535) / 65536
  UiManager:OpenWindow(Ui.UI_MINIKEYBOARD)
  local x, y = Wnd_GetPos(Ui.UI_MINIKEYBOARD, "Main")
  y = MathRandom(10) * 30
  Wnd_SetPos(Ui.UI_MINIKEYBOARD, "Main", x, y)
end

function UiUnLock:OnButtonClick(szWndName, nParam)
  if szWndName == BTN_ENTER then
    self:OnEnter()
  end

  if szWndName == BTN_CANCEL then
    UiManager:CloseWindow(Ui.UI_MINIKEYBOARD)
    UiManager:CloseWindow(self.UIGROUP)
  end

  if szWndName == BTN_CLOSE then
    UiManager:CloseWindow(Ui.UI_MINIKEYBOARD)
    UiManager:CloseWindow(self.UIGROUP)
  end

  if szWndName == BTN_FINDPASS then
    local tbMsg = {}
    if me.GetPasspodMode() == Account.PASSPODMODE_ZPMATRIX then -- 如果是密保卡，直接开网页
      OpenWebSite(Account.SZ_CARD_JIESUO_URL)
    else
      if Player.bApplyingJiesuo == 1 then -- 取消自助解锁申请
        tbMsg.szMsg = "您确定保留账户锁吗？选择”确定“，账户锁将继续保护您的帐号安全。"
        tbMsg.nOptCount = 2
        function tbMsg:Callback(nOptIndex)
          if nOptIndex == 2 then
            me.CallServerScript({ "AccountCmd", Account.JIESUO_CANCEL })
          end
        end
        UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
      else
        tbMsg.szMsg = "您确定申请取消密码保护？申请将在5天后生效。"
        tbMsg.nOptCount = 2
        function tbMsg:Callback(nOptIndex)
          if nOptIndex == 2 then
            me.CallServerScript({ "AccountCmd", Account.JIESUO_APPLY })
          end
        end
        UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
      end
    end

    UiManager:CloseWindow(Ui.UI_MINIKEYBOARD)
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function UiUnLock:ProcessPwd(nKey)
  --local nKey = self.tbChar2Num[szKey];
  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    return
  end
  if not nKey then
    return
  end
  if nKey == 0 and self.nPwd == 1 and me.GetPasspodMode() == 0 then
    me.Msg("密码不能以0开头！")
    return
  end
  if nKey ~= -1 then
    if self.nPwd >= 1000000 or self.nPos < 1 then
      return
    end
    self.nPwd = self.nPwd * 10 + (nKey + math.floor(self.nNameId / self.nPos) % 10) % 10
    self.nPos = self.nPos / 10
  elseif self.nPwd >= 10 then
    self.nPwd = math.floor(self.nPwd / 10)
    self.nPos = self.nPos * 10
  end
end

function UiUnLock:BuildStarByCount(nCount)
  local szStar = ""
  if nCount > 0 then
    for i = 1, nCount do
      szStar = szStar .. "*"
    end
  end
  return szStar
end

function UiUnLock:KeyProc(szKey)
  self:ProcessPwd(szKey)

  self:UpdatePwdShow()
end

function UiUnLock:UpdatePwdShow()
  local szPwdStar = self:BuildStarByCount(math.ceil(math.log10(1 + self.nPwd)) - 1)
  Edt_SetTxt(self.UIGROUP, EDIT_PWD, szPwdStar)
end

function UiUnLock:OnClose()
  UiManager:CloseWindow(Ui.UI_MINIKEYBOARD)
end

function UiUnLock:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emUIEVENT_MINIKEY_SEND, self.KeyProc },
  }
  return tbRegEvent
end
