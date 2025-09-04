-------------------------------------------------------
-- 文件名　：baibaoxiang_c.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2009-04-20 10:14:26
-- 文件描述：
-------------------------------------------------------

-- get round result
function Baibaoxiang:GetRoundResult(pPlayer, nRound)
  if nRound < 1 or nRound > 6 then
    return
  end

  -- get task
  local nTask = pPlayer.GetTask(2086, 5)

  -- offset
  local nIndex = (nRound - 1) * 5

  -- type
  local nType = Lib:LoadBits(nTask, nIndex, nIndex + 2)

  -- level
  local nLevel = Lib:LoadBits(nTask, nIndex + 3, nIndex + 4)

  -- rand
  local nRandGrid = Lib:LoadBits(nTask, 30, 31)

  return nType, nLevel, nRandGrid
end
