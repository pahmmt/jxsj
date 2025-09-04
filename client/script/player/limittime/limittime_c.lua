--
-- FileName: limittime_c.lua
-- Author: zhongjunqi
-- Time: 2012/7/10 09:34
-- Comment: 防沉迷系统
--

if not MODULE_GAMECLIENT then
  return
end

Require("\\script\\player\\limittime\\limittime_def.lua")

Player.tbLimitTime = Player.tbLimitTime or {}
local tbLimitTime = Player.tbLimitTime

-- 提示防沉迷的时间
tbLimitTime.tbNotifyTime = { 3600, 7200, 10200, 10500 }
function tbLimitTime:_OnLogin()
  local nLimitTimeFlag, nLimitTimeOnlineTime, _ = GetLimitTimeInfo()
  if not nLimitTimeFlag then
    return
  end
  if self:IsNoInfoAndLimited(nLimitTimeFlag) == 0 and self:IsHasInfoAndLimited(nLimitTimeFlag) == 0 then
    return
  end
  self.tbEventId = self.tbEventId or {}

  for _, nEventId in pairs(self.tbEventId) do
    Timer:Close(nEventId)
  end
  self.tbEventId = {}
  for _, v in ipairs(self.tbNotifyTime) do -- 注册定时器
    if v > nLimitTimeOnlineTime then
      self.tbEventId[v] = Timer:Register((v - nLimitTimeOnlineTime) * Env.GAME_FPS, self.OnLimitTimeout, self, v)
    end
  end
end

function tbLimitTime:_OnLogout()
  if not self.tbEventId then
    return
  end
  for _, nEventId in pairs(self.tbEventId) do
    Timer:Close(nEventId)
  end
  self.tbEventId = nil
end

function tbLimitTime:OnLimitTimeout(nOnlineTime)
  local nLimitTimeFlag, _, _ = GetLimitTimeInfo()
  UiManager:OpenWindow(Ui.UI_LIMITTIME_NOTIFY, self:IsHasInfoAndLimited(nLimitTimeFlag), self.nLimitTime - nOnlineTime)
  self.tbEventId[nOnlineTime] = nil
  return 0
end

function tbLimitTime:IsNoInfoAndLimited(nLimitTimeFlag)
  if nLimitTimeFlag == 1 or nLimitTimeFlag == 7 or nLimitTimeFlag == 8 or nLimitTimeFlag == 9 or nLimitTimeFlag == 10 or nLimitTimeFlag == 11 or nLimitTimeFlag == 12 then
    return 1
  else
    return 0
  end
end

function tbLimitTime:IsHasInfoAndLimited(nLimitTimeFlag)
  if nLimitTimeFlag == 6 or nLimitTimeFlag == 3 then
    return 1
  else
    return 0
  end
end
