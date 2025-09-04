Require("\\script\\misc\\globaltaskdef.lua")

Xisuidao.TSKGROUP = 2011
Xisuidao.TSKID_LINGPAICOUNT = 15 -- 进入洗髓岛的令牌个数
Xisuidao.TSKID_REVIVEMAPID = 16 -- 进入洗髓岛前的重生点地图id
Xisuidao.TSKID_REVIVEPOINTID = 17 -- 进入洗髓岛前的重生点储物箱ID
Xisuidao.TSKID_AWARDFREE = 18 -- 免费进入洗髓岛的标记

Xisuidao.XISUIDAOMAPID = 255 -- 暂定，洗点区
Xisuidao.BATTLEMAPID = 256 -- 暂定，战斗测试区

Xisuidao.LIMIT_PLAYER_NUM = 200 -- 洗髓岛在线人数的限制包括战斗区和洗点区

Xisuidao.GBLTASKID_NUM = DBTASK_XISUIDAO_PLAYER

Xisuidao.tbDeathRevPos = {
  [1] = { Xisuidao.XISUIDAOMAPID, 1652, 3389 },
}

Xisuidao.tbItem2Map = { 18, 1, 1274, 1 } --三修令牌

-- 如果需要继续开新等级的时候给予奖励就要添
Xisuidao.tbLevelInfo = {
  DBTASD_SERVER_SETMAXLEVEL89,
  DBTASD_SERVER_SETMAXLEVEL99,
  DBTASD_SERVER_SETMAXLEVEL150,
}

function Xisuidao:Init() end

function Xisuidao:OnEnterXisuidao_Xidian(pPlayer)
  if 60 > pPlayer.nLevel then
    Setting:SetGlobalObj(pPlayer)
    Dialog:Say("你的等级尚不足60级，功力尚浅，不能进入洗髓岛。")
    Setting:RestoreGlobalObj()
    return
  end

  local nPlayerNum = KGblTask.SCGetTmpTaskInt(Xisuidao.GBLTASKID_NUM)
  if nPlayerNum >= self.LIMIT_PLAYER_NUM then
    Setting:SetGlobalObj(pPlayer)
    Dialog:Say("洗髓岛人数已满，您不能进入，请稍后再来吧。")
    Setting:RestoreGlobalObj()
    return
  end

  if 1 == self:AwardFreeEnter(pPlayer) then
    return
  end

  local nCount = pPlayer.GetTask(Xisuidao.TSKGROUP, Xisuidao.TSKID_LINGPAICOUNT)
  local szMsg = ""
  if 0 == nCount then
    szMsg = "在洗髓岛内可以洗去已分配的潜能点和技能点，并重新分配。第一次进入洗髓岛无需任何代价，你确定要进入了吗？"
  elseif 0 < nCount and 5 > nCount then
    szMsg = string.format("你之前已经进过%d次洗髓岛，此次需要%d个洗髓岛令牌方可进入，可在奇珍阁购买，你确定要进入了吗？", nCount, nCount)
  elseif 5 <= nCount then
    szMsg = "你之前已经进过很多次洗髓岛，此次需要5个洗髓岛令牌方可进入，可在奇珍阁购买，你确定要进入了吗？"
  else
    -- DEBUG
    return
  end
  local tbOpt = {
    { "是的，我现在就要前去", self.OnEnter, self, pPlayer, nCount },
    { "结束对话" },
  }
  Setting:SetGlobalObj(pPlayer)
  Dialog:Say(szMsg, tbOpt)
  Setting:RestoreGlobalObj()
  return
end

function Xisuidao:CanDuoxiu(pPlayer)
  if pPlayer.nLevel < 100 then
    Setting:SetGlobalObj(pPlayer)
    Dialog:Say("必须修炼到<color=red>100级<color>，有足够的功力，才能辅修其他门派。")
    Setting:RestoreGlobalObj()
    return 0
  end

  local nCount = pPlayer.GetItemCountInBags(Item.SCRIPTITEM, 1, 16, 1)
  if nCount < 1 then
    Setting:SetGlobalObj(pPlayer)
    Dialog:Say("辅修门派后需要用<color=red>修炼珠来<color>切换，所以必须携带<color=red>修炼珠<color>才可入岛辅修。")
    Setting:RestoreGlobalObj()
    return 0
  end

  if pPlayer.IsAccountLock() == 1 then
    Setting:SetGlobalObj(pPlayer)
    Dialog:Say("你的帐号处于锁定状态，不能进洗髓岛多修。")
    Setting:RestoreGlobalObj()
    return 0
  end

  local nCurGerneCount = #Faction:GetGerneFactionInfo(pPlayer)
  if nCurGerneCount >= Faction.MAX_USED_FACTION then
    Setting:SetGlobalObj(pPlayer)
    Dialog:Say("目前你尚没有辅修机会，或者已经使用完了。")
    Setting:RestoreGlobalObj()
    return 0
  end

  return 1
end

function Xisuidao:OnEnterXisuidao_Duoxiu(pPlayer, nFlag)
  local nPlayerNum = KGblTask.SCGetTmpTaskInt(Xisuidao.GBLTASKID_NUM)
  if nPlayerNum >= self.LIMIT_PLAYER_NUM then
    Setting:SetGlobalObj(pPlayer)
    Dialog:Say("洗髓岛人数已满，您不能进入，请稍后再来吧。")
    Setting:RestoreGlobalObj()
    return
  end

  if self:CanDuoxiu(pPlayer) ~= 1 then
    return
  end

  -- 多修时提醒玩家如果要辅修古墓派需要古墓好友度达到2级才能辅修
  if Faction:IsOpenGumuFuXiu() == 1 then
    local nShowWarningMsg = 0
    if me.nFaction ~= Env.FACTION_ID_GUMU then
      local nOrgFaction = Faction:GetOriginalFaction(pPlayer)
      if nOrgFaction ~= Env.FACTION_ID_GUMU then
        nShowWarningMsg = 1
      end
    end
    if nShowWarningMsg == 1 then
      local nFuXiuLevel = pPlayer.GetReputeLevel(Faction.GUMU_FRIEND_REPUTE_CAMP, Faction.GUMU_FRIEND_REPUTE_CLASS)
      if nFuXiuLevel < Faction.GUMU_FRIEND_REPUTE_CAN_FUXIU_LEVEL then
        if not nFlag or nFlag ~= 1 then
          Setting:SetGlobalObj(pPlayer)
          Dialog:Say("<color=red>古墓派为特殊辅修门派，可自由辅修，但切换门派时需要古墓友好度达到2级才能切换至古墓。<color>    \n确定进入洗髓岛？", {
            { "是，进入洗髓岛", self.OnEnterXisuidao_Duoxiu, self, pPlayer, 1 },
            { "否，我再想想" },
          })
          Setting:RestoreGlobalObj()
          return 0
        end
      end
    end
  end

  local tbGerneFactionInfo = Faction:GetGerneFactionInfo(pPlayer)

  local szMsg = "目前你还可以再辅修<color=yellow>%d<color>个门派。<enter>"
  szMsg = string.format(szMsg, Faction.MAX_USED_FACTION - #tbGerneFactionInfo)
  szMsg = szMsg .. "辅修门派即为在保留现有门派的基础上，再额外修炼其他门派。<enter>在洗髓岛内可找<color=yellow>洗髓大师<color>选择辅修门派加入。<enter>江湖之上各路武功路数千变万化，刀枪棍剑各领风骚。要习得其中精华还需勤于修炼方可在不同路数的武技之中顿悟和升华，江湖后生们纷纷跃跃欲试，你是否准备好了呢？"

  local tbOpt = {
    { "是的，我现在就要前去", self.EnterXisuidao_Duoxiu, self, pPlayer, #tbGerneFactionInfo },
    { "结束对话" },
  }

  Setting:SetGlobalObj(pPlayer)
  Dialog:Say(szMsg, tbOpt)
  Setting:RestoreGlobalObj()
  return
end

-- return 1, nLastGerne or 0
function Xisuidao:CanModifyDuoxiu(pPlayer)
  local tbGerneFactionInfo = Faction:GetGerneFactionInfo(pPlayer)
  local nChangeGerneIndex = Faction:GetChangeGenreIndex(pPlayer)
  local nModifyFactionNum = Faction:GetModifyFactionNum(pPlayer)

  if #tbGerneFactionInfo <= 1 then
    Dialog:Say("目前你尚没有辅修任何门派。")
    return 0
  end

  if pPlayer.IsAccountLock() == 1 then
    Dialog:Say("你的帐号处于锁定状态，不能进洗髓岛多修。")
    return 0
  end

  if nModifyFactionNum >= Faction:GetMaxModifyTimes(pPlayer) then
    Dialog:Say("目前你尚没有更换机会，或者已经使用完了。")
    return 0
  end

  return 1
end

function Xisuidao:OnEnterXisuidao_ModifyDuoxiu(pPlayer)
  Faction:InitChangeFaction(pPlayer)
  local nRes = self:CanModifyDuoxiu(pPlayer)
  if nRes == 0 then
    return
  end

  local tbGerneFactionInfo = Faction:GetGerneFactionInfo(pPlayer)
  local nDelta = Faction:GetMaxModifyTimes(pPlayer) - Faction:GetModifyFactionNum(pPlayer)
  local szMsg = string.format("目前你还有<color=yellow>%d次<color>更换辅修门派的机会。", nDelta)

  if Faction:IsOpenGumuFuXiu() == 1 then
    szMsg = szMsg .. "\n<color=red>古墓派为特殊辅修门派，可自由辅修，但切换门派时需要古墓友好度达到2级才能切换至古墓。<color>"
  end
  szMsg = szMsg .. "<enter>你要把当前已辅修的哪个门派更换掉？"

  local tbOpt = { { "结束对话" } }

  for i = 2, #tbGerneFactionInfo do
    local szFactionName = Player.tbFactions[tbGerneFactionInfo[i]].szName
    table.insert(tbOpt, 1, { szFactionName, self.SureModifyFaction, self, pPlayer, szFactionName, i })
  end

  Dialog:Say(szMsg, tbOpt)
  return
end

function Xisuidao:SureModifyFaction(pPlayer, nFactionName, nFactionGerne)
  local szMsg = "你确定要更换辅修门派——<color=yellow>%s<color>吗？<enter>确认后，即可进入洗髓岛内找洗髓大师重新选择辅修门派，并替换掉这次选择的门派，请慎重选择。"
  szMsg = string.format(szMsg, nFactionName)

  local tbOpt = {
    { "是的，我现在就要前去", self.EnterXisuidao_ModifyDuoXiu, self, pPlayer, nFactionGerne },
    { "我稍后再来" },
  }

  Dialog:Say(szMsg, tbOpt)
end

-- 多修一个门派
function Xisuidao:EnterXisuidao_Duoxiu(pPlayer, nGerneFaction)
  local nResult = self:CanDuoxiu(pPlayer)
  if nResult ~= 1 then
    return
  end

  local nRet, szMsg = Map:CheckTagServerPlayerCount(self.XISUIDAOMAPID)
  if nRet ~= 1 then
    pPlayer.Msg(szMsg)
    return 0
  end

  if EventManager.IVER_bUseChangeFactionItem == 1 and nGerneFaction == 2 then
    local nResult = self:CheckHaveItem2Map(pPlayer)
    if nResult ~= 1 then
      return 0
    end
    pPlayer.ConsumeItemInBags2(1, self.tbItem2Map[1], self.tbItem2Map[2], self.tbItem2Map[3], self.tbItem2Map[4])
  end

  Faction:InitChangeFaction(pPlayer)

  local nCurGerneCount = #Faction:GetGerneFactionInfo(pPlayer)

  local nGerne = nCurGerneCount + 1 -- 要修一个新的

  Faction:SetChangeGenreIndex(pPlayer, nGerne)
  Faction:WriteLog(Dbg.LOG_INFO, "EnterXisuidao_Duoxiu", pPlayer.szName, nGerne)
  pPlayer.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, string.format("进入洗髓岛多修，修的是第%d修。", nGerne))
  pPlayer.NewWorld(self.XISUIDAOMAPID, 1652, 3389)
  pPlayer.Msg("进入洗髓岛，你可以开始进行辅修门派的选择和试炼。")
end

--vn 检查是否是有三修令牌才能进入洗髓岛
function Xisuidao:CheckHaveItem2Map(pPlayer)
  local nCount = pPlayer.GetItemCountInBags(unpack(self.tbItem2Map))
  if nCount < 1 then
    Setting:SetGlobalObj(pPlayer)
    Dialog:Say("辅修第三门派需要有<color=red>三修令牌<color>。")
    Setting:RestoreGlobalObj()
    return 0
  end
  return 1
end

-- 更换多修
-- nGerne：要换第几个
function Xisuidao:EnterXisuidao_ModifyDuoXiu(pPlayer, nGerne)
  local nRet, szMsg = Map:CheckTagServerPlayerCount(self.XISUIDAOMAPID)
  if nRet ~= 1 then
    pPlayer.Msg(szMsg)
    return 0
  end

  Faction:InitChangeFaction(pPlayer)
  local nCurGerneCount = #Faction:GetGerneFactionInfo(pPlayer)
  assert(nGerne >= 2 and nGerne <= nCurGerneCount)

  local nRes = self:CanModifyDuoxiu(pPlayer)
  if nRes == 0 then
    return
  end

  local nCurrModifyNum = Faction:GetModifyFactionNum(pPlayer)
  Faction:SetModifyFactionNum(pPlayer, nCurrModifyNum + 1)
  Faction:SetChangeGenreIndex(pPlayer, nGerne)

  Faction:WriteLog(Dbg.LOG_INFO, "EnterXisuidao_ModifyDuoxiu", pPlayer.szName, nGerne)
  pPlayer.NewWorld(self.XISUIDAOMAPID, 1652, 3389)
  pPlayer.Msg("进入洗髓岛，你可以开始更换辅修门派。")
  local szLogMsg = string.format("进入洗髓岛更换辅修门派， 换的是第%d修。", nGerne)
  pPlayer.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, szLogMsg)
end

-- 增加判断给予免费洗点的机会
function Xisuidao:AwardFreeEnter(pPlayer)
  for _, nTaskId in ipairs(self.tbLevelInfo) do
    local nTime = KGblTask.SCGetDbTaskInt(nTaskId)
    if nTime > 0 then
      local nAwardFlag = 0
      local nFreeFlag = pPlayer.GetTask(self.TSKGROUP, self.TSKID_AWARDFREE)
      if nFreeFlag <= 0 then
        if nTime < GetTime() then
          nAwardFlag = 1
        end
      else
        if nTime > nFreeFlag then
          nAwardFlag = 1
        end
      end
      if nAwardFlag == 1 then
        local szMsg = "目前你拥有系统赠送的免费进入洗髓岛洗点的机会。"
        local tbOpt = {
          { "是的，我现在就要前去", self.OnFreeEnter, self, pPlayer, nTime },
          { "结束对话" },
        }
        Setting:SetGlobalObj(pPlayer)
        Dialog:Say(szMsg, tbOpt)
        Setting:RestoreGlobalObj()
        return 1
      end
    else
      break
    end
  end
  return 0
end

function Xisuidao:OnEnter(pPlayer, nCount)
  local nRet, szMsg = Map:CheckTagServerPlayerCount(self.XISUIDAOMAPID)
  if nRet ~= 1 then
    pPlayer.Msg(szMsg)
    return 0
  end
  -- 判断包裹里的令牌是否足够
  if 0 < nCount then
    local nPaiCount = nCount
    if 5 < nCount then
      nPaiCount = 5
    end
    local nLingpaiCount = pPlayer.GetItemCountInBags(18, 1, 79, 1)
    -- 包裹里的令牌不足
    if nPaiCount > nLingpaiCount then
      Setting:SetGlobalObj(pPlayer)
      Dialog:Say("你带的洗髓岛令牌不足，待备齐了再来吧。")
      Setting:RestoreGlobalObj()
      return
    end
    pPlayer.ConsumeItemInBags(nPaiCount, 18, 1, 79, 1)
  end
  if 5 > nCount then
    nCount = nCount + 1
    pPlayer.SetTask(self.TSKGROUP, self.TSKID_LINGPAICOUNT, nCount)
  end
  self:EnterXisuidao(pPlayer)
end

function Xisuidao:OnFreeEnter(pPlayer, nTime)
  local nRet, szMsg = Map:CheckTagServerPlayerCount(self.XISUIDAOMAPID)
  if nRet ~= 1 then
    pPlayer.Msg(szMsg)
    return 0
  end
  pPlayer.SetTask(self.TSKGROUP, self.TSKID_AWARDFREE, nTime)
  self:EnterXisuidao(pPlayer)
end

function Xisuidao:EnterXisuidao(pPlayer)
  pPlayer.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, "进入洗髓岛洗点")
  pPlayer.NewWorld(self.XISUIDAOMAPID, 1652, 3389)
  pPlayer.Msg("进入洗髓岛，你可以无限次洗技能点和潜能点")
end

function Xisuidao:OnRecoverXisuidao(pPlayer)
  local nChangeGerneIndex = Faction:GetChangeGenreIndex(pPlayer)
  if nChangeGerneIndex > 0 then
    Faction:WriteLog(Dbg.LOG_INFO, "OnRecoverXisuidao", pPlayer.szName, nChangeGerneIndex)
    local szLogMsg = string.format("进入洗髓岛更换辅修门派， 换的是第%d修。", nChangeGerneIndex)
    pPlayer.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, szLogMsg)
    pPlayer.NewWorld(self.XISUIDAOMAPID, 1652, 3389)
    pPlayer.Msg("进入洗髓岛，你可以开始更换辅修门派。")
  end
end

Xisuidao:Init()

--?pl DoScript("\\script\\player\\xisuidao\\xisuidao.lua")
