-- 文件名　：newbattle_gc.lua
-- 创建者　：LQY
-- 创建时间：2012-07-18 15:02:20
-- 说	明 ：新宋金战场的GC实现
if not MODULE_GC_SERVER then
  return 0
end
Require("\\script\\mission\\newbattle\\newbattle_def.lua")

NewBattle.tbNewBattleOpen = NewBattle.tbNewBattleOpen or {
  [1] = 0,
  [2] = 0,
  [3] = 0,
}

--启动战场活动，进入第一个阶段,nExValue不得超过3位，可空
function NewBattle:StartNewBattle_GC(nBattleSeq, nExValue)
  if NewBattle.OPEN_BATTLE[nBattleSeq] == 0 then
    return
  end
  --活动流水号
  local nSession = KGblTask.SCGetDbTaskInt(DBTASK_NEWBATTLE_SESSION)
  KGblTask.SCSetDbTaskInt(DBTASK_NEWBATTLE_SESSION, nSession + 1)
  --召唤GS启动报名
  GlobalExcute({ "NewBattle:StartNewBattle_GS", nSession + 1, nBattleSeq, nExValue })
end

-- 成功开启一个战场
function NewBattle:BattleOpen_GC(nBattleSeq, nBattleKey)
  if self.tbNewBattleOpen then
    self.tbNewBattleOpen[nBattleSeq] = nBattleKey
  end
  GlobalExcute({ "NewBattle:BattleOpen_GS", nBattleSeq, nBattleKey })
end

-- 关闭一个战场
function NewBattle:BattleClose_GC(nBattleSeq)
  if self.tbNewBattleOpen then
    self.tbNewBattleOpen[nBattleSeq] = 0
  end
  GlobalExcute({ "NewBattle:BattleClose_GS", nBattleSeq })
end

--GS连接事件
function NewBattle:OnRecConnectEvent(nConnectId)
  GSExcute(nConnectId, { "NewBattle:UpdateOpen_GS", tbNewBattleOpen, 1 })
end

--玩家数量处理
function NewBattle:PlayerCount_GC(nTaskId, nType)
  local nCount = KGblTask.SCGetTmpTaskInt(nTaskId)
  if nType == 0 then
    KGblTask.SCSetTmpTaskInt(nTaskId, nCount - 1)
  end
  if nType == 1 then
    KGblTask.SCSetTmpTaskInt(nTaskId, nCount + 1)
  end
end

--注册GS连接事件
GCEvent:RegisterGS2GCServerStartFunc(NewBattle.OnRecConnectEvent, NewBattle)
