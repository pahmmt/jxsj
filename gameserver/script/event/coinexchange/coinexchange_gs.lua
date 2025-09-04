-- 文件名　：coinexchange.lua
-- 创建者　：xiewen
-- 创建时间：2009-02-16 15:17:18
-- 功能：绑银兑换银两

Require("\\script\\event\\coinexchange\\coinexchange_def.lua")

-- GS
function CoinExchange:CheckOnlinePayer_GS()
  local nOnlinePayer = CountOnlinePayer(15) -- 获得在线的付费用户数
  if nOnlinePayer then
    GCExcute({ "CoinExchange:CheckOnlinePayer_GC", nOnlinePayer })
  end
end

function CoinExchange:ExchangePayerMaxIsSusscess(nPlayerId, nSuccess)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return 0
  end
  if nSuccess == 1 then
    CoinExchange:Exchange(pPlayer, 1)
  else
    Setting:SetGlobalObj(pPlayer)
    Dialog:Say("本周兑换的银两已经换完了，下周请早点来找我吧。")
    Setting:RestoreGlobalObj()
  end
  return 0
end

-- 是否可以兑换 -1尚未排序，0已兑换，1可兑换
function CoinExchange:CanExchange(pPlayer)
  if pPlayer.IsAccountLock() ~= 0 then
    return 0, "您的账号处于锁定状态，无法进行该操作。"
  end
  local nPrestige = KGblTask.SCGetDbTaskInt(DBTASD_EVENT_PRESIGE_RESULT)
  if nPrestige == 0 then
    return -1, "系统尚未进行威望排序，目前不能兑换。"
  end

  if nPrestige < self.MIN_PRESTIGE then
    nPrestige = self.MIN_PRESTIGE
  end

  if nPrestige > pPlayer.nPrestige then
    return 0, "您的威望不够" .. nPrestige .. "点，不能兑换。"
  end

  local nLastXchgWeek = pPlayer.GetTask(self.TASK_GROUP, self.TASK_XCHG_TIME)
  local nThisWeek = Lib:GetLocalWeek(GetTime()) + 1

  if nLastXchgWeek == nThisWeek then
    return 0, "您本周已经兑换过了，每周只能兑换一次。"
  end

  return 1, "可以兑换"
end

function CoinExchange:RefreshExchangeRate()
  if SpecialEvent:IsWellfareStarted() == 1 then
    self.ExchangeRate = self.__ExchangeRate_wellfare
  else
    self.ExchangeRate = self.__ExchangeRate
  end
end

function CoinExchange:Exchange(pPlayer, Susscess)
  Setting:SetGlobalObj(pPlayer)
  local nErr, szErr = self:CanExchange(pPlayer)
  if nErr == 1 then
    if not Susscess then
      GCExcute({ "CoinExchange:CheckExchangePayerMax_GC", pPlayer.nId, 1 })
      Setting:RestoreGlobalObj()
      return 0
    end

    if pPlayer.GetBindMoney() < self.ExchangeAmount then
      Dialog:Say("您的绑银不足" .. self.ExchangeAmount .. "两，不能兑换。")
      Setting:RestoreGlobalObj()
      return
    end

    if self.ExchangeAmount * self.ExchangeRate + pPlayer.nCashMoney > pPlayer.GetMaxCarryMoney() then
      Dialog:Say("对不起，兑换后您身上的银两将会超过上限，请整理后再来兑换。")
      Setting:RestoreGlobalObj()
      return
    end

    if pPlayer.CostBindMoney(self.ExchangeAmount, Player.emKBINDMONEY_COST_EXCHANGE) == 1 then
      local nRank = PlayerHonor:GetPlayerHonorRank(pPlayer.nId, PlayerHonor.HONOR_CLASS_WEIWANG, 0)
      if nRank <= 0 or nRank > self.nMaxLimitRank then
        GCExcute({ "CoinExchange:AddExchangePayerMax_GC" })
      end
      local nThisWeek = Lib:GetLocalWeek(GetTime()) + 1
      pPlayer.SetTask(self.TASK_GROUP, self.TASK_XCHG_TIME, nThisWeek)

      local nAddCount = self.ExchangeAmount * self.ExchangeRate
      pPlayer.Earn(nAddCount, Player.emKEARN_EXCHANGE_BIND)
      KStatLog.ModifyAdd("jxb", "[产出]绑银兑换", "总量", nAddCount)
      KStatLog.ModifyAdd("bindjxb", "[消耗]兑换银两", "总量", self.ExchangeAmount)
      KStatLog.ModifyAdd("mixstat", "[统计]绑银兑换银两人数", "总量", 1)
      Dialog:Say("您成功用绑银兑换了" .. self.ExchangeAmount * self.ExchangeRate .. "两银两。")

      -- 记录玩家兑换银两的次数
      Stats.Activity:AddCount(pPlayer, Stats.TASK_COUNT_COINEX, 1)

      Setting:RestoreGlobalObj()
    else
      Dialog:Say("兑换失败，无法扣除指定数量的绑银。")
      Setting:RestoreGlobalObj()
    end
  else
    Dialog:Say(szErr)
    Setting:RestoreGlobalObj()
  end
end

local tbCoinExchange = {}
SpecialEvent.CoinExchange = tbCoinExchange

function tbCoinExchange:OnDialog()
  CoinExchange:RefreshExchangeRate()

  local nPrestige = KGblTask.SCGetDbTaskInt(DBTASD_EVENT_PRESIGE_RESULT)
  if nPrestige <= 0 then
    Dialog:Say("还没进行全区威望排名，无法知道今天获得优惠的威望要求，请等排名后再来找我吧")
    return 0
  end

  if nPrestige < CoinExchange.MIN_PRESTIGE then
    nPrestige = CoinExchange.MIN_PRESTIGE
  end

  local szMsg = "礼官：符合一定条件的玩家可以将<color=red>" .. CoinExchange.ExchangeAmount .. "两<color>绑银兑换成<color=red>" .. CoinExchange.ExchangeAmount * CoinExchange.ExchangeRate .. "两<color>银两。您的江湖威望需要达到<color=green>" .. nPrestige .. "点<color>方能获得今天的优惠。福利每周只可领一次，不会累计到下一周，并且数量有限，先到先得，请尽快兑换。"
  local tbOpt = {
    { "确定兑换", self.OnDialog2, self },
    { "我只是来看看" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbCoinExchange:OnDialog2()
  CoinExchange:Exchange(me)
end
