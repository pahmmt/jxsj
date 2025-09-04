-- Thẻ GM

local tbGMCard = Item:GetClass("gmcard")

tbGMCard.MAX_RECENTPLAYER = 15

function tbGMCard:OnUse()
  local nIsHide = GM.tbGMRole:IsHide()

  local tbOpt = {
    { (nIsHide == 1 and "Hủy ẩn thân") or "Bắt đầu ẩn thân", "GM.tbGMRole:SetHide", 1 - nIsHide },
    { "Nhập tên nhân vật", self.AskRoleName, self },
    { "Người chơi xung quanh", self.AroundPlayer, self },
    { "Người chơi gần đây", self.RecentPlayer, self },
    { "Điều chỉnh cấp bản thân", self.AdjustLevel, self },
    --{"Tải lại kịch bản [Tạm]", self.Reload, self},
    { "<color=yellow>Phóng viên Thi Đấu Liên SV<color>", self.LookGlbBattle, self },
    { "<color=yellow>Hoàng Lăng vô hạn<color>", self.SuperQinling, self },
    { "<color=yellow>Quan sát viên Lâu Lan Cổ Thành<color>", Atlantis.PlayerEnter, Atlantis },
    { "Kết thúc đối thoại" },
  }

  Dialog:Say("\n  Các bạn GM đã vất vả rồi! <pic=28>\n\n      ~~Vì nhân dân phục vụ<pic=98><pic=98><pic=98>", tbOpt)

  return 0
end

function tbGMCard:SuperQinling()
  me.NewWorld(1536, 1567, 3629)
  me.SetTask(2098, 1, 0)
  me.AddSkillState(1413, 4, 1, 2 * 60 * 60 * Env.GAME_FPS, 1, 1)
end

function tbGMCard:Reload()
  local nRet1 = DoScript("\\script\\item\\class\\gmcard.lua")
  local nRet2 = DoScript("\\script\\misc\\gm_role.lua")
  GCExcute({ "DoScript", "\\script\\misc\\gm_role.lua" })
  local szMsg = "Reloaded!!(" .. nRet1 .. "," .. nRet2 .. GetLocalDate(") %Y-%m-%d %H:%M:%S")
  me.Msg(szMsg)
  print(szMsg)
end

function tbGMCard:AskRoleName()
  Dialog:AskString("Tên nhân vật", 16, self.OnInputRoleName, self)
end

function tbGMCard:OnInputRoleName(szRoleName)
  local nPlayerId = KGCPlayer.GetPlayerIdByName(szRoleName)
  if not nPlayerId then
    Dialog:Say("Tên nhân vật này không tồn tại!", { "Nhập lại", self.AskRoleName, self }, { "Kết thúc đối thoại" })
    return
  end

  self:ViewPlayer(nPlayerId)
end

function tbGMCard:ViewPlayer(nPlayerId)
  -- Chèn vào danh sách người chơi gần đây
  local tbRecentPlayerList = self.tbRecentPlayerList or {}
  self.tbRecentPlayerList = tbRecentPlayerList
  for nIndex, nRecentPlayerId in ipairs(tbRecentPlayerList) do
    if nRecentPlayerId == nPlayerId then
      table.remove(tbRecentPlayerList, nIndex)
      break
    end
  end
  if #tbRecentPlayerList >= self.MAX_RECENTPLAYER then
    table.remove(tbRecentPlayerList)
  end
  table.insert(tbRecentPlayerList, 1, nPlayerId)

  local szName = KGCPlayer.GetPlayerName(nPlayerId)
  local tbInfo = GetPlayerInfoForLadderGC(szName)
  local tbState = {
    [0] = "Không online",
    [-1] = "Đang xử lý",
    [-2] = "Treo máy?",
  }
  local nState = KGCPlayer.OptGetTask(nPlayerId, KGCPlayer.TSK_ONLINESERVER)
  local tbText = {
    { "Tên", szName },
    { "Tài khoản", tbInfo.szAccount },
    { "Cấp", tbInfo.nLevel },
    { "Giới tính", (tbInfo.nSex == 1 and "Nữ") or "Nam" },
    { "Hệ phái", Player:GetFactionRouteName(tbInfo.nFaction, tbInfo.nRoute) },
    { "Gia tộc", tbInfo.szKinName },
    { "Bang hội", tbInfo.szTongName },
    { "Uy danh", KGCPlayer.GetPlayerPrestige(nPlayerId) },
    { "Trạng thái", (tbState[nState] or "<color=green>Online<color>") .. "(" .. nState .. ")" },
  }
  local szMsg = ""
  for _, tb in ipairs(tbText) do
    szMsg = szMsg .. "\n  " .. Lib:StrFillL(tb[1], 6) .. tostring(tb[2])
  end
  local szButtonColor = (nState > 0 and "") or "<color=gray>"
  local tbOpt = {
    { szButtonColor .. "Kéo người chơi lại đây", "GM.tbGMRole:CallHimHere", nPlayerId },
    { szButtonColor .. "Dịch chuyển đến đó", "GM.tbGMRole:SendMeThere", nPlayerId },
    { szButtonColor .. "Kick offline", "GM.tbGMRole:KickHim", nPlayerId },
    { "Nhốt vào Thiên Lao", "GM.tbGMRole:ArrestHim", nPlayerId },
    { "Thả khỏi Thiên Lao", "GM.tbGMRole:FreeHim", nPlayerId },
    { "Gửi thư", self.SendMail, self, nPlayerId },
    { "Kết thúc đối thoại" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbGMCard:RecentPlayer()
  local tbOpt = {}
  for nIndex, nPlayerId in ipairs(self.tbRecentPlayerList or {}) do
    local szName = KGCPlayer.GetPlayerName(nPlayerId)
    local nState = KGCPlayer.OptGetTask(nPlayerId, KGCPlayer.TSK_ONLINESERVER)
    tbOpt[#tbOpt + 1] = { ((nState > 0 and "<color=green>") or "") .. szName, self.ViewPlayer, self, nPlayerId }
  end
  tbOpt[#tbOpt + 1] = { "Kết thúc đối thoại" }

  Dialog:Say("Vui lòng chọn người chơi：", tbOpt)
end

function tbGMCard:AroundPlayer()
  local tbPlayer = {}
  local _, nMyMapX, nMyMapY = me.GetWorldPos()
  for _, pPlayer in ipairs(KPlayer.GetAroundPlayerList(me.nId, 50)) do
    if pPlayer.szName ~= me.szName then
      local _, nMapX, nMapY = pPlayer.GetWorldPos()
      local nDistance = (nMapX - nMyMapX) ^ 2 + (nMapY - nMyMapY) ^ 2
      tbPlayer[#tbPlayer + 1] = { nDistance, pPlayer }
    end
  end
  local function fnLess(tb1, tb2)
    return tb1[1] < tb2[1]
  end
  table.sort(tbPlayer, fnLess)
  local tbOpt = {}
  for _, tb in ipairs(tbPlayer) do
    local pPlayer = tb[2]
    tbOpt[#tbOpt + 1] = { pPlayer.szName, self.ViewPlayer, self, pPlayer.nId }
    if #tbOpt >= 8 then
      break
    end
  end
  tbOpt[#tbOpt + 1] = { "Kết thúc đối thoại" }

  Dialog:Say("Vui lòng chọn người chơi：", tbOpt)
end

function tbGMCard:AdjustLevel()
  local nMaxLevel = GM.tbGMRole:GetMaxAdjustLevel()
  Dialog:AskNumber("Cấp độ mong muốn (1~" .. nMaxLevel .. ")", nMaxLevel, "GM.tbGMRole:AdjustLevel")
end

function tbGMCard:SendMail(nPlayerId)
  Dialog:AskString("Nội dung thư", 500, "GM.tbGMRole:SendMail", nPlayerId)
end

function tbGMCard:LookGlbBattle()
  if not GLOBAL_AGENT then
    local szMsg = "Lối vào phóng viên Thi Đấu Liên SV<pic=98><pic=98><pic=98>"
    local tbOpt = {
      { "Vào Đảo Anh Hùng", self.EnterGlobalServer, self },
      { "Bạch Hổ Đường Liên Server", self.LookKuaFuBaiHu, self },
      { "Chờ một lát" },
    }
    Dialog:Say(szMsg, tbOpt)
    return 0
  end
  local szMsg = "Lối vào phóng viên Thi Đấu Liên SV<pic=98><pic=98><pic=98>"
  local tbOpt = {
    { "Trở về Đảo Anh Hùng", self.ReturnGlobalServer, self },
    { "Trở về Lâm An Phủ", self.ReturnMyServer, self },
    { "Xem chung kết Võ Lâm Đại Hội", self.LookWldh, self },
    { "Xem trận chiến Thiết Phù Thành", self.LookXkland, self },
    { "Bạch Hổ Đường Liên Server", self.LookKuaFuBaiHu, self },
    { "Chờ một lát" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbGMCard:LookWldh()
  local szMsg = "Lối vào phóng viên Thi Đấu Liên SV<pic=98><pic=98><pic=98>"
  local tbOpt = {
    { "Xem chung kết đơn đấu", self.Wldh_SelectFaction, self },
    { "Xem chung kết song đấu", self.Wldh_SelectVsState, self, 2, 1 },
    { "Xem chung kết tam đấu", self.Wldh_SelectVsState, self, 3, 1 },
    { "Xem chung kết ngũ đấu", self.Wldh_SelectVsState, self, 4, 1 },
    { "Xem chung kết tổ đội", self.Wldh_SelectBattleVsState, self },
    { "Chờ một lát" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbGMCard:ReturnMyServer()
  me.GlobalTransfer(29, 1694, 4037)
end

function tbGMCard:Wldh_SelectBattleVsState()
  local szMsg = ""
  local tbOpt = {
    { "Sân chung kết tổ đội (Kim)", self.Wldh_EnterBattleMap, self, 1, 1 },
    { "Sân chung kết tổ đội (Tống)", self.Wldh_EnterBattleMap, self, 1, 2 },
    { "Sân tứ kết tổ đội (Kim 1)", self.Wldh_EnterBattleMap, self, 1, 1 },
    { "Sân tứ kết tổ đội (Tống 1)", self.Wldh_EnterBattleMap, self, 1, 2 },
    { "Sân tứ kết tổ đội (Kim 2)", self.Wldh_EnterBattleMap, self, 2, 1 },
    { "Sân tứ kết tổ đội (Tống 2)", self.Wldh_EnterBattleMap, self, 2, 2 },
    { "Quay lại", self.LookWldh, self },
    { "Kết thúc đối thoại" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbGMCard:Wldh_EnterBattleMap(nAreaId, nCamp)
  local tbMap = {
    [1] = 1631,
    [2] = 1632,
  }
  local tbPos = {
    [1] = { 1767, 2977 },
    [2] = { 1547, 3512 },
  }
  local nMapId = tbMap[nAreaId]

  me.NewWorld(nMapId, unpack(tbPos[nCamp]))
end

function tbGMCard:Wldh_SelectFaction()
  local szMsg = "Vui lòng chọn môn phái bạn muốn xem?"
  local tbOpt = {}
  for i = 1, Env.FACTION_NUM do
    table.insert(tbOpt, { Player:GetFactionRouteName(i) .. " chung kết", self.Wldh_SelectVsState, self, 1, i })
  end

  table.insert(tbOpt, { "Quay lại", self.LookWldh, self })
  table.insert(tbOpt, { "Để ta suy nghĩ lại" })
  Dialog:Say(szMsg, tbOpt)
end

function tbGMCard:Wldh_SelectVsState(nType, nReadyId)
  local szMsg = "Vui lòng chọn giải đấu bạn muốn xem?"
  local tbOpt = {
    { "Sân chung kết", self.Wldh_SelectPkMap, self, nType, nReadyId, 1 },
    { "Sân tứ kết", self.Wldh_SelectPkMap, self, nType, nReadyId, 2 },
    { "Sân bát kết", self.Wldh_SelectPkMap, self, nType, nReadyId, 4 },
    { "Sân 16 đội", self.Wldh_SelectPkMap, self, nType, nReadyId, 8 },
    { "Sân 32 đội", self.Wldh_SelectPkMap, self, nType, nReadyId, 16 },
    { "Quay lại", self.LookWldh, self },
    { "Kết thúc đối thoại" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbGMCard:Wldh_SelectPkMap(nType, nReadyId, nMapCount)
  local szMsg = "Vui lòng chọn đấu trường bạn muốn xem?"
  local tbOpt = {}
  for i = 1, nMapCount do
    local szSelect = string.format("Đấu trường (%s)", i)
    table.insert(tbOpt, { szSelect, self.Wldh_EnterPkMap, self, nType, nReadyId, i })
  end
  table.insert(tbOpt, { "Quay lại", self.LookWldh, self })
  table.insert(tbOpt, { "Để ta suy nghĩ lại" })
  Dialog:Say(szMsg, tbOpt)
end

function tbGMCard:Wldh_EnterPkMap(nType, nReadyId, nAearId)
  local nMapId = Wldh:GetMapMacthTable(nType)[nReadyId]
  local nPosX, nPosY = unpack(Wldh:GetMapPKPosTable(nType)[nAearId])
  me.NewWorld(nMapId, nPosX, nPosY)
end

function tbGMCard:EnterGlobalServer()
  Transfer:NewWorld2GlobalMap(me)
end

function tbGMCard:ReturnGlobalServer()
  Transfer:NewWorld2GlobalMap(me)
end

function tbGMCard:LookXkland(nFrom)
  if Newland:GetWarState() == Newland.WAR_END then
    Dialog:Say("Chiến trường Thiết Phù Thành chưa bắt đầu, vui lòng quay lại sau.<enter><color=gold>Chi tiết nhấn F12->Trợ giúp chi tiết->Truy vấn công thành chiến liên server<color>")
    return 0
  end

  local tbOpt = {}
  local szMsg = "Vui lòng chọn bang hội muốn xem?"
  local nCount = 8
  local nLast = nFrom or 1
  for i = nLast, #Newland.tbGroupBuffer do
    table.insert(tbOpt, { Newland.tbGroupBuffer[i].szTongName, self.SelectLookTong, self, i })
    nCount = nCount - 1
    nLast = nLast + 1
    if nCount <= 0 then
      table.insert(tbOpt, { "Trang sau", self.LookXkland, self, nLast })
      break
    end
  end

  table.insert(tbOpt, { "Ta đã biết" })
  Dialog:Say(szMsg, tbOpt)
end

function tbGMCard:SelectLookTong(nGroupIndex)
  local nMapId = Newland:GetLevelMapIdByIndex(nGroupIndex, 1)
  local tbTree = Newland:GetMapTreeByIndex(nGroupIndex)
  if nMapId and tbTree then
    local nMapX, nMapY = unpack(Newland.REVIVAL_LIST[tbTree[0]])
    me.SetTask(Newland.TASK_GID, Newland.TASK_GROUP_INDEX, nGroupIndex)
    me.NewWorld(nMapId, nMapX, nMapY)
  end
end

-------------Phóng viên Bạch Hổ Đường liên server--------------------------
function tbGMCard:LookKuaFuBaiHu()
  local szMsg = "Vui lòng chọn địa điểm muốn đến?"
  local tbOpt = {}
  tbOpt[1] = { "Vào phòng chờ", self.LookKuaFuBaiHuWaitMap, self }
  tbOpt[2] = { "Vào chiến trường", self.LookKuaFuBaiHuFightMap, self }
  tbOpt[3] = { "Kết thúc đối thoại" }
  Dialog:Say(szMsg, tbOpt)
end

function tbGMCard:LookKuaFuBaiHuWaitMap()
  local szMsg = "Vui lòng chọn phòng chờ muốn vào?"
  local tbOpt = {}
  local nIndex = 1
  for nTbIndex, tbWaitMap in ipairs(KuaFuBaiHu.tbWaitMapIdList) do
    for nMapIndex, nMapId in ipairs(tbWaitMap) do
      local szInfo = string.format("Phòng chờ số %d", nIndex)
      table.insert(tbOpt, { szInfo, self.TransferBaiHuWaitMap, self, nTbIndex, nMapIndex })
      nIndex = nIndex + 1
    end
  end
  tbOpt[#tbOpt + 1] = { "Quay lại", self.LookKuaFuBaiHu, self }
  tbOpt[#tbOpt + 1] = { "Kết thúc đối thoại" }
  Dialog:Say(szMsg, tbOpt)
end

function tbGMCard:LookKuaFuBaiHuFightMap()
  local szMsg = "Vui lòng chọn chiến trường muốn vào?"
  local tbOpt = {}
  local nIndex = 1
  for nTbIndex, tbWaitMap in ipairs(KuaFuBaiHu.tbFightMapIdList) do
    for nMapIndex, nMapId in ipairs(tbWaitMap) do
      local szInfo = string.format("Chiến trường số %d", nIndex)
      table.insert(tbOpt, { szInfo, self.TransferBaiHuFightMap, self, nTbIndex, nMapIndex })
      nIndex = nIndex + 1
    end
  end
  tbOpt[#tbOpt + 1] = { "Quay lại", self.LookKuaFuBaiHu, self }
  tbOpt[#tbOpt + 1] = { "Kết thúc đối thoại" }
  Dialog:Say(szMsg, tbOpt)
end

function tbGMCard:TransferBaiHuWaitMap(nTbIndex, nIndex)
  local nMapId = KuaFuBaiHu.tbWaitMapIdList[nTbIndex][nIndex]
  local tbPos = KuaFuBaiHu.tbWaitMapPos[MathRandom(#KuaFuBaiHu.tbWaitMapPos)]
  if not nMapId then
    return 0
  end
  if GLOBAL_AGENT then
    local nCanSure = Map:CheckTagServerPlayerCount(nMapId)
    if nCanSure < 0 then
      me.Msg("Con đường phía trước không thông.", "Hệ thống")
      return 0
    end
    me.NewWorld(nMapId, tbPos.nX / 32, tbPos.nY / 32)
  else
    local nCanSure = Map:CheckGlobalPlayerCount(nMapId)
    if nCanSure < 0 then
      me.Msg("Con đường phía trước không thông.", "Hệ thống")
      return 0
    end
    me.GlobalTransfer(nMapId, tbPos.nX / 32, tbPos.nY / 32)
  end
end

function tbGMCard:TransferBaiHuFightMap(nTbIndex, nIndex)
  local nMapId = KuaFuBaiHu.tbFightMapIdList[nTbIndex][nIndex]
  local tbPos = KuaFuBaiHu.tbEnterPos[MathRandom(#KuaFuBaiHu.tbEnterPos)]
  if not nMapId then
    return 0
  end
  if GLOBAL_AGENT then
    local nCanSure = Map:CheckTagServerPlayerCount(nMapId)
    if nCanSure < 0 then
      me.Msg("Con đường phía trước không thông.", "Hệ thống")
      return 0
    end
    me.NewWorld(nMapId, tbPos.nX / 32, tbPos.nY / 32)
  else
    local nCanSure = Map:CheckGlobalPlayerCount(nMapId)
    if nCanSure < 0 then
      me.Msg("Con đường phía trước không thông.", "Hệ thống")
      return 0
    end
    me.GlobalTransfer(nMapId, tbPos.nX / 32, tbPos.nY / 32)
  end
end
