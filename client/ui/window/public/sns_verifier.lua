-----------------------------------------------------
--文件名		：	sns_verifier.lua
--创建者		：	wangzhiguang
--创建时间		：
--功能描述		：	oauth_verifier输入面板，现在用来引导玩家开始授权流程
------------------------------------------------------

local uiSnsVerifier = Ui:GetClass("sns_verifier")

uiSnsVerifier.TXT_DESC = "TxtDesc"
uiSnsVerifier.TXT_DESC2 = "TxtDesc2"
uiSnsVerifier.BUTTON_CLOSE = "BtnClose"
uiSnsVerifier.BUTTON_CANCEL = "BtnCancel"
uiSnsVerifier.BUTTON_AUTH = "BtnAuth"

uiSnsVerifier.DESC_MESSAGE = [[点击“关联授权”按钮后将会打开<color=yellow>%s<color>的官方网站。在网页上<color=red>登录/注册<color>微博帐号后进行授权。]]
uiSnsVerifier.DESC_MESSAGE2 = [[<color=yellow>备注：<color>您在<color=yellow>%s<color>的登录/注册操作是全程在其官方网站进行的，游戏中不需要您提供账号密码。]]

function uiSnsVerifier:OnOpen(nSnsId)
  self.tbSns = Sns:GetSnsObject(nSnsId)
  local szMsg = string.format(self.DESC_MESSAGE, self.tbSns.szName)
  Txt_SetTxt(self.UIGROUP, self.TXT_DESC, szMsg)
  local szMsg2 = string.format(self.DESC_MESSAGE2, self.tbSns.szName)
  Txt_SetTxt(self.UIGROUP, self.TXT_DESC2, szMsg2)
end

function uiSnsVerifier:OnButtonClick(szWnd, nParam)
  if szWnd == self.BUTTON_AUTH then
    self:BeginAuth()
  elseif szWnd == self.BUTTON_CANCEL or szWnd == self.BUTTON_CLOSE then
    self:Close()
  end
end

function uiSnsVerifier:BeginAuth()
  self.nAuthJobId = Sns:BeginAuthorization(self.tbSns.nId)
end

function uiSnsVerifier:Close(bSuccess)
  UiManager:CloseWindow(self.UIGROUP)
  if bSuccess == 1 then
    UiManager:OpenWindow(Ui.UI_SNS_FOLLOW, self.tbSns.nId)
  else
    UiManager:OpenWindow(Ui.UI_SNS_MAIN)
  end
end
