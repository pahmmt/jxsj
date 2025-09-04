Require("\\script\\kin\\homeland\\homeland_def.lua")

local tbNpc = Npc:GetClass("homelandnpc_manager")

function tbNpc:OnDialog()
  local szMsg = "你想去哪个区域？我送你过去"
  local tbOpt = {}
  --for i = 1, #HomeLand.TB_TRANS_POS do
  --	table.insert(tbOpt, {HomeLand.TB_TRANS_POS[i][2], self.Transmit, self, i});
  --end
  table.insert(tbOpt, { "我想要回城市", self.Back2City, self })
  table.insert(tbOpt, { "我再考虑一下" })
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:Transmit(nPosIndex)
  me.NewWorld(me.nMapId, HomeLand.TB_TRANS_POS[nPosIndex][1][1], HomeLand.TB_TRANS_POS[nPosIndex][1][2])
end

function tbNpc:Back2City()
  Npc:GetClass("chefu"):SelectMap("city")
end
