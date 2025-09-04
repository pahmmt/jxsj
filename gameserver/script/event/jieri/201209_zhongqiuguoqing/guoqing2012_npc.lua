-- 文件名　：guoqing2012_npc.lua
-- 创建者　：huangxiaoming
-- 创建时间：2012-09-10 16:16:10
-- 描  述  ：

if not MODULE_GAMESERVER then
  return
end

Require("\\script\\event\\jieri\\201209_zhongqiuguoqing\\guoqing2012_def.lua")

SpecialEvent.GuoQing2012 = SpecialEvent.GuoQing2012 or {}
local tbGuoQing2012 = SpecialEvent.GuoQing2012 or {}

local tbNpcHuoDongDaShi = Npc:GetClass("guoqing2012_huodongdashi")

function tbNpcHuoDongDaShi:OnDialog_HuiLiu()
  if tbGuoQing2012:CheckIsOpen() ~= 1 then
    Dialog:Say("当前时间不在活动期间,活动日期为：2012年9月27日至10月10日。")
    return
  end
  if me.nLevel < tbGuoQing2012.LIMIT_LEVEL or me.nFaction <= 0 then
    Dialog:Say("只有50级以上并且加入门派的侠士才能参加活动。")
    return
  end
  local szMsg = "<color=pink>【活动四-好时好礼好运来】<color><enter><color=green>活动时间<color>：9月27日-10月10日<enter><enter>活动期间，各侠士可在我这里领取一份5张【欢度国庆系列】卡片及1张【欢度国庆纪念卡册】。在<color=yellow>指定日期开启<color>每张欢度国庆卡片或卡册都将获得丰厚奖励，<enter><color=green>【小提示】<color><enter>1.卡片过期后依然可以开启，不过只能得到部分奖励；<enter>2.10月9日后开启【欢度国庆纪念卡册】可获得<color=yellow>5888绑金或小游龙阁声望令牌<color>，开启即有大礼！"
  local tbOpt = {}
  if me.GetTask(tbGuoQing2012.TASK_GROUP_ID, tbGuoQing2012.TASK_HUILIU_ACCEPT) == 1 then
    table.insert(tbOpt, { "<color=gray>领取欢度国庆系列卡<color>", self.AcceptHuiLiuTask, self })
  else
    table.insert(tbOpt, { "领取欢度国庆系列卡", self.AcceptHuiLiuTask, self })
  end
  table.insert(tbOpt, { "我只是随便看看" })
  Dialog:Say(szMsg, tbOpt)
end

function tbNpcHuoDongDaShi:AcceptHuiLiuTask()
  if tbGuoQing2012:CheckIsOpen() ~= 1 then
    Dialog:Say("当前时间不在活动期间,活动日期为：2012年9月27日至10月10日。")
    return
  end
  if me.nLevel < tbGuoQing2012.LIMIT_LEVEL or me.nFaction <= 0 then
    Dialog:Say("只有50级以上并且加入门派的侠士才能参加活动。")
    return
  end
  if me.GetTask(tbGuoQing2012.TASK_GROUP_ID, tbGuoQing2012.TASK_HUILIU_ACCEPT) == 1 then
    Dialog:Say("你已经领取了欢度国庆系列卡，不可重复领取")
    return
  end
  if me.CountFreeBagCell() < 6 then
    Dialog:Say("背包空间不足，请整理出6格以上空间。")
    return
  end
  me.SetTask(tbGuoQing2012.TASK_GROUP_ID, tbGuoQing2012.TASK_HUILIU_ACCEPT, 1)
  local tbTemp = { unpack(tbGuoQing2012.ITEMID_HUANGDUGUOQING) }
  for i = 1, 5 do
    tbTemp[4] = i
    local pItem = me.AddItem(unpack(tbTemp))
    if pItem then
      pItem.Bind(3)
      me.SetItemTimeout(pItem, "2012/10/11/00/00/00")
    else
      Dbg:WriteLog("guoqing2012", "huiliu item", me.szName, string.format("%s,%s,%s,%s", unpack(tbTemp)))
    end
  end
  local pItem = me.AddItem(unpack(tbGuoQing2012.ITEMID_HUILIUAWARD_CARD))
  if pItem then
    pItem.Bind(3)
    me.SetItemTimeout(pItem, "2012/10/11/23/59/59")
  else
    Dbg:WriteLog("guoqing2012", "huiliu crad", me.szName, string.format("%s,%s,%s,%s", unpack(tbGuoQing2012.ITEMID_HUILIUAWARD_CARD)))
  end
  Dialog:Say("领取成功！<enter><enter>你获得了5张【欢度国庆】系列卡片及1张卡册，在卡片指定日期开启可获得丰厚奖励。<enter><enter>一马当先:[9月28日][绑金]<enter>两全其美:[10月1日][绑金]<enter>三星在天:[10月4日][绑金]<enter>四海升平:[10月8日][绑金]<enter>五谷丰登:[10月9日][绑金]<enter>欢度国庆纪念卡册 [10月9日-11日]<color=green>[5888绑金或小游龙阁声望令]<color>")
  StatLog:WriteStatLog("stat_info", "midautunm2012", "get_card ", me.nId, 1)
end

function tbNpcHuoDongDaShi:OnDialog_HuoDong()
  if tbGuoQing2012:CheckIsOpen() ~= 1 then
    Dialog:Say("当前时间不在活动期间,活动日期为：2012年9月27日至10月10日。")
    return
  end
  if me.nLevel < tbGuoQing2012.LIMIT_LEVEL or me.nFaction <= 0 then
    Dialog:Say("只有50级以上并且加入门派的侠士才能参加活动。")
    return
  end
  if tbGuoQing2012:CheckActivityTime() ~= 1 then
    Dialog:Say("2012年9月27日至10月10日，每天11：00-14:00、18:00-23:00才是活动时间")
    return
  end
  local szMsg = "<color=pink>【活动三-中秋国庆齐欢度】<color><enter><color=green>活动时间<color>：9月27日-10月10日每天11:00-14:00、18:00-23:00<enter><enter>我好像在哪里见过你？看你这么面善，一定能完成我托付的三件事情吧？\n"
  local nState = tbGuoQing2012:GetEventState(me)
  local tbOpt = {
    { "我随便看看" },
  }
  local nNextState = nState + 1
  local nStepInfo = tbGuoQing2012:GetEventStepInfo(me, nNextState)
  if nState == 0 then
    if nStepInfo == tbGuoQing2012.EVENT_STEP_INIT then
      szMsg = szMsg .. "<enter><color=green>【放飞吉祥喜庆灯】<color><enter>这城里没灯笼看真不好玩。你愿意帮我去某个地方挂灯笼吗？挂出不同的灯笼将会获得不同的奖励哦。<enter><color=green>【竹藤纸灯】<color><enter>奖励：玄晶、绑银<enter><color=green>【吉祥彩灯】<color><enter>奖励：玄晶、绑银、<color=yellow>葫小芦跟宠、古墓面具、酷炫坐骑<color>"
      table.insert(tbOpt, 1, { "领取竹藤纸灯", self.GetTaskItem, self, nNextState, nStepInfo, 1 })
      table.insert(tbOpt, 1, {
        string.format("<color=yellow>花费%s金币领取吉祥彩灯<color>", tbGuoQing2012.EVENT_COST_COIN_NUM[nNextState]),
        self.GetTaskItem,
        self,
        nNextState,
        nStepInfo,
        2,
      })
    elseif nStepInfo == tbGuoQing2012.EVENT_STEP_FREE then
      szMsg = szMsg .. string.format("<enter>当前步骤：放飞吉祥喜庆灯", tbGuoQing2012.EVENT_COST_COIN_NUM[nNextState])
      table.insert(tbOpt, 1, { string.format("升级灯笼（消耗%s金币）", tbGuoQing2012.EVENT_COST_COIN_NUM[nNextState]), self.LevelUpTaskItem, self, nNextState, nStepInfo })
    elseif nStepInfo == tbGuoQing2012.EVENT_STEP_COST then
      szMsg = szMsg .. "当前步骤：放飞吉祥喜庆灯"
    end
  elseif nState == 1 then
    if nStepInfo == tbGuoQing2012.EVENT_STEP_INIT then
      szMsg = szMsg .. "<enter><color=green>【点燃爱我中华心】<color><enter>我有很多漂亮的炮竹想送给你，不过想要点燃，必须要找个人帮忙哦。<enter><color=green>【小炮竹】<color><enter>奖励：玄晶、绑银<enter><color=green>【皇家礼炮】<color><enter>奖励：玄晶、绑银、<color=yellow>葫小芦跟宠、古墓面具、酷炫坐骑<color>"
      table.insert(tbOpt, 1, { "领取小炮竹", self.GetTaskItem, self, nNextState, nStepInfo, 1 })
      table.insert(tbOpt, 1, {
        string.format("<color=yellow>花费%s金币领取皇家礼炮<color>", tbGuoQing2012.EVENT_COST_COIN_NUM[nNextState]),
        self.GetTaskItem,
        self,
        nNextState,
        nStepInfo,
        2,
      })
    elseif nStepInfo == tbGuoQing2012.EVENT_STEP_FREE then
      szMsg = szMsg .. string.format("<enter>当前步骤：点燃爱我中华心", tbGuoQing2012.EVENT_COST_COIN_NUM[nNextState])
      table.insert(tbOpt, 1, { string.format("升级炮竹（消耗%s金币）", tbGuoQing2012.EVENT_COST_COIN_NUM[nNextState]), self.LevelUpTaskItem, self, nNextState, nStepInfo })
    elseif nStepInfo == tbGuoQing2012.EVENT_STEP_COST then
      szMsg = szMsg .. "当前步骤：点燃爱我中华心"
    end
  elseif nState == 2 then
    if nStepInfo == tbGuoQing2012.EVENT_STEP_INIT then
      szMsg = szMsg .. "<enter><color=green>【送出节日真挚情】<color><enter>正逢双节，想必你一定打算给好友送些礼物吧。这些月饼就送给你，可以将其送给指定的门派好友哦。<enter><color=green>【豆沙月饼】<color><enter>奖励：玄晶、绑银<enter><color=green>【水晶月饼】<color><enter>奖励：玄晶、绑银、<color=yellow>葫小芦跟宠、古墓面具、酷炫坐骑<color>"
      table.insert(tbOpt, 1, { "领取豆沙月饼", self.GetTaskItem, self, nNextState, nStepInfo, 1 })
      table.insert(tbOpt, 1, {
        string.format("<color=yellow>花费%s金币领取水晶月饼<color>", tbGuoQing2012.EVENT_COST_COIN_NUM[nNextState]),
        self.GetTaskItem,
        self,
        nNextState,
        nStepInfo,
        2,
      })
    elseif nStepInfo == tbGuoQing2012.EVENT_STEP_FREE then
      szMsg = szMsg .. string.format("<enter>当前步骤：送出节日真挚情", tbGuoQing2012.EVENT_COST_COIN_NUM[nNextState])
      table.insert(tbOpt, 1, { string.format("升级月饼（消耗%s金币）", tbGuoQing2012.EVENT_COST_COIN_NUM[nNextState]), self.LevelUpTaskItem, self, nNextState, nStepInfo })
    elseif nStepInfo == tbGuoQing2012.EVENT_STEP_COST then
      szMsg = szMsg .. "当前步骤：送出节日真挚情"
    end
  elseif nState == 3 then
    szMsg = "你已经完成了今日的任务，明天再来找我吧"
  end
  Dialog:Say(szMsg, tbOpt)
end

function tbNpcHuoDongDaShi:GetTaskItem(nCheckState, nCheckStepInfo, nType)
  if tbGuoQing2012:CheckIsOpen() ~= 1 then
    Dialog:Say("不在活动期间。")
    return
  end
  if tbGuoQing2012:CheckActivityTime() ~= 1 then
    Dialog:Say("2012年9月27日至10月10日，每天11：00-14:00、18:00-23:00才是活动时间")
    return
  end
  local nState = tbGuoQing2012:GetEventState(me)
  local nNextState = nState + 1
  local nStepInfo = tbGuoQing2012:GetEventStepInfo(me, nNextState)
  if nNextState ~= nCheckState or nStepInfo ~= nCheckStepInfo then
    return
  end
  local varItem = tbGuoQing2012.ITEMID_EVENT[nNextState][nType]
  if not varItem then
    print("guoqing2012 GetTaskItem error item")
    return
  end
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("背包空间不足，需要1格背包空间")
    return
  end

  if nType == 2 then -- 付费
    local nCoin = tbGuoQing2012.EVENT_COST_COIN_NUM[nNextState]
    if me.nCoin < nCoin then
      Dialog:Say("您的金币不足！", { { "我知道啦" } })
      return
    end
    me.ApplyAutoBuyAndUse(varItem, 1, 1)
    tbGuoQing2012:SetEventStepInfo(me, nNextState, tbGuoQing2012.EVENT_STEP_COST)
    StatLog:WriteStatLog("stat_info", "midautunm2012", "get_tool", me.nId, nNextState * 2, nCoin)
  elseif nType == 1 then
    local pItem = me.AddItem(unpack(varItem))
    if pItem then
      pItem.Bind(3)
    else
      Dbg:WriteLog("guoqin2012", "get item fail", me.szName, string.format("%s,%s,%s,%s", unpack(varItem)))
    end
    tbGuoQing2012:SetEventStepInfo(me, nNextState, tbGuoQing2012.EVENT_STEP_FREE)
    StatLog:WriteStatLog("stat_info", "midautunm2012", "get_tool", me.nId, nNextState * 2 - 1, 0)
  end
  if nNextState == 1 then
    local nRandMapIndex = MathRandom(#tbGuoQing2012.MAP_ID_USELANTERN)
    local nMapId = tbGuoQing2012.MAP_ID_USELANTERN[nRandMapIndex]
    me.SetTask(tbGuoQing2012.TASK_GROUP_ID, tbGuoQing2012.TASK_EVENT_STEP_PARAM, nMapId)
    Dialog:SendBlackBoardMsg(me, string.format("你领取到1个灯笼，请前往%s挂起灯笼。", GetMapNameFormId(nMapId)))
  elseif nNextState == 2 then
    Dialog:SendBlackBoardMsg(me, "你领取到1个烟花，请与你的好友一起点燃烟花吧")
  elseif nNextState == 3 then
    local nRand = tbGuoQing2012:GetRandFaction()
    me.SetTask(tbGuoQing2012.TASK_GROUP_ID, tbGuoQing2012.TASK_EVENT_STEP_PARAM, nRand)
    Dialog:SendBlackBoardMsg(me, string.format("你领取到1个月饼，请送给%s门派的侠士。", Player:GetFactionRouteName(nRand)))
  end
end

function tbNpcHuoDongDaShi:LevelUpTaskItem(nCheckState, nCheckStepInfo)
  if tbGuoQing2012:CheckIsOpen() ~= 1 then
    Dialog:Say("不在活动期间。")
    return
  end
  if tbGuoQing2012:CheckActivityTime() ~= 1 then
    Dialog:Say("2012年9月27日至10月10日，每天11：00-14:00、18:00-23:00才是活动时间")
    return
  end
  local nState = tbGuoQing2012:GetEventState(me)
  local nNextState = nState + 1
  local nStepInfo = tbGuoQing2012:GetEventStepInfo(me, nNextState)
  if nNextState ~= nCheckState or nStepInfo ~= nCheckStepInfo then
    return
  end
  local tbNeedItem = tbGuoQing2012.ITEMID_EVENT[nNextState][1]
  if not tbNeedItem or #tbNeedItem ~= 4 then
    print("guoqing2012 LevelUpTaskItem error item")
    return
  end
  local tbFind = me.FindItemInBags(unpack(tbNeedItem))
  if #tbFind <= 0 then
    Dialog:Say("你身上没有可以升级的道具")
    return
  end
  local nCoin = tbGuoQing2012.EVENT_COST_COIN_NUM[nNextState]
  if me.nCoin < nCoin then
    Dialog:Say("您的金币不足！", { { "我知道啦" } })
    return
  end
  if me.DelItem(tbFind[1].pItem) == 1 then
    me.ApplyAutoBuyAndUse(tbGuoQing2012.ITEMID_EVENT[nNextState][2], 1, 1)
    tbGuoQing2012:SetEventStepInfo(me, nNextState, tbGuoQing2012.EVENT_STEP_COST)
    Dialog:Say("成功升级了道具", { { "我知道啦" } })
    StatLog:WriteStatLog("stat_info", "midautunm2012", "updata_tool", me.nId, nNextState)
  end
end

local tbNpcYanHua = Npc:GetClass("guoqing2012_fireworks")

function tbNpcYanHua:OnDialog()
  if tbGuoQing2012:CheckIsOpen() ~= 1 then
    Dialog:Say("不在活动期间。")
    return
  end
  local tbFireworksInfo = him.GetTempTable("Npc").tbInfo
  if not tbFireworksInfo then
    return
  end
  if tbFireworksInfo.nIgniteFlag == 1 then
    return
  end
  local nType = 0
  for nIndex, nTemplateId in ipairs(tbGuoQing2012.NPCID_FIREWORKS) do
    if him.nTemplateId == nTemplateId then
      nType = nIndex
      break
    end
  end
  local szMsg = string.format("必须双人组队，%s秒内同时点燃", tbGuoQing2012.INTERVAL_IGNITEFIREWORKS)
  local tbOpt = {
    { "点燃炮竹", tbGuoQing2012.IgniteFireworks, tbGuoQing2012, me.nId, him.dwId, nType },
    { "我随便看看" },
  }
  Dialog:Say(szMsg, tbOpt)
end
