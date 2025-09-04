----mask_2012_10_16.lua
----作者：孙多良
----2012-10-10
----info：

local tbItem = Item:GetClass("mask_2012_10_16")
function tbItem:OnUse()
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("您的背包空间不足，需要1格背包空间。", { "我知道了" })
    return 0
  end
  local pItem = me.AddItem(1, 13, 178 + me.nSex, 10)
  if pItem then
    pItem.Bind(1)
    me.SetItemTimeout(pItem, 7 * 1440, 0)
  end
  return 1
end

--该选择方式不使用
function tbItem:OnUse_null()
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("您的背包空间不足，需要1格背包空间。", { "我知道了" })
    return 0
  end

  local szMsg = "请选择古墓面具。\n古墓·风掣或古墓·雪空你可以选择其中一个。有效期7天。"
  local tbOpt = {
    { "古墓·风掣", self.GetItem, self, it.dwId, 178 },
    { "古墓·雪空", self.GetItem, self, it.dwId, 179 },
  }
  Dialog:Say(szMsg, tbOpt)
  return 0
end

function tbItem:GetItem(nItemId, nAwardId)
  local pItem = KItem.GetObjById(nItemId)
  if not pItem then
    return 0
  end
  if me.DelItem(pItem) == 1 then
    local pItem = me.AddItem(1, 13, nAwardId, 10)
    if pItem then
      pItem.Bind(1)
      me.SetItemTimeout(pItem, 7 * 1440, 0)
    end
  end
end
