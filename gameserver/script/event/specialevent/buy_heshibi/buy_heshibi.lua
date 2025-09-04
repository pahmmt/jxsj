-- 文件名　：buy_heshibi.lua
-- 创建者　：sunduoliang
-- 创建时间：2009-07-17 15:00:48
-- 描  述  ：

SpecialEvent.BuyHeShiBi = SpecialEvent.BuyHeShiBi or {}
local tbBuyItem = SpecialEvent.BuyHeShiBi
tbBuyItem.TSK_GROUP = 2027
tbBuyItem.TSK_ID = 70 --可以购买和氏壁数量
tbBuyItem.TSK_DATE = 91 --增加和氏壁次数时间
tbBuyItem.DEF_COIN = 8000 --需要金币数
tbBuyItem.DEF_CWAREID = 380 --奇珍阁表Id
tbBuyItem.DEF_CLSDATE = 20 --次数累加间隔20天清除(取消，下月清0)

function tbBuyItem:Check()
  self:CheckCls()

  if me.GetTask(self.TSK_GROUP, self.TSK_ID) <= 0 then
    Dialog:Say("和氏壁数量有限，你没有购买和氏壁的资格。")
    return 0
  end

  if IVER_g_nSdoVersion == 0 and me.GetJbCoin() < self.DEF_COIN then
    Dialog:Say(string.format("您的金币不足，购买1个<color=yellow>秦陵·和氏璧<color>需要%s金币。", self.DEF_COIN))
    return 0
  end

  if me.CountFreeBagCell() < 1 then
    Dialog:Say(string.format("您的背包空间不足，需要1格背包空间。"))
    return 0
  end
  return 1
end

function tbBuyItem:BuyOnDialog(nSure)
  if self:Check() ~= 1 then
    return 0
  end
  if not nSure then
    local nSum = me.GetTask(self.TSK_GROUP, self.TSK_ID)
    local szMsg = string.format("你还可以购买<color=yellow>%s个秦陵·和氏璧<color>。购买一个<color=yellow>秦陵·和氏璧<color>需要<color=yellow>%s<color>%s，你确定要购买吗？", nSum, self.DEF_COIN, IVER_g_szCoinName)
    local tbOpt = {
      { "确定现在购买", self.BuyOnDialog, self, 1 },
      { "我再考虑考虑" },
    }
    Dialog:Say(szMsg, tbOpt)
    return 0
  end
  me.ApplyAutoBuyAndUse(self.DEF_CWAREID, 1)
  if IVER_g_nSdoVersion == 0 then
    Dialog:Say(string.format("您成功购买了1个<color=yellow>秦陵·和氏璧<color>"))
  end

  return 1
end

function tbBuyItem:AddCount(nCount)
  self:CheckCls()
  local nSum = me.GetTask(self.TSK_GROUP, self.TSK_ID)
  me.SetTask(self.TSK_GROUP, self.TSK_ID, nSum + nCount)
  return 1
end

function tbBuyItem:GetCount(nCount)
  self:CheckCls()
  return me.GetTask(self.TSK_GROUP, self.TSK_ID)
end

function tbBuyItem:CheckCls()
  local nCurSec = GetTime()
  local nSaveSec = me.GetTask(self.TSK_GROUP, self.TSK_DATE)
  if nSaveSec <= 0 or tonumber(os.date("%Y%m", nSaveSec)) < tonumber(os.date("%Y%m", nCurSec)) then
    --if (nSaveSec + self.DEF_CLSDATE * 24*3600) < nCurSec then
    me.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, "秦陵·和氏璧购买次数清0")
    me.SetTask(self.TSK_GROUP, self.TSK_ID, 0)
    me.SetTask(self.TSK_GROUP, self.TSK_DATE, nCurSec)
  end
end

function tbBuyItem:Consume()
  local nSum = me.GetTask(self.TSK_GROUP, self.TSK_ID)
  if nSum <= 0 then
    return 0
  end
  me.SetTask(self.TSK_GROUP, self.TSK_ID, nSum - 1)
  EventManager.tbChongZhiEvent:GetData(1)
  return 1
end

local tbCoinItem = Item:GetClass("coin_qinling_arm_item")

function tbCoinItem:OnUse()
  if me.CountFreeBagCell() < 1 then
    me.Msg(string.format("您的背包空间不足，需要1格背包空间。"))
    return 0
  end
  local tbItemInfo = { bTimeOut = 1, bForceBind = 1, bMsg = 0 }
  local pItem = me.AddItemEx(18, 1, 377, 1, tbItemInfo)
  --不公告
  if pItem then
    SpecialEvent.BuyHeShiBi:Consume()
    pItem.Bind(1)
    local szDate = os.date("%Y/%m/%d/%H/%M/%S", GetTime() + 3600 * 24 * 30)
    me.SetItemTimeout(pItem, szDate)
    local szLog = string.format("自动使用获得了1个秦陵·和氏璧")
    Dbg:WriteLog("Player.tbBuyJingHuo", "优惠购买精活", me.szAccount, me.szName, szLog)
  end
  return 1
end
