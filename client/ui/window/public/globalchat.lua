-- author:	zhaoyu
-- date:	2010/3/25 17:28:33
-- comments:

local uiGlobalChat = Ui:GetClass("globalchat")
local tbMsgList = Ui.tbLogic.tbMessageList
local tbMsgChannel = Ui.tbLogic.tbMsgChannel
uiGlobalChat.szMessageListName = "MessageList99"
uiGlobalChat.szPostName = "MsgName"
uiGlobalChat.szBGAnimation = "BGAnimation"

uiGlobalChat.MAX_MSGCOUNT = 1 -- 最多显示的消息数
uiGlobalChat.nCurrentMsgCount = 0 -- 当前已经显示的消息数量

uiGlobalChat.MAX_FRAMELEFT = 18 * 2 -- 滑动持续多少帧
uiGlobalChat.nFrameLeft = 0 -- 当前帧
uiGlobalChat.nFrameTimerId = 0 -- 每帧回调的timerid
uiGlobalChat.MAX_SLEEP = 9 -- 缓冲多少帧
uiGlobalChat.nSleepLeft = 0 -- 当前缓冲帧

uiGlobalChat.tbMsgList = {} -- 未显示的消息列表
uiGlobalChat.nMsgList_End = 1 -- 未显示的消息列表结束Id
uiGlobalChat.nMsgList_Begin = 1 -- 未显示的消息列表开始Id

uiGlobalChat.MIN_TIMELEFT = 4 -- 每个消息最少存在时间
uiGlobalChat.MAX_TIMELEFT = 15 -- 每个消息最多存在时间
uiGlobalChat.nTimeLeft = 0 -- 当前消息显示的剩余时间
uiGlobalChat.nSecondTimerId = 0 -- 每秒回调的timerid
uiGlobalChat.bInited = 0
uiGlobalChat.bAutoHide = 0

uiGlobalChat.tbEffect = {
  "\\image\\ui\\001a\\main\\chatchanel\\chanel_fire.spr",
  "\\image\\ui\\001a\\main\\chatchanel\\chanel_stars.spr",
  "\\image\\ui\\001a\\main\\chatchanel\\chanel_brightly.spr",
}

function uiGlobalChat:Init()
  if self.bInited ~= 1 then
    self.bInited = 1
    self.nMessageCount = 0
    self.tbElemClass = {}
  end
end

function uiGlobalChat:OnOpen()
  Ui.tbLogic.tbGlobalChat = self
  self:Init()
  if self.nSecondTimerId == 0 then
    self.nSecondTimerId = Timer:Register(18, self.OnSecondCallBack, self)
  end
  if self.nFrameTimerId == 0 then
    self.nFrameTimerId = Timer:Register(1, self.OnFrameCallBack, self)
  end
  --MessageList_AddNewLine(self.UIGROUP, self.szMessageListName);
end

function uiGlobalChat:OnClose(bAutoHide)
  self.bAutoHide = bAutoHide or 0
end

function uiGlobalChat:AddElemName(szName)
  self:AddMsgElem("name", tbInfo)
end

function uiGlobalChat:AddElemNormal(szMsg, szColor)
  if szColor == nil then
    szColor = "yellow"
  end
  self:AddMsgElem("normal", { szMsg, szColor, "black", 0 })
end

function uiGlobalChat:AddMsgElem(szName, tbInfo)
  if not tbMsgList.tbBaseClass[szName] then
    return 0
  end
  local tbNewElem = Lib:NewClass(tbMsgList.tbBaseClass[szName])
  tbNewElem.tbManager = self
  local nElemId = tbNewElem:Init(tbInfo)
  self.tbElemClass[nElemId] = tbNewElem
  return 1, nElenId
end

function uiGlobalChat:OnSecondCallBack()
  if self.nTimeLeft > 0 then
    self.nTimeLeft = self.nTimeLeft - 1
  end
  if self.nTimeLeft <= self.MAX_TIMELEFT - self.MIN_TIMELEFT then
    UiManager:CloseWindow("UI_GLOBALCHATEFFECT")
  end
  self:DisposeMessageList()
end

function uiGlobalChat:OnFrameCallBack()
  local MAX_WIDTH = 302
  if self.nFrameLeft <= 0 then
    return
  end
  if self.nFrameLeft == self.MAX_FRAMELEFT and self.nSleep == self.MAX_SLEEP then
    Wnd_SetPos(self.UIGROUP, self.szMessageListName, -MAX_WIDTH, 20)
    self.nSleep = self.MAX_SLEEP
  end
  if self.nSleep > 0 then
    self.nSleep = self.nSleep - 1
    return
  end
  local nX, nY = Wnd_GetPos(self.UIGROUP, self.szMessageListName)
  self.nFrameLeft = self.nFrameLeft - 1
  nX = nX + MAX_WIDTH / self.MAX_FRAMELEFT
  if nX > 0 then
    nX = 0
  end
  if self.nFrameLeft <= 0 then
  end
  Wnd_SetPos(self.UIGROUP, self.szMessageListName, nX, 20)
end

function uiGlobalChat:FindLink(szMsg, nBegin)
  local tbParams = {}
  nBegin = nBegin or 1
  local nBegin, nEnd, szName, szParam = string.find(szMsg, "<([^<>]-)=([^<>]-)>", tonumber(nBegin))
  if nBegin and nEnd and szParam then
    tbParams = Lib:SplitStr(szParam, ",")
  end
  return szName, nBegin, nEnd, tbParams
end

--过滤非表情图片
function uiGlobalChat:FilterUnFacePic(szMsg)
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
function uiGlobalChat:NewMsg(szGateway, szName, szMsg, nSpeTitle)
  szMsg = self:FilterUnFacePic(szMsg)
  if szMsg == "" then
    return
  end
  self.tbMsgList[self.nMsgList_End] = { szGateway = szGateway, szName = szName, szMsg = szMsg, nSpeTitle = nSpeTitle }
  self.nMsgList_End = self.nMsgList_End + 1
  self:DisposeMessageList()
end

function uiGlobalChat:DisposeMessageList()
  if self.nFrameLeft > 0 then
    return -- 动画还没播放完
  end
  if self.nTimeLeft > self.MAX_TIMELEFT - self.MIN_TIMELEFT then
    return -- 最小存在时间还没到
  end
  local tbMsg = self.tbMsgList[self.nMsgList_Begin]
  -- 下一条没有消息了
  if tbMsg == nil then
    -- 超时了，清除当前消息
    if self.nTimeLeft <= 0 then
      UiManager:CloseWindow("UI_GLOBALCHAT", 1)
      UiManager:CloseWindow("UI_GLOBALCHATEFFECT")
      UiManager:CloseWindow("UI_GLOBALCHATBUY")
      TxtEx_SetText(self.UIGROUP, self.szPostName, " ")
      MessageList_Clear(self.UIGROUP, self.szMessageListName)
    end
    return -- 没有消息可以显示
  end
  self.tbMsgList[self.nMsgList_Begin] = nil
  self.nMsgList_Begin = self.nMsgList_Begin + 1
  self:RefreshMsg(tbMsg.szGateway, tbMsg.szName, tbMsg.szMsg, tbMsg.nSpeTitle)
end

function uiGlobalChat:RefreshMsg(szGateway, szName, szMsg, nSpeTitle)
  if UiManager:WindowVisible(Ui.UI_GLOBALCHAT) == 0 and self.bAutoHide == 1 then
    UiManager:OpenWindow(Ui.UI_GLOBALCHAT)
  end
  if UiManager:WindowVisible(Ui.UI_GLOBALCHAT) == 1 then
    UiManager:OpenWindow("UI_GLOBALCHATBUY")
    local nImgIdx = MathRandom(1, 3)
    Img_SetImage("UI_GLOBALCHATEFFECT", "BGAnimation", 1, self.tbEffect[nImgIdx])
    UiManager:OpenWindow("UI_GLOBALCHATEFFECT")
    Img_PlayAnimation("UI_GLOBALCHATEFFECT", "BGAnimation")
  end

  self.nTimeLeft = self.MAX_TIMELEFT
  self.nFrameLeft = self.MAX_FRAMELEFT
  self.nSleep = self.MAX_SLEEP
  if self.nCurrentMsgCount >= self.MAX_MSGCOUNT then
    self.nCurrentMsgCount = 0
    MessageList_PopUpOne(self.UIGROUP, self.szMessageListName)
  end

  self.nCurrentMsgCount = self.nCurrentMsgCount + 1
  MessageList_AddNewLine(self.UIGROUP, self.szMessageListName)

  -- 发消息的人名字
  local szGatewayName = GetServerNameByGatewayName(szGateway)
  if szGatewayName == nil then
    szGatewayName = "【未知服务器】"
  end
  local _, _, szServerName = string.find(szGatewayName, "(【.*】)")
  if szServerName ~= nil then
    szGatewayName = szServerName
  end
  local szSendPic = ""
  if nSpeTitle and nSpeTitle > 0 and tbMsgChannel.tbGVSprChatPicId[nSpeTitle] then
    szSendPic = "<pic=" .. tbMsgChannel.tbGVSprChatPicId[nSpeTitle] .. ">"
  end
  TxtEx_SetText(self.UIGROUP, self.szPostName, string.format("<color=orange>%s%s<color=green>%s<color>说：", szGatewayName, szSendPic, szName))

  local szTemp = szMsg
  local szHead = string.sub(szTemp, 1, 1)
  if szHead == "#" then
    local szEmote = string.sub(szTemp, 2, -1)
    local szNewEmote = AddEmoteMsg(szEmote, szName)
    if szNewEmote then
      szTemp = szNewEmote
      TxtEx_SetText(self.UIGROUP, self.szPostName, string.format("<color=orange>%s<color=green>%s<color>表情：", szGatewayName, szName))
    else
    end
  end

  local szElemName, nBegin, nEnd, tbLinkParams = tbMsgList:FindLink(szTemp)

  local szNormal = ""
  while szElemName do
    if nBegin ~= 1 then
      szNormal = szNormal .. string.sub(szTemp, 1, nBegin - 1)
    end
    if tbMsgList:IsTradeLink(szElemName) == 1 then
      if szNormal then
        self:AddElemNormal(szNormal)
      end
      -- 添加一个装备连接
      self:AddMsgElem(szElemName, { tbLinkParams, "64,190,255", "black", 0, 0 })
      szNormal = ""
    else
      szNormal = szNormal .. string.sub(szTemp, nBegin, nEnd)
    end

    szTemp = string.sub(szTemp, nEnd + 1)
    szElemName, nBegin, nEnd, tbLinkParams = tbMsgList:FindLink(szTemp)
  end
  szNormal = szNormal .. szTemp
  self:AddElemNormal(szNormal)
  MessageList_PushOver(self.UIGROUP, self.szMessageListName)
end

function uiGlobalChat:LeftClick(nElemId)
  local tbElem = self.tbElemClass[nElemId]
  if tbElem and tbElem.LeftClick then
    tbElem:LeftClick()
  end
end

-- 拖动响应
function uiGlobalChat:OnScorllbarPosChanged(szWnd)
  local nGlobalWidth, nGlobalHeight = Wnd_GetSize(self.UIGROUP, "Main")
  Wnd_SetHeight(self.UIGROUP, self.szMessageListName, nGlobalHeight)
  Wnd_SetPos(self.UIGROUP, self.szMessageListName, 0, 20)

  local nX, nY = Wnd_GetPos(self.UIGROUP)
  Wnd_SetPos("UI_GLOBALCHATBUY", "Main", nX, nY)
  Wnd_SetPos("UI_GLOBALCHATEFFECT", "Main", nX, nY)
end

function uiGlobalChat:RegisterMessage()
  local tbRegMsg = {
    { Ui.MSG_MSGLIST_ELEM_CLICK, self.szMessageListName, self.LeftClick, self }, -- 鼠标点击触发按钮
    --{ Ui.MSG_MSGLIST_ELEM_RIGHTCLICK,		self.szMessageListName,	self.RightClick,		self },		-- 鼠标右键点击触发按钮
    --{ Ui.MSG_MSGLIST_ELEM_SHIFT_CLICK,		self.szMessageListName,	self.ShiftLeftClick,	self },		-- 鼠标SHIFT点击触发按钮
    --{ Ui.MSG_MSGLIST_ELEM_CTRL_LEFT_CLICK,	self.szMessageListName,	self.CtrlLeftClick,		self },		-- 鼠标CTRL 左键点击触发按钮
  }

  return tbRegMsg
end
