-- 幸运大转盘
-- 2012/12/6 10:57:16
-- zhouchenfei

SpecialEvent.XmasLottery2012 = SpecialEvent.XmasLottery2012 or {}
local XmasLottery2012 = SpecialEvent.XmasLottery2012

XmasLottery2012.TASK_GROUP_ID = 2217

XmasLottery2012.TASKID_RANDOM_RESULT = 1
XmasLottery2012.TASKID_AWARD_TYPE = 2

XmasLottery2012.TASKID_SQU_LOTTERY_POS_1 = 3
XmasLottery2012.TASKID_SQU_LOTTERY_POS_2 = 4
XmasLottery2012.TASKID_SQU_LOTTERY_POS_3 = 5
XmasLottery2012.TASKID_AWARD_RESULT_SYNC_1 = 6
XmasLottery2012.TASKID_AWARD_RESULT_SYNC_2 = 7
XmasLottery2012.TASKID_AWARD_RESULT_SYNC_3 = 8
XmasLottery2012.TASKID_LOTTERY_ROUND = 9
XmasLottery2012.TASKID_AWARD_FINISH = 10
XmasLottery2012.TASKID_DALIY_TOTAL_ROUND = 11
XmasLottery2012.TASKID_GAME_STEP = 12
XmasLottery2012.TASKID_SAVE_BIG_RANDOMNUM = 13
XmasLottery2012.TASKID_GET_EX_AWARD_MASK = 14
XmasLottery2012.TASKID_GET_EX_AWARD_PAT = 15

XmasLottery2012.LOTTERY_MAX_ROUND = 5
XmasLottery2012.LOTTERY_MAX_BIG_SEQU = 25
XmasLottery2012.LOTTERY_ITEM_NUM = 6
XmasLottery2012.LOTTERY_MAX_DALIY_COUNT = 6

XmasLottery2012.DEF_STEP_NOGAME = 0
XmasLottery2012.DEF_STEP_SHOW_BEGIN_CARD = 1
XmasLottery2012.DEF_STEP_GET_CARD = 2

XmasLottery2012.tbRoundNeedItemNum = { 1, 3, 7, 13, 23, 39 }
XmasLottery2012.tbGameJoinItem = { 18, 1, 1880, 1 }

XmasLottery2012.tbAwardValue = {
  [1] = 3000000,
  [2] = 1280000,
  [3] = 640000,
  [4] = 320000,
  [5] = 160000,
  [6] = 80000,
}

XmasLottery2012.TIME_BEGIN = 20121218
XmasLottery2012.TIME_END = 20130103
XmasLottery2012.MIN_JOIN_LEVEL = 50

XmasLottery2012.tbYouLong = {
  { 18, 1, 1251, 2 }, --帽子
  { 18, 1, 1251, 3 }, --衣服
  { 18, 1, 1251, 1 }, --护身
  { 18, 1, 1251, 4 }, --腰带
  { 18, 1, 1251, 5 }, --鞋子
  { 18, 1, 1251, 7 }, --戒指
}

XmasLottery2012.tbAwardItemList = {
  [1] = { 18, 1, 1881, 1 },
  [2] = { 18, 1, 1882, 1 },
  [3] = { 18, 1, 1883, 1 },
  [4] = { 18, 1, 1884, 1 },
  [5] = { 18, 1, 1885, 1 },
  [6] = { 18, 1, 1886, 1 },
}
