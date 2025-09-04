-- 文件名　：dayplayerback_item_c.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-07-03 17:17:36
-- 功能    ：

SpecialEvent.tbDayPlayerBack = SpecialEvent.tbDayPlayerBack or {}
local tbDayPlayerBack = SpecialEvent.tbDayPlayerBack or {}

local tbItem = Item:GetClass("zhengzhanjianghuling")

function tbItem:GetTip()
  local szTip = "<color=gold>活动名         已领取 / 可领取 （上限）<color>\n"
  local nTaskBatch = me.GetTask(tbDayPlayerBack.TASK_GID, tbDayPlayerBack.TASK_ID_BATCH)
  local nItemBatch = me.GetTask(tbDayPlayerBack.TASK_GID, 1)
  if nTaskBatch ~= nItemBatch then
    szTip = "<color=red>令牌已经失效，请重新领取最新令牌<color>\n\n" .. szTip
  end
  local nRate = me.GetTask(tbDayPlayerBack.TASK_GID, tbDayPlayerBack.TASK_RATE_BACK)
  for i, tb in ipairs(tbDayPlayerBack.tbEventList) do
    local tbEvent = tbDayPlayerBack.tbEventList[i]
    local nMaxEvent = math.min(nRate * tbEvent[2], tbEvent[3])
    local nCount = me.GetTask(tbDayPlayerBack.TASK_GID, tb[5])
    local nCountMax = me.GetTask(tbDayPlayerBack.TASK_GID, tb[4])
    szTip = szTip .. string.format("%-20s%s / %s （<color=green>%s<color>）\n", tb[1], nCount, nCountMax, nMaxEvent)
  end
  return szTip
end
