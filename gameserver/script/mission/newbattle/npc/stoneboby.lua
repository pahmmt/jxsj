-- 文件名　：stoneboby.lua
-- 创建者　：LQY
-- 创建时间：2012-09-19 10:57:20
-- 说　　明：
local tbNpc = Npc:GetClass("newbattle_npc_baby")
-- 死亡事件
function tbNpc:OnDeath(pNpcKiller)
  local nMapId = him.GetWorldPos()
  if not NewBattle.tbMission[nMapId] or NewBattle.tbMission[nMapId]:IsOpen() ~= 1 then
    return
  end
  local pStone = KNpc.GetById(NewBattle.tbMission[nMapId].dwStoneId)
  if not pStone then
    return
  end
  local tbInfo = pStone.GetTempTable("Npc")
  for i = 1, #tbInfo.tbBaby do
    if tbInfo.tbBaby[i] == him.dwId then
      table.remove(tbInfo.tbBaby, i)
    end
  end
  if #tbInfo.tbBaby == 0 then
    local T, tbPlayerData, szName = NewBattle:GetKiller(pNpcKiller)
    if not szName then
      szName = "神秘人"
    end
    if T ~= 0 then
      for _, pPlayer in pairs(tbPlayerData) do
        NewBattle.tbMission[nMapId].tbCPlayers[pPlayer.nId]:GetStone()
      end
    end
    tbInfo.nState = 0
    local nPower = NewBattle:GetEnemy(tbInfo.nPower)
    tbInfo.nPower = nPower
    NewBattle.tbMission[nMapId].nTransStoneOwner = nPower
    local szMsg = string.format("<color=yellow>%s<color><color=white>%s<color>攻占了召唤石，士气大增。", (nPower == 1) and "宋方" or "金方", szName)
    NewBattle.tbMission[nMapId]:BroadCastMission(szMsg, NewBattle.SYSTEMBLACK_MSG, 0)
    local szCol = (nPower == 1) and "blue" or "yellow"
    local szName = (nPower == 1) and "宋方" or "金方"
    pStone.SetTitle(string.format("<color=%s>%s<color>", szCol, szName))
    pStone.Sync()
    NewBattle.tbMission[nMapId]:AddTip(NewBattle.POWER_ENAME[nPower], 2, 2)
    NewBattle.tbMission[nMapId]:AddTip(NewBattle.POWER_ENAME[NewBattle:GetEnemy(nPower)], 2, 1)
  end
end
