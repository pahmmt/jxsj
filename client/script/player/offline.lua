-- Tên tệp　:offline.lua
-- Người tạo　:FanZai
-- Thời gian tạo:2007-12-22 10:01:14
-- Mô tả tệp:Liên quan đến ủy thác offline

Require("\\script\\player\\player.lua")

local tbOffline = Player.tbOffline or {} -- Hỗ trợ tải lại
Player.tbOffline = tbOffline

tbOffline.LEVEL_MIN = 20 -- Cấp độ thấp hơn mức này không được tham gia ủy thác offline

tbOffline.TIME_MIN = 60 * 5 -- Thời gian nhạy cảm của ủy thác offline (ủy thác dưới thời gian này sẽ không kích hoạt các sự kiện liên quan)

tbOffline.TIME_DAY_USE = 3600 * 18 -- Thời gian ủy thác offline tối đa mỗi ngày

tbOffline.TIME_BAJUWAN_ADD = 3600 * 8 -- Bạch Câu Hoàn tăng thời gian ủy thác

tbOffline.MAX_ADDEXP_ONCE = 10 * 10000 * 10000 -- Một lần tăng tối đa 1 tỷ kinh nghiệm

tbOffline.POINT_ADD_PERHOUR = 30 -- Mỗi giờ nhận được Tinh Lực và Hoạt Lực

tbOffline.DEFAULTBAIJUTYPE = 3

tbOffline.COINLIMIT = 99999999

tbOffline.CHANGE_MULT = 1.5 -- Tăng kinh nghiệm

tbOffline.DEF_COMBINSERVER_GIVETIME = 180 -- Số ngày thưởng gộp server sau khi gộp server
tbOffline.DEF_COZONE_COMPOSE_MINDAY = 7

tbOffline.BAIJU_DEFINE = { -- Thiết lập tham số các loại Bạch Câu Hoàn -- Hiện tại vì client không còn đặt tệp warelist, nên không thể lấy được giá của vật phẩm
  { -- Tạm thời chỉ có thể định giá loại này, sau này nhất định phải sửa, đặc biệt là khi giá thay đổi
    szName = " Bạch Câu Hoàn ", -- Tên
    nExpMultply = 1, -- Bội số nhận kinh nghiệm
    nTaskId = 1, -- Biến ghi lại thời gian còn lại
    nWareId = 1,
    nCoin = tbOffline.COINLIMIT,
    nShowFlag = 0,
  },
  {
    szName = "Đại Bạch Câu Hoàn",
    nExpMultply = 1.3,
    nTaskId = 2,
    nWareId = 2,
    nCoin = tbOffline.COINLIMIT,
    nShowFlag = 0,
  },
  {
    szName = "Cường Hiệu Bạch Câu",
    nExpMultply = 1.6,
    nTaskId = 3,
    nWareId = 3,
    nCoin = tbOffline.COINLIMIT,
    nShowFlag = 0,
  },
  {
    szName = "Đặc Hiệu Bạch Câu",
    nExpMultply = 2.0,
    nTaskId = 4,
    nWareId = 52,
    nCoin = tbOffline.COINLIMIT,
    nShowFlag = 0,
  },
}

tbOffline.tbBaijuInfo = {
  [1] = { szGDPL = { 18, 1, 71, 1 }, nCost = 36 },
  [2] = { szGDPL = { 18, 1, 71, 2 }, nCost = 180 },
  [3] = { szGDPL = { 18, 1, 71, 3 }, nCost = 540 },
  [4] = { szGDPL = { 18, 1, 71, 4 }, nCost = 1480 },
}

tbOffline.MAPID_FOBID = {
  [222] = 1, -- Đại lao Biện Kinh Phủ
  [223] = 1, -- Đại lao Lâm An Phủ
  [399] = 1, -- Thiên Lao
  [1497] = 1, -- Lối vào Đào Nguyên 1
  [1498] = 1, -- Lối vào Đào Nguyên 2
  [1499] = 1, -- Lối vào Đào Nguyên 3
  [1500] = 1, -- Lối vào Đào Nguyên 4
  [1501] = 1, -- Lối vào Đào Nguyên 5
  [1502] = 1, -- Lối vào Đào Nguyên 6
  [1503] = 1, -- Lối vào Đào Nguyên 7
}

-- Bảng thông tin cấp độ
if MODULE_GAMESERVER then
  tbOffline.tbLevelInfo = {
    {
      nLevel = 69,
      nTimeTskId = -1,
    },
    {
      nLevel = 79,
      nTimeTskId = DBTASD_SERVER_SETMAXLEVEL79,
    },
    {
      nLevel = 89,
      nTimeTskId = DBTASD_SERVER_SETMAXLEVEL89,
    },
    {
      nLevel = 99,
      nTimeTskId = DBTASD_SERVER_SETMAXLEVEL99,
    },
    {
      nLevel = 150,
      nTimeTskId = DBTASD_SERVER_SETMAXLEVEL150,
    },
  }
end

tbOffline.TSKGID = 5
tbOffline.TSKID_AUTO_CLOSED = 11 -- Đã cấm ủy thác tự động chưa
tbOffline.TSKID_OFFLINE_STARTTIME = 12 -- Thời gian bắt đầu ủy thác offline (chỉ ghi lại trường hợp ủy thác online)
tbOffline.TSKID_ADD_EXP1 = 13 -- Kinh nghiệm có thể cộng cho người chơi trong lần ủy thác này (chữ số dưới 1 tỷ)
tbOffline.TSKID_ADD_EXP2 = 14 -- Kinh nghiệm có thể cộng cho người chơi trong lần ủy thác này (chữ số trên 1 tỷ)
tbOffline.TSKID_WASTE_TIME = 15 -- Thời gian ủy thác bị lãng phí do người chơi không có Bạch Câu Hoàn (người chơi có thể dùng tiền để bù lại)
tbOffline.TSKID_WASTE_START_LEVEL = 16 -- Cấp độ bắt đầu của thời gian ủy thác bị lãng phí
tbOffline.TSKID_WASTE_START_EXP = 17 -- Kinh nghiệm bắt đầu của thời gian ủy thác bị lãng phí
tbOffline.TSKID_USED_OFFLINE_TIME = 18 -- Thời gian ủy thác offline đã sử dụng trong một ngày (DayNum*3600*24+UsedTimeSec)
tbOffline.TSKID_WASTE_LEVELLIMIT = 19 -- Cấp độ cao nhất của ủy thác offline hiện tại
tbOffline.TSKID_WASTE_OLDMULT_LIVETIME = 20 -- Thời gian offline của người chơi theo tỷ lệ cũ
tbOffline.TSKID_COZONE_GIVEOFFLINETIME_FLAG = 21 -- Thưởng thời gian ủy thác offline khi gộp server
tbOffline.TSKID_SERVERSTART_TIME = 22 -- Ghi lại thời gian mở server trên người chơi, nếu khác 0 và có chênh lệch với thời gian mở server hiện tại thì bù kinh nghiệm gộp server
tbOffline.TSKID_COZONE_GIVEOFFLINE_TIME = 24 -- Ghi lại dấu hiệu do gộp server trước khi cập nhật nhưng cần thay đổi giới hạn, thưởng cho người chơi đã nhận
tbOffline.TSKID_EX_OFFLINE_TIME = 25 -- Thời gian offline bổ sung (đơn vị phút)
tbOffline.TSKID_TOTALUSEBAIJUTIME = 100 -- Tổng thời gian ủy thác offline tích lũy của người chơi (dành cho nhân viên nội bộ kiểm tra)

tbOffline.nNowTimeDayUse = 0 -- Thời gian ủy thác offline có thể tích lũy mỗi ngày
tbOffline.EXGIVEENDTIME = 1260230400 -- Thời gian bắt đầu đền bù do gộp server trước khi cập nhật máy chủ, nhưng lại cần sửa đổi giới hạn thưởng gộp server

-- Hàm so sánh
tbOffline._Cmp = function(nNumA, nNumB)
  return nNumA < nNumB
end

function tbOffline:OnUpdateLevelInfo()
  for key, tbLevel in ipairs(self.tbLevelInfo) do
    local nTskId = tbLevel.nTimeTskId
    local nTime = 0
    if nTskId < 0 then
      nTime = -1
    elseif nTskId > 0 then
      nTime = KGblTask.SCGetDbTaskInt(nTskId)
    end
    local tbLevelExp = {}
    if nTime > 0 or nTime == -1 then
      tbLevelExp = self:CaluLevelExp(1, tbLevel.nLevel)
    end
    tbLevel.nTime = nTime
    tbLevel.tbLevelExp = tbLevelExp
  end
end

function tbOffline:Init()
  local bInited = (self.tbLevelData and 1) or 0

  -- Kinh nghiệm lên cấp, kinh nghiệm cơ bản của người chơi ở các cấp độ
  self.tbLevelData = {}
  local tbFileData = Lib:LoadTabFile("\\setting\\player\\attrib_level.txt")
  for nRow, tbRow in ipairs(tbFileData) do
    local nLevel = tonumber(tbRow.LEVEL)
    local nUpExp = tonumber(tbRow.EXP_UPGRADE)
    local nBaseExp = tonumber(tbRow.BASE_AWARD_EXP)
    local nEffect = Player:GetLevelEffect(nLevel)
    if nLevel then
      self.tbLevelData[nLevel] = {
        nUpExp = nUpExp,
        nBaseExpSec = nBaseExp / 60,
        nEffect = nEffect,
      }
    end
  end

  if bInited == 1 then
    self:_LoadBaijuCoin()
  else
    tbOffline.nDTime = 0
    if not GLOBAL_AGENT then
      PlayerEvent:RegisterGlobal("OnLoginOnly", self.OnLogin, self)
    end
  end
end

-- Nhận tổng giá trị kinh nghiệm
function tbOffline:GetLevelExp(nLevel, nCurExp, nLevelLimit)
  local nExp = 0
  if nLevel <= 0 or nLevelLimit <= 0 then
    return 0
  end

  if nLevel > nLevelLimit then
    return 0
  end

  if MODULE_GAMESERVER then
    for key, tbLevel in ipairs(self.tbLevelInfo) do
      if tbLevel.nTime == 0 then
        break
      end
      if nLevelLimit == tbLevel.nLevel then
        nExp = tbLevel.tbLevelExp[nLevel]
        break
      end
    end
  end
  if MODULE_GAMECLIENT then -- Client tính tổng kinh nghiệm từ cấp hiện tại đến cấp giới hạn, tính mỗi lần
    local nLimit = me.GetTask(self.TSKGID, self.TSKID_WASTE_LEVELLIMIT)
    if nLevelLimit > nLimit then
      return 0
    end
    for nCurLevel = nLevel, nLevelLimit do
      nExp = nExp + self.tbLevelData[nCurLevel].nUpExp
    end
  end
  nExp = nExp - nCurExp
  if nExp < 0 then
    nExp = 0
  end
  return nExp
end

-- Server tính tổng kinh nghiệm từ cấp hiện tại đến cấp giới hạn, server chỉ tính một lần
function tbOffline:CaluLevelExp(nLowLevel, nHighLevel)
  local tbLevelTotalExp = {}
  if nLowLevel <= 0 then
    self:WriteLog("CaluLevelExp", "nLowLevel < the really low level")
    nLowLevel = 1
  end
  if nHighLevel > #self.tbLevelData then
    nHighLevel = #self.tbLevelData
  end
  for i = nHighLevel, nLowLevel, -1 do
    local nExp = 0
    if self.tbLevelData[i] and self.tbLevelData[i].nUpExp then
      nExp = self.tbLevelData[i].nUpExp
    end

    if i == nHighLevel then
      tbLevelTotalExp[i] = nExp
    else
      tbLevelTotalExp[i] = nExp + tbLevelTotalExp[i + 1]
    end
  end
  return tbLevelTotalExp
end

-- Tải giá của Bạch Câu Hoàn
function tbOffline:_LoadBaijuCoin()
  local tbData = Lib:LoadTabFile("\\setting\\ibshop\\warelist.txt")
  assert(tbData)

  local nTime = GetTime()
  local nDay = Lib:GetLocalDay(nTime)
  local nStartTime = KGblTask.SCGetDbTaskInt(DBTASD_SERVER_STARTTIME)
  local nStartDay = Lib:GetLocalDay(nStartTime)

  for _, tbRow in ipairs(tbData) do
    local nWareId = tonumber(tbRow.WareId)
    for key, tbValue in pairs(self.BAIJU_DEFINE) do
      if tbValue.nWareId == nWareId then
        if tbRow.nTimeFrameStartSale then
          tbValue.nTimeFrameStartSale = tonumber(tbRow.nTimeFrameStartSale)
          self:WriteLog(tbValue.szName, "nTimeFrameStartSale", tbValue.nTimeFrameStartSale)
        end

        if tbRow.nTimeFrameEndSale then
          tbValue.nTimeFrameEndSale = tonumber(tbRow.nTimeFrameEndSale)
          self:WriteLog(tbValue.szName, "nTimeFrameEndSale", tbValue.nTimeFrameEndSale)
        end
        if tbValue.nTimeFrameStartSale then
          self:WriteLog("_LoadBaijuCoin", tbValue.szName, "tbValue.nTimeFrameStartSale and tbValue.nTimeFrameEndSale", tbValue.nTimeFrameStartSale, tbValue.nTimeFrameEndSale)
        end
        if tbValue.nTimeFrameStartSale and tbValue.nTimeFrameEndSale then
          local nStartSaleDay = nStartDay + tbValue.nTimeFrameStartSale
          local nEndSaleDay = nStartDay + tbValue.nTimeFrameEndSale
          if nDay >= nStartSaleDay and nDay <= nEndSaleDay then
            tbValue.nCoin = tonumber(tbRow.nOrgPrice)
            tbValue.nShowFlag = 1
          end
        else
          tbValue.nCoin = tonumber(tbRow.nOrgPrice)
          tbValue.nShowFlag = 1
        end

        self:WriteLog(tbValue.szName, tbValue.nCoin)
        break
      end
    end
  end
end

function tbOffline:GetAddExp(pPlayer)
  local nAddExp1 = pPlayer.GetTask(self.TSKGID, self.TSKID_ADD_EXP1)
  local nAddExp2 = pPlayer.GetTask(self.TSKGID, self.TSKID_ADD_EXP2)
  local nAddExp = nAddExp1 + self.MAX_ADDEXP_ONCE * nAddExp2
  return nAddExp, nAddExp1, nAddExp2
end

function tbOffline:SetAddExp(pPlayer, nAddExp)
  local nAddExp1 = math.mod(nAddExp, self.MAX_ADDEXP_ONCE)
  local nAddExp2 = math.floor(nAddExp / self.MAX_ADDEXP_ONCE)
  pPlayer.SetTask(self.TSKGID, self.TSKID_ADD_EXP1, nAddExp1)
  pPlayer.SetTask(self.TSKGID, self.TSKID_ADD_EXP2, nAddExp2)
end

function tbOffline:AddExp(pPlayer, nAddExp1, nAddExp2)
  if nAddExp2 >= 1 then
    self:WriteLog("AddExp", string.format("Give player %s max exp count %d", pPlayer.szName, nAddExp2))
  end
  for i = 1, nAddExp2 do
    pPlayer.AddExp(self.MAX_ADDEXP_ONCE)
  end
  self:WriteLog("AddExp", string.format("Give player %s exp :%d", pPlayer.szName, nAddExp1))
  pPlayer.AddExp(nAddExp1)
  pPlayer.SetTask(self.TSKGID, self.TSKID_ADD_EXP1, 0)
  pPlayer.SetTask(self.TSKGID, self.TSKID_ADD_EXP2, 0)
end

function tbOffline:OnLogin(bExchangeServer)
  -- Không làm gì khi liên server
  if bExchangeServer == 1 then
    me.SyncTaskGroup(self.TSKGID) -- Có thể giao diện client chưa đóng
    return
  end

  self:SyncBaiJuDefine()

  -- Bù kinh nghiệm bị thiếu
  local nAddExp, nAddExp1, nAddExp2 = self:GetAddExp(me)
  if nAddExp > 0 then
    self:AddExp(me, nAddExp1, nAddExp2)
  end

  local bPoped = self:ProcessOfflineTime()

  if bPoped ~= 1 then
    self:ProcessWasteTime()
  end
end

-- Lấy tỷ lệ của Bạch Câu Hoàn vì có thể thay đổi tỷ lệ theo thời gian offline khác nhau của người chơi
function tbOffline:GetBaijuMult(nType, nLastLiveTime)
  local nMult = self.BAIJU_DEFINE[nType].nExpMultply
  if nLastLiveTime >= 1226444400 then -- Khi thời gian offline trước 8 giờ ngày 12 tháng 11 năm 2008 đều được coi là dùng tỷ lệ cũ
    nMult = self.BAIJU_DEFINE[nType].nExpMultply * self.CHANGE_MULT
  end
  return nMult
end

function tbOffline:CaluDayDefUseTime(nLastSaveTime)
  local nDayUseTime = self.TIME_DAY_USE
  if nLastSaveTime < 1226444400 then -- Khi thời gian offline trước 8 giờ ngày 12 tháng 11 năm 2008 đều được coi là dùng tỷ lệ cũ
    nDayUseTime = 3600 * 16
  end
  return nDayUseTime
end

-- Đồng bộ cấu hình Bạch Câu đến client
function tbOffline:SyncBaiJuDefine()
  self.nNowTimeDayUse = self:CaluDayDefUseTime(me.nLastSaveTime)
  local tbBaiDefine = {}
  local nTime = GetTime()
  local nDay = Lib:GetLocalDay(nTime)
  local nStartTime = KGblTask.SCGetDbTaskInt(DBTASD_SERVER_STARTTIME)
  local nStartDay = Lib:GetLocalDay(nStartTime)
  for key, tbDefine in ipairs(self.BAIJU_DEFINE) do
    -- Cho thấy có giới hạn thời gian
    local tbDe = {}
    tbDe.szName = tbDefine.szName -- Tên
    tbDe.nExpMultply = tbDefine.nExpMultply -- Bội số nhận kinh nghiệm
    tbDe.nTaskId = tbDefine.nTaskId -- Biến ghi lại thời gian còn lại
    tbDe.nWareId = tbDefine.nWareId
    tbDe.nCoin = tbDefine.nCoin
    tbDe.nShowFlag = 0
    if tbDefine.nTimeFrameStartSale and tbDefine.nTimeFrameStartSale > 0 then
      local nStartSaleDay = nStartDay + tbDefine.nTimeFrameStartSale
      local nEndSaleDay = nStartDay + tbDefine.nTimeFrameEndSale
      if nDay >= nStartSaleDay and nDay <= nEndSaleDay then
        tbDe.nShowFlag = 1
      end
    else
      tbDe.nShowFlag = 1
    end
    tbBaiDefine[#tbBaiDefine + 1] = tbDe
  end
  me.CallClientScript({ "Player.tbOffline:GetBaiJuDefine", tbBaiDefine, self.nNowTimeDayUse })
end

-- Ghi lại tổng thời gian sử dụng Bạch Câu của người chơi
function tbOffline:_AddTotalTime(pPlayer, nTime)
  if nTime <= 0 then
    return
  end
  local nTotalTime = pPlayer.GetTask(self.TSKGID, self.TSKID_TOTALUSEBAIJUTIME) + nTime
  pPlayer.SetTask(self.TSKGID, self.TSKID_TOTALUSEBAIJUTIME, nTotalTime)
end

function tbOffline:OnStallStateChange(nStallState)
  -- Sau khi bày bán xong, đợi một lát rồi offline
  Player:RegisterTimer(20 * Env.GAME_FPS, self.OnOfflineTimeout, self)
end

function tbOffline:ClearWasterValue(pPlayer)
  if pPlayer.GetTask(self.TSKGID, self.TSKID_WASTE_TIME) <= 0 then
    return
  end

  pPlayer.SetTask(self.TSKGID, self.TSKID_WASTE_TIME, 0)
  pPlayer.SetTask(self.TSKGID, self.TSKID_WASTE_START_LEVEL, 0)
  pPlayer.SetTask(self.TSKGID, self.TSKID_WASTE_START_EXP, 0)
  self:WriteLog("ClearWasterValue", "Player " .. pPlayer.szName .. " get on the level limit, so clear all waster time!")
end

-- *******Nhận kinh nghiệm thưởng ưu đãi gộp server, hết hạn sau 10 ngày gộp server*******
function tbOffline:CoZoneAddOfflineTime()
  --print("Ưu đãi gộp server, tăng thời gian ủy thác offline")
  local nRestTime = 0
  local nNowTime = GetTime()
  local nGbCoZoneTime = KGblTask.SCGetDbTaskInt(DBTASK_COZONE_TIME)
  local nZoneStartTime = KGblTask.SCGetDbTaskInt(DBTASD_SERVER_STARTTIME)
  local nCurZoneStartTime = me.GetTask(self.TSKGID, self.TSKID_SERVERSTART_TIME)
  local bAddExp = 0
  if nCurZoneStartTime ~= nZoneStartTime then
    if nCurZoneStartTime > 0 and nCurZoneStartTime < nZoneStartTime then
      --bAddExp = 1; --Tạm thời không dùng phán đoán này, sẽ mở sau khi bỏ phán đoán tạm thời
    end
    me.SetTask(self.TSKGID, self.TSKID_SERVERSTART_TIME, nZoneStartTime)
  end
  if nNowTime > nGbCoZoneTime and nNowTime < nGbCoZoneTime + 10 * 24 * 60 * 60 and me.nLevel >= 50 then
    local nSelfCoZoneTime = me.GetTask(self.TSKGID, self.TSKID_COZONE_GIVEOFFLINETIME_FLAG)
    --	print(nSelfCoZoneTime);
    --	print(nGbCoZoneTime);
    if nSelfCoZoneTime < nGbCoZoneTime then
      -- Nếu là người chơi server phụ
      if me.IsSubPlayer() == 1 then -- Kiểm tra xem tên mình có trong danh sách ưu đãi không
        -- Cộng thêm chênh lệch thời gian mở server của hai server gộp lại
        nRestTime = math.max(KGblTask.SCGetDbTaskInt(DBTASK_SERVER_STARTTIME_DISTANCE), self.DEF_COZONE_COMPOSE_MINDAY * 24 * 3600)
        nRestTime = math.min(self.DEF_COMBINSERVER_GIVETIME * 24 * 3600 * 0.75, nRestTime * 0.75)
      else
        -- Người chơi server chính có thể được đền bù 7 ngày thưởng
        nRestTime = self.DEF_COZONE_COMPOSE_MINDAY * 0.75 * 24 * 3600
      end
      me.SetTask(self.TSKGID, self.TSKID_COZONE_GIVEOFFLINETIME_FLAG, GetTime())
      me.SetTask(self.TSKGID, self.TSKID_COZONE_GIVEOFFLINE_TIME, self.EXGIVEENDTIME)
      self:WriteLog("CoZoneAddOfflineTime Main", me.szName, nRestTime)
      --- Cần sửa đổi dấu hiệu thưởng gộp server
    end
  end
  return nRestTime
end

--Thời gian offline bổ sung
function tbOffline:CalcExOffLineTime()
  local nTimeSec = me.GetTask(self.TSKGID, self.TSKID_EX_OFFLINE_TIME)
  me.SetTask(self.TSKGID, self.TSKID_EX_OFFLINE_TIME, 0)
  return nTimeSec
end

--Tăng thời gian offline bổ sung
function tbOffline:AddExOffLineTime(nMin)
  local nTimeSec = me.GetTask(self.TSKGID, self.TSKID_EX_OFFLINE_TIME)
  me.SetTask(self.TSKGID, self.TSKID_EX_OFFLINE_TIME, nTimeSec + nMin * 60)
  return 1
end

-- Xử lý thời gian offline, trả về: có thông báo báo cáo ủy thác hiện ra không
function tbOffline:ProcessOfflineTime()
  if self.MAPID_FOBID[me.nMapId] == 1 then -- Bản đồ cấm
    return 0
  end

  local nNowTime = self:GetTime()

  if me.GetTask(self.TSKGID, self.TSKID_AUTO_CLOSED) == 1 then
    return 0
  end

  if me.nLevel < self.LEVEL_MIN then
    return 0
  end

  -- Chú ý: Sau năm 2038 cần chú ý vấn đề dấu âm của nLastTime
  local nLastTime = me.GetTask(self.TSKGID, self.TSKID_OFFLINE_STARTTIME)
  if nLastTime <= 0 then -- Trước lần offline trước không có ủy thác online, tính theo thời gian offline thực tế
    nLastTime = me.nLastSaveTime
  else
    me.SetTask(self.TSKGID, self.TSKID_OFFLINE_STARTTIME, 0)
  end
  self:WriteLog("ProcessOfflineTime", string.format("%s Last Logout time and now login time: %d %d", me.szName, nLastTime, nNowTime))
  if nLastTime <= 0 then -- Người chơi này lần đầu đăng nhập game
    return 0
  end

  local nOffTime, nOffLiveTime, nTodayUsedtime, nNowDay = self:CalcOfflineTime(nNowTime, nLastTime, self.nNowTimeDayUse)

  self:WriteLog("ProcessOfflineTime", string.format("%s nOffLiveTime, nTodayUsedtime = %d, %d", me.szName, nOffLiveTime, nTodayUsedtime))

  -- Tính ra thời gian hiệu lực cuối cùng của ủy thác offline

  -- Tính toán hiệu quả của các loại Bạch Câu Hoàn
  local szMsg = ""
  local nRestTime = nOffLiveTime
  local nTotalAddExp = 0
  local nTotalAddPoint = 0
  local nCurLevel = me.nLevel
  local nCurExp = me.GetExp()
  local nLogAddTime = 0
  local nLevelLimit = self:GetLevelLimit(nLastTime)

  local nExOffTime = self:CalcExOffLineTime() + self:CoZoneAddOfflineTime() -- ******Thời gian bổ sung và ưu đãi gộp server*******

  nRestTime = nRestTime + nExOffTime

  self:WriteLog("ProcessOfflineTime", me.szName, "nCurLevel, nCurExp, nLevelLimit ", nCurLevel, nCurExp, nLevelLimit)
  local nLevelTotalExp = self:GetLevelExp(nCurLevel, nCurExp, nLevelLimit)

  -- Ở đây sẽ có vấn đề là có thể thời gian offline không dài, nhưng lại có thời gian chưa bù lần trước, nên dẫn đến trường hợp có Bạch Câu Hoàn vẫn hiện ra mua Bạch Câu Hoàn
  if nRestTime <= 0 then
    -- Đối với cấp tối đa và kinh nghiệm tối đa cần xóa thời gian còn lại
    if nLevelTotalExp <= 0 then
      self:ClearWasterValue(me)
    end
    return 0
  end

  -- Lưu giới hạn ngày hôm nay
  me.SetTask(self.TSKGID, self.TSKID_USED_OFFLINE_TIME, nNowDay * 3600 * 24 + nTodayUsedtime)

  -- Nếu người chơi đã có thời gian sử dụng Bạch Câu Hoàn, tính kinh nghiệm sau khi sử dụng
  for nType = #self.BAIJU_DEFINE, 1, -1 do
    local tbBaiJu = self.BAIJU_DEFINE[nType]
    local nBaiJuTime = me.GetTask(self.TSKGID, tbBaiJu.nTaskId)
    local nUseBaiJuTime = math.min(nBaiJuTime, nRestTime)
    local nMultply = self:GetBaijuMult(nType, nLastTime)
    local nAddExp, nAddPoint, nFinalLevel, nFinalExp, nUseRestTime = self:CalcAddExp(nUseBaiJuTime, nCurLevel, nCurExp, nType, nLevelTotalExp, nMultply)
    nTotalAddExp = nTotalAddExp + nAddExp
    nLevelTotalExp = nLevelTotalExp - nAddExp
    nTotalAddPoint = nTotalAddPoint + nAddPoint
    nRestTime = nRestTime - (nUseBaiJuTime - nUseRestTime)
    nBaiJuTime = nBaiJuTime - (nUseBaiJuTime - nUseRestTime)
    nLogAddTime = nLogAddTime + nUseBaiJuTime - nUseRestTime

    self:_AddTotalTime(me, nUseBaiJuTime - nUseRestTime)
    self:WriteLog("ProcessOfflineTime", string.format("Player %s use BaiJu %s , Original BaiJu Time is %d; Used Baiju Time is %d; Rest Baiju Time is %d  !", me.szName, self.BAIJU_DEFINE[nType].szName, me.GetTask(self.TSKGID, tbBaiJu.nTaskId), nUseBaiJuTime - nUseRestTime, nBaiJuTime))
    me.SetTask(self.TSKGID, tbBaiJu.nTaskId, nBaiJuTime)
    szMsg = string.format("<bclr=Blue>%s<bclr> %s %s<color=Yellow>%9d<color>\n", tbBaiJu.szName, self:GetDTimeShortDesc(nUseBaiJuTime - nUseRestTime), self:GetDTimeShortDesc(nBaiJuTime), nAddExp) .. szMsg
    nCurLevel = nFinalLevel
    nCurExp = nFinalExp
  end
  -- Lưu kinh nghiệm chờ cộng
  self:SetAddExp(me, nTotalAddExp)

  -- Đối với cấp tối đa và kinh nghiệm tối đa cần xóa
  if nLevelTotalExp <= 0 then
    self:ClearWasterValue(me)
  elseif nRestTime > 0 then -- Lưu thời gian còn lại
    local bNewRestTime = 1 -- Có cần ghi lại thời gian còn lại lần này không
    local nDefaultUseType = self.DEFAULTBAIJUTYPE -- Mặc định người chơi sẽ sử dụng Bạch Câu Hoàn cấp cao nhất
    local nTotalExp = self:GetLevelExp(nCurLevel, nCurExp, nLevelLimit)
    local nMultply = self:GetBaijuMult(nDefaultUseType, nLastTime)
    local nNowAddExp, nAddPoint, nFinalLevel, nFinalExp, nUseRestTime = self:CalcAddExp(nRestTime, nCurLevel, nCurExp, nDefaultUseType, nTotalExp, nMultply)

    local nLastWasteTime = me.GetTask(self.TSKGID, self.TSKID_WASTE_TIME)
    if nLastWasteTime > nRestTime then -- Chỉ khi thời gian lãng phí lần trước nhiều hơn lần này, mới có khả năng vượt quá kinh nghiệm nhận được lần này
      local nWasteLevelLimit = me.GetTask(self.TSKGID, self.TSKID_WASTE_LEVELLIMIT)
      if nWasteLevelLimit <= 0 then
        nWasteLevelLimit = 69
      end
      local nWasterTotalExp = self:GetLevelExp(nCurLevel, nCurExp, nWasteLevelLimit)
      local nLastWastLevel = me.GetTask(self.TSKGID, self.TSKID_WASTE_START_LEVEL)
      local nLastWastExp = me.GetTask(self.TSKGID, self.TSKID_WASTE_START_EXP)
      local nLastWasterLiveTime = me.GetTask(self.TSKGID, self.TSKID_WASTE_OLDMULT_LIVETIME)
      local nMultply = self:GetBaijuMult(nDefaultUseType, nLastWasterLiveTime)
      local nLastWastAddExp = self:CalcAddExp(nLastWasteTime, nLastWastLevel, nLastWastExp, nDefaultUseType, nWasterTotalExp, nMultply)
      if nLastWastAddExp >= nNowAddExp then -- Thời gian bỏ lỡ trước đây có giá trị hơn hiện tại
        bNewRestTime = 0
        nRestTime = nLastWasteTime
      end
    end
    if bNewRestTime == 1 then
      me.SetTask(self.TSKGID, self.TSKID_WASTE_TIME, nRestTime)
      me.SetTask(self.TSKGID, self.TSKID_WASTE_START_LEVEL, nCurLevel)
      me.SetTask(self.TSKGID, self.TSKID_WASTE_START_EXP, nCurExp)
      me.SetTask(self.TSKGID, self.TSKID_WASTE_LEVELLIMIT, nLevelLimit)
      me.SetTask(self.TSKGID, self.TSKID_WASTE_OLDMULT_LIVETIME, nLastTime)
    end
  end

  self:WriteLog("ProcessOfflineTime", string.format("%s The really rest time is %d, nTotalAddExp " .. nTotalAddExp .. ", nTotalAddPoint %d !", me.szName, nLogAddTime, nTotalAddPoint))
  if nTotalAddExp <= 0 and nTotalAddPoint <= 0 then
    return 0
  end

  KStatLog.ModifyAdd("roleinfo", me.szName, "Tổng thời gian ủy thác", nOffLiveTime)

  szMsg = string.format("           [Báo cáo Ủy thác Offline]\n" .. "Ngày offline: %s\n" .. "Ngày online: %s\n" .. "Thời gian offline: %s\n" .. "Thời gian bổ sung: %s\n" .. "Ủy thác hiệu quả: %s\n" .. "Kinh nghiệm nhận được: <color=Yellow>%.f<color> điểm\n" .. "Cấp độ ban đầu: %s\n" .. "Cấp độ đạt được: %s\n"  --		"Nhận Tinh Lực: <color=Yellow>%d<color> điểm\n" ..
  --		"Nhận Hoạt Lực: <color=Yellow>%d<color> điểm\n" ..
 .. "Loại ủy thác Thời gian sử dụng Thời gian còn lại Kinh nghiệm nhận được\n", self:GetTimeDesc(nLastTime), self:GetTimeDesc(nNowTime), self:GetDTimeDesc(nOffTime), self:GetDTimeDesc(nExOffTime), self:GetDTimeDesc(nOffLiveTime), nTotalAddExp, self:GetLevelDesc(me.nLevel, me.GetExp()), self:GetLevelDesc(nCurLevel, nCurExp)) .. szMsg
  --		nTotalAddPoint, nTotalAddPoint

  if nLevelLimit < 150 and nLevelLimit > 0 then
    szMsg = szMsg .. string.format("Bạn đã ủy thác offline trước khi server mở giới hạn cấp <color=yellow>%d<color>, vì vậy kinh nghiệm offline lần này chỉ có thể giúp bạn lên tối đa cấp <color=yellow>%d<color>!\n", nLevelLimit, nLevelLimit)
  end
  Dialog:Say(szMsg, { string.format("Nhận %.f kinh nghiệm", nTotalAddExp), self.OnGetExp, self, nTotalAddPoint })

  return 1
end

-- Tính toán thời gian ủy thác
-- Giá trị trả về: nOffTime thời gian offline, nOffLiveTime thời gian ủy thác hiệu quả, nTodayUsedtime thời gian sử dụng hôm nay, nNowDay số ngày
function tbOffline:CalcOfflineTime(nNowTime, nLastTime, nNowTimeDayUse)
  assert(nNowTimeDayUse and nNowTimeDayUse > 0)
  local nOffTime = nNowTime - nLastTime -- Thời gian offline
  if nOffTime < self.TIME_MIN then
    -- Thời gian offline quá ngắn, có thể là liên server hoặc mất kết nối, bỏ qua
    return 0, 0, 0, 0
  end

  -- Tính toán thời gian ủy thác hiệu quả là bao lâu
  local nOffLiveTime = 0
  local nTodayUsedtime = 0
  local nNowDay = Lib:GetLocalDay(nNowTime)
  local nPassDay = nNowDay - Lib:GetLocalDay(nLastTime) -- Số ngày đã trôi qua
  if nPassDay <= 0 then -- Không qua ngày
    nTodayUsedtime = self:GetUsedOfflineTime(nNowTime)
    if nTodayUsedtime >= nNowTimeDayUse then -- Hôm nay đã không còn thời gian ủy thác khả dụng
      return 0, 0, nTodayUsedtime, nNowDay
    end
    nOffLiveTime = math.min(nOffTime, nNowTimeDayUse - nTodayUsedtime)
    nTodayUsedtime = nTodayUsedtime + nOffLiveTime
  else -- Đã qua ngày
    local nLastUsedtime = self:GetUsedOfflineTime(nLastTime)
    local nLastDaySec = Lib:GetLocalDayTime(nLastTime)
    local nNowDaySec = Lib:GetLocalDayTime(nNowTime)
    local nLastOffLiveTime = math.min(nNowTimeDayUse - nLastUsedtime, 3600 * 24 - nLastDaySec)
    nTodayUsedtime = math.min(self.nNowTimeDayUse, nNowDaySec)
    nOffLiveTime = nLastOffLiveTime + nTodayUsedtime + nNowTimeDayUse * (nPassDay - 1)
  end
  return nOffTime, nOffLiveTime, nTodayUsedtime, nNowDay
end

function tbOffline:GetTodayRestOfflineTime()
  if me.nLevel < self.LEVEL_MIN then
    return 0
  end

  local nNowTime = self:GetTime()
  if not self.tbLevelData then
    self:WriteLog("GetTodayRestOfflineTime", "self.tbLevelData is nil")
    return 0
  end
  local nLimitLevel = #self.tbLevelData

  if nLimitLevel <= 0 then
    self:WriteLog("GetTodayRestOfflineTime", "self.tbLevelData is no date")
    return 0
  end

  -- TODO:Có một nguy hiểm là có thể không điền giới hạn trên
  if nLimitLevel > 0 and me.nLevel > nLimitLevel then
    return 0
  end

  if nLimitLevel > 0 and me.nLevel == nLimitLevel and me.GetExp() + 1 >= self.tbLevelData[me.nLevel].nUpExp then -- Cho thấy cấp độ tiếp theo là cấp độ giới hạn
    return 0
  end

  local nTodayRestTime = self.nNowTimeDayUse - self:GetUsedOfflineTime(nNowTime)
  if nTodayRestTime < 0 then
    nTodayRestTime = 0
  end

  return nTodayRestTime
end

-- Nhắc nhở người chơi bổ sung thời gian ủy thác bị lãng phí
function tbOffline:ProcessWasteTime()
  local nWasteTime = me.GetTask(self.TSKGID, self.TSKID_WASTE_TIME)
  local nWasteLevelLimit = me.GetTask(self.TSKGID, self.TSKID_WASTE_LEVELLIMIT)
  local nLastWastLevel = me.GetTask(self.TSKGID, self.TSKID_WASTE_START_LEVEL)
  local nLastWastExp = me.GetTask(self.TSKGID, self.TSKID_WASTE_START_EXP)
  local nCurLevel = me.nLevel
  local nCurExp = me.GetExp()
  local nLevelTotalExp = self:GetLevelExp(nCurLevel, nCurExp, nWasteLevelLimit)
  local nLastWasterLiveTime = me.GetTask(self.TSKGID, self.TSKID_WASTE_OLDMULT_LIVETIME)
  local nMultply = self:GetBaijuMult(self.DEFAULTBAIJUTYPE, nLastWasterLiveTime)
  local nNowAddExp = self:CalcAddExp(nWasteTime, nLastWastLevel, nLastWastExp, self.DEFAULTBAIJUTYPE, nLevelTotalExp, nMultply)

  self:WriteLog("ProcessWasteTime", string.format("Player %s have nWasteTime %d, nNowAddExp " .. nNowAddExp .. " !", me.szName, nWasteTime))
  if nWasteTime > 0 and nNowAddExp > 0 then
    me.SyncTaskGroup(self.TSKGID) -- Cần đồng bộ dữ liệu trước khi mở giao diện
    me.CallClientScript({ "UiManager:OpenWindow", "UI_TRUSTEE" })
  end
end

function tbOffline:GetPillInfo()
  local tbPillInfo = {}
  local tbWasterInfo = self:GetWasteInfo()
  for nType, tbBaiJu in ipairs(self.BAIJU_DEFINE) do
    local nNeedCount = math.ceil(tbWasterInfo.nWasteTime / self.TIME_BAJUWAN_ADD)
    tbPillInfo[nType] = {
      tbBaiJu.szName,
      tbBaiJu.nCoin,
      tbBaiJu.nExpMultply,
      nNeedCount,
      tbBaiJu.nShowFlag,
    }
  end

  return tbPillInfo
end

function tbOffline:GetWasteInfo(nBaiJuType)
  if not nBaiJuType then -- Tham số ở đây có thể không điền, không điền có nghĩa là loại Bạch Câu Hoàn mặc định
    nBaiJuType = 1
  end
  local nCurLevel = me.nLevel
  local nCurExp = me.GetExp()
  local nStartLevel = me.GetTask(self.TSKGID, self.TSKID_WASTE_START_LEVEL)
  local nStartExp = me.GetTask(self.TSKGID, self.TSKID_WASTE_START_EXP)
  local nLevelLimit = me.GetTask(self.TSKGID, self.TSKID_WASTE_LEVELLIMIT)
  local nWasteTime = me.GetTask(self.TSKGID, self.TSKID_WASTE_TIME)
  local nLevelTotalExp = self:GetLevelExp(nCurLevel, nCurExp, nLevelLimit)
  local nLastWasterLiveTime = me.GetTask(self.TSKGID, self.TSKID_WASTE_OLDMULT_LIVETIME)
  local nMultply = self:GetBaijuMult(nBaiJuType, nLastWasterLiveTime)
  local nAddExp, nAddPoint, nToLevel, nToExp, nRestTime = self:CalcAddExp(nWasteTime, nStartLevel, nStartExp, nBaiJuType, nLevelTotalExp, nMultply)
  local nEndLevel, nEndExp = self:GetFinalLevel(nCurLevel, nCurExp, nAddExp)

  local tbWasteInfo = {
    nWasteTime = nWasteTime - nRestTime,
    szStartLevel = self:GetLevelShortDesc(nCurLevel, nCurExp),
    nToLevel = nEndLevel,
    nToExp = nEndExp,
    nAddExp = nAddExp,
  }

  return tbWasteInfo
end

function tbOffline:GetBuyInfo(nType, nCount)
  local tbBaiJu = self.BAIJU_DEFINE[nType]
  assert(tbBaiJu.nCoin and tbBaiJu.nCoin > 0)

  local nAddTime = self.TIME_BAJUWAN_ADD * nCount
  local nUseBaiJuTime = me.GetTask(self.TSKGID, self.TSKID_WASTE_TIME)
  local nLevelLimit = me.GetTask(self.TSKGID, self.TSKID_WASTE_LEVELLIMIT)
  local nStartLevel = me.GetTask(self.TSKGID, self.TSKID_WASTE_START_LEVEL)
  local nStartExp = me.GetTask(self.TSKGID, self.TSKID_WASTE_START_EXP)

  if nUseBaiJuTime > nAddTime then
    nUseBaiJuTime = nAddTime
  end

  -- Đây là tính kinh nghiệm
  local nCurLevel = me.nLevel
  local nCurExp = me.GetExp()
  local nLevelTotalExp = self:GetLevelExp(nCurLevel, nCurExp, nLevelLimit)
  local nLastWasterLiveTime = me.GetTask(self.TSKGID, self.TSKID_WASTE_OLDMULT_LIVETIME)
  local nMultply = self:GetBaijuMult(nType, nLastWasterLiveTime)
  local nAddExp, nAddPoint, nToLevel, nToExp, nUseRestTime = self:CalcAddExp(nUseBaiJuTime, nStartLevel, nStartExp, nType, nLevelTotalExp, nMultply)
  local nEndLevel, nEndExp = self:GetFinalLevel(nCurLevel, nCurExp, nAddExp)
  local tbCount = self:CalcuCount(nCount, tbBaiJu)

  local tbBuyInfo = {
    nBuyType = nType,
    szBuyName = tbBaiJu.szName,
    nBuyCount = nCount,
    tbCount = tbCount,
    nCoinCost = tbBaiJu.nCoin * tbCount.nCoinCount, -- Số lượng Đồng đã tiêu
    nBindCoinCost = tbBaiJu.nCoin * tbCount.nBindCoinCount, -- Số lượng Đồng khóa đã tiêu
    nAddExp = nAddExp,
    nAddPoint = nAddPoint,
    szCurLevel = self:GetLevelShortDesc(nCurLevel, nCurExp),
    szToLevel = self:GetLevelShortDesc(nEndLevel, nEndExp),
    nRestTime = nAddTime - (nUseBaiJuTime - nUseRestTime),
    nLevelLimit = nLevelLimit,
  }

  if tbBuyInfo.nRestTime < 0 then
    tbBuyInfo.nRestTime = 0
  end

  return tbBuyInfo
end

function tbOffline:CalcuCount(nCount, tbBaiJu)
  local nBindCoin = me.nBindCoin
  local nCoin = me.nCoin
  local tbCount = {}
  assert(tbBaiJu.nCoin and tbBaiJu.nCoin > 0)
  local nBindCoinCount = math.floor(nBindCoin / tbBaiJu.nCoin) -- Số lượng Bạch Câu có thể mua bằng Đồng khóa
  local nTempCoinCount = math.floor(nCoin / tbBaiJu.nCoin)
  local nCoinCount = 0
  if nCount - nBindCoinCount > 0 then
    nCoinCount = nCount - nBindCoinCount
  else
    nBindCoinCount = nCount
  end
  if IVER_g_nSdoVersion == 0 then --zjq mod 09.3.2 Chế độ Shanda không thể biết số lượng Đồng, mặc định mua tối đa
    if nTempCoinCount >= 0 and nCoinCount > nTempCoinCount then
      nCoinCount = nTempCoinCount
    end
  end
  tbCount.nBindCoinCount = nBindCoinCount
  tbCount.nCoinCount = nCoinCount
  return tbCount
end

-- Lãng phí
function tbOffline:OnWaste()
  local nWasteTime = me.GetTask(self.TSKGID, self.TSKID_WASTE_TIME)
  Dialog:Say("Bạn có chắc chắn muốn lãng phí thời gian ủy thác này không?" .. self:GetDTimeDesc(nWasteTime), { "Đúng vậy", self.OnWaste_Sure, self }, { "Ta bấm nhầm", self.OnWaste_Cancle, self })
end
function tbOffline:OnWaste_Sure()
  me.SetTask(self.TSKGID, self.TSKID_WASTE_TIME, 0)
  me.SetTask(self.TSKGID, self.TSKID_WASTE_START_LEVEL, 0)
  me.SetTask(self.TSKGID, self.TSKID_WASTE_START_EXP, 0)
  me.Msg("Thời gian ủy thác bị bỏ lỡ đã được xóa!")
end
function tbOffline:OnWaste_Cancle()
  self:ProcessWasteTime()
end

-- Tặng kinh nghiệm
function tbOffline:OnGetExp(nTotalAddPoint)
  local nAddExp, nAddExp1, nAddExp2 = self:GetAddExp(me)
  if nAddExp > 0 then
    self:AddExp(me, nAddExp1, nAddExp2)
  end
  --	me.ChangeCurMakePoint(nTotalAddPoint);
  --	me.ChangeCurGatherPoint(nTotalAddPoint);
  self:ProcessWasteTime()
end

-- Bù thời gian ủy thác
function tbOffline:OnBuy(nType, nCount)
  if (EventManager.IVER_bOpenAccountLockNotEvent == 1) and (me.IsAccountLock() ~= 0) then
    me.Msg("Tài khoản của bạn đang ở trạng thái khóa, không thể thực hiện thao tác này!")
    Account:OpenLockWindow(me)
    return 0
  end
  local tbBaiJu = self.BAIJU_DEFINE[nType]
  local tbCount = self:CalcuCount(nCount, tbBaiJu)
  assert(tbBaiJu.nCoin and tbBaiJu.nCoin > 0)
  local nNeedBindCoin = tbBaiJu.nCoin * tbCount.nBindCoinCount
  local nNeedCoin = tbBaiJu.nCoin * tbCount.nCoinCount

  local nHaveBuy = 0

  if nNeedBindCoin > 0 then
    self:CastBindCoin(nNeedBindCoin, self.OnCastCoin, self, me, nType, tbCount.nBindCoinCount) -- Đồng khóa
    nHaveBuy = 1
  end
  self:CastIBCoin(nNeedCoin, me, nType, tbCount.nCoinCount, nHaveBuy)
end

-- Tiêu hao Đồng
function tbOffline:CastIBCoin(nCoin, pPlayer, nType, nCount, nHaveBuy)
  if not nCount or nCount <= 0 then
    return
  end

  if self.BAIJU_DEFINE[nType].nCoin == self.COINLIMIT then
    self:WriteLog("CastIBCoin", string.format("Player %s buy %s is wrong price!", pPlayer.szName, self.BAIJU_DEFINE[nType].szName))
    return
  end
  --zjq mod 09.2.27 Ở chế độ Shanda, không kiểm tra số lượng Đồng, mua trực tiếp
  if IVER_g_nSdoVersion == 0 then
    if me.nCoin < nCoin or me.nCoin == 0 then
      if nHaveBuy == 0 then
        pPlayer.Msg("Đồng không đủ, vui lòng mang đủ Đồng đăng nhập lại game để dùng Bạch Câu Hoàn bổ sung hoặc bổ sung qua Kỳ Trân Các. Khoảng thời gian ủy thác này sẽ được giữ lại cho bạn.")
      end
      return
    end
  end

  local nWare = self.BAIJU_DEFINE[nType].nWareId
  self:WriteLog("CastIBCoin", string.format("%s đã dùng Coin mua %d cái %s", pPlayer.szName, nCount, self.BAIJU_DEFINE[nType].szName))
  pPlayer.ApplyAutoBuyAndUse(nWare, nCount)
  pPlayer.CallClientScript({ "Ui:ServerCall", "UI_HELPSPRITE", "OnUpdatePage_Page1" })
end

function tbOffline:CastBindCoin(nCoin, ...)
  assert(me.nBindCoin >= nCoin and nCoin > 0)
  --TODO  Đồng khóa
  me.AddBindCoin(-nCoin, Player.emKBINDCOIN_COST_OFFLINE)
  Lib:CallBack(arg) -- Gọi lại sau khi khấu trừ Đồng khóa thành công
  local szLogMsg = string.format("Mua Bạch Câu Hoàn ủy thác offline đã tiêu tốn " .. nCoin .. " " .. IVER_g_szCoinName .. " khóa")
  me.PlayerLog(Log.emKPLAYERLOG_TYPE_BINDCOIN, szLogMsg)
  szLogMsg = string.format("Mua ủy thác offline " .. arg[5] .. " cái " .. self.BAIJU_DEFINE[arg[4]].szName)
  me.PlayerLog(Log.emKPLAYERLOG_TYPE_BINDCOIN, szLogMsg)
  local tbGdpl = self.tbBaijuInfo[arg[4]].szGDPL
  Dbg:WriteLogEx(Dbg.LOG_INFO, "CostBindCoinOnLogin", me.szName, string.format("%s,%s,%s,%s,%s,%s", me.szAccount, tbGdpl[1], tbGdpl[2], tbGdpl[3], tbGdpl[4], arg[5]))
end

function tbOffline:OnCastCoin(pPlayer, nType, nCount, bNoOpenWnd)
  self:WriteLog("OnCastCoin", string.format("%s đã tiêu hao %d cái %s", pPlayer.szName, nCount, self.BAIJU_DEFINE[nType].szName))

  local nWasteTime = pPlayer.GetTask(self.TSKGID, self.TSKID_WASTE_TIME)
  local nStartLevel = pPlayer.GetTask(self.TSKGID, self.TSKID_WASTE_START_LEVEL)
  local nStartExp = pPlayer.GetTask(self.TSKGID, self.TSKID_WASTE_START_EXP)
  local nLevelLimit = pPlayer.GetTask(self.TSKGID, self.TSKID_WASTE_LEVELLIMIT)
  local nLastWasterLiveTime = me.GetTask(self.TSKGID, self.TSKID_WASTE_OLDMULT_LIVETIME)
  local nMultply = self:GetBaijuMult(nType, nLastWasterLiveTime)
  local tbBaiJu = self.BAIJU_DEFINE[nType]
  local nRestTime = pPlayer.GetTask(self.TSKGID, tbBaiJu.nTaskId) + self.TIME_BAJUWAN_ADD * nCount

  -- Tính toán thời gian Bạch Câu sẽ sử dụng bây giờ
  local nUseBaiJuTime = nWasteTime
  if nUseBaiJuTime > nRestTime then
    nUseBaiJuTime = nRestTime
  end

  -- Lưu thời gian ủy thác còn lại
  nRestTime = nRestTime - nUseBaiJuTime
  pPlayer.SetTask(self.TSKGID, tbBaiJu.nTaskId, nRestTime)

  -- Bù thời gian lãng phí
  if nUseBaiJuTime > 0 then
    -- Ghi LOG
    KStatLog.ModifyAdd("roleinfo", me.szName, "Tổng thời gian ủy thác", nUseBaiJuTime)

    -- Thêm kinh nghiệm
    local nLevelTotalExp = self:GetLevelExp(me.nLevel, me.GetExp(), nLevelLimit)
    local nAddExp, nAddPoint, nToLevel, nToExp, nUseRestTime = self:CalcAddExp(nUseBaiJuTime, nStartLevel, nStartExp, nType, nLevelTotalExp, nMultply)
    while nAddExp > self.MAX_ADDEXP_ONCE do
      pPlayer.AddExp(self.MAX_ADDEXP_ONCE)
      nAddExp = nAddExp - self.MAX_ADDEXP_ONCE
    end
    pPlayer.AddExp(nAddExp)

    self:_AddTotalTime(me, nUseBaiJuTime - nUseRestTime)

    -- Thêm tinh lực hoạt lực
    --		me.ChangeCurMakePoint(nAddPoint);
    --		me.ChangeCurGatherPoint(nAddPoint);
    self:WriteLog("OnCastCoin", string.format("Give %s the exp " .. nAddExp .. " and point %d.", pPlayer.szName, nAddPoint))

    -- Lưu thời gian lãng phí còn lại
    nWasteTime = nWasteTime - (nUseBaiJuTime - nUseRestTime)
    if nUseRestTime > 0 then -- Nếu thời gian còn lại của Bạch Câu bù vào có dư, cần cộng lại
      nRestTime = nRestTime + nUseRestTime
      pPlayer.SetTask(self.TSKGID, tbBaiJu.nTaskId, nRestTime)
    end
    if (nLevelTotalExp - nAddExp) <= 0 then
      nWasteTime = 0
      bNoOpenWnd = 1
    end

    -- Khi đạt cấp tối đa và kinh nghiệm tối đa, xóa hết thời gian chưa bù còn lại
    if nLevelTotalExp <= 0 then
      nWasteTime = 0
    end

    if nWasteTime >= 0 then
      pPlayer.SetTask(self.TSKGID, self.TSKID_WASTE_TIME, nWasteTime)
      pPlayer.SetTask(self.TSKGID, self.TSKID_WASTE_START_LEVEL, nToLevel)
      pPlayer.SetTask(self.TSKGID, self.TSKID_WASTE_START_EXP, nToExp)
    --			if (bNoOpenWnd ~= 1) then
    --				self:ProcessWasteTime();	-- Mở lại giao diện, tiếp tục mua
    --			end
    else
      pPlayer.SetTask(self.TSKGID, self.TSKID_WASTE_TIME, 0)
      pPlayer.SetTask(self.TSKGID, self.TSKID_WASTE_START_LEVEL, 0)
      pPlayer.SetTask(self.TSKGID, self.TSKID_WASTE_START_EXP, 0)
    end

    -- Đưa ra thông báo
    local szMsg = string.format("Bạn đã bổ sung %s thời gian ủy thác bị bỏ lỡ, vẫn còn %s thời gian ủy thác bị bỏ lỡ chưa bổ sung.", self:GetDTimeDesc(nUseBaiJuTime - nUseRestTime), self:GetDTimeDesc(nWasteTime))
    if nLevelLimit < 150 and nLevelLimit > 0 then
      szMsg = szMsg .. string.format("Bạn đã ủy thác offline trước khi server mở giới hạn cấp <color=yellow>%d<color>, vì vậy kinh nghiệm offline lần này chỉ có thể giúp bạn lên tối đa cấp <color=yellow>%d<color>!\n", nLevelLimit, nLevelLimit)
    end

    me.Msg(szMsg)
  end

  local szMsg = string.format("Thời gian ủy thác offline còn lại hiện tại của %s của bạn là: %s", tbBaiJu.szName, self:GetDTimeDesc(nRestTime))
  pPlayer.Msg(szMsg)
  pPlayer.CallClientScript({ "Ui:ServerCall", "UI_HELPSPRITE", "OnUpdatePage_Page1" })
end

function tbOffline:TryOffline()
  if GLOBAL_AGENT then -- Máy chủ toàn cục cấm treo máy offline
    return 0
  end
  if self.MAPID_FOBID[me.nMapId] == 1 then -- Bản đồ cấm
    return 0
  end

  local nStallState = me.nStallState
  if nStallState ~= Player.STALL_STAT_STALL_SELL and nStallState ~= Player.STALL_STAT_OFFER_BUY then -- Đang bày bán
    return 0
  end

  local nTotalBaiJuTime = 0
  for nType, tbBaiJu in ipairs(self.BAIJU_DEFINE) do
    nTotalBaiJuTime = nTotalBaiJuTime + me.GetTask(self.TSKGID, tbBaiJu.nTaskId)
  end
  if nTotalBaiJuTime <= 0 then
    return 0 -- Đã hết thời gian Bạch Câu Hoàn
  end

  -- Tính toán thời gian có thể ủy thác
  local nTotalLiveTime = 0
  local nNowTime = self:GetTime()
  local nRestDayTime = 3600 * 24 - Lib:GetLocalDayTime(nNowTime)
  local nDayUsedTime = self:GetUsedOfflineTime(nNowTime) -- Thời gian ủy thác đã dùng hôm nay
  local nRestDayUseTime = self.nNowTimeDayUse - nDayUsedTime -- Thời gian ủy thác khả dụng hôm nay
  if nRestDayUseTime >= nRestDayTime then
    nRestDayUseTime = nRestDayUseTime
  end
  if nRestDayUseTime >= nTotalBaiJuTime then -- Ủy thác kết thúc trong ngày
    nTotalLiveTime = nTotalBaiJuTime
  else
    nTotalBaiJuTime = nTotalBaiJuTime - nRestDayUseTime
    nTotalLiveTime = nRestDayUseTime
    nTotalLiveTime = nTotalLiveTime + math.floor(nTotalBaiJuTime / self.nNowTimeDayUse) * 3600 * 24
    nTotalLiveTime = nTotalLiveTime + math.mod(nTotalBaiJuTime, self.nNowTimeDayUse)
  end

  me.SetTask(self.TSKGID, self.TSKID_OFFLINE_STARTTIME, nNowTime)

  self:Dbg("Begin Offline", me.szName, nTotalLiveTime)

  Player:RegisterTimer(nTotalLiveTime * Env.GAME_FPS, self.OnOfflineTimeout, self)

  PlayerEvent:Register("OnStallStateChange", self.OnStallStateChange, self)

  return 1
end

-- Trả về có thể vào trạng thái ngủ đông hiện tại không
function tbOffline:CanSleep()
  if self.MAPID_FOBID[me.nMapId] == 1 then -- Bản đồ cấm
    return 0
  end

  local nStallState = me.nStallState
  if nStallState == Player.STALL_STAT_STALL_SELL or nStallState == Player.STALL_STAT_OFFER_BUY then -- Đang bày bán
    return 0
  end

  local pNpc = me.GetFollowNpc()
  if pNpc then -- Đang đi theo
    return 0
  end

  return 1
end

function tbOffline:OnOfflineTimeout()
  self:Dbg("OnOfflineTimeout", me.szName)
  me.KickOut()
  return 0
end

-- Tính toán sẽ nhận được bao nhiêu kinh nghiệm trong tình huống cụ thể (chỉ tính một loại Bạch Câu Hoàn)
-- Tham số nTime , nStartLevel, nStartExp, nBaiJuType, nNowLevelLimit
-- Trả về nAddExp kinh nghiệm cần cộng, nAddPoint tinh lực hoạt lực cần cộng, nFinalLevel cấp độ cuối cùng, nFinalExp kinh nghiệm cuối cùng, nRestTime thời gian hiệu quả còn lại
function tbOffline:CalcAddExp(nTime, nStartLevel, nStartExp, nBaiJuType, nLevelTotalExp, nExpMultply)
  local nTotalLevelExp = nLevelTotalExp
  local nRestTime = nTime
  if nRestTime <= 0 then
    return 0, 0, nStartLevel, nStartExp, 0
  end

  if nTotalLevelExp <= 0 then
    return 0, 0, nStartLevel, nStartExp, nRestTime
  end

  assert(nExpMultply and nExpMultply > 0)

  local nAddExp = 0
  local nAddPoint = 0
  local nFinalLevel = #self.tbLevelData
  local nFinalExp = self.tbLevelData[nFinalLevel].nUpExp
  local nCurExp = nStartExp

  for nCurLevel = nStartLevel, #self.tbLevelData do
    local tbCurLevel = self.tbLevelData[nCurLevel] -- Dữ liệu cấp độ này
    local nCurAddExpSec = tbCurLevel.nBaseExpSec * nExpMultply -- Lượng kinh nghiệm tăng mỗi giây ở cấp độ này
    local nCurRestExp = math.min(tbCurLevel.nUpExp - nCurExp, nTotalLevelExp) -- Kinh nghiệm còn lại ở cấp độ này

    local nCurRestTime = math.ceil(nCurRestExp / nCurAddExpSec) -- Trước khi lên cấp, cấp độ này còn có thể cộng bao nhiêu giây kinh nghiệm
    if nCurRestExp < 0 then -- Kinh nghiệm tràn?
      Dbg:WriteLogEx(Dbg.LOG_ERROR, "Player", "tbOffline:CalcAddExp nCurRestExp < 0 ???", nStartLevel, nStartExp, nCurLevel, nCurExp, tbCurLevel.nUpExp)
      nCurRestTime = 0
    end
    local nCurAddTime = math.min(nRestTime, nCurRestTime) -- Thực tế có thể cộng bao nhiêu giây

    local nCurAddExp = nCurAddExpSec * nCurAddTime -- Thực tế có thể cộng bao nhiêu kinh nghiệm
    local nCurAddPoint = tbCurLevel.nEffect * self.POINT_ADD_PERHOUR * nCurAddTime / 3600

    nCurAddExp = math.min(nCurAddExp, nTotalLevelExp)
    nTotalLevelExp = nTotalLevelExp - nCurAddExp
    nAddExp = nAddExp + nCurAddExp
    nAddPoint = nAddPoint + nCurAddPoint
    nRestTime = nRestTime - nCurAddTime
    if nCurAddExp < nCurRestExp then -- Vẫn chưa đủ để lên cấp
      nFinalLevel = nCurLevel
      nFinalExp = nCurExp + nCurAddExp
      break
    end

    if nRestTime <= 0 then
      nFinalLevel = nCurLevel
      nFinalExp = nCurExp + nCurAddExp
      break
    end

    if nTotalLevelExp <= 0 then
      nFinalLevel = nCurLevel
      nFinalExp = nCurExp + nCurAddExp
      break
    end

    nCurExp = nCurAddExp - nCurRestExp -- Sau khi lên cấp, còn lại bấy nhiêu kinh nghiệm
  end

  nAddExp = math.floor(nAddExp)
  nAddPoint = math.floor(nAddPoint)

  return nAddExp, nAddPoint, nFinalLevel, nFinalExp, nRestTime
end

function tbOffline:GetLevelLimit(nTime)
  local nResultLevel = 69
  for i = 2, #self.tbLevelInfo do
    local nLevelTime = self.tbLevelInfo[i].nTime
    if nLevelTime == 0 then
      break
    end
    if nTime < nLevelTime then
      break
    elseif nTime >= nLevelTime then
      nResultLevel = self.tbLevelInfo[i].nLevel
    end
  end
  return nResultLevel
end

-- Tính toán thời gian ủy thác offline đã sử dụng trong ngày
function tbOffline:GetUsedOfflineTime(nNowTime)
  local nUsed = me.GetTask(self.TSKGID, self.TSKID_USED_OFFLINE_TIME)
  local nDay = Lib:GetLocalDay(nNowTime)
  if math.floor(nUsed / (3600 * 24)) == nDay then -- Đã sử dụng trong ngày
    return math.mod(nUsed, 3600 * 24)
  else
    return 0
  end
end

-- Tính toán nếu tăng thêm kinh nghiệm cụ thể, có thể đạt đến cấp độ bao nhiêu
--	Trả về:	nFinalLevel, nFinalExp
function tbOffline:GetFinalLevel(nStartLevel, nStartExp, nAddExp)
  local nCurExp = nStartExp + nAddExp
  for nCurLevel = nStartLevel, #self.tbLevelData do
    local tbLevel = self.tbLevelData[nCurLevel] -- Dữ liệu cấp độ này
    if nCurExp < tbLevel.nUpExp then
      return nCurLevel, nCurExp
    end

    nCurExp = nCurExp - tbLevel.nUpExp -- Sau khi lên cấp, còn lại bấy nhiêu kinh nghiệm
  end

  -- Đạt đến giới hạn cấp độ
  local nFinalLevel = #self.tbLevelData
  local nFinalExp = self.tbLevelData[nFinalLevel].nUpExp

  return nFinalLevel, nFinalExp
end

-- Trả về chuỗi mô tả thời điểm
function tbOffline:GetTimeDesc(nTime)
  return os.date("<color=Yellow>%Y năm %m tháng %d ngày %H:%M:%S<color>", nTime)
end

-- Trả về chuỗi mô tả độ dài thời gian cố định
function tbOffline:GetDTimeShortDesc(nDTime)
  return string.format("<color=Yellow>%8s<color>", Lib:TimeDesc(nDTime))
end

-- Trả về chuỗi mô tả thời gian đầy đủ
function tbOffline:GetDTimeDesc(nDTime)
  return string.format("<color=Yellow>%s<color>", Lib:TimeFullDesc(nDTime))
end

-- Trả về chuỗi mô tả độ dài cấp độ cố định
function tbOffline:GetLevelShortDesc(nLevel, nExp)
  return string.format("%.2f cấp", nLevel + nExp / self.tbLevelData[nLevel].nUpExp)
end

-- Trả về chuỗi mô tả cấp độ
function tbOffline:GetLevelDesc(nLevel, nExp)
  return string.format("<color=Green>%d cấp %.1f%% kinh nghiệm<color>", nLevel, nExp * 100 / self.tbLevelData[nLevel].nUpExp)
end

-- Đóng gói GetTime
function tbOffline:GetTime()
  return GetTime() + self.nDTime
end

function tbOffline:GM()
  DoScript("\\script\\player\\offline.lua")
  DoScript("\\script\\item\\class\\baijuwan.lua")
  Dialog:Say("offline GM~", { "Mô phỏng online", self.OnLogin, self, 0 }, { "Mô phỏng offline (chỉ lưu trữ)", me.SaveQuickly }, { "Thiết lập chênh lệch thời gian", Dialog.AskString, Dialog, "Nhập số giây cần chênh lệch +/-", 10, self.GM_DTime, self }, { "Tặng Bạch Câu", self.GM_Get, self }, "over")
end

function tbOffline:GM_DTime(szDTime)
  self.nDTime = self.nDTime + Lib:Str2Val(szDTime)
  local szMsg = string.format("Chênh lệch thời gian %s%s, thời gian mô phỏng hiện tại: %s", (self.nDTime >= 0) and "+" or "-", self:GetDTimeDesc(math.abs(self.nDTime)), self:GetTimeDesc(self:GetTime()))
  me.Msg(szMsg)
  me.CallClientScript({ "Player.tbOffline:SetTime", szDTime })
end

function tbOffline:SetTime(szDTime)
  self.nDTime = self.nDTime + Lib:Str2Val(szDTime)
  local szMsg = string.format("Chênh lệch thời gian %s%s, thời gian mô phỏng hiện tại: %s", (self.nDTime >= 0) and "+" or "-", self:GetDTimeDesc(math.abs(self.nDTime)), self:GetTimeDesc(self:GetTime()))
end

function tbOffline:GM_Get()
  me.AddItem(18, 1, 71, 1)
  me.AddItem(18, 1, 71, 2)
  me.AddItem(18, 1, 71, 3)
  me.AddItem(18, 1, 71, 4)
end

-- Gỡ lỗi
function tbOffline:Dbg(...)
  Dbg:Output("Player", "Offline", unpack(arg))
end

function tbOffline:WriteLog(...)
  if MODULE_GAMESERVER then
    Dbg:WriteLogEx(Dbg.LOG_INFO, "Player", "Offline", unpack(arg))
  end
  if MODULE_GAMECLIENT then
    Dbg:Output("Player", "Offline", unpack(arg))
  end
end

tbOffline:Init()

if MODULE_GAMESERVER then
  ServerEvent:RegisterServerStartFunc(tbOffline._LoadBaijuCoin, tbOffline)
end

if MODULE_GAMECLIENT then
  function tbOffline:GetBaiJuDefine(tbBaiDefine, nNowTimeDayUse)
    self.nNowTimeDayUse = nNowTimeDayUse
    self.BAIJU_DEFINE = tbBaiDefine
  end
end

--houxuan
function tbOffline:GetLeftBaiJuTime(pPlayer)
  --Lấy thời gian còn lại của mỗi loại Bạch Câu hiện tại, lần lượt là Tiểu Bạch, Đại Bạch, Cường Bạch, Đặc Bạch, đơn vị là giây
  local nLeftBaiJuTime = 0
  for nIndex, v in ipairs(self.BAIJU_DEFINE) do
    nLeftBaiJuTime = nLeftBaiJuTime + pPlayer.GetTask(self.TSKGID, v.nTaskId)
  end
  return nLeftBaiJuTime
end

-- Tính toán thời gian ủy thác offline đã sử dụng trong ngày
function tbOffline:GetNowDayUsedOfflineTime(pPlayer, nNowTime)
  local nUsed = pPlayer.GetTask(self.TSKGID, self.TSKID_USED_OFFLINE_TIME)
  local nDay = Lib:GetLocalDay(nNowTime)
  if math.floor(nUsed / (3600 * 24)) == nDay then -- Đã sử dụng trong ngày
    return math.mod(nUsed, 3600 * 24)
  else
    return 0
  end
end

function tbOffline:AddNowDayUsedTime(pPlayer, nAddTime, nNowTime)
  local nTodayUsedtime = self:GetNowDayUsedOfflineTime(pPlayer, nNowTime)
  local nNowDay = Lib:GetLocalDay(nNowTime)
  pPlayer.SetTask(self.TSKGID, self.TSKID_USED_OFFLINE_TIME, nNowDay * 3600 * 24 + nTodayUsedtime + nAddTime)
end

--Lấy thời gian tu luyện offline còn lại trong ngày
function tbOffline:GetLeftOfflineTime(pPlayer)
  local nNowTime = self:GetTime()
  return self.TIME_DAY_USE - self:GetNowDayUsedOfflineTime(pPlayer, nNowTime)
end

function tbOffline:GetRemainBaijuTime(pPlayer)
  local tbLeftBaiJuTime = {}
  local nAllBaiJuTime = 0
  for nIndex, v in ipairs(self.BAIJU_DEFINE) do
    tbLeftBaiJuTime[nIndex] = pPlayer.GetTask(self.TSKGID, v.nTaskId)
    nAllBaiJuTime = nAllBaiJuTime + tbLeftBaiJuTime[nIndex]
  end
  --Thời gian Bạch Câu đã dùng hết, trả về trực tiếp
  return nAllBaiJuTime
end

function tbOffline:CheckIsFullLevel(pPlayer)
  local nCurMaxLevel = KPlayer.GetMaxLevel()
  local nAllExp = self.tbLevelData[nCurMaxLevel].nUpExp
  local nCurExp = pPlayer.GetExp()
  if pPlayer.nLevel >= nCurMaxLevel and nCurExp >= nAllExp then
    --Vượt quá giới hạn cấp độ, không xử lý, trả về trực tiếp
    return 1
  end
  return 0
end

function tbOffline:AddSpecialExp(pPlayer, nTime, nStateFlag) -- nStateFlag ghi lại trường hợp sử dụng hàm này để tính kinh nghiệm, có thể không điền, ở đây 1 có nghĩa là ủy thác online
  local nNowTime = self:GetTime()
  local nUsedTime = self:GetNowDayUsedOfflineTime(pPlayer, nNowTime)
  local nLeftTime = self.TIME_DAY_USE - nUsedTime
  if nLeftTime < nTime then
    return 3
  end

  --Lấy thời gian còn lại của mỗi loại Bạch Câu hiện tại, lần lượt là Tiểu Bạch, Đại Bạch, Cường Bạch, Đặc Bạch
  local tbLeftBaiJuTime = {}
  local nAllBaiJuTime = 0
  for nIndex, v in ipairs(self.BAIJU_DEFINE) do
    tbLeftBaiJuTime[nIndex] = pPlayer.GetTask(self.TSKGID, v.nTaskId)
    nAllBaiJuTime = nAllBaiJuTime + tbLeftBaiJuTime[nIndex]
  end
  --Thời gian Bạch Câu đã dùng hết, trả về trực tiếp
  if nAllBaiJuTime <= 0 then
    return 2
  end

  --Nếu không thì tính toán giá trị kinh nghiệm người chơi có thể nhận được
  local nExp = 0
  local nSpecialTime = nTime
  local nIndex = #tbLeftBaiJuTime
  local nCurLevel = pPlayer.nLevel
  local tbLevel = self.tbLevelData[nCurLevel] --Lấy giá trị kinh nghiệm cơ bản của cấp độ hiện tại
  local nLevelBaseExp = tbLevel.nBaseExpSec * self.CHANGE_MULT --Bội số kinh nghiệm mỗi giây trong trạng thái offline

  while nIndex > 0 and nSpecialTime > 0 do
    local nCurTime = tbLeftBaiJuTime[nIndex]
    local tbData = self.BAIJU_DEFINE[nIndex]
    if nCurTime > 0 then
      if nSpecialTime > nCurTime then
        nExp = nExp + nCurTime * tbData.nExpMultply * nLevelBaseExp --thời gian?phút?giây?
        nSpecialTime = nSpecialTime - nCurTime
        tbLeftBaiJuTime[nIndex] = 0
      else
        nExp = nExp + nSpecialTime * tbData.nExpMultply * nLevelBaseExp
        tbLeftBaiJuTime[nIndex] = nCurTime - nSpecialTime
        nSpecialTime = 0
      end
    end
    nIndex = nIndex - 1
  end
  nExp = math.floor(nExp)

  --Xem có vượt quá giới hạn cấp độ hiện tại không
  local nCurMaxLevel = KPlayer.GetMaxLevel()
  local nAllExp = self.tbLevelData[nCurMaxLevel].nUpExp
  local nCurExp = pPlayer.GetExp()
  if nCurExp + nExp > nAllExp then
    --Vượt quá giới hạn cấp độ, không xử lý, trả về trực tiếp
    return 1
  end

  --Nếu không vượt quá thì cộng kinh nghiệm cho người chơi, trừ đi thời gian Bạch Câu
  pPlayer.AddExp(nExp)

  if nStateFlag and nStateFlag == 1 then
    Player.tbOnlineExp:GiveExpInfo(pPlayer, nExp)
  end

  --Sửa đổi thời gian của các loại Bạch Câu
  for nIndex, v in ipairs(self.BAIJU_DEFINE) do
    local nBaiJuTime = pPlayer.GetTask(self.TSKGID, v.nTaskId)
    local nLeftTime = tbLeftBaiJuTime[nIndex]
    if nLeftTime ~= nBaiJuTime then
      pPlayer.SetTask(self.TSKGID, v.nTaskId, nLeftTime)
    end
  end

  --Sửa đổi thời gian tu luyện offline trong ngày của người chơi
  self:AddNowDayUsedTime(pPlayer, nTime, nNowTime)
  if nAllBaiJuTime < nTime then
    return 2
  end
  return 1
end

-- Kiểm tra xem có đủ điều kiện nhận hàm đền bù giới hạn do gộp server trước khi cập nhật không
function tbOffline:CheckExGive()
  local nRestTime = 0
  local nNowTime = GetTime()
  local nGbCoZoneTime = KGblTask.SCGetDbTaskInt(DBTASK_COZONE_TIME)
  local nZoneStartTime = KGblTask.SCGetDbTaskInt(DBTASD_SERVER_STARTTIME)
  local nCurZoneStartTime = me.GetTask(self.TSKGID, self.TSKID_SERVERSTART_TIME)
  local bAddExp = 0
  if me.IsSubPlayer() == 0 then
    return 0
  end

  if nNowTime < self.EXGIVEENDTIME then
    return 0
  end

  if nNowTime > nGbCoZoneTime and nNowTime < nGbCoZoneTime + 10 * 24 * 60 * 60 and me.nLevel >= 50 then
    local nSelfCoZoneTime = me.GetTask(self.TSKGID, self.TSKID_COZONE_GIVEOFFLINETIME_FLAG)
    if nSelfCoZoneTime ~= nGbCoZoneTime then
      return 0
    end

    local nFlag = me.GetTask(self.TSKGID, self.TSKID_COZONE_GIVEOFFLINE_TIME)
    if nFlag > 0 and nFlag >= self.EXGIVEENDTIME then
      return 0
    end

    return 1
  end
  return 0
end

function tbOffline:OnSureGetExCompensationOffline()
  if self:CheckExGive() == 0 then
    return 0
  end
  local bAddExp = 0
  local nOrgWasterTime = me.GetTask(self.TSKGID, self.TSKID_WASTE_TIME)
  if bAddExp == 1 or me.IsSubPlayer() == 1 then -- Kiểm tra xem tên mình có trong danh sách ưu đãi không
    -- Cộng thêm chênh lệch thời gian mở server của hai server gộp lại
    local nRestTime = 0
    nRestTime = math.min(self.DEF_COMBINSERVER_GIVETIME * 24 * 3600 * 0.75, KGblTask.SCGetDbTaskInt(DBTASK_SERVER_STARTTIME_DISTANCE) * 0.75)
    nRestTime = nRestTime - 90 * 24 * 3600 * 0.75
    if nRestTime < 0 then
      nRestTime = 0
    end
    if nRestTime > 0 then
      me.SetTask(self.TSKGID, self.TSKID_WASTE_TIME, nOrgWasterTime + nRestTime)
      me.Msg(string.format("Bạn đã nhận %d giờ thời gian đền bù gộp server chưa nhận trước đó", math.floor(nRestTime / 3600)))
    end
    me.SetTask(self.TSKGID, self.TSKID_COZONE_GIVEOFFLINE_TIME, self.EXGIVEENDTIME)
    self:WriteLog("GiveExOfflineTime", me.szName, nOrgWasterTime, nRestTime, GetTime())
  end
  return 1
end

-- Do gộp server trước khi cập nhật
-- Hàm này chỉ được thực hiện sau khi đã nhận thưởng gộp server trước khi cập nhật lần đầu tiên, như vậy không cần quan tâm đến quy tắc ngầm của thời gian ủy thác offline
function tbOffline:GiveExOfflineTime()
  if self:CheckExGive() == 0 then
    return 0
  end

  local nGbCoZoneTime = KGblTask.SCGetDbTaskInt(DBTASK_COZONE_TIME)
  local szTime = os.date("%Y năm %m tháng %d ngày", nGbCoZoneTime + 10 * 24 * 60 * 60)
  Dialog:Say(string.format("Bạn có thể nhận thời gian ủy thác offline đền bù gộp server trước %s, có chắc chắn nhận ngay bây giờ không?", szTime), {
    { "Chắc chắn", self.OnSureGetExCompensationOffline, self },
    { "Để ta suy nghĩ thêm" },
  })
end

--==================================================

-- Thao tác giao diện giữ chân người chơi thoát game (mua Bạch Câu)
function tbOffline:Detain_BuyBaijuDlg()
  local szMsg = string.format("Khi bạn đạt cấp 20, có thể dùng Bạch Câu Hoàn, sau khi dùng sẽ nhận được 8 giờ thời gian tu luyện offline, mỗi ngày có thể tu luyện offline tối đa 18 giờ.\nNhấp vào cửa hàng ở góc trên bên phải giao diện, dùng %s hoặc %s khóa để mua Bạch Câu Hoàn, dễ dàng thực hiện ủy thác lên cấp.", IVER_g_szCoinName, IVER_g_szCoinName)
  local tbOpt = {
    { string.format("Mua Bạch Câu Hoàn (36 %s khóa)", IVER_g_szCoinName), self.BuyBaiju, self, 1 },
    { string.format("Mua Đại Bạch Câu Hoàn (180 %s khóa)", IVER_g_szCoinName), self.BuyBaiju, self, 2 },
    { "Để ta suy nghĩ thêm" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbOffline:BuyBaiju(nIndex)
  if not nIndex or not self.tbBaijuInfo[nIndex] then
    return
  end

  local tbInfo = self.tbBaijuInfo[nIndex]
  if me.CountFreeBagCell() < 1 then
    me.Msg("Túi đồ của bạn không đủ chỗ, vui lòng dọn ra ít nhất 1 ô trống rồi hãy quay lại.")
    return
  end

  if me.nBindCoin < tbInfo.nCost then
    me.Msg(string.format("Số lượng %s khóa của bạn không đủ, hãy mang đủ %s khóa rồi quay lại.", IVER_g_szCoinName, IVER_g_szCoinName))
    return
  end

  if me.AddBindCoin(-tbInfo.nCost, Player.emKBINDCOIN_COST_BAIJU_LOGOUT) == 1 then
    local pItem = me.AddItem(unpack(tbInfo.szGDPL))
    if pItem then
      pItem.Bind(1)
      Dbg:WriteLog("Onffline", "Mua thành công Bạch Câu Hoàn", tbInfo.nCost, nIndex)
    end
  end
end

--end
