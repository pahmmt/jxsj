--优惠购买精活
--孙多良
--2008.09.22

Require("\\script\\player\\jinghuofuli.lua")

local tbBuyJingHuo = {}
SpecialEvent.BuyJingHuo = tbBuyJingHuo
function tbBuyJingHuo:OnDialog()
  local nFlag, szMsg = Player.tbBuyJingHuo:OpenBuJingHuo(me, 1)
  if 0 == nFlag then
    Dialog:Say(szMsg)
  elseif 2 == nFlag then
    local nPrestigeKe = KGblTask.SCGetDbTaskInt(DBTASK_JINGHUOFULI_KE)
    local nPrestige = Player.tbBuyJingHuo:GetTodayPrestige()
    if nPrestigeKe > 0 then
      nPrestige = nPrestigeKe
    end

    local szMsg = string.format("你今天购买四折福利精活的机会尚未使用，再提升<color=yellow>%s<color>点江湖威望就可以激活了。《剑侠世界》四折福利精活为您打造高收益的网游生活。\n你可以通过“充值领取每周江湖威望”（15元档：10点/周，50元档：30点/周）或“使用江湖威望令牌”（20点）快速提高江湖威望：", nPrestige - me.nPrestige)
    local tbOpt = {
      { "打开【奇珍阁】购买<color=yellow>江湖威望令<color>", self.OpenQiZhenge, self },
      { "我考虑下" },
    }

    if SpecialEvent.ChongZhiRepute:CheckISCanGetRepute() == 0 then
      if SpecialEvent.ChongZhiRepute:CheckIsSetExt() ~= 1 then
        table.insert(tbOpt, 1, { "激活角色领取江湖威望", SpecialEvent.ChongZhiRepute.OnJiHuoGetRepute, SpecialEvent.ChongZhiRepute })
      end
    else
      local nResultRepute, nSumRepute = SpecialEvent.ChongZhiRepute:Check2()
      if me.nLevel >= 60 then
        if nResultRepute < 0 then
          table.insert(tbOpt, 1, { "充值获得每周福利精活领取资格", self.OpenChongZhi, self })
        elseif nResultRepute == 0 then
          if me.GetExtMonthPay() < IVER_g_nPayLevel2 then
            table.insert(tbOpt, 1, { "充值获得每周福利精活领取资格", self.OpenChongZhi, self })
          end
        elseif nResultRepute > 0 then
          if me.GetExtMonthPay() < IVER_g_nPayLevel2 then
            table.insert(tbOpt, 1, { "充值获得每周福利精活领取资格", self.OpenChongZhi, self })
          end
          table.insert(tbOpt, 1, { "领取本周充值江湖威望", SpecialEvent.ChongZhiRepute.OnDialog, SpecialEvent.ChongZhiRepute })
        end
      end
    end
    Dialog:Say(szMsg, tbOpt)
  else
  end
end

function tbBuyJingHuo:OpenChongZhi()
  c2s:ApplyOpenOnlinePay()
end

function tbBuyJingHuo:OpenQiZhenge()
  me.CallClientScript({ "UiManager:OpenWindow", "UI_IBSHOP" })
end

--脚本购买精气药过渡物品
local tbItem = Item:GetClass("jingqisan_coin")
function tbItem:OnUse()
  if me.CountFreeBagCell() < 5 then
    me.Msg(string.format("您的背包空间不足，需要5格背包空间。"))
    Dbg:WriteLog("Player.tbBuyJingHuo", "优惠购买精活", me.szAccount, me.szName, "背包空间不足，无法获得精气散。")
    return 0
  end

  if Player.tbBuyJingHuo:GetOrgJingHuoCount(me, 1) > 0 then
    Player.tbBuyJingHuo:AddOrgJingHuoBuyCount(me, 1)
  else
    Player.tbBuyJingHuo:DelExJingHuoBuyCount(me, 1, 1)
  end

  local tbItemInfo = { bTimeOut = 1 }
  for i = 1, 5 do
    local pItem = me.AddItemEx(18, 1, 89, 1, tbItemInfo)
    --不公告
    if pItem then
      pItem.Bind(1)
      local szDate = os.date("%Y/%m/%d/%H/%M/%S", GetTime() + 3600 * 24 * 30)
      me.SetItemTimeout(pItem, szDate)
      local szLog = string.format("自动使用获得了1个精气散")
      Dbg:WriteLog("Player.tbBuyJingHuo", "优惠购买精活", me.szAccount, me.szName, szLog)
    end
  end

  KStatLog.ModifyAdd("mixstat", "[统计]购买福利精气散人数", "总量", 1)
  me.CallClientScript({ "Ui:ServerCall", "UI_JINGHUOFULI", "RefreshCount" })
  return 1
end

--脚本购买活气药过渡物品
local tbItem = Item:GetClass("huoqisan_coin")
function tbItem:OnUse()
  if me.CountFreeBagCell() < 5 then
    me.Msg(string.format("您的背包空间不足，需要5格背包空间。"))
    Dbg:WriteLog("Player.tbBuyJingHuo", "优惠购买精活", me.szAccount, me.szName, "背包空间不足，无法获得活气散。")
    return 0
  end

  if Player.tbBuyJingHuo:GetOrgJingHuoCount(me, 2) > 0 then
    Player.tbBuyJingHuo:AddOrgJingHuoBuyCount(me, 2)
  else
    Player.tbBuyJingHuo:DelExJingHuoBuyCount(me, 2, 1)
  end

  local tbItemInfo = { bTimeOut = 1 }
  --不公告
  for i = 1, 5 do
    local pItem = me.AddItemEx(18, 1, 90, 1, tbItemInfo)
    if pItem then
      pItem.Bind(1)
      local szDate = os.date("%Y/%m/%d/%H/%M/%S", GetTime() + 3600 * 24 * 30)
      me.SetItemTimeout(pItem, szDate)
      local szLog = string.format("自动使用获得了1个活气散")
      Dbg:WriteLog("Player.tbBuyJingHuo", "优惠购买精活", me.szAccount, me.szName, szLog)
    end
  end

  KStatLog.ModifyAdd("mixstat", "[统计]购买福利活气散人数", "总量", 1)
  me.CallClientScript({ "Ui:ServerCall", "UI_JINGHUOFULI", "RefreshCount" })
  return 1
end
