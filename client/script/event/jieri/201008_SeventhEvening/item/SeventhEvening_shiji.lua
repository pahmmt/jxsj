-------------------------------------------------------
-- 文件名　：SeventhEvening_shiji.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2010-07-22 19:17:28
-- 文件描述：
-------------------------------------------------------

local tbItem = Item:GetClass("QX_shiji")
SpecialEvent.SeventhEvening = SpecialEvent.SeventhEvening or {}
local tbSeventhEvening = SpecialEvent.SeventhEvening
tbSeventhEvening.Shiji = tbItem

function tbItem:GetTip(nState)
  local szTip = ""
  local nCount = 0
  for _, tbLine in ipairs(tbSeventhEvening.TASK_SHIJI) do
    for _, tbTaskId in ipairs(tbLine) do
      if me.GetTask(tbSeventhEvening.TASKID_GROUP, tbTaskId[1]) == 0 then
        szTip = szTip .. string.format("<color=gray>%s<color> ", tbTaskId[2])
      else
        nCount = nCount + 1
        szTip = szTip .. string.format("<color=yellow>%s<color> ", tbTaskId[2])
      end
    end
    szTip = szTip .. "\n"
  end
  szTip = szTip .. string.format("<color=yellow>（%s/%s）<color>", nCount, 56)
  return szTip
end
