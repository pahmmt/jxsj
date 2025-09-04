-- castlefight_c.lua
-- zhouchenfei
-- 兑换物品函数
-- 2010/11/6 13:53:08

CastleFight.SNOWFIGHT_ITEM_EXCOUNT = { 18, 1, 476, 1 }

function CastleFight:CheckGiftSwith(tbGiftSelf, pPickItem, pDropItem, nX, nY)
  local szItemParam = string.format("%s,%s,%s,%s", unpack(self.SNOWFIGHT_ITEM_EXCOUNT))
  tbGiftSelf.nOnSwithItemCount = tbGiftSelf.nOnSwithItemCount or 0
  if pDropItem then
    local szPutParam = string.format("%s,%s,%s,%s", pDropItem.nGenre, pDropItem.nDetail, pDropItem.nParticular, pDropItem.nLevel)
    if szPutParam ~= szItemParam then
      me.Msg("我只需要月影之石，请不要放入其他物品。")
      return 0
    end
    tbGiftSelf.nOnSwithItemCount = tbGiftSelf.nOnSwithItemCount + pDropItem.nCount
  end
  if pPickItem then
    tbGiftSelf.nOnSwithItemCount = tbGiftSelf.nOnSwithItemCount - pPickItem.nCount
  end
  tbGiftSelf:UpdateContent(string.format("您放入了<color=yellow>%s个月影之石<color>，可以兑换<color=yellow>%s次<color>活动机会。", tbGiftSelf.nOnSwithItemCount, tbGiftSelf.nOnSwithItemCount * 3))
  return 1
end
