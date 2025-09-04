-- 文件名　：stone.lua
-- 创建者　：LQY
-- 创建时间：2012-07-23 10:34:47
-- 说　　明：召唤石逻辑
-- 炉石你好！

local tbNpc = Npc:GetClass("NewBattle_stone")

function tbNpc:OnDialog()
  local nMapId = him.GetWorldPos()
  if not NewBattle.tbMission[nMapId] or NewBattle.tbMission[nMapId]:IsOpen() ~= 1 then
    return
  end
  local nState = NewBattle:CheckOccupyPole(me, him.dwId)
  if nState == 0 then
    return
  end
  local tbBreakEvent = {
    Player.ProcessBreakEvent.emEVENT_MOVE,
    Player.ProcessBreakEvent.emEVENT_ATTACK,
    Player.ProcessBreakEvent.emEVENT_SIT,
    Player.ProcessBreakEvent.emEVENT_RIDE,
    Player.ProcessBreakEvent.emEVENT_USEITEM,
    Player.ProcessBreakEvent.emEVENT_ARRANGEITEM,
    Player.ProcessBreakEvent.emEVENT_DROPITEM,
    Player.ProcessBreakEvent.emEVENT_CHANGEEQUIP,
    Player.ProcessBreakEvent.emEVENT_SENDMAIL,
    Player.ProcessBreakEvent.emEVENT_TRADE,
    Player.ProcessBreakEvent.emEVENT_CHANGEFIGHTSTATE,
    Player.ProcessBreakEvent.emEVENT_ATTACKED,
    Player.ProcessBreakEvent.emEVENT_DEATH,
    Player.ProcessBreakEvent.emEVENT_LOGOUT,
    Player.ProcessBreakEvent.emEVENT_REVIVE,
    Player.ProcessBreakEvent.emEVENT_CLIENTCOMMAND,
  }
  local szMsg = "占领中"
  if nState == 1 then
    szMsg = "收回中"
  end
  GeneralProcess:StartProcess(szMsg, 15 * Env.GAME_FPS, { self.OnOccupyPole, self, me.nId, him.dwId }, nil, tbBreakEvent)
end

function tbNpc:OnOccupyPole(pPlayerId, nNpcDwId)
  local pPlayer = KPlayer.GetPlayerObjById(pPlayerId)
  local pStone = KNpc.GetById(nNpcDwId)
  if not pPlayer or not pStone then
    return 0
  end
  local nMapId = pStone.GetWorldPos()
  local nState = NewBattle:CheckOccupyPole(pPlayer, pStone.dwId)
  if nState == 0 then
    return 0
  end
  local nPlayerPower = NewBattle.tbMission[nMapId]:GetPlayerGroupId(me)
  local tbInfo = pStone.GetTempTable("Npc")
  if nState == 1 then
    tbInfo.nState = 0
    for _, nBabyDwId in pairs(tbInfo.tbBaby) do
      local pNpc = KNpc.GetById(nBabyDwId)
      if pNpc then
        pNpc.Delete()
      end
    end
    tbInfo.tbBaby = {}
    return
  end
  if nState == 2 then
    tbInfo.nState = 1
    local tbTmp = { { -4, 0 }, { 4, 0 }, { -2, -5 }, { -2, 4 }, { 2, -4 }, { 2, 4 } }
    local nMapId, nX, nY = pStone.GetWorldPos()
    for i = 1, #tbTmp do
      local pNpc = KNpc.Add2(NewBattle.STONEBOBY_ID[NewBattle.POWER_ENAME[tbInfo.nPower]], NewBattle.tbMission[nMapId].tbNpcLevel.SHITOUBOBY, -1, nMapId, nX + tbTmp[i][1], nY + tbTmp[i][2])
      if pNpc then
        pNpc.SetCurCamp(tbInfo.nPower)
        table.insert(tbInfo.tbBaby, pNpc.dwId)
      end
    end
    NewBattle.tbMission[nMapId].tbCPlayers[pPlayerId]:AddPoint(NewBattle.ATTACKSTONEPOINT, "你开始进攻召唤石，获得积分<color=yellow>%d<color>点！")
    local szMsg = string.format("%s军<color=yellow>%s<color>向召唤石发起攻击！", NewBattle.POWER_CNAME[nPlayerPower], pPlayer.szName)
    NewBattle.tbMission[nMapId]:BroadCastMission(szMsg, NewBattle.SYSTEMRED_MSG, 0)
    return
  end
  if nState == 3 then
    NewBattle.tbMission[nMapId].tbCPlayers[pPlayerId]:AddPoint(NewBattle.ATTACKSTONEPOINT + NewBattle.GETSTONEPOINT, "你占领了召唤石，获得积分<color=yellow>%d<color>点！")
    tbInfo.nPower = nPlayerPower
    NewBattle.tbMission[nMapId].nTransStoneOwner = nPlayerPower
    local szMsg = string.format("<color=yellow>%s<color><color=white>%s<color>攻占了召唤石，士气大增。", (nPlayerPower == 1) and "宋方" or "金方", pPlayer.szName)
    NewBattle.tbMission[nMapId]:BroadCastMission(szMsg, NewBattle.SYSTEMBLACK_MSG, 0)
    local szCol = (nPlayerPower == 1) and "blue" or "yellow"
    local szName = (nPlayerPower == 1) and "宋方" or "金方"
    pStone.SetTitle(string.format("<color=%s>%s<color>", szCol, szName))
    pStone.Sync()
    tbInfo.nState = 0
    NewBattle.tbMission[nMapId]:AddTip(NewBattle.POWER_ENAME[nPlayerPower], 2, 2)
  end
end
