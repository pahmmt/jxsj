-- 文件名　：chenchongzhen_gs.lua
-- 创建者　：zhangjunjie
-- 创建时间：2012-02-20 14:37:34
-- 描述：gs

if not MODULE_GAMESERVER then
  return 0
end

Require("\\script\\boss\\chenchongzhen\\chenchongzhen_def.lua")

ChenChongZhen.tbGameManager = {}
local tbGameManager = ChenChongZhen.tbGameManager

function tbGameManager:InitManager()
  self.tbGame = {}
  self.tbMap = {}
  self.tbPlayer = {} --存储是谁开的副本
  self.tbMap_Time = {}
  self.nMapCount = 0
  self.nGameCount = 0
end

--gs根据server id申请fb
function tbGameManager:ApplyGame(nPlayerId, nServerId, nApplyMapId)
  self:ClearOutData(self.nMapCount) --申请超时删除
  if self.tbPlayer[nPlayerId] then
    return 0
  end
  for i = 1, self.nMapCount do
    if not self.tbGame[self.tbMap[i]] and self.tbMap[i] and self.tbMap[i] ~= 0 then
      self.tbPlayer[nPlayerId] = self.tbMap[i]
      self.tbMap[i] = self.tbMap[i]
      self.tbGame[self.tbMap[i]] = Lib:NewClass(ChenChongZhen.tbBase)
      self.tbGame[self.tbMap[i]]:InitGame(self.tbMap[i], nServerId, nPlayerId)
      self.nGameCount = self.nGameCount + 1
      Map:RegisterMapForbidReviveType(self.tbMap[i], 0, 0, "当前地图禁止原地复活和技能复活")
      Map:RegisterMapForbidRemoteRevive(self.tbMap[i], 0, "当前地图暂时禁止回城疗伤")
      local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
      local szName = pPlayer and pPlayer.szName or ""
      GCExcute({ "ChenChongZhen:SyncGameMapInfo_GC", nPlayerId, szName, nApplyMapId }) --同步申请信息到每个gs，保证一个队伍只开启一个副本
      if pPlayer then
        pPlayer.Msg("<color=yellow>你已成功开启了辰虫镇副本<color>，请叫上朋友，进入副本地图。")
        KTeam.Msg2Team(pPlayer.nTeamId, "队长已成功开启辰虫镇副本。")
      end
      return 1
    end
  end
  if self.nMapCount >= ChenChongZhen.MAX_GAME then
    return 0
  end
  if Map:LoadDynMap(Map.DYNMAP_TREASUREMAP, ChenChongZhen.nTemplateMapId, { self.OnLoadMapFinish, self, nPlayerId, nServerId, nApplyMapId }) == 1 then
    self.nMapCount = self.nMapCount + 1 -- 先占一个名额~不用等GC响应也能判断是否已经到达副本上限
    self.tbMap[self.nMapCount] = 0 -- 先标0防止其他副本使用本地图
    self.tbPlayer[nPlayerId] = 0
    self.tbMap_Time[self.nMapCount] = { nPlayerId, GetTime() }
    return 1
  end
end

function tbGameManager:ClearOutData(nIdx)
  local nNowTime = GetTime()
  for j = nIdx, 1, -1 do
    if self.tbMap[j] == 0 and self.tbMap_Time then
      local tbInfo = self.tbMap_Time[j]
      if tbInfo and nNowTime - tbInfo[2] >= 600 then
        table.remove(self.tbMap, j)
        self.tbPlayer[tbInfo[1]] = nil
        self.tbMap_Time[j] = nil
        self.nMapCount = self.nMapCount - 1
      end
    end
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
          self.tbGame[self.tbMap[i]] = Lib:NewClass(ChenChongZhen.tbBase)
          self.tbGame[self.tbMap[i]]:InitGame(self.tbMap[i], nServerId, nPlayerId)
          self.nGameCount = self.nGameCount + 1
          Map:RegisterMapForbidReviveType(nMapId, 0, 0, "当前地图禁止原地复活和技能复活")
          Map:RegisterMapForbidRemoteRevive(nMapId, 0, "当前地图暂时禁止回城疗伤")
          local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
          local szName = pPlayer and pPlayer.szName or ""
          GCExcute({ "ChenChongZhen:SyncGameMapInfo_GC", nPlayerId, szName, nApplyMapId }) --同步申请信息到每个gs，保证一个队伍只开启一个副本
          if pPlayer then
            pPlayer.Msg("<color=yellow>你已成功开启了辰虫镇副本<color>，请叫上朋友，进入副本地图。")
            KTeam.Msg2Team(pPlayer.nTeamId, "队长已成功开启辰虫镇副本。")
          end
          return 1
        end
      end
    end
  end
  return 0
end

function ChenChongZhen:Init()
  self.tbManager = {}
end

if not ChenChongZhen.tbManager then
  ChenChongZhen:Init()
end

--通过地图id获取fb对象
function ChenChongZhen:GetGameObjByMapId(nMapId)
  local tbManager = self.tbManager
  if tbManager[GetServerId()] and tbManager[GetServerId()].tbGame and tbManager[GetServerId()].tbGame[nMapId] then
    return tbManager[GetServerId()].tbGame[nMapId]
  end
end

--通过playerid 获取对象
function ChenChongZhen:GetGameObjByPlayerId(nPlayerId)
  local tbManager = self.tbManager
  if tbManager[GetServerId()] and tbManager[GetServerId()].tbPlayer[nPlayerId] and tbManager[GetServerId()].tbGame and tbManager[GetServerId()].tbGame[tbManager[GetServerId()].tbPlayer[nPlayerId]] then
    return tbManager[GetServerId()].tbGame[tbManager[GetServerId()].tbPlayer[nPlayerId]]
  end
end

function ChenChongZhen:GetGameObjByTeamId(nTeamId)
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

--申请
function ChenChongZhen:ApplyGame_GS(nPlayerId, nServerId, nApplyMapId)
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
function ChenChongZhen:IsAlreadyApply(nPlayerId)
  if not self.tbGameMapInfo then
    return 0
  end
  if self.tbGameMapInfo and self.tbGameMapInfo[nPlayerId] then
    return 1, self.tbGameMapInfo[nPlayerId]
  end
  return 0
end

--同步申请的信息，保证所有server一个队伍里只能申请一个
function ChenChongZhen:SyncGameMapInfo_GS(nPlayerId, szName, nApplyMapId)
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
function ChenChongZhen:EndGame_GS(nPlayerId, nServerId, nMapId)
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

function ChenChongZhen:GetGameNum(nServerId)
  if not self.tbManager[nServerId] then
    return 0
  end
  return self.tbManager[nServerId].nGameCount
end

--加入游戏
function ChenChongZhen:JoinGame()
  if me.GetTiredDegree1() == 2 then
    Dialog:Say("您太累了，还是休息下吧！")
    return
  end
  local nRet, szMsg = self:CheckCanJoin()
  if nRet ~= 1 then
    Dialog:Say(szMsg)
    return 0
  end
  local pGame = self:GetGameObjByTeamId(me.nTeamId)
  if not pGame then
    return 0
  end
  pGame:JoinGame(me)
end

function ChenChongZhen:CheckCanJoin()
  local nTeamId = me.nTeamId
  if nTeamId <= 0 then
    return 0, "请组队进入!"
  end
  local nRet, szMsg = self:CheckCondition()
  if nRet ~= 1 then
    return 0, szMsg
  end
  local pGame = self:GetGameObjByTeamId(me.nTeamId)
  if not pGame then
    return 0, "你们队伍没有开启辰虫镇副本。"
  end
  --检查道具
  local bHasItem = self:CheckHaveJoinItem(me)
  if bHasItem ~= 1 and pGame:FindLogOutPlayer(me.nId) ~= 1 then --进入过的就不用再判断是不是有道具了
    return 0, "你身上没有令牌！"
  end
  local nPlayerNum = pGame:GetPlayerCount()
  if nPlayerNum >= ChenChongZhen.MAX_PLAYER then
    return 0, "副本内人数已经达到上限！"
  end
  if not Task:GetPlayerTask(me).tbTasks[ChenChongZhen.nHaveTaskId] then
    return 0, "你未接取辰虫镇任务!"
  end
  if Task:GetPlayerTask(me).tbTasks[ChenChongZhen.nHaveTaskId].nCurStep ~= ChenChongZhen.nTaskNeedStep then
    return 0, "你未接取辰虫镇指定的任务步骤!"
  end
  return 1
end

function ChenChongZhen:CheckCondition()
  local tbTeamList = KTeam.GetTeamMemberList(me.nTeamId)
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

function ChenChongZhen:CheckCanApply()
  local tbTeamList = KTeam.GetTeamMemberList(me.nTeamId)
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
  if not Task:GetPlayerTask(me).tbTasks[ChenChongZhen.nHaveTaskId] then
    return 0, "你未接取辰虫镇任务!"
  end
  if Task:GetPlayerTask(me).tbTasks[ChenChongZhen.nHaveTaskId].nCurStep ~= ChenChongZhen.nTaskNeedStep then
    return 0, "你未接取辰虫镇指定的任务步骤!"
  end
  return 1
end

function ChenChongZhen:CheckHaveJoinItem(pPlayer)
  if not pPlayer then
    return 0
  end
  local tbFind = pPlayer.FindItemInBags(unpack(self.ENTER_ITEM_GDPL))
  if #tbFind < 1 then
    return 0
  end
  return 1
end

--扣玩家道具
function ChenChongZhen:ConsumePlayerItem(pPlayer)
  if not pPlayer then
    return 0
  end
  local tbFind = pPlayer.FindItemInBags(unpack(ChenChongZhen.ENTER_ITEM_GDPL))
  if #tbFind < 1 then
    return 0
  end
  if #tbFind > 0 then
    pPlayer.ConsumeItemInBags(1, unpack(ChenChongZhen.ENTER_ITEM_GDPL))
    StatLog:WriteStatLog("stat_info", "chenchongzhen", "enter", pPlayer.nId, 1) --数据埋点
    return 1
  end
end

--给予每周的令牌
function ChenChongZhen:GiveChenChongZhenItem()
  local szMsg = string.format("    如果你的家族威望排行达到了前<color=yellow>%d<color>名，并且你的江湖威望排名达到了前<color=yellow>%d<color>名，每周星期二中午12点之后，我可以给你发放<color=yellow>%d<color>个进入辰虫镇的令牌，不过要在服务器开放皇陵后的第二周才可以进行发放。(<color=yellow>请在当周之内领取令牌<color>)", ChenChongZhen.nGetJoinItemBaseKinLevel, ChenChongZhen.nGetJoinItemBasePlayerLevel, ChenChongZhen.nEnterItemNum)
  local tbOpt = {}
  tbOpt[#tbOpt + 1] = { "确定领取", self.OnGiveChenChongZhenEnterItem, self }
  tbOpt[#tbOpt + 1] = { "我再想一想" }
  Dialog:Say(szMsg, tbOpt)
  return 1
end

function ChenChongZhen:OnGiveChenChongZhenEnterItem()
  local nOpenBoss120Week = Lib:GetLocalWeek(TimeFrame:GetTime("OpenBoss120"))
  local nNowWeek = Lib:GetLocalWeek(GetTime())
  if TimeFrame:GetState("OpenBoss120") ~= 1 then
    Dialog:MsgBox("对不起，你们服务器还未开放皇陵，所以无法进行辰虫镇令牌的领取！")
    return 0
  end
  if nNowWeek <= nOpenBoss120Week then
    Dialog:MsgBox("对不起，要在皇陵开放后的第二周才能进行辰虫镇令牌的领取！")
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
  if nTime < ChenChongZhen.nGetEnterItemLimitTime then
    Dialog:MsgBox("对不起，现在还没有到领取令牌的时间，请在每周星期二中午12点后前来领取！")
    return 0
  end
  local nKinRank = HomeLand:GetKinRank(nKinId)
  if nKinRank <= 0 or nKinRank > ChenChongZhen.nGetJoinItemBaseKinLevel then
    Dialog:MsgBox("对不起，你的家族威望排行未达到领取辰虫镇令牌的条件，无法进行领取！")
    return 0
  end
  local nPlayerRank = GetPlayerHonorRank(me.nId, 11, 0, 0) --获取个人江湖威望排行
  if nPlayerRank <= 0 or nPlayerRank > ChenChongZhen.nGetJoinItemBasePlayerLevel then
    Dialog:MsgBox("对不起，你江湖威望排行未达到领取辰虫镇令牌的条件，无法进行领取！")
    return 0
  end
  local nLastGetTime = Lib:GetLocalWeek(me.GetTask(ChenChongZhen.nTaskGroupId, ChenChongZhen.nTaskGetItemTime))
  local nNowWeekTime = Lib:GetLocalWeek(GetTime())
  if nLastGetTime == nNowWeekTime then
    Dialog:MsgBox("对不起，本周你已经领取过辰虫镇令牌了，请下周再来领取！")
    return 0
  end
  if me.CountFreeBagCell() < ChenChongZhen.nEnterItemNum then
    local szMsg = "背包空间不足，无法进行领取！"
    Dialog:MsgBox(szMsg)
    return 0
  end
  local tbItemGdpl = ChenChongZhen.ENTER_ITEM_GDPL
  local nRemainWeekDay = 7 - (tonumber(os.date("%w", nTimeSec)) == 0 and 7 or tonumber(os.date("%w", nTimeSec)))
  local nRemainDayTime = Lib:GetDate2Time(tonumber(os.date("%Y%m%d", GetTime()))) + 3600 * 24 * (nRemainWeekDay + 1)
  for i = 1, ChenChongZhen.nEnterItemNum do
    local pItem = me.AddItemEx(tbItemGdpl[1], tbItemGdpl[2], tbItemGdpl[3], tbItemGdpl[4], nil, nil, nRemainDayTime)
    if not pItem then
      Dbg:WriteLog("ChenChongZhen", "Give Enter Item failed", me.szName)
    end
  end
  local szKinName = cKin.GetName()
  StatLog:WriteStatLog("stat_info", "chenchongzhen", "get", me.nId, szKinName, 2) --数据埋点
  me.SetTask(ChenChongZhen.nTaskGroupId, ChenChongZhen.nTaskGetItemTime, GetTime())
  return 1
end
