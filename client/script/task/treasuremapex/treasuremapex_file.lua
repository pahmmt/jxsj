-- 文件名　：treasuremapEx_file.lua
-- 创建者　：LQY
-- 创建时间：2012-11-03 16:53:30
-- 说　　明：文件信息读取

Require("\\script\\task\\treasuremapex\\treasuremapex_def.lua")
Require("\\script\\task\\treasuremap2\\treasuremap2_def.lua")
local TreasureMapEx = TreasureMap.TreasureMapEx

--数据初始化
function TreasureMapEx:InitData()
  if self.IsOpen == 0 then
    return
  end
  self.IsOpen = 0
  --初始化副本信息表
  self.tbMapInfo = {}
  local tbMapInfoFile = Lib:LoadTabFile(self.MAPSINFO_FILE)
  if not tbMapInfoFile then
    print("TreasureMapEx Error!Load " .. self.MAPSINFO_FILE .. " failed!")
    return
  end
  self.tbType2Id = {} --TypeName到ID
  self.tbId2Type = {} --ID到TypeName
  table.remove(tbMapInfoFile, 1) --移除说明项
  for n, tbData in pairs(tbMapInfoFile) do
    --TypeName到ID
    self.tbType2Id[tbData.TypeName] = n
    --ID到TypeName
    self.tbId2Type[n] = tbData.TypeName
    self.tbMapInfo[tbData.TypeName] = {}
    local tbMapData = self.tbMapInfo[tbData.TypeName]
    tbMapData.nClosed = tonumber(tbData.Closed)
    tbMapData.szName = tbData.Name
    tbMapData.szTypeName = tbData.TypeName
    tbMapData.nTemplateMapId = tonumber(tbData.TemplateMapId)
    tbMapData.tbBirthPos = { tonumber(tbData.BirthPosX), tonumber(tbData.BirthPosY) }
    tbMapData.nBaseCount = tonumber(tbData.BaseCount)
    tbMapData.tbTimeRate = {}
    for n = 1, 4 do --通关加成
      local szCName = "TimeRate" .. n
      table.insert(tbMapData.tbTimeRate, { tonumber(tbData[szCName]) * 60, self.TIMERATE_VALUE[n] })
    end
    if tbMapData.nClosed ~= 1 then
      tbMapData.tbNpcInfo = self:LoadNpcFile(string.format(self.MAPNPCINFO, tbMapData.szTypeName))
      tbMapData.tbTrapInfo = self:LoadTrapFile(string.format(self.MAPTRAPINFO, tbMapData.szTypeName))
    end
  end

  ----一些额外的数据添加
  -- 剧情任务
  self.tbMapInfo["taozhugongyizhong"].tbTask = { 201, 301, "DB", "159" }
  self.tbMapInfo["damogucheng"].tbTask = { 202, 302, "DC", "15A" }
  self.tbMapInfo["wanhuagu"].tbTask = { 204, 304, "12D", "15C" }
  self.tbMapInfo["qianqionggongfuben"].tbTask = { 203, 303, "E0", "15B" }
  --师徒成就
  self.tbMapInfo["taozhugongyizhong"].nAchievementId = Achievement_ST.FUBEN_TAOZHUGONG
  self.tbMapInfo["damogucheng"].nAchievementId = Achievement_ST.FUBEN_DAMOGUCHENG
  self.tbMapInfo["wanhuagu"].nAchievementId = Achievement_ST.FUBEN_WANHUA
  self.tbMapInfo["qianqionggongfuben"].nAchievementId = Achievement_ST.FUBEN_QIANQIONG

  ---------------------
  --初始化阶梯信息
  self.tbRankTable = Lib:LoadTabFile(self.CONFIG_FILE)
  if not self.tbRankTable then
    print("TreasureMapEx Error!Load " .. self.CONFIG_FILE .. " failed!")
    return
  end
  table.remove(self.tbRankTable, 1) --移除说明项
  --初始化星级对应副本列表
  self.tbNpcLevel = {}
  self.tbStarMapTable = {}
  self.tbStarAward = {}
  for _, tbData in pairs(self.tbRankTable) do
    --星级对应怪物等级表
    self.tbNpcLevel[tonumber(tbData.Star)] = tonumber(tbData.Npclevel)

    self.tbStarMapTable[tonumber(tbData.Star)] = {}
    local tbMaps = Lib:LoadTabFile(tbData.MapList)
    if not tbMaps then
      print("TreasureMapEx Error!Load " .. tbData.MapList .. " failed!")
      return
    else
      table.remove(tbMaps, 1) --移除说明项
      for _, tbMapInfo in pairs(tbMaps) do
        if tonumber(tbMapInfo.Closed) ~= 1 and self.tbMapInfo[tbMapInfo.TypeName] and self.tbMapInfo[tbMapInfo.TypeName].nClosed ~= 1 then --关闭的副本不插入
          table.insert(self.tbStarMapTable[tonumber(tbData.Star)], tbMapInfo)
        end
      end
    end
    local tbAward = Lib:LoadTabFile(tbData.AwardCount)
    if not tbAward then
      print("TreasureMapEx Error!Load " .. tbData.AwardCount .. " failed!")
      return
    else
      self.tbStarAward[tonumber(tbData.Star)] = {}
      for _, tbAwardInfo in pairs(tbAward) do
        self.tbStarAward[tonumber(tbData.Star)][tonumber(tbAwardInfo.Grade)] = { tonumber(tbAwardInfo.Count), tbItem = {} }
        self.tbStarAward[tonumber(tbData.Star)][tonumber(tbAwardInfo.Grade)].tbItem = { tonumber(tbData.ItemG), tonumber(tbData.ItemD), tonumber(tbData.ItemP), tonumber(tbData.ItemL) }
      end
    end
  end
  self.IsOpen = 1
end

function TreasureMapEx:LoadNpcFile(szNpcFile)
  if MODULE_GAMECLIENT then
    return {}
  end
  --print(szNpcFile);
  local tbFile = Lib:LoadTabFile(szNpcFile)
  if not tbFile then
    print("TreasureMapEx Error! LoadNpcFile1", szNpcFile, debug.traceback())
  end
  local tbInstanceNpc = {}
  for _, tbData in ipairs(tbFile) do
    local tbInstanceInfo = {}
    tbInstanceInfo.nTemplateId = tonumber(tbData.TemplateId) or 0
    tbInstanceInfo.nNpcLevel = tbData.NpcLevel and tonumber(tbData.NpcLevel) or nil
    tbInstanceInfo.nNpcScore = tonumber(tbData.NpcScore) or 0
    tbInstanceInfo.szName = tbData.NpcName
    tbInstanceInfo.szTypeName = tbData.TypeName
    tbInstanceInfo.nManually = tonumber(tbData.Manually) or 0
    local nNpcCount = tonumber(tbData.NpcCount) or 0
    local nXPos = tonumber(tbData.XPos) or 0
    local nYPos = tonumber(tbData.YPos) or 0
    tbInstanceInfo.tbNpcPos = {}
    if nXPos ~= 0 and nYPos ~= 0 then
      table.insert(tbInstanceInfo.tbNpcPos, { math.floor(nXPos / 32), math.floor(nYPos / 32) })
      for i = 2, nNpcCount do
        table.insert(tbInstanceInfo.tbNpcPos, { math.floor(nXPos / 32), math.floor(nYPos / 32) })
      end
    end
    local szNpcPosFile = tbData.NpcPosFile

    if szNpcPosFile ~= "" then
      local tbPosFile = Lib:LoadTabFile(szNpcPosFile)
      if not tbPosFile then
        print("TreasureMapEx Error! LoadNpcFile2", szNpcPosFile)
      end

      for _, tbPos in ipairs(tbPosFile) do
        table.insert(tbInstanceInfo.tbNpcPos, { math.floor((tonumber(tbPos.TRAPX)) / 32), math.floor((tonumber(tbPos.TRAPY)) / 32) })
      end
    end
    if tbInstanceInfo.nNpcScore == 0 and tbData.NpcScore ~= "" and tbData.NpcScore ~= nil then
      local tbScoreFile = Lib:LoadTabFile(tbData.NpcScore)
      if not tbScoreFile then
        print("TreasureMapEx Error! LoadNpcFile3", tbData.NpcScor, tbData.NpcName)
      else
        tbInstanceInfo.tbNpcScore = {}
        for _, tbScoreData in pairs(tbScoreFile) do
          tbInstanceInfo.tbNpcScore[tonumber(tbScoreData.Star)] = tonumber(tbScoreData.Score)
        end
      end
    end

    if nNpcCount == 0 then
      tbInstanceInfo.nNpcCount = #tbInstanceInfo.tbNpcPos
    else
      tbInstanceInfo.nNpcCount = nNpcCount
    end

    table.insert(tbInstanceNpc, tbInstanceInfo)
  end
  return tbInstanceNpc
end

function TreasureMapEx:LoadTrapFile(szTrapFile)
  if MODULE_GAMECLIENT then
    return {}
  end
  local tbFile = Lib:LoadTabFile(szTrapFile)
  if not tbFile then
    print("TreasureMapEx Error! LoadTrapFile", szTrapFile)
  end

  local tbInstanceTrap = {}
  for _, tbData in ipairs(tbFile) do
    local szTrapName = tbData.TrapName
    local szTrapPosFile = tbData.TrapPosFile
    local tbTrapInfo = {}
    if szTrapPosFile ~= "" and szTrapPosFile ~= nil then
      local tbPosFile = Lib:LoadTabFile(szTrapPosFile)
      if not tbPosFile then
        print("TreasureMapEx Error! LoadTrapFile", szTrapPosFile)
      end

      for _, tbPos in ipairs(tbPosFile) do
        table.insert(tbTrapInfo, { math.floor((tonumber(tbPos.TRAPX)) / 32), math.floor((tonumber(tbPos.TRAPY)) / 32) })
        --			table.insert(tbTrapInfo,{tonumber(tbPos.TRAPX/32),tonumber(tbPos.TRAPY/32)});
      end
      if szTrapName == "" then
        print("TreasureMapEx Error! LoadTrapFile TRAPNAME IS NIL")
      end
      tbInstanceTrap[szTrapName] = tbTrapInfo
    end
  end

  return tbInstanceTrap
end
TreasureMapEx:InitData()

-----GS ONLY--------
if not MODULE_GAMESERVER then
  return
end

--初始副本表
if not TreasureMap2.tbDynMapList then
  TreasureMap2.tbDynMapList = {} --动态地图最多申请表
  TreasureMap2.tbDynMapList[0] = TreasureMap2.DYNMAP_LIMIT
  for nTreasureId, tbData in pairs(TreasureMapEx.tbMapInfo) do
    TreasureMap2.tbDynMapList[TreasureMapEx.tbType2Id[tbData.szTypeName]] = tbData.nBaseCount
    TreasureMap2.tbDynMapList[0] = TreasureMap2.tbDynMapList[0] - tbData.nBaseCount
  end
  if TreasureMap2.tbDynMapList[0] < 0 then
    print("[ERR],藏宝图所有副本申请数之和超出单台GS上限")
  end
end

--link地图
for _, tbData in pairs(TreasureMapEx.tbMapInfo) do
  local tbMapTemplet = Map:GetClass(tbData.nTemplateMapId)
  for szFnc in pairs(TreasureMap2.tbMap) do
    tbMapTemplet[szFnc] = TreasureMap2.tbMap[szFnc]
  end
end
