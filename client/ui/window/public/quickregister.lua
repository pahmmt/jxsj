-- FileName	: quciregister.lua
-- Author	: zhongjunqi
-- Time		: 2011-11-10 10:44
-- Comment	: 快速注册

local uiQuickRegister = Ui:GetClass("quickregister")
local BTN_CLOSE = "BtnCancle"
local IE_WND = "IEWnd"

function uiQuickRegister:init() end

function uiQuickRegister:OnOpen()
  UiManager:SetExclusive(self.UIGROUP, 1)
  IE_Navigate(self.UIGROUP, IE_WND, "http://my.xoyo.com/express/jxsj.php")
end

function uiQuickRegister:OnClose()
  UiManager:SetExclusive(self.UIGROUP, 0)
end

function uiQuickRegister:OnEscExclusiveWnd()
  UiManager:CloseWindow(self.UIGROUP)
end

function uiQuickRegister:OnButtonClick(szWnd, nParam)
  if szWnd == BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiQuickRegister:Split(szFullString, szSeparator)
  local nFindStartIndex = 1
  local nSplitIndex = 1
  local nSplitArray = {}
  while true do
    local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
    if not nFindLastIndex then
      nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
      break
    end
    nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
    nFindStartIndex = nFindLastIndex + string.len(szSeparator)
    nSplitIndex = nSplitIndex + 1
  end
  return nSplitArray
end

function uiQuickRegister:ParseUrlParam(szUrl)
  local tbParamMap = {}
  local nStartParam = string.find(szUrl, "?")
  if nStartParam then
    local szParam = string.sub(szUrl, nStartParam + 1)
    local tbParam = self:Split(szParam, "&")
    for i, v in ipairs(tbParam) do
      local tbMap = self:Split(v, "=")
      tbParamMap[tbMap[1]] = tbMap[2]
    end
  end
  return tbParamMap
end

function uiQuickRegister:OnIeComplete(szWnd, szUrl)
  if szWnd == IE_WND then
    if string.find(szUrl, "olduser.php") then
      local uiAccountHole = Ui(Ui.UI_ACCOUNT_LOGIN)
      if uiAccountHole then
        Wnd_SetFocus(uiAccountHole.UIGROUP, uiAccountHole.EDIT_ACCOUNT)
        uiAccountHole.nLastFocus = 1
      end
      UiManager:CloseWindow(self.UIGROUP)
      return
    end
    if string.find(szUrl, "jxsj.php") then
      local tbParam = self:ParseUrlParam(szUrl)
      if tbParam["user"] ~= nil and tbParam["user"] ~= "" then -- 注册成功
        -- 跨界面访问，不太好
        local uiAccountHole = Ui(Ui.UI_ACCOUNT_LOGIN)
        if uiAccountHole then
          uiAccountHole:SetAccount(tbParam["user"])
        else
          UiManager:OpenWindow(Ui.UI_ACCOUNT_LOGIN)
        end
        UiManager:CloseWindow(self.UIGROUP)
      end
    end
  end
end
