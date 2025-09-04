-----------------------------------------------------
--文件名		：	Confirm.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-7-24
--功能描述		：	其他确认消息（没地方去的那些）。
------------------------------------------------------

Ui.tbLogic.tbConfirm = {}

local tbConfirm = Ui.tbLogic.tbConfirm
local tbMsgInfo = Ui.tbLogic.tbMsgInfo
local tbTempData = Ui.tbLogic.tbTempData

tbConfirm.MAKE_KEY = -- Key的生成规则
  {
    [UiNotify.CONFIRMATION_TEAM_RECEIVE_INVITE] = { "%s,%d", 1, 2 }, -- szPlayer, nPlayerId
    [UiNotify.CONFIRMATION_TEAM_APPLY_ADD] = { "%s,%d", 1, 2 }, -- szPlayer, nPlayerId
    [UiNotify.CONFIRMATION_TRADE_RECEIVE_REQUEST] = { "%s", 1 }, -- szPlayer
    [UiNotify.CONFIRMATION_TRADE_SEND_REQUEST] = { "%s", 1 }, -- szPlayer
    [UiNotify.CONFIRMATION_KIN_INVITE_ADD] = { "%d,%d", 1, 2 }, -- nKinId, nInvitorId
    [UiNotify.CONFIRMATION_KIN_INTRODUCE] = { "%d,%d", 1, 2 }, -- nKinId, nInvitorId
    [UiNotify.CONFIRMATION_KIN_CONVECTION] = { "%s", 1 }, -- szPlayer
    [UiNotify.CONFIRMATION_TONG_APPLY_JOIN] = { "%d,%d", 1, 2 }, -- nKinId, nInvitorId
    [UiNotify.CONFIRMATION_TONG_INVITE_ADD] = { "%d,%s,%s", 1, 2, 3 }, -- nPlayerId, szTong, szPlayer
    [UiNotify.CONFIRMATION_RELATION_TMPFRIEND] = { "%s", 1 }, -- szPlayer
    [UiNotify.CONFIRMATION_RELATION_BLACKLIST] = { "" },
    [UiNotify.CONFIRMATION_RELATION_BINDFRIEND] = { "%s", 1 }, -- szPlayer
    [UiNotify.CONFIRMATION_TEACHER_APPLY_TEACHER] = { "%s", 1 }, -- szPlayer
    [UiNotify.CONFIRMATION_TEACHER_APPLY_STUDENT] = { "%s", 1 }, -- szPlayer
    [UiNotify.CONFIRMATION_TEACHER_CONVECTION] = { "%s", 1 }, -- szPlayer
    [UiNotify.CONFIRMATION_COUPLE_CONVECTION] = { "%s, %s", 1, 2 }, -- szPlayer, szPlayer
    [UiNotify.CONFIRMATION_PK_EXERCISE_INVITE] = { "%s,%d", 1, 2 }, -- szPlayer, nPlayerId
  }

tbConfirm.PROCESS = -- 处理函数名
  {
    [UiNotify.CONFIRMATION_TEAM_RECEIVE_INVITE] = "OnTeamReceiveInvite",
    [UiNotify.CONFIRMATION_TEAM_APPLY_ADD] = "OnTeamApplyAdd",
    [UiNotify.CONFIRMATION_TRADE_RECEIVE_REQUEST] = "OnTradeReceiveRequest",
    [UiNotify.CONFIRMATION_TRADE_SEND_REQUEST] = "OnTradeSendRequest",
    [UiNotify.CONFIRMATION_KIN_INVITE_ADD] = "OnKinInviteAdd",
    [UiNotify.CONFIRMATION_KIN_INTRODUCE] = "OnKinIntroduce",
    [UiNotify.CONFIRMATION_KIN_CONVECTION] = "OnKinConvection",
    [UiNotify.CONFIRMATION_TONG_APPLY_JOIN] = "OnTongApplyJoin",
    [UiNotify.CONFIRMATION_TONG_INVITE_ADD] = "OnTongInviteAdd",
    [UiNotify.CONFIRMATION_RELATION_TMPFRIEND] = "OnRelationTmpFriend",
    [UiNotify.CONFIRMATION_RELATION_BLACKLIST] = "OnRelationBlackList",
    [UiNotify.CONFIRMATION_RELATION_BINDFRIEND] = "OnRelationBindFriend",
    [UiNotify.CONFIRMATION_TEACHER_APPLY_TEACHER] = "OnTeacherApplyTeacher",
    [UiNotify.CONFIRMATION_TEACHER_APPLY_STUDENT] = "OnTeacherApplyStudent",
    [UiNotify.CONFIRMATION_TEACHER_CONVECTION] = "OnTeacherConvection",
    [UiNotify.CONFIRMATION_COUPLE_CONVECTION] = "OnCoupleConvection",
    [UiNotify.CONFIRMATION_PK_EXERCISE_INVITE] = "OnPkExerciseInvite",
  }

function tbConfirm:MakeKey(nCfmId, ...)
  local tbInfo = self.MAKE_KEY[nCfmId]
  if not tbInfo then
    return ""
  end
  local tbParam = {}
  for i = 2, #tbInfo do
    table.insert(tbParam, arg[tbInfo[i]])
  end
  return string.format("<<CONFIRM>>::%d$$" .. (tbInfo[1] or ""), nCfmId, unpack(tbParam))
end

function tbConfirm:OnConfirm(nCfmId, ...)
  local fnProc = self[self.PROCESS[nCfmId] or ""]
  if type(fnProc) ~= "function" then
    return
  end
  local szKey = self:MakeKey(nCfmId, unpack(arg))
  fnProc(self, szKey, unpack(arg))
end

function tbConfirm:OnTeamReceiveInvite(szKey, szPlayer, nPlayerId)
  local tbMsg = {}

  if 1 == tbTempData.nDisableTeam then
    return
  end

  tbMsg.nOptCount = 2
  tbMsg.tbOptTitle = { "拒绝", "接受" }
  tbMsg.szMsg = szPlayer .. "邀请您加入队伍。\n<a=Black>将此人加入黑名单<a>"
  tbMsg.tbFun = {}
  function tbMsg.tbFun:Link_Black_OnClick()
    UiManager:CloseWindow(self.UIGROUP)
    Relation:OnAddRelation(szPlayer, Player.emKPLAYERRELATION_TYPE_BLACKLIST)
  end
  function tbMsg:Callback(nOptIndex, szPlayer, nPlayerId)
    me.TeamReplyInvite(nOptIndex - 1, nPlayerId, szPlayer) -- 1：接受 0：拒绝
  end
  tbMsgInfo:AddMsg(szKey, tbMsg, szPlayer, nPlayerId)
end

function tbConfirm:OnTeamApplyAdd(szKey, szPlayer, nPlayerId)
  local tbMsg = {}

  if 1 == tbTempData.nDisableTeam then
    return
  end

  tbMsg.nOptCount = 2
  tbMsg.tbOptTitle = { "拒绝", "接受" }
  tbMsg.szMsg = szPlayer .. "申请加入您的队伍\n<a=Black>将此人加入黑名单<a>"
  tbMsg.tbFun = {}
  function tbMsg.tbFun:Link_Black_OnClick()
    UiManager:CloseWindow(self.UIGROUP)
    Relation:OnAddRelation(szPlayer, Player.emKPLAYERRELATION_TYPE_BLACKLIST)
  end
  function tbMsg:Callback(nOptIndex, szPlayer, nPlayerId)
    me.TeamReplyApply(nOptIndex - 1, nPlayerId, szPlayer) -- 1：接受 0：拒绝
  end
  tbMsgInfo:AddMsg(szKey, tbMsg, szPlayer, nPlayerId)
end

-- 在交易对象前加上社会关系前缀（好友、队友）
function tbConfirm:GetTradePlayerNameEx(szTradePlayer)
  local szPlayerEx = szTradePlayer
  local nIsFriend = Relation:IsFriend(szTradePlayer)
  local nIsTeammate = Relation:IsTeammate(szTradePlayer)
  local nIsCouple = Relation:IsCouple(szTradePlayer)
  local nIsBuddy = Relation:IsBuddy(szTradePlayer)
  local nIsTrain = Relation:IsTrainRelation(szTradePlayer)
  local szColor = Ui.tbLogic.tbMsgChannel.TB_TEXT_COLOR[Ui.tbLogic.tbMsgChannel.CHANNEL_NEAR]
  local nStranger = 0

  if 1 == nIsFriend then
    szColor = Ui.tbLogic.tbMsgChannel.TB_TEXT_COLOR[Ui.tbLogic.tbMsgChannel.CHANNEL_FRIEND]
    szPlayerEx = string.format("[好友]%s", szPlayerEx)
  elseif 1 == nIsCouple then
    szColor = Ui.tbLogic.tbMsgChannel.TB_TEXT_COLOR[Ui.tbLogic.tbMsgChannel.CHANNEL_FRIEND]
    szPlayerEx = string.format("[侠侣]%s", szPlayerEx)
  elseif 1 == nIsBuddy then
    szColor = Ui.tbLogic.tbMsgChannel.TB_TEXT_COLOR[Ui.tbLogic.tbMsgChannel.CHANNEL_FRIEND]
    szPlayerEx = string.format("[密友]%s", szPlayerEx)
  elseif 1 == nIsTrain then
    szColor = Ui.tbLogic.tbMsgChannel.TB_TEXT_COLOR[Ui.tbLogic.tbMsgChannel.CHANNEL_FRIEND]
    szPlayerEx = string.format("[师徒]%s", szPlayerEx)
  elseif 1 == nIsTeammate then
    szColor = Ui.tbLogic.tbMsgChannel.TB_TEXT_COLOR[Ui.tbLogic.tbMsgChannel.CHANNEL_TEAM]
    szPlayerEx = string.format("[队友]%s", szPlayerEx)
  else
    nStranger = 1
  end
  szPlayerEx = string.format("<color=%s>%s<color>", szColor, szPlayerEx)
  return szPlayerEx, nStranger
end

function tbConfirm:OnTradeReceiveRequest(szKey, szPlayer, bCancel)
  local tbMsg = {}
  if 1 == tbTempData.nDisableStall then
    return
  end

  tbMsg.nOptCount = 2
  tbMsg.tbOptTitle = { "拒绝", "接受" }
  if bCancel ~= 1 then
    local szPlayerEx, bStranger = self:GetTradePlayerNameEx(szPlayer)
    local szSuffix = ""
    if 1 == bStranger then
      szSuffix = "<color=gold>请核对对方姓名，防止受骗。<color>"
    end
    tbMsg.szMsg = szPlayerEx .. "(<a=Black>加入黑名单<a>) 申请与您交易！" .. szSuffix
    tbMsg.tbFun = {}
    function tbMsg.tbFun:Link_Black_OnClick()
      UiManager:CloseWindow(self.UIGROUP)
      Relation:OnAddRelation(szPlayer, Player.emKPLAYERRELATION_TYPE_BLACKLIST)
    end
    function tbMsg:Callback(nOptIndex, szPlayer, x)
      me.TradeResponse(szPlayer, nOptIndex - 1) -- 1：接受 0：拒绝
    end
    tbMsgInfo:AddMsg(szKey, tbMsg, szPlayer, 1)
  else
    me.Msg(szPlayer .. "取消了交易请求！")
    tbMsgInfo:DelMsg(szKey)
  end
end

function tbConfirm:OnTradeSendRequest(szKey, szPlayer)
  local szRequsetKey = self:MakeKey(UiNotify.CONFIRMATION_TRADE_RECEIVE_REQUEST, szPlayer)
  if tbMsgInfo:GetMsg(szRequsetKey) then
    me.TradeResponse(szPlayer, 1)
    tbMsgInfo:DelMsg(szKey)
    return
  end

  local szPlayerNameEx = self:GetTradePlayerNameEx(szPlayer)

  local tbMsg = {}
  tbMsg.szMsg = "您向" .. szPlayerNameEx .. "请求交易，点击“取消”按钮将中断请求。"
  tbMsg.nOptCount = 1
  tbMsg.tbOptTitle = { "取消" }
  function tbMsg:Callback(nOptIndex, szPlayer)
    if nOptIndex == 1 then
      me.TradeRequest(szPlayer, 1)
    end
  end
  tbMsgInfo:AddMsg(szKey, tbMsg, szPlayer)
end

function tbConfirm:OnKinInviteAdd(szKey, nKinId, nInvitorId, szKinName, szPlayer)
  local tbMsg = {}
  tbMsg.szMsg = szKinName .. "家族会长" .. szPlayer .. "邀请你加入家族"
  function tbMsg:Callback(nOptIndex, nKinId, nInvitorId)
    me.CallServerScript({ "KinCmd", "InviteAddReply", nKinId, nInvitorId, nOptIndex - 1 })
    if nOptIndex == 2 then
      me.Msg("你接受了对方的加入家族邀请！")
    elseif nOptIndex == 1 then
      me.Msg("你拒绝了对方的加入家族邀请！")
    end
  end
  tbMsgInfo:AddMsg(szKey, tbMsg, nKinId, nInvitorId)
end

function tbConfirm:OnKinIntroduce(szKey, nKinId, nInvitorId, szKinName, szPlayer)
  local tbMsg = {}
  tbMsg.szMsg = szKinName .. "家族成员" .. szPlayer .. "推荐你加入家族"
  function tbMsg:Callback(nOptIndex, nKinId, nInvitorId)
    me.CallServerScript({ "KinCmd", "MemberIntroduceConfirm", nKinId, nInvitorId, nOptIndex - 1 })
    if nOptIndex == 2 then
      me.Msg("你接受了对方的加入家族推荐！")
    elseif nOptIndex == 1 then
      me.Msg("你拒绝了对方的加入家族推荐！")
    end
  end
  tbMsgInfo:AddMsg(szKey, tbMsg, nKinId, nInvitorId)
end

function tbConfirm:OnKinConvection(szKey, szPlayer, nKind, nMapId, nPosX, nPosY, nMemberPlayerId, nFightState)
  local tbMsg = {}
  tbMsg.nOptCount = 2
  tbMsg.tbOptTitle = { "拒绝", "同意" }
  tbMsg.nTimeout = 60
  if nKind == 1 then
    tbMsg.szMsg = string.format("您家族的成员[<color=yellow>%s<color>]正在召唤您，您希望传送到他身边吗？", szPlayer)
  elseif nKind == 2 then
    tbMsg.szMsg = string.format("你帮会的成员[<color=yellow>%s<color>]正在召唤您，您希望传送到他身边吗？", szPlayer)
  else
    tbMsg.szMsg = string.format("您的好友[<color=yellow>%s<color>]正在召唤您，您希望传送到他身边吗？", szPlayer)
  end
  function tbMsg:Callback(nOptIndex, nMapId, nPosX, nPosY, nMemberPlayerId, nFightState)
    me.CallServerScript({ "ZhaoHuanLingPaiCmd", nMapId, nPosX, nPosY, nMemberPlayerId, nFightState, nOptIndex })
  end
  tbMsgInfo:AddMsg(szKey, tbMsg, nMapId, nPosX, nPosY, nMemberPlayerId, nFightState)
end

function tbConfirm:OnTongApplyJoin(szKey, nKinId, nMemberId, szKinName, szPlayer)
  local tbMsg = {}
  tbMsg.szMsg = szKinName .. "家族族长" .. szPlayer .. "申请加入你的帮会"
  function tbMsg:Callback(nOptIndex, nKinId, nMemberId)
    me.CallServerScript({ "TongCmd", "JoinReply", nKinId, nMemberId, nOptIndex - 1 })
    if nOptIndex == 2 then
      me.Msg("你接受了对方的加入帮会申请！")
    elseif nOptIndex == 1 then
      me.Msg("你拒绝了对方的加入帮会申请！")
    end
  end
  tbMsgInfo:AddMsg(szKey, tbMsg, nKinId, nMemberId)
end

function tbConfirm:OnTongInviteAdd(szKey, nPlayerId, szTong, szPlayer)
  local tbMsg = {}
  tbMsg.szMsg = szTong .. "帮会帮主" .. szPlayer .. "邀请你的家族加入帮会"
  function tbMsg:Callback(nOptIndex, nPlayerId)
    me.CallServerScript({ "TongCmd", "InviteAddReply", nPlayerId, nOptIndex - 1 })
    if nOptIndex == 2 then
      me.Msg("你接受了对方的加入帮会邀请！")
    elseif nOptIndex == 1 then
      me.Msg("你拒绝了对方的加入帮会邀请！")
    end
  end
  tbMsgInfo:AddMsg(szKey, tbMsg, nPlayerId)
end

function tbConfirm:OnRelationTmpFriend(szKey, szPlayer)
  if 1 == tbTempData.nDisableFriend then
    return
  end

  if me.HasRelation(szPlayer, Player.emKPLAYERRELATION_TYPE_BIDFRIEND) == 1 then
    me.Msg("你和" .. szPlayer .. "成为正式好友，可以通过组队打怪来提高亲密度了。")
    tbMsgInfo:DelMsg(szKey)
    return
  end
  local tbMsg = {}
  tbMsg.szMsg = szPlayer .. "加你为好友，是否将其加为好友？<color=yellow>" .. "亲密度提升会获得相应奖励！" .. "<color>"
  tbMsg.nOptCount = 2
  tbMsg.tbOptTitle = { "否", "是" }
  function tbMsg:Callback(nOptIndex, szPlayer)
    if nOptIndex == 2 then -- 同意加为好友
      if me.HasRelation(szPlayer, Player.emKPLAYERRELATION_TYPE_ENEMEY) == 1 then
        me.Msg("你与对方为仇人关系，请先从仇人列表把对方删除再添加好友！")
        return
      end
      local tbRelationList, tbInfo, nNum = me.Relation_GetRelationList()
      if nNum and Relation.MAX_NUMBER_FRIEND <= nNum then
        me.Msg("你的好友人数已达上限。")
        return
      end
      me.CallServerScript({ "RelationCmd", "AddRelation_C2S", szPlayer, Player.emKPLAYERRELATION_TYPE_TMPFRIEND })
    end
  end
  tbMsgInfo:AddMsg(szKey, tbMsg, szPlayer)
end

function tbConfirm:OnRelationBlackList(szKey, szPlayer)
  -- me.Msg(szPlayer.."将您加入了黑名单。");
  -- 不需要提示了
end

function tbConfirm:OnRelationBindFriend(szKey, szPlayer)
  -- TODO: xyf 为什么没有内容？
end

function tbConfirm:OnTeacherApplyTeacher(szKey, szPlayer)
  local tbMsg = {}
  tbMsg.nOptCount = 1
  tbMsg.szMsg = szPlayer .. "想拜你为师，点击确定测试他是否是一个合格的弟子"
  function tbMsg:Callback(nOptIndex, szPlayer)
    UiManager:OpenWindow(Ui.UI_CHECKTEACHER, { szPlayer, 1 })
  end
  tbMsgInfo:AddMsg(szKey, tbMsg, szPlayer)
end

function tbConfirm:OnTeacherApplyStudent(szKey, szPlayer)
  local tbMsg = {}
  tbMsg.nOptCount = 1
  tbMsg.szMsg = szPlayer .. "想收你为徒，点击确定测试他是否是一个合格的师傅"
  function tbMsg:Callback(nOptIndex, szPlayer)
    UiManager:OpenWindow(Ui.UI_CHECKTEACHER, { szPlayer, 0 })
  end
  tbMsgInfo:AddMsg(szKey, tbMsg, szPlayer)
end

function tbConfirm:OnTeacherConvection(szKey, szDstPlayer, szAppPlayer)
  local tbMsg = {}
  local szName = szDstPlayer
  if szDstPlayer == me.szName then
    szName = szAppPlayer
  end
  tbMsg.szMsg = "你希望" .. szName .. "通过师徒传送来到你身边吗？"
  tbMsg.nOptCount = 2
  tbMsg.tbOptTitle = { "拒绝", "同意" }
  function tbMsg:Callback(nOptIndex)
    me.CallServerScript({ "ShiTuChaunSongCmd", "DstPlayerAccredit", szDstPlayer, szAppPlayer, nOptIndex - 1 })
  end
  tbMsgInfo:AddMsg(szKey, tbMsg)
end

function tbConfirm:OnCoupleConvection(szKey, szDstPlayer, szAppPlayer)
  local tbMsg = {}
  local szName = szDstPlayer
  if szDstPlayer == me.szName then
    szName = szAppPlayer
  end
  tbMsg.szMsg = "你希望" .. szName .. "通过夫妻传送来到你身边吗？"
  tbMsg.nOptCount = 2
  tbMsg.tbOptTitle = { "拒绝", "同意" }
  function tbMsg:Callback(nOptIndex)
    me.CallServerScript({ "tbFuQiChuanSongCmd", "DstPlayerAccredit", szDstPlayer, szAppPlayer, nOptIndex - 1 })
  end
  tbMsgInfo:AddMsg(szKey, tbMsg)
end

function tbConfirm:OnPkExerciseInvite(szKey, szPlayer, nPlayerId)
  local tbMsg = {}
  tbMsg.szMsg = szPlayer .. "想与您进行切磋"
  tbMsg.nOptCount = 2
  tbMsg.tbOptTitle = { "拒绝", "接受" }
  function tbMsg:Callback(nOptIndex, szPlayer, nPlayerId)
    me.PkExerciseResponse(nOptIndex - 1, nPlayerId)
  end
  tbMsgInfo:AddMsg(szKey, tbMsg, szPlayer, nPlayerId)
end
