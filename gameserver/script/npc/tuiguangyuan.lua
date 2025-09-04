-------------------------------------------------------------------
--File: tuiguangyuan.lua
--Author: kenmaster
--Date: 2008-06-04 03:00
--Describe: 活动推广员npc脚本
-------------------------------------------------------------------
local tbTuiGuangYuan = Npc:GetClass("tuiguangyuan")

--初始对话（对话1）
-- Npc.IVER_nTuiGuanYuan 数值为1，表示只有大陆版才开启这个功能
function tbTuiGuangYuan:OnDialog()
  local tbOpt = {
    { "姑娘您可能认错人了" },
  }

  if KGblTask.SCGetDbTaskInt(DBTASK_LAXIN2010_OPEN) == 1 then
    table.insert(tbOpt, 1, { "<color=yellow>10月新手体验抽奖激活<color>", SpecialEvent.tbLaXin2010.OnActive, SpecialEvent.tbLaXin2010 })
  end
  if Npc.IVER_nTuiGuanYuan == 1 then
    if SpecialEvent.ChangeServer:CheckState() == 1 then
      table.insert(tbOpt, 1, { "我要移民", SpecialEvent.ChangeServer.ApplyChangeServer, SpecialEvent.ChangeServer })
    end

    --		if SpecialEvent.Compensate:CheckState() == 1 then
    --			table.insert(tbOpt, 1, {"领取丢失的在金币区购买的物品", SpecialEvent.Compensate.OnDialog, SpecialEvent.Compensate});
    --		end

    if SpecialEvent.ChangeServer:CheckAward() == 1 then
      table.insert(tbOpt, 1, { "我要领取移民奖励", SpecialEvent.ChangeServer.GetServerAward, SpecialEvent.ChangeServer })
    end
  end

  --	if SpecialEvent.RecommendServer:CheckRecommend() == 1 then
  --		table.insert(tbOpt, 1, {"入驻奖励领取", SpecialEvent.RecommendServer.OnDialog, SpecialEvent.RecommendServer});
  --	end

  if Npc.IVER_nTuiGuanYuan == 1 then
    if SpecialEvent.CompensateCommon:CheckState() == 1 then
      table.insert(tbOpt, 1, { "领取丢失补偿", SpecialEvent.CompensateCommon.OnDialog, SpecialEvent.CompensateCommon })
    end

    if SpecialEvent.NewPlayerCard:CheckTime(1) == 1 then
      table.insert(tbOpt, 1, { "领取新手卡奖励", SpecialEvent.NewPlayerCard.OnDialogNewCard, SpecialEvent.NewPlayerCard })
    end

    if SpecialEvent.NewPlayerCard:CheckTime(2) == 1 then
      table.insert(tbOpt, 1, { "领取真情回馈礼包", SpecialEvent.NewPlayerCard.OnDialogFeedBack, SpecialEvent.NewPlayerCard })
    end

    if SpecialEvent.TuiGuangYuan:Check() == 1 then
      table.insert(tbOpt, 1, { "领取推广员活动奖励", SpecialEvent.TuiGuangYuan.OnDialog, SpecialEvent.TuiGuangYuan })
    end
    if SpecialEvent.GameOpenTest:GetState(3) == 1 then
      table.insert(tbOpt, 1, { "充值送礼活动", SpecialEvent.ChongZhi.OnDialog, SpecialEvent.ChongZhi })
    end

    if SpecialEvent.tbQQShow:CheckOpen() == 1 then
      table.insert(tbOpt, 1, { "领取QQ秀激活码", SpecialEvent.tbQQShow.QQShowApplySN, SpecialEvent.tbQQShow, me.nId })
    end

    if SpecialEvent.tbTwentyAnniversary:CheckTime() == 1 then
      table.insert(tbOpt, 1, { "领取金山20周年活动奖励", SpecialEvent.tbTwentyAnniversary.TwentyYearsOnDialog, SpecialEvent.tbTwentyAnniversary })
    end

    if SpecialEvent.VipReturn_6M:Check() == 1 then
      table.insert(tbOpt, 1, { "<color=yellow>年度充值回馈活动<color>", SpecialEvent.VipReturn_6M.OnDialog, SpecialEvent.VipReturn_6M })
    end
  end

  if IVER_g_nSdoVersion == 0 then
    table.insert(tbOpt, 1, { "激活码资格验证", PresendCard.OnDialogCard, PresendCard })
  end

  if SpecialEvent.Xmas2008:CheckReback() == 1 then
    table.insert(tbOpt, 1, { "圣诞充值有礼活动", SpecialEvent.Xmas2008.GetReback, SpecialEvent.Xmas2008 })
  end

  if SpecialEvent.ValentineTitle2009:CanGetTitle(me) == 1 then
    table.insert(tbOpt, 1, { "领取情人节称号", SpecialEvent.ValentineTitle2009.GetTitle, SpecialEvent.ValentineTitle2009, me })
  end

  if EventManager.IVER_bOpenChongZhiHuoDong == 1 then
    table.insert(tbOpt, 1, { string.format("领取%s优惠奖励", IVER_g_szPayName), SpecialEvent.ChongZhiYouHui48.Dialog, SpecialEvent.ChongZhiYouHui48 })
  end

  if SpecialEvent.tbGoldBar:CheckPlayer(me) == 1 then
    table.insert(tbOpt, 1, { "<color=yellow>金牌网吧<color>", SpecialEvent.tbGoldBar.OnDialog, SpecialEvent.tbGoldBar })
  end
  if SpecialEvent.DuBaVip:CheckState() == 1 then
    if SpecialEvent.DuBaVip:CheckTakeAuthority() == 1 then
      table.insert(tbOpt, 1, { "金山毒霸特权月度礼包", SpecialEvent.DuBaVip.OnDialog, SpecialEvent.DuBaVip })
    else
      table.insert(tbOpt, 1, { "<color=gray>金山毒霸特权月度礼包<color>", SpecialEvent.DuBaVip.OnDialog, SpecialEvent.DuBaVip })
    end
  end

  local tbItem = SpecialEvent.tbVipInvite:TryGetDialogItem()
  if tbItem then
    table.insert(tbOpt, 1, tbItem)
  end

  if SpecialEvent.tbRoleTransfer.bOpen == 1 then
    table.insert(tbOpt, 1, { "<color=yellow>角色转移<color>", SpecialEvent.tbRoleTransfer.OnDialog, SpecialEvent.tbRoleTransfer })
  end
  Dialog:Say("古枫霞：这位大侠，在哪里...在哪里见过您？您的笑容是如此的熟悉，我...我却一时想不起...", tbOpt)
end

function tbTuiGuangYuan:AboutConsume(nRemote)
  if me.IsAccountLock() ~= 0 then
    Dialog:Say("账号未解锁，无法进行该操作。")
    Account:OpenLockWindow(me)
    return 0
  end
  if Account:Account2CheckIsUse(me, 4) == 0 then
    Dialog:Say("你正在使用副密码登陆游戏，设置了权限控制，无法进行该操作！")
    return 0
  end
  local nCounsumeMonth = Spreader:IbShopGetConsume()
  local nCounsumeLastM = me.GetTask(2070, 4)
  local szMsg = string.format(
    [[	
		奇珍阁消耗情况如下：
		
	<color=yellow>上月消耗：%s<color>
	<color=yellow>本月消耗：%s<color>
	]],
    nCounsumeLastM,
    nCounsumeMonth
  )
  local tbOpt = {}
  if nRemote == 1 then
    table.insert(tbOpt, { "打开抽奖网页", self.OpenConsumeLottery, self })
    --table.insert(tbOpt, {"打开积分商城官方网页", self.OpenConsumeUrl, self});
    if nCounsumeLastM < 10000 then
      szMsg = szMsg .. string.format("上个月的消耗没有达到<color=gold>10000金币<color>, 不能参加实物抽奖活动。（当本月消耗达到10000金币时可参与下月实物抽奖活动）")
    else
      szMsg = szMsg .. string.format("上个月的消耗已经达到了<color=gold>10000金币<color>, 可以参加实物抽奖活动。（当本月消耗达到10000金币时可参与下月实物抽奖活动）")
    end
  end
  table.insert(tbOpt, { "消耗介绍", self.ConsumeInfo, self, nRemote })
  table.insert(tbOpt, { "结束对话" })
  Dialog:Say(szMsg, tbOpt)
end

function tbTuiGuangYuan:ConsumeShop()
  if me.IsAccountLock() ~= 0 then
    Dialog:Say("你的账号处于锁定状态，无法进行该操作！")
    return
  end
  local nNowYear = tonumber(GetLocalDate("%Y")) - 2011
  local nYear = me.GetTask(2070, 8)
  if nNowYear >= 0 and nYear ~= nNowYear then
    me.SetTask(2070, 6, 0)
    me.SetTask(2070, 8, nNowYear)
  end
  local nCounsumeMoney = me.GetTask(2070, 6)
  local szMsg = string.format("您好！欢迎您来到积分商城，在这里您可以用您在奇珍阁累积的消费积分换取您想要的各种商品。\n<color=red>注：每年1月1日消耗积分清空<color>\n\n您当前的消费积分为：<color=yellow>%s<color>", nCounsumeMoney)
  local tbOpt = {
    { "称号光环类", self.OpenConsumeShop, self, 1 },
    { "面具外装类", self.OpenConsumeShop, self, 2 },
    { "坐骑装备类", self.OpenConsumeShop, self, 3 },
    { "限量版剑世周边", self.OpenConsumeShop, self, 5 },
    { "其他道具", self.OpenConsumeShop, self, 4 },
    { "打开商城官方网页", self.OpenConsumeUrl, self },
    { "我再想想" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbTuiGuangYuan:OpenConsumeShop(nType)
  local szMapClass = GetMapType(me.nMapId) or ""
  if szMapClass ~= "village" and szMapClass ~= "city" then
    Dialog:Say("只有新手村或者城市才能打开。")
    return 0
  end
  local tbShop = { 192, 193, 194, 195, 196 }
  me.OpenShop(tbShop[nType], 10)
end

function tbTuiGuangYuan:OpenConsumeLottery()
  me.CallClientScript({ "OpenWebSite", "http://jxsj.xoyo.com/zt/2011/05/04/index.shtml" })
end

function tbTuiGuangYuan:OpenConsumeUrl()
  me.CallClientScript({ "OpenWebSite", "http://zt.xoyo.com/jxsj/mall/" })
end

function tbTuiGuangYuan:ConsumeInfo(nRemote)
  local szMsg = [[
	<color=green>奇珍阁消耗类型：<color>例如下:
	
		1、金币区购买玄晶，玄晶强化或合成被消耗掉即可算入消耗。
		2、金币区购买精气散，直接使用精气散后即可算入消耗。
		3、金币区购买魂石箱，取出所有魂石，箱子消失后即可算入消耗。
		4、金币区购买乾坤符，乾坤符10次使用完消失后，即可算入消耗。
	<color=red>注：必须从奇珍阁金币区购买的商品，并且该商品被消耗掉，即算入消耗额<color>]]
  Dialog:Say(szMsg, { "返回上层", self.AboutConsume, self, nRemote })
  return 0
end

-- ?pl DoScript("\\script\\npc\\tuiguangyuan.lua")
