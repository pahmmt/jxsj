-----------------------------------------------------
--文件名		：	uicallback.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-04-19
--功能描述		：	界面回调脚本。临时过渡使用，要用UiNotify机制完全代替他
------------------------------------------------------

function UiCallback:OnTeamDataChanged(nParam)
  Ui(Ui.UI_TEAM):TeamInfoChangedCallback()
  Ui(Ui.UI_TREASUREMAP):TeamInfoChanged()
  if nParam > 0 then
    UiManager:OpenWindow(Ui.UI_TEAMPORTRAIT)
  else
    UiManager:CloseWindow(Ui.UI_TEAMPORTRAIT)
  end
end

function UiCallback:OnQuestionAndAnswer(szQuestion, tbAnswers)
  UiManager:OpenWindow(Ui.UI_SAYPANEL, { szQuestion, tbAnswers })
end

function UiCallback:OnMsgArrival(nChannelID, szSendName, szMsg)
  local nLogType = self.nChatMsgLog
  if nLogType == 1 then
    self:DbgOut("ChatMsg", nChannelID, szSendName, szMsg)
  elseif nLogType == 2 then
    self:WriteLog(Dbg.LOG_INFO, "ChatMsg", nChannelID, szSendName, szMsg)
  end
end

function UiCallback:OnCurChannel()
  local tbTempData = Ui.tbLogic.tbTempData
  return tbTempData.nCurChannel
end

function UiCallback:GetTableCount(szTableName)
  local tbTempData = Ui.tbLogic.tbTempData
  return #tbTempData[szTableName]
end

function UiCallback:GetTableStr(szTableName, nIndex)
  local tbTempData = Ui.tbLogic.tbTempData
  return tbTempData[szTableName][nIndex]
end

function UiCallback:GetMailNewFlag()
  local tbTempData = Ui.tbLogic.tbTempData
  return tbTempData.nMailNewFlag
end

--function UiCallback:IsNeedAgree()
--	if (IVER_g_nTwVersion == 1) then
--		return UiManager.bAgreementFlag or 0;
--	end
--	return Ui.tbLogic.tbAgreementMgr:IsAgree();
--end
--
--function UiCallback:IsAgree()
--	return Ui.tbLogic.tbAgreementMgr:IsAgree();
--end
--
--function UiCallback:OpenAgreement()
--	UiManager:OpenWindow(Ui.UI_AGREEMENT);
--end

function UiCallback:LinkPreView(nItemGenre, nDetailType, nParticularType, nLevel, nSeries)
  local tbPreViewMgr = Ui.tbLogic.tbPreViewMgr
  tbPreViewMgr:LinkToPreView(nItemGenre, nDetailType, nParticularType, nLevel, nSeries)
end

function UiCallback:LinkAuction(szKey, nPrice, tbItemInfo)
  local tbAcutionLink = Ui.tbLogic.tbAcutionLink
  tbAcutionLink:OnePriceBuy(szKey, nPrice, tbItemInfo)
end

function UiCallback:PlayRec(szRecFilePath)
  Replay("play", szRecFilePath)
end

function UiCallback:ViewNpcInfo(nNpcId)
  local tbTemp = me.GetTempTable("Npc")
  if not tbTemp.tbViewPlayer then
    tbTemp.tbViewPlayer = {}
  end
  tbTemp.tbViewPlayer.nNpcId = nNpcId
  UiManager:OpenWindow(Ui.UI_VIEWPLAYER, nNpcId)
end

function UiCallback:PushSendMsg(nChannelId, szMsg)
  return Ui.tbLogic.tbMsgChannel:PushSendMsg(nChannelId, szMsg)
end

function UiCallback:GetSendMsg()
  return Ui.tbLogic.tbMsgChannel:GetSendMsg()
end

-----------------------------------------------------------------------------------------------
--外接查询频道栏的接口
function UiCallback:IsDynChannel(nChannelId)
  return Ui.tbLogic.tbMsgChannel:IsDynChannel(nChannelId)
end

function UiCallback:GetChannelCount()
  return Ui.tbLogic.tbMsgChannel:GetChannelCount()
end

function UiCallback:GetChannelNameByIndex(nIndex)
  return Ui.tbLogic.tbMsgChannel:GetChannelNameByIndex(nIndex)
end

function UiCallback:GetChannelNameByMenuText(szChannelText)
  return Ui.tbLogic.tbMsgChannel:GetChannelNameByMenuText(szChannelText)
end

function UiCallback:GetChannelIdByMenuText(szChannelText)
  return Ui.tbLogic.tbMsgChannel:GetChannelIdByMenuText(szChannelText)
end

function UiCallback:SetCurrentChannel(szChannelName)
  return Ui.tbLogic.tbMsgChannel:GetChannelIdByMenuText(szChannelText)
end

function UiCallback:GetShortTxtPicByChannelName(szChannelName)
  return Ui.tbLogic.tbMsgChannel:GetShortTxtPicByChannelName(szChannelName)
end

function UiCallback:GetPersonalMenuinfo()
  return Ui.tbLogic.tbMsgChannel:GetPersonalMenuinfo()
end

function UiCallback:GetTeamLinkInfo()
  local nPlayerId = 0
  local szName = ""
  local nTeamNum = 0
  local nAllotModel, tbMemberList = me.GetTeamInfo()

  if not tbMemberList then
    return "", 0, 0
  end

  local nTeamId = me.nTeamId

  for i = 1, #tbMemberList do
    if tbMemberList[i].szName and tbMemberList[i].nPlayerID then
      if tbMemberList[i].nLeader == 1 then
        nPlayerId = tbMemberList[i].nPlayerID
        szName = tbMemberList[i].szName
        nTeamNum = #tbMemberList
        break
      end
    end
  end

  return szName, nPlayerId, nTeamId, nTeamNum
end

function UiCallback:PushSendMsgTeamLinkInfo(szChannelName)
  local nPlayerId = 0
  local nAllotModel, tbMemberList = me.GetTeamInfo()

  if not tbMemberList then
    return "", 0, 0
  end

  if szChannelName ~= "帮会频道" and szChannelName ~= "家族频道" then
    return
  end

  for i = 1, #tbMemberList do
    if tbMemberList[i].szName and tbMemberList[i].nPlayerID then
      if tbMemberList[i].nLeader == 1 then
        nPlayerId = tbMemberList[i].nPlayerID
        break
      end
    end
  end
  local nKinId = 0
  local nTongId = 0
  local bTong = 0
  if szChannelName == "帮会频道" then
    nTongId = me.dwTongId
  elseif szChannelName == "家族频道" then
    nKinId = me.dwKinId
  end
  me.CallServerScript({ "ApplyAddNewTeamLink", me.nTeamId, nPlayerId, nKinId, nTongId })

  return
end

function UiCallback:GetCloseTeamLinkFlag()
  return tonumber(KGblTask.SCGetDbTaskInt(DBTASK_CLOASE_TEAMLINK)) or 0
end

function UiCallback:GetAutoTeamJoinFlag()
  return Ui.tbLogic.tbTempData.nAutoTeamFlag or 0
end

function UiCallback:ModifyTeamLinkInfo(nPlayerId, nTeamId, nTeamNum, szTeamName)
  Ui(Ui.UI_MSGPAD):ModifyTeamLinkInfo(nPlayerId, nTeamId, nTeamNum, szTeamName)
end

function UiCallback:GetChannelIndexByChannelName(szChannelName)
  local nIndex = Ui.tbLogic.tbMsgChannel:GetChannelIndexByChannelName(szChannelName)
  if nIndex == -1 then
    return -1
  else
    return nIndex - 1
  end
end

function UiCallback:GetChannelIndexByMenuText(szMenuText)
  local nIndex = Ui.tbLogic.tbMsgChannel:GetChannelIndexByMenuText(szMenuText)
  if not nIndex then
    return -1
  end
  return nIndex - 1
end

function UiCallback:GetChannelMenuTextByIndex(nIndex)
  return Ui.tbLogic.tbMsgChannel:GetChannelMenuTextByIndex(nIndex + 1)
end

function UiCallback:GetChannelCostByIndex(nIndex)
  return Ui.tbLogic.tbMsgChannel:GetChannelCostByIndex(nIndex + 1)
end

function UiCallback:GetChannelIdByIndex(nIndex)
  return Ui.tbLogic.tbMsgChannel:GetChannelIdByIndex(nIndex + 1)
end

function UiCallback:GetAchievementMsgInfo(szMsg)
  return Ui.tbLogic.tbMsgChannel:GetAchievementMsgInfo(szMsg)
end

function UiCallback:GetChannelIdByChannelName(szChannelName)
  return Ui.tbLogic.tbMsgChannel:GetChannelIdByChannelName(szChannelName)
end

function UiCallback:GetChannelMenuinfo(nIndex)
  return Ui.tbLogic.tbMsgChannel:GetChannelMenuinfo(nIndex + 1)
end

function UiCallback:IsGmChannelByIndex(nIndex)
  return Ui.tbLogic.tbMsgChannel:IsGmChannelByIndex(nIndex + 1)
end

---------------------------------------------------------------------------------------
--外接查询接口完毕，为兼容旧代码 :~(

function UiCallback:QueryAllChannel()
  return Ui.tbLogic.tbMsgChannel:QueryAllChannel()
end

function UiCallback:DelActiveChannel(szChannelName)
  return Ui.tbLogic.tbMsgChannel:DelActiveChannel(szChannelName)
end

function UiCallback:HideMsgPad()
  Wnd_Hide("UI_MSGPAD", "Main")
  UiManager:CloseWindow("UI_CHATTAB")
end

function UiCallback:ShowMsgPad()
  Wnd_Show("UI_MSGPAD", "Main")
  UiManager:OpenWindow("UI_CHATTAB")
end
