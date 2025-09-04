-- 文件名　：keju_item.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-10-24 15:24:06
-- 功能说明：剑侠世界科举考试

if not MODULE_GAMESERVER then
  return
end

SpecialEvent.JxsjKeju = SpecialEvent.JxsjKeju or {}
local JxsjKeju = SpecialEvent.JxsjKeju

local tbItem = Item:GetClass("weeklyAwardItem")

function tbItem:OnUse()
  local nDay = TimeFrame:GetServerOpenDay()
  local tbAward = Lib._CalcAward:RandomAward(3, 3, 2, 100000, Lib:_GetXuanReduce(nDay), { 0, 10, 0 })
  local nMaxMoney = Lib._CalcAward:GetMaxMoney(tbAward)
  if me.GetBindMoney() + nMaxMoney > me.GetMaxCarryMoney() then
    Dialog:Say("背包携带绑银将达上限，请清理下再来。")
    return 0
  end
  Lib._CalcAward:RandomItem(me, tbAward)
  return 1
end
