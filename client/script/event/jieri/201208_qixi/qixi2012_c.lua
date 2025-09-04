-- 文件名  : qixi2012_c.lua
-- 创建者  : huangxiaoming
-- 创建时间: 2012-8-17 10:50:11
-- 描述    : 雪花效果

SpecialEvent.QiXi2012 = SpecialEvent.QiXi2012 or {}
local tbQiXi2012 = SpecialEvent.QiXi2012 or {}

function tbQiXi2012:OnTimer(nSkillId, nDis)
  if not self.nRemainFrame or self.nRemainFrame <= 0 then
    return 0
  end
  local RANGE_WIDTH = nDis or 64
  local RANGE_HIGHT = nDis or 64
  local nMapId, nMapX, nMapY = me.GetWorldPos()
  if nMapId <= 0 or nMapX <= 0 then
    return
  end
  local w = math.floor(RANGE_WIDTH / 2)
  local h = math.floor(RANGE_HIGHT / 2)
  for i = 1, 2 do
    local x = nMapX + MathRandom(-w, w)
    local y = nMapY + MathRandom(-h, h) + h / 2 -- 偏下一点，这样飘落起始位置就不会太靠上
    me.CastSkill(nSkillId, 1, x * 32, y * 32)
  end
  self.nRemainFrame = self.nRemainFrame - 1
end

function tbQiXi2012:OpenTimer(nSkillId, nDuration)
  self.nRemainFrame = nDuration or 18 * 60
  self:CloseTimer()
  if not self.nSnowTimer then
    self.nSnowTimer = Timer:Register(1, self.OnTimer, self, nSkillId)
  end
end

function tbQiXi2012:CloseTimer()
  if self.nSnowTimer then
    Timer:Close(self.nSnowTimer)
    self.nSnowTimer = nil
  end
end
