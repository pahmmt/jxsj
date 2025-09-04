-- 文件名　：crosstimeroom_def.lua
-- 创建者　：zhangjunjie
-- 创建时间：2011-07-29 16:54:49
-- 描述：时光阴阳店define

local preEnv = _G
setfenv(1, CrossTimeRoom)

nOpenState = 0 --开关

nTemplateMapId = 2091 --地图模板id

MAX_GAME = 50 --当前地图最大的游戏数量

MAX_TIME = 60 * 60 --游戏最大的时间

MAX_PLAYER = 6 --游戏的最大人数

FINISH_TIME = 60 --挑战完成后一分钟后关闭副本

ENTER_ITEM_GDPL = { 18, 1, 1451, 1 } --进入的令牌的gdpl

ENTER_POS = --进入点
  {
    { 52896 / 32, 103264 / 32 },
  }

LEAVE_POS = --离开点，根据serverid进行判断
  {
    [1] = { 3, 1585, 3156 },
  }

tbRoomPos = --每个房间的传入点
  {
    [1] = { 47328 / 32, 99072 / 32 },
    [2] = { 41824 / 32, 97248 / 32 },
    [3] = { 50400 / 32, 93952 / 32 },
    [4] = { 50112 / 32, 106400 / 32 },
    [5] = { 51904 / 32, 101760 / 32 },
  }

nCheastTemplateId = --宝箱ID
  {
    [1] = 11146,
    [2] = 11146,
    [3] = 11146,
    [4] = 11147,
    [5] = 11148,
    [6] = 11149,
  }

nTransferTemplateId = 9596 --传送门模板id

tbTransferNpcPos = --传送门的pos
  {
    [0] = { 56448 / 32, 106624 / 32 }, --准备场的传送门
    [1] = { 46976 / 32, 98560 / 32 },
    [2] = { 41888 / 32, 98336 / 32 },
    [3] = { 50016 / 32, 94912 / 32 },
    [4] = { 50048 / 32, 106464 / 32 },
    [5] = { 51968 / 32, 101824 / 32 },
    [6] = { 56160 / 32, 101440 / 32 }, --第五关的异境里的传送npc，防止那里也有人死亡
  }
tbChestPos = { --宝箱刷新地点
  [1] = { 1494, 3071 },
  [2] = { 1304, 3048 },
  [3] = { 1579, 2947 },
  [4] = { 1558, 3296 },
  [5] = { 1612, 3169 },
}
tbExpTable = --经验值 索引人数
  {
    [1] = { 806400, 1075200, 1209600, 1612800, 2016000 },
    [2] = { 921600, 1228800, 1382400, 1843200, 2304000 },
    [3] = { 1036800, 1382400, 1555200, 2073600, 2592000 },
    [4] = { 1152000, 1536000, 1728000, 2304000, 2880000 },
    [5] = { 1267200, 1689600, 1900800, 2534400, 3168000 },
    [6] = { 1324800, 1766400, 1987200, 2649600, 3312000 },
  }
tbDropItemFile = {
  [1] = "setting\\npc\\droprate\\yinyangshiguangdian\\crystal_01.txt",
  [2] = "setting\\npc\\droprate\\yinyangshiguangdian\\crystal_02.txt",
  [3] = "setting\\npc\\droprate\\yinyangshiguangdian\\crystal_03.txt",
  [4] = "setting\\npc\\droprate\\yinyangshiguangdian\\crystal_04.txt",
  [5] = "setting\\npc\\droprate\\yinyangshiguangdian\\crystal_05.txt",
  [6] = "setting\\npc\\droprate\\yinyangshiguangdian\\crystal_06.txt",
}
tbDropItemExFile = "setting\\npc\\droprate\\yinyangshiguangdian\\dropadd.txt"
tbDropCount = {
  [1] = { 6 },
  [2] = { 8 },
  [3] = { 9 },
  [4] = { 12, { 1, 2, 3, 5, 6, 7 } },
  [5] = { 15, { 1, 3, 6, 9, 12, 16 } },
}

tbBoxTxt = {
  [1] = "你们齐心协力走到这里，特赠予铜质宝箱。参与侠士越多，将获得等级更高的宝箱。",
  [2] = "你们齐心协力走到这里，特赠予铜质宝箱。参与侠士越多，将获得等级更高的宝箱。",
  [3] = "你们齐心协力走到这里，特赠予铜质宝箱。参与侠士越多，将获得等级更高的宝箱。",
  [4] = "你们齐心协力走到这里，特赠予银质宝箱。参与侠士越多，将获得等级更高的宝箱。",
  [5] = "你们齐心协力走到这里，特赠予金质宝箱。参与侠士越多，将获得等级更高的宝箱。",
  [6] = "你们齐心协力走到这里，特赠予锦绣宝箱。实乃人生一大快事！",
}
tbMapTrapBackPos = --trap的弹回点
  {
    ["trap_up"] = { 52096 / 32, 101984 / 32 },
    ["trap_down"] = { 52352 / 32, 102528 / 32 },
  }

nLimitJoinHuanglingBuffId = 2328 --限制进入皇陵的buff id

nGetJoinItemBaseKinLevel = 200 --每周可以领取进入牌子的家族的最低威望排名
nGetJoinItemBasePlayerLevel = 3000 --每周可以领取进入牌子的个人最低威望排名

nCloseTransferNpcDelay = 55 * 60 --报名npc存在的时间,55分钟

nBeginTransferTimeDay = 1525
nEndTransferTimeDay = 1535
nBeginTransferTimeNight = 2225
nEndTransferTimeNight = 2235

nDelteTransferNpcTimeDay = 1635
nDelteTransferNpcTimeNight = 2335

nApplyNpcTemplateId = 9615 --报名npc的模板id

nApplyNpcMapId = 132 --报名npc的地图id

tbApplyNpcPos = { 62816 / 32, 105952 / 32 } --报名npc的位置

nEnterItemNum = 2 --每周可领取令牌的数量

nGetEnterItemLimitTime = 21200 --星期二中午12点后才可以进行领取

nTaskGroupId = 2177 --记录领取令牌的任务变量组
nTaskGetItemTime = 1 --领取时间
nTaskGetCount = 2 --接取任务次数

tbTransferName = {
  [1] = "壹：送我去改变一个人",
  [2] = "贰：送我去改变历史",
  [3] = "叁：送我去改变自己的过去",
  [4] = "肆：送我去改变一段传奇",
  [5] = "伍：送我去终结这一切",
}

nMakeStoneJinghuo = 3000 --制作时候需要的精活

tbOtherDropInfo = { "\\setting\\npc\\droprate\\yinyangshiguangdian\\boss2_other.txt", 10 }

nRepute = 2 --每关通关后给的威望

preEnv.setfenv(1, preEnv)
