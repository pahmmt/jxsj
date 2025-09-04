-------------------------------------------------------------------
--File: account_gs.lua
--Author: lbh
--Date: 2008-6-27 10:04
--Describe: Máy chủ GS liên quan đến tài khoản
-------------------------------------------------------------------
Require("\\script\\account\\account_head.lua")
Require("\\script\\player\\playerevent.lua")

Account.tbUnlockFailCount = {} -- Số lần mở khóa tài khoản thất bại
Account.tbBanUnlockTime = {} -- Thời gian cấm tài khoản
Account.UNLOCK_FAIL_LIMIT = 5
Account.UNLOCK_BAN_TIME = 30 -- Đóng băng bao nhiêu phút khi đạt số lần mở khóa thất bại
Account.TIME_UNLOCKPASSPOD = 60 * 1.5 -- Không được mở khóa trong 1.5 phút sau khi đăng nhập
Account.c2sCmd = {}
Account.TSK_GROUP = 2137 -- Biến phụ trợ mở khóa bằng điện thoại Đài Loan
Account.TSK_ID_FLAG = 1 -- Biến phụ trợ mở khóa bằng điện thoại Đài Loan

function Account:ProcessClientCmd(nId, tbParam)
  if type(nId) ~= "number" then
    return
  end
  local fun = self.c2sCmd[nId]
  if not fun then
    return
  end
  fun(Account, unpack(tbParam))
end

function Account:SetAccPsw(nOldPsw, nNewPsw, nr)
  if not nr then
    nr = 1
  end
  nNewPsw = math.floor(math.floor(nNewPsw * nr) / 64)
  local bSetOldPsw = 0
  if nOldPsw ~= 0 then
    bSetOldPsw = 1
    nOldPsw = math.floor(nOldPsw * math.floor(nNewPsw / 1048576) / 64) - 1000000
  end
  nNewPsw = nNewPsw % 1048576
  local nNameId = KLib.String2Id(tostring(me.GetNpc().dwId))
  local nNewPswOrg = nNewPsw
  local nOldPswOrg = nOldPsw
  nNewPsw = 0
  nOldPsw = 0
  local nPos = 1
  for i = 1, 6 do
    nNewPsw = nNewPsw + ((nNewPswOrg - nNameId) % 10 + 10) % 10 * nPos
    nNewPswOrg = math.floor(nNewPswOrg / 10)
    if bSetOldPsw ~= 0 then
      nOldPsw = nOldPsw + ((nOldPswOrg - nNameId) % 10 + 10) % 10 * nPos
      nOldPswOrg = math.floor(nOldPswOrg / 10)
    end
    nNameId = math.floor(nNameId / 10)
    nPos = nPos * 10
  end

  if nNewPsw < 100000 or nNewPsw > 999999 then
    me.Msg("Thiết lập thất bại: Mật khẩu phải có 6 chữ số và không được bắt đầu bằng 0!")
    return 0
  end

  local szAccount = me.szAccount
  local nBanTime = self.tbBanUnlockTime[szAccount]
  if nBanTime then
    local nLeftMin = math.ceil(nBanTime / 60 + self.UNLOCK_BAN_TIME - GetTime() / 60)
    if nLeftMin > 0 then
      me.Msg("<color=yellow>" .. nLeftMin .. "<color> phút sau ngươi mới có thể thử lại!")
      return 0
    end
    self.tbBanUnlockTime[szAccount] = nil
  end

  if me.SetAccountLockCode(nOldPsw, nNewPsw) ~= 1 then
    me.Msg("Thiết lập thất bại: Mật khẩu cũ không chính xác!")
    self:PswFail()
    return 0
  end

  if self.tbUnlockFailCount[szAccount] then
    GlobalExcute({ "Account:SetUnLockAccFailCount", szAccount, nil })
  end

  if nOldPsw == 0 then
    me.UnLockAccount(nNewPsw) -- Đồng bộ lại trạng thái khóa
    me.Msg("Thiết lập mật khẩu Khóa an toàn thành công, tất cả nhân vật trong tài khoản này mỗi lần đăng nhập game, chức năng khóa sẽ tự động mở!")
    me.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, "Thiết lập mật khẩu Khóa an toàn thành công.")
  else
    me.Msg("Thay đổi mật khẩu Khóa an toàn thành công!")
    me.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, "Thay đổi mật khẩu Khóa an toàn thành công.")
  end

  return 1
end
Account.c2sCmd[Account.SET_PSW] = Account.SetAccPsw

function Account:LockAcc()
  if me.LockAccount() ~= 1 then
    me.Msg("Khóa tài khoản thất bại: Mật khẩu Khóa an toàn chưa được thiết lập!")
    return
  end
  me.Msg("Tài khoản đã khóa!")
  return 1
end
Account.c2sCmd[Account.LOCKACC] = Account.LockAcc

-- Có quyền xin tự mở khóa không
function Account:CanApplyDisableLock()
  if me.GetAccountMaxLevel() > me.nLevel then
    return 0
  end
  return 1
end

-- Xin tự mở khóa
function Account:DisableLock_Apply()
  if me.IsAccountLockOpen() ~= 1 then
    me.Msg("Tài khoản của bạn không bị khóa.")
    return 0
  end
  if self.CanApplyDisableLock() == 1 then
    me.DisableAccountLock_Apply()
    me.Msg("Bạn đã xin tự mở khóa, sẽ có hiệu lực sau <color=yellow>5 ngày nữa khi đăng nhập lại nhân vật này<color>, trong thời gian này có thể hủy bỏ bất cứ lúc nào.")
    me.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, "Xin tự mở khóa.")
  else
    me.Msg("Hãy đăng nhập vào nhân vật có cấp độ cao nhất trong tài khoản của bạn để xin tự mở khóa.")
  end
  self:SyncJiesuoStateToClient()
end
Account.c2sCmd[Account.JIESUO_APPLY] = Account.DisableLock_Apply

-- Thực hiện tự mở khóa
function Account:DisableLock()
  me.ClearAccountLock()
  Account:DisableLock_Cancel() -- Xóa yêu cầu tự mở khóa

  self:SyncJiesuoStateToClient()
  me.CallClientScript({ "Player:JiesuoNotify" })
  me.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, "Tự mở khóa đã thực hiện thành công.")
end

-- Hủy yêu cầu tự mở khóa
function Account:DisableLock_Cancel()
  me.DisableAccountLock_Cancel()
  self:SyncJiesuoStateToClient()
end

function Account:Jiesuo_Cancel()
  self:DisableLock_Cancel()
  me.Msg("Yêu cầu tự mở khóa đã được hủy.")
  me.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, "Hủy yêu cầu tự mở khóa thành công.")
end
Account.c2sCmd[Account.JIESUO_CANCEL] = Account.Jiesuo_Cancel

function Account:GetDisableLockApplyTime()
  --me.Msg("Thời gian xin mở khóa lần trước "..os.date("%Y-%m-%d %H:%M:%S", me.GetDisableAccountLockApplyTime()));
  return me.GetDisableAccountLockApplyTime()
end

function Account:IsApplyingDisableLock()
  return me.IsApplyingDisableAccountLock()
end
Account.c2sCmd[Account.IS_APPLYING_JIESUO] = Account.IsApplyingDisableLock

function Account:UnLockAcc(nPsw, nr)
  if me.GetPasspodMode() == 1 then
    return 0 -- Có bảo mật, khóa tài khoản gốc không hợp lệ
  end

  if not nr then
    nr = 1
  end
  nPsw = math.floor(math.floor(nPsw * nr) / 64) % 1048576
  if nPsw == 0 then
    return 0
  end
  local nNameId = KLib.String2Id(tostring(me.GetNpc().dwId))
  local nOldPsw = nPsw
  nPsw = 0
  local nPos = 1
  for i = 1, 6 do
    nPsw = nPsw + ((nOldPsw - nNameId) % 10 + 10) % 10 * nPos
    nOldPsw = math.floor(nOldPsw / 10)
    nNameId = math.floor(nNameId / 10)
    nPos = nPos * 10
  end
  if nPsw == 0 then
    return 0
  end
  local szAccount = me.szAccount
  local nBanTime = self.tbBanUnlockTime[szAccount]
  if nBanTime then
    local nLeftMin = math.ceil(nBanTime / 60 + self.UNLOCK_BAN_TIME - GetTime() / 60)
    if nLeftMin > 0 then
      me.Msg("<color=yellow>" .. nLeftMin .. "<color> phút sau ngươi mới có thể thử mở khóa tài khoản lại!")
      return 0
    end
    self.tbBanUnlockTime[szAccount] = nil
  end

  local szLog = string.format("Xin mở khóa\t%s\tLoại:Khóa mật khẩu", me.szName)
  Dbg:WriteLogEx(Dbg.LOG_INFO, "Account", szLog)

  return me.UnLockAccount(nPsw)
end
Account.c2sCmd[Account.UNLOCK] = Account.UnLockAcc

function Account:UnLockAcc_ByPasspod(szCode)
  if me.GetPasspodMode() == 0 then
    return 0 -- Không có bảo mật
  end
  if type(szCode) ~= "string" then
    return 0
  end

  if (me.GetPasspodMode() == self.PASSPODMODE_ZPTOKEN or me.GetPasspodMode() == self.PASSPODMODE_KSPHONELOCK) and (GetTime() < Player:GetLastLoginTime(me) + self.TIME_UNLOCKPASSPOD) then
    return 0 -- Kim Sơn Lệnh bài, không được mở khóa trong vòng 1.5 phút sau khi đăng nhập
  end

  local szAccount = me.szAccount
  local nBanTime = self.tbBanUnlockTime[szAccount]
  if nBanTime then
    local nLeftMin = math.ceil(nBanTime / 60 + self.UNLOCK_BAN_TIME - GetTime() / 60)
    if nLeftMin > 0 then
      me.Msg("<color=yellow>" .. nLeftMin .. "<color> phút sau ngươi mới có thể thử mở khóa tài khoản lại!")
      return 0
    end
    self.tbBanUnlockTime[szAccount] = nil
  end

  local szType = "Thẻ bảo mật"
  if me.GetPasspodMode() == self.PASSPODMODE_ZPTOKEN then
    szType = "Kim Sơn Lệnh Bài"
  end
  local szLog = string.format("Xin mở khóa\t%s\tLoại:%s", me.szName, szType)
  Dbg:WriteLogEx(Dbg.LOG_INFO, "Account", szLog)

  me.ClearAccountLock() -- Xóa khóa an toàn
  return me.UnLockPasspodAccount(szCode)
end
Account.c2sCmd[Account.UNLOCK_BYPASSPOD] = Account.UnLockAcc_ByPasspod

function Account:UnLockAcc_PhoneLock()
  local szLog = string.format("Xin mở khóa\t%s\tLoại:Khóa điện thoại", me.szName)
  Dbg:WriteLogEx(Dbg.LOG_INFO, "Account", szLog)

  GCExcute({ "Account:OnApplyPhoneLock", me.szName })
end
Account.c2sCmd[Account.UNLOCK_PHONELOCK] = Account.UnLockAcc_PhoneLock

function Account:OnUnlockResult(nResult)
  if nResult == 1 then
    if self.tbUnlockFailCount[me.szAccount] then
      GlobalExcute({ "Account:SetUnLockAccFailCount", me.szAccount, nil })
    end
    me.Msg("Mở khóa thành công!")
    me.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, "Mở khóa thành công.")
    return
  end

  local szErrorMsg = ""
  if 0 == nResult then
    local bIsAccountLockOpen = me.GetAccountLockState()
    local bIsPhoneLockOpen = me.GetPhoneLockState()
    local bHasPhoneLock = IVER_g_bHasPhoneLock
    if bHasPhoneLock == 1 then
      if bIsAccountLockOpen == 1 and bIsPhoneLockOpen == 0 then
        me.Msg("Khóa điện thoại đã được mở, vui lòng mở tiếp Khóa an toàn.")

        if 0 ~= me.GetTask(self.TSK_GROUP, self.TSK_ID_FLAG) then
          szErrorMsg = "Mở khóa thất bại: Mật khẩu Khóa an toàn sai, vui lòng nhập lại."
          me.Msg(szErrorMsg)
          me.CallClientScript({ "Ui:ServerCall", "UI_LOCKACCOUNT", "UpdateErrorMsg", szErrorMsg })
          me.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, szErrorMsg)
          self:PswFail()
        else
          me.SetTask(self.TSK_GROUP, self.TSK_ID_FLAG, 1)
        end

        return
      elseif bIsAccountLockOpen == 0 and bIsPhoneLockOpen == 1 then
        me.Msg("Khóa an toàn đã được mở, vui lòng mở tiếp Khóa điện thoại.")
        return
      end
    end
  end

  if me.GetPasspodMode() ~= 0 then
    szErrorMsg = "Mở khóa thất bại: " .. (self.FAILED_RESULT[nResult] or "Lỗi không xác định")

    me.Msg(szErrorMsg)

    --Thông báo giao diện client cập nhật lỗi
    me.CallClientScript({ "Ui:ServerCall", "UI_LOCKACCOUNT", "UpdateErrorMsg", szErrorMsg })

    me.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, szErrorMsg)
  else
    szErrorMsg = "Mở khóa thất bại: Mật khẩu Khóa an toàn sai, vui lòng nhập lại."

    me.Msg(szErrorMsg)

    --Thông báo giao diện client cập nhật lỗi
    me.CallClientScript({ "Ui:ServerCall", "UI_LOCKACCOUNT", "UpdateErrorMsg", szErrorMsg })

    me.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, szErrorMsg)
  end
  self:PswFail()
end

function Account:OnUnlockPhoneLockResult(szPlayerName, nResult)
  local pPlayer = KPlayer.GetPlayerByName(szPlayerName)
  if pPlayer then
    if 1 == nResult then
      pPlayer.UnLockAccount(0, 1)
      pPlayer.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, "Thiết lập mật khẩu Khóa điện thoại thành công.")
    end
    pPlayer.CallClientScript({ "Ui:ServerCall", "UI_LOCKACCOUNT", "PhoneLockResult", nResult })
  end
end

function Account:SetUnLockAccFailCount(szAccount, nCount)
  self.tbUnlockFailCount[szAccount] = nCount
end

function Account:SetUnLockAccBanTime(szAccount, nTime)
  self.tbBanUnlockTime[szAccount] = nTime
  self.tbUnlockFailCount[szAccount] = 0 -- Số lần xóa về 0
end

function Account:PswFail()
  local szAccount = me.szAccount
  local nFailCount = self.tbUnlockFailCount[szAccount]
  if not nFailCount then
    nFailCount = 0
  end
  nFailCount = nFailCount + 1

  if nFailCount >= self.UNLOCK_FAIL_LIMIT then
    local szErrorMsg = "Số lần nhập sai mật khẩu Khóa an toàn đã đạt giới hạn, trong vòng <color=yellow>" .. self.UNLOCK_BAN_TIME .. "<color> phút bạn sẽ không thể thử lại! (Nếu bạn chắc chắn đã quên mật khẩu Khóa an toàn, vui lòng liên hệ với bộ phận chăm sóc khách hàng)."
    me.Msg(szErrorMsg)

    --Thông báo giao diện client cập nhật lỗi
    me.CallClientScript({ "Ui:ServerCall", "UI_LOCKACCOUNT", "UpdateErrorMsg", szErrorMsg })

    local nTime = GetTime()
    self.tbBanUnlockTime[szAccount] = nTime
    GlobalExcute({ "Account:SetUnLockAccBanTime", szAccount, nTime })

    return 0
  end
  me.Msg("Số lần nhập sai mật khẩu Khóa an toàn đã đạt <color=yellow>" .. nFailCount .. "<color> lần, nếu thất bại liên tục <color=yellow>" .. self.UNLOCK_FAIL_LIMIT .. "<color> lần, trong vòng <color=yellow>" .. self.UNLOCK_BAN_TIME .. "<color> phút, các nhân vật trong cùng tài khoản của bạn sẽ không thể thử lại!")

  self.tbUnlockFailCount[szAccount] = nFailCount

  GlobalExcute({ "Account:SetUnLockAccFailCount", szAccount, nFailCount })
  return 1
end

function Account:OnLogin(bExchangeServer)
  if me.GetPasspodMode() == self.PASSPODMODE_ZPMATRIX then
    self:RandomMatrixPos() -- Vị trí thẻ ma trận ngẫu nhiên
  end
  if bExchangeServer == 1 then
    return
  end
  me.SetTask(self.TSK_GROUP, self.TSK_ID_FLAG, 0)
  if me.IsApplyingDisableAccountLock() == 1 then
    local dwTimeApply = me.GetDisableAccountLockApplyTime()
    if dwTimeApply ~= 0 then
      if dwTimeApply + 5 * 24 * 60 * 60 <= GetTime() then
        Account:DisableLock()
      else
        me.CallClientScript({ "Player:ApplyJiesuoNotify", me.GetDisableAccountLockApplyTime() })
      end
    else
      me.CallClientScript({ "Player:ApplyJiesuoNotify" })
    end
  end
  self:SyncJiesuoStateToClient()
  if UiManager.IVER_nIsLoginOpenLockWnd == 1 then
    self:OpenLockWindow(me)
  end
  local nLimiLevel, nSpeLevel, nMonthLimit = jbreturn:GetRetLevel(me)
  local nIsNoUse = Account:GetIntValue(me.szAccount, "Account.VipIsNoUse")
  if nLimiLevel > 0 and nIsNoUse == 0 then
    local szCurIp = Lib:IntIpToStrIp(me.GetTask(2063, 1)) or "0.0.0.0"
    local szCurArea = GetIpAreaAddr(me.GetTask(2063, 1)) or "Khu vực không xác định"
    GCExcute({ "Account:LogLimitAccount", me.szName, me.szAccount, nLimiLevel, nSpeLevel, nMonthLimit, me.nMonCharge, me.GetHonorLevel(), szCurIp, szCurArea })
  end
end

function Account:RandomMatrixPos()
  local tbRow = { "A", "B", "C", "D", "E", "F", "G", "H" }
  local tbLine = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 0 }

  local szPos = ""
  for i = 1, 3 do
    local nIndex = MathRandom(#tbRow)
    szPos = szPos .. tbRow[nIndex]
    table.remove(tbRow, nIndex)
    nIndex = MathRandom(#tbLine)
    szPos = szPos .. tbLine[nIndex]
    table.remove(tbLine, nIndex)
  end
  me.SetMatrixPosition(szPos)
end

function Account:SyncJiesuoStateToClient()
  me.CallClientScript({ "Player:SyncJiesuoState_C", self.CanApplyDisableLock(), self.IsApplyingDisableLock(), self.GetDisableLockApplyTime() })
end

-- Có mở quảng cáo thẻ bảo mật và lệnh bài không
function Account:IsOpenPasspodAd()
  return IVER_g_nLockAccount or 0
end

function Account:OpenLockWindow(pPlayer)
  if not pPlayer then
    return
  end
  if EventManager.IVER_nOpenLockWnd == 1 then
    pPlayer.CallClientScript({ "UiManager:OpenWindow", "UI_LOCKACCOUNT" })
  end
end

function Account:OpenLockWindow(pPlayer)
  if not pPlayer then
    return
  end
  if EventManager.IVER_nOpenLockWnd == 1 then
    pPlayer.CallClientScript({ "UiManager:OpenWindow", "UI_LOCKACCOUNT" })
  end
end

PlayerEvent:RegisterGlobal("OnLogin", Account.OnLogin, Account)
