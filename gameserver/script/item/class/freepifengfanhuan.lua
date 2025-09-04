local tbItem = Item:GetClass("freepifengfanhuan")

tbItem.HUNSHI_COUNT = 200 --  赠送魂石的数量

function tbItem:OnUse()
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("背包空间不足，至少需要<color=yellow>1格<color>背包空间。")
    return 0
  end
  local pEquip = me.GetEquip(Item.EQUIPPOS_MANTLE)
  if not pEquip then
    Dialog:Say("只有佩戴了超凡及以上等级披风才能领取返还魂石。")
    return 0
  end
  if me.GetTask(PlayerHonor.TSK_GIFT_GROUP, PlayerHonor.TSK_ID_GIFT_USEAWARD) == 0 then
    me.SetTask(PlayerHonor.TSK_GIFT_GROUP, PlayerHonor.TSK_ID_GIFT_USEAWARD, 1)
    me.AddStackItem(18, 1, 205, 1, { bForceBind = 1 }, self.HUNSHI_COUNT)
  else
    Dialog:Say("你已经领取过披风返还的魂石，每个角色只能领取一次。")
    return 0
  end
  return 1
end
