-- 副本入口Npc
local tbInstancingEntrancePoint = Npc:GetClass("instancingentrancepoint")

function tbInstancingEntrancePoint:OnDialog()
  local tbNpcData = him.GetTempTable("TreasureMap")
  assert(tbNpcData.nEntrancePlayerId)
  local pOpener = KPlayer.GetPlayerObjById(tbNpcData.nEntrancePlayerId)
  if not pOpener then
    return
  end

  local nTeamId = pOpener.nTeamId

  if me.nTeamId == 0 then
    local szMsg = "只有组队才能进入此地底迷宫！"
    Dialog:SendInfoBoardMsg(me, szMsg)
    return
  end

  if me.nTeamId ~= nTeamId then
    local szMsg = "只有<color=yellow>" .. pOpener.szName .. "<color>所在的队伍才能进入此地底迷宫！"
    Dialog:SendInfoBoardMsg(me, szMsg)
    return
  end

  local nTreasureId = tbNpcData.nEntranceTreasureId
  local nTreasureMapId = tbNpcData.nTreasureMapId

  Dialog:Say("是否现在进入副本？", { "好", self.Enter, self, me, him.dwId, nTreasureId, nTreasureMapId }, { "暂时不去" })
end

function tbInstancingEntrancePoint:Enter(pPlayer, nNpcId, nTreasureId, nTreasureMapId)
  local pNpc = KNpc.GetById(nNpcId)
  if TreasureMap:IsInstancingFree(nTreasureId, nTreasureMapId) == 1 then
    pPlayer.Msg("<color=yellow>你所发现的地底迷宫已经倒塌！<color>")
    if pNpc then
      pNpc.Delete()
    end
    return
  end

  local tbTreasureInfo = TreasureMap:GetTreasureInfo(nTreasureId)
  pPlayer.NewWorld(nTreasureMapId, tbTreasureInfo.InstancingMapX, tbTreasureInfo.InstancingMapY)
  TreasureMap:SetMyInstancingTreasureId(pPlayer, nTreasureId)
  pPlayer.SetFightState(1)
end
