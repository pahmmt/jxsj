-- 文件名　：childrenday_item_c.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-05-14 11:48:12
-- 功能    ：

if not MODULE_GAMECLIENT then
  return
end

local tbItem = Item:GetClass("childrenday_book_2012")
SpecialEvent.tbChildrenDay2012 = SpecialEvent.tbChildrenDay2012 or {}
local tbChildrenDay2012 = SpecialEvent.tbChildrenDay2012

function tbItem:OnClientUse()
  local pNpc = me.GetSelectNpc()
  if not pNpc then
    return 0
  end
  return pNpc.dwId
end

function tbItem:GetTip()
  local szTip = ""
  local nDate = me.GetTask(tbChildrenDay2012.TASKID_GROUP, tbChildrenDay2012.TASKID_TIME)
  local nNowDate = tonumber(GetLocalDate("%Y%m%d"))
  for i, szName in ipairs(tbChildrenDay2012.tbFactionName) do
    local nFlag = me.GetTask(tbChildrenDay2012.TASKID_GROUP, tbChildrenDay2012.TASKID_FACTION_START + i - 1) or 0
    local szColor = "green"
    if nFlag ~= 1 or nNowDate ~= nDate then
      szColor = "gray"
    end
    local szMsg = string.format("<color=%s>", szColor)
    szTip = szTip .. Lib:StrFillL("", 3) .. szMsg .. Lib:StrFillL(szName, 5) .. "<color>"
    if math.fmod(i, 3) == 0 then
      szTip = szTip .. "\n"
    end
  end
  return szTip
end
