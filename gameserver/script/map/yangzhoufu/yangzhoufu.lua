local tbTest = Map:GetClass(26) -- 地图Id

-- 定义玩家进入事件
function tbTest:OnEnter(szParam) end

-- 定义玩家离开事件
function tbTest:OnLeave(szParam)
  if SpecialEvent.Xmas2012:IsPlayerInRace(me) == 1 then
    SpecialEvent.Xmas2012:OnPlayerRaceEnd(me, 1) -- 离开地图，设置赛跑失败
  end
end
