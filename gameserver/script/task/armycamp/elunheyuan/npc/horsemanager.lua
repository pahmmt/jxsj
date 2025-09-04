-- 马场传送人以及马场大部分逻辑
local tbNpc = Npc:GetClass("elunheyuan_maguan")
tbNpc.tbTimeStep = {
  [1] = 60, -- 第一轮
  [2] = 15, -- 第二轮
  [3] = 15, -- 第三轮
  [4] = 60, -- 第四轮
  [5] = 15, -- 第五轮
  [6] = 15, -- 第六轮
  [7] = 60, -- 第七轮
  [8] = 15,
  [9] = 15,
}
-- 关卡总时间
tbNpc.nTotalTime = 20 -- 预留20秒
for i = 1, #tbNpc.tbTimeStep do
  tbNpc.nTotalTime = tbNpc.nTotalTime + tbNpc.tbTimeStep[i]
end
tbNpc.nRefreshHorseTime = 10 -- 10秒刷一批马
tbNpc.nRefreshSheepTime = 6 -- 6秒刷羊
tbNpc.nRefreshSheepNum = 10 -- 刷羊的个数
tbNpc.tbType2Point = { [1] = 10, [2] = 20, [3] = 50, [4] = 0, [5] = 10, [6] = 5, [7] = 5 } -- 每种马对应的分数
tbNpc.nGetExpRand = 50 -- 马王给经验的概率
tbNpc.nExpValue = 1000000 -- 经验的数值
tbNpc.tbBianshenSkillId = { [0] = { 1, 2, 4, 6 }, [1] = { 3, 5 } }
tbNpc.nSuccessPoint = 700 -- 过关分数
function tbNpc:OnDialog()
  local nSubWorld, _, _ = him.GetWorldPos()
  local tbInstancing = Task.tbArmyCampInstancingManager:GetInstancing(nSubWorld)
  assert(tbInstancing)
  -- 上一关打完才能开启下一关
  if tbInstancing.tbTollgateReset[1] ~= 2 then
    Dialog:Say("先打败我们草原的蒙古勇士再来我这里吧。")
    return
  end
  local tbOpt = {
    { "<color=green>查询套马规则<color>", self.Introduce, self },
    { "我随便看看" },
  }
  local szMsg = "年轻人，套马是草原男儿证明自己勇气和智慧的最佳途径，这马场中围得都是未驯的野马，套到多少，套到什么样的马，都看你们自己的，要是能够驯服那马王……哈哈，那可算得上是盛事一件。"
  if tbInstancing.tbTollgateReset[2] == 0 then
    szMsg = szMsg .. "\n你的队友正在里面套马，先耐心等一等吧。"
  elseif tbInstancing.tbTollgateReset[2] == 1 then
    szMsg = szMsg .. "\n确定要开始挑战吗？"
    table.insert(tbOpt, 1, { "我确定要开始套马", self.StartHarmessHorse, self, him.dwId })
  elseif tbInstancing.tbTollgateReset[2] == 2 then
    szMsg = szMsg .. "\n你们已经在马场证明了自己，继续往前走吧。"
  end
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:Introduce()
  local szMsg = string.format("套马开始后，你将获得套索技能。需要使用套索技能来套住场地中的各种马匹，套中不同的马匹获得的积分不同。全队获得的积分累加。\n<color=yellow>黄骠马<color>\t%s分\n<color=yellow>大宛马<color>\t%s分\n<color=yellow>汗血马王<color>\t%s分\n要注意<color=yellow>儿马子<color>性情猛烈极难驯服，不小心套到的话说不定会损坏套索，甚至受伤。套马时需注意。\n汗血马王极其珍贵，若套到则有机会获得奖励，更有可能得到稀有的坐骑。\n在时限内全队多能累计积分达到%s分，则通过关卡。如果为难达到这个要求则失败，还可以继续挑战直到通过。", self.tbType2Point[1], self.tbType2Point[2], self.tbType2Point[3], self.nSuccessPoint)
  local tbOpt = {
    { "我明白了" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:StartHarmessHorse(nNpcId)
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    return
  end
  local nSubWorld, _, _ = pNpc.GetWorldPos()
  local tbInstancing = Task.tbArmyCampInstancingManager:GetInstancing(nSubWorld)
  assert(tbInstancing)
  if tbInstancing.tbTollgateReset[2] ~= 1 then
    return
  end
  tbInstancing:ChangeTollgateState(2, 0)
  -- 传送，变身
  local tbPlayList, _ = KPlayer.GetMapPlayer(nSubWorld)
  for _, teammate in ipairs(tbPlayList) do
    teammate.NewWorld(nSubWorld, 1776, 3628)
    teammate.SetFightState(1)
    local _, nX, nY = teammate.GetWorldPos()
    -- 记录玩家技能快捷键
    Setting:SetGlobalObj(teammate)
    Player:SaveShotCut(tbInstancing.tbMachang.tbPlayerShotSkill)
    Setting:RestoreGlobalObj()
    local nLevel = self.tbBianshenSkillId[teammate.nSex][MathRandom(#self.tbBianshenSkillId[teammate.nSex])]
    teammate.CastSkill(2588, nLevel, nX * 32, nY * 32)
    -- 设置快捷键
    FightSkill:SetShortcutSkill(teammate, 1, 2589, 1)
    FightSkill:SetShortcutSkill(teammate, 12, 2589, 1)
    tbInstancing.tbAttendPlayerList[teammate.nId] = 1
    local szTimeMsg = "<color=green>\n剩余时间：<color> <color=white>%s<color>"
    Dialog:SetBattleTimer(teammate, szTimeMsg, self.nTotalTime * Env.GAME_FPS)
    Dialog:SendBlackBoardMsg(teammate, "开始套马了，集中注意力哦")
    Dialog:SendBattleMsg(teammate, self:GetBattleInfo(tbInstancing, teammate.nId))
    Dialog:ShowBattleMsg(teammate, 1, 0)
  end
  tbInstancing.tbMachang.nHugeHorseTimerId = Timer:Register(self.tbTimeStep[1] * Env.GAME_FPS, self.RefreshHugeHorse, self, 1, nNpcId)
  -- 早3秒提示大波野马即将出现
  Timer:Register((self.tbTimeStep[1] - 3) * Env.GAME_FPS, tbNpc.RefreshHorsePrompt, tbNpc, nNpcId)
  tbInstancing.tbMachang.nTimerId = Timer:Register(self.nTotalTime * Env.GAME_FPS, self.GameOver, self, nNpcId)
  tbInstancing.tbMachang.nHorseTimerId = Timer:Register(self.nRefreshHorseTime * Env.GAME_FPS, self.RefreshHorse, self, nNpcId)
  tbInstancing.tbMachang.nSheepTimerId = Timer:Register(self.nRefreshSheepTime * Env.GAME_FPS, self.RefreshSheep, self, nNpcId)
  Timer:Register(20 * Env.GAME_FPS, self.SaySomething, self, pNpc.dwId)
end

tbNpc.tbText = {
  "蒙古马个头较矮，耐力持久，善于长途跋涉，但是冲刺力度较小，爆发力很差。",
  "汗血马的名字，是因为其流汗时，汗浆如血，所以命名为汗血马。",
  "乌桓马敏捷灵巧，个头高大，是非常优良的马种！",
  "儿马子是指野马群中具有生育能力的公马，性情暴烈，甚至可以斗过野狼。",
  "驯服野马不仅是技巧上的问题，智慧，耐心，勇气，缺一不可。",
}

function tbNpc:SaySomething(nNpcId)
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    return 0
  end
  local nSubWorld, _, _ = pNpc.GetWorldPos()
  local tbInstancing = Task.tbArmyCampInstancingManager:GetInstancing(nSubWorld)
  if not tbInstancing then
    return 0
  end
  if tbInstancing.tbTollgateReset[2] ~= 0 then
    return 0
  end
  local nIndex = pNpc.GetTempTable("Task").nPromptIndex or 0
  nIndex = math.mod(nIndex + 1, #self.tbText) + 1
  tbInstancing:NpcSay(nNpcId, self.tbText[nIndex])
  pNpc.GetTempTable("Task").nPromptIndex = nIndex
end

-- 获取显示在右侧的分数信息
function tbNpc:GetBattleInfo(tbInstancing, nSelfId)
  local tbMachang = tbInstancing.tbMachang
  local szMsg = string.format("\n<color=green>队伍积分：%s/%s<color>", tbMachang.nTotalPoint, self.nSuccessPoint)
  for nPlayerId, nPoint in pairs(tbMachang.tbPoint) do
    if nSelfId == nPlayerId then
      szMsg = string.format("%s\n<color=yellow>%s：%s分<color>", szMsg, Lib:StrFillR(KGCPlayer.GetPlayerName(nPlayerId), 16), Lib:StrFillR(nPoint, 4))
    else
      szMsg = string.format("%s\n%s：%s分", szMsg, Lib:StrFillR(KGCPlayer.GetPlayerName(nPlayerId), 16), Lib:StrFillR(nPoint, 4))
    end
  end
  return szMsg
end

function tbNpc:RefreshHugeHorse(nStep, nNpcId)
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    return 0
  end
  local nSubWorld, _, _ = pNpc.GetWorldPos()
  local tbInstancing = Task.tbArmyCampInstancingManager:GetInstancing(nSubWorld)
  if not tbInstancing then
    return 0
  end
  if tbInstancing.tbTollgateReset[2] ~= 0 then
    return 0
  end
  if tbInstancing:CheckTollgateOver() == 1 then
    return 0
  end
  if self.tbTimeStep[nStep] then
    for nPlayerId, nFlag in pairs(tbInstancing.tbAttendPlayerList) do
      local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
      if pPlayer then
        Dialog:SendBattleMsg(pPlayer, self:GetBattleInfo(tbInstancing, nPlayerId))
        Dialog:ShowBattleMsg(pPlayer, 1, 0)
        Dialog:SendBlackBoardMsg(pPlayer, "一大波野马出现了")
      end
    end
    tbInstancing.tbMachang.nHugeHorseTimerId = nil
    if nStep < #self.tbTimeStep then
      -- 早3秒提示大波野马即将出现
      Timer:Register((self.tbTimeStep[nStep + 1] - 3) * Env.GAME_FPS, tbNpc.RefreshHorsePrompt, tbNpc, nNpcId)
      tbInstancing.tbMachang.nHugeHorseTimerId = Timer:Register(self.tbTimeStep[nStep + 1] * Env.GAME_FPS, tbNpc.RefreshHugeHorse, tbNpc, nStep + 1, nNpcId)
    end
    -- 添加马
    self:AddHugeHorse(tbInstancing)
    -- 把场上的羊清一下，防止干扰
    for _, nSheepId in ipairs(tbInstancing.tbMachang.tbSheepId) do
      local pSheep = KNpc.GetById(nSheepId)
      if pSheep then
        pSheep.Delete()
      end
    end
    tbInstancing.tbMachang.tbSheepId = {}
  end
  return 0
end

function tbNpc:RefreshHorsePrompt(nNpcId)
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    return 0
  end
  local nSubWorld = pNpc.GetWorldPos()
  local tbInstancing = Task.tbArmyCampInstancingManager:GetInstancing(nSubWorld)
  if not tbInstancing then
    return 0
  end
  if tbInstancing.tbTollgateReset[2] ~= 0 then
    return 0
  end
  tbInstancing:SendPrompt("请注意，一大波野马即将出现！", 0, 1, 0, 0)
  return 0
end

function tbNpc:RefreshHorse(nNpcId)
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    return 0
  end
  local nSubWorld = pNpc.GetWorldPos()
  local tbInstancing = Task.tbArmyCampInstancingManager:GetInstancing(nSubWorld)
  if not tbInstancing then
    return 0
  end
  if tbInstancing.tbTollgateReset[2] ~= 0 then
    return 0
  end
  if tbInstancing:CheckTollgateOver() == 1 then
    return 0
  end
  self:AddOneHorese(tbInstancing)
end

function tbNpc:RefreshSheep(nNpcId)
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    return 0
  end
  local nSubWorld = pNpc.GetWorldPos()
  local tbInstancing = Task.tbArmyCampInstancingManager:GetInstancing(nSubWorld)
  if not tbInstancing then
    return 0
  end
  if tbInstancing.tbTollgateReset[2] ~= 0 then
    return 0
  end
  if tbInstancing:CheckTollgateOver() == 1 then
    return 0
  end
  -- 如果场上马大于5批不刷
  if #tbInstancing.tbMachang.tbHorseId <= 5 then
    self:AddSheep(tbInstancing)
  end
end

function tbNpc:GameOver(nNpcId)
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    return 0
  end
  local nSubWorld = pNpc.GetWorldPos()
  local tbInstancing = Task.tbArmyCampInstancingManager:GetInstancing(nSubWorld)
  if not tbInstancing then
    return 0
  end
  if tbInstancing.tbTollgateReset[2] ~= 0 then
    return 0
  end
  -- 把所有人传送回准备区，然后关卡复位
  for nPlayerId, nFlag in pairs(tbInstancing.tbAttendPlayerList) do
    local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
    if pPlayer then
      Dialog:ShowBattleMsg(pPlayer, 0, 0)
      if pPlayer.GetSkillState(2588) > 0 then
        pPlayer.RemoveSkillState(2588)
        Setting:SetGlobalObj(pPlayer)
        Player:RestoryShotCut(tbInstancing.tbMachang.tbPlayerShotSkill)
        Setting:RestoreGlobalObj()
      end
      if pPlayer.IsDead() == 1 then -- 理论上不可能死
        pPlayer.ReviveImmediately(0)
      else
        pPlayer.NewWorld(tbInstancing.nMapId, unpack(tbInstancing.tbSetting.tbRevivePos))
      end
      pPlayer.SetFightState(0)
      pPlayer.Msg("真遗憾，驯马失败了。请到牧马人处申请再次挑战。")
    end
  end
  tbInstancing.tbAttendPlayerList = {}
  tbInstancing:RestartTollgate() -- 还原关卡重新开始
  return 0
end

tbNpc.tbHorseRand = { [1] = { 40, 30, 30 }, [2] = { 55, 45 } } -- 第一次挑战套马和非第一次的概率不同
tbNpc.tbHorseRoute = {} -- 马路线
tbNpc.tbSheepRoute = {} -- 羊路线
-- 加载路线文件，分东南西北四个方向起始点到终点
tbNpc.szSettingFilePath = "\\setting\\task\\armycamp\\elunheyuan\\"
function tbNpc:LoadRouteFile()
  self.tbHorseRoute = {}
  for i = 1, 4 do
    local szFile1 = string.format("%shorse_born_%s.txt", self.szSettingFilePath, i)
    local szFile2 = string.format("%shorse_final_%s.txt", self.szSettingFilePath, i)
    local tbFile1 = Lib:LoadTabFile(szFile1)
    local tbFile2 = Lib:LoadTabFile(szFile2)
    self.tbHorseRoute[i] = {}
    self.tbHorseRoute[i][1] = {}
    self.tbHorseRoute[i][2] = {}
    assert(tbFile1)
    for nIndex, tbTemp in ipairs(tbFile1) do
      table.insert(self.tbHorseRoute[i][1], { tonumber(tbTemp["TRAPX"]), tonumber(tbTemp["TRAPY"]) })
    end
    assert(tbFile2)
    for nIndex, tbTemp in ipairs(tbFile2) do
      table.insert(self.tbHorseRoute[i][2], { tonumber(tbTemp["TRAPX"]), tonumber(tbTemp["TRAPY"]) })
    end
  end
  -- 羊路线
  self.tbSheepRoute = {}
  local tbFile = Lib:LoadTabFile(self.szSettingFilePath .. "sheep_pos.txt")
  assert(tbFile)
  for nIndex, tbTemp in ipairs(tbFile) do
    table.insert(self.tbSheepRoute, { { tonumber(tbTemp["POSX1"]), tonumber(tbTemp["POSY1"]) }, { tonumber(tbTemp["POSX2"]), tonumber(tbTemp["POSY2"]) } })
  end
end

function tbNpc:RandHorseType(nType)
  nType = nType or 2
  local nRand = MathRandom(100)
  local nIndex = 1
  local nSum = 0
  for i = 1, #self.tbHorseRand[nType] do
    nSum = nSum + self.tbHorseRand[nType][i]
    if nSum >= nRand then
      nIndex = i
      break
    end
  end
  return nIndex
end

function tbNpc:RandHorseRoute()
  -- 先随方向
  local nDirect = MathRandom(#self.tbHorseRoute)
  local nBorn = MathRandom(#self.tbHorseRoute[nDirect][1])
  local nFinal = MathRandom(#self.tbHorseRoute[nDirect][2])
  return self.tbHorseRoute[nDirect][1][nBorn], self.tbHorseRoute[nDirect][2][nFinal]
end

tbNpc.tbType2HorseId = {
  [1] = 9944,
  [2] = 9945,
  [3] = 9946,
  [4] = 9947,
  [5] = 10119,
}
tbNpc.tbIndex2Route = {
  [1] = { 1769, 3616 },
}
tbNpc.nMaxHorse = 5 -- 每次随机马的最大数量
tbNpc.nXuanyunHorseRand = 50 -- 眩晕马的几率
tbNpc.nCDHorseRand = 50 -- cd马的概率
tbNpc.nMaxSheep = 5 -- 每次随机羊的概率
tbNpc.tbAnimalId = { 10120, 10121 } -- 两种羊
function tbNpc:AddHugeHorse(tbInstancing)
  local nHorseKin = 0
  for i = 1, self.nMaxHorse do
    local nRandType = 1
    -- 不是第一次挑战或者本轮已经随过马王则不再随马王
    if tbInstancing.tbMachang.nFirstChallenge ~= 1 or nHorseKin == 1 then
      nRandType = 2
    end
    local nType = self:RandHorseType(nRandType)
    if nType == 3 then
      nHorseKin = 1
    end
    self:AddHorseByType(tbInstancing, nType)
  end
  -- 每轮随机出现眩晕马和cd马
  local nRand = MathRandom(100)
  if nRand <= self.nXuanyunHorseRand then
    self:AddHorseByType(tbInstancing, 4)
  end
  local nRand = MathRandom(100)
  if nRand <= self.nCDHorseRand then
    self:AddHorseByType(tbInstancing, 5)
  end
end

function tbNpc:AddOneHorese(tbInstancing)
  local nRandType = 1
  -- 不是第一次挑战随马王
  if tbInstancing.tbMachang.nFirstChallenge ~= 1 then
    nRandType = 2
  end
  local nType = self:RandHorseType(nRandType)
  self:AddHorseByType(tbInstancing, nType)
end

function tbNpc:AddSheep(tbInstancing)
  for i = 1, self.nMaxSheep do
    local nRand = MathRandom(#self.tbSheepRoute)
    local nType = MathRandom(#self.tbAnimalId)
    local pNpc = KNpc.Add2(self.tbAnimalId[nType], 1, -1, tbInstancing.nMapId, self.tbSheepRoute[nRand][1][1] / 32, self.tbSheepRoute[nRand][1][2] / 32)
    if pNpc then
      table.insert(tbInstancing.tbMachang.tbSheepId, pNpc.dwId)
      pNpc.SetActiveForever(1)
      pNpc.SetLiveTime(20 * Env.GAME_FPS)
      pNpc.GetTempTable("Npc").tbOnArrive = { self.OnArrive1, self, pNpc.dwId, 2 }
      pNpc.AI_ClearPath()
      pNpc.AI_AddMovePos(self.tbSheepRoute[nRand][2][1], self.tbSheepRoute[nRand][2][2])
      pNpc.SetNpcAI(9, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0)
    end
  end
end

function tbNpc:AddHorseByType(tbInstancing, nType)
  local tbBorn, tbFinal = self:RandHorseRoute()
  if not tbBorn or not tbFinal then
    pritn("elunehuan addhorsebytype error")
    return
  end
  local pNpc = KNpc.Add2(self.tbType2HorseId[nType], 1, -1, tbInstancing.nMapId, tbBorn[1] / 32, tbBorn[2] / 32)
  if pNpc then
    tbInstancing.tbMachang.tbHorseId[#tbInstancing.tbMachang.tbHorseId + 1] = pNpc.dwId
    pNpc.SetActiveForever(1)
    pNpc.SetLiveTime(20 * Env.GAME_FPS)
    pNpc.GetTempTable("Npc").tbOnArrive = { self.OnArrive1, self, pNpc.dwId, 1 }
    pNpc.AI_ClearPath()
    pNpc.AI_AddMovePos(unpack(tbFinal))
    pNpc.SetNpcAI(9, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0)
  end
end

function tbNpc:OnArrive1(nNpcId, nType)
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    return 0
  end
  local nSubWorld, _, _ = pNpc.GetWorldPos()
  pNpc.Delete()
  local tbInstancing = Task.tbArmyCampInstancingManager:GetInstancing(nSubWorld)
  if not tbInstancing then
    return 0
  end
  if tbInstancing.tbTollgateReset[2] ~= 0 then
    return 0
  end
  local tbId = nil
  if nType == 1 then
    tbId = tbInstancing.tbMachang.tbHorseId
  elseif nType == 2 then
    tbId = tbInstancing.tbMachang.tbSheepId
  end
  if not tbId then
    return 0
  end
  local nIndex = 0
  for i, nId in pairs(tbId) do
    if nId == nNpcId then
      nIndex = i
      break
    end
  end
  if nIndex > 0 then
    table.remove(tbId, nIndex)
  end
  return 0
end

-- 击杀一批马
function tbNpc:KillHorse(nNpcId, nMapId, nPlayerId, nType, nIsSheep)
  local tbInstancing = Task.tbArmyCampInstancingManager:GetInstancing(nMapId)
  assert(tbInstancing)
  if tbInstancing.tbTollgateReset[2] ~= 0 then
    return
  end
  local pKillerPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pKillerPlayer then
    return 0
  end
  local nIndex = 0
  local tbId = nil
  if nIsSheep == 1 then
    tbId = tbInstancing.tbMachang.tbSheepId
  else
    tbId = tbInstancing.tbMachang.tbHorseId
  end
  for i, nId in ipairs(tbId) do
    if nId == nNpcId then
      nIndex = i
      break
    end
  end
  if nIndex <= 0 then
    return 0
  end
  table.remove(tbId, nIndex)
  if tbInstancing:AddHarnessHorsePoint(pKillerPlayer.nId, self.tbType2Point[nType]) == 1 then
    local szMsg = string.format(tbInstancing.tbMachang.szPrompt, tbInstancing.tbMachang.nTotalPoint)
    for nPlayerId, nFlag in pairs(tbInstancing.tbAttendPlayerList) do
      local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
      if pPlayer then
        Dialog:SendBattleMsg(pPlayer, self:GetBattleInfo(tbInstancing, nPlayerId))
        Dialog:ShowBattleMsg(pPlayer, 1, 0)
      end
    end
    if nType == 3 then -- 马王有机会获得特殊宝箱
      local nRand = MathRandom(100)
      if nRand <= self.nGetExpRand then
        pKillerPlayer.AddExp(self.nExpValue)
        pKillerPlayer.Msg(string.format("恭喜你成功驯服了汗血马王，获得%s经验。", self.nExpValue))
        Dialog:SendBlackBoardMsg(pKillerPlayer, "恭喜你！你成功的驯服了汗血马王获得大量经验！")
        StatLog:WriteStatLog("stat_info", "xinjunying", "mawang", pKillerPlayer.nId, 1)
      else
        pKillerPlayer.Msg("成功驯服了汗血马王，可惜马王没有留下任何东西。")
        StatLog:WriteStatLog("stat_info", "xinjunying", "mawang", pKillerPlayer.nId, 0)
      end
      Achievement:FinishAchievement(pKillerPlayer, 488)
    end
    -- 如果分数大于指定分数则成功通关
    if tbInstancing.tbMachang.nTotalPoint >= self.nSuccessPoint then
      -- 将场上的马删除
      for _, nHorseId in pairs(tbInstancing.tbMachang.tbHorseId) do
        tbInstancing:DeleteNpc(nHorseId)
      end
      tbInstancing.tbMachang.tbHorseId = {}
      -- 将场上的兔子删除
      for _, nSheepId in pairs(tbInstancing.tbMachang.tbSheepId) do
        tbInstancing:DeleteNpc(nSheepId)
      end
      -- 把定时器全部关掉
      if tbInstancing.tbMachang.nHugeHorseTimerId then
        Timer:Close(tbInstancing.tbMachang.nHugeHorseTimerId)
        tbInstancing.tbMachang.nHugeHorseTimerId = nil
      end
      if tbInstancing.tbMachang.nTimerId then
        Timer:Close(tbInstancing.tbMachang.nTimerId)
        tbInstancing.tbMachang.nTimerId = nil
      end
      if tbInstancing.tbMachang.nHorseTimerId then
        Timer:Close(tbInstancing.tbMachang.nHorseTimerId)
        tbInstancing.tbMachang.nHorseTimerId = nil
      end
      if tbInstancing.tbMachang.nSheepTimerId then
        Timer:Close(tbInstancing.tbMachang.nSheepTimerId)
        tbInstancing.tbMachang.nSheepTimerId = nil
      end
      local tbPlayList, _ = KPlayer.GetMapPlayer(tbInstancing.nMapId)
      -- 给所有地图内的人都设上任务标志
      for _, teammate in ipairs(tbPlayList) do
        Dialog:SendBlackBoardMsg(teammate, "恭喜你们驯服野马成功，通过本关考验！")
        teammate.SetTask(1025, 58, 1)
        teammate.Msg("成功驯服了野马！赶快前往下一关狩猎场吧！")
      end
      for nPlayerId, nFlag in pairs(tbInstancing.tbAttendPlayerList) do
        local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
        if pPlayer then
          Dialog:ShowBattleMsg(pPlayer, 0, 0)
          if pPlayer.GetSkillState(2588) > 0 then
            pPlayer.RemoveSkillState(2588)
            Setting:SetGlobalObj(pPlayer)
            Player:RestoryShotCut(tbInstancing.tbMachang.tbPlayerShotSkill or {})
            Setting:RestoreGlobalObj()
          end
          if pPlayer.IsDead() == 1 then -- 理论上不可能死
            pPlayer.ReviveImmediately(1)
          end
          pPlayer.SetFightState(0)
          pPlayer.NewWorld(tbInstancing.nMapId, 1787, 3608)
        end
      end
      tbInstancing.tbAttendPlayerList = {}
      tbInstancing:ChangeTollgateState(2, 2)
    end
  end
end

tbNpc:LoadRouteFile() -- 加载路线
