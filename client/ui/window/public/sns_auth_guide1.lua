-----------------------------------------------------
--文件名		：	sns_auth_guide1.lua
--创建者		：	wangzhiguang
--创建时间		：
--功能描述		：	对未关联SNS的用户进行引导
------------------------------------------------------

local uiSnsAuthGuide1 = Ui:GetClass("sns_auth_guide1")

local BUTTON_CLOSE = "BtnClose"
local BUTTON_OK = "BtnOK"

function uiSnsAuthGuide1:OnOpen(szTweet)
  self.szTweet = szTweet
end

function uiSnsAuthGuide1:OnButtonClick(szWnd, nParam)
  if szWnd == BUTTON_OK then
    self:Close()
  elseif szWnd == BUTTON_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiSnsAuthGuide1:Close()
  local szTweet = self.szTweet
  self.szTweet = nil
  UiManager:CloseWindow(self.UIGROUP)
  UiManager:OpenWindow(Ui.UI_SNS_MAIN, szTweet)
end
