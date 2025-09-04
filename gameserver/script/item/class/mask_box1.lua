-- 文件名　：horse_box_base.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-02-09 15:00:19
-- 功能    ：马牌箱子，从箱子中取出马牌，时间继承箱子

local tbItem = Item:GetClass("mask_box1")

tbItem.tbMask = {
  [1] = {
    szName = "传统圣诞面具箱",
    nDay = 7,
    tbItemList = {
      { 7, "圣诞老人", { 1, 13, 42, 1 }, 1, 1 },
      { 7, "圣诞少女", { 1, 13, 43, 1 }, 1, 1 },
    },
  },
  [2] = {
    szName = "时尚圣诞面具箱",
    nDay = 7,
    tbItemList = {
      { 7, "圣诞男孩和小熊（蓝）", { 1, 13, 164, 10 }, 1, 1 },
      { 7, "圣诞萝莉和小熊（蓝）", { 1, 13, 165, 10 }, 1, 1 },
      { 7, "圣诞男孩和雪人（红）", { 1, 13, 166, 10 }, 1, 1 },
      { 7, "圣诞萝莉和雪人（红）", { 1, 13, 167, 10 }, 1, 1 },
    },
  },
}

function tbItem:OnUse()
  local nKind = it.GetExtParam(1)
  if not self.tbMask[nKind] then
    Dialog:Say("道具异常！")
    return 0
  end
  local tbItemInfo = self.tbMask[nKind]
  local szInfo = string.format("请选择你想要的物品(只能选择一个喔~)：")
  local tbOpt = {}

  local tbItemList = tbItemInfo.tbItemList
  for i, tbInfo in pairs(tbItemList) do
    tbOpt[#tbOpt + 1] = { string.format("<color=yellow>%s<color>", tbInfo[2]), self.AddMask, self, nKind, it.dwId, i }
  end

  tbOpt[#tbOpt + 1] = { "关闭" }
  Dialog:Say(szInfo, tbOpt)
  return 0
end

function tbItem:AddMask(nKind, nItemId, nIndex)
  if me.CountFreeBagCell() < 1 then
    Dialog:Say(string.format("请留出<color=green>%s格<color>背包空间。", 1))
    return 0
  end

  local pItem = KItem.GetObjById(nItemId)
  if not pItem then
    return 0
  end

  local tbItemInfo = self.tbMask[nKind]
  local tbItemList = tbItemInfo.tbItemList
  local tbItem = tbItemList[nIndex]
  if not tbItem then
    return 0
  end

  pItem.Delete(me)
  local pItemEx = me.AddItem(unpack(tbItem[3]))
  if pItemEx then
    pItemEx.Bind(1)
    pItemEx.SetTimeOut(0, GetTime() + tbItem[1] * 3600 * 24)
    pItemEx.Sync()
  end
end
