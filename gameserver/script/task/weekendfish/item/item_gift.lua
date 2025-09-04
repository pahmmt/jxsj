Require("\\script\\task\\weekendfish\\weekendfish_def.lua")

-- 奖励的箱子
local tbClass = Item:GetClass("weekendfish_gift")

function tbClass:OnUse()
  local nLevel = it.nLevel
  if me.CountFreeBagCell() < 2 then
    Dialog:Say("背包空间不足，至少需要<color=yellow>2个<color>背包空间。")
    return 0
  end
  local tbRandomItem = Item:GetClass("randomitem")
  local nRet = tbRandomItem:OnUse()
  if nRet ~= 1 then
    return 0
  end
  if me.CountFreeBagCell() < 2 then
    return 1
  end
  if WeekendFish.RANK_FRAGMENT[nLevel] then
    local nRand = MathRandom(10000)
    if nRand <= WeekendFish.RANK_FRAGMENT[nLevel] then
      local pItem = me.AddItem(unpack(WeekendFish.ITEM_FRAGMENT_ID))
      if pItem then
        me.SendMsgToFriend(string.format("您的好友[<color=yellow>%s<color>]开启%s获得了忠魂碎片（不绑定），真是可喜可贺啊！", me.szName, it.szName))
        Player:SendMsgToKinOrTong(me, string.format("开启%s获得了忠魂碎片（不绑定），真是可喜可贺啊！", it.szName))
        KDialog.NewsMsg(0, Env.NEWSMSG_NORMAL, string.format("%s开启%s获得了忠魂碎片（不绑定），真是可喜可贺啊！", me.szName, it.szName))
        StatLog:WriteStatLog("stat_info", "fishing", "repute_item", me.nId, 1)
      else
        Dbg:WriteLog("WeekendFish", "add_suipian_failure", me.szName, nLevel)
      end
    end
  end
  if WeekendFish.DONGXUANHANTIE[nLevel] and TimeFrame:GetServerOpenDay() > WeekendFish.ACCELERATE_DAYLIMIT then
    local nRand = MathRandom(10000)
    if nRand <= WeekendFish.DONGXUANHANTIE[nLevel] then
      local pItem = me.AddItem(unpack(WeekendFish.ITEM_DONGXUANHANTIE))
      if not pItem then
        Dbg:WriteLog("WeekendFish", "add_dongxuanhantie_failure", me.szName, nLevel)
      end
    end
  end
  return 1
end
