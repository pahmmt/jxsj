-- zhouchenfei
-- 2012/9/24 15:30:59
-- ÑÌ»¨»î¶¯
Require("\\script\\event\\specialevent\\zhounianqing2012\\zhounianqing2012_public.lua")

local ZhouNianQing2012 = SpecialEvent.ZhouNianQing2012

local tbItem = Item:GetClass("thank_hongbao")

tbItem.nBaseExp = 180

function tbItem:OnUse()
  local nExp = me.GetBaseAwardExp() * self.nBaseExp
  Dbg:WriteLog("ZhouNianQing2012", "thank_hongbao", string.format("%s,%s", me.szName, nExp))
  me.AddExp(nExp)
  return 1
end
