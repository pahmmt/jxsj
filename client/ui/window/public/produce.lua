-----------------------------------------------------
--文件名		：	produce.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-06-02
--功能描述		：	生活技能界面脚本。
------------------------------------------------------

local uiProduce = Ui:GetClass("produce")
local tbObject = Ui.tbLogic.tbObject
local tbTempItem = Ui.tbLogic.tbTempItem

uiProduce.BTN_CLOSE = "BtnClose" -- 关闭
uiProduce.BTN_MAKE = "BtnMake" -- 制造
uiProduce.BTN_MAKE_ALL = "BtnMakeAll" -- 制造全部
uiProduce.BTN_CANCEL = "BtnCancel" -- 取消
uiProduce.BTN_INC_COUNT = "BtnIncCount" -- 增加制造数目
uiProduce.BTN_DEC_COUNT = "BtnDecCount" -- 减少制造数目
uiProduce.IMGPART_EXP_PROCESS = "ImgPartExp" -- 经验进度条
uiProduce.TXT_SKILLINFO = "TxtSkillInfo" -- 显示技能名称，等级
uiProduce.OUTLOOK_RECIPE = "OutLookRecipe" -- 配方列表
uiProduce.EDT_MAKECOUNT = "EdtMakeCount" -- 输入框显示需要制造多少个
uiProduce.TXT_COST = "TxtCost" -- 配方需要消耗精力活力数
uiProduce.TXT_EXP = "TxtExp" -- 经验文字进度
uiProduce.TXT_INFO = "TxtExpInfo"
uiProduce.TXT_DESC = "TxtRecipeDesc" -- 配方描述
uiProduce.COMBOBOX_FILTER1 = "ComboBoxFilter1" -- 分类下拉菜单
uiProduce.COMBOBOX_FILTER2 = "ComboBoxFilter2" -- 分类下拉菜单

uiProduce.TXT_PRODUCE = {
  "TxtProduce1",
  "TxtProduce2",
  "TxtProduce3",
}

uiProduce.TXT_MATERIAL = {
  "TxtMaterialCount1",
  "TxtMaterialCount2",
  "TxtMaterialCount3",
  "TxtMaterialCount4",
  "TxtMaterialCount5",
}

uiProduce.FILTER1DATA = {
  { nId = 1, szText = "五行不限", nValue = -1 },
  { nId = 2, szText = "无五行", nValue = 0 },
  { nId = 3, szText = "金", nValue = 1 },
  { nId = 4, szText = "木", nValue = 2 },
  { nId = 5, szText = "水", nValue = 3 },
  { nId = 6, szText = "火", nValue = 4 },
  { nId = 7, szText = "土", nValue = 5 },
}

uiProduce.FILTER2DATA = {
  { nId = 1, szText = "等级不限", nValue = -1 },
  { nId = 2, szText = "1级", nValue = 1 },
  { nId = 3, szText = "2级", nValue = 2 },
  { nId = 4, szText = "3级", nValue = 3 },
  { nId = 5, szText = "4级", nValue = 4 },
  { nId = 6, szText = "5级", nValue = 5 },
  { nId = 7, szText = "6级", nValue = 6 },
  { nId = 8, szText = "7级", nValue = 7 },
  { nId = 9, szText = "8级", nValue = 8 },
  { nId = 10, szText = "9级", nValue = 9 },
  { nId = 11, szText = "10级", nValue = 10 },
}

local OBJPRODUCE = "ObjProduce" -- 生产装备OBJ
local OBJSTUFF = "ObjStuff" -- 生产装备所需材料的OBJ
local tbEquipCont = { bShowCd = 0, bUse = 0, bLink = 0, bSwitch = 0 }
local tbStuffCont = { bShowCd = 0, bUse = 0, bLink = 0, bSwitch = 0 }
local OBJPRODUCE_ROW = 1
local OBJPRODUCE_LINE = 3

local OBJSTUFF_ROW = 5
local OBJSTUFF_LINE = 1

function uiProduce:GetFilter1ValueFromId(nId)
  for _, item in ipairs(self.FILTER1DATA) do
    if nId == item.nId then
      return item.nValue
    end
  end
end

function uiProduce:GetFilter2ValueFromId(nId)
  for _, item in ipairs(self.FILTER2DATA) do
    if nId == item.nId then
      return item.nValue
    end
  end
end

uiProduce.MAX_MATERIAL = #uiProduce.TXT_MATERIAL -- 最大材料数

function uiProduce:Init()
  self.m_nRecipeId = 0 -- 当前选择的配方id
  self.m_nMakeCount = 0 -- 制造数量
  self.m_nMaxCount = 0 -- 最大制造数量
  self.m_bProducing = 0 -- 是否正在制造中
  self.m_nLifeSkillId = -1 -- 当前的生活技能Id
  self.m_nCurFilter1Index = 0 -- 默认选择0号类别
  self.m_nCurFilter2Index = 0 -- 第2过滤器当前选项索引
  self.m_tbCurOutLookMap = {}
  self.m_tbRecipeSet = {} -- 此技能下的配方集合
end

function uiProduce:WriteStatLog()
  Log:Ui_SendLog("F8生活技能界面", 1)
end

function uiProduce:OnCreate()
  self.tbEquipCont = tbObject:RegisterContainer(self.UIGROUP, OBJPRODUCE, OBJPRODUCE_ROW, OBJPRODUCE_LINE, tbEquipCont, "award")
  self.tbStuffCont = tbObject:RegisterContainer(self.UIGROUP, OBJSTUFF, OBJSTUFF_ROW, OBJSTUFF_LINE, tbStuffCont)
end

function tbStuffCont:FormatItem(tbItem)
  local tbObj = {}
  local pItem = tbItem.pItem
  if not pItem then
    return
  end
  tbObj.szBgImage = pItem.szIconImage
  tbObj.bShowSubScript = 0 -- 总显示下标数字
  return tbObj
end

function tbEquipCont:FormatItem(tbItem)
  local tbObj = {}
  local pItem = tbItem.pItem
  if not pItem then
    return
  end
  tbObj.szBgImage = pItem.szIconImage
  tbObj.bShowSubScript = 0 -- 总显示下标数字
  return tbObj
end

function uiProduce:OnDestroy()
  tbObject:UnregContainer(self.tbEquipCont)
  tbObject:UnregContainer(self.tbStuffCont)
end

function uiProduce:OnOpen(nLifeSkillId)
  self:WriteStatLog()

  ClearComboBoxItem(self.UIGROUP, self.COMBOBOX_FILTER1)
  OutLookPanelClearAll(self.UIGROUP, self.OUTLOOK_RECIPE)
  self.m_tbRecipeSet = {}
  --assert(nLifeSkillId and nLifeSkillId > 0);
  self.m_nLifeSkillId = nLifeSkillId
  local tbRecipeList = self:GetRecipeList(nLifeSkillId) --me.GetRecipeList();
  for _, nRecipeId in ipairs(tbRecipeList) do
    if LifeSkill.tbRecipeDatas[nRecipeId] then
      if LifeSkill.tbRecipeDatas[nRecipeId].Belong == nLifeSkillId then
        self.m_tbRecipeSet[#self.m_tbRecipeSet + 1] = { nId = nRecipeId, tbData = LifeSkill.tbRecipeDatas[nRecipeId] }
      end
    end
  end

  -- 填充下拉菜单
  local nFilter1Count, nFilter2Count = self:FillCategoryComboBox()

  -- 选择第一项
  if nFilter1Count > 0 and nFilter2Count > 0 then
    ComboBoxSelectItem(self.UIGROUP, self.COMBOBOX_FILTER1, 0)
    ComboBoxSelectItem(self.UIGROUP, self.COMBOBOX_FILTER2, 0)
    self:SelectFirstItem()
    Btn_SetTxt(self.UIGROUP, self.BTN_CANCEL, "返 回")
    Edt_SetInt(self.UIGROUP, self.EDT_MAKECOUNT, 0)
    self:OnSkillAttrModify(nLifeSkillId)
    self.m_szBGM = LifeSkill.tbLifeSkillDatas[nLifeSkillId].BGM
  end
end

-- 填充下拉框
function uiProduce:FillCategoryComboBox()
  ClearComboBoxItem(self.UIGROUP, self.COMBOBOX_FILTER1)
  ClearComboBoxItem(self.UIGROUP, self.COMBOBOX_FILTER2)

  local nFilter1Count = 0
  local nFilter2Count = 0
  for _, tbData in ipairs(self.FILTER1DATA) do
    if ComboBoxAddItem(self.UIGROUP, self.COMBOBOX_FILTER1, tbData.nId, tbData.szText) == 1 then
      nFilter1Count = nFilter1Count + 1
    end
  end

  for _, tbData in ipairs(self.FILTER2DATA) do
    if ComboBoxAddItem(self.UIGROUP, self.COMBOBOX_FILTER2, tbData.nId, tbData.szText) == 1 then
      nFilter2Count = nFilter2Count + 1
    end
  end

  return nFilter1Count, nFilter2Count
end

-- 下拉菜单改变
function uiProduce:OnComboBoxIndexChange(szWnd, nIndex)
  if szWnd == self.COMBOBOX_FILTER1 then
    self.m_nCurFilter1Index = nIndex
  end

  if szWnd == self.COMBOBOX_FILTER2 then
    self.m_nCurFilter2Index = nIndex
  end

  -- 更新配方列表
  self:UpdateRecipeList()
end

-- 更新配方列表
function uiProduce:UpdateRecipeList()
  local tbArrangedPickedRecipeList = self:ArrangePickedRecipeList(self:GetPickedRecipeList())
  --{
  --	szKindName = "",
  --	tbRecipes =
  --	{
  --		{
  --			uId = 1,
  --			szName = "xxx"
  --		}
  --		{
  --			uId = 1,
  --			szName = "xxx"
  --		}
  --	}
  --}

  OutLookPanelClearAll(self.UIGROUP, self.OUTLOOK_RECIPE)

  self.m_tbCurOutLookMap = {}
  AddOutLookPanelColumnHeader(self.UIGROUP, self.OUTLOOK_RECIPE, "")
  SetOutLookHeaderWidth(self.UIGROUP, self.OUTLOOK_RECIPE, 0, 150)

  local nGroup = 0

  for _, tbKindRecipeSet in ipairs(tbArrangedPickedRecipeList) do
    if tbKindRecipeSet.szKindName == "特殊物品" then
      AddOutLookGroup(self.UIGROUP, self.OUTLOOK_RECIPE, tbKindRecipeSet.szKindName)
      self.m_tbCurOutLookMap[#self.m_tbCurOutLookMap + 1] = tbKindRecipeSet.szKindName
      local tbRecipeList = tbKindRecipeSet.tbRecipes
      for i = 1, #tbRecipeList do
        AddOutLookItem(self.UIGROUP, self.OUTLOOK_RECIPE, nGroup, { tbRecipeList[i].szName }, tostring(tbRecipeList[i].uId))
      end
      nGroup = nGroup + 1
      break
    end
  end

  for _, tbKindRecipeSet in ipairs(tbArrangedPickedRecipeList) do
    if tbKindRecipeSet.szKindName ~= "特殊物品" then
      AddOutLookGroup(self.UIGROUP, self.OUTLOOK_RECIPE, tbKindRecipeSet.szKindName)
      self.m_tbCurOutLookMap[#self.m_tbCurOutLookMap + 1] = tbKindRecipeSet.szKindName
      local tbRecipeList = tbKindRecipeSet.tbRecipes
      for i = 1, #tbRecipeList do
        AddOutLookItem(self.UIGROUP, self.OUTLOOK_RECIPE, nGroup, { tbRecipeList[i].szName }, tostring(tbRecipeList[i].uId))
      end
      nGroup = nGroup + 1
    end
  end

  self:SelectFirstItem()
end

function uiProduce:GetCurFilter1Id()
  if not self.m_nCurFilter1Index or self.m_nCurFilter1Index < 0 then
    return
  end

  local nCurFilterId = GetComboBoxItemId(self.UIGROUP, self.COMBOBOX_FILTER1, self.m_nCurFilter1Index)

  return nCurFilterId
end

function uiProduce:GetCurFilter2Id()
  if not self.m_nCurFilter2Index or self.m_nCurFilter2Index < 0 then
    return
  end

  local nCurFilterId = GetComboBoxItemId(self.UIGROUP, self.COMBOBOX_FILTER2, self.m_nCurFilter2Index)

  return nCurFilterId
end

--[[
function uiProduce:GetCurCategory()
	if (not self.m_nCurFilter1Index or self.m_nCurFilter1Index < 0) then
		return;
	end
	local szCategory = GetComboBoxItemText(self.UIGROUP, self.COMBOBOX_FILTER1, self.m_nCurFilter1Index);
	return szCategory;
end

]]
--
-- 根据FilterId筛选的配方列表
function uiProduce:GetPickedRecipeList()
  local nCurFilter1Id = self:GetCurFilter1Id()
  local nCurFilter2Id = self:GetCurFilter2Id()

  local nSeries = self:GetFilter1ValueFromId(nCurFilter1Id) or -1
  local nLevel = self:GetFilter2ValueFromId(nCurFilter2Id) or -1

  local tbPickedRecipeList = {}
  for _, tbRecipt in ipairs(self.m_tbRecipeSet) do
    if (tbRecipt.tbData.tbProductSet[1].tbItem[6] == nSeries or nSeries < 0) and (tbRecipt.tbData.tbProductSet[1].tbItem[4] == nLevel or nLevel < 0) then
      tbPickedRecipeList[#tbPickedRecipeList + 1] = tbRecipt.tbData
    end
  end

  return tbPickedRecipeList
end

function uiProduce:ArrangePickedRecipeList(tbRecipes)
  local tbArrangedRecipeList = {}
  for i = 1, #tbRecipes do
    local tbKindGroup = self:GetKindGroup(tbArrangedRecipeList, tbRecipes[i].KindName, tbRecipes[i].Kind)
    local tbTmpRecipe = { uId = tbRecipes[i].ID, szName = tbRecipes[i].Name }
    tbKindGroup.tbRecipes[#tbKindGroup.tbRecipes + 1] = tbTmpRecipe
  end

  --{
  --	szKindName = "",
  --	tbRecipes =
  --	{
  --		{
  --			uId = 1,
  --			szName = "xxx"
  --		}
  --		{
  --			uId = 1,
  --			szName = "xxx"
  --		}
  --	}
  --}
  local nMaxKindId = 0
  for nKindId, tbKindRecipeSet in pairs(tbArrangedRecipeList) do
    if nKindId > nMaxKindId then
      nMaxKindId = nKindId
    end
  end
  local tbRet = {}

  for i = 1, nMaxKindId do
    if tbArrangedRecipeList[i] then
      tbRet[#tbRet + 1] = tbArrangedRecipeList[i]
    end
  end

  return tbRet
end

function uiProduce:GetKindGroup(tbArrangedRecipeList, szKindName, nKindId)
  assert(szKindName)
  assert(tbArrangedRecipeList)

  if not tbArrangedRecipeList[nKindId] then
    tbArrangedRecipeList[nKindId] = {}
    tbArrangedRecipeList[nKindId].tbRecipes = {}
    tbArrangedRecipeList[nKindId].szKindName = szKindName
    tbArrangedRecipeList[nKindId].nKindId = nKindId
  end

  return tbArrangedRecipeList[nKindId]
end

function uiProduce:OnClose()
  if self.m_szBGM then
    StopSound(self.m_szBGM)
  end

  self:ClearObj() -- 清除所有临时物品
end

-- 清空临时物品
function uiProduce:ClearObj()
  for i = 0, OBJPRODUCE_LINE - 1 do
    local tbObj = self.tbEquipCont:GetObj(0, i)
    if tbObj then
      tbTempItem:Destroy(tbObj.pItem)
    end
  end

  for i = 0, OBJSTUFF_ROW - 1 do
    local tbObj = self.tbStuffCont:GetObj(i, 0)
    if tbObj then
      tbTempItem:Destroy(tbObj.pItem)
    end
  end
  self.tbStuffCont:ClearObj()
  self.tbEquipCont:ClearObj()
end

-- 点击按钮
function uiProduce:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)

    -- 关了这个窗口之后同时打开生活技能窗口（09011调整为不打开）
    --UiManager:OpenWindow(Ui.UI_LIFESKILL);
  elseif szWnd == self.BTN_MAKE then
    if self.m_bProducing ~= 1 then
      local nGroupIdx, nItemIdx = GetOutLookCurSelItemIdx(self.UIGROUP, self.OUTLOOK_RECIPE)
      if not nGroupIdx or not nItemIdx then
        if self:SelectFirstItem() == 0 then
          return
        end
      end

      self.m_nRecipeId = tonumber(GetOutLookItemUserDesc(self.UIGROUP, self.OUTLOOK_RECIPE, nGroupIdx, nItemIdx))
      self.m_nMakeCount = Edt_GetInt(self.UIGROUP, self.EDT_MAKECOUNT)
      local nMaxCount = self:GetMaxCount(self.m_nRecipeId)
      if self.m_nMakeCount >= nMaxCount then
        Edt_SetInt(self.UIGROUP, self.EDT_MAKECOUNT, nMaxCount)
        self.m_nMakeCount = nMaxCount
      elseif self.m_nMakeCount <= 0 then
        Edt_SetInt(self.UIGROUP, self.EDT_MAKECOUNT, 1)
        self.m_nMakeCount = 1
      end
      self:MakeProduce()
    else
    end
  elseif szWnd == self.BTN_MAKE_ALL then
    if self.m_bProducing ~= 1 then
      local nGroupIdx, nItemIdx = GetOutLookCurSelItemIdx(self.UIGROUP, self.OUTLOOK_RECIPE)
      if not nGroupIdx or not nItemIdx then
        if self:SelectFirstItem() == 0 then
          return
        end
      end
      self.m_nRecipeId = tonumber(GetOutLookItemUserDesc(self.UIGROUP, self.OUTLOOK_RECIPE, nGroupIdx, nItemIdx))
      Edt_SetInt(self.UIGROUP, self.EDT_MAKECOUNT, self:GetMaxCount(self.m_nRecipeId))
      self.m_nMakeCount = self:GetMaxCount(self.m_nRecipeId)
      self:MakeProduce()
    else
    end
  elseif szWnd == self.BTN_CANCEL then
    if self.m_bProducing == 0 then
      UiManager:CloseWindow(self.UIGROUP)
      UiManager:OpenWindow(Ui.UI_LIFESKILL)
    else
      self:CancelProduce()
    end
  elseif szWnd == self.BTN_INC_COUNT then
    self:IncreaseMakeCount()
  elseif szWnd == self.BTN_DEC_COUNT then
    self:DecreaseMakeCount()
  end
end

-- 选中一项配方时
function uiProduce:OnOutLookItemSelected(szWndName, nGroupIdx, nItemIdx)
  local nRecipeId = tonumber(GetOutLookItemUserDesc(self.UIGROUP, self.OUTLOOK_RECIPE, nGroupIdx, nItemIdx))
  self:UpdateRecipe(nRecipeId)
end

-- 制造物品
function uiProduce:MakeProduce()
  if self.m_nMakeCount <= 0 then
    me.Msg("请保证有足够的精力活力和制造材料")
    return
  end

  me.DoRecipe(self.m_nRecipeId)

  if self.m_bProducing == 0 then
    PlaySound(self.m_szBGM, 1)
  end

  self.m_bProducing = 1
end

-- 取消制造
function uiProduce:CancelProduce()
  if self.m_szBGM then
    StopSound(self.m_szBGM)
  end
  self.m_bProducing = 0
  self.m_nMakeCount = 0
end

-- 增加输入框中的数
function uiProduce:IncreaseMakeCount(nCount)
  if not nCount then
    nCount = 1
  end

  local nCurCount = Edt_GetInt(self.UIGROUP, self.EDT_MAKECOUNT)
  nCurCount = nCurCount + nCount

  if nCurCount > 999 then
    nCurCount = 999
  end

  Edt_SetInt(self.UIGROUP, self.EDT_MAKECOUNT, nCurCount)
end

-- 减少输入框中的数
function uiProduce:DecreaseMakeCount(nCount)
  if not nCount then
    nCount = 1
  end
  local nCurCount = Edt_GetInt(self.UIGROUP, self.EDT_MAKECOUNT)
  nCurCount = nCurCount - nCount
  if nCurCount < 0 then
    nCurCount = 0
  end
  Edt_SetInt(self.UIGROUP, self.EDT_MAKECOUNT, nCurCount)
end

function uiProduce:UpdateRecipe(nRecipeId)
  local nMaxCount = self:GetMaxCount(nRecipeId)
  if nMaxCount <= 0 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_INC_COUNT, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_DEC_COUNT, 0)
    Wnd_SetEnable(self.UIGROUP, self.EDT_MAKECOUNT, 0)
  else
    Wnd_SetEnable(self.UIGROUP, self.BTN_INC_COUNT, 1)
    Wnd_SetEnable(self.UIGROUP, self.BTN_DEC_COUNT, 1)
    Wnd_SetEnable(self.UIGROUP, self.EDT_MAKECOUNT, 1)
  end

  self:ClearObj()
  for i = 1, #self.TXT_PRODUCE do
    Txt_SetTxt(self.UIGROUP, self.TXT_PRODUCE[i], "")
  end

  for i = 1, #self.TXT_MATERIAL do
    Txt_SetTxt(self.UIGROUP, self.TXT_MATERIAL[i], "")
  end
  if nRecipeId <= 0 then
    Txt_SetTxt(self.UIGROUP, self.TXT_COST, "")
    return
  end

  local tbRecipeData = LifeSkill.tbRecipeDatas[nRecipeId]
  local tbSkillData = LifeSkill.tbLifeSkillDatas[tbRecipeData.Belong]
  local tbProductSet = tbRecipeData.tbProductSet
  local tbStuffSet = tbRecipeData.tbStuffSet
  Txt_SetTxt(self.UIGROUP, self.TXT_INFO, "可获得经验值：" .. tbRecipeData.ExpGain)
  for i = 1, OBJPRODUCE_LINE do
    if tbProductSet[i].tbItem then
      local tbProduct = tbProductSet[i].tbItem
      local tbItemInfo = { bForceBind = LifeSkill:GetBindType(tbProductSet[i].nBind) }

      local pItem = tbTempItem:CreateEx(tbItemInfo, tbProduct[1], tbProduct[2], tbProduct[3], tbProduct[4], tbProduct[6])
      local tbObj = nil
      if pItem then
        tbObj = {}
        tbObj.nType = Ui.OBJ_TEMPITEM
        tbObj.pItem = pItem
        if tbProductSet[i].nBind == 1 then
          tbObj.szBindType = "获取绑定"
        end
        self.tbEquipCont:SetObj(tbObj, OBJPRODUCE_ROW - 1, i - 1)

        local nRate = tbProductSet[i].nRate
        if nRate > 100 then
          nRate = 100
        end
        local nG = tbRecipeData.tbProductSet[i].tbItem[1]
        local nD = tbRecipeData.tbProductSet[i].tbItem[2]
        local nP = tbRecipeData.tbProductSet[i].tbItem[3]
        local nL = tbRecipeData.tbProductSet[i].tbItem[4]

        local szItemName = KItem.GetNameById(nG, nD, nP, nL)
        local szMsg = string.format("名称：%s\n成功率：%d%%", szItemName, nRate)
        Txt_SetTxt(self.UIGROUP, self.TXT_PRODUCE[i], szMsg)
      end
    end
  end

  -- 显示消耗的精力活力
  local szCostMsg = ""
  if tbSkillData.Gene == 0 then
    szCostMsg = string.format("消耗精力：%d  当前精力：%d", tbRecipeData.Cost, me.dwCurMKP)
  elseif tbSkillData.Gene == 1 then
    szCostMsg = string.format("消耗活力：%d  当前活力：%d", tbRecipeData.Cost, me.dwCurGTP)
  else
    --assert(false);
  end
  Txt_SetTxt(self.UIGROUP, self.TXT_COST, szCostMsg)
  if tbRecipeData.Desc and tbRecipeData.Desc ~= "" then
    Txt_SetTxt(self.UIGROUP, self.TXT_DESC, tbRecipeData.Desc)
  else
    Txt_SetTxt(self.UIGROUP, self.TXT_DESC, "")
  end

  -- 材料
  for i = 1, OBJSTUFF_ROW do
    if tbStuffSet[i].nCount > 0 then
      local tbStuff = tbStuffSet[i].tbItem
      local tbItemInfo = { bForceBind = LifeSkill:GetBindType(tbStuffSet[i].nBind) }

      local pItem = tbTempItem:CreateEx(tbItemInfo, tbStuff[1], tbStuff[2], tbStuff[3], tbStuff[4], tbStuff[6])
      local tbObj = nil
      if pItem then
        tbObj = {}
        tbObj.nType = Ui.OBJ_TEMPITEM
        tbObj.pItem = pItem
        self.tbStuffCont:SetObj(tbObj, i - 1, OBJSTUFF_LINE - 1)

        local nItemCount = me.GetItemCountInBags(tbStuffSet[i].tbItem[1], tbStuffSet[i].tbItem[2], tbStuffSet[i].tbItem[3], tbStuffSet[i].tbItem[4], tbStuffSet[i].tbItem[5], LifeSkill:GetBindType(tbStuffSet[i].nBind))
        local nNeedCount = tbStuffSet[i].nCount
        --assert(nNeedCount > 0);
        local szFormat = "%d/%d"
        if nItemCount < nNeedCount then
          szFormat = "<color=red>%d<color>/%d"
        end

        local szNumber = string.format(szFormat, nItemCount, nNeedCount)
        Txt_SetTxt(self.UIGROUP, self.TXT_MATERIAL[i], szNumber)
      end
    else
    end
  end
end

function uiProduce:GetMaxCount(nRecipeId)
  if nRecipeId <= 0 then
    return 0
  end

  local nMaxCount = 999
  local tbRecipeData = LifeSkill.tbRecipeDatas[nRecipeId]
  local tbSkillData = LifeSkill.tbLifeSkillDatas[tbRecipeData.Belong]
  local tbProductSet = tbRecipeData.tbProductSet
  local tbStuffSet = tbRecipeData.tbStuffSet

  -- 显示消耗的精力活力
  local szCostMsg = ""
  if tbSkillData.Gene == 0 then
    nMaxCount = math.min(nMaxCount, math.floor(me.dwCurMKP / tbRecipeData.Cost))
  elseif tbSkillData.Gene == 1 then
    nMaxCount = math.min(nMaxCount, math.floor(me.dwCurGTP / tbRecipeData.Cost))
  else
    --assert(false);
  end

  -- 材料
  for i = 1, #tbStuffSet do
    if tbStuffSet[i].nCount > 0 then
      local nItemCount = me.GetItemCountInBags(tbStuffSet[i].tbItem[1], tbStuffSet[i].tbItem[2], tbStuffSet[i].tbItem[3], tbStuffSet[i].tbItem[4], tbStuffSet[i].tbItem[5], LifeSkill:GetBindType(tbStuffSet[i].nBind))
      local nNeedCount = tbStuffSet[i].nCount
      nMaxCount = math.min(nMaxCount, math.floor(nItemCount / nNeedCount))
    end
  end

  return nMaxCount
end

function uiProduce:OnEventSyncRecipe()
  if UiManager:WindowVisible(Ui.UI_PRODUCE) ~= 0 then
    uiProduce:OnSyncRecipe()
  end
end

function uiProduce:OnEventDoRecipeResult(bSuccess)
  if UiManager:WindowVisible(Ui.UI_PRODUCE) ~= 0 then
    uiProduce:OnProduceResult(bSuccess)
  end
end

-- 触发一个技能时调用
function uiProduce:OnDelSkill(nSkillId)
  -- TODO:liuchang
end

-- 技能等级改变
function uiProduce:OnSkillLevelUp(nSkillId)
  self:OnSkillAttrModify(nSkillId)
  local tbRecipes = self:GetRecipeList(nSkillId)
  local tbTemp = {}
  for nIndex, tbRecipe in ipairs(self.m_tbRecipeSet) do
    tbTemp[tbRecipe.nId] = nIndex
  end
  for nIndex, nId in ipairs(tbRecipes) do
    if not tbTemp[nId] and LifeSkill.tbRecipeDatas[nId].Belong == nSkillId then
      self:OnAddRecipe(nId, 1)
    end
  end
end

-- 技能属性改变时调用(升级，经验增加)
function uiProduce:OnSkillAttrModify(nSkillId)
  if self.m_nLifeSkillId ~= nSkillId then
    --assert(false);
    return
  end
  local tbSkill = me.GetSingleLifeSkill(nSkillId)
  local nSkillLevel = tbSkill.nLevel
  local nSkillExp = tbSkill.nExp
  local tbSkillData = LifeSkill.tbLifeSkillDatas[nSkillId]
  local nNextLevel = nSkillLevel + 1
  if nNextLevel > tbSkillData.nMaxLevel then
    nNextLevel = tbSkillData.nMaxLevel
  end

  local szTxt = string.format("技能名称：%s   等级：%d", tbSkillData.Name, tbSkill.nLevel)
  Txt_SetTxt(self.UIGROUP, self.TXT_SKILLINFO, szTxt)
  Prg_SetPos(self.UIGROUP, self.IMGPART_EXP_PROCESS, nSkillExp / tbSkillData.tbSkillExpMap[nNextLevel] * 1000)
  Txt_SetTxt(self.UIGROUP, self.TXT_EXP, nSkillExp .. "/" .. tbSkillData.tbSkillExpMap[nNextLevel])
end

-- 添加一个配方的时候调用
function uiProduce:OnAddRecipe(nRecipeId, nRef)
  local nLifeSkillId = LifeSkill:GetBelongSkillId(nRecipeId)
  if nLifeSkillId ~= self.m_nLifeSkillId then
    return
  end
  if not nRef or nRef ~= 1 then
    for _, tbRecipt in ipairs(self.m_tbRecipeSet) do
      if tbRecipt.nId == nRecipeId then
        -- 若已有次配方则直接返回，在目前只在跨服的时候
        return
      end
    end
  end
  self.m_tbRecipeSet = {}
  local tbRecipeList = self:GetRecipeList(nLifeSkillId) --me.GetRecipeList();
  for _, nRecipeId in ipairs(tbRecipeList) do
    if LifeSkill.tbRecipeDatas[nRecipeId] then
      if LifeSkill.tbRecipeDatas[nRecipeId].Belong == nLifeSkillId then
        self.m_tbRecipeSet[#self.m_tbRecipeSet + 1] = { nId = nRecipeId, tbData = LifeSkill.tbRecipeDatas[nRecipeId] }
      end
    end
  end

  local tbRecipeData = LifeSkill.tbRecipeDatas[nRecipeId]
  local tbSkillData = LifeSkill.tbLifeSkillDatas[nLifeSkillId]
  local nCurFilter1Id = self:GetCurFilter1Id()
  local nCurFilter2Id = self:GetCurFilter2Id()
  local nSeries = self:GetFilter1ValueFromId(nCurFilter1Id) or -1
  local nLevel = self:GetFilter2ValueFromId(nCurFilter2Id) or -1

  if (nSeries > 0 and tbRecipeData.tbProductSet[1].tbItem[6] ~= nSeries) or (nLevel > 0 and tbRecipeData.tbRecipeData[1].tbItem[4] ~= nLevel) then
    return
  end
  local nInsertGroupIndex = -1
  for index = 1, #self.m_tbCurOutLookMap do
    if self.m_tbCurOutLookMap[index] == tbRecipeData.KindName then
      nInsertGroupIndex = index - 1
      break
    end
  end

  if nInsertGroupIndex < 0 then
    AddOutLookGroup(self.UIGROUP, self.OUTLOOK_RECIPE, tbRecipeData.KindName)
    self.m_tbCurOutLookMap[#self.m_tbCurOutLookMap + 1] = tbRecipeData.KindName
    nInsertGroupIndex = #self.m_tbCurOutLookMap
  end

  AddOutLookItem(self.UIGROUP, self.OUTLOOK_RECIPE, nInsertGroupIndex, { tbRecipeData.Name }, tostring(nRecipeId))
end

-- 删除一个配方的时候调用
function uiProduce:OnDelRecipe(nRecipeId)
  -- TODO:liuchang
end

-- 如果没收到这个消息则会停止
function uiProduce:OnProductSuccess(nRecipeId, nRet)
  if nRet == 0 then
    if self.m_szBGM then
      StopSound(self.m_szBGM)
    end
    self.m_bProducing = 0
  else
    self.m_nMakeCount = self.m_nMakeCount - 1
    if self.m_nMakeCount > 0 then
      self:MakeProduce()
    else
      if self.m_szBGM then
        StopSound(self.m_szBGM)
      end
      self.m_bProducing = 0
    end

    self:DecreaseMakeCount()
  end
end

function uiProduce:UpdateCurSelectRecipe()
  if UiManager:WindowVisible(Ui.UI_PRODUCE) ~= 0 then
    local nGroupIdx, nItemIdx = GetOutLookCurSelItemIdx(self.UIGROUP, self.OUTLOOK_RECIPE)
    if not nGroupIdx or not nItemIdx then
      if self:SelectFirstItem() == 0 then
        return
      end
    end
    local nRecipeId = tonumber(GetOutLookItemUserDesc(self.UIGROUP, self.OUTLOOK_RECIPE, nGroupIdx, nItemIdx))
    self:UpdateRecipe(nRecipeId)
  end
end

function uiProduce:SelectFirstItem()
  local nItemCount = GetOutLookGroupItemCount(self.UIGROUP, self.OUTLOOK_RECIPE, 0)
  if nItemCount > 0 then
    OutLookPanelSelItem(self.UIGROUP, self.OUTLOOK_RECIPE, 0, 0)
  else
    return 0
  end
  return 1
end

function uiProduce:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_DELLIFESKILL, self.OnDelSkill },
    { UiNotify.emCOREEVENT_CHANGELIFESKILLLEVEL, self.OnSkillLevelUp },
    { UiNotify.emCOREEVENT_CHANGELIFESKILLEXP, self.OnSkillAttrModify },
    { UiNotify.emCOREEVENT_ADDRECIPE, self.OnAddRecipe },
    { UiNotify.emCOREEVENT_DELRECIPE, self.OnDelRecipe },
    { UiNotify.emCOREEVENT_DORECIPE_SUCCESS, self.OnProductSuccess },
    { UiNotify.emCOREEVENT_SYNC_GTP, self.UpdateCurSelectRecipe },
    { UiNotify.emCOREEVENT_SYNC_MKP, self.UpdateCurSelectRecipe },
    { UiNotify.emCOREEVENT_SYNC_ITEM, self.UpdateCurSelectRecipe },
  }
  tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbEquipCont:RegisterEvent())
  tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbStuffCont:RegisterEvent())
  return tbRegEvent
end

function uiProduce:RegisterMessage()
  local tbRegMsg = Lib:MergeTable(self.tbEquipCont:RegisterMessage(), self.tbStuffCont:RegisterMessage())
  return tbRegMsg
end

function uiProduce:GetRecipeList(nSkillId)
  local tbRecipes1 = me.GetRecipeList()
  local tbSkill = me.GetSingleLifeSkill(nSkillId)
  local nSkillLevel = tbSkill.nLevel
  local tbRecipes2 = LifeSkill:GetSkillFixRecipes(nSkillId, nSkillLevel)
  local tbTemp = {}
  for nIndex, nId in pairs(tbRecipes1) do
    tbTemp[nId] = nIndex
  end
  for _, nId in pairs(tbRecipes2) do
    if not tbTemp[nId] then
      table.insert(tbRecipes1, nId)
    end
  end

  return tbRecipes1
end
