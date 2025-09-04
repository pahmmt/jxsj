local uiIbShopCart = Ui:GetClass("ibshopcart")
local tbObject = Ui.tbLogic.tbObject
local tbMouse = Ui.tbLogic.tbMouse

local BUTTON_CLOSE = "BtnCloseWnd"
local TXT_PAGA_NUMBER = "TxtPageNum"
local BUTTON_BACK_MARKET = "BtnBackMarket"
local DISCONUT_CARD_CONTAINER = "Obj"
local COMMINT_BUY = "BtnSurePay"
local BUTTON_QUICKGETGOLD = "BtnQuickGetGold"
local BUTTON_CURRENCY1 = "BtnCurrencyType1"
local BUTTON_CURRENCY2 = "BtnCurrencyType2"

local COINTYPE = 1
local SILVERTYPE = 2
local BINDCOINTYPE = 3
local INTEGRALCOINTYPE = 4

local MAX_NUMBER = 999
local WEBSITE = "http://pay.kingsoft.com/index.php?s=jxsj"

local MAIN_PAGE_SET = 1
local TXT_GOOD_NAME = 2
local GOOD_PRICE = 3
local GOOD_DISCOUNT = 4
local EDT_NUMBER_BUY = 5
local BUTTON_ADD = 6
local BUTTON_SUB = 7
local TXT_TOTAL_PRICE = 8
local BUTTON_CHECK = 9
local BUTTON_DELETE = 10
local OBJ_SHOW = 11

local TXT_COUNT = 1
local TXT_NEED = 2
local TXT_SAVED = 3
local TXT_CONSUME = 4
local TXT_LEFT_GOLD = 5
local TXT_BIND_GOLD = 6
local TXT_LEFT_QIANZHUANGGOLD = 7
local TXT_LAST_INFOR = 8
local TXT_LEFT_INTEGRAL = 9

local OBJ_CONT_ROW = 1 -- 优惠券容器列
local OBJ_CONT_LINE = 1 -- 优惠券容器行

local PAGE_SET = {
  [1] = {
    [MAIN_PAGE_SET] = "LstGoodsShow1",
    [TXT_GOOD_NAME] = "GoodNames1",
    [GOOD_PRICE] = "GoodsPrice1",
    [GOOD_DISCOUNT] = "GoodDiscount1",
    [EDT_NUMBER_BUY] = "EdtNumberBuy1",
    [BUTTON_ADD] = "BtnAdd1",
    [BUTTON_SUB] = "BtnSub1",
    [TXT_TOTAL_PRICE] = "TxtTotalPrice1",
    [BUTTON_CHECK] = "BtnCheck1",
    [BUTTON_DELETE] = "BtnBuy1",
    [OBJ_SHOW] = "ImgGoodShow1",
  },
  [2] = {
    [MAIN_PAGE_SET] = "LstGoodsShow2",
    [TXT_GOOD_NAME] = "GoodNames2",
    [GOOD_PRICE] = "GoodsPrice2",
    [GOOD_DISCOUNT] = "GoodDiscount2",
    [EDT_NUMBER_BUY] = "EdtNumberBuy2",
    [BUTTON_ADD] = "BtnAdd2",
    [BUTTON_SUB] = "BtnSub2",
    [TXT_TOTAL_PRICE] = "TxtTotalPrice2",
    [BUTTON_CHECK] = "BtnCheck2",
    [BUTTON_DELETE] = "BtnBuy2",
    [OBJ_SHOW] = "ImgGoodShow2",
  },
  [3] = {
    [MAIN_PAGE_SET] = "LstGoodsShow3",
    [TXT_GOOD_NAME] = "GoodNames3",
    [GOOD_PRICE] = "GoodsPrice3",
    [GOOD_DISCOUNT] = "GoodDiscount3",
    [EDT_NUMBER_BUY] = "EdtNumberBuy3",
    [BUTTON_ADD] = "BtnAdd3",
    [BUTTON_SUB] = "BtnSub3",
    [TXT_TOTAL_PRICE] = "TxtTotalPrice3",
    [BUTTON_CHECK] = "BtnCheck3",
    [BUTTON_DELETE] = "BtnBuy3",
    [OBJ_SHOW] = "ImgGoodShow3",
  },
  [4] = {
    [MAIN_PAGE_SET] = "LstGoodsShow4",
    [TXT_GOOD_NAME] = "GoodNames4",
    [GOOD_PRICE] = "GoodsPrice4",
    [GOOD_DISCOUNT] = "GoodDiscount4",
    [EDT_NUMBER_BUY] = "EdtNumberBuy4",
    [BUTTON_ADD] = "BtnAdd4",
    [BUTTON_SUB] = "BtnSub4",
    [TXT_TOTAL_PRICE] = "TxtTotalPrice4",
    [BUTTON_CHECK] = "BtnCheck4",
    [BUTTON_DELETE] = "BtnBuy4",
    [OBJ_SHOW] = "ImgGoodShow4",
  },
  [5] = {
    [MAIN_PAGE_SET] = "LstGoodsShow5",
    [TXT_GOOD_NAME] = "GoodNames5",
    [GOOD_PRICE] = "GoodsPrice5",
    [GOOD_DISCOUNT] = "GoodDiscount5",
    [EDT_NUMBER_BUY] = "EdtNumberBuy5",
    [BUTTON_ADD] = "BtnAdd5",
    [BUTTON_SUB] = "BtnSub5",
    [TXT_TOTAL_PRICE] = "TxtTotalPrice5",
    [BUTTON_CHECK] = "BtnCheck5",
    [BUTTON_DELETE] = "BtnBuy5",
    [OBJ_SHOW] = "ImgGoodShow5",
  },
}

local TXT_INFOR = {
  [TXT_COUNT] = "TxtLstCount", --选中情况
  [TXT_NEED] = "TxtLstNeed", --打折前的总数
  [TXT_SAVED] = "TxtLstSaved", --节省的总数
  [TXT_CONSUME] = "TxtLstConsume", --实际需要的总数
  [TXT_LEFT_GOLD] = "TxtLstFifthGold", --持有金币数
  [TXT_BIND_GOLD] = "TxtLstFifthBindGold", --持有绑金数
  [TXT_LEFT_QIANZHUANGGOLD] = "TxtLstSixthSilver", --持有钱庄金币数
  [TXT_LAST_INFOR] = "TxtLstLastInfo", --错误信息提示文本框
  [TXT_LEFT_INTEGRAL] = "TxtLstFifthIntegral", --持有积分数
}

function uiIbShopCart:Init()
  self.nCurrencyNum = 0 --购物车中支付类型数
  self.tbGoodsToShow = {}
  self.nCurrencyType = 0 --当前支付类型（正确的情况下支付类型只有一种）
end

-- 在点击确定支付时候，可能出现的情况，
--	emBUYCOMMITSUCCESS = 0,     // 点击购物车确定支付按钮成功
--	emERRORMSG_HAVECOMMIT,	    // 已经点击过一次支付按钮
--	emERRORMSG_VOUCHERERROR,	// 使用的优惠券有问题
--	emERRORMSG_CURRENCYERROR,   // 多余一种货币在同一购物车中
--	emERRORMSG_SHOPTIMEOUT,		// 购物车中有已经过了销售期的物品，
--	emERRORMSG_DISCOUNTTIMEOUT, // 购物车中有已经超过打折期的物品
uiIbShopCart.tbErrorInfo = {
  [1] = "已经点击过一次支付按钮。",
  [2] = "使用的优惠券有问题 。",
  [3] = "多于一种货币在同一购物车中。",
  [4] = "购物车中有已经过了销售期的物品。",
  [5] = "购物车中有已经超过打折期的物品。",
}

-- 临时做法，记录一个标志，为了防止存放其他地方拿过来的Temp obj放置在本界面的容器中
-- 定义放在界面上原因主要只在本界面上使用，而且能防止每个容器都复制一份的问题
local OBJ_SIGN = "uiIbShopCar"

-- 容器函数重载
local tbCont = { bShowCd = 0, bUse = 0, bLink = 0, nRoom = Item.ROOM_IBSHOPCART }

function tbCont:CheckSwitchItem(pDrop, pPick, nX, nY)
  if not pDrop then --pick item
    return 1
  end
  if pDrop.szClass ~= "coupon" and pDrop.szClass ~= "newcoupon" and pDrop.szClass ~= "voucher" then
    me.Msg("格子中只能放入优惠券！")
    return 0
  end
  local nRes, szMsg = Item:CanCouponUse(pDrop.szClass, pDrop.dwId)
  if nRes == 0 then
    uiIbShopCart:BuyFailuer(szMsg, 0)
    me.Msg(szMsg)
    return 0
  end
  if Ui(Ui.UI_IBSHOPCART).nCurrencyType ~= COINTYPE then --只能在金币区才能放入优惠券
    me.Msg("目前优惠券无法使用！")
    return 0
  end

  return 1
end

--取出优惠券
function tbCont:PickMouse(tbObj, nX, nY)
  if self:CheckSwitch(nil, tbObj, nX, nY) ~= 1 then
    return 0
  end

  if self:IsMappingRoom() == 1 then
    me.SetItem(nil, self.nRoom, nX + self.nOffsetX, nY + self.nOffsetY) -- 映射道具空间，清掉映射
  end

  me.IbCart_DetachVoucher()
  Ui(Ui.UI_IBSHOPCART):UpdatePanel()
  return 1
end

function tbCont:SwitchMouse(tbMouseObj, tbObj, nX, nY)
  local pMouseItem = me.GetItem(tbMouseObj.nRoom, tbMouseObj.nX, tbMouseObj.nY)
  local pItem = me.GetItem(tbObj.nRoom, tbObj.nX, tbObj.nY)
  if (not pMouseItem) or not pItem then
    Ui:Output("[ERR] Object机制内部错误！")
    tbMouse:SetObj(nil)
    return 0
  end

  if self:CheckSwitch(tbMouseObj, tbObj, nX, nY) ~= 1 then
    tbMouse:ResetObj()
    return 0
  end

  if self:IsMappingRoom() ~= 1 then
    -- 如果不是映射道具空间，调用CORE接口请求交换操作
    if me.SwitchItem(tbMouseObj.nRoom, tbMouseObj.nX, tbMouseObj.nY, tbObj.nRoom, tbObj.nX, tbObj.nY) ~= 1 then
      tbMouse:ResetObj() -- 交换失败，立刻把鼠标上的东西弹回
      return 0
    end
  else
    -- 映射道具空间，对空间道具进行处理
    me.SetItem(pMouseItem, self.nRoom, nX + self.nOffsetX, nY + self.nOffsetY) -- 设置道具空间
    tbMouse:SetObj(tbObj) -- 先把容器道具放到鼠标上
    self:SetObj(tbMouseObj, nX, nY) -- 再把鼠标道具放入容器
  end
  me.IbCart_DetachVoucher()
  me.IbCart_AttachVoucher()
  Ui(Ui.UI_IBSHOPCART):UpdatePanel()
  return 1
end

function tbCont:DropMouse(tbMouseObj, nX, nY)
  local pItem = me.GetItem(tbMouseObj.nRoom, tbMouseObj.nX, tbMouseObj.nY)
  if not pItem then
    Ui:Output("[ERR] Object机制内部错误！")
    return 0
  end
  if self:CheckSwitch(tbMouseObj, nil, nX, nY) ~= 1 then
    tbMouse:ResetObj()
    return 0
  end

  if self:IsMappingRoom() ~= 1 then
    -- 如果不是映射道具空间，调用CORE接口请求交换操作
    if me.SwitchItem(tbMouseObj.nRoom, tbMouseObj.nX, tbMouseObj.nY, self.nRoom, nX + self.nOffsetX, nY + self.nOffsetY) ~= 1 then
      -- 交换失败，立刻把鼠标上的东西弹回
      tbMouse:ResetObj()
      return 0
    end
  else
    -- 映射道具空间，对空间道具进行处理
    me.SetItem(pItem, self.nRoom, nX + self.nOffsetX, nY + self.nOffsetY) -- 设置道具空间
    tbMouse:SetObj(nil) -- 先清掉鼠标
    self:SetObj(tbMouseObj, nX, nY) -- 再把鼠标道具放入容器
  end

  me.IbCart_DetachVoucher()
  me.IbCart_AttachVoucher()
  Ui(Ui.UI_IBSHOPCART):UpdatePanel()
  return 1
end

function uiIbShopCart:OnCreate()
  self.tbDiscountCont = tbObject:RegisterContainer(self.UIGROUP, DISCONUT_CARD_CONTAINER, OBJ_CONT_ROW, OBJ_CONT_LINE, tbCont, "itemroom")
end

function uiIbShopCart:OnDestroy()
  tbObject:UnregContainer(self.tbDiscountCont)
end

function uiIbShopCart:OnOpen()
  UiManager:SetUiState(UiManager.UIS_IBSHOP_CART)
  me.IbCart_DetachVoucher()

  if IVER_g_nSdoVersion == 1 then
    QuerySndaCoin()
  end
  if IbShop.bShowInfo == 1 then
    local szMsg = ""
    -- 促销活动时间
    local nNowTime = GetTime()
    local szDate = os.date("%Y%m%d%H%M%S", nNowTime)

    if "20081121000000" <= szDate and szDate <= "20081128000000" then
      local nCount = me.GetPromotionCoin()
      nCount = nCount % 500
      if nCount == 0 then
        szMsg = string.format("金山20周年庆%s消费奖绑金，欲知详情请阅读帮助锦囊（F12）", IVER_g_szCoinName)
      else
        szMsg = string.format("已消费%d当月充值%s，再消费%d当月充值%s可获100绑金奖励", nCount, IVER_g_szCoinName, 500 - nCount, IVER_g_szCoinName)
      end
    end
    self:BuyFailuer(szMsg, 0)
  else
    self:BuyFailuer("购物车已满，请先购买。", 0)
  end
  self.nCurrencyType = -1
  self:UpdatePanel()
  Wnd_SetEnable(self.UIGROUP, DISCONUT_CARD_CONTAINER, 1)
  for i, v in ipairs(self.tbGoodsToShow) do
    Edt_SetTxt(self.UIGROUP, PAGE_SET[i][EDT_NUMBER_BUY], v.nCount)
  end
end

function uiIbShopCart:OnClose()
  self.tbDiscountCont:ClearRoom()
  UiManager:ReleaseUiState(UiManager.UIS_IBSHOP_CART)
  me.IbCart_DetachVoucher()
  IbShop.bShowInfo = 1
end

function uiIbShopCart:OnButtonClick(szWnd, nParam)
  if szWnd == BUTTON_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == BUTTON_QUICKGETGOLD then
    if GblTask:GetUiFunSwitch(Ui.UI_PAYONLINE) == 1 then
      me.CallServerScript({ "ApplyOpenOnlinePay" })
    else
      Ui:GetClass("payonline"):PreOpen()
    end
    return
  elseif szWnd == BUTTON_BACK_MARKET then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == COMMINT_BUY then
    if self.nCurrencyNum > 1 then
      self:BuyFailuer("每次只能购买一种货币类型的物品，请麻烦分次购买。", 0)
      return
    end

    if self.nCurrencyType == -1 then
      return
    end

    local nType = self.nCurrencyType
    --当是绑定金币区的时候，判断支付方式是绑定金币还是钱庄金币
    if self.nCurrencyType == BINDCOINTYPE then
      if Btn_GetCheck(self.UIGROUP, BUTTON_CURRENCY2) == 1 then
        nType = BANKCOINTYPE
      end
    end

    local nRet = me.IbCart_Commit(nType - 1)
    if nRet == 0 then
      return
    end
    self:UpdateInfo()
    return
  elseif szWnd == BUTTON_CURRENCY1 then
    if self.nCurrencyType ~= BANKCOINTYPE then
      Btn_Check(self.UIGROUP, BUTTON_CURRENCY1, 1)
    end

    Btn_Check(self.UIGROUP, BUTTON_CURRENCY2, 0)
    self:UpdateInfo()
    return
  elseif szWnd == BUTTON_CURRENCY2 then
    Btn_Check(self.UIGROUP, BUTTON_CURRENCY1, 0)
    self:UpdateInfo()
    return
  else
    local nNum = 0 --用来临时存储要购买的商品个数
    for i, v in ipairs(self.tbGoodsToShow) do
      if szWnd == PAGE_SET[i][BUTTON_ADD] then
        nNum = v.nCount + 1
        nNum = nNum >= MAX_NUMBER and MAX_NUMBER or nNum
        me.IbCart_SetWareCount(v.nWareID, nNum)
        Edt_SetTxt(self.UIGROUP, PAGE_SET[i][EDT_NUMBER_BUY], nNum)
      elseif szWnd == PAGE_SET[i][BUTTON_SUB] then
        nNum = v.nCount - 1
        nNum = nNum < 0 and 0 or nNum
        me.IbCart_SetWareCount(v.nWareID, nNum)
        Edt_SetTxt(self.UIGROUP, PAGE_SET[i][EDT_NUMBER_BUY], nNum)
      elseif szWnd == PAGE_SET[i][BUTTON_DELETE] then
        me.IbCart_DelWare(v.nWareID)
      elseif szWnd == PAGE_SET[i][BUTTON_CHECK] then
        local bSelected = Btn_GetCheck(self.UIGROUP, PAGE_SET[i][BUTTON_CHECK])
        if bSelected > 0 then
          me.IbCart_SelectWare(v.nWareID, 1)
        else
          me.IbCart_SelectWare(v.nWareID, 0)
        end
      end
    end
  end

  self:UpdatePanel()
end

function uiIbShopCart:UpdatePanel()
  self:UpdateGoods()
  self:UpdateInfo()
end

--消费面板区的消费信息显示和选择支付方式面板下的支付方式按钮绘制
function uiIbShopCart:UpdateInfo()
  local nNum = 0
  for _, v in ipairs(self.tbGoodsToShow) do
    if v.bSelected == 1 then
      nNum = nNum + 1
    end
  end
  local szSaveGold = ""
  local szSaveSilve = ""
  Txt_SetTxt(self.UIGROUP, TXT_INFOR[TXT_COUNT], "总共：" .. #self.tbGoodsToShow .. "个，选中：" .. nNum .. "个")

  --tbAmout =
  --{
  --	[1] = 金币总额,
  --	[2] = 银两总额,
  --	[3] = 绑定金币数，
  --	[4] = 钱庄金币数，	--目前在存储的时候是将钱庄金币当做绑定金币来存的，只是在扣除的时候才判定到底是钱庄金币还是绑定金币?
  --	[5] = 使用的货币种类数，
  --}  by dengyong  09-10-16
  local tbAmount = me.IbCart_GetAmount()
  if tbAmount[#tbAmount] > 1 then
    me.Msg("您的购物车中有多于一种的货币购买物，请每次只用一种货币购买物品！")
    self.nCurrencyNum = tbAmount[#tbAmount]
    return
  end

  --这里没有做除金币、绑金（钱庄金币）外的其它币种类型的判定，这是因为币种类型是由脚本传给程序再传回脚本的。
  --只有金币和绑金两种类型
  local nAmount = tbAmount[1] ~= 0 and tbAmount[1] or (tbAmount[3] ~= 0 and tbAmount[3]) or tbAmount[4]
  local szType = tbAmount[1] ~= 0 and IVER_g_szCoinName or (tbAmount[3] ~= 0 and IVER_g_szBindCoinName) or "消耗积分"

  --tbSaveMoney的格式与tbAmount类似，不过它只存tbAmount的前4个类型，而且表示的是节省量
  local tbSaveMoney = me.IbCart_GetDiscountAmount()
  local nSaved = szType == IVER_g_szCoinName and tbSaveMoney[1] or (szType == "消耗积分" and tbSaveMoney[3]) or tbSaveMoney[4]

  --当是绑定金币区的时候，判断支付方式是绑定金币还是钱庄金币
  if szType == "绑定金币" then
    if IVER_g_nSdoVersion == 1 then
      szType = "绑定点券"
    end
    if Btn_GetCheck(self.UIGROUP, BUTTON_CURRENCY2) == 1 then
      szType = "钱庄金币"
    end
  end

  local nCoin = me.nCoin
  if IVER_g_nSdoVersion == 1 then
    nCoin = GetSndaCoin()
  end
  local nFullAmout = nAmount + nSaved
  if UiVersion == Ui.Version001 then
    Txt_SetTxt(self.UIGROUP, TXT_INFOR[TXT_NEED], "本次消费：" .. nFullAmout .. szType)
    Txt_SetTxt(self.UIGROUP, TXT_INFOR[TXT_SAVED], "优惠券节省：" .. nSaved .. szType)
    Txt_SetTxt(self.UIGROUP, TXT_INFOR[TXT_CONSUME], "您共支付：" .. nAmount .. szType)
  else
    Txt_SetTxt(self.UIGROUP, TXT_INFOR[TXT_NEED], "本次消费：" .. nFullAmout)
    Txt_SetTxt(self.UIGROUP, TXT_INFOR[TXT_SAVED], "优惠券节省：" .. nSaved)
    Txt_SetTxt(self.UIGROUP, TXT_INFOR[TXT_CONSUME], "您共支付：" .. nAmount)
  end
  local szInfo = ""
  Wnd_Show(self.UIGROUP, BUTTON_CURRENCY1)
  --几种不同支付方式选项
  if self.nCurrencyType == COINTYPE then --金币区
    szInfo = string.format("%s（剩余：%d）", IVER_g_szCoinName, nCoin)
    Wnd_Hide(self.UIGROUP, BUTTON_CURRENCY2)
    Btn_SetTxt(self.UIGROUP, BUTTON_CURRENCY1, szInfo)
    Btn_Check(self.UIGROUP, BUTTON_CURRENCY1, 1)
  elseif self.nCurrencyType == BINDCOINTYPE then --绑定金币区
    szInfo = string.format("绑定%s（剩余：%d）", IVER_g_szCoinName, me.nBindCoin)
    Btn_SetTxt(self.UIGROUP, BUTTON_CURRENCY1, szInfo)
    Btn_Check(self.UIGROUP, BUTTON_CURRENCY1, 1)
    Wnd_Hide(self.UIGROUP, BUTTON_CURRENCY2)
  elseif self.nCurrencyType == INTEGRALCOINTYPE then --积分区
    szInfo = string.format("积分（剩余：%d）", me.GetTask(2070, 6))
    Wnd_Hide(self.UIGROUP, BUTTON_CURRENCY2)
    Btn_SetTxt(self.UIGROUP, BUTTON_CURRENCY1, szInfo)
    Btn_Check(self.UIGROUP, BUTTON_CURRENCY1, 1)
  else
    Wnd_Hide(self.UIGROUP, BUTTON_CURRENCY1)
    Wnd_Hide(self.UIGROUP, BUTTON_CURRENCY2)
  end

  Txt_SetTxt(self.UIGROUP, TXT_INFOR[TXT_LEFT_GOLD], IVER_g_szCoinName .. "：" .. nCoin)
  Txt_SetTxt(self.UIGROUP, TXT_INFOR[TXT_BIND_GOLD], string.format("%s：%s", IVER_g_szBindCoinName, me.nBindCoin))
  if IVER_g_nSdoVersion == 0 then
    Txt_SetTxt(self.UIGROUP, TXT_INFOR[TXT_LEFT_QIANZHUANGGOLD], "消耗积分：" .. me.GetTask(2070, 6))
  end
end

--商品面板区的商品信息显示（一类商品一个子面板，最多五个）
function uiIbShopCart:UpdateGoods()
  self.tbGoodsToShow = {}
  self.tbGoodsToShow = me.IbCart_GetWareList()
  for i, v in ipairs(self.tbGoodsToShow) do
    local tbInfo = me.IbShop_GetWareInf(v.nWareID)
    local pItem = KItem.CreateTempItem(tbInfo.nGenre, tbInfo.nDetailType, tbInfo.nParticular, tbInfo.nLevel, tbInfo.nSeries)
    if not pItem then
      return
    end
    local tbTemp = pItem.GetTempTable("IbShop")
    tbTemp[pItem.nIndex] = v.nWareID
    pItem.SetTimeOut(tbInfo.nTimeoutType, tbInfo.nTimeout)
    Txt_SetTxt(self.UIGROUP, PAGE_SET[i][TXT_GOOD_NAME], pItem.szName)

    -- nCurrencyType 为1表示金币，2表示银两
    local szMoney = ""
    local szAmount = ""
    self.nCurrencyType = v.nCurrencyType

    if v.nCurrencyType == SILVERTYPE then
      szMoney = "<color=white>" .. tbInfo.nOrgPrice .. "<color>"
      szAmount = "<color=white>" .. v.nAmount .. "<color>"
    elseif v.nCurrencyType == COINTYPE then
      szMoney = "<color=orange>" .. tbInfo.nOrgPrice .. "<color>"
      szAmount = "<color=orange>" .. v.nAmount .. "<color>"
    else
      szMoney = "<color=yellow>" .. tbInfo.nOrgPrice .. "<color>"
      szAmount = "<color=yellow>" .. v.nAmount .. "<color>"
    end

    Txt_SetTxt(self.UIGROUP, PAGE_SET[i][GOOD_PRICE], szMoney)
    Txt_SetTxt(self.UIGROUP, PAGE_SET[i][TXT_TOTAL_PRICE], szAmount)

    local szDiscount = v.nCount * tbInfo.nOrgPrice - v.nAmount
    szDiscount = szDiscount < 0 and 0 or szDiscount

    Txt_SetTxt(self.UIGROUP, PAGE_SET[i][GOOD_DISCOUNT], szDiscount)

    Edt_SetTxt(self.UIGROUP, PAGE_SET[i][EDT_NUMBER_BUY], v.nCount)

    ObjMx_AddObject(self.UIGROUP, PAGE_SET[i][OBJ_SHOW], Ui.CGOG_ITEM, pItem.nIndex, 0, 0)

    if v.bSelected == 1 then
      Btn_Check(self.UIGROUP, PAGE_SET[i][BUTTON_CHECK], 1)
    else
      Btn_Check(self.UIGROUP, PAGE_SET[i][BUTTON_CHECK], 0)
    end
    Wnd_Show(self.UIGROUP, PAGE_SET[i][MAIN_PAGE_SET])
  end
  for i = #self.tbGoodsToShow + 1, 5 do
    Wnd_Hide(self.UIGROUP, PAGE_SET[i][MAIN_PAGE_SET])
  end
end

function uiIbShopCart:UpdateCashMoney()
  if IVER_g_nSdoVersion == 0 then
    Txt_SetTxt(self.UIGROUP, TXT_INFOR[TXT_LEFT_QIANZHUANGGOLD], "消耗积分：" .. me.GetTask(2070, 6))
  end
end

function uiIbShopCart:UpdateCoin()
  if IVER_g_nSdoVersion == 1 then
    Txt_SetTxt(self.UIGROUP, TXT_INFOR[TXT_LEFT_GOLD], "点券：" .. GetSndaCoin())
  else
    Txt_SetTxt(self.UIGROUP, TXT_INFOR[TXT_LEFT_GOLD], "金币：" .. me.nCoin)
  end
end

--当直接修改数量的时候进入到这里（不通过用加、减按钮修改数量时）
function uiIbShopCart:OnEditChange(szWndName, nParam)
  for i, v in ipairs(self.tbGoodsToShow) do
    if szWndName == PAGE_SET[i][EDT_NUMBER_BUY] then
      local nNum = Edt_GetInt(self.UIGROUP, PAGE_SET[i][EDT_NUMBER_BUY])
      if v.nCount == nNum then
        return
      elseif nNum < 0 then
        nNum = 0
      elseif nNum > MAX_NUMBER then
        nNum = MAX_NUMBER
      end
      me.IbCart_SetWareCount(v.nWareID, nNum)
    end
  end
  self:UpdatePanel()
end

--显示物品的TIP面板，现在没有用到？
function uiIbShopCart:OnObjHover(szWnd, uGenre, uId, nX, nY)
  self:ViewItem(szWnd, KItem.GetItemObj(uId))
end

function uiIbShopCart:ViewItem(szWnd, pItem)
  local nTipType = Item.TIPS_NORMAL
  if self.nCurrencyType and self.nCurrencyType == 3 then
    nTipType = Item.TIPS_BINDGOLD_SECTION
  elseif self.nCurrencyType and self.nCurrencyType == 4 then
    nTipType = Item.TIPS_INTEGRAL_SECTION
  else
    nTipType = Item.TIPS_NOBIND_SECTION
  end
  if pItem then
    Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, pItem.GetCompareTip(nTipType))
  end
end

function uiIbShopCart:BuyFailuer(szMsg, nErronNo)
  if nErronNo then
    if szMsg == "" then
      szMsg = self.tbErrorInfo[nErronNo] or ""
    else
      szMsg = "<color=red>" .. szMsg .. "<color>"
    end
  else
    szMsg = "<color=red>" .. szMsg .. "<color>"
    Img_PlayAnimation(self.UIGROUP, BUTTON_QUICKGETGOLD, 1, 72) -- 动画
    Ui.tbLogic.tbTimer:Register(1 * 18, self.StopAnimation, self)
  end
  Txt_SetTxt(Ui.UI_IBSHOPCART, TXT_INFOR[TXT_LAST_INFOR], szMsg)
end

function uiIbShopCart:StopAnimation()
  Img_StopAnimation(self.UIGROUP, BUTTON_QUICKGETGOLD)
  return 0
end

function uiIbShopCart:BuySuccess()
  --ObjMx_Clear(self.UIGROUP, OBJ_ONE_CARD);
  me.IbShop_Close()
  UiManager:OpenWindow(Ui.UI_ITEMBOX)
  UiManager:CloseWindow(self.UIGROUP)
  UiManager:CloseWindow(Ui.UI_IBSHOP)
  UiManager:OpenWindow(Ui.UI_IBSHOP)
end
--zjq add 09.2.23	处理服务器发下来的付费URL地址，盛大模式用
function uiIbShopCart:OnGetPayUrl(szUrl)
  --ObjMx_Clear(self.UIGROUP, OBJ_ONE_CARD);
  UiManager:CloseWindow(Ui.UI_IBSHOP)
  UiManager:OpenWindow(Ui.UI_ITEMBOX)
  UiManager:CloseWindow(self.UIGROUP)
  OpenPayUrl(szUrl)
end
--end add

function uiIbShopCart:RegisterEvent()
  local tbRegEvent = {
    --{ UiNotify.emCOREEVENT_SYNC_ITEM,			self.RefreshItem },
    { UiNotify.emCOREEVENT_IBSHOP_BUYFAILURE, self.BuyFailuer },
    { UiNotify.emCOREEVENT_IBSHOP_BUYSUCCESS, self.BuySuccess },
    { UiNotify.emCOREEVENT_JBCOIN_CHANGED, self.UpdateCoin }, --maiyajin:刷新金币
    { UiNotify.emCOREEVENT_MONEY_CHANGED, self.UpdateCashMoney },
  }
  if IVER_g_nSdoVersion == 1 then
    table.insert(tbRegEvent, { UiNotify.emCOREEVENT_IBSHOP_PAYURL, self.OnGetPayUrl })
  end
  tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbDiscountCont:RegisterEvent())
  return tbRegEvent
end

function uiIbShopCart:RegisterMessage()
  local tbRegMsg = self.tbDiscountCont:RegisterMessage()
  return tbRegMsg
end
