-- 文件名　：crosstimeroom_gs.lua
-- 创建者　：zhangjunjie
-- 创建时间：2011-08-01 15:22:28
-- 描述：时光屋gs

if not MODULE_GAMESERVER then
  return 0
end

Require("\\script\\boss\\crosstimeroom\\crosstimeroom_def.lua")

CrossTimeRoom.tbGameManager = {}
local tbGameManager = CrossTimeRoom.tbGameManager

function tbGameManager:InitManager()
  self.tbGame = {}
  self.tbMap = {}
  self.tbPlayer = {} --存储是谁开的副本
  self.nMapCount = 0
  self.nGameCount = 0
end

--gs根据server id申请fb
function tbGameManager:ApplyGame(nPlayerId, nServerId, nApplyMapId)
  if self.tbPlayer[nPlayerId] then
    return 0
  end
  for i = 1, self.nMapCount do
    if not self.tbGame[self.tbMap[i]] and self.tbMap[i] and self.tbMap[i] ~= 0 then
      self.tbPlayer[nPlayerId] = self.tbMap[i]
      self.tbMap[i] = self.tbMap[i]
      self.tbGame[self.tbMap[i]] = Lib:NewClass(CrossTimeRoom.tbBase)
      self.tbGame[self.tbMap[i]]:InitGame(self.tbMap[i], nServerId, nPlayerId)
      self.nGameCount = self.nGameCount + 1
      Map:RegisterMapForbidReviveType(self.tbMap[i], 0, 0, "当前地图禁止原地复活和技能复活")
      Map:RegisterMapForbidRemoteRevive(self.tbMap[i], 0, "当前地图暂时禁止回城疗伤")
      local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
      local szName = pPlayer and pPlayer.szName or ""
      GCExcute({ "CrossTimeRoom:SyncGameMapInfo_GC", nPlayerId, szName, nApplyMapId }) --同步申请信息到每个gs，保证一个队伍只开启一个副本
      if pPlayer then
        pPlayer.Msg("<color=yellow>你已成功开启了阴阳时光殿副本<color>，请叫上朋友，进入副本地图。")
        KTeam.Msg2Team(pPlayer.nTeamId, "队长已成功开启阴阳时光殿副本。")
        --CrossTimeRoom:AddTeamPlayerLockBuff(pPlayer);
      end
      return 1
    end
  end
  if self.nMapCount >= CrossTimeRoom.MAX_GAME then
    return 0
  end
  if Map:LoadDynMap(Map.DYNMAP_TREASUREMAP, CrossTimeRoom.nTemplateMapId, { self.OnLoadMapFinish, self, nPlayerId, nServerId, nApplyMapId }) == 1 then
    self.nMapCount = self.nMapCount + 1 -- 先占一个名额~不用等GC响应也能判断是否已经到达副本上限
    self.tbMap[self.nMapCount] = 0 -- 先标0防止其他副本使用本地图
    self.tbPlayer[nPlayerId] = 0
    return 1
  end
end

--地图加载完成后的回调
function tbGameManager:OnLoadMapFinish(nPlayerId, nServerId, nApplyMapId, nMapId)
  for nPlayerId, nIsFinishLoad in pairs(self.tbPlayer) do
    if nIsFinishLoad == 0 then
      for i = 1, #self.tbMap do
        if self.tbMap[i] == 0 then
          self.tbPlayer[nPlayerId] = nMapId
          self.tbMap[i] = nMapId
          self.tbGame[self.tbMap[i]] = Lib:NewClass(CrossTimeRoom.tbBase)
          self.tbGame[self.tbMap[i]]:InitGame(self.tbMap[i], nServerId, nPlayerId)
          self.nGameCount = self.nGameCount + 1
          Map:RegisterMapForbidReviveType(nMapId, 0, 0, "当前地图禁止原地复活和技能复活")
          Map:RegisterMapForbidRemoteRevive(nMapId, 0, "当前地图暂时禁止回城疗伤")
          local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
          local szName = pPlayer and pPlayer.szName or ""
          GCExcute({ "CrossTimeRoom:SyncGameMapInfo_GC", nPlayerId, szName, nApplyMapId }) --同步申请信息到每个gs，保证一个队伍只开启一个副本
          if pPlayer then
            pPlayer.Msg("<color=yellow>你已成功开启了阴阳时光殿副本<color>，请叫上朋友，进入副本地图。")
            KTeam.Msg2Team(pPlayer.nTeamId, "队长已成功开启阴阳时光殿副本。")
            --CrossTimeRoom:AddTeamPlayerLockBuff(pPlayer);
          end
          return 1
        end
      end
    end
  end
  return 0
end

function CrossTimeRoom:Init()
  self.tbManager = {}
end

if not CrossTimeRoom.tbManager then
  CrossTimeRoom:Init()
end

--通过地图id获取fb对象
function CrossTimeRoom:GetGameObjByMapId(nMapId)
  local tbManager = self.tbManager
  if tbManager[GetServerId()] and tbManager[GetServerId()].tbGame and tbManager[GetServerId()].tbGame[nMapId] then
    return tbManager[GetServerId()].tbGame[nMapId]
  end
end

--通过playerid 获取对象
function CrossTimeRoom:GetGameObjByPlayerId(nPlayerId)
  local tbManager = self.tbManager
  if tbManager[GetServerId()] and tbManager[GetServerId()].tbPlayer[nPlayerId] and tbManager[GetServerId()].tbGame and tbManager[GetServerId()].tbGame[tbManager[GetServerId()].tbPlayer[nPlayerId]] then
    return tbManager[GetServerId()].tbGame[tbManager[GetServerId()].tbPlayer[nPlayerId]]
  end
end

function CrossTimeRoom:GetGameObjByTeamId(nTeamId)
  if nTeamId <= 0 then
    return
  end
  local tbTeamList = KTeam.GetTeamMemberList(nTeamId)
  if not tbTeamList then
    return
  end
  for _, nPlayerId in pairs(tbTeamList) do
    local pGame = self:GetGameObjByPlayerId(nPlayerId)
    if pGame then
      return pGame
    end
  end
end

--刷报名npc
function CrossTimeRoom:AddApplyNpc_GS()
  --皇陵没有开放则不进行传送npc的刷出
  if TimeFrame:GetState("OpenBoss120") ~= 1 then
    return 0
  else
    local nOpenBoss120Week = Lib:GetLocalWeek(TimeFrame:GetTime("OpenBoss120"))
    local nNowWeek = Lib:GetLocalWeek(GetTime())
    if nNowWeek <= nOpenBoss120Week then
      return 0
    end
    if IsMapLoaded(CrossTimeRoom.nApplyNpcMapId) ~= 1 then
      return 0
    end
    local tbPos = CrossTimeRoom.tbApplyNpcPos
    self.pApplyNpc = KNpc.Add2(CrossTimeRoom.nApplyNpcTemplateId, 100, -1, CrossTimeRoom.nApplyNpcMapId, tbPos[1], tbPos[2])
    if self.nDeleteApplyNpcTimer and self.nDeleteApplyNpcTimer > 0 then
      Timer:Close(self.nDeleteApplyNpcTimer)
      self.nDeleteApplyNpcTimer = 0
    end
    local szMsg = "阴阳时光殿报名者在阿房宫废墟出现了！"
    KDialog.NewsMsg(1, Env.NEWSMSG_NORMAL, szMsg)
    KDialog.MsgToGlobal(szMsg)
    self.nDeleteApplyNpcTimer = Timer:Register(CrossTimeRoom.nCloseTransferNpcDelay * Env.GAME_FPS, self.DeleteApplyNpc, self)
  end
end

--删除报名npc
function CrossTimeRoom:DeleteApplyNpc()
  if self.pApplyNpc then
    self.pApplyNpc.Delete()
  end
  self.nDeleteApplyNpcTimer = 0
  local szMsg = "阴阳时光殿报名者离开了阿房宫废墟！"
  KDialog.NewsMsg(1, Env.NEWSMSG_NORMAL, szMsg)
  KDialog.MsgToGlobal(szMsg)
  return 0
end

--申请
function CrossTimeRoom:ApplyGame_GS(nPlayerId, nServerId, nApplyMapId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not self.tbManager[nServerId] then
    self.tbManager[nServerId] = Lib:NewClass(tbGameManager)
    self.tbManager[nServerId]:InitManager()
  end
  if self.tbGameMapInfo and self.tbGameMapInfo[nPlayerId] then --已经有申请过了
    return 0
  end
  local nRet = self.tbManager[nServerId]:ApplyGame(nPlayerId, nServerId, nApplyMapId)
  if nRet ~= 1 and pPlayer then
    --todo，通知申请失败，地图满了，请稍后再试
    pPlayer.Msg("当前副本地图都已经有侠士去挑战了，请稍后再来！")
    return 0
  end
end

--是否有申请过的副本存在
function CrossTimeRoom:IsAlreadyApply(nPlayerId)
  if not self.tbGameMapInfo then
    return 0
  end
  if self.tbGameMapInfo and self.tbGameMapInfo[nPlayerId] then
    return 1, self.tbGameMapInfo[nPlayerId]
  end
  return 0
end

--同步申请的信息，保证所有server一个队伍里只能申请一个
function CrossTimeRoom:SyncGameMapInfo_GS(nPlayerId, szName, nApplyMapId)
  if not self.tbGameMapInfo then
    self.tbGameMapInfo = {}
  end
  if not self.tbGameMapInfo[nPlayerId] then
    self.tbGameMapInfo[nPlayerId] = {}
  end
  self.tbGameMapInfo[nPlayerId].szName = szName
  self.tbGameMapInfo[nPlayerId].nApplyMapId = nApplyMapId
end

-- 关闭
function CrossTimeRoom:EndGame_GS(nPlayerId, nServerId, nMapId)
  if self.tbManager and self.tbManager[nServerId] and self.tbManager[nServerId].tbGame and self.tbManager[nServerId].tbGame[nMapId] then
    Map:UnRegisterMapForbidRemoteRevive(nMapId)
    Map:UnRegisterMapForbidReviveType(nMapId)
    self.tbManager[nServerId].tbGame[nMapId] = nil
    self.tbManager[nServerId].nGameCount = self.tbManager[nServerId].nGameCount - 1
    self.tbManager[nServerId].tbPlayer[nPlayerId] = nil
  end
  if self.tbGameMapInfo and self.tbGameMapInfo[nPlayerId] then
    self.tbGameMapInfo[nPlayerId] = nil
  end
end

function CrossTimeRoom:GetGameNum(nServerId)
  if not self.tbManager[nServerId] then
    return 0
  end
  return self.tbManager[nServerId].nGameCount
end

--加入游戏
function CrossTimeRoom:JoinGame()
  if me.GetTiredDegree1() == 2 then
    Dialog:Say("您太累了，还是休息下吧！")
    return
  end
  local nRet, szMsg = self:CheckCanJoin(me.nId)
  local pGame = self:GetGameObjByTeamId(me.nTeamId)
  if not pGame then
    return 0
  end
  if nRet ~= 1 then
    Dialog:Say(szMsg)
    return 0
  end
  pGame:JoinGame(me)
end

--是否能进入
function CrossTimeRoom:CheckCanJoin(nPlayerId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return 0
  end
  local nTeamId = pPlayer.nTeamId
  if nTeamId <= 0 then
    return 0, "请组队进入!"
  end
  local nRet, szMsg = self:CheckCondition(nPlayerId)
  if nRet ~= 1 then
    return 0, szMsg
  end
  local pGame = self:GetGameObjByTeamId(pPlayer.nTeamId)
  if not pGame then
    return 0, "你们队伍没有开启阴阳时光殿副本。"
  end
  --检查道具
  local bHasItem = self:CheckHaveJoinItem(pPlayer)
  if bHasItem ~= 1 and pGame:FindLogOutPlayer(pPlayer.nId) ~= 1 then --进入过的就不用再判断是不是有道具了
    return 0, "你身上没有令牌！"
  end
  local nPlayerNum = pGame:GetPlayerCount()
  if nPlayerNum >= CrossTimeRoom.MAX_PLAYER then
    return 0, "副本内人数已经达到上限！"
  end
  if not Task:GetPlayerTask(pPlayer).tbTasks[479] then
    return 0, "你未接取阴阳时光殿任务!"
  end
  if Task:GetPlayerTask(pPlayer).tbTasks[479].nCurStep ~= 2 then
    return 0, "你未接取阴阳时光殿指定的任务步骤!"
  end
  --	if pPlayer.GetSkillState(CrossTimeRoom.nLimitJoinHuanglingBuffId) <= 0 then
  --		if self:IsTimeCanApply() == 1 then
  --			return 1;
  --		else
  --			return 0,"    现在不是报名时间，无法进行报名！\n    <color=yellow>每天副本报名及开启时间为:15:25一15:35和22:25一22:35，该时间段以外玩家将无法报名或者进入副本。<color>";
  --		end
  --	end
  return 1
end

--是否开启检测
function CrossTimeRoom:CheckCondition(nPlayerId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return 0
  end
  local tbTeamList = KTeam.GetTeamMemberList(pPlayer.nTeamId)
  if not tbTeamList then
    return 0, "无法获得队伍信息！"
  end
  local tbGame = {}
  local nGameCount = 0
  for _, nPlayerId in pairs(tbTeamList) do
    if self:GetGameObjByPlayerId(nPlayerId) then
      tbGame[nPlayerId] = 1
      nGameCount = nGameCount + 1
    end
  end
  if nGameCount < 1 then
    local nGameNum = 0
    local szMap = ""
    for _, nPlayerId in pairs(tbTeamList) do
      if self.tbGameMapInfo and self.tbGameMapInfo[nPlayerId] then
        nGameNum = nGameNum + 1
      end
    end
    if nGameNum < 1 then
      return 0, "你的队伍没有开启副本，请队长前来开启副本！"
    end
    if nGameNum > 1 then
      local szName = ""
      for _, nPlayerId in pairs(tbTeamList) do
        if self.tbGameMapInfo and self.tbGameMapInfo[nPlayerId] then
          szName = szName .. self.tbGameMapInfo[nId].szName .. "\n"
        end
      end
      return 0, string.format("你的队伍有不同玩家开启了副本！开启副本的玩家为：\n", szName)
    end
    if nGameNum == 1 then
      local szMap = ""
      for _, nPlayerId in pairs(tbTeamList) do
        if self.tbGameMapInfo and self.tbGameMapInfo[nPlayerId] then
          szMap = szMap .. GetMapNameFormId(self.tbGameMapInfo[nPlayerId].nApplyMapId)
          break
        end
      end
      return 0, string.format("你的队伍在%s开启了副本！请前往该地进入！", szMap)
    end
  end
  if nGameCount > 1 then
    local szMsg = "你的队伍中有超过两人开启过副本了,一个队伍只能开启一个副本！已经开启副本的玩家为：\n"
    local szName = ""
    for nId, _ in pairs(tbGame) do
      if self.tbGameMapInfo and self.tbGameMapInfo[nId] then
        szName = szName .. self.tbGameMapInfo[nId].szName .. "\n"
      end
    end
    szMsg = szMsg .. szName
    return 0, szMsg
  end
  return 1
end

--是否是申请时间
function CrossTimeRoom:IsTimeCanApply()
  local nTime = tonumber(os.date("%H%M", GetTime()))
  if nTime >= CrossTimeRoom.nBeginTransferTimeDay and nTime < CrossTimeRoom.nEndTransferTimeDay then
    return 1
  elseif nTime >= CrossTimeRoom.nBeginTransferTimeNight and nTime < CrossTimeRoom.nEndTransferTimeNight then
    return 1
  else
    return 0
  end
end

--是否能申请fb
function CrossTimeRoom:CheckCanApply(nPlayerId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return 0
  end
  local tbTeamList = KTeam.GetTeamMemberList(pPlayer.nTeamId)
  if not tbTeamList then
    return 0, "无法获得队伍信息！"
  end
  --	if self:IsTimeCanApply() ~= 1 then
  --		return 0,"    现在不是报名时间，无法进行报名！\n    <color=yellow>每天副本报名及开启时间为:15:25一15:35和22:25一22:35，该时间段以外玩家将无法报名或者进入副本。<color>";
  --	end
  local tbGame = {}
  local nGameCount = 0
  for _, nPlayerId in pairs(tbTeamList) do
    if self:GetGameObjByPlayerId(nPlayerId) then
      tbGame[nPlayerId] = 1
      nGameCount = nGameCount + 1
    end
  end
  if nGameCount < 1 then
    local nGameNum = 0
    local szMap = ""
    for _, nPlayerId in pairs(tbTeamList) do
      if self.tbGameMapInfo and self.tbGameMapInfo[nPlayerId] then
        nGameNum = nGameNum + 1
      end
    end
    if nGameNum > 1 then
      local szName = ""
      for _, nPlayerId in pairs(tbTeamList) do
        if self.tbGameMapInfo and self.tbGameMapInfo[nPlayerId] then
          szName = szName .. self.tbGameMapInfo[nId].szName .. "\n"
        end
      end
      return 0, string.format("你的队伍有不同玩家开启了副本！开启副本的玩家为：\n", szName)
    end
    if nGameNum == 1 then
      local szMap = ""
      for _, nPlayerId in pairs(tbTeamList) do
        if self.tbGameMapInfo and self.tbGameMapInfo[nPlayerId] then
          szMap = szMap .. GetMapNameFormId(self.tbGameMapInfo[nPlayerId].nApplyMapId)
          break
        end
      end
      return 0, string.format("你的队伍在%s开启了副本！请前往并进入!", szMap)
    end
  end
  if nGameCount > 1 then
    local szMsg = "你的队伍中有超过两人开启过副本了,一个队伍只能开启一个副本！已经开启副本的玩家为：\n"
    local szName = ""
    for nId, _ in pairs(tbGame) do
      if self.tbGameMapInfo and self.tbGameMapInfo[nId] then
        szName = szName .. self.tbGameMapInfo[nId].szName .. "\n"
      end
    end
    szMsg = szMsg .. szName
    return 0, szMsg
  end
  if not Task:GetPlayerTask(pPlayer).tbTasks[479] then
    return 0, "你未接取阴阳时光殿任务!"
  end
  if Task:GetPlayerTask(pPlayer).tbTasks[479].nCurStep ~= 2 then
    return 0, "你未接取阴阳时光殿指定的任务步骤!"
  end
  return 1
end

--检测是否有道具
function CrossTimeRoom:CheckHaveJoinItem(pPlayer)
  if not pPlayer then
    return 0
  end
  local tbFind = pPlayer.FindItemInBags(unpack(CrossTimeRoom.ENTER_ITEM_GDPL))
  if #tbFind < 1 then
    return 0
  end
  return 1
end

--打开宝箱，给与奖励
function CrossTimeRoom:GiveReward(nRoom, tbBase, dwBoxId)
  if nRoom == 0 then
    return
  end
  local pBox = KNpc.GetById(dwBoxId)
  if not pBox then
    return
  end
  if not tbBase then
    return
  end

  local tbAroundPlayers = KNpc.GetAroundPlayerList(dwBoxId, 32)
  local tbPlayer = tbBase:GetPlayerList()
  if #tbAroundPlayers ~= #tbPlayer then
    Dialog:Say("必须所有队员都附近才能开启！")
    return
  end
  local _, nTeamCount = KTeam.GetTeamMemberList(me.nTeamId)
  if nTeamCount < #tbPlayer then
    Dialog:Say("你没有队伍或者副本内有人不在你的队伍中！")
    return
  end
  for _, pPlayer in pairs(tbAroundPlayers) do
    if pPlayer.nTeamId ~= me.nTeamId then
      Dialog:Say("副本内有人不在你的队伍中！")
      return
    end
  end
  local nPlayerCount = #tbPlayer
  local szFile = self.tbDropItemFile[nPlayerCount]
  local tbInfo = self.tbDropCount[nRoom]
  local nCount = tbInfo[1]

  if szFile and nCount then
    pBox.DropRateItem(szFile, nCount, 0, -1, me.nId)
  end
  if tbInfo[2] then
    local nExCount = tbInfo[2][nPlayerCount]
    local szExFile = self.tbDropItemExFile
    if szExFile and nExCount then
      pBox.DropRateItem(szExFile, nExCount, 0, -1, me.nId)
    end
  end
  for _, pPlayer in pairs(tbPlayer) do
    pPlayer.AddExperience(self.tbExpTable[nPlayerCount][nRoom])
  end

  pBox.Delete()
end

--刷宝箱
function CrossTimeRoom:AddChest(nRoom, tbBase)
  local tbPlayer = tbBase:GetPlayerList()
  local pNpc = KNpc.Add2(CrossTimeRoom.nCheastTemplateId[#tbPlayer], 1, -1, tbBase.nMapId, CrossTimeRoom.tbChestPos[nRoom][1], CrossTimeRoom.tbChestPos[nRoom][2])
  if pNpc then
    local tbData = pNpc.GetTempTable("Npc")
    tbData.nRoom = nRoom
    tbData.tbBase = tbBase
    Npc:RegDeathLoseItem(pNpc, tbBase.OnBossDrop, tbBase) --掉落回调
    for _, pPlayer in pairs(tbPlayer) do
      pPlayer.Msg(self.tbBoxTxt[#tbPlayer])
    end
  end
end

--扣玩家道具
function CrossTimeRoom:ConsumePlayerItem(pPlayer)
  if not pPlayer then
    return 0
  end
  local tbFind = pPlayer.FindItemInBags(unpack(CrossTimeRoom.ENTER_ITEM_GDPL))
  if #tbFind < 1 then
    return 0
  end
  if #tbFind > 0 then
    pPlayer.ConsumeItemInBags(1, unpack(CrossTimeRoom.ENTER_ITEM_GDPL))
    StatLog:WriteStatLog("stat_info", "yinyangshiguangdian", "enter", pPlayer.nId, 1) --数据埋点
    return 1
  end
end

--给玩家加buff
function CrossTimeRoom:AddPlayerLockBuff(pPlayer)
  if not pPlayer then
    return 0
  end
  local nTime = tonumber(os.date("%H%M", GetTime()))
  local nSec = 45 * 60
  if nTime >= CrossTimeRoom.nBeginTransferTimeDay and nTime < CrossTimeRoom.nDelteTransferNpcTimeDay then
    local nTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
    local nNewTime = tonumber(os.date("%Y%m%d0000", GetTime())) + CrossTimeRoom.nDelteTransferNpcTimeDay
    nSec = Lib:GetDate2Time(nNewTime) - Lib:GetDate2Time(nTime)
  elseif nTime >= CrossTimeRoom.nBeginTransferTimeNight and nTime < CrossTimeRoom.nDelteTransferNpcTimeNight then
    local nTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
    local nNewTime = tonumber(os.date("%Y%m%d0000", GetTime())) + CrossTimeRoom.nDelteTransferNpcTimeNight
    nSec = Lib:GetDate2Time(nNewTime) - Lib:GetDate2Time(nTime)
  end
  pPlayer.AddSkillState(CrossTimeRoom.nLimitJoinHuanglingBuffId, 1, 2, nSec * Env.GAME_FPS, 1, 0, 1)
end

--给队伍玩家加buff
function CrossTimeRoom:AddTeamPlayerLockBuff(pPlayer)
  if not pPlayer then
    return 0
  end
  if pPlayer.nTeamId <= 0 then
    return 0
  end
  local tbMemberId, nCount = KTeam.GetTeamMemberList(pPlayer.nTeamId)
  for _, nPlayerId in pairs(tbMemberId) do
    local pMember = KPlayer.GetPlayerObjById(nPlayerId)
    if pMember then
      self:AddPlayerLockBuff(pMember)
    end
  end
  return 1
end

function CrossTimeRoom:GetCrossTimeRoomOpenState()
  local nOpenBoss120Week = Lib:GetLocalWeek(TimeFrame:GetTime("OpenBoss120"))
  local nNowWeek = Lib:GetLocalWeek(GetTime())
  if KGblTask.SCGetDbTaskInt(DBTASK_CROSSTIMEROOM_CLOSESTATE) ~= 0 then
    return 0
  end
  if TimeFrame:GetState("OpenBoss120") ~= 1 then
    return 0
  end
  if nNowWeek <= nOpenBoss120Week then
    return 0
  end
  return 1
end

--给予每周的时光屋令牌
function CrossTimeRoom:GiveCrossTimeRoomItem()
  local szMsg = string.format("    如果你的家族威望排行达到了前<color=yellow>%d<color>名，并且你的江湖威望排名达到了前<color=yellow>%d<color>名，每周星期二中午12点之后，我可以给你发放<color=yellow>%d<color>个进入阴阳时光殿的令牌，不过要在服务器开放皇陵后的第二周才可以进行发放。(<color=yellow>请在当周之内领取令牌<color>)", CrossTimeRoom.nGetJoinItemBaseKinLevel, CrossTimeRoom.nGetJoinItemBasePlayerLevel, CrossTimeRoom.nEnterItemNum)
  local tbOpt = {}
  tbOpt[#tbOpt + 1] = { "确定领取", self.OnGiveCrossTimeRoomEnterItem, self }
  tbOpt[#tbOpt + 1] = { "我再想一想" }
  Dialog:Say(szMsg, tbOpt)
  return 1
end

function CrossTimeRoom:OnGiveCrossTimeRoomEnterItem()
  local nOpenBoss120Week = Lib:GetLocalWeek(TimeFrame:GetTime("OpenBoss120"))
  local nNowWeek = Lib:GetLocalWeek(GetTime())
  if TimeFrame:GetState("OpenBoss120") ~= 1 then
    Dialog:MsgBox("对不起，你们服务器还未开放皇陵，所以无法进行阴阳时光殿令牌的领取！")
    return 0
  end
  if nNowWeek <= nOpenBoss120Week then
    Dialog:MsgBox("对不起，要在皇陵开放后的第二周才能进行阴阳时光殿令牌的领取！")
    return 0
  end
  local nKinId, nMemberId = me.GetKinMember()
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    Dialog:MsgBox("对不起，你还没有家族，等你有了家族再来找我吧！")
    return 0
  end
  local nTimeSec = GetTime()
  local nWeek = tonumber(os.date("%w", nTimeSec))
  nWeek = (nWeek == 0 and 7 or nWeek)
  local nTime = nWeek * 10000 + tonumber(os.date("%H%M", nTimeSec))
  if nTime < CrossTimeRoom.nGetEnterItemLimitTime then
    Dialog:MsgBox("对不起，现在还没有到领取令牌的时间，请在每周星期二中午12点后前来领取！")
    return 0
  end
  local nKinRank = HomeLand:GetKinRank(nKinId)
  if nKinRank <= 0 or nKinRank > CrossTimeRoom.nGetJoinItemBaseKinLevel then
    Dialog:MsgBox("对不起，你的家族威望排行未达到领取阴阳时光殿令牌的条件，无法进行领取！")
    return 0
  end
  local nPlayerRank = GetPlayerHonorRank(me.nId, 11, 0, 0) --获取个人江湖威望排行
  if nPlayerRank <= 0 or nPlayerRank > CrossTimeRoom.nGetJoinItemBasePlayerLevel then
    Dialog:MsgBox("对不起，你江湖威望排行未达到领取阴阳时光殿令牌的条件，无法进行领取！")
    return 0
  end
  local nLastGetTime = Lib:GetLocalWeek(me.GetTask(CrossTimeRoom.nTaskGroupId, CrossTimeRoom.nTaskGetItemTime))
  local nNowWeekTime = Lib:GetLocalWeek(GetTime())
  if nLastGetTime == nNowWeekTime then
    Dialog:MsgBox("对不起，本周你已经领取过阴阳时光殿令牌了，请下周再来领取！")
    return 0
  end
  if me.CountFreeBagCell() < CrossTimeRoom.nEnterItemNum then
    local szMsg = "背包空间不足，无法进行领取！"
    Dialog:MsgBox(szMsg)
    return 0
  end
  local tbItemGdpl = CrossTimeRoom.ENTER_ITEM_GDPL
  local nRemainWeekDay = 7 - (tonumber(os.date("%w", nTimeSec)) == 0 and 7 or tonumber(os.date("%w", nTimeSec)))
  local nRemainDayTime = Lib:GetDate2Time(tonumber(os.date("%Y%m%d", GetTime()))) + 3600 * 24 * (nRemainWeekDay + 1)
  for i = 1, CrossTimeRoom.nEnterItemNum do
    local pItem = me.AddItem(unpack(tbItemGdpl))
    if not pItem then
      Dbg:WriteLog("CrossTimeRoom", "Give Enter Item failed", me.szName)
    else
      pItem.SetTimeOut(0, nRemainDayTime)
      pItem.Sync()
    end
  end
  local szKinName = cKin.GetName()
  StatLog:WriteStatLog("stat_info", "yinyangshiguangdian", "get", me.nId, szKinName, 2) --数据埋点
  me.SetTask(CrossTimeRoom.nTaskGroupId, CrossTimeRoom.nTaskGetItemTime, GetTime())
  return 1
end

--每周清除任务，并将次数清零
function CrossTimeRoom:PlayerWeekEvent()
  me.SetTask(CrossTimeRoom.nTaskGroupId, CrossTimeRoom.nTaskGetCount, 0)
  Task:CloseTask(479, "failed")
end

PlayerSchemeEvent:RegisterGlobalWeekEvent({ CrossTimeRoom.PlayerWeekEvent, CrossTimeRoom })
