function Player:OnAlterCheckReturn(tbRes)
  -- 排序，将验证失败的放到表的前面
  tbRes = tbRes or {}
  local tbSortRes = {}
  local nCurError = 0
  for i, tbInfo in pairs(tbRes) do
    if tbInfo[1] == 0 then
      nCurError = nCurError + 1
      table.insert(tbSortRes, nCurError, tbInfo)
    else
      table.insert(tbSortRes, tbInfo)
    end
  end

  Ui(Ui.UI_REINCARNATE):OnCheckResult(tbSortRes)
end

function Player:OnAlterResult(nRes)
  Ui(Ui.UI_REINCARNATE):OnAlterResult(nRes)
end

function Player:OnXmas12GainScore(nScore)
  -- 添加特效
  local _, x, y = me.GetWorldPos()
  me.CastSkill(2439, 1, x * 32, y * 32)
  -- 浮动字
  TestFlyChar(25, nScore)
end
