-- 文件名　：dts_guanyuan_city.lua
-- 创建者　：jiazhenwei
-- 创建时间：2009-10-13
-- 描  述  ：临安大逃杀接引

local tbNpc = Npc:GetClass("dataosha_city")

function tbNpc:OnDialog()
  DaTaoSha:PlayerOnLogin()
  local tbOpt = {}
  local szMsg = string.format("现在还未到活动开启时间，请在正确的时间来找我吧。\n\n活动开启时间:\n<color=yellow>%s--%s\n早11点--下午2点\n晚6点--晚9点<color>\n<color=red>注：周六晚有铁浮城战故不开放<color>", os.date("%Y年%m月%d日", Lib:GetDate2Time(DaTaoSha.nStatTime)), os.date("%Y年%m月%d日", Lib:GetDate2Time(DaTaoSha.nEndTime)))
  local nTime = tonumber(GetLocalDate("%H%M"))
  local nDate = tonumber(GetLocalDate("%Y%m%d"))
  local nWeek = tonumber(GetLocalDate("%w"))
  local nAllTimes = GetPlayerSportTask(me.nId, DaTaoSha.GBTSKG_DATAOSHA, DaTaoSha.GBTASKID_ATTEND_ALLNUM) or 0
  local nGlobalBatch = GetPlayerSportTask(me.nId, DaTaoSha.GBTSKG_DATAOSHA, DaTaoSha.GBTASKID_BATCH) or 0
  local nLimitTime = me.GetTask(DaTaoSha.TASKID_GROUP, DaTaoSha.TASKID_LIMIT_TIMES)
  local nTickets = me.GetTask(DaTaoSha.TASKID_GROUP, DaTaoSha.TASKID_TICKETS)
  --传送
  if nGlobalBatch ~= DaTaoSha.nBatch then
    nAllTimes = 0
  end
  if nDate >= DaTaoSha.nStatTime and nDate <= DaTaoSha.nEndTime then
    if (nTime >= DaTaoSha.OPENTIME[1] and nTime <= DaTaoSha.CLOSETIME[1]) or (nTime >= DaTaoSha.OPENTIME[2] and nTime <= DaTaoSha.CLOSETIME[2] and nWeek ~= 6) then
      szMsg = string.format("又到了这个<color=yellow>欢快的中秋国庆节日<color>，让我们一起欢歌笑语，载歌载舞。\n<color=green>9月27日-10月10日期间<color>，让我们一起分享<color=yellow>寒武遗迹竞技<color>的快乐与激情。活动期间可以在<color=yellow>月影之石商店<color>购买寒武魂珠（未开放100级上限的服务器可在<color=yellow>奇珍阁<color>购买）参加活动，每人最多可参与<color=yellow>36<color>场次比赛。\n\n<color=yellow>参加一次活动需要消耗1次挑战机会与1次资格。使用寒武魂珠可获得资格。<color>\n\n<color=yellow>剩余挑战机会： %s次\n剩余挑战资格： %s次\n已参与活动次数： %s/%s次<color>", nLimitTime - nAllTimes, nTickets - nAllTimes, nAllTimes, DaTaoSha.nMaxTime)
      table.insert(tbOpt, { "前往寒武遗迹报名点", self.TransToServer, self })
    end
  end
  --about
  table.insert(tbOpt, { "活动规则", self.Introduction, self })
  --领取本场
  table.insert(tbOpt, { "领取奖励", DaTaoSha.GetAwardForMe, DaTaoSha })
  --领取终场
  if DaTaoSha:CheckFinalAwardDate() == 1 then
    table.insert(tbOpt, { "领取最终奖励", DaTaoSha.GetGlobalAwardForMe, DaTaoSha })
  end
  table.insert(tbOpt, { "结束对话" })
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:BuyAge(bFlag)
  local nDate = tonumber(GetLocalDate("%Y%m%d"))
  if me.GetTask(2189, 520) == nDate then
    Dialog:Say("您今天已经购买过了，每天只可以买一个开心蛋。")
    return 0
  end
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("您的背包空间不足，需要1格背包空间。")
    return 0
  end
  if me.GetJbCoin() < 200 then
    Dialog:Say("您的金币不足，购买1个开心蛋需要200金币。")
    return 0
  end
  if not bFlag then
    Dialog:Say("<color=yellow>9月27日——10月10日期间<color>，每天可以在我这儿以<color=green>200金币的价格购买一个游龙阁开心蛋<color>，祝你天天开心哦。\n\n您是否确定花费<color=yellow>200金币<color>购买1个开心蛋？", { { "确定", self.BuyAge, self, 1 }, { "我再想想" } })
    return 0
  end
  local bRet = me.ApplyAutoBuyAndUse(90, 1, 0)
  if bRet == 1 then
    me.SetTask(2189, 520, nDate)
    Item:GetClass("youlongge_happyegg"):OnLoginDay(nUse)
    if me.GetTask(2106, 4) < 7 then
      me.SetTask(2106, 4, me.GetTask(2106, 4) + 1)
    end
    Dialog:Say("恭喜您成功购买了1个开心蛋")
  end
end

function tbNpc:TransToServer()
  local nAllTimes = GetPlayerSportTask(me.nId, DaTaoSha.GBTSKG_DATAOSHA, DaTaoSha.GBTASKID_ATTEND_ALLNUM) or 0
  local nGlobalBatch = GetPlayerSportTask(me.nId, DaTaoSha.GBTSKG_DATAOSHA, DaTaoSha.GBTASKID_BATCH) or 0
  local nLimitTime = me.GetTask(DaTaoSha.TASKID_GROUP, DaTaoSha.TASKID_LIMIT_TIMES)
  local nTickets = me.GetTask(DaTaoSha.TASKID_GROUP, DaTaoSha.TASKID_TICKETS)
  local nNowDate = tonumber(GetLocalDate("%Y%m%d"))
  if nGlobalBatch ~= DaTaoSha.nBatch then
    nAllTimes = 0
  end
  if nAllTimes >= DaTaoSha.nMaxTime then
    Dialog:Say("您参与本次活动次数已达上限，无法继续参加。")
    return 0
  end
  if nLimitTime <= 0 or nLimitTime <= nAllTimes then
    Dialog:Say("您今天已无挑战机会，还是明天再来吧！")
    return 0
  end
  if nTickets <= 0 or nTickets <= nAllTimes then
    Dialog:Say("您已无挑战资格，可使用月影之石在龙五太爷处购买寒武魂珠增加挑战资格！")
    return 0
  end
  if me.nLevel < DaTaoSha.PLAYER_ATTEND_LEVEL then
    Dialog:Say(string.format("您等级未达到%s级，无法参加本次活动！", DaTaoSha.PLAYER_ATTEND_LEVEL))
    return
  end
  if me.nFaction <= 0 then
    Dialog:Say("您尚未加入门派，无法参加本次活动！")
    return
  end
  Transfer:NewWorld2GlobalMap(me)
  me.SendMsgToFriend(string.format("%s报名参与活动“探索寒武遗迹”！", me.szName))
end

function tbNpc:Introduction(nFlag)
  local szMsg = "寒武遗迹介绍："
  local tbOpt = {
    { "活动时间", self.Introduction, self, 1 },
    { "活动要求", self.Introduction, self, 2 },
    { "活动规则", self.Introduction, self, 3 },
    { "活动流程", self.Introduction, self, 4 },
    { "活动奖励", self.Introduction, self, 5 },
    { "返回上一层", self.OnDialog, self },
  }
  local tbMsg = {
    string.format("<color=green>活动时间：\n  <color>%s——%s每天11:00——14:00、18:00——21:00\n<color=red>注：周六晚有铁浮城战故不开放<color>", os.date("%Y年%m月%d日", Lib:GetDate2Time(DaTaoSha.nStatTime)), os.date("%Y年%m月%d日", Lib:GetDate2Time(DaTaoSha.nEndTime))),
    "<color=green>活动要求：\n  <color>大于等于60级且加入门派侠士",
    string.format(
      [[
		<color=green>活动资格：<color>
	  每位侠士每天增加<color=yellow>5次<color>挑战机会，最多增加至<color=yellow>15次<color>即不会再增长。<color=yellow>参加一次活动需要消耗1次挑战机会与1次挑战资格。<color>挑战资格需要使用月影之石在龙五太爷处购买<color=yellow>寒武魂珠<color>使用后获得。活动期间每位侠士最多参与活动<color=yellow>%s次<color>。

		<color=green>报名方式<color>：
	  拥有活动资格的侠士与各大主城卖<color=yellow>火柴小女孩<color>对话可进入英雄岛报名场地。与场地中<color=yellow>战神李若水<color>对话即可报名。组队报名队伍人数必须为三人，且由队长报名才有效。
		]],
      DaTaoSha.nMaxTime
    ),

    [[
		<color=green>等待期：<color>
	  报名成功后进入等待场地，场地中达到66人会将所有侠士分为22组进入活动场地。
		<color=green>准备期：<color>
	  进入活动场地有3分钟准备期。侠士可通过包裹中门派令牌选择门派。并在准备期最后一分钟开启宝箱获得道具。
		<color=green>活动期：<color>
	  活动分三阶段，每阶段中侠士需要尽量存活。除三阶段外，击败NPC都会获得寒武符石。
		<color=green>休息期：<color>
	  活动一二阶段结束后有休息期，侠士出生点会刷新商人，可使用寒武符石与其购买道具。
		<color=green>其他：<color>
	  一二阶段中，只要队伍中还有人存活坚持到本阶段结束，全队成员都可进入下一阶段。三阶段若最后剩余队伍大于一支则本次活动无优胜者。
		]],
    string.format(
      [[
		<color=green>活动奖励：<color>
	  1、单次活动依据结果都与卖火柴小女孩对话领取奖励。
	  2、每次活动可获得积分，在活动结束后依据积分总排名，前30名可领取雪魂令，使用后获得寒武遗迹声望，可在逍遥谷客商处购买装备。
		<color=green>领奖时间：<color>
	  %s——%s

	]],
      os.date("%Y年%m月%d日", Lib:GetDate2Time(DaTaoSha.DEF_GLOBALAWARD_DATE_BEGIN)),
      os.date("%Y年%m月%d日", Lib:GetDate2Time(DaTaoSha.DEF_GLOBALAWARD_DATE_END))
    ),
  }
  if nFlag then
    tbOpt = { { "返回上一层", self.Introduction, self } }
    szMsg = tbMsg[nFlag]
  end
  Dialog:Say(szMsg, tbOpt)
end
