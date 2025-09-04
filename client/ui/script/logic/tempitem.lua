-- 临时道具管理

Ui.tbLogic.tbTempItem = {}
local tbTempItem = Ui.tbLogic.tbTempItem

function tbTempItem:Init()
  self.tbItem = {} -- 注意该表下标未必连续
end

function tbTempItem:Clear()
  for _, pItem in pairs(self.tbItem) do
    self:Destroy(pItem)
  end
  self.tbItem = {}
end

function tbTempItem:Create(...)
  local pItem = KItem.CreateTempItem(unpack(arg))
  if not pItem then
    return
  end
  table.insert(self.tbItem, pItem)
  return pItem
end

-- tbItemInfo =
--{
--	bForceBind,						强制绑定默认0
--}
function tbTempItem:CreateEx(tbItemInfo, ...)
  local pItem = KItem.CreateTempItem(unpack(arg))
  if not pItem then
    return
  end

  if tbItemInfo.bForceBind >= 0 then
    pItem.Bind(tbItemInfo.bForceBind)
  end

  table.insert(self.tbItem, pItem)
  return pItem
end

function tbTempItem:Destroy(pItem)
  for i, p in pairs(self.tbItem) do
    if pItem == p then
      pItem.Remove()
      self.tbItem[i] = nil
    end
  end
end
