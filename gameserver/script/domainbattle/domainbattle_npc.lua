--
-- 领土争夺战对话逻辑

-- 领土战期间车夫对话逻辑

local tbXuanZhan = Npc:GetClass("xuanzhan")
function Domain:BattleChefu(nStartNo, nSelMapId)
  nStartNo = nStartNo or 1
  local nCount = 0
  local nMaxNo = nStartNo + 10
  local nState = self:GetBattleState()
  local pTong = KTong.GetTong(me.dwTongId)
  if not pTong then
    Dialog:Say("您没有帮会，不能使用征战车夫功能！")
    return 0
  end
  if nState ~= self.BATTLE_STATE and nState ~= self.PRE_BATTLE_STATE then
    Dialog:Say("目前不是征战期，不能使用征战车夫功能！")
    return 0
  end
  self:CheckTask(me)
  local nMapId = me.GetTask(self.TASK_GROUP_ID, self.CHUANSONG_ID)
  if nMapId == 0 and nSelMapId then
    me.SetTask(self.TASK_GROUP_ID, self.CHUANSONG_ID, nSelMapId)
    Dialog:Say("设置成功！", {
      { "马上送我过去", self.BattleChefu, self },
      { "没什么事了" },
    })
  elseif nMapId == 0 then
    local tbOpt = {}
    local pDomainItor = pTong.GetDomainItor()
    local nCurDomainId = pDomainItor.GetCurDomainId()
    while nCurDomainId and nCurDomainId ~= 0 do
      nCount = nCount + 1
      if nCount >= nStartNo and nCount < nMaxNo then
        local nFightMapId = self:GetDomainFightMap(nCurDomainId)
        local szMapName = GetMapNameFormId(nFightMapId)
        if szMapName ~= "" then
          table.insert(tbOpt, { szMapName, self.BattleChefu, self, nil, nFightMapId })
        end
      elseif nCount >= nMaxNo then
        break
      end
      nCurDomainId = pDomainItor.NextDomainId()
    end
    if nStartNo > 1 then
      table.insert(tbOpt, { "上一页", self.BattleChefu, self, math.max(1, nStartNo - 10) })
    end
    if nCount >= nMaxNo then
      table.insert(tbOpt, { "下一页", self.BattleChefu, self, nMaxNo })
    end
    if #tbOpt > 0 then
      table.insert(tbOpt, { "不用了" })
      Dialog:Say("请选择本次领土争夺战的传送点，<color=red>一旦选择之后本次领土争夺战将无法更改<color>，您只可选择<color=red>您帮会占领的非新手村区域<color>作为传送点，您要选哪个区域作自己的传送点？", tbOpt)
    else
      Dialog:Say("您的帮会目前没有占领领土，不能是使用征战车夫功能！")
    end
  else
    local nDomainId = self:GetMapDomain(nMapId)
    if nDomainId then
      local tbCenter = self:GetCenterRange(nDomainId)
      if tbCenter then
        local nRet, szMsg = Map:CheckTagServerPlayerCount(nMapId)
        if nRet == 1 then
          me.NewWorld(nMapId, tbCenter.nX, tbCenter.nY)
        else
          me.Msg(szMsg)
        end
      end
    end
  end
end

Domain.MAX_OPTIONS = 8 -- 分页显示时一页容纳的选项

-- 奖励Npc响应对话
function Domain:AwardDialog()
  if self:GetBattleState() == self.PRE_BATTLE_STATE or self:GetBattleState() == self.BATTLE_STATE then
    Dialog:Say("宣战期和征战期无法设置奖励和领奖，请您在领土争夺战结束后再来。")
    return 0
  end
  local pTong = KTong.GetTong(me.dwTongId)
  if not pTong then
    Dialog:Say("您未加入帮会，无法使用领土战相关功能。")
    return 0
  end
  Dialog:Say("  每次领土争夺战结束后，您都可以前来领取奖励。您的功勋越高，领取的奖励也会越多。" .. "奖励必须在下一次领土战结束之前来领取，否则就没了。\n  最近一次领土战帮内功勋排名如下：\n<color=green>" .. (pTong.GetDomainResult() or "暂时没有排名结果"), {
    { "领取声望奖励", self.ReciveSystemAward, self, 0 },
    { "领取军饷", self.ReciveTongAward, self, 0, 0 },
    { "设置军饷额度", self.SetTongAward, self, 0, 0 },
    { "奖励说明", self.Award_Intro, self },
    { "返回上一层", tbXuanZhan.OnDialog, tbXuanZhan },
    { "结束对话" },
  })
end

function Domain:DlgJunXu()
  Dialog:Say(
    [[    每次领土争夺战期间，帮会成员都可以前来领取军需。
    如果您想获得更多的军需，需要请帮主在领土战期间（20：00~21：30）前来设置军需额度。设置完后，您将可以在我这领取额外的军需。
    本次领土战的军需如果没有领完，则会在下一次领土战开启宣战期时被清空。
    同时您还可以领取每日免费药品。]],
    {
      { "领取军需", self.FatchJunXu, self },
      { "领取今日免费药品", SpecialEvent.tbMedicine_2012.GetMedicine, SpecialEvent.tbMedicine_2012 },
      { "设置帮会额外军需", self.SetJunXu, self },
      { "返回上一层", tbXuanZhan.OnDialog, tbXuanZhan },
      { "结束对话" },
    }
  )
end

function Domain:CheckDeclareWarRight(nTongId)
  local nSelfKinId, nSelfMemberId = me.GetKinMember()
  local nMasterCheck, cMember = Tong:CheckSelfRight(nTongId, nSelfKinId, nSelfMemberId, Tong.POW_MASTER)
  local nGeneralCheck, cMember = Tong:CheckSelfRight(nTongId, nSelfKinId, nSelfMemberId, Tong.POW_WAR)

  if nGeneralCheck ~= 1 then
    Dialog:Say("您没有宣战权限。")
    return 0
  end
  return 1
end

function Domain:DeclareWar_Confirm(nDomainId, nTongId)
  local tbDlg = {
    { "确定", self.DeclareWar_GS1, self, nDomainId, nTongId },
    { "我再想想" },
  }
  local szDomainName = self:GetDeclareTongNames(nDomainId)
  if szDomainName then
    Dialog:Say("    您确定选择<color=yellow>" .. self:GetDomainName(nDomainId) .. "<color>作为帮会在本次领土战的宣战目标？\n<color=yellow>当前已对该领土宣战的帮会有：\n<color><color=green>" .. szDomainName .. "<color>", tbDlg)
  else
    Dialog:Say("    您确定选择<color=yellow>" .. self:GetDomainName(nDomainId) .. "<color>作为帮会在本次领土战的宣战目标？", tbDlg)
  end
end

-- 选择要宣战的新手村
function Domain:SelectVillageToAttack(nPageStart)
  self:CheckDeclareWarRight(me.dwTongId)
  local nStart = nPageStart or 1
  local tbDlg = {}
  local tbDomain = self:GetDomains()
  local nDomainVersion = self:GetDomainVersion()
  local nPos = 0
  for nDomainId, szDomainName in pairs(tbDomain) do
    if self:GetDomainType(nDomainId) == "village" and self:GetBorderDomains(nDomainVersion, nDomainId) then
      nPos = nPos + 1
      if nPos >= nStart and nPos < nStart + self.MAX_OPTIONS then -- 一页显示几个结果
        if self:GetReputeParam(nDomainId) and self:GetReputeParam(nDomainId) > 0 then
          szDomainName = szDomainName .. "(<color=yellow>" .. self:GetReputeParam(nDomainId) .. "<color>级领土)"
        end
        local tbTmp = { szDomainName, self.DeclareWar_Confirm, self, nDomainId, me.dwTongId }
        table.insert(tbDlg, tbTmp)
      end
    end
  end
  if nPos >= nStart + self.MAX_OPTIONS then
    table.insert(tbDlg, { "下一页", self.ListNativeVillage, self, nStart + self.MAX_OPTIONS })
  end
  table.insert(tbDlg, { "关闭" })

  Dialog:Say("您的帮会现在没有领土，可以选择各新手村领土进行宣战：", tbDlg)
end

-- 选择要宣战的非新手村
function Domain:SelectNonVillageToAttack(nPageStart)
  self:CheckDeclareWarRight(me.dwTongId)
  local nStart = nPageStart or 1
  local tbDlg = {}
  local tbDomain = self:GetDomains()
  local nDomainVersion = self:GetDomainVersion()
  local nPos = 0
  for nDomainId, szDomainName in pairs(tbDomain) do
    if self:GetDomainType(nDomainId) ~= "village" and self:GetDomainOwner(nDomainId) == 0 and self:GetBorderDomains(nDomainVersion, nDomainId) then
      nPos = nPos + 1
      if self:GetReputeParam(nDomainId) and self:GetReputeParam(nDomainId) > 0 then
        szDomainName = szDomainName .. "<color=yellow>(" .. self:GetReputeParam(nDomainId) .. "级)<color>"
      end
      if nPos >= nStart and nPos < nStart + self.MAX_OPTIONS then -- 一页显示几个结果
        local tbTmp = { szDomainName, self.DeclareWar_Confirm, self, nDomainId, me.dwTongId }
        table.insert(tbDlg, tbTmp)
      end
    end
  end
  if nStart > self.MAX_OPTIONS then
    table.insert(tbDlg, { "上一页", self.SelectNonVillageToAttack, self, nStart - self.MAX_OPTIONS })
  end
  if nPos >= nStart + self.MAX_OPTIONS then
    table.insert(tbDlg, { "下一页", self.SelectNonVillageToAttack, self, nStart + self.MAX_OPTIONS })
  end
  table.insert(tbDlg, { "关闭" })

  Dialog:Say("选择您的帮会要宣战的目标领土名称：", tbDlg)
end

-- 宣战对话框
function Domain:DeclareWar_Intro()
  local nState = self:GetBattleState()
  local szSay = [[    每次领土争夺战前半小时（20：00~20：30）为宣战期。
    帮主和具有宣战权限的成员可以在宣战期内选择一块领土作为本次领土战的宣战目标。确定宣战目标后，帮会成员即可在征战期间攻打宣战目标。
    <color=green>攻打新手村和没有被帮会占领的领土时，必须先进行宣战。<color>
    选定本次宣战目标后，只有帮主有权限更换目标。
    
]]

  if nState ~= self.PRE_BATTLE_STATE then
    szSay = szSay .. [[
	<color=yellow>当前尚未到达宣战时间。<color>
		]]
    Dialog:Say(szSay)
    return 0
  end
  local nTongId = me.dwTongId
  local tbToAttack = self:GetDomainToAttack(nTongId)
  local nDelareNum = self:GetConzoneDelareNum(nTongId)
  if nDelareNum > 0 then
    szSay = szSay .. string.format("  <color=gold>你的帮会在合服前已占领了%d块领土，因此此次合服后的第一次领土战中，你的帮会可以<color=green>直接宣战%d块未占领的领土。<color><color>", nDelareNum, nDelareNum)
  end
  if #tbToAttack == 0 then
    szSay = szSay .. [[
		<color=yellow><enter>  您的帮会尚未宣战，请让帮主或宣战权的长老在20：30前确认宣战目标，否则将失去征战权力。<color>
		]]
  else
    local szDeclareInfo = ""
    for i = 1, #tbToAttack do
      local szDomainName = Domain:GetDomainName(tbToAttack[i])
      local nFightMap = self:GetDomainFightMap(tbToAttack[i]) or 0
      local szFightMap = GetMapNameFormId(nFightMap)
      if szDomainName and szFightMap then
        szDeclareInfo = szDeclareInfo .. string.format("\n<color=green>%s领土<color>（争夺地图：<color=gold>%s<color>）", szDomainName, szFightMap)
      end
    end
    szSay = szSay .. "<color=yellow>本次领土战帮会宣战目标为：<color>" .. szDeclareInfo
  end

  local tbOpt = {}
  local nTongId = me.dwTongId
  local nSelfKinId, nSelfMemberId = me.GetKinMember()
  local nGeneralCheck, cMember = Tong:CheckSelfRight(nTongId, nSelfKinId, nSelfMemberId, Tong.POW_WAR)

  if nGeneralCheck == 1 then
    table.insert(tbOpt, { "选择宣战目标", self.SelectDomainToAttack, self })
  end
  table.insert(tbOpt, { "返回上一层", tbXuanZhan.OnDialog, tbXuanZhan })
  table.insert(tbOpt, { "结束对话" })
  Dialog:Say(szSay, tbOpt)
end

-- 设置主城对话框
function Domain:SelectCapital_Intro()
  local szSay = [[    当帮会占有了非新手村领土后，可以选择其中的一块领土作为本帮的主城。拥有主城后，帮会成员在守卫主城时能够获得额外的辅助状态，来提升防守能力。
    主城被其他帮会攻下后，就会失去主城，需要重新设立。同时一旦设立主城后，如果要更换的话，需要支付一定的手续费，因此要慎重决定。
    只有帮主有权力设立和更换主城。
    <color=red>注意：在领土战期间（包括：宣战期、征战期、休战期）都不能更换主城！<color>
]]

  local tbOpt = {
    { "设立或更换本帮的主城", self.SelectCapital, self },
    { "返回上一层", tbXuanZhan.OnDialog, tbXuanZhan },
    { "我再想想" },
  }
  Dialog:Say(szSay, tbOpt)
end

function Domain:SelectDomainToAttack(nPageStart)
  local nStart = nPageStart or 1
  local tbDlg = {}
  local nState = self:GetBattleState()
  if nState ~= self.PRE_BATTLE_STATE then
    Dialog:Say("目前不允许宣战！请在宣战期内（20：00~20：30）前来。")
    return 0
  end

  local pTong = KTong.GetTong(me.dwTongId)
  if pTong == nil then
    Dialog:Say("您未加入帮会，不能参与领土战！")
    return 0
  end
  local nUnionId = pTong.GetBelongUnion()
  if nUnionId ~= 0 and KUnion.GetUnion(nUnionId) then
    local nState = Union:GetUnionDomainDecleaarState(nUnionId)
    if nState < 0 then
      Dialog:Say("您的联盟领土总数大于帮会总数，不能继续入侵其他领土！")
      return 0
    elseif nState == 0 then -- 联盟当前状态只能宣新手村
      self:SelectVillageToAttack()
      return 1
    elseif nState == 1 then -- 联盟当前状态可宣战任意白城
      self:SelectNonVillageToAttack(nPageStart)
      return 1
    end
  else -- 无联盟才有合服补偿
    local nDomainCount = pTong.GetDomainCount()
    local cItor = pTong.GetDomainItor()
    local nDelareNum = self:GetConzoneDelareNum(me.dwTongId)
    if nDomainCount == 0 and nDelareNum == 0 then -- 没有领土并且没有合服补偿，选择新手村宣战
      self:SelectVillageToAttack()
      return 1
    elseif nDelareNum > 0 then -- 有合服补偿，可宣战任意地图
      self:SelectNonVillageToAttack(nPageStart)
      return 1
    end
    if nDomainCount == 1 and cItor then
      local nIdTmp = cItor.GetCurDomainId()
      if self:GetDomainType(nIdTmp) == "village" then -- 只占有新手村
        self:SelectNonVillageToAttack(nPageStart)
        return 1
      end
    end
  end
  local tbAdjacency = self:GetAdjacency(me.dwTongId)
  local nPos = 0
  if tbAdjacency then
    for nDomainId, nOwnerTongId in pairs(tbAdjacency) do
      if (nOwnerTongId == nil or nOwnerTongId == 0) and self:GetDomainType(nDomainId) ~= "village" then
        nPos = nPos + 1
        if nPos >= nStart and nPos < nStart + self.MAX_OPTIONS then -- 一页显示几个结果
          local szDomainName = self:GetDomainName(nDomainId)
          if self:GetReputeParam(nDomainId) and self:GetReputeParam(nDomainId) > 0 then
            szDomainName = szDomainName .. "<color=yellow>(" .. self:GetReputeParam(nDomainId) .. "级)<color>"
          end
          local tbTmp = { szDomainName, self.DeclareWar_Confirm, self, nDomainId, me.dwTongId }
          table.insert(tbDlg, tbTmp)
        end
      end
    end
  end
  if nStart > self.MAX_OPTIONS then
    table.insert(tbDlg, { "上一页", self.SelectDomainToAttack, self, nStart - self.MAX_OPTIONS })
  end
  if nPos >= nStart + self.MAX_OPTIONS then
    table.insert(tbDlg, { "下一页", self.SelectDomainToAttack, self, nStart + self.MAX_OPTIONS })
  end
  if #tbDlg > 0 then
    table.insert(tbDlg, { "关闭" })
    Dialog:Say("相邻且被其他帮会占领的领土无需宣战即可攻打。目前您的帮会可以宣战的领土有：", tbDlg)
  else
    Dialog:Say("相邻且被其他帮会占领的领土无需宣战即可攻打。目前您的帮会没有可以宣战的领土。")
  end
end

-- 选择主城
function Domain:SelectCapital(nPageStart)
  local nStart = nPageStart or 1
  local tbDlg = {}
  local cTong = KTong.GetTong(me.dwTongId)
  if cTong == nil then
    Dialog:Say("您未加入帮会，不能使用领土战功能。")
    return 0
  end
  if self:GetBattleState() ~= self.NO_BATTLE then
    Dialog:Say("领土争夺战已开始，不允许更换主城。")
    return 0
  end
  local nSelfKinId, nSelfMemberId = me.GetKinMember()
  local nMasterCheck, cMember = Tong:CheckSelfRight(me.dwTongId, nSelfKinId, nSelfMemberId, Tong.POW_MASTER)
  if nMasterCheck ~= 1 then
    Dialog:Say("只有帮主才能设立或更换主城。")
    return 0
  end

  if cTong.GetDomainCount() == 0 then
    Dialog:Say("您的帮会没有任何领土，有了地盘再来吧。")
    return 0
  end

  local nPos = 0
  local cItor = cTong.GetDomainItor()
  for i = 1, cTong.GetDomainCount() do
    local nDomainId = cItor.GetCurDomainId()
    nPos = nPos + 1
    if nPos >= nStart and nPos < nStart + self.MAX_OPTIONS then -- 一页显示几个结果
      local tbTmp = { self:GetDomainName(nDomainId), Tong.SetCapital_GS1, Tong, me.dwTongId, nDomainId }
      table.insert(tbDlg, tbTmp)
    end
    cItor.NextDomain()
  end
  if nPos >= nStart + self.MAX_OPTIONS then
    table.insert(tbDlg, { "下一页", self.SelectCapital, self, nStart + self.MAX_OPTIONS })
  end
  table.insert(tbDlg, { "关闭" })

  local nCapital = cTong.GetCapital()
  if nCapital == 0 then
    Dialog:Say("您的帮会当前还没有设立主城。\n请选择您要设立为主城的领土名称。", tbDlg)
  else
    Dialog:Say("您的帮会当前设立的主城为<color=green>" .. self:GetDomainName(nCapital) .. "<color>。\n请选择您要更换为主城的领土名称。", tbDlg)
  end
end

-- 设置军需
function Domain:SetJunXu(nType, nLevel, nNum, nConfirm)
  local nTongId = me.dwTongId
  local nSelfKinId, nSelfMemberId = me.GetKinMember()
  local nMasterCheck, cMember = Tong:CheckSelfRight(nTongId, nSelfKinId, nSelfMemberId, Tong.POW_MASTER)
  local nCurState = self:GetBattleState()
  if nMasterCheck ~= 1 then
    Dialog:Say("只有帮主才能设置军需额度。")
    return 0
  end
  if nCurState ~= self.PRE_BATTLE_STATE and nCurState ~= self.BATTLE_STATE then
    Dialog:Say("只有宣战期或征战期（20：00~21；30）才能设置军需额度。")
    return 0
  end

  local pTong = KTong.GetTong(me.dwTongId)
  local nJunXuNo = pTong.GetDomainJunXunNo()
  local nCurNo = KGblTask.SCGetDbTaskInt(DBTASK_DOMAIN_BATTLE_NO)
  local nMedicineLevel = self:GetMedicineLevel(pTong.GetDomainJunXunType())
  local nHelpfulLevel = self:GetHelpfulLevel(pTong.GetDomainJunXunType())
  if nJunXuNo == nCurNo and nMedicineLevel > 0 and nHelpfulLevel > 0 then
    Dialog:Say("您的帮会已经设置过本次领土战的军需额度了。")
    return 0
  end

  -- 选择要设置的军需
  if not nType then
    self:SelectSetType()
    return 0
  end

  if nType == self.JUNXU_HELPFUL and not nNum and not nConfirm then
    local tbDlg = {}
    local szMsg = ""
    if nLevel == 1 then
      szMsg = "<color=yellow>行军丹（小）<color>单价：\n    <color=yellow>10万<color>两/个。\n\n    建设资金在帮会成员领取军需的时候扣除。购买了行军丹（小）后，本次领土战<color=red>将无法再购买<color>行军丹（中）。\n"
    else
      szMsg = "<color=yellow>行军丹（中）<color>单价：\n    <color=yellow>40万<color>两/个。\n\n    建设资金在帮会成员领取军需的时候扣除。购买了行军丹（中）后，本次领土战<color=red>将无法再购买<color>行军丹（小）。\n"
    end
    table.insert(tbDlg, { "每人<color=green>1<color>个", self.SetJunXu, self, nType, nLevel, self.JUNXU_HELPFUL_MAX_NUM })
    table.insert(tbDlg, { "我再想想。" })
    Dialog:Say(szMsg, tbDlg)
    return 0
  end

  -- 确认
  if not nConfirm or nConfirm ~= 1 then
    local szTypeName = self.JUNXU_NAME[nType][nLevel]
    local szPrice = ""
    if nType == self.JUNXU_MEDICINE and nLevel == 1 then
      szPrice = "每箱军需需要花费<color=yellow>3000<color>帮会建设资金。"
    elseif nType == self.JUNXU_MEDICINE and nLevel == 2 then
      szPrice = "每箱军需需要花费<color=yellow>8万<color>帮会建设资金。"
    elseif nType == self.JUNXU_HELPFUL and nLevel == 1 then
      szPrice = "每箱军需需要花费<color=yellow>10万<color>帮会建设资金。"
    elseif nType == self.JUNXU_HELPFUL and nLevel == 1 then
      szPrice = "每箱军需需要花费<color=yellow>40万<color>帮会建设资金。"
    end
    Dialog:Say("设定每人" .. szTypeName .. "<color=green>额外" .. nNum .. "箱<color>军需，" .. szPrice .. "是否确定？", {
      { "确定", self.SetJunXu, self, nType, nLevel, nNum, 1 },
      { "结束对话" },
    })
    return 0
  end
  GCExcute({ "Domain:SetJunXu_GC", nTongId, nType, nLevel, nNum })
end

-- 选择设置军需的类型
function Domain:SelectSetType(nType, nLevel)
  local pTong = KTong.GetTong(me.dwTongId)
  local nJunXuNo = pTong.GetDomainJunXunNo()
  local nCurNo = KGblTask.SCGetDbTaskInt(DBTASK_DOMAIN_BATTLE_NO)
  local nMedicineLevel = self:GetMedicineLevel(pTong.GetDomainJunXunType())
  local nHelpfulLevel = self:GetHelpfulLevel(pTong.GetDomainJunXunType())
  if not nType then
    local tbDlg = {}
    if nJunXuNo ~= nCurNo or nMedicineLevel == 0 then
      table.insert(tbDlg, { "中级药（箱），回复血、内", self.SelectSetType, self, self.JUNXU_MEDICINE, 1 })
      table.insert(tbDlg, { "高级药（箱），大量回复血、内", self.SelectSetType, self, self.JUNXU_MEDICINE, 2 })
    end
    if nJunXuNo ~= nCurNo or nHelpfulLevel == 0 then
      table.insert(tbDlg, { "行军丹（小），提高攻击力、血量上限、抗性", self.SetJunXu, self, self.JUNXU_HELPFUL, 1 })
      table.insert(tbDlg, { "行军丹（中），大幅提高攻击力、血量上限、抗性", self.SetJunXu, self, self.JUNXU_HELPFUL, 2 })
    end
    table.insert(tbDlg, { "我再想想。" })
    Dialog:Say("    我这里提供了多种不同的军需：\n", tbDlg)
    return 0
  end
  if nLevel then
    local tbDlg = {}
    local szMsg = ""
    if nLevel == 1 then
      szMsg = "<color=yellow>中级药<color>单价：\n    <color=yellow>3000<color>两/箱。\n\n    建设资金在帮会成员领取军需时逐箱扣除。购买了中级药后，本次领土战<color=red>将无法再购买<color>高级药。您想让帮会成员每人能领取多少箱？\n"
    else
      szMsg = "<color=yellow>高级药<color>单价：\n    <color=yellow>8万<color>两/箱。\n\n    建设资金在帮会成员领取军需时逐箱扣除。购买了高级药后，本次领土战<color=red>将无法再购买<color>中级药。您想让帮会成员每人能领取多少箱？\n"
    end
    for i = 1, self.JUNXU_MEDICINE_MAX_NUM do
      table.insert(tbDlg, { "每人<color=green>" .. i .. "<color>箱", self.SetJunXu, self, nType, nLevel, i })
    end
    table.insert(tbDlg, { "我再想想。" })
    Dialog:Say(szMsg, tbDlg)
    return 0
  end

  return 0
end

-- 领取军需
function Domain:FatchJunXu(nType, nParticular, nConfirm, nLevel)
  local pTong = KTong.GetTong(me.dwTongId)
  if not pTong then
    Dialog:Say("您未加入帮会，不能使用领土战功能！")
    return 0
  end

  local nCurState = self:GetBattleState()
  if nCurState ~= self.PRE_BATTLE_STATE and nCurState ~= self.BATTLE_STATE then
    Dialog:Say("只有宣战期或征战期（20：00~21；30）才能领取军需。")
    return 0
  end

  local nKinId, nMemberId = me.GetKinMember()
  if Kin:HaveFigure(nKinId, nMemberId, Kin.FIGURE_REGULAR) ~= 1 then
    Dialog:Say("您不是正式帮众，不能参加领土争夺战，贵帮主在我这里配备的军需没有您的配额！")
    return 0
  end

  local nCurNo = KGblTask.SCGetDbTaskInt(DBTASK_DOMAIN_BATTLE_NO)
  local nJunXuNo = pTong.GetDomainJunXunNo()
  local nSelfNum = me.GetTask(self.TASK_GROUP_ID, self.JUNXU_NUM)
  local nSelfMedicineNo = me.GetTask(self.TASK_GROUP_ID, self.JUNXU_MEDICINE_NO)
  -- 如果这场没领过，清空上次的记录。
  if nSelfMedicineNo ~= nCurNo then
    nSelfNum = 0
  end
  local nMedicineMoney = 0
  local nMedicineNum = 0
  local nMedicineLevel = self:GetMedicineLevel(pTong.GetDomainJunXunType())
  -- 如果设置了药
  if nMedicineLevel > 0 and nJunXuNo == nCurNo then
    nMedicineNum = pTong.GetDomainJunXunMedicineNum()
    nMedicineMoney = self.JUNXU_MEDICINE_PRICE[nMedicineLevel] * nMedicineNum
  end

  local nSelfHelpfulNo = me.GetTask(self.TASK_GROUP_ID, self.JUNXU_HELPFUL_NO)
  local nHelpfulMoney = 0
  local nHelpfulNum = 0
  local nHelpfulLevel = self:GetHelpfulLevel(pTong.GetDomainJunXunType())
  -- 如果设置了辅助
  if nHelpfulLevel > 0 and nJunXuNo == nCurNo then
    nHelpfulMoney = self.JUNXU_HELPFUL_PRICE[nHelpfulLevel]
    nHelpfulNum = self.JUNXU_HELPFUL_MAX_NUM
  end

  local nJunXuNum = nMedicineNum + self.DEFAULT_JUNXU

  if nSelfMedicineNo == nCurNo and nSelfHelpfulNo == nCurNo and nJunXuNum == nSelfNum then
    Dialog:Say("您已经领取过全部的军需了。")
    return 0
  end

  if not nType then
    local szMsg = "您当前还可以领取：\n"
    local tbOpt = {}

    if nSelfNum < self.DEFAULT_JUNXU then
      szMsg = szMsg .. "免费的中级药<color=green>" .. self.DEFAULT_JUNXU .. "<color>箱\n"
      if nMedicineLevel > 0 then
        szMsg = szMsg .. "额外的" .. self.JUNXU_NAME[self.JUNXU_MEDICINE][nMedicineLevel] .. "<color=green>" .. nMedicineNum .. "<color>箱\n"
      end
      table.insert(tbOpt, { "领取免费的药", self.FatchJunXu, self, self.JUNXU_MEDICINE })
    end
    if nSelfNum < nJunXuNum and nSelfNum >= self.DEFAULT_JUNXU and nJunXuNo == nCurNo then
      szMsg = szMsg .. "额外的" .. self.JUNXU_NAME[self.JUNXU_MEDICINE][nMedicineLevel] .. "<color=green>" .. nJunXuNum - nSelfNum .. "<color>箱\n"
      table.insert(tbOpt, { "领取药", self.FatchJunXu, self, self.JUNXU_MEDICINE })
    end
    if nHelpfulMoney > 0 and nSelfHelpfulNo ~= nCurNo and nJunXuNo == nCurNo then
      szMsg = szMsg .. self.JUNXU_NAME[self.JUNXU_HELPFUL][nHelpfulLevel] .. "<color=green>" .. nHelpfulNum .. "<color>个\n"
      table.insert(tbOpt, { "领取行军丹", self.FatchJunXu, self, self.JUNXU_HELPFUL, self.JUNXU_HELPFUL_PARTICULAR[nHelpfulLevel] })
    end
    if #tbOpt == 0 then
      szMsg = "    若要领取更多军需，需首领设定额外的军需。"
      table.insert(tbOpt, { "结束对话" })
    else
      table.insert(tbOpt, { "暂时不领" })
    end
    Dialog:Say(szMsg, tbOpt)
    return 0
  end

  if not nParticular then
    local szMsg = "您想领取：\n"
    local szSize = ""
    if nMedicineLevel == 1 or nSelfNum < self.DEFAULT_JUNXU then
      szSize = "(中)"
    else
      szSize = "(大)"
    end

    local tbOpt = {
      { "领取回血丹" .. szSize, self.FatchJunXu, self, self.JUNXU_MEDICINE, self.JUNXU_MEDICINE_PARTICULAR[1] },
      { "领取回内丹" .. szSize, self.FatchJunXu, self, self.JUNXU_MEDICINE, self.JUNXU_MEDICINE_PARTICULAR[2] },
      { "领取乾坤造化丸" .. szSize, self.FatchJunXu, self, self.JUNXU_MEDICINE, self.JUNXU_MEDICINE_PARTICULAR[3] },
      { "结束对话" },
    }
    Dialog:Say(szMsg, tbOpt)
    return 0
  end

  if not nConfirm then
    local nLevel = 0
    if nType == self.JUNXU_MEDICINE and nSelfNum >= self.DEFAULT_JUNXU then
      nLevel = nMedicineLevel
    elseif nType == self.JUNXU_MEDICINE and nSelfNum < self.DEFAULT_JUNXU then
      nLevel = 1
    elseif nType == self.JUNXU_HELPFUL then
      nLevel = nHelpfulLevel
    end

    local szName = ""
    if nType == self.JUNXU_MEDICINE then
      szName = self.JUNXU_NAME[nType][nLevel] .. " " .. self.JUNXU_MEDICINE_NAME[self.JUNXU_MEDICINE][nParticular]
    else
      szName = self.JUNXU_NAME[nType][nLevel]
    end

    local szMsg = "您确认领取：" .. szName .. "吗？\n"
    local tbOpt = {}
    if nType == self.JUNXU_MEDICINE then
      tbOpt = {
        { "确认领取", self.FatchJunXu, self, nType, nParticular, 1, nLevel },
        { "暂时不领" },
      }
    else
      tbOpt = {
        { "确认领取", self.FatchJunXu, self, nType, nParticular, 1, nLevel },
        { "暂时不领" },
      }
    end
    Dialog:Say(szMsg, tbOpt)
    return 0
  end

  if me.CountFreeBagCell() < 1 then
    Dialog:Say("您的背包已经满了，请清出足够空间再来领取！")
    return 0
  end

  local nJunXuMoney = 0
  local nSelfNo = 0
  if nType == self.JUNXU_MEDICINE then
    nSelfNo = self.JUNXU_MEDICINE_NO
    nJunXuMoney = self.JUNXU_MEDICINE_PRICE[nLevel]
    -- 第一个免费
    --if nSelfNum == 0 then
    --	me.SetTask(self.TASK_GROUP_ID, nSelfNo, nCurNo);
    --	me.SetTask(self.TASK_GROUP_ID, self.JUNXU_NUM, nSelfNum + 1);
    --	return Domain:FatchJunXu_GS2(me.dwTongId, me.nId, self.JUNXU_MEDICINE, nParticular, nLevel, 1, 0);
    --end
    -- 如果不是第1个，检测够不够钱
    if nMedicineMoney > 0 and Tong:CanCostedBuildFund(me.dwTongId, 0, 0, nJunXuMoney, 0) ~= 1 then
      Dialog:Say("    您帮会本周消耗的建设资金已经达到上限，不能领取军需，请让帮会的<color=yellow>首领<color>设置更高的周使用上限！")
      return 0
    end
    me.SetTask(self.TASK_GROUP_ID, nSelfNo, nCurNo)
    me.SetTask(self.TASK_GROUP_ID, self.JUNXU_NUM, nSelfNum + 1)
    return GCExcute({ "Domain:FatchJunXu_GC", me.dwTongId, me.nId, nType, nParticular, nLevel })
  elseif nType == self.JUNXU_HELPFUL then
    nSelfNo = self.JUNXU_HELPFUL_NO
    nJunXuMoney = self.JUNXU_HELPFUL_PRICE[nLevel]
    if nHelpfulMoney > 0 and Tong:CanCostedBuildFund(me.dwTongId, 0, 0, nJunXuMoney, 0) ~= 1 then
      Dialog:Say("    您帮会本周消耗的建设资金已经达到上限，不能领取军需，请让帮会的<color=yellow>首领<color>设置更高的周使用上限！")
      return 0
    end
    me.SetTask(self.TASK_GROUP_ID, nSelfNo, nCurNo)
    return GCExcute({ "Domain:FatchJunXu_GC", me.dwTongId, me.nId, nType, nParticular, nLevel })
  end
end

function Domain:Award_Intro(nType)
  local szMsg = "您需要我为您解答说明些什么呢？"
  local tbOpt = {}
  if nType == 1 then
    szMsg = [[
    领土争夺战的宝箱可以随机开出各种材料。
    在领土战官员处可以购买到各种材料的制作图纸，使用后可以学会材料的加工和制造方法。
    材料只有经过加工、制造两道工序后，才能变成增加声望的道具。
    声望达到一定等级可购买不同的炼化图纸，再配以相应装备可以炼化出更具强力属性的套装。
]]
    table.insert(tbOpt, { "返回上一层", self.Award_Intro, self })
  elseif nType == 2 then
    szMsg = [[    每次领土战获得的<color=green>个人功勋级别<color>，以及所在帮会攻占的<color=green>领土数量<color>，将决定奖励的宝箱数量。因此，获得更多宝箱的途径有：
1、获得更多的功勋，提升在帮会中的功勋排名；
2、整体提升帮会实力，攻占更多的领土。
    特别地，个人功勋级别比帮会领土数量更重要，所以在一块领土数量较少的帮会取得较高个人功勋级别的角色，可能要比在一块领土数量很多的帮会但取得较低个人功勋级别的角色获得更多的宝箱。
]]
    table.insert(tbOpt, { "返回上一层", self.Award_Intro, self })
  else
    table.insert(tbOpt, { "宝箱用途", self.Award_Intro, self, 1 })
    table.insert(tbOpt, { "如何获得更多的宝箱", self.Award_Intro, self, 2 })
    table.insert(tbOpt, { "返回上一层", self.AwardDialog, self })
  end
  Dialog:Say(szMsg, tbOpt)
end

-- 设置过药
function Domain:HasSetMedicine(nTongId)
  local pTong = KTong.GetTong(nTongId)
  if not pTong then
    return 0
  end
  local nLevel = self:GetMedicineLevel(pTong.GetDomainJunXunType())
  local nJunXuNo = pTong.GetDomainJunXunNo()
  local nCurNo = KGblTask.SCGetDbTaskInt(DBTASK_DOMAIN_BATTLE_NO)
  if nCurNo == nJunXuNo and nLevel > 0 then
    return 1
  end
end

-- 设置过辅助
function Domain:HasSetHelpful(nTongId)
  local pTong = KTong.GetTong(nTongId)
  if not pTong then
    return 0
  end
  local nLevel = self:GetHelpfulLevel(pTong.GetDomainJunXunType())
  local nJunXuNo = pTong.GetDomainJunXunNo()
  local nCurNo = KGblTask.SCGetDbTaskInt(DBTASK_DOMAIN_BATTLE_NO)
  if nCurNo == nJunXuNo and nLevel > 0 then
    return 1
  end
end
