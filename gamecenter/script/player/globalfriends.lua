--GBLINTBUF_GLOBALFRIEND
Player.tbGlobalFriends = {}
local tbGlobalFriends = Player.tbGlobalFriends

--Ghi lại bạn bè mà người chơi đã thêm trong máy chủ toàn cục
--tbCache[szSrcName] = {szFriend1, szFriend2, ...}
tbGlobalFriends.tbCache = {}

tbGlobalFriends.tbPlayerInfo = {}

tbGlobalFriends.tbBlackList = {}

tbGlobalFriends.nTimeOutId = 0

function tbGlobalFriends:Init()
  tbGlobalFriends.tbBlackList = {}
  tbGlobalFriends.nTimeOutId = 0
  self:LoadBlackList()
end

function tbGlobalFriends:SaveBlackList()
  local szFilePath = GetPlayerPrivatePath() .. "global_blacklist.dat"
  local szData = Lib:Val2Str(self.tbBlackList)
  KFile.WriteFile(szFilePath, szData)
end

function tbGlobalFriends:LoadBlackList()
  local szFilePath = GetPlayerPrivatePath() .. "global_blacklist.dat"
  local szData = KIo.ReadTxtFile(szFilePath)
  if szData then
    self.tbBlackList = Lib:Str2Val(szData)
  end
end

function tbGlobalFriends:Clear()
  me.GlobalFriends_Clear()
end

function tbGlobalFriends:Add(szName, szGateway)
  if self.nTimeOutId > 0 then
    Timer:Close(self.nTimeOutId)
    self.nTimeOutId = 0
  end
  me.Msg(string.format("[%s] đã trở thành bạn bè liên server của bạn.", szName))
  me.GlobalFriends_Add(szName, szGateway)
  if MODULE_GAMESERVER == nil then
    CoreEventNotify(UiNotify.emCOREEVENT_RELATION_UPDATEPANEL)
  end
end

-- Thiết lập cổng cho một người bạn liên server
function tbGlobalFriends:SetGateway(szName, szGateway)
  me.GlobalFriends_SetGateway(szName, szGateway)
end

-- Xóa bạn bè liên server
function tbGlobalFriends:Delete(szName)
  me.GlobalFriends_Delete(szName)
  if MODULE_GAMESERVER == nil then
    CoreEventNotify(UiNotify.emCOREEVENT_RELATION_UPDATEPANEL)
  end
end

function tbGlobalFriends:Exist(szName)
  local tbFriends = me.GlobalFriends_Get(szName)
  if tbFriends == nil then
    return 0
  else
    return 1
  end
end

-- Client cập nhật danh sách bạn bè liên server
function tbGlobalFriends:UpdateList(szNameList)
  me.GlobalFriends_UpdateList(szNameList)
end

-- Đồng bộ thêm bạn bè liên server mới đến client
function tbGlobalFriends:SyncAdd(szName, szGateway)
  me.CallClientScript({ "Player.tbGlobalFriends:Add", szName, szGateway })
end

-- Đồng bộ cổng của người chơi đến client
function tbGlobalFriends:SyncGateway(szName, szGateway)
  me.CallClientScript({ "Player.tbGlobalFriends:SetGateway", szName, szGateway })
end

-- Đồng bộ xóa đến client
function tbGlobalFriends:SyncDelete(szName)
  me.CallClientScript({ "Player.tbGlobalFriends:Delete", szName })
end

-- Đồng bộ danh sách bạn bè liên server đến client
function tbGlobalFriends:SyncList(szNameList)
  me.CallClientScript({ "Player.tbGlobalFriends:UpdateList", szNameList })
end

function tbGlobalFriends:AddGlobalFriendsFailed()
  if self.nTimeOutId > 0 then
    Timer:Close(self.nTimeOutId)
  end
  me.Msg("Thêm bạn bè liên server thất bại, đối phương là người chơi cùng server.")
end

function tbGlobalFriends:TimeOutCallBack(szName)
  self.nTimeOutId = 0
  me.Msg(string.format("Thêm bạn bè liên server thất bại, không tìm thấy người chơi [%s].", szName))
  return 0
end

-- Client thêm bạn bè liên server
function tbGlobalFriends:ApplyAddFriend(szSrcName, szDstName)
  if self.nTimeOutId ~= 0 then
    me.Msg("Thao tác của bạn quá nhanh.")
    return
  end
  for _k, _v in pairs(self.tbBlackList) do
    if _v == szDstName then
      me.Msg(string.format("[%s] đã có trong danh sách đen của bạn.", szDstName))
      return
    end
  end
  if me.GlobalFriends_GetCount() >= 99 then
    me.Msg("Số lượng bạn bè liên server của bạn đã đạt đến giới hạn.")
    return
  end
  if szSrcName == "" then
    szSrcName = me.szName
  end
  if self:Exist(szDstName) == 1 then
    me.Msg(string.format("[%s] đã là bạn bè liên server của bạn", szDstName))
    return
  end
  self.nTimeOutId = Timer:Register(18 * 2, self.TimeOutCallBack, self, szDstName)
  me.CallServerScript({ "GlobalFriendsCmd", "gs_ApplyAddFriend", szSrcName, szDstName })
end

-- Client thêm vào danh sách đen (danh sách đen được lưu cục bộ)
function tbGlobalFriends:ApplyAddBlack(szName)
  for _k, _v in pairs(self.tbBlackList) do
    if _v == szName then
      me.Msg(string.format("[%s] đã có trong danh sách đen.", szName))
      return
    end
  end
  if self:Exist(szName) == 1 then
    me.Msg(string.format("[%s] là bạn bè liên server của bạn, không thể thêm vào danh sách đen.", szName))
    return
  end
  table.insert(self.tbBlackList, szName)
  CoreEventNotify(UiNotify.emCOREEVENT_RELATION_UPDATEPANEL)
  me.Msg(string.format("Bạn đã thêm [%s] vào danh sách đen.", szName))
  tbGlobalFriends:SaveBlackList()
end

-- Client yêu cầu xóa bạn bè liên server
function tbGlobalFriends:ApplyDeleteFriend(szDstName)
  me.CallServerScript({ "GlobalFriendsCmd", "gs_ApplyDeleteFriend", szDstName })
end

-- GS nhận giao thức: Thêm bạn bè liên server thất bại
function tbGlobalFriends:gs_OnAddGlobalFriendsFailed(szSrcName)
  local pPlayer = KPlayer.GetPlayerByName(szSrcName)
  if pPlayer == nil then
    return
  end
  pPlayer.CallClientScript({ "Player.tbGlobalFriends:AddGlobalFriendsFailed" })
end

-- GS xóa bạn bè liên server
function tbGlobalFriends:gs_ApplyDeleteFriend(szName)
  self:Delete(szName)
end

-- GS thêm bạn bè liên server, yêu cầu GC
function tbGlobalFriends:gs_ApplyAddFriend(szSrcName, szDstName)
  GCExcute({ "Player.tbGlobalFriends:gc_ApplyAddFriend", szSrcName, szDstName })
end

-- GC nhận yêu cầu thêm bạn bè liên server từ GS
function tbGlobalFriends:gc_ApplyAddFriend(szSrcName, szDstName)
  -- Nếu gc này không phải là máy chủ toàn cục, thì gửi tin nhắn đến máy chủ toàn cục
  if IsGlobalServer() == false then
    local nDstPlayerId = KGCPlayer.GetPlayerIdByName(szDstName)
    -- Máy chủ này đã phát hiện người chơi mục tiêu, cho thấy không phải là bạn bè liên server
    if nDstPlayerId ~= nil then
      local nSrcPlayerServer = GCGetPlayerOnlineServer(szSrcName)
      GSExcute(nSrcPlayerServer, { "Player.tbGlobalFriends:gs_OnAddGlobalFriendsFailed", szSrcName })
      return
    end
    local szSrcGateway = GetGatewayName()
    GlobalGCExcute(-1, { "Player.tbGlobalFriends:global_gc_ApplyAddFriend", szSrcName, szDstName, szSrcGateway })
  else
    -- Nếu gc này là máy chủ toàn cục, cho thấy người chơi đang ở trạng thái liên server, thêm bạn bè
    self:global_gc_ApplyAddFriend(szSrcName, szDstName, "")
  end
end

-- Máy chủ toàn cục nhận yêu cầu thêm bạn bè từ GC
function tbGlobalFriends:global_gc_ApplyAddFriend(szSrcName, szDstName, szSrcGateway)
  GlobalGCExcute(-1, { "Player.tbGlobalFriends:gc_OnFindPlayer", szSrcName, szDstName, szSrcGateway })
end

-- gc nhận giao thức tìm người chơi từ máy chủ toàn cục
function tbGlobalFriends:gc_OnFindPlayer(szSrcName, szDstName)
  -- gc này tìm thấy người chơi mục tiêu
  local nSrcPlayerId = KGCPlayer.GetPlayerIdByName(szSrcName)
  local nPlayerId = KGCPlayer.GetPlayerIdByName(szDstName)
  -- Người chơi cùng server, không thể thêm bạn bè liên server
  if nSrcPlayerId ~= nil and nPlayerId ~= nil then
    KGCPlayer.SendPlayerAnnounce(nSrcPlayerId, "Không thể thêm người chơi cùng server làm bạn bè liên server.")
    return
  end
  if nPlayerId ~= nil then
    --TODO: Hỏi mục tiêu có muốn thêm đối phương làm bạn bè không
    local szDstGateway = GetGatewayName()
    local tbPlayerInfo = KGCPlayer.GCPlayerGetInfo(nPlayerId)
    tbPlayerInfo.szGateway = szDstGateway
    GlobalGCExcute(-1, { "Player.tbGlobalFriends:global_OnFoundFriend", szSrcName, szDstName, tbPlayerInfo })
  end
end

--Máy chủ toàn cục nhận giao thức gc: tìm thấy người chơi mục tiêu
function tbGlobalFriends:global_OnFoundFriend(szSrcName, szDstName, tbPlayerInfo)
  GlobalGCExcute(-1, { "Player.tbGlobalFriends:gc_OnFoundFriend", szSrcName, szDstName, tbPlayerInfo })
  -- Thông báo cho gs của máy chủ toàn cục
  self:gc_OnFoundFriend(szSrcName, szDstName, tbPlayerInfo)
end

--gc nhận giao thức máy chủ toàn cục: tìm thấy người chơi mục tiêu
function tbGlobalFriends:gc_OnFoundFriend(szSrcName, szDstName, tbPlayerInfo)
  local nSrcPlayerId = KGCPlayer.GetPlayerIdByName(szSrcName)
  if nSrcPlayerId == nil then
    return
  end
  local nSrcPlayerServer = GCGetPlayerOnlineServer(szSrcName)
  -- Người chơi online thì thông báo, không online thì lưu vào bộ nhớ đệm
  if nSrcPlayerServer > 0 then
    GSExcute(nSrcPlayerServer, { "Player.tbGlobalFriends:gs_OnFoundFriend", szSrcName, szDstName, tbPlayerInfo })
  elseif IsGlobalServer() == false then
    self:gc_AddFriendCache(szSrcName, szDstName)
  end
end

--gs nhận giao thức gc: tìm thấy người chơi mục tiêu
function tbGlobalFriends:gs_OnFoundFriend(szSrcName, szDstName, tbPlayerInfo)
  local pPlayer = KPlayer.GetPlayerByName(szSrcName)
  if pPlayer == nil then
    return
  end
  pPlayer.CallClientScript({ "Player.tbGlobalFriends:SetPlayerInfo", szDstName, tbPlayerInfo })
  pPlayer.GlobalFriends_Add(szDstName, tbPlayerInfo.szGateway)
end

-- GS yêu cầu truy vấn cổng của bạn bè liên server
function tbGlobalFriends:gs_ApplyQureyGateway(szNameList)
  if szNameList == "" then
    return
  end
  GCExcute({ "Player.tbGlobalFriends:gc_ApplyQureyGateway", me.szName, szNameList })
end

-- GC nhận yêu cầu truy vấn cổng của bạn bè liên server từ GS
function tbGlobalFriends:gc_ApplyQureyGateway(szSrcName, szNameList)
  if IsGlobalServer() then
    self:global_gc_ApplyQureyGateway(szSrcName, szNameList)
  else
    GlobalGCExcute(-1, { "Player.tbGlobalFriends:global_gc_ApplyQureyGateway", szSrcName, szNameList })
  end
end

-- Máy chủ toàn cục nhận yêu cầu truy vấn cổng của bạn bè liên server từ GC
function tbGlobalFriends:global_gc_ApplyQureyGateway(szSrcName, szNameList)
  GlobalGCExcute(-1, { "Player.tbGlobalFriends:gc_OnQureyGateway", szSrcName, szNameList })
end

-- Các GC nhận yêu cầu truy vấn được phát sóng từ máy chủ toàn cục
function tbGlobalFriends:gc_OnQureyGateway(szSrcName, szNameList)
  local szGateway = GetGatewayName()
  local nPlayerId = 0
  for szName in string.gfind(szNameList, ".-\n") do
    szName = string.gsub(szName, "\n", "")
    nPlayerId = KGCPlayer.GetPlayerIdByName(szName)
    if nPlayerId ~= nil then
      local tbPlayerInfo = KGCPlayer.GCPlayerGetInfo(nPlayerId)
      tbPlayerInfo.szGateway = szGateway
      GlobalGCExcute(-1, { "Player.tbGlobalFriends:global_gc_OnQureyGateway", szSrcName, szName, tbPlayerInfo })
    end
  end
end

-- Máy chủ toàn cục nhận phản hồi từ các GC về yêu cầu truy vấn cổng
function tbGlobalFriends:global_gc_OnQureyGateway(szSrcName, szName, tbPlayerInfo)
  local nSrcPlayerServer = GCGetPlayerOnlineServer(szSrcName)
  if nSrcPlayerServer > 0 then
    GSExcute(nSrcPlayerServer, { "Player.tbGlobalFriends:gs_OnFoundGateway", szSrcName, szName, tbPlayerInfo })
  else
    GlobalGCExcute(-1, { "Player.tbGlobalFriends:gc_OnFoundGateway", szSrcName, szName, tbPlayerInfo })
  end
end

-- GC nhận kết quả truy vấn được gửi về từ máy chủ toàn cục
function tbGlobalFriends:gc_OnFoundGateway(szSrcName, szName, tbPlayerInfo)
  local nSrcPlayerServer = GCGetPlayerOnlineServer(szSrcName)
  if nSrcPlayerServer > 0 then
    GSExcute(nSrcPlayerServer, { "Player.tbGlobalFriends:gs_OnFoundGateway", szSrcName, szName, tbPlayerInfo })
  end
end

-- GS nhận kết quả truy vấn từ GC
function tbGlobalFriends:gs_OnFoundGateway(szSrcName, szName, tbPlayerInfo)
  local pPlayer = KPlayer.GetPlayerByName(szSrcName)
  if pPlayer == nil then
    return
  end
  pPlayer.GlobalFriends_SetGateway(szName, tbPlayerInfo.szGateway)
  tbPlayerInfo.nPortrait = 1
  pPlayer.CallClientScript({ "Player.tbGlobalFriends:SetPlayerInfo", szName, tbPlayerInfo })
end

function tbGlobalFriends:SetPlayerInfo(szName, tbPlayerInfo)
  self.tbPlayerInfo[szName] = tbPlayerInfo
end

function tbGlobalFriends:gs_OnPlayerLogin()
  GCExcute({ "Player.tbGlobalFriends:gc_OnPlayerLogin", me.szName })
end

-- Người chơi đăng nhập, lấy dữ liệu từ bộ nhớ đệm
function tbGlobalFriends:gc_OnPlayerLogin(szName)
  if self.tbCache[szName] == nil or type(self.tbCache[szName]) ~= "table" then
    return
  end
  for _k, _v in ipairs(self.tbCache[szName]) do
    self:gc_ApplyAddFriend(szName, _v)
  end
  self.tbCache[szName] = nil
  SetGblIntBuf(GBLINTBUF_GLOBALFRIEND, 0, 1, self.tbCache)
end

-- gc của server gốc nhận dữ liệu bộ nhớ đệm từ global
function tbGlobalFriends:gc_AddFriendCache(szSrcName, szDstName)
  local nSrcPlayerId = KGCPlayer.GetPlayerIdByName(szSrcName)
  if nSrcPlayerId == nil or nSrcPlayerId < 0 then
    return
  end
  self.tbCache[szSrcName] = self.tbCache[szSrcName] or {}
  self.tbCache[szSrcName].nTime = GetTime()
  table.insert(self.tbCache[szSrcName], szDstName)
  SetGblIntBuf(GBLINTBUF_GLOBALFRIEND, 0, 1, self.tbCache)
end

-- gc khởi động, tải bộ nhớ đệm liên server
function tbGlobalFriends:gc_InitCache()
  local tbLoadBuf = GetGblIntBuf(GBLINTBUF_GLOBALFRIEND, 0)
  if tbLoadBuf ~= nil then
    self.tbCache = tbLoadBuf
  end
  print("gc_InitCache ", self.tbCache)
  -- Xóa dữ liệu đã hết hạn
  local nNow = GetTime()
  local nExpire = 60 * 60 * 24 * 30 -- Hết hạn sau 30 ngày
  local tbDelete = {}
  for _k, _v in pairs(self.tbCache) do
    if nNow - _v.nTime > nExpire then
      table.insert(tbDelete, _k)
    end
  end
  for _k, _v in pairs(tbDelete) do
    self.tbCache[_v] = nil
  end
end

-- Thao tác gộp server cho bạn bè liên server
function tbGlobalFriends:MergeGlobalFriends(tbCache2)
  print("MergeGlobalFriends start!!")
  local tbLocalCache = GetGblIntBuf(GBLINTBUF_GLOBALFRIEND, 0) or {}
  for _k, _v in pairs(tbCache2) do
    tbLocalCache[_k] = _v
  end
  self.tbCache = tbLocalCache
  SetGblIntBuf(GBLINTBUF_GLOBALFRIEND, 0, 1, self.tbCache)
  print("MergeGlobalFriends end!!")
end

if GCEvent ~= nil and GCEvent.RegisterGCServerStartFunc ~= nil then
  GCEvent:RegisterGCServerStartFunc(tbGlobalFriends.gc_InitCache, tbGlobalFriends)
end
