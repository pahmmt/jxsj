-------------------------------------------------------
-- 文件名　：atlantis_gs.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2011-03-09 11:43:31
-- 文件描述：
-------------------------------------------------------

if not MODULE_GAMESERVER then
  return
end

Require("\\script\\boss\\atlantis\\atlantis_def.lua")

-------------------------------------------------------
-- 功能函数
-------------------------------------------------------

-- 消息封装
function Atlantis:SendMessage(pPlayer, nType, szMsg)
  if nType == self.MSG_CHANNEL then
    pPlayer.Msg(szMsg)
  elseif nType == self.MSG_BOTTOM then
    Dialog:SendBlackBoardMsg(pPlayer, szMsg)
  elseif nType == self.MSG_MIDDLE then
    Dialog:SendInfoBoardMsg(pPlayer, szMsg)
  end
end

-- 广播消息
function Atlantis:BroadCast(nType, szMsg)
  for szPlayerName, _ in pairs(self.tbPlayerList) do
    local pPlayer = KPlayer.GetPlayerByName(szPlayerName)
    if pPlayer then
      self:SendMessage(pPlayer, nType, szMsg)
    end
  end
end

-- 开启右侧信息
function Atlantis:OpenRightUI(pPlayer, nRemainFrame)
  local szTitle = "<color=green>剩余时间：<color=white>%s<color>"
  local szMsg = string.format("\n<color=green>击杀玩家：<color=yellow>%s\n<color=green>材料数量：<color=yellow>%s\n<color=green>队伍人数：<color=yellow>%s<color>\n", 0, 0, 0)
  Dialog:SetBattleTimer(pPlayer, szTitle, nRemainFrame)
  Dialog:SendBattleMsg(pPlayer, szMsg, 1)
  Dialog:ShowBattleMsg(pPlayer, 1, 0)
end

-- 关闭信息界面
function Atlantis:CloseRightUI(pPlayer)
  Dialog:ShowBattleMsg(pPlayer, 0, 0)
end

-- 更新右侧信息
function Atlantis:UpdateRightUI(pPlayer)
  local tbInfo = self.tbPlayerList[pPlayer.szName]
  if not tbInfo then
    self:CloseRightUI(pPlayer)
    return 0
  end
  local nKillCount = tbInfo.nKillCount
  local nChipCount = self:GetChipCount(pPlayer)
  local _, nMemberCount = pPlayer.GetTeamMemberList()
  nMemberCount = nMemberCount or 1
  local szMsg = string.format("\n<color=green>击杀玩家：<color=yellow>%s\n<color=green>材料数量：<color=yellow>%s\n<color=green>队伍人数：<color=yellow>%s<color>\n", nKillCount, nChipCount, nMemberCount)
  Dialog:SendBattleMsg(pPlayer, szMsg, 1)
end

-- 获取材料数量
function Atlantis:GetChipCount(pPlayer)
  local nCount = 0
  for i, tbInfo in pairs(self.ITEM_CHIP_ID) do
    nCount = nCount + pPlayer.GetItemCountInBags(unpack(tbInfo.tbItemId))
  end
  return nCount
end

-- 掉落一定比例材料
function Atlantis:PlayerLostChip(pPlayer, pReceiver, szType)
  local nMapId, nMapX, nMapY = pPlayer.GetWorldPos()
  for i, tbInfo in pairs(self.ITEM_CHIP_ID) do
    local nLost = 0
    local tbItemId = tbInfo.tbItemId
    local nCount = pPlayer.GetItemCountInBags(unpack(tbItemId))
    if nCount > self.MIN_BAG_CHIP then
      nLost = math.floor(nCount / 5)
    elseif nCount > 0 then
      nLost = 1
    end
    if nLost > 0 then
      local nRet = pPlayer.ConsumeItemInBags2(nLost, tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4])
      if nRet ~= 0 then
        Dbg:WriteLog("楼兰古城", "Atlantis", pPlayer.szAccount, pPlayer.szName, string.format("扣除%s个%s失败", nLost, tbInfo.szName))
      end
      self:SendMessage(pPlayer, self.MSG_CHANNEL, string.format("你损失了<color=yellow>%s个%s<color>", nLost, tbInfo.szName))

      if pReceiver then
        pReceiver.AddStackItem(tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4], nil, nLost)
      elseif szType ~= "clear" then
        for i = 1, nLost do
          KItem.AddItemInPos(nMapId, nMapX + MathRandom(10) - 5, nMapY + MathRandom(10) - 5, tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4])
        end
      end

      Dbg:WriteLog("Atlantis", "楼兰古城", pPlayer.szAccount, pPlayer.szName, string.format("掉落了%s个%s", nLost, tbInfo.szName))
      StatLog:WriteStatLog("stat_info", "loulangucheng", "drop", pPlayer.nId, pPlayer.GetHonorLevel(), self:GetMantleLevel(pPlayer), tbInfo.szName, nLost)
    end
  end
end

-- 判断是否携带神器
function Atlantis:CheckHaveSuper(szPlayerName)
  if not self.tbPlayerList[szPlayerName] then
    return 0
  end
  return self.tbPlayerList[szPlayerName].nSuperEquip
end

-- 判断神兵
function Atlantis:CheckIsSuper(pItem)
  for _, tbInfo in pairs(self.ITEM_EQUIP_ID) do
    for _, tbItemId in pairs(tbInfo) do
      if pItem.nGenre == tbItemId[1] and pItem.nDetail == tbItemId[2] and pItem.nParticular == tbItemId[3] and pItem.nLevel == tbItemId[4] then
        return 1
      end
    end
  end
  return 0
end

-- 掉落神兵
function Atlantis:PlayerLostEquip(pPlayer, szType)
  local nFlag = 0
  Setting:SetGlobalObj(pPlayer)

  for _, tbInfo in pairs(self.ITEM_EQUIP_ID) do
    for _, tbItemId in pairs(tbInfo) do
      local tbFind = GM:GMFindAllRoom(tbItemId)
      for _, tbItem in pairs(tbFind or {}) do
        pPlayer.DelItem(tbItem.pItem)
        nFlag = nFlag + 1
      end
    end
  end

  local tbFind2 = GM:GMFindAllRoom(self.ITEM_HAMMER_ID)
  for _, tbItem in pairs(tbFind2 or {}) do
    pPlayer.DelItem(tbItem.pItem)
  end

  Setting:RestoreGlobalObj(pPlayer)

  if nFlag > 0 then
    if szType == "drop" then
      local nMapId, nMapX, nMapY = pPlayer.GetWorldPos()
      local pNpc = KNpc.Add2(self.NPC_EQUIP_ID, self.NPC_LEVEL, -1, nMapId, nMapX, nMapY)
      if pNpc then
        local szMsg = "<color=yellow>在一道耀眼的光芒闪过之后，神器诞生于这片广袤的土地上！<color>"
        self:BroadCast(self.MSG_BOTTOM, szMsg)
        self:BroadCast(self.MSG_CHANNEL, szMsg)
        Timer:Register(5 * 60 * Env.GAME_FPS, self.OnTimerDelNpc, self, pNpc.dwId)
      end
    elseif self.nEquipCount >= 1 then
      for i = self.nEquipCount, self.MAX_EQUIP do
        if self.tbStar[i] then
          local pNpc = KNpc.GetById(self.tbStar[i])
          if pNpc then
            pNpc.Delete()
          end
          self.tbStar[i] = nil
        end
      end
      self.nEquipCount = self.nEquipCount - 1
    end
    self.tbPlayerList[pPlayer.szName].nSuperEquip = 0
    self.tbTeamList[pPlayer.nTeamId].nSuperTeam = 0
    Player.tbFightPower:RefreshFightPower(pPlayer, true)
    return 1
  end
  return 0
end

function Atlantis:OnTimerDelNpc(dwNpcId)
  local pNpc = KNpc.GetById(dwNpcId)
  if not pNpc then
    return 0
  end
  pNpc.Delete()
  if self.nEquipCount >= 1 then
    for i = self.nEquipCount, self.MAX_EQUIP do
      if self.tbStar[i] then
        local pStar = KNpc.GetById(self.tbStar[i])
        if pStar then
          pStar.Delete()
        end
        self.tbStar[i] = nil
      end
    end
    self.nEquipCount = self.nEquipCount - 1
  end
  return 0
end

-- 获取精英怪信息
function Atlantis:GetMonsterById(nNpcDwId)
  for _, tbInfo in ipairs(self.tbMonster) do
    if tbInfo.nNpcDwId == nNpcDwId then
      return tbInfo
    end
  end
  return nil
end

-- 判断是否可以拾取白金装备
function Atlantis:CheckGetEquip(pPlayer)
  local tbTeam = self.tbTeamList[pPlayer.nTeamId]
  if not tbTeam then
    return 0
  end

  if pPlayer.nFightState == 0 then
    return 0
  end

  if tbTeam.nSuperTeam == 1 then
    self:SendMessage(pPlayer, self.MSG_MIDDLE, "队伍中已经有人拥有了楼兰神器，同队里只能有一位成为神之选民！")
    return 0
  end

  local nNeed = 2
  if pPlayer.CountFreeBagCell() < nNeed then
    self:SendMessage(pPlayer, self.MSG_MIDDLE, string.format("请留出至少%s格背包空间！", nNeed))
    return 0
  end

  return 1
end

-- 获得对应的装备id
function Atlantis:GetEquipId(pPlayer)
  local tbFaction = self.ITEM_EQUIP_ID[pPlayer.nFaction]
  if not tbFaction then
    return nil
  end
  return tbFaction[pPlayer.nRouteId]
end

-- 获得时间段系数
function Atlantis:GetTimeRate()
  --	local nTime = tonumber(GetLocalDate("%H%M"));
  --	for nTmpTime, nTmpRate in ipairs(self.TIME_RATE) do
  --		if nCurTime <= nTmpTime then
  --			return nTmpRate;
  --		end
  --	end
  return 1
end

-- 获得人数系数
function Atlantis:GetPlayerRate()
  local nCount = self:GetMapPlayerCount()
  if nCount > 0 then
    return (nCount ^ 0.5) / (self.MAX_PLAYER ^ 0.5) * 0.75 + 0.25
  end
  return 0
end

-- 获取地图人数
function Atlantis:GetMapPlayerCount()
  return Lib:CountTB(self.tbPlayerList)
end

-- 获取掉落次数
function Atlantis:GetCurDropTimes()
  return math.floor(self.MAX_DROP_TIMES * self.nDropRate)
end

-- 获取披风等级
function Atlantis:GetMantleLevel(pPlayer)
  local pItem = pPlayer.GetItem(Item.ROOM_EQUIP, Item.EQUIPPOS_MANTLE, 0)
  if not pItem then
    return 0
  end
  return pItem.nLevel
end

-------------------------------------------------------
-- 入口相关
-------------------------------------------------------

-- 进入判定
function Atlantis:CheckCanEnter()
  -- 系统开关
  if self:CheckIsOpen() ~= 1 or self._Open ~= 1 then
    Dialog:Say(string.format("    哎呀。。。我昨天雇的那个车夫现在还没有来呢，你还是在开服<color=yellow>%s天<color>后，<color=yellow>15:00-24:00<color>这段时间再来看看吧～", Atlantis.OPEN_DAY))
    return 0
  end

  -- 等级限制
  if me.nLevel < self.MIN_LEVEL then
    Dialog:Say(string.format("    楼兰古城周围那荒漠尽是凶禽猛兽，这样凶险的地方，你这单薄的身子还是算了，先将等级提升为<color=yellow>%s级<color>再说吧！", self.MIN_LEVEL))
    return 0
  end

  -- 门派限制
  if me.nFaction <= 0 then
    Dialog:Say("    楼兰古城周围那荒漠尽是凶禽猛兽，这样凶险的地方，你这单薄的身子还是算了，先加入<color=yellow>门派<color>再说吧！")
    return 0
  end

  -- 混天披风
  if self:GetMantleLevel(me) < self.MIN_MANTLE then
    Dialog:Say("    楼兰古城周围那荒漠尽是凶禽猛兽，这样凶险的地方，你这单薄的身子怎么可以去呢？还是穿戴好<color=yellow>混天或以上的披风并且组队<color>前往吧！")
    return 0
  end

  -- 时间限制
  local nUseTime = me.GetTask(self.TASK_GID, self.TASK_USE_TIME)
  if nUseTime >= self.MAX_TIME then
    Dialog:Say("    你今天在里面呆的时间太久了，还是等明天再来吧")
    return 0
  end

  return 1
end

-- 玩家进入
function Atlantis:PlayerEnter()
  local bGreenServer = KGblTask.SCGetDbTaskInt(DBTASK_TIMEFRAME_OPEN)
  local nType = Ladder:GetType(0, 2, 1, 0) or 0 -- 由于ladder的tbconfig没有gs副本，所有特殊处理，获取战斗力等级排行榜的type
  local tbInfo = GetHonorLadderInfoByRank(nType, 25) -- 等级排行榜第25名
  local nLadderLevel = 0
  if tbInfo then
    nLadderLevel = tbInfo.nHonor
  end

  -- GM功能
  if me.GetCamp() == 6 then
    me.NewWorld(unpack(self.REVIVAL_LIST[MathRandom(1, #self.REVIVAL_LIST)]))
    return 0
  end

  if bGreenServer == 1 then --绿色服务器限制
    if nLadderLevel < 100 then
      Dialog:Say("楼兰古城还未开放，本服25人达到100级后将会自动开启。")
      return 0
    end
  end

  -- 是否队长
  if me.IsCaptain() ~= 1 then
    Dialog:Say("你不是队长，请叫队长来带领大家进入。")
    return 0
  end

  -- 是否组队
  local tbMemberId, nMemberCount = KTeam.GetTeamMemberList(me.nTeamId)
  if not tbMemberId then
    Dialog:Say("请叫齐你的伙伴一起组队进去吧。")
    return 0
  end

  -- 所有成员在附近
  local nNearby = 0
  local tbPlayerList = KPlayer.GetAroundPlayerList(me.nId, 50)
  for _, tbRound in pairs(tbPlayerList or {}) do
    for _, nMemberId in pairs(tbMemberId) do
      local pMember = KPlayer.GetPlayerObjById(nMemberId)
      if pMember and pMember.szName == tbRound.szName then
        nNearby = nNearby + 1
      end
    end
  end

  if nNearby ~= nMemberCount then
    Dialog:Say("你的队友离得太远了，请叫他们都过来吧。")
    return 0
  end

  -- 所有成员满足条件
  local nFlag = 0
  for _, nMemberId in pairs(tbMemberId) do
    local pMember = KPlayer.GetPlayerObjById(nMemberId)
    if pMember then
      Setting:SetGlobalObj(pMember)
      if self:CheckCanEnter() ~= 1 then
        KTeam.Msg2Team(pMember.nTeamId, string.format("[%s]无法进入楼兰古城，请整理队伍后再来。", pMember.szName))
        nFlag = 1
      end
      Setting:RestoreGlobalObj()
    end
  end

  if nFlag == 1 then
    return 0
  end

  -- 人数判定
  local nMapCount = self:GetMapPlayerCount()
  if nMemberCount + nMapCount > self.MAX_PLAYER then
    Dialog:Say("    （人数满了）哎呀……哎呀呀，这段时间是怎么了？无数的人都想去那个地方，我们车队的马匹都快跑断腿了，<color=yellow>你还是过一会再来看看吧~<color>")
    return 0
  end

  -- 执行进入(同地图直接传)
  local nRand = MathRandom(1, #self.REVIVAL_LIST)
  for _, nMemberId in pairs(tbMemberId) do
    local pMember = KPlayer.GetPlayerObjById(nMemberId)
    if pMember then
      Lib:ShowTB(self.REVIVAL_LIST[nRand])
      pMember.NewWorld(unpack(self.REVIVAL_LIST[nRand]))
    end
  end
end

-- 增加玩家
function Atlantis:AddPlayer(pPlayer)
  -- 设置状态
  pPlayer.TeamDisable(1) -- 禁止队伍操作
  pPlayer.ForbitTrade(1) -- 禁止交易
  pPlayer.ForbidEnmity(1) -- 禁止仇杀
  pPlayer.ForbidExercise(1) -- 禁止切磋
  pPlayer.DisabledStall(1) -- 禁止摆摊
  pPlayer.SetChannelState(-1, 1) -- 禁止聊天
  pPlayer.SetChannelState(7, 0) -- 打开队聊
  pPlayer.nForbidChangePK = 1 -- 禁止切换状态
  pPlayer.DisableChangeCurCamp(1) -- 禁止切换阵营
  pPlayer.SetNoDeathPunish(1) -- 死亡无惩罚
  pPlayer.SetLogoutRV(1) -- 下线保护
  pPlayer.nPkModel = Player.emKPK_STATE_BUTCHER -- 战斗模式
  pPlayer.SetDisableButcherReduceStamina(1) -- 不扣体力
  pPlayer.GetNpc().SetTrickName("神秘人") -- 隐藏名字

  pPlayer.nInBattleState = 1
  pPlayer.SetCheckTeamInBattle(1)

  pPlayer.SetSyncKinTongState(0)
  pPlayer.UpdateKinTongTitle()

  pPlayer.SetHonorLevel(0) -- 隐藏头衔
  pPlayer.AddSpeTitle("楼兰神话", GetTime() + 2 * 60 * 60 * 24, "orange")

  Partner:SetForbitOut(pPlayer, 1) -- 隐藏同伴

  local szMsg = "您来到了楼兰古城废墟，这里是商队的营地，还是很安全的！"
  self:SendMessage(pPlayer, self.MSG_BOTTOM, szMsg)
  self:SendMessage(pPlayer, self.MSG_CHANNEL, szMsg)

  -- 玩家列表
  self.tbPlayerList[pPlayer.szName] = {}
  self.tbPlayerList[pPlayer.szName].nSuperEquip = 0
  self.tbPlayerList[pPlayer.szName].nKillCount = 0
  self.tbPlayerList[pPlayer.szName].nEnterTime = GetTime()

  -- GM模式
  if pPlayer.GetCamp() == 6 then
    self.tbPlayerList[pPlayer.szName].nGMFlag = 1
    return 0
  end

  -- 队伍列表
  if not self.tbTeamList[pPlayer.nTeamId] then
    self.tbTeamList[pPlayer.nTeamId] = {}
    self.tbTeamList[pPlayer.nTeamId].nMemberCount = 0
    self.tbTeamList[pPlayer.nTeamId].nSuperTeam = 0
  end

  self.tbTeamList[pPlayer.nTeamId].nMemberCount = self.tbTeamList[pPlayer.nTeamId].nMemberCount + 1

  -- 右侧界面
  local nUseTime = pPlayer.GetTask(self.TASK_GID, self.TASK_USE_TIME)
  local nFrame = (self.MAX_TIME - nUseTime) * Env.GAME_FPS
  self:OpenRightUI(pPlayer, nFrame)

  -- 保护时间
  Player:AddProtectedState(pPlayer, self.SUPER_TIME)

  Dbg:WriteLog("Atlantis", "楼兰古城", pPlayer.szAccount, pPlayer.szName, "进入楼兰古城", string.format("财富等级：%s", pPlayer.GetHonorLevel()))
  StatLog:WriteStatLog("stat_info", "loulangucheng", "enter", pPlayer.nId, pPlayer.GetHonorLevel(), pPlayer.nTeamId)
end

-- 移除玩家
function Atlantis:RemovePlayer(pPlayer)
  -- 还原状态
  pPlayer.LeaveTeam() -- 离开队伍
  pPlayer.TeamDisable(0) -- 禁止队伍操作
  pPlayer.ForbitTrade(0) -- 禁止交易
  pPlayer.ForbidEnmity(0) -- 禁止仇杀
  pPlayer.ForbidExercise(0) -- 禁止切磋
  pPlayer.DisabledStall(0) -- 禁止摆摊
  pPlayer.SetChannelState(-1, 0) -- 禁止聊天
  pPlayer.nForbidChangePK = 0 -- 禁止切换状态
  pPlayer.SetFightState(0) -- 开始战斗
  pPlayer.DisableChangeCurCamp(0) -- 禁止切换阵营
  pPlayer.SetNoDeathPunish(0) -- 死亡无惩罚
  pPlayer.nPkModel = Player.emKPK_STATE_PRACTISE -- 战斗模式
  pPlayer.SetDisableButcherReduceStamina(0) -- 不扣体力
  pPlayer.GetNpc().SetTrickName("") -- 隐藏名字

  pPlayer.nInBattleState = 0
  pPlayer.SetCheckTeamInBattle(0)

  pPlayer.SetSyncKinTongState(1)
  pPlayer.UpdateKinTongTitle()

  local nHonorLevel = PlayerHonor:GetPlayerMaxHonorLevel(pPlayer)
  pPlayer.SetHonorLevel(nHonorLevel)
  pPlayer.RemoveSpeTitle("楼兰神话")

  Partner:SetForbitOut(pPlayer, 0) -- 显示同伴

  -- GM到此为止
  if pPlayer.GetCamp() == 6 then
    self.tbPlayerList[pPlayer.szName] = nil
    return 0
  end

  -- 如果是地图中退出，执行掉落
  --	if pPlayer.nFightState > 0 then
  --		self:PlayerLostChip(pPlayer);
  --	end

  -- 删除神器
  self:PlayerLostEquip(pPlayer)

  -- 移除列表
  self.tbPlayerList[pPlayer.szName] = nil

  -- 队伍处理
  if self.tbTeamList[pPlayer.nTeamId].nMemberCount > 1 then
    self.tbTeamList[pPlayer.nTeamId].nMemberCount = self.tbTeamList[pPlayer.nTeamId].nMemberCount - 1
  else
    self.tbTeamList[pPlayer.nTeamId] = nil
  end

  -- 关闭界面
  self:CloseRightUI(pPlayer)

  local nUseTime = pPlayer.GetTask(self.TASK_GID, self.TASK_USE_TIME)
  Dbg:WriteLog("Atlantis", "楼兰古城", pPlayer.szAccount, pPlayer.szName, "离开楼兰古城", string.format("财富等级：%s", pPlayer.GetHonorLevel()), string.format("当日累计时间：%s", nUseTime))
  StatLog:WriteStatLog("stat_info", "loulangucheng", "leave", pPlayer.nId, pPlayer.GetHonorLevel(), nUseTime)
end

-------------------------------------------------------
-- Timer相关
-------------------------------------------------------

-- 启动计时器
function Atlantis:StartTimer(nTime, fnTimer, szType)
  self:ClearTimer(szType)
  self.tbTimerId[szType] = Timer:Register(nTime, fnTimer, self)
end

-- 关闭计时器
function Atlantis:ClearTimer(szType)
  local nTimerId = self.tbTimerId[szType]
  if nTimerId and nTimerId > 0 then
    Timer:Close(nTimerId)
    self.tbTimerId[szType] = nil
  end
end

-- 玩家管理
function Atlantis:TimerPlayer()
  -- 5秒监控一次
  for szPlayerName, tbInfo in pairs(self.tbPlayerList) do
    local pPlayer = KPlayer.GetPlayerByName(szPlayerName)
    if pPlayer then
      -- 关闭状态直接踢出去
      if self:CheckIsOpen() ~= 1 then
        self:SafeLeave(pPlayer)

      -- 直接加时间
      elseif pPlayer.GetCamp() ~= 6 then
        local nUseTime = pPlayer.GetTask(self.TASK_GID, self.TASK_USE_TIME)
        if nUseTime + self.TIMER_PLAYER > self.MAX_TIME then
          pPlayer.SetTask(self.TASK_GID, self.TASK_USE_TIME, self.MAX_TIME)
          self:SafeLeave(pPlayer)

        -- 时间不足提示
        else
          local nTime = nUseTime + self.TIMER_PLAYER
          if self.MAX_TIME - nTime < 300 then
            self:SendMessage(pPlayer, self.MSG_BOTTOM, "你今天的剩余时间已经不多了，请准备返回凤翔吧。")
          end
          pPlayer.SetTask(self.TASK_GID, self.TASK_USE_TIME, nTime)
        end
        self:UpdateRightUI(pPlayer)
      end
    else
      self.tbPlayerList[szPlayerName] = nil
    end
  end

  return self.TIMER_PLAYER * Env.GAME_FPS
end

-- 刷出精英怪
function Atlantis:TimerMonster()
  -- 乱序筛选法
  Lib:SmashTable(self.tbMonster)
  table.sort(self.tbMonster, function(a, b)
    return a.nLiving > b.nLiving
  end)

  -- 保证刷出一定数量怪
  local nCount = 0
  for _, tbInfo in ipairs(self.tbMonster) do
    if tbInfo.nLiving ~= 1 then
      local nRand = math.ceil(MathRandom(1, #self.MONSTER_LIST * 100) / 100)
      local nNpcId = self.MONSTER_LIST[nRand].nNpcId
      local pNpc = KNpc.Add2(nNpcId, self.NPC_LEVEL, -1, tbInfo.tbPos[1], tbInfo.tbPos[2], tbInfo.tbPos[3])
      if pNpc then
        tbInfo.nNpcId = nNpcId
        tbInfo.nNpcDwId = pNpc.dwId
        tbInfo.nLiving = 1
        local tbBaby = self.MONSTER_BABY[nNpcId]
        for _, tbLife in ipairs(tbBaby or {}) do
          pNpc.AddLifePObserver(tbLife.nPercent)
        end
        pNpc.SetLoseItemCallBack(1)
      end
    end
    nCount = nCount + 1
    if nCount >= self.MAX_MONSTER then
      break
    end
  end

  return self.TIMER_MONSTER * Env.GAME_FPS
end

-- 移动怪
function Atlantis:TimerMover()
  for i, tbPos in ipairs(self.MAP_MOVER_POS) do
    if MathRandom(1, 10000) <= self.MOVER_RATE and self.nMoverCount < self.MAX_MOVER then
      local pNpc = KNpc.Add2(self.NPC_MOVER_ID, self.NPC_LEVEL, -1, tbPos[1], tbPos[2], tbPos[3])
      if pNpc then
        self.nMoverCount = self.nMoverCount + 1
      end
    end
  end
  return self.TIMER_MOVER * Env.GAME_FPS
end

-- boss
--function Atlantis:TimerBoss()
--
--	if not self.tbBoss.nBossDwId and MathRandom(1, 10000) <= self.BOSS_RATE and self.tbBoss.nTotal < self.MAX_DAY_BOSS then
--		local tbPos = self.MAP_BOSS_POS[MathRandom(1, #self.MAP_BOSS_POS)];
--		local pNpc = KNpc.Add2(self.NPC_BOSS_ID, self.NPC_LEVEL, -1, tbPos[1], tbPos[2], tbPos[3]);
--		if pNpc then
--			self.tbBoss.nBossDwId = pNpc.dwId;
--			self.tbBoss.nTotal = (self.tbBoss.nTotal or 0) + 1;
--			local szMsg = string.format("%s出现了，大家快去找找吧！", pNpc.szName);
--			self:BroadCast(self.MSG_BOTTOM, szMsg);
--			self:BroadCast(self.MSG_CHANNEL, szMsg);
--		end
--	end
--	return self.TIMER_BOSS * Env.GAME_FPS;
--end

-- 守护
function Atlantis:TimerDeamon()
  self.nDropRate = self:GetTimeRate() * self:GetPlayerRate()
  return self.TIMER_DEAMON * Env.GAME_FPS
end

-- new boss
function Atlantis:FreshBoss_GS()
  if SubWorldID2Idx(self.MAP_ID) < 0 then
    return 0
  end
  local nRand = MathRandom(1, 1200)
  Timer:Register(nRand * Env.GAME_FPS, self.TimerFreshBoss, self)
end

function Atlantis:TimerFreshBoss()
  if SubWorldID2Idx(self.MAP_ID) < 0 then
    return 0
  end
  local tbPos = self.MAP_BOSS_POS[MathRandom(1, #self.MAP_BOSS_POS)]
  local pNpc = KNpc.Add2(self.NPC_BOSS_ID, self.NPC_LEVEL, -1, tbPos[1], tbPos[2], tbPos[3])
  if pNpc then
    local szMsg = string.format("%s出现了，大家快去找找吧！", pNpc.szName)
    self:BroadCast(self.MSG_BOTTOM, szMsg)
    self:BroadCast(self.MSG_CHANNEL, szMsg)
  end
  return 0
end

-------------------------------------------------------
-- 怪物相关
-------------------------------------------------------

-- 添加附属怪
function Atlantis:OnAddMonsterBaby(nMonsterDwId, nBabyDwId)
  local tbInfo = self:GetMonsterById(nMonsterDwId)
  if tbInfo then
    if not tbInfo.tbBaby then
      tbInfo.tbBaby = {}
    end
    table.insert(tbInfo.tbBaby, nBabyDwId)
  end
end

-- 精英怪死亡
function Atlantis:OnMonsterDeath(pMonster)
  local tbInfo = self:GetMonsterById(pMonster.dwId)
  if tbInfo then
    for _, nBabyDwId in pairs(tbInfo.tbBaby or {}) do
      local pNpc = KNpc.GetById(nBabyDwId)
      if pNpc then
        pNpc.Delete()
      end
    end
    tbInfo.nLiving = 0
  end
end

-- 随机怪死亡
function Atlantis:OnMoverDeath(pMover)
  if self.nMoverCount > 0 then
    self.nMoverCount = self.nMoverCount - 1
  end

  local nRand = MathRandom(1, 10000)
  if nRand <= self.EQUIP_RATE and self.nEquipCount < self.MAX_EQUIP then
    local nMapId, nMapX, nMapY = pMover.GetWorldPos()
    local pNpc = KNpc.Add2(self.NPC_EQUIP_ID, self.NPC_LEVEL, -1, nMapId, nMapX, nMapY)
    if pNpc then
      local szMsg = "<color=yellow>在一道耀眼的光芒闪过之后，神器诞生于这片广袤的土地上！<color>"
      self:BroadCast(self.MSG_BOTTOM, szMsg)
      self:BroadCast(self.MSG_CHANNEL, szMsg)
      self.nEquipCount = self.nEquipCount + 1
      for i = 1, self.nEquipCount do
        if not self.tbStar[i] then
          local tbPos = self.MAP_STAR_POS[i]
          local pStar = KNpc.Add2(self.NPC_STAR_ID, self.NPC_LEVEL, -1, tbPos[1], tbPos[2], tbPos[3])
          if pStar then
            self.tbStar[i] = pStar.dwId
          end
        end
      end
    end
  end
end

-- 启动事件
function Atlantis:StartEvent()
  if self:CheckIsOpen() == 1 then
    self:OpenSystem_GS()
  end
end

-- 每日事件
function Atlantis:PlayerDailyEvent()
  if me.nMapId == self.MAP_ID and me.GetCamp() ~= 6 then
    if self.tbPlayerList[me.szName] then
      self:OpenRightUI(me, self.MAX_TIME * Env.GAME_FPS)
    else
      self:SafeLeave(me)
    end
  end
  me.SetTask(self.TASK_GID, self.TASK_USE_TIME, 0)
end

-- 批量记录
function Atlantis:ServerDailyEvent_GS()
  for szPlayerName, _ in pairs(self.tbPlayerList) do
    local pPlayer = KPlayer.GetPlayerByName(szPlayerName)
    if pPlayer and pPlayer.GetCamp() ~= 6 then
      local nUseTime = pPlayer.GetTask(self.TASK_GID, self.TASK_USE_TIME)
      StatLog:WriteStatLog("stat_info", "loulangucheng", "leave", pPlayer.nId, pPlayer.GetHonorLevel(), nUseTime)
    end
  end
  Dbg:WriteLog("Atlantis", "楼兰古城", string.format("时间：%s，掉落总次数：%s", GetLocalDate("%Y%m%d"), self._nTotalDropTimes or 0))
end

function Atlantis:OpenSystem_GS()
  if SubWorldID2Idx(self.MAP_ID) < 0 then
    return 0
  end

  ClearMapNpc(self.MAP_ID)

  for szType, _ in pairs(self.tbTimerId) do
    self:ClearTimer(szType)
  end

  KDialog.NewsMsg(0, Env.NEWSMSG_NORMAL, "在一片神秘的光耀中，楼兰古城浮现出巍峨的轮廓。")

  self.nMoverCount = 0
  self.nEquipCount = 0
  self.nDropRate = self.nDropRate or 1

  self.tbMonster = {}
  self.tbBoss = { nTotal = 0 }

  for i, tbPos in ipairs(self.MAP_MONSTER_POS) do
    self.tbMonster[i] = {}
    self.tbMonster[i].tbPos = tbPos
    self.tbMonster[i].nLiving = 0
  end

  -- 玩家 Timer
  self:StartTimer(self.TIMER_PLAYER, self.TimerPlayer, "player")

  -- 精英怪 Timer
  self:StartTimer(self.TIMER_MONSTER, self.TimerMonster, "monster")

  -- Boss Timer
  --	self:StartTimer(self.TIMER_BOSS, self.TimerBoss, "boss");

  -- deamon Timer
  self:StartTimer(self.TIMER_DEAMON, self.TimerDeamon, "deamon")

  -- 移动怪 Timer
  self:StartTimer(self.TIMER_MOVER, self.TimerMover, "mover")

  self._Open = 1
end

function Atlantis:CloseSystem_GS()
  if SubWorldID2Idx(self.MAP_ID) < 0 then
    return 0
  end

  ClearMapNpc(self.MAP_ID)

  for szType, _ in pairs(self.tbTimerId) do
    self:ClearTimer(szType)
  end

  KDialog.NewsMsg(0, Env.NEWSMSG_NORMAL, "在一片神秘的光耀中，楼兰古城凭空消失了。")

  for szPlayerName, _ in pairs(self.tbPlayerList) do
    local pPlayer = KPlayer.GetPlayerByName(szPlayerName)
    if pPlayer then
      self:SafeLeave(pPlayer)
    end
  end

  self._Open = 0
end

-- 玩家死亡回调
function Atlantis:OnPlayerDeath(pKillerNpc)
  if me.nMapId ~= self.MAP_ID or me.GetCamp() == 6 then
    return 0
  end

  local pKillerPlayer = pKillerNpc.GetPlayer()
  if pKillerPlayer then
    if self.tbPlayerList[pKillerPlayer.szName] then
      self.tbPlayerList[pKillerPlayer.szName].nKillCount = self.tbPlayerList[pKillerPlayer.szName].nKillCount + 1
    end
    self:SendMessage(pKillerPlayer, self.MSG_MIDDLE, string.format("您将<color=yellow>%s<color>击为重伤！", me.szName))
    self:SendMessage(pKillerPlayer, self.MSG_CHANNEL, string.format("您将神秘人的面纱撕开后，赫然发现他竟是<color=yellow>%s<color>！", me.szName))
    KTeam.Msg2Team(pKillerPlayer.nTeamId, string.format("[%s]将敌人[%s]击为重伤！", pKillerPlayer.szName, me.szName))
    KTeam.Msg2Team(me.nTeamId, string.format("[%s]被敌人击为重伤！现已被抢救回商队营地", me.szName))
    self:SendMessage(me, self.MSG_BOTTOM, "你被一个蒙面的夺宝者所击伤，经商队的郎中抢救后已经无恙！")

    Dbg:WriteLog("Atlantis", "楼兰古城", string.format("击杀者：%s，披风等级：%s，门派：%s，路线：%s", pKillerPlayer.szName, self:GetMantleLevel(pKillerPlayer), pKillerPlayer.nFaction, pKillerPlayer.nRouteId), string.format("被杀者：%s，披风等级：%s，门派：%s，路线：%s", me.szName, self:GetMantleLevel(me), me.nFaction, me.nRouteId))

    StatLog:WriteStatLog("stat_info", "loulangucheng", "pvp", me.nId, me.GetHonorLevel(), self:GetMantleLevel(me), me.nFaction, me.nRouteId, self:CheckHaveSuper(me.szName), pKillerPlayer.szAccount, pKillerPlayer.szName, pKillerPlayer.GetHonorLevel(), self:GetMantleLevel(pKillerPlayer), pKillerPlayer.nFaction, pKillerPlayer.nRouteId, self:CheckHaveSuper(pKillerPlayer.szName))
  else
    StatLog:WriteStatLog("stat_info", "loulangucheng", "npckillrole", me.nId, me.GetHonorLevel(), self:GetMantleLevel(me), me.nFaction, me.nRouteId, self:CheckHaveSuper(me.szName), pKillerNpc.nTemplateId)
  end

  --	self:PlayerLostChip(me, pKillerPlayer);
  self:PlayerLostEquip(me, "drop")

  me.ReviveImmediately(1)
  me.SetFightState(0)

  if not self.tbPlayerList[me.szName] then
    self:SafeLeave(me)
  else
    me.NewWorld(unpack(self.REVIVAL_LIST[MathRandom(1, #self.REVIVAL_LIST)]))
  end
end

-- 玩家登陆回调
function Atlantis:OnPlayerLogin()
  if me.GetTask(self.TASK_GID, self.TASK_PROTECT) == 1 then
    self:PlayerLostEquip(me)
    Partner:SetForbitOut(me, 0)
    --		self:PlayerLostChip(me, nil, "clear");
    self:SafeLeave(me)
  else
    if me.GetTask(2093, 37) == 0 then
      for _, tbInfo in pairs(self.ITEM_EQUIP_ID) do
        for _, tbItemId in pairs(tbInfo) do
          local tbFind = GM:GMFindAllRoom(tbItemId)
          for _, tbItem in pairs(tbFind or {}) do
            local szName = tbItem.pItem.szName
            local nEnchane = tbItem.pItem.nEnhTimes
            if me.DelItem(tbItem.pItem) == 1 then
              Dbg:WriteLog("Atlantis", "DelItem", me.szName, szName, nEnchane)
            end
          end
        end
      end
      me.SetTask(2093, 37, 1)
    end
  end
end

function Atlantis:SafeLeave(pPlayer)
  pPlayer.SetFightState(0)
  pPlayer.SetLogoutRV(0)
  pPlayer.SetTask(self.TASK_GID, self.TASK_PROTECT, 0)
  pPlayer.NewWorld(unpack(self.MAP_CITY_POS))
end

-- 注册玩家每日事件
PlayerSchemeEvent:RegisterGlobalDailyEvent({ Atlantis.PlayerDailyEvent, Atlantis })

-- 注册启动事件
ServerEvent:RegisterServerStartFunc(Atlantis.StartEvent, Atlantis)

-- 注册死亡事件
if Atlantis.nEventDeathId then
  PlayerEvent:UnRegisterGlobal("OnDeath", Atlantis.nEventDeathId)
end
Atlantis.nEventDeathId = PlayerEvent:RegisterGlobal("OnDeath", Atlantis.OnPlayerDeath, Atlantis)

-- 注册登陆事件
if Atlantis.nEventLoginId then
  PlayerEvent:UnRegisterGlobal("OnLoginOnly", Atlantis.nEventLoginId)
end
Atlantis.nEventLoginId = PlayerEvent:RegisterGlobal("OnLoginOnly", Atlantis.OnPlayerLogin, Atlantis)

function Atlantis:_Test()
  me.Msg("地图人数：" .. self:GetMapPlayerCount())
  me.Msg("地图队伍：" .. Lib:CountTB(self.tbTeamList))
  me.Msg("掉落次数：" .. self:GetCurDropTimes())
  me.Msg("地图神兵：" .. self.nEquipCount)
  me.Msg("地图羊羊：" .. self.nMoverCount)
end
