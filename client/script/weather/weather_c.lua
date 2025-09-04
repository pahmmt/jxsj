-------------------------------------------------------
-- 文件名　：weather_c.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2011-12-3 12:24:50
-- 文件描述：
-------------------------------------------------------

if not MODULE_GAMECLIENT then
  return
end

Weather.tbWeather = {
  [1] = { "Weather:Rain", "Weather:StopRain" },
  [2] = { "Weather:StartShine", "Weather:StopShine" },
  [3] = { "Weather:StartSnow", "Weather:StopSnow" },
  [4] = { "Weather:StartDark", "Weather:StopDark" },
}

function Weather:ChangeWeather(nWeatherId)
  nWeatherId = (nWeatherId == 255) and 0 or nWeatherId
  self.nWeatherId = self.nWeatherId or 0
  assert(nWeatherId and nWeatherId >= 0 and nWeatherId <= #Weather.tbWeather)
  if self.nWeatherId ~= 0 and self.nWeatherId ~= nWeatherId then
    Lib:CallBack({ Weather.tbWeather[self.nWeatherId][2] })
  end
  if nWeatherId ~= 0 then
    Lib:CallBack({ Weather.tbWeather[nWeatherId][1] })
  end
  self.nWeatherId = nWeatherId
end

function Weather:Rain()
  SetAmbientLight(90, 90, 90, 3)
  ChangeWeather(1)
  OpenGroundEffect("\\image\\effect\\other\\ripple.spr", 0, 0)
end

function Weather:StopRain()
  DisableAmbientLight()
  ChangeWeather(-1)
  CloseGroundEffect()
end

-- extra
function Weather:StartShine()
  SetAmbientLight(176, 153, 97, 0)
end

function Weather:StopShine()
  DisableAmbientLight()
end

function Weather:StartSnow()
  Weather:StopSnow()
  Weather.nSnowTimer = Timer:Register(3, Weather.OnSnowTimer, Weather)
end

function Weather:StopSnow()
  if Weather.nSnowTimer and Timer:GetRestTime(Weather.nSnowTimer) > 0 then
    Timer:Close(Weather.nSnowTimer)
    Weather.nSnowTimer = nil
  end
end

function Weather:OnSnowTimer()
  local nSkillId = 15
  local nRangeWidth = 32
  local nRangeHight = 32
  local nMapId, nMapX, nMapY = me.GetWorldPos()
  if nMapId >= 0 and nMapX >= 0 then
    local w = math.floor(nRangeWidth / 2)
    local h = math.floor(nRangeHight / 2)
    for i = 1, 2 do
      local x = nMapX + MathRandom(-w, w)
      local y = nMapY + MathRandom(-h, h) + h / 2
      me.CastSkill(nSkillId, 1, x * 32, y * 32)
    end
  end
end

function Weather:StartDark()
  SetAmbientLight(80, 80, 80, 0)
end

function Weather:StopDark()
  DisableAmbientLight()
end
