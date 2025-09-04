-- 文件名　：xiakedaily_npc.lua
-- 创建者　：huangxiaoming
-- 创建时间：2011-03-15 12:10:10
-- 描  述  ：

Require("\\script\\task\\xiakedaily\\xiakedaily_def.lua")

local tbClass = Npc:GetClass("xiakedaily")

function tbClass:OnDialog()
  local szMsg = "   江湖之上风起云涌，真正的侠义乃是急人之难、出言必信、锄强扶弱的豪侠之士。还望侠客们鼎力相助！\n"
  if XiakeDaily:CheckOpen() ~= 1 then
    Dialog:Say(szMsg)
    return 0
  end
  if me.nLevel < XiakeDaily.LEVEL_LIMIT or me.nFaction <= 0 then
    Dialog:Say(szMsg .. "   这个任务比较凶险，必须要达到<color=yellow>100级<color>且已经<color=yellow>加入门派<color>的侠士才能接取。")
    return 0
  end
  XiakeDaily:PredictAccept()
  local nTask1 = KGblTask.SCGetDbTaskInt(DBTASK_XIAKEDAILY_TASK_ID1)
  local nTask2 = KGblTask.SCGetDbTaskInt(DBTASK_XIAKEDAILY_TASK_ID2)
  local nTomorrowTask1 = KGblTask.SCGetDbTaskInt(DBTASK_XIAKEDAILY_TOMORROW_TASK_ID1)
  local nTomorrowTask2 = KGblTask.SCGetDbTaskInt(DBTASK_XIAKEDAILY_TOMORROW_TASK_ID2)
  local nWeekTimes = XiakeDaily:GetWeekTimes()
  local szMsgEx = ""
  if nWeekTimes == XiakeDaily.WEEK_MAX_TIMES then
    szMsgEx = "\n\n<color=red>您本周的任务可接次数已用完<color>"
  end
  local nDayAcceptTimes = XiakeDaily:GetTask(XiakeDaily.TASK_ACCEPT_COUNT)
  local szMsg = string.format("<newdialog>   江湖之上风起云涌，真正的侠义乃是急人之难，出言必信，锄强扶弱的豪侠之士。还望侠客们鼎力相助！\n<color=green>             今日侠客任务\n\n  <color><color=yellow>%s<color>   <color=yellow>%s<color>\n    %s     %s\n\n本周已完成侠客任务<color=green>%s/%s<color>次。\n今日剩余接取任务次数<color=green>%s<color>次。\n<color=green>任务完成奖励<color>  <item=18,1,1233,1><color=gold> X %s<color>%s", Lib:StrFillC(XiakeDaily.TaskFile[nTask1].szDynamicDesc, 16), Lib:StrFillC(XiakeDaily.TaskFile[nTask2].szDynamicDesc, 16), XiakeDaily.ID_TO_IMAGE[nTask1], XiakeDaily.ID_TO_IMAGE[nTask2], nWeekTimes, XiakeDaily.WEEK_MAX_TIMES, nDayAcceptTimes, XiakeDaily.AWARD_ONCE, szMsgEx)
  local nFlag = XiakeDaily:GetTask(XiakeDaily.TASK_STATE)
  local tbOpt = {}
  if nFlag == 0 and nDayAcceptTimes > 0 and nWeekTimes < XiakeDaily.WEEK_MAX_TIMES then
    table.insert(tbOpt, { "<color=yellow>接取侠客任务<color>", self.OnDialog_Accept, self })
  elseif nFlag == 1 and XiakeDaily:GetTask(XiakeDaily.TASK_FIRST_TARGET) == 1 and XiakeDaily:GetTask(XiakeDaily.TASK_SECOND_TARGET) == 1 then -- 任务已完成
    table.insert(tbOpt, { "<color=yellow>领取任务奖励<color>", self.OnDialog_Finish, self })
  end
  table.insert(tbOpt, { "查询明日任务", self.QueryTomorrowTask, self })
  table.insert(tbOpt, { "侠客令牌商店", self.OpenXiaKeShop, self })
  table.insert(tbOpt, { "侠客任务介绍", self.Introduce, self })
  table.insert(tbOpt, { "我随便看看" })

  Dialog:Say(szMsg, tbOpt)
end

function tbClass:Introduce()
  local szMsg =
    "<color=green>【简介】<color>\n   每天可以在我这儿接取<color=yellow>每日侠客任务<color>，次日凌晨<color=yellow>3点<color>前完成今日侠客任务并在我这里交付，可以获得<color=yellow>2个<color>侠客令。达到<color=yellow>100级<color>且已<color=yellow>加入门派<color>的侠客可以接取任务。\n\n<color=green>【玩法】<color>   我会每天在<color=yellow>逍遥谷、军营任务、藏宝图副本<color>中随机选取任意2项。每天可以完成一个侠客任务，每人每周最多做<color=yellow>5次<color>，第5次完成任务时会额外获得<color=yellow>4枚<color>侠客令，最多可获得<color=yellow>14枚<color>侠客令。\n\n<color=green>【奖励】<color>   侠客令可以购买<color=yellow>[侠义礼包]（有效期7天）<color>，每<color=yellow>28个<color>侠客令牌换1个<color=yellow>[侠义礼包]<color>，礼包中含有一个<color=yellow>9玄<color>哟!<color=red>注意<color>：军营需要开启朱雀石并击杀最终的隐藏BOSS，随机任务遇到藏宝图我会额外给予你对应的藏宝图挑战次数，逍遥谷一星难度必须通五关，三星及以上难度通四关以上。"
  local tbOpt = {
    { "返回上一层", self.OnDialog, self },
    { "结束对话" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbClass:QueryTomorrowTask()
  if XiakeDaily:CheckOpen() ~= 1 then
    Dialog:Say(" 江湖之上风起云涌，真正的侠义乃是急人之难、出言必信、锄强扶弱的豪侠之士。\n")
    return 0
  end
  local nTomorrowTask1 = KGblTask.SCGetDbTaskInt(DBTASK_XIAKEDAILY_TOMORROW_TASK_ID1)
  local nTomorrowTask2 = KGblTask.SCGetDbTaskInt(DBTASK_XIAKEDAILY_TOMORROW_TASK_ID2)
  local szMsg = string.format("<newdialog>   江湖之上风起云涌，真正的侠义乃是急人之难，出言必信，锄强扶弱的豪侠之士。还望侠客们鼎力相助！\n<color=green>             明日侠客任务\n\n<color>  <color=yellow>%s<color>   <color=yellow>%s<color>\n    %s     %s\n", Lib:StrFillC(XiakeDaily.TaskFile[nTomorrowTask1].szDynamicDesc, 16), Lib:StrFillC(XiakeDaily.TaskFile[nTomorrowTask2].szDynamicDesc, 16), XiakeDaily.ID_TO_IMAGE[nTomorrowTask1], XiakeDaily.ID_TO_IMAGE[nTomorrowTask2])
  local tbOpt = {
    { "返回上一层", self.OnDialog, self },
    { "结束对话" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbClass:OnDialog_Accept(nSure)
  if XiakeDaily:CheckOpen() ~= 1 then
    Dialog:Say(" 江湖之上风起云涌，真正的侠义乃是急人之难、出言必信、锄强扶弱的豪侠之士。\n")
    return 0
  end
  if me.nLevel < XiakeDaily.LEVEL_LIMIT or me.nFaction <= 0 then
    Dialog:Say("   江湖之上风起云涌，真正的侠义乃是急人之难，出言必信，锄强扶弱的豪侠之士。\n   这个任务比较凶险，必须要达到<color=yellow>100级<color>且已经<color=yellow>加入门派<color>的侠士才能接取。")
    return 0
  end
  XiakeDaily:PredictAccept()
  local nTask1 = KGblTask.SCGetDbTaskInt(DBTASK_XIAKEDAILY_TASK_ID1)
  local nTask2 = KGblTask.SCGetDbTaskInt(DBTASK_XIAKEDAILY_TASK_ID2)
  local nFlag = XiakeDaily:GetTask(XiakeDaily.TASK_STATE)
  local nWeekTimes = XiakeDaily:GetWeekTimes()
  local nDayAcceptTimes = XiakeDaily:GetTask(XiakeDaily.TASK_ACCEPT_COUNT)
  if nFlag == 0 and nDayAcceptTimes > 0 and nWeekTimes < XiakeDaily.WEEK_MAX_TIMES then
    if nSure and nSure == 1 then
      local tbResult = Task:DoAccept(XiakeDaily.TASK_MAIN_ID, XiakeDaily.TASK_MAIN_ID)
      if not tbResult then
        Dialog:Say("对不起，你的任务已满，无法接取任务。")
        return 0
      end
      if XiakeDaily.TASK_TREASUREMAP2_GROUPID[nTask1] then
        local nCount = me.GetTask(XiakeDaily.TASK_TREASUREMAP2_GROUPID[nTask1][1], XiakeDaily.TASK_TREASUREMAP2_GROUPID[nTask1][2])
        if nCount < TreasureMap.TreasureMapEx.MAXCOUNT then
          me.SetTask(XiakeDaily.TASK_TREASUREMAP2_GROUPID[nTask1][1], XiakeDaily.TASK_TREASUREMAP2_GROUPID[nTask1][2], nCount + 1)
        else
          me.Msg("藏宝图挑战机会上限累计为100次，您的次数已经达到上限不能再累计。")
        end
      end
      if XiakeDaily.TASK_TREASUREMAP2_GROUPID[nTask2] then
        local nCount = me.GetTask(XiakeDaily.TASK_TREASUREMAP2_GROUPID[nTask2][1], XiakeDaily.TASK_TREASUREMAP2_GROUPID[nTask2][2])
        if nCount < TreasureMap.TreasureMapEx.MAXCOUNT then
          me.SetTask(XiakeDaily.TASK_TREASUREMAP2_GROUPID[nTask2][1], XiakeDaily.TASK_TREASUREMAP2_GROUPID[nTask2][2], nCount + 1)
        else
          me.Msg("藏宝图挑战机会上限累计为100次，您的次数已经达到上限不能再累计。")
        end
      end
      local nTaskLogId = nTask1 + nTask2 * 100
      StatLog:WriteStatLog("stat_info", "richangrenwu", "accept", me.nId, me.GetHonorLevel(), nTaskLogId)
    else
      local nCount = XiakeDaily.AWARD_ONCE
      local nWeekTimes = XiakeDaily:GetWeekTimes()
      if nWeekTimes + 1 == XiakeDaily.WEEK_MAX_TIMES then
        nCount = nCount + XiakeDaily.AWARD_EXTRA
      end
      local szMsg = string.format("<newdialog><color=green>             今日侠客任务\n\n<color>  <color=yellow>%s<color>   <color=yellow>%s<color>\n    %s     %s\n\n<color=green>今日完成任务的奖励<color><item=18,1,1233,1><color=gold> X %s<color>", Lib:StrFillC(XiakeDaily.TaskFile[nTask1].szDynamicDesc, 16), Lib:StrFillC(XiakeDaily.TaskFile[nTask2].szDynamicDesc, 16), XiakeDaily.ID_TO_IMAGE[nTask1], XiakeDaily.ID_TO_IMAGE[nTask2], nCount)
      if nWeekTimes + 1 == XiakeDaily.WEEK_MAX_TIMES then
        if Item.tbStone:GetOpenDay() ~= 0 then
          szMsg = szMsg .. string.format("<item=18,1,1317,1><color=gold> X %s<color>", XiakeDaily.AWARD_STONE)
          szMsg = szMsg .. string.format("<item=18,1,1312,1,0,0,0,0,0,0,0,0,1><color=gold> X %s<color>", XiakeDaily.AWARD_STONE_KEY)
        end
      end
      local tbOpt = {
        { "确定接取", self.OnDialog_Accept, self, 1 },
        { "我在考虑考虑" },
      }
      Dialog:Say(szMsg, tbOpt)
    end
  end
end

function tbClass:OnDialog_Finish()
  if XiakeDaily:CheckOpen() ~= 1 then
    Dialog:Say(" 江湖之上风起云涌，真正的侠义乃是急人之难、出言必信、锄强扶弱的豪侠之士。\n")
    return 0
  end
  if XiakeDaily:CheckTaskFinish() == 1 then
    --Task:CloseTask(XiakeDaily.TASK_MAIN_ID, "finish");
    XiakeDaily:ShowAwardDialog()
  end
end

function tbClass:OpenXiaKeShop()
  if XiakeDaily:CheckOpen() ~= 1 then
    Dialog:Say("侠客商店暂时关闭")
    return 0
  end
  me.OpenShop(190, 3)
end
