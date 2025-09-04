-----------------------------------------------------
-- 文件名　：awordonline_min.lua
-- 创建者　：jiazhenwei
-- 创建时间：2010-04-26 15:36:43
-- 描  述  ：在线领奖
------------------------------------------------------

local uiAwordOnline = Ui:GetClass("awordonline_min")
SpecialEvent.tbAwordOnline = SpecialEvent.tbAwordOnline or {}
local tbAwordOnline = SpecialEvent.tbAwordOnline

uiAwordOnline.BtnClose = "BtnClose"
uiAwordOnline.GetAword = "GetAword"
uiAwordOnline.InFormation = "infromation"
uiAwordOnline.Cancle = "Cancle"

function uiAwordOnline:OnOpen()
  local szMsg = ""
  if tbAwordOnline.nType <= 2 then
    szMsg = szMsg .. string.format("\n  欢迎来到《剑侠世界》,特为新手备下<color=green>%s份小礼物<color>，您将在倒计时结束后获得<color=green>第%s份<color>礼物。", #tbAwordOnline.tbAword, tbAwordOnline.nNum)
    Wnd_SetVisible(self.UIGROUP, self.GetAword, 0)
    Wnd_SetVisible(self.UIGROUP, self.Cancle, 1)
  else
    if tbAwordOnline.nNum < #tbAwordOnline.tbAword then
      szMsg = szMsg .. string.format("\n  恭喜您获得<color=green>第%s份神秘礼物<color>！领取后将进入下次领奖倒计时。", tbAwordOnline.nNum)
    else
      szMsg = szMsg .. string.format("\n  恭喜您获得<color=green>第%s份神秘礼物<color>！", tbAwordOnline.nNum)
    end
    Wnd_SetVisible(self.UIGROUP, self.GetAword, 1)
    Wnd_SetVisible(self.UIGROUP, self.Cancle, 0)
  end
  Txt_SetTxt(self.UIGROUP, self.InFormation, szMsg)
end

function uiAwordOnline:OnButtonClick(szWnd, nParam)
  if szWnd == self.GetAword then
    me.CallServerScript({ "AwordOnline" })
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.Cancle then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BtnClose then
    UiManager:CloseWindow(self.UIGROUP)
  end
end
