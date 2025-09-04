-- 文件名　：chuanpiao_2012.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-12-07 15:26:34
-- 功能说明：2012.12月新服活动-拿船票，不是梦

--船票-字
local tbItem = Item:GetClass("xmas_2012_zi")
tbItem.tbZiItem = { [1894] = "诺", [1895] = "亚", [1896] = "方", [1897] = "舟" }
tbItem.tbChuanItem = { 18, 1, 1898, 1 }
tbItem.nUseTime = 20121222

function tbItem:OnUse()
  if me.nLevel < 20 then
    Dialog:SendBlackBoardMsg(me, "你的等级不足20级。")
    return 0
  end
  local nNowDate = tonumber(GetLocalDate("%Y%m%d"))
  if nNowDate >= self.nUseTime then
    Dialog:SendBlackBoardMsg(me, "诺亚方舟已经起航，字卡已经没用了。")
    return 0
  end
  local nParticular = self:GetOtherItem(it.nParticular)
  if nParticular > 0 then
    Dialog:SendBlackBoardMsg(me, "你还未收集到“诺”“亚”“方”“舟”四张卡，无法兑换船票。")
    return 0
  end
  if me.CountFreeBagCell() < 1 then
    Dialog:SendBlackBoardMsg(me, "你身上的背包空间不足，需要1格背包空间。")
    return 0
  end
  for nP, _ in pairs(self.tbZiItem) do
    if nP ~= it.nParticular then
      me.ConsumeItemInBags2(1, 18, 1, nP, 1)
    end
  end
  local pItem = me.AddItemEx(unpack(self.tbChuanItem))
  if pItem then
    me.SetItemTimeout(pItem, 7 * 24 * 60, 0)
  end
  Dialog:SendBlackBoardMsg(me, "恭喜你成功兑换到了诺亚方舟船票！")
  local szMsg = "得到了一张诺亚方舟船票，世界末日来了也一样无压力。"
  Player:SendMsgToKinOrTong(me, szMsg, 1)
  me.SendMsgToFriend("恭喜[" .. me.szName .. "]" .. szMsg)
  return 1
end

function tbItem:GetOtherItem(nParticular)
  for nP, _ in pairs(self.tbZiItem) do
    if nP ~= nParticular then
      local tbFind = me.FindItemInBags(18, 1, nP, 1)
      if #tbFind <= 0 then
        return nP
      end
    end
  end
  return 0
end

--船票
local tbItem2 = Item:GetClass("xmas_2012_chuanpiao")
tbItem2.nUseTime = 20121222
function tbItem2:OnUse()
  local nNowDate = tonumber(GetLocalDate("%Y%m%d"))
  if nNowDate < self.nUseTime then
    Dialog:SendBlackBoardMsg(me, "诺亚方舟还未起航，请于2012年12月22日00:00分后使用。")
    return 0
  end
  if me.CountFreeBagCell() < 1 then
    Dialog:SendBlackBoardMsg(me, "你身上的背包空间不足，需要1格背包空间。")
    return 0
  end
  return Item:GetClass("randomitem"):SureOnUse(386)
end
