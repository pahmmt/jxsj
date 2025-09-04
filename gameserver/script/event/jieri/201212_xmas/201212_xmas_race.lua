------------------------------------------------------
-- 文件名　：201212_xmas_race.lua
-- 创建者　：dengyong
-- 创建时间：2012-11-30 10:13:34
-- 描  述  ：12年双旦活动----拉雪橇
------------------------------------------------------

SpecialEvent.Xmas2012 = SpecialEvent.Xmas2012 or {}
local Xmas2012 = SpecialEvent.Xmas2012

Xmas2012.TRAP_TREE = 1
Xmas2012.TRAP_STAR = 2

Xmas2012.STAR_TRAP_YELLOW = 1 -- 黄星，收集
Xmas2012.STAR_TRAP_RED = 2 -- 红星，减速
Xmas2012.STAR_TRAP_PURPLE = 3 -- 紫星，传送
Xmas2012.STAR_TRAP_BLUE = 4 -- 蓝星，冰冻
Xmas2012.STAR_TRAP_GREEN = 5 -- 绿星，加速

Xmas2012.LEFTUP = 1 -- 左上
Xmas2012.UP = 2 -- 上
Xmas2012.RIGHTUP = 3 -- 右上
Xmas2012.LEFT = 4 -- 左
Xmas2012.STOP = 5 --
Xmas2012.RIGHTUP = 6 -- 右
Xmas2012.LEFTDOWN = 7 -- 左下
Xmas2012.DOWN = 8 -- 下
Xmas2012.RIGHTDOWN = 9 -- 右下
Xmas2012.OPERATE_CD = 1 -- 操作CD，单位秒
-- 操作键到dir的对应表
Xmas2012.tbOperToDir = { 3, 4, 5, 2, -1, 6, 1, 0, 7 }

Xmas2012.SKILL_DISGUISE_ID = 2764 -- 易容ID
Xmas2012.SKILL_DISGUISE_LEVEL = 45 -- 易容等级
Xmas2012.SKILL_SPEEDDOWN_ID = 2175 -- 减速ID
Xmas2012.SKILL_SPEEDDOWN_LEVEL = 5 -- 减速等级
Xmas2012.SKILL_SPEEDUP_ID = 2929 -- 加速ID
Xmas2012.SKILL_SPEEDUP_LEVEL = 5 -- 回事等级
Xmas2012.STATE_TIME_SPEEDDOWN = 18 * 5 -- 状态时间
Xmas2012.STATE_TIME_FREEZE = 18 * 5
Xmas2012.STATE_TIME_SPEEDUP = 18 * 8

Xmas2012.TRAP_PATH = "\\setting\\event\\jieri\\201212_xmas\\" -- 路径
Xmas2012.TRAP_FILE = "trap_setting.txt"
Xmas2012.SHOW_NPC_FILE = "npc_show.txt" -- 装饰NPC表
Xmas2012.LAST_TREE_SEQ = 8 -- 最后一颗树的序列ID
Xmas2012.MAP_ID = 28 -- 赛道所在城市，大理
Xmas2012.tbMapId = { 28, 26 }
Xmas2012.TSK_GROUP = 2215 -- 上次参加比赛天数的主任务变量
Xmas2012.TSK_SUB_DAY = 2 -- 上次参加比赛天数的子任务变量
Xmas2012.TSK_SUB_AWARD = 3 -- 上次参加比赛未领取的奖励
Xmas2012.STAR_RAND_GROUP = 8 -- 随机出来group数
Xmas2012.tbStarRandColor = { Xmas2012.STAR_TRAP_RED, Xmas2012.STAR_TRAP_BLUE }
Xmas2012.tbColorStr = { "yellow", "red", "purple", "blue", "green" }
Xmas2012.NPC_TEMPLATE_TREE = 11312 --3470;	-- 圣诞树NPC
Xmas2012.tbStarNpcTemplate = { 11282, 11283, 11286, 11284, 11285 } -- 黄、红、紫、蓝、绿
Xmas2012.RACE_LIMIT_TIME = 60 * 5 * 18 -- 限时5分钟
Xmas2012.RACE_MSG_TIP = "<color=pink>收集黄星星数量：<color=white>%d\n"
Xmas2012.RACE_MSG_TIME = "<color=pink>剩余时间：<color=white>%s<color><color>\n"
Xmas2012.LADDER_MAX_COUNT = 10 -- 每天只统计前10名的
Xmas2012.DEFAULT_DIR = 56 -- 初始行走方向
Xmas2012.NPC_START = 11313
Xmas2012.NPC_END = 11314
Xmas2012.RACE_LEVEL_LIMIT = 50
Xmas2012.HIGHER_AWARD_SCORE = 90
Xmas2012.tbStarRandRate = {
  { Xmas2012.STAR_TRAP_PURPLE, 5 },
  { Xmas2012.STAR_TRAP_BLUE, 7 },
  { Xmas2012.STAR_TRAP_GREEN, 8 },
  { Xmas2012.STAR_TRAP_RED, 10 },
  { Xmas2012.STAR_TRAP_YELLOW, 70 },
}
Xmas2012.tbDialogNpc = {
  [28] = {
    { 11313, 1420, 3274 },
    { 11314, 1701, 3282 },
  },
  [26] = {
    { 11313, 1614, 3193 },
    { 11314, 1726, 3140 },
  },
}
Xmas2012.tbAwardItem = {
  { 18, 1, 1877, 1 },
  { 18, 1, 1878, 1 },
}
Xmas2012.tbAwardValue = {
  255000,
  345000,
}

-- 因为多地图的原因，该函数的调用一定要在地图加载完毕之后！！！
function Xmas2012:StartRaceEvent()
  self:Init()

  -- 添加装饰NPC
  local tbFile = Lib:LoadTabFile(self.TRAP_PATH .. self.SHOW_NPC_FILE)
  assert(tbFile, "File[" .. self.SHOW_NPC_FILE .. "] load failed!")
  for _, tbData in pairs(tbFile) do
    local nMapId = tonumber(tbData.Mapid)
    local nNpcId = tonumber(tbData.NPCID)
    local X = tonumber(tbData.posx)
    local Y = tonumber(tbData.posy)

    if IsMapLoaded(nMapId) == 1 then
      local pNpc = KNpc.Add2(nNpcId, 1, -1, nMapId, X, Y)
      if pNpc then
        self.tbAddedNpc[nNpcId] = 1
      end
    end
  end

  -- 添加对话NPC
  for nMapId, tbInfo in pairs(self.tbDialogNpc) do
    if IsMapLoaded(nMapId) == 1 then
      for _, tbNpc in pairs(tbInfo) do
        KNpc.Add2(tbNpc[1], 1, -1, nMapId, tbNpc[2], tbNpc[3])
      end
    end
  end
end

function Xmas2012:Init()
  self.nPlayerIn = 0 -- 当前正在系统中的玩家
  self.bTreeTrapInited = 0
  self.bInRacing = 0
  self.tbLadder = {} -- 历史排行榜
  self.tbStarTraps = {} -- 星星trap点
  self.tbTreeTraps = {} -- 圣诞树trap点
  self.tbStarSetting = {} -- 星星trap点配置
  self.tbAddedNpc = {} -- 用来记录一些添加过的活动NPC，活动结束后删除

  self:LoadTrapsSetting()
end

-- 重刷trap点及NPC
function Xmas2012:PreDayRaceStart()
  self:ResetRunway()
end

-- 置当天活动开关，打开
function Xmas2012:OnDayRaceStart()
  self.bInRacing = 1 -- 开启
  --self:ResetRunway();
end

-- 置当天活动开关，关闭
function Xmas2012:OnDayRaceEnd()
  self.bInRacing = 0 -- 结束了
end

function Xmas2012:PostDayRaceEnd()
  for _, nMapId in pairs(self.tbMapId) do
    if IsMapLoaded(nMapId) then
      -- 清除动态trap
      self:ClearTraps(nMapId)
    end
  end
end

function Xmas2012:LoadTrapsSetting()
  -- 一个trapname对应多个trap点
  local tbFile = Lib:LoadTabFile(self.TRAP_PATH .. self.TRAP_FILE)
  assert(tbFile, "File[" .. self.TRAP_FILE .. "] load failed!")

  for _, tbData in pairs(tbFile) do
    local szTrapName = tbData.TrapName
    local szPosFile = tbData.PosFile
    local nTrapType = tonumber(tbData.TrapType)
    local nParam = tonumber(tbData.Param)
    local nMapId = tonumber(tbData.Map)

    self.tbTreeTraps[nMapId] = self.tbTreeTraps[nMapId] or {}
    self.tbStarSetting[nMapId] = self.tbStarSetting[nMapId] or {}

    local tbTreeTraps = self.tbTreeTraps[nMapId]
    local tbStarSetting = self.tbStarSetting[nMapId]

    -- 只保留本GS已加载地图的数据
    if IsMapLoaded(nMapId) == 1 then
      if nTrapType == self.TRAP_TREE then
        if not self.tbTreeTraps[szTrapName] then
          tbTreeTraps[szTrapName] = {}
          tbTreeTraps[szTrapName].nParam = nParam
        end

        local tbPosFile = Lib:LoadTabFile(self.TRAP_PATH .. szPosFile)
        for _, tbPos in pairs(tbPosFile) do
          local X = tonumber(tbPos.X)
          local Y = tonumber(tbPos.Y)
          local bCenter = tonumber(tbPos.bCenter)
          table.insert(tbTreeTraps[szTrapName], { X, Y, bCenter })
        end
      elseif nTrapType == self.TRAP_STAR then
        self:LoadStarTraps(szPosFile, tbStarSetting)
      else
        assert(false, "error trap type")
      end
    end
  end
end

function Xmas2012:LoadStarTraps(szFile, tbStarSetting)
  local szFullPath = self.TRAP_PATH .. szFile
  local tbFile = Lib:LoadTabFile(szFullPath)
  assert(tbFile, "File[" .. szFullPath .. "] load failed!")

  for _, tbData in pairs(tbFile) do
    local szType = tbData.Type
    local X = tonumber(tbData.X)
    local Y = tonumber(tbData.Y)
    local nGroup = tonumber(tbData.Group)
    local nRand = tonumber(tbData.Rand)

    tbStarSetting[szType] = tbStarSetting[szType] or {}
    --tbStarSetting[nRand] = tbStarSetting[nRand] or {};
    --tbStarSetting[nRand][nGroup] = tbStarSetting[nRand][nGroup] or {};
    --tbStarSetting[nRand][nGroup][szType] = tbStarSetting[nRand][nGroup][szType] or {};
    local tb = {}
    tb[1] = { X, Y, 1 } -- 第三个值1表示中心点，0表示非中心点
    -- 配置表只填写了中心trap点，脚本自动填充周围3个点
    tb[2] = { X - 1, Y - 1, 0 } -- 左上
    tb[3] = { X, Y - 1, 0 } -- 上
    tb[4] = { X - 1, Y, 0 } -- 左
    --tb[5] = {X + 1, Y - 1, 	0};	-- 右上
    --tb[6] = {X + 1, Y, 		0};	-- 右
    --tb[7] = {X - 1, Y + 1, 	0};	-- 左下
    --tb[8] = {X,     Y + 1, 	0};	-- 下
    --tb[9] = {X + 1, Y + 1, 	0};	-- 右下

    table.insert(tbStarSetting[szType], tb)
  end
end

function Xmas2012:CheckCanRace(pPlayer)
  -- 活动是否开启了
  if self.bInRacing == 0 then
    return 0, "2012年12月18日至2013年1月3日，<color=yellow>每天11:00-23:00<color>活动方才开启"
  end

  -- 等级大于50
  if pPlayer.nLevel < self.RACE_LEVEL_LIMIT then
    return 0, "等级大于或等于50级的侠客才可参加此活动。"
  end

  -- 组队不能参加
  if me.GetTeamId() then
    return 0, "组队状态下不能参加！"
  end

  -- 快结束了，不能参加

  -- 今天是否已经参加过了
  local nDay = Lib:GetLocalDay(GetTime())
  local nLastDay = pPlayer.GetTask(self.TSK_GROUP, self.TSK_SUB_DAY)
  if nLastDay >= nDay then
    return 0, "您今天已经参加过此活动，请明日再来吧！"
  end

  local nAward = pPlayer.GetTask(self.TSK_GROUP, self.TSK_SUB_AWARD)
  if nAward ~= 0 then
    return 0, "您还有奖励未领取，请先领取。"
  end

  return 1
end

-- TODO:根据当前正在参加活动的人数做人数限制
function Xmas2012:StartRaceOnPlayer(pPlayer)
  -- 记录今天已经参加
  pPlayer.SetTask(self.TSK_GROUP, self.TSK_SUB_DAY, Lib:GetLocalDay(GetTime()))

  -- 变身成圣诞老人
  pPlayer.AddSkillState(self.SKILL_DISGUISE_ID, self.SKILL_DISGUISE_LEVEL, 0, 18 * 3600, 0, 0, 0, 0, 1)
  pPlayer.SetTask(2192, 34, GetTime()) -- 为了跨地图时能保留
  pPlayer.SetTask(2192, 44, self.SKILL_DISGUISE_LEVEL) -- 为了跨地图时能保留
  -- 下马先
  pPlayer.RideHorse(0)
  -- 赛跑期间禁止使用道具
  pPlayer.SetForbidUseItem(1)
  -- 设置禁止使用传送功能
  pPlayer.LimitTrans(1)
  -- 禁止组队
  pPlayer.DisabledTeam(1)
  --pPlayer.LockClientInput();
  --pPlayer.GetNpc().DoCommand(28, self.DEFAULT_DIR)

  -- 初始化数据表
  -- 操作CD表、TRAP触发表、
  local tbRaceInfo = {}
  tbRaceInfo.bRacing = 1
  tbRaceInfo.nStarTime = GetTime()
  tbRaceInfo.nScore = 0
  tbRaceInfo.nLastDir = self.DEFAULT_DIR
  tbRaceInfo.nTimer = Timer:Register(self.RACE_LIMIT_TIME, self.OnRaceTimeOut, self, pPlayer.nId)
  self:SetPlayerRaceInfo(pPlayer, tbRaceInfo)

  -- 通知UI
  self:OpenMsgUi(pPlayer)
  self:UpdateMsgUi(pPlayer, tbRaceInfo.nScore)
  --pPlayer.CallClientScript({"UiManager:OpenWindow", "UI_XMAS_CTRL"});
  Dialog:SendBlackBoardMsg(pPlayer, "开始！请在<color=pink>5分钟内<color>按<color=pink>派送路牌<color>指示前往<color=pink>8棵圣诞树<color>派送礼物")

  -- 埋点
  StatLog:WriteStatLog("stat_info", "shengdanjie_2012", "sled_start", pPlayer.nId, 1)
end

function Xmas2012:OnPlayerRaceEnd(pPlayer, bFailed)
  bFailed = bFailed or 0

  pPlayer.RemoveSkillState(self.SKILL_DISGUISE_ID)
  --pPlayer.UnLockClientInput();
  --pPlayer.GetNpc().DoCommand(28, -1);

  -- 成功完成了才计算积分
  if bFailed == 0 then
    local nScore = self:ComputePlayerScore(pPlayer)
    -- 根据积分设置奖励
    local nAward = 1
    if nScore >= self.HIGHER_AWARD_SCORE then
      nAward = 2
    end
    pPlayer.SetTask(self.TSK_GROUP, self.TSK_SUB_AWARD, nAward)
    --self:UpdateMyScoreToLadder(pPlayer);
  end

  local tbRaceInfo = self:GetPlayerRaceInfo(pPlayer)
  if tbRaceInfo.nTimer and tbRaceInfo.nTimer ~= 0 then
    Timer:Close(tbRaceInfo.nTimer)
    tbRaceInfo.nTimer = nil
  end
  self:SetPlayerRaceInfo(pPlayer, nil)

  -- 可以使用道具
  pPlayer.SetForbidUseItem(0)
  -- 可以使用传送功能
  pPlayer.LimitTrans(0)
  -- 恢复可以组队
  pPlayer.DisabledTeam(0)

  -- 关闭界面
  self:CloseMsgUi(pPlayer)
  pPlayer.CallClientScript({ "UiManager:CloseWindow", "UI_XMAS_CTRL" })
end

function Xmas2012:OnRaceTimeOut(nPlayerId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return 0
  end

  Dialog:SendBlackBoardMsg(pPlayer, "很遗憾时间已结束，你此次派送失败。")
  self:OnPlayerRaceEnd(pPlayer, 1)
  return 0
end

function Xmas2012:UpdateMyScoreToLadder(pPlayer)
  local nScore = self:ComputePlayerScore(pPlayer)
  if not nScore or nScore == 0 then
    return
  end

  local nDay = Lib:GetLocalDay(GetTime())
  self.tbLadder[nDay] = self.tbLadder[nDay] or {}
  local bBreak = 0
  for i, tbInfo in pairs(self.tbLadder[nDay]) do
    if tbInfo[2] < nScore then
      table.insert(self.tbLadder[nDay][i], { pPlayer.szRoleId, nScore })
      bBreak = 1
      break
    end
  end

  if #self.tbLadder[nDay] < self.LADDER_MAX_COUNT and bBreak == 0 then
    table.insert(self.tbLadder[nDay], { pPlayer.szRoleId, nScore })
  end

  if #self.tbLadder[nDay] > self.LADDER_MAX_COUNT then
    table.remove(self.tbLadder[nDay], self.LADDER_MAX_COUNT + 1)
  end
end

function Xmas2012:ComputePlayerScore(pPlayer)
  local tbRaceInfo = self:GetPlayerRaceInfo(pPlayer)
  local nStarTime = tbRaceInfo.nStarTime
  local nUseTime = GetTime() - nStarTime

  local nScore = tbRaceInfo.nScore or 0
  nScore = nScore + math.floor((self.RACE_LIMIT_TIME / 18 - nUseTime) / 5)

  return nScore
end

function Xmas2012:ResetRunway()
  local _pairs, _type = pairs, type

  -- 随机星星trap点及type
  self:RandStarTrap()

  local nTreeTrapInited = 0
  for _, nMapId in _pairs(self.tbMapId) do
    if IsMapLoaded(nMapId) == 1 then
      -- 清除动态trap
      self:ClearTraps(nMapId)

      local tbMap = Map:GetClass(nMapId)

      -- 添加圣诞树所在点的trap
      for szTrapName, tbInfo in _pairs(self.tbTreeTraps[nMapId] or {}) do
        for _, tbPos in _pairs(tbInfo) do
          if _type(tbPos) == "table" then
            self:AddTrap(nMapId, self.TRAP_TREE, szTrapName, tbPos)
          end
        end
        if self.bTreeTrapInited == 0 then
          local tbTrap = tbMap:GetTrapClass(szTrapName)
          function tbTrap:OnPlayer()
            Xmas2012:OnPlayerTrap(self.szName, Xmas2012.TRAP_TREE)
          end
        end
      end
      nTreeTrapInited = 1

      for szTrapName, tbInfo in _pairs(self.tbStarTraps[nMapId] or {}) do
        for i, tbPos in _pairs(tbInfo) do
          if _type(tbPos) == "table" then
            self:AddTrap(nMapId, self.TRAP_STAR, szTrapName, tbPos)
          end
        end

        -- 注册响应函数
        local tbTrap = tbMap:GetTrapClass(szTrapName)
        function tbTrap:OnPlayer()
          Xmas2012:OnPlayerTrap(self.szName, Xmas2012.TRAP_STAR)
        end
      end
    end
  end

  self.bTreeTrapInited = nTreeTrapInited
end

function Xmas2012:AddTrap(nMapId, nTrapType, szTrapName, tbPos)
  AddMapTrap(nMapId, tbPos[1] * 32, tbPos[2] * 32, szTrapName)
  if tbPos[3] and tbPos[3] ~= 0 then -- 表示是中心点，添加形象NPC
    local nNpcTemplate = 0
    if nTrapType == self.TRAP_TREE then
      nNpcTemplate = self.NPC_TEMPLATE_TREE
    else
      local nStarColor = self:GetStarColorType(nMapId, szTrapName)
      nNpcTemplate = self.tbStarNpcTemplate[nStarColor] or 0
    end

    if nNpcTemplate == 0 then
      return
    end

    local pNpc = KNpc.Add2(nNpcTemplate, 1, -1, nMapId, tbPos[1], tbPos[2])
    if not pNpc then
      print("npc" .. nNpcTemplate .. "添加失败")
    --		elseif nTrapType == self.TRAP_STAR then
    --			pNpc.szName = szTrapName;
    elseif nTrapType == self.TRAP_TREE then
      local nSeq = self:GetTreeTrapSeq(nMapId, szTrapName)
      if nSeq and nSeq ~= 0 then
        pNpc.SetTitle(string.format("<color=pink>派送点%s<color>", Lib:Transfer4LenDigit2CnNum(nSeq)))
        pNpc.Sync()
      end
    end
  end
end

function Xmas2012:ClearTraps(nMapId)
  local _pairs = pairs

  ClearMapAdditionTrap(nMapId)

  -- 因为星星的类名都是动态的，所以要把原来注册的trap清掉
  local tbMap = Map:GetClass(nMapId)
  for szTrapName, _ in _pairs(self.tbStarTraps[nMapId] or {}) do
    if tbMap.tbTraps and tbMap.tbTraps[szTrapName] then
      tbMap.tbTraps[szTrapName] = nil -- 不清掉应当不会影响逻辑，只是内存会越来越大
    end
  end

  -- 把外观NPC也删除
  for _, nTemplate in _pairs(self.tbStarNpcTemplate) do
    ClearMapNpcWithTemplateId(nMapId, nTemplate)
  end
  ClearMapNpcWithTemplateId(nMapId, self.NPC_TEMPLATE_TREE)
end

function Xmas2012:RandStarTrap()
  local _pairs = pairs

  self.tbStarTraps = {}
  for _, nMapId in _pairs(self.tbMapId) do
    if IsMapLoaded(nMapId) == 1 then
      self:GeneralMapStarTrap(nMapId)
    end
  end
end

function Xmas2012:GeneralMapStarTrap(nMapId)
  local tbSetting = self.tbStarSetting[nMapId]
  local tbStarTraps = self.tbStarTraps[nMapId] or {}
  self.tbStarTraps[nMapId] = tbStarTraps
  if not tbSetting or not tbStarTraps then
    assert(false)
    return
  end

  local _pairs = pairs
  local szTrapName = ""

  for szType, tbData in _pairs(tbSetting or {}) do
    if szType == "rand" then -- 需要随机颜色的点
      local tbRandInfo = { unpack(tbData) }
      for _, tbInfo in _pairs(self.tbStarRandRate) do
        local nCount = math.ceil(#tbRandInfo * tbInfo[2] / 100)
        local tbGroup = self:RandNElememtFromTB(tbData, nCount)
        local szColor = self.tbColorStr[tbInfo[1]]
        for nIndex, tbPos in _pairs(tbGroup) do
          szTrapName = string.format("star_%s_rand_%d", szColor, nIndex)
          tbStarTraps[szTrapName] = tbStarTraps[szTrapName] or {}
          for i, pos in _pairs(tbPos) do
            tbStarTraps[szTrapName][i] = pos
          end
          tbStarTraps[szTrapName].szColor = szColor
        end
      end
    else -- 固定颜色的点
      for nIndex, tbPos in _pairs(tbData) do
        szTrapName = string.format("star_%s_%d", szType, nIndex)
        tbStarTraps[szTrapName] = tbStarTraps[szTrapName] or {}
        for i, pos in _pairs(tbPos) do
          tbStarTraps[szTrapName][i] = pos
        end
        tbStarTraps[szTrapName].szColor = szType
      end
    end
  end
end

-- 从指定表中随机N个元素出来，tb必须是以自然数作为索引下标的
-- 返回值：tbRet, N个从tb中随机出来的索引下标
-- 注意，随机过程中是直接操作参数1的，参数1的表会发生改变
function Xmas2012:RandNElememtFromTB(tb, n)
  --	local tbRand = {};
  --	for i = 1, #tb do
  --		tbRand[i] = i;
  --	end

  local tbRet = {}

  while n > 0 do
    local nRand = MathRandom(1, #tb)
    tbRet[#tbRet + 1] = tb[nRand]
    table.remove(tb, nRand)
    n = n - 1

    if #tb == 0 then
      break
    end
  end

  return tbRet
end

function Xmas2012:IsPlayerInRace(pPlayer)
  local tbRaceInfo = self:GetPlayerRaceInfo(pPlayer)
  return tbRaceInfo.bRacing or 0
end

function Xmas2012:GetPlayerRaceInfo(pPlayer)
  -- nLastPassTree  上次有效经过的树ID
  -- tbPassStar  	  已经经过的星星
  -- nLastOper	  上次操作时间
  -- nLastDir		  上次操作方向(64向的，其中负数表示停止)
  -- bRacing 		  是否在比赛中
  -- nStarTime 	  比赛开始时间
  -- nScore		  比赛积分
  -- nTimer		  比赛结束timer
  return pPlayer.GetTempTable("SpecialEvent").tbRaceInfo or {}
end

function Xmas2012:SetPlayerRaceInfo(pPlayer, tbInfo)
  pPlayer.GetTempTable("SpecialEvent").tbRaceInfo = tbInfo
end

function Xmas2012:UpdatePlayerRaceInfo() end

-- 客户端操作处理接口
function Xmas2012:ApplyClientOperate(nOpreate)
  if true or self:IsPlayerInRace(me) == 0 then
    return
  end

  local tbRaceInfo = self:GetPlayerRaceInfo(me)
  --tbRaceInfo.tbCDInfo = tbRaceInfo.tbCDInfo or {};
  --local nLastOper = tbRaceInfo.tbCDInfo[nOpreate] or 0;

  local nCurTime = GetTime()
  local nLastOper = tbRaceInfo.nLastOper or 0
  if nLastOper + self.OPERATE_CD > nCurTime then
    -- UI提示
    return
  end

  local nDir = self.tbOperToDir[nOpreate] * 8
  me.GetNpc().DoCommand(28, nDir) -- 向指向方向移动
  if nDir >= 0 then -- 是转向的话要加个减速BUF，停止不用加
    me.AddSkillState(self.SKILL_SPEEDDOWN_ID, self.SKILL_SPEEDDOWN_LEVEL, 1, self.STATE_TIME, 0, 0, 0, 0, 1) -- 减速BUFF
  end

  -- 可以操作
  tbRaceInfo.nLastOper = nCurTime
  tbRaceInfo.nLastDir = nDir
  self:SetPlayerRaceInfo(me, tbRaceInfo)
end

-- 相关trap回调
function Xmas2012:OnPlayerTrap(szTrapName, nTrapType)
  if self:IsPlayerInRace(me) == 0 then
    return
  end

  local nMapId = me.nMapId
  local tbRaceInfo = self:GetPlayerRaceInfo(me)
  tbRaceInfo.tbPassStar = tbRaceInfo.tbPassStar or {}
  tbRaceInfo.nLastPassTree = tbRaceInfo.nLastPassTree or 0

  if nTrapType == self.TRAP_STAR then
    if not self.tbStarTraps[nMapId][szTrapName] then
      return
    end

    if tbRaceInfo.tbPassStar[szTrapName] then
      return
    end

    tbRaceInfo.tbPassStar[szTrapName] = 1
  end

  if nTrapType == self.TRAP_TREE then -- 树的经历顺序必须按顺序来
    if not self.tbTreeTraps[nMapId][szTrapName] then
      return
    end

    local nTreeSeq = self:GetTreeTrapSeq(me.nMapId, szTrapName)
    if nTreeSeq ~= tbRaceInfo.nLastPassTree + 1 then
      return
    end

    tbRaceInfo.nLastPassTree = tbRaceInfo.nLastPassTree + 1
  end

  self:OnTrapAction(szTrapName, nTrapType) -- 对各种类型的trap做状态处理
end

function Xmas2012:OnTrapAction(szTrapName, nTrapType)
  local tbRaceInfo = self:GetPlayerRaceInfo(me)
  if nTrapType == self.TRAP_TREE then
    tbRaceInfo.nScore = tbRaceInfo.nScore or 0
    self:UpdateMsgUi(me, tbRaceInfo.nScore)
    if self:IsRaceFinished(me) == 1 then
      self:OnPlayerRaceEnd(me)
      Dialog:SendBlackBoardMsg(me, "派送完成，请前往旁边的雪人摇摇处领取奖励吧！")
    else
      Dialog:SendBlackBoardMsg(me, string.format("第%d份礼物派送完成，请继续前行！", tbRaceInfo.nLastPassTree))
    end
  end

  if nTrapType == self.TRAP_STAR then
    local nColorType = self:GetStarColorType(me.nMapId, szTrapName)
    local szMsg = ""
    if nColorType == self.STAR_TRAP_YELLOW then
      -- 添加积分
      tbRaceInfo.nScore = tbRaceInfo.nScore + 1
      self:SetPlayerRaceInfo(me, tbRaceInfo)

      -- 更新UI
      self:UpdateMsgUi(me, tbRaceInfo.nScore)

      -- 客户端作表现
      me.CallClientScript({ "Player:OnXmas12GainScore", 1 })
    elseif nColorType == self.STAR_TRAP_RED then
      -- 减速
      me.AddSkillState(self.SKILL_SPEEDDOWN_ID, self.SKILL_SPEEDDOWN_LEVEL, 1, self.STATE_TIME_SPEEDDOWN, 0, 0, 0, 0, 1)
      szMsg = "糟糕，碰到<color=red>红星星<color>被减速了"
    elseif nColorType == self.STAR_TRAP_PURPLE then
      -- 传送到上一颗圣诞树
      local tbTransPos = self:GetLastTreePos(me)
      me.NewWorld(me.nMapId, unpack(tbTransPos))

      --			local tbRaceInfo = self:GetPlayerRaceInfo(me);
      --			if tbRaceInfo.nLastDir >= 0 then
      --				me.GetNpc().DoCommand(28, tbRaceInfo.nLastDir);			-- 按着之前的方向行走
      --			end
      szMsg = "怎么会这样！<color=pink>紫星星<color>让我返回上一个礼物派送点了！"
    elseif nColorType == self.STAR_TRAP_BLUE then
      -- 冰冻
      me.GetNpc().AddSpecialState(8, self.STATE_TIME_FREEZE)
      szMsg = "讨厌，<color=cyan>蓝星星<color>还会冻人的.."
    elseif nColorType == self.STAR_TRAP_GREEN then
      -- 加速
      me.AddSkillState(self.SKILL_SPEEDUP_ID, self.SKILL_SPEEDUP_LEVEL, 1, self.STATE_TIME_SPEEDUP)
      szMsg = "太棒了，<color=green>绿星星<color>让我跑的更快了！"
    end

    if szMsg ~= "" then
      Dialog:SendBlackBoardMsg(me, szMsg)
    end
  end
end

function Xmas2012:GetStarColorType(nMapId, szTrapName)
  if not self.tbStarTraps[nMapId] or not self.tbStarTraps[nMapId][szTrapName] then
    return
  end

  local tbInfo = self.tbStarTraps[nMapId][szTrapName]
  local szColor = tbInfo.szColor
  for i, sz in pairs(self.tbColorStr) do
    if sz == szColor then
      return i
    end
  end

  return 0 -- 0是非法值
end

function Xmas2012:GetTreeTrapSeq(nMapId, szTrapName)
  if not self.tbTreeTraps[nMapId] or not self.tbTreeTraps[nMapId][szTrapName] then
    return
  end

  local tbInfo = self.tbTreeTraps[nMapId][szTrapName]
  return tbInfo.nParam or 0 -- 0是非法值
end

function Xmas2012:GetLastTreePos(pPlayer)
  local tbRaceInfo = self:GetPlayerRaceInfo(pPlayer)
  local nLastPassTree = tbRaceInfo.nLastPassTree
  local nMapId = pPlayer.nMapId

  for _, tbInfo in pairs(self.tbTreeTraps[nMapId] or {}) do
    if tbInfo.nParam == nLastPassTree then
      return { unpack(tbInfo[1], 1, 2) }
    end
  end

  -- 否则返回报名NPC的点
  local tbDiaNpc = self.tbDialogNpc[nMapId]
  return { tbDiaNpc[1][2], tbDiaNpc[1][3] }
end

function Xmas2012:GetAward(pPlayer)
  local nAward = pPlayer.GetTask(self.TSK_GROUP, self.TSK_SUB_AWARD)
  if nAward == 0 then
    pPlayer.Msg("您没有可领取的奖励。")
    return
  end

  if not self.tbAwardItem[nAward] then
    return
  end

  if pPlayer.CountFreeBagCell() < 1 then
    pPlayer.Msg("请至少空出一格背包！")
    return
  end

  local tbGDPL = self.tbAwardItem[nAward]
  if pPlayer.AddItem(unpack(tbGDPL)) then
    pPlayer.SetTask(self.TSK_GROUP, self.TSK_SUB_AWARD, 0)

    local szMsg = ""
    if nAward == 1 then
      szMsg = "你取得了不错的成绩，再接再厉你将获得更好的奖励"
    elseif nAward == 2 then
      szMsg = "干得漂亮！你的努力值得给你这最好的奖励"
    end

    if szMsg ~= "" then
      Dialog:SendBlackBoardMsg(pPlayer, szMsg)
    end

    -- 埋点
    StatLog:WriteStatLog("stat_info", "shengdanjie_2012", "sled_finish", pPlayer.nId, string.format("%d_%d_%d_%d", unpack(tbGDPL)))
  end
end

function Xmas2012:IsRaceFinished(pPlayer)
  local tbRaceInfo = self:GetPlayerRaceInfo(pPlayer)
  local nLastPassTree = tbRaceInfo.nLastPassTree or 0
  if nLastPassTree == self.LAST_TREE_SEQ then
    return 1
  end

  return 0
end

function Xmas2012:GetUiShowMsg(pPlayer)
  local tbRaceInfo = self:GetPlayerRaceInfo(pPlayer)
  tbRaceInfo.nLastPassTree = tbRaceInfo.nLastPassTree or 0

  local tbMsg = {
    "第一份礼物",
    "第二份礼物",
    "第三份礼物",
    "第四份礼物",
    "第五份礼物",
    "第六份礼物",
    "第七份礼物",
    "第八份礼物",
  }
  local tbState = {
    "（未送达）",
    "（已送达）",
  }
  local szMsg = ""
  local szColor = ""
  local szState = ""
  for i, _szMsg in pairs(tbMsg) do
    if i > tbRaceInfo.nLastPassTree then
      szColor = "red"
      szState = tbState[1]
    else
      szColor = "green"
      szState = tbState[2]
    end

    szMsg = szMsg .. string.format("<color=%s>%s%s<color>\n", szColor, _szMsg, szState)
  end
  return szMsg
end

function Xmas2012:UpdateMsgUi(pPlayer, nScore)
  local szMsg = string.format(self.RACE_MSG_TIP, nScore)
  szMsg = szMsg .. "\n" .. self:GetUiShowMsg(pPlayer)
  Dialog:SendBattleMsg(pPlayer, szMsg)
end

function Xmas2012:OpenMsgUi(pPlayer)
  Dialog:ShowBattleMsg(pPlayer, 1, 0) --开启界面
  Dialog:SetBattleTimer(pPlayer, self.RACE_MSG_TIME, self.RACE_LIMIT_TIME)
end

function Xmas2012:CloseMsgUi(pPlayer)
  Dialog:ShowBattleMsg(pPlayer, 0, 0)
end
