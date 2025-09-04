-- 战役

if not MODULE_GAMESERVER then
  return
end

-- 战局启动
function Battle:RoundStart_GS(nBattleId, nBattleLevel, tbMapId, szMapName, nRuleType, nMapNpcNumType, nSeqNum)
  if not tbMapId then
    assert(tbMapId)
    return
  end
  local szMsg = string.format("宋金大战一触即发，目前正进入报名阶段，欲参战者请尽快从七大城市中的战场募兵官或使用宋金诏书前往宋金战场报名点报名，报名剩余时间:%d分。参战条件:等级不小于%d级。", self.TIMER_SIGNUP / (Env.GAME_FPS * 60), self.LEVEL_LIMIT[1])
  KDialog.NewsMsg(0, Env.NEWSMSG_NORMAL, szMsg)
  local szBattleTime = GetLocalDate("%y%m%d%H")

  local nOpenCount = #tbMapId

  if EventManager.IVER_bOpenTiFu == 1 then
    nOpenCount = self:GetOpenCount(nBattleLevel, #tbMapId)
  else
    if nSeqNum == 1 and nOpenCount > 1 then -- 如果是今天的第一场比赛，那么就只开一场
      nOpenCount = 1
    else
      nOpenCount = self:GetOpenCount(nBattleLevel, #tbMapId)
    end
  end

  for i = 1, nOpenCount do
    local nMapId = tbMapId[i]
    Battle:OpenBattle(nBattleId, nBattleLevel, nMapId, szMapName, nRuleType, nMapNpcNumType, nSeqNum, i, szBattleTime)
  end
  --Battle:RoundEnd_GS(nBattleId, nBattleLevel, MathRandom(0, 1));
end

--战场开启场次调整为跟时间轴相关：
--时间轴开放99级后,扬州战场调整为只开放战场一、战场二；
--时间轴开放150级后，扬州战场调整为只开放战场一；
--时间轴开放150级后150天之后，凤翔战场调整为只开放战场一；

function Battle:GetOpenCount(nBattleLevel, nCount)
  if GLOBAL_AGENT then
    return 1
  end

  if EventManager.IVER_bOpenTiFu == 1 then
    return 3
  end

  local nOpenCount = nCount
  if nBattleLevel == 1 then
    if TimeFrame:GetStateGS("OpenLevel150") == 1 then
      nOpenCount = 1
    elseif TimeFrame:GetStateGS("OpenLevel99") == 1 then
      nOpenCount = 2
    end
  elseif nBattleLevel == 2 then
    if TimeFrame:GetStateGS("OpenOneFengXiangBattle") == 1 then
      nOpenCount = 1
    end
    if SpecialEvent.HundredKin:CheckEventTime("songjin") == 1 then
      nOpenCount = 2
    end
  end
  return nOpenCount
end

-- 战局结束
-- nSongResult 参见：Battle.RESULT_XXX
function Battle:RoundEnd_GS(nBattleId, nBattleLevel, nSongResult, tbPlayerList)
  GCExcute({ "Battle:RoundEnd_GC", nBattleId, nBattleLevel, nSongResult, tbPlayerList })
end
