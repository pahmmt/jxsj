-------------------------------------------------------
-- 文件名　：longwutaiye.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2009-11-16 14:21:55
-- 文件描述：修改原有逻辑结构
-------------------------------------------------------

local tbJie = Npc:GetClass("longwutaiye")

function tbJie:OnDialog()
  local szMsg = "您好，有什么可以帮到你呢？"
  local tbOpt = {}

  --mini客户端，更改为玩家20级或才可以看到龙五其他的功能
  local nLookLevel = 20
  if me.nLevel >= nLookLevel then
    if Youlongmibao:CheckState() == 1 then
      table.insert(tbOpt, { "<color=yellow>月影之石店<color>(需要月影之石）", self.Challenge, self })
      table.insert(tbOpt, { "<color=yellow>游龙杂货店<color>(需要游龙古币）", self.OpenYouLongZahuoShop, self })
      table.insert(tbOpt, { "<color=yellow>装备声望店<color>(需要游龙古币）", self.OpenYouLongReputeShop, self })
    end

    if IVER_g_nTwVersion == 1 then
      table.insert(tbOpt, { "月影之石商店", self.Challenge, self })
    end

    if Partner.bOpenPartner == 1 then
      table.insert(tbOpt, { '什么是"同伴"', self.OnSelectPartnerDesc, self })
      table.insert(tbOpt, { "同伴装备解锁", Partner.UnBindPartEq, Partner, me.nId })
      table.insert(tbOpt, { "同伴特殊材料兑换同伴秘籍", self.ChangePartnerMiJi, self })
      table.insert(tbOpt, { "无上智慧精华拆解", self.SplitPartnerJinghua, self })
      table.insert(tbOpt, { "护体真元转为非护体", self.ChangeZhenYuan, self })
    end

    local nData = tonumber(GetLocalDate("%Y%m%d"))
    if nData >= SpecialEvent.SpringFrestival.HuaDengOpenTime and nData <= SpecialEvent.SpringFrestival.HuaDengCloseTime then --活动期间内启动服务器
      table.insert(tbOpt, 1, { "年画收集册换取奖励", SpecialEvent.SpringFrestival.GetAward, SpringFrestival })
    end

    if Esport:CheckState(3) == 1 then
      table.insert(tbOpt, 1, { "新年活动", Esport.GetItemJinZhouBaoZu, Esport })
    end
  end

  local task_value = me.GetTask(1022, 115)
  if task_value == 1 then
    table.insert(tbOpt, 1, { "现在要去藏剑山庄吗？", self.Send2NewWorld, self })
    szMsg = string.format("%s：你来得正好，" .. me.szName, him.szName)
  end

  if me.nLevel >= nLookLevel then
    if Partner.bOpenPartner == 1 then
      local nPartnerDelState = Partner:GetDelState(me)
      if nPartnerDelState == 1 then
        table.insert(tbOpt, 4, { "申请删除同伴", self.OnSelectPartnerDel, self, 1 })
      else
        table.insert(tbOpt, 4, { "撤销删除同伴申请", self.OnSelectPartnerDel, self, 0 })
      end

      local nPartnerPeelState = Partner:GetPeelState(me)
      if nPartnerPeelState == 1 then
        table.insert(tbOpt, 5, { "申请同伴重生", self.OnSelectPartnerPeel, self, 1 })
      else
        table.insert(tbOpt, 5, { "撤销同伴重生申请", self.OnSelectPartnerPeel, self, 0 })
      end

      local nPartnerEquipState = Partner:GetPartnerEquipState(me)
      if nPartnerEquipState == 1 then
        table.insert(tbOpt, 6, { "申请同伴装备解锁", self.ApplyUnBindPartEq, self, 1 })
      else
        table.insert(tbOpt, 6, { "取消同伴装备解锁", self.ApplyUnBindPartEq, self, 0 })
      end
    end
  end

  -- 我绝对不写注释，你永远都不可能知道1025,75是龙影珠任务完成状态的任务变量ID
  task_value = me.GetTask(1025, 75)
  if task_value == 1 then
    table.insert(tbOpt, { "补领龙影珠", self.ApplyReGetDragonBall, self })
  end

  table.insert(tbOpt, { "结束对话" })

  Dialog:Say(szMsg, tbOpt)
end

function tbJie:Send2NewWorld()
  me.NewWorld(477, 1631, 3099)
  me.SetFightState(0)
end

tbJie.tbReputeShop = {
  [1] = { "OpenYoulongAllSell", 299, 3 },
  [2] = { "OpenLevel150", 298, 3 },
  [3] = { "OpenLevel99", 297, 3 },
  [4] = { "OpenLevel79", 296, 3 },
}

function tbJie:OpenYouLongReputeShop()
  for i = 1, #self.tbReputeShop do
    local tbRepute = self.tbReputeShop[i]
    if TimeFrame:GetState(tbRepute[1]) == 1 then
      me.OpenShop(tbRepute[2], tbRepute[3])
      return
    end
  end
  Dialog:Say("游龙商店还未开张，正在装修中。<enter><enter>货品上架时间：<enter>开服16天（开79级）：腰带、护身符声望令<enter>开服53天（开99级）：帽子、项链声望令<enter>开服89天（开100级）：护腕、鞋子声望令<enter>开服149天（开100级后2个月）：衣服")
  return
end

function tbJie:OpenYouLongZahuoShop()
  me.OpenShop(167, 3)
end

function tbJie:Challenge()
  me.OpenShop(166, 3)
  do
    return
  end

  Dialog:OpenGift("这里可以利用“月影之石”换取“战书：游龙密室”，可以一次换取多个。", nil, { Youlongmibao.OnChallenge, Youlongmibao })
end

function tbJie:OnSelectPartnerDesc()
  Dialog:Say("    想让剑侠世界里的各路江湖人士与你结伴同行吗？当你陷入苦战时，同伴能够助你一臂之力。<enter>    详细请看<color=yellow>F12<color>中<color=yellow>详细帮助的同伴系统<color>进行了解。")
end

function tbJie:OnSelectPartnerDel(nState)
  local szMsg = ""
  local tbOpt = {}

  if nState == 1 then
    if me.nPartnerCount == 0 then
      szMsg = "你没有同伴"
      Dialog:Say(szMsg)
      return
    end

    szMsg = string.format("提交申请后%d小时后才能删除%0.1f星级以上或%d技能以上的同伴，确定提交删除申请吗？", Partner.DEL_USABLE_MINTIME / 3600, Partner.DELLIMITSTARLEVEL, Partner.DELLIMITSKILLCOUNT)
    tbOpt = {
      { "确定", Partner.ApplyDelPartner, Partner, me.nId },
      { "我再看看" },
    }
  else
    local nPeelTime = me.GetTask(Partner.TASK_DEL_PARTNER_GROUPID, Partner.TASK_DEL_PARTNER_SUBID)
    local nDiff = GetTime() - nPeelTime

    if nDiff <= Partner.DEL_USABLE_MINTIME then
      szMsg = string.format("您已经提交了删除申请，还有%0.1f小时申请生效。是否要撤销申请？", (Partner.DEL_USABLE_MINTIME - nDiff) / 3600)
    elseif nDiff >= Partner.DEL_USABLE_MAXTIME then
      me.Msg("您提交的删除申请已经过期，请重新申请！")
      return
    else
      szMsg = string.format("您提交的申请已经开始生效，可以删除%0.1f星级以上或%d技能以上的同伴了！是否要现在撤销？", Partner.DELLIMITSTARLEVEL, Partner.DELLIMITSKILLCOUNT)
    end

    tbOpt = {
      { "确定", Partner.CancelDelPartner, Partner, me.nId },
      { "我再看看" },
    }
  end

  Dialog:Say(szMsg, tbOpt)
end

function tbJie:OnSelectPartnerPeel(nState)
  local szMsg = ""
  local tbOpt = {}

  if nState == 1 then
    if me.nPartnerCount == 0 then
      szMsg = "你没有同伴"
      Dialog:Say(szMsg)
      return
    end

    szMsg = string.format("提交申请后%d小时后才能服用菩提果重生%0.1f星级以上的同伴，确定提交重生申请吗？", (Partner.PEEL_USABLE_MINTIME / 3600), Partner.PEELLIMITSTARLEVEL)
    tbOpt = {
      { "确定", Partner.ApplyPeelPartner, Partner, me.nId },
      { "我再想想" },
    }
  else
    local nPeelTime = me.GetTask(Partner.TASK_PEEL_PARTNER_GROUPID, Partner.TASK_PEEL_PARTNER_SUBID)
    local nDiff = GetTime() - nPeelTime

    if nDiff <= Partner.PEEL_USABLE_MINTIME then
      szMsg = string.format("您已经提交了重生申请，还有%0.1f小时申请生效。是否要撤销申请？", (Partner.PEEL_USABLE_MINTIME - nDiff) / 3600)
    elseif nDiff >= Partner.PEEL_USABLE_MAXTIME then
      me.Msg("您提交的申请已经过期，请重新申请！")
      return
    else
      szMsg = string.format("您提交的申请已经开始生效，可以使用菩提果重生%0.1f星级以上的同伴！是否要现在撤销？", Partner.PEELLIMITSTARLEVEL)
    end

    tbOpt = {
      { "确定", Partner.CancelPeelPartner, Partner, me.nId },
      { "我再想想" },
    }
  end

  Dialog:Say(szMsg, tbOpt)
end

--同伴特殊材料兑换同伴秘籍
function tbJie:ChangePartnerMiJi()
  local szMsg = "我这里可以用同伴特殊材料兑换同伴秘籍(绑定)：\n一个初级秘籍(绑定)（<color=yellow>6星及以下的同伴可使用<color>）需要<color=yellow>一个<color>同伴特殊材料\n一个中级秘籍(绑定)（<color=yellow>6星半到8星的同伴可使用<color>）需要<color=yellow>五个<color>同伴特殊材料\n一个高级秘籍(绑定)（<color=yellow>8星以上的同伴可使用<color>）需要<color=yellow>三十<color>个同伴特殊材料，看看你要兑换那种呢？"
  local tbOpt = {
    { "兑换初级同伴秘籍", self.ChangePartnerMiJExi, self, 1 },
    { "兑换中级同伴秘籍", self.ChangePartnerMiJExi, self, 2 },
    { "兑换高级同伴秘籍", self.ChangePartnerMiJExi, self, 3 },
    { "我再想想" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbJie:ChangePartnerMiJExi(nLevel)
  local tbType = { 1, 5, 30 } --三个级别兑换的个数
  local szContent = string.format("请放入<color=yellow>%s个<color>同伴特殊材料", tbType[nLevel])
  Dialog:OpenGift(szContent, nil, { tbJie.OnOpenGiftOk, tbJie, nLevel })
end

function tbJie:OnOpenGiftOk(nLevel, tbItemObj)
  local tbType = { 1, 5, 30 } --三个级别兑换的个数
  local szPartnerCaiLiao = "18,1,556,1" --同伴特殊材料的gdpl
  --数量判断
  local nCount = 0
  for i = 1, #tbItemObj do
    nCount = nCount + tbItemObj[i][1].nCount
  end
  if nCount ~= tbType[nLevel] then
    Dialog:Say("放入的物品数量不对！", { "知道了" })
    return 0
  end
  --物品判定
  for i = 1, #tbItemObj do
    local pItem = tbItemObj[i][1]
    local szKey = string.format("%s,%s,%s,%s", pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel)
    if szKey ~= szPartnerCaiLiao then
      Dialog:Say("放入的物品不对！", { "知道了" })
      return 0
    end
  end
  --背包判定
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("需要1格背包空间，去整理下再来吧！", { "知道了" })
    return 0
  end
  --删除交的东西
  for i = 1, #tbItemObj do
    local pItem = tbItemObj[i][1]
    pItem.Delete(me)
  end
  local pItemEx = me.AddItem(18, 1, 554, nLevel)
  if pItemEx then
    pItemEx.Bind(1)
    me.SetItemTimeout(pItemEx, 60 * 24 * 30, 0)
    EventManager:WriteLog(string.format("[兑换同伴秘籍]获得物品:%s", pItemEx.szName), me)
    me.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, string.format("[兑换同伴秘籍]获得物品:%s", pItemEx.szName))
  else
    EventManager:WriteLog(string.format("[兑换同伴秘籍]获得失败，扣除材料%s个", nCount), me)
    me.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, string.format("[兑换同伴秘籍]获得失败，扣除材料%s个", nCount))
  end
end

-- by zhangjinpin@kingsoft
function tbJie:SplitPartnerJinghua()
  local szMsg = "这里可以将<color=yellow>无上智慧精华（4级）<color>拆解成等价值的<color=yellow>白金智慧精华（3级）<color>"
  szMsg = szMsg .. "<color=green>（1个无上智慧精华，可拆解为10个白金智慧精华）<color>"
  Dialog:OpenGift(szMsg, nil, { tbJie.OnSplitPartnerJinghua, tbJie })
end

function tbJie:OnSplitPartnerJinghua(tbItem)
  local tbItemIdIn = { 18, 1, 565, 4 }
  local tbItemIdOut = { 18, 1, 565, 3 }

  local nExCount = 0
  for _, tbItem in pairs(tbItem) do
    local pItem = tbItem[1]
    local szKey = string.format("%s,%s,%s,%s", pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel)
    if szKey == string.format("%s,%s,%s,%s", unpack(tbItemIdIn)) then
      nExCount = nExCount + pItem.nCount
    end
  end

  if nExCount <= 0 then
    Dialog:Say("请放入正确的物品。")
    return 0
  end

  local nNeed = KItem.GetNeedFreeBag(tbItemIdOut[1], tbItemIdOut[2], tbItemIdOut[3], tbItemIdOut[4], nil, nExCount * 10)
  if me.CountFreeBagCell() < nNeed then
    Dialog:Say(string.format("请留出%s格背包空间。", nNeed))
    return 0
  end

  local nExTempCount = 0
  for _, tbItem in pairs(tbItem) do
    local pItem = tbItem[1]
    local szKey = string.format("%s,%s,%s,%s", pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel)
    if szKey == string.format("%s,%s,%s,%s", unpack(tbItemIdIn)) then
      me.DelItem(pItem)
      nExTempCount = nExTempCount + pItem.nCount
    end
    if nExTempCount >= nExCount then
      break
    end
  end

  me.AddStackItem(tbItemIdOut[1], tbItemIdOut[2], tbItemIdOut[3], tbItemIdOut[4], nil, nExCount * 10)
end

function tbJie:ApplyUnBindPartEq(nState)
  local szMsg = ""
  local tbOpt = {}

  if nState == 1 then
    -- 下面除以2是把小时转成时辰
    szMsg = string.format("老朽自幼给人修锁，从未见过如此难解的好锁，我需要准备%d个时辰(%d小时)， 之后的%0.1f个时辰内我可以给你剥离，过时不候。", Partner.BIND_PARTNERQUIP_MINTIME / 3600 / 2, Partner.BIND_PARTNERQUIP_MINTIME / 3600, (Partner.BIND_PARTNERQUIP_MAXTIME - Partner.BIND_PARTNERQUIP_MINTIME) / 2 / 3600)
    tbOpt = {
      { "申请同伴装备解锁", Partner.ApplyUnBindPartEq, Partner, me.nId },
      { "取消" },
    }
  else
    local nBindTime = me.GetTask(Partner.TASK_BIND_PARTNEREQ_GROUPID, Partner.TASK_BIND_PARTNEREQ_SUBID)
    local nDiff = GetTime() - nBindTime

    if nDiff <= Partner.BIND_PARTNERQUIP_MINTIME then
      szMsg = string.format("您已经提交了解绑申请，还有%0.1f小时申请生效。是否要撤销申请？", (Partner.BIND_PARTNERQUIP_MINTIME - nDiff) / 3600)
    elseif nDiff >= Partner.BIND_PARTNERQUIP_MAXTIME then
      me.Msg("您提交的申请已经过期，请重新申请！")
      return
    else
      szMsg = string.format("您提交的申请已经开始生效，可以解绑一件同伴装备！是否要现在撤销？", Partner.PEELLIMITSTARLEVEL)
    end

    tbOpt = {
      { "确定", Partner.CancelUnBindPartEq, Partner, me.nId },
      { "我再想想" },
    }
  end

  Dialog:Say(szMsg, tbOpt)
end

function tbJie:ChangeZhenYuan()
  local szMsg = "    这里可以免费将护体真元转化为非护体真元（仅限价值量超过1000的真元），转化后真元的<color=red>所有属性会降低半个星级<color>。"
  local nTime = me.GetTask(2085, 8)
  local nDetra = GetTime() - nTime
  if nTime <= 0 or nDetra <= 0 or nDetra > Item.MAX_PEEL_TIME then
    szMsg = szMsg .. "你要申请转化么，请给我一段准备时间，3小时后便可以开始了。"
    local tbOpt = {
      { "<color=yellow>确定<color>", self.OnApplyChangeZhenYuan, self },
      { "我再想想" },
    }
    Dialog:Say(szMsg, tbOpt)
    return 0
  elseif nDetra <= Item.VALID_PEEL_TIME then
    szMsg = szMsg .. "你已经申请转化了，再等一会儿就可以开始了。"
    local tbOpt = {
      { "<color=yellow>取消申请<color>", self.ChancelChangeZhenYuan, self },
      { "我再想想" },
    }
    Dialog:Say(szMsg, tbOpt)
    return 0
  else
    szMsg = szMsg .. "你确定要转化么？"
    local tbOpt = {
      { "<color=yellow>确定<color>", jbreturn.ChangeFree, jbreturn },
      { "我再想想" },
    }
    Dialog:Say(szMsg, tbOpt)
    return 0
  end
end

function tbJie:ChancelChangeZhenYuan()
  local szMsg = "你确定要取消护体真元转化申请么？"
  local tbOpt = {
    { "<color=yellow>确定<color>", self.OnChancelChangeZhenYuan, self },
    { "我再想想" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbJie:OnApplyChangeZhenYuan()
  me.SetTask(2085, 8, GetTime())
  me.AddSkillState(2476, 1, 2, Item.MAX_PEEL_TIME * Env.GAME_FPS, 1, 0, 1)
  me.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, "申请护体真元转化")
  me.Msg("你提交了护体真元转化申请。")
end

function tbJie:OnChancelChangeZhenYuan()
  me.SetTask(2085, 8, 0)
  me.RemoveSkillState(2476)
  me.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, "撤销护体真元转化申请")
  me.Msg("你取消了护体真元转化申请。")
end

function tbJie:ApplyReGetDragonBall()
  local tbRes = me.FindItemInAllPosition(unpack(Item.DRAGONBALL_GDPL))
  if tbRes and Lib:CountTB(tbRes) ~= 0 then
    Dialog:Say("孩子，龙影珠海纳天地元素，持一颗可萃取其中精华，而再多变会因元气过盛而爆裂。<enter>所以千万不可以贪恋多得，以免惹来杀生之祸！")
    return
  end

  if me.CountFreeBagCell() < 1 then
    Dialog:Say("请至少空出一个背包格子再来！")
    return
  end

  local pItem = me.AddItem(unpack(Item.DRAGONBALL_GDPL))
  if not pItem then
    Dialog:Say("领取失败，请重新领！")
    return
  end

  Item:SyncPlayerDataToBall(me, pItem)
end
