-------------------------------------------------------
-- 文件名　 : superbattle_npc_baby.lua
-- 创建者　 : zhangjinpin@kingsoft
-- 创建时间 : 2011-06-02 18:46:37
-- 文件描述 :
-------------------------------------------------------

if not MODULE_GAMESERVER then
  return
end

Require("\\script\\globalserverbattle\\superbattle\\superbattle_def.lua")

-- 营地护卫
local tbNpc = Npc:GetClass("superbattle_npc_baby")
function tbNpc:OnDeath(pNpcKiller)
  SuperBattle:OnBabyDeath(pNpcKiller.GetPlayer(), him)
end

-- 元帅护卫
local tbNpc2 = Npc:GetClass("superbattle_npc_guard")
function tbNpc2:OnDeath(pNpcKiller)
  local nCamp = 0
  local pPlayer = pNpcKiller.GetPlayer()
  if pPlayer then
    nCamp = SuperBattle:GetPlayerTypeData(pPlayer, "nCamp")
    SuperBattle:AddPlayerPoint(pPlayer, SuperBattle.KILL_GUARD_POINT)
    SuperBattle:SendMessage(pPlayer, SuperBattle.MSG_CHANNEL, string.format("你的击杀了<color=yellow>%s<color>，获得<color=yellow>%s点<color>个人积分。", him.szName, SuperBattle.KILL_GUARD_POINT))
    local nPoint = math.floor(SuperBattle.KILL_GUARD_POINT * SuperBattle.SHARE_CAMP_RATE)
    local szMsg = string.format("你的盟友击杀了<color=yellow>%s<color>，你获得<color=yellow>%s点<color>共享积分。", him.szName, nPoint)
    local tbPlayerList = KPlayer.GetAroundPlayerList(pPlayer.nId, 50)
    for _, pTmpPlayer in pairs(tbPlayerList or {}) do
      local nTmpCamp = SuperBattle:GetPlayerTypeData(pTmpPlayer, "nCamp")
      if pTmpPlayer.szName ~= pPlayer.szName and nTmpCamp == nCamp then
        SuperBattle:AddPlayerPoint(pTmpPlayer, nPoint)
        SuperBattle:SendMessage(pTmpPlayer, SuperBattle.MSG_CHANNEL, szMsg)
      end
    end
  end
end
