-- 文件名　：dayplayerback_item.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-07-02 14:58:12
-- 功能    ：日常回流
Require("\\script\\task\\treasuremapex\\treasuremapex_def.lua")
local TreasureMapEx = TreasureMap.TreasureMapEx

SpecialEvent.tbDayPlayerBack = SpecialEvent.tbDayPlayerBack or {}
local tbDayPlayerBack = SpecialEvent.tbDayPlayerBack or {}

local tbItem = Item:GetClass("zhengzhanjianghuling")

function tbItem:OnUse()
  local tbOpt = { { "领取奖励", self.GetAward, self }, { "了解征战令牌功能", self.Infor, self }, { "我再想想" } }
  local szMsg = "大侠你好，欢迎你重出江湖，你可以携带此道具参加江湖事迹即可让你事半功倍。快快查看您的江湖事迹进度情况吧？"
  Dialog:Say(szMsg, tbOpt)
  return
end

function tbItem:GetAward(nIndex)
  if not nIndex then
    local tbOpt = {}
    for i, tb in ipairs(tbDayPlayerBack.tbEventList) do
      if i <= 4 then
        table.insert(tbOpt, { tb[1], self.GetAward, self, i })
      end
    end
    local tbOldPlayerInfo = SpecialEvent.tbOldPlayerBack.tbOldPlayerInfo[2][string.lower(me.szAccount)] or SpecialEvent.tbOldPlayerBack.tbOldPlayerInfo2[string.lower(me.szAccount)] or SpecialEvent.tbOldPlayerBack.tbOldPlayerInfo3[string.lower(me.szAccount)]
    local nNowDate = tonumber(GetLocalDate("%Y%m%d"))
    if tbOldPlayerInfo and nNowDate <= SpecialEvent.tbOldPlayerBack.nCloseDate[2] then
      table.insert(tbOpt, { "<color=yellow>重礼邀江湖前辈重出江湖<color>", SpecialEvent.tbOldPlayerBack.OnDialog_Old, SpecialEvent.tbOldPlayerBack })
    end
    table.insert(tbOpt, { "我再想想" })
    Dialog:Say("请选择您要领取的活动？", tbOpt)
    return
  end
  if nIndex == 1 then
    self:GetWantedAward()
  elseif nIndex == 2 then
    self:GetXoyoAward()
  elseif nIndex == 3 then
    self:GetTreasureAward()
  elseif nIndex == 4 then
    self:GetBaihuAward()
  end
end

function tbItem:GetWantedAward(nFlag)
  local nCount = me.GetTask(2040, 2)
  local tbInfo = tbDayPlayerBack.tbEventList[1]
  local nMaxCount = me.GetTask(tbDayPlayerBack.TASK_GID, tbInfo[4])
  local nGetCount = me.GetTask(tbDayPlayerBack.TASK_GID, tbInfo[5])
  if nGetCount >= nMaxCount then
    Dialog:Say("您已经没有官府通缉加速次数了。")
    return
  end
  if nCount < 1 then
    Dialog:Say("您已经没有官府通缉次数了。")
    return
  end
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("对不起，您身上的背包空间不足1格。")
    return
  end
  if not nFlag then
    Dialog:Say("您是否需要耗费一次官府通缉参加机会，获得3个名捕令和1点江湖威望？", { { "我愿意", self.GetWantedAward, self, 1 }, { "我再想想" } })
    return
  end
  me.AddStackItem(18, 1, 190, 1, nil, 3)
  me.AddKinReputeEntry(1)
  me.SetTask(2040, 2, nCount - 1)
  me.SetTask(tbDayPlayerBack.TASK_GID, tbInfo[5], nGetCount + 1)
  StatLog:WriteStatLog("stat_info", "roleback", "lingpai_use", me.nId, 1)
  me.Msg("恭喜你获得官府通缉加速奖励。")
end

function tbItem:GetXoyoAward(nFlag)
  local nCount = me.GetTask(2050, 1)
  local tbInfo = tbDayPlayerBack.tbEventList[2]
  local nMaxCount = me.GetTask(tbDayPlayerBack.TASK_GID, tbInfo[4])
  local nGetCount = me.GetTask(tbDayPlayerBack.TASK_GID, tbInfo[5])
  if nGetCount >= nMaxCount then
    Dialog:Say("您已经没有逍遥谷加速次数了。")
    return
  end
  if nCount < 1 then
    Dialog:Say("您已经没有参加逍遥谷的次数了。")
    return
  end
  if me.CountFreeBagCell() < 2 then
    Dialog:Say("对不起，您身上的背包空间不足2格。")
    return
  end
  if not nFlag then
    Dialog:Say("您是否需要耗费一次逍遥谷参加机会和30个上交逍遥谷材料机会（如果当天已经上交满60个，则不扣除），获得1个逍遥玄晶宝箱和3点江湖威望，更有机会获得1张特殊卡？", { { "我愿意", self.GetXoyoAward, self, 1 }, { "我再想想" } })
    return
  end
  --上交物品数
  local nTimes = me.GetTask(XoyoGame.TASK_GROUP, XoyoGame.REPUTE_TIMES)
  local nDate = me.GetTask(XoyoGame.TASK_GROUP, XoyoGame.CUR_REPUTE_DATE)
  local nCurDate = tonumber(os.date("%Y%m%d", GetTime()))
  if nDate ~= nCurDate then
    me.SetTask(XoyoGame.TASK_GROUP, XoyoGame.CUR_REPUTE_DATE, nCurDate)
    nTimes = 0
  end
  me.SetTask(XoyoGame.TASK_GROUP, XoyoGame.REPUTE_TIMES, nTimes + 30)
  me.AddItemEx(18, 1, 1756, 1)
  me.AddKinReputeEntry(3)
  me.SetTask(2050, 1, nCount - 1)
  if MathRandom(100) <= 30 then
    me.AddItemEx(18, 1, 314, 1, { bForceBind = 1 })
  end
  me.SetTask(tbDayPlayerBack.TASK_GID, tbInfo[5], nGetCount + 1)
  StatLog:WriteStatLog("stat_info", "roleback", "lingpai_use", me.nId, 2)
  me.Msg("恭喜你获得逍遥谷加速奖励。")
end

function tbItem:GetTreasureAward()
  local tbInfo = tbDayPlayerBack.tbEventList[3]
  local nMaxCount = me.GetTask(tbDayPlayerBack.TASK_GID, tbInfo[4])
  local nGetCount = me.GetTask(tbDayPlayerBack.TASK_GID, tbInfo[5])
  if nGetCount >= nMaxCount then
    Dialog:Say("您已经没有藏宝图加速次数了。")
    return
  end
  if me.GetTask(TreasureMapEx.TASK_GROUP, 1) > 0 then
    local tbOpt = {
      { "使用一次藏宝图次数兑换奖励", self.ChangAward, self },
      { "我再想想" },
    }
    Dialog:Say("您要使用藏宝图次数兑换奖励吗，10个奖励箱子/1个藏宝图。", tbOpt)
  else
    Dialog:Say("你没有藏宝图次数。")
  end
  --Dialog:OpenGift("请放入<color=yellow>1个藏宝图令牌<color>，可以给你兑换<color=yellow>奖励宝箱10个<color>。", nil ,{self.OnOpenGiftOk, self});
end

function tbItem:ChangAward()
  local tbInfo = tbDayPlayerBack.tbEventList[3]
  local nMaxCount = me.GetTask(tbDayPlayerBack.TASK_GID, tbInfo[4])
  local nGetCount = me.GetTask(tbDayPlayerBack.TASK_GID, tbInfo[5])
  if nGetCount >= nMaxCount then
    Dialog:Say("您已经没有藏宝图加速次数了。")
    return
  end
  if me.GetTask(TreasureMapEx.TASK_GROUP, 1) <= 0 then
    Dialog:Say("您已经没有藏宝图次数了。")
    return
  end
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("对不起，您身上的背包空间不足1格。")
    return
  end
  local nSelfLevel = 0
  for i, nLevelEx in ipairs(tbDayPlayerBack.tbLevelLimit) do
    if me.nLevel >= nLevelEx and (not tbDayPlayerBack.tbLevelLimit[i + 1] or me.nLevel < tbDayPlayerBack.tbLevelLimit[i + 1]) then
      nSelfLevel = i
      break
    end
  end
  me.SetTask(TreasureMapEx.TASK_GROUP, 1, me.GetTask(TreasureMapEx.TASK_GROUP, 1) - 1)
  me.AddStackItem(18, 1, 1868, nSelfLevel, { bForceBind = 1 }, 10)
  me.SetTask(tbDayPlayerBack.TASK_GID, tbInfo[5], nGetCount + 1)
  StatLog:WriteStatLog("stat_info", "roleback", "lingpai_use", me.nId, 3)
  me.Msg("恭喜你获得藏宝图加速奖励。")
end

function tbItem:OnOpenGiftOk(tbItemObj)
  local tbInfo = tbDayPlayerBack.tbEventList[3]
  local nMaxCount = me.GetTask(tbDayPlayerBack.TASK_GID, tbInfo[4])
  local nGetCount = me.GetTask(tbDayPlayerBack.TASK_GID, tbInfo[5])
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("对不起，您身上的背包空间不足1格。")
    return
  end
  if nGetCount >= nMaxCount then
    Dialog:Say("您已经没有藏宝图加速次数了。")
    return
  end
  if #tbItemObj ~= 1 then
    Dialog:Say("只能放入一个藏宝图令牌。")
    return
  end
  local nLevel = tbDayPlayerBack.tbTreasureLing[tbItemObj[1][1].SzGDPL()]
  if not nLevel then
    Dialog:Say("请放入一个藏宝图令牌。")
    return
  end
  local nSelfLevel = 0
  for i, nLevelEx in ipairs(tbDayPlayerBack.tbLevelLimit) do
    if me.nLevel >= nLevelEx and (not tbDayPlayerBack.tbLevelLimit[i + 1] or me.nLevel < tbDayPlayerBack.tbLevelLimit[i + 1]) then
      nSelfLevel = i
      break
    end
  end
  nLevel = math.min(nLevel, nSelfLevel)
  if nLevel <= 0 then
    Dialog:Say("请放入其他的藏宝图令牌。")
    return
  end
  me.AddStackItem(18, 1, 1018, nLevel, { bForceBind = 1 }, 10)
  if tbItemObj[1][1].nCount > 1 then
    tbItemObj[1][1].SetCount(tbItemObj[1][1].nCount - 1)
  else
    tbItemObj[1][1].Delete(me)
  end
  me.SetTask(tbDayPlayerBack.TASK_GID, tbInfo[5], nGetCount + 1)
  StatLog:WriteStatLog("stat_info", "roleback", "lingpai_use", me.nId, 3)
  me.Msg("恭喜你获得藏宝图加速奖励。")
end

function tbItem:GetBaihuAward(nFlag)
  local nTimes = me.GetTask(BaiHuTang.TSKG_PVP_ACT, BaiHuTang.TSK_BaiHuTang_PKTIMES) or 0
  local nOtherTimes = me.GetTask(BaiHuTang.TSKG_PVP_ACT, BaiHuTang.TSK_BaiHuTang_PKTIMES_Ex) or 0
  local nNowDate = tonumber(GetLocalDate("%y%m%d"))
  local nDate = math.floor(nTimes / 10)
  local nPKTimes = nTimes % 10
  local tbInfo = tbDayPlayerBack.tbEventList[4]
  local nMaxCount = me.GetTask(tbDayPlayerBack.TASK_GID, tbInfo[4])
  local nGetCount = me.GetTask(tbDayPlayerBack.TASK_GID, tbInfo[5])
  if nGetCount >= nMaxCount then
    Dialog:Say("您已经没有白虎堂加速次数了。")
    return
  end
  if (nDate == nNowDate) and nPKTimes >= BaiHuTang.MAX_ONDDAY_PKTIMES then
    Dialog:Say("您已经没有可以参加白虎的次数了。")
    return
  end
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("对不起，您身上的背包空间不足1格。")
    return
  end
  if not nFlag then
    Dialog:Say("您是否需要耗费一次白虎堂参加机会，获得1个白虎玄晶宝箱和1点江湖威望？", { { "我愿意", self.GetBaihuAward, self, 1 }, { "我再想想" } })
    return
  end
  if nDate ~= nNowDate then
    me.SetTask(BaiHuTang.TSKG_PVP_ACT, BaiHuTang.TSK_BaiHuTang_PKTIMES, nNowDate * 10 + 1)
  else
    me.SetTask(BaiHuTang.TSKG_PVP_ACT, BaiHuTang.TSK_BaiHuTang_PKTIMES, nTimes + 1)
  end
  me.AddItemEx(18, 1, 1757, 1)
  me.AddKinReputeEntry(1)
  me.SetTask(tbDayPlayerBack.TASK_GID, tbInfo[5], nGetCount + 1)
  StatLog:WriteStatLog("stat_info", "roleback", "lingpai_use", me.nId, 4)
  me.Msg("恭喜你获得白虎堂加速奖励。")
end

function tbItem:Infor(nIndex)
  local szInfo = "您可以参加一下江湖事迹，完成后可以获得加速次数或直接获得加速奖励，让你参加活动事半功倍。"
  local tbEventInfo = {
    [1] = [[<color=green>官府通缉<color>
	
		最大加速次数：<color=yellow>%s<color>
		已经完成情况：<color=yellow>%s / %s（已经使用的加速次数/获得的加速次数）<color>
		
		<color=red>注：完成一次官府通缉获得一次加速次数，使用道具领取奖励（消耗一次官府通缉次数，获得3个名捕令和1点江湖威望）<color>]],
    [2] = [[<color=green>逍遥谷<color>
	
		最大加速次数：<color=yellow>%s<color>
		已经完成情况：<color=yellow>%s / %s（已经使用的加速次数/获得的加速次数）<color>
		
		<color=red>注：完成一次逍遥谷通过4关获得一次加速次数，使用道具领取奖励（消耗一次逍遥谷次数和上交材料数目30个，获得1个逍遥玄晶箱和3点江湖威望，更有机会获得特殊卡片）<color>]],
    [3] = [[<color=green>藏宝图<color>
	
		最大加速次数：<color=yellow>%s<color>
		已经完成情况：<color=yellow>%s / %s（已经使用的加速次数/获得的加速次数）<color>
		
		<color=red>注：完成一次藏宝图获得一次加速次数，使用道具领取奖励（消耗1个藏宝图令牌，根据令牌级别给予箱子10个）<color>]],
    [4] = [[<color=green>白虎堂<color>
	
		最大加速次数：<color=yellow>%s<color>
		已经完成情况：<color=yellow>%s / %s（已经使用的加速次数/获得的加速次数）<color>
		
		<color=red>注：通过白虎堂2层获得一次加速次数，使用道具领取奖励（消耗1次白虎堂机会，获得白虎玄晶箱和1点江湖威望）<color>]],
    [5] = [[<color=green>军营<color>
	
		最大加速次数：<color=yellow>%s<color>
		已经完成情况：<color=yellow>%s / %s（已经使用的加速次数/获得的加速次数）<color>
		
		<color=red>注：完成一次军营任务获得一次加速次数，获得加速机会同时获得奖励（1点军营声望，不绑定银两1000，1个军营玄晶箱和1点江湖威望）<color>]],
    [6] = [[<color=green>灯谜活动<color>
	
		最大加速次数：<color=yellow>%s<color>
		已经完成情况：<color=yellow>%s / %s（已经使用的加速次数/获得的加速次数）<color>
		
		<color=red>注：完成一次灯谜200分获得一次加速次数，获得加速机会同时获得奖励（获得灯谜奖励翻倍）<color>]],
    [7] = [[<color=green>初级家族关卡<color>
	
		最大加速次数：<color=yellow>%s<color>
		已经完成情况：<color=yellow>%s / %s（已经使用的加速次数/获得的加速次数）<color>
		
		<color=red>注：使用古铜币每换1个箱子获得一次加速次数，获得加速机会同时获得奖励（获得古铜币60个）<color>]],
    [8] = [[<color=green>高级家族关卡<color>
	
		最大加速次数：<color=yellow>%s<color>
		已经完成情况：<color=yellow>%s / %s（已经使用的加速次数/获得的加速次数）<color>
		
		<color=red>注：使用古金币每换1个箱子获得一次加速次数，获得加速机会同时获得奖励（获得古金币60个）<color>]],
    [9] = [[<color=green>领土争夺<color>
	
		最大加速次数：<color=yellow>%s<color>
		已经完成情况：<color=yellow>%s / %s（已经使用的加速次数/获得的加速次数）<color>
		
		<color=red>注：领土完成获得超过1000分获得一次加速次数，获得加速机会同时获得奖励（获得领土奖励箱子翻倍）<color>]],
    [10] = [[<color=green>家园种植<color>
	
		最大加速次数：<color=yellow>%s<color>
		已经完成情况：<color=yellow>%s / %s（已经使用的加速次数/获得的加速次数）<color>
		
		<color=red>注：每次收获植物时获得一次加速次数，获得加速机会同时获得奖励（获得的收成翻倍）<color>]],
    [11] = [[<color=green>侠客任务<color>
	
		最大加速次数：<color=yellow>%s<color>
		已经完成情况：<color=yellow>%s / %s（已经使用的加速次数/获得的加速次数）<color>
		
		<color=red>注：完成一次侠客任务获得一次加速次数，获得加速机会同时获得奖励（获得的奖励侠客令翻倍）<color>]],
  }
  if not nIndex then
    local tbOpt = {}
    for i, tb in ipairs(tbDayPlayerBack.tbEventList) do
      table.insert(tbOpt, { tb[1], self.Infor, self, i })
    end
    table.insert(tbOpt, { "我再想想" })
    Dialog:Say(szInfo, tbOpt)
    return
  end
  local tbEvent = tbDayPlayerBack.tbEventList[nIndex]
  local nRate = me.GetTask(tbDayPlayerBack.TASK_GID, tbDayPlayerBack.TASK_RATE_BACK)
  local szInfoEx = string.format(tbEventInfo[nIndex], math.min(nRate * tbEvent[2], tbEvent[3]), me.GetTask(tbDayPlayerBack.TASK_GID, tbEvent[5]), me.GetTask(tbDayPlayerBack.TASK_GID, tbEvent[4]))
  Dialog:Say(szInfoEx)
  return
end
