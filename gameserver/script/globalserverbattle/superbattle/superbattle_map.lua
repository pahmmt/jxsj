-------------------------------------------------------
-- 文件名　 : supertbBattleMap.lua
-- 创建者　 : zhangjinpin@kingsoft
-- 创建时间 : 2011-06-02 15:33:15
-- 文件描述 :
-------------------------------------------------------

if not MODULE_GAMESERVER then
  return
end

Require("\\script\\globalserverbattle\\superbattle\\superbattle_def.lua")

-- battle map
local tbBattleMap = SuperBattle.BattleMap or {}
SuperBattle.BattleMap = tbBattleMap

function tbBattleMap:OnEnter2()
  local nCamp = 0
  for _, tbInfo in pairs(SuperBattle.tbMissionPlayer or {}) do
    if tbInfo.szName == me.szName then
      nCamp = tbInfo.nCamp
      break
    end
  end

  if SuperBattle.tbMissionGame and SuperBattle.tbMissionGame:IsOpen() ~= 0 and nCamp > 0 then
    if not SuperBattle.tbPlayerData[me.szName] and SuperBattle.tbMissionGame.nWarState >= SuperBattle.WAR_ADMIRAL then
      SuperBattle:SendMessage(me, SuperBattle.MSG_BOTTOM, "你来的太晚了，无法参加战斗。")
      Transfer:NewWorld2GlobalMap(me, SuperBattle.TRANS_POS)
      return 0
    end
    SuperBattle.tbMissionGame:JoinPlayer(me, nCamp)
    me.SetLogoutRV(1)
  else
    Transfer:NewWorld2GlobalMap(me, SuperBattle.TRANS_POS)
  end
end

function tbBattleMap:OnLeave(szParam)
  if SuperBattle.tbMissionGame and SuperBattle.tbMissionGame:IsOpen() ~= 0 then
    SuperBattle.tbMissionGame:KickPlayer(me)
    me.SetLogoutRV(0)
  end
end
-- end

-- trap
local tbTrap = SuperBattle.Trap or {}
SuperBattle.Trap = tbTrap

function tbTrap:OnPlayer()
  local nCamp = SuperBattle:GetPlayerTypeData(me, "nCamp")
  if self.nMapX and self.nMapY and self.nFightState and self.nCamp == nCamp then
    if self.nFightState == 1 then
      if SuperBattle.tbMissionGame.nWarState <= SuperBattle.WAR_INIT then
        SuperBattle:SendMessage(me, SuperBattle.MSG_BOTTOM, "战斗尚未开始！请等候片刻。")
        local nRand = MathRandom(1, #SuperBattle.CAMP_POS[nCamp])
        local nMapX, nMapY = unpack(SuperBattle.CAMP_POS[nCamp][nRand])
        me.NewWorld(me.nMapId, nMapX, nMapY)
        return 0
      end
      Player:AddProtectedState(me, SuperBattle.SUPER_TIME)
      SuperBattle:SendMessage(me, SuperBattle.MSG_BOTTOM, "进入战斗，小心！")
    else
      SuperBattle:SendMessage(me, SuperBattle.MSG_BOTTOM, "回到后营，可以喘口气了。")
    end
    me.NewWorld(me.nMapId, self.nMapX, self.nMapY)
    me.SetFightState(self.nFightState)
  end
end
-- end

function SuperBattle:LinkMapTrap()
  for _, nMapId in pairs(self.BATTLE_MAP) do
    local tbMap = Map:GetClass(nMapId)
    for szFunMap, _ in pairs(self.BattleMap) do
      tbMap[szFunMap] = self.BattleMap[szFunMap]
    end
    for szTrapName, tbInfo in pairs(self.MAP_TRAP_POS) do
      local tbTrap = tbMap:GetTrapClass(szTrapName)
      tbTrap.nMapX = tbInfo[1]
      tbTrap.nMapY = tbInfo[2]
      tbTrap.nFightState = tbInfo[3]
      tbTrap.nCamp = tbInfo[4]
      for szFunTrap in pairs(self.Trap) do
        tbTrap[szFunTrap] = self.Trap[szFunTrap]
      end
    end
  end
end

SuperBattle:LinkMapTrap()
