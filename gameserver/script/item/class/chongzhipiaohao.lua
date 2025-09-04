-- 文件名　：chongzhipiaohao.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-02-09 15:00:19
-- 功能    ：充值票号，充值后使得充值额度提升到某个额度

local tbItem = Item:GetClass("chongzhipiaohao")

tbItem.tbKind_PiaoHao = {
  [1] = {
    szName = "充值票号·188元",
    nPayPoint = 188,
    nMaxPayPoint = 138,
  },
}

function tbItem:OnUse()
  local nKind = it.GetExtParam(1)
  local tbKind = self.tbKind_PiaoHao[nKind]
  if not tbKind then
    Dialog:Say("道具异常！")
    return 0
  end

  local nMonth = me.GetExtMonthPay()
  if nMonth >= tbKind.nMaxPayPoint then
    Dialog:Say("钱庄老板特别交代，本票号只能给有需要的侠士使用，你已经用不上这个宝物啦！快送给有需要的朋友们吧。")
    return 0
  end

  local nFlag, szMsg = EventManager.tbChongZhiEvent:CheckPayAward()
  if 0 ~= nFlag then
    Dialog:Say(szMsg)
    return 0
  end

  local szMsg = string.format("钱庄老板<color=yellow>谢贤<color>限量发行的<color=yellow>福利票号<color>，使用该宝物后可获得本月<color=yellow>充值188元<color>所有<color=yellow>充值福利特权<color>和<color=yellow>充值礼包<color>的激活领取资格。<color=yellow>充值福利特权<color>在使用本宝物时<color=yellow>自动激活<color>，至本月月底每日均可享用；<color=yellow>充值礼包<color>需要在<color=yellow>本月充值活动开放期间<color>激活领取。<enter><color=green>账号本月充值额度低于138元才享有此资格<color>。\n\n你确定使用吗？")
  local tbOpt = {
    { "确定", self.OnSureUse, self, it.dwId, nKind },
    { "我再考虑考虑" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbItem:OnSureUse(nItemId, nKind)
  local pItem = KItem.GetObjById(nItemId)
  if not pItem then
    Dialog:Say("物品异常！")
    return 0
  end

  local tbKind = self.tbKind_PiaoHao[nKind]
  if not tbKind then
    Dialog:Say("道具异常！")
    return 0
  end

  local nFlag, szMsg = EventManager.tbChongZhiEvent:CheckPayAward()
  if 0 ~= nFlag then
    Dialog:Say(szMsg)
    return 0
  end

  local nMonth = me.GetExtMonthPay()
  if nMonth >= tbKind.nMaxPayPoint then
    Dialog:Say("钱庄老板特别交代，本票号只能给有需要的侠士使用，你已经用不上这个宝物啦！快送给有需要的朋友们吧。")
    return 0
  end

  pItem.Delete(me)
  local nDet = tbKind.nPayPoint - nMonth
  me.__AddMonthPayExtValue(nDet)
  Dbg:WriteLog("chongzhipiaohao", "OnSureUse", me.szName, nDet)
  Dialog:Say("恭喜你已获得本月<color=yellow>充值188元<color>所有<color=yellow>充值福利特权<color>和<color=yellow>充值礼包<color>的激活领取资格。<enter><color=yellow>充值福利特权<color>已自动激活，至本月月底每日均可享用。<enter><color=yellow>充值礼包<color>需要在<color=yellow>本月充值活动开放期间<color>激活领取。<enter>")
  return 1
end
