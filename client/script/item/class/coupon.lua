-- 优惠券
-- ExtParam1：物品的WareId
-- GenInfo: 使用次数，默认为1
local tbItem = Item:GetClass("coupon")

--TODO: dengyong 这个结构适用于对单种商品有效的优惠券，如果有对多种商品都有效的优惠券的话，需要修改这个结构。
tbItem.tbWareInfo = {
  --nWareId    szDescrip  nDiscountRate  对应商品的"g-d-p-l"	 购买的商品是否立即绑定
  [359] = { "3折大白驹丸", 30, "18-1-71-2", 1 },
  [360] = { "3折乾坤符", 30, "18-1-85-1", 1 },
  [361] = { "3折7级玄晶", 30, "18-1-1-7", 1 },
  [362] = { "3折9级玄晶", 30, "18-1-1-9", 1 },
}

function tbItem:GetWareInfo()
  return self.tbWareInfo
end

function tbItem:CalDiscount(tbWareList)
  --对优惠券的可用性进行判断，似乎将这个判断放在将优惠券放入格子的事件回调中更恰当一些，这里先将这段代码注释掉
  --local nRes, szMsg = self:Check(it.dwId);
  --if nRes == 0 then
  --	return szMsg;
  --end
  if not tbWareList then
    return {}
  end

  assert(it)
  assert(me)

  local tbRet = {}
  local pItem = KItem.GetObjById(it.dwId)
  local nWareId = pItem.GetExtParam(1)

  -- furuilei:旧优惠券的默认使用次数是0，需要在这里对次数进行手工加1
  local nTimes = pItem.GetGenInfo(1)
  if 0 == nTimes then
    nTimes = nTimes + 1
  end

  for nIndex, tbData in pairs(tbWareList) do
    local tbInfo = me.IbShop_GetWareInf(tbData.nWareId)

    if tbInfo.nCurrencyType == 0 then --只有金币区才能使用优惠券(程序中0表示金币，1表示银两，2表示绑金)
      local szWareIndex = string.format("%s-%s-%s-%s", tbInfo.nGenre, tbInfo.nDetailType, tbInfo.nParticular, tbInfo.nLevel)

      local nActualDiscountTimes, nDiscountRate = 0, 0
      if szWareIndex == self.tbWareInfo[nWareId][3] then
        --打折率
        nDiscountRate = self.tbWareInfo[nWareId][2]

        --实际打折商品的数量
        nActualDiscountTimes = nTimes > tbData.nCount and tbData.nCount or nTimes
        nTimes = nTimes - nActualDiscountTimes
        local bBind = self.tbWareInfo[nWareId][4] --是否获取绑定 1是， 0否
        table.insert(tbRet, { tbData.nWareId, nActualDiscountTimes, nDiscountRate, bBind })
      end
    end
  end

  return tbRet
end

function tbItem:CanCouponUse(dwId)
  assert(dwId)
  local pItem = KItem.GetObjById(dwId)
  if not pItem then
    return 0, "你的优惠券已过期。"
  end

  local nWareId = pItem.GetExtParam(1)
  local tbWareInfo = self.tbWareInfo[nWareId]

  if IVER_g_nSdoVersion == 0 and me.GetJbCoin() < tbWareInfo[2] then
    return 0, string.format("您的%s不足，购买1个%s需要%d%s", IVER_g_szCoinName, tbWareInfo[1], tbWareInfo[2], IVER_g_szCoinName)
  end

  if me.IsAccountLock() ~= 0 then
    return 0, "你还处于锁定状态"
  end

  return 1, pItem
end

function tbItem:DecreaseCouponTimes(tbCouponWare)
  if not tbCouponWare then
    return 0
  end

  assert(it)
  local pItem = KItem.GetObjById(it.dwId)
  if not pItem then
    return 0
  end

  local nWareId = pItem.GetExtParam(1)
  local nTimes = pItem.GetGenInfo(1)
  local nToDelTimes = 0 --需要扣除的次数
  --furuilei:旧优惠券的默认次数是0，需要手工加1
  if 0 == nTimes then
    nTimes = nTimes + 1
  end

  if nTimes == 0 then
    pItem.Delete(me)
    return 0
  end

  for nIndex, tbData in pairs(tbCouponWare) do
    local tbInfo = me.IbShop_GetWareInf(tbData[1])

    local szWareIndex = string.format("%s-%s-%s-%s", tbInfo.nGenre, tbInfo.nDetailType, tbInfo.nParticular, tbInfo.nLevel)

    if szWareIndex == self.tbWareInfo[nWareId][3] then
      nToDelTimes = nToDelTimes + tbData[2]
    end
  end

  if nToDelTimes > nTimes then --要扣除的次数大于剩余次数
    Dbg:WriteLog("coupon", "优惠个数大于优惠券剩余个数！！！")
    return 0
  end

  nTimes = nTimes - nToDelTimes

  if nTimes == 0 then
    pItem.Delete(me)
  else
    pItem.SetGenInfo(1, nTimes)
    pItem.Sync()
  end

  return 1
end

-------------------------------------------------------
--中间物品
local tbBaijuwan = Item:GetClass("newcoupon_temp")
function tbBaijuwan:OnUse()
  Item:GetClass("newcoupon"):AddItem(it.dwId)
  Dbg:WriteLog("TempItem", me.szName, it.szName)
end

-------------------------------------------------------
-- by zhangjinpin@kingsoft
-------------------------------------------------------
local tbNewItem = Item:GetClass("newcoupon")

tbNewItem.tbWareInfo = { --nWareId    szDescrip    nDicountRate  对应商品的"g-d-p-l"  购买的商品是否立即绑定, 真正的nWareId，价格，原价, 原来物品名字
  [359] = { "3折大白驹丸", 30, "18-1-71-2", 1, 54, 180, "大白驹丸" },
  [360] = { "3折乾坤符", 30, "18-1-85-1", 1, 60, 200, "乾坤符" },
  [361] = { "3折7级玄晶", 30, "18-1-1-7", 1, 672, 2240, "7级玄晶" },
  [362] = { "3折9级玄晶", 30, "18-1-1-9", 1, 8640, 28800, "9级玄晶" },
  [383] = { "5折购买帮会银锭（大）", 50, "18-1-284-2", 1, 5000, 10000, "买帮会银锭（大）" },
  [519] = { "3折购买精气散（回1500）", 30, "18-1-89-3", 1, 65, 215, "购买精气散（回1500）" },
  [520] = { "3折购买活气散（回1500）", 30, "18-1-90-3", 1, 65, 215, "购买活气散（回1500）" },
  [610] = { "2折魂石箱（1000个）", 20, "18-1-244-2", 1, 1600, 8000, "魂石箱（1000个）" },
}

function tbNewItem:OnUse()
  local nWareId = it.GetExtParam(1)
  local nTimes = it.GetExtParam(3) - it.GetGenInfo(1)
  local tbWareInfo = self.tbWareInfo[nWareId]
  if me.IsAccountLock() ~= 0 then
    Dialog:Say("你还处于锁定状态。")
    return 0
  end
  if Account:Account2CheckIsUse(me, 4) == 0 then
    Dialog:Say("你正在使用副密码登陆游戏，设置了权限控制，无法进行该操作！")
    return 0
  end
  if not tbWareInfo then
    return 0
  end
  if IVER_g_nSdoVersion == 0 and me.GetJbCoin() < tbWareInfo[5] then
    Dialog:Say(string.format("您的%s不足，购买1个%s需要<color=yellow>%d%s<color>，此次购买为您节省<color=yellow>%d%s<color>", IVER_g_szCoinName, tbWareInfo[1], tbWareInfo[5], IVER_g_szCoinName, tbWareInfo[6] - tbWareInfo[5], IVER_g_szCoinName), { { "充值获得金币", self.OpenWindow, self }, { "我知道了" } })
    return 0
  end
  if me.CountFreeBagCell() <= 0 then
    Dialog:Say("需要1格背包空间。")
    return
  end
  Dialog:Say(string.format("您将以<color=yellow>%s折<color>的优惠价格<color=yellow>%s%s<color>快速购买1个<color=yellow>%s<color>。\n<color=yellow>%s<color>原价<color=yellow>%s%s<color>，此优惠券为您节约<color=yellow>%s%s<color>。", math.floor(tbWareInfo[2] / 10), tbWareInfo[5], IVER_g_szCoinName, tbWareInfo[1], tbWareInfo[7], tbWareInfo[6], IVER_g_szCoinName, tbWareInfo[6] - tbWareInfo[5], IVER_g_szCoinName), {
    { "确认购买（购买绑定）", self.OnBuyItem, self, it.dwId, nWareId, nTimes },
    { "如何获得更多折扣优惠券", self.GetNewCoupon, self },
    { "稍后购买" },
  })
  return
end

function tbNewItem:GetNewCoupon()
  Dialog:Say("折扣购买券是《剑侠世界》为您推出的福利政策之一，可用于<color=yellow>优惠购买7玄/9玄/大白驹丸/乾坤符<color>等道具。\n折扣购买券是部分任务或活动的奖励之一，您还可以通过参加<color=yellow>每月充值活动<color>额外获得。", { "我知道了" })
end

function tbNewItem:OnBuyItem(dwId, nWareId, nTimes)
  local pItem = KItem.GetObjById(dwId)
  if not pItem then
    Dialog:Say("你的优惠券已过期。")
    return
  end
  if me.IsAccountLock() ~= 0 then
    Dialog:Say("你还处于锁定状态。")
    return 0
  end
  if Account:Account2CheckIsUse(me, 4) == 0 then
    Dialog:Say("你正在使用副密码登陆游戏，设置了权限控制，无法进行该操作！")
    return 0
  end
  local tbWareInfo = self.tbWareInfo[nWareId]
  if IVER_g_nSdoVersion == 0 and me.GetJbCoin() < tbWareInfo[5] then
    Dialog:Say(string.format("您的%s不足，购买1个%s需要<color=yellow>%d%s<color>，此次购买为您节省<color=yellow>%d%s<color>", IVER_g_szCoinName, tbWareInfo[1], tbWareInfo[5], IVER_g_szCoinName, tbWareInfo[6] - tbWareInfo[5], IVER_g_szCoinName), { { "充值获得金币", self.OpenWindow, self }, { "我知道了" } })
    return 0
  end
  if me.CountFreeBagCell() <= 0 then
    Dialog:Say("需要1格背包空间。")
    return
  end
  if me.IsItemInBags(pItem) == 0 then
    return
  end
  if nTimes <= 1 then
    local nRet = pItem.Delete(me)
    if nRet ~= 1 then
      return
    end
  else
    pItem.SetGenInfo(1, pItem.GetGenInfo(1) + 1)
    pItem.Sync()
  end
  me.ApplyAutoBuyAndUse(nWareId, 1, 1)
  return
end

function tbNewItem:OpenWindow()
  Player:OpenFuliTequan(1)
end

function tbNewItem:AddItem(dwId)
  local pItem = KItem.GetObjById(dwId)
  if not pItem then
    return
  end
  local tbWareInfo = self.tbWareInfo[pItem.GetExtParam(1)]
  if not tbWareInfo then
    return
  end
  pItem.Delete(me)
  local tbItem = Lib:SplitStr(tbWareInfo[3], "-")
  local pItemEx = me.AddItem(tonumber(tbItem[1]), tonumber(tbItem[2]), tonumber(tbItem[3]), tonumber(tbItem[4]))
  if pItemEx then
    pItemEx.Bind(1)
    me.SetItemTimeout(pItemEx, 30 * 24 * 60, 0)
  end
  return
end

function tbNewItem:GetWareInfo()
  return self.tbWareInfo
end

function tbNewItem:CalDiscount(tbWareList)
  --对优惠券的可用性进行判断，似乎将这个判断放在将优惠券放入格子的事件回调中更恰当一些，这里先将这段代码注释掉
  --local nRes, szMsg = self:Check(it.dwId);
  --if nRes == 0 then
  --	return szMsg;
  --end
  if not tbWareList then
    return {}
  end

  assert(it)
  assert(me)

  local tbRet = {}
  local pItem = KItem.GetObjById(it.dwId)
  local nWareId = pItem.GetExtParam(1)
  local nTimes = pItem.GetExtParam(3) - pItem.GetGenInfo(1)

  for nIndex, tbData in pairs(tbWareList) do
    local tbInfo = me.IbShop_GetWareInf(tbData.nWareId)

    if tbInfo.nCurrencyType == 0 then --只有金币区才能使用优惠券(程序中0表示金币，1表示银两，2表示绑金)
      local szWareIndex = string.format("%s-%s-%s-%s", tbInfo.nGenre, tbInfo.nDetailType, tbInfo.nParticular, tbInfo.nLevel)

      local nActualDiscountTimes, nDiscountRate = 0, 0
      if szWareIndex == self.tbWareInfo[nWareId][3] then
        --打折率
        nDiscountRate = self.tbWareInfo[nWareId][2]

        --实际打折商品的数量
        nActualDiscountTimes = nTimes > tbData.nCount and tbData.nCount or nTimes
        nTimes = nTimes - nActualDiscountTimes
        local bBind = self.tbWareInfo[nWareId][4] --是否获取绑定
        table.insert(tbRet, { tbData.nWareId, nActualDiscountTimes, nDiscountRate, bBind })
      end
    end
  end

  return tbRet
end

function tbNewItem:CanCouponUse(dwId)
  assert(dwId)
  local pItem = KItem.GetObjById(dwId)
  if not pItem then
    return 0, "你的优惠券已过期。"
  end

  local nWareId = pItem.GetExtParam(1)
  local tbWareInfo = self.tbWareInfo[nWareId]

  if IVER_g_nSdoVersion == 0 and me.GetJbCoin() < tbWareInfo[5] then
    return 0, string.format("您的%s不足，购买1个%s需要%d%s", IVER_g_szCoinName, tbWareInfo[1], tbWareInfo[5], IVER_g_szCoinName)
  end

  if me.IsAccountLock() ~= 0 then
    return 0, "你还处于锁定状态"
  end

  if MODULE_GAMESERVER and Account:Account2CheckIsUse(me, 4) == 0 then
    Dialog:Say("你正在使用副密码登陆游戏，设置了权限控制，无法进行该操作！")
    return 0
  end
  return 1
end

function tbNewItem:DecreaseCouponTimes(tbCouponWare)
  if not tbCouponWare then
    return 0
  end

  assert(it)
  local pItem = KItem.GetObjById(it.dwId)
  if not pItem then
    return 0
  end

  local nWareId = pItem.GetExtParam(1)
  local nTimes = pItem.GetGenInfo(1) --已经使用次数
  local nMaxTimes = pItem.GetExtParam(3) --最多可使用次数
  local nToDelTimes = 0 --需要扣除的次数

  if nTimes >= nMaxTimes then
    pItem.Delete(me)
    return 0
  end

  for nIndex, tbData in pairs(tbCouponWare) do
    local tbInfo = me.IbShop_GetWareInf(tbData[1])

    local szWareIndex = string.format("%s-%s-%s-%s", tbInfo.nGenre, tbInfo.nDetailType, tbInfo.nParticular, tbInfo.nLevel)

    if szWareIndex == self.tbWareInfo[nWareId][3] then
      nToDelTimes = nToDelTimes + tbData[2]
    end
  end

  if nToDelTimes > nMaxTimes - nTimes then --要扣除的次数大于剩余次数
    Dbg:WriteLog("coupon", "优惠个数大于优惠券剩余个数！！！")
    return 0
  end

  nTimes = nTimes + nToDelTimes

  if nTimes >= nMaxTimes then
    pItem.Delete(me)
  else
    pItem.SetGenInfo(1, nTimes)
    pItem.Sync()
  end

  return 1
end
