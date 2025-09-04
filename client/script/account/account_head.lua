-------------------------------------------------------------------
--File: account_head.lua
--Author: lbh
--Date: 2008-6-27 17:03
--Describe: Các vấn đề liên quan đến tài khoản
-------------------------------------------------------------------
-- Định nghĩa enum c2s
Account.SET_PSW = 1
Account.LOCKACC = 2
Account.UNLOCK = 3
Account.IS_APPLYING_JIESUO = 4 -- Có đang xin tự mở khóa không
Account.JIESUO_APPLY = 5
Account.JIESUO_CANCEL = 6
Account.UNLOCK_BYPASSPOD = 7
Account.UNLOCK_PHONELOCK = 8

Account.PASSPODMODE_ZPTOKEN = 1 --Kim Sơn Lệnh Bài
Account.PASSPODMODE_ZPMATRIX = 2 --Thẻ ma trận
Account.PASSPODMODE_KSPHONELOCK = 3 --Kim Sơn Lệnh Bài Điện Thoại
Account.PASSPODMODE_TW_PHONELOCK = 255 --Khóa điện thoại Đài Loan

Account.SZ_CARD_JIESUO_URL = "http://ecard.xoyo.com/"
Account.SZ_LINGPAI_JIESUO_URL = "http://ekey.xoyo.com/"

Account.nAccount2LockDef_Tsk_Group = 2198 --Nhóm nhiệm vụ
Account.tbAccount2LockDef_Tsk_Id = {
  --Loại Id={Biến nhiệm vụ}
  [1] = { 1 }, --Chức năng giao dịch giữa người chơi
  [2] = { 2 }, --Chức năng nhà đấu giá 1
  [3] = { 3 }, --Chức năng sàn giao dịch Kim Nguyên Bảo 1
  [4] = { 4 }, --Chức năng Kỳ Trân Các 1
  [5] = { 5 }, --Chức năng thư
  [6] = { 6 }, --Chức năng gỡ bỏ (gỡ bỏ bảo thạch, chức năng đồng hành và trang bị đồng hành, chức năng chân nguyên)
  [7] = { 7 }, --Chức năng liên quan cường hóa của Đại Sư Luyện Kim (có thể hợp huyền từ xa) 1
  [8] = { 8 }, --Chức năng khuyến mãi nạp thẻ 1
}

Account.FAILED_RESULT = {
  [5001] = "Lỗi hệ thống",
  [5002] = "Mật khẩu động đã được sử dụng",
  [5003] = "Xác thực lệnh bài thất bại, vui lòng nhập lại mật khẩu động.",
  [5004] = "Lệnh bài đã hết hạn",
  [5005] = "Không tìm thấy liên kết lệnh bài",
  [5006] = "Lệnh bài đã bị vô hiệu hóa (báo mất)",
  [5007] = "Xác thực thẻ bảo mật thất bại, vui lòng nhập lại mật khẩu số ở vị trí đã chỉ định.",
  [5008] = "Thẻ bảo mật đã hết hiệu lực (thời hạn sử dụng thẻ bảo mật đã hết), vui lòng đổi một thẻ bảo mật mới.",
  [5009] = "Không tìm thấy thẻ bảo mật",
}

Account.PHONE_UNLOCK_RESULT = {
  [0] = "<color=red>Đã quá thời gian chờ xác thực, vui lòng gọi đến số khóa liên lạc để tiến hành xác thực.<color>\n Số mở khóa Đài Loan: 0800-771-778\n Số mở khóa Hồng Kông: 3717-1615",
  --[1] = "<color=green>Xác thực thành công<color>",
  [2] = "<color=red>Tài khoản này đã có người chơi khác đăng nhập, nếu không phải bạn sử dụng, vui lòng không gọi khóa liên lạc và nhanh chóng đến trang chủ GF để sửa đổi mật khẩu.<color>",
  [3] = "<color=red>Số điện thoại liên kết với tài khoản này đồng thời có các tài khoản liên quan khác đang chờ kích hoạt, nếu không phải bạn sử dụng, vui lòng nhanh chóng đến trang chủ GF để sửa đổi mật khẩu của các tài khoản liên quan.<color>",
}

Account.tbAccountValue_int = {}
Account.tbAccountValue_bin = {}
Account.tbLimitUseType = {
  [0] = "Hủy tư cách",
  [1] = "Đang sử dụng",
  [2] = "Chuyển nhân vật",
}
Account.tbNameAccountList = {}

function Account:Init()
  local tbData = Lib:LoadTabFile("\\setting\\player\\accountvalue.txt", { Id = 1 })
  for _, tbRow in ipairs(tbData) do
    local tb = self["tbAccountValue_" .. tbRow.Type]
    tb[tbRow.Key] = tbRow.Id
  end
end

function Account:GetIntValue(szAccount, szKey)
  local nId = self.tbAccountValue_int[szKey]
  assert(nId, "invalid key: " .. szKey)
  local bOk, nValue = GetAccountIntegerDataCache(szAccount, nId)
  if bOk ~= 1 then
    nValue = 0
  end
  return nValue
end

function Account:GetBinValue(szAccount, szKey)
  local nId = self.tbAccountValue_bin[szKey]
  assert(nId, "invalid key: " .. szKey)
  local bOk, szValue = GetAccountBinaryDataCache(szAccount, nId)
  if bOk ~= 1 then
    szValue = ""
  end
  return szValue
end

--szAccount, szKey, nValue, bAppend
--Tài khoản, giá trị key, giá trị thay đổi, phương thức thao tác (0 là thiết lập giá trị, 1 là cộng dồn giá trị)
function Account:ApplySetIntValue(szAccount, szKey, nValue, bAppend)
  local nId = self.tbAccountValue_int[szKey]
  assert(nId, "invalid key: " .. szKey)
  if GetAccountIntegerDataCache(szAccount, nId) ~= 1 then -- Biến này không tồn tại
    RequestAccountIntegerDataUpdating(szAccount, nId, 3, nValue)
  elseif bAppend == 1 then
    RequestAccountIntegerDataUpdating(szAccount, nId, 1, nValue)
  else
    RequestAccountIntegerDataUpdating(szAccount, nId, 2, nValue)
  end
end

function Account:ApplySetBinValue(szAccount, szKey, szValue)
  local nId = self.tbAccountValue_bin[szKey]
  assert(nId, "invalid key: " .. szKey)
  if GetAccountBinaryDataCache(szAccount, nId) ~= 1 then -- Biến này không tồn tại
    RequestAccountBinaryDataUpdating(szAccount, nId, 3, szValue)
  else
    RequestAccountBinaryDataUpdating(szAccount, nId, 2, szValue)
  end
end

function Account:GetAccountLimitBuff()
  if not self.tbAccountLimitBuff then
    self.tbAccountLimitBuff = GetGblIntBuf(GBLINTBUF_ACC_LIMIT, 0) or {}
  end
  self.tbNameAccountList = self.tbNameAccountList or {}
  return self.tbAccountLimitBuff
end

function Account:GetAccountLimitBuff2()
  if not self.tbAccountLimitBuff2 then
    self.tbAccountLimitBuff2 = GetGblIntBuf(GBLINTBUF_ACC_LIMIT2, 0) or {}
  end
  return self.tbAccountLimitBuff2
end

Account:Init()
