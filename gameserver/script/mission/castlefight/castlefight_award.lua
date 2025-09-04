-- castlefight_award.lua
-- zhouchenfei
-- 奖励函数
-- 2010/11/6 13:53:08

function CastleFight:AwardSingleSport(tbListA, tbListB, nResult, tbGrade_player, nGameOverType)
  --平
  if nResult == 3 then
    for _, nId in pairs(tbListA) do
      local pPlayer = KPlayer.GetPlayerObjById(nId)
      if pPlayer then
        local nGrade = self:FindTb(tbGrade_player[1], pPlayer.szName)
        self:AwardSingleTie(pPlayer, nGrade, nGameOverType)
      end
    end

    for _, nId in pairs(tbListB) do
      local pPlayer = KPlayer.GetPlayerObjById(nId)
      if pPlayer then
        local nGrade = self:FindTb(tbGrade_player[2], pPlayer.szName)
        self:AwardSingleTie(pPlayer, nGrade, nGameOverType)
      end
    end
    return 0
  end

  local tbWin = tbListA
  local tbLost = tbListB
  local tbWin_Ex = tbGrade_player[1]
  local tbList_Ex = tbGrade_player[2]
  --胜者
  if nResult == 2 then
    tbWin = tbListB
    tbLost = tbListA
    tbWin_Ex = tbGrade_player[2]
    tbList_Ex = tbGrade_player[1]
  end

  for _, nId in pairs(tbWin) do
    local pPlayer = KPlayer.GetPlayerObjById(nId)
    if pPlayer then
      local nGrade = self:FindTb(tbWin_Ex, pPlayer.szName)
      self:AwardSingleWin(pPlayer, nGrade, nGameOverType)
    end
  end

  for _, nId in pairs(tbLost) do
    local pPlayer = KPlayer.GetPlayerObjById(nId)
    if pPlayer then
      local nGrade = self:FindTb(tbList_Ex, pPlayer.szName)
      self:AwardSingleLost(pPlayer, nGrade, nGameOverType)
    end
  end
end

function CastleFight:AwardSingleWin(pPlayer, nGrade, nGameOverType)
  pPlayer.SetTask(CastleFight.TSK_GROUP, CastleFight.TSK_ATTEND_AWARD, self.WINNER_AWARD_ID[nGrade])
  pPlayer.SetTask(CastleFight.TSK_GROUP, CastleFight.TSK_ATTEND_WIN, pPlayer.GetTask(CastleFight.TSK_GROUP, CastleFight.TSK_ATTEND_WIN) + 1)
  self:AddHonor(pPlayer.szName, self.DEF_POINT_WIN[nGrade])
  pPlayer.Msg("恭喜你队伍获得了胜利")
  local szFriendmsg = string.format("您的好友[%s]在刚刚结束的[决战夜岚关]中获得了一场胜利！", pPlayer.szName)
  local szKinOrTongMsg = "在刚刚结束的[决战夜岚关]中获得了一场胜利！"
  if nGrade == 1 then
    szFriendmsg = string.format("您的好友[%s]在刚刚结束的[决战夜岚关]中拿到了第一名！", pPlayer.szName)
    szKinOrTongMsg = "在刚刚结束的[决战夜岚关]中拿到了第一名！"
  end
  pPlayer.SendMsgToFriend(szFriendmsg)
  Player:SendMsgToKinOrTong(pPlayer, szKinOrTongMsg, 0)
  self:WriteLog("恭喜你队伍获得了胜利", pPlayer.nId)
  StatLog:WriteStatLog("stat_info", "fight_YLG", "award", pPlayer.nId, pPlayer.nTeamId, CastleFight.GAMOVER_TYPE_DEC["win"][nGameOverType], nGrade)
end

function CastleFight:AwardSingleLost(pPlayer, nGrade, nGameOverType)
  pPlayer.SetTask(CastleFight.TSK_GROUP, CastleFight.TSK_ATTEND_AWARD, self.LOST_AWARD_ID[nGrade])
  self:AddHonor(pPlayer.szName, self.DEF_POINT_LOST[nGrade])
  pPlayer.Msg("很遗憾，你队伍在本场比赛中失利了，下次继续加油。")
  self:WriteLog("恭喜你队伍获得了失败", pPlayer.nId)
  StatLog:WriteStatLog("stat_info", "fight_YLG", "award", pPlayer.nId, pPlayer.nTeamId, CastleFight.GAMOVER_TYPE_DEC["lost"][nGameOverType], nGrade)
end

function CastleFight:AwardSingleTie(pPlayer, nGrade, nGameOverType)
  pPlayer.SetTask(CastleFight.TSK_GROUP, CastleFight.TSK_ATTEND_AWARD, self.LOST_AWARD_ID[nGrade])
  pPlayer.SetTask(CastleFight.TSK_GROUP, CastleFight.TSK_ATTEND_TIE, pPlayer.GetTask(CastleFight.TSK_GROUP, CastleFight.TSK_ATTEND_TIE) + 1)
  self:AddHonor(pPlayer.szName, self.DEF_POINT_TIE[nGrade])
  pPlayer.Msg("很遗憾，你队伍在本场比赛中和对手打平了，下次继续加油。")
  self:WriteLog("恭喜你队伍获得了平局", pPlayer.nId)
  StatLog:WriteStatLog("stat_info", "fight_YLG", "award", pPlayer.nId, pPlayer.nTeamId, "draw", nGrade)
end

function CastleFight:FindTb(tbGrade, szName)
  for i, _ in ipairs(tbGrade) do
    if tbGrade[i][1] == szName then
      return i
    end
  end
end
