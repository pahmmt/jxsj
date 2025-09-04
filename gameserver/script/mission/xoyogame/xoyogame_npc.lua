--
-- 逍遥谷 NPC逻辑

XoyoGame.TASK_GROUP_MEDICINE = 2050
XoyoGame.TASK_GET_MEDICINE_TIME = 53

XoyoGame.nLastBroadcast = 0
XoyoGame.nBroadcastNpcId = 0
XoyoGame.nBroadcastMapId = 0

function XoyoGame:CanGetMedicine()
  if SpecialEvent:IsWellfareStarted() ~= 1 then
    return 0, "此功能尚未开启，敬请期待。"
  end

  if me.nLevel < 30 then
    return 0, "你需要达到30级才能领取逍遥谷药品。"
  end

  local nTime = tonumber(os.date("%Y%m%d", GetTime()))
  local nLastTime = me.GetTask(self.TASK_GROUP_MEDICINE, self.TASK_GET_MEDICINE_TIME)
  if nTime == nLastTime then
    return 0, "你今天已经领过逍遥谷药品啦，明天再来吧。"
  end

  if me.CountFreeBagCell() < 1 then
    return 0, "背包空间不足，请空出1格之后再来领取。"
  end

  return 1
end

function XoyoGame:GetMedicine()
  local nRes, szMsg = self:CanGetMedicine()
  if nRes == 0 then
    Dialog:Say(szMsg)
    return
  end

  local tbOpt = {
    { "回血丹·箱", XoyoGame.GetMedicine2, XoyoGame, 1 },
    { "回内丹·箱", XoyoGame.GetMedicine2, XoyoGame, 2 },
    { "乾坤造化丸·箱", XoyoGame.GetMedicine2, XoyoGame, 3 },
    { "我只是来看看" },
  }
  Dialog:Say("你要领取那种药品？", tbOpt)
end

XoyoGame.tbFreeMedicine = {
  [30] = {
    [1] = { 18, 1, 352, 5 },
    [2] = { 18, 1, 353, 5 },
    [3] = { 18, 1, 354, 5 },
  },
  [50] = {
    [1] = { 18, 1, 352, 4 },
    [2] = { 18, 1, 353, 4 },
    [3] = { 18, 1, 354, 4 },
  },
  [80] = {
    [1] = { 18, 1, 352, 1 },
    [2] = { 18, 1, 353, 1 },
    [3] = { 18, 1, 354, 1 },
  },
  [90] = {
    [1] = { 18, 1, 352, 2 },
    [2] = { 18, 1, 353, 2 },
    [3] = { 18, 1, 354, 2 },
  },
  [110] = {
    [1] = { 18, 1, 352, 3 },
    [2] = { 18, 1, 353, 3 },
    [3] = { 18, 1, 354, 3 },
  },
}

function XoyoGame:GetMedicine2(nType)
  local nRes, szMsg = self:CanGetMedicine()
  if nRes == 0 then
    Dialog:Say(szMsg)
    return
  end

  local nLevel
  if me.nLevel >= 110 then
    nLevel = 110
  elseif me.nLevel >= 90 then
    nLevel = 90
  elseif me.nLevel >= 80 then
    nLevel = 80
  elseif me.nLevel >= 50 then
    nLevel = 50
  elseif me.nLevel >= 30 then
    nLevel = 30
  end

  local pItem = me.AddItem(unpack(self.tbFreeMedicine[nLevel][nType]))
  me.SetItemTimeout(pItem, 24 * 60, 0)
  me.SetTask(self.TASK_GROUP_MEDICINE, self.TASK_GET_MEDICINE_TIME, tonumber(os.date("%Y%m%d", GetTime())))
  Dbg:WriteLog("XoyoGame", string.format("%s 获得逍遥药品 %s", me.szName, pItem.szName))
end

function XoyoGame:JieYinRen()
  Dialog:Say("最近想去逍遥谷的人可真多啊，你也是其中一员吗？", {
    { "请送我去逍遥谷入口1", self.ToBaoMingDian, self, 341 },
    { "请送我去逍遥谷入口2", self.ToBaoMingDian, self, 342 },
    { "我只是路过" },
  })
end

function XoyoGame:BroadcastRank()
  return XoyoGame:__BroadcastRank()
end

function XoyoGame:__BroadcastRank()
  if XoyoGame.nBroadcastNpcId <= 0 then
    local tbNpcList = KNpc.GetMapNpcWithName(341, "黄翡")
    XoyoGame.nBroadcastMapId = 341
    if not tbNpcList or #tbNpcList == 0 then
      XoyoGame.nBroadcastMapId = 342
      tbNpcList = KNpc.GetMapNpcWithName(342, "黄翡")
    end
    if not tbNpcList or #tbNpcList == 0 then
      XoyoGame.nBroadcastMapId = 0
      return
    end
    XoyoGame.nBroadcastNpcId = tbNpcList[1]
  end

  local szDesc = self:GetBroadcastRank()
  if not szDesc then
    return
  end
  local pNpc = KNpc.GetByIndex(XoyoGame.nBroadcastNpcId)
  if not pNpc then
    return
  end
  pNpc.SendChat(szDesc)
  if XoyoGame.nBroadcastMapId == 0 then
    print("Error When nBroadcastMapId is 0")
    return
  end
  local tbPlayList, nCount = KPlayer.GetMapPlayer(XoyoGame.nBroadcastMapId)
  for _, teammate in ipairs(tbPlayList) do
    teammate.Msg(szDesc, pNpc.szName)
  end
end

function XoyoGame:GetBroadcastRank()
  local nDifficuty, nRank
  local nMax = #XoyoGame.LevelDesp * XoyoGame.RANK_RECORD - 1
  local nRepeat = 0
  repeat
    nRepeat = nRepeat + 1
    if nRepeat > nMax then
      return
    end
    if XoyoGame.nLastBroadcast >= nMax then
      XoyoGame.nLastBroadcast = 0
    else
      XoyoGame.nLastBroadcast = XoyoGame.nLastBroadcast + 1
    end
    nDifficuty = math.floor(XoyoGame.nLastBroadcast / XoyoGame.RANK_RECORD) + 1
    nRank = XoyoGame.nLastBroadcast % XoyoGame.RANK_RECORD + 1
  until XoyoGame.tbXoyoRank[nDifficuty] and XoyoGame.tbXoyoRank[nDifficuty][nRank]
  local tbRank = XoyoGame.tbXoyoRank[nDifficuty][nRank]
  if not tbRank then
    return
  end

  local szDesc = "<color=white>逍遥谷<color=orange>[%s难度]<color>    通关纪录第%d名:<color=orange>%s<color>   <color=yellow>%s<color>的队伍创造于%s<color>"
  local szDate = os.date("%Y年%m月%d日", tbRank.nDate)
  local szTimeUsed = os.date("%M分%S秒", tbRank.nTime)
  local szCaptain = tbRank.tbMember[1]
  local szDifficuty = XoyoGame.LevelDesp[nDifficuty][2]
  szDesc = string.format(szDesc, szDifficuty, nRank, szTimeUsed, szCaptain, szDate)
  return szDesc
end

function XoyoGame:WatchRecord()
  local tbOpt = {}
  for nSortIndex = 1, #XoyoGame.LevelDespSortIndex do
    local i = XoyoGame.LevelDespSortIndex[nSortIndex]
    if XoyoGame.LevelDesp[i][1] == 1 then
      table.insert(tbOpt, { XoyoGame.LevelDesp[i][2] .. ":" .. XoyoGame.LevelDesp[i][3], self.WatchRecordDetails, self, i })
    elseif XoyoGame.LevelDesp[i][1] == 0 then
      table.insert(tbOpt, { "<color=gray>" .. XoyoGame.LevelDesp[i][2] .. ":" .. XoyoGame.LevelDesp[i][3] .. "<color>", self.NotOpenDifficuty, self })
    end
  end
  table.insert(tbOpt, { "结束对话" })
  Dialog:Say("您可以查看以下难度的通关纪录", tbOpt)
end

function XoyoGame:WatchRecordDetails(nDifficuty)
  if not XoyoGame.tbXoyoRank[nDifficuty] or #XoyoGame.tbXoyoRank[nDifficuty] == 0 then
    Dialog:Say("当前难度下没有任何纪录")
    return
  end
  local szMsg = string.format("您正在查看<color=orange>%s难度<color>下的通关纪录:\n\n", XoyoGame.LevelDesp[nDifficuty][2])
  for nRank, tbInfo in ipairs(XoyoGame.tbXoyoRank[nDifficuty]) do
    szMsg = szMsg .. string.format("第%d名:\n", nRank)
    szMsg = szMsg .. os.date("日期:%Y年%m月%d日\n", tbInfo.nDate)
    szMsg = szMsg .. os.date("用时:<color=yellow>%M分%S秒<color>\n", tbInfo.nTime)
    szMsg = szMsg .. "队员:"
    for _, szName in ipairs(tbInfo.tbMember) do
      szMsg = szMsg .. szName .. " "
    end
    szMsg = szMsg .. "\n\n"
  end
  Dialog:Say(szMsg)
end

function XoyoGame:TestWatch()
  local tbOpt = {
    { "上月家族记录", self.WatchPreKinRecord, self },
    { "上月个人记录", self.WatchPreRecord, self },
    { "当前家族数据", self.Test_WatchKinDataRecord, self },
  }
  Dialog:Say("请选择", tbOpt)
end

function XoyoGame:Test_WatchKinDataRecord()
  local nKinId, nMemberId = me.GetKinMember()
  local cKin = KKin.GetKin(nKinId)
  local szMsg = "个人积分：" .. me.GetTask(self.TASK_GROUP, self.TOLL_GATE_POINT) .. "\n"
  if cKin then
    szMsg = szMsg .. string.format("月份：%s\n分数：%s\n时间：%s", cKin.GetXoyoMonth(), cKin.GetXoyoPoint(), os.date("%Y年%m月%d日%H时%M分%S秒", cKin.GetXoyoLastTime()))
  end
  Dialog:Say(szMsg)
end

function XoyoGame:WatchPreRecord()
  local tbOpt = {}
  for nSortIndex = 1, #XoyoGame.LevelDespSortIndex do
    local i = XoyoGame.LevelDespSortIndex[nSortIndex]
    if XoyoGame.LevelDesp[i][1] == 1 then
      table.insert(tbOpt, { XoyoGame.LevelDesp[i][2] .. ":" .. XoyoGame.LevelDesp[i][3], self.WatchPreRecordDetails, self, i })
    elseif XoyoGame.LevelDesp[i][1] == 0 then
      table.insert(tbOpt, { "<color=gray>" .. XoyoGame.LevelDesp[i][2] .. ":" .. XoyoGame.LevelDesp[i][3] .. "<color>", self.NotOpenDifficuty, self })
    end
  end
  table.insert(tbOpt, { "结束对话" })
  Dialog:Say("您可以查看以下难度的通关纪录", tbOpt)
end

function XoyoGame:WatchPreRecordDetails(nDifficuty)
  if not XoyoGame.tbLastMonthXoyoRank[nDifficuty] or #XoyoGame.tbLastMonthXoyoRank[nDifficuty] == 0 then
    Dialog:Say("当前难度下没有任何纪录")
    return
  end
  local szMsg = string.format("您正在查看<color=orange>%s难度<color>下的通关纪录:\n\n", XoyoGame.LevelDesp[nDifficuty][2])
  for nRank, tbInfo in ipairs(XoyoGame.tbLastMonthXoyoRank[nDifficuty]) do
    szMsg = szMsg .. string.format("第%d名:\n", nRank)
    szMsg = szMsg .. os.date("日期:%Y年%m月%d日\n", tbInfo.nDate)
    szMsg = szMsg .. os.date("用时:<color=yellow>%M分%S秒<color>\n", tbInfo.nTime)
    szMsg = szMsg .. "队员:"
    for _, szName in ipairs(tbInfo.tbMember) do
      szMsg = szMsg .. szName .. " "
    end
    szMsg = szMsg .. "\n\n"
  end
  Dialog:Say(szMsg)
end

function XoyoGame.WatchPreKinRecord()
  if not XoyoGame.tbLastMonthXoyoKinRank or #XoyoGame.tbLastMonthXoyoKinRank == 0 then
    Dialog:Say("本月暂时还没有地狱逍遥谷家族积分记录")
    return
  end
  local szMsg = "您正在查看上月<color=yellow>地狱逍遥谷<color>家族积分记录：\n\n"
  local nKinId, nMemberId = me.GetKinMember()
  for nRank, tbInfo in ipairs(XoyoGame.tbLastMonthXoyoKinRank) do
    szMsg = szMsg .. string.format("第%d名:\n", nRank)
    szMsg = szMsg .. string.format("家族：%s\n", tbInfo.szName)
    szMsg = szMsg .. string.format("积分：%s\n", tbInfo.nPoint)
    szMsg = szMsg .. os.date("最后一次通关时间：%Y年%m月%d日%H时%M分%S秒\n\n", tbInfo.nTime)
  end
  Dialog:Say(szMsg)
end

function XoyoGame:WatchKinRecord()
  local szInfo = "<color=yellow>活动介绍：<color>家族成员击败<color=yellow>逍遥谷地狱关卡BOSS<color>，获得积分累积进行家族排名。月终排入前十名家族的正式成员和荣誉成员，在领取逍遥录奖励时将获得<color=yellow>额外20%<color>的奖励加成。\n\n"
  if not XoyoGame.tbXoyoKinRank or #XoyoGame.tbXoyoKinRank == 0 then
    Dialog:Say(szInfo .. "本月暂时还没有地狱关卡家族积分排行。")
    return
  end
  local szMsg = szInfo
  local nKinId, nMemberId = me.GetKinMember()
  local cKin = KKin.GetKin(nKinId)
  if cKin then
    local nMonth = cKin.GetXoyoMonth()
    local nTaskMonth = KGblTask.SCGetDbTaskInt(DBTASK_XOYO_RANK_LAST_MONTH, nMonth)
    if nMonth < nTaskMonth then
      szMsg = szMsg .. "家族本月积分：<color=green>0分<color>\n\n"
    elseif nMonth == nTaskMonth then
      szMsg = szMsg .. string.format("家族本月积分：<color=green>%s分<color>\n\n", cKin.GetXoyoPoint())
    end
  end
  szMsg = szMsg .. "<color=yellow>--------地狱关卡家族积分排行-------<color>\n\n"
  for nRank, tbInfo in ipairs(XoyoGame.tbXoyoKinRank) do
    if nRank > 5 then
      break
    end
    szMsg = szMsg .. string.format("第<color=yellow>%d<color>名：<color=green>%s分<color>\n", nRank, tbInfo.nPoint)
    szMsg = szMsg .. string.format("家 族：<color=green>%s<color>\n\n", tbInfo.szName)
  end
  local tbOpt = {}
  if #XoyoGame.tbXoyoKinRank > 5 then
    table.insert(tbOpt, { "下一页", XoyoGame.WatchKinRecordNextPage, XoyoGame })
  end
  table.insert(tbOpt, { "结束对话" })
  Dialog:Say(szMsg, tbOpt)
end

function XoyoGame:WatchKinRecordNextPage()
  local szMsg = "<color=yellow>--------地狱关卡家族积分排行-------<color>\n\n"
  for nRank, tbInfo in ipairs(XoyoGame.tbXoyoKinRank) do
    if nRank > 5 then
      szMsg = szMsg .. string.format("第<color=yellow>%d<color>名：<color=green>%s分<color>\n", nRank, tbInfo.nPoint)
      szMsg = szMsg .. string.format("家 族：<color=green>%s<color>\n\n", tbInfo.szName)
    end
  end
  Dialog:Say(szMsg)
end

function XoyoGame:ToBaoMingDian(nMapId)
  if me.nLevel < self.MIN_LEVEL then
    Dialog:Say("你功力尚浅，逍遥谷对你来说太危险了，先把等级提升到" .. self.MIN_LEVEL .. "级再来闯谷吧。")
    return 0
  end
  if me.GetCamp() == 0 then
    Dialog:Say("你无门无派，闯谷等于是去送死，还是先入了门派再来找老夫吧。")
    return 0
  end
  me.NewWorld(nMapId, unpack(self.BAOMING_IN_POS))
end

function XoyoGame:NotOpenDifficuty()
  Dialog:Say("该难度还未开放，敬请期待。")
end

function XoyoGame:DocumentDifficuty(nTeamId, nDifficuty)
  local tbMemberList, nCount = KTeam.GetTeamMemberList(nTeamId)
  for _, nPlayerId in pairs(tbMemberList) do
    local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
    if pPlayer then
      pPlayer.SetTask(XoyoGame.TASK_GROUP, XoyoGame.TASK_DIFFICUTY, nDifficuty)
    end
  end
end

function XoyoGame:GetOnlineTeamMember(nTeamId)
  local tbMemberList, nCount = KTeam.GetTeamMemberList(nTeamId)
  if nCount == 0 then
    return
  end
  for _, nPlayerId in pairs(tbMemberList) do
    local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
    if pPlayer then
      return pPlayer
    end
  end
end

function XoyoGame:GetDifficuty(nTeamId)
  local pPlayer = self:GetOnlineTeamMember(nTeamId)
  if not pPlayer then
    return 1 -- 防止报错
  end
  local nDifficuty = pPlayer.GetTask(XoyoGame.TASK_GROUP, XoyoGame.TASK_DIFFICUTY)
  if nDifficuty == 0 then
    nDifficuty = 1
  end
  return nDifficuty
end

function XoyoGame:TellLevelRequire(nDifficuty)
  local szTips = string.format("逍遥谷<color=orange>[%s难度]<color>需要队伍所有玩家等级达到<color=yellow>%d级<color>才能挑战。", XoyoGame.LevelDesp[nDifficuty][2], XoyoGame.DifficutyRequire[nDifficuty])
  Dialog:Say(szTips)
end

function XoyoGame:GetTeamMinLevel(nTeamId)
  if nTeamId == 0 then
    return 0
  end
  local tbMemberList, nMemberCount = KTeam.GetTeamMemberList(nTeamId)
  if nMemberCount == 0 then
    return 0
  end
  local nMinLevel = 999
  for _, nPlayerId in pairs(tbMemberList) do
    local nLevel = KGCPlayer.OptGetTask(nPlayerId, 11)
    if nMinLevel > nLevel then
      nMinLevel = nLevel
    end
  end
  return nMinLevel
end

function XoyoGame:ApplyJoinGame(nDifficuty, nGameId)
  if me.GetTiredDegree1() == 2 then
    Dialog:Say("您太累了，还是休息下吧！")
    return
  end
  if me.nTeamId == 0 then
    Dialog:Say("  谷里地形复杂、艰险异常，为了你们的安全着想，<color=green>每人每天最多只能入谷两次，而且至少得4人结伴通行<color>，老夫才允许你们进入。好了，找齐了一起闯谷的伙伴就让队长来我这报名吧。老夫每天<color=yellow>凌晨0点到2点、上午8点到晚上23点<color>之间的<color=green>正点和半点<color>引领各位进谷。", tbOpt)
    return
  end
  local nManagerId = him.nMapId
  if not self.tbManager[nManagerId] or not self.tbManager[nManagerId].tbData then
    return 0
  end
  local nCurTime = tonumber(os.date("%H%M", GetTime()))
  if not self.__debug_test and (nCurTime < self.START_TIME1 or nCurTime >= self.END_TIME1) and (nCurTime < self.START_TIME2 or nCurTime >= self.END_TIME2) then
    Dialog:Say("老夫在每天的<color=yellow>早上8点到晚上11点、晚上12点到凌晨2点<color>之间才能引领各位，请各位到时再来！")
    return 0
  end
  local tbOpt = {}
  if not nDifficuty then
    local nIndex = 1
    for nSortIndex = 1, #XoyoGame.LevelDespSortIndex do
      local i = XoyoGame.LevelDespSortIndex[nSortIndex]
      if XoyoGame.LevelDesp[i][1] == 1 then
        if XoyoGame:GetTeamMinLevel(me.nTeamId) < XoyoGame.DifficutyRequire[i] then
          tbOpt[nIndex] = { XoyoGame.LevelDesp[i][2] .. "：" .. XoyoGame.LevelDesp[i][3], self.TellLevelRequire, self, i }
        else
          tbOpt[nIndex] = { XoyoGame.LevelDesp[i][2] .. "：" .. XoyoGame.LevelDesp[i][3], self.ApplyJoinGame, self, i }
        end
        nIndex = nIndex + 1
      elseif XoyoGame.LevelDesp[i][1] == 0 then
        tbOpt[nIndex] = { "<color=gray>" .. XoyoGame.LevelDesp[i][2] .. "：" .. XoyoGame.LevelDesp[i][3] .. "<color>", self.NotOpenDifficuty, self }
        nIndex = nIndex + 1
      end
    end
    table.insert(tbOpt, { "结束对话" })
    Dialog:Say("最近很多年轻阅历尚浅的侠士亦纷纷前来报名想入谷一探究竟，鉴于此特开放简单难度的逍遥谷供等级在30级以上的侠士参与，望有所得，有所知，有所获！\n<color=yellow>注意：通过简单难度逍遥谷不能达成侠客任务的条件，请选择难度时慎重。<color>\n\n请选择要挑战的难度", tbOpt)
    return 0
  end
  if not nGameId then
    for i, nCurGameId in pairs(self.MANAGER_GROUP[nManagerId]) do
      if self.START_SWITCH[nCurGameId] == 1 then
        local szTeamCount = "(未开启)"
        if self.tbManager[nManagerId].tbData[nCurGameId] then
          if self.tbManager[nManagerId].tbData[nCurGameId] < self.MAX_TEAM then
            local nNormalCount = self.tbManager[nManagerId].tbData[nCurGameId]
            local nVipCount = 0
            if nNormalCount > self.MAX_NOR_TEAM then
              nNormalCount = self.MAX_NOR_TEAM
              nVipCount = self.tbManager[nManagerId].tbData[nCurGameId] - nNormalCount
            end
            szTeamCount = string.format("(入谷队伍:%s/%s,<color=green>VIP[%s/%s]<color>)", nNormalCount, self.MAX_NOR_TEAM, nVipCount, self.MAX_VIP_TEAM)
          else
            szTeamCount = "(已满员)"
          end
        end
        table.insert(tbOpt, { string.format("去逍遥谷%s%s", i, szTeamCount), self.ApplyJoinGame, self, nDifficuty, nCurGameId })
      end
    end
    table.insert(tbOpt, { "转移报名点", self.ChangeBaoMingDian, self, nManagerId })
    table.insert(tbOpt, { "我们还没准备好，等会再来" })
    Dialog:Say("  谷里地形复杂、艰险异常，为了你们的安全着想，<color=green>每人每天最多只能入谷两次，而且至少得4人结伴通行<color>，老夫才允许你们进入。好了，找齐了一起闯谷的伙伴就让队长来我这报名吧。老夫每天<color=yellow>凌晨0点到2点、上午8点到晚上23点<color>之间的<color=green>正点和半点<color>引领各位进谷", tbOpt)
  else
    if not self.tbManager[nManagerId].tbData[nGameId] then
      Dialog:Say("逍遥谷未开启")
      return 0
    end
    if self.tbManager[nManagerId].tbData[nGameId] >= self.MAX_TEAM then
      Dialog:Say("谷内已经满员了。")
      return 0
    end
    local nTeamId = me.nTeamId
    if nTeamId == 0 then
      Dialog:Say("都说了至少得4人结伴，赶紧去找些伙伴再来吧。")
      return 0
    end
    local tbMember, nMemberCount = KTeam.GetTeamMemberList(nTeamId)
    if not tbMember or nMemberCount < self.MIN_TEAM_PLAYERS then
      Dialog:Say("都说了至少得4人结伴，赶紧去找些伙伴再来吧。")
      return 0
    end
    if me.nId ~= tbMember[1] then
      Dialog:Say("你不是队长，让你们的队长来找我吧！")
      return 0
    end
    for i = 1, #tbMember do
      local nRet = self:CheckPlayer(tbMember[i], nManagerId)
      if nRet ~= 1 then
        return 0
      end
    end
    if self.tbManager[nManagerId].tbData[nGameId] >= self.MAX_TEAM then
      Dialog:Say("在逍遥谷内等候的队伍已满")
      return 0
    end

    if self.tbManager[nManagerId].tbData[nGameId] >= self.MAX_NOR_TEAM then -- 只有充值100的玩家才能进入使用最后两个预留队伍
      if me.GetExtMonthPay() < self.LIMIT_ROOM_PAYVALUE then
        Dialog:Say(string.format("只有充值满%s元的玩家才能进入vip房间", self.LIMIT_ROOM_PAYVALUE))
        return 0
      end
    end

    if nDifficuty == 9 then
      for i = 1, #tbMember do
        local pPlayer = KPlayer.GetPlayerObjById(tbMember[i])
        if pPlayer.nLevel >= XoyoGame.MAX_SIMPLE_XOYO_LEVEL then
          Dialog:Say(string.format("您报名的是简单难度逍遥谷（推荐进入等级30级~50级），你队伍中有人等级超过%s级，请确认是否进入简单难度逍遥谷？", self.MAX_SIMPLE_XOYO_LEVEL), {
            { "确定", self.OnSureJoinGame, self, nDifficuty, nGameId },
            { "返回上一页", self.ApplyJoinGame, self },
            { "我再考虑考虑" },
          })
          return 0
        end
      end
    end

    self.tbManager[nManagerId].tbData[nGameId] = self.tbManager[nManagerId].tbData[nGameId] + 1
    self:DocumentDifficuty(nTeamId, nDifficuty)
    --StatLog:WriteStatLog("stat_info", "xoyo", "join", nTeamId, nDifficuty);
    local tbDataLog = {}
    table.insert(tbDataLog, me.nTeamId)

    -- 队聊提示报名成功，以及报名难度
    local szTeamMsg = string.format("本队已报名 <color=yellow>%s<color>逍遥谷", self.LevelDesp[nDifficuty][2])
    KTeam.Msg2Team(nTeamId, szTeamMsg)

    for i = 1, #tbMember do
      local pPlayer = KPlayer.GetPlayerObjById(tbMember[i])

      if XoyoGame.XoyoChallenge:GetXoyoluState(pPlayer) == 0 and XoyoGame.LevelDesp[nDifficuty][5] == 1 then
        local nRes, szMsg = XoyoGame.XoyoChallenge:GetXoyolu(pPlayer)
        if szMsg then
          pPlayer.Msg(szMsg)
        end
      end

      pPlayer.NewWorld(XoyoGame.MAP_GROUP[nGameId][1], unpack(self.GAME_IN_POS))
      table.insert(tbDataLog, pPlayer.szName)
    end
    DataLog:WriteELog(me.szName, 1, 1, unpack(tbDataLog))
  end
end

function XoyoGame:ChangeBaoMingDian(nManagerId, nSure)
  if me.nTeamId == 0 then
    return
  end
  local szMsg = ""
  local nTargetMapId = 0
  if nManagerId == 341 then
    szMsg = "将报名点内的队友全部转移到逍遥谷报名点2，确定？"
    nTargetMapId = 342
  elseif nManagerId == 342 then
    szMsg = "将报名点内的队友全部转移到逍遥谷报名点1，确定？"
    nTargetMapId = 341
  end
  if nTargetMapId == 0 then
    return
  end
  if not nSure then
    local tbOpt = {
      { "确定转移", self.ChangeBaoMingDian, self, nManagerId, 1 },
      { "我再考虑一下" },
    }
    Dialog:Say(szMsg, tbOpt)
    return
  end
  local tbMember, nMemberCount = KTeam.GetTeamMemberList(me.nTeamId)
  if me.nId ~= tbMember[1] then
    Dialog:Say("你不是队长，无法转移你的队友！")
    return 0
  end
  for i = 1, #tbMember do
    local pPlayer = KPlayer.GetPlayerObjById(tbMember[i])
    if pPlayer and pPlayer.nMapId == nManagerId then
      pPlayer.NewWorld(nTargetMapId, unpack(self.BAOMING_IN_POS))
    end
  end
end

function XoyoGame:OnSureJoinGame(nDifficuty, nGameId)
  if not nDifficuty or not nGameId then
    return 0
  end

  if me.GetTiredDegree1() == 2 then
    Dialog:Say("您太累了，还是休息下吧！")
    return
  end
  if me.nTeamId == 0 then
    Dialog:Say("  谷里地形复杂、艰险异常，为了你们的安全着想，<color=green>每人每天最多只能入谷两次，而且至少得4人结伴通行<color>，老夫才允许你们进入。好了，找齐了一起闯谷的伙伴就让队长来我这报名吧。老夫每天<color=yellow>凌晨0点到2点、上午8点到晚上23点<color>之间的<color=green>正点和半点<color>引领各位进谷", tbOpt)
    return
  end
  local nManagerId = him.nMapId
  if not self.tbManager[nManagerId] or not self.tbManager[nManagerId].tbData then
    return 0
  end
  local nCurTime = tonumber(os.date("%H%M", GetTime()))
  if not self.__debug_test and (nCurTime < self.START_TIME1 or nCurTime >= self.END_TIME1) and (nCurTime < self.START_TIME2 or nCurTime >= self.END_TIME2) then
    Dialog:Say("老夫在每天的<color=yellow>早上8点到晚上11点、晚上12点到凌晨2点<color>之间才能引领各位，请各位到时再来！")
    return 0
  end

  if not self.tbManager[nManagerId].tbData[nGameId] then
    Dialog:Say("逍遥谷未开启")
    return 0
  end
  if self.tbManager[nManagerId].tbData[nGameId] >= self.MAX_TEAM then
    Dialog:Say("谷内已经满员了。")
    return 0
  end
  local nTeamId = me.nTeamId
  if nTeamId == 0 then
    Dialog:Say("都说了至少得4人结伴，赶紧去找些伙伴再来吧。")
    return 0
  end
  local tbMember, nMemberCount = KTeam.GetTeamMemberList(nTeamId)
  if not tbMember or nMemberCount < self.MIN_TEAM_PLAYERS then
    Dialog:Say("都说了至少得4人结伴，赶紧去找些伙伴再来吧。")
    return 0
  end
  if me.nId ~= tbMember[1] then
    Dialog:Say("你不是队长，让你们的队长来找我吧！")
    return 0
  end
  for i = 1, #tbMember do
    local nRet = self:CheckPlayer(tbMember[i], nManagerId)
    if nRet ~= 1 then
      return 0
    end
  end
  if self.tbManager[nManagerId].tbData[nGameId] >= self.MAX_TEAM then
    Dialog:Say("在逍遥谷内等候的队伍已满")
    return 0
  end

  self.tbManager[nManagerId].tbData[nGameId] = self.tbManager[nManagerId].tbData[nGameId] + 1
  self:DocumentDifficuty(nTeamId, nDifficuty)
  --StatLog:WriteStatLog("stat_info", "xoyo", "join", nTeamId, nDifficuty);
  local tbDataLog = {}
  table.insert(tbDataLog, me.nTeamId)

  -- 队聊提示报名成功，以及报名难度
  local szTeamMsg = string.format("本队已报名 <color=yellow>%s<color>逍遥谷", self.LevelDesp[nDifficuty][2])
  KTeam.Msg2Team(nTeamId, szTeamMsg)

  for i = 1, #tbMember do
    local pPlayer = KPlayer.GetPlayerObjById(tbMember[i])

    if XoyoGame.XoyoChallenge:GetXoyoluState(pPlayer) == 0 and XoyoGame.LevelDesp[nDifficuty][5] == 1 then
      local nRes, szMsg = XoyoGame.XoyoChallenge:GetXoyolu(pPlayer)
      if szMsg then
        pPlayer.Msg(szMsg)
      end
    end

    pPlayer.NewWorld(XoyoGame.MAP_GROUP[nGameId][1], unpack(self.GAME_IN_POS))
    table.insert(tbDataLog, pPlayer.szName)
  end
  DataLog:WriteELog(me.szName, 1, 1, unpack(tbDataLog))
end

function XoyoGame:CheckPlayer(nPlayerId, nMapId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer or pPlayer.nMapId ~= nMapId then
    Dialog:Say("你们队好像还有人不在这里哦，还是等人到齐了再一起入谷吧。")
    return 0
  end
  if pPlayer.nLevel < self.MIN_LEVEL then
    Dialog:Say("诶！你们队怎么还有菜鸟混进来了？先把等级提升到" .. self.MIN_LEVEL .. "级再来吧。")
    return 0
  end
  if pPlayer.GetCamp() == 0 then
    Dialog:Say("诶！怎么还有菜鸟混进来了？无门无派，闯谷等于是去送死，还是先入了门派再来吧")
    return 0
  end
  if self:GetPlayerTimes(pPlayer) <= 0 then
    Dialog:Say(string.format("喂!喂!那个<color=red>%s<color>，你今天已经不能再进谷了，还想进去？明天再来吧！", pPlayer.szName))
    return 0
  end
  return 1
end

function XoyoGame:GetPlayerTimes(pPlayer)
  return self:AddPlayerTimes(pPlayer)
end

function XoyoGame:AddPlayerTimes(pPlayer, nDirectAddTimes)
  if not nDirectAddTimes or nDirectAddTimes ~= 1 then
    if pPlayer.nLevel < self.MIN_LEVEL then
      return 0
    end
  end
  local nCurTime = GetTime()
  local nCurDay = Lib:GetLocalDay(nCurTime)
  local nTimes = pPlayer.GetTask(self.TASK_GROUP, self.TIMES_ID)
  local nAddDay = pPlayer.GetTask(self.TASK_GROUP, self.ADDTIMES_TIME)
  if nAddDay == 0 then
    nTimes = self.TIMES_PER_DAY
    pPlayer.SetTask(self.TASK_GROUP, self.TIMES_ID, nTimes)
    pPlayer.SetTask(self.TASK_GROUP, self.ADDTIMES_TIME, nCurDay)
    return nTimes
  end
  if nCurDay >= nAddDay then
    nTimes = nTimes + (nCurDay - nAddDay) * self.TIMES_PER_DAY
    -- TODO: 以后要删掉 -------------------------------
    local nXiuFuNum = (nCurDay - 14333) * self.TIMES_PER_DAY -- 14334 是1970.1.1 到 2009.3.30 的天数
    if nXiuFuNum < nTimes then
      nTimes = nXiuFuNum
    end
    -- TODO：END --------------------------------------
    if nTimes >= self.MAX_TIMES then
      nTimes = self.MAX_TIMES
    end
    pPlayer.SetTask(self.TASK_GROUP, self.TIMES_ID, nTimes)
    pPlayer.SetTask(self.TASK_GROUP, self.ADDTIMES_TIME, nCurDay)
  end
  return nTimes
end

function XoyoGame:AddPlayerTimesOnLogin()
  self:AddPlayerTimes(me)
end
PlayerEvent:RegisterOnLoginEvent(XoyoGame.AddPlayerTimesOnLogin, XoyoGame)

------------------------------------------------------------------------------------------------------------------
--  领奖给予界面
XoyoGame.tbGift = Gift:New()

local tbGift = XoyoGame.tbGift
tbGift.ITEM_CALSS = "xoyoitem"

function tbGift:OnOK(tbParam)
  local pItem = self:First()
  local tbItem = {}
  if not pItem then
    return 0
  end
  while pItem do
    if pItem.szClass == self.ITEM_CALSS then
      table.insert(tbItem, pItem)
    end
    pItem = self:Next()
  end

  local nTimes = me.GetTask(XoyoGame.TASK_GROUP, XoyoGame.REPUTE_TIMES)
  local nDate = me.GetTask(XoyoGame.TASK_GROUP, XoyoGame.CUR_REPUTE_DATE)
  local nCurDate = tonumber(os.date("%Y%m%d", GetTime()))
  if nDate ~= nCurDate then
    nTimes = 0
    me.SetTask(XoyoGame.TASK_GROUP, XoyoGame.CUR_REPUTE_DATE, nCurDate)
    me.SetTask(XoyoGame.TASK_GROUP, XoyoGame.REPUTE_TIMES, nTimes)
  end
  if nTimes >= XoyoGame.MAX_REPUTE_TIMES then
    Dialog:Say("你今天已经给了我<color=red>" .. XoyoGame.MAX_REPUTE_TIMES .. "<color>个宝贝了，我需要整理一下这些宝贝，请明天送过来吧！")
    return 0
  end

  local nLevel = me.GetReputeLevel(XoyoGame.REPUTE_CAMP, XoyoGame.REPUTE_CLASS)
  if not nLevel then
    print("AddRepute Repute is error ", me.szName, nClass, nCampId)
    return 0
  else
    if 1 == me.CheckLevelLimit(XoyoGame.REPUTE_CAMP, XoyoGame.REPUTE_CLASS) then
      me.Msg("你给我的宝贝已经够多了，我已经不需要了！")
      return 0
    end
  end

  local nRet = 0
  for _, pDelItem in ipairs(tbItem) do
    local nCount = pDelItem.nCount
    if nTimes + nRet + nCount > XoyoGame.MAX_REPUTE_TIMES then -- 交纳道具超过上限
      local nRemain = nCount - (XoyoGame.MAX_REPUTE_TIMES - nTimes - nRet)
      if nRemain > 0 and nRemain <= nCount and pDelItem.SetCount(nRemain, Item.emITEM_DATARECORD_REMOVE) == 1 then
        nRet = XoyoGame.MAX_REPUTE_TIMES - nTimes
      end
    elseif me.DelItem(pDelItem) == 1 then
      nRet = nRet + nCount
    end
    if nTimes + nRet >= XoyoGame.MAX_REPUTE_TIMES then
      break
    end
  end
  if nRet == 0 then
    Dialog:Say("嘿嘿嘿！别想拿这些破东西来糊弄我！")
    return 0
  end

  me.AddRepute(XoyoGame.REPUTE_CAMP, XoyoGame.REPUTE_CLASS, nRet * XoyoGame.REPUTE_VALUE)
  me.SetTask(XoyoGame.TASK_GROUP, XoyoGame.REPUTE_TIMES, nTimes + nRet)

  --成就
  Achievement:FinishAchievement(me, 189)

  Dialog:Say("不错不错！这正是我要的东西！")
end

function tbGift:OnUpdate()
  self._szTitle = "交纳宝物"
  local nTimes = me.GetTask(XoyoGame.TASK_GROUP, XoyoGame.REPUTE_TIMES)
  local nDate = me.GetTask(XoyoGame.TASK_GROUP, XoyoGame.CUR_REPUTE_DATE)
  local nCurDate = tonumber(os.date("%Y%m%d", GetTime()))
  if nDate ~= nCurDate then
    nTimes = 0
  end
  self._szContent = "每天最多可以交" .. XoyoGame.MAX_REPUTE_TIMES .. "个物品\n今天已交了<color=green>" .. nTimes .. "<color>个"
  return 0
end

-- ?pl DoScript("\\script\\mission\\xoyogame\\xoyogame_npc.lua")
