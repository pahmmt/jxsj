-------------------------------------------------------
-- 文件名　：atlantis_npc_chefu.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2011-03-15 16:07:55
-- 文件描述：
-------------------------------------------------------

if not MODULE_GAMESERVER then
  return
end

Require("\\script\\boss\\atlantis\\atlantis_def.lua")

local tbNpc = Npc:GetClass("atlantis_npc_chefu")

function tbNpc:OnDialog()
  local szMsg = "    商队车夫：怎么，想回去了？看刚来的时候老夫说的没错吧？这样凶险的地方还是少呆为好。"
  local tbOpt = {
    { "<color=yellow>返回凤翔<color>", self.ReturnCity, self },
    { "我知道了" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:ReturnCity()
  Atlantis:SafeLeave(me)
end
