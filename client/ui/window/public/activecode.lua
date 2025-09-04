-- FileName	: activecode.lua
-- Author	: zhongjunqi
-- Time		: 2012-8-31 9:04
-- Comment	: 激活码页面

local uiActiveCode = Ui:GetClass("activecode")
local BTN_CLOSE = "BtnCancle"
local IE_WND = "IEWnd"

uiActiveCode.szOkUrl = "http://zt.xoyo.com/jxsj/inplay/inner/succ.php"

function uiActiveCode:OnOpen(szBeginUrl)
  if not szBeginUrl then
    return
  end
  Wnd_Show(self.UIGROUP, IE_WND)
  self:OnEnterUrl(szBeginUrl)
end

function uiActiveCode:OnEscExclusiveWnd()
  self:Failed()
end

function uiActiveCode:OnButtonClick(szWnd, nParam)
  if szWnd == BTN_CLOSE then
    self:Failed()
  end
end

function uiActiveCode:OnIeComplete(szWnd, szUrl)
  if szWnd == IE_WND then
    if self.szOkUrl == szUrl then
      self:Success()
      return 1
    end
  end
end

-- 成功补充完信息，关闭窗口，继续登录
function uiActiveCode:Success()
  UiManager:CloseWindow(self.UIGROUP)
  AccountLoginSecret() -- 自动登录
end

-- 填写信息失败，关闭窗口，返回到服务器选择界面
function uiActiveCode:Failed()
  UiManager:CloseWindow(self.UIGROUP)
  Ui.tbLogic.tbLogin:CancelConnectBishop()
end

function uiActiveCode:OnEnterUrl(szBeginUrl)
  if szBeginUrl then
    IE_Navigate(self.UIGROUP, IE_WND, szBeginUrl)
  end
end
