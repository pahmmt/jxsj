Require("\\script\\event\\collectcard\\define.lua")

local tbItem = Item:GetClass("collect_token")
local CollectCard = SpecialEvent.CollectCard
local tbAward = {

  [1] = 1000,
  [2] = 3000,
  [3] = 500,
}

function tbItem:OnUse()
  me.AddRepute(5, 2, tbAward[it.nLevel])
  if it.nLevel ~= 3 then
    me.Msg(string.format("您获得<color=yellow>%s点<color>盛夏活动声望，可到汴京逍遥谷客商处购买全技能+1腰带。", tbAward[it.nLevel]))
    Dialog:SendBlackBoardMsg(me, "您获得了盛夏活动声望，可到逍遥谷客商处购买全技能+1腰带。")
  else
    me.Msg(string.format("您获得<color=yellow>%s点<color>盛夏活动声望。", tbAward[it.nLevel]))
  end
  CollectCard:WriteLog(string.format("使用盛夏活动令牌，获得了%s点威望", tbAward[it.nLevel]), me.nId)
  return 1
end
