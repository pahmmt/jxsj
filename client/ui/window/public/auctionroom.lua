local ITEM_BAR_STR = "Bar_"
local ITEM_OBJTXT_STR = "_TxtItem"
local ITEM_OBJIMG_STR = "_ImgItem"
local ITEM_OBJOBJ_STR = "_ObjItem"
local ITEM_NAME_STR = "_TxtItemName"
local ITEM_SELLERNAME_STR = "_TxtSellerName"
local ITEM_SELLERTIME_STR = "_TxtSellerTime"
local ITEM_PRICE_STR = "_TxtPrice"
local ITEM_ONEPRICE_STR = "_TxtOnePrice"
local ITEM_COIN_STR = "_TxtCoin"
local ITEM_STAR_STR = "_TxtStar"
local ITEM_SEND = "_BtnSend"

local BROWSE_ITEMLIST_NAME = "BGList"
local BUYING_ITEMLIST_NAME = "BuyingGList"
local SELL_ITEMLIST_NAME = "SellGList"

local BROWSE_ITEMLIST_ID = 0
local BUYING_ITEMLIST_ID = 1
local SELL_ITEMLIST_ID = 2
local SELL_ITEMLIST_ID_QUERY = 3

local ITEMCOLOR_TYPE = { "形单影只", "心有所属" }
local ITEMINDEX_TYPE = { "男", "女" }

local YINLIANG = "银两"
local BANGDINGYINLIANG = "绑定银两"
local JINBI = IVER_g_szCoinName
local BANGDINGJINBI = IVER_g_szBindCoinName

local TXT_MONEY = "TxtMoney"
local TXT_BINDMONEY = "TxtBindMoney"
local TXT_JBCOIN = "TxtJbCoin"
local TXT_BINDJBCOIN = "TxtBindCoin"
local TXT_SELLPRICE = "TxtSellPrice"
local TXT_SELLONEPRICE = "TxtSellOnePrice"
local TXT_SELLTAX = "TxtSellTax"

local BTN_BGLISTGOODSNAMESORT = "BtnBGListNameSort"
local BTN_BGLISTSTARSORT = "BtnBGListStarSort"
local BTN_BGLISTPRICESORT = "BtnBGListPriceSort"
local BTN_BUYINGGLISTSTARSORT = "BtnBuyingGListStarSort"
local BTN_BUYINGGLISTPRICESORT = "BtnBuyingGListPriceSort"
local BTN_SELLGLISTSTARSORT = "BtnSellGListStarSort"
local BTN_SELLGLISTPRICESORT = "BtnSellGListPriceSort"
local BTN_WUXINGLIMIT = "BtnWuXingLimit"
local BTN_CLOSE0 = "BtnClose0"
local BTN_CLOSE1 = "BtnClose1"
local BTN_CLOSE2 = "BtnClose2"
local BTN_CLOSE = "BtnClose"
local BTN_FINDGOODS = "BtnSearch"
local BTN_SHOWPRICE = "BtnItemPrice"
local BTN_BUY = "BtnBuyByPrice"
local BTN_ONEPRICEBUY = "BtnBuyByOnePrice"
local BTN_RETURNIBSHOP = "BtnReturnIbshop"
local BTN_LOOKPAGEUP = "BtnPageUp"
local BTN_LOOKPAGEDOWN = "BtnPageDown"
local BTN_BUYINGPAGEUP = "BtnBuyingPageUp"
local BTN_BUYINGPAGEDOWN = "BtnBuyingPageDown"
local BTN_SELL = "BtnSell"
local BTN_SELLPAGEUP = "BtnSellPageUp"
local BTN_SELLPAGEDOWN = "BtnSellPageDown"
local BTN_BROWSEPAGE = "BtnBrowsePage"
local BTN_BUYINGPAGE = "BtnBuyingPage"
local BTN_SELLPAGE = "BtnSellPage"
local BTN_SELLTIME12 = "BtnSellTime12"
local BTN_SELLTIME24 = "BtnSellTime24"
local BTN_SELLTIME48 = "BtnSellTime48"
local SELLGLISTBAR_0 = "SellGListBar_0_Btn"
local SELLGLISTBAR_1 = "SellGListBar_1_Btn"
local SELLGLISTBAR_2 = "SellGListBar_2_Btn"
local SELLGLISTBAR_3 = "SellGListBar_3_Btn"
local SELLGLISTBAR_4 = "SellGListBar_4_Btn"
local SELLGLISTBAR_5 = "SellGListBar_5_Btn"
local SELLGLISTBAR_6 = "SellGListBar_6_Btn"
local SELLGLISTBAR_7 = "SellGListBar_7_Btn"
local BGLISTBAR_0 = "BGListBar_0_Btn"
local BGLISTBAR_1 = "BGListBar_1_Btn"
local BGLISTBAR_2 = "BGListBar_2_Btn"
local BGLISTBAR_3 = "BGListBar_3_Btn"
local BGLISTBAR_4 = "BGListBar_4_Btn"
local BGLISTBAR_5 = "BGListBar_5_Btn"
local BGLISTBAR_6 = "BGListBar_6_Btn"
local BGLISTBAR_7 = "BGListBar_7_Btn"
local BUYINGGLISTBAR_0 = "BuyingGListBar_0_Btn"
local BUYINGGLISTBAR_1 = "BuyingGListBar_1_Btn"
local BUYINGGLISTBAR_2 = "BuyingGListBar_2_Btn"
local BUYINGGLISTBAR_3 = "BuyingGListBar_3_Btn"
local BUYINGGLISTBAR_4 = "BuyingGListBar_4_Btn"
local BUYINGGLISTBAR_5 = "BuyingGListBar_5_Btn"
local BUYINGGLISTBAR_6 = "BuyingGListBar_6_Btn"
local BUYINGGLISTBAR_7 = "BuyingGListBar_7_Btn"
local BTN_CANCELSELL = "BtnCancelSell"
local BTN_NAME_SEARCH = "BtnNameSearch"

local PAGE_BROWSE = "PageBrowse"
local PAGE_BUYING = "PageBuying"
local PAGE_SELL = "PageSell"

local EDT_SEARCH = "EditSearch"
local EDT_BUYBYPRICE = "EditBuyByPrice"
local EDT_SELLPRICE = "EdtSellPrice"
local EDT_SELLONEPRICE = "EdtSellOnePrice"

local OBJ_SELLITEM = "SellItem_Obj"

local CMB_ITEMLEVEL = "ComboBoxItemLevel"
local CMB_ITEMTYPE = "ComboBoxItemType"
local CMB_ITEMSTAR = "ComboBoxItemStar"
--------------------------------------------------------------
-- 2010/10/22 16:38:38 xuantao
local CMB_ITEMMOENY = "ComboBoxItemMoneyType"
local CMB_ITEMWUXING = "ComboBoxItemWuXing"
local BTN_COIN = "BtnCoin"
local BTN_YINLIANG = "BtnYingLiang"
local PAGE_MONEY_SET = "MoneyPageSet"
local PAGE_YINLIANG = "YinLiangPage"
local PAGE_COIN = "CoinPage"
local EDT_SELLONEPRICE_COIN = "EdtSellOnePrice_Coin"
local EDT_SELLONEPRICE_YINLIANG = "EdtSellOnePrice_YingLiang"
local EDT_SELLPRICE_YINLIANG = "EdtSellPrice_YingLiang"
--------------------------------------------------------------

local Sell_0_BtnSend = "SellGListBar_0_BtnSend"
local Sell_1_BtnSend = "SellGListBar_1_BtnSend"
local Sell_2_BtnSend = "SellGListBar_2_BtnSend"
local Sell_3_BtnSend = "SellGListBar_3_BtnSend"
local Sell_4_BtnSend = "SellGListBar_4_BtnSend"
local Sell_5_BtnSend = "SellGListBar_5_BtnSend"
local Sell_6_BtnSend = "SellGListBar_6_BtnSend"
local Sell_7_BtnSend = "SellGListBar_7_BtnSend"

local BtnQueryPrice = "Btn_QueryPrice"

local tbAuctionRoom = Ui:GetClass("auctionroom")
local tbObject = Ui.tbLogic.tbObject
local tbMouse = Ui.tbLogic.tbMouse
tbAuctionRoom.nDoTime = 0
tbAuctionRoom.nMaxDoTime = 6 --操作间隔(秒)
-- 最少差价
local DIFPRICE = 1000
-- 金币最低价
local COINPRICE = 500
--物品装备位置，适应的五行条件参数
local ITEM_TYPE2 = {
  -1, -- 全部不指定五行
  3, -- 武器
  0, -- 头盔
  8, -- 项链
  1, -- 衣服
  7, -- 戒指
  2, -- 腰带
  9, -- 腰坠
  5, -- 护腕
  6, -- 护身符
  4, -- 鞋子
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
}

local ITEM_TYPE_NAME = {
  "全部",
  "武器",
  "帽子",
  "项链",
  "衣服",
  "戒指",
  "腰带",
  "腰坠",
  "护腕",
  "护身符",
  "鞋子",
  "其它物品",
  "    玄晶宝石",
  "    各式令牌",
  "    材料",
  "    背包",
  "    宝石原石",
}

local STAR_TYPE = {
  "无限制",
  "达到1星级",
  "达到2星级",
  "达到3星级",
  "达到4星级",
  "达到5星级",
  "达到6星级",
  "达到7星级",
  "达到8星级",
  "达到9星级",
  "达到10星级",
  "达到11星级",
  "达到12星级",
}

local LEVLE_TYPE = {
  "无限制",
  "1级",
  "2级",
  "3级",
  "4级",
  "5级",
  "6级",
  "7级",
  "8级",
  "9级",
  "10级",
}
--------------------------------------------------------------
-- 2010/10/22 16:42:27 xuantao
-- 拍卖行中的五行选择
local ITEM_WUXING = {
  "所有五行",
  "适合金系",
  "适合木系",
  "适合水系",
  "适合火系",
  "适合土系",
}
-- 拍卖行在卖物品时的货币类型
local MOENY_TYPE = {
  "无限制",
  "银两",
  "金币",
}
--------------------------------------------------------------
local tbSellGoodCont = { bShowCd = 0, bUse = 0, bLink = 0, nRoom = Item.ROOM_AUCTION } -- 不显示CD特效，不可使用，不可链接

local nMoneyType = 0 -- 0银两 1绑定银两 2点券 3绑定点券
local GOODSPERPAGE = 8
local tgGoodsIndexArray = {}
local tgObjIndexArray = {}
local AUCTIONSTATE = -4
local tbBtnSend2ItemIdx = {}
--local tbBtnSend2ItemCurrency = {};

tbAuctionRoom.tbBtnSend2ItemCurrency = {}

-- SellGListBar对应的Item在setting中的名字：SellGListBar_0_ObjItem等
local SELLGLISTBAR_OBJ = {}
-- BGListBar对应的Item在setting中的名字：BGListBar_0_ObjItem等
local BGLISTBAR_OBJ = {}
-- BuyingGListBar对应的Item在setting中的名字：BuyingGListBar_0_ObjItem等
local BUYINGGLISTBAR_OBJ = {}

-- 为各个UI控件赋值
for nItemBarIdx = 0, GOODSPERPAGE - 1 do
  SELLGLISTBAR_OBJ[nItemBarIdx] = SELL_ITEMLIST_NAME .. ITEM_BAR_STR .. nItemBarIdx .. ITEM_OBJOBJ_STR
  BGLISTBAR_OBJ[nItemBarIdx] = BROWSE_ITEMLIST_NAME .. ITEM_BAR_STR .. nItemBarIdx .. ITEM_OBJOBJ_STR
  BUYINGGLISTBAR_OBJ[nItemBarIdx] = BUYING_ITEMLIST_NAME .. ITEM_BAR_STR .. nItemBarIdx .. ITEM_OBJOBJ_STR
end

-- 各个ListBar对应的tbListBarObj
local tbListBarObj = {
  ["BGList"] = BGLISTBAR_OBJ,
  ["SellGList"] = SELLGLISTBAR_OBJ,
  ["BuyingGList"] = BUYINGGLISTBAR_OBJ,
}

local tbViewGoodCont = { bShowCd = 0, bUse = 0 }

function tbViewGoodCont:CheckMouse(tbMouseObj)
  return 0
end

function tbViewGoodCont:ClickMouse(tbObj, nX, nY)
  return 0
end

tbAuctionRoom.tbViewGoodCont_browse = {}
tbAuctionRoom.tbViewGoodCont_buying = {}
tbAuctionRoom.tbViewGoodCont_sell = {}
tbAuctionRoom.tbRecodeItem = {}

-- 各个ListBar的ViewGood对应的tbViewGoodCont
tbAuctionRoom.tbListBarViewGood = {
  ["BGList"] = tbAuctionRoom.tbViewGoodCont_browse,
  ["BuyingGList"] = tbAuctionRoom.tbViewGoodCont_buying,
  ["SellGList"] = tbAuctionRoom.tbViewGoodCont_sell,
}

function tbSellGoodCont:CheckSwitchItem(pDrop, pPick, nX, nY)
  if not pDrop then
    return 1
  end

  if pDrop.IsForbitAuction() == 1 then
    UiManager:OpenWindow(Ui.UI_INFOBOARD, "物品属于不能拍卖物品")
    tbMouse:ResetObj()
    return 0
  end
  return 1
end

--工具函数

function tbAuctionRoom:PreOpen(bServer)
  if not bServer then
    return 1
  end

  me.CallServerScript({ "AuctionCmd", "ApplyOpenAuction" })
  return 0
end

function tbAuctionRoom:OnSellItemChangedCallback(nAction, uGenre, uId)
  if nAction > 0 then
    ObjBox_HoldObject(self.UIGROUP, OBJ_SELLITEM, uGenre, uId)
  else
    self.tbSellGoodCont:SetObj(nil)
  end
end

function tbAuctionRoom:SearchReturn(nFindRetType)
  local bStartPage = KAuction.IsStartPage()
  local bEndPage = KAuction.IsEndPage()
  if nFindRetType == BROWSE_ITEMLIST_ID then
    self:ClearItemList(BROWSE_ITEMLIST_NAME)
    self:UpdateItemList(BROWSE_ITEMLIST_NAME)
    if bStartPage == 1 then
      Wnd_SetEnable(self.UIGROUP, BTN_LOOKPAGEUP, 0)
    else
      Wnd_SetEnable(self.UIGROUP, BTN_LOOKPAGEUP, 1)
    end
    if bEndPage == 1 then
      Wnd_SetEnable(self.UIGROUP, BTN_LOOKPAGEDOWN, 0)
    else
      Wnd_SetEnable(self.UIGROUP, BTN_LOOKPAGEDOWN, 1)
    end
  elseif nFindRetType == BUYING_ITEMLIST_ID then
    self:ClearItemList(BUYING_ITEMLIST_NAME)
    self:UpdateItemList(BUYING_ITEMLIST_NAME)
    if bStartPage == 1 then
      Wnd_SetEnable(self.UIGROUP, BTN_BUYINGPAGEUP, 0)
    else
      Wnd_SetEnable(self.UIGROUP, BTN_BUYINGPAGEUP, 1)
    end
    if bEndPage == 1 then
      Wnd_SetEnable(self.UIGROUP, BTN_BUYINGPAGEDOWN, 0)
    else
      Wnd_SetEnable(self.UIGROUP, BTN_BUYINGPAGEDOWN, 1)
    end
  elseif nFindRetType == SELL_ITEMLIST_ID then
    self:ClearItemList(SELL_ITEMLIST_NAME)
    self:UpdateItemList(SELL_ITEMLIST_NAME)
    if bStartPage == 1 then
      Wnd_SetEnable(self.UIGROUP, BTN_SELLPAGEUP, 0)
    else
      Wnd_SetEnable(self.UIGROUP, BTN_SELLPAGEUP, 1)
    end
    if bEndPage == 1 then
      Wnd_SetEnable(self.UIGROUP, BTN_SELLPAGEDOWN, 0)
    else
      Wnd_SetEnable(self.UIGROUP, BTN_SELLPAGEDOWN, 1)
    end
  elseif nFindRetType == SELL_ITEMLIST_ID_QUERY then
    self:ClearItemList(SELL_ITEMLIST_NAME)
    self:UpdateItemList(SELL_ITEMLIST_NAME, 1)
    Wnd_SetEnable(self.UIGROUP, BTN_SELLPAGEUP, 0)
    Wnd_SetEnable(self.UIGROUP, BTN_SELLPAGEDOWN, 0)
  end
end

function tbAuctionRoom:UpdateAuctionRoom()
  Txt_SetTxt(self.UIGROUP, TXT_MONEY, YINLIANG .. Item:FormatMoney(me.nCashMoney))
  Txt_SetTxt(self.UIGROUP, TXT_BINDMONEY, BANGDINGYINLIANG .. Item:FormatMoney(me.GetBindMoney()))
  Txt_SetTxt(self.UIGROUP, TXT_JBCOIN, JINBI .. Item:FormatMoney(me.GetJbCoin()))
  Txt_SetTxt(self.UIGROUP, TXT_BINDJBCOIN, BANGDINGJINBI .. Item:FormatMoney(me.nBindCoin))
end

function tbAuctionRoom:ClearItemBar(szListName, nItemBarIdx)
  local szBarName = szListName .. ITEM_BAR_STR .. nItemBarIdx
  local txtItemName = szBarName .. ITEM_NAME_STR
  local txtSellerName = szBarName .. ITEM_SELLERNAME_STR
  local txtSellerTime = szBarName .. ITEM_SELLERTIME_STR
  local txtPrice = szBarName .. ITEM_PRICE_STR
  local txtOnePrice = szBarName .. ITEM_ONEPRICE_STR
  local txtCoin = szBarName .. ITEM_COIN_STR
  local txtStar = szBarName .. ITEM_STAR_STR
  local btnSend = szBarName .. ITEM_SEND
  Wnd_Hide(self.UIGROUP, btnSend)
  Wnd_SetDummyWnd(self.UIGROUP, txtItemName, 1)
  Wnd_SetDummyWnd(self.UIGROUP, txtSellerName, 1)
  Wnd_SetDummyWnd(self.UIGROUP, txtSellerTime, 1)
  Wnd_SetDummyWnd(self.UIGROUP, txtPrice, 1)
  Wnd_SetDummyWnd(self.UIGROUP, txtOnePrice, 1)
  Wnd_SetDummyWnd(self.UIGROUP, txtStar, 1)
  Wnd_SetDummyWnd(self.UIGROUP, txtCoin, 1)

  Txt_SetTxt(self.UIGROUP, txtItemName, "")
  TxtEx_SetText(self.UIGROUP, txtSellerName, "")
  Txt_SetTxt(self.UIGROUP, txtSellerTime, "")
  Txt_SetTxt(self.UIGROUP, txtStar, "")

  if nMoneyType == 0 then
    Txt_SetTxt(self.UIGROUP, txtPrice, "")
  elseif nMoneyType == 1 then
    Txt_SetTxt(self.UIGROUP, txtPrice, "")
  elseif nMoneyType == 2 then
    Txt_SetTxt(self.UIGROUP, txtPrice, "")
  elseif nMoneyType == 3 then
    Txt_SetTxt(self.UIGROUP, txtPrice, "")
  end

  if nMoneyType == 0 then
    Txt_SetTxt(self.UIGROUP, txtOnePrice, "")
  elseif nMoneyType == 1 then
    Txt_SetTxt(self.UIGROUP, txtOnePrice, "")
  elseif nMoneyType == 2 then
    Txt_SetTxt(self.UIGROUP, txtOnePrice, "")
  elseif nMoneyType == 3 then
    Txt_SetTxt(self.UIGROUP, txtOnePrice, "")
  end
  if nMoneyType == 0 then
    Txt_SetTxt(self.UIGROUP, txtCoin, "")
  elseif nMoneyType == 1 then
    Txt_SetTxt(self.UIGROUP, txtCoin, "")
  elseif nMoneyType == 2 then
    Txt_SetTxt(self.UIGROUP, txtCoin, "")
  elseif nMoneyType == 3 then
    Txt_SetTxt(self.UIGROUP, txtCoin, "")
  end
  -- 清理List里的各个项
  self.tbListBarViewGood[szListName][nItemBarIdx]:ClearObj()
end

function tbAuctionRoom:ClearItemList(szListName)
  self.nSelGoodIdx = -1
  local nItemCountPerPage = GOODSPERPAGE - 1
  tbBtnSend2ItemIdx = {}
  self.tbBtnSend2ItemCurrency = {}
  for nItemBarIdx = 0, nItemCountPerPage do
    local szBarName = szListName .. ITEM_BAR_STR .. nItemBarIdx
    self:ClearItemBar(szListName, nItemBarIdx)
    tgObjIndexArray[szBarName .. "_Btn"] = -1
    tgGoodsIndexArray[szBarName .. "_Btn"] = -1
    Btn_Check(self.UIGROUP, szBarName .. "_Btn", 0)
    Wnd_Hide(self.UIGROUP, szBarName .. "_Btn")
  end
end

function tbAuctionRoom:UpdateItemBar(szListName, nItemIdx, szSellName, szSellTime, nPrice, nOnePrice, nItemBarIdx, nCurrency, bSpecial)
  local szBarName = szListName .. ITEM_BAR_STR .. nItemBarIdx
  local objItemObj = szBarName .. ITEM_OBJOBJ_STR
  local txtItemName = szBarName .. ITEM_NAME_STR
  local txtSellerName = szBarName .. ITEM_SELLERNAME_STR
  local txtSellerTime = szBarName .. ITEM_SELLERTIME_STR
  local txtPrice = szBarName .. ITEM_PRICE_STR
  local txtOnePrice = szBarName .. ITEM_ONEPRICE_STR
  local txtCoin = szBarName .. ITEM_COIN_STR
  local txtStar = szBarName .. ITEM_STAR_STR
  local btnSend = szBarName .. ITEM_SEND
  local nAvgPrice = nPrice
  local nAvgOnePrice = nOnePrice
  local pItem = KItem.GetItemObj(nItemIdx)
  local tbObj = nil
  if pItem then
    nAvgPrice = math.ceil(nPrice * 100 / pItem.nCount) / 100
    nAvgOnePrice = math.ceil(nOnePrice * 100 / pItem.nCount) / 100
    tbObj = {}
    tbObj.nType = Ui.OBJ_ITEM
    tbObj.pItem = pItem
    Txt_SetTxt(self.UIGROUP, txtStar, (pItem.nStarLevel / 2) .. "星")
    Txt_SetTxt(self.UIGROUP, txtItemName, pItem.szName)
    self.tbListBarViewGood[szListName][nItemBarIdx]:SetObj(tbObj)
  end
  TxtEx_SetText(self.UIGROUP, txtSellerName, "<a=infor:" .. szSellName .. ">" .. szSellName .. "<a>")
  Wnd_Show(self.UIGROUP, btnSend)
  local hTime = math.floor(szSellTime / 60 / 60)
  if hTime >= 1 then
    Txt_SetTxt(self.UIGROUP, txtSellerTime, "剩余" .. hTime .. "小时")
  else
    Txt_SetTxt(self.UIGROUP, txtSellerTime, "少于1小时")
  end

  if (Btn_GetCheck(self.UIGROUP, BTN_SHOWPRICE) == 1 and szListName == BROWSE_ITEMLIST_NAME) or bSpecial then
    if nMoneyType == 0 then
      if nCurrency and nCurrency == 2 then -- 表示用金币交易的物品
        Txt_SetTxt(self.UIGROUP, txtCoin, "单价：<color=yellow>" .. Item:FormatMoney(nAvgOnePrice) .. "金<color>")
        Wnd_SetEnable(self.UIGROUP, btnSend, 1)
        if bSpecial then
          Wnd_Hide(self.UIGROUP, btnSend, 1)
        end
      else
        Txt_SetTxt(self.UIGROUP, txtOnePrice, "单价：<color=orange>" .. Item:FormatMoney(nAvgOnePrice) .. "两<color>")
        Txt_SetTxt(self.UIGROUP, txtPrice, "拍卖单价：<color=orange>" .. Item:FormatMoney(nAvgPrice) .. "两<color>")
        Wnd_SetEnable(self.UIGROUP, btnSend, 1)
        if bSpecial then
          Wnd_Hide(self.UIGROUP, btnSend, 1)
        end
      end
    end
  else
    if nMoneyType == 0 then
      if nCurrency and nCurrency == 2 then -- 表示用金币交易的物品
        Txt_SetTxt(self.UIGROUP, txtCoin, "一口价：<color=yellow>" .. Item:FormatMoney(nOnePrice) .. "金<color>")
        Wnd_SetEnable(self.UIGROUP, btnSend, 1)
      else
        Txt_SetTxt(self.UIGROUP, txtOnePrice, "一口价：<color=orange>" .. Item:FormatMoney(nOnePrice) .. "两<color>")
        Txt_SetTxt(self.UIGROUP, txtPrice, "拍卖价：<color=orange>" .. Item:FormatMoney(nPrice) .. "两<color>")
        Wnd_SetEnable(self.UIGROUP, btnSend, 1)
      end
    end
  end
end

function tbAuctionRoom:UpdateItemList(szListName, bSpecial)
  local nItemCountPerPage = KAuction.AuctionGetSearchResultNum() - 1
  for nItemBarIdx = 0, nItemCountPerPage do
    local rec = KAuction.AuctionGetSearchResultByIndex(nItemBarIdx)
    if rec ~= nil then
      local szBarName = szListName .. ITEM_BAR_STR .. nItemBarIdx
      local nItemIdx = rec.GetItemIndex() -- 获取临时物品对象的Index
      local szSellName = rec.GetSellerName() -- 获取卖者名字
      local szSellTime = rec.GetValidTime() -- 获取有效期(秒为单位);
      local nPrice = rec.GetCompetePrice() -- 获取竞拍价
      local nOnePrice = rec.GetOneTimeBuyPrice() -- 获取一口价价格 （银两）;
      local nCurrency = rec.GetCurrency() -- 获取拍卖的金币交易类型

      self:UpdateItemBar(szListName, nItemIdx, szSellName, szSellTime, nPrice, nOnePrice, nItemBarIdx, nCurrency, bSpecial)
      tgGoodsIndexArray[szBarName .. "_Btn"] = nItemBarIdx
      tgObjIndexArray[szBarName .. "_Btn"] = nItemIdx
      tbBtnSend2ItemIdx[szBarName .. ITEM_SEND] = rec.GetAucItemkey()
      self.tbBtnSend2ItemCurrency[szBarName .. ITEM_SEND] = nCurrency or 0
      Wnd_Show(self.UIGROUP, szBarName .. "_Btn")

      if nCurrency == 2 then -- 金币交易时修改背景图片
        local szImageName = "image/ui/001a/auction/coin_spar_long.spr"
        if szListName == BUYING_ITEMLIST_NAME or szListName == BROWSE_ITEMLIST_NAME then
          if UiVersion == Ui.Version001 then
            szImageName = "image/ui/001a/auction/coin_spar_long.spr"
          else
            szImageName = "image/ui/002a/auctionroom/coin_spar_long.spr"
          end
        elseif szListName == SELL_ITEMLIST_NAME then
          if UiVersion == Ui.Version001 then
            szImageName = "image/ui/001a/auction/coin_spar.spr"
          else
            szImageName = "image/ui/002a/auctionroom/coin_spar_short.spr"
          end
        end
        -- 设置背景图片
        Img_SetImage(self.UIGROUP, szBarName .. "_Btn", 1, szImageName)
      else
        if UiVersion == Ui.Version001 then
          local szImageName = "image/ui/001a/auction/auctionbigitembar.spr"
          if szListName == BUYING_ITEMLIST_NAME or szListName == BROWSE_ITEMLIST_NAME then
            szImageName = "image/ui/001a/auction/auctionbigitembar.spr"
          elseif szListName == SELL_ITEMLIST_NAME then
            szImageName = "image/ui/001a/auction/auctionitembar.spr"
          end
          -- 设置背景图片
          Img_SetImage(self.UIGROUP, szBarName .. "_Btn", 1, szImageName)
        else
          local szImageName = "image/ui/002a/auctionroom/bg_cursel_long.spr"
          if szListName == BUYING_ITEMLIST_NAME or szListName == BROWSE_ITEMLIST_NAME then
            szImageName = "image/ui/002a/auctionroom/bg_cursel_long.spr"
          else
            szImageName = "image/ui/002a/auctionroom/bg_cursel_short.spr"
          end
          Img_SetImage(self.UIGROUP, szBarName .. "_Btn", 1, szImageName)
        end
      end
    end
  end
end

function tbAuctionRoom:ItemBarLight(szButtonName, szItemBarName)
  local nItemCountPerPage = GOODSPERPAGE - 1
  local bCheck = Btn_GetCheck(self.UIGROUP, szButtonName)
  if bCheck == 1 then
    for nItemBarIdx = 0, nItemCountPerPage do
      local tmpBtnName = szItemBarName .. "_" .. nItemBarIdx .. "_Btn"
      Btn_Check(self.UIGROUP, tmpBtnName, 0)
    end
  end
  Btn_Check(self.UIGROUP, szButtonName, bCheck)
end

--接口函数

function tbAuctionRoom:UpPage()
  local szGoodName = Edt_GetTxt(self.UIGROUP, EDT_SEARCH)
  local nLevelLimit = self.nCurItemLevel

  local bWuXingLimit = Btn_GetCheck(self.UIGROUP, BTN_WUXINGLIMIT)
  local nStarLevel = self.nCurItemStar * 2
  local nItemType = self.nCurItemType + 1
  local nOrderByType = self.nOrderByType
  local bDecOrder = self.bDecOrder
  local bMeSell = 0
  local bMeExpreed = 0
  --------------------------------------------------------------------------------------------
  local nCurrency = self.nCurItemMoney
  local nWuXingType = self.nCurItemWuXing
  if not nCurrency or nCurrency == 0 then
    nCurrency = 3
  end
  --------------------------------------------------------------------------------------------

  local bReturn, szGoodName = self:PreProdGoodsName(szGoodName)
  if 0 == bReturn then
    return
  end

  KAuction.AuctionPrePage(szGoodName, nItemType, nLevelLimit, nWuXingType, bMeSell, bMeExpreed, nOrderByType, bDecOrder, nStarLevel, ITEM_TYPE2[self.nCurItemType + 1], BROWSE_ITEMLIST_ID, nCurrency)
end

function tbAuctionRoom:DownPage()
  local szGoodName = Edt_GetTxt(self.UIGROUP, EDT_SEARCH)
  local nLevelLimit = self.nCurItemLevel
  local bWuXingLimit = Btn_GetCheck(self.UIGROUP, BTN_WUXINGLIMIT)
  local nStarLevel = self.nCurItemStar * 2
  local nItemType = self.nCurItemType + 1
  local nOrderByType = self.nOrderByType
  local bDecOrder = self.bDecOrder
  local bMeSell = 0
  local bMeExpreed = 0
  local bReturn, szGoodName = self:PreProdGoodsName(szGoodName)
  --------------------------------------------------------------------------------------------
  local nCurrency = self.nCurItemMoney
  local nWuXingType = self.nCurItemWuXing
  if not nCurrency or nCurrency == 0 then
    nCurrency = 3
  end
  --------------------------------------------------------------------------------------------
  if 0 == bReturn then
    return
  end
  KAuction.AuctionNextPage(szGoodName, nItemType, nLevelLimit, nWuXingType, bMeSell, bMeExpreed, nOrderByType, bDecOrder, nStarLevel, ITEM_TYPE2[self.nCurItemType + 1], BROWSE_ITEMLIST_ID, nCurrency)
end

function tbAuctionRoom:FindGoods(szName)
  local szGoodName = Edt_GetTxt(self.UIGROUP, EDT_SEARCH)
  if szName then
    Edt_SetTxt(self.UIGROUP, EDT_SEARCH, szName)
    Btn_Check(self.UIGROUP, BTN_NAME_SEARCH, 1)
    szGoodName = szName
  end
  local nLevelLimit = self.nCurItemLevel
  local bWuXingLimit = Btn_GetCheck(self.UIGROUP, BTN_WUXINGLIMIT)
  local nStarLevel = self.nCurItemStar * 2
  local nItemType = self.nCurItemType + 1
  local nOrderByType = self.nOrderByType
  local bDecOrder = self.bDecOrder
  local bMeSell = 0
  local bMeExpreed = 0
  local bReturn, szGoodName = self:PreProdGoodsName(szGoodName)
  --------------------------------------------------------------------------------------------
  local nCurrency = self.nCurItemMoney
  local nWuXingType = self.nCurItemWuXing
  if not nCurrency or nCurrency == 0 then
    nCurrency = 3
  end
  --------------------------------------------------------------------------------------------
  if 0 == bReturn then
    return
  end
  KAuction.AuctionSearchRequest(szGoodName, nItemType, nLevelLimit, nWuXingType, bMeSell, bMeExpreed, nOrderByType, bDecOrder, nStarLevel, ITEM_TYPE2[self.nCurItemType + 1], BROWSE_ITEMLIST_ID, nCurrency)
  self.nDoTime = GetTime()
end

function tbAuctionRoom:Buy(nPrice, nOnePrice)
  local nGoodsIndex = self.nSelGoodIdx
  local nGoodsPrice = 0
  if nPrice == 0 or nPrice == nil then
    nGoodsPrice = Edt_GetInt(self.UIGROUP, EDT_BUYBYPRICE)
  else
    nGoodsPrice = nPrice
  end
  if nGoodsIndex >= 0 and nGoodsIndex < GOODSPERPAGE then
    if nOnePrice == nGoodsPrice then
      KAuction.AuctionOneTimeBuy(nGoodsIndex)
    else
      KAuction.AuctionExpreedBuy(nGoodsIndex, nGoodsPrice)
    end
  else
    UiManager:OpenWindow(Ui.UI_INFOBOARD, "没有选择要竞拍的物品")
  end
end

function tbAuctionRoom:OnePriceBuy()
  local nGoodsIndex = self.nSelGoodIdx
  if nGoodsIndex >= 0 and nGoodsIndex < GOODSPERPAGE then
    KAuction.AuctionOneTimeBuy(nGoodsIndex)
  else
    UiManager:OpenWindow(Ui.UI_INFOBOARD, "没有选择要购买的物品")
  end
end

function tbAuctionRoom:BuyingUpPage()
  local szGoodName = ""
  local nLevelLimit = 0
  local bWuXingLimit = 0
  local nStarLevel = 0
  local nItemType = 1
  local nOrderByType = self.nOrderByType
  local bDecOrder = self.bDecOrder
  local bMeSell = 0
  local bMeExpreed = 1
  local nCurrency = 3 -- 无货币类型限制
  KAuction.AuctionPrePage(szGoodName, nItemType, nLevelLimit, bWuXingLimit, bMeSell, bMeExpreed, nOrderByType, bDecOrder, nStarLevel, -1, BUYING_ITEMLIST_ID, nCurrency)
end

function tbAuctionRoom:BuyingDownPage()
  local szGoodName = ""
  local nLevelLimit = 0
  local bWuXingLimit = 0
  local nStarLevel = 0
  local nItemType = 1
  local nOrderByType = self.nOrderByType
  local bDecOrder = self.bDecOrder
  local bMeSell = 0
  local bMeExpreed = 1
  local nCurrency = 3 -- 无货币类型限制
  KAuction.AuctionNextPage(szGoodName, nItemType, nLevelLimit, bWuXingLimit, bMeSell, bMeExpreed, nOrderByType, bDecOrder, nStarLevel, -1, BUYING_ITEMLIST_ID, nCurrency)
end

function tbAuctionRoom:CancelSell()
  local nGoodsIndex = self.nSelGoodIdx
  KAuction.AuctionCancel(nGoodsIndex)
end

function tbAuctionRoom:Sell(bAccept)
  local nGoodsBuyOnePrice = Edt_GetInt(self.UIGROUP, EDT_SELLONEPRICE)
  local nGoodsExpreedPrice = Edt_GetInt(self.UIGROUP, EDT_SELLPRICE)
  ------------------------------------------------------------------------------------------------------------------------------
  -- 2010/10/27 10:13:16 xuantao 金币交易
  local bCoin = -1
  if Btn_GetCheck(self.UIGROUP, BTN_COIN) == 1 then
    bCoin = 1
    if KGblTask and KGblTask.SCGetDbTaskInt and KGblTask.SCGetDbTaskInt(DBTASK_OPEN_COIN_AUCTION) == 0 then
      Ui:ServerCall("UI_TASKTIPS", "Begin", "金币寄卖暂未开放，敬请期待！")
      return 0
    end
  elseif Btn_GetCheck(self.UIGROUP, BTN_YINLIANG) == 1 then
    bCoin = 0
  end

  local nYiKouJia = 0
  local nSellPrice = 0
  local nCurrency = 1 -- 银两
  if bCoin == -1 then
    UiManager:OpenWindow(Ui.UI_INFOBOARD, "您没有选择货币类型！")
    return 0
  end
  if bCoin == 1 then
    nYiKouJia = Edt_GetInt(self.UIGROUP, EDT_SELLONEPRICE_COIN)
    nSellPrice = nYiKouJia
    nCurrency = 2 -- 金币
  else
    nYiKouJia = Edt_GetInt(self.UIGROUP, EDT_SELLONEPRICE_YINLIANG)
    nSellPrice = Edt_GetInt(self.UIGROUP, EDT_SELLPRICE_YINLIANG)
  end
  ------------------------------------------------------------------------------------------------------------------------------
  local nGoodsItemId = 0
  local nGoodsSellTime = 0

  if Btn_GetCheck(self.UIGROUP, BTN_SELLTIME12) == 1 then
    nGoodsSellTime = 0
  elseif Btn_GetCheck(self.UIGROUP, BTN_SELLTIME24) == 1 then
    nGoodsSellTime = 1
  elseif Btn_GetCheck(self.UIGROUP, BTN_SELLTIME48) == 1 then
    nGoodsSellTime = 2
  else
    nGoodsSellTime = 0
  end
  if nCurrency == 1 and nYiKouJia < DIFPRICE then
    UiManager:OpenWindow(Ui.UI_INFOBOARD, "您的一口价标的太低了，一口价不能小于" .. DIFPRICE .. "银两！")
    return 0
  elseif nCurrency == 1 and nSellPrice <= 0 then
    UiManager:OpenWindow(Ui.UI_INFOBOARD, "竞拍价格不符合要求！")
    return 0
  end
  if nCurrency == 2 and nYiKouJia < COINPRICE then
    UiManager:OpenWindow(Ui.UI_INFOBOARD, "您的一口价标的太低了，金币寄卖不能小于" .. COINPRICE .. "金！")
    return 0
  end

  if not bAccept or bAccept ~= 1 then
    local pObj = self.tbSellGoodCont:GetObj()
    if not (pObj and pObj.nRoom and pObj.nX and pObj.nY) then
      print("获取不到物品")
      UiManager:OpenWindow(Ui.UI_INFOBOARD, "您没有放入要拍卖的物品！")
      return 0
    end

    local pItem = me.GetItem(pObj.nRoom, pObj.nX, pObj.nY)
    if not pItem then
      print("获取物品对象失败")
    end

    local tbMsg = {}
    tbMsg.szMsg = ""
    tbMsg.szTitle = "物品拍卖"
    if bCoin == 1 then
      tbMsg.szMsg = string.format("确定以<color=yellow>金币<color>来交易【%s】", pItem.szName)
    else
      tbMsg.szMsg = string.format("确定以<color=orange>银两<color>来交易【%s】", pItem.szName)
    end
    function tbMsg:Callback(nIndex, Wnd)
      if nIndex == 2 then
        Wnd:Sell(1)
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, self)
    return 0
  end

  KAuction.AuctionSell(nGoodsSellTime, nYiKouJia, nSellPrice, nCurrency)
  self:ShowSellPage_Detail()
end

function tbAuctionRoom:SellUpPage()
  local szGoodName = ""
  local nLevelLimit = 0
  local bWuXingLimit = 0
  local nStarLevel = 0
  local nItemType = 1
  local nOrderByType = self.nOrderByType
  local bDecOrder = self.bDecOrder
  local bMeSell = 1
  local bMeExpreed = 0
  local nCurrency = 3
  local nWuXingType = 0
  KAuction.AuctionPrePage(szGoodName, nItemType, nLevelLimit, nWuXingType, bMeSell, bMeExpreed, nOrderByType, bDecOrder, nStarLevel, -1, SELL_ITEMLIST_ID, nCurrency)
end

function tbAuctionRoom:SellDownPage()
  local szGoodName = ""
  local nLevelLimit = 0
  local bWuXingLimit = 0
  local nStarLevel = 0
  local nItemType = 1
  local nOrderByType = self.nOrderByType
  local bDecOrder = self.bDecOrder
  local bMeSell = 1
  local bMeExpreed = 0
  local nCurrency = 3 --self.nCurItemMoney;
  local nWuXingType = 0 --self.nCurItemWuXing;
  KAuction.AuctionNextPage(szGoodName, nItemType, nLevelLimit, nWuXingType, bMeSell, bMeExpreed, nOrderByType, bDecOrder, nStarLevel, -1, SELL_ITEMLIST_ID, nCurrency)
end

function tbAuctionRoom:ShowBrowsePage()
  self.nQureyBuyPrice = nil
  Wnd_Show(self.UIGROUP, BTN_BUY)
  Wnd_Show(self.UIGROUP, BTN_ONEPRICEBUY)
  if UiVersion == Ui.Version001 then
    Wnd_Show(self.UIGROUP, BTN_RETURNIBSHOP)
  end
  Wnd_SetFocus(self.UIGROUP, EDT_SEARCH)
  self:FindGoods()
end

function tbAuctionRoom:ShowBuyingPage()
  self.nQureyBuyPrice = nil
  Wnd_Hide(self.UIGROUP, BTN_BUY)
  Wnd_Hide(self.UIGROUP, BTN_ONEPRICEBUY)
  Wnd_Hide(self.UIGROUP, BTN_RETURNIBSHOP)
  local szGoodName = ""
  local nLevelLimit = 0
  local bWuXingLimit = 0
  local nStarLevel = 0
  local nItemType = 1
  local nOrderByType = self.nOrderByType
  local bDecOrder = self.bDecOrder
  local bMeSell = 0
  local bMeExpreed = 1
  KAuction.AuctionSearchRequest(szGoodName, nItemType, nLevelLimit, bWuXingLimit, bMeSell, bMeExpreed, nOrderByType, bDecOrder, nStarLevel, -1, BUYING_ITEMLIST_ID, 3)
  self.nDoTime = GetTime()
end

function tbAuctionRoom:ShowSellPage_Detail()
  Btn_Check(self.UIGROUP, BTN_SELLTIME12, 1)
  Btn_Check(self.UIGROUP, BTN_SELLTIME24, 0)
  Btn_Check(self.UIGROUP, BTN_SELLTIME48, 0)
  Btn_Check(self.UIGROUP, BTN_COIN, 0)
  Btn_Check(self.UIGROUP, BTN_YINLIANG, 0)
  Wnd_Hide(self.UIGROUP, BTN_BUY)
  Wnd_Hide(self.UIGROUP, BTN_ONEPRICEBUY)
  Wnd_Hide(self.UIGROUP, BTN_RETURNIBSHOP)
  Wnd_Hide(self.UIGROUP, PAGE_YINLIANG)
  Wnd_Hide(self.UIGROUP, PAGE_COIN)
end

function tbAuctionRoom:ShowSellPage(bRefresh)
  self.nQureyBuyPrice = 1
  local szGoodName = ""
  local nLevelLimit = 0
  local bWuXingLimit = 0
  local nStarLevel = 0
  local nItemType = 1
  local nOrderByType = self.nOrderByType
  local bDecOrder = self.bDecOrder
  local bMeSell = 1
  local bMeExpreed = 0
  if not bRefresh then
    Btn_SetTxt(self.UIGROUP, BtnQueryPrice, "查询市价")
    self:ShowSellPage_Detail()
  end
  KAuction.AuctionSearchRequest(szGoodName, nItemType, nLevelLimit, bWuXingLimit, bMeSell, bMeExpreed, nOrderByType, bDecOrder, nStarLevel, -1, SELL_ITEMLIST_ID, 3)
  self.nDoTime = GetTime()
end

--界面事件消息函数

function tbAuctionRoom:OnCreate()
  self.nCurMoneyType = 0
  self.nCurItemStar = 0
  self.nCurItemType = 0
  self.nSelGoodIdx = -1
  self.nOrderByType = 0
  self.bDecOrder = 0
  self.nCurItemLevel = -1
  -------------------------------------------------------------------------------
  -- 2010/10/27 11:50:31 xuantao 金币交易
  self.nCurItemMoney = 0 -- 搜索时的货币类型
  self.nCurItemWuXing = 0 -- 搜索时的五行类型
  -------------------------------------------------------------------------------
  self.tbSellGoodCont = tbObject:RegisterContainer(self.UIGROUP, OBJ_SELLITEM, 1, 1, tbSellGoodCont, "itemroom")

  for szListName in pairs(self.tbListBarViewGood) do
    for nItemBarIdx = 0, GOODSPERPAGE - 1 do
      self.tbListBarViewGood[szListName][nItemBarIdx] = tbObject:RegisterContainer(self.UIGROUP, tbListBarObj[szListName][nItemBarIdx], 1, 1, tbViewGoodCont)
    end
  end

  self:ClearItemList(BROWSE_ITEMLIST_NAME)
end

function tbAuctionRoom:OnDestroy()
  tbObject:UnregContainer(self.tbSellGoodCont)
  for szListName in pairs(self.tbListBarViewGood) do
    for nItemBarIdx = 0, GOODSPERPAGE - 1 do
      tbObject:UnregContainer(self.tbListBarViewGood[szListName][nItemBarIdx])
    end
  end
end

function tbAuctionRoom:OnOpen()
  self.nDoTime = 0
  UiManager:CloseWindow(Ui.UI_IBSHOP)
  self:UpdateAuctionRoom()
  self:ClearItemList(BROWSE_ITEMLIST_NAME)
  ClearComboBoxItem(self.UIGROUP, CMB_ITEMLEVEL)
  for i = 1, #LEVLE_TYPE do
    ComboBoxAddItem(self.UIGROUP, CMB_ITEMLEVEL, i, LEVLE_TYPE[i])
  end
  ComboBoxSelectItem(self.UIGROUP, CMB_ITEMLEVEL, 0)

  ClearComboBoxItem(self.UIGROUP, CMB_ITEMTYPE)
  for i = 1, #ITEM_TYPE_NAME do
    ComboBoxAddItem(self.UIGROUP, CMB_ITEMTYPE, i, ITEM_TYPE_NAME[i])
  end
  ComboBoxSelectItem(self.UIGROUP, CMB_ITEMTYPE, 0)

  ClearComboBoxItem(self.UIGROUP, CMB_ITEMSTAR)
  for i = 1, #STAR_TYPE do
    ComboBoxAddItem(self.UIGROUP, CMB_ITEMSTAR, i, STAR_TYPE[i])
  end
  ComboBoxSelectItem(self.UIGROUP, CMB_ITEMSTAR, 0)
  --------------------------------------------------------------
  -- 2010/10/22 16:44:51 xuantao
  ClearComboBoxItem(self.UIGROUP, CMB_ITEMWUXING)
  for i = 1, #ITEM_WUXING do
    ComboBoxAddItem(self.UIGROUP, CMB_ITEMWUXING, i, ITEM_WUXING[i])
  end
  ComboBoxSelectItem(self.UIGROUP, CMB_ITEMWUXING, 0)

  ClearComboBoxItem(self.UIGROUP, CMB_ITEMMOENY)
  for i = 1, #MOENY_TYPE do
    ComboBoxAddItem(self.UIGROUP, CMB_ITEMMOENY, i, MOENY_TYPE[i])
  end
  ComboBoxSelectItem(self.UIGROUP, CMB_ITEMMOENY, 0)
  --------------------------------------------------------------

  PgSet_ActivePage(self.UIGROUP, "PageSetMain", PAGE_BROWSE)

  local bStartPage = KAuction.IsStartPage()
  local bEndPage = KAuction.IsEndPage()

  if bStartPage == 1 then
    Wnd_SetEnable(self.UIGROUP, BTN_LOOKPAGEUP, 0)
  else
    Wnd_SetEnable(self.UIGROUP, BTN_LOOKPAGEUP, 1)
  end
  if bEndPage == 1 then
    Wnd_SetEnable(self.UIGROUP, BTN_LOOKPAGEDOWN, 0)
  else
    Wnd_SetEnable(self.UIGROUP, BTN_LOOKPAGEDOWN, 1)
  end
  Btn_Check(self.UIGROUP, BTN_NAME_SEARCH, 1)
  Wnd_SetFocus(self.UIGROUP, EDT_SEARCH)
end

function tbAuctionRoom:OnClose()
  self:ClearItemList(BROWSE_ITEMLIST_NAME)
  me.ShopExit(AUCTIONSTATE)
  self.tbSellGoodCont:ClearRoom()

  --	self.tbViewGoodCont0_browse:ClearObj();
  for szListName in pairs(self.tbListBarViewGood) do
    for nItemBarIdx = 0, GOODSPERPAGE - 1 do
      self.tbListBarViewGood[szListName][nItemBarIdx]:ClearObj()
    end
  end

  KAuction.ClearAuctionDate()
end

function tbAuctionRoom:OnComboBoxIndexChange(szWnd, nIndex)
  if szWnd == CMB_ITEMSTAR then
    self.nCurItemStar = nIndex
  end
  if szWnd == CMB_ITEMTYPE then
    self.nCurItemType = nIndex
  end
  if szWnd == CMB_ITEMLEVEL then
    self.nCurItemLevel = nIndex
  end
  if szWnd == CMB_ITEMMOENY then
    self.nCurItemMoney = nIndex
  end
  if szWnd == CMB_ITEMWUXING then
    self.nCurItemWuXing = nIndex
  end
end

function tbAuctionRoom:OnEditChange(szWnd, nParam)
  if EDT_SELLPRICE_YINLIANG == szWnd or EDT_SELLONEPRICE_YINLIANG == szWnd or EDT_SELLONEPRICE_COIN == szWnd then
    local nGoodsSellTime = 0
    if Btn_GetCheck(self.UIGROUP, BTN_SELLTIME12) == 1 then
      nGoodsSellTime = 0
    elseif Btn_GetCheck(self.UIGROUP, BTN_SELLTIME24) == 1 then
      nGoodsSellTime = 1
    elseif Btn_GetCheck(self.UIGROUP, BTN_SELLTIME48) == 1 then
      nGoodsSellTime = 2
    else
      nGoodsSellTime = 0
    end

    local tax = Auction:CalcAuctionTax(nGoodsSellTime, nGoodsBuyOnePrice, nGoodsExpreedPrice)

    if nMoneyType == 0 then
      Txt_SetTxt(self.UIGROUP, TXT_SELLTAX, tax .. "(" .. YINLIANG .. ")")
    end
  end
end

function tbAuctionRoom:IsListBar(szWnd, szListName)
  for szListBarName in pairs(tbListBarObj[szListName]) do
    if szListBarName == szWnd then
      return 1
    end
  end
  return 0
end
-- 选择金币拍卖
function tbAuctionRoom:OnBtnCoin()
  if KGblTask and KGblTask.SCGetDbTaskInt and KGblTask.SCGetDbTaskInt(DBTASK_OPEN_COIN_AUCTION) == 0 then
    Btn_Check(self.UIGROUP, BTN_COIN, 0)
    Btn_Check(self.UIGROUP, BTN_YINLIANG, 1)
    Wnd_Hide(self.UIGROUP, PAGE_COIN)
    Wnd_Show(self.UIGROUP, PAGE_YINLIANG)
    PgSet_ActivePage(self.UIGROUP, PAGE_MONEY_SET, PAGE_YINLIANG)
    Ui:ServerCall("UI_TASKTIPS", "Begin", "金币寄卖暂未开放，敬请期待！")
  elseif KGblTask and KGblTask.SCGetDbTaskInt and KGblTask.SCGetDbTaskInt(DBTASK_OPEN_COIN_AUCTION) == 1 then
    Btn_Check(self.UIGROUP, BTN_COIN, 1)
    Btn_Check(self.UIGROUP, BTN_YINLIANG, 0)
    Wnd_Hide(self.UIGROUP, PAGE_YINLIANG)
    Wnd_Show(self.UIGROUP, PAGE_COIN)
    PgSet_ActivePage(self.UIGROUP, PAGE_MONEY_SET, PAGE_COIN)
  end
end
-- 选择银两拍卖
function tbAuctionRoom:OnBtnYinLiang()
  Btn_Check(self.UIGROUP, BTN_COIN, 0)
  Btn_Check(self.UIGROUP, BTN_YINLIANG, 1)
  Wnd_Hide(self.UIGROUP, PAGE_COIN)
  Wnd_Show(self.UIGROUP, PAGE_YINLIANG)
  PgSet_ActivePage(self.UIGROUP, PAGE_MONEY_SET, PAGE_YINLIANG)
end
-- 点击拍卖时间
function tbAuctionRoom:OnBtnSellTime(szWnd)
  if BTN_SELLTIME12 == szWnd then
    if Btn_GetCheck(self.UIGROUP, BTN_SELLTIME12) == 1 then
      Btn_Check(self.UIGROUP, BTN_SELLTIME24, 0)
      Btn_Check(self.UIGROUP, BTN_SELLTIME48, 0)
    else
      Btn_Check(self.UIGROUP, BTN_SELLTIME12, 1)
    end
  --	self:OnEditChange(EDT_SELLPRICE_YINLIANG, 0);
  elseif BTN_SELLTIME24 == szWnd then
    if Btn_GetCheck(self.UIGROUP, BTN_SELLTIME24) == 1 then
      Btn_Check(self.UIGROUP, BTN_SELLTIME12, 0)
      Btn_Check(self.UIGROUP, BTN_SELLTIME48, 0)
    else
      Btn_Check(self.UIGROUP, BTN_SELLTIME24, 1)
    end
  --	self:OnEditChange(EDT_SELLPRICE_YINLIANG, 0);
  elseif BTN_SELLTIME48 == szWnd then
    if Btn_GetCheck(self.UIGROUP, BTN_SELLTIME48) == 1 then
      Btn_Check(self.UIGROUP, BTN_SELLTIME24, 0)
      Btn_Check(self.UIGROUP, BTN_SELLTIME12, 0)
    else
      Btn_Check(self.UIGROUP, BTN_SELLTIME48, 1)
    end
  end
  self:OnEditChange(EDT_SELLPRICE_YINLIANG, 0)
end

function tbAuctionRoom:OnButtonClick(szWnd, nParam)
  if (BTN_CLOSE0 == szWnd or BTN_CLOSE1 == szWnd or BTN_CLOSE2 == szWnd) or (BTN_CLOSE == szWnd) then -- 关闭主窗口
    UiManager:CloseWindow(self.UIGROUP)
  elseif BTN_FINDGOODS == szWnd then
    if self.nDoTime > 0 and GetTime() - self.nDoTime < self.nMaxDoTime then
      UiManager:OpenWindow("UI_INFOBOARD", "请不要过快操作")
      return
    end
    self:FindGoods()
  elseif BTN_SHOWPRICE == szWnd then
    self:UpdateItemList(BROWSE_ITEMLIST_NAME)
    return
  elseif BTN_CANCELSELL == szWnd then
    self:CancelSell()
  elseif BTN_BUY == szWnd then
    self:OnBtnBuy(szWnd, nParam)
  elseif BTN_ONEPRICEBUY == szWnd then
    self:OnBtnOnePrice(szWnd, nParam)
  elseif BTN_RETURNIBSHOP == szWnd then
    UiManager:CloseWindow(Ui.UI_AUCTIONROOM)
    UiManager:OpenWindow(Ui.UI_IBSHOP, "返回商城")
  elseif BTN_SELL == szWnd then
    self:Sell()
  elseif BTN_LOOKPAGEUP == szWnd then
    if self.nDoTime > 0 and GetTime() - self.nDoTime < self.nMaxDoTime then
      UiManager:OpenWindow("UI_INFOBOARD", "请不要过快操作")
      return
    end
    self:UpPage()
  elseif BTN_LOOKPAGEDOWN == szWnd then
    if self.nDoTime > 0 and GetTime() - self.nDoTime < self.nMaxDoTime then
      UiManager:OpenWindow("UI_INFOBOARD", "请不要过快操作")
      return
    end
    self:DownPage()
  elseif BTN_BUYINGPAGEUP == szWnd then
    if self.nDoTime > 0 and GetTime() - self.nDoTime < self.nMaxDoTime then
      UiManager:OpenWindow("UI_INFOBOARD", "请不要过快操作")
      return
    end
    self:BuyingUpPage()
  elseif BTN_BUYINGPAGEDOWN == szWnd then
    if self.nDoTime > 0 and GetTime() - self.nDoTime < self.nMaxDoTime then
      UiManager:OpenWindow("UI_INFOBOARD", "请不要过快操作")
      return
    end
    self:BuyingDownPage()
  elseif BTN_SELLPAGEUP == szWnd then
    if self.nDoTime > 0 and GetTime() - self.nDoTime < self.nMaxDoTime then
      UiManager:OpenWindow("UI_INFOBOARD", "请不要过快操作")
      return
    end
    self:SellUpPage()
  elseif BTN_SELLPAGEDOWN == szWnd then
    if self.nDoTime > 0 and GetTime() - self.nDoTime < self.nMaxDoTime then
      UiManager:OpenWindow("UI_INFOBOARD", "请不要过快操作")
      return
    end
    self:SellDownPage()
  elseif BTN_BROWSEPAGE == szWnd then
    self:ShowBrowsePage()
  elseif BTN_BUYINGPAGE == szWnd then
    self:ShowBuyingPage()
  elseif BTN_SELLPAGE == szWnd then
    self:ShowSellPage()
  elseif BTN_BGLISTGOODSNAMESORT == szWnd then
    if self.nDoTime > 0 and GetTime() - self.nDoTime < self.nMaxDoTime then
      UiManager:OpenWindow("UI_INFOBOARD", "请不要过快操作")
      return
    end
    Btn_Check(self.UIGROUP, BTN_BGLISTSTARSORT, 0)
    Btn_Check(self.UIGROUP, BTN_BGLISTPRICESORT, 0)

    if Btn_GetCheck(self.UIGROUP, BTN_BGLISTGOODSNAMESORT) == 1 then
      self.nOrderByType = 3
      self.bDecOrder = 0
      if UiVersion == Ui.Version001 then
        Img_SetImage(self.UIGROUP, BTN_BGLISTGOODSNAMESORT, 1, "\\image\\ui\\001a\\auction\\auctionitemnamebtn0.spr")
      else
        Img_SetImage(self.UIGROUP, BTN_BGLISTGOODSNAMESORT, 1, "\\image\\ui\\002a\\auctionroom\\btn_title2_b.spr")
      end
    else
      self.nOrderByType = 3
      self.bDecOrder = 1
      if UiVersion == Ui.Version001 then
        Img_SetImage(self.UIGROUP, BTN_BGLISTGOODSNAMESORT, 1, "\\image\\ui\\001a\\auction\\auctionitemnamebtn.spr")
      else
        Img_SetImage(self.UIGROUP, BTN_BGLISTGOODSNAMESORT, 1, "\\image\\ui\\002a\\auctionroom\\btn_title2_a.spr")
      end
    end
    self:ShowBrowsePage()
  elseif BTN_BGLISTSTARSORT == szWnd then
    if self.nDoTime > 0 and GetTime() - self.nDoTime < self.nMaxDoTime then
      UiManager:OpenWindow("UI_INFOBOARD", "请不要过快操作")
      return
    end
    Btn_Check(self.UIGROUP, BTN_BGLISTGOODSNAMESORT, 0)
    Btn_Check(self.UIGROUP, BTN_BGLISTPRICESORT, 0)
    if Btn_GetCheck(self.UIGROUP, BTN_BGLISTSTARSORT) == 1 then
      self.nOrderByType = 1
      self.bDecOrder = 0
      if UiVersion == Ui.Version001 then
        Img_SetImage(self.UIGROUP, BTN_BGLISTSTARSORT, 1, "\\image\\ui\\001a\\auction\\auctionstarsortbtn0.spr")
      else
        Img_SetImage(self.UIGROUP, BTN_BGLISTSTARSORT, 1, "\\image\\ui\\002a\\auctionroom\\btn_title1_b.spr")
      end
    else
      self.nOrderByType = 1
      self.bDecOrder = 1
      if UiVersion == Ui.Version001 then
        Img_SetImage(self.UIGROUP, BTN_BGLISTSTARSORT, 1, "\\image\\ui\\001a\\auction\\auctionstarsortbtn.spr")
      else
        Img_SetImage(self.UIGROUP, BTN_BGLISTSTARSORT, 1, "\\image\\ui\\002a\\auctionroom\\btn_title1_a.spr")
      end
    end
    self:ShowBrowsePage()
  elseif BTN_BGLISTPRICESORT == szWnd then
    if self.nDoTime > 0 and GetTime() - self.nDoTime < self.nMaxDoTime then
      UiManager:OpenWindow("UI_INFOBOARD", "请不要过快操作")
      return
    end
    Btn_Check(self.UIGROUP, BTN_BGLISTGOODSNAMESORT, 0)
    Btn_Check(self.UIGROUP, BTN_BGLISTSTARSORT, 0)

    if Btn_GetCheck(self.UIGROUP, BTN_BGLISTPRICESORT) == 1 then
      self.nOrderByType = 2
      self.bDecOrder = 0
      if UiVersion == Ui.Version001 then
        Img_SetImage(self.UIGROUP, BTN_BGLISTPRICESORT, 1, "\\image\\ui\\001a\\auction\\auctionpricesortbtn0.spr")
      else
        Img_SetImage(self.UIGROUP, BTN_BGLISTPRICESORT, 1, "\\image\\ui\\002a\\auctionroom\\btn_title2_b.spr")
      end
    else
      self.nOrderByType = 2
      self.bDecOrder = 1
      if UiVersion == Ui.Version001 then
        Img_SetImage(self.UIGROUP, BTN_BGLISTPRICESORT, 1, "\\image\\ui\\001a\\auction\\auctionpricesortbtn.spr")
      else
        Img_SetImage(self.UIGROUP, BTN_BGLISTPRICESORT, 1, "\\image\\ui\\002a\\auctionroom\\btn_title2_a.spr")
      end
    end
    self:ShowBrowsePage()
  elseif BTN_BUYINGGLISTSTARSORT == szWnd then
    if self.nDoTime > 0 and GetTime() - self.nDoTime < self.nMaxDoTime then
      UiManager:OpenWindow("UI_INFOBOARD", "请不要过快操作")
      return
    end
    if Btn_GetCheck(self.UIGROUP, BTN_BUYINGGLISTSTARSORT) == 1 then
      self.nOrderByType = 1
      self.bDecOrder = 0
      if UiVersion == Ui.Version001 then
        Img_SetImage(self.UIGROUP, BTN_BUYINGGLISTSTARSORT, 1, "\\image\\ui\\001a\\auction\\auctionstarsortbtn0.spr")
      else
        Img_SetImage(self.UIGROUP, BTN_BUYINGGLISTSTARSORT, 1, "\\image\\ui\\002a\\auctionroom\\btn_title1_b.spr")
      end
    else
      self.nOrderByType = 1
      self.bDecOrder = 1
      if UiVersion == Ui.Version001 then
        Img_SetImage(self.UIGROUP, BTN_BUYINGGLISTSTARSORT, 1, "\\image\\ui\\001a\\auction\\auctionstarsortbtn.spr")
      else
        Img_SetImage(self.UIGROUP, BTN_BUYINGGLISTSTARSORT, 1, "\\image\\ui\\002a\\auctionroom\\btn_title1_a.spr")
      end
    end
    self:ShowBuyingPage()
  elseif BTN_BUYINGGLISTPRICESORT == szWnd then
    if self.nDoTime > 0 and GetTime() - self.nDoTime < self.nMaxDoTime then
      UiManager:OpenWindow("UI_INFOBOARD", "请不要过快操作")
      return
    end
    if Btn_GetCheck(self.UIGROUP, BTN_BUYINGGLISTPRICESORT) == 1 then
      self.nOrderByType = 2
      self.bDecOrder = 0
      if UiVersion == Ui.Version001 then
        Img_SetImage(self.UIGROUP, BTN_BUYINGGLISTPRICESORT, 1, "\\image\\ui\\001a\\auction\\auctionpricesortbtn0.spr")
      else
        Img_SetImage(self.UIGROUP, BTN_BUYINGGLISTPRICESORT, 1, "\\image\\ui\\002a\\auctionroom\\btn_title2_b.spr")
      end
    else
      self.nOrderByType = 2
      self.bDecOrder = 1
      if UiVersion == Ui.Version001 then
        Img_SetImage(self.UIGROUP, BTN_BUYINGGLISTPRICESORT, 1, "\\image\\ui\\001a\\auction\\auctionpricesortbtn.spr")
      else
        Img_SetImage(self.UIGROUP, BTN_BUYINGGLISTPRICESORT, 1, "\\image\\ui\\002a\\auctionroom\\btn_title2_a.spr")
      end
    end
    self:ShowBuyingPage()
  elseif BTN_SELLGLISTSTARSORT == szWnd then
    if self.nDoTime > 0 and GetTime() - self.nDoTime < self.nMaxDoTime then
      UiManager:OpenWindow("UI_INFOBOARD", "请不要过快操作")
      return
    end
    if Btn_GetCheck(self.UIGROUP, BTN_SELLGLISTSTARSORT) == 1 then
      self.nOrderByType = 1
      self.bDecOrder = 0
    else
      self.nOrderByType = 1
      self.bDecOrder = 1
    end
    self:ShowSellPage()
  elseif BTN_SELLGLISTPRICESORT == szWnd then
    if self.nDoTime > 0 and GetTime() - self.nDoTime < self.nMaxDoTime then
      UiManager:OpenWindow("UI_INFOBOARD", "请不要过快操作")
      return
    end
    if Btn_GetCheck(self.UIGROUP, BTN_SELLGLISTPRICESORT) == 1 then
      self.nOrderByType = 2
      self.bDecOrder = 0
    else
      self.nOrderByType = 2
      self.bDecOrder = 1
    end
    self:ShowSellPage()
  elseif BGLISTBAR_0 == szWnd or BGLISTBAR_1 == szWnd or BGLISTBAR_2 == szWnd or BGLISTBAR_3 == szWnd or BGLISTBAR_4 == szWnd or BGLISTBAR_5 == szWnd or BGLISTBAR_6 == szWnd or BGLISTBAR_7 == szWnd then
    self:ItemBarLight(szWnd, "BGListBar")
    local nItemIdex = tgGoodsIndexArray[szWnd]
    local rec = KAuction.AuctionGetSearchResultByIndex(nItemIdex)
    if rec ~= nil and nItemIdex then
      local nCurrency = rec.GetCurrency()
      local bCheck = Btn_GetCheck(self.UIGROUP, szWnd)
      if bCheck == 1 then
        if nCurrency and nCurrency == 2 then
          Wnd_SetEnable(self.UIGROUP, BTN_BUY, 0)
        else
          Wnd_SetEnable(self.UIGROUP, BTN_BUY, 1)
        end
        self.nSelGoodIdx = tgGoodsIndexArray[szWnd]
      else
        self.nSelGoodIdx = -1
        Wnd_SetEnable(self.UIGROUP, BTN_BUY, 1)
      end
    end
  elseif BUYINGGLISTBAR_0 == szWnd or BUYINGGLISTBAR_1 == szWnd or BUYINGGLISTBAR_2 == szWnd or BUYINGGLISTBAR_3 == szWnd or BUYINGGLISTBAR_4 == szWnd or BUYINGGLISTBAR_5 == szWnd or BUYINGGLISTBAR_6 == szWnd or BUYINGGLISTBAR_7 == szWnd then
    self:ItemBarLight(szWnd, "BuyingGListBar")
    self.nSelGoodIdx = tgGoodsIndexArray[szWnd]
  -----------------------------------------------------------------------------------
  elseif BTN_SELLTIME12 == szWnd then
    self:OnBtnSellTime(szWnd)
  elseif BTN_SELLTIME24 == szWnd then
    self:OnBtnSellTime(szWnd)
  elseif BTN_SELLTIME48 == szWnd then
    self:OnBtnSellTime(szWnd)
  -----------------------------------------------------------------------------------
  elseif Sell_0_BtnSend == szWnd or Sell_1_BtnSend == szWnd or Sell_2_BtnSend == szWnd or Sell_3_BtnSend == szWnd or Sell_4_BtnSend == szWnd or Sell_5_BtnSend == szWnd or Sell_6_BtnSend == szWnd or Sell_7_BtnSend == szWnd then
    self:SendSellItem(szWnd)
  elseif BTN_COIN == szWnd then
    self:OnBtnCoin()
  elseif BTN_YINLIANG == szWnd then
    self:OnBtnYinLiang()
  elseif BtnQueryPrice == szWnd then
    if self.nDoTime > 0 and GetTime() - self.nDoTime < self.nMaxDoTime then
      UiManager:OpenWindow("UI_INFOBOARD", "请不要过快操作")
      return
    end
    self:QureyPrice()
  end
end

function tbAuctionRoom:QureyPrice()
  if self.nQureyBuyPrice == 0 then
    self:ShowSellPage(1)
    Btn_SetTxt(self.UIGROUP, BtnQueryPrice, "查询市价")
  else
    local pObj = self.tbSellGoodCont:GetObj()
    if not pObj then
      UiManager:OpenWindow("UI_INFOBOARD", "请放入要查询的物品")
      return
    end
    local pItem = me.GetItem(pObj.nRoom, pObj.nX, pObj.nY)
    if not pItem then
      UiManager:OpenWindow("UI_INFOBOARD", "请放入要查询的物品")
      return
    end
    Btn_SetTxt(self.UIGROUP, BtnQueryPrice, "返回贩卖")
    self.nQureyBuyPrice = 0
    local szGoodName = pItem.szName
    local nLevelLimit = 0
    local bWuXingLimit = 0
    local nStarLevel = 0
    local nItemType = 1
    local nOrderByType = 2
    local bDecOrder = 0
    local bMeSell = 0
    local bMeExpreed = 0
    local nCurrency = 3
    if Btn_GetCheck(self.UIGROUP, BTN_COIN) == 1 then
      nCurrency = 2
    elseif Btn_GetCheck(self.UIGROUP, BTN_YINLIANG) == 1 then
      nCurrency = 1
    end
    --self:ShowSellPage_Detail();
    KAuction.AuctionSearchRequest(szGoodName, nItemType, nLevelLimit, bWuXingLimit, bMeSell, bMeExpreed, nOrderByType, bDecOrder, nStarLevel, -1, SELL_ITEMLIST_ID_QUERY, nCurrency)
    self.nDoTime = GetTime()
  end
end

function tbAuctionRoom:SendSellItem(szWnd)
  local szAucKey = tbBtnSend2ItemIdx[szWnd]
  if self.tbBtnSend2ItemCurrency[szWnd] then
    me.CallServerScript({ "AuctionCmd", "ApplySendAdvs", szAucKey })
  else
    print("错误，货币类型不认识")
  end
end

function tbAuctionRoom:PreProdGoodsName(szGoodName)
  local bNameSearch = Btn_GetCheck(self.UIGROUP, BTN_NAME_SEARCH)
  if bNameSearch == 1 and szGoodName and szGoodName ~= "" then
    if szGoodName then
      local szTemp = Auction:ParseName(szGoodName)
      if KUnify.IsNameWordPass(szTemp) ~= 1 then
        me.Msg("您只能输入中文简繁体字，数字及· 【 】（）符号！")
        return 0, szGoodName
      end
    end
  else
    szGoodName = ""
  end
  return 1, szGoodName
end

function tbAuctionRoom:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_MONEY_CHANGED, self.UpdateAuctionRoom },
    { UiNotify.emCOREEVENT_JBCOIN_CHANGED, self.UpdateAuctionRoom },
    { UiNotify.emCOREEVENT_SYNC_BINDCOINANDMONEY, self.UpdateAuctionRoom },
    { UiNotify.emCOREEVENT_SYNC_AUCTION_RET, self.SearchReturn },
  }

  tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbSellGoodCont:RegisterEvent())
  for szListName in pairs(self.tbListBarViewGood) do
    for nItemBarIdx = 0, GOODSPERPAGE - 1 do
      tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbListBarViewGood[szListName][nItemBarIdx]:RegisterEvent())
    end
  end

  return tbRegEvent
end

function tbAuctionRoom:RegisterMessage()
  local tbRegMsg = {}
  tbRegMsg = Lib:MergeTable(tbRegMsg, self.tbSellGoodCont:RegisterMessage())
  for szListName in pairs(self.tbListBarViewGood) do
    for nItemBarIdx = 0, GOODSPERPAGE - 1 do
      tbRegMsg = Lib:MergeTable(tbRegMsg, self.tbListBarViewGood[szListName][nItemBarIdx]:RegisterMessage())
    end
  end

  return tbRegMsg
end

function tbAuctionRoom:OnBtnBuy(szWnd, nParam)
  local nGoodsIndex = self.nSelGoodIdx
  if nGoodsIndex >= 0 and nGoodsIndex < GOODSPERPAGE then
    local rec = KAuction.AuctionGetSearchResultByIndex(nGoodsIndex)
    if rec ~= nil then
      local nItemIdx = rec.GetItemIndex() -- 获取临时物品对象的Index
      local szSellName = rec.GetSellerName() -- 获取卖者名字
      local szSellTime = rec.GetValidTime() -- 获取有效期(秒为单位);
      local nPrice = rec.GetCompetePrice() -- 获取竞拍价
      local nOnePrice = rec.GetOneTimeBuyPrice() -- 获取一口价价格 （银两）;
      local nCurrency = rec.GetCurrency() -- 交易的货币类型
      local nSelItemBuyPrice = Edt_GetInt(self.UIGROUP, EDT_BUYBYPRICE)
      local pItem = KItem.GetItemObj(nItemIdx)
      local tbObj = nil
      if nCurrency and nCurrency == 2 then
        UiManager:OpenWindow(Ui.UI_INFOBOARD, "金币交易的物品不能够竞拍")
        return
      end
      if pItem then
        tbObj = {}
        tbObj.nType = Ui.OBJ_ITEM
        tbObj.pItem = pItem
      end
      local tbApplyMsg = {}
      tbApplyMsg.tgObj = tbObj
      tbApplyMsg.szObjName = pItem.szName
      tbApplyMsg.szMsg = "该物品当前竞拍价是：<color=255,167,0>" .. Item:FormatMoney(nPrice) .. "<color>(两)"
      tbApplyMsg.szTitle = "竞拍物品"
      tbApplyMsg.nOptCount = 2
      tbApplyMsg.bObjEdt = 1
      tbApplyMsg.szObjEdtTxt = "您的出价："

      function tbApplyMsg:Callback(nOptIndex, msgWnd, Wnd)
        if nOptIndex == 2 then
          local nNewPrice = msgWnd:GetObjEdtInt()
          if nNewPrice - nPrice < DIFPRICE then
            local szMsg = "<color=red>您的竞价必须比当前竞拍价高出" .. DIFPRICE .. "银两。<color>"
            UiManager:OpenWindow(Ui.UI_INFOBOARD, szMsg)
            return
          end
          Wnd:Buy(nNewPrice, nOnePrice)
        end
      end
      UiManager:OpenWindow(Ui.UI_MSGBOXWITHOBJ, tbApplyMsg, self)
    end
  else
    UiManager:OpenWindow(Ui.UI_INFOBOARD, "没有选择要竞拍的物品")
  end
end

function tbAuctionRoom:OnBtnOnePrice(szWnd, nParam)
  local nGoodsIndex = self.nSelGoodIdx
  if nGoodsIndex >= 0 and nGoodsIndex < GOODSPERPAGE then
    local rec = KAuction.AuctionGetSearchResultByIndex(nGoodsIndex)
    if rec ~= nil then
      local nItemIdx = rec.GetItemIndex() -- 获取临时物品对象的Index
      local szSellName = rec.GetSellerName() -- 获取卖者名字
      local szSellTime = rec.GetValidTime() -- 获取有期(秒为单位);
      local nPrice = rec.GetCompetePrice() -- 获取竞拍价
      local nOnePrice = rec.GetOneTimeBuyPrice() -- 获取一口价价格 （银两）;
      local nCurrency = rec.GetCurrency() -- 获取交易货币类型
      local pItem = KItem.GetItemObj(nItemIdx)
      local tbObj = nil
      if pItem then
        tbObj = {}
        tbObj.nType = Ui.OBJ_ITEM
        tbObj.pItem = pItem
      end
      local tbApplyMsg = {}
      tbApplyMsg.tgObj = tbObj
      tbApplyMsg.szObjName = pItem.szName
      tbApplyMsg.szMsg = "您确认以一口价：<color=255,167,0>" .. Item:FormatMoney(nOnePrice) .. "(两)<color>来购买这件物品？"
      tbApplyMsg.szTitle = "竞拍物品"
      tbApplyMsg.nOptCount = 2
      tbApplyMsg.bObjEdt = 0
      if nCurrency and nCurrency == 2 then
        tbApplyMsg.szMsg = "您确认以一口价：<color=yellow>" .. Item:FormatMoney(nOnePrice) .. "(金)<color>来购买这件物品？"
        tbApplyMsg.szWarmingTxt = "<color=yellow>注意：将扣除您的金币<color>"
      else
        tbApplyMsg.szWarmingTxt = ""
      end
      function tbApplyMsg:Callback(nOptIndex, msgWnd, Wnd)
        if nOptIndex == 2 then
          Wnd:OnePriceBuy()
        end
      end
      UiManager:OpenWindow(Ui.UI_MSGBOXWITHOBJ, tbApplyMsg, self)
    end
  else
    UiManager:OpenWindow(Ui.UI_INFOBOARD, "没有选择要一口价购买的物品")
  end
end

function tbAuctionRoom:OnSpecialKeyDown(szWndName, nParam)
  if szWndName == EDT_SEARCH then
    if nParam == Ui.MSG_VK_RETURN then -- 回车，自动勾选按名称搜索，然后搜索
      local szGoodName = Edt_GetTxt(self.UIGROUP, EDT_SEARCH)
      if szGoodName == nil or szGoodName == "" then
        Btn_Check(self.UIGROUP, BTN_NAME_SEARCH, 0)
      else
        Btn_Check(self.UIGROUP, BTN_NAME_SEARCH, 1)
      end
      self:FindGoods()
    end
  end
end

function tbAuctionRoom:Link_infor_OnClick(szWnd, szSellName)
  ChatToPlayer(szSellName)
end
