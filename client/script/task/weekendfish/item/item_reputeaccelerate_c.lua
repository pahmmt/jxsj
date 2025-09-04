if not MODULE_GAMECLIENT then
  return
end

local tbClass = Item:GetClass("reputeaccelerate")

tbClass.tbTaskId = {
  [1526] = 1,
  [1527] = 2,
  [1528] = 3,
}

function tbClass:GetTip()
  local szTip = string.format("今日还可使用<color=yellow>%s个<color>", me.GetTask(2184, 5))

  local nAccelerate = me.GetTask(2184, self.tbTaskId[it.nParticular])
  local szTip = string.format("%s<enter><color=green>剩余累积声望奖励%s点<color>", szTip, nAccelerate / 100)
  return szTip
end
