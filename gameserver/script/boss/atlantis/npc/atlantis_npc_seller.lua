-------------------------------------------------------
-- 文件名　：atlantis_npc_seller.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2011-03-17 22:35:34
-- 文件描述：
-------------------------------------------------------

if not MODULE_GAMESERVER then
  return
end

Require("\\script\\boss\\atlantis\\atlantis_def.lua")

local tbNpc = Npc:GetClass("atlantis_npc_seller")

function tbNpc:OnDialog()
  local szMsg = "    商队医师：这位侠士，来到这种荒漠之地还是得多带些药物以备不时之需呀！"
  local tbOpt = {
    { "<color=yellow>[绑定银两]我要买药<color>", self.OnBuyYaoBind, self },
    { "<color=yellow>[绑定银两]我要买菜<color>", self.OnBuyCaiBind, self },
    { "我要买药", self.OnBuyYao, self },
    { "我知道了" },
  }
  Dialog:Say(szMsg, tbOpt)
end

-- 买药
function tbNpc:OnBuyYaoBind()
  me.OpenShop(14, 7)
end

function tbNpc:OnBuyYao()
  me.OpenShop(14, 1)
end

-- 买菜
function tbNpc:OnBuyCaiBind()
  me.OpenShop(21, 7)
end
