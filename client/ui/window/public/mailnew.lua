-----------------------------------------------------
--文件名		：	mailnew.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-06-02
--功能描述		：	信件界面脚本。
------------------------------------------------------

local uiMailNew = Ui:GetClass("mailnew")
local tbObject = Ui.tbLogic.tbObject
local tbMouse = Ui.tbLogic.tbMouse
local tbMsgInfo = Ui.tbLogic.tbMsgInfo

uiMailNew.CLOSE_WINDOW_BUTTON = "BtnClose"
uiMailNew.SEND_MAIL_BUTTON = "BtnSendMail"
uiMailNew.SELECT_MAIL_RECEIVER = "BtnSelectTo"
uiMailNew.MAIL_TITLE_EDIT = "EdtMailTitle"
uiMailNew.MAIL_TO_EDIT = "EdtTo"
uiMailNew.MAIL_CONTENT_EDIT = "EdtContent"
uiMailNew.MAIL_MONEY_EDIT = "EdtMoney"
uiMailNew.MAIL_ITEM_OBJECT = "ObjItem"
uiMailNew.MAIL_SEND_COST = "TxtSendCost"

function uiMailNew:Init()
  self.nMoney = 0
  self.tbObj = nil
  self.tbExitObj = nil
end

local tbMailCont = { bShowCd = 0, bUse = 0, bLink = 0, nRoom = Item.ROOM_MAIL } -- 不显示CD特效，不可使用，不可链接

function tbMailCont:CheckSwitchItem(pDrop, pPick, nX, nY)
  if not pDrop then
    return 1
  end
  if pDrop.IsForbitTrade() == 1 then
    me.Msg("物品属于不能交易物品，不能作为信件附件！")
    tbMouse:ResetObj()
    return 0
  end
  return 1
end

function uiMailNew:OnCreate()
  self.tbMailCont = tbObject:RegisterContainer(self.UIGROUP, self.MAIL_ITEM_OBJECT, 1, 1, tbMailCont, "itemroom")
end

function uiMailNew:OnDestroy()
  tbObject:UnregContainer(self.tbMailCont)
end

function uiMailNew:OnClose()
  self.tbMailCont:ClearRoom()
  UiManager:ReleaseUiState(UiManager.UIS_MAIL_NEW)
end

function uiMailNew:OnOpen(tbParam)
  UiManager:SetUiState(UiManager.UIS_MAIL_NEW)

  Edt_SetTxt(self.UIGROUP, self.MAIL_CONTENT_EDIT, "")
  Edt_SetTxt(self.UIGROUP, self.MAIL_TO_EDIT, "")
  Edt_SetTxt(self.UIGROUP, self.MAIL_TITLE_EDIT, "")
  Edt_SetInt(self.UIGROUP, self.MAIL_MONEY_EDIT, 0)
  Wnd_SetFocus(self.UIGROUP, self.MAIL_TITLE_EDIT)

  if tbParam and tbParam.szSender then
    Edt_SetTxt(self.UIGROUP, self.MAIL_TITLE_EDIT, tbParam.szTitle)
    Edt_SetTxt(self.UIGROUP, self.MAIL_TO_EDIT, tbParam.szSender)
  end
  local nCost = me.GetMailCost()
  Txt_SetTxt(self.UIGROUP, self.MAIL_SEND_COST, Item:FormatMoney(nCost) .. "银两")
  if UiVersion == Ui.Version001 then
    Txt_SetTxt(self.UIGROUP, self.MAIL_SEND_COST, "发送资费：" .. Item:FormatMoney(nCost) .. "银两")
  end
end

function uiMailNew:OnMailItemChangedCallback(nAction, uGenre, uId)
  if nAction > 0 then
    ObjBox_HoldObject(self.UIGROUP, self.MAIL_ITEM_OBJECT, uGenre, uId)
  else
    self.tbMailCont:SetObj(nil)
  end
end

function uiMailNew:OnButtonClick(szWnd, nParam)
  if szWnd == self.CLOSE_WINDOW_BUTTON then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.SELECT_MAIL_RECEIVER then
    UiManager:OpenWindow(Ui.UI_RELATIONNEW)
  elseif szWnd == self.SEND_MAIL_BUTTON then
    if Mail.nMailCount >= 20 then
      me.Msg("发送失败！你信箱中的信件超过20封，请尽快清除！")
      return
    end

    local nMoney = Edt_GetInt(self.UIGROUP, self.MAIL_MONEY_EDIT)
    local tbAttachment = self.tbMailCont:GetObj()

    local tbMsg = {}
    if nMoney > 0 or tbAttachment ~= nil then
      tbMsg.szMsg = "    <color=white>请再次确认发送的接收人、银两数额和物品。<color><enter><color=green>邮箱没有寄存等系统交易功能，谨防受骗！<color>"
    else
      tbMsg.szMsg = "您确定发送这封邮件吗？"
    end
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex, fnAccept, tbSelf)
      if nOptIndex == 1 then
        return
      elseif nOptIndex == 2 then
        fnAccept(tbSelf)
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, self.SendMail, self)
  end
end

function uiMailNew:SendMail()
  local szTitle = Edt_GetTxt(self.UIGROUP, self.MAIL_TITLE_EDIT)
  local szTo = Edt_GetTxt(self.UIGROUP, self.MAIL_TO_EDIT)
  local szContent = Edt_GetTxt(self.UIGROUP, self.MAIL_CONTENT_EDIT)
  local nMoney = Edt_GetInt(self.UIGROUP, self.MAIL_MONEY_EDIT)

  if szTo and szTo == "" then
    me.Msg("未填写收信人。")
    return
  end

  local bRet = me.HasRelation(szTo, 2)
  if bRet ~= 1 then
    me.Msg("对方不是你的正式好友，不能发送信件！")
    return
  end
  if me.nCashMoney < nMoney + me.GetMailCost() then
    me.Msg("邮资不够，发送失败！")
    return
  end
  if #szTitle > 0 and #szTo > 0 and #szContent > 0 then
    local nRetCode = 0
    if me.SendMail(szTo, szTitle, szContent, 0, nMoney) == 1 then
      UiManager:CloseWindow(self.UIGROUP)
    else
      me.Msg("信件填写不正确，发送失败！")
    end
  else
    me.Msg("请将信件写完整！")
  end
end

function uiMailNew:OnEditChange(szWnd, nParam)
  if szWnd == self.MAIL_MONEY_EDIT then
    local nNum = Edt_GetInt(self.UIGROUP, self.MAIL_MONEY_EDIT)
    if nNum == self.nMoney then -- 防止死循环
      return
    end
    if nNum < 0 then
      nNum = 0
    elseif nNum > me.nCashMoney then
      nNum = me.nCashMoney
    end
    self.nMoney = nNum
    Edt_SetInt(self.UIGROUP, self.MAIL_MONEY_EDIT, nNum)
  end
end

function uiMailNew:SetReceiver(szPlayer)
  Edt_SetTxt(self.UIGROUP, self.MAIL_TO_EDIT, szPlayer)
end

function uiMailNew:RegisterEvent()
  return self.tbMailCont:RegisterEvent()
end

function uiMailNew:RegisterMessage()
  return self.tbMailCont:RegisterMessage()
end
