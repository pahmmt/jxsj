-----------------------------------------------------
--文件名		：	flashplayer.lua
--创建者		：	zhongjunqi@kingsoft.net
--创建时间		：	2012-8-28
--功能描述		：	flash播放器
--使用方式		：	潜规则，flash播放完成后调用PlayComplete，此时如果需要淡出，则在淡出完成后关闭窗口，否则立即关闭
------------------------------------------------------

local tbFlashPlayer = Ui:GetClass("flashplayer")

tbFlashPlayer.FLASH = "Flash"
tbFlashPlayer.IMGBG = "ImgBg"

local tbTimer = Ui.tbLogic.tbTimer

function tbFlashPlayer:Init()
  self.bFadeIn = 0
  self.nFadeInTime = 0
  self.bFadeOut = 0
  self.nFadeOutTime = 0
  self.bFadeOutIng = 0 -- 如果正在淡出，延迟退出，完成后关闭窗口
  self.bCanSkip = 1
end

function tbFlashPlayer:OnOpen(szFlashFile, szFlashRelateFile, bFadeIn, nFadeInTime, bFadeOut, nFadeOutTime)
  self:Init()
  -- 关闭互斥的界面：新建角色
  Flash_LoadMovie(self.UIGROUP, self.FLASH, szFlashFile or "", szFlashRelateFile or "")
  UiManager:SetExclusive(self.UIGROUP, 1) -- 设置为独占
  self.bFadeIn = bFadeIn or 0
  self.nFadeInTime = nFadeInTime or 0
  self.bFadeOut = bFadeOut or 0
  self.nFadeOutTime = nFadeOutTime or 0
  self.bFadeOutIng = 0
  self.szFadeoutBgImg = ""
  Wnd_SetVisible(self.UIGROUP, self.IMGBG, 0)
  Wnd_SetAlpha(self.UIGROUP, "Main", 255)
  if bFadeIn == 1 then
    self:_FadeIn(nFadeInTime)
  end
end

function tbFlashPlayer:OnClose()
  if self.nTimerId > 0 then
    tbTimer:Close(self.nTimerId)
    self.nTimerId = 0
  end
  Flash_ReleaseMovie(self.UIGROUP, self.FLASH)
  UiManager:SetExclusive(self.UIGROUP, 0) -- 设置为独占
end

-- 响应按钮点击事件
function tbFlashPlayer:OnButtonClick(szWndName, nParam) end

-- 淡入
function tbFlashPlayer:_FadeIn(nTime)
  Wnd_FadeIn(self.UIGROUP, "Main", 0, 255, nTime)
end

-- 淡出
function tbFlashPlayer:_FadeOut(nTime)
  Wnd_FadeIn(self.UIGROUP, "Main", 255, 0, nTime)
end

function tbFlashPlayer:OnFadeinFinished(szWnd)
  if self.bFadeOutIng == 1 then
    self.bFadeOutIng = 0
    self:PreCloseWindow()
  end
end

function tbFlashPlayer:OnFadeinStarted(szWnd) end

function tbFlashPlayer:PlayComplete()
  if self.bFadeOut == 1 then
    self:ShowFadeoutBgImg()
    self.bFadeOutIng = 1
    self:_FadeOut(self.nFadeOutTime)
  else
    self:PreCloseWindow()
  end
end

function tbFlashPlayer:OnFlashCall(szWnd, szFun, ...)
  if szWnd == self.FLASH then
    self[szFun](self, unpack(arg))
  end
end

function tbFlashPlayer:OnEscExclusiveWnd()
  if self.bCanSkip == 1 then
    self:PreCloseWindow()
  end
end

function tbFlashPlayer:SetCanSkip(bCanSkip)
  self.bCanSkip = bCanSkip
end

function tbFlashPlayer:PreCloseWindow()
  if self.tbCompleteCallback then
    for _, tbCallback in ipairs(self.tbCompleteCallback) do
      local _Self = tbCallback.fnSelf
      local _Fun = tbCallback.fnCallback
      _Fun(_Self, unpack(tbCallback.tbArg or {}))
    end
    self.tbCompleteCallback = nil
  end
  self.nTimerId = tbTimer:Register(1, self.OnTimer, self) -- 开启定时器，防止flash回调的时候关闭窗口，导致宕机
end

-- 设置淡出开始时候的图片，为了实现flash播放完成后，以某个图片为结束淡出的效果，淡出的时候才有效
function tbFlashPlayer:SetFadeoutBackGround(szImg)
  self.szFadeoutBgImg = szImg
end

function tbFlashPlayer:ShowFadeoutBgImg()
  if not self.szFadeoutBgImg or self.szFadeoutBgImg == "" then
    return
  end
  Wnd_SetVisible(self.UIGROUP, self.IMGBG, 1)
  Img_SetImage(self.UIGROUP, self.IMGBG, 1, self.szFadeoutBgImg)
  local nWidth, nHeight = Wnd_GetSize(self.UIGROUP, self.IMGBG)
  local nParentW, nParentH = Wnd_GetSize(self.UIGROUP, self.FLASH)
  local nX = (nParentW - nWidth) / 2
  local nY = (nParentH - nHeight) / 2
  Wnd_SetPos(self.UIGROUP, self.IMGBG, nX, nY)
end

-- flash播放完成回调,tbCallback = {fnCallback=fn,fnSelf=tbSelf,tbArg={arg1,arg2,...}}
-- 注意每次完成后都会清空回调列表
function tbFlashPlayer:RegisterCompleteCallback(tbCallback)
  self.tbCompleteCallback = self.tbCompleteCallback or {}
  self.tbCompleteCallback[#self.tbCompleteCallback + 1] = tbCallback
end

function tbFlashPlayer:OnTimer()
  if self.nTimerId > 0 then
    tbTimer:Close(self.nTimerId)
    self.nTimerId = 0
  end
  UiManager:CloseWindow(self.UIGROUP)
end
