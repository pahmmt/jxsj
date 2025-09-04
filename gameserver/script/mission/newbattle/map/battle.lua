-- 文件名　：battle.lua
-- 创建者　：LQY
-- 创建时间：2012-07-19 13:45:58
-- 说　　明：战场地图

Require("\\script\\mission\\newbattle\\newbattle_def.lua")
local tbBattleMap = NewBattle.BattleMap or {}
NewBattle.BattleMap = tbBattleMap

function tbBattleMap:OnEnter2()
  local nMapId = me.nMapId
  if not NewBattle.tbMission[nMapId] or NewBattle.tbMission[nMapId]:IsOpen() == 0 then
    NewBattle:MovePlayerOut(me)
    return
  end
  local nPower = me.GetTask(NewBattle.TSKGID, NewBattle.TASKID_BTCAMP)
  if not nPower or nPower == 0 then
    NewBattle:MovePlayerOut(me)
    return
  end
  NewBattle.tbMission[nMapId]:JoinPlayer(me, nPower)
end

local tbTrap = NewBattle.Trap or {}
NewBattle.Trap = tbTrap

function tbTrap:OnPlayer()
  local nMapId = me.nMapId
  local nPower = self.nPower
  if self.szType == "CHUKOU" then
    if NewBattle.tbMission[nMapId].nBattle_State ~= NewBattle.BATTLE_STATES.FIGHT and NewBattle.nBattle_State ~= NewBattle.BATTLE_STATES.FINISH then
      me.NewWorld(nMapId, unpack(NewBattle:GetRandomPoint(NewBattle.POS_BRON[nPower])))
      NewBattle:SendMsg2Player(me, "还未开战，不能离开大营", NewBattle.SYSTEMBLACK_MSG)
    end
    return
  end
  if self.szType == "CHUANSONG" then
    local nPower = NewBattle.tbMission[nMapId]:GetPlayerGroupId(me)
    local szPoint = ""
    local nFight = 0
    if self.szParm == "dh" then
      szPoint = "POS_READY"
      nFight = 0
    elseif self.szParm == "hd" then
      szPoint = "POS_BRON"
      nFight = 1
    end
    if nPower == self.nPower then
      if me.IsInCarrier() == 1 then
        me.Msg("前方道路狭窄，战车无法通行。请先下车！")
      else
        me.SetFightState(nFight)
        Player:AddProtectedState(me, NewBattle.PLAYERPROTECTEDTIME)
        me.NewWorld(nMapId, unpack(NewBattle:GetRandomPoint(NewBattle[szPoint][nPower])))
      end
    else
      me.Msg("前方枪林弹雨，不能通行。")
    end
    return
  end
end

--link Map和Trap点
function NewBattle:LinkMapTrap()
  local tbTraps = {
    ["daying3_yewai1"] = { "CHUKOU", 2 },
    ["daying3_yewai2"] = { "CHUKOU", 2 },
    ["daying1_yewai1"] = { "CHUKOU", 1 },
    ["daying1_yewai2"] = { "CHUKOU", 1 },
    ["daying1_houying1_1"] = { "CHUANSONG", 1, "dh" },
    ["daying1_houying1_2"] = { "CHUANSONG", 1, "dh" },
    ["daying3_houying3_1"] = { "CHUANSONG", 2, "dh" },
    ["daying3_houying3_2"] = { "CHUANSONG", 2, "dh" },
    ["houying1_daying1"] = { "CHUANSONG", 1, "hd" },
    ["houying3_daying3"] = { "CHUANSONG", 2, "hd" },
  }

  for _, nMapId in pairs(self.TB_MAP_BATTLE) do
    local tbMap = Map:GetClass(nMapId)
    for szFunMap, _ in pairs(self.BattleMap) do
      tbMap[szFunMap] = self.BattleMap[szFunMap]
    end
    for szTrapName, tbData in pairs(tbTraps) do
      local tbTrap = tbMap:GetTrapClass(szTrapName)
      for szFunTrap in pairs(self.Trap) do
        tbTrap[szFunTrap] = self.Trap[szFunTrap]
      end
      tbTrap.nPower = tbData[2]
      tbTrap.szType = tbData[1]
      tbTrap.szParm = tbData[3]
    end
  end
end
NewBattle:LinkMapTrap()
