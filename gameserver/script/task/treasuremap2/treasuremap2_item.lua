-- 文件名  : treasuremap2_item.lua
-- 创建者  : huangxiaoming
-- 创建时间: 2012-08-30 11:55:41
-- 描述    :
Require("\\script\\task\\treasuremapex\\treasuremapex_def.lua")
local TreasureMapEx = TreasureMap.TreasureMapEx
local tbLingPai = Item:GetClass("treasure2_lingpai")
function tbLingPai:OnUse()
  local nTaskGroup = TreasureMapEx.TASK_GROUP
  local nTaskId = TreasureMapEx.TASK_COUNT
  local nCount = me.GetTask(nTaskGroup, nTaskId)
  if nCount >= TreasureMapEx.MAXCOUNT then
    me.Msg("藏宝图挑战次数最多累计100次，请尽快前去挑战再使用牌子兑换次数吧。")
    return
  end
  local szMsg = string.format("恭喜你增加了1次藏宝图的机会")
  me.SetTask(nTaskGroup, nTaskId, nCount + 1)
  me.Msg(szMsg)
  return 1
end

local tbCommon = Item:GetClass("treasure2_common")

function tbCommon:OnUse()
  local nTaskGroup = TreasureMapEx.TASK_GROUP
  local nTaskId = TreasureMapEx.TASK_COUNT
  local nCount = me.GetTask(nTaskGroup, nTaskId)
  if nCount >= TreasureMapEx.MAXCOUNT then
    me.Msg("藏宝图挑战次数最多累计100次，请尽快前去挑战再使用牌子兑换次数吧。")
    return
  end
  local szMsg = string.format("恭喜你增加了1次藏宝图的机会")
  me.SetTask(nTaskGroup, nTaskId, nCount + 1)
  me.Msg(szMsg)
  return 1
end
