-- 白虎堂传送NPC

local tbNpc = Npc:GetClass("baihutangchuansong")

local tbKuaFuPrizeGDPL = { 18, 1, 1120, 1 } --跨服白虎奖励宝箱gdpl
local nPrizeValue = 500 --一个宝箱为500积分

tbNpc.nTopLevel = 90
tbNpc.nBottomLevel = 50

function tbNpc:Init()
  self.tbShopID = {
    [Env.FACTION_ID_SHAOLIN] = 89, -- 少林
    [Env.FACTION_ID_TIANWANG] = 90, --天王掌门
    [Env.FACTION_ID_TANGMEN] = 91, --唐门掌门
    [Env.FACTION_ID_WUDU] = 93, --五毒掌门
    [Env.FACTION_ID_EMEI] = 95, --峨嵋掌门
    [Env.FACTION_ID_CUIYAN] = 96, --翠烟掌门
    [Env.FACTION_ID_GAIBANG] = 98, --丐帮掌门
    [Env.FACTION_ID_TIANREN] = 97, --天忍掌门
    [Env.FACTION_ID_WUDANG] = 99, --武当掌门
    [Env.FACTION_ID_KUNLUN] = 100, --昆仑掌门
    [Env.FACTION_ID_MINGJIAO] = 92, --明教掌门
    [Env.FACTION_ID_DALIDUANSHI] = 94, --大理段氏掌门
    [Env.FACTION_ID_GUMU] = 295, -- 古墓
  }
end

tbNpc:Init()

function tbNpc:OnDialog()
  local nMapId = me.nMapId
  local tbOpt = {}

  if me.nLevel < tbNpc.nBottomLevel then
    tbOpt[1] = { "白虎堂对你来说太危险了，请把等级提升至50级再来吧！" }
  elseif me.nFaction == 0 then
    tbOpt[1] = { "您还是白名，请加入门派后再参加白虎堂。" }
  else
    if me.nLevel >= tbNpc.nBottomLevel and me.nLevel < tbNpc.nTopLevel then
      table.insert(tbOpt, { "我想进入白虎堂（初级一）", self.OnTrans, self, BaiHuTang.ChuJi })
      -- 开放99级后后一周 75 + 7 后关闭 初级二
      if TimeFrame:GetStateGS("CloseBaiHuTangChu2") == 0 then
        table.insert(tbOpt, { "我想进入白虎堂（初级二）", self.OnTrans, self, BaiHuTang.ChuJi2 })
      end
      --table.insert(tbOpt, {"我想进入白虎堂（初级三）", self.OnTrans, self, BaiHuTang.ChuJi3});
    else
      table.insert(tbOpt, { "我想进入白虎堂（高级）", self.OnTrans, self, BaiHuTang.GaoJi })
      if BaiHuTang:IsOpenGolden() == 1 and me.nLevel >= 120 then
        table.insert(tbOpt, { "我想进入白虎堂（黄金）", self.OnTrans, self, BaiHuTang.Goldlen })
      end
    end

    table.insert(tbOpt, { "[活动规则]", self.Rule, self })
    table.insert(tbOpt, { "购买白虎堂声望装备", self.BuyReputeItem, self })
    table.insert(tbOpt, { "跨服白虎奖励", self.ChangeKuaFuPrize, self })
    table.insert(tbOpt, { "结束对话" })
  end
  Dialog:Say("最近白虎堂里出现了一批盗贼，以我们的力量是无法应付的，你能帮我们一个忙吗？我可以送你到“白虎堂大殿”，具体的事情请找里面的“白虎堂门人”询问。你要去吗？", tbOpt)
end

--规则显示
function tbNpc:Rule()
  local tbOpt = {}
  tbOpt[1] = { "返回上一层对话", self.OnDialog, self }
  tbOpt[2] = { "结束对话" }
  local szMsg = string.format("本活动报名时间<color=green>30<color>分钟，活动时间<color=green>30<color>分钟。活动开始后白虎堂内会出现许多<color=red>闯堂贼<color>，打败他们可以获得道具与经验，在经过一定时间之后会出现<color=red>闯堂贼头领<color>，" .. "打败<color=red>闯堂贼头领<color>后会出现通向二层的出口，白虎堂共3层，如果你把3层的头领都打败的话出来的出口便会打开。要注意的是来闯白虎堂的人都不是什么等闲之辈，进去就会强制开启战斗状态，所以最好组队或者跟家族或者帮会的人一起参加的比较好。（本活动每天最多参加<color=red>%s次<color>）\n<color=red>注：进入初级白虎堂必须加入家族<color>", BaiHuTang.MAX_ONDDAY_PKTIMES)
  Dialog:Say(szMsg, tbOpt)
end
function tbNpc:OnTrans(nMapId)
  if EventManager.IVER_bOpenBaiLimit == 1 then
    if nMapId == BaiHuTang.ChuJi or nMapId == BaiHuTang.ChuJi2 then
      if me.dwKinId == 0 then
        Dialog:Say("您还没有加入家族，请加入家族后再来参加！")
        return
      end
    end
  end
  local nRect = MathRandom(#BaiHuTang.tbPKPos)
  local tbPos = BaiHuTang.tbPKPos[nRect]
  me.NewWorld(nMapId, tbPos.nX / 32, tbPos.nY / 32)
end

-- 购买白虎堂声望装备
function tbNpc:BuyReputeItem()
  local nFaction = me.nFaction
  if nFaction <= 0 then
    Dialog:Say("非白名玩家才能购买义军装备")
    return 0
  end
  me.OpenShop(self.tbShopID[nFaction], 1, 100, me.nSeries) --使用声望购买
end

--兑换跨服白虎奖励
function tbNpc:ChangeKuaFuPrize()
  local szMsg = string.format("你好%s,我可以做点什么?", me.szName)
  local tbOpt = {}
  tbOpt[1] = { "查询积分", self.ViewKuaFuScores, self }
  tbOpt[2] = { "兑换跨服奖励", self.ExchangeBox_Info, self }
  tbOpt[3] = { "返回上一层", self.OnDialog, self }
  tbOpt[4] = { "结束对话" }
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:ViewKuaFuScores()
  local nSportScores = GetPlayerSportTask(me.nId, KuaFuBaiHu.GB_TASK_GID, KuaFuBaiHu.GB_TASK_SCORES) or 0
  local nLocalScores = me.GetTask(KuaFuBaiHu.TASK_GID, KuaFuBaiHu.TASK_MYSERVER_SCORES) or 0
  local nUseScores = nSportScores - nLocalScores
  local szMsg = string.format("您当前的跨服白虎累计积分为:<color=green>%s<color>", tostring(nUseScores))
  local tbOpt = {}
  tbOpt[1] = { "返回上一层", self.ChangeKuaFuPrize, self }
  tbOpt[2] = { "结束对话" }
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:ExchangeBox_Info()
  local nSportScores = GetPlayerSportTask(me.nId, KuaFuBaiHu.GB_TASK_GID, KuaFuBaiHu.GB_TASK_SCORES) or 0
  local nLocalScores = me.GetTask(KuaFuBaiHu.TASK_GID, KuaFuBaiHu.TASK_MYSERVER_SCORES) or 0
  local nUseScores = nSportScores - nLocalScores
  local nCount = math.floor(nUseScores / nPrizeValue)
  if nCount < 1 then
    local szMsg = string.format("您当前的跨服白虎累计积分为<color=red>%s<color>,不足以兑换宝箱！", tostring(nUseScores))
    local tbOpt = {}
    tbOpt[1] = { "返回上一层", self.ChangeKuaFuPrize, self }
    tbOpt[2] = { "结束对话" }
    Dialog:Say(szMsg, tbOpt)
  elseif nCount >= 1 then
    local szMsg = string.format("您当前的跨服白虎累计积分为:<color=yellow>%s<color>,可以兑换<color=yellow>%s<color>宝箱，确定现在兑换么?", tostring(nUseScores), tostring(nCount))
    local tbOpt = {}
    tbOpt[1] = { "是的", self.ExchangeBox, self }
    tbOpt[2] = { "以后再换" }
    Dialog:Say(szMsg, tbOpt)
  end
end

function tbNpc:ExchangeBox()
  local nSportScores = GetPlayerSportTask(me.nId, KuaFuBaiHu.GB_TASK_GID, KuaFuBaiHu.GB_TASK_SCORES) or 0
  local nLocalScores = me.GetTask(KuaFuBaiHu.TASK_GID, KuaFuBaiHu.TASK_MYSERVER_SCORES) or 0
  local nUseScores = nSportScores - nLocalScores
  local nCount = math.floor(nUseScores / nPrizeValue)
  local nFreeBagCell = me.CountFreeBagCell() --背包空间
  local tbPrizeProp = KItem.GetOtherBaseProp(tbKuaFuPrizeGDPL[1], tbKuaFuPrizeGDPL[2], tbKuaFuPrizeGDPL[3], tbKuaFuPrizeGDPL[4])
  local nMaxPrizeCount = tbPrizeProp["nStackMax"] or 5000
  local nPrizeCount = math.ceil(nCount / nMaxPrizeCount) --宝箱叠加100个，计算需要几个背包空间
  if nFreeBagCell < nPrizeCount then
    local szMsg = string.format("请至少留出%s个背包空间!", tostring(nPrizeCount))
    me.Msg(szMsg, "系统提示")
    return 0
  end
  me.AddStackItem(tbKuaFuPrizeGDPL[1], tbKuaFuPrizeGDPL[2], tbKuaFuPrizeGDPL[3], tbKuaFuPrizeGDPL[4], nil, nCount)
  local nNewScores = nLocalScores + nPrizeValue * nCount
  me.SetTask(KuaFuBaiHu.TASK_GID, KuaFuBaiHu.TASK_MYSERVER_SCORES, nNewScores) --将使用过的积分存储

  SpecialEvent.ActiveGift:AddCounts(pPlayer, 35) --领取跨服白虎堂奖励活跃度
end
