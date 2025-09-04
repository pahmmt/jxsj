-- 文件名　：main.lua
-- 创建者　：LQY
-- 创建时间：2012-11-07 10:50:02
-- 说　　明：冥灵庭院

Require("\\script\\task\\treasuremap\\treasuremap.lua")
Require("\\script\\task\\treasuremap2\\treasuremap.lua")
Require("\\script\\task\\treasuremap2\\instancing\\minlingtingyuan\\define.lua")

local tbInstancing = TreasureMap2:GetInstancingBase(8)

-- 入口trap事件处理
function tbInstancing:EnterTrapEvent(pPlayer, nStep, ...)
  local nGo = 1
  if self.nStep < nStep then
    nGo = 0
  end
  if self.nStep == nStep - 1 and self.Finished == 1 then
    self:RoundBegin(nStep)
    return
  end
  if nGo == 0 then
    local tbBack = arg[1] or self.tbBirthPos
    pPlayer.NewWorld(pPlayer.nMapId, unpack(tbBack))
    Dialog:SendBlackBoardMsg(pPlayer, "一股莫名的力量把你推了回来！")
    return
  end
end
-- 出口trap事件处理
function tbInstancing:LeaveTrapEvent(pPlayer, nStep, ...)
  local nGo = 1
  if self.nStep < nStep then
    nGo = 0
  end
  if self.Finished ~= 1 and self.nStep == nStep then
    nGo = 0
  end
  if self.Finished == 1 and self.nStep == nStep then
    return
  end
  if nGo == 0 then
    local tbBack = arg[1] or self.tbBirthPos
    pPlayer.NewWorld(pPlayer.nMapId, unpack(tbBack))
    Dialog:SendBlackBoardMsg(pPlayer, "一股莫名的力量把你推了回来！")
    return
  end
end

-- 第一次打开副本时调用，这个时候里面肯定没有别的队伍
function tbInstancing:OnNew()
  --local nNpcLevel =  	self.nNpcLevel;--TreasureMap2.TEMPLATE_LIST[self.nTreasureId].tbNpcLevel[self.nTreasureLevel];
  self.nStep = 0
  self.Finished = 1
  if self.tbTimers then
    for _, times in pairs(self.tbTimers) do
      for _, timer in pairs(times) do
        Lib:CallBack({ timer.Close, timer })
      end
    end
  end
  self.tbTimers = {}
  self.tbTrapEvent = {}
  self.tbRounds = {}
  local tbInstancingBase = TreasureMap2:GetInstancingBase(8)
  for n, tbRound in pairs(tbInstancingBase.tbRounds) do
    self.tbRounds[n] = Lib:NewClass(tbRound, self)
  end
end

----关卡基础
--开始一关
function tbInstancing:RoundBegin(nStep)
  if not self.tbRounds[nStep] then
    return 0
  end
  self.nStep = nStep
  self.Finished = 0
  local tbRound = self.tbRounds[nStep]
  tbRound.Finished = 0
  self.tbTimers[nStep] = {}
  tbRound:Begin()
  if self.tbStepTips[nStep] then
    self:SetStepTips(self.tbStepTips[nStep])
  end
  return 0
end

--结束一关
function tbInstancing:RoundEnd(nStep)
  nStep = nStep or self.nStep
  if not self.tbRounds[nStep] then
    return 0
  end
  self.Finished = 1
  local tbRound = self.tbRounds[nStep]
  tbRound.Finished = 1
  tbRound:End()
  self:CloseRoundTimer(nStep)
  self:DeleteStepTips()
  --根据星级提前结束关卡
  if self.tbStarRound[self.nStar] then
    if self.tbStarRound[self.nStar] == nStep then
      self:MissionComplete()
    end
  end
  return 0
end

--为一个关卡加入计时器
--nStep = 0时为全局时钟，副本结束才会关闭
function tbInstancing:AddRoundTimer(nStep, nWaitTime, ...)
  self.tbTimers[nStep] = self.tbTimers[nStep] or {}
  local tbTimer = self:CreateTimer(nWaitTime, unpack(arg))
  table.insert(self.tbTimers[nStep], tbTimer)
  return tbTimer
end

--关闭一个关卡所有计时器
function tbInstancing:CloseRoundTimer(nStep)
  self.tbTimers[nStep] = self.tbTimers[nStep] or {}
  local tbTimers = self.tbTimers[nStep]
  for n, tbTimer in pairs(tbTimers) do
    Lib:CallBack({ tbTimer.Close, tbTimer })
    --table.remove(tbTimers,n);
  end
end

--创建/获得某关卡
function tbInstancing:GetRound(nNum)
  if not self.tbRounds[nNum] then
    self.tbRounds[nNum] = Lib:NewClass(tbInstancing.RoundBase, self)
    self.tbRounds[nNum].nRound = nNum
  end
  return self.tbRounds[nNum]
end

--创建相遇事件
function tbInstancing:AddMeetEvent(nStep, pNpc1, pNpc2, nMeetDis, fncBack, tbSelf, ...)
  if not pNpc1 or not pNpc2 then
    return
  end
  nStep = nStep or 0
  self:AddRoundTimer(nStep, 1 * Env.GAME_FPS, self.AddMeetEventTimer, self, pNpc1, pNpc2, nMeetDis, fncBack, tbSelf, unpack(arg))
end

--相遇时钟,请勿手动调用
function tbInstancing:AddMeetEventTimer(pNpc1, pNpc2, nMeetDis, fncBack, tbSelf, ...)
  nMeetDis = nMeetDis or 2
  local nDis = self:GetDis(pNpc1, pNpc2)
  if nDis == 9999 then
    return 0
  end
  if self:GetDis(pNpc1, pNpc2) <= nMeetDis then
    fncBack(tbSelf, unpack(arg))
    return 0
  end
  return nil
end

--trap点特殊事件注册
function tbInstancing:RegisterTrapEvent(szTrapName, funcBack, tbSelf, ...)
  self.tbTrapEvent[szTrapName] = self.tbTrapEvent[szTrapName] or {}
  table.insert(self.tbTrapEvent[szTrapName], { funcBack, tbSelf, arg })
end

--建立战斗跟随关系, 关卡，目标NPC，跟随NPC，攻击距离，最大距离, 标志(如果目标身上标志消失，取消跟随),{丢失回调}
function tbInstancing:CreatFightFollow(nStep, pTarget, pFollower, nAtk, nMaxDis, nSign, tbLostFunc)
  nStep = nStep or 0
  if tbLostFunc then
    local tbArg = {}
    for i = 3, #tbLostFunc do
      tbArg[#tbArg + 1] = tbLostFunc[i]
    end
    tbLostFunc.Call = function()
      pFollower.GetTempTable("TreasureMap2").pTarget = nil
      pFollower.GetTempTable("TreasureMap2").bBack = 1
      tbLostFunc[1](tbLostFunc[2], pFollower.dwId, unpack(tbArg))
    end
  else
    tbLostFunc = {}
    tbLostFunc.Call = function() end
  end
  pFollower.SetNpcAI(9, nAtk or 50, 0, 0, 0, 0, 0, 0, 0)
  if pTarget then
    pTarget.GetTempTable("TreasureMap2").tbFightFollowSign = pTarget.GetTempTable("TreasureMap2").tbFightFollowSign or {}
    pTarget.GetTempTable("TreasureMap2").tbFightFollowSign[nSign] = 1
  end
  pFollower.GetTempTable("TreasureMap2").nFightFollow = nSign
  pFollower.GetTempTable("TreasureMap2").pTarget = pTarget
  self:FightFollowTimer(pFollower.dwId, nAtk, nMaxDis, nSign, tbLostFunc) --先调一次，处理寻找事件
  self:AddRoundTimer(nStep, 2 * Env.GAME_FPS, self.FightFollowTimer, self, pFollower.dwId, nAtk, nMaxDis, nSign, tbLostFunc)
end
--切换跟随目标
function tbInstancing:ChangeFightFollow(pFollower, pTarget)
  pFollower.AI_ClearPath()
  pTarget.GetTempTable("TreasureMap2").tbFightFollowSign = pTarget.GetTempTable("TreasureMap2").tbFightFollowSign or {}
  local nSign = pFollower.GetTempTable("TreasureMap2").nFightFollow or 0
  pTarget.GetTempTable("TreasureMap2").tbFightFollowSign[nSign] = 1
  pFollower.GetTempTable("TreasureMap2").pTarget = pTarget
  pFollower.GetTempTable("TreasureMap2").bBack = 0
end

--战斗跟随时钟,请勿手动调用
function tbInstancing:FightFollowTimer(dwFollower, nAtk, nMaxDis, nSign, tbLostFunc)
  local pFollower = KNpc.GetById(dwFollower)
  if not pFollower then
    return 0
  end
  local pTarget = pFollower.GetTempTable("TreasureMap2").pTarget
  local bBack = pFollower.GetTempTable("TreasureMap2").bBack or 0
  local _, nFx, nFx = pFollower.GetWorldPos()
  if nFx + nFx == 0 then
    return 0
  end
  if pTarget == nil then
    if bBack == 1 then
      return
    else
      tbLostFunc.Call()
      return
    end
  end
  local nDis = self:GetDis(pTarget, pFollower)
  if nDis > nMaxDis then
    tbLostFunc.Call()
    return
  end
  if pTarget.IsDead() == 1 or pFollower.IsDead() == 1 then
    tbLostFunc.Call()
    return
  end
  local tbTargSign = pTarget.GetTempTable("TreasureMap2").tbFightFollowSign or {}
  if not tbTargSign[nSign] then
    tbLostFunc.Call()
    return
  end
  local tbFightFollow = pFollower.GetTempTable("TreasureMap2").tbFightFollow or {}
  local _, nX, nY = pTarget.GetWorldPos()
  if tbFightFollow[1] == nX and tbFightFollow[2] == nY then
    return
  end
  pFollower.GetTempTable("TreasureMap2").tbFightFollow = { nX, nY }
  pFollower.AI_ClearPath()
  pFollower.AI_AddMovePos(nX * 32, nY * 32)
  return
end
--Npc说话,支持多句
function tbInstancing:NpcChat(pNpc, tbMsg, ntype)
  if not tbMsg or #tbMsg == 0 then
    return 0
  end
  if ntype == 1 then
    for _, pPlayer in pairs(self:GetPlayerList()) do
      pPlayer.Msg("<color=white>" .. tbMsg[1] .. "<color>", pNpc.szName)
    end
    pNpc.SendChat(tbMsg[1])
    local nSec = math.max(math.floor(#tbMsg[1] / 20), 1) --根据句子长度设置时间
    table.remove(tbMsg, 1)
    return nSec * 18
  end
  self:AddRoundTimer(0, 18, self.NpcChat, self, pNpc, tbMsg, 1)
  return 0
end

---RoundBase
local RoundBase = tbInstancing.RoundBase or {}
tbInstancing.RoundBase = RoundBase

function RoundBase:init(tbInstancing)
  self.tbInstancing = tbInstancing
end

function RoundBase:AddRoundTimer(nWaitTime, ...)
  return self.tbInstancing:AddRoundTimer(self.nRound, nWaitTime, unpack(arg))
end

function RoundBase:AddNpc(...)
  return self.tbInstancing.AddNpc(self.tbInstancing, unpack(arg))
end

function RoundBase:RoundEnd()
  self.tbInstancing:RoundEnd(self.nRound)
end

--创建相遇事件
function RoundBase:AddMeetEvent(...)
  self.tbInstancing:AddMeetEvent(self.nRound, unpack(arg))
end

--建立战斗跟随关系
function RoundBase:CreatFightFollow(...)
  self.tbInstancing:CreatFightFollow(self.nRound, unpack(arg))
end
--切换跟随目标
function RoundBase:ChangeFightFollow(...)
  self.tbInstancing:ChangeFightFollow(unpack(arg))
end
--Npc说话
function RoundBase:NpcChat(...)
  self.tbInstancing:NpcChat(unpack(arg))
end
