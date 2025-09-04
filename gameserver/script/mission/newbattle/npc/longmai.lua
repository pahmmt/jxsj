-- 文件名　：longmai.lua
-- 创建者　：LQY
-- 创建时间：2012-07-24 11:09:02
-- 说　　明：龙脉逻辑，死掉就判断胜负

local tbNpc = Npc:GetClass("NewBattle_longmai")
-- 龙脉宋死亡事件
function tbNpc:OnDeath(pNpcKiller)
  local nMapId = him.GetWorldPos()
  if not NewBattle.tbMission[nMapId] or NewBattle.tbMission[nMapId]:IsOpen() ~= 1 then
    return
  end
  local tbInfo = him.GetTempTable("Npc")
  local szPower = NewBattle.POWER_ENAME[tbInfo.nPower]
  NewBattle.tbMission[nMapId].tbLongMaiLive[szPower][1] = 0
  NewBattle.tbMission[nMapId].tbLongMaiLiveWL[szPower] = 0
  NewBattle.tbMission[nMapId]:OnNpcDeath("LONGMAI", pNpcKiller, him)
  NewBattle.tbMission[nMapId]:GoNextState()
  NewBattle.tbMission[nMapId]:Boom(szPower, pNpcKiller)
  --him.CastSkill(NewBattle.BOOM_ID,1,1,1,1);
end
--血量触发
function tbNpc:OnLifePercentReduceHere(nLifePercent)
  local nMapId = him.GetWorldPos()
  if nLifePercent == NewBattle.LONGMAIBLOODBIANSHEN then
    local tbInfo = him.GetTempTable("Npc")
    local szPower = NewBattle.POWER_ENAME[tbInfo.nPower]
    NewBattle.tbMission[nMapId]:BroadCastMission(NewBattle:GetColStr(NewBattle.POWER_CNAME[tbInfo.nPower] .. "方", tbInfo.nPower) .. "<color=red>龙脉<color>已经岌岌可危了！", NewBattle.SYSTEMBLACK_MSG, 0)
    him.CastSkill(NewBattle.BIANSHEN[szPower], 1, 1, 1)
  end
end
