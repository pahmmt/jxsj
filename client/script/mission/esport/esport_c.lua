--竞技赛（雪仗）client
--孙多良
--2008.12.30

--客户端检查放入给予界面物品是否符合。
function Esport:CheckGiftSwith(tbGiftSelf, pPickItem, pDropItem, nX, nY)
  local szItemParam = string.format("%s,%s,%s,%s", unpack(self.SNOWFIGHT_ITEM_EXCOUNT))
  tbGiftSelf.nOnSwithItemCount = tbGiftSelf.nOnSwithItemCount or 0
  if pDropItem then
    local szPutParam = string.format("%s,%s,%s,%s", pDropItem.nGenre, pDropItem.nDetail, pDropItem.nParticular, pDropItem.nLevel)
    if szPutParam ~= szItemParam then
      me.Msg("我只需要红粉莲花，请不要放入其他物品。")
      return 0
    end
    tbGiftSelf.nOnSwithItemCount = tbGiftSelf.nOnSwithItemCount + 1
  end
  if pPickItem then
    tbGiftSelf.nOnSwithItemCount = tbGiftSelf.nOnSwithItemCount - 1
  end
  tbGiftSelf:UpdateContent(string.format("您放入了<color=yellow>%s个红粉莲花<color>，可以兑换<color=yellow>%s次<color>活动机会。", tbGiftSelf.nOnSwithItemCount, tbGiftSelf.nOnSwithItemCount))
  return 1
end
