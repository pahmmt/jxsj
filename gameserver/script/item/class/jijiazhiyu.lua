-- 文件名　：jijiazhiyu.lua
-- 创建者　：jiazhenwei
-- 创建时间：2011-09-06 09:15:26
-- 功能    ：技嘉之羽

local tbItem = Item:GetClass("jijiazhiyu")
function tbItem:OnUse()
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("您的背包空间不足，需要1格背包空间。", { "我知道了" })
    return 0
  end
  local pItem = me.AddItem(1, 26, 42 + me.nSex, 1)
  if pItem then
    me.SetItemTimeout(pItem, 60 * 24 * 7, 0)
  end
  return 1
end
