-----------------------------------------------------
--文件名		：	msgbox.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-5-6
--功能描述		：	消息确认小窗口
------------------------------------------------------

local tbMsgBox = Ui:GetClass("msgbox")
local tbTimer = Ui.tbLogic.tbTimer

local TXT_MSG = "TxtMsg"
local TXT_TITLE = "TxtTitle"
local BTN_OPTION = "BtnOption"

local TIMER_TICK = Env.GAME_FPS -- 定时器最小单位，1秒
local MAX_OPTION_NUMBER = 3
local TIMEOUT_LIMIT = 5

----------------------------------------------------------------------------------------
--                MsgBox通关攻略
-- 调用方式： UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, ...);
-- tbMsg参数详解：
-- tbMsg.szMsg		必填	显示的消息
-- tbMsg.szTitle	可选	标题文字
-- tbMsg.bExclusive	可选	是否独占窗口，默认为独占
-- tbMsg.tbPos		可选	窗口的初始位置。例：tbPos = { 203, 426 } 则窗口位置为203,426
-- tbMsg.nOptCount  可选    定义窗口上选项个数，目前支持最大MAX_BTN_NUMBER个，默认为2
-- tbMsg.tbOptTitle	可选    选项名字表, 比如 tbOptTitle[2] = "确定"
-- tbMsg.nTimeout   可选	超时时间（秒），如果超时，则调用设定的Callback，选项索引为0
-- tbMsg:Callback	可选	点击按钮后的回调函数，其中第一个参数为选项索引（从1开始），后续参数为自定义
-- tbMsg.tbFun		可选    需要为MsgBox重载/新增的函数
----------------------------------------------------------------------------------------

function tbMsgBox:Init()
  self.tbMsg = nil
  self.tbArgs = {}
  self.nTimerId = 0
end

function tbMsgBox:OnOpen(tbMsg, ...)
  if (not tbMsg) or not tbMsg.szMsg then
    return 0
  end

  self.tbMsg = tbMsg
  self.tbArgs = arg
  if tbMsg.tbFun then
    for n, x in pairs(tbMsg.tbFun) do
      self[n] = x
    end
  end
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
  elseif tbMsg.nOptCount == 3 then
    if not tbMsg.tbOptTitle[1] then
      tbMsg.tbOptTitle[1] = "中止"
    end
    if not tbMsg.tbOptTitle[2] then
      tbMsg.tbOptTitle[2] = "重试"
    end
    if not tbMsg.tbOptTitle[3] then
      tbMsg.tbOptTitle[3] = "忽略"
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

  self:UpdateMsg()
  return 1
end

function tbMsgBox:OnClose()
  if self.nTimerId > 0 then
    tbTimer:Close(self.nTimerId)
    self.nTimerId = 0
  end
  if self.tbMsg.bExclusive == 1 then
    UiManager:SetExclusive(self.UIGROUP, 0) -- 取消独占状态
  end
end

function tbMsgBox:OnButtonClick(szWnd, nParam)
  local tbMsg = self.tbMsg
  local _, _, szIndex = string.find(szWnd, BTN_OPTION .. "(%d+)")
  if not szIndex then
    return
  end
  local nIndex = tonumber(szIndex)
  local bRet = 0
  if tbMsg.Callback then
    bRet = tbMsg:Callback(nIndex, unpack(self.tbArgs))
  end
  if bRet ~= 1 then
    UiManager:CloseWindow(self.UIGROUP) -- 按下按钮必然会关闭自己
  end
end

function tbMsgBox:OnTimer()
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

function tbMsgBox:UpdateMsg()
  local tbMsg = self.tbMsg
  local szMsg = tbMsg.szMsg
  if tbMsg.nTimeout > 0 then
    szMsg = string.format("%s  ... [<color=%s>%d<color>]", szMsg, (tbMsg.nTimeout < TIMEOUT_LIMIT) and "red" or "green", tbMsg.nTimeout)
  end
  TxtEx_SetText(self.UIGROUP, TXT_MSG, szMsg) -- 设置信息文字
end
