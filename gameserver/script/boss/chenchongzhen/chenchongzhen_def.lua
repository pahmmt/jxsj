-- 文件名　：chenchongzhen_def.lua
-- 创建者　：zhangjunjie
-- 创建时间：2012-02-20 14:37:39
-- 描述：common define

local preEnv = _G
setfenv(1, ChenChongZhen)

nTemplateMapId = 2153 --地图模板id

MAX_GAME = 50 --当前地图最大的游戏数量

MAX_TIME = 90 * 60 --游戏最大的时间

MAX_PLAYER = 6 --游戏的最大人数

FINISH_TIME = 60 --一分钟后关闭副本

REVIVE_DELAY = 1 * 18 --复活的延迟

ENTER_ITEM_GDPL = { 18, 1, 1695, 1 } --进入的令牌gdpl

nGetJoinItemBaseKinLevel = 200 --每周可以领取进入牌子的家族的最低威望排名
nGetJoinItemBasePlayerLevel = 3000 --每周可以领取进入牌子的个人最低威望排名
nGetEnterItemLimitTime = 21200 --星期二中午12点后才可以进行领取
nEnterItemNum = 2 --每周可领取令牌的数量
nTaskGroupId = 2177 --记录领取令牌的任务变量组
nTaskGetItemTime = 3 --领取时间

ENTER_POS = --进入点
  {
    { 1489, 3324 },
  }

LEAVE_POS = --离开点，根据serverid进行判断
  {
    [1] = { 24, 1752, 3532 },
  }
BACK_POS = --返回点
  {
    [3] = { 49408 / 32, 97760 / 32 },
    [4] = { 56960 / 32, 93888 / 32 },
    [5] = { 45984 / 32, 102240 / 32 },
  }
FIGHT_STATE_POS = --准备场到战斗的点，2个
  {
    ["trap_join"] = { 48320 / 32, 105632 / 32 },
  }

MAX_ROOM_COUNT = 7 --关卡的数量

tbMapTrapName = {
  ["trap_join"] = { 48224 / 32, 105760 / 32 },
  ["trap_machine1"] = {},
  ["trap_machine2"] = {},
  ["trap_machine3"] = {},
  ["trap_machine4"] = {},
  ["trap_room2"] = { 1630, 3178 },
  ["trap_room3"] = { 1714, 3080 },
  ["trap_room4"] = { 1542, 3057 },
  ["trap_room5"] = { 1923, 3032 },
  ["trap_back5"] = { 1430, 3188 },
  ["trap_room5_trans"] = { 61472 / 32, 96960 / 32 },
}

tbRoom7FireEyeInfo = {
  10020,
  {
    { 52704 / 32, 108800 / 32 },
    { 53216 / 32, 108160 / 32 },
    { 53856 / 32, 107936 / 32 },
    { 54752 / 32, 107136 / 32 },
    { 54400 / 32, 107520 / 32 },
    { 55168 / 32, 106624 / 32 },
    { 55648 / 32, 106112 / 32 },
  },
} --火眼

nRoom7FireEyeCastSkillDelay = 4 * 18 --释放技能的间隔

nRoom7FireEyeSkillId = 2600 --火眼的技能id

tbRoom7Horse = {
  10019,
  {
    { 57312 / 32, 103328 / 32 },
    { 57216 / 32, 103520 / 32 },
    { 57184 / 32, 103616 / 32 },
    { 57184 / 32, 103744 / 32 },
    { 57248 / 32, 103424 / 32 },
    { 57376 / 32, 103264 / 32 },
  },
} --第七关的马匹

nRoom7AddHorseDelay = 5 * 60 * 18

tbDropRateInfo = --掉落
  {
    [1] = { 4 },
    [2] = { 6 },
    [3] = { 8 },
    [4] = { 10, { 2, 4, 6, 10, 12, 14 } },
    [5] = { 7 },
    [6] = { 9 },
    [7] = { 6, { 2, 6, 12, 18, 24, 32 } },
  }

tbDropRateInfoLevel = {
  [1] = "\\setting\\npc\\droprate\\chenchongzhen\\crystal_01.txt",
  [2] = "\\setting\\npc\\droprate\\chenchongzhen\\crystal_02.txt",
  [3] = "\\setting\\npc\\droprate\\chenchongzhen\\crystal_03.txt",
  [4] = "\\setting\\npc\\droprate\\chenchongzhen\\crystal_04.txt",
  [5] = "\\setting\\npc\\droprate\\chenchongzhen\\crystal_05.txt",
  [6] = "\\setting\\npc\\droprate\\chenchongzhen\\crystal_06.txt",
}
szDropRateInfoExtra = "\\setting\\npc\\droprate\\chenchongzhen\\dropadd.txt"
tbDropRateInfoExp = {
  [1] = { 67200, 1008000, 1344000, 1680000, 1176000, 1512000, 1008000 },
  [2] = { 768000, 1152000, 1536000, 1920000, 1344000, 1728000, 1152000 },
  [3] = { 864000, 1296000, 1728000, 2160000, 1512000, 1944000, 1296000 },
  [4] = { 960000, 1440000, 1920000, 2400000, 1680000, 2160000, 1440000 },
  [5] = { 1056000, 1584000, 2112000, 2640000, 1848000, 2376000, 1584000 },
  [6] = { 1104000, 1656000, 2208000, 2760000, 1932000, 2484000, 1656000 },
}

tbDropRateInfoNpc = {
  [1] = 11128,
  [2] = 11129,
  [3] = 11130,
  [4] = 11131,
}

tbDropBoxMsg = {
  [1] = "你们齐心协力走到这里，特赠予铜质宝箱。参与侠士越多，将获得等级更高的宝箱。",
  [2] = "你们齐心协力走到这里，特赠予银质宝箱。参与侠士越多，将获得等级更高的宝箱。",
  [3] = "你们齐心协力走到这里，特赠予金质宝箱。参与侠士越多，将获得等级更高的宝箱。",
  [4] = "你们齐心协力走到这里，特赠予锦绣宝箱。实乃人生一大快事！",
}

tbRevivePos = --复活后的点
  {
    [1] = { 51872 / 32, 102048 / 32 },
    [7] = { 52320 / 32, 109440 / 32 },
  }

nDropItemBoxTemplateId = 9838 --宝箱的id

tbBoxInfo = {
  [1] = { 51968 / 32, 101920 / 32 },
  [2] = { 1710, 3084 },
  [3] = { 57088 / 32, 94496 / 32 },
  [4] = { 45376 / 32, 101696 / 32 },
  [5] = { 1796, 3214 },
  [6] = { 1792, 3251 },
  [7] = { 52192 / 32, 109536 / 32 },
}

nRepute = 2 --每关通关后给的威望

tbAchievement = --成就
  {
    [1] = 493,
    [2] = 494,
    [3] = 495,
    [4] = 496,
    [5] = 497,
    [6] = 498,
    [7] = 499,
  }

nHaveTaskId = 523 --需要接的任务

nTaskNeedStep = 1 --需要接的步骤

nTaskHavePlayerTaskGroupId = 1025

nTaskHavePlayerTaskId = 76

preEnv.setfenv(1, preEnv)
