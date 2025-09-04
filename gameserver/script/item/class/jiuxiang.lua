--酒箱子
--孙多良
--2008.08.07

local tbItem = Item:GetClass("jiuxiang")
tbItem.tbJiu = {
  { "陈年西北望", 48 },
  { "陈年稻花香", 49 },
  { "陈年女儿红", 50 },
  { "陈年杏花村", 51 },
  { "陈年烧刀子", 52 },
}

function tbItem:OnUse()
  --安全处理
  if it.GetGenInfo(1) >= it.GetExtParam(1) then
    if me.DelItem(it, Player.emKLOSEITEM_USE) ~= 1 then
      return
    end
  end

  local tbOpt = {}
  for i, tbJiu in pairs(self.tbJiu) do
    table.insert(tbOpt, { tbJiu[1], self.OnOpenItem, self, tbJiu[2], it.dwId })
  end
  table.insert(tbOpt, { "我再考虑考虑" })
  local szMsg = "\n请选择您需所需要的酒。"
  Dialog:Say(szMsg, tbOpt)
end

function tbItem:OnOpenItem(nJiuPrap, nItemId)
  local pItem = KItem.GetObjById(nItemId)
  if not pItem then
    return 1
  end
  local nMaxTakeOutCount = pItem.GetExtParam(1) - pItem.GetGenInfo(1)
  Dialog:AskNumber("请输入取出的数量：", nMaxTakeOutCount, self.OnUseTakeOut, self, nJiuPrap, nItemId)
end

function tbItem:OnUseTakeOut(nJiuPrap, nItemId, nTakeOutCount)
  local pItem = KItem.GetObjById(nItemId)
  if not pItem then
    return 1
  end
  if nTakeOutCount <= 0 then
    return 0
  end
  local nTakeOutCountSure = nTakeOutCount
  if nTakeOutCount > pItem.GetExtParam(1) - pItem.GetGenInfo(1) then
    nTakeOutCountSure = pItem.GetExtParam(1) - pItem.GetGenInfo(1)
  end
  if me.CountFreeBagCell() < nTakeOutCountSure then
    Dialog:Say("您的背包空间不足。")
    return 0
  end
  for ni = 1, nTakeOutCountSure do
    local pAddItem = me.AddItem(18, 1, nJiuPrap, 1)
    if pAddItem then
      pItem.SetGenInfo(1, pItem.GetGenInfo(1) + 1)
      if pItem.GetGenInfo(1) >= pItem.GetExtParam(1) then
        break
      end
    end
  end
  pItem.Sync()
  if pItem.GetGenInfo(1) >= pItem.GetExtParam(1) then
    if me.DelItem(pItem, Player.emKLOSEITEM_USE) ~= 1 then
      return
    end
  end
end

function tbItem:GetTip(nState)
  local szTip = ""
  szTip = szTip .. string.format("<color=gold>右键点击打开<color>\n")
  szTip = szTip .. string.format("<color=yellow>剩余陈年酒数量: %s瓶<color>", (it.GetExtParam(1) - it.GetGenInfo(1)))
  return szTip
end
