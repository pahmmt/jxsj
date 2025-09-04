-------------------------------------------------------------------
--File: 	factionbattle_npc.lua
--Author: 	zhengyuhua
--Date: 	2008-1-8 17:38
--Describe:	门派战npc对话逻辑
-------------------------------------------------------------------

-- 门派竞技功能选项对话
function FactionBattle:ChoiceFunc(nFaction)
  if EventManager.IVER_bOpenTiFu == 1 then
    Dialog:Say("门派竞技场12：20和20：20开放并接受报名，12：30和20：30正式开始\n<color=red>每次门派竞技的积分将会在下次举行门派竞技的前清空<color>", {
      { "我想前往本门竞技场", self.EnterMap, self, nFaction },
      { "积分兑换奖励", self.ExchangeExp, self, me.nId },
    })
  else
    Dialog:Say(string.format("门派竞技场每周二、%s晚上19：30开放并接受报名，20：00正式开始\n<color=red>每次门派竞技的积分将会在下次举行门派竞技的前清空<color>", Lib:Transfer4LenDigit2CnNum(EventManager.IVER_nSecFactionDay)), {
      { "我想前往本门竞技场", self.EnterMap, self, nFaction },
      { "积分兑换奖励", self.ExchangeExp, self, me.nId },
    })
  end
end

-- 报名参加门派战
function FactionBattle:SignUp(nFaction)
  if me.GetTiredDegree1() == 2 then
    Dialog:Say("您太累了，还是休息下吧！")
    return
  end
  local tbData = self:GetFactionData(nFaction)
  if not tbData then
    Dialog:Say("现在没有门派竞技！")
    return 0
  elseif tbData.nState > self.SIGN_UP then
    if EventManager.IVER_bOpenTiFu == 1 then
      Dialog:Say("本门竞技比赛已开始了，现在不再接受报名，请在场内参加其他活动吧")
    else
      Dialog:Say("本门竞技比赛已在20：00开始了，现在不再接受报名，请在场内参加其他活动吧")
    end
    return 0
  end
  if me.nFaction ~= nFaction then
    Dialog:Say("你不是本门弟子，不能参加本门的门派竞技!")
    return 0
  end
  if me.nLevel < self.MIN_LEVEL then
    Dialog:Say("你学艺不精，等级不足" .. self.MIN_LEVEL .. "级，不能参加比武竞技比赛，但可参加场内组织的其他活动")
    return 0
  end
  --	if (Wlls:CheckFactionLimit() == 1 and me.nLevel >= self.MAX_LEVEL) then
  --		Dialog:Say("你已经出师了，不能进入本门的门派竞技场!");
  --		return 0;
  --	end
  if tbData:GetAttendPlayuerCount() >= self.MAX_ATTEND_PLAYER then
    Dialog:Say("报名人数已达到400人上限，不能再报名了，请在场内参加其他活动吧")
  else
    local nRet = tbData:AddAttendPlayer(me.nId)
    if nRet == 0 then
      Dialog:Say("你已经报过名了！")
    else
      Dialog:Say("报名成功，请在外场等待比赛开始，切勿离开，否则会失去比赛资格！<color=yellow>竞技比赛将在19：30正式开始")
    end
  end
end

-- 进入门派竞技场地图
function FactionBattle:EnterMap(nFaction)
  if me.GetTiredDegree1() == 2 then
    Dialog:Say("您太累了，还是休息下吧！")
    return
  end
  local nFlag = self:GetBattleFlag(nFaction)
  if nFlag ~= 1 then
    if EventManager.IVER_bOpenTiFu == 1 then
      Dialog:Say("门派竞技场12：20和20：20开放并接受报名，12：30和20：30正式开始\n现在还没有开放")
    else
      Dialog:Say(string.format("门派竞技场每周二、%s晚上19：30开放并接受报名，20：00正式开始\n现在还没有开放", Lib:Transfer4LenDigit2CnNum(EventManager.IVER_nSecFactionDay)))
    end

    return 0
  end
  if me.nFaction ~= nFaction then
    Dialog:Say("你不是本门弟子，不能进入本门的门派竞技场!")
    return 0
  end
  --	if (Wlls:CheckFactionLimit() == 1 and me.nLevel >= self.MAX_LEVEL) then
  --		Dialog:Say("你已经出师了，不能进入本门的门派竞技场!");
  --		return 0;
  --	end
  if me.nLevel < self.MIN_LEVEL then
    Dialog:Say("你等级不足" .. self.MIN_LEVEL .. "级，不能参加比武竞技比赛。")
    return 0
  end

  self:TrapIn(me)
  -- 记录参加次数
  local nNum = me.GetTask(StatLog.StatTaskGroupId, 2) + 1
  me.SetTask(StatLog.StatTaskGroupId, 2, nNum)

  SpecialEvent.ActiveGift:AddCounts(me, 23) --参加门派竞技活跃度
end

-- 离开门派竞技场对话
function FactionBattle:LeaveMap(nFaction, bConfirm)
  if bConfirm == 1 then
    Npc.tbMenPaiNpc:Transfer(nFaction)
    return 0
  end
  Dialog:Say("你确定要离开竞技场吗？如果在比赛开始时不在场内，你将失去比赛资格", {
    { "确定", FactionBattle.LeaveMap, FactionBattle, nFaction, 1 },
    { "我再考虑一下" },
  })
end

function FactionBattle:CancelSignUp(nFaction, bConfirm)
  if bConfirm == 1 then
    local tbData = self:GetFactionData(nFaction)
    if tbData ~= nil then
      if tbData.nState ~= self.SIGN_UP then
        Dialog:Say("比赛已经开始,不能取消比赛资格。")
        return 0
      end
      tbData:DelAttendPlayer(me.nId)
      Dialog:Say("您取消了参加竞技赛的资格。")
    end
    return 0
  end
  Dialog:Say("你确定要取消报名？", {
    { "确定", FactionBattle.CancelSignUp, FactionBattle, nFaction, 1 },
    { "我再考虑一下" },
  })
end

function FactionBattle:ChampionFlagNpc(pPlayer, pNpc)
  self:ExcuteAwardChampion(pPlayer, pNpc)
end
