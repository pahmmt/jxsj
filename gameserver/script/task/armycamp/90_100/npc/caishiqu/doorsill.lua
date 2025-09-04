-- 上交指定数目的材料可以到下一关
local tbNpc = Npc:GetClass("caishiqudoorsill")

tbNpc.tbNeedItemList = {
  { 20, 1, 603, 1, 10 },
}

function tbNpc:OnDialog()
  local nSubWorld, _, _ = him.GetWorldPos()
  local tbInstancing = Task.tbArmyCampInstancingManager:GetInstancing(nSubWorld)
  assert(tbInstancing)

  if tbInstancing.nCaiShiQuColItem == 1 then
    Task.tbArmyCampInstancingManager:ShowTip(me, "切石器已经被损坏")
    return
  end

  Dialog:Say("在机器中放入十枚取自采石工匠的“刀具”可将其损坏，届时大工匠便会闻声而出。", {
    { "投入道具", self.Destroy, self, tbInstancing },
    { "结束对话" },
  })
end

function tbNpc:Destroy(tbInstancing)
  if tbInstancing.nCaiShiQuColItem ~= 1 then
    Task:OnGift("从采石工匠处取得10枚刀具放入，可毁坏切石器。", self.tbNeedItemList, { self.PassCaiKuangQu, self, tbInstancing }, nil, { self.CheckRepeat, self, tbInstancing })
  end
end

function tbNpc:PassCaiKuangQu(tbInstancing)
  TaskAct:Talk("<npc=4002>:“你们这帮蠢材，又干了什么好事？看我不好好教训你们。”")
  tbInstancing.nCaiShiQuColItem = 1
  local pNpc = KNpc.Add2(4002, tbInstancing.nNpcLevel, -1, tbInstancing.nMapId, 1696, 3880)
  if pNpc then
    local nRand = MathRandom(3)
    Task.ArmyCamp:StartTrigger(pNpc.dwId, nRand)
  end
end

function tbNpc:CheckRepeat(tbInstancing)
  if tbInstancing.nCaiShiQuColItem == 1 then
    return 0
  end

  return 1
end
