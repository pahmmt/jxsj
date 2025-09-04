Require("\\script\\player\\define.lua")
Require("\\script\\player\\playerevent.lua")
Require("\\script\\player\\playerschemeevent.lua")
Require("\\script\\player\\globalfriends.lua")

-- Hiệu suất cấp độ người chơi
Player.tbLevelEffect = { -- [Cấp độ/10] Hiệu suất (tỷ lệ)
  [1] = 0.2,
  [2] = 0.3,
  [3] = 0.4,
  [4] = 0.5,
  [5] = 0.6,
  [6] = 0.7,
  [7] = 0.8,
  [8] = 0.85,
  [9] = 0.9,
  [10] = 0.95,
  [11] = 1.0,
  [12] = 1.05,
  [13] = 1.1,
  [14] = 1.2,
  [15] = 1.2,
}
Player.bCanApplyJiesuo = 0
Player.bApplyingJiesuo = 0
Player.dwApplyJiesuoTime = 0
Player.nAccountSafeLevel = 60
Player.nAccountSafeHonour = 1500
Player.nAccountSafeMode = 0
Player.bForbid_GblSever_SpeRepair = 1

Player.COMEBACK_DOUBT_OLD = 1 -- Người chơi cũ bị nghi ngờ hack
Player.COMEBACK_DOUBT_NEW = 2 -- Người chơi mới bị nghi ngờ hack
Player.COMEBACK_YES_OLD = 3 -- Người chơi cũ bình thường
Player.COMEBACK_YES_NEW = 4 -- Người chơi mới bình thường
Player.COMEBACK_TSKGROUPID = 2082
Player.COMEBACK_TSKID_FLAG = 6
Player.COMEBACK_TSKID_LASTTIME = 7
Player.COMEBACK_TSKID_NOWTIME = 8

Player.COMSUME_CLEAR_PROMPT_DAY = 1225
Player.COMSUME_CLEAR_PROMPT_POINT = 500

Player.nOpenIpHandle = EventManager.IVER_bOpenIpHandle -- Bật hiển thị IP khi người chơi đăng nhập

Player.c2sFun = {} -- Bảng hàm gọi lại máy chủ

Player.tbTransferStatus = { 2219, 1 } -- Dấu hiệu liên server

-- Client nhận được thông báo có người đang cố gắng hồi sinh mình
function Player:OnGetCure(nLifeP, nManaP, nStaminaP)
  CoreEventNotify(UiNotify.emCOREEVENT_GET_CURE, nLifeP, nManaP, nStaminaP)
end

function Player:OnFreezeCoin(pPlayer, nFlag, nCoin, nReason)
  if nFlag == 1 then
  --		pPlayer.Msg(string.format("Freeze:%d %d %d", nFlag, nCoin, nReason));
  elseif nFlag == 2 then
    --		pPlayer.Msg(string.format("UnFreeze:%d %d %d", nFlag, nCoin, nReason));
  end
  return 1
end

-------------------------------------------------------------------------
-- Kiểm tra tính hợp lệ của việc cộng điểm tiềm năng
function Player:CheckAssignPotential(nStrength, nDexterity, nVitality, nEnergy)
  -- Tính điểm tiềm năng sau khi cộng
  nStrength = math.max(me.nBaseStrength + nStrength, 0)
  nDexterity = math.max(me.nBaseDexterity + nDexterity, 0)
  nVitality = math.max(me.nBaseVitality + nVitality, 0)
  nEnergy = math.max(me.nBaseEnergy + nEnergy, 0)

  local nBaseTotal = me.nBaseStrength + me.nBaseDexterity + me.nBaseVitality + me.nBaseEnergy
  local nTotal = nBaseTotal + me.nRemainPotential

  -- Về lý thuyết, kết quả cuối cùng của bất kỳ điểm tiềm năng nào cũng không được vượt quá 60% tổng số
  -- Nhưng cần xem xét trường hợp tỷ lệ điểm tiềm năng ban đầu đã mất cân bằng (ví dụ: bị sửa đổi bằng lệnh GM), thì vẫn phải đảm bảo có thể cộng điểm bình thường.
  -- Lúc này, mục có tỷ lệ cao nhất không được tăng thêm trước khi tỷ lệ trở lại bình thường (tỷ lệ sau khi cộng điểm có thể vẫn cao hơn 60%), mục có tỷ lệ thấp phải đảm bảo tỷ lệ sau khi cộng điểm không cao hơn 60%

  if (nStrength / 0.6) > nTotal then -- Tỷ lệ sức mạnh sau khi cộng điểm không chính xác
    -- Nếu sức mạnh trước khi cộng điểm là chính xác, thì việc cộng điểm thất bại, nếu sức mạnh lại tăng thêm trước khi tỷ lệ không bình thường, cũng được coi là không chính xác
    if ((me.nBaseStrength / 0.6) > nTotal) and (me.nBaseStrength == nStrength) then
      return 1
    end
  elseif (nDexterity / 0.6) > nTotal then -- Tỷ lệ thân pháp sau khi cộng điểm không chính xác
    if ((me.nBaseDexterity / 0.6) > nTotal) and (me.nBaseDexterity == nDexterity) then
      return 1
    end
  elseif (nVitality / 0.6) > nTotal then -- Tỷ lệ ngoại công sau khi cộng điểm không chính xác
    if ((me.nBaseVitality / 0.6) > nTotal) and (me.nBaseVitality == nVitality) then
      return 1
    end
  elseif (nEnergy / 0.6) > nTotal then -- Tỷ lệ nội công sau khi cộng điểm không chính xác
    if ((me.nBaseEnergy / 0.6) > nTotal) and (me.nBaseEnergy == nEnergy) then
      return 1
    end
  else -- Tỷ lệ tiềm năng sau khi cộng điểm là bình thường
    return 1
  end

  return 0
end

-------------------------------------------------------------------------
-- Hàm này được gọi để trì hoãn khi người chơi thoát game trong trạng thái chiến đấu
function Player:DelayShutdown(bForce)
  if not bForce then
    bForce = 0
  end
  local nShutdownTime = me.GetDelayShutdownTime()
  if nShutdownTime ~= 0 then
    return
  end

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
  }
  GeneralProcess:StartProcess("Chuẩn bị thoát... di chuyển sẽ hủy", 10 * Env.GAME_FPS, { me.FinishDelayLogout, bForce }, { me.SetDelayShutdownTime, 0 }, tbEvent)

  me.SetDelayShutdownTime(GetFrame())
end

-------------------------------------------------------------------------
-- Người chơi hồi sinh
function Player:PreLocalRevive(szFun, nId)
  if me.IsDead() ~= 1 then
    return
  end
  local nReviveTime = 30
  if szFun == "SkillRevive" then
    nReviveTime = 5
  end
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
    Player.ProcessBreakEvent.emEVENT_ATTACKED,
    Player.ProcessBreakEvent.emEVENT_DEATH,
    Player.ProcessBreakEvent.emEVENT_LOGOUT,
    Player.ProcessBreakEvent.emEVENT_BUYITEM,
    Player.ProcessBreakEvent.emEVENT_SELLITEM,
    Player.ProcessBreakEvent.emEVENT_REVIVE,
  }

  GeneralProcess:StartProcess("Chuẩn bị hồi sinh", nReviveTime * Env.GAME_FPS, { Player[szFun], Player, nId }, nil, tbEvent)
end

function Player:CanBeRevived(pPlayer, nMapId, nReviveType)
  Setting:SetGlobalObj(pPlayer)
  local bRet, szMsg = Map:CanBeRevived(nMapId, nReviveType)
  Setting:RestoreGlobalObj()
  if bRet ~= 1 then
    pPlayer.Msg(szMsg)
    return 0
  end
  return 1
end

--Có thể hồi sinh về thành không
function Player:CanRemoteRevive()
  local bRet, szMsg = Map:CanBeRemoteRevive(me.nMapId)
  if bRet ~= 1 then
    me.Msg(szMsg)
    return 0
  end
  return 1
end

--Hồi sinh bằng vật phẩm
function Player:OnLocalRevive()
  if self:CanBeRevived(me, me.nMapId, 1) ~= 1 then
    return
  end

  if me.nLevel >= 30 then
    if me.GetItemCountInBags(18, 1, 24, 1) > 0 or me.GetItemCountInBags(18, 1, 268, 1) > 0 then
      self:ItemRevive(me.nId)
    else
      me.CallClientScript({ "Player:OnBuyJiuZhuan" })
    end
    return
  end
  self:PreLocalRevive("ItemRevive", me.nId)
end

function Player:ItemRevive(nId)
  local pPlayer = KPlayer.GetPlayerObjById(nId)
  assert(pPlayer)
  if pPlayer.IsDead() ~= 1 then
    return
  end

  if pPlayer.nLevel < 30 then
    pPlayer.OnLocalRevive()
    return
  end

  local bRet = pPlayer.ConsumeItemInBags(1, 18, 1, 268, 1)
  if bRet ~= 0 then
    bRet = pPlayer.ConsumeItemInBags(1, 18, 1, 24, 1)
  end

  if bRet == 0 then
    pPlayer.Msg(pPlayer.szName .. " đã dùng một viên Cửu Chuyển Tục Mệnh Hoàn, trị thương tại chỗ hoàn tất.")
    local nLostExp = me.GetDeathPunishExp()
    if nLostExp > 0 then --Bù lại kinh nghiệm đã mất
      me.AddExp(nLostExp)
      me.ClearDeathPunishExp()
    end
    pPlayer.OnLocalRevive()
    if KinBattle:CheckUseJiuZhuan(pPlayer) == 1 then
      KinBattle:OnUseJiuZhuan(pPlayer) --Giao diện sử dụng Cửu Chuyển trong Gia Tộc Chiến
    end
  end
end

--Hồi sinh bằng kỹ năng
function Player:PreSkillRevive(nSkillPlayerId)
  if me.IsDead() ~= 1 or nSkillPlayerId <= 0 then
    return
  end
  if self:CanBeRevived(me, me.nMapId, 2) ~= 1 then
    return
  end
  self:PreLocalRevive("SkillRevive", nSkillPlayerId)
end

function Player:SkillRevive(nSkillPlayerId)
  if me.IsDead() ~= 1 then
    return
  end
  local pSkillPlayer = KPlayer.GetPlayerObjById(nSkillPlayerId)
  if self:CanBeRevived(me, me.nMapId, 2) ~= 1 then
    return
  end
  me.Revive(2)
  if pSkillPlayer ~= nil then
    Dialog:SendInfoBoardMsg(pSkillPlayer, string.format("Ngươi đã chữa trị hồi phục cho %s bị trọng thương", me.szName))
    Dialog:SendInfoBoardMsg(me, string.format("Ngươi bị trọng thương đã được %s chữa trị hồi phục", pSkillPlayer.szName))
  end
end

function Player:TryOffline()
  return self.tbOffline:TryOffline()
end

-------------------------------------------------------------------------

-- Đăng ký PlayerTimer
--	Tham số: nWaitTime (số khung hình từ bây giờ), fnCallBack, varParam1, varParam2, ...
--	Trả về: nRegisterId
function Player:RegisterTimer(nWaitTime, ...)
  -- Gọi điều khiển Timer công cộng, đăng ký Timer
  local tbEvent = {
    nWaitTime = nWaitTime,
    tbCallBack = arg,
    szRegInfo = debug.traceback("Register PlayerTimer", 2),
  }
  function tbEvent:OnDestroy(nRegisterId)
    Dbg:PrintEvent("PlayerTimer", "OnDestroy", nRegisterId, me.szName) -- Thông báo cho mô-đun gỡ lỗi, PlayerTimer đã bị hủy
    local tbPlayerTimer = me.GetTempTable("Player").tbTimer or {}
    --assert(tbPlayerTimer[nRegisterId]); -- Tạm thời chú thích zounan
    tbPlayerTimer[nRegisterId] = nil
  end
  local nRegisterId = Timer:RegisterEx(tbEvent)

  -- Ghi lại tình hình đăng ký trong bảng tạm thời của người chơi
  local tbPlayerData = me.GetTempTable("Player")
  local tbPlayerTimer = tbPlayerData.tbTimer
  if not tbPlayerTimer then
    tbPlayerTimer = {}
    tbPlayerData.tbTimer = tbPlayerTimer
  end
  tbPlayerTimer[nRegisterId] = tbEvent

  -- Thông báo cho mô-đun gỡ lỗi, đăng ký PlayerTimer mới
  Dbg:PrintEvent("PlayerTimer", "Register", nRegisterId, nWaitTime, me.szName)

  return nRegisterId
end

-- Tắt PlayerTimer
function Player:CloseTimer(nRegisterId)
  Dbg:PrintEvent("PlayerTimer", "Close", nRegisterId, me.szName) -- Thông báo cho mô-đun gỡ lỗi, tắt PlayerTimer

  local tbPlayerTimer = me.GetTempTable("Player").tbTimer or {}
  assert(tbPlayerTimer[nRegisterId])
  Timer:Close(nRegisterId)
end

-- Thông báo cho client IP và địa điểm đăng nhập lần trước
function Player:LoginIpHandle(nIp)
  if not nIp then
    return
  end

  if self.nOpenIpHandle == 0 then
    return 0
  end

  local szLastIp = "Không rõ"
  local szLastArea = "Không rõ"
  local bFirstLogin = 1
  local nLastIp = me.GetTask(2063, 1)
  if nLastIp ~= 0 then
    bFirstLogin = 0
    szLastIp = Lib:IntIpToStrIp(nLastIp)
    szLastArea = GetIpAreaAddr(nLastIp)
  end

  local szCurIp = "Không rõ"
  local szCurArea = "Không rõ"
  me.SetTask(2063, 1, nIp)

  szCurIp = Lib:IntIpToStrIp(nIp)
  szCurArea = GetIpAreaAddr(nIp)

  local szWarning = ""
  if szCurArea ~= szLastArea and bFirstLogin ~= 1 then
    szWarning = "<color=red>Cảnh báo!<color>"
  end
  local nLimiLevel, nSpeLevel, nMonthLimit = jbreturn:GetRetLevel(me)
  if nLimiLevel > 0 then
    szWarning = ""
    szLastArea = "Trung Quốc"
  end
  local szTip = "IP lần trước: <color=yellow>" .. szLastIp .. " " .. szWarning .. " <color>\nĐịa điểm: <color=yellow>" .. szLastArea .. "<color>\nIP lần này: <color=yellow>" .. szCurIp .. " <color>\nĐịa điểm: <color=yellow>" .. szCurArea .. "<color>"

  if bFirstLogin ~= 1 then
    --me.CallClientScript({"PopoTip:ShowPopo", 19, szTip});
    me.CallClientScript({ "PopoTip:ShowLoginPopo", szTip }) -- Bong bóng nhắc nhở đăng nhập, GroupId=19
  end
end

-- Thời gian đăng nhập lần trước, tính bằng giây, không tính liên server
-- 注: 在OnLogin事件中此函数返回值可能不正常
function Player:GetLastLoginTime(pPlayer)
  return pPlayer.GetTask(2063, 2)
end

-------------------------------------------------------------------------
-- Sự kiện online chung
function Player:_OnLogin(bExchangeServerComing)
  ----Bắt đầu tải sự kiện ưu tiên
  if not GLOBAL_AGENT then
    Task:OnLogin()
    PlayerSchemeEvent:OnDailyEvent()
  end
  ----Kết thúc tải sự kiện ưu tiên

  self:_OnLoginOnly(bExchangeServerComing) --Sự kiện đăng nhập thuần túy
  self:_OnLoginCommon(bExchangeServerComing) --Đăng nhập và liên server
end

--Online chung, kích hoạt cả khi qua GS
function Player:_OnLoginCommon(bExchangeServerComing)
  --Làm mới cấp độ trang bị giảm, hiệu suất tiêu thụ lớn, sau này có thể điều chỉnh cơ chế làm mới trang bị
  if me.nLevel < 117 and me.GetSkillState(2859) > 0 then
    me.UpdateEquipInvalid()
    if bExchangeServerComing == 1 then
      me.CallClientScript({ "GM:DoCommand", [[me.UpdateEquipInvalid();]] })
    end
  end

  if GLOBAL_AGENT then
    --Nếu là máy chủ trung tâm, trả về trực tiếp；
    if self.bForbid_GblSever_SpeRepair == 1 then
      -- Máy chủ toàn cục cấm sửa chữa đặc biệt
      me.CallClientScript({ "Ui:ServerCall", "UI_SHOP", "OnSetForbidSpeRepair", 1 })
    end
    local nActiveAureId = me.GetTask(2062, 4)
    Dialog:SetActiveAuraId(me, nActiveAureId)
    return 0
  end

  if KPlayer.GetPlayerCount() >= KPlayer.GetMaxPlayerCount() then
    me.Msg("Số người trên máy chủ hiện tại quá đông, vui lòng chú ý giữ trạng thái online, nếu offline có thể không đăng nhập lại được.")
  end

  if self:IsFresh() == 1 then
    me.CallClientScript({ "me.AddSkillState", 390, 1, 1, 400000000, 1 })
    --Nếu là tân thủ, chế độ PK là 0;
    me.nPkModel = 0
  end
  local nActiveAureId = me.GetTask(2062, 4)
  Dialog:SetActiveAuraId(me, nActiveAureId)
  SpecialEvent.ActiveGift:AddCounts(me, 1) --Độ sôi nổi đăng nhập

  self:ResetDragonBallSate(me)
  --Sự kiện online của pet đồng hành
  if not GLOBAL_AGENT then
    Npc.tbFollowPartner:FollowPartnerLogin()
  end
end

--Chỉ đăng nhập, không tính qua GS
function Player:_OnLoginOnly(bExchangeServerComing)
  if bExchangeServerComing == 1 then
    return 0
  end
  -- Nhật ký
  if me.GetTask(2181, 3) <= 0 then
    me.SetTask(2181, 3, me.GetRoleCreateDate())
  end

  local szLoginIp = me.GetPlayerIpAddress() or "???"
  local szLogMsg = string.format("IP đăng nhập: %s，người chơi đăng nhập", szLoginIp)

  local nAddExp, nAddExp1, nAddExp2 = Player.tbOffline:GetAddExp(me)
  if nAddExp > 0 then
    local szMsg = string.format("Nhận %d kinh nghiệm ủy thác offline chưa nhận lần trước", nAddExp)
    szLogMsg = szLogMsg .. ", " .. szMsg
  end
  me.PlayerLog(Log.emKPLAYERLOG_TYPE_LOGIN, szLogMsg)

  if GLOBAL_AGENT then
    me.CallClientScript({ "SpecialEvent.tbMessagePush:SetOpenState", 0 })
    return 0
  end
  me.CallClientScript({ "SpecialEvent.tbMessagePush:SetOpenState", 1 })
  me.CheckXuanJingTimeOut(7)
  me.CallClientScript({ "Bank:LoginMsg" })

  -- Thông báo cho client IP và địa điểm đăng nhập lần trước
  self:LoginIpHandle(me.dwIp)

  --Ghi lại thời gian liên quan và giá trị tích lũy khi online
  self:RecordTimeAbort()

  --Nhắc nhở loại bảo vệ khóa đã được kích hoạt
  if me.IsAccountLock() == 1 then
    if me.IsAccountLockOpen() == 1 and me.GetPasspodMode() == Account.PASSPODMODE_ZPTOKEN then
      me.Msg("<color=yellow>Bạn đã kích hoạt Lệnh Bài Kingsoft<color>，nhân vật đang trong trạng thái bảo vệ khóa, vui lòng nhấp vào nút khóa tài khoản ở dưới bên trái ảnh đại diện nhân vật để mở khóa.")
    elseif me.IsAccountLockOpen() == 1 and me.GetPasspodMode() == Account.PASSPODMODE_ZPMATRIX then
      me.Msg("<color=yellow>Bạn đã kích hoạt Thẻ Bảo Mật Kingsoft<color>，nhân vật đang trong trạng thái bảo vệ khóa, vui lòng nhấp vào nút khóa tài khoản ở dưới bên trái ảnh đại diện nhân vật để mở khóa.")
    elseif me.IsAccountLockOpen() == 1 and me.GetPasspodMode() == 0 then
      me.Msg("<color=yellow>Bạn đã kích hoạt Khóa An Toàn<color>，nhân vật đang trong trạng thái bảo vệ khóa, vui lòng nhấp vào nút khóa tài khoản ở dưới bên trái ảnh đại diện nhân vật để mở khóa.")
    end
  end

  -- Nhắc nhở xóa điểm tích lũy cuối năm
  self:ConsumeClearPrompt()
  -- Ghi lại thời gian đăng nhập gần nhất của gia tộc khi online
  local nKinId = me.GetKinMember()
  if nKinId > 0 then
    Kin:UpdateLastLoginTime(nKinId)
  end

  if PlayerEvent.bOpenMovieFlag == 1 then
    if not GLOBAL_AGENT and me.GetTask(2204, 1) <= 0 then
      me.SetTask(2204, 1, 1) -- Dấu hiệu phát đoạn phim mở đầu
      me.CallClientScript({ "Ui:OnPlayMovie", 0 })
    end
  end

  -- Người mới nhận trực tiếp nhiệm vụ tân thủ
  if PlayerEvent.bOpenMovieFlag ~= 1 then
    Task:OnAskBeginnerTask() -- Do xung đột với đoạn phim mở đầu, đổi thành client thông báo cho server
  end

  -- TODO:liuchang Tạm thời thêm
  if me.GetSkillLevel(10) > 20 then
    me.AddFightSkill(10, 20)
  end

  self:UpdateFudaiLimit()

  Wlls:OnLogin() --Võ Lâm Liên Tái, online, tự động bổ sung phần thưởng.
  EPlatForm:OnLogin()
  Mission:LogOutRV() --Ngăn chặn chức năng mở khóa khi máy chủ ngừng hoạt động；

  self:ProcessAllReputeTitle(me)

  self.tbBuyJingHuo:OnLogin()

  --Làm mới phím tắt Đại Đào Sát
  DaTaoSha:ReFreshShotCutalias()

  if SpecialEvent.tbTequan:CheckFreeTeQuan() == 1 then
    me.CallClientScript({ "Tutorial:Login_OpenTimerProcessPlayerTutorial" })
  end

  -- Sau khi online tại máy chủ này, nên coi như offline trên toàn khu vực
  if not GLOBAL_AGENT then
    self:Logout_GlobalServer_Normal_GS()
  else
  end
end

function Player:Login_GlobalServer_Normal_GS() end

function Player:Login_GlobalServer_Global_GS(szGateway, nPlayerId, szTongName, szKinName)
  KGCPlayer.ProcessGlobalPlayerLogin_Global(szGateway, nPlayerId, szTongName, szKinName)
end

function Player:UpdatePlayerKinInTong_Global_GS(szGateway, szTongName, szKinName)
  KGCPlayer.UpdateGlobaPlayerKinInTong(szGateway, szTongName, szKinName)
end

function Player:ApplyLogout_GlobalServer_Global_GS(nPlayerId)
  GCExcute({ "Player:Logout_GlobalServer_Global_GC", nPlayerId })
end

function Player:Logout_GlobalServer_Global_GS(nPlayerId)
  KGCPlayer.ProcessGlobalPlayerLogout_Global(nPlayerId)
end

-- Đây là đăng nhập của người chơi máy chủ thường, mục đích của hàm này là để xác định xem người chơi có phải từ máy chủ toàn cục chuyển qua không, nếu có thì cần xóa bản ghi liên server của máy chủ thường
function Player:Logout_GlobalServer_Normal_GS()
  if not MODULE_GAMESERVER then
    return 0
  end
  local nState = self:GetGlobalLoginState_Normal(me.nId)
  if 1 == nState then
    GCExcute({ "Player:Logout_GlobalServer_Normal_GC", me.nId, me.dwTongId, me.dwKinId })
    Transfer:ClearPlayerKinAndTongName(me)
  end
  return 0
end

function Player:RecordTimeAbort()
  --by jiazhenwei
  local nCurTime = GetTime()
  local nLastTime = me.GetTask(2063, 17) --Ghi lại thời gian đăng nhập lần trước (cập nhật tức thì)
  local nCurExTime = me.GetTask(2063, 2) --Ghi lại thời gian đăng nhập lần này (cập nhật ngay cả khi)
  local nJianGeTime = me.GetTask(2063, 16) --Ghi lại thời gian đăng nhập lần trước (cập nhật sau 24 giờ)
  --Người chơi cũ
  if ((nCurTime - nLastTime) > 24 * 3600) or ((nCurTime - nCurExTime) > 24 * 3600) then
    me.SetTask(2063, 16, nCurExTime)
    me.SetTask(2063, 17, nCurTime)
  end

  if Lib:GetLocalDay(nCurTime) ~= Lib:GetLocalDay(nCurExTime) then
    -- Là lần đăng nhập đầu tiên trong ngày, ghi lại thông tin chân nguyên đang trang bị
    local szLog = ""
    for i = Item.EQUIPPOS_ZHENYUAN_MAIN, Item.EQUIPPOS_ZHENYUAN_SUB2 do
      local pItem = me.GetItem(Item.ROOM_EQUIP, i)
      if pItem then
        if szLog ~= "" then
          szLog = szLog .. ","
        end
        szLog = szLog .. string.format("%d,%s,%s,%d,%1.0f", i, pItem.szGUID, pItem.szName, Item.tbZhenYuan:GetLevel(pItem), Item.tbZhenYuan:GetZhenYuanValue(pItem))
      end
    end

    if szLog ~= "" then
      StatLog:WriteStatLog("stat_info", "zhenyuan", "hutizhenyuan", me.nId, szLog)
    end
  end

  me.SetTask(2063, 2, nCurTime)
  --Ghi lại số ngày trong tháng
  local nNowMonth = tonumber(GetLocalDate("%m"))
  local nMonth = me.GetTask(2063, 18)
  if nMonth ~= nNowMonth then
    me.SetTask(2063, 18, nNowMonth)
    me.SetTask(2063, 20, 0) --Đặt lại số ngày tích lũy
    me.SetTask(2122, 8, 0) --Đặt lại số lần nhận
  end
  local nDate = me.GetTask(2063, 19)
  local nNowDate = tonumber(GetLocalDate("%Y%m%d"))
  if nDate < nNowDate then
    me.SetTask(2063, 19, nNowDate)
    me.SetTask(2063, 20, me.GetTask(2063, 20) + 1)
  end
  --end
end

-- Đồng bộ dữ liệu đăng xuất GS thường liên khu vực
function Player:DataSync_GS2(szName, nCurrentMoney)
  if szName and nCurrentMoney then
    local nPlayerId = KGCPlayer.GetPlayerIdByName(szName)
    KGCPlayer.OptSetTask(nPlayerId, KGCPlayer.TSK_CURRENCY_MONEY, nCurrentMoney)
  end
end

-- Nhắc nhở an toàn đăng nhập
function Player:OnLogin_AccountSafe(bExchangeServer)
  if bExchangeServer == 1 or IVER_g_nTwVersion == 1 then
    return
  end

  if 0 == IVER_g_nLockAccount then
    return
  end

  Timer:Register(1, Player.AccountSafe, Player)
end

function Player:AccountSafe()
  local nCurHonor = PlayerHonor:GetPlayerHonorByName(me.szName, PlayerHonor.HONOR_CLASS_MONEY, 0)
  if me.nLevel >= self.nAccountSafeLevel and me.GetPasspodMode() == self.nAccountSafeMode and nCurHonor >= self.nAccountSafeHonour then
    me.CallClientScript({ "UiManager:OpenWindow", "UI_ACCOUNTSAFE" })
  end
  return 0
end

function Player:OnLogin_OnSetComeBackOldPlayer(bExchangeServerComing)
  if 1 == bExchangeServerComing then
    return
  end
  local nFlag = self:GetComeBackFlag()
  if nFlag > 0 then
    return
  end

  local nLevel = me.nLevel
  if nLevel < 79 or nLevel < me.GetAccountMaxLevel() then
    return
  end

  local nZeroFlag = self:CheckComeBackZero()

  local nNowTime = GetTime()
  local nLastTime = me.nLastSaveTime

  if nLastTime <= 0 then
    return
  end

  local tbTime = {
    year = 2009,
    month = 2,
    day = 20,
    hour = 0,
    min = 0,
    sec = 0,
  }
  local nLimitTime = os.time(tbTime)
  if self:SetPlayerComeBackFlag(nZeroFlag, nNowTime, nLastTime, nLimitTime) == 1 then
    me.SetTask(self.COMEBACK_TSKGROUPID, self.COMEBACK_TSKID_LASTTIME, nLastTime)
    me.SetTask(self.COMEBACK_TSKGROUPID, self.COMEBACK_TSKID_NOWTIME, nNowTime)
  end
end

function Player:SetPlayerComeBackFlag(nFlag, nNowTime, nLastTime, nLimitTime)
  if nLastTime > nLimitTime and 1 == nFlag then
    self:SetComeBackFlag(self.COMEBACK_YES_NEW)
    self:WriteLog_ForPlayer("SetPlayerComeBackFlag", me.szName, " is right new player")
    return 0
  end

  if nLastTime > nLimitTime and 0 == nFlag then
    self:SetComeBackFlag(self.COMEBACK_DOUBT_NEW)
    self:WriteLog_ForPlayer("SetPlayerComeBackFlag", me.szName, " is doubt new player")
    return 0
  end

  if nLastTime <= nLimitTime and 1 == nFlag then
    self:SetComeBackFlag(self.COMEBACK_YES_OLD)
    self:WriteLog_ForPlayer("SetPlayerComeBackFlag", me.szName, " is right call back player")
    return 1
  end

  if nLastTime <= nLimitTime and 0 == nFlag then
    self:SetComeBackFlag(self.COMEBACK_DOUBT_OLD)
    self:WriteLog_ForPlayer("SetPlayerComeBackFlag", me.szName, " is doubt call back player")
    return 1
  end
end

function Player:WriteLog_ForPlayer(...)
  Dbg:WriteLogEx(Dbg.LOG_INFO, "Player", unpack(arg))
end

function Player:GetComeBackFlag()
  return me.GetTask(self.COMEBACK_TSKGROUPID, self.COMEBACK_TSKID_FLAG)
end

function Player:SetComeBackFlag(nValue)
  me.SetTask(self.COMEBACK_TSKGROUPID, self.COMEBACK_TSKID_FLAG, nValue)
end

-- Đồng > 0, Đồng trong ngân hàng > 0, Nạp hàng tháng > 0,
function Player:CheckComeBackZero()
  if me.nCoin > 0 then
    return 1
  end

  if me.nBankCoin > 0 then
    return 1
  end

  if me.GetExtMonthPay() > 0 then
    return 1
  end

  if me.GetReputeValue(1, 2) > 0 then
    return 1
  end

  --Cái này cần thêm danh vọng chuyển tu môn phái
  if me.nFaction > 0 and me.GetReputeValue(3, me.nFaction) > 0 then
    return 1
  end

  if me.GetReputeValue(4, 1) > 0 then
    return 1
  end

  if me.GetReputeValue(5, 2) > 0 then
    return 1
  end

  if me.GetReputeValue(5, 3) > 0 then
    return 1
  end

  for i = 1, 5 do
    if me.GetReputeValue(6, i) > 0 then
      return 1
    end
  end
  return 0
end

function Player:OnLogin_StatComeBack(bExchangeServerComing)
  if 1 == bExchangeServerComing then
    return
  end
  local nNowTime = GetTime()
  local nLastTime = me.nLastSaveTime
  if (nNowTime - nLastTime) < 30 * 3600 * 24 then -- quay lại sau 30 ngày
    return
  end
  if nLastTime <= 0 then
    return
  end
  local nMaxLevel = me.GetAccountMaxLevel()
  local tbInfo = GetPlayerInfoForLadderGC(me.szName)
  local szLastTime = os.date("%Y-%m-%d %H:%M:%S", nLastTime)
  local szNowTime = os.date("%Y-%m-%d %H:%M:%S", nNowTime)
  local tbReputeId = {
    [1] = { 1, 2, 3 },
    [2] = { 1, 2, 3 },
    [3] = { me.nFaction },
    [4] = { 1 },
    [5] = { 1, 2, 3, 4 },
    [6] = { 1, 2, 3, 4, 5 },
    [7] = { 1 },
  }
  -- Tên khu vực, Tài khoản, Tên nhân vật, Cấp độ nhân vật hiện tại, Cấp độ nhân vật cao nhất trong tài khoản, Thời gian đăng nhập lần trước, Thời gian đăng nhập lần này, Chênh lệch thời gian, Tổng thời gian online, Bạc, Bạc khóa, Đồng, Đồng khóa
  -- Đồng trong ngân hàng, Môn phái, Lộ tuyến, Hoạt lực, Tinh lực, Uy danh giang hồ
  -- Nghĩa Quân Cấp, Quân Doanh Cấp, Cơ Quan Học Cấp, Dương Châu Cấp, Phượng Tường Cấp, Tương Dương Cấp, Môn phái hiện tại Cấp, Gia tộc Cấp, Bạch Hổ Đường Cấp, Hoạt động mùa hè Cấp, Tiêu Dao Cốc Cấp, Cầu phúc Cấp, Thách đấu cao thủ võ lâm Kim Cấp, Thách đấu cao thủ võ lâm Mộc Cấp, Thách đấu cao thủ võ lâm Thủy Cấp, Thách đấu cao thủ võ lâm Hỏa Cấp, Thách đấu cao thủ võ lâm Thổ Cấp, Võ Lâm Liên Tái Cấp
  local tb = {
    GetGatewayName(),
    tbInfo.szAccount,
    me.szName,
    me.nLevel,
    nMaxLevel,
    szLastTime,
    szNowTime,
    (nNowTime - nLastTime),
    me.nOnlineTime,
    me.GetRoleCreateDate(),
    me.nTotalMoney,
    me.GetBindMoney(),
    me.nCoin,
    me.nBindCoin,
    me.nBankCoin,
    Player:GetFactionRouteName(me.nFaction),
    Player:GetFactionRouteName(me.nFaction, me.nRouteId),
    me.dwCurGTP,
    me.dwCurMKP,
    me.nPrestige,
  }
  -- Danh vọng
  for nCamp, tbCamp in ipairs(tbReputeId) do
    for nClass, tbClass in ipairs(tbCamp) do
      local nRepute = 0
      local nLevel = 0
      if nClass > 0 then
        nRepute = me.GetReputeValue(nCamp, nClass)
        nLevel = me.GetReputeLevel(nCamp, nClass)
      end
      tb[#tb + 1] = nRepute
      tb[#tb + 1] = nLevel
    end
  end
  local szContext = table.concat(tb, "\t")
  -- tbInfo.szAccount .. "\t";
  GCExcute({ "KFile.AppendFile", "\\..\\stat_playercomeback_" .. GetGatewayName() .. ".txt", szContext .. "\n" })
end

function Player:ClearCibeixinjingUsedAmount()
  local tbYunyousengren = Npc:GetClass("yunyousengren")
  me.SetTask(tbYunyousengren.tbTaskIdUsedCount[1], tbYunyousengren.tbTaskIdUsedCount[2], 0)
end

function Player:ClearInsightBookUsedCount()
  me.SetTask(2006, 1, 0, 1)
end

-------------------------------------------------------------------------
-- Sự kiện offline chung
function Player:_OnLogout(szReason)
  if MODULE_GAMESERVER then
    self:CommitLevelUpInfo(me.nId)
    -- Nhật ký
    if szReason ~= "SwitchServer" then
      local nBank_Coin = me.GetTask(Bank.TASK_GROUP, Bank.TASK_ID_GOLD_SUM)
      local nBank_Money = me.GetTask(Bank.TASK_GROUP, Bank.TASK_ID_SILVER_SUM)
      local szMsg = string.format("Người chơi offline (Cấp:%d,%s:%d,Tiền mặt và tiền gửi:%d,Khóa %s:%d,Bạc khóa:%d,Uy danh giang hồ:%d,\nBạc khóa liên server:%d,Bạc trong ngân hàng:%d,Đồng trong ngân hàng:%d,Tinh lực hiện tại%d,Hoạt lực hiện tại%d,Tài sản cổ phần:%d)", me.nLevel, IVER_g_szCoinName, me.nCoin, me.nCashMoney + me.nSaveMoney, IVER_g_szCoinName, me.nBindCoin, me.GetBindMoney(), me.nPrestige, me.GetGlbBindMoney(), nBank_Money, nBank_Coin, me.dwCurMKP, me.dwCurGTP, KGCPlayer.OptGetTask(me.nId, KGCPlayer.TSK_TONGSTOCK))
      me.PlayerLog(Log.emKPLAYERLOG_TYPE_LOGOUT, szMsg)
      --Khi người chơi offline, lưu uy danh giang hồ của người chơi vào biến nhiệm vụ
      me.SetTask(0, 2389, me.nPrestige) --0, 2389 là biến nhiệm vụ của uy danh giang hồ
      local nKinId, nMemberId = me.GetKinMember()
      if nKinId > 0 then
        GCExecute({ "Kin:SetLastLogOutTime_GC", nKinId, nMemberId, GetTime() })
      end
      if IsGlobalServer() == true then
        self:ApplyLogout_GlobalServer_Global_GS(me.nId)
      end
    end
    -- Cập nhật phần trăm kinh nghiệm
    -- Máy chủ toàn cục không áp dụng bảng xếp hạng cấp độ lực chiến, khi ở máy chủ toàn cục cũng không cần đồng bộ phần trăm kinh nghiệm
    if IsGlobalServer() == false then
      GCExecute({ "Player.tbFightPower:UpdatePlayerExp", me.nId, me.nLevel, me.GetExpPercent(0) })
    end
  end

  -- Xóa PlayerTimer
  local tbPlayerTimer = me.GetTempTable("Player").tbTimer
  if tbPlayerTimer then
    for nRegisterId, tbEvent in pairs(tbPlayerTimer) do
      -- Thông báo cho mô-đun gỡ lỗi, tắt PlayerTimer
      Dbg:PrintEvent("PlayerTimer", "LogoutClose", nRegisterId, me.szName)
      -- TODO: FanZai	Vẫn chưa hỗ trợ PlayerTimer không biến mất khi offline
      Timer:Close(nRegisterId)
    end
  end
  if szReason ~= "SwitchServer" then
    --by jiazhenweiGhi lại thời gian online tích lũy khi offline
    local nNowTime = GetTime()
    local nLastLogInTime = me.GetTask(2063, 2)
    local nTodayTime = Lib:GetDate2Time(tonumber(GetLocalDate("%Y%m%d")))
    if nTodayTime <= nLastLogInTime then
      me.SetTask(2063, 21, me.GetTask(2063, 21) + nNowTime - nLastLogInTime)
    else
      me.SetTask(2063, 21, nNowTime - nTodayTime)
    end
    --end
    if MODULE_GAMESERVER then
      me.CallClientScript({ "SpecialEvent.tbGetPhoneId_2012:CloseWindow" })
    end
  end

  if MODULE_GAMESERVER then
    local tbXJRecord = me.GetXJRecordInfo()
    if tbXJRecord and tbXJRecord ~= {} then
      local szLog = ""
      local bHasValue = 0
      for i, nCount in pairs(tbXJRecord) do
        if i ~= 1 then
          szLog = szLog .. ","
        end

        szLog = string.format("%s%d", szLog, nCount)

        if nCount > 0 then
          bHasValue = 1
        end
      end

      if bHasValue == 1 then
        StatLog:WriteStatLog("stat_info", "roleobtain", "xuanjing", me.nId, szLog)
      end
    end

    MiniResource.tbDownloadInfo:OnLogout(szReason)

    --Sự kiện online của pet đồng hành
    if not GLOBAL_AGENT then
      Npc.tbFollowPartner:FollowPartnerLogOut()
    end
    --Khi offline trong Khoa Cử, cần đặt biến mở UI về 0, để tránh tình trạng vừa vào đã có câu hỏi dù chưa mở giao diện
    me.SetTask(2216, 16, 0)
  else
    ClientEvent:OnLogout(szReason)
  end
end

-------------------------------------------------------------------------
-- Sự kiện lên cấp chung
function Player:_OnLevelUp(nLevel)
  -- Lên cấp kỹ năng sống
  LifeSkill:AddSkillWhenPlayerLevelUp(nLevel)

  if MODULE_GAMESERVER then
    if self:IsFresh() ~= 1 then
      me.CallClientScript({ "me.RemoveSkillState", 390 })
      if me.nLevel == 30 then
        me.Msg("Ngươi có thể chuyển sang chế độ chiến đấu mới rồi!")
      end
    end

    ----Kiểm tra xem có nhiệm vụ thế giới mới để nhận không
    local tbTaskListInfo = Task:GetBranchTaskTable(me)
    if tbTaskListInfo and #tbTaskListInfo > 0 then
      for _, tbInfo in ipairs(tbTaskListInfo) do
        if me.nLevel == tbInfo[1] then
          me.CallClientScript({
            "Ui:ServerCall",
            "UI_TASKTIPS",
            "Begin",
            "Có nhiệm vụ thế giới mới để nhận, vui lòng xem <color=yellow>Bảng nhiệm vụ F4<color> trong <color=yellow>Hướng dẫn nhiệm vụ<color>!",
          })
          break
        end
      end
    end

    --Đạt cấp độ nhất định, tự động thiết lập tùy chọn sư đồ
    -- Cấp 20 rồi, có thể bái sư rồi，
    if me.nLevel == 20 then
      me.CallClientScript({ "me.SetTrainingOption", 1, 1 })
    elseif me.nLevel == 49 then
      me.CallClientScript({ "me.SetTrainingOption", 1, 0 })
    elseif me.nLevel == 80 then -- Cấp 80 rồi, thêm một lượt vào quân doanh
      Task.tbArmyCampInstancingManager:UpdateEnterTimes()
    end
    self:SetActMaxLevel(nLevel)
    local tbActiveEvent = { [10] = 10, [20] = 12, [30] = 39, [40] = 40, [50] = 41 }
    if tbActiveEvent[me.nLevel] then
      SpecialEvent.ActiveGift:AddCounts(me, tbActiveEvent[me.nLevel]) --Độ sôi nổi lên cấp
    end
    SpecialEvent.tbGoldBar:AddTask(me, 11) --Lên cấp giải đấu Kim Bài
  end
  if MODULE_GAMECLIENT then
    Tutorial:OnLevelUp()
  end
end

function Player:IsFresh()
  return me.IsFreshPlayer()
end

-------------------------------------------------------------------------
-- Sự kiện tử vong chung
function Player:_OnDeath(pKiller)
  BlackSky:GiveMeBright(me)
  if not pKiller then
    return
  end
  if pKiller.nKind == 1 then
    local szMsg = "Ngươi bị<color=yellow>" .. pKiller.szName .. "<color>đánh trọng thương!"
    if pKiller.GetTrickName() ~= "" then
      szMsg = "Ngươi bị<color=yellow>" .. pKiller.GetTrickName() .. "<color>đánh trọng thương!"
    end
    Dialog:SendInfoBoardMsg(me, szMsg)
    me.Msg(szMsg)
    local pPlayer = pKiller.GetPlayer()
    if pPlayer then
      local szMsg = "<color=yellow>" .. me.szName .. "<color>bị ngươi đánh trọng thương!"
      if me.GetNpc().GetTrickName() ~= "" then
        szMsg = "<color=yellow>" .. me.GetNpc().GetTrickName() .. "<color>bị ngươi đánh trọng thương!"
      end
      Dialog:SendInfoBoardMsg(pPlayer, szMsg)
      pPlayer.Msg(szMsg)
      --Gọi phần thưởng pet khi tiêu diệt người chơi
      Npc.tbFollowPartner:AddAward(pPlayer, "killplayer")
    end
  end
end

-------------------------------------------------------------------------
function Player:_OnKillNpc()
  -- Nếu là quái tinh anh, quái thủ lĩnh, kiểm tra xem có cần thêm kinh nghiệm cho đồng hành của người chơi không
  if him.GetNpcType() ~= 0 then
    Partner:OnKillBoss(me, him)
  end

  Task:OnKillNpc(me, him)
end

function Player:_OnCampChange()
  if MODULE_GAMESERVER then
    if self:IsFresh() ~= 1 then
      me.CallClientScript({ "me.RemoveSkillState", 390 })
    end
  end
end

-- Đồng bộ dữ liệu hoạt động
function Player:SyncCampaignDate(nType, tbDate, nUsefulTime)
  me.SetCampaignDate(nType, tbDate, nUsefulTime)
end

-- Nhận hiệu suất cấp độ người chơi
function Player:GetLevelEffect(nLevel)
  local nLevel10 = math.floor(nLevel / 10)
  return self.tbLevelEffect[nLevel10] or 0
end

-- Chức năng: Tính toán sát thương giảm đi xx% khi bị kẻ địch cùng cấp tấn công trong ô phòng ngự (trả về xx, không phải xx%)
function Player:CountReduceDefence(nDefense)
  local nMaxPercent = KFightSkill.GetSetting().nDefenceMaxPercent --Giới hạn trên của tỷ lệ giảm kháng cũ
  local nExcessRisPer = KFightSkill.GetSetting().nExcessRisPer / 100 --Tỷ lệ phần trăm kháng vượt mức sẽ được khuếch đại
  local pReduceDefance = 2 * nMaxPercent * nDefense / (nDefense + 10 * me.nLevel + 200)
  local klv = me.nLevel * 10 + 200
  if nDefense > klv then
    pReduceDefance = 100 * 1 / (1 + 1 / (nExcessRisPer * nDefense / klv + nMaxPercent / (100 - nMaxPercent) - nExcessRisPer))
  end
  if nDefense < 0 then
    pReduceDefance = 0
  end
  return pReduceDefance
end

function Player:AddProtectedState(pPlayer, nTime)
  if nTime > 0 then
    pPlayer.AddSkillState(self.nBeProtectedStateSkillId, 1, 1, nTime * Env.GAME_FPS)
  else
    pPlayer.RemoveSkillState(self.nBeProtectedStateSkillId)
  end
end

function Player:UpdateFudaiLimit()
  local tbItem = Item:GetClass("fudai")
  local nMaxUse = tbItem.ITEM_USE_COUNT_MAX.nCommon
  if me.GetExtMonthPay() >= tbItem.VIP then
    nMaxUse = tbItem.ITEM_USE_COUNT_MAX.nVip
  end

  -- *******Ưu đãi gộp server, hết hạn sau 7 ngày gộp server*******
  if GetTime() < KGblTask.SCGetDbTaskInt(DBTASK_COZONE_TIME) + 7 * 24 * 60 * 60 and me.nLevel >= 50 then
    nMaxUse = nMaxUse + 5
  end
  -- *************************************

  me.SetTask(tbItem.TASK_GROUP_ID, tbItem.TASK_COUNT_LIMIT, nMaxUse)
end

-- Khi kinh nghiệm lên cấp nhận được đạt đến một điều kiện nhất định, kịch bản cộng tâm đắc này sẽ được kích hoạt
function Player:AddXinDe(nXinDeTimes)
  local nXinDe = 10000 * nXinDeTimes
  Task:AddInsight(nXinDe)
end

if MODULE_GAMESERVER then
  -- Tháo Mã Bài thất bại (đang trên ngựa và trong thời gian hồi chiêu lên xuống ngựa)
  function Player:OnSwitchHorseFailed(nPlayerId)
    if type(nPlayerId) ~= "number" then
      return
    end

    local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
    if not pPlayer then
      return
    end

    pPlayer.Msg("Kỹ năng lên xuống ngựa đang trong thời gian hồi, ngươi không thể tháo Mã Bài lúc này.")
  end

  function Player:Buy_GS1(nCurrencyType, nCost, nEnergyCost, nBuy, nBuyIndex, nCount)
    if nCount < 0 then
      return 0
    end
    if nEnergyCost < 0 then
      nEnergyCost = 0
    end
    if nCost < 0 then
      return 0
    end
    if nCurrencyType == 9 then -- Loại tiền tệ là quỹ xây dựng bang hội
      local cTong = KTong.GetTong(me.dwTongId)
      if not cTong then
        me.Msg("Ngươi chưa gia nhập bang hội, không thể mua!")
        return 0
      end
      local nTongId = me.dwTongId
      local nSelfKinId, nSelfMemberId = me.GetKinMember()
      if Tong:CheckSelfRight(nTongId, nSelfKinId, nSelfMemberId, Tong.POW_FUN) ~= 1 then
        me.Msg("Ngươi không có quyền thao tác quỹ bang hội!")
        return 0
      end
      local nEnergy = cTong.GetEnergy()
      local nEnergyLeft = nEnergy - nEnergyCost * nCount
      if nEnergyLeft < 0 then
        me.Msg("Hành động lực của bang hội không đủ!")
        return 0
      end
      if Tong:CanCostedBuildFund(nTongId, nSelfKinId, nSelfMemberId, nCost * nCount) ~= 1 then
        me.Msg("Hạn mức sử dụng quỹ xây dựng không đủ! Vui lòng yêu cầu <color=yellow>Bang chủ<color> của bang hội thiết lập giới hạn sử dụng hàng tuần cao hơn!")
        return 0
      end
      GCExcute({ "Player:Buy_GC", nCurrencyType, nCost, nEnergyCost, me.dwTongId, nSelfKinId, nSelfMemberId, me.nId, nBuy, nBuyIndex, nCount })
    end
  end

  function Player:Buy_GS2(nCurrencyType, dwTongId, nPlayerId, nBuy, nBuyIndex, nCost, nEnergyLeft, nCount)
    local cTong = KTong.GetTong(dwTongId)
    if not cTong then
      return 0
    end
    cTong.SetEnergy(nEnergyLeft)

    local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
    if not pPlayer then
      return 0
    end

    if nCurrencyType == 9 then
      pPlayer.Buy_Sync(nCurrencyType, nBuy, nBuyIndex, nCost, nCount)
    end
  end

  function Player:SendMsgToKinOrTong(pPlayer, szMsg, bIsTong)
    if not pPlayer then
      return
    end
    if bIsTong == 1 then
      local nTongId = pPlayer.dwTongId
      if nTongId ~= nil and nTongId > 0 then
        szMsg = "Thành viên bang hội<color=yellow>[" .. pPlayer.szName .. "]<color>" .. szMsg
        pPlayer.SendMsgToKinOrTong(1, szMsg)
        return
      end
    end

    local nKinId = pPlayer.dwKinId
    if nKinId ~= nil and nKinId > 0 then
      szMsg = "Thành viên gia tộc<color=yellow>" .. pPlayer.szName .. "<color>" .. szMsg
      pPlayer.SendMsgToKinOrTong(0, szMsg)
    end
  end

  function Player:ApplyBuyAndUseJiuZhuan()
    if me.IsAccountLock() ~= 0 then
      me.Msg("Tài khoản của ngươi đang bị khóa, không thể thực hiện thao tác này!")
      Account:OpenLockWindow(me)
      return
    end
    me.ApplyAutoBuyAndUse(53, 1)
    Dbg:WriteLog("Player", me.szName, "ApplyBuyAndUseJiuZhuan", 53)
  end

  function Player:NotifyItemTimeOut(nLeftTime)
    if nLeftTime > 0 then
      me.CallClientScript({ "Player:NotifyItemTimeOutClient", 45 })
    else
      me.Msg("Huyền Tinh trong túi đồ hoặc kho của ngươi đã biến mất do hết hạn sử dụng.")
    end
  end

  -- Bắt vào Thiên Lao Đào Nguyên. szORpPlayer: tên hoặc đối tượng người chơi, nJailTerm: thời gian giam (giây thực tế, 0 là vô thời hạn (mặc định))
  function Player:Arrest(szORpPlayer, nJailTerm)
    local pPlayer = nil
    if type(szORpPlayer) == "string" then
      pPlayer = KPlayer.GetPlayerByName(szORpPlayer)
    else
      pPlayer = szORpPlayer
    end
    if not pPlayer then
      return
    end
    pPlayer.SetJailTerm(nJailTerm or 0)
    pPlayer.SetArrestTime(GetTime())
    pPlayer.KickOut()
    pPlayer.PlayerLog(Log.emKPLAYERLOG_TYPE_COMPENSATE, "Giam ở Đào Nguyên，thời gian giam(giây thực tế,0 là vô thời hạn): " .. (nJailTerm or 0))
    return 1
  end

  -- Thả ra khỏi Thiên Lao Đào Nguyên. szORpPlayer: tên hoặc đối tượng người chơi
  function Player:SetFree(szORpPlayer)
    local pPlayer = nil
    local szPlayerName = ""
    if type(szORpPlayer) == "string" then
      pPlayer = KPlayer.GetPlayerByName(szORpPlayer)
      szPlayerName = szORpPlayer
    else
      pPlayer = szORpPlayer
    end
    if not pPlayer then
      return
    end

    pPlayer.SetJailTerm(0)
    pPlayer.SetArrestTime(0)
    pPlayer.ForbitSet(0, 1)

    local nMapId, nReliveId = pPlayer.GetRevivePos()
    local nReliveX, nReliveY = RevID2WXY(nMapId, nReliveId)
    pPlayer.NewWorld(nMapId, nReliveX / 32, nReliveY / 32) -- Quay lại điểm lưu

    -- Tiện thể xóa dấu hiệu hệ thống chống hack (houxuan)
    if self.tbAntiBot:IsKilledByAntiBot(pPlayer) == 1 then
      self.tbAntiBot:SetPlayerInnocent(pPlayer.szName)
    end

    --Xóa biến nhiệm vụ lưu lý do
    pPlayer.SetTask(SpecialEvent.HoleSolution.TASK_COMPENSATE_GROUPID, SpecialEvent.HoleSolution.TASK_SUBID_REASON, 0)

    pPlayer.KickOut()
    return 1
  end

  -- Có thể rời khỏi Thiên Lao Đào Nguyên không
  function Player:CanLeaveTaoyuan(pPlayer)
    if pPlayer.GetArrestTime() == 0 then -- Chưa bị bắt vào Thiên Lao Đào Nguyên
      return 1
    else
      if pPlayer.GetJailTerm() == 0 or pPlayer.GetJailTerm() + pPlayer.GetArrestTime() > GetTime() then
        return 0
      end
    end
    return 1
  end

  -- Tăng giá trị danh vọng. Trả về 0 nếu danh vọng bất thường, 1 nếu đạt giới hạn cấp độ, 2 nếu tăng danh vọng thành công
  function Player:AddRepute(pPlayer, nClass, nCampId, nShengWang)
    local nLevel = pPlayer.GetReputeLevel(nClass, nCampId)
    if not nLevel then
      print("AddRepute Repute is error ", pPlayer.szName, nClass, nCampId)
      return 0
    else
      if 1 == pPlayer.CheckLevelLimit(nClass, nCampId) then
        return 1
      end
    end
    pPlayer.AddRepute(nClass, nCampId, nShengWang)
    return 2
  end

  -- Tăng danh vọng, nếu có danh vọng tích lũy sẽ tiêu hao danh vọng tích lũy
  function Player:AddReputeWithAccelerate(pPlayer, nClass, nCampId, nShengWang)
    local nLevel = pPlayer.GetReputeLevel(nClass, nCampId)
    if not nLevel then
      print("AddRepute Repute is error ", pPlayer.szName, nClass, nCampId)
      return 0
    else
      if 1 == pPlayer.CheckLevelLimit(nClass, nCampId) then
        return 1
      end
    end
    local nShengWangExt = Item:GetClass("reputeaccelerate"):GetAndUseExtRepute(pPlayer, nClass, nCampId, nShengWang, 1)
    pPlayer.AddRepute(nClass, nCampId, nShengWang + nShengWangExt)
    return 2, nShengWangExt
  end

  function Player:OnMoneyErr(szReason, nCheckMoney, nNowMoney)
    if me.nLastSaveTime <= 1238457600 then -- Dữ liệu lỗi thời kỳ đầu
      return
    end
    local szMsg = string.format("%s\t%s\t%s\t[%d]\t%s\t%d=>%d\t%s", GetLocalDate("%Y-%m-%d %H:%M:%S"), me.szAccount, me.szName, me.nId, szReason, nCheckMoney, nNowMoney, me.GetPlayerIpAddress())
    print("MoneyErr1", szMsg)
    GCExcute({ "KFile.AppendFile", "\\log\\moneyerr1_" .. GetGatewayName() .. ".txt", szMsg .. "\n" })
    if nNowMoney > nCheckMoney then
      --me.SetLogType(1+4);
    end
  end

  function Player:OnChangeFightState()
    if me.nFightState == 0 then -- Từ 1 thành 0
      -- Chuyển từ trạng thái chiến đấu sang trạng thái không chiến đấu，
      if me.nActivePartner ~= -1 then
        Partner:DecreaseFriendship(me.nId)
      end

      -- Tắt TIMER
      Partner:UnRegisterPartnerTimer(me)
    else -- Từ 0 thành 1
      local pPartner = me.GetPartner(me.nActivePartner)
      if pPartner then
        -- Nếu người chơi này có đồng hành được kích hoạt, bật bộ đếm giờ để thêm hiệu ứng triệu hồi đồng hành
        -- Công tắc tổng không có giới hạn, có thể bật TIMER mà không cần tắt
        Partner:RegisterPartnerTimer(me)

        -- Chuyển từ trạng thái không chiến đấu sang trạng thái chiến đấu, ghi lại thời gian bắt đầu giảm độ thân mật
        Partner:ResetDecrTime(pPartner) -- Đặt lại biến giảm độ thân mật của đồng hành
      end
    end
  end

  -- by zhangjinpin@kingsoft
  -- Đóng băng tài khoản
  function Player:Freeze(szPlayer)
    local pPlayer = nil
    if type(szPlayer) == "string" then
      pPlayer = KPlayer.GetPlayerByName(szPlayer)
    else
      pPlayer = szPlayer
    end
    if not pPlayer then
      return
    end
    pPlayer.SetTask(2063, 4, 1)
    pPlayer.Msg("Xin lỗi, tài khoản của bạn đã bị đóng băng.")
    pPlayer.KickOut()
    return 1
  end

  -- Sự kiện đăng nhập kiểm tra đóng băng
  function Player:OnLogin_CheckFreeze()
    if me.GetTask(2063, 4, 1) == 1 then
      me.Msg("Xin lỗi, tài khoản của bạn đã bị đóng băng.")
      me.KickOut()
    end
  end
  -- end

  -- Xử lý giao thức bất hợp pháp do client gửi, hiện tại chỉ ghi LOG zounan
  function Player:ProcessIllegalProtocol(szFunc, szParam, nValue)
    szFunc = szFunc or ""
    szParam = szParam or ""
    nValue = nValue or 0
    Dbg:WriteLog("Player:ProcessIllegalProtocol", me.szAccount, me.szName, szFunc, szParam, nValue)
  end

  --Lưu phím tắt của người chơi (truyền vào một bảng để ghi vào đó)
  function Player:SaveShotCut(tbSave)
    tbSave[me.nId] = {}
    for nPos = 1, Item.TSKID_SHORTCUTBAR_FLAG do
      tbSave[me.nId][nPos] = me.GetTask(Item.TSKGID_SHORTCUTBAR, nPos)
    end
    local nLeftSkill, nRightSkill = FightSkill:LoadSkillTask(me)
    tbSave[me.nId][Item.TSKID_SHORTCUTBAR_FLAG + 1] = nLeftSkill
    tbSave[me.nId][Item.TSKID_SHORTCUTBAR_FLAG + 2] = nRightSkill
  end

  --Thiết lập phím tắt dựa trên bảng đã biết
  function Player:RestoryShotCut(tbSave)
    if not tbSave[me.nId] then
      return
    end
    for nPos = 1, #tbSave[me.nId] - 2 do
      me.SetTask(Item.TSKGID_SHORTCUTBAR, nPos, tbSave[me.nId][nPos])
    end
    FightSkill:SaveLeftSkillEx(me, tbSave[me.nId][#tbSave[me.nId] - 1])
    FightSkill:SaveRightSkillEx(me, tbSave[me.nId][#tbSave[me.nId]])
    FightSkill:RefreshShortcutWindow(me)
    tbSave[me.nId] = nil
  end

  --Kiểm tra biến nhiệm vụ hàng ngày, hết hạn sẽ đặt lại
  function Player:CheckTask(nGroupId, nGDate, szDateRule, nGCount, nCount)
    if not nGroupId or not nGDate or not szDateRule or not nGCount or not nCount then
      return 0
    end
    local nNowDate = tonumber(GetLocalDate(szDateRule))
    local nDate = me.GetTask(nGroupId, nGDate)
    if nDate ~= nNowDate then
      me.SetTask(nGroupId, nGDate, nNowDate)
      me.SetTask(nGroupId, nGCount, 0)
      return 1
    end
    local nNowCount = me.GetTask(nGroupId, nGCount)
    if nNowCount >= nCount then
      return 0
    end
    return 1
  end

  --Thiết lập biến mở rộng
  function Player:SetActMaxLevel(nNewLevel)
    if self:CheckIsXp() == 1 then
      return
    end
    local nExt7OrgValue = me.GetExtPoint(7)
    local nExt7 = math.floor(nExt7OrgValue / 1000)
    local nOldLevel = (nExt7OrgValue % 1000)
    local nDisLevel = 0
    if nOldLevel >= 0 then
      nDisLevel = (nNewLevel - nOldLevel)
    else
      nDisLevel = (nNewLevel + nOldLevel)
    end
    if nDisLevel > 0 then
      local tbTemp = me.GetTempTable("Player")
      tbTemp.nAccumulateLevel = tbTemp.nAccumulateLevel or 0
      if nExt7 < 0 then
        tbTemp.nAccumulateLevel = -nDisLevel
      else
        tbTemp.nAccumulateLevel = nDisLevel
      end
      if not tbTemp.nAccumulateLevelTimerId then
        tbTemp.nAccumulateLevelTimerId = Player:RegisterTimer(Env.GAME_FPS, Player.CommitLevelUpInfo, Player, me.nId)
        assert(tbTemp.nAccumulateLevelTimerId > 0)
      end
    end
  end

  function Player:CommitLevelUpInfo(nPlayerId)
    local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
    assert(pPlayer)
    local tbTemp = pPlayer.GetTempTable("Player")
    assert(tbTemp)
    local nAccumulateLevel = tbTemp.nAccumulateLevel
    if nAccumulateLevel then
      tbTemp.nAccumulateLevel = 0
      if nAccumulateLevel > 0 then
        pPlayer.AddExtPoint(7, nAccumulateLevel)
      elseif nAccumulateLevel < 0 then
        pPlayer.PayExtPoint(7, -nAccumulateLevel)
      end
    end
    if tbTemp.nAccumulateLevelTimerId then
      Setting:SetGlobalObj(pPlayer)
      Player:CloseTimer(tbTemp.nAccumulateLevelTimerId)
      Setting:RestoreGlobalObj()
      tbTemp.nAccumulateLevelTimerId = nil
    end

    return 0
  end

  --Kiểm tra dấu hiệu máy chủ thử nghiệm
  function Player:CheckIsXp()
    if EventManager.IVER_bOpenTiFu == 0 then
      return 0
    end
    return 1
  end

  function Player:ApplyJoinFaction(nFaction)
    if me.nFaction > 0 then
      Dialog:Say("Thiếu hiệp, ngươi đã gia nhập môn phái rồi!")
      return
    end

    local tbMenPai = Npc.tbMenPaiNpc
    tbMenPai:JoinZhuXiuFaction(nFaction)
  end

  function Player:GetViewInfo_GS(szName)
    if not szName then
      return
    end
    local nID = KGCPlayer.GetPlayerIdByName(szName)
    if not nID then
      return
    end
    local nFaction = KGCPlayer.GCPlayerGetInfo(nID).nFaction
    local nLevel = KGCPlayer.OptGetTask(nID, 11) -- emKGC_OPT_PLAYER_LEVEL = 11, lấy cấp độ người chơi

    me.CallClientScript({ "Player:GetViewInfo_C", nFaction, nLevel, szName })
  end

  Player.c2sFun["GetViewInfo_GS"] = Player.GetViewInfo_GS

  function Player:LogUiVersion(nUiVersion)
    if nUiVersion == 1 or nUiVersion == 2 then
      if me.GetTask(2063, 22) ~= nUiVersion then
        me.SetTask(2063, 22, nUiVersion)
        StatLog:WriteStatLog("stat_info", "Interface", "type", me.nId, nUiVersion)
      end
    end
  end

  Player.c2sFun["WriteUiVersionLog"] = Player.LogUiVersion

  function Player:OnReceiveClientGatesInfo(...)
    local tbArg = arg
    if tbArg.n < 2 then
      return
    end

    local szCorrectGate = tbArg[1]
    if szCorrectGate ~= GetGatewayName() then
      print("Invalide gate info from client!", szCorrectGate, GetGatewayName())
      return
    end

    self.tbGatesInfo = self.tbGatesInfo or {}
    self.tbGatesInfo[szCorrectGate] = self.tbGatesInfo[szCorrectGate] or {}

    for i = 2, tbArg.n do
      if not self.tbGatesInfo[szCorrectGate][tbArg[i]] then
        self.tbGatesInfo[szCorrectGate][tbArg[i]] = 1
      end
    end

    if not self.nGatesInfoSyncTimer then
      self.nGatesInfoSyncTimer = Timer:Register(Env.GAME_FPS * 60, self.SyncGatesInfoToGC, self)
    end
  end

  function Player:SyncGatesInfoToGC()
    if not self.tbGatesInfo or Lib:CountTB(self.tbGatesInfo) == 0 then
      return
    end

    GCExcute({ "Player:CollectGatesInfo_GC", self.tbGatesInfo })
    self.tbGatesInfo = nil -- Xóa
  end

  function Player:OnResetAllPlayerDragonBallState()
    for _, pPlayer in ipairs(KPlayer.GetAllPlayer()) do
      self:ResetDragonBallSate(pPlayer)
    end
  end

  function Player:ResetDragonBallSate(pPlayer)
    local nLastDay = pPlayer.GetTask(self.TASK_MAIN_GROUP, self.TASK_SUB_GROUP_RESET_DAY) -- Trực tiếp lưu trữ số ngày
    local nToday = Lib:GetLocalDay(GetTime())
    local nLocalDayTime = Lib:GetLocalDayTime(GetTime()) -- Thời gian đã trôi qua trong ngày hôm nay

    if nLocalDayTime < 3 * 3600 then -- Đã qua ngày mới nhưng trước 3 giờ, coi như là ngày hôm trước
      nToday = nToday - 1
    end

    if nLastDay ~= nToday then
      -- Nếu không thì coi như cần làm mới biến nhiệm vụ
      Item:SetDragonBallState(pPlayer, nil, 0, 1)
    end
  end

  function Player:ViewConsume()
    if me.IsAccountLock() ~= 0 then
      Dialog:Say("Tài khoản chưa mở khóa, không thể xem tiêu hao Kỳ Trân Các.")
      Account:OpenLockWindow(me)
      return 0
    end
    if Account:Account2CheckIsUse(me, 4) == 0 then
      Dialog:Say("Ngươi đang dùng mật khẩu phụ để đăng nhập game, đã thiết lập kiểm soát quyền hạn, không thể thực hiện thao tác này!")
      return 0
    end
    if IsLoginUseVicePassword(me.nPlayerIndex) == 1 then
      Dialog:Say("Ngươi dùng mật khẩu phụ để đăng nhập game, không thể thực hiện thao tác này.")
      return 0
    end
    local nNowYear = tonumber(GetLocalDate("%Y")) - 2011
    local nYear = me.GetTask(2070, 8)
    local nYearGrade = me.GetTask(2070, 5) + me.GetTask(2070, 2)
    local nLastYearGrade = me.GetTask(2070, 10)
    local nConsumeMonth = Spreader:IbShopGetConsume()
    local nConsumeLastM = me.GetTask(2070, 4)
    local nMoney = me.GetTask(2070, 6)
    if nNowYear >= 0 and nYear ~= nNowYear then
      nMoney = 0
      nLastYearGrade = nYearGrade
      nYearGrade = 0
    end
    local szTip = string.format("Tình hình tiêu hao Kỳ Trân Các như sau: \n\n<color=yellow>Tiêu hao tháng trước: %s<color>\n<color=yellow>Tiêu hao tháng này: %s<color>\n\n<color=yellow>Tổng tiêu hao năm ngoái: %s<color>\n<color=yellow>Tổng tiêu hao năm nay: %s<color>\n", nConsumeLastM, nConsumeMonth, nLastYearGrade, nYearGrade)
    Dialog:Say(szTip)
  end

  -- Giao diện phúc lợi đặc quyền
  function Player:OpenFuliTequan(nFlag)
    if GLOBAL_AGENT then
      return
    end
    if not nFlag or type(nFlag) ~= "number" then
      return
    end
    Player.tbBuyJingHuo:OpenBuJingHuo(me, 3)
    local nMonthPay = me.GetExtMonthPay()
    local nMonthConsume = Spreader:IbShopGetConsume()
    local nPrestigeActive = SpecialEvent.ChongZhiRepute:CheckISCanGetRepute()
    if nPrestigeActive ~= 1 then
      if SpecialEvent.ChongZhiRepute:CheckIsSetExt() == 1 then
        nPrestigeActive = -1
      end
    end
    local nKinWageActive = me.GetAccTask("tequan.kinWage")
    local nRank = GetPlayerHonorRankByName(me.szName, PlayerHonor.HONOR_CLASS_WEIWANG, 0)
    local nWeek = KGblTask.SCGetDbTaskInt(DBTASK_WEIWANG_WEEK)
    if nFlag == 1 then
      me.CallClientScript({ "UiManager:OpenWindow", "UI_FULITEQUAN", 1, nMonthPay, nMonthConsume, nPrestigeActive, nRank, nWeek, nKinWageActive })
    else
      me.CallClientScript({ "Ui:ServerCall", "UI_FULITEQUAN", "Update", 1, nMonthPay, nMonthConsume, nPrestigeActive, nRank, nWeek, nKinWageActive })
    end
  end

  Player.c2sFun["OpenFuliTequan"] = Player.OpenFuliTequan

  -- Mở giao diện PVP, PVE
  function Player:OpenFubenInfo(nFlag)
    if GLOBAL_AGENT then
      return
    end
    local nLadderType = 0
    nLadderType = KLib.SetByte(nLadderType, 3, 2)
    nLadderType = KLib.SetByte(nLadderType, 2, 2)
    nLadderType = KLib.SetByte(nLadderType, 1, 2)
    local nXoyoRank = GetTotalLadderRankByName(nLadderType, me.szName)
    if nXoyoRank < 0 then
      nXoyoRank = 0
    end
    local nSportMemGrade = 0
    local nSportRemainTimes = 0
    local nKinId, nMemberId = me.GetKinMember()
    local cKin = KKin.GetKin(nKinId)
    if cKin then
      local cMember = cKin.GetMember(nMemberId)
      if cMember then
        local nMonthNow = tonumber(GetLocalDate("%m"))
        local nMonth = cMember.GetKinGameMonth()
        if nMonthNow == nMonth then
          nSportMemGrade = cMember.GetKinGameGrade()
        end
      end
    end
    me.CallClientScript({ "UiManager:OpenWindow", "UI_FUBEN_INFO", nXoyoRank, nSportMemGrade })
    SuperBattle:SelectState_GS(me, 1)
  end

  --Player.c2sFun["OpenFubenInfo"] = Player.OpenFubenInfo; -- Giao diện phụ bản đã đóng, không còn sử dụng

  -- Nhận số lần Tàng Bảo Đồ
  function Player:GetTreasureTimes(nType, nId)
    if GLOBAL_AGENT then
      return
    end
    if me.nLevel < 25 then
      me.Msg("Chỉ hiệp khách đạt cấp 25 mới có thể nhận.")
      return
    end
    if nType == 3 and nId then ---Chỉ có cao cấp mới cần nhận thủ công
      local tbIdMap = {
        [1] = { ChenChongZhen.OnGiveChenChongZhenEnterItem, { ChenChongZhen } },
        [2] = { CrossTimeRoom.OnGiveCrossTimeRoomEnterItem, { CrossTimeRoom, me.nId } },
      }
      local szMapType = GetMapType(me.nMapId)
      if szMapType ~= "village" and szMapType ~= "city" then
        me.Msg("Chỉ có thể nhận ở thành thị hoặc tân thủ thôn.")
        return
      end
      if tbIdMap[nId] then
        tbIdMap[nId][1](unpack(tbIdMap[nId][2]))
      end
    end
  end

  Player.c2sFun["GetTreasureTimes"] = Player.GetTreasureTimes

  -- Đến các điểm báo danh PVE, PVP
  function Player:GoFubenEnter(nUseChuangSongFu, nType, nId)
    if nUseChuangSongFu == 1 then
      local tbChuangsongfu = Item:GetClass("chuansongfu")
      local tbFind = me.FindClassItemInBags("chuansongfu")
      local pItem = nil
      for _, tbItem in ipairs(tbFind) do
        local nParticular = tbItem.pItem.nParticular
        for nKey, _ in pairs(tbChuangsongfu.tbNewTransItem) do
          if nParticular == nKey then
            pItem = tbItem.pItem
            break
          end
        end
      end
      if not pItem then
        me.Msg("Ngươi không có Vô Hạn Truyền Tống Phù, không thể truyền tống đến điểm chỉ định")
        return
      end
      local szForbitMap = KItem.GetOtherForbidType(unpack(pItem.TbGDPL()))
      local nCanUse = 1
      if szForbitMap then
        nCanUse = KItem.CheckLimitUse(me.nMapId, szForbitMap)
      end
      if not nCanUse or nCanUse == 0 then
        me.Msg("Đạo cụ này bị cấm sử dụng tại bản đồ này!")
        return
      end
      if nType == 1 then -- Tiêu Dao Cốc
        tbChuangsongfu:OnTransItem(pItem, tbChuangsongfu.tbXiaoyaogu, tbChuangsongfu.tbNewTransItem[pItem.nParticular])
      elseif nType == 2 then -- Phụ bản Quân Doanh
        tbChuangsongfu:OnTransArmyCamp(pItem.dwId)
      elseif nType == 3 then -- Tống Kim bản server
        tbChuangsongfu:OnTransBattle(pItem.dwId)
      elseif nType == 4 then -- Bạch Hổ Đường
        tbChuangsongfu:OnTransItem(pItem, tbChuangsongfu.tbBaihutang, tbChuangsongfu.tbNewTransItem[pItem.nParticular])
      elseif nType == 5 then -- Danh sách Tân Thủ Thôn
        tbChuangsongfu:OnTransItem(pItem, tbChuangsongfu.tbHomeMap, tbChuangsongfu.tbNewTransItem[pItem.nParticular])
      elseif nType == 6 then -- Danh sách thành thị
        tbChuangsongfu:OnTransItem(pItem, tbChuangsongfu.tbCityMap, tbChuangsongfu.tbNewTransItem[pItem.nParticular])
      elseif nType == 7 then -- Danh sách môn phái
        tbChuangsongfu:OnTransItem(pItem, tbChuangsongfu.tbGenreMap, tbChuangsongfu.tbNewTransItem[pItem.nParticular])
      elseif nType == 8 then -- Điểm báo danh Tống Kim liên server
        tbChuangsongfu:OnTransItem(pItem, tbChuangsongfu.tbSuperBattle, tbChuangsongfu.tbNewTransItem[pItem.nParticular])
      end
    else
      -- Không cần thiết phải đặt ở server, client có thể tự thực hiện Dialog:say(), những gì đã làm rồi thì cứ để đó không đổi
      if nType == 1 then -- Tàng Bảo Đồ
        local tbPathInfo = {
          [1] = { szName = "Nghĩa Quân Quân Nhu Quan-Giang Tân Thôn", tbPos = { 5, 1639, 3103 } },
          [2] = { szName = "Nghĩa Quân Quân Nhu Quan-Vân Trung Trấn", tbPos = { 1, 1407, 3150 } },
          [3] = { szName = "Nghĩa Quân Quân Nhu Quan-Vĩnh Lạc Trấn", tbPos = { 3, 1634, 3172 } },
        }
        local tbOpt = {}
        for _, tbInfo in ipairs(tbPathInfo) do
          table.insert(tbOpt, { tbInfo.szName, Player.GoFubenEnterByAutoPath, Player, unpack(tbInfo.tbPos) })
        end
        table.insert(tbOpt, { "Để ta suy nghĩ lại" })
        Dialog:Say("Vui lòng chọn một điểm báo danh Tàng Bảo Đồ", tbOpt)
      elseif nType == 2 and nId then -- Tàng Bảo Đồ Cao Cấp
        local tbPathInfo = {
          [1] = { szName = "Thần Trùng Trấn", tbPos = { 2150, 1648, 3924 } },
          [2] = { szName = "Thời Quang Điện", tbPos = { 132, 1900, 3806 } },
        }
        local tbInfo = tbPathInfo[nId]
        if not tbInfo then
          return
        end
        Player:GoFubenEnterByAutoPath(unpack(tbInfo.tbPos))
      elseif nType == 3 then -- Gia Tộc Tranh Đoạt
        local tbPathInfo = {
          [1] = { szName = "Yến Nhược Tuyết--Giang Tân Thôn", tbPos = { 5, 1660, 3042 } },
          [2] = { szName = "Yến Nhược Tuyết--Vân Trung Trấn", tbPos = { 1, 1535, 3119 } },
          [3] = { szName = "Yến Nhược Tuyết--Vĩnh Lạc Trấn", tbPos = { 3, 1636, 3207 } },
        }
        local tbOpt = {}
        for _, tbInfo in ipairs(tbPathInfo) do
          table.insert(tbOpt, { tbInfo.szName, Player.GoFubenEnterByAutoPath, Player, unpack(tbInfo.tbPos) })
        end
        table.insert(tbOpt, { "Để ta suy nghĩ lại" })
        Dialog:Say("Vui lòng chọn một điểm báo danh Gia Tộc Tranh Đoạt", tbOpt)
      end
    end
  end

  Player.c2sFun["GoFubenEnter"] = Player.GoFubenEnter

  function Player:GoFubenEnterByAutoPath(nTargetMapId, nTargetX, nTargetY)
    me.CallClientScript({ "Ui.tbLogic.tbAutoPath:ProcessClick", { nMapId = nTargetMapId, nX = nTargetX, nY = nTargetY } })
  end

  -- Bắt đầu liên quan đến việc chỉnh sửa Nghĩa Quân Quân Nhu Quan
  --Người chơi báo danh Tàng Bảo Đồ
  function Player:SignTreasure(szTypeName, nStar)
    TreasureMap.TreasureMapEx:SignMap(szTypeName, nStar)
    --TreasureMap.TreasureMapEx:ApplyTreasureMap(nil, pFind.dwId);--随机
  end
  Player.c2sFun["SignTreasure"] = Player.SignTreasure

  -- Yêu cầu đồng bộ thông tin Tàng Bảo Đồ/Bí Cảnh
  function Player:ApplyTreasuremapInfo()
    TreasureMap.TreasureMapEx:ApplyTreasuremapInfo(me)
  end
  Player.c2sFun["ApplyTreasuremapInfo"] = Player.ApplyTreasuremapInfo

  --Người chơi vào Tàng Bảo Đồ
  function Player:EnterTreasure()
    TreasureMap.TreasureMapEx:EnterTreasure()
  end
  Player.c2sFun["EnterTreasure"] = Player.EnterTreasure

  --Vào Đắc Nguyệt Phảng
  function Player:EnterDeYuefang()
    FightAfter:ApplyFreeRoomForMe()
  end
  Player.c2sFun["EnterDeYuefang"] = Player.EnterDeYuefang

  --Mở Bí Cảnh
  function Player:SignFourfold()
    Task.FourfoldMap:SignMap_UI()
  end
  Player.c2sFun["SignFourfold"] = Player.SignFourfold

  --Vào Bí Cảnh
  function Player:EnterFourfold()
    Task.FourfoldMap:EnterMap_UI()
  end
  Player.c2sFun["EnterFourfold"] = Player.EnterFourfold
  -- Kết thúc liên quan đến việc chỉnh sửa Nghĩa Quân Quân Nhu Quan

  -- Thông tin đặc biệt giao diện lịch
  function Player:ApplyCalendarInfo()
    if GLOBAL_AGENT then
      return
    end
    local nKinId, nMemberId = me.GetKinMember()
    local cKin = KKin.GetKin(nKinId)
    local nKinGameTimes = 0
    local nKinBossTimes = 0
    if cKin then
      local nTime = cKin.GetKinGameTime()
      nKinGameTimes = cKin.GetKinGameDegree()
      if os.date("%W", nTime) ~= os.date("%W", GetTime()) then
        nKinGameTimes = 0
      end
      nKinBossTimes = HomeLand:GetTodayChallengeTimes(nKinId)
    end

    me.CallClientScript({ "Ui:ServerCall", "UI_NEWCALENDARVIEW", "OnServerInfoUpdate", nKinGameTimes, nKinBossTimes })
    SuperBattle:SelectState_GS(me, 1)
  end

  Player.c2sFun["ApplyCalendarInfo"] = Player.ApplyCalendarInfo

  -- Giao diện kịch bản nhắc nhở tin nhắn
  function Player:ApplyMessagePushMsg(szKey, vParam1, vParam2, vParam3)
    if GLOBAL_AGENT then
      return
    end
    if "kuafuliansaigu" == szKey then
      Npc:GetClass("gbwlls_praynpc"):OnDialog()
    end
  end

  Player.c2sFun["ApplyMessagePushMsg"] = Player.ApplyMessagePushMsg

  -- Lương gia tộc đặc quyền
  function Player:ActionKinWage()
    if GLOBAL_AGENT then
      return
    end
    local nAction = me.GetTask(2196, 1)
    local nDate = tonumber(GetLocalDate("%Y%m"))
    --Đã kích hoạt
    if nAction >= nDate then
      return
    end
    if me.GetExtMonthPay() < EventManager.IVER_nPlayerFuli_KinWage then
      me.Msg("Cần nạp đạt 50 tệ mới có thể kích hoạt chức năng này.")
      return
    end
    --Tài khoản đã được kích hoạt
    if me.GetAccTask("tequan.kinWage") >= nDate then
      me.Msg("Mỗi tài khoản chỉ có thể kích hoạt một nhân vật.")
      return
    end

    me.SetAccTask("tequan.kinWage", nDate)
    me.SetTask(2196, 1, nDate)
    me.Msg("Ngươi đã kích hoạt thành công tư cách đặc quyền lương gia tộc.")
    Dbg:WriteLog("TeQuanFuli", "Kích hoạt tư cách đặc quyền lương gia tộc", me.szName)
    me.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, "Kích hoạt tư cách đặc quyền lương gia tộc")
  end
  Player.c2sFun["ActionKinWage"] = Player.ActionKinWage

  function Player:OpenConsumeUrl()
    me.CallClientScript({ "OpenWebSite", "http://zt.xoyo.com/jxsj/mall/" })
  end

  -- Nhắc nhở xóa điểm tích lũy cuối năm
  function Player:ConsumeClearPrompt()
    local nDate = tonumber(GetLocalDate("%m%d"))
    if nDate < self.COMSUME_CLEAR_PROMPT_DAY then
      return
    end
    local nMoney = me.GetTask(2070, 6)
    if nMoney < self.COMSUME_CLEAR_PROMPT_POINT then
      return
    end
    local nYear = GetLocalDate("%Y")
    me.Msg(string.format("Nhắc nhở thân thiện: %s năm 12 tháng 31 ngày 24 giờ điểm tiêu hao Kỳ Trân Các của bạn sẽ bị xóa, vui lòng sử dụng hết điểm tiêu hao của bạn càng sớm càng tốt.<color=yellow>CTRL+G hoặc Kỳ Trân Các để mở cửa hàng điểm<color>", nYear))
  end

  function Player:OnPlayerLeaveTeam()
    local pCarrier = me.GetCarrierNpc()
    if not pCarrier then
      return
    end

    Npc.tbCarrier:OnPlayerLeaveTeam(pCarrier, me)
  end
end

if MODULE_GAMECLIENT then
  -- Lấy tên người chơi từ client
  function Player:GetPlayerName()
    if not me or not me.szName then
      return ""
    end
    return me.szName
  end
  function Player:GetViewInfo_C(nFaction, nLevel, szName)
    local szNameShow = "Tên người chơi: " .. "<color=yellow>" .. szName .. "<color>"
    local szFaction = "Cấp người chơi: " .. "<color=yellow>" .. nLevel .. "<color>"
    local szLevel = "Môn phái người chơi: " .. "<color=yellow>" .. Player:GetFactionRouteName(nFaction) .. "<color>"
    local szMsg = string.format("%s\n\n%s\n\n%s\n", szNameShow, szLevel, szFaction)
    ShowEquipLink("", szMsg, "")
  end

  --Xem thông tin người chơi
  function Player:GetViewInfo(szName)
    me.CallServerScript({ "PlayerCmd", "GetViewInfo_GS", szName })
  end

  function Player:OnSelectNpc(pNpc)
    local tbTemp = me.GetTempTable("Npc")
    tbTemp.pSelectNpc = pNpc
    tbTemp.nSelectpNpcId = (pNpc and pNpc.dwId) or nil
    CoreEventNotify(UiNotify.emCOREEVENT_SYNC_SELECT_NPC)
  end

  function Player:OnChangeState(nState)
    CoreEventNotify(UiNotify.emCOREEVENT_CHANGEWAITGETITEMSTATE, nState)
    if nState == 2 then
      CoreEventNotify(UiNotify.emCOREEVENT_UPDATEBANKINFO)
    end
  end

  function Player:NotifyItemTimeOutClient(nType, szDate)
    if szDate and nType == 46 then -- Phiếu hoàn trả
      me.Msg("Phiếu hoàn trả của bạn sẽ hết hạn và biến mất vào " .. szDate .. "，vui lòng sử dụng hết để tránh lãng phí.")
    elseif nType == 45 then
      me.Msg("Trong túi đồ hoặc kho của bạn có Huyền Tinh sắp hết hạn, vui lòng sử dụng kịp thời.")
    end
    CoreEventNotify(UiNotify.emCOREEVENT_SET_POPTIP, nType)
  end

  function Player:OnBuyJiuZhuan()
    local tbMsg = {}
    tbMsg.szMsg = string.format("Ngươi không có<color=yellow>Cửu Chuyển Tục Mệnh Hoàn<color>。Ngươi có muốn tiêu <color=red>50%s<color>để trị thương tại chỗ？", IVER_g_szCoinName)
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex)
      if nOptIndex == 2 then
        if me.IsAccountLock() ~= 0 then
          UiNotify:OnNotify(UiNotify.emCOREEVENT_SET_POPTIP, 44)
          me.Msg("Tài khoản của ngươi đang bị khóa, không thể thực hiện thao tác này!")
          Account:OpenLockWindow(me)
          return
        end
        if IVER_g_nSdoVersion == 0 then
          if me.nCoin >= 50 then
            me.CallServerScript({ "ApplyBuyJiuZhuan" })
          else
            me.Msg("Số Đồng trên người ngươi không đủ.")
          end
        else
          me.CallServerScript({ "ApplyBuyJiuZhuan" })
        end
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
  end

  function Player:UpdateDrawMantle()
    Ui(Ui.UI_PLAYERPANEL):UpdateDrawMantle()
  end

  function Player:GetPluginUseState()
    local tbNameList = KInterface.GetPluginNameList() or {}
    local nState = KInterface.GetPluginManagerLoadState()
    if 1 == nState then
      local nPluginNum = 0
      for _, szName in pairs(tbNameList) do
        local tbInfo = KInterface.GetPluginInfo(szName)
        if tbInfo.nLoadState == 1 then
          nPluginNum = nPluginNum + 1
        end
      end
      if nPluginNum > 0 then
        me.CallServerScript({ "RecordPluginUseState", me.szName, nPluginNum })
      end
    end
  end

  function Player:JiesuoNotify()
    local tbMsg = {}
    tbMsg.szMsg = "Khóa tài khoản của bạn đã được xóa."
    tbMsg.nOptCount = 1
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
  end

  -- Nhắc nhở người dùng đang yêu cầu hủy khóa tài khoản
  function Player:ApplyJiesuoNotify(dwApplyTime)
    local tbMsg = {}
    tbMsg.szMsg = "Tài khoản của bạn đang <color=red>yêu cầu tự mở khóa<color>，nhấp vào “Xác nhận” để xem chi tiết."
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex)
      if nOptIndex == 2 then
        local szSay = "Một nhân vật khác trong tài khoản của bạn đã yêu cầu tắt bảo vệ tài khoản. Nếu bạn không thực hiện thao tác này, vui lòng hủy yêu cầu ngay lập tức, quét virus trojan bằng phần mềm diệt virus mới nhất và thay đổi mật khẩu game để đảm bảo an toàn cho tài khoản của bạn。" .. "\nLưu ý: Yêu cầu tắt bảo vệ tài khoản sẽ có hiệu lực khi đăng nhập lại sau <color=yellow>5<color> ngày kể từ ngày yêu cầu。"
        if dwApplyTime ~= nil then
          szSay = "Bạn đã yêu cầu tắt bảo vệ tài khoản vào <color=white><bclr=blue>" .. os.date("%Y năm %m tháng %d ngày %H:%M:%S", dwApplyTime) .. "<bclr><color>。Nếu bạn không thực hiện thao tác này, vui lòng hủy yêu cầu ngay lập tức, quét virus trojan bằng phần mềm diệt virus mới nhất và thay đổi mật khẩu game để đảm bảo an toàn cho tài khoản của bạn。" .. "\nLưu ý: Yêu cầu tắt bảo vệ tài khoản sẽ có hiệu lực khi đăng nhập lại sau <color=white><bclr=blue>" .. os.date("%Y năm %m tháng %d ngày %H:%M:%S", dwApplyTime + 5 * 24 * 60 * 60) .. "<bclr><color>。"
        end
        if UiManager:WindowVisible(Ui.UI_SAYPANEL) == 1 then -- Khi có hộp thoại như kinh nghiệm Bạch Câu mở
          me.Msg(szSay)
        else
          Dialog:Say(szSay)
        end
      end
    end

    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)

    Player.bApplyingJiesuo = 1
  end

  function Player:SyncJiesuoState_C(bCanApplyJiesuo, bApplyingJiesuo, dwApplyTime)
    self.bCanApplyJiesuo = bCanApplyJiesuo
    self.bApplyingJiesuo = bApplyingJiesuo
    self.dwApplyJiesuoTime = dwApplyTime
  end

  function Player:SetActiveAura(nActiveAura)
    me.SetAuraSkill(nActiveAura)
  end

  function Player:BindInfoSync(nBind1, nBind2)
    if UiManager:WindowVisible(Ui.UI_REPOSITORY) == 1 then
      Ui(Ui.UI_REPOSITORY):UpdateBindInfo(nBind1, nBind2)
    end
  end
end

-- 客户端 当生命低于25%时候
------------------------------------------------------------------------
function Player:LifeIsPoor_C()
  if me.nLevel > 20 then
    return
  end

  local bHave = false
  local tbBuffList = me.GetBuffList()
  for i = 1, #tbBuffList do
    local tbInfo = me.GetBuffInfo(tbBuffList[i].uId)
    if tbInfo.nSkillId == 476 then
      bHave = true
    end
  end

  local pNpc = me.GetNpc()
  if not bHave and pNpc then
    pNpc.Chat("Điềm Tửu thúc đã nhắc ta phải ăn thức ăn khi chiến đấu ngoài trời!")
  end
end

function Player:LogPluginUseState(bExchangeServerComing)
  if bExchangeServerComing ~= 1 then
    me.CallClientScript({ "Player:GetPluginUseState" })
  end
end

function Player:CallGlobalFriends(szFunc, ...)
  return Player.tbGlobalFriends[szFunc](Player.tbGlobalFriends, ...)
end

function Player:TellNewServerRule(nServerOpenDays, nLimit)
  local szMsg = string.format("Để nhiều người chơi hơn có thể trải nghiệm game, bạn chỉ có thể đăng nhập tối đa %d client vào máy chủ đã mở được <color=green>%d ngày<color>。", nLimit, nServerOpenDays)

  local tbMsg = {}
  tbMsg.szMsg = szMsg
  tbMsg.nOptCount = 1
  tbMsg.tbOptTitle = { "Xác nhận" }
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
end

-- Xóa điểm nạp đã tiêu trong tháng
function Player:ResetMonthPayPoint()
  me.SetTask(2137, 2, 0)
  me.SetTask(2137, 3, GetTime())
end

function Player:OnLogin_DrawMantle()
  local nValue = me.GetTask(self.TSK_GROUP_HIDE_MANTLE, self.TSK_SUB_HIDE_MANTLE)
  me.SetBeHideMantle(nValue)
  -- Thông báo cho UI thiết lập trạng thái nút
  me.CallClientScript({ "Player:UpdateDrawMantle" })
end

function Player:IsHideMantle()
  local nValue = me.GetTask(self.TSK_GROUP_HIDE_MANTLE, self.TSK_SUB_HIDE_MANTLE)
  return nValue
end

-- Player.c2sFun = {};
function Player:OnClientClickHideMantle(nPlayerId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return
  end

  local nTask = pPlayer.GetTask(self.TSK_GROUP_HIDE_MANTLE, self.TSK_SUB_HIDE_MANTLE)
  if nTask == 0 then -- Yêu cầu ẩn áo choàng
    pPlayer.SetTask(self.TSK_GROUP_HIDE_MANTLE, self.TSK_SUB_HIDE_MANTLE, 1)
  else -- Yêu cầu hủy ẩn áo choàng
    pPlayer.SetTask(self.TSK_GROUP_HIDE_MANTLE, self.TSK_SUB_HIDE_MANTLE, 0)
  end

  pPlayer.SetBeHideMantle(pPlayer.GetTask(self.TSK_GROUP_HIDE_MANTLE, self.TSK_SUB_HIDE_MANTLE))
end
Player.c2sFun["OnClickHideMantle"] = Player.OnClientClickHideMantle

function Player:ClientApplyRepositoryInfo(nPlayerId, nType)
  -- Không thể không có TYPE
  if not nType then
    return
  end

  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not Player then
    return
  end

  me.ApplyRepItemInfo(nType)
end
Player.c2sFun["ApplyRepositoryInfo"] = Player.ClientApplyRepositoryInfo

function Player:ViewEquipOnMe(pViewPlayer)
  if not pViewPlayer then
    return
  end

  local nHonorLevel = me.GetHonorLevel()
  local szMsg = self.tbViewEquipMsg[nHonorLevel] or ""
  if szMsg and szMsg ~= "" then
    me.Msg(string.format("%s%s", pViewPlayer.szName, szMsg))
    me.CallClientScript({ "UiManager:OpenWindow", "UI_INFOBOARD", string.format("<color=yellow>%s%s<color>", pViewPlayer.szName, szMsg) })
    --pViewPlayer.Msg(self.szBeViewdEquipMsg);
    --pViewPlayer.CallClientScript({"UiManager:OpenWindow", "UI_INFOBOARD", string.format("<color=yellow>%s<color>", self.szBeViewdEquipMsg)});
  end
end

--Để giảm số lượng gói tin client nhận, xử lý các thông báo lặp lại một lần
function Player:BuyGoodsMsg(nCount, szGoodsName)
  if not MODULE_GAMESERVER then
    return
  end
  if not nCount or nCount == 0 then
    return
  end
  if not szGoodsName or #szGoodsName == 0 then
    return
  end
  me.Msg(string.format("Bạn đã nhận được tổng cộng %d个%s!", nCount, szGoodsName), "")
end

-- Gửi tin nhắn cho người chơi có tên được chỉ định
function Player:Msg2Player(szPlayerName, szMsg, szTitle)
  local pPlayer = KPlayer.GetPlayerByName(szPlayerName)
  if not pPlayer then
    return 0
  end
  pPlayer.Msg(szMsg, szTitle)
end

function Player:GetCloseSyncTeamResultFlag()
  return tonumber(KGblTask.SCGetDbTaskInt(DBTASK_CLOASE_TEAMLINK)) or 0
end

--Thiết lập trạng thái tân thủ, nếu trạng thái là 1 thì kiểm tra cấp 50 sẽ không hợp lệ
function Player:SetFreshState(pPlayer, nState)
  if nState <= 0 then
    nState = 0
  elseif nState > 1 then
    nState = 1
  end
  pPlayer.SetTask(2179, 20, nState)
  pPlayer.SendSyncData()
end

function Player:ClearPlayerGlobalLoginState_Normal_GS()
  KGCPlayer.ClearGlobalPlayerLoginState_Normal()
end

function Player:SetGlobalLoginState_Normal_GS(nPlayerId, nState)
  KGCPlayer.SetPlayerGlobalLoginState_Normal(nPlayerId, nState)
end

function Player:GetGlobalLoginState_Normal(nPlayerId)
  return KGCPlayer.GetPlayerGlobalLoginState_Normal(nPlayerId)
end

function Player:GetMyGateway()
  -- Lấy Gateway của máy chủ thường mà mình đang ở, bất kể hiện tại đang ở máy chủ thường hay máy chủ toàn cục
  return Transfer:GetMyGateway(me)
end

--Lấy dấu hiệu liên server, sau khi liên server là 1, nếu không là 0
function Player:GetTransferStatus()
  return me.GetTask(self.tbTransferStatus[1], self.tbTransferStatus[2])
end
-------------------------------------------------------------------------

-- Đăng ký sự kiện online chung
PlayerEvent:RegisterGlobal("OnLogin", Player._OnLogin, Player)

-- Đăng ký sự kiện offline chung
PlayerEvent:RegisterGlobal("OnLogout", Player._OnLogout, Player)

-- Đăng ký gọi lại khi lên cấp
PlayerEvent:RegisterGlobal("OnLevelUp", Player._OnLevelUp, Player)

-- Đăng ký sự kiện người chơi tử vong
PlayerEvent:RegisterGlobal("OnDeath", Player._OnDeath, Player)

-- Đăng ký sự kiện giết quái chung
PlayerEvent:RegisterGlobal("OnKillNpc", Player._OnKillNpc, Player)

PlayerEvent:RegisterGlobal("OnCampChange", Player._OnCampChange, Player)

-- Đăng ký sự kiện xóa định kỳ việc sử dụng sách tâm đắc
PlayerSchemeEvent:RegisterGlobalDailyEvent({ Player.ClearInsightBookUsedCount, Player })

PlayerEvent:RegisterGlobal("OnLoginOnly", Player.OnLogin_AccountSafe, Player)

PlayerEvent:RegisterGlobal("OnLoginOnly", Player.OnLogin_StatComeBack, Player)

PlayerEvent:RegisterGlobal("OnLoginOnly", Player.OnLogin_OnSetComeBackOldPlayer, Player)

PlayerEvent:RegisterGlobal("OnLoginOnly", Player.LogPluginUseState, Player)

PlayerSchemeEvent:RegisterGlobalMonthEvent({ Player.ResetMonthPayPoint, Player })

PlayerEvent:RegisterGlobal("OnLogin", Player.OnLogin_DrawMantle, Player)
---- Đăng ký xóa định kỳ xxxx
--PlayerSchemeEvent:RegisterGlobalDailyEvent({Player.ClearCibeixinjingUsedAmount, Player});
--
