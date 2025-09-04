-- 文件名　：zhanche.lua
-- 创建者　：LQY
-- 创建时间：2012-07-25 13:51:49
-- 说　　明：战车逻辑
-- 嗒嗒滴 哒哒哒 达达嘟

-- 战车
local tbNpc = Npc:GetClass("NewBattle_zhanche")

-- 死亡事件
function tbNpc:OnDeath(pNpcKiller)
  local nMapId = him.GetWorldPos()
  if not NewBattle.tbMission[nMapId] or NewBattle.tbMission[nMapId]:IsOpen() ~= 1 then
    return
  end
  local tbInfo = him.GetTempTable("Npc")
  local szPower = NewBattle.POWER_ENAME[tbInfo.nPower]
  NewBattle.tbMission[nMapId]:OnNpcDeath("ZHANCHE", pNpcKiller, him)
  NewBattle.tbMission[nMapId]:DeleteCardwId(szPower, tbInfo.nNum)
  NewBattle.tbMission[nMapId].tbCarLive[szPower][tbInfo.nNum] = 0
end
