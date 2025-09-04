-- 文件名　：dts_def.lua
-- 创建者　：zounan/jiazhenwei
-- 创建时间：2009-10-30 14:49:38
-- 描  述  ：大逃杀相关设定

--Task ID--
DaTaoSha.TASKID_GROUP = 2148 --任务变量组
DaTaoSha.TASKID_ATTEND_TIME = 1 --进入准备场时间
--DaTaoSha.TASKID_MONEY				= 2;		--玩家身上的货币数
DaTaoSha.TASKID_AWARD = 2 --第几次奖励 是否已经领奖
DaTaoSha.TASKID_WENJUAN = 3 --玩家是否进行过问卷调查
DaTaoSha.TASKID_SHORTCUT1 = 4 --玩家的快捷键
DaTaoSha.TASKID_SHORTCUT2 = 5 --玩家的快捷键
DaTaoSha.TASKID_SHORTCUT3 = 6 --玩家的快捷键
DaTaoSha.TASKID_SHORTCUT4 = 7 --玩家的快捷键
DaTaoSha.TASKID_SHORTCUT5 = 8 --玩家的快捷键
DaTaoSha.TASKID_SHORTCUT6 = 9 --玩家的快捷键
DaTaoSha.TASKID_SHORTCUT7 = 10 --玩家的快捷键
DaTaoSha.TASKID_SHORTCUT8 = 11 --玩家的快捷键
DaTaoSha.TASKID_SHORTCUT9 = 12 --玩家的快捷键
DaTaoSha.TASKID_SHORTCUT10 = 13 --玩家的快捷键
DaTaoSha.TASKID_SHORTCUT11 = 14 --玩家的快捷键
DaTaoSha.TASKID_SHORTCUT12 = 15 --玩家的快捷键
DaTaoSha.TASKID_SHORTCUT13 = 16 --玩家的快捷键
DaTaoSha.TASKID_SHORTCUT14 = 17 --玩家的快捷键
DaTaoSha.TASKID_SHORTCUT15 = 18 --玩家的快捷键
DaTaoSha.TASKID_SHORTCUT16 = 19 --玩家的快捷键
DaTaoSha.TASKID_SHORTCUT17 = 20 --玩家的快捷键
DaTaoSha.TASKID_SHORTCUT18 = 21 --玩家的快捷键
DaTaoSha.TASKID_SHORTCUT19 = 22 --玩家的快捷键
DaTaoSha.TASKID_SHORTCUT20 = 23 --玩家的快捷键
DaTaoSha.TASKID_SHORTCUT21 = 24 --玩家的快捷键
DaTaoSha.TASKID_SHORTCUT22 = 25 --玩家的快捷键
DaTaoSha.TASKID_GROUPID = 26 --玩家组队的ID
DaTaoSha.TASKID_GROUP_MAPID = 27 --玩家组队的ID
DaTaoSha.TASKID_GROUP_POSX = 28 --玩家组队的ID
DaTaoSha.TASKID_GROUP_POSY = 29 --玩家组队的ID
DaTaoSha.TASKID_JOIN_TIMES = 30 --玩家每天可参加的次数
DaTaoSha.TASKID_JOIN_DATA = 31 --玩家累计日期
DaTaoSha.TASKID_LIMIT_TIMES = 32 --玩家每天限制次数

DaTaoSha.TASKID_GLOBAL_AWARD = 37
DaTaoSha.TASKID_TICKETS = 38 --门票
DaTaoSha.TASKID_BATCH = 40 --批次变量

--global server 任务变量
DaTaoSha.GBTSKG_DATAOSHA = 6
DaTaoSha.GBTSK_AWARD = 1
DaTaoSha.GBTASKID_ATTEND_NUMBER = 2 --参加次数
DaTaoSha.GBTASKID_DATE = 3 --时间
DaTaoSha.GBTASKID_ATTEND_ALLNUM = 4 --参加总次数

DaTaoSha.DEF_AWARD_TSK = {
  [1] = { nGlobal = 5, nLocal = 33 },
  [2] = { nGlobal = 6, nLocal = 34 },
  [3] = { nGlobal = 7, nLocal = 35 },
  [4] = { nGlobal = 8, nLocal = 36 },
  [5] = { nGlobal = 9, nLocal = 39 },
}
DaTaoSha.GBTASKID_BATCH = 10 --全局变量批次
DaTaoSha.GBTASKID_SHOTCUT = 11 --快捷键刷新问题

DaTaoSha.nBatch = 4 --批次，清除玩家任务变量跨服变量及排行榜
--类型
DaTaoSha.MACTH_PRIM = 1 --初级
DaTaoSha.MACTH_ADV = 2 --高级

DaTaoSha.PLAYER_ATTEND_LEVEL = 60 --最低等级需求;
DaTaoSha.PLAYER_NUMBER = 66 --每张pk图人数
DaTaoSha.MACTH_TIME_READY = Env.GAME_FPS * 20 --20秒轮询
DaTaoSha.READYMAP_PLAYER_NUM = 400 --准备场地图人数上限
DaTaoSha.PLAYER_TEAM_NUMBER = 3 --一个队的人数(和上面的pk图人数能除尽的整数)
DaTaoSha.PLAYER_ATTNUMBER = 10 --每天每个人能参加活动的数目
DaTaoSha.OPENTIME = { 1100, 1800 } --活动开启时间
DaTaoSha.CLOSETIME = { 1400, 2100 } --活动关闭时间
DaTaoSha.nMaxDayTime = 15 --每天最多累计15次
DaTaoSha.nDayTime = 5 --每天上线累计3次机会
DaTaoSha.nMaxTime = 36 --活动期间最多45次机会

DaTaoSha.bIsOpenXueHua = 1 --比赛场雪花开关

--mission
-- 分钟
DaTaoSha.TIME_ROUND1 = 10 -- 第一轮时间
DaTaoSha.TIME_ROUND2 = 10 -- 第二轮时间
DaTaoSha.TIME_ROUND3 = 10 -- 第三轮时间
DaTaoSha.TIME_CALL_CHESTS = 1 -- 第一轮开始前1分钟刷宝箱
DaTaoSha.TIME_RELAX = 3 -- 休息时间
DaTaoSha.TIME_GAMEOVER = 0.5 -- 比赛结束 给0.5分钟等待
DaTaoSha.MIS_LIST = {
  { "GetReady", Env.GAME_FPS * 60 * (DaTaoSha.TIME_RELAX - DaTaoSha.TIME_CALL_CHESTS), "CallChests" }, --刷宝箱
  { "Round1Start", Env.GAME_FPS * 60 * DaTaoSha.TIME_CALL_CHESTS, "Round1Start" }, --第一轮
  { "Round1Start", Env.GAME_FPS * 60 * DaTaoSha.TIME_ROUND1, "Round1Relax" }, --第一轮结束休息
  { "Round2Start", Env.GAME_FPS * 60 * DaTaoSha.TIME_RELAX, "Round2Start" }, --第二轮
  { "Round2Start", Env.GAME_FPS * 60 * DaTaoSha.TIME_ROUND2, "Round2Relax" }, --第二轮结束休息
  { "Round3Start", Env.GAME_FPS * 60 * DaTaoSha.TIME_RELAX, "Round3Start" }, --第三轮
  { "EndGame", Env.GAME_FPS * 60 * DaTaoSha.TIME_ROUND3, "OnGameOverNoCamp" }, --比赛结束
}
DaTaoSha.ROUND1_LIVEABILITY = 0.5 --第一轮存活率
DaTaoSha.MONEY = { 18, 1, 511, 1 } --铜钱的道具GDPL
DaTaoSha.QIANGHUAJUANZHOU = {
  { 18, 1, 518, 1 }, --武器强化卷轴
  { 18, 1, 519, 1 }, --防具强化卷轴
  { 18, 1, 520, 1 }, --饰品强化卷轴
}
DaTaoSha.LingPai = { 18, 1, 523, 1 } --令牌GDPL
DaTaoSha.CHESTS_ID = 2472 --宝箱的ID
DaTaoSha.MERCHANT_ID = 2470 --商人的ID
DaTaoSha.NPC_ID = 2469 --怪的ID
DaTaoSha.MIS_MONSTER_REFRESH_TIME = 3 -- 每隔2分钟刷怪
DaTaoSha.MIS_MONSTER_REFRESH_COUNT = 5 -- 共刷5次
DaTaoSha.MIS_KILL_NPC_EARN = 5 -- 杀一个NPC得5个货币
DaTaoSha.MIS_KILL_PLAYER_EARN_S = 10 -- 杀一个玩家自己得10个货币
DaTaoSha.MIS_KILL_PLAYER_EARN = 5 -- 杀一个玩家队友得5个货币
DaTaoSha.MIS_LIFE_COUNT = 3 --每个队有几条命
DaTaoSha.TIME_PROTECT = 5 -- 5秒的保护时间
DaTaoSha.TIME_PROTECT2 = 10 -- 10秒的保护时间
DaTaoSha.DROPRATE_PATH = {
  szNpc_droprate = "\\setting\\npc\\droprate\\dataosha\\npc_droprate.txt",
  szPlayer_droprate = "\\setting\\npc\\droprate\\dataosha\\player_droprate.txt",
}

DaTaoSha.MISSION_MOVIE = {
  [1] = "您和您的队友一起来到了这片充满了杀戮与恐惧气息的土地，此时有三种五行可供你们选择：%s、%s、%s，在敌人还没杀到之前，赶紧做出决定吧。",
}
DaTaoSha.MISSION_BATTLE_MSG = "<color=green>本队剩余成员:<color=white> %s<color>\n场内剩余队伍:<color=white> %s<color>\n本队伍击杀数:<color=white> %s<color>\n个人击杀数:<color=white> %s<color>"
DaTaoSha.MISSION_UI_EXTEND_MSG = {
  [0] = "\n稍候将刷出宝箱，请耐心等待。",
  [1] = "\n活动即将开始，请最后检查技能、道具设置。",
  [2] = "\n击败敌人、NPC可获得寒武符石！",
  [3] = "\n您可使用寒武符石与物资商人换取道具。",
  [4] = "\n击败敌人、NPC可获得寒武符石！",
  [5] = "\n您可使用寒武符石与物资商人换取道具。",
}

DaTaoSha.MEDICINE_CAI = {
  [1] = { 19, 3, 1, 5, 0 }, -- 玉笛谁家听落梅  G,D,P,L
  [2] = { 19, 3, 1, 4, 0 }, -- 蒜蓉生菜
}

DaTaoSha.MEDICINE_LIFE = { -- 用于设置快捷栏
  [1] = { 17, 1, 1, 5, 0 }, -- 九转还魂丹 G,D,P,L,Series
  [2] = { 17, 1, 1, 4, 0 }, -- 回天丹
}

DaTaoSha.MEDICINE_MANA = { -- 用于设置快捷栏
  [1] = { 17, 2, 1, 5, 0 }, -- 首乌还神丹 G,D,P,L,Series
  [2] = { 17, 2, 1, 4, 0 }, -- 大补散
}

DaTaoSha.YAOXIANG_LIFE = { --大逃杀回血丹·箱
  [1] = { 18, 1, 497, 1 },
  [2] = { 18, 1, 505, 1 },
}

DaTaoSha.YAOXIANG_MANA = { --大逃杀回内丹·箱
  [1] = { 18, 1, 498, 1 },
  [2] = { 18, 1, 506, 1 },
}

DaTaoSha.YAOXIANG_LM = {
  [1] = { 18, 1, 514, 1 }, --五花玉露丸·箱
  [2] = { 18, 1, 507, 1 }, --七巧补心丹·箱
}

DaTaoSha.YAOFANG = { 18, 1, 540, 1 }

DaTaoSha.HORSE = { -- 马
  [1] = {
    { 1, 12, 5, 3, -1 },
    { 1, 12, 6, 3, -1 },
    { 1, 12, 7, 3, -1 },
    { 1, 12, 8, 3, -1 },
    { 1, 12, 9, 3, -1 },
  },
  [2] = {
    { 1, 12, 5, 3, -1 },
    { 1, 12, 6, 3, -1 },
    { 1, 12, 7, 3, -1 },
    { 1, 12, 8, 3, -1 },
    { 1, 12, 9, 3, -1 },
  },
}

DaTaoSha.MACTH_TRAP_ENTER = { { 1573, 3233 }, { 1584, 3193 }, { 1607, 3182 } } --进入准备场坐标

DaTaoSha.RANDOM_ITEM = {
  -- GDPL ,  数目
  { { 18, 1, 499, 1 }, 3 },
  { { 18, 1, 500, 1 }, 3 },
  { { 18, 1, 501, 1 }, 3 },
}

DaTaoSha.tbMantle = { 1, 17, 6 } --披风G、D、L

DaTaoSha.FACTION = {
  [1] = {
    szSeriesName = "金系",
    [1] = { szFactionName = "少林", nFactionId = 1, nSexLimit = 0, [1] = "刀少林", [2] = "棍少林" },
    [2] = { szFactionName = "天王", nFactionId = 2, nSexLimit = -1, [1] = "枪天王", [2] = "锤天王" },
  },
  [2] = {
    szSeriesName = "木系",
    [1] = { szFactionName = "唐门", nFactionId = 3, nSexLimit = -1, [1] = "陷阱唐门", [2] = "袖箭唐门" },
    [2] = { szFactionName = "五毒", nFactionId = 4, nSexLimit = -1, [1] = "刀五毒", [2] = "掌五毒" },
    [3] = { szFactionName = "明教", nFactionId = 11, nSexLimit = -1, [1] = "锤明教", [2] = "剑明教" },
  },
  [3] = {
    szSeriesName = "水系",
    [1] = { szFactionName = "峨嵋", nFactionId = 5, nSexLimit = 1, [1] = "掌峨嵋", [2] = "辅助峨嵋" },
    [2] = { szFactionName = "翠烟", nFactionId = 6, nSexLimit = -1, [1] = "剑翠烟", [2] = "刀翠烟" },
    [3] = { szFactionName = "大理段氏", nFactionId = 12, nSexLimit = -1, [1] = "指段氏", [2] = "气段氏" },
  },
  [4] = {
    szSeriesName = "火系",
    [1] = { szFactionName = "丐帮", nFactionId = 7, nSexLimit = -1, [1] = "掌丐帮", [2] = "棍丐帮" },
    [2] = { szFactionName = "天忍", nFactionId = 8, nSexLimit = -1, [1] = "战天忍", [2] = "魔天忍" },
  },
  [5] = {
    szSeriesName = "土系",
    [1] = { szFactionName = "武当", nFactionId = 9, nSexLimit = -1, [1] = "气武当", [2] = "剑武当" },
    [2] = { szFactionName = "昆仑", nFactionId = 10, nSexLimit = -1, [1] = "刀昆仑", [2] = "剑昆仑" },
    [3] = { szFactionName = "古墓", nFactionId = 13, nSexLimit = -1, nGateLimit = 1, [1] = "剑古墓", [2] = "针古墓" },
  },
}

--本服网关id为以下的才能选择古墓门派
DaTaoSha.tbGateLimit = { ["gate1025"] = 1, ["gate1121"] = 1 }

DaTaoSha.DEF_MAXLEVEL = { [1] = 119, [2] = 110 }
DaTaoSha.WEAPONLEVEL = { [1] = 10, [2] = 10 } -- 宋金体验的武器等级
DaTaoSha.ARMOR_LEVEL = { [1] = 10, [2] = 10 } -- 宋金体验的防具等级
DaTaoSha.ENHANCELEVEL = 10 -- 宋金体验装备的强化等级
DaTaoSha.tbExbag_20Grid = { 21, 8, 1, 1 } -- 20格背包

DaTaoSha.PRIM_ITEM = { -- 9级紫装
  { -- 少林
    { -- 刀少林
      [0] = { --男性
        { 2, 1, 727 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 }, --近身武器meleeweapon.txt
        { 2, 3, 828 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 }, --衣服armor
        { 2, 9, 826 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 }, --帽子helm
        { 2, 8, 406 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 }, --腰带belt
        { 2, 7, 408 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 }, --鞋子boots
        { 2, 10, 624 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 }, --护腕cuff
        { 2, 5, 206 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 }, --项链necklace
        { 2, 4, 156 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 }, --戒指ring
        { 2, 11, 406 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 }, --玉佩pendant
        { 2, 6, 207 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 }, --护身符amulet
        { 1, 14, 1, 2, -1 },
      },
      [1] = { --女性
        { 2, 1, 727 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 838 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 836 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 416 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 418 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 630 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 206 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 156 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 416 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 207 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 1, 2, -1 },
      },
    },
    { -- 	棍少林
      [0] = {
        { 2, 1, 737 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 808 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 806 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 406 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 408 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 624 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 206 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 156 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 406 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 207 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 2, 2, -1 },
      },
      [1] = {
        { 2, 1, 737 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 818 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 816 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 416 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 418 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 630 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 206 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 156 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 416 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 207 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 2, 2, -1 },
      },
    },
  },
  { -- 天王
    { -- 	枪天王
      [0] = {
        { 2, 1, 747 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 808 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 806 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 406 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 408 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 624 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 206 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 156 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 406 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 207 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 3, 2, -1 },
      },
      [1] = {
        { 2, 1, 747 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 818 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 816 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 416 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 418 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 630 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 206 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 156 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 416 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 207 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 3, 2, -1 },
      },
    },
    { --	锤天王
      [0] = {
        { 2, 1, 757 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 808 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 806 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 406 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 408 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 624 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 206 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 156 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 406 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 207 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 4, 2, -1 },
      },
      [1] = {
        { 2, 1, 757 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 818 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 816 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 416 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 418 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 630 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 206 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 156 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 416 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 207 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 4, 2, -1 },
      },
    },
  },
  { -- 唐门
    { -- 陷阱唐门
      [0] = {
        { 2, 2, 86 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 }, --远程武器rangeweapon.txt
        { 2, 3, 848 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 846 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 426 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 428 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 636 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 216 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 166 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 426 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 217 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 5, 2, -1 },
      },
      [1] = {
        { 2, 2, 86 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 858 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 856 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 436 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 438 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 642 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 216 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 166 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 436 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 217 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 5, 2, -1 },
      },
    },
    { -- 	袖箭唐
      [0] = {
        { 2, 2, 96 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 }, --远程武器rangeweapon.txt
        { 2, 3, 848 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 846 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 426 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 428 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 636 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 216 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 166 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 426 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 217 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 6, 2, -1 },
      },
      [1] = {
        { 2, 2, 96 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 858 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 856 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 436 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 438 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 642 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 216 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 166 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 436 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 217 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 6, 2, -1 },
      },
    },
  },
  { -- 五毒
    { -- 刀毒
      [0] = {
        { 2, 1, 767 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 848 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 846 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 426 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 428 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 636 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 216 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 166 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 426 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 217 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 7, 2, -1 },
      },
      [1] = {
        { 2, 1, 767 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 858 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 856 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 436 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 438 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 642 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 216 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 166 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 436 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 217 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 7, 2, -1 },
      },
    },
    { -- 掌毒
      [0] = {
        { 2, 1, 777 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 868 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 866 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 426 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 428 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 636 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 216 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 216 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 426 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 217 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 8, 2, -1 },
      },
      [1] = {
        { 2, 1, 777 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 878 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 876 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 436 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 438 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 438 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 216 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 166 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 436 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 217 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 8, 2, -1 },
      },
    },
  },
  { -- 峨嵋
    { -- 掌em
      [0] = {
        { 2, 1, 807 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 908 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 906 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 446 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 448 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 648 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 226 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 176 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 446 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 227 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 9, 2, -1 },
      },
      [1] = {
        { 2, 1, 807 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 918 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 916 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 456 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 458 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 654 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 226 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 176 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 456 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 227 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 9, 2, -1 },
      },
    },
    { -- 辅助
      [0] = {
        { 2, 1, 817 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 908 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 906 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 446 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 448 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 648 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 226 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 176 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 446 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 227 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 10, 2, -1 },
      },
      [1] = {
        { 2, 1, 817 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 918 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 916 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 456 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 458 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 654 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 226 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 176 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 456 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 227 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 10, 2, -1 },
      },
    },
  },
  { -- 翠烟
    { -- 剑翠
      [0] = {
        { 2, 1, 817 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 908 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 906 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 446 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 448 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 648 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 226 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 176 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 446 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 227 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 11, 2, -1 },
      },
      [1] = {
        { 2, 1, 817 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 918 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 916 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 456 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 458 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 654 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 226 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 176 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 456 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 227 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 11, 2, -1 },
      },
    },
    { -- 刀翠
      [0] = {
        { 2, 1, 787 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 908 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 906 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 446 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 448 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 648 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 226 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 176 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 446 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 227 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 12, 2, -1 },
      },
      [1] = {
        { 2, 1, 787 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 918 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 916 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 456 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 458 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 654 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 226 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 176 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 456 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 227 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 12, 2, -1 },
      },
    },
  },
  { -- 丐帮
    { -- 掌丐
      [0] = {
        { 2, 1, 847 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 748 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 746 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 366 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 368 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 660 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 186 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 186 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 366 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 187 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 13, 2, -1 },
      },
      [1] = {
        { 2, 1, 847 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 758 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 756 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 376 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 378 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 666 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 186 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 186 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 376 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 187 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 13, 2, -1 },
      },
    },
    { -- 棍丐
      [0] = {
        { 2, 1, 827 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 748 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 746 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 366 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 368 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 660 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 186 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 186 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 366 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 187 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 14, 2, -1 },
      },
      [1] = {
        { 2, 1, 827 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 758 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 756 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 376 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 378 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 666 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 186 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 186 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 376 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 187 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 14, 2, -1 },
      },
    },
  },
  { -- 天忍
    { -- 战忍
      [0] = {
        { 2, 1, 837 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 728 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 726 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 366 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 368 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 660 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 186 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 186 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 366 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 187 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 15, 2, -1 },
      },
      [1] = {
        { 2, 1, 837 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 738 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 736 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 376 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 378 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 666 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 186 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 186 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 376 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 187 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 15, 2, -1 },
      },
    },
    { -- 魔忍
      [0] = {
        { 2, 1, 857 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 748 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 746 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 366 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 368 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 660 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 186 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 186 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 366 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 187 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 16, 2, -1 },
      },
      [1] = {
        { 2, 1, 857 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 758 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 756 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 376 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 378 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 666 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 186 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 186 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 376 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 187 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 16, 2, -1 },
      },
    },
  },
  { -- 武当
    { -- 气武
      [0] = {
        { 2, 1, 887 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 988 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 986 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 486 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 488 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 672 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 246 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 196 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 486 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 247 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 17, 2, -1 },
      },
      [1] = {
        { 2, 1, 887 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 998 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 996 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 496 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 498 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 678 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 246 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 196 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 496 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 247 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 17, 2, -1 },
      },
    },
    { -- 剑武
      [0] = {
        { 2, 1, 877 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 968 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 966 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 486 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 488 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 672 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 246 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 196 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 486 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 247 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 18, 2, -1 },
      },
      [1] = {
        { 2, 1, 877 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 978 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 976 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 496 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 498 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 678 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 246 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 196 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 496 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 247 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 18, 2, -1 },
      },
    },
  },
  { -- 昆仑
    { -- 刀昆
      [0] = {
        { 2, 1, 867 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 988 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 986 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 486 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 488 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 672 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 246 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 196 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 486 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 247 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 19, 2, -1 },
      },
      [1] = {
        { 2, 1, 867 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 998 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 996 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 496 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 498 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 678 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 246 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 196 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 496 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 247 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 19, 2, -1 },
      },
    },
    { -- 剑昆
      [0] = {
        { 2, 1, 897 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 988 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 986 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 486 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 488 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 672 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 246 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 196 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 486 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 247 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 20, 2, -1 },
      },
      [1] = {
        { 2, 1, 897 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 998 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 996 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 496 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 498 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 678 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 246 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 196 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 496 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 247 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 20, 2, -1 },
      },
    },
  },
  { -- 明教
    { -- 锤明教
      [0] = {
        { 2, 1, 987 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 848 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 846 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 426 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 428 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 636 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 216 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 166 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 426 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 217 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 21, 2, -1 },
      },
      [1] = {
        { 2, 1, 987 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 858 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 856 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 436 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 438 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 642 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 216 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 166 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 436 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 217 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 21, 2, -1 },
      },
    },
    { -- 剑明教
      [0] = {
        { 2, 1, 977 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 868 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 866 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 426 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 428 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 636 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 216 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 166 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 426 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 217 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 22, 2, -1 },
      },
      [1] = {
        { 2, 1, 977 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 878 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 876 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 436 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 438 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 642 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 216 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 166 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 436 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 217 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 22, 2, -1 },
      },
    },
  },
  { -- 段氏
    { -- 指段氏
      [0] = {
        { 2, 1, 797 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 908 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 906 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 446 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 448 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 648 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 226 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 176 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 446 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 227 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 23, 2, -1 },
      },
      [1] = {
        { 2, 1, 797 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 918 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 916 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 456 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 458 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 654 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 226 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 176 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 456 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 227 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 23, 2, -1 },
      },
    },
    { -- 气段氏
      [0] = {
        { 2, 1, 817 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 908 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 906 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 446 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 448 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 648 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 226 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 176 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 446 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 227 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 24, 2, -1 },
      },
      [1] = {
        { 2, 1, 817 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 918 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 916 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 456 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 458 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 654 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 226 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 176 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 456 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 227 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 24, 2, -1 },
      },
    },
  },
  { -- 古墓
    { -- 剑古墓
      [0] = {
        { 2, 1, 1512 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 1472 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 1086 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 641 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 488 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 488 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 336 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 246 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 699 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 247 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 25, 2, -1 },
      },
      [1] = {
        { 2, 1, 1512 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 1462 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 1096 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 646 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 498 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 498 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 336 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 246 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 692 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 247 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 25, 2, -1 },
      },
    },
    { -- 针古墓
      [0] = {
        { 2, 2, 210 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 1472 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 1086 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 641 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 488 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 488 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 336 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 246 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 699 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 247 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 26, 2, -1 },
      },
      [1] = {
        { 2, 2, 210 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 1462 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 1096 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 646 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 498 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 498 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 336 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 246 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 692 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 247 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 26, 2, -1 },
      },
    },
  },
}
DaTaoSha.ADV_ITEM = { -- 10级紫装
  { -- 少林
    { -- 刀少林
      [0] = {
        { 2, 1, 727 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 }, --近身武器meleeweapon.txt
        { 2, 3, 828 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 }, --衣服armor
        { 2, 9, 826 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 }, --帽子helm
        { 2, 8, 406 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 }, --腰带belt
        { 2, 7, 408 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 }, --鞋子boots
        { 2, 10, 680 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 }, --护腕cuff
        { 2, 5, 206 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 }, --项链necklace
        { 2, 4, 250 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 }, --戒指ring
        { 2, 11, 406 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 }, --玉佩pendant
        { 2, 6, 207 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 }, --护身符amulet
        { 1, 14, 1, 2, -1 },
      },
      [1] = {
        { 2, 1, 727 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 838 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 836 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 416 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 418 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 685 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 206 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 250 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 416 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 207 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 1, 2, -1 },
      },

      ["MijiSkillName"] = "达摩闭息功",
    },
    { -- 	棍少林
      [0] = {
        { 2, 1, 737 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 808 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 806 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 406 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 408 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 680 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 206 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 250 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 406 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 207 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 2, 2, -1 },
      },
      [1] = {
        { 2, 1, 737 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 818 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 816 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 416 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 418 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 685 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 206 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 250 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 416 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 207 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 2, 2, -1 },
      },
      ["MijiSkillName"] = "金刚不坏",
    },
  },
  { -- 天王
    { -- 	枪天王
      [0] = {
        { 2, 1, 747 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 808 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 806 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 406 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 408 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 680 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 206 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 250 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 406 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 207 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 3, 2, -1 },
      },
      [1] = {
        { 2, 1, 747 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 818 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 816 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 416 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 418 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 685 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 206 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 250 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 416 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 207 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 3, 2, -1 },
      },
      ["MijiSkillName"] = "披荆斩棘",
    },
    { --	锤天王
      [0] = {
        { 2, 1, 757 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 808 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 806 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 406 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 408 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 680 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 206 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 250 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 406 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 207 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 4, 2, -1 },
      },
      [1] = {
        { 2, 1, 757 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 818 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 816 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 416 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 418 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 685 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 206 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 250 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 416 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 207 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 4, 2, -1 },
      },
      ["MijiSkillName"] = "披荆斩棘",
    },
  },
  { -- 唐门
    { -- 陷阱唐门
      [0] = {
        { 2, 2, 86 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 }, --远程武器rangeweapon.txt
        { 2, 3, 848 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 846 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 426 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 428 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 683 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 216 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 247 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 426 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 217 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 5, 2, -1 },
      },
      [1] = {
        { 2, 2, 86 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 858 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 856 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 436 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 438 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 688 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 216 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 247 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 436 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 217 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 5, 2, -1 },
      },
      ["MijiSkillName"] = "含沙射影",
    },
    { -- 	袖箭唐
      [0] = {
        { 2, 2, 96 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 }, --远程武器rangeweapon.txt
        { 2, 3, 848 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 846 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 426 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 428 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 683 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 216 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 247 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 426 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 217 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 6, 2, -1 },
      },
      [1] = {
        { 2, 2, 96 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 858 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 856 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 436 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 438 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 688 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 216 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 247 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 436 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 217 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 6, 2, -1 },
      },
      ["MijiSkillName"] = "漫天雨花",
    },
  },
  { -- 五毒
    { -- 刀毒
      [0] = {
        { 2, 1, 767 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 848 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 846 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 426 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 428 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 683 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 216 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 247 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 426 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 217 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 7, 2, -1 },
      },
      [1] = {
        { 2, 1, 767 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 858 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 856 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 436 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 438 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 688 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 216 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 447 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 436 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 217 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 7, 2, -1 },
      },
      ["MijiSkillName"] = "化血截脉",
    },
    { -- 掌毒
      [0] = {
        { 2, 1, 777 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 868 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 866 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 426 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 428 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 428 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 216 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 216 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 426 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 217 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 8, 2, -1 },
      },
      [1] = {
        { 2, 1, 777 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 878 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 876 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 436 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 438 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 438 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 216 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 216 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 436 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 217 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 8, 2, -1 },
      },
      ["MijiSkillName"] = "追风毒棘",
    },
  },
  { -- 峨嵋
    { -- 掌em
      [0] = {
        { 2, 1, 807 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 908 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 906 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 446 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 448 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 448 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 226 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 226 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 446 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 227 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 9, 2, -1 },
      },
      [1] = {
        { 2, 1, 807 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 918 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 916 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 456 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 458 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 458 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 226 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 226 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 456 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 227 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 9, 2, -1 },
      },
      ["MijiSkillName"] = "金顶绵掌",
    },
    { -- 辅助
      [0] = {
        { 2, 1, 817 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 908 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 906 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 446 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 448 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 448 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 226 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 226 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 446 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 227 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 10, 2, -1 },
      },
      [1] = {
        { 2, 1, 817 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 918 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 916 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 456 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 458 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 458 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 226 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 226 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 456 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 227 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 10, 2, -1 },
      },
      ["MijiSkillName"] = "渡元功",
    },
  },
  { -- 翠烟
    { -- 剑翠
      [0] = {
        { 2, 1, 817 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 908 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 906 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 446 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 448 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 448 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 226 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 226 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 446 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 227 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 11, 2, -1 },
      },
      [1] = {
        { 2, 1, 817 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 918 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 916 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 456 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 458 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 458 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 226 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 226 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 456 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 227 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 11, 2, -1 },
      },
      ["MijiSkillName"] = "雨打梨花",
    },
    { -- 刀翠
      [0] = {
        { 2, 1, 787 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 908 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 906 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 446 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 448 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 682 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 226 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 251 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 446 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 227 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 12, 2, -1 },
      },
      [1] = {
        { 2, 1, 787 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 918 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 916 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 456 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 458 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 687 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 226 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 251 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 456 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 227 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 12, 2, -1 },
      },
      ["MijiSkillName"] = "踏雪无痕",
    },
  },
  { -- 丐帮
    { -- 掌丐
      [0] = {
        { 2, 1, 847 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 748 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 746 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 366 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 368 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 468 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 186 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 236 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 366 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 187 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 13, 2, -1 },
      },
      [1] = {
        { 2, 1, 847 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 758 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 756 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 376 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 378 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 478 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 186 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 236 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 376 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 187 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 13, 2, -1 },
      },
      ["MijiSkillName"] = "神龙摆尾",
    },
    { -- 棍丐
      [0] = {
        { 2, 1, 827 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 748 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 746 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 366 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 368 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 679 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 186 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 249 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 366 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 187 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 14, 2, -1 },
      },
      [1] = {
        { 2, 1, 827 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 758 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 756 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 376 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 378 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 684 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 186 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 249 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 376 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 187 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 14, 2, -1 },
      },
      ["MijiSkillName"] = "偷龙转凤",
    },
  },
  { -- 天忍
    { -- 战忍
      [0] = {
        { 2, 1, 837 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 728 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 726 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 366 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 368 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 679 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 186 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 249 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 366 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 187 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 15, 2, -1 },
      },
      [1] = {
        { 2, 1, 837 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 738 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 736 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 376 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 378 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 684 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 186 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 249 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 376 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 187 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 15, 2, -1 },
      },
      ["MijiSkillName"] = "碧月飞星",
    },
    { -- 魔忍
      [0] = {
        { 2, 1, 857 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 748 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 746 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 366 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 368 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 468 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 186 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 236 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 366 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 187 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 16, 2, -1 },
      },
      [1] = {
        { 2, 1, 857 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 758 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 756 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 376 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 378 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 478 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 186 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 236 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 376 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 187 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 16, 2, -1 },
      },
      ["MijiSkillName"] = "玄冥吸星",
    },
  },
  { -- 武当
    { -- 气武
      [0] = {
        { 2, 1, 887 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 988 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 986 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 486 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 488 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 488 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 246 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 246 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 486 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 247 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 17, 2, -1 },
      },
      [1] = {
        { 2, 1, 887 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 998 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 996 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 496 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 498 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 498 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 246 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 246 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 496 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 247 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 17, 2, -1 },
      },
      ["MijiSkillName"] = "两仪心法",
    },
    { -- 剑武
      [0] = {
        { 2, 1, 877 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 968 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 966 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 486 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 488 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 681 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 246 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 248 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 486 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 247 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 18, 2, -1 },
      },
      [1] = {
        { 2, 1, 877 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 978 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 976 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 496 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 498 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 686 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 246 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 248 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 496 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 247 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 18, 2, -1 },
      },
      ["MijiSkillName"] = "流星赶月",
    },
  },
  { -- 昆仑
    { -- 刀昆
      [0] = {
        { 2, 1, 867 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 988 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 986 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 486 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 488 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 681 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 246 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 248 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 486 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 247 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 19, 2, -1 },
      },
      [1] = {
        { 2, 1, 867 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 998 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 996 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 496 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 498 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 686 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 246 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 248 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 496 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 247 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 19, 2, -1 },
      },
      ["MijiSkillName"] = "两仪真气",
    },
    { -- 剑昆
      [0] = {
        { 2, 1, 897 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 988 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 986 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 486 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 488 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 488 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 246 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 246 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 486 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 247 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 20, 2, -1 },
      },
      [1] = {
        { 2, 1, 897 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 998 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 996 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 496 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 498 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 498 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 246 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 246 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 496 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 247 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 20, 2, -1 },
      },
      ["MijiSkillName"] = "化髓无意",
    },
  },
  { -- 明教
    { -- 锤明教
      [0] = {
        { 2, 1, 987 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 848 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 846 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 426 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 428 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 683 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 216 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 247 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 426 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 217 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 21, 2, -1 },
      },
      [1] = {
        { 2, 1, 987 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 858 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 856 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 436 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 438 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 688 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 216 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 247 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 436 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 217 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 21, 2, -1 },
      },
      ["MijiSkillName"] = "流星锤",
    },
    { -- 剑明教
      [0] = {
        { 2, 1, 977 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 868 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 866 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 426 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 428 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 428 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 216 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 216 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 426 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 217 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 22, 2, -1 },
      },
      [1] = {
        { 2, 1, 977 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 878 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 876 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 436 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 438 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 438 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 216 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 216 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 436 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 217 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 22, 2, -1 },
      },
      ["MijiSkillName"] = "氤氲紫气",
    },
  },
  { -- 段氏
    { -- 指段氏
      [0] = {
        { 2, 1, 797 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 908 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 906 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 446 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 448 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 682 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 226 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 251 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 446 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 227 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 23, 2, -1 },
      },
      [1] = {
        { 2, 1, 797 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 918 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 916 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 456 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 458 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 687 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 226 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 251 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 456 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 227 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 23, 2, -1 },
      },
      ["MijiSkillName"] = "百步穿杨",
    },
    { -- 气段氏
      [0] = {
        { 2, 1, 817 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 908 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 906 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 446 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 448 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 448 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 226 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 226 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 446 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 227 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 24, 2, -1 },
      },
      [1] = {
        { 2, 1, 817 - 6 + DaTaoSha.WEAPONLEVEL[2], DaTaoSha.WEAPONLEVEL[2], -1 },
        { 2, 3, 918 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 9, 916 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 8, 456 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 7, 458 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 10, 458 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 5, 226 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 4, 226 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 11, 456 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 2, 6, 227 - 6 + DaTaoSha.ARMOR_LEVEL[2], DaTaoSha.ARMOR_LEVEL[2], -1 },
        { 1, 14, 24, 2, -1 },
      },
      ["MijiSkillName"] = "白虹贯日",
    },
  },
  { -- 古墓
    { -- 剑古墓
      [0] = {
        { 2, 1, 1512 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 1472 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 1086 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 641 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 488 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 488 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 336 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 246 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 699 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 247 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 25, 2, -1 },
      },
      [1] = {
        { 2, 1, 1512 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 1462 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 1096 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 646 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 498 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 498 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 336 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 246 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 692 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 247 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 25, 2, -1 },
      },
      ["MijiSkillName"] = "失魂引",
    },
    { -- 针古墓
      [0] = {
        { 2, 2, 210 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 1472 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 1086 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 641 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 488 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 488 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 336 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 246 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 699 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 247 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 26, 2, -1 },
      },
      [1] = {
        { 2, 2, 210 - 6 + DaTaoSha.WEAPONLEVEL[1], DaTaoSha.WEAPONLEVEL[1], -1 },
        { 2, 3, 1462 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 9, 1096 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 8, 646 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 7, 498 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 10, 498 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 5, 336 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 4, 246 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 11, 692 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 2, 6, 247 - 6 + DaTaoSha.ARMOR_LEVEL[1], DaTaoSha.ARMOR_LEVEL[1], -1 },
        { 1, 14, 26, 2, -1 },
      },
    },
    ["MijiSkillName"] = "明珠暗投",
  },
}

DaTaoSha.EUQIP_ITEM = {
  [1] = DaTaoSha.PRIM_ITEM,
  [2] = DaTaoSha.ADV_ITEM,
}

--内存记录表
DaTaoSha.MissionList = DaTaoSha.MissionList or {} --mission
DaTaoSha.tbReadyTimer = DaTaoSha.tbReadyTimer or {} --准备场计时器Id;
DaTaoSha.WaitMapMemList = DaTaoSha.WaitMapMemList or {} --准备场玩家名单
DaTaoSha.WaitMapMemList2 = DaTaoSha.WaitMapMemList2 or {} --准备场玩家对应队长的表
DaTaoSha.WaitMapPlayerNum = DaTaoSha.WaitMapPlayerNum or {}
DaTaoSha.WaitMemMap = DaTaoSha.WaitMemMap or {}
DaTaoSha.PKPlayerList = DaTaoSha.PKPlayerList or {} --pk中玩家名单
DaTaoSha.tbPlayerShortCut = DaTaoSha.tbPlayerShortCut or {} --记录玩家快捷键栏 返回本服时刷新
DaTaoSha.tbAllPlayerList = DaTaoSha.tbAllPlayerList or {}

DaTaoSha.tbCD_EnterReady = DaTaoSha.tbCD_EnterReady or {}
DaTaoSha.SERIES_COLOR = {
  [1] = "<color=orange>%s<color>", -- 金系
  [2] = "<color=green>%s<color>", -- 木系
  [3] = "<color=blue>%s<color>", -- 水系
  [4] = "<color=salmon>%s<color>", -- 火系
  [5] = "<color=wheat>%s<color>", -- 土系
}
--奖励
DaTaoSha.AWARD_ROUND = {
  [1] = { nBindMoney = 120000, tbItem = { 18, 1, 1, 7 } },
  [2] = { nBindMoney = 120000, tbItem = { 18, 1, 1, 8 } },
  [3] = { nBindMoney = 120000, tbItem = { 18, 1, 1, 9 } },
}

DaTaoSha.AWARD_HORSE = { 18, 1, 666, 10 }

DaTaoSha.AWARD_CAMPITEM = { 18, 1, 1099, 1 } -- 冠军礼包
DaTaoSha.AWARD_MONEY = 300000
DaTaoSha.AWARD_REPUTE = {
  [1] = { nCampId = 7, nClassId = 1, szName = "武林联赛", nLevel = 5, tbRepute = { [1] = 1500, [2] = 3000, [3] = 4500, [4] = 48000, [5] = 100000 } },
  [2] = { nCampId = 8, nClassId = 1, szName = "领土争夺战", nLevel = 5, tbRepute = { [1] = 1500, [2] = 3000, [3] = 4500, [4] = 35000, [5] = 70000 } },
  [3] = { nCampId = 5, nClassId = 4, szName = "祈福", nLevel = 4, tbRepute = { [1] = 300, [2] = 300, [3] = 8000, [4] = 10000 } },
  [4] = { nCampId = 10, nClassId = 1, szName = "民族大团圆", nLevel = 2, tbRepute = { [1] = 500, [2] = 1000 } },
  [5] = { nCampId = 11, nClassId = 1, szName = "武林大会", nLevel = 2, tbRepute = { [1] = 4800, [2] = 9600 } },
  [6] = { nCampId = 5, nClassId = 2, szName = "2008盛夏活动", nLevel = 2, tbRepute = { [1] = 1000, [2] = 2000 } },
}

DaTaoSha.DEF_ROUND_COUNTLIMIT = {
  [1] = 11,
  [2] = 5,
}

--积分
DaTaoSha.DEF_AWARD_SCORE = {
  [1] = 1,
  [2] = 2,
  [3] = 3,
  [4] = 5,
}

--具体奖励
DaTaoSha.DEF_AWARD_ITEM = {
  [1] = { tbItemId = { 18, 1, 508, 1 }, szName = "寒武瓷瓶" },
  [2] = { tbItemId = { 18, 1, 509, 1 }, szName = "寒武宝瓶" },
  [3] = { tbItemId = { 18, 1, 512, 1 }, szName = "雪魂令" },
  [4] = { tbItemId = { 18, 1, 1, 8 }, szName = "8玄", bBind = 1 },
  [5] = { tbItemId = { 18, 1, 1, 9 }, szName = "9玄", bBind = 1 },
  [6] = { tbItemId = { 18, 1, 1, 10 }, szName = "10玄", bBind = 1 },
}

--奖励类型，个数
DaTaoSha.DEF_AWARD_ITEMLIST = {
  [1] = { tbId = 1, nCount = 1 },
  [2] = { tbId = 2, nCount = 1 },
  [3] = { tbId = 2, nCount = 2 },
  [4] = { tbId = 2, nCount = 3 },
  [5] = { tbId = 3, nCount = 1 },
}

-- 冠军额外奖励
DaTaoSha.DEF_AWARD_EXTRA_PROC = 16
DaTaoSha.DEF_AWARD_EXTRA_ITEM = {
  nProc = 16,
  tbId = 3,
  nCount = 1,
}

--全局排行奖励
DaTaoSha.DEF_GLOBAL_AWARD_TYPE = {
  [1] = { nRank = 1, tbItem = { tbId = 3, nCount = 60 } },
  [2] = { nRank = 4, tbItem = { tbId = 3, nCount = 30 } },
  [3] = { nRank = 10, tbItem = { tbId = 3, nCount = 10 } },
  [4] = { nRank = 30, tbItem = { tbId = 3, nCount = 5 } },
  [5] = { nRank = 100, tbItem = { tbId = 6, nCount = 1 } },
  [6] = { nRank = 300, tbItem = { tbId = 5, nCount = 2 } },
  [7] = { nRank = 500, tbItem = { tbId = 5, nCount = 1 } },
  [8] = { nRank = 1500, tbItem = { tbId = 4, nCount = 2 } },
}

DaTaoSha.DEF_GLOBALAWARD_DATE_BEGIN = 20121011 --领奖开始日期
DaTaoSha.DEF_GLOBALAWARD_DATE_END = 20121017 --领奖结束日期
DaTaoSha.nStatTime = 20120927 --活动开始日期
DaTaoSha.nEndTime = 20121010 --活动结束日期

DaTaoSha.tbMsg2Global = {
  "还有10分钟“探索寒武遗迹”活动即开启，请诸位侠士前往主城附近找卖火柴小女孩报名参与！",
  "“探索寒武遗迹”活动已经开启，请诸位侠士前往主城中央附近找卖火柴小女孩报名参与！",
  "“探索寒武遗迹”正在火热进行中，请诸位侠士前往主城中央附近找卖火柴小女孩报名参与！",
}

DaTaoSha.TIME_SCHTASK = {
  [1] = { 1050, 1750 },
  [3] = { 1130, 1200, 1230, 1300, 1330, 1830, 1900, 1930, 2000, 2030 },
}
