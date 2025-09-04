-------------------------------------------------------------------
--File: kincreate.lua
--Author: zhengyuhua
--Date: 2007-9-11 16:23
--Describe: 	创建家族对话框界面脚本
-------------------------------------------------------------------

local uiKinCreate = Ui:GetClass("kincreate")

uiKinCreate.BUTTON_JUSTICE = "BtnJustice"
uiKinCreate.BUTTON_NEUTRALITY = "BtnNeutrality"
uiKinCreate.BUTTON_EVIL = "BtnEvil"
uiKinCreate.BUTTON_ACCEPT = "BtnAccept"
uiKinCreate.BUTTON_CANCEL = "BtnCancel"
uiKinCreate.TXT_KIN_NAME = "TxtKinName"
uiKinCreate.TXT_TITLE = "TxtTitle"
uiKinCreate.EDIT_KIN_NAME = "EdtKinName"

function uiKinCreate:Init()
  self.nCamp = Kin.CAMP_NEUTRALITY
end

function uiKinCreate:OnOpen(bTong)
  self.bTong = bTong
  if self.bTong and self.bTong == 1 then
    Txt_SetTxt(self.UIGROUP, self.TXT_KIN_NAME, "帮会名称")
    Txt_SetTxt(self.UIGROUP, self.TXT_TITLE, "创建帮会")
  else
    Txt_SetTxt(self.UIGROUP, self.TXT_KIN_NAME, "家族名称")
    Txt_SetTxt(self.UIGROUP, self.TXT_TITLE, "创建家族")
  end
  Btn_Check(self.UIGROUP, self.BUTTON_JUSTICE, 0)
  Btn_Check(self.UIGROUP, self.BUTTON_NEUTRALITY, 1) --默认选择中立
  Btn_Check(self.UIGROUP, self.BUTTON_EVIL, 0)
  self.nCamp = Kin.CAMP_NEUTRALITY
end

function uiKinCreate:OnButtonClick(szWnd, nParam)
  if szWnd == self.BUTTON_JUSTICE then
    Btn_Check(self.UIGROUP, self.BUTTON_JUSTICE, 1)
    Btn_Check(self.UIGROUP, self.BUTTON_NEUTRALITY, 0)
    Btn_Check(self.UIGROUP, self.BUTTON_EVIL, 0)
    self.nCamp = Kin.CAMP_JUSTICE
  elseif szWnd == self.BUTTON_NEUTRALITY then
    Btn_Check(self.UIGROUP, self.BUTTON_JUSTICE, 0)
    Btn_Check(self.UIGROUP, self.BUTTON_NEUTRALITY, 1)
    Btn_Check(self.UIGROUP, self.BUTTON_EVIL, 0)
    self.nCamp = Kin.CAMP_NEUTRALITY
  elseif szWnd == self.BUTTON_EVIL then
    Btn_Check(self.UIGROUP, self.BUTTON_JUSTICE, 0)
    Btn_Check(self.UIGROUP, self.BUTTON_NEUTRALITY, 0)
    Btn_Check(self.UIGROUP, self.BUTTON_EVIL, 1)
    self.nCamp = Kin.CAMP_EVIL
  elseif szWnd == self.BUTTON_ACCEPT then
    local szName = Edt_GetTxt(self.UIGROUP, self.EDIT_KIN_NAME)
    local nRetCode
    if self.bTong and self.bTong == 1 then
      nRetCode = Tong:CreateTong_C(szName, self.nCamp)
    else
      nRetCode = Kin:CreateKin_C(szName, self.nCamp)
    end
    if nRetCode == 1 then
      UiManager:CloseWindow(self.UIGROUP)
    end
  elseif szWnd == self.BUTTON_CANCEL then
    UiManager:CloseWindow(self.UIGROUP)
  end
end
