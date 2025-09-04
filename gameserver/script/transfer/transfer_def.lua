-- 跨服

Transfer.tbServerTaskId = { 2063, 3 } --记录网关Id（废弃使用）
Transfer.tbServerTaskGatewayName = { 2063, 5, 12 } --记录网关名
Transfer.tbServerTaskSaveMapId = { 2063, 13 } --地图ID
Transfer.tbServerTaskSavePosX = { 2063, 14 } --地图x
Transfer.tbServerTaskSavePosY = { 2063, 15 } --地图y
Transfer.tbTransferStatus = { 2219, 1 } --跨服标志
Transfer.tbLoginGlbServerEvent = Transfer.tbLoginGlbServerEvent or {} --注册登陆事件
Transfer.tbTransferSyncData = Transfer.tbTransferSyncData or {} --注册跨服数据同步

Transfer.TASK_GROUP_GLOBAL_LOGIN = 2063
Transfer.TASK_ID_GLOBAL_LOGIN_TONGNAME = 26
Transfer.TASK_ID_GLOBAL_LOGIN_KINNAME = 34

--英雄岛地图Id
Transfer.tbGlobalMapId = {
  --编号 地图ID
  [1] = 1609,
  [2] = 1610,
  [3] = 1611,
  [4] = 1612,
  [5] = 1613,
  [6] = 1614,
  [7] = 1615,
  [8] = 1644,
  [9] = 1645,
  [10] = 1646,
  [11] = 1647,
  [12] = 1648,
  [13] = 1649,
  [14] = 1650,
}
