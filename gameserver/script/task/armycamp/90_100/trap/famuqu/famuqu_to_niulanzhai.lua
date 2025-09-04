--伐木区--牛栏寨

local tbMap = Map:GetClass(557)
local tbTrap_1 = tbMap:GetTrapClass("to_niulanzhai")

function tbTrap_1:OnPlayer()
  local nSubWorld, _, _ = me.GetWorldPos()
  local tbInstancing = Task.tbArmyCampInstancingManager:GetInstancing(nSubWorld)
  assert(tbInstancing)
  if tbInstancing.nNiuLanZhaiPass ~= 1 then
    me.NewWorld(nSubWorld, 1867, 3189)
    Task.tbArmyCampInstancingManager:ShowTip(me, "请找钱莱带路进入牛栏寨")
  end
end
