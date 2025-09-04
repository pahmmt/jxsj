-- 战役

if not MODULE_GC_SERVER then
  return
end
Battle.DBKEY_BATTLE = "BATTLE_%d_%d" -- 战役信息的数据库KEY
Battle.tbCurRoundDataAll = {} -- 各战役当前进行的战局信息
Battle.RANKTYPE = 2
Battle.RANKLISTNAME = "SongJinBattle"
Battle.ITOR = 1
Battle.RANKMEMBERTASK = 1
Battle.tbMapInfo = {}
Battle.tbSeqTimeFrameList = {
  [4] = "CloseSongJin1450",
  [7] = "CloseSongJin2050",
}

if 1 == IVER_g_nTwVersion then
  Battle.tbSeqTimeFrameList = {}
end

Battle.tbFixRule_ProtectTotem = {}

function Battle:_LoadMapInfo()
  local tbMapInfo = {}
  local tbData = Lib:LoadTabFile("\\setting\\battle\\songjin\\battlemap.txt")
  for _, tbRow in ipairs(tbData) do
    local nBattleLevel = tonumber(tbRow.BATTLE_LEVEL) or 0
    if nBattleLevel > 0 then
      local tbBattle = tbMapInfo[nBattleLevel]
      if not tbBattle then
        tbBattle = {}
        tbMapInfo[nBattleLevel] = tbBattle
      end
      local tbMapId = {}
      for i = 1, 3 do
        local nMapid = tonumber(tbRow["WORLD_MAP_ID" .. i])
        if nMapid then
          tbMapId[#tbMapId + 1] = nMapid
        end
      end
      local tbMapName = {}
      local szMapName = tostring(tbRow["BATTLE_MAP_NAME"])
      if szMapName and string.len(szMapName) > 0 then
        tbMapName[#tbMapName + 1] = szMapName
      end
      local tbMapRule = {}

      local nMapRule = tonumber(tbRow["BATTLE_RULE"])
      if nMapRule then
        tbMapRule[#tbMapRule + 1] = nMapRule
      end

      local nMapNpcNumType = tonumber(tbRow.NPC_NUM_TYPE) or 1

      local szStartTime = tbRow["START_FLAG"] or ""
      local szEndTime = tbRow["END_FLAG"] or ""

      local tbBattleInfo = {}
      tbBattleInfo.tbMapId = tbMapId
      tbBattleInfo.tbMapName = tbMapName
      tbBattleInfo.tbMapRule = tbMapRule
      tbBattleInfo.nMapNpcNumType = nMapNpcNumType
      tbBattleInfo.szStartTime = szStartTime
      tbBattleInfo.szEndTime = szEndTime
      tbBattle[#tbBattle + 1] = tbBattleInfo
      -- 把保护龙柱模式记录下来
      if tbMapRule[1] == 6 then
        self.tbFixRule_ProtectTotem[nBattleLevel] = tbBattleInfo
      end
    end
  end
  self.tbMapInfo = tbMapInfo
end

function Battle:GetSongjinBattleInfo(nBattleLevel)
  local tbLevelBattle = self.tbMapInfo[nBattleLevel]
  local tbRandomBattle = {}
  for _, tbBattleInfo in pairs(tbLevelBattle) do
    local szStartTime = tbBattleInfo.szStartTime
    local szEndTime = tbBattleInfo.szEndTime
    local nFlag = 1
    if szStartTime ~= "" then
      if TimeFrame:GetState(szStartTime) ~= 1 then
        nFlag = 0
      end
    end
    if szEndTime ~= "" then
      if TimeFrame:GetState(szEndTime) == 1 then
        nFlag = 0
      end
    end
    --体服只开启杀戮模式
    if EventManager.IVER_bOpenTiFu == 1 and tbBattleInfo.tbMapRule and tbBattleInfo.tbMapRule[1] ~= 1 then
      nFlag = 0
    end
    if 1 == nFlag then
      tbRandomBattle[#tbRandomBattle + 1] = tbBattleInfo
    end
  end
  if #tbRandomBattle <= 0 then
    return
  end
  local nRandom = MathRandom(#tbRandomBattle)
  return tbRandomBattle[nRandom]
end

-- 战局启动
function Battle:RoundStart_GC(dwBattleId, dwBattleLevel, nSeqNum)
  -- 通知GameServer执行战局启动操作
  if not self.tbMapInfo[dwBattleLevel] then
    Battle:DbgOut_GC("ScheduleSongJin", "没有此等级地图信息")
    return
  end

  local tbBattleInfo = self:GetSongjinBattleInfo(dwBattleLevel)

  if not tbBattleInfo then
    Battle:DbgOut_GC("ScheduleSongJin", "没有此等级此模式的地图信息")
    return
  end
  local tbWorldMapId = tbBattleInfo.tbMapId
  local szMapName = tbBattleInfo.tbMapName[1]
  local dwRuleType = tbBattleInfo.tbMapRule[1]
  local nMapNpcNumType = tbBattleInfo.nMapNpcNumType or 1
  GlobalExcute({ "Battle:RoundStart_GS", dwBattleId, dwBattleLevel, tbWorldMapId, szMapName, dwRuleType, nMapNpcNumType, nSeqNum })
  -- 显示战局启动提示
  self:_MsgNewRound(dwBattleLevel, szMapName)
end

-- 战局结束
function Battle:RoundEnd_GC(dwBattleId, dwBattleLevel, dwBattleResult, tbPlayerList)
  self:_MsgRoundResult(dwBattleLevel)
end

-- 显示分隔符
function Battle:_MsgSeparator()
  print("-------------------------------------------------------------------------------")
end

-- 显示战局启动提示
function Battle:_MsgNewRound(dwBattleLevel, szMapName, szExtraMsg)
  self:_MsgSeparator()
  print(string.format("[%s]\tBATTLE ROUND START", GetLocalDate("%Y-%m-%d %H:%M:%S")))
  print(string.format("tBattleLevel: %d\tMapName: %s", dwBattleLevel, szMapName))
  if szExtraMsg ~= nil then
    print(szExtraMsg)
  end
  self:_MsgSeparator()
end

-- 显示战局结束提示
function Battle:_MsgRoundResult(dwBattleLevel, szExtraMsg)
  self:_MsgSeparator()
  print(string.format("[%s]\tBATTLE ROUND END", GetLocalDate("%Y-%m-%d %H:%M:%S")))
  print(string.format("BattleLevel: %d", dwBattleLevel))
  if szExtraMsg ~= nil then
    print(szExtraMsg)
  end
  self:_MsgSeparator()
end

-- 调度宋金
function Battle:ScheduleSongJin(nSeqNum)
  if GLOBAL_AGENT then
    return
  end

  if self.nTestClose and self.nTestClose == 1 then
    print("测试开启，关闭自动宋金")
    return
  end

  local szTimeFrame = Battle.tbSeqTimeFrameList[nSeqNum]
  if szTimeFrame and TimeFrame:GetState(szTimeFrame) == 1 then
    print("时间轴到了，宋金本时间点不开宋金", nSeqNum)
    return 0
  end

  -- 随机使用新战场
  if MathRandom(100) <= NewBattle.nNewBattle_Rand then
    -- 使用新战场
    NewBattle:StartNewBattle_GC(1, nSeqNum)
    NewBattle:StartNewBattle_GC(2, nSeqNum)
    NewBattle:StartNewBattle_GC(3, nSeqNum)
    return
  end

  if EventManager.IVER_bOpenTiFu == 1 then
    --体服只开启后面两个等级
    for i = 2, 3 do
      Battle:RoundStart_GC(1, i, nSeqNum)
    end
    return
  end

  -- 启动高中低3级战役
  for i = 1, 3 do
    Battle:RoundStart_GC(1, i, nSeqNum)
  end
end

-- 跨服宋金
function Battle:GlobalSongJin(nSeqNum)
  if not GLOBAL_AGENT then
    return
  end

  Battle:RoundStart_GC(1, 2, nSeqNum)
end

function Battle:DbgOut_GC(szMode, ...)
  Dbg:Output("Battle", szMode, unpack(arg))
end

Battle:_LoadMapInfo()
