-- 文件名　：keju_npc.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-10-24 15:24:00
-- 功能说明：剑侠世界科举考试

if not MODULE_GAMESERVER then
  return
end

SpecialEvent.JxsjKeju = SpecialEvent.JxsjKeju or {}
local JxsjKeju = SpecialEvent.JxsjKeju

-------------------------------------------------------------------------------------------
--乡试考官
-------------------------------------------------------------------------------------------

local tbXSNpc = Npc:GetClass("keju_xiangshi")

function tbXSNpc:OnDialog()
  local szMsg = "秋试及第，桂榜飘香！天子有诏，敕命我等来此举办乡试，遴选饱学之士进京觐圣，观其才而重用之。乡试时间为每周一至周五12:30~13:00、18:30~19:00，侠士是否有兴趣来挑战一下呀？\n<color=green>（提示：答题过程中，按回车键即可打字聊天）<color>"
  local tbOpt = {
    { "我要参加乡试", JxsjKeju.OnAttend, JxsjKeju, 1 },
    { "查看乡试桂榜", self.QueryList, self },
    { "领取乡试奖励", self.GetAward, self },
    { "询问殿试资格", self.AttendSecondInfo, self },
    { "科举考试相关介绍", self.OnInfor, self },
    { "我再看看" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbXSNpc:QueryList()
  local szList = "乡试榜单张贴于此，恭贺以下侠士荣登桂榜！\n\n"
  if not JxsjKeju.tbJxsjKejuGrade[1][1] then
    Dialog:Say("桂榜并未发布任何信息。")
    return
  end
  for i, tb in ipairs(JxsjKeju.tbJxsjKejuGrade[1]) do
    local nPlayerId = KGCPlayer.GetPlayerIdByRoleId(tb[1])
    if nPlayerId then
      local szName = KGCPlayer.GetPlayerName(nPlayerId)
      if szName then
        szList = szList .. Lib:StrFillL(string.format("第%s名", i), 8) .. Lib:StrFillL(szName, 18) .. string.format("%s积分", tb[2]) .. "\n"
      end
    end
  end
  Dialog:Say(szList, { { "我知道了" } })
end

function tbXSNpc:GetAward(nFlag)
  local nDayGradeDate = me.GetTask(JxsjKeju.nTaskGroup, JxsjKeju.nGradeDate)
  local nGradePre = me.GetTask(JxsjKeju.nTaskGroup, JxsjKeju.nGradePre)
  local nGradeTime = me.GetTask(JxsjKeju.nTaskGroup, JxsjKeju.nGradeTime)
  local nGetAwardDay = me.GetTask(JxsjKeju.nTaskGroup, JxsjKeju.nGetAwardDay)
  local nWeek = tonumber(os.date("%w", Lib:GetDate2Time(nDayGradeDate)))
  --领取日期比积分日期大或者积分日期为周六默认没有奖励领取
  if nDayGradeDate <= nGetAwardDay or JxsjKeju.tbEventWeeklyType[nWeek] == 2 then
    Dialog:Say("您没有可以领取的奖励，请先参加科举考试。")
    return
  end
  local nGrade = math.fmod(nGradePre, 10000) + nGradeTime
  if nGrade < JxsjKeju.nMinAwardGradeType1 then
    Dialog:Say(string.format("您上场乡试积分不足<color=red>%s分<color>，没有领取奖励。", JxsjKeju.nMinAwardGradeType1))
    return
  end
  local nKinSilverTimes = 1
  local nExpTimes = 1
  local nAddKinRepute = 0
  if nGrade >= 600 then
    nKinSilverTimes = 1.5
    nExpTimes = 2
    nAddKinRepute = 3
  end
  local nKinRepute = 15 + nAddKinRepute
  local nAddExp = me.GetBaseAwardExp() * 60 * nExpTimes
  local nKinSilver = math.floor(400 * Lib:_GetXuanEnlarge(TimeFrame:GetServerOpenDay()) * nKinSilverTimes)
  if not nFlag then
    local szMsg = string.format("经本官查看，侠士本次乡试科举的积分为<color=yellow>%s<color>分, 可以领取以下奖励：\n%s经验\n%s威望\n%s两家族工资<color=red>（需要侠士加入家族才可获得）<color>\n确定领取乡试奖励吗？", nGrade, nAddExp, nKinRepute, nKinSilver)
    Dialog:Say(szMsg, { { "确定领取", self.GetAward, self, 1 }, { "我再想想" } })
    return
  end
  me.AddKinReputeEntry(nKinRepute)
  me.AddExp(nAddExp)
  local bKin = 0
  if me.dwKinId > 0 then
    me.AddKinSilverMoney(nKinSilver)
    bKin = 1
  end
  me.SetTask(JxsjKeju.nTaskGroup, JxsjKeju.nGetAwardDay, nDayGradeDate)
  Achievement:FinishAchievement(me, 517)
  StatLog:WriteStatLog("stat_info", "keju", "get_award", me.nId, 1, 1, 1)
  Dbg:WriteLog("jxsjkeju", "GetDayAward", me.szName, me.szAccount, bKin, nDayGradeDate)
end

function tbXSNpc:AttendSecondInfo()
  local nWeeklyGrade = me.GetTask(JxsjKeju.nTaskGroup, JxsjKeju.nWeeklyGrade)
  local nAttendWeekDate = me.GetTask(JxsjKeju.nTaskGroup, JxsjKeju.nAttendWeekDate)
  local nWeek = Lib:GetLocalWeek(GetTime())
  if nAttendWeekDate ~= nWeek then
    nWeeklyGrade = 0
  end
  if nWeeklyGrade >= JxsjKeju.nMinAtWeeklyCount then
    Dialog:Say(string.format("您本周的积分为：<color=yellow>%s分<color>，已经获得殿试资格。", nWeeklyGrade))
    return
  end
  Dialog:Say(string.format("您本周的积分为<color=yellow>%s分<color>不足<color=red>%s分<color>，未获得殿试资格。", nWeeklyGrade, JxsjKeju.nMinAtWeeklyCount))
end

function tbXSNpc:OnInfor()
  Task.tbHelp:OpenNews(5, "科举考试")
end

--青玉案
local tbQingyuA = Npc:GetClass("keju_qingyuan")

function tbQingyuA:OnDialog()
  local szMsg = "秋试及第，桂榜飘香！天子有诏，敕命我等来此举办乡试，遴选饱学之士进京觐圣，观其才而重用之。乡试时间为每周一至周五12:30~13:30、18:30~19:00，侠士是否有兴趣来挑战一下呀？\n<color=green>（提示：答题过程中，按回车键即可打字聊天）<color>"
  local tbOpt = {
    { "我要参加乡试", JxsjKeju.OnAttend, JxsjKeju, 1 },
    { "我再看看" },
  }
  Dialog:Say(szMsg, tbOpt)
end
-------------------------------------------------------------------------------------------
--殿试考官
-------------------------------------------------------------------------------------------

local tbDSNpc = Npc:GetClass("keju_dianshi")

function tbDSNpc:OnDialog()
  local szMsg = "春闱试才后，金榜题名时！圣上亲临崇政殿，欲博求俊彦于科场中，提名者均赏其朝服笏板。殿试时间（周日16:00~16:15）以一炷龙诞香为限，各位贤能都准备好了么？\n<color=green>（提示：答题过程中，按回车键即可打字聊天）<color>"
  local tbOpt = {
    { "我要参加殿试", JxsjKeju.OnAttend, JxsjKeju, 2 },
    { "查看殿试金榜", self.QueryListAward, self },
    { "领取殿试奖励", Npc:GetClass("keju_jingbang").GetAward, Npc:GetClass("keju_jingbang") },
    { "科举考试相关介绍", self.OnInfor, self },
    { "我再看看" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbDSNpc:QueryListAward(nFlag)
  local nWeek = tonumber(GetLocalDate("%w"))
  local nEventType = JxsjKeju.tbEventWeeklyType[nWeek]
  if nEventType == 2 and JxsjKeju:CheckIsOpen(1) == 1 then
    Dialog:Say("殿试正在进行中，金榜还未发布。")
    return
  end
  local szList = "殿试金榜张贴于此，恭贺以下侠士金榜题名！\n\n"
  local nPage = 0
  if nFlag then
    nPage = 1
  end
  if not JxsjKeju.tbJxsjKejuGrade[2][1] then
    Dialog:Say("金榜并未发布任何信息。")
    return
  end
  local nCount = 0
  for i = nPage * 10 + 1, nPage * 10 + 10 do
    if JxsjKeju.tbJxsjKejuGrade[2] and JxsjKeju.tbJxsjKejuGrade[2][i] then
      local tb = JxsjKeju.tbJxsjKejuGrade[2][i]
      local nPlayerId = KGCPlayer.GetPlayerIdByRoleId(tb[1])
      if nPlayerId then
        local szName = KGCPlayer.GetPlayerName(nPlayerId)
        if szName then
          szList = szList .. Lib:StrFillL(string.format("第%s名", i), 8) .. Lib:StrFillL(szName, 18) .. string.format("%s积分", tb[2]) .. "\n"
          nCount = nCount + 1
        end
      end
    end
  end
  if nFlag then
    Dialog:Say(szList, { { "上一页", self.QueryListAward, self }, { "我知道了" } })
  elseif JxsjKeju.tbJxsjKejuGrade[2] and #JxsjKeju.tbJxsjKejuGrade[2] > 10 and nPage == 0 then
    Dialog:Say(szList, { { "下一页", self.QueryListAward, self, 1 }, { "我知道了" } })
  else
    Dialog:Say(szList, { { "我知道了" } })
  end
end

function tbDSNpc:OnInfor()
  Task.tbHelp:OpenNews(5, "科举考试")
end

--龙纹御案
local tbLongwenyuA = Npc:GetClass("keju_longwenyuan")

function tbLongwenyuA:OnDialog()
  local szMsg = "春闱试才后，金榜题名时！圣上亲临崇政殿，欲博求俊彦于科场中，提名者均赏其朝服笏板。殿试时间殿试时间（周日16:00~16:15）以一炷龙涎香为限，各位贤才都准备好了么？\n<color=green>（提示：答题过程中，按回车键即可打字聊天）<color>"
  local tbOpt = {
    { "我要参加殿试", JxsjKeju.OnAttend, JxsjKeju, 2 },
    { "我再看看" },
  }
  Dialog:Say(szMsg, tbOpt)
end

-------------------------------------------------------------------------------------------
--御题金榜
-------------------------------------------------------------------------------------------

local tbJBNpc = Npc:GetClass("keju_jingbang")

function tbJBNpc:OnDialog()
  local szMsg = "春闱试才后，金榜题名时！"
  local tbOpt = {
    { "查看殿试金榜", Npc:GetClass("keju_dianshi").QueryListAward, Npc:GetClass("keju_dianshi") },
    { "领取殿试奖励", self.GetAward, self },
    { "我再看看" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbJBNpc:GetAward(nFlag)
  local nWeek = tonumber(GetLocalDate("%w"))
  local nEventType = JxsjKeju.tbEventWeeklyType[nWeek]
  if nEventType == 2 and JxsjKeju:CheckIsOpen(1) == 1 then
    Dialog:Say("殿试正在进行中，金榜还未发布，请稍后再来领取。")
    return
  end
  local nTime = tonumber(GetLocalDate("%H%M"))
  if nEventType == 2 and nTime >= JxsjKeju.tbType2GetAwardTime[1] and nTime <= JxsjKeju.tbType2GetAwardTime[2] then
    Dialog:Say("请侠客前往临安广场参加状元花车巡游，殿试金榜稍后公布！")
    return
  end

  local nNum = KGblTask.SCGetDbTaskInt(DBTASK_JXSJ_KEJU_WEEKGRADE)
  local nGetAwardFlag = me.GetTask(JxsjKeju.nTaskGroup, JxsjKeju.nGetAwardWeek)
  if nGetAwardFlag >= nNum then
    Dialog:Say("你没有可以领取的奖励。")
    return
  end
  if not JxsjKeju.tbJxsjKejuGrade_Week[nNum] then
    JxsjKeju:SortWeekGradeList(nNum)
  end

  local tbInfo = JxsjKeju.tbJxsjKejuGrade_Week[nNum][me.szRoleId]
  if tbInfo then
    local tbAward = JxsjKeju.tbWeeklyAward[tbInfo[1]]
    if tbAward then
      local nFirstNeedBag = 0
      if tbInfo[2] == 3 or tbInfo[2] == 2 then
        nFirstNeedBag = 1
      elseif tbInfo[2] == 1 then
        nFirstNeedBag = 2
      end
      local nNeedBag = KItem.GetNeedFreeBag(JxsjKeju.tbWeekAwardItem[1], JxsjKeju.tbWeekAwardItem[2], JxsjKeju.tbWeekAwardItem[3], JxsjKeju.tbWeekAwardItem[4], nil, tbAward[3])
      if me.CountFreeBagCell() < nNeedBag + 1 + nFirstNeedBag then
        Dialog:Say(string.format("对不起，您身上的背包空间不足，需要%s格背包空间。", nNeedBag + 1 + nFirstNeedBag))
        return
      end
      if not nFlag then
        local szMsg = string.format("经圣上恩准，侠士此次殿试科举排名<color=yellow>第%s<color>、积分为<color=yellow>%s<color>分, 可以领取以下奖励：\n%s经验\n%s个周末活动徽章\n%s两家族工资<color=red>（需要侠士加入家族才可获得）<color>", tbInfo[2], tbInfo[3], me.GetBaseAwardExp() * tbAward[2], tbAward[3], math.floor(tbAward[1] * Lib:_GetXuanEnlarge(TimeFrame:GetServerOpenDay())))
        if tbInfo[2] == 1 then
          szMsg = szMsg .. "\n恭喜您是<color=yellow>新科状元<color>，还可以额外获得<color=yellow>御赐仙鹤绣金囊（18格背包）、玉逍遥（状元御赐坐骑）、状元披风资格及御赐状元称号<color>"
        elseif tbInfo[2] == 2 then
          szMsg = szMsg .. "\n恭喜您是<color=yellow>榜眼及第<color>，还可以额外获得<color=yellow>御赐孔雀描银囊（15格背包）及榜眼及第称号<color>"
        elseif tbInfo[2] == 3 then
          szMsg = szMsg .. "\n恭喜您是<color=yellow>探花及第<color>，还可以额外获得<color=yellow>御赐孔雀描银囊（15格背包）及探花及第称号<color>"
        end
        szMsg = szMsg .. "，更有机会获得御赐伴读书童跟宠。\n确定领取殿试奖励吗？"
        Dialog:Say(szMsg, { { "确定领取", self.GetAward, self, 1 }, { "我再想想" } })
        return
      end
      self:AddAward(tbAward, tbInfo)
      me.SetTask(JxsjKeju.nTaskGroup, JxsjKeju.nGetAwardWeek, nNum)
    else
      Dialog:Say("您殿试科举分数不理想，没有奖励可以领取，请再接再厉。")
      return
    end
  else
    Dialog:Say("您并没有奖励可以领取。")
    return
  end
end

function tbJBNpc:AddAward(tbAward, tbInfo)
  me.AddExp(me.GetBaseAwardExp() * tbAward[2])
  local bKin = 0
  if me.dwKinId > 0 then
    me.AddKinSilverMoney(math.floor(tbAward[1] * Lib:_GetXuanEnlarge(TimeFrame:GetServerOpenDay())))
    bKin = 1
  end
  me.AddStackItem(JxsjKeju.tbWeekAwardItem[1], JxsjKeju.tbWeekAwardItem[2], JxsjKeju.tbWeekAwardItem[3], JxsjKeju.tbWeekAwardItem[4], nil, tbAward[3])
  local nRate = MathRandom(100)
  if nRate <= tbAward[4] then
    local pItem = me.AddItemEx(unpack(JxsjKeju.tbPartnerItem))
    if pItem then
      me.SetItemTimeout(pItem, 7 * 24 * 60, 0)
      KDialog.NewsMsg(0, Env.NEWSMSG_NORMAL, string.format("【%s】名妙笔生花，皇帝特赐其伴读书童，以彰龙恩！", me.szName))
      StatLog:WriteStatLog("stat_info", "keju", "sp_award", me.nId, JxsjKeju.szPartnerItem)
    end
  end
  --冠军额外加其他奖励
  if tbInfo[2] == 1 then
    local pItem = me.AddItemEx(unpack(JxsjKeju.tbFirstHorse))
    if pItem then
      pItem.Bind(1)
      me.SetItemTimeout(pItem, 7 * 24 * 60, 0)
    end
    local pBox = me.AddItemEx(unpack(JxsjKeju.tb18Box))
    if pBox then
      pBox.SetCustom(Item.CUSTOM_TYPE_MAKER, me.szName)
      pBox.Sync()
    end
    me.AddSkillState(2411, 2, 2, 7 * 24 * 3600 * 18, 1, 0, 1)
    me.AddTitle(16, 1, 1, 1)
    me.SetCurTitle(16, 1, 1, 1)
    me.Msg("恭喜您获得殿试第一名的成绩。")
    Achievement:FinishAchievement(me, 511)
    StatLog:WriteStatLog("stat_info", "keju", "get_award", me.nId, 2, 1, 1)
  elseif tbInfo[2] == 2 or tbInfo[2] == 3 then
    local pBox = me.AddItemEx(unpack(JxsjKeju.tb15Box))
    if pBox then
      pBox.SetCustom(Item.CUSTOM_TYPE_MAKER, me.szName)
      pBox.Sync()
    end
    me.AddTitle(16, 1, tbInfo[2], tbInfo[2])
    me.SetCurTitle(16, 1, tbInfo[2], tbInfo[2])
    Achievement:FinishAchievement(me, 510 + tbInfo[2])
    StatLog:WriteStatLog("stat_info", "keju", "get_award", me.nId, 2, 1, tbInfo[2])
  else
    StatLog:WriteStatLog("stat_info", "keju", "get_award", me.nId, 2, tbInfo[1], 1)
  end
  Achievement:FinishAchievement(me, 518)
  Achievement:FinishAchievement(me, 519)
  Achievement:FinishAchievement(me, 520)
  Achievement:FinishAchievement(me, 521)

  if tbInfo[3] >= 700 then
    Achievement:FinishAchievement(me, 514)
  end
  if tbInfo[3] >= 500 then
    Achievement:FinishAchievement(me, 515)
  end

  if tbInfo[2] > 3 and tbInfo[3] >= 900 then
    me.AddTitle(16, 1, 4, 4)
    me.SetCurTitle(16, 1, 4, 4)
  elseif tbInfo[2] > 3 and tbInfo[3] >= 700 then
    me.AddTitle(16, 1, 5, 5)
    me.SetCurTitle(16, 1, 5, 5)
  elseif tbInfo[2] > 3 and tbInfo[3] >= 500 then
    me.AddTitle(16, 1, 6, 6)
    me.SetCurTitle(16, 1, 6, 6)
  end
  Dbg:WriteLog("jxsjkeju", "GetWeeklyAward", me.szName, me.szAccount, bKin, tbInfo[1], tbInfo[2], tbInfo[3])
end

-------------------------------------------------------------------------------------------
--通用逻辑
-------------------------------------------------------------------------------------------

--参加考试
function JxsjKeju:OnAttend(nType)
  local nFlag, szErrorMsg = self:CheckCanAttend(nType)
  if nFlag == 0 then
    Dialog:Say(szErrorMsg)
    return
  end
end

--检查能不能参加
function JxsjKeju:CheckCanAttend(nType)
  --等级检查
  if me.nLevel < self.nAttendLevelMin then
    return 0, string.format("你的等级不足%s级。", self.nAttendLevelMin)
  end
  --门派检查
  if me.nFaction <= 0 then
    return 0, "你还是小白，请先加入门派。"
  end
  --时间检查
  local nTime = tonumber(GetLocalDate("%H%M"))
  if nType <= 0 or self.nQuestionType <= 0 or self:CheckIsOpen(1) == 0 then
    return 0, "科举考试还未开始，请周一至周五12:30~13:00, 18:30~19:00参加乡试，周日16:00~16:30参加殿试，提前10分钟可以参加。"
  end

  if not self:CheckIsAttending(me.nId) and self.nQuestionType == 1 and ((nTime >= self.tbEndStartTime[1] and nTime < self.tbEndTime[1]) or (nTime >= self.tbEndStartTime[3] and nTime < self.tbEndTime[3])) then
    return 0, "科举考试马上结束，您还是改天再来参加吧。"
  end

  --是否在考官跟前
  if self:CheckIsNear(me) == 0 then
    if self.nQuestionType == 2 then
      return 0, "请前往殿试报名处参加活动。"
    else
      return 0, "请前往乡试报名处参加活动。"
    end
  end

  --当天是否参加过或者是否是已经在参加的名单里面了
  if self:CheckIsAttended(me) == 1 and not self:CheckIsAttending(me.nId) then
    return 0, "您今天已经参加过了，还是改天再来吧。"
  end

  --是否有乡试奖励没有领取
  if self:HasAward() == 1 then
    return 0, "您上场乡试奖励还没有领取，请先领取了才能参加。"
  end

  --检查当天答题是否结束
  if self:CheckIsOver(me) == 1 then
    return 0, "您今天已经答满题目了，还是改天再来吧。"
  end

  --今天没参加过要检查周参加次数及或者是殿试资格
  if not self:CheckIsAttending(me.nId) then
    local nAttendDate = me.GetTask(self.nTaskGroup, self.nAttendWeekDate)
    local nAttendCount = me.GetTask(self.nTaskGroup, self.nAttendCount)
    local nWeeklyGrade = me.GetTask(self.nTaskGroup, self.nWeeklyGrade)
    local nWeek = Lib:GetLocalWeek(GetTime())
    if nAttendDate ~= nWeek then
      me.SetTask(self.nTaskGroup, self.nAttendWeekDate, nWeek)
      me.SetTask(self.nTaskGroup, self.nAttendCount, 0)
      me.SetTask(self.nTaskGroup, self.nWeeklyGrade, 0)
      nAttendCount = 0
      nWeeklyGrade = 0
    end
    if nType == 1 and nAttendCount >= self.nMaxWeeklyCount then
      return 0, string.format("本周只能参加%s次乡试，机会还是留给其他人吧。", self.nMaxWeeklyCount)
    elseif nType == 2 and nWeeklyGrade < self.nMinAtWeeklyCount then
      return 0, string.format("您本周的乡试积分不足%s分，没有资格参加殿试。", self.nMinAtWeeklyCount)
    end
    self:AttendEvent(nType)
    me.SetTask(self.nTaskGroup, self.nAttendCount, nAttendCount + 1)
    Dbg:WriteLog("jxsjkeju", "AttendKeJu", me.szName, me.szAccount, nType)
  --已经在参加名单里面的，并且已经开始发题了
  elseif self:CheckIsOpen(2) == 1 then
    self:AskPlayerQuestion(nType)
  elseif self:CheckIsOpen(1) == 1 then
    me.SetTask(self.nTaskGroup, self.nOpenUiFalg, 1)
    me.CallClientScript({ "UiManager:OpenWindow", "UI_JXSJKEJU", nType })
  else
    return 0, "科举考试还未开始，请稍后再来。"
  end
  return 1
end

--给玩家发题目
function JxsjKeju:AskPlayerQuestion(nType)
  local tbQuestion = self.tbQuestionDay[self.nJourNum] --当前题目
  if tbQuestion then
    local bDisable = 0 --本题可以答还是不可以答(流水号不对，或者是已经答过就不能再答了)
    if self:CheckIsFirstAnswer() == 0 or self:CheckQuestionIsRight() == 0 then
      bDisable = 1
    end
    local tbQuestionEx = { tbQuestion[1], tbQuestion[3], tbQuestion[4], tbQuestion[5], tbQuestion[6], tbQuestion[7] }
    local nGradePre = me.GetTask(self.nTaskGroup, self.nGradePre)
    local nAllCount = math.floor(nGradePre / 10000)
    --当前题目还没有发过，并且答题时间还有10秒以上就发题
    if self.nTimeAskS - GetTime() + self.nQuestionTime >= 10 and self:CheckQuestionIsRight() == 0 then
      --总数加1
      me.SetTask(self.nTaskGroup, self.nAskJourNum, tonumber(GetLocalDate("%m%d%H")) * 1000 + self.nJourNum)
      me.SetTask(self.nTaskGroup, self.nGradePre, nGradePre + 10000)
      --时间还是要加30秒
      me.SetTask(self.nTaskGroup, self.nAnswerTime, me.GetTask(self.nTaskGroup, self.nAnswerTime) + self.nTimeAskS)
      nAllCount = nAllCount + 1
      bDisable = 0
    end
    --当天成绩
    local nGradePreEx = math.fmod(nGradePre, 10000)
    local nTimeGrade = me.GetTask(self.nTaskGroup, self.nGradeTime)
    --周成绩
    local nWeeklyGrade = me.GetTask(self.nTaskGroup, self.nWeeklyGrade)

    --成绩单
    local tbPlayerGradeList = {}
    for i = 1, 10 do
      local tb = self.tbJxsjKejuGrade[self.nQuestionType][i]
      if tb then
        local nPlayerId = KGCPlayer.GetPlayerIdByRoleId(tb[1])
        if nPlayerId then
          local szName = KGCPlayer.GetPlayerName(nPlayerId)
          if szName then
            table.insert(tbPlayerGradeList, { szName, tb[2] })
          end
        end
      end
    end
    if nType == 2 then
      nAllCount = self.nJourNum
    end
    me.SetTask(self.nTaskGroup, self.nOpenUiFalg, 1)
    me.CallClientScript({
      "UiManager:OpenWindow",
      "UI_JXSJKEJU",
      nType,
      JxsjKeju.nTimeAskS - GetTime() + JxsjKeju.nQuestionTime,
      tbQuestionEx,
      self.nJourNum,
      nAllCount,
      bDisable,
      nGradePreEx + nTimeGrade,
      nWeeklyGrade,
      tbPlayerGradeList,
    })
  else --否则是例题时间
    me.SetTask(self.nTaskGroup, self.nOpenUiFalg, 1)
    me.CallClientScript({ "UiManager:OpenWindow", "UI_JXSJKEJU", nType })
  end
end
