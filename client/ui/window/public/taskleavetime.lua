----------------------------------------
-- 倒计时面板
-- ZhangDeheng
-- 2008/11/6  14:41
----------------------------------------

local uiTaskLeaveTime = Ui:GetClass("taskleavetime")

uiTaskLeaveTime.TEXTE_MSG = "TxtMsg"
uiTaskLeaveTime.TITLE = ""
uiTaskLeaveTime.SHOW_TEXT = ""
uiTaskLeaveTime.nLeaveTime = 0

-- 初始化
function uiTaskLeaveTime:Init() end

function uiTaskLeaveTime:OnOpen() end

-- 对外调用 当需要打开计时面板时调用
-- szName 计时的任务名 比如 "伏牛山\n距结束还剩："
-- 					显示 ：  	伏牛山
--								距结束还剩：X分X秒！
-- nSec 总时间，单位秒
function uiTaskLeaveTime:OpenWindow(szName, nSec)
  assert(szName and nSec)
  if self.nTimerId then
    return
  end
  if szName then
    uiTaskLeaveTime.TITLE = szName
    uiTaskLeaveTime.TITLE = uiTaskLeaveTime.TITLE
  end
  uiTaskLeaveTime.nLeaveTime = tonumber(nSec)
  UiManager:OpenWindow(Ui.UI_TASKLEAVETIME)
  self.nTimerId = Timer:Register(Env.GAME_FPS, self.Refresh, self)
end

-- 每秒钟刷新一次
function uiTaskLeaveTime:Refresh()
  if uiTaskLeaveTime.nLeaveTime <= 0 then
    self:CloseWindow()
    return
  end

  uiTaskLeaveTime.nLeaveTime = uiTaskLeaveTime.nLeaveTime - 1
  if uiTaskLeaveTime.nLeaveTime > 3600 then
    local nHour = math.floor(uiTaskLeaveTime.nLeaveTime / 3600)
    local nMin = math.floor((uiTaskLeaveTime.nLeaveTime % 3600) / 60)
    uiTaskLeaveTime.SHOW_TEXT = uiTaskLeaveTime.TITLE .. string.format("<color=White>%d小时%d分！<color>", nHour, nMin)
  else
    local nMin = math.floor(uiTaskLeaveTime.nLeaveTime / 60)
    local nSec = math.floor(uiTaskLeaveTime.nLeaveTime % 60)
    uiTaskLeaveTime.SHOW_TEXT = uiTaskLeaveTime.TITLE .. string.format("<color=White>%d分%d秒！<color>", nMin, nSec)
  end
  Txt_SetTxt(Ui.UI_TASKLEAVETIME, self.TEXTE_MSG, uiTaskLeaveTime.SHOW_TEXT)
end

function uiTaskLeaveTime:OnClose()
  if self.nTimerId then
    Timer:Close(self.nTimerId)
    self.nTimerId = nil
  end
end
-- 对外 关闭计时面板时调用
function uiTaskLeaveTime:CloseWindow()
  UiManager:CloseWindow(Ui.UI_TASKLEAVETIME)
end
