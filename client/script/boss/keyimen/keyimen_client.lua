-------------------------------------------------------
-- 文件名　：keyimen_client.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2012-08-22 11:31:58
-- 文件描述：
-------------------------------------------------------

if not MODULE_GAMECLIENT then
  return 0
end

-- 动态任务
Keyimen.TASK_MAIN_ID = 60002

-- 任务变量
Keyimen.TASK_GID = 2191 -- 任务变量组
Keyimen.TASK_STATE = 16 -- 任务状态
Keyimen.TASK_CAMP = 17 -- 任务阵营

-- 帮会任务完成变量
Keyimen.TASK_FINISH = {
  [1] = 6,
  [2] = 7,
  [3] = 8,
  [4] = 9,
  [5] = 10,
}

-- 帮会任务目标变量
Keyimen.TASK_TARGET = {
  [1] = 11,
  [2] = 12,
  [3] = 13,
  [4] = 14,
  [5] = 15,
}

-- 常量定义
Keyimen.FINAL_DRAGON = 12 -- 最后一个柱子索引
Keyimen.AWARD_EXP = 8000000 -- 800w经验
Keyimen.BASE_SALARY = 1500 -- 基础工资

-- boss list
Keyimen.NPC_BOSS_LIST = {
  -- 西夏boss
  [1] = {
    nBossId = 10028,
    nDragonId = 11095,
    szDragonName = "尾宿·夏",
  },

  -- 蒙古boss
  [2] = {
    nBossId = 10038,
    nDragonId = 11107,
    szDragonName = "尾宿·蒙",
  },
}

-- 幽玄龙柱
Keyimen.NPC_DRAGON_LIST = {
  [1] = {
    [1] = { nNpcId = 11084, tbPos = { 2148, 1568, 3176 }, szName = "火蛇·夏" },
    [2] = { nNpcId = 11085, tbPos = { 2148, 1759, 3228 }, szName = "水猿·夏" },
    [3] = { nNpcId = 11086, tbPos = { 2148, 1876, 3188 }, szName = "木蛟·夏" },
    [4] = { nNpcId = 11087, tbPos = { 2148, 1742, 2929 }, szName = "土蝠·夏" },
    [5] = { nNpcId = 11088, tbPos = { 2148, 1878, 2923 }, szName = "金牛·夏" },
    [6] = { nNpcId = 11089, tbPos = { 2148, 1864, 3076 }, szName = "命轨·夏" },
    [7] = { nNpcId = 11090, tbPos = { 2147, 1797, 3664 }, szName = "天尊·夏" },
    [8] = { nNpcId = 11091, tbPos = { 2147, 1925, 3611 }, szName = "地奎·夏" },
    [9] = { nNpcId = 11092, tbPos = { 2147, 1992, 3467 }, szName = "月乌·夏" },
    [10] = { nNpcId = 11093, tbPos = { 2147, 1885, 3330 }, szName = "日冠·夏" },
    [11] = { nNpcId = 11094, tbPos = { 2147, 1747, 3277 }, szName = "星尘·夏" },
  },
  [2] = {
    [1] = { nNpcId = 11096, tbPos = { 2149, 1675, 3467 }, szName = "火蛇·蒙" },
    [2] = { nNpcId = 11097, tbPos = { 2149, 1706, 3664 }, szName = "水猿·蒙" },
    [3] = { nNpcId = 11098, tbPos = { 2149, 1809, 3511 }, szName = "木蛟·蒙" },
    [4] = { nNpcId = 11099, tbPos = { 2149, 1801, 3321 }, szName = "土蝠·蒙" },
    [5] = { nNpcId = 11100, tbPos = { 2149, 1984, 3612 }, szName = "金牛·蒙" },
    [6] = { nNpcId = 11101, tbPos = { 2150, 1758, 3810 }, szName = "命轨·蒙" },
    [7] = { nNpcId = 11102, tbPos = { 2150, 1918, 3789 }, szName = "天尊·蒙" },
    [8] = { nNpcId = 11103, tbPos = { 2150, 1930, 3558 }, szName = "地奎·蒙" },
    [9] = { nNpcId = 11104, tbPos = { 2150, 1770, 3347 }, szName = "月乌·蒙" },
    [10] = { nNpcId = 11105, tbPos = { 2150, 1858, 3436 }, szName = "日冠·蒙" },
    [11] = { nNpcId = 11106, tbPos = { 2150, 1705, 3285 }, szName = "星尘·蒙" },
  },
}

-- 赤焰龙魂
Keyimen.NPC_DIALOG_LIST = {
  [1] = 11108,
  [2] = 11109,
  [3] = 11110,
  [4] = 11111,
  [5] = 11112,
}
