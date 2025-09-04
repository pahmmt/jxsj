if not Task.tbArmyCampInstancingManager then
  Task.tbArmyCampInstancingManager = {}
  Task.tbArmyCampInstancingManager.tbSettings = {}
end
Task.tbArmyCampInstancingManager.szAnnouce = "军营副本已经开始接受报名，请80级以上的大侠们通过新手村“军营传送官”传送到“伏牛山军营”报名参加。"
Task.tbArmyCampInstancingManager.nStudioMaxCount = 20 -- 同时可以开启此FB的总数
Task.tbArmyCampInstancingManager.nInstancingMaxCount = 40 -- 同时可以开启此FB的总数
Task.tbArmyCampInstancingManager.nDailyEnterTimes = 2 -- 每天可进两次
Task.tbArmyCampInstancingManager.nMaxEnterTimes = 14 -- 最多累积14次

-- 一个等级段可能会有多个FB
local tbArmyCampInstancingSettings = {
  {
    nInstancingTemplateId = 1, -- 副本模板Id
    szName = "伏牛山后山", -- 副本名字
    szEnterMsg = "副本每逢整点接受报名，报名时间持续35分钟，需至少4名80级以上的非白名玩家在本地图组队，由队长报名。进入副本条件：\n<color=yellow>1、已成功报过名\n2、同一时间段，玩家只能进入第一个队伍开启的副本<color>",
    nMinLevel = 80, -- 等级下限
    nMaxLevel = 150, -- 等级上限
    nOpenDayLimit = 0, -- 开服天数限制
    nInstancingMapTemplateId = 557, -- FB模板Id
    nInstancingEnterLimit_D = { nTaskGroup = 2043, nTaskId = 1, nLimitValue = 4 }, -- 玩家每天可进入FB的次数的上限
    nJuQingTaskLimit_W = { nTaskGroup = 1024, nTaskId = 52, nLimitValue = 4 }, -- 玩家每周可接剧情副本任务的上限
    nDailyTaskLimit_W = { nTaskGroup = 1024, nTaskId = 51, nLimitValue = 22 }, -- 玩家每周可接日常副本任务上限
    nRegisterMapId = { nTaskGroup = 2043, nTaskId = 2 }, -- 上次注册FB的报名点地图Id
    nInstancingRemainEnterTimes = { nTaskGroup = 1025, nTaskId = 62 }, -- 剩余可进副本的次数
    nInstancingExistTime = 90 * 60, -- FB重置的时间
    tbRevivePos = { 1643, 3623 }, -- 玩家在副本内的零时重生点
    nMinPlayer = 4, -- 开启FB需要的最小玩家数
    nMaxPlayer = 6, -- FB能容纳的最大玩家数
    tbOpenHour = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23 }, -- 开启的小时
    tbOpenDuration = 35, -- 持续的分钟
    tbInstancingTimeId = { nTaskGroup = 2043, nTaskId = 4 }, -- 记录玩家上次进入此FB的小时数
    tbInstancingMapId = { nTaskGroup = 2043, nTaskId = 5 }, -- 记录玩家上次进入FB的地图Id
    tbHaveTask = { 225, 226, 227, 483, 491 }, -- 必须有这些任务才能注册和进入FB
    tbJuqingTask = { nTaskId = 483, nReferId = 696 }, -- 剧情任务TaskID，ReferID
    tbRichangTask = { nTaskId = 491, nReferId = 704 }, -- 日常任务TaskID，ReferID
    nNoPlayerDuration = 10 * 60, -- FB中没有玩家指定时间则重置
    szNoTaskMsg = "未接伏牛山副本任务！", -- 未接任务提示
  },
  {
    nInstancingTemplateId = 2, -- 副本模板Id
    szName = "百蛮山", -- 副本名字
    szEnterMsg = "副本每逢整点接受报名，报名时间持续35分钟，需至少4名80级以上的非白名玩家在本地图组队，由队长报名。进入副本条件：\n<color=yellow>1、已成功报过名\n2、同一时间段，玩家只能进入第一个队伍开启的副本<color>",
    nMinLevel = 80, -- 等级下限
    nMaxLevel = 150, -- 等级上限
    nOpenDayLimit = 0, -- 开服天数限制
    nInstancingMapTemplateId = 560, -- FB模板Id
    nInstancingEnterLimit_D = { nTaskGroup = 2043, nTaskId = 1, nLimitValue = 4 }, -- 玩家每天可进入FB的次数的上限
    nJuQingTaskLimit_W = { nTaskGroup = 1024, nTaskId = 52, nLimitValue = 4 }, -- 玩家每周可接剧情副本任务的上限
    nDailyTaskLimit_W = { nTaskGroup = 1024, nTaskId = 51, nLimitValue = 22 }, -- 玩家每周可接日常副本任务上限
    nRegisterMapId = { nTaskGroup = 2043, nTaskId = 2 }, -- 上次注册FB的报名点地图Id
    nInstancingRemainEnterTimes = { nTaskGroup = 1025, nTaskId = 62 }, -- 剩余可进副本的次数
    nInstancingExistTime = 90 * 60, -- FB重置的时间
    tbRevivePos = { 1724, 3131 }, -- 玩家在副本内的零时重生点
    nMinPlayer = 4, -- 开启FB需要的最小玩家数
    nMaxPlayer = 6, -- FB能容纳的最大玩家数
    tbOpenHour = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23 }, -- 开启的小时
    tbOpenDuration = 35, -- 持续的分钟
    tbInstancingTimeId = { nTaskGroup = 2043, nTaskId = 4 }, -- 记录玩家上次进入此FB的小时数
    tbInstancingMapId = { nTaskGroup = 2043, nTaskId = 5 }, -- 记录玩家上次进入FB的地图Id
    tbHaveTask = { 333, 334, 337, 338, 493, 492 }, -- 必须有这些任务才能注册和进入FB
    tbJuqingTask = { nTaskId = 493, nReferId = 706 }, -- 剧情任务TaskID，ReferID
    tbRichangTask = { nTaskId = 492, nReferId = 705 }, -- 日常任务TaskID，ReferID
    nNoPlayerDuration = 10 * 60, -- FB中没有玩家指定时间则重置
    szNoTaskMsg = "未接百蛮山副本任务！", -- 未接任务提示
  },
  {
    nInstancingTemplateId = 3, -- 副本模板Id
    szName = "海陵王墓", -- 副本名字
    szEnterMsg = "副本每逢整点接受报名，报名时间持续35分钟，需至少4名90级以上的非白名玩家在本地图组队，由队长报名。进入副本条件：\n<color=yellow>1、已成功报过名\n2、同一时间段，玩家只能进入第一个队伍开启的副本<color>",
    nMinLevel = 90, -- 等级下限
    nMaxLevel = 150, -- 等级上限
    nOpenDayLimit = 0, -- 开服天数限制
    nInstancingMapTemplateId = 493, -- FB模板Id
    nInstancingEnterLimit_D = { nTaskGroup = 2043, nTaskId = 1, nLimitValue = 4 }, -- 玩家每天可进入FB的次数的上限
    nJuQingTaskLimit_W = { nTaskGroup = 1024, nTaskId = 52, nLimitValue = 4 }, -- 玩家每周可接剧情副本任务的上限
    nDailyTaskLimit_W = { nTaskGroup = 1024, nTaskId = 51, nLimitValue = 22 }, -- 玩家每周可接日常副本任务上限
    nRegisterMapId = { nTaskGroup = 2043, nTaskId = 2 }, -- 上次注册FB的报名点地图Id
    nInstancingRemainEnterTimes = { nTaskGroup = 1025, nTaskId = 62 }, -- 剩余可进副本的次数
    nInstancingExistTime = 90 * 60, -- FB重置的时间
    tbRevivePos = { 1586, 3157 }, -- 玩家在副本内的零时重生点
    nMinPlayer = 4, -- 开启FB需要的最小玩家数
    nMaxPlayer = 6, -- FB能容纳的最大玩家数
    tbOpenHour = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23 }, -- 开启的小时
    tbOpenDuration = 35, -- 持续的分钟
    tbInstancingTimeId = { nTaskGroup = 2043, nTaskId = 4 }, -- 记录玩家上次进入此FB的小时数
    tbInstancingMapId = { nTaskGroup = 2043, nTaskId = 5 }, -- 记录玩家上次进入FB的地图Id
    tbHaveTask = { 363, 364, 365, 366, 367, 368, 484, 485 }, -- 必须有这些任务才能注册和进入FB
    tbJuqingTask = { nTaskId = 484, nReferId = 699 }, -- 剧情任务TaskID，ReferID
    tbRichangTask = { nTaskId = 485, nReferId = 700 }, -- 日常任务TaskID，ReferID
    nNoPlayerDuration = 10 * 60, -- FB中没有玩家指定时间则重置
    szNoTaskMsg = "未接海陵王墓副本任务！", -- 未接任务提示
  },
  {
    nInstancingTemplateId = 4, -- 副本模板Id
    szName = "鄂伦河原", -- 副本名字
    szEnterMsg = "副本每逢整点接受报名，报名时间持续35分钟，需至少4名100级以上的非白名玩家在本地图组队，由队长报名。进入副本条件：\n<color=yellow>1、已成功报过名\n2、同一时间段，玩家只能进入第一个队伍开启的副本<color>",
    nMinLevel = 100, -- 等级下限
    nMaxLevel = 150, -- 等级上限
    nOpenDayLimit = 119, -- 开服天数限制
    nInstancingMapTemplateId = 2152, -- FB模板Id
    nInstancingEnterLimit_D = { nTaskGroup = 2043, nTaskId = 1, nLimitValue = 4 }, -- 玩家每天可进入FB的次数的上限
    nJuQingTaskLimit_W = { nTaskGroup = 1024, nTaskId = 52, nLimitValue = 4 }, -- 玩家每周可接剧情副本任务的上限
    nDailyTaskLimit_W = { nTaskGroup = 1024, nTaskId = 51, nLimitValue = 22 }, -- 玩家每周可接日常副本任务上限
    nRegisterMapId = { nTaskGroup = 2043, nTaskId = 2 }, -- 上次注册FB的报名点地图Id
    nInstancingRemainEnterTimes = { nTaskGroup = 1025, nTaskId = 62 }, -- 剩余可进副本的次数
    nInstancingExistTime = 90 * 60, -- FB重置的时间
    tbRevivePos = { 1787, 3463 }, -- 玩家在副本内的零时重生点
    nMinPlayer = 4, -- 开启FB需要的最小玩家数
    nMaxPlayer = 6, -- FB能容纳的最大玩家数
    tbOpenHour = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23 }, -- 开启的小时
    tbOpenDuration = 35, -- 持续的分钟
    tbInstancingTimeId = { nTaskGroup = 2043, nTaskId = 4 }, -- 记录玩家上次进入此FB的小时数
    tbInstancingMapId = { nTaskGroup = 2043, nTaskId = 5 }, -- 记录玩家上次进入FB的地图Id
    tbHaveTask = { 494, 495 }, -- 必须有这些任务才能注册和进入FB
    tbJuqingTask = { nTaskId = 495, nReferId = 707 }, -- 剧情任务TaskID，ReferID
    tbRichangTask = { nTaskId = 494, nReferId = 708 }, -- 日常任务TaskID，ReferID
    nNoPlayerDuration = 10 * 60, -- FB中没有玩家指定时间则重置
    szNoTaskMsg = "未接鄂伦河原副本任务！", -- 未接任务提示
  },
}

for _, tbInstaingSetting in ipairs(tbArmyCampInstancingSettings) do
  assert(not Task.tbArmyCampInstancingManager.tbSettings[tbInstaingSetting.nInstancingTemplateId]) -- 确保没有重复的Id
  Task.tbArmyCampInstancingManager.tbSettings[tbInstaingSetting.nInstancingTemplateId] = tbInstaingSetting
end
