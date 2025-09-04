------------------------------------------------------
-- 文件名　：homeland_challenge.lua
-- 创建者　：dengyong
-- 创建时间：2012-10-10 09:26:57
-- 描  述  ：家族挑战令相关逻辑
------------------------------------------------------

if not MODULE_GAMESERVER then
  return 0
end

Require("\\script\\kin\\homeland\\homeland_def.lua")

-- 挑战令boss死亡处理
function HomeLand:OnChallengeBossDeath(pKiller)
  local pPlayer = pKiller.GetPlayer()
  if not pPlayer then
    return
  end

  local tbChallenge = self:GetMyChallenge(pPlayer.dwKinId)
  if not tbChallenge or tbChallenge.dwBossId ~= him.dwId then
    return
  end

  self:AddAwardBoxNpc(pPlayer.dwKinId, him.szName) -- 添加箱子
  -- 关闭boss超时timer
  if tbChallenge.nBossTimer then
    Timer:Close(tbChallenge.nBossTimer)
    tbChallenge.nBossTimer = nil
    tbChallenge.dwBossId = nil
    --tbChallenge.nBossTime = nil;
  end

  self:ClearXiaoBingNpc(pPlayer.dwKinId) -- 清空小兵
  local pKin = KKin.GetKin(pPlayer.dwKinId)
  if not pKin then
    StatLog:WriteStatLog("stat_info", "family_boss", "boss_kill", 0, pKin.GetName())
  end
end

-- boss血量回调
function HomeLand:OnBossLifeReduced(nKinId, nPercent)
  local tbChallenge = self:GetMyChallenge(nKinId)
  if not tbChallenge or self:GetMapIdByKinId(nKinId) ~= him.nMapId then
    return 0
  end

  -- 金钟罩，1分钟
  him.AddSkillState(self.CHALLENG_BOSS_BUFF_SKILL, self.CHALLENG_BOSS_BUFF_LEVEL, 0, self.CHALLENG_BOSS_BUFF_TIME, 0, 0, 1, 1, 1)

  local nTimerId = Timer:Register(self.CHALLENGE_XIAOBING_INTERVAL, self.CallXiaoBing, self, him.nMapId, nKinId, nPercent)
  -- 记录timer信息
  tbChallenge.tbXiaoBingTimer = tbChallenge.tbXiaoBingTimer or {}
  local tb = {}
  tb.nTimer = nTimerId
  tb.nCallTimes = 0
  tbChallenge.tbXiaoBingTimer[nPercent] = tb

  self:SendBlackBoardMsgForMapPlayer(nKinId, "在兵俑的攻击下坚持一段时间！")
end

function HomeLand:CallXiaoBing(nMapId, nKinId, nPercent)
  local tbChallenge = self:GetMyChallenge(nKinId)
  if not tbChallenge or self:GetMapIdByKinId(nKinId) ~= nMapId then
    return 0
  end

  local nChallengeLevel = self:GetChallengeLevel()
  local nNpcLevel = self.CHALLENG_XIAOBING_LEVEL[nChallengeLevel]

  for i = 1, self.CHALLENGE_XIAOBING_COUNT_PERTIME do
    local tbPos = self.CHALLENGE_XIAOBING_POS[MathRandom(1, #self.CHALLENGE_XIAOBING_POS)]
    KNpc.Add2(self.CHALLENGE_XIAOBING_TEMPLATE, nNpcLevel, -1, nMapId, unpack(tbPos))
  end

  local tb = tbChallenge.tbXiaoBingTimer[nPercent]
  tb.nCallTimes = tb.nCallTimes + 1

  if tb.nCallTimes >= self.CHALLENG_XIAOBING_TIMES then
    tbChallenge.tbXiaoBingTimer[nPercent] = nil
    return 0
  end

  return self.CHALLENGE_XIAOBING_INTERVAL
end

-- 添加箱子奖励NPC
function HomeLand:AddAwardBoxNpc(nKinId, szBossName)
  local tbChallenge = self:GetMyChallenge(nKinId)
  if not tbChallenge or tbChallenge.dwBossId ~= him.dwId then
    return
  end

  local pBox = KNpc.Add2(self.CHALLENGE_AWARD_BOX_TEMPLATE, 100, -1, him.nMapId, unpack(self.CHALLENGE_POS))
  if not pBox then
    Dbg:WriteLog("HomeLandChallenge", nKinId, "Add Award Box Npc Failed!")
  end

  tbChallenge.dwBoxNpcId = pBox.dwId
  local nTimerId = Timer:Register(self.CHALLENGE_BOX_TIME_OUT, self.OnAwardBoxTimeOut, self, nKinId)
  tbChallenge.nBoxTimer = nTimerId
  --tbChallenge.nBoxTime = GetTime();
  tbChallenge.nStep = 3
  tbChallenge.nBeginTime = GetTime()

  self:AddGuoHuo(nKinId)
  -- 家族公告，通过GC广播
  KKin.Msg2Kin(nKinId, "家族挑战成功！请家族成员迅速前往家族领地演武场处，点击宝箱领取挑战奖励！宝箱将在3分钟后消失。", 0)
  self:SendBlackBoardMsgForMapPlayer(nKinId, "挑战成功！点击宝箱领取挑战奖励，宝箱将在3分钟后消失。")
  if tbChallenge.nBossType == 1 then
    local pKin = KKin.GetKin(nKinId)
    local szMsg = string.format("<color=green>%s<color>家族在家族挑战活动中挑战<color=red>%s<color>成功，并获得了丰厚奖励。恭喜%s家族！", pKin.GetName(), szBossName, pKin.GetName())
    KDialog.NewsMsg(1, Env.NEWSMSG_NORMAL, szMsg)
    KDialog.MsgToGlobal(szMsg)
  end
end

-- 奖励箱子开启回调, 给予奖励
function HomeLand:OpenAwardBox()
  local tbChallenge = self:GetMyChallenge(me.dwKinId)
  if not tbChallenge then
    return
  end

  -- 每个人只能领一次奖
  local tbRecord = him.GetTempTable("HomeLand").tbRecord
  if tbRecord and tbRecord[me.nId] then
    Dialog:Say("你已经领取过本次挑战的奖励了！")
    return
  end

  -- 每个人每天只能领取4次
  local nLocalDay = Lib:GetLocalDay(GetTime())
  local nDays = me.GetTask(self.CHALLENGE_AWARD_TASK_GROUP, self.CHALLENGE_AWARD_SUB_DAYS)
  local nTimes = me.GetTask(self.CHALLENGE_AWARD_TASK_GROUP, self.CHALLENGE_AWARD_SUB_TIMES)
  if nDays ~= nLocalDay then
    me.SetTask(self.CHALLENGE_AWARD_TASK_GROUP, self.CHALLENGE_AWARD_SUB_DAYS, nLocalDay)
    me.SetTask(self.CHALLENGE_AWARD_TASK_GROUP, self.CHALLENGE_AWARD_SUB_TIMES, 0)
  elseif nTimes >= self.CHALLENGE_AWARD_MAX_COUNT_DAILY then
    Dialog:Say(string.format("你今天已经领取了%d次奖励，不能再领奖了。", self.CHALLENGE_AWARD_MAX_COUNT_DAILY))
    return
  end

  -- 检查背包
  local nBossType = tbChallenge.nBossType or 0
  local nAwardItemCount = self.AWARD_ITEM_COUNT[nBossType + 1] or 0
  if me.CountFreeBagCell() < nAwardItemCount then
    Dialog:Say("背包空间不足，请至少空出" .. nAwardItemCount .. "个背包空间！")
    return
  end

  -- 物品奖励
  local nChallengeLevel = self:GetChallengeLevel()
  local tbItemId = self.AWARD_ITEM_ID[nChallengeLevel]
  if not tbItemId then
    Dbg:WriteLog("HomeLandChallenge", me.szName, string.format("CanNot Find AwardItem Count:%d ChallengeLevel:%d", nAwardItemCount, nChallengeLevel))
  else
    me.AddStackItem(tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4], { bFroceBind = 1 }, nAwardItemCount)
  end

  -- 基准经验奖励
  local nExp = self.AWARD_BASE_EXP_TIME * me.GetBaseAwardExp()
  me.AddExp(nExp)

  -- 与周围玩家的亲密度奖励
  local tbPlayers, nCount = KNpc.GetAroundPlayerList(him.dwId, self.AWARD_SEARCH_RANGE)
  if tbPlayers and nCount ~= 0 then
    for _, player in pairs(tbPlayers) do
      if player.nId ~= me.nId and KPlayer.CheckRelation(player.szName, me.szName, Player.emKPLAYERRELATION_TYPE_BIDFRIEND) == 1 then
        me.AddFriendFavor(player.szName, self.AWARD_FRIENDSHIP)
      end
    end
  end

  -- 记录该玩家已经领奖
  local tbTempTable = him.GetTempTable("HomeLand")
  local tbRecord = tbTempTable.tbRecord or {}
  tbRecord[me.nId] = 1
  tbTempTable.tbRecord = tbRecord

  local nTimes = me.GetTask(self.CHALLENGE_AWARD_TASK_GROUP, self.CHALLENGE_AWARD_SUB_TIMES)
  me.SetTask(self.CHALLENGE_AWARD_TASK_GROUP, self.CHALLENGE_AWARD_SUB_TIMES, nTimes + 1)
end

-- 与萧汜对话，申请开启挑战
function HomeLand:ApplyChallenge(bSure)
  local nKinId, nMember = me.GetKinMember()
  if not nKinId then
    return
  end

  local pKin = KKin.GetKin(nKinId)
  if not pKin then
    return
  end

  -- 如果不是族长。。。
  if Kin:CheckSelfRight(nKinId, nMember, 1) ~= 1 then
    Dialog:Say("家族挑战活动只能由家族族长开启。")
    return
  end

  -- 当前挑战还在进行中
  local tbChallenge = self:GetMyChallenge(nKinId)
  if tbChallenge then
    Dialog:Say("当前家族挑战活动正在进行中！请等本次挑战结束后再行尝试。")
    return
  end

  -- 如果次数不足。。。
  local nUsed, nAll = self:GetTodayChallengeTimes(nKinId)
  if not nUsed or not nAll or nUsed >= nAll then
    Dialog:Say("本日家族挑战次数已用尽，请等明日再行挑战。")
    return
  end

  bSure = bSure or 0
  if bSure == 0 then
    local szMsg = "确认现在开启家族挑战活动吗？活动将在家族领地的“演武场”开启。<color=red>（活动开启后，如果30分钟内没有完成挑战，则视为挑战失败。）<color>"
    local tbOpt = {
      { "开启家族挑战", HomeLand.ApplyChallenge, HomeLand, 1 },
      { "我知道了" },
    }
    Dialog:Say(szMsg, tbOpt)
  else
    -- 如果是当天最后一次, 有若干机率随机出精英BOSS
    local nBossType = 0 -- 普通boss, 1表示精英boss
    if nUsed == nAll - 1 then
      local nRand = MathRandom(1, 100)
      nBossType = nRand <= self.SENIOR_BOSS_RAND_RATE and 1 or 0
    end
    self:AssignChallenge_GS1(nKinId, nBossType)
  end
end

-- 获取家族当前挑战对象，没有返回nil
function HomeLand:GetMyChallenge(nKinId)
  if not self.tbAllKinChallenge then
    return
  end

  return self.tbAllKinChallenge[nKinId]
end

-- 分配一个挑战对象，每个家族同一时刻只能有一个挑战对象
function HomeLand:AssignChallenge_GS1(nKinId, nBossType)
  local tbChallenge = self:GetMyChallenge(nKinId)
  if tbChallenge then
    return
  end

  -- 申请扣除次数
  GCExcute({ "HomeLand:ApplyCostChallengeTimes", nKinId, { nBossType } })
end

function HomeLand:SetChallengeTimesResult(nDataVer, nKinId, nTimes, nReason, tbParam)
  local pKin = KKin.GetKin(nKinId)
  if not pKin then
    return
  end

  pKin.SetChallengeTimes(nTimes)
  pKin.SetKinDataVer(nDataVer)

  -- 广播客户端修改挑战次数
  KKinGs.KinClientExcute(nKinId, { "Kin:ChangeChallengeTimes_C", nDataVer, nTimes })

  if nReason == 1 then
    self:AssignChallenge_GS2(nKinId, unpack(tbParam))
  end
end

function HomeLand:AssignChallenge_GS2(nKinId, nBossType)
  local tbChallenge = self:GetMyChallenge(nKinId)
  if tbChallenge then
    return
  end

  -- 召唤等待NPC
  local nMapId = self:GetMapIdByKinId(nKinId)
  local pWait = KNpc.Add2(self.CHALLENGE_WAIT_NPC_TEMPLATE, 1, -1, nMapId, unpack(self.CHALLENGE_POS))
  if not pWait then
    return
  end

  local nTimerId = Timer:Register(self.CHALLENGE_WAIT_TIME_OUT, self.OnWaitNpcTimeOut, self, nKinId)
  local tbChallenge = {}
  tbChallenge.nBossType = nBossType
  tbChallenge.dwWaitNpcId = pWait.dwId
  tbChallenge.nBeginTime = GetTime()
  tbChallenge.nStep = 1

  self.tbAllKinChallenge = self.tbAllKinChallenge or {}
  self.tbAllKinChallenge[nKinId] = tbChallenge

  Timer:Register(5 * 18, self.OnChallenge_Timer, self, nKinId)

  -- 家族公告，通过GC广播
  KKin.Msg2Kin(nKinId, "家族挑战活动已经开启，请前往家族领地演武场参加家族挑战活动！", 0)
  self:SendBlackBoardMsgForMapPlayer(nKinId, "家族挑战令活动已经开始！")

  local pKin = KKin.GetKin(nKinId)
  if not pKin then
    StatLog:WriteStatLog("stat_info", "family_boss", "boss_open", 0, pKin.GetName())
  end
end

function HomeLand:OnWaitNpcTimeOut(nKinId)
  local tbChallenge = self:GetMyChallenge(nKinId)
  if not tbChallenge then
    return 0
  end

  local pWait = KNpc.GetById(tbChallenge.dwWaitNpcId)
  if pWait then
    pWait.Delete()
  end
  tbChallenge.dwWaitNpcId = nil

  local nBossType = tbChallenge.nBossType
  local nMapId = self:GetMapIdByKinId(nKinId)
  local nChallengeLevel = self:GetChallengeLevel()
  local nTemplateId = self.CHALLENGE_BOSS_TEMPLATE[nChallengeLevel][nBossType + 1]
  local nNpcLevel = self.CHALLENG_BOSS_LEVEL[nChallengeLevel][nBossType + 1]
  if not nTemplateId or not nNpcLevel then
    self.tbAllKinChallenge[nKinId] = nil
    return 0
  end
  --节日boss
  local nNowDate = tonumber(GetLocalDate("%Y%m%d"))
  local bDayBoss = 0
  if nNowDate >= self.CHALLENGE_BOSS_DATE_XMAS[1] and nNowDate <= self.CHALLENGE_BOSS_DATE_XMAS[2] then
    local nOpenDay = TimeFrame:GetServerOpenDay()
    if nOpenDay > self.CHALLENGE_BOSS_OPENDAY then
      nTemplateId = self.CHALLENGE_BOSS_TEMPLATE_XMAS[2]
    else
      nTemplateId = self.CHALLENGE_BOSS_TEMPLATE_XMAS[1]
    end
    bDayBoss = 1
  end
  --节日boss end
  local pBoss = KNpc.Add2(nTemplateId, nNpcLevel, -1, nMapId, self.CHALLENGE_POS[1], self.CHALLENGE_POS[2])
  if not pBoss then
    self.tbAllKinChallenge[nKinId] = nil
    return 0
  end

  if bDayBoss == 0 then
    -- boss注册血量回调
    Npc:RegPNpcLifePercentReduce(pBoss, 70, self.OnBossLifeReduced, self, nKinId)
    Npc:RegPNpcLifePercentReduce(pBoss, 30, self.OnBossLifeReduced, self, nKinId)
  end

  local nTimerId = Timer:Register(self.CHALLENGE_BOSS_TIME_OUT, self.OnChallengeTimeOut, self, nKinId)
  tbChallenge.nBossTimer = nTimerId
  tbChallenge.dwBossId = pBoss.dwId
  --tbChallenge.nBossTime = GetTime();
  tbChallenge.nStep = 2
  tbChallenge.nBeginTime = GetTime()

  -- 家族公告，通过GC广播
  KKin.Msg2Kin(nKinId, "家族挑战BOSS在家族领地内刷出了，请所有家族成员在30分钟内前往击败之！", 0)
  if nBossType == 1 then
    self:SendBlackBoardMsgForMapPlayer(nKinId, "来自沉默英雄的特别考验，挑战成功可以获得更多奖励！")
  end

  return 0
end

-- boss挑战超时回调
function HomeLand:OnChallengeTimeOut(nKinId)
  local tbChallenge = self:GetMyChallenge(nKinId)
  if not tbChallenge then
    return 0
  end

  -- 删除挑战BOSS
  local pNpc = KNpc.GetById(tbChallenge.dwBossId)
  if pNpc then
    pNpc.Delete()
  end

  self:ClearXiaoBingNpc(nKinId)
  self.tbAllKinChallenge[nKinId] = nil -- 直接置空
  return 0
end

-- 奖励箱子超时回调
function HomeLand:OnAwardBoxTimeOut(nKinId)
  local tbChallenge = self:GetMyChallenge(nKinId)
  if not tbChallenge then
    return 0
  end

  local pBox = KNpc.GetById(tbChallenge.dwBoxNpcId)
  if pBox then
    pBox.Delete()
    KKin.Msg2Kin(nKinId, "本次家族挑战活动结束，如仍有剩余挑战次数。则家族族长可以于萧汜处开启下一场挑战。", 0)
    self:SendBlackBoardMsgForMapPlayer(nKinId, "家族挑战活动结束！期待各位下一次有更好的表现！")
  end

  self:ClearXiaoBingNpc(nKinId)
  self.tbAllKinChallenge[nKinId] = nil -- 直接置空
  return 0
end

-- 设置家族挑战次数，只要申请成功就删除次数
function HomeLand:SetTodayChallengeTimes(nKinId, nUsed, nAll)
  local pKin = KKin.GetKin(nKinId)
  if not pKin then
    return
  end

  local nTimes = nAll
  Lib:SetBits(nTimes, nUsed, 16, 31)
  pKin.SetChallengeTimes(nTimes)
end

-- 清除小兵
function HomeLand:ClearXiaoBingNpc(nKinId)
  -- 删除地图上还没死的小兵
  ClearMapNpcWithTemplateId(self:GetMapIdByKinId(nKinId), self.CHALLENGE_XIAOBING_TEMPLATE)

  local tbChallenge = self:GetMyChallenge(nKinId)
  if not tbChallenge then
    return
  end

  local tbXiaoBingTimer = tbChallenge.tbXiaoBingTimer or {}
  for _, tb in pairs(tbXiaoBingTimer) do
    if tb.nTimer then
      Timer:Close(tb.nTimer)
      tb.nTimer = nil
    end
  end
  tbXiaoBingTimer = nil
end

function HomeLand:AddGuoHuo(nKinId)
  local nMapId = self:GetMapIdByKinId(nKinId)
  if not nMapId or nMapId == 0 then
    return
  end

  local tbNpc = Npc:GetClass("gouhuonpc")
  for _, tbPos in pairs(self.CHALLENGE_GUOHUO_POS) do
    local pNpc = KNpc.Add2(tbNpc.nNpcId, 1, -1, nMapId, unpack(tbPos)) -- 获得篝火Npc
    tbNpc:InitGouHuo(pNpc.dwId, 2, self.CHALLENGE_GUOHUO_TIME, 5, 45, 300, 0) -- 时间单位是秒
    tbNpc:SetKinId(pNpc.dwId, nKinId)
    tbNpc:StartNpcTimer(pNpc.dwId)
  end
end

function HomeLand:OnChallengeDeath()
  me.ReviveImmediately(0)
end

function HomeLand:GetChallengeTipMsg(nKinId)
  local tbChallenge = self:GetMyChallenge(nKinId)
  if not tbChallenge then
    return
  end

  if tbChallenge.dwBossId then
    return "请在30分钟内干掉boss"
  elseif tbChallenge.dwBoxNpcId then
    return "请在3分钟内领取奖励"
  end
end

-- 给领地内所有玩家弹黑条提示信息
function HomeLand:SendBlackBoardMsgForMapPlayer(nKinId, szMsg)
  local nMapId = self:GetMapIdByKinId(nKinId)
  if not nMapId or nMapId == 0 then
    return
  end

  local tbPlayer, nCount = KPlayer.GetMapPlayer(nMapId)
  if not tbPlayer or nCount == 0 then
    return
  end

  for _, pPlayer in pairs(tbPlayer) do
    Dialog:SendBlackBoardMsg(pPlayer, szMsg)
  end
end

function HomeLand:UpdateUiMsg(nKinId, szMsg, nLeftFrame)
  local nMapId = self:GetMapIdByKinId(nKinId)
  if not nMapId or nMapId == 0 then
    return
  end

  local tbPlayer, nCount = KPlayer.GetMapPlayer(nMapId)
  if not tbPlayer or nCount == 0 then
    return
  end

  for _, pPlayer in pairs(tbPlayer) do
    if szMsg then
      Dialog:SendBattleMsg(pPlayer, szMsg)
      Dialog:ShowBattleMsg(pPlayer, 1, 0)
      Dialog:SetBattleTimer(pPlayer, "<color=green>剩余时间：<color=white>%s\n", nLeftFrame)
    else
      Dialog:ShowBattleMsg(pPlayer, 0, 0)
    end
  end
end

-- 挑战对应的timer，用来维护挑战对象状态
function HomeLand:OnChallenge_Timer(nKinId)
  local tbChallenge = self:GetMyChallenge(nKinId)
  if not tbChallenge then
    self:UpdateUiMsg(nKinId)
    return 0
  end

  local nPassTime = GetTime() - tbChallenge.nBeginTime
  local nPassFrame = nPassTime * 18
  local szTip = ""
  local nLeftTime = 0
  if tbChallenge.nStep == 1 then
    nLeftTime = self.CHALLENGE_WAIT_TIME_OUT - nPassFrame
    szTip = "<color=green>即将刷出BOSS<color>"
  elseif tbChallenge.nStep == 2 then
    nLeftTime = self.CHALLENGE_BOSS_TIME_OUT - nPassFrame
    szTip = "<color=green>击败BOSS<color>"

    local pBoss = KNpc.GetById(tbChallenge.dwBossId or 0)
    if pBoss then
      szTip = string.format("<color=green>击败%s<color>", pBoss.szName)
    end
  elseif tbChallenge.nStep == 3 then
    nLeftTime = self.CHALLENGE_BOX_TIME_OUT - nPassFrame
    szTip = "<color=green>点击宝箱领取奖励<color>"
  else
    szTip = nil
  end

  self:UpdateUiMsg(nKinId, szTip, nLeftTime)

  if not szTip then
    return 0
  end
end
