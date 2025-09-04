-- 修炼珠
-- zhouchenfei 2007.9

-- 状态保存结构1023
-- 1表示保存上一次更新时间
-- 2表示剩余积累时间
-- 3表示开启后剩余时间0表示未开启

-- 临时Item模板

local tbItem = Item:GetClass("xiulianzhu")

-- 一定等级下的经验上限
tbItem.tbExpLimit = {
  [1] = 300000, -- 10~19
  [2] = 480000, -- 20~29 的经验上限，2表示的是除10后的数方便查表
  [3] = 800000, -- 30~39
  [4] = 1200000, -- 40~49
  [5] = 1680000, -- 50~59
  [6] = 2200000, -- 60~69
  [7] = 2880000, -- 70~79
  [8] = 3600000, -- 80~89
  [9] = 4400000, -- 90~99
  [10] = 5280000, -- 100~109
  [11] = 6200000, -- 110~119
  [12] = 7240000, -- 120~129
  [13] = 8400000, -- 130~139
  [14] = 9600000, -- 140~149
  [15] = 9600000, -- 150
}

-- 一定等级下的修炼量上限
tbItem.tbXiuWeiLimit = {
  [1] = 2400,
  [2] = 2400,
  [3] = 4000,
  [4] = 6000,
  [5] = 8400,
  [6] = 11200,
  [7] = 14400,
  [8] = 18000,
  [9] = 22000,
  [10] = 26400,
}

tbItem.TASKGROUPID_HAVETASK = 1022 -- 判断是否接门派任务的标记变量

-- 判断是否接了门派任务标记变量
tbItem.tbTaskHaveId = {
  [2] = 188,
  [3] = 189,
  [4] = 190,
}

-- 玩家门派任务id
tbItem.tbPlayerTaskId = {
  [2] = {
    [1] = { 0x184, 0x245 },
    [2] = { 0x17F, 0x240 },
    [3] = { 0x187, 0x248 },
    [4] = { 0x181, 0x242 },
    [5] = { 0x186, 0x247 },
    [6] = { 0x188, 0x249 },
    [7] = { 0x180, 0x241 },
    [8] = { 0x185, 0x246 },
    [9] = { 0x183, 0x244 },
    [10] = { 0x182, 0x243 },
    [11] = { 0x189, 0x24A },
    [12] = { 0x18A, 0x24B },
  },
  [3] = {
    [1] = { 0x19A, 0x25B },
    [2] = { 0x195, 0x256 },
    [3] = { 0x19D, 0x25E },
    [4] = { 0x197, 0x258 },
    [5] = { 0x19C, 0x25D },
    [6] = { 0x19E, 0x25F },
    [7] = { 0x196, 0x257 },
    [8] = { 0x19B, 0x25C },
    [9] = { 0x199, 0x25A },
    [10] = { 0x198, 0x259 },
    [11] = { 0x19F, 0x260 },
    [12] = { 0x1A0, 0x261 },
  },
  [4] = {
    [1] = { 0x1A6, 0x267 },
    [2] = { 0x1A1, 0x262 },
    [3] = { 0x1A9, 0x26A },
    [4] = { 0x1A3, 0x264 },
    [5] = { 0x1A8, 0x269 },
    [6] = { 0x1AA, 0x26B },
    [7] = { 0x1A2, 0x263 },
    [8] = { 0x1A7, 0x268 },
    [9] = { 0x1A5, 0x266 },
    [10] = { 0x1A4, 0x265 },
    [11] = { 0x1AB, 0x26C },
    [12] = { 0x1AC, 0x26D },
  },
}

tbItem.MIN_PLAYER_LEVEL = Item.IVER_nXiuLianZhuLevel -- 最小使用修炼状态的等级要求
tbItem.TASKGROUP = 1023 -- 人物任务变量的groupID
tbItem.TASKLASTTIME_ID = 1 -- 人物任务变量的最后时间保存的ID
tbItem.TASKREMAINTIME_ID = 2 -- 人物任务变量的剩余累积时间ID 单位：小时乘10
tbItem.TASKEXPLIMIT_ID = 3 -- 剩余经验ID
tbItem.TASKXIUWEI_ID = 4 -- 剩余修为ID
tbItem.TASKOLDPRTIME_ID = 5 -- 回归老玩家还能领取修炼时间
tbItem.TASKCANGETEXTIME_ID = 6 -- 回归老玩家是否能获取额外修炼时间
tbItem.MAX_REMAINTIME = 14 -- 最大剩余累积时间
tbItem.SKILL_ID_EXP = 332 -- 332，经验加倍技能ID
tbItem.SKILL_ID_LUCKY = 333 -- 333, 幸运增值技能ID
tbItem.SKILL_ID_XIUWEI = 380 -- 修为ID
tbItem.XIULIANREMAINTIME = 1.5 -- 每天可加的修炼时间
tbItem.EXPTIMES = 1.2 -- 用于修改经验上限的倍数
tbItem.SKILL_ID_EXP_LEVEL = Item.IVER_nXiuLianZhuSkillLevel -- 332，经验加倍技能等级
-- by zhangjinpin@kingsoft
tbItem.TASK_XIULIAN_ADDTIME = 7 -- 通用的修炼珠增加时间
tbItem.LIMIT_ADDTIME = 10

tbItem.TASK_GROUP_COZONE = 2065 -- 表示合服变量的groupId
tbItem.TASK_GETEXTIME_FLAG = 2 -- 表示子服务器玩家是否领取额外时间的ID
tbItem.TASK_SUBPLAYER_EXTIME = 3 -- 表示子服务器玩家剩余的额外时间
tbItem.TASK_SUBPLAYER_ADDITEM = 4 -- 表示子服务器玩家物品补偿

tbItem.nCoZone_QiankundaiBaseNum = 3
tbItem.nCoZone_QiankundaiDet = 30
tbItem.nCoZone_CaibaoTuBaseDay = 7
tbItem.nCoZone_CaibaoTuDet = 7

tbItem.tbCoZoneAward_Qiankundai = { 18, 1, 1766, 1 }
tbItem.tbCoZoneAward_CaibaoPat = { 18, 1, 1724, 1 }

tbItem.DEF_COZONE_COMPOSE_MINDAY = 7

-- 升级判断，当到20级时自动为人物初始化修炼状态变量
function tbItem:OnLevelUp(nLevel)
  if nLevel < self.MIN_PLAYER_LEVEL then
    return
  end
  if me.GetTask(self.TASKGROUP, self.TASKLASTTIME_ID) ~= 0 then
    return
  end
  local nNowTime = GetTime()
  local nRemainTime = self.XIULIANREMAINTIME -- 问题：初始值是1.5还是0?
  local nRemainExp = 0
  me.SetTask(self.TASKGROUP, self.TASKLASTTIME_ID, nNowTime)
  me.SetTask(self.TASKGROUP, self.TASKREMAINTIME_ID, nRemainTime * 10)
  me.SetTask(self.TASKGROUP, self.TASKEXPLIMIT_ID, nRemainExp)
end

-- 使用道具
function tbItem:OnUse()
  local tbOpt = {}
  if EventManager.IVER_bOpenTiFu == 1 then
    tbOpt = { { "重置战斗技能点", self.ResetSkillPoint, self } }
  end

  local tbGerneFaction = Faction:GetGerneFactionInfo(me)

  for _, nFactionId in ipairs(tbGerneFaction) do
    if nFactionId ~= me.nFaction then
      local szMsg = "切换到" .. tostring(Player.tbFactions[nFactionId].szName)
      if Faction:IsCanSwitchFaction(me, nFactionId) == 0 then
        szMsg = string.format("<color=gray>%s<color>", szMsg)
      end
      table.insert(tbOpt, 1, { szMsg, self.OnSwitchFaction, self, nFactionId })
    end
  end

  if IsVoting() == 1 then
    tbOpt = Lib:MergeTable({ { "大师兄/大师姐候选人投票", FactionElect.VoteDialogLogin, FactionElect } }, tbOpt)
  end
  if Item.IVER_nEventCheck == 1 then
    if SpecialEvent.HundredKin:CheckEventTime2("view") == 1 then
      tbOpt = Lib:MergeTable({ { "家族积分排名", SpecialEvent.HundredKin.XiuLianZhu_Logic, SpecialEvent.HundredKin } }, tbOpt)
    end

    if SpecialEvent.WangLaoJi:CheckEventTime(4) == 1 then
      tbOpt = Lib:MergeTable({ { "查看江湖防上火行动排名", SpecialEvent.WangLaoJi.XiuLianZhu, SpecialEvent.WangLaoJi } }, tbOpt)
    end

    -- 通用的增加修炼珠时间 by zhangjinpin@kingsoft
    if self:CheckAddableCommon() == 1 then
      tbOpt = Lib:MergeTable({ { "领取补充修炼时间", self.CheckAddableCommon, self, 1 } }, tbOpt)
    end

    -- 武林大会相关 by zhangjinpin@kingsoft
    if Wldh.Qualification:Check_Yingxiong() == 1 then
      tbOpt = Lib:MergeTable({ { "<color=yellow>武林大会英雄帖<color>", Wldh.Qualification.Yingxiong_Dialog, Wldh.Qualification } }, tbOpt)
    end

    if Wldh.Qualification:Check_Vote() == 1 then
      tbOpt = Lib:MergeTable({ { "<color=yellow>武林盟主选举<color>", Wldh.Qualification.Vote_Dialog, Wldh.Qualification } }, tbOpt)
    end

    if Wldh.Qualification:Check_Query() == 1 then
      tbOpt = Lib:MergeTable({ { "<color=yellow>武林大会选手名单<color>", Wldh.Qualification.ShowMemberDialog, Wldh.Qualification } }, tbOpt)
    end

    --公测活动关闭
    --if (self:CheckAddable() == 1) then
    --	tbOpt = Lib:MergeTable({{"领取额外的修炼时间", self.CheckAddable, self, 1}}, tbOpt)
    --end

    --houxuan:金山20周年活动
    if SpecialEvent.tbTwentyAnniversary:CheckTime() == 1 then
      tbOpt = Lib:MergeTable({ { "领取金山20周年活动奖励", SpecialEvent.tbTwentyAnniversary.XiuLianZhuOnDialog, SpecialEvent.tbTwentyAnniversary, 1 } }, tbOpt)
    end

    --zjq:三周年活动
    if SpecialEvent.ZhouNianQing2011:CheckTime() == 1 then
      if me.nLevel >= SpecialEvent.ZhouNianQing2011.nPlayerLevelLimit and me.nFaction > 0 then
        tbOpt = Lib:MergeTable({ { "<color=yellow>领取三周年庆称号<color>", SpecialEvent.ZhouNianQing2011.GetPlayerTitle, SpecialEvent.ZhouNianQing2011 } }, tbOpt)
      end
    end

    -- 选秀:zounan
    if Wldh.Beauty:CheckState() ~= 0 then
      tbOpt = Lib:MergeTable({ { "《剑侠情缘》电视剧选秀投票", Wldh.Beauty.SelBeauty, Wldh.Beauty } }, tbOpt)
    end
  end

  --tbOpt = Lib:MergeTable({{"<color=yellow>2012欧洲杯有奖竞猜<color>", SpecialEvent.tbEuropean.Join, SpecialEvent.tbEuropean}}, tbOpt);

  if EventManager.IVER_bOpenChongZhiHuoDong == 1 and (self:CheckAddablePreMonth() == 1) then
    tbOpt = Lib:MergeTable({ { "领取本月额外修炼时间", self.CheckAddablePreMonth, self, 1 } }, tbOpt)
  end

  -- *******合服优惠，对子服务器玩家的额外修炼时间奖励*******
  if self:CheckAddableSubPlayer() == 1 then
    tbOpt = Lib:MergeTable({ { "补满修炼珠时间（合服补偿）", self.CheckAddableSubPlayer, self, 1 } }, tbOpt)
  end

  -- *******合服优惠，对子服务器玩家的额外修炼时间奖励*******
  if self:CheckAddableSubPlayerForItem() == 1 then
    tbOpt = Lib:MergeTable({ { "合服补偿物品补偿", self.CheckAddableSubPlayerForItem, self, 1 } }, tbOpt)
  end
  -- *************************************

  -- *******合服优惠，合服7天后过期*******
  if self:CheckAddableCoZone() == 1 and me.nLevel >= 50 then
    tbOpt = Lib:MergeTable({ { "领取合服额外奖励的修炼时间", self.CheckAddableCoZone, self, 1 } }, tbOpt)
  end
  -- *************************************

  -- 老玩家召回活动
  if self:CheckOldPCallBack() == 1 then
    tbOpt = Lib:MergeTable({ { "补充修炼时间", self.CheckOldPCallBack, self, 1 } }, tbOpt)
  end

  tbOpt = Lib:MergeTable({ { "购买福利精活", SpecialEvent.BuyJingHuo.OnDialog, SpecialEvent.BuyJingHuo } }, tbOpt)

  --额外购买4折精活
  local nSaveSecEx = me.GetTask(2027, 225)
  if me.GetTask(2027, 224) > 0 and tonumber(os.date("%Y%m%d", nSaveSecEx)) == tonumber(os.date("%Y%m%d", GetTime())) then
    tbOpt = Lib:MergeTable({ { "<color=yellow>额外购买4折活气散（小）x5<color>", SpecialEvent.BuyItem.BuyOnDialog, SpecialEvent.BuyItem, 23 } }, tbOpt)
  end
  local nSaveSec = me.GetTask(2027, 223)
  if me.GetTask(2027, 222) > 0 and tonumber(os.date("%Y%m%d", nSaveSec)) == tonumber(os.date("%Y%m%d", GetTime())) then
    tbOpt = Lib:MergeTable({ { "<color=yellow>额外购买4折精气散（小）x5<color>", SpecialEvent.BuyItem.BuyOnDialog, SpecialEvent.BuyItem, 22 } }, tbOpt)
  end
  --额外购买4折精活end

  local nNowLevel = me.nLevel
  if self.MIN_PLAYER_LEVEL > nNowLevel then -- 判断等级是否到达修炼要求等级
    tbOpt = Lib:MergeTable(tbOpt, { { "结束对话" } })
    Dialog:Say(string.format("	对不起，您还没达到修炼状态规定等级%d，加油继续升级哦！", tbItem.MIN_PLAYER_LEVEL), tbOpt)
    return 0
  end

  self:Update()

  local nExpSkillLevel, nExpStateType, nExpEndTime, bExpIsNoClearOnDeath = me.GetSkillState(self.SKILL_ID_EXP)
  local nLuckySkillLevel, nLuckyStateType, nLuckyEndTime, bLuckyIsNoClearOnDeath = me.GetSkillState(self.SKILL_ID_LUCKY)

  local nRemainTime = self:GetRemainTime()
  local nMiniter = (nRemainTime % 1) * 60

  local nRemainTime = self:GetRemainTime()
  local nMiniter = (nRemainTime % 1) * 60
  local szMsg = "    你把手放到这个珠宝上顿时感到精力充沛!" .. "<color=yellow>你可以开启修炼状态来获得打怪4倍经验以及幸运提升10增益，<color><color=red>修炼一旦开启在时间用完之前是无法关闭的。<color>" .. string.format("\n    你现在的累积修炼时间有：<color=green>%d<color><color=yellow>小时<color><color=green>%d<color><color=yellow>分钟<color>。你要开启多久呢?", nRemainTime, nMiniter)
  tbOpt = Lib:MergeTable(tbOpt, {
    --			{"重置战斗技能点", me.ResetFightSkillPoint},
    { "<color=yellow>我要开启修炼<color>", self.OnOpenXiuLianSure, self },
    { "结束对话" },
  })

  Dialog:Say(szMsg, tbOpt)

  return 0
end

function tbItem:OnOpenXiuLianSure()
  local nRemainTime = self:GetRemainTime()
  local nMiniter = (nRemainTime % 1) * 60
  local szMsg = "    你把手放到这个珠宝上顿时感到精力充沛!" .. "<color=yellow>你可以开启修炼状态来获得打怪4倍经验以及幸运提升10增益，<color><color=red>修炼一旦开启在时间用完之前是无法关闭的。<color>" .. string.format("\n    你现在的累积修炼时间有：<color=green>%d<color><color=yellow>小时<color><color=green>%d<color><color=yellow>分钟<color>。你要开启多久呢?", nRemainTime, nMiniter)
  local tbOpt = {
    { "我要开启0.5小时。", self.StartPractice, self, 0.5 },
    { "我要开启1小时。", self.StartPractice, self, 1 },
    { "我要开启1.5小时。", self.StartPractice, self, 1.5 },
    { "我要开启2小时。", self.StartPractice, self, 2 },
    { "我要开启4小时。", self.StartPractice, self, 4 },
    { "我要开启6小时。", self.StartPractice, self, 6 },
    { "我要开启8小时。", self.StartPractice, self, 8 },
    { "还是不开启了。" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbItem:OnSwitchFaction(nFactionId)
  local nFlag, szError = Faction:IsCanSwitchFaction(me, nFactionId)
  if nFlag == 0 then
    Dialog:Say(szError)
    return 0
  end

  local tbOpt = {
    { "确定", self.OnSwitchFactionEx, self, nFactionId },
    { "取消" },
  }

  Dialog:Say("确定要切换门派吗？\n\n<color=green>切换后参加义军任务、宋金战场、家族关卡、白虎堂等活动时将获得新门派对应的五行声望，同时在特定NPC处只能购买新门派对应的五行声望装备。<color>", tbOpt)
end

function tbItem:OnSwitchFactionEx(nFactionId)
  local nResult, szMsg = Faction:SwitchFaction(me, nFactionId)
  if szMsg then
    me.Msg(szMsg)
  end
end

if EventManager.IVER_bOpenTiFu == 1 then
  function tbItem:ResetSkillPoint()
    me.ResetFightSkillPoint()
    me.SetTask(2, 1, 1)
    me.UnAssignPotential()
  end

  function tbItem:OnOpenXiuLian(nChooseTime)
    local nLuckySkillLevel, nLuckyStateType, nLuckyEndTime, bLuckyIsNoClearOnDeath = me.GetSkillState(self.SKILL_ID_LUCKY)
    if nLuckySkillLevel > 0 then
      Dialog:Say("你已经处于修炼状态，再次开启将重新计算4倍经验时间，你确定要开启吗？", {
        --				{"重置战斗技能点", me.ResetFightSkillPoint},
        { "确定", self.StartPractice, self, nChooseTime },
        { "取消" },
      })
      return 0
    end

    self:StartPractice(nChooseTime)
  end
end

-- 从任务变量中获取累积剩余时间，单位：小时(对外接口)
function tbItem:GetReTime()
  self:Update()
  return me.GetTask(self.TASKGROUP, self.TASKREMAINTIME_ID) / 10
end

-- 从任务变量中获取累积剩余时间，单位：小时
function tbItem:GetRemainTime()
  return me.GetTask(self.TASKGROUP, self.TASKREMAINTIME_ID) / 10
end

-- 开启修炼状态
function tbItem:StartPractice(nChooseTime)
  self:Update()
  local nRemainTime = self:GetRemainTime()
  local szMsg = ""
  local tbOpt = {}
  local nNewLunckyTime = 0
  local nNewExpTime = 0
  local nNewXiuWeiTime = 0
  if nChooseTime > nRemainTime then
    szMsg = string.format("你的累积修炼时间不足，无法开启<color=yellow>(%.1f)<color>小时的修炼状态！", nChooseTime)
  else
    local nLuckySkillLevel, nLuckyStateType, nLuckyEndTime, bLuckyIsNoClearOnDeath = me.GetSkillState(self.SKILL_ID_LUCKY)
    local nExpSkillLevel, nExpStateType, nExpEndTime, bExpIsNoClearOnDeath = me.GetSkillState(self.SKILL_ID_EXP)
    local nXiuSkillLevel, nXiuStateType, nXiuEndTime, bXiuIsNoClearOnDeath = me.GetSkillState(self.SKILL_ID_XIUWEI)
    if not nLuckyEndTime then
      nLuckyEndTime = 0
    end

    if not nExpEndTime then
      nExpEndTime = 0
    end

    if not nXiuEndTime then
      nXiuEndTime = 0
    end

    szMsg = string.format("你已经增加了<color=yellow>(%.1f)<color>小时修炼状态，现在打怪将获得<color=yellow>4<color>倍经验，并且你的幸运值提高<color=yellow>10<color>！", nChooseTime)
    nRemainTime = nRemainTime - nChooseTime
    local nRemainExp = self:GetExpLimit()
    local nXiuWeiLimit = self:GetXiuWeiLimit()
    local nRemainLimitExp = me.GetTask(self.TASKGROUP, self.TASKEXPLIMIT_ID)
    if not nExpSkillLevel or nExpSkillLevel <= 0 then
      nRemainLimitExp = 0
    end
    local nAddExp = nRemainExp * nChooseTime + nRemainLimitExp
    nNewExpTime = nChooseTime * 18 * 3600 + nExpEndTime
    nNewLunckyTime = nChooseTime * 18 * 3600 + nLuckyEndTime
    nNewXiuWeiTime = nChooseTime * 18 * 3600 + nXiuEndTime

    if nRemainExp * self.LIMIT_ADDTIME < nAddExp then
      Dialog:Say("您修炼珠开启累加经验超过当前经验上限，不能继续开启修炼珠！")
      return 0
    end

    -- 加修为
    local nRemainXiuwei = me.GetTask(self.TASKGROUP, self.TASKXIUWEI_ID)
    if not nXiuSkillLevel or nXiuSkillLevel <= 0 then
      nRemainXiuwei = 0
    end
    local nAddXiuWei = nXiuWeiLimit * nChooseTime + nRemainXiuwei
    me.AddSkillState(self.SKILL_ID_EXP, self.SKILL_ID_EXP_LEVEL, 1, nNewExpTime, 1)
    me.SetTask(self.TASKGROUP, self.TASKEXPLIMIT_ID, nAddExp)
    me.AddSkillState(self.SKILL_ID_LUCKY, 2, 1, nNewLunckyTime, 1)
    me.AddSkillState(self.SKILL_ID_XIUWEI, 1, 1, nNewXiuWeiTime, 1)
    me.SetTask(self.TASKGROUP, self.TASKXIUWEI_ID, nAddXiuWei)
    me.SetTask(self.TASKGROUP, self.TASKREMAINTIME_ID, nRemainTime * 10)

    -- 统计玩家使用修炼珠
    Stats.Activity:AddCount(me, Stats.TASK_COUNT_XIULIANZHU, nChooseTime * 10)
  end
  Dialog:Say(szMsg)
end

function tbItem:ExpExhausted()
  local nExpSkillLevel, nExpStateType, nExpEndTime, bExpIsNoClearOnDeath = me.GetSkillState(self.SKILL_ID_EXP)
  local nXiuSkillLevel, nXiuStateType, nXiuEndTime, bXiuIsNoClearOnDeath = me.GetSkillState(self.SKILL_ID_XIUWEI)
  if nExpSkillLevel < 0 then
    return
  end
  me.RemoveSkillState(self.SKILL_ID_EXP)
  if nXiuSkillLevel > 0 then
    me.Msg("你已经达到本次修炼经验上限，现在你打怪将不能获得4倍经验，但是依然可以获得秘籍修为，同时幸运值依然提升10！")
  else
    me.Msg("你已经达到本次修炼经验上限，现在你打怪将不能获得4倍经验，但是幸运值依然提升10！")
  end
end

function tbItem:XiuWeiExhausted()
  local nXiuSkillLevel, nXiuStateType, nXiuEndTime, bXiuIsNoClearOnDeath = me.GetSkillState(self.SKILL_ID_XIUWEI)
  local nExpSkillLevel, nExpStateType, nExpEndTime, bExpIsNoClearOnDeath = me.GetSkillState(self.SKILL_ID_EXP)
  if nXiuSkillLevel < 0 then
    return
  end
  me.RemoveSkillState(self.SKILL_ID_XIUWEI)
  if nExpSkillLevel > 0 then
    me.Msg("你已经达到本次秘籍修为上限，现在你将不能获得秘籍修为，秘籍技能修炼度也不会提升，但是现在你打怪依然能获得4倍经验，同时幸运值依然提升10！")
  else
    me.Msg("你已经达到本次秘籍修为上限，现在你将不能获得秘籍修为，秘籍技能修炼度也不会提升，但是幸运值依然提升10！")
  end
end

function tbItem:CheckFactionTask(nIndex)
  if 20 >= me.nLevel or 50 <= me.nLevel then
    Dialog:Say("你当前等级不能接门派杀怪任务！")
    return 0
  end

  if me.nFaction <= 0 then
    Dialog:Say("你未加入门派，无法接门派任务")
  end

  local nNowIndex = math.floor(me.nLevel / 10)
  local nMod = math.fmod(me.nLevel, 10)

  if nMod == 0 then
    return 0
  end

  local tbTaskList = self.tbPlayerTaskId[nNowIndex]
  if not tbTaskList then
    Dialog:Say("当前等级段的门派任务不存在！")
    return 0
  end

  local tbOpt = {}
  for i, tbTask in ipairs(tbTaskList) do
    if tbTask[1] and tbTask[2] then
      if Task:HaveDoneSubTask(me, tbTask[1], tbTask[2]) == 0 and Task.tbTaskDatas[tbTask[1]] then
        local szTaskName = Task.tbTaskDatas[tbTask[1]].szName
        local tbReferData = Task.tbReferDatas[tbTask[2]]
        if tbReferData then
          local tbVisable = tbReferData.tbVisable
          local bOK = Lib:DoTestFuncs(tbVisable)
          if bOK then
            local tbSubData = Task.tbSubDatas[tbReferData.nSubTaskId]
            if tbSubData then
              local szMsg = ""
              if tbSubData.tbAttribute.tbDialog.Start then
                if tbSubData.tbAttribute.tbDialog.Start.szMsg then -- 未分步骤
                  szMsg = tbSubData.tbAttribute.tbDialog.Start.szMsg
                else
                  szMsg = tbSubData.tbAttribute.tbDialog.Start.tbSetpMsg[1]
                end
              end
              tbOpt[#tbOpt + 1] = { szTaskName, TaskAct.TalkInDark, TaskAct, szMsg, Task.AskAccept, Task, tbTask[1], tbTask[2] }
            end
          end
        end
      end
    end
  end
  tbOpt[#tbOpt + 1] = { "我再考虑考虑" }
  Dialog:Say(string.format("%d门派任务列表：", nNowIndex * 10), tbOpt)
end

function tbItem:GetExpLimit()
  local nExpLimit = 0
  local nLevel = me.nLevel
  local nIndex = 0
  if nLevel < self.MIN_PLAYER_LEVEL then
    return nExpLimit
  elseif nLevel > 150 then
    nIndex = 15
  else
    nIndex = math.floor(nLevel / 10)
  end
  nExpLimit = self.tbExpLimit[nIndex] * self.EXPTIMES
  return nExpLimit
end

function tbItem:GetXiuWeiLimit()
  local nXiuLimit = 0
  local nLevel = me.nLevel
  local nIndex = 0
  if nLevel < self.MIN_PLAYER_LEVEL then
    return nXiuLimit
  elseif nLevel > 100 then
    nIndex = 10
  else
    nIndex = math.floor(nLevel / 10)
  end
  nXiuLimit = self.tbXiuWeiLimit[nIndex] * 2
  return nXiuLimit
end

-- 更新剩余修炼累积时间
function tbItem:Update()
  local nLastTime = me.GetTask(self.TASKGROUP, self.TASKLASTTIME_ID)
  local nNowTime = GetTime()
  local nDays = self:CalculateDay(nLastTime, nNowTime)
  local nRemainTime = nDays * 1.5 + self:GetRemainTime()
  if nRemainTime < 0.1 then
    nRemainTime = 0
  end
  if nRemainTime > self.MAX_REMAINTIME then
    nRemainTime = self.MAX_REMAINTIME
  end

  if nLastTime <= 0 then
    nRemainTime = 1.5
  end

  me.SetTask(self.TASKGROUP, self.TASKLASTTIME_ID, nNowTime)
  me.SetTask(self.TASKGROUP, self.TASKREMAINTIME_ID, nRemainTime * 10) -- 存的是小时的十倍
end

-- 计算离上次更新时间过了多少天
function tbItem:CalculateDay(nLastTime, nNowTime)
  local nLastDay = Lib:GetLocalDay(nLastTime)
  local nNowDay = Lib:GetLocalDay(nNowTime)
  local nDays = nNowDay - nLastDay
  if nDays < 0 then
    nDays = 0
  end
  return nDays
end

function tbItem:GetTip(nState)
  local nLuckySkillLevel, nLuckyStateType, nLuckyEndTime, bLuckyIsNoClearOnDeath = me.GetSkillState(self.SKILL_ID_LUCKY)
  local szTip = ""

  local nLastTime = me.GetTask(self.TASKGROUP, self.TASKLASTTIME_ID)
  local nNowTime = GetTime()
  local nDays = self:CalculateDay(nLastTime, nNowTime)
  local nRemainTime = nDays * 1.5 + me.GetTask(self.TASKGROUP, self.TASKREMAINTIME_ID) / 10
  if nRemainTime < 0.1 then
    nRemainTime = 0
  end
  if nRemainTime > self.MAX_REMAINTIME then
    nRemainTime = self.MAX_REMAINTIME
  end

  local nMiniter = (nRemainTime % 1) * 60
  local szRemainMsg = string.format("你现在的累积修炼时间有：<color=green>%d<color><color=yellow>小时<color><color=green>%d<color><color=yellow>分钟<color>，\n", nRemainTime, nMiniter)

  if not nLuckyEndTime then
    nLuckyEndTime = 0
    szTip = szTip .. string.format(szRemainMsg .. "<color=0x8080ff>右键点击使用<color>。")
  else
    szTip = szTip .. string.format(szRemainMsg .. "<color=0x8080ff>已经在修炼状态中<color>。")
  end
  return szTip
end

function tbItem:GetXiuLianZhuInfo()
  local pPlayer = me
  self:Update()
  local nCount = pPlayer.GetItemCountInBags(18, 1, 16, 1)
  local nRemainTime = pPlayer.GetTask(self.TASKGROUP, self.TASKREMAINTIME_ID) / 10
  local nLuckySkillLevel, nLuckyStateType, nLuckyEndTime, bLuckyIsNoClearOnDeath = pPlayer.GetSkillState(self.SKILL_ID_LUCKY)
  if 0 >= nLuckySkillLevel then
    nLuckyEndTime = 0
  end
  return nCount, nRemainTime, nLuckyEndTime
end

function tbItem:AddRemainTime(nMin)
  local nHour = self:GetReTime() + string.format("%0.1f", nMin / 60)
  if nHour > self.MAX_REMAINTIME then
    nHour = self.MAX_REMAINTIME
  end
  me.SetTask(self.TASKGROUP, self.TASKREMAINTIME_ID, (nHour * 10))
end

function tbItem:AddExRemainTime(nMin)
  local nHour = me.GetTask(self.TASKGROUP, self.TASK_XIULIAN_ADDTIME) + (string.format("%0.1f", nMin / 60) * 10)
  me.SetTask(self.TASKGROUP, self.TASK_XIULIAN_ADDTIME, nHour)
end

-- 通用的增加修炼珠时间接口
-- by zhangjinpin@kingsoft
function tbItem:CheckAddableCommon(bAdd, ...)
  -- add private condition
  if arg[1] ~= nil then
    -- private callback
    local bOk = arg[1](unpack(arg, 2))

    if bOk ~= 1 then
      return 0
    end
  end

  -- check
  if (not bAdd) or (bAdd ~= 1) then
    -- get remain extra time
    local nExtraTime = me.GetTask(self.TASKGROUP, self.TASK_XIULIAN_ADDTIME)

    if nExtraTime <= 0 then
      return 0
    end

    return 1

  -- add
  elseif bAdd == 1 then
    -- get remain xiulian time
    local nRemainTime = self:GetRemainTime()

    -- get remain extra time
    local nExtraTime = me.GetTask(self.TASKGROUP, self.TASK_XIULIAN_ADDTIME) / 10

    -- full time
    if nRemainTime >= self.MAX_REMAINTIME then
      Dialog:Say(string.format("您的修炼时间已满，无法领取补充的修炼时间。\n\n您拥有的补充修炼时间：<color=yellow>%s小时<color>", nExtraTime))
      return 0
    end

    -- free time
    local nFreeTime = self.MAX_REMAINTIME - nRemainTime

    if nFreeTime > nExtraTime then
      nFreeTime = nExtraTime
    end

    -- add minute
    self:AddRemainTime(nFreeTime * 60)

    -- dec extra time
    nExtraTime = nExtraTime - nFreeTime

    -- save task
    me.SetTask(self.TASKGROUP, self.TASK_XIULIAN_ADDTIME, nExtraTime * 10)

    Dialog:Say("您的修炼时间增加了<color=yellow>" .. nFreeTime .. "<color>小时，您拥有的补充修炼时间：<color=yellow>" .. nExtraTime .. "<color>小时。")
  end
end

-- zhengyuhua:庆公测活动临时内容
function tbItem:CheckAddable(bAdd)
  local nBufLevel = me.GetSkillState(881)
  local nCurDate = tonumber(os.date("%Y%m%d", GetTime()))
  local nDate = me.GetTask(2038, 4)
  if nBufLevel > 0 and nDate ~= nCurDate then
    if bAdd == 1 then
      if self:GetRemainTime() == 14 then
        Dialog:Say("您的修炼时间已满，不能领取额外的修炼时间！")
        return 0
      end
      self:AddRemainTime(30)
      me.SetTask(2038, 4, nCurDate)
      Dialog:Say("您的修炼时间增加了<color=green>30分钟<color>")
    end
    return 1
  else
    if bAdd == 1 then
      Dialog:Say("您没有额外的修炼时间可以领取！")
    end
    return 0
  end
end

-- fenghewen:合服优惠
function tbItem:CheckAddableCoZone(bAdd)
  local nCurDate = tonumber(os.date("%Y%m%d", GetTime()))
  local nDate = me.GetTask(2065, 1)
  if GetTime() < KGblTask.SCGetDbTaskInt(DBTASK_COZONE_TIME) + 7 * 24 * 60 * 60 and nDate ~= nCurDate then
    if bAdd == 1 then
      if self:GetRemainTime() == 14 then
        Dialog:Say("您的修炼时间已满，不能领取额外的修炼时间！")
        return 0
      end
      self:AddRemainTime(120)
      me.SetTask(2065, 1, nCurDate)
      Dialog:Say("您的修炼时间增加了<color=green>2小时<color>")
    end
    return 1
  else
    if bAdd == 1 then
      Dialog:Say("您没有额外的修炼时间可以领取！")
    end
    return 0
  end
end

function tbItem:CheckAddableSubPlayer(bAdd)
  if me.nLevel < 50 then
    return 0
  end
  local nCoZoneTime = KGblTask.SCGetDbTaskInt(DBTASK_COZONE_TIME)

  if not bAdd then
    if GetTime() <= KGblTask.SCGetDbTaskInt(DBTASK_COZONE_TIME) + 10 * 24 * 60 * 60 then
      if nCoZoneTime > me.GetTask(self.TASK_GROUP_COZONE, self.TASK_GETEXTIME_FLAG) then
        local nExtraTime = self.DEF_COZONE_COMPOSE_MINDAY * 0.5 * 10 -- 主服玩家可以获得7天优惠
        -- 从服玩家可以获得7天或者大于7天优惠
        if me.IsSubPlayer() == 1 then
          nExtraTime = math.max(nExtraTime, math.floor(KGblTask.SCGetDbTaskInt(DBTASK_SERVER_STARTTIME_DISTANCE) / (24 * 3600)) * 0.5 * 10)
        end

        me.SetTask(self.TASK_GROUP_COZONE, self.TASK_GETEXTIME_FLAG, GetTime())

        if nExtraTime >= 0 then
          me.SetTask(self.TASK_GROUP_COZONE, self.TASK_SUBPLAYER_EXTIME, nExtraTime)
        end
      end
    end

    if me.GetTask(self.TASK_GROUP_COZONE, self.TASK_SUBPLAYER_EXTIME) > 0 then
      return 1
    else
      return 0
    end
  end
  if bAdd == 1 and me.GetTask(self.TASK_GROUP_COZONE, self.TASK_SUBPLAYER_EXTIME) >= 0 then
    local nExtraTime = me.GetTask(self.TASK_GROUP_COZONE, self.TASK_SUBPLAYER_EXTIME) / 10
    local nStillHaveTime = self:GetRemainTime()
    local nNeedTime = 14 - nStillHaveTime
    if nExtraTime == 0 then
      Dialog:Say("您的额外修炼时间已经用完，不能补充修炼时间了。")
      return 0
    end
    if nStillHaveTime == 14 then
      Dialog:Say("您的修炼时间已满，不需要补充。")
      return 0
    end
    if nExtraTime >= 0 and nExtraTime < nNeedTime then
      nNeedTime = nExtraTime
    end
    self:AddRemainTime(nNeedTime * 60)
    nExtraTime = nExtraTime - nNeedTime
    if nExtraTime < 0 then
      nExtraTime = 0
    end
    me.SetTask(self.TASK_GROUP_COZONE, self.TASK_SUBPLAYER_EXTIME, nExtraTime * 10)
    Dialog:Say("您已经补充修炼时间<color=yellow>" .. nNeedTime .. "<color>小时，还剩余额外修炼时间<color=yellow>" .. nExtraTime .. "<color>小时。")
    return 1
  else
    return 0
  end
end

function tbItem:CheckAddableSubPlayerForItem(bAdd)
  if me.nLevel < 100 then
    return 0
  end

  if GetTime() > KGblTask.SCGetDbTaskInt(DBTASK_COZONE_TIME) + 10 * 24 * 60 * 60 then
    return 0
  end

  local nCoZoneTime = KGblTask.SCGetDbTaskInt(DBTASK_COZONE_TIME)

  -- 如果不是从服玩家，或者已经领取过奖励的玩家，都过
  if nCoZoneTime <= me.GetTask(self.TASK_GROUP_COZONE, self.TASK_SUBPLAYER_ADDITEM) then
    return 0
  end

  if not bAdd then
    return 1
  end

  local nCoZoneDay = self.DEF_COZONE_COMPOSE_MINDAY
  if me.IsSubPlayer() == 1 then
    nCoZoneDay = math.max(self.DEF_COZONE_COMPOSE_MINDAY, math.floor(KGblTask.SCGetDbTaskInt(DBTASK_SERVER_STARTTIME_DISTANCE) / (24 * 3600)))
  end
  local nCaiDay = self.nCoZone_CaibaoTuBaseDay + math.floor(nCoZoneDay / self.nCoZone_CaibaoTuDet)
  local nQianKunCount = self.nCoZone_QiankundaiBaseNum + math.floor(nCoZoneDay / self.nCoZone_QiankundaiDet)

  if me.CountFreeBagCell() < nQianKunCount + 1 then
    Dialog:Say(string.format("您的背包空间不足%s格，请清理后再来领取！", nQianKunCount + 1))
    return 0
  end

  me.SetTask(self.TASK_GROUP_COZONE, self.TASK_SUBPLAYER_ADDITEM, nCoZoneTime)

  local pItem = me.AddItem(unpack(self.tbCoZoneAward_CaibaoPat))
  if pItem then
    pItem.SetTimeOut(0, GetTime() + nCaiDay * 3600 * 24)
    pItem.Bind(1)
    pItem.Sync()
  end

  for i = 1, nQianKunCount do
    local pItem = me.AddItem(unpack(self.tbCoZoneAward_Qiankundai))
    if pItem then
      pItem.SetTimeOut(0, GetTime() + 30 * 3600 * 24)
      pItem.Bind(1)
      pItem.Sync()
    end
  end

  return 1
end

-- 老玩家召回活动
function tbItem:CheckOldPCallBack(bAdd)
  if (not bAdd) or (bAdd ~= 1) then
    if EventManager.ExEvent.tbPlayerCallBack:IsOpen(me, 3) == 1 and me.GetTask(self.TASKGROUP, self.TASKCANGETEXTIME_ID) == 0 then
      local nCanAddTime = me.GetTask(self.TASKGROUP, self.TASKOLDPRTIME_ID)
      if 0 == nCanAddTime and (0 == me.GetTask(self.TASKGROUP, self.TASKCANGETEXTIME_ID)) then
        local nLeaveDay = EventManager.ExEvent.tbPlayerCallBack:GetLeaveDay(me)
        nCanAddTime = nLeaveDay * 0.5 * 10
        me.SetTask(self.TASKGROUP, self.TASKOLDPRTIME_ID, nCanAddTime)
        me.SetTask(self.TASKGROUP, self.TASKCANGETEXTIME_ID, 1)
      end
      return 1
    end

    if me.GetTask(self.TASKGROUP, self.TASKCANGETEXTIME_ID) == 1 and me.GetTask(self.TASKGROUP, self.TASKOLDPRTIME_ID) > 0 then
      return 1
    end

    return 0
  elseif bAdd == 1 then
    local nRemainTime = self:GetReTime()
    local nCanAddTime = me.GetTask(self.TASKGROUP, self.TASKOLDPRTIME_ID) / 10
    if nRemainTime >= self.MAX_REMAINTIME then
      Dialog:Say(string.format("您的修炼时间是满的，不需要添加。\n\n<color=yellow>剩余额外修炼时间：%s小时<color>", nCanAddTime))
      return 0
    end

    local nNeedTime = (self.MAX_REMAINTIME - nRemainTime)
    if nNeedTime > nCanAddTime then
      nNeedTime = nCanAddTime
    end
    self:AddRemainTime(nNeedTime * 60)
    nCanAddTime = nCanAddTime - nNeedTime
    me.SetTask(self.TASKGROUP, self.TASKOLDPRTIME_ID, nCanAddTime * 10)
    Dialog:Say("您的修炼时间增加了<color=yellow>" .. nNeedTime .. "<color>小时，你还能领取的修炼时间是：<color=yellow>" .. nCanAddTime .. "<color>小时。")
  end
end

--充值累计达到48元，可每天可额外领取30分钟修炼时间。
function tbItem:CheckAddablePreMonth(bAdd)
  local nCurDate = tonumber(GetLocalDate("%y%m%d"))
  local szMsg = string.format(
    [[%s累计%s达到<color=red>%s<color>，可获得如下额外优惠：
	  <color=yellow>
	每天1次额外的祈福机会<color>
	  （自动获得）	
	<color=yellow>
	每天额外领取30分钟4倍<color>
	  （修炼珠领取）
	  <color=yellow>
	1个无限传送符（1个月）<color>
	  （在充值特权可以快速获得）<color=yellow>
	1个乾坤符（10次）<color>
	  （在充值特权可以快速获得）	
	  （达到60级，%s达%s，每周可在礼官处领取10点江湖威望。%s达%s，每周可在礼官处领取30点江湖威望）
	]],
    IVER_g_szPayMonth,
    IVER_g_szPayName,
    IVER_g_szPayLevel2,
    IVER_g_szPayName,
    IVER_g_szPayLevel1,
    IVER_g_szPayName,
    IVER_g_szPayLevel2
  )
  if me.GetTask(2038, 6) < nCurDate then
    if bAdd == 1 then
      if me.GetExtMonthPay() < IVER_g_nPayLevel2 then
        Dialog:Say(string.format("当前角色本月%s不足%s，", IVER_g_szPayName, IVER_g_szPayLevel2) .. szMsg)
        return 0
      end
      if self:GetRemainTime() == 14 then
        Dialog:Say("您的修炼时间已满，不能领取额外的修炼时间！")
        return 0
      end
      self:AddRemainTime(30)
      me.SetTask(2038, 6, nCurDate)
      Dialog:Say("您的修炼时间增加了<color=green>30分钟<color>\n\n" .. szMsg)
      me.Msg("您的修炼时间增加了<color=green>30分钟<color>")
    end
    return 1
  else
    if bAdd == 1 then
      Dialog:Say("您已领取了今天的额外修炼时间\n\n" .. szMsg)
    end
    return 0
  end
end
function tbItem:Init()
  if MODULE_GAMESERVER then
    PlayerEvent:RegisterGlobal("On4TimeExpExhausted", self.ExpExhausted, self)
    PlayerEvent:RegisterGlobal("OnLevelUp", self.OnLevelUp, self)
    PlayerEvent:RegisterGlobal("OnXiuWeiExhausted", self.XiuWeiExhausted, self)
  end
end

function tbItem:WriteLog(...)
  if MODULE_GAMESERVER then
    Dbg:WriteLogEx(Dbg.LOG_INFO, "Item", "XiuLianZhu", unpack(arg))
  end
end

tbItem:Init()
