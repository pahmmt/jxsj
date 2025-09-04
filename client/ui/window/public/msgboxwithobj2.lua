-- 文件名　：msgboxwithobj2.lua
-- 创建者　：zhangjunjie
-- 创建时间：2011-03-04 09:28:46
-- 描述：逻辑和msgboxwithobj一样，只是换了个外观

local tbMsgBoxWithObj = Ui:GetClass("msgboxwithobj2")
local tbTimer = Ui.tbLogic.tbTimer
local tbObject = Ui.tbLogic.tbObject

local TXT_MSG = "TxtMsg"
local TXT_TITLE = "TxtTitle"
local BTN_OPTION = "BtnOption"
local OBJ_OBJ = "Obj"
local TIMER_TICK = Env.GAME_FPS -- 定时器最小单位，1秒
local MAX_OPTION_NUMBER = 2 --最大选项个数
local TIMEOUT_LIMIT = 5
local CLOSED_EVENT = 99

local tbViewGoodCont = { bShowCd = 0, bUse = 0 }
function tbViewGoodCont:CheckMouse(tbMouseObj)
  return 0
end
function tbViewGoodCont:ClickMouse(tbObj, nX, nY)
  return 0
end

----------------------------------------------------------------------------------------
--                MsgBox通关攻略
-- 调用方式： UiManager:OpenWindow(Ui.UI_MSGBOXWITHOBJ2, tbMsg, ...);
-- tbMsg参数详解：
-- tbMsg.szMsg		必填	显示的消息
-- tbMsg.tgObj		必填	显示的obj
-- tbMsg.szTitle	可选	标题文字
-- tbMsg.bExclusive	可选	是否独占窗口，默认为独占
-- tbMsg.tbPos		可选	窗口的初始位置。例：tbPos = { 203, 426 } 则窗口位置为203,426
-- tbMsg.nOptCount  可选    定义窗口上选项个数，目前支持最大MAX_BTN_NUMBER个，默认为2
-- tbMsg.tbOptTitle	可选    选项名字表, 比如 tbOptTitle[2] = "确定"
-- tbMsg.nTimeout   可选	超时时间（秒），如果超时，则调用设定的Callback，选项索引为0
-- tbMsg.bClose   	可选	是否关闭自己
-- tbMsg:Callback	可选	点击按钮后的回调函数，其中第一个参数为选项索引（从1开始），后续参数为自定义
----------------------------------------------------------------------------------------

function tbMsgBoxWithObj:Init()
  self.tbMsg = nil
  self.tbArgs = {}
  self.nTimerId = 0
  self.bClose = 1
end

function tbMsgBoxWithObj:OnCreate()
  self.tbViewGoodCont = tbObject:RegisterContainer(self.UIGROUP, OBJ_OBJ, 1, 1, tbViewGoodCont)
end

function tbMsgBoxWithObj:OnDestroy()
  tbObject:UnregContainer(self.tbViewGoodCont)
end

function tbMsgBoxWithObj:OnOpen(tbMsg, ...)
  if (not tbMsg) or not tbMsg.szMsg then
    return 0
  end

  self.tbMsg = tbMsg
  self.tbArgs = arg

  if not tbMsg.szTitle then
    tbMsg.szTitle = "提　示"
  end

  if (not tbMsg.bExclusive) or (tbMsg.bExclusive == 1) then
    tbMsg.bExclusive = 1
  else
    tbMsg.bExclusive = 0
  end

  if (not tbMsg.nOptCount) or (tbMsg.nOptCount < 1) or (tbMsg.nOptCount > MAX_OPTION_NUMBER) then
    tbMsg.nOptCount = 2
  end

  if not tbMsg.tbOptTitle then
    tbMsg.tbOptTitle = {}
  end

  if tbMsg.bClose and tbMsg.bClose == 0 then
    self.bClose = 0
  end

  if tbMsg.nOptCount == 1 then
    if not tbMsg.tbOptTitle[1] then
      tbMsg.tbOptTitle[1] = "确定"
    end
  elseif tbMsg.nOptCount == 2 then
    if not tbMsg.tbOptTitle[1] then
      tbMsg.tbOptTitle[1] = "取消"
    end
    if not tbMsg.tbOptTitle[2] then
      tbMsg.tbOptTitle[2] = "确定"
    end
  end

  if tbMsg.bExclusive == 1 then
    UiManager:SetExclusive(self.UIGROUP, 1) -- 设置为独占
  end

  Txt_SetTxt(self.UIGROUP, TXT_TITLE, tbMsg.szTitle) -- 设置标题文字

  -- 设置按钮显示
  for i = 1, MAX_OPTION_NUMBER do
    local szBtn = BTN_OPTION .. i
    Btn_SetTxt(self.UIGROUP, szBtn, tbMsg.tbOptTitle[i] or "")
    if i <= tbMsg.nOptCount then
      Wnd_Show(self.UIGROUP, szBtn)
    else
      Wnd_Hide(self.UIGROUP, szBtn)
    end
  end

  if tbMsg.tbPos and (#tbMsg.tbPos == 2) then
    Wnd_SetPos(self.UIGROUP, unpack(tbMsg.tbPos)) -- 设置窗口的初始位置
  end

  if not tbMsg.nTimeout then
    tbMsg.nTimeout = 0
  end

  if tbMsg.nTimeout > 0 then
    self.nTimerId = tbTimer:Register(TIMER_TICK, self.OnTimer, self) -- 开启定时器，定时1秒
  end

  self.tbViewGoodCont:ClearObj()
  if tbMsg.tgObj ~= nil then
    self.tbViewGoodCont:SetObj(tbMsg.tgObj)
  end

  self:UpdateMsg()
  return 1
end

function tbMsgBoxWithObj:OnClose()
  local tbMsg = self.tbMsg
  if tbMsg.Callback then
    tbMsg:Callback(CLOSED_EVENT, self, unpack(self.tbArgs))
  end

  self.tbViewGoodCont:ClearObj()
  if self.nTimerId > 0 then
    tbTimer:Close(self.nTimerId)
    self.nTimerId = 0
  end
  if self.tbMsg.bExclusive == 1 then
    UiManager:SetExclusive(self.UIGROUP, 0) -- 取消独占状态
  end
end

function tbMsgBoxWithObj:OnButtonClick(szWnd, nParam)
  if szWnd == "BtnOption1" or szWnd == "BtnClose" then
    UiManager:CloseWindow(self.UIGROUP)
    return
  end

  local tbMsg = self.tbMsg
  local _, _, szIndex = string.find(szWnd, BTN_OPTION .. "(%d+)")
  if not szIndex then
    return
  end
  local nIndex = tonumber(szIndex)
  if tbMsg.Callback then
    tbMsg:Callback(nIndex, self, unpack(self.tbArgs))
  end
  if self.bClose == 1 then
    UiManager:CloseWindow(self.UIGROUP) -- 按下按钮必然会关闭自己
  end
end

function tbMsgBoxWithObj:OnTimer()
  local tbMsg = self.tbMsg
  tbMsg.nTimeout = tbMsg.nTimeout - 1
  if tbMsg.nTimeout <= 0 then
    if self.nTimerId > 0 then
      tbTimer:Close(self.nTimerId)
      self.nTimerId = 0
    end
    if tbMsg.Callback then
      tbMsg:Callback(0, unpack(self.tbArgs))
    end
    UiManager:CloseWindow(self.UIGROUP)
  else
    self:UpdateMsg()
  end
end

function tbMsgBoxWithObj:UpdateMsg()
  local tbMsg = self.tbMsg
  local szMsg = tbMsg.szMsg
  if tbMsg.nTimeout > 0 then
    szMsg = string.format("%s  ... [<color=%s>%d<color>]", szMsg, (tbMsg.nTimeout < TIMEOUT_LIMIT) and "red" or "green", tbMsg.nTimeout)
  end
  Txt_SetTxt(self.UIGROUP, TXT_MSG, szMsg) -- 设置信息文字
end

function tbMsgBoxWithObj:RegisterEvent()
  local tbRegEvent = {}
  tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbViewGoodCont:RegisterEvent())
  return tbRegEvent
end

function tbMsgBoxWithObj:RegisterMessage()
  local tbRegMsg = {}
  tbRegMsg = Lib:MergeTable(tbRegMsg, self.tbViewGoodCont:RegisterMessage())
  return tbRegMsg
end

function tbMsgBoxWithObj:OnEscExclusiveWnd(szWnd)
  UiManager:CloseWindow(self.UIGROUP)
end
