-------------------------------------------------------
-- 文件名　 : superbattle_npc_city.lua
-- 创建者　 : zhangjinpin@kingsoft
-- 创建时间 : 2011-06-02 15:13:41
-- 文件描述 :
-------------------------------------------------------

if not MODULE_GAMESERVER then
  return
end

Require("\\script\\globalserverbattle\\superbattle\\superbattle_def.lua")

local tbNpc = Npc:GetClass("superbattle_npc_city")
--排名积分
tbNpc.tbLadderHonor = {
  [1] = 400,
  [4] = 320,
  [10] = 280,
  [20] = 240,
}
tbNpc.tbGradeHonor = {
  [5000] = 280,
  [4000] = 240,
  [3000] = 200,
  [2500] = 160,
  [2000] = 130,
  [1500] = 100,
  [1000] = 80,
  [500] = 60,
}
function tbNpc:OnDialog()
  -- 活动是否开启
  if SuperBattle:CheckIsOpen() ~= 1 then
    Dialog:Say("春潮带雨晚来急，野渡无人舟自横。")
    return 0
  end

  -- 区服是否开启跨服功能
  local nTransferId = Transfer:GetMyTransferId(me)
  if not Transfer.tbGlobalMapId[nTransferId] then
    Dialog:Say("春潮带雨晚来急，野渡无人舟自横。")
    return 0
  end

  local nTotalBox = GetPlayerSportTask(me.nId, SuperBattle.GA_TASK_GID, SuperBattle.GA_TASK_BOX) or 0
  local nBox = math.floor(nTotalBox / 100) - me.GetTask(SuperBattle.TASK_GID, SuperBattle.TASK_BOX)

  local szMsg = string.format("    二十年了，我始终忘不了那一战。千索横江，万剑纵横，烽烟蔽天日。来跟我回到当年的战场吧！\n<color=yellow>（战场结束后请回到我这里领取奖励）<color>\n\n    以你本周的战绩，下周可以领取的宝石原矿为：<color=yellow>%s个<color>。", nBox)
  local tbOpt = {
    { "<color=yellow>跨服宋金报名<color>", self.AttendSuperBattle, self },
    { "领取上周奖励", self.GetAward, self },
    { "领取本场奖励", self.GetExp, self },
    { "了解跨服战场", self.Help, self },
    { "我知道了" },
  }

  if me.GetTask(SuperBattle.TASK_GID, SuperBattle.TASK_MANTLE) == 1 then
    table.insert(tbOpt, 2, { "<color=yellow>跨服宋金商店<color>", self.MantleShop, self })
  end

  Dialog:Say(szMsg, tbOpt)
end

-- 本服报名
function tbNpc:AttendSuperBattle()
  SuperBattle:SelectState_GS(me)
end

-- 领取奖励
function tbNpc:GetAward(nSure)
  local nWeek = me.GetTask(SuperBattle.TASK_GID, SuperBattle.TASK_WEEK)
  if nWeek >= SuperBattle:GetWeek() or SuperBattle:GetWeek() == 1 then
    Dialog:Say("对不起，请下周再来领奖。")
    return 0
  end

  local nTotalBox = GetPlayerSportTask(me.nId, SuperBattle.GA_TASK_GID, SuperBattle.GA_TASK_BOX) or 0
  local nBox = math.floor(nTotalBox / 100) - me.GetTask(SuperBattle.TASK_GID, SuperBattle.TASK_BOX)

  if nBox <= 0 then
    Dialog:Say("你没有任何奖励可以领取。")
    return 0
  end

  if not nSure then
    local szMsg = string.format("    你当前可以领取<color=yellow>%s<color>个宝石原矿，确定要领取么？\n", nBox)
    if GetPlayerSportTask(me.nId, SuperBattle.GA_TASK_GID, SuperBattle.GA_TASK_MANTLE) == 1 then
      szMsg = string.format("%s<color=yellow>（您在跨服宋金中取得了好成绩，将会获得使用逐日勇士披风的资格）<color>", szMsg)
    end
    local tbOpt = {
      { "确定", self.GetAward, self, 1 },
      { "我再想想" },
    }
    Dialog:Say(szMsg, tbOpt)
    return 0
  end

  -- 叠加物品背包空间
  local nNeed = KItem.GetNeedFreeBag(SuperBattle.AWARDBOX_ID[1], SuperBattle.AWARDBOX_ID[2], SuperBattle.AWARDBOX_ID[3], SuperBattle.AWARDBOX_ID[4], { bForceBind = 1 }, nBox)
  if me.CountFreeBagCell() < nNeed then
    Dialog:Say(string.format("请留出%s格背包空间。", nNeed))
    return 0
  end

  -- 箱子
  me.AddStackItem(SuperBattle.AWARDBOX_ID[1], SuperBattle.AWARDBOX_ID[2], SuperBattle.AWARDBOX_ID[3], SuperBattle.AWARDBOX_ID[4], { bForceBind = 1 }, nBox)
  me.SetTask(SuperBattle.TASK_GID, SuperBattle.TASK_BOX, me.GetTask(SuperBattle.TASK_GID, SuperBattle.TASK_BOX) + nBox)

  me.SetTask(SuperBattle.TASK_GID, SuperBattle.TASK_WEEK, SuperBattle:GetWeek())
  SuperBattle:StatLog("get_award", me.nId, nWeek, nBox)

  if GetPlayerSportTask(me.nId, SuperBattle.GA_TASK_GID, SuperBattle.GA_TASK_MANTLE) == 1 then
    me.AddTitle(unpack(SuperBattle.TITLE_ID))
    me.AddSkillState(SuperBattle.BUFFER_ID, 1, 2, SuperBattle.BUFFER_TIME, 1, 0, 1)
    me.SetTask(SuperBattle.TASK_GID, SuperBattle.TASK_MANTLE, 1)
    me.Msg("恭喜您获得使用逐日勇士披风的资格！")
    GCExcute({ "SuperBattle:GetMantleBuffer_GC", me.szName })
    local szMsg = "在跨服宋金战场_梦回采石矶获得了战神称号及逐日勇士资格。"
    me.SendMsgToFriend(string.format("您的好友[%s]%s", me.szName, szMsg))
    Player:SendMsgToKinOrTong(me, szMsg)
  end
end

function tbNpc:MantleShop()
  me.OpenShop(199, 3)
end

function tbNpc:GetExp(nSure)
  local nTotalExp = GetPlayerSportTask(me.nId, SuperBattle.GA_TASK_GID, SuperBattle.GA_TASK_EXP) or 0
  local nExp = nTotalExp - me.GetTask(SuperBattle.TASK_GID, SuperBattle.TASK_EXP)
  if nExp <= 0 then
    Dialog:Say("你没有任何奖励可以领取。")
    return 0
  end

  local nBindMoney = SuperBattle:CalcPlayerBindMoney(nExp)
  local nRepute = GetPlayerSportTask(me.nId, SuperBattle.GA_TASK_GID, SuperBattle.GA_TASK_REPUTE) or 0

  local nSort = GetPlayerSportTask(me.nId, SuperBattle.GA_TASK_GID, SuperBattle.GA_TASK_SORT) or 0
  local nPoint = GetPlayerSportTask(me.nId, SuperBattle.GA_TASK_GID, SuperBattle.GA_TASK_POINT) or 0
  local nOffer = SuperBattle:CalcPlayerOffer(nSort, nPoint)
  local nPad = math.min(math.floor(nPoint / 1000), 5)

  if not nSure then
    local szMsg = string.format(
      [[你当前可以领取：
			
    <color=yellow>%s<color>经验
    <color=yellow>%s<color>绑银
    <color=yellow>%s点<color>威望
    <color=yellow>%s个<color>商会书卷
    
确定要领取么？
<color=yellow>（每周可以领取的威望上限为60点）<color>]],
      me.GetBaseAwardExp() * nExp,
      nBindMoney,
      nRepute,
      nPad,
      nOffer
    )
    local tbOpt = {
      { "确定", self.GetExp, self, 1 },
      { "我再想想" },
    }
    Dialog:Say(szMsg, tbOpt)
    return 0
  end
  local nFreeCount, tbFunExecute = SpecialEvent.ExtendAward:DoCheck("SuperBattle", me, nPoint)

  -- 绑银
  if nBindMoney + me.GetBindMoney() > me.GetMaxCarryMoney() then
    Dialog:Say("对不起，领取后您身上的绑定银两将会超出上限，请整理后再来领取。")
    return 0
  end

  -- 牌子
  if nPad + nFreeCount > 0 then
    if me.CountFreeBagCell() < nPad + nFreeCount then
      Dialog:Say(string.format("请留出%s格背包空间。", nPad))
      return 0
    end
    for i = 1, nPad do
      me.AddItem(SuperBattle.PAD_ID[1], SuperBattle.PAD_ID[2], SuperBattle.PAD_ID[3], SuperBattle.PAD_ID[4])
    end
  end

  SpecialEvent.ExtendAward:DoExecute(tbFunExecute)

  SpecialEvent.ActiveGift:AddCounts(me, 31) --领取宋金奖励完成一场宋金活跃度

  if TimeFrame:GetState("Keyimen") == 1 then
    Item:ActiveDragonBall(me)
  end

  -- 经验和威望
  me.AddExp(me.GetBaseAwardExp() * nExp)
  me.AddBindMoney(nBindMoney)
  me.SetTask(SuperBattle.TASK_GID, SuperBattle.TASK_EXP, me.GetTask(SuperBattle.TASK_GID, SuperBattle.TASK_EXP) + nExp)
  me.AddKinReputeEntry(nRepute, "superbattle")
  --本服宋金声望
  self:AddRepute(nSort, nPoint)

  -- 股权
  Tong:AddStockBaseCount_GS1(me.nId, nOffer, 0.8, 0.1, 0.1, 0, 0)

  -- task
  if me.GetTask(1022, 233) == 1 and GetPlayerSportTask(me.nId, SuperBattle.GA_TASK_GID, SuperBattle.GA_TASK_TASK1) == 1 then
    me.SetTask(1022, 228, 1)
    GCExcute({ "SuperBattle:FinishTask_GC", me.szName, 1 })
  end

  if me.GetTask(1022, 234) == 1 and GetPlayerSportTask(me.nId, SuperBattle.GA_TASK_GID, SuperBattle.GA_TASK_TASK2) == 1 then
    me.SetTask(1022, 231, 1)
    GCExcute({ "SuperBattle:FinishTask_GC", me.szName, 2 })
  end
end

function tbNpc:AddRepute(nSort, nPoint)
  local nAddHonor = 0
  local bLadder = 0
  for i, nHonor in pairs(self.tbLadderHonor) do
    if nSort <= i then
      nAddHonor = nHonor
      bLadder = 1
      break
    end
  end
  if bLadder <= 0 then
    for i, nHonor in pairs(self.tbGradeHonor) do
      if nPoint >= i then
        nAddHonor = nHonor
        break
      end
    end
  end
  if nAddHonor > 0 then
    PlayerHonor:AddPlayerHonor(me, PlayerHonor.HONOR_CLASS_BATTLE, 0, nAddHonor)
  end
end

function tbNpc:Help()
  Task.tbHelp:OpenNews(5, "梦回采石矶")
end
