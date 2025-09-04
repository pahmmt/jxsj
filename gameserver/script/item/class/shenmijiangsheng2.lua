--神秘疆绳
--sunduoliang
--2008.10.30

local tbItem = Item:GetClass("shenmijiangsheng2")

tbItem.tbHorse = {
  { 1, 12, 28, 3 }, --奇珍阁（乌云踏雪）
  { 1, 12, 29, 3 }, --奇珍阁（的卢）
  { 1, 12, 30, 3 }, --奇珍阁（绝影）
  { 1, 12, 31, 3 }, --奇珍阁（照夜玉狮子）
  { 1, 12, 32, 3 }, --奇珍阁（汗血宝马）
}
tbItem.nLimitTime = Item.IVER_nShenMiHorse

function tbItem:OnUse()
  local szMsg = "神秘疆绳，可捕获极品马匹，请选择你想要的马匹。\n<color=red>（获得马匹将会自动绑定）<color>"
  local tbOpt = {}
  for nId, tbHorse in ipairs(self.tbHorse) do
    local szName = KItem.GetNameById(unpack(tbHorse))
    table.insert(tbOpt, { szName, self.GetHorse, self, it.dwId, nId })
  end
  table.insert(tbOpt, { "我再考虑考虑" })
  Dialog:Say(szMsg, tbOpt)
end

function tbItem:GetHorse(nItemId, nId, nFlag)
  local pItem = KItem.GetObjById(nItemId)
  if not pItem then
    return 0
  end
  if not nFlag then
    local szMsg = string.format("您选择了<color=yellow>%s<color>，使用后得到马匹将会<color=red>自动绑定<color>，您确定使用吗？", KItem.GetNameById(unpack(self.tbHorse[nId])))
    local tbOpt = {
      { "确定使用", self.GetHorse, self, nItemId, nId, 1 },
      { "我再考虑考虑" },
    }
    Dialog:Say(szMsg, tbOpt)
    return
  end
  if me.DelItem(pItem) ~= 1 then
    return
  end
  local pAddItem = me.AddItem(unpack(self.tbHorse[nId]))
  if pAddItem then
    pAddItem.Bind(1)
    me.SetItemTimeout(pAddItem, os.date("%Y/%m/%d/%H/%M/%S", GetTime() + self.nLimitTime * 24 * 3600), 0)
    me.Msg(string.format("你获得了一个<color=yellow>%s<color>", pAddItem.szName))
  end
end
