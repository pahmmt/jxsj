function Account:OnPhoneLockResult(szName, nResult)
  return GlobalExcute({ "Account:OnUnlockPhoneLockResult", szName, nResult })
end

function Account:OnApplyPhoneLock(szName)
  local nRet = ApplyUnlockPhoneLock(szName)
  if nRet ~= 1 then
    self:OnPhoneLockResult(szName, 2) -- Yêu cầu lặp lại
  end
end

--Ghi lại cấp độ nhân vật
function Account:LogLimitAccount(szName, szAccount, nLimiLevel, nSpeLevel, nMonthLimit, nMonCharge, nHonorLevel, szCurIp, szCurArea)
  local tbBuff = self:GetAccountLimitBuff()
  local tbBuff2 = Account:GetAccountLimitBuff2()
  local szDate = os.date("%Y-%m-%d", GetTime())
  tbBuff[szAccount] = tbBuff[szAccount] or {}
  tbBuff[szAccount][szName] = tbBuff[szAccount][szName] or {}
  tbBuff[szAccount][szName] = { nLimiLevel, nSpeLevel, nMonthLimit, nMonCharge, nHonorLevel, szDate, 1, szCurIp, szCurArea }

  local szCurName = Account:GetBinValue(szAccount, "Account.VipName")
  local nPlayerId = KGCPlayer.GetPlayerIdByName(szName)
  if KGCPlayer.OptGetTask(nPlayerId, KGCPlayer.TSK_ONLINESERVER) <= 0 and tbBuff2[szAccount] then
    --Không trực tuyến
    szCurName = tbBuff2[szAccount][2] or ""
  end
  if szCurName == "" then
    if tbBuff2[szAccount] then
      szCurName = tbBuff2[szAccount][2] or "Chưa thiết lập"
      Account:SetLimitAccountCurName(szAccount, tbBuff2[szAccount][2])
    else
      szCurName = "Chưa thiết lập"
    end
  elseif not tbBuff2[szAccount] then
    tbBuff2[szAccount] = { 1, szCurName }
  end

  --Trường hợp nhân vật chuyển tài khoản
  if self.tbNameAccountList[szName] and self.tbNameAccountList[szName] ~= szAccount then
    if tbBuff[self.tbNameAccountList[szName]] and tbBuff[self.tbNameAccountList[szName]][szName] then
      tbBuff[self.tbNameAccountList[szName]][szName][7] = "Chuyển nhân vật"
    end
  end
  self.tbNameAccountList[szName] = szAccount
end

function Account:SetLimitAccountCurName(szAccount, szCurName)
  Account:ApplySetBinValue(szAccount, "Account.VipName", szCurName)
  local tbBuff2 = Account:GetAccountLimitBuff2()
  tbBuff2[szAccount] = { 1, szCurName }
  return 1
end

function Account:DelAccountLimit(szName, szAccount, nLimiLevel, nSpeLevel, nMonthLimit, nMonCharge, nHonorLevel)
  Account:LogLimitAccount(szName, szAccount, nLimiLevel, nSpeLevel, nMonthLimit, nMonCharge, nHonorLevel, "0.0.0.0", "Khu vực không xác định")
  local tbBuff, tbBuff2 = self:GetAccountLimitBuff()
  for szName, tbInfo in pairs(tbBuff[szAccount]) do
    tbInfo[7] = 0
  end
  Account:SetAccountLimitIsUse(szAccount, 1)
  SetGblIntBuf(GBLINTBUF_ACC_LIMIT, 0, 0, tbBuff)
end

function Account:SetAccountLimitIsUse(szAccount, bInt)
  Account:ApplySetIntValue(szAccount, "Account.VipIsNoUse", bInt, 0)
  return 1
end

function Account:ScheduletaskAccountLimitSave()
  local szGateWay = GetGatewayName()
  local szGateName = ServerEvent:GetServerNameByGateway(szGateWay)
  local szOutFile = "\\accountlimit\\" .. szGateWay .. "_accountlimit.txt"
  local szContext = "Cổng\tTên máy chủ\tTài khoản\tTên nhân vật\tCấp ưu đãi\tƯu đãi đặc biệt\tHạn mức ưu đãi\tSố tiền nạp trong tháng\tCấp độ Vinh Danh Tài Phú\tNgày đăng nhập gần nhất\tCó hủy không\tIP đăng nhập gần nhất\tKhu vực đăng nhập gần nhất\tQuyền sở hữu\n"
  KFile.WriteFile(szOutFile, szContext)
  local tbBuff = self:GetAccountLimitBuff()
  local tbBuff2 = Account:GetAccountLimitBuff2()

  for szAccount, tbName in pairs(tbBuff) do
    for szName, tbInfo in pairs(tbName) do
      local szUseInfo = "Tình trạng không xác định"
      local szCurName = "Chưa thiết lập"

      if tbBuff2[szAccount] then
        szCurName = tbBuff2[szAccount][2]
      end
      szUseInfo = self.tbLimitUseType[tbInfo[7]] or ""

      local szOut = string.format("%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", szGateWay, szGateName, szAccount, szName, tbInfo[1] or 0, tbInfo[2] or 0, tbInfo[3] or 0, tbInfo[4] or 0, tbInfo[5] or 0, tbInfo[6] or 0, szUseInfo or "", tbInfo[8] or "0.0.0.0", tbInfo[9] or "Khu vực không xác định", szCurName or "")
      KFile.AppendFile(szOutFile, szOut)
    end
  end
  SetGblIntBuf(GBLINTBUF_ACC_LIMIT, 0, 1, tbBuff)
end

function Account:AccountLimitSaveBuff()
  local tbBuff = self:GetAccountLimitBuff()
  SetGblIntBuf(GBLINTBUF_ACC_LIMIT, 0, 1, tbBuff)

  local tbBuff2 = self:GetAccountLimitBuff2()
  SetGblIntBuf(GBLINTBUF_ACC_LIMIT2, 0, 1, tbBuff2)
end

function Account:ApplyCancelJbreturn(szPlayerName, nLevel, nHonor, szAccount, szNewAccount)
  local szGateWay = GetGatewayName()
  local szGateName = ServerEvent:GetServerNameByGateway(szGateWay)
  local szCurName = Account:GetBinValue(szAccount, "Account.VipName")
  local szOutFile = string.format("\\accountlimit\\%s_cancel_jbreturn_%s.txt", szGateWay, GetLocalDate("%Y%m%d"))
  local szOut = string.format("%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", szGateWay, szGateName, szPlayerName, nLevel, nHonor, szAccount, szNewAccount, szCurName)
  KFile.AppendFile(szOutFile, szOut)
  Account:ApplySetIntValue(szAccount, "Account.ApplyCancelTime", GetTime(), 0)
end

function Account:AlterRoleName(szOldName, szNewName, nPlayerId)
  local szAccount = KGCPlayer.GetPlayerAccount(nPlayerId)
  if not szAccount then
    return
  end

  local tbBuff = self:GetAccountLimitBuff() or {}
  local tbBuff2 = self:GetAccountLimitBuff2() or {}
  --	if not tbBuff or not tbBuff[szAccount] then
  --		return;
  --	end

  local bFind = 0
  local tbName = tbBuff[szAccount] or {}
  if tbName[szOldName] then
    tbName[szNewName] = tbName[szOldName]
    tbName[szOldName] = nil
    bFind = 1
  end

  for szAccount, tbInfo in pairs(tbBuff2) do
    if tbInfo[2] == szOldName then
      tbInfo[2] = szNewName
      bFind = 1
    end
  end

  if self.tbNameAccountList[szOldName] then
    self.tbNameAccountList[szNewName] = self.tbNameAccountList[szOldName]
    self.tbNameAccountList[szOldName] = nil
  end

  local szCurName = Account:GetBinValue(szAccount, "Account.VipName")
  if szCurName == szOldName then
    self:ApplySetBinValue(szAccount, "Account.VipName", szNewName)
  end

  if bFind == 1 then
    self:AccountLimitSaveBuff()
  end
end
GCEvent:RegisterGCServerShutDownFunc(Account.AccountLimitSaveBuff, Account)
