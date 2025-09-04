-- 募兵校尉报名脚本程序
-- zhouchenfei  create  2007-09-17

local tbNpc = Npc:GetClass("mubingxiaowei")

function tbNpc:Init()
  if self.tbMapNpc then -- 支持重载
    return
  end

  local tbMapNpc = {} -- 通过地图Id寻找募兵校尉
  for nLevel, tbMId in pairs(Battle.MAPID_LEVEL_CAMP) do
    for nBattleSeq, tbMapId in pairs(tbMId) do
      for nCampId, nMapId in pairs(tbMapId) do
        tbMapNpc[nMapId] = Lib:NewClass(Battle.tbNpcBase, nMapId, nLevel, nCampId, nBattleSeq)
      end
    end
  end

  self.tbMapNpc = tbMapNpc
end

-- 和募兵校尉对话
function tbNpc:OnDialog()
  local tbNpc = self.tbMapNpc[him.nMapId]

  tbNpc:OnDialog()
end

-- 针对一个募兵校尉的基类
local tbNpcBase = Battle.tbNpcBase or {} -- 支持重载

tbNpcBase.tbBattleSeq = { "一", "二", "三" }

function tbNpcBase:init(nMapId, nLevel, nCampId, nBattleSeq)
  self.nMapId = nMapId
  self.nLevel = nLevel
  self.nCampId = nCampId
  self.nBattleSeq = nBattleSeq
  self.tbDialog = Battle.tbCampDialog[self.nCampId]
end

-- 刷新，使得链接到相应阵营
function tbNpcBase:Refresh()
  local tbMission = Battle:GetMission(self.nLevel, self.nBattleSeq)
  if tbMission then
    self.tbMission = tbMission
    self.tbCamp = tbMission.tbCamps[self.nCampId]
  else
    self.tbMission = nil
    self.tbCamp = nil
  end
end

function tbNpcBase:OnDialog()
  self:Refresh()

  if me.IsFreshPlayer() == 1 then
    Dialog:Say("你目前尚未加入门派，武艺不精，还是等加入门派后再来把！")
    return
  end
  local n, szMsg = NewBattle:PlayerCanGetAward(me.nId)
  if n == 1 then
    NewBattle:PlayerGetAward(me.nId)
    Dialog:Say("我已经将你上一次参加冰火天堑未领取的奖励:\n" .. szMsg .. "\n发放给你了。")
    return
  end
  if n == 2 then
    NewBattle:PlayerGetAward(me.nId)
    Dialog:Say("对不起，你在上一次参加冰火天堑时表现太过平凡，故没有奖励可领！")
    return
  end
  if NewBattle:OnlyBattleOpen() > 0 then
    NewBattle:GetBattleDialog(self.nCampId)
    return
  end
  if not GLOBAL_AGENT then
    if 0 == self:AwardGood() then
      --			return;
      --		end
      --	if (2 == self:ProcessBattleBouns()) then
      --	Dialog:Say("本周周积分将会刷新，您还有积分没兑换掉，去<color=yellow>报名点军需官<color>那儿兑换完积分再来吧！");
      return
    end
  end

  Battle:DbgOut("tbNpcBase:OnDialog", self, self.nMapId, self.tbMission)
  if not self.tbMission then
    Dialog:Say("开赴战场的大军尚未出发，请继续勤加操练，等候我们的通知。")
    return
  end

  if 0 == self:CheckMaxNum() then
    Dialog:Say(self.tbDialog[1])
    return
  end
  local pPlayer = me
  local nCheckResult = self:CheckPlayer()
  if 1 == nCheckResult then
    local nPLLevel = Battle.LEVEL_LIMIT[self.nLevel]
    Dialog:Say(string.format(self.tbDialog[2], nPLLevel), {
      { string.format("我要加入<color=red>%s<color>军", Battle.NAME_CAMP[self.nCampId]), self.OnSingleJoin, self, pPlayer },
      { "我再考虑一下" },
    })
  elseif 2 == nCheckResult then
    Dialog:Say("你现在要进入战场么？战斗中，你可以与其他人组成小队，一同杀敌，势必会事半功倍。", {
      { "我要进入战场", self.OnSingleJoin, self, pPlayer },
      { "等会再说" },
    })
  end
end

-- 奖励上一场宋金战场的积分对应的奖励，返回1表示继续，返回0表示不用继续了
function tbNpcBase:AwardGood()
  -- 判断是否能给予奖励
  local pPlayer = me
  if self.tbMission then
    local nCampId = pPlayer.GetTask(Battle.TSKGID, Battle.TASKID_BTCAMP)
    local nMyBTKey = pPlayer.GetTask(Battle.TSKGID, Battle.TSK_BTPLAYER_KEY)
    local nBTKey = self.tbMission.nBattleKey
    local nDiaFlag = 0

    local nBattleSeqA = math.fmod(nMyBTKey, 10)
    local nBattleSeqB = math.fmod(nBTKey, 10)
    local nBattleTimeA = nMyBTKey - nBattleSeqA
    local nBattleTimeB = nBTKey - nBattleSeqB

    -- id不一样表示可能是同一时间段不同场次，可能是不同一时间段
    if nMyBTKey ~= nBTKey then
      -- 如果是同一时间段的表示这个玩家可能从另一个场次出来到其他场次
      if nBattleTimeA == nBattleTimeB then
        nDiaFlag = 1
      end
    else -- 相同id
      -- 如果战局开始了就不能领了，直接继续下面对话
      if self.tbMission.nState == 2 then
        return 1
      end
      -- 同一场次却不是同一阵营
      if 0 ~= nCampId and self.nCampId ~= nCampId then
        nDiaFlag = 2
      end
    end

    if nDiaFlag == 1 then
      Dialog:Say(string.format(self.tbDialog[8], Battle.NAME_GAMELEVEL[self.nLevel], self.tbBattleSeq[nBattleSeqA], Battle.NAME_CAMP[nCampId]))
      return 0
    elseif nDiaFlag == 2 then
      Dialog:Say(self.tbDialog[5])
      return 0
    end
  end

  local nAwardPai = pPlayer.GetTask(Battle.TSKGID, Battle.TSK_BTPLAYER_ZHANCHANGLINGPAI)
  local nAwardFu = pPlayer.GetTask(Battle.TSKGID, Battle.TSK_BTPLAYER_FUDAI)
  local nBouns = pPlayer.GetTask(Battle.TSKGID, Battle.TSK_BTPLAYER_TOTALBOUNS)

  local nAwardRank, nMoney, tbXuanjing, nExpTime = nil, 0, {}, 0
  if EventManager.IVER_bOpenTiFu == 1 then
    nAwardRank = pPlayer.GetTask(Battle.TSKGID, Battle.TSK_BTPLAYER_AWARDRANK)
    nMoney, tbXuanjing, nExpTime = 0, {}, 0
    if nAwardRank ~= 0 then
      if Battle.tbTiFuAwardList[nAwardRank] then
        nMoney = Battle.tbTiFuAwardList[nAwardRank]["money"]
        tbXuanjing = Battle.tbTiFuAwardList[nAwardRank]["xuanjing"]
        nExpTime = Battle.tbTiFuAwardList[nAwardRank]["zhenyuanexp"]
      end
    end
  end

  if nAwardPai + nAwardFu + nBouns > 0 then
    local nPaiCount = 0
    local nFuCount = 0
    local szMsg = string.format("你上一次的战场积分为%d分", nBouns)
    local nFinalBouns = 0

    if nBouns > 0 then
      nFinalBouns = nBouns
      local nMyUse = pPlayer.GetTask(Battle.TSKGID, Battle.TSK_BTPLAYER_USEBOUNS)
      if nMyUse + nBouns > Battle.BATTLES_POINT2EXP_MAXEXP then
        nFinalBouns = Battle.BATTLES_POINT2EXP_MAXEXP - nMyUse
      end
    end
    if nFinalBouns > 0 then
      szMsg = szMsg .. string.format("，可以领取%d分的经验奖励", nFinalBouns)
    elseif nFinalBouns == 0 and nBouns > 0 then
      szMsg = szMsg .. string.format("，您的本周积分兑换经验已达到<color=yellow>50万<color>积分的周上限，本周内将无法兑换经验，但仍然可以获得家族贡献度等奖励", nFinalBouns)
    end

    if nAwardPai > 0 and nAwardFu > 0 then
      szMsg = szMsg .. string.format("，可以领取1个%s战场令牌和2个黄金福袋", Battle.NAME_GAMELEVEL[nAwardPai])
      nPaiCount = 1
      nFuCount = nAwardFu
    elseif nAwardFu > 0 then
      szMsg = szMsg .. "，可以领取1个福袋"
      nFuCount = nAwardFu
    end
    local tbOpt = {
      { "确定", self.OnAwardGood, self, pPlayer, nAwardPai, nPaiCount, nFuCount, nBouns, nFinalBouns, nMoney, tbXuanjing, nExpTime },
      { "再说吧" },
    }
    local _, _, szExtendInfo = SpecialEvent.ExtendAward:DoCheck("Battle", pPlayer, nBouns, self.nLevel)
    Dialog:Say(szMsg .. szExtendInfo .. "，确定要现在领取吗？", tbOpt)
    return 0
  end
  return 1
end

if EventManager.IVER_bOpenTiFu == 1 then
  function tbNpcBase:OnAwardGood(pPlayer, nItemId, nPaiCount, nFuCount, nBouns, nFinalBouns, nMoney, tbXuanJing, nExpTime)
    local nCount = 0
    local szMsg = szMsg or ""
    for i, v in pairs(tbXuanJing) do
      nCount = nCount + v
    end
    if pPlayer.CountFreeBagCell() < nCount + nPaiCount + nFuCount then
      pPlayer.Msg("您身上背包剩余空间不足，无法给你奖励")
      return 0
    end
    if 0 == Battle:AwardGood(pPlayer, nItemId, nPaiCount, nFuCount, nBouns, self.nLevel) then
      -- 保存玩家义军令牌的等级
      pPlayer.Msg("您身上背包剩余空间不足，无法给你奖励")
      return 0
    else
      local nAwardRank = pPlayer.GetTask(Battle.TSKGID, Battle.TSK_BTPLAYER_AWARDRANK)
      me.Earn(nMoney, Player.emKEARN_EVENT)
      for i, v in pairs(tbXuanJing) do
        me.AddStackItem(18, 1, 1, i, nil, v)
      end

      Item.tbZhenYuan:AddExp(nil, nExpTime, 0, me)
      me.SetTask(Battle.TSKGID, Battle.TSK_BTPLAYER_AWARDRANK, 0)

      if nMoney > 0 then
        szMsg = szMsg .. string.format("，获得%d银两", nMoney)
      end
      local szMsg = string.format("你上一次的战场积分为%d分", nBouns)
      if nFinalBouns > 0 then
        szMsg = szMsg .. string.format("，已经领取%d分的经验奖励", nFinalBouns)
      elseif nFinalBouns == 0 and nBouns > 0 then
        szMsg = szMsg .. string.format("，您的本周积分兑换经验已达到<color=yellow>50万<color>积分的周上限，本周内将无法兑换经验，但仍然可以获得家族贡献度等奖励", nFinalBouns)
      end
      if nPaiCount > 0 then
        szMsg = szMsg .. string.format("，获取奖励1个%s<color=green>战场令牌<color>和2个<color=yellow>黄金福袋<color>。", Battle.NAME_GAMELEVEL[nItemId])
      elseif nFuCount > 0 then
        szMsg = szMsg .. "，获取奖励1个<color=yellow>黄金福袋<color>。"
      end
      pPlayer.Msg(szMsg)
    end
    return
  end
else
  function tbNpcBase:OnAwardGood(pPlayer, nItemId, nPaiCount, nFuCount, nBouns, nFinalBouns)
    if 0 == Battle:AwardGood(pPlayer, nItemId, nPaiCount, nFuCount, nBouns, self.nLevel) then
      -- 保存玩家义军令牌的等级
      pPlayer.Msg("您身上背包剩余空间不足，无法给你奖励")
    else
      local szMsg = string.format("你上一次的战场积分为%d分", nBouns)
      if nFinalBouns > 0 then
        szMsg = szMsg .. string.format("，已经领取%d分的经验奖励", nFinalBouns)
      elseif nFinalBouns == 0 and nBouns > 0 then
        szMsg = szMsg .. string.format("，您的本周积分兑换经验已达到<color=yellow>50万<color>积分的周上限，本周内将无法兑换经验，但仍然可以获得家族贡献度等奖励", nFinalBouns)
      end
      if nPaiCount > 0 then
        szMsg = szMsg .. string.format("，获取奖励1个%s<color=green>战场令牌<color>和2个<color=yellow>黄金福袋<color>。", Battle.NAME_GAMELEVEL[nItemId])
      elseif nFuCount > 0 then
        szMsg = szMsg .. "，获取奖励1个<color=yellow>黄金福袋<color>。"
      end
      pPlayer.Msg(szMsg)
      -- 参加了一次宋金
      StudioScore:OnActivityFinish("songjin", pPlayer)
      SpecialEvent.ActiveGift:AddCounts(pPlayer, 31) --领取宋金奖励完成一场宋金活跃度
    end
    return
  end
end

function tbNpcBase:ProcessBattleBouns()
  local pPlayer = me
  if self.tbMission then
    local nCampId = pPlayer.GetTask(Battle.TSKGID, Battle.TASKID_BTCAMP)
    local nMyBTKey = pPlayer.GetTask(Battle.TSKGID, Battle.TSK_BTPLAYER_KEY)
    local nBTKey = self.tbMission.nBattleKey
    local nDiaFlag = 0

    local nBattleSeqA = math.fmod(nMyBTKey, 10)
    local nBattleSeqB = math.fmod(nBTKey, 10)
    local nBattleTimeA = nMyBTKey - nBattleSeqA
    local nBattleTimeB = nBTKey - nBattleSeqB

    -- id不一样表示可能是同一时间段不同场次，可能是不同一时间段
    if nMyBTKey ~= nBTKey then
      -- 如果是同一时间段的表示这个玩家可能从另一个场次出来到其他场次
      if nBattleTimeA == nBattleTimeB then
        nDiaFlag = 1
      end
    else -- 相同id
      -- 如果战局开始了就不能领了，直接继续下面对话
      if self.tbMission.nState == 2 then
        return 1
      end
      -- 同一场次却不是同一阵营
      if 0 ~= nCampId and self.nCampId ~= nCampId then
        nDiaFlag = 2
      end
    end

    if nDiaFlag == 1 then
      Dialog:Say(string.format(self.tbDialog[8], Battle.NAME_GAMELEVEL[self.nLevel], self.tbBattleSeq[nBattleSeqA], Battle.NAME_CAMP[nCampId]))
      return 0
    elseif nDiaFlag == 2 then
      Dialog:Say(self.tbDialog[5])
      return 0
    end
  end

  local nAwardPai = pPlayer.GetTask(Battle.TSKGID, Battle.TSK_BTPLAYER_ZHANCHANGLINGPAI)
  local nAwardFu = pPlayer.GetTask(Battle.TSKGID, Battle.TSK_BTPLAYER_FUDAI)
  local nBouns = pPlayer.GetTask(Battle.TSKGID, Battle.TSK_BTPLAYER_TOTALBOUNS)
  if nBouns > 0 then
    local nOrgBouns = pPlayer.GetTask(Battle.TSKGID, Battle.TSK_BTPLAYER_BOUNS_TOTAL_WEEK)
    local nNowBouns = nBouns + nOrgBouns
    pPlayer.SetTask(Battle.TSKGID, Battle.TSK_BTPLAYER_BOUNS_TOTAL_WEEK, nNowBouns)
    local nLastReWeek = Lib:GetLocalWeek(pPlayer.GetTask(Battle.TSKGID, Battle.TSK_BTPLAYER_BOUNS_TOTAL_RETIME))
    local nNowWeek = Lib:GetLocalWeek(GetTime())
    if nNowWeek == nLastReWeek then
      local nCurMax = KGblTask.SCGetDbTaskInt(Battle.DBTASK_SONGJIN_BOUNS_MAX)
      if nCurMax < nNowBouns then
        KGblTask.SCSetDbTaskStr(Battle.DBTASK_SONGJIN_BOUNS_MAX, pPlayer.szName)
        KGblTask.SCSetDbTaskInt(Battle.DBTASK_SONGJIN_BOUNS_MAX, nNowBouns)
      end
    end
    pPlayer.SetTask(Battle.TSKGID, Battle.TSK_BTPLAYER_TOTALBOUNS, 0)
    pPlayer.Msg(string.format("您上场宋金的战斗没有坚持到最后，还有宋金积分未领取，现在帮您加到周积分中去，你可以用积分到<color=yellow>报名点军需官<color>那儿兑换奖励！"))
  end

  local nFlag = Battle:RefreshBattleWeekBouns(pPlayer)
  if 1 == nFlag then
    return 2
  end
  return 0
end

function tbNpcBase:CheckMaxNum()
  local nMyCampCount = self.tbCamp:GetPlayerCount()
  if Battle.BTPLNUM_HIGHBOUND <= nMyCampCount then
    return 0
  end
  return 1
end

-- 检查玩家的等级和阵营
-- 返回值：0、此玩家不能进入；1、此玩家本场尚未报名，可以参加；2、此玩家报过名了，可以进入
function tbNpcBase:CheckPlayer()
  if not self.tbMission then
    Dialog:Say("开赴战场的大军尚未出发，请继续勤加操练，等候我们的通知。")
    return
  end

  local pPlayer = me

  local nJoinLevel = Battle:GetJoinLevel(pPlayer)
  local nCampId = pPlayer.GetTask(Battle.TSKGID, Battle.TASKID_BTCAMP)
  local nFlag = 1

  local nMyBTKey = pPlayer.GetTask(Battle.TSKGID, Battle.TSK_BTPLAYER_KEY)
  local nBTKey = self.tbMission.nBattleKey
  local nDiaFlag = 0

  local nBattleSeqA = math.fmod(nMyBTKey, 10)
  local nBattleSeqB = math.fmod(nBTKey, 10)
  local nBattleTimeA = nMyBTKey - nBattleSeqA
  local nBattleTimeB = nBTKey - nBattleSeqB

  if nMyBTKey ~= nBTKey then
    if nBattleTimeA == nBattleTimeB then
      nDiaFlag = 1
    end
  else
    if 0 ~= nCampId and self.nCampId ~= nCampId then
      nDiaFlag = 2
    elseif 0 ~= nCampId and self.nCampId == nCampId then
      nFlag = 2
    end
  end

  if nFlag == 1 then
    if self.nLevel > nJoinLevel then
      local tbOpt = {
        --								{"我想了解战役的信息", self.OnBattleInfo, self},
        { "好的" },
      }
      Dialog:Say("你目前造诣不精，还是回去勤加练习，今后再来为国效力吧！", tbOpt)
      return 0
    end

    if pPlayer.IsFreshPlayer() == 1 then
      Dialog:Say("你目前尚未加入门派，武艺不精，还是等加入门派后再来把！")
      return 0
    end

    if self.nLevel < nJoinLevel then -- 有问题
      Dialog:Say(string.format("你目前武艺精湛，还是去参加<color=yellow>%s<color>战场的战斗吧！", Battle.NAME_GAMELEVEL[nJoinLevel]))
      return 0
    end
  end

  if nDiaFlag == 1 then
    Dialog:Say(string.format(self.tbDialog[8], Battle.NAME_GAMELEVEL[self.nLevel], self.tbBattleSeq[nBattleSeqA], Battle.NAME_CAMP[nCampId]))
    return 0
  elseif nDiaFlag == 2 then
    Dialog:Say(self.tbDialog[5])
    return 0
  end

  if 0 == self:CheckNumDif(self.nLevel) then
    local nSongNum = self.tbMission.tbCamps[Battle.CAMPID_SONG].nPlayerCount
    local nJinNum = self.tbMission.tbCamps[Battle.CAMPID_JIN].nPlayerCount
    local szMsg = string.format("目前双方人数比为：<color=orange>宋：%d<color>、<color=purple>金：%d<color>，较之敌军，我军目前暂无兵力匮乏之忧，你还是暂且静候，过会再来吧！", nSongNum, nJinNum)
    Dialog:Say(szMsg)
    return 0
  end

  return nFlag
end

function tbNpcBase:CheckNumDif(nJoinLevel)
  local nMyCampNum = self.tbCamp:GetPlayerCount()
  local nEnemyCampNum = self.tbCamp.tbOppCamp:GetPlayerCount()
  if nMyCampNum < Battle.tbBTPLNUM_LOWBOUND[nJoinLevel] then
    return 1
  end
  local nTemp = nMyCampNum - nEnemyCampNum
  local nDifNumLimit = math.max(Battle.BTPLNUM_NUMDIF, (nMyCampNum + nEnemyCampNum) * 0.1)
  if nTemp >= nDifNumLimit then
    return 0
  end
  return 1
end

-- 选择个人进入战场
function tbNpcBase:OnSingleJoin(pPlayer)
  if me.GetTiredDegree1() == 2 then
    Dialog:Say("您太累了，还是休息下吧！")
    return
  end
  self:Refresh()

  if 0 == self:CheckPlayer() then
    return
  end

  self:DoSingleJoin(pPlayer)
end

function tbNpcBase:OnNewEnter(pPlayer, nNowTime)
  if 0 == self:CheckPlayer() then
    return
  end
  self:DoSingleJoin(pPlayer)
  Battle:ResetBonus(pPlayer, nNowTime)
end

-- 执行真正进入战场操作
function tbNpcBase:DoSingleJoin(pPlayer)
  Setting:SetGlobalObj(pPlayer)
  if not self.tbMission then -- 异常
    Dialog:Say("你来晚了，对不起下次再来吧")
    Setting:RestoreGlobalObj()
    return
  elseif self.tbMission.nState == 2 then -- 战局开始
    pPlayer.Msg(self.tbDialog[4])
  else -- 战局还没开始
    Dialog:Say(self.tbDialog[3])
  end
  if self.tbMission.nState == 2 then -- 战局开始后才记录玩家阵营和战场id
    --记录玩家参加宋金战场的次数
    local nBTKey = self.tbMission.nBattleKey
    local bIsDiffBattle = Battle:IsDiffBattle(pPlayer, nBTKey)
    if bIsDiffBattle and 1 == bIsDiffBattle then
      Stats.Activity:AddCount(pPlayer, Stats.TASK_COUNT_BATTLE, 1)
      local nTimes = pPlayer.GetTask(SpecialEvent.tbPJoinEventTimes.TASKGID, SpecialEvent.tbPJoinEventTimes.TASK_JOIN_BATTLE)
      pPlayer.SetTask(SpecialEvent.tbPJoinEventTimes.TASKGID, SpecialEvent.tbPJoinEventTimes.TASK_JOIN_BATTLE, nTimes + 1)
    end

    pPlayer.SetTask(Battle.TSKGID, Battle.TSK_BTPLAYER_KEY, self.tbMission.nBattleKey)
    pPlayer.SetTask(Battle.TSKGID, Battle.TASKID_BTCAMP, self.nCampId)
  end
  self.tbMission:JoinPlayer(pPlayer, self.nCampId)
  Setting:RestoreGlobalObj()
end

function tbNpcBase:OnBattleInfo() -- todo
  self:Refresh()
end

Battle.tbNpcBase = tbNpcBase

tbNpc:Init()
