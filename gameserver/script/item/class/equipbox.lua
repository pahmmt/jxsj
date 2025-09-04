local tbItem = Item:GetClass("equipbox")

tbItem.tbLevelDesc = {
  [6] = "60级",
  [7] = "70级",
  [8] = "80级",
  [9] = "90级",
  [10] = "100级",
}

tbItem.tbQualityDesc = {
  [1] = "中档手工制作装",
  [2] = "高档手工制作装",
}

tbItem.tbQianghuaDesc = {
  [0] = "未强化",
}
for i = 1, 16 do
  tbItem.tbQianghuaDesc[i] = i .. "级"
end

tbItem.tbSexDesc = {
  [0] = "男性",
  [1] = "女性",
}

tbItem.tbSexForbidEquip = {
  [0] = 5, -- 男性禁止选峨眉
  [1] = 1, -- 女性禁止选少林
}

function tbItem:LoadEquipList()
  local tbAddedItem = {}
  local tbItem_4pre = Lib:LoadTabFile("\\setting\\item\\equipgift\\giftequiplist_4pre.txt")
  if not tbItem_4pre or #tbItem_4pre == 0 then
    Dbg:WriteLog("加载百四装备列表失败")
    return nil
  end
  local tbItem_20pre = Lib:LoadTabFile("\\setting\\item\\equipgift\\giftequiplist_20pre.txt")
  if not tbItem_4pre or #tbItem_4pre == 0 then
    Dbg:WriteLog("加载百二十装备列表失败")
    return nil
  end
  tbAddedItem[1] = self:FilterTab(tbItem_20pre)
  tbAddedItem[2] = self:FilterTab(tbItem_4pre)
  return tbAddedItem
end

function tbItem:FilterTab(tbEquipTable)
  local tbEquip = {}
  for i = 1, Env.FACTION_NUM do
    tbEquip[i] = {} -- 门派
    for j = 1, 2 do
      tbEquip[i][j] = {} -- 路线
      for k = 0, 1 do
        tbEquip[i][j][k] = {} -- 性别
        for p = 1, 10 do
          tbEquip[i][j][k][p] = {} -- 装备位置
        end
      end
    end
  end
  for nIndex, tbTemp in ipairs(tbEquipTable) do
    tbEquip[tonumber(tbTemp["Faction"])][tonumber(tbTemp["RoutId"])][tonumber(tbTemp["Sex"]) - 1][tonumber(tbTemp["PartId"])][1] = tonumber(tbTemp["Genre"])
    tbEquip[tonumber(tbTemp["Faction"])][tonumber(tbTemp["RoutId"])][tonumber(tbTemp["Sex"]) - 1][tonumber(tbTemp["PartId"])][2] = tonumber(tbTemp["DetailType"])
    tbEquip[tonumber(tbTemp["Faction"])][tonumber(tbTemp["RoutId"])][tonumber(tbTemp["Sex"]) - 1][tonumber(tbTemp["PartId"])][3] = tonumber(tbTemp["ParticularType"])
    tbEquip[tonumber(tbTemp["Faction"])][tonumber(tbTemp["RoutId"])][tonumber(tbTemp["Sex"]) - 1][tonumber(tbTemp["PartId"])][4] = tonumber(tbTemp["Level"])
  end
  return tbEquip
end

function tbItem:OnUse()
  local nRes, nLevel, nQuality, nQianghua = self:CheckParam(it.dwId)
  if nRes == 0 then
    Dialog:Say("道具未知错误，请联系GM")
    return
  end
  local szMsg = string.format("打开该礼包可获取如下属性的一套<color=yellow>%s<color>装备：\n", self.tbSexDesc[me.nSex])
  szMsg = szMsg .. string.format("装备等级：<color=yellow>%s<color>\n", self.tbLevelDesc[nLevel])
  szMsg = szMsg .. string.format("装备品质：<color=yellow>%s<color>\n", self.tbQualityDesc[nQuality])
  szMsg = szMsg .. string.format("强化等级：<color=yellow>%s<color>\n\n", self.tbQianghuaDesc[nQianghua])
  szMsg = szMsg .. "确定打开？"
  local tbOpt = {
    { "确定", self.GetEquipFaction, self, it.dwId, 1 },
    { "我再考虑一下吧" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbItem:CheckParam(nItemId)
  local pItem = KItem.GetObjById(nItemId)
  if not pItem then
    return 0
  end
  local nLevel = pItem.GetExtParam(1) or 6 -- 等级
  local nQuality = pItem.GetExtParam(2) or 1 -- 橙装或紫装
  local nQianghua = pItem.GetExtParam(3) or 0 -- 强化
  if nQuality > 16 or nQuality < 0 or nLevel < 6 or nLevel > 10 or nQuality < 1 or nQuality > 2 then
    return 0
  end
  return 1, nLevel, nQuality, nQianghua
end

-- 获取装备的门派
function tbItem:GetEquipFaction(nItemId, nPosStartIdx)
  local nRes, nLevel, nQuality, nQianghua = self:CheckParam(nItemId)
  if nRes == 0 then
    return 0
  end
  local tbOpt = {}
  local nCount = 9
  for i = nPosStartIdx, Player.FACTION_NUM do
    if nCount <= 0 then
      tbOpt[#tbOpt] = { "下一页", self.GetEquipFaction, self, nItemId, i - 1 }
      break
    end

    if self.tbSexForbidEquip[me.nSex] ~= i then
      tbOpt[#tbOpt + 1] = { Player:GetFactionRouteName(i), self.GetEquipRoute, self, nItemId, i, 1 }
      nCount = nCount - 1
    end
  end
  tbOpt[#tbOpt + 1] = { "结束对话" }
  local szMsg = string.format("您可获得如下属性的一套<color=yellow>%s<color>装备：\n", self.tbSexDesc[me.nSex])
  szMsg = szMsg .. string.format("装备等级：<color=yellow>%s<color>\n", self.tbLevelDesc[nLevel])
  szMsg = szMsg .. string.format("装备品质：<color=yellow>%s<color>\n", self.tbQualityDesc[nQuality])
  szMsg = szMsg .. string.format("强化等级：<color=yellow>%s<color>\n\n", self.tbQianghuaDesc[nQianghua])
  szMsg = szMsg .. "请选择装备的门派"
  Dialog:Say(szMsg, tbOpt)
end

-- 获得装备所属的路线
function tbItem:GetEquipRoute(nItemId, nFactionId, nPosStartIdx)
  local nRes, nLevel, nQuality, nQianghua = self:CheckParam(nItemId)
  if nRes == 0 then
    return 0
  end
  local tbOpt = {}
  local nCount = 9
  for i = nPosStartIdx, #Player.tbFactions[nFactionId].tbRoutes do
    if nCount <= 0 then
      tbOpt[#tbOpt] = { "下一页", self.GetEquipRoute, self, nItemId, nFactionId, i - 1 }
      break
    end
    tbOpt[#tbOpt + 1] = { Player:GetFactionRouteName(nFactionId, i), self.GetEquip, self, nItemId, nFactionId, i }
    nCount = nCount - 1
  end
  tbOpt[#tbOpt + 1] = { "结束对话" }
  local szMsg = string.format("您可获得如下属性的一套<color=yellow>%s<color>装备：\n", self.tbSexDesc[me.nSex])
  szMsg = szMsg .. string.format("装备门派：<color=yellow>%s<color>\n", Player:GetFactionRouteName(nFactionId))
  szMsg = szMsg .. string.format("装备等级：<color=yellow>%s<color>\n", self.tbLevelDesc[nLevel])
  szMsg = szMsg .. string.format("装备品质：<color=yellow>%s<color>\n", self.tbQualityDesc[nQuality])
  szMsg = szMsg .. string.format("强化等级：<color=yellow>%s<color>\n\n", self.tbQianghuaDesc[nQianghua])
  szMsg = szMsg .. "请选择装备的门派路线"
  Dialog:Say(szMsg, tbOpt)
end

-- 获得装备
function tbItem:GetEquip(nItemId, nFactionId, nRouteId, nSure)
  local nRes, nLevel, nQuality, nQianghua = self:CheckParam(nItemId)
  if nRes == 0 then
    return 0
  end
  local pItem = KItem.GetObjById(nItemId)
  if not pItem then
    return 0
  end
  if not nSure then
    local szMsg = string.format("您可获得如下属性的一套<color=yellow>%s<color>装备：\n", self.tbSexDesc[me.nSex])
    szMsg = szMsg .. string.format("装备门派：<color=yellow>%s<color>\n", Player:GetFactionRouteName(nFactionId))
    szMsg = szMsg .. string.format("门派路线：<color=yellow>%s<color>\n", Player:GetFactionRouteName(nFactionId, nRouteId))
    szMsg = szMsg .. string.format("装备等级：<color=yellow>%s<color>\n", self.tbLevelDesc[nLevel])
    szMsg = szMsg .. string.format("装备品质：<color=yellow>%s<color>\n", self.tbQualityDesc[nQuality])
    szMsg = szMsg .. string.format("强化等级：<color=yellow>%s<color>\n\n", self.tbQianghuaDesc[nQianghua])
    szMsg = szMsg .. "确定获取？"
    local tbOpt = {
      { "确定获取", self.GetEquip, self, nItemId, nFactionId, nRouteId, 1 },
      { "我再考虑一下" },
    }
    Dialog:Say(szMsg, tbOpt)
    return 0
  end
  self.tbAddedItem = self.tbAddedItem or self:LoadEquipList()
  if not self.tbAddedItem then
    Dialog:Say("物品使用失败，请联系GM！")
    return 0
  end
  local tbEquip = self.tbAddedItem[nQuality][nFactionId][nRouteId][me.nSex]
  local tbTempEquip = {}
  for i = 1, #tbEquip do
    tbTempEquip[i] = {}
    tbTempEquip[i][1] = tbEquip[i][1]
    tbTempEquip[i][2] = tbEquip[i][2]
    tbTempEquip[i][3] = tbEquip[i][3] + nLevel - 10
    tbTempEquip[i][4] = tbEquip[i][4] + nLevel - 10
    tbTempEquip[i][5] = -1
  end
  if me.CountFreeBagCell() < #tbEquip then
    Dialog:Say(string.format("背包空间不足，请清理出<color=yellow>%s格<color>空间", #tbEquip))
    return 0
  end
  local szItemGDPL = string.format("(%s,%s,%s,%s)", pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel)
  me.DelItem(pItem)
  for i = 1, #tbTempEquip do
    local tbTmp = { unpack(tbTempEquip[i]) }
    tbTmp[6] = tbTmp[6] or nQianghua
    local pAddItem = me.AddItem(unpack(tbTmp))
    if pAddItem then
      pAddItem.Bind(1)
      local szAddItemGDPL = string.format("(%s,%s,%s,%s)", pAddItem.nGenre, pAddItem.nDetail, pAddItem.nParticular, pAddItem.nLevel)
      Dbg:WriteLog(string.format("%s打开了道具礼包%s获得了一件装备%s%s，强化等级：%s级", me.szName, szItemGDPL, pAddItem.szName, szAddItemGDPL, pAddItem.nEnhTimes))
    end
  end
end

-- 测试(级别：6-10，属性：1代表百20，2代表4%， 强化：1-16， 门派：1-13， 门派路线：1-2， 性别：0-1)
function tbItem:Test_AddEquit(nLevel, nQuality, nQiangHua, nFactionId, nRouteId, nSex)
  self.tbAddedItem = self.tbAddedItem or self:LoadEquipList()
  local tbEquip = self.tbAddedItem[nQuality][nFactionId][nRouteId][nSex]
  local tbTempEquip = {}
  for i = 1, #tbEquip do
    tbTempEquip[i] = {}
    tbTempEquip[i][1] = tbEquip[i][1]
    tbTempEquip[i][2] = tbEquip[i][2]
    tbTempEquip[i][3] = tbEquip[i][3] + nLevel - 10
    tbTempEquip[i][4] = tbEquip[i][4] + nLevel - 10
    tbTempEquip[i][5] = -1
  end
  if me.CountFreeBagCell() < #tbEquip then
    Dialog:Say(string.format("背包空间不足，请清理出<color=yellow>%s格<color>空间", #tbEquip))
    return 0
  end
  for i = 1, #tbTempEquip do
    local tbTmp = { unpack(tbTempEquip[i]) }
    tbTmp[6] = tbTmp[6] or nQiangHua
    local pAddItem = me.AddItem(unpack(tbTmp))
    if pAddItem then
      pAddItem.Bind(1)
    end
  end
end
