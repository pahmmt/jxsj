-------------------------------------------------------------------
--File: kinlogic_gs.lua
--Author: lbh
--Date: 2007-6-26 14:57
--Describe: Gameserver家族逻辑
-------------------------------------------------------------------
if not Kin then --调试需要
  Kin = {}
  print(GetLocalDate("%Y/%m/%d/%H/%M/%S") .. " build ok ..")
else
  if not MODULE_GAMESERVER then
    return
  end
end

Kin.c2sFun = {}
--注册能被客户端直接调用的函数
local function RegC2SFun(szName, fun)
  Kin.c2sFun[szName] = fun
end

--nType:类型，1为判断正式+记名成员， 0或nil为判断家族所有人员满足 并且 正式+记名同时满足
function Kin:_CheckMemberCount(nKinId, nType)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return nil
  end
  local nRegular, nSigned, nRetire = cKin.GetMemberCount()
  local nMemberLimit, nRetireLimit = self:GetKinMemberLimit(nKinId)
  if nType ~= 1 then
    if (nRegular + nSigned + nRetire) >= (nMemberLimit + nRetireLimit) then
      return nil
    end
  end
  if nRegular + nSigned >= nMemberLimit then
    return nil
  end
  return 1
end

function Kin:CreateKinApply_GS1(szKinName, nCamp)
  return self:DlgCreateKin(szKinName, nCamp)
end
RegC2SFun("CreateKin", Kin.CreateKinApply_GS1)

if not Kin.aKinCreateApply then
  Kin.aKinCreateApply = {}
end

--GS1后缀表示申请逻辑，GS2后缀表示结果逻辑
--以列表的PlayerId创建家族
function Kin:CreateKin_GS1(anPlayerId, anStoredRepute, szKinName, nCamp, nPlayerId, bGoldLogo)
  if self.aKinCreateApply[nPlayerId] then
    return 0
  end
  --家族名字合法性检查
  local nLen = GetNameShowLen(szKinName)
  if nLen < 6 or nLen > 12 then
    return -1
  end
  --是否允许的单词范围
  if KUnify.IsNameWordPass(szKinName) ~= 1 then
    return -2
  end
  --是否包含敏感字串
  if IsNamePass(szKinName) ~= 1 then
    return -3
  end
  --检查家族名是否已占用
  if KKin.FindKin(szKinName) ~= nil then
    return -4
  end
  --检查创建家族的成员是否符合要求
  if self:CanCreateKin(anPlayerId) ~= 1 then
    return -5
  end

  self.aKinCreateApply[nPlayerId] = { anPlayerId, anStoredRepute, szKinName, nCamp, bGoldLogo }
  return GCExcute({ "Kin:CreateKinApply_GC", nPlayerId, szKinName })
end

function Kin:OnKinNameResult_GS2(nPlayerId, nResult)
  local tbParam = self.aKinCreateApply[nPlayerId]
  if not tbParam then
    return
  end
  local bGoldLogo = tbParam[5]
  Kin.aKinCreateApply[nPlayerId] = nil

  local cPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not cPlayer then
    return 0
  end

  if nResult ~= 1 then
    cPlayer.Msg("家族名字已存在，请更换其他名字")
    return
  end

  -- by jiazhenwei  金牌网吧建立家族5w
  local nMoneyCreat = self.CREATE_KIN_MONEY
  if SpecialEvent.tbGoldBar:CheckPlayer(cPlayer) == 1 then
    nMoneyCreat = math.min(nMoneyCreat, 50000)
  end
  --end

  --by jiazhenwei 有该物品建立家族只需15w
  local nFlag = 0
  if #cPlayer.FindItemInBags(18, 1, 994, 1) >= 1 then
    nFlag = 1
    nMoneyCreat = math.min(nMoneyCreat, 150000)
  end
  --end

  --by jiazhenwei 某个日期之前建立家族折扣(不可以和物品及金牌网吧的叠加，取最小值)
  local tbBuffer = GetGblIntBuf(GBLINTBUF_LOGIN_AWARD, 0)
  if not tbBuffer or type(tbBuffer) ~= "table" then
    tbBuffer = {}
  end
  local nMoneyDiscount = 0
  if tbBuffer[2] and tbBuffer[2][1] and Lib:GetDate2Time(tbBuffer[2][1]) > GetTime() then
    nMoneyDiscount = math.floor(self.CREATE_KIN_MONEY * tbBuffer[2][2] / 10000)
    nMoneyCreat = math.min(nMoneyCreat, nMoneyDiscount)
  end
  --end

  --用家族建立卡建立的家族，不收钱，只扣东西
  if bGoldLogo then
    cPlayer.ConsumeItemInBags(1, 18, 1, 1697, 1, 0)
  else
    if cPlayer.CostMoney(nMoneyCreat, Player.emKPAY_CREATEKIN) ~= 1 then
      return 0
    end
    --真实价格和折扣价格一样的默认为折扣价格
    if nMoneyDiscount == nMoneyCreat and nMoneyDiscount ~= self.CREATE_KIN_MONEY then
      nFlag = 0
      cPlayer.Msg(string.format("现在处于家族建设优惠期，只收取您%s两费用", nMoneyCreat))
      Dialog:SendBlackBoardMsg(cPlayer, string.format("现在处于家族建设优惠期，只收取您%s两费用", nMoneyCreat))
    end

    --by jiazhenwei 有该物品建立家族只需15w
    if nFlag == 1 then
      cPlayer.ConsumeItemInBags(1, 18, 1, 994, 1, 0)
    end
    --end
  end
  GCExcute({ "Kin:CreateKin_GC", unpack(tbParam) })

  --解散队伍
  if cPlayer.nTeamId > 0 then
    KTeam.DisbandTeam(cPlayer.nTeamId)
  end
end

function Kin:CreateKin_GS2(anPlayerId, anStoredRepute, szKinName, nCamp, nCreateTime, tbStock, nChallengeTimes, bGoldLogo)
  local cKin, nKinId = self:CreateKin(anPlayerId, anStoredRepute, szKinName, nCamp, nCreateTime, tbStock, nChallengeTimes)
  if not cKin then
    return 0
  end

  --金牌家族标志
  if bGoldLogo then
    cKin.SetGoldLogo(1)
  end

  for i, nPlayerId in ipairs(anPlayerId) do
    KKinGs.UpdateKinInfo(nPlayerId)

    -- 创建家族的时候增加师徒成就（加入家族）
    Achievement_ST:FinishAchievement(nPlayerId, Achievement_ST.ENTER_KIN)
    local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
    if pPlayer then
      if pPlayer.GetTask(Player.TSKGROUP_NEWPLAYER_GUIDE, Player.TSKID_NEWPLAYER_KIN) ~= 1 then
        local nYinding = pPlayer.GetTask(Kinsalary.TASK_GID, Kinsalary.TASK_YINDING)
        pPlayer.SetTask(Kinsalary.TASK_GID, Kinsalary.TASK_YINDING, nYinding + 1000)
      end

      pPlayer.SetTask(Player.TSKGROUP_NEWPLAYER_GUIDE, Player.TSKID_NEWPLAYER_KIN, 1)

      -- 成就，加入家族
      Achievement:FinishAchievement(pPlayer, 26)

      -- 家族创始人称号
      pPlayer.AddSpeTitle(szKinName .. "创始人", GetTime() + 30 * 60 * 60 * 24, "gold")
    end
  end
  return KKinGs.KinClientExcute(nKinId, { "Kin:CreateKin_C2", szKinName, nCamp })
end

--增加成员
function Kin:MemberAdd_GS1(nKinId, nExcutorId, nPlayerId, bCanJoinKinImmediately)
  if self:CheckSelfRight(nKinId, nExcutorId, 2) ~= 1 then
    return 0
  end
  if self:CheckMemberCanAdd(nKinId, nPlayerId) ~= 1 then
    return 0
  end
  return GCExcute({ "Kin:MemberAdd_GC", nKinId, nExcutorId, nPlayerId, bCanJoinKinImmediately })
end

function Kin:MemberAdd_GS2(nDataVer, nKinId, nPlayerId, nMemberId, nJoinTime, nStoredRepute, nPersonalStock, bCanJoinKinImmediately)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  local cMember = cKin.AddMember(nMemberId)
  if not cMember then
    return 0
  end

  cMember.SetJoinTime(nJoinTime)
  cMember.SetPlayerId(nPlayerId)
  if EventManager.IVER_bOpenTiFu == 1 then
    cMember.SetFigure(self.FIGURE_REGULAR) -- TEMP:2008-11-13,xiewen修改（为了方便玩家进入体服参加领土战）
  else
    cMember.SetFigure(self.FIGURE_SIGNED)
  end
  if bCanJoinKinImmediately == 1 then
    cMember.SetFigure(self.FIGURE_REGULAR)
  end
  cMember.SetPersonalStock(nPersonalStock)
  if nStoredRepute > 0 then
    cKin.AddTotalRepute(nStoredRepute)
  end
  KKinGs.UpdateKinInfo(nPlayerId)
  cKin.SetKinDataVer(nDataVer)
  local szPlayerName = KGCPlayer.GetPlayerName(nPlayerId)
  cKin.AddHistoryPlayerJoin(szPlayerName)
  KKin.DelKinInductee(nKinId, szPlayerName)

  -- 加入家族的师徒成就
  Achievement_ST:FinishAchievement(nPlayerId, Achievement_ST.ENTER_KIN)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if pPlayer then
    --技能贡献点
    local nSkillOffer = pPlayer.GetTask(self.TASK_GROUP, self.TASK_SKILLOFFER)
    local nSkillOfferLost = math.floor(nSkillOffer * 0.2)
    if nSkillOfferLost > self.nLostMaxPoint then
      nSkillOfferLost = self.nLostMaxPoint
    end
    if nSkillOffer > 0 and nSkillOfferLost > 0 then
      pPlayer.SetTask(self.TASK_GROUP, self.TASK_SKILLOFFER, nSkillOffer - nSkillOfferLost)
      pPlayer.Msg("恭喜加入家族，您的家族功勋点减少" .. nSkillOfferLost)
    end

    if pPlayer.GetTask(Player.TSKGROUP_NEWPLAYER_GUIDE, Player.TSKID_NEWPLAYER_KIN) ~= 1 then
      local nYinding = pPlayer.GetTask(Kinsalary.TASK_GID, Kinsalary.TASK_YINDING)
      pPlayer.SetTask(Kinsalary.TASK_GID, Kinsalary.TASK_YINDING, nYinding + 1000)
    end

    pPlayer.SetTask(Player.TSKGROUP_NEWPLAYER_GUIDE, Player.TSKID_NEWPLAYER_KIN, 1)

    -- 成就，加入家族
    Achievement:FinishAchievement(pPlayer, 26)
  end

  local nRegular, nSigned, nRetire = cKin.GetMemberCount()
  local nMemberCount = nRegular + nSigned
  local nMemberLimit, nRetireLimit = self:GetKinMemberLimit(nKinId)
  if cKin.GetRecruitmentPublish() == 1 and (nMemberCount >= nMemberLimit or ((nRegular + nSigned + nRetire) >= (nMemberLimit + nRetireLimit))) then
    cKin.SetRecruitmentPublish(0)
    KKin.Msg2Kin(nKinId, "你的家族满员了，结束了家族招募。")
  end
  return KKinGs.KinClientExcute(nKinId, { "Kin:MemberAdd_C2", nDataVer, nPlayerId, nMemberId, nJoinTime, szPlayerName, nStoredRepute })
end

--邀请成员加入
function Kin:InviteAdd_GS1(nPlayerId, bAccept)
  if not nPlayerId then
    return 0
  end
  local cPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not cPlayer then
    return 0
  end
  local nKinId, nExcutorId = me.GetKinMember()
  local nRet, cKin = self:CheckSelfRight(nKinId, nExcutorId, 2)
  if nRet ~= 1 then
    return 0
  end
  if not self:_CheckMemberCount(nKinId) then
    me.Msg("家族人数已达上限！")
    return 0
  end
  if cPlayer.GetCamp() == 0 then
    me.Msg("白名新手不能加入家族")
    return 0
  end
  if cPlayer.nLevel < 10 then
    me.Msg("对方未满10级，不能邀请！")
    return 0
  end
  local nPlayerKinId = cPlayer.GetKinMember()

  if nPlayerKinId == nKinId then
    me.Msg("对方已经是本家族的成员！")
    return 0
  end

  if nPlayerKinId and nPlayerKinId ~= 0 then
    me.Msg("对方已经是其他家族的成员")
    return 0
  end
  --	if me.GetFriendFavor(cPlayer.szName) < self.INVITE_FAVOR then
  --		me.Msg("你与对方的亲密度小于2级，不能邀请！")
  --		return 0
  --	end
  if GetTime() - KGCPlayer.OptGetTask(nPlayerId, KGCPlayer.TSK_LEAVE_KIN_TIME) < 1800 then
    me.Msg("对方离开家族未满30分钟！")
    return 0
  end
  -----------------------------------------------------------------------------------------------------------
  -- 需在此添加警告(警告帮会建设资金已经满了)
  local nStockPercent = 1
  local nTongId = cKin.GetBelongTong()
  if nTongId then
    local pTong = KTong.GetTong(nTongId)
    if pTong then
      local nBuildFund = pTong.GetBuildFund() or 0
      local nPersonalStock = KGCPlayer.OptGetTask(nPlayerId, KGCPlayer.TSK_TONGSTOCK) -- 个人资产;
      if nBuildFund > Tong.MAX_BUILD_FUND then
        nBuildFund = Tong.MAX_BUILD_FUND
      end
      if nPersonalStock > 0 and nPersonalStock > (Tong.MAX_BUILD_FUND - nBuildFund) then
        nStockPercent = (Tong.MAX_BUILD_FUND - nBuildFund) / nPersonalStock
      end
    end
  end

  if not bAccept or bAccept ~= 1 then
    if 1 ~= nStockPercent then
      local nTemp = math.floor(nStockPercent * 100)
      local szMsg = "<color=green>【" .. cKin.GetName() .. "】<color>家族会长<color=yellow>【" .. me.szName .. "】<color>邀请你加入家族\n"
      szMsg = szMsg .. "由于你的加入会使家族所在帮会的建设资金超过上限，所以你在帮会中获取的股份只有正常情况下的<color=yellow> " .. nTemp .. "%<color> ！"

      local function SayWhat(nInvitor, nPlayerId, bAccept)
        local cInvitor = KPlayer.GetPlayerObjById(nInvitor)
        if not cInvitor then
          return
        end
        if bAccept and bAccept == 1 then
          Setting:SetGlobalObj(cInvitor)
          Kin:InviteAdd_GS1(nPlayerId, bAccept)
          Setting:RestoreGlobalObj()
        else
          cInvitor.Msg(me.szName .. "拒绝了你的邀请！")
          me.Msg("你拒绝了对方的加入家族邀请！")
        end
      end
      local nInvitor = me.nId
      Setting:SetGlobalObj(cPlayer)
      Dialog:Say(szMsg, {
        { "确定", SayWhat, nInvitor, nPlayerId, 1 },
        { "拒绝", SayWhat, nInvitor, nPlayerId, 0 },
      })

      Setting:RestoreGlobalObj()
      return 0
    end
  end
  -----------------------------------------------------------------------------------------------------------
  local aInviteEvent = self:GetKinData(nKinId).aInviteEvent
  aInviteEvent[nPlayerId] = 1
  --5分钟后超时（可能造成本次定时器误删下一次同一玩家推荐事件的bug，但影响不大）
  Timer:Register(5 * 60 * 18, self.InviteCancel_GS, self, nKinId, nPlayerId)
  return cPlayer.CallClientScript({ "Kin:InviteAdd_C2", nKinId, nExcutorId, cKin.GetName(), me.szName, nStockPercent })
end
RegC2SFun("InviteAdd", Kin.InviteAdd_GS1)

--时间到取消邀请
function Kin:InviteCancel_GS(nKinId, nPlayerId)
  local aInviteEvent = self:GetKinData(nKinId).aInviteEvent
  aInviteEvent[nPlayerId] = nil
  return 0
end

--回答邀请
function Kin:InviteAddReply_GS1(nKinId, nInvitorId, bAccept)
  local nPlayerId = me.nId
  local aInviteEvent = self:GetKinData(nKinId).aInviteEvent
  if bAccept ~= 1 then
    local cKin = KKin.GetKin(nKinId)
    if not cKin then
      return 0
    end
    local cMember = cKin.GetMember(nInvitorId)
    if not cMember then
      return 0
    end
    local cPlayer = KPlayer.GetPlayerObjById(cMember.GetPlayerId())
    if cPlayer then
      cPlayer.Msg("<color=white>" .. me.szName .. "<color>拒绝了您的家族邀请！")
    end
    return 0
  end
  if not aInviteEvent[nPlayerId] then
    me.Msg("回答超时或对方已不在线！")
    return 0
  end
  aInviteEvent[nPlayerId] = nil
  local bCanJoinKinImmediately = me.CanJoinKinImmediately() -- 用来判断是否可以立即加入家族并且转正
  return self:MemberAdd_GS1(nKinId, nInvitorId, nPlayerId, bCanJoinKinImmediately)
end
RegC2SFun("InviteAddReply", Kin.InviteAddReply_GS1)

--删除成员，nMethod = 0自己退出，nMethod = 1开除
function Kin:MemberDel_GS1(nKinId, nMemberId, nMethod)
  return GCExcute({ "Kin:MemberDel_GC", nKinId, nMemberId, nMethod })
end

function Kin:MemberDel_GS2(nDataVer, nKinId, nMemberId, nPlayerId, nMethod, nReputeLeft, nRepute)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  local cMember = cKin.GetMember(nMemberId)
  if not cMember then
    return 0
  end
  if cMember.GetFigure() == self.FIGURE_ASSISTANT then
    cKin.SetAssistant(0)
  end
  --退出时的时间
  KGCPlayer.OptSetTask(nPlayerId, KGCPlayer.TSK_LEAVE_KIN_TIME, GetTime())
  cKin.DelMember(nMemberId)
  cKin.SetKinDataVer(nDataVer)
  cKin.AddTotalRepute(-nRepute)
  KKinGs.PlayerLeaveKin(nPlayerId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if pPlayer then
    local szMsg = "你已经离开了家族。"
    pPlayer.Msg(szMsg)
    Dialog:SendBlackBoardMsg(pPlayer, szMsg)
  end
  return KKinGs.KinClientExcute(nKinId, { "Kin:MemberDel_C2", nDataVer, nMemberId, KGCPlayer.GetPlayerName(nPlayerId), nMethod, nRepute })
end

function Kin:DisbandKin_GS2(nKinId)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  -- 把家族成员全部剔除家族
  local itor = cKin.GetMemberItor()
  local cMember = itor.GetCurMember()
  while cMember do
    local nMemberId = itor.GetCurMemberId()
    local cTmpMember = itor.NextMember()
    local nPlayerId = cMember.GetPlayerId()
    if nPlayerId > 0 then
      KGCPlayer.OptSetTask(nPlayerId, KGCPlayer.TSK_LEAVE_KIN_TIME, GetTime())
      KKinGs.PlayerLeaveKin(nPlayerId)
    end
    cKin.DelMember(nMemberId)
    cMember = cTmpMember
  end
  KKin.DelKin(nKinId)
end

function Kin:MemberLeave_GS1(nType)
  local nKinId, nExcutorId = me.GetKinMember()
  if nKinId == 0 or nExcutorId == 0 then
    return 0
  end
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  local cMember = cKin.GetMember(nExcutorId)
  if not cMember then
    return 0
  end
  if nType and nType == 1 then
    local tbData = self:GetExclusiveEvent(nKinId, self.KIN_EVENT_TAKE_FUND)
    if tbData.nApplyEvent and tbData.nApplyEvent == 1 and tbData.tbApplyRecord and tbData.tbApplyRecord.nMemberId == nExcutorId then
      me.CallClientScript({ "Ui:ServerCall", "UI_KIN", "MemberLeavePromt_C2" }) -- 提示客户端确认是否叛离
      return 0
    end
  end
  local nFigure = cMember.GetFigure()
  if nFigure == self.FIGURE_CAPTAIN then
    me.Msg("族长不能直接退出家族！")
    return 0
  end
  if nFigure ~= self.FIGURE_SIGNED and nFigure > 0 then
    local nTime = cMember.GetLeaveInitTime()
    local bCanLeaveKinImmediately = me.CanLeaveKinImmediately()
    if nTime == 0 then
      if bCanLeaveKinImmediately == 0 then
        Dialog:Say("正式成员退出家族必须先行申请，三天后才能退出成功，你确定要申请退出家族吗？", { "申请退出", self.LeaveApply_GS1, self, 1 }, { "关闭" })
      elseif bCanLeaveKinImmediately == 1 then
        Dialog:Say("您是被召回老玩家，有一次立即退出家族的机会，你确定要申请退出家族吗？", { "申请退出", self.LeaveApply_GS1, self, 1, 1 }, { "关闭" })
      end
    else
      Dialog:Say("你已经申请退出家族，申请日之后第三天的18点会正式退出家族，在此之前你可以随时取消退出状态", { "取消退出", self.LeaveApply_GS1, self, 0 }, { "关闭" })
    end
    return 1
  end
  return self:MemberDel_GS1(nKinId, nExcutorId, 0)
end
RegC2SFun("MemberLeave", Kin.MemberLeave_GS1)

function Kin:LeaveApply_GS1(bLeave, bCanLeaveKinImmediately)
  local nKinId, nExcutorId = me.GetKinMember()
  if nKinId == 0 or nExcutorId == 0 then
    return 0
  end
  if bLeave == 1 then
    if not bCanLeaveKinImmediately or bCanLeaveKinImmediately == 0 then
      me.Msg("你已成功申请退出家族，申请日之后第三天的18点才会正式执行退出，在正式退出前你随时可取消退出申请状态！")
    elseif bCanLeaveKinImmediately and bCanLeaveKinImmediately == 1 then
      GCExcute({ "Kin:MemberDel_GC", nKinId, nExcutorId, 0 })
      me.Msg("您已经成功退出家族。")
    end
  else
    me.Msg("你已成功取消退出申请状态！")
  end
  Dbg:WriteLog("Kin", "ApplyLeave", me.szName, bLeave, nKinId, nExcutorId)
  return GCExcute({ "Kin:LeaveApply_GC", nKinId, nExcutorId, bLeave })
end

function Kin:LeaveApply_GS2(nKinId, nExcutorId, nTime)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  local cMember = cKin.GetMember(nExcutorId)
  if not cMember then
    return 0
  end
  cMember.SetLeaveInitTime(nTime)
  return 1
end

--发起开除成员
function Kin:MemberKickInit_GS1(nMemberId)
  local nKinId, nExcutorId = me.GetKinMember()
  if nExcutorId == nMemberId then
    me.Msg("你不能开除自己！")
    return 0
  end
  local nRet, cKin = self:CheckSelfRight(nKinId, nExcutorId, 2)
  if nRet ~= 1 then
    me.Msg("只有族长或副族长才能发起开除成员！")
    return 0
  end
  local cMember = cKin.GetMember(nMemberId)
  if not cMember then
    return 0
  end
  local nFigure = cMember.GetFigure()
  if nFigure <= self.FIGURE_ASSISTANT then
    me.Msg("族长和副族长不能直接开除！")
    return 0
  end

  -- 首领不能开除
  local nTongId = cKin.GetBelongTong()
  if Tong:IsPresident(nTongId, nKinId, nMemberId) == 1 then
    me.Msg("首领不能直接开除！")
    return 0
  end

  --记名成员直接开除
  if nFigure == self.FIGURE_SIGNED then
    return self:MemberDel_GS1(nKinId, nMemberId, 1)
  end
  local aThisKickEvent = self:GetKinData(nKinId).aKickEvent
  if aThisKickEvent[nMemberId] then
    me.Msg("上次发起对该成员的开除申请尚未超时！")
    return 0
  end
  local szName = KGCPlayer.GetPlayerName(cMember.GetPlayerId())
  me.Msg(string.format("你发起了开除成员“%s”，在10分钟内需要有另外两名家族正式成员同意才能正式开除成功。", szName))
  return GCExcute({ "Kin:MemberKickInit_GC", nKinId, nExcutorId, nMemberId })
end
RegC2SFun("MemberKickInit", Kin.MemberKickInit_GS1)

function Kin:MemberKickInit_GS2(nKinId, nExcutorId, nMemberId)
  local aThisKickEvent = self:GetKinData(nKinId).aKickEvent
  aThisKickEvent[nMemberId] = nExcutorId
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return
  end
  local cMember = cKin.GetMember(nMemberId)
  return KKinGs.KinClientExcute(nKinId, { "Kin:MemberKickInit_C2", nMemberId, KGCPlayer.GetPlayerName(cMember.GetPlayerId()) })
end

--开除成员的响应
function Kin:MemberKickRespond_GS1(nMemberId, nAccept)
  local nKinId, nExcutorId = me.GetKinMember()
  if self:HaveFigure(nKinId, nExcutorId, 3) ~= 1 then
    me.Msg("非正式成员表决无效！")
    return 0
  end
  local aThisKickEvent = self:GetKinData(nKinId).aKickEvent
  if not aThisKickEvent[nMemberId] then
    me.Msg("该申请已超时了！")
    return 0
  end
  if nExcutorId == aThisKickEvent[nMemberId] then
    me.Msg("发起者表决无效！")
    return 0
  end
  if nAccept == 1 then
    me.Msg("你同意了开除成员的申请！")
    return GCExcute({ "Kin:MemberKickRespond_GC", nKinId, nExcutorId, nMemberId })
  else
    me.Msg("你反对开除成员的申请！")
    return 1
  end
end
RegC2SFun("MemberKickRespond", Kin.MemberKickRespond_GS1)

function Kin:MemberKickRespond_GS2(nKinId, nMemberId, nEventId) end

-- 退隐
function Kin:MemberRetire_GS1(nMemberId)
  local nKinId, nExcutorId = me.GetKinMember()
  if not nMemberId then
    nMemberId = nExcutorId
  end

  local cKin, cMember
  if nMemberId ~= nExcutorId then
    local nRet
    nRet, cKin = self:CheckSelfRight(nKinId, nExcutorId, 2)
    if nRet ~= 1 then
      return 0
    end
    cMember = cKin.GetMember(nMemberId)
  else
    cKin = KKin.GetKin(nKinId)
    if not cKin then
      return 0
    end
    cMember = cKin.GetMember(nExcutorId)
  end
  if not cMember then
    return 0
  end

  local nFigure = cMember.GetFigure()
  if nFigure == self.FIGURE_CAPTAIN then
    me.Msg("族长不能退隐！")
    return 0
  end
  if cMember.GetFigure() > self.FIGURE_REGULAR then
    me.Msg("正式成员才能退隐！")
    return 0
  end

  -- 首领不能退隐
  local nTongId = cKin.GetBelongTong()
  if Tong:IsPresident(nTongId, nKinId, nMemberId) == 1 then
    me.Msg("首领不能退隐！")
    return 0
  end
  local nRegular, nSigned, nRetireCount = cKin.GetMemberCount()
  local nMember, nRetire = self:GetKinMemberLimit(nKinId)
  if nRetireCount >= nRetire then
    me.Msg("退隐的成员已经到达上限，你不能退隐！")
    return 0
  end

  return GCExcute({ "Kin:MemberRetire_GC", nKinId, nMemberId })
end
RegC2SFun("MemberRetire", Kin.MemberRetire_GS1)

function Kin:MemberRetire_GS2(nKinId, nMemberId, nTime)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  local cMember = cKin.GetMember(nMemberId)
  if not cMember then
    return 0
  end
  local nFigure = cMember.GetFigure()
  if nFigure == self.FIGURE_ASSISTANT then
    cKin.SetAssistant(0) -- 副族长退隐
  end
  cMember.SetRepAuthority(0)
  cMember.SetFigure(self.FIGURE_RETIRE)
  cMember.SetEnvoyFigure(0) -- 退隐删除掌令使职位
  cMember.SetBitExcellent(0) -- 退隐删除精英
  cMember.SetRetireTime(nTime) -- 记录退隐时间
  local nPlayerId = cMember.GetPlayerId()
  KKinGs.UpdateKinInfo(nPlayerId)
  return KKinGs.KinClientExcute(nKinId, { "Kin:MemberRetire_C2", nMemberId, KGCPlayer.GetPlayerName(nPlayerId) })
end

-- 取消退隐
function Kin:CancelRetire_GS1()
  local nKinId, nMemberId = me.GetKinMember()
  if nKinId == 0 or nMemberId == 0 then
    me.Msg("你没有家族")
    return 0
  end
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  local cMember = cKin.GetMember(nMemberId)
  if not cMember then
    return 0
  end
  local nFigure = cMember.GetFigure()
  if nFigure ~= self.FIGURE_RETIRE then
    me.Msg("你不是退隐成员！不需要取消退隐！")
    return 0
  end
  if not self:_CheckMemberCount(nKinId, 1) then -- 到达人数上限，取消退隐失败
    me.Msg("家族正式和记名成员已达上限！不能取消退隐！")
    return 0
  end
  if GetTime() - cMember.GetRetireTime() < self.CANCEL_RETIRE_TIME then
    me.Msg("取消退隐必须退隐达到7天以上！")
    return 0
  end
  GCExcute({ "Kin:CancelRetire_GC", nKinId, nMemberId })
end
RegC2SFun("CancelRetire", Kin.CancelRetire_GS1)

function Kin:CancelRetire_GS2(nKinId, nMemberId)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  local cMember = cKin.GetMember(nMemberId)
  if not cMember then
    return 0
  end
  cMember.SetFigure(self.FIGURE_REGULAR)
  local nPlayerId = cMember.GetPlayerId()
  KKinGs.UpdateKinInfo(nPlayerId)

  local nRegular, nSign, nRetire = cKin.GetMemberCount()
  local nMemberLimit, nRetireLimit = self:GetKinMemberLimit(nKinId)
  local nMemberCount = nRegular + nSign + 1
  if cKin.GetRecruitmentPublish() == 1 and (nMemberCount >= nMemberLimit or (nRegular + nSign + nRetire) >= (nMemberLimit + nRetireLimit)) then
    cKin.SetRecruitmentPublish(0)
    KKin.Msg2Kin(nKinId, "你的家族满员了，结束了家族招募。")
  end

  return KKinGs.KinClientExcute(nKinId, { "Kin:CancelRetire_C2", nMemberId, KGCPlayer.GetPlayerName(nPlayerId) })
end

-- 拥有转正资格
function Kin:SetCan2Regular_GS2(nKinId, nMemberId)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  local cMember = cKin.GetMember(nMemberId)
  if not cMember then
    return 0
  end
  cMember.SetCan2Regular(1)
  return 1
end

-- 试用转正GS1
function Kin:Member2Regular_GS1(nKinId, nMemberId)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  local cMember = cKin.GetMember(nMemberId)
  if not cMember then
    return 0
  end
  local nSelfKinId, nSelfMemberId = me.GetKinMember()
  if Kin:HaveFigure(nSelfKinId, nSelfMemberId, Kin.FIGURE_REGULAR) ~= 1 then
    me.Msg("你没权限把指定玩家转为正式成员")
    return 0
  end
  if cMember.GetFigure() ~= self.FIGURE_SIGNED then
    me.Msg("该玩家已经是正式成员了")
    return 0
  end
  if cMember.GetCan2Regular() ~= 1 then
    me.Msg("该玩家还没过家族试用期")
    return 0
  end
  local szName = KGCPlayer.GetPlayerName(cMember.GetPlayerId())
  if not szName or not me.GetFriendFavor(szName) or me.GetFriendFavor(szName) < self.INVITE_FAVOR then
    me.Msg("你和指定玩家的亲密度不足，不能把他转为正式成员")
    return 0
  end
  return GCExcute({ "Kin:Member2Regular_GC", nKinId, nMemberId })
end
RegC2SFun("Member2Regular", Kin.Member2Regular_GS1)

-- 试用转正GS2
function Kin:Member2Regular_GS2(nKinId, nMemberId)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  local cMember = cKin.GetMember(nMemberId)
  if not cMember then
    return 0
  end
  cMember.SetFigure(self.FIGURE_REGULAR)

  local pPlayer = KPlayer.GetPlayerObjById(cMember.GetPlayerId())
  if pPlayer then
    pPlayer.nKinFigure = self.FIGURE_REGULAR
  end

  return KKinGs.KinClientExcute(nKinId, { "Kin:Member2Regular_C2", nMemberId, KGCPlayer.GetPlayerName(cMember.GetPlayerId()) })
end

--踢人事件取消
function Kin:MemberKickCancel_GS2(nKinId, nMemberId)
  local aThisKickEvent = self:GetKinData(nKinId).aKickEvent
  aThisKickEvent[nMemberId] = nil
  return 0
end

function Kin:MemberIntroduce_GS1(nPlayerId, bAccept)
  local cPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not cPlayer then
    return 0
  end
  local nKinId, nExcutorId = me.GetKinMember()
  local bRet, cKin = self:HaveFigure(nKinId, nExcutorId, 3)
  if bRet ~= 1 then
    me.Msg("非正式成员不能推荐！")
    return 0
  end
  if cPlayer.GetCamp() == 0 then
    me.Msg("新手不能加入家族！")
    return 0
  end
  if cPlayer.nLevel < 10 then
    me.Msg("对方未满10级，不能推荐！")
    return 0
  end
  if KKin.GetPlayerKinMember(nPlayerId) ~= 0 then
    me.Msg("推荐的玩家已有家族！")
    return 0
  end
  if not self:_CheckMemberCount(nKinId) then
    me.Msg("家族人数已达上限！")
    return 0
  end

  if EventManager.IVER_bOpenTiFu ~= 1 then
    if me.GetFriendFavor(cPlayer.szName) < self.INVITE_FAVOR then
      me.Msg("你与对方的亲密度小于2级，不能推荐！")
      return 0
    end
  end

  if GetTime() - KGCPlayer.OptGetTask(nPlayerId, KGCPlayer.TSK_LEAVE_KIN_TIME) < 1800 then
    me.Msg("对方离开家族未满30分钟！")
    return 0
  end
  local aThisIntroEvent = self:GetKinData(nKinId).aIntroduceEvent
  --如果推荐已经发起过，返回
  if aThisIntroEvent[nPlayerId] then
    me.Msg("已经有人推荐了该成员，等待族长回复！")
    return 0
  end
  -----------------------------------------------------------------------------------------------------------
  -- 需在此添加警告(警告帮会建设资金已经满了)
  local nTongId = cKin.GetBelongTong()
  local nStockPercent = 1
  if nTongId then
    local pTong = KTong.GetTong(nTongId)
    if pTong then
      local nBuildFund = pTong.GetBuildFund()
      local nKinFund = KGCPlayer.OptGetTask(nPlayerId, KGCPlayer.TSK_TONGSTOCK) --Kin:GetTotalKinStock(nKinId);
      nBuildFund = nBuildFund or 0
      if nBuildFund > Tong.MAX_BUILD_FUND then
        nBuildFund = Tong.MAX_BUILD_FUND
      end

      if nKinFund > 0 and nKinFund > Tong.MAX_BUILD_FUND - nBuildFund then
        nStockPercent = (Tong.MAX_BUILD_FUND - nBuildFund) / nKinFund
      end
    end
  end
  if not bAccept or bAccept ~= 1 then
    if 1 ~= nStockPercent then
      local szMsg = "家族成员<color=yellow>" .. me.szName .. "<color>推荐你加入家族 <color=green>【" .. cKin.GetName() .. "】<color>\n"
      local nTemp = math.floor(nStockPercent * 100)
      szMsg = szMsg .. "由于你的加入，家族所在帮会的建设资金将会超过上限，所以你将获得的帮会股份只有平时普通情况下的<color=yellow> " .. nTemp .. "%<color>！"
      local function SayWhat(nIntra, nPlayerId, bAccept)
        local cIntra = KPlayer.GetPlayerObjById(nIntra)
        if not cIntra then
          return
        end
        if 1 == bAccept then
          Setting:SetGlobalObj(cIntra)
          Kin:MemberIntroduce_GS1(nPlayerId, bAccept)
          Setting:RestoreGlobalObj()
        else
          cIntra.Msg(me.szName .. "拒绝了你的推荐！")
          me.Msg("你拒绝了对方的加入家族推荐！")
        end
      end
      local nIntra = me.nId
      Setting:SetGlobalObj(cPlayer)
      Dialog:Say(szMsg, {
        { "确定", SayWhat, nIntra, nPlayerId, 1 },
        { "拒绝", SayWhat, nIntra, nPlayerId, 0 },
      })
      Setting:RestoreGlobalObj()
      return 0
    end
  end
  -----------------------------------------------------------------------------------------------------------
  --未确认前先设为0
  aThisIntroEvent[nPlayerId] = 0
  --5分钟后删除（可能会造成删除下一个同一nPlayerId事件的bug，但影响很小，忽略）
  Timer:Register(5 * 60 * 18, self.IntroduceCancel_GS, self, nKinId, nPlayerId)
  --转发到被推荐人
  cPlayer.CallClientScript({ "Kin:MemberIntroduceMe_C2", nKinId, nExcutorId, cKin.GetName(), me.szName })
  --return GCExcute{"Kin:MemberIntroduce_GC", nKinId, nExcutorId, nPlayerId}
end
RegC2SFun("MemberIntroduce", Kin.MemberIntroduce_GS1)

function Kin:MemberIntroduce_GS2(nKinId, nExcutorId, nPlayerId)
  local aThisIntroEvent = self:GetKinData(nKinId).aIntroduceEvent
  --若之前未设过删除定时器，设置一个
  if not aThisIntroEvent[nPlayerId] then
    Timer:Register(5 * 60 * 18, self.IntroduceCancel_GS, self, nKinId, nPlayerId)
  end
  aThisIntroEvent[nPlayerId] = nExcutorId
  --发送到副族长以上领导层
  return KKinGs.KinClientExcute(nKinId, { "Kin:MemberIntroduce_C2", nExcutorId, nPlayerId, KGCPlayer.GetPlayerName(nPlayerId) }, self.FIGURE_ASSISTANT)
end

--被推荐人确认推荐
function Kin:MemberIntroduceConfirm_GS1(nKinId, nIntroducerId, bAccept)
  local nPlayerId = me.nId
  local aThisIntroEvent = self:GetKinData(nKinId).aIntroduceEvent
  --如果推荐事件不存在，返回
  if not aThisIntroEvent[nPlayerId] then
    return 0
  end
  if bAccept ~= 1 then
    aThisIntroEvent[nPlayerId] = nil
    local cKin = KKin.GetKin(nKinId)
    if not cKin then
      return 0
    end
    local cMember = cKin.GetMember(nIntroducerId)
    if not cMember then
      return 0
    end
    local cPlayer = KPlayer.GetPlayerObjById(cMember.GetPlayerId())
    if cPlayer then
      cPlayer.Msg("<color=white>" .. me.szName .. "<color>拒绝了您的家族推荐！")
    end
    return 0
  end
  return GCExcute({ "Kin:MemberIntroduce_GC", nKinId, nIntroducerId, nPlayerId, me.nPrestige })
end
RegC2SFun("MemberIntroduceConfirm", Kin.MemberIntroduceConfirm_GS1)

--时间到取消推荐事件
function Kin:IntroduceCancel_GS(nKinId, nPlayerId)
  local aThisIntroEvent = self:GetKinData(nKinId).aIntroduceEvent
  aThisIntroEvent[nPlayerId] = nil
  return 0
end

--接受或拒绝推荐申请
function Kin:AcceptIntroduce_GS1(nPlayerId, bAccept)
  local nKinId, nExcutorId = me.GetKinMember()
  if self:CheckSelfRight(nKinId, nExcutorId, 2) ~= 1 then
    return 0
  end
  local aThisIntroEvent = self:GetKinData(nKinId).aIntroduceEvent
  --如果推荐事件已不存在或未得到被推荐人确认
  if not aThisIntroEvent[nPlayerId] or aThisIntroEvent[nPlayerId] == 0 then
    return 0
  end
  return GCExcute({ "Kin:AcceptIntroduce_GC", nKinId, nExcutorId, nPlayerId, bAccept })
end
RegC2SFun("AcceptIntroduce", Kin.AcceptIntroduce_GS1)

function Kin:AcceptIntroduce_GS2(nKinId, nPlayerId)
  local aThisIntroEvent = self:GetKinData(nKinId).aIntroduceEvent
  --如果推荐事件已不存在
  if aThisIntroEvent[nPlayerId] then
    aThisIntroEvent[nPlayerId] = nil
  end
  return 1
end

--更换称号
function Kin:ChangeTitle_GS1(nTitleType, szTitle)
  local nKinId, nExcutorId = me.GetKinMember()
  if self:CheckSelfRight(nKinId, nExcutorId, 2) ~= 1 then
    return 0
  end
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  local nLen = GetNameShowLen(szTitle)
  if nLen > 8 then
    me.Msg("称号不能大于4汉字的长度")
    return 0
  end
  --称号名字合法性检查
  if KUnify.IsNameWordPass(szTitle) ~= 1 then
    me.Msg("称号只能包含中文简繁体字及· 【 】符号！")
    return 0
  end
  --名称过滤
  if IsNamePass(szTitle) ~= 1 then
    me.Msg("称号中包含敏感词汇！")
    return 0
  end
  --nTitleType + 1即为称号ID
  if cKin.SetBufTask(nTitleType + 1, szTitle) ~= 1 then
    return 0
  end
  return GCExcute({ "Kin:ChangeTitle_GC", nKinId, nExcutorId, nTitleType, szTitle })
end
RegC2SFun("ChangeTitle", Kin.ChangeTitle_GS1)

function Kin:ChangeTitle_GS2(nKinId, nTitleType, szTitle)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  --nTitleType + 1即为称号ID
  if cKin.SetBufTask(nTitleType + 1, szTitle) ~= 1 then
    return 0
  end
  if cKin.GetBelongTong() == 0 then
    KKinGs.UpdateKinTitle(nKinId, nTitleType, szTitle)
  end
  return KKinGs.KinClientExcute(nKinId, { "Kin:ChangeTitle_C2", nTitleType, szTitle })
end

--更换阵营
function Kin:ChangeCamp_GS2(nDataVer, nKinId, nCamp, nDate)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  local nLastCamp = cKin.GetCamp()
  if cKin.SetCamp(nCamp) ~= 1 then
    return 0
  end
  --更新所有成员阵营
  if nLastCamp ~= nCamp then
    KKinGs.UpdateKinMemberCamp(nKinId, nCamp)
  end
  cKin.SetKinDataVer(nDataVer)
  cKin.SetChangeCampDate(nDate)
  return KKinGs.KinClientExcute(nKinId, { "Kin:ChangeCamp_C2", nDataVer, nCamp })
end

--设置副族长
function Kin:SetAssistant_GS1(nMemberId)
  local nKinId, nExcutorId = me.GetKinMember()
  local nRet, cKin = self:CheckSelfRight(nKinId, nExcutorId, 1)
  if nRet ~= 1 then
    return 0
  end
  if nExcutorId == nMemberId then
    me.Msg("您不能对自己进行此操作！")
    return 0
  end
  local cMember = cKin.GetMember(nMemberId)
  if not cMember then
    return 0
  end
  if cMember.GetFigure() ~= self.FIGURE_REGULAR then
    me.Msg("只有普通正式成员才能被任命！")
    return 0
  end
  local aKinData = self:GetKinData(nKinId)
  if aKinData.nLastSetAssistantTime and GetTime() - aKinData.nLastSetAssistantTime < self.CHANGE_ASSISTANT_TIME then
    me.Msg("任命副族长间隔必须超过10分钟！")
    return 0
  end
  return GCExcute({ "Kin:SetAssistant_GC", nKinId, nExcutorId, nMemberId })
end
RegC2SFun("SetAssistant", Kin.SetAssistant_GS1)

function Kin:SetAssistant_GS2(nDataVer, nKinId, nMemberId)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  local cMember = cKin.GetMember(nMemberId)
  if not cMember then
    return 0
  end
  local aKinData = self:GetKinData(nKinId)
  aKinData.nLastSetAssistantTime = GetTime()
  --旧的副族长变为普通成员
  local nOldAssistant = cKin.GetAssistant()
  if nOldAssistant ~= 0 then
    local cOldAssistant = cKin.GetMember(nOldAssistant)
    if cOldAssistant then
      cOldAssistant.SetFigure(self.FIGURE_REGULAR)
      KKinGs.UpdateKinInfo(cOldAssistant.GetPlayerId())
    end
  end
  --设置并更新新副族长信息
  cKin.SetAssistant(nMemberId)
  cMember.SetFigure(self.FIGURE_ASSISTANT)
  KKinGs.UpdateKinInfo(cMember.GetPlayerId())
  cKin.SetKinDataVer(nDataVer)
  return KKinGs.KinClientExcute(nKinId, { "Kin:SetAssistant_C2", nDataVer, nMemberId, KGCPlayer.GetPlayerName(cMember.GetPlayerId()) })
end

--免除副族长
function Kin:FireAssistant_GS1(nMemberId)
  local nKinId, nExcutorId = me.GetKinMember()
  local nRet, cKin = self:CheckSelfRight(nKinId, nExcutorId, 1)
  if nRet ~= 1 then
    return 0
  end
  if cKin.GetAssistant() ~= nMemberId then
    return 0
  end
  return GCExcute({ "Kin:FireAssistant_GC", nKinId, nExcutorId, nMemberId })
end
RegC2SFun("FireAssistant", Kin.FireAssistant_GS1)

function Kin:FireAssistant_GS2(nKinId, nMemberId)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  local cMember = cKin.GetMember(nMemberId)
  if not cMember then
    return 0
  end
  cMember.SetFigure(self.FIGURE_REGULAR)
  KKinGs.UpdateKinInfo(cMember.GetPlayerId())
  cKin.SetAssistant(0)
  return KKinGs.KinClientExcute(nKinId, { "Kin:FireAssistant_C2", nMemberId, KGCPlayer.GetPlayerName(cMember.GetPlayerId()) })
end

--更换族长
function Kin:ChangeCaptain_GS1(nMemberId)
  local nKinId, nExcutorId = me.GetKinMember()
  local nRet, cKin, cExcutor = self:CheckSelfRight(nKinId, nExcutorId, 1)
  if nRet ~= 1 then
    return 0
  end
  local nPlayerId = cExcutor.GetPlayerId()
  if KGCPlayer.GetPlayerPrestige(nPlayerId) < 10 then
    me.Msg("江湖威望需大于10才能进行族长移交！")
    return 0
  end
  if nExcutorId == nMemberId then
    return 0
  end
  local cMember = cKin.GetMember(nMemberId)
  if not cMember then
    return 0
  end
  if cMember.GetFigure() > self.FIGURE_REGULAR then
    me.Msg("非正式成员不能移交！")
    return 0
  end
  return GCExcute({ "Kin:ChangeCaptain_GC", nKinId, nExcutorId, nMemberId })
end
RegC2SFun("ChangeCaptain", Kin.ChangeCaptain_GS1)

function Kin:ChangeCaptain_GS2(nDataVer, nKinId, nExcutorId, nMemberId)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  local cMember = cKin.GetMember(nMemberId)
  if not cMember then
    return 0
  end
  if cKin.GetAssistant() == nMemberId then
    cKin.SetAssistant(0)
  end
  local cExcutor = cKin.GetMember(nExcutorId)
  if cExcutor then
    cExcutor.SetFigure(self.FIGURE_REGULAR)
  end

  -- 如果族长是帮主，也记录到帮会事件上
  local nTongId = cKin.GetBelongTong()
  local szNewCaptain = KGCPlayer.GetPlayerName(cMember.GetPlayerId())
  local szOldCaptain = KGCPlayer.GetPlayerName(cExcutor.GetPlayerId())
  if nTongId then
    local pTong = KTong.GetTong(nTongId)
    if pTong then
      if pTong.GetMaster() == nKinId then
        pTong.AddAffairChangeMaster(szNewCaptain, szOldCaptain)
      end
    end
  end

  cKin.SetCaptain(nMemberId)
  cMember.SetFigure(self.FIGURE_CAPTAIN)

  KKinGs.UpdateKinInfo(cMember.GetPlayerId())
  KKinGs.UpdateKinInfo(cExcutor.GetPlayerId())
  cKin.AddAffairChangeCaptain(szNewCaptain, szOldCaptain)
  cKin.SetKinDataVer(nDataVer)
  -- 移交仓库权限
  cMember.SetRepAuthority(KinRepository.AUTHORITY_FIGURE_CAPTAIN)
  cExcutor.SetRepAuthority(0)
  local pPlayer = KPlayer.GetPlayerObjById(cMember.GetPlayerId())
  if pPlayer then
    Achievement:FinishAchievement(pPlayer, 33) -- 成就，成为族长
  end

  return KKinGs.KinClientExcute(nKinId, { "Kin:ChangeCaptain_C2", nDataVer, nMemberId, KGCPlayer.GetPlayerName(cMember.GetPlayerId()) })
end

--发起罢免族长
function Kin:FireCaptain_Init_GS1()
  local nKinId, nExcutorId = me.GetKinMember()
  local nRet, cKin, cExcutor = self:CheckSelfRight(nKinId, nExcutorId, 3)
  if nRet ~= 1 then
    return 0
  end
  local aKinData = self:GetKinData(nKinId)
  if aKinData.eveFireCaptain0 then
    me.Msg("上次罢免族长的申请尚未结束！")
    return 0
  end
  return GCExcute({ "Kin:FireCaptain_Init_GC", nKinId, nExcutorId })
end
RegC2SFun("FireCaptainInit", Kin.FireCaptain_Init_GS1)

function Kin:FireCaptain_Init_GS2(nKinId, nExcutorId)
  local aKinData = self:GetKinData(nKinId)
  aKinData.eveFireCaptain0 = nExcutorId
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  local cMember = cKin.GetMember(nExcutorId)
  if not cMember then
    return 0
  end
  return KKinGs.KinClientExcute(nKinId, { "Kin:FireCaptain_Init_C2", nExcutorId, KGCPlayer.GetPlayerName(cMember.GetPlayerId()) })
end

function Kin:FireCaptain_Vote_GS1()
  local nKinId, nExcutorId = me.GetKinMember()
  local nRet, cKin, cExcutor = self:HaveFigure(nKinId, nExcutorId, 3)
  if nRet ~= 1 then
    return 0
  end
  local aKinData = self:GetKinData(nKinId)
  if not aKinData.eveFireCaptain0 then
    me.Msg("罢免族长的申请未发起或已经超时！")
    return 0
  end
  --已经表决过
  if aKinData.eveFireCaptain0 == nExcutorId or aKinData.eveFireCaptain1 == nExcutorId then
    return 0
  end
  return GCExcute({ "Kin:FireCaptain_Vote_GC", nKinId, nExcutorId })
end
RegC2SFun("FireCaptainVote", Kin.FireCaptain_Vote_GS1)

function Kin:FireCaptain_Cancel_GS2(nKinId)
  local aKinData = self:GetKinData(nKinId)
  aKinData.eveFireCaptain0 = nil
  aKinData.eveFireCaptain1 = nil
end

function Kin:FireCaptain_Vote_GS2(nKinId, nExcutorId, bLock)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  local cMember = cKin.GetMember(nExcutorId)
  if not cMember then
    return 0
  end
  local aKinData = self:GetKinData(nKinId)
  if bLock and bLock == 1 then
    aKinData.eveFireCaptain0 = nil
    aKinData.eveFireCaptain1 = nil
    cKin.SetCaptainLockState(1)
  else
    aKinData.eveFireCaptain1 = nExcutorId
  end
  return KKinGs.KinClientExcute(nKinId, { "Kin:FireCaptain_Vote_C2", nExcutorId, KGCPlayer.GetPlayerName(cMember.GetPlayerId()), bLock })
end

--编辑公告
function Kin:SetAnnounce_GS1(szAnnounce)
  local nKinId, nExcutorId = me.GetKinMember()
  if self:CheckSelfRight(nKinId, nExcutorId, 2) ~= 1 then
    return 0
  end
  if #szAnnounce > self.ANNOUNCE_MAX_LEN then
    me.Msg("公告字数大于允许的最大长度!")
    return 0
  end
  return GCExcute({ "Kin:SetAnnounce_GC", nKinId, nExcutorId, szAnnounce })
end
RegC2SFun("SetAnnounce", Kin.SetAnnounce_GS1)

-- 编辑家园描述
function Kin:SetHomeLandDesc_GS1(szHomeLandDesc)
  local nKinId, nExcutorId = me.GetKinMember()
  if self:CheckSelfRight(nKinId, nExcutorId, 2) ~= 1 then
    return 0
  end
  if #szHomeLandDesc > self.HOMELANDDESC_MAX_LEN then
    me.Msg("家园描述字数大于允许的最大长度!")
    return 0
  end
  return GCExcute({ "Kin:SetHomeLandDesc_GC", nKinId, nExcutorId, szHomeLandDesc })
end
--RegC2SFun("SetHomeLandDesc", Kin.SetHomeLandDesc_GS1) -- 暂时不允许玩家编辑

function Kin:SetHomeLandDesc_GS2(nDataVer, nKinId, szHomeLandDesc)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  if cKin.SetHomeLandDesc(szHomeLandDesc) ~= 1 then
    return 0
  end
  cKin.SetKinDataVer(nDataVer)
  return KKinGs.KinClientExcute(nKinId, { "Kin:SetHomeLandDesc_C2", nDataVer, szHomeLandDesc })
end

function Kin:SetAnnounce_GS2(nDataVer, nKinId, szAnnounce)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  if cKin.SetAnnounce(szAnnounce) ~= 1 then
    return 0
  end
  cKin.SetKinDataVer(nDataVer)
  return KKinGs.KinClientExcute(nKinId, { "Kin:SetAnnounce_C2", nDataVer, szAnnounce })
end

-- 招募公告
function Kin:SetRecAnnounce_GS1(szRecAnnounce)
  local nKinId, nExcutorId = me.GetKinMember()
  if self:CheckSelfRight(nKinId, nExcutorId, 2) ~= 1 then
    return 0
  end
  if #szRecAnnounce > self.REC_ANNOUNCE_MAX_LEN then
    me.Msg("招募公告字数大于允许的最大长度!")
    return 0
  end
  return GCExcute({ "Kin:SetRecAnnounce_GC", nKinId, nExcutorId, szRecAnnounce })
end
RegC2SFun("SetRecAnnounce", Kin.SetRecAnnounce_GS1)

function Kin:SetRecAnnounce_GS2(nDataVer, nKinId, szRecAnnounce)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  if cKin.SetRecAnnounce(szRecAnnounce) ~= 1 then
    return 0
  end
  cKin.SetKinDataVer(nDataVer)
  return KKinGs.KinClientExcute(nKinId, { "Kin:SetRecAnnounce_C2", nDataVer, szRecAnnounce })
end

function Kin:StartCaptainVote_GS2(nKinId, nStartTime)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  cKin.SetVoteStartTime(nStartTime)
  KKin.Msg2Kin(nKinId, "家族族长竞选启动！家族正式成员现在可通过家族界面投票！")
  return 1
end

--停止单个家族的竞选
function Kin:StopCaptainVote_GS1(nKinId)
  return GCExcute({ "Kin:StopCaptainVote_GC", nKinId })
end

function Kin:StopCaptainVote_GS2(nKinId, nMember, nMaxBallot)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  cKin.SetVoteCounter(0)
  cKin.SetVoteStartTime(0)
  local itor = cKin.GetMemberItor()
  local cMember = itor.GetCurMember()
  while cMember do
    --清空投票数据
    cMember.SetBallot(0)
    cMember.SetVoteState(0)
    cMember.SetVoteJourNum(0)

    cMember = itor.NextMember()
  end
  --解除族长锁定状态
  cKin.SetCaptainLockState(0)
  if nMember == 0 or nMaxBallot == 0 then
    KKin.Msg2Kin(nKinId, "本届家族竞选结束，由于无人投票，现任族长继续留任！")
    return 1
  end
  local cMemberNewCaptain = cKin.GetMember(nMember)
  if cMemberNewCaptain then
    KKin.Msg2Kin(nKinId, "本届家族竞选结束，<color=white>" .. KGCPlayer.GetPlayerName(cMemberNewCaptain.GetPlayerId()) .. "<color>以<color=yellow>" .. nMaxBallot .. "<color>的最高票数当选为新一任族长！")
  end
  return 1
end

--族长竞选投票
function Kin:CaptainVoteBallot_GS1(nMemberId)
  local nKinId, nExcutorId = me.GetKinMember()
  local nRet, cKin, cMemberExcutor = self:HaveFigure(nKinId, nExcutorId, 3)
  if nRet ~= 1 then
    return 0
  end
  local nVoteStartTime = cKin.GetVoteStartTime()
  if nVoteStartTime == 0 then
    me.Msg("目前不是族长竞选期！")
    return 0
  end
  if cMemberExcutor.GetFigure() > self.FIGURE_REGULAR then
    me.Msg("正式成员才能投票！")
    return 0
  end
  if cMemberExcutor.GetVoteState() == nVoteStartTime then
    me.Msg("您已投过票！")
    return 0
  end
  local nPlayerId = cMemberExcutor.GetPlayerId()
  local nBallot = KGCPlayer.GetPlayerPrestige(nPlayerId)
  if nBallot <= 0 then
    me.Msg("江湖威望值必须大于0才能投票！")
    return 0
  end
  local cMemberTarget = cKin.GetMember(nMemberId)
  if not cMemberTarget or cMemberTarget.GetFigure() > self.FIGURE_REGULAR then
    me.Msg("只能对家族正式成员投票！")
    return 0
  end
  me.Msg("投票成功！")
  cMemberExcutor.SetVoteState(nVoteStartTime)
  return GCExcute({ "Kin:CaptainVoteBallot_GC", nKinId, nExcutorId, nMemberId })
end
RegC2SFun("CaptainVoteBallot", Kin.CaptainVoteBallot_GS1)

function Kin:CaptainVoteBallot_GS2(nKinId, nExcutorId, nMemberId, nBallot, nVoteCounter)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  local cExcutor = cKin.GetMember(nExcutorId)
  local cMember = cKin.GetMember(nMemberId)
  if not cExcutor or not cMember then
    return 0
  end
  cExcutor.SetVoteState(cKin.GetVoteStartTime())
  cMember.AddBallot(nBallot)
  cMember.SetVoteJourNum(nVoteCounter)
  return KKinGs.KinClientExcute(nKinId, { "Kin:CaptainVoteBallot_C2", nExcutorId, nMemberId, nBallot })
end

function Kin:JoinTong_GS2(nKinId, szTong, nTongId, nCamp)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  local nLastCamp = cKin.GetCamp()
  cKin.SetLastCamp(nLastCamp)
  cKin.SetBelongTong(nTongId)
  cKin.SetCamp(nCamp)
  KKinGs.KinAttachTong(nKinId, nTongId)
  cKin.AddHistoryJoinTong(szTong)
  return KKinGs.KinClientExcute(nKinId, { "Kin:JoinTong_C2", szTong })
end

function Kin:ApplyQuiitTong_GS1(nType)
  local nKinId, nExcutorId = me.GetKinMember()
  if self:CheckSelfRight(nKinId, nExcutorId, 1) ~= 1 then
    return 0
  end
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  if cKin.GetApplyQuitTime() ~= 0 then
    me.Msg("已经发起了退出帮会，不能重复发起！")
    return 0
  end
  local nTongId = cKin.GetBelongTong()
  if nTongId == 0 then
    return 0
  end
  if nType and nType == 1 then
    local tbData = Tong:GetExclusiveEvent(nTongId, Tong.REQUEST_STORAGE_FUND_TO_KIN)
    if tbData.nApplyEvent and tbData.nApplyEvent == 1 and tbData.ApplyRecord and tbData.ApplyRecord.nTargetKinId == nKinId then
      me.CallClientScript({ "Ui:ServerCall", "UI_KIN", "LeaveTongPromt_C2" }) -- 提示客户端确认是否叛离
      return 0
    end
  end
  if cKin.GetTongFigure() == 1 then
    me.Msg("帮主所在家族不能退出帮会!")
    return 0
  end
  return GCExcute({ "Kin:ApplyQuitTong_GC", nTongId, nKinId, nExcutorId })
end
RegC2SFun("LeaveTong", Kin.ApplyQuiitTong_GS1)

function Kin:ApplyQuitTong_GS2(nKinId, nApplyQuitTime)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  cKin.SetApplyQuitTime(nApplyQuitTime)
  return KKinGs.KinClientExcute(nKinId, { "Kin:ApplyQuitTong_C2", nApplyQuitTime })
end

function Kin:QuitTongVote_GS1(nAccept)
  local nKinId, nMemberId = me.GetKinMember()
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  if cKin.GetApplyQuitTime() == 0 then
    me.Msg("没有发起退出帮会或发起已结束")
    return 0
  end
  local cMember = cKin.GetMember(nMemberId)
  if not cMember then
    return 0
  end
  if cMember.GetQuitVoteState() ~= 0 then
    me.Msg("你已经表决过了")
    return 0
  end
  return GCExcute({ "Kin:QuitTongVote_GC", nKinId, nMemberId, nAccept })
end
RegC2SFun("QuitTongVote", Kin.QuitTongVote_GS1)

function Kin:QuitTongVote_GS2(nKinId, nMemberId, nAccept)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  local cMember = cKin.GetMember(nMemberId)
  if not cMember then
    return 0
  end
  cMember.SetQuitVoteState((nAccept == 1) and 1 or 2)
  local nPlayerId = cMember.GetPlayerId()
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return 0
  end
  return pPlayer.CallClientScript({ "Kin:QuitTongVote_C2", nAccept })
end

-- 主动取消离开帮会
function Kin:CloseQuitTong_GS1()
  local nKinId, nMemberId = me.GetKinMember()
  if self:CheckSelfRight(nKinId, nMemberId, 1) ~= 1 then
    me.Msg("你没有权限取消离开帮会")
    return 0
  end
  return GCExcute({ "Kin:CloseQuitTong_GC", nKinId, 2 })
end
RegC2SFun("CloseQuitTong", Kin.CloseQuitTong_GS1)

--关闭退出帮会的投票状态, bSuccess为  0为时间到失败;1表示时间到达成功退出帮会;2为族长取消;3为帮主家族不可退出
function Kin:CloseQuitTong_GS2(nKinId, nSuccess)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  local cMemberItor = cKin.GetMemberItor()
  local cCurMember = cMemberItor.GetCurMember()
  while cCurMember do
    cCurMember.SetQuitVoteState(0) -- 清空各个成员的投票状态
    cCurMember = cMemberItor.NextMember()
  end
  cKin.SetApplyQuitTime(0)
  return KKinGs.KinClientExcute(nKinId, { "Kin:CloseQuitTong_C2", nSuccess })
end

function Kin:LeaveTong_GS2(nTongId, nKinId, nMethod, nBuildFund, nTotalStock, tbResult, bSync)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  local pTong = KTong.GetTong(nTongId)
  if pTong then -- 帮会不存在的话应该是解散了~不用管
    pTong.SetBuildFund(nBuildFund)
    pTong.SetTotalStock(nTotalStock)
  end
  --	local nLastCamp = cKin.GetLastCamp()
  --	if nLastCamp ~= 0 and cKin.GetCamp() ~= nLastCamp then
  --		cKin.SetCamp(nLastCamp)
  --		KKinGs.UpdateKinMemberCamp(nKinId, nLastCamp)
  --	end
  --清空帮会相关数据
  cKin.SetBelongTong(0)
  cKin.SetTongFigure(0)
  cKin.SetTongVoteBallot(0)
  cKin.SetTongVoteJourNum(0)
  cKin.SetTongVoteState(0)
  if cKin.GetApplyQuitTime() ~= 0 then
    self:CloseQuitTong_GS2(nKinId, 1)
  end
  KKinGs.KinDetachTong(nKinId)
  --清空成员帮会相关数据
  local cMemberItor = cKin.GetMemberItor()
  local cMember = cMemberItor.GetCurMember()
  while cMember do
    cMember.SetTongFlag(0)
    cMember.SetEnvoyFigure(0)
    cMember.SetWageFigure(0)
    cMember.SetWageValue(0)
    local nMember = cMemberItor.GetCurMemberId()
    if tbResult[nMember] then
      cMember.SetPersonalStock(tbResult[nMember]) -- 同步成员数据
    else
      cMember.SetPersonalStock(0)
    end
    cMember = cMemberItor.NextMember()
  end
  if bSync == 1 then
    return KKinGs.KinClientExcute(nKinId, { "Kin:LeaveTong_C2", nMethod })
  end
  return 1
end

function Kin:SetSelfQuitVoteState(nVoteState)
  local nKinId, nMemberId = me.GetKinMember()
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  local cMember = cKin.GetMember(nMemberId)
  if not cMember then
    return 0
  end
  cMember.SetQuitVoteState(nVoteState)
  return GCExcute({ "Kin:SetSelfQuitVoteState_GC", nKinId, nMemberId, nVoteState })
end

function Kin:AddKinTotalRepute_GS2(nKinId, nMemberId, nPlayerId, nRepute, nDataVer)
  local pKin = KKin.GetKin(nKinId)
  if pKin then
    pKin.AddTotalRepute(nRepute)
    pKin.SetKinDataVer(nDataVer)
  end
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if pPlayer then
    pPlayer.Msg(string.format("你获得了%d点威望", nRepute))
  end
end

function Kin:AddHistory(bIsHistory, nType, ...)
  local nKinId, nMemberId = me.GetKinMember()
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  cKin.AddKinHistory(bIsHistory, nType, GetTime(), unpack(arg))
end

-- TODO:测试用临时指令，完整的历史功能后删除
function Kin:GetHistoryPage_GS1(nIsHistory, nPage)
  local nKinId, nMemberId = me.GetKinMember()
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  local tbHistory = cKin.GetKinHistory(nIsHistory, nPage)
  me.Msg("page" .. nPage)
  for i, tbRecord in pairs(tbHistory) do
    local szMsg = self:ParseHistory(tbRecord)
    me.Msg(szMsg)
  end
end

function Kin:AddGuYinBi_GS2(nKinId, nCurGuYinBi, nAddGuYinBi)
  local pKin = KKin.GetKin(nKinId)
  if not pKin then
    return 0
  end
  pKin.SetKinGuYinBi(nCurGuYinBi)
  return KKinGs.KinClientExcute(nKinId, { "Kin:AddGuYinBi_C2", nAddGuYinBi })
end

-- 检测、设置家族插旗时间和地点
function Kin:CheckBuildFlagOrderTime(nHour, nMin, nPlayerId, nKinId)
  if not nPlayerId then
    return 0
  end
  local cPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not cPlayer then
    return 0
  end
  local cSelfNpc = cPlayer.GetNpc()
  local nMapId, nMapX, nMapY = cSelfNpc.GetWorldPos()

  -- 判断时间是否正确
  local nTime = nHour * 60 + nMin
  local nBeginTime = 19 * 60 + 30 -- 允许使用的开始时间
  local nEndTime = 23 * 60 + 30 -- 允许使用的结束时间
  if nTime < nBeginTime or nTime > nEndTime then
    --返回界面并通知玩家设置不正确
    cPlayer.Msg("时间不正确")
    cPlayer.CallClientScript({ "UiManager:OpenWindow", "UI_KINBUILDFLAG" })
    return 0
  end

  -- 判断地点是否正确
  if GetMapType(nMapId) ~= "village" and GetMapType(nMapId) ~= "city" then
    cPlayer.Msg("家族令牌只能在城市或新手村使用！")
    cPlayer.CallClientScript({ "UiManager:OpenWindow", "UI_KINBUILDFLAG" })
    return 0
  end

  -- 扣除掉令牌
  local tbItem = cPlayer.FindItemInBags(18, 1, 47, 1, 0)
  if not tbItem[1] then
    return 0
  end

  cPlayer.DelItem(tbItem[1].pItem)

  return GCExcute({ "Kin:SaveBuildFlagSetting_GC", nPlayerId, nKinId, nTime, nMapId, nMapX, nMapY })
end
RegC2SFun("CheckBuildFlagOrderTime", Kin.CheckBuildFlagOrderTime)
-- 注册客户端到服务器的回调

-- 所有服务器保存插旗的时间，用于客户端显示
function Kin:SaveBuildFlagSetting_GS2(nPlayerId, nKinId, nTime, nMapId, nMapX, nMapY)
  local cKin = KKin.GetKin(nKinId)
  if cKin then
    -- 记录插旗时间
    cKin.SetKinBuildFlagOrderTime(nTime)
    cKin.SetKinBuildFlagMapId(nMapId)
    cKin.SetKinBuildFlagMapX(nMapX)
    cKin.SetKinBuildFlagMapY(nMapY)

    -- 插旗
    local nNowDay = tonumber(os.date("%m%d", GetTime()))
    local nPreDay = cKin.GetTogetherTime()
    local cPlayer = KPlayer.GetPlayerObjById(nPlayerId)
    if nNowDay ~= nPreDay then
      Kin:KinBuildFlag_GS2(nKinId)
      if cPlayer then
        cPlayer.Msg("已成功记录你设置的插旗时间和地点")
      end
    else
      if cPlayer then
        cPlayer.Msg("已成功记录你设置的插旗时间和地点, 你的家族今天已经插过旗子了，自动插旗活动将从明天开始为你进行")
      end
    end
  end
end

-- 有指定插旗的地图的服务器开始插旗，在所有服务器都公告一次
function Kin:KinBuildFlag_GS2(nKinId)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end

  KKin.Msg2Kin(nKinId, "家族插旗活动开始了，请各位家族成员迅速到场。")

  -- 记录今天已经插旗
  local nNowDay = tonumber(os.date("%m%d", GetTime()))
  cKin.SetTogetherTime(nNowDay)
  local nMapId = cKin.GetKinBuildFlagMapId()
  if not nMapId then
    return 0
  end

  if IsMapLoaded(nMapId) then
    local nMapX = cKin.GetKinBuildFlagMapX()
    local nMapY = cKin.GetKinBuildFlagMapY()
    local tbNpc = Npc:GetClass("jiazulingpainpc")
    tbNpc:StartToWork(nKinId, nMapId, nMapX, nMapY)
  end
end

-- 修改家族令牌的KinExpstate,使玩家能再领家族令牌
function Kin:ChangeKinExpState_GS2(nPlayerId, nKinId)
  local cKin = KKin.GetKin(nKinId)
  if cKin then
    local nNowDay = tonumber(os.date("%m%d", GetTime()))
    cKin.SetGainExpState(nNowDay)
    cKin.SetKinBuildFlagOrderTime(0)
  end
  local cPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if cPlayer then
    cPlayer.Msg("您的家族已经成功清除自动插旗记录。您可以再次设置自动插旗时间了。")
    local cLingPai = cPlayer.AddItemEx(Item.SCRIPTITEM, 1, 47, 1, { bTimeOut = 1 }) -- 获得家族令牌
    if cLingPai then
      cPlayer.SetItemTimeout(cLingPai, os.date("%Y/%m/%d/00/00/00", GetTime() + 3600 * 24)) -- 领取当天有效
      cLingPai.Sync()
    end
    cPlayer.Msg("获得家族令牌")
    Dbg:WriteLog("Kin", "PlayerID:" .. cPlayer.nId, "Account:" .. cPlayer.szAccount .. "Get a JiaZuLingPai")
  end
  return 1
end

-- 领取家族令牌
function Kin:GetKinLingPai_GS2(nKinId, nPlayerId)
  if not nKinId or not nPlayerId then
    return 0
  end

  local nTime = GetTime()
  local nNowDay = tonumber(os.date("%m%d", nTime))

  local cKin = KKin.GetKin(nKinId)
  cKin.SetGainExpState(nNowDay)

  local cPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not cPlayer then
    return 0
  end
  local cLingPai = cPlayer.AddItemEx(Item.SCRIPTITEM, 1, 47, 1, { bTimeOut = 1 }) -- 获得家族令牌
  if cLingPai then
    cPlayer.SetItemTimeout(cLingPai, os.date("%Y/%m/%d/00/00/00", GetTime() + 3600 * 24)) -- 领取当天有效
    cLingPai.Sync()
  end
  cPlayer.Msg("获得家族令牌")
  return 1
end

-- 帮会频道提示插旗
function Kin:NoticeKinBuildFlag_GS2(nKinId, nLeftTime)
  if not nKinId then
    return 0
  end
  KKin.Msg2Kin(nKinId, nLeftTime .. "分钟后家族插旗")
end

function Kin:SetRecuitmentAutoAgree_GS1(nAutoAgree)
  local nKinId, nMemberId = me.GetKinMember()
  local pKin = KKin.GetKin(nKinId)
  if not pKin then
    return 0
  end
  if Kin:CheckSelfRight(nKinId, nMemberId, 2) ~= 1 then
    return 0
  end
  return GCExcute({ "Kin:SetRecuitmentAutoAgree_GC", nKinId, nMemberId, nAutoAgree })
end
RegC2SFun("SetRecuitmentAutoAgree", Kin.SetRecuitmentAutoAgree_GS1)

function Kin:SetRecuitmentAutoAgree_GS2(nKinId, nAutoAgree)
  local pKin = KKin.GetKin(nKinId)
  if pKin and nAutoAgree then
    pKin.SetRecruitmentAutoAgree(nAutoAgree)
    local nPublish = pKin.GetRecruitmentPublish()
    local nLevel = pKin.GetRecruitmentLevel()
    local nHonor = pKin.GetRecruitmentHonour()
    return KKinGs.KinClientExcute(nKinId, { "Kin:ProcessRecruitmentPublish", nPublish, nLevel, nHonor, nAutoAgree })
  end
end

-- 发布\取消招募
function Kin:RecruitmentPublish_GS1(nPublish, nLevel, nHonour, nAutoAgree)
  local nKinId, nMemberId = me.GetKinMember()
  local pKin = KKin.GetKin(nKinId)
  if not pKin then
    me.Msg("你没有家族，不能进行招募。")
    return 0
  end
  if Kin:CheckSelfRight(nKinId, nMemberId, 2) ~= 1 then
    me.Msg("你没有权限发布/停止招募，要族长或者副族长才能发布/停止招募。")
    return 0
  end
  if nPublish == 1 and nLevel > Kin.KIN_RECRUITMENT_MAX_LEVEL then
    me.Msg("招募的等级超过范围")
    return 0
  end
  if nPublish == 1 and nLevel < Kin.KIN_RECRUITMENT_MIN_LEVEL then
    me.Msg("招募的等级最低要求必需在" .. Kin.KIN_RECRUITMENT_MIN_LEVEL .. "级，小于最低等级则默认为最低等级")
    nLevel = 10
  end
  local nMemberLimit, nRetireLimit = self:GetKinMemberLimit(nKinId)
  local nRegular, nSigned, nRetire = pKin.GetMemberCount()
  local nMemberCount = nRegular + nSigned

  if (nRegular + nSigned + nRetire) >= (nMemberLimit + nRetireLimit) then
    me.Msg("你的家族已经满员，不能再招募人员了。")
    return 0
  end
  if nMemberCount >= nMemberLimit then
    me.Msg("你的家族已经满员，不能再招募人员了。")
    return 0
  end

  return GCExcute({ "Kin:RecruitmentPublish_GC", nKinId, nMemberId, nPublish, nLevel, nHonour, nAutoAgree })
end
RegC2SFun("RecruitmentPublish", Kin.RecruitmentPublish_GS1)

function Kin:RecruitmentPublish_GS2(nKinId, nPublish, nLevel, nHonour, nAutoAgree)
  local pKin = KKin.GetKin(nKinId)
  if pKin and nPublish then
    pKin.SetRecruitmentPublish(nPublish)
    if nPublish == 1 then
      if nLevel then
        pKin.SetRecruitmentLevel(nLevel)
      end
      if nHonour then
        pKin.SetRecruitmentHonour(nHonour)
      end
      if nAutoAgree then
        pKin.SetRecruitmentAutoAgree(nAutoAgree)
      end
      KKin.Msg2Kin(nKinId, "你的家族招募开始了！")
    else
      KKin.Msg2Kin(nKinId, "你的家族结束了招募！")
    end
    return KKinGs.KinClientExcute(nKinId, { "Kin:ProcessRecruitmentPublish", nPublish, nLevel, nHonour, nAutoAgree })
  end
end

-- 同意招募
function Kin:RecruitmentAgree_GS1(szName)
  local nSelfKinId, nSelfMemberId = me.GetKinMember()
  local pSelfKin = KKin.GetKin(nSelfKinId)
  if not pSelfKin then
    me.Msg("你没有家族，不能进行招募。")
    return 0
  end

  if Kin:CheckSelfRight(nSelfKinId, nSelfMemberId, 2) ~= 1 then
    me.Msg("你没有权限招募人员，要族长或者副族长才能进行招募。")
    return 0
  end
  local nMemberLimit, nRetireLimit = self:GetKinMemberLimit(nSelfKinId)
  local nRegular, nSigned, nRetire = pSelfKin.GetMemberCount()
  local nMemberCount = nRegular + nSigned
  if (nRegular + nSigned + nRetire) >= (nMemberLimit + nRetireLimit) then
    me.Msg("你的家族已经满员，不能再招募人员了。")
    return 0
  end
  if nMemberCount >= nMemberLimit then
    me.Msg("你的家族已经满员，不能再招募人员了。")
    return 0
  end
  local nPlayerId = KGCPlayer.GetPlayerIdByName(szName)
  if not nPlayerId or nPlayerId <= 0 then
    me.Msg("你招募的人员不存在。")
    return 0
  end
  local nKinId = KGCPlayer.GetKinId(nPlayerId)
  local pKin = KKin.GetKin(nKinId)
  if pKin then
    me.Msg("该玩家已经加入了其他家族了。")
    return 0
  end
  if GetTime() - KGCPlayer.OptGetTask(nPlayerId, KGCPlayer.TSK_LEAVE_KIN_TIME) < 1800 then
    me.Msg("对方离开家族未满30分钟！")
    return 0
  end

  return GCExcute({ "Kin:RecruitmentAgree_GC", nSelfKinId, nSelfMemberId, szName, nKinId })
end
RegC2SFun("RecruitmentAgree", Kin.RecruitmentAgree_GS1)

function Kin:RecruitmentAgree_GS2(nKinId, nSelfMemberId, szName, nPlayerId)
  local pKin = KKin.GetKin(nKinId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if pKin and pPlayer then
    StatLog:WriteStatLog("stat_info", "join_kin", "join_in", nPlayerId, pKin.GetName())
  end
  self:MemberAdd_GS1(nKinId, nSelfMemberId, nPlayerId, 0)
  KKin.DelKinInductee(nKinId, szName)
  --	return KKinGs.KinClientExcute(nKinId, {"Kin:ProcessRecruitment"});
end

-- 拒绝招募
function Kin:RecruitmentReject_GS1(szName)
  local nKinId, nMemberId = me.GetKinMember()
  local pKin = KKin.GetKin(nKinId)
  if not pKin then
    me.Msg("你没有家族，不能进行招募")
    return 0
  end
  if Kin:CheckSelfRight(nKinId, nMemberId, 2) ~= 1 then
    me.Msg("你没有权限拒绝申请人，要族长或者副族长才能拒绝申请人")
    return 0
  end

  return GCExcute({ "Kin:RecruitmentReject_GC", szName, nKinId, nMemberId })
end
RegC2SFun("RecruitmentReject", Kin.RecruitmentReject_GS1)

function Kin:RecruitmentReject_GS2(szName, nKinId, nMemberId)
  local pKin = KKin.GetKin(nKinId)
  if pKin then
    KKin.DelKinInductee(nKinId, szName)
    local pMember = pKin.GetMember(nMemberId)
    if pMember then
      local pPlayer = KPlayer.GetPlayerObjById(pMember.GetPlayerId())
      if pPlayer then
        pPlayer.Msg("拒绝了" .. szName .. "的申请")
      end

      local nTagetPlayerId = KGCPlayer.GetPlayerIdByName(szName)
      local pTagetPlayer = KPlayer.GetPlayerObjById(nTagetPlayerId)
      if pTagetPlayer then
        pTagetPlayer.Msg(pKin.GetName() .. "拒绝了你的加入家族的申请")
      end
    end
  end
  --	return KKinGs.KinClientExcute(nKinId, {"Kin:ProcessRecruitment"});
end

-- 加入招募
function Kin:JoinRecruitment_GS1(nKinId)
  local nSelfKinId, nSelfMemberId = me.GetKinMember()
  local pSelfKin = KKin.GetKin(nSelfKinId)
  if pSelfKin then
    me.Msg("你已经有家族了，如果你想加入其他家族必须先退出现在的家族。")
    return 0
  end
  local pKin = KKin.GetKin(nKinId)
  if not pKin then
    me.Msg("该家族不存在了。")
    return 0
  end
  if pKin.GetRecruitmentPublish() == 0 then
    me.Msg("对不起，该家族已经结束了招募，请重新申请。")
    return 0
  end
  local pKin = KKin.GetKin(nKinId)
  if KKin.GetInducteeCount(nKinId) >= self.INDUCTEE_LIMITED then
    me.Msg("该家族的招募榜已满员。")
    return 0
  end
  if KKin.GetKinInducteeJoinTime(nKinId, me.szName) then
    me.Msg("你已经在该家族的招募里了。")
    return 0
  end

  local nNeedLevel = pKin.GetRecruitmentLevel()
  local nNeedHonour = pKin.GetRecruitmentHonour()

  if me.nFaction <= 0 then
    me.Msg("你还没有加入门派，无法进入家族。")
    return 0
  end

  if me.nLevel < nNeedLevel then
    me.Msg("你还没到达该家族的招募等级要求。")
    return 0
  end

  local nHonour = PlayerHonor:GetHonorLevel(me, PlayerHonor.HONOR_CLASS_MONEY)
  if nHonour < nNeedHonour then
    me.Msg("你还没到达该家族的招募荣誉等级要求。")
    return 0
  end

  if GetTime() - KGCPlayer.OptGetTask(me.nId, KGCPlayer.TSK_LEAVE_KIN_TIME) < 1800 then
    me.Msg("你离开家族未满30分钟！")
    return 0
  end

  if pKin.GetRecruitmentAutoAgree() == 1 then
    StatLog:WriteStatLog("stat_info", "join_kin", "join_ask", me.nId, pKin.GetName())
    StatLog:WriteStatLog("stat_info", "join_kin", "join_in", me.nId, pKin.GetName())
    return Kin:MemberAdd_GS1(nKinId, pKin.GetCaptain(), me.nId, 0)
  end

  local nJoinTimes = me.GetTask(self.KIN_RECRUITMENT_TASK_GROUP_ID, self.TSK_JOIN_RECRUITMENT_TIMES)
  local nJoinTime = me.GetTask(self.KIN_RECRUITMENT_TASK_GROUP_ID, self.TSK_JOIN_RECRUITMENT_DAY)
  local nJoinDay = tonumber(os.date("%Y%m%d", nJoinTime))
  local nNowTime = GetTime()
  local nNowDay = tonumber(os.date("%Y%m%d", nNowTime))
  if nJoinTimes >= self.KIN_JOIN_RECRUITMENT_MAXTIMES and nJoinDay == nNowDay then
    me.Msg("一天只有10次加入家族的招募榜的机会。")
    return 0
  elseif nJoinDay ~= nNowDay then
    nJoinTimes = 0
  end
  me.Msg("你第" .. (nJoinTimes + 1) .. "次加入了家族招募榜，一天只有10次加入家族的招募榜的机会。")
  me.SetTask(self.KIN_RECRUITMENT_TASK_GROUP_ID, self.TSK_JOIN_RECRUITMENT_TIMES, nJoinTimes + 1)
  me.SetTask(self.KIN_RECRUITMENT_TASK_GROUP_ID, self.TSK_JOIN_RECRUITMENT_DAY, nNowTime)

  if KKin.GetInducteeCount(nKinId) >= self.INDUCTEE_LIMITED - 1 then
    KKin.Msg2Kin(nKinId, "你的家族招募榜已满员。")
  end
  return GCExcute({ "Kin:JoinRecruitment_GC", nKinId, me.nId })
end
RegC2SFun("JoinRecruitment", Kin.JoinRecruitment_GS1)

function Kin:JoinRecruitment_GS2(nKinId, nPlayerId, nTime, szName)
  local pKin = KKin.GetKin(nKinId)
  if pKin then
    KKin.AddKinInductee(nKinId, nTime, szName)
    local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
    if pPlayer then
      pPlayer.Msg("你加入了" .. pKin.GetName() .. "家族的招募榜了。")
      StatLog:WriteStatLog("stat_info", "join_kin", "join_ask", nPlayerId, pKin.GetName())
    end
    -- add 管理者提示
    local szMsg = string.format("<color=yellow>%s<color>申请加入家族，请查看招募列表！", szName)
    local nCaptainId = Kin:GetPlayerIdByMemberId(nKinId, pKin.GetCaptain())
    local pCaptain = KPlayer.GetPlayerObjById(nCaptainId)
    if pCaptain then
      Dialog:SendBlackBoardMsg(pCaptain, szMsg)
    end
    local nAssistantId = Kin:GetPlayerIdByMemberId(nKinId, pKin.GetAssistant())
    local pAssistant = KPlayer.GetPlayerObjById(nAssistantId)
    if pAssistant then
      Dialog:SendBlackBoardMsg(pAssistant, szMsg)
    end
  end
end

-- 清理已经有家族的应召者
function Kin:KinRecruitmenClean_GS1(nKinId)
  return GCExcute({ "Kin:KinInducteeClean_GC", nKinId })
end
RegC2SFun("KinRecruitmenClean", Kin.KinRecruitmenClean_GS1)

function Kin:KinRecruitmenClean_GS2(nKinId, tbDelKinInducteeList)
  --	print("KinRecruitmenClean_GS2")
  --	Lib:ShowTB(tbDelKinInducteeList)
  for i, szName in ipairs(tbDelKinInducteeList) do
    KKin.DelKinInductee(nKinId, szName)
  end
  --	return KKinGs.KinClientExcute(nKinId, {"Kin:ProcessRecruitment"});
end

-- 申请招募信息：招募状态、要求等级和荣誉
function Kin:ApplyRecruitmentPublishInfo()
  local nKinId, nMemberId = me.GetKinMember()
  local pKin = KKin.GetKin(nKinId)
  if not pKin then
    return 0
  end
  local nPublish = pKin.GetRecruitmentPublish()
  local nNeedLevel = pKin.GetRecruitmentLevel()
  local nNeedHonour = pKin.GetRecruitmentHonour()
  local nAutoAgree = pKin.GetRecruitmentAutoAgree()
  return KKinGs.KinClientExcute(nKinId, { "Kin:ProcessRecruitmentPublish", nPublish, nNeedLevel, nNeedHonour, nAutoAgree })
end
RegC2SFun("ApplyRecruitmentPublishInfo", Kin.ApplyRecruitmentPublishInfo)

-- 每周清理家族招募榜
function Kin:CleanKinRecruitmenPublish_GS2(nKinId)
  local pCurKin = KKin.GetKin(nKinId)
  if not pCurKin then
    return
  end
  pCurKin.SetRecruitmentPublish(0)
  KKin.Msg2Kin(nKinId, "您的家族招募到达了发布期限(七天以后)，家族招募结束了，请重新发布招募。")
end

-- 家族已完成成就的修复
function Kin:RepairAchievement()
  local nKinId, nMemberId = me.GetKinMember()
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  local cMember = cKin.GetMember(nMemberId)
  if not cMember then
    return 0
  end

  Achievement:FinishAchievement(me, 26) -- 修复已有成就，加入家族
  if self.FIGURE_CAPTAIN == cMember.GetFigure() then
    Achievement:FinishAchievement(me, 33) -- 修复已有成就，才成为族长
  end
end

--家族资金转存帮会
function Kin:StorageFundToTong_GS1(nMoney)
  if EventManager.IVER_bOpenkinMoney ~= 1 then
    Dialog:SendBlackBoardMsg(me, "该功能暂未开放！")
    return
  end
  if not nMoney or 0 == Lib:IsInteger(nMoney) or nMoney <= 0 or nMoney > self.MAX_KIN_FUND then
    return 0
  end
  local nKinId, nMemberId = me.GetKinMember()
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    Dialog:SendInfoBoardMsg(me, "你没有家族，不能转存家族资金到帮会！")
    me.Msg("你没有家族，不能转存家族资金到帮会！")
    return 0
  end
  local cTong = KTong.GetTong(me.dwTongId)
  if not cTong then
    Dialog:SendInfoBoardMsg(me, "你没有帮会，不能转存家族资金到帮会！")
    me.Msg("你没有帮会，不能转存家族资金到帮会！")
    return 0
  end
  if me.IsAccountLock() ~= 0 then
    Dialog:Say("你的账号处于锁定状态，无法进行该操作！")
    Account:OpenLockWindow(me)
    return 0
  end
  if Kin:CheckSelfRight(nKinId, nMemberId, 1) ~= 1 then
    Dialog:SendInfoBoardMsg(me, "只有族长才能转存家族资金到帮会！")
    me.Msg("只有族长才能转存家族资金到帮会！")
    return 0
  end
  if me.IsInPrison() == 1 then
    me.Msg("您在坐牢期间不能转存家族资金到帮会！")
    return 0
  end
  local tbSalaryData = self:GetExclusiveEvent(nKinId, self.KIN_EVENT_SALARY)
  if tbSalaryData.nApplyEvent and tbSalaryData.nApplyEvent == 1 then
    Dialog:SendInfoBoardMsg(me, "已经有发放出勤奖励的申请！")
    me.Msg("已经有发放出勤奖励的申请！请先处理后再转存帮会！")
    return 0
  end
  local tbData = self:GetExclusiveEvent(nKinId, self.KIN_EVENT_TAKE_FUND)
  if tbData.nApplyEvent and tbData.nApplyEvent == 1 then
    Dialog:SendInfoBoardMsg(me, "已经有取出家族资金的申请！")
    me.Msg("已经有取出家族资金的申请！请先处理申请后再转存帮会！")
    return 0
  end
  if tbData.nLastStorageTime and GetTime() - tbData.nLastStorageTime < self.STORAGE_FUND_TIME then
    Dialog:SendInfoBoardMsg(me, "两次转存帮会时间间隔需要一分钟！")
    me.Msg("两次转存帮会时间间隔需要一分钟！")
    return 0
  end
  local nKinFund = cKin.GetMoneyFund()
  local nTongFund = cTong.GetMoneyFund()
  if nMoney > nKinFund then
    Dialog:SendInfoBoardMsg(me, "没有足够的家族资金让你转存帮会！")
    me.Msg("没有足够的家族资金让你转存帮会！")
    return 0
  end
  if nMoney + nTongFund > Tong.MAX_TONG_FUND then
    Dialog:SendInfoBoardMsg(me, "您转存帮会的金额将会使帮会资金超过存款上限！")
    me.Msg("您转存帮会的金额将会使帮会资金超过存款上限，无法存入！")
    return 0
  end
  return GCExcute({ "Kin:StorageFundToTong_GC", me.nId, nKinId, nMemberId, me.dwTongId, nMoney })
end
RegC2SFun("StorageFundToTong", Kin.StorageFundToTong_GS1)

function Kin:StorageFundToTong_GS2(nPlayerId, nKinId, nTongId, nKinDataVer, nTongDataVer, nKinFund, nTongFund, nMoney)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  cKin.SetKinDataVer(nKinDataVer)
  cKin.SetMoneyFund(nKinFund)
  local cTong = KTong.GetTong(nTongId)
  if not cTong then
    return 0
  end
  cTong.SetTongDataVer(nTongDataVer)
  cTong.SetMoneyFund(nTongFund)
  local szPlayerName = KGCPlayer.GetPlayerName(nPlayerId)
  local szKinName = cKin.GetName()
  local szTongName = cTong.GetName()
  if nMoney >= self.STORAGE_FUND_TO_TONG then
    cTong.AddAffairGetFundFromKin(szKinName, tostring(nMoney))
    cKin.AddAffairStorageFundToTong(szPlayerName, szTongName, tostring(nMoney))
  end
  local tbData = self:GetExclusiveEvent(nKinId, self.KIN_EVENT_TAKE_FUND)
  tbData.nLastStorageTime = GetTime()
  KKinGs.KinClientExcute(nKinId, { "Kin:StorageFundToTong_C2", szPlayerName, szTongName, nMoney })
  KTongGs.TongClientExcute(nTongId, { "Tong:GetFundFromKin_C2", szKinName, nMoney })
  local cPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not cPlayer then
    return 0
  end
  cPlayer.Msg("成功转存帮会" .. nMoney .. "两家族资金！")
  cPlayer.CallClientScript({ "Ui:ServerCall", "UI_KIN", "RefreshFund_C2", nKinFund })
end

function Kin:AddFund_GS1(nMoney)
  if EventManager.IVER_bOpenkinMoney ~= 1 then
    Dialog:SendBlackBoardMsg(me, "该功能暂未开放！")
    return
  end
  if not nMoney or 0 == Lib:IsInteger(nMoney) or nMoney <= 0 or nMoney > 2000000000 then
    return 0
  end
  local nKinId, nMemberId = me.GetKinMember()
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    me.Msg("你没有家族，不能存家族资金")
    return 0
  end
  if me.IsAccountLock() ~= 0 then
    Dialog:Say("你的账号处于锁定状态，无法进行该操作！")
    Account:OpenLockWindow(me)
    return 0
  end
  if me.IsInPrison() == 1 then
    me.Msg("您在坐牢期间不能存入家族资金！")
    return 0
  end

  local nCurMoney = me.nCashMoney
  if nMoney > nCurMoney then
    Dialog:SendInfoBoardMsg(me, "你的身上没有足够的银两！")
    me.Msg("你的身上没有足够的银两！")
    return 0
  end
  local nKinMoney = cKin.GetMoneyFund()
  if nMoney + nKinMoney > self.MAX_KIN_FUND then
    Dialog:SendInfoBoardMsg(me, "您存入的金额将会使家族资金超过存款上限！")
    me.Msg("您存入的金额将会使家族资金超过存款上限，无法存入！")
    return 0
  end
  local nRet = me.CostMoney(nMoney, Player.emKPAY_KIN_FUND)
  if nRet ~= 1 then
    me.Msg("存入资金失败！")
    return 0
  end
  return GCExcute({ "Kin:AddFund_GC", nKinId, me.nId, nMoney })
end
RegC2SFun("AddFund", Kin.AddFund_GS1)

--系统存钱，有可能会失败
function Kin:AddFundGM_GS(nKinId, nMoney)
  GCExcute({ "Kin:AddFund_GC", nKinId, -1, nMoney })
end

function Kin:AddFund_GS2(nKinId, nDataVer, nPlayerId, nKinFund, nMoney)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  cKin.SetMoneyFund(nKinFund)
  cKin.SetKinDataVer(nDataVer)
  local szPlayerName = "系统奖励"
  if nPlayerId > 0 then
    szPlayerName = KGCPlayer.GetPlayerName(nPlayerId)
  end
  if nMoney >= self.TAKE_FUND_APPLY then
    cKin.AddAffairSaveFund(szPlayerName, tostring(nMoney))
  end
  KKinGs.KinClientExcute(nKinId, { "Kin:AddFund_C2", szPlayerName, nMoney })
  if nPlayerId <= 0 then
    return
  end
  local cPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not cPlayer then
    return
  end
  cPlayer.Msg("成功存入" .. nMoney .. "两家族资金！")
  cPlayer.CallClientScript({ "Ui:ServerCall", "UI_KIN", "RefreshFund_C2", nKinFund })
end

function Kin:ApplyTakeFund_GS1(nMoney)
  if EventManager.IVER_bOpenkinMoney ~= 1 then
    Dialog:SendBlackBoardMsg(me, "该功能暂未开放！")
    return
  end
  if not nMoney or 0 == Lib:IsInteger(nMoney) or nMoney <= 0 or nMoney > 2000000000 then
    return 0
  end
  local nKinId, nMemberId = me.GetKinMember()
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    Dialog:SendInfoBoardMsg(me, "你没有家族，不能取家族资金！")
    me.Msg("你没有家族，不能取家族资金")
    return 0
  end
  if me.IsAccountLock() ~= 0 then
    Dialog:Say("你的账号处于锁定状态，无法进行该操作！")
    Account:OpenLockWindow(me)
    return
  end
  if me.IsInPrison() == 1 then
    me.Msg("您在坐牢期间不能取帮会资金。")
    return 0
  end
  local tbSalaryData = self:GetExclusiveEvent(nKinId, self.KIN_EVENT_SALARY)
  if tbSalaryData.nApplyEvent and tbSalaryData.nApplyEvent == 1 then
    Dialog:SendInfoBoardMsg(me, "已经有发放出勤奖励的申请！不能再申请！")
    me.Msg("已经有发放出勤奖励的申请！不能再申请！")
    return 0
  end
  local tbData = self:GetExclusiveEvent(nKinId, self.KIN_EVENT_TAKE_FUND)
  if tbData.nApplyEvent and tbData.nApplyEvent == 1 then
    Dialog:SendInfoBoardMsg(me, "已经有取出家族资金的申请！不能再申请！")
    me.Msg("已经有取出家族资金的申请！不能再申请！")
    return 0
  end

  if tbData.nLastTime and GetTime() - tbData.nLastTime < self.TAKE_FUND_TIME then
    Dialog:SendInfoBoardMsg(me, "两次取家族资金需要间隔5分钟！")
    me.Msg("两次取家族资金需要间隔5分钟")
    return 0
  end
  local nCurFund = cKin.GetMoneyFund()
  if nMoney > nCurFund then
    Dialog:SendInfoBoardMsg(me, "家族没有足够的资金供你取出！")
    me.Msg("家族没有足够的资金供你取出！")
    return 0
  end
  if me.GetMaxCarryMoney() < me.nCashMoney + nMoney then
    Dialog:SendInfoBoardMsg(me, "你取出的资金额度将会使银两携带量超出上限！")
    me.Msg("你取出的资金额度将会使银两携带量超出上限！")
    return 0
  end
  return GCExcute({ "Kin:ApplyTakeFund_GC", nKinId, nMemberId, me.nId, nMoney })
end
RegC2SFun("TakeFund", Kin.ApplyTakeFund_GS1)

function Kin:ApplyTakeFund_GS2(nType, nKinId, nMemberId, nPlayerId, nMoney)
  local tbData = self:GetExclusiveEvent(nKinId, self.KIN_EVENT_TAKE_FUND)
  tbData.nApplyEvent = 1
  if not tbData.tbApplyRecord then
    tbData.tbApplyRecord = {}
  end
  tbData.tbApplyRecord.nMemberId = nMemberId
  tbData.tbApplyRecord.nAmount = nMoney
  tbData.tbAccept = {}
  if nType == 1 then
    tbData.tbApplyRecord.nPow = self.FIGURE_REGULAR
    tbData.nAgreeCount = 2
  else
    tbData.tbApplyRecord.nPow = self.FIGURE_CAPTAIN
    tbData.nAgreeCount = 1
  end
  tbData.tbApplyRecord.nTimerId = Timer:Register(self.TAKE_FUND_APPLY_LAST, self.CancelExclusiveEvent_GS, self, nKinId, self.KIN_EVENT_TAKE_FUND, nPlayerId)
  local szPlayerName = KGCPlayer.GetPlayerName(nPlayerId)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  local cApplyPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if cApplyPlayer then
    cApplyPlayer.CallClientScript({ "Kin:NotifApplyTakeFundPlayer_C2", nMoney, nType })
  end
  KKinGs.KinClientExcute(nKinId, { "Kin:SendTakeFundApply_C2", szPlayerName, nMoney, nType })
  if nType == 1 then
    return KKinGs.KinClientExcute(nKinId, { "Kin:GetTakeFundApply_C2", self.KIN_EVENT_TAKE_FUND, nMemberId, szPlayerName, nMoney })
  else
    -- 寻找族长通知有申请
    local nCaptainId = cKin.GetCaptain()
    local cCatainIdMember = cKin.GetMember(nCaptainId)
    if not cCatainIdMember then
      return 0
    end
    local nId = cCatainIdMember.GetPlayerId()
    local pPlayer = KPlayer.GetPlayerObjById(nId)
    if not pPlayer then
      return 0
    end
    pPlayer.CallClientScript({ "Kin:GetTakeFundApply_C2", self.KIN_EVENT_TAKE_FUND, nMemberId, szPlayerName, nMoney })
  end
end

function Kin:AcceptExclusiveEvent_GS1(nKey, nAccept, nAppleyMemberId)
  if EventManager.IVER_bOpenkinMoney ~= 1 then
    Dialog:SendBlackBoardMsg(me, "该功能暂未开放！")
    return
  end
  if me.IsAccountLock() ~= 0 then
    Dialog:SendBlackBoardMsg(me, "你的账号处于锁定状态，无法进行该操作！")
    return
  end
  if not nKey or Lib:IsInteger(nKey) == 0 or not nAccept or Lib:IsInteger(nAccept) == 0 or not nAppleyMemberId or Lib:IsInteger(nAppleyMemberId) == 0 then
    return 0
  end
  local nKinId, nMemberId = me.GetKinMember()
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  local tbData = self:GetExclusiveEvent(nKinId, nKey)
  if not tbData.nApplyEvent or tbData.nApplyEvent == 0 then
    me.Msg("该申请已结束！")
    return 0
  end
  if tbData.tbApplyRecord.nMemberId ~= nAppleyMemberId then
    me.Msg("该申请不存在！")
    return 0
  end
  local cMember = cKin.GetMember(nAppleyMemberId)
  if not cMember then
    me.Msg("该成员已经不是家族成员！")
    return 0
  end
  if nKey == self.KIN_EVENT_TAKE_REPOSITORY then -- 家族仓库的权限判断
    if KinRepository:CheckRepAuthority(nKinId, nMemberId, tbData.tbApplyRecord.nPow) ~= 1 then
      me.Msg("对不起，您没有权限响应这个申请！")
      return 0
    end
  else
    if Kin:CheckSelfRight(nKinId, nMemberId, tbData.tbApplyRecord.nPow) ~= 1 then
      me.Msg("对不起，您没有权限响应这个申请！")
      return 0
    end
  end
  if tbData.tbApplyRecord.nMemberId == nMemberId then --表决人是发起人不需要表决
    me.Msg("申请人表决无效！")
    return 0
  end
  if not tbData.tbAccept then
    tbData.tbAccept = {} -- 已表态的成员记录
  end
  if tbData.tbAccept[nMemberId] then
    me.Msg("你已经表过态了！")
    return 0
  end
  GCExcute({ "Kin:AcceptExclusiveEvent_GC", nKey, me.nId, nKinId, nMemberId, nAccept, nAppleyMemberId })
end
RegC2SFun("AcceptExclusiveEvent", Kin.AcceptExclusiveEvent_GS1)

function Kin:AcceptExclusiveEvent_GS2(nKey, nPlayerId, nKinId, nMemberId, nAccept)
  local tbData = self:GetExclusiveEvent(nKinId, nKey)
  if not tbData.tbAccept then
    tbData.tbAccept = {}
  end
  tbData.tbAccept[nMemberId] = nAccept
  local szPlayerName = KGCPlayer.GetPlayerName(nPlayerId)
  KKinGs.KinClientExcute(nKinId, { "Kin:AcceptExclusiveEvent_C2", szPlayerName, nKey, nAccept })
  if not tbData.tbApplyRecord then
    return 0
  end
  local nApplyMemberId = tbData.tbApplyRecord.nMemberId
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  local cMember = cKin.GetMember(nApplyMemberId)
  if not cMember then
    return 0
  end
  local nApplyPlayerId = cMember.GetPlayerId()
  local cApplyPlayer = KPlayer.GetPlayerObjById(nApplyPlayerId)
  if cApplyPlayer then
    cApplyPlayer.CallClientScript({ "Kin:AcceptExclusiveEventNotify_C2", szPlayerName, nKey, nAccept })
  end
end

function Kin:CanCelMemberTakeFund_GS2(nKinId, nPlayerId)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  local tbData = self:GetExclusiveEvent(nKinId, self.KIN_EVENT_TAKE_FUND)
  tbData.nLastTime = GetTime()
  if tbData.nApplyEvent and tbData.nApplyEvent == 1 then
    if tbData.tbApplyRecord and tbData.tbApplyRecord.nTimerId then
      Timer:Close(tbData.tbApplyRecord.nTimerId)
    end
    self:DelExclusiveEvent(nKinId, self.KIN_EVENT_TAKE_FUND)
  end
end

--找到玩家，然后向gc取钱
function Kin:FindPlayerAddMoney_GS(nKinId, nMoney, nPlayerId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return 0
  end
  if pPlayer.GetMaxCarryMoney() < pPlayer.nCashMoney + nMoney then
    pPlayer.Msg("你携带的银两将会超出携带上限！取出资金失败！")
    return 0
  end
  -- 玩家准备跨服或下线，当不在线处理
  if pPlayer.nIsExchangingOrLogout == 1 then
    return 0
  end
  local nRet = GCExcute({ "Kin:TakeFund_GC", nKinId, nMoney, nPlayerId })
  if nRet == 1 then
    -- 申请获取资金时，锁定状态
    pPlayer.AddWaitGetItemNum(1)
  end
end

function Kin:TakeFund_GS2(nKinId, nPlayerId, nDataVer, nMoney, nCurFund)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  cKin.SetMoneyFund(nCurFund)
  cKin.SetKinDataVer(nDataVer)
  local szPlayerName = KGCPlayer.GetPlayerName(nPlayerId)
  if nMoney >= self.TAKE_FUND_APPLY then
    cKin.AddAffairTakeFund(szPlayerName, tostring(nMoney))
  end
  local tbData = self:GetExclusiveEvent(nKinId, self.KIN_EVENT_TAKE_FUND)
  tbData.nLastTime = GetTime()
  if tbData.nApplyEvent and tbData.nApplyEvent == 1 then
    if tbData.tbApplyRecord and tbData.tbApplyRecord.nTimerId then
      Timer:Close(tbData.tbApplyRecord.nTimerId)
    end
    self:DelExclusiveEvent(nKinId, self.KIN_EVENT_TAKE_FUND)
  end
  KKinGs.KinClientExcute(nKinId, { "Kin:TakeFund_C2", szPlayerName, nMoney })
  local cPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not cPlayer then
    return 0
  end
  local nTrueMoney = TradeTax:TradeMoney(cPlayer, nMoney)
  cPlayer.Earn(nTrueMoney, Player.emKEARN_KIN_FUND)
  -- 还原锁定状态
  cPlayer.AddWaitGetItemNum(-1)
  Dbg:WriteLog("Kin:TakeFund_GS2", cKin.GetName(), nCurFund, cPlayer.szName, cPlayer.szAccount, nMoney)
  cPlayer.PlayerLog(Log.emKPLAYERLOG_TYPE_KINPAYOFF, string.format("玩家：%s, 帐号:%s, 从家族：%s 领取了%d的资金,家族还有%d的资金", cPlayer.szName, cPlayer.szAccount, cKin.GetName(), nMoney, nCurFund))
  local cPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  cPlayer.Msg("成功取出" .. nMoney .. "两家族资金！")
  cPlayer.CallClientScript({ "Ui:ServerCall", "UI_KIN", "RefreshFund_C2", nCurFund })
end

-- 超时删除申请资金事件
function Kin:CancelExclusiveEvent_GS(nKinId, nEventId, nPlayerId)
  self:DelExclusiveEvent(nKinId, nEventId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return 0
  end
  pPlayer.CallClientScript({ "Kin:ApplyFailed_C2", nEventId })
  return 0
end

function Kin:SaveSalaryCount_GS1(tbMember)
  if EventManager.IVER_bOpenkinMoney ~= 1 then
    Dialog:SendBlackBoardMsg(me, "该功能暂未开放！")
    return
  end
  if not tbMember or type(tbMember) ~= "table" then
    return 0
  end
  local nKinId, nMemberId = me.GetKinMember()
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    Dialog:SendInfoBoardMsg(me, "你没有家族，不能修改家族出勤统计！")
    me.Msg("你没有家族，不能修改家族出勤统计！")
    return 0
  end
  if me.IsAccountLock() ~= 0 then
    Dialog:Say("你的账号处于锁定状态，无法进行该操作！")
    Account:OpenLockWindow(me)
    return
  end
  if Kin:CheckSelfRight(nKinId, nMemberId, 2) ~= 1 then
    Dialog:SendInfoBoardMsg(me, "只有族长和副族长才能修改家族出勤统计！")
    me.Msg("只有族长和副族长才能修改家族出勤统计！")
    return 0
  end
  if self:CheckMemberSalary(nKinId, tbMember) ~= 1 then
    Dialog:SendInfoBoardMsg(me, "保存失败！请刷新数据后重新修改再保存！")
    me.Msg("保存失败！请刷新数据后重新修改再保存！")
    return 0
  end
  local tbSalaryData = self:GetExclusiveEvent(nKinId, self.KIN_EVENT_SALARY)
  if tbSalaryData.nApplyEvent and tbSalaryData.nApplyEvent == 1 then
    Dialog:SendInfoBoardMsg(me, "有发放出勤奖励的申请！暂不能修改数据！")
    me.Msg("有发放出勤奖励的申请！暂不能修改出勤数据！")
    return 0
  end
  local tbKinData = self:GetKinData(nKinId)
  if not tbKinData.nLastSaveSalaryTime then
    tbKinData.nLastSaveSalaryTime = 0
  end
  if GetTime() - tbKinData.nLastSaveSalaryTime < 1 then --防止客户端频繁保存以及连按两下保存所引发的错误
    Dialog:SendInfoBoardMsg(me, "你保存的太频繁了，请稍后再试！")
    me.Msg("你保存的太频繁了，请稍后再试！")
    return 0
  end
  tbKinData.nLastSaveSalaryTime = GetTime()
  GCExcute({ "Kin:SaveSalaryCount_GC", me.nId, nKinId, nMemberId, tbMember })
end
RegC2SFun("SaveSalaryCount", Kin.SaveSalaryCount_GS1)

function Kin:CheckMemberSalary(nKinId, tbClientMember)
  local nAttendanceCount = 0
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0, -1
  end
  local cMemberIt = cKin.GetMemberItor()
  local cMember = cMemberIt.GetCurMember()
  local nMemberId = cMemberIt.GetCurMemberId()
  while cMember do
    local nAttendance = tbClientMember[nMemberId]
    if not nAttendance or 0 == Lib:IsInteger(nAttendance) or nAttendance < 0 or nAttendance > 1000000 then
      return 0, -1
    end
    cMember = cMemberIt.NextMember()
    nMemberId = cMemberIt.GetCurMemberId()
    nAttendanceCount = nAttendanceCount + nAttendance
  end

  return 1, nAttendanceCount
end

function Kin:SaveSalaryCount_GS2(nPlayerId, nKinId, tbMember)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  for nId, nAttendance in pairs(tbMember) do
    local cMember = cKin.GetMember(nId)
    if cMember then
      cMember.SetAttendance(nAttendance)
    end
  end
  local cPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not cPlayer then
    return 0
  end
  cPlayer.Msg("家族出勤统计保存成功！")
  cPlayer.CallClientScript({ "Ui:ServerCall", "UI_KIN", "SaveSuccess_C2" })
end

function Kin:ClearSalaryCount_GS1()
  if EventManager.IVER_bOpenkinMoney ~= 1 then
    Dialog:SendBlackBoardMsg(me, "该功能暂未开放！")
    return
  end
  local nKinId, nMemberId = me.GetKinMember()
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    me.Msg("你没有家族，不能修改家族出勤统计！")
    return 0
  end
  if me.IsAccountLock() ~= 0 then
    Dialog:Say("你的账号处于锁定状态，无法进行该操作！")
    Account:OpenLockWindow(me)
    return
  end
  if Kin:CheckSelfRight(nKinId, nMemberId, 2) ~= 1 then
    Dialog:SendInfoBoardMsg(me, "只有族长和副族长才能修改家族出勤统计！")
    me.Msg("只有族长和副族长才能修改家族出勤统计！")
    return 0
  end
  local tbSalaryData = self:GetExclusiveEvent(nKinId, self.KIN_EVENT_SALARY)
  if tbSalaryData.nApplyEvent and tbSalaryData.nApplyEvent == 1 then
    Dialog:SendInfoBoardMsg(me, "有发放出勤奖励的申请！暂不能修改数据！")
    me.Msg("有发放出勤奖励的申请！暂不能修改出勤数据！")
    return 0
  end
  GCExcute({ "Kin:ClearSalaryCount_GC", me.nId, nKinId, nMemberId })
end
RegC2SFun("ClearSalaryCount", Kin.ClearSalaryCount_GS1)

function Kin:ClearSalaryCount_GS2(nPlayerId, nKinId)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  local cMemberIt = cKin.GetMemberItor()
  local cMember = cMemberIt.GetCurMember()
  while cMember do
    cMember.SetAttendance(0)
    cMember = cMemberIt.NextMember()
  end
  local cPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not cPlayer then
    return 0
  end
  cPlayer.Msg("家族出勤统计清零成功！")
  cPlayer.CallClientScript({ "Ui:ServerCall", "UI_KIN", "SaveSuccess_C2" })
end

function Kin:ApplySendSalary_GS1(nAttendanceAward, tbMember)
  if EventManager.IVER_bOpenkinMoney ~= 1 then
    Dialog:SendBlackBoardMsg(me, "该功能暂未开放！")
    return
  end
  if not nAttendanceAward or 0 == Lib:IsInteger(nAttendanceAward) or nAttendanceAward < 0 or nAttendanceAward > 2000000000 then
    return 0
  end
  if not tbMember or type(tbMember) ~= "table" then
    return 0
  end
  local nKinId, nMemberId = me.GetKinMember()
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    Dialog:SendInfoBoardMsg(me, "你没有家族，不能发放家族出勤奖励！")
    me.Msg("你没有家族，不能发放家族出勤奖励！")
    return 0
  end
  if me.IsAccountLock() ~= 0 then
    Dialog:Say("你的账号处于锁定状态，无法进行该操作！")
    Account:OpenLockWindow(me)
    return
  end
  if Kin:CheckSelfRight(nKinId, nMemberId, 1) ~= 1 then
    Dialog:SendInfoBoardMsg(me, "只有族长才能发放家族出勤奖励!")
    me.Msg("只有族长才能发放家族出勤奖励!")
    return 0
  end
  if me.IsInPrison() == 1 then
    me.Msg("您在坐牢期间不能发放家族出勤奖励！")
    return 0
  end
  local tbSalaryData = self:GetExclusiveEvent(nKinId, self.KIN_EVENT_SALARY)
  if tbSalaryData.nApplyEvent and tbSalaryData.nApplyEvent == 1 then
    Dialog:SendInfoBoardMsg(me, "已经有发放出勤奖励的申请！不能再申请！")
    me.Msg("已经有发放出勤奖励的申请！不能再申请！")
    return 0
  end
  local nLastSalaryTime = cKin.GetLastSalaryTime()
  if GetTime() - nLastSalaryTime < self.SEND_SALARY_TIME then
    Dialog:SendInfoBoardMsg(me, "发放出勤奖励至少需要间隔24小时！")
    me.Msg("发放出勤奖励至少需要间隔24小时！")
    return 0
  end
  local tbData = self:GetExclusiveEvent(nKinId, self.KIN_EVENT_TAKE_FUND)
  if tbData.nApplyEvent and tbData.nApplyEvent == 1 then
    Dialog:SendInfoBoardMsg(me, "有取出家族资金的申请！请先处理再发放出勤奖励！")
    me.Msg("有取出家族资金的申请！请先处理再发放出勤奖励！")
    return 0
  end
  local nCheck, nAttendanceCount = self:CheckMemberSalary(nKinId, tbMember)
  if nCheck ~= 1 then
    Dialog:SendInfoBoardMsg(me, "发放出勤奖励失败！请刷新数据后重新发放奖励！")
    me.Msg("发放出勤奖励失败！请刷新数据后重新发放奖励！")
    return 0
  end
  if self:CheckClientMember(nKinId, tbMember) ~= 1 then
    Dialog:SendInfoBoardMsg(me, "出勤统计已被修改，请保存或者刷新后再发放！")
    me.Msg("出勤统计已被修改，请保存或者刷新后再发放！")
    return 0
  end
  if nAttendanceCount == 0 then
    Dialog:SendInfoBoardMsg(me, "总人次为0，不能发放！")
    me.Msg("总人次为0，不能发放！")
    return 0
  end
  local nTotalSalary = nAttendanceCount * nAttendanceAward
  local nFund = cKin.GetMoneyFund()
  if nTotalSalary > nFund then
    Dialog:SendInfoBoardMsg(me, "家族资金不足，发放失败！")
    me.Msg("家族资金不足，发放失败！")
    return 0
  end
  GCExcute({ "Kin:ApplySendSalary_GC", me.nId, nKinId, nMemberId, tbMember, nAttendanceAward })
end
RegC2SFun("ApplySendSalary", Kin.ApplySendSalary_GS1)

function Kin:ApplySendSalary_GS2(nPlayerId, nKinId, nMemberId, nMoney, nAttendanceAward)
  local tbData = self:GetExclusiveEvent(nKinId, self.KIN_EVENT_SALARY)
  tbData.nApplyEvent = 1
  if not tbData.tbApplyRecord then
    tbData.tbApplyRecord = {}
  end
  tbData.tbApplyRecord.nMemberId = nMemberId
  tbData.tbApplyRecord.nAmount = nMoney
  tbData.tbApplyRecord.nAttendanceAward = nAttendanceAward
  tbData.tbApplyRecord.nPow = self.FIGURE_REGULAR
  tbData.tbAccept = {}
  tbData.nAgreeCount = 2
  tbData.tbApplyRecord.nTimerId = Timer:Register(self.TAKE_FUND_APPLY_LAST, self.CancelExclusiveEvent_GS, self, nKinId, self.KIN_EVENT_SALARY, nPlayerId)
  local cApplyPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if cApplyPlayer then
    cApplyPlayer.CallClientScript({ "Kin:NotifApplySalaryPlayer_C2", nMoney })
  end
  local szPlayerName = KGCPlayer.GetPlayerName(nPlayerId)
  KKinGs.KinClientExcute(nKinId, { "Kin:SendSalaryApply_C2", szPlayerName, nMoney, nAttendanceAward })
  return KKinGs.KinClientExcute(nKinId, { "Kin:SalaryRequestApply_C2", self.KIN_EVENT_SALARY, nMemberId, szPlayerName, nMoney })
end

function Kin:SendSalary_GS2(nDataVer, nPlayerId, nKinId, nCurFund, nTotalSalary, nLastSalaryTime, tbSalary)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  if not tbSalary then
    return 0
  end
  cKin.SetKinDataVer(nDataVer)
  cKin.SetMoneyFund(nCurFund)
  cKin.SetLastSalaryTime(nLastSalaryTime)
  for nMemberId, tbMember in pairs(tbSalary) do
    local cMember = cKin.GetMember(nMemberId)
    if cMember then
      cMember.SetAttendance(tbMember.nAttendance)
    end
  end
  local tbData = self:GetExclusiveEvent(nKinId, self.KIN_EVENT_SALARY)
  if tbData.nApplyEvent and tbData.nApplyEvent == 1 then
    if tbData.tbApplyRecord and tbData.tbApplyRecord.nTimerId then
      Timer:Close(tbData.tbApplyRecord.nTimerId)
    end
    self:DelExclusiveEvent(nKinId, self.KIN_EVENT_SALARY)
  end
  KKinGs.KinClientExcute(nKinId, { "Kin:SendSalary_C2", nTotalSalary })
  local cPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not cPlayer then
    return 0
  end
  cPlayer.Msg("出勤奖励发放成功！")
  cPlayer.CallClientScript({ "Ui:ServerCall", "UI_KIN", "ClearPromt_C2" })
end

function Kin:CheckClientMember(nKinId, tbClientMember)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0, -1
  end
  local cMemberIt = cKin.GetMemberItor()
  local cMember = cMemberIt.GetCurMember()
  local nMemberId = cMemberIt.GetCurMemberId()
  while cMember do
    local nAttendance = cMember.GetAttendance()
    if not tbClientMember[nMemberId] or tbClientMember[nMemberId] ~= nAttendance then
      return 0
    end
    cMember = cMemberIt.NextMember()
    nMemberId = cMemberIt.GetCurMemberId()
  end
  return 1
end

--操作失败解锁
function Kin:FailureToUnLock(nPlayerId)
  local cPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not cPlayer then
    return 0
  end
  -- 还原锁定状态
  cPlayer.AddWaitGetItemNum(-1)
  cPlayer.Msg("操作失败！")
end

function Kin:AddKinKillBaiHuTangCount(nPlayerId, nCount)
  if not nPlayerId or not nCount or nPlayerId <= 0 then
    return 0
  end
  GCExcute({ "Kin:AddKinKillBaiHuTangCount_GC", nPlayerId, nCount })
end

function Kin:AddKinKillBaiHuTangCount_GS(nPlayerId, nNum)
  -- 杀死boss会给家族增加一次本日击杀boss个数
  local dwKinId, nMemberId = KKin.GetPlayerKinMember(nPlayerId)
  if dwKinId > 0 then
    local pKin = KKin.GetKin(dwKinId)
    if pKin then
      local nCount = pKin.GetBaiHuTangKillNum()
      pKin.SetBaiHuTangKillNum(nCount + nNum)
    end
  end
end

function Kin:ClearGoldDate_GS(dwKinId)
  if dwKinId > 0 then
    local pKin = KKin.GetKin(dwKinId)
    if pKin then
      local itor = pKin.GetMemberItor()
      local cMember = itor.GetCurMember()
      while cMember do
        cMember.SetGoldLS(0)
        cMember = itor.NextMember()
      end
    end
  end
  return 1
end

-- 家族列表
function Kin:ShowKinDetail_GS(nKinId)
  local pKin = KKin.GetKin(nKinId)
  if not pKin then
    me.Msg("该家族不存在了。")
    return 0
  end
  local tbDetail = {}
  local pMemberItor = pKin.GetMemberItor()
  local pMember = pMemberItor.GetCurMember()
  while pMember do
    local szName = KGCPlayer.GetPlayerName(pMember.GetPlayerId())
    local tbInfo = GetPlayerInfoForLadderGC(szName)
    local nSex = tbInfo and tbInfo.nSex or 0
    local nFigure = pMember.GetFigure()
    local nHonor = PlayerHonor:GetPlayerMoneyHonorLevel(pMember.GetPlayerId())
    table.insert(tbDetail, { szName, nSex, nFigure, nHonor })
    pMember = pMemberItor.NextMember()
  end
  table.sort(tbDetail, function(a, b)
    return a[3] < b[3]
  end)
  me.CallClientScript({ "UiManager:OpenWindow", "UI_KIN_RECRUIT_PLAYERS" })
  me.CallClientScript({ "Ui:ServerCall", "UI_KIN_RECRUIT_PLAYERS", "OnRecvData", tbDetail })
end
RegC2SFun("ShowKinDetail", Kin.ShowKinDetail_GS)

-- 设置yy号
function Kin:SetYYNumber_GS1(nYYNumber)
  local nKinId, nExcutorId = me.GetKinMember()
  local nRet, cKin = self:CheckSelfRight(nKinId, nExcutorId, 2)
  if nRet ~= 1 then
    return 0
  end
  return GCExcute({ "Kin:SetYYNumber_GC", nKinId, nExcutorId, nYYNumber })
end
RegC2SFun("SetYYNumber", Kin.SetYYNumber_GS1)

function Kin:SetYYNumber_GS2(nKinId, nYYNumber)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  cKin.SetYYNumber(nYYNumber)
  return KKinGs.KinClientExcute(nKinId, { "Kin:SetYYNumber_C2", nYYNumber })
end

function Kin:AddGoldLSTask(nKinId, nExcutorId, nPoint)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  local cMember = cKin.GetMember(nExcutorId)
  if not cMember then
    return 0
  end
  local nTotalPoint = cMember.GetGoldLS()
  cMember.SetGoldLS(nTotalPoint + nPoint)
end

function Kin:SetGoldFlag(nKinId)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  cKin.SetGoldLogo(1)
  KKin.Msg2Kin(nKinId, "族长标记家族为金牌家族。")
end

function Kin:ApplyRepTakeAuthority_GS()
  local nKinId, nExcutorId = me.GetKinMember()
  KinRepository:ApplyTakeAuthority(me, nKinId)
end
RegC2SFun("ApplyRepTakeAuthority", Kin.ApplyRepTakeAuthority_GS)

-- 申请仓库信息
function Kin:RefreshRepositoryInfo_GS()
  KinRepository:SyncRepositoryInfo(me)
end
RegC2SFun("RefreshRepositoryInfo", Kin.RefreshRepositoryInfo_GS)

-- 申请查看仓库记录
function Kin:ApplyViewRecord_GS(nRoomType, nPage)
  if not nRoomType or Lib:IsInteger(nRoomType) == 0 or not nPage or Lib:IsInteger(nPage) == 0 then
    return
  end
  KinRepository:ApplyViewRecord_GS(me, nRoomType, nPage)
end
RegC2SFun("ApplyViewRecord", Kin.ApplyViewRecord_GS)

-- 申请扩仓库
function Kin:ApplyExtendRep_GS()
  local dwKinId, nExcutorId = me.GetKinMember()
  if dwKinId == 0 then
    return
  end

  local cKin = KKin.GetKin(dwKinId)
  --	local nRet, cKin = self:CheckSelfRight(dwKinId, nExcutorId, 1)
  --	if nRet ~= 1 then
  --		Dialog:Say("只有家族族长才能操作");
  --		return;
  --	end
  if cKin.GetIsOpenRepository() == 0 then
    return
  end
  local tbOpt = {
    { "扩展公共仓库", KinRepository.ExtendRep, KinRepository, KinRepository.REPTYPE_FREE },
    { "扩展权限仓库", KinRepository.ExtendRep, KinRepository, KinRepository.REPTYPE_LIMIT },
    { "我再考虑一下" },
  }
  local nFreeLevel = cKin.GetFreeRepBuildLevel()
  local nLimitLevel = cKin.GetLimitRepBuildLevel()
  local szMsg = string.format("<color=green>【仓库信息】<color><enter>公共仓库：已扩展%s/18次<enter>权限仓库：已扩展%s/18次<enter><enter><color=green>【当前建设度】<color><enter>家族当前建设度：<color=yellow>%s点<color><enter><color=yellow>通过家族总工资数发放仓库建设度。<color><enter><enter><color=green>【扩展信息】<color>\n", nFreeLevel, nLimitLevel, cKin.GetRepBuildValue())
  if nFreeLevel >= #KinRepository.BUILD_VALUE[KinRepository.REPTYPE_FREE] then
    szMsg = szMsg .. "家族公共仓库已扩展到最高级<enter>"
  else
    local nExtendMoney = KinRepository:GetExtendMoney(KinRepository.REPTYPE_FREE, nFreeLevel + 1)
    szMsg = szMsg .. string.format("公共仓库下级扩展需仓库建设度%s点，银两%s两<enter>", KinRepository.BUILD_VALUE[KinRepository.REPTYPE_FREE][nFreeLevel + 1][1], nExtendMoney)
  end
  if nLimitLevel >= #KinRepository.BUILD_VALUE[KinRepository.REPTYPE_LIMIT] then
    szMsg = szMsg .. "家族权限仓库已扩展到最高级<enter>"
  else
    local nExtendMoney = KinRepository:GetExtendMoney(KinRepository.REPTYPE_LIMIT, nLimitLevel + 1)
    szMsg = szMsg .. string.format("权限仓库下级扩展需仓库建设度%s点，银两%s两<enter>", KinRepository.BUILD_VALUE[KinRepository.REPTYPE_LIMIT][nLimitLevel + 1][1], nExtendMoney)
  end
  Dialog:Say(szMsg, tbOpt)
end
RegC2SFun("ApplyExtendRep", Kin.ApplyExtendRep_GS)

-- 更改权限
function Kin:ApplySetMemberRepAuthority_GS(nMemberId)
  if not nMemberId or 0 == Lib:IsInteger(nMemberId) then
    Dialog:Say("请先选择所要操作的家族成员。")
    return
  end
  local nKinId, nExcutorId = me.GetKinMember()
  if nMemberId == nExcutorId then
    Dialog:Say("族长是默认管理员，不需要再设置。")
    return
  end
  local nRet, cKin = self:CheckSelfRight(nKinId, nExcutorId, 1)
  if nRet ~= 1 then
    Dialog:Say("只有族长才可以更改权限。")
    return
  end
  if cKin.GetIsOpenRepository() == 0 then
    Dialog:Say("请开启家族仓库再设置权限。")
    return
  end
  local cMember = cKin.GetMember(nMemberId)
  if not cMember then
    return
  end
  local nRepAuthority = cMember.GetRepAuthority()
  local nPlayerId = cMember.GetPlayerId()
  local szMemberName = KGCPlayer.GetPlayerName(nPlayerId)
  local tbOpt = {}
  local szMsg = string.format("家族成员[%s]", szMemberName)
  if nRepAuthority < 0 then
    szMsg = szMsg .. "操作家族仓库的权限已被禁止，是否恢复？"
    tbOpt[1] = { "恢复权限", KinRepository.SetMemberRepAuthority, KinRepository, nMemberId, nRepAuthority, 0 }
  elseif nRepAuthority == 0 then
    szMsg = szMsg .. "不是本家族的仓库管理员，你想对他怎样设置？<enter>设置为管理员后，该成员即可申请操作家族的<color=green>权限仓库<color>。禁止操作后，该成员操作<color=green>所有仓库<color>的权限将被禁止。"
    tbOpt[1] = { "设置为管理员", KinRepository.SetMemberRepAuthority, KinRepository, nMemberId, nRepAuthority, KinRepository.AUTHORITY_ASSISTANT }
    tbOpt[2] = { "禁止操作", KinRepository.SetMemberRepAuthority, KinRepository, nMemberId, nRepAuthority, -1 }
  else
    szMsg = szMsg .. "是本家族的仓库管理员，你想对他怎样设置？<enter>撤销管理员后，该成员将不能再申请操作家族的<color=green>权限仓库<color>。禁止操作后，该成员操作<color=green>所有仓库<color>的权限将被禁止"
    tbOpt[1] = { "撤销管理员", KinRepository.SetMemberRepAuthority, KinRepository, nMemberId, nRepAuthority, 0 }
    tbOpt[2] = { "禁止操作", KinRepository.SetMemberRepAuthority, KinRepository, nMemberId, nRepAuthority, -1 }
  end
  tbOpt[#tbOpt + 1] = { "我再考虑一下" }
  Dialog:Say(szMsg, tbOpt)
end
RegC2SFun("ApplySetMemberRepAuthority", Kin.ApplySetMemberRepAuthority_GS)

-- 设置家族徽章
function Kin:SetKinBadge_GS1(nSelectBadge, nType)
  local nKinId, nExcutorId = me.GetKinMember()
  local nRet, cKin = self:CheckSelfRight(nKinId, nExcutorId, 2)
  if nRet ~= 1 then
    return 0
  end
  local nRecord = 0
  local nRegular, nSigned, nRetire = cKin.GetMemberCount()
  if nType == 1 then
    nRecord = cKin.GetBadgeRecord1()
  elseif nType == 2 then
    nRecord = cKin.GetBadgeRecord2()
    if nRegular < self.nBuyLimitPlayerCount2 then
      Dialog:Say(string.format("使用2级徽章需要家族正式成员数达到%s人，请扩充您的家族。", self.nBuyLimitPlayerCount2))
      return
    end
  elseif nType == 3 then
    nRecord = cKin.GetBadgeRecord3()
    if nRegular < self.nBuyLimitPlayerCount3 then
      Dialog:Say(string.format("使用3级徽章需要家族正式成员数达到%s人，请扩充您的家族。", self.nBuyLimitPlayerCount3))
      return
    end
  end
  if nType ~= 1 or nSelectBadge ~= 1 then
    if Lib:LoadBits(nRecord, nSelectBadge - 1, nSelectBadge - 1) ~= 1 then
      Dialog:Say("您还没购买这个徽章，请先购买。")
      return 0
    end
  end

  return GCExcute({ "Kin:SetKinBadge_GC", nKinId, nExcutorId, me.nId, nSelectBadge, nType })
end

RegC2SFun("SetKinBadge", Kin.SetKinBadge_GS1)

function Kin:SetKinBadge_GS2(nKinId, nPlayerId, nSelectBadge, nType)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  cKin.SetKinBadge(nType * 10000 + nSelectBadge)

  local szPlayerName = KGCPlayer.GetPlayerName(nPlayerId)
  KKinGs.KinClientExcute(nKinId, { "Kin:SetKinBadge_C2", szPlayerName, nSelectBadge, nType })
end

-- 购买家族徽章
function Kin:ApplyBuyBadge_GS1(nRecord, nRate)
  if nRate <= 0 or nRate >= 4 or nRecord <= 0 or nRecord > 30 then
    return 0
  end
  if me.IsAccountLock() ~= 0 then
    Dialog:Say("你的账号处于锁定状态，无法进行该操作！")
    Account:OpenLockWindow(me)
    return
  end
  if me.IsInPrison() == 1 then
    me.Msg("您在坐牢期间不能使用家族资金。")
    return 0
  end
  local nKinId, nExcutorId = me.GetKinMember()
  local nRet, cKin = self:CheckSelfRight(nKinId, nExcutorId, 1)
  if nRet ~= 1 then
    Dialog:Say("您没有权限购买族徽，请你们的族长来购买吧。")
    return 0
  end
  local nKinId, nMemberId = me.GetKinMember()
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    Dialog:Say("你没有家族，不能使用家族资金。")
    return 0
  end
  --购买条件
  local nRecordEx = 0
  local nRegular, nSigned, nRetire = cKin.GetMemberCount()
  if nRate == 1 then
    nRecordEx = cKin.GetBadgeRecord1()
  elseif nRate == 2 then
    nRecordEx = cKin.GetBadgeRecord2()
    if nRegular < self.nBuyLimitPlayerCount2 then
      Dialog:Say("购买2级徽章需要家族正式成员数达到30人，请扩充您的家族。")
      return
    end
  elseif nRate == 3 then
    nRecordEx = cKin.GetBadgeRecord3()
    if nRegular < self.nBuyLimitPlayerCount3 then
      Dialog:Say("购买3级徽章需要家族正式成员数达到50人，请扩充您的家族。")
      return
    end
  end

  if Lib:LoadBits(nRecordEx, nRecord - 1, nRecord - 1) == 1 or (nRecord == 1 and nRate == 1) then
    Dialog:Say("你们家族已经拥有这个徽章了。")
    return 0
  end

  local tbData = self:GetExclusiveEvent(nKinId, self.KIN_EVENT_BUYBADGE)
  if tbData.nApplyEvent and tbData.nApplyEvent == 1 then
    Dialog:SendInfoBoardMsg(me, "已经有购买徽章的申请！不能再申请！")
    me.Msg("已经有购买徽章的申请！不能再申请！")
    return 0
  end

  if tbData.nLastTime and GetTime() - tbData.nLastTime < self.TAKE_FUND_TIME then
    Dialog:SendInfoBoardMsg(me, "两次使用家族资金购买徽章需要间隔5分钟！")
    me.Msg("两次使用家族资金购买徽章需要间隔5分钟")
    return 0
  end

  local nMoney = self.BADGE_LEVEL_PRICE[nRate]
  local nCurFund = cKin.GetMoneyFund()
  if nMoney > nCurFund then
    Dialog:SendInfoBoardMsg(me, "家族没有足够的资金供你购买徽章！")
    me.Msg("家族没有足够的资金供你购买徽章！")
    return 0
  end
  return GCExcute({ "Kin:ApplyBuyBadge_GC", nKinId, nMemberId, me.nId, nRecord, nRate })
end
RegC2SFun("BuyBadge", Kin.ApplyBuyBadge_GS1)

function Kin:ApplyBuyBadge_GS2(nKinId, nMemberId, nPlayerId, nRecord, nRate)
  local tbData = self:GetExclusiveEvent(nKinId, self.KIN_EVENT_BUYBADGE)
  tbData.nApplyEvent = 1
  if not tbData.tbApplyRecord then
    tbData.tbApplyRecord = {}
  end
  local nMoney = self.BADGE_LEVEL_PRICE[nRate]
  tbData.tbApplyRecord.nMemberId = nMemberId
  tbData.tbApplyRecord.nPlayerId = nPlayerId
  tbData.tbApplyRecord.nAmount = nMoney
  tbData.tbApplyRecord.nRate = nRate
  tbData.tbApplyRecord.nRecord = nRecord
  tbData.tbAccept = {}
  -- 族长取钱买徽章，需两名正式成员同意
  tbData.tbApplyRecord.nPow = self.FIGURE_REGULAR
  tbData.nAgreeCount = 2
  tbData.tbApplyRecord.nTimerId = Timer:Register(self.TAKE_FUND_APPLY_LAST, self.CancelExclusiveEvent_GS, self, nKinId, self.KIN_EVENT_BUYBADGE, nPlayerId)
  local szPlayerName = KGCPlayer.GetPlayerName(nPlayerId)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  KKinGs.KinClientExcute(nKinId, { "Kin:GetBuyBadgeApply_C2", self.KIN_EVENT_BUYBADGE, nMemberId, szPlayerName, nMoney, nRate })
end

function Kin:BuyBadge_GS2(nKinId, nMemberId, nPlayerId, nMoney, nRecord, nRate)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  local cPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not cPlayer then
    return 0
  end
  local nCurMoney = cKin.GetMoneyFund() - nMoney
  cKin.SetMoneyFund(nCurMoney) -- 取钱
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

  local szPlayerName = KGCPlayer.GetPlayerName(nPlayerId)
  local tbData = self:GetExclusiveEvent(nKinId, self.KIN_EVENT_BUYBADGE)
  tbData.nLastTime = GetTime()
  if tbData.nApplyEvent and tbData.nApplyEvent == 1 then
    if tbData.tbApplyRecord and tbData.tbApplyRecord.nTimerId then
      Timer:Close(tbData.tbApplyRecord.nTimerId)
    end
    self:DelExclusiveEvent(nKinId, self.KIN_EVENT_BUYBADGE)
  end
  KKinGs.KinClientExcute(nKinId, { "Kin:BuyBadge_C2", szPlayerName, nMoney, nRecord, nRate })
  Dbg:WriteLog("Kin:BuyBadge_GS2", cKin.GetName(), nCurMoney, cPlayer.szName, cPlayer.szAccount, nMoney)
end

function Kin:SysChangeKinBadge(nKinId)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  local tbLimit = { [2] = Kin.nBuyLimitPlayerCount2, [3] = Kin.nBuyLimitPlayerCount3 }
  local nSelectBadge = cKin.GetKinBadge()
  local nLevel = math.floor(nSelectBadge / 10000)
  cKin.SetKinBadge(10001) --默认降级为第一等级第一个
  local nCaptainId = Kin:GetPlayerIdByMemberId(nKinId, cKin.GetCaptain())
  local szCaptainIdName = ""
  if nCaptainId then
    szCaptainIdName = KGCPlayer.GetPlayerName(nCaptainId)
  end
  if szCaptainIdName ~= "" and (GetServerId() == 1) then --只用1号服务器发邮件
    KPlayer.SendMail(szCaptainIdName, "家族族徽降级通知", string.format("由于您的家族启用的家族族徽等级为%s，需满足家族正式成员%s个，现在由于人员不足，您的家族族徽被剥夺使用权限降级为1级徽章，请您招揽人员扩充家族，方可再次使用%s级徽章。", nLevel, tbLimit[nLevel], nLevel))
  end
  return KKinGs.KinClientExcute(nKinId, { "Kin:SysChangeKinBadge" })
end

-- 记录玩家下线时间
function Kin:SetLastLogOutTime_GS(nKinId, nMemberId, nTime)
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end
  local cMember = cKin.GetMember(nMemberId)
  if not cMember then
    return 0
  end

  if nTime < 0 then
    return 0
  end
  cMember.SetLastLogOutTime(nTime)
end
