-- Map脚本类

-- 动态地图类型（与gc_core/kgc_mapdef.h的枚举对应）
Map.DYNMAP_TREASUREMAP = 1
Map.DYNMAP_CONSOLE = 2 --开关类动态地图

Map.MAPID_BASE_MAX = 29 -- 基础地图的Id最大值（新手村、门派、城市）

Map.MAP_TYPE_NEW = -1
Map.MAP_TYPE_CITY = -2
Map.MAP_TYPE_FACTION = -3
Map.MAP_TYPE_SAME1 = -4

Map.PK_TIPS_OPEN = 1

Map.MAP_TYPE = {
  ["new"] = Map.MAP_TYPE_NEW,
  ["l5"] = Map.MAP_TYPE_NEW,
  ["l15"] = Map.MAP_TYPE_NEW,
  ["city"] = Map.MAP_TYPE_CITY,
  ["faction"] = Map.MAP_TYPE_FACTION,
  ["s1"] = Map.MAP_TYPE_SAME1,
}

Map.MAP_AREA = {
  [Map.MAP_TYPE_NEW] = "new",
  [Map.MAP_TYPE_CITY] = "city",
  [Map.MAP_TYPE_FACTION] = "faction",
  [Map.MAP_TYPE_SAME1] = "s1",
}

Map.MAP_TYPE_NAME = {
  [Map.MAP_TYPE_NEW] = "新手村",
  [Map.MAP_TYPE_CITY] = "城市",
  [Map.MAP_TYPE_FACTION] = "门派",
  [Map.MAP_TYPE_SAME1] = "伏牛山军营",
}

--结构 tbDynamicForbiden[nMapId]["szClassName"] = 1 or nil
Map.tbDynamicForbiden = {}

Map.tbChuanSongMapInfo = {} -- 传送信息（分层次）
Map.tbAllBaseMap = {} -- 所有可传送到的点（不分层次）

function Map:Init()
  -- 开关函数
  self.tbMapIdList = {}
  self.tbSwitchs = {}

  -- Map基础模板，详细的在default.lua中定义
  self.tbMapBase = {}
  -- Trap基础类，详细的在default.lua中定义
  self.tbTrapBase = {}

  -- Map类库（每一个Map中含有Trap类库）
  self.tbClass = {}

  -- 地图连接表（从基础地图向外展开）	[nToMapId]	= {nFromMapId, nFromPosX, nFromPosY};
  self.tbMapLink = {}

  self.tbMapBackLink = {}

  self.tbMapType = {} -- 记录地图详细信息的table

  self.tbTypeMap = {} -- 按照类型的地图分类

  self.tbMapLinkRout = {}

  self.tbMapItemState = {} --地图状态,物品禁用表。
  --self.tbMapProperItem = {}; --地图专属物品对应表。
  self.tbForbidReviveMapType = {} --禁止原地重生类型地图。
  self.tbDynamicForbidRevive = {} --动态禁止复活
  self.tbDynamicForbidRemoteRevive = {} --动态禁止回城复活

  -- 载入地图间连接信息
  self:LoadTraffic()

  -- 初始化地图玩家计数器
  self.tbMapCount = {}

  --动态地图申请回调table
  self.DynMapCallBack = {}

  --地图分配表
  self.tbMapWorldsetList = {}

  self:LoadChuanSonMapInfo()

  if not MODULE_GAMECLIENT then
    -- 载入地图对应的玩家进入保护表
    self:LoadMapProtocted()
  end

  self:LoadMapIdList() --加载所有地图列表
  self:LoadMapWorldSet() --加载底图分配表
end

function Map:LoadMapIdList()
  local tbMapList = Lib:LoadTabFile("\\setting\\map\\maplist.txt")
  for i = 2, #tbMapList do
    local nMapId = tonumber(tbMapList[i].TemplateId) or 0
    if nMapId > 0 then
      self.tbMapIdList[nMapId] = { szMapName = tbMapList[i].MapName, szMapType = tbMapList[i].MapType, nMapLevel = tbMapList[i].MapLevel }
    end
  end
end

-- 载入地图间连接信息
function Map:LoadTraffic()
  local tbFileData = Lib:LoadTabFile("\\setting\\map\\transmit.txt")
  local tbMapTrans = {} -- 临时记录地图传送
  local tbMapNode = {} -- 标记图的数组
  for _, tbRow in pairs(tbFileData) do
    local nFromMapId = tonumber(tbRow.FromMapId)
    local nToMapId = tonumber(tbRow.ToMapId)
    if nFromMapId and nToMapId then
      -- 临时记录地图传送
      local tbFromMap = tbMapTrans[nFromMapId] or {}
      tbFromMap[nToMapId] = {
        nFromMapId,
        tonumber(tbRow.FromPosX) / 32, -- TODO: 尚未统一
        tonumber(tbRow.FromPosY) / 32,
      }
      tbMapTrans[nFromMapId] = tbFromMap

      if tbRow.Type == "trap" then
        -- 生成地图Trap点
        local tbMap = self:GetClass(nFromMapId)
        tbMap.tbTransmit[tbRow.Name] = {
          tonumber(tbRow.ToMapId),
          tonumber(tbRow.ToPosX) / 32,
          tonumber(tbRow.ToPosY) / 32,
          tbRow.ToFightState or "",
          tonumber(tbRow.BeProtected) or 0,
        }
      end
    end
  end

  self:LoadMapLevel()
  self:LoadMapItemState() --地图状态,物品禁用表
  self:RegisterMapForbidLocalRevive() --注册地图禁用原地重生

  local tbResultLink, tbResultBackLink = self:FindLink(tbMapTrans)
  -- 计算并保存地图连接信息
  self:CalcMapLink(tbMapTrans, tbResultLink, tbResultBackLink)
end

-- 加载等级地图文件
function Map:LoadMapLevel()
  local tbMapLevelFile = Lib:LoadTabFile("\\setting\\map\\mapid_level.txt")

  local tbMapLevel = {}
  local tbTypeMap = {}
  local szMapArea = ""
  local nLevel = -5

  for _, tbRow in pairs(tbMapLevelFile) do
    local szMapType = tbRow.MapType
    if szMapType == "new" then
      szMapArea = szMapType
    elseif szMapType == "city" then
      szMapArea = szMapType
    elseif szMapType == "faction" then
      szMapArea = szMapType
    elseif szMapType == "s1" then
      szMapArea = szMapType
    else
      nLevel = nLevel + 10
    end

    tbTypeMap[szMapType] = {}
    if not tbMapLevel[szMapArea] then
      tbMapLevel[szMapArea] = {}
    end
    for i = 1, 15 do
      local nMapId = tonumber(tbRow["MapId" .. i])
      if nMapId then
        table.insert(tbTypeMap[szMapType], nMapId)
        if not tbMapLevel[szMapArea][i] then
          tbMapLevel[szMapArea][i] = {}
        end
        local tbNodeInfo = {}
        tbNodeInfo.szMapArea = szMapArea
        tbNodeInfo.nMapId = nMapId
        if #tbMapLevel[szMapArea][i] <= 0 then -- 表示此时处理的是基础点
          tbNodeInfo.nBaseMapId = nMapId
        else
          tbNodeInfo.nBaseMapId = tbMapLevel[szMapArea][i][1].nBaseMapId
        end
        tbMapLevel[szMapArea][i][#tbMapLevel[szMapArea][i] + 1] = tbNodeInfo
        self.tbMapType[nMapId] = tbNodeInfo -- 地图信息包括地图属于那个区域
        self.tbMapType[nMapId].szMapType = szMapType -- 地图类型
        self.tbMapType[nMapId].nLevel = nLevel -- 地图等级,如果是那些非战斗或者是没有加入到表里的地图等级全是默认等级
      end
    end
  end

  self.tbMapLevel = tbMapLevel
  self.tbTypeMap = tbTypeMap
end

function Map:LoadChuanSonMapInfo()
  local tbMapInfo = Lib:LoadTabFile("\\setting\\map\\chuansongmapinfo.txt")

  local tbChuanSongMapInfo = {
    tbMapIndex = {},
    tbSubMap = {},
    tbMapList = {},
  }
  for _, tbRow in ipairs(tbMapInfo) do
    local szType = tbRow["MAP_CLASS"]
    local tbType = Lib:SplitStr(szType, "\\")
    local tbTemp = tbChuanSongMapInfo
    for _, szSubType in ipairs(tbType) do
      local nIndex = tbTemp.tbMapIndex[szSubType]
      if not nIndex then
        nIndex = #tbTemp.tbSubMap + 1
        tbTemp.tbSubMap[nIndex] = {
          szSubName = szSubType,
          tbMapIndex = {},
          tbSubMap = {},
          tbMapList = {},
        }
        tbTemp.tbMapIndex[szSubType] = nIndex
      end
      tbTemp = tbTemp.tbSubMap[nIndex]
    end
    local tbMapInfo = {
      szType = szType,
      szName = tbRow["MAP_INFO"],
      nMapId = tonumber(tbRow["MAP_ID"]),
      nX = tonumber(tbRow["MAP_X"]),
      nY = tonumber(tbRow["MAP_Y"]),
      nFightsSate = tonumber(tbRow["TO_FIGHTSTATE"]),
    }
    tbTemp.tbMapList[#tbTemp.tbMapList + 1] = tbMapInfo
    if not self.tbAllBaseMap[tbMapInfo.nMapId] then -- 暂不处理同地图ID对应多点的情况
      self.tbAllBaseMap[tbMapInfo.nMapId] = tbMapInfo
    end
  end

  self.tbChuanSongMapInfo = tbChuanSongMapInfo
end

-- 构建初始连通图，初始图中包括所有的战斗地图，这些都是从mapid_level里填的
function Map:FindLink(tbMapTrans)
  local tbMapLevel = self.tbMapLevel
  local tbMapLink = {}
  local tbMapBackLink = {}
  local tbMapResult = {}
  local tbMapBackResult = {}
  local tbNodeFlag = {} -- 遍历图的时候作为点是否已经经过的判断
  local nNewNode = 0

  for szArea, tbMapArea in pairs(tbMapLevel) do -- 遍历区域
    for n, tbMap in pairs(tbMapArea) do -- 遍历寻找基础区域
      if #tbMap > 0 then
        local nId = tbMap[1].nMapId
        tbMapLink[nId] = false
        tbMapBackLink[nId] = {}
        tbMapBackLink[nId].tbFromPos = {}
        tbMapBackLink[nId].nToMapId = -1
        for nIndex = 1, #tbMap do
          nNewNode = nNewNode + 1
          tbMapResult[nNewNode] = tbMap[nIndex].nMapId
          tbMapBackResult[nNewNode] = tbMap[nIndex].nMapId
          tbNodeFlag[tbMap[nIndex].nMapId] = 0
        end
        for i = #tbMap, 1, -1 do -- 从后往前搜，将路连起来
          if tbNodeFlag[tbMap[i].nMapId] == 0 then
            local nNowIndex = i
            local nNextIndex = nNowIndex - 1 -- 等级小地图
            while true do
              if nNextIndex <= 0 then
                break
              end
              local nNowMapId = tbMap[nNowIndex].nMapId -- 等级大地图
              if tbNodeFlag[nNowMapId] == 1 then -- 已经寻路过了就不要找了
                break
              end

              local nNextMapId = tbMap[nNextIndex].nMapId
              -- 去的路 -- 假设图与图之间是双向连通的
              if tbMapTrans[nNextMapId] and tbMapTrans[nNextMapId][nNowMapId] then -- 连通性
                if tbMapLink[nNowMapId] == nil then -- 第一次发现可以到达此地图
                  -- 记录此地图的最近来源 -- 一定先从小图到大图
                  tbMapLink[nNowMapId] = tbMapTrans[nNextMapId][nNowMapId]
                end
                -- 回路--TODO:假设图是双向连通的
                if tbMapBackLink[nNowMapId] == nil then
                  if tbMapTrans[nNowMapId] and tbMapTrans[nNowMapId][nNextMapId] then
                    tbMapBackLink[nNowMapId] = {}
                    tbMapBackLink[nNowMapId].tbFromPos = tbMapTrans[nNowMapId][nNextMapId]
                    tbMapBackLink[nNowMapId].nToMapId = nNextMapId
                  end
                end
                tbNodeFlag[nNowMapId] = 1
                nNowIndex = nNextIndex
                nNextIndex = nNowIndex
              end
              nNextIndex = nNextIndex - 1
            end
          end
        end
      end
    end
  end

  self.tbMapLink = tbMapLink
  self.tbMapBackLink = tbMapBackLink
  return tbMapResult, tbMapBackResult
end

-- 计算并保存地图连接信息
function Map:CalcMapLink(tbMapTrans, tbResultLink, tbResultBackLink)
  local tbMapLink = self.tbMapLink
  local tbMapBackLink = self.tbMapBackLink

  local tbNewMap = {} -- 新地图队列
  local nNewMapMax = 0

  tbNewMap = tbResultLink
  nNewMapMax = #tbResultLink
  -- 由基础地图开始生成连接
  for _, nNewMapId in ipairs(tbNewMap) do -- 逐个遍历队列
    local tbFromMap = tbMapTrans[nNewMapId] or {} -- 此地图作为起点的全部传送
    for nToMapId, tbFromPos in pairs(tbFromMap) do
      if tbMapLink[nToMapId] == nil then -- 第一次发现可以到达此地图
        -- 记录此地图的最近来源
        tbMapLink[nToMapId] = tbFromPos

        -- 加入新地图队列
        nNewMapMax = nNewMapMax + 1
        tbNewMap[nNewMapMax] = nToMapId
        -- 将未归类的地图归类
        if tbFromPos[1] then
          if self.tbMapType[tbFromPos[1]] and not self.tbMapType[nToMapId] then
            local tbNodeInfo = {}
            tbNodeInfo.szMapArea = self.tbMapType[tbFromPos[1]].szMapArea
            tbNodeInfo.nMapId = tbFromPos[1]
            tbNodeInfo.nBaseMapId = self.tbMapType[tbFromPos[1]].nBaseMapId
            self.tbMapType[nToMapId] = tbNodeInfo
          end
        end
      end
    end
  end

  tbNewMap = tbResultBackLink
  nNewMapMax = #tbResultBackLink
  -- 反着走
  for _, nNewMapId in ipairs(tbNewMap) do -- 逐个遍历队列
    local tbFromMap = tbMapTrans[nNewMapId] or {} -- 此地图作为起点的全部传送
    for nFromMapId, tbFromPos in pairs(tbFromMap) do
      if tbMapBackLink[nFromMapId] == nil then -- 第一次发现可以到达此地图
        local tbFMap = tbMapTrans[nFromMapId]
        if tbFMap then
          if tbFMap[nNewMapId] then -- 回来的路径存在
            tbMapBackLink[nFromMapId] = {}
            tbMapBackLink[nFromMapId].tbFromPos = tbFMap[nNewMapId]
            tbMapBackLink[nFromMapId].nToMapId = nNewMapId
          else -- 没有回来的路径寻找其他路径
            for key, tbValue in pairs(tbFMap) do
              if tbValue then
                tbMapBackLink[nFromMapId] = {}
                tbMapBackLink[nFromMapId].tbFromPos = tbValue
                tbMapBackLink[nFromMapId].nToMapId = key
                break
              end
            end
            if not tbMapBackLink[nFromMapId] then
              tbMapBackLink[nFromMapId] = {}
              tbMapBackLink[nFromMapId].tbFromPos = {}
              tbMapBackLink[nFromMapId].nToMapId = -1
            end
          end
        end
        nNewMapMax = nNewMapMax + 1
        tbNewMap[nNewMapMax] = nFromMapId
      end
    end
  end
end

-- 取得特定ID的Map类
function Map:GetClass(nMapId, bNotCreate)
  local tbClass = self.tbClass[nMapId]
  -- 如果没有bNotCreate，当找不到指定模板时会自动建立新模板
  if not tbClass and bNotCreate ~= 1 then
    -- 新模板从基础模板派生
    tbClass = Lib:NewClass(self.tbMapBase)
    tbClass.nMapId = nMapId

    tbClass.tbTransmit = {}
    -- 加入到模板库里面
    self.tbClass[nMapId] = tbClass
  end
  return tbClass
end

-- 获取从基础地图到达特定地图的最短路线
--	nFromMapId	起点地图Id，可填nil表式从基础地图开始。
--		（路径从nToMapId反向追溯到nFromMapId为止，一直不能到达nFromMapId才会搜索至基础地图）
--	nToMapId	要寻找路线的目标地图Id。
function Map:GetMapRoute(nFromMapId, nToMapId)
  if nToMapId == nFromMapId then -- 已经在了
    return {} -- 返回空路径
  end

  local tbMapLink = self.tbMapLink
  local tbMapRoute = {}
  local nFindTimes = 0

  local tbFromPos = tbMapLink[nToMapId] -- 特定地图的上一个来源地图坐标
  while tbFromPos do -- 找不到此地图信息或者已经找到了基础地图时结束
    -- 防止不可预知问题导致死循环
    nFindTimes = nFindTimes + 1
    assert(nFindTimes < 100)

    table.insert(tbMapRoute, 1, tbFromPos) -- 插入此来源地图坐标

    if tbFromPos[1] == nFromMapId then -- 已经到达起点地图了
      break -- 停止追溯
    end

    tbFromPos = tbMapLink[tbFromPos[1]] -- 此来源地图的再上一个来源地图坐标
  end

  return tbMapRoute
end

function Map:GetMapBackRoute(nFromMapId, nToMapId)
  if nToMapId == nFromMapId then -- 已经在了
    return {} -- 返回空路径
  end

  local tbMapLink = self.tbMapBackLink
  local tbMapRoute = {}
  local nFindTimes = 0

  if not tbMapLink[nFromMapId] then
    return tbMapRoute
  end

  local tbFromPos = tbMapLink[nFromMapId].tbFromPos -- 特定地图的上一个来源地图坐标
  local nNextMapId = tbMapLink[nFromMapId].nToMapId
  while tbFromPos do -- 找不到此地图信息或者已经找到了基础地图时结束
    -- 防止不可预知问题导致死循环
    nFindTimes = nFindTimes + 1
    assert(nFindTimes < 100)

    if nNextMapId == -1 or not tbFromPos[1] then -- 表示到了源地图
      break
    end

    local tbNodeInfo = {}
    tbNodeInfo.tbFromPos = tbFromPos
    tbNodeInfo.nToMapId = nNextMapId

    tbMapRoute[#tbMapRoute + 1] = tbNodeInfo

    if nNextMapId == nToMapId then -- 已经到达起点地图了
      break -- 停止追溯
    end

    tbFromPos = tbMapLink[nNextMapId].tbFromPos -- 此来源地图的再上一个来源地图坐标
    nNextMapId = tbMapLink[nNextMapId].nToMapId
  end

  return tbMapRoute
end

function Map:GetMapInfo(nMapId)
  return self.tbMapType[nMapId]
end

-- 解析这个文字，判断是具体的地图id，还是新手村标示
function Map:AnalysisMapString(szMapInfo)
  local nMapId = 0
  local nMyMapId = me.GetMapTemplateId()
  if self.MAP_TYPE[szMapInfo] then -- 在列举的这些类型里
    nMapId = self:GetMapIdFromArea(szMapInfo, nMyMapId)
  else
    nMapId = tonumber(szMapInfo) --  如果在类型表中找不到这个类型，说明可能是数字直接转
    assert(nMapId) -- 字符串不是数字，转换出错
  end
  return nMapId
end

function Map:GetMapIdFromArea(szMapInfo, nMyMapId)
  local nMapId = self.MAP_TYPE[szMapInfo]
  local tbMapInfo = self.tbMapType[nMyMapId]
  if not tbMapInfo then
    return nMapId
  end
  if self.MAP_AREA[nMapId] ~= tbMapInfo.szMapArea then
    return nMapId
  end
  local tbMapArea = self.tbMapLevel[tbMapInfo.szMapArea]
  assert(tbMapArea) -- 不存在这个区域
  assert(tbMapInfo.nBaseMapId) -- 不存在基础地图id
  for _, tbValue in pairs(tbMapArea) do
    if tbValue and tbValue[1].nMapId == tbMapInfo.nBaseMapId then
      nMapId = tbMapInfo.nBaseMapId
      for _, tbMap in ipairs(tbValue) do
        if tbMap and tbMap.szMapType == szMapInfo then
          nMapId = tbMap.nMapId
          break
        end
      end
      break
    end
  end
  return nMapId
end

function Map:GetMapIdFromType(tbMapInfo)
  local nMapId = 0
  local tbMapArea = self.tbMapLevel[tbMapInfo.szMapArea] -- 找到地图所在区域
  -- maptype如果不存在的话表示，表里没有存在这个类型，那么直接让他回基础点,现在这个只支持新手村,其他的需要确切的地点
  if tbMapInfo.szMapType then
    for _, tbMap in pairs(tbMapArea) do
      if tbMap[1] and tbMap[1].nMapId == tbMapInfo.nBaseMapId then -- 找到基础地图的那一区域
        -- 找那个类型一致的地图
        for _, tbValue in pairs(tbMap[1]) do
          local nNowMapId = tbValue.nMapId
          if self.tbMapType[nNowMapId].szMapType == tbMapInfo.szMapType then
          end
        end
      end
    end
  else
    nMapId = tbMapInfo.nBaseMapId
  end
end

function Map:_Print(tbMapLevel)
  for key, value in pairs(tbMapLevel) do
    print("key = ", key)
    for n, v in pairs(value) do
      print("    n, #v= ", n, #v)
      for i, va in pairs(v) do
        print("          #va = ", #va)
        print("          i, va.nBaseMapId, va.szMapArea, va.nMapId = ", i, va.nBaseMapId, va.szMapArea, va.nMapId)
      end
    end
  end
end

--加载地图状态表和物品地图限制表
function Map:LoadMapItemState()
  local tbMapItem = Lib:LoadTabFile("\\setting\\map\\forbiddenitem_mapstate.txt")
  if tbMapItem == nil then
    return 0
  end
  for nItem = 2, #tbMapItem do
    local szMapType = tbMapItem[nItem].MapType
    if szMapType ~= nil then
      self.tbMapItemState[szMapType] = {}
      local tbTemp = {}
      tbTemp.tbForbiddenUse = Lib:SplitStr(tbMapItem[nItem].ForbiddenUse, "|")
      tbTemp.tbForbiddenCallIn = Lib:SplitStr(tbMapItem[nItem].ForbiddenCallIn, "|")
      tbTemp.tbForbiddenCallOut = Lib:SplitStr(tbMapItem[nItem].ForbiddenCallOut, "|")
      for szClass, tbClass in pairs(tbTemp) do
        self.tbMapItemState[szMapType][szClass] = {}
        for ni, szClassName in pairs(tbClass) do
          if szClassName ~= "" then
            self.tbMapItemState[szMapType][szClass][szClassName] = 1
          end
        end
      end

      --地图状态
      local szSwitch = tbMapItem[nItem].OnSwitch
      if szSwitch ~= nil and szSwitch ~= "" then
        self.tbMapItemState[szMapType].szSwitch = szSwitch
      end

      self.tbMapItemState[szMapType].szInfo = tbMapItem[nItem].Info
    end
  end
end

-- 注册禁止使用原地复活的地图
function Map:RegisterMapForbidLocalRevive()
  for szMapType, tbClass in pairs(self.tbMapItemState) do
    for szItemClass in pairs(tbClass.tbForbiddenUse) do
      if szItemClass == "revive" or szItemClass == "ALL_ITEM" then
        self.tbForbidReviveMapType[szMapType] = 1
      end
    end
  end
end

-- 动态单一地图ID禁止复活类型 bItemRevive为0禁止道具复活  bSkillRevive为0禁止技能复活
function Map:RegisterMapForbidReviveType(nMapId, bItemRevive, bSkillRevive, szMsg)
  self.tbDynamicForbidRevive[nMapId] = { bItemRevive = bItemRevive, bSkillRevive = bSkillRevive, szMsg = szMsg }
end
function Map:UnRegisterMapForbidReviveType(nMapId)
  self.tbDynamicForbidRevive[nMapId] = nil
end

-- 动态注册该地图是否能回城复活
function Map:RegisterMapForbidRemoteRevive(nMapId, bCanRemoteRevive, szError)
  self.tbDynamicForbidRemoteRevive[nMapId] = { bRemoteRevive = bCanRemoteRevive, szMsg = szError }
end

-- 动态注册该地图是否能回城复活
function Map:UnRegisterMapForbidRemoteRevive(nMapId)
  self.tbDynamicForbidRemoteRevive[nMapId] = nil
end

--是否能回城复活
function Map:CanBeRemoteRevive(nMapId)
  local szDefault = "此地不允许暂时不允许回城复活"
  if self.tbDynamicForbidRemoteRevive[nMapId] then
    if self.tbDynamicForbidRemoteRevive[nMapId].bRemoteRevive and self.tbDynamicForbidRemoteRevive[nMapId].bRemoteRevive == 0 then
      return 0, self.tbDynamicForbidRemoteRevive[nMapId].szMsg or szDefault
    end
  end
  return 1
end

-- 判断是否允许被复活 nReviveType 为1道具复活； 为2技能复活
function Map:CanBeRevived(nMapId, nReviveType)
  local szDefault = "此地不允许使用治疗技能复活！"
  if self.tbDynamicForbidRevive[nMapId] then
    if nReviveType == 1 and self.tbDynamicForbidRevive[nMapId].bItemRevive == 0 then
      return 0, self.tbDynamicForbidRevive[nMapId].szMsg or szDefault
    elseif nReviveType == 2 and self.tbDynamicForbidRevive[nMapId].bSkillRevive == 0 then
      return 0, self.tbDynamicForbidRevive[nMapId].szMsg or szDefault
    end
  end
  local szMapType = GetMapType(me.nMapId)
  if Map.tbForbidReviveMapType and Map.tbForbidReviveMapType[szMapType] then
    return 0, szDefault
  end
  return 1
end

--获得地图状态
function Map:GetMapStateParam(nMapId)
  --根据地图状态开关
  --返回地图状态开关
  local szMapType = GetMapType(nMapId)
  if szMapType ~= nil and self.tbMapItemState[szMapType] ~= nil then
    if self.tbMapItemState[szMapType].szSwitch ~= nil and self.tbMapItemState[szMapType].szSwitch ~= "" then
      return self.tbMapItemState[szMapType].szSwitch
    end
  end
  return ""
end

-- 根据参数，选择检查函数
function Map:PraseParam(szParam)
  if szParam == nil then
    return {}
  end
  local tbSwitchExec = {}
  local tbFunName = Lib:SplitStr(szParam, "|")
  for _, szFunName in pairs(tbFunName) do
    local fn = Map.tbSwitchs[szFunName]
    if not fn then
      if szFunName ~= "" then
        self:WriteLog(Dbg.LOG_ERROR, "ErrorWordParam: 未定义执行函数:", szFunName, SubWorld)
      end
    else
      table.insert(tbSwitchExec, fn)
    end
  end
  return tbSwitchExec
end
---------------- 以下供系统触发 -------------------
function Map:__GetReturnVillagePos()
  local tbNpc = Npc:GetClass("chefu")
  for _, tbMapInfo in ipairs(tbNpc.tbCountry) do
    if SubWorldID2Idx(tbMapInfo.nId) >= 0 then
      local nRandomPos = MathRandom(1, #tbMapInfo.tbSect)
      return tbMapInfo.nId, tbMapInfo.tbSect[nRandomPos][1], tbMapInfo.tbSect[nRandomPos][2]
    end
  end
  return 5, 1580, 3029
end

--OnLogin前调用
-- 玩家进入
function Map:OnEnter(nMapId, szParam)
  --如果上次回程点是mini村，并且完成了教育主线，将回程点设置为新手村
  local nLastRevMapId = me.GetRevivePos() or 0
  if nLastRevMapId and GetMapType(nLastRevMapId) == "village_mini" and me.GetTask(1025, 32) == 2 and GetMapType(nMapId) ~= "village_mini" then
    local nNewMapId = self:__GetReturnVillagePos()
    me.SetRevivePos(nNewMapId, 1)
  end

  local tbMap = self:GetClass(nMapId)
  if not tbMap.tbSwitchExec then
    tbMap.tbSwitchExec = self:PraseParam(self:GetMapStateParam(nMapId))
  end
  tbMap:OnEnterState(tbMap.tbSwitchExec)

  -- 进入地图保护时间
  if self.tbMapProtocted and self.tbMapProtocted[tostring(nMapId)] and self.tbMapProtocted[tostring(nMapId)] ~= 0 then
    Player:AddProtectedState(me, 5)
  end
  if Looker:IsLooker(me) <= 0 then
    tbMap:ExcuteEnterFun() -- 执行动态进入地图回调
    tbMap:OnEnterConsole() --开关类进入地图回调
    tbMap:OnEnter()
    if self.PK_TIPS_OPEN == 1 and (GetMapType(nMapId) == "fight") then
      local szMapName = GetMapNameFormId(nMapId)
      me.Msg(string.format("你已进入%s，该地图可以任意PK。", szMapName))
      Dialog:SendBlackBoardMsg(me, "该地图可以任意PK。")
    end
  end
  self:DbgOut("OnEnter:", me.szName, szParam)

  -- 该地图玩家数量加1
  if not self.tbMapCount[nMapId] then
    self.tbMapCount[nMapId] = 0
  end
  self.tbMapCount[nMapId] = self.tbMapCount[nMapId] + 1

  if me.GetCamp() == 6 then -- GM阵营
    GM.tbGMRole:OnEnterMap(nMapId)
  end

  -- 成就，进入指定地图
  Achievement:OnEnterMap(me, nMapId)
end

-- 玩家离开
function Map:OnLeave(nMapId, szParam)
  -- 在线托管的时候地图转换直接退出
  local nOnlineExpState = Player.tbOnlineExp:GetOnlineState(me)
  if 1 == nOnlineExpState then
    Player.tbOnlineExp:CloseOnlineExp()
  end

  local tbMap = self:GetClass(nMapId)
  if not tbMap.tbSwitchExec then
    tbMap.tbSwitchExec = self:PraseParam(self:GetMapStateParam(nMapId))
  end
  tbMap:OnLeaveState(tbMap.tbSwitchExec)
  if Looker:IsLooker(me) > 0 then
    Looker:MapOnLeave(nMapId)
  else
    tbMap:ExcuteLeaveFun() -- 执行动态离开地图回调
    tbMap:OnLeaveConsole() -- 开关类离开地图回调
    tbMap:OnLeave()
  end
  self:DbgOut("OnLeave:", me.szName, szParam)

  -- 该地图玩家数量减1
  if not self.tbMapCount[nMapId] then
    self.tbMapCount[nMapId] = 0
  end
  self.tbMapCount[nMapId] = self.tbMapCount[nMapId] - 1
  if self.tbMapCount[nMapId] < 0 then
    self.tbMapCount[nMapId] = 0
  end
end

--OnLogin后调用
function Map:OnEnter2(nMapId)
  local tbMap = self:GetClass(nMapId)

  --如果是观战模式,走自己的统一逻辑
  if Looker:IsLooker(me) > 0 then
    Looker:MapOnEnter(nMapId)
    return 0
  end

  tbMap:OnEnter2()
  Npc.tbFollowPartner:FollowPartnerOnEnter()
end

-- 玩家接触Trap点
function Map:OnPlayerTrap(nMapId, szClassName)
  local tbMap = self:GetClass(nMapId)
  tbMap:OnPlayerTrap(szClassName)
  --宠物跟玩家跳trap点
  Npc.tbFollowPartner:FollowPartnerOnTrap()
end

-- Npc接触Trap点
function Map:OnNpcTrap(nMapId, szClassName)
  --宠物不受npc Trap点影响
  if Npc.tbFollowPartner:CheckIsFollowPartner() == 1 then
    return
  end
  local tbMap = self:GetClass(nMapId)
  tbMap:OnNpcTrap(szClassName)
end

-- 本Gameserver申请的动态地图加载完的回调
-- nMapType：动态地图类型
-- nParam：申请时的参数
-- nMapId：已加载的地图Id
-- nMapCopy：地图模板Id
-- ps:在该函数手动填写回调已废弃，请使用新的副本申请机制Map:LoadDynMap(nMapType, nMapId, tbCallBack, bOccupy)
-- by sunduoliang
function Map:OnLoadDynMap(nMapType, nParam, nMapId, nMapCopy)
  self:GetClass(nMapCopy):OnDyLoad(nMapId)
  if self.DynMapCallBack[nMapType] and self.DynMapCallBack[nMapType][nMapCopy] and self.DynMapCallBack[nMapType][nMapCopy][nParam] then
    local tbCallBack = self.DynMapCallBack[nMapType][nMapCopy][nParam]
    table.insert(tbCallBack, nMapId)
    Lib:CallBack(tbCallBack)
    self.DynMapCallBack[nMapType][nMapCopy][nParam] = nil
    return 1
  end

  --以下方式不允许再使用，保留旧有方式。
  if nMapType == Map.DYNMAP_CONSOLE then
    Console:OnLoadMapFinish(nMapId, nParam)
  else
    if nMapCopy == KinGame.MAP_TEMPLATE_ID then
      KinGame:OnLoadMapFinish(nMapId, nParam)
    elseif nMapCopy == KinGame2.MAP_TEMPLATE_ID then
      KinGame2:OnLoadMapFinish(nMapId, nParam)
    elseif Task.tbArmyCampInstancingManager:IsArmyCampInstancingMap(nMapCopy) == 1 then
      Task:OnLoadMapFinish(nMapId, nMapCopy, nParam)
    elseif nMapCopy == Task.FourfoldMap.MAP_TEMPLATE_ID then
      Task.FourfoldMap:OnLoadMapFinish(nMapId, nParam)
    elseif nMapCopy == Esport.DEF_MAP_TEMPLATE_ID then
      Esport:OnLoadMapFinish(nMapId, nParam)
    else
      TreasureMap.InstancingMgr:OnLoadMapFinish(nMapId, nMapCopy, nParam)
    end
  end
end

-- 副本申请通用接口
-- nMapType动态地图类型（程序默认1类型为不在bishop注册申请，只自己服务器使用）
-- nMapId地图模版Id
-- tbCallBack回调table(申请成功返还的副本Id做为回调函数最后一个参数)
-- bOccupy 是否为永久地图Id（默认为否）
-- by sunduoliang
function Map:LoadDynMap(nMapType, nMapId, tbCallBack, bOccupy)
  if not tbCallBack then
    return 0
  end
  self.DynMapCallBack[nMapType] = self.DynMapCallBack[nMapType] or {}
  self.DynMapCallBack[nMapType][nMapId] = self.DynMapCallBack[nMapType][nMapId] or {}
  local nParam = #self.DynMapCallBack[nMapType][nMapId] + 1
  self.DynMapCallBack[nMapType][nMapId][nParam] = tbCallBack
  return LoadDynMap(nMapType, nMapId, nParam, bOccupy or 0)
end

-- 把各地图当前人数进行统计
function Map:LogMapPlayerCount_GS()
  local szCurTime = GetLocalDate("%Y%m%d%H%M")
  for i, v in pairs(self.tbMapCount) do
    KStatLog.ModifyAdd("playercount", szCurTime .. ":MapID:" .. tostring(i), "该地图玩家数量", v)
  end
end

--载入地图对应的玩家进入保护表
function Map:LoadMapProtocted()
  local tbFileData = Lib:LoadTabFile("\\setting\\map\\map_protected.txt")
  local tbMapProtocted = {}
  for _, tbRow in pairs(tbFileData) do
    if tbRow then
      tbMapProtocted[tbRow.MapId] = tonumber(tbRow.BeProtected) or 0
    end
  end
  self.tbMapProtocted = tbMapProtocted
end

--调用GC，注册地图禁用
function Map:RegisterForbiden(nMapId, szItemClass)
  GCExcute({ "Map:GCRegisterForbiden", nMapId, szItemClass })
end

--调用GC，反注册地图禁用
function Map:UnRegisterForbiden(nMapId, szItemClass)
  GCExcute({ "Map:GCUnregisterForbiden", nMapId, szItemClass })
end

--调用GC，同步地图禁用表
function Map:UpdateForbidenInfo()
  GCExcute({ "Map:GCUpdateForbidenInfo" })
end

--由GC调用，注册地图禁用，成功返回1
function Map:OnRegisterForbiden(nMapId, szItemClass)
  if Map.tbDynamicForbiden[nMapId] == nil then
    Map.tbDynamicForbiden[nMapId] = {}
  end
  Map.tbDynamicForbiden[nMapId][szItemClass] = 1
  return 1
end

--由GC调用，反注册地图禁用，成功返回1
function Map:OnUnregisterForbiden(nMapId, szItemClass)
  if Map.tbDynamicForbiden[nMapId] == nil then
    return 0
  end
  if Map.tbDynamicForbiden[nMapId][szItemClass] == nil then
    return 0
  end
  Map.tbDynamicForbiden[nMapId][szItemClass] = nil
  return 1
end

--当GS启动时，从GC同步地图禁用表
function Map:OnUpdateForbidenInfo(tbForbiden)
  Map.tbDynamicForbiden = tbForbiden
end

if MODULE_GAMESERVER then
  --注册GS启动事件，同步地图禁用表
  if ServerEvent.RegisterServerStartFunc then
    ServerEvent:RegisterServerStartFunc(Map.UpdateForbidenInfo)
  end
end

function Map:CheckTagServerPlayerCount(nMapId)
  if IsMapLoaded(nMapId) == 1 then
    return 1
  end
  local tbMap = GetLocalServerMapInfo() -- 本地服务器地图分配状况
  local nServerId = tbMap[nMapId] -- 没加载
  if not nServerId then
    return -1, "前方道路不通!"
  end
  local tbServerPlayerCount = GetServerPlayerCount()
  if not tbServerPlayerCount[nServerId] or tbServerPlayerCount[nServerId] < KPlayer.GetMaxPlayerCount() then
    return 1
  end
  return 0, "前方人满为患。"
end

function Map:CheckGlobalPlayerCount(nMapId)
  if GLOBAL_AGENT then -- 自身就是全局服务器，不进行负载检测
    return 1
  end
  local tbMap = GetGlobalServerMapInfo() -- 全局服务器地图分配状况
  local nServerId = tbMap[nMapId] -- 没加载
  if not nServerId then
    return -1
  end
  local tbGlobalPlayerCount = GetGlobalPlayerCount()
  if not tbGlobalPlayerCount[nServerId] or tbGlobalPlayerCount[nServerId] < KPlayer.GetMaxPlayerCount() then
    return 1
  end
  return 0
end

function Map:LoadMapWorldSet()
  local tbMapWorldsetList = Lib:LoadTabFile("\\setting\\worldset.txt")

  for _, tbMapSetInfo in ipairs(tbMapWorldsetList) do
    local nMapId = tonumber(tbMapSetInfo.MAP_ID) or 0
    if self.tbMapWorldsetList[nMapId] then
      --底图重复了
      print("trackback: setting\\worldset.txt 地图Id重复！！！", nMapId)
    end
    self.tbMapWorldsetList[nMapId] = {}
    for i = 1, 16 do
      self.tbMapWorldsetList[nMapId][i] = tonumber(tbMapSetInfo["GAMESVR_SET_" .. i]) or 0
    end
  end
end

if not Map.tbClass then -- 防止文件重载时破坏已有数据
  Map:Init()
end

Require("\\script\\map\\default.lua")
