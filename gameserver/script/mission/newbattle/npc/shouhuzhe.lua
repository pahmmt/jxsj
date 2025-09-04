-- 文件名　：shouhuzhe.lua
-- 创建者　：LQY
-- 创建时间：2012-07-24 11:09:12
-- 说　　明：守护者逻辑，死掉就刷龙脉

local tbNpc = Npc:GetClass("NewBattle_shouhuzhe")

-- 死亡事件
function tbNpc:OnDeath(pNpcKiller)
  local nMapId = him.GetWorldPos()
  if not NewBattle.tbMission[nMapId] or NewBattle.tbMission[nMapId]:IsOpen() ~= 1 then
    return
  end
  local tbInfo = him.GetTempTable("Npc")
  local nPower = tbInfo.nPower
  local szPower = NewBattle.POWER_ENAME[nPower]
  if not nPower then
    return
  end
  local szMsg = string.format("%s守护者战败，<color=red>龙脉<color>已失去保护！", NewBattle:GetColStr((nPower == 1) and "宋方" or "金方", nPower))
  NewBattle.tbMission[nMapId]:BroadCastMission(szMsg, NewBattle.SYSTEMBLACKRED_MSG, 0)
  NewBattle.tbMission[nMapId].tbShouhuzheLive[szPower][1] = 0
  NewBattle.tbMission[nMapId]:OnNpcDeath("SHOUHUZHE", pNpcKiller, him)
  --改变龙脉战斗关系为可攻击
  --
  --DEBUG BEGIN
  if NewBattle.__DEBUG then
    print("改变龙脉战斗关系为可攻击", szPower, NewBattle.tbMission[nMapId].tbLongMaipNpcId[szPower])
  end
  --
  --DEBUG END
  local pNpc = KNpc.GetById(NewBattle.tbMission[nMapId].tbLongMaipNpcId[szPower])
  if not pNpc then
    print("冰火天堑，龙脉ID故障")
    --出问题了
    return
  end
  --改变龙脉阵营
  pNpc.szName = "龙脉"
  pNpc.Sync()
  pNpc.SetCurCamp(nPower)
  pNpc.RemoveSkillState(NewBattle.WUDITEXIAO[szPower])
  NewBattle.tbMission[nMapId]:CreateTimer(NewBattle.DEFPOINTTIME, NewBattle.tbMission[nMapId].DefAddPoint, NewBattle.tbMission[nMapId], "LONGMAI", nPower, pNpc.dwId)
  NewBattle.tbMission[nMapId].tbLongMaiLive[szPower][1] = 1
  NewBattle.tbMission[nMapId]:AddTip(szPower, 3, 3)
  NewBattle.tbMission[nMapId]:AddTip(NewBattle:GetEnemy(szPower), 4, 3)
end
