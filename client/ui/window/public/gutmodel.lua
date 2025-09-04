-----------------------------------------------------
--文件名		：	gutmodel.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-02-06
--功能描述		：	ui的剧情模式。
------------------------------------------------------

local uiGutModel = Ui:GetClass("gutmodel")

local IMAGE_HEAD = "ImgHead"
local IMAGE_FOOT = "ImgFoot"
local PROGRESS_TIME = 400

function uiGutModel:Init()
  self.nLoadCompleted = 0
  self.tbOpeningCallback = {}
  self.tbEndingCallback = {}
end

function uiGutModel:OnOpen()
  if UiManager:WindowVisible(Ui.UI_TRADE) == 1 then
    UiManager:CloseWindow(Ui.UI_TRADE)
  end
  UiManager:SwitchUiModel(2)
end

function uiGutModel:OnClose()
  UiManager:SwitchUiModel(0)
end

function uiGutModel:Opening() -- 开幕
  Prg_SetTime(self.UIGROUP, IMAGE_HEAD, PROGRESS_TIME, 0)
  Prg_SetTime(self.UIGROUP, IMAGE_FOOT, PROGRESS_TIME, 0)
end

function uiGutModel:Ending() -- 谢幕
  Prg_SetTime(self.UIGROUP, IMAGE_HEAD, PROGRESS_TIME, 1)
  Prg_SetTime(self.UIGROUP, IMAGE_FOOT, PROGRESS_TIME, 1)
end

function uiGutModel:OnProgressFull(szWnd)
  if szWnd == IMAGE_FOOT then
    if self.nLoadCompleted == 0 then
      for _, tbCall in ipairs(self.tbOpeningCallback) do
        Lib:CallBack({ tbCall[2], tbCall[1], tbCall[3] })
      end
      self.tbOpeningCallback = {}
      self.nLoadCompleted = 1
    else
      for _, tbCall in ipairs(self.tbEndingCallback) do
        Lib:CallBack({ tbCall[2], tbCall[1], tbCall[3] })
      end
      self.tbEndingCallback = {}
      UiManager:CloseWindow(self.UIGROUP)
      self.nLoadCompleted = 0
    end
  end
end

-- 剧情模式的入口函数
function uiGutModel:GutBegin(varTable, varFunc, tbParam)
  if varTable and varFunc then
    table.insert(self.tbOpeningCallback, { varTable, varFunc, tbParam })
  end
  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    UiManager:OpenWindow(self.UIGROUP)
    self:Opening()
  else
    self.nLoadCompleted = 0
    Prg_SetTime(self.UIGROUP, IMAGE_HEAD, 0)
    self:OnProgressFull(IMAGE_FOOT)
    Prg_SetTime(self.UIGROUP, IMAGE_FOOT, 0)
  end
end

function uiGutModel:GutEnd(varTable, varFunc, tbParam)
  if varTable and varFunc then
    table.insert(self.tbEndingCallback, { varTable, varFunc, tbParam })
  end
  self:Ending()
  UiManager:CloseWindow(Ui.UI_GUTTALK)
  UiManager:CloseWindow(Ui.UI_GUTAWARD)
  UiManager:CloseWindow(Ui.UI_GUTSAY)
end
