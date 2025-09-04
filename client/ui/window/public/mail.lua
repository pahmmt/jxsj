-----------------------------------------------------
--文件名		：	mail.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-06-01
--功能描述		：	信件界面脚本。
------------------------------------------------------

local uiMail = Ui:GetClass("mail")
local tbTimer = Ui.tbLogic.tbTimer

uiMail.CLOSE_WINDOW_BUTTON = "BtnClose"
uiMail.LIST_MAIL = "LstMail"
uiMail.BUTTON_OPEN_MAIL = "BtnOpenMail"
uiMail.BUTTON_NEW_MAIL = "BtnNewMail"
uiMail.BUTTON_CLS_ALL_MAIL = "ClearAllMail"
uiMail.BUTTON_CLS_READ_MAIL = "ClearReadMail"
uiMail.MAX_MAIL_NUMBER = 20
uiMail.PreDelMailCount = 4
uiMail.PreDelMailTimeOpen = 2 * 18
uiMail.PreDelMailTimeClose = 3 * 18
uiMail.TIME_PLAYER_NEW_MAIL = 5 * 18

-- 表情符序号，在\setting\chat\chatface.ini中定义
uiMail.MAIL_STATE_ICON = { 140, 141, 142, 143 } -- { 未读，已读，退信，保存 }

function uiMail:Init()
  self.tbMailList = {}
  self.nRefreshFlag = 0
  self.nNewMailFlag = 0
  self.nTimer_PlayerNewMailId = nil
end

function uiMail:OnOpen()
  Mail:RequestMailList(Mail.MAILCONDTYPE)
  --写log
  Log:Ui_SendLog("点击邮箱", 1)

  if Mail.nMailCount >= self.MAX_MAIL_NUMBER then
    me.Msg("您的信箱已满，可能造成新信件丢失，请尽快清理信箱，删除不再需要的信件，在被清理之前您不能发送新信件！")
  end
end

function uiMail:RequestMailList(nType)
  if self.nRefreshFlag ~= 1 then
    Lst_Clear(self.UIGROUP, self.LIST_MAIL)
    Mail:RequestMailList(nType)
    self.nRefreshFlag = 1
  end
end

function uiMail:RefreshMailList(nType)
  self.nRefreshFlag = 0
  self:RequestMailList(nType)
end

function uiMail:OnMailLoaded()
  self:RefreshMailList(Mail.MAILOTHERTYPE)
end

function uiMail:OnMailSendOk()
  me.Msg("信件发送成功！")
end

function uiMail:OnMailSendFail()
  me.Msg("信件发送失败！")
end

function uiMail:PlayerNewMailHighLight()
  SetNewMailFlag(1)

  if self.nTimer_PlayerNewMailId and self.nTimer_PlayerNewMailId ~= 0 then
    tbTimer:Close(self.nTimer_PlayerNewMailId)
    self.nTimer_PlayerNewMailId = 0
  end

  self.nTimer_PlayerNewMailId = tbTimer:Register(self.TIME_PLAYER_NEW_MAIL, self.StopNewMailHighLight, self)
end

function uiMail:StopNewMailHighLight()
  SetNewMailFlag(0)
  --	self.nNewMailFlag = 0;
  self.nTimer_PlayerNewMailId = 0
  return 0
end

function uiMail:OnMailNew()
  me.Msg("有新信件！")
  self:PlayerNewMailHighLight(1)
  self.nNewMailFlag = 1
  if UiManager:WindowVisible(Ui.UI_MAIL) ~= 0 then
    Mail:RequestMailList(Mail.MAILCONDTYPE)
  else
    self:RefreshMailList(Mail.MAILOTHERTYPE)
  end
end

function uiMail:OnButtonClick(szWnd, nParam)
  if Mail.IsManuUse == 0 then
    return 0
  end
  if szWnd == self.CLOSE_WINDOW_BUTTON then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BUTTON_OPEN_MAIL then
    self:OnOpenMail()
  elseif szWnd == self.BUTTON_NEW_MAIL then
    Mail:RequestOpenNewMail()
  elseif szWnd == self.BUTTON_CLS_ALL_MAIL then
    self:ClearAllMail(0)
  elseif szWnd == self.BUTTON_CLS_READ_MAIL then
    self:ClearAllMail(1)
  end
end

function uiMail:ClearAllMail(bRead)
  self.tbMailId = {}
  for nMailId, tbMail in pairs(me.GetTempTable("Mail").tbMailListID or {}) do
    if bRead == 1 then
      if tbMail.nState == 1 then
        table.insert(self.tbMailId, nMailId)
      end
    else
      table.insert(self.tbMailId, nMailId)
    end
  end
  if #self.tbMailId <= 0 then
    return 0
  end
  local tbMsg = {}
  tbMsg.szMsg = "删除所有已读和未读邮件（不会删除包含附件的邮件）删除不能再恢复，是否确定？"
  if bRead == 1 then
    tbMsg.szMsg = "删除所有已读邮件（不会删除包含附件的邮件）删除不能再恢复，是否确定？"
  end
  tbMsg.nOptCount = 2
  function tbMsg:Callback(nOptIndex, bReadFlag)
    if nOptIndex == 2 then
      Ui(Ui.UI_MAIL):ClearAllMailSure(bReadFlag)
    end
  end
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, bRead)
end

function uiMail:ClearAllMailSure(bRead)
  if #self.tbMailId <= 0 then
    return 0
  end
  Mail.IsManuUse = 0
  self:ClearAllMailState()
  self:ClearAllMailOpen()
  local szText = "清空所有邮件中..."
  if bRead == 1 then
    szText = "清空已读邮件中..."
  end
  local nDelay = (self.PreDelMailTimeOpen * math.ceil(#self.tbMailId / self.PreDelMailCount)) + self.PreDelMailTimeClose
  Timer:Register(nDelay + 2 * 18, self.ClearAllMailClose, self) --必解
  GeneralProcess:StartProcess(szText, nDelay, { self.ClearAllMailClose, self }, {}, { 13 })
end

function uiMail:ClearAllMailOpen()
  Timer:Register(self.PreDelMailTimeOpen, self.ClearAllMailState, self)
end

function uiMail:ClearAllMailState()
  local nSum = 0
  local tbDelId = {}
  for ni, nMailId in pairs(self.tbMailId) do
    me.RequestMail(nMailId)
    self:DeleteMail(nMailId)
    tbDelId[ni] = 1
    nSum = nSum + 1
    if nSum >= self.PreDelMailCount then
      break
    end
  end
  for ni in pairs(tbDelId) do
    self.tbMailId[ni] = nil
  end

  if nSum < self.PreDelMailCount then
    return 0
  end
  return
end

function uiMail:ClearAllMailClose()
  if Mail.IsManuUse == 1 then
    return 0
  end
  CoreEventNotify(UiNotify.emCOREEVENT_MAIL_LOADED)
  Mail.IsManuUse = 1
  return 0
end

function uiMail:OnListDClick(szWnd, nParam)
  if szWnd == self.LIST_MAIL then
    self:OnOpenMail()
  end
end

function uiMail:OnOpenMail()
  local nMailId = Lst_GetCurKey(self.UIGROUP, self.LIST_MAIL)
  local tbMail = self.tbMailList[nMailId]
  if not tbMail then
    return
  end
  self.nType = tbMail.nType

  Mail:RequireMail(nMailId, tbMail.byClient)
end

function uiMail:DeleteMail(nMailId)
  if self.tbMailList[nMailId] then
    Mail:DeleteMailRequest(nMailId, self.tbMailList[nMailId].byClient)
    self.tbMailList[nMailId] = nil
  end
end

function uiMail:OnShowMailList()
  local tbTempTable = me.GetTempTable("Mail")
  local tbList = tbTempTable.tbMailList
  local nNewMailFlag = 0

  Lst_Clear(self.UIGROUP, self.LIST_MAIL)

  for i, v in pairs(tbTempTable.tbMailListID) do
    self.tbMailList[i] = v
  end

  local nMax = (Mail.nMailCount >= 20) and 20 or Mail.nMailCount
  local nStart = 0

  if Mail.nMailCount >= 20 then
    nStart = Mail.nMailCount - 20
  end
  local bHaveBackMail = 0
  for i = 1, nMax do
    local tbMail = tbList[nStart + i]
    local szTitle = ""
    if tbMail.nType ~= 1 then
      szTitle = "标题：<color=red>" .. tbMail.szCaption .. "<color>\n来自：<color=red>" .. tbMail.szSender .. "<color>"
    else
      szTitle = "标题：" .. tbMail.szCaption .. "\n来自：" .. tbMail.szSender
    end
    Lst_SetCell(self.UIGROUP, self.LIST_MAIL, tbMail.nId, 1, "<pic=" .. self.MAIL_STATE_ICON[tbMail.nState + 1] .. ">")
    Lst_SetCell(self.UIGROUP, self.LIST_MAIL, tbMail.nId, 2, szTitle)
    Lst_SetCell(self.UIGROUP, self.LIST_MAIL, tbMail.nId, 3, tbMail.nTime .. "天")
    if tbMail.nState == 0 then
      nNewMailFlag = 1
    elseif tbMail.nState == 2 then
      bHaveBackMail = 1
    end
  end

  if (nNewMailFlag == 1) or (self.nNewMailFlag == 1) then
    self:PlayerNewMailHighLight()
  else
    SetNewMailFlag(0)
  end
  self.nNewMailFlag = 0
  if bHaveBackMail == 1 then
    me.Msg("您邮箱中有被退回的邮件。")
  end
  if Mail.nMailCount >= 20 then
    self:PlayerNewMailHighLight()
    local szMsg = "您的邮箱已满，请即时删除旧邮件"
    UiManager:OpenWindow(Ui.UI_INFOBOARD, szMsg)
  end
end

-----------------------------------------------------------

function uiMail:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_MAIL_LOADED, self.OnMailLoaded },
    { UiNotify.emCOREEVENT_MAIL_SENDOK, self.OnMailSendOk },
    { UiNotify.emCOREEVENT_MAIL_SENDFAIL, self.OnMailSendFail },
    { UiNotify.emCOREEVENT_MAIL_NEWMAIL, self.OnMailNew },
    { UiNotify.emCOREEVENT_SYNC_MAIL_LIST, self.OnShowMailList },
  }
  return tbRegEvent
end

-----------------------------------------------------------
