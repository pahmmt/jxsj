--===================================================
-- 文件名　：serieskill.lua
-- 创建者　：furuilei
-- 创建时间：2011-05-12 15:15:15
-- 功能描述：YY连斩特效
--===================================================

local uiSeriesKill = Ui:GetClass("serieskill")

uiSeriesKill.tbTimer = Ui.tbLogic.tbTimer
uiSeriesKill.MIN_SHOW_NUM = 2 -- 最少达到这个数值才开始显示连战计数
uiSeriesKill.tbAnimateCatch = {} -- 记录在客户端的动画缓存
uiSeriesKill.tbCurSKAnimateInfo = {}

uiSeriesKill.IMG_SKTIPS = "Img_SKTips"
uiSeriesKill.IMG_SKANIMATE = "Img_SKAnimate"
uiSeriesKill.TBIMG_NUM = {
  [1] = "Img_SKNum1",
  [2] = "Img_SKNum2",
  [3] = "Img_SKNum3",
  [4] = "Img_SKNum4",
}

uiSeriesKill.OPT_STAYFRAME = 1
uiSeriesKill.OPT_PLAYANIMATE = 2
uiSeriesKill.OPT_DISAPPEAR = 3

uiSeriesKill.SPRSKTIPS = "\\image\\effect\\info\\sk\\sk.spr"
uiSeriesKill.tbAnimateOpts = {
  { uiSeriesKill.OPT_PLAYANIMATE, 0, 19 },
  { uiSeriesKill.OPT_STAYFRAME, 19, 5 * 18 },
  { uiSeriesKill.OPT_PLAYANIMATE, 20, 40 },
  { uiSeriesKill.OPT_DISAPPEAR, 0, 0 },
}

uiSeriesKill.tbSKAnimateInfo = {
  { nMin = 5, nMax = 9, szAnimate = "\\image\\effect\\info\\sk\\animate_10.spr" },
  { nMin = 10, nMax = 19, szAnimate = "\\image\\effect\\info\\sk\\animate_15.spr" },
  { nMin = 20, nMax = 29, szAnimate = "\\image\\effect\\info\\sk\\animate_20.spr" },
  { nMin = 30, nMax = 49, szAnimate = "\\image\\effect\\info\\sk\\animate_30.spr" },
  { nMin = 50, nMax = 79, szAnimate = "\\image\\effect\\info\\sk\\animate_50.spr" },
  { nMin = 80, nMax = 99, szAnimate = "\\image\\effect\\info\\sk\\animate_75.spr" },
  { nMin = 100, nMax = 1000, szAnimate = "\\image\\effect\\info\\sk\\animate_100.spr" },
}

uiSeriesKill.tbNumAnimates = {
  [0] = "\\image\\effect\\info\\sk\\0.spr",
  [1] = "\\image\\effect\\info\\sk\\1.spr",
  [2] = "\\image\\effect\\info\\sk\\2.spr",
  [3] = "\\image\\effect\\info\\sk\\3.spr",
  [4] = "\\image\\effect\\info\\sk\\4.spr",
  [5] = "\\image\\effect\\info\\sk\\5.spr",
  [6] = "\\image\\effect\\info\\sk\\6.spr",
  [7] = "\\image\\effect\\info\\sk\\7.spr",
  [8] = "\\image\\effect\\info\\sk\\8.spr",
  [9] = "\\image\\effect\\info\\sk\\9.spr",
}

uiSeriesKill.DEF_SHOWTIME = 8

function uiSeriesKill:ClearAllInfo(nFlag)
  self:Clear_SKTips()
  self:Clear_SKAnimate()
  if nFlag ~= 1 and self.nShowTimerId and self.nShowTimerId > 0 then
    self.tbTimer:Close(self.nShowTimerId)
    self.nShowTimerId = 0
  end
  return 0
end

function uiSeriesKill:Clear_SKTips()
  Img_SetImage(self.UIGROUP, self.IMG_SKTIPS, 1, "")
  for i = 1, 4 do
    Img_SetImage(self.UIGROUP, self.TBIMG_NUM[i], 1, "")
  end
end

function uiSeriesKill:Close()
  self:ClearAllInfo()
end

function uiSeriesKill:Clear_SKAnimate()
  if self.Opt_StayFrameTimerId and self.Opt_StayFrameTimerId > 0 then
    self.tbTimer:Close(self.Opt_StayFrameTimerId)
    self.Opt_StayFrameTimerId = 0
  end
  Img_SetImage(self.UIGROUP, self.IMG_SKANIMATE, 1, "")
end

function uiSeriesKill:OnOpen(nSeriesKillNum, nTimeSec)
  self:ClearAllInfo()
  if not nSeriesKillNum or nSeriesKillNum < self.MIN_SHOW_NUM then
    return
  end
  nTimeSec = nTimeSec or self.DEF_SHOWTIME
  self.tbAnimateCatch = {}
  self:UpdateSKTips(nSeriesKillNum)
  self:UpdateSKAnimate(nSeriesKillNum)
  if nTimeSec > 0 then
    self.nShowTimerId = self.tbTimer:Register(nTimeSec * Env.GAME_FPS, self.ClearAllInfo, self, 1)
  end
end

function uiSeriesKill:SplitNum(nSourceNum)
  local tbNums = {}
  local bInsert = 0
  for i = 10, 0, -1 do
    local nNum = math.floor(nSourceNum / (10 ^ i))
    nSourceNum = nSourceNum % (10 ^ i)
    if bInsert == 0 and nNum ~= 0 then
      bInsert = 1
    end
    if bInsert == 1 then
      table.insert(tbNums, nNum)
    end
  end
  return tbNums
end

function uiSeriesKill:GetSKNumAnimates(nSeriesKillNum)
  local tbAnimates = {}
  local tbNums = self:SplitNum(nSeriesKillNum)
  for nIndex, nNum in ipairs(tbNums) do
    tbAnimates[nIndex] = self.tbNumAnimates[nNum]
  end
  return tbAnimates
end

function uiSeriesKill:UpdateSKTips(nSeriesKillNum)
  Img_SetImage(self.UIGROUP, self.IMG_SKTIPS, 1, self.SPRSKTIPS)
  Img_PlayAnimation(self.UIGROUP, self.IMG_SKTIPS, 1)

  local tbAnimates = self:GetSKNumAnimates(nSeriesKillNum)
  for i = 1, 4 do
    local szAnimate = tbAnimates[i]
    if szAnimate then
      Img_SetImage(self.UIGROUP, self.TBIMG_NUM[i], 1, szAnimate)
      -- self.tbAnimateCatch[self.TBIMG_NUM[i]] = {szAnimate, 0};
      Img_PlayAnimation(self.UIGROUP, self.TBIMG_NUM[i], 1)
    end
  end
end

function uiSeriesKill:UpdateSKAnimate(nSeriesKillNum)
  local szAnimate = self:GetAnimatePath(nSeriesKillNum)
  if not szAnimate then
    self:Clear_SKAnimate()
    return
  end

  --	Img_SetImage(self.UIGROUP, self.IMG_SKANIMATE, 1, szAnimate);
  --	Img_PlayAnimation(self.UIGROUP, self.IMG_SKANIMATE, 0);

  self.tbAnimateCatch[self.IMG_SKANIMATE] = { szAnimate, 1 }
  self:Opt_Animate(self.IMG_SKANIMATE)
end

function uiSeriesKill:GetAnimatePath(nSeriesKillNum)
  for _, tbInfo in pairs(self.tbSKAnimateInfo) do
    local nMin = tbInfo.nMin
    local nMax = tbInfo.nMax
    if nSeriesKillNum >= nMin and nSeriesKillNum <= nMax then
      return tbInfo.szAnimate
    end
  end
  return nil
end

function uiSeriesKill:OnAnimationOver(szWnd)
  if not szWnd then
    return
  end

  self:Opt_Animate(szWnd)
end

function uiSeriesKill:Opt_Animate(szWnd)
  if not szWnd then
    return 0
  end
  if not self.tbAnimateCatch[szWnd] then
    return 0
  end
  local szAnimate = self.tbAnimateCatch[szWnd][1]
  local nStep = self.tbAnimateCatch[szWnd][2]
  if not szAnimate or not nStep then
    return 0
  end
  local tbInfo = self.tbAnimateOpts[nStep]
  if not tbInfo then
    return 0
  end

  if self.tbAnimateOpts[nStep + 1] then
    self.tbAnimateCatch[self.IMG_SKANIMATE] = { szAnimate, nStep + 1 }
  else
    self.tbAnimateCatch[self.IMG_SKANIMATE] = nil
  end

  local nOpt = tbInfo[1]
  if nOpt == self.OPT_STAYFRAME then
    self:Opt_StayFrame(szWnd, nStep)
  elseif nOpt == self.OPT_PLAYANIMATE then
    self:Opt_PlayAnimate(szWnd, nStep)
  elseif nOpt == OPT_DISAPPEAR then
    self:Opt_Disappear(szWnd)
  end
end

function uiSeriesKill:Opt_StayFrame(szWnd, nStep, bStayEnough)
  if bStayEnough and bStayEnough == 1 then
    self:Opt_Animate(szWnd)
    return 0
  end
  local szAnimate = self.tbAnimateCatch[szWnd][1]
  local nStayFrame = self.tbAnimateOpts[nStep][2]
  local nStayTime = self.tbAnimateOpts[nStep][3]

  Img_SetImage(self.UIGROUP, szWnd, 1, szAnimate)
  Img_SetFrame(self.UIGROUP, szWnd, nStayFrame)

  self.Opt_StayFrameTimerId = self.tbTimer:Register(nStayTime, self.Opt_StayFrame, self, szWnd, nStep, 1)
end

function uiSeriesKill:Opt_PlayAnimate(szWnd, nStep)
  local szAnimate = self.tbAnimateCatch[szWnd][1]
  local nBeginFrame = self.tbAnimateOpts[nStep][2]
  local nEndFrame = self.tbAnimateOpts[nStep][3]

  Img_SetImage(self.UIGROUP, szWnd, 1, szAnimate)
  Img_PlayAnimation(self.UIGROUP, self.IMG_SKANIMATE, 0, 0, nBeginFrame, nEndFrame)
end

function uiSeriesKill:Opt_Disappear(szWnd, nStep)
  Img_SetImage(self.UIGROUP, szWnd, 1, "")
end
