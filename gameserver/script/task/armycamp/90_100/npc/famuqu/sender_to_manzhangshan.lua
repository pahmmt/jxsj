-- 传送去蛮瘴山的Npc

-- 上交指定数目的材料可以到下一关
local tbNpc = Npc:GetClass("yundadao")

tbNpc.tbNeedItemList = {
  { 20, 1, 487, 1, 2 },
}

function tbNpc:OnDialog()
  local nSubWorld, _, _ = him.GetWorldPos()
  local tbInstancing = Task.tbArmyCampInstancingManager:GetInstancing(nSubWorld)
  assert(tbInstancing)

  if tbInstancing.nManZhangShanPass == 1 then
    Dialog:Say("是否这就去蛮瘴山。", {
      { "前往蛮瘴山", self.Send, self, tbInstancing, me.nId },
      { "结束对话" },
    })
  else
    Dialog:Say("云大刀：“此番我等兄弟几人前来蛮瘴山寻宝，费了好大力气才和这里的蛮人套好交情。你若想进蛮瘴山，我可以帮忙。不过我们快刀门以利当先，你要先给我找来两个骨玉图腾才行。”", {
      { "给云大刀两个骨玉图腾", self.Give, self, tbInstancing, me.nId },
      { "结束对话" },
    })
  end
end

function tbNpc:Give(tbInstancing, nPlayerId)
  Task:OnGift("交给云大刀两个骨玉图腾便可在他的带领下进入蛮瘴山。", self.tbNeedItemList, { self.Pass, self, tbInstancing, nPlayerId }, nil, { self.CheckRepeat, self, tbInstancing })
end

function tbNpc:Send(tbInstancing)
  me.NewWorld(tbInstancing.nMapId, 1911, 3000)
end

function tbNpc:Pass(tbInstancing, nPlayerId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  tbInstancing.nManZhangShanPass = 1
  if pPlayer then
    Task.tbArmyCampInstancingManager:ShowTip(pPlayer, "我现在放心的去蛮瘴山了")
  end
end

function tbNpc:CheckRepeat(tbInstancing)
  if tbInstancing.nManZhangShanPass == 1 then
    return 0
  end

  return 1
end
