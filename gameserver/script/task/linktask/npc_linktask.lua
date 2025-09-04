-- ====================== 文件信息 ======================

-- 剑侠世界门派任务链 NPC 处理文件
-- Edited by peres
-- 2007/03/16 PM 03:25

-- 在人群里，一对对年轻的情侣，彼此紧紧地纠缠在一起，旁若无人地接吻。
-- 爱情如此美丽，似乎可以拥抱取暖到天明。
-- 我们原可以就这样过下去，闭起眼睛，抱住对方，不松手亦不需要分辨。

-- ======================================================

Require("\\script\\task\\linktask\\linktask_head.lua")

local tbNpc = Npc:GetClass("seasonnpc")

tbNpc.tbShopID = {
  [Env.FACTION_ID_SHAOLIN] = 37, -- 少林
  [Env.FACTION_ID_TIANWANG] = 38, --天王掌门
  [Env.FACTION_ID_TANGMEN] = 39, --唐门掌门
  [Env.FACTION_ID_WUDU] = 41, --五毒掌门
  [Env.FACTION_ID_EMEI] = 43, --峨嵋掌门
  [Env.FACTION_ID_CUIYAN] = 44, --翠烟掌门
  [Env.FACTION_ID_GAIBANG] = 46, --丐帮掌门
  [Env.FACTION_ID_TIANREN] = 45, --天忍掌门
  [Env.FACTION_ID_WUDANG] = 47, --武当掌门
  [Env.FACTION_ID_KUNLUN] = 48, --昆仑掌门
  [Env.FACTION_ID_MINGJIAO] = 40, --明教掌门
  [Env.FACTION_ID_DALIDUANSHI] = 42, --大理段氏掌门
  [Env.FACTION_ID_GUMU] = 291,
}

tbNpc.MIN_LEVEL = 25

function tbNpc:OnDialog()
  local nOpen = LinkTask:GetTask(LinkTask.TSK_TASKOPEN)
  local nTaskType = LinkTask:GetTask(LinkTask.TSK_TASKTYPE)

  local nContain = LinkTask:GetTask(LinkTask.TSK_CONTAIN)
  local nPauseTime = LinkTask:GetTask(LinkTask.TSK_CANCELTIME)

  -- 判断是否超过了容忍次数，被禁止做任务中
  if nContain >= LinkTask.CONTAIN_LIMIT then
    if me.nOnlineTime - nPauseTime >= LinkTask.PAUSE_TIME then
      LinkTask:SetTask(LinkTask.TSK_CONTAIN, 0)
    else
      Dialog:Say("你也太没有耐心了吧？还是歇一会再来吧！")
      return
    end
  end

  if me.GetTiredDegree1() == 2 then
    Dialog:Say("您已经太累了！")
    return
  end

  -- 因为某种原因未能领取到奖励
  if LinkTask:GetAwardState() == 1 then
    Dialog:Say("恭喜你已经完成了任务，现在领取奖励？", {
      { "废话，快给我", tbNpc.PayAward, tbNpc },
      { "暂时不领", tbNpc.LeaveNpc, tbNpc },
    })
    return
  end

  -- 如果从来没有开始过，则开始
  if nOpen == 0 then
    if me.nLevel >= self.MIN_LEVEL then
      Dialog:Say("这位侠士，在下包万同，有一事相求，不知可否留步容我细细说来？", {
        { "好啊", tbNpc.OpeningTalk, tbNpc },
        { "算了", tbNpc.OnExit, tbNpc },
      })
      return
    else
      Dialog:Say(string.format("这位侠士，当你等级到了 <color=yellow>%s 以上<color>的时候过来找我，我会有些事情要拜托你。", self.MIN_LEVEL))
      return
    end
  end

  local nTaskType = LinkTask:GetTask(LinkTask.TSK_TASKTYPE)
  local tbTask = Task:GetPlayerTask(me).tbTasks[nTaskType]

  LinkTask:CheckPerDayTask()

  if Task.IVER_nLaoBaoOnly10Times == 1 then
    local n10Times = LinkTask:GetTask10TimesNum_PerDay()
    if n10Times > 0 then
      Dialog:Say("年轻人，今天你能帮助义军完成如此繁重的任务，老包我很感激，先歇一会吧，<color=yellow>明天再来<color>，我还有任务要交给你。")
      return
    end
  end

  -- 如果玩家身上没任何任务链的任务，则直接提示下一个
  -- 如果存在未完成的任务，则显示当前任务的对话
  if tbTask == nil then
    self:NextDialog()
  else
    local nSubTaskId = LinkTask:GetTask(LinkTask.TSK_TASKID)
    self:ShowTaskInfo(nSubTaskId)
  end
end

function tbNpc:OpeningTalk()
  if me.nLevel < 25 then
    Dialog:Say("呃……我看你武艺根基还不稳，恐怕暂时还难以胜任我的任务，请你到了 <color=red>20 级<color>之后再来找我吧！")
    return
  end

  local szTalk = [[<color=red><npc=3573><color>：近来义军将士在淮河渡口打了场胜仗，大壮军威。可惜辛苦所获的辎重粮草，只够十日之需。白秋琳首领为此事夜不能寐，食不甘味，天天派人催促我尽快解决。这督办粮草的活计真是愁死人了。<end>
						<color=red><npc=3573><color>：现在是手里有钱，可全天下连年征战，粮食欠收，物资紧缺。金国人封禁了一切边地贸易，朝廷又四处盘剥本已空乏的民众，要办齐辎重比登天还难。<end>
						<color=red><npc=3573><color>：可就是造一座梯子爬到天上去，我也得硬着头皮造呀。我老包自幼便父母双亡，长在军中，是义军养大了我。前线上拼死拼活的人，眼巴巴也就是盼口饭吃，他们都是我的兄弟姐妹，我撒不了这个手。<end>
						<color=red><npc=3573><color>：我一撒手，他们就要穿着布衣去和全身着甲的敌人拼杀，就要骑着饿得皮包骨头的瘦马和金军铁骑对冲。那是送死啊。<end>
						<color=red><npc=3573><color>：可巧的是，前几日邹德侩的外甥给我出了个好主意。遍邀天下豪杰，为义军筹措物资。我们则帮助这些高手们修行更上乘的武学，将从金国人那里获得的金银与众人换取所需。说来也是，天下能人众多，大家也算各取所需吧。不知你愿不愿意帮我这忙？]]

  TaskAct:Talk(szTalk, Npc:GetClass("seasonnpc").OpenTask, Npc:GetClass("seasonnpc"))
end

function tbNpc:OpenTask()
  LinkTask:Open()
  local nMainTaskId, nSubTaskId = LinkTask:StartTask() -- 开始任务
  if not nMainTaskId then
    return
  end
  self:ShowTaskInfo(nSubTaskId)
end

-- 问玩家是否进行下一步的对话框，如果是队长，则询问是否与队友共享任务
function tbNpc:NextDialog()
  local nTaskNum = LinkTask:GetTaskNum()
  local nTaskNum_PerDay = LinkTask:GetTaskNum_PerDay()

  local szMainText = "你今天连续完成了 <color=green>" .. nTaskNum_PerDay .. "<color> 次我交给你的任务，还想继续进行吗？\n\n每连续完成10次任务将可获得额外的奖励。"

  --	if me.IsCaptain() ~= 1 then
  Dialog:Say(szMainText, {
    { "是的，我闲着呢", tbNpc.NextTask, tbNpc },
    { "我再考虑考虑", tbNpc.LeaveNpc, tbNpc },
    { "我要购买义军装备", self.OpenShop, self },
  })
  --	else
  --		Dialog:Say(szMainText, {
  --				  {"我想与队友一起进行下一次任务", tbNpc.TeamNextTask, tbNpc},
  --				  {"我想自己进行任务", tbNpc.NextTask, tbNpc},
  --				  {"我再考虑考虑", tbNpc.LeaveNpc, tbNpc},
  --			});
  --	end;
end

-- 进行下一个任务的选择，如果 nIsTeam 为 1 ，则将该任务与队友共享
function tbNpc:NextTask(nIsTeam)
  local nMainTaskId, nSubTaskId = LinkTask:StartTask() -- 开始任务，并把任务强制设置玩家接受
  if not nMainTaskId then
    return
  end

  if nMainTaskId <= 0 or nSubTaskId <= 0 then
    Dialog:Say("年轻人，今天你能帮助义军完成如此繁重的 50 次任务，老包我很感激，先歇一会吧，<color=yellow>明天再来<color>，我还有任务要交给你。", { { "我要购买义军装备", self.OpenShop, self } })
    return
  end

  self:ShowTaskInfo(nSubTaskId)

  if nIsTeam then
    local tbTeamMembers, nMemberCount = me.GetTeamMemberList()

    local nOldIndex = me.nPlayerIndex

    if not tbTeamMembers then
      return
    end

    local szCaptainName = me.szName
    local nCaptainLevel = me.nLevel -- 队长的等级

    for i = 1, nMemberCount do
      if nOldIndex ~= tbTeamMembers[i].nPlayerIndex then
        Setting:SetGlobalObj(tbTeamMembers[i])
        local nOpen = me.GetTask(LinkTask.TSKG_LINKTASK, LinkTask.TSK_TASKOPEN)
        local nContain = me.GetTask(LinkTask.TSKG_LINKTASK, LinkTask.TSK_CONTAIN)
        local nAwardState = me.GetTask(LinkTask.TSKG_LINKTASK, LinkTask.TSK_AWARDSAVE)
        local nTotalNum = me.GetTask(LinkTask.TSKG_LINKTASK, LinkTask.TSK_TOTALNUM_PERDAY) -- 每天固定次数的限制
        local nLevelAbs = math.abs(me.nLevel - nCaptainLevel) -- 等级相差的绝对值

        -- 满足的条件：已经开始做野叟任务，没被禁止，没有处于领奖状态，没超过上限
        if nOpen == 1 and nContain < 3 and nAwardState ~= 1 and nTotalNum < LinkTask.PERDAY_NUM_MAX and nLevelAbs <= 10 then
          local nTaskType = me.GetTask(LinkTask.TSKG_LINKTASK, LinkTask.TSK_TASKTYPE)
          local tbTask = Task:GetPlayerTask(me).tbTasks[nTaskType]

          -- 当前处于未接任务的状态
          if tbTask == nil then
            LinkTask:Team_ShowTaskInfo(me, szCaptainName, nMainTaskId, nSubTaskId)
          end
        end
        Setting:RestoreGlobalObj()
      end
    end
  end
end

-- 选择与队友共享任务
function tbNpc:TeamNextTask()
  local tbTeamMembers, nMemberCount = me.GetTeamMemberList()
  local tbPlayerName = {}

  if not tbTeamMembers then
    Dialog:Say("你当前并没有在任何队伍中哦！")
    return
  end

  local nOldIndex = me.nPlayerIndex
  local nCaptainLevel = me.nLevel -- 队长的等级

  for i = 1, nMemberCount do
    if nOldIndex ~= tbTeamMembers[i].nPlayerIndex then
      Setting:SetGlobalObj(tbTeamMembers[i])
      local nOpen = me.GetTask(LinkTask.TSKG_LINKTASK, LinkTask.TSK_TASKOPEN)
      local nContain = me.GetTask(LinkTask.TSKG_LINKTASK, LinkTask.TSK_CONTAIN)
      local nAwardState = me.GetTask(LinkTask.TSKG_LINKTASK, LinkTask.TSK_AWARDSAVE)

      local nTotalNum = me.GetTask(LinkTask.TSKG_LINKTASK, LinkTask.TSK_TOTALNUM_PERDAY) -- 每天固定次数的限制
      local nLevelAbs = math.abs(me.nLevel - nCaptainLevel) -- 等级相差的绝对值

      --			print ("LinkTask: "..me.szName.." Start check: ", nOpen, nContain, nAwardState);

      -- 满足的条件：已经开始做野叟任务，没被禁止，没有处于领奖状态，没超过上限
      if nOpen == 1 and nContain < 3 and nAwardState ~= 1 and nTotalNum < LinkTask.PERDAY_NUM_MAX and nLevelAbs <= 10 then
        local nTaskType = me.GetTask(LinkTask.TSKG_LINKTASK, LinkTask.TSK_TASKTYPE)
        local tbTask = Task:GetPlayerTask(me).tbTasks[nTaskType]

        -- 当前处于未接任务的状态
        if tbTask == nil then
          --					print ("LinkTask: "..me.szName.." Pass!");
          table.insert(tbPlayerName, { tbTeamMembers[i].nPlayerIndex, tbTeamMembers[i].szName })
        end
      end
      Setting:RestoreGlobalObj()
    end
  end

  if #tbPlayerName <= 0 then
    Dialog:Say("当前并没有符合能与你一起共享任务条件的队友，队内共享任务必须符合以下条件：<color=yellow>\n\n    队友在你附近\n    队友的等级大于 20 级并且已经开启义军任务\n    队友已经完成一轮任务并且未接新任务\n    队长与队员之间的等级相差不能超过 10 级<color>\n")
    return
  end

  local szMembersName = "\n"

  for i = 1, #tbPlayerName do
    szMembersName = szMembersName .. "<color=yellow>" .. tbPlayerName[i][2] .. "<color>\n"
  end

  Dialog:Say("现在符合能与你共享任务的队友有：\n" .. szMembersName .. "\n你想和队友一起共享你接到的下一个任务么？", {
    { "是的", tbNpc.NextTask, tbNpc, 1 },
    { "不了", tbNpc.LeaveNpc, tbNpc },
  })
end

function tbNpc:ShowTaskInfo(nSubTaskId)
  local nTaskNum = LinkTask:GetTaskNum() -- 总的任务数
  local nTaskNum_PerDay = LinkTask:GetTaskNum_PerDay() -- 每天完成的任务数

  local nTaskType = LinkTask:GetTask(LinkTask.TSK_TASKTYPE)
  local szTaskName = Task.tbSubDatas[nSubTaskId].szName
  local szDesc = LinkTask:GetTaskText(nTaskType, nSubTaskId)

  if szDesc == "" then
    szDesc = "<无任务描述>"
  end

  local szTalk = "你今天连续完成了 <color=green>" .. nTaskNum_PerDay .. "<color> 次任务。<enter><enter>" .. "任务名称：" .. szTaskName .. "<enter><enter>" .. "任务描述：" .. szDesc .. "<enter>" .. "你的义军声望达到一定程度就可以在这购买装备。"

  local tbSelect = {}
  table.insert(tbSelect, { "我知道了", tbNpc.LeaveNpc, tbNpc })
  table.insert(tbSelect, { "我已经完成任务", tbNpc.CheckTask, tbNpc })

  if nTaskType == 20000 then
    table.insert(tbSelect, { "请把我送到需要战斗的地方吧", tbNpc.SendWorld, tbNpc, nTaskType, nSubTaskId })
  end

  table.insert(tbSelect, { "我要取消任务", tbNpc.CancelTask, tbNpc })
  table.insert(tbSelect, { "我要购买义军装备", self.OpenShop, self })
  Dialog:Say(szTalk, tbSelect)
end

function tbNpc:OpenShop()
  local nFaction = me.nFaction
  if nFaction <= 0 or me.GetCamp() == 0 then
    Dialog:Say("非白名玩家才能购买义军装备")
    return 0
  end
  me.OpenShop(self.tbShopID[nFaction], 1, 100, me.nSeries) --使用声望购买
end

function tbNpc:SendWorld(nTaskType, nSubTaskId)
  local nMapId = Task.tbSubDatas[nSubTaskId].tbSteps[1].tbTargets[1].nMapId
  local szMapName = Task:GetMapName(nMapId)

  if not LinkTask.tbMapPos[nMapId] then
    Dialog:Say("我现在还不能把你送到" .. szMapName .. "哦，你还是自己尝试过去吧！")
    return
  end

  local nMapX, nMapY = LinkTask.tbMapPos[nMapId][2], LinkTask.tbMapPos[nMapId][3]

  Dialog:Say("你现在想要去<color=yellow>" .. szMapName .. "<color>吗？义军兄弟遍布各地，我老包可以安排车马把你送过去！", {
    { "是的", tbNpc.SendWorldNow, tbNpc, nMapId, nMapX, nMapY },
    { "不了" },
  })
end

function tbNpc:SendWorldNow(nMapId, nMapX, nMapY)
  me.NewWorld(nMapId, nMapX, nMapY)
  me.SetFightState(1)
end

-- 检测任务是否完成
function tbNpc:CheckTask()
  LinkTask:_Debug("Start check task.")

  if LinkTask:CheckHaveItemTarget() == 1 then
    LinkTask:_Debug("Have find item target, show gift dialog.")
    LinkTask:ShowGiftDialog()
    return
  end

  if LinkTask:CheckTaskFinish() == 1 then
    LinkTask:OnAward()
    return
  else
    Dialog:Say("你还没有完成任务吧？又来这骗我！")
    return
  end
end

-- 给玩家发奖励
function tbNpc:PayAward()
  if LinkTask:GetAwardState() == 2 then
    Dialog:Say("你已经领取过一次奖励了吧？")
    return
  end
  LinkTask:OnAward()
end

-- 取消任务
function tbNpc:CancelTask()
  local nCancel = LinkTask:GetTask(LinkTask.TSK_CANCELNUM)
  local szTalk = ""
  if nCancel < 1 then
    szTalk = "您现在一次取消机会也没有哦，你确定要取消这次任务吗？"
  else
    szTalk = "您现在有 <color=yellow>" .. nCancel .. "<color> 次取消机会，你确定要取消这次任务吗？"
  end
  Dialog:Say(szTalk, {
    { "是的，我要取消这该死的任务", tbNpc.DoCancel, tbNpc },
    { "算了，我再想想吧", tbNpc.LeaveNpc, tbNpc },
  })
end

-- 取消确认
function tbNpc:DoCancel()
  local nResult = LinkTask:Cancel()

  if nResult == 1 then
    Dialog:Say("你也太没有耐心了吧？还是歇一会再来吧！")
    return
  end

  Dialog:Say("你取消了本次任务！")

  --	self:NextTask();
end

function tbNpc:SendMessageToTeam() end

function tbNpc:OnExit()
  return
end

function tbNpc:LeaveNpc()
  return
end
