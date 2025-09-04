-- zhouchenfei
-- 2012/9/24 15:30:59
-- 烟花活动
Require("\\script\\event\\specialevent\\zhounianqing2012\\zhounianqing2012_public.lua")

local ZhouNianQing2012 = SpecialEvent.ZhouNianQing2012

local tbItem = Item:GetClass("zhounianqing2012_hongzhu")

function tbItem:GetTip(nState)
  local nUseCount = ZhouNianQing2012:GetUseHongZhuCount(me)
  local szTip = ""
  szTip = szTip .. string.format("<color=0x8080ff>右键点击使用<color>\n")
  szTip = szTip .. string.format("<color=yellow>已使用次数: %s/%s<color>", nUseCount, ZhouNianQing2012.MAX_HONGZHU_USE_COUNT)
  return szTip
end
