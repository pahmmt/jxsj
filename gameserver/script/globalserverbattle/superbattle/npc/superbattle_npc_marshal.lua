-------------------------------------------------------
-- 文件名　 : superbattle_npc_marshal.lua
-- 创建者　 : zhangjinpin@kingsoft
-- 创建时间 : 2011-06-08 14:42:28
-- 文件描述 :
-------------------------------------------------------

if not MODULE_GAMESERVER then
  return
end

Require("\\script\\globalserverbattle\\superbattle\\superbattle_def.lua")

local tbNpc = Npc:GetClass("superbattle_npc_marshal")

-- 死亡事件
function tbNpc:OnDeath(pNpcKiller)
  local nCamp = 0
  local pPlayer = pNpcKiller.GetPlayer()
  if pPlayer then
    nCamp = SuperBattle:GetPlayerTypeData(pPlayer, "nCamp")
    SuperBattle:AddPlayerPoint(pPlayer, SuperBattle.KILL_MARSHAL_POINT)
    SuperBattle:SendMessage(pPlayer, SuperBattle.MSG_CHANNEL, string.format("你的击杀了<color=yellow>%s<color>，获得<color=yellow>%s点<color>个人积分。", him.szName, SuperBattle.KILL_MARSHAL_POINT))
    SuperBattle:AddCampPoint(nCamp, SuperBattle.KILL_MARSHAL_CAMP_POINT)
    local nPoint = math.floor(SuperBattle.KILL_MARSHAL_POINT * SuperBattle.SHARE_CAMP_RATE)
    local szMsg = string.format("你的盟友击杀了<color=yellow>%s<color>，你获得<color=yellow>%s点<color>共享积分。", him.szName, nPoint)
    local tbPlayerList = KPlayer.GetAroundPlayerList(pPlayer.nId, 50)
    for _, pTmpPlayer in pairs(tbPlayerList or {}) do
      local nTmpCamp = SuperBattle:GetPlayerTypeData(pTmpPlayer, "nCamp")
      if pTmpPlayer.szName ~= pPlayer.szName and nTmpCamp == nCamp then
        SuperBattle:AddPlayerPoint(pTmpPlayer, nPoint)
        SuperBattle:SendMessage(pTmpPlayer, SuperBattle.MSG_CHANNEL, szMsg)
      end
    end
  else
    if SuperBattle.tbMarshal[him.dwId] then
      nCamp = 3 - SuperBattle.tbMarshal[him.dwId].nCamp
      SuperBattle:AddCampPoint(nCamp, SuperBattle.KILL_MARSHAL_CAMP_POINT)
    end
  end
  if SuperBattle.tbMissionGame then
    SuperBattle.tbMissionGame:BroadCastMission(SuperBattle.MSG_BOTTOM, string.format("%s<color=yellow>%s<color>所在的小队成功击杀了%s！", SuperBattle:GetCampName(nCamp), pPlayer and pPlayer.szName or "神秘人", him.szName))
  end
  if pPlayer then
    SuperBattle:StatLog("npc_alive", pPlayer.nId, SuperBattle:GetSession(), nCamp, 2, SuperBattle.tbMissionGame.nEndTime - GetTime(), pPlayer.nFaction, pPlayer.nRouteId)
  else
    SuperBattle:StatLog("npc_alive", nil, SuperBattle:GetSession(), nCamp, 2, SuperBattle.tbMissionGame.nEndTime - GetTime(), 0, 0)
  end
end
