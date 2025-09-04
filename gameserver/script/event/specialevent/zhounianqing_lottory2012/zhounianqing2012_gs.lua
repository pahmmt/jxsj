-- 文件名　：zhounianqing2012_gs.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-09-24 16:14:52
-- 描述：四周年庆-抽奖

if not MODULE_GAMESERVER then
  return
end

Require("\\script\\event\\specialevent\\zhounianqing_lottory2012\\zhounianqing2012_def.lua")

SpecialEvent.tbZhouNianQing2012 = SpecialEvent.tbZhouNianQing2012 or {}
local tbZhouNianQing2012 = SpecialEvent.tbZhouNianQing2012

--兑换奖券
function tbZhouNianQing2012:OnDialog()
  local szMsg = [[江湖不老，天涯常伴。10月9日至21日活动期间，诸位可通过参加击杀野外精英首领、逍遥谷、军营，四周年其他活动获得“新”、“剑”、“侠”、“世”、“界”五张字卡。领奖规则如下：
	    <color=yellow>“侠”  <color>兑换庆·侠士香囊
	    <color=yellow>“剑侠”  <color>兑换庆·剑侠礼盒
	    <color=yellow>“剑侠世界” <color>兑换庆·剑世锦盒
	    <color=yellow>“新剑侠世界” <color>兑换庆·新剑世八宝匣以及iPhone5抽奖机会
	
	<color=red>注：其中“新“字卡掉落概率极低，打开好友界面（F5）点击【好友悬赏】按钮，参与好友召回活动，轻松获得“新”字卡。
	
	兑换时间：10月11日至10月21日19点之前，每天每个玩家只能兑换一次，以19点为分隔，19点后计算入第二天兑换次数和抽奖机会。	<color>
	]]

  local tbOpt = {
    { "兑换字卡", self.ChangeCard, self },
    { "了解好友悬赏活动", self.OnInfo, self },
    { "我再看看" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbZhouNianQing2012:ChangeCard()
  local nNowDate = tonumber(GetLocalDate("%Y%m%d"))
  if nNowDate < self.nStartTime or nNowDate > self.nEndTime then
    Dialog:SendBlackBoardMsg(me, "兑换卡片时间为10月11日至10月21日。")
    return
  end
  if nNowDate >= self.nEndTime and tonumber(GetLocalDate("%H")) >= self.nChangeHour then
    Dialog:SendBlackBoardMsg(me, "兑换卡片时间为10月11日至10月21日19点。")
    return
  end

  if me.nFaction <= 0 then
    Dialog:SendBlackBoardMsg(me, "你目前尚未加入门派，武艺不精，还是等加入门派后再来把！")
    return
  end

  if me.nLevel < 30 then
    Dialog:SendBlackBoardMsg(me, "你目前等级未达到30级，不能兑换！")
    return
  end

  local nChangeDate = me.GetTask(self.nGroupId, self.nChangCardDate)
  local nNewTime = GetTime()
  local nMidTime = Lib:GetDate2Time(tonumber(os.date("%Y%m%d19", nNewTime))) --分隔时间点
  local nUseTime = nMidTime
  if nNewTime >= nMidTime then
    nUseTime = Lib:GetDate2Time(tonumber(os.date("%Y%m%d19", (nNewTime + 5 * 60 * 60))))
  end
  if nChangeDate >= nUseTime then
    local szDateInfo = os.date("%Y年%m月%d日", nUseTime)
    Dialog:SendBlackBoardMsg(me, string.format("您已经兑换过%s的字卡，请在19点后再来吧。", szDateInfo, szDateInfo))
    return
  end

  Dialog:OpenGift(
    [[请放入您要兑换的字卡，每天只能兑换一次。
“侠”:
回馈<color=yellow>庆·侠士香囊<color>。
“剑”“侠”:
回馈<color=yellow>庆·剑侠礼盒<color>。
“剑”“侠”“世”“界”:
回馈<color=yellow>庆·剑世锦盒<color>。
“新”“剑”“侠”“世”“界”:
回馈<color=yellow>庆·新剑世八宝匣<color>。
]],
    nil,
    { self.OnOpenGiftOk, self }
  )
end

function tbZhouNianQing2012:OnOpenGiftOk(tbItemObj)
  local nNowDate = tonumber(GetLocalDate("%Y%m%d"))
  if nNowDate < self.nStartTime or nNowDate > self.nEndTime then
    Dialog:SendBlackBoardMsg(me, "兑换卡片时间为10月11日至10月21日。")
    return
  end
  if nNowDate >= self.nEndTime and tonumber(GetLocalDate("%H")) >= self.nChangeHour then
    Dialog:SendBlackBoardMsg(me, "兑换卡片时间为10月11日至10月21日19点。")
    return
  end
  if Lib:CountTB(tbItemObj) <= 0 then
    Dialog:SendBlackBoardMsg(me, "请放入您要兑换的字卡。")
    return 0
  end
  local tbHandOnList = {}
  for _, pItem in ipairs(tbItemObj) do
    if self.tbCardGDP[1] == pItem[1].nGenre and self.tbCardGDP[2] == pItem[1].nDetail and self.tbCardGDP[3] == pItem[1].nParticular then
      if not tbHandOnList[pItem[1].nLevel] then
        tbHandOnList[pItem[1].nLevel] = 1
      end
    end
  end
  local nChangeLevel = 0
  for i, tb in ipairs(self.tbDuihuanList) do
    local nIsFinish = 1
    for _, nCard in ipairs(tb) do
      if not tbHandOnList[nCard] then
        nIsFinish = 0
        break
      end
    end
    if nIsFinish == 1 then
      nChangeLevel = i
    end
  end

  if nChangeLevel <= 0 then
    Dialog:SendBlackBoardMsg(me, "您上交的字卡不符合兑换规则。")
    return
  end
  local nChangeDate = me.GetTask(self.nGroupId, self.nChangCardDate)
  local nNewTime = GetTime()
  local nMidTime = Lib:GetDate2Time(tonumber(os.date("%Y%m%d19", nNewTime))) --分隔时间点
  local nUseTime = nMidTime
  if nNewTime >= nMidTime then
    nUseTime = Lib:GetDate2Time(tonumber(os.date("%Y%m%d19", (nNewTime + 5 * 60 * 60))))
  end
  local szDateInfo = os.date("%Y年%m月%d日", nUseTime)
  if nChangeDate >= nUseTime then
    Dialog:SendBlackBoardMsg(me, string.format("您已经兑换过%s的字卡了，请在%s19点后再来吧。", szDateInfo, szDateInfo))
    return
  end

  if me.CountFreeBagCell() < 1 then
    Dialog:SendBlackBoardMsg(me, "您的背包空间不足1格，请整理下再来吧。")
    return
  end

  local tbHangonItem = self.tbDuihuanList[nChangeLevel]
  for _, nCardLevel in ipairs(tbHangonItem) do
    for _, pItem in pairs(tbItemObj) do
      if self.tbCardGDP[1] == pItem[1].nGenre and self.tbCardGDP[2] == pItem[1].nDetail and self.tbCardGDP[3] == pItem[1].nParticular and nCardLevel == pItem[1].nLevel then
        if pItem[1].nCount > 1 then
          pItem[1].SetCount(pItem[1].nCount - 1)
        else
          pItem[1].Delete(me)
        end
        break
      end
    end
  end

  local pItem = me.AddItemEx(self.tbAwardBoxGDP[1], self.tbAwardBoxGDP[2], self.tbAwardBoxGDP[3], nChangeLevel)
  if pItem then
    local szMsg = string.format("恭喜您成功兑换一个：%s", pItem.szName)
    Dialog:SendBlackBoardMsg(me, szMsg)
    me.SetTask(self.nGroupId, self.nChangCardDate, nUseTime)
    if nChangeLevel == #self.tbDuihuanList then --5个字的兑换
      GCExcute({ "SpecialEvent.tbZhouNianQing2012:WriteUseCard", me.szAccount, me.szName })
      me.Msg(string.format("恭喜你获得了%s抽取iphone5的抽奖机会！将会在%s晚上21点进行抽奖并公布结果!", szDateInfo, szDateInfo))
    end
    StatLog:WriteStatLog("stat_info", "sizhounian_2012", "jizika_duihuan", me.nId, nChangeLevel)
    Dbg:WriteLog("Zhounianqing2012", "ChangeCard", "兑换卡片", me.szAccount, me.szName, nChangeLevel, nNowDate)
  end
end

------------------------------------------------------------------------------------------------------------------------------------------------
--回归玩家获取字卡
------------------------------------------------------------------------------------------------------------------------------------------------
--获得回归礼包奖励
function tbZhouNianQing2012:OnBackGetAward()
  local tbOpt = {
    { "激活资格", self.OnBackActive, self },
    { "领取“新”字卡", self.OnBackGetAwardEx, self },
    { "了解好友悬赏活动", self.OnInfo, self },
    { "我再想想" },
  }
  Dialog:Say("如果您是邀请回归的老玩家，可以来我这里领取邀请“新”字卡，快来参加好友悬赏活动吧。\n<color=red>网站成功邀请老玩家后，需等待一个小时，才能领取到邀请老玩家奖励。<color>", tbOpt)
end

function tbZhouNianQing2012:OnBackActive(nCallBack)
  local nExtPoint = me.GetExtPoint(self.EXT_POINT)
  local nFlag = math.floor(nExtPoint / 10000000)
  local nFlag = math.fmod(nFlag, 10)
  if nFlag ~= 1 then
    Dialog:SendBlackBoardMsg(me, "您没有被邀请无法激活“新”字卡领取资格。")
    return
  end
  local nPlayerActiveFlag = me.GetTask(self.nGroupId, self.nPlayerBackActiveFlag)
  if nPlayerActiveFlag == 1 then
    Dialog:SendBlackBoardMsg(me, "您的角色已经激活过了。")
    return
  end
  local nActiveFlag = Account:GetIntValue(me.szAccount, "Account.IniviteFlag")
  local bActiveInivited = math.fmod(nActiveFlag, 10)
  if bActiveInivited == 1 then
    Dialog:SendBlackBoardMsg(me, "每个账号只能激活一个角色。")
    return
  end
  if not nCallBack then
    Dialog:Say("每个账号只能激活一个角色，您确认是否要激活领取“新”字卡资格？", { { "确认激活", self.OnBackActive, self, 1 }, { "我再想想" } })
    return
  end
  Account:ApplySetIntValue(me.szAccount, "Account.IniviteFlag", nActiveFlag + 1, 0)
  me.SetTask(self.nGroupId, self.nPlayerBackActiveFlag, 1)
  Dialog:SendBlackBoardMsg(me, "恭喜您成功激活“新”字卡领取资格。")
  me.Msg("恭喜您成功激活“新”字卡领取资格。")
  Dbg:WriteLog("Zhounianqing2012", "PlayerBackActive", "回归玩家激活", me.szAccount, me.szName)
end

function tbZhouNianQing2012:OnBackGetAwardEx()
  local nExtPoint = me.GetExtPoint(self.EXT_POINT)
  local nFlag = math.floor(nExtPoint / 10000000)
  local nFlag = math.fmod(nFlag, 10)
  if nFlag ~= 1 then
    Dialog:SendBlackBoardMsg(me, "您没有被邀请无法获得“新”字卡奖励。")
    return
  end
  local nActiveFlag = me.GetTask(self.nGroupId, self.nPlayerBackActiveFlag)
  if nActiveFlag ~= 1 then
    Dialog:SendBlackBoardMsg(me, "您还没有激活领取“新”字卡资格。")
    return
  end
  local nGetFlag = me.GetTask(self.nGroupId, self.nPlayerBackGetCardFlag)
  if nGetFlag == 1 then
    Dialog:SendBlackBoardMsg(me, "您已经领取过“新”字卡了。")
    return
  end
  if me.CountFreeBagCell() < 1 then
    Dialog:SendBlackBoardMsg(me, "您的背包空间不足1格，请整理下再来吧。")
    return
  end
  local pItem = me.AddItemEx(self.tbCardGDP[1], self.tbCardGDP[2], self.tbCardGDP[3], 1)
  if pItem then
    Dialog:SendBlackBoardMsg(me, "恭喜您获得“新”字卡，您可参加四周年庆集齐字卡赢取iPhone5大奖。")
    me.SetTask(self.nGroupId, self.nPlayerBackGetCardFlag, 1)
    StatLog:WriteStatLog("stat_info", "sizhounian_2012", "jizika_get", me.nId, 11)
    Dbg:WriteLog("Zhounianqing2012", "PlayerBackGetCard", "回归玩家获得卡牌", me.szAccount, me.szName)
  end
end

function tbZhouNianQing2012:OnInfo()
  me.CallClientScript({ "OpenWebSite", self.SZ_INIVITE_URL })
end

------------------------------------------------------------------------------------------------------------------------------------------------
--邀请玩家获得礼包和字卡
------------------------------------------------------------------------------------------------------------------------------------------------

--获得回归礼包奖励
function tbZhouNianQing2012:OnIniviteAward()
  local tbOpt = {
    { "领取奖励", self.OnGetIniviteAward, self },
    { "了解好友悬赏活动", self.OnInfo, self },
    { "我再想想" },
  }
  Dialog:Say("参加好友悬赏活动，可以在我这里领取好友悬赏令大礼，快快行动吧。", tbOpt)
end

function tbZhouNianQing2012:OnGetIniviteAward()
  --Gc做玩家邀请个数的校验
  GCExcute({ "SpecialEvent.tbZhouNianQing2012:OnIniviteAward", me.szAccount, me.szName })
end

--领取失败提示
function tbZhouNianQing2012:OnIniviteAwardFailed(szAccount, szPlayerName, nType)
  local pPlayer = KPlayer.GetPlayerByName(szPlayerName)
  if pPlayer then
    local szMsg = "您并没有邀请老玩家回归，您可以参加好友悬赏令获得领取资格。"
    if nType then
      szMsg = "您没有可以领取的邀请奖励了。"
    end
    Dialog:SendBlackBoardMsg(pPlayer, szMsg)
  end
end

--获得邀请奖励
function tbZhouNianQing2012:OnIniviteAwardEx(szAccount, szPlayerName, nIniviteEx)
  local pPlayer = KPlayer.GetPlayerByName(szPlayerName)
  if pPlayer then
    local nActiveFlag = Account:GetIntValue(szAccount, "Account.IniviteFlag")
    local nIniviteCount = math.floor(nActiveFlag / 10)
    if nIniviteEx <= 0 then
      Dialog:SendBlackBoardMsg(pPlayer, "您并没有邀请老玩家回归，您可以参加好友悬赏令获得领取资格。")
      return
    end
    if nIniviteEx <= nIniviteCount then
      Dialog:SendBlackBoardMsg(pPlayer, "您没有可以领取的邀请奖励了。")
      return
    end
    if pPlayer.CountFreeBagCell() < 2 then
      Dialog:SendBlackBoardMsg(pPlayer, "您的背包空间不足2格，请整理下再来吧。")
      return
    end
    pPlayer.AddItemEx(self.tbCardGDP[1], self.tbCardGDP[2], self.tbCardGDP[3], 1)

    if nIniviteCount < 10 then
      local nBoxLevel = 1
      if nIniviteCount >= 3 then
        nBoxLevel = 2
      end
      pPlayer.AddItemEx(self.tbIniviteBox[1], self.tbIniviteBox[2], self.tbIniviteBox[3], nBoxLevel)
      StatLog:WriteStatLog("stat_info", "sizhounian_2012", "libao_get", pPlayer.nId, string.format("%s_%s_%s_%s", self.tbIniviteBox[1], self.tbIniviteBox[2], self.tbIniviteBox[3], nBoxLevel))
    end
    Account:ApplySetIntValue(szAccount, "Account.IniviteFlag", nActiveFlag + 10, 0)
    pPlayer.Msg("恭喜您获得好友悬赏令邀请大礼。")
    Dialog:SendBlackBoardMsg(pPlayer, "恭喜您获得好友悬赏令邀请大礼。")
    StatLog:WriteStatLog("stat_info", "sizhounian_2012", "jizika_get", pPlayer.nId, 10)
    Dbg:WriteLog("Zhounianqing2012", "PlayerIniviteGetAward", "邀请玩家获得奖励", szAccount, szPlayerName, nIniviteCount)
  end
end

--加声望牌子
function tbZhouNianQing2012:AddAward(nPlayerId, nItemId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return
  end
  pPlayer.AddWaitGetItemNum(-1)
  local pItem = KItem.GetObjById(nItemId)
  if not pItem then
    return
  end
  local nIndex = MathRandom(#self.tbHonor)
  local pItemEx = pPlayer.AddItem(unpack(self.tbHonor[nIndex][1]))
  if pItemEx then
    pItemEx.Bind(1)
    local szMsg = string.format("%s打开%s获得一个%s,真是鸿运当头呀！", pPlayer.szName, pItem.szName, self.tbHonor[nIndex][2])
    StatLog:WriteStatLog("stat_info", "sizhounian_2012", "kaiqi_xiangzi", pPlayer.nId, pItem.nLevel, string.format("%s_%s_%s_%s", unpack(self.tbHonor[nIndex][1])), 1)
    KDialog.NewsMsg(1, Env.NEWSMSG_NORMAL, szMsg)
    if pPlayer.dwTongId and pPlayer.dwTongId > 0 then
      Player:SendMsgToKinOrTong(pPlayer, szMsg, 1)
    else
      Player:SendMsgToKinOrTong(pPlayer, szMsg, 0)
    end
    pItem.Delete(pPlayer)
  end
  return
end

--random
function tbZhouNianQing2012:AddRandomItem(nPlayerId, nItemId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return
  end
  pPlayer.AddWaitGetItemNum(-1)
  local pItem = KItem.GetObjById(nItemId)
  if not pItem then
    return
  end
  local nValue = tbZhouNianQing2012.tbValue[pItem.nLevel] or tbZhouNianQing2012.tbValue[1]
  local nOpenDay = math.floor((GetTime() - KGblTask.SCGetDbTaskInt(DBTASD_SERVER_STARTTIME)) / (60 * 60 * 24))
  local tbAward = Lib._CalcAward:RandomAward(3, 3, 2, nValue, Lib:_GetXuanReduce(nOpenDay), { 8, 2, 0 })
  tbZhouNianQing2012:RandomAward(pPlayer, tbAward, pItem.nLevel)
  pItem.Delete(pPlayer)
  return
end

function tbZhouNianQing2012:RandomAward(pPlayer, tbAward, nType)
  local nRate = MathRandom(1000000)
  local nAdd = 0
  local nFind = 0
  for i, tbInfo in ipairs(tbAward) do
    nAdd = nAdd + tbInfo[3]
    if nRate <= nAdd then
      nFind = i
      break
    end
  end
  if nFind > 0 then
    local tbFind = tbAward[nFind]
    if tbFind[1] == "玄晶" then
      pPlayer.AddItemEx(18, 1, 114, tbFind[2])
      StatLog:WriteStatLog("stat_info", "sizhounian_2012", "kaiqi_xiangzi", pPlayer.nId, nType, string.format("%s_%s_%s_%s", 18, 1, 114, tbFind[2]), 1)
    elseif tbFind[1] == "绑金" then
      pPlayer.AddBindCoin(tbFind[2])
      StatLog:WriteStatLog("stat_info", "sizhounian_2012", "kaiqi_xiangzi", pPlayer.nId, nType, "BindCoin", tbFind[2])
    elseif tbFind[1] == "绑银" then
      pPlayer.AddBindMoney(tbFind[2])
      StatLog:WriteStatLog("stat_info", "sizhounian_2012", "kaiqi_xiangzi", pPlayer.nId, nType, "BindMoney", tbFind[2])
    end
  end
  return 1
end

function tbZhouNianQing2012:Msg2World2GS(nType, szGateWay, szPlayerName, nCountAward, bTimer)
  local nNowTime = tonumber(GetLocalDate("%Y%m%d"))
  if nNowTime > self.nEndTime or nNowTime < self.nStartTime then
    return
  end
  local tbMsg = {
    "<bclr=Fire><color=white>老友悬赏令集字卡<color=yellow>赢iPhone5抽奖活动<color>今日中奖名单已经产生，稍后每隔一段时间我们会公布一批获奖名单，参与的玩家越多我们送出的奖励越多，请持续关注。<color><bclr>",
    "<bclr=Fire><color=white>今天<color=yellow>第%s位<color>获得iPhone5大奖的玩家是：<color=yellow>【%s】<color>的<color=yellow>%s<color><color><bclr>",
    "<bclr=Fire><color=white>老友悬赏令集字卡<color=yellow>赢iPhone5抽奖活动<color>中奖名单已经公布完毕，集字卡就有机会赢取iPhone5大奖，参与的玩家越多我们送出的奖励越多，赶紧来参加吧。<color><bclr>",
    "<bclr=Fire><color=white>很遗憾，今天并没有玩家赢取到iPhone5大奖，大家赶紧集字卡才有更多机会，参与的玩家越多我们送出的奖励越多。<color><bclr>",
    "<bclr=Fire><color=white>【<color=yellow>老友悬赏令集字卡赢iPhone5<color>】抽奖将于<color=yellow>%s分钟<color>后开启，参与的玩家越多我们送出的奖励越多，祝您好运！<color><bclr>",
    "<bclr=Fire><color=white>恭喜<color=yellow>%s<color>在老友悬赏令集字卡活动中获得iPhone5大奖，大家赶紧来参加活动，参与的玩家越多我们送出的奖励越多！<color><bclr>",
  }
  if not tbMsg[nType] then
    return 0
  end
  if nType == 2 and (not szGateWay or not szPlayerName or not nCountAward) then
    return 0
  end
  local szMsg = string.format(tbMsg[nType], nCountAward, ServerEvent:GetServerNameByGateway(szGateWay), szPlayerName)
  if GetServerId() == 1 then
    KDialog.NewsMsg(1, 3, szMsg)
  end
  KDialog.Msg2SubWorld(szMsg)
  if nType == 2 and not bTimer then
    self.nMsg2SubWorld_GS = 1
    Timer:Register(self.nMsgTime2World / 6, self.Msg2World2GS, self, nType, szGateWay, szPlayerName, nCountAward, 1)
  elseif nType == 2 and bTimer then
    self.nMsg2SubWorld_GS = self.nMsg2SubWorld_GS + 1
    if self.nMsg2SubWorld_GS >= 5 then
      return 0
    end
  end
  return
end

--登陆事件，做提醒邀请
function tbZhouNianQing2012:PlayerLogIn()
  if tonumber(GetLocalDate("%Y%m%d")) > self.nEndTime then
    return
  end
  local nMsgTime = me.GetTask(self.nGroupId, self.nMsgTime)
  local nNowTime = tonumber(GetLocalDate("%y%m%d%H"))
  if nNowTime ~= nMsgTime then
    local nAccountFlag = Account:GetIntValue(me.szAccount, "Account.IniviteFlag")
    local nIniviteCount = math.floor(nAccountFlag / 10)
    GCExcute({ "SpecialEvent.tbZhouNianQing2012:CheckIniviteAward", me.szAccount, me.szName, nIniviteCount })
    me.SetTask(self.nGroupId, self.nMsgTime, nNowTime)
  end

  local nMsgFlag = me.GetTask(self.nGroupId, self.nPlayerBackGetAwardFlag)
  if nMsgFlag == 1 then
    return
  end

  local nExtPoint = me.GetExtPoint(self.EXT_POINT)
  local nFlag = math.floor(nExtPoint / 10000000)
  local nFlag = math.fmod(nFlag, 10)
  if nFlag ~= 1 then
    return
  end
  local nActiveFlag = Account:GetIntValue(me.szAccount, "Account.IniviteFlag")
  local bActiveInivited = math.fmod(nActiveFlag, 10)
  if bActiveInivited == 1 then
    return
  end
  local nGetAward = me.GetTask(self.nGroupId, self.nPlayerBackActiveFlag)
  if nGetAward == 1 then
    return
  end
  KPlayer.SendMail(me.szName, "老友回归送大礼", "旧友不离，江湖未老。欢迎侠士回归剑侠世界，您现在可从礼官处，领取一张“新”字卡。集齐“新剑侠世界”五张字卡，会获得庆·新剑世八宝匣和赢取iphone5等大奖的机会，参加游戏内四周年活动即可轻松获得其他字卡。")
  me.SetTask(self.nGroupId, self.nPlayerBackGetAwardFlag, 1)
end

--PlayerEvent:RegisterGlobal("OnLogin", SpecialEvent.tbZhouNianQing2012.PlayerLogIn, SpecialEvent.tbZhouNianQing2012);
