-- 文件名　：treasuremapEx_gs.lua
-- 创建者　：LQY
-- 创建时间：2012-11-02 16:26:39
-- 说　　明：藏宝图重整

Require("\\script\\task\\treasuremapex\\treasuremapex_def.lua")
Require("\\script\\task\\treasuremap2\\treasuremap2_def.lua")
local TreasureMapEx = TreasureMap.TreasureMapEx

--玩家等级到星级
function TreasureMapEx:Level2Star(nLevel)
  if not nLevel then
    return -1
  end
  nLevel = tonumber(nLevel)
  for _, tbData in pairs(self.tbRankTable) do
    if nLevel >= tonumber(tbData.LevelLower) and nLevel <= tonumber(tbData.LevelUpper) then
      return tonumber(tbData.Star), tonumber(tbData.LevelLower), tonumber(tbData.LevelUpper)
    end
  end
  return -1
end

--星级到副本列表
function TreasureMapEx:Star2Maps(nStar)
  if not nStar then
    return nil
  end
  nStar = tonumber(nStar)
  local rs = {}
  local nCount = 0
  for i = 0, nStar do
    nCount = nCount + #self.tbStarMapTable[i]
    rs[i] = self.tbStarMapTable[i]
  end
  if not rs[0] then
    rs = nil
  end
  return rs, nCount
end

--星级&分数等级到奖励{数量，tbItem}
function TreasureMapEx:Star2AwrrowCount(nStar, nArrowLevel)
  if not self.tbStarAward[nStar] then
    return 0
  end
  if not self.tbStarAward[nStar][nArrowLevel] then
    return 0
  end
  return self.tbStarAward[nStar][nArrowLevel][1], self.tbStarAward[nStar][nArrowLevel].tbItem
end

-- 玩家藏宝图次数检查
function TreasureMapEx:CheckPlayerCount(pPlayer)
  if pPlayer.GetTask(self.TASK_GROUP, self.TASK_COUNT) > 0 then
    return 1
  end
  return 0
end

--ID到副本信息
function TreasureMapEx:Id2MapInfo(nId)
  local szTypeName = self.tbId2Type[nId]
  return self.tbMapInfo[szTypeName]
end
----------------GS only----
if not MODULE_GAMESERVER then
  return
end

--星级到NPC等级
function TreasureMapEx:Star2NpcLevel(nStar)
  if not nStar then
    return nil
  end
  nStar = tonumber(nStar)
  return self.tbNpcLevel[nStar] or nil
end

--Id星级到好感度
function TreasureMapEx:Id2Favor(nId, nStar)
  local tbMap = self:Star2Maps(nStar)
  if not tbMap then
    return 0
  end
  local szTypeName = self.tbId2Type[nId]
  if not szTypeName then
    return 0
  end
  for _, tbMapInfo in pairs(tbMap[nStar]) do
    if tbMapInfo.TypeName == szTypeName then
      return tonumber(tbMapInfo.Favor)
    end
  end
  return 0
end

--获取队伍可以进入的星级
function TreasureMapEx:GetTeamStar(nPlayerId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return -1, "你不能进入藏宝图！"
  end
  if pPlayer.nTeamId <= 0 then
    return -1, "副本路途险恶，必须组队才能进入。"
  end
  local tbTeamList = KTeam.GetTeamMemberList(pPlayer.nTeamId)
  if not tbTeamList then
    return -1, "你不能进入藏宝图！"
  end
  local nLevel = 999
  for _, nTeamPlayerId in pairs(tbTeamList) do
    local pTeamPlayer = KPlayer.GetPlayerObjById(nTeamPlayerId)
    if not pTeamPlayer then
      return -1, "你的队伍不能进入藏宝图，必须所有对友都在附近！"
    end
    if pTeamPlayer.nLevel < nLevel then
      nLevel = pTeamPlayer.nLevel
    end
  end
  local nStar, nLvlLow, nLvlTop = self:Level2Star(nLevel)
  if nStar == -1 then
    return -1, string.format("你的队伍里最小等级为<color=green>%d级<color>，没有你的队伍可以进入的副本！", nLevel)
  end
  return nStar, string.format("你的队伍里最小等级为<color=green>%d级<color>，你们可以挑战的藏宝图为:\n\n<color=red>          %d星(%d—%d级)<color>\n", nLevel, nStar, nLvlLow, nLvlTop)
end

function TreasureMapEx:CheckPlayer(nPlayerId, nCityMapId, nStar)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer or pPlayer.nMapId ~= nCityMapId then
    return 0, "不在附近"
  end

  if pPlayer.nTeamId <= 0 then
    return 0, "副本路途险恶，必须组队才能进入。"
  end
  if self:Level2Star(pPlayer.nLevel) < nStar then
    return 0, "等级不足"
  end

  if pPlayer.GetCamp() == 0 then
    return 0, "无门派"
  end

  if TreasureMap2:CheckPlayerTimes(pPlayer) == 0 then
    return 0, "参加次数过多"
  end

  if self:CheckPlayerCount(pPlayer) == 0 then
    return -1, "没有可用次数"
  end

  return 1
end

--领取今天的藏宝图次数
function TreasureMapEx:GetCount(pPlayer)
  -- 全局服返回
  if GLOBAL_AGENT then
    return
  end
  local pPlayer = pPlayer or me
  if self:Level2Star(pPlayer.nLevel) == -1 then
    return
  end
  self:ChangeData()
  local nNowWeek = Lib:GetLocalWeek()
  local nWeek = pPlayer.GetTask(self.TASK_GROUP, self.TASK_WEEK)
  if nWeek < nNowWeek then
    pPlayer.SetTask(self.TASK_GROUP, self.TASK_WEEK, nNowWeek)
    pPlayer.SetTask(self.TASK_GROUP, self.TASK_WEEK_COUNT, 0)
  end
  local nDay = pPlayer.GetTask(self.TASK_GROUP, self.TASK_DAY)
  local nToday = tonumber(GetLocalDate("%y%m%d"))
  if nDay >= nToday then
    return
  end
  local nCount = 2
  local nWeekCount = pPlayer.GetTask(self.TASK_GROUP, self.TASK_WEEK_COUNT)
  if nWeekCount >= 2 and pPlayer.nLevel > 69 then
    nCount = 1
  end
  pPlayer.SetTask(self.TASK_GROUP, self.TASK_WEEK_COUNT, nWeekCount + 1)
  pPlayer.SetTask(self.TASK_GROUP, self.TASK_DAY, nToday)
  local nPlayerCount = pPlayer.GetTask(self.TASK_GROUP, self.TASK_COUNT)
  if nPlayerCount + nCount > self.MAXCOUNT then
    nCount = self.MAXCOUNT - nPlayerCount
  end
  if nCount == 0 then
    pPlayer.Msg("你的藏宝图次数已达上限，请及时使用！")
    return
  end
  pPlayer.SetTask(self.TASK_GROUP, self.TASK_COUNT, nPlayerCount + nCount)
  pPlayer.Msg("你获得了本日藏宝图次数" .. nCount .. "次。你的藏宝图次数总数为" .. nPlayerCount + nCount .. "次。")
  if nPlayerCount + nCount == self.MAXCOUNT then
    pPlayer.Msg("你的藏宝图次数已达上限，请及时使用！")
  end
end

function TreasureMapEx:GetTreasure(szMapTypeName)
  if not self.tbMapInfo[szMapTypeName] then
    print("[ERR] GetTreasure", szMapTypeName)
    assert(false)
    return
  end
  return self.tbMapInfo[szMapTypeName]
end
--申请同步信息,包括了藏宝图和秘境
function TreasureMapEx:ApplyTreasuremapInfo(pPlayer)
  local nTreasureId, nStar, nCityMapId, nMijingMap = -1, -1, -1, -1
  local bIsRandom = 0
  if self.IsOpen == 0 then
    Dialog:Say("藏宝图系统异常。请联系GM。")
  end
  TreasureMap2:GetMapTempletList()
  if pPlayer.nTeamId > 0 then
    --藏宝图数据
    local tbTeamList = KTeam.GetTeamMemberList(pPlayer.nTeamId)
    local nCBTPlayerId = 0
    if TreasureMap2.MapTempletList.tbBelongList[tbTeamList[1]] then
      nCBTPlayerId = tbTeamList[1]
    elseif TreasureMap2.MapTempletList.tbBelongList[me.nId] then
      nCBTPlayerId = me.nId
    end
    if nCBTPlayerId ~= 0 then
      local tbData = TreasureMap2.MapTempletList.tbBelongList[nCBTPlayerId]
      nTreasureId = tbData[3] or -1
      nStar = tbData[4] or -1
      nCityMapId = tbData[1] or -1
      bIsRandom = tbData[5] or -1
    end
    --秘境数据
    local nMJPlayerId = 0
    local Fourfold = Task.FourfoldMap
    if Fourfold.MapTempletList.tbBelongList[tbTeamList[1]] then
      nMJPlayerId = tbTeamList[1]
    elseif Fourfold.MapTempletList.tbBelongList[me.nId] then
      nMJPlayerId = me.nId
    end
    if Fourfold.MapTempletList.tbBelongList[nMJPlayerId] then
      nMijingMap = Fourfold.MapTempletList.tbBelongList[nMJPlayerId][1] or -1
    end
  end
  local tbInstanceList = FightAfter:GetExpiryInstanceList(pPlayer)
  local nDeyuefang = #tbInstanceList
  pPlayer.CallClientScript({ "TreasureMap.TreasureMapEx:ApplyTreasuremapInfo_C", { nTreasureId, nStar, nCityMapId, nDeyuefang, bIsRandom, nMijingMap } })
end

--扣除次数
function TreasureMapEx:ConsumePlayerCount(pPlayer)
  local nPlayerCount = pPlayer.GetTask(self.TASK_GROUP, self.TASK_COUNT)
  pPlayer.SetTask(self.TASK_GROUP, self.TASK_COUNT, nPlayerCount - 1)
  pPlayer.Msg("已扣除藏宝图次数1次，你的藏宝图次数还有" .. (nPlayerCount - 1) .. "次。")
end

--旧数据转换
function TreasureMapEx:ChangeData()
  -- 全局服返回
  if GLOBAL_AGENT then
    return
  end
  if me.GetTask(self.TASK_GROUP, self.TASK_CHANGE) == 1 then
    return
  end
  local tbTask = { 4, 5, 6, 7, 8, 9 }
  --次数转换
  local nOldCommon = me.GetTask(TreasureMap2.TASK_GROUP, TreasureMap2.TASK_ID_COMMONTASK)
  local nAdd = 0
  if nOldCommon > 0 then
    nAdd = nOldCommon
    me.SetTask(TreasureMap2.TASK_GROUP, TreasureMap2.TASK_ID_COMMONTASK, 0)
  end
  for _, nTask in pairs(tbTask) do
    local nOld = me.GetTask(2203, nTask)
    if nOld > 0 then
      nAdd = nAdd + nOld
      me.SetTask(2203, nTask, 0)
    end
  end
  if nAdd > 0 then
    me.SetTask(self.TASK_GROUP, self.TASK_COUNT, nAdd)
    me.Msg("你的所有藏宝图次数已全部转换为通用次数。")
    me.Msg("你的藏宝图次数为" .. nAdd .. "次。")
  end
  XiakeDaily:MergeServer() --处理侠客任务，直接调用合服的接口
  me.SetTask(self.TASK_GROUP, self.TASK_CHANGE, 1)
end

PlayerEvent:RegisterOnLoginEvent(TreasureMap.TreasureMapEx.GetCount, TreasureMap.TreasureMapEx)
