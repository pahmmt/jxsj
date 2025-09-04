-- Liên quan đến nhân vật GM

local tbGMRole = {}
GM.tbGMRole = tbGMRole

if MODULE_GAMESERVER then -- Tạm thời sao chép trực tiếp danh sách Ip trả về nội bộ
  Require("\\script\\misc\\jbreturn.lua")
  tbGMRole.tbPermitIp = Lib:CopyTB1(jbreturn.tbPermitIp)
end

tbGMRole.SKILLID_GMHIDE = 1462

-- Tạo nhân vật GM
function tbGMRole:MakeGmRole()
  me.AddLevel(5 - me.nLevel) -- Cấp ban đầu là 5

  me.SetCamp(6) -- Phe GM
  me.SetCurCamp(6)

  me.AddFightSkill(163, 60) -- Thang Vân Tung cấp 60
  me.AddFightSkill(91, 60) -- Ngân Ty Phi Chu cấp 60
  me.AddFightSkill(1417, 1) -- Di Hình Hoán Ảnh cấp 1

  me.SetExtRepState(1) --	Lệnh bài mở rộng rương x1 (đã sử dụng)

  me.AddItemEx(21, 8, 1, 1, { bForceBind = 1 }, 0) -- Túi 20 ô x3 (khóa)
  me.AddItemEx(21, 8, 1, 1, { bForceBind = 1 }, 0)
  me.AddItemEx(21, 8, 1, 1, { bForceBind = 1 }, 0)
  me.AddItemEx(18, 1, 195, 1, { bForceBind = 1 }, 0) -- Thần Hành Phù vô hạn (vĩnh viễn, khóa)
  me.AddItemEx(18, 1, 400, 1, { bForceBind = 1 }, 0) -- Thẻ GM chuyên dụng (vĩnh viễn, khóa)
  local pItem = me.AddItemEx(1, 13, 17, 1, { bForceBind = 1 }, 0) -- Mặt nạ Nhị Nha (vĩnh viễn, khóa)
  me.DelItemTimeout(pItem)
  pItem = me.AddItemEx(1, 13, 15, 1, { bForceBind = 1 }, 0) -- Mặt nạ Thánh Nữ Giáng Sinh (vĩnh viễn, khóa)
  me.DelItemTimeout(pItem)

  me.AddBindMoney(100000, 100)
end

-- Triệu hồi người nào đó đến đây
function tbGMRole:CallHimHere(nPlayerId)
  self:_CallSomeoneHere(me.nId, nPlayerId, string.format("Kéo người chơi (%s) đến vị trí hiện tại", KGCPlayer.GetPlayerName(nPlayerId)))
end

-- Dịch chuyển bản thân đến chỗ người nào đó
function tbGMRole:SendMeThere(nPlayerId)
  local szOperation = string.format("Dịch chuyển đến người chơi (%s)", KGCPlayer.GetPlayerName(nPlayerId))
  GM.tbGMRole:_ApplyPlayerCall(me.nId, szOperation, nPlayerId, "GM.tbGMRole:_CallSomeoneHere", me.nId, me.nId, szOperation)
end

-- Nhốt người nào đó vào Thiên Lao
function tbGMRole:ArrestHim(nPlayerId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if pPlayer then
    pPlayer.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, "GM bắt vào Thiên Lao")
  end
  self:_OnLineCmd(me.nId, string.format("Nhốt người chơi (%s) vào Thiên Lao", KGCPlayer.GetPlayerName(nPlayerId)), nPlayerId, "Player:Arrest(me.szName)")
end

-- Thả người nào đó khỏi Thiên Lao
function tbGMRole:FreeHim(nPlayerId)
  self:_OnLineCmd(me.nId, string.format("Thả người chơi (%s) khỏi Thiên Lao", KGCPlayer.GetPlayerName(nPlayerId)), nPlayerId, "Player:SetFree(me.szName)")
end

-- Kick người nào đó khỏi game
function tbGMRole:KickHim(nPlayerId)
  local szOperation = string.format("Kick người chơi (%s) khỏi game", KGCPlayer.GetPlayerName(nPlayerId))
  GM.tbGMRole:_ApplyPlayerCall(me.nId, szOperation, nPlayerId, "GM.tbGMRole:_KickMe", me.nId, szOperation)
end

-- Thử thực thi lệnh người chơi, nếu có lỗi sẽ có log
function tbGMRole:_ApplyPlayerCall(nGMPlayerId, szOperation, nPlayerId, ...)
  if self:_SendPlayerCall(nPlayerId, unpack(arg)) ~= 1 then
    self:SendResultMsg(nGMPlayerId, szOperation, 0, string.format("Người chơi (%s) không online", KGCPlayer.GetPlayerName(nPlayerId)))
  end
end

-- Thực thi lệnh offline của người chơi, và tạo ra kết quả thực thi
function tbGMRole:_OnLineCmd(nGMPlayerId, szOperation, nPlayerId, szScriptCmd)
  GCExcute({ "GM.tbGMRole:_OnLineCmd_GC", nGMPlayerId, szOperation, nPlayerId, szScriptCmd })
end
function tbGMRole:_OnLineCmd_GC(nGMPlayerId, szOperation, nPlayerId, szScriptCmd)
  local szName = KGCPlayer.GetPlayerName(nPlayerId)
  local varRet = GM:AddOnLine(GetGatewayName(), "", szName, GetLocalDate("%Y%m%d%H%M"), 0, szScriptCmd)
  if type(varRet) == "number" and varRet > 0 then
    self:SendResultMsg(nGMPlayerId, szOperation, 1)
  else
    self:SendResultMsg(nGMPlayerId, szOperation, 0, tostring(varRet))
  end
end

-- Gửi thao tác thực thi cho người chơi
function tbGMRole:_SendPlayerCall(nPlayerId, ...)
  local nState = KGCPlayer.OptGetTask(nPlayerId, KGCPlayer.TSK_ONLINESERVER)
  if nState <= 0 then
    return 0
  end

  GlobalExcute({ "GM.tbGMRole:_OnPlayerCall", nPlayerId, arg })

  return 1
end

-- Nhận thao tác thực thi của người chơi
function tbGMRole:_OnPlayerCall(nPlayerId, tbCallBack)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if pPlayer then
    pPlayer.Call(unpack(tbCallBack))
    self:DbgOut("_OnPlayerCall", pPlayer.szName, tostring(tbCallBack[1]))
  end
end

-- Ghi log script
function tbGMRole:ScriptLogF(pPlayer, ...)
  local szMsg = string.format(unpack(arg))
  Dbg:WriteLogEx(Dbg.LOG_INFO, "GM", "GM_ThaoTac", pPlayer.szName, szMsg)
end

-- Gửi tin nhắn kết quả thao tác GM và ghi log hỗ trợ khách hàng
function tbGMRole:SendResultMsg(nGMPlayerId, szOperation, bSuccess, szDetail)
  GM.tbGMRole:_SendPlayerCall(nGMPlayerId, "GM.tbGMRole:_OnResultMsg", szOperation, bSuccess, szDetail)
end
function tbGMRole:_OnResultMsg(szOperation, bSuccess, szDetail)
  local szMsg = ""
  if szOperation then
    szMsg = szMsg .. "[Thao tác] " .. szOperation .. "；"
  end
  if bSuccess then
    szMsg = szMsg .. "[Kết quả] " .. ((bSuccess == 1 and "Thành công") or "Thất bại") .. "；"
  end
  if szDetail then
    szMsg = szMsg .. "[Chi tiết] " .. szDetail .. "；"
  end
  me.PlayerLog(Log.emKPLAYERLOG_TYPE_GM_OPERATION, szMsg)
  self:ScriptLogF(me, szMsg)
  me.Msg(szMsg)
end

-- Có đang tàng hình không
function tbGMRole:IsHide()
  return me.IsHaveSkill(self.SKILLID_GMHIDE)
end

-- Thiết lập tàng hình
function tbGMRole:SetHide(nHide)
  if nHide == 1 then
    me.AddFightSkill(self.SKILLID_GMHIDE, 1)
  else
    me.DelFightSkill(self.SKILLID_GMHIDE)
  end
  self:SendResultMsg(me.nId, (nHide == 1 and "Bắt đầu tàng hình") or "Hủy tàng hình", 1)
end

-- Lấy cấp độ tối đa có thể thiết lập
function tbGMRole:GetMaxAdjustLevel()
  local nLadderLevel = 0
  local tbInfo = GetLadderPlayerInfoByRank(0x00020100, 10) -- Hạng 10 trên bảng xếp hạng
  if tbInfo then
    local _, _, Level = string.find(tbInfo.szContext, "(-?%d+)(.*)")
    nLadderLevel = tonumber(Level) or 0
  end
  return math.max(nLadderLevel, 10) -- Ít nhất có thể đạt đến cấp 10
end

-- Điều chỉnh cấp độ bản thân
function tbGMRole:AdjustLevel(nLevel)
  local szOperation = string.format("Thiết lập cấp độ đến %d", nLevel)
  local nMaxLevel = self:GetMaxAdjustLevel()
  if nLevel < 1 or nLevel > nMaxLevel then
    self:SendResultMsg(me.nId, szOperation, 0, string.format("Vượt quá phạm vi cấp độ cho phép (1~%d)", nMaxLevel))
    return
  end

  local szDetail = nil
  local nAddLevel = nLevel - me.nLevel
  if nAddLevel < 0 then
    if me.IsHaveSkill(91) then
      me.DelFightSkill(91) -- Ngân Ty Phi Chu
    end
    if me.IsHaveSkill(163) then
      me.DelFightSkill(163) -- Thang Vân Tung
    end
    if me.IsHaveSkill(1417) then
      me.DelFightSkill(1417) -- Di Hình Hoán Ảnh cấp 1
    end
    me.ResetFightSkillPoint() -- Tẩy lại điểm kỹ năng
    me.UnAssignPotential() -- Tẩy lại điểm tiềm năng
    me.Msg("<color=green>Bạn đã thực hiện thao tác giảm cấp, cần thoát ra đăng nhập lại. Nếu không hiển thị ở client sẽ có bất thường.")
    szDetail = "Thao tác giảm cấp, dẫn đến tẩy lại điểm kỹ năng, điểm tiềm năng"
  end
  me.AddLevel(nAddLevel)

  me.AddFightSkill(163, 60) -- Thang Vân Tung cấp 60
  me.AddFightSkill(91, 60) -- Ngân Ty Phi Chu cấp 60
  me.AddFightSkill(1417, 1) -- Di Hình Hoán Ảnh cấp 1

  self:SendResultMsg(me.nId, szOperation, 1, szDetail)
end

-- Khi GM vào bản đồ
function tbGMRole:OnEnterMap(nMapId)
  local szMsg = string.format("Đến bản đồ: %s(%d), trạng thái tàng hình: %d", GetMapNameFormId(nMapId), nMapId, self:IsHide())
  me.PlayerLog(Log.emKPLAYERLOG_TYPE_GM_OPERATION, szMsg)
  self:DbgOut(szMsg)
end

-- Khi GM đăng nhập
function tbGMRole:OnLogin(nMapId)
  if me.GetCamp() ~= 6 then
    return
  end

  local szIp = me.GetPlayerIpAddress()
  local nPos = string.find(szIp, ":")
  szIp = string.sub(szIp, 1, nPos - 1)
  if not self.tbPermitIp[szIp] then
    local szMsg = string.format("!!! Từ chối đăng nhập IP: %s", szIp)
    me.PlayerLog(Log.emKPLAYERLOG_TYPE_GM_OPERATION, szMsg)
    self:DbgOut(szMsg)
    me.KickOut()
  end
end

-- Gửi thư hệ thống
function tbGMRole:SendMail(nPlayerId, szContext)
  print(nPlayerId, szContext)
  local szName = KGCPlayer.GetPlayerName(nPlayerId)
  local szTitle = string.format("[%s]", me.szName)
  KPlayer.SendMail(szName, szTitle, szContext)

  self:SendResultMsg(me.nId, string.format("Gửi thư đến người chơi (%s)", szName), 1)
end

function tbGMRole:_CallSomeoneHere(nGMPlayerId, nPlayerId, szOperation)
  local nMapId, nMapX, nMapY = me.GetWorldPos()
  local szMapClass = GetMapType(nMapId) or ""
  if Map.tbMapItemState[szMapClass].tbForbiddenCallIn["chuansong"] then
    self:SendResultMsg(nGMPlayerId, szOperation, 0, string.format("Bản đồ (%s) của (%s) cấm dịch chuyển đến", GetMapNameFormId(nMapId), me.szName))
    return
  end
  GM.tbGMRole:_ApplyPlayerCall(nGMPlayerId, szOperation, nPlayerId, "GM.tbGMRole:_CallMePos", nGMPlayerId, nMapId, nMapX, nMapY, szOperation)
end

function tbGMRole:_CallMePos(nGMPlayerId, nMapId, nMapX, nMapY, szOperation)
  local szMapClass = GetMapType(me.nMapId) or ""
  if Item:IsCallOutAtMap(me.nMapId, "chuansong") ~= 1 then
    self:SendResultMsg(nGMPlayerId, szOperation, 0, string.format("Bản đồ (%s) của (%s) cấm dịch chuyển đi", GetMapNameFormId(nMapId), me.szName))
    return
  end
  self:SendResultMsg(nGMPlayerId, szOperation, 1)
  me.NewWorld(nMapId, nMapX, nMapY)
end

function tbGMRole:_KickMe(nGMPlayerId, szOperation)
  self:SendResultMsg(nGMPlayerId, szOperation, 1)
  me.KickOut()
end

-- Xuất debug
function tbGMRole:DbgOut(...)
  Dbg:Output("GM", unpack(arg))
end

-- Đăng ký Login
if MODULE_GAMESERVER and not GM.tbGMRole.bReged then
  local function fnOnLogin()
    GM.tbGMRole:OnLogin()
  end
  PlayerEvent:RegisterOnLoginEvent(fnOnLogin)
  GM.tbGMRole.bReged = 1
end

----------Kiểm tra-------------
function tbGMRole:AddPermitIp(szIp)
  if MODULE_GC_SERVER then
    GlobalExcute({ "GM.tbGMRole:AddPermitIp", szIp }) --Trạng thái quảng bá
    return
  end
  if szIp and #szIp ~= 0 then
    self.tbPermitIp[szIp] = 1
  end
end
