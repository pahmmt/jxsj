-- 文件名　：treasuremapEx_def.lua
-- 创建者　：LQY
-- 创建时间：2012-11-02 16:32:52
-- 说　　明：藏宝图重整 定义
local TreasureMapEx = TreasureMap.TreasureMapEx or {}
TreasureMap.TreasureMapEx = TreasureMapEx

--文件配置
TreasureMapEx.CONFIG_FILE = "\\setting\\task\\treasuremapex\\rankconfig.txt" --阶梯配置文件
TreasureMapEx.MAPSINFO_FILE = "\\setting\\task\\treasuremapex\\mapsinfo.txt" --副本信息文件
TreasureMapEx.MAPNPCINFO = "\\setting\\task\\treasuremapex\\mapInfo\\%s\\npc.txt" --副本NPC文件
TreasureMapEx.MAPTRAPINFO = "\\setting\\task\\treasuremapex\\mapInfo\\%s\\trap.txt" --副本TRAP文件

--系统状态
TreasureMapEx.IsOpen = 1

--系统配置
TreasureMapEx.TIMERATE_VALUE = --通关时间加成数值
  {
    [1] = 68,
    [2] = 51,
    [3] = 34,
    [4] = 17,
  }

----系统常量
TreasureMapEx.MAXCOUNT = 100 --次数上限
TreasureMapEx.XIAKE_STAR = 4 --完成侠客任务最低的星级

--TASK
TreasureMapEx.TASK_GROUP = 2218
TreasureMapEx.TASK_COUNT = 1 --副本次数
TreasureMapEx.TASK_CHANGE = 2 --是否已转换旧数据
TreasureMapEx.TASK_DAY = 3 --领取天
TreasureMapEx.TASK_WEEK_COUNT = 4 --本周领取次数
TreasureMapEx.TASK_WEEK = 5 --领取周

--表
TreasureMapEx.tbRankTable = TreasureMapEx.tbRankTable or {} --阶梯信息表
TreasureMapEx.tbNpcLevel = TreasureMapEx.tbNpcLevel or {} --星级对应怪物等级表
TreasureMapEx.tbStarMapTable = TreasureMapEx.tbStarMapTable or {} --星级对应副本列表
TreasureMapEx.tbStarAward = TreasureMapEx.tbStarAward or {} --星级对应奖励数量
TreasureMapEx.tbMapInfo = TreasureMapEx.tbMapInfo or {} --副本信息表

---------------------------
--- 通用函数
-- 星级数字到图片
function TreasureMapEx:Star2pic(nStar)
  nStar = tonumber(nStar)
  local Star0 = "☆"
  local Star1 = "★"
  if nStar < 0 then
    return ""
  end
  if nStar == 0 then
    return "   <color=gold>" .. Star0 .. "<color>"
  end
  local szStar = "  "
  for n = 1, nStar do
    szStar = szStar .. Star1
  end
  return "   <color=gold>" .. szStar .. "<color>"
end
