-- 文件名　：healthy.lua
-- 创建者　：FanZai
-- 创建时间：2008-03-23 23:19:38

local tbHealthy = Ui.tbLogic.tbHealthy or {}
Ui.tbLogic.tbHealthy = tbHealthy

tbHealthy.TIME_NOTIFY = 3600 * Env.GAME_FPS

function tbHealthy:Init()
  if self.nTimerRegId then
    return
  end
  self.nTimerRegId = 0
end

function tbHealthy:OnTimer()
  -- 不是个长久之计
  if me.nLevel < 20 then
    return
  end

  Ui(Ui.UI_TASKTIPS):Begin("您已经连续游戏一小时，建议您暂时离开电脑，舒展筋骨，休息双眼")
end

function tbHealthy:OnEnterGame()
  assert(self.nTimerRegId == 0)
  self.nTimerRegId = Timer:Register(self.TIME_NOTIFY, self.OnTimer, self)
end

function tbHealthy:OnLeaveGame()
  if self.nTimerRegId ~= 0 then
    Timer:Close(self.nTimerRegId)
    self.nTimerRegId = 0
  end
end
