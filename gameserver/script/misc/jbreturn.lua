-------------------------------------------------------------------
--File: jbreturn.lua
--Author: luobaohang
--Date: 2008-9-24 22:51:59
--Describe: 金币消耗返还脚本
--Modify by zhangjinpin@kingsoft
-------------------------------------------------------------------

-- 是否开启新优惠标记
jbreturn.USE_ACCOUNT_DATA = 1

-- 固定10倍优惠
jbreturn.REBATE_RATE = 10

-- 支持重载，方便内网测试
jbreturn.tbPermitIp = jbreturn.tbPermitIp or {
  ["219.131.196.66"] = 1,
  ["219.141.176.227"] = 1,
  ["219.141.176.228"] = 1,
  ["219.141.176.229"] = 1,
  ["219.141.176.232"] = 1,
  ["114.255.44.131"] = 1,
  ["114.255.44.132"] = 1,
  ["114.255.44.133"] = 1,
  ["114.255.44.136"] = 1,
  ["222.35.61.94"] = 1,
  ["221.237.177.90"] = 1,
  ["221.237.177.91"] = 1,
  ["221.237.177.92"] = 1,
  ["221.237.177.93"] = 1,
  ["221.237.177.94"] = 1,
  ["221.237.177.95"] = 1,
  ["218.24.136.208"] = 1,
  ["113.106.106.2"] = 1,
  ["113.106.106.98"] = 1,
  ["113.106.106.99"] = 1,
  ["221.4.212.138"] = 1,
  ["221.4.212.139"] = 1,
  ["103.106.106.2"] = 1,
  ["218.24.136.210"] = 1,
  ["218.24.136.211"] = 1,
  ["218.24.136.212"] = 1,
  ["60.251.48.106"] = 1,
  ["59.124.243.115"] = 1,
  ["221.133.32.154"] = 1,
  ["221.133.32.155"] = 1,
  ["221.10.5.90"] = 1,
}

-- 额度档次
jbreturn.tbMonLimit = {
  [0] = 0,
  [1] = 100,
  [2] = 300,
  [3] = 500,
  [4] = 1000,
  [5] = 2000,
  [6] = 5000,
  [9] = math.huge,
}

-- 权限对话
jbreturn.tbSpecial = {
  { 0, "<color=yellow>兑换绑定银两<color>", "SelectReturnType", 1 },
  { 0, "<color=yellow>兑换绑定金币<color>", "SelectReturnType", 2 },
  { 0, "<color=green>购买绑定道具<color>", "_BuyPrivateItem" },
  { 0, "<color=green>兑换绑定道具<color>", "_ChangePrivateItem" },
  { 0, "打开内部仓库", "OpenSpecRepository" },
  { 0, "内部返还规则", "ReturnHelp" },
  { 0, "我要提升额度", "LimitLevelUp" },
  { 0, "<color=red>我要取消内部资格<color>", "ApplyCancel" },
}

-- 银锭道具
jbreturn.tbRefundItem = {
  [1] = {
    szName = "绑定银两",
    tbLevel = { { 349, 500 }, { 350, 5000 } },
  },
  [2] = {
    szName = "绑定金币",
    tbLevel = { { 351, 500 }, { 352, 5000 } },
  },
}

-- 任务变量
jbreturn.TASK_GID = 2056 -- 任务变量组
jbreturn.TASK_TASK1 = 1 -- (废弃)
jbreturn.TASK_TASK2 = 2 -- (废弃)
jbreturn.TASK_YOULONGBI = 3 -- 游龙古币(废弃)
jbreturn.TASK_TASK4 = 4 -- (废弃)
jbreturn.TASK_HESHIBI = 5 -- 和氏璧(废弃)
jbreturn.TASK_ZHENYUAN_TOTAL = 6 -- 真元相关(废弃)
jbreturn.TASK_ZHENYUAN_GET = 7 -- 真元相关(废弃)
jbreturn.TASK_YOULONGSHU = 8 -- 游龙战书(废弃)
jbreturn.TASK_MIJINGTU = 9 -- 秘境地图
jbreturn.TASK_ZHENYUAN_FREE = 10 -- 真元相关(废弃)
jbreturn.TASK_FRIEND_COST = 11 -- 内部密友(废弃)
jbreturn.TASK_YOULONG_HIDE = 12 -- 隐藏游龙(废弃)
jbreturn.TASK_JIEYUCHUI = 13 -- 解玉锤
jbreturn.TASK_MEIGUIHUA = 14 -- 玫瑰花(废弃)
jbreturn.TASK_TONYINDING = 15 -- 帮会银锭
jbreturn.TASK_ART_QUALIFI = 16 -- 美术特别优惠
jbreturn.TASK_ART_WEEK = 17 -- 美术特别优惠
jbreturn.TASK_LONWENBI = 18 -- 龙纹银币
jbreturn.TASK_TRANS_ACCOUNT = 19 -- 转入账号(19-26)
jbreturn.TASK_CANCEL_QUALITY = 27 -- 取消成功
jbreturn.TASK_CHANGE_ADDUP = 28 -- 兑换商城积分

jbreturn.BINDBANK_MAIN = 2085 -- 绑定银行主任务变量
jbreturn.BINDBANK_BINDMONEY = 9 -- 绑定银行子变量，绑银
jbreturn.BINDBANK_BINDCOIN = 10 -- 绑定银行子变更，绑金

function jbreturn:_BuyPrivateItem()
  local szMsg = "    这里可以通过内部商店购买<color=yellow>常用道具<color>，也可以购买每月<color=yellow>限额道具<color>和一些特殊道具。"
  local tbOpt = {
    { "打开内部商店", self.OpenSpecShop, self },
    { "购买限额道具", self.BuyLimitItem, self },
    { "购买特殊道具", self.BuySpecailItem, self },
    { "<color=gray>返回<color>", self.GainBindCoin, self },
  }
  Dialog:Say(szMsg, tbOpt)
end

function jbreturn:_ChangePrivateItem()
  local szMsg = "    这里可以使用限定的<color=yellow>不绑定道具<color>兑换<color=yellow>高倍数<color>的绑定道具或声望，还可以兑换一些<color=yellow>特殊<color>的装备和声望。"
  local tbOpt = {
    { "兑换特殊道具", self.ChangeSpecItem, self },
    { "兑换特殊声望", self.ChangeSpecRepute, self },
    { "兑换同伴装备", self.BuyPartnerEquip, self },
    { "兑换龙魂声望", self.BuyLonghunRepute, self },
    { "<color=gray>返回<color>", self.GainBindCoin, self },
  }
  Dialog:Say(szMsg, tbOpt)
end

-------------------------------------------------------
-- 账号优惠级别
-------------------------------------------------------

-- 获取优惠级别
function jbreturn:GetRetLevel(pPlayer)
  local nRebateValue = Account:GetIntValue(pPlayer.szAccount, "jbreturn.nRebateValue")
  local nLimitLevel = math.mod(nRebateValue, 10)
  local nSpecial = math.floor(nRebateValue / 10)
  return nLimitLevel, nSpecial, self.tbMonLimit[nLimitLevel] or 0
end

-- 设定优惠级别
function jbreturn:SetRetLevel(pPlayer, nLimitLevel, nSpecial)
  local nRebateValue = nLimitLevel + (nSpecial or 0) * 10
  Account:ApplySetIntValue(pPlayer.szAccount, "jbreturn.nRebateValue", nRebateValue)

  --记录扩展点，只做账号统计查询使用
  local nOldValue = pPlayer.GetExtPoint(7)
  local nSign = math.mod(math.floor(nOldValue / 10000), 10) --标记优惠账号
  local nSign2 = math.mod(math.floor(nOldValue / 100000), 10) --清除
  if nSign2 > 0 then
    pPlayer.PayExtPoint(7, (nSign2 * 100000))
  end
  if nLimitLevel > 0 and nSign == 0 then
    pPlayer.AddExtPoint(7, 10000)
  end
  if nLimitLevel == 0 and nSign > 0 then
    pPlayer.PayExtPoint(7, (nSign * 10000))
  end
end

-- 计算n月的优惠使用最大、最小值
function jbreturn:CheckConsume(pPlayer, nCheckMon, nCheckCount)
  local tbConsume, nLastMonth = self:GetConsume(pPlayer)
  local nMax = 0
  local nMin = math.huge
  local tbConsumeChecked = {}
  while nCheckCount > 0 do
    local nMon = math.mod(nCheckMon, 100)
    if nMon == 0 then -- 跨年
      nMon = 12
      nCheckMon = nCheckMon - 100 + 12
    end
    local nConsume = tbConsume[nMon]
    if nCheckMon > nLastMonth then -- 尚未消耗
      nConsume = 0
    elseif nCheckMon <= nLastMonth - 100 or not nConsume then -- 超出1年或没有消耗记录
      return nil, nil, tbConsumeChecked
    end
    table.insert(tbConsumeChecked, 1, { nCheckMon, nConsume })
    if nConsume > nMax then
      nMax = nConsume
    end
    if nConsume < nMin then
      nMin = nConsume
    end
    nCheckMon = nCheckMon - 1
    nCheckCount = nCheckCount - 1
  end
  return nMax, nMin, tbConsumeChecked
end

-- 检查优惠状态
function jbreturn:CheckState()
  if self.USE_ACCOUNT_DATA ~= 1 then
    return 1
  end

  local nRebateValue = Account:GetIntValue(me.szAccount, "jbreturn.nRebateValue")
  if nRebateValue <= 0 then -- 无优惠
    return 1
  end

  -- add 最低三档500
  local nLimitLevel, nSpecial, nMonLimit = self:GetRetLevel(me)
  if nLimitLevel < 3 then
    self:SetRetLevel(me, 3, nSpecial)
    return 1
  end

  local nCurMon = tonumber(GetLocalDate("%Y%m"))
  local tbConsume, nLastMonth = self:GetConsume(me)
  if nCurMon == nLastMonth then -- 没跨月，无需检查
    return 1
  end

  -- 检查近3月充值
  local nMaxConsume, nMinConsume = self:CheckConsume(me, nCurMon - 1, 3)
  if not nMaxConsume then -- 记录不足3月
    return 1
  end

  local nLowMonLimit = self.tbMonLimit[nLimitLevel - 1] or 0
  if nMaxConsume < nLowMonLimit * 100 and nLimitLevel > 3 then -- 低于更低等级
    self:SetRetLevel(me, nLimitLevel - 1, nSpecial)
    local szMsg = string.format("您的内部优惠额度因长期使用不足而降级（原：%d￥/月，现：%d￥/月）。", nMonLimit, nLowMonLimit)
    return 0, szMsg
  end

  return 1
end

-- 获取消耗记录
function jbreturn:GetConsume(pPlayer)
  -- 这里缓存一下，避免写入后立即读取出错
  local tbTemp = self:GetPlayerTempTable(pPlayer)
  if not tbTemp.tbConsume then
    tbTemp.nLastMonth = Account:GetIntValue(pPlayer.szAccount, "jbreturn.nCurMon")
    local szBuffer = Account:GetBinValue(pPlayer.szAccount, "jbreturn.tbMonUse")
    if tbTemp.nLastMonth > 0 then
      tbTemp.tbConsume = KLib.LoadBuffer2Value(szBuffer or "") or {}
    else
      local nConsumedValue = pPlayer.GetTask(2034, 4)
      local nConsumedMon = pPlayer.GetTask(2034, 3) + 1
      tbTemp.nLastMonth = tonumber(GetLocalDate("%Y%m"))
      local nCurMon = math.mod(tbTemp.nLastMonth, 100)
      if nCurMon ~= nConsumedMon then
        nConsumedValue = 0
      end
      tbTemp.tbConsume = { [nCurMon] = nConsumedValue }
    end
  end
  return tbTemp.tbConsume, tbTemp.nLastMonth
end

-- 获取当月消耗
function jbreturn:GetCurConsume(pPlayer)
  if self.USE_ACCOUNT_DATA == 1 then
    local tbConsume, nLastMonth = self:GetConsume(pPlayer)
    local nCurMonth = tonumber(GetLocalDate("%Y%m"))
    if nCurMonth == nLastMonth then
      return tbConsume[math.mod(nLastMonth, 100)] or 0
    end
  end

  return pPlayer.nConsumedValue
end

-- 当消耗额度时
function jbreturn:OnConsume(pPlayer, nPrice)
  pPlayer.ApplyConsumeRebateCredit(nPrice)

  -- 追加消耗记录
  local tbConsume, nLastMonth = self:GetConsume(pPlayer)
  local nCurMonth = tonumber(GetLocalDate("%Y%m"))
  if nLastMonth < nCurMonth - 100 then
    nLastMonth = nCurMonth - 100
  end
  while nLastMonth < nCurMonth do
    nLastMonth = nLastMonth + 1
    local nLastMon = math.mod(nLastMonth, 100)
    if nLastMon > 12 then
      nLastMon = 1
      nLastMonth = nLastMonth - 12 + 100
    end
    print("~~~", nLastMonth, nLastMon, tbConsume[nLastMon])
    tbConsume[nLastMon] = nil
  end
  local nCurMon = math.mod(nCurMonth, 100)
  local nConsumedValue = pPlayer.GetTask(2034, 4) -- 转换期间，可能原记录方式数值更高
  tbConsume[nCurMon] = math.max((tbConsume[nCurMon] or 0) + nPrice, nConsumedValue)
  local tbTemp = self:GetPlayerTempTable(pPlayer)
  tbTemp.nLastMonth = nCurMonth
  Account:ApplySetBinValue(pPlayer.szAccount, "jbreturn.tbMonUse", KLib.SaveValue2Buffer(tbConsume))
  Account:ApplySetIntValue(pPlayer.szAccount, "jbreturn.nCurMon", nCurMonth)
end

-- 是否是允许IP
function jbreturn:IsPermitIp(pPlayer)
  local szIp = pPlayer.GetPlayerIpAddress()
  local nPos = string.find(szIp, ":")
  if nPos then
    szIp = string.sub(szIp, 1, nPos - 1)
  end
  return self.tbPermitIp[szIp] or 0
end

-- 测试用激活内部优惠
function jbreturn:ActiveAccount(nMonLimit, nSpecial, szCurName)
  nMonLimit = nMonLimit or 2
  nSpecial = nSpecial or 0
  self:SetRetLevel(me, nMonLimit, nSpecial)
  me.Msg(string.format("激活内部优惠(%d,%d)！", nMonLimit, nSpecial))

  local nMonthLimit = self.tbMonLimit[nMonLimit]
  if nMonLimit <= 0 then
    self:DelSpecItem(me)
    GCExcute({ "Account:DelAccountLimit", me.szName, me.szAccount, nMonLimit, nSpecial, nMonthLimit, me.nMonCharge, me.GetHonorLevel() })
  else
    local szCurIp = Lib:IntIpToStrIp(me.GetTask(2063, 1)) or "0.0.0.0"
    local szCurArea = GetIpAreaAddr(me.GetTask(2063, 1)) or "未知区域"
    GCExcute({ "Account:LogLimitAccount", me.szName, me.szAccount, nMonLimit, nSpecial, nMonthLimit, me.nMonCharge, me.GetHonorLevel(), szCurIp, szCurArea })
    if szCurName and szCurName ~= "" and szCurName ~= "未设置" then
      GCExcute({ "Account:SetLimitAccountCurName", me.szAccount, szCurName })
    end
  end
end

-- 获取每月兑换额度
function jbreturn:GetMonLimit(pPlayer)
  local nLimitLevel, nSpecial, nMonthLimit = self:GetRetLevel(pPlayer)
  return nMonthLimit
end

-------------------------------------------------------
-- 主对话框
-------------------------------------------------------

-- 获取特殊权限对话（未做激活处理）
function jbreturn:GetSpecialOption(pPlayer)
  local nLimitLevel, nSpecial, nMonthLimit = self:GetRetLevel(pPlayer)
  local tbOption = {}
  for _, tb in ipairs(self.tbSpecial) do
    if nSpecial >= tb[1] then
      tbOption[#tbOption + 1] = { tb[2], self[tb[3]], self, unpack(tb, 4) }
    end
  end
  -- 美术同学特别通道
  local nWeek = Lib:GetLocalWeek()
  if pPlayer.GetTask(jbreturn.TASK_GID, self.TASK_ART_QUALIFI) >= nWeek then
    table.insert(tbOption, 1, { "美术特别优惠", self.GetFreeReward, self })
  end
  return tbOption
end

function jbreturn:GainBindCoin()
  if self:IsPermitIp(me) ~= 1 then
    return 0
  end

  local bOk, szMsg = self:CheckState()
  if bOk ~= 1 then
    Dialog:Say(szMsg)
    return 1
  end

  local nMonLimit = self:GetMonLimit(me)
  if nMonLimit <= 0 then
    return 0
  end

  -- 计算可兑换额度
  local nConsumedValue = self:GetCurConsume(me)
  local nMonCharge = me.nMonCharge
  local nRefundAvailable = math.min(nMonLimit, nMonCharge) * 100 - nConsumedValue
  if nRefundAvailable < 0 then
    nRefundAvailable = 0
  end

  local tbOption = self:GetSpecialOption(me)
  local tbNpc = Npc:GetClass("renji")
  tbOption[#tbOption + 1] = { "领取密友返还的绑定金币", tbNpc.GetIbBindCoin, tbNpc }
  tbOption[#tbOption + 1] = { "<color=gray>关闭" }

  local szMsgFmt = [[
<color=green>您的帐号是内部流通帐号<color>

您每月可以使用<color=yellow>%s金币<color>换取绑定金币或绑定银两，换取后金币将被扣除。

本月充值：<color=yellow>%d<color>金币
已兑换过：<color=yellow>%d<color>金币
还可兑换：<color=yellow>%d<color>金币
]]

  Dialog:Say(string.format(szMsgFmt, (nMonLimit == math.huge and "无限") or nMonLimit * 100, nMonCharge * 100, nConsumedValue, nRefundAvailable), tbOption)

  return 1
end

-------------------------------------------------------
-- 兑换绑金绑银
-------------------------------------------------------

-- nType 1:绑银，2：绑金 nLevel:等级(大/小) nCount个数
function jbreturn:_GetRefundOption(nType, nLevel, nCount)
  local nRate = self:GetRebateRate(nType)
  local tbItem = self.tbRefundItem[nType].tbLevel[nLevel]
  local szMsg = string.format("<color=yellow>%s<color>金币 -- <color=yellow>%s<color>%s", Lib:FormatMoney(tbItem[2] * nCount), Lib:FormatMoney(tbItem[2] * nRate * nCount), self.tbRefundItem[nType].szName)
  return { szMsg, self.PrepareRefund, self, nType, nLevel, nCount }
end

function jbreturn:SelectReturnType(nType)
  Dialog:Say("请选择兑换额度：", {
    self:_GetRefundOption(nType, 1, 1),
    self:_GetRefundOption(nType, 1, 2),
    self:_GetRefundOption(nType, 1, 4),
    self:_GetRefundOption(nType, 2, 1),
    self:_GetRefundOption(nType, 2, 2),
    self:_GetRefundOption(nType, 2, 4),
    self:_GetRefundOption(nType, 2, 10),
    { "<color=gray>返回<color>", self.GainBindCoin, self },
  })
end

function jbreturn:PrepareRefund(nType, nLevel, nCount)
  if me.IsInPrison() == 1 then
    me.Msg("天牢里不能兑换。")
    return 0
  end

  local tbItem = self.tbRefundItem[nType].tbLevel[nLevel]
  local nConsume = self:GetCurConsume(me) + tbItem[2] * nCount

  if nConsume > self:GetMonLimit(me) * 100 then
    me.Msg("您的每月兑换额度不足以完成兑换，请下个月再来。<pic=20>")
    return 0
  end
  if nConsume > me.nMonCharge * 100 then
    me.Msg("您本月充值额度不足以兑换，想要继续兑换，请充值。<pic=20>")
    return 0
  end
  if
    nType == 1 -- 换绑银需要检查携带上限
    and tbItem[2] * self:GetRebateRate(nType) * nCount + me.GetBindMoney() > me.GetMaxCarryMoney()
  then
    Dialog:Say(string.format("您的绑定银两将超出<color=yellow>%s两<color>的上限，请用掉一部分再来！<pic=26>", me.GetMaxCarryMoney()))
    return 0
  end

  me.ApplyAutoBuyAndUse(tbItem[1], nCount)
  return 1
end

function jbreturn:ReturnHelp()
  local szMsg = string.format("在充值当月，您可以按一定比例将金币兑换为绑定金币或绑定银两。兑换比例是您的返还倍数(<color=yellow>%d倍<color>)，金币兑换总量不能超过当月充值的金币数量。\n\n此功能仅限公司内部帐号，并且只有从公司IP登录游戏才可看到。", self.REBATE_RATE)
  local tbOpt = {
    { "返回上页", self.GainBindCoin, self },
    { "我知道了" },
  }
  Dialog:Say(szMsg, tbOpt)
end

-- 获得汇率
function jbreturn:GetRebateRate(nType)
  local nRate = self.REBATE_RATE
  if nType == 1 then
    local nJbPrice = KJbExchange.GetPrvAvgPrice()
    nRate = nRate * math.max(100, nJbPrice)
  end
  return nRate
end

-------------------------------------------------------
-- 内部返还充值额度
-------------------------------------------------------
function jbreturn:GetMonthPay(nMonth, nPay)
  if not self.tbMonthPay then
    local tbMonthPay = {}
    local tbTabFile = Lib:LoadTabFile("\\setting\\misc\\monthpay.txt")
    for _, tbRow in pairs(tbTabFile or {}) do
      local nMonth = tonumber(tbRow.Month)
      if not tbMonthPay[nMonth] then
        tbMonthPay[nMonth] = {}
      end
      for szKey, szValue in pairs(tbRow) do
        local nFind = string.find(szKey, "Pay")
        if nFind then
          local nKey = tonumber(string.sub(szKey, nFind + 3, -1))
          local nValue = tonumber(szValue)
          table.insert(tbMonthPay[nMonth], { Real = nValue, Result = nKey })
        end
      end
      table.sort(tbMonthPay[nMonth], function(a, b)
        return a.Real > b.Real
      end)
    end
    self.tbMonthPay = tbMonthPay
  end
  if not self.tbMonthPay[nMonth] then
    local tbPrePay = {
      [1] = { Real = 2000, Result = 5000 },
      [2] = { Real = 800, Result = 2000 },
      [3] = { Real = 400, Result = 1000 },
      [4] = { Real = 200, Result = 600 },
      [5] = { Real = 100, Result = 200 },
      [6] = { Real = 50, Result = 50 },
    }
    for _, tbRow in ipairs(tbPrePay) do
      if nPay >= tbRow.Real then
        return (nPay >= tbRow.Result) and nPay or tbRow.Result
      end
    end
    return nPay
  end
  for _, tbRow in ipairs(self.tbMonthPay[nMonth]) do
    if nPay >= tbRow.Real then
      return (nPay >= tbRow.Result) and nPay or tbRow.Result
    end
  end
  return nPay
end

-------------------------------------------------------
-- 限额度道具
-------------------------------------------------------

-- 限额度道具列表
jbreturn.tbLimitItemList = {
  [1] = {
    szName = "秘境地图",
    nPrice = 1200,
    tbItemId = { 18, 1, 251, 1 },
    tbTaskId = { jbreturn.TASK_GID, jbreturn.TASK_MIJINGTU },
    nDayLimit = 0,
    nHonor = 0,
    nBaseCount = 20,
    tbHonorLimit = { [9] = 30, [10] = 30 },
  },
  [2] = {
    szName = "帮会银锭（大）",
    nPrice = 10000,
    tbItemId = { 18, 1, 284, 2 },
    tbTaskId = { jbreturn.TASK_GID, jbreturn.TASK_TONYINDING },
    nDayLimit = 0,
    nHonor = 8,
    nBaseCount = 4,
    tbHonorLimit = { [10] = 8 },
  },
  [3] = {
    szName = "龙纹银币",
    nPrice = 10,
    tbItemId = { 18, 1, 1672, 1 },
    tbTaskId = { jbreturn.TASK_GID, jbreturn.TASK_LONWENBI },
    nDayLimit = 120,
    nHonor = 6,
    nBaseCount = 1000,
    tbHonorLimit = { [9] = 1500, [10] = 1500 },
  },
  [4] = {
    szName = "解玉锤",
    nPrice = 800,
    tbItemId = { 18, 1, 1312, 1 },
    tbTaskId = { jbreturn.TASK_GID, jbreturn.TASK_JIEYUCHUI },
    nDayLimit = 90,
    nHonor = 0,
    nBaseCount = 1000,
    tbHonorLimit = { [10] = 1500 },
  },
}

-- 购买限额度道具
function jbreturn:BuyLimitItem()
  local tbOpt = {}
  local szMsg = "大家好，我是金老板！我这里可以购买限额内部道具。"

  local nPlayerHonor = me.GetHonorLevel()
  local nOpenTime = GetTime() - KGblTask.SCGetDbTaskInt(DBTASD_SERVER_STARTTIME)
  for nIndex, tbInfo in ipairs(self.tbLimitItemList) do
    if nOpenTime >= tbInfo.nDayLimit * 60 * 60 * 24 and nPlayerHonor >= tbInfo.nHonor then
      table.insert(tbOpt, { tbInfo.szName, self.DoBuyLimitItem, self, nIndex })
    end
  end

  table.insert(tbOpt, { "<color=gray>返回<color>", self.GainBindCoin, self })
  Dialog:Say(szMsg, tbOpt)
end

function jbreturn:DoBuyLimitItem(nType)
  local tbInfo = self.tbLimitItemList[nType]
  if not tbInfo then
    return 0
  end

  local nLimitLevel, nSpecial, nMonthLimit = self:GetRetLevel(me)
  local nChange = me.GetTask(tbInfo.tbTaskId[1], tbInfo.tbTaskId[2])
  local nPermit = math.max((tbInfo.tbHonorLimit[me.GetHonorLevel()] or tbInfo.nBaseCount) - nChange, 0)

  local szMsg = string.format("您本月已经购买了%s<color=yellow>%s<color>个，还能继续购买<color=yellow>%s<color>个%s。", tbInfo.szName, nChange, (nMonthLimit == math.huge) and "无限" or nPermit, tbInfo.szName)

  local tbOpt = {
    { "我要购买", self.OnBuyLimitItem, self, nType, nPermit },
    { "我再想想" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function jbreturn:OnBuyLimitItem(nType, nPermit)
  Dialog:AskNumber("请输入数量：", nPermit, self.OnBuyLimitItem_Show, self, nType)
end

function jbreturn:OnBuyLimitItem_Show(nType, nInput)
  local tbInfo = self.tbLimitItemList[nType]
  if not tbInfo then
    return 0
  end

  local nLimitLevel, nSpecial, nMonthLimit = self:GetRetLevel(me)
  local nChange = me.GetTask(tbInfo.tbTaskId[1], tbInfo.tbTaskId[2])
  local nPermit = math.max((tbInfo.tbHonorLimit[me.GetHonorLevel()] or tbInfo.nBaseCount) - nChange, 0)

  if nInput <= 0 or nInput > nPermit then
    Dialog:Say("请输入正确的数量。")
    return 0
  end

  local nPrice = tbInfo.nPrice * nInput
  local szMsg = string.format(
    [[
商品名称：<color=yellow>%s<color>
购买数量：<color=yellow>%d<color>
消耗绑金：<color=yellow>%s<color>

是否确认购买？]],
    tbInfo.szName,
    nInput,
    nPrice
  )

  Dialog:Say(szMsg, { { "确定", self.OnBuyLimitItem_Sure, self, nType, nInput, nPrice }, { "<color=gray>取消" } })
end

function jbreturn:OnBuyLimitItem_Sure(nType, nInput, nPrice)
  local tbInfo = self.tbLimitItemList[nType]
  if not tbInfo then
    return 0
  end

  if me.nBindCoin < nPrice then
    Dialog:Say(string.format("对不起，您的绑金不足<color=green>%s<color>。", nPrice))
    return 0
  end

  local tbItemId = tbInfo.tbItemId
  local nNeed = KItem.GetNeedFreeBag(tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4], { bForceBind = 1 }, nInput)
  if me.CountFreeBagCell() < nNeed then
    Dialog:Say(string.format("请留出%s格背包空间。", nNeed))
    return 0
  end

  me.AddStackItem(tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4], { bForceBind = 1 }, nInput)
  me.AddBindCoin(-nPrice, Player.emKBINDCOIN_COST_JBRETURN)

  local nChange = me.GetTask(tbInfo.tbTaskId[1], tbInfo.tbTaskId[2])
  me.SetTask(tbInfo.tbTaskId[1], tbInfo.tbTaskId[2], nChange + nInput)
end

-------------------------------------------------------
-- 特殊道具
-------------------------------------------------------

-- 特殊声望道具列表
jbreturn.tbSpecailReputeList = {
  [1] = {
    nPrice = 80,
    nMaxCount = 300,
    tbItemId = { 18, 1, 200, 1 },
    szName = "逍遥·血影枪",
    nDayLimit = 30,
    nHonor = 0,
  },
  [2] = {
    nPrice = 4000,
    nMaxCount = 10,
    tbItemId = { 18, 1, 382, 1 },
    szName = "夜明珠·箱",
    nDayLimit = 138,
    nHonor = 0,
  },
  [3] = {
    nPrice = 1000,
    nMaxCount = 50,
    tbItemId = { 18, 1, 1300, 1 },
    szName = "忠魂之石碎片",
    nDayLimit = 50,
    nHonor = 6,
  },
}

-- 绑金购买特殊声望道具
function jbreturn:BuySpecailItem()
  local tbOpt = {}
  local szMsg = "大家好，我是金老板！我这里可以购买特殊内部道具。"

  local nOpenTime = GetTime() - KGblTask.SCGetDbTaskInt(DBTASD_SERVER_STARTTIME)
  local nPlayerHonor = me.GetHonorLevel()
  local nLimitLevel, nSpecial, nMonthLimit = self:GetRetLevel(me)
  for nIndex, tbInfo in ipairs(self.tbSpecailReputeList) do
    if nOpenTime >= tbInfo.nDayLimit * 3600 * 24 and nPlayerHonor >= tbInfo.nHonor then
      table.insert(tbOpt, { tbInfo.szName, self.OnBuySpecailItem, self, nIndex })
    end
  end
  table.insert(tbOpt, { "<color=gray>返回<color>", self.GainBindCoin, self })

  Dialog:Say(szMsg, tbOpt)
end

function jbreturn:OnBuySpecailItem(nType)
  local tbInfo = self.tbSpecailReputeList[nType]
  if not tbInfo then
    return 0
  end

  Dialog:AskNumber("请输入数量：", tbInfo.nMaxCount, self.OnBuySpecailItem_Show, self, nType)
end

function jbreturn:OnBuySpecailItem_Show(nType, nInput)
  local tbInfo = self.tbSpecailReputeList[nType]
  if not tbInfo then
    return 0
  end

  if nInput <= 0 or nInput > tbInfo.nMaxCount then
    Dialog:Say("请输入正确的数量。")
    return 0
  end

  local nPrice = tbInfo.nPrice * nInput
  local szMsg = string.format(
    [[
商品名称：<color=yellow>%s<color>
购买数量：<color=yellow>%d<color>
消耗绑金：<color=yellow>%s<color>

是否确认购买？]],
    tbInfo.szName,
    nInput,
    nPrice
  )

  Dialog:Say(szMsg, { { "确定", self.OnBuySpecailItem_Sure, self, nType, nInput, nPrice }, { "<color=gray>取消" } })
end

function jbreturn:OnBuySpecailItem_Sure(nType, nInput, nPrice)
  local tbInfo = self.tbSpecailReputeList[nType]
  if not tbInfo then
    return 0
  end

  if me.nBindCoin < nPrice then
    Dialog:Say(string.format("对不起，您的绑金不足<color=green>%s<color>。", nPrice))
    return 0
  end

  local tbItemId = tbInfo.tbItemId
  local nNeed = KItem.GetNeedFreeBag(tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4], { bForceBind = 1 }, nInput)
  if me.CountFreeBagCell() < nNeed then
    Dialog:Say(string.format("请留出%s格背包空间。", nNeed))
    return 0
  end

  me.AddBindCoin(-nPrice, Player.emKBINDCOIN_COST_JBRETURN)
  me.AddStackItem(tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4], { bForceBind = 1 }, nInput)
end

-------------------------------------------------------
-- 内部真元
-------------------------------------------------------

jbreturn.tbZhenyuanType = {
  [1] = { "宝玉", 193 },
  [2] = { "夏小倩", 182 },
  [3] = { "莺莺", 194 },
  [4] = { "木超", 181 },
  [5] = { "紫苑", 177 },
  [6] = { "秦仲", 178 },
  [7] = { "叶静", 246 },
}

-- 转化为非护体真元
function jbreturn:ChangeFree()
  Dialog:OpenGift(string.format("请放入欲转化的护体真元<color=yellow>（需要在背包中，价值量需超过1000，转化后所有属性降半星）<color>"), nil, { jbreturn.OnChangeFree, jbreturn })
end

function jbreturn:OnChangeFree(tbItem)
  -- 当前已经装备的真元17,18,19三个格子
  local tbEquipOrg = {}
  for i = 1, 3 do
    local pEquiped = me.GetItem(0, 16 + i, 0)
    if pEquiped then
      tbEquipOrg[pEquiped.dwId] = 1
    end
  end

  local nLimit = 10000000
  local nCount = 0
  local pTmpItem = nil
  for _, tbItem in pairs(tbItem) do
    local pItem = tbItem[1]
    if pItem.IsZhenYuan() == 1 and Item.tbZhenYuan:GetEquiped(pItem) == 1 and Item.tbZhenYuan:GetZhenYuanValue(pItem) >= nLimit and not tbEquipOrg[pItem.dwId] then
      nCount = nCount + 1
      pTmpItem = pItem
    end
  end

  if nCount ~= 1 then
    Dialog:Say("请放入正确的护体真元，每次只能放入一件。")
    return 0
  end

  for _, tbItem in pairs(tbItem) do
    local pItem = tbItem[1]
    if pItem.IsZhenYuan() == 1 and Item.tbZhenYuan:GetEquiped(pItem) == 1 then
      local nOrgValue = Item.tbZhenYuan:GetZhenYuanValue(pItem)
      if nOrgValue >= nLimit and not tbEquipOrg[pItem.dwId] then
        self:ZhenYuanRevalue(pItem, 1)
        Item.tbZhenYuan:SetEquiped(pItem, 0)
        pItem.Regenerate(pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel, pItem.nSeries, pItem.nEnhTimes, pItem.nLucky, pItem.GetGenInfo(), pItem.nVersion, pItem.dwRandSeed, pItem.nStrengthen)
        if Item.tbZhenYuan:GetParam1(pItem) == 0 and IsGlobalServer() == false then
          Ladder.tbGuidLadder:ApplyChangeValue(Item.tbZhenYuan:GetLadderId(pItem), pItem.szGUID, me.szName, Item.tbZhenYuan:GetZhenYuanValue(pItem) / 10000)
        end
        me.SetTask(2085, 8, 0)
        me.RemoveSkillState(2476)
        local szLog = string.format("转化为非护体真元：%s，原价值量：%s，新价值量：%s", pItem.szName, nOrgValue, Item.tbZhenYuan:GetZhenYuanValue(pItem))
        Dbg:WriteLog("jbreturn", me.szName, szLog)
        me.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, szLog)
      end
    end
  end
end

function jbreturn:ZhenYuanRevalue(pItem, nPot)
  if pItem and pItem.IsZhenYuan() == 1 then
    local nPot1 = Item.tbZhenYuan:GetAttribPotential1(pItem)
    local nPot2 = Item.tbZhenYuan:GetAttribPotential2(pItem)
    local nPot3 = Item.tbZhenYuan:GetAttribPotential3(pItem)
    local nPot4 = Item.tbZhenYuan:GetAttribPotential4(pItem)
    Item.tbZhenYuan:SetAttribPotential1(pItem, math.max(nPot1 - nPot, 1))
    Item.tbZhenYuan:SetAttribPotential2(pItem, math.max(nPot2 - nPot, 1))
    Item.tbZhenYuan:SetAttribPotential3(pItem, math.max(nPot3 - nPot, 1))
    Item.tbZhenYuan:SetAttribPotential4(pItem, math.max(nPot4 - nPot, 1))
    pItem.Sync()
    Dbg:WriteLog("真元降星", me.szName, string.format("真元：%s, 原始星级：%d_%d_%d_%d，集体下降%d星", pItem.szName, nPot1, nPot2, nPot3, nPot4, nPot))
  end
end

-------------------------------------------------------
-- 内部同伴装备
-------------------------------------------------------

-- 同伴装备列表
jbreturn.tbPartnerEquip = {
  [1] = { "碧血战衣", { 5, 20, 1, 1 }, { 18, 1, 944, 1 }, 15, 15, { { 18, 1, 944, 1 }, 35 } },
  [2] = { "碧血之刃", { 5, 19, 1, 1 }, { 18, 1, 941, 1 }, 15, 15, { { 18, 1, 941, 1 }, 35 } },
  [3] = { "碧血护符", { 5, 23, 1, 1 }, { 18, 1, 947, 1 }, 15, 15, { { 18, 1, 947, 1 }, 35 } },
  [4] = { "碧血护腕", { 5, 22, 1, 1 }, { 18, 1, 1235, 1 }, 300, 270, { { 18, 1, 476, 1 }, 150 } },
  [5] = { "碧血戒指", { 5, 21, 1, 1 }, { 18, 1, 1236, 1 }, 300, 270, { { 18, 1, 476, 1 }, 200 } },
  [6] = { "金鳞战衣", { 5, 20, 1, 2 }, { 18, 1, 945, 1 }, 15, 15, { { 18, 1, 945, 1 }, 35 } },
  [7] = { "金鳞之刃", { 5, 19, 1, 2 }, { 18, 1, 942, 1 }, 15, 15, { { 18, 1, 942, 1 }, 35 } },
  [8] = { "金鳞护符", { 5, 23, 1, 2 }, { 18, 1, 948, 1 }, 15, 15, { { 18, 1, 948, 1 }, 35 } },
  [9] = { "金鳞护腕", { 5, 22, 1, 2 }, { 18, 1, 1235, 2 }, 300, 270 },
  [10] = { "金鳞戒指", { 5, 21, 1, 2 }, { 18, 1, 1236, 2 }, 300, 270 },
}

function jbreturn:BuyPartnerEquip()
  local szMsg = [[
	大家好，我是金老板，萌达同伴装备到货了！你要兑换哪一种？
	
	<color=green>说明：
	1. 内部同伴装备不可交易，不可解绑
	2. 使用一定数量的同伴碎片或材料换取
	3. 内部同伴装备可以兑换回碎片或材料<color>
]]
  local tbOpt = {}
  for nType, tbInfo in ipairs(self.tbPartnerEquip) do
    table.insert(tbOpt, { string.format("%s - %s", tbInfo[1], tbInfo[4]), self.ChangePartnerEquip, self, nType })
  end
  table.insert(tbOpt, { "<color=yellow>同伴装备兑换材料<color>", self.ChangeBack, self })
  table.insert(tbOpt, { "<color=yellow>同伴装备转为外部<color>", self.ChangeCommon, self })
  table.insert(tbOpt, { "<color=gray>返回<color>", self.GainBindCoin, self })

  Dialog:Say(szMsg, tbOpt)
end

function jbreturn:ChangePartnerEquip(nType)
  Dialog:OpenGift(string.format("请放入<color=yellow>%s<color>碎片或材料", self.tbPartnerEquip[nType][1]), nil, { jbreturn.OnChangePartnerEquip, jbreturn, nType })
end

function jbreturn:OnChangePartnerEquip(nType, tbItem, nSure)
  local tbInfo = self.tbPartnerEquip[nType]
  if not tbInfo then
    return 0
  end

  local nCount = 0
  local nBind = 1
  for _, tbItem in pairs(tbItem) do
    local pItem = tbItem[1]
    local szKey = string.format("%s,%s,%s,%s", pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel)
    if szKey == string.format("%s,%s,%s,%s", unpack(tbInfo[3])) then
      nCount = nCount + pItem.nCount
      if pItem.IsBind() == 1 then
        nBind = 2
      end
    end
  end

  local nBase = tbInfo[4] * nBind
  if nCount <= 0 or math.mod(nCount, nBase) ~= 0 then
    Dialog:Say(string.format("请放入<color=yellow>%s<color>或其整数倍的<color=yellow>%s<color>材料或碎片。", nBase, tbInfo[1]))
    return 0
  end

  local nNeed = math.floor(nCount / nBase)
  if me.CountFreeBagCell() < nNeed then
    Dialog:Say(string.format("请留出%s格背包空间。", nNeed))
    return 0
  end

  if not nSure then
    local szMsg = string.format("你确定要兑换<color=yellow>%s<color>个<color=yellow>%s<color>么？", nNeed, tbInfo[1])
    local tbOpt = {
      { "确定", self.OnChangePartnerEquip, self, nType, tbItem, 1 },
      { "我再想想" },
    }
    Dialog:Say(szMsg, tbOpt)
    return 0
  end

  for _, tbItem in pairs(tbItem) do
    local pItem = tbItem[1]
    local szKey = string.format("%s,%s,%s,%s", pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel)
    if szKey == string.format("%s,%s,%s,%s", unpack(tbInfo[3])) then
      me.DelItem(pItem)
    end
  end

  for i = 1, nNeed do
    local tbItemId = tbInfo[2]
    local pItem = me.AddItem(tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4])
    if pItem then
      Partner:SetPartnerEquipParam(pItem)
      pItem.Bind(1)
      pItem.Sync()
    end
  end
end

function jbreturn:ChangeBack()
  Dialog:OpenGift("请放入同伴装备", nil, { jbreturn.OnChangeBack, jbreturn })
end

function jbreturn:OnChangeBack(tbItem, nSure)
  local nNeed = 0
  local nValue = 0
  for _, tbItem in pairs(tbItem) do
    local pItem = tbItem[1]
    if Partner:GetPartnerEquipParam(pItem) == 1 then
      local szKey = string.format("%s,%s,%s,%s", pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel)
      for i, tbInfo in pairs(self.tbPartnerEquip) do
        if szKey == string.format("%s,%s,%s,%s", unpack(tbInfo[2])) and tbInfo[5] then
          nValue = nValue + 1
          nNeed = nNeed + math.ceil(tbInfo[5] / 100)
        end
      end
    end
  end

  if nValue <= 0 then
    Dialog:Say("请放入正确的同伴装备，一次可以放入多件。")
    return 0
  end

  if me.CountFreeBagCell() < nNeed then
    Dialog:Say(string.format("请留出%s格背包空间。", nNeed))
    return 0
  end

  if not nSure then
    local szMsg = string.format("你打算将放入的<color=yellow>%s件<color>同伴装备全部兑换为原料吗？", nValue)
    local tbOpt = {
      { "确定", self.OnChangeBack, self, tbItem, 1 },
      { "我再想想" },
    }
    Dialog:Say(szMsg, tbOpt)
    return 0
  end

  for _, tbItem in pairs(tbItem) do
    local pItem = tbItem[1]
    if Partner:GetPartnerEquipParam(pItem) == 1 then
      local szKey = string.format("%s,%s,%s,%s", pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel)
      for i, tbInfo in pairs(self.tbPartnerEquip) do
        if szKey == string.format("%s,%s,%s,%s", unpack(tbInfo[2])) and tbInfo[5] then
          me.DelItem(pItem)
          me.AddStackItem(tbInfo[3][1], tbInfo[3][2], tbInfo[3][3], tbInfo[3][4], nil, tbInfo[5])
        end
      end
    end
  end
end

function jbreturn:ChangeCommon()
  Dialog:OpenGift("请放入内部同伴装备和差额材料（转为外部后可<color=yellow>保留属性<color>），跨服同伴装备需要放入差额碎片，楼兰同伴装备只需补齐<color=yellow>月影<color>即可，目前只能转化1级同伴装备", nil, { jbreturn.OnChangeCommon, jbreturn })
end

function jbreturn:OnChangeCommon(tbItem, nSure)
  local tbT = {}
  for _, tbItem in pairs(tbItem) do
    local pItem = tbItem[1]
    if Partner:GetPartnerEquipParam(pItem) == 1 then
      local szKey = string.format("%s,%s,%s,%s", pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel)
      for i, tbInfo in pairs(self.tbPartnerEquip) do
        if szKey == string.format("%s,%s,%s,%s", unpack(tbInfo[2])) and tbInfo[6] then
          tbT[i] = (tbT[i] or 0) + 1
        end
      end
    end
  end

  if Lib:CountTB(tbT) <= 0 then
    Dialog:Say("请放入正确的同伴装备和材料，一次可以放入多件。")
    return 0
  end

  local tbL = {}
  for _, tbItem in pairs(tbItem) do
    local pItem = tbItem[1]
    local szKey = string.format("%s,%s,%s,%s", pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel)
    for i, nCount in pairs(tbT) do
      local tbNeed = self.tbPartnerEquip[i][6]
      if tbNeed and szKey == string.format("%s,%s,%s,%s", unpack(tbNeed[1])) then
        tbL[i] = (tbL[i] or 0) + pItem.nCount
      end
    end
  end

  if Lib:CountTB(tbL) <= 0 then
    Dialog:Say("请放入正确的同伴装备和材料，一次可以放入多件。")
    return 0
  end

  for i, nCount in pairs(tbT) do
    local tbNeed = self.tbPartnerEquip[i][6]
    if not tbL[i] or tbL[i] ~= nCount * tbNeed[2] then
      Dialog:Say("请放入正确的同伴装备和材料，一次可以放入多件。")
      return 0
    end
  end

  if not nSure then
    local szMsg = "你确定要将放入的同伴装备和材料转为外部装备吗？"
    local tbOpt = {
      { "确定", self.OnChangeCommon, self, tbItem, 1 },
      { "我再想想" },
    }
    Dialog:Say(szMsg, tbOpt)
    return 0
  end

  for _, tbItem in pairs(tbItem) do
    local pItem = tbItem[1]
    local szKey = string.format("%s,%s,%s,%s", pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel)
    for i, nCount in pairs(tbT) do
      local tbNeed = self.tbPartnerEquip[i][6]
      if szKey == string.format("%s,%s,%s,%s", unpack(tbNeed[1])) then
        if tbL[i] and tbL[i] == nCount * tbNeed[2] then
          me.DelItem(pItem)
        end
      end
    end
  end

  for _, tbItem in pairs(tbItem) do
    local pItem = tbItem[1]
    if Partner:GetPartnerEquipParam(pItem) == 1 then
      local szKey = string.format("%s,%s,%s,%s", pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel)
      for i, tbInfo in pairs(self.tbPartnerEquip) do
        if szKey == string.format("%s,%s,%s,%s", unpack(tbInfo[2])) then
          if tbT[i] then
            Partner:ResetPartnerEquipParam(pItem)
          end
        end
      end
    end
  end
end

-------------------------------------------------------
-- 内部龙魂装备
-------------------------------------------------------

jbreturn._LONGHUN_VALUE = 4
jbreturn.tbLonghunList = {

  [1] = { "龙魂鉴·衣服（1级）", { 22, 1, 112, 1 }, { 15, 2, 1 } },
  [2] = { "龙魂鉴·衣服（2级）", { 22, 1, 112, 2 }, { 15, 2, 2 } },
  [3] = { "龙魂鉴·衣服（3级）", { 22, 1, 112, 3 }, { 15, 2, 3 } },
  [4] = { "龙魂鉴·戒指（1级）", { 22, 1, 113, 1 }, { 15, 3, 1 } },
  [5] = { "龙魂鉴·戒指（2级）", { 22, 1, 113, 2 }, { 15, 3, 2 } },
  [6] = { "龙魂鉴·戒指（3级）", { 22, 1, 113, 3 }, { 15, 3, 3 } },
  [7] = { "龙魂鉴·护身符（1级）", { 22, 1, 114, 1 }, { 15, 4, 1 } },
  [8] = { "龙魂鉴·护身符（2级）", { 22, 1, 114, 2 }, { 15, 4, 2 } },
  [9] = { "龙魂鉴·护身符（3级）", { 22, 1, 114, 3 }, { 15, 4, 3 } },
}

function jbreturn:CalcLonghunRepute(nCamp, nClass, nLevel)
  local nCurLevel = me.GetReputeLevel(nCamp, nClass)
  local nCurValue = me.GetReputeValue(nCamp, nClass)
  if nCurLevel ~= nLevel then
    return 0
  end
  local tbFullReputeInfo = KPlayer.GetReputeInfo()
  local tbReputeInfo = tbFullReputeInfo[nCamp][nClass]
  if nCurValue < 0 then
    return 0
  end
  return math.ceil(tbReputeInfo[nCurLevel].nLevelUp - nCurValue) / self._LONGHUN_VALUE
end

function jbreturn:BuyLonghunRepute()
  local szMsg = "    这里可以直接用<color=yellow>龙魂鉴碎片<color>兑换龙魂声望，独此一家，别无分号，赶紧的吧哈哈哈。"
  local tbOpt = {}
  for nType, tbInfo in ipairs(self.tbLonghunList) do
    local nCamp, nClass, nLevel = unpack(tbInfo[3])
    local nLimit = self:CalcLonghunRepute(nCamp, nClass, nLevel)
    if nLimit > 0 then
      table.insert(tbOpt, { string.format("%s - <color=yellow>需要%s个<color>", tbInfo[1], nLimit), self.DoBuyLonghunRepute, self, nType })
    else
      table.insert(tbOpt, { string.format("%s - <color=gray>不可兑换<color>", tbInfo[1]), self.BuyLonghunRepute, self })
    end
  end
  table.insert(tbOpt, { "<color=gray>返回<color>", self.GainBindCoin, self })
  Dialog:Say(szMsg, tbOpt)
end

function jbreturn:DoBuyLonghunRepute(nType)
  Dialog:OpenGift(string.format("请放入<color=yellow>%s<color>", self.tbLonghunList[nType][1]), nil, { jbreturn.OnBuyLonghunRepute, jbreturn, nType })
end

function jbreturn:OnBuyLonghunRepute(nType, tbItem, nSure)
  local tbInfo = self.tbLonghunList[nType]
  if not tbInfo then
    return 0
  end

  local nCount = 0
  for _, tbItem in pairs(tbItem) do
    local pItem = tbItem[1]
    local szKey = string.format("%s,%s,%s,%s", pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel)
    if szKey == string.format("%s,%s,%s,%s", unpack(tbInfo[2])) then
      nCount = nCount + pItem.nCount
    end
  end

  local nCamp, nClass, nLevel = unpack(tbInfo[3])
  local nLimit = self:CalcLonghunRepute(nCamp, nClass, nLevel)
  if nCount <= 0 or nCount > nLimit then
    Dialog:Say("请放入正确数量的声望碎片。")
    return 0
  end

  if not nSure then
    local szMsg = string.format("你确定要将<color=yellow>%s<color>个<color=yellow>%s<color>兑换成声望么？", nCount, tbInfo[1])
    local tbOpt = {
      { "确定", self.OnBuyLonghunRepute, self, nType, tbItem, 1 },
      { "我再想想" },
    }
    Dialog:Say(szMsg, tbOpt)
    return 0
  end

  for _, tbItem in pairs(tbItem) do
    local pItem = tbItem[1]
    local szKey = string.format("%s,%s,%s,%s", pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel)
    if szKey == string.format("%s,%s,%s,%s", unpack(tbInfo[2])) then
      local nRet = me.DelItem(pItem)
      if nRet ~= 1 then
        return 0
      end
    end
  end

  me.AddRepute(nCamp, nClass, nCount * self._LONGHUN_VALUE)
end

-------------------------------------------------------
-- 内部特殊声望
-------------------------------------------------------
jbreturn.tbSpecReputeItem = {
  {
    szName = "秦陵·官府声望",
    tbRepute = { 9, 1, 0.5 },
    tbList = {
      { { 18, 1, 366, 1 }, 50, "秦陵·摸金符", { 0 } },
    },
  },
  {
    szName = "秦陵·发丘门声望",
    tbRepute = { 9, 2, 4 },
    tbList = {
      { { 18, 1, 377, 1 }, 800, "和氏璧", { 0 } },
      { { 18, 1, 1453, 1 }, 160, "蓝田美玉（绑定）", { 1 } },
      { { 18, 1, 1453, 2 }, 160, "蓝田美玉（不绑定）", { 0 } },
    },
  },
  {
    szName = "武林联赛声望",
    tbRepute = { 7, 1, 0.3 },
    tbList = {
      { { 18, 1, 215, 1 }, 1000, "武林联赛黑铁令牌", { 0 } },
      { { 18, 1, 215, 2 }, 2000, "武林联赛青铜令牌", { 0 } },
      { { 18, 1, 215, 3 }, 3000, "武林联赛白银令牌", { 0 } },
      { { 18, 1, 215, 4 }, 5000, "武林联赛黄金令牌", { 0 } },
    },
  },
  {
    szName = "寒武遗迹声望",
    tbRepute = { 5, 6, 3 },
    tbList = {
      { { 18, 1, 512, 1 }, 250, "雪魂令", { 0 } },
    },
  },
  {
    szName = "民族大团圆声望",
    tbRepute = { 10, 1, 30 },
    tbList = {
      { { 18, 1, 475, 1 }, 5, "玉如意", { 0, 1 } },
    },
  },
  {
    szName = "2010盛夏活动声望",
    tbRepute = { 5, 5, 3 },
    tbList = {
      { { 18, 1, 663, 1 }, 500, "2010盛夏纪念徽章", { 0 } },
    },
  },
  {
    szName = "武林大会声望",
    tbRepute = { 11, 1, 3 },
    tbList = {
      { { 18, 1, 487, 1 }, 1600, "武林大会英雄令牌", { 0 } },
    },
  },
  {
    szName = "跨服联赛声望",
    tbRepute = { 12, 1, 3 },
    tbList = {
      { { 18, 1, 916, 1 }, 500, "白玉", { 0 } },
    },
  },
  {
    szName = "武林高手声望（金）",
    tbRepute = { 6, 1, 0 },
    tbList = {
      { { 18, 1, 1709, 1 }, 30, "初级武林高手令（金）", { 0 } },
      { { 18, 1, 1710, 2 }, 60, "中级武林高手令（金）", { 0 } },
      { { 18, 1, 1711, 3 }, 150, "高级武林高手令（金）", { 0 } },
    },
  },
  {
    szName = "武林高手声望（木）",
    tbRepute = { 6, 2, 0 },
    tbList = {
      { { 18, 1, 1712, 1 }, 30, "初级武林高手令（木）", { 0 } },
      { { 18, 1, 1713, 2 }, 60, "中级武林高手令（木）", { 0 } },
      { { 18, 1, 1714, 3 }, 150, "高级武林高手令（木）", { 0 } },
    },
  },
  {
    szName = "武林高手声望（水）",
    tbRepute = { 6, 3, 0 },
    tbList = {
      { { 18, 1, 1715, 1 }, 30, "初级武林高手令（水）", { 0 } },
      { { 18, 1, 1716, 2 }, 60, "中级武林高手令（水）", { 0 } },
      { { 18, 1, 1717, 3 }, 150, "高级武林高手令（水）", { 0 } },
    },
  },
  {
    szName = "武林高手声望（火）",
    tbRepute = { 6, 4, 0 },
    tbList = {
      { { 18, 1, 1718, 1 }, 30, "初级武林高手令（火）", { 0 } },
      { { 18, 1, 1719, 2 }, 60, "中级武林高手令（火）", { 0 } },
      { { 18, 1, 1720, 3 }, 150, "高级武林高手令（火）", { 0 } },
    },
  },
  {
    szName = "武林高手声望（土）",
    tbRepute = { 6, 5, 0 },
    tbList = {
      { { 18, 1, 1721, 1 }, 30, "初级武林高手令（土）", { 0 } },
      { { 18, 1, 1722, 2 }, 60, "中级武林高手令（土）", { 0 } },
      { { 18, 1, 1723, 3 }, 150, "高级武林高手令（土）", { 0 } },
    },
  },
}

function jbreturn:ChangeSpecRepute()
  local szMsg = "    这里可以使用限定的<color=yellow>不绑定声望道具<color>兑换<color=yellow>高倍数声望点数<color>，要换的赶紧。"
  local tbOpt = {}
  for i, tbInfo in ipairs(self.tbSpecReputeItem) do
    table.insert(tbOpt, { tbInfo.szName, self.DoChangeSpecRepute, self, i })
  end
  tbOpt[#tbOpt + 1] = { "<color=gray>返回<color>", self.GainBindCoin, self }
  Dialog:Say(szMsg, tbOpt)
end

function jbreturn:DoChangeSpecRepute(nType)
  local tbInfo = self.tbSpecReputeItem[nType]
  if tbInfo then
    local szName = " "
    for _, tbList in pairs(tbInfo.tbList) do
      szName = szName .. tbList[3] .. " "
    end
    Dialog:OpenGift(string.format("请放入<color=green>%s<color>来兑换 <color=yellow>%s<color>", szName, tbInfo.szName), nil, { jbreturn.OnChangeSpecRepute, jbreturn, nType })
  end
end

function jbreturn:OnChangeSpecRepute(nType, tbItem, nSure)
  local tbInfo = self.tbSpecReputeItem[nType]
  if not tbInfo then
    return 0
  end

  local nRepute = 0
  for _, tbItem in pairs(tbItem) do
    local pItem = tbItem[1]
    local szKey = string.format("%s,%s,%s,%s", pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel)
    for _, tbTmpList in pairs(tbInfo.tbList) do
      for _, nBind in pairs(tbTmpList[4]) do
        if szKey == string.format("%s,%s,%s,%s", unpack(tbTmpList[1])) and pItem.IsBind() == nBind then
          nRepute = nRepute + pItem.nCount * tbTmpList[2]
        end
      end
    end
  end

  if nRepute <= 0 then
    Dialog:Say("请放入正确数量的道具。")
    return 0
  end

  if not nSure then
    local szMsg = string.format("    你确定要将放入的道具兑换成<color=yellow>%s点%s<color>么？", nRepute, tbInfo.szName)
    local tbOpt = {
      { "<color=yellow>确定<color>", self.OnChangeSpecRepute, self, nType, tbItem, 1 },
      { "我再想想" },
    }
    Dialog:Say(szMsg, tbOpt)
    return 0
  end

  for _, tbItem in pairs(tbItem) do
    local pItem = tbItem[1]
    local szKey = string.format("%s,%s,%s,%s", pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel)
    for _, tbTmpList in pairs(tbInfo.tbList) do
      for _, nBind in pairs(tbTmpList[4]) do
        if szKey == string.format("%s,%s,%s,%s", unpack(tbTmpList[1])) and pItem.IsBind() == nBind then
          local nRet = me.DelItem(pItem)
          if nRet ~= 1 then
            return 0
          end
        end
      end
    end
  end
  me.AddRepute(tbInfo.tbRepute[1], tbInfo.tbRepute[2], nRepute)
  local nValue = math.floor(nRepute * tbInfo.tbRepute[3] / 5)

  -- 密友返还
  me.IbBackCoin(nValue * 20)
  me.Msg(string.format("你的密友返还增加：<color=yellow>%s<color>", nValue))

  -- 商城积分
  local nChangeAddup = me.GetTask(self.TASK_GID, self.TASK_CHANGE_ADDUP)
  local nMonthCharge = math.min(me.nMonCharge, 2000) * 10
  if nChangeAddup + nValue <= nMonthCharge then
    Spreader:IbShopAddConsume(nValue * 100, 1)
    me.SetTask(self.TASK_GID, self.TASK_CHANGE_ADDUP, nChangeAddup + nValue)
    me.Msg(string.format("你的密友返还增加：%s，商城积分增加：%s", nValue, nValue * 100))
  end
end

-------------------------------------------------------
-- 内部特殊兑换道具
-------------------------------------------------------
jbreturn.tbSpecChangeItem = {
  {
    szName = "玄晶",
    nCount = 5,
    tbList = {
      { { 18, 1, 1, 5 }, { 18, 1, 114, 5 }, "5级玄晶", 2 },
      { { 18, 1, 1, 6 }, { 18, 1, 114, 6 }, "6级玄晶", 7 },
      { { 18, 1, 1, 7 }, { 18, 1, 114, 7 }, "7级玄晶", 25 },
      { { 18, 1, 1, 8 }, { 18, 1, 114, 8 }, "8级玄晶", 90 },
      { { 18, 1, 1, 9 }, { 18, 1, 114, 9 }, "9级玄晶", 320 },
      { { 18, 1, 1, 10 }, { 18, 1, 114, 10 }, "10级玄晶", 1150 },
      { { 18, 1, 1, 11 }, { 18, 1, 114, 11 }, "11级玄晶", 4150 },
    },
  },
  {
    szName = "五行魂石",
    nCount = 5,
    tbList = {
      { { 18, 1, 205, 1 }, { 18, 1, 205, 1 }, "五行魂石", 0.2 },
    },
  },
  {
    szName = "游龙战书",
    nCount = 3,
    tbList = {
      { { 18, 1, 524, 1 }, { 18, 1, 524, 1 }, "游龙战书", 5 },
    },
  },
  {
    szName = "领土成品",
    nCount = 5,
    tbList = {
      { { 18, 1, 263, 1 }, { 18, 1, 263, 1 }, "百步穿杨", 5 },
      { { 18, 1, 264, 1 }, { 18, 1, 264, 1 }, "刑天战袍", 5 },
      { { 18, 1, 265, 1 }, { 18, 1, 265, 1 }, "游龙战书", 5 },
      { { 18, 1, 266, 1 }, { 18, 1, 266, 1 }, "行军符咒", 5 },
      { { 18, 1, 267, 1 }, { 18, 1, 267, 1 }, "千里止渴丹", 5 },
    },
  },
}

function jbreturn:ChangeSpecItem()
  local szMsg = "    这里可以使用限定的<color=yellow>不绑定道具<color>兑换<color=yellow>高倍数绑定道具<color>，要换的赶紧。"
  local tbOpt = {}
  for i, tbInfo in ipairs(self.tbSpecChangeItem) do
    table.insert(tbOpt, { tbInfo.szName, self.DoChangeSpecItem, self, i })
  end
  tbOpt[#tbOpt + 1] = { "<color=gray>返回<color>", self.GainBindCoin, self }
  Dialog:Say(szMsg, tbOpt)
end

function jbreturn:DoChangeSpecItem(nType)
  local tbInfo = self.tbSpecChangeItem[nType]
  if tbInfo then
    Dialog:OpenGift(string.format("请放入<color=yellow>%s<color>来兑换<color=yellow>绑定%s<color>", tbInfo.szName, tbInfo.szName), nil, { jbreturn.OnChangeSpecItem, jbreturn, nType })
  end
end

function jbreturn:OnChangeSpecItem(nType, tbItem, nSure)
  local tbInfo = self.tbSpecChangeItem[nType]
  if not tbInfo then
    return 0
  end

  local nNeed = 0
  for _, tbItem in pairs(tbItem) do
    local pItem = tbItem[1]
    local szKey = string.format("%s,%s,%s,%s", pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel)
    for _, tbTmpList in pairs(tbInfo.tbList) do
      if szKey == string.format("%s,%s,%s,%s", unpack(tbTmpList[1])) and pItem.IsBind() == 0 then
        nNeed = nNeed + KItem.GetNeedFreeBag(tbTmpList[2][1], tbTmpList[2][2], tbTmpList[2][3], tbTmpList[2][4], { bForceBind = 1 }, pItem.nCount * tbInfo.nCount)
      end
    end
  end

  if nNeed <= 0 then
    Dialog:Say("请放入正确数量的道具。")
    return 0
  end

  if me.CountFreeBagCell() < nNeed then
    Dialog:Say(string.format("请留出%s格背包空间。", nNeed))
    return 0
  end

  if not nSure then
    local szMsg = string.format("    你确定要将放入的<color=yellow>%s<color>兑换为高倍数的<color=yellow>绑定%s<color>么？", tbInfo.szName, tbInfo.szName)
    local tbOpt = {
      { "<color=yellow>确定<color>", self.OnChangeSpecItem, self, nType, tbItem, 1 },
      { "我再想想" },
    }
    Dialog:Say(szMsg, tbOpt)
    return 0
  end

  for _, tbItem in pairs(tbItem) do
    local pItem = tbItem[1]
    local szKey = string.format("%s,%s,%s,%s", pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel)
    for _, tbTmpList in pairs(tbInfo.tbList) do
      if szKey == string.format("%s,%s,%s,%s", unpack(tbTmpList[1])) and pItem.IsBind() == 0 then
        local nCount = pItem.nCount
        me.DelItem(pItem)
        me.AddStackItem(tbTmpList[2][1], tbTmpList[2][2], tbTmpList[2][3], tbTmpList[2][4], { bForceBind = 1 }, nCount * tbInfo.nCount)
        local nValue = math.floor(nCount * tbTmpList[4])
        -- 密友返还
        me.IbBackCoin(nValue * 20)
        me.Msg(string.format("你的密友返还增加：<color=yellow>%s<color>", nValue))
        -- 商城积分
        local nChangeAddup = me.GetTask(self.TASK_GID, self.TASK_CHANGE_ADDUP)
        local nMonthCharge = math.min(me.nMonCharge, 2000) * 10
        if nChangeAddup + nValue <= nMonthCharge then
          Spreader:IbShopAddConsume(nValue * 100, 1)
          me.SetTask(self.TASK_GID, self.TASK_CHANGE_ADDUP, nChangeAddup + nValue)
          me.Msg(string.format("你的商城积分增加：<color=yellow>%s<color>", nValue * 100))
        end
      end
    end
  end
end

-------------------------------------------------------
-- 日月事件
-------------------------------------------------------

-- 刷新月额度
function jbreturn:ResetMonthLimit()
  local nMonLimit = self:GetMonLimit(me)
  if nMonLimit <= 0 then
    return 0
  end
  for _, tbInfo in pairs(self.tbLimitItemList or {}) do
    local tbTaskId = tbInfo.tbTaskId
    if tbTaskId then
      me.SetTask(tbTaskId[1], tbTaskId[2], 0)
    end
  end
  me.SetTask(self.TASK_GID, self.TASK_CHANGE_ADDUP, 0)
end

-- 刷新日额度
function jbreturn:ResetDailyLimit()
  local nMonLimit = self:GetMonLimit(me)
  if nMonLimit <= 0 then
    return 0
  end
end

-------------------------------------------------------
-- 内部商店仓库
-------------------------------------------------------

-- 内部商店
function jbreturn:OpenSpecShop()
  me.OpenShop(178, 10)
end

-- 内部仓库
function jbreturn:OpenSpecRepository()
  me.OpenRepository(him, 1)
  self:SyncBindBankData(me)
end

function jbreturn:BindCurrencyOperate(nOperate, nMoneyType, nCount)
  if self:IsPermitIp(me) == 0 then
    return
  end

  local bOk, szMsg = self:CheckState()
  if bOk ~= 1 then
    return
  end

  local nMonLimit = self:GetMonLimit(me)
  if nMonLimit <= 0 then
    return
  end

  -- 内部仓库处于打开状态才行
  if me.GetRepositoryOpenState() ~= 2 then
    return
  end

  if nOperate == 1 then -- 存
    if nMoneyType == 1 then -- 绑银
      local nSum = me.GetBindMoney()
      if nSum < nCount then
        return
      end
      if me.CostBindMoney(nCount) ~= 1 then
        return
      end
      me.SetTask(self.BINDBANK_MAIN, self.BINDBANK_BINDMONEY, me.GetTask(self.BINDBANK_MAIN, self.BINDBANK_BINDMONEY) + nCount)
    else -- 绑金
      local nSum = me.nBindCoin
      if nSum < nCount then
        return
      end
      if me.AddBindCoin(0 - nCount) ~= 1 then
        return
      end
      me.SetTask(self.BINDBANK_MAIN, self.BINDBANK_BINDCOIN, me.GetTask(self.BINDBANK_MAIN, self.BINDBANK_BINDCOIN) + nCount)
    end
  else -- 取
    if nMoneyType == 1 then -- 绑银
      local nSum = me.GetTask(self.BINDBANK_MAIN, self.BINDBANK_BINDMONEY)
      if nSum < nCount then
        return
      end

      if me.GetMaxCarryMoney() < me.GetBindMoney() + nCount then
        me.Msg("携带量将达上限！")
        return
      end
      me.AddBindMoney(nCount)
      me.SetTask(self.BINDBANK_MAIN, self.BINDBANK_BINDMONEY, nSum - nCount)
    else -- 绑金
      local nSum = me.GetTask(self.BINDBANK_MAIN, self.BINDBANK_BINDCOIN)
      if nSum < nCount then
        return
      end
      if me.AddBindCoin(nCount) ~= 1 then
        return
      end
      me.SetTask(self.BINDBANK_MAIN, self.BINDBANK_BINDCOIN, nSum - nCount)
    end
  end

  self:SyncBindBankData(me)
end

function jbreturn:SyncBindBankData(pPlayer)
  local nBankBindMoney = me.GetTask(self.BINDBANK_MAIN, self.BINDBANK_BINDMONEY)
  local nBankBindCoin = me.GetTask(self.BINDBANK_MAIN, self.BINDBANK_BINDCOIN)
  pPlayer.CallClientScript({ "Player:BindInfoSync", nBankBindMoney, nBankBindCoin })
end

-------------------------------------------------------
-- 美术优惠
-------------------------------------------------------
jbreturn.tbFreeReward = { bindcoin = 50000, bindmoney = 500000 }

-- 激活免费领取，有效期26周
function jbreturn:ActiveFreeReward()
  local nWeek = Lib:GetLocalWeek()
  me.SetTask(jbreturn.TASK_GID, self.TASK_ART_QUALIFI, nWeek + 25)
end

function jbreturn:GetFreeReward()
  local nWeek = Lib:GetLocalWeek()
  if me.GetTask(jbreturn.TASK_GID, self.TASK_ART_QUALIFI) < nWeek then
    Dialog:Say("对不起，该角色没有权利领取该优惠。")
    return
  end
  if me.GetTask(jbreturn.TASK_GID, self.TASK_ART_WEEK) >= nWeek then
    Dialog:Say(string.format("无法领取，每个角色每周只能领取一次。\n角色至激活后<color=yellow>26周以内<color>可以领取该优惠，当前该角色还可以领取<color=yellow>%s周<color>。", me.GetTask(jbreturn.TASK_GID, self.TASK_ART_QUALIFI) - nWeek))
    return
  end
  if self.tbFreeReward.bindmoney + me.GetBindMoney() > me.GetMaxCarryMoney() then
    Dialog:Say(string.format("您的绑定银两将超出<color=yellow>%s两<color>的上限，请用掉一部分再来！<pic=26>", me.GetMaxCarryMoney()))
    return
  end
  me.SetTask(jbreturn.TASK_GID, self.TASK_ART_WEEK, nWeek)
  me.AddBindCoin(self.tbFreeReward.bindcoin, Player.emKBINDCOIN_ADD_VIP_REBACK)
  me.AddBindMoney(self.tbFreeReward.bindmoney, Player.emKBINDMONEY_ADD_VIP_TRANSFER)
  Dialog:Say(string.format("你本周成功领取了<color=yellow>5万绑金和50万绑银<color>的优惠。\n角色至激活后<color=yellow>26周以内<color>可以领取该优惠，当前该角色还可以领取<color=yellow>%s周<color>。", me.GetTask(jbreturn.TASK_GID, self.TASK_ART_QUALIFI) - nWeek))
end

-- 额度升级
function jbreturn:LimitLevelUp()
  local nCurMon = tonumber(GetLocalDate("%Y%m"))
  local nMaxConsume, nMinConsume, tbConsume = self:CheckConsume(me, nCurMon, 3)
  local szConsume = "消耗记录："
  local nMonth = math.mod(nCurMon, 100)
  local nYear = math.floor(nCurMon / 100)
  for _, tb in ipairs(tbConsume) do
    local m = math.mod(tb[1], 100)
    local y = math.floor(tb[1] / 100)
    szConsume = szConsume .. string.format("\n%d年%02d月：%4d￥", y, m, math.floor(tb[2] / 100))
  end
  if not nMinConsume then
    Dialog:Say("充值记录不足3个月，不能处理升级。\n\n" .. szConsume)
    return
  end
  local nLimitLevel, nSpecial, nMonLimit = self:GetRetLevel(me)
  if nLimitLevel >= 5 then
    Dialog:Say("您当前额度过高，已不能自动升级，请向相关负责人申请。\n\n" .. szConsume)
    return
  end
  if nMinConsume < nMonLimit * 100 then
    Dialog:Say(string.format("请先保持3个月用满原%d￥/月的额度，再来申请。\n\n" .. szConsume, nMonLimit))
    return
  end
  self:SetRetLevel(me, nLimitLevel + 1, nSpecial)
  Dialog:Say(string.format("符合提升要求，已将您的优惠额度提升至%d￥/月！\n\n" .. szConsume, self.tbMonLimit[nLimitLevel + 1]))
end

-------------------------------------------------------
-- 取消内部资格
-------------------------------------------------------
function jbreturn:ApplyCancel()
  -- 完成审核
  if me.GetTask(self.TASK_GID, self.TASK_CANCEL_QUALITY) == 1 then
    local nNewAccount = me.GetTaskStr(self.TASK_GID, self.TASK_TRANS_ACCOUNT)
    if nNewAccount ~= "" then
      self:DelSpecItem(me)
      me.ApplyChangeAccount(nNewAccount)
      me.SetTaskStr(self.TASK_GID, self.TASK_TRANS_ACCOUNT, "")
    else
      self:ActiveAccount(0, 0)
    end
    me.SetTask(self.TASK_GID, self.TASK_CANCEL_QUALITY, 0)
    return 0
  end

  local szMsg = [[
    如果不想继续使用<color=yellow>内部资格<color>，或者想将账号<color=yellow>停封、出售<color>等，可以申请取消内部资格，并<color=yellow>免费<color>将角色转移到另一个<color=yellow>通行证<color>下
 
    <color=yellow>申请条件：<color>
    1.角色等级达到100级
    2.角色财富达到30000
    3.角色创建时间达到60天
    4.服务器开放时间达到150天
    5.账号下60天内无其他角色申请
]]
  local tbOpt = {
    { "<color=red>我要申请<color>", self.OnApplyCancel, self },
    { "我再想想" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function jbreturn:OnApplyCancel()
  -- 开服时间
  local nOpenDay = math.floor((GetTime() - KGblTask.SCGetDbTaskInt(DBTASD_SERVER_STARTTIME)) / (60 * 60 * 24))
  if nOpenDay < 150 then
    Dialog:Say("对不起，开服时间不足150天，无法申请取消内部资格。")
    return 0
  end
  -- 角色等级
  if me.nLevel < 100 then
    Dialog:Say("对不起，你的等级不足100级，无法申请取消内部资格。")
    return 0
  end
  -- 角色财富
  if PlayerHonor:GetPlayerHonor(me.nId, PlayerHonor.HONOR_CLASS_MONEY, 0) < 30000 then
    Dialog:Say("对不起，你的财富荣誉不足30000，无法申请取消内部资格。")
    return 0
  end
  -- 角色创建时间
  local nRoleCreateTime = Lib:GetDate2Time(me.GetRoleCreateDate())
  local nRoleExistDay = math.floor((GetTime() - nRoleCreateTime) / (60 * 60 * 24))
  if nRoleExistDay < 0 then
    Dialog:Say("对不起，你的角色创建时间不足60天，无法申请取消内部资格。")
    return 0
  end
  -- 账号数据
  local nApplyTime = Account:GetIntValue(me.szAccount, "Account.ApplyCancelTime")
  local nApplyDay = math.floor((GetTime() - nApplyTime) / (60 * 60 * 24))
  if nApplyDay < 60 then
    Dialog:Say("对不起，该账号下60天内已经有角色申请取消资格，请过一段再来申请。")
    return 0
  end

  local szMsg = [[
    取消内部资格时，可以选择将角色更换通行证，以便保护一些账号私人信息，你打算申请更换通行证么？申请通过后，请过来找我确认进行更换。

    <color=green>优惠账号开通和关闭：
    1.正式员工需发邮件申请开通
    2.离职或特殊情况下申请关闭
    3.优惠账号下角色只允许转移到新账号下，离职时可直接取消资格。<color>

    <color=yellow>请成功更换账号后，再和玩家谈卖号操作，申请买卖账号会根据游戏情况进行审批，可能会审批不允许通过。因个人买卖账号导致对游戏产生影响，需自行负责，项目组保持责任追求权利！请谨慎操作。<color>
]]
  local tbOpt = {
    { "<color=red>更换账号<color>", self.ChangeAccount, self },
    { "我再想想" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function jbreturn:ChangeAccount()
  -- 组队
  if me.nTeamId <= 0 then
    Dialog:Say("对不起，请与欲更换的通行证下角色单独组队，再来申请。")
    return 0
  end

  -- 2人
  local tbPlayerList = KTeam.GetTeamMemberList(me.nTeamId)
  if #tbPlayerList ~= 2 then
    Dialog:Say("对不起，请与欲更换的通行证下角色单独组队，再来申请。")
    return 0
  end

  -- 队长
  if me.IsCaptain() == 0 then
    Dialog:Say("对不起，你必须是队长，才能完成申请。")
    return 0
  end

  -- 同地图
  local pPlayer = KPlayer.GetPlayerObjById(tbPlayerList[2])
  if not pPlayer or pPlayer.nMapId ~= me.nMapId then
    Dialog:Say("对不起，你的队友必须在附近，才能完成申请。")
    return 0
  end

  self:ConfirmCancel(pPlayer.szAccount)
end

function jbreturn:ConfirmCancel(szAccount)
  if not szAccount or szAccount == "" then
    Dialog:Say("账号数据异常，请重新申请。")
    return 0
  end

  local nHonor = PlayerHonor:GetPlayerHonor(me.nId, PlayerHonor.HONOR_CLASS_MONEY, 0)
  local szMsg = string.format(
    [[
<color=red>您确定要取消内部资格么？<color>

角色名字：<color=yellow>%s<color>
角色等级：<color=yellow>%s<color>
角色财富：<color=yellow>%s<color>

原通行证：<color=yellow>%s<color>
新通行证：<color=yellow>%s<color>
]],
    me.szName,
    me.nLevel,
    nHonor,
    me.szAccount,
    szAccount
  )

  local tbOpt = {
    { "<color=red>确定<color>", self.OnConfirmCancel, self, szAccount },
    { "我再想想" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function jbreturn:OnConfirmCancel(szAccount)
  local szHour = tonumber(GetLocalDate("%H%M"))
  if szHour >= 2350 and szHour <= 2400 then
    me.Msg("每天晚上23：50至24：00间名单正在清点中，不允许使用该功能。")
    return
  end
  if me.szAccount ~= szAccount then
    me.SetTaskStr(self.TASK_GID, self.TASK_TRANS_ACCOUNT, szAccount)
  else
    me.SetTaskStr(self.TASK_GID, self.TASK_TRANS_ACCOUNT, "")
  end
  local nHonor = PlayerHonor:GetPlayerHonor(me.nId, PlayerHonor.HONOR_CLASS_MONEY, 0)
  GCExcute({ "Account:ApplyCancelJbreturn", me.szName, me.nLevel, nHonor, me.szAccount, szAccount })
  Dbg:WriteLog("jbreturn", "申请取消内部资格", me.szName, me.nLevel, nHonor, me.szAccount, szAccount)
  me.Msg("申请取消内部资格成功，请等待审核。")
end

-- 处理非法道具
function jbreturn:DelSpecItem(Player)
  local tbList = {
    { "内部战书", { 18, 1, 524, 4 }, 1 },
    { "碧血战衣", { 5, 20, 1, 1 }, 2, { 18, 1, 944, 1 }, 30 },
    { "碧血之刃", { 5, 19, 1, 1 }, 2, { 18, 1, 941, 1 }, 30 },
    { "碧血护符", { 5, 23, 1, 1 }, 2, { 18, 1, 947, 1 }, 30 },
    { "碧血护腕", { 5, 22, 1, 1 }, 2, { 18, 1, 1237, 1 }, 30 },
    { "碧血戒指", { 5, 21, 1, 1 }, 2, { 18, 1, 1240, 1 }, 30 },
    { "金鳞战衣", { 5, 20, 1, 2 }, 2, { 18, 1, 945, 1 }, 30 },
    { "金鳞之刃", { 5, 19, 1, 2 }, 2, { 18, 1, 942, 1 }, 30 },
    { "金鳞护符", { 5, 23, 1, 2 }, 2, { 18, 1, 948, 1 }, 30 },
    { "金鳞护腕", { 5, 22, 1, 2 }, 2, { 18, 1, 1238, 1 }, 30 },
    { "金鳞戒指", { 5, 21, 1, 2 }, 2, { 18, 1, 1241, 1 }, 30 },
    { "【真元】叶静", { 1, 24, 1, 1 }, 3 },
    { "【真元】宝玉", { 1, 24, 2, 1 }, 3 },
    { "【真元】夏小倩", { 1, 24, 3, 1 }, 3 },
    { "【真元】莺莺", { 1, 24, 4, 1 }, 3 },
    { "【真元】木超", { 1, 24, 5, 1 }, 3 },
    { "【真元】紫苑", { 1, 24, 6, 1 }, 3 },
    { "【真元】秦仲", { 1, 24, 7, 1 }, 3 },
  }

  Setting:SetGlobalObj(pPlayer)
  for _, tbInfo in pairs(tbList) do
    local tbFind = GM:GMFindAllRoom(tbInfo[2])
    for _, tbItem in pairs(tbFind or {}) do
      if tbInfo[3] == 1 then
        local szMsg = string.format("VIP游龙战书扣除：%s", tbItem.pItem.szName)
        me.DelItem(tbItem.pItem)
        me.PlayerLog(Log.emKPLAYERLOG_TYPE_GM_OPERATION, szMsg)
        Dbg:WriteLog("jbreturn", me.szName, szMsg)
      elseif tbInfo[3] == 2 and Partner:GetPartnerEquipParam(tbItem.pItem) == 1 then
        local szMsg = string.format("VIP同伴装备扣除：%s", tbItem.pItem.szName)
        me.DelItem(tbItem.pItem)
        me.AddStackItem(tbInfo[4][1], tbInfo[4][2], tbInfo[4][3], tbInfo[4][4], { bForceBind = 1 }, tbInfo[5])
        me.PlayerLog(Log.emKPLAYERLOG_TYPE_GM_OPERATION, szMsg)
        Dbg:WriteLog("jbreturn", me.szName, szMsg)
      elseif tbInfo[3] == 3 and Item.tbZhenYuan:GetParam1(tbItem.pItem) == 1 then
        local szPot = string.format("%s-%s-%s-%s", Item.tbZhenYuan:GetAttribPotential1(tbItem.pItem), Item.tbZhenYuan:GetAttribPotential2(tbItem.pItem), Item.tbZhenYuan:GetAttribPotential3(tbItem.pItem), Item.tbZhenYuan:GetAttribPotential4(tbItem.pItem))
        local szOrgValue = Item.tbZhenYuan:GetZhenYuanValue(tbItem.pItem)
        Item.tbZhenYuan:SetParam1(tbItem.pItem, 0)
        local szMsg = string.format("VIP真元转为外部：%s, 价值：%s，星级：%s", tbItem.pItem.szName, szOrgValue, szPot)
        me.PlayerLog(Log.emKPLAYERLOG_TYPE_GM_OPERATION, szMsg)
        Dbg:WriteLog("jbreturn", me.szName, szMsg)
      end
    end
    for i = 0, 4 do
      local pItem = me.GetItem(Item.ROOM_PARTNEREQUIP, i, 0)
      if pItem then
        local szName = string.format("%s,%s,%s,%s", pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel)
        local szName2 = string.format("%s,%s,%s,%s", unpack(tbInfo[2]))
        if szName == szName2 and Partner:GetPartnerEquipParam(pItem) == 1 then
          Partner:ResetPartnerEquipParam(pItem)
          local szMsg = string.format("VIP同伴装备转为外部：%s", pItem.szName)
          me.PlayerLog(Log.emKPLAYERLOG_TYPE_GM_OPERATION, szMsg)
          Dbg:WriteLog("jbreturn", me.szName, szMsg)
        end
      end
    end
  end
  Setting:RestoreGlobalObj(pPlayer)
end

-- 登陆事件
function jbreturn:_OnLogin(bExchangeServerComing)
  local nIsNoUse = Account:GetIntValue(me.szAccount, "Account.VipIsNoUse")
  if nIsNoUse == 0 then
    return
  end

  self:DelSpecItem(me)

  if self:GetRetLevel(me) == 0 then
    return
  end

  self:SetRetLevel(me, 0, 0)
  self:WriteLog(Dbg.LOG_ATTENTION, me.szAccount, me.szName, "Disable Account!")
end

if not jbreturn.nLoginId then
  PlayerSchemeEvent:RegisterGlobalDailyEvent({ jbreturn.ResetDailyLimit, jbreturn })
  PlayerSchemeEvent:RegisterGlobalMonthEvent({ jbreturn.ResetMonthLimit, jbreturn })
  jbreturn.nLoginId = PlayerEvent:RegisterGlobal("OnLoginOnly", "jbreturn:_OnLogin")
end
