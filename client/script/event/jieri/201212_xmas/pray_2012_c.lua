-- 文件名　：pray_2012_c.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-12-10 09:28:57
-- 功能说明：2012.12月新服活动-祈福2012

local tbItem = Item:GetClass("xmas_2012_pray")
tbItem.nTaskGroupId = 2216
tbItem.nFactionStartTask = 21
tbItem.nFactionEndTask = 33

function tbItem:OnClientUse()
  local pNpc = me.GetSelectNpc()
  if not pNpc then
    return 0
  end
  return pNpc.dwId
end

function tbItem:GetTip()
  local szTip = "获得的祝福：\n\n"
  for i = self.nFactionStartTask, self.nFactionEndTask do
    local nIndex = i - self.nFactionStartTask + 1
    local nFlag = me.GetTask(self.nTaskGroupId, i)
    local szFactionName = Player.tbFactions[nIndex].szName
    local szColor = "gray"
    if nFlag == 1 then
      szColor = "green"
    end
    szTip = szTip .. string.format("<color=%s>%s<color>", szColor, Lib:StrFillL(szFactionName, 10))
    if math.fmod(nIndex, 4) == 0 then
      szTip = szTip .. "\n"
    end
  end
  return szTip
end
