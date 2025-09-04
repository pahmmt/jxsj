--4倍地图npc
--sunduoliang
--2008.11.05

Require("\\script\\task\\fourfoldmap\\fourfoldmap_def.lua")

local Fourfold = Task.FourfoldMap

function Fourfold:OnAbout()
  local szMsg = string.format(
    [[
<color=red>秘境简介：<color>

1.必须等级达到<color=yellow>50级<color>的玩家才有资格进入秘境；

2.每次秘境开启的时间为<color=yellow>2到6小时<color>，秘境内有丰厚的经验奖励；

3.等级达到50级的玩家，每人每天将会<color=yellow>自动累加%d小时<color>的秘境修炼时间，最高上限累加<color=yellow>%d小时<color>秘境修炼时间；

4.秘境关闭之前，可以随意出入，离开秘境后只要回到这里找我就可以再次进入秘境修炼；

5.队长秘境修炼时间最少要有<color=yellow>2小时<color>才可使用秘境地图，带领队员共同进入地图修炼，但最多只能有<color=yellow>6个人<color>同时进入秘境修炼；

6.如果是<color=yellow>使用地图进入的秘境(无论是否是队长)<color>，在秘境内修炼时，可以获得<color=red>对应时间离线托管经验（在线托管）<color>，获得经验需要<color=yellow>角色白驹时间不为0，经验给予的时间间隔为5秒，并且当天的离线修炼时间未用完<color>。

7.有其他不懂的地方可以按F12打开<color=yellow>帮助锦囊<color>查询；
]],
    EventManager.IVER_nFourfoldMapPreTime,
    EventManager.IVER_nFourfoldMapMaxTime
  )
  Dialog:Say(szMsg)
end

--位置检测
function Fourfold:CheckPos()
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

--报名参加秘境，供UI
function Fourfold:SignMap_UI()
  if self:CheckPos() == 0 then
    return
  end
  if me.nLevel < self.LIMIT_LEVEL then
    Dialog:MsgBox(string.format("必须等级达到%s级，才有资格进入秘境。", self.LIMIT_LEVEL))
    return 0
  end
  local nRemainTime = me.GetTask(self.TSK_GROUP, self.TSK_REMAIN_TIME)
  --local szMsgTilte = string.format("目前你剩余的秘境修行时间：\n    <color=yellow>%s<color>\n\n", Lib:TimeFullDesc(nRemainTime));
  if nRemainTime <= 0 then
    Dialog:MsgBox(string.format("你今天的修行已经达到顶峰了，还是明天再继续吧。"))
    return 0
  end
  if me.nTeamId <= 0 then
    Dialog:MsgBox(string.format("你<color=yellow>必须组队<color>并且是<color=yellow>队长<color>，才能带领你的朋友共同修行。"))
    return 0
  end
  local nTeamList = KTeam.GetTeamMemberList(me.nTeamId)
  local nMapId, nPosX, nPosY = me.GetWorldPos()

  local tbOpenMap = {}
  for nId, nPlayerId in ipairs(nTeamList) do
    if self.MapTempletList.tbBelongList[nPlayerId] then
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
    Dialog:MsgBox(string.format("您队伍中有多个人开启了秘境，分别是%s，一个队伍只允许队长一人开启秘境，请重新组建符合要求的队伍。", szPlayerMsg))
    return 0
  end
  if #tbOpenMap > 0 and tbOpenMap[1][1] ~= 1 then
    Dialog:MsgBox(string.format("您队伍中的<color=yellow>%s<color>已开启了秘境，但他现在不是队长，请把队长给予<color=yellow>%s<color>，你们才能进入秘境。", tbOpenMap[1][2], tbOpenMap[1][2]))
    return 0
  end
  self:ApplyTeamMap()
end
--进入秘境秘境，供UI
function Fourfold:EnterMap_UI()
  if self:CheckPos() == 0 then
    return
  end
  if me.nLevel < self.LIMIT_LEVEL then
    Dialog:MsgBox(string.format("必须等级达到%s级，才有资格进入秘境。", self.LIMIT_LEVEL))
    return 0
  end
  local nRemainTime = me.GetTask(self.TSK_GROUP, self.TSK_REMAIN_TIME)
  --local szMsgTilte = string.format("目前你剩余的秘境修行时间：\n    <color=yellow>%s<color>\n\n", Lib:TimeFullDesc(nRemainTime));
  if nRemainTime <= 0 then
    Dialog:MsgBox(string.format("你今天的修行已经达到顶峰了，还是明天再继续吧。"))
    return 0
  end
  if me.nTeamId <= 0 then
    Dialog:MsgBox(string.format("你<color=yellow>必须组队<color>并且是<color=yellow>队长<color>，才能带领你的朋友共同修行。"))
    return 0
  end
  local nTeamList = KTeam.GetTeamMemberList(me.nTeamId)
  local nMapId, nPosX, nPosY = me.GetWorldPos()

  local tbOpenMap = {}
  for nId, nPlayerId in ipairs(nTeamList) do
    if self.MapTempletList.tbBelongList[nPlayerId] then
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
    Dialog:MsgBox(string.format("您队伍中有多个人开启了秘境，分别是%s，一个队伍只允许队长一人开启秘境，请重新组建符合要求的队伍。", szPlayerMsg))
    return 0
  end
  if #tbOpenMap > 0 and tbOpenMap[1][1] ~= 1 then
    Dialog:MsgBox(string.format("您队伍中的<color=yellow>%s<color>已开启了秘境，但他现在不是队长，请把队长给予<color=yellow>%s<color>，你们才能进入秘境。", tbOpenMap[1][2], tbOpenMap[1][2]))
    return 0
  end
  if self.MapTempletList.tbBelongList[nTeamList[1]] then
    if self:IsMissionOpen() == 1 then
      local szMsg = string.format("决定闯入秘境了吗？")
      local tbOpt = {
        { "自备地图闯入秘境(经验翻倍)", self.EnterMapForItem, self },
        { "跟随队长闯入秘境", self.EnterMap, self },
        { "结束对话" },
      }
      Dialog:Say(szMsg, tbOpt)
      return 0
    else
      local nTeamList = KTeam.GetTeamMemberList(me.nTeamId)
      local nCityMapId = self.MapTempletList.tbBelongList[nTeamList[1]][1]
      local szWorldName = GetMapNameFormId(nCityMapId)
      local szMsg = string.format("您的队伍在<color=yellow>%s<color>开启了秘境，请到<color=yellow>%s<color>的义军军需官处进入秘境。", szWorldName, szWorldName)
      Dialog:MsgBox(szMsg)
      return
    end
  end
end
function Fourfold:OnDialog()
  if me.nLevel < self.LIMIT_LEVEL then
    Dialog:Say(string.format("必须等级达到%s级，才有资格进入秘境。", self.LIMIT_LEVEL))
    return 0
  end
  local nRemainTime = me.GetTask(self.TSK_GROUP, self.TSK_REMAIN_TIME)
  local szMsgTilte = string.format("武学修行，只能适度修习，如果操之过急则会反噬自身，走火入魔。\n\n目前你剩余的秘境修行时间：\n    <color=yellow>%s<color>\n\n", Lib:TimeFullDesc(nRemainTime))
  if nRemainTime <= 0 then
    Dialog:Say(string.format("%s你今天的修行已经达到顶峰了，还是明天再继续吧。", szMsgTilte))
    return 0
  end
  if me.nTeamId <= 0 then
    Dialog:Say(string.format("%s你<color=yellow>必须组队<color>并且是<color=yellow>队长<color>，才能带领你的朋友共同修行。", szMsgTilte))
    return 0
  end
  local nTeamList = KTeam.GetTeamMemberList(me.nTeamId)
  local nMapId, nPosX, nPosY = me.GetWorldPos()

  local tbOpenMap = {}
  for nId, nPlayerId in ipairs(nTeamList) do
    if self.MapTempletList.tbBelongList[nPlayerId] then
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
    Dialog:Say(string.format("%s您队伍中有多个人开启了秘境，分别是%s，一个队伍只允许队长一人开启秘境，请重新组建符合要求的队伍。", szMsgTilte, szPlayerMsg))
    return 0
  end
  if #tbOpenMap > 0 and tbOpenMap[1][1] ~= 1 then
    Dialog:Say(string.format("%s您队伍中的<color=yellow>%s<color>已开启了秘境，但他现在不是队长，请把队长给予<color=yellow>%s<color>，你们才能进入秘境。", szMsgTilte, tbOpenMap[1][2], tbOpenMap[1][2]))
    return 0
  end

  if self.MapTempletList.tbBelongList[nTeamList[1]] then
    if self:IsMissionOpen() == 1 then
      local szMsg = string.format("%s决定闯入秘境了吗？", szMsgTilte)
      local tbOpt = {
        { "自备地图闯入秘境(经验翻倍)", self.EnterMapForItem, self },
        { "跟随队长闯入秘境", self.EnterMap, self },
        { "结束对话" },
      }
      Dialog:Say(szMsg, tbOpt)
      return 0
    else
      local nTeamList = KTeam.GetTeamMemberList(me.nTeamId)
      local nCityMapId = self.MapTempletList.tbBelongList[nTeamList[1]][1]
      local szWorldName = GetMapNameFormId(nCityMapId)
      local szMsg = string.format("%s您的队伍在<color=yellow>%s<color>开启了秘境，请到<color=yellow>%s<color>的义军军需官处进入秘境。", szMsgTilte, szWorldName, szWorldName)
      Dialog:Say(szMsg)
      return
    end
  end
  local szMsg = string.format("%s你如果有<color=yellow>秘境地图<color>，将可开启秘境，您是否要开启秘境？", szMsgTilte)
  local tbOpt = {
    { "开启秘境", self.ApplyTeamMap, self },
    { "结束对话" },
  }
  Dialog:Say(szMsg, tbOpt)
end

--返回可能的修炼时间，如果时间不够则返回空table
--nRemainTime单位为秒
function Fourfold:GetValidPractiseTime(pPlayer, nRemainTime)
  local tbHour = {}
  if nRemainTime >= 6 * 3600 then
    table.insert(tbHour, 6)
  end
  if nRemainTime >= 4 * 3600 then
    table.insert(tbHour, 4)
  end
  if nRemainTime >= 2 * 3600 then
    table.insert(tbHour, 2)
  end
  return tbHour, string.format("秘境修行时间必须<color=yellow>大于%s<color>才能进入秘境修炼。", Lib:TimeFullDesc(self.DEF_MIN_OPEN_TIME))
end

function Fourfold:ApplyTeamMap(nFlag, nHour, nMapNumber)
  if self:CheckPos() == 0 then
    return
  end
  local nRemainTime = me.GetTask(self.TSK_GROUP, self.TSK_REMAIN_TIME)
  if nRemainTime < self.DEF_MIN_OPEN_TIME then
    Dialog:MsgBox(string.format("秘境修行时间必须<color=yellow>大于%s<color>才能进入秘境修炼。", Lib:TimeFullDesc(self.DEF_MIN_OPEN_TIME)))
    return 0
  end
  if me.nTeamId <= 0 or me.IsCaptain() == 0 then
    Dialog:MsgBox(string.format("你必须组队并且是队长，才能带领你的朋友共同修行。"))
    return 0
  end

  local nTeamList = KTeam.GetTeamMemberList(me.nTeamId)
  if self.MapTempletList.tbBelongList[nTeamList[1]] then
    return 0
  end
  if self.MapTempletList.nCount >= self.MAP_APPLY_MAX then
    Dialog:MsgBox("多位英雄已于此地秘境修炼，这位侠士烦请稍候片刻。")
    return 0
  end

  -- 选择用多少地图
  if not nFlag then
    local tbHour, szMsg = self:GetValidPractiseTime(me, nRemainTime)
    if #tbHour == 0 then
      Dialog:Say(szMsg)
      return 0
    end

    local szMsg = string.format("你如果有<color=yellow>秘境地图<color>，将可开启秘境，你确定要开启秘境？\n<color=red>开启秘境将会扣除你身上的秘境地图<color>")
    local tbOpt = {}

    for _, nHour in ipairs(tbHour) do
      table.insert(tbOpt, { string.format("使用%d张地图修炼%d小时", nHour / 2, nHour), self.ApplyTeamMap, self, 1, nHour, nHour / 2 })
    end

    table.insert(tbOpt, { "结束对话" })
    Dialog:Say(szMsg, tbOpt)
    return 0
  end

  local tbFind = me.FindItemInBags(unpack(self.DEF_ITEM_KEY))
  if #tbFind < nMapNumber then
    Dialog:Say(string.format("没有<color=yellow>%d张<color>地图的指引，我也没办法带你进入这个神秘的地方，记得带足够的<color=yellow>秘境地图<color>来找我啊！", nMapNumber))
    return 0
  end
  if self:CheckPos() == 0 then
    return
  end
  local nMapId, nPosX, nPosY = me.GetWorldPos()
  if self:ApplyMap(nMapId, me.nId, me.nLevel, nHour) == 1 then
    for i = 1, nMapNumber do
      me.DelItem(tbFind[i].pItem)
    end
    me.Msg("<color=yellow>成功开启秘境<color>，请叫上朋友，在<color=yellow>三分钟内<color>进入秘境。")
    SpecialEvent.ActiveGift:AddCounts(me, 18) --开启秘境活跃度
    TreasureMap.TreasureMapEx:UpdatePlayersInfo()
    return 0
  end
end

-- 玩家队伍的副本是否已经开启
function Fourfold:IsMissionOpen()
  local nTeamList = KTeam.GetTeamMemberList(me.nTeamId)
  local nMapId, nPosX, nPosY = me.GetWorldPos()
  if self.MapTempletList.tbBelongList[nTeamList[1]] then
    local nCityMapId = self.MapTempletList.tbBelongList[nTeamList[1]][1]
    local nDyMapId = self.MapTempletList.tbBelongList[nTeamList[1]][3]
    if nCityMapId == nMapId and nDyMapId ~= 0 then
      if not self.MissionList[nTeamList[1]] then
        return 0, "秘境地图未开启。"
      else
        return 1, self.MissionList[nTeamList[1]], nDyMapId
      end
    else
      return 0, "秘境地图未开启。"
    end
  else
    return 0, "秘境地图未开启。"
  end
end

function Fourfold:CanEnterMap()
  if me.nTeamId <= 0 then
    return 0, "秘境路途险恶，必须组队才能进入。"
  end

  local nRemainTime = me.GetTask(self.TSK_GROUP, self.TSK_REMAIN_TIME)
  if nRemainTime <= self.DEF_MIN_ENTER_TIME then
    return 0, string.format("秘境修行时间必须<color=yellow>大于%s<color>才能进入秘境。", Lib:TimeFullDesc(self.DEF_MIN_ENTER_TIME))
  end

  local nRes, var, nDyMapId = self:IsMissionOpen()
  if nRes ~= 1 then
    return 0, var
  end

  local nTeamList = KTeam.GetTeamMemberList(me.nTeamId)
  if var:GetPlayerCount() >= self.DEF_MAX_ENTER then
    return 0, string.format("已有<color=yellow>%s人<color>闯入了秘境地图，太多人反而会更乱，还是不要进去吧。", self.DEF_MAX_ENTER)
  end

  return 1, var, nDyMapId
end

function Fourfold:EnterMapForItem(nFlag, nHour, nMapNumber)
  if self:CheckPos() == 0 then
    return
  end
  local nRes, var = self:CanEnterMap()
  if nRes ~= 1 then
    Dialog:Say(var)
    return 0
  end
  local tbMission = var
  if tbMission:GetFourfold(me.nId) == 1 or tbMission:IsOnceInFourfold(me.nId) == 1 then
    self:EnterMap()
    return 0
  end

  if not nFlag then -- 选择用几幅地图
    local nMissionTime = tbMission:GetHour() * 3600
    local nRemainTime = me.GetTask(self.TSK_GROUP, self.TSK_REMAIN_TIME)
    local tbHour, szMsg = Fourfold:GetValidPractiseTime(pPlayer, math.min(nRemainTime, nMissionTime))
    if #tbHour == 0 then
      Dialog:Say(szMsg)
      return 0
    end
    local szMsg = string.format("你如果有<color=yellow>秘境地图<color>，可自带<color=yellow>秘境地图<color>跟随队长闯入秘境，你的修行效果将会大大提升（4倍经验），你确定要使用<color=yellow>秘境地图<color>闯入秘境吗？\n<color=red>使用秘境地图闯入秘境将会扣除你身上的秘境地图<color>")
    local tbOpt = {}
    for _, nHour in ipairs(tbHour) do
      table.insert(tbOpt, { string.format("使用%d张秘境地图", nHour / 2), self.EnterMapForItem, self, 1, nHour, nHour / 2 })
    end
    table.insert(tbOpt, { "结束对话" })
    Dialog:Say(szMsg, tbOpt)
    return 0
  else -- 进入
    local tbFind = me.FindItemInBags(unpack(self.DEF_ITEM_KEY))
    if #tbFind < nMapNumber then
      Dialog:Say(string.format("你没有足够的<color=yellow>秘境地图<color>，想获得%d个小时的大修为，必须带上<color=yellow>%d张秘境地图<color>来找我！", nHour, nMapNumber))
      return 0
    end

    for i = 1, nMapNumber do
      me.DelItem(tbFind[i].pItem)
    end
    SpecialEvent.ActiveGift:AddCounts(me, 18) --开启秘境活跃度
    tbMission:JoinFourfold(me.nId, nHour)
    self:EnterMap()
    return 0
  end
end

function Fourfold:EnterMap()
  if self:CheckPos() == 0 then
    return
  end
  local nRes, var, nDyMapId = self:CanEnterMap()
  if nRes ~= 1 then
    Dialog:Say(var)
    return 0
  end

  local nMapId, nPosX, nPosY = me.GetWorldPos()
  self.PlayerTempList[me.nId] = {}
  self.PlayerTempList[me.nId].nMapId = nMapId
  self.PlayerTempList[me.nId].nPosX = nPosX
  self.PlayerTempList[me.nId].nPosY = nPosY
  self.PlayerTempList[me.nId].nCaptain = KTeam.GetTeamMemberList(me.nTeamId)[1]
  self.PlayerTempList[me.nId].nState = 0
  me.NewWorld(nDyMapId, unpack(self.DEF_MAP_POS[1]))
  return 0
end
