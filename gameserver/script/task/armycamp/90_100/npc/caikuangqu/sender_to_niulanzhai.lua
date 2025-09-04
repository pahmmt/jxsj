-- 牛栏寨
-- 上交指定数目的材料可以到下一关
local tbNpc = Npc:GetClass("qianlai")

tbNpc.tbNeedItemList = {
  { 20, 1, 485, 1, 2 },
}

function tbNpc:OnDialog()
  local nSubWorld, _, _ = him.GetWorldPos()
  local tbInstancing = Task.tbArmyCampInstancingManager:GetInstancing(nSubWorld)
  assert(tbInstancing)

  if tbInstancing.nNiuLanZhaiPass ~= 1 then
    Dialog:Say("钱莱：“我等奉胡嘉大人之命混入牛栏寨刺探消息，有幸成为看守大门的哨兵。你既然是义军兄弟，那就拿两块牛栏寨腰牌给我，这是胡大人下的命令，不然我也不能放你进入牛栏寨。”", {
      { "给钱莱两个牛栏寨腰牌", self.Give, self, tbInstancing, me.nId },
      { "结束对话" },
    })
  end
end

function tbNpc:Give(tbInstancing, nPlayerId)
  Task:OnGift("交给钱莱两块牛栏寨腰牌便可自由出入于牛栏寨。", self.tbNeedItemList, { self.Pass, self, tbInstancing, nPlayerId }, nil, { self.CheckRepeat, self, tbInstancing })
end

function tbNpc:Send(tbInstancing)
  --me.NewWorld(tbInstancing.nMapId, 1911, 3000);
end

function tbNpc:Pass(tbInstancing, nPlayerId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  tbInstancing.nNiuLanZhaiPass = 1
  local pNpc = KNpc.GetById(tbInstancing.nNiuLanZhaiLaoMenId)
  if pNpc then
    pNpc.Delete()
  end

  if pPlayer then
    Task.tbArmyCampInstancingManager:ShowTip(pPlayer, "我现在可以放心的去牛栏寨了")
  end
end

function tbNpc:CheckRepeat(tbInstancing)
  if tbInstancing.nNiuLanZhaiPass == 1 then
    return 0
  end

  return 1
end
