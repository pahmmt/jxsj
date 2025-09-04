-- 文件名　：guoqing2012_item.lua
-- 创建者　：huangxiaoming
-- 创建时间：2012-09-17 20:29:20
-- 描  述  ：

if not MODULE_GAMESERVER then
  return
end

Require("\\script\\event\\jieri\\201209_zhongqiuguoqing\\guoqing2012_def.lua")

SpecialEvent.GuoQing2012 = SpecialEvent.GuoQing2012 or {}
local tbGuoQing2012 = SpecialEvent.GuoQing2012 or {}

----------------------灯笼-----------------------------------
local tbItemIBLantern = Item:GetClass("guoqing2012_iblantern")

function tbItemIBLantern:OnUse()
  local pItem = me.AddItem(unpack(tbGuoQing2012.ITEMID_EVENT[1][3]))
  if pItem then
    pItem.Bind(3)
  else
    Dbg:WriteLog("guoqin2012", "add match", me.szName)
  end
  return 1
end

local tbItemLantern = Item:GetClass("guoqing2012_lantern")

function tbItemLantern:InitGenInfo()
  local nDate = tonumber(GetLocalDate("%Y%m%d"))
  local nValidTime = Lib:GetDate2Time(nDate) + 24 * 3600 - 1
  it.SetTimeOut(0, nValidTime)
end

function tbItemLantern:OnUse()
  if tbGuoQing2012:CheckIsOpen() ~= 1 then
    Dialog:Say("2012年9月27日至10月10日，每天<color=green>11：00-14:00、18:00-23:00<color>期间才可参加此活动")
    return
  end
  if tbGuoQing2012:CheckActivityTime() ~= 1 then
    Dialog:Say("活动还未开启，2012年9月27日至10月10日，每天<color=green>11：00-14:00、18:00-23:00<color>期间才可参加此活动")
    return
  end
  local nState = tbGuoQing2012:GetEventState(me)
  if nState ~= 0 then
    Dialog:Say("当前步骤不是挂灯笼")
    return
  end
  local nNextState = nState + 1
  local nLevel = it.nLevel
  local szMsg = ""
  local tbOpt = {}
  if nLevel == 1 then
    szMsg = szMsg .. string.format("你可以花费%s金币将竹藤纸灯升级为吉祥彩灯，将获得更丰厚的奖励。<enter><color=green>【竹藤纸灯】<color><enter>奖励：玄晶、绑银<enter><color=green>【吉祥彩灯】<color><enter>奖励：更多玄晶、绑银、<color=pink>葫小芦跟宠、古墓面具、稀有坐骑。<color>\n", tbGuoQing2012.EVENT_COST_COIN_NUM[1])
    local nStepInfo = tbGuoQing2012:GetEventStepInfo(me, nNextState)
    if nStepInfo == 2 then
      Dialog:Say("你身上有更好的道具，不要用这个了")
      return
    end
    local tbNpc = Npc:GetClass("guoqing2012_huodongdashi")
    table.insert(tbOpt, { string.format("升级灯笼（消耗%s金币）", tbGuoQing2012.EVENT_COST_COIN_NUM[nNextState]), tbNpc.LevelUpTaskItem, tbNpc, nNextState, nStepInfo })
  end
  table.insert(tbOpt, { "悬挂灯笼", tbGuoQing2012.HangLantern, tbGuoQing2012, me.nId, nLevel })
  table.insert(tbOpt, { "我随便看看" })
  szMsg = szMsg .. "你确定要在这里悬挂灯笼吗？"
  Dialog:Say(szMsg, tbOpt)
end

------------------------------------------------------------------

---------------------火柴--------------------------------------

local tbItemIBMatch = Item:GetClass("guoqing2012_ibmatch")

function tbItemIBMatch:OnUse()
  local pItem = me.AddItem(unpack(tbGuoQing2012.ITEMID_EVENT[2][3]))
  if pItem then
    pItem.Bind(3)
  else
    Dbg:WriteLog("guoqin2012", "add match", me.szName)
  end
  return 1
end

local tbItemMatch = Item:GetClass("guoqing2012_match")

function tbItemMatch:InitGenInfo()
  local nDate = tonumber(GetLocalDate("%Y%m%d"))
  local nValidTime = Lib:GetDate2Time(nDate) + 24 * 3600 - 1
  it.SetTimeOut(0, nValidTime)
end

function tbItemMatch:OnUse()
  if tbGuoQing2012:CheckIsOpen() ~= 1 then
    Dialog:Say("2012年9月27日至10月10日，每天<color=green>11：00-14:00、18:00-23:00<color>期间才可参加此活动")
    return
  end
  if tbGuoQing2012:CheckActivityTime() ~= 1 then
    Dialog:Say("活动还未开启，2012年9月27日至10月10日，每天<color=green>11：00-14:00、18:00-23:00<color>期间才可参加此活动")
    return
  end
  local nState = tbGuoQing2012:GetEventState(me)
  if nState ~= 1 then
    Dialog:Say("当前步骤不是点炮竹")
    return
  end
  local nNextState = nState + 1
  local nLevel = it.nLevel
  local szMsg = "确认要在原地摆放出一个炮竹吗？\n"
  local tbOpt = {}
  if nLevel == 1 then
    szMsg = szMsg .. string.format("你可以花费%s金币将小炮竹升级为皇家礼炮，将获得更丰厚的奖励。<enter><color=green>【小炮竹】<color><enter>奖励：玄晶、绑银<enter><color=green>【皇家礼炮】<color><enter>奖励：更多玄晶、绑银、<color=pink>葫小芦跟宠、古墓面具、稀有坐骑。<color>\n", tbGuoQing2012.EVENT_COST_COIN_NUM[1])
    local nStepInfo = tbGuoQing2012:GetEventStepInfo(me, nNextState)
    if nStepInfo == 2 then
      return
    end
    local tbNpc = Npc:GetClass("guoqing2012_huodongdashi")
    table.insert(tbOpt, { string.format("升级炮竹（消耗%s金币）", tbGuoQing2012.EVENT_COST_COIN_NUM[nNextState]), tbNpc.LevelUpTaskItem, tbNpc, nNextState, nStepInfo })
  end
  table.insert(tbOpt, { "摆放炮竹", tbGuoQing2012.AddFireWork, tbGuoQing2012, me.nId, nLevel })
  table.insert(tbOpt, { "我随便看看" })
  Dialog:Say(szMsg, tbOpt)
end

------------------------------------------------------------------

---------------------月饼---------------------------------------
local tbItemIBMoonCake = Item:GetClass("guoqing2012_ibmooncake")

function tbItemIBMoonCake:OnUse()
  local pItem = me.AddItem(unpack(tbGuoQing2012.ITEMID_EVENT[3][3]))
  if pItem then
    pItem.Bind(3)
  else
    Dbg:WriteLog("guoqin2012", "add mooncake", me.szName)
  end
  return 1
end

local tbItemMoonCake = Item:GetClass("guoqing2012_mooncake")

function tbItemMoonCake:InitGenInfo()
  local nDate = tonumber(GetLocalDate("%Y%m%d"))
  local nValidTime = Lib:GetDate2Time(nDate) + 24 * 3600 - 1
  it.SetTimeOut(0, nValidTime)
end

function tbItemMoonCake:OnUse()
  if tbGuoQing2012:CheckIsOpen() ~= 1 then
    Dialog:Say("2012年9月27日至10月10日，每天<color=green>11：00-14:00、18:00-23:00<color>期间才可参加此活动")
    return
  end
  if tbGuoQing2012:CheckActivityTime() ~= 1 then
    Dialog:Say("活动还未开启，2012年9月27日至10月10日，每天<color=green>11：00-14:00、18:00-23:00<color>期间才可参加此活动")
    return
  end
  local nState = tbGuoQing2012:GetEventState(me)
  if nState ~= 2 then
    Dialog:Say("当前步骤不是送月饼")
    return
  end
  local nNextState = nState + 1
  local nLevel = it.nLevel
  local szMsg = ""
  local tbOpt = {}
  if nLevel == 1 then
    szMsg = szMsg .. string.format("你可以花费%s金币将豆沙月饼升级为水晶月饼，将获得更丰厚的奖励。<enter><color=green>【豆沙月饼】<color><enter>奖励：玄晶、绑银<enter><color=green>【水晶月饼】<color><enter>奖励：更多玄晶、绑银、<color=pink>葫小芦跟宠、古墓面具、稀有坐骑。<color>\n", tbGuoQing2012.EVENT_COST_COIN_NUM[1])
    local nStepInfo = tbGuoQing2012:GetEventStepInfo(me, nNextState)
    if nStepInfo == 2 then
      Dialog:Say("你身上有更好的月饼，不要用这个了")
      return
    end
    local tbNpc = Npc:GetClass("guoqing2012_huodongdashi")
    table.insert(tbOpt, { string.format("升级月饼（消耗%s金币）", tbGuoQing2012.EVENT_COST_COIN_NUM[nNextState]), tbNpc.LevelUpTaskItem, tbNpc, nNextState, nStepInfo })
  else
    szMsg = szMsg .. "你确定要把月饼送给此队友吗？"
  end
  table.insert(tbOpt, { "赠送月饼", tbGuoQing2012.PresentMoonCake, tbGuoQing2012, me.nId, nLevel })
  table.insert(tbOpt, { "我随便看看" })
  Dialog:Say(szMsg, tbOpt)
end

-----------------------------------------------------------------------

----------------------------国庆礼盒--------------------------------------
local tbItemBoxAward = Item:GetClass("guoqing2012_boxaward")

function tbItemBoxAward:OnUse()
  if me.CountFreeBagCell() < 3 then
    Dialog:Say("背包空间不足，需要3格背包空间。")
    return 0
  end
  local nLevel = it.nLevel
  local nOpenDay = math.floor((GetTime() - KGblTask.SCGetDbTaskInt(DBTASD_SERVER_STARTTIME)) / (60 * 60 * 24))
  local tbAward = Lib._CalcAward:RandomAward(3, 4, 2, tbGuoQing2012.AWARD_VALUE_BOX[nLevel], Lib:_GetXuanReduce(nOpenDay), { 6, 4, 0 })
  local nMaxMoney = tbGuoQing2012:GetMaxMoney(tbAward)
  if nMaxMoney + me.GetBindMoney() > me.GetMaxCarryMoney() then
    Dialog:Say("对不起，您身上的绑定银两可能会超出上限，请整理后再来领取。")
    return 0
  end
  tbGuoQing2012:RandomAward(me, tbAward, nLevel + 1)
  if nLevel == 2 then
    tbGuoQing2012:RandPet(me)
    tbGuoQing2012:RandExtendAward(me)
  end
  return 1
end
--------------------------------------------------------------------------

-------------------------好友赠送的月饼-----------------------------------
local tbItemFreeMoonCake = Item:GetClass("guoqing2012_freemooncake")

function tbItemFreeMoonCake:OnUse()
  local nOpenDay = math.floor((GetTime() - KGblTask.SCGetDbTaskInt(DBTASD_SERVER_STARTTIME)) / (60 * 60 * 24))
  local tbAward = Lib._CalcAward:RandomAward(3, 4, 2, tbGuoQing2012.AWARD_VALUE_FREE_MOONCAKE, Lib:_GetXuanReduce(nOpenDay), { 0, 10, 0 })
  local nMaxMoney = tbGuoQing2012:GetMaxMoney(tbAward)
  if nMaxMoney + me.GetBindMoney() > me.GetMaxCarryMoney() then
    Dialog:Say("对不起，您身上的绑定银两可能会超出上限，请整理后再来领取。")
    return 0
  end
  tbGuoQing2012:RandomAward(me, tbAward, 1)
  return 1
end
--------------------------------------------------------------------------

-------------------------回流道具---------------------------------------
local tbItemHuiLiuCard = Item:GetClass("guoqing2012_huiliucard")

function tbItemHuiLiuCard:OnUse()
  if tbGuoQing2012:CheckIsOpen() ~= 1 then
    Dialog:Say("不在活动期间无法使用")
    return
  end
  local szMsg = "<color=green>【开卡日期】<color>\n欢度国庆·一马当先:\t9月28日\n欢度国庆·两全其美:\t10月1日\n欢度国庆·三星在天:\t10月4日\n欢度国庆·四海升平：\t10月8日\n欢度国庆·五谷丰登：\t10月9日\n\n"
  local tbOpt = {}
  local nLevel = it.nLevel
  local nDate = tonumber(GetLocalDate("%Y%m%d"))
  if nDate < tbGuoQing2012.HUANDUGUOQING_OPENDAY[nLevel] then -- 没到开卡日期
    szMsg = szMsg .. "<color=red>今天不是本张卡片的开启时间<color>"
    Dialog:Say(szMsg)
  elseif nDate > tbGuoQing2012.HUANDUGUOQING_OPENDAY[nLevel] then -- 过了开卡日期
    szMsg = szMsg .. "你的本张欢度国庆卡已过期，开启后只能获得部分奖励。"
    table.insert(tbOpt, { "开启卡片", tbGuoQing2012.OpenHuiLiuCard, tbGuoQing2012, me.nId, nLevel, 2 })
  else
    szMsg = szMsg .. "今日可以开启本张欢度国庆卡"
    table.insert(tbOpt, { "开启卡片", tbGuoQing2012.OpenHuiLiuCard, tbGuoQing2012, me.nId, nLevel, 1 })
  end
  table.insert(tbOpt, { "我再考虑一下" })
  Dialog:Say(szMsg, tbOpt)
end
--------------------------------------------------------------------------

---------------------------------回流收集卡--------------------------------
local tbItemHuiLiuBook = Item:GetClass("guoqing2012_huiliubook")

function tbItemHuiLiuBook:OnUse()
  local tbCardInfo = tbGuoQing2012:GetHuiLiuCardInfo(me)
  local szMsg = ""
  local nAwardFalg = 1
  for i = 1, #tbCardInfo do
    if tbCardInfo[i] == 0 then
      nAwardFalg = 0
      szMsg = szMsg .. string.format("%s:%s(未开启)\n", i, tbGuoQing2012.HUANDUGUOQING_CARDNAME[i])
    elseif tbCardInfo[i] == 1 then
      szMsg = szMsg .. string.format("<color=green>%s:%s（正常开启）<color>\n", i, tbGuoQing2012.HUANDUGUOQING_CARDNAME[i])
    elseif tbCardInfo[i] == 2 then
      if nAwardFalg ~= 0 then
        nAwardFalg = 2
      end
      szMsg = szMsg .. string.format("<color=red>%s:%s（过期开启）<color>\n", i, tbGuoQing2012.HUANDUGUOQING_CARDNAME[i])
    end
  end
  szMsg = szMsg .. "开启5个欢度国庆卡片即可打开欢度国庆纪念卡册。\n"
  local tbOpt = {}
  if nAwardFalg == 0 then
    szMsg = szMsg .. "\n<color=pink>在指定日期开满5张卡片，即可获得5888绑金或者小游龙阁声望令牌。若卡片已过期则需要花费一定金币开启也可以获得同样奖励。<color>"
    table.insert(tbOpt, { "<color=gray>打开纪念卡册<color>", self.PromptFail, self })
  elseif nAwardFalg == 1 then
    table.insert(tbOpt, { "打开纪念卡册", tbGuoQing2012.GetHuiLiuCardFinalAward, tbGuoQing2012, me.nId, nAwardFalg })
  elseif nAwardFalg == 2 then
    szMsg = szMsg .. "由于你没有按时开启欢度国庆系列卡片，所以需要花费金币才能开启"
    table.insert(tbOpt, { string.format("<color=yellow>花费%s金币开启<color>", tbGuoQing2012.HUILIU_COST_COIN_NUM), self.ConsumeConfirm, self, nAwardFalg })
  end
  table.insert(tbOpt, { "我只是随便看看" })
  Dialog:Say(szMsg, tbOpt)
end

function tbItemHuiLiuBook:ConsumeConfirm(nAwardFalg)
  local szMsg = string.format("确定花费%s金币开启", tbGuoQing2012.HUILIU_COST_COIN_NUM)
  local tbOpt = {
    { "确定开启", tbGuoQing2012.GetHuiLiuCardFinalAward, tbGuoQing2012, me.nId, nAwardFalg },
    { "我再考虑一下" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbItemHuiLiuBook:PromptFail()
  Dialog:Say("你还没有开启5张欢度国庆系列卡片，无法使用")
end
---------------------------------------------------------------------------

---------------------------回流收集册最终大奖------------------------------
local tbItemHuiLiuFinalAward = Item:GetClass("guoqing_huiliufinalaward")

function tbItemHuiLiuFinalAward:OnUse()
  if me.GetTask(tbGuoQing2012.TASK_GROUP_ID, tbGuoQing2012.TASK_HUILIU_FINAL_AWARD) == 1 then
    return 0
  end
  local nAwardIndex = 1
  local nRand = MathRandom(100)
  local nSum = 0
  for nIndex, tbTemp in ipairs(tbGuoQing2012.AWARD_VALUE_FINALAWARD) do
    nSum = nSum + tbTemp[1]
    if nSum >= nRand then
      nAwardIndex = nIndex
      break
    end
  end
  if tbGuoQing2012.AWARD_VALUE_FINALAWARD[nAwardIndex][2] == 1 then -- 绑金
    me.AddBindCoin(tbGuoQing2012.AWARD_VALUE_FINALAWARD[nAwardIndex][3])
    me.SendMsgToFriend(string.format("您的好友[<color=yellow>%s<color>]开启了开启了欢度国庆纪念卡册获得了%s绑金", me.szName, tbGuoQing2012.AWARD_VALUE_FINALAWARD[nAwardIndex][3]))
    StatLog:WriteStatLog("stat_info", "midautunm2012", "light_bag", me.nId, "BindCoin", tbGuoQing2012.AWARD_VALUE_FINALAWARD[nAwardIndex][3])
  elseif tbGuoQing2012.AWARD_VALUE_FINALAWARD[nAwardIndex][2] == 2 then -- 道具
    local nItemRand = MathRandom(#tbGuoQing2012.AWARD_VALUE_FINALAWARD[nAwardIndex][3])
    local pItem = me.AddItem(unpack(tbGuoQing2012.AWARD_VALUE_FINALAWARD[nAwardIndex][3][nItemRand]))
    if pItem then
      pItem.Bind(1)
      me.SendMsgToFriend(string.format("您的好友[<color=yellow>%s<color>]开启了开启了欢度国庆纪念卡册获得了%s", me.szName, pItem.szName))
      Dialog:GlobalNewsMsg_GS(string.format("%s打开欢度国庆纪念卡册获得了小游龙阁声望令牌", me.szName))
    else
      Dbg:WriteLog("guoqing2012", "use final award fail", me.szName, string.format("%s_%s_%s_%s", unpack(tbGuoQing2012.AWARD_VALUE_FINALAWARD[nAwardIndex][3][nItemRand])))
    end
    StatLog:WriteStatLog("stat_info", "midautunm2012", "light_bag", me.nId, string.format("%s_%s_%s_%s", unpack(tbGuoQing2012.AWARD_VALUE_FINALAWARD[nAwardIndex][3][nItemRand])), 1)
  end
  me.SetTask(tbGuoQing2012.TASK_GROUP_ID, tbGuoQing2012.TASK_HUILIU_FINAL_AWARD, 1)
  return 1
end
---------------------------------------------------------------------------
