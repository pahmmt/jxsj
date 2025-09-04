-- 文件名　：weekendfish_file.lua
-- 创建者　：huangxiaoming
-- 创建时间：2011-08-05 19:18:10
-- 描  述  ：

if MODULE_GAMESERVER then
  Require("\\script\\task\\weekendfish\\weekendfish_def.lua")
else
  Require("\\script\\task\\weekendfish\\weekendfish_cdef.lua")
end

function WeekendFish:InitFile()
  self:LoadTaskConfig()
  self:InitMainTask()
  self:InitSubTask()
end

function WeekendFish:LoadTaskConfig()
  self.TaskFile = {} -- 各事件表
  self.TaskAwardFile = {} -- 奖励表
  self.TaskContent = {} --固定内容表：
  self.tbAreaInfo = {} -- 区域对应鱼群ID表
  self.tbAreaName = {}
  local tbFile = Lib:LoadTabFile(self.FILE_TASK_INI_PATH)
  if not tbFile then
    print("Error: WeekendFish:LoadTaskConfig loadtabfile failure, path:" .. self.FILE_TASK_INI_PATH)
    return
  end
  for i = 2, #tbFile do
    local nFishId = tonumber(tbFile[i].FishID) or 0
    local szFishName = tbFile[i].FishName or ""
    local nAreaId = tonumber(tbFile[i].AreaId) or 0
    local szAreaName = tbFile[i].AreaName or ""
    local szStaticDesc = tbFile[i].StaticDesc or ""
    local szDynamicDesc = tbFile[i].DynamicDesc or ""
    local szDetailDesc = string.format("%s生长在%s，请%s", szFishName, szAreaName, string.format(szStaticDesc, 0, self.TASK_NEED_FISH_NUM))

    self.TaskFile[nFishId] = {}
    self.TaskFile[nFishId].szFishName = szFishName
    self.TaskFile[nFishId].nAreaId = nAreaId
    self.TaskFile[nFishId].szAreaName = szAreaName
    self.TaskFile[nFishId].szStaticDesc = szStaticDesc
    self.TaskFile[nFishId].szDynamicDesc = szDynamicDesc
    self.TaskFile[nFishId].szDetailDesc = szDetailDesc
    self.tbAreaInfo[nAreaId] = self.tbAreaInfo[nAreaId] or {}
    self.tbAreaInfo[nAreaId].szName = szAreaName
    self.tbAreaInfo[nAreaId].tbFishList = self.tbAreaInfo[nAreaId].tbFishList or {}
    table.insert(self.tbAreaInfo[nAreaId].tbFishList, nFishId)
  end
  self:LoadContent()
end

function WeekendFish:LoadContent()
  self.TaskContent.tbReferData = {}
  local tbVisable = {}
  local tbAccept = {}
  self.TaskContent.tbReferData.tbVisable = tbVisable
  self.TaskContent.tbReferData.tbAccept = tbAccept

  self.TaskContent.tbSubData = {}
  local tbAttribute = {}
  tbAttribute.tbDialog = {}
  tbAttribute.tbDialog["Start"] = { szMsg = "" }
  tbAttribute.tbDialog["Procedure"] = { szMsg = "" }
  tbAttribute.tbDialog["Error"] = { szMsg = "" }
  tbAttribute.tbDialog["Prize"] = { szMsg = "" }
  tbAttribute.tbDialog["End"] = { szMsg = "" }
  self.TaskContent.tbSubData.tbAttribute = tbAttribute
end

function WeekendFish:InitMainTask()
  local nTaskId = self.TASK_MAIN_ID
  local tbTaskData = {}
  tbTaskData.nId = nTaskId
  tbTaskData.szName = self.TXT_NAME

  -- 主任务的基础属性
  local tbAttribute = {}
  tbTaskData.tbAttribute = tbAttribute

  tbAttribute["Order"] = Lib:Str2Val("linear") -- 任务流程：线性
  tbAttribute["Repeat"] = Lib:Str2Val("true") -- 是否可重做：是
  tbAttribute["Context"] = Lib:Str2Val("") -- 任务描述
  tbAttribute["Share"] = Lib:Str2Val("false") -- 是否可共享
  tbAttribute["TaskType"] = Lib:Str2Val("3") -- 任务类型：3、随机任务
  tbAttribute["AutoTrack"] = Lib:Str2Val("true")

  -- 主任务下的子任务
  local tbReferIds = {}
  tbTaskData.tbReferIds = tbReferIds

  local nReferId = nTaskId -- 引用子任务Id
  local nReferIdx = 1 -- 引用子任务索引
  tbReferIds[nReferIdx] = nReferId
  -- 不能存在已有任务
  assert(not Task.tbReferDatas[nReferId])
  Task.tbReferDatas[nReferId] = self:NewRefer(nReferId)
  Task.tbTaskDatas[self.TASK_MAIN_ID] = tbTaskData
end

function WeekendFish:NewRefer(nReferId)
  local nReferIdx = 1 -- 引用子任务索引
  local tbReferData = {}

  tbReferData.nReferId = nReferId
  tbReferData.nReferIdx = nReferIdx
  tbReferData.nTaskId = nReferId
  tbReferData.nSubTaskId = nReferId
  tbReferData.szName = "钓鱼活动"
  tbReferData.tbDesc = {}
  tbReferData.tbDesc.szMainDesc = "每个周六和周日你都可以从我这里接取钓鱼任务，完成钓鱼任务将获得大量的经验。每天可以钓50条鱼，将钓到的鱼交给我，你将会获得有丰厚的奖励哦。<enter>钓鱼的必备用具有<color=green>鱼竿、鱼饵、水产秘术<color>这些东西你可以到我的渔具店里瞧瞧。"
  tbReferData.tbDesc.tbStepsDesc = { "" }

  tbReferData.tbVisable = self.TaskContent.tbReferData.tbVisable -- 可见条件
  tbReferData.tbAccept = self.TaskContent.tbReferData.tbAccept -- 可接条件

  tbReferData.nAcceptNpcId = 0 --self.ACCEPT_NPC_ID;

  tbReferData.bCanGiveUp = Lib:Str2Val("false")

  tbReferData.szGossip = "" -- 流言文字
  tbReferData.nReplyNpcId = 0 --self.ACCEPT_NPC_ID;	-- 回复 NPC
  tbReferData.szReplyDesc = "" --"请找新手村秦洼处领取奖励";		-- 回复文字
  tbReferData.nBagSpaceCount = 1 -- 背包空间检查
  tbReferData.nLevel = 50
  tbReferData.szIntrDesc = ""
  tbReferData.nDegree = 1
  tbReferData.tbAwards = {
    tbFix = {},
    tbOpt = {},
    tbRand = {},
  }
  return tbReferData
end

function WeekendFish:InitSubTask()
  local nSubTaskId = self.TASK_MAIN_ID
  local tbSubData = self:NewSubTask(nSubTaskId)
  Task.tbSubDatas[nSubTaskId] = tbSubData
  return tbSubData
end

function WeekendFish:NewSubTask(nSubTaskId)
  local tbSubData = {}
  tbSubData.nId = nSubTaskId
  tbSubData.szName = self.TEXT_NAME
  tbSubData.szDesc = ""

  tbSubData.tbSteps = {}
  tbSubData.tbExecute = {}
  tbSubData.tbStartExecute = {}
  tbSubData.tbFailedExecute = {}
  tbSubData.tbFinishExecute = {}

  -- 任务属性
  tbSubData.tbAttribute = self.TaskContent.tbSubData.tbAttribute

  -- 步骤
  local tbStep = {}
  table.insert(tbSubData.tbSteps, tbStep)

  -- 开始事件，这里设一个空的 npc
  local tbEvent = {}
  tbStep.tbEvent = tbEvent
  tbEvent.nType = 1
  tbEvent.nValue = 0

  -- 任务目标
  local tbTargets = {}
  tbStep.tbTargets = tbTargets

  -- 步骤条件
  tbStep.tbJudge = {}
  tbStep.tbExecute = {}
  return tbSubData
end

function WeekendFish:LoadDate(nTaskId, tbTaskList)
  if nTaskId == self.TASK_MAIN_ID then
    self:SyncTask(tbTaskList)
  end
end

function WeekendFish:SyncTask(tbTaskList)
  if not Task:GetPlayerTask(me).tbTasks[self.TASK_MAIN_ID] then
    return 0
  end

  if not tbTaskList then
    tbTaskList = {}
    for i = 1, self.FISH_TASK_NUM do
      tbTaskList[i] = me.GetTask(self.TASK_GROUP, self.TASK_FISH_ID1 + i - 1)
    end
  else
    for i = 1, self.FISH_TASK_NUM do
      me.SetTask(self.TASK_GROUP, self.TASK_FISH_ID1 + i - 1, tbTaskList[i])
    end
  end
  Task:GetPlayerTask(me).tbTasks[self.TASK_MAIN_ID].tbReferData = self:NewRefer(self.TASK_MAIN_ID)
  Task:GetPlayerTask(me).tbTasks[self.TASK_MAIN_ID].tbSubData = self:NewSubTask(self.TASK_MAIN_ID)
  local TbSubTask = Task:GetPlayerTask(me).tbTasks[self.TASK_MAIN_ID].tbSubData
  local TBReferTask = Task:GetPlayerTask(me).tbTasks[self.TASK_MAIN_ID].tbReferData
  TBReferTask.tbDesc.szMainDesc = ""
  TbSubTask.szDesc = ""
  local szDescribe = "西塞山前白鹭飞，桃花流水鳜鱼肥。青箬笠，绿蓑衣，斜风细雨不须归。钓鱼是一种乐趣，钓鱼是一种精神。现在正是鱼肥水美的季节，还望各位侠客在百忙之中抽身为我钓些鱼儿来，我秦洼一定会进我所能回馈大家的哦！\n"
  szDescribe = szDescribe .. "任务完成后找各新手村的<color=yellow>秦洼<color>领取奖励。\n"
  szDescribe = szDescribe .. string.format("<color=green>今日幸运鱼：<color><color=yellow>%s %s %s<color>\n", self.TaskFile[tbTaskList[1]].szFishName, self.TaskFile[tbTaskList[2]].szFishName, self.TaskFile[tbTaskList[3]].szFishName)
  szDescribe = szDescribe .. "<color=yellow>任务奖励:<color> \n<color=green>1.海量经验\n2.水产证书(可使当日的钓鱼总奖励翻倍)\n3.秦洼的祝福（每周完成两次钓鱼任务在下周接取任务时自动获得，可提高钓鱼幸运值）<color>"
  TBReferTask.tbDesc.tbStepsDesc[1] = szDescribe
  local tbParams = {}
  for i = 1, self.FISH_TASK_NUM do
    local nTempValue = me.GetTask(self.TASK_GROUP, self.TASK_TARGET1 + i - 1)
    tbParams[i] = {
      self.TASK_GROUP,
      self.TASK_TARGET1 + i - 1,
      nTempValue,
      self.TASK_NEED_FISH_NUM,
      self.TaskFile[tbTaskList[i]].szStaticDesc,
      self.TaskFile[tbTaskList[i]].szDynamicDesc,
      1,
    }
  end
  TbSubTask.tbSteps[1].szAwardDesc = ""
  TbSubTask.tbSteps[1].tbExecute = {}
  local tbTargets = TbSubTask.tbSteps[1].tbTargets
  local tbTagLib = Task.tbTargetLib["RequireTaskValue"]
  assert(tbTagLib, 'Target["RequireTaskValue"] not found!!!')
  for i = 1, self.FISH_TASK_NUM do
    local tbTarget = Lib:NewClass(tbTagLib)
    tbTarget:Init(unpack(tbParams[i]))
    tbTargets[i] = tbTarget
  end
  if MODULE_GAMESERVER then
    me.CallClientScript({ "WeekendFish:SyncTask", tbTaskList })
  end
end
