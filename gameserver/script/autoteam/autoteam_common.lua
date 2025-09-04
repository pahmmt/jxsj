--client, gs, gc共用逻辑
--关闭
do
  return
end

--允许申请自动匹配组队、以及匹配中时玩家能够所在的地图类型
AutoTeam.tbAllowedMapType = {
  ["village"] = 1, --新手村
  ["city"] = 1, --城市
  ["faction"] = 1, --门派
  ["fight"] = 1, --普通野外地图
  ["taskarmy"] = 1, --军营（青龙、朱雀、玄武）
  ["taskfight"] = 1, --任务地图（战斗模式）
  ["tasksafe"] = 1, --任务地图（练功模式）
}

--逍遥谷报名点和关卡地图的Type相同，所以要通过ID判断
AutoTeam.tbAllowedMapId = {
  [341] = 1, --逍遥谷报名点1
  [342] = 1, --逍遥谷报名点2
}

function AutoTeam:IsAllowedMap(nMapId)
  if self.tbAllowedMapId[nMapId] == 1 then
    return 1
  end

  local szMapType = GetMapType(nMapId)
  if self.tbAllowedMapType[szMapType] == 1 then
    return 1
  end

  return 0
end

function AutoTeam:IsTeamTypeXoyo(nTeamType)
  return (nTeamType >= self.XOYO_PUTONG and nTeamType <= self.XOYO_DIYU) and 1 or 0
end

function AutoTeam:IsTeamTypeArmy(nTeamType)
  return (nTeamType >= self.ARMY_FUNIUSHAN and nTeamType <= self.ARMY_HAIWANGLINGMU) and 1 or 0
end

function AutoTeam:GetTeamTypeName(nTeamType)
  local tb = {
    [self.XOYO_PUTONG] = "普通逍遥谷",
    [self.XOYO_KUNNAN] = "困难逍遥谷",
    [self.XOYO_CHUANSHUO] = "传说逍遥谷",
    [self.XOYO_DIYU] = "地狱逍遥谷",

    [self.ARMY_FUNIUSHAN] = "伏牛山后山",
    [self.ARMY_BAIMANSHAN] = "百蛮山",
    [self.ARMY_HAIWANGLINGMU] = "海陵王墓",
  }
  return assert(tb[nTeamType])
end
