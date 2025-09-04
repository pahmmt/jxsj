-- 文件名　：xuanzhan.lua
-- 创建者　：xiewen
-- 创建时间：2008-10-31 00:07:10

local tbNpc = Npc:GetClass("xuanzhan")

function tbNpc:OnDialog()
  if KGblTask.SCGetDbTaskInt(DBTASK_DOMAIN_BATTLE_NO) == 0 then
    Dialog:Say("领土争夺战将会在开放89等级上限后的第7天开放，请耐心等候。")
    return 0
  end
  local tbOpt = {
    { "领土战军需", Domain.DlgJunXu, Domain },
    { "征战奖励", Domain.AwardDialog, Domain },
    { "帮会商店", self.OpenTongShop, self },
    { "设置主城", Domain.SelectCapital_Intro, Domain },
    { "购买领土战声望装备", self.OpenReputeShop, self },
    { "结束对话" },
  }
  if Domain:GetBattleState() == Domain.PRE_BATTLE_STATE then
    tbOpt = Lib:MergeTable({ { "宣战", Domain.DeclareWar_Intro, Domain } }, tbOpt)
  end

  if me.GetTaskBit(HelpQuestion.TASK_GROUP_ID, 7) == 0 or me.GetTaskBit(HelpQuestion.TASK_GROUP_ID, 8) == 0 or me.GetTaskBit(HelpQuestion.TASK_GROUP_ID, 9) == 0 or me.GetTaskBit(HelpQuestion.TASK_GROUP_ID, 10) == 0 or me.GetTaskBit(HelpQuestion.TASK_GROUP_ID, 11) == 0 or me.GetTaskBit(HelpQuestion.TASK_GROUP_ID, 12) == 0 then
    tbOpt = Lib:MergeTable({ { "<color=yellow>剑侠辞典之领土战<color>", self.AwardQuestion, self } }, tbOpt)
  end

  local szSay = [[
    领土争夺战的号角已经吹响，现在是群雄逐鹿的时代！
    在每周的<color=green>周]] .. EventManager.IVER_szDomainBattleDay .. [[、周日20：00~21：30<color>，各帮会可以对游戏内的领土发起攻击，占领该领土后可以获得声望、绑银、玄晶及各种神秘道具哦。
]]
  Dialog:Say(szSay, tbOpt)
end

function tbNpc:OpenTongShop()
  me.OpenShop(145, 9)
end

function tbNpc:OpenReputeShop()
  me.OpenShop(147, 1)
end

function tbNpc:AwardQuestion()
  if me.nLevel < 80 then
    local tbOpt = {
      { "返回上一层", self.OnDialog, self },
      { "结束对话" },
    }

    Dialog:Say("您尚未达到80级，不能参加有奖问答。", tbOpt)
  else
    local tbOpt = {
      { "返回上一层", self.OnDialog, self },
      { "结束对话" },
    }
    if me.GetTaskBit(HelpQuestion.TASK_GROUP_ID, 12) == 0 then
      tbOpt = Lib:MergeTable({ { "问答<color=green>规则篇（二）<color>", HelpQuestion.StartGame, HelpQuestion, me, 12 } }, tbOpt)
    end
    if me.GetTaskBit(HelpQuestion.TASK_GROUP_ID, 11) == 0 then
      tbOpt = Lib:MergeTable({ { "问答<color=green>帮会设置篇<color>", HelpQuestion.StartGame, HelpQuestion, me, 11 } }, tbOpt)
    end
    if me.GetTaskBit(HelpQuestion.TASK_GROUP_ID, 10) == 0 then
      tbOpt = Lib:MergeTable({ { "问答<color=green>NPC篇<color>", HelpQuestion.StartGame, HelpQuestion, me, 10 } }, tbOpt)
    end
    if me.GetTaskBit(HelpQuestion.TASK_GROUP_ID, 9) == 0 then
      tbOpt = Lib:MergeTable({ { "问答<color=green>界面篇<color>", HelpQuestion.StartGame, HelpQuestion, me, 9 } }, tbOpt)
    end
    if me.GetTaskBit(HelpQuestion.TASK_GROUP_ID, 8) == 0 then
      tbOpt = Lib:MergeTable({ { "问答<color=green>规则篇<color>", HelpQuestion.StartGame, HelpQuestion, me, 8 } }, tbOpt)
    end
    if me.GetTaskBit(HelpQuestion.TASK_GROUP_ID, 7) == 0 then
      tbOpt = Lib:MergeTable({ { "问答<color=green>流程篇<color>", HelpQuestion.StartGame, HelpQuestion, me, 7 } }, tbOpt)
    end
    local szSay = string.format(
      [[    这位侠士，您是否已经熟悉了领土战的相关规则和流程了呢？
    我这里有若干道问题，如果您能全部答对，我会奖励您丰厚的绑定%s。问题有点难度，建议您仔细阅读F12帮助锦囊里的详细帮助，熟读完领土战相关内容后再来答题。
    您是否准备好开始答题了么？
]],
      IVER_g_szCoinName
    )
    Dialog:Say(szSay, tbOpt)
  end
end
