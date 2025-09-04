local tbItem = Item:GetClass("coupon")

function tbItem:GetTip()
  local nTimes = it.GetGenInfo(1)
  if nTimes == 0 then
    nTimes = 1
  end
  return string.format("剩余使用次数：%d次", nTimes)
end

local tbNewItem = Item:GetClass("newcoupon")

function tbNewItem:GetTip()
  local nTimes = it.GetExtParam(3) - it.GetGenInfo(1)
  if nTimes < 0 then
    nTimes = 0
  end
  return string.format("剩余使用次数：%d次", nTimes)
end
