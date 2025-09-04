-- 文件名　：newbattle_cpalyer.lua
-- 创建者　：LQY
-- 创建时间：2012-07-19 16:53:36
-- 说　　明：存储Player所有数据的类

local tbPLBase = NewBattle.tbPlayerBase or {}
NewBattle.tbPlayerBase = tbPLBase
function tbPLBase:init(nPlayerId, nGounpId, tbMission)
  self.nPlayerId = nPlayerId
  self.nGounpId = nGounpId
  self.nSeriesKillNum = 0 -- 连斩数
  self.nMaxSeriesKillNum = 0 -- 最大连斩数
  self.nTransferCD = 0 -- 个人传送CD
  self.nBouns = 0 -- 战局积分
  self.nKillPlayerNum = 0 -- 杀死玩家个数
  self.nKillPlayerBouns = 0 -- 杀敌玩家积分
  self.nBeenKilledNum = 0 -- 被杀数
  self.nRank = 1 -- 排名
  self.nTitle = 1 -- 官衔
  self.bFristBlood = 0 -- 一血
  self.nAlreadyAddCount = 0 -- 是否已增加本日宋金数量
  self.nShengWang = 0 -- 声望
  self.nHonor = 0 -- 荣誉
  self.tbLogData = {}
  self.szAccount, self.szName = StatLog:__WriteStatLog_GetAccName(self.nPlayerId)

  self.pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  self.tbCamp = {}
  self.tbCamp.nCampId = nGounpId
  self.nEnterBattleTime = GetTime()
  self.tbMission = tbMission
  self.szFacName = Player:GetFactionRouteName(self.pPlayer.nFaction, self.pPlayer.nRouteId) -- 玩家门派名称

  -- 奖励数据 LOG用
  self.nBindMoney = 0
  self.nKinMoney = 0
  self.nWeiWang = 0

  self.tbKillNum = -- 摧毁数量
    {
      ["ZHANCHE"] = 0,
      ["JIANTA"] = 0,
      ["PAOTAI"] = 0,
      ["SHOUHUZHE"] = 0,
      ["LONGMAI"] = 0,
      ["JUNDUI"] = 0,
    }
  self.tbKillPoint = --摧毁得分
    {
      ["ZHANCHE"] = 0,
      ["JIANTA"] = 0,
      ["PAOTAI"] = 0,
      ["SHOUHUZHE"] = 0,
      ["LONGMAI"] = 0,
    }
  self.tbDefPoint = --守护得分
    {
      ["PAOTAI"] = 0,
      ["SHOUHUZHE"] = 0,
      ["LONGMAI"] = 0,
    }
  self.nTimeDeath = nTimeDeath or 0
end

--能否使用召唤石
function tbPLBase:CanUseStone()
  local nPass = Lib:GetLocalDayTime() - self.nTransferCD
  if nPass >= NewBattle.PLAYERTRANSFERCD then
    self.nTransferCD = Lib:GetLocalDayTime()
    return 1
  end
  return 0, NewBattle.PLAYERTRANSFERCD - nPass
end

--获取pPlayer
function tbPLBase:GetPlayer()
  local pPlayer = KPlayer.GetPlayerObjById(self.nPlayerId)
  return pPlayer and pPlayer or nil
end

-- 玩家被杀
function tbPLBase:AddBeenKill(tbKillers, bCarrie)
  self.nBeenKilledNum = self.nBeenKilledNum + 1

  --是被玩家杀的
  if tbKillers then
    local szKillName = ""
    for _, tbKiller in pairs(tbKillers) do
      szKillName = szKillName .. tbKiller:GetPlayer().szName .. "%s"
    end
    if #tbKillers == 1 then
      szKillName = string.format(szKillName, "")
    else
      szKillName = string.format(szKillName, "和", "乘坐的战车")
    end
    local pPlayerme = self:GetPlayer()
    if bCarrie and pPlayerme then
      NewBattle:SendMsg2Player(pPlayerme, "你被<color=yellow>" .. szKillName .. "<color>击为重伤！", 1)
    end
    for _, tbKiller in pairs(tbKillers) do
      if bCarrie then
        local pKiller = tbKiller:GetPlayer()
        if pKiller then
          NewBattle:SendMsg2Player(pKiller, "<color=yellow>" .. pPlayerme.szName .. "<color>被你击成重伤！", 1)
        end
      end
      if self.nSeriesKillNum >= NewBattle.SERIESPK_NAME[1][1] then
        local pPlayerme = self:GetPlayer()
        if pPlayerme then
          local szMsg = string.format("<color=yellow>%s<color>终结了<color=yellow>%s<color>的<color=white>%d<color>连斩<color=yellow><bclr=red>[%s]<bclr><color>!", szKillName, pPlayerme.szName, self.nSeriesKillNum, NewBattle:GetSeriesPkName(self.nSeriesKillNum))
          self.tbMission:BroadCastMission(szMsg, NewBattle.SYSTEMRED_MSG, 0)
        end
      end
      --一血处理
      if not self.tbMission.bFristBlood or self.tbMission.bFristBlood == 0 then
        local pPlayerme = self:GetPlayer()
        if pPlayerme then
          local szMsg = string.format("<color=yellow>%s<color>击杀了<color=yellow>%s<color>得到了<color=yellow><bclr=red>一斩<bclr><color>！", szKillName, pPlayerme.szName)
          self.tbMission:BroadCastMission(szMsg, NewBattle.SYSTEMRED_MSG, 0)
          --记录首杀者ID
          self.tbMission.bFristBlood = 1
          for _, tbKiller in pairs(tbKillers) do
            tbKiller.bFristBlood = 1
            tbKiller:AddPoint(NewBattle.FRISTBLOODPOINT, "你获得了<color=yellow>[一斩]<color>个人积分<color=yellow>%d<color>点！")
          end
        end
      end
      tbKiller:AddKill(self)
    end
  end

  --连斩数清零
  self.nSeriesKillNum = 0
end

--玩家杀人
function tbPLBase:AddKill(tbBeKill)
  self.nKillPlayerNum = self.nKillPlayerNum + 1
  self.nKillPlayerBouns = self.nKillPlayerBouns + 1
  self:SeriesKill()
  self:AddKillPoint(tbBeKill)
end

--玩家杀人获得积分
function tbPLBase:AddKillPoint(tbBeKill)
  local nSelf = self.nKillPlayerBouns
  local nTag = tbBeKill.nKillPlayerBouns
  local nBase = NewBattle.KILL_BASEPOINT
  local nPoint = math.floor(nBase * ((nTag + nBase) / (nSelf + nBase)) ^ 0.5)
  --连斩加成
  if self.nSeriesKillNum >= 3 then
    nPoint = nPoint * (NewBattle.SERIESPKPOINT + 1)
  end
  nPoint = math.floor(nPoint)
  self.nKillPlayerBouns = self.nKillPlayerBouns + nPoint
  self:AddPoint(nPoint, "你击杀玩家获得个人积分<color=yellow>%d<color>点！")
end

--玩家连斩处理
function tbPLBase:SeriesKill()
  self.nSeriesKillNum = self.nSeriesKillNum + 1
  if self.nSeriesKillNum > self.nMaxSeriesKillNum then
    self.nMaxSeriesKillNum = self.nSeriesKillNum
  end
  local pPlayer = self:GetPlayer()
  if not pPlayer then
    return
  end
  local tbAchievementSeriesKill = {
    [3] = 138,
    [10] = 139,
    [30] = 140,
    [50] = 141,
    [100] = 142,
  }
  if tbAchievementSeriesKill[self.nSeriesKillNum] then
    Achievement:FinishAchievement(pPlayer, tbAchievementSeriesKill[self.nSeriesKillNum]) --连斩。
  end
  Achievement:FinishAchievement(pPlayer, 125) --个人击退一名敌对玩家。
  Achievement:FinishAchievement(pPlayer, 126) --个人击退20名敌对玩家
  Achievement:FinishAchievement(pPlayer, 127) --个人击退200名敌对玩家。
  --显示连斩
  if self.nSeriesKillNum >= NewBattle.SERIESPK_NAME[1][1] then
    --只在刚达到连斩等级时广播
    local szSerName, nR = NewBattle:GetSeriesPkName(self.nSeriesKillNum)
    if nR == 1 then
      local szMsg = string.format("玩家<color=yellow>%s<color>完成了<color=white>%d<color>连斩<color=yellow><bclr=red>[%s]<bclr><color>!", pPlayer.szName, self.nSeriesKillNum, szSerName)
      self.tbMission:BroadCastMission(szMsg, NewBattle.SYSTEMRED_MSG, 0)
    end
    pPlayer.ShowSeriesPk(1, self.nSeriesKillNum, 30)
  end
end

--守护NPC得分
function tbPLBase:DefNpc(szType)
  self.tbDefPoint[szType] = self.tbDefPoint[szType] + NewBattle.DEFPOINTRULE[szType]
  self:AddPoint(NewBattle.DEFPOINTRULE[szType], "你因守护<color=yellow>" .. NewBattle.NPC_CNAME[szType] .. "<color>获得个人积分<color=yellow>%d<color>点。")
end

--玩家击杀NPC得分
function tbPLBase:KillNpc(szType, nPlayerCount, bFirst, tbPlayers)
  local tbPoint = NewBattle.KILLPOINTRULE[szType]
  local nCount = nPlayerCount or 1
  if not tbPoint then
    return
  end
  self.tbKillNum[szType] = self.tbKillNum[szType] + 1
  local nSelfBoun = tbPoint[1] / nCount
  self:AddPoint(nSelfBoun, tbPoint[3])
  self.tbKillPoint[szType] = self.tbKillPoint[szType] + nSelfBoun
  --阵营共享分处理
  if bFirst == 1 and tbPoint[2] > 0 then
    local tbIsHere = {}
    for _, tbPlayer in ipairs(tbPlayers) do
      tbIsHere[tbPlayer.nPlayerId] = 1
    end
    local tbGroupPlayers = self.tbMission:GetPlayerList(self.nGounpId)
    if tbGroupPlayers then
      for _, pPlayer in ipairs(tbGroupPlayers) do
        if not tbIsHere[pPlayer.nId] then
          local tbPlayer = self.tbMission.tbCPlayers[pPlayer.nId]
          if tbPlayer then
            tbPlayer:AddPoint(tbPoint[2], "你获得阵营共享积分<color=yellow>%d<color>点。")
          end
        end
      end
    end
  end
end

--玩家获得积分
function tbPLBase:AddPoint(nPoint, szMsg)
  if nPoint <= 0 then
    return
  end
  nPoint = math.floor(nPoint)
  self.nBouns = self.nBouns + nPoint
  self:ProcessRank() -- 称号
  self:CountAward() --记录奖励
  local pPlayer = self:GetPlayer()
  if pPlayer then
    NewBattle:SendMsg2Player(pPlayer, string.format(szMsg, nPoint), 1)
  end
end

--胜负加分
function tbPLBase:WinLostAddPoint(nWiner)
  --self:AddPoint(100, "你获得基础积分<color=yellow>%d<color>分。");
  if nWiner == 0 then
    self:AddPoint(self.nBouns * NewBattle.BATTLEPOINTRULE["DRAW"] / 100, "你获得了平局积分<color=yellow>%d<color>点！")
    self:CountAward()
    return
  end
  if nWiner ~= self.nGounpId then
    self:AddPoint(self.nBouns * NewBattle.BATTLEPOINTRULE["LOST"] / 100, "你获得了失败积分<color=yellow>%d<color>点！")
    self:CountAward()
    return
  end
  if nWiner == self.nGounpId then
    self:AddPoint(self.nBouns * NewBattle.BATTLEPOINTRULE["WIN"] / 100, "你获得了胜利积分<color=yellow>%d<color>点！")
    self:CountAward()
    self:CountWinMoney()
    return
  end
end

-- 处理官衔相关信息
function tbPLBase:ProcessRank()
  local nTitle = 0
  if self.nTitle >= 10 then
    return
  end
  for i = #NewBattle.TAB_RANKBONUS, 1, -1 do
    if self.nBouns >= NewBattle.TAB_RANKBONUS[i] and -1 ~= NewBattle.TAB_RANKBONUS[i] then
      nTitle = i
      break
    end
  end
  if self.nTitle == nTitle then
    return
  end

  assert(self.nTitle < nTitle)
  local pPlayer = self:GetPlayer()
  if not pPlayer then
    return
  end
  pPlayer.AddTitle(2, self.nGounpId, nTitle, 0)
  local tbAchievement = {
    [5] = 135,
    [7] = 136,
    [9] = 137,
  }
  if tbAchievement[nTitle] then
    Achievement:FinishAchievement(pPlayer, tbAchievement[nTitle])
  end

  self.nTitle = nTitle
  return nTitle
end

function tbPLBase:GetKinTongName()
  local pPlayer = self:GetPlayer()
  if not pPlayer then
    return "无"
  end
  local nTongId = pPlayer.dwTongId
  local pTong = KTong.GetTong(nTongId)
  local szTKName = "无"

  if pTong then
    szTKName = "（帮会）" .. pTong.GetName()
  else
    local nKinID = pPlayer.GetKinMember() --
    --DEBUG BEGIN
    if NewBattle.__DEBUG then
      print("nKinID", nKinID)
    end
    --
    --DEBUG END
    if nKinID then
      if nKinID > 0 then
        local pKin = KKin.GetKin(nKinID)
        if pKin then
          szTKName = "（家族）" .. pKin.GetName()
        end
      end
    end
  end

  return szTKName -- 家族帮会名，有帮会计帮会，无帮会计家族
end

--获得杀死载具数量
function tbPLBase:KillNpcNum()
  local nNum = 0
  for _, nN in pairs(self.tbKillNum) do
    nNum = nNum + nN
  end
  return nNum
end

--击杀野生NPC得分
function tbPLBase:OnKillNpc(nId)
  if not NewBattle.FIGHTNPC_NAME[nId] then
    return
  end
  local szNpcName = NewBattle.FIGHTNPC_NAME[nId]
  local nPoint = NewBattle.BATTLE_NPCPOINT[szNpcName]
  self.tbKillNum.JUNDUI = self.tbKillNum.JUNDUI + 1
  local szMsg = string.format("你杀死了%s军%s获得积分", NewBattle.POWER_CNAME[NewBattle:GetEnemy(self.nGounpId)], NewBattle.BATTLE_NPCNAME[szNpcName])
  self:AddPoint(nPoint, szMsg .. "<color=yellow>%d<color>点。")
end
--夺取召唤石
function tbPLBase:GetStone()
  self:AddPoint(NewBattle.GETSTONEPOINT, "你夺取了召唤石获得积分<color=yellow>%d<color>点。")
end

--设置排名
function tbPLBase:SetRank(nRank)
  if self.nRank ~= nRank then
    self.nRank = nRank
    self:CountAward()
  end
end
--计算奖励
function tbPLBase:CountAward()
  if not self.tbMission or self.tbMission:IsOpen() ~= 1 then
    return
  end
  local pPlayer = self:GetPlayer()
  if not pPlayer then
    return
  end
  local nPlayerCount = self.tbMission:GetPlayerCount(0)
  --计算基准经验
  local nExpBase = NewBattle:GetValueFromLimitTable(NewBattle.BATTLEAWARDPOINT, self.nBouns)
  if self.nBouns == 0 then
    nExpBase = 0
  end
  --计算排名经验
  local nExpRank = 400 - (200 * self.nRank / nPlayerCount)
  if nExpRank < 200 then
    print("NewBattle Rank", pPlayer.szName)
    nExpRank = 200
  end
  --计算实际经验
  local nExp = math.min(nExpBase, nExpRank)
  nExp = math.floor(nExp)

  self.nBindMoney = nExp * 200
  self.nKinMoney = math.floor(nExp * 1.5 * Lib:_GetXuanEnlarge(Kinsalary:GetOpenDay()))
  self.nWeiWang = math.max(math.ceil((nExp - 200) / 20), 0) + 2
  if nExp == 0 then
    nExp = 1
  end
  --记录基准经验
  pPlayer.SetTask(NewBattle.TSKGID, NewBattle.TASKID_BASEEXP, nExp)
end

--计算胜利银锭
function tbPLBase:CountWinMoney()
  if not self.tbMission or self.tbMission:IsOpen() ~= 1 then
    return
  end
  local nPlayerCount = self.tbMission:GetPlayerCount(0)
  local nExMoney = NewBattle:GetValueFromLimitTable(NewBattle.BATTLEWINMONEY, nPlayerCount)
  if nExMoney > 0 then
    self.nKinMoney = self.nKinMoney + math.floor(self.nKinMoney * nExMoney / 100)
    self.pPlayer.SetTask(NewBattle.TSKGID, NewBattle.TASKID_WINEX, nExMoney)
  end
end
