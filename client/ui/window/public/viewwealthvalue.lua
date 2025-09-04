-----------------------------------------------------
--文件名		：	viewwealthvalue.lua
--创建者		：	jiazhenwei
--创建时间		：2009年7月23日, 16:42:15
--功能描述		：具体财富荣誉显示
------------------------------------------------------

local uiValue = Ui:GetClass("viewwealthvalue")

local tbEquitName = {}
local tbEquitExName = {}
local tbEquitQianghuaGrade = {} --nWeapon = 0,nArmor= 0,nRing = 0,nNecklace = 0,
--nAmulet = 0,nBoots = 0,nBelt = 0,nHelm = 0,nCuff = 0,nPendant = 0
local tbEquitQianghuaGradeMax = {}
local tbEquitExQianghuaGrade = {}
local tbEquitExQianghuaGradeMax = {}
local tbEquitValue = {}
local tbEquitExValue = {}
local tbEquitQHValue = {}
local tbEquitExQHValue = {}
local tbOtherEquitName = {}
local tbOtherEquitValue = {}
local tbEquitDefineName = { "头盔", "衣服", "腰带", "武器", "鞋子", "护腕", "护身符", "戒指", "项链", "腰坠" }
local tbOtherEquitDefineName = { "马", "面具", "秘籍", "阵法", "印章", "披风", "官印", "真元" }

local NUMBER = 10 --装备数目
local OTHERNUMBER = 8 --其他装备数目

local PAGESET_MAIN = "PageSetMain" -- 财富荣誉左侧页表
local PAGE_HISTORY = "PageHistory" -- 主角历程页
local BTN_HONOR = "BtnHistory" -- 财富荣誉界面
local OUTLOOK_HISTORY = "OutLookHistory" -- 荣誉界面：荣誉列表

local TEXT_BASIC_CAIFURONGYU = "TxtBasicCaifurongyu" -- 本周财富荣誉
local TEXT_NOW_CAIFURONGYU = "TxtNowCaifurongyu" --当前财富荣誉
local TEXT_GRADE = "TxtBasicGrade" --强化等级

uiValue.BUTTON_CLOSE = "BtnClose"
uiValue.BUTTON_UP = "BtnBasicUp"
uiValue.BUTTON_DOWN = "BtnBasicDown"

uiValue.tbCurrentEquip = {}
uiValue.tbSupportEquip = {}
uiValue.tbOtherEquip = {}

function uiValue:OnButtonClick(szWnd, nParam)
  if szWnd == self.BUTTON_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BUTTON_UP then
    self:OnIncrease()
  elseif szWnd == self.BUTTON_DOWN then
    self:OnDecrease()
  end
end
function uiValue:OnOpen()
  -- 更新所有页面
  PgSet_ActivePage(self.UIGROUP, PAGESET_MAIN, PAGE_HISTORY) -- 设置首页
  self:UpdateEquitData()
  self:UpdateOtherEquit()
  self:OnUpdateHonor()
  self:UpdateCaifurongyu()
end

function uiValue:UpdateEquitData()
  for i = 1, NUMBER do
    if me.GetItem(Item.ROOM_EQUIP, i - 1, 0) ~= nil then
      tbEquitName[i] = me.GetItem(Item.ROOM_EQUIP, i - 1, 0).szName
      tbEquitQianghuaGrade[i] = me.GetItem(Item.ROOM_EQUIP, i - 1, 0).nEnhTimes
      if me.GetItem(Item.ROOM_EQUIP, i - 1, 0).nStrengthen == 1 then
        tbEquitQianghuaGrade[i] = tbEquitQianghuaGrade[i] + 0.5
      end
      tbEquitQianghuaGradeMax[i] = Item:CalcMaxEnhanceTimes(me.GetItem(Item.ROOM_EQUIP, i - 1, 0))
      tbEquitValue[i] = PlayerHonor:CaculateEquipOrgValue(Item.ROOM_EQUIP, i - 1) / 10000 --调用接口 价值量
      tbEquitQHValue[i] = PlayerHonor:CaculateEquipEnhValue(Item.ROOM_EQUIP, i - 1, tbEquitQianghuaGrade[i]) / 10000 --调用接口 强化价值量
    else
      tbEquitName[i] = tbEquitDefineName[i]
      tbEquitQianghuaGrade[i] = 0
      tbEquitQianghuaGradeMax[i] = 0
      tbEquitValue[i] = 0
      tbEquitQHValue[i] = 0
    end
    if me.GetItem(Item.ROOM_EQUIPEX, i - 1, 0) ~= nil then
      tbEquitExName[i] = me.GetItem(Item.ROOM_EQUIPEX, i - 1, 0).szName
      tbEquitExQianghuaGrade[i] = me.GetItem(Item.ROOM_EQUIPEX, i - 1, 0).nEnhTimes
      if me.GetItem(Item.ROOM_EQUIPEX, i - 1, 0).nStrengthen == 1 then
        tbEquitExQianghuaGrade[i] = tbEquitExQianghuaGrade[i] + 0.5
      end
      tbEquitExQianghuaGradeMax[i] = Item:CalcMaxEnhanceTimes(me.GetItem(Item.ROOM_EQUIPEX, i - 1, 0))
      tbEquitExValue[i] = PlayerHonor:CaculateEquipOrgValue(Item.ROOM_EQUIPEX, i - 1) / 10000 --调用接口 价值量
      tbEquitExQHValue[i] = PlayerHonor:CaculateEquipEnhValue(Item.ROOM_EQUIPEX, i - 1, tbEquitExQianghuaGrade[i]) / 10000 --调用接口 强化价值量
    else
      tbEquitExName[i] = tbEquitDefineName[i]
      tbEquitExQianghuaGrade[i] = 0
      tbEquitExQianghuaGradeMax[i] = 0
      tbEquitExValue[i] = 0
      tbEquitExQHValue[i] = 0
    end
  end
end

function uiValue:UpdateCaifurongyu()
  Txt_SetTxt(self.UIGROUP, TEXT_BASIC_CAIFURONGYU, "上周财富荣誉:" .. PlayerHonor.tbPlayerHonorData.tbHonorData[3].tbHonorSubList[1].nValue)
  Txt_SetTxt(self.UIGROUP, TEXT_NOW_CAIFURONGYU, "当前财富荣誉:" .. PlayerHonor:CaculateTotalWealthValue()) --调用接口 当前财富荣誉的计算
end

function uiValue:UpdateOtherEquit()
  for i = 1, OTHERNUMBER do
    if me.GetItem(Item.ROOM_EQUIP, i + 9, 0) ~= nil then
      tbOtherEquitName[i] = me.GetItem(Item.ROOM_EQUIP, i + 9, 0).szName
      tbOtherEquitValue[i] = me.GetItem(Item.ROOM_EQUIP, i + 9, 0).nValue / 10000
    else
      tbOtherEquitName[i] = tbOtherEquitDefineName[i]
      tbOtherEquitValue[i] = 0
    end
  end
end

function uiValue:OnIncrease()
  if 0 == self.m_nSelTitleX then
    if tbEquitQianghuaGrade[self.m_nSelTitleY] < tbEquitQianghuaGradeMax[self.m_nSelTitleY] and 0 <= tbEquitQianghuaGrade[self.m_nSelTitleY] then
      if tbEquitQianghuaGrade[self.m_nSelTitleY] == 15 or tbEquitQianghuaGrade[self.m_nSelTitleY] == 15.5 then
        tbEquitQianghuaGrade[self.m_nSelTitleY] = tbEquitQianghuaGrade[self.m_nSelTitleY] + 0.5
      else
        tbEquitQianghuaGrade[self.m_nSelTitleY] = tbEquitQianghuaGrade[self.m_nSelTitleY] + 1
      end
      tbEquitQHValue[self.m_nSelTitleY] = PlayerHonor:CaculateEquipEnhValue(Item.ROOM_EQUIP, self.m_nSelTitleY - 1, tbEquitQianghuaGrade[self.m_nSelTitleY]) / 10000
    end
    Txt_SetTxt(self.UIGROUP, TEXT_GRADE, tbEquitQianghuaGrade[self.m_nSelTitleY])
  elseif 1 == self.m_nSelTitleX then
    if tbEquitExQianghuaGrade[self.m_nSelTitleY] < tbEquitExQianghuaGradeMax[self.m_nSelTitleY] and 0 <= tbEquitExQianghuaGrade[self.m_nSelTitleY] then
      if tbEquitExQianghuaGrade[self.m_nSelTitleY] == 15 or tbEquitExQianghuaGrade[self.m_nSelTitleY] == 15.5 then
        tbEquitExQianghuaGrade[self.m_nSelTitleY] = tbEquitExQianghuaGrade[self.m_nSelTitleY] + 0.5
      else
        tbEquitExQianghuaGrade[self.m_nSelTitleY] = tbEquitExQianghuaGrade[self.m_nSelTitleY] + 1
      end
      tbEquitExQHValue[self.m_nSelTitleY] = PlayerHonor:CaculateEquipEnhValue(Item.ROOM_EQUIPEX, self.m_nSelTitleY - 1, tbEquitExQianghuaGrade[self.m_nSelTitleY]) / 10000
    end
    Txt_SetTxt(self.UIGROUP, TEXT_GRADE, tbEquitExQianghuaGrade[self.m_nSelTitleY])
  end
  self:OnUpdateHonor()
  self:UpdateCaifurongyu()
end
function uiValue:OnDecrease()
  if 0 == self.m_nSelTitleX then
    if tbEquitQianghuaGrade[self.m_nSelTitleY] <= tbEquitQianghuaGradeMax[self.m_nSelTitleY] and 0 < tbEquitQianghuaGrade[self.m_nSelTitleY] then
      if tbEquitQianghuaGrade[self.m_nSelTitleY] == 16 or tbEquitQianghuaGrade[self.m_nSelTitleY] == 15.5 then
        tbEquitQianghuaGrade[self.m_nSelTitleY] = tbEquitQianghuaGrade[self.m_nSelTitleY] - 0.5
      else
        tbEquitQianghuaGrade[self.m_nSelTitleY] = tbEquitQianghuaGrade[self.m_nSelTitleY] - 1
      end
      tbEquitQHValue[self.m_nSelTitleY] = PlayerHonor:CaculateEquipEnhValue(Item.ROOM_EQUIP, self.m_nSelTitleY - 1, tbEquitQianghuaGrade[self.m_nSelTitleY]) / 10000
    end
    Txt_SetTxt(self.UIGROUP, TEXT_GRADE, tbEquitQianghuaGrade[self.m_nSelTitleY])
  elseif 1 == self.m_nSelTitleX then
    if tbEquitExQianghuaGrade[self.m_nSelTitleY] <= tbEquitExQianghuaGradeMax[self.m_nSelTitleY] and 0 < tbEquitExQianghuaGrade[self.m_nSelTitleY] then
      if tbEquitExQianghuaGrade[self.m_nSelTitleY] == 16 or tbEquitExQianghuaGrade[self.m_nSelTitleY] == 15.5 then
        tbEquitExQianghuaGrade[self.m_nSelTitleY] = tbEquitExQianghuaGrade[self.m_nSelTitleY] - 0.5
      else
        tbEquitExQianghuaGrade[self.m_nSelTitleY] = tbEquitExQianghuaGrade[self.m_nSelTitleY] - 1
      end
      tbEquitExQHValue[self.m_nSelTitleY] = PlayerHonor:CaculateEquipEnhValue(Item.ROOM_EQUIPEX, self.m_nSelTitleY - 1, tbEquitExQianghuaGrade[self.m_nSelTitleY]) / 10000
    end
    Txt_SetTxt(self.UIGROUP, TEXT_GRADE, tbEquitExQianghuaGrade[self.m_nSelTitleY])
  end
  self:OnUpdateHonor()
  self:UpdateCaifurongyu()
end

function uiValue:OnUpdateHonor()
  OutLookPanelClearAll(self.UIGROUP, OUTLOOK_HISTORY)
  AddOutLookPanelColumnHeader(self.UIGROUP, OUTLOOK_HISTORY, "")
  AddOutLookPanelColumnHeader(self.UIGROUP, OUTLOOK_HISTORY, "")
  AddOutLookPanelColumnHeader(self.UIGROUP, OUTLOOK_HISTORY, "")
  AddOutLookPanelColumnHeader(self.UIGROUP, OUTLOOK_HISTORY, "")
  SetOutLookHeaderWidth(self.UIGROUP, OUTLOOK_HISTORY, 0, 135)
  SetOutLookHeaderWidth(self.UIGROUP, OUTLOOK_HISTORY, 1, 85)
  SetOutLookHeaderWidth(self.UIGROUP, OUTLOOK_HISTORY, 2, 75)
  SetOutLookHeaderWidth(self.UIGROUP, OUTLOOK_HISTORY, 3, 20)

  AddOutLookGroup(self.UIGROUP, OUTLOOK_HISTORY, "当前装备")
  AddOutLookGroup(self.UIGROUP, OUTLOOK_HISTORY, "后备装备")
  AddOutLookGroup(self.UIGROUP, OUTLOOK_HISTORY, "其他装备及物品")
  local szEquipName = ""
  local szEquipExName = ""

  for i = 1, NUMBER do
    if string.len(tbEquitName[i]) > 16 then
      szEquipName = string.sub(tbEquitName[i], 1, 16) .. "..."
    else
      szEquipName = tbEquitName[i]
    end
    if string.len(tbEquitExName[i]) > 16 then
      szEquipExName = string.sub(tbEquitExName[i], 1, 16) .. "..."
    else
      szEquipExName = tbEquitExName[i]
    end
    self.tbCurrentEquip[i - 1] = tbEquitName[i]
    self.tbSupportEquip[i - 1] = tbEquitExName[i]
    if tbEquitValue[i] >= tbEquitExValue[i] then
      AddOutLookItem(self.UIGROUP, OUTLOOK_HISTORY, 0, { "√" .. szEquipName, string.format("%.2f", tbEquitValue[i]), string.format("%.2f", tbEquitQHValue[i]), tbEquitQianghuaGrade[i] })
      AddOutLookItem(self.UIGROUP, OUTLOOK_HISTORY, 1, { "  " .. szEquipExName, string.format("%.2f", tbEquitExValue[i]), string.format("%.2f", tbEquitExQHValue[i]), tbEquitExQianghuaGrade[i] })
    else
      AddOutLookItem(self.UIGROUP, OUTLOOK_HISTORY, 0, { "  " .. szEquipName, string.format("%.2f", tbEquitValue[i]), string.format("%.2f", tbEquitQHValue[i]), tbEquitQianghuaGrade[i] })
      AddOutLookItem(self.UIGROUP, OUTLOOK_HISTORY, 1, { "√" .. szEquipExName, string.format("%.2f", tbEquitExValue[i]), string.format("%.2f", tbEquitExQHValue[i]), tbEquitExQianghuaGrade[i] })
    end
  end

  for i = 1, OTHERNUMBER do
    local szOtherEquipName = ""
    if string.len(tbOtherEquitName[i]) > 16 then
      szOtherEquipName = string.sub(tbOtherEquitName[i], 1, 16) .. "..."
    else
      szOtherEquipName = tbOtherEquitName[i]
    end
    self.tbOtherEquip[i - 1] = tbOtherEquitName[i]
    AddOutLookItem(self.UIGROUP, OUTLOOK_HISTORY, 2, { "√" .. szOtherEquipName, string.format("%.2f", tbOtherEquitValue[i]) })
  end

  AddOutLookItem(self.UIGROUP, OUTLOOK_HISTORY, 2, { "√武林秘籍", string.format("%.2f", PlayerHonor:GetWulinmijiValue() / 10000) })
  self.tbOtherEquip[OTHERNUMBER] = "武林秘籍"
  AddOutLookItem(self.UIGROUP, OUTLOOK_HISTORY, 2, { "√洗髓经", string.format("%.2f", PlayerHonor:GetXisuijingValue() / 10000) })
  self.tbOtherEquip[OTHERNUMBER + 1] = "洗髓经"
  AddOutLookItem(self.UIGROUP, OUTLOOK_HISTORY, 2, { "√消耗型财富", string.format("%.2f", PlayerHonor:GetXiaohaoValue() / 10000) })
  self.tbOtherEquip[OTHERNUMBER + 2] = "消耗型财"
  AddOutLookItem(self.UIGROUP, OUTLOOK_HISTORY, 2, { "√月饼", string.format("%.2f", PlayerHonor:GetYuebingValue() / 10000) })
  self.tbOtherEquip[OTHERNUMBER + 3] = "月饼"
  AddOutLookItem(self.UIGROUP, OUTLOOK_HISTORY, 2, { "√同伴", string.format("%.2f", PlayerHonor:GetPartnerValue() / 10000) })
  self.tbOtherEquip[OTHERNUMBER + 4] = "同伴"
end

function uiValue:OnOutLookItemSelected(szWndName, nGroupIndex, nItemIndex)
  if szWndName ~= OUTLOOK_HISTORY then
    return
  end
  self.m_nSelTitleX = nGroupIndex
  self.m_nSelTitleY = nItemIndex + 1

  if 0 == nGroupIndex then
    Txt_SetTxt(self.UIGROUP, TEXT_GRADE, tbEquitQianghuaGrade[nItemIndex + 1])
  elseif 1 == nGroupIndex then
    Txt_SetTxt(self.UIGROUP, TEXT_GRADE, tbEquitExQianghuaGrade[nItemIndex + 1])
  else
    Txt_SetTxt(self.UIGROUP, TEXT_GRADE, 0)
  end
end

function uiValue:OnMouseEnter(szWnd, nParam) -- 鼠标移上Tips显示
  local szTip = ""
  if szWnd == OUTLOOK_HISTORY then
    szTip = self:ProcessOutlookHistoryMouseEnter(nParam)
  end

  if szTip ~= "" then --	2012/7/27 10:16:50	显示指定窗口的提示信息
    Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, "", szTip)
  end
end

function uiValue:ProcessOutlookHistoryMouseEnter(nParam)
  local nGroupIndex = Lib:LoadBits(nParam, 0, 15)
  local nItemIndex = Lib:LoadBits(nParam, 16, 31)
  local szTip = ""
  if nItemIndex == 65535 then --这里经过测试 当鼠标滑到Group时(即outlook的标题栏 当前装备 后备装备 其他装备) nItemIndex为65535 所以特殊处理忽略之
    return ""
  end
  if nGroupIndex == 0 then
    szTip = self.tbCurrentEquip[nItemIndex]
  elseif nGroupIndex == 1 then
    szTip = self.tbSupportEquip[nItemIndex]
  else
    szTip = self.tbOtherEquip[nItemIndex]
  end
  return szTip
end
