-- 文件名　：homeland_gc.lua
-- 创建者　：huangxiaoming
-- 创建时间：2011-06-10 14:44:10
-- 描  述  ：

if not MODULE_GC_SERVER then
  return
end

Require("\\script\\kin\\homeland\\homeland_def.lua")

-- 启动的时候加载排行榜
function HomeLand:InitRank()
  local nCount = 1
  local nFirstOpen = KGblTask.SCGetDbTaskInt(DBTASK_HOMELAND_FIRST_OPEN)
  local cNextKin, nNextKin = KKin.GetFirstKin()
  local tbOpenKinList = {} -- 已开启家族领地的家族列表
  while cNextKin and nCount < 2000000 do
    local nRank = cNextKin.GetLastHomeLandRank()
    local nRepute = cNextKin.GetTotalRepute()
    if nFirstOpen ~= 0 and nRank > 0 and nRank <= self.MAX_VISIBLE_LADDER then
      self.tbLastWeekRank[nRank] = nNextKin
    end
    self.tbCurWeekRank[nCount] = {}
    self.tbCurWeekRank[nCount].nKinId = nNextKin
    self.tbCurWeekRank[nCount].nRepute = nRepute
    self.tbCurWeekRank[nCount].nLastRank = nRank
    self.tbKinId2Index[nNextKin] = nCount
    if cNextKin.GetIsOpenHomeLand() == 1 then
      table.insert(tbOpenKinList, nNextKin)
    end
    cNextKin, nNextKin = KKin.GetNextKin(nNextKin)
    nCount = nCount + 1 -- 防死循环
  end
  if nFirstOpen == 0 then -- 服务器第一次启动直接取当前威望的排名
    table.sort(self.tbCurWeekRank, self._KinReputeCmp)
    self.tbKinId2Index = {}
    for i = 1, #self.tbCurWeekRank do
      self.tbKinId2Index[self.tbCurWeekRank[i].nKinId] = i
    end
    self:ChangeRank()
    self:UpdateShowLadder()
    KGblTask.SCSetDbTaskInt(DBTASK_HOMELAND_FIRST_OPEN, 1)
  end
  if self:CheckFirstWeek() == 1 then
    self:LoadHomeLandMap(tbOpenKinList)
  else
    self:LoadHomeLandMap()
  end
end

HomeLand._KinReputeCmp = function(tb1, tb2)
  if tb1.nRepute ~= tb2.nRepute then
    return tb1.nRepute > tb2.nRepute
  end
  return tb1.nLastRank < tb2.nLastRank
end

-- 更新前10
function HomeLand:UpdateShowLadder()
  local nLadderType = Ladder:GetType(0, Ladder.LADDER_CLASS_LADDER, Ladder.LADDER_TYPE_LADDER_KINREPUTE, 0)
  if GetShowLadder(nLadderType) then
    DelShowLadder(nLadderType)
  end
  local szTitle = "家族排行榜"
  if 0 == CheckShowLadderExist(nLadderType) then
    AddNewShowLadder(nLadderType)
  end
  local szName = "家族排行榜"
  SetShowLadderName(nLadderType, szName, string.len(szName) + 1)
  local tbLadderInfo = {}
  for i = 1, 10 do
    if self.tbLastWeekRank[i] then
      local nKinId = self.tbLastWeekRank[i]
      local cKin = KKin.GetKin(nKinId)
      if cKin then
        local tbInfo = {}
        tbInfo.szName = cKin.GetName()
        tbInfo.dwImgType = 2
        tbInfo.szTxt1 = cKin.GetTotalRepute()
        local nCamp = cKin.GetCamp()
        if nCamp <= 3 and nCamp >= 1 then
          tbInfo.szTxt2 = "阵营：" .. self.CAMP[nCamp]
        else
          tbInfo.szTxt2 = "阵营："
        end
        local nRegular, nSigned, nRetire = cKin.GetMemberCount()
        local nMemberCount = nRegular + nSigned + nRetire
        tbInfo.szTxt3 = "成员：" .. nMemberCount .. "人"
        local nLeader = cKin.GetCaptain()
        local cMember = cKin.GetMember(nLeader)
        if cMember then
          local nPlayerId = cMember.GetPlayerId()
          local szName = KGCPlayer.GetPlayerName(nPlayerId)
          tbInfo.szTxt4 = "族长：" .. szName
        else
          tbInfo.szTxt4 = "族长："
        end
        local nBelongTong = cKin.GetBelongTong()
        if nBelongTong <= 0 then
          tbInfo.szTxt5 = "所属帮会："
        else
          local cTong = KTong.GetTong(nBelongTong)
          if cTong then
            tbInfo.szTxt5 = "所属帮会：" .. cTong.GetName()
          else
            tbInfo.szTxt5 = "所属帮会："
          end
        end
        tbInfo.szTxt6 = ""

        tbInfo.szContext = cKin.GetHomeLandDesc() or ""
        table.insert(tbLadderInfo, tbInfo)
      end
    end
  end
  SetShowLadder(nLadderType, szTitle, string.len(szTitle) + 1, tbLadderInfo)
  GlobalExcute({ "Ladder:RefreshLadderName" })
end

-- 启动时候加载地图副本
function HomeLand:LoadHomeLandMap(tbLoadList)
  tbLoadList = tbLoadList or self.tbLastWeekRank
  local nMinServerCount = GCEvent.SERVER_COUNT
  if nMinServerCount > 7 then
    nMinServerCount = 7
  end

  for nRank = 1, self.MAX_LADDER_RNAK do
    local nKinId = self.tbLastWeekRank[nRank]
    if nKinId and not self.tbKinId2MapId[nKinId] then
      self.tbKinId2MapId[nKinId] = {}
      self.tbKinId2MapId[nKinId][1] = math.mod(nRank, nMinServerCount) + 1
      self.tbKinId2MapId[nKinId][2] = 0
    end
  end
end

-- 每周一六点刷新
function HomeLand:RefreshRank()
  if tonumber(GetLocalDate("%w")) ~= self.REFRESH_WEEKDAY then
    return
  end
  table.sort(self.tbCurWeekRank, self._KinReputeCmp)
  self.tbKinId2Index = {}
  for i = 1, #self.tbCurWeekRank do
    self.tbKinId2Index[self.tbCurWeekRank[i].nKinId] = i
  end
  self:ChangeRank()
  self:UpdateShowLadder()
  self:LoadHomeLandMap()
  self:UpdateGSData()
  self.nLogIndex = 1
  --新服家族拉人赛（by jiazhenwei ）
  local nServerStarTime = tonumber(os.date("%Y%m%d", tonumber(KGblTask.SCGetDbTaskInt(DBTASD_SERVER_STARTTIME))))
  if tonumber(GetLocalDate("%Y%m%d")) == SpecialEvent.tbNewGateEvent.nStartTime and nServerStarTime >= SpecialEvent.tbNewGateEvent.nServerStarLimit then
    SpecialEvent.tbNewGateEvent:GetAwardList(self.tbKinId2Index)
  end
  Timer:Register(1, self.WriteRankLog_Timer, self)
end

-- 记录log
function HomeLand:WriteRankLog_Timer()
  local nIndex = self.nLogIndex
  local nMaxList = math.min(#self.tbLastWeekRank, self.MAX_LOG_COUNT)
  if nIndex > nMaxList then
    self.nLogIndex = 1
    return 0
  end
  local nMaxNum = math.min(nIndex + 5, nMaxList)
  for i = nIndex, nMaxNum do
    local cKin = KKin.GetKin(self.tbLastWeekRank[i])
    if cKin then
      local szKinName = cKin.GetName()
      local szTongName = ""
      local pTong = KTong.GetTong(cKin.GetBelongTong())
      if pTong then
        szTongName = pTong.GetName()
      end
      local nRegular, nSigned, nRetire = cKin.GetMemberCount()
      local nMemberCount = nRegular + nSigned + nRetire
      local nLastReputeRank = cKin.GetLastHomeLandRank()
      local nTotalRepute = cKin.GetTotalRepute()
      StatLog:WriteStatLog("stat_info", "jiazulingdi", "weiwangpaiming", 0, szTongName, szKinName, nMemberCount, nLastReputeRank, nTotalRepute)
    end
  end
  self.nLogIndex = nMaxNum + 1
  return 1
end

-- 族长开启家园
function HomeLand:OpenHomeLand_GC(nKinId, nMemberId, nPlayerId)
  local nRet, cKin = Kin:CheckSelfRight(nKinId, nMemberId, 1)
  if nRet ~= 1 then
    return 0
  end
  if cKin.GetIsOpenHomeLand() == 1 then
    return 0
  end
  cKin.SetIsOpenHomeLand(1)
  GlobalExcute({ "HomeLand:OpenHomeLand_GS2", nKinId })
  StatLog:WriteStatLog("stat_info", "jiazulingdi", "open", nPlayerId, cKin.GetName())
end

-- 新服第一周可直接开启家族领地
function HomeLand:NewServerOpenHomeLand_GC(nKinId, nMemberId, nPlayerId)
  local nRet, cKin = Kin:CheckSelfRight(nKinId, nMemberId, 1)
  if nRet ~= 1 then
    return 0
  end
  if cKin.GetIsOpenHomeLand() == 1 then
    return 0
  end
  if self:CheckFirstWeek() ~= 1 then
    return 0
  end
  local nCount = 0
  for _, _ in pairs(self.tbKinId2MapId) do
    nCount = nCount + 1
  end
  if nCount >= self.MAX_LADDER_RNAK then -- 最多开启200个，防止无限制出地图
    return 0
  end
  if self.tbKinId2MapId[nKinId] then
    return 0
  end
  local nMinServerCount = GCEvent.SERVER_COUNT
  if nMinServerCount > 7 then
    nMinServerCount = 7
  end
  cKin.SetIsOpenHomeLand(1)
  self.tbKinId2MapId[nKinId] = {}
  self.tbKinId2MapId[nKinId][1] = math.mod(nCount, nMinServerCount) + 1
  self.tbKinId2MapId[nKinId][2] = 0
  GlobalExcute({ "HomeLand:OpenHomeLand_GS2", nKinId })
  GlobalExcute({ "HomeLand:LoadMap_GS", self.tbKinId2MapId, 0 })
  StatLog:WriteStatLog("stat_info", "jiazulingdi", "open", nPlayerId, cKin.GetName())
end

function HomeLand:ChangeRank()
  self.tbLastWeekRank = {}
  for i = 1, #self.tbCurWeekRank do
    if self.tbCurWeekRank[i] then
      if self.tbCurWeekRank[i].nRepute > 0 then
        if i <= self.MAX_VISIBLE_LADDER then
          self.tbLastWeekRank[i] = self.tbCurWeekRank[i].nKinId
        end
        self.tbCurWeekRank[i].nLastRank = i
      else
        self.tbCurWeekRank[i].nLastRank = 0
      end

      local cKin = KKin.GetKin(self.tbCurWeekRank[i].nKinId)
      if cKin then
        cKin.SetLastHomeLandRank(self.tbCurWeekRank[i].nLastRank)
      end
    end
  end
end

function HomeLand:RecordKinMapId_GC(nKinId, nMapId)
  self.tbKinId2MapId[nKinId][2] = nMapId
  GlobalExcute({ "HomeLand:RecordKinMapId_GS2", nKinId, nMapId })
end

function HomeLand:UpdateGSData(nConnectId, nConectEvent)
  nConnectId = nConnectId or -1
  nConectEvent = nConectEvent or 0
  GSExcute(nConnectId, { "HomeLand:LoadLadder_GS", self.tbLastWeekRank })
  GSExcute(nConnectId, { "HomeLand:LoadMap_GS", self.tbKinId2MapId, nConectEvent })
end

function HomeLand:OnRecConnectEvent(nConnectId)
  self:UpdateGSData(nConnectId, 1)
end

GCEvent:RegisterGCServerStartFunc(HomeLand.InitRank, HomeLand)
GCEvent:RegisterGS2GCServerStartFunc(HomeLand.OnRecConnectEvent, HomeLand)

-----------------GM-----------------------
--强制更新家族排行
function HomeLand:GM_ForceUpdate()
  self.tbCurWeekRank = {}
  self.tbLastWeekRank = {}
  self.tbKinId2MapId = {}
  local nCount = 1
  local cNextKin, nNextKin = KKin.GetFirstKin()
  while cNextKin and nCount < 2000000 do
    local nRepute = cNextKin.GetTotalRepute()
    self.tbCurWeekRank[nCount] = {}
    self.tbCurWeekRank[nCount].nKinId = nNextKin
    self.tbCurWeekRank[nCount].nRepute = nRepute
    self.tbCurWeekRank[nCount].nLastRank = 0
    self.tbKinId2Index[nNextKin] = nCount
    cNextKin, nNextKin = KKin.GetNextKin(nNextKin)
    nCount = nCount + 1 -- 防死循环
  end
  table.sort(self.tbCurWeekRank, self._KinReputeCmp)
  for i = 1, #self.tbCurWeekRank do
    self.tbKinId2Index[self.tbCurWeekRank[i].nKinId] = i
  end
  self:ChangeRank()
  self:UpdateShowLadder()
  self:LoadHomeLandMap()
  self:UpdateGSData()
  return 1
end

---------------------------------------------家族挑战令相关---------------------------------
-- 每日重置家族挑战令次数
function HomeLand:ResetHomeLandChallengeTimesDaily()
  self.HomeLandChallenge_cKin, self.HomeLandChallenge_nKin = KKin.GetFirstKin()
  if self.HomeLandChallenge_nKin then
    Timer:Register(1, self.ResetHomeLandChallengeTimesDaily_Timer, self)
  end
  return 0 -- 这里返回0，是因为其实本帧内还没有什么逻辑
end

function HomeLand:ResetHomeLandChallengeTimesDaily_Timer()
  local nDailyTimes = self:GetDailyChallengeTimes()
  local nCount = 1
  while self.HomeLandChallenge_cKin and nCount < 500000 do -- 每一帧内不要做太多
    --self.HomeLandChallenge_cKin.SetChallengeTimes(nDailyTimes);
    self:SetKinChallengeTimes(self.HomeLandChallenge_nKin, nDailyTimes)
    self.HomeLandChallenge_cKin, self.HomeLandChallenge_nKin = KKin.GetNextKin(self.HomeLandChallenge_nKin)
    nCount = nCount + 1
  end

  if self.HomeLandChallenge_cKin then
    return 1 -- 还有没重置的，下一帧继续做
  end

  return 0 -- 已经全部重置了，结束timer
end

function HomeLand:SetKinChallengeTimes(nKinId, nTimes, nReason, tbParam)
  local pKin = KKin.GetKin(nKinId)
  if not pKin then
    return
  end

  pKin.SetChallengeTimes(nTimes)
  -- 修改数据版本号
  Kin.nJourNum = Kin.nJourNum + 1
  pKin.SetKinDataVer(Kin.nJourNum)
  GlobalExcute({ "HomeLand:SetChallengeTimesResult", Kin.nJourNum, nKinId, nTimes, nReason or 0, tbParam })
end

-- GS申请消耗一次挑战次数
function HomeLand:ApplyCostChallengeTimes(nKinId, tbParam)
  local nUsed, nAll = self:GetTodayChallengeTimes(nKinId)
  if not nUsed or not nAll or nUsed >= nAll then
    return
  end

  local nTimes = nAll
  nTimes = Lib:SetBits(nTimes, nUsed + 1, 16, 31)
  self:SetKinChallengeTimes(nKinId, nTimes, 1, tbParam) -- reason为1表示是由GS发起的消耗申请
end
