-----------------------------------------------------
--文件名		：	fightpower.lua
--创建者		：	zhoupengfeng
--创建时间		：	2010-06-28
--功能描述		：	战斗力
------------------------------------------------------

local uiFightPower = Ui:GetClass("fightpower")

local MAX_ENHTIMES = 16

-- 战斗力主页
uiFightPower.BTN_CLOSE = "BtnClose" -- 关闭按钮
uiFightPower.PAGE_SET_MAIN = "PageSetMain" -- 分页集
uiFightPower.PAGE_MAIN = { -- 	页按钮				页名
  { "BtnPageTotal", "PageTotal" },
  { "BtnPageEquip", "PageEquip" },
  --{ "BtnPagePartner", 	"PagePartner", },
}
uiFightPower.TXT_INSTRUCTION = "TxtInstruction" -- 简要说明

-- 总战斗力
uiFightPower.TXT_TOTAL_POWER = "TxtTotalPower" -- 总战斗力值
uiFightPower.TXT_RANK = "TxtTotalPowerRank" -- 排名
uiFightPower.BTN_LADDER = "BtnLadder" -- 排行榜
uiFightPower.OUTLOOK_TOTAL_POWER = "OutLookTotalPower" -- 展开面板

-- 装备详情
uiFightPower.SCROLL_EQUIP = "ScrollEquip" -- 滑动面板
uiFightPower.PAGE_SET_EQUIP = "PageSetEquip" -- 装备详情分页集
uiFightPower.PAGE_EQUIP = { -- 	页按钮					 页名
  { "BtnPageUsedEquip", "PageUsedEquip" },
  { "BtnPageReservedEquip", "PageReservedEquip" },
  { "BtnPageExpandEquip", "PageExpandedEquip" },
}
-- 备用装备
uiFightPower.WND_EQUIP_LIST_RE = { -- 装备类名			 强化战斗力
  { "TxtHatR", "ProgHatR", "TxtProgHatR", nPos = Item.EQUIPEXPOS_HEAD },
  { "TxtBodyR", "ProgBodyR", "TxtProgBodyR", nPos = Item.EQUIPEXPOS_BODY },
  { "TxtBeltR", "ProgBeltR", "TxtProgBeltR", nPos = Item.EQUIPEXPOS_BELT },
  { "TxtBracerR", "ProgBracerR", "TxtProgBracerR", nPos = Item.EQUIPEXPOS_CUFF },
  { "TxtShoeR", "ProgShoeR", "TxtProgShoeR", nPos = Item.EQUIPEXPOS_FOOT },
  { "TxtWeaponR", "ProgWeaponR", "TxtProgWeaponR", nPos = Item.EQUIPEXPOS_WEAPON },
  { "TxtNecklaceR", "ProgNecklaceR", "TxtProgNecklaceR", nPos = Item.EQUIPEXPOS_NECKLACE },
  { "TxtRingR", "ProgRingR", "TxtProgRingR", nPos = Item.EQUIPEXPOS_RING },
  { "TxtPendantR", "ProgPendantR", "TxtProgPendantR", nPos = Item.EQUIPEXPOS_PENDANT },
  { "TxtAmuletR", "ProgAmuletR", "TxtProgAmuletR", nPos = Item.EQUIPEXPOS_AMULET },
}
-- 战魂装备
uiFightPower.WND_EQUIP_LIST_EX = { -- 装备类名			 强化战斗力
  { "TxtHatE", "ProgHatE", "TxtProgHatE", nPos = Item.EQUIPEXPOS_HEAD },
  { "TxtBodyE", "ProgBodyE", "TxtProgBodyE", nPos = Item.EQUIPEXPOS_BODY },
  { "TxtBeltE", "ProgBeltE", "TxtProgBeltE", nPos = Item.EQUIPEXPOS_BELT },
  { "TxtBracerE", "ProgBracerE", "TxtProgBracerE", nPos = Item.EQUIPEXPOS_CUFF },
  { "TxtShoeE", "ProgShoeE", "TxtProgShoeE", nPos = Item.EQUIPEXPOS_FOOT },
  { "TxtWeaponE", "ProgWeaponE", "TxtProgWeaponE", nPos = Item.EQUIPEXPOS_WEAPON },
  { "TxtNecklaceE", "ProgNecklaceE", "TxtProgNecklaceE", nPos = Item.EQUIPEXPOS_NECKLACE },
  { "TxtRingE", "ProgRingE", "TxtProgRingE", nPos = Item.EQUIPEXPOS_RING },
  { "TxtPendantE", "ProgPendantE", "TxtProgPendantE", nPos = Item.EQUIPEXPOS_PENDANT },
  { "TxtAmuletE", "ProgAmuletE", "TxtProgAmuletE", nPos = Item.EQUIPEXPOS_AMULET },
}
-- 当前装备
uiFightPower.WND_EQUIP_LIST_USED = { -- 装备类名		 装备战斗力				炼化战斗力					强化战斗力进度	进度条文字
  { "TxtHat", "TxtBasePowerHat", "TxtRefinePowerHat", "TxtStonPowerHat", "ProgHat", "TxtProgHat", nPos = Item.EQUIPPOS_HEAD },
  { "TxtBody", "TxtBasePowerBody", "TxtRefinePowerBody", "TxtStonPowerBody", "ProgBody", "TxtProgBody", nPos = Item.EQUIPPOS_BODY },
  { "TxtBelt", "TxtBasePowerBelt", "TxtRefinePowerBelt", "TxtStonPowerBelt", "ProgBelt", "TxtProgBelt", nPos = Item.EQUIPPOS_BELT },
  { "TxtBracer", "TxtBasePowerBracer", "TxtRefinePowerBracer", "TxtStonPowerBracer", "ProgBracer", "TxtProgBracer", nPos = Item.EQUIPPOS_CUFF },
  { "TxtShoe", "TxtBasePowerShoe", "TxtRefinePowerShoe", "TxtStonPowerShoe", "ProgShoe", "TxtProgShoe", nPos = Item.EQUIPPOS_FOOT },
  { "TxtWeapon", "TxtBasePowerWeapon", "TxtRefinePowerWeapon", "TxtStonPowerWeapon", "ProgWeapon", "TxtProgWeapon", nPos = Item.EQUIPPOS_WEAPON },
  { "TxtNecklace", "TxtBasePowerNecklace", "TxtRefinePowerNecklace", "TxtStonPowerNecklace", "ProgNecklace", "TxtProgNecklace", nPos = Item.EQUIPPOS_NECKLACE },
  { "TxtRing", "TxtBasePowerRing", "TxtRefinePowerRing", "TxtStonPowerRing", "ProgRing", "TxtProgRing", nPos = Item.EQUIPPOS_RING },
  { "TxtPendant", "TxtBasePowerPendant", "TxtRefinePowerPendant", "TxtStonPowerPendant", "ProgPendant", "TxtProgPendant", nPos = Item.EQUIPPOS_PENDANT },
  { "TxtAmulet", "TxtBasePowerAmulet", "TxtRefinePowerAmulet", "TxtStonPowerAmulet", "ProgAmulet", "TxtProgAmulet", nPos = Item.EQUIPPOS_AMULET },
  { "TxtMantle", "TxtBasePowerMantle", nPos = Item.EQUIPPOS_MANTLE }, -- 披风
  { "TxtSignet", "TxtBasePowerSignet", nPos = Item.EQUIPPOS_SIGNET }, -- 印鉴-五行印
  { "TxtMiJi", "TxtBasePowerMiJi", nPos = Item.EQUIPPOS_BOOK }, -- 秘籍
  { "TxtZhenFa", "TxtBasePowerZhenFa", nPos = Item.EQUIPPOS_ZHEN }, -- 阵法
  { "TxtChop", "TxtBasePowerChop", nPos = Item.EQUIPPOS_CHOP }, -- 官印
}

-- 战魂装备(可能不需要)
uiFightPower.TXT_EXPAND_EQUIP = { -- 强化战斗力系数
  --{ "TxtEnhancePowerFactor"
}

function uiFightPower:Init()
  self.m_nPageNum = 2 -- 页面总数
  self.m_nCurPageIndex = 1 -- 当前页
  self.tbEquipRoomInfo = -- 用来获取装备战斗力
    { -- 		 装备类型		道具容器号
      { szSuitName = "当前装备", nRoomId = Item.ROOM_EQUIP, tbSuit = self.WND_EQUIP_LIST_USED },
      { szSuitName = "备用装备", nRoomId = Item.ROOM_EQUIPEX, tbSuit = self.WND_EQUIP_LIST_RE },
      { szSuitName = "战魂装备", nRoomId = Item.ROOM_EQUIPEX2, tbSuit = self.WND_EQUIP_LIST_EX },
    }
  self.tbInstruction = {
    tbTotal = { "真元", "装被", "同伴", "成就", "等级" },
    tbEquip = {},
  }
  --self:LoadInstructionText();
end

function uiFightPower:OnOpen()
  self:LoadInstructionText()
  if not self.bLoadInstruction then
    self.bLoadInstruction = 1
  end
  self.m_nCurPageIndex = 1
  self:UpdatePageMain()
end

function uiFightPower:UpdatePageMain()
  if 1 == self.m_nCurPageIndex then
    self:UpdatePageTotalPower()
  elseif 2 == self.m_nCurPageIndex then
    self.nEquipCurPageIndex = 1
    self:UpdatePageEquip()
    --elseif 3 == self.m_nCurPageIndex then
    --	self.UpdatePagePartner();
  end
  PgSet_ActivePage(self.UIGROUP, self.PAGE_SET_MAIN, self.PAGE_MAIN[self.m_nCurPageIndex][2])
end

function uiFightPower:UpdatePageTotalPower()
  self:ShowOutlookWnd()
  -- 总战斗力数值
  Txt_SetTxt(self.UIGROUP, self.TXT_TOTAL_POWER, self:FormatValue(self.nTotalFightPower))

  -- 总战斗力排名
  local nRank = Player.tbFightPower:GetRank(me)
  local szRank = ((0 ~= nRank) and ("第" .. nRank .. "名") or "未上榜")
  Txt_SetTxt(self.UIGROUP, self.TXT_RANK, szRank)

  Txt_SetTxt(self.UIGROUP, self.TXT_INSTRUCTION, self.tbInstruction[1][0])
end

function uiFightPower:OnOutLookItemSelected(szWndName, nGroupIndex, nItemIndex)
  self.nCurGroupId = nGroupIndex
  if not self.tbInstruction then
    return
  end
  Txt_SetTxt(self.UIGROUP, self.TXT_INSTRUCTION, self.tbInstruction[1][nGroupIndex + 1])
end

--  初始化总战斗力OUTLOOK 控件
function uiFightPower:ShowOutlookWnd()
  OutLookPanelClearAll(self.UIGROUP, self.OUTLOOK_TOTAL_POWER)
  AddOutLookPanelColumnHeader(self.UIGROUP, self.OUTLOOK_TOTAL_POWER, "")
  AddOutLookPanelColumnHeader(self.UIGROUP, self.OUTLOOK_TOTAL_POWER, "")
  AddOutLookPanelColumnHeader(self.UIGROUP, self.OUTLOOK_TOTAL_POWER, "")
  SetOutLookHeaderWidth(self.UIGROUP, self.OUTLOOK_TOTAL_POWER, 0, 120)
  SetOutLookHeaderWidth(self.UIGROUP, self.OUTLOOK_TOTAL_POWER, 1, 120)
  SetOutLookHeaderWidth(self.UIGROUP, self.OUTLOOK_TOTAL_POWER, 2, 50)
  local tbSet = self:GetTotalFightPowerInfo()
  if not tbSet then
    return
  end
  for i = 1, #tbSet do
    AddOutLookGroup(self.UIGROUP, self.OUTLOOK_TOTAL_POWER, tbSet[i].szName)
    local tbContent = tbSet[i].tbContent
    if tbContent then
      for j = 1, #tbContent do
        local nRet = AddOutLookItem(self.UIGROUP, self.OUTLOOK_TOTAL_POWER, i - 1, tbContent[j])
      end
      if i ~= 1 then
        SetGroupCollapseState(self.UIGROUP, self.OUTLOOK_TOTAL_POWER, i - 1, 0)
      end
    end
    --Txt_SetTxt(self.UIGROUP, "Txt", self.nTotalFightPower);
  end
end

function uiFightPower:GetTotalFightPowerInfo()
  local tbInfo = {}
  self.nTotalFightPower = 0

  for i = 1, 5 do
    local tbGroup = {}
    if 1 == i then
      local nTotalSum = 0
      nTotalSum, tbGroup.tbContent = self:GetZhenyuanInfo()
      local szSum = self:FormatValue(nTotalSum)
      tbGroup.szName = self:GetFormatString("真元", szSum, "")
      self.nTotalFightPower = self.nTotalFightPower + nTotalSum
    elseif 2 == i then
      local nTotalSum = 0
      nTotalSum, tbGroup.tbContent = self:GetEquipFightPowerSum()
      local szSum = self:FormatValue(nTotalSum)
      tbGroup.szName = self:GetFormatString("装备", szSum, "")
      self.nTotalFightPower = self.nTotalFightPower + nTotalSum
    elseif 3 == i then
      local nTotalSum = 0
      nTotalSum, tbGroup.tbContent = self:GetPartnerInfo()
      local szSum = self:FormatValue(nTotalSum)
      tbGroup.szName = self:GetFormatString("同伴", szSum, "")
      self.nTotalFightPower = self.nTotalFightPower + nTotalSum
    elseif 4 == i then
      local nAchievPower = Player.tbFightPower:GetPlayerAchievementPoint(me)
      local nAchievRank = Player.tbFightPower:GetAchievementRank(me) --todo
      local szAchievRank = ((0 == nAchievRank) and "未上榜") or ("第" .. nAchievRank .. "名")
      local szResult = self:FormatValue(nAchievPower)
      tbGroup.szName = self:GetFormatString("成就", szResult, "")
      tbGroup.tbContent = {}
      tbGroup.tbContent[1] = { "成就", "+" .. nAchievPower, szAchievRank }
      self.nTotalFightPower = self.nTotalFightPower + nAchievPower
    elseif 5 == i then
      local nLevelPower = Player.tbFightPower:GetPlayerLevelPoint(me)
      local nLevelRank = Player.tbFightPower:GetLevelRank(me) --todo
      local szLevelRank = ((0 == nLevelRank) and "未上榜") or ("第" .. nLevelRank .. "名")
      local szResult = self:FormatValue(nLevelPower)
      tbGroup.szName = self:GetFormatString("等级", szResult, "")
      tbGroup.tbContent = {}
      tbGroup.tbContent[1] = { "等级", "+" .. nLevelPower, szLevelRank }
      self.nTotalFightPower = self.nTotalFightPower + nLevelPower
    end
    tbInfo[i] = tbGroup
  end
  return tbInfo
end

function uiFightPower:GetFormatString(szPre, szMid, szSuf)
  if UiVersion == Ui.Version001 then
    local nSize = 30
    local szResult = "  " .. szPre
    local nPreLen = #szResult
    for i = 1, 21 - nPreLen do
      szResult = szResult .. " "
    end
    local nMidLen = #szMid
    szResult = szResult .. szMid
    for i = 1, 20 - nMidLen do
      szResult = szResult .. " "
    end
    szResult = szResult .. szSuf
    local nSufLen = #szResult
    for i = 1, 55 - nSufLen do
      szResult = szResult .. " "
    end
    return szResult
  end
  return szPre .. "  " .. szMid
end

-- 真元战斗力及排名
function uiFightPower:GetZhenyuanInfo()
  local nTotalPower = 0
  local tbZhenyuanInfo = nil

  local tbFind = {}
  -- 先取装备上的
  tbFind = me.FindClassItem(Item.ROOM_EQUIP, "zhenyuan") -- 装备栏
  for _, tbFind in pairs(tbFind) do
    if not tbZhenyuanInfo then
      tbZhenyuanInfo = {}
    end
    local pItem = tbFind.pItem
    local szName = pItem.szName
    local nFightPower = Item.tbZhenYuan:GetFightPower(pItem) -- 取战斗力
    local nRank = Item.tbZhenYuan:GetRank(pItem) -- 取排名
    local szFightPower = string.format("%d", nFightPower)
    local szRank
    if nRank == 0 then
      szRank = "未上榜"
    else
      szRank = string.format("第%d名", nRank)
    end
    local tbItem = { szName, szFightPower, szRank }
    table.insert(tbZhenyuanInfo, tbItem)
    nTotalPower = nTotalPower + nFightPower
  end

  tbFind = me.FindClassItemOnPlayer("zhenyuan") -- 背包，仓库
  for _, tbFind in pairs(tbFind) do
    if not tbZhenyuanInfo then
      tbZhenyuanInfo = {}
    end
    local pItem = tbFind.pItem
    local szName = pItem.szName
    local nRank = Item.tbZhenYuan:GetRank(pItem) -- 取排名
    local szRank = string.format("第%d名", nRank)
    if nRank == 0 then
      szRank = "未上榜"
    else
      szRank = string.format("第%d名", nRank)
    end
    local tbItem = { szName, "未装备", szRank }
    table.insert(tbZhenyuanInfo, tbItem)
  end

  if not tbZhenyuanInfo then
    tbZhenyuanInfo = { { "您目前没有真元", "", "" } }
  end

  return nTotalPower, tbZhenyuanInfo
end

-- 装备总战斗力
function uiFightPower:GetEquipFightPowerSum()
  if not self.tbEquipRoomInfo then
    return {}
  end
  local tbEquipFightPowerSum = {} --{ {"当前装备", "+26", ""} };
  local nTotalSum = 0
  for i = 1, #self.tbEquipRoomInfo do
    local tbEquipInfo = {}
    local nCumulateFightPower = 0
    local nRoomIndex = self.tbEquipRoomInfo[i].nRoomId
    local tbSuit = self.tbEquipRoomInfo[i].tbSuit
    -- 每次都要计算和
    for j = 1, #tbSuit do
      local pItem = me.GetItem(nRoomIndex, tbSuit[j].nPos, 0)
      if pItem then
        nCumulateFightPower = nCumulateFightPower + self:GetSingleFightPower(pItem, i, j)
        --print(i..": "..j.." "..tbSuit[j][1].." "..self:GetSingleFightPower(pItem, i, j)..", 和："..nCumulateFightPower);
      end
    end
    tbEquipInfo[1] = self.tbEquipRoomInfo[i].szSuitName -- 装备套名称
    tbEquipInfo[2] = self:FormatValue(nCumulateFightPower) -- 对应装备套的总战斗
    tbEquipInfo[3] = ""

    tbEquipFightPowerSum[i] = tbEquipInfo
    nTotalSum = nTotalSum + nCumulateFightPower
  end
  return nTotalSum, tbEquipFightPowerSum
end

function uiFightPower:GetSingleFightPower(pItem, nEquipType, nEquipId)
  if not pItem then
    return nil
  end
  local nValue
  if 2 == nEquipType then -- 备用装备
    nValue = pItem.CalcExtraFightPower(pItem.nEnhTimes, 0)
  elseif 3 == nEquipType then -- 战魂装备
    nValue = pItem.CalcExtraFightPower(pItem.nEnhTimes, 0) / 2
  else -- 当前装备
    if 11 > nEquipId then
      -- 一般防具与武器
      nValue = pItem.CalcFightPower()
    else
      -- 披风、秘籍等特殊物
      nValue = self:GetSpecEquipPower(nEquipId)
    end
  end
  return nValue
end

-- 同伴战斗力
function uiFightPower:GetPartnerInfo()
  local tbAllPartner = {}
  local tbPartnerFightPower = {}
  local nTotalPower = 0
  local nActivePower = 0
  for i = 1, me.nPartnerCount do
    local nPartnerId = i - 1
    local tbPartnerInfo = {}
    local pPartner = me.GetPartner(nPartnerId)
    if not pPartner then
      print("Failed to find partner: me.GetPartner(" .. nPartnerId .. ")")
      break
    end
    local nFightPower = Player.tbFightPower:GetPartnerFightPower(pPartner, me)
    if nPartnerId == me.nActivePartner then
      --nFightPower = nFightPower + Player.tbFightPower:GetPartnerEquipPower(me); -- 暂时不加同伴装备 2010.09.25
      nFightPower = nFightPower
    end

    table.insert(tbPartnerFightPower, { nFightPower, i })

    tbPartnerInfo[1] = pPartner.szName
    tbPartnerInfo[2] = self:FormatValue(nFightPower)
    tbPartnerInfo[3] = ((nPartnerId == me.nActivePartner) and "出手") or "未出手"

    tbAllPartner[i] = tbPartnerInfo
  end

  table.sort(tbPartnerFightPower, function(a, b)
    return a[1] > b[1]
  end)

  for i, tbInfo in pairs(tbPartnerFightPower) do
    local nPower = tbInfo[1]
    local nIndex = tbInfo[2]

    if i <= Partner.VALUE_CALC_MAX_NUM then
      nTotalPower = nTotalPower + nPower
    else
      tbAllPartner[nIndex][2] = self:FormatValue(0)
      tbAllPartner[nIndex][3] = "不计入"
    end
  end

  if 0 == #tbAllPartner then
    tbAllPartner[1] = { "您目前没有同伴", "", "" }
  end
  return nTotalPower, tbAllPartner
end

function uiFightPower:UpdatePageEquip()
  if 1 == self.nEquipCurPageIndex then
    self:UpdatePageEquipUsed()
  elseif 2 == self.nEquipCurPageIndex then
    self:UpdatePageEquipReserved()
  elseif 3 == self.nEquipCurPageIndex then
    self:UpdatePageEquipExpand()
  end
  PgSet_ActivePage(self.UIGROUP, self.PAGE_SET_EQUIP, self.PAGE_EQUIP[self.nEquipCurPageIndex][2])
end

-- 当前装备的战斗力列表
function uiFightPower:UpdatePageEquipUsed()
  local tbData = self:GetUsedEquipData()
  local tbWnd = self.WND_EQUIP_LIST_USED
  for i = 1, #tbWnd do
    Wnd_SetTip(self.UIGROUP, tbWnd[i][1], tbData[i][1]) -- Tips显示装备的名称
    Txt_SetTxt(self.UIGROUP, tbWnd[i][2], tbData[i][2]) -- 装备的基本战斗力
    if 11 > i then
      Txt_SetTxt(self.UIGROUP, tbWnd[i][3], tbData[i][3]) -- 装备的炼化战斗力
      Txt_SetTxt(self.UIGROUP, tbWnd[i][4], tbData[i][4]) -- 装备上宝石的战斗力
      Prg_SetPos(self.UIGROUP, tbWnd[i][5], tbData[i][5]) -- 进度条
      Txt_SetTxt(self.UIGROUP, tbWnd[i][6], tbData[i][6]) -- 进度条文字
      Wnd_SetTip(self.UIGROUP, tbWnd[i][6], tbData[i][7]) -- Tips强化
    end
  end
  Txt_SetTxt(self.UIGROUP, self.TXT_INSTRUCTION, self.tbInstruction[2][1])
end

function uiFightPower:GetUsedEquipData()
  local tbData = {}

  for i = 1, #self.WND_EQUIP_LIST_USED do
    local tbCloth = {}
    local pItem = me.GetItem(Item.ROOM_EQUIP, self.WND_EQUIP_LIST_USED[i].nPos, 0)
    if not pItem then
      --print("[used equip]Failed to find item: me.GetItem("..Item.ROOM_EQUIP..", "..self.WND_EQUIP_LIST_USED[i].nPos..")");
      --break;
    end
    tbCloth[1] = (pItem and pItem.szName) or "未装备"
    if 11 > i then
      tbCloth[2] = (pItem and (self:FormatValue(pItem.nFightPower + pItem.CalcExFightPower()))) or "--"
      tbCloth[3] = (pItem and (self:FormatValue(pItem.CalcExtraFightPower(0)))) or "--"
      local nCurEnhPower = 0
      local nMaxEnhPower = 0
      local nNxtEnhPower = nil
      local nNxtEnhTimes = nil
      local szEnhTip = ""
      if pItem then
        local nEnhaceMaxTimes = Item:CalcMaxEnhanceTimes(pItem) -- 最高强化次数
        nCurEnhPower = pItem.CalcExtraFightPower(pItem.nEnhTimes, 0)
        nMaxEnhPower = pItem.CalcExtraFightPower(nEnhaceMaxTimes, 0)

        nNxtEnhTimes = pItem.nEnhTimes + 1
        if nEnhaceMaxTimes == nNxtEnhTimes then
          nNxtEnhTimes = nEnhaceMaxTimes
          nNxtEnhPower = nMaxEnhPower
        else
          nNxtEnhTimes, nNxtEnhPower = self:GetNextEnhancPowerLevel(pItem, pItem.nEnhTimes, nCurEnhPower)
        end

        szEnhTip = "[当前]<enter>" .. "强化+" .. pItem.nEnhTimes .. " 效果：战斗力" .. self:FormatValue(nCurEnhPower)
        local bMaxEnhPower = nCurEnhPower >= nMaxEnhPower
        if 1 ~= pItem.IsWhite() then
          if not bMaxEnhPower then
            if nNxtEnhTimes and pItem.nEnhTimes ~= nEnhaceMaxTimes then
              szEnhTip = (szEnhTip .. "<color=green><enter>[下一档]<enter>强化+" .. nNxtEnhTimes .. " 效果：战斗力" .. self:FormatValue(nNxtEnhPower) .. "<color>")
            end
            szEnhTip = szEnhTip .. "<color=red><enter><enter>[最高]<enter>强化+" .. nEnhaceMaxTimes .. " 效果：战斗力" .. self:FormatValue(nMaxEnhPower) .. "<color>"
          end
        else
          nMaxEnhPower = 0
          bMaxEnhPower = true
        end
        if bMaxEnhPower then
          szEnhTip = szEnhTip .. "<enter><color=red>已达到最高点数<color>"
        end
        if nEnhaceMaxTimes ~= MAX_ENHTIMES then
          szEnhTip = szEnhTip .. "<enter><enter><color=green>高等级可用强16装备，战斗力+" .. pItem.CalcExtraFightPower(MAX_ENHTIMES, 0) .. "<color>"
        end
      end
      tbCloth[4] = (pItem and (self:FormatValue(pItem.CalcStoneFightPower()))) or "--"
      tbCloth[5] = (pItem and (nCurEnhPower / nMaxEnhPower * 1000)) or 0
      tbCloth[6] = (pItem and (self:FormatValue(nCurEnhPower, nMaxEnhPower))) or "--/--"

      tbCloth[7] = (pItem and szEnhTip) or "未装备"
    else
      -- 披风等特殊装备
      local szValue = "--"
      if pItem then
        szValue = self:FormatValue((self:GetSpecEquipPower(i)))
      end
      tbCloth[2] = szValue
    end

    tbData[i] = tbCloth
  end
  return tbData
end

function uiFightPower:GetNextEnhancPowerLevel(pItem, nNowEnhanceTimes, nNowEnhanceFightPower)
  if not pItem then
    return nil, nil
  end
  local nEnhaceMaxTimes = Item:CalcMaxEnhanceTimes(pItem) -- 最高强化次数
  if nNowEnhanceTimes > nEnhaceMaxTimes then
    return nil, nil
  end
  local nEnhTimes = nNowEnhanceTimes
  local nEnhFightPower = nNowEnhanceFightPower
  local nFactor = Item.tbEnhanceOfEquipPos[pItem.nEquipPos] or 1
  for i = (nNowEnhanceTimes + 1), nEnhaceMaxTimes do
    nEnhTimes = i
    nEnhFightPower = Item.tbEnhanceFightPower[nEnhTimes] * nFactor
    if nEnhFightPower > nNowEnhanceFightPower then
      return nEnhTimes, nEnhFightPower
    end
  end
  return nil, nil
end

function uiFightPower:GetSpecEquipPower(nEquipId)
  local nValue = nil
  if 11 == nEquipId then -- 披风
    nValue = Player.tbFightPower:GetPiFengPower(me)
  elseif 12 == nEquipId then -- 五行印
    nValue = Player.tbFightPower:Get5XingYinPower(me)
  elseif 13 == nEquipId then -- 秘籍
    nValue = Player.tbFightPower:GetMiJiPower(me)
  elseif 14 == nEquipId then -- 阵法
    nValue = Player.tbFightPower:GetZhenFaPower(me)
  elseif 15 == nEquipId then -- 官印
    nValue = Player.tbFightPower:GetGuanYinPower(me)
  end
  return nValue
end

function uiFightPower:UpdatePageEquipReserved()
  self.tbCurWndList = self.WND_EQUIP_LIST_RE
  self:UpdatePageEquipEx(Item.ROOM_EQUIPEX, self.WND_EQUIP_LIST_RE, 1)
  Txt_SetTxt(self.UIGROUP, self.TXT_INSTRUCTION, self.tbInstruction[2][2])
end

function uiFightPower:UpdatePageEquipEx(nRoomId, tbWndList, nParam)
  local tbData = self:GetEquipDataEx(nRoomId, tbWndList, nParam)
  local tbWnd = self.tbCurWndList
  for i = 1, #tbWnd do
    -- todo
    Wnd_SetTip(self.UIGROUP, tbWnd[i][1], tbData[i][1]) -- Tips显示装备的名称
    Prg_SetPos(self.UIGROUP, tbWnd[i][2], tbData[i][2]) -- 进度条
    Txt_SetTxt(self.UIGROUP, tbWnd[i][3], tbData[i][3]) -- 进度条文字
    Wnd_SetTip(self.UIGROUP, tbWnd[i][3], tbData[i][4]) -- Tips强化
  end
end

function uiFightPower:GetEquipDataEx(nRoomId, tbWndList, nParam)
  local tbData = {}

  for i = 1, #self.tbCurWndList do
    local tbCloth = {}
    local pItem = me.GetItem(nRoomId, tbWndList[i].nPos, 0)
    if not pItem then
      --print("[ex equip]Failed to find item: me.GetItem("..nRoomId..", "..tbWndList[i].nPos..")");
      --break;
    end
    tbCloth[1] = (pItem and pItem.szName) or "未装备"
    local nCurEnhPower = 0
    local nMaxEnhPower = 0
    local nNxtEnhPower = nil
    local nNxtEnhTimes = nil
    local szEnhTip = ""
    if pItem then
      local nEnhaceMaxTimes = Item:CalcMaxEnhanceTimes(pItem) -- 最高强化次数
      nCurEnhPower = pItem.CalcExtraFightPower(pItem.nEnhTimes, 0) / nParam
      nMaxEnhPower = pItem.CalcExtraFightPower(nEnhaceMaxTimes, 0) / nParam

      nNxtEnhTimes = pItem.nEnhTimes + 1
      if nEnhaceMaxTimes == nNxtEnhTimes then
        nNxtEnhTimes = nEnhaceMaxTimes
        nNxtEnhPower = nMaxEnhPower
      elseif pItem.nEnhTimes == nEnhaceMaxTimes then
        nNxtEnhTimes = nil
        nNxtEnhPower = nil
      else
        nNxtEnhTimes, nNxtEnhPower = self:GetNextEnhancPowerLevel(pItem, pItem.nEnhTimes, nCurEnhPower * nParam)
        if nNxtEnhPower then
          nNxtEnhPower = nNxtEnhPower / nParam
        end
      end

      szEnhTip = "[当前]<enter>" .. "强化+" .. pItem.nEnhTimes .. " 效果：战斗力" .. self:FormatValue(nCurEnhPower)
      local bMaxEnhPower = nCurEnhPower >= nMaxEnhPower
      if 1 ~= pItem.IsWhite() then
        if not bMaxEnhPower then
          if nNxtEnhTimes and pItem.nEnhTimes ~= nEnhaceMaxTimes then
            szEnhTip = (szEnhTip .. "<color=green><enter>[下一档]<enter>强化+" .. nNxtEnhTimes .. " 效果：战斗力" .. self:FormatValue(nNxtEnhPower) .. "<color>")
          end
          szEnhTip = szEnhTip .. "<color=red><enter><enter>[最高]<enter>强化+" .. nEnhaceMaxTimes .. " 效果：战斗力" .. self:FormatValue(nMaxEnhPower) .. "<color>"
        end
      else
        nMaxEnhPower = 0
        bMaxEnhPower = true
      end
      if bMaxEnhPower then
        szEnhTip = szEnhTip .. "<enter><color=red>已达到最高点数<color>"
      end
      if nEnhaceMaxTimes ~= MAX_ENHTIMES then
        szEnhTip = szEnhTip .. "<enter><enter><color=green>高等级可用强" .. MAX_ENHTIMES .. "装备，战斗力+" .. (pItem.CalcExtraFightPower(MAX_ENHTIMES, 0) / nParam) .. "<color>"
      end
    end
    tbCloth[2] = (pItem and (nCurEnhPower / nMaxEnhPower * 1000)) or 0
    tbCloth[3] = (pItem and (self:FormatValue(nCurEnhPower, nMaxEnhPower))) or "--/--"
    tbCloth[4] = (pItem and szEnhTip) or "未装备"

    tbData[i] = tbCloth
  end
  return tbData
end

function uiFightPower:UpdatePageEquipExpand()
  self.tbCurWndList = self.WND_EQUIP_LIST_EX
  self:UpdatePageEquipEx(Item.ROOM_EQUIPEX2, self.WND_EQUIP_LIST_EX, 2) -- 以后加上
  Txt_SetTxt(self.UIGROUP, self.TXT_INSTRUCTION, self.tbInstruction[2][3])
end

function uiFightPower:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_LADDER then
    local nSelGroupId, nSelItemId = GetOutLookCurSelItemIdx(self.UIGROUP, self.OUTLOOK_TOTAL_POWER)
    local nGen = 1
    if nSelGroupId then
      if 0 == nSelGroupId then
        nGen = 3
      elseif 3 == nSelGroupId then
        nGen = 2
      elseif 4 == nSelGroupId then
        nGen = 4
      else
        nGen = 1
      end
    end
    UiManager:SwitchWindow(Ui.UI_LADDER, 7, nGen)
  end

  -- 主分页
  for i = 1, 2 do
    if szWnd == self.PAGE_MAIN[i][1] then
      self.m_nCurPageIndex = i
      self:UpdatePageMain()
      return
    end
  end
  -- 装备分页
  for i = 1, 3 do
    if szWnd == self.PAGE_EQUIP[i][1] then
      self.nEquipCurPageIndex = i
      self:UpdatePageEquip()
      return
    end
  end
end

-- 读取说明文字
function uiFightPower:LoadInstructionText()
  local tbFile = Lib:LoadTabFile("\\setting\\fightpower\\instruction.txt")
  if not tbFile then
    print("[fightpower]Failed to load file instruction.txt!")
  else
    local tbInfo = {}
    for _, tbRow in ipairs(tbFile) do
      local nMainId = tonumber(tbRow.mainid)
      local nSubId = tonumber(tbRow.subid)
      local strText = tostring(tbRow.text)

      if not tbInfo[nMainId] then
        tbInfo[nMainId] = {}
      end
      if not tbInfo[nMainId][nSubId] then
        tbInfo[nMainId][nSubId] = {}
      end

      tbInfo[nMainId][nSubId] = strText
    end
    self.tbInstruction = tbInfo
  end

  -- 防止文件错误
  local tbCheck = { { 0, 5 }, { 1, 3 } }
  for i = 1, #tbCheck do
    for j = tbCheck[i][1], tbCheck[i][2] do
      if not self.tbInstruction[i][j] then
        self.tbInstruction[i][j] = ""
      end
    end
  end
end

--
function uiFightPower:FormatValue(nLValue, nRValue)
  local szResult = ""

  if nLValue then
    nLValue = math.floor(nLValue * 100) / 100
    szResult = ((nLValue == math.floor(nLValue)) and ("+" .. nLValue)) or (string.format("+%0.2f", nLValue))
  end
  if nRValue then
    nRValue = math.floor(nRValue * 100) / 100
    szResult = szResult .. (((math.floor(nLValue) == nLValue) and ("/" .. nRValue)) or (string.format("/%0.2f", nRValue)))
  end
  return szResult
end
