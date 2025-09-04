local RELATIONTYPE_TRAINING = 5 -- 当前师徒关系
local RELATIONTYPE_TRAINED = 6 -- 出师师徒关系
local RELATIONTYPE_INTRODUCE = 8 -- 介绍人关系
local RELATIONTYPE_BUDDY = 9 -- 指定密友关系
local COST_DELTEACHER = 10000 -- 解除和师父关系的费用
local COST_DELSTUDENT = 10000 -- 解除和弟子关系的费用

local tbNpc = Npc:GetClass("renji")

-- 对话
function tbNpc:OnDialog()
  local szMsg = "我这里可以帮您处理一些人际关系的问题，有什么我可以帮到你的吗？"
  local tbOpt = {}

  table.insert(tbOpt, { "师徒相关", tbNpc.Training, self })
  table.insert(tbOpt, { "介绍人相关", tbNpc.Introduce, self })
  table.insert(tbOpt, { "指定密友", tbNpc.Buddy, self })
  table.insert(tbOpt, { "领取密友奖励", tbNpc.GainBindCoin, self })
  table.insert(tbOpt, { "成就系统相关", tbNpc.AchievementDlg, self })
  table.insert(tbOpt, { "我只是随便来看看" })

  local nCurDate = tonumber(os.date("%Y%m%d", GetTime()))
  if nCurDate >= 20100920 and nCurDate <= 20101004 then
    local tbTemp = { "<color=yellow>资料片新系统开放奖励<color>", SpecialEvent.Achive_Zhaneyuan.OnDialog, SpecialEvent.Achive_Zhaneyuan }
    table.insert(tbOpt, 1, tbTemp)
  end

  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:Training()
  local tbOpt = {
    { "申请拜师", tbNpc.AppTrain, self },
    { "进行出师仪式", tbNpc.Graduation, self },
    { "解除未出师师徒关系", tbNpc.DelTrainingRelation, self },
    { "解除已出师师徒关系", tbNpc.DelTrainedRelation, self },
    { "领取师徒同心符", tbNpc.GetShiTuChuanSongFu, self },
    { "修复已完成固定成就", tbNpc.RetrieveAchievement, self },
  }
  if me.GetTrainingStudentList() then
    table.insert(tbOpt, #tbOpt, { "更换师徒称号", tbNpc.ChangeShituTitle, self })
  end

  if me.GetTrainingTeacher() then
    table.insert(tbOpt, #tbOpt, { "获取弟子称号", tbNpc.GetStudentTitle, self })
  end
  if Esport.Mentor.bVisible then
    if self:GetTeamMission() then
      table.insert(tbOpt, { "进入师徒副本", tbNpc.PreStartMentor, self })
    else
      table.insert(tbOpt, { "开启师徒副本", tbNpc.PreStartMentor, self })
    end
  end

  table.insert(tbOpt, { "我只是随便来看看" })

  Dialog:Say("师徒相关", tbOpt)
end

--=====================================

function tbNpc:DelTrainedRelation()
  local szTeacher = me.GetTrainingTeacher(RELATIONTYPE_TRAINED)
  local tbStudent = me.GetRelationList(RELATIONTYPE_TRAINED, 1)
  if not szTeacher and (not tbStudent or Lib:CountTB(tbStudent) <= 0) then
    Dialog:Say("你现在没有已出师的师徒关系。")
    return 0
  end

  Dialog:Say("解除已出师师徒关系", {
    { "和师傅解除关系", self.DelTrainedTeacher, self, 0, szTeacher },
    { "和弟子解除关系", self.DelTrainedStudent, self, 0, 1 },
    { "我只是随便来看看" },
  })
end

function tbNpc:DelTrainedTeacher(bConfirm, szTeacher)
  bConfirm = bConfirm or 0
  szTeacher = szTeacher or ""
  if "" == szTeacher then
    Dialog:Say("你还没有出师，不能进行此操作。")
    return 0
  end
  if me.nCashMoney < COST_DELTEACHER then
    Dialog:Say(string.format("弟子主动删除师傅需要缴纳%s两的手续费，你还是准备好了再来吧。", COST_DELTEACHER))
    return 0
  end

  if me.IsHaveRelation(szTeacher, RELATIONTYPE_TRAINED, 0) ~= 1 then
    return 0
  end

  if 0 == bConfirm then
    Dialog:Say(string.format("你确定要和<color=yellow>%s<color>解除师徒关系吗？", szTeacher), {
      { "是的，我确定", self.DelTrainedTeacher, self, 1, szTeacher },
      { "我还是再考虑一下吧" },
    })
  else
    if me.CostMoney(COST_DELTEACHER, Player.emKPAY_DEL_TEACHER) ~= 1 then
      Dialog:Say("解除师徒关系需要<color=red>10000<color>两银子，你身上银子不够，带够了再来吧。")
      return 0
    end
    Relation:DelRelation_GS(me.szName, szTeacher, RELATIONTYPE_TRAINED, 0)
    KPlayer.SendMail(szTeacher, "师徒关系解除通知", "您好，您的弟子<color=yellow>" .. me.szName .. "<color>已经单方面和你解除了师徒关系。节哀啊节哀。")
    Dialog:Say("你和<color=yellow>" .. szTeacher .. "<color>的师徒关系已经成功解除了，以后你们就天各一方，互不相干了。")
  end
end

function tbNpc:DelTrainedStudent(bConfirm, nPageNum, szStudentName)
  bConfirm = bConfirm or 0
  nPageNum = nPageNum or 1
  szStudentName = szStudentName or ""

  if 0 == bConfirm then
    local tbStudent = me.GetRelationList(RELATIONTYPE_TRAINED, 1)
    if not tbStudent or Lib:CountTB(tbStudent) <= 0 then
      Dialog:Say("你还没有已经出师的弟子，不能进行此操作。")
      return
    end
    local szMsg = "请选择你要和谁解除师徒关系"
    local tbOpt = {}

    -- 每页显示10个供选择弟子
    local nBeginIndex = (nPageNum - 1) * 10 + 1
    local nEndIndex = nBeginIndex + 10
    local nTotalPage = math.ceil(#tbStudent / 10)
    for nIndex, szStudent in ipairs(tbStudent) do
      if nIndex >= nBeginIndex and nIndex < nEndIndex then
        local tbOneOpt = { szStudent, self.DelTrainedStudent, self, 1, nPageNum, szStudent }
        table.insert(tbOpt, tbOneOpt)
      end
    end

    if nPageNum > 1 then
      table.insert(tbOpt, { "上一页", self.DelTrainedStudent, self, 0, nPageNum - 1 })
    end
    if nPageNum < nTotalPage then
      table.insert(tbOpt, { "下一页", self.DelTrainedStudent, self, 0, nPageNum + 1 })
    end
    Dialog:Say(szMsg, tbOpt)
  else
    if me.IsHaveRelation(szStudentName, RELATIONTYPE_TRAINED, 1) ~= 1 then
      Dialog:Say("你们之间不存在已出师的师徒关系。")
      return
    end
    Relation:DelRelation_GS(me.szName, szStudentName, RELATIONTYPE_TRAINED, 1)
    KPlayer.SendMail(szStudentName, "师徒关系解除通知", "您好，您的师傅<color=yellow>" .. me.szName .. "<color>已经单方面和你解除了师徒关系。节哀啊节哀。")
    Dialog:Say("你和<color=yellow>" .. szStudentName .. "<color>的师徒关系已经成功解除了，以后你们就天各一方，互不相干了。")
  end
end

--=====================================

function tbNpc:DelTrainingRelation()
  local pszTeacher = me.GetTrainingTeacher()
  local tbStudent = me.GetTrainingStudentList()
  if self:CanDoRelationOpt(me.szName) == 0 then
    return
  end
  if not pszTeacher and not tbStudent then
    Dialog:Say("你现在没有未出师的师徒关系。")
    return 0
  else
    Dialog:Say("师徒相关", {
      { "和师傅解除关系", tbNpc.DelTrainingTeacherDialog, self },
      { "和徒弟解除关系", tbNpc.DelTrainingStudentDialog, self },
      { "我只是随便来看看" },
    })
  end
end

function tbNpc:Introduce()
  if self:CanDoRelationOpt(me.szName) == 0 then
    return
  end
  Dialog:Say("建立介绍人关系以后，你每次在奇珍阁消费，你的介绍人就会获得5%的消费奖励。<color=yellow>介绍人关系将维持一年，到期后将自动解除。当两人亲密度达到6级时，也可在我这里申请转成指定密友关系。<color>\n\n确认要和其建立介绍人关系吗？", {
    { "确认我的介绍人", tbNpc.IntroduceDialog, self },
    { "我们想成为密友", tbNpc.BuddyDialog, self },
    { "我只是随便来看看" },
  })
end

function tbNpc:Buddy()
  if self:CanDoRelationOpt(me.szName) == 0 then
    return
  end
  Dialog:Say("成为密友后，一方在奇珍阁消费时另一方将获得消费返还奖励。<color=yellow>密友关系将维持一年，到期后将自动解除密友关系，需要重新到我这里指定密友。<color>\n\n你们确定要成为密友吗？解除密友关系时需要支付一定的手续费用，请考虑清楚哦。", {
    { "我们想成为密友", tbNpc.BuddyDialog, self },
    { "我想删除密友", tbNpc.DelBuddyDialog, self },
    { "我只是随便来看看" },
  })
end

function tbNpc:GainBindCoin()
  if 1 ~= jbreturn:GainBindCoin() then
    local tbOption = {
      { string.format("我要领取绑定%s", IVER_g_szCoinName), tbNpc.GetIbBindCoin, self },
      { "我只是随便来看看" },
    }
    -- 美术同学特别通道
    local nWeek = Lib:GetLocalWeek()
    if me.GetTask(2056, 16) >= nWeek then
      table.insert(tbOption, 1, { "工资优惠", jbreturn.GetFreeReward, jbreturn })
    end
    Dialog:Say("领取密友奖励", tbOption)
  end
end

-- 更换师徒称号
function tbNpc:ChangeShituTitle()
  local tbItem = Item:GetClass("teacher2student")
  tbItem:ChangeShituTitle()
end

-- 获取弟子称号
function tbNpc:GetStudentTitle()
  local tbItem = Item:GetClass("teacher2student")
  tbItem:FetchStudentTitle()
end

-- 检查拜师的条件
function tbNpc:CheckAppTrainCond()
  if 0 == self:CanDoRelationOpt(me.szName) then
    return 0
  end

  if me.GetTrainingTeacher() then
    Dialog:Say("你已经有师傅了，不能再拜师")
    return 0
  end

  if me.nLevel < Relation.STUDENT_MINILEVEL then
    Dialog:Say(string.format("你的等级还不够<color=yellow>%s<color>级，不能拜师", Relation.STUDENT_MINILEVEL))
    return 0
  end

  if me.nLevel >= Relation.STUDENT_MAXLEVEL then
    Dialog:Say(string.format("你的等级已经超过<color=yellow>%s<color>级，不能拜师。", Relation.STUDENT_MAXLEVEL - 1))
    return 0
  end

  local nCurDate = tonumber(os.date("%Y%m%d", GetTime()))
  local nLastAppDate = me.GetTask(Relation.TASK_GROUP, Relation.TASKID_LASTAPPTRAIN_DATE)
  local nAppCount = me.GetTask(Relation.TASK_GROUP, Relation.TASKID_APPTRAIN_COUNT)
  if nAppCount > Relation.MAX_APPTRAIN_COUNT then
    Dialog:Say(string.format("你今天已经拜师<color=yellow>%s<color>次了，不能再拜师", Relation.MAX_APPTRAIN_COUNT))
    return 0
  end

  local tblMemberList, nMemberCount = me.GetTeamMemberList()
  if 2 ~= nMemberCount then
    Dialog:Say("必须两人组队过来才能进行拜师")
    return 0
  end

  local cTeamMate = tblMemberList[1]
  for i = 1, #tblMemberList do
    if tblMemberList[i].szName ~= me.szName then
      cTeamMate = tblMemberList[i]
    end
  end

  -- 在拜师前，如果不是好友关系，先自动加为好友
  if me.IsFriendRelation(cTeamMate.szName) ~= 1 then
    Dialog:Say("你们需要先结为好友才能拜师。")
    return 0
  end

  if cTeamMate.nLevel < Relation.TEACHER_NIMIEVEL then
    Dialog:Say(string.format("对方等级不足%s级，暂时不能接受弟子，你还是拜别人为师吧。", Relation.TEACHER_NIMIEVEL))
    return 0
  end

  if cTeamMate.nLevel - me.nLevel < Relation.GAPMINILEVEL then
    Dialog:Say(string.format("对方等级至少需要大于您<color=yellow>%s<color>级，所以对方不能接受你为弟子，你还是拜别人为师吧。", Relation.GAPMINILEVEL))
    return 0
  end

  local tbStudentList = me.GetTrainingStudentList()
  if tbStudentList and Lib:CountTB(tbStudentList) > Relation.MAX_STUDENCOUNT then
    Dialog:Say(string.format("对方已经有%s个弟子了，不能再接受弟子，你还是拜别人为师吧。", Relation.MAX_STUDENCOUNT))
    return 0
  end

  if cTeamMate.GetTrainingTeacher() then
    Dialog:Say("对方也还未出师呢，你还是拜别人为师吧。")
    return 0
  end

  return 1
end

-- 申请拜师
function tbNpc:AppTrain()
  local bCanAppTrain = self:CheckAppTrainCond()
  if 1 == bCanAppTrain then
    local tblMemberList, nMemberCount = me.GetTeamMemberList()
    local cTeamMate = tblMemberList[1]
    for i = 1, #tblMemberList do
      if tblMemberList[i].szName ~= me.szName then
        cTeamMate = tblMemberList[i]
        break
      end
    end
    local szTeacherName = cTeamMate.szName
    -- me.CallClientScript({"Relation:CmdApplyTeacher", cTeamMate.szName});
    cTeamMate.CallClientScript({ "Relation:ApplyTeacher_S2C", me.szName })
  end
end

-- 密友：建立指定密友对话
function tbNpc:BuddyDialog()
  local tblMemberList, nMemberCount = me.GetTeamMemberList()
  -- 玩家必须处于组队状态，且队伍中只有两个人
  if nMemberCount ~= 2 then
    Dialog:Say("必须两个人组队过来才能成为密友啊！")
    return
  end
  Dialog:Say("必须要两个人一起组队过来，才能成为密友。", {
    { "是的，我们确定要成为密友", tbNpc.MakeBuddy, self },
    { "我还是考虑考虑吧" },
  })
end

-- 密友：建立指定密友
function tbNpc:MakeBuddy()
  local tblMemberList, nMemberCount = me.GetTeamMemberList()
  -- 玩家必须处于组队状态，且队伍中只有两个人
  if nMemberCount ~= 2 then
    Dialog:Say("必须两个人组队过来才能成为密友啊！")
    return
  end
  for i = 1, #tblMemberList do
    local cTeamMate = tblMemberList[i]
    if cTeamMate.szName ~= me.szName then
      -- 检查级别
      if me.nLevel < 61 or cTeamMate.nLevel < 61 then
        Dialog:Say("江湖险恶，你们还年少无知，还是等<color=red>61级<color>之后再来吧。")
        return
      end
      -- 两人必须互相是好友，且亲密度不低于 等级6级。即秦密度3600
      local nFavor = me.GetFriendFavor(cTeamMate.szName)

      if nFavor <= 2500 then
        Dialog:Say("你们的亲密度必须超过<color=red>6级<color>才能成为密友啊，你们还是以后再来吧。")
        return
      end
      -- 检查是否已经是指定密友
      if KPlayer.CheckRelation(me.szName, cTeamMate.szName, RELATIONTYPE_BUDDY) ~= 0 then
        Dialog:Say("你们已经是密友了。")
        return
      end
      -- 两人之间必须没有师徒关系
      if KPlayer.CheckRelation(me.szName, cTeamMate.szName, RELATIONTYPE_TRAINING, 1) ~= 0 or KPlayer.CheckRelation(me.szName, cTeamMate.szName, RELATIONTYPE_TRAINED, 1) ~= 0 then
        Dialog:Say("你们已经是师徒了，不能再成为指定密友。")
        return
      end
      -- 检查指定密友数量 暂时设定为4个
      if me.GetRelationCount(RELATIONTYPE_BUDDY) >= 4 or cTeamMate.GetRelationCount(RELATIONTYPE_BUDDY) >= 4 then
        Dialog:Say("只能和4个人指定成为密友，你们的密友数量已经满了。")
        return
      end
      -- 两人之间必须没有介绍人关系
      if KPlayer.CheckRelation(me.szName, cTeamMate.szName, RELATIONTYPE_INTRODUCE, 1) ~= 0 then
        Relation:DelRelation_GS(me.szName, cTeamMate.szName, RELATIONTYPE_INTRODUCE)
      end
      -- 建立指定密友关系
      Relation:AddRelation_GS(me.szName, cTeamMate.szName, RELATIONTYPE_BUDDY)
    end
  end
end

-- 确认介绍人对话
function tbNpc:IntroduceDialog()
  -- 检查级别
  if me.nLevel > 11 then
    Dialog:Say("您已经超过了11级，不能再确定介绍人了。")
    return
  end
  -- 玩家必须处于组队状态，且队伍中只有两个人

  local tblMemberList, nMemberCount = KTeam.GetTeamMemberList(me.nTeamId)
  local pszTeamHint = "您必须和您的介绍人两人一起组队，可以通过密聊加好友和进行远程组队操作；而且您的介绍人等级至少得比您大<color=red>30级<color>以上，我才能帮助你们建立密友关系。"
  if nMemberCount ~= 2 then
    Dialog:Say(pszTeamHint)
    return
  end
  for i = 1, #tblMemberList do
    local npMemId = tblMemberList[i]
    if npMemId ~= me.nId then
      -- 检查级别
      local nOnline = KGCPlayer.OptGetTask(npMemId, KGCPlayer.TSK_ONLINESERVER)
      if nOnline <= 0 then
        Dialog:Say("您的好友不在线，无法进行介绍人操作，建立密友关系失败。")
        return
      end
      local szMemName = KGCPlayer.GetPlayerName(npMemId)
      local tbInfo = GetPlayerInfoForLadderGC(szMemName)
      if not tbInfo then
        return
      end
      if tbInfo.nLevel - me.nLevel < 30 then
        Dialog:Say(pszTeamHint)
        return
      end
      -- 检查是否已有介绍人
      if me.GetRelationCount(RELATIONTYPE_INTRODUCE) ~= 0 then
        Dialog:Say("你已经有介绍人了。")
        return
      end
      -- 加介绍人之前需要已经是好友关系
      if me.IsFriendRelation(szMemName) ~= 1 then
        Dialog:Say("你们需要先成为好友才能确认介绍人关系。")
        return
      end
      -- 建立介绍人关系
      Relation:AddRelation_GS(me.szName, szMemName, RELATIONTYPE_INTRODUCE, 0)
      Dialog:Say("您已经成功和" .. szMemName .. "建立了密友关系，以后他也能享受您的成长，如果有什么不明白的，多问问他吧。")
    end
  end
end

-- 删除密友对话
function tbNpc:DelBuddyDialog()
  Dialog:Say("只有自己指定的密友是可以被删除的。给我<color=red>20万银两<color>，我就帮你解除密友关系。你确定要删除密友吗？", {
    { "是的，我要删除密友", tbNpc.DeleteBuddy, self },
    { "我还是考虑考虑吧" },
  })
end

-- 删除密友
function tbNpc:DeleteBuddy()
  local tblRelation = me.GetRelationList(RELATIONTYPE_BUDDY)
  if #tblRelation == 0 then
    Dialog:Say("你没有密友")
    return
  end
  local tblOptions = {}
  for i = 1, #tblRelation do
    tblOptions[i] = { tblRelation[i], tbNpc.DeleteTheBuddyDialog, self, tblRelation[i] }
  end
  tblOptions[#tblRelation + 1] = { "我还是考虑考虑吧" }
  Dialog:Say("你想删除哪个密友呢？", tblOptions)
end

-- 删除某个指定密友对话
function tbNpc:DeleteTheBuddyDialog(pszBuddy)
  Dialog:Say("你确定要和<color=yellow>" .. pszBuddy .. "<color>解除密友关系吗？", {
    { "是的，我要和" .. pszBuddy .. "解除密友关系", tbNpc.DeleteTheBuddy, self, pszBuddy },
    { "我还是考虑考虑吧" },
  })
end

-- 删除某个指定密友
function tbNpc:DeleteTheBuddy(pszBuddyName)
  -- 扣除20W银两
  if me.CostMoney(200000, Player.emKPAY_DEL_BUDDY) ~= 1 then
    Dialog:Say("必须付<color=red>200000<color>才能删除密友，你还是带够了钱再来吧！")
    return
  end
  Relation:DelRelation_GS(me.szName, pszBuddyName, RELATIONTYPE_BUDDY)
  me.Msg("您花费了20万银两，与 " .. pszBuddyName .. " 解除了密友关系。")
  KPlayer.SendMail(pszBuddyName, "密友关系解除通知", "您好，您的密友" .. me.szName .. "已经和你解除了密友关系。节哀啊节哀。")
end

-- 和师父解除关系对话
function tbNpc:DelTrainingTeacherDialog()
  local pszTeacher = me.GetTrainingTeacher()
  if pszTeacher == nil then
    Dialog:Say("你现在没有可以解除关系的师父呀")
    return
  end
  Dialog:Say("你确定想和<color=yellow>" .. pszTeacher .. "<color>解除师徒关系吗？如果你们的关系解除，以后你们相关的各种师徒奖励都将再不能享受，你可得考虑清楚。另外解除师徒关系还需要<color=red>10000<color>两银子。", {
    { "是的，我知道后果了，我要和他解除师徒关系", tbNpc.DelTrainingTeacher, self, pszTeacher },
    { "那我还是想想再来吧" },
  })
end

-- 和师父解除关系
function tbNpc:DelTrainingTeacher(pszTeacher)
  if me.CostMoney(COST_DELTEACHER, Player.emKPAY_DEL_TEACHER) ~= 1 then
    Dialog:Say("解除师徒关系需要<color=red>10000<color>两银子，你身上银子不够，带够了再来吧。")
    return
  end
  Relation:DelRelation_GS(me.szName, pszTeacher, RELATIONTYPE_TRAINING, 0)

  -- 去掉师徒称号
  local szStudentTitle = pszTeacher .. EventManager.IVER_szTudiTitle
  me.RemoveSpeTitle(szStudentTitle)
  EventManager:WriteLog("去除自定义称号" .. szStudentTitle, me)

  KPlayer.SendMail(pszTeacher, "师徒关系解除通知", "您好，您的弟子" .. me.szName .. "已经单方面和你解除了师徒关系。节哀啊节哀。")
  Dialog:Say("你和<color=yellow>" .. pszTeacher .. "<color>的师徒关系已经成功解除了，以后你们就天各一方，互不相干了。")
end

-- 和弟子解除关系对话
function tbNpc:DelTrainingStudentDialog()
  local tbStudent = me.GetTrainingStudentList()
  if tbStudent == nil then
    Dialog:Say("你现在没有可以解除关系的弟子呀。")
    return
  end
  local tbOption = {}
  for i = 1, #tbStudent do
    tbOption[i] = { tbStudent[i], tbNpc.DelTrainingStudent1, self, tbStudent[i] }
  end
  tbOption[#tbStudent + 1] = { "算了，我还是想想再来" }
  Dialog:Say("你想和谁解除师徒关系呢？", tbOption)
end

-- 和弟子解除关系
function tbNpc:DelTrainingStudent1(pszStudent)
  Dialog:Say("你确定想和<color=yellow>" .. pszStudent .. "<color>解除师徒关系吗？如果你们的关系解除，以后你们相关的各种师徒奖励都将再不能享受，你可得考虑清楚。", {
    { "是的，我知道后果了，我要和他解除师徒关系", tbNpc.DelTrainingStudent2, self, pszStudent },
    { "那我还是想想再来吧" },
  })
end

-- 和弟子解除关系
function tbNpc:DelTrainingStudent2(pszStudent)
  Relation:DelRelation_GS(me.szName, pszStudent, RELATIONTYPE_TRAINING, 1)

  local szTeacherTitle = pszStudent .. EventManager.IVER_szTeacherTitle
  me.RemoveSpeTitle(szTeacherTitle)
  EventManager:WriteLog("去除自定义称号" .. szTeacherTitle, me)

  KPlayer.SendMail(pszStudent, "师徒关系解除通知", "您好，您的师傅" .. me.szName .. "已经单方面和你解除了师徒关系。节哀啊节哀。")
  Dialog:Say("你和" .. pszStudent .. "的师徒关系已经成功解除了，以后你们就天各一方，互不相干了。")
end

--开启师徒副本
function tbNpc:PreStartMentor()
  local tbMiss = self:GetTeamMission()

  --如果副本已经开启了，显示进入副本
  if tbMiss then
    --将玩家再次传入到FB中的起始点
    tbMiss:ReEnterMission(me.nId)
  else --否则开启副本
    if Esport.Mentor:CheckEnterCondition(me.nId) ~= 1 then
      return
    end

    if Esport.Mentor:PreStartMission() == 0 then
      Dialog:Say("副本数量已达到上限。")
    end
  end
end

--根据当前队伍来取得MISSION，即始终根据队伍中的徒弟来取MISSION
function tbNpc:GetTeamMission()
  --必须是师徒二人组成的队伍才能进，这时候已经不需要做其它判定了，因为该玩家只会被送到他之前开启了的副本里面
  local anPlayerId, nPlayerNum = KTeam.GetTeamMemberList(me.nTeamId)
  if not anPlayerId or not nPlayerNum or nPlayerNum ~= 2 then
    Dialog:Say("必须由师徒两人组队才能进入！")
    return
  end

  --如果是徒弟要进，直接进入自己的副本就好了；
  --如果是师傅要进，进入到队伍中的徒弟的副本。
  local tbMiss
  if Esport.Mentor:CheckApprentice(me.nId) == 1 then
    tbMiss = Esport.Mentor:GetMission(me)
  else
    local pStudent = Esport.Mentor:GetApprentice(me.nId)
    tbMiss = Esport.Mentor:GetMission(pStudent) --如果当前队伍不是由满足关系的师徒二人组成的，得到的MISSION为NIL
  end

  return tbMiss
end

-- 修复弟子已完成的固定成就
function tbNpc:RetrieveAchievement()
  -- 只有当前有师傅的时候才可以修复成就
  if not me.GetTrainingTeacher() then
    Dialog:Say("你当前没有拜师，不需要修复成就。")
    return
  end

  local szMsg = "在师徒成就系统发布之前，如果您已经完成所有固定成就对应的事件，导致无法获得固定成就，以致无法出师的话，可以在这里修复。修复后的结果可以在师徒面板中查看。"
  Dialog:Say(szMsg, { "我已经知道了，要修复成就", Achievement_ST.CheckPreviousAchievement, Achievement_ST, 1 }, { "我还是一会再来吧" })
end

function tbNpc:GetShiTuChuanSongFu(bAutoGet)
  local tbChuanSongFu = { Item.SCRIPTITEM, 1, 65, 1 }
  local tbBaseProp = KItem.GetItemBaseProp(unpack(tbChuanSongFu))
  if not tbBaseProp then
    return
  end

  local nCount = me.GetItemCountInBags(unpack(tbChuanSongFu))
  if nCount >= 1 and not bAutoGet then
    me.Msg("你已拥有师徒同心符了！")
    return
  elseif nCount >= 1 and bAutoGet and bAutoGet == 1 then
    return
  end

  -- 现在领取师徒传送符的条件只要达到拜师条件即可
  local nLevel = me.nLevel
  if nLevel < 20 and not bAutoGet then
    me.Msg("你需要达到20级才可以领取师徒同心符。")
    return 0
  elseif nLevel < 20 and bAutoGet and bAutoGet == 1 then
    return 0
  end

  local tbItem = {
    nGenre = tbChuanSongFu[1],
    nDetail = tbChuanSongFu[2],
    nParticular = tbChuanSongFu[3],
    nLevel = tbChuanSongFu[4],
    nSeries = (tbBaseProp.nSeries > 0) and tbBaseProp.nSeries or 0,
    bBind = KItem.IsItemBindByBindType(tbBaseProp.nBindType),
    nCount = 1,
  }

  if me.CanAddItemIntoBag(tbItem) == 0 and not bAutoGet then
    me.Msg("背包已满")
    return
  elseif me.CanAddItemIntoBag(tbItem) == 0 and bAutoGet and bAutoGet == 1 then
    return
  end

  tbChuanSongFu[5] = tbItem.nSeries
  me.AddItem(unpack(tbChuanSongFu))
end

function tbNpc:GetIbBindCoin()
  me.ApplyGainIbCoin()
end

-- 出师仪式
function tbNpc.Graduation()
  if tbNpc:CanDoRelationOpt(me.szName) == 0 then
    return
  end
  local tblMemberList, nMemberCount = me.GetTeamMemberList()
  if nMemberCount ~= 2 then
    Dialog:Say("必须两个人组队过来才能成为出师啊！")
    return
  end
  local cTeamMate = tblMemberList[1]
  for i = 1, #tblMemberList do
    if tblMemberList[i].szName ~= me.szName then
      cTeamMate = tblMemberList[i]
    end
  end
  local TeacherList = me.GetTrainingTeacher()
  local StudentList = me.GetTrainingStudentList()

  if StudentList == nil then
    if TeacherList ~= nil then
      Dialog:Say("请你师傅来主持出师仪式吧。", {
        { "我明白了。" },
      })
      return
    end

    Dialog:Say("你们两没有师徒关系，或已经出师！")
    return
  end
  local bFind = 0
  for _, szStudentName in ipairs(StudentList) do
    if szStudentName == cTeamMate.szName then
      bFind = 1
      break
    end
  end
  if 0 == bFind then
    Dialog:Say("你们两没有师徒关系！")
    return
  end

  if cTeamMate.nFaction == 0 then
    Dialog:Say("弟子还没有加入门派，不能出师。")
    return
  end

  -- 获取所有固定成就
  local tbGudingAchievement = Achievement_ST:GetSpeTypeAchievementInfo(cTeamMate.nId, "固定成就")
  local bAchieve = 1
  for _, tbInfo in pairs(tbGudingAchievement) do
    if tbInfo.bAchieve == 0 then
      bAchieve = 0
      break
    end
  end
  if 0 == bAchieve then
    Dialog:Say("弟子需要完成所有固定成就才能出师。")
    return
  end

  Dialog:Say("必须师徒两人一同组队前来，由师父来开启出师仪式，弟子必须加入门派，达到90级并且完成所有固定成就才能出师。", {
    { "进行出师仪式", tbNpc.DoGraduation, self, cTeamMate },
    { "我只是随便看看。" },
  })
end

function tbNpc:DoGraduation(cTeamMate)
  local szStudent = ""
  -- 检查级别
  if cTeamMate.nLevel < 90 then
    Dialog:Say("弟子还没有达到90级，你们以后再来吧。")
    return
  end
  szStudent = cTeamMate.szName

  local pPlayer = KPlayer.GetPlayerByName(szStudent)
  if pPlayer ~= nil then
    me.TrainedStudent(szStudent)
    local szAccount = KGCPlayer.GetPlayerAccount(pPlayer.nId)
    StatLog:WriteStatLog("stat_info", "relationship", "remove", me.nId, szAccount, szStudent, 5, 0)
    StatLog:WriteStatLog("stat_info", "relationship", "create", me.nId, szAccount, szStudent, 6, 0)
    Dialog:Say("您的弟子" .. szStudent .. "已成功出师，从此以后，" .. szStudent .. "将成为您的密友，他在奇珍阁消费额度的5%将作为您对他培养的奖励返还给您。<color=yellow>师徒关系将维持一年，到期后将自动解除。<color>")

    pPlayer.Msg("你已经成功出师，以后可以独自行侠江湖了！")
  end

  -- 去取自定义称号，只把师傅的称号去掉，弟子的保留
  local szTeacherTitle = cTeamMate.szName .. EventManager.IVER_szTeacherTitle
  me.RemoveSpeTitle(szTeacherTitle)
  EventManager:WriteLog("去除自定义称号" .. szTeacherTitle, me)
end

function tbNpc:CanDoRelationOpt(szAppName)
  local pAppPlayer = KPlayer.GetPlayerByName(szAppName)
  if not pAppPlayer then
    return 0
  end
  local bCanOpt, szErrMsg = Relation:CanDoRelationOpt(szAppName)
  if bCanOpt == 0 then
    if "" ~= szErrMsg then
      pAppPlayer.Msg(szErrMsg)
    end
    return 0
  end
  return 1
end

function tbNpc:AchievementDlg()
  if not Achievement.FLAG_OPEN or Achievement.FLAG_OPEN == 0 then
    Dialog:Say("成就系统即将开放，敬请期待。")
    return
  end

  local szMsg = "你可以在我这里进行成就系统相关的一些操作。请问你要做什么？"
  local tbOpt = {
    { "修复已完成成就", self.RepairAchievementDlg, self },
    { "成就侠义值商店", self.OpenAchievementShop, self },
    { "我只是随便看看" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:OpenAchievementShop()
  me.OpenShop(181, 10)
end

function tbNpc:RepairAchievementDlg()
  local szMsg = "如果成就系统发布之前，您已经达成了某些成就，可以在这里点击修复，把这些成就找回来。请问，现在要修复吗？"
  local tbOpt = {
    { "是的", self.RepairAchievement, self },
    { "离开" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:RepairAchievement()
  Achievement:RepairAchievement()
end

function Relation:SyncIbBinCoinInfo(tbInfoList, bFirst)
  if not tbInfoList or #tbInfoList == 0 then
    local szMsg = ""

    if bFirst == 1 then
      szMsg = string.format("目前没有可领取的绑定%s。", IVER_g_szCoinName)
    else
      szMsg = "全部领取完了"
    end
    Dialog:Say(szMsg, {
      { "退出" },
    })
    return
  end
  if bFirst ~= 1 then
    Dialog:Say(string.format("继续领取其他密友的返还%s", IVER_g_szCoinName), {
      { "确定", Relation.ShowGetIbCoin, self, tbInfoList },
      { "下次再来领取", Relation.CancelGainCoin, self },
    })
  else
    self:ShowGetIbCoin(tbInfoList)
  end
end

function Relation:ShowGetIbCoin(tbInfoList)
  for nIndex, tbInfo in ipairs(tbInfoList) do
    Dialog:Say("您的密友 " .. tbInfo.szName .. string.format(" 在奇珍阁进行了消费，您获得返还绑定%s<color=red>", IVER_g_szCoinName) .. tbInfo.nBindCoin .. "<color>个", {
      { "确定", Relation.GainIbCoin, self, tbInfo.szName, tbInfo.nBindCoin },
      { "下次再来领取", Relation.CancelGainCoin, self },
    })
  end
end

function Relation:GainIbCoin(szTarget, nBindCoin)
  if me.nBindCoin + nBindCoin >= 2000000000 then
    me.Msg(string.format("您的绑定%s到达上限了，领取失败。", IVER_g_szCoinName))
    return
  end
  me.GainIbCoin(szTarget)

  -- 成就，获得密友返还金币
  Achievement:FinishAchievement(me, 14)
end

function Relation:CancelGainCoin()
  me.CancelGainIbCoin()
end

-- 找到当前师徒称号以及对应玩家的名字
function Relation:FindTitleAndName(szSuffix, pPlayer)
  local szPlayerName = ""

  local tbAllTitle = pPlayer.GetAllTitle()
  local szCurShituTitle = ""
  local bFind = 0
  for _, tbTitleInfo in pairs(tbAllTitle) do
    -- 自定义称号大类的id是250
    local nTitleLen = string.len(tbTitleInfo.szTitleName)
    local nSuffixLen = string.len(szSuffix)
    local nStart, nEnd = string.find(tbTitleInfo.szTitleName, szSuffix)
    if tbTitleInfo.byTitleGenre == 250 and nTitleLen > nSuffixLen and nStart ~= nEnd and nEnd == nTitleLen then
      szPlayerName = string.sub(tbTitleInfo.szTitleName, 1, nTitleLen - nSuffixLen)
      return tbTitleInfo.szTitleName, szPlayerName
    end
  end
end

function Relation:CheckTeacherTitle()
  -- 玩家的身份是师傅的话，检查无效的师徒称号并删除
  local szCurTitle, szPlayerName = self:FindTitleAndName(EventManager.IVER_szTeacherTitle, me)
  if szCurTitle and szPlayerName and me.IsTeacherRelation(szPlayerName, 1) ~= 1 then
    me.RemoveSpeTitle(szCurTitle)
  end
end

function Relation:CheckStudentTitle()
  -- 玩家的身份是弟子的话，检查无效的师徒称号并删除
  local szCurTitle, szPlayerName = self:FindTitleAndName(EventManager.IVER_szTudiTitle, me)
  if szCurTitle and szPlayerName and me.IsTeacherRelation(szPlayerName, 0) ~= 1 then
    me.RemoveSpeTitle(szCurTitle)
  end
end

-- 在玩家上线的时候，检查师徒称号是否有效
function Relation:CheckShituTitle()
  self:CheckTeacherTitle()
  self:CheckStudentTitle()
end

-- 注册通用上线事件
PlayerEvent:RegisterGlobal("OnLoginOnly", Relation.CheckShituTitle, Relation)
