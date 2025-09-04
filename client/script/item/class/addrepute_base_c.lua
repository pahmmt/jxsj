if not MODULE_GAMECLIENT then
  return
end

local tbClass = Item:GetClass("addrepute_base")

-- 目前只有3种声望加速符
local tbTaskId = {
  [1] = { 8, 1 },
  [2] = { 7, 1 },
  [3] = { 5, 4 },
}

function tbClass:GetTip()
  if TimeFrame:GetServerOpenDay() <= 365 then
    return ""
  end
  local nCamp = it.GetExtParam(1)
  local nClass = it.GetExtParam(2)
  local nTaskId = 0
  for nId, tbTemp in pairs(tbTaskId) do
    if tbTemp[1] == nCamp and tbTemp[2] == nClass then
      nTaskId = nId
      break
    end
  end
  if nTaskId == 0 then
    return ""
  end
  local nAccelerate = me.GetTask(2184, nTaskId)
  local szTip = string.format("<color=green>剩余累积声望奖励%s点<color>", nAccelerate / 100)
  return szTip
end
