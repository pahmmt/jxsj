--收集箱客户端
--张德衡

function Merchant:CheckGiftSwith(tbGiftSelf, pPickItem, pDropItem, nX, nY)
  if not tbGiftSelf.tbOnSwithItemCount then
    tbGiftSelf.tbOnSwithItemCount = {}
  end
  local szMsg = ""
  if pDropItem then
    local szFollowItem = string.format("%s,%s,%s", 18, 1, 289)
    local szItem = string.format("%s,%s,%s", pDropItem.nGenre, pDropItem.nDetail, pDropItem.nParticular)
    local szItemEx = szItem .. "," .. pDropItem.nLevel
    local bOther = 0
    local nLevel = pDropItem.nLevel
    for nOrgLevel, tbItem in pairs(self.tbOtherItem) do
      if szItemEx == string.format("%s,%s,%s,%s", unpack(tbItem)) then
        bOther = 1
        nLevel = nOrgLevel
      end
    end
    if (szFollowItem ~= szItem and bOther == 0) or (Merchant.TASK_ITEM_FIX[nLevel] and Merchant.TASK_ITEM_FIX[nLevel].hide) then
      me.Msg("此物品不能放入!")
      return 0
    end
    if not tbGiftSelf.tbOnSwithItemCount[nLevel] then
      tbGiftSelf.tbOnSwithItemCount[nLevel] = Merchant.TASK_ITEM_FIX[nLevel].nMax - me.GetTask(Merchant.TASK_GOURP, Merchant.TASK_ITEM_FIX[nLevel].nTask)
    end
    if tbGiftSelf.tbOnSwithItemCount[nLevel] <= 0 then
      me.Msg("此物品已达到最大数量，不能再放入!")
      return 0
    end
    tbGiftSelf.tbOnSwithItemCount[nLevel] = tbGiftSelf.tbOnSwithItemCount[nLevel] - 1
    szMsg = self:UpdateGiftSwith(tbGiftSelf.tbOnSwithItemCount)
  end
  if pPickItem then
    local szItem = string.format("%s,%s,%s,%s", pPickItem.nGenre, pPickItem.nDetail, pPickItem.nParticular, pPickItem.nLevel)
    local nLevel = pPickItem.nLevel
    for nOrgLevel, tbItem in pairs(self.tbOtherItem) do
      if szItem == string.format("%s,%s,%s,%s", unpack(tbItem)) then
        nLevel = nOrgLevel
        break
      end
    end
    tbGiftSelf.tbOnSwithItemCount[nLevel] = tbGiftSelf.tbOnSwithItemCount[nLevel] + 1
    szMsg = self:UpdateGiftSwith(tbGiftSelf.tbOnSwithItemCount)
  end
  tbGiftSelf:UpdateContent(szMsg)
  return 1
end

function Merchant:UpdateGiftSwith(tbOnSwithItemCount)
  local szMsg = string.format("%s%s\n\n", Lib:StrFillC("商会令牌", 16), Lib:StrFillC("剩余放入个数", 12))
  for nLevel, nCount in pairs(tbOnSwithItemCount) do
    if nCount == 0 then
      szMsg = szMsg .. string.format("  <color=yellow>%s<color><color=red>%s<color>\n", Lib:StrFillL(Merchant.TASK_ITEM_FIX[nLevel].szName, 14), Lib:StrFillC("满", 12))
    else
      szMsg = szMsg .. string.format("  <color=yellow>%s<color><color=green>%s<color>\n", Lib:StrFillL(Merchant.TASK_ITEM_FIX[nLevel].szName, 14), Lib:StrFillC(nCount, 12))
    end
  end
  return szMsg
end
