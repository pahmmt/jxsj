-----------------------------------------------------
--文件名		：	jbexchange.lua
--创建者		：	zouying@kingsoft.net
--创建时间		：	2008-03-10
--功能描述		：	金币交易所。
------------------------------------------------------

local uiJbExchange = Ui:GetClass("jbexchange")
local tbTimer = Ui.tbLogic.tbTimer

uiJbExchange.BTNCLOSE = "BtnClose"
uiJbExchange.BTNBUY = "BtnBuy"
uiJbExchange.BTNSELL = "BtnSell"
uiJbExchange.BTNCANCELBILL = "CancelBill"
uiJbExchange.BTNGETMONEY = "GetMoney"
uiJbExchange.TXT_MYBILL = "Txt_MyBill"
uiJbExchange.TXT_TAX = "Txt_Tax"
uiJbExchange.TXT_PRODICT = "Txt_Product"
uiJbExchange.TXT_RECLAIM = "Txt_Reclaim"
uiJbExchange.TXT_COINCOUNT = "Txt_CoinCount"
uiJbExchange.TXT_CASHMONEY = "Txt_CashMoney"
uiJbExchange.TXT_MYBILLCONTENT = "Txt_MyBillContent"
uiJbExchange.TXT_CREATETIME = "Txt_CreateTime"

uiJbExchange.BUY_LIST = "LstBuy"
uiJbExchange.SELL_LST = "LstSell"
uiJbExchange.MYBILL_LST = "LstMyBill"

uiJbExchange.BUY_TYPE = 1
uiJbExchange.SELL_TYPE = 0
uiJbExchange.REFRESHTIME = Env.GAME_FPS * 2 -- 定时刷新 1秒钟
uiJbExchange.SHOWNUMBER = 5

function uiJbExchange:Init()
  self.nCashMoney = 0
  self.nTimerId = 0
end

function uiJbExchange:OnOpen()
  if JbExchange.IsClose == 1 then
    Txt_SetTxt(self.UIGROUP, self.TXT_CREATETIME, "现在为休市时间！")
    return
  end
  me.CallServerScript({ "JbExchangeCmd", "ApplyBillList" })
  me.CallServerScript({ "JbExchangeCmd", "ApplyPlayerBillInfo" })
  self:TimerRegister()
  Log:Ui_SendLog("点击交易所", 1)
end

function uiJbExchange:OnClose()
  if self.nTimerId and (self.nTimerId ~= 0) then
    tbTimer:Close(self.nTimerId)
  end
  Ui(Ui.UI_IBSHOP):WndOpenCloseCallback(self.UIGROUP, 0)

  UiNotify:OnNotify(UiNotify.emUIEVENT_IBSHOP_SWITCH_BUTTON)
end

function uiJbExchange:OnTimer()
  me.CallServerScript({ "JbExchangeCmd", "ApplyBillList" })
  me.CallServerScript({ "JbExchangeCmd", "ApplyPlayerBillInfo" })
end

function uiJbExchange:TimerRegister()
  self.nTimerId = tbTimer:Register(self.REFRESHTIME, self.OnTimer, self)
end

function uiJbExchange:OnUpdatePlayerInfo()
  if JbExchange.IsClose == 1 then
    Lst_Clear(self.UIGROUP, self.MYBILL_LST)

    if self.nTimerId and self.nTimerId ~= 0 then
      tbTimer:Close(self.nTimerId)
    end

    return
  end
  local tbMyData = me.GetPlayerBillInfo()

  if tbMyData == nil then
    return
  end
  local szCoinCount = "金币：" .. Item:FormatMoney(tbMyData.nCoinCount)
  Txt_SetTxt(self.UIGROUP, self.TXT_COINCOUNT, szCoinCount)
  self.nCashMoney = tbMyData.nCashMoney
  local szCashMoney = "银两：" .. Item:FormatMoney(tbMyData.nCashMoney)
  Txt_SetTxt(self.UIGROUP, self.TXT_CASHMONEY, szCashMoney)

  local szTime = "我的交易单"
  if tbMyData.nIndex == 0 then
    Txt_SetTxt(self.UIGROUP, self.TXT_CREATETIME, "您没有交易单")
    Lst_Clear(self.UIGROUP, self.MYBILL_LST)
    Txt_SetTxt(self.UIGROUP, self.TXT_MYBILL, szTime)
    return
  end

  szTime = szTime .. "    挂单时间：" .. os.date("%Y-%m-%d %H:%M", tbMyData.tTime)
  Txt_SetTxt(self.UIGROUP, self.TXT_MYBILL, szTime)

  Lst_SetCell(self.UIGROUP, self.MYBILL_LST, 1, 0, tbMyData.nPrice)
  Lst_SetCell(self.UIGROUP, self.MYBILL_LST, 1, 1, tbMyData.nCount)

  local szData = Item:FormatMoney(tbMyData.nTotalMoney)

  if szData then
    Lst_SetCell(self.UIGROUP, self.MYBILL_LST, 1, 2, szData)
  end
  local szType = ""
  if tbMyData.btType == self.BUY_TYPE then
    szType = "买入金币"
  elseif tbMyData.btType == self.SELL_TYPE then
    szType = "卖出金币"
  end
  Lst_SetCell(self.UIGROUP, self.MYBILL_LST, 1, 3, szType)
end

function uiJbExchange:ShowExchangeInfo()
  local tbInfo = me.GetExchangeInfo()
  local szMsgTax = string.format("金币交易手续费：%d", tbInfo.nTax) .. "% (仅卖出金币收取)"
  local szMsgProduct = string.format("本周产出物价：%d", tbInfo.nProduct) .. "%"
  local szMsgReclaim = string.format("本周回收物价：%d", tbInfo.nReclaim) .. "%"
  Txt_SetTxt(self.UIGROUP, self.TXT_TAX, szMsgTax)
  Txt_SetTxt(self.UIGROUP, self.TXT_PRODICT, szMsgProduct)
  Txt_SetTxt(self.UIGROUP, self.TXT_RECLAIM, szMsgReclaim)
end

function uiJbExchange:OnUpdateShowList()
  Lst_Clear(self.UIGROUP, self.BUY_LIST)
  Lst_Clear(self.UIGROUP, self.SELL_LST)

  if JbExchange.IsClose == 1 then
    if self.nTimerId and self.nTimerId ~= 0 then
      tbTimer:Close(self.nTimerId)
    end
    return
  end

  local tbData = me.GetShowBillList()
  if tbData == nil then
    return
  end
  local nBuy = 0
  local nSell = 0
  local tbSellList = {}

  for i, tbCell in ipairs(tbData) do
    if tbCell.btType == 1 and nBuy < self.SHOWNUMBER then
      nBuy = nBuy + 1
      self:LstAddLine(self.BUY_LIST, nBuy, tbCell.nPrice, tbCell.nCount)
    elseif tbCell.btType == 0 then
      table.insert(tbSellList, 1, tbCell)
    else
      assert(false)
    end
  end

  nSell = 0
  for i, tbCell in ipairs(tbSellList) do
    if nSell < self.SHOWNUMBER then
      nSell = nSell + 1
      self:LstAddLine(self.SELL_LST, nSell, tbCell.nPrice, tbCell.nCount)
    end
  end
  self:ShowExchangeInfo()
end

function uiJbExchange:LstAddLine(szWnd, nIndex, nPrice, nCount)
  Lst_SetCell(self.UIGROUP, szWnd, nIndex, 0, nPrice)
  Lst_SetCell(self.UIGROUP, szWnd, nIndex, 1, nCount)
end

function uiJbExchange:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTNCLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTNBUY then
    UiManager:OpenWindow(Ui.UI_JBMARKPRICE, 1)
  elseif szWnd == self.BTNSELL then
    UiManager:OpenWindow(Ui.UI_JBMARKPRICE, 0)
  elseif szWnd == self.BTNCANCELBILL then
    self:CancelBill()
  elseif szWnd == self.BTNGETMONEY then
    local tbParam = {}
    tbParam.tbTable = self
    tbParam.fnAccept = self.TakeMoneyAccept
    tbParam.szTitle = "取出银两"
    tbParam.varDefault = 0
    tbParam.nType = 0
    tbParam.tbRange = { 0, self.nCashMoney }
    UiManager:OpenWindow(Ui.UI_TEXTINPUT, tbParam)
  end
end

function uiJbExchange:TakeMoneyAccept(szText)
  local nMoney = tonumber(szText)
  if (not nMoney) or (nMoney <= 0) then
    return
  end
  if nMoney <= 0 or nMoney > self.nCashMoney then
    local szMsg = "<color=red>您输入的银两数不对，请重新输入！<color>"
    UiManager:OpenWindow(Ui.UI_INFOBOARD, szMsg)
    return
  end
  if nMoney + me.nCashMoney > 2000000000 then
    local szMsg = "<color=red>银两数超过背包上限，取钱失败！<color>"
    UiManager:OpenWindow(Ui.UI_INFOBOARD, szMsg)
    return
  end
  local bRet = me.CallServerScript({ "JbExchangeCmd", "ApplyGetCashMoney", nMoney })
  if bRet == nil then
    local szMsg = "<color=red>获取失败！<color>"
    UiManager:OpenWindow(Ui.UI_INFOBOARD, szMsg)
  end
  me.CallServerScript({ "JbExchangeCmd", "ApplyPlayerBillInfo" })
end

-- 撤销交易单
function uiJbExchange:CancelBill()
  local tbBill = me.GetPlayerBillInfo()
  if (tbBill == nil) or (tbBill and tbBill.nIndex == 0) then
    local szMsg = "<color=red>您没有交易单。<color>"
    UiManager:OpenWindow(Ui.UI_INFOBOARD, szMsg)
    return
  end
  me.CallServerScript({ "JbExchangeCmd", "ApplyCancelBill", tbBill.nIndex, tbBill.btType })
end

function uiJbExchange:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_UPDATE_PLAYERBILLINFO, self.OnUpdatePlayerInfo },
    { UiNotify.emCOREEVENT_UPDATE_SHOWBILLLIST, self.OnUpdateShowList },
  }
  return tbRegEvent
end
