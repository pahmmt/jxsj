-- 初级跨服联赛官

local tbNpc = Npc:GetClass("gbwlls_guanyuan2")

function tbNpc:OnDialog()
  --	if (GLOBAL_AGENT) then
  --		-- 如果黄金跨服联赛还没开那么就转到高级联赛
  --		if (0 == GbWlls:CheckOpenGoldenGbWlls()) then
  --			local nGameLevel = 2;
  --			GbWlls.DialogNpc:OnDialog(nGameLevel)
  --			return;
  --		end
  --	end

  Dialog:Say("现在大家都可以去黄金跨服联赛报名官那儿报名参加黄金跨服联赛证明自己的实力，故跨服高级联赛不开放！")

  --	local nGameLevel = 1;
  --	GbWlls.DialogNpc:OnDialog(nGameLevel)
end
