-- zhouchenfei
-- 2012/9/13 11:19:12
-- 返还宝箱

local tbItem = Item:GetClass("2012guoqingbox")

tbItem.tbAddItem = { 18, 1, 510, 1 }
tbItem.tbWaiZhuang = {
  [Env.SEX_MALE] = {
    { 1, 25, 42, 1 },
    { 1, 26, 44, 1 },
  },
  [Env.SEX_FEMALE] = {
    { 1, 25, 43, 1 },
    { 1, 26, 45, 1 },
  },
}
tbItem.nGiveCount = 2
tbItem.nTime_WaiZhuang = 60 * 60 * 14 * 24
tbItem.nNeedFreeBag = 3

function tbItem:OnUse()
  if self.nNeedFreeBag > me.CountFreeBagCell() then
    me.Msg(string.format("您的背包剩余空间不足<color=yellow>%s<color>格，请整理后再来领取！", self.nNeedFreeBag))
    return 0
  end

  local nAddCount = me.AddStackItem(self.tbAddItem[1], self.tbAddItem[2], self.tbAddItem[3], self.tbAddItem[4], { bForceBind = 1 }, self.nGiveCount)
  if nAddCount ~= self.nGiveCount then
    Dbg:WriteLog("2012guoqingbox", me.szName, "增加物品寒武魂珠失败！")
  end

  local tbOneWaiZhuang = self.tbWaiZhuang[me.nSex]
  for i, tbInfo in pairs(tbOneWaiZhuang) do
    local pItem = me.AddItem(unpack(tbInfo))
    if pItem then
      pItem.Bind(1)
      me.SetItemTimeout(pItem, os.date("%Y/%m/%d/%H/%M/00", GetTime() + self.nTime_WaiZhuang))
      pItem.Sync()
      Dbg:WriteLog("2012guoqingbox", me.szName, "获取外装成功", unpack(tbInfo))
    else
      Dbg:WriteLog("2012guoqingbox", me.szName, "获取外装失败", unpack(tbInfo))
    end
  end

  return 1
end
