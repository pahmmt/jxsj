-- 文件名　：guoqing2012_def.lua
-- 创建者　：huangxiaoming
-- 创建时间：2012-09-17 14:10:10
-- 描  述  ：

SpecialEvent.GuoQing2012 = SpecialEvent.GuoQing2012 or {}
local tbGuoQing2012 = SpecialEvent.GuoQing2012 or {}

tbGuoQing2012.IS_OPEN = 1 -- 系统开关

-- task id
tbGuoQing2012.TASK_GROUP_ID = 2027 -- 任务组ID
tbGuoQing2012.TASK_EVENT_DAY = 252 -- 接取事件任务的天数
tbGuoQing2012.TASK_EVENT_STATE = 253 -- 事件任务的状态
tbGuoQing2012.TASK_EVENT_STEP_INFO = 254 -- 事件的步骤信息
tbGuoQing2012.TASK_EVENT_STEP_PARAM = 255 -- 第一步地图ID,第二步最后一次点燃的时间,第三步需要赠送的门派
tbGuoQing2012.TASK_EVENT_CAKE_DAY = 256 -- 收到月饼的日期
tbGuoQing2012.TASK_EVENT_CAKE_COUNT = 257 -- 收到月饼的个数
tbGuoQing2012.TASK_HUILIU_ACCEPT = 258 -- 是否接取了回流任务
tbGuoQing2012.TASK_HUILIU_STATE = 259 -- 在指定日期开启回流道具的信息
tbGuoQing2012.TASK_HUILIU_FINAL_AWARD = 260 -- 最终大奖，奖励太多，加个变量保护一下
tbGuoQing2012.TASK_EVENT_HELP_DAY = 261 -- 收到赠送月饼的日期
tbGuoQing2012.TASK_EVENT_HELP_COUNT = 262 -- 收到赠送月饼的个数
tbGuoQing2012.TASK_AWARD_PET = 263 -- 随机跟宠的概率
tbGuoQing2012.TASK_EVENT_IGINITE_TIME = 264 -- 点炮竹的时间

-- 事件的步骤定义
tbGuoQing2012.EVENT_STEP_INIT = 0 -- 初始状态
tbGuoQing2012.EVENT_STEP_FREE = 1 -- 免费道具
tbGuoQing2012.EVENT_STEP_COST = 2 -- 付费道具

-- 每个步骤消费的金币数
tbGuoQing2012.EVENT_COST_COIN_NUM = { 100, 100, 100 }
tbGuoQing2012.HUILIU_COST_COIN_NUM = 500 -- 回流活动过期开卡的费用

tbGuoQing2012.LIMIT_LEVEL = 50

-- map id
tbGuoQing2012.MAP_ID_USELANTERN = {} -- 城市和新手村列表
for i = 1, 8 do
  tbGuoQing2012.MAP_ID_USELANTERN[i] = i
end
for i = 23, 29 do
  tbGuoQing2012.MAP_ID_USELANTERN[#tbGuoQing2012.MAP_ID_USELANTERN + 1] = i
end
-- item id
tbGuoQing2012.ITEMID_HUANGDUGUOQING = { 18, 1, 1815, 1 }
tbGuoQing2012.ITEMID_HUILIUAWARD_BIG = { 18, 1, 1819, 1 }
tbGuoQing2012.ITEMID_HUILIUAWARD_SMALL = { 18, 1, 1818, 1 }
tbGuoQing2012.ITEMID_HUILIUAWARD_CARD = { 18, 1, 1820, 1 } -- 月饼收集册
tbGuoQing2012.ITEMID_HUILIU_FINALAWARD = { 18, 1, 1821, 1 }
tbGuoQing2012.IBSHOP_HUILIUAWARD_FINALAWARD = 630
tbGuoQing2012.ITEMID_EVENT = { -- 免费道具ID，奇珍阁道具ID, 付费道具ID
  [1] = { { 18, 1, 1807, 1 }, 627, { 18, 1, 1807, 2 } },
  [2] = { { 18, 1, 1808, 1 }, 628, { 18, 1, 1808, 2 } },
  [3] = { { 18, 1, 1809, 1 }, 629, { 18, 1, 1809, 2 } },
}

tbGuoQing2012.ITEMID_PET = { 18, 1, 1730, 11 } -- 7天跟宠
tbGuoQing2012.ITEMID_EXTENDAWARD = {
  [1] = { [0] = { 1, 12, 69, 4 }, [1] = { 1, 12, 69, 4 }, [2] = 30 * 24 * 3600 },
  [2] = { [0] = { 1, 13, 178, 10 }, [1] = { 1, 13, 179, 10 }, [2] = 14 * 24 * 3600 },
}
-- 收到的月饼奖励
tbGuoQing2012.ITEMID_AWARD_MOONCAKE = { 18, 1, 1810, 1 }

-- 步骤奖励
tbGuoQing2012.ITEMID_AWARD_STEP = { { 18, 1, 1811, 1 }, { 18, 1, 1811, 2 } }

-- 国庆锦盒的奖励
tbGuoQing2012.AWARD_VALUE_BOX = {
  [1] = 100000,
  [2] = 400000,
}

-- 好友赠送的免费月饼
tbGuoQing2012.AWARD_VALUE_FREE_MOONCAKE = 10000
-- 帮忙点火的绑银奖励
tbGuoQing2012.AWARD_VALUE_HELP_IGNITE = 20000

-- 回流开卡基础奖励(绑金范围)
tbGuoQing2012.AWARD_VALUE_OPEN_CARD = { 200, 800 }

-- 最终大奖的概率和值
tbGuoQing2012.AWARD_VALUE_FINALAWARD = {
  [1] = { 85, 1, 5888 },
  [2] = { 15, 2, { { 18, 1, 1251, 1 }, { 18, 1, 1251, 2 }, { 18, 1, 1251, 3 }, { 18, 1, 1251, 4 }, { 18, 1, 1251, 5 }, { 18, 1, 1251, 7 } } },
}
-- npc id
tbGuoQing2012.NPCID_LANTERN = { [1] = 11124, [2] = 11125 }
tbGuoQing2012.NPCID_FIREWORKS = { [1] = 11126, [2] = 11127 }

tbGuoQing2012.SKILLID_FIREWORKS = { [1] = 2478, [2] = 1636 }

tbGuoQing2012.MAX_LANTERN_RANGE = 10
tbGuoQing2012.INTERVAL_IGNITEFIREWORKS = 4 -- 烟花点燃间隔
tbGuoQing2012.MAX_DAY_RECEIVE_CAKE_COUNT = 10 -- 每天最多收10个月饼
tbGuoQing2012.MAX_DAY_HELP_IGNITE_COUNT = 10 -- 每天最多收10次点烟花奖励
tbGuoQing2012.RAND_AWARD_PET = 5 -- 随机跟宠的概率， 花钱的才能随,百分比
tbGuoQing2012.RAND_AWARD_EXTEND = 5 -- 随机面具，马牌的概率,千分比

tbGuoQing2012.HUANDUGUOQING_OPENDAY = {
  [1] = 20120928,
  [2] = 20121001,
  [3] = 20121004,
  [4] = 20121008,
  [5] = 20121009,
}

tbGuoQing2012.HUANDUGUOQING_CARDNAME = {
  [1] = "欢度国庆·一马当先",
  [2] = "欢度国庆·两全其美",
  [3] = "欢度国庆·三星在天",
  [4] = "欢度国庆·四海升平",
  [5] = "欢度国庆·五谷丰登",
}

-- time
tbGuoQing2012.OPEN_DAY = 20120927 -- 开启时间
tbGuoQing2012.CLOSE_DAY = 20121010 -- 结束时间

tbGuoQing2012.DAY_OPEN_TIME1 = 110000
tbGuoQing2012.DAY_CLOSE_TIME1 = 140000
tbGuoQing2012.DAY_OPEN_TIME2 = 180000
tbGuoQing2012.DAY_CLOSE_TIME2 = 230000

-- 系统开关
function tbGuoQing2012:CheckIsOpen()
  local nDate = tonumber(GetLocalDate("%Y%m%d"))
  if nDate < self.OPEN_DAY or nDate > self.CLOSE_DAY then
    return 0
  end
  return self.IS_OPEN
end
