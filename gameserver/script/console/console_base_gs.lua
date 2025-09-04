-- Tên tệp　：console_gs.lua
-- Người tạo　：sunduoliang
-- Thời gian tạo：2009-04-23 10:04:41
-- Mô tả  ：--Bảng điều khiển

if MODULE_GC_SERVER then
  return 0
end

Console.Base = Console.Base or {}
local tbBase = Console.Base

----Giao diện, tùy chỉnh----

--Vào khu vực hoạt động
function tbBase:OnJoin()
  --print("OnJoin", me.szName)
end

--Rời khỏi khu vực hoạt động
function tbBase:OnLeave()
  --print("OnLeave", me.szName)
end

--Sau khi vào khu vực chuẩn bị
function tbBase:OnJoinWaitMap()
  --print("OnJoinWaitMap", me.szName)
end

--Sau khi rời khỏi khu vực chuẩn bị
function tbBase:OnLeaveWaitMap()
  --print("OnLeaveWaitMap", me.szName)
end

--Logic chia nhóm
function tbBase:OnGroupLogic()
  --print("OnGroupLogic");
end
--Mở giao diện
function tbBase:OpenSingleUi(pPlayer, szMsg, nLastFrameTime)
  if not pPlayer or pPlayer == 0 then
    return 0
  end
  Dialog:SetBattleTimer(pPlayer, szMsg, nLastFrameTime)
  Dialog:ShowBattleMsg(pPlayer, 1, 0) --Mở giao diện
end

--Đóng giao diện
function tbBase:CloseSingleUi(pPlayer)
  if not pPlayer or pPlayer == 0 then
    return 0
  end
  Dialog:ShowBattleMsg(pPlayer, 0, 0) -- Đóng giao diện
end

--Cập nhật thời gian giao diện
function tbBase:UpdateTimeUi(pPlayer, szMsg, nLastFrameTime)
  if not pPlayer or pPlayer == 0 then
    return 0
  end
  Dialog:SetBattleTimer(pPlayer, szMsg, nLastFrameTime)
end

--Cập nhật thông tin giao diện
function tbBase:UpdateMsgUi(pPlayer, szMsg)
  if not pPlayer or pPlayer == 0 then
    return 0
  end
  Dialog:SendBattleMsg(pPlayer, szMsg, 1)
end

function tbBase:GetRestTime()
  if self.tbTimerList.nReadyId then
    return Timer:GetRestTime(self.tbTimerList.nReadyId)
  end
  return 0
end

function tbBase:KickPlayer(pPlayer)
  pPlayer.NewWorld(self:GetLeaveMapPos())
end

function tbBase:KickAllPlayer()
  if not self.tbGroupLists then
    return 0
  end
  for nMapId, tbGroupList in pairs(self.tbGroupLists) do
    if SubWorldID2Idx(nMapId) >= 0 then
      local tbGroupLists = tbGroupList.tbList
      if tbGroupLists then
        for nGroup, tbGroup in pairs(tbGroupLists) do
          for _, nPlayerId in pairs(tbGroup) do
            local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
            if pPlayer then
              self:KickPlayer(pPlayer)
            end
          end
        end
      end
    end
  end
end

---Gọi giao diện----

--Báo danh, vào khu vực chuẩn bị
function tbBase:ApplySignUp(tbPlayerIdList)
  if self:IsFull(#tbPlayerIdList) == 0 then
    Dialog:Say("Số người đã đủ!")
    return 0
  end
  if self:GetRestTime() <= 5 * 18 then
    Dialog:Say("Báo danh đã kết thúc!")
    return 0
  end
  Console:ApplySignUp(self.nDegree, tbPlayerIdList)
end

----kết thúc----

--Bắt đầu cấu hình bản đồ
function tbBase:SetMapCfg()
  if self.tbCfg.tbMap then
    for nMapId, tbPos in pairs(self.tbCfg.tbMap) do
      local tbReadyMap = Map:GetClass(nMapId)
      tbReadyMap.OnEnterConsole = function()
        self:MapReadyOnEnter()
      end
      tbReadyMap.OnLeaveConsole = function()
        self:MapReadyOnLeave()
      end
    end
  end

  if self.tbCfg.nDynamicMap and self.tbCfg.nDynamicMap > 0 then
    local tbMap = Map:GetClass(self.tbCfg.nDynamicMap)
    tbMap.OnEnterConsole = function()
      self:MapOnEnter()
    end
    tbMap.OnLeaveConsole = function()
      self:MapOnLeave()
    end
  end
end

function tbBase:ApplyDyMap()
  if self.tbCfg.tbMap and self.tbCfg.nDynamicMap then
    for nMapId, tbPos in pairs(self.tbCfg.tbMap) do
      if SubWorldID2Idx(nMapId) >= 0 then
        Console:ApplyDyMap(self.nDegree, nMapId)
      end
    end
  end
end

function tbBase:GetLeaveMapPos()
  for nMapId, tbPos in pairs(self.tbCfg.tbMap) do
    if SubWorldID2Idx(nMapId) >= 0 then
      if tbPos and tbPos.tbOutPos then
        return unpack(tbPos.tbOutPos)
      end
    end
  end

  local tbNpc = Npc:GetClass("chefu")
  for _, tbMapInfo in ipairs(tbNpc.tbCountry) do
    if SubWorldID2Idx(tbMapInfo.nId) >= 0 then
      local nRandomPos = MathRandom(1, #tbMapInfo.tbSect)
      return tbMapInfo.nId, tbMapInfo.tbSect[nRandomPos][1], tbMapInfo.tbSect[nRandomPos][2]
    end
  end
  return 5, 1580, 3029
end

--Đối tượng, phân phối chỉ số bản đồ động, số nhóm;
function tbBase:OnDyJoin(pPlayer, nDyId, GroupId)
  local tbData = self:GetPlayerData(pPlayer.nMapId, pPlayer.nId)
  if not tbData then
    return 0
  end
  local nCaptain = tbData.nCaptain
  local nGroupId = tbData.nGroupId
  local nMapId = tbData.nMapId

  self.tbMapGroupList[nMapId][nDyId] = self.tbMapGroupList[nMapId][nDyId] or {}
  self.tbMapGroupList[nMapId][nDyId][GroupId] = self.tbMapGroupList[nMapId][nDyId][GroupId] or { tbList = {}, tbPos = {} }
  table.insert(self.tbMapGroupList[nMapId][nDyId][GroupId].tbList, pPlayer.nId)
end

function tbBase:StartSignUp()
  self:KickAllPlayer()
  self:Init()
  self:SetMapCfg()
  self:ApplyDyMap()
  local nDegree = self.nDegree
  self.nState = 1
  self.tbTimerList.nReadyId = Timer:Register(self.tbCfg.nReadyTime, self.TimerClose, self)
  if self.OnMySignUp then
    self:OnMySignUp()
  end
end

function tbBase:TimerClose()
  --self.nState 	  = 2;
  return 0
end

function tbBase:MapReadyOnEnter()
  me.SetLogoutRV(1)
  if self.nState ~= 1 then
    return 0
  end
  self:ReadyOnJoin(me.nMapId, me.nId)
  self:OnJoinWaitMap()
end

function tbBase:MapReadyOnLeave()
  --me.SetLogoutRV(0);
  self:CloseSingleUi(me)
  self:ReadyOnLeave(me.nMapId, me.nId)
  self:OnLeaveWaitMap()
end

function tbBase:MapOnEnter()
  me.SetLogoutRV(1)
  self:ConsumeTask(me) -- Gọi lại trừ số lần khi vào bản đồ
  self:OnJoin()
end

function tbBase:MapOnLeave()
  self:CloseSingleUi(me)
  self:OnLeave()
  --me.SetLogoutRV(0);
end

--Kết thúc cấu hình bản đồ

function tbBase:GetPlayerData(nMapId, nId)
  return self.tbPlayerData[nMapId][nId]
end

--Vào khu vực chuẩn bị
function tbBase:ReadyOnJoin(nMapId, nId)
  local tbData = self:GetPlayerData(nMapId, nId)
  if not tbData then
    return 0
  end
  local nCaptain = tbData.nCaptain
  local nGroupId = tbData.nGroupId
  --local nMapId = tbData.nMapId;

  if nCaptain == 1 then
    table.insert(self.tbGroupLists[nMapId].tbList[nGroupId], 1, nId)
  else
    table.insert(self.tbGroupLists[nMapId].tbList[nGroupId], nId)
  end
end

--Rời khỏi khu vực chuẩn bị
function tbBase:ReadyOnLeave(nMapId, nId)
  if self.nState >= 2 then
    return 0
  end
  GCExcute({ "Console:LeaveGroupList", self.nDegree, nMapId, nId })
  Console:LeaveGroupList(self.nDegree, nMapId, nId)
  GlobalExcute({ "Console:LeaveGroupList", self.nDegree, nMapId, nId })
end

function tbBase:OnStartMission()
  self.nState = 2
  local nDyMapIndex = 1
  if not self.tbGroupLists then
    return 0
  end
  for nMapId, tbGroupList in pairs(self.tbGroupLists) do
    if SubWorldID2Idx(nMapId) >= 0 then
      self:OnGroupLogic(nMapId)
    end
  end

  local nDegree = self.nDegree
  for nWaitMapId, tbPos in pairs(self.tbCfg.tbMap) do
    if SubWorldID2Idx(nWaitMapId) >= 0 then
      for nDyId, tbGroupLists in pairs(self.tbMapGroupList[nWaitMapId]) do
        local nDyMapId = self.tbDynMapLists[nWaitMapId][nDyId]
        local tbCfg = {
          nWaitMapId = nWaitMapId, --ID khu vực chuẩn bị
          nDyMapId = nDyMapId, --ID khu vực hoạt động
          tbGroupLists = tbGroupLists, --Danh sách đội
        }
        self:OnMyStart(tbCfg)
      end
    end
  end
  self.tbGroupLists = {}
  return 0
end

-- Hàm chia nhóm mặc định, hàm này có thể dùng cho hầu hết các trường hợp
function tbBase:GroupLogic(nReadyMap)
  local nMapId = nReadyMap
  local tbGroup = self.tbGroupLists[nMapId]

  if not tbGroup then
    return 0
  end

  if self:ProcessMatchCanOpen(nMapId) ~= 1 then
    return 0
  end

  if SubWorldID2Idx(nMapId) > 0 then
    local tbGroupLists = self:LogicPreProcess(tbGroup)
    local tbGroupMatchList, tbGroupFlag = self:LogicBase(tbGroupLists) --Logic phân phối cơ bản
    local nCurMembers, nLastMembers = self:LogicGetLastSeries(tbGroupMatchList)
    self:LogicAvgTeam(tbGroupMatchList, tbGroupFlag, nLastMembers, nCurMembers)
    self:LogicCheckKickOut(tbGroupMatchList, nLastMembers, nCurMembers) --Xử lý miễn đấu
    self:LogicEnterGame(tbGroupMatchList, nMapId) --Vào sân thi đấu
  end

  return 1
end

-- Không thể bắt đầu do không đủ người trong khu vực chuẩn bị
function tbBase:ProcessMatchCanOpen(nWaitMapId)
  local tbGroup = self.tbGroupLists[nWaitMapId]
  local nWaitNum = 0

  for _, tbGroupTemp in ipairs(tbGroup.tbList) do
    nWaitNum = nWaitNum + #tbGroupTemp
  end

  if nWaitNum >= self.tbCfg.nMinDynPlayer then
    return 1
  end

  local nLeaveMapId, nLeavePosX, nLeavePosY = self:GetLeaveMapPos()

  for _, tbGroupTemp in ipairs(tbGroup.tbList) do
    for _, nId in pairs(tbGroupTemp) do
      local pPlayer = KPlayer.GetPlayerObjById(nId)
      if pPlayer then
        pPlayer.Msg(string.format("Số người tham gia không đủ %s người, không thể bắt đầu thi đấu", self.tbCfg.nMinDynPlayer))
        Dialog:SendBlackBoardMsg(pPlayer, string.format("Số người tham gia không đủ %s người, không thể bắt đầu thi đấu", self.tbCfg.nMinDynPlayer))
        --self:ConsumeTask(pPlayer);
        pPlayer.NewWorld(nLeaveMapId, nLeavePosX, nLeavePosY)
      end
    end
  end

  return 0
end

function tbBase:LogicPreProcess(tbGroup)
  local tbGroupLists = {}
  for nMem = 1, self.tbCfg.nMaxTeamMember do
    tbGroupLists[nMem] = {}
  end

  for _, tbGroupTemp in ipairs(tbGroup.tbList) do
    if #tbGroupTemp > 0 then
      table.insert(tbGroupLists[#tbGroupTemp], tbGroupTemp)
    end
  end

  --Xáo trộn thứ tự ban đầu
  for _, tbGroups in ipairs(tbGroupLists) do
    for i in pairs(tbGroups) do
      local nP = MathRandom(1, #tbGroups)
      tbGroups[i], tbGroups[nP] = tbGroups[nP], tbGroups[i]
    end
  end
  return tbGroupLists
end

--Logic phân phối cơ bản
function tbBase:LogicBase(tbGroupLists)
  --Nguyên tắc ghép cặp.
  local tbGroupMatchList = { {} }
  local tbGroupFlag = {}
  local nGroupFlag = 0
  local nloop = 1 --Chống vòng lặp vô hạn, tối đa 10000 lần lặp
  while self:CheckGroupLists(tbGroupLists) == 1 and nloop <= 10000 do
    local nCurMembers = #tbGroupMatchList

    --Nếu số người trong bảng vượt quá sáu người, thì tạo một bảng trống tiếp theo
    if #tbGroupMatchList[nCurMembers] >= self.tbCfg.nMaxTeamMember then
      nCurMembers = nCurMembers + 1
      tbGroupMatchList[nCurMembers] = {}
    end

    local nIsCreateNewGroup = 1
    --Tìm đội đủ điều kiện để thêm vào bảng
    for nMem = self.tbCfg.nMaxTeamMember, 1, -1 do
      if #tbGroupLists[nMem] > 0 then
        if #tbGroupLists[nMem][1] > 0 and #tbGroupMatchList[nCurMembers] + #tbGroupLists[nMem][1] <= self.tbCfg.nMaxTeamMember then
          nGroupFlag = nGroupFlag + 1
          for _, nId in pairs(tbGroupLists[nMem][1]) do
            tbGroupFlag[nId] = nGroupFlag
            table.insert(tbGroupMatchList[nCurMembers], nId)
          end
          table.remove(tbGroupLists[nMem], 1)
          nIsCreateNewGroup = 0
        end
      end
    end

    --Không tìm thấy đội đủ điều kiện, tạo một bảng trống tiếp theo
    if nIsCreateNewGroup == 1 then
      nCurMembers = nCurMembers + 1
      tbGroupMatchList[nCurMembers] = {}
    end

    nloop = nloop + 1
  end
  return tbGroupMatchList, tbGroupFlag
end

function tbBase:LogicGetLastSeries(tbGroupMatchList)
  local nCurMembers = #tbGroupMatchList
  if #tbGroupMatchList[nCurMembers] <= 0 then
    table.remove(tbGroupMatchList, nCurMembers)
  end

  nCurMembers = #tbGroupMatchList
  local nLastMembers = nCurMembers - 1
  if math.mod(nCurMembers, 2) ~= 0 or nCurMembers == 0 then
    nLastMembers = nCurMembers + 1
  end
  return nCurMembers, nLastMembers
end

--Phân phối đều cho hai đội cuối cùng
function tbBase:LogicAvgTeam(tbGroupMatchList, tbGroupFlag, nLastMembers, nCurMembers)
  --Phân phối đều cho 2 đội được ghép cuối cùng

  local tbGroupA = tbGroupMatchList[nLastMembers] or {}
  local tbGroupB = tbGroupMatchList[nCurMembers] or {}
  local nMid = math.floor((#tbGroupA + #tbGroupB) / 2)
  local tbFlag = {}
  for _, nId in pairs(tbGroupA) do
    tbFlag[tbGroupFlag[nId]] = tbFlag[tbGroupFlag[nId]] or {}
    table.insert(tbFlag[tbGroupFlag[nId]], nId)
  end
  for _, nId in pairs(tbGroupB) do
    tbFlag[tbGroupFlag[nId]] = tbFlag[tbGroupFlag[nId]] or {}
    table.insert(tbFlag[tbGroupFlag[nId]], nId)
  end
  local nMinTeamMember = self.tbCfg.nMinTeamMember or 0
  if #tbGroupA < nMinTeamMember or #tbGroupB < nMinTeamMember then
    local nLeaveMapId, nLeavePosX, nLeavePosY = self:GetLeaveMapPos()
    for _, nId in pairs(tbGroupA) do
      local pPlayer = KPlayer.GetPlayerObjById(nId)
      if pPlayer then
        pPlayer.Msg("Rất xin lỗi, hoạt động lần này được miễn đấu, vui lòng chờ hoạt động lần sau!")
        Dialog:SendBlackBoardMsg(pPlayer, "Rất xin lỗi, hoạt động lần này được miễn đấu, vui lòng chờ hoạt động lần sau!")
        pPlayer.NewWorld(nLeaveMapId, nLeavePosX, nLeavePosY)
      end
    end
    for _, nId in pairs(tbGroupB) do
      local pPlayer = KPlayer.GetPlayerObjById(nId)
      if pPlayer then
        pPlayer.Msg("Rất xin lỗi, hoạt động lần này được miễn đấu, vui lòng chờ hoạt động lần sau!")
        Dialog:SendBlackBoardMsg(pPlayer, "Rất xin lỗi, hoạt động lần này được miễn đấu, vui lòng chờ hoạt động lần sau!")
        pPlayer.NewWorld(nLeaveMapId, nLeavePosX, nLeavePosY)
      end
    end
    tbGroupA = {}
    tbGroupB = {}
  else
    tbGroupA = {}
    tbGroupB = {}
    for _, tbGroup in pairs(tbFlag) do
      if #tbGroupA <= nMid and (#tbGroupA + #tbGroup) <= nMid then
        for _, nId in pairs(tbGroup) do
          table.insert(tbGroupA, nId)
        end
      else
        for _, nId in pairs(tbGroup) do
          table.insert(tbGroupB, nId)
        end
      end
    end
  end
  tbGroupMatchList[nLastMembers] = tbGroupA
  tbGroupMatchList[nCurMembers] = tbGroupB
  return tbGroupMatchList
end

--Xử lý miễn đấu
function tbBase:LogicCheckKickOut(tbGroupMatchList, nLastMembers, nCurMembers)
  local nLeaveMapId, nLeavePosX, nLeavePosY = self:GetLeaveMapPos()
  --Miễn đấu
  if #tbGroupMatchList[nLastMembers] <= 0 or #tbGroupMatchList[nCurMembers] <= 0 then
    for _, nId in pairs(tbGroupMatchList[nLastMembers]) do
      local pPlayer = KPlayer.GetPlayerObjById(nId)
      if pPlayer then
        pPlayer.Msg("Rất xin lỗi, hoạt động lần này được miễn đấu, vui lòng chờ hoạt động lần sau!")
        Dialog:SendBlackBoardMsg(pPlayer, "Rất xin lỗi, hoạt động lần này được miễn đấu, vui lòng chờ hoạt động lần sau!")
        pPlayer.NewWorld(nLeaveMapId, nLeavePosX, nLeavePosY)
      end
    end
    for _, nId in pairs(tbGroupMatchList[nCurMembers]) do
      local pPlayer = KPlayer.GetPlayerObjById(nId)
      if pPlayer then
        pPlayer.Msg("Rất xin lỗi, hoạt động lần này được miễn đấu, vui lòng chờ hoạt động lần sau!")
        Dialog:SendBlackBoardMsg(pPlayer, "Rất xin lỗi, hoạt động lần này được miễn đấu, vui lòng chờ hoạt động lần sau!")
        --self:ConsumeTask(pPlayer);
        pPlayer.NewWorld(nLeaveMapId, nLeavePosX, nLeavePosY)
      end
    end
    if nLastMembers < nCurMembers then
      nLastMembers, nCurMembers = nCurMembers, nLastMembers
    end
    table.remove(tbGroupMatchList, nLastMembers)
    table.remove(tbGroupMatchList, nCurMembers)
  end
  return tbGroupMatchList
end

function tbBase:LogicEnterGame(tbGroupMatchList, nMapId)
  local nLeaveMapId, nLeavePosX, nLeavePosY = self:GetLeaveMapPos()
  for nKey = 1, #tbGroupMatchList, 2 do
    local nTeam = math.floor(nKey / 2) + 1
    self.tbDynMapLists[nMapId] = self.tbDynMapLists[nMapId] or {}
    local nDyMapId = self.tbDynMapLists[nMapId][nTeam]

    local nCaptionAId = 0
    for _, nId in pairs(tbGroupMatchList[nKey]) do
      local pPlayer = KPlayer.GetPlayerObjById(nId)
      if pPlayer then
        if nDyMapId then
          --self:ConsumeTask(pPlayer); -- Chuyển sang trừ số lần khi vào bản đồ
          self:OnDyJoin(pPlayer, nTeam, nKey)
        else
          pPlayer.Msg("Tải bản đồ có lỗi bất thường, trận đấu này không thể bắt đầu, vui lòng liên hệ GM.")
          pPlayer.NewWorld(nLeaveMapId, nLeavePosX, nLeavePosY)
        end
      end
    end

    nCaptionAId = 0
    for _, nId in pairs(tbGroupMatchList[nKey + 1]) do
      local pPlayer = KPlayer.GetPlayerObjById(nId)
      if pPlayer then
        if nDyMapId then
          --self:ConsumeTask(pPlayer); -- Chuyển sang trừ số lần khi vào bản đồ
          self:OnDyJoin(pPlayer, nTeam, nKey + 1)
        else
          pPlayer.Msg("Tải bản đồ có lỗi bất thường, trận đấu này không thể bắt đầu, vui lòng liên hệ GM.")
          pPlayer.NewWorld(nLeaveMapId, nLeavePosX, nLeavePosY)
        end
      end
    end
  end
end

--Kiểm tra xem có đội nào không
function tbBase:CheckGroupLists(tbGroupLists)
  for nMem = 1, self.tbCfg.nMaxTeamMember do
    if #tbGroupLists[nMem] > 0 then
      return 1
    end
  end
  return 0
end

-- Ghi lại số lần tham gia của người chơi
function tbBase:ConsumeTask(pPlayer) end

-- Cài đặt mặc định trạng thái vào sân của người chơi
function tbBase:SetJoinGameState(nGroupId)
  me.ClearSpecialState() --Xóa trạng thái đặc biệt
  me.RemoveSkillStateWithoutKind(Player.emKNPCFIGHTSKILLKIND_CLEARDWHENENTERBATTLE) --Xóa trạng thái
  me.DisableChangeCurCamp(1) --Thiết lập biến liên quan đến bang hội, không cho phép thay đổi phe phái bang hội trong chiến trường
  --me.SetFightState(1);	  	--Thiết lập trạng thái chiến đấu
  me.ForbidEnmity(1) --Cấm cừu sát
  me.DisabledStall(1) --Bày bán
  me.ForbitTrade(1) --Giao dịch
  me.ForbidExercise(1) -- Cấm tỷ thí
  me.SetCurCamp(nGroupId)
  me.TeamDisable(1) --Cấm tổ đội
  me.TeamApplyLeave() --Rời đội
  me.StartDamageCounter() --Bắt đầu tính sát thương
  Faction:SetForbidSwitchFaction(me, 1) -- Vào khu vực chuẩn bị, sân thi đấu sẽ không thể chuyển đổi môn phái
  me.SetDisableZhenfa(1)
  me.nForbidChangePK = 1
  Player:SetForbidGetItem(1)
end

--Người chơi rời khỏi khu vực chuẩn bị, sân thi đấu
function tbBase:SetLeaveGameState()
  me.SetFightState(0)
  me.SetCurCamp(me.GetCamp())
  me.StopDamageCounter() -- Dừng tính sát thương
  me.DisableChangeCurCamp(0)
  me.nPkModel = Player.emKPK_STATE_PRACTISE --Tắt công tắc PK
  me.nForbidChangePK = 0
  me.SetDeathType(0)
  me.RestoreMana()
  me.RestoreLife()
  me.RestoreStamina()
  me.DisabledStall(0) --Bày bán
  me.TeamDisable(0) --Cấm tổ đội
  me.ForbitTrade(0) --Giao dịch
  me.ForbidEnmity(0)
  me.ForbidExercise(0) -- Tỷ thí
  Faction:SetForbidSwitchFaction(me, 0) -- Rời khỏi khu vực chuẩn bị, sân thi đấu sẽ khôi phục lại việc chuyển đổi môn phái
  me.SetDisableZhenfa(0)
  me.LeaveTeam()
  Player:SetForbidGetItem(0)
end

function tbBase:OnSingUpSucess(nPlayerId) end
