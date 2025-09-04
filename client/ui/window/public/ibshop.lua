local uiIbShop = Ui:GetClass("ibshop")

uiIbShop.MAX_TYPES_SHOW = IbShop.MAX_TYPES_SHOW
uiIbShop.MAX_SHOW_NUMBER = IbShop.MAX_SHOW_NUMBER

uiIbShop.CLOSE_WINDOWS = "BtnClose"
uiIbShop.BUTTON_LOOKCAR = "BtnLookCar"
uiIbShop.TXT_GOLD_NUMBER = "TxtGoldNumber"
uiIbShop.TXT_SILVER_NUMBER = "TxtSilveNumber"
uiIbShop.TXT_BIND_GOLD_NUMBER = "TxtBindGoldNumber"
uiIbShop.TXT_BANK_GOLD_NUMBER = "TxtBankCoinNumber"
uiIbShop.BUTTON_UP_PAGE = "BtnUpPage"
uiIbShop.BUTTON_NEXT_PAGE = "BtnDownPage"
uiIbShop.TXT_PAGE_NUMBER = "TxtPageNumber"
uiIbShop.TXT_TYPE_DESCRIPTION = "TxtTypeDescription"
uiIbShop.TXT_NUMBER_GOLD = "TxtGoldNum"
uiIbShop.TXT_NUMBER_BINDGOLD = "TxtBindGoldNum"
uiIbShop.TXT_NUMERBER_SILVER = "TxtSilverNum"
uiIbShop.TXT_NUMBER_BANKCOIN = "TxtBankCoinNum"
uiIbShop.TXT_NUMBER_INTEGRAL = "TxtIntegralNum"
uiIbShop.BUTTON_JBEXCHANGE = "BtnJbExchange"
uiIbShop.BUTTON_ONLINEPAY = "BtnOnlinePay"
uiIbShop.BUTTON_AUCTION = "BtnAuction"
uiIbShop.BUTTON_TASK = "BtnTask"
uiIbShop.BUTTON_BaiBaoXiang = "BtnBaiBaoXiang"
uiIbShop.TXX_INFOR = "TxtExInFor"

uiIbShop.PAGE_TYPE = 1
uiIbShop.TXT_TYPE_TITLE = 2
uiIbShop.TXT_OLD_PRICE = 3
uiIbShop.TXT_NOW_PRICE = 4
uiIbShop.TXT_LEFT_NUMBER = 5
uiIbShop.BUTTON_BUY = 6
uiIbShop.BUTTON_TRY = 7
uiIbShop.SHOW_PIC = 8
uiIbShop.IMG_DISCOUNT = 9
uiIbShop.TXT_DISCOUNT = 10
uiIbShop.GOOD_SHOWS = {
  [1] = {
    [uiIbShop.PAGE_TYPE] = "PageSetType1",
    [uiIbShop.TXT_TYPE_TITLE] = "TxtTypeTitle1",
    [uiIbShop.TXT_OLD_PRICE] = "TxtTypeOldPrice1",
    [uiIbShop.TXT_NOW_PRICE] = "TxtTypeNewPrice1",
    [uiIbShop.TXT_LEFT_NUMBER] = "TxtTypeLeftNumber1",
    [uiIbShop.BUTTON_BUY] = "BtnTypeBuy1",
    [uiIbShop.BUTTON_TRY] = "BtnTypeTry1",
    [uiIbShop.SHOW_PIC] = "ObjImgTypeMatrix1",
    [uiIbShop.IMG_DISCOUNT] = "ImgDiscount1",
    [uiIbShop.TXT_DISCOUNT] = "TxtDiscount1",
  },
  [2] = {
    [uiIbShop.PAGE_TYPE] = "PageSetType2",
    [uiIbShop.TXT_TYPE_TITLE] = "TxtTypeTitle2",
    [uiIbShop.TXT_OLD_PRICE] = "TxtTypeOldPrice2",
    [uiIbShop.TXT_NOW_PRICE] = "TxtTypeNewPrice2",
    [uiIbShop.TXT_LEFT_NUMBER] = "TxtTypeLeftNumber2",
    [uiIbShop.BUTTON_BUY] = "BtnTypeBuy2",
    [uiIbShop.BUTTON_TRY] = "BtnTypeTry2",
    [uiIbShop.SHOW_PIC] = "ObjImgTypeMatrix2",
    [uiIbShop.IMG_DISCOUNT] = "ImgDiscount2",
    [uiIbShop.TXT_DISCOUNT] = "TxtDiscount2",
  },
  [3] = {
    [uiIbShop.PAGE_TYPE] = "PageSetType3",
    [uiIbShop.TXT_TYPE_TITLE] = "TxtTypeTitle3",
    [uiIbShop.TXT_OLD_PRICE] = "TxtTypeOldPrice3",
    [uiIbShop.TXT_NOW_PRICE] = "TxtTypeNewPrice3",
    [uiIbShop.TXT_LEFT_NUMBER] = "TxtTypeLeftNumber3",
    [uiIbShop.BUTTON_BUY] = "BtnTypeBuy3",
    [uiIbShop.BUTTON_TRY] = "BtnTypeTry3",
    [uiIbShop.SHOW_PIC] = "ObjImgTypeMatrix3",
    [uiIbShop.IMG_DISCOUNT] = "ImgDiscount3",
    [uiIbShop.TXT_DISCOUNT] = "TxtDiscount3",
  },
  [4] = {
    [uiIbShop.PAGE_TYPE] = "PageSetType4",
    [uiIbShop.TXT_TYPE_TITLE] = "TxtTypeTitle4",
    [uiIbShop.TXT_OLD_PRICE] = "TxtTypeOldPrice4",
    [uiIbShop.TXT_NOW_PRICE] = "TxtTypeNewPrice4",
    [uiIbShop.TXT_LEFT_NUMBER] = "TxtTypeLeftNumber4",
    [uiIbShop.BUTTON_BUY] = "BtnTypeBuy4",
    [uiIbShop.BUTTON_TRY] = "BtnTypeTry4",
    [uiIbShop.SHOW_PIC] = "ObjImgTypeMatrix4",
    [uiIbShop.IMG_DISCOUNT] = "ImgDiscount4",
    [uiIbShop.TXT_DISCOUNT] = "TxtDiscount4",
  },
  [5] = {
    [uiIbShop.PAGE_TYPE] = "PageSetType5",
    [uiIbShop.TXT_TYPE_TITLE] = "TxtTypeTitle5",
    [uiIbShop.TXT_OLD_PRICE] = "TxtTypeOldPrice5",
    [uiIbShop.TXT_NOW_PRICE] = "TxtTypeNewPrice5",
    [uiIbShop.TXT_LEFT_NUMBER] = "TxtTypeLeftNumber5",
    [uiIbShop.BUTTON_BUY] = "BtnTypeBuy5",
    [uiIbShop.BUTTON_TRY] = "BtnTypeTry5",
    [uiIbShop.SHOW_PIC] = "ObjImgTypeMatrix5",
    [uiIbShop.IMG_DISCOUNT] = "ImgDiscount5",
    [uiIbShop.TXT_DISCOUNT] = "TxtDiscount5",
  },
  [6] = {
    [uiIbShop.PAGE_TYPE] = "PageSetType6",
    [uiIbShop.TXT_TYPE_TITLE] = "TxtTypeTitle6",
    [uiIbShop.TXT_OLD_PRICE] = "TxtTypeOldPrice6",
    [uiIbShop.TXT_NOW_PRICE] = "TxtTypeNewPrice6",
    [uiIbShop.TXT_LEFT_NUMBER] = "TxtTypeLeftNumber6",
    [uiIbShop.BUTTON_BUY] = "BtnTypeBuy6",
    [uiIbShop.BUTTON_TRY] = "BtnTypeTry6",
    [uiIbShop.SHOW_PIC] = "ObjImgTypeMatrix6",
    [uiIbShop.IMG_DISCOUNT] = "ImgDiscount6",
    [uiIbShop.TXT_DISCOUNT] = "TxtDiscount6",
  },
  [7] = {
    [uiIbShop.PAGE_TYPE] = "PageSetType7",
    [uiIbShop.TXT_TYPE_TITLE] = "TxtTypeTitle7",
    [uiIbShop.TXT_OLD_PRICE] = "TxtTypeOldPrice7",
    [uiIbShop.TXT_NOW_PRICE] = "TxtTypeNewPrice7",
    [uiIbShop.TXT_LEFT_NUMBER] = "TxtTypeLeftNumber7",
    [uiIbShop.BUTTON_BUY] = "BtnTypeBuy7",
    [uiIbShop.BUTTON_TRY] = "BtnTypeTry7",
    [uiIbShop.SHOW_PIC] = "ObjImgTypeMatrix7",
    [uiIbShop.IMG_DISCOUNT] = "ImgDiscount7",
    [uiIbShop.TXT_DISCOUNT] = "TxtDiscount7",
  },
  [8] = {
    [uiIbShop.PAGE_TYPE] = "PageSetType8",
    [uiIbShop.TXT_TYPE_TITLE] = "TxtTypeTitle8",
    [uiIbShop.TXT_OLD_PRICE] = "TxtTypeOldPrice8",
    [uiIbShop.TXT_NOW_PRICE] = "TxtTypeNewPrice8",
    [uiIbShop.TXT_LEFT_NUMBER] = "TxtTypeLeftNumber8",
    [uiIbShop.BUTTON_BUY] = "BtnTypeBuy8",
    [uiIbShop.BUTTON_TRY] = "BtnTypeTry8",
    [uiIbShop.SHOW_PIC] = "ObjImgTypeMatrix8",
    [uiIbShop.IMG_DISCOUNT] = "ImgDiscount8",
    [uiIbShop.TXT_DISCOUNT] = "TxtDiscount8",
  },
  [9] = {
    [uiIbShop.PAGE_TYPE] = "PageSetType9",
    [uiIbShop.TXT_TYPE_TITLE] = "TxtTypeTitle9",
    [uiIbShop.TXT_OLD_PRICE] = "TxtTypeOldPrice9",
    [uiIbShop.TXT_NOW_PRICE] = "TxtTypeNewPrice9",
    [uiIbShop.TXT_LEFT_NUMBER] = "TxtTypeLeftNumber9",
    [uiIbShop.BUTTON_BUY] = "BtnTypeBuy9",
    [uiIbShop.BUTTON_TRY] = "BtnTypeTry9",
    [uiIbShop.SHOW_PIC] = "ObjImgTypeMatrix9",
    [uiIbShop.IMG_DISCOUNT] = "ImgDiscount9",
    [uiIbShop.TXT_DISCOUNT] = "TxtDiscount9",
  },
  [10] = {
    [uiIbShop.PAGE_TYPE] = "PageSetType10",
    [uiIbShop.TXT_TYPE_TITLE] = "TxtTypeTitle10",
    [uiIbShop.TXT_OLD_PRICE] = "TxtTypeOldPrice10",
    [uiIbShop.TXT_NOW_PRICE] = "TxtTypeNewPrice10",
    [uiIbShop.TXT_LEFT_NUMBER] = "TxtTypeLeftNumber10",
    [uiIbShop.BUTTON_BUY] = "BtnTypeBuy10",
    [uiIbShop.BUTTON_TRY] = "BtnTypeTry10",
    [uiIbShop.SHOW_PIC] = "ObjImgTypeMatrix10",
    [uiIbShop.IMG_DISCOUNT] = "ImgDiscount10",
    [uiIbShop.TXT_DISCOUNT] = "TxtDiscount10",
  },
  [11] = {
    [uiIbShop.PAGE_TYPE] = "PageSetType11",
    [uiIbShop.TXT_TYPE_TITLE] = "TxtTypeTitle11",
    [uiIbShop.TXT_OLD_PRICE] = "TxtTypeOldPrice11",
    [uiIbShop.TXT_NOW_PRICE] = "TxtTypeNewPrice11",
    [uiIbShop.TXT_LEFT_NUMBER] = "TxtTypeLeftNumber11",
    [uiIbShop.BUTTON_BUY] = "BtnTypeBuy11",
    [uiIbShop.BUTTON_TRY] = "BtnTypeTry11",
    [uiIbShop.SHOW_PIC] = "ObjImgTypeMatrix11",
    [uiIbShop.IMG_DISCOUNT] = "ImgDiscount11",
    [uiIbShop.TXT_DISCOUNT] = "TxtDiscount11",
  },
  [12] = {
    [uiIbShop.PAGE_TYPE] = "PageSetType12",
    [uiIbShop.TXT_TYPE_TITLE] = "TxtTypeTitle12",
    [uiIbShop.TXT_OLD_PRICE] = "TxtTypeOldPrice12",
    [uiIbShop.TXT_NOW_PRICE] = "TxtTypeNewPrice12",
    [uiIbShop.TXT_LEFT_NUMBER] = "TxtTypeLeftNumber12",
    [uiIbShop.BUTTON_BUY] = "BtnTypeBuy12",
    [uiIbShop.BUTTON_TRY] = "BtnTypeTry12",
    [uiIbShop.SHOW_PIC] = "ObjImgTypeMatrix12",
    [uiIbShop.IMG_DISCOUNT] = "ImgDiscount12",
    [uiIbShop.TXT_DISCOUNT] = "TxtDiscount12",
  },
  [13] = {
    [uiIbShop.PAGE_TYPE] = "PageSetType13",
    [uiIbShop.TXT_TYPE_TITLE] = "TxtTypeTitle13",
    [uiIbShop.TXT_OLD_PRICE] = "TxtTypeOldPrice13",
    [uiIbShop.TXT_NOW_PRICE] = "TxtTypeNewPrice13",
    [uiIbShop.TXT_LEFT_NUMBER] = "TxtTypeLeftNumber13",
    [uiIbShop.BUTTON_BUY] = "BtnTypeBuy13",
    [uiIbShop.BUTTON_TRY] = "BtnTypeTry13",
    [uiIbShop.SHOW_PIC] = "ObjImgTypeMatrix13",
    [uiIbShop.IMG_DISCOUNT] = "ImgDiscount13",
    [uiIbShop.TXT_DISCOUNT] = "TxtDiscount13",
  },
  [14] = {
    [uiIbShop.PAGE_TYPE] = "PageSetType14",
    [uiIbShop.TXT_TYPE_TITLE] = "TxtTypeTitle14",
    [uiIbShop.TXT_OLD_PRICE] = "TxtTypeOldPrice14",
    [uiIbShop.TXT_NOW_PRICE] = "TxtTypeNewPrice14",
    [uiIbShop.TXT_LEFT_NUMBER] = "TxtTypeLeftNumber14",
    [uiIbShop.BUTTON_BUY] = "BtnTypeBuy14",
    [uiIbShop.BUTTON_TRY] = "BtnTypeTry14",
    [uiIbShop.SHOW_PIC] = "ObjImgTypeMatrix14",
    [uiIbShop.IMG_DISCOUNT] = "ImgDiscount14",
    [uiIbShop.TXT_DISCOUNT] = "TxtDiscount14",
  },
  [15] = {
    [uiIbShop.PAGE_TYPE] = "PageSetType15",
    [uiIbShop.TXT_TYPE_TITLE] = "TxtTypeTitle15",
    [uiIbShop.TXT_OLD_PRICE] = "TxtTypeOldPrice15",
    [uiIbShop.TXT_NOW_PRICE] = "TxtTypeNewPrice15",
    [uiIbShop.TXT_LEFT_NUMBER] = "TxtTypeLeftNumber15",
    [uiIbShop.BUTTON_BUY] = "BtnTypeBuy15",
    [uiIbShop.BUTTON_TRY] = "BtnTypeTry15",
    [uiIbShop.SHOW_PIC] = "ObjImgTypeMatrix15",
    [uiIbShop.IMG_DISCOUNT] = "ImgDiscount15",
    [uiIbShop.TXT_DISCOUNT] = "TxtDiscount15",
  },
}

uiIbShop.BUTTON_TYPES = {
  [1] = "BtnType1",
  [2] = "BtnType2",
  [3] = "BtnType3",
  [4] = "BtnType4",
  [5] = "BtnType5",
  [6] = "BtnType6",
  [7] = "BtnType7",
  [8] = "BtnType8",
  [9] = "BtnType9",
  [10] = "BtnType10",
  [11] = "BtnType11",
  [12] = "BtnType12",
  [13] = "BtnType13",
  [14] = "BtnType14",
  [15] = "BtnType15",
}

uiIbShop.BUTTON_GOLD_SECTION = IbShop.GOLD_SECTION
--uiIbShop.BUTTON_SILVER_SECTION   	= IbShop.BUTTON_SILVER_SECTION;
uiIbShop.BUTTON_BINDGOLD_SECTION = IbShop.BINDGOLD_SECTION
uiIbShop.BUTTON_INTEGRAL_SECTION = IbShop.INTEGRAL_SECTION

uiIbShop.BUTTON_SECTIONS = {
  [uiIbShop.BUTTON_GOLD_SECTION] = "BtnGoldSection",
  --[uiIbShop.BUTTON_SILVER_SECTION] 	  = "BtnSilverSection";
  [uiIbShop.BUTTON_BINDGOLD_SECTION] = "BtnBindGoldSection",
  [uiIbShop.BUTTON_INTEGRAL_SECTION] = "BtnIntegralSection",
}

function uiIbShop:Init()
  self.m_nZoneType = nil
  self.m_nWareType = 1
  self.m_nTotalPageNum = 0
  self.m_nCurPageNumber = 0
  self.tbPrvWareID = nil
  self.tbWareID = nil
  self.tbLstTypes = {}
  self.tbInfo = {}
  self.tbPageNumber = {}
  self.m_nFirstOpen = 1
  self.nSection = 0
  self.tbTempItems = {}
  self.tbDate = {
    SilverZone = {},
    GoldZone = {},
  }
end

------------------------------------------------------------------------------
--写log
function uiIbShop:WriteStatLog()
  Log:Ui_SendLog("打开奇珍阁", 1)
end

function uiIbShop:OnOpen(nType)
  IbShop:Init()
  if IVER_g_nSdoVersion == 1 then
    QuerySndaCoin()
  end
  if me.IsAccountLock() ~= 0 then
    UiManager:CloseWindow(Ui.UI_IBSHOP)
    UiNotify:OnNotify(UiNotify.emCOREEVENT_SET_POPTIP, 44)
    Account:OpenLockWindow()
    me.Msg("你的账号处于锁定状态，无法进行该操作！")
    return 0
  end
  self:WriteStatLog()

  --写log
  Log:Ui_SendLog("点击金币区新品上市", 1) --默认的是金币区的新品上市

  self:HideGoodsShow()

  Btn_Check(self.UIGROUP, self.BUTTON_SECTIONS[1], 1)
  Btn_Check(self.UIGROUP, self.BUTTON_TYPES[1], 1)
  me.IbShop_Open()
  self.m_nZoneType = 1
end

--隐藏商品窗口
function uiIbShop:HideGoodsShow()
  for i = 1, self.MAX_SHOW_NUMBER do
    Wnd_Hide(self.UIGROUP, self.GOOD_SHOWS[i][self.PAGE_TYPE])
  end
end

function uiIbShop:OnEscExclusiveWnd(szWnd)
  UiManager:CloseWindow(self.UIGROUP)
end

function uiIbShop:OnClose()
  local bIsEmpty = me.IbCartIsEmpty()

  if UiManager:WindowVisible(Ui.UI_IBSHOPCART) ~= 1 then
    if bIsEmpty ~= 1 then
      self:ShowColseMsgBox()
    end
  end

  if bIsEmpty == 1 then
    if UiManager:WindowVisible(Ui.UI_IBSHOPCART) == 1 then
      UiManager:CloseWindow(Ui.UI_IBSHOPCART)
    end
  end

  self:CleartTempItems()

  IbShop:UnInit()
end

function uiIbShop:CleartTempItems()
  for _, pItem in pairs(self.tbTempItems) do
    if pItem then
      pItem.Remove()
    end
  end
  self.tbTempItems = {}
end

function uiIbShop:WndOpenCloseCallback(szWnd, nParam)
  if szWnd == Ui.UI_JBEXCHANGE then
    Btn_Check(self.UIGROUP, self.BUTTON_JBEXCHANGE, nParam)
  end
end

function uiIbShop:UpdatePageShow()
  if not self.tbLstTypes or #self.tbLstTypes == 0 or not self.tbPageNumber or #self.tbPageNumber == 0 then
    return
  end
  local nType = self.tbLstTypes[self.m_nWareType].nType
  local nTotalNum = self.tbPageNumber[self.m_nZoneType][nType]
  if not nTotalNum then
    return
  end
  -- 写log
  if self.BUTTON_SECTIONS[self.m_nZoneType] == "BtnGoldSection" and nType == 1 then
    Log:Ui_SendLog("点击金币区新品上市", 1)
  elseif self.BUTTON_SECTIONS[self.m_nZoneType] == "BtnGoldSection" and nType == 2 then
    Log:Ui_SendLog("点击金币区推荐商品", 1)
  elseif self.BUTTON_SECTIONS[self.m_nZoneType] == "BtnSilverSection" then
    Log:Ui_SendLog("点击银两页", 1)
  elseif self.BUTTON_SECTIONS[self.m_nZoneType] == "BtnBindGoldSection" and nType == 1 then
    Log:Ui_SendLog("点击绑金区新品上市", 1)
  elseif self.BUTTON_SECTIONS[self.m_nZoneType] == "BtnBindGoldSection" and nType == 2 then
    Log:Ui_SendLog("点击绑金区推荐商品", 1)
  end

  if nTotalNum == 0 then
    self.m_nCurPageNumber = 0
  end
  self.m_nTotalPageNum = math.ceil(nTotalNum / self.MAX_SHOW_NUMBER)
  local szBuff = self.m_nCurPageNumber .. "/" .. self.m_nTotalPageNum
  Txt_SetTxt(self.UIGROUP, self.TXT_PAGE_NUMBER, szBuff)
  if self.m_nCurPageNumber == 1 then
    Btn_Check(self.UIGROUP, self.BUTTON_UP_PAGE, 1)
  else
    Btn_Check(self.UIGROUP, self.BUTTON_UP_PAGE, 0)
  end
  if self.m_nCurPageNumber == self.m_nTotalPageNum then
    Btn_Check(self.UIGROUP, self.BUTTON_NEXT_PAGE, 1)
  else
    Btn_Check(self.UIGROUP, self.BUTTON_NEXT_PAGE, 0)
  end

  if self.m_nTotalPageNum <= 1 then
    Wnd_SetEnable(self.UIGROUP, self.BUTTON_UP_PAGE, 0)
    Wnd_SetEnable(self.UIGROUP, self.BUTTON_NEXT_PAGE, 0)
  else
    Wnd_SetEnable(self.UIGROUP, self.BUTTON_UP_PAGE, 1)
    Wnd_SetEnable(self.UIGROUP, self.BUTTON_NEXT_PAGE, 1)
  end
end

function uiIbShop:UpdateTypeList()
  self.tbLstTypes = nil
  self.tbLstTypes = {}
  local nZoneType = 0 -- 默认是金币区
  if self.m_nZoneType ~= nil then
    nZoneType = self.m_nZoneType
  end
  self.tbLstTypes = me.IbShop_GetWareTypeList(nZoneType)

  local nSize = (#self.tbLstTypes > self.MAX_TYPES_SHOW) and self.MAX_TYPES_SHOW or #self.tbLstTypes

  --按一定顺序整理界面
  if nZoneType and IbShop.UiSort_Bnt[nZoneType] then
    local tbLstTypesTemp = {}
    for i, nTypeId in pairs(IbShop.UiSort_Bnt[nZoneType]) do
      for _, tbInfo in pairs(self.tbLstTypes) do
        if tbInfo.nType == nTypeId then
          table.insert(tbLstTypesTemp, tbInfo)
        end
      end
    end
    self.tbLstTypes = tbLstTypesTemp
  end

  --TO  do
  for i = 1, nSize do
    Btn_SetTxt(self.UIGROUP, self.BUTTON_TYPES[i], self.tbLstTypes[i]["szName"])
    Wnd_Show(self.UIGROUP, self.BUTTON_TYPES[i])
  end
  for i = nSize + 1, self.MAX_TYPES_SHOW do
    Wnd_Hide(self.UIGROUP, self.BUTTON_TYPES[i])
  end
end

function uiIbShop:UpPage()
  local nNow = self.m_nCurPageNumber - 1
  self.m_nCurPageNumber = (nNow <= 1) and 1 or nNow

  if self.m_nTotalPageNum == 0 then
    return
  end
  if self.m_nCurPageNumber == 1 then
    Btn_Check(self.UIGROUP, self.BUTTON_UP_PAGE, 1)
  else
    Btn_Check(self.UIGROUP, self.BUTTON_UP_PAGE, 0)
  end

  if self.m_nTotalPageNum > self.m_nCurPageNumber then
    Btn_Check(self.UIGROUP, self.BUTTON_NEXT_PAGE, 0)
  else
    Btn_Check(self.UIGROUP, self.BUTTON_NEXT_PAGE, 1)
  end
end

function uiIbShop:NextPage()
  local nNow = self.m_nCurPageNumber + 1

  if nNow >= self.m_nTotalPageNum then
    self.m_nCurPageNumber = self.m_nTotalPageNum
  else
    self.m_nCurPageNumber = nNow
  end

  if self.m_nCurPageNumber == self.m_nTotalPageNum then
    Btn_Check(self.UIGROUP, self.BUTTON_NEXT_PAGE, 1)
  else
    Btn_Check(self.UIGROUP, self.BUTTON_NEXT_PAGE, 0)
  end

  if self.m_nCurPageNumber > 1 then
    Btn_Check(self.UIGROUP, self.BUTTON_UP_PAGE, 0)
  else
    Btn_Check(self.UIGROUP, self.BUTTON_UP_PAGE, 1)
  end
end

function uiIbShop:OnButtonClick(szWnd, nParam)
  if szWnd == self.CLOSE_WINDOWS then
    UiManager:CloseWindow(self.UIGROUP)
    return
  elseif szWnd == self.BUTTON_LOOKCAR then
    UiManager:OpenWindow(Ui.UI_IBSHOPCART)
  elseif szWnd == self.BUTTON_ONLINEPAY then
    if IVER_g_nSdoVersion == 1 then
      OpenSDOWidget()
      return
    end
    me.CallServerScript({ "ApplyOpenOnlinePay" })
    return
  elseif szWnd == self.BUTTON_UP_PAGE then
    if self.m_nTotalPageNum == 0 then
      return
    else
      self:UpPage()
    end
  elseif szWnd == self.BUTTON_NEXT_PAGE then
    if self.m_nTotalPageNum == 0 then
      return
    else
      self:NextPage()
    end
  elseif szWnd == self.BUTTON_AUCTION then
    UiManager:OpenWindow(Ui.UI_AUCTIONROOM, 1)
  elseif szWnd == self.BUTTON_TASK then
    UiManager:CloseWindow(self.UIGROUP)
    UiManager:OpenWindow(Ui.UI_EXPTASK, 1)
    return
  elseif szWnd == self.BUTTON_BaiBaoXiang then
    UiManager:OpenWindow(Ui.UI_BAIBAOXIANG, 1)
    UiManager:CloseWindow(self.UIGROUP)
    return
  elseif szWnd == self.BUTTON_JBEXCHANGE then
    me.CallServerScript({ "JbExchangeCmd", "ApplyOpenJbExchange" })
    return
  else
    local nCurType = me.IbCart_CurType()
    local bFlag = 0
    if self.tbWareID then
      for i = 1, #self.tbWareID do
        if szWnd == self.GOOD_SHOWS[i][self.BUTTON_BUY] then
          if nCurType == -1 then
            IbShop.bShowInfo = me.IbCart_AddWare(self.tbWareID[i], self.nSection)
          elseif self.nSection == nCurType then
            local tbGoods = me.IbCart_GetWareList()
            for j = 1, #tbGoods do
              if self.tbWareID[i] == tbGoods[j] then
                me.IbCart_SetWareCount(self.tbGoods[j]["nWareID"], 1)
                bFlag = 1
              end
            end
            if bFlag == 0 then
              IbShop.bShowInfo = me.IbCart_AddWare(self.tbWareID[i], self.nSection)
            end
          else
            local bIsEmpty = me.IbCartIsEmpty()
            if bIsEmpty ~= 1 then
              self:ShowMsgBox()
            end
          end
          UiManager:OpenWindow(Ui.UI_IBSHOPCART)
        end
      end
    end

    for i, v in pairs(self.BUTTON_SECTIONS) do
      if szWnd == v then
        self.m_nZoneType = i
        self.m_nWareType = 1
        self.m_nCurPageNumber = 1
        if self.nSection ~= i - 1 then
          -- TODO 购物车是否为空
          local bIsEmpty = me.IbCartIsEmpty()
          if bIsEmpty ~= 1 then
            self:ShowMsgBox()
          end
        end
        self.nSection = i - 1 --与程序中枚举值相对应
        self:UpdateTypeList()
      else
        Btn_Check(self.UIGROUP, self.BUTTON_SECTIONS[i], 0)
      end
    end
    for i = 1, #self.tbLstTypes do
      if szWnd == self.BUTTON_TYPES[i] then
        self.m_nWareType = i
        self.m_nCurPageNumber = 1

        -- 写log
        if self.BUTTON_SECTIONS[nZoneType] == "BtnGoldSection" and i == 1 then
          Log:Ui_SendLog("点击金币区新品上市", 1)
        elseif self.BUTTON_SECTIONS[nZoneType] == "BtnGoldSection" and i == 2 then
          Log:Ui_SendLog("点击金币区推荐商品", 1)
        elseif self.BUTTON_SECTIONS[nZoneType] == "BtnSilverSection" then
          Log:Ui_SendLog("点击银两页", 1)
        elseif self.BUTTON_SECTIONS[nZoneType] == "BtnBindGoldSection" and i == 1 then
          Log:Ui_SendLog("点击绑金区新品上市", 1)
        elseif self.BUTTON_SECTIONS[nZoneType] == "BtnBindGoldSection" and i == 2 then
          Log:Ui_SendLog("点击绑金区推荐商品", 1)
        end
      else
        Btn_Check(self.UIGROUP, self.BUTTON_TYPES[i], 0)
      end
    end
    Btn_Check(self.UIGROUP, self.BUTTON_TYPES[self.m_nWareType], 1)
    Btn_Check(self.UIGROUP, self.BUTTON_SECTIONS[self.m_nZoneType], 1)
  end

  self:UpdatePanel()
  self:UpdatePageShow()
end

function uiIbShop:ShowColseMsgBox()
  local tbMsg = {}
  tbMsg.szMsg = "您的购物车还有商品未结算。"
  tbMsg.nOptCount = 2
  tbMsg.tbOptTitle = { "清空", "结算" }
  function tbMsg:Callback(nOptIndex)
    if nOptIndex == 1 then
      me.IbCart_Clear()
      Ui(Ui.UI_IBSHOPCART):UpdateGoods()
    elseif nOptIndex == 2 then
      UiManager:OpenWindow(Ui.UI_IBSHOPCART)
    end
  end
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
end

function uiIbShop:ShowMsgBox()
  local tbMsg = {}
  tbMsg.szMsg = "您将切换到其他货币购买类型，请先将购物车中的物品结算，否则将自动清空。"
  tbMsg.nOptCount = 2
  tbMsg.tbOptTitle = { "清空", "结算" }
  function tbMsg:Callback(nOptIndex)
    if nOptIndex == 1 then
      me.IbCart_Clear()
      Ui(Ui.UI_IBSHOPCART):UpdateGoods()
    elseif nOptIndex == 2 then
      UiManager:OpenWindow(Ui.UI_IBSHOPCART)
    end
  end
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
end

function uiIbShop:UpdateGoodsShow()
  self.tbDate = nil
  self.tbDate = {}
  local nUnknownItemNum = 0
  local tbUnknownItemIdx = {}
  self:CleartTempItems()
  for i = 1, #self.tbWareID do
    local nWareID = self.tbWareID[i]
    self.tbInfo = me.IbShop_GetWareInf(nWareID)
    if not self.tbInfo then
      return
    end
    local pItem = KItem.CreateTempItem(self.tbInfo.nGenre, self.tbInfo.nDetailType, self.tbInfo.nParticular, self.tbInfo.nLevel, self.tbInfo.nSeries)

    local bIsUnknownItem = 0
    if not pItem then
      bIsUnknownItem = 1
      nUnknownItemNum = nUnknownItemNum + 1
      tbUnknownItemIdx[i] = 1
    else
      local tbTemp = pItem.GetTempTable("IbShop")
      tbTemp[pItem.nIndex] = nWareID
      tbUnknownItemIdx[i] = 0
      table.insert(self.tbTempItems, pItem)
    end
    if 0 == bIsUnknownItem then
      pItem.SetTimeOut(self.tbInfo.nTimeoutType, self.tbInfo.nTimeout)
      local Txt_Old_Price = self.tbInfo["nOrgPrice"]
      local Txt_Now_Pirce = self.tbInfo["nCurPrice"]
      local nCount = "∞" -- 因为限量销售被取消，所以商品的数量都是无穷大
      local Txt_Count = "剩余数量：" .. nCount
      if self.m_nZoneType == 1 then
        Txt_Old_Price = "原价：<color=orange>" .. Txt_Old_Price .. IVER_g_szCoinName .. "<color>"
        Txt_Now_Pirce = "现价：<color=orange>" .. Txt_Now_Pirce .. IVER_g_szCoinName .. "<color>"
      elseif self.m_nZoneType == 2 then
        Txt_Old_Price = "原价：<color=white>" .. Txt_Old_Price .. "银两<color>"
        Txt_Now_Pirce = "现价：<color=white>" .. Txt_Now_Pirce .. "银两<color>"
      elseif self.m_nZoneType == 4 then
        Txt_Old_Price = "原价：<color=white>" .. Txt_Old_Price .. "积分<color>"
        Txt_Now_Pirce = "现价：<color=white>" .. Txt_Now_Pirce .. "积分<color>"
      else
        Txt_Old_Price = "原价：<color=yellow>" .. Txt_Old_Price .. IVER_g_szBindCoinName .. "<color>"
        Txt_Now_Pirce = "现价：<color=yellow>" .. Txt_Now_Pirce .. IVER_g_szBindCoinName .. "<color>"
      end

      -- Txt_SetTxt(self.UIGROUP, self.GOOD_SHOWS[i][self.TXT_TYPE_TITLE], self.tbInfo["szName"]);
      Txt_SetTxt(self.UIGROUP, self.GOOD_SHOWS[i - nUnknownItemNum][self.TXT_TYPE_TITLE], pItem.szName)
      Txt_SetTxt(self.UIGROUP, self.GOOD_SHOWS[i - nUnknownItemNum][self.TXT_OLD_PRICE], Txt_Old_Price)
      Txt_SetTxt(self.UIGROUP, self.GOOD_SHOWS[i - nUnknownItemNum][self.TXT_NOW_PRICE], Txt_Now_Pirce)
      Txt_SetTxt(self.UIGROUP, self.GOOD_SHOWS[i - nUnknownItemNum][self.TXT_LEFT_NUMBER], Txt_Count)
      ObjMx_AddObject(self.UIGROUP, self.GOOD_SHOWS[i - nUnknownItemNum][self.SHOW_PIC], Ui.CGOG_ITEM, pItem.nIndex, 0, 0)
      Wnd_Show(self.UIGROUP, self.GOOD_SHOWS[i - nUnknownItemNum][self.PAGE_TYPE])

      -- TODO 现在全部去掉试穿按钮
      Wnd_Hide(self.UIGROUP, self.GOOD_SHOWS[i - nUnknownItemNum][self.BUTTON_TRY])

      if self.tbInfo.nDiscount > 0 and self.tbInfo.nDiscount < 100 and self.tbInfo.nDiscStart <= GetTime() and self.tbInfo.nDiscEnd >= GetTime() then
        Txt_SetTxt(self.UIGROUP, self.GOOD_SHOWS[i - nUnknownItemNum][self.TXT_DISCOUNT], self.tbInfo.nDiscount / 10)
        Wnd_Show(self.UIGROUP, self.GOOD_SHOWS[i - nUnknownItemNum][self.IMG_DISCOUNT])
        Wnd_Show(self.UIGROUP, self.GOOD_SHOWS[i - nUnknownItemNum][self.TXT_DISCOUNT])
      else
        Wnd_Hide(self.UIGROUP, self.GOOD_SHOWS[i - nUnknownItemNum][self.IMG_DISCOUNT])
        Wnd_Hide(self.UIGROUP, self.GOOD_SHOWS[i - nUnknownItemNum][self.TXT_DISCOUNT])
      end

      local tbTemp = {
        uId = self.tbWareID[i],
        szName = self.tbInfo["szName"],
        nCurPrice = self.tbInfo["nCurPrice"],
      }
      table.insert(self.tbDate, tbTemp)
    end
  end
  for i = #tbUnknownItemIdx, 1, -1 do
    if tbUnknownItemIdx[i] == 1 then
      table.remove(self.tbWareID, i)
    end
  end

  for i = #self.tbWareID + 1, self.MAX_SHOW_NUMBER do
    Wnd_Hide(self.UIGROUP, self.GOOD_SHOWS[i][self.PAGE_TYPE])
  end
  if #self.tbWareID == 0 and self.m_nWareType == 1 then -- and self.m_nFirstOpen == 1) then
    Btn_Check(self.UIGROUP, self.BUTTON_TYPES[self.m_nWareType], 0)
    self.m_nWareType = 2
    self.m_nCurPageNumber = 1
    Btn_Check(self.UIGROUP, self.BUTTON_TYPES[self.m_nWareType], 1)
    self:UpdatePanel()
    self.m_nFirstOpen = 0
    self:UpdatePageShow()
  end
end

function uiIbShop:UpdatePanel()
  if self.m_nZoneType == nil then
    self.m_nZoneType = 1 --默认为金币区
    self.m_nWareType = 1
    self.m_nCurPageNumber = 1
  end
  if self.m_nCurPageNumber <= 0 then
    self.m_nCurPageNumber = 1
  end

  self.tbWareID = self:IbShop_GetWareList(self.m_nZoneType, self.tbLstTypes[self.m_nWareType]["nType"], self.m_nCurPageNumber)

  if self.tbWareID == nil or 0 == Lib:CountTB(self.tbWareID) then
    self:IbShop_Apply(self.m_nZoneType, self.tbLstTypes[self.m_nWareType]["nType"], self.m_nCurPageNumber)
    --没有物品先全部隐藏掉
    self:HideGoodsShow()
  else
    self:UpdateGoodsShow()
  end
  Txt_SetTxt(self.UIGROUP, self.TXT_NUMBER_BANKCOIN, me.nBankCoin)
  Txt_SetTxt(self.UIGROUP, self.TXT_NUMERBER_SILVER, me.nCashMoney)
  if IVER_g_nSdoVersion == 1 then
    Txt_SetTxt(self.UIGROUP, self.TXT_NUMBER_GOLD, GetSndaCoin()) --Txt_SetTxt(self.UIGROUP, self.TXT_NUMBER_GOLD, me.nCoin);
  else
    Txt_SetTxt(self.UIGROUP, self.TXT_NUMBER_GOLD, me.nCoin)
  end
  Txt_SetTxt(self.UIGROUP, self.TXT_NUMBER_BINDGOLD, me.nBindCoin)
  local nMoney = me.GetTask(2070, 6)
  Txt_SetTxt(self.UIGROUP, self.TXT_NUMBER_INTEGRAL, "积分：<color=0xffDFCBB7>" .. nMoney .. "<color>")
  TxtEx_SetText(self.UIGROUP, self.TXX_INFOR, "<a=infor>消耗简介和积分查询<a>")
  if self.m_nZoneType ~= IbShop.INTEGRAL_SECTION then
    Wnd_SetVisible(self.UIGROUP, self.TXT_NUMBER_BANKCOIN, 1)
    Wnd_SetVisible(self.UIGROUP, self.TXT_NUMERBER_SILVER, 1)
    Wnd_SetVisible(self.UIGROUP, self.TXT_NUMBER_GOLD, 1)
    Wnd_SetVisible(self.UIGROUP, self.TXT_NUMBER_BINDGOLD, 1)
    Wnd_SetVisible(self.UIGROUP, self.TXT_GOLD_NUMBER, 1)
    Wnd_SetVisible(self.UIGROUP, self.TXT_SILVER_NUMBER, 1)
    Wnd_SetVisible(self.UIGROUP, self.TXT_BIND_GOLD_NUMBER, 1)
    Wnd_SetVisible(self.UIGROUP, self.TXT_BANK_GOLD_NUMBER, 1)
    Wnd_SetVisible(self.UIGROUP, self.TXT_NUMBER_INTEGRAL, 0)
    Wnd_SetVisible(self.UIGROUP, self.TXX_INFOR, 0)
  else
    Wnd_SetVisible(self.UIGROUP, self.TXT_NUMBER_BANKCOIN, 0)
    Wnd_SetVisible(self.UIGROUP, self.TXT_NUMERBER_SILVER, 0)
    Wnd_SetVisible(self.UIGROUP, self.TXT_NUMBER_GOLD, 0)
    Wnd_SetVisible(self.UIGROUP, self.TXT_NUMBER_BINDGOLD, 0)
    Wnd_SetVisible(self.UIGROUP, self.TXT_GOLD_NUMBER, 0)
    Wnd_SetVisible(self.UIGROUP, self.TXT_SILVER_NUMBER, 0)
    Wnd_SetVisible(self.UIGROUP, self.TXT_BIND_GOLD_NUMBER, 0)
    Wnd_SetVisible(self.UIGROUP, self.TXT_BANK_GOLD_NUMBER, 0)
    Wnd_SetVisible(self.UIGROUP, self.TXT_NUMBER_INTEGRAL, 1)
    Wnd_SetVisible(self.UIGROUP, self.TXX_INFOR, 1)
  end
end

function uiIbShop:GetItemId(nZoneType, nWareType, tblResult)
  local nSize = 0
  if tblResult == nil then
    nSize = 0
  else
    nSize = #tblResult
  end

  self.tbWareID = nil
  self.tbWareID = {}
  for i = 1, #tblResult do
    table.insert(self.tbWareID, tblResult[i])
  end
  IbShop:AddWare(nZoneType, nWareType, tblResult)
  self:UpdateGoodsShow()
end

function uiIbShop:OnObjHover(szWnd, uGenre, uId, nX, nY)
  self:ViewItem(szWnd, KItem.GetItemObj(uId))
end

function uiIbShop:ViewItem(szWnd, pItem)
  local nTipType = Item.TIPS_NORMAL
  if self.m_nZoneType == self.BUTTON_BINDGOLD_SECTION then
    nTipType = Item.TIPS_BINDGOLD_SECTION
  elseif self.m_nZoneType == self.BUTTON_INTEGRAL_SECTION then
    nTipType = Item.TIPS_INTEGRAL_SECTION
  else
    nTipType = Item.TIPS_NOBIND_SECTION
  end
  if pItem then
    Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, pItem.GetCompareTip(nTipType))
  end
end

function uiIbShop:ResetShow()
  --To Be Decide
end

function uiIbShop:Show_New_Tag()
  --To Be Decide
end

function uiIbShop:GetTotalPages(tbPageNumber)
  assert(tbPageNumber)

  self.tbPageNumber = tbPageNumber
  self:UpdatePageShow()
end

function uiIbShop:OpenWindow()
  self:UpdateTypeList()
  self:UpdatePanel()
end

function uiIbShop:CloseWindow()
  UiManager:CloseWindow(Ui.UI_IBSHOP)
end

-- 商品区，商品类别
function uiIbShop:OnReducePageCount(nZoneType, nWareType)
  if self.m_nCurPageNumber - 1 > 0 then
    self:OnPageUpdate(nZoneType, nWareType, self.m_nCurPageNumber - 1)
  else
    if self.m_nWareType == 1 then
      Btn_Check(self.UIGROUP, self.BUTTON_TYPES[self.m_nWareType], 0)
      self.m_nWareType = 2
      self.m_nCurPageNumber = 1
      Btn_Check(self.UIGROUP, self.BUTTON_TYPES[self.m_nWareType], 1)
      self:UpdatePanel()
      self:UpdatePageShow()
    elseif self.m_nWareType == 6 or self.m_nWareType == 7 then
      self.m_nCurPageNumber = 1
      self.m_nTotalPageNum = 1
      self:HideGoodsShow()
    end
  end
end

--参数：商品区，商品类别，商品总页数
function uiIbShop:OnPageUpdate(nZoneType, nWareType, nPageCnt)
  assert(nZoneType)
  assert(nWareType)
  self.tbPageNumber[nZoneType][nWareType] = nPageCnt
  self.m_nZoneType = nZoneType
  self.m_nWareType = nWareType
  self.m_nCurPageNumber = self.m_nCurPageNumber - 1
  self:UpdatePageShow()
end

function uiIbShop:UpdateCoin()
  if IVER_g_nSdoVersion == 1 then
    Txt_SetTxt(self.UIGROUP, self.TXT_NUMBER_GOLD, GetSndaCoin()) --Txt_SetTxt(self.UIGROUP, self.TXT_NUMBER_GOLD, me.nCoin);
  else
    Txt_SetTxt(self.UIGROUP, self.TXT_NUMBER_GOLD, me.nCoin)
  end
end

function uiIbShop:UpdateCashMoney()
  Txt_SetTxt(self.UIGROUP, self.TXT_NUMERBER_SILVER, me.nCashMoney)
end

-- 获取指定类型，指定页码的商品id列表
function uiIbShop:IbShop_GetWareList(nWareZone, nWareType, nPageNo)
  if nWareZone < IbShop.GOLD_SECTION or nWareZone > IbShop.INTEGRAL_SECTION or nWareType <= 0 or nPageNo <= 0 then
    return
  end
  local nFirstIndex = (nPageNo - 1) * self.MAX_SHOW_NUMBER
  return IbShop:GetWareList(nWareZone, nWareType, nFirstIndex, self.MAX_SHOW_NUMBER)
end

-- 申请商品列表
function uiIbShop:IbShop_Apply(nWareZone, nWareType, nPageNo)
  if nWareZone < IbShop.GOLD_SECTION or nWareZone > IbShop.INTEGRAL_SECTION or nWareType <= 0 or nPageNo <= 0 then
    return
  end
  local nPreWareId = self:GetPreWareId(nWareZone, nWareType, nPageNo)
  me.IbShop_Apply(nWareZone, nWareType, nPreWareId, self.MAX_SHOW_NUMBER)
end

-- 获取前一个商品的id
function uiIbShop:GetPreWareId(nWareZone, nWareType, nPageNo)
  if nWareZone < IbShop.GOLD_SECTION or nWareZone > IbShop.INTEGRAL_SECTION or nWareType <= 0 or nPageNo <= 0 then
    return 0
  end
  if nPageNo == 1 then
    return 0
  else
    local tbPreWareList = self:IbShop_GetWareList(nWareZone, nWareType, nPageNo - 1)
    if tbPreWareList and Lib:CountTB(tbPreWareList) ~= 0 then
      return tbPreWareList[Lib:CountTB(tbPreWareList)]
    else
      return 0
    end
  end
end

function uiIbShop:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_IBSHOP_SYNWARELIST, self.GetItemId },
    { UiNotify.emCOREEVENT_IBSHOP_SYNWARECOUNT, self.GetTotalPages },
    { UiNotify.emCOREEVENT_IBSHOP_OPENWINDOW, self.OpenWindow },
    { UiNotify.emCOREEVENT_IBSHOP_CLOSEWINDOW, self.CloseWindow },
    { UiNotify.emCOREEVENT_IBSHOP_REDUCEPAGECOUNT, self.OnReducePageCount },
    { UiNotify.emCOREEVENT_JBCOIN_CHANGED, self.UpdateCoin },
    { UiNotify.emCOREEVENT_MONEY_CHANGED, self.UpdateCashMoney },
  }
  return tbRegEvent
end

function uiIbShop:Link_infor_OnClick(szWnd, szLinkData)
  me.CallServerScript({ "ApplyConsumeScores" })
end

function uiIbShop:OpenConsumeUrl()
  OpenWebSite("http://zt.xoyo.com/jxsj/mall/")
end
