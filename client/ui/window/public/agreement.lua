local tbAgreement = Ui:GetClass("agreement")
local tbAgreementMgr = Ui.tbLogic.tbAgreementMgr

local TXT_AGREEMENT = "TxtAgreement"
local BTN_AGREE = "BtnAgree"
local BTN_CANCEL = "BtnCancel"
local SCROLLPANEL = "AgreementScrollPanel"
local AGREEMENTFILE = "\\setting\\misc\\agreement.txt"

function tbAgreement:Init()
  self.szAgreeData = ""
end

function tbAgreement:OnOpen(szAgreeData)
  local szTxtContent = KIo.ReadTxtFile(AGREEMENTFILE)
  self.szAgreeData = szTxtContent
  TxtEx_SetText(self.UIGROUP, TXT_AGREEMENT, self.szAgreeData)

  if IVER_g_nTwVersion == 1 then
    if not UiManager.bAgreementFlag or UiManager.bAgreementFlag == 0 then
      Wnd_SetEnable(self.UIGROUP, BTN_AGREE, 0)
      Btn_Check(self.UIGROUP, BTN_AGREE, 0)
    end
  end
end

function tbAgreement:OnButtonClick(szWnd, nParam)
  if szWnd == BTN_AGREE then
    tbAgreementMgr:SetAgree(1)
    UiManager:CloseWindow(self.UIGROUP)
    --SetStatAgree(1);
    --UiManager:OpenWindow(Ui.UI_LOGINBG, 2);
    --OpenSelSrv();
    UiManager.bAgreementFlag = 1
    SetLoginStatus(Ui.tbLogic.tbLogin.emLOGINSTATUS_IDLE)
  elseif szWnd == BTN_CANCEL then
    --SetActiveState(Ui.ACTIVE_STATE_DEAD);
    UiManager:CloseWindow(self.UIGROUP)
    UiManager.bAgreementFlag = 0
    SetLoginStatus(Ui.tbLogic.tbLogin.emLOGINSTATUS_DEAD)
  end
end

function tbAgreement:OnScorllPanelSlideMaxPos(szWnd, nParam)
  if IVER_g_nTwVersion == 1 then
    if szWnd == SCROLLPANEL then
      if 1 == nParam then
        Wnd_SetEnable(self.UIGROUP, BTN_AGREE, 1)
      else
        Wnd_SetEnable(self.UIGROUP, BTN_AGREE, 0)
      end
    end
  end
end
