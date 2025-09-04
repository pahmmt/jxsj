-- 文件名　：pray_2012.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-12-07 15:27:10
-- 功能说明：2012.12月新服活动-祈福2012

local tbItem = Item:GetClass("xmas_2012_pray")
tbItem.nTaskGroupId = 2216
tbItem.nFactionStartTask = 21
tbItem.nFactionEndTask = 33

tbItem.tbNpcTemplateId = { [11309] = 1, [11310] = 1 }
tbItem.nTemplateId = 11308

tbItem.nUseTime = { 20121219, 20121221 }

tbItem.nNpcLiveTime = 60 * Env.GAME_FPS

tbItem.nArrowTime = 5 * Env.GAME_FPS

tbItem.nSkillId = 1979 --技能id

tbItem.tbEvent = {
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
  Player.ProcessBreakEvent.emEVENT_ATTACKED,
  Player.ProcessBreakEvent.emEVENT_DEATH,
  Player.ProcessBreakEvent.emEVENT_LOGOUT,
}

function tbItem:OnUse(nNpcId)
  local nNowDate = tonumber(GetLocalDate("%Y%m%d"))
  if nNowDate < self.nUseTime[1] then
    Dialog:SendBlackBoardMsg(me, "祈福2012活动还未开始，请稍后。")
    return 0
  end
  if me.nLevel < 20 then
    Dialog:SendBlackBoardMsg(me, "你的等级不足20级。")
    return 0
  end
  if nNowDate > self.nUseTime[2] then --领取奖励
    return self:GetAward()
  else
    local nFlag = 1
    for i = self.nFactionStartTask, self.nFactionEndTask do
      if me.GetTask(self.nTaskGroupId, i) <= 0 then
        nFlag = 0
        break
      end
    end
    if nFlag == 1 then
      Dialog:SendBlackBoardMsg(me, "您已经收集满所有门派的祝福了，请于2012年12月22日00:00分后使用。")
      return 0
    end
  end

  local nMapId, nX, nY = me.GetWorldPos()
  local szMapType = GetMapType(nMapId)
  if szMapType ~= "village" and szMapType ~= "city" then
    Dialog:SendBlackBoardMsg(me, "该道具只能在新手村和各大城市使用！")
    return 0
  end

  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    Dialog:SendBlackBoardMsg(me, "对不起，你没有目标是不能使用的！")
    return 0
  end
  local pPlayer = pNpc.GetPlayer()
  if not pPlayer then
    Dialog:SendBlackBoardMsg(me, "该道具只能对玩家使用。")
    return 0
  end
  self:CollectPray(me.nId, pPlayer.nId)
end

function tbItem:CollectPray(nPlayerId, nTargePlayerId, nFlag)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return 0
  end
  local tbNpcList = KNpc.GetAroundNpcList(pPlayer, 10)
  for _, pNpc in ipairs(tbNpcList) do
    if pNpc.nKind == 3 or self.tbNpcTemplateId[pNpc.nTemplateId] then
      Dialog:SendBlackBoardMsg(pPlayer, "这里貌似太过拥挤了，还是换一个地方试试吧！")
      return 0
    end
  end
  local pTargerPlayer = KPlayer.GetPlayerObjById(nTargePlayerId)
  if not pTargerPlayer then
    return 0
  end
  local nFaction = pTargerPlayer.nFaction
  if nFaction <= 0 then
    Dialog:SendBlackBoardMsg(pPlayer, "该玩家没有门派还是换个玩家吧。")
    return 0
  end
  local nGetFlag = pPlayer.GetTask(self.nTaskGroupId, self.nFactionStartTask + nFaction - 1)
  if nGetFlag == 1 then
    Dialog:SendBlackBoardMsg(pPlayer, "您收集过该门派玩家的祝福了。")
    return 0
  end
  local nMapId1, nX1, nY1 = pPlayer.GetWorldPos()
  local nMapId2, nX2, nY2 = pTargerPlayer.GetWorldPos()

  if nMapId1 ~= nMapId2 or (nX1 - nX2) * (nX1 - nX2) + (nY1 - nY2) * (nY1 - nY2) > 100 then
    Dialog:SendBlackBoardMsg(pPlayer, "只有在玩家跟前才能收集祝福。")
    return 0
  end
  if not nFlag then
    GeneralProcess:StartProcess("收集祝福...", self.nArrowTime, { self.CollectPray, self, nPlayerId, nTargePlayerId, 1 }, nil, self.tbEvent)
    return
  end

  local nMapId, nX, nY = me.GetWorldPos()
  pPlayer.CastSkill(self.nSkillId + MathRandom(2), 1, nX * 32, nY * 32, 1) --放特效
  pPlayer.SetTask(self.nTaskGroupId, self.nFactionStartTask + nFaction - 1, 1)
  local szFactionName = Player.tbFactions[nFaction].szName
  Dialog:SendBlackBoardMsg(pPlayer, string.format("恭喜您成功收集<color=yellow>%s<color>玩家祝福。", szFactionName))
  return 0
end

function tbItem:GetAward()
  for i = self.nFactionStartTask, self.nFactionEndTask do
    if me.GetTask(self.nTaskGroupId, i) <= 0 then
      Dialog:SendBlackBoardMsg(me, "您未收集满所有门派的祝福。")
      return 0
    end
  end
  if me.CountFreeBagCell() < 1 then
    Dialog:SendBlackBoardMsg(me, "你身上的背包空间不足，需要1格背包空间。")
    return 0
  end
  me.AddSpeTitle("救世侠客", GetTime() + 7 * 3600 * 24, "pink")
  return Item:GetClass("randomitem"):SureOnUse(387)
end

function tbItem:InitGenInfo()
  it.SetTimeOut(0, GetTime() + 3600 * 24 * 7)
  return {}
end
