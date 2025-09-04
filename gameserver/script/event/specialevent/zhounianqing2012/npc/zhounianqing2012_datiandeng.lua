-- zhouchenfei
-- 2012/9/24 15:07:30
-- 大天灯脚本

Require("\\script\\event\\specialevent\\zhounianqing2012\\zhounianqing2012_public.lua")

local tbDaTianDeng = Npc:GetClass("zhounian2012_datiandeng")
local ZhouNianQing2012 = SpecialEvent.ZhouNianQing2012
tbDaTianDeng.nHongZhuTime = 3600 * 1.5
function tbDaTianDeng:OnDialog()
  local nLevelFlag, szError = ZhouNianQing2012:IsCanGetPromiseAward(me)
  if nLevelFlag == 1 then
    Dialog:Say("你还有奖励未领取，现在领取吗？", {
      { "<color=yellow>领取许愿奖励<color>", ZhouNianQing2012.OnGetPrayAward, ZhouNianQing2012 },
      { "我再考虑考虑" },
    })
    return 0
  end

  local nFlag, szError = self:IsCanPromise(me)
  if 1 ~= nFlag then
    Dialog:Say(szError)
    return 0
  end

  local szMsg = "八月秋风明月下，天池池上看天灯。"
  local tbOpt = {}
  tbOpt[#tbOpt + 1] = { "许心愿，迎吉时", self.OnPromiseWish, self }
  tbOpt[#tbOpt + 1] = { "查看放灯注意事项", self.OnAbout, self }
  tbOpt[#tbOpt + 1] = { "我再看看" }
  Dialog:Say(szMsg, tbOpt)
end

function tbDaTianDeng:IsCanPromise(pPlayer)
  local nFlag, szError = ZhouNianQing2012:IsOpenEvent()
  if 1 ~= nFlag then
    return nFlag, szError
  end

  local nDaTianDengTimeIndex = ZhouNianQing2012:GetOpenDaTianDengEventTimeIndex()
  if nDaTianDengTimeIndex == 0 then
    return 0, "现在不是大天灯活动时间，活动时间<color=yellow>10月9日至21日的13:00~14:25和20:00~21:25<color>。"
  end

  local nLevelFlag, szError = ZhouNianQing2012:IsCanJoinEvent(pPlayer)
  if 1 ~= nLevelFlag then
    return 0, szError
  end

  local tbTime = ZhouNianQing2012.tbDaTianDengEventTime[nDaTianDengTimeIndex]
  local nAlreadyTime = ZhouNianQing2012:GetLastPromiseTime(pPlayer)
  local nNowTime = GetTime()
  local nNowDay = Lib:GetLocalDay(nNowTime)
  local nLastDay = Lib:GetLocalDay(nAlreadyTime)
  if nNowDay ~= nLastDay then
    ZhouNianQing2012:SetLastPromiseIndex(pPlayer, 0)
  else
    local nLastDate = tonumber(os.date("%H%M", nAlreadyTime))
    if nLastDate >= tbTime[1] and nLastDate <= tbTime[2] then
      return 0, "这个时间段你已经许愿过了，只能许愿一次。"
    end
  end

  return 1
end

function tbDaTianDeng:OnPromiseWish()
  local nFlag, szError = self:IsCanPromise(me)
  if 1 ~= nFlag then
    Dialog:Say(szError)
    return 0
  end

  local szMsg = "天灯许愿，心诚则灵。"
  local tbOpt = {}
  for nIndex, tbInfo in pairs(ZhouNianQing2012.tbPromiseWords) do
    tbOpt[#tbOpt + 1] = { tbInfo.szDesc, self.OnSurePromise, self, nIndex }
  end
  tbOpt[#tbOpt + 1] = { "返回上一页", self.OnDialog, self }
  tbOpt[#tbOpt + 1] = { "我再看看" }
  Dialog:Say(szMsg, tbOpt)
end

function tbDaTianDeng:OnSurePromise(nIndex)
  local nFlag, szError = self:IsCanPromise(me)
  if 1 ~= nFlag then
    Dialog:Say(szError)
    return 0
  end
  local tbOnePromise = ZhouNianQing2012.tbPromiseWords[nIndex]
  if not tbOnePromise then
    Dialog:Say("没有许愿语！")
    return 0
  end

  local nDaTianDengTimeIndex = ZhouNianQing2012:GetOpenDaTianDengEventTimeIndex()
  local nNowTime = GetTime()
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("你的背包不足1格，请清理后再来！")
    return 0
  end

  local nAwardIndex = #ZhouNianQing2012.tbPromiseWords + 1

  if nDaTianDengTimeIndex > 1 then
    local nLastIndex = ZhouNianQing2012:GetLastPromiseIndex(me)
    if nLastIndex > 0 and nLastIndex == nIndex then
      nAwardIndex = nIndex
    end
  end
  ZhouNianQing2012:SetPromiseAwardIndex(me, nAwardIndex)
  ZhouNianQing2012:SetLastPromiseIndex(me, nIndex)
  ZhouNianQing2012:SetLastPromiseTime(me, nNowTime)
  ZhouNianQing2012:SetUseHongZhuCount(me, 0)
  local pItem = me.AddItem(unpack(ZhouNianQing2012.tbItem_HongZhu))
  local tbStatItem = ZhouNianQing2012.tbItem_HongZhu
  StatLog:WriteStatLog("stat_info", "sizhounian_2012", "datiandeng", me.nId)
  if pItem then
    me.SetItemTimeout(pItem, os.date("%Y/%m/%d/%H/%M/%S", nNowTime + self.nHongZhuTime))
    pItem.Bind(1)
    pItem.Sync()
  end
  Dialog:Say(string.format("许愿成功：<color=yellow>%s<color>", tbOnePromise.szDesc))
  Dbg:WriteLog("ZhouNianQing2012", "OnSurePromise", me.szName, nIndex)
  return 1
end

function tbDaTianDeng:OnAbout()
  Dialog:Say("<color=yellow>10月9日至21日<color>活动期间，<color=yellow>每日13:00~13:30和20:00~20:30<color>，诸位可在<color=yellow>临安皇宫外、凤翔府中心、汴京铁浮城大将前坪<color>，点击吉时天灯，选择合您心意的愿望。还可获得参与放飞小天灯的机会。 吉时一到，吉时天灯将不可再许愿 。  <enter><color=yellow>每日13：30、20:30后<color>，将在<color=yellow>临安、凤翔、汴京<color>全城出现一大批小天灯，<color=yellow>持续十分钟<color>，时间过后小天灯即会消失，<color=yellow>间隔五分钟<color>再次刷新。<enter>参与了吉时天灯许愿的侠客，每点燃一只小天灯即可获得一份回馈好礼。一个小时候后小天灯将不会再出现，请各位侠士不要错过。", {
    { "返回上一页", self.OnDialog, self },
    { "我再看看" },
  })
end
