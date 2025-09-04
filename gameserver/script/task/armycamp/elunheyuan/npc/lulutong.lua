local tbNpc = Npc:GetClass("elunheyuan_lulutong")

-- 传送的位置
tbNpc.tbPos = {
  { "套马场", 1752, 3580 },
  { "祭祀场", 1755, 3423 },
  { "可汗大帐", 1694, 3258 },
}

function tbNpc:OnDialog()
  local nSubWorld, _, _ = him.GetWorldPos()
  local tbInstancing = Task.tbArmyCampInstancingManager:GetInstancing(nSubWorld)
  assert(tbInstancing)

  local szMsg = "这是一条通往副本内各个地方的捷径，如果你或你的队友已经开启了通关的条件，便可以通过这条捷径直接前往那里。"
  local tbOpt = {}
  for i = 1, #self.tbPos do
    tbOpt[#tbOpt + 1] = { "前往" .. self.tbPos[i][1], tbNpc.Send, self, i, tbInstancing, me.nId }
  end
  tbOpt[#tbOpt + 1] = { "结束对话" }
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:Send(nPos, tbInstancing, nPlayerId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return
  end
  -- 正在进行关卡游戏中不能传送
  for i = 1, #tbInstancing.tbTollgateReset do
    if tbInstancing.tbTollgateReset[i] == 0 then
      Task.tbArmyCampInstancingManager:Warring(pPlayer, "你的队友正在战斗中，还是等等过去吧")
      return
    end
  end
  if nPos == 1 and tbInstancing.tbTollgateReset[1] == 2 then
    self:SendToNewPos(nPos, tbInstancing.nMapId, nPlayerId, 0)
    return
  elseif nPos == 2 and tbInstancing.tbTollgateReset[3] == 2 then
    self:SendToNewPos(nPos, tbInstancing.nMapId, nPlayerId, 0)
    return
  elseif nPos == 3 and tbInstancing.tbTollgateReset[5] == 2 then
    self:SendToNewPos(nPos, tbInstancing.nMapId, nPlayerId, 0)
    return
  end
  Task.tbArmyCampInstancingManager:Warring(pPlayer, "只有通过关卡之后才可使用捷径")
end

function tbNpc:SendToNewPos(nPos, nMapId, nPlayerId, nFightState)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return
  end

  pPlayer.NewWorld(pPlayer.nMapId, tbNpc.tbPos[nPos][2], tbNpc.tbPos[nPos][3])

  pPlayer.SetFightState(nFightState)
end
