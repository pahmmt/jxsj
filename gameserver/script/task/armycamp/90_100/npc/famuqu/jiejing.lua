local tbNpc = Npc:GetClass("jiejing")

function tbNpc:OnDialog()
  local nSubWorld, _, _ = him.GetWorldPos()
  local tbInstancing = Task.tbArmyCampInstancingManager:GetInstancing(nSubWorld)

  local szMsg = "这是一条通往犀角矿和乱石滩的捷径，如果你或你的队友已经开启了通关的条件，便可以通过这条捷径直接前往那里。但需支付500两银子。"
  local tbOpt = {
    { "我要前往犀角矿", tbNpc.JieJing, self, 1, tbInstancing, me.nId },
    { "我要前往乱石滩", tbNpc.JieJing, self, 2, tbInstancing, me.nId },
    { "结束对话" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:JieJing(nPosType, tbInstancing, nPlayerId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return
  end

  if pPlayer.nCashMoney < 500 then
    Task.tbArmyCampInstancingManager:Warring(pPlayer, "你身上的钱不够！")
    return
  end

  if nPosType == 1 and tbInstancing.nFaMuQuTrapOpen == 1 then
    assert(pPlayer.CostMoney(500, Player.emKPAY_CAMPSEND) == 1)
    pPlayer.NewWorld(tbInstancing.nMapId, 1919, 3308)
    pPlayer.SetFightState(1)
    return
  elseif nPosType == 2 and tbInstancing.nCaiKuangQuPass == 1 then
    assert(pPlayer.CostMoney(500, Player.emKPAY_CAMPSEND) == 1)
    pPlayer.NewWorld(tbInstancing.nMapId, 1668, 3764)
    pPlayer.SetFightState(1)
    return
  end

  Task.tbArmyCampInstancingManager:Warring(pPlayer, "只有通过关卡之后才可使用捷径")
end
