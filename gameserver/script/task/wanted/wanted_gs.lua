--官府通缉任务
--孙多良
--2008.08.05
Require("\\script\\task\\wanted\\wanted_def.lua")

--测试使用,完成任务
function Wanted:_Test_FinishTask()
  if Task:GetPlayerTask(me).tbTasks[Wanted.TASK_MAIN_ID] then
    for _, tbCurTag in ipairs(Task:GetPlayerTask(me).tbTasks[Wanted.TASK_MAIN_ID].tbCurTags) do
      if tbCurTag.OnKillNpc then
        if tbCurTag:IsDone() then
          --杀死Boss玩家的队友身上有任务完成时调用
          if me.GetTask(Wanted.TASK_GROUP, Wanted.TASK_FINISH) == 1 then
            me.SetTask(Wanted.TASK_GROUP, Wanted.TASK_FINISH, 0)
          end
          break
        end
        tbCurTag.nCount = tbCurTag.nCount + 1
        local tbSaveTask = tbCurTag.tbSaveTask
        if MODULE_GAMESERVER and tbSaveTask then -- 自行同步到客户端，要求客户端刷新
          tbCurTag.me.SetTask(tbSaveTask.nGroupId, tbSaveTask.nStartTaskId, tbCurTag.nCount, 1)
          KTask.SendRefresh(tbCurTag.me, tbCurTag.tbTask.nTaskId, tbCurTag.tbTask.nReferId, tbSaveTask.nGroupId)
        end

        if tbCurTag:IsDone() then -- 本目标是一旦达成后不会失效的
          tbCurTag.me.Msg("目标达成：" .. tbCurTag:GetStaticDesc())
          tbCurTag.tbTask:OnFinishOneTag()
        end

        --杀死Boss玩家的队友身上有任务完成时调用
        if me.GetTask(Wanted.TASK_GROUP, Wanted.TASK_FINISH) == 1 then
          me.SetTask(Wanted.TASK_GROUP, Wanted.TASK_FINISH, 0)
        end
      end
    end
  end
end

function Wanted:GetLevelGroup(nLevel)
  if nLevel < self.LIMIT_LEVEL then
    return 0
  end
  local nMax = 0
  for ni, nLevelSeg in ipairs(self.LevelGroup) do
    if nLevel <= nLevelSeg then
      return ni
    end
    nMax = ni
  end
  return nMax
end

function Wanted:GetTask(nTaskId)
  return me.GetTask(self.TASK_GROUP, nTaskId)
end

function Wanted:SetTask(nTaskId, nValue)
  return me.DirectSetTask(self.TASK_GROUP, nTaskId, nValue)
end

function Wanted:Check_Task()
  if me.nLevel < self.LIMIT_LEVEL then
    return 3
  end
  if self:GetTask(self.TASK_FIRST) == 0 then
    if self:GetTask(self.TASK_COUNT) == 0 then
      self:SetTask(self.TASK_COUNT, self.Day_COUNT)
    end
    self:SetTask(self.TASK_FIRST, 1)
  end
  --if self:GetTask(self.TASK_ACCEPT_ID) <= 0 then
  --	return 0;
  --end
  local tbTask = Task:GetPlayerTask(me).tbTasks[self.TASK_MAIN_ID]
  if not tbTask then
    --self:SetTask(self.TASK_ACCEPT_ID, 0);
    return 0 --未接任务
  end

  if self:CheckTaskFinish() == 1 then
    return 1 --已完成
  else
    return 2 --未完成
  end
  return 0
end

function Wanted:CheckLimitTask()
  local nCurTime = tonumber(GetLocalDate("%H%M"))
  if EventManager.IVER_bOpenWantedLimitTime == 1 then
    local szNoOpenMsg = string.format("刑部捕头：大侠，衙门现在已经关门休息了，开门时间在%s，关门时间在%s，请在开门的时候再过来接受任务吧。", Lib:HourMinNumber2TimeDesc(self.DEF_DATE_START), Lib:HourMinNumber2TimeDesc(self.DEF_DATE_END))
    if self.DEF_DATE_START > self.DEF_DATE_END then
      if nCurTime < self.DEF_DATE_START and nCurTime > self.DEF_DATE_END then
        Dialog:Say(szNoOpenMsg)
        return 0
      end
    else
      if nCurTime < self.DEF_DATE_START or nCurTime > self.DEF_DATE_END then
        Dialog:Say(szNoOpenMsg)
        return 0
      end
    end
  end
  --if me.GetTask(1022,107) ~= 1 then
  --	Dialog:Say("刑部捕头：大侠，您必须完成50级主线任务,这样才能证明您具有能力参加缉捕任务。");
  --	return 0;
  --end

  --江湖威望判断
  if me.nPrestige < self.LIMIT_REPUTE then
    local szFailDesc = "您的江湖威望不足20点，无法接该任务。"
    Dialog:Say(szFailDesc)
    return 0
  end

  local nType = self:GetLevelGroup(me.nLevel)
  if nType <= 0 then
    Dialog:Say("刑部捕头：大侠，到您这种境界，江湖上这些小毛贼哪用得着你出手。")
    return 0
  end
  if self:GetTask(self.TASK_COUNT) <= 0 then
    Dialog:Say("刑部捕头：大侠，您今天休息一下吧，已经没有任务可接。")
    return 0
  end
  return 1
end

-- 检测任务除了交物品任务之外还有没有未完成的目标
function Wanted:CheckTaskFinish()
  local tbTask = Task:GetPlayerTask(me).tbTasks[self.TASK_MAIN_ID]

  -- 还有未完成的目标
  for _, tbCurTag in pairs(tbTask.tbCurTags) do
    if not tbCurTag:IsDone() then
      return 0
    end
  end

  -- 全部目标完成
  return 1
end

function Wanted:GetDialogSayMsg()
  local szMsg = string.format("你可以选择领取以下任务，任务等级越高，难度越大。\n\n官府通缉特权介绍：\n凡当月充值达到%d元的玩家，都可享受特权资格，将自动接取到额外的汪洋大盗，不必和其他人进行争抢任务。", self.DEF_ACTION_KIND_PAY)
  local nPay = me.GetExtMonthPay()
  if nPay >= self.DEF_ACTION_KIND_PAY then
    szMsg = szMsg .. "\n\n<color=green>★你已拥有官府通缉特权资格★<color>"
  else
    szMsg = szMsg .. "\n\n<color=red>你当月充值未达到官府通缉特权资格<color>"
  end
  szMsg = szMsg .. "\n\n<color=yellow>任务紧迫，当天接取必须当天完成。<color>"
  return szMsg
end

function Wanted:SingleAcceptTask()
  if me.GetTiredDegree1() == 2 then
    Dialog:Say("您太累了，还是休息下吧！")
    return
  end
  if self:Check_Task() ~= 0 then
    return 0
  end
  if self:CheckLimitTask() ~= 1 then
    return 0
  end
  local nType = self:GetLevelGroup(me.nLevel)
  local tbOpt = {}
  for i = 1, nType do
    if self.DEF_Adv_LEVEL[i] then
      --如果是高级大盗需按时间轴
      if TimeFrame:GetState("OpenAdvWanted") == 1 then
        table.insert(tbOpt, { string.format("%s", self.LevelGroupName[i]), self.GetRandomTask, self, i })
      end
    else
      table.insert(tbOpt, { string.format("%s", self.LevelGroupName[i]), self.GetRandomTask, self, i })
    end
  end
  table.insert(tbOpt, { "我再考虑考虑" })
  Dialog:Say(self:GetDialogSayMsg(), tbOpt)
end

function Wanted:GetRandomTask(nLevelSeg)
  if self:CheckLimitTask() ~= 1 then
    return 0
  end
  --初级大盗

  --	if nLevelSeg <= 5 then
  --		if self.TaskLevelSeg[nLevelSeg] then
  --			local nTaskCount = self:GetCurNeedTaskCount(nLevelSeg, #self.TaskLevelSeg[nLevelSeg]);
  --			local nP = MathRandom(1, nTaskCount);
  --			local nTaskId = self.TaskLevelSeg[nLevelSeg][nP];
  --			self:AcceptTask(nTaskId, nLevelSeg);
  --			return nTaskId;
  --		end
  --		return 0;
  --	end
  --
  --	--高级大盗特殊处理
  --	local nPlayerActionKind = Player:GetActionKind(me.szName);
  --	local nActionKind = Wanted.ACTION_KIND[nPlayerActionKind] or 0;
  --	if self.TaskLevelSegActionKind[nLevelSeg] and
  --		self.TaskLevelSegActionKind[nLevelSeg][nActionKind] then
  --		--local nTaskCount = self:GetCurNeedTaskCount(nLevelSeg, #self.TaskLevelSegActionKind[nLevelSeg][nActionKind]);
  --		local nTaskCount = self.DEF_ACTION_KIND[nActionKind];
  --		if nTaskCount > #self.TaskLevelSegActionKind[nLevelSeg][nActionKind] then
  --			nTaskCount = #self.TaskLevelSegActionKind[nLevelSeg][nActionKind];
  --		end
  --		local nP = MathRandom(1, nTaskCount);
  --		local nTaskId = self.TaskLevelSegActionKind[nLevelSeg][nActionKind][nP];
  --		if not nTaskId then
  --			return 0;
  --		end
  --		self:AcceptTask(nTaskId, nLevelSeg);
  --		return nTaskId;
  --	end

  local nActionKind = 1 --未充值
  if me.GetExtMonthPay() >= self.DEF_ACTION_KIND_PAY then --充值大于等于100元
    nActionKind = 0
  end
  if self.TaskLevelSegActionKind[nLevelSeg] and self.TaskLevelSegActionKind[nLevelSeg][nActionKind] then
    local nTaskCount = #self.TaskLevelSegActionKind[nLevelSeg][nActionKind]
    nTaskCount = self:GetCurNeedTaskCount(nLevelSeg, nTaskCount)
    local nP = MathRandom(1, nTaskCount)
    local nTaskId = self.TaskLevelSegActionKind[nLevelSeg][nActionKind][nP]
    if not nTaskId then
      return 0
    end
    self:AcceptTask(nTaskId, nLevelSeg)
    return nTaskId
  end
  return 0
end

function Wanted:GetCurNeedTaskCount(nLevelSeg, nMaxCount)
  -- 根据服务器情况减少任务数量，增加争夺点
  -- 跟进上周人数获得可接任务数
  local nWeekTask = Wanted:GetNeedTaskCountByLastWeek(nLevelSeg)
  local nTimeTask = Wanted:GetNeedTaskCountByTimeFrame(nLevelSeg)
  local nTaskCount = nWeekTask
  if nTimeTask < nTaskCount then
    nTaskCount = nTimeTask
  end
  if nTaskCount > nMaxCount then
    nTaskCount = nMaxCount
  end
  if nTaskCount < 1 then
    nTaskCount = 1
  end

  if nLevelSeg < 6 and EventManager.IVER_bOpenWantedLimit == 1 then
    nTaskCount = nMaxCount
  end

  return nTaskCount
end

function Wanted:GetNeedTaskCountByLastWeek(nLevelSeg)
  local nLastWeekCount = KGblTask.SCGetDbTaskInt(self.DEF_SAVE_TASK[nLevelSeg][2])
  local nFlag = -1
  local nTaskCount = 0
  if nLastWeekCount <= 0 then
    -- 第一次取最大值
    for _, tbParam in pairs(self.TaskWeekSeg[nLevelSeg]) do
      if nTaskCount < tbParam.nTaskCount then
        nTaskCount = tbParam.nTaskCount
      end
    end
    return nTaskCount
  end

  for _, tbParam in pairs(self.TaskWeekSeg[nLevelSeg]) do
    if nFlag < tbParam.nLastWeekSum and nLastWeekCount >= tbParam.nLastWeekSum then
      nTaskCount = tbParam.nTaskCount
      nFlag = tbParam.nLastWeekSum
    end
  end
  return nTaskCount
end

function Wanted:GetNeedTaskCountByTimeFrame(nLevelSeg)
  local nCurOpenServerDay = TimeFrame:GetServerOpenDay()
  local nFlag = -1
  local nTaskCount = 0
  for _, tbParam in pairs(self.TaskTimeSeg[nLevelSeg]) do
    if nFlag < tbParam.nTimeDay and nCurOpenServerDay >= tbParam.nTimeDay then
      nTaskCount = tbParam.nTaskCount
      nFlag = tbParam.nTimeDay
    end
  end
  return nTaskCount
end

function Wanted:AcceptTask(nTaskId, nLevelSeg)
  if self:Check_Task() ~= 0 then
    return 0
  end
  if self:CheckLimitTask() ~= 1 then
    return 0
  end
  Task:DoAccept(self.TASK_MAIN_ID, nTaskId)
  self:SetTask(self.TASK_ACCEPT_ID, nTaskId)
  self:SetTask(self.TASK_LEVELSEG, nLevelSeg)
  self:SetTask(self.TASK_FINISH, 1)
  self:SetTask(self.TASK_COUNT, self:GetTask(self.TASK_COUNT) - 1)
  self:SetTask(self.TASK_ACCEPT_TIME, GetTime())
  local nRLevel = self:GetTask(self.TASK_100SEG_RANLEVEL)
  if nRLevel == 0 then
    local nRLevel = MathRandom(1, 5)
    self:SetTask(self.TASK_100SEG_RANLEVEL, nRLevel)
  end
  -- 记录参加次数
  local nNum = me.GetTask(StatLog.StatTaskGroupId, 4) + 1
  me.SetTask(StatLog.StatTaskGroupId, 4, nNum)

  -- 记录玩家参加官府通缉的次数
  Stats.Activity:AddCount(me, Stats.TASK_COUNT_WANTED, 1)

  --接任务log
  DataLog:WriteELog(me.szName, 3, 1, nTaskId)
end

function Wanted:CaptainAcceptTask()
  local tbTeamMembers, nMemberCount = me.GetTeamMemberList()
  local tbPlayerName = {}
  if not tbTeamMembers then
    Dialog:Say("刑部捕头：你当前并没有在任何队伍中哦！")
    return
  end
  if self:Check_Task() ~= 0 then
    return 0
  end
  if self:CheckLimitTask() ~= 1 then
    return 0
  end
  local nType = self:GetLevelGroup(me.nLevel)
  local tbOpt = {}
  for i = 1, nType do
    if self.DEF_Adv_LEVEL[i] then
      --如果是高级大盗需按时间轴
      if TimeFrame:GetState("OpenAdvWanted") == 1 then
        table.insert(tbOpt, { string.format("%s", self.LevelGroupName[i]), self.TeamAcceptTask, self, i })
      end
    else
      table.insert(tbOpt, { string.format("%s", self.LevelGroupName[i]), self.TeamAcceptTask, self, i })
    end
  end
  table.insert(tbOpt, { "我再考虑考虑" })
  Dialog:Say(self:GetDialogSayMsg(), tbOpt)
end

function Wanted:TeamAcceptTask(nLevelSeg, nFlag)
  local tbTeamMembers, nMemberCount = me.GetTeamMemberList()
  local tbPlayerName = {}
  if not tbTeamMembers then
    Dialog:Say("刑部捕头：你当前并没有在任何队伍中哦！")
    return
  end
  local nTeamTaskId = 0
  if nFlag == 1 then
    nTeamTaskId = self:GetRandomTask(nLevelSeg)
  end
  local nOldIndex = me.nPlayerIndex
  local nCaptainLevel = me.nLevel -- 队长的等级
  local szCaptainName = me.szName -- 队长的名字

  for i = 1, nMemberCount do
    if nOldIndex ~= tbTeamMembers[i].nPlayerIndex then
      Setting:SetGlobalObj(tbTeamMembers[i])
      if self:Check_Task() == 0 and self:CheckLimitTask() == 1 and self:GetLevelGroup(me.nLevel) >= nLevelSeg then
        if nFlag == 1 and nTeamTaskId > 0 then
          local szMsg = string.format("刑部捕头：你所在队伍的队长<color=yellow>%s<color>想要与你共享官府通缉任务：%s级任务 - <color=green>缉拿江洋大盗%s<color>，你愿意接受吗？", szCaptainName, (40 + nLevelSeg * 10), self.TaskFile[nTeamTaskId].szTaskName)
          local tbOpt = {
            { "是", self.AcceptTask, self, nTeamTaskId, nLevelSeg },
            { "否" },
          }
          Dialog:Say(szMsg, tbOpt)
        else
          table.insert(tbPlayerName, { tbTeamMembers[i].nPlayerIndex, tbTeamMembers[i].szName })
        end
      end
      Setting:RestoreGlobalObj()
    end
  end

  if nFlag == 1 then
    return
  end

  if #tbPlayerName <= 0 then
    Dialog:Say("刑部捕头：当前并没有符合能与你一起共享任务条件的队友，队内共享任务必须符合以下条件：<color=yellow>\n\n    队员等级符合队长当前接的任务的条件需求\n    队员未接官府通缉任务\n    队员当天可接任务限额未满\n    队员在队长邻近的范围\n    队员已完成50级主线任务\n    队员江湖威望达到20点<color>\n")
    return
  end

  local szMembersName = "\n"

  for i = 1, #tbPlayerName do
    szMembersName = szMembersName .. "<color=yellow>" .. tbPlayerName[i][2] .. "<color>\n"
  end
  local szMsg = string.format("刑部捕头：现在符合能与你共享任务的队友有：\n%s\n你想和队友一起共享你接到的任务么？", szMembersName)
  local tbOpt = {
    { "是的", self.TeamAcceptTask, self, nLevelSeg, 1 },
    { "不了" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function Wanted:CancelTask(nFlag)
  if self:Check_Task() ~= 2 then
    return 0
  end
  if nFlag == 1 then
    self:SetTask(self.TASK_ACCEPT_ID, 0)
    self:SetTask(self.TASK_FINISH, 0)
    self:SetTask(self.TASK_ACCEPT_TIME, 0)
    self:SetTask(self.TASK_100SEG_RANLEVEL, 0)
    Task:CloseTask(self.TASK_MAIN_ID, "giveup")
    return
  end
  local szMsg = "刑部捕头：您现在要放弃当前的通缉任务吗？确定要放弃吗？"
  local tbOpt = {
    { "我确定要取消", self.CancelTask, self, 1 },
    { "我再考虑考虑" },
  }
  Dialog:Say(szMsg, tbOpt)
  return
end

function Wanted:FinishTask()
  if self:Check_Task() ~= 1 then
    return 0
  end
  self:ShowAwardDialog()
end

-- 师徒成就：官府通缉
function Wanted:GetAchievement(pPlayer)
  if not pPlayer then
    return
  end

  -- nLevle的具体数值对应等级和配置文件"\\setting\\task\\wanted\\level_group.txt"相同
  local nLevel = self:GetTask(self.TASK_LEVELSEG)
  local nAchievementId = 0
  if 1 == nLevel then
    nAchievementId = Achievement_ST.TONGJI_55
  elseif 2 == nLevel then
    nAchievementId = Achievement_ST.TONGJI_65
  elseif 3 == nLevel then
    nAchievementId = Achievement_ST.TONGJI_75
  elseif 4 == nLevel then
    nAchievementId = Achievement_ST.TONGJI_85
  elseif nLevel >= 5 then
    nAchievementId = Achievement_ST.TONGJI_95
  end

  Achievement_ST:FinishAchievement(pPlayer.nId, nAchievementId)
end

function Wanted:AwardFinish()
  if self:Check_Task() ~= 1 then
    return 0
  end
  local nTaskId = self:GetTask(self.TASK_ACCEPT_ID)
  local nTaskLevel = self.TaskFile[nTaskId].nLevelSeg
  self:SetTask(self.TASK_LEVELSEG, 0)
  self:SetTask(self.TASK_ACCEPT_ID, 0)
  self:SetTask(self.TASK_FINISH, 0)
  self:SetTask(self.TASK_100SEG_RANLEVEL, 0)
  self:SetTask(self.TASK_ACCEPT_TIME, 0)

  local tbLevel = {
    [1] = 0.6,
    [2] = 0.7,
    [3] = 0.8,
    [4] = 0.9,
    [5] = 1.0,
    [6] = 1.0,
  }
  local nMulti = tbLevel[nTaskLevel] and tbLevel[nTaskLevel] or 1
  local tbInfo = Kinsalary.EVENT_TYPE[Kinsalary.EVENT_DADAO]
  Kinsalary:AddSalary_GS(me, Kinsalary.EVENT_DADAO, tbInfo.nRate * nMulti)

  if me.GetTrainingTeacher() then -- 如果玩家的身份是徒弟，那么师徒任务当中的通缉任务次数加1
    -- local tbItem = Item:GetClass("teacher2student");
    local nNeed_Wanted = me.GetTask(Relation.TASK_GROUP, Relation.TASK_ID_SHITU_WANTED) + 1
    me.SetTask(Relation.TASK_GROUP, Relation.TASK_ID_SHITU_WANTED, nNeed_Wanted)
  end
  Task:CloseTask(self.TASK_MAIN_ID, "finish")

  --额外奖励
  local nFreeCount, tbFunExecute = SpecialEvent.ExtendAward:DoCheck("FinishWanted", me)
  SpecialEvent.ExtendAward:DoExecute(tbFunExecute)

  --完成次数累积
  local nTimes = me.GetTask(SpecialEvent.tbPJoinEventTimes.TASKGID, SpecialEvent.tbPJoinEventTimes.TASK_FINISH_WANTED)
  me.SetTask(SpecialEvent.tbPJoinEventTimes.TASKGID, SpecialEvent.tbPJoinEventTimes.TASK_FINISH_WANTED, nTimes + 1)

  -- 师徒成就：官府通缉
  self:GetAchievement(me)

  -- 增加完成次数
  GCExcute({ "Wanted:AddFinishTaskCount_GC", nTaskLevel })

  SpecialEvent.ActiveGift:AddCounts(me, 22) --完成一次大盗活跃度

  --完成Log
  DataLog:WriteELog(me.szName, 3, 4, nTaskId)
end

-- 根据选取出来的奖励表构成奖励面版
function Wanted:ShowAwardDialog()
  local tbGeneralAward = {} -- 最后传到奖励面版脚本的数据结构
  local szAwardTalk = "隆兴和议以来，各地恢复少许安宁。但近日出现不少江洋大盗，民不堪扰。为迅速安民保境，恢复治安，刑部衙门颁下通缉令，广发海捕文书，号召武林中人相助，缉拿江洋大盗，为民除害。大侠，您做的不错，这些名捕令是给您的，希望您能继续为民分忧，缉拿江洋大盗。" -- 奖励时说的话

  tbGeneralAward.tbFix = {}
  tbGeneralAward.tbOpt = {}
  tbGeneralAward.tbRandom = {}
  local nNum = self.AWARD_LIST[self:GetTask(self.TASK_LEVELSEG)] or 0
  local nXiangNum = self.AWARD_LIST2[self:GetTask(self.TASK_LEVELSEG)] or 0
  local nFreeCount = SpecialEvent.ExtendAward:DoCheck("FinishWanted")
  local nNeedFreeNum = 0
  local nNeedFreeXiangNum = 0
  if nNum > 0 then
    nNeedFreeNum = 1
  end
  if nXiangNum > 0 then
    nNeedFreeXiangNum = 1
  end
  if me.CountFreeBagCell() < (nNeedFreeNum + nNeedFreeXiangNum + nFreeCount) then
    Dialog:Say(string.format("您背包空间不足。请整理%s格空余背包空间", (1 + nFreeCount)))
    return 1
  end
  if nNum > 0 then
    table.insert(tbGeneralAward.tbFix, {
      szType = "item",
      varValue = { self.ITEM_MINGBULING[1], self.ITEM_MINGBULING[2], self.ITEM_MINGBULING[3], self.ITEM_MINGBULING[4] },
      nSprIdx = "",
      szDesc = "名捕令",
      szAddParam1 = nNum,
    })
  end
  if nXiangNum > 0 then
    local nRLevel = self:GetTask(self.TASK_100SEG_RANLEVEL)
    if nRLevel == 0 then
      local nRLevel = MathRandom(1, 5)
      self:SetTask(self.TASK_100SEG_RANLEVEL, nRLevel)
    end
    table.insert(tbGeneralAward.tbFix, {
      szType = "item",
      varValue = { self.ITEM_MINGBUXIANG[1], self.ITEM_MINGBUXIANG[2], self.ITEM_MINGBUXIANG[3], nRLevel },
      nSprIdx = "",
      szDesc = "名捕材料",
      szAddParam1 = nXiangNum,
    })
  end
  GeneralAward:SendAskAward(szAwardTalk, tbGeneralAward, { "Wanted:AwardFinish", Wanted.AwardFinish })
end

function Wanted:Day_SetTask(nDay)
  if me.nLevel < self.LIMIT_LEVEL then
    return 0
  end
  local nCount = self.Day_COUNT * nDay
  if self:GetTask(self.TASK_COUNT) + nCount > self.LIMIT_COUNT_MAX then
    nCount = self.LIMIT_COUNT_MAX - self:GetTask(self.TASK_COUNT)
  end
  self:SetTask(self.TASK_COUNT, self:GetTask(self.TASK_COUNT) + nCount)
  if self:GetTask(self.TASK_FIRST) == 0 then
    self:SetTask(self.TASK_FIRST, 1)
  end
  local nFlag = self:Check_Task()
  local nSec = self:GetTask(self.TASK_ACCEPT_TIME)
  if nFlag == 2 and nSec > 0 and tonumber(os.date("%Y%m%d", GetTime())) > tonumber(os.date("%Y%m%d", nSec)) then
    --如果任务已经过期但未完成；
    self:CancelTask(1)
    me.Msg("很遗憾，你的官府通缉任务因为过期未完成而失败。官府通缉任务必须当天接取当天完成。")
  end
end

PlayerSchemeEvent:RegisterGlobalDailyEvent({ Wanted.Day_SetTask, Wanted })

--随机召唤boss
function Wanted:GetRandomBossInfor()
  local nCurOpenServerDay = TimeFrame:GetServerOpenDay()
  local nFlag = -1
  local nSegId = 0
  for nId, nOpenServerDay in pairs(self.CallBossRateSeg) do
    if nFlag < nOpenServerDay and nCurOpenServerDay >= nOpenServerDay then
      nSegId = nId
      nFlag = nOpenServerDay
    end
  end
  local nRateSum = 0
  local nCurRate = MathRandom(1, self.CallBossRate[nSegId].nMaxRate)
  for _, tbBoss in pairs(self.CallBossRate[nSegId].tbBoss) do
    nRateSum = nRateSum + tbBoss.nRate
    if nCurRate <= nRateSum then
      return tbBoss.tbNpcInFor
    end
  end
  return
end

function Wanted:ReRandomTask(nSeg, tbTaskLevelSeg)
  if not self.TaskLevelSeg then
    return
  end
  self.TaskLevelSeg[nSeg] = tbTaskLevelSeg
  self.TaskLevelSegActionKind[nSeg] = {}
  for _, nTaskId in ipairs(self.TaskLevelSeg[nSeg]) do
    local nActionKind = self.TaskFile[nTaskId].nActionKind
    self.TaskLevelSegActionKind[nSeg][nActionKind] = self.TaskLevelSegActionKind[nSeg][nActionKind] or {}
    table.insert(self.TaskLevelSegActionKind[nSeg][nActionKind], nTaskId)
  end
end
