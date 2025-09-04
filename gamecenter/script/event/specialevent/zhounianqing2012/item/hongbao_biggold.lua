-- zhouchenfei
-- 2012/9/24 15:30:59
-- 烟花活动
Require("\\script\\event\\specialevent\\zhounianqing2012\\zhounianqing2012_public.lua")

local ZhouNianQing2012 = SpecialEvent.ZhouNianQing2012

ZhouNianQing2012.nMaxPaiZiCount = 10
ZhouNianQing2012.tbHonor = {
  { { 18, 1, 1251, 1 }, "小游龙阁声望令[护身符]" },
  { { 18, 1, 1251, 2 }, "小游龙阁声望令[帽子] " },
  { { 18, 1, 1251, 3 }, "小游龙阁声望令[衣服]" },
  { { 18, 1, 1251, 4 }, "小游龙阁声望令[腰带]" },
  { { 18, 1, 1251, 5 }, "小游龙阁声望令[鞋子]" },
  { { 18, 1, 1251, 6 }, "小游龙阁声望令[项链]" },
  { { 18, 1, 1251, 7 }, "小游龙阁声望令[戒指]" },
  { { 18, 1, 1251, 8 }, "小游龙阁声望令[护腕]" },
  { { 18, 1, 1251, 9 }, "小游龙阁声望令[腰坠]" },
}

if MODULE_GAMESERVER then
  local tbItem = Item:GetClass("zhounianqing2012_biggold")

  tbItem.nNormalAwardId = 368
  tbItem.nMaxPaiZiRate = 10000
  tbItem.nBindMoney = 18888
  tbItem.nRate = 10

  function tbItem:OnUse()
    local nAwardIndex = it.GetGenInfo(1)
    if nAwardIndex <= 0 or nAwardIndex > #ZhouNianQing2012.tbPromiseWords then
      return Item:GetClass("randomitem"):SureOnUse(self.nNormalAwardId)
    elseif nAwardIndex ~= 2 then
      return Item:GetClass("randomitem"):SureOnUse(ZhouNianQing2012.tbPromiseWords[nAwardIndex].nRandomId)
    end

    if me.CountFreeBagCell() < 1 then
      me.Msg("包裹空间不足1格，请整理下！")
      return 0
    end

    if me.GetBindMoney() + self.nBindMoney > me.GetMaxCarryMoney() then
      me.Msg("你的绑定银两携带达上限了，无法获得绑定银两。")
      return 0
    end

    local nRet = 0
    local nDay = KGblTask.SCGetDbTaskInt(DBTASK_ZHOUNIANQING2012_BIGGOLD_HONOR_DAY)
    local nAllCount = KGblTask.SCGetDbTaskInt(DBTASK_ZHOUNIANQING2012_BIGGOLD_HONOR_COUNT)
    local nNowDay = tonumber(GetLocalDate("%Y%m%d"))
    if nDay ~= nNowDay then
      nAllCount = 0
    end
    local nRate = MathRandom(self.nMaxPaiZiRate)
    if not IpStatistics:IsStudioRole(me) and nAllCount < ZhouNianQing2012.nMaxPaiZiCount and nRate <= self.nRate and me.nLevel >= 90 then
      me.AddWaitGetItemNum(1)
      GCExcute({ "SpecialEvent.ZhouNianQing2012:CanGetHonor", me.nId, it.dwId })
      return 0
    else
      StatLog:WriteStatLog("stat_info", "sizhounian_2012", "award_datiandeng", me.nId, string.format("BindMoney,%s", self.nBindMoney))
      Dbg:WriteLog("ZhouNianQing2012", "zhounianqing2012_biggold", "addBindmoney1", me.szName)
      me.AddBindMoney(self.nBindMoney)
      return 1
    end
    return 1
  end

  --加声望牌子
  function ZhouNianQing2012:AddAward(nPlayerId, nItemId)
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
      KDialog.NewsMsg(1, Env.NEWSMSG_NORMAL, szMsg)
      if pPlayer.dwTongId and pPlayer.dwTongId > 0 then
        Player:SendMsgToKinOrTong(pPlayer, szMsg, 1)
      else
        Player:SendMsgToKinOrTong(pPlayer, szMsg, 0)
      end
      local tbLog = self.tbHonor[nIndex][1]
      pItem.Delete(pPlayer)
      StatLog:WriteStatLog("stat_info", "sizhounian_2012", "award_datiandeng", pPlayer.nId, string.format("%s_%s_%s_%s,1", tbLog[1], tbLog[2], tbLog[3], tbLog[4]))
      Dbg:WriteLog("ZhouNianQing2012", "zhounianqing2012_biggold", "addBindmoney2", pPlayer.szName)
    end
    return
  end

  --random
  function ZhouNianQing2012:AddRandomItem(nPlayerId, nItemId)
    local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
    if not pPlayer then
      return
    end
    pPlayer.AddWaitGetItemNum(-1)
    local pItem = KItem.GetObjById(nItemId)
    if not pItem then
      return
    end
    Dbg:WriteLog("ZhouNianQing2012", "zhounianqing2012_biggold", "addpaizi", pPlayer.szName)
    StatLog:WriteStatLog("stat_info", "sizhounian_2012", "award_datiandeng", pPlayer.nId, string.format("BindMoney,%s", self.nBindMoney))
    pItem.Delete(pPlayer)
    pPlayer.AddBindMoney(self.nBindMoney)
    return
  end
end
----------------------------------------------------------------------------
--gc

if MODULE_GC_SERVER then
  function ZhouNianQing2012:CanGetHonor(nPlayerId, nItemId)
    local nDay = KGblTask.SCGetDbTaskInt(DBTASK_ZHOUNIANQING2012_BIGGOLD_HONOR_DAY)
    local nAllCount = KGblTask.SCGetDbTaskInt(DBTASK_ZHOUNIANQING2012_BIGGOLD_HONOR_COUNT)
    local nNowDay = tonumber(GetLocalDate("%Y%m%d"))
    if nDay ~= nNowDay then
      KGblTask.SCSetDbTaskInt(DBTASK_ZHOUNIANQING2012_BIGGOLD_HONOR_DAY, nNowDay)
      nAllCount = 0
    end
    if nAllCount >= self.nMaxPaiZiCount then
      GlobalExcute({ "SpecialEvent.ZhouNianQing2012:AddRandomItem", nPlayerId, nItemId })
      return
    end
    GlobalExcute({ "SpecialEvent.ZhouNianQing2012:AddAward", nPlayerId, nItemId })
    KGblTask.SCSetDbTaskInt(DBTASK_ZHOUNIANQING2012_BIGGOLD_HONOR_COUNT, nAllCount + 1)
  end
end
