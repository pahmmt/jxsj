-- 文件名　：guoqing2012_gs.lua
-- 创建者　：huangxiaoming
-- 创建时间：2012-08-10 14:10:10
-- 描  述  ：

if not MODULE_GAMESERVER then
  return
end

Require("\\script\\event\\jieri\\201209_zhongqiuguoqing\\guoqing2012_def.lua")

SpecialEvent.GuoQing2012 = SpecialEvent.GuoQing2012 or {}
local tbGuoQing2012 = SpecialEvent.GuoQing2012 or {}

-- 是否在活动时间内
function tbGuoQing2012:CheckActivityTime()
  local nNowTime = tonumber(GetLocalDate("%H%M%S"))
  if nNowTime >= self.DAY_OPEN_TIME1 and nNowTime <= self.DAY_CLOSE_TIME1 then
    return 1
  end
  if nNowTime >= self.DAY_OPEN_TIME2 and nNowTime <= self.DAY_CLOSE_TIME2 then
    return 1
  end
  return 0
end

-- 获取收到月饼的个数
function tbGuoQing2012:GetReceiveCakeCount(pPlayer)
  local nDate = tonumber(GetLocalDate("%Y%m%d"))
  local nTaskDate = pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_EVENT_CAKE_DAY)
  if nDate > nTaskDate then
    pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_EVENT_CAKE_DAY, nDate)
    pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_EVENT_CAKE_COUNT, 0)
  end
  return pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_EVENT_CAKE_COUNT)
end

-- 添加收到月饼的个数
function tbGuoQing2012:AddReciveCakeCount(pPlayer, nNum)
  nNum = nNum or 1
  local nTask = self:GetReceiveCakeCount(pPlayer)
  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_EVENT_CAKE_COUNT, nTask + nNum)
end

-- 帮忙点烟花的的次数
function tbGuoQing2012:GetHelpIgniteCount(pPlayer)
  local nDate = tonumber(GetLocalDate("%Y%m%d"))
  local nTaskDate = pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_EVENT_HELP_DAY)
  if nDate > nTaskDate then
    pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_EVENT_HELP_DAY, nDate)
    pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_EVENT_HELP_COUNT, 0)
  end
  return pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_EVENT_HELP_COUNT)
end

-- 添加帮忙点烟花的次数
function tbGuoQing2012:AddHelpIgniteCount(pPlayer, nNum)
  nNum = nNum or 1
  local nTask = self:GetHelpIgniteCount(pPlayer)
  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_EVENT_HELP_COUNT, nTask + nNum)
end

-- 检查任务日期
function tbGuoQing2012:CheckEventTaskDay(pPlayer)
  local nDate = tonumber(GetLocalDate("%Y%m%d"))
  local nTaskDate = pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_EVENT_DAY)
  if nDate > nTaskDate then
    pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_EVENT_DAY, nDate)
    pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_EVENT_STATE, 0)
    pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_EVENT_STEP_INFO, 0)
  end
end

-- 获取事件任务的已完成状态
function tbGuoQing2012:GetEventState(pPlayer)
  self:CheckEventTaskDay(pPlayer)
  return pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_EVENT_STATE)
end

-- 设置事件任务的已完成状态
function tbGuoQing2012:SetEventState(pPlayer, nState)
  self:CheckEventTaskDay(pPlayer)
  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_EVENT_STATE, nState)
end

-- 设置步骤的值,0:初始状态，1：领取了免费道具，2：领取付费道具
function tbGuoQing2012:SetEventStepInfo(pPlayer, nStep, nValue)
  if nStep < 1 or nStep > 3 then
    assert(false)
    return
  end
  self:CheckEventTaskDay(pPlayer)
  local nTaskValue = pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_EVENT_STEP_INFO)
  local tbStepValue = {}
  for i = 1, 3 do
    if i > 1 then
      nTaskValue = math.floor(nTaskValue / 10)
    end
    tbStepValue[i] = math.mod(nTaskValue, 10)
  end
  tbStepValue[nStep] = nValue
  nTaskValue = 0
  for i = 3, 1, -1 do
    nTaskValue = nTaskValue * 10 + tbStepValue[i]
  end
  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_EVENT_STEP_INFO, nTaskValue)
end

-- 获取步骤的值
function tbGuoQing2012:GetEventStepInfo(pPlayer, nStep)
  self:CheckEventTaskDay(pPlayer)
  local nTaskValue = pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_EVENT_STEP_INFO)
  local tbStepValue = {}
  for i = 1, 3 do
    if i > 1 then
      nTaskValue = math.floor(nTaskValue / 10)
    end
    tbStepValue[i] = math.mod(nTaskValue, 10)
  end
  return tbStepValue[nStep]
end

-- 获取需要随机的门派值
function tbGuoQing2012:GetRandFaction()
  local szGateName = GetGatewayName()
  if szGateName == "gate1025" or szGateName == "gate1121" then
    local nRand = MathRandom(100) --新区50%的几率随古墓
    if nRand <= 50 then
      return 13
    end
  end
  return MathRandom(12)
end

-- 查找步骤需要的道具
function tbGuoQing2012:FindStepNeedItem(pPlayer, nState, nType)
  local tbNeedItem = nil
  if nType == 1 then
    tbNeedItem = tbGuoQing2012.ITEMID_EVENT[nState][1]
  elseif nType == 2 then
    tbNeedItem = tbGuoQing2012.ITEMID_EVENT[nState][3]
  end
  if not tbNeedItem or #tbNeedItem ~= 4 then
    return 0
  end
  local tbFind = pPlayer.FindItemInBags(unpack(tbNeedItem))
  return tbFind, tbNeedItem
end

-- 挂灯笼
function tbGuoQing2012:HangLantern(nPlayerId, nType, nFlag)
  if tbGuoQing2012:CheckIsOpen() ~= 1 then
    return
  end
  if tbGuoQing2012:CheckActivityTime() ~= 1 then
    return
  end
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return
  end
  local nState = tbGuoQing2012:GetEventState(pPlayer)
  if nState ~= 0 then
    return
  end
  if tbGuoQing2012:GetEventStepInfo(pPlayer, 1) ~= nType then
    return
  end
  local nNextState = nState + 1
  local tbFind, tbNeedItem = self:FindStepNeedItem(pPlayer, nNextState, nType)
  if #tbFind <= 0 then
    pPlayer.Msg("身上没有可用的灯笼。")
    return
  end
  local nNeedMapId = pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_EVENT_STEP_PARAM)
  if nNeedMapId ~= pPlayer.nMapId then
    local szMapName = GetMapNameFormId(nNeedMapId)
    local szMsg = string.format("地点不正确，请前往%s挂起灯笼", szMapName)
    pPlayer.Msg(szMsg)
    Dialog:SendBlackBoardMsg(pPlayer, szMsg)
    return
  end
  local tbNpcList = KNpc.GetAroundNpcList(pPlayer, self.MAX_LANTERN_RANGE)
  for _, pNpc in ipairs(tbNpcList) do
    if pNpc.nKind == 3 or pNpc.nKind == 4 or pNpc.nKind == 8 then
      pPlayer.Msg("这里太拥挤了，换个地方放吧。")
      Dialog:SendBlackBoardMsg(pPlayer, "这里太拥挤了，换个地方放吧。")
      return
    end
  end
  if pPlayer.CountFreeBagCell() < 1 then
    pPlayer.Msg("背包空间不足，需要1格背包空间。")
    Dialog:SendBlackBoardMsg(pPlayer, "背包空间不足，需要1格背包空间。")
    return
  end

  if not nFlag then
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
    GeneralProcess:StartProcess("放置中", 5 * Env.GAME_FPS, { self.HangLantern, self, nPlayerId, nType, 1 }, nil, tbEvent)
    return
  end
  local szItemName = tbFind[1].pItem.szName
  pPlayer.DelItem(tbFind[1].pItem)
  local nMapId, nPosX, nPosY = pPlayer.GetWorldPos()
  local pNpc = KNpc.Add2(self.NPCID_LANTERN[nType], 120, -1, nMapId, nPosX, nPosY)
  if pNpc then
    pNpc.SetTitle(string.format("<color=green>%s<color>", pPlayer.szName))
    pNpc.SetLiveTime(15 * 60 * 18)
  end
  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_EVENT_STEP_PARAM, 0)
  self:SetEventState(pPlayer, nNextState)
  self:SetEventState(pPlayer, nNextState)
  local pItem = pPlayer.AddItem(unpack(self.ITEMID_AWARD_STEP[nType]))
  if pItem then
    pItem.Bind(1)
    local nDate = tonumber(GetLocalDate("%Y%m%d"))
    local nValidTime = Lib:GetDate2Time(nDate) + 24 * 3600 - 1
    pPlayer.SetItemTimeout(pItem, os.date("%Y/%m/%d/%H/%M/%S", nValidTime))
    pItem.Sync()
    local szMsg = string.format("你获得一个%s，小女孩正找你要托付下一件重要的事情！", pItem.szName)
    pPlayer.Msg(szMsg)
  --	Dialog:SendBlackBoardMsg(pPlayer, szMsg);
  else
    Dbg:WriteLog("guoqing2012 Add award faile", pPlayer.szName, nNextState, nType)
  end
  pPlayer.SendMsgToFriend(string.format("您的好友[<color=yellow>%s<color>]挂起了%s。", pPlayer.szName, szItemName))
  Dialog:SendBlackBoardMsg(pPlayer, "操作成功！小女孩正找你要托付下一件重要的事情！")
  StatLog:WriteStatLog("stat_info", "midautunm2012", "use_tool", pPlayer.nId, string.format("%s_%s_%s_%s", unpack(tbNeedItem)), nType)
end

-- 获取组队的另一方
function tbGuoQing2012:GetPartner(pPlayer)
  if pPlayer.nTeamId <= 0 then
    return nil
  end
  local _, nTeamCount = KTeam.GetTeamMemberList(pPlayer.nTeamId)
  if nTeamCount ~= 2 then
    return ni
  end
  local tbTeamMembers, nMemberCount = pPlayer.GetTeamMemberList()
  if nMemberCount ~= 2 then
    return nil
  end

  if tbTeamMembers[1].nId == pPlayer.nId then
    return tbTeamMembers[2]
  end
  return tbTeamMembers[1]
end

function tbGuoQing2012:AddFireWork(nPlayerId, nType, nFlag)
  if tbGuoQing2012:CheckIsOpen() ~= 1 then
    return
  end
  if tbGuoQing2012:CheckActivityTime() ~= 1 then
    return
  end
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return
  end
  local szMapTyp = GetMapType(pPlayer.nMapId)
  if szMapTyp ~= "village" and szMapTyp ~= "city" then
    pPlayer.Msg("只有在城市或者新手村才能摆放烟花。")
    Dialog:SendBlackBoardMsg(pPlayer, "只有在城市或者新手村才能摆放烟花。")
    return
  end
  local pPartner = self:GetPartner(pPlayer)
  if not pPartner then
    pPlayer.Msg("必须双人组队才能做这个活动。")
    Dialog:SendBlackBoardMsg(pPlayer, "必须双人组队才能做这个活动。")
    return
  end
  local nState = self:GetEventState(pPlayer)
  local nNextState = nState + 1
  if nState ~= 1 then
    return
  end
  if tbGuoQing2012:GetEventStepInfo(pPlayer, nNextState) ~= nType then
    return
  end
  local nMapId1, nPosX1, nPosY1 = pPlayer.GetWorldPos()
  local nMapId2, nPosX2, nPosY2 = pPartner.GetWorldPos()
  if nMapId1 ~= nMapId2 then
    pPlayer.Msg("队友离你太远了，无法摆放炮竹。")
    Dialog:SendBlackBoardMsg(pPlayer, "队友离你太远了，无法摆放炮竹。")
    return
  end
  if (nPosX1 - nPosX2) * (nPosX1 - nPosX2) + (nPosY1 - nPosY2) * (nPosY1 - nPosY2) > 30 * 30 then
    pPlayer.Msg("队友离你太远了，无法摆放炮竹。")
    Dialog:SendBlackBoardMsg(pPlayer, "队友离你太远了，无法摆放炮竹。")
    return
  end
  local tbFind, tbNeedItem = self:FindStepNeedItem(pPlayer, nNextState, nType)
  if #tbFind <= 0 then
    return
  end
  local tbNpcList = KNpc.GetAroundNpcList(pPlayer, self.MAX_LANTERN_RANGE)
  for _, pNpc in ipairs(tbNpcList) do
    if pNpc.nKind == 3 or pNpc.nKind == 4 or pNpc.nKind == 8 then
      pPlayer.Msg("这里太拥挤了，换个地方放吧。")
      Dialog:SendBlackBoardMsg(pPlayer, "这里太拥挤了，换个地方放吧。")
      return
    end
  end
  if not nFlag then
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
    GeneralProcess:StartProcess("摆放中", 5 * Env.GAME_FPS, { self.AddFireWork, self, nPlayerId, nType, 1 }, nil, tbEvent)
    return
  end

  pPlayer.DelItem(tbFind[1].pItem)
  local pNpc = KNpc.Add2(self.NPCID_FIREWORKS[nType], 120, -1, nMapId1, nPosX1, nPosY1)
  if pNpc then
    pNpc.SetTitle(string.format("<color=pink>%s<color>", pPlayer.szName))
    pNpc.SetLiveTime(30 * 60 * 18)
    pNpc.GetTempTable("Npc").tbInfo = {}
    pNpc.GetTempTable("Npc").tbInfo.nOwnerId = pPlayer.nId
    pNpc.GetTempTable("Npc").tbInfo.nDay = Lib:GetLocalDay() -- 记录一下放下的天数，防止npc过天
  end
  pPlayer.Msg("炮竹已摆好，请你们2人同时点燃")
  Dialog:SendBlackBoardMsg(pPlayer, "炮竹已摆好，请你们2人同时点燃")
  pPartner.Msg("炮竹已摆好，请你们2人同时点燃")
  Dialog:SendBlackBoardMsg(pPartner, "炮竹已摆好，请你们2人同时点燃")
  StatLog:WriteStatLog("stat_info", "midautunm2012", "use_tool", pPlayer.nId, string.format("%s_%s_%s_%s", unpack(tbNeedItem)), -1)
end

-- 点燃烟花
function tbGuoQing2012:IgniteFireworks(nPlayerId, dwNpcId, nType, nFlag)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return
  end
  local pFireworks = KNpc.GetById(dwNpcId)
  if not pFireworks then
    return
  end
  local tbFireworksInfo = pFireworks.GetTempTable("Npc").tbInfo
  if not tbFireworksInfo then
    return
  end
  if tbFireworksInfo.nIgniteFlag == 1 then
    return
  end
  -- 保护一下，万一没人激活跨天了
  if tbFireworksInfo.nDay ~= Lib:GetLocalDay() then
    return
  end
  local pPartner = self:GetPartner(pPlayer)
  if not pPartner then
    pPlayer.Msg("必须双人组队才能点燃。")
    Dialog:SendBlackBoardMsg(pPlayer, "必须双人组队才能点燃。")
    return
  end
  local pOwner = nil
  local nIsOwner = 1
  if pPlayer.nId == tbFireworksInfo.nOwnerId then
    pOwner = pPlayer
    nIsOwner = 1
  elseif pPartner.nId == tbFireworksInfo.nOwnerId then
    pOwner = pPartner
    nIsOwner = 0
  end
  if not pOwner then
    pPlayer.Msg("这不是你们队伍的烟花")
    Dialog:SendBlackBoardMsg(pPlayer, "这不是你们队伍的烟花")
    return
  end
  local nState = self:GetEventState(pOwner)
  local nNextState = nState + 1
  if nState ~= 1 then
    return
  end
  if tbGuoQing2012:GetEventStepInfo(pOwner, nNextState) ~= nType then
    return
  end
  if pOwner.CountFreeBagCell() < 1 then
    pPlayer.Msg(string.format("%s背包空间不足", pOwner.szName))
    Dialog:SendBlackBoardMsg(pPlayer, string.format("%s背包空间不足", pOwner.szName))
    return
  end
  local nLastIgniteTime = pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_EVENT_IGINITE_TIME)
  if nLastIgniteTime > GetTime() - self.INTERVAL_IGNITEFIREWORKS - 2 then
    pPlayer.Msg("你刚点燃了烟花，休息一下再点吧。")
    Dialog:SendBlackBoardMsg(pPlayer, "你刚点燃了烟花，休息一下再点吧。")
    return
  end
  if not nFlag then
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
    GeneralProcess:StartProcess("点燃中", 5 * Env.GAME_FPS, { self.IgniteFireworks, self, nPlayerId, dwNpcId, nType, 1 }, nil, tbEvent)
    return
  end
  self:AchieveIgniteFireworks(pPlayer, pPartner, nIsOwner, pFireworks, nNextState, nType)
end

-- 完成点燃
function tbGuoQing2012:AchieveIgniteFireworks(pPlayer, pPartner, nIsOwner, pNpc, nNextState, nType)
  local tbFireworksInfo = pNpc.GetTempTable("Npc").tbInfo
  if not tbFireworksInfo then
    assert(false)
    return
  end
  local nPartnerTime = nil
  local pHelper = nil
  local pOwner = nil
  if nIsOwner ~= 1 then
    nPartnerTime = tbFireworksInfo.nOwnerTime
    pOwner = pPartner
    pHelper = pPlayer
  else
    nPartnerTime = tbFireworksInfo.nFriendTime
    pOwner = pPlayer
    pHelper = pPartner
  end
  local nNowTime = GetTime()
  if nPartnerTime then
    -- 成功点燃烟花
    if nNowTime - nPartnerTime <= self.INTERVAL_IGNITEFIREWORKS then
      tbFireworksInfo.nIgniteFlag = 1
      local szMsg = "点燃成功！小女孩正找你要托付下一件重要的事情！"
      Dialog:SendBlackBoardMsg(pOwner, szMsg)
      local nType = tbGuoQing2012:GetEventStepInfo(pOwner, nNextState)
      pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_EVENT_IGINITE_TIME, 0)
      pPartner.SetTask(self.TASK_GROUP_ID, self.TASK_EVENT_IGINITE_TIME, 0)
      self:SetEventState(pOwner, nNextState)
      local pItem = pOwner.AddItem(unpack(self.ITEMID_AWARD_STEP[nType]))
      if pItem then
        pItem.Bind(1)
        local nDate = tonumber(GetLocalDate("%Y%m%d"))
        local nValidTime = Lib:GetDate2Time(nDate) + 24 * 3600 - 1
        pPlayer.SetItemTimeout(pItem, os.date("%Y/%m/%d/%H/%M/%S", nValidTime))
        pItem.Sync()
        local szMsg = string.format("你获得一个%s，小女孩正找你要托付下一件重要的事情！", pItem.szName)
        pOwner.Msg(szMsg)
      else
        Dbg:WriteLog("guoqing2012 Add award faile", pOwner.szName, nNextState, nType)
      end
      local _, nX, nY = pNpc.GetWorldPos()
      local nHelpCount = self:GetHelpIgniteCount(pHelper)
      if nHelpCount < self.MAX_DAY_HELP_IGNITE_COUNT then
        if self.AWARD_VALUE_HELP_IGNITE + pHelper.GetBindMoney() <= pHelper.GetMaxCarryMoney() then
          self:AddHelpIgniteCount(pHelper, 1)
          pHelper.AddBindMoney(self.AWARD_VALUE_HELP_IGNITE)
          pHelper.Msg(string.format("你帮助好友点燃了烟花，获得了%s绑银", self.AWARD_VALUE_HELP_IGNITE))
        end
      end
      pNpc.CastSkill(self.SKILLID_FIREWORKS[nType], 1, nX * 32, nY * 32, 1)
      local szItemName = "国庆小炮竹"
      if nType == 2 then
        szItemName = "国庆皇家礼炮"
      end
      pOwner.SendMsgToFriend(string.format("您的好友[<color=yellow>%s<color>]点燃了%s。", pOwner.szName, szItemName))
      StatLog:WriteStatLog("stat_info", "midautunm2012", "use_tool", pOwner.nId, string.format("18_1_1808_%s", nType), nType)
    end
  else
    pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_EVENT_IGINITE_TIME, nNowTime)
    if nIsOwner ~= 1 then
      tbFireworksInfo.nFriendTime = nNowTime
    else
      tbFireworksInfo.nOwnerTime = nNowTime
    end
    pPlayer.Msg("你成功点燃了烟花，等待你的队友点燃。")
    Timer:Register(self.INTERVAL_IGNITEFIREWORKS * 18, self.IgniteFireworksOverdue, self, pNpc.dwId, pOwner.nId, pHelper.nId, nNextState, nType)
  end
end

-- 释放烟花过期
function tbGuoQing2012:IgniteFireworksOverdue(dwNpcId, nPlayerId, nPartnerId, nNextState, nType)
  local pNpc = KNpc.GetById(dwNpcId)
  if not pNpc then
    return 0
  end
  local tbFireworksInfo = pNpc.GetTempTable("Npc").tbInfo
  if not tbFireworksInfo then
    return 0
  end
  tbFireworksInfo.nFriendTime = nil
  tbFireworksInfo.nOwnerTime = nil
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return 0
  end
  local pPartner = KPlayer.GetPlayerObjById(nPartnerId)
  if not pPartner then
    return 0
  end
  if tbFireworksInfo.nIgniteFlag ~= 1 then
    pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_EVENT_IGINITE_TIME, 0)
    pPartner.SetTask(self.TASK_GROUP_ID, self.TASK_EVENT_IGINITE_TIME, 0)
    pPlayer.Msg("操作失败，请2人同时点燃")
    pPartner.Msg("操作失败，请2人同时点燃")
    Dialog:SendBlackBoardMsg(pPlayer, "操作失败，请2人同时点燃")
    Dialog:SendBlackBoardMsg(pPartner, "操作失败，请2人同时点燃")
    StatLog:WriteStatLog("stat_info", "midautunm2012", "use_tool", pPlayer.nId, string.format("18_1_1808_%s", nType), 0)
  end
  return 0
end

-- 赠送月饼
function tbGuoQing2012:PresentMoonCake(nPlayerId, nType, nFlag)
  if tbGuoQing2012:CheckIsOpen() ~= 1 then
    return
  end
  if tbGuoQing2012:CheckActivityTime() ~= 1 then
    return
  end
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return
  end
  local szMapTyp = GetMapType(pPlayer.nMapId)
  if szMapTyp ~= "village" and szMapTyp ~= "city" then
    pPlayer.Msg("只有在城市或者新手村才能赠送。")
    Dialog:SendBlackBoardMsg(pPlayer, "只有在城市或者新手村才能赠送。")
    return
  end
  local pPartner = self:GetPartner(pPlayer)
  if not pPartner then
    pPlayer.Msg("必须双人组队才能赠送。")
    Dialog:SendBlackBoardMsg(pPlayer, "必须双人组队才能赠送。")
    return
  end
  local nMapId1, nPosX1, nPosY1 = pPlayer.GetWorldPos()
  local nMapId2, nPosX2, nPosY2 = pPartner.GetWorldPos()
  if nMapId1 ~= nMapId2 then
    pPlayer.Msg("队友离你太远了，无法赠送月饼。")
    Dialog:SendBlackBoardMsg(pPlayer, "队友离你太远了，无法赠送月饼。")
    return
  end
  if (nPosX1 - nPosX2) * (nPosX1 - nPosX2) + (nPosY1 - nPosY2) * (nPosY1 - nPosY2) > 30 * 30 then
    pPlayer.Msg("队友离你太远了，无法赠送月饼。")
    Dialog:SendBlackBoardMsg(pPlayer, "队友离你太远了，无法赠送月饼。")
    return
  end
  if self:GetReceiveCakeCount(pPartner) >= self.MAX_DAY_RECEIVE_CAKE_COUNT then
    pPlayer.Msg("队友今天已经收到很多月饼了，还是换个人送吧！")
    Dialog:SendBlackBoardMsg(pPlayer, "队友今天已经收到很多月饼了，还是换个人送吧！")
    return
  end
  -- 检查被送对象的门派是否满足条件
  local nNeedFaction = pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_EVENT_STEP_PARAM)
  if nNeedFaction ~= pPartner.nFaction then
    local szMsg = string.format("门派不对，该月饼只能送给%s的侠士", Player:GetFactionRouteName(nNeedFaction))
    pPlayer.Msg(szMsg)
    Dialog:SendBlackBoardMsg(pPlayer, szMsg)
    return
  end
  if pPartner.CountFreeBagCell() < 1 then
    pPlayer.Msg("队友背包空间不足，请对方先清理背包。")
    Dialog:SendBlackBoardMsg(pPlayer, "队友背包空间不足，请对方先清理背包。")
    return
  end
  if pPlayer.CountFreeBagCell() < 1 then
    pPlayer.Msg("背包空间不足，请整理后再送吧！")
    Dialog:SendBlackBoardMsg(pPlayer, "背包空间不足，请整理后再送吧！")
    return
  end
  local nState = tbGuoQing2012:GetEventState(pPlayer)
  local nNextState = nState + 1
  if nState ~= 2 then
    return
  end
  if tbGuoQing2012:GetEventStepInfo(pPlayer, nNextState) ~= nType then
    return
  end
  local tbFind, tbNeedItem = self:FindStepNeedItem(pPlayer, nNextState, nType)
  if #tbFind <= 0 then
    pPlayer.Msg("找不到月饼")
    Dialog:SendBlackBoardMsg(pPlayer, "找不到月饼")
    return
  end
  if not nFlag then
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
    GeneralProcess:StartProcess("赠送中", 5 * Env.GAME_FPS, { self.PresentMoonCake, self, nPlayerId, nType, 1 }, nil, tbEvent)
    return
  end
  local szItemName = tbFind[1].pItem.szName
  pPlayer.DelItem(tbFind[1].pItem)
  self:SetEventState(pPlayer, nNextState)
  local nDate = tonumber(GetLocalDate("%Y%m%d"))
  local nValidTime = Lib:GetDate2Time(nDate) + 24 * 3600 - 1
  local pItem1 = pPlayer.AddItem(unpack(self.ITEMID_AWARD_STEP[nType]))
  if pItem1 then
    pItem1.Bind(1)
    pPlayer.SetItemTimeout(pItem1, os.date("%Y/%m/%d/%H/%M/%S", nValidTime))
    pItem1.Sync()
    local szMsg = string.format("你获得一个%s，小女孩今日委托已完成", pItem1.szName)
    pPlayer.Msg(szMsg)
    Dialog:SendBlackBoardMsg(pPlayer, szMsg)
  else
    Dbg:WriteLog("guoqing2012 Add self cake faile", pPlayer.szName, nNextState, nType)
  end
  pPlayer.SendMsgToFriend(string.format("您的好友[<color=yellow>%s<color>]给神秘人赠送了%s。", pPlayer.szName, szItemName))
  local pItem2 = pPartner.AddItem(unpack(self.ITEMID_AWARD_MOONCAKE))
  if pItem2 then
    pItem2.Bind(1)
    pPartner.SetItemTimeout(pItem2, os.date("%Y/%m/%d/%H/%M/%S", nValidTime))
    pItem2.Sync()
    self:AddReciveCakeCount(pPartner)
    local szMsg = string.format("收到一个%s", pItem2.szName)
    pPartner.Msg(szMsg)
    Dialog:SendBlackBoardMsg(pPartner, szMsg)
    StatLog:WriteStatLog("stat_info", "midautunm2012", "get_mooncake", pPartner.nId, 1)
  else
    Dbg:WriteLog("guoqing2012 Add partner cake faile", pPartner.szName, nNextState, nType)
  end
  StatLog:WriteStatLog("stat_info", "midautunm2012", "use_tool", pPlayer.nId, string.format("%s_%s_%s_%s", unpack(tbNeedItem)), nType)
end

-- 设置回流卡片的值,0:初始状态，1：正常， 2：非正常开启
function tbGuoQing2012:SetHuiLiuCardInfo(pPlayer, nLevel, nValue)
  if nLevel < 1 or nLevel > 5 then
    assert(false)
    return
  end

  local nTaskValue = pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_HUILIU_STATE)
  local tbStepValue = {}
  for i = 1, 5 do
    if i > 1 then
      nTaskValue = math.floor(nTaskValue / 10)
    end
    tbStepValue[i] = math.mod(nTaskValue, 10)
  end
  tbStepValue[nLevel] = nValue
  nTaskValue = 0
  for i = 5, 1, -1 do
    nTaskValue = nTaskValue * 10 + tbStepValue[i]
  end
  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_HUILIU_STATE, nTaskValue)
end

-- 获取回流卡的表
function tbGuoQing2012:GetHuiLiuCardInfo(pPlayer)
  local nTaskValue = pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_HUILIU_STATE)
  local tbStepValue = {}
  for i = 1, 5 do
    if i > 1 then
      nTaskValue = math.floor(nTaskValue / 10)
    end
    tbStepValue[i] = math.mod(nTaskValue, 10)
  end
  return tbStepValue
end

-- 开回流卡片
function tbGuoQing2012:OpenHuiLiuCard(nPlayerId, nLevel, nType)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return
  end
  if self:CheckIsOpen() ~= 1 then
    return
  end
  local tbItem = { unpack(tbGuoQing2012.ITEMID_HUANGDUGUOQING) }
  tbItem[4] = nLevel
  local nDate = tonumber(GetLocalDate("%Y%m%d"))
  if nDate < tbGuoQing2012.HUANDUGUOQING_OPENDAY[nLevel] then
    return
  end
  local nCheckType = 0
  if nDate == tbGuoQing2012.HUANDUGUOQING_OPENDAY[nLevel] then
    nCheckType = 1
  else
    nCheckType = 2
  end
  if nCheckType ~= nType then
    return
  end
  local tbFind = pPlayer.FindItemInBags(unpack(tbItem))
  if #tbFind <= 0 then
    return
  end
  pPlayer.DelItem(tbFind[1].pItem)
  local nRand = MathRandom(self.AWARD_VALUE_OPEN_CARD[1], self.AWARD_VALUE_OPEN_CARD[2])
  if nType == 1 then
    self:SetHuiLiuCardInfo(pPlayer, nLevel, 1)
    pPlayer.AddBindCoin(nRand)
    pPlayer.SendMsgToFriend(string.format("您的好友[<color=yellow>%s<color>]开启了今日%s获得了丰厚的奖励。", pPlayer.szName, self.HUANDUGUOQING_CARDNAME[nLevel]))
  else
    self:SetHuiLiuCardInfo(pPlayer, nLevel, 2)
    nRand = math.floor(nRand / 2)
    pPlayer.AddBindCoin(nRand)
  end
  StatLog:WriteStatLog("stat_info", "midautunm2012", "light_card ", pPlayer.nId, nLevel, "BindCoin", nRand)
end

--获取回流卡片最终大奖
function tbGuoQing2012:GetHuiLiuCardFinalAward(nPlayerId, nCheckAwardFlag)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return
  end
  local nAwardFlag = 1
  local tbCardInfo = tbGuoQing2012:GetHuiLiuCardInfo(pPlayer)
  for i = 1, #tbCardInfo do
    if tbCardInfo[i] == 0 then
      return
    end
    if tbCardInfo[i] == 2 then
      nAwardFlag = 2
      break
    end
  end
  if nCheckAwardFlag ~= nAwardFlag then
    return
  end
  if pPlayer.CountFreeBagCell() < 1 then
    pPlayer.Msg("背包空间不足，需要1个背包空间")
    Dialog:SendBlackBoardMsg(pPlayer, "背包空间不足，需要1个背包空间")
    return
  end
  local tbFind = pPlayer.FindItemInBags(unpack(self.ITEMID_HUILIUAWARD_CARD))
  if #tbFind <= 0 then
    return
  end
  if nAwardFlag == 2 then
    if pPlayer.nCoin < self.HUILIU_COST_COIN_NUM then
      Dialog:SendBlackBoardMsg(pPlayer, "你的金币不足")
      return
    end
  end
  pPlayer.DelItem(tbFind[1].pItem)
  if nAwardFlag == 2 then
    pPlayer.ApplyAutoBuyAndUse(self.IBSHOP_HUILIUAWARD_FINALAWARD, 1, 0)
    StatLog:WriteStatLog("stat_info", "midautunm2012", "light_book", pPlayer.nId, self.HUILIU_COST_COIN_NUM)
  else
    local pItem = pPlayer.AddItem(unpack(self.ITEMID_HUILIU_FINALAWARD))
    if pItem then
      pItem.Bind(1)
      pPlayer.SetItemTimeout(pItem, os.date("%Y/%m/%d/%H/%M/%S", GetTime() + 7 * 24 * 3600))
      pItem.Sync()
    else
      Dbg:WriteLog("guoqing2012", "add huiliu final award fail", pPlayer.szName)
    end
    StatLog:WriteStatLog("stat_info", "midautunm2012", "light_book", pPlayer.nId, 0)
  end
  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_HUILIU_STATE, 0)
end

-- 判断奖励最大银两
function tbGuoQing2012:GetMaxMoney(tbAward)
  local nMaxValue = 0
  for _, tbInfo in ipairs(tbAward) do
    if tbInfo[1] == "绑银" and nMaxValue < tbInfo[2] then
      nMaxValue = tbInfo[2]
    end
  end
  return nMaxValue
end

-- 随机奖励
function tbGuoQing2012:RandomAward(pPlayer, tbAward, nLogType)
  nLogType = nLogType or 0
  local nRate = MathRandom(1000000)
  local nAdd = 0
  local nFind = 0
  for i, tbInfo in ipairs(tbAward) do
    nAdd = nAdd + tbInfo[3]
    if nRate <= nAdd then
      nFind = i
      break
    end
  end
  if nFind > 0 then
    local tbFind = tbAward[nFind]
    if tbFind[1] == "玄晶" then
      pPlayer.AddItemEx(18, 1, 114, tbFind[2])
      StatLog:WriteStatLog("stat_info", "midautunm2012", "use_awardtool", pPlayer.nId, nLogType, string.format("%s_%s_%s_%s", 18, 1, 114, tbFind[2]), 1)
    elseif tbFind[1] == "绑金" then
      pPlayer.AddBindCoin(tbFind[2])
      StatLog:WriteStatLog("stat_info", "midautunm2012", "use_awardtool", pPlayer.nId, nLogType, "BindCoin", tbFind[2])
    elseif tbFind[1] == "绑银" then
      pPlayer.AddBindMoney(tbFind[2])
      StatLog:WriteStatLog("stat_info", "midautunm2012", "use_awardtool", pPlayer.nId, nLogType, "BindMoney", tbFind[2])
    end
  end
end

-- 随机跟宠
function tbGuoQing2012:RandPet(pPlayer)
  if pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_AWARD_PET) == 1 then
    return
  end
  local nRand = MathRandom(100)
  if nRand <= self.RAND_AWARD_PET then
    local pItem = pPlayer.AddItem(unpack(self.ITEMID_PET))
    if pItem then
      pItem.Bind(1)
      pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_AWARD_PET, 1)
      pPlayer.SendMsgToFriend(string.format("您的好友[<color=yellow>%s<color>]打开金漆锦盒获得了<color=green>【葫小芦·跟宠】<color>。", pPlayer.szName))
      Player:SendMsgToKinOrTong(pPlayer, "打开金漆锦盒获得了【葫小芦·跟宠】。", 1)
      --Dialog:GlobalNewsMsg_GS(string.format("%s打开金漆锦盒获得了【葫小芦·跟宠】", pPlayer.szName));
      GCExcute({ "Dialog:GlobalNewsMsg_GC", string.format("%s打开金漆锦盒获得了【葫小芦·跟宠】", pPlayer.szName) })
    else
      Dbg:WriteLog("guoqing2012", "add pet fail", pPlayer.szName)
    end
    StatLog:WriteStatLog("stat_info", "midautunm2012", "use_awardtool", pPlayer.nId, 3, string.format("%s_%s_%s_%s", unpack(self.ITEMID_PET)), 1)
  end
end

-- 随机面具或者马牌
function tbGuoQing2012:RandExtendAward(pPlayer)
  local nRand = MathRandom(1000)
  if nRand <= self.RAND_AWARD_EXTEND then
    local nIndex = MathRandom(#self.ITEMID_EXTENDAWARD)
    local pItem = pPlayer.AddItem(unpack(self.ITEMID_EXTENDAWARD[nIndex][pPlayer.nSex]))
    if pItem then
      pPlayer.SetItemTimeout(pItem, os.date("%Y/%m/%d/%H/%M/%S", GetTime() + self.ITEMID_EXTENDAWARD[nIndex][2]))
      pItem.Sync()
      pPlayer.SendMsgToFriend(string.format("您的好友[<color=yellow>%s<color>]打开金漆锦盒获得了<color=green>%s<color>。", pPlayer.szName, pItem.szName))
      Player:SendMsgToKinOrTong(pPlayer, string.format("打开金漆锦盒获得了<color=green>%s<color>。", pItem.szName), 1)
      --Dialog:GlobalNewsMsg_GS(string.format("%s打开金漆锦盒获得了%s", pPlayer.szName, pItem.szName));
      GCExcute({ "Dialog:GlobalNewsMsg_GC", string.format("%s打开金漆锦盒获得了%s", pPlayer.szName, pItem.szName) })
    else
      Dbg:WriteLog("guoqing2012", "add extendaward fail", pPlayer.szName, nIndex)
    end
    StatLog:WriteStatLog("stat_info", "midautunm2012", "use_awardtool", pPlayer.nId, 3, string.format("%s_%s_%s_%s", unpack(self.ITEMID_EXTENDAWARD[nIndex][pPlayer.nSex])), 1)
  end
end
