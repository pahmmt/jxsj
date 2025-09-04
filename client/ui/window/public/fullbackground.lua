-----------------------------------------------------
--文件名		：	fullbackground.lua
--创建者		：	zhongjunqi@kingsoft.net
--创建时间		：	2012-9-26
--功能描述		：	全屏幕ui效果
--使用方式		：	设置图片，淡入处理，1 淡入整体窗口 2 淡入图片 3 显示 4 淡出图片 5 淡出整体窗口，如果没有设置淡入淡出效果，则略过
------------------------------------------------------

local tbUiWnd = Ui:GetClass("fullbackground")

tbUiWnd.IMGBG = "ImgBg"
tbUiWnd.SHADOWWND = "ShadowWnd"

local tbTimer = Ui.tbLogic.tbTimer

function tbUiWnd:Init()
  self.tbModeCfg = {
    bMainFadeIn = 0,
    nMainFadeInTime = 2000,
    bMainFadeOut = 1,
    nMainFadeOutTime = 2000,
    nShowTime = 3000,
    bImgFadeIn = 1,
    nImgFadeInTime = 2000,
    bImgFadeOut = 1,
    nImgFadeOutTime = 2000,
  }
  self.nTimerId = 0
  self.bCanSkip = 1
  self.nStep = 0
end

function tbUiWnd:OnOpen(szImg)
  self:Init()
  -- 关闭互斥的界面：新建角色
  UiManager:SetExclusive(self.UIGROUP, 1) -- 设置为独占

  self.szFadeoutBgImg = szImg or ""
  self:ShowFadeoutBgImg()
  if self.tbModeCfg.bImgFadeIn == 1 then
    Wnd_SetVisible(self.UIGROUP, self.IMGBG, 0)
  end
  Wnd_SetAlpha(self.UIGROUP, self.IMGBG, 255)
  Wnd_SetAlpha(self.UIGROUP, self.SHADOWWND, 255)

  self:ChangeStep()
end

function tbUiWnd:OnClose()
  if self.nTimerId > 0 then
    tbTimer:Close(self.nTimerId)
    self.nTimerId = 0
  end
  UiManager:SetExclusive(self.UIGROUP, 0) -- 设置为独占
end

-- 响应按钮点击事件
function tbUiWnd:OnButtonClick(szWndName, nParam) end

function tbUiWnd:OnFadeinFinished(szWnd)
  self:ChangeStep()
end

function tbUiWnd:OnFadeinStarted(szWnd) end

function tbUiWnd:OnEscExclusiveWnd()
  if self.bCanSkip == 1 then
    self:PreCloseWindow()
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function tbUiWnd:SetCanSkip(bCanSkip)
  self.bCanSkip = bCanSkip
end

function tbUiWnd:OnTimer()
  self:ChangeStep()
  return 0
end

-- 推进ui显示进度
function tbUiWnd:ChangeStep()
  if self.nStep == 0 then -- 主窗口淡入完成
    if self.tbModeCfg.bMainFadeIn == 1 then
      Wnd_FadeIn(self.UIGROUP, self.SHADOWWND, 0, 255, self.tbModeCfg.nMainFadeInTime)
      self.nStep = 1
      return
    elseif self.tbModeCfg.bImgFadeIn == 1 then -- 需要淡入图片
      Wnd_SetVisible(self.UIGROUP, self.IMGBG, 1)
      Wnd_FadeIn(self.UIGROUP, self.IMGBG, 0, 255, self.tbModeCfg.nImgFadeInTime)
      self.nStep = 2
      return
    elseif self.tbModeCfg.nShowTime > 0 then -- 需要显示图片的时间
      self.nTimerId = tbTimer:Register(math.floor(self.tbModeCfg.nShowTime * Env.GAME_FPS / 1000), self.OnTimer, self)
      self.nStep = 3
      return
    elseif self.tbModeCfg.bImgFadeOut == 1 then -- 需要淡出图片
      Wnd_FadeIn(self.UIGROUP, self.IMGBG, 255, 0, self.tbModeCfg.nImgFadeOutTime)
      self.nStep = 4
      return
    elseif self.tbModeCfg.bMainFadeOut == 1 then -- 需要淡出整体窗口
      Wnd_FadeIn(self.UIGROUP, self.SHADOWWND, 255, 0, self.tbModeCfg.nMainFadeOutTime)
      self.nStep = 5
      return
    end
  elseif self.nStep == 1 then -- 主窗口淡入完成
    if self.tbModeCfg.bImgFadeIn == 1 then -- 需要淡入图片
      Wnd_SetVisible(self.UIGROUP, self.IMGBG, 1)
      Wnd_FadeIn(self.UIGROUP, self.IMGBG, 0, 255, self.tbModeCfg.nImgFadeInTime)
      self.nStep = 2
      return
    elseif self.tbModeCfg.nShowTime > 0 then -- 需要显示图片的时间
      self.nTimerId = tbTimer:Register(math.floor(self.tbModeCfg.nShowTime * Env.GAME_FPS / 1000), self.OnTimer, self)
      self.nStep = 3
      return
    elseif self.tbModeCfg.bImgFadeOut == 1 then -- 需要淡出图片
      Wnd_FadeIn(self.UIGROUP, self.IMGBG, 255, 0, self.tbModeCfg.nImgFadeOutTime)
      self.nStep = 4
      return
    elseif self.tbModeCfg.bMainFadeOut == 1 then -- 需要淡出整体窗口
      Wnd_FadeIn(self.UIGROUP, self.SHADOWWND, 255, 0, self.tbModeCfg.nMainFadeOutTime)
      self.nStep = 5
      return
    end
  elseif self.nStep == 2 then
    if self.tbModeCfg.nShowTime > 0 then -- 需要显示图片的时间
      self.nTimerId = tbTimer:Register(math.floor(self.tbModeCfg.nShowTime * Env.GAME_FPS / 1000), self.OnTimer, self)
      self.nStep = 3
      return
    elseif self.tbModeCfg.bImgFadeOut == 1 then -- 需要淡出图片
      Wnd_FadeIn(self.UIGROUP, self.IMGBG, 255, 0, self.tbModeCfg.nImgFadeOutTime)
      self.nStep = 4
      return
    elseif self.tbModeCfg.bMainFadeOut == 1 then -- 需要淡出整体窗口
      Wnd_FadeIn(self.UIGROUP, self.SHADOWWND, 255, 0, self.tbModeCfg.nMainFadeOutTime)
      self.nStep = 5
      return
    end
  elseif self.nStep == 3 then
    if self.tbModeCfg.bImgFadeOut == 1 then -- 需要淡出图片
      Wnd_FadeIn(self.UIGROUP, self.IMGBG, 255, 0, self.tbModeCfg.nImgFadeOutTime)
      self.nStep = 4
      return
    elseif self.tbModeCfg.bMainFadeOut == 1 then -- 需要淡出整体窗口
      Wnd_FadeIn(self.UIGROUP, self.SHADOWWND, 255, 0, self.tbModeCfg.nMainFadeOutTime)
      self.nStep = 5
      return
    end
  elseif self.nStep == 4 then
    if self.tbModeCfg.bMainFadeOut == 1 then -- 需要淡出整体窗口
      Wnd_FadeIn(self.UIGROUP, self.SHADOWWND, 255, 0, self.tbModeCfg.nMainFadeOutTime)
      self.nStep = 5
      return
    end
  end
  -- 关闭了
  self:PreCloseWindow()
  UiManager:CloseWindow(self.UIGROUP)
end

function tbUiWnd:ShowFadeoutBgImg()
  if not self.szFadeoutBgImg or self.szFadeoutBgImg == "" then
    return
  end
  Wnd_SetVisible(self.UIGROUP, self.IMGBG, 1)
  Img_SetImage(self.UIGROUP, self.IMGBG, 1, self.szFadeoutBgImg)
  local nWidth, nHeight = Wnd_GetSize(self.UIGROUP, self.IMGBG)
  local nParentW, nParentH = Wnd_GetSize(self.UIGROUP, self.SHADOWWND)
  local nX = (nParentW - nWidth) / 2
  local nY = (nParentH - nHeight) / 2
  Wnd_SetPos(self.UIGROUP, self.IMGBG, nX, nY)
end

function tbUiWnd:PreCloseWindow()
  if self.tbCompleteCallback then
    for _, tbCallback in ipairs(self.tbCompleteCallback) do
      local _Self = tbCallback.fnSelf
      local _Fun = tbCallback.fnCallback
      _Fun(_Self, unpack(tbCallback.tbArg or {}))
    end
    self.tbCompleteCallback = nil
  end
end

-- 窗口流程完成回调,tbCallback = {fnCallback=fn,fnSelf=tbSelf,tbArg={arg1,arg2,...}}
-- 注意每次完成后都会清空回调列表
function tbUiWnd:RegisterCompleteCallback(tbCallback)
  self.tbCompleteCallback = self.tbCompleteCallback or {}
  self.tbCompleteCallback[#self.tbCompleteCallback + 1] = tbCallback
end
