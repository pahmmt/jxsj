-- 文件名　：followpartner_base_c.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-05-23 10:42:59
-- 功能    ：

local tbItem = Item:GetClass("FollowPartner")

function tbItem:GetTip()
  local nNpcId = tonumber(it.GetExtParam(1))
  local nType = tonumber(it.GetExtParam(2))
  local nLastCallTime = me.GetTask(2112, 7)
  local nAwardType = me.GetTask(2112, 8)
  local nAwardTotalPlayer = me.GetTask(2112, 9)
  local nRelTime = me.GetTask(2112, 10)
  if nLastCallTime > 0 then
    nRelTime = nRelTime - (GetTime() - nLastCallTime)
  end
  local nAwardTotalItem = it.GetGenInfo(1)
  local nState = it.GetGenInfo(2)
  local tbType = Npc.tbFollowPartner.tbFollowPartner[nType]
  local szClientTip = Npc.tbFollowPartner.tbClientTip[nType]
  if nNpcId > 0 and nType > 0 and tbType and szClientTip then
    local nAwardTotal = tbType[6]
    if tbType[5] == 2 then
      nAwardTotalItem = me.GetBaseAwardExp() * nAwardTotalItem
      nAwardTotalPlayer = me.GetBaseAwardExp() * nAwardTotalPlayer
      nAwardTotal = me.GetBaseAwardExp() * nAwardTotal
    end
    if nState <= 0 then
      return "<color=red>宠物没有被召唤出来<color>\n\n" .. string.format(szClientTip, nAwardTotalItem, nAwardTotal)
    elseif nState == 1 and nLastCallTime > 0 and nRelTime > 0 then
      return "<color=green>宠物正在召唤中...<color>\n\n" .. string.format(szClientTip, nAwardTotalPlayer, nAwardTotal)
    end
  end
  return ""
end
