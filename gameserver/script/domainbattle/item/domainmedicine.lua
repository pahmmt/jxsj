-- 领土战药物
-- zhengyuhua

Require("\\script\\item\\class\\medicine.lua")

local tbMedicine = Item:NewClass("domainmedicine", "medicine")
if not tbMedicine then
  tbMedicine = Item:GetClass("domainmedicine")
end

------------------------------------------------------------------------------------------
-- public

function tbMedicine:CheckUsable()
  if me.GetNpc().GetRangeDamageFlag() ~= 1 then
    me.Msg("非领土征战状态下不允许使用该道具！")
    return 0
  end
  return self._tbBase:CheckUsable()
end
