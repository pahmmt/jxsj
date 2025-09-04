-- 文件名　：haohualibaoquan.lua
-- 创建者　：LQY
-- 创建时间：2012-12-06 14:42:41
-- 说　　明：豪华礼包券
local tbItem = Item:GetClass("2012haohualibaoquan")

function tbItem:OnUse()
  local szMsg = "<color=pink>新人首选【新·剑侠世界】豪华礼包<color><enter>原价：28880金币，<color=red>现价1折2888金币<color>，每人限购1个，助您前期轻松游戏！<enter><enter>购买后将会获得如下奖励<enter><color=cyan>【1级】<color>“古墓情缘”称号<enter>        月光宝盒·小<enter>        古墓稀有面具<enter>        3折7玄优惠券*4个<enter>        3折9玄优惠券*1个<enter>        5级玄晶*4个<enter>        侠客印鉴<enter><color=cyan>【10级】<color>绑定银两100000<enter><color=cyan>【20级】<color>绑定金币3000<enter>        白驹丸*20个<enter><color=cyan>【30级】<color>绑定银两900000<enter><color=cyan>【60级】<color>拉风坐骑“魍魉”"
  local tbOpt = {}
  if me.nCoin < 2888 then
    szMsg = szMsg .. "<enter><color=yellow>您的金币不够。<color>"
    table.insert(tbOpt, { "充值获得金币", self.GetCoin, self })
  else
    table.insert(tbOpt, { "马上购买", self.Buy, self, nil, it.dwId })
  end
  table.insert(tbOpt, { "我知道了" })
  Dialog:Say(szMsg, tbOpt)
end

function tbItem:GetTip()
  return "<color=green>您还可以使用1次该礼券<color><enter>新人首选【新·剑侠世界】豪华礼包，超值回馈，原价：28880金币，<color=red>现价1折2888金币<color>，每人限购1个，助您前期轻松游戏！<color=gold>右键点击快速购买。<color><enter><enter>购买后将会获得如下奖励<enter><color=cyan>【1级】<color>“古墓情缘”称号<enter>        月光宝盒·小<enter>        古墓稀有面具<enter>        3折7玄优惠券*4个<enter>        3折9玄优惠券*1个<enter>        5级玄晶*4个<enter>        侠客印鉴<enter><color=cyan>【10级】<color>绑定银两100000<enter><color=cyan>【20级】<color>绑定金币3000<enter>        白驹丸*20个<enter><color=cyan>【30级】<color>绑定银两900000<enter><color=cyan>【60级】<color>拉风坐骑“魍魉”<enter><color=red>此物品使用有效期：开服后30天。<color>"
end

function tbItem:InitGenInfo()
  local nOpenTime = KGblTask.SCGetDbTaskInt(DBTASD_SERVER_STARTTIME)
  local nEndSecond = nOpenTime + 30 * 24 * 60 * 60 --开服后30天
  it.SetTimeOut(0, nEndSecond) --绝对时间
end
function tbItem:Buy(nType, nItemId)
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("您的背包空间不足，请先整理出1个背包空间。")
    return
  end
  if me.IsAccountLock() ~= 0 then
    Dialog:Say("您的账号处于锁定状态。不能购买。")
    return
  end
  if nType ~= 1 then
    Dialog:Say("您正在购买<color=pink>【新·剑侠世界】豪华礼包<color><enter>此操作会消耗您<color=green>2888金币<color>。请确定购买。", { { "确定", self.Buy, self, 1, nItemId }, { "我再想想" } })
    return
  end
  local pItem = KItem.GetObjById(nItemId)
  if not pItem then
    Dialog:Say("您的优惠券不见了")
    return
  end
  if me.nCoin < 2888 then
    Dialog:Say("您的金币不足2888。", { { "充值获得金币", self.GetCoin, self }, { "我再想想" } })
    return
  end
  local nRs = me.ApplyAutoBuyAndUse(631, 1, 0)
  if nRs ~= 1 then
    Dialog:Say("未能购买成功，请稍后再试。")
    return
  else
    Dbg:WriteLog("Player", me.szName, "ApplyBuyHaoHuaLiBao", 631)
    pItem.Delete(me)
    Dialog:Say("恭喜您购买<color=pink>【新·剑侠世界】豪华礼包<color>成功。祝您游戏愉快！")
    return
  end
end
function tbItem:GetCoin()
  me.CallClientScript({ "UiManager:OpenWindow", "UI_FULITEQUAN" })
end
