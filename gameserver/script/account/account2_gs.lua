-------------------------------------------------------------------
--File: account2_gs.lua
--Author: sunduoliang
--Date: 2012-7-21 10:04
--Describe: Chức năng mật khẩu phụ
-------------------------------------------------------------------

--Kiểm tra xem chức năng này có thể sử dụng được không
function Account:Account2CheckIsUse(pPlayer, nType)
  if IsLoginUseVicePassword(pPlayer.nPlayerIndex) ~= 1 then
    -- Mật khẩu chính không giới hạn
    return 1
  end
  if not self.tbAccount2LockDef_Tsk_Id[nType] then
    -- Loại không tồn tại, không giới hạn sử dụng
    return 1
  end
  local nLimit = pPlayer.GetTask(self.nAccount2LockDef_Tsk_Group, self.tbAccount2LockDef_Tsk_Id[nType][1])
  if nLimit == 1 then
    return 0
  end
  return 1
end

--Kiểm tra xem chức năng này có thể sử dụng được không
function Account:Account2CheckIsUseById(nPlayerId, nType)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return 0
  end
  return self:Account2CheckIsUse(pPlayer, nType)
end

-- Thiết lập mật khẩu phụ có thể sử dụng loại nào, type là loại, bUse=1 có thể sử dụng, 0 không thể sử dụng
function Account:Account2SetUseState(pPlayer, nType, bUse)
  if IsLoginUseVicePassword(pPlayer.nPlayerIndex) == 1 then
    -- Không thể thiết lập mật khẩu phụ
    return 1
  end
  if not self.tbAccount2LockDef_Tsk_Id[nType] then
    -- Loại không tồn tại, không giới hạn sử dụng
    return 1
  end
  local nLimit = 0
  if bUse == 0 then
    nLimit = 1
  end
  pPlayer.SetTask(self.nAccount2LockDef_Tsk_Group, self.tbAccount2LockDef_Tsk_Id[nType][1], nLimit)
end

function Account:Account2CheckIsUseByIndex(nPlayerIndex, nType)
  local pPlayer = KPlayer.GetPlayerObjByIndex(nPlayerIndex)
  if not pPlayer then
    return 0
  end
  local nLimit = self:Account2CheckIsUse(pPlayer, nType)
  if nLimit == 0 then
    pPlayer.Msg("Bạn đang dùng mật khẩu phụ đăng nhập game, đã thiết lập kiểm soát quyền hạn, không thể thực hiện thao tác này!")
  end
  return nLimit
end
