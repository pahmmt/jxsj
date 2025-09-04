-------------------------------------------------------
-- 文件名　：qingren_2011_card.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2011-01-07 16:39:08
-- 文件描述：
-------------------------------------------------------

-- 爱神卡
local tbWomenday_2011 = {}
local tbItem = Item:GetClass("womenday_card_2011")

tbWomenday_2011.TASK_GID = 2190 --2155;
tbWomenday_2011.TASK_CARD = {
  [1] = { { 1, "白秋琳", 3570 }, { 2, "沈荷叶", 3562 }, { 3, "郝漂靓", 3563 } },
  [2] = { { 4, "叶芷琳", 3576 }, { 5, "古枫霞", 3601 }, { 6, "晏若雪", 3603 } },
  [3] = { { 7, "尹筱雨", 3536 }, { 8, "古嫣然", 3524 }, { 9, "无想师太", 3530 }, { 10, "红姨", 6513 } },
}

function tbItem:GetTip(nState)
  local szTip = ""
  local nCount = 0
  for _, tbLine in ipairs(tbWomenday_2011.TASK_CARD) do
    for _, tbTaskId in ipairs(tbLine) do
      if me.GetTask(tbWomenday_2011.TASK_GID, tbTaskId[1]) == 0 then
        szTip = szTip .. string.format("<color=gray>%s<color> ", tbTaskId[2])
      else
        nCount = nCount + 1
        szTip = szTip .. string.format("<color=yellow>%s<color> ", tbTaskId[2])
      end
    end
    szTip = szTip .. "\n"
  end
  szTip = szTip .. string.format("<color=yellow>（%s/%s）<color>", nCount, 10)
  return szTip
end
