--官府通缉任务
--孙多良
--2008.08.06
Require("\\script\\task\\wanted\\wanted_def.lua")

function Wanted:OnDialog()
  local nFlag = self:Check_Task()
  if nFlag == 1 then
    self:OnDialog_Finish()
  elseif nFlag == 2 then
    local nSec = self:GetTask(self.TASK_ACCEPT_TIME)
    if nSec > 0 and tonumber(os.date("%Y%m%d", GetTime())) > tonumber(os.date("%Y%m%d", nSec)) then
      --如果任务已经过期但未完成；
      self:CancelTask(1)
      me.Msg("很遗憾，你的官府通缉任务因为过期未完成而失败。官府通缉任务必须当天接取当天完成。")
      local tbOpt = {
        { "我要接受新的任务", self.OnDialog, self },
        { "我再考虑考虑" },
      }
      Dialog:Say("很遗憾，你的官府通缉任务因为过期未完成而失败。官府通缉任务必须当天接取当天完成。", tbOpt)
      return 0
    end
    self:OnDialog_NoFinish()
  elseif nFlag == 3 then
    self:OnDialog_NoAccept()
  else
    self:OnDialog_Accept()
  end
end

function Wanted:OnDialog_Accept()
  local szMsg = string.format("刑部捕头：近日各地江洋大盗横行，民不堪扰，你愿意协助衙门，缉拿江洋大盗，为民除害么？不过官府只有每天%s-%s才开放任务。\n\n<color=yellow>您今天还能完成%s次<color>", Lib:HourMinNumber2TimeDesc(self.DEF_DATE_START), Lib:HourMinNumber2TimeDesc(self.DEF_DATE_END), self:GetTask(self.TASK_COUNT))

  if EventManager.IVER_bOpenWantedLimitTime == 0 then
    szMsg = string.format("刑部捕头：近日各地江洋大盗横行，民不堪扰，你愿意协助衙门，缉拿江洋大盗，为民除害么？\n\n<color=yellow>您今天还能完成%s次<color>", self:GetTask(self.TASK_COUNT))
  end

  local tbOpt = {
    { "我愿前往缉拿江洋大盗", self.SingleAcceptTask, self },
    { "我要用名捕令兑换奖励", self.OnGetAward, self },
    { "我要兑换昏暗封印", self.OnGetAwardCallBoss, self },
    { "我再考虑考虑" },
  }
  if me.IsCaptain() == 1 then
    table.insert(tbOpt, 1, { "我想与队友一起缉拿江洋大盗", self.CaptainAcceptTask, self })
  end
  Dialog:Say(szMsg, tbOpt)
end

function Wanted:OnDialog_NoAccept()
  local szMsg = string.format("刑部捕头：近日各地江洋大盗横行，民不堪扰，你愿意协助衙门，缉拿江洋大盗，为民除害么？不过我看你的实力还不够，还需要锻炼，等达到50级后再来找我吧。")
  local tbOpt = {
    { "我知道了" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function Wanted:OnDialog_Finish()
  local nTask = Task:GetPlayerTask(me).tbTasks[self.TASK_MAIN_ID].nReferId
  local szMsg = self:CreateText(nTask)
  local tbOpt = {
    { "任务完成，特来领取奖励", self.FinishTask, self },
    { "我要用名捕令兑换奖励", self.OnGetAward, self },
    { "我要兑换昏暗封印", self.OnGetAwardCallBoss, self },
    { "我再考虑考虑" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function Wanted:OnDialog_NoFinish()
  local nTask = Task:GetPlayerTask(me).tbTasks[self.TASK_MAIN_ID].nReferId
  local szMsg = self:CreateText(nTask)
  local tbOpt = {
    { "我要取消任务", self.CancelTask, self },
    { "我要用名捕令兑换奖励", self.OnGetAward, self },
    { "我要兑换昏暗封印", self.OnGetAwardCallBoss, self },
    { "我再考虑考虑" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function Wanted:CreateText(nTask)
  local szMsg = string.format("任务名称：[<color=green>缉拿江洋大盗%s<color>]\n任务描述：听闻<color=green>江洋大盗%s<color>近日出现在<color=yellow>%s<color>的（<color=yellow>%s,%s<color>）处，你务必将其缉拿归案，恢复当地安宁。", self.TaskFile[nTask].szTaskName, self.TaskFile[nTask].szTaskName, self.TaskFile[nTask].szMapName, math.floor(self.TaskFile[nTask].nPosX / 8), math.floor(self.TaskFile[nTask].nPosY / 16))
  return szMsg
end

function Wanted:OnGetAward()
  local szMsg = "刑部捕头：江洋大盗纷纷被缉拿归案，朝廷发下重赏。诸位大侠皆可凭名捕令在我这里，兑换各种奖励。"
  local tbOpt = {
    { "我要兑换武林秘籍（初级）", self.OnGift, self, self.ITEM_WULINMIJI },
    { "我要兑换洗髓经（初级）", self.OnGift, self, self.ITEM_XISUIJING },
    { "我再考虑考虑" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function Wanted:OnGift(tbItem)
  local tbParam = {
    tbAward = {
      {
        nGenre = tbItem[1][1],
        nDetail = tbItem[1][2],
        nParticular = tbItem[1][3],
        nLevel = tbItem[1][4],
        nCount = 1,
      },
    },
    tbMareial = {
      {
        nGenre = self.ITEM_MINGBULING[1],
        nDetail = self.ITEM_MINGBULING[2],
        nParticular = self.ITEM_MINGBULING[3],
        nLevel = self.ITEM_MINGBULING[4],
        nCount = tbItem[2],
      },
    },
  }
  local szContent = string.format("\n换取<color=yellow>%s<color>需要<color=yellow>%s<color>个<color=yellow>%s<color>", KItem.GetNameById(unpack(tbItem[1])), tbItem[2], KItem.GetNameById(unpack(self.ITEM_MINGBULING)))
  Wanted.Gift:OnOpen(szContent, tbParam)
end

function Wanted:OnGetAwardCallBoss(nSure)
  if nSure == 1 then
    if me.CountFreeBagCell() < 1 then
      Dialog:Say("您的背包空间不足，请整理1格背包空间。")
      return 0
    end
    if me.dwCurGTP < self.DEF_PAYGTP then
      Dialog:Say(string.format("您的活力不足%s，需要精力%s点和活力%s点。", self.DEF_PAYGTP, self.DEF_PAYGTP, self.DEF_PAYMKP))
      return 0
    end
    if me.dwCurMKP < self.DEF_PAYMKP then
      Dialog:Say(string.format("您的精力不足%s，需要精力%s点和活力%s点。", self.DEF_PAYMKP, self.DEF_PAYGTP, self.DEF_PAYMKP))
      return 0
    end

    for nLevel = 1, 5 do
      local tbItem = me.FindItemInBags(self.ITEM_MINGBUXIANG[1], self.ITEM_MINGBUXIANG[2], self.ITEM_MINGBUXIANG[3], nLevel)
      if #tbItem <= 0 then
        Dialog:Say(string.format(
          [[  换取1个<color=yellow>昏暗封印<color>需要如下材料：<color=yellow>
					
    封印残片(金)
    封印残片(木)
    封印残片(水)
    封印残片(火)
    封印残片(土)
    精力%s点
    活力%s点
    <color>
  你身上的材料不足，无法兑换。
		]],
          self.DEF_PAYGTP,
          self.DEF_PAYMKP
        ))
        return 0
      end
    end

    me.ChangeCurGatherPoint(-self.DEF_PAYGTP) --减精力
    me.ChangeCurMakePoint(-self.DEF_PAYMKP) --减活力
    for nLevel = 1, 5 do
      me.ConsumeItemInBags2(1, self.ITEM_MINGBUXIANG[1], self.ITEM_MINGBUXIANG[2], self.ITEM_MINGBUXIANG[3], nLevel)
    end
    local tbItemInfo = { bForceBind = 1 }
    local pItem = me.AddItemEx(self.ITEM_CALLBOSSLP[1], self.ITEM_CALLBOSSLP[2], self.ITEM_CALLBOSSLP[3], self.ITEM_CALLBOSSLP[4], tbItemInfo)
    if not pItem then
      Dbg:WriteLog("Wanted", "ChangeCallBoss", "AddItem Not!!!", me.szName)
    end

    local tbOpt = {
      { "继续兑换", self.OnGetAwardCallBoss, self },
      { "不用了" },
    }
    Dialog:Say("你成功兑换了一个名捕召唤令牌，是否要继续兑换？", tbOpt)
    return 0
  end
  local szMsg = string.format(
    [[  换取1个<color=yellow>昏暗封印<color>需要如下材料：<color=yellow>
		
    封印残片(金)
    封印残片(木)
    封印残片(水)
    封印残片(火)
    封印残片(土)
    精力%s点
    活力%s点
    <color>
  你需要现在兑换吗？
		]],
    self.DEF_PAYGTP,
    self.DEF_PAYMKP
  )
  local tbOpt = {
    { "我确定要兑换", self.OnGetAwardCallBoss, self, 1 },
    { "我再考虑考虑" },
  }
  Dialog:Say(szMsg, tbOpt)
end
