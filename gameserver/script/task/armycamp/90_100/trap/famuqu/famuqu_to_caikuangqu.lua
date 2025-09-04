-- 伐木区到采矿区
local tbMap = Map:GetClass(557)
local tbTrap_1 = tbMap:GetTrapClass("to_caikuanqu")

function tbTrap_1:OnPlayer()
  local nSubWorld, _, _ = me.GetWorldPos()
  local tbInstancing = Task.tbArmyCampInstancingManager:GetInstancing(nSubWorld)
  assert(tbInstancing)

  if tbInstancing.nFaMuQuTrapOpen ~= 1 then
    me.NewWorld(me.nMapId, 1842, 3399)
    Task.tbArmyCampInstancingManager:ShowTip(me, "需要先杀死守矿的喽罗头目才可进入")
  else
    me.NewWorld(me.nMapId, 1913, 3316)
    Task.tbArmyCampInstancingManager:ShowTip(me, "进入犀角矿")
  end
end
