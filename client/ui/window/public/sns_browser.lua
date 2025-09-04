-----------------------------------------------------
--文件名		：	sns_browser.lua
--创建者		：	wangzhiguang
--创建时间		：	2011-03-31
--功能描述		：	社交网络浏览器
------------------------------------------------------

local uiSnsBrowser = Ui:GetClass("sns_browser")

local BTN_CLOSE = "BtnClose"
local BTN_TENCENT = "BtnTencent"
local BTN_SINA = "BtnSina"
local BTN_TENCENT_TOPIC = "BtnTencentTopic"
local BTN_SINA_TOPIC = "BtnSinaTopic"
local IE_WND = "IEWnd"

local tbCheckBox = { BTN_TENCENT, BTN_SINA, BTN_TENCENT_TOPIC, BTN_SINA_TOPIC }

function uiSnsBrowser:Init()
  self.tbUrl = {
    [Sns.SNS_T_TENCENT] = "http://t.qq.com/",
    [Sns.SNS_T_SINA] = "http://t.sina.com.cn/",
  }
end

function uiSnsBrowser:OnOpen(szUrl)
  local nSnsId = string.find(szUrl, "http://t.qq.com") == 1 and Sns.SNS_T_TENCENT or Sns.SNS_T_SINA
  local szWnd = nSnsId == Sns.SNS_T_TENCENT and BTN_TENCENT or BTN_SINA
  self:CheckSingle(szWnd)
  self:GoToUrl(szUrl, nSnsId)
end

function uiSnsBrowser:OnButtonClick(szWnd, nParam)
  if szWnd == BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == BTN_TENCENT then
    self:GoToUrl(self.tbUrl[Sns.SNS_T_TENCENT], Sns.SNS_T_TENCENT)
  elseif szWnd == BTN_SINA then
    self:GoToUrl(self.tbUrl[Sns.SNS_T_SINA], Sns.SNS_T_SINA)
  elseif szWnd == BTN_TENCENT_TOPIC then
    self:GoToUrl("http://t.qq.com/k/%E5%89%91%E4%BE%A0%E4%B8%96%E7%95%8C")
  elseif szWnd == BTN_SINA_TOPIC then
    self:GoToUrl("http://t.sina.com.cn/k/%E5%89%91%E4%BE%A0%E4%B8%96%E7%95%8C")
  end
  if szWnd ~= BTN_CLOSE then
    self:CheckSingle(szWnd)
  end
end

function uiSnsBrowser:CheckSingle(szWndCheck)
  for n, szWnd in ipairs(tbCheckBox) do
    Btn_Check(self.UIGROUP, szWnd, 0)
  end
  Btn_Check(self.UIGROUP, szWndCheck, 1)
end

function uiSnsBrowser:GoToUrl(szUrl, nSnsId)
  IE_Navigate(self.UIGROUP, IE_WND, szUrl)
  if nSnsId then
    self.tbUrl[nSnsId] = szUrl
  end
end
