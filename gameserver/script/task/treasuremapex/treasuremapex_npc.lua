-- 文件名　：treasuremapEx_npc.lua
-- 创建者　：LQY
-- 创建时间：2012-11-03 18:19:11
-- 说　　明：藏宝图NPC逻辑

if not MODULE_GAMESERVER then
  return
end
Require("\\script\\task\\treasuremapex\\treasuremapex_def.lua")
Require("\\script\\task\\treasuremap2\\treasuremap2_def.lua")
local TreasureMapEx = TreasureMap.TreasureMapEx

function TreasureMapEx:ApplyTreasureMap(szMapTypeName, nNpcId, nOpenStar)
  local nStar, szMsg = self:GetTeamStar(me.nId)
  if nStar == -1 then
    Dialog:MsgBox(szMsg)
    return
  end
  local tbMaps, nCount = self:Star2Maps(nStar)
  if not tbMaps then
    Dialog:MsgBox("没有适合你们的藏宝图，开启失败！")
    return 0
  end
  local IsRandMap = 0 --是否为随机副本
  if not szMapTypeName then --随机副本
    if #tbMaps[nStar] <= 0 then
      Dialog:MsgBox("可用副本数量太少，不能进行随机！")
      return 0
    end
    szMapTypeName = tbMaps[nStar][MathRandom(1, #tbMaps[nStar])].TypeName
    IsRandMap = 1
    nOpenStar = nStar
  end
  if not self.tbMapInfo[szMapTypeName] then
    Dialog:MsgBox("该藏宝图不适合你们的队伍，开启失败！")
    return 0
  end
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    return
  end
  local nCityMapId = pNpc.GetWorldPos()
  if me.nTeamId <= 0 or me.IsCaptain() == 0 then
    Dialog:MsgBox(string.format("你必须组队并且是队长，才能开启藏宝图副本。"))
    return 0
  end
  TreasureMap2:GetMapTempletList()
  local tbTeamList = KTeam.GetTeamMemberList(me.nTeamId)

  if TreasureMap2.MapTempletList.nCount >= TreasureMap2.INSTANCE_LIMIT then
    Dialog:MsgBox("多位英雄已于此地秘境修炼，这位侠士烦请稍候片刻。")
    return 0
  end
  nOpenStar = nOpenStar or nStar
  self:ApplyTreasureLevel(szMapTypeName, nOpenStar, nNpcId, IsRandMap)
end

function TreasureMapEx:ApplyTreasureLevel(szMapTypeName, nStar, nNpcId, IsRandMap)
  if me.nTeamId <= 0 then
    Dialog:MsgBox("副本路途险恶，必须组队才能进入。")
  end

  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    return
  end

  local nCityMapId = pNpc.GetWorldPos()

  local tbTeamList = KTeam.GetTeamMemberList(me.nTeamId)
  if not tbTeamList then
    return
  end

  local bAllRight = 1
  local tbOpt = {}
  local szMsg = "以下队友不符合条件\n"
  for nId, nPlayerId in ipairs(tbTeamList) do
    local nRes, szRes = self:CheckPlayer(nPlayerId, nCityMapId, nStar)
    if nRes ~= 1 then
      bAllRight = 0
      szMsg = szMsg .. "<color=yellow>" .. KGCPlayer.GetPlayerName(nPlayerId) .. "<color> <color=red>" .. szRes .. "<color> \n"
    end
    if nRes == -1 then
      local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
      if pPlayer then
        Dialog:SendBlackBoardMsg(pPlayer, "每天上线系统会自动发放当日藏宝图次数。")
      end
    end
  end
  if bAllRight == 0 then
    --szMsg = szMsg .. "按<color=yellow>K<color>键打开重要活动推荐领取藏宝图次数。每周可领取两次通用藏宝图次数，每日可领取1次（50级以下玩家每日可领取2次）藏宝图次数。";
    table.insert(tbOpt, { "返回上层", self.OnDialog, self, IsRandMap == 1 and 1 or 2 })
    table.insert(tbOpt, { "我再想想" })
    Dialog:MsgBox(szMsg)
    return
  end

  local nTreasureId = self.tbType2Id[szMapTypeName]
  if not nTreasureId then
    return 0
  end
  if self:Id2MapInfo(nTreasureId).nClosed == 1 then
    return 0
  end
  local szRand = IsRandMap == 1 and "(随机)" or ""
  if TreasureMap2:CreateInstancing(me, nTreasureId, nStar, nCityMapId, IsRandMap) == 1 then
    self:ConsumePlayerCount(me)
    TreasureMap2:AddPlayerTimes(me)
    me.Msg(string.format("<color=yellow>成功开启%s副本%d星难度%s<color>，请叫上朋友，进入副本地图。", self:Id2MapInfo(nTreasureId).szName, nStar, szRand))
    KTeam.Msg2Team(me.nTeamId, string.format("队长已成功开启%s副本%d星难度%s。", self:Id2MapInfo(nTreasureId).szName, nStar, szRand))
    self:UpdatePlayersInfo()
    return 0
  else
    Dialog:MsgBox("已有多位勇士在此副本中奋战,请到其他地图申请,或稍后再试。")
  end
end
--同步信息到队友
function TreasureMapEx:UpdatePlayersInfo(nType)
  if not nType then
    Timer:Register(18, self.UpdatePlayersInfo, self, 1)
    return
  end
  if me.nTeamId <= 0 then
    return
  end
  local tbTeamList = KTeam.GetTeamMemberList(me.nTeamId)
  for _, nPlayerId in pairs(tbTeamList) do
    local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
    if pPlayer then
      self:ApplyTreasuremapInfo(pPlayer)
    end
  end
  return 0
end

--NPC对话
function TreasureMapEx:OnDialog(nType)
  if self.IsOpen == 0 then
    Dialog:Say("藏宝图系统异常。请联系GM。")
    return 0
  end
  local szMsgTilte = "本官可带你们挑战各藏宝图地图。\n"
  if me.nTeamId <= 0 then
    Dialog:Say(string.format("%s你<color=yellow>必须组队<color>并且是<color=yellow>队长<color>，才能开启藏宝图副本。", szMsgTilte))
    return 0
  end
  TreasureMap2:GetMapTempletList()
  local tbTeamList = KTeam.GetTeamMemberList(me.nTeamId)
  local tbOpenMap = {}
  for nId, nPlayerId in ipairs(tbTeamList) do
    if TreasureMap2.MapTempletList.tbBelongList[nPlayerId] then
      table.insert(tbOpenMap, { nId, KGCPlayer.GetPlayerName(nPlayerId) })
    end
  end
  if #tbOpenMap >= 2 then
    local szPlayerMsg = ""
    for ni, tbTemp in pairs(tbOpenMap) do
      szPlayerMsg = szPlayerMsg .. string.format("<color=yellow>%s<color>", tbTemp[2])
      if ni ~= #tbOpenMap then
        szPlayerMsg = szPlayerMsg .. "，"
      end
    end
    Dialog:Say(string.format("%s您队伍中有多个人开启了藏宝图副本，分别是%s，一个队伍只允许队长一人开启藏宝图副本，请重新组建符合要求的队伍。", szMsgTilte, szPlayerMsg))
    return 0
  end

  if #tbOpenMap > 0 and tbOpenMap[1][1] ~= 1 then
    Dialog:Say(string.format("%s您队伍中的<color=yellow>%s<color>已开启了藏宝图副本，但他现在不是队长，请把队长给予<color=yellow>%s<color>，你们才能进入藏宝图副本。", szMsgTilte, tbOpenMap[1][2], tbOpenMap[1][2]))
    return 0
  end
  local nCityMapId = him.GetWorldPos()
  if TreasureMap2.MapTempletList.tbBelongList[tbTeamList[1]] then
    local nRes, tbMission, nDyMapId = self:IsMissionOpen()
    if nRes == 1 then
      local szMsg = string.format("%s队长已开启<color=yellow>%s<color>副本<color=green>%d<color>星难度 ,决定闯入藏宝图副本了吗？", szMsgTilte, tbMission.szName, tbMission.nTreasureLevel)
      local tbOpt = {}
      if tbTeamList[1] == me.nId then
        table.insert(tbOpt, { "闯入副本", self.EnterMap, self, nCityMapId })
      else
        table.insert(tbOpt, { "跟随队长闯入副本", self.EnterMap, self, nCityMapId })
      end
      table.insert(tbOpt, { "我再想想" })

      Dialog:Say(szMsg, tbOpt)
      return 0
    else
      local tbTeamList = KTeam.GetTeamMemberList(me.nTeamId)
      local nCityMapId = TreasureMap2.MapTempletList.tbBelongList[tbTeamList[1]][1]
      local szWorldName = GetMapNameFormId(nCityMapId)
      local szMsg = string.format("%s您的队伍在<color=yellow>%s<color>开启了藏宝图副本，请到<color=yellow>%s<color>的义军军需官处进入藏宝图副本。", szMsgTilte, szWorldName, szWorldName)
      if nCityMapId == me.nMapId then
        szMsg = string.format("%s该副本已关闭。", szMsgTilte)
      end
      Dialog:Say(szMsg)
      return
    end
  end
  if not nType then
    Dialog:Say("请队长选择挑战随机藏宝图副本或制定藏宝图副本。随机藏宝图副本奖励更丰富。", { { "挑战随机藏宝图", self.OnDialog, self, 1 }, { "挑战指定藏宝图", self.OnDialog, self, 2 }, { "我再想想" } })
    return
  end
  if nType == 2 then
    local nStar, szMsg = self:GetTeamStar(me.nId)
    if nStar == -1 then
      Dialog:Say(szMsg)
      return
    end
    local tbMap = self:Star2Maps(nStar)
    if not tbMap then
      Dialog:Say("没有适合你的藏宝图！")
      return
    end
    local tbOpt = {}
    for _, tbMapinfo in pairs(tbMap[nStar]) do
      table.insert(tbOpt, { Lib:StrFillL(tbMapinfo.Name, 10) .. self:Star2pic(nStar), self.ApplyTreasureMap, self, tbMapinfo.TypeName, him.dwId })
    end
    table.insert(tbOpt, { "我再想想" })
    local _, tbItem = self:Star2AwrrowCount(nStar, 1)
    Dialog:Say("<newdialog>" .. szMsg .. string.format("你们将会获得若干<item=%d,%d,%d,%d>奖励。\n你们可以挑战以下藏宝图，请选择：", unpack(tbItem)), tbOpt)
    return
  end
  if nType == 1 then
    local nStar, szMsg = self:GetTeamStar(me.nId)
    if nStar == -1 then
      Dialog:Say(szMsg)
      return
    end
    local tbMap = self:Star2Maps(nStar)
    if not tbMap then
      Dialog:Say("没有适合你们的藏宝图！")
      return
    end
    local _, tbItem = self:Star2AwrrowCount(nStar, 1)
    szMsg = "<newdialog>" .. szMsg .. string.format("随机挑战你们将会获得额外的<item=%d,%d,%d,%d><color=gold>X3<color> 奖励。\n系统会在以下藏宝图中为你们随机一个进行挑战:\n", unpack(tbItem))
    for _, tbMapinfo in pairs(tbMap[nStar]) do
      szMsg = szMsg .. "\n<color=yellow>" .. Lib:StrFillL(tbMapinfo.Name, 10) .. "<color>" .. self:Star2pic(nStar)
    end
    Dialog:Say(szMsg, { { "接受挑战", self.ApplyTreasureMap, self, nil, him.dwId }, { "我再想想" } })
    return
  end
end

--NPC对话
function TreasureMapEx:OpenUI()
  --local nStar, szMsg = self:GetTeamStar(me.nId);
  --if nStar == -1 then
  --self:SendMsgBox(szMsg);
  --return;
  --end
  me.CallClientScript({ "UiManager:OpenWindow", "UI_TREASUREMAP", nStar })
end
-- 玩家队伍的副本是否已经开启
function TreasureMapEx:IsMissionOpen()
  local nTeamList = KTeam.GetTeamMemberList(me.nTeamId)
  local nMapId, nPosX, nPosY = me.GetWorldPos()
  if TreasureMap2.MapTempletList.tbBelongList[nTeamList[1]] then
    local nCityMapId = TreasureMap2.MapTempletList.tbBelongList[nTeamList[1]][1]
    local nDyMapId = TreasureMap2.MapTempletList.tbBelongList[nTeamList[1]][2]
    if nCityMapId == nMapId and nDyMapId ~= 0 then
      if not TreasureMap2.MissionList[nTeamList[1]] then
        return 0, "副本地图未开启，或已结束。"
      else
        return 1, TreasureMap2.MissionList[nTeamList[1]], nDyMapId
      end
    else
      return 0, "副本地图未开启。"
    end
  else
    return 0, "副本地图未开启。"
  end
end

--报名参加某图,供UI
function TreasureMapEx:SignMap(szTypeName, nStar)
  if self.IsOpen == 0 then
    Dialog:MsgBox("藏宝图系统异常。请联系GM。")
    return 0
  end
  if me.nTeamId <= 0 then
    Dialog:MsgBox("你<color=yellow>必须组队<color>并且是<color=yellow>队长<color>，才能开启藏宝图副本。")
    return 0
  end
  local nNpcId = self:CheckPos()
  if nNpcId == 0 then
    return 0
  end
  TreasureMap2:GetMapTempletList()
  local tbTeamList = KTeam.GetTeamMemberList(me.nTeamId)
  local tbOpenMap = {}
  for nId, nPlayerId in ipairs(tbTeamList) do
    if TreasureMap2.MapTempletList.tbBelongList[nPlayerId] then
      table.insert(tbOpenMap, { nId, KGCPlayer.GetPlayerName(nPlayerId) })
    end
  end
  if TreasureMap2.MapTempletList.tbBelongList[me.nId] then
    Dialog:MsgBox("你已经开启了藏宝图，不能再次开启。")
    return 0
  end
  if #tbOpenMap >= 2 then
    local szPlayerMsg = ""
    for ni, tbTemp in pairs(tbOpenMap) do
      szPlayerMsg = szPlayerMsg .. string.format("<color=yellow>%s<color>", tbTemp[2])
      if ni ~= #tbOpenMap then
        szPlayerMsg = szPlayerMsg .. "，"
      end
    end
    Dialog:MsgBox(string.format("您队伍中有多个人开启了藏宝图副本，分别是%s，一个队伍只允许队长一人开启藏宝图副本，请重新组建符合要求的队伍。", szPlayerMsg))
    return 0
  end
  if #tbOpenMap > 0 and tbOpenMap[1][1] ~= 1 then
    Dialog:MsgBox(string.format("您队伍中的<color=yellow>%s<color>已开启了藏宝图副本，但他现在不是队长，请把队长给予<color=yellow>%s<color>，你们才能进入藏宝图副本。", tbOpenMap[1][2], tbOpenMap[1][2]))
    return 0
  end
  if szTypeName then --指定藏宝图
    self:ApplyTreasureMap(szTypeName, nNpcId, nStar)
    return
  end
  if not szTypeName then --随机藏宝图
    self:ApplyTreasureMap(nil, nNpcId)
    return
  end
end

--进入藏宝图,供UI
function TreasureMapEx:EnterTreasure()
  local dwNpc = self:CheckPos()
  if dwNpc == 0 then
    return
  end
  local pNpc = KNpc.GetById(dwNpc)
  if not pNpc then
    return
  end
  if self.IsOpen == 0 then
    Dialog:MsgBox("藏宝图系统异常。请联系GM。")
    return 0
  end
  if me.nTeamId <= 0 then
    Dialog:MsgBox("你<color=yellow>必须组队<color>并且是<color=yellow>队长<color>，才能开启藏宝图副本。")
    return 0
  end
  local nNpcId = self:CheckPos()
  if nNpcId == 0 then
    return 0
  end
  TreasureMap2:GetMapTempletList()
  local tbTeamList = KTeam.GetTeamMemberList(me.nTeamId)
  local tbOpenMap = {}
  for nId, nPlayerId in ipairs(tbTeamList) do
    if TreasureMap2.MapTempletList.tbBelongList[nPlayerId] then
      table.insert(tbOpenMap, { nId, KGCPlayer.GetPlayerName(nPlayerId) })
    end
  end
  if #tbOpenMap >= 2 then
    local szPlayerMsg = ""
    for ni, tbTemp in pairs(tbOpenMap) do
      szPlayerMsg = szPlayerMsg .. string.format("<color=yellow>%s<color>", tbTemp[2])
      if ni ~= #tbOpenMap then
        szPlayerMsg = szPlayerMsg .. "，"
      end
    end
    Dialog:MsgBox(string.format("您队伍中有多个人开启了藏宝图副本，分别是%s，一个队伍只允许队长一人开启藏宝图副本，请重新组建符合要求的队伍。", szPlayerMsg))
    return 0
  end
  if #tbOpenMap > 0 and tbOpenMap[1][1] ~= 1 then
    Dialog:MsgBox(string.format("您队伍中的<color=yellow>%s<color>已开启了藏宝图副本，但他现在不是队长，请把队长给予<color=yellow>%s<color>，你们才能进入藏宝图副本。", tbOpenMap[1][2], tbOpenMap[1][2]))
    return 0
  end
  self:EnterMap(pNpc.nMapId)
end

--位置检测
function TreasureMapEx:CheckPos()
  local tbNpc = KNpc.GetAroundNpcList(me, 20)
  if not tbNpc then
    Dialog:MsgBox("距离军需官太远了，请站在各大城市义军军需官旁边！")
    return 0
  end
  local pFind = 0
  for _, pNpc in pairs(tbNpc) do
    if pNpc.nTemplateId == 2711 then
      pFind = pNpc
      break
    end
  end
  if pFind == 0 then
    Dialog:MsgBox("距离军需官太远了，请站在各大城市义军军需官旁边！")
    return 0
  end
  return pFind.dwId
end
function TreasureMapEx:CanEnterMap(pPlayer)
  if pPlayer.nTeamId <= 0 then
    return 0, "副本路途险恶，必须组队才能进入。"
  end

  local nRes, var, nDyMapId = self:IsMissionOpen()
  if nRes ~= 1 then
    return 0, var
  end

  if var:GetPlayerCount() >= TreasureMap2.DEF_MAX_ENTER then
    return 0, string.format("已有<color=yellow>%s人<color>闯入了副本地图，太多人反而会更乱，还是不要进去吧。", TreasureMap2.DEF_MAX_ENTER)
  end

  return 1, var, nDyMapId
end

function TreasureMapEx:EnterMap(nCityMapId)
  local nRes, var = self:CanEnterMap(me)
  if nRes ~= 1 then
    Dialog:MsgBox(var)
    return 0
  end
  local tbMission = var
  if tbMission:IsOnceInMission(me.nId) == 0 then
    nRes, var = self:CheckPlayer(me.nId, nCityMapId, tbMission.nTreasureLevel)
    if nRes ~= 1 then
      local szMsg = string.format("您不能进入该副本:\n<color=red>%s<color>", var)
      Dialog:MsgBox(szMsg)
      return 0
    end
  end

  tbMission:JoinPlayer(me, 0)
  return 0
end
