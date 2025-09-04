-----------------------------------------------------
--Tên tệp		：	mail.lua
--Người tạo		：	zouying@kingsoft.net
--Thời gian tạo		：	2007-10-17
--Mô tả chức năng		：	Script hệ thống thư.
------------------------------------------------------

Mail.nMailCount = 0

Mail.MAILCONDTYPE = 0
Mail.MAILOTHERTYPE = 1
Mail.IsManuUse = 1

function Mail:SwitchWindow()
  if UiManager:WindowVisible(Ui.UI_MAIL) ~= 0 then
    UiManager:CloseWindow(Ui.UI_MAIL)
    return
  end
  -- Chống nhấp liên tục
  if self.nLastOpenTime == os.clock() then
    return
  end
  self.nLastOpenTime = os.clock()

  me.CallServerScript({ "MailCmd", "ApplyOpen" })
end

function Mail:OnAcceptOpen(nAccept)
  if nAccept ~= 1 then
    me.Msg("Bản đồ hiện tại không cho phép mở hòm thư!")
    UiManager:CloseWindow(Ui.UI_MAIL) -- Đóng giao diện hòm thư
  else
    UiManager:OpenWindow(Ui.UI_MAIL)
  end
end

function Mail:RequestMailList(nMailType)
  me.RequestMailList(nMailType)
end

function Mail:FilterInfo(szMsg)
  if szMsg then
    szMsg = string.gsub(szMsg, "<bclr=[^>]*>", "")
    szMsg = string.gsub(szMsg, "<color=[^>]*>", "")
  end
  return szMsg
end

function Mail:SyncMailList(tbMailList)
  local tbTempData = me.GetTempTable("Mail")
  tbTempData.tbMailList = {}
  tbTempData.tbMailListID = {}

  self:Init()
  local tbClientMail, nClientMailCount = self:ReadClientMail()
  if tbClientMail and 0 ~= nClientMailCount then
    for i = 1, nClientMailCount do
      tbClientMail[i].byClient = 1
      table.insert(tbTempData.tbMailList, tbClientMail[i])
      -- tbTempData.tbMailList[i].byClient = 1;
      tbTempData.tbMailListID[tbClientMail[i].nId] = tbClientMail[i]
    end
  end

  for i = 1, #tbMailList do
    if tbMailList[i].nType == 1 then
      tbMailList[i].szCaption = self:FilterInfo(tbMailList[i].szCaption)
    end

    tbMailList[i].byClient = 0
    table.insert(tbTempData.tbMailList, tbMailList[i])
    -- tbTempData.tbMailList[i + nClientMailCount].byClient = 0;
    tbTempData.tbMailListID[tbMailList[i].nId] = tbMailList[i]
  end
  self.nMailCount = Lib:CountTB(tbTempData.tbMailList)
  CoreEventNotify(UiNotify.emCOREEVENT_SYNC_MAIL_LIST)
end

function Mail:AddMailContent(tbMailContent)
  local tbTempData = me.GetTempTable("Mail")
  tbTempData.tbMailContent = tbMailContent
  if Mail.IsManuUse == 0 then
    return 0
  end
  UiManager:OpenWindow(Ui.UI_MAILVIEW)
  CoreEventNotify(UiNotify.emCOREEVENT_SHOW_MAILCONTENT)
end

function Mail:RequestOpenNewMail(tbParam)
  if me.IsAccountLock() ~= 0 then
    me.Msg("Tài khoản đang bị khóa, không thể gửi thư!")
    Account:OpenLockWindow(me)
    return 0
  end
  self.tbParam = tbParam
  me.CallServerScript({ "MailCmd", "ApplyOpenNewMail" })
  return 1
end

function Mail:OnAcceptOpenNewMail()
  if self.tbParam then
    UiManager:OpenWindow(Ui.UI_MAILNEW, self.tbParam)
  else
    UiManager:OpenWindow(Ui.UI_MAILNEW)
  end
end

--	emKMAIL_ERR_BOXFULL = 1,			// Hòm thư đã đầy
--	emKMAIL_ERR_RECEIVER,				// Người nhận sai, người nhận không đúng hoặc người nhận và người gửi là một
--	emKMAIL_ERR_MONEY,					// Không đủ tiền
--	emKMAIL_ERR_ITEM,					// Vật phẩm sai
--	emKMAIL_ERR_MONEY_TONG,				// Ngân quỹ bang hội không đủ
--
function Mail:MailFailReason(nReason)
  local szMsg = "Gửi thư thất bại, "
  if nReason == 1 then
    szMsg = szMsg .. "hòm thư đã đầy!"
  elseif nReason == 2 then
    szMsg = szMsg .. "người nhận không đúng hoặc người nhận và người gửi là một!"
  elseif nReason == 3 then
    szMsg = szMsg .. "không đủ Bạc!"
  elseif nReason == 4 then
    szMsg = szMsg .. "vật phẩm sai"
  elseif nReason == 5 then
    szMsg = szMsg .. "ngân quỹ bang hội không đủ"
  end
  me.Msg(szMsg)
  return
end

function Mail:MailBoxLoadOk(bShowMsg)
  if bShowMsg and bShowMsg == 1 then
    me.Msg("Tải thư hoàn tất!")
  end
  me.SetMailBoxLoadOk()
  CoreEventNotify(UiNotify.emCOREEVENT_MAIL_LOADED)
end

-- Lấy nội dung thư thường
function Mail:RequireMail(nMailId, byClient)
  if not nMailId or not byClient then
    return 0
  end
  if byClient == 0 then
    me.RequestMail(nMailId)
  elseif byClient == 1 then
    self:SelectClientMail(nMailId)
  end
end

function Mail:DeleteMailRequest(nMailId, byClient)
  if not nMailId or not byClient then
    return 0
  end
  if byClient == 0 then
    me.DeleteMail(nMailId)
  elseif byClient == 1 then
    self:DeleteMail(nMailId)
  end
end

function Mail:OnLogin()
  Mail.IsManuUse = 1
end

PlayerEvent:RegisterGlobal("OnLogin", Mail.OnLogin, Mail)
