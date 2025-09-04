-- FileName	: limitplay.lua
-- Author	: furuilei
-- Time		: 2010-4-20 10:44
-- Comment	: 防沉迷补充信息

local uiLimitPlay = Ui:GetClass("limitplay")
local BTN_CLOSE = "BtnCancle"
local IE_WND = "IEWnd"

function uiLimitPlay:Init()
  -- 调用这里，把配置文件中的信息读取进来，保存，这里主要读取的是几个url地址
  local tbUrl = self.tbLimitPlayUrl
  if not tbUrl or not tbUrl["TerminateUrl_OK"] or not tbUrl["TerminateUrl_FAIL"] or not tbUrl["BeginUrl"] then
    self.tbLimitPlayUrl = {}
    local tbIniInfo = Lib:LoadIniFile("\\ui\\001a\\window\\limitplay.ini")
    assert(tbIniInfo)
    for szSessionName, tbInfo in pairs(tbIniInfo) do
      if szSessionName == "IEWnd" then
        local szBeginUrl = tostring(tbInfo["Url"])
        local szTerminateUrl_OK = tostring(tbInfo["TerminateUrl_OK"])
        local szTerminateUrl_FAIL = tostring(tbInfo["TerminateUrl_FAIL"])
        self.tbLimitPlayUrl["BeginUrl"] = szBeginUrl
        self.tbLimitPlayUrl["TerminateUrl_OK"] = szTerminateUrl_OK
        self.tbLimitPlayUrl["TerminateUrl_FAIL"] = szTerminateUrl_FAIL
        break
      end
    end
  end
end
uiLimitPlay:Init()

function uiLimitPlay:OnOpen(szBeginUrl, bContinuePlay)
  if not szBeginUrl then
    return
  end
  self.bContinuePlay = bContinuePlay -- 是否继续游戏，如果有这个标记不会重新登录，用于游戏内补填
  Wnd_Show(self.UIGROUP, IE_WND)
  self:OnEnterUrl(szBeginUrl)
end

function uiLimitPlay:OnEscExclusiveWnd()
  self:Failed()
end

function uiLimitPlay:OnButtonClick(szWnd, nParam)
  if szWnd == BTN_CLOSE then
    self:Failed()
  end
end

function uiLimitPlay:OnIeComplete(szWnd, szUrl)
  if szWnd == IE_WND then
    local tbUrl = self.tbLimitPlayUrl
    if not tbUrl then
      return 0
    end
    local szOKUrl = tbUrl["TerminateUrl_OK"]
    local szFailUrl = tbUrl["TerminateUrl_FAIL"]
    if not szOKUrl or not szFailUrl or not szUrl then
      return 0
    end
    -- 补充信息成功
    if szOKUrl == szUrl then
      self:Success()
      return 1
    end
    -- 补充信息失败
    -- local s, e = string.find(szUrl, szFailUrl);
    -- if (s and e and s ~= e) then
    -- 	self:Failed();
    -- 	return 1;
    -- end
  end
end

-- 成功补充完信息，关闭窗口，继续登录
function uiLimitPlay:Success()
  UiManager:CloseWindow(self.UIGROUP)
  if self.bContinuePlay == 1 then
    local tbMsg = { szMsg = "    恭喜您补填实名信息成功，需要重新登录游戏才能生效。", bExclusive = 0, nOptCount = 1 }
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
  else
    AccountLoginSecret() -- 自动登录
  end
end

-- 填写信息失败，关闭窗口，返回到服务器选择界面
function uiLimitPlay:Failed()
  UiManager:CloseWindow(self.UIGROUP)
  if self.bContinuePlay == 1 then
    local tbMsg = { szMsg = "    您补填实名信息没有成功，将会继续纳入防沉迷系统。", bExclusive = 0, nOptCount = 1 }
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
  else
    Ui.tbLogic.tbLogin:CancelConnectBishop()
  end
end

function uiLimitPlay:OnEnterUrl(szBeginUrl)
  if szBeginUrl then
    IE_Navigate(self.UIGROUP, IE_WND, szBeginUrl)
  end
end
