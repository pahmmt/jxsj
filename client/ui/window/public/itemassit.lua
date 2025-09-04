--
-- FileName: item_assist.lua
-- Author: zhangbin1
-- Time: 2011/3/7 16:36
-- Ghi chú:
--

local ItemAssit = Ui:GetClass("itemassit")

ItemAssit.tbItemSettingFiles = {
  "equip\\general\\meleeweapon",
  "equip\\general\\rangeweapon",
  "equip\\general\\armor",
  "equip\\general\\helm",
  "equip\\general\\boots",
  "equip\\general\\belt",
  "equip\\general\\amulet",
  "equip\\general\\ring",
  "equip\\general\\necklace",
  "equip\\general\\cuff",
  "equip\\general\\pendant",
  "equip\\general\\horse",
  "equip\\general\\mask",
  "equip\\general\\book",
  "equip\\general\\zhen",
  "equip\\general\\signet",
  "equip\\general\\mantle",
  "equip\\general\\chop",
  "equip\\general\\zhenyuan",
  "equip\\general\\garment",
  "equip\\general\\outhat",
  "equip\\purple\\meleeweapon",
  "equip\\purple\\rangeweapon",
  "equip\\purple\\armor",
  "equip\\purple\\helm",
  "equip\\purple\\boots",
  "equip\\purple\\belt",
  "equip\\purple\\amulet",
  "equip\\purple\\ring",
  "equip\\purple\\necklace",
  "equip\\purple\\cuff",
  "equip\\purple\\pendant",
  "other\\medicine",
  "other\\scriptitem", -- Sẽ gây lỗi
  "other\\skillitem",
  "other\\taskquest",
  "other\\extbag",
  "other\\stuffitem",
  "other\\planitem",
  "other\\stone",
  "equip\\goldequip",
  "equip\\greenequip",
  "equip\\peequipex",
  "partnerequip\\partnerweapon",
  "partnerequip\\partnerbody",
  "partnerequip\\partnerring",
  "partnerequip\\partnercuff",
  "partnerequip\\partneramulet",
}
ItemAssit.nSeries = 0
ItemAssit.tbItemGenre = {
  { szText = "Tất cả", tbGenre = { 1, 2, 3, 4, 5, 6, 17, 18, 19, 20, 21, 22, 23 } },
  { szText = "Dược phẩm", tbGenre = { 17 } },
  { szText = "Trang bị", tbGenre = { 1, 2, 3, 4, 6 } },
  { szText = "Đạo cụ thường dùng", tbGenre = { 18, 19 } },
  { szText = "Trang bị Đồng Hành", tbGenre = { 5 } },
  { szText = "Túi mở rộng", tbGenre = { 21 } },
  { szText = "Đạo cụ nhiệm vụ", tbGenre = { 20 } },
  { szText = "Kỹ năng sống", tbGenre = { 22, 23 } },
  { szText = "Bảo Thạch/Nguyên Thạch", tbGenre = { 24 } },
}

ItemAssit.tbBindType = {
  [0] = "(Không khóa)",
  [1] = "(Nhận sẽ khóa)", -- Nhận sẽ khóa, có thể bán
  [2] = "(Trang bị sẽ khóa)",
  [3] = "(Nhận sẽ khóa)", -- Nhận sẽ khóa, không thể bán
  [4] = "(Không khóa)", -- Không khóa, không thể bán
}

ItemAssit.ITEM_FILE_DIR = "\\setting\\item\\001\\"
ItemAssit.ITEM_FILE_SUFFIX = ".txt"

ItemAssit.BTN_CLOSE = "Btn_Close"
ItemAssit.EDT_ITEM_NAME = "Edt_ItemName"
ItemAssit.CMB_ITEM_GENRE = "Cmb_ItemGenre"
ItemAssit.LST_ITEM_LIST = "Lst_ItemList"
ItemAssit.EDT_ITEM_COUNT = "Edt_ItemCount"
ItemAssit.BTN_ADD_ITEM = "Btn_AddItem"
ItemAssit.BTN_SHOW_ALL = "Btn_ShowAll"

ItemAssit.BTN_PAGE_UP = "Btn_PageUp"
ItemAssit.BTN_PAGE_DOWN = "Btn_PageDown"
ItemAssit.TXT_PAGE = "Txt_Page"
ItemAssit.TXT_TITLE = "Txt_Title"

ItemAssit.ITEM_COUNT_ONE_PAGE = 100

ItemAssit.tbItems = nil

function ItemAssit:OnOpen()
  if not self.tbItems then
    self:LoadSettingFiles()
  end

  self.szNameFilter = self.szNameFilter or ""
  self.tbGenreFilter = self.tbItemGenre[1].tbGenre
  self.nShowAll = self.nShowAll or 0
  self.nAddCount = self.nAddCount or 1
  self.nSelectItem = self.nSelectItem or 1
  self.tbResultItems = self.tbResultItems or {}
  self.tbSelectItem = self.tbSelectItem or nil

  self.nPageCount = self.nPageCount or 1
  self.nCurPage = self.nCurPage or 1
  self.nComboBoxSelect = self.nComboBoxSelect or 0

  Btn_Check(self.UIGROUP, self.BTN_SHOW_ALL, self.nShowAll)
  Edt_SetTxt(self.UIGROUP, self.EDT_ITEM_COUNT, tostring(self.nAddCount))
  Edt_SetTxt(self.UIGROUP, self.EDT_ITEM_NAME, self.szNameFilter)

  self:InitGenreCombo()

  self:Filter()
  self:RefreshPageState()
end

function ItemAssit:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_ADD_ITEM then
    self:AddItem()
  elseif szWnd == self.BTN_SHOW_ALL then
    --print("nParam:", nParam);
    if self.nShowAll ~= nParam then
      self.nShowAll = nParam
      if self.szNameFilter == "" then
        self:Filter()
        self:RefreshPageState()
      end
    end
  elseif szWnd == self.BTN_PAGE_UP then
    if self.nCurPage > 1 then
      self.nCurPage = self.nCurPage - 1
      self:RefreshItemList()
    end
  elseif szWnd == self.BTN_PAGE_DOWN then
    if self.nCurPage < self.nPageCount then
      self.nCurPage = self.nCurPage + 1
      self:RefreshItemList()
    end
  end
end

function ItemAssit:OnEditChange(szWnd, nParam)
  if szWnd == self.EDT_ITEM_NAME then
    local szNewFilter = Edt_GetTxt(self.UIGROUP, self.EDT_ITEM_NAME)
    if szNewFilter ~= self.szNameFilter then
      self.szNameFilter = szNewFilter
      if self.nFiltRegisterId then
        Timer:Close(self.nFiltRegisterId)
      end
      self.nFiltRegisterId = Timer:Register(18, self.FilterAndFresh, self)
    end
  elseif szWnd == self.EDT_ITEM_COUNT then
    local nCount = tonumber(Edt_GetTxt(self.UIGROUP, self.EDT_ITEM_COUNT))
    if nCount ~= self.nAddCount then
      self.nAddCount = nCount
    end
  end
end

function ItemAssit:FilterAndFresh()
  self:Filter()
  self:RefreshPageState()
  self.nFiltRegisterId = nil
  return 0
end

function ItemAssit:OnComboBoxIndexChange(szWnd, nIndex)
  if szWnd == self.CMB_ITEM_GENRE then
    local tbTempGenres = self.tbItemGenre[nIndex + 1].tbGenre
    if tbTempGenres ~= self.tbGenreFilter then
      self.nComboBoxSelect = nIndex
      self.tbSelectItem = nil
      self.tbGenreFilter = tbTempGenres
      self:Filter()
      self:RefreshPageState()
    end
  end
end

function ItemAssit:OnListSel(szWnd, nParam)
  if szWnd == self.LST_ITEM_LIST then
    local nStartIndex = (self.nCurPage - 1) * self.ITEM_COUNT_ONE_PAGE
    self.tbSelectItem = self.tbResultItems[nStartIndex + nParam]
    self.nSelectItem = nParam
  end
end

function ItemAssit:OnListOver(szWnd, nItemIndex)
  if szWnd ~= self.LST_ITEM_LIST then
    return
  end
  local nStartIndex = (self.nCurPage - 1) * self.ITEM_COUNT_ONE_PAGE
  local tbItem = self.tbResultItems[nStartIndex + nItemIndex]
  if not tbItem then
    --print("Đạo cụ trợ giúp：Vật phẩm ", nStartIndex + nItemIndex, " không tìm thấy");
    return
  end

  local bOk, szTitle, szTip, szViewImage

  local pItem = KItem.CreateTempItem(tonumber(tbItem.Genre), tonumber(tbItem.DetailType), tonumber(tbItem.ParticularType), tonumber(tbItem.Level))
  if pItem then
    bOk, szTitle, szTip, szViewImage = pcall(pItem.GetTip, pItem, Item.TIPS_PREVIEW)
    pItem.Remove()
  end

  if not bOk then
    szTitle, szTip, szViewImage = "Lỗi", "Xảy ra lỗi khi lấy Tips", ""
  end
  Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, szTitle, szTip, szViewImage)
end

function ItemAssit:LoadSettingFiles()
  if not self.nRegisterId then
    self.tbItems = {}
    self.nSeries = 1
    Txt_SetTxt(self.UIGROUP, self.TXT_TITLE, "Đạo cụ trợ giúp (Đang tải 0%)")
    self.nRegisterId = Timer:Register(3, self.LoadSettingFilesFrame, self)
  end
end

function ItemAssit:LoadSettingFilesFrame()
  if not self.tbItemSettingFiles[self.nSeries] then
    self.nRegisterId = nil
    Txt_SetTxt(self.UIGROUP, self.TXT_TITLE, "Đạo cụ trợ giúp (Đã tải xong)")
    return 0
  end
  local v = self.tbItemSettingFiles[self.nSeries]
  local file = self.ITEM_FILE_DIR .. v .. self.ITEM_FILE_SUFFIX
  local tbData = Lib:LoadTabFile(file)
  if not tbData then
    --print("Đạo cụ trợ giúp：" .. file .. " tải thất bại！");
  else
    for _, v1 in ipairs(tbData) do
      table.insert(self.tbItems, v1)
    end
  end
  self.nSeries = self.nSeries + 1
  --print("Load>>>>>>>>>>>>>", v)
  Txt_SetTxt(self.UIGROUP, self.TXT_TITLE, string.format("Đạo cụ trợ giúp (Đang tải %d%%)", math.floor((self.nSeries / #self.tbItemSettingFiles) * 100)))
  return
end

function ItemAssit:InitGenreCombo()
  ClearComboBoxItem(self.UIGROUP, self.CMB_ITEM_GENRE)
  for i = 1, #self.tbItemGenre do
    ComboBoxAddItem(self.UIGROUP, self.CMB_ITEM_GENRE, i, self.tbItemGenre[i].szText)
  end
  ComboBoxSelectItem(self.UIGROUP, self.CMB_ITEM_GENRE, self.nComboBoxSelect)
end

function ItemAssit:RefreshPageState()
  local nResultItemCount = #self.tbResultItems

  self.nPageCount = math.ceil(nResultItemCount / self.ITEM_COUNT_ONE_PAGE)
  if self.nPageCount == 0 then
    self.nPageCount = 1
  end

  self.nCurPage = self.nCurPage or 1
  if self.nCurPage > self.nPageCount then
    self.nCurPage = 1
  end

  if self.nEditRegisterId then
    Timer:Close(self.nEditRegisterId)
  end
  --if not self.nRegisterId then
  self.nEditRegisterId = Timer:Register(18, self.RefreshItemList, self)
  --end
end

function ItemAssit:RefreshItemList()
  Lst_Clear(self.UIGROUP, self.LST_ITEM_LIST)
  Txt_SetTxt(self.UIGROUP, self.TXT_PAGE, self.nCurPage .. "/" .. self.nPageCount)

  local nStartIndex = (self.nCurPage - 1) * self.ITEM_COUNT_ONE_PAGE
  for i = 1, self.ITEM_COUNT_ONE_PAGE do
    if not self.tbResultItems[i + nStartIndex] then
      break
    end
    self:ShowItem(i, self.tbResultItems[i + nStartIndex])
  end

  if #self.tbResultItems > 0 then
    Lst_SetCurKey(self.UIGROUP, self.LST_ITEM_LIST, self.nSelectItem or 1)
  end
  self.nEditRegisterId = nil
  return 0
end

function ItemAssit:ShowItem(nIndex, tbItem)
  -- Cột đầu tiên Name
  local szName = tbItem.Name
  local nBindType = tonumber(tbItem.BindType)
  if nBindType and nBindType >= 0 and nBindType < #self.tbBindType then
    szName = szName .. self.tbBindType[nBindType]
  end
  Lst_SetCell(self.UIGROUP, self.LST_ITEM_LIST, nIndex, 0, szName)

  -- Cột thứ ba Kind
  Lst_SetCell(self.UIGROUP, self.LST_ITEM_LIST, nIndex, 2, tbItem.Kind)

  -- Cột thứ năm GDPL
  local szGdpl = string.format("%s,%s,%s,%s", tbItem.Genre, tbItem.DetailType, tbItem.ParticularType, tbItem.Level)
  Lst_SetCell(self.UIGROUP, self.LST_ITEM_LIST, nIndex, 4, szGdpl)
end

function ItemAssit:Filter()
  self.tbResultItems = {}

  if self.nShowAll == 0 and self.szNameFilter == "" then
    return
  end

  for _, v in ipairs(self.tbItems) do
    if 1 == self:IsItemSuit(v) then
      table.insert(self.tbResultItems, v)
    end
  end
end

function ItemAssit:IsItemSuit(tbItem)
  if not tbItem.Name then
    return 0
  end

  local szGDPL = string.format("%s,%s,%s,%s", tbItem.Genre, tbItem.DetailType, tbItem.ParticularType, tbItem.Level)

  if self.szNameFilter ~= "" and not KLib.FindStr(tbItem.Name, self.szNameFilter) and not KLib.FindStr(szGDPL, self.szNameFilter) then
    return 0
  end

  local nGenre = tonumber(tbItem.Genre)
  for _, v in pairs(self.tbGenreFilter) do
    if v == nGenre then
      return 1
    end
  end
  return 0
end

function ItemAssit:AddItem()
  if not self.tbSelectItem then
    --print("Đạo cụ trợ giúp：Vui lòng chọn vật phẩm trước！");
    return
  end

  if self.nAddCount <= 0 then
    --print("Đạo cụ trợ giúp：Số lượng vật phẩm phải lớn hơn 0！");
    return
  end

  if not me then
    return
  end

  local szCmd = string.format("?gm ds me.AddStackItem(%s,%s,%s,%s,nil,%s)", self.tbSelectItem.Genre, self.tbSelectItem.DetailType, self.tbSelectItem.ParticularType, self.tbSelectItem.Level, self.nAddCount)
  SendChannelMsg("GM", szCmd)
end
