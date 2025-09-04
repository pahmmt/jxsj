local tbNpc = Npc:GetClass("homeland_npc_trader")

function tbNpc:OnDialog()
  local szMsg = "  我这里有各种药品出售。你想要买些什么？"
  local tbOpt = {
    { "<color=yellow>[绑定银两]我要买药<color>", self.OnBuyYaoBind, self },
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
