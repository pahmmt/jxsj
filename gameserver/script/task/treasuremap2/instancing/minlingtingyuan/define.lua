-- 文件名　：define.lua
-- 创建者　：LQY
-- 创建时间：2012-11-09 10:11:35
-- 说　　明：冥灵庭院定义
local tbInstancing = TreasureMap2:GetInstancingBase(8)
tbInstancing.szName = "冥灵庭院"
tbInstancing.nStep = 0
tbInstancing.tbRounds = tbInstancing.tbRounds or {}
tbInstancing.tbTraps = --trap点及处理函数
  {
    EnterTrapEvent = {
      --[步骤] = trap名,参数table
      [1] = { "enter1" },
      [2] = { "enter2" },
      [3] = { "enter3" },
      [4] = { "enter4" },
      [5] = { "enter5" },
      [6] = { "enter6" },
      [7] = { "enter7" },
      [8] = { "enter8" },
    },
    LeaveTrapEvent = { --弹回点
      [1] = { "leave1", { { 1648, 3210 } } },
      [2] = { "leave2", { { 1715, 3183 } } },
      [3] = { "leave3", { { 1782, 3153 } } },
      [4] = { "leave4", { { 1801, 3214 } } },
      [5] = { "leave5", { { 1747, 3336 } } },
      [6] = { "leave6", { { 1773, 3429 } } },
      [7] = { "leave7", { { 1838, 3364 } } },
    },
  }
tbInstancing.tbStepTips = {
  [1] = "<color=yellow>毒灼妖草终自食<color>\n<color=white>吸引炼毒人，利用他除去毒火花<color>",
  [2] = "<color=yellow>北煌元凰火引身<color>\n<color=white>打败元凰，救出被困女子<color>",
  [3] = "<color=yellow>火狼王殒困囹圄<color>\n<color=white>除去挡住去路的火狼王<color>",
  [4] = "<color=yellow>灯引危机钥藏箱<color>\n<color=white>保持灯座不灭，找出宝箱钥匙<color>",
  [5] = "<color=yellow>嗜血明月吟荷泣<color>\n<color=white>击退吟荷<color>",
  [6] = "<color=yellow>少女献祭毒虫刺<color>\n<color=white>在规定时间内，击杀毒虫，解救少女<color>",
  [7] = "<color=yellow>冥灵旗主藏深处<color>\n<color=white>除去冥灵使，引出冥灵旗主<color>",
  [8] = "<color=yellow>冥灵旗主藏深处<color>\n<color=white>击杀冥灵旗主<color>",
}

tbInstancing.tbStarRound = --星级对应关卡，同时满足直接结束关卡
  {
    --星级 =  关卡
    --例：[3] = 1,	 3星的地图将在打完第一关结束游戏
    [0] = 5,
    [1] = 5,
    [2] = 5,
    [3] = 5,
  }
--获取两个角色之间的距离
function tbInstancing:GetDis(pMan, pOtherMan)
  if not pMan or not pOtherMan then
    return 9999
  end
  local nMap1, nX1, nY1 = pMan.GetWorldPos()
  local nMap2, nX2, nY2 = pOtherMan.GetWorldPos()
  if nX1 == 0 or nY1 == 0 or nX2 == 0 or nY2 == 0 then
    return 9999
  end
  if nMap1 ~= nMap2 then
    return 9999
  end
  local nDis = ((nX1 - nX2) ^ 2 + (nY1 - nY2) ^ 2) ^ 0.5
  return nDis
end

--获得6个60度扇形技能释放点
function tbInstancing:Get6Pos(tbO, nDis)
  local nOx, nOy = tbO[1], tbO[2]
  local nD12 = nDis / 2
  local nD32 = nDis * 0.866
  local tbP = { {}, {}, {}, {}, {}, {} }
  tbP[1][1] = math.floor(nOx + nD12)
  tbP[1][2] = math.floor(nOy - nD32)
  tbP[2][1] = math.floor(nOx + nDis)
  tbP[2][2] = nOy
  tbP[3][1] = math.floor(nOx + nD12)
  tbP[3][2] = math.floor(nOy + nD32)
  tbP[4][1] = math.floor(nOx - nD12)
  tbP[4][2] = math.floor(nOy + nD32)
  tbP[5][1] = math.floor(nOx - nDis)
  tbP[5][2] = nOy
  tbP[6][1] = math.floor(nOx - nD12)
  tbP[6][2] = math.floor(nOy - nD32)
  return tbP
end

-----关卡配置
--Round1
local tbRound1 = tbInstancing.tbRound1 or {}
tbInstancing.tbRound1 = tbRound1

tbRound1.TIME_AFTER = 40 * Env.GAME_FPS --20s后小怪开始无敌
tbRound1.TIME_NAMENPC_TIME = 20 * Env.GAME_FPS --NPC出现10s

--Round2
local tbRound2 = tbInstancing.tbRound2 or {}
tbInstancing.tbRound2 = tbRound2

tbRound2.nFireNpc = 11244
tbRound2.tbFires = --喷火坐标
  {
    [1] = { { 54592 / 32, 103552 / 32 }, { 54080, 103360 }, { 1723, 15 } },
    [2] = { { 54176 / 32, 102848 / 32 }, { 54592, 103136 }, { 1723, 16 } },
    [3] = { { 54976 / 32, 102688 / 32 }, { 54720, 102496 }, { 1723, 8 } },
    [4] = { { 55008 / 32, 102080 / 32 }, { 55072, 102016 }, { 1723, 4 } },
  }
tbRound2.nFireTime1 = 3 * Env.GAME_FPS - 1 --喷火间隔1
tbRound2.nFireTime2 = 5 * Env.GAME_FPS --喷火间隔2
tbRound2.tbBugTarget = { 54592, 104512 } --虫子目的地

--Round3
local tbRound3 = tbInstancing.tbRound3 or {}
tbInstancing.tbRound3 = tbRound3

tbRound3.tbBossPos = { 1765, 3127 } --Boss所在位置
tbRound3.nFireTime = 3 * Env.GAME_FPS --喷火的间隙
tbRound3.nSectorId = 2722 --扇形技能ID
tbRound3.nFireWallId = 2722 --火墙ID
tbRound3.tbFireWallPos = {
  { 55872 / 32, 100096 / 32 },
  { 56448 / 32, 99584 / 32 },
  { 56544 / 32, 100736 / 32 },
  { 57120 / 32, 100160 / 32 },
}

--Round4
local tbRound4 = tbInstancing.tbRound4 or {}
tbInstancing.tbRound4 = tbRound4

tbRound4.nLightNpc = 11246 --点燃的灯
tbRound4.nUnLightNpc = 11245 --熄灭的灯
tbRound4.tbLightPos = --灯坐标
  {
    LD = { 57856 / 32, 102176 / 32 }, --左下
    LU = { 58336 / 32, 101792 / 32 }, --左上
    RD = { 58144 / 32, 102624 / 32 }, --右下
    RU = { 58560 / 32, 102080 / 32 }, --右上
  }
tbRound4.nAddLightTime = 5 * Env.GAME_FPS --刷出宝箱时间
tbRound4.nBoxReadTime = 1.5 * Env.GAME_FPS --宝箱读条时间
tbRound4.nTellLightOffTime = 2 * Env.GAME_FPS --提示熄灯时间
tbRound4.nLightOffTime = 10 * Env.GAME_FPS --熄灯时间
tbRound4.nLightOnTime = 1 * Env.GAME_FPS --点灯读条时间
tbRound4.nAddMonsterTime = 10 * Env.GAME_FPS --熄灭的灯刷小怪的时间

--Round5
local tbRound5 = tbInstancing.tbRound5 or {}
tbInstancing.tbRound5 = tbRound5

tbRound5.nFireNpc = 11254
tbRound5.tbFires = --喷冰坐标
  {
    [1] = { { 55648 / 32, 104896 / 32 }, { 55968, 105280 }, { 1725, 16 } },
    [2] = { { 55712 / 32, 105568 / 32 }, { 55552, 105824 }, { 1725, 10 } },
    [3] = { { 55776 / 32, 106656 / 32 }, { 55968, 106464 }, { 1725, 10 } },
  }
tbRound5.nFireTime1 = 3 * Env.GAME_FPS - 1 --喷冰间隔1
tbRound5.nFireTime2 = 5 * Env.GAME_FPS --喷冰间隔2

--Round6
local tbRound6 = tbInstancing.tbRound6 or {}
tbInstancing.tbRound6 = tbRound6

tbRound6.nLimitTime = 4 * 60 * Env.GAME_FPS --第六关限时
tbRound6.nAddBugTime = 3 * Env.GAME_FPS --多少秒刷新一个毒虫
tbRound6.nKillBug = 10 --打死多少只虫子才能救妹子
tbRound6.nBugBoomTime = 5 * Env.GAME_FPS --虫子爆炸时间
tbRound6.nSaveGirlTime = 5 * Env.GAME_FPS --解救妹子的读条时间
tbRound6.nSavebuff = 1760 --救完妹子后的BUFF
tbRound6.nSaveBuffTime = 5 * Env.GAME_FPS --BUFF持续时间

--Round7
local tbRound7 = tbInstancing.tbRound7 or {}
tbInstancing.tbRound7 = tbRound7
tbRound7.nOnLight = 15 * Env.GAME_FPS --多少秒点亮一个灯
tbRound7.nOnLightId = 11261 --点亮的AOE灯ID
tbRound7.nOffLightId = 11260 --熄灭的AOE灯ID
