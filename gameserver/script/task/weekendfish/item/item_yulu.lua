Require("\\script\\task\\weekendfish\\weekendfish_def.lua")

-- 九州鱼录
local tbClass = Item:GetClass("weekendfish_yulu")

function tbClass:OnUse()
  if WeekendFish:CheckFishTime() ~= 1 then
    Dialog:Say("现在不是钓鱼时间，无法查看鱼群地图。")
    return
  end
  Npc:GetClass("weekednfish_npc"):OnDialog_ViewFishMap()
end
