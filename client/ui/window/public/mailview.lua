-----------------------------------------------------
--文件名		：	mailview.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-06-02
--功能描述		：	信件界面脚本。
------------------------------------------------------

local uiMailView = Ui:GetClass("mailview")
local tbObject = Ui.tbLogic.tbObject

uiMailView.CLOSE_WINDOW_BUTTON = "BtnClose"
uiMailView.DELETE_MAIL_BUTTON = "BtnDelMail"
uiMailView.WRITE_BACK_BUTTON = "BtnWriteBack"
uiMailView.FETCH_MONEY_BUTTON = "BtnFetchMoney"

uiMailView.MAIL_NOTICE_TEXT = "TxtNotice"
uiMailView.MAIL_TITLE_TEXT = "TxtMailTitle"
uiMailView.MAIL_FROM_TEXT = "TxtFrom"
uiMailView.MAIL_CONTENT_TEXT = "TxtContent"
uiMailView.MAIL_CONTENT_TEXTEX = "TxxContent"
uiMailView.MAIL_CONTENT_IMAGE = "ImgContent"
uiMailView.MAIL_MONEY_TEXT = "TxtMailMoney"
uiMailView.MAIL_ITEM_OBJECT = "ObjItem"

-----------------------------------------------------------
-- tbMail表参数：
--	nMailId,			[1]
--	nPicId,				[2]
--	szContent,			[3]
--	nMoney,				[4]
--  nItemCount,			[5]
--	nItemIdx			[6]

function uiMailView:Init()
  self.szSender = ""
  self.szTitle = ""
  self.nMoney = 0
  self.ItemIndex = 0
  self.nMailType = 0
end

local tbMailViewCont = { bShowCd = 0, bUse = 0 }

function tbMailViewCont:CheckMouse(tbMouseObj)
  return 0
end

function tbMailViewCont:ClickMouse(tbObj, nX, nY)
  if tbObj.nType ~= Ui.OBJ_ITEM then
    return 0
  end
  if not self.nMailId then
    return 0
  end
  if me.CalcFreeSameItemCountInBags(tbObj.pItem) > 0 then
    --向服务器发送获取附件的请求	两个参数分别表示信件ID，第几个附件，目前只有一个附件，就用0表示
    me.CallServerScript({ "MailCmd", "ApplyProcess", self.nMailId, 0 })
  else
    me.Msg("您的背包已满！")
  end
  return 0
end

function uiMailView:OnCreate()
  self.tbMailViewCont = tbObject:RegisterContainer(self.UIGROUP, self.MAIL_ITEM_OBJECT, 1, 1, tbMailViewCont)
end

function uiMailView:OnDestroy()
  tbObject:UnregContainer(self.tbMailViewCont)
end

function uiMailView:WriteStatLog()
  Log:Ui_SendLog("查看邮件", 1)
end

function uiMailView:OnOpen()
  self:WriteStatLog()

  local tbTempTable = me.GetTempTable("Mail")
  local tbMail = tbTempTable.tbMailContent
  local tbMailInfo = tbTempTable.tbMailListID[tbMail.nMailId]

  self.nMailType = tbMailInfo.nType
  self:OnFetchItemOK()
  self:OnFetchMoneyOK()

  if tbMailInfo then
    Txt_SetTxt(self.UIGROUP, self.MAIL_TITLE_TEXT, "信件标题：" .. tbMailInfo.szCaption)
    local szSender = tbMail.szContent
    if szSender then
      local nA1, nB1 = string.find(szSender, "<Sender>")
      if nA1 and nB1 then
        szSender = string.sub(szSender, nB1 + 1)
        local nA2, nB2 = string.find(szSender, "<Sender>")
        if nA2 and nB2 then
          if ((nB1 - nA1) == 7) and ((nB2 - nA2) == 7) then
            tbMailInfo.szSender = string.sub(szSender, 1, nA2 - 1)
            tbMail.szContent = string.sub(szSender, nB2 + 1)
          end
        end
      end
    end

    if self.nMailType ~= 1 then -- 系统信件
      Wnd_Hide(self.UIGROUP, self.MAIL_NOTICE_TEXT)
      Wnd_Show(self.UIGROUP, self.MAIL_CONTENT_IMAGE)
      Txt_SetTxt(self.UIGROUP, self.MAIL_FROM_TEXT, string.format("发信人：<color=red>%s<color>", tbMailInfo.szSender))
      Txt_SetTxt(self.UIGROUP, self.MAIL_CONTENT_TEXT, "")
      if tbMailInfo.szSender == "系统" and tbMailInfo.szCaption == "拍卖行" then --成交时间跟邮件时间一样
        local szTime = string.format("\n\n<color=yellow>拍卖成交时间：%s<color>", os.date("%Y-%m-%d %H:%M:%S", tbMailInfo.nSendTime))
        TxtEx_SetText(self.UIGROUP, self.MAIL_CONTENT_TEXTEX, tbMail.szContent .. szTime)
      else
        TxtEx_SetText(self.UIGROUP, self.MAIL_CONTENT_TEXTEX, tbMail.szContent)
      end
    else
      Wnd_Show(self.UIGROUP, self.MAIL_NOTICE_TEXT)
      Wnd_Hide(self.UIGROUP, self.MAIL_CONTENT_IMAGE)
      Txt_SetTxt(self.UIGROUP, self.MAIL_FROM_TEXT, "发信人：" .. tbMailInfo.szSender)
      if tbMailInfo.szSender == "系统" and tbMailInfo.szCaption == "拍卖行" then --成交时间跟邮件时间一样
        local szTime = string.format("\n\n<color=yellow>拍卖成交时间：%s<color>", os.date("%Y-%m-%d %H:%M:%S", tbMailInfo.nSendTime))
        Txt_SetTxt(self.UIGROUP, self.MAIL_CONTENT_TEXT, tbMail.szContent .. szTime)
      else
        Txt_SetTxt(self.UIGROUP, self.MAIL_CONTENT_TEXT, tbMail.szContent)
      end
      TxtEx_SetText(self.UIGROUP, self.MAIL_CONTENT_TEXTEX, "")
    end

    self.tbMailViewCont.nMailId = tbMail.nMailId
    self.szTitle = tbMailInfo.szCaption
    self.szSender = tbMailInfo.szSender
    self.nMoney = tbMail.nMoney
    self.ItemIndex = tbMail.nItemIdx

    --[[
		local szImg = self:GetMailImage(tbMail.nPicId);
		Img_SetImage(self.UIGROUP, self.MAIL_CONTENT_IMAGE, 1, szImg);
		local _, nImgHeight = Wnd_GetSize(self.UIGROUP, self.MAIL_CONTENT_IMAGE);
		if nImgHeight then
			Wnd_SetPos(self.UIGROUP, self.MAIL_CONTENT_TEXT, 10, nImgHeight + 10);
			Wnd_SetPos(self.UIGROUP, self.MAIL_CONTENT_TEXTEX, 10, nImgHeight + 10);
		end
		--]]
    if tbMail.nItemCount > 0 then
      local pItem = KItem.GetItemObj(tbMail.nItemIdx)
      local tbObj = nil
      if pItem then
        tbObj = {}
        tbObj.nType = Ui.OBJ_ITEM
        tbObj.pItem = pItem
      end
      self.tbMailViewCont:SetObj(tbObj)
    end

    Wnd_SetEnable(self.UIGROUP, self.FETCH_MONEY_BUTTON, self.nMoney)
    Txt_SetTxt(self.UIGROUP, self.MAIL_MONEY_TEXT, Item:FormatMoney(self.nMoney))
  end
end

function uiMailView:OnClose()
  self.tbMailViewCont:ClearObj()
  Ui(Ui.UI_MAIL):RefreshMailList(Mail.MAILCONDTYPE) -- 刷新信件
end

function uiMailView:OnButtonClick(szWnd, nParam)
  if Mail.IsManuUse == 0 then
    return 0
  end
  if szWnd == self.CLOSE_WINDOW_BUTTON then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.DELETE_MAIL_BUTTON then
    if self.tbMailViewCont then
      local tbObj = self.tbMailViewCont:GetObj()
      local szMoney = Txt_GetTxt(self.UIGROUP, self.MAIL_MONEY_TEXT) -- TODO: xyf 最好别依赖控件数据而是读CORE数据
      if tbObj or (tonumber(szMoney) ~= 0) then
        me.Msg("信件不能删除，信件中含有银两或附件！")
        return
      end

      local tbMsg = {}
      tbMsg.szMsg = "邮件一旦删除就不能再恢复，是否确定？"
      tbMsg.nOptCount = 2
      function tbMsg:Callback(nOptIndex, nMailId)
        if nOptIndex == 2 then
          Ui(Ui.UI_MAIL):DeleteMail(nMailId)
          UiManager:CloseWindow(Ui.UI_MAILVIEW)
        end
      end
      UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, self.tbMailViewCont.nMailId)
    end
  elseif szWnd == self.WRITE_BACK_BUTTON then
    if self.nMailType ~= 1 then
      me.Msg("系统信件不能回复！")
      return
    end

    local tbParam = {}
    tbParam.szTitle = "『回复』" .. self.szTitle
    tbParam.szSender = self.szSender
    if Mail:RequestOpenNewMail(tbParam) ~= 1 then
      return
    end
    UiManager:OpenWindow(Ui.UI_MAILNEW, { "『回复』" .. self.szTitle, self.szSender })
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.FETCH_MONEY_BUTTON then
    if self.tbMailViewCont and (self.tbMailViewCont.nMailId > 0) then
      if self.nMoney + me.nCashMoney <= me.GetMaxCarryMoney() then
        me.MailFetchMoney(self.tbMailViewCont.nMailId)
        Wnd_SetEnable(self.UIGROUP, self.FETCH_MONEY_BUTTON, 0)
      else
        me.Msg("您携带的银两已达到上限！")
      end
    end
  end
end

function uiMailView:GetMailImage(nId)
  if nId > 0 then
    return KIo.GetPictureById(nId)
  else
    return ""
  end
end

function uiMailView:OnFetchItemOK()
  self.tbMailViewCont:ClearObj()
end

function uiMailView:OnFetchMoneyOK()
  Txt_SetTxt(self.UIGROUP, self.MAIL_MONEY_TEXT, Item:FormatMoney(0))
end

function uiMailView:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_MAIL_FETCHITEMOK, self.OnFetchItemOK },
    { UiNotify.emCOREEVENT_MAIL_FETCHMONEYOK, self.OnFetchMoneyOK },
  }
  tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbMailViewCont:RegisterEvent())
  return tbRegEvent
end

function uiMailView:RegisterMessage()
  local tbRegMsg = self.tbMailViewCont:RegisterMessage()
  return tbRegMsg
end
