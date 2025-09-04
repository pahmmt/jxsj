local tbJug = Item:GetClass("jug_arbor_day_09")

-- 装满水壶
function tbJug:GetTip()
  return "还可以洒水<color=green>" .. tostring(it.GetGenInfo(1, 0)) .. "次<color>"
end

local tbOldSeed = Item:GetClass("item_seed_arbor_day_09Ex")

function tbOldSeed:GetTip()
  if it.GetGenInfo(1) <= 0 then
    return "<color=gray>未激活<color>"
  else
    return "<color=green>已激活<color>"
  end
end
