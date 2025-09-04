-- 文件名　：crosstimeroom_npc.lua
-- 创建者　：zhangjunjie
-- 创建时间：2011-08-02 16:11:02
-- 描述：传送npc

local tbNpc = Npc:GetClass("crosstimeroom_npc")

function tbNpc:OnDialog()
  if KGblTask.SCGetDbTaskInt(DBTASK_CROSSTIMEROOM_CLOSESTATE) ~= 0 then
    Dialog:Say(string.format("林风杨：你好，%s!", me.szName))
    return 0
  end
  if TimeFrame:GetState("OpenBoss120") ~= 1 then
    Dialog:Say(string.format("林风杨：你好，%s!", me.szName))
    return 0
  else
    local nOpenBoss120Week = Lib:GetLocalWeek(TimeFrame:GetTime("OpenBoss120"))
    local nNowWeek = Lib:GetLocalWeek(GetTime())
    if nNowWeek <= nOpenBoss120Week then
      Dialog:Say(string.format("林风杨：你好，%s!", me.szName))
      return 0
    end
  end
  local szMsg = "    先秦时期，百家争鸣。其中有一阴阳家循五行、八卦之玄妙，探过去未来，生死循环之究竟。\n    阴阳家通明天道循环，其大司命执掌过去，少司命窥探未来。\n    阴阳时光殿更是阴阳家的隐秘根据地，如今若有此机会，你可愿一探？"
  local tbOpt = {}
  local nLastGetTime = Lib:GetLocalWeek(me.GetTask(CrossTimeRoom.nTaskGroupId, CrossTimeRoom.nTaskGetItemTime))
  local nNowWeekTime = Lib:GetLocalWeek()
  if nLastGetTime ~= nNowWeekTime then
    tbOpt[#tbOpt + 1] = { "领取阴阳时光殿令牌", CrossTimeRoom.GiveCrossTimeRoomItem, CrossTimeRoom }
  end
  tbOpt[#tbOpt + 1] = { "闯入阴阳时光殿", self.Process, self, me.nId }
  tbOpt[#tbOpt + 1] = { "我再想想" }
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:Process(nPlayerId)
  local szMsg = "我可以带你去阴阳时光殿!"
  local tbOpt = {}
  if me.nFaction <= 0 then
    Dialog:Say("想进入阴阳时光殿，先加了门派再来找我！")
    return 0
  end
  if me.nLevel < 100 then
    Dialog:Say("想进入阴阳时光殿，等你达到100级再来找我吧！")
    return 0
  end
  local nTeamId = me.nTeamId
  if nTeamId <= 0 then
    Dialog:Say("想进入阴阳时光殿，请组队前来！")
    return 0
  end
  local pGame = CrossTimeRoom:GetGameObjByTeamId(me.nTeamId)
  if not pGame then
    tbOpt[#tbOpt + 1] = { "开启阴阳时光殿", self.ApplyGame, self, nPlayerId }
  else
    tbOpt[#tbOpt + 1] = { "进入阴阳时光殿", self.Transfer, self }
  end
  tbOpt[#tbOpt + 1] = { "我再想想" }
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:ApplyGame(nPlayerId)
  if me.nFaction <= 0 then
    Dialog:Say("想进入阴阳时光殿，先加了门派再来找我！")
    return 0
  end
  if me.nLevel < 100 then
    Dialog:Say("想进入阴阳时光殿，等你达到100级再来找我吧！")
    return 0
  end
  if me.nTeamId <= 0 then
    Dialog:Say("想进入阴阳时光殿，请组队前来！")
    return 0
  end
  if me.IsCaptain() ~= 1 then
    Dialog:Say("想进入阴阳时光殿，请队长前来报名！")
    return 0
  end
  local nRet, szError = CrossTimeRoom:CheckCanApply(me.nId)
  if nRet ~= 1 then
    Dialog:Say(szError)
    return 0
  end
  local nNearby = 0
  local tbMemberId, nCount = KTeam.GetTeamMemberList(me.nTeamId)
  local tbPlayerList = KPlayer.GetAroundPlayerList(me.nId, 40)
  for _, tbRound in pairs(tbPlayerList or {}) do
    for _, nMemberId in pairs(tbMemberId) do
      local pMember = KPlayer.GetPlayerObjById(nMemberId)
      if pMember and pMember.szName == tbRound.szName then
        nNearby = nNearby + 1
      end
    end
  end
  if nNearby ~= nCount then
    Dialog:Say("对不起，有队友不在身边！")
    return 0
  end
  --todo,检查队友身上次数，和队友身上道具是否符合条件
  local nIsPlayerHasNoItem, tbNoItemPlayerName = 0, {}
  local nIsPlayerNoGetLevel, tbNoGetLevelPlayerName = 0, {}
  local nIsPlayerNoFaction, tbNoFactionPlayerName = 0, {}
  local nIsPlayerNotGetTask, tbNoTaskPlayerName = 0, {}
  for _, nMemberId in pairs(tbMemberId) do
    local pMember = KPlayer.GetPlayerObjById(nMemberId)
    if pMember then
      if CrossTimeRoom:CheckHaveJoinItem(pMember) ~= 1 then
        nIsPlayerHasNoItem = 1
        table.insert(tbNoItemPlayerName, pMember.szName)
      end
      if pMember.nLevel < 100 then
        nIsPlayerNoGetLevel = 1
        table.insert(tbNoGetLevelPlayerName, pMember.szName)
      end
      if pMember.nFaction <= 0 then
        nIsPlayerNoFaction = 1
        table.insert(tbNoFactionPlayerName, pMember.szName)
      end
      if not Task:GetPlayerTask(pMember).tbTasks[479] or Task:GetPlayerTask(pMember).tbTasks[479].nCurStep ~= 2 then
        nIsPlayerNotGetTask = 1
        table.insert(tbNoTaskPlayerName, pMember.szName)
      end
    end
  end
  if nIsPlayerNoGetLevel == 1 then --有等级未达到的
    local szMsg = ""
    for _, szName in pairs(tbNoGetLevelPlayerName) do
      szMsg = szMsg .. "<color=yellow>" .. szName .. "<color>等级未达到100级\n"
    end
    Dialog:Say(szMsg)
    return 0
  end
  if nIsPlayerNoFaction == 1 then --有未加入门派的
    local szMsg = ""
    for _, szName in pairs(tbNoFactionPlayerName) do
      szMsg = szMsg .. "<color=yellow>" .. szName .. "<color>未加入任何门派\n"
    end
    Dialog:Say(szMsg)
    return 0
  end
  if nIsPlayerHasNoItem == 1 then
    local szMsg = ""
    for _, szName in pairs(tbNoItemPlayerName) do
      szMsg = szMsg .. "<color=yellow>" .. szName .. "<color>身上没有令牌\n"
    end
    Dialog:Say(szMsg)
    return 0
  end
  if nIsPlayerNotGetTask == 1 then
    local szMsg = ""
    for _, szName in pairs(tbNoTaskPlayerName) do
      szMsg = szMsg .. "<color=yellow>" .. szName .. "<color>没有接取阴阳时光殿任务或者接取的任务未到达指定步骤\n"
    end
    Dialog:Say(szMsg)
    return 0
  end
  local pGame = CrossTimeRoom:GetGameObjByTeamId(me.nTeamId)
  if not pGame then
    local nNum = CrossTimeRoom:GetGameNum(GetServerId())
    if nNum >= CrossTimeRoom.MAX_GAME then
      Dialog:Say("当前活动场地已满！")
      return 0
    end
    GCExcute({ "CrossTimeRoom:ApplyGame_GC", me.nId, GetServerId(), me.nMapId })
    return 1
  else
    Dialog:Say("队长已经开启过副本了！")
    return 0
  end
end

function tbNpc:Transfer()
  CrossTimeRoom:JoinGame()
end

-----------------第一关的对话开启人----
local tbRoom2Npc = Npc:GetClass("crosstimeroom2_dialog")

function tbRoom2Npc:OnDialog()
  self:BeginGame(him.dwId)
end

function tbRoom2Npc:BeginGame(nNpcId)
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    return 0
  end
  local pGame = CrossTimeRoom:GetGameObjByMapId(him.nMapId)
  if not pGame then
    return 0
  end
  if pGame.tbRoom and pGame.tbRoom[1] then
    pGame.tbRoom[1]:StartAddNpc()
    pNpc.Delete()
  else
    return 0
  end
end

-------------第三关的月影花--------
local tbEvent = {
  Player.ProcessBreakEvent.emEVENT_MOVE,
  Player.ProcessBreakEvent.emEVENT_ATTACK,
  Player.ProcessBreakEvent.emEVENT_SITE,
  Player.ProcessBreakEvent.emEVENT_USEITEM,
  Player.ProcessBreakEvent.emEVENT_ARRANGEITEM,
  Player.ProcessBreakEvent.emEVENT_DROPITEM,
  Player.ProcessBreakEvent.emEVENT_SENDMAIL,
  Player.ProcessBreakEvent.emEVENT_TRADE,
  Player.ProcessBreakEvent.emEVENT_CHANGEFIGHTSTATE,
  Player.ProcessBreakEvent.emEVENT_CLIENTCOMMAND,
  Player.ProcessBreakEvent.emEVENT_LOGOUT,
  Player.ProcessBreakEvent.emEVENT_DEATH,
}

local tbRoom3Flower = Npc:GetClass("crosstimeroom_flowernpc")

function tbRoom3Flower:OnDialog()
  GeneralProcess:StartProcess("医治中...", 2 * Env.GAME_FPS, { self.DoCure, self, him.dwId, me.nId }, nil, tbEvent)
end

function tbRoom3Flower:DoCure(nNpcId, nPlayerId)
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    return 0
  end
  local pGame = CrossTimeRoom:GetGameObjByMapId(me.nMapId)
  if not pGame then
    return 0
  end
  me.RemoveSkillState(CrossTimeRoom.nRedStateId)
  me.RemoveSkillState(CrossTimeRoom.nYellowStateId)
  me.RemoveSkillState(CrossTimeRoom.nGreenStateId)
  pNpc.Delete()
end

--------------------------
local tbRoom3Grass = Npc:GetClass("crosstimeroom_grassnpc")

function tbRoom3Grass:OnDialog()
  GeneralProcess:StartProcess("采集中...", 1 * Env.GAME_FPS, { self.DoPickUp, self, him.dwId, me.nId }, nil, tbEvent)
end

function tbRoom3Grass:DoPickUp(nNpcId, nPlayerId)
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    return 0
  end

  local pGame = CrossTimeRoom:GetGameObjByMapId(me.nMapId)
  if not pGame then
    return 0
  end
  local tbRoom = pGame.tbRoom[pGame.nCurrentRoomId]
  if not tbRoom then
    return 0
  end
  local pZixuan = KNpc.GetById(tbRoom.pBossZi and tbRoom.pBossZi.dwId or 0)
  if pZixuan then
    local _, x, y = pZixuan.GetWorldPos()
    me.CastSkill(CrossTimeRoom.nDamageSkillId, 1, x * 32, y * 32, 1)
    local nMaxLife = pZixuan.nMaxLife
    local nReduceLife = math.floor(nMaxLife * 0.2)
    pZixuan.ReduceLife(nReduceLife)
    if pZixuan.nCurLife <= 0 then
      me.KillNpc(pZixuan.dwId)
    end
  end
  pNpc.Delete()
end
