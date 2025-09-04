-----------------------------------------------------
--文件名		：	kinrequestlist.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-7-26
--功能描述		：	家族请求列表。
------------------------------------------------------

local uiKinRequestList = Ui:GetClass("kinrequestlist")
local tbMsgInfo = Ui.tbLogic.tbMsgInfo

uiKinRequestList.CLOSE_WINDOW_BUTTON = "BtnClose"
uiKinRequestList.REQUEST_LIST = "LstRequest"
uiKinRequestList.ACCEPT_BUTTON = "BtnAccept"
uiKinRequestList.REFUSE_BUTTON = "BtnRefuse"

function uiKinRequestList:OnOpen()
  local cKin = KKin.GetSelfKin()
  if cKin then
    if cKin.GetApplyQuitTime() ~= 0 and cKin.GetSelfQuitVoteState() == 0 then
      self:AddQuitTong(1)
    end
  end
  self:UpdateList()
end

function uiKinRequestList:UpdateList()
  Lst_Clear(self.UIGROUP, self.REQUEST_LIST)
  local tbRequestList = me.KinRequest_GetRequestList()
  if not tbRequestList then -- 为空则无数据，不需要插列表
    return 0
  end
  for nKey, tbData in pairs(tbRequestList) do
    Lst_SetCell(self.UIGROUP, self.REQUEST_LIST, nKey, 1, tbData.szMsg)
  end
  if me.IsAccountLock() == 0 then
    Wnd_SetEnable(self.UIGROUP, self.ACCEPT_BUTTON, 1)
    Wnd_SetEnable(self.UIGROUP, self.REFUSE_BUTTON, 1)
  else
    Wnd_SetEnable(self.UIGROUP, self.ACCEPT_BUTTON, 0)
    Wnd_SetEnable(self.UIGROUP, self.REFUSE_BUTTON, 0)
  end
end

function uiKinRequestList:OnButtonClick(szWnd, nParam)
  if szWnd == self.CLOSE_WINDOW_BUTTON then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.ACCEPT_BUTTON then
    local nIndex = Lst_GetCurKey(self.UIGROUP, self.REQUEST_LIST)
    if nIndex == 0 then
      return 0
    end
    self:OnHandleRequest(nIndex, 1)
  elseif szWnd == self.REFUSE_BUTTON then
    local nIndex = Lst_GetCurKey(self.UIGROUP, self.REQUEST_LIST)
    if nIndex == 0 then
      return 0
    end
    self:OnHandleRequest(nIndex, 0)
  end
end

function uiKinRequestList:OnHandleRequest(nIndex, nAccept)
  local tbRequest = self:GetRequest(nIndex)
  if not tbRequest then
    return
  end
  if tbRequest.nType == Kin.KIN_EVENT_INTRODUCE then
    me.CallServerScript({ "KinCmd", "AcceptIntroduce", tbRequest.nKey, nAccept })
  elseif tbRequest.nType == Kin.KIN_EVENT_KICK then
    me.CallServerScript({ "KinCmd", "MemberKickRespond", tbRequest.nKey, nAccept })
  elseif tbRequest.nType == Kin.KIN_EVENT_FIRE_CAPTAIN then
    if nAccept == 1 then
      me.CallServerScript({ "KinCmd", "FireCaptainVote" })
    end
  elseif tbRequest.nType == Kin.KIN_EVENT_QUIT_TONG then
    me.CallServerScript({ "KinCmd", "QuitTongVote", nAccept })
  elseif tbRequest.nType == Kin.KIN_EVENT_TAKE_FUND then
    me.CallServerScript({ "KinCmd", "AcceptExclusiveEvent", tbRequest.nKey, nAccept, tbRequest.nApplyMemberId })
  elseif tbRequest.nType == Kin.KIN_EVENT_SALARY then
    me.CallServerScript({ "KinCmd", "AcceptExclusiveEvent", tbRequest.nKey, nAccept, tbRequest.nApplyMemberId })
  elseif tbRequest.nType == Kin.KIN_EVENT_TAKE_REPOSITORY then
    me.CallServerScript({ "KinCmd", "AcceptExclusiveEvent", tbRequest.nKey, nAccept, tbRequest.nApplyMemberId })
  elseif tbRequest.nType == Kin.KIN_EVENT_BUYBADGE then
    me.CallServerScript({ "KinCmd", "AcceptExclusiveEvent", tbRequest.nKey, nAccept, tbRequest.nApplyMemberId })
  end
end

function uiKinRequestList:AddJoinRequest(nIntroducerId, nPlayerId, szPlayerName)
  local tbRequest = {}
  tbRequest.nKey = nPlayerId
  tbRequest.szMsg = "邀请[" .. szPlayerName .. "]加入家族。"
  tbRequest.nType = Kin.KIN_EVENT_INTRODUCE
  me.KinRequest_AddRequset(tbRequest)
  self:NotifyRequest()
end

function uiKinRequestList:AddKickRequest(nMemberId, szName)
  local tbRequest = {}
  tbRequest.szMsg = "开除[" .. szName .. "]出家族。"
  tbRequest.nKey = nMemberId
  tbRequest.nType = Kin.KIN_EVENT_KICK
  me.KinRequest_AddRequset(tbRequest)
  self:NotifyRequest()
end

function uiKinRequestList:AddFireCaptain(szName)
  local tbRequest = {}
  tbRequest.szMsg = "[" .. szName .. "]发起罢免族长"
  tbRequest.nType = Kin.KIN_EVENT_FIRE_CAPTAIN
  me.KinRequest_AddRequset(tbRequest)
  self:NotifyRequest()
end

function uiKinRequestList:AddQuitTong(bHide)
  local tbRequest = {}
  tbRequest.szMsg = "族长发起退出帮会"
  tbRequest.nType = self.KIN_EVENT_QUIT_TONG
  me.KinRequest_AddRequset(tbRequest, Kin.KIN_EVENT_QUIT_TONG)
  self:NotifyRequest(bHide)
end

function uiKinRequestList:NotifyRequest(bHide)
  if bHide ~= 1 then
    Ui("UI_TASKTIPS"):Begin("有新的家族申请，请在家族界面内“申请列表”中表决！")
    me.Msg("有新的家族申请，请在家族界面内“申请列表”中表决！")
    local tbMsg = {}
    tbMsg.nOptCount = 1
    tbMsg.szMsg = "有新的家族申请，请在家族界面内“申请列表”中表决！"
    tbMsgInfo:AddMsg(tbMsg.szMsg, tbParam)
  end
end

function uiKinRequestList:GetRequest(nIndex)
  local tbRequest = me.KinRequest_DelRequest(nIndex)
  Lst_RemoveLine(self.UIGROUP, self.REQUEST_LIST, nIndex)
  return tbRequest
end

function uiKinRequestList:AddTakeFundRequest(nKey, nMemberId, szPlayerName, nMoney)
  local tbRequestList = me.KinRequest_GetRequestList()
  if tbRequestList then -- 为空则无数据，不需要插列表
    for nIndex, tbTempRequest in pairs(tbRequestList) do
      if tbTempRequest.nType == Kin.KIN_EVENT_TAKE_FUND or tbTempRequest.nType == Kin.KIN_EVENT_SALARY then
        me.KinRequest_DelRequest(nIndex)
        Lst_RemoveLine(self.UIGROUP, self.REQUEST_LIST, nIndex)
      end
    end
  end
  local tbRequest = {}
  tbRequest.nKey = nKey
  tbRequest.nApplyMemberId = nMemberId
  tbRequest.szMsg = "[" .. szPlayerName .. "]申请取出" .. nMoney .. "两家族资金"
  tbRequest.nType = Kin.KIN_EVENT_TAKE_FUND
  me.KinRequest_AddRequset(tbRequest)
  self:NotifyRequest()
end

function uiKinRequestList:AddSalaryRequest(nKey, nMemberId, szPlayerName, nMoney)
  local tbRequestList = me.KinRequest_GetRequestList()
  if tbRequestList then -- 为空则无数据，不需要插列表
    for nIndex, tbTempRequest in pairs(tbRequestList) do
      if tbTempRequest.nType == Kin.KIN_EVENT_TAKE_FUND or tbTempRequest.nType == Kin.KIN_EVENT_SALARY then
        me.KinRequest_DelRequest(nIndex)
        Lst_RemoveLine(self.UIGROUP, self.REQUEST_LIST, nIndex)
      end
    end
  end
  local tbRequest = {}
  tbRequest.nKey = nKey
  tbRequest.nApplyMemberId = nMemberId
  tbRequest.szMsg = "[" .. szPlayerName .. "]申请发放出勤奖励共" .. nMoney .. "两"
  tbRequest.nType = Kin.KIN_EVENT_SALARY
  me.KinRequest_AddRequset(tbRequest)
  self:NotifyRequest()
end

function uiKinRequestList:AddTakeRepositoryRequest(nKey, nMemberId, szPlayerName)
  -- 如果不是管理员就不要发申请了
  if KinRepository.nAuthority and KinRepository.nAuthority < KinRepository.AUTHORITY_ASSISTANT then
    return
  end
  local tbRequest = {}
  tbRequest.szMsg = "[" .. szPlayerName .. "]申请仓库取东西权限"
  tbRequest.nKey = nKey
  tbRequest.nApplyMemberId = nMemberId
  tbRequest.nType = Kin.KIN_EVENT_TAKE_REPOSITORY
  me.KinRequest_AddRequset(tbRequest, Kin.KIN_EVENT_TAKE_REPOSITORY)
  self:NotifyRequest()
end

-- 购买徽章申请
function uiKinRequestList:AddBuyBadgeRequest(nKey, nMemberId, szPlayerName, nMoney, nRate)
  local tbRequestList = me.KinRequest_GetRequestList()
  if tbRequestList then -- 为空则无数据，不需要插列表
    for nIndex, tbTempRequest in pairs(tbRequestList) do
      if tbTempRequest.nType == Kin.KIN_EVENT_BUYBADGE then
        me.KinRequest_DelRequest(nIndex)
        Lst_RemoveLine(self.UIGROUP, self.REQUEST_LIST, nIndex)
      end
    end
  end
  local tbRequest = {}
  tbRequest.nKey = nKey
  tbRequest.nApplyMemberId = nMemberId
  tbRequest.szMsg = "[" .. szPlayerName .. "]申请取出" .. nMoney .. "两家族资金，购买一个" .. nRate .. "级徽章"
  tbRequest.nType = Kin.KIN_EVENT_BUYBADGE
  me.KinRequest_AddRequset(tbRequest)
  self:NotifyRequest()
end

function uiKinRequestList:OnClose()
  Ui(Ui.UI_KIN).nShowRequestList = 0
end
