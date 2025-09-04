-----------------------------------------------------
--文件名		：	groupmailnew.lua
--创建者		：	ZouYing@kingsoft.net
--创建时间		：	2007-12-06
--功能描述		：	群发信件界面脚本。
------------------------------------------------------

local uiGroupMailNew = Ui:GetClass("groupmailnew")

uiGroupMailNew.CLOSE_WINDOW_BUTTON = "BtnClose"
uiGroupMailNew.SEND_MAIL_BUTTON = "BtnSendMail"
uiGroupMailNew.MAIL_TITLE_EDIT = "EdtMailTitle"
uiGroupMailNew.MAIL_TO_EDIT = "EdtTo"
uiGroupMailNew.MAIL_CONTENT_EDIT = "EdtContent"
uiGroupMailNew.MAIL_SEND_COST = "TxtSendCost"
uiGroupMailNew.MAIL_ITEM_OBJECT = "ObjItem"
uiGroupMailNew.MAIL_EDT_MONEY = "EdtMoney"

function uiGroupMailNew:Init()
  self.nMailCost = 0
  self.nParam = 0
  self.tbParam = nil
end

function uiGroupMailNew:OnOpen(tbParam)
  assert(tbParam)
  Edt_SetTxt(self.UIGROUP, self.MAIL_CONTENT_EDIT, "")
  Edt_SetTxt(self.UIGROUP, self.MAIL_TITLE_EDIT, "")
  Wnd_SetFocus(self.UIGROUP, self.MAIL_TITLE_EDIT)
  ObjBox_Clear(self.UIGROUP, self.MAIL_ITEM_OBJECT)
  Edt_SetInt(self.UIGROUP, self.MAIL_EDT_MONEY, 0)

  self.tbParam = tbParam
  if tbParam then
    Edt_SetTxt(self.UIGROUP, self.MAIL_TO_EDIT, tbParam.szReceive)
  end
  local nCost = me.GetMailCost()
  if tbParam.nCountNumber then
    nCost = nCost * tbParam.nCountNumber
    self.nMailCost = nCost
  end
  Txt_SetTxt(self.UIGROUP, self.MAIL_SEND_COST, "发送资费：" .. Item:FormatMoney(nCost))
end

-- 交换容器与鼠标上的物品
function uiGroupMailNew:OnObjSwitch(szWnd, uGenre, uId, nX, nY)
  me.Msg("群发信件不可带附件！")
  return
end

function uiGroupMailNew:OnButtonClick(szWnd, nParam)
  if szWnd == self.CLOSE_WINDOW_BUTTON then
    UiManager:CloseWindow(Ui.UI_GROUPMAILNEW)
    return
  elseif szWnd == self.SEND_MAIL_BUTTON then
    if Mail.nMailCount >= 20 then
      me.Msg("发送失败！你信箱中的信件超过20封，请尽快清除！")
      return
    end
    self:SendMail()
  end
end

function uiGroupMailNew:OnEditChange(szWnd, nParam)
  if szWnd == self.MAIL_EDT_MONEY then
    local nMoney = Edt_GetInt(self.UIGROUP, self.MAIL_EDT_MONEY)
    if nMoney == 0 then
      return
    end
    Edt_SetInt(self.UIGROUP, self.MAIL_EDT_MONEY, 0)
    me.Msg("群发信件不能发送银两！")
  end
end

function uiGroupMailNew:SendMail()
  local szTitle = Edt_GetTxt(self.UIGROUP, self.MAIL_TITLE_EDIT)
  local szContent = Edt_GetTxt(self.UIGROUP, self.MAIL_CONTENT_EDIT)
  local szTo = Edt_GetTxt(self.UIGROUP, self.MAIL_TO_EDIT)

  if self.tbParam.szMailType == "Kin" then
    if me.nCashMoney < self.nMailCost then
      me.Msg("邮资不够，发送失败！")
      return
    end
  elseif self.tbParam.szMailType == "Tong" then
    local pTong = KTong.GetSelfTong()
    if pTong == nil then
      me.Msg("无帮会！")
      return
    end
    local nMoney = pTong.GetMoneyFund()
    if nMoney < self.nMailCost then
      me.Msg("帮费不够，发送失败！")
      return
    end
  else
    me.Msg("发送失败！")
    return
  end
  if self.tbParam.nCountNumber <= 0 then
    me.Msg("您在对自己发邮件或收件人数为0，发送失败！")
    return
  end
  if #szTitle > 0 and #szTo > 0 and #szContent > 0 and self.tbParam.nItemId and self.tbParam.nItemId > 0 then
    local nRetCode = 0
    if self.tbParam.szMailType == "Kin" then
      nRetCode = me.SendKinGroupMail(self.tbParam.nGroupId, self.tbParam.nGroupType, self.tbParam.nItemId, szTitle, szContent, 0)
    elseif self.tbParam.szMailType == "Tong" and self.tbParam.nGroupId then
      if self.tbParam.nGroupId ~= 0 then
        nRetCode = me.SendTongGroupMail(1, self.tbParam.nGroupId, szTitle, szContent, 0)
      else
        local nReceiveId = self.tbParam.nItemId
        if nReceiveId > 3 and nReceiveId <= 0 then
          ms.Msg("选择的收件人不正确！")
          return
        end
        nRetCode = me.SendTongGroupMail(0, nReceiveId, szTitle, szContent, 0)
      end
    end
    if nRetCode == 1 then
      UiManager:CloseWindow(Ui.UI_GROUPMAILNEW)
    else
      me.Msg("信件填写不正确，发送失败！")
    end
  else
    me.Msg("请将信件写完整！")
  end
end
