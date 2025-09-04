-- ====================== 文件信息 ======================

-- 队列式公告脚本
-- Edited by peres
-- 2007/11/07 PM 08:00

-- 如果有过幸福。
-- 幸福只是瞬间的片断，一小段一小段。

-- ======================================================

-- 增加一个公告的 GM 指令：??UiManager:OpenWindow("UI_INFOBOARD", "这是超级无敌的公告啊！！！");

local tbInfoBoard = Ui:GetClass("infoboard")
local tbTimer = Ui.tbLogic.tbTimer

local DEFAULT_TIME = 6
local TEXT_WINDOW = { "Txt1", "Txt2", "Txt3" }

tbInfoBoard.WND_MAIN = "Main"

function tbInfoBoard:Init()
  self.tbInfo = { { "", 0 }, { "", 0 }, { "", 0 } }
  self.nMaxInfo = 0
  self.nTimerId = 0
end

function tbInfoBoard:OnOpen(szText)
  local tbTempData = Ui.tbLogic.tbTempData
  if tbTempData.tbInfoboardText then
    self.tbInfo = tbTempData.tbInfoboardText
    self.nMaxInfo = tbTempData.nMaxInfoboardText
  end

  if self.nTimerId == 0 then
    self.nTimerId = tbTimer:Register(Env.GAME_FPS * 1, self.OnTimer, self)
  end

  local szTempText, nTempTimes = "", 0
  if self.nMaxInfo <= 0 then
    self.tbInfo[1] = { szText, DEFAULT_TIME }
  else
    for i = #self.tbInfo, 2, -1 do
      szTempText, nTempTimes = unpack(self.tbInfo[i - 1])
      self.tbInfo[i] = { szTempText, nTempTimes }
    end
    self.tbInfo[1] = { szText, DEFAULT_TIME }
  end

  self.nMaxInfo = self.nMaxInfo + 1
  self:UpDate()
  Wnd_Show(self.UIGROUP, self.WND_MAIN)
end

function tbInfoBoard:OnClose(szText)
  local tbTempData = Ui.tbLogic.tbTempData
  tbTempData.tbInfoboardText = self.tbInfo
  tbTempData.nMaxInfoboardText = self.nMaxInfo

  if self.nTimerId and self.nTimerId ~= 0 then
    tbTimer:Close(self.nTimerId)
    tbInfoBoard.nTimerId = 0
  end
end

function tbInfoBoard:UpDate()
  for i, v in ipairs(self.tbInfo) do
    if (v[1] ~= "") and (v[2] ~= 0) then
      Txt_SetTxt(self.UIGROUP, TEXT_WINDOW[i], v[1])
      Wnd_Show(self.UIGROUP, TEXT_WINDOW[i])
    else
      Wnd_Hide(self.UIGROUP, TEXT_WINDOW[i])
    end
  end
end

function tbInfoBoard:OnTimer()
  local nTimes = 0

  for i = #self.tbInfo, 1, -1 do
    nTimes = nTimes + self.tbInfo[i][2]
    if self.tbInfo[i][2] > 0 then
      self.tbInfo[i][2] = self.tbInfo[i][2] - 1
      --Txt_SetTxtColor(self.UIGROUP, TEXT_WINDOW[i], { 255, 0, 0, self.tbInfo[i][2] * 50 });
      Txt_SetTxtColor(self.UIGROUP, TEXT_WINDOW[i], { 255, 0, 0 })
      if self.tbInfo[i][2] <= 0 then
        Wnd_Hide(self.UIGROUP, TEXT_WINDOW[i])
        self.tbInfo[i][1] = ""
        --				self.nMaxInfo = self.nMaxInfo - 1;
      end
    end
  end

  self:UpDate()

  if nTimes == 0 then
    if self.nTimerId and (self.nTimerId ~= 0) then
      UiManager:CloseWindow(self.UIGROUP)
    end
  end
end
