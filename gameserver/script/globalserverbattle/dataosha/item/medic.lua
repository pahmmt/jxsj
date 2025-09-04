-- 文件名　：medic.lua
-- 创建者　：jiazhenwei
-- 创建时间：2009-12-02 09:40:06
-- 描  述  ：

local tbItem = Item:GetClass("medicpaper")
tbItem.szInfo = '"本草秘方"集合了天地精华为您打造出江湖必备的精品良药！'
tbItem.tbMedic = {
  [1] = {
    { 18, 1, 505, 1 }, --回天丹箱
    { 18, 1, 506, 1 }, --大补散箱
    { 18, 1, 538, 1 }, --大逃杀万灵丹·箱
  },
  [2] = {
    { 18, 1, 497, 1 }, --九转还魂丹箱
    { 18, 1, 498, 1 }, --首乌还神丹箱
    { 18, 1, 539, 1 }, --大逃杀万灵丹·箱
  },
}
tbItem.tbMedicName = {
  [1] = {
    "寒武遗迹回血丹·箱（低级）",
    "寒武遗迹回内丹·箱（低级）",
    "寒武遗迹万灵丹·箱（低级）",
  },
  [2] = {
    "寒武遗迹回血丹·箱（高级）",
    "寒武遗迹回内丹·箱（高级）",
    "寒武遗迹万灵丹·箱（高级）",
  },
}
function tbItem:OnUse()
  local tbOpt = {}
  for i = 1, 3 do
    table.insert(tbOpt, { self.tbMedicName[DaTaoSha:GetPlayerMission(me).nLevel][i], self.Select, self, i, it.dwId })
  end
  Dialog:Say(self.szInfo, tbOpt)
  return 0
end

function tbItem:Select(nType, nId)
  me.AddItem(unpack(self.tbMedic[DaTaoSha:GetPlayerMission(me).nLevel][nType]))
  local pItem = KItem.GetObjById(nId)
  if pItem then
    pItem.Delete(me)
  end
end
