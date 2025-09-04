-- 文件名　：dropeffect_c.lua
-- 创建者　：
-- 创建时间：2012-11-29 15:53:51
-- 说　　明：下(雨)特效通用
if not MODULE_GAMECLIENT then
  return
end
Map.DropEffect = Map.DropEffect or {}
local DropEffect = Map.DropEffect
local nCounter = 0 --计数器

function DropEffect:OnTimer(nSkillId, nDis)
  local SKILL_ID = nSkillId or 15
  local DISTANCE = nDis or 32
  local RANGE_WIDTH = DISTANCE
  local RANGE_HIGHT = DISTANCE
  local nMapId, nMapX, nMapY = me.GetWorldPos()
  if nMapId <= 0 or nMapX <= 0 then
    return
  end
  local w = math.floor(RANGE_WIDTH / 2)
  local h = math.floor(RANGE_HIGHT / 2)
  for i = 1, 2 do
    local x = nMapX + MathRandom(-w, w)
    local y = nMapY + MathRandom(-h, h) + h / 2 -- 偏下一点，这样飘落起始位置就不会太靠上
    me.CastSkill(SKILL_ID, 1, x * 32, y * 32)
  end
  if nCounter then
    nCounter = nCounter - 1
    if nCounter <= 0 then
      Timer:Close(self.nSnowTimer)
      self.nSnowTimer = nil
    end
  end
end

function DropEffect:Show(nSkillId, nDis, nTimes)
  local SKILL_ID = nSkillId or 15
  local DISTANCE = nDis or 32
  nCounter = nTimes or -1

  if not self.nSnowTimer then
    self.nSnowTimer = Timer:Register(1, self.OnTimer, self, SKILL_ID, DISTANCE)
  else
    Timer:Close(self.nSnowTimer)
    self.nSnowTimer = nil
  end
end
