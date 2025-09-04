-------------------------------------------------------------------
--File: tonglogic_c.lua
--Author: lbh
--Date: 2007-9-6 11:24
--Describe: 客户端帮会逻辑
-------------------------------------------------------------------
if not Tong then --调试需要
  Tong = {}
  print(GetLocalDate("%Y\\%m\\%d  %H:%M:%S") .. " build ok ..")
else
  if not MODULE_GAMECLIENT then
    return
  end
end

function Tong:OnServerExcute(tbCall)
  print("Tong:OnServerExcute", unpack(tbCall))
  Lib:CallBack(tbCall)
end

function Tong:InviteTong(nPlayerId) -- 邀请家族加入帮会,程序调用
  me.CallServerScript({ "TongCmd", "InviteAdd", nPlayerId })
end

function Tong:JoinTong(nPlayerId) -- 申请加入帮会，程序调用
  me.CallServerScript({ "TongCmd", "JoinTong", nPlayerId })
end

--显示创建帮会输入框
function Tong:ShowCreateTongDlg()
  CoreEventNotify(UiNotify.emCOREEVENT_OPEN_TONGCREATE)
end

function Tong:CreateTong_C(szTongName, nCamp)
  --是否允许的单词范围
  if KUnify.IsNameWordPass(szTongName) ~= 1 then
    me.Msg("名称只能包含中文简繁体字及· 【 】符号！")
    return 0
  end
  for i, v in ipairs(Kin.aKinTongNameFilter) do
    if string.find(szTongName, v) then
      me.Msg("对不起，您输入的帮会名称包含敏感字词，请重新设定")
      return
    end
  end
  me.CallServerScript({ "TongCmd", "CreateTong", szTongName, nCamp })
  return 1
end

function Tong:CreateTong_C2(szTongName, nCamp, nMasterKinId)
  local nKinId, _ = me.GetKinMember()
  if me.nKinFigure == Kin.FIGURE_CAPTAIN then
    if nKinId == nMasterKinId then
      me.Msg("帮会<color=yellow>" .. szTongName .. "<color>创建成功，帮会进入考验期，你成为第一任帮主，江湖威望增加100！")
    else
      me.Msg("帮会<color=yellow>" .. szTongName .. "<color>创建成功，帮会进入考验期，你成为帮会长老，江湖威望增加20！")
    end
  end
end

function Tong:DisbandTong_C2()
  Kin:LeaveTong_C2()
  me.Msg("你的家族所在帮会已经解散！")
end

function Tong:ChangeMaster_C2(szName)
  KTong.ShowTongMsg("<color=white>" .. szName .. "<color>被任命为<color=green>帮主<color>！")
end

function Tong:ApplyJoin_C2(nKinId, nMemberId, szKinName, szPlayerName)
  KTong.ShowTongMsg(string.format("<color=green>[%s]<color>家族族长<color=white>%s<color>申请加入你的帮会", szKinName, szPlayerName))
  CoreEventNotify(UiNotify.emCOREEVENT_CONFIRMATION, UiNotify.CONFIRMATION_TONG_APPLY_JOIN, nKinId, nMemberId, szKinName, szPlayerName)
end

function Tong:InviteAdd_C2(nPlayerId, szTongName, szPlayerName)
  me.Msg(szTongName .. "帮会帮主" .. szPlayerName .. "邀请你的家族加入帮会")
  CoreEventNotify(UiNotify.emCOREEVENT_CONFIRMATION, UiNotify.CONFIRMATION_TONG_INVITE_ADD, nPlayerId, szTongName, szPlayerName)
end

function Tong:KinAdd_C2(szKinName, nRepute, nAddFund)
  KTong.ShowTongMsg(string.format("家族<color=white>%s<color>加入到本帮会，帮会威望增加<color=yellow>%d<color>，帮会资金增加%d", szKinName, nRepute, nAddFund))
end

function Tong:KinDel_C2(szKinName, nRepute, nMethod, nReduceFund)
  -- 将来要改在聊天频道上显示
  if nMethod == 0 then
    KTong.ShowTongMsg(string.format("家族<color=white>%s<color>离开了本帮会，帮会威望减少<color=green>%d<color>，帮会建设资金减少<color=green>%d<color>", szKinName, nRepute, nReduceFund))
  else
    KTong.ShowTongMsg(string.format("家族<color=white>%s<color>被开除了，帮会威望减少<color=green>%d<color>，帮会建设资金减少<color=green>%d<color>", szKinName, nRepute, nReduceFund))
    me.TongRequest_DelRequest(self.REQUEST_KICK_KIN)
  end
end

function Tong:KinDelFailed_C2()
  KTong.ShowTongMsg("不能开除帮主或者首领的家族！")
end

function Tong:ApointAssistant_C2(nAssistantId, nOrgKinId, nKinId, szAssistant, szName, szOrgName)
  if szOrgName then
    KTong.ShowTongMsg("<color=white>" .. szOrgName .. "<color>的<color=green>" .. szAssistant .. "<color>职位被罢免！")
  end
  KTong.ShowTongMsg("<color=white>" .. szName .. "<color>被任命为<color=green>" .. szAssistant)
  if (Ui(Ui.UI_TONG)).nPageSetNo == Tong.NO_PAGE_TONG_POSITION then
    local cTong = KTong.GetSelfTong()
    if not cTong then
      return 0
    end
    local cOrgKin = cTong.GetKin(nOrgKinId)
    local cKin = cTong.GetKin(nKinId)
    if not cKin then
      return 0
    end
    cKin.SetTongFigure(nAssistantId)
    if cOrgKin then
      cOrgKin.SetTongFigure(self.CAPTAIN_NORMAL)
    end
    CoreEventNotify(UiNotify.emCOREEVENT_TONG_ALL_KIN_INFO)
  end
end

function Tong:ApointEmissary_C2(nTagetKinId, nTagetMemberId, nEmissaryId, szPlayerName, szEmissaryName)
  if szPlayerName and szEmissaryName then
    KTong.ShowTongMsg("<color=white>" .. szPlayerName .. "<color>被任命为<color=blue>" .. szEmissaryName)
  end
  if (Ui(Ui.UI_TONG)).nPageSetNo == Tong.NO_PAGE_TONG_POSITION then
    local cTong = KTong.GetSelfTong()
    if not cTong then
      return 0
    end
    local cKin = cTong.GetKin(nTagetKinId)
    if not cKin then
      return 0
    end
    local cMember = cKin.GetMember(nTagetMemberId)
    if not cMember then
      return 0
    end
    cMember.SetEnvoyFigure(nEmissaryId)
    CoreEventNotify(UiNotify.emCOREEVENT_TONG_ALL_KIN_INFO)
  end
end

function Tong:ChangeAssistant_C2(nAssistantId, szAssistant, nPow)
  KTong.ShowTongMsg("帮主改变了<color=green>" .. szAssistant .. "<color>的职位设置")

  if (Ui(Ui.UI_TONG)).nPageSetNo == Tong.NO_PAGE_TONG_POSITION then
    -- 更新打开了窗口的客户的显示 (同步数据)
    local cTong = KTong.GetSelfTong()
    if cTong then
      cTong.SetCaptainTitle(nAssistantId, szAssistant)
      cTong.AssignCaptainPower(nAssistantId, nPow);
      (Ui(Ui.UI_TONG)):UpdateFigureInfo()
    end
  end
end

function Tong:ChangeEmissary_C2(nEmissaryId, szEmissary)
  KTong.ShowTongMsg("第<color=white>" .. nEmissaryId .. "<color>掌令使的称谓修改为<color=blue>" .. szEmissary)
  if (Ui(Ui.UI_TONG)).nPageSetNo == Tong.NO_PAGE_TONG_POSITION then
    -- 更新打开了窗口的客户的显示(同步数据)
    local cTong = KTong.GetSelfTong()
    if cTong then
      cTong.SetEnvoyTitle(nEmissaryId, szEmissary);
      (Ui(Ui.UI_TONG)):UpdateFigureInfo()
    end
  end
end

function Tong:FireEmissary_C2(nKinId, nMemberId, szName)
  KTong.ShowTongMsg("<color=white>" .. szName .. "<color>的掌令使职位被卸去")

  if (Ui(Ui.UI_TONG)).nPageSetNo == Tong.NO_PAGE_TONG_POSITION then -- 即时显示删除效果（同步数据）
    local cTong = KTong.GetSelfTong()
    if cTong then
      local cKin = cTong.GetKin(nKinId)
      if not cKin then
        return 0
      end
      local cMember = cKin.GetMember(nMemberId)
      if not cMember then
        return 0
      end
      cMember.SetEnvoyFigure(0)
      CoreEventNotify(UiNotify.emCOREEVENT_TONG_ALL_KIN_INFO)
    end
  end
end

function Tong:FireAllEmissary_C2(nEmissaryId, szEmissary)
  if szEmissary then
    KTong.ShowTongMsg("被任命为<color=blue>" .. szEmissary .. "<color>的所有成员职位被卸去！")
  end
  if (Ui(Ui.UI_TONG)).nPageSetNo == Tong.NO_PAGE_TONG_POSITION then
    (Ui(Ui.UI_TONG)).tbEmissary[nEmissaryId] = {} -- 暂时清空显示信息，以达到即时显示效果(数据不同步)
    (Ui(Ui.UI_TONG)):UpdateEmissaryMember(nEmissaryId)
  end
end

function Tong:SaveAnnounce_C2()
  KTong.ShowTongMsg("帮会公告已更新！")
  if (Ui(Ui.UI_TONG)).nPageSetNo == Tong.NO_PAGE_TONG_NOTE then
    (Ui(Ui.UI_TONG)):Refresh(0)
  end
end

function Tong:ChangeTakeStock_C2(nWageLevel, nEnergy)
  KTong.ShowTongMsg("帮会消耗了" .. nEnergy .. "点行动力，把分红比例调整为<color=red>" .. nWageLevel .. "%")
end

function Tong:HandUp_C2(nSelfKinId, nSelfMemberId)
  local tbTemp = me.GetTempTable("Tong")
  if tbTemp then
    if not tbTemp.Tong_tbHandUp then
      tbTemp.Tong_tbHandUp = {}
    end
    if not tbTemp.Tong_tbHandUp[nSelfKinId] then
      tbTemp.Tong_tbHandUp[nSelfKinId] = {}
    end
    tbTemp.Tong_tbHandUp[nSelfKinId][nSelfMemberId] = 1
    CoreEventNotify(UiNotify.emCOREEVENT_TONG_ALL_KIN_INFO)
    if (Ui(Ui.UI_TONG)).nPageSetNo ~= Tong.NO_PAGE_TONG_NONE then
      (Ui(Ui.UI_TONG)):UpdateMemberList()
    end
  end
end

function Tong:SendApply_C2(nRequset, szName, nAmount, nType, szKinName)
  if nRequset == self.REQUEST_DISPENSE_FUND then
    KTong.ShowTongMsg("<color=white>" .. szName .. "<color>申请对群体[" .. Tong.tbCrowdTitle[nType] .. "]发放资金<color=red>" .. nAmount .. "<color>两！需要两名拥有资金权限的长老同意方可成功！")
  elseif nRequset == self.REQUEST_DISPENSE_OFFER then
    KTong.ShowTongMsg("<color=white>" .. szName .. "<color>申请对群体[" .. Tong.tbCrowdTitle[nType] .. "]发放贡献度<color=red>" .. nAmount .. "<color>点！需要两名拥有贡献度权限的长老同意方可成功！")
  elseif nRequset == self.REQUEST_TAKE_FUND then
    KTong.ShowTongMsg("<color=white>" .. szName .. "<color>申请取出帮会资金<color=red>" .. nAmount .. "<color>两！需要两名拥有资金权限的长老同意方可成功！")
  elseif nRequset == self.REQUEST_KICK_KIN then
    KTong.ShowTongMsg("<color=white>" .. szName .. "<color>发起了开除家族，10分钟内获得其他2位长老同意则开除成功！")
  elseif nRequset == self.REQUEST_STORAGE_FUND_TO_KIN then
    KTong.ShowTongMsg("<color=white>" .. szName .. "<color>申请向<color=white>" .. szKinName .. "<color>家族转存<color=red>" .. nAmount .. "<color>两帮会资金！需要两名拥有资金权限的长老同意方可成功！")
  end
end

function Tong:GetApply_C2(szName, nRequset, nId, nData)
  local szMsg
  if nRequset == self.REQUEST_DISPENSE_FUND then
    szMsg = szName .. "申请对[" .. Tong.tbCrowdTitle[nId] .. "]每人发放" .. nData .. "两"
  elseif nRequset == self.REQUEST_DISPENSE_OFFER then
    szMsg = szName .. "申请对[" .. Tong.tbCrowdTitle[nId] .. "]每人发放" .. nData .. "点贡献"
  elseif nRequset == self.REQUEST_TAKE_FUND then
    szMsg = szName .. "申请取出帮会资金" .. nData .. "两！"
  elseif nRequset == self.REQUEST_KICK_KIN then
    szMsg = "开除家族[" .. szName .. "]"
  elseif nRequset == self.REQUEST_STORAGE_FUND_TO_KIN then
    szMsg = "向" .. szName .. "家族转存" .. nData .. "两帮会资金"
  end
  local nTimerId = Timer:Register(self.DISPENSE_APPLY_LAST, self.CancelApply_C2, self, nRequset)
  local tbRequest = {}
  tbRequest.szMsg = szMsg
  tbRequest.nTimerId = nTimerId
  me.TongRequest_AddRequest(nRequset, tbRequest)
  me.Msg("有新的帮会申请，请在帮会界面内“申请列表”中表决！")
  Ui("UI_TASKTIPS"):Begin("有新的帮会申请，请在帮会界面内“申请列表”中表决！")
  --confirmmsg是一个nil值
  --ConfirmMsg(Tong.SMCT_UI_TONG_REQUEST_LIST, "有新的帮会申请，请查收！", 0);
end

function Tong:AcceptExclusiveEvent_C2(szPlayerName, nKey, nAccept)
  local szMsg
  if nAccept == 1 then
    szMsg = "<color=white>" .. szPlayerName .. "<color>同意了"
  else
    szMsg = "<color=white>" .. szPlayerName .. "<color>拒绝了"
  end
  local szMsg2
  if nKey == self.REQUEST_DISPENSE_FUND then
    szMsg2 = "发放资金的申请"
  elseif nKey == self.REQUEST_DISPENSE_OFFER then
    szMsg2 = "发放贡献度的申请"
  elseif nKey == self.REQUEST_TAKE_FUND then
    szMsg2 = "取出资金的申请"
  elseif nKey == self.REQUEST_KICK_KIN then
    szMsg2 = "开除家族的申请"
  elseif nKey == self.REQUEST_STORAGE_FUND_TO_KIN then
    szMsg2 = "帮会资金转存家族的申请"
  end
  KTong.ShowTongMsg(szMsg .. szMsg2)
end

-- 定时函数，删除申请事件
function Tong:CancelApply_C2(nKey)
  local tbTemp = me.GetTempTable("Tong")
  if tbTemp then
    if not tbTemp.Tong_tbRequest then
      tbTemp.Tong_tbRequest = {}
      return 0
    end
    if tbTemp.Tong_tbRequest[nKey] then
      tbTemp.Tong_tbRequest[nKey] = nil
    end
  end
  return 0
end

function Tong:ApplyFailed_C2(nType)
  if nType == self.REQUEST_DISPENSE_FUND then
    KTong.ShowTongMsg("你的发放资金申请超时了！")
  elseif nType == self.REQUEST_DISPENSE_OFFER then
    KTong.ShowTongMsg("你的发放贡献度申请超时了！")
  elseif nType == self.REQUEST_TAKE_FUND then
    KTong.ShowTongMsg("你取出帮会资金的申请超时了！")
  elseif nType == self.REQUEST_KICK_KIN then
    KTong.ShowTongMsg("你的开除家族申请超时了！")
  elseif nType == self.REQUEST_STORAGE_FUND_TO_KIN then
    KTong.ShowTongMsg("你转存帮会资金到家族的申请超时了")
  end
  return 0
end

function Tong:GetDispense_C2(nType, nAmount)
  if nType == self.DISPENSE_FUND then
    KTong.ShowTongMsg("你获得帮会发放的资金<color=red>" .. nAmount .. "<color>两")
  elseif nType == self.DISPENSE_OFFER then
    KTong.ShowTongMsg("你获得帮会发放的贡献度<color=green>" .. nAmount .. "<color>点")
  else
    print("error! undefined dispense type! " .. nType)
  end
end

function Tong:SyncDispense_C2(nType, nCrowdType, nAmount)
  local szMsg = "帮会对群体[" .. Tong.tbCrowdTitle[nCrowdType] .. "]每人发放" .. nAmount
  if nType == self.DISPENSE_FUND then
    me.TongRequest_DelRequest(self.REQUEST_DISPENSE_FUND)
    KTong.ShowTongMsg(szMsg .. "两帮会资金！")
  elseif nType == self.DISPENSE_OFFER then
    me.TongRequest_DelRequest(self.REQUEST_DISPENSE_OFFER)
    KTong.ShowTongMsg(szMsg .. "点贡献度！")
  end
end

function Tong:FailedDispense_C2(nType)
  if nType == self.DISPENSE_FUND then
    me.TongRequest_DelRequest(self.REQUEST_DISPENSE_FUND)
    KTong.ShowTongMsg("资金不足！不能发放！")
  elseif nType == self.DISPENSE_OFFER then
    me.TongRequest_DelRequest(self.REQUEST_DISPENSE_OFFER)
    KTong.ShowTongMsg("储备贡献度不足！不能发放！")
  end
end

function Tong:AddFund_C2(szNmae, nFund)
  KTong.ShowTongMsg("<color=white>" .. szNmae .. "<color>存入帮会资金:<color=red>" .. nFund .. "<color>两！")
end

function Tong:TakeFund_C2(szName, nMoney)
  KTong.ShowTongMsg("<color=white>" .. szName .. "<color>在帮会资金中取出<color=red>" .. nMoney .. "<color>两！")
  me.TongRequest_DelRequest(self.REQUEST_TAKE_FUND)
end

function Tong:AddBuildFund_C2(szName, nMoney)
  KTong.ShowTongMsg("<color=white>" .. szName .. "<color>存入<color=red>" .. nMoney .. "两建设资金")
end

function Tong:ElectMaster_C2(szSelfName, szTagetName, nVote)
  --KTong.ShowTongMsg("<color=white>"..szSelfName.."<color>代表家族投票给<color=white>"..szTagetName.."<color>, 现有票数上升为<color=cyan>"..nVote);
end

function Tong:FundToBuildFund_C2(szPlayerName, nMoney)
  KTong.ShowTongMsg("<color=white>" .. szPlayerName .. "<color>把帮会资金<color=red>" .. nMoney .. "<color>两转到建设资金")
end

function Tong:ChangeTitle_C2(nTitleType, szTitle)
  KTong.ShowTongMsg("帮会的[" .. Tong.TITLE_MENU[nTitleType - 1] .. "]修改为<color=pink>" .. szTitle)
end

function Tong:ChangeCamp_C2(nCamp)
  KTong.ShowTongMsg("帮会消耗了<color=red>" .. Tong.CHANGE_CAMP .. "<color>建设资金,阵营改变为<color=pink>" .. Tong.CAMP[nCamp])
end

function Tong:GetInPutWage(nTongId, nKinId, nMemberId, nPlayerId, nCanGetWage)
  local tbFundParam = {}
  tbFundParam.tbTable = self
  tbFundParam.fnAccept = self.AcceptGetInPutWage
  tbFundParam.nType = 0
  tbFundParam.tbRange = { 1, nCanGetWage }
  tbFundParam.szTitle = "领取工资"
  UiManager:OpenWindow(Ui.UI_TEXTINPUT, tbFundParam, nTongId, nKinId, nMemberId, nPlayerId)
end

function Tong:AcceptGetInPutWage(nMoney, nTongId, nKinId, nMemberId, nPlayerId)
  me.CallServerScript({ "TongCmd", "GetInPutWage", nTongId, nKinId, nMemberId, nPlayerId, tonumber(nMoney) })
end

-- 客户端判断自己是不是首领
function Tong:IsPresident_C()
  local pTong = KTong.GetSelfTong()
  if not pTong then
    return 0
  end

  local nKinId, nMemberId = me.GetKinMember()
  if nKinId == pTong.GetPresidentKin() and nMemberId == pTong.GetPresidentMember() then
    return 1
  else
    return 0
  end
end

-- 获得个人官衔等级
function Tong:GetPersonalOfficialLevel(nTongOfficialLevel, nOfficialRank)
  local pTong = KTong.GetSelfTong()
  if not pTong then
    return ""
  end
  local nSelfLevel = 0
  if nTongOfficialLevel and Tong.OFFICIAL_TABLE[nTongOfficialLevel] and Tong.OFFICIAL_TABLE[nTongOfficialLevel][nOfficialRank] then
    nSelfLevel = Tong.OFFICIAL_TABLE[nTongOfficialLevel][nOfficialRank]
  end
  return nSelfLevel
end

function Tong:StorageFundToKin_C2(szName, szKinName, nFund)
  KTong.ShowTongMsg("<color=white>" .. szName .. "<color>向<color=white>" .. szKinName .. "<color>家族转存帮会资金<color=red>" .. nFund .. "<color>两！")
  me.TongRequest_DelRequest(self.REQUEST_STORAGE_FUND_TO_KIN)
end

function Tong:GetFundFromKin_C2(szKinName, nFund)
  KTong.ShowTongMsg("<color=white>" .. szKinName .. "<color>家族向帮会转存家族资金<color=red>" .. nFund .. "<color>两")
end

function Tong:NotifApplyStorageFund_C2()
  Ui("UI_TASKTIPS"):Begin("您已申请转存资金操作！")
end
