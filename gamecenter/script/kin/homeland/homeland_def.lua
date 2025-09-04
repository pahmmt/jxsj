-- 文件名　：homeland.lua
-- 创建者　：huangxiaoming
-- 创建时间：2011-06-10 14:01:10
-- 描  述  ：家园

HomeLand._OPEN = 1 -- 系统开关

HomeLand.MAX_LADDER_RNAK = 200 -- 最多上榜家族
HomeLand.REFRESH_WEEKDAY = 1 -- 每星期一更新
HomeLand.MAX_VISIBLE_LADDER = 1000 -- 排行榜上最多显示的家族数
HomeLand.MAX_LOG_COUNT = HomeLand.MAX_LADDER_RNAK + 100 -- log记录的家族数目

HomeLand.MAP_TEMPLATE = 2086 -- 家园模板id

HomeLand.tbLastWeekRank = HomeLand.tbLastWeekRank or {} -- 上周排名表
HomeLand.tbLastWeekKinId2Index = HomeLand.tbLastWeekKinId2Index or {} -- 上周排名索引表
HomeLand.tbCurWeekRank = HomeLand.tbCurWeekRank or {} -- 本周排名表
HomeLand.tbKinId2Index = HomeLand.tbKinId2Index or {} -- 家族id到索引表
HomeLand.tbKinId2MapId = HomeLand.tbKinId2MapId or {} -- 家族id对应地图id
HomeLand.tbLoadFailKin = HomeLand.tbLoadFailKin or {} -- 加载失败的加载列表

HomeLand.CAMP = {
  [1] = "宋方",
  [2] = "金方",
  [3] = "中立",
}

HomeLand.DEFAULT_POS = { 1, 1401, 3146 } -- 默认离开坐标点
HomeLand.ENTER_POS = { 56384 / 32, 106848 / 32 } -- 进入坐标
HomeLand.NPC_POS_CRAFTMAN = { 1794, 3093 } -- 宝石工匠
HomeLand.NPC_POS_CARVEMANANGE = { 1633, 3151 } -- 雕塑管理员
HomeLand.NPC_POS_MACHUANSHAN = { 1679, 3231 } -- 马穿山

function HomeLand:CheckOpen()
  return self._OPEN
end

-- 检查是否是第一周
function HomeLand:CheckFirstWeek()
  if not self.tbLastWeekRank or #self.tbLastWeekRank > 0 then
    return 0
  end
  local nSec = TimeFrame:GetStartServerTime()
  local nOpenWeek = Lib:GetLocalWeek(nSec)
  local nWeek = Lib:GetLocalWeek()
  if nWeek == nOpenWeek then
    return 1
  end
  if nWeek == nOpenWeek + 1 and tonumber(GetLocalDate("%w")) == 1 and tonumber(GetLocalDate("%H%M%S")) < 180000 then -- 星期一6点以前允许申请
    return 1
  end
  return 0
end

HomeLand.TB_TRANS_POS = {
  [1] = { [1] = { 1632, 3201 }, [2] = "中心广场" }, -- 中央广场
  [2] = { [1] = { 1784, 3108 }, [2] = "熔炉" }, -- 熔炉
  [3] = { [1] = { 1535, 3147 }, [2] = "后园" }, -- 田园
  [4] = { [1] = { 1550, 2981 }, [2] = "议事厅" }, -- 议事厅
  [5] = { [1] = { 1692, 3101 }, [2] = "仓库" }, -- 未知
}

-- 家族挑战令相关
HomeLand.CHALLENGE_BOSS_TIME_OUT = 30 * 60 * 18 -- BOSS超时时间，30分钟
HomeLand.CHALLENGE_BOX_TIME_OUT = 3 * 60 * 18 -- 奖励箱子超时时间，3分钟
HomeLand.CHALLENGE_WAIT_TIME_OUT = 60 * 18 -- 等待NPC时间，1分钟
HomeLand.CHALLENGE_XIAOBING_INTERVAL = 10 * 18 -- 小兵timer间隔
HomeLand.CHALLENGE_GUOHUO_TIME = 3 * 60 -- 篝火时间，3分钟
HomeLand.CHALLENG_BOSS_BUFF_TIME = 60 * 18 -- boss无敌状态时间
HomeLand.CHALLENG_BOSS_BUFF_SKILL = 999 -- boss无敌状态技能
HomeLand.CHALLENG_BOSS_BUFF_LEVEL = 10 -- boss无敌状态技能等级
HomeLand.CHALLENG_XIAOBING_TIMES = 6 -- 小兵回调触发次数
HomeLand.SENIOR_BOSS_RAND_RATE = 5 -- 精英boss的随机概率，5%
HomeLand.CHALLENGE_BOSS_TEMPLATE = -- 挑战BOSSID
  {
    { 11166, 11167 },
    { 11168, 11169 },
    { 11170, 11171 },
  }

HomeLand.CHALLENGE_BOSS_TEMPLATE_XMAS = { 11287, 11288 } --节日活动bossid
HomeLand.CHALLENGE_BOSS_DATE_XMAS = { 20121218, 20130103 } --节日boss时间
HomeLand.CHALLENGE_BOSS_OPENDAY = 139 --节日boss时间轴区分
HomeLand.CHALLENGE_WAIT_NPC_TEMPLATE = 2976 -- 召唤boss前的等待NPC特效
HomeLand.CHALLENGE_XIAOBING_TEMPLATE = 11172 -- BOSS招出的小兵ID
HomeLand.CHALLENGE_AWARD_BOX_TEMPLATE = 11133 -- 奖励箱子ID
HomeLand.CHALLENG_BOSS_LEVEL = -- 挑战BOSS等级
  {
    { 25, 40 },
    { 70, 80 },
    { 110, 130 },
  }
HomeLand.CHALLENG_XIAOBING_LEVEL = { 25, 70, 110 } -- 小兵等级
HomeLand.CHALLENGE_POS = { 61792 / 32, 105184 / 32 } -- boss和箱子坐标
HomeLand.CHALLENGE_REVIVE_POS = { 60480 / 32, 107008 / 32 } -- 挑战死亡复活点
HomeLand.CHALLENGE_GUOHUO_POS = {
  { 61536 / 32, 104896 / 32 },
  { 61504 / 32, 105536 / 32 },
  { 62016 / 32, 104896 / 32 },
  { 62048 / 32, 105568 / 32 },
}
HomeLand.CHALLENGE_XIAOBING_POS = -- 小兵的位置
  {
    { 61280 / 32, 105248 / 32 },
    { 61280 / 32, 105088 / 32 },
    { 61280 / 32, 104896 / 32 },
    { 61280 / 32, 104704 / 32 },
    { 61248 / 32, 105344 / 32 },
    { 61152 / 32, 104800 / 32 },
    { 61184 / 32, 104992 / 32 },
    { 61152 / 32, 105184 / 32 },
    { 61152 / 32, 105440 / 32 },
    { 61056 / 32, 104896 / 32 },
    { 61056 / 32, 105088 / 32 },
    { 61056 / 32, 105344 / 32 },
    { 61376 / 32, 105504 / 32 },
    { 61248 / 32, 105536 / 32 },
    { 61408 / 32, 105696 / 32 },
    { 61248 / 32, 105728 / 32 },
    { 61152 / 32, 105664 / 32 },
    { 61056 / 32, 105632 / 32 },
    { 61760 / 32, 104384 / 32 },
    { 61760 / 32, 104768 / 32 },
    { 61600 / 32, 104928 / 32 },
    { 61440 / 32, 105088 / 32 },
    { 61600 / 32, 104736 / 32 },
    { 61440 / 32, 104896 / 32 },
    { 61440 / 32, 104704 / 32 },
    { 61568 / 32, 104576 / 32 },
    { 61760 / 32, 104576 / 32 },
    { 61664 / 32, 104480 / 32 },
    { 61888 / 32, 104480 / 32 },
    { 61728 / 32, 104992 / 32 },
    { 61600 / 32, 105152 / 32 },
    { 61472 / 32, 105440 / 32 },
    { 61920 / 32, 105440 / 32 },
    { 61888 / 32, 104928 / 32 },
    { 61888 / 32, 105600 / 32 },
    { 61728 / 32, 105792 / 32 },
    { 61536 / 32, 105664 / 32 },
    { 61536 / 32, 105824 / 32 },
    { 61696 / 32, 105856 / 32 },
    { 61888 / 32, 105888 / 32 },
    { 61600 / 32, 105984 / 32 },
    { 61760 / 32, 106016 / 32 },
    { 61664 / 32, 105568 / 32 },
    { 61952 / 32, 104608 / 32 },
    { 62304 / 32, 105216 / 32 },
    { 62176 / 32, 105344 / 32 },
    { 62336 / 32, 105408 / 32 },
    { 62080 / 32, 105280 / 32 },
    { 62016 / 32, 105088 / 32 },
    { 62048 / 32, 105472 / 32 },
    { 61952 / 32, 105824 / 32 },
    { 62080 / 32, 105664 / 32 },
    { 62208 / 32, 105536 / 32 },
    { 62112 / 32, 105856 / 32 },
    { 62240 / 32, 105728 / 32 },
    { 62336 / 32, 105632 / 32 },
  }
HomeLand.CHALLENGE_XIAOBING_COUNT_PERTIME = 5
HomeLand.AWARD_SEARCH_RANGE = 32 -- 添加奖励时搜索周围玩家的范围，格子
HomeLand.AWARD_BASE_EXP_TIME = 30 -- 基准经验奖励，30分钟
HomeLand.AWARD_FRIENDSHIP = 28 -- 好友亲密度奖励
HomeLand.AWARD_ITEM_COUNT = { 2, 10 } -- 道具奖励数量，索引是BOSS类型
HomeLand.CHALLENGE_AWARD_MAX_COUNT_DAILY = 4 -- 每人每天最多只能领奖4次
HomeLand.CHALLENGE_AWARD_TASK_GROUP = 2028 -- 任务变量主ID
HomeLand.CHALLENGE_AWARD_SUB_TIMES = 14 -- 任务变量子ID，次数
HomeLand.CHALLENGE_AWARD_SUB_DAYS = 15 -- 任务变量子ID，天数
HomeLand.AWARD_ITEM_ID = -- 奖励道具ID，索引是服务器时间轴阶段
  {
    { 18, 1, 1018, 1 },
    { 18, 1, 1018, 5 },
    { 18, 1, 1018, 6 },
  }

-- 获取挑战等级（只与时间轴有关）
function HomeLand:GetChallengeLevel()
  if TimeFrame:GetState("OpenLevel150") == 1 then
    return 3
  end

  if TimeFrame:GetState("OpenLevel99") == 1 then
    return 2
  end

  return 1
end

-- 获取每天总可挑战次数
function HomeLand:GetDailyChallengeTimes()
  if TimeFrame:GetState("OpenLevel150") == 1 then
    return 1
  end

  if TimeFrame:GetState("OpenLevel99") == 1 then
    return 2
  end

  return 4
end

-- 获取指定家族当日次数
-- 返回值：当日已用次数，当日总次数
function HomeLand:GetTodayChallengeTimes(nKinId)
  local pKin = KKin.GetKin(nKinId)
  if not pKin then
    return
  end

  local nTimes = pKin.GetChallengeTimes()
  return Lib:LoadBits(nTimes, 16, 31), Lib:LoadBits(nTimes, 0, 15)
end
