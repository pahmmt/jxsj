-- 文件名　：weekendfish_npc.lua
-- 创建者　：huangxiaoming
-- 创建时间：2011-08-05 14:06:00
-- 描  述  ：

Require("\\script\\task\\weekendfish\\weekendfish_def.lua")

local tbClass = Npc:GetClass("weekednfish_npc")

function tbClass:OnDialog()
  local szMsg = "你好，有什么能帮到你的？\n"
  local tbOpt = {}
  local tbDuanWu2011 = SpecialEvent.DuanWu2011 or {}
  local nDate = tonumber(GetLocalDate("%Y%m%d"))
  if WeekendFish:CheckOpen() == 1 then
    szMsg = "    每周六和周日的<color=green>10：00 - 14：00和16：00 - 20：00<color>，世界各大水域将出现鱼儿。在我这里购买鱼饵和鱼竿，使用<color=yellow>精工鱼饵<color>能钓到的鱼将会更好些，每人每天可以钓<color=yellow>50条<color>鱼。"
    if WeekendFish:CheckCanAcceptTask(me) == 1 then
      table.insert(tbOpt, { "<color=yellow>接取钓鱼任务<color>", self.OnDialog_Accept, self })
    elseif WeekendFish:CheckCanAwardTask(me) == 1 then
      table.insert(tbOpt, { "<color=yellow>领取任务奖励<color>", self.OnDialog_Finish, self })
    end
    if WeekendFish:CheckCanHandInFish(me) == 1 then
      local nHandinNum = WeekendFish:GetTodyRemainHandInFishNum(me)
      table.insert(tbOpt, { "<color=pink>我现在要交鱼<color>", self.OnDialog_HandIn, self, nHandinNum })
    end
    if WeekendFish:CheckCanChangeAward(me) == 1 then
      table.insert(tbOpt, { "领取交鱼奖励", self.OnDialog_Award, self })
    end
    if WeekendFish:CheckFishTime() == 1 then
      table.insert(tbOpt, { "查询鱼群地图", self.OnDialog_ViewFishMap, self })
    end
    table.insert(tbOpt, { "<color=blue>幸运鱼排行榜<color>", self.OnDialog_LuckFishRank, self })
    table.insert(tbOpt, { "钓鱼活动介绍", self.Introduce, self })
    table.insert(tbOpt, { "<color=green>渔夫用具商店<color>", self.OpenFishShop, self })
  end
  if tbDuanWu2011.IS_OPEN == 1 and nDate >= tbDuanWu2011.OPEN_DAY then
    table.insert(tbOpt, { "端午忠魂商店", tbDuanWu2011.OpenShop, tbDuanWu2011 })
    table.insert(tbOpt, { "兑换忠魂腰带", tbDuanWu2011.ChangeDuanWuBelt, tbDuanWu2011 })
  end
  table.insert(tbOpt, { "我只是路过" })
  Dialog:Say(szMsg, tbOpt)
  return 1
end

function tbClass:OpenFishShop()
  if WeekendFish._OPEN ~= 1 then
    Dialog:Say("渔夫用具商店暂时关闭")
    return 0
  end
  me.OpenShop(200, 1)
end

function tbClass:Introduce()
  Task.tbHelp:OpenNews(5, "周末钓鱼活动")
end

function tbClass:OnDialog_Accept()
  local szMsg = "  鱼肥水美的季节岂能不参加钓鱼活动，周六和周日在我这里接取钓鱼任务，完成钓鱼任务后不仅可以获得<color=yellow>海量经验<color>，还可获得<color=yellow>水产证书<color>使你今天所钓的全部鱼儿<color=yellow>奖励翻倍<color>。\n  周末两天的钓鱼任务都完成之后，在下周更接取任务的时候可获得<color=green>秦洼的祝福<color>，此状态可以让你钓到更重的鱼哦。\n<color=yellow>注意：钓鱼任务可以组队接取也可以单人接取，组队之后队友接到任务都是和队长一样的。<color>"
  local tbOpt = {
    { "<color=yellow>接取钓鱼任务<color>", self.SingleAcceptTask, self },
    { "我再考虑考虑" },
  }
  if me.IsCaptain() == 1 then
    table.insert(tbOpt, 1, { "我想与队友一起钓鱼", self.CaptainAcceptTask, self })
  end
  Dialog:Say(szMsg, tbOpt)
end

-- 单人接任务
function tbClass:SingleAcceptTask()
  self:AcceptTask(1)
end

-- 队长接任务
function tbClass:CaptainAcceptTask(nFlag)
  local nRes, szMsg = WeekendFish:CheckCanAcceptTask(me)
  if nRes ~= 1 then
    Dialog:Say(szMsg)
    return 0
  end
  local tbTeamMembers, nMemberCount = me.GetTeamMemberList()
  local tbPlayerName = {}
  if not tbTeamMembers then
    Dialog:Say("秦洼：你当前并没有在任何队伍中哦！")
    return
  end
  local nTaskValue = 0
  if nFlag == 1 then
    nTaskValue = WeekendFish:RandTeamFishShareTaskList()
    me.SetTask(WeekendFish.TASK_GROUP, WeekendFish.TASK_TEAM_IDGROUP, nTaskValue)
    self:AcceptTask()
  end
  local szCaptainName = me.szName
  for i = 1, nMemberCount do
    if me.nPlayerIndex ~= tbTeamMembers[i].nPlayerIndex and me.nMapId == tbTeamMembers[i].nMapId then
      Setting:SetGlobalObj(tbTeamMembers[i])
      if WeekendFish:CheckCanAcceptTask(me) == 1 then
        if nFlag and nFlag == 1 then
          WeekendFish:ClearTaskValue(me)
          me.SetTask(WeekendFish.TASK_GROUP, WeekendFish.TASK_TEAM_IDGROUP, nTaskValue)
          local szMsg = string.format("秦洼：你所在队伍的队长<color=yellow>%s<color>想要与你共享钓鱼任务，你愿意接受吗？", szCaptainName)
          local tbOpt = {
            { "是", self.AcceptTask, self },
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
  if nFlag and nFlag == 1 then
    return
  end
  if #tbPlayerName <= 0 then
    Dialog:Say("秦洼：当前并没有符合能与你一起共享任务条件的队友\n")
    return
  end
  local szMembersName = "\n"
  for i = 1, #tbPlayerName do
    szMembersName = szMembersName .. "<color=yellow>" .. tbPlayerName[i][2] .. "<color>\n"
  end
  local szMsg = string.format("秦洼：现在符合能与你共享任务的队友有：\n%s\n你想和队友一起共享你接到的任务么？", szMembersName)
  local tbOpt = {
    { "是的", self.CaptainAcceptTask, self, 1 },
    { "不了" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbClass:AcceptTask(nClearGroupTask)
  local nRes, szMsg = WeekendFish:CheckCanAcceptTask(me)
  if nRes ~= 1 then
    Dialog:Say(szMsg)
    return 0
  end
  if nClearGroupTask and nClearGroupTask == 1 then
    WeekendFish:ClearTaskValue(me)
  end
  local nPreAcceptDay = me.GetTask(WeekendFish.TASK_GROUP, WeekendFish.TASK_ACCEPT_DAY)
  local tbResult = Task:DoAccept(WeekendFish.TASK_MAIN_ID, WeekendFish.TASK_MAIN_ID)
  if not tbResult then
    Dialog:Say("对不起，你的任务已满，无法接取任务。")
    return 0
  end
  local nWeek = tonumber(GetLocalDate("%W"))
  local nTaskWeek = me.GetTask(WeekendFish.TASK_GROUP, WeekendFish.TASK_ACHIEVEBUF_WEEK)
  local nTimes = me.GetTask(WeekendFish.TASK_GROUP, WeekendFish.TASK_ACHEIVEBUF_NUM)
  if ((nWeek == nTaskWeek + 1 or nWeek < nTaskWeek) and nTimes == 2) or (nPreAcceptDay == 0) then -- 上一周做了两次或是第一次接任务
    me.SetTask(WeekendFish.TASK_GROUP, WeekendFish.TASK_ACHIEVEBUF_WEEK, nWeek)
    me.SetTask(WeekendFish.TASK_GROUP, WeekendFish.TASK_ACHEIVEBUF_NUM, 0)
    me.AddSkillState(WeekendFish.STATE_SKILLID, 1, 2, WeekendFish.STATE_TIME, 1, 0, 1)
  end
  if nClearGroupTask == 1 then -- 单人接任务
    StatLog:WriteStatLog("stat_info", "fishing", "get_task", me.nId, 1, 0)
  else
    local tbTeamMembers, nMemberCount = me.GetTeamMemberList()
    StatLog:WriteStatLog("stat_info", "fishing", "get_task", me.nId, nMemberCount, me.nTeamId)
  end
  Dialog:SendBlackBoardMsg(me, "完成钓鱼任务获得证书可使今日钓鱼总奖励翻倍")
  if nPreAcceptDay == 0 then
    me.Msg("首次接取钓鱼任务，获得秦洼的祝福，此祝福可增加钓到更重的鱼的几率。每周连续两次完成钓鱼任务在下周接取任务时可获得此祝福。")
  end
end

function tbClass:OnDialog_Finish()
  if WeekendFish:CheckCanAwardTask(me) == 1 then
    WeekendFish:ShowAwardDialog()
  end
end

-- 兑换奖励
function tbClass:OnDialog_HandIn(nHandinNum)
  Dialog:OpenGift(string.format("把你钓到鱼放进来吧，我不会亏待你的，你今天还可上交<color=yellow>%s条<color>鱼", nHandinNum), nil, { self.OnHandInFish, self })
end

function tbClass:OnHandInFish(tbItem)
  local nRes, szMsg = WeekendFish:CheckCanHandInFish(me)
  if nRes ~= 1 then
    Dialog:Say(szMsg)
  end
  if #tbItem <= 0 then
    return 0
  end
  local nTempNum = 0
  for _, tbTemp in pairs(tbItem) do
    local pItem = tbTemp[1]
    if WeekendFish:CheckIsFish(pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel) ~= 1 then
      Dialog:Say("我只要鱼，其他东西就不要给我拉。")
      return 0
    end
    nTempNum = nTempNum + 1
  end
  local nTodayHandInNum = me.GetTask(WeekendFish.TASK_GROUP, WeekendFish.TASK_HANDIN_NUM)
  if nTodayHandInNum + nTempNum > WeekendFish.MAX_FISH_DAYTIMES then
    Dialog:Say("你上交的鱼超过50条了，不知道哪里来的，你自己消化吧")
    return 0
  end
  local nHandInNum = 0
  local tbTaskFishWeight = { 0, 0, 0 } -- 3种任务鱼的重量
  local nWeightSum = 0
  for _, tbTemp in pairs(tbItem) do
    local pItem = tbTemp[1]
    local nWeight = pItem.GetGenInfo(1, 0) -- 重量
    local nTaskId = WeekendFish:GetFishTaskId(pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel)
    if me.DelItem(pItem) ~= 1 then
      Dbg:WriteLog("WeekendFish", "fish2award_failure", me.szName, string.format("%s,%s,%s,%s", pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel))
    else
      if nTaskId > 0 and nTaskId <= 3 then
        tbTaskFishWeight[nTaskId] = tbTaskFishWeight[nTaskId] + nWeight
      end
      nWeightSum = nWeightSum + nWeight
      nHandInNum = nHandInNum + 1
    end
  end
  WeekendFish:AddTaskFishRank(me, tbTaskFishWeight) -- 增加鱼排行榜自己的积分
  me.SetTask(WeekendFish.TASK_GROUP, WeekendFish.TASK_HANDIN_NUM, nTodayHandInNum + nHandInNum)
  local nTodayHandInWeight = me.GetTask(WeekendFish.TASK_GROUP, WeekendFish.TASK_HANDIN_WEIGHT) + nWeightSum
  me.SetTask(WeekendFish.TASK_GROUP, WeekendFish.TASK_HANDIN_WEIGHT, nTodayHandInWeight)
  if nTodayHandInWeight >= 1000 then
    Achievement:FinishAchievement(me, 388)
  end
  if nTodayHandInWeight >= 1500 then
    Achievement:FinishAchievement(me, 389)
  end
  if nTodayHandInWeight >= 1700 then
    Achievement:FinishAchievement(me, 390)
  end
  local nRemainHandInNum = WeekendFish.MAX_FISH_DAYTIMES - nTodayHandInNum - nHandInNum
  local szMsg = string.format("  今日已成功上交<color=yellow>%s斤<color>鱼，我都记着了，你今天还有<color=yellow>%s条<color>鱼可以上交。如果确定不交了可以选择领奖。\n\n<color=red>注意：一天只能领取一次奖励，领奖之后就不能再交鱼了。<color>\n", nTodayHandInWeight, nRemainHandInNum)
  local tbOpt = {
    { "我再去钓一些吧" },
    { "我现在就要领奖", self.OnDialog_Award, self },
  }
  if nRemainHandInNum > 0 then
    table.insert(tbOpt, 1, { "<color=yellow>我还要继续交鱼<color>", self.OnDialog_HandIn, self, nRemainHandInNum })
  end
  Dialog:Say(szMsg, tbOpt)
end

function tbClass:OnDialog_Award(nSure)
  local nRes, szMsg = WeekendFish:CheckCanChangeAward(me)
  if nRes ~= 1 then
    Dialog:Say(szMsg)
  end
  local nWeightSum = me.GetTask(WeekendFish.TASK_GROUP, WeekendFish.TASK_HANDIN_WEIGHT)
  if nWeightSum < WeekendFish.AWARD_LEVEL[2][1] then
    Dialog:Say(string.format("你今天才交了<color=yellow>%s<color>斤，最低要120斤才能换奖励，再去努力吧。", nWeightSum))
    return 0
  end
  local nAwardType = 1
  for i = #WeekendFish.AWARD_LEVEL, 1, -1 do
    if nWeightSum >= WeekendFish.AWARD_LEVEL[i][1] then
      nAwardType = i
      break
    end
  end
  local nAwardTypeNoRecom = 1
  local nWeightSumNoRecom = math.floor(nWeightSum * WeekendFish.AWARD_NORECOMMENDATION)
  for i = #WeekendFish.AWARD_LEVEL, 1, -1 do
    if nWeightSumNoRecom >= WeekendFish.AWARD_LEVEL[i][1] then
      nAwardTypeNoRecom = i
      break
    end
  end
  local nRecommendationFlag = 0
  local tbFind = me.FindItemInBags(unpack(WeekendFish.ITEM_RECOMMENDATION))
  if tbFind[1] then
    nRecommendationFlag = 1
  end
  local nHandInNum = me.GetTask(WeekendFish.TASK_GROUP, WeekendFish.TASK_HANDIN_NUM)
  if not nSure then
    local szMsg = ""
    if nRecommendationFlag == 0 then
      szMsg = string.format("   干得不错！你一共交了<color=yellow>%s/%s<color>条鱼，总重量是<color=yellow>%s斤<color>，你身上<color=red>没有<color><color=yellow>水产证书<color>我只能给你<color=yellow>第%s档<color>的奖励，如果你有水产证书我能给你<color=yellow>第%s档<color>的奖励，奖励共分<color=yellow>7档<color>。\n   水产证书可以通过<color=yellow>完成钓鱼任务<color>获得，当天的证书会在当天23:30分过期。\n\n<color=red>注意：一天只能领取一次奖励，领奖之后就不能再交鱼了。<color>\n", nHandInNum, WeekendFish.MAX_FISH_DAYTIMES, nWeightSum, nAwardTypeNoRecom, nAwardType)
    else
      szMsg = string.format("   干得不错！你一共交了<color=yellow>%s/%s<color>条鱼，总重量是<color=yellow>%s斤<color>，你身上有水产证书，我可以给你<color=yellow>第%s档<color>的奖励，奖励共分<color=yellow>7档<color>。确定领取吗？\n\n<color=red>注意：一天只能领取一次奖励，领奖之后就不能再交鱼了。<color>\n", nHandInNum, WeekendFish.MAX_FISH_DAYTIMES, nWeightSum, nAwardType)
    end
    local tbOpt = {
      { "确定领取", self.OnDialog_Award, self, 1 },
      { "我再想想" },
    }
    Dialog:Say(szMsg, tbOpt)
    return 0
  end
  local tbAward = {}
  if nRecommendationFlag == 1 then
    tbAward = WeekendFish.AWARD_LEVEL[nAwardType]
  else
    tbAward = WeekendFish.AWARD_LEVEL[nAwardTypeNoRecom]
  end
  local nBagCount = 0
  for i = 2, #tbAward do
    nBagCount = nBagCount + tbAward[i]
  end
  if me.CountFreeBagCell() < nBagCount then
    Dialog:Say(string.format("需要<color=yellow>%s格<color>格背包空间， 整理下再来", nBagCount))
    return 0
  end
  if nRecommendationFlag == 1 then
    me.ConsumeItemInBags(1, WeekendFish.ITEM_RECOMMENDATION[1], WeekendFish.ITEM_RECOMMENDATION[2], WeekendFish.ITEM_RECOMMENDATION[3], WeekendFish.ITEM_RECOMMENDATION[4], -1)
  end
  me.SetTask(WeekendFish.TASK_GROUP, WeekendFish.TASK_HANDIN_AWARD, 1)
  me.SetTask(WeekendFish.TASK_GROUP, WeekendFish.TASK_HANDIN_WEIGHT, 0)
  for i = 2, #tbAward do
    if tbAward[i] > 0 then
      for j = 1, tbAward[i] do
        local pItem = me.AddItem(WeekendFish.ITEM_AWARD_BOX[1], WeekendFish.ITEM_AWARD_BOX[2], WeekendFish.ITEM_AWARD_BOX[3], WeekendFish.ITEM_AWARD_BOX[4] + i - 2)
        if pItem then
          pItem.Bind(1)
        end
      end
    end
  end
  StatLog:WriteStatLog("stat_info", "fishing", "fish_award", me.nId, nWeightSum, nRecommendationFlag, nHandInNum)
  me.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, string.format("钓鱼领奖：玩家：%s, 交鱼重量：%s，水产证书：%s", me.szName, nWeightSum, nRecommendationFlag))
end

-- 排行榜
function tbClass:OnDialog_LuckFishRank()
  local nRes, szMsg = WeekendFish:CheckViewLuckRank()
  if nRes ~= 1 then
    Dialog:Say(szMsg)
    return 0
  end
  local tbTaskList = {}
  tbTaskList[1] = KGblTask.SCGetDbTaskInt(DBTASK_WEEKENDFISH_TASK_ID1)
  tbTaskList[2] = KGblTask.SCGetDbTaskInt(DBTASK_WEEKENDFISH_TASK_ID2)
  tbTaskList[3] = KGblTask.SCGetDbTaskInt(DBTASK_WEEKENDFISH_TASK_ID3)
  local tbOpt = {}
  for i = 1, 3 do
    local tbInfo = {
      string.format("<color=yellow>【%s】<color>排行榜", KItem.GetNameById(unpack(WeekendFish.ITEM_FISH_ID[tbTaskList[i]]))),
      self.OnDialog_ViewLunckFishRank,
      self,
      i,
      tbTaskList[i],
    }
    table.insert(tbOpt, tbInfo)
  end

  if WeekendFish.tbLuckFishRank_Ex then
    for nType, tbRank in pairs(WeekendFish.tbLuckFishRank_Ex) do
      if #tbRank > 0 then
        local tbInfo = { string.format("<color=yellow>合服从服第%s种鱼<color>排行榜", nType), self.OnDialog_ViewLunckFishRank_Ex, self, nType }
        table.insert(tbOpt, tbInfo)
      end
    end
  end

  table.insert(tbOpt, { "我只是路过" })
  szMsg = "   每周我将选取3种鱼为本周幸运鱼，凡是幸运鱼的总斤数排名前列的侠客可以得到幸运排行榜奖励，<color=green>第1名<color>可以获得不绑定的<color=yellow>18格鱼篓背包<color>，<color=green>第2至5名<color>可以获得不绑定的<color=yellow>15格鱼篓背包<color>。背包可以放在任意背包栏位中。\n\n<color=green>领奖时间：周日23:32--下周五23:32<color>"
  Dialog:Say(szMsg, tbOpt)
end

function tbClass:OnDialog_ViewLunckFishRank(nType, nFishSort)
  local nRes, szMsg = WeekendFish:CheckViewLuckRank()
  if nRes ~= 1 then
    Dialog:Say(szMsg)
    return 0
  end
  if not WeekendFish.tbLuckFishRank then
    Dialog:Say("没找到排行榜")
    return 0
  end
  local nWeek = tonumber(GetLocalDate("%W"))
  if nWeek ~= me.GetTask(WeekendFish.TASK_GROUP, WeekendFish.TASK_RANK_WEEK) then
    me.SetTask(WeekendFish.TASK_GROUP, WeekendFish.TASK_RANK_WEEK, nWeek)
    me.SetTask(WeekendFish.TASK_GROUP, WeekendFish.TASK_WEIGHT_FISH1, 0)
    me.SetTask(WeekendFish.TASK_GROUP, WeekendFish.TASK_WEIGHT_FISH2, 0)
    me.SetTask(WeekendFish.TASK_GROUP, WeekendFish.TASK_WEIGHT_FISH3, 0)
  end
  local szFishName = KItem.GetNameById(unpack(WeekendFish.ITEM_FISH_ID[nFishSort]))
  if not WeekendFish.tbLuckFishRank[nType] or #WeekendFish.tbLuckFishRank[nType] == 0 then
    Dialog:Say(string.format("  今天还没有人来我这里交%s，赶紧去钓了给我吧，成就和奖励在等着你哦。", szFishName))
    return 0
  end
  local szMsg = ""
  local nFishWeight = me.GetTask(WeekendFish.TASK_GROUP, WeekendFish.TASK_WEIGHT_FISH1 + nType - 1)
  if nFishWeight > 0 then
    szMsg = szMsg .. string.format("你本轮已经上交了<color=yellow>%s斤<color><color=green>%s<color>\n\n", nFishWeight, szFishName)
  end
  szMsg = szMsg .. "<color=yellow>---------本轮幸运鱼重量排行-------<color>\n\n"
  for nRank = 1, #WeekendFish.tbLuckFishRank[nType] do
    szMsg = szMsg .. string.format("<color=yellow>%s<color>%s %s\n", Lib:StrFillC("第" .. nRank .. "名：", 8), Lib:StrFillC(WeekendFish.tbLuckFishRank[nType][nRank][1], 16), Lib:StrFillC(WeekendFish.tbLuckFishRank[nType][nRank][2] .. "斤", 8))
  end
  local tbOpt = {}
  if WeekendFish:CheckCanAwardLuckRank(me, nType) > 0 then
    table.insert(tbOpt, { "领取幸运鱼奖励", WeekendFish.GetLuckFishAward, WeekendFish, me.nId, nType })
  end
  table.insert(tbOpt, { "我知道了" })
  Dialog:Say(szMsg, tbOpt)
end

function tbClass:OnDialog_ViewLunckFishRank_Ex(nType)
  local nRes, szMsg = WeekendFish:CheckViewLuckRank()
  if nRes ~= 1 then
    Dialog:Say(szMsg)
    return 0
  end
  if not WeekendFish.tbLuckFishRank_Ex then
    Dialog:Say("没找到从服排行榜")
    return 0
  end
  local nWeek = tonumber(GetLocalDate("%W"))
  if nWeek ~= me.GetTask(WeekendFish.TASK_GROUP, WeekendFish.TASK_RANK_WEEK) then
    me.SetTask(WeekendFish.TASK_GROUP, WeekendFish.TASK_RANK_WEEK, nWeek)
    me.SetTask(WeekendFish.TASK_GROUP, WeekendFish.TASK_WEIGHT_FISH1, 0)
    me.SetTask(WeekendFish.TASK_GROUP, WeekendFish.TASK_WEIGHT_FISH2, 0)
    me.SetTask(WeekendFish.TASK_GROUP, WeekendFish.TASK_WEIGHT_FISH3, 0)
  end
  local tbOpt = {}
  if WeekendFish:CheckCanAwardLuckRank(me, nType) > 0 then
    table.insert(tbOpt, { "领取幸运鱼奖励", WeekendFish.GetLuckFishAward, WeekendFish, me.nId, nType })
  end
  szMsg = "这里是从服钓鱼领奖："
  table.insert(tbOpt, { "我知道了" })
  Dialog:Say(szMsg, tbOpt)
end

-- 查询鱼群点
function tbClass:OnDialog_ViewFishMap(nAreadId)
  if not WeekendFish.tbFishInMapList or #WeekendFish.tbFishInMapList <= 0 then
    return
  end
  if not nAreadId then
    local szMsg = "每个区域分布有<color=yellow>5种鱼类<color>。分布区域为：\n"
    local tbOpt = {}
    for i, tbInfo in ipairs(WeekendFish.tbAreaInfo) do
      table.insert(tbOpt, { tbInfo.szName, self.OnDialog_ViewFishMap, self, i })
      local szFish = "<color=yellow>" .. WeekendFish.tbAreaInfo[i].szName .. "：<color>"
      for j, nFishId in ipairs(WeekendFish.tbAreaInfo[i].tbFishList) do
        if j == 1 then
          szFish = szFish .. WeekendFish.TaskFile[nFishId].szFishName
        else
          szFish = szFish .. "，" .. WeekendFish.TaskFile[nFishId].szFishName
        end
      end
      szMsg = szMsg .. szFish .. "\n"
    end
    szMsg = szMsg .. "选择你要查看的区域："
    table.insert(tbOpt, { "我随便看看" })
    Dialog:Say(szMsg, tbOpt)
    return
  end
  local szMsg = ""
  for _, nFishId in ipairs(WeekendFish.tbAreaInfo[nAreadId].tbFishList) do
    szMsg = szMsg .. "<color=yellow>" .. WeekendFish.TaskFile[nFishId].szFishName .. "：<color>"
    local nFirst = 1
    for nMapId, _ in pairs(WeekendFish.tbFishInMapList[nFishId]) do
      if nFirst == 1 then
        nFirst = 0
      else
        szMsg = szMsg .. "、"
      end
      szMsg = szMsg .. GetMapNameFormId(nMapId)
    end
    szMsg = szMsg .. "\n"
  end
  Dialog:Say(szMsg, tbOpt)
end
