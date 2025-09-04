-- 文件名　：horse_box_base.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-02-09 15:00:19
-- 功能    ：财宝兔箱子

local tbItem = Item:GetClass("zhounianqing2012_patbox")

tbItem.nMaxRandom = 1000
tbItem.tbPat = {
  [0] = {
    { "柔小翠", { 18, 1, 1833, 1 }, 1, 1, 1 * 3600 * 24, 500 },
    { "玫瑰精灵", { 18, 1, 1833, 2 }, 1, 1, 1 * 3600 * 24, 500 },
  },
  [1] = {
    { "雷锋兔", { 18, 1, 1834, 1 }, 1, 1, 1 * 3600 * 24, 500 },
    { "剑神", { 18, 1, 1834, 2 }, 1, 1, 1 * 3600 * 24, 500 },
  },
}

function tbItem:OnUse()
  local tbInfo = self.tbPat[me.nSex]
  if not tbInfo then
    Dialog:Say("宠物宝箱出问题了！")
    return 0
  end
  if me.CountFreeBagCell() < 1 then
    Dialog:Say(string.format("请留出<color=green>1格<color>背包空间。"))
    return 0
  end

  local nRand = MathRandom(1, self.nMaxRandom)
  local nIndex = 1
  if nRand > tbInfo[1][6] then
    nIndex = 2
  end
  local tbOneInfo = tbInfo[nIndex]
  Dbg:WriteLog("ZhouNianQing2012", "zhounianqing2012_patbox", me.szName, me.nSex, nIndex)

  local pItemEx = me.AddItem(unpack(tbOneInfo[2]))
  if tbInfo[3] == 1 then
    pItemEx.Bind(1)
  end
  if pItemEx then
    pItemEx.SetTimeOut(0, GetTime() + tbOneInfo[5])
    pItemEx.Sync()
  end
  return 1
end
