-----------------------------------------------------
--文件名		：	msgprocessing.lua
--创建者		：	zhongjunqi
--创建时间		：	2011-8-30
--功能描述		：	处理过程的消息窗口
------------------------------------------------------
local tbMsgBox = Ui:GetClass("msgprocessing")
local tbTimer = Ui.tbLogic.tbTimer

local TXT_MSG = "TxtMsg"
local BTN_OPTION = "ConfirmBtn"

local TIMER_TICK = Env.GAME_FPS -- 定时器最小单位，1秒
local MAX_OPTION_NUMBER = 2
local TIMEOUT_LIMIT = 5
local BTN_POS = { [1] = { 74, 125 }, [2] = { { 17, 125 }, { 133, 125 } } } -- 按钮布局信息
----------------------------------------------------------------------------------------
--                MsgBox通关攻略
-- 调用方式： UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, ...);
-- tbMsg参数详解：
-- tbMsg.szMsg		必填	显示的消息
-- tbMsg.bChangeColor 可选	是否变化文字信息，默认变,0为不变
-- tbMsg.bExclusive	可选	是否独占窗口，默认为独占
-- tbMsg.tbPos		可选	窗口的初始位置。例：tbPos = { 203, 426 } 则窗口位置为203,426
-- tbMsg.nOptCount  可选    定义窗口上选项个数，目前支持最大MAX_BTN_NUMBER个，默认为1
-- tbMsg.tbOptTitle	可选    选项名字表, 比如 tbOptTitle[2] = "确定"
-- tbMsg.nTimeout   可选	超时时间（秒），如果超时，则调用设定的Callback
-- tbMsg:Callback	可选	点击按钮后的回调函数，参数为自定义
-- tbMsg:CallbackSelf 可选  回调函数的self
----------------------------------------------------------------------------------------

function tbMsgBox:Init()
  self.tbMsg = nil
  self.tbArgs = {}
  self.nTimerId = 0
  self.nChangeColorTimerId = 0
end

function tbMsgBox:OnOpen(tbMsg, ...)
  if (not tbMsg) or not tbMsg.szMsg then
    return 0
  end

  self.tbMsg = tbMsg
  self.tbArgs = arg

  if (not tbMsg.bExclusive) or (tbMsg.bExclusive == 1) then
    tbMsg.bExclusive = 1
  else
    tbMsg.bExclusive = 0
  end

  if (not tbMsg.nOptCount) or (tbMsg.nOptCount < 0) or (tbMsg.nOptCount > MAX_OPTION_NUMBER) then
    tbMsg.nOptCount = 1
  end

  if not tbMsg.tbOptTitle then
    tbMsg.tbOptTitle = {}
  end

  if tbMsg.nOptCount == 1 then
    if not tbMsg.tbOptTitle[1] then
      tbMsg.tbOptTitle[1] = "返回"
    end
    Wnd_SetPos(self.UIGROUP, BTN_OPTION .. 1, unpack(BTN_POS[1]))
  elseif tbMsg.nOptCount == 2 then
    if not tbMsg.tbOptTitle[1] then
      tbMsg.tbOptTitle[1] = "确定"
    end
    Wnd_SetPos(self.UIGROUP, BTN_OPTION .. 1, unpack(BTN_POS[2][1]))
    if not tbMsg.tbOptTitle[2] then
      tbMsg.tbOptTitle[2] = "返回"
    end
    Wnd_SetPos(self.UIGROUP, BTN_OPTION .. 2, unpack(BTN_POS[2][2]))
  end

  if tbMsg.bExclusive == 1 then
    UiManager:SetExclusive(self.UIGROUP, 1) -- 设置为独占
  end

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
    Wnd_SetPos(self.UIGROUP, nil, unpack(tbMsg.tbPos)) -- 设置窗口的初始位置
  end

  if not tbMsg.nTimeout then
    tbMsg.nTimeout = 0
  end

  if tbMsg.nTimeout > 0 then
    self.nTimerId = tbTimer:Register(TIMER_TICK, self.OnTimer, self) -- 开启定时器，定时1秒
  end

  if tbMsg.bChangeColor ~= 0 then
    self.nChangeColorTimerId = tbTimer:Register(TIMER_TICK / 5, self.OnChangeColorTimer, self)
    self.tbParseStr = Lib:NewUtf8Str(tbMsg.szMsg) -- 切分字符串用
  end

  return 1
end

function tbMsgBox:OnClose()
  if self.nTimerId > 0 then
    tbTimer:Close(self.nTimerId)
    self.nTimerId = 0
  end
  if self.nChangeColorTimerId > 0 then
    tbTimer:Close(self.nChangeColorTimerId)
    self.nChangeColorTimerId = 0
  end
  if self.tbMsg.bExclusive == 1 then
    UiManager:SetExclusive(self.UIGROUP, 0) -- 取消独占状态
  end
end

function tbMsgBox:OnButtonClick(szWnd, nParam)
  local _, _, szIndex = string.find(szWnd, BTN_OPTION .. "(%d+)")
  if not szIndex then
    return
  end
  local nIndex = tonumber(szIndex)
  local bRet = 0

  local tbMsg = self.tbMsg
  if tbMsg.Callback then
    if tbMsg.CallbackSelf then
      bRet = tbMsg.Callback(tbMsg.CallbackSelf, nIndex, unpack(self.tbArgs))
    else
      bRet = tbMsg.Callback(nIndex, unpack(self.tbArgs))
    end
  end
  UiManager:CloseWindow(self.UIGROUP) -- 按下按钮必然会关闭自己
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
      if tbMsg.CallbackSelf then
        tbMsg.Callback(tbMsg.CallbackSelf, nIndex, unpack(self.tbArgs))
      else
        tbMsg.Callback(nIndex, unpack(self.tbArgs))
      end
    end
    UiManager:CloseWindow(self.UIGROUP)
  end
end

-- todo 逐个高亮文字？
function tbMsgBox:OnChangeColorTimer()
  local nStrLen = self.tbParseStr:GetLen()
  if nStrLen == 0 then
    return
  end
  local szOut = ""
  self.nIndex = self.nIndex or 1
  if nStrLen < self.nIndex or self.nIndex == 1 then
    self.nIndex = 1
  else
    szOut = self.tbParseStr:SubStr(1, self.nIndex - 1)
  end
  local szChange = self.tbParseStr:SubStr(self.nIndex, self.nIndex)
  szOut = szOut .. "<color=yellow>" .. szChange .. "<color>"
  if nStrLen >= self.nIndex + 1 then
    szOut = szOut .. self.tbParseStr:SubStr(self.nIndex + 1)
  end

  if self.tbMsg.nTimeout and self.tbMsg.nTimeout > 0 then
    szOut = string.format("%s  [<color=%s>%d<color>]", szOut, (self.tbMsg.nTimeout < TIMEOUT_LIMIT) and "red" or "green", self.tbMsg.nTimeout)
  end

  Txt_SetTxt(self.UIGROUP, TXT_MSG, szOut) -- 设置信息文字
  self.nIndex = self.nIndex + 1
end
