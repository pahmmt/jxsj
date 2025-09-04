------------------------------------------------------
-- Tên tệp　: player_alter.lua
-- Người tạo　: dengyong
-- Thời gian tạo: 2012-10-23 14:25:47
-- Mô tả  : Liên quan đến đổi tên, đổi giới tính nhân vật
------------------------------------------------------

if not MODULE_GAMESERVER then
  return
end

Require("\\script\\player\\define.lua")

Player.bAlterOpen = 1 -- Công tắc, mặc định mở

Player.ALTER_TYPE_NONE = 0
Player.ALTER_TYPE_NAME = 1
Player.ALTER_TYPE_SEX = 2

Player.ALERT_IDLE = 0
Player.ALTER_CHECK = 1
Player.ALTER_CHECKING = 2
Player.ALTER_REQUEST = 3
Player.ALTER_DOING = 4

-- Dùng để ghi lại trạng thái không đồng bộ trong quá trình kiểm tra
Player.ALTER_WAIT_NONE = 0 -- Không chờ đợi
Player.ALTER_WAIT_CHECKNAME = 1 -- Chờ tên
Player.ALTER_WAIT_CHECKAUC = 2 -- Chờ đấu giá
Player.ALTER_WAIT_LOTTERY = 3 -- Dữ liệu rút thưởng

Player.ALTER_AUCWAIT_SELFSELL = 1 -- Chờ đấu giá của vật phẩm mình bán
Player.ALTER_AUCWAIT_COMPETE = 2 -- Chờ đấu giá của vật phẩm đang đấu giá

Player.ALTER_ITEM_PRICE = 38800 -- Giá Tam Sinh Thạch
Player.ALTER_ITEM_WAREID = 634 -- ID vật phẩm Tam Sinh Thạch
Player.ALTER_LEVEL_LIMIT = 60 -- Giới hạn cấp độ, trên cấp 60
Player.ALTER_CHECK_COST = 10000 -- Kiểm tra có trả phí, tiêu hao 10000 Bạc
Player.ALTER_PROCESS_TIME = 20 -- Thời gian thanh tiến trình
Player.ALTER_WAIT_TIME_OUT = 5 -- Thời gian chờ kiểm tra quá hạn
Player.ALTER_CHECK_INTERVAL = 10 -- Khoảng cách kiểm tra, 10 giây
Player.ALTER_MAIL_FRIENDLEV = 2 -- Gửi thư tái sinh cho hảo hữu cấp 2 trở lên
Player.ALTER_SEX_EQUIP_LEVEL = 10 -- Chỉ trang bị cấp 10 mới đổi giới tính
Player.ALTER_SEX_EQUIP_FILE = "\\setting\\item\\001\\extern\\change\\altersexequip.txt"

Player.ALTER_TSK_GROUP = 2215 -- Thời gian tái sinh, biến nhiệm vụ chính
Player.ALTER_TSK_ALTERTIME = 1 -- Thời gian tái sinh, biến nhiệm vụ phụ
Player.ALTER_OPERATE_INTERVAL = 24 * 3600 -- Khoảng cách tái sinh, 24 giờ

Player.tbAlterCostItem = { 18, 1, 1871, 1 } -- Đạo cụ tiêu hao tái sinh

-- Khi đổi giới tính, cần xóa một số danh hiệu
Player.tbAlterSexDeleteTitile = {
  { 6, 95, 1, 5 }, -- Danh hiệu hoạt động tuyển chọn mỹ nữ 2012
  { 6, 95, 2, 6 },
  { 6, 95, 3, 0 },
  { 6, 95, 4, 0 },
  { 6, 95, 5, 9 },
  { 6, 95, 6, 0 },
  { 13, 1, 1, 0 }, -- Danh hiệu Hiệp Lữ
  { 13, 1, 2, 0 },
}

-- Khi đổi giới tính, tìm bảng không gian của trang bị cần đổi giới tính
Player.tbAlterSearchRoom = {
  -- Ô trang bị, ô trang bị dự phòng, ô trang bị Chiến Hồn
  Item.ROOM_EQUIP,
  Item.ROOM_EQUIPEX,
  Item.ROOM_EQUIPEX2,
  -- Tất cả không gian túi
  Item.ROOM_MAINBAG,
  Item.ROOM_EXTBAG1,
  Item.ROOM_EXTBAG2,
  Item.ROOM_EXTBAG3,
  -- Tất cả không gian kho
  Item.ROOM_REPOSITORY, -- Rương chứa đồ
  Item.ROOM_EXTREP1, -- Rương chứa đồ mở rộng 1
  Item.ROOM_EXTREP2, -- Rương chứa đồ mở rộng 2
  Item.ROOM_EXTREP3, -- Rương chứa đồ mở rộng 3
  Item.ROOM_EXTREP4, -- Rương chứa đồ mở rộng 4
  Item.ROOM_EXTREP5, -- Rương chứa đồ mở rộng 5
  Item.ROOM_REPOSITORY_EXT,
  --Không gian mua lại
  Item.ROOM_RECYCLE,
}

function Player:IsAlterOpen()
  return self.bAlterOpen or 0
end

function Player:AlterSex()
  -- Bỏ chữ ‘V’ của chứng nhận mỹ nữ
  me.SetNpcSpeTitleImage(0, 0)
  me.SetTask(SpecialEvent.Girl_Vote.TSK_GROUP, SpecialEvent.Girl_Vote.TSK_Renzheng_Buff, 0)
  me.SetTask(SpecialEvent.Girl_Vote.TSK_GROUP, SpecialEvent.Girl_Vote.TSK_nLogoTime, 0)
  me.SetTask(SpecialEvent.Girl_Vote.TSK_GROUP, SpecialEvent.Girl_Vote.TSK_LogoIndex, 0)

  -- Bỏ một số danh hiệu đặc biệt...
  for _, tbID in pairs(self.tbAlterSexDeleteTitile) do
    me.RemoveTitle(unpack(tbID))
  end

  -- Đổi trang bị
  local tbFindClass = { "equip", "suite", "mantle", "horse" }
  local tbResult = {}

  for _, szClass in pairs(tbFindClass) do
    for _, nRoom in pairs(self.tbAlterSearchRoom) do
      local tbFind = me.FindClassItem(nRoom, szClass)
      if tbFind then
        for _, tbItem in ipairs(tbFind) do
          tbItem.nRoom = nRoom
        end
        Lib:MergeTable(tbResult, tbFind)
      end
    end
  end

  local nRes = 1
  for _, tbItem in pairs(tbResult) do
    local pItem = tbItem.pItem
    --if pItem and pItem.nLevel == self.ALTER_SEX_EQUIP_LEVEL and pItem.IsBind() == 1 then
    if self:CanEquipBeAltered(pItem) == 1 then
      local tbAlterId = self:GetAlterEquipGDPL(pItem)
      if tbAlterId then -- Nếu thất bại thì làm sao???
        local nRet = pItem.Regenerate(tbAlterId[1], tbAlterId[2], tbAlterId[3], tbAlterId[4], pItem.nSeries, pItem.nEnhTimes, pItem.nLucky, pItem.GetGenInfo(), pItem.nVersion, pItem.dwRandSeed, pItem.nStrengthen)
        if nRet == 0 then
          local szLog = string.format("Trang bị [%s] alter đến [%d_%d_%d_%d] thất bại!", pItem.SzGDPL(), unpack(tbAlterId))
          Dbg:WriteLog("PlayerAlter", "Tên nhân vật: " .. me.szName, "Tên tài khoản: " .. me.szAccount, szLog)
        end

        nRes = nRes * nRet
      end
    end
  end

  return nRes
end

function Player:CanEquipBeAltered(pEquip)
  if pEquip.IsBind() ~= 1 then
    return 0 -- Chỉ trang bị khóa mới cần chuyển
  end

  if (pEquip.szClass == "equip" or pEquip.szClass == "suite") and pEquip.nLevel ~= self.ALTER_SEX_EQUIP_LEVEL then
    return 0 -- Trang bị đều cần cấp 10 mới có thể chuyển
  end

  return 1 -- Những cái khác đều có thể chuyển, tất nhiên là phải có trong bảng chuyển đổi
end

function Player:_OnWaitFunctionRet(pPlayer, nWaitStep, nResult, ...)
  local tbAlterInfo = pPlayer.GetTempTable("Player").tbAlterInfo
  if not tbAlterInfo then
    return 0
  end

  local tbResult = tbAlterInfo.tbResult
  local tbRequest = tbAlterInfo.tbRequest
  local tbWait = tbAlterInfo.tbWait
  if not tbRequest or not tbResult or not tbWait or not tbWait[nWaitStep] then
    return 0
  end

  if nWaitStep == self.ALTER_WAIT_CHECKNAME then
    local szAlterName = unpack(arg)
    if szAlterName ~= tbRequest[1] then
      return 0
    end

    if nResult == 0 then
      table.insert(tbResult, { 1, "Tên nhân vật có thể dùng" })
    elseif nResult == 1 then
      table.insert(tbResult, { 0, "Tên nhân vật đã tồn tại" })
    elseif nResult == 2 then
      table.insert(tbResult, { 0, "Tên nhân vật chứa ký tự nhạy cảm" })
    end
    tbWait[self.ALTER_WAIT_CHECKNAME] = nil
  elseif nWaitStep == self.ALTER_WAIT_CHECKAUC then
    local nCurWait = tbWait[self.ALTER_WAIT_CHECKAUC]
    if nResult ~= 0 then
      table.insert(tbResult, { 0, "Bạn có vật phẩm đang treo bán hoặc đang đấu giá trong Nhà Đấu Giá, vui lòng tự hủy" })
      tbWait[self.ALTER_WAIT_CHECKAUC] = nil
    elseif nCurWait == self.ALTER_AUCWAIT_SELFSELL then
      tbWait[self.ALTER_WAIT_CHECKAUC] = self.ALTER_AUCWAIT_COMPETE
      pPlayer.SearchAndLockAuction(self.ALTER_AUCWAIT_COMPETE)
    else
      table.insert(tbResult, { 1, "Bạn không có vật phẩm đang treo bán hoặc đang đấu giá trong Nhà Đấu Giá" })
      tbWait[self.ALTER_WAIT_CHECKAUC] = nil
    end
  elseif nWaitStep == self.ALTER_WAIT_LOTTERY then
    if nResult == 1 then -- Có dữ liệu rút thưởng
      table.insert(tbResult, { 0, "Hôm nay bạn đã sử dụng vé nạp thẻ hoặc có phần thưởng nạp thẻ chưa nhận, tạm thời không thể tái sinh" })
    else
      table.insert(tbResult, { 1, "Hôm nay bạn không tham gia rút thưởng nạp thẻ" })
    end
    tbWait[self.ALTER_WAIT_LOTTERY] = nil
  end

  if Lib:CountTB(tbWait) == 0 then -- Không còn gì để chờ
    self:SyncAlterCheckResult(pPlayer.nId, tbResult)

    -- Nếu muốn thực hiện thao tác, không thể xóa temptable
    if tbRequest[3] and tbRequest[3] == 1 and self:IsResultPass(tbResult) == 1 then
      self:DoAlterOperate(pPlayer.nId, tbRequest[1], tbRequest[2])
    else -- Nếu không thực hiện thao tác, xóa temptable
      self:ClearAlterData(pPlayer)
      --pPlayer.GetTempTable("Player").tbAlterInfo = nil;
    end
  else -- Vẫn còn phải chờ những cái khác
    tbAlterInfo.tbWait = tbWait
    tbAlterInfo.tbResult = tbResult
    pPlayer.GetTempTable("Player").tbAlterInfo = tbAlterInfo
  end
end

-- Thời điểm gọi, sau khi dữ liệu goddess trả về, trước khi dữ liệu kplayer bị sửa đổi
-- nResult có nghĩa là ALTER_CHECK:0 tên có thể dùng, 1 tên đã bị chiếm, 2 tên không hợp lệ
-- ALTER_REQUEST:1 thành công, -1 lỗi không xác định, -2 tên mới đã bị chiếm, -3 xử lý tên cũ thất bại, -4 GODDESS cập nhật dữ liệu tên nhân vật thất bại
function Player:OnGoddessRoleNameResult(nAlterType, szAlterName, nResult, dwSeq, nOperate)
  if nAlterType == self.ALTER_CHECK then
    self:_OnWaitFunctionRet(me, self.ALTER_WAIT_CHECKNAME, nResult, szAlterName)
  elseif nAlterType == self.ALTER_REQUEST then
    --me.GetTempTable("Player").tbAlterInfo = nil;
    self:ClearAlterData(me)
    if nResult <= 0 then
      me.CallClientScript({ "Player:OnAlterResult", 0 })
    end

    local nNewSex = math.floor(nOperate / 2) > 0 and 1 - me.nSex or me.nSex
    local szNewName = nOperate % 2 == 1 and szAlterName or me.szName
    if nResult == 1 then
      local szMsg = string.format("Đã tái sinh nhân vật, thông tin tái sinh <color=cyan>[%s (%s)]<color>.", szNewName, nNewSex == 1 and "Nữ" or "Nam")

      -- Gửi thư cho hảo hữu
      local tbFriendList = me.GetRelationList(Player.emKPLAYERRELATION_TYPE_BIDFRIEND)
      for _, szName in pairs(tbFriendList or {}) do
        if me.GetFriendFavorLevel(szName) >= self.ALTER_MAIL_FRIENDLEV then
          KPlayer.SendMail(szName, "Thông báo tái sinh nhân vật", string.format("<color=cyan>%s<color>%s", me.szName, szMsg))
        end
      end

      -- Thông báo gia tộc, bang hội
      self:SendMsgToKinOrTong(me, szMsg, 1)

      -- Thông báo hảo hữu
      me.SendMsgToFriend(string.format("<color=cyan>%s<color>%s", me.szName, szMsg))

      -- Thông báo toàn server
      GCExcute({ "Dialog:GlobalMsg2SubWorld_GC", string.format("<color=yellow><color=cyan>%s<color>%s<color>", me.szName, szMsg) })

      me.SetTask(self.ALTER_TSK_GROUP, self.ALTER_TSK_ALTERTIME, GetTime())
    end

    -- statlog
    local szLog = string.format("%d,%d", nOperate, nResult)
    if nOperate % 2 == 1 then
      szLog = szLog .. "," .. szNewName
    else
      szLog = szLog .. ","
    end
    if math.floor(nOperate / 2) > 0 then
      szLog = szLog .. "," .. nNewSex
    end
    StatLog:WriteStatLog("stat_info", "change_name", "change", me.nId, szLog)
  end
end

function Player:OnLockSearchAuctionRet(pPlayer, nItemCount)
  self:_OnWaitFunctionRet(pPlayer, self.ALTER_WAIT_CHECKAUC, nItemCount)
end

function Player:OnLotteryDataCheckRet(nPlayerId, nResult)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return 0
  end

  self:_OnWaitFunctionRet(pPlayer, self.ALTER_WAIT_LOTTERY, nResult)
end

function Player:CheckCanOperate()
  if self:IsAlterOpen() == 0 then
    me.Msg("Chức năng tạm thời chưa mở.")
    return 0
  end

  -- Trạng thái khóa tài khoản
  if me.IsAccountLock() == 1 then
    me.Msg("Tài khoản của bạn đang ở trạng thái khóa, không thể thực hiện thao tác này!")
    return 0
  end

  -- Chu kỳ thao tác
  local nLastTime = me.GetTask(self.ALTER_TSK_GROUP, self.ALTER_TSK_ALTERTIME)
  if GetTime() - nLastTime >= 0 and GetTime() - nLastTime <= self.ALTER_OPERATE_INTERVAL then
    me.Msg("Bạn chưa đủ 24 giờ kể từ lần tái sinh trước, không thể thao tác.")
    return 0
  end

  -- Trạng thái tổ đội không thao tác
  if me.GetTeamId() then
    me.Msg("Không thể thao tác khi đang trong trạng thái tổ đội!")
    return 0
  end

  -- Cấp độ lớn hơn 60
  if me.nLevel < self.ALTER_LEVEL_LIMIT then
    me.Msg("Cấp độ của bạn chưa đạt 60, không thể tái sinh nhân vật.")
    return 0
  end

  -- Thử thao tác ở nơi không hợp lệ?
  local szMap = GetMapType(me.nMapId) or ""
  if szMap ~= "village" and szMap ~= "city" then
    me.Msg("Chỉ có thể thực hiện ở Tân Thủ Thôn hoặc thành thị.")
    return 0
  end

  -- Trong danh sách Thiên Lao, danh sách cày vật phẩm bất hợp pháp không thể thao tác
  local tbBlackList = SpecialEvent.HoleSolution.tbBlackList
  for szIndex, tbFileList in pairs(tbBlackList or {}) do
    if tbFileList[me.szName] then
      return 0
    end
  end

  local tbArrestList = GM.BatchArrest.tbProcessList
  if tbArrestList and tbArrestList[me.szName] then
    return 0
  end

  if IsLoginUseVicePassword(me.nPlayerIndex) == 1 then
    me.Msg("Bạn đang đăng nhập bằng mật khẩu phụ, không thể thực hiện thao tác này.")
    return 0
  end

  -- Nếu trong temptable có dữ liệu, có nghĩa là đang chờ kết quả của thao tác trước đó, thao tác hiện tại không thể thực hiện
  -- TODO:Nên thêm phán đoán thời gian chờ trong dữ liệu???
  local tb = me.GetTempTable("Player").tbAlterInfo
  if not tb or Lib:CountTB(tb) == 0 then
    return 1
  else
    me.Msg("Lần kiểm tra trước vẫn đang tiến hành, vui lòng chờ")
    return 0
  end
  return 0
end

-- nType: 0 có nghĩa là chỉ kiểm tra, 1 có nghĩa là đến từ yêu cầu tái sinh
function Player:DoAlterCheck(szName, nSex, nType)
  local tbResult, tbWait = {}, {}
  local nRet = 1

  local bChangeName, bChangeSex = 0, 0
  if szName and szName ~= "" and szName ~= me.szName then
    bChangeName = 1
  end
  if nSex ~= -1 and nSex ~= me.nSex then
    bChangeSex = 1
  end

  nRet, tbResult = self:_AlterCheck_Common(szName, nSex)

  -- Kiểm tra môn phái, Thiếu Lâm, Nga Mi không thể đổi giới tính
  if bChangeSex == 1 then
    local _nRet, _tbResult = self:_AlterCheck_Sex()

    Lib:MergeTable(tbResult, _tbResult)
    nRet = _nRet * nRet
  end

  -- Kiểm tra nhà đấu giá, chỉ kiểm tra khi đổi tên
  if bChangeName == 1 then
    local _nRet, _tbResult, _tbWait = self:_AlterCheck_Name(szName)

    Lib:MergeTable(tbResult, _tbResult)
    Lib:MergeTable(tbWait, _tbWait)
    nRet = _nRet * nRet
  end

  if Lib:CountTB(tbWait) ~= 0 then
    local nTimerId = Timer:Register(self.ALTER_WAIT_TIME_OUT * Env.GAME_FPS, self.OnCheckWaitTimeOut, self, me.nId)
    local tbAlterInfo = {}
    tbAlterInfo.tbResult = tbResult
    tbAlterInfo.tbRequest = { szName, nSex, nType }
    tbAlterInfo.tbWait = tbWait
    tbAlterInfo.nTimerId = nTimerId
    me.GetTempTable("Player").tbAlterInfo = tbAlterInfo
  else
    return nRet, tbResult
  end
end

function Player:OnCheckWaitTimeOut(nPlayerId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return 0
  end

  local tbAlterInfo = pPlayer.GetTempTable("Player").tbAlterInfo
  if not tbAlterInfo then
    return 0
  end

  local tbResult = tbAlterInfo.tbResult
  local tbRequest = tbAlterInfo.tbRequest
  local tbWait = tbAlterInfo.tbWait
  if not tbRequest or not tbResult or not tbWait then
    pPlayer.GetTempTable("Player").tbAlterInfo = nil
    return 0
  end

  if tbWait[self.ALTER_WAIT_CHECKNAME] then
    table.insert(tbResult, { 0, "Kiểm tra tên quá thời gian, vui lòng kiểm tra lại." })
  end

  if tbWait[self.ALTER_WAIT_CHECKAUC] then
    table.insert(tbResult, { 0, "Kiểm tra dữ liệu nhà đấu giá quá thời gian, vui lòng kiểm tra lại." })
  end

  if tbWait[self.ALTER_WAIT_LOTTERY] then
    table.insert(tbResult, { 0, "Kiểm tra dữ liệu rút thưởng quá thời gian, vui lòng kiểm tra lại." })
  end

  self:SyncAlterCheckResult(pPlayer.nId, tbResult)
  pPlayer.GetTempTable("Player").tbAlterInfo = nil

  return 0
end

function Player:DoAlterOperate(nPlayerId, szName, nSex, nConfirm)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return
  end

  nConfirm = nConfirm or 0

  local bChangeName, bChangeSex = 1, 1
  if not szName or szName == "" or szName == pPlayer.szName then
    bChangeName = 0
  end
  if nSex ~= -1 and nSex == pPlayer.nSex then
    bChangeSex = 0
  end

  if bChangeSex == 0 and bChangeName == 0 then
    return
  end

  if nConfirm == 0 then
    local tbEvent = {
      Player.ProcessBreakEvent.emEVENT_MOVE,
      Player.ProcessBreakEvent.emEVENT_ATTACK,
      Player.ProcessBreakEvent.emEVENT_SITE,
      Player.ProcessBreakEvent.emEVENT_USEITEM,
      Player.ProcessBreakEvent.emEVENT_ARRANGEITEM,
      Player.ProcessBreakEvent.emEVENT_DROPITEM,
      Player.ProcessBreakEvent.emEVENT_SENDMAIL,
      Player.ProcessBreakEvent.emEVENT_TRADE,
      Player.ProcessBreakEvent.emEVENT_CHANGEFIGHTSTATE,
      Player.ProcessBreakEvent.emEVENT_CLIENTCOMMAND,
      Player.ProcessBreakEvent.emEVENT_LOGOUT,
      Player.ProcessBreakEvent.emEVENT_DEATH,
      Player.ProcessBreakEvent.emEVENT_ATTACKED,
    }

    Setting:SetGlobalObj(pPlayer)
    GeneralProcess:StartProcess("Đang tái sinh nhân vật, nhấn ESC để hủy", self.ALTER_PROCESS_TIME * Env.GAME_FPS, { self.DoAlterOperate, self, nPlayerId, szName, nSex, 1 }, { self.DoAlterCancel, self, nPlayerId }, tbEvent)
    Setting:RestoreGlobalObj()
  else
    -- Tiêu hao đạo cụ
    local tbFind = pPlayer.FindItemInBags(unpack(self.tbAlterCostItem))
    if not tbFind or #tbFind == 0 then
      return
    end

    local pItem = tbFind[1].pItem
    if pItem.Delete(pPlayer) == 1 then
      local nRet = pPlayer.ApplyAlter(bChangeName, bChangeSex, szName)
      if nRet == 0 then
        Dbg:WriteLog("PlayerAlter", pPlayer.szAccount, pPlayer.szName .. "ApplyAlter Failed!")
      end
    end
  end
end

function Player:DoAlterCancel(nPlayerId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return
  end

  --pPlayer.GetTempTable("Player").tbAlterInfo = nil;
  self:ClearAlterData(pPlayer)
end

function Player:LoadAlterSexEquipInfo()
  self.tbAlterSexEquipInfo = {}

  local tbFile = Lib:LoadTabFile(self.ALTER_SEX_EQUIP_FILE)
  assert(tbFile, "load [ " .. self.ALTER_SEX_EQUIP_FILE .. " ] Failed!")

  for _, tbData in pairs(tbFile) do
    local nMaleG = tonumber(tbData.MaleG)
    local nMaleD = tonumber(tbData.MaleD)
    local nMaleP = tonumber(tbData.MaleP)
    local nMaleL = tonumber(tbData.MaleL)
    -- Theo giới tính, có nghĩa là chỉ nam mới có thể chuyển trang bị này
    local szMaleId = string.format("%d_%d_%d_%d_0", nMaleG, nMaleD, nMaleP, nMaleL)

    local nFemaleG = tonumber(tbData.FemaleG)
    local nFemaleD = tonumber(tbData.FemaleD)
    local nFemaleP = tonumber(tbData.FemaleP)
    local nFemaleL = tonumber(tbData.FemaleL)
    -- Theo giới tính này, có nghĩa là chỉ nữ mới có thể chuyển trang bị này
    local szFemaleId = string.format("%d_%d_%d_%d_1", nFemaleG, nFemaleD, nFemaleP, nFemaleL)

    self.tbAlterSexEquipInfo[szMaleId] = szFemaleId
    self.tbAlterSexEquipInfo[szFemaleId] = szMaleId
  end
end

function Player:GetAlterEquipGDPL(varItem)
  local szGDPL = nil
  if type(varItem) == "userdata" then
    szGDPL = string.format("%d_%d_%d_%d", unpack(varItem.TbGDPL()))
  elseif type(varItem) == "table" then
    szGDPL = string.format("%d_%d_%d_%d", unpack(varItem))
  end

  if not szGDPL then
    return
  end

  szGDPL = string.format("%s_%d", szGDPL, me.nSex)
  local szDstGDPL = self.tbAlterSexEquipInfo[szGDPL]
  if not szDstGDPL then
    return
  end

  local tbRet = Lib:SplitStr(szDstGDPL, "_")
  for i, var in pairs(tbRet) do
    tbRet[i] = tonumber(var) -- Chuyển ký tự thành số
  end

  return tbRet
end

function Player:IsRoleNameValid(szName)
  local nShowLen = GetNameShowLen(szName)
  -- 3--8 ký tự Hán
  if nShowLen < 6 or nShowLen > 16 then
    return 0, "Độ dài tên nhân vật phải từ 3 đến 8 ký tự Hán!"
  end

  -- Có chứa ký tự không hợp lệ không
  local bNamePass = KUnify.IsNameWordPass(szName)
  if bNamePass == 0 then
    return 0, "Tên nhân vật chỉ có thể chứa chữ Hán giản thể, phồn thể và các ký hiệu ·[]!"
  end

  -- Từ nhạy cảm
  bNamePass = IsNamePass(szName)
  if bNamePass == 0 then
    return 0, "Tên nhân vật chứa từ nhạy cảm!"
  end

  return 1
end

function Player:IsHaveAlterItem(pPlayer)
  -- Chỉ tìm trong túi đồ thôi??
  local tbFind = pPlayer.FindItemInBags(unpack(self.tbAlterCostItem))
  if not tbFind or Lib:CountTB(tbFind) == 0 then
    return 0
  end

  return 1
end

function Player:IsResultPass(tbRes)
  for _, tbInfo in pairs(tbRes or {}) do
    if not tbInfo[1] or tbInfo[1] ~= 1 then
      return 0
    end
  end

  return 1
end

function Player:IsHaveMarryData(pPlayer)
  if pPlayer.IsMarried() == 1 then
    return 1
  end

  -- Đã nạp cát?
  if me.GetTaskStr(Marry.TASK_GROUP_ID, Marry.TASK_QIUHUN_NAME) ~= "" then
    return 1
  end

  -- Có đặt trước ngày cưới không
  if Marry:CheckPreWedding(pPlayer.szName) == 1 then
    return 1
  end

  -- Có lễ kim chưa nhận không
  local tbLinJin = GetGblIntBuf(GBLINTBUF_MARRY_LIJIN, 0) or {}
  for _, tbInfo in pairs(tbLinJin) do
    local szMaleName = tbInfo.szMaleName
    local szFemaleName = tbInfo.szFemaleName
    local nSum = tbInfo.nSum
    if (szMaleName == pPlayer.szName or szFemaleName == pPlayer.szName) and nSum > 0 then
      return 1
    end
  end

  -- Có dữ liệu hủy cầu hôn không
  if Marry.tbProposalBuffer[pPlayer.szName] then
    return 1
  end

  -- Có dữ liệu ly hôn không
  if Marry.tbDivorceBuffer[pPlayer.szName] then
    return 1
  end

  return 0
end

function Player:IsInRoleTransferState(pPlayer)
  -- Đã đăng ký chuyển nhân vật
  local tbTransferData = SpecialEvent.tbRoleTransfer.tbTransferDate or {}
  for _, tb in pairs(tbTransferData[pPlayer.szName] or {}) do
    if tb[5] == 1 then
      return 1
    end
  end

  -- Chuyển nhân vật thất bại
  if SpecialEvent.tbRoleTransfer.tbTransferFailData and SpecialEvent.tbRoleTransfer.tbTransferFailData[pPlayer.szName] then
    return 1
  end

  -- Đang thực hiện thao tác chuyển nhân vật
  if pPlayer.IsInChangeAccountState() == 1 then
    return 1
  end

  return 0
end

function Player:IsInSexLimitedFaction(pPlayer)
  local tbGerneFaction = Faction:GetGerneFactionInfo(pPlayer)

  for i, nFaction in pairs(tbGerneFaction) do
    if nFaction == self.FACTION_SHAOLIN or nFaction == self.FACTION_EMEI then
      return 1
    end
  end

  -- Nếu chưa tu bổ, tbGerneFaction là bảng rỗng, phải kiểm tra môn phái hiện tại
  if pPlayer.nFaction == self.FACTION_SHAOLIN or pPlayer.nFaction == self.FACTION_EMEI then
    return 1
  end

  return 0
end

-- Client yêu cầu kiểm tra tên nhân vật
function Player:ClientApplyAlterCheck(szName, nSex)
  if (not szName or szName == "" or szName == me.szName) and (nSex == -1 or nSex == me.nSex) then
    me.Msg("Thông tin tái sinh bạn điền giống với thông tin nhân vật gốc, không thể tái sinh") -- Vừa không đổi tên vừa không đổi giới tính??
    return
  end

  if self:CheckCanOperate() == 0 then
    return
  end

  -- Khoảng cách thời gian
  local nLast = me.GetTempTable("Player").nLastAlterCheckTime or 0
  if GetTime() - nLast < self.ALTER_CHECK_INTERVAL then
    me.Msg("Vẫn đang trong khoảng thời gian kiểm tra, vui lòng thử lại sau.")
    return
  end

  -- Nếu không có đạo cụ tái sinh, cái này sẽ bị tính phí
  --	if self:IsHaveAlterItem(me) == 0 then
  --		local szMsg = string.format("Mỗi lần kiểm tra sẽ thu <color=yellow>%s<color> Bạc, có chắc chắn kiểm tra không?",  Lib:FormatMoney(self.ALTER_CHECK_COST));
  --		local tbOpt =
  --		{
  --			{"Chắc chắn", self.ApplyAlterCheckSure, self, szName, nSex},
  --			{"Để ta suy nghĩ thêm"},
  --		}
  --		Dialog:Say(szMsg, tbOpt);
  --	end

  local nRet, tbRes = self:DoAlterCheck(szName, nSex, 0)
  me.GetTempTable("Player").nLastAlterCheckTime = GetTime()
  if tbRes then
    self:SyncAlterCheckResult(me.nId, tbRes)
  end
end
Player.c2sFun["ReincarnateCheck"] = Player.ClientApplyAlterCheck

function Player:ApplyAlterCheckSure(szName, nSex)
  if (not szName or szName == "" or szName == me.szName) and (nSex == -1 or nSex == me.nSex) then
    me.Msg("Thông tin tái sinh bạn điền giống với thông tin nhân vật gốc, không thể tái sinh.") -- Vừa không đổi tên vừa không đổi giới tính??
    return
  end

  if self:CheckCanOperate() == 0 then
    return
  end

  -- Trừ Bạc
  if me.CostMoney(self.ALTER_CHECK_COST, 100) == 0 then
    return
  end

  local nRet, tbRes = self:DoAlterCheck(szName, nSex, 0)
  if tbRes then
    self:SyncAlterCheckResult(me.nId, tbRes)
  end
end

-- Client xin tái sinh
function Player:ClientApplyAlter(szName, nSex)
  if (not szName or szName == "" or szName == me.szName) and (nSex == -1 or nSex == me.nSex) then
    me.Msg("Thông tin tái sinh bạn điền giống với thông tin nhân vật gốc, không thể tái sinh.") -- Vừa không đổi tên vừa không đổi giới tính??
    return
  end

  if self:CheckCanOperate() == 0 then
    return
  end

  -- Không có đạo cụ tái sinh không cho thực hiện????
  if self:IsHaveAlterItem(me) == 0 then
    me.Msg("Bạn không có Tam Sinh Thạch trên người!")
    return
  end

  local nRet, tbRes = self:DoAlterCheck(szName, nSex, 1)
  if nRet and tbRes then
    self:SyncAlterCheckResult(me.nId, tbRes)
  end

  if nRet == 1 then
    self:DoAlterOperate(me.nId, szName, nSex)
  end
end
Player.c2sFun["ApplyReincarnate"] = Player.ClientApplyAlter

function Player:ApplyBuyAlterItem(nFlag)
  if self:IsAlterOpen() == 0 then
    me.Msg("Chức năng tạm thời chưa mở.")
    return 0
  end

  nFlag = nFlag or 0

  if nFlag == 0 then
    local szMsg = string.format("Chắc chắn muốn tiêu <color=yellow>%d<color> Đồng để mua một đạo cụ tái sinh Tam Sinh Thạch không?", self.ALTER_ITEM_PRICE)
    szMsg = szMsg .. "<enter><enter><color=red>[Mẹo nhỏ]: <enter>Nhân vật có nghề chính là Thiếu Lâm hoặc Nga Mi không thể đổi giới tính.<color>"
    local tbOpt = {
      { "Mua Tam Sinh Thạch", self.ApplyBuyAlterItem, self, 1 },
      { "Hủy" },
    }
    Dialog:Say(szMsg, tbOpt)
    return
  end

  if me.IsAccountLock() ~= 0 then
    Dialog:Say("Tài khoản của bạn đang ở trạng thái khóa, không thể thực hiện thao tác này!")
    Account:OpenLockWindow(me)
    return
  end
  if Account:Account2CheckIsUse(me, 4) == 0 then
    Dialog:Say("Bạn đang đăng nhập bằng mật khẩu phụ, đã thiết lập kiểm soát quyền hạn, không thể thực hiện thao tác này!")
    return 0
  end
  if me.nCoin < self.ALTER_ITEM_PRICE then
    Dialog:Say("Đồng của bạn không đủ.")
    return 0
  end
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("Cần <color=yellow>1 ô<color> trong túi đồ, hãy dọn dẹp rồi quay lại!")
    return 0
  end
  local bRet = me.ApplyAutoBuyAndUse(self.ALTER_ITEM_WAREID, 1, 0)
  if bRet == 1 then
    Dialog:Say("Mua thành công.")
  else
    Dialog:Say("Mua thất bại.")
  end
end
Player.c2sFun["ApplyBuyAlterItem"] = Player.ApplyBuyAlterItem

function Player:SyncAlterCheckResult(nPlayerId, tbResult)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return
  end

  pPlayer.SetAuctionSearchLockState(0)
  pPlayer.CallClientScript({ "Player:OnAlterCheckReturn", tbResult })
end

Player:LoadAlterSexEquipInfo()

-- Kiểm tra chỉ liên quan đến đổi giới tính
function Player:_AlterCheck_Sex()
  local nRet = 1
  local tbResult = {}

  -- Tu Thiếu Lâm, Nga Mi không thể đổi giới tính????
  if self:IsInSexLimitedFaction(me) == 1 then
    table.insert(tbResult, { 0, "Nhân vật có nghề chính hoặc phụ là Thiếu Lâm hoặc Nga Mi không thể tái sinh giới tính!" })
    nRet = 0
  end

  return nRet, tbResult
end

-- Kiểm tra chỉ liên quan đến đổi tên
function Player:_AlterCheck_Name(szName)
  local nRet = 1
  local tbResult = {}
  local tbWait = {}

  -- Tên có thể dùng không
  if self:IsRoleNameValid(szName) == 0 then
    table.insert(tbResult, { 0, "Tên bạn nhập có từ nhạy cảm" })
    nRet = 0
  else
    if me.ApplyAlterCheck(szName) == 1 then
      tbWait[self.ALTER_WAIT_CHECKNAME] = 1
    else
      table.insert(tbResult, { 0, "Kiểm tra tên thất bại" })
      nRet = 0
    end
  end

  -- Kiểm tra nhà đấu giá
  tbWait[self.ALTER_WAIT_CHECKAUC] = self.ALTER_AUCWAIT_SELFSELL -- Trước tiên kiểm tra cái mình bán
  me.SearchAndLockAuction(self.ALTER_AUCWAIT_SELFSELL)

  -- Nền tảng nhiệm vụ có đơn hàng??
  local tbTaskExp = Task.TaskExp:GetMyTask(me)
  if tbTaskExp and #tbTaskExp ~= 0 then
    table.insert(tbResult, { 0, "Bạn có đơn hàng đã đăng trên nền tảng nhiệm vụ, vui lòng tự hủy" })
    nRet = 0
  else
    table.insert(tbResult, { 1, "Bạn không có đơn hàng đã đăng trên nền tảng nhiệm vụ" })
  end

  -- Là thành chủ nhiệm kỳ trước, và chưa nhận thưởng
  if Newland:CheckCastleOwner(me.szName) == 1 and Newland.tbCastleBuffer.nAward == 1 then
    --(Newland:CheckCastleAward(me) == 1 or Newland:CheckSellBox(me)) then

    table.insert(tbResult, { 0, "Phần thưởng thành chủ của bạn chưa nhận, vui lòng tự nhận" })
    nRet = 0
  end

  -- Rút thưởng
  if NewLottery:GetPlayerAwardList(me) == 1 then -- Có ghi nhận trúng thưởng
    table.insert(tbResult, { 0, "Hôm nay bạn đã sử dụng vé nạp thẻ hoặc có phần thưởng nạp thẻ chưa nhận, tạm thời không thể tái sinh" })
    nRet = 0
  else
    tbWait[self.ALTER_WAIT_LOTTERY] = 1
    GCExcute({ "NewLottery:CheckDataForAlter", me.nId, me.szName })
  end

  -- Kiểm tra chiến đội giải đấu
  local szLeagueName = League:GetMemberLeague(Wlls.LGTYPE, me.szName)
  if szLeagueName then
    local nGameLevel = League:GetLeagueTask(Wlls.LGTYPE, szLeagueName, Wlls.LGTASK_MLEVEL)
    local nCheck, nRank = Wlls:OnCheckAward(me, nGameLevel)
    if nCheck == 1 then
      table.insert(tbResult, { 0, "Bạn có phần thưởng giải đấu chưa nhận" })
      nRet = 0
    end
  end

  -- Kiểm tra phần thưởng giải đấu liên server
  local nGameLevel = GbWlls:GetPlayerSportTask(me.szName, GbWlls.GBTASKID_MATCH_LEVEL)
  if nGameLevel > 0 then
    local nCheck, nRank, szError = GbWlls:OnCheckAward(me, nGameLevel)
    if nCheck ~= 0 then
      table.insert(tbResult, { 0, "Bạn có phần thưởng giải đấu liên server chưa nhận" })
      nRet = 0
    end
  end

  return nRet, tbResult, tbWait
end

-- Kiểm tra liên quan đến cả đổi giới tính và đổi tên
function Player:_AlterCheck_Common(szName, nSex)
  local nRet = 1
  local tbResult = {}

  -- Kiểm tra đạo cụ tái sinh
  if self:IsHaveAlterItem(me) == 1 then
    table.insert(tbResult, { 1, { "Bạn có mang theo đạo cụ tái sinh Tam Sinh Thạch" } })
  else
    table.insert(tbResult, { 0, { "Bạn không có đạo cụ Tam Sinh Thạch, không thể tái sinh" } })
    nRet = 0
  end

  -- Kiểm tra sàn giao dịch Đồng
  local bHaveBill = KJbExchange.HaveBill(me.nId)
  if bHaveBill and bHaveBill == 1 then
    table.insert(tbResult, { 0, "Bạn có đơn hàng giao dịch trong Sàn Giao Dịch Đồng, vui lòng tự hủy" })
    nRet = 0
  else
    table.insert(tbResult, { 1, "Bạn không có đơn hàng giao dịch trong Sàn Giao Dịch Đồng" })
  end

  -- Kiểm tra tình trạng hôn nhân
  if self:IsHaveMarryData(me) == 1 then
    table.insert(tbResult, { 0, "Nhân vật của bạn có quan hệ hiệp lữ (Nạp Cát/Kết hôn), vui lòng tự hủy" })
    nRet = 0
  else
    table.insert(tbResult, { 1, "Nhân vật của bạn không có quan hệ hiệp lữ" })
  end

  -- Kiểm tra dữ liệu chuyển nhân vật
  if self:IsInRoleTransferState(me) == 1 then
    table.insert(tbResult, { 0, "Nhân vật của bạn đã đăng ký chuyển nhân vật, vui lòng đăng nhập trang chủ để tự hủy" })
    nRet = 0
  else
    table.insert(tbResult, { 1, "Nhân vật của bạn không đăng ký chuyển nhân vật" })
  end

  return nRet, tbResult
end

function Player:ClearAlterData(pPlayer)
  local tbAlterInfo = pPlayer.GetTempTable("Player").tbAlterInfo
  if not tbAlterInfo then
    return
  end

  if tbAlterInfo.nTimerId and tbAlterInfo.nTimerId ~= 0 then
    Timer:Close(tbAlterInfo.nTimerId)
    tbAlterInfo.nTimerId = nil
  end

  pPlayer.GetTempTable("Player").tbAlterInfo = nil
end

-- Đối thoại mua Tam Sinh Thạch khóa
function Player:BuyBindAlterItem(nFlag)
  if self:IsAlterOpen() == 0 then
    Dialog:Say("Chức năng này sắp ra mắt, vui lòng kiên nhẫn chờ.")
    return
  end

  if me.CountFreeBagCell() < 1 then
    me.Msg("Túi đồ của bạn không đủ chỗ!")
    return
  end

  nFlag = nFlag or 0

  if nFlag == 0 then
    local szMsg = string.format("Bạn sẽ tiêu %d Đồng khóa để mua một Tam Sinh Thạch", self.ALTER_ITEM_PRICE)
    szMsg = szMsg .. "<enter><enter><color=red>[Mẹo nhỏ]: <enter>Nhân vật có nghề chính là Thiếu Lâm hoặc Nga Mi không thể đổi giới tính.<color>"
    local tbOpt = {
      { "Chắc chắn", self.BuyBindAlterItem, self, 1 },
      { "Hủy" },
    }
    Dialog:Say(szMsg, tbOpt)
  else
    if me.AddBindCoin(0 - self.ALTER_ITEM_PRICE) == 1 then
      me.AddItem(unpack(self.tbAlterCostItem))
    else
      me.Msg("Đồng khóa của bạn không đủ!")
    end
  end
end
