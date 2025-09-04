-- 文件名　：dayplayerback_def.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-07-03 11:17:44
-- 功能    ：

SpecialEvent.tbDayPlayerBack = SpecialEvent.tbDayPlayerBack or {}
local tbDayPlayerBack = SpecialEvent.tbDayPlayerBack or {}

tbDayPlayerBack.TASK_GID = 2195
tbDayPlayerBack.TASK_ID_BATCH = 45
tbDayPlayerBack.TASK_RATE_BACK = 46
tbDayPlayerBack.TASK_TIME_BATCH = 47

tbDayPlayerBack.nTimeLimit = 7 * 24 * 3600
tbDayPlayerBack.nLevelLimit = 50

tbDayPlayerBack.tbChangeTime = { 20121011, 20121120, 1.5 } --调整时间及参数

tbDayPlayerBack.tbLing = { 18, 1, 1754, 1 } --征战江湖令

tbDayPlayerBack.tbAwardList = {
  --奖励名字，基础量，最大量，具体奖励类型及参数，有效期（不填表示永久）,领取批次，领取时间
  { "领取征战江湖令", 1, 1, [[AddItem:"18,1,1754,1",1,1,43200]], nil, 1, 2 },
  { "领取修炼时间", 6 * 60, 72 * 60, "AddXiulianExTime: %s", nil, 3, 4 },
  { "领取离线托管时间", 24 * 60, 240 * 60, "AddOfflineTime: %s", nil, 5, 6 },
  { "领取开启福袋机会", 30, 360, "AddExOpenFuDai: %s", nil, 7, 8 },
  { "领取祈福机会", 3, 36, "AddExOpenQiFu: %s", nil, 9, 10 },
  { "领取福袋箱(20个福袋)", 1, 5, [[AddItem:"18,1,303,2",%s,1,""]], nil, 11, 12 },
  { "领取藏宝图令牌", 3, 15, "AddGTask:%s,%s,%s", nil, 13, 14 },
  { "领取侠客印鉴", 2 * 24 * 60, 8 * 24 * 60, [[AddItem:"1,18,%s,1",1,1,%s]], 20121120, 15, 16, 20121011 },
  { "领取魂石折扣券", 1, 5, [[AddItem:"18,1,1696,1",%s,1,""]], nil, 17, 18 },
  { "领取绑金返还券(1000点)", 1, 5, [[AddItem:"18,1,1309,1",%s,1,""]], nil, 19, 20 },
  { "绑定银两返还券(500000点)", 1, 5, [[AddItem:"18,1,1352,2",%s,1,""]], nil, 21, 22 },
  { "家族银元宝", 1, 15, [[AddItem:"18,1,1787,1",%s,1,""]], 20121120, 51, 52, 20121011 },
}

tbDayPlayerBack.tbEventList = {
  --征战令牌活动，基础量，最大量，可以参加的次数，已经参加的次
  { "官府通缉 ", 9, 36, 23, 24 },
  { "逍遥谷 ", 3, 15, 25, 26 },
  { "藏宝图 ", 3, 15, 27, 28 },
  { "白虎堂 ", 2, 10, 29, 30 },
  { "军营 ", 3, 30, 31, 32 },
  --{"灯谜活动 ", 	2, 20, 33, 34},
  { "初级家族关卡 ", 2, 10, 35, 36 },
  { "高级家族关卡 ", 2, 10, 37, 38 },
  { "领土争夺 ", 1, 5, 39, 40 },
  { "家园种植 ", 6, 60, 41, 42 },
  { "侠客任务 ", 1, 4, 43, 44 },
}

tbDayPlayerBack.tbTreasureLing = {
  ["18,1,995,2"] = 2,
  ["18,1,995,3"] = 3,
  ["18,1,995,4"] = 4,
  ["18,1,996,2"] = 3,
  ["18,1,996,3"] = 4,
  ["18,1,996,4"] = 5,
  ["18,1,997,2"] = 4,
  ["18,1,997,3"] = 5,
  ["18,1,997,4"] = 6,
  ["18,1,998,2"] = 7,
  ["18,1,998,3"] = 8,
  ["18,1,998,4"] = 9,
  ["18,1,999,2"] = 5,
  ["18,1,999,3"] = 6,
  ["18,1,999,4"] = 7,
  ["18,1,1019,1"] = 4,
  ["18,1,1019,2"] = 5,
  ["18,1,1019,3"] = 6,
}

tbDayPlayerBack.tbNameTreasure = {
  [3] = "通用挑战",
  [4] = "陶朱公疑冢",
  [5] = "大漠古城",
  [6] = "万花谷",
  [7] = "千琼宫",
  [8] = "龙门飞剑",
  [9] = "碧落谷",
}

tbDayPlayerBack.tbLevelLimit = {
  [1] = 25,
  [2] = 50,
  [3] = 70,
  [4] = 80,
  [5] = 90,
  [6] = 100,
  [7] = 120,
}
