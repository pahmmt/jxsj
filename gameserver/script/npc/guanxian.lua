local tbNpc = Npc:GetClass("guanxian")

function tbNpc:OnDialog()
  Dialog:Say("    在领土争夺战中建树卓越的各帮首领和股东会成员，可在我这进行官衔相关的各项处理事务，以及购买官印。\n    首领的官衔自动获得，与帮会官衔等级相关。\n    股东会成员的官衔由首领通过设置官职来授予。", {
    { "官衔维护", self.DlgOfficialMaintain, self },
    { "申请帮会官衔晋级", self.DlgIncreaseOfficialLevel, self },
    { "调整帮会官衔等级", self.DlgChoseOfficialLevel, self },
    { "官印商店", self.OnOpenShop, self },
    { "结束对话" },
  })
end

function tbNpc:OnOpenShop()
  local nSeries = me.nSeries
  if nSeries == 0 then
    Dialog:Say("请加入门派后再来！")
    return
  end

  if 1 == nSeries then
    me.OpenShop(149, 3)
  elseif 2 == nSeries then
    me.OpenShop(150, 3)
  elseif 3 == nSeries then
    me.OpenShop(151, 3)
  elseif 4 == nSeries then
    me.OpenShop(152, 3)
  elseif 5 == nSeries then
    me.OpenShop(153, 3)
  else
    Dbg:WriteLogEx(Dbg.LOG_INFO, "Npc qianzhuang", me.szName, "There is no Series", nSeries)
  end
end

-- 申请帮会官衔晋级
function tbNpc:DlgIncreaseOfficialLevel(nConfirm)
  local pTong = KTong.GetTong(me.dwTongId)
  if not pTong then
    Dialog:Say("您尚未加入帮会，不能提出官衔相关的申请。")
    return 0
  end

  local nKinId, nMemberId = me.GetKinMember()
  if Tong:CheckPresidentRight(me.dwTongId, nKinId, nMemberId) ~= 1 then
    Dialog:Say("只有首领才有权调整帮会官衔等级。")
    return 0
  end

  local nTongLevel = pTong.GetPreOfficialLevel()
  local nMaxTongLevel = pTong.GetOfficialMaxLevel()
  local nMaxLevelByDomain = Tong:GetMaxLevelByDomain(me.dwTongId)
  local nLevel = nMaxTongLevel + 1
  local nMoney = Tong.TONG_OFFICIAL_LEVEL_CHARGE[nLevel]

  local nIncreaseNo = pTong.GetIncreaseOfficialNo()
  local nCurNo = KGblTask.SCGetDbTaskInt(DBTASK_OFFICIAL_MAINTAIN_NO)
  if nCurNo + 1 == nIncreaseNo then
    Dialog:Say("您的帮会本周已经晋级过了。\n您的帮会已晋升到<color=yellow>" .. nMaxTongLevel .. "<color>级，新等级将在下周一生效。")
    return 0
  end

  local szDialog = "    申请帮会官衔晋级后，下周一开始首领和更多股东会成员能获得更高的官衔。\n    您的帮会已晋升到<color=yellow>" .. nMaxTongLevel .. "<color>级，要晋升到<color=yellow>" .. (nMaxTongLevel + 1) .. "<color>级需要："
  local szCondition1 = "\n    1、占领<color=yellow>" .. Tong.OFFICIAL_LEVEL_CONDITION[nLevel] .. "<color>块领土"
  local szCondition2 = "\n    2、晋级费用：<color=yellow>" .. tostring(nMoney / 10000) .. "万<color>建设资金"

  if not nConfirm or nConfirm ~= 1 then
    Dialog:Say(szDialog .. szCondition1 .. szCondition2 .. "\n\n    您要晋升到下一级吗？", {
      { "确定", self.IncreaseOfficialLevelConfirm, self, nLevel },
      { "返回首页", self.OnDialog, self },
      { "我再考虑一下" },
    })
    return 0
  end

  if nMaxTongLevel == #Tong.OFFICIAL_LEVEL_CONDITION then
    Dialog:Say("您的帮会已经晋升到最高级了。")
    return 0
  elseif nMaxTongLevel >= nMaxLevelByDomain and nMaxTongLevel < #Tong.OFFICIAL_LEVEL_CONDITION then
    Dialog:Say("    您占领的领土数不足。")
    return 0
  end

  if Tong:CanCostedBuildFund(me.dwTongId, nKinId, nMemberId, nMoney, 0) ~= 1 then
    Dialog:Say("    您的帮会还能使用的建设资金不足。")
    return 0
  end

  return GCExcute({ "Tong:IncreaseOfficialLevel_GC", me.dwTongId, nKinId, nMemberId })
end

function tbNpc:IncreaseOfficialLevelConfirm(nLevel)
  local pTong = KTong.GetTong(me.dwTongId)
  if not pTong then
    return 0
  end

  Dialog:Say("    晋级需要消耗" .. Tong.TONG_OFFICIAL_LEVEL_CHARGE[nLevel] .. "帮会建设资金。<color=yellow>晋级后若占领领土数量不足，则帮会官衔等级会自动降低回与领土数对应的水平。<color>\n您确定继续晋级？", {
    { "确定", self.DlgIncreaseOfficialLevel, self, 1 },
    { "返回首页", self.OnDialog, self },
    { "我再考虑一下" },
  })
end

-- 选择帮会官衔水平
function tbNpc:DlgChoseOfficialLevel(nLevel, nConfirm)
  local pTong = KTong.GetTong(me.dwTongId)
  if not pTong then
    Dialog:Say("您尚未加入帮会，不能提出官衔相关的申请。")
    return 0
  end

  local nKinId, nMemberId = me.GetKinMember()
  if Tong:CheckPresidentRight(me.dwTongId, nKinId, nMemberId) ~= 1 then
    Dialog:Say("只有首领才有权调整帮会官衔等级。")
    return 0
  end

  local nMaxTongLevel = pTong.GetOfficialMaxLevel()
  if nMaxTongLevel == 0 then
    Dialog:Say("帮会官衔等级为<color=red>0<color>级，请先晋升帮会官衔等级。")
    return 0
  end

  if not nConfirm or nConfirm ~= 1 then
    local tbOpt = {}
    for i = 0, nMaxTongLevel do
      table.insert(tbOpt, {
        string.format("帮会官衔等级<color=green>%d级<color>", i),
        self.DlgChoseOfficialLevel,
        self,
        i,
        1,
      })
    end
    table.insert(tbOpt, { "返回首页", self.OnDialog, self })
    table.insert(tbOpt, "我再想想")
    Dialog:Say("    首领可以根据帮会实际情况自由选择比当前官衔等级低的任意级别，来控制股东会成员中能获得官衔的人数。\n    当前设置的下周帮会官衔等级为<color=yellow>" .. pTong.GetOfficialLevel() .. "<color>级。您希望将下周帮会官衔等级设置为？", tbOpt)
    return 0
  end

  return GCExcute({ "Tong:ChoseOfficialLevel_GC", me.dwTongId, nKinId, nMemberId, nLevel })
end

-- 个人官衔维护
function tbNpc:DlgOfficialMaintain(nConfirm)
  local pTong = KTong.GetTong(me.dwTongId)
  if not pTong then
    Dialog:Say("您尚未加入帮会，不能提出官衔相关的申请。")
    return 0
  end

  local nKinId, nMemberId = me.GetKinMember()
  if Tong:CanAppointOfficial(me.dwTongId, nKinId, nMemberId) ~= 1 then
    Dialog:Say("只有首领或股东会成员才有机会获得官衔。")
    return 0
  end

  local nTongLevel = pTong.GetPreOfficialLevel()
  if not nTongLevel or nTongLevel == 0 then
    Dialog:Say("帮会官衔等级为<color=red>0<color>级，尚无官衔资格，请先晋升帮会官衔等级。")
    return 0
  end

  local nOfficialRank = Tong:GetOfficialRank(me.dwTongId, nKinId, nMemberId)
  if nOfficialRank == 0 then
    Dialog:Say("您在帮会里尚未拥有官职，无需进行官衔维护。")
    return 0
  end

  local nCurNo = KGblTask.SCGetDbTaskInt(DBTASK_OFFICIAL_MAINTAIN_NO)
  if nCurNo == KGCPlayer.OptGetTask(me.nId, KGCPlayer.TSK_MAINTAIN_OFFICIAL_NO) then
    Dialog:Say("您本周的官衔维护已完成。")
    return 0
  end

  local nPersonalLevel = Tong.OFFICIAL_TABLE[nTongLevel][nOfficialRank]
  if not nPersonalLevel or nPersonalLevel < 1 then
    Dialog:Say("您尚未拥有官衔，无需进行官衔维护。")
    return 0
  end

  local szOfficialTitle = ""
  if Tong.IsPresident(me.dwTongId, nKinId, nMemberId) ~= 0 then
    szOfficialTitle = Tong.OFFICIAL_TITLE[nPersonalLevel]
  else
    szOfficialTitle = Tong.OFFICIAL_TITLE_NP[nPersonalLevel]
  end

  if not nConfirm or nConfirm ~= 1 then
    Dialog:Say("您未完成本周的官衔维护，官衔<color=yellow>" .. szOfficialTitle .. "<color>已被冻结。您确认将<color=yellow>" .. Tong.OFFICIAL_CHARGE[nPersonalLevel] .. "两<color>的个人资产转化为帮会建设资金来解冻你的官衔吗？", {
      { "官衔解冻", self.DlgOfficialMaintain, self, 1 },
      { "返回首页", self.OnDialog, self },
      { "我再考虑一下" },
    })
    return 0
  end
  -- 如果个人资产和股份不足
  local nStockAmount = Tong:CalculateStockCost(me.dwTongId, nKinId, nMemberId, tonumber(Tong.OFFICIAL_CHARGE[nPersonalLevel]))
  if not nStockAmount then
    return 0
  end

  local pKin = KKin.GetKin(nKinId)
  if not pKin then
    return 0
  end
  local pMember = pKin.GetMember(nMemberId)
  if not pMember then
    return 0
  end
  local nPersonalStock = pMember.GetPersonalStock() - nStockAmount
  if nPersonalStock < 0 then
    Dialog:Say("您的个人资产不足，请筹备足够的个人资产后再来申请解冻。")
    return 0
  end

  return GCExcute({ "Tong:OfficialMaintain_GC", me.dwTongId, nKinId, nMemberId })
end
