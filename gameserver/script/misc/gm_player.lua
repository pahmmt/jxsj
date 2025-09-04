-- Tên file　：gm_player.lua
-- Người tạo　：FanZai
-- Thời gian tạo：2008-10-10 12:21:04
-- Mô tả file：Lệnh GM——Thao tác nhiều người chơi

local tbGmPlayer = GM.tbPlayer or {}

GM.tbPlayer = tbGmPlayer

tbGmPlayer.MAX_RECENTPLAYER = 5 -- Danh sách người chơi đã thao tác gần đây

tbGmPlayer.tbRemoteList = {} -- Danh sách người chơi toàn server, làm mới mỗi khi mở menu chính

function tbGmPlayer:Main()
  local tbOpt = {
    { "Xuất danh sách người chơi", self.OutputAllPlayer, self },
    { "Triệu hồi tất cả người chơi", self.ComeHereAll, self },
    { "Chọn người chơi để thao tác", self.ListAllPlayer, self },
  }

  -- Người chơi đã thao tác gần đây
  local tbRecentPlayerList = me.GetTempTable("GM").tbRecentPlayerList or {}
  for nIndex, nPlayerId in ipairs(tbRecentPlayerList) do
    local tbInfo = self.tbRemoteList[nPlayerId]
    if tbInfo then
      tbOpt[#tbOpt + 1] = { "<color=green>" .. tbInfo[1], self.SelectPlayer, self, nPlayerId, tbInfo[1] }
    end
  end
  tbOpt[#tbOpt + 1] = { "<color=gray>Kết thúc đối thoại" }

  Dialog:Say("Ngươi muốn làm gì?<pic=20>", tbOpt)

  -- Cập nhật danh sách người chơi toàn server
  self.tbRemoteList = {}
  GlobalExcute({ "GM.tbPlayer:RemoteList_Fetch", me.nId })

  -- Mỗi lần đều tải lại script này
  DoScript("\\script\\misc\\gm_player.lua")
end

function tbGmPlayer:OutputAllPlayer()
  me.Msg(" ", "Danh sách người chơi trên server hiện tại")
  for nPlayerId, tbInfo in pairs(self.tbRemoteList) do
    local szMsg = string.format("Cấp %d %s %s", tbInfo[2], Player:GetFactionRouteName(tbInfo[3], tbInfo[4]), GetMapNameFormId(tbInfo[5]))
    me.Msg(szMsg, tbInfo[1])
  end
end

function tbGmPlayer:ComeHereAll()
  local nMapId, nMapX, nMapY = me.GetWorldPos()
  me.Msg("Tất cả tập hợp!")
  self:RemoteCall_ApplyAll("me.NewWorld", nMapId, nMapX, nMapY)
end

function tbGmPlayer:ListAllPlayer()
  local tbOpt = {}
  for nPlayerId, tbInfo in pairs(self.tbRemoteList) do
    tbOpt[#tbOpt + 1] = { "<color=green>" .. tbInfo[1], self.SelectPlayer, self, nPlayerId, tbInfo[1] }
  end
  tbOpt[#tbOpt + 1] = { "<color=gray>Kết thúc đối thoại" }
  Dialog:Say("Ngươi muốn tìm ai?<pic=58>", tbOpt)
end

function tbGmPlayer:SelectPlayer(nPlayerId, szPlayerName)
  -- Chèn người chơi đã thao tác gần đây
  local tbPlayerData = me.GetTempTable("GM")
  local tbRecentPlayerList = tbPlayerData.tbRecentPlayerList or {}
  tbPlayerData.tbRecentPlayerList = tbRecentPlayerList
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

  local tbInfo = self.tbRemoteList[nPlayerId]
  if not tbInfo then
    me.Msg(string.format("[%s] đã biến mất không dấu vết...", szPlayerName))
    return
  end

  local szMsg = string.format("Tên：%s\nCấp độ：%d\nHệ phái：%s\nVị trí：%s", tbInfo[1], tbInfo[2], Player:GetFactionRouteName(tbInfo[3], tbInfo[4]), GetMapNameFormId(tbInfo[5]))

  Dialog:Say(szMsg, { "Kéo hắn đến đây", self.CallSomeoneHere, self, nPlayerId }, { "Dịch chuyển ta qua đó", self.RemoteCall_ApplyOne, self, nPlayerId, "GM.tbPlayer:CallSomeoneHere", me.nId }, { "Kick hắn khỏi game", self.RemoteCall_ApplyOne, self, nPlayerId, "me.KickOut" }, { "<color=gray>Kết thúc đối thoại" })
end

function tbGmPlayer:CallSomeoneHere(nPlayerId)
  local nMapId, nMapX, nMapY = me.GetWorldPos()
  self:RemoteCall_ApplyOne(nPlayerId, "me.NewWorld", nMapId, nMapX, nMapY)
end

--== Danh sách người chơi toàn server ==--
-- Gửi danh sách người chơi của server này đi
function tbGmPlayer:RemoteList_Fetch(nToPlayerId)
  local tbLocalPlayer = KPlayer.GetAllPlayer()
  local tbRemoteList = {}
  for _, pPlayer in pairs(tbLocalPlayer) do
    tbRemoteList[pPlayer.nId] = {
      pPlayer.szName,
      pPlayer.nLevel,
      pPlayer.nFaction,
      pPlayer.nRouteId,
      pPlayer.nMapId,
    }
  end
  GlobalExcute({ "GM.tbPlayer:RemoteList_Receive", nToPlayerId, tbRemoteList })
end
-- Nhận danh sách người chơi được gửi về
function tbGmPlayer:RemoteList_Receive(nToPlayerId, tbRemoteList)
  local pPlayer = KPlayer.GetPlayerObjById(nToPlayerId)
  if not pPlayer then
    return
  end
  for nPlayerId, tbInfo in pairs(tbRemoteList) do
    self.tbRemoteList[nPlayerId] = tbInfo
  end
end

--== Thực thi trên toàn server/một người chơi ==--
-- Yêu cầu thực thi cho toàn bộ người chơi trên server
function tbGmPlayer:RemoteCall_ApplyAll(...)
  GlobalExcute({ "GM.tbPlayer:RemoteCall_DoAll", arg })
end
-- Thực thi cho người chơi trên server này
function tbGmPlayer:RemoteCall_DoAll(tbCallBack)
  local tbLocalPlayer = KPlayer.GetAllPlayer()
  for _, pPlayer in pairs(tbLocalPlayer) do
    pPlayer.Call(unpack(tbCallBack))
  end
end
-- Yêu cầu thực thi cho một người chơi
function tbGmPlayer:RemoteCall_ApplyOne(nToPlayerId, ...)
  GlobalExcute({ "GM.tbPlayer:RemoteCall_DoOne", nToPlayerId, arg })
end
-- Thực thi cho người chơi trên server này
function tbGmPlayer:RemoteCall_DoOne(nToPlayerId, tbCallBack)
  local pPlayer = KPlayer.GetPlayerObjById(nToPlayerId)
  if pPlayer then
    pPlayer.Call(unpack(tbCallBack))
  end
end

--Lệnh tắt GM
function tbGmPlayer:GMShortcutailasCmd()
  local szMsg = "Xin chào!! Đây là một số công cụ GM thường dùng, ngươi muốn làm gì???\n\nFile script của tính năng này nằm ở: script\\misc\\gm_player.lua"
  local tbOpt = {
    { "Tạo danh sách server", self.CreateServerList, self },
    { "Tạo danh sách nhiệm vụ", self.CreateTaskList, self },
    { "Tạo danh sách thành tựu", self.CreateAchievementList, self },
    { "Không có gì" },
  }
  Dialog:Say(szMsg, tbOpt)
end

--Nhiệm vụ
function tbGmPlayer:CreateTaskList()
  me.CallClientScript({ "ServerEvent:CreateTaskList" })
end

--Thành tựu
function tbGmPlayer:CreateAchievementList()
  me.CallClientScript({ "ServerEvent:CreateAchievementList" })
end

--Tạo danh sách server
function tbGmPlayer:CreateServerList(nFlag)
  if not nFlag then
    local szMsg = "  Vui lòng đặt file serverlist.ini đã tải từ trang web vào thư mục client theo đường dẫn sau: \\setting\\serverlist.ini\n\nNếu đã đặt xong, có muốn tạo serverlistcfg.txt ngay bây giờ không?\n\nTạo tăng thêm: Đọc file gói, giữ lại server cũ làm server chính.\nTạo mới hoàn toàn: Không đọc file gói, tạo mới hoàn toàn theo danh sách."
    local tbOpt = {
      { "Tải danh sách", self.DownLoadServerList, self },
      { "Xác nhận tạo (Tăng thêm) - Đề nghị", self.CreateServerList, self, 1 },
      { "Xác nhận tạo (Mới hoàn toàn)", self.CreateServerList, self, 2 },
      { "Trở về", self.GMShortcutailasCmd, self },
    }
    Dialog:Say(szMsg, tbOpt)
    return 0
  end
  if nFlag == 1 then
    me.CallClientScript({ "ServerEvent:CSList_Modiff", "\\setting\\serverlist.ini" })
  else
    me.CallClientScript({ "ServerEvent:CSList", "\\setting\\serverlist.ini" })
  end
end

function tbGmPlayer:DownLoadServerList()
  me.CallClientScript({ "OpenWebSite", "http://jxsj.autoupdate.kingsoft.com/jxsj/serverlist/serverlist.ini" })
  local szMsg = "Đã mở và tải danh sách server mới nhất qua trình duyệt IE, vui lòng lưu vào thư mục client theo đường dẫn sau: \\setting\\serverlist.ini\n\nTôi đã lưu xong, có muốn tạo ngay file cấu hình danh sách server mới nhất không?"
  local tbOpt = {
    { "Xác nhận tạo", self.CreateServerList, self, 1 },
    { "Trở về", self.GMShortcutailasCmd, self },
  }
  Dialog:Say(szMsg, tbOpt)
end
