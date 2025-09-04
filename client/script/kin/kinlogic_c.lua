-------------------------------------------------------------------
--File: kinlogic_c.lua
--Author: lbh
--Date: 2007-6-26 14:57
--Describe: 客户端家族逻辑
-------------------------------------------------------------------
if not Kin then --调试需要
  Kin = {}
  print(GetLocalDate("%Y/%m/%d/%H/%M/%S") .. " build ok ..")
else
  if not MODULE_GAMECLIENT then
    return
  end
end

function Kin:OnServerExcute(tbCall)
  print("Kin:OnServerExcute", unpack(tbCall))
  Lib:CallBack(tbCall)
end

-- 族长邀请玩家加入
function Kin:InviteKin(nPlayerId, szName)
  me.Msg("你邀请[" .. szName .. "]加入家族")
  me.CallServerScript({ "KinCmd", "InviteAdd", nPlayerId })
end

-- 成员推荐玩家加入
function Kin:RecommendKin(nPlayerId, szName)
  me.Msg("你推荐[" .. szName .. "]加入家族")
  me.CallServerScript({ "KinCmd", "MemberIntroduce", nPlayerId })
end

--显示创建家族输入框
function Kin:ShowCreateKinDlg()
  CoreEventNotify(UiNotify.emCOREEVENT_OPEN_KINCREATE)
end

function Kin:CreateKin_C(szKinName, nCamp)
  --是否允许的单词范围
  if KUnify.IsNameWordPass(szKinName) ~= 1 then
    me.Msg("名称只能包含中文简繁体字及· 【 】符号！")
    return 0
  end
  for i, v in ipairs(self.aKinTongNameFilter) do
    if string.find(szKinName, v) then
      me.Msg("对不起，您输入的家族名称包含敏感字词，请重新设定")
      return 0
    end
  end
  me.CallServerScript({ "KinCmd", "CreateKin", szKinName, nCamp })
  return 1
end

function Kin:CreateKin_C2(szKinName, nCamp)
  me.Msg("家族<color=yellow>" .. szKinName .. "<color>创建成功，您已经自动成为家族成员！")
end

--接到szKinName家族的szPlayerName邀请加入
function Kin:InviteAdd_C2(nKinId, nInvitorId, szKinName, szPlayerName)
  CoreEventNotify(UiNotify.emCOREEVENT_CONFIRMATION, UiNotify.CONFIRMATION_KIN_INVITE_ADD, nKinId, nInvitorId, szKinName, szPlayerName)
end

function Kin:MemberIntroduceMe_C2(nKinId, nInvitorId, szKinName, szPlayerName)
  CoreEventNotify(UiNotify.emCOREEVENT_CONFIRMATION, UiNotify.CONFIRMATION_KIN_INTRODUCE, nKinId, nInvitorId, szKinName, szPlayerName)
end

--成员加入结果通知
function Kin:MemberAdd_C2(nDataVer, nPlayerId, nMemberId, nJoinTime, szPlayerName, nStoredRepute, bCanJoinKinImmediately)
  KKin.ShowKinMsg("<color=white>" .. szPlayerName .. "<color>加入本家族，家族总江湖威望增加<color=yellow>" .. nStoredRepute)
  local cKin = KKin.GetSelfKin()
  if not cKin or cKin.GetKinDataVer() < 0 then
    return
  end
  local cMember = cKin.AddMember(nMemberId)
  if not cMember then
    return
  end
  cMember.SetName(szPlayerName)
  cMember.SetPlayerId(nPlayerId)
  if EventManager.IVER_bOpenTiFu == 1 then
    cMember.SetFigure(self.FIGURE_REGULAR) -- TEMP:2008-11-13,xiewen修改（为了方便玩家进入体服参加领土战）
  else
    cMember.SetFigure(self.FIGURE_SIGNED)
  end

  if bCanJoinKinImmediately == 1 then -- 如果是被召回老玩家，在老玩家活动期间可以马上转正
    cMember.SetFigure(self.FIGURE_REGULAR)
  end
  cMember.SetOnline(1)
  cKin.AddTotalRepute(nStoredRepute)
  cKin.SetKinDataVer(nDataVer)
end

--成员删除结果通知，nMethod = 0自己退出，nMethod = 1开除
function Kin:MemberDel_C2(nDataVer, nMemberId, szName, nMethod, nReputeDec)
  if nMethod == 1 then
    KKin.ShowKinMsg("<color=white>" .. szName .. "<color>被开除出家族，家族总江湖威望减少<color=yellow>" .. nReputeDec)
  else
    KKin.ShowKinMsg("<color=white>" .. szName .. "<color>离开本家族，家族总江湖威望减少<color=yellow>" .. nReputeDec)
  end
  local cKin = KKin.GetSelfKin()
  if not cKin or cKin.GetKinDataVer() < 0 then
    return
  end
  if nReputeDec < 0 then
    nReputeDec = 0
  end
  cKin.DelMember(nMemberId)
  cKin.SetKinDataVer(nDataVer)
  cKin.AddTotalRepute(-nReputeDec)
  Ui(Ui.UI_KIN):UpdateBaseInfo()
  Ui(Ui.UI_KIN):UpdateMemberList()
end

--收到成员开除发起
function Kin:MemberKickInit_C2(nMemberId, szName)
  Ui(Ui.UI_KINREQUESTLIST):AddKickRequest(nMemberId, szName)
end

function Kin:Member2Regular_C2(nMemberId, szName)
  KKin.ShowKinMsg("<color=white>" .. szName .. "<color>成为家族正式成员！")
  local _, nSelfId = me.GetKinMember()
  if nSelfId ~= 0 and nMemberId == nSelfId then
    me.nKinFigure = self.FIGURE_REGULAR
  end
  local cKin = KKin.GetSelfKin()
  if not cKin or cKin.GetKinDataVer() < 0 then
    return 0
  end
  local cMember = cKin.GetMember(nMemberId)
  if not cMember then
    return 0
  end
  cMember.SetFigure(self.FIGURE_REGULAR)
end

--成员推荐（族长副族长收到）
function Kin:MemberIntroduce_C2(nIntroducerId, nPlayerId, szPlayerName)
  Ui(Ui.UI_KINREQUESTLIST):AddJoinRequest(nIntroducerId, nPlayerId, szPlayerName)
end

--更改称号
function Kin:ChangeTitle_C2(nTitleType, szTitle)
  local aTitleDesc = {
    "族长",
    "副族长",
    "男成员",
    "女成员",
    "荣誉成员",
  }
  KKin.ShowKinMsg("家族" .. aTitleDesc[nTitleType] .. "称号已更改为：<color=yellow>" .. szTitle)
end

--更改阵营
function Kin:ChangeCamp_C2(nDataVer, nCamp)
  local aCampName = {
    "宋方",
    "金方",
    "中立",
  }
  KKin.ShowKinMsg("家族阵营已更改为：<color=yellow>" .. aCampName[nCamp])
  local cKin = KKin.GetSelfKin()
  if not cKin or cKin.GetKinDataVer() < 0 then
    return
  end
  cKin.SetCamp(nCamp)
  cKin.SetKinDataVer(nDataVer)
  Ui(Ui.UI_KIN):UpdateBaseInfo()
end

--任命副族长
function Kin:SetAssistant_C2(nDataVer, nMemberId, szName)
  KKin.ShowKinMsg("<color=white>" .. szName .. "<color>被任命为新的副族长！")
  local cKin = KKin.GetSelfKin()
  if not cKin or cKin.GetKinDataVer() < 0 then
    return
  end
  --获取原有副族长
  local nAssistant = cKin.GetAssistant()
  local cMemberAssistant = cKin.GetMember(nAssistant)
  --更换职位
  if cMemberAssistant then
    cMemberAssistant.SetFigure(self.FIGURE_REGULAR)
  end
  local cMemberNewAssistant = cKin.GetMember(nMemberId)
  if cMemberNewAssistant then
    cMemberNewAssistant.SetFigure(self.FIGURE_ASSISTANT)
  end
  cKin.SetAssistant(nMemberId)
  cKin.SetKinDataVer(nDataVer)
  Ui(Ui.UI_KIN):UpdateBaseInfo()
  Ui(Ui.UI_KIN):UpdateMemberList()
end

function Kin:FireAssistant_C2(nMemberId, szName)
  KKin.ShowKinMsg("<color=white>" .. szName .. "<color>被撤消副族长职务！")
  local cKin = KKin.GetSelfKin()
  if not cKin or cKin.GetKinDataVer() < 0 then
    return
  end
  local cMember = cKin.GetMember(nMemberId)
  if not cMember then
    return 0
  end
  cMember.SetFigure(self.FIGURE_REGULAR)
  cKin.SetAssistant(0)
  Ui(Ui.UI_KIN):UpdateBaseInfo()
  Ui(Ui.UI_KIN):UpdateMemberList()
end

--更换族长
function Kin:ChangeCaptain_C2(nDataVer, nMemberId, szName)
  KKin.ShowKinMsg("<color=white>" .. szName .. "<color>被任命为新的族长！")
  local cKin = KKin.GetSelfKin()
  if not cKin or cKin.GetKinDataVer() < 0 then
    return
  end
  cKin.SetKinDataVer(nDataVer)
  if cKin.GetAssistant() == nMemberId then
    cKin.SetAssistant(0)
  end
  --获取原有族长
  local nCaptain = cKin.GetCaptain()
  local cMemberCaptain = cKin.GetMember(nCaptain)
  --更换职位
  if cMemberCaptain then
    cMemberCaptain.SetFigure(self.FIGURE_REGULAR)
  end
  local cMemberNewCaptain = cKin.GetMember(nMemberId)
  if cMemberNewCaptain then
    cMemberNewCaptain.SetFigure(self.FIGURE_CAPTAIN)
  end
  cKin.SetCaptain(nMemberId)
  Ui(Ui.UI_KIN):UpdateBaseInfo()
  Ui(Ui.UI_KIN):UpdateMemberList()
end

function Kin:FireCaptain_Init_C2(nExcutorId, szName)
  local nKinId, nMemberId = me.GetKinMember()
  --发起者不用显示申请
  if nMemberId == nExcutorId then
    return
  end
  KKin.ShowKinMsg("<color=white>" .. szName .. "<color>发起了罢免族长申请，请通过申请列表表决！")
  Ui(Ui.UI_KINREQUESTLIST):AddFireCaptain(szName)
end

function Kin:FireCaptain_Vote_C2(nExcutorId, szName, bLock)
  KKin.ShowKinMsg("<color=white>" .. szName .. "<color>同意罢免族长！")
  if bLock then
    KKin.ShowKinMsg("族长罢免生效，族长权限被冻结！")
  end
end

--成员退隐
function Kin:MemberRetire_C2(nMemberId, szName)
  KKin.ShowKinMsg("<color=white>" .. szName .. "<color>退隐，成为家族荣誉成员！")
  local cKin = KKin.GetSelfKin()
  if not cKin or cKin.GetKinDataVer() < 0 then
    return
  end
  local cMember = cKin.GetMember(nMemberId)
  if not cMember then
    return 0
  end
  local nFigure = cMember.GetFigure()
  if nFigure == self.FIGURE_ASSISTANT then
    cKin.SetAssistant(0)
  end
  cMember.SetFigure(self.FIGURE_RETIRE)
  Ui(Ui.UI_KIN):UpdateBaseInfo()
  Ui(Ui.UI_KIN):UpdateMemberList()
end

-- 取消退隐
function Kin:CancelRetire_C2(nMemberId, szName)
  KKin.ShowKinMsg("<color=white>" .. szName .. "<color>取消退隐，恢复家族正式成员的身份")
end

--设置公告
function Kin:SetAnnounce_C2(nDataVer, szAnnounce)
  KKin.ShowKinMsg("家族公告已更新！")
  Ui(Ui.UI_KIN):UpdateAddiche(szAnnounce)
  local cKin = KKin.GetSelfKin()
  if not cKin or cKin.GetKinDataVer() < 0 then
    return
  end
  cKin.SetAnnounce(szAnnounce)
  cKin.SetKinDataVer(nDataVer)
end

-- 设置家园描述
function Kin:SetHomeLandDesc_C2(nDataVer, szHomeLandDesc)
  KKin.ShowKinMsg("家园描述已更新！")
  Ui(Ui.UI_KIN):UpdateHomeLandDesc(szAnnounce)
  local cKin = KKin.GetSelfKin()
  if not cKin or cKin.GetKinDataVer() < 0 then
    return
  end
  cKin.SetHomeLandDesc(szHomeLandDesc)
  cKin.SetKinDataVer(nDataVer)
end

--招募公告
function Kin:SetRecAnnounce_C2(nDataVer, szRecAnnounce)
  KKin.ShowKinMsg("家族招募公告已更新！")
  Ui(Ui.UI_KIN):UpdateRecAnnounce(szRecAnnounce)
  local cKin = KKin.GetSelfKin()
  if not cKin or cKin.GetKinDataVer() < 0 then
    return
  end
  cKin.SetRecAnnounce(szRecAnnounce)
  cKin.SetKinDataVer(nDataVer)
end

--族长竞选投票
function Kin:CaptainVoteBallot_C2(nExcutorId, nMemberId, nBallot)
  --不显示公告
  Ui(Ui.UI_KIN):UpBallotList(nMemberId, nBallot)
  do
    return
  end
  local cKin = KKin.GetSelfKin()
  if not cKin then
    return
  end
  local cExcutor = cKin.GetMember(nExcutorId)
  local cMember = cKin.GetMember(nMemberId)
  if not cExcutor or not cMember then
    return
  end
  local szSrcName = "<color=white>" .. cExcutor.GetName() .. "<color>"
  local szDstName, szWhoAdd
  if nExcutorId ~= nMemberId then
    szDstName = "<color=white>" .. cMember.GetName() .. "<color>"
    szWhoAdd = szDstName
  else
    szDstName = "自已"
    szWhoAdd = szSrcName
  end
  KKin.ShowKinMsg(szSrcName .. "把票数投给了" .. szDstName .. "，" .. szWhoAdd .. "票数值增加：<color=cyan>" .. nBallot)
end

function Kin:JoinTong_C2(szTong)
  KKin.ShowKinMsg("本家族加入帮会：<color=yellow>" .. szTong .. "<color>")
end

function Kin:LeaveTong_C2(nMethod)
  if nMethod == 0 then
    KKin.ShowKinMsg("你的家族离开了帮会。")
  else
    KKin.ShowKinMsg("你的家族被帮会开除了。")
  end
  local cKin = KKin.GetSelfKin()
  if not cKin then
    return
  end
  cKin.SetBelongTong(0)
end
function Kin:ApplyQuitTong_C2(nTime)
  local cKin = KKin.GetSelfKin()
  if cKin then
    cKin.SetApplyQuitTime(nTime)
  end
  cKin.SetSelfQuitVoteState(0)
  KKin.ShowKinMsg("你的家族发起了退出帮会，7天后反对人数不超过总人数的1/3则自动退出帮会，你可以通过申请列表进行表决。")
  CoreEventNotify(UiNotify.emCOREEVENT_KIN_BASE_INFO)
  Ui(Ui.UI_KINREQUESTLIST):AddQuitTong()
end

function Kin:CloseQuitTong_C2(nSuccess)
  local cKin = KKin.GetSelfKin()
  if cKin then
    cKin.SetApplyQuitTime(0)
    cKin.SetSelfQuitVoteState(0)
  end
  if nSuccess == 0 then
    KKin.ShowKinMsg("拒绝人数超过总人数的1/3，退出帮会失败！")
  elseif nSuccess == 2 then
    KKin.ShowKinMsg("族长取消了退出帮会!")
    CoreEventNotify(UiNotify.emCOREEVENT_KIN_BASE_INFO)
  elseif nSuccess == 3 then
    KKin.ShowKinMsg("帮主所在家族不能离开帮会！")
  end
end

function Kin:QuitTongVote_C2(nAccept)
  local cKin = KKin.GetSelfKin()
  if not cKin then
    return 0
  end
  cKin.SetSelfQuitVoteState((nAccept == 1) and 1 or 2)
  if nAccept == 1 then
    KKin.ShowKinMsg("你赞成退出帮会！")
  else
    KKin.ShowKinMsg("你反对退出帮会！")
  end
end

function Kin:AddGuYinBi_C2(nAddGuYinBi)
  if nAddGuYinBi == 0 then
    KKin.ShowKinMsg("你的家族古银币已经到达上限！")
  else
    KKin.ShowKinMsg("你的家族增加了" .. nAddGuYinBi .. "个古银币")
  end
end

--接收、处理家族招募状态
function Kin:ProcessRecruitmentPublish(nPublish, nLevel, nHonour, nAutoAgree)
  local pKin = KKin.GetSelfKin()
  if not pKin then
    return 0
  end
  if nPublish then
    pKin.SetRecruitmentPublish(nPublish)
  end
  if nLevel then
    pKin.SetRecruitmentLevel(nLevel)
  end
  if nHonour then
    pKin.SetRecruitmentHonour(nHonour)
  end
  if nAutoAgree then
    pKin.SetRecruitmentAutoAgree(nAutoAgree)
  end

  CoreEventNotify(UiNotify.emCOREEVENT_KINRECRUITMENT_STATE)
end

----接收、处理家族招募榜
--function Kin:ProcessRecruitment()
--	CoreEventNotify(UiNotify.emCOREEVENT_KINRECRUITMENT);
--end

function Kin:StorageFundToTong_C2(szPlayerName, szTongName, nMoney)
  KKin.ShowKinMsg("<color=white>" .. szPlayerName .. "<color>向<color=white>" .. szTongName .. "<color>帮会转存家族资金<color=red>" .. nMoney .. "<color>两！")
end

function Kin:AddFund_C2(szPlayerName, nMoney)
  KKin.ShowKinMsg("<color=white>" .. szPlayerName .. "<color>存入家族资金:<color=red>" .. nMoney .. "<color>两！")
end

function Kin:TakeFund_C2(szPlayerName, nMoney)
  KKin.ShowKinMsg("<color=white>" .. szPlayerName .. "<color>在家族资金中取出<color=red>" .. nMoney .. "<color>两！")
end

function Kin:SendTakeFundApply_C2(szPlayerName, nMoney, nType)
  if nType == 0 then
    KKin.ShowKinMsg("<color=white>" .. szPlayerName .. "<color>申请取出<color=red>" .. nMoney .. "<color>两家族资金！需要家族族长同意才能取出资金！")
  elseif nType == 1 then
    KKin.ShowKinMsg("家族族长<color=white>" .. szPlayerName .. "<color>申请取出<color=red>" .. nMoney .. "<color>两家族资金！需要另外两名家族正式成员同意才能取出资金！")
  end
end

function Kin:TakeFundRespond_C2(szName, nMoney, nAccept)
  if nAccept == 0 then
    KKin.ShowKinMsg("家族族长拒绝了<color=white>" .. szName .. "<color>取出<color=red>" .. nMoney .. "<color>两家族资金的申请！")
  elseif nAccept == 1 then
    KKin.ShowKinMsg("家族族长同意了<color=white>" .. szName .. "<color>取出<color=red>" .. nMoney .. "<color>两家族资金的申请！")
  end
end

-- 成员家族资金申请
function Kin:GetTakeFundApply_C2(nKey, nMemberId, szPlayerName, nMoney)
  me.Msg(szPlayerName .. "申请取出家族资金" .. nMoney .. "两，请您在家族申请列表中表决！")
  Ui(Ui.UI_KINREQUESTLIST):AddTakeFundRequest(nKey, nMemberId, szPlayerName, nMoney)
end

function Kin:SendSalary_C2(nMoney)
  KKin.ShowKinMsg("族长发放了出勤奖励，家族资金减少<color=red>" .. nMoney .. "<color>两，请出勤人员注意查收邮件并确保邮箱可接收到新邮件！")
end

function Kin:NotifApplyTakeFundPlayer_C2(nMoney, nType)
  if nType == 0 then
    me.Msg("您申请了取出资金操作，在10分钟内需要族长同意才能取出！")
  elseif nType == 1 then
    me.Msg("您申请了取出资金操作，在10分钟内需要另外两名正式成员同意才能取出！")
  end
  Ui("UI_TASKTIPS"):Begin("您已申请取出家族资金" .. nMoney .. "两！")
end

function Kin:AcceptExclusiveEvent_C2(szPlayerName, nKey, nAccept)
  local szMsg
  if nAccept == 1 then
    szMsg = "<color=white>" .. szPlayerName .. "<color>同意了"
  else
    szMsg = "<color=white>" .. szPlayerName .. "<color>拒绝了"
  end
  local szMsg2 = ""
  if nKey == self.KIN_EVENT_TAKE_FUND then
    szMsg2 = "取出资金的申请"
  elseif nKey == self.KIN_EVENT_SALARY then
    szMsg2 = "发放出勤奖励的申请"
  elseif nKey == self.KIN_EVENT_TAKE_REPOSITORY then
    szMsg2 = "家族权限仓库操作申请"
  elseif nKey == self.KIN_EVENT_BUYBADGE then
    szMsg2 = "家族徽章购买的申请"
  else
    print("errorkey:", nKey)
    szMsg2 = ""
  end
  KKin.ShowKinMsg(szMsg .. szMsg2)
end

function Kin:NotifApplySalaryPlayer_C2(nMoney)
  me.Msg("您申请了发放出勤奖励操作，在10分钟内需要另外两名正式成员同意才能取出！")
  Ui("UI_TASKTIPS"):Begin("您已申请发放出勤奖励共" .. nMoney .. "两！")
end

function Kin:SendSalaryApply_C2(szPlayerName, nMoney, nAttendanceAward)
  KKin.ShowKinMsg("族长<color=white>" .. szPlayerName .. "<color>申请发放出勤奖励！本次单次出勤奖励金额为<color=red>" .. nAttendanceAward .. "<color>两，共<color=red>" .. nMoney .. "<color>两！在10分钟内需要另外两名正式成员同意才能生效")
end

function Kin:SalaryRequestApply_C2(nKey, nMemberId, szPlayerName, nMoney)
  Ui(Ui.UI_KINREQUESTLIST):AddSalaryRequest(nKey, nMemberId, szPlayerName, nMoney)
end

function Kin:SendTakeRepositoryApply_C2(szPlayerName)
  KKin.ShowKinMsg("仓库管理员<color=white>" .. szPlayerName .. "<color>申请了家族权限仓库操作，在2分钟内需要另外2名仓库管理员同意才能生效。")
end

function Kin:AgreeTakeAuthority_C2(szPlayerName)
  KKin.ShowKinMsg("仓库管理员<color=white>" .. szPlayerName .. "<color>正在取出权限仓库内物品。")
end

function Kin:TakeRepositoryRequestApply_C2(nKey, nMemberId, szPlayerName)
  Ui(Ui.UI_KINREQUESTLIST):AddTakeRepositoryRequest(nKey, nMemberId, szPlayerName)
end

function Kin:AcceptExclusiveEventNotify_C2(szPlayerName, nKey, nAccept)
  local szMsg
  if nAccept == 1 then
    szMsg = szPlayerName .. "同意了"
  else
    szMsg = szPlayerName .. "拒绝了"
  end
  local szMsg2 = ""
  if nKey == self.KIN_EVENT_TAKE_FUND then
    szMsg2 = "你取出资金的申请"
  elseif nKey == self.KIN_EVENT_SALARY then
    szMsg2 = "你发放出勤奖励的申请"
  elseif nKey == self.KIN_EVENT_TAKE_REPOSITORY then
    szMsg2 = "你家族权限仓库操作申请"
  elseif nKey == self.KIN_EVENT_BUYBADGE then
    szMsg2 = "你家族徽章购买的申请"
  end
  me.Msg(szMsg .. szMsg2)
  Ui("UI_TASKTIPS"):Begin(szMsg .. szMsg2)
end

function Kin:ApplyFailed_C2(nKey)
  if nKey == self.KIN_EVENT_TAKE_FUND then
    KKin.ShowKinMsg("你取出资金的申请超时了！")
  elseif nKey == self.KIN_EVENT_SALARY then
    KKin.ShowKinMsg("你发放出勤奖励的申请超时了！")
  end
  return 0
end

--增加经验增加技能等级
function Kin:AddSkillExp_C2(nLevel, nNowExp)
  local cKin = KKin.GetSelfKin()
  if not cKin then
    return
  end
  cKin.SetSkillLevel(nLevel)
  cKin.SetSkillExp(nNowExp)
  return 0
end

--加技能点
function Kin:AddSkillLevel_C2(tbSkillInfo)
  local cKin = KKin.GetSelfKin()
  if not cKin then
    return
  end
  local nLevel = cKin.GetSkillLevel()
  local nMaxPoint = 0
  for _, tbSkillInfoEx in pairs(tbSkillInfo) do
    local nTaskId = self.tbKinSkill.tbSkillInfo[tbSkillInfoEx[1]][tbSkillInfoEx[2]][tbSkillInfoEx[3]].nTaskId
    cKin.SetTask(nTaskId, cKin.GetTask(nTaskId) + tbSkillInfoEx[4])
    nMaxPoint = nMaxPoint + tbSkillInfoEx[4]
  end
  cKin.SetUsePoint(cKin.GetUsePoint() + nMaxPoint)
  Ui(Ui.UI_KIN):UpdateSkillList()
  return 0
end

--同步家族技能信息
function Kin:RefreshSkillInfo_C2(tbSkillInfo)
  local cKin = KKin.GetSelfKin()
  if not cKin then
    return
  end
  for nTaskId, nNum in pairs(tbSkillInfo) do
    cKin.SetTask(nTaskId, nNum)
  end
  return 0
end

--洗技能点
function Kin:RefreshSkillPoint_C2()
  local cKin = KKin.GetSelfKin()
  if not cKin then
    return
  end
  local nPoint = 0
  for _, tbSkillG in pairs(self.tbKinSkill.tbSkillInfo) do
    for _, tbSkillD in pairs(tbSkillG) do
      for _, tbSkillS in pairs(tbSkillD) do
        nPoint = nPoint + cKin.GetTask(tbSkillS.nTaskId)
        cKin.SetTask(tbSkillS.nTaskId, 0)
      end
    end
  end
  cKin.SetUsePoint(0)
end

--获取技能等级
function Kin:GetSkillLevel(nKinId, nGenreId, nDetailId, nSkillId)
  if not self.tbKinSkill.tbSkillInfo[nGenreId] or not self.tbKinSkill.tbSkillInfo[nGenreId][nDetailId] or not self.tbKinSkill.tbSkillInfo[nGenreId][nDetailId][nSkillId] then
    return 0
  end
  local cKin = KKin.GetSelfKin()
  if not cKin then
    return 0
  end

  local nTaskId = self.tbKinSkill.tbSkillInfo[nGenreId][nDetailId][nSkillId].nTaskId
  if nTaskId <= 0 then
    return 0
  end
  return cKin.GetTask(nTaskId)
end

--设置yy号
function Kin:SetYYNumber_C2(nYYNumber)
  KKin.ShowKinMsg(string.format("家族的yy号变更为：<color=yellow>%s<color>", nYYNumber))
  local cKin = KKin.GetSelfKin()
  if not cKin or cKin.GetKinDataVer() < 0 then
    return 0
  end
  cKin.SetYYNumber(nYYNumber)
  Ui(Ui.UI_KIN):UpdateBaseInfo()
end

function Kin:AddPlantSkillExp_C2(nExp, nNum, nFlag)
  local cKin = KKin.GetSelfKin()
  if not cKin then
    return 0
  end
  if nFlag then
    cKin.AddPlantExp(nExp)
  end
  cKin.SetHandInCount(nNum)
end

function Kin:AddKinGrade_C2(nMemberId, nGrade)
  local cKin = KKin.GetSelfKin()
  if not cKin then
    return 0
  end
  local nMonthNow = tonumber(GetLocalDate("%m"))

  --家族积分
  local nKinMonth = cKin.GetKinGameMonth()
  local nKinTotalGrade = cKin.GetKinGameGrade()
  if nMonthNow ~= nKinMonth then
    if nMonthNow == math.fmod(nKinMonth, 12) + 1 then
      cKin.SetKinGameGradeLast(nKinTotalGrade)
    else
      cKin.SetKinGameGradeLast(0)
    end
    cKin.SetKinGameMonth(nMonthNow)
    nKinTotalGrade = 0
  end
  cKin.SetKinGameGrade(nKinTotalGrade + nGrade)

  --成员积分
  local cMember = cKin.GetMember(nMemberId)
  if not cMember then
    return 0
  end
  local nMemMonth = cMember.GetKinGameMonth()
  local nMemTotalGrade = cMember.GetKinGameGrade()
  if nMonthNow ~= nMemMonth then
    cMember.SetKinGameMonth(nMonthNow)
    nMemTotalGrade = 0
  end
  cMember.SetKinGameGrade(nMemTotalGrade + nGrade)
end

-- 设置家族徽章
function Kin:SetKinBadge_C2(szPlayerName, nSelectBadge, nType)
  local cKin = KKin.GetSelfKin()
  if not cKin then
    return 0
  end
  cKin.SetKinBadge(nType * 10000 + nSelectBadge)
  KKin.ShowKinMsg("家族成员<color=white>" .. szPlayerName .. "<color>更换了家族徽章！")
  Ui(Ui.UI_BADGE):UpdateBadgeInfo()
  Ui(Ui.UI_KIN):UpdateBaseInfo()
end

function Kin:GetBuyBadgeApply_C2(nKey, nMemberId, szPlayerName, nMoney, nRate)
  local nKinId, nExcutorId = me.GetKinMember()
  --发起者不用显示申请
  if nMemberId == nExcutorId or me.nKinFigure > 3 then
    me.Msg("你的购买徽章申请已提交，请等待家族正式成员在家族界面内“申请列表”中的表决。")
    return
  end
  KKin.ShowKinMsg("家族族长<color=white>" .. szPlayerName .. "<color>使用<color=red>" .. nMoney .. "<color>两家族资金，购买了一个" .. nRate .. "级徽章！需要另外两名家族正式成员同意才能购买徽章！！")
  Ui(Ui.UI_KINREQUESTLIST):AddBuyBadgeRequest(nKey, nMemberId, szPlayerName, nMoney, nRate)
end

function Kin:BuyBadge_C2(szPlayerName, nMoney, nRecord, nRate)
  local cKin = KKin.GetSelfKin()
  if not cKin then
    return 0
  end
  cKin.SetMoneyFund(cKin.GetMoneyFund() - nMoney)
  -- 记录购买徽章
  if nRate == 1 then
    local nRecordEx = cKin.GetBadgeRecord1()
    cKin.SetBadgeRecord1(Lib:SetBits(nRecordEx, 1, nRecord - 1, nRecord - 1))
  elseif nRate == 2 then
    local nRecordEx = cKin.GetBadgeRecord2()
    cKin.SetBadgeRecord2(Lib:SetBits(nRecordEx, 1, nRecord - 1, nRecord - 1))
  else
    local nRecordEx = cKin.GetBadgeRecord3()
    cKin.SetBadgeRecord3(Lib:SetBits(nRecordEx, 1, nRecord - 1, nRecord - 1))
  end
  KKin.ShowKinMsg("家族族长<color=white>" .. szPlayerName .. "<color>使用<color=red>" .. nMoney .. "<color>两家族资金，成功购买了一个" .. nRate .. "级徽章！")
  Ui(Ui.UI_BADGE):UpdateBadgeInfo()
  Ui(Ui.UI_KIN):UpdateBaseInfo()
end

function Kin:SysChangeKinBadge()
  local cKin = KKin.GetSelfKin()
  if not cKin then
    return 0
  end
  cKin.SetKinBadge(10001)
  Ui(Ui.UI_BADGE):UpdateBadgeInfo()
  Ui(Ui.UI_KIN):UpdateBaseInfo()
  KKin.ShowKinMsg("家族徽章由于正式人员资格不足降级为1级，请族长扩充壮大家族，方可再次使用高等级族徽。")
end

function Kin:SetMemberRepAuthority_C2(nMemberId, nSetRepAuthority)
  local cKin = KKin.GetSelfKin()
  if not cKin then
    return 0
  end
  Ui(Ui.UI_KIN):UpRepAuthorityList(nMemberId, nSetRepAuthority)
end

-- 改变挑战次数
function Kin:ChangeChallengeTimes_C(nDataVer, nTimes)
  local cKin = KKin.GetSelfKin()
  if not cKin then
    return 0
  end

  cKin.SetChallengeTimes(nTimes)
  Ui(Ui.UI_KIN):UpdateKinChallengeInfo()
end
