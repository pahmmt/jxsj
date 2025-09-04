-- 文件名　：collectphoneid.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-11-08 09:12:28
-- 功能说明：

local uiCollectPhoneId = Ui:GetClass("collectphoneid")
uiCollectPhoneId.Btn_Close = "Btn_Close"
uiCollectPhoneId.IE_URL = "IE_URL"

function uiCollectPhoneId:OnOpen(szUrl)
  if not szUrl then
    UiManager:CloseWindow(self.UIGROUP)
  end
  IE_Navigate(self.UIGROUP, self.IE_URL, szUrl)
end

function uiCollectPhoneId:OnButtonClick(szWnd, nParam)
  if szWnd == self.Btn_Close then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiCollectPhoneId:GetCurUrl()
  return IE_GetCurUrl(self.UIGROUP, self.IE_URL)
end
