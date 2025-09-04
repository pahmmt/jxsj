-------------------------------------------------------
-- 文件名　：keyimen_task.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2012-08-22 11:31:58
-- 文件描述：
-------------------------------------------------------

if MODULE_GAMESERVER then
  Require("\\script\\boss\\keyimen\\keyimen_def.lua")
else
  Require("\\script\\boss\\keyimen\\keyimen_client.lua")
end

function Keyimen:InitFile()
  self:LoadTaskConfig()
  self:InitMainTask()
  self:InitSubTask()
end

function Keyimen:LoadTaskConfig()
  self.TaskFile = {} -- 各事件表
  self.TaskAwardFile = {} -- 奖励表
  self.TaskContent = {} -- 固定内容表：

  for nCamp, tbCamp in ipairs(self.NPC_DRAGON_LIST) do
    self.TaskFile[nCamp] = {}
    for i, tbInfo in ipairs(tbCamp) do
      local szStaticDesc = ""
      local szDynamicDesc = string.format("击败<pos=%s,%s,%s,%s>并点击龙魂", tbInfo.szName, unpack(tbInfo.tbPos))
      self.TaskFile[nCamp][i] = {}
      self.TaskFile[nCamp][i].szStaticDesc = szStaticDesc
      self.TaskFile[nCamp][i].szDynamicDesc = szDynamicDesc
    end
    local tbBoss = self.NPC_BOSS_LIST[nCamp]
    local szStaticDesc = ""
    local szDynamicDesc = string.format("击败%s并点击龙魂", tbBoss.szDragonName)
    self.TaskFile[nCamp][self.FINAL_DRAGON] = {}
    self.TaskFile[nCamp][self.FINAL_DRAGON].szStaticDesc = szStaticDesc
    self.TaskFile[nCamp][self.FINAL_DRAGON].szDynamicDesc = szDynamicDesc
  end

  self:LoadContent()
end

function Keyimen:LoadContent()
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

function Keyimen:InitMainTask()
  local nTaskId = self.TASK_MAIN_ID
  local tbTaskData = {}
  tbTaskData.nId = nTaskId
  tbTaskData.szName = "【克夷门帮会任务】"

  -- 主任务的基础属性
  local tbAttribute = {}
  tbTaskData.tbAttribute = tbAttribute

  tbAttribute["Order"] = Lib:Str2Val("linear") -- 任务流程：线性
  tbAttribute["Repeat"] = Lib:Str2Val("true") -- 是否可重做：是
  tbAttribute["Context"] = Lib:Str2Val("") -- 任务描述
  tbAttribute["Share"] = Lib:Str2Val("false") -- 是否可共享
  tbAttribute["TaskType"] = Lib:Str2Val("3") -- 任务类型：3、随机任务
  tbAttribute["AutoTrack"] = Lib:Str2Val("true") -- 自动跟踪

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

function Keyimen:NewRefer(nReferId)
  local nReferIdx = 1 -- 引用子任务索引
  local tbReferData = {}

  tbReferData.nReferId = nReferId
  tbReferData.nReferIdx = nReferIdx
  tbReferData.nTaskId = nReferId
  tbReferData.nSubTaskId = nReferId
  tbReferData.szName = "克夷门帮会任务"
  tbReferData.tbDesc = {}
  tbReferData.tbDesc.szMainDesc = "摧毁五个幽玄龙柱，释放出封印于其中的赤焰龙魂。"
  tbReferData.tbDesc.tbStepsDesc = { "" }

  tbReferData.tbVisable = self.TaskContent.tbReferData.tbVisable -- 可见条件
  tbReferData.tbAccept = self.TaskContent.tbReferData.tbAccept -- 可接条件

  tbReferData.bCanGiveUp = Lib:Str2Val("false")

  tbReferData.szGossip = "" -- 流言文字
  tbReferData.nAcceptNpcId = 0 -- 接任务npc
  tbReferData.nReplyNpcId = 0 -- 交任务npc
  tbReferData.szReplyDesc = "" -- 回复文字
  tbReferData.nBagSpaceCount = 3 -- 背包空间检查
  tbReferData.nLevel = 100 -- 角色等级
  tbReferData.szIntrDesc = ""
  tbReferData.nDegree = 1
  tbReferData.tbAwards = {
    tbFix = {
      {
        szType = "exp",
        varValue = self.AWARD_EXP,
        nSprIdx = "",
        szDesc = "经验",
      },
      {
        szType = "item",
        varValue = { 18, 1, 1800, 1 },
        nSprIdx = "",
        szDesc = "工资银锭",
        szAddParam1 = 1,
      },
      {
        szType = "item",
        varValue = { 18, 1, 1801, 1 },
        nSprIdx = "",
        szDesc = "龙锦玉匣",
        szAddParam1 = 1,
      },
      {
        szType = "item",
        varValue = { 18, 1, 1802, 1 },
        nSprIdx = "",
        szDesc = "龙影玉匣",
        szAddParam1 = 1,
      },
    },
    tbOpt = {},
    tbRand = {},
  }

  return tbReferData
end

function Keyimen:InitSubTask()
  local nSubTaskId = self.TASK_MAIN_ID
  local tbSubData = self:NewSubTask(nSubTaskId)
  Task.tbSubDatas[nSubTaskId] = tbSubData
  return tbSubData
end

function Keyimen:NewSubTask(nSubTaskId)
  local tbSubData = {}
  tbSubData.nId = nSubTaskId
  tbSubData.szName = "克夷门子任务"
  tbSubData.szDesc = ""

  tbSubData.tbSteps = {}
  tbSubData.tbExecute = {}
  tbSubData.tbStartExecute = {}
  tbSubData.tbFailedExecute = {}
  tbSubData.tbFinishExecute = {}

  -- 任务属性
  tbSubData.tbAttribute = self.TaskContent.tbSubData.tbAttribute

  -- 任务步骤
  local tbStep = {}
  table.insert(tbSubData.tbSteps, tbStep)

  -- 开始事件，这里设一个空的npc
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

function Keyimen:LoadData(nTaskId, tbTarget)
  if nTaskId == self.TASK_MAIN_ID then
    self:SyncTask(tbTarget)
  end
end

function Keyimen:SyncTask(tbTarget)
  if not Task:GetPlayerTask(me).tbTasks[self.TASK_MAIN_ID] then
    return 0
  end

  if not tbTarget then
    tbTarget = {}
    for i = 1, #self.TASK_TARGET do
      tbTarget[i] = me.GetTask(self.TASK_GID, self.TASK_TARGET[i])
    end
  end

  local nCamp = 3 - me.GetTask(self.TASK_GID, self.TASK_CAMP)

  Task:GetPlayerTask(me).tbTasks[self.TASK_MAIN_ID].tbReferData = self:NewRefer(self.TASK_MAIN_ID)
  Task:GetPlayerTask(me).tbTasks[self.TASK_MAIN_ID].tbSubData = self:NewSubTask(self.TASK_MAIN_ID)

  local tbSubTask = Task:GetPlayerTask(me).tbTasks[self.TASK_MAIN_ID].tbSubData
  local tbReferTask = Task:GetPlayerTask(me).tbTasks[self.TASK_MAIN_ID].tbReferData

  tbReferTask.tbDesc.szMainDesc = ""
  tbSubTask.szDesc = ""
  local szDescribe = "鲜血横流的战场上演永无止境的战斗，高低错落地势险峻的克夷门成了兵家必争之地 。有传说这片曾经的净土便是天下龙脉所在，有心怀不轨之徒为诅咒这片净土，阻止龙气现世，将龙柱镇于这片土地之上。龙气受激荡之下破土欲出，引来天下人士。只要摧毁龙柱，释放出封印其中的赤焰龙魂，便可获得丰厚的奖励。"
  tbReferTask.tbDesc.tbStepsDesc[1] = szDescribe

  local tbParams = {}
  for i = 1, #tbTarget do
    local nTempValue = me.GetTask(self.TASK_GID, self.TASK_FINISH[i])
    tbParams[i] = { self.TASK_GID, self.TASK_FINISH[i], nTempValue, 1, self.TaskFile[nCamp][tbTarget[i]].szStaticDesc, self.TaskFile[nCamp][tbTarget[i]].szDynamicDesc }
  end

  tbSubTask.tbSteps[1].szAwardDesc = ""
  tbSubTask.tbSteps[1].tbExecute = {}
  local tbTargets = tbSubTask.tbSteps[1].tbTargets
  local tbTagLib = Task.tbTargetLib["RequireTaskValue"]
  assert(tbTagLib, 'Target["RequireTaskValue"] not found!!!')

  for i = 1, #tbTarget do
    local tbTarget = Lib:NewClass(tbTagLib)
    tbTarget:Init(unpack(tbParams[i]))
    tbTargets[i] = tbTarget
  end

  if MODULE_GAMESERVER then
    me.CallClientScript({ "Keyimen:SyncTask", tbTarget })
  end
end

function Keyimen:OnAccept()
  if MODULE_GAMESERVER then
    local nCamp = Keyimen:GetPlayerTongCamp(me)
    local tbTarget = Keyimen:GetPlayerTongTask(me)
    for i, nValue in ipairs(tbTarget) do
      me.SetTask(self.TASK_GID, self.TASK_TARGET[i], nValue)
    end
    me.SetTask(self.TASK_GID, self.TASK_CAMP, nCamp)
    local szBlackMsg = "神秘之音：“年轻人，我等你好久了，传说中龙气出则天下定。我纵观百年天象却看不透这未来，龙柱是恢复这片净土昔日安宁之所在，你愿意抛开欲望还这克夷门一片净土么？”<end>"
    szBlackMsg = szBlackMsg .. "<playername>：“我愿意！侠之大者为国民！”"
    TaskAct:Talk(szBlackMsg)
    me.SetTask(self.TASK_GID, self.TASK_STATE, 1)
    self:LoadData(self.TASK_MAIN_ID, tbTarget)
  end
end

function Keyimen:DoAccept(tbTask, nTaskId, nReferId)
  if nTaskId == self.TASK_MAIN_ID and nReferId == self.TASK_MAIN_ID then
    self:OnAccept()
  end
end
