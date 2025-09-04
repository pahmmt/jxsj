-- 文件名　：newbattle_gs.lua
-- 创建者　：LQY
-- 创建时间：2012-07-18 15:02:18
-- 说	明 ：新宋金战场的GS实现
-- 哇！小朋友们大家好~还记得我是谁吗？
if not MODULE_GAMESERVER then
  return
end
Require("\\script\\mission\\newbattle\\newbattle_def.lua")

NewBattle.tbNewBattleOpen = NewBattle.tbNewBattleOpen or {
  [1] = 0,
  [2] = 0,
  [3] = 0,
}
--启动战场活动，进入第一个阶段
function NewBattle:StartNewBattle_GS(nSession, nBattleSeq, nExValue)
  if self:CanStartBattle(nBattleSeq) ~= 1 then
    return 0
  end
  --
  --DEBUG BEGIN
  if NewBattle.__DEBUG then
    print("启动战场_GS")
  end
  --
  --DEBUG END
  local nMapId = NewBattle.TB_MAP_BATTLE[nBattleSeq]
  if not nMapId then
    return 0
  end

  --地图所在GS判断
  if SubWorldID2Idx(nMapId) < 0 then
    return 0
  end
  self.tbMission = self.tbMission or {}
  --Mission是否开放
  if self.tbMission[nMapId] and self.tbMission[nMapId]:IsOpen() ~= 0 then
    --DEBUG BEGIN
    if NewBattle.__DEBUG then
      print("Mission尚未关闭，无法打开！")
    end
    self.tbMission[nMapId]:State_Boom()
  end
  local dwBattleLevel = self:GetValueFromLimitTable(self.TIMELEVEL, Kinsalary:GetOpenDay()) --这里由开服天数决定
  --初始化MISSION
  local szBattleTime = GetLocalDate("%m%d%H")
  self.tbMission[nMapId] = self.tbMission[nMapId] or Lib:NewClass(self.Mission)
  self.tbMission[nMapId]:InitGame(NewBattle.TB_MAP_BATTLE[nBattleSeq], dwBattleLevel, szBattleTime, nSession, nBattleSeq, nExValue)

  --置活动状态
  self.nBattle_State = self.BATTLE_STATES.SIGNUP

  --初始化表
  self.tbTimers = {} --计时器列表

  if self.tbMission[nMapId]:IsOpen() == 1 then
    GCExcute({ "NewBattle:BattleOpen_GC", nBattleSeq, self.tbMission[nMapId].nBattleKey })
  else
    --记log
  end
end

-- 同步开放信息
function NewBattle:UpdateOpen_GS(tbNewBattleOpen, bGS2GC)
  if tbNewBattleOpen and type(tbNewBattleOpen) == "table" then
    self.tbNewBattleOpen = tbNewBattleOpen
  else
    return
  end
  --GS宕机后，如果是战场所在GS，将关闭信息重新同步一下。
  if bGS2GC == 1 then
    for n, nMapId in ipairs(self.TB_MAP_BATTLE) do
      if SubWorldID2Idx(nMapId) >= 0 and self.tbNewBattleOpen[n] ~= 0 then
        if not self.tbMission[nMapId] or self.tbMission[nMapId]:IsOpen() == 0 then
          GCExcute({ "NewBattle:BattleClose_GC", n })
        end
      end
    end
  end
end

-- 成功开启一个战场
function NewBattle:BattleOpen_GS(nBattleSeq, nBattleKey)
  local szMsg = string.format("宋金战场之冰火天堑开启，目前正进入报名阶段，欲参战者请尽快从七大城市中的战场募兵官或使用宋金诏书前往宋金战场报名点报名，报名剩余时间:%d分。参战条件:等级不小于%d级。", self.TIME_SIGN / (Env.GAME_FPS * 60), Battle.LEVEL_LIMIT[1])
  KDialog.NewsMsg(0, Env.NEWSMSG_NORMAL, szMsg)
  self.tbNewBattleOpen[nBattleSeq] = nBattleKey
end
--玩家能否加入某一阵营
function NewBattle:CanPlayerJoinPower(pPlayer, nBattleSeq, nPower)
  if self.tbNewBattleOpen[nBattleSeq] == 0 then
    return 0, "开赴战场的大军尚未出发，请继续勤加操练，等候我们的通知。"
  end
  if pPlayer.IsFreshPlayer() == 1 then
    return 0, "你目前尚未加入门派，武艺不精，还是等加入门派后再来把！"
  end
  if pPlayer.GetTiredDegree1() == 2 then
    return 0, "您太累了，还是休息下吧！"
  end
  if pPlayer.nLevel < 60 then
    return 0, "您的等级过低，贸然前去会有生命危险！"
  end
  local nOpen, nSong, nJin = self:GetBattlePlayerCount(nBattleSeq)
  if nOpen == 0 then
    return 0, "开赴冰火天堑战场的大军尚未出发，请继续勤加操练，等候我们的通知。"
  end
  local nPlayerKey = pPlayer.GetTask(self.TSKGID, self.TSK_BTPLAYER_KEY)
  local nPlayerPower = pPlayer.GetTask(self.TSKGID, self.TASKID_BTCAMP)
  local nPlayerSeq = math.mod(nPlayerKey, 10)
  local nPlayerTime = nPlayerKey - nPlayerSeq
  local nKey = self.tbNewBattleOpen[nBattleSeq]
  local nTime = nKey - nBattleSeq
  if nPlayerTime == nTime then
    if nPlayerSeq ~= nBattleSeq then
      return 0, "你已经在冰火天堑(" .. Lib:Transfer4LenDigit2CnNum(nPlayerSeq) .. ")报名了。"
    elseif nPlayerPower ~= nPower then
      return 0, "你已加入" .. self.POWER_CNAME[nPlayerPower] .. "军，还是下次再来吧。"
    end
  end

  if nPower == 1 and nSong - nJin >= self.SIGNLIMIT then
    return 0, "我军目前暂无兵力匮乏之忧，你还是暂且静候，过会再来吧！"
  end
  if nPower == 2 and nJin - nSong >= self.SIGNLIMIT then
    return 0, "我军目前暂无兵力匮乏之忧，你还是暂且静候，过会再来吧！"
  end
  if nPower == 1 and nSong >= NewBattle.MAXPLAYER then
    return 0, "我军军营已经人满为患，你过会再来吧！"
  end

  if nPower == 2 and nJin >= NewBattle.MAXPLAYER then
    return 0, "我军军营已经人满为患，你过会再来吧！"
  end
  return 1
end

--将玩家传回
function NewBattle:MovePlayerOut(pPlayer, nPower)
  if not nPower then
    local nMap, nMapX, nMapY = Boss.Qinshihuang:GetLeaveMapPos()
    pPlayer.NewWorld(nMap, nMapX, nMapY)
    return
  end
  --self:PlayerLeave(pPlayer);
  pPlayer.SetFightState(0)
  --因为报名点是老地图，这里也调用老数据
  local tbMaps = Battle.MAPID_LEVEL_CAMP[Battle:GetJoinLevel(pPlayer)]
  local nMapId = 0
  for _, tbMapCampId in pairs(tbMaps) do
    if SubWorldID2Idx(tbMapCampId[nPower]) >= 0 then
      nMapId = tbMapCampId[nPower]
      break
    end
  end
  if nMapId == 0 then
    nMapId = tbMaps[MathRandom(1, #tbMaps)][nPower]
  end
  pPlayer.NewWorld(nMapId, unpack(NewBattle:GetRandomPoint(NewBattle.POS_BAOMING)))
end

--发送信息到玩家
function NewBattle:SendMsg2Player(pPlayer, szMsg, nType)
  local nMsgType = nType or NewBattle.SYSTEM_CHANNEL_MSG
  if not pPlayer then
    return
  end
  for _, szType in ipairs(self.MSGSENDRULE[nMsgType]) do
    if szType == "CHANNEL" then
      KDialog.Msg2PlayerList({ pPlayer }, szMsg, "系统")
    end
    if szType == "BLACK" then
      Dialog:SendBlackBoardMsg(pPlayer, szMsg)
    end
    if szType == "RED" then
      Dialog:SendInfoBoardMsg(pPlayer, szMsg)
    end
  end
end

--新玩家加入
function NewBattle:PlayerJoin(pPlayer, nType, nMapId)
  if not pPlayer then
    return
  end
  self:SendMsg2Player(pPlayer, "成功加入" .. self.POWER_CNAME[nType] .. "军阵营")
  local nDbTskId_PlCnt = self.DBTASKID_PLAYER_COUNT[self.tbMission[nMapId].nBattleSeq][nType]
  GCExcute({ "NewBattle:PlayerCount_GC", nDbTskId_PlCnt, 1 })
end

--玩家离开
function NewBattle:PlayerLeave(pPlayer, nGroupId, nMapId)
  if not pPlayer then
    return
  end
  local nGroupId = nGroupId or self.tbMission[nMapId]:GetPlayerGroupId(me)
  local nDbTskId_PlCnt = self.DBTASKID_PLAYER_COUNT[self.tbMission[nMapId].nBattleSeq][nGroupId]
  GCExcute({ "NewBattle:PlayerCount_GC", nDbTskId_PlCnt, 0 })
end

--关闭MISSION
function NewBattle:CloseMission(nBattleSeq)
  local nMapId = self.TB_MAP_BATTLE[nBattleSeq]
  if self.tbMission[nMapId]:IsOpen() ~= 0 then
    self.tbMission[nMapId]:Close()
    GCExcute({ "NewBattle:BattleClose_GC", nBattleSeq })
  end
  return 0
end

-- 关闭了一个战场
function NewBattle:BattleClose_GS(nBattleSeq)
  self.tbNewBattleOpen[nBattleSeq] = 0
end

-- 召唤石读条阶段判断
function NewBattle:CheckOccupyPole(pPlayer, dwNpc)
  local pPole = KNpc.GetById(dwNpc)
  if not pPole then
    return 0
  end
  local nMapId = pPole.GetWorldPos()
  if self.tbMission[nMapId]:IsOpen() ~= 1 then
    return 0
  end
  local nPower = self.tbMission[nMapId]:GetPlayerGroupId(pPlayer)
  if nPower == -1 then
    return 0
  end
  local tbInfo = pPole.GetTempTable("Npc")
  if tbInfo.nPower == 0 then
    return 3 --直接占领
  end
  if nPower == tbInfo.nPower and tbInfo.nState == 1 then
    return 1 --收回卫兵
  end
  if nPower ~= tbInfo.nPower and tbInfo.nState == 0 then
    return 2 --招出卫兵
  end
  return 0
end

--进入战场操作
function NewBattle:EnterBattle(nBattleSeq, nPower, nType)
  --	if nType == 2 then
  local n, szMsg = self:PlayerJoinNewBattle(me.nId, nBattleSeq, nPower)
  if n == 0 then
    Dialog:Say(szMsg)
  end
  return
  --	end
  --	local szMsg = "你现在要进入战场么？战斗中，你可以与其他人组成小队，一同杀敌，势必会事半功倍。";
  --	Dialog:Say(szMsg,{{"我要进入战场", self.EnterBattle, self, nBattleSeq, nPower, 2},{"我再想想"}});
  --	return;
end

-- 玩家参加战场
function NewBattle:PlayerJoinNewBattle(nPlayerId, nBattleSeq, nPower)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return 0, "玩家不存在了！"
  end
  local nMapId = self.TB_MAP_BATTLE[nBattleSeq]
  local nR, szMag = self:CanPlayerJoinPower(pPlayer, nBattleSeq, nPower)
  if nR == 0 then
    return 0, szMag
  end
  pPlayer.SetTask(self.TSKGID, self.TASKID_BTCAMP, nPower)
  pPlayer.NewWorld(self.TB_MAP_BATTLE[nBattleSeq], unpack(self:GetRandomPoint(self.POS_READY[nPower])))
end

-- 对外接口 是否有战场开启
function NewBattle:OnlyBattleOpen()
  local n = 0
  for i = 1, #self.tbNewBattleOpen do
    if self.tbNewBattleOpen[i] ~= 0 then
      n = n + 1
    end
  end
  return n
end

-- 对外接口 获取进入战场对话框，由UI、物品、NPC调用
-- nPower 1:宋 2：金 0：所有
function NewBattle:GetBattleDialog(nPower)
  local tbOpt = {}
  local szMsg = "    国家兴亡匹夫有责，只要你等级达到60级，就可以来报效国家了，加入我们吧！此外，你每天都可以在军需官处领取一定的军需奖励，供作战之用！"
  for i = 1, #self.OPEN_BATTLE do
    local n, nSong, nJin = self:GetBattlePlayerCount(i)
    if n == 1 then
      nJin = (nPower == 1) and -1 or nJin
      nSong = (nPower == 2) and -1 or nSong
      if nSong ~= -1 then
        tbOpt[#tbOpt + 1] = {
          string.format("加入<color=yellow>冰火天堑%s<color><color=orange> 宋军(人数:%d)<color>", Lib:Transfer4LenDigit2CnNum(i), nSong),
          self.EnterBattle,
          self,
          i,
          1,
        }
      end
      if nJin ~= -1 then
        tbOpt[#tbOpt + 1] = {
          string.format("加入<color=yellow>冰火天堑%s<color><color=pink> 金军(人数:%d)<color>", Lib:Transfer4LenDigit2CnNum(i), nJin),
          self.EnterBattle,
          self,
          i,
          2,
        }
      end
    end
  end
  tbOpt[#tbOpt + 1] = { "结束对话" }
  if #tbOpt <= 0 then
    szMsg = "开赴冰火天堑战场的大军尚未出发，请勤加操练，等候我们的通知！"
  end
  Dialog:Say(szMsg, tbOpt)
  return
end

-- 对外接口 获取战场人数，战场未开放返回0 ，开放返回1,宋人数，金人数
function NewBattle:GetBattlePlayerCount(nBattleSeq)
  if not self.tbNewBattleOpen[nBattleSeq] or self.tbNewBattleOpen[nBattleSeq] == 0 then
    return 0
  end
  local tbDbTskId_PlCnt = self.DBTASKID_PLAYER_COUNT[nBattleSeq]
  local nSong = KGblTask.SCGetTmpTaskInt(tbDbTskId_PlCnt[1])
  local nJin = KGblTask.SCGetTmpTaskInt(tbDbTskId_PlCnt[2])
  return 1, nSong, nJin
end

-- 对外接口 玩家能否领奖
function NewBattle:PlayerCanGetAward(nPlayerId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return 0, "玩家不存在了！"
  end
  local nPlayerKey = pPlayer.GetTask(self.TSKGID, self.TSK_BTPLAYER_KEY)
  local nPlayerSeq = math.mod(nPlayerKey, 10)
  local nPlayerTime = nPlayerKey - nPlayerSeq
  if not nPlayerKey or not nPlayerSeq or nPlayerKey == 0 then
    return 0, "没有领奖数据！"
  end
  local nTime = 0
  for nSeq, key in ipairs(self.tbNewBattleOpen) do
    if key ~= 0 then
      nTime = key - nSeq
    end
  end
  if nPlayerTime == nTime and self.tbNewBattleOpen[nPlayerSeq] ~= 0 then
    return 0, "你参加的战场还未结束！"
  end
  local nPlayerBaseExp = pPlayer.GetTask(self.TSKGID, self.TASKID_BASEEXP)
  if not nPlayerBaseExp or nPlayerBaseExp == 0 then
    return 0, "你没有领奖信息！"
  end
  if nPlayerBaseExp == 1 then
    return 2, "你的积分过低，没有奖励！"
  end
  local nBindMoney = nPlayerBaseExp * 200
  local nKinMoney = math.floor(nPlayerBaseExp * 1.5 * Lib:_GetXuanEnlarge(Kinsalary:GetOpenDay()))
  local nExKinMoney = math.floor(pPlayer.GetTask(self.TSKGID, self.TASKID_WINEX) * nKinMoney / 10)
  local nExp = nPlayerBaseExp * pPlayer.GetBaseAwardExp()
  local nWeiWang = math.max(math.ceil((nPlayerBaseExp - 200) / 20), 0) + 2
  -- 返回信息为：1, "奖励信息", 绑银, 威望, 家族银锭, 胜利额外银锭
  return 1, string.format("经验值<color=yellow>%d<color>,绑银<color=yellow>%d<color>，威望<color=yellow>%d<color>，家族银锭<color=yellow>%d<color>，胜方额外银锭<color=yellow>%d<color>\n<color=green>(胜利方将享受35%%到60%%的奖励加成)<color>", nExp, nBindMoney, nWeiWang, nKinMoney, nExKinMoney), nExp, nBindMoney, nWeiWang, nKinMoney, nExKinMoney
end

-- 对外接口 玩家领奖
function NewBattle:PlayerGetAward(nPlayerId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return 0, "玩家不存在了！"
  end
  local n, szMsg, nExp, nBindMoney, nWeiWang, nKinMoney, nExKinMoney = self:PlayerCanGetAward(nPlayerId)
  if n == 0 then
    return 0, szMsg
  end
  --pPlayer.SetTask(self.TSKGID, self.TSK_BTPLAYER_KEY, 0);
  pPlayer.SetTask(self.TSKGID, self.TASKID_BASEEXP, 0)
  pPlayer.SetTask(self.TSKGID, self.TASKID_WINEX, 0)
  if n == 2 then
    return 0, "你的积分过低，没有奖励！"
  end
  pPlayer.AddExp(nExp)
  pPlayer.AddBindMoney(nBindMoney)
  pPlayer.AddKinSilverMoney(nKinMoney)
  pPlayer.AddKinSilverMoney(nExKinMoney)
  pPlayer.AddKinReputeEntry(nWeiWang, "battle")
  -- 参加了一次宋金
  StudioScore:OnActivityFinish("songjin", pPlayer)
  SpecialEvent.ActiveGift:AddCounts(pPlayer, 31) --领取宋金奖励完成一场宋金活跃度
end

--载具快捷键处理
function NewBattle:SwitchCarrier(nPlayerId, nNpcId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return
  end
  if not self.tbMission[pPlayer.nMapId] then
    return
  end
  if self.tbMission[pPlayer.nMapId].nBattle_State ~= self.BATTLE_STATES.FIGHT then
    return
  end
  local bOnCarrier = (pPlayer.GetCarrierNpc()) and 1 or 0
  if bOnCarrier == 1 then
    pPlayer.LandOffCarrier()
    return
  else
    if not nNpcId then
      return
    end
    local pNpc = KNpc.GetById(nNpcId)
    if not pNpc then
      return
    end
    if pNpc.IsCarrier() == 1 then
      --判断载具归属
      local nPlayerPower = self.tbMission[pPlayer.nMapId]:GetPlayerGroupId(pPlayer)
      if not nPlayerPower then
        return
      end
      local tbInfo = pNpc.GetTempTable("Npc")
      if nPlayerPower ~= tbInfo.nPower then
        pPlayer.Msg("不是我方载具，不能使用。")
        return
      end

      --判断与载具的距离
      local nMapId1, nPosX1, nPosY1 = pPlayer.GetWorldPos()
      local nMapId2, nPosX2, nPosY2 = pNpc.GetWorldPos()
      local nDis = ((nPosX1 - nPosX2) ^ 2 + (nPosY1 - nPosY2) ^ 2) ^ 0.5
      if nDis > NewBattle.CARRIERDISLIMIT then
        pPlayer.Msg("距离太远了，无法乘坐载具。")
        return
      end

      --数据埋点，玩家控制资源记录  账号，角色，控制的资源模版ID
      StatLog:WriteStatLog("stat_info", "ganluocheng", "res_use", pPlayer.nId, pNpc.nTemplateId)

      --下马
      pPlayer.RideHorse(0)
      --GeneralProcess:StartProcess("乘坐载具……",self.GETCARRIERTIME, {self.OnCarrierProcess, self, nPlayerId, nNpcId}, nil, self.tbCarrierBreakEvent);
      Npc.tbCarrier:LandInCarrier(pNpc, me)
    else
      pPlayer.Msg("不能乘坐非载具！")
    end
  end
end

-- C2S 玩家上下载具
function c2s:PlayerSwitchCarrier(nNpcId)
  if GLOBAL_AGENT then
    return 0
  end
  NewBattle:SwitchCarrier(me.nId, nNpcId)
end
