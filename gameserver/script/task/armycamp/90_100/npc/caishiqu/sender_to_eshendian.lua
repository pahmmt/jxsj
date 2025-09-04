-- 传送去鳄神殿的Npc

-- 上交指定数目的材料可以到下一关
local tbNpc = Npc:GetClass("yunxiaodao")

tbNpc.tbNeedItemList = {
  { 20, 1, 486, 1, 2 },
}

function tbNpc:OnDialog()
  local nSubWorld, _, _ = him.GetWorldPos()
  local tbInstancing = Task.tbArmyCampInstancingManager:GetInstancing(nSubWorld)
  assert(tbInstancing)

  if tbInstancing.nEShenDianPass == 1 then
    Dialog:Say("是否这就去鳄神殿。", {
      { "前往鳄神殿", self.Send, self, tbInstancing, me.nId },
      { "结束对话" },
    })
  else
    Dialog:Say("云小刀：“真是奇哉怪也，这里竟然会留下这么一座上古的鳄神殿，这里面一定有什么秘密。我等兄弟费了好大力气才打开了神殿入口，你若是想进入，就拿两把迷宫钥匙给我，就算是个辛苦钱吧！”", {
      { "给云小刀两把迷宫钥匙", self.Give, self, tbInstancing, me.nId },
      { "结束对话" },
    })
  end
end

function tbNpc:Give(tbInstancing, nPlayerId)
  Task:OnGift("交给云小刀两把迷宫钥匙便可在他的带领下进入鳄神殿", self.tbNeedItemList, { self.Pass, self, tbInstancing, nPlayerId }, nil, { self.CheckRepeat, self, tbInstancing })
end

function tbNpc:Send(tbInstancing)
  me.NewWorld(tbInstancing.nMapId, 1819, 3941)
end

function tbNpc:Pass(tbInstancing, nPlayerId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  tbInstancing.nEShenDianPass = 1
  if pPlayer then
    Task.tbArmyCampInstancingManager:ShowTip(pPlayer, "我现在放心的去鳄神殿了")
  end
end

function tbNpc:CheckRepeat(tbInstancing)
  if tbInstancing.nEShenDianPass == 1 then
    return 0
  end

  return 1
end
