-------------------------------------------------------------------
--File: onlinebankpay.lua
--Author: zhouchenfei
--Date: 2012/6/19 14:46:53
--Describe: 网银充值活动
-------------------------------------------------------------------

SpecialEvent.tbOnlineBankPay = SpecialEvent.tbOnlineBankPay or {}
local tbOnlineBankPay = SpecialEvent.tbOnlineBankPay

tbOnlineBankPay.EXT_POINT = 4
tbOnlineBankPay.BANKPAY_CONSUME_POINT = 30 -- 每一点充值记录就获得30点消费积分
tbOnlineBankPay.nGroupId = 2027
tbOnlineBankPay.nTaskId_ConsumePoint = 239
tbOnlineBankPay.nTaskId_RefreshConsumePointTime = 240
tbOnlineBankPay.nTaskId_GetAward = 241
tbOnlineBankPay.nTaskId_QualificationiFlag = 242
tbOnlineBankPay.nIsOpen = 1
tbOnlineBankPay.tbPayAward = {
  [1] = {
    nPayMoney = 50,
    szName = "领取【网银新秀奖】",
    szMsg = "你可以获得游龙阁开心蛋（绑定）1个和称号：武林网银新秀",
    tbItem = {
      -- 物品gdpl，数量，是否绑定，时限
      { { 18, 1, 525, 1 }, 1, 1, 30 * 3600 * 24 },
    },
    tbSpeTitle = { "武林网银新秀", 3 * 3600 * 24, "pink" },
    nFlagBit = 1,
  },
  [2] = {
    nPayMoney = 500,
    szName = "领取【网银达人奖】",
    szMsg = "你可以获得游龙阁开心蛋（绑定）3个、游龙阁碎金锭（绑定）3个和称号：武林网银达人",
    tbItem = {
      { { 18, 1, 525, 1 }, 3, 1, 30 * 3600 * 24 },
      { { 18, 1, 527, 2 }, 3, 1, 30 * 3600 * 24 },
    },
    tbSpeTitle = { "武林网银达人", 5 * 3600 * 24, "pink" },
    nFlagBit = 2,
  },
  [3] = {
    nPayMoney = 1000,
    szName = "领取【网银王者奖】",
    szMsg = "你可以获得超炫跟宠7天和称号：武林网银王者",
    tbItem = {
      { { 18, 1, 1751, 1 }, 1, 1, 30 * 3600 * 24 },
    },
    tbSpeTitle = { "武林网银王者", 7 * 3600 * 24, "pink" },
    nFlagBit = 3,
  },
}

tbOnlineBankPay.tbShowAward = {
  [1] = {
    szName = "50元<enter>网银新秀奖",
    tbAward = {
      { "binditem", { 18, 1, 525, 1, 1, 1 } },
      { "titlename", "武林网银新秀" },
    },
    nGetState = 0,
  },
  [2] = {
    szName = "500元<enter>网银达人奖",
    tbAward = {
      { "binditem", { 18, 1, 525, 1, 1, 3 } },
      { "binditem", { 18, 1, 527, 2, 1, 3 } },
      { "titlename", "武林网银达人" },
    },
    nGetState = 0,
  },
  [3] = {
    szName = "1000元<enter>网银王者奖",
    tbAward = {
      { "binditem", { 18, 1, 1751, 1, 1, 1 } },
      { "titlename", "武林网银王者" },
    },
    nGetState = 0,
  },
}

function tbOnlineBankPay:GetExtPoint(pPlayer)
  return pPlayer.GetExtPoint(self.EXT_POINT)
end

-- Lib:SetBits(nExtTemp, nSetValue, nStart, nEnd);

function tbOnlineBankPay:GetMonthType(pPlayer)
  local nExtTemp = self:GetExtPoint(pPlayer)
  return Lib:LoadBits(nExtTemp, 30, 30)
end

function tbOnlineBankPay:GetPayValue(pPlayer)
  local nExtTemp = self:GetExtPoint(pPlayer)
  local nMoney = Lib:LoadBits(nExtTemp, 0, 27)

  if jbreturn:GetMonLimit(pPlayer) > 0 then
    local nMonth = tonumber(GetLocalDate("%Y%m"))
    nMoney = jbreturn:GetMonthPay(nMonth, nMoney)
  end

  return nMoney
end

function tbOnlineBankPay:GetPlayerAwardFlagValue(pPlayer)
  return pPlayer.GetTask(self.nGroupId, self.nTaskId_GetAward)
end

function tbOnlineBankPay:SetPlayerAwardFlagValue(pPlayer, nValue)
  pPlayer.SetTask(self.nGroupId, self.nTaskId_GetAward, nValue)
end

function tbOnlineBankPay:GetAwardFlag(pPlayer, nFlagBit)
  local nAwardValue = self:GetPlayerAwardFlagValue(pPlayer)
  return KLib.GetBit(nAwardValue, nFlagBit)
end

function tbOnlineBankPay:SetAwardFlag(pPlayer, nFlagBit, nValue)
  local nAwardValue = self:GetPlayerAwardFlagValue(pPlayer)
  nAwardValue = KLib.SetBit(nAwardValue, nFlagBit, nValue)
  self:SetPlayerAwardFlagValue(pPlayer, nAwardValue)
end

function tbOnlineBankPay:GetHaveConsumeMoney(pPlayer)
  return pPlayer.GetTask(self.nGroupId, self.nTaskId_ConsumePoint)
end

function tbOnlineBankPay:SetHaveConsumeMoney(pPlayer, nValue)
  pPlayer.SetTask(self.nGroupId, self.nTaskId_ConsumePoint, nValue)
end

function tbOnlineBankPay:GetQualificationFlag(pPlayer)
  return pPlayer.GetTask(self.nGroupId, self.nTaskId_QualificationiFlag)
end

function tbOnlineBankPay:SetQualificationFlag(pPlayer, nValue)
  pPlayer.SetTask(self.nGroupId, self.nTaskId_QualificationiFlag, nValue)
end

-- 判断是否在同一个月
function tbOnlineBankPay:CheckIsSameMonth(pPlayer)
  local nMonthType = self:GetMonthType(pPlayer)
  local nNowMonthType = tonumber(os.date("%m", GetTime()))
  nNowMonthType = math.fmod(nNowMonthType, 2)

  -- 双月是1
  if nNowMonthType == 0 then
    nNowMonthType = 1
  else -- 单月是0
    nNowMonthType = 0
  end

  if nMonthType ~= nNowMonthType then
    return 0
  end
  return 1
end

function tbOnlineBankPay:UpdateBankPay_AwardFlagAndPoint(pPlayer)
  local nNowTime = GetTime()
  local nLastTime = pPlayer.GetTask(self.nGroupId, self.nTaskId_RefreshConsumePointTime)
  local nNowMonth = Lib:GetLocalMonth(nNowTime)
  local nLastMonth = Lib:GetLocalMonth(nLastTime)
  -- 不同月就清数据
  if nNowMonth == nLastMonth then
    return 0
  end

  pPlayer.SetTask(self.nGroupId, self.nTaskId_RefreshConsumePointTime, nNowTime)
  self:SetHaveConsumeMoney(pPlayer, 0)
  self:SetPlayerAwardFlagValue(pPlayer, 0)
  return 1
end

function tbOnlineBankPay:UpdateBankPayConsume(pPlayer)
  if 1 ~= self:CheckIsSameMonth(pPlayer) then
    return 0
  end

  local nDetPoint = self:GetLastConsumePoint(pPlayer) * self.BANKPAY_CONSUME_POINT

  if nDetPoint <= 0 then
    return 0
  end

  local nBankPay = self:GetCurMonthPay(pPlayer)
  self:SetHaveConsumeMoney(pPlayer, nBankPay)
  Spreader:IbShopAddConsume(nDetPoint, 1)
  local szMsg = string.format("网银充值额外为您增加了<color=yellow>%s<color=yellow>点奇珍阁消耗积分！", nDetPoint)
  pPlayer.Msg(szMsg)
  Dbg:WriteLog("OnlineBankPay", "UpdateBankPayConsume", me.szName, string.format("增加了%s点奇珍阁消耗积分", nDetPoint))
  me.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, string.format("增加了%s点奇珍阁消耗积分", nDetPoint))
  return 1
end

function tbOnlineBankPay:GetBankPayAward(nIndex, nFlag)
  local tbAward = self.tbPayAward[nIndex]
  if not tbAward then
    return 0
  end

  local nCheckFlag, szErrorMsg = self:CheckGetAward(me, nIndex)
  if nCheckFlag == 0 then
    Dialog:Say(szErrorMsg)
    return 0
  end

  local tbItem = tbAward.tbItem

  local nNeedBag = 0
  for i, tbOne in pairs(tbItem) do
    nNeedBag = nNeedBag + tbOne[2]
  end

  if nNeedBag > me.CountFreeBagCell() then
    Dialog:Say(string.format("您的背包空间不足%s格，请清理后再来领取！", nNeedBag))
    return 0
  end

  if not nFlag or nFlag ~= 1 then
    Dialog:Say(string.format("%s，你确定现在领取吗？", tbAward.szMsg), {
      { "确定", self.GetBankPayAward, self, nIndex, 1 },
      { "再考虑考虑" },
    })
    return 0
  end

  self:SetAwardFlag(me, tbAward.nFlagBit, 1)
  local nNowTime = GetTime()
  for i, tbOne in pairs(tbItem) do
    local nCount = tbOne[2]
    for j = 1, nCount do
      local pItemEx = me.AddItem(unpack(tbOne[1]))
      if pItemEx then
        pItemEx.SetTimeOut(0, nNowTime + tbOne[4])
        if tbOne[3] == 1 then
          pItemEx.Bind(1)
        end
        pItemEx.Sync()
      else
        Dbg:WriteLog("OnlineBankPay", "GetBankPayAward", me.szName, string.format("添加物品失败：%s,%s,%s,%s", tbOne[1][1], tbOne[1][2], tbOne[1][3], tbOne[1][4]))
      end
    end
  end

  local tbSpeTitle = tbAward.tbSpeTitle

  if tbSpeTitle then
    me.AddSpeTitle(tbSpeTitle[1], nNowTime + tbSpeTitle[2], tbSpeTitle[3])
  end

  Dbg:WriteLog("OnlineBankPay", "GetBankPayAward", me.szName, string.format("%s物品奖励成功！", tbAward.szName))
  me.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, string.format("%s物品奖励成功！", tbAward.szName))
  self:ApplyOpenOnlineBankWindow(1)
  return 1
end

function tbOnlineBankPay:CheckGetAwardEx(pPlayer, nIndex)
  if self:CheckIsSameMonth(pPlayer) ~= 1 then
    return 0
  end

  local nCheckQuFlag, szErrorMsg = self:CheckBankPayQulification(pPlayer)
  if nCheckQuFlag ~= 1 then
    return 0
  end

  local tbAward = self.tbPayAward[nIndex]

  if not tbAward then
    return 0
  end

  local nMoney = self:GetCurMonthPay(pPlayer)
  if nMoney < tbAward.nPayMoney then
    return 0
  end

  local nFlag = self:GetAwardFlag(pPlayer, tbAward.nFlagBit)
  if nFlag == 1 then
    return 2, "你已领取过奖励"
  end
  return 1
end

function tbOnlineBankPay:CheckGetAward(pPlayer, nIndex)
  if self.nIsOpen == 0 then
    return 0, "网银活动未开启。"
  end

  if self:CheckIsSameMonth(pPlayer) ~= 1 then
    return 0, "您当月还未充值不能领取。"
  end

  if GetMapType(pPlayer.nMapId) ~= "city" and GetMapType(pPlayer.nMapId) ~= "village" then
    return 0, "只能在各大新手村和城市才能领取充值优惠奖励！"
  end

  local nCheckQuFlag, szErrorMsg = self:CheckBankPayQulification(pPlayer)
  if nCheckQuFlag ~= 1 then
    return 0, szErrorMsg
  end

  local tbAward = self.tbPayAward[nIndex]

  if not tbAward then
    return 0, "没有此奖励。"
  end

  local nMoney = self:GetCurMonthPay(pPlayer)
  if nMoney < tbAward.nPayMoney then
    return 0, string.format("网银充值额度没有达到<color=red>%s元<color>，无法领取", tbAward.nPayMoney)
  end

  local nFlag = self:GetAwardFlag(pPlayer, tbAward.nFlagBit)
  if nFlag == 1 then
    return 0, "你已领取过奖励"
  end

  return 1
end

-- 判断这个时间是不是月底最后一天
function tbOnlineBankPay:CheckIsLastMonthDay(nSec)
  local nDay = tonumber(os.date("%d", nSec + 3600 * 24))
  -- 如果当天+1天就是1号，说明当天是月底
  if nDay == 1 then
    return 1
  end
  return 0
end

-- 获取是否有领取资格
function tbOnlineBankPay:CheckBankPayQulification(pPlayer)
  if self.nIsOpen == 0 then
    return 2, "网银充值特权未开放。"
  end

  if pPlayer.IsAccountLock() ~= 0 then
    return 2, "您的账号处于锁定状态，请先解锁。"
  end

  if Account:Account2CheckIsUse(pPlayer, 8) == 0 then
    return 2, "你正在使用副密码登陆游戏，设置了权限控制，无法进行该操作！"
  end

  local nNowTime = GetTime()
  local nNowMonth = Lib:GetLocalMonth(nNowTime)
  local nLastTime = pPlayer.GetBankPayQualification()
  local nLastMonth = Lib:GetLocalMonth(nLastTime)

  local nFlag = 1

  if nNowMonth <= 0 then
    nFlag = 0
  end

  if nLastMonth ~= nNowMonth then
    nFlag = 0
  end

  if self:CheckIsLastMonthDay(nNowTime) == 1 then
    local nHour = tonumber(GetLocalDate("%H"))
    -- 表示已经超过了22点
    if nHour >= 22 then
      return 2, "现在是每月额度清零时期，在此期间将不开放网银特权活动，并且在这段时间内充值将不计算额度，所以请您不要在这段时间内充值！"
    end
  end

  if 0 == nFlag then
    return 0, "此角色网银充值特权未激活" -- 未激活
  end
  local nMyFlag = self:GetQualificationFlag(pPlayer)
  local nMyMonth = Lib:GetLocalMonth(nMyFlag)
  if nMyMonth == nNowMonth then
    return 1, "此角色已激活本月网银充值特权" -- 此账号已经激活
  end

  return 2, "其他角色已激活本月网银充值特权"
end

-- 设置资格
function tbOnlineBankPay:SetBankPayQuilication(nFlag)
  local nCheckFlag, szMsg = self:CheckBankPayQulification(me)
  if 0 ~= nCheckFlag then
    Dialog:Say(szMsg)
    return 0
  end

  if not nFlag or nFlag ~= 1 then
    Dialog:Say("您确定激活此角色的网银充值特权资格吗？若此角色激活后，这个账号下的其他角色就无法激活了！", {
      { "确定", self.SetBankPayQuilication, self, 1 },
      { "我在考虑考虑" },
    })
    return 0
  end
  local nNowTime = GetTime()
  me.SetBankPayQualification(nNowTime)
  self:SetQualificationFlag(me, nNowTime)
  me.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, "网银特权激活成功！")
  Dbg:WriteLog("OnlineBankPay", "SetBankPayQuilication", me.szName, "网银特权激活成功！")
  Dialog:Say("你已经激活此角色的网银充值特权！")
end

function tbOnlineBankPay:GetLastConsumePoint(pPlayer)
  local nPayMoney = self:GetCurMonthPay(pPlayer)
  local nHaveGetMoney = self:GetHaveConsumeMoney(pPlayer)
  if self:CheckIsSameMonth(pPlayer) ~= 1 then
    return 0
  end

  if nHaveGetMoney > 5000 then
    return 0
  end

  if nPayMoney > 5000 then
    nPayMoney = 5000
  end

  local nDet = nPayMoney - nHaveGetMoney
  if nDet < 0 then
    nDet = 0
  end

  return nDet
end

function tbOnlineBankPay:GetRankPoint(nFlag)
  local nCheckQuFlag, szErrorMsg = self:CheckBankPayQulification(me)
  if nCheckQuFlag ~= 1 then
    Dialog:Say(szErrorMsg)
    return 0
  end

  if self:CheckIsSameMonth(me) ~= 1 then
    Dialog:Say("您当月还未充值。")
    return 0
  end

  if GetMapType(me.nMapId) ~= "city" and GetMapType(me.nMapId) ~= "village" then
    Dialog:Say("只能在各大新手村和城市才能领取充值优惠奖励！")
    return 0
  end

  local nPoint = self:GetLastConsumePoint(me)

  if nPoint <= 0 then
    Dialog:Say(string.format("通过网银充值，每充值一元，就能额外为您增加<color=yellow>%s点奇珍阁消耗积分<color>。最多能兑换5000元的积分。您还没有网银充值记录，无法领取积分。", self.BANKPAY_CONSUME_POINT))
    return 0
  end

  local szMsg = string.format("通过网银充值，每充值一元，就能额外为您增加<color=yellow>%s点奇珍阁消耗积分<color>，最多能兑换5000元的积分，您现在有<color=green>%s元<color>的奇珍阁消耗积分未领取，确定现在领取吗？", self.BANKPAY_CONSUME_POINT, nPoint)
  if not nFlag or nFlag ~= 1 then
    Dialog:Say(szMsg, {
      { "确定", self.GetRankPoint, self, 1 },
      { "再考虑考虑" },
    })
    return 0
  end

  self:UpdateBankPayConsume(me)
  self:ApplyOpenOnlineBankWindow(1)
end

function tbOnlineBankPay:ApplyOpenOnlineBankWindow(bIsUpdate)
  local nFlag, szErrorMsg = self:CheckBankPayQulification(me)

  if 0 == nFlag then
    Dialog:Say("此角色还未激活网银充值特权资格，你想激活吗？", {
      { "激活网银充值特权资格", self.SetBankPayQuilication, self },
      { "再考虑考虑" },
    })
    return 0
  elseif 2 == nFlag then
    Dialog:Say(szErrorMsg)
    return 0
  end

  local nPayMoney = self:GetCurMonthPay(me)
  local nPoint = self:GetLastConsumePoint(me)

  self:UpdateBankPay_AwardFlagAndPoint(me)

  local tbAwardInfo = {}

  for i, tbInfo in pairs(self.tbPayAward) do
    local nFlag = self:CheckGetAwardEx(me, i)
    local szName = tbInfo.szName
    tbAwardInfo[i] = self.tbShowAward[i]
    tbAwardInfo[i].nGetState = nFlag
  end

  local nGetConsumePointFlag = 0

  if self:GetLastConsumePoint(me) > 0 then
    nGetConsumePointFlag = 1
  end

  if bIsUpdate then
    me.CallClientScript({ "Ui:ServerCall", "UI_ONLINEBANKPAY", "UpdatePanel", nPayMoney, nPoint, tbAwardInfo })
    return 0
  end

  me.CallClientScript({ "UiManager:OpenWindow", "UI_ONLINEBANKPAY", nPayMoney, nPoint, tbAwardInfo })

  return 1
end

function tbOnlineBankPay:AboutInfo(nType)
  local szMsg = [[
<color=green>【奇珍阁消耗积分】<color>
    官方银行卡和官方支付宝充值的角色，每充值1元都可额外获得30点奇珍阁消耗积分。
<color=green>【网银新秀奖】<color>
    游龙阁开心蛋1个（绑定）
    称号：<color=pink>武林网银新秀<color>（3天）
<color=green>【网银达人奖】<color>
    游龙阁开心蛋3个（绑定）
    游龙阁碎金锭3个（绑定）
    称号：<color=pink>武林网银达人<color>（5天）
<color=green>【网银王者奖】<color>
    玫瑰精灵跟宠（7天）
    称号：<color=pink>武林网银王者<color>（7天）	
	]]
  Dialog:Say(szMsg)
end

-- Lib:SetBits(nExtTemp, nSetValue, nStart, nEnd);

function tbOnlineBankPay:SetOnlinePayPoint(pPlayer, nMonthType, nValue)
  local nExtTemp = self:GetExtPoint(pPlayer)
  if nExtTemp > 0 then
    pPlayer.PayExtPoint(self.EXT_POINT, nExtTemp)
  end

  nExtTemp = Lib:SetBits(0, nMonthType, 30, 30)
  nExtTemp = Lib:SetBits(nExtTemp, nValue, 0, 27)
  pPlayer.AddExtPoint(self.EXT_POINT, nExtTemp)
end

function tbOnlineBankPay:GetCurMonthPay(pPlayer)
  local nNowMonthType = 0
  local nMonth = tonumber(GetLocalDate("%m"))
  if math.mod(nMonth, 2) == 0 then
    nNowMonthType = 1
  end

  local nMonthType = self:GetMonthType(pPlayer)
  if nNowMonthType ~= nMonthType then
    return 0
  end

  return self:GetPayValue(pPlayer)
end
