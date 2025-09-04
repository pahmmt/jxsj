--工资领取：福利版推出后，符合江湖威望条件的玩家，可以每周领取最多价值500RMB的绑定金币

SpecialEvent.Salary = {}
local Salary = SpecialEvent.Salary

Salary.TASK_GROUP_ID = 2027
Salary.TASK_LAST_PAID_TIME = 68

function Salary:CanGetSalary()
  if SpecialEvent:IsWellfareStarted() ~= 1 then
    return 0, "此功能尚未开启，敬请期待。"
  end

  local nTime = GetTime()
  local nWeek = Lib:GetLocalWeek(nTime)

  local nLastTime = me.GetTask(self.TASK_GROUP_ID, self.TASK_LAST_PAID_TIME)
  local nLastWeek = Lib:GetLocalWeek(nLastTime)

  local nTimeOK = 0

  if nLastTime == 0 or nWeek > nLastWeek then
    nTimeOK = 1
  end

  if nTimeOK ~= 1 then
    return 0, "你这周已经领过工资啦。"
  end

  if KGblTask.SCGetDbTaskInt(DBTASK_WEIWANG_WEEK) ~= tonumber(GetLocalDate("%W")) then
    return 0, "这一周的江湖威望排名还没出来，请稍候再来。"
  end

  local nLevel = GetPlayerHonorRankByName(me.szName, PlayerHonor.HONOR_CLASS_WEIWANG, 0)

  if nLevel < 1 or nLevel > 1200 then
    return 0, "很可惜，你这次排名还没达到领取工资的要求。"
  end

  local nCoin, nDecreaseRepute
  if 1 <= nLevel and nLevel <= 100 then
    nCoin = 12000
    nDecreaseRepute = 100
  elseif 101 <= nLevel and nLevel <= 300 then
    nCoin = 6000
    nDecreaseRepute = 50
  elseif 301 <= nLevel and nLevel <= 600 then
    nCoin = 3000
    nDecreaseRepute = 30
  elseif 601 <= nLevel and nLevel <= 1200 then
    nCoin = 2000
    nDecreaseRepute = 20
  end

  if me.nPrestige < nDecreaseRepute then
    return 0, string.format("要领取威望排名<color=yellow>第%d名<color>的工资，你至少需要<color=yellow>%d点<color>威望。", nLevel, nDecreaseRepute)
  end

  return 1, nLevel, nCoin, nDecreaseRepute
end

function Salary:GetSalary()
  local nRes, var, nCoin, nDecreaseRepute = Salary:CanGetSalary()
  if nRes == 0 then
    Dialog:Say(var)
    return
  end

  local nLevel = var

  if nCoin then
    local szMsg = string.format("你本周江湖威望排名为<color=yellow>第%d名<color>。你可以通过使用<color=yellow>%d点<color>江湖威望来领取工资，数额为<color=yellow>%d绑定%s<color>\n\n确定要领取吗？", nLevel, nDecreaseRepute, nCoin, IVER_g_szCoinName)

    local tbOpt = {
      { "是的，我要领工资", self.GetSalary2, self, nCoin, nDecreaseRepute, nLevel },
      { "我只是来看看" },
    }
    Dialog:Say(szMsg, tbOpt)
  end
end

function Salary:GetSalary2(nCoin, nDecreaseRepute, nLevel)
  local nRes, var = Salary:CanGetSalary()
  if nRes == 0 then
    Dialog:Say(var)
    return
  end

  me.AddBindCoin(nCoin, Player.emKBINDCOIN_ADD_SALARY)
  local nOldReput = me.nPrestige
  local nNewPrestige = math.max(nOldReput - nDecreaseRepute, 0)
  KGCPlayer.SetPlayerPrestige(me.nId, nNewPrestige)

  me.SetTask(self.TASK_GROUP_ID, self.TASK_LAST_PAID_TIME, GetTime())

  local szLog = string.format("%s 第%d名 获得福利工资%d绑定%s， 减少%d点威望，威望由%s减为%s", me.szName, nLevel, nCoin, IVER_g_szCoinName, nDecreaseRepute, nOldReput, nNewPrestige)
  Dbg:WriteLog("SpecialEvent.Salary", szLog)
  me.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, szLog)
  --记录玩家领取工资的次数
  Stats.Activity:AddCount(me, Stats.TASK_COUNT_SALARY, 1)
  KStatLog.ModifyAdd("bindcoin", "[产出]工资", "总量", nCoin)
end
