-- 文件名　：jianta.lua
-- 创建者　：LQY
-- 创建时间：2012-07-25 13:59:23
-- 说　　明：箭塔逻辑
-- 嗖嗖嗖嗖

--宋军箭塔
local tbNpc = Npc:GetClass("NewBattle_jianta")

-- 死亡事件
function tbNpc:OnDeath(pNpcKiller)
  local nMapId = him.GetWorldPos()
  if not NewBattle.tbMission[nMapId] or NewBattle.tbMission[nMapId]:IsOpen() ~= 1 then
    return
  end
  local tbInfo = him.GetTempTable("Npc")
  local szPower = NewBattle.POWER_ENAME[tbInfo.nPower]
  NewBattle.tbMission[nMapId].tbArrowLive[szPower][tbInfo.nNum] = 0
  NewBattle.tbMission[nMapId]:OnNpcDeath("JIANTA", pNpcKiller, him)
  --注册复活计时器
  if not tbInfo or not tbInfo.nNum or not tbInfo.nPower then
    return
  end
  NewBattle.tbMission[nMapId]:CreateTimer(NewBattle.SWORDREBORN, NewBattle.tbMission[nMapId].JianTaFuHuo, NewBattle.tbMission[nMapId], tbInfo.nNum, tbInfo.nPower)
  --pNpcKiller.CastSkill(2935,1,1,1);
end
