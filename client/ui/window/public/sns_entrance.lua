-----------------------------------------------------
--文件名		：	sns_entrance.lua
--创建者		：	wangzhiguang
--创建时间		：	2011-03-18
--功能描述		：	SNS功能入口（聊天栏旁边的小按钮）
------------------------------------------------------

local uiSnsEntrance = Ui:GetClass("sns_entrance") -- 这样写支持重载

uiSnsEntrance.BUTTON_OPEN_MAIN = "BtnOpenMain"
uiSnsEntrance.nPopUpTipId = 122

function uiSnsEntrance:OnOpen()
  if Sns.bIsOpen == 0 then
    return
  end

  Wnd_SetTip(self.UIGROUP, self.BUTTON_OPEN_MAIN, "社交网络")
end

function uiSnsEntrance:ShowPopupTip(szMessage)
  if type(szMessage) ~= "string" or string.len(szMessage) == 0 then
    szMessage = nil
  end
  Ui.tbLogic.tbPopMgr:ShowPopTip(self.nPopUpTipId, szMessage)
end

--闪烁入口图标
function uiSnsEntrance:Blink(nSecond)
  Img_PlayAnimation(self.UIGROUP, self.BUTTON_OPEN_MAIN, 1, 200, 0, 1)
  local function StopAnimation()
    Img_StopAnimation(self.UIGROUP, self.BUTTON_OPEN_MAIN)
    return 0
  end
  Ui.tbLogic.tbTimer:Register(18 * nSecond, StopAnimation)
end

--设置下次打开主界面时的tweet内容
function uiSnsEntrance:SetNextTweet(szTweet)
  self.szTweet = szTweet
end

function uiSnsEntrance:OnButtonClick(szWnd, nParam)
  if szWnd == self.BUTTON_OPEN_MAIN then
    self:OpenSNSmain()
  end
end

function uiSnsEntrance:OpenSNSmain()
  if Sns.bIsOpen == 0 then
    return
  end

  --开关逻辑
  if UiManager:WindowVisible(Ui.UI_SNS_MAIN) == 1 then
    UiManager:CloseWindow(Ui.UI_SNS_MAIN)
    return
  elseif UiManager:WindowVisible(Ui.UI_SNS_AUTH_GUIDE1) == 1 then
    UiManager:CloseWindow(Ui.UI_SNS_AUTH_GUIDE1)
    return
  end

  local szTweet = self.szTweet
  if szTweet then
    self.szTweet = nil
  end

  for nId, tbSns in ipairs(Sns.tbSns) do
    local szTokenKey = tbSns:GetTokenKey()
    if #szTokenKey > 0 then
      UiManager:OpenWindow(Ui.UI_SNS_MAIN, szTweet)
      return
    end
  end
  UiManager:OpenWindow(Ui.UI_SNS_AUTH_GUIDE1, szTweet)
end
