GbWlls.tbDropItem = {
  ["18,1,476,1"] = { nBaseNum = 50, szItemName = "月影之石" },
  ["18,1,915,1"] = { nBaseNum = 1, szItemName = "五色石" },
}

GbWlls.tbDropItem_KaiYang = {
  ["18,1,476,1"] = { nBaseNum = 50, szItemName = "月影之石" },
  ["18,1,1243,1"] = { nBaseNum = 1, szItemName = "开阳石" },
}

GbWlls.tbDropItem_ChengZhuBox = {
  ["18,1,476,1"] = { nBaseNum = 100, szItemName = "月影之石" },
}

GbWlls.tbDropItem_ChengZhanBox = {
  ["18,1,476,1"] = { nBaseNum = 2, szItemName = "月影之石" },
}

function GbWlls:CheckGiftItem(tbGiftSelf, pPickItem, pDropItem, nX, nY)
  local pItem = tbGiftSelf:First()
  local tbItemList = GbWlls.tbDropItem
  for szItemPut, tbInfo in pairs(tbItemList) do
    tbInfo.nNum = 0
  end
  while pItem do
    local szIndex = string.format("%s,%s,%s,%s", pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel)
    if tbItemList[szIndex] then
      tbItemList[szIndex].nNum = tbItemList[szIndex].nNum + pItem.nCount
    end
    pItem = tbGiftSelf:Next()
  end

  if pDropItem then
    -- 判断要放入道具是否是指定的礼品
    local szIndex = string.format("%d,%d,%d,%d", pDropItem.nGenre, pDropItem.nDetail, pDropItem.nParticular, pDropItem.nLevel)
    if not tbItemList[szIndex] then
      me.Msg("该类型物品不能兑换翡翠珠。")
      return 0
    end
    tbItemList[szIndex].nNum = tbItemList[szIndex].nNum + pDropItem.nCount
  end

  if pPickItem then
    local szIndex = string.format("%d,%d,%d,%d", pPickItem.nGenre, pPickItem.nDetail, pPickItem.nParticular, pPickItem.nLevel)
    if tbItemList[szIndex] then
      tbItemList[szIndex].nNum = tbItemList[szIndex].nNum - pPickItem.nCount
    end
  end

  local nMinNum = 99999999
  for szItem, tbItem in pairs(tbItemList) do
    local nDetNum = math.floor(tbItem.nNum / tbItem.nBaseNum)
    if nMinNum > nDetNum then
      nMinNum = nDetNum
    end
  end
  local szContent = "50个月影之石和1个五色石换取1个翡翠珠\n"

  for szPutItem, tbInfo in pairs(tbItemList) do
    szContent = string.format("%s<color=green>%s<color>：<color=yellow>%s<color>个\n", szContent, tbInfo.szItemName, tbInfo.nNum)
  end

  if nMinNum <= 0 or nMinNum >= 99999999 then
    szContent = string.format("%s可兑换<color=green>翡翠珠<color>：<color=yellow>0<color>个", szContent)
  else
    szContent = string.format("%s可兑换<color=green>翡翠珠<color>：<color=yellow>%s<color>个", szContent, nMinNum)
  end

  tbGiftSelf:UpdateContent(szContent)
  return 1
end

function GbWlls:CheckGiftItem_ShiHunZhu(tbGiftSelf, pPickItem, pDropItem, nX, nY)
  local pItem = tbGiftSelf:First()
  local tbItemList = GbWlls.tbDropItem_KaiYang
  for szItemPut, tbInfo in pairs(tbItemList) do
    tbInfo.nNum = 0
  end
  while pItem do
    local szIndex = string.format("%s,%s,%s,%s", pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel)
    if tbItemList[szIndex] then
      tbItemList[szIndex].nNum = tbItemList[szIndex].nNum + pItem.nCount
    end
    pItem = tbGiftSelf:Next()
  end

  if pDropItem then
    -- 判断要放入道具是否是指定的礼品
    local szIndex = string.format("%d,%d,%d,%d", pDropItem.nGenre, pDropItem.nDetail, pDropItem.nParticular, pDropItem.nLevel)
    if not tbItemList[szIndex] then
      me.Msg("该类型物品不能兑换噬魂珠。")
      return 0
    end
    tbItemList[szIndex].nNum = tbItemList[szIndex].nNum + pDropItem.nCount
  end

  if pPickItem then
    local szIndex = string.format("%d,%d,%d,%d", pPickItem.nGenre, pPickItem.nDetail, pPickItem.nParticular, pPickItem.nLevel)
    if tbItemList[szIndex] then
      tbItemList[szIndex].nNum = tbItemList[szIndex].nNum - pPickItem.nCount
    end
  end

  local nMinNum = 99999999
  for szItem, tbItem in pairs(tbItemList) do
    local nDetNum = math.floor(tbItem.nNum / tbItem.nBaseNum)
    if nMinNum > nDetNum then
      nMinNum = nDetNum
    end
  end
  local szContent = "50个月影之石和1个开阳石换取1个噬魂珠\n"

  for szPutItem, tbInfo in pairs(tbItemList) do
    szContent = string.format("%s<color=green>%s<color>：<color=yellow>%s<color>个\n", szContent, tbInfo.szItemName, tbInfo.nNum)
  end

  if nMinNum <= 0 or nMinNum >= 99999999 then
    szContent = string.format("%s可兑换<color=green>噬魂珠<color>：<color=yellow>0<color>个", szContent)
  else
    szContent = string.format("%s可兑换<color=green>噬魂珠<color>：<color=yellow>%s<color>个", szContent, nMinNum)
  end

  tbGiftSelf:UpdateContent(szContent)
  return 1
end

function GbWlls:CheckGiftItem_ChengZhuBox(tbGiftSelf, pPickItem, pDropItem, nX, nY)
  local pItem = tbGiftSelf:First()
  local tbItemList = GbWlls.tbDropItem_ChengZhuBox
  for szItemPut, tbInfo in pairs(tbItemList) do
    tbInfo.nNum = 0
  end
  while pItem do
    local szIndex = string.format("%s,%s,%s,%s", pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel)
    if tbItemList[szIndex] then
      tbItemList[szIndex].nNum = tbItemList[szIndex].nNum + pItem.nCount
    end
    pItem = tbGiftSelf:Next()
  end

  if pDropItem then
    -- 判断要放入道具是否是指定的礼品
    local szIndex = string.format("%d,%d,%d,%d", pDropItem.nGenre, pDropItem.nDetail, pDropItem.nParticular, pDropItem.nLevel)
    if not tbItemList[szIndex] then
      me.Msg("该类型物品不能兑换辉煌战功箱。")
      return 0
    end
    tbItemList[szIndex].nNum = tbItemList[szIndex].nNum + pDropItem.nCount
  end

  if pPickItem then
    local szIndex = string.format("%d,%d,%d,%d", pPickItem.nGenre, pPickItem.nDetail, pPickItem.nParticular, pPickItem.nLevel)
    if tbItemList[szIndex] then
      tbItemList[szIndex].nNum = tbItemList[szIndex].nNum - pPickItem.nCount
    end
  end

  local nMinNum = 99999999
  for szItem, tbItem in pairs(tbItemList) do
    local nDetNum = math.floor(tbItem.nNum / tbItem.nBaseNum)
    if nMinNum > nDetNum then
      nMinNum = nDetNum
    end
  end

  local nRemainCount = me.GetTask(GbWlls.TASKID_GROUP, GbWlls.TASKID_CHENGZHUBOX_NUM)
  if nRemainCount < nMinNum then
    nMinNum = nRemainCount
  end

  local szContent = "100个月影之石换取1个辉煌战功箱\n"
  if nRemainCount <= 0 then
    szContent = szContent .. "您的兑换辉煌战功箱的次数已经用完\n"
  end

  for szPutItem, tbInfo in pairs(tbItemList) do
    szContent = string.format("%s<color=green>%s<color>：<color=yellow>%s<color>个\n", szContent, tbInfo.szItemName, tbInfo.nNum)
  end

  if nMinNum <= 0 or nMinNum >= 99999999 then
    szContent = string.format("%s可兑换<color=green>辉煌战功箱<color>：<color=yellow>0<color>个", szContent)
  else
    szContent = string.format("%s可兑换<color=green>辉煌战功箱<color>：<color=yellow>%s<color>个", szContent, nMinNum)
  end

  tbGiftSelf:UpdateContent(szContent)
  return 1
end

function GbWlls:CheckGiftItem_ChengZhanBox(tbGiftSelf, pPickItem, pDropItem, nX, nY)
  local pItem = tbGiftSelf:First()
  local tbItemList = GbWlls.tbDropItem_ChengZhanBox
  for szItemPut, tbInfo in pairs(tbItemList) do
    tbInfo.nNum = 0
  end
  while pItem do
    local szIndex = string.format("%s,%s,%s,%s", pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel)
    if tbItemList[szIndex] then
      tbItemList[szIndex].nNum = tbItemList[szIndex].nNum + pItem.nCount
    end
    pItem = tbGiftSelf:Next()
  end

  if pDropItem then
    -- 判断要放入道具是否是指定的礼品
    local szIndex = string.format("%d,%d,%d,%d", pDropItem.nGenre, pDropItem.nDetail, pDropItem.nParticular, pDropItem.nLevel)
    if not tbItemList[szIndex] then
      me.Msg("该类型物品不能兑换卓越战功箱。")
      return 0
    end
    tbItemList[szIndex].nNum = tbItemList[szIndex].nNum + pDropItem.nCount
  end

  if pPickItem then
    local szIndex = string.format("%d,%d,%d,%d", pPickItem.nGenre, pPickItem.nDetail, pPickItem.nParticular, pPickItem.nLevel)
    if tbItemList[szIndex] then
      tbItemList[szIndex].nNum = tbItemList[szIndex].nNum - pPickItem.nCount
    end
  end

  local nMinNum = 99999999
  for szItem, tbItem in pairs(tbItemList) do
    local nDetNum = math.floor(tbItem.nNum / tbItem.nBaseNum)
    if nMinNum > nDetNum then
      nMinNum = nDetNum
    end
  end

  local nRemainCount = me.GetTask(GbWlls.TASKID_GROUP, GbWlls.TASKID_CHENGZHANBOX_NUM)
  if nRemainCount < nMinNum then
    nMinNum = nRemainCount
  end

  local szContent = "2个月影之石换取1个卓越战功箱\n"

  if nRemainCount <= 0 then
    szContent = szContent .. "您的兑换卓越战功箱的次数已经用完\n"
  end

  for szPutItem, tbInfo in pairs(tbItemList) do
    szContent = string.format("%s<color=green>%s<color>：<color=yellow>%s<color>个\n", szContent, tbInfo.szItemName, tbInfo.nNum)
  end

  if nMinNum <= 0 or nMinNum >= 99999999 then
    szContent = string.format("%s可兑换<color=green>卓越战功箱<color>：<color=yellow>0<color>个", szContent)
  else
    szContent = string.format("%s可兑换<color=green>卓越战功箱<color>：<color=yellow>%s<color>个", szContent, nMinNum)
  end

  tbGiftSelf:UpdateContent(szContent)
  return 1
end
