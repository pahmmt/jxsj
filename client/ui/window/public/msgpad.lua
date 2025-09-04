local uiMsgPad = Ui:GetClass("msgpad")
local tbMessageList = Ui.tbLogic.tbMessageList
local tbMsgChannel = Ui.tbLogic.tbMsgChannel

uiMsgPad.MESSAGE_LIST_CONT = {
  { "MessageList1", 0 },
  { "MessageList2", 0 },
  { "MessageList3", 0 },
  { "MessageList4", 0 },
  { "MessageList5", 0 },
  { "MessageList6", 0 },
  { "MessageList7", 0 },
} -- 多放几个以后可以支持动态标签了 :~)

----------------------------------------------------------------------
--频道标签TAB类(考虑不放在这个脚本里 :~) )

uiMsgPad.tbTabClass = {}
local tbTabClass = uiMsgPad.tbTabClass

function tbTabClass:Init(szName, szControlName) --每一个TAB有一个标签名
  self.tbMsgList = {}
  self.tbChannelCont = {}
  self.szTabName = szName
  self.tbMsgList = Lib:NewClass(Ui.tbLogic.tbMessageList)
  self.tbMsgList:Init()
  self.tbMsgList.szMessageListName = szControlName
  self.tbMsgList.UIGROUP = "UI_MSGPAD"
  self.tbMsgLog = {}
end

function tbTabClass:AddMsg(szChannelName, szName, szMsg, bSelfSend, szGateway, nSpeTitle)
  if self:IsNeedChannel(szChannelName) == 0 then
    --print("这个不是我需要的~");
    return
  end
  local szRealName = szName
  if szChannelName == "Global" and bSelfSend ~= 1 then
    Ui.tbLogic.tbGlobalChat:NewMsg(szGateway, szName, szMsg, nSpeTitle)
  end

  local nIsGm = 0
  if (szChannelName == tbMsgChannel.CHANNEL_SYSTEM) or (bSelfSend == 1) or (szName == "系统") then
    nIsGm = 1
  end
  local szGatewayName = ""
  if szChannelName == tbMsgChannel.CHANNEL_GLOBAL or (szChannelName == tbMsgChannel.CHANNEL_PERSONAL and tostring(szGateway or "") ~= "") then
    if szGateway == "abroad" then
      local tbPlayerInfo = Player.tbGlobalFriends.tbPlayerInfo[szName]
      if tbPlayerInfo and tbPlayerInfo.szGateway and tbPlayerInfo.szGateway ~= "" then
        szGateway = Player.tbGlobalFriends.tbPlayerInfo[szName].szGateway
      end
    end
    szGatewayName = GetServerNameByGatewayName(szGateway)
    if szGatewayName == nil then
      szGatewayName = "【未知服务器】"
    end
    local _, _, szServerName = string.find(szGatewayName, "(【.*】)")
    if szServerName ~= nil then
      szGatewayName = szServerName
    end
  end

  local tbNewChannelMsg = Lib:NewClass(tbMsgChannel.tbChannelMsgClass)
  tbNewChannelMsg.szChannelType = szChannelName
  local szNewMsg = tbNewChannelMsg:GetResult(szName, szMsg, nIsGm)
  local szColor = tbNewChannelMsg:GetColor()

  local szBorderColor = tbNewChannelMsg:GetBorderColor()
  tbNewChannelMsg = nil
  local nChannelPicId = tbMsgChannel:GetPicIdByChannelName(szChannelName)
  local szChannelPic = "<pic=" .. nChannelPicId .. ">"

  if self.tbMsgList then
    local tbParam = {}
    tbParam.szChannelPic = szChannelPic
    tbParam.szMsg = szNewMsg
    tbParam.szSendName = szName
    tbParam.nSpeTitle = tonumber(nSpeTitle) or 0
    tbParam.tbSendName = { szSendName = szName, nIsSystem = nIsGm }
    tbParam.szColor = szColor
    tbParam.szBorderColor = szBorderColor
    tbParam.nIsGm = nIsGm
    tbParam.szChannelName = szChannelName
    tbParam.szRealName = szRealName
    tbParam.szGateway = szGateway
    tbParam.szGatewayName = szGatewayName
    if szChannelName == tbMsgChannel.CHANNEL_GLOBAL then
      tbParam.bDisableMenu = 1
    end
    if szChannelName == tbMsgChannel.CHANNEL_PERSONAL and szGateway ~= "" then
      tbParam.bGlobalPrivateMsg = 1
    end
    self.tbMsgList:AddOneMsg(tbParam)
  end
  local szLable = ""
  if szName ~= "" then
    szLable = ":"
  end
  local szLogMsg = szName .. szLable .. szMsg
  table.insert(self.tbMsgLog, szLogMsg)
end

function tbTabClass:IsNeedChannel(szChannelName)
  if self.tbChannelCont[szChannelName] then
    return 1
  end
  return 0
end

function tbTabClass:AddNeedChannel(szChannelName)
  self.tbChannelCont[szChannelName] = 1
end

function tbTabClass:DelNeedChannel(szChannelName)
  self.tbChannelCont[szChannelName] = nil
end

function tbTabClass:ResetAllChannel()
  self.tbChannelCont = {}
end

function tbTabClass:Clear()
  self:ClearMsg()
  self.tbMsgList:Clear()
  self.tbMsgLog = {}
  self.tbChannelCont = {}
end

function tbTabClass:OnActive()
  Wnd_Show(self.tbMsgList.UIGROUP, self.tbMsgList.szMessageListName)
  Wnd_SetEnable(self.tbMsgList.UIGROUP, self.tbMsgList.szMessageListName, 1)
  ScrPanel_SetFirstShow(self.tbMsgList.UIGROUP, "Main", self.tbMsgList.szMessageListName)
  ScrPnl_DragToBottom(self.tbMsgList.UIGROUP, "Main")
end

function tbTabClass:OnLostFouce()
  Wnd_Hide(self.tbMsgList.UIGROUP, self.tbMsgList.szMessageListName)
  Wnd_SetEnable(self.tbMsgList.UIGROUP, self.tbMsgList.szMessageListName, 0)
end

function tbTabClass:OnSaveMsgLog()
  local tb = {}
  for _, szMsg in pairs(self.tbMsgLog) do
    tb[#tb + 1] = szMsg
  end
  local szLog = table.concat(tb, "\r\n")
  SaveMessageToFile(self.szTabName, szLog)
end

function tbTabClass:ClearMsg()
  self.tbMsgList:Clear()
  MessageList_Clear(self.tbMsgList.UIGROUP, self.tbMsgList.szMessageListName)
end

----------------------------------------------------------------------
--频道标签管理(考虑不放在这个脚本里 :~) )
uiMsgPad.tbChannelTabMgrClass = {}
local tbChannelTabMgrClass = uiMsgPad.tbChannelTabMgrClass

function tbChannelTabMgrClass:init()
  self.tbTabCont = {}
  self:LoadSetting()
  self.szCurActiveTabName = ""
end

function tbChannelTabMgrClass:LoadSetting() --标签设置 可以考虑读取ini 进行配置
  self:AddTab(tbMsgChannel.TAB_COMMON)
  self:AddTabChannel(tbMsgChannel.TAB_COMMON, tbMsgChannel.CHANNEL_GLOBAL)
  self:AddTabChannel(tbMsgChannel.TAB_COMMON, tbMsgChannel.CHANNEL_WORLD)
  self:AddTabChannel(tbMsgChannel.TAB_COMMON, tbMsgChannel.CHANNEL_FRIEND)
  self:AddTabChannel(tbMsgChannel.TAB_COMMON, tbMsgChannel.CHANNEL_TEAM)
  self:AddTabChannel(tbMsgChannel.TAB_COMMON, tbMsgChannel.CHANNEL_CITY)
  self:AddTabChannel(tbMsgChannel.TAB_COMMON, tbMsgChannel.CHANNEL_NEAR)
  self:AddTabChannel(tbMsgChannel.TAB_COMMON, tbMsgChannel.CHANNEL_TONG)
  self:AddTabChannel(tbMsgChannel.TAB_COMMON, tbMsgChannel.CHANNEL_KIN)
  self:AddTabChannel(tbMsgChannel.TAB_COMMON, tbMsgChannel.CHANNEL_FACTION)
  self:AddTabChannel(tbMsgChannel.TAB_COMMON, tbMsgChannel.CHANNEL_SONG)
  self:AddTabChannel(tbMsgChannel.TAB_COMMON, tbMsgChannel.CHANNEL_KING)
  self:AddTabChannel(tbMsgChannel.TAB_COMMON, tbMsgChannel.CHANNEL_SYSTEM)
  self:AddTabChannel(tbMsgChannel.TAB_COMMON, tbMsgChannel.CHANNEL_ME)
  self:AddTabChannel(tbMsgChannel.TAB_COMMON, tbMsgChannel.CHANNEL_PERSONAL)
  self:AddTabChannel(tbMsgChannel.TAB_COMMON, tbMsgChannel.CHANNEL_SERVER)
  self:AddTabChannel(tbMsgChannel.TAB_COMMON, tbMsgChannel.CHANNEL_DYN)

  self:AddTab(tbMsgChannel.TAB_PRIVATE)
  self:AddTabChannel(tbMsgChannel.TAB_PRIVATE, tbMsgChannel.CHANNEL_ME)
  self:AddTabChannel(tbMsgChannel.TAB_PRIVATE, tbMsgChannel.CHANNEL_PERSONAL)
  self:AddTabChannel(tbMsgChannel.TAB_PRIVATE, tbMsgChannel.CHANNEL_TEAM)

  self:AddTab(tbMsgChannel.TAB_FRIEND)
  self:AddTabChannel(tbMsgChannel.TAB_FRIEND, tbMsgChannel.CHANNEL_FRIEND)

  self:AddTab(tbMsgChannel.TAB_TONG)
  self:AddTabChannel(tbMsgChannel.TAB_TONG, tbMsgChannel.CHANNEL_TONG)
  self:AddTabChannel(tbMsgChannel.TAB_TONG, tbMsgChannel.CHANNEL_KIN)

  self:AddTab(tbMsgChannel.TAB_OTHER)
  self:AddTabChannel(tbMsgChannel.TAB_OTHER, tbMsgChannel.CHANNEL_SYSTEM)

  self:AddTab(tbMsgChannel.TAB_CUSTOM)

  self:AddTab(tbMsgChannel.TAB_TRANSFER) -- 跨服后源服标签
  --self:AddTabChannel(tbMsgChannel.TAB_TRANSFER, tbMsgChannel.CHANNEL_GLOBAL);
  --self:AddTabChannel(tbMsgChannel.TAB_TRANSFER, tbMsgChannel.CHANNEL_SYSTEM);
  self:AddTabChannel(tbMsgChannel.TAB_TRANSFER, tbMsgChannel.CHANNEL_WORLD)
  self:AddTabChannel(tbMsgChannel.TAB_TRANSFER, tbMsgChannel.CHANNEL_FRIEND)
  self:AddTabChannel(tbMsgChannel.TAB_TRANSFER, tbMsgChannel.CHANNEL_TONG)
  self:AddTabChannel(tbMsgChannel.TAB_TRANSFER, tbMsgChannel.CHANNEL_KIN)
end

--配置标签栏以及所需要的频道
function tbChannelTabMgrClass:AddTab(szTabName)
  local tbNewChannelTab = Lib:NewClass(uiMsgPad.tbTabClass)
  local szCanUseListName = nil
  for i, tbMessageListCtl in pairs(uiMsgPad.MESSAGE_LIST_CONT) do -- 查找控件表，找出可用的分配给当前标签
    if tbMessageListCtl[2] ~= 1 then
      szCanUseListName = tbMessageListCtl[1]
      tbMessageListCtl[2] = 1
      break
    end
  end
  if not szCanUseListName then
    print("没有可用来显示的messagelist了~")
    return
  end
  tbNewChannelTab:Init(szTabName, szCanUseListName)
  self.tbTabCont[szTabName] = tbNewChannelTab
end

function tbChannelTabMgrClass:DelTab(szTabName)
  self.tbTabCont[szTabName] = nil
end

function tbChannelTabMgrClass:ResetTab(szTabName)
  if self.tbTabCont[szTabName] then
    self.tbTabCont[szTabName]:ResetAllChannel()
  end
end

function tbChannelTabMgrClass:AddTabChannel(szTabName, szChannelName)
  if self.tbTabCont[szTabName] then
    self.tbTabCont[szTabName]:AddNeedChannel(szChannelName)
  end
end

function tbChannelTabMgrClass:DelTabChannel(szTabName, szChannelName)
  if self.tbTabCont[szTabName] then
    self.tbTabCont[szTabName]:DelNeedCHannel(szChannelName)
  end
end

function tbChannelTabMgrClass:AddMsg(szChannelName, szName, szMsg, bSelfSend, szGateway, nSpeTitle)
  if szChannelName ~= "World" then
    for szTabName, tbChannelTab in pairs(self.tbTabCont) do
      tbChannelTab:AddMsg(szChannelName, szName, szMsg, bSelfSend, szGateway, nSpeTitle)
    end
  elseif Player:GetTransferStatus() == 1 and szGateway ~= "Global" then
    self.tbTabCont[tbMsgChannel.TAB_TRANSFER]:AddMsg(szChannelName, szName, szMsg, bSelfSend, szGateway, nSpeTitle)
  else
    self.tbTabCont[tbMsgChannel.TAB_COMMON]:AddMsg(szChannelName, szName, szMsg, bSelfSend, szGateway, nSpeTitle)
  end
end

function tbChannelTabMgrClass:OnSaveMsgLog(szTabName)
  if self.tbTabCont[szTabName] then
    self.tbTabCont[szTabName]:OnSaveMsgLog()
  end
end

function tbChannelTabMgrClass:OnClearTabMsg(szTabName)
  if self.tbTabCont[szTabName] then
    self.tbTabCont[szTabName]:ClearMsg()
  end
end

function tbChannelTabMgrClass:OnActive(szName)
  if szName == self.szCurActiveTabName then
    return
  end
  for szTabName, tbChannelTab in pairs(self.tbTabCont) do
    tbChannelTab:OnLostFouce()
  end
  self.szCurActiveTabName = szName
  self.tbTabCont[szName]:OnActive()
end

function tbChannelTabMgrClass:Reset()
  self:Init()
end

function tbChannelTabMgrClass:Clear()
  for i, tbMessageListCtl in pairs(uiMsgPad.MESSAGE_LIST_CONT) do
    tbMessageListCtl[2] = 0
  end
  for szTabName, tbTab in pairs(self.tbTabCont) do
    if tbTab then
      tbTab:Clear()
    end
  end
  self.tbTabCont = nil
end

function tbChannelTabMgrClass:GetActiveTabName()
  return self.szCurActiveTabName
end

------------------------------------------------------------------
---- 界面逻辑
function uiMsgPad:Init()
  self.tbChannelTabMgr = Lib:NewClass(self.tbChannelTabMgrClass)
  self.bAutoScroll = 1
end

function uiMsgPad:OnOpen()
  UiManager:OpenWindow(Ui.UI_CHATTAB)
end

function uiMsgPad:OnClose()
  self.tbChannelTabMgr:Clear()
  self.tbChannelTabMgr = nil
end

function uiMsgPad:SetAutoScroll(bScroll, bBottom)
  if bScroll == 1 and bBottom == 1 then
    ScrPnl_DragToBottom(self.UIGROUP, "Main")
  end
  self.bAutoScroll = bScroll
end

function uiMsgPad:GetAutoScroll()
  return self.bAutoScroll
end

function uiMsgPad:OnActive(szTabName)
  self.tbChannelTabMgr:OnActive(szTabName)
end

function uiMsgPad:AddChannelToCustom(szChannelName)
  self.tbChannelTabMgr:AddTabChannel(tbMsgChannel.TAB_CUSTOM, szChannelName)
end

function uiMsgPad:ResetCustomTab(szChannelName)
  self.tbChannelTabMgr:ResetTab(tbMsgChannel.TAB_CUSTOM)
end

function uiMsgPad:OnChatChannel(nChannelId, szName, szMsg, szGateway, nSpeTitle)
  local bTest = CallForTest(szMsg)
  if bTest == 1 then
    return
  end
  local szChannelName = tbMsgChannel:GetChannelNameById(nChannelId)
  if nChannelId == 2 and szChannelName == nil then
    szChannelName = "Global"
  end
  if me.IsShowOtherPlayerChat() == 0 and szChannelName == Ui.tbLogic.tbMsgChannel.CHANNEL_NEAR then
    return
  end
  self:OnSendMsgToChannel(szChannelName, szName, szMsg, szGateway, nSpeTitle)
end

function uiMsgPad:OnChatDynChannel(ChannelId, szName, szMsg)
  local szChannelName = tbMsgChannel:GetChannelNameById(ChannelId)
  self:OnSendMsgToChannel(szChannelName, szName, szMsg)
end

function uiMsgPad:FindLink(szMsg, nBegin)
  local tbParams = {}
  nBegin = nBegin or 1
  local nBegin, nEnd, szName, szParam = string.find(szMsg, "<([^<>]-)=([^<>]-)>", tonumber(nBegin))
  if nBegin and nEnd and szParam then
    tbParams = Lib:SplitStr(szParam, ",")
  end
  return szName, nBegin, nEnd, tbParams
end

--过滤非表情图片
function uiMsgPad:FilterUnFacePic(szMsg)
  local szElemName, nBegin, nEnd, tbLinkParams = self:FindLink(szMsg)
  local szNormal = ""
  while szElemName do
    if (szElemName == "pic") and GetPicForChat(tonumber(tbLinkParams[1])) ~= 1 then
      szMsg = string.sub(szMsg, 0, nBegin - 1) .. string.sub(szMsg, nEnd + 1)
      szElemName, nBegin, nEnd, tbLinkParams = self:FindLink(szMsg)
    else
      szElemName, nBegin, nEnd, tbLinkParams = self:FindLink(szMsg, nEnd)
    end
  end
  return szMsg
end

function uiMsgPad:OnSendMsgToChannel(szChannelName, szName, szMsg, szGateway, nSpeTitle)
  self.bAutoBottom = self.bAutoScroll
  if szChannelName ~= "GM" and szName ~= me.szName and szName ~= "系统" and szName ~= "公告" then
    local nChatType = ChatFilter:GetChatTypeByChannelName(szChannelName)
    if nChatType and ChatFilter:IsChatMsgAllowed(nChatType, szName, szMsg) == 0 then
      self.bAutoBottom = 0
      return
    end
  end
  local tbNoFilterPic = {
    [tbMsgChannel.CHANNEL_SYSTEM] = 1,
    [tbMsgChannel.CHANNEL_SERVER] = 1,
  }
  if tbNoFilterPic[szChannelName] ~= 1 then
    szMsg = self:FilterUnFacePic(szMsg)
    if szMsg == "" then
      return
    end
  end
  self.tbChannelTabMgr:AddMsg(szChannelName, szName, szMsg, 0, szGateway, nSpeTitle)
  if self.bAutoBottom ~= 1 then
    self:OnOpenChatNewMsg(szChannelName, szName, szMsg)
  end
  if self.bAutoScroll == 1 then
    ScrPnl_DragToBottom(self.UIGROUP, "Main")
  end
  self.bAutoBottom = 0
end

function uiMsgPad:OnSendMsgToChannelBySelf(szChannelName, szName, szMsg, nSpeTitle)
  self.bAutoBottom = self.bAutoScroll
  self.tbChannelTabMgr:AddMsg(szChannelName, szName, szMsg, 1, nil, nSpeTitle)
  if self.bAutoBottom ~= 1 then
    self:OnOpenChatNewMsg(szChannelName, szName, szMsg)
  end
  if self.bAutoScroll == 1 then
    ScrPnl_DragToBottom(self.UIGROUP, "Main")
  end
  self.bAutoBottom = 0
end

function uiMsgPad:OnChatSomeOne(szGateway, szSomeOne, szSendName, szMsg, nSpeTitle, nMonth, nDay, nHour, nMin)
  -- 跨服密聊黑名单
  nSpeTitle = 0 --私聊不支持表情
  for _k, _v in pairs(Player.tbGlobalFriends.tbBlackList) do
    if _v == szSomeOne then
      return
    end
  end

  local szTime = ""
  if nMonth then
    szTime = string.format("发送于%d月%d日%d:%02d:", nMonth, nDay, nHour, nMin)
  end
  if me.szName == szSomeOne then -- FeedBack(私聊频道中 私聊发送者 和 私聊动作描述 是反的。。真晕 @_@~)
    local szRecvMsg = szTime .. szMsg
    local szHead = string.sub(szRecvMsg, 1, 1)
    if szHead == "#" then
      local szEmote = string.sub(szRecvMsg, 2, -1)
      local szNewEmote = AddEmoteMsg(szEmote, szSendName)
      if szNewEmote then
        self:OnSendMsgToChannel(tbMsgChannel.CHANNEL_ME, szSomeOne, szRecvMsg, nil, nSpeTitle)
      else
        self:OnSendMsgToChannel(tbMsgChannel.CHANNEL_ME, szSendName, szRecvMsg, nil, nSpeTitle)
      end
    else
      self:OnSendMsgToChannel(tbMsgChannel.CHANNEL_ME, szSendName, szRecvMsg, nil, nSpeTitle)
    end
  else
    if ChatFilter:IsChatMsgAllowed(ChatFilter.CHAT_TYPE_PRIVATE, szSomeOne, szMsg) == 0 then
      return
    end
    local szActiveTabName = self.tbChannelTabMgr:GetActiveTabName()
    self:OnSendMsgToChannel(tbMsgChannel.CHANNEL_PERSONAL, szSomeOne, szTime .. szMsg, szGateway, nSpeTitle)
    if szActiveTabName ~= tbMsgChannel.TAB_PRIVATE then
      Ui(Ui.UI_CHATTAB):FlashPrivateTab()
    end
  end
end

function uiMsgPad:OnSaveTabLog(szTabName)
  self.tbChannelTabMgr:OnSaveMsgLog(szTabName)
end

function uiMsgPad:ClearTabMsg(szTabName)
  self.tbChannelTabMgr:OnClearTabMsg(szTabName)
end

function uiMsgPad:ClearActiveTabMsg()
  local szActiveTabName = self.tbChannelTabMgr:GetActiveTabName()
  self.tbChannelTabMgr:OnClearTabMsg(szActiveTabName)
  ScrPnl_Update(self.UIGROUP, "Main")
end

function uiMsgPad:ModifyTeamLinkInfo(nPlayerId, nTeamId, nTeamNum, szTeamName)
  local tbTab = self.tbChannelTabMgr.tbTabCont[tbMsgChannel.TAB_COMMON]
  tbTab.tbMsgList:ModifyTeamLinkInfo(nPlayerId, nTeamId, nTeamNum, szTeamName)

  tbTab = self.tbChannelTabMgr.tbTabCont[tbMsgChannel.TAB_PRIVATE]
  tbTab.tbMsgList:ModifyTeamLinkInfo(nPlayerId, nTeamId, nTeamNum, szTeamName)

  tbTab = self.tbChannelTabMgr.tbTabCont[tbMsgChannel.TAB_FRIEND]
  tbTab.tbMsgList:ModifyTeamLinkInfo(nPlayerId, nTeamId, nTeamNum, szTeamName)

  tbTab = self.tbChannelTabMgr.tbTabCont[tbMsgChannel.TAB_TONG]
  tbTab.tbMsgList:ModifyTeamLinkInfo(nPlayerId, nTeamId, nTeamNum, szTeamName)

  tbTab = self.tbChannelTabMgr.tbTabCont[tbMsgChannel.TAB_CUSTOM]
  tbTab.tbMsgList:ModifyTeamLinkInfo(nPlayerId, nTeamId, nTeamNum, szTeamName)
end

function uiMsgPad:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_CHAT_SOMEONE, self.OnChatSomeOne },
    { UiNotify.emCOREEVENT_CHAT_CHANNEL, self.OnChatChannel },
    { UiNotify.emCOREEVENT_CHAT_DYNCHANNEL, self.OnChatDynChannel },
    { UiNotify.emUIEVENT_CHAT_SEND_MSG_CHANNEL, self.OnSendMsgToChannelBySelf },
    { UiNotify.emCOREEVENT_CHAT_SEND_MSG_CHANNEL, self.OnSendMsgToChannelBySelf },
    { UiNotify.emUIEVENT_CHAT_ONACTIVE_TAB, self.OnActive },
  }
  return tbRegEvent
end

-- 拖动响应
function uiMsgPad:OnScorllbarPosChanged(szWnd)
  local nX, nY = Wnd_GetPos(self.UIGROUP, "Main")
  local nGlobalWidth, nGlobalHeight = Wnd_GetSize(Ui.UI_GLOBALCHAT, "Main")
  Wnd_SetPos(Ui.UI_GLOBALCHAT, "Main", 0, nY - nGlobalHeight)
end

function uiMsgPad:RegisterMessage()
  local tbRegMsg = {}
  for szName, tbTab in pairs(self.tbChannelTabMgr.tbTabCont) do
    tbRegMsg = Lib:MergeTable(tbRegMsg, tbTab.tbMsgList:RegisterMouseMessage())
  end
  return tbRegMsg
end

function uiMsgPad:OnScorllPanelSlideMaxPos(szWnd, nParam)
  if szWnd == "Main" and self.bAutoBottom ~= 1 then
    self:SetAutoScroll(nParam)
    Btn_Check(Ui.UI_CHATTAB, "BtnAutoScrol", nParam)
    if nParam == 1 and UiManager:WindowVisible(Ui.UI_CHATNEWMSG) == 1 then
      UiManager:CloseWindow(Ui.UI_CHATNEWMSG)
    end
  end
end

function uiMsgPad:OnOpenChatNewMsg(szChannelName, szName, szMsg)
  if szChannelName ~= "GM" and szName ~= "系统" then
    if UiManager:WindowVisible(Ui.UI_CHATNEWMSG) ~= 1 then
      UiManager:OpenWindow(Ui.UI_CHATNEWMSG, szChannelName, szName, szMsg)
      local nTabLeft, nTabTop = Wnd_GetPos(Ui.UI_CHATTAB, "Main")
      Wnd_SetPos(Ui.UI_CHATNEWMSG, "Main", nTabLeft + 13, nTabTop - 18)
    else
      Ui(Ui.UI_CHATNEWMSG):UpdateTxt(szChannelName, szName, szMsg)
    end
  end
end
