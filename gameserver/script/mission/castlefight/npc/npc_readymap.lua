-- npc_readymap.lua
-- zhouchenfei
-- 兑换物品函数
-- 2010/11/6 13:53:08

local tbNpc = Npc:GetClass("castlefightnpc_ready")

function tbNpc:OnDialog()
  local szMsg = "你不参加比赛了吗？\n"
  local tbOpt = {
    { "是的，我有急事要离开", self.OnLeave, self },
    { "随便看看" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:OnLeave()
  local nMapId, nPosX, nPosY = EPlatForm:GetLeaveMapPos()
  me.TeamApplyLeave() --离开队伍
  me.NewWorld(nMapId, nPosX, nPosY)
end
