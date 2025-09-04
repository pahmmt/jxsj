-------------------------------------------------------
-- 文件名　：zhunbeiqunpc.lua
-- 文件描述：准备区NPC脚本
-- 创建者　：ZhangDeheng
-- 创建时间：2009-03-16 09:17:36
-------------------------------------------------------

-- 路路通
local tbNpc = Npc:GetClass("hl_lulutong")
-- 传送的位置
tbNpc.tbPos = {
  { "一层", 1841, 3210 },
  { "二层", 1883, 3452 },
  { "三层", 1819, 3647 },
}
tbNpc.tbPosKuoZhanQu = {
  { "象棋盘", 53696 / 32, 115104 / 32 },
  { "镜中人", 52288 / 32, 109760 / 32 },
  { "追捕留一半", 54144 / 32, 124160 / 32 },
}

function tbNpc:OnDialog()
  local nSubWorld, _, _ = him.GetWorldPos()
  local tbInstancing = Task.tbArmyCampInstancingManager:GetInstancing(nSubWorld)
  assert(tbInstancing)

  local szMsg = "这是一条通往副本内各个地方的捷径，如果你或你的队友已经开启了通关的条件，便可以通过这条捷径直接前往那里。但需支付500两银子。"
  local tbOpt = {}
  for i = 1, #self.tbPos do
    tbOpt[#tbOpt + 1] = { "前往" .. self.tbPos[i][1], tbNpc.Send, self, i, tbInstancing, me.nId }
  end
  if tbInstancing.tbKuoZhanQuOut[1] == 1 then
    tbOpt[#tbOpt + 1] = { "前往" .. self.tbPosKuoZhanQu[1][1], tbNpc.Send, self, 4, tbInstancing, me.nId }
  end
  if tbInstancing.tbKuoZhanQuOut[2] == 1 then
    tbOpt[#tbOpt + 1] = { "前往" .. self.tbPosKuoZhanQu[2][1], tbNpc.Send, self, 5, tbInstancing, me.nId }
  end
  if tbInstancing.tbKuoZhanQuOut[3] == 1 then
    tbOpt[#tbOpt + 1] = { "前往" .. self.tbPosKuoZhanQu[3][1], tbNpc.Send, self, 6, tbInstancing, me.nId }
  end

  tbOpt[#tbOpt + 1] = { "结束对话" }
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:Send(nPos, tbInstancing, nPlayerId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return
  end

  if pPlayer.nCashMoney < 500 then
    Task.tbArmyCampInstancingManager:Warring(pPlayer, "你身上的钱不够！")
    return
  end

  if nPos == 1 and tbInstancing.nTrap2Pass == 1 then
    self:SendToNewPos(nPos, tbInstancing.nMapId, nPlayerId)
    tbInstancing:OnCoverBegin(pPlayer)
    return
  elseif nPos == 2 and tbInstancing.nTrap4Pass == 1 then
    self:SendToNewPos(nPos, tbInstancing.nMapId, nPlayerId)
    tbInstancing:OnCoverBegin(pPlayer)
    return
  elseif nPos == 3 and tbInstancing.nTrap6Pass == 1 then
    self:SendToNewPos(nPos, tbInstancing.nMapId, nPlayerId)
    return
  elseif nPos == 4 then
    self:SendToNewPos(4, tbInstancing.nMapId, nPlayerId)
    return
  elseif nPos == 5 then
    self:SendToNewPos(5, tbInstancing.nMapId, nPlayerId)
    return
  elseif nPos == 6 then
    self:SendToNewPos(6, tbInstancing.nMapId, nPlayerId)
    return
  end

  Task.tbArmyCampInstancingManager:Warring(pPlayer, "只有通过关卡之后才可使用捷径")
end

function tbNpc:SendToNewPos(nPos, nMapId, nPlayerId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return
  end

  assert(pPlayer.CostMoney(500, Player.emKPAY_CAMPSEND) == 1)
  if nPos <= 3 then
    pPlayer.NewWorld(pPlayer.nMapId, tbNpc.tbPos[nPos][2], tbNpc.tbPos[nPos][3])
  elseif nPos <= 6 then
    pPlayer.NewWorld(pPlayer.nMapId, tbNpc.tbPosKuoZhanQu[nPos - 3][2], tbNpc.tbPosKuoZhanQu[nPos - 3][3])
  end

  pPlayer.SetFightState(1)
end
