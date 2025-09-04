-- 文件名　：returnbindmoney.lua
-- 创建者　：jiazhenwei
-- 创建时间：2011-07-15 17:42:59
-- 功能    ：
--绑银返还券

local tbItem = Item:GetClass("returnbindmoney")

function tbItem:OnUse()
  local nCount = tonumber(it.GetExtParam(1))
  if nCount <= 0 then
    me.Msg("道具出问题，请联系GM")
    return 0
  end
  local nTolCount = me.GetTask(2034, 11)
  if nTolCount + nCount > 2000000000 then
    me.Msg("您的返还点过多，暂时不能使用这个道具。")
    return 0
  end
  me.SetTask(2034, 11, nTolCount + nCount)
  Dialog:Say(string.format("恭喜你获得<color=yellow>%s<color>消耗返还绑银点，当前剩余返还点数为<color=yellow>%s<color>点，您只需要购买<color=yellow>%s<color>金币的商品即可获得所有绑银超值返还。", nCount, nCount + nTolCount, math.floor((nCount + nTolCount) / 1000)))
  --me.Msg(string.format("恭喜您获得<color=yellow>%s<color>消耗返还绑银点。", nCount));
  return 1
end
