Require("\\script\\task\\weekendfish\\weekendfish_def.lua")

-- 精致鱼饵粉
local tbClass = Item:GetClass("weekendfish_material_fishbait")

function tbClass:OnUse()
  if WeekendFish:CheckPlayerLimit(me) ~= 1 then
    me.Msg("只有达到30级并且加入门派的玩家制作。")
    return 0
  end
  if GetMapType(me.nMapId) ~= "city" and GetMapType(me.nMapId) ~= "village" then
    me.Msg("该物品只能在各大新手村和城市使用")
    return 0
  end
  local nTodayRemainNum, szMsg = WeekendFish:CheckTodayMakeRemainNum(me)
  if nTodayRemainNum <= 0 then
    me.Msg(szMsg)
    return 0
  end
  local szMsg = string.format("你今天一共还能制作<color=yellow>%s个<color>鱼饵。\n\n确定制作？", nTodayRemainNum)
  local tbOpt = {
    { "确定制作", self.MakeFishBait, self, nTodayRemainNum },
    { "我再想想" },
  }
  Dialog:Say(szMsg, tbOpt)
  return 0
end

function tbClass:MakeFishBait(nNum)
  Dialog:AskNumber("请输入制作的数量：", nNum, WeekendFish.MakeFishBaitDlg, WeekendFish)
end
