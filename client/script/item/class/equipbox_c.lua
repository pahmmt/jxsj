if not MODULE_GAMECLIENT then
  return
end

local tbItem = Item:GetClass("equipbox")

tbItem.tbLevelDesc = {
  [6] = "60级",
  [7] = "70级",
  [8] = "80级",
  [9] = "90级",
  [10] = "100级",
}

tbItem.tbQualityDesc = {
  [1] = "中档手工制作装",
  [2] = "高档手工制作装",
}

tbItem.tbQianghuaDesc = {
  [0] = "未强化",
}
for i = 1, 16 do
  tbItem.tbQianghuaDesc[i] = i .. "级"
end

function tbItem:GetTip(nState)
  local nLevel = it.GetExtParam(1) or 6 -- 等级
  local nQuality = it.GetExtParam(2) or 1 -- 橙装或紫装
  local nQianghua = it.GetExtParam(3) or 0 -- 强化
  if nQuality > 16 or nQuality < 0 or nLevel < 6 or nLevel > 10 or nQuality < 1 or nQuality > 2 then
    return "物品属性未知"
  end
  local szTip = "精美的装备礼包，包含了所有门派的整套装备，可以随意选取一套装备。\n"
  szTip = szTip .. string.format("装备等级：<color=yellow>%s<color>\n", self.tbLevelDesc[nLevel])
  szTip = szTip .. string.format("装备品质：<color=yellow>%s<color>\n", self.tbQualityDesc[nQuality])
  szTip = szTip .. string.format("强化等级：<color=yellow>%s<color>\n\n", self.tbQianghuaDesc[nQianghua])
  szTip = szTip .. "<color=green>右键点击获取。<color>"
  return szTip
end
