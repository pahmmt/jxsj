-- zhouchenfei
-- 2012/9/24 17:16:10
-- npc

Require("\\script\\event\\specialevent\\zhounianqing2012\\zhounianqing2012_public.lua")

local ZhouNianQing2012 = SpecialEvent.ZhouNianQing2012

ZhouNianQing2012.tbPromiseWords = {
  [1] = {
    szDesc = "愿得一人心，白首不相离",
    nRandomId = 364,
  },
  [2] = {
    szDesc = "愿得大黄金，所向皆披靡",
    nRandomId = 0,
  },
  [3] = {
    szDesc = "愿得万贯财，其他是浮云",
    nRandomId = 365,
  },
  [4] = {
    szDesc = "愿得犀利法，脸滚键盘赢",
    nRandomId = 366,
  },
  [5] = {
    szDesc = "愿得逍遥游，走马过千山",
    nRandomId = 367,
  },
}
ZhouNianQing2012.nTime_HeHuanBi = 3600 * 24 * 7
ZhouNianQing2012.nTime_MeiGuiHua = 3600 * 24 * 7

function ZhouNianQing2012:OnDialog()
  local szMsg = "与诸位相逢已四载，其中共历多少恩怨情仇，又有多少日夜把酒言欢。江湖儿女，不屑惺惺作态，今日便在此谢予诸位！长歌一曲，不离不弃！"
  local nFlag, szError = self:IsOpenEvent()
  if 1 ~= nFlag then
    Dialog:Say(szError)
    return 0
  end

  local tbOpt = {}
  tbOpt[#tbOpt + 1] = { "集字卡赢iphone5", self.OnZiKaDialog, self }
  tbOpt[#tbOpt + 1] = { "红包赠侠客", self.GiveHongbao, self }
  tbOpt[#tbOpt + 1] = { "烟花庆周年", self.GiveYanhua, self }
  tbOpt[#tbOpt + 1] = { "天灯许心愿", self.PrayTiandengMsg, self }
  tbOpt[#tbOpt + 1] = { "领取双人合璧奖励", self.GetDoubleBiAward, self }
  tbOpt[#tbOpt + 1] = { "我再看看" }
  Dialog:Say(szMsg, tbOpt)
end

function ZhouNianQing2012:OnZiKaDialog()
  return SpecialEvent.tbZhouNianQing2012:OnDialog()
end

-- 红包
function ZhouNianQing2012:GiveHongbao()
  local nFlag, szError = self:IsOpenEvent()
  if 1 ~= nFlag then
    Dialog:Say(szError)
    return 0
  end

  local szMsg = "相识皆缘，此回只想答谢各位，四载情谊，礼轻情重。<enter><color=yellow>10月9日至21日<color>活动期间，每位侠客<color=yellow>每日<color>均可在我这领取答谢红包<color=yellow>1枚<color>，诸位勿要错过。"
  local tbOpt = {}
  tbOpt[#tbOpt + 1] = { "领取答谢红包", self.OnSureGetHongbao, self }
  tbOpt[#tbOpt + 1] = { "返回上一页", self.OnDialog, self }
  tbOpt[#tbOpt + 1] = { "我再看看" }
  Dialog:Say(szMsg, tbOpt)
end

function ZhouNianQing2012:OnSureGetHongbao()
  local nLevelFlag, szError = self:IsCanJoinEvent(me)
  if 1 ~= nLevelFlag then
    Dialog:Say(szError)
    return 0
  end

  local nLastTime = self:GetHongBaoTime(me)
  local nNowTime = GetTime()
  local nLastDate = tonumber(os.date("%Y%m%d", nLastTime))
  local nNowDate = tonumber(os.date("%Y%m%d", nNowTime))
  if nLastDate == nNowDate then
    Dialog:Say("您今天已经领取过红包了，请明天再来！")
    return 0
  end

  if me.CountFreeBagCell() < 1 then
    Dialog:Say("包裹空间不足1格，请整理下！")
    return 0
  end

  self:SetHongBaoTime(me, nNowTime)
  local pItem = me.AddItem(unpack(self.tbDaHongBao))
  if not pItem then
    Dbg:WriteLog("ZhouNianQing2012", "OnSureGetHongbao", me.szName, "获得大红包失败")
    return 0
  end

  pItem.Bind(1)
  me.SetItemTimeout(pItem, os.date("%Y/%m/%d/00/00/00", GetTime() + 3600 * 24 * 7)) -- 领取当天有效
  pItem.Sync()
  Dbg:WriteLog("ZhouNianQing2012", "OnSureGetHongbao", me.szName, "获得大红包成功")
  self:ChangeRandomFeature(me)
  local nRand = MathRandom(1, #self.tbHongBaoMsg)
  me.GetNpc().SendChat(self.tbHongBaoMsg[nRand])
end

-- 烟花周年庆
function ZhouNianQing2012:GiveYanhua()
  local nFlag, szError = self:IsOpenEvent()
  if 1 ~= nFlag then
    Dialog:Say(szError)
    return 0
  end

  local szMsg = "若说庆贺，怎能少了烟花，小女子特从蜀地购置各类烟花。诸位侠士见多识广，还望能入诸位法眼。<enter><color=yellow>10月9日至21日<color>活动期间，每日每位侠客均可在我这领取欢庆烟花一支。点燃后，定为诸位奉上一份好礼。<enter>烟花一路颠簸至此地，难免效用受些影响，诸位莫要将之留到明日。"
  local tbOpt = {}
  tbOpt[#tbOpt + 1] = { "领取欢庆烟花", self.OnSureGetYanhua, self }
  tbOpt[#tbOpt + 1] = { "返回上一页", self.OnDialog, self }
  tbOpt[#tbOpt + 1] = { "我再看看" }
  Dialog:Say(szMsg, tbOpt)
end

function ZhouNianQing2012:OnSureGetYanhua()
  local nLevelFlag, szError = self:IsCanJoinEvent(me)
  if 1 ~= nLevelFlag then
    Dialog:Say(szError)
    return 0
  end

  local nGetTime = self:GetYanHuaGetTime(me)
  local nNowTime = GetTime()
  local nNowDay = Lib:GetLocalDay(nNowTime)
  local nLastGetDay = Lib:GetLocalDay(nGetTime)
  if nLastGetDay >= nNowDay then
    Dialog:Say("今天你已经领取过烟花了！")
    return 0
  end

  if me.CountFreeBagCell() < 1 then
    Dialog:Say("包裹空间不足1格，请整理下！")
    return 0
  end

  self:SetYanHuaGetTime(me, nNowTime)
  local pItem = me.AddItem(unpack(self.tbItem_YanHua))
  if not pItem then
    Dbg:WriteLog("OnSureGetYanhua", me.szName, "获得烟花失败")
    return 0
  end
  StatLog:WriteStatLog("stat_info", "sizhounian_2012", "yanhuo_lingqu", me.nId)
  pItem.Bind(1)
  me.SetItemTimeout(pItem, os.date("%Y/%m/%d/00/00/00", nNowTime + 3600 * 24)) -- 领取当天有效
  pItem.Sync()
  self:SetUseYanHuaCount(me, 0)
  Dialog:Say("恭喜你获得了周年庆烟花！")
  return 1
end

-- 天灯许愿
function ZhouNianQing2012:PrayTiandengMsg()
  local szMsg = "天灯许心愿，自古以来已成习俗。近来小女均会遣人在临安、汴京、凤翔添置天灯，诸位如有兴趣，可前往参加。 <enter><color=yellow>10月9日至21日<color>活动期间，<color=yellow>每日13:00~13:30和20:00~20:30<color>，诸位可在<color=yellow>临安皇宫外、凤翔府中心、汴京铁浮城大将前坪<color>，点击吉时天灯，选择合您心意的愿望。还可获得<color=yellow>【红喜蜡烛】<color>，放飞小天灯。 吉时一到，吉时天灯将不可再许愿 。  <enter><color=yellow>每日13：30、20:30<color>后，将在<color=yellow>临安、凤翔、汴京全城<color>刷新一大批<color=yellow>小天灯<color>，小天灯存在时间为十分钟，每隔十五分钟刷新一次。拥有<color=yellow>【红喜蜡烛】<color>的侠客，可用之点燃小天灯，获得回馈好礼。一个小时候后小天灯将不会再出现，请各位侠士不要错过。"
  local tbOpt = {}
  local nLevelFlag = self:IsCanGetPromiseAward(me)
  if 1 == nLevelFlag then
    tbOpt[#tbOpt + 1] = { "<color=yellow>领取心愿红包<color>", self.OnGetPrayAward, self }
  end
  tbOpt[#tbOpt + 1] = { "返回上一页", self.OnDialog, self }
  tbOpt[#tbOpt + 1] = { "我再看看" }
  Dialog:Say(szMsg, tbOpt)
end

ZhouNianQing2012.tbNormalAward = { 18, 1, 1832, 1 }

function ZhouNianQing2012:IsCanGetPromiseAward(pPlayer)
  local nLevelFlag, szError = self:IsCanJoinEvent(pPlayer)
  if 1 ~= nLevelFlag then
    return 0, szError
  end

  local nAwardIndex = self:GetPromiseAwardIndex(pPlayer)
  if nAwardIndex <= 0 then
    return 0, "没有奖励可以领取！"
  end

  local nAlreadyTime = ZhouNianQing2012:GetLastPromiseTime(pPlayer)
  local nNowTime = GetTime()
  local nNowDay = Lib:GetLocalDay(nNowTime)
  local nLastDay = Lib:GetLocalDay(nAlreadyTime)
  if nLastDay <= 0 or nNowDay == nLastDay then
    return 0, "你没有许愿奖励可以领取！"
  end
  return 1
end

function ZhouNianQing2012:OnGetPrayAward()
  local nLevelFlag, szError = self:IsCanGetPromiseAward(me)
  if 1 ~= nLevelFlag then
    Dialog:Say(szError)
    return 0
  end

  local nAwardIndex = self:GetPromiseAwardIndex(me)

  if me.CountFreeBagCell() < 1 then
    Dialog:Say("包裹空间不足1格，请整理下！")
    return 0
  end

  local tbItem = self.tbNormalAward

  self:SetLastPromiseIndex(me, 0)
  self:SetPromiseAwardIndex(me, 0)
  StatLog:WriteStatLog("stat_info", "sizhounian_2012", "lingqu_datiandeng", me.nId)
  local pItem = me.AddItem(unpack(tbItem))
  if not pItem then
    Dbg:WriteLog("ZhouNianQing2012", "OnGetPrayAward", me.szName, "获得心愿礼包失败")
    return 0
  end
  pItem.Bind(1)
  pItem.SetGenInfo(1, nAwardIndex)
  me.SetItemTimeout(pItem, os.date("%Y/%m/%d/00/00/00", GetTime() + 3600 * 24 * 30))
  pItem.Sync()
  Dialog:Say("恭喜领取许愿奖励！")
  Dbg:WriteLog("ZhouNianQing2012", "OnGetPrayAward", me.szName, "获得心愿礼包成功")
  return 1
end

function ZhouNianQing2012:GetDoubleBiAward()
  local nFlag, szError = self:IsOpenEvent()
  if 1 ~= nFlag then
    Dialog:Say(szError)
    return 0
  end

  local szMsg = "各位侠士参加放飞小天灯的活动【详见{天灯许心愿}】，可获得<color=yellow>【同庆·合】<color>和<color=yellow>【同庆·欢】<color>其中任一玉璧，与拥有不同玉璧的侠士组队，即可从我这领取丰厚奖励。"
  local tbOpt = {}
  tbOpt[#tbOpt + 1] = { "<color=yellow>确定领取<color>", self.OnSureGetDoubleBi, self }
  tbOpt[#tbOpt + 1] = { "返回上一页", self.OnDialog, self }
  tbOpt[#tbOpt + 1] = { "我再看看" }
  Dialog:Say(szMsg, tbOpt)
end

function ZhouNianQing2012:OnSureGetDoubleBi()
  local nLevelFlag, szError = self:IsCanJoinEvent(me)
  if 1 ~= nLevelFlag then
    Dialog:Say(szError)
    return 0
  end

  local nFlag, szErrorMsg = self:IsCanFinishDoubleBi(me)
  if 1 ~= nFlag then
    Dialog:Say(szErrorMsg)
    return 0
  end
  local tbTeamMemberList = KTeam.GetTeamMemberList(me.nTeamId)
  local tbRemoveItem = {}
  local nDoubleBi = 0
  for _, nPlayerId in pairs(tbTeamMemberList) do
    local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
    if not pPlayer then
      return 0, "您的所有队友必须在这附近。"
    end
    local nIsDoubleBi = self:IsHaveDoubleBi(pPlayer)
    if 0 == nIsDoubleBi then
      return 0
    end
    if nDoubleBi == nIsDoubleBi then
      return 0
    end
    tbRemoveItem[#tbRemoveItem + 1] = { nPlayerId, nIsDoubleBi }
    nDoubleBi = nIsDoubleBi
  end
  if #tbRemoveItem ~= 2 then
    return 0
  end

  local nNowTime = GetTime()
  for _, tbInfo in pairs(tbRemoveItem) do
    local pPlayer = KPlayer.GetPlayerObjById(tbInfo[1])
    if pPlayer then
      local tbItem = self.tbDoubleBi[tbInfo[2]]
      local tbResult = pPlayer.FindItemInBags(unpack(tbItem))
      for _, tbOneItem in pairs(tbResult) do
        pPlayer.DelItem(tbOneItem.pItem)
      end
      local nUseCount = self:GetHeBiCount(pPlayer)
      self:SetHeBiCount(pPlayer, nUseCount + 1)
      local pItem = pPlayer.AddItem(unpack(self.tbFinalBi))
      if not pItem then
        Dbg:WriteLog("OnSureGetDoubleBi", pPlayer.szName, "获得完整玉璧失败")
      else
        pItem.Bind(1)
        pPlayer.SetItemTimeout(pItem, os.date("%Y/%m/%d/00/00/00", nNowTime + self.nTime_HeHuanBi)) -- 领取当天有效
        pItem.Sync()
        Dbg:WriteLog("OnSureGetDoubleBi", pPlayer.szName, "获得完整玉璧成功")
      end
      StatLog:WriteStatLog("stat_info", "sizhounian_2012", "shuangrenhebi", pPlayer.nId, string.format("%s_%s_%s_%s,%s", self.tbFinalBi[1], self.tbFinalBi[2], self.tbFinalBi[3], self.tbFinalBi[4], 1))
      self:AddZiKa_HeBiEvent(pPlayer)
      --			local pMeiItem = pPlayer.AddItem(unpack(self.tbMeiGuiHua));
      --			if (pMeiItem) then
      --				pMeiItem.Bind(1);
      --				pPlayer.SetItemTimeout(pMeiItem, os.date("%Y/%m/%d/00/00/00", nNowTime + self.nTime_MeiGuiHua)); -- 领取当天有效
      --				pMeiItem.Sync();
      --			end
    end
  end

  return 0
end

function ZhouNianQing2012:IsCanFinishDoubleBi(pMyPlayer)
  local tbTeamMemberList = KTeam.GetTeamMemberList(pMyPlayer.nTeamId)
  if not tbTeamMemberList then
    return 0, "必须组队才能领取奖励！"
  end

  if #tbTeamMemberList ~= 2 then
    return 0, "队伍中需两人才能领取。"
  end
  local nNowTime = GetTime()
  local nDoubleBi = 0
  local nMapId, nPosX, nPosY = pMyPlayer.GetWorldPos()
  for _, nPlayerId in pairs(tbTeamMemberList) do
    local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
    if not pPlayer then
      return 0, "您的所有队友必须在这附近。"
    end

    local nHeBiCount = self:GetHeBiCount(pPlayer)
    if nHeBiCount >= self.MAX_HEBI_COUNT then
      return 0, string.format("<color=yellow>%s<color>今天的合璧次数用完了，不能合璧！", pPlayer.szName)
    end

    local nMapId2, nPosX2, nPosY2 = pPlayer.GetWorldPos()
    local nDisSquare = (nPosX - nPosX2) ^ 2 + (nPosY - nPosY2) ^ 2
    if nMapId2 ~= nMapId or nDisSquare > 400 then
      return 0, "您的所有队友必须在这附近。"
    end
    if not pPlayer or pPlayer.nMapId ~= nMapId then
      return 0, "您的所有队友必须在这附近。"
    end
    local nIsDoubleBi = self:IsHaveDoubleBi(pPlayer)
    if 0 == nIsDoubleBi then
      return 0, string.format("您队伍中<color=yellow>%s<color>没有【同庆·合】或者【同庆·欢】中的一种玉璧，不能领取。", pPlayer.szName)
    end
    if nDoubleBi == 0 then
      nDoubleBi = nIsDoubleBi
    else
      if nDoubleBi == nIsDoubleBi then
        return 0, "您队友中包里存在的玉璧和你的是一样的，不能领取。"
      end
    end
    if pPlayer.CountFreeBagCell() < 3 then
      return 0, string.format("你队伍中<color=yellow>%s<color>的背包不足<color=yellow>3<color>格，请清理后再来！", pPlayer.szName)
    end
    local nLastHeBiTime = self:GetHeBiTime(pPlayer)
    local nLastHeBiDay = Lib:GetLocalDay(nLastHeBiTime)
    local nNowDay = Lib:GetLocalDay(nNowTime)
    if nNowDay ~= nLastHeBiDay then
      self:SetHeBiTime(pPlayer, nNowTime)
      self:SetHeBiCount(pPlayer, 0)
    end
  end
  return 1
end

local tbZhouNianQingTeShi = Npc:GetClass("zhounianqing2012_teshi")

function tbZhouNianQingTeShi:OnDialog()
  ZhouNianQing2012:OnDialog()
end
