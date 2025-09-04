-- 文件名　：paotai.lua
-- 创建者　：LQY
-- 创建时间：2012-07-26 10:28:03
-- 说　　明：炮台逻辑
-- 这一个就不卖萌了

--宋军炮台
local tbNpc = Npc:GetClass("NewBattle_paotai")

-- 死亡事件
function tbNpc:OnDeath(pNpcKiller)
  local nMapId = him.GetWorldPos()
  if not NewBattle.tbMission[nMapId] or NewBattle.tbMission[nMapId]:IsOpen() ~= 1 then
    return
  end
  NewBattle.tbMission[nMapId]:OnNpcDeath("PAOTAI", pNpcKiller, him)
  local tbInfo = him.GetTempTable("Npc")
  NewBattle.tbMission[nMapId]:PaoTaiOnDeath(tbInfo.nNum, tbInfo.nPower)
end
