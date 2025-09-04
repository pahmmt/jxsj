---
-- 逍遥谷猜谜NPC
---

local XoyoNpc_Guess = Npc:GetClass("xoyonpc_guess")

function XoyoNpc_Guess:OnDialog(bConfirm)
  if not him then
    return 0
  end
  local tbTmp = him.GetTempTable("XoyoGame")
  if not tbTmp then
    return 0
  end
  if not tbTmp.tbRoom then
    return 0
  end
  local nTeamId = me.nTeamId
  local nPlayerId = tbTmp.tbRoom:GetTeamGuessPlayer(nTeamId)
  local tbMemberList, nCount = KTeam.GetTeamMemberList(nTeamId)
  local tbOpt = {}
  local szMsg = {}
  if me.nId == tbMemberList[1] then
    if not bConfirm or bConfirm ~= 1 then
      local szMsg = "你就是队长啊，准备好要答题了吗？别紧张，只要在剩下的时间内答完30道题就可以了。对了，你在答题时，你的队员们也可以看到题目和选项，可以征求他们的意见再进行选择哦。"
      local tbTeamInfo = tbTmp.tbRoom:GetTeamInfo(nTeamId)
      if not tbTeamInfo then
        return
      end
      if tbTeamInfo.nQuestCount and tbTeamInfo.nQuestCount < XoyoGame.GUESS_QUESTIONS then
        szMsg = "你的30道问题还没回答完，你准备好继续回答我的问题了吗？"
      elseif tbTeamInfo.nQuestCount and tbTeamInfo.nQuestCount >= XoyoGame.GUESS_QUESTIONS then
        tbTmp.tbRoom:AskQuestion(nTeamId, him.dwId)
        return 0
      end
      Dialog:Say(szMsg, {
        { "准备好了，您发问吧。", self.OnDialog, self, 1 },
        { "我还得再准备一下" },
      })
      return 0
    end
    tbTmp.tbRoom:AskQuestion(nTeamId, him.dwId)
  else
    Dialog:Say("还是让你们的队长来找我吧")
    return 0
  end
end
