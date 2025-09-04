-------------------------------------------------------
-- 文件名　：baibaoxiang.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2009-04-07 23:01:02
-- 文件描述：
-------------------------------------------------------

local uiBaibaoxiang = Ui:GetClass("baibaoxiang")
local tbTimer = Ui.tbLogic.tbTimer

-- const
uiBaibaoxiang.GRID_COUNT = 22

-- button
uiBaibaoxiang.BTN_START = "BtnStart"
uiBaibaoxiang.BTN_CLOSE = "BtnClose"
uiBaibaoxiang.BTN_LINGJIANG = "BtnLingjiang"
uiBaibaoxiang.BTN_LINGBI = "BtnLingbi"

-- touzhu
uiBaibaoxiang.BTN_TOUZHU = {
  [1] = { "BtnTouzhu1", 2 },
  [2] = { "BtnTouzhu2", 10 },
  [3] = { "BtnTouzhu3", 50 },
}

-- text
uiBaibaoxiang.TXT_CAICHI = "TxtCaichi"
uiBaibaoxiang.TXT_YINBI = "TxtYinbi"
uiBaibaoxiang.TXT_YINBINUM = "TxtYinbiNum"
uiBaibaoxiang.TXT_MIAOSHU = "TxtMiaoshu"
uiBaibaoxiang.TXT_TOUZHU = "TxtTouzhu"

-- img
uiBaibaoxiang.IMG_HIGHLIGHT = "ImgHighlight"
uiBaibaoxiang.IMG_FLASH = "ImgFlash"

-- 22 grid
uiBaibaoxiang.IMG_GRID = {
  -- {name, type(1-5), level(1-3), effect}
  [1] = { "ImgGrid1", 2, 1, "ImgEffect1" },
  [2] = { "ImgGrid2", 3, 3, "ImgEffect2" },
  [3] = { "ImgGrid3", 3, 1, "ImgEffect3" },
  [4] = { "ImgGrid4", 5, 1, "ImgEffect4" },
  [5] = { "ImgGrid5", 2, 2, "ImgEffect5" },
  [6] = { "ImgGrid6", 3, 1, "ImgEffect6" },
  [7] = { "ImgGrid7", 1, 3, "ImgEffect7" },
  [8] = { "ImgGrid8", 1, 1, "ImgEffect8" },
  [9] = { "ImgGrid9", 4, 1, "ImgEffect9" },
  [10] = { "ImgGrid10", 2, 1, "ImgEffect10" },
  [11] = { "ImgGrid11", 3, 2, "ImgEffect11" },
  [12] = { "ImgGrid12", 1, 1, "ImgEffect12" },
  [13] = { "ImgGrid13", 4, 3, "ImgEffect13" },
  [14] = { "ImgGrid14", 4, 1, "ImgEffect14" },
  [15] = { "ImgGrid15", 5, 1, "ImgEffect15" },
  [16] = { "ImgGrid16", 1, 2, "ImgEffect16" },
  [17] = { "ImgGrid17", 4, 1, "ImgEffect17" },
  [18] = { "ImgGrid18", 2, 3, "ImgEffect18" },
  [19] = { "ImgGrid19", 2, 1, "ImgEffect19" },
  [20] = { "ImgGrid20", 3, 1, "ImgEffect20" },
  [21] = { "ImgGrid21", 1, 1, "ImgEffect21" },
  [22] = { "ImgGrid22", 4, 2, "ImgEffect22" },
}

-- 6 line
uiBaibaoxiang.IMG_AWARD_LEVEL = {
  [1] = { "ImgLevel1", "TxtLevel1" },
  [2] = { "ImgLevel2", "TxtLevel2" },
  [3] = { "ImgLevel3", "TxtLevel3" },
  [4] = { "ImgLevel4", "TxtLevel4" },
  [5] = { "ImgLevel5", "TxtLevel5" },
  [6] = { "ImgLevel6", "TxtLevel6" },
}

-- resource
uiBaibaoxiang.SPR_EFFECT = "\\image\\ui\\001a\\baibaoxiang\\img_effect.spr"
uiBaibaoxiang.SPR_RUN = "\\image\\ui\\001a\\baibaoxiang\\img_run.spr"
uiBaibaoxiang.SPR_START = "\\image\\ui\\001a\\baibaoxiang\\btn_start" .. UiManager.IVER_szVnSpr
uiBaibaoxiang.SPR_CONTINUE = "\\image\\ui\\001a\\baibaoxiang\\btn_continue" .. UiManager.IVER_szVnSpr
uiBaibaoxiang.SPR_LEVELSTAR = {
  [1] = "\\image\\ui\\001a\\baibaoxiang\\img_star_1.spr",
  [2] = "\\image\\ui\\001a\\baibaoxiang\\img_star_2.spr",
  [3] = "\\image\\ui\\001a\\baibaoxiang\\img_star_3.spr",
  [4] = "\\image\\ui\\001a\\baibaoxiang\\img_star_4.spr",
  [5] = "\\image\\ui\\001a\\baibaoxiang\\img_star_5.spr",
  [6] = "\\image\\ui\\001a\\baibaoxiang\\img_star_6.spr",
}

-- award value
uiBaibaoxiang.tbAward = {
  [1] = { "玄晶", { 4, 5, 6, 7, 8, 9 } },
  [2] = { "精活", { 300, 900, 3000, 10500, 36000, 120000 } },
  [3] = { "银两", { 10000, 30000, 100000, 350000, 1200000, 4000000 } },
  [4] = { "绑金", { 60, 180, 600, 2100, 7200, 24000 } },
  [5] = { "宝箱", { 1 } },
  [6] = { "贝壳", { 1, 3, 10, 35, 120, 400 } },
}

-------------------------------------------------------
-- 华丽的分割线
-------------------------------------------------------

-- init
function uiBaibaoxiang:Init()
  self.nTimeMoveID = 0
  self.nTimerDelayID = 0
  self.nTimerResetID = 0
  self.nTimerUpdateID = 0

  self.nTimerStep = 1
  self.nSlowStep = 1
  self.nMaxSlowStep = 1

  self.tbSlowTime = {}

  self.nLevel = 0
  self.nTimes = 0
  self.nType = 0
  self.nTouzhu = 0
  self.nResult = 0
  self.nOverflow = 0
  self.nContinue = 0

  self.nCurrGrid = 1
  self.nEndGrid = 1
  self.nRandGrid = 0

  self.nLastType = 0
  self.nLastLevel = 0
  self.nLastTimes = 0

  self.bOpen = 0 -- window open
  self.nFlashTimes = 0 -- flash count
end

-- check need recover state
function uiBaibaoxiang:CheckRecover()
  local nTimes = me.GetTask(2086, 2)

  if nTimes > 0 then
    return 1
  end

  return 0
end

function uiBaibaoxiang:Recover()
  -- get task variable
  self.nLevel = me.GetTask(2086, 1)
  self.nTimes = me.GetTask(2086, 2)
  self.nType = me.GetTask(2086, 3)
  self.nTouzhu = me.GetTask(2086, 4)
  self.nResult = me.GetTask(2086, 5)
  self.nOverflow = me.GetTask(2086, 6)
  self.nContinue = me.GetTask(2086, 7)

  -- find last result
  self.nLastType, self.nLastLevel, self.nRandGrid = Baibaoxiang:GetRoundResult(me, self.nTimes)
  self.nEndGrid = self:FindGridByResult(self.nLastType, self.nLastLevel, self.nRandGrid)

  self.nCurrGrid = self.nEndGrid
  self.nLastTimes = self.nTimes

  -- remember touzhu
  if self.nTouzhu > 0 then
    self:CheckTouzhu(self.nTouzhu)
    self:State_Touzhu()
  end

  -- do state
  self:State_GetResult(self.nTimes)
end

-- on open
function uiBaibaoxiang:OnOpen()
  -- set window open flag
  self.bOpen = 1

  -- switch state
  if self:CheckRecover() == 1 then
    self:Recover()
  else
    self:State_Begin()
  end

  -- register time for upate caichi
  self.nTimerUpdateID = tbTimer:Register(10, self.OnTimerUpdate, self)
end

-- on close
function uiBaibaoxiang:OnClose()
  if self.nTimeMoveID > 0 then
    tbTimer:Close(self.nTimeMoveID)
    self.nTimeMoveID = 0
  end

  if self.nTimerDelayID > 0 then
    tbTimer:Close(self.nTimerDelayID)
    self.nTimerDelayID = 0
  end

  if self.nTimerResetID > 0 then
    tbTimer:Close(self.nTimerResetID)
    self.nTimerResetID = 0
  end

  if self.nTimerUpdateID > 0 then
    tbTimer:Close(self.nTimerUpdateID)
    self.nTimerUpdateID = 0
  end
end

-- update caichi
function uiBaibaoxiang:OnTimerUpdate()
  local nCoin = me.GetItemCountInBags(18, 1, 325, 1)

  Txt_SetTxt(self.UIGROUP, self.TXT_YINBINUM, nCoin)

  local nCaichi = KGblTask.SCGetDbTaskInt(DBTASK_BAIBAOXIANG_CAICHI) / 100
  local szTxt = string.format("当前服务器所积累彩池：%d贝壳！", tonumber(nCaichi))

  Txt_SetTxt(self.UIGROUP, self.TXT_CAICHI, szTxt)

  return 10
end

-- disable all button
function uiBaibaoxiang:DisableAllButton()
  local i

  -- touzhu
  for i = 1, 3 do
    Wnd_SetEnable(self.UIGROUP, self.BTN_TOUZHU[i][1], 0)
  end

  -- start/continue, lingjiang, lingbi
  Wnd_SetEnable(self.UIGROUP, self.BTN_START, 0)
  Wnd_SetEnable(self.UIGROUP, self.BTN_LINGJIANG, 0)
  Wnd_SetEnable(self.UIGROUP, self.BTN_LINGBI, 0)
end

-- invisible all effect
function uiBaibaoxiang:InvisibleEffect()
  local i

  for i = 1, self.GRID_COUNT do
    Wnd_SetVisible(self.UIGROUP, self.IMG_GRID[i][4], 0)
    Img_PlayAnimation(self.UIGROUP, self.IMG_GRID[self.nEndGrid][4], 1)
  end
end

-- trigger click event
function uiBaibaoxiang:OnButtonClick(szWnd, nParam)
  -- close
  if self.BTN_CLOSE == szWnd then
    UiManager:CloseWindow(self.UIGROUP)

  -- start/continue
  elseif self.BTN_START == szWnd then
    if self.nTouzhu > 0 then
      me.CallServerScript({ "ApplyBaibaoxiangGetResult", self.nTouzhu })
      self:State_WaitResult()
    end

  -- lingjiang
  elseif self.BTN_LINGJIANG == szWnd then
    me.CallServerScript({ "ApplyBaibaoxiangGetAward", 1 })

  -- lingbi
  elseif self.BTN_LINGBI == szWnd then
    me.CallServerScript({ "ApplyBaibaoxiangGetAward", 2 })

  -- touzhu
  else
    local i
    for i = 1, 3 do
      -- match touzhu type
      if self.BTN_TOUZHU[i][1] == szWnd then
        -- find beike
        local nCoin = me.GetItemCountInBags(18, 1, 325, 1)

        -- check button
        if self.BTN_TOUZHU[i][2] <= nCoin then
          self.nTouzhu = self.BTN_TOUZHU[i][2]
          self:CheckTouzhu(self.nTouzhu)
          self:State_Touzhu()
        else
          Btn_Check(self.UIGROUP, self.BTN_TOUZHU[i][1], 0)
        end
      end
    end
  end
end

-- check box
function uiBaibaoxiang:CheckTouzhu(nTouzhu)
  local i

  for i = 1, 3 do
    if nTouzhu == self.BTN_TOUZHU[i][2] then
      Btn_Check(self.UIGROUP, self.BTN_TOUZHU[i][1], 1)
    else
      Btn_Check(self.UIGROUP, self.BTN_TOUZHU[i][1], 0)
    end
  end
end

-- find grid by type.level.randgrid
-- default return 1 or return array[1]
function uiBaibaoxiang:FindGridByResult(nType, nLevel, nRandGrid)
  local i
  local tbResult = {}

  for i = 1, self.GRID_COUNT do
    if self.IMG_GRID[i][2] == nType then
      if self.IMG_GRID[i][3] == nLevel then
        table.insert(tbResult, i)
      end
    end
  end

  if #tbResult == 0 then
    return 1
  end

  if #tbResult > 1 and nRandGrid > 0 then
    if nRandGrid >= 1 and nRandGrid <= #tbResult then
      return tbResult[nRandGrid]
    else
      return tbResult[1]
    end
  else
    return tbResult[1]
  end
end

-- find same type, may be {}
function uiBaibaoxiang:FindGridByType(nType, nGrid)
  local i
  local tbResult = {}

  for i = 1, self.GRID_COUNT do
    if self.IMG_GRID[i][2] == nType and i ~= nGrid then
      table.insert(tbResult, i)
    end
  end

  return tbResult
end

-- calculate trace
function uiBaibaoxiang:CacMoveGrid(nBeginGrid, nEndGrid)
  local tbSlowTime = {
    [2] = 32, -- 16
    [3] = 24, -- 8
    [4] = 16, -- 4
    [5] = 10, -- 2
  }

  local nMoveGrid = nEndGrid - nBeginGrid + self.GRID_COUNT * 3 - 30

  tbSlowTime[1] = nMoveGrid
  self.nFixPos = math.fmod(nMoveGrid + nBeginGrid, self.GRID_COUNT)
  self.nMaxSlowStep = #tbSlowTime

  return tbSlowTime
end

-- set frame highlight / others gray
function uiBaibaoxiang:SetFrameGrid(nGrid)
  local i
  for i = 1, self.GRID_COUNT do
    if nGrid == i then
      Img_SetFrame(self.UIGROUP, self.IMG_GRID[i][1], 1)
    else
      Img_SetFrame(self.UIGROUP, self.IMG_GRID[i][1], 2)
    end
  end
end

-- grid highlight move
function uiBaibaoxiang:OnTimerMove()
  if self.nCurrGrid > 0 then
    Wnd_SetVisible(self.UIGROUP, self.IMG_GRID[self.nCurrGrid][4], 1)
    Img_SetImage(self.UIGROUP, self.IMG_GRID[self.nCurrGrid][4], 1, self.SPR_RUN)
    Img_PlayAnimation(self.UIGROUP, self.IMG_GRID[self.nCurrGrid][4])
  end

  self.nCurrGrid = self.nCurrGrid + 1

  if self.nCurrGrid > self.GRID_COUNT then
    self.nCurrGrid = self.nCurrGrid - self.GRID_COUNT
  end

  return self.nTimerStep
end

-- simulate slow step
function uiBaibaoxiang:OnTimerDelay()
  self.nSlowStep = self.nSlowStep + 1

  if self.nSlowStep <= self.nMaxSlowStep then
    if self.tbSlowTime[self.nSlowStep] then
      -- position fix
      if self.nSlowStep - 1 == 1 then
        self.nCurrGrid = self.nFixPos
      end
      self.nTimerStep = self.nTimerStep + 1
      return self.tbSlowTime[self.nSlowStep]
    end
  end

  -- close timer
  tbTimer:Close(self.nTimeMoveID)
  tbTimer:Close(self.nTimerDelayID)

  -- reset
  self.nTimeMoveID = 0
  self.nTimerDelayID = 0
  self.nTimerStep = 1
  self.nSlowStep = 1
  self.nMaxSlowStep = 1
  self.tbSlowTime = {}

  -- do state
  self:State_GetResult(self.nLastTimes)
end

-- reset to begin state
function uiBaibaoxiang:OnTimerReset()
  tbTimer:Close(self.nTimerResetID)
  self.nTimerResetID = 0
  self:State_Begin()
end

-- receive server result
function uiBaibaoxiang:OnRecvResult(tbResult)
  if not tbResult then
    return
  end

  -- make scene
  self.nLastType = tbResult.Type
  self.nLastLevel = tbResult.Level
  self.nLastTimes = tbResult.Times
  self.nRandGrid = tbResult.Grid

  self.nEndGrid = self:FindGridByResult(self.nLastType, self.nLastLevel, self.nRandGrid)
  self.tbSlowTime = self:CacMoveGrid(self.nCurrGrid, self.nEndGrid)

  -- window open : do timer slow step
  -- window close : direct do state
  if self.bOpen == 1 then
    self.nTimerDelayID = tbTimer:Register(self.tbSlowTime[1], self.OnTimerDelay, self)
  else
    self:State_GetResult(self.nLastTimes)
  end
end

-- receive server getaward over
function uiBaibaoxiang:OnReset()
  self:State_GetAward()
end

-- begin state
function uiBaibaoxiang:State_Begin()
  -- start button
  Img_SetImage(self.UIGROUP, self.BTN_START, 1, self.SPR_START)

  local i

  -- clear award area
  for i = 1, 6 do
    Wnd_SetVisible(self.UIGROUP, self.IMG_AWARD_LEVEL[i][1], 0)
    Txt_SetTxt(self.UIGROUP, self.IMG_AWARD_LEVEL[i][2], "")
    Wnd_SetVisible(self.UIGROUP, self.IMG_HIGHLIGHT, 0)
  end

  -- grid normal frame
  for i = 1, self.GRID_COUNT do
    Img_SetFrame(self.UIGROUP, self.IMG_GRID[i][1], 0)
  end

  -- disable button
  self:DisableAllButton()

  -- disable grid effect
  self:InvisibleEffect()

  -- touzhu enable
  for i = 1, 3 do
    Wnd_SetEnable(self.UIGROUP, self.BTN_TOUZHU[i][1], 1)
  end

  -- show text
  Txt_SetTxt(self.UIGROUP, self.TXT_MIAOSHU, "请您选择投注金额！")

  -- find beike
  local nCoin = me.GetItemCountInBags(18, 1, 325, 1)

  if self.nTouzhu > 0 and self.nTouzhu <= nCoin then
    self:CheckTouzhu(self.nTouzhu)
    self:State_Touzhu()
  else
    self:CheckTouzhu(0)
  end
end

-- click touzhu
function uiBaibaoxiang:State_Touzhu()
  local i

  -- grid gray
  for i = 1, self.GRID_COUNT do
    Img_SetFrame(self.UIGROUP, self.IMG_GRID[i][1], 2)
  end

  -- disable button
  self:DisableAllButton()

  -- disable grid effect
  self:InvisibleEffect()

  -- touzhu enable
  for i = 1, 3 do
    Wnd_SetEnable(self.UIGROUP, self.BTN_TOUZHU[i][1], 1)
  end

  -- start button
  Wnd_SetEnable(self.UIGROUP, self.BTN_START, 1)

  -- touzhu text
  local szTouzhu = string.format("您当前投注额为：%d贝壳", self.nTouzhu)
  Txt_SetTxt(self.UIGROUP, self.TXT_TOUZHU, szTouzhu)

  -- miaoshu text
  local szMiaoshu = string.format("您选择投注%d个贝壳，点击开始按键就可以了哦！", self.nTouzhu)
  Txt_SetTxt(self.UIGROUP, self.TXT_MIAOSHU, szMiaoshu)
end

-- after start/continue, wait result
function uiBaibaoxiang:State_WaitResult()
  -- disable button
  self:DisableAllButton()

  -- disable grid effect
  self:InvisibleEffect()

  -- register timer grid move
  self.nTimeMoveID = tbTimer:Register(1, self.OnTimerMove, self)
end

-- get result
function uiBaibaoxiang:State_GetResult(nTimes)
  -- disable button
  self:DisableAllButton()

  -- disable grid effect
  self:InvisibleEffect()

  -- enable lingjiang/lingbi
  Wnd_SetEnable(self.UIGROUP, self.BTN_LINGJIANG, 1)
  Wnd_SetEnable(self.UIGROUP, self.BTN_LINGBI, 1)

  -- change start to continue
  Wnd_SetEnable(self.UIGROUP, self.BTN_START, 1)
  Img_SetImage(self.UIGROUP, self.BTN_START, 1, self.SPR_CONTINUE)

  -- highlight result
  self:SetFrameGrid(self.nEndGrid)

  -- highlight award text
  Wnd_SetVisible(self.UIGROUP, self.IMG_GRID[self.nEndGrid][4], 1)
  Img_PlayAnimation(self.UIGROUP, self.IMG_GRID[self.nEndGrid][4], 1)

  local nLevel = me.GetTask(2086, 1)
  local bContinue = me.GetTask(2086, 7)

  -- switch state
  if nTimes == 1 then
    self:State_FirstResult(bContinue)
  elseif nTimes > 1 then
    if bContinue == 1 then
      self:State_SameResult(1)
    elseif bContinue == 0 then
      if nLevel == 6 then
        self:State_SameResult(0)
      else
        self:State_DifferResult(1)
      end
    end
  end
end

-- get first result
function uiBaibaoxiang:State_FirstResult(bContinue)
  -- find same type
  local tbGrid = self:FindGridByType(self.nLastType, self.nEndGrid)

  if #tbGrid <= 0 then
    return
  end

  local i

  -- light same type grid
  for i = 1, #tbGrid do
    Img_SetFrame(self.UIGROUP, self.IMG_GRID[tbGrid[i]][1], 0)
  end

  -- special conditione box
  if bContinue == 0 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_START, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_LINGBI, 0)
  end

  -- update award area
  self:UpdateAward(1)
end

-- update award area
function uiBaibaoxiang:UpdateAward(nTimes)
  local i

  -- get total level and final type
  local nTotalLevel = me.GetTask(2086, 1)
  local nFinalType = me.GetTask(2086, 3)

  -- box special only one level
  if nFinalType == 5 then
    local nNum = self.tbAward[nFinalType][2][1]
    local nMultiple = self.nTouzhu / 2

    local szAward = "宝箱" .. nNum .. "个"

    szAward = Lib:StrFillL(szAward, 12)
    Txt_SetTxt(self.UIGROUP, self.IMG_AWARD_LEVEL[1][2], szAward .. "×" .. nMultiple)
    Wnd_SetVisible(self.UIGROUP, self.IMG_AWARD_LEVEL[1][1], 1)

  -- normal award text
  else
    for i = 1, 6 do
      local nNum = self.tbAward[nFinalType][2][i]
      local nMultiple = self.nTouzhu / 2

      local szAward

      if nFinalType == 1 then
        szAward = nNum .. "级玄晶"
      elseif nFinalType == 2 then
        szAward = "精活" .. nNum .. "点"
      elseif nFinalType == 3 then
        szAward = "银两" .. nNum
      elseif nFinalType == 4 then
        szAward = "绑金" .. nNum
      elseif nFinalType == 5 then
        szAward = "宝箱" .. nNum .. "个"
      end

      szAward = Lib:StrFillL(szAward, 12)
      Txt_SetTxt(self.UIGROUP, self.IMG_AWARD_LEVEL[i][2], szAward .. "×" .. nMultiple)
      Wnd_SetVisible(self.UIGROUP, self.IMG_AWARD_LEVEL[i][1], 1)
    end
  end

  -- highlight area
  Wnd_SetVisible(self.UIGROUP, self.IMG_HIGHLIGHT, 1)
  Wnd_SetPos(self.UIGROUP, self.IMG_HIGHLIGHT, 131, 197 + 25 * (nTotalLevel - 1))

  -- make miaoshou text
  local nNum = self.tbAward[nFinalType][2][nTotalLevel]
  local nTotalNum = nNum * self.nTouzhu / 2
  local nCoin = self.tbAward[6][2][nTotalLevel] * self.nTouzhu / 2
  local szCoin = "贝壳" .. nCoin .. "个"
  local szMiaoshu

  if nFinalType == 1 then
    szMiaoshu = nNum .. "级玄晶" .. (self.nTouzhu / 2) .. "个"
  elseif nFinalType == 2 then
    szMiaoshu = "精活" .. nTotalNum .. "点"
  elseif nFinalType == 3 then
    szMiaoshu = "银两" .. nTotalNum
  elseif nFinalType == 4 then
    szMiaoshu = "绑金" .. nTotalNum
  elseif nFinalType == 5 then
    szMiaoshu = "宝箱" .. nTotalNum .. "个"
  end

  -- miaoshu
  if nFinalType == 5 then
    szMiaoshu = string.format("恭喜您可以领取<color=green> %s <color>！", szMiaoshu)
  else
    szMiaoshu = string.format("恭喜您可以领取<color=green> %s <color>或者<color=green> %s <color>！", szMiaoshu, szCoin)
  end

  Txt_SetTxt(self.UIGROUP, self.TXT_MIAOSHU, szMiaoshu)
end

-- get same type
function uiBaibaoxiang:State_SameResult(nFlag)
  -- find same type
  local tbGrid = self:FindGridByType(self.nLastType, self.nEndGrid)

  if #tbGrid <= 0 then
    return
  end

  local i

  -- light same type grid
  for i = 1, #tbGrid do
    Img_SetFrame(self.UIGROUP, self.IMG_GRID[tbGrid[i]][1], 0)
  end

  -- special level 6
  if nFlag == 0 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_START, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_LINGBI, 1)
  end

  -- flash
  Wnd_SetVisible(self.UIGROUP, self.IMG_FLASH, 1)
  Img_PlayAnimation(self.UIGROUP, self.IMG_FLASH)

  -- update award area
  self:UpdateAward(nTimes)
end

-- get differ result
function uiBaibaoxiang:State_DifferResult(nFlag)
  -- disable all button
  self:DisableAllButton()

  -- clear award area
  for i = 1, 6 do
    Wnd_SetVisible(self.UIGROUP, self.IMG_AWARD_LEVEL[i][1], 0)
    Txt_SetTxt(self.UIGROUP, self.IMG_AWARD_LEVEL[i][2], "")
    Wnd_SetVisible(self.UIGROUP, self.IMG_HIGHLIGHT, 0)
  end

  -- miaoshu text
  local szMiaoshu = "您这次运气差了少许，再加把劲试试吧！"
  Txt_SetTxt(self.UIGROUP, self.TXT_MIAOSHU, szMiaoshu)

  -- register timer to reset
  self.nTimerResetID = tbTimer:Register(50, self.OnTimerReset, self)
end

-- after server getaward success
function uiBaibaoxiang:State_GetAward()
  -- disable all button
  self:DisableAllButton()

  -- disable grid effect
  self:InvisibleEffect()

  -- register timer to reset
  self.nTimerResetID = tbTimer:Register(50, self.OnTimerReset, self)
end

-- animation callback
function uiBaibaoxiang:OnAnimationOver(szWnd)
  if szWnd == self.IMG_FLASH then
    self.nFlashTimes = self.nFlashTimes + 1

    if self.nFlashTimes > 5 then
      self.nFlashTimes = 0
      Wnd_SetVisible(self.UIGROUP, self.IMG_FLASH, 0)
    else
      Img_PlayAnimation(self.UIGROUP, self.IMG_FLASH)
    end
  else
    local i
    for i = 1, self.GRID_COUNT do
      if szWnd == self.IMG_GRID[i][4] then
        Wnd_SetVisible(self.UIGROUP, self.IMG_GRID[i][4], 0)
        Img_SetImage(self.UIGROUP, self.IMG_GRID[i][4], 1, self.SPR_EFFECT)
      end
    end
  end
end
