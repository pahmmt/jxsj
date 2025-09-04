-------------------------------------------------------
-- 文件名　：keyimen_npc.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2012-02-22 11:31:58
-- 文件描述：
-------------------------------------------------------

if not MODULE_GAMESERVER then
  return
end

Require("\\script\\boss\\keyimen\\keyimen_def.lua")

-- 战场报名官
local tbSignup = Npc:GetClass("keyimen_npc_signup")

function tbSignup:OnDialog()
  local nCamp = Keyimen.MAP_LIST[him.nMapId]
  if not nCamp or nCamp <= 0 then
    Dialog:Say("你好像来错地方了。")
    return 0
  end

  local tbTxt = {
    [1] = "如今鞑虏侵我河山，杀我同胞。你若能助我驱除鞑虏，救西夏百姓于危难，解苍生于倒悬，我西夏必铭记于心，而各位也必定彪榜青史！",
    [2] = "各位大侠，是否愿意去消灭顽抗的西夏人，帮助我们完成统一大业？我们要让青草覆盖的地方都成为族人牧马之地，长生天一定会保佑诸位勇士旗开得胜！",
  }

  local szMsg = string.format(
    [[
	    %s
		    
	☆ 帮主首领在报名官处<color=yellow>选择阵营<color>
	☆ 帮会成员接取当日的<color=yellow>阵营军令<color>
	☆ 持有<color=yellow>军令<color>才能接取任务和快速传送
	
	<color=green>你们帮会今天的阵营为：<color>]],
    tbTxt[nCamp]
  )

  local tbOpt = {
    { "<color=yellow>领取今日军令<color>", self.GetCampPad, self },
    { "我知道了" },
  }

  if me.GetTask(Keyimen.TASK_GID, Keyimen.TASK_STATE) == 0 then
    if Keyimen:CheckPeriod() == 1 then
      table.insert(tbOpt, 2, { "<color=green>接取龙魂任务<color>", self.GetTongTask, self })
    else
      table.insert(tbOpt, 2, { "<color=gray>接取龙魂任务<color>", self.GetTongTask, self })
    end
  elseif me.GetTask(Keyimen.TASK_GID, Keyimen.TASK_STATE) == 1 and Keyimen:CheckPlayerTaskFinish(me) == 1 then
    table.insert(tbOpt, 2, { "<color=green>完成龙魂任务<color>", self.FinishTongTask, self })
  end

  local nTongId = me.dwTongId
  local nKinId, nMemberId = me.GetKinMember()
  if Tong:CheckSelfRight(nTongId, nKinId, nMemberId, Tong.POW_MASTER) == 1 or Tong:CheckPresidentRight(nTongId, nKinId, nMemberId) == 1 then
    table.insert(tbOpt, 1, { "<color=yellow>选择明日阵营<color>", self.SelectCamp, self })
    --		table.insert(tbOpt, 1, {"<color=cyan>开启龙魂任务<color>", self.StartTongTask, self});
  end

  local nCamp = Keyimen:GetTongCamp(nTongId)
  if nCamp <= 0 then
    szMsg = szMsg .. "<color=gray>未选择<color>"
  else
    szMsg = szMsg .. string.format("<color=yellow>%s<color>", Keyimen.CAMP_LIST[nCamp])
  end

  Dialog:Say(szMsg, tbOpt)
end

-- 选择阵营
function tbSignup:SelectCamp()
  local nCamp = Keyimen.MAP_LIST[him.nMapId]
  if not nCamp or nCamp <= 0 then
    Dialog:Say("你好像来错地方了。")
    return 0
  end

  local nTongId = me.dwTongId
  local nKinId, nMemberId = me.GetKinMember()
  if Tong:CheckSelfRight(nTongId, nKinId, nMemberId, Tong.POW_MASTER) ~= 1 and Tong:CheckPresidentRight(nTongId, nKinId, nMemberId) ~= 1 then
    Dialog:Say("对不起，你不是帮主或首领，无法选择阵营。")
    return 0
  end

  local nPreCamp = Keyimen:GetTongPreCamp(nTongId)
  if nPreCamp > 0 then
    Dialog:Say(string.format("    你们帮会已经选择了明日阵营为：<color=yellow>%s<color>，若帮会当日没有选择次日阵营，则默认为昨日的阵营。", Keyimen.CAMP_LIST[nPreCamp]))
    return 0
  end

  local szMsg = string.format("    你们帮会确定要加入我方<color=yellow>%s<color>大军作为明日阵营么？每个帮会每天只有<color=yellow>1次机会<color>选择次日阵营，一旦选择后将无法修改。", Keyimen.CAMP_LIST[nCamp], Keyimen.CAMP_LIST[nCamp])
  local tbOpt = {
    { "<color=yellow>确定<color>", self.DoSelectCamp, self, nCamp },
    { "我知道了" },
  }

  Dialog:Say(szMsg, tbOpt)
end

function tbSignup:DoSelectCamp(nCamp)
  local nTongId = me.dwTongId
  local nKinId, nMemberId = me.GetKinMember()
  if Tong:CheckSelfRight(nTongId, nKinId, nMemberId, Tong.POW_MASTER) ~= 1 and Tong:CheckPresidentRight(nTongId, nKinId, nMemberId) ~= 1 then
    Dialog:Say("对不起，你不是帮主或首领，无法选择阵营。")
    return 0
  end

  local nPreCamp = Keyimen:GetTongPreCamp(nTongId)
  if nPreCamp > 0 then
    Dialog:Say(string.format("你们帮会已经选择<color=yellow>%s<color>作为明日阵营了。", Keyimen.CAMP_LIST[nPreCamp]))
    return 0
  end

  Keyimen:TongSignup_GS(nTongId, nCamp)
  StatLog:WriteStatLog("stat_info", "keyimen_battle", "select_camp", me.nId, nTongId, nCamp)

  local szMsg = string.format("<color=yellow>%s<color>选择了<color=yellow>%s<color>作为帮会明日阵营", me.szName, Keyimen.CAMP_LIST[nCamp])
  KTong.Msg2Tong(nTongId, szMsg, 0)
  Keyimen:SendMessage(me, Keyimen.MSG_CHANNEL, szMsg)
end

-- 领取军令
function tbSignup:GetCampPad()
  if me.GetTask(Keyimen.TASK_GID, Keyimen.TASK_GET_PAD) == 1 then
    Dialog:Say("    你今天已经领取过军令了，每位侠士每天只可在我这里领取<color=yellow>1个<color>军令。")
    return 0
  end

  local nTongId = me.dwTongId
  local nKinId, nMemberId = me.GetKinMember()

  if nTongId <= 0 then
    Dialog:Say("对不起，你还有加入任何帮会。")
    return 0
  end

  if Keyimen:GetTongCamp(nTongId) <= 0 then
    Dialog:Say("对不起，你们帮会没有选择今日阵营。")
    return 0
  end

  local nCamp = Keyimen.MAP_LIST[him.nMapId]
  if Keyimen:GetTongCamp(nTongId) ~= nCamp then
    Dialog:Say(string.format("    对不起，你们帮会没有选择<color=yellow>%s<color>作为今日阵营。", Keyimen.CAMP_LIST[nCamp]))
    return 0
  end

  local nNeed = 1
  if me.CountFreeBagCell() < nNeed then
    Dialog:Say(string.format("请留出至少%s格背包空间！", nNeed))
    return 0
  end

  local pItem = me.AddItem(unpack(Keyimen.CAMP_PAD_LIST[nCamp]))
  if pItem then
    me.SetTask(Keyimen.TASK_GID, Keyimen.TASK_GET_PAD, 1)
    Keyimen:SendMessage(me, Keyimen.MSG_CHANNEL, string.format("持此军令可前往我军后方大营接取战场任务。"))
    KKin.Msg2Kin(nKinId, string.format("家族成员<color=yellow>[%s]<color>在克夷门战场中领取了一个%s。", me.szName, pItem.szName), 0)
    StatLog:WriteStatLog("stat_info", "keyimen_battle", "join", me.nId, 1)
  end
end

-- 开启龙魂任务
function tbSignup:StartTongTask()
  local nTongId = me.dwTongId
  local nKinId, nMemberId = me.GetKinMember()
  if Tong:CheckSelfRight(nTongId, nKinId, nMemberId, Tong.POW_MASTER) ~= 1 and Tong:CheckPresidentRight(nTongId, nKinId, nMemberId) ~= 1 then
    Dialog:Say("对不起，你不是帮主或首领，无法开启龙魂任务。")
    return 0
  end

  local nCamp = Keyimen:GetTongCamp(nTongId)
  if nCamp <= 0 then
    Dialog:Say("对不起，你们帮会没有选择阵营，无法开启龙魂任务。")
    return 0
  end

  if nCamp ~= Keyimen.MAP_LIST[him.nMapId] then
    Dialog:Say("对不起，请在本方后营开启龙魂任务。")
    return 0
  end

  local tbInfo = Keyimen.tbTongBuffer[nTongId]
  if tbInfo.tbTask and #tbInfo.tbTask > 0 then
    Dialog:Say("你们帮会已经开启龙魂任务了。")
    return 0
  end

  Keyimen:TongStartTask_GS(nTongId)

  local szMsg = string.format("%s开启了克夷门龙魂任务，帮会成员可以前往本方阵营报名官处接取任务了！", me.szName)
  KTong.Msg2Tong(nTongId, szMsg, 0)
  Keyimen:SendMessage(me, Keyimen.MSG_CHANNEL, szMsg)
end

-- 领取龙魂任务
function tbSignup:GetTongTask()
  local nCamp = Keyimen:GetTongCamp(me.dwTongId)
  if nCamp ~= Keyimen.MAP_LIST[him.nMapId] then
    Dialog:Say("对不起，您所在的帮会没有选择阵营，或者选择的阵营不在本方，无法接取本方龙魂任务。")
    return 0
  end

  if Keyimen:CheckPeriod() ~= 1 then
    Dialog:Say("每天14:30-15:15、21:30-22:15期间才可接取龙魂任务。")
    return 0
  end

  local tbTask = Keyimen:GetPlayerTongTask(me)
  if not tbTask then
    Dialog:Say("对不起，你所在的帮会尚未开启克夷门龙魂任务。")
    return 0
  end

  local tbResult = Task:DoAccept(Keyimen.TASK_MAIN_ID, Keyimen.TASK_MAIN_ID)
  if tbResult then
    StatLog:WriteStatLog("stat_info", "keyimen_battle", "task_accept", me.nId, 1)
  end
end

-- 完成龙魂任务
function tbSignup:FinishTongTask()
  if Keyimen:CheckPlayerTaskFinish(me) == 1 and me.GetTask(Keyimen.TASK_GID, Keyimen.TASK_STATE) == 1 then
    Keyimen:FinishTaskAward(me)
  end
end

-------------------------------------------------------

-- 装备商人
local tbTrader = Npc:GetClass("keyimen_npc_trader")

function tbTrader:OnDialog()
  local nCamp = Keyimen.MAP_LIST[him.nMapId]
  if not nCamp or nCamp <= 0 then
    Dialog:Say("你好像来错地方了。")
    return 0
  end

  local tbTxt = {
    [1] = "侵我河山者，必用其鲜血告慰我<color=yellow>西夏<color>苍生！",
    [2] = "我们要让青草覆盖的地方都成为族人的<color=yellow>牧马<color>之地。",
  }

  local szMsg = string.format(
    [[
	    %s
	    我这里有一批神甲宝驹，如果你能收集一些宝物予我，我必重谢。据说那些宝物只会出现在前线战场中，你前往之时一定要多加小心才是。
	]],
    tbTxt[nCamp]
  )

  local tbOpt = {
    { "<color=yellow>战场坐骑<color>", self.KeyimenHorse, self },
    { "<color=yellow>龙魂装备<color>", self.BuyEquip, self },
    { "我知道了" },
  }

  Dialog:Say(szMsg, tbOpt)
end

-- 战场坐骑
function tbTrader:KeyimenHorse()
  local nCamp = Keyimen.MAP_LIST[him.nMapId]
  if not nCamp or nCamp <= 0 then
    Dialog:Say("你好像来错地方了。")
    return 0
  end

  local szMsg = "    赤夜飞翔，赤地三千，乘云而奔，身有羽翅，乃神驹也。\n    我可不是吹牛，天下间也只有我一人，知道如何驯养这神驹。驯养神驹需要一些<color=yellow>特殊碎片<color>，如果你能替我寻来一些，我必重谢！"
  local tbOpt = {

    { "<color=yellow>上交赤夜飞翎<color>", self.HandinFragment, self },
    { "<color=yellow>取回赤夜飞翎", self.GetFragmentBack, self },
    { "<color=yellow>查询收集排名<color>", self.ViewLadder, self },
    { "<color=yellow>领取战场神驹<color>", self.GetHorse, self },
    { "我知道了" },
  }

  Dialog:Say(szMsg, tbOpt)
end

function tbTrader:HandinFragment(nType, tbItemObj)
  nType = nType or 0
  if nType == 0 then
    local szMsg = "每周日21:30更新赤夜飞翎收集排行榜，排名第一且<color=yellow>上交数量大于等于300<color>的侠士将可获得一匹神驹。<enter>排行榜非前5名的侠士可在周日21:30至次日21：30之间<color=yellow>领回全部上交的碎片<color>。<enter><enter>放入你所要交纳的碎片"
    Dialog:OpenGift(szMsg, nil, { self.HandinFragment, self, 1 })
    return 0
  end

  if nType == 1 then
    local tbItems = {}
    local nCount = 0
    local szItemName = ""
    for _, tbItem in pairs(tbItemObj) do
      if tbItem[1].szClass == "newhorse_piece" then
        table.insert(tbItems, tbItem[1])
        nCount = nCount + tbItem[1].nCount
        szItemName = tbItem[1].szName
      end
    end

    if nCount <= 0 then
      me.Msg("您没有放入有效物品！")
      return 0
    end

    local szMsg = string.format("你确定要交纳%d个%s吗？", nCount, szItemName)
    local tbOpt = {
      { "确定", self.HandinFragment, self, 2, tbItems },
      { "取消" },
    }
    Dialog:Say(szMsg, tbOpt)
  end

  if nType == 2 then
    local nCount = 0
    for _, pItem in pairs(tbItemObj) do
      if pItem.szClass == "newhorse_piece" then
        local nCurCount = pItem.nCount
        if me.DelItem(pItem, Player.emKLOSEITEM_HANDIN_HOSRE_FRAG) == 1 then
          nCount = nCount + nCurCount
        end
      end
    end

    if nCount ~= 0 then
      local nOrgCount = GetPlayerHonor(me.nId, PlayerHonor.HONOR_CLASS_LADDER3, 0)
      PlayerHonor:SetPlayerHonor(me.nId, PlayerHonor.HONOR_CLASS_LADDER3, 0, nOrgCount + nCount)
      Dialog:Say("你成功缴纳了" .. nCount .. "个碎片，目前排行榜上共缴纳了" .. (nOrgCount + nCount) .. "个碎片。")
      me.Msg("你成功缴纳了" .. nCount .. "个碎片，目前排行榜上共缴纳了" .. (nOrgCount + nCount) .. "个碎片。")

      -- 数据埋点
      StatLog:WriteStatLog("stat_info", "keyimen_battle", "chip_collect", me.nId, nCount)
    end
  end
end

function tbTrader:GetFragmentBack(nStep)
  local nCurTime = GetTime()
  local nWeekDay = tonumber(os.date("%w", nCurTime))
  local nDayTime = Lib:GetLocalDayTime(nCurTime)

  -- 星期天21：30之后到星期一21:30之前
  if not ((nWeekDay == 0 and nDayTime > Keyimen.SECONDS_PAST) or (nWeekDay == 1 and nDayTime < Keyimen.SECONDS_PAST)) then
    Dialog:Say("每周日晚9点30分至下周一晚9点30分是领取碎片时间，排名未达到前5名方有资格领取。")
    return
  end

  local nHonor = PlayerHonor:GetPlayerHonor(me.nId, PlayerHonor.HONOR_CLASS_LADDER3, 0)
  if nHonor <= 0 then
    Dialog:Say("您没有可取回的碎片！")
    return
  end

  local nMyRank = PlayerHonor:GetPlayerHonorRank(me.nId, PlayerHonor.HONOR_CLASS_LADDER3, 0)
  if nMyRank < Keyimen.GET_FRANG_RANK_LIMIT then
    Dialog:Say("名次不在前5名内的玩家才可领回碎片。")
    return
  end

  nStep = nStep or 0
  if nStep == 0 then
    local szMsg = string.format("您累积上交了%d个碎片，确定要全部取回吗？", nHonor)
    local tbOpt = {
      { "确定", self.GetFragmentBack, self, 1 },
      { "我再想想" },
    }
    Dialog:Say(szMsg, tbOpt)
  else
    local tbInfo = { unpack(Keyimen.FRANGMENT_GDPL) }
    table.insert(tbInfo, {})
    table.insert(tbInfo, nHonor)

    local tbItemInfo = KItem.GetOtherBaseProp(unpack(tbInfo, 1, 4))
    local nNeedCell = math.ceil(nHonor / tbItemInfo.nStackMax)
    local nFreeCell = me.CountFreeBagCell()
    if nNeedCell > nFreeCell then
      Dialog:Say(string.format("你的背包空间不足，请至少空出%d格背包空间。", nNeedCell))
      return
    end

    -- 清零，然后领道具
    PlayerHonor:SetPlayerHonor(me.nId, PlayerHonor.HONOR_CLASS_LADDER3, 0, 0)

    local nCount = me.AddStackItem(unpack(tbInfo))
    if nCount ~= nHonor then
      Dbg:WriteLog("chiyefeiling", "角色名:" .. me.szName, "帐号:" .. me.szAccount, "领取赤夜飞翎数量不足,应领" .. nHonor .. "个，实领" .. nCount .. "个。")
    end
  end
end

function tbTrader:ViewLadder()
  me.CallClientScript({ "Ui:ApplyOpenSelectedLadder", Ladder.LADDER_CLASS_LADDER, Ladder.LADDER_TYPE_LADDER_ACTION, Ladder.LADDER_TYPE_LADDER_ACTION_LADDER3 })
end

function tbTrader:GetHorse()
  local nHorseOwnerId = KGblTask.SCGetDbTaskInt(DBTASK_NEW_HORSE_OWNER)
  local szOwner = KGblTask.SCGetDbTaskStr(DBTASK_NEW_HORSE_OWNER)
  -- 以后都应该直接取角色名字，这时taskint里面应该是0
  if szOwner ~= "" and szOwner ~= me.szName then
    Dialog:Say("你没有神驹的领取资格。")
    return
  end

  -- 之前的设计错误，导致这里可能存放了玩家ID，因此这个值还是要再判断的
  -- TODO：若干周之后，情况稳定了，这段判断ID的逻辑应当要去掉
  -- szOwner为空时才需要去检查ID，因为设置szOwner时必会将ID清0
  if szOwner == "" and nHorseOwnerId ~= me.nId then
    Dialog:Say("你没有神驹的领取资格。")
    return
  end

  if me.CountFreeBagCell() <= 0 then
    Dialog:Say("请至少空出一格背包！")
    return
  end

  local pHorse = me.AddItem(unpack(Keyimen.NEW_HORSE_GDPL))
  if pHorse then
    pHorse.SetTimeOut(0, GetTime() + Keyimen.NEW_HOESE_VALID_TIME) -- 绝对时间，从领的时刻起计时，7日内有效
    pHorse.Sync()
    KGblTask.SCSetDbTaskInt(DBTASK_NEW_HORSE_OWNER, 0) -- 置0
    KGblTask.SCSetDbTaskStr(DBTASK_NEW_HORSE_OWNER, "") -- 置空
  end
end

function tbTrader:ExchangeEqToCurrency(nType, tbItemObj)
  nType = nType or 0
  if nType == 0 then
    local szMsg = "放入未强化的龙魂装备，每件龙魂装备可兑换购买价格" .. Item.EQUIP_TO_CURRENCY_RATE .. "%的龙纹银币！"
    Dialog:OpenGift(szMsg, { "Item:ExchangeEqToCurrency_CheckGiftItem" }, { self.ExchangeEqToCurrency, self, 1 })
    return 0
  end

  if me.CountFreeBagCell() <= 0 then
    me.Msg("你的背包空间不足，请至少空出一格背包空间！")
    return 0
  end

  if nType == 1 then
    local nRetCurrency = 0
    local bHaveInvalidItem = 0
    for _, tbItem in pairs(tbItemObj or {}) do
      local pItem = tbItem[1]
      if pItem.IsExEquip() ~= 1 or pItem.nEnhTimes ~= 0 then
        me.Msg("只能放入未强化的龙魂装备！")
        bHaveInvalidItem = 1
        break
      end

      if pItem.IsEquipHasStone() == 1 then
        me.Msg("请不要放入嵌有宝石的装备")
        return 0
      end

      nRetCurrency = nRetCurrency + math.floor(pItem.nPrice * Item.EQUIP_TO_CURRENCY_RATE / 10000)
    end

    if bHaveInvalidItem == 1 or nRetCurrency == 0 then
      return 0
    end

    local szMsg = string.format("扣掉这些龙魂装备，你将获得%d个龙纹银币，你确定吗？", nRetCurrency)
    local tbOpt = {
      { "确定", self.ExchangeEqToCurrency, self, 2, tbItemObj },
      { "我再想想" },
    }
    Dialog:Say(szMsg, tbOpt)
  end

  if nType == 2 then
    local nCurrencyCount = 0
    for _, tbItem in pairs(tbItemObj or {}) do
      local pItem = tbItem[1]
      if pItem.IsExEquip() == 1 and pItem.nEnhTimes == 0 and pItem.IsEquipHasStone() == 0 then
        local nRetCount = math.floor(pItem.nPrice * Item.EQUIP_TO_CURRENCY_RATE / 10000)
        if me.DelItem(pItem, Player.emKLOSEITEM_LONGEQUIP_EXCHANGE) == 1 then
          nCurrencyCount = nCurrencyCount + nRetCount
        end
      end
    end

    local tbInfo = { unpack(Item.tbLonghunCurrencyItemId) }
    tbInfo[5] = nil
    tbInfo[6] = nCurrencyCount
    local nCount = me.AddStackItem(unpack(tbInfo))
    if nCurrencyCount ~= nCount then
      Dbg:WriteLog("龙魂装备兑换龙纹银币", "角色名:" .. me.szName, "帐号:" .. me.szAccount, "理应领取银币：" .. nCurrencyCount .. "，实际获得银币：" .. nCount)
    end
  end
end

function tbTrader:CheckPermission(tbOption)
  if me.IsAccountLock() ~= 0 then
    Dialog:Say("你的账号处于锁定状态，无法进行该操作！")
    Account:OpenLockWindow(me)
    return
  end
  Lib:CallBack(tbOption)
end

-- 购买装备
function tbTrader:BuyEquip()
  local nCamp = Keyimen.MAP_LIST[him.nMapId]
  if not nCamp or nCamp <= 0 then
    Dialog:Say("你好像来错地方了。")
    return 0
  end

  local szMsg = "    如今前线战事紧张，我军急需骁勇善战之士。这里有一批极品装备，希望奖励给那些英勇杀敌之人。你可是那战场勇士？"
  local tbOpt = {
    { "<color=yellow>装备精铸<color>", self.CheckPermission, self, { me.OpenEnhance, Item.ENHANCE_MODE_CAST, Item.BIND_MONEY } },
    { "<color=yellow>换取龙魂装备声望<color>", self.ExchangeRepute, self },
    { "<color=yellow>龙魂装备兑换龙纹银币<color>", self.CheckPermission, self, { self.ExchangeEqToCurrency, self } },
    { "<color=green>龙魂·侠影声望商店<color>", self.DoBuyEquip, self, 1 },
    { "<color=green>龙魂鉴·衣服声望商店<color>", self.DoBuyEquip, self, 2 },
    { "<color=green>龙魂鉴·戒指声望商店<color>", self.DoBuyEquip, self, 3 },
    { "<color=green>龙魂鉴·护身符声望商店<color>", self.DoBuyEquip, self, 4 },
    { "我知道了" },
  }

  Dialog:Say(szMsg, tbOpt)
end

function tbTrader:ExchangeRepute()
  Dialog:OpenGift(Item:ExChangeLongHun_GetInitMsg(), { "Item:ExChangeLongHun_CheckGiftItem" }, { Item.ExChangeLongHun_OnOK, Item })
end

function tbTrader:DoBuyEquip(nType)
  local tbType = { 229, 230, 231, 232 }
  if not tbType[nType] then
    return 0
  end
  me.OpenShop(tbType[nType], 3)
end
-------------------------------------------------------

-- 战场医师
local tbSeller = Npc:GetClass("keyimen_npc_seller")

function tbSeller:OnDialog()
  local szMsg = "    战场医师：这位侠士，来到这战火纷飞之地还是得多带些药物以备不时之需呀！"
  local tbOpt = {
    { "<color=yellow>[绑定银两]我要买药<color>", self.OnBuyYaoBind, self },
    { "<color=yellow>[绑定银两]我要买菜<color>", self.OnBuyCaiBind, self },
    { "我要买药", self.OnBuyYao, self },
    { "我知道了" },
  }
  Dialog:Say(szMsg, tbOpt)
end

-- 买药
function tbSeller:OnBuyYaoBind()
  me.OpenShop(14, 7)
end

function tbSeller:OnBuyYao()
  me.OpenShop(14, 1)
end

-- 买菜
function tbSeller:OnBuyCaiBind()
  me.OpenShop(21, 7)
end
