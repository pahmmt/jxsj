-- 文件名　：yuelao.lua
-- 创建者　：furuilei
-- 创建时间：2009-12-07 11:08:45
-- 功能描述：结婚npc，月老

local tbNpc = Npc:GetClass("marry_yuelao")
--==========================================================

tbNpc.LEVEL_PINGMIN = 1 -- 平民
tbNpc.LEVEL_GUIZU = 2 -- 贵族
tbNpc.LEVEL_WANGHOU = 3 -- 王侯
tbNpc.LEVEL_HUANGJIA = 4 -- 皇家

tbNpc.MINLEVEL_APPWEDDING = 69 -- 求婚的最低等级要求

tbNpc.MONEY_BASE = 200000 -- 首次修改婚期需要上缴费用20W
tbNpc.RETE = 5 -- 每次修改，需要缴纳费用是上次的5倍

tbNpc.tbLibaoGDPL = { "18-1-603-1", "18-1-603-2", "18-1-603-3", "18-1-603-4", "18-1-594-1", "18-1-594-2", "18-1-594-3", "18-1-594-4" }

tbNpc.tbWeddingInfo = {
  [tbNpc.LEVEL_PINGMIN] = { szName = "侠士" },
  [tbNpc.LEVEL_GUIZU] = { szName = "贵族" },
  [tbNpc.LEVEL_WANGHOU] = { szName = "王侯" },
  [tbNpc.LEVEL_HUANGJIA] = { szName = "皇家" },
}

--==========================================================

function tbNpc:OnDialog()
  if Marry:CheckState() == 0 then
    return 0
  end
  local szMsg = "关关雎鸠，在河之洲。窈窕淑女，君子好逑。这位大侠，看得出：你即使身在江湖，也有同心上人共度一生的美好愿望啊！"
  local tbOpt = {}
  table.insert(tbOpt, { "<color=yellow>参加典礼<color>", Marry.SelectServer, Marry })
  table.insert(tbOpt, { "预定典礼", self.AppWeddingDlg, self })
  table.insert(tbOpt, { "参观典礼场地", self.PreViewWeddingPlaceDlg, self })
  table.insert(tbOpt, { "典礼信息查询", self.QueryWeddingInfoDlg, self })
  table.insert(tbOpt, { "领取侠侣信物", self.GetWeddingRing, self })
  table.insert(tbOpt, { "修复侠侣关系", self.XiufuCoupleRelationDlg, self })
  table.insert(tbOpt, { "补领侠侣称号", self.GetCoupleTitleDlg, self })
  table.insert(tbOpt, "结束对话")
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:QueryWeddingInfoDlg()
  local szMsg = "你可以查询自己或者他人的信息。"
  local tbOpt = {
    { "查询自己的典礼信息", self.QueryMyWeddingInfo, self },
    { "查询他人的典礼信息", self.QueryOthersWeddingInfo, self },
    { "按日期查询典礼信息", self.QuerySpedayWedingInfo, self },
    { "返回上一层", self.OnDialog, self },
  }
  Dialog:Say(szMsg, tbOpt)
end

-- 查询自己的婚礼信息
function tbNpc:QueryMyWeddingInfo()
  Marry:QueryWedding(1, me.szName)
end

-- 查询他人的婚礼信息
function tbNpc:QueryOthersWeddingInfo()
  Dialog:AskString("玩家角色名", 16, self.OnAcceptSpeMsg, self)
end

function tbNpc:OnAcceptSpeMsg(szPlayerName)
  local nLen = GetNameShowLen(szPlayerName)
  if nLen <= 0 or nLen > 32 then
    Dialog:Say("输入的名字超出限制，请重新输入")
    return
  end
  Marry:QueryWedding(1, szPlayerName)
end

-- 查找指定日期的婚礼信息
function tbNpc:QuerySpedayWedingInfo()
  local szMsg = "你可以在如下日期中选择你要查询哪天的典礼信息。"
  local tbOpt = self:GetQueryDate()
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:GetQueryDate()
  local nCurTime = GetTime()
  local tbOpt = {}
  for i = 0, 6 do
    local nTime = nCurTime + i * 3600 * 24
    local nDate = tonumber(os.date("%Y%m%d", nTime))
    local szDate = tostring(os.date("%Y-%m-%d", nTime))
    table.insert(tbOpt, { szDate, self.QueryByDate, self, nDate })
  end
  return tbOpt
end

function tbNpc:QueryByDate(nDate)
  Marry:QueryWedding(2, nDate)
end

function tbNpc:CheckLevel(nLevel)
  if not nLevel then
    return 0
  end
  if nLevel < self.LEVEL_PINGMIN or nLevel > self.LEVEL_HUANGJIA then
    return 0
  end

  return 1
end

--=====================================================================

function tbNpc:CanXiufuCoupleRelation()
  local szErrMsg = ""

  local bHasPreWedding, szCoupleName, nPreWeddingDate, nWeddingLevel = Marry:CheckPreWedding(me.szName)
  if 0 == bHasPreWedding then
    szErrMsg = "你还没有举办典礼，不能修复关系。"
    return 0, szErrMsg
  end

  local tblMemberList, nMemberCount = me.GetTeamMemberList()
  if nMemberCount ~= 2 then
    szErrMsg = "修复侠侣关系，需要两人组队才行。"
    return 0, szErrMsg
  end

  local cTeamMate = tblMemberList[1]
  for _, pPlayer in pairs(tblMemberList) do
    if pPlayer.szName ~= me.szName then
      cTeamMate = pPlayer
      break
    end
  end

  if me.IsMarried() == 1 or cTeamMate.IsMarried() == 1 then
    szErrMsg = "你已经有侠侣关系了，不能来修复关系"
    return 0, szErrMsg
  end

  local bHasPreWedding, szCoupleName, nPreWeddingDate, nWeddingLevel = Marry:CheckPreWedding(me.szName)
  if szCoupleName ~= cTeamMate.szName then
    szErrMsg = "你的队友不是你的心上人。"
    return 0, szErrMsg
  end

  local nCurDate = tonumber(os.date("%Y%m%d", GetTime()))
  local nCurHour = tonumber(os.date("%H", GetTime()))
  if nCurDate <= nPreWeddingDate or (nCurDate == nPreWeddingDate + 1 and nCurHour < 7) then
    szErrMsg = "典礼还没有结束，你们可以通过正常的典礼流程来结为侠侣，不用来我这里修复。"
    return 0, szErrMsg
  end

  if me.IsAccountLock() ~= 0 or cTeamMate.IsAccountLock() ~= 0 then
    szErrMsg = "你们的账号处于锁定状态，不能来修复关系"
    return 0, szErrMsg
  end

  return 1
end

function tbNpc:XiufuCoupleRelationDlg()
  local nRet, _, nPreDate = Marry:CheckPreWedding(me.szName)
  if nRet == 1 then
    if nPreDate < 20100601 then
      Dialog:Say("对不起，请您重新选择婚礼日期。")
      return 0
    end
  end

  local bCanOpt, szErrMsg = self:CanXiufuCoupleRelation()
  if 0 == bCanOpt then
    if szErrMsg ~= "" then
      Dialog:Say(szErrMsg)
    end
    return 0
  end

  local szMsg = "如果预定了典礼，但是因为某些原因未能及时参加，导致没有参加典礼的话，可以通过这个选项来补上侠侣关系。"

  local tblMemberList, nMemberCount = me.GetTeamMemberList()
  if nMemberCount ~= 2 then
    return 0
  end

  local tbOpt = {
    { "现在就修复", self.XiufuCoupleRelation, self, tblMemberList[1].szName, tblMemberList[2].szName },
    { "以后再说吧" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:XiufuCoupleRelation(szName1, szName2)
  local pMale = KPlayer.GetPlayerByName(szName1)
  local pFemale = KPlayer.GetPlayerByName(szName2)
  if not pMale or not pFemale then
    return 0
  end
  if pMale.nSex == 1 then
    pMale, pFemale = pFemale, pMale
  end
  Relation:AddRelation_GS(pMale.szName, pFemale.szName, Player.emKPLAYERRELATION_TYPE_COUPLE, 1)
  pMale.Msg("你们的关系已经修复，现在已经是侠侣了。")
  pFemale.Msg("你们的关系已经修复，现在已经是侠侣了。")

  Marry:SetTitle(pMale, pFemale)

  local szLog = string.format("%s 与 %s 修复侠侣关系", pMale.szName, pFemale.szName)
  Dbg:WriteLog("Marry", "结婚系统", szLog)

  pMale.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, string.format("与 %s 修复为夫妻", pFemale.szName))
  pFemale.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, string.format("与 %s 修复为夫妻", pMale.szName))
end

--=====================================================================

function tbNpc:GetWeddingRing()
  --	if (0 ~= me.GetTask(Marry.TASK_GROUP_ID, Marry.TASK_GET_WEDDING_RING)) then
  --		Dialog:Say("你已经领取过侠侣信物了，不要重复领取。");
  --		return 0;
  --	end

  local szCoupleName = me.GetCoupleName()
  if not szCoupleName or szCoupleName == "" then
    Dialog:Say("你们还是成为侠侣后再来领侠侣信物吧。")
    return 0
  end

  local nWeddingLevel = me.GetTask(Marry.TASK_GROUP_ID, Marry.TASK_WEDDING_LEVEL)
  if nWeddingLevel <= 0 or nWeddingLevel > 4 then
    return 0
  end

  if me.CountFreeBagCell() < 1 then
    Dialog:Say("您的背包空间不足，整理出1格背包空间，再来领取吧。")
    return 0
  end

  local pItem = me.AddItem(18, 1, 595, nWeddingLevel)
  if pItem then
    pItem.SetCustom(Item.CUSTOM_TYPE_EVENT, szCoupleName)
    --		me.SetTask(Marry.TASK_GROUP_ID, Marry.TASK_GET_WEDDING_RING, 1);

    Dbg:WriteLog("Marry", "结婚系统", me.szAccount, me.szName, "领取了结婚戒指")
  end
end

function tbNpc:PreViewWeddingPlaceDlg()
  local tbNpc = Npc:GetClass("marry_yuelao2")
  tbNpc:OnDialog()
end

-- 前往指定地图参观婚礼场地
function tbNpc:PreViewWeddingPlace(nLevel)
  if 0 == self:CheckLevel(nLevel) then
    return 0
  end

  local tbMap = Marry.MAP_PREVIEW_INFO[nLevel]
  if tbMap then
    me.NewWorld(unpack(tbMap))
  end
end

function tbNpc:CheckWeddingCond(nLevel)
  if 0 == self:CheckLevel(nLevel) then
    return 0
  end

  local szErrMsg = ""
  local tblMemberList, nMemberCount = me.GetTeamMemberList()
  if 2 ~= nMemberCount then
    szErrMsg = "这等大事，岂能儿戏。请男女两人组队再来预订。"
    return 0, szErrMsg
  end
  local cTeamMate = tblMemberList[1]
  for i = 1, #tblMemberList do
    if tblMemberList[i].szName ~= me.szName then
      cTeamMate = tblMemberList[i]
    end
  end

  if me.nLevel < self.MINLEVEL_APPWEDDING or cTeamMate.nLevel < self.MINLEVEL_APPWEDDING then
    szErrMsg = string.format("需要双方的等级都达到<color=yellow>%s<color>级。", self.MINLEVEL_APPWEDDING)
    return 0, szErrMsg
  end

  if me.nSex ~= 0 or cTeamMate.nSex ~= 1 then
    szErrMsg = "让男方来确定你们大喜的日子吧，你只需在旁静待片刻。"
    return 0, szErrMsg
  end

  if 1 == me.IsMarried() or 1 == cTeamMate.IsMarried() then
    szErrMsg = "没搞错吧，已经有了知己的人还来做什么？！"
    return 0, szErrMsg
  end

  local bIsNearby = 0
  local tbPlayerList = KPlayer.GetAroundPlayerList(me.nId, 50)
  if tbPlayerList then
    for _, pPlayer in ipairs(tbPlayerList) do
      if pPlayer.szName == cTeamMate.szName then
        bIsNearby = 1
      end
    end
  end
  if 0 == bIsNearby then
    szErrMsg = "你的心上人怎么走远了？靠近我一点！"
    return 0, szErrMsg
  end

  local nReSelectTime = me.GetTask(Marry.TASK_GROUP_ID, Marry.TASK_TIME_RESELECTDATE)
  if nReSelectTime > 0 then
    local nNeedMoney = self.MONEY_BASE * nReSelectTime
    if me.nCashMoney < nNeedMoney then
      szErrMsg = string.format("您目前是第<color=yellow>%s<color>次修改典礼日期，需要缴纳手续费<color=yellow>%s<color>，你还是带够钱再来吧。", nReSelectTime, nNeedMoney)
      return 0, szErrMsg
    end
  end

  if Marry:CheckQiuhun(me, cTeamMate) ~= 1 then
    szErrMsg = "请先向你心上人纳吉后，再来找我吧！请其中一方先在典礼商人处购买纳吉礼包，并使用里面的纳吉卡。"
    return 0, szErrMsg
  end

  return 1
end

function tbNpc:AppWeddingDlg()
  --	local nDate = me.GetTask(Marry.TASK_GROUP_ID , Marry.TASK_RESERVE_DATE);
  --	local nLevel = me.GetTask(Marry.TASK_GROUP_ID , Marry.TASK_WEDDING_LEVEL);
  --	local nRet = Marry:CheckPreWedding(me.szName);
  --	if nRet == 0 and nDate > 0 and nLevel > 0 then
  --		me.SetTask(Marry.TASK_GROUP_ID, Marry.TASK_WEDDING_LEVEL, 0);
  --		me.SetTask(Marry.TASK_GROUP_ID, Marry.TASK_RESERVE_DATE, 0);
  --		me.SetTask(Marry.TASK_GROUP_ID, Marry.TASK_RESERVE_MAPLEVEL, 0);
  --		me.SetTask(Marry.TASK_GROUP_ID, Marry.TASK_TIME_RESELECTDATE, 0);
  --	end

  if me.nSex == 1 then
    Dialog:Say("需要男方持有典礼礼包前来预订典礼。\n<color=green>提示：\n1、典礼礼包可以在典礼商人处购买。\n2、女方若误购典礼礼包可兑换回情花。\n3、可以放入更高级的典礼礼包来顶替原来预定的低级典礼。<color>")
    return 0
  end

  if me.IsMarried() == 1 then
    Dialog:Say("你已经是有家室的人了，不要再来凑热闹了。")
    return 0
  end

  local szMsg = "请放入还没有使用过的典礼礼包，开始预订典礼。\n<color=green>提示：\n1、典礼礼包可以在典礼商人处购买。\n2、女方若误购典礼礼包可兑换回情花。\n3、可以放入更高级的典礼礼包来顶替原来预定的低级典礼。\n<color>"
  local bNeedCompensation = Marry:CheckCompensation(me.szName)
  if bNeedCompensation == 1 then
    me.SetTask(Marry.TASK_GROUP_ID, Marry.TASK_TIME_RESELECTDATE, 0)
    if 2 > me.CountFreeBagCell() then
      szMsg = szMsg .. string.format("\n<color=red>请清理出%s格包裹空间再来预定典礼。<color>", 2)
      Dialog:Say(szMsg)
      return 0
    end
  else
    if me.CountFreeBagCell() < 1 then
      szMsg = szMsg .. "\n<color=red>请清理出1格包裹空间再来预定典礼。<color>"
      Dialog:Say(szMsg)
      return 0
    end
  end

  local nReSelectTime = me.GetTask(Marry.TASK_GROUP_ID, Marry.TASK_TIME_RESELECTDATE)
  if nReSelectTime > 0 then
    local nNeedMoney = self.MONEY_BASE * nReSelectTime
    szMsg = szMsg .. string.format("\n<color=red>注意：<color>您现在已经是第<color=yellow>%s<color>次重新选择典礼了，需要收取手续费<color=yellow>%s<color>两。", nReSelectTime, nNeedMoney)
  end

  local tbOpt = {
    { "放入典礼礼包", self.GetLibao, self },
    { "我还是考虑一下再来吧" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:GetLibao()
  Dialog:OpenGift("请放入典礼礼包。<color=green>\n可以放入更高级的典礼礼包来顶替原来预定的低级典礼。已经在典礼场地打开使用过的典礼礼包不能再重新预订典礼。", nil, { self.OnOpenGiftOk, self })
end

function tbNpc:ChechItem(tbItem)
  local bRighitItem = 0
  for _, szGDPL in pairs(self.tbLibaoGDPL) do
    local szItem = string.format("%s-%s-%s-%s", tbItem[1].nGenre, tbItem[1].nDetail, tbItem[1].nParticular, tbItem[1].nLevel)
    if szGDPL == szItem then
      bRighitItem = 1
      break
    end
  end
  return bRighitItem
end

function tbNpc:OnOpenGiftOk(tbItemObj)
  if Lib:CountTB(tbItemObj) ~= 1 then
    Dialog:Say("你放入的物品不对，只需要放入一个典礼礼包就行了。")
    return 0
  end

  local tbItem = tbItemObj[1]
  if self:ChechItem(tbItem) == 0 then
    Dialog:Say("您放入了不是典礼礼包的物品，请确认后再来吧。")
    return 0
  end

  local pItem = tbItem[1]

  local tbQiuhunLibao = Item:GetClass("marry_xinhunlibao")
  if tbQiuhunLibao:IsNewItem(pItem) ~= 1 then
    Dialog:Say("这个典礼礼包已经被使用过了，不能用来预订典礼。")
    return 0
  end

  local nWeddingLevel = pItem.nLevel

  local nPreWeddingLevel = me.GetTask(Marry.TASK_GROUP_ID, Marry.TASK_WEDDING_LEVEL)
  if pItem.nLevel < nPreWeddingLevel then
    Dialog:Say("不能重新选择典礼。请放入同档次或更高档次的典礼礼包。")
    return 0
  end

  local bCanWedding, szErrMsg = self:CheckWeddingCond(nWeddingLevel)
  if 0 == bCanWedding then
    if szErrMsg and szErrMsg ~= "" then
      Dialog:Say(szErrMsg)
    end
    return 0
  end

  local tblMemberList, nMemberCount = me.GetTeamMemberList()
  if 2 ~= nMemberCount then
    return 0
  end
  local cTeamMate = tblMemberList[1]
  for i = 1, #tblMemberList do
    if tblMemberList[i].szName ~= me.szName then
      cTeamMate = tblMemberList[i]
    end
  end

  if pItem.szCustomString and pItem.szCustomString ~= "" and cTeamMate.szName ~= pItem.szCustomString then
    Dialog:Say(string.format("这个典礼礼包只能用来和<color=yellow>%s<color>确定和修改典礼日期。", pItem.szCustomString))
    return 0
  end

  -- self:SelectDate(pItem, nWeddingLevel, nPlaceLevel);
  local szMsg = string.format("你确定要用这个礼包来预订<color=yellow>%s<color>典礼吗？", self.tbWeddingInfo[nWeddingLevel].szName)
  local tbOpt = {
    { "是的，我确定", self.SureAppWedding, self, pItem.dwId },
    { "我还是再想想吧" },
  }
  Dialog:Say(szMsg, tbOpt)
end

-- 是否确定要预定婚期
function tbNpc:SureAppWedding(dwItemId)
  local pItem = KItem.GetObjById(dwItemId)
  if not pItem then
    return
  end
  local nWeddingLevel = pItem.nLevel
  local szMsg = "根据你的礼包等级，你可以选择以下档次的典礼场地。"
  local tbOpt = {}
  for i = nWeddingLevel, self.LEVEL_PINGMIN, -1 do
    local szOpt = string.format("%s场地", self.tbWeddingInfo[i].szName)
    table.insert(tbOpt, { szOpt, self.SelectDate, self, dwItemId, i })
  end
  table.insert(tbOpt, { "结束对话" })
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:SelectWeddingPlace(nWeddingLevel, nPlaceLevel)
  local szMsg = "放入典礼礼包，绑定它，并判断是否有资格选择相应等级的典礼。"
  local tbOpt = {
    { "放入礼包", self.GetLibao, self, nWeddingLevel, nPlaceLevel },
    { "结束对话" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:GetDateOpt(dwItemId, nPlaceLevel, nStartOrderTime)
  local tbOpt = {}
  local pItem = KItem.GetObjById(dwItemId)
  if not pItem then
    return
  end
  local nWeddingLevel = pItem.nLevel
  if nWeddingLevel == self.LEVEL_HUANGJIA then
    local nTuesdayTime = 0
    local nTime = GetTime()
    if nStartOrderTime then
      nTime = nStartOrderTime
    end
    for i = 1, 7 do
      nTime = nTime + 3600 * 24
      local nWeekday = tonumber(os.date("%w", nTime))
      if 2 == nWeekday then
        nTuesdayTime = nTime
        break
      end
    end

    local nStartTime = nTuesdayTime
    local nEndTime = nTuesdayTime + 3600 * 24 * 6
    for i = 1, 4 do
      local szStartDay = os.date("%Y年%m月%d日", nStartTime)
      local szEndDay = os.date("%Y年%m月%d日", nEndTime)
      local szOpt = string.format("<color=yellow>%s - %s<color>", szStartDay, szEndDay)
      local nDate = tonumber(os.date("%Y%m%d", nStartTime))
      if Marry:CheckAddWedding(nWeddingLevel, nDate) == 1 then
        table.insert(tbOpt, { szOpt, self.GetDateOpt_HuangJia, self, dwItemId, nPlaceLevel, nStartTime })
      end

      nStartTime = nStartTime + 3600 * 24 * 7
      nEndTime = nEndTime + 3600 * 24 * 7
    end
  else
    local nTime = GetTime()
    if nStartOrderTime then
      nTime = nStartOrderTime
    end
    for i = 1, 7 do
      nTime = nTime + 3600 * 24
      local szDate = tostring(os.date("%Y年%m月%d日", nTime))
      local nDate = tonumber(os.date("%Y%m%d", nTime))
      if Marry:CheckAddWedding(nWeddingLevel, nDate) == 1 then
        table.insert(tbOpt, { string.format("<color=yellow>%s<color>", szDate), self.SelectCertainDate, self, dwItemId, nPlaceLevel, nTime })
      end
    end
  end
  table.insert(tbOpt, { "返回上一层", self.SureAppWedding, self, dwItemId })
  return tbOpt
end

-- 皇家婚礼的再次选择日期选项（因为皇家婚礼的举办时间是一周只举行一次，需要再次确定是在那天举行婚礼）
function tbNpc:GetDateOpt_HuangJia(dwItemId, nPlaceLevel, nStartTime)
  local szMsg = "请选择你具体要在那一天举行典礼："
  local tbOpt = {}
  for i = 0, 6 do
    local nTime = nStartTime + i * 3600 * 24
    local szDate = tostring(os.date("%Y年%m月%d日", nTime))
    local nDate = tonumber(os.date("%Y%m%d", nTime))
    table.insert(tbOpt, { string.format("<color=yellow>%s<color>", szDate), self.SelectCertainDate, self, dwItemId, nPlaceLevel, nTime })
  end
  table.insert(tbOpt, { "返回上一层", self.SureAppWedding, self, dwItemId })
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:SelectDate(dwItemId, nPlaceLevel)
  local szMsg = "请在下列日期内选择你喜欢的典礼日期。"
  local nStartOrderTime = Lib:GetDate2Time(Marry.START_TIME) - 3600 * 24
  if GetTime() > nStartOrderTime then
    nStartOrderTime = GetTime()
  end
  local tbOpt = self:GetDateOpt(dwItemId, nPlaceLevel, nStartOrderTime)
  if #tbOpt == 1 then
    szMsg = "该等级典礼档期已满，请另择吉日！"
  end
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:CheckDate(nTime, nWeddingLevel)
  local szErrMsg = ""
  local nOk = Marry:CheckAddWedding(nWeddingLevel, nTime)
  if nOk ~= 1 then
    szErrMsg = "该等级典礼档期已满，请另择吉日！"
    return 0, szErrMsg
  end
  return 1
end

function tbNpc:SelectCertainDate(dwItemId, nPlaceLevel, nTime)
  local nDate = tonumber(os.date("%Y%m%d", nTime))
  local pItem = KItem.GetObjById(dwItemId)
  if not pItem then
    return 0
  end
  local bCanSelect, szErrMsg = self:CheckDate(nDate, pItem.nLevel)
  if 0 == bCanSelect then
    if szErrMsg ~= "" then
      Dialog:Say(szErrMsg, { { "重新选择日期", self.SelectDate, self, dwItemId, nPlaceLevel }, { "结束对话" } })
    end
    return 0
  end

  local szDate = tostring(os.date("%Y年%m月%d日", nTime))
  local szMsg = string.format("你已经选定举办典礼的日期为：<color=yellow>%s<color>，确定要在这天举办典礼吗？", szDate)
  local tbOpt = {
    { "是的，我要在这天举办典礼", self.SureSelectDate, self, dwItemId, nPlaceLevel, nTime },
    { "我要重新选择", self.SelectDate, self, dwItemId, nPlaceLevel },
    { "结束对话" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:SureSelectDate(dwItemId, nPlaceLevel, nTime)
  local pItem = KItem.GetObjById(dwItemId)
  if not pItem then
    return 0
  end

  local nDate = tonumber(os.date("%Y%m%d", nTime))
  local nCurDate = tonumber(os.date("%Y%m%d", GetTime()))
  if nDate <= nCurDate then
    Dialog:Say("当前日期无法预订。")
    return 0
  end
  local nWeddingLevel = pItem.nLevel
  local bCanWedding, szErrMsg = self:CheckWeddingCond(nWeddingLevel)
  if 0 == bCanWedding then
    if szErrMsg and szErrMsg ~= "" then
      Dialog:Say(szErrMsg)
    end
    return 0
  end

  local tblMemberList, nMemberCount = me.GetTeamMemberList()
  if 2 ~= nMemberCount then
    return 0
  end

  local cTeamMate = tblMemberList[1]
  for i = 1, #tblMemberList do
    if tblMemberList[i].szName ~= me.szName then
      cTeamMate = tblMemberList[i]
    end
  end

  -- 服务器增加预订婚礼
  local nWeddingLevel = pItem.nLevel
  if Marry:CheckAddWedding(nWeddingLevel, nDate) ~= 1 then
    return 0
  end

  local nRet, _, nPreDate = Marry:CheckPreWedding(me.szName)
  local nReSelectTime = me.GetTask(Marry.TASK_GROUP_ID, Marry.TASK_TIME_RESELECTDATE)
  if 1 == nRet and nReSelectTime > 0 then
    local nCurDate = tonumber(os.date("%Y%m%d", GetTime()))
    local nCurTime = tonumber(os.date("%H%M", GetTime()))

    -- 上午11:50之后就不要重新选择婚礼了
    if nPreDate == nCurDate and nCurTime >= 1150 and nCurTime < 1200 then
      Dialog:Say("您上次预定的典礼场地马上就要打开，现在已经来不及重新预定典礼了。")
      return 0
    elseif nPreDate == nCurDate and nCurTime >= 1200 then
      Dialog:Say("您上次预定的典礼场地已经打开，现在已经来不及重新预定典礼了。")
      return 0
    elseif nPreDate < nCurDate then
      Dialog:Say("您上次预定的典礼已经开启过了，现在已经不能重新预定典礼了。")
      return 0
    end
  end

  Marry:AddWedding_GS(nWeddingLevel, nDate, { me.szName, cTeamMate.szName, nPlaceLevel }, dwItemId, nTime)
end

function tbNpc:GetCoupleTitleDlg()
  local szMsg = "如果您的侠侣称号消失，可以在我这里给你们加上。注意，需要侠侣双方组队前来。"
  local tbOpt = {
    { "修复侠侣称号", self.GetCoupleTitle, self },
    { "我再想想" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:GetCoupleTitle()
  local szCoupleName = me.GetCoupleName()
  if not szCoupleName then
    Dialog:Say("你还没有侠侣，怎么修复侠侣称号？")
    return 0
  end

  local tblMemberList, nMemberCount = me.GetTeamMemberList()
  if 2 ~= nMemberCount then
    Dialog:Say("修复侠侣称号需要侠侣两人组队前来。")
    return 0
  end
  local cTeamMate = tblMemberList[1]
  for i = 1, #tblMemberList do
    if tblMemberList[i].szName ~= me.szName then
      cTeamMate = tblMemberList[i]
    end
  end

  if szCoupleName ~= cTeamMate.szName then
    Dialog:Say("你的队友并不是你的侠侣，不能为你们修复侠侣称号。")
    return 0
  end

  Marry:SetTitle(me, cTeamMate)
  Dialog:Say("你们的侠侣称号已经修复。")
  Setting:SetGlobalObj(cTeamMate)
  Dialog:Say("你们的侠侣称号已经修复。")
  Setting:RestoreGlobalObj()
end
