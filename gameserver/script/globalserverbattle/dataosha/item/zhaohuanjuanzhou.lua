-- 文件名  : zhaohuanjuanzhou.lua
-- 创建者  : jiazhenwei
-- 创建时间: 2010-12-08 11:51:56
-- 描述    : 召唤卷轴

local tbItem = Item:GetClass("zhaohuanjuanzhou")

function tbItem:OnUse()
  local nTime = tonumber(GetLocalDate("%Y%m%d"))
  if nTime < DaTaoSha.nStatTime or nTime > DaTaoSha.nEndTime then
    me.Msg("不在活动期间，无法使用寒武魂珠。")
    return 0
  end
  local nLimitTime = me.GetTask(DaTaoSha.TASKID_GROUP, DaTaoSha.TASKID_LIMIT_TIMES)
  local nAllTimes = GetPlayerSportTask(me.nId, DaTaoSha.GBTSKG_DATAOSHA, DaTaoSha.GBTASKID_ATTEND_ALLNUM) or 0
  local nTickets = me.GetTask(DaTaoSha.TASKID_GROUP, DaTaoSha.TASKID_TICKETS)
  local nGlobalBatch = GetPlayerSportTask(me.nId, DaTaoSha.GBTSKG_DATAOSHA, DaTaoSha.GBTASKID_BATCH) or 0
  if nGlobalBatch ~= DaTaoSha.nBatch then
    nAllTimes = 0
  end
  if me.nLevel < DaTaoSha.PLAYER_ATTEND_LEVEL then
    me.Msg(string.format("您的等级还未达到 %s 级，恐怕不能使用这个道具。", DaTaoSha.PLAYER_ATTEND_LEVEL))
    return 0
  end
  if me.nFaction <= 0 then
    me.Msg("加入门派后才能使用这个道具。")
    return 0
  end

  if nAllTimes >= DaTaoSha.nMaxTime then
    local szMsg = string.format("您累计参加活动已达<color=yellow>%s次<color>上限，无法再增加挑战资格。", DaTaoSha.nMaxTime)
    me.Msg(szMsg)
    Dialog:SendInfoBoardMsg(me, szMsg)
    return 0
  end

  if nTickets >= DaTaoSha.nMaxTime then
    me.Msg(string.format("活动期间累计最多获得挑战资格<color=yellow>%s次<color>，您已达上限！", DaTaoSha.nMaxTime))
    return 0
  end
  if nTickets >= nLimitTime then
    local szMsg = "挑战资格无法大于当日挑战机会，您可明日使用魂珠！"
    me.Msg(szMsg)
    Dialog:SendInfoBoardMsg(me, szMsg)
    return 0
  end
  me.SetTask(DaTaoSha.TASKID_GROUP, DaTaoSha.TASKID_TICKETS, nTickets + 1)
  me.Msg("您获得了一次参与寒武遗迹的资格。")
  Dialog:SendBlackBoardMsg(me, "您获得一次参与“探索寒武遗迹”的资格，在卖火柴小女孩处报名！")
  return 1
end
