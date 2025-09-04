-- ====================== 文件信息 ======================

-- 任务过程提示界面
-- Edited by peres
-- 2007/11/13 PM 03:57

-- 如果有过幸福。
-- 幸福只是瞬间的片断，一小段一小段。

-- ======================================================

local uiTaskTips = Ui:GetClass("tasktips")
local tbTimer = Ui.tbLogic.tbTimer

uiTaskTips.IMG_HEAD = "ImgHead"
uiTaskTips.TXT_TIPS = "TxtTips"
uiTaskTips.PROGRESS_TIME = 400

function uiTaskTips:Init()
  self.nCloseTimerId = 0
  self.nLoadCompleted = 0
  self.szTaskTips = ""
end

function uiTaskTips:OnClose()
  self:CloseTimer()
end

function uiTaskTips:Opening()
  Prg_SetTime(self.UIGROUP, self.IMG_HEAD, self.PROGRESS_TIME)
end

function uiTaskTips:Ending()
  Prg_SetTime(self.UIGROUP, self.IMG_HEAD, self.PROGRESS_TIME, 1)
end

function uiTaskTips:Begin(szTips, nTime)
  self.szTaskTips = szTips
  if UiManager:WindowVisible(self.UIGROUP) == 0 then
    UiManager:OpenWindow(self.UIGROUP)
    self:Opening()
    if nTime and nTime > 0 then
      self.nLastTime = nTime
    end
  else
    self.nLoadCompleted = 0
    Prg_SetTime(self.UIGROUP, self.IMG_HEAD, 0)
    self:OnProgressFull(self.IMG_HEAD, nTime)
  end
end

function uiTaskTips:OnProgressFull(szImageHead, nTime)
  if self.nLastTime then
    nTime = self.nLastTime
    self.nLastTime = nil
  end
  if not nTime or nTime == 0 then
    nTime = 9
  end

  if self.nLoadCompleted == 0 then
    Txt_SetTxt(self.UIGROUP, self.TXT_TIPS, self.szTaskTips)
    self.nLoadCompleted = 1
    -- 开始关闭倒计时
    if self.nCloseTimerId == 0 then
      self.nCloseTimerId = tbTimer:Register(18 * nTime, self.CloseTimer, self)
    end
  else
    self.nLoadCompleted = 0
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiTaskTips:CloseTimer()
  if self.nCloseTimerId and (self.nCloseTimerId ~= 0) then
    tbTimer:Close(self.nCloseTimerId)
    self.nCloseTimerId = 0
  end
  Txt_SetTxt(self.UIGROUP, self.TXT_TIPS, "")
  self:Ending()
end
