local tbMessageList = Ui.tbLogic.tbMessageList or {}
Ui.tbLogic.tbMessageList = tbMessageList
local tbMsgChannel = Ui.tbLogic.tbMsgChannel

tbMessageList.MAX_LINECOUNT = 100
tbMessageList.MAX_FULLDELCOUNT = 20
tbMessageList.tbForbidName = { "系统", "公告" }

function tbMessageList:Init()
  self.tbElemClass = {}
  self.tbMsgCount = {}
  self.nMessageCount = 0
  self.nCurDelIndex = 1
  self.szMessageListName = ""
  self.tbTeamApplyMsg = {}
end

function tbMessageList:Clear()
  for nId, tbElem in pairs(self.tbElemClass) do
    if tbElem then
      tbElem:Clear()
    end
    self.tbElemClass[nId] = nil
  end

  self.tbElemClass = {}
  self.tbMsgCount = {}
  self.nMessageCount = 0
  self.nCurDelIndex = 1
  self.tbTeamApplyMsg = {}
end

function tbMessageList:FindLink(szMsg)
  local tbParams = {}

  local nBegin, nEnd, szName, szParam = string.find(szMsg, "<([^<>]-)=([^<>]-)>")
  if nBegin and nEnd and szParam then
    tbParams = Lib:SplitStr(szParam, ",")
  end

  return szName, nBegin, nEnd, tbParams
end

function tbMessageList:AddOneMsg(tbMsg)
  MessageList_AddNewLine(self.UIGROUP, self.szMessageListName)
  self.nMessageCount = self.nMessageCount + 1
  self.tbMsgCount[self.nMessageCount] = {}

  self:AddElemNormal({ tbMsg.szChannelPic, tbMsg.szColor, tbMsg.szBorderColor, tbMsg.tbSendName.nIsSystem })

  if not tbMsg.szMsg then
    return
  end
  local szHead = string.sub(tbMsg.szMsg, 1, 1)
  if szHead == "#" then
    local szEmote = string.sub(tbMsg.szMsg, 2, -1)
    local szNewEmote = AddEmoteMsg(szEmote, tbMsg.tbSendName.szSendName)
    if szNewEmote then
      self:AddElemNormal({ szNewEmote, tbMsg.szColor, tbMsg.szBorderColor, tbMsg.tbSendName.nIsSystem })
      MessageList_PushOver(self.UIGROUP, self.szMessageListName)
      self:TakeCount()
      return
    end
  end

  if tbMsg.tbSendName.nIsSystem == 1 then
    local szSendName = tbMsg.tbSendName.szSendName
    if szSendName ~= "" then
      szSendName = szSendName .. ":"
      self:AddElemNormal({ szSendName, "white", "black", tbMsg.tbSendName.nIsSystem })
    end
  else
    local szSendName = tbMsg.szRealName
    if tbMsg.nSpeTitle and tbMsg.nSpeTitle > 0 and tbMsgChannel.tbGVSprChat[tbMsg.nSpeTitle] then
      szSendName = "<pic=" .. tbMsgChannel.tbGVSprChat[tbMsg.nSpeTitle] .. ">" .. szSendName
    end
    if tbMsg.szChannelName == tbMsgChannel.CHANNEL_GLOBAL or tbMsg.szChannelName == tbMsgChannel.CHANNEL_PERSONAL then
      if tbMsg.szGatewayName and tbMsg.szGatewayName ~= "" then
        szSendName = tbMsg.szGatewayName .. szSendName
      end
    end
    local bSucc, nElemId = self:AddElemName({ szSendName, tbMsg.szColor, tbMsg.szBorderColor, tbMsg.szMsg, tbMsg.tbSendName.nIsSystem, tbMsg.szChannelName })
    self.tbElemClass[nElemId].bDisableMenu = tbMsg.bDisableMenu
    self.tbElemClass[nElemId].bGlobalPrivateMsg = tbMsg.bGlobalPrivateMsg
    self.tbElemClass[nElemId].szGateway = tbMsg.szGateway
    self.tbElemClass[nElemId].szRealName = tbMsg.szRealName
  end

  local szTemp = tbMsg.szMsg
  local szElemName, nBegin, nEnd, tbLinkParams = self:FindLink(szTemp)
  local szNormal = ""
  while szElemName do
    if nBegin ~= 1 then
      szNormal = szNormal .. string.sub(szTemp, 1, nBegin - 1)
    end
    if self:IsTradeLink(szElemName) == 1 then
      if szNormal then
        self:AddElemNormal({ szNormal, tbMsg.szColor, tbMsg.szBorderColor, tbMsg.tbSendName.nIsSystem })
      end
      self:AddMsgElem(szElemName, { tbLinkParams, tbMsg.szColor, tbMsg.szBorderColor, bFiterColor, tbMsg.tbSendName.nIsSystem })
      szNormal = ""
    else
      szNormal = szNormal .. string.sub(szTemp, nBegin, nEnd)
    end

    szTemp = string.sub(szTemp, nEnd + 1)
    szElemName, nBegin, nEnd, tbLinkParams = tbMessageList:FindLink(szTemp)
  end

  if szTemp then
    -- 非GM频道，过滤换行符，限制显示长度
    if tbMsg.szChannelName ~= "GM" then
      szTemp = string.gsub(szTemp, "\r", "")
      szTemp = string.gsub(szTemp, "\n", "")
      if string.len(szTemp) > 144 then
        szTemp = string.sub(szTemp, 1, 144)
      end
    end
    szNormal = szNormal .. szTemp
    self:AddElemNormal({ szNormal, tbMsg.szColor, tbMsg.szBorderColor, tbMsg.tbSendName.nIsSystem })
    -- 根据敏感词汇，添加官方提示
    if tbMsg.szChannelName ~= "GM" then
      local nFlag = UiManager:CheckNeedAddWarring(szTemp)
      if nFlag ~= 0 then
        local szWarring = "  <color=yellow>[官方提示]非官方公告切勿相信，请注意保管好自己的财产。<color>"
        self:AddElemNormal({ szWarring, "yellow", tbMsg.szBorderColor, tbMsg.tbSendName.nIsSystem })
      end
    end
  end
  self:AddNoFriendWarring(tbMsg)
  MessageList_PushOver(self.UIGROUP, self.szMessageListName)
  self:TakeCount()
end

function tbMessageList:AddNoFriendWarring(tbMsg)
  if me.GetHonorLevel() >= 6 and (tbMsg.szChannelName == "Me" or tbMsg.szChannelName == "Personal") then
    local szRealName = tbMsg.szRealName
    local tbRelationList = me.Relation_GetRelationList() or {}
    local tbList = {
      Player.emKPLAYERRELATION_TYPE_BIDFRIEND,
      Player.emKPLAYERRELATION_TYPE_COUPLE,
      Player.emKPLAYERRELATION_TYPE_BUDDY,
      Player.emKPLAYERRELATION_TYPE_TRAINING,
      Player.emKPLAYERRELATION_TYPE_TRAINED,
      Player.emKPLAYERRELATION_TYPE_INTRODUCTION,
    }
    local nFriend = 0
    for _, nType in pairs(tbList) do
      if tbRelationList[nType] and tbRelationList[nType][szRealName] then
        nFriend = 1
        break
      end
    end

    if nFriend == 0 then
      local tbFriendList = me.GlobalFriends_GetList() or {}
      if tbFriendList[szRealName] then
        nFriend = 1
      end
    end

    if nFriend == 0 then
      local szWarring = " [陌生人]"
      self:AddElemNormal({ szWarring, "greenyellow", "black", tbMsg.tbSendName.nIsSystem })
    end
  end
end

function tbMessageList:TakeCount()
  if self.nMessageCount - self.nCurDelIndex >= self.MAX_LINECOUNT then
    for i = 1, self.MAX_FULLDELCOUNT do
      for i, nElemId in pairs(self.tbMsgCount[self.nCurDelIndex]) do
        if nElemId and self.tbElemClass[nElemId] then
          if self.tbElemClass[nElemId].Clear then
            self.tbElemClass[nElemId]:Clear()
          end

          self.tbElemClass[nElemId] = nil
        end
      end
      self.tbMsgCount[self.nCurDelIndex] = nil
      self.nCurDelIndex = self.nCurDelIndex + 1

      MessageList_PopUpOne(self.UIGROUP, self.szMessageListName)
    end
  end
end

function tbMessageList:IsTradeLink(szName)
  if not self.tbBaseClass[szName] then
    return 0
  end

  return 1
end

function tbMessageList:AddElemName(tbInfo)
  return self:AddMsgElem("name", tbInfo)
end

function tbMessageList:AddElemNormal(tbInfo)
  return self:AddMsgElem("normal", tbInfo)
end

function tbMessageList:AddMsgElem(szName, tbInfo)
  if not self.tbBaseClass[szName] then
    return 0
  end

  local tbNewElem = Lib:NewClass(self.tbBaseClass[szName])
  tbNewElem.tbManager = self
  local nElemId = tbNewElem:Init(tbInfo)

  self.tbElemClass[nElemId] = tbNewElem
  table.insert(self.tbMsgCount[self.nMessageCount], nElemId)
  if szName == "teamapply" then
    self.tbTeamApplyMsg[nElemId] = self.nMessageCount
  end
  return 1, nElemId
end

function tbMessageList:FormatMsg(szMsg)
  local szShowMsg = ""
  local szTempMsg = szMsg
  local szElemName, nStart, nEnd, tbLinPrarms = self:FindLink(szTempMsg)

  while szElemName and nStart and nEnd do
    if nStart ~= 1 then
      szShowMsg = szShowMsg .. string.sub(szTempMsg, 1, nStart - 1)
    end

    if self.tbBaseClass[szElemName] and self.tbBaseClass[szElemName].GetShowMsg then
      szShowMsg = szShowMsg .. self.tbBaseClass[szElemName]:GetShowMsg(tbLinPrarms)
    else
      szShowMsg = szShowMsg .. string.sub(szTempMsg, nStart, nEnd)
    end

    szTempMsg = string.sub(szTempMsg, nEnd + 1)
    szElemName, nStart, nEnd, tbLinPrarms = self:FindLink(szTempMsg)
  end

  if szTempMsg then
    szShowMsg = szShowMsg .. szTempMsg
  end

  return szShowMsg
end

function tbMessageList:LeftClick(nElemId)
  local tbElem = self.tbElemClass[nElemId]
  if tbElem and tbElem.LeftClick then
    tbElem:LeftClick()
  end
end

function tbMessageList:ShiftLeftClick(nElemId)
  local tbElem = self.tbElemClass[nElemId]
  if tbElem and tbElem.ShiftLeftClick then
    tbElem:ShiftLeftClick()
  end
end

function tbMessageList:CtrlLeftClick(nElemId)
  local tbElem = self.tbElemClass[nElemId]
  if tbElem and tbElem.CtrlLeftClick then
    tbElem:CtrlLeftClick()
  end
end

function tbMessageList:RightClick(nElemId)
  local tbElem = self.tbElemClass[nElemId]
  if tbElem and tbElem.RightClick then
    tbElem:RightClick()
  end
end

function tbMessageList:ModifyTeamLinkInfo(nPlayerId, nTeamId, nTeamNum, szTeamName)
  local tbDelElem = {}
  for nElemId, nLine in pairs(self.tbTeamApplyMsg) do
    local tbElem = self.tbElemClass[nElemId]
    if tbElem and tbElem.tbInfo then
      if nTeamId == tbElem.tbInfo.nTeamId then
        local nFlagDisable = 0
        local szText = ""
        if nTeamNum <= 0 then
          szText = string.format("<申请入队：队伍解散>")
          nFlagDisable = 1
          tbElem.tbInfo.nTeamId = 0
        elseif nTeamNum >= 6 then
          szText = string.format("<申请入队：队伍满员>")
          nFlagDisable = 1
          tbElem.tbInfo.nTeamId = 0
        else
          szText = string.format("<申请入队：队伍未满>")
        end

        tbElem.tbInfo.szDesc = szText
        tbElem.tbInfo.nPlayerId = nPlayerId
        tbElem.tbInfo.szTeamName = szTeamName
        MessageList_ModifyMsg(self.UIGROUP, self.szMessageListName, nLine, nElemId, szText, 0, nFlagDisable)
        if nTeamNum <= 0 or nTeamNum >= 6 then
          table.insert(tbDelElem, nElemId)
        end
      end
    else
      table.insert(tbDelElem, nElemId)
    end
  end

  for i, nElemId in pairs(tbDelElem) do
    self.tbTeamApplyMsg[nElemId] = nil
  end
end

function tbMessageList:RegisterBaseClass(szName, tbClass)
  if not szName then
    return
  end

  if not self.tbBaseClass then
    self.tbBaseClass = {}
  end

  self.tbBaseClass[szName] = tbClass
end

function tbMessageList:RegisterMouseMessage()
  local tbRegMsg = {
    { Ui.MSG_MSGLIST_ELEM_CLICK, self.szMessageListName, self.LeftClick, self }, -- 鼠标点击触发按钮
    { Ui.MSG_MSGLIST_ELEM_RIGHTCLICK, self.szMessageListName, self.RightClick, self }, -- 鼠标右键点击触发按钮
    { Ui.MSG_MSGLIST_ELEM_SHIFT_CLICK, self.szMessageListName, self.ShiftLeftClick, self }, -- 鼠标SHIFT点击触发按钮
    { Ui.MSG_MSGLIST_ELEM_CTRL_LEFT_CLICK, self.szMessageListName, self.CtrlLeftClick, self }, -- 鼠标CTRL 左键点击触发按钮
  }

  return tbRegMsg
end
