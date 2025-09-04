-------------------------------------------------------
-- 文件名　 : superbattle_npc_land.lua
-- 创建者　 : zhangjinpin@kingsoft
-- 创建时间 : 2011-06-02 16:17:12
-- 文件描述 :
-------------------------------------------------------

if not MODULE_GAMESERVER then
  return
end

Require("\\script\\globalserverbattle\\superbattle\\superbattle_def.lua")

local tbNpc = Npc:GetClass("superbattle_npc_land")

function tbNpc:OnDialog()
  -- 活动是否开启
  if SuperBattle:CheckIsOpen() ~= 1 or SuperBattle:CheckIsGlobal() ~= 1 then
    Dialog:Say("可怜夜半虚前席，不问苍生问鬼神。")
    return 0
  end

  local szMsg = "    二十年了，我始终忘不了那一战。千索横江，万剑纵横，烽烟蔽天日。来跟我回到当年的战场吧！\n<color=yellow>（战场结束后请回到本服领取奖励）<color>"
  local tbOpt = {
    { "<color=yellow>进入跨服宋金<color>", self.EnterBattle, self },
    { "查询宋金排行", self.Query, self },
    { "查询上周积分", self.QueryLastGpa, self },
    { "我知道了" },
  }

  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:EnterBattle()
  SuperBattle:EnterBattle_GS(me)
end

function tbNpc:Query()
  local szMsg = "    这里可以查询跨服宋金的排行，"
  local nSort = 0
  local nGpa = GetPlayerSportTask(me.nId, SuperBattle.GA_TASK_GID, SuperBattle.GA_TASK_GPA) or 0
  for i, tbInfo in pairs(SuperBattle.tbGlobalBuffer) do
    if tbInfo[1] == me.szName then
      nSort = i
    end
  end
  if nSort == 0 then
    szMsg = szMsg .. string.format("你当前的排行点数为：<color=yellow>%s<color>，还没有上榜。", nGpa)
  else
    szMsg = szMsg .. string.format("你当前的排行点数为：<color=yellow>%s<color>，处于排行榜的<color=yellow>%s<color>位。", nGpa, nSort)
  end
  local tbOpt = {
    { "<color=yellow>查询宋金排名<color>", self.QueryOther, self },
    { "我知道了" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:QueryOther(nFrom)
  local tbOpt = { "我知道了" }
  local szMsg = "          <color=cyan>跨服宋金排行榜<color>\n\n"
  local nBegin = nFrom or 0
  local nLeft = #SuperBattle.tbGlobalBuffer - nBegin
  local nLength = nLeft <= 10 and nLeft or 10
  for i = nBegin, nBegin + nLength do
    if SuperBattle.tbGlobalBuffer[i] then
      szMsg = szMsg .. string.format("<color=yellow>%s%s%s%s<color>\n", Lib:StrFillC(string.format("%s.", i), 4), Lib:StrFillC(SuperBattle.tbGlobalBuffer[i][1], 17), Lib:StrFillC(ServerEvent:GetServerNameByGateway(SuperBattle.tbGlobalBuffer[i][3]), 8), Lib:StrFillC(SuperBattle.tbGlobalBuffer[i][2], 6))
    end
  end
  if nLeft > 10 then
    table.insert(tbOpt, 1, { "<color=yellow>下一页<color>", self.QueryOther, self, nBegin + nLength + 1 })
  end
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:QueryLastGpa()
  local nLastGpa = GetPlayerSportTask(me.nId, SuperBattle.GA_TASK_GID, SuperBattle.GA_TASK_LAST_GPA) or 0
  local nLastSort = GetPlayerSportTask(me.nId, SuperBattle.GA_TASK_GID, SuperBattle.GA_TASK_LAST_SORT) or 0
  local szMsg = string.format("您上周的跨服宋金排行点数为：<color=yellow>%s<color>，处于排行榜的<color=yellow>%s<color>位。", nLastGpa, nLastSort)
  Dialog:Say(szMsg)
end
