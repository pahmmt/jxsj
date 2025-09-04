local tbItem = Item:GetClass("jintiao")
tbItem.GETMONEY = {
  [1] = { 150000, 200000 },
  [2] = { 1500000, 2000000 },
}
tbItem.ExReturnBindMoney = 0 --返还获得绑银的百分比绑银
function tbItem:OnUse()
  local nGetMoney = self.GETMONEY[it.nLevel][1]
  local nGetBindMoney = self.GETMONEY[it.nLevel][2]

  local szMsg = string.format("您使用<color=yellow>%s<color>可以兑换以下其中一种：\n\n    <color=yellow>%s银两<color>\n    <color=yellow>%s绑定银两<color>\n\n任选其一，您想兑换哪种？", it.szName, nGetMoney, nGetBindMoney)
  local tbOpt = {
    { "兑换银两", self.SureUse, self, it, 1 },
    { "兑换绑定银两", self.SureUse, self, it, 2 },
    { "我再考虑考虑" },
  }
  Dialog:Say(szMsg, tbOpt)
  return 0
end

function tbItem:SureUse(pItem, nType, nSure)
  if not pItem then
    return
  end
  local szItemName = pItem.szName
  local nIbValue = pItem.nBuyPrice
  local nGetMoney = self.GETMONEY[pItem.nLevel][nType]
  local nGetBindMoney = self.GETMONEY[pItem.nLevel][2]
  local szType = "银两"
  if nType == 2 then
    szType = "绑定银两"
  end
  if not nSure then
    local szMsg = string.format("您确定兑换<color=yellow>%s%s<color>吗？", nGetMoney, szType)
    local tbOpt = {
      { "确定领取", self.SureUse, self, pItem, nType, 1 },
      { "我再考虑考虑" },
    }
    Dialog:Say(szMsg, tbOpt)
    return 0
  end
  if nType == 1 then
    if me.nCashMoney + nGetMoney > me.GetMaxCarryMoney() then
      me.Msg("使用后，您身上的银两将会超过上限，请稍后再使用金条。")
      return 0
    end
  else
    if me.GetBindMoney() + nGetMoney + math.floor(self.ExReturnBindMoney * nGetBindMoney / 100) > me.GetMaxCarryMoney() then
      me.Msg("使用后，您身上的绑定银两将会超过上限，请稍后再使用金条。")
      return 0
    end
  end

  if me.DelItem(pItem, Player.emKLOSEITEM_JINTIAO) ~= 1 then
    Dbg:WriteLog(me.szName, "Del Item:", szItemName, "失败")
    return 0
  end
  if self.ExReturnBindMoney > 0 then
    me.AddBindMoney(math.floor(self.ExReturnBindMoney * nGetBindMoney / 100), Player.emKBINDMONEY_ADD_JITIAO)
    KStatLog.ModifyAdd("bindjxb", "[产出]金条开出", "总量", math.floor(self.ExReturnBindMoney * nGetBindMoney / 100))
  end

  local szMoneyType = "银两"
  if nType == 1 then
    me.Earn(nGetMoney, Player.emKEARN_TASK_JITIAO)
    Dbg:WriteLog(me.szName, "Use Item:", szItemName, "GetMoney:", nGetMoney)
    KStatLog.ModifyAdd("jxb", "[产出]金条开出", "总量", nGetMoney)
  else
    szMoneyType = "绑定" .. szMoneyType
    me.AddBindMoney(nGetMoney, Player.emKBINDMONEY_ADD_JITIAO)
    Spreader:AddConsume(nIbValue, 1, szItemName)
    KStatLog.ModifyAdd("bindjxb", "[产出]金条开出", "总量", nGetMoney)
  end

  Dbg:WriteLog("use jintiao", me.szAccount, me.szName, string.format("使用%s兑换%d%s", szItemName, nGetMoney, szMoneyType))
  me.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, string.format("%s使用%s获得了%d%s", me.szName, szItemName, nGetMoney, szMoneyType))
end
