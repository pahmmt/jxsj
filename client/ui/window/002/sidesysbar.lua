-----------------------------------------------------
--文件名		：	sidebar.lua
--创建者		：	huangxiaoming.net
--创建时间	    ：	2011-09-23
--功能描述	    ：	功能工具条脚本。
------------------------------------------------------
local tbTimer = Ui.tbLogic.tbTimer

local uiSideSysBar = Ui:GetClass("sidesysbar")
uiSideSysBar.BTN_MENOLOGY = "BtnMenology"
uiSideSysBar.BTN_HELP = "BtnHelp"
uiSideSysBar.BTN_LOCK = "BtnLock"
uiSideSysBar.BTN_SIDEBAREXSWITCH = "BtnSidebarExSwitch"
uiSideSysBar.TXT_TIME = "TxtTime"

local szSideBarSprPath = "\\image\\ui\\002a\\sidebar\\"
local szLockSprPath = "\\image\\ui\\002a\\sidebar\\"
uiSideSysBar.TIME_NOTIFY = 18
local POPTIP_DELAYTIME = Env.GAME_FPS * 30 -- 泡泡延时显示时间

function uiSideSysBar:OnOpen()
  self:UpdateSysTime()
  if not self.nTimerRegId then
    self.nTimerRegId = tbTimer:Register(self.TIME_NOTIFY, self.UpdateSysTime, self)
  end
  self:UpdateSideBarExState(UiManager:WindowVisible(Ui.UI_SIDEBAR))
  self:UpdateLock()
  Timer:Register(Env.GAME_FPS, Ui(Ui.UI_LOCKACCOUNT).StartOpenTimer4Tip, Ui(Ui.UI_LOCKACCOUNT))
end

function uiSideSysBar:OnClose()
  if self.nTimerRegId then
    Timer:Close(self.nTimerRegId)
    self.nTimerRegId = nil
  end
  Ui(Ui.UI_LOCKACCOUNT):CloseTimerTip()
end

-- 更新系统时间，每1秒更新一次
function uiSideSysBar:UpdateSysTime()
  local nNowDate = GetTime()
  local nWeekDay = tonumber(os.date("%w", nNowDate))
  local szWeekDay = "日"
  if nWeekDay ~= 0 then
    szWeekDay = Lib:Transfer4LenDigit2CnNum(nWeekDay)
  end
  local szTime = os.date("%H:%M:%S", nNowDate)
  local szDate = os.date("%Y年%m月%d日 星期" .. szWeekDay, nNowDate)
  Txt_SetTxt(self.UIGROUP, self.TXT_TIME, szTime)
  Wnd_SetTip(self.UIGROUP, self.TXT_TIME, szDate)
end

function uiSideSysBar:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_MENOLOGY then
    UiManager:SwitchWindow(Ui.UI_NEWCALENDARVIEW)
    Img_PlayAnimation("UI_SIDESYSBAR", self.BTN_MENOLOGY, 0)
  elseif szWnd == self.BTN_HELP then
    UiManager:SwitchWindow(Ui.UI_HELPSPRITE)
  elseif szWnd == self.BTN_LOCK then
    UiManager:SwitchWindow(Ui.UI_LOCKACCOUNT)
  elseif szWnd == self.BTN_SIDEBAREXSWITCH then
    UiManager:SwitchWindow(Ui.UI_SIDEBAR)
    Btn_Check(self.UIGROUP, szWnd, 0)
  end
end

function uiSideSysBar:UpdateSideBarExState(nFlag)
  if nFlag == 1 then
    Img_SetImage(self.UIGROUP, self.BTN_SIDEBAREXSWITCH, 1, szSideBarSprPath .. "btn_sidebarex_close.spr")
  else
    Img_SetImage(self.UIGROUP, self.BTN_SIDEBAREXSWITCH, 1, szSideBarSprPath .. "btn_sidebarex_open.spr")
  end
end

function uiSideSysBar:UpdateLock()
  if me.IsAccountLock() == 1 then
    Img_SetImage(self.UIGROUP, self.BTN_LOCK, 1, szLockSprPath .. "btn_lock.spr")
  else
    Img_SetImage(self.UIGROUP, self.BTN_LOCK, 1, szLockSprPath .. "btn_unlock.spr")
  end
  if me.IsAccountLockOpen() ~= 1 and not self.bAccountNotified then
    self.bAccountNotified = 1
    self.nTimerId = tbTimer:Register(POPTIP_DELAYTIME, self.OnTimer, self)
  elseif me.IsAccountLock() == 1 and not self.bAccountNotified then
    self.bAccountNotified = 1
    UiNotify:OnNotify(UiNotify.emCOREEVENT_SET_POPTIP, 44)
  end
end

function uiSideSysBar:OnTimer()
  UiNotify:OnNotify(UiNotify.emCOREEVENT_SET_POPTIP, 42)
  tbTimer:Close(self.nTimerId)
end

function uiSideSysBar:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_LOCK, self.UpdateLock },
  }
  return tbRegEvent
end
