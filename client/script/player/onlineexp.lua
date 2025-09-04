-- Tên tệp　：onlineexp.lua
-- Người tạo　：zhouchenfei
-- Thời gian tạo：2009-05-11 10:01:14
-- Mô tả tệp：Liên quan đến ủy thác online

local tbOnlineExp = Player.tbOnlineExp or {} -- Hỗ trợ tải lại
Player.tbOnlineExp = tbOnlineExp

tbOnlineExp.TIME_GIVEEXP = 5 -- Khoảng thời gian ủy thác online cho kinh nghiệm, và thời gian cho kinh nghiệm
tbOnlineExp.TIME_AUTOOPENONLINE = 60 * 5 -- Thời gian tự động vào ủy thác online khi không có thao tác
tbOnlineExp.TIME_CHECKONLINESTATE = 30 -- Thời gian client vào game để phán đoán trạng thái hành động của người chơi, 2 giây
tbOnlineExp.ONLINESTATE_ID = 1296
tbOnlineExp.ONLINESTATE_TIME = 60 * 60 * 24 * 100 -- Cố ý đặt rất lớn
tbOnlineExp.HEAD_STATE_SKILLID = 349
tbOnlineExp.IS_OPEN = EventManager.IVER_bOpenOnLineExp

tbOnlineExp.tbAllowOnlineMap = { -- Bản đồ có thể ủy thác online
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  23,
  24,
  25,
  26,
  27,
  28,
  29,
  1401,
  1402,
  1403,
  1404,
  1405,
  1406,
  1407,
  1408,
  1409,
  1410,
  1411,
  1412,
  1437,
  1438,
  1439,
  1440,
  1441,
  1442,
  1443,
  1444,
  1445,
  1446,
  1447,
  1448,
}

function tbOnlineExp:GetTempOnlineExp(pPlayer)
  local tbTemp = Player:GetPlayerTempTable(pPlayer).tbOnlineExp
  if not tbTemp then
    tbTemp = {}
    tbTemp.nOnlineX = -1
    tbTemp.nOnlineY = -1
    tbTemp.nOnlineMapId = -1
    tbTemp.nLastStandTime = 0
    tbTemp.nTimerId_CheckOnlineState = 0
    tbTemp.nOnlineExpState = 0
    tbTemp.nLogExp = 0
    Player:GetPlayerTempTable(pPlayer).tbOnlineExp = tbTemp
  end
  return tbTemp
end

function tbOnlineExp:SetOnlineState(nState, pPlayer)
  if self.IS_OPEN ~= 1 then
    return 0
  end
  if not pPlayer then
    pPlayer = me
  end
  local tbTemp = self:GetTempOnlineExp(pPlayer)
  tbTemp.nOnlineExpState = nState
  if MODULE_GAMESERVER then
    pPlayer.CallClientScript({ "Player.tbOnlineExp:SetOnlineState", nState })
  end
end

function tbOnlineExp:GetOnlineState(pPlayer)
  if not pPlayer then
    pPlayer = me
  end
  local tbTemp = self:GetTempOnlineExp(pPlayer)
  return tbTemp.nOnlineExpState
end

function tbOnlineExp:WriteLog(...)
  if MODULE_GAMESERVER then
    Dbg:WriteLogEx(Dbg.LOG_INFO, "Player", "OnlineExp", unpack(arg))
  end
  if MODULE_GAMECLIENT then
    Dbg:Output("Player", "OnlineExp", unpack(arg))
  end
end

if MODULE_GAMECLIENT then
  function tbOnlineExp:UpdateState(nFlag)
    if nFlag then
      if 1 == nFlag then
        me.AddSkillEffect(self.HEAD_STATE_SKILLID)
      elseif 2 == nFlag then
        me.RemoveSkillEffect(self.HEAD_STATE_SKILLID)
      end
    end
    local tbTemp = self:GetTempOnlineExp(me)
    local nMapId, nX, nY = me.GetWorldPos()
    tbTemp.nOnlineMapId = nMapId
    tbTemp.nOnlineX = nX
    tbTemp.nOnlineY = nY
    CoreEventNotify(UiNotify.emCOREEVENT_UPDATEONLINEEXPSTATE)
  end

  -- Phán đoán vào trạng thái sau năm phút, mở timer này
  function tbOnlineExp:OnStartCheckOnlineExpState()
    if self.IS_OPEN ~= 1 then
      return 0
    end
    local tbTemp = self:GetTempOnlineExp(me)
    tbTemp.nOnlineMapId, tbTemp.nOnlineX, tbTemp.nOnlineY = me.GetWorldPos()
    tbTemp.nLastStandTime = GetTime()
    tbTemp.nTimerId_CheckOnlineState = Ui.tbLogic.tbTimer:Register(self.TIME_CHECKONLINESTATE * Env.GAME_FPS, self.OnTimer_CheckOnlineExpState, self)
  end

  -- Phán đoán vào trạng thái sau năm phút, mở timer này
  function tbOnlineExp:OnEndCheckOnlineExpState()
    local tbTemp = self:GetTempOnlineExp(me)
    tbTemp.nOnlineMapId, tbTemp.nOnlineX, tbTemp.nOnlineY = 0, 0, 0
    tbTemp.nLastStandTime = 0
    if tbTemp.nTimerId_CheckOnlineState and tbTemp.nTimerId_CheckOnlineState > 0 then
      Ui.tbLogic.tbTimer:Close(tbTemp.nTimerId_CheckOnlineState)
    end
    tbTemp.nTimerId_CheckOnlineState = 0
  end

  -- Kiểm tra xem người chơi có thể tự động vào trạng thái ủy thác online không, điều kiện là không di chuyển trong năm phút
  function tbOnlineExp:OnTimer_CheckOnlineExpState()
    local tbTemp = self:GetTempOnlineExp(me)
    local nMapId, nX, nY = me.GetWorldPos()
    local nNowTime = GetTime()
    local nFlag = self:GetOnlineState(me)

    if me.nLevel < 20 then
      tbTemp.nLastStandTime = nNowTime
      return
    end

    if nMapId ~= tbTemp.nOnlineMapId or nX ~= tbTemp.nOnlineX or nY ~= tbTemp.nOnlineY then
      tbTemp.nLastStandTime = nNowTime
      tbTemp.nOnlineMapId = nMapId
      tbTemp.nOnlineX = nX
      tbTemp.nOnlineY = nY
      if 1 == nFlag then
        me.CallServerScript({ "ApplyUpdateOnlineState", 0 })
        me.Msg("Bạn đã rời khỏi nơi ủy thác ban đầu, thoát ủy thác online")
      end
      return
    end

    if 1 == nFlag then
      return
    end

    if tbTemp.nLastStandTime == 0 then
      tbTemp.nLastStandTime = nNowTime
    end

    -- Chưa đủ 5 phút
    if nNowTime - tbTemp.nLastStandTime < self.TIME_AUTOOPENONLINE then
      return
    end
    --Trạng thái chiến đấu không tự động ủy thác
    if 1 == me.nFightState then
      return
    end

    -- Không di chuyển trong năm phút sẽ tự động vào ủy thác online
    AutoAi.Sit()
    me.CallServerScript({ "ApplyUpdateOnlineState", 1 })
    tbTemp.nLastStandTime = nNowTime
    return
  end
end

if MODULE_GAMESERVER then
  function tbOnlineExp:OnApplyUpdateState(nChangerState)
    local nState = self:GetOnlineState(me)
    if nChangerState == nState then
      return
    end

    local nFlag = 0

    if 1 == nChangerState then
      if self.IS_OPEN ~= 1 then
        return 0
      end
      self:OpenOnlineExp()
    else
      self:CloseOnlineExp()
      me.Msg("Thoát ủy thác online")
    end
  end

  function tbOnlineExp:OpenOnlineExp()
    if self.IS_OPEN ~= 1 then
      return 0
    end
    local pPlayer = me
    local nState = self:GetOnlineState(pPlayer)
    if 1 == nState then
      return 0
    end
    local nFlag, szMsg = self:CheckCanOnline(pPlayer)
    if 0 ~= nFlag then
      pPlayer.Msg(szMsg)
      return 0
    end

    -- timerid của người chơi được lưu trong bảng tạm
    local tbTemp = self:GetTempOnlineExp(pPlayer)
    if tbTemp.nOnlineExpOpenStateTimer and tbTemp.nOnlineExpOpenStateTimer > 0 then
      Player:CloseTimer(tbTemp.nOnlineExpOpenStateTimer)
    end
    Dialog:SetBattleTimer(me) -- Đóng timer có thể có
    tbTemp.nOnlineExpOpenStateTimer = Player:RegisterTimer(Env.GAME_FPS * self.TIME_GIVEEXP, self.OnTimer_GiveExp, self)

    self:SetOnlineState(1, pPlayer)
    tbTemp.nOnlineMapId, tbTemp.nOnlineX, tbTemp.nOnlineY = pPlayer.GetWorldPos()
    pPlayer.AddSkillState(self.ONLINESTATE_ID, 1, 0, self.ONLINESTATE_TIME * Env.GAME_FPS)

    pPlayer.Msg("Bắt đầu ủy thác online, nhân vật không thể di chuyển")
    pPlayer.CallClientScript({ "Player.tbOnlineExp:UpdateState", 1 })
    self:WriteOpenLog(pPlayer)
    return 1
  end

  function tbOnlineExp:CloseOnlineExp()
    local pPlayer = me

    local nState = self:GetOnlineState(pPlayer)
    if 0 == nState then
      return 0
    end

    self:SetOnlineState(0, pPlayer)
    Dialog:ShowBattleMsg(pPlayer, 0, 0)

    local tbTemp = self:GetTempOnlineExp(pPlayer)
    if tbTemp.nOnlineExpOpenStateTimer and tbTemp.nOnlineExpOpenStateTimer > 0 then
      Player:CloseTimer(tbTemp.nOnlineExpOpenStateTimer)
    end

    tbTemp.nOnlineExpOpenStateTimer = 0
    pPlayer.RemoveSkillState(self.ONLINESTATE_ID)
    pPlayer.CallClientScript({ "Player.tbOnlineExp:UpdateState", 2 })
    self:WriteCloseLog(pPlayer)
    return 1
  end

  function tbOnlineExp:WriteOpenLog(pPlayer)
    local tbTemp = self:GetTempOnlineExp(pPlayer)
    tbTemp.nLogExp = 0

    local nOfflineTime = Player.tbOffline:GetTodayRestOfflineTime()
    local szMsg = "OpenOnlineExp " .. pPlayer.szName .. "ủy thác còn lại：" .. nOfflineTime .. ", "

    for key, tbBaiju in ipairs(Player.tbOffline.BAIJU_DEFINE) do
      local nRestTime = me.GetTask(5, tbBaiju.nTaskId)
      szMsg = szMsg .. nRestTime .. ","
    end
    self:WriteLog(pPlayer.szName, szMsg)
  end

  function tbOnlineExp:WriteCloseLog(pPlayer)
    local tbTemp = self:GetTempOnlineExp(pPlayer)
    local nOfflineTime = Player.tbOffline:GetTodayRestOfflineTime()
    local szMsg = "CloseOnlineExp " .. pPlayer.szName .. "ủy thác còn lại：" .. nOfflineTime .. ", "

    szMsg = szMsg .. "thêm exp: " .. tbTemp.nLogExp .. ", thời gian còn lại："

    for key, tbBaiju in ipairs(Player.tbOffline.BAIJU_DEFINE) do
      local nRestTime = me.GetTask(5, tbBaiju.nTaskId)
      szMsg = szMsg .. nRestTime .. ","
    end

    self:WriteLog(pPlayer.szName, szMsg)
  end

  function tbOnlineExp:GiveExpInfo(pPlayer, nExp)
    local tbTemp = self:GetTempOnlineExp(pPlayer)
    tbTemp.nLogExp = tbTemp.nLogExp + nExp
  end

  function tbOnlineExp:OnTimer_GiveExp()
    local pPlayer = me
    local nMapId, nX, nY = pPlayer.GetWorldPos()
    local nState = self:GetOnlineState(pPlayer)
    local tbTemp = self:GetTempOnlineExp(pPlayer)
    if 1 == nState and (nMapId ~= tbTemp.nOnlineMapId or nX ~= tbTemp.nOnlineX or nY ~= tbTemp.nOnlineY) then
      pPlayer.Msg("Bạn đã rời khỏi nơi ủy thác ban đầu, ủy thác online kết thúc.")
      self:CloseOnlineExp()
      return 0
    end

    local nFlag, szMsg = self:CheckCanOnline(pPlayer)
    if 0 ~= nFlag then
      pPlayer.Msg(szMsg)
      pPlayer.Msg("Thoát ủy thác online")
      self:CloseOnlineExp()
      return 0
    end

    nFlag = Player.tbOffline:AddSpecialExp(pPlayer, self.TIME_GIVEEXP, 1)
    if 3 == nFlag then -- Không còn thời gian bổ sung ủy thác
      pPlayer.Msg("Thời gian ủy thác còn lại của bạn hôm nay là 0, thoát ủy thác online")
      self:CloseOnlineExp()
      return 0
    elseif 2 == nFlag then -- Không còn thời gian Bạch Câu
      pPlayer.Msg("Thời gian Bạch Câu của bạn không đủ, ủy thác online kết thúc.")
      Dialog:Say("Thời gian Bạch Câu của bạn không đủ, ủy thác online kết thúc. Vui lòng bổ sung thời gian Bạch Câu.")
      self:CloseOnlineExp()
      return 0
    end

    if 1 ~= nFlag then
      self:CloseOnlineExp()
      pPlayer.Msg("Thoát ủy thác online")
      return 0
    end

    local szMsg = self:GetOnlineRightInfo()
    Dialog:SendBattleMsg(pPlayer, szMsg)
    Dialog:ShowBattleMsg(pPlayer, 1, 0)
  end

  function tbOnlineExp:GetOnlineRightInfo()
    local szMsg = "<color=gold>Ủy thác Online<color>\n"

    local nOfflineTime = Player.tbOffline:GetTodayRestOfflineTime()
    szMsg = szMsg .. "<color=green>Thời gian ủy thác còn lại hôm nay：<color>\n" .. "<color=yellow>" .. self:GetTimeDes(nOfflineTime) .. "<color>\n\n"

    for key, tbBaiju in ipairs(Player.tbOffline.BAIJU_DEFINE) do
      if tbBaiju.nShowFlag == 1 then
        local nRestTime = me.GetTask(5, tbBaiju.nTaskId)
        szMsg = szMsg .. "<color=green>Thời gian còn lại<color=white>" .. Lib:StrTrim(tbBaiju.szName, " ") .. "<color>：<color>\n<color=yellow>" .. self:GetTimeDes(nRestTime) .. "<color>\n\n"
      end
    end
    szMsg = szMsg .. "Có thể kết thúc ủy thác online trong bảng cài đặt hệ thống"

    return szMsg
  end

  function tbOnlineExp:GetTimeDes(nTime)
    local szOrg = Lib:TimeFullDescEx(nTime)
    local nLen = string.len(szOrg)
    local nSubLen = 24 - nLen
    for i = 1, nSubLen do
      szOrg = " " .. szOrg
    end
    return szOrg
  end

  function tbOnlineExp:CheckCanOnline(pPlayer)
    if pPlayer.nLevel < 20 then
      return 2, "Chỉ cấp 20 trở lên mới có thể mở ủy thác online."
    end

    -- Đầy cấp đầy kinh nghiệm
    if Player.tbOffline:CheckIsFullLevel(pPlayer) == 1 then
      return 3, "Bạn đã đạt cấp tối đa và kinh nghiệm tối đa, không cần ủy thác."
    end

    local nMapId = pPlayer.nMapId
    local nMapFlag = 0
    for _, nId in pairs(self.tbAllowOnlineMap) do
      if nMapId == nId then
        nMapFlag = 1
        break
      end
    end
    if 0 == nMapFlag then
      return 1, "Chỉ có thể mở ủy thác online trong thành thị, tân thủ thôn hoặc sân báo danh giải đấu."
    end

    if pPlayer.IsOfflineLive() == 1 then
      return 4, ""
    end
    return 0
  end

  function tbOnlineExp:ClearOnlineExpState(pPlayer)
    self:SetOnlineState(0, pPlayer)
    Dialog:ShowBattleMsg(pPlayer, 0, 0)
    pPlayer.RemoveSkillState(self.ONLINESTATE_ID)
    pPlayer.CallClientScript({ "Player.tbOnlineExp:UpdateState", 2 })
  end
end
