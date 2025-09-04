--机关箱

local tbItem = Item:GetClass("army_bag")

function tbItem:GetTip(nState)
  local nLevel = me.GetReputeLevel(1, 3)
  local nMachineCoin = me.GetMachineCoin()
  local szTip = string.format("<color=green>机关学造诣：%s级<enter><enter>", nLevel)
  szTip = string.format("%s机关耐久度：%s<color>", szTip, nMachineCoin)
  return szTip
end
