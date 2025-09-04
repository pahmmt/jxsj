-- 文件名  : dts_c.lua
-- 创建者  : jiazhenwei
-- 创建时间: 2010-12-14 16:50:11
-- 描述    : 雪花效果

function DaTaoSha:OnTimer()
  local SKILL_ID = 15
  local RANGE_WIDTH = 32
  local RANGE_HIGHT = 32
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
end

function DaTaoSha:OpenTimer()
  if not self.nSnowTimer then
    self.nSnowTimer = Timer:Register(1, self.OnTimer)
  end
end

function DaTaoSha:CloseTimer()
  if self.nSnowTimer then
    Timer:Close(self.nSnowTimer)
    self.nSnowTimer = nil
  end
end

function DaTaoSha:RefreshShortcutWindow()
  Timer:Register(36, self.RefreshShortcutWindowEx)
end

function DaTaoSha:RefreshShortcutWindowEx()
  UiManager:CloseWindow(Ui.UI_SHORTCUTBAR)
  UiManager:OpenWindow(Ui.UI_SHORTCUTBAR)
  return 0
end
