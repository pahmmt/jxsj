------------------------------------------------------
-- 文件名　：partner_c.lua
-- 创建者　：dengyong
-- 创建时间：2009-12-09 20:29:24
-- 描  述  ：同伴客户端
------------------------------------------------------
if not Partner then
  Partner = {}
end

Require("\\script\\partner\\loadfile.lua")

-- 对放入的物品进行类型检查
function Partner:CheckGiftItem(tbGiftSelf, pPickItem, pDropItem, nX, nY)
  local nTalentPointAdded = self:CalcTalentPointAdded(tbGiftSelf)

  local pPartner = me.GetPartner(me.nActivePartner)
  if not pPartner then
    return
  end
  local nCurTalent = pPartner.GetValue(Partner.emKPARTNERATTRIBTYPE_TALENT)
  local nTalentLevel = nCurTalent % 1000 -- nCurTalent = nTalentLevel*1000 + nTalentPoint
  local nTalentPoint = math.floor(nCurTalent / 1000)
  local szContent = ""

  if pDropItem then
    -- 判断要放入道具是否是指定的礼品
    local szIndex = string.format("%d_%d_%d_%d", pDropItem.nGenre, pDropItem.nDetail, pDropItem.nParticular, pDropItem.nLevel)
    if not self.tbItemTalentValue[szIndex] then
      me.Msg("该类型物品不能赠送给同伴。")
      return 0
    end

    local szBindValue = pDropItem.nBindType == 1 and "nBindValue" or "nUnBindValue"
    nTalentPointAdded = nTalentPointAdded + self.tbItemTalentValue[szIndex][szBindValue] * pDropItem.nCount

    if nTalentPointAdded > 0 then
      -- 这里传入的是领悟度价值量，第三个参数要为1
      local nNewLevel, nBalancPoint = self:GetTalentLevelAdded(pPartner, nTalentPointAdded, 1)

      szContent = string.format("无上智慧精华可在龙五太爷处拆解。该同伴<color=yellow>%s<color>当前的领悟度为<color=yellow>%d<color>,\n", pPartner.szName, nTalentLevel)
      szContent = szContent .. string.format("窗口中的礼品将使您的同领悟度提升至<color=yellow>%d<color>。", nNewLevel)
      if nNewLevel < self.TALENT_MAX then
        szContent = szContent .. "<color=green>若想把领悟度提升更高，可以放入更多的礼物。<color>"
      end
      --szContent = szContent.."\n<color=green>无上智慧精华液可在龙五太爷处拆解<color>";
    else
      szContent = self.szGiftContent
    end
  end
  if pPickItem then
    local szIndex = string.format("%d_%d_%d_%d", pPickItem.nGenre, pPickItem.nDetail, pPickItem.nParticular, pPickItem.nLevel)
    local szBindValue = pPickItem.nBindType == 1 and "nBindValue" or "nUnBindValue"
    nTalentPointAdded = nTalentPointAdded - self.tbItemTalentValue[szIndex][szBindValue] * pPickItem.nCount
    if nTalentPointAdded > 0 then
      local nNewLevel, nBalancPoint = self:GetTalentLevelAdded(pPartner, nTalentPointAdded)

      szContent = string.format("无上智慧精华可在龙五太爷处拆解。该同伴<color=yellow>%s<color>当前的领悟度为<color=yellow>%d<color>,\n", pPartner.szName, nTalentLevel)
      szContent = szContent .. string.format("窗口中的礼品将使您的同领悟度提升至<color=yellow>%d<color>。", nNewLevel)
      if nNewLevel < self.TALENT_MAX then
        szContent = szContent .. "<color=green>若想把领悟度提升更高，可以放入更多的礼物。<color>"
      end
      --szContent = szContent.."\n<color=green>无上智慧精华液可在龙五太爷处拆解<color>";
    else
      szContent = self.szGiftContent
    end
  end

  tbGiftSelf:UpdateContent(szContent)
  return 1
end

-- 计算给予界面的物品能添加的领悟度总和
function Partner:CalcTalentPointAdded(tbGift)
  local pItem = tbGift:First()
  local nTalentPointAdded = 0
  while pItem do
    local szIndex = string.format("%s_%s_%s_%s", pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel)
    if self.tbItemTalentValue[szIndex] then
      local szBindValue = pItem.nBindType == 1 and "nBindValue" or "nUnBindValue"
      nTalentPointAdded = nTalentPointAdded + self.tbItemTalentValue[szIndex][szBindValue] * pItem.nCount
    end

    pItem = tbGift:Next()
  end

  return nTalentPointAdded
end

-- 升到下一级需要多少经验
function Partner:GetNeedLevel(nLevel)
  if nLevel >= 120 then
    return 0
  end
  return self.tbLevelSetting[nLevel].nExp
end

-- 月影商店的客户端回调
function Partner:MoonStoneCheckFun(tbGiftSelf, pPickItem, pDropItem, nX, nY, tbParam)
  -- 放入/取出道具前的月影之石个数
  local nItemCount = self:GetMoonStoneCount(tbGiftSelf)
  --Lib:ShowTB(tbParam);

  if pDropItem then
    if not (pDropItem.nGenre == self.tbMoonStone.nGenre and pDropItem.nDetail == self.tbMoonStone.nDetail and pDropItem.nParticular == self.tbMoonStone.nParticular and pDropItem.nLevel == self.tbMoonStone.nLevel) then
      me.Msg("只能放入月影之石。")
      return 0
    end

    nItemCount = nItemCount + pDropItem.nCount
  end

  if pPickItem then
    nItemCount = nItemCount - pPickItem.nCount
    if nItemCount <= 0 then
      tbGiftSelf:UpdateContent(tbParam.szTip)
      return 1
    end
  end

  local nExchangeCount = math.floor(nItemCount / tbParam.nCount) -- 能兑换的成品道具个数
  local nBalancCount = nItemCount - nExchangeCount * tbParam.nCount -- 剩余的月影之石个数

  local szMsg = string.format("兑换一个<color=yellow>%s<color>需要<color=yellow>%d<color>个月影之石。您当前放入了<color=yellow>%d<color>个月影之石，将会得到<color=yellow>%d<color>个<color=yellow>%s<color>", tbParam.szName, tbParam.nCount, nItemCount, nExchangeCount, tbParam.szName)
  if nBalancCount > 0 then
    szMsg = szMsg .. string.format("，<color=green>（还剩余%d个月影之石，将返还给您）<color>。", nBalancCount)
  else
    szMsg = szMsg .. "。"
  end

  tbGiftSelf:UpdateContent(szMsg)
  return 1
end

-- 获得月影商店给予界面中的道具个数
function Partner:GetMoonStoneCount(tbGiftSelf)
  local nCount = 0
  local pItem = tbGiftSelf:First()
  while pItem do
    nCount = nCount + pItem.nCount
    pItem = tbGiftSelf:Next()
  end

  return nCount
end

-- 取得查看玩家当前激活同伴的信息
function Partner:GetViewPartnerInfo_c(szName, nLevel, nStarLevel, tbPotential, tbSkill)
  CoreEventNotify(UiNotify.emCOREEVENT_VIEW_PLAYERPARTNER, szName, nLevel, nStarLevel, tbPotential, tbSkill)
end

-- 检查放入的装备是否是同伴装备，只需要对当前放入的装备做检查就可以了
function Partner:ChcekPartnerEquip(tbGiftSelf, pPickItem, pDropItem, nX, nY, nParam)
  local nType = nParam -- 类型，0为解绑，1为申绑

  -- 放入的时候只能放入同伴装备
  if pDropItem then
    -- 解绑时只能放入一件装备
    if nType == 0 then
      local pItem = tbGiftSelf:First()
      if pItem then
        me.Msg("一次只能解绑一件已绑定的同伴装备！")
        return 0
      end

      if pDropItem.IsBind() == 0 then
        me.Msg("只能放入已绑定的同伴装备！")
        return 0
      end
    elseif nType == 1 then -- 申绑同伴装备
      if pDropItem.IsPartnerEquip() == 0 then
        me.Msg("只能放入同伴装备！")
        return 0
      end
    end
  end

  return 1
end

function Partner:PlayerConvertAnimate(bPlay)
  Ui(Ui.UI_PARTNER):PlayerAnimate(bPlay)
end

function Partner:SwitchUnBind_Check(pDropItem)
  local nPos = pDropItem.nEquipPos
  if nPos < Item.EQUIPPOS_NUM or nPos > Item.EQUIPPOS_NUM + Item.PARTNEREQUIP_NUM then
    return 0
  end

  nPos = nPos - Item.EQUIPPOS_NUM
  local pItem = me.GetItem(Item.ROOM_PARTNEREQUIP, nPos, 0)
  if pItem and pItem.dwId == pDropItem.dwId then
    me.Msg("装备着的同伴装备不能解绑！")
    return 0
  end

  return 1
end
