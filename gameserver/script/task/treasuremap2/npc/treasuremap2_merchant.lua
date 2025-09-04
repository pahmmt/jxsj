-- 文件名  : treasuremap2_merchant.lua
-- 创建者  : zounan
-- 创建时间: 2010-08-19 17:07:35
-- 描述    :

Require("\\script\\task\\treasuremap2\\treasuremap2_def.lua")

local tbNpc = Npc:GetClass("treasuremap2_merchant")

function tbNpc:OnDialog()
  local szMsg = "各大密境逐一向世人展现，夺宝贼日益猖狂，我们大家都忧心忡忡……"
  local tbOpt = {
    --	{"我要买药。",self.Shop, self},
    { "我要离开这儿", self.Leave, self },
    { "我要结束副本", self.EndMission, self },
    { "我再想想" },
  }

  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:Leave()
  FightAfter:Fly2City(me)
end

function tbNpc:Shop()
  me.OpenShop(14, 7)
end

function tbNpc:EndMission(bSure)
  local nCaptainId = me.GetTempTable("TreasureMap2").nCaptainId
  if not nCaptainId or nCaptainId ~= me.nId then
    Dialog:Say("副本不是您开启的，您不能结束此副本。")
    return
  end

  local tbInstance = TreasureMap2:GetInstancingByPlayerId(nCaptainId)
  if not tbInstance then
    Dialog:Say("副本已关闭，不能结束。")
    return
  end
  local nDisTime = GetTime() - tbInstance.nStartTime
  if nDisTime < TreasureMap2.CANCLOSE_TIME * 60 then
    Dialog:Say(string.format("副本开启%d分钟后才能选择关闭，还是晚点再来吧。", TreasureMap2.CANCLOSE_TIME))
    return
  end

  if bSure and bSure == 1 then
    tbInstance:EndGame()
    return
  end

  local tbOpt = {
    { "确定", self.EndMission, self, 1 },
    { "我再想想" },
  }

  Dialog:Say("您确定要结束此副本吗？", tbOpt)
end
