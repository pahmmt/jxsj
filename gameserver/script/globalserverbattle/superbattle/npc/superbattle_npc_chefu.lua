-------------------------------------------------------
-- 文件名　 : superbattle_npc_chefu.lua
-- 创建者　 : zhangjinpin@kingsoft
-- 创建时间 : 2011-06-09 16:48:11
-- 文件描述 :
-------------------------------------------------------

if not MODULE_GAMESERVER then
  return
end

Require("\\script\\globalserverbattle\\superbattle\\superbattle_def.lua")

local tbNpc = Npc:GetClass("superbattle_npc_chefu")

function tbNpc:OnDialog()
  local szMsg = "    一入湖海三十年，归处在何方？我可以带您回英雄岛。"
  local tbOpt = {
    { "返回英雄岛", self.ReturnLand, self },
    { "我知道了" },
  }

  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:ReturnLand()
  Transfer:NewWorld2GlobalMap(me, SuperBattle.TRANS_POS)
end
