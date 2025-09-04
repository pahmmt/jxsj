Ui.tbNewBag = Ui.tbNewBag or {}
local tbNewBag = Ui.tbNewBag

local WNDINFO = {
  [Item.EXTBAG_4CELL] = {
    nWidth = Item.EXTBAG_WIDTH_4CELL,
    nHeight = Item.EXTBAG_HEIGHT_4CELL,
  },
  [Item.EXTBAG_6CELL] = {
    nWidth = Item.EXTBAG_WIDTH_6CELL,
    nHeight = Item.EXTBAG_HEIGHT_6CELL,
  },
  [Item.EXTBAG_8CELL] = {
    nWidth = Item.EXTBAG_WIDTH_8CELL,
    nHeight = Item.EXTBAG_HEIGHT_8CELL,
  },
  [Item.EXTBAG_10CELL] = {
    nWidth = Item.EXTBAG_WIDTH_10CELL,
    nHeight = Item.EXTBAG_HEIGHT_10CELL,
  },
  [Item.EXTBAG_12CELL] = {
    nWidth = Item.EXTBAG_WIDTH_12CELL,
    nHeight = Item.EXTBAG_HEIGHT_12CELL,
  },
  [Item.EXTBAG_15CELL] = {
    nWidth = Item.EXTBAG_WIDTH_15CELL,
    nHeight = Item.EXTBAG_HEIGHT_15CELL,
  },
  [Item.EXTBAG_18CELL] = {
    nWidth = Item.EXTBAG_WIDTH_18CELL,
    nHeight = Item.EXTBAG_HEIGHT_18CELL,
  },
  [Item.EXTBAG_20CELL] = {
    nWidth = Item.EXTBAG_WIDTH_20CELL,
    nHeight = Item.EXTBAG_HEIGHT_20CELL,
  },
  [Item.EXTBAG_24CELL] = {
    nWidth = Item.EXTBAG_WIDTH_24CELL,
    nHeight = Item.EXTBAG_HEIGHT_24CELL,
  },
}

local MAPPING_INTEGRATIONBAGROOM = -- 该表包含了新背包的空间
  {
    Item.ROOM_INTEGRATIONBAG1,
    Item.ROOM_INTEGRATIONBAG2,
    Item.ROOM_INTEGRATIONBAG3,
    Item.ROOM_INTEGRATIONBAG4,
    Item.ROOM_INTEGRATIONBAG5,
    Item.ROOM_INTEGRATIONBAG6,
    Item.ROOM_INTEGRATIONBAG7,
    Item.ROOM_INTEGRATIONBAG8,
    Item.ROOM_INTEGRATIONBAG9,
    Item.ROOM_INTEGRATIONBAG10,
    Item.ROOM_INTEGRATIONBAG11,
  }

-- 检查是否是新背包的虚拟空间
function tbNewBag:CheckNewBagMapingRoom(nRoom)
  if not nRoom then
    return 0
  end
  for _, n in ipairs(MAPPING_INTEGRATIONBAGROOM) do
    if nRoom == n then
      return 1
    end
  end
  return 0
end

-- 获取真实地址
function tbNewBag:GetTrueRoomPosByMaping(nRoom, nX, nY)
  if self:CheckNewBagMapingRoom(nRoom) == 1 then
    local nStartPos = (nRoom - Item.ROOM_INTEGRATIONBAG1) * Item.ROOM_INTEGRATIONBAG_WIDTH
    local nPos = nStartPos + nX
    local nMainBagSize = Item.ROOM_MAINBAG_WIDTH * Item.ROOM_MAINBAG_HEIGHT
    if nPos < nMainBagSize then
      local nTrueY = math.floor(nPos / Item.ROOM_MAINBAG_WIDTH)
      local nTrueX = math.mod(nPos, Item.ROOM_MAINBAG_WIDTH)
      return Item.ROOM_MAINBAG, nTrueX, nTrueY
    end
    nPos = nPos - nMainBagSize -- 寻找在第几个背包
    local tbExtBagRoom = { [0] = Item.ROOM_EXTBAG1, [1] = Item.ROOM_EXTBAG2, [2] = Item.ROOM_EXTBAG3 }
    for i = 0, 2 do
      local pExtBag = me.GetExtBag(i)
      if pExtBag then
        local nType = pExtBag.nDetail
        local tbInfo = WNDINFO[nType]
        if not tbInfo then
          return nil
        end
        if nPos < tbInfo.nWidth * tbInfo.nHeight then
          local nTrueY = math.floor(nPos / tbInfo.nWidth)
          local nTrueX = math.mod(nPos, tbInfo.nWidth)
          return tbExtBagRoom[i], nTrueX, nTrueY
        end
        nPos = nPos - tbInfo.nWidth * tbInfo.nHeight
      end
    end
    return nil
  end
  return nRoom, nX, nY
end

-- 获取虚拟的地址
function tbNewBag:GetMapingRoomPosByTrue(nRoom, nX, nY)
  local nPos = 0
  if nRoom == Item.ROOM_MAINBAG then
    nPos = nY * Item.ROOM_MAINBAG_WIDTH + nX
    return math.floor(nPos / Item.ROOM_INTEGRATIONBAG_WIDTH) + Item.ROOM_INTEGRATIONBAG1, math.mod(nPos, Item.ROOM_INTEGRATIONBAG_WIDTH), 0
  elseif nRoom == Item.ROOM_EXTBAG1 then
    nPos = Item.ROOM_MAINBAG_HEIGHT * Item.ROOM_MAINBAG_WIDTH
    local pExtBag1 = me.GetExtBag(0)
    if pExtBag1 then
      local nType = pExtBag1.nDetail
      local tbInfo = WNDINFO[nType]
      if not tbInfo then
        return
      end
      nPos = nPos + tbInfo.nWidth * nY + nX
      return math.floor(nPos / Item.ROOM_INTEGRATIONBAG_WIDTH) + Item.ROOM_INTEGRATIONBAG1, math.mod(nPos, Item.ROOM_INTEGRATIONBAG_WIDTH), 0
    end
    return nil
  elseif nRoom == Item.ROOM_EXTBAG2 then
    nPos = Item.ROOM_MAINBAG_HEIGHT * Item.ROOM_MAINBAG_WIDTH
    local pExtBag1 = me.GetExtBag(0)
    if pExtBag1 then
      local nType = pExtBag1.nDetail
      local tbInfo = WNDINFO[nType]
      if not tbInfo then
        return
      end
      nPos = nPos + tbInfo.nWidth * tbInfo.nHeight
    end
    local pExtBag2 = me.GetExtBag(1)
    if pExtBag2 then
      local nType = pExtBag2.nDetail
      local tbInfo = WNDINFO[nType]
      if not tbInfo then
        return
      end
      nPos = nPos + tbInfo.nWidth * nY + nX
      return math.floor(nPos / Item.ROOM_INTEGRATIONBAG_WIDTH) + Item.ROOM_INTEGRATIONBAG1, math.mod(nPos, Item.ROOM_INTEGRATIONBAG_WIDTH), 0
    end
    return nil
  elseif nRoom == Item.ROOM_EXTBAG3 then
    nPos = Item.ROOM_MAINBAG_HEIGHT * Item.ROOM_MAINBAG_WIDTH
    local pExtBag1 = me.GetExtBag(0)
    if pExtBag1 then
      local nType = pExtBag1.nDetail
      local tbInfo = WNDINFO[nType]
      if not tbInfo then
        return
      end
      nPos = nPos + tbInfo.nWidth * tbInfo.nHeight
    end
    local pExtBag2 = me.GetExtBag(1)
    if pExtBag2 then
      local nType = pExtBag2.nDetail
      local tbInfo = WNDINFO[nType]
      if not tbInfo then
        return
      end
      nPos = nPos + tbInfo.nWidth * tbInfo.nHeight
    end
    local pExtBag3 = me.GetExtBag(2)
    if pExtBag3 then
      local nType = pExtBag3.nDetail
      local tbInfo = WNDINFO[nType]
      if not tbInfo then
        return
      end
      nPos = nPos + tbInfo.nWidth * nY + nX
      return math.floor(nPos / Item.ROOM_INTEGRATIONBAG_WIDTH) + Item.ROOM_INTEGRATIONBAG1, math.mod(nPos, Item.ROOM_INTEGRATIONBAG_WIDTH), 0
    end
    return nil
  end
  return nRoom, nX, nY
end

-- 检查是否是同一个位置的物品
function tbNewBag:CheckIsSameObj(nRoom1, nX1, nY1, nRoom2, nX2, nY2)
  local nRoom1, nX1, nY1 = self:GetTrueRoomPosByMaping(nRoom1, nX1, nY1)
  local nRoom2, nX2, nY2 = self:GetTrueRoomPosByMaping(nRoom2, nX2, nY2)
  if nRoom1 and nRoom2 then
    if nRoom1 ~= nRoom2 or nX1 ~= nX2 or nY1 ~= nY2 then
      return 0
    end
    return 1
  end
  return 0
end

-- 获取玩家背包和扩展背包的总个数
function tbNewBag:GetExtBagSize(nType)
  if not WNDINFO[nType] then
    return 0
  end
  return WNDINFO[nType].nWidth * WNDINFO[nType].nHeight
end
