-------------------------------------------------------------------
--File: 	huadeng.lua
--Author: 	sunduoliang
--Date: 	2008-3-3 19:00
--Describe:	猜谜花灯
-------------------------------------------------------------------

local tbGuessGame = Npc:GetClass("huadengshizhe")

function tbGuessGame:OnDialog()
  self:StartDialog(him.dwId)
end

function tbGuessGame:StartDialog(nHimId)
  --local pHim = KNpc.GetById(nHimId)
  --if pHim == nil then
  --	return 0;
  --end
  if me.GetTiredDegree1() == 2 then
    Dialog:Say("您太累了，还是休息下吧！")
    return
  end
  tbGuessGame._tbBase = GuessGame
  local pPlayer = me
  local szSex = "侠女"
  if pPlayer.nSex == Env.SEX_MALE then
    szSex = "侠士"
  end
  if self:CheckLimit(pPlayer) == 0 then
    Dialog:Say("只有加入门派并等级达到30级的侠士侠女才能参加活动。")
    return 0
  end

  local nState = pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_STATE_ID)
  local nStopSec = pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_ATTEND_GAME_ID)
  self:ClearPlayerData(pPlayer)
  if pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_GET_AWARD_ID) > 0 then
    Dialog:Say("您已经领取了今天活动奖励，不能再参加今天的活动了。")
    return 0
  end

  if nStopSec > 0 then
    if nStopSec >= GetTime() then
      Dialog:Say("因为您答错了题目，还在停秒中，请查看右边提示框")
      return 0
    else
      self:StartGameAgain(pPlayer.nId)
    end
  end

  if self.nAnnouceCount ~= nState then
    pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_STATE_ID, self.nAnnouceCount)
    pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_SHARE_ID, 0)
    pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_COUNT_ID, 0)
  end

  if pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_ALLCOUNT_ID) == 0 and pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_WRONG_COUNT) == 0 and pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_WRONG_ID) == 0 then
    local szMsg = string.format("：我这里有几个灯谜，实在是猜不出了，%s帮我看看好不好？", szSex)
    self:ShowMovie(szMsg, self.CreateDialog, nHimId, pPlayer.nId) --to do 电影效果
    -- 记录参加次数
    local nNum = pPlayer.GetTask(StatLog.StatTaskGroupId, 5) + 1
    pPlayer.SetTask(StatLog.StatTaskGroupId, 5, nNum)
    return 0
  end
  self:CreateDialog(nHimId, pPlayer.nId)
end

function tbGuessGame:CreateDialog(nHimId, nPlayerId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  --local pHim = KNpc.GetById(nHimId)
  if pPlayer == nil then
    return 0
  end

  if pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_ALLCOUNT_ID) >= self.GUESS_ALLCOUNT_MAX then --如果今天已答完30题
    Setting:SetGlobalObj(pPlayer)
    Dialog:Say(string.format("喜您已经猜对了%s个灯谜，今天已经不能继续猜了，请前往礼官处领取奖励。", self.GUESS_ALLCOUNT_MAX))
    Setting:RestoreGlobalObj()
    return 0
  end

  if pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_COUNT_ID) >= self.GUESS_COUNT_MAX then --如果本轮已答完6题
    Setting:SetGlobalObj(pPlayer)
    Dialog:Say(string.format("您已经猜对了%s个灯谜，等下一轮再来继续猜吧。", self.GUESS_COUNT_MAX))
    Setting:RestoreGlobalObj()
    return 0
  end
  local tbNowQuestion = {}
  local nQquestionId = pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_WRONG_ID)
  if nQquestionId ~= 0 then
    tbNowQuestion = self.tbGuessQuestion[nQquestionId]
  else
    nQquestionId, tbNowQuestion = self:GetQuestion()
  end
  local tbOpt = {
    { tbNowQuestion.szAnswer, self.RightAnswer, self, nQquestionId, nHimId },
    { tbNowQuestion.szSelect1, self.WrongAnswer, self, nQquestionId, nHimId },
    { tbNowQuestion.szSelect2, self.WrongAnswer, self, nQquestionId, nHimId },
  }
  tbOpt = self:GetRandomTable(tbOpt, #tbOpt)
  table.insert(tbOpt, { "结束对话" })
  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_WRONG_ID, nQquestionId)
  Dialog:Say(tbNowQuestion.szQuestion, tbOpt)
end

function tbGuessGame:RightAnswer(nQquestionId, nHimId)
  local pPlayer = me
  --local pHim = KNpc.GetById(nHimId)
  if pPlayer == nil then
    return 0
  end
  --KStatLog.ModifyAdd("RoleWeeklyEvent", me.szName, "本周参加答题次数", 1);

  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_COUNT_ID, pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_COUNT_ID) + 1)
  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_ALLCOUNT_ID, pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_ALLCOUNT_ID) + 1)
  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_WRONG_ID, 0)
  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_WRONG_COUNT, 0)
  self:ShareRightAnswer(pPlayer)
  if pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_ALLCOUNT_ID) >= self.GUESS_ALLCOUNT_MAX then
    local szSex = "姐姐"
    if pPlayer.nSex == Env.SEX_MALE then
      szSex = "哥哥"
    end
    local szMsg = string.format("：%s，今天的灯谜你帮我全部猜完了，快去礼官那里看看能得到什么好东西吧。", szSex)
    self:ShowMovie(szMsg, 0, 0, pPlayer.nId) --to do 电影效果
    self:GetAchiemement(pPlayer) -- 师徒成就：回答正确所有问题
    return 0
  elseif pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_COUNT_ID) >= self.GUESS_COUNT_MAX then
    Dialog:Say("恭喜您答对了本轮所有题。")
  else
    local tbOpt = {
      { "继续答题", self.StartDialog, self, nHimId },
      { "结束对话" },
    }
    Dialog:Say("恭喜您答对了该题，是否继续答下一题吗？", tbOpt)
  end
end

function tbGuessGame:ShareRightAnswer(pPlayer)
  if pPlayer == nil then
    return 0
  end
  local tbTeamMemberList = pPlayer.GetTeamMemberList()
  if tbTeamMemberList == nil then
    pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_GRADE_ID, pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_GRADE_ID) + self.GUESS_MY_GRADE)
    pPlayer.Msg(string.format("您答对了题目，获得了<color=yellow>%s点<color>积分。", self.GUESS_MY_GRADE))
  else
    for _, pMemPlayer in pairs(tbTeamMemberList) do
      local nGrade = self.GUESS_MY_GRADE
      if self:CheckLimit(pMemPlayer) ~= 0 then --是否符合非白名玩家
        if pPlayer.nMapId == pMemPlayer.nMapId then --是否在同地图
          if pPlayer.nId ~= pMemPlayer.nId then --是否是答对题目的玩家
            self:ClearPlayerData(pMemPlayer)
            if self.nAnnouceCount ~= pMemPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_STATE_ID) then
              pMemPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_STATE_ID, self.nAnnouceCount)
              pMemPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_SHARE_ID, 0)
              pMemPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_COUNT_ID, 0)
            end
            if pMemPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_GET_AWARD_ID) <= 0 and pMemPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_SHARE_ID) < self.GUESS_SHARE then
              nGrade = self.GUESS_SHARE_GRADE
              pMemPlayer.Msg(string.format("您的队友<color=yellow>%s<color>答对了题目，您获得了<color=yellow>%s<color>分享积分。", pPlayer.szName, nGrade))
              pMemPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_SHARE_ID, pMemPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_SHARE_ID) + 1)
            else
              nGrade = 0
            end
          else
            pMemPlayer.Msg(string.format("您答对了题目，获得了<color=yellow>%s<color>积分。", nGrade))
          end
          if nGrade ~= 0 then
            pMemPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_GRADE_ID, pMemPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_GRADE_ID) + nGrade)
          end
        end
      end
    end
  end
  return 0
end

function tbGuessGame:WrongAnswer(nQquestionId, nHimId)
  local pPlayer = me
  --local pHim = KNpc.GetById(nHimId)
  if pPlayer == nil then
    return 0
  end
  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_WRONG_ID, nQquestionId)
  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_WRONG_COUNT, pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_WRONG_COUNT) + 1)
  local nStopTime = self.GUESS_WRONG_ONE_TIME
  local szMsg = string.format("这个答案不对哟，再给你%s秒时间好好想想。", nStopTime)
  if pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_WRONG_COUNT) >= self.GUESS_WRONG_MANY_COUNT then
    nStopTime = self.GUESS_WRONG_MANY_TIME
    szMsg = string.format("这道题你已经连续答错%s次了，看来要给你多点时间想清楚哦！%s秒以后再来找我吧。", pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_WRONG_COUNT), nStopTime)
  end
  self:ShowStopTime(pPlayer, nStopTime)
  Dialog:Say(szMsg)
  return 0
end

function tbGuessGame:ShowStopTime(pPlayer, nStopTime)
  if pPlayer == nil then
    return 0
  end
  local nTimerId = Timer:Register(nStopTime * Env.GAME_FPS, self.StartGameAgain, self, pPlayer.nId)
  local nLastFrameTime = tonumber(Timer:GetRestTime(nTimerId))
  local szMsgFormat = "<color=green>禁止答题时间还剩：<color><color=white>%s<color>"
  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_ATTEND_GAME_ID, (GetTime() + nStopTime))
  Dialog:SetBattleTimer(pPlayer, szMsgFormat, nLastFrameTime)
  Dialog:SendBattleMsg(pPlayer, "\n此期间不能回答灯谜")
  Dialog:ShowBattleMsg(pPlayer, 1, 0) --开启界面
  return 0
end

function tbGuessGame:StartGameAgain(nPlayerId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return 0
  end
  if pPlayer then
    pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_ATTEND_GAME_ID, 0)
    Dialog:ShowBattleMsg(pPlayer, 0, 0) -- 关闭界面
  end
  return 0
end

function tbGuessGame:ShowMovie(szMsg, szfun, nHimId, nPlayerId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if pPlayer == nil then
    return 0
  end
  local szMessage = string.format("<npc=%s>%s", self.NPC_ID, szMsg)
  Setting:SetGlobalObj(pPlayer)
  if szfun == 0 or szfun == nil then
    TaskAct:Talk(szMessage)
  else
    TaskAct:Talk(szMessage, szfun, self, nHimId, nPlayerId)
  end
  Setting:RestoreGlobalObj()
  return 0
end

function tbGuessGame:GetRandomTable(tbitem, nmax)
  for ni = 1, nmax do
    local p = Random(nmax) + 1
    tbitem[ni], tbitem[p] = tbitem[p], tbitem[ni]
  end
  return tbitem
end

function tbGuessGame:GetQuestion()
  local nQId = Random(#self.tbGuessQuestion) + 1
  return nQId, self.tbGuessQuestion[nQId]
end

-- 师徒成就：在一次猜灯谜活动中回答正确所有的问题
function tbGuessGame:GetAchiemement(pPlayer)
  if not pPlayer then
    return
  end
  Achievement_ST:FinishAchievement(pPlayer.nId, Achievement_ST.DENGMI)
end
