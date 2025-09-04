-----------------------------------------------------
--文件名		：	trade.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-02-09
--功能描述		：	交易面板。
------------------------------------------------------

local uiTrade = Ui:GetClass("trade")
local tbObject = Ui.tbLogic.tbObject
local tbMouse = Ui.tbLogic.tbMouse
local tbTimer = Ui.tbLogic.tbTimer
local tbSaveData = Ui.tbLogic.tbSaveData
local tbMsgInfo = Ui.tbLogic.tbMsgInfo
local tbConfirm = Ui.tbLogic.tbConfirm

uiTrade.OBJ_TRADE = "ObjTrade"
uiTrade.SELF_MONEY_EDIT = "EditSelfSilver"
uiTrade.OTHER_CONTAINER = "ObjPlayerTradeArea"
uiTrade.OTHER_MONEY_TEXT = "TxtPlayerSilverNum"
uiTrade.LOCK_TRADE_BUTTON = "BtnLockTrade" -- 锁定交易按钮
uiTrade.AFFIRM_TRADE_BUTTON = "BtnAffirmTrade" -- 确认交易按钮
uiTrade.CANCEL_TRADE_BUTTON = "BtnCancelTrade" -- 取消交易按钮
uiTrade.TRADE_HISTORY_LIST = "LstTradeHistory" -- 显示交易历史的列表
uiTrade.CHECK_CODE_TEXT = "TxtCheckCode" -- 显示验证码
uiTrade.OTHER_PLAYER_INFO_TEXT = "TxtPlayerInfo" -- 显示对方的信息
uiTrade.TRADE_STATE_TEXT = "TxtTradeState" -- 显示交易的当前状态
uiTrade.TXT_TITLE = "TxtWindowTitle"
uiTrade.HISTORY_SCORLLBAR = "ScrbarHistory"
uiTrade.CLOSE_BUTTON = "BtnClose"
uiTrade.TXT_OTHER_COIN = "TxtPlayerOtherCoin"
uiTrade.EDIT_COIN = "EditSelfCoin"

uiTrade.TRADE_HISTORY_DIR = "user\\history\\trade\\"
uiTrade.MAX_TRADE_HISTORY_COUNT = 5 -- 交易历史最大数目
uiTrade.TRADE_FREEZE_TIME = 6 -- 交易冷却6秒

uiTrade.DATA_KEY = "TradeHistory"

local tbTradeCont = { bUse = 0, bLink = 0, nRoom = Item.ROOM_TRADE, bSendToGift = 1 } -- 不可使用，不可链接
local tbShowCont = { bShowCd = 0, bUse = 0, bLink = 0, bSwitch = 0 }

function tbTradeCont:CheckSwitchItem(pDrop, pPick, nX, nY)
  if not pDrop then
    return 1
  end
  if pDrop.IsForbitTrade() == 1 then
    me.Msg("该物品不能交易！")
    tbMouse:ResetObj()
    return 0
  end
  return 1
end

function tbShowCont:CheckSwitchItem(pDrop, pPick, nX, nY)
  return 0 -- 永远不允许拿起
end

function uiTrade:Init()
  self.szPlayerName = ""
  self.tbTradeHistory = {}
  self.tbDataList = {}
  self.nTradeMoney = 0
  self.nTradeCoin = 0
  self.nSelfLockState = 0
  self.nOtherLockState = 0
  self.nSelfConfirmState = 0
  self.nOtherConfirmState = 0
  self.nFreezeTime = 0
  self.nTimerId = 0
  self.nLockCoin = 0
end

function uiTrade:OnCreate()
  self.tbTradeCont = tbObject:RegisterContainer(self.UIGROUP, self.OBJ_TRADE, Item.ROOM_TRADE_WIDTH, Item.ROOM_TRADE_HEIGHT, tbTradeCont, "itemroom")
  self.tbShowItemCont = tbObject:RegisterContainer(self.UIGROUP, self.OTHER_CONTAINER, Item.ROOM_TRADE_WIDTH, Item.ROOM_TRADE_HEIGHT, tbShowCont)
end

function uiTrade:OnDestroy()
  tbObject:UnregContainer(self.tbTradeCont)
  tbObject:UnregContainer(self.tbShowItemCont)
end

--写log
function uiTrade:WriteStatLog()
  Log:Ui_SendLog("交易", 1)
end

function uiTrade:OnOpen()
  self:WriteStatLog()
  self:UpdateTradeState()
  self.nFreezeTime = self.TRADE_FREEZE_TIME
  UiManager:SetUiState(UiManager.UIS_TRADE_PLAYER)
  UiManager:OpenWindow(Ui.UI_ITEMBOX)
  if KGblTask.SCGetDbTaskInt(DBTASK_OPEN_COIN_TRADE) ~= 1 then
    Wnd_SetVisible("UI_TRADE", "TxtPlayerOtherCoinNum", 0)
    Wnd_SetVisible("UI_TRADE", "EditSelfCoin", 0)
    Wnd_SetVisible(self.UIGROUP, self.TXT_OTHER_COIN, 0)
  end
end

function uiTrade:OnClose()
  self.tbTradeCont:ClearRoom()
  self.tbShowItemCont:ClearObj()
  me.TradeEnd()
  UiManager:ReleaseUiState(UiManager.UIS_TRADE_PLAYER)
  tbSaveData:Save(self.DATA_KEY, self.tbTradeHistory)
  if self.nTimerId ~= 0 then
    tbTimer:Close(self.nTimerId) -- 关闭计时器
    self.nTimerId = 0
  end
end

function uiTrade:OnButtonClick(szWndName, nParam)
  if (szWndName == self.CANCEL_TRADE_BUTTON) or (szWndName == self.CLOSE_BUTTON) then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWndName == self.LOCK_TRADE_BUTTON then
    if self.nTradeCoin == 0 then
      self:ApplyLock()
    else
      if self:CheckLockCondition() == 1 then
        local theSelf = self
        local szMsg = string.format("您将要交易<color=yellow>%s金币<color>给对方。", Item:FormatMoney(self.nTradeCoin))
        local tbMsg = {}
        tbMsg.szMsg = szMsg
        tbMsg.nOptCount = 2
        tbMsg.tbOptTitle = { "取消", "确定" }
        function tbMsg:Callback(nOptIndex, nAttriId)
          if nOptIndex == 2 then
            theSelf:ApplyLock()
          end
        end
        UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
      end
    end
  elseif szWndName == self.AFFIRM_TRADE_BUTTON then
    self.nSelfConfirmState = 1
    Wnd_SetEnable(self.UIGROUP, self.AFFIRM_TRADE_BUTTON, 0)
    if not self.nLockMoney then
      self.nLockMoney = 2000000000
    end
    me.TradeConfirm(self.nLockMoney, self.nLockCoin)
  end
  self:UpdateTradeState()
end

function uiTrade:CheckLockCondition()
  local nRet = 0
  local nCoinTradeLimit = KGblTask.SCGetDbTaskInt(DBTASK_COIN_TRADE_LIMIT)
  if nCoinTradeLimit == 0 then
    nCoinTradeLimit = 0x64
  end
  if self.nLockCoin > 0 and self.nTradeCoin > 0 then
    UiManager:OpenWindow(Ui.UI_INFOBOARD, "双方不能同时交易金币！")
    me.Msg("双方不能同时交易金币！")
  elseif self.nLockCoin + self.nTradeCoin > 0 and self.nLockCoin + self.nTradeCoin < nCoinTradeLimit then
    UiManager:OpenWindow(Ui.UI_INFOBOARD, "金币最低交易额为" .. nCoinTradeLimit)
    me.Msg("金币最低交易额为" .. nCoinTradeLimit)
  elseif KGblTask.SCGetDbTaskInt(DBTASK_OPEN_COIN_TRADE) ~= 1 and self.nTradeCoin > 0 then
    UiManager:OpenWindow(Ui.UI_INFOBOARD, "金币交易功能关闭中！")
    me.Msg("金币交易功能关闭中！")
  else
    nRet = 1
  end
  return nRet
end

function uiTrade:ApplyLock()
  if self:CheckLockCondition() == 1 then
    self.nSelfLockState = 1
    me.TradeLock(self.nTradeMoney, self.nTradeCoin)
  end
  self:UpdateTradeState()
end

function uiTrade:OnEditChange(szWndName, nParam)
  if szWndName == self.SELF_MONEY_EDIT then
    local szFormatMoney = Edt_GetTxt(self.UIGROUP, self.SELF_MONEY_EDIT)
    local _, _, szSilver = string.find(szFormatMoney, "([%d,]*)两")
    if szSilver then
      -- 若编辑框显示的银两数已经是格式化后的，则不作后续处理了
      return
    end

    local nMoney = Edt_GetInt(self.UIGROUP, self.SELF_MONEY_EDIT) -- 防止死循环
    if self.nTradeMoney == nMoney then
      return
    end
    if nMoney > me.nCashMoney then
      nMoney = me.nCashMoney
    end
    self.nTradeMoney = nMoney
    Edt_SetInt(self.UIGROUP, self.SELF_MONEY_EDIT, self.nTradeMoney)
  elseif szWndName == self.EDIT_COIN then
    local szFormatMoney = Edt_GetTxt(self.UIGROUP, self.EDIT_COIN)
    local _, _, szCoin = string.find(szFormatMoney, "([%d,]*)金")
    if szCoin then
      -- 若编辑框显示的金币数已经是格式化后的，则不作后续处理了
      return
    end

    local nCoin = Edt_GetInt(self.UIGROUP, self.EDIT_COIN) -- 防止死循环
    if self.nTradeCoin == nCoin then
      return
    end
    if nCoin > me.nCoin then
      nCoin = me.nCoin
    end
    self.nTradeCoin = nCoin
    Edt_SetInt(self.UIGROUP, self.EDIT_COIN, self.nTradeCoin)
  end
end

function uiTrade:OnObjHover(szWnd, uGenre, uId, nX, nY)
  local tbItem = self:BuildItem(szWnd, uGenre, uId, nX, nY)
  local pItem = me.GetItem(tbItem.nRoom, tbItem.nX, tbItem.nY)
  if not pItem then
    return 0
  end
  Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, pItem.GetCompareTip(Item.TIPS_NORMAL))
end

function uiTrade:BuildItem(szWnd, uGenre, uId, nX, nY)
  local tbItem = {}
  tbItem.uGenre = uGenre
  tbItem.uId = uId
  tbItem.nX = nX
  tbItem.nY = nY
  tbItem.nRoom = Item.ROOM_TRADECLIENT
  return tbItem
end

-- 维护界面上的状态，包括按钮、容器、输入框、提示的显示
function uiTrade:UpdateTradeState()
  if self.nSelfLockState == 0 then
    Txt_SetTxt(self.UIGROUP, self.TRADE_STATE_TEXT, "开始交易")
    Btn_Check(self.UIGROUP, self.LOCK_TRADE_BUTTON, 0)
    Btn_Check(self.UIGROUP, self.AFFIRM_TRADE_BUTTON, 0)
    Wnd_SetEnable(self.UIGROUP, self.LOCK_TRADE_BUTTON, 1)
    Wnd_SetEnable(self.UIGROUP, self.AFFIRM_TRADE_BUTTON, 0)
    Wnd_SetEnable(self.UIGROUP, self.OBJ_TRADE, 1)
    Edt_SetInt(self.UIGROUP, self.SELF_MONEY_EDIT, self.nTradeMoney)
    Edt_SetInt(self.UIGROUP, self.EDIT_COIN, self.nTradeCoin)
    Wnd_SetEnable(self.UIGROUP, self.SELF_MONEY_EDIT, 1)
    Wnd_SetEnable(self.UIGROUP, self.EDIT_COIN, 1)
    Wnd_SetEnable(self.UIGROUP, self.OTHER_MONEY_TEXT, 0)
  else
    Txt_SetTxt(self.UIGROUP, self.TRADE_STATE_TEXT, "等待对方锁定")
    Btn_Check(self.UIGROUP, self.LOCK_TRADE_BUTTON, 1)
    Wnd_SetEnable(self.UIGROUP, self.LOCK_TRADE_BUTTON, 0)
    Wnd_SetEnable(self.UIGROUP, self.OBJ_TRADE, 0)

    -- 格式化显示自己的交易银两
    local szMoney = Item:FormatMoney(self.nTradeMoney) .. "两"
    Edt_SetTxt(self.UIGROUP, self.SELF_MONEY_EDIT, szMoney)
    Wnd_SetEnable(self.UIGROUP, self.SELF_MONEY_EDIT, 0)

    -- 格式化显示自己的交易金币
    local szCoin = Item:FormatMoney(self.nTradeCoin) .. "金"
    Edt_SetTxt(self.UIGROUP, self.EDIT_COIN, szCoin)
    Wnd_SetEnable(self.UIGROUP, self.EDIT_COIN, 0)
  end

  if self.nOtherLockState == 1 then
    Txt_SetTxt(self.UIGROUP, self.TRADE_STATE_TEXT, "对方已经锁定")
  end

  if (self.nSelfLockState == 1) and (self.nOtherLockState == 1) then
    Txt_SetTxt(self.UIGROUP, self.TRADE_STATE_TEXT, "双方都已锁定")
    if (self.nTimerId == 0) and (self.nSelfConfirmState ~= 1) then
      self.nTimerId = tbTimer:Register(18, self.OnTimer, self)
    end
  end

  if self.nOtherConfirmState == 1 then
    Txt_SetTxt(self.UIGROUP, self.TRADE_STATE_TEXT, "对方已经确认")
  end

  if self.nSelfConfirmState == 1 then
    Txt_SetTxt(self.UIGROUP, self.TRADE_STATE_TEXT, "等待交易执行")
  end
end

function uiTrade:OnTimer()
  self.nFreezeTime = self.nFreezeTime - 1
  if self.nFreezeTime > 0 then
    Btn_SetTxt(self.UIGROUP, self.AFFIRM_TRADE_BUTTON, "  确定(" .. self.nFreezeTime .. ")")
  else
    Btn_SetTxt(self.UIGROUP, self.AFFIRM_TRADE_BUTTON, " 确 定")
    Wnd_SetEnable(self.UIGROUP, self.AFFIRM_TRADE_BUTTON, 1) -- 启用确认交易按钮
    tbTimer:Close(self.nTimerId)
    self.nTimerId = 0
  end
end

function uiTrade:AddTradeHistory(szName, szCode)
  if (not szName) or not szCode then
    return
  end
  local tbHistoryItem = {}
  tbHistoryItem.szName = szName
  tbHistoryItem.szCode = szCode
  table.insert(self.tbTradeHistory, 1, tbHistoryItem)
end

function uiTrade:GetTradeHistoryFormatString(szName, szCode)
  if not szName then
    szName = "没有名字"
  end

  if not szCode then
    szCode = "没有验证码"
  end

  local nLength = #szName
  local nMaxLength = 16

  if nLength < nMaxLength then
    szName = szName .. string.rep(" ", nMaxLength - nLength)
  else
    szName = string.sub(szName, 1, nMaxLength)
  end
  return "  " .. szName .. "\t  " .. szCode
end

function uiTrade:OnTradeRequest(bCancel)
  local pNpc = Trade:GetTradeClientNpc(me)
  if not pNpc then
    UiManager:CloseWindow(self.UIGROUP)
    return
  end
  -- 暂时留空
end

function uiTrade:OnTradeResponse()
  local pNpc = Trade:GetTradeClientNpc(me)
  if not pNpc then
    UiManager:CloseWindow(self.UIGROUP)
    return
  end
  -- 交易被拒绝，删除对此人的请求信息
  tbMsgInfo:DelMsg(tbConfirm:MakeKey(UiNotify.CONFIRMATION_TRADE_SEND_REQUEST, pNpc.szName))
  me.Msg(pNpc.szName .. "拒绝与您交易。")
end

function uiTrade:OnTradeTrading(nFaction)
  local pNpc = Trade:GetTradeClientNpc(me)
  if not pNpc then
    UiManager:CloseWindow(self.UIGROUP)
    return
  end

  -- 交易开始，删除所有与此人的关于交易的交互信息
  tbMsgInfo:DelMsg(tbConfirm:MakeKey(UiNotify.CONFIRMATION_TRADE_RECEIVE_REQUEST, pNpc.szName))
  tbMsgInfo:DelMsg(tbConfirm:MakeKey(UiNotify.CONFIRMATION_TRADE_SEND_REQUEST, pNpc.szName))

  Txt_SetTxt(self.UIGROUP, self.TXT_TITLE, pNpc.szName .. "  " .. pNpc.nLevel .. "级  " .. Player:GetFactionRouteName(nFaction))

  self.szPlayerName = pNpc.szName
  Lst_Clear(self.UIGROUP, self.TRADE_HISTORY_LIST)
  self.tbTradeHistory = tbSaveData:Load(self.DATA_KEY)

  if self.tbTradeHistory then
    local nCount = #self.tbTradeHistory
    for i = 1, nCount do
      local tbHistory = self.tbTradeHistory[i]
      local szBuffer = self:GetTradeHistoryFormatString(tbHistory.szName, tbHistory.szCode)
      Lst_SetCell(self.UIGROUP, self.TRADE_HISTORY_LIST, i, 1, szBuffer)
    end
  else
    self.tbTradeHistory = {}
  end

  self.nTradeMoney = 0 -- 交易栏金钱归零
  UiManager:OpenWindow(self.UIGROUP)
end

function uiTrade:MakeStyleMoney(nMoney)
  return "<color=white>" .. Item:FormatMoney2Style(nMoney) .. "两<color>"
end

function uiTrade:OnTradeLock(nMoney, nCoin, szCheckCode)
  self.nLockMoney = nMoney
  self.nLockCoin = nCoin
  Txt_SetTxt(self.UIGROUP, self.CHECK_CODE_TEXT, szCheckCode)
  self:AddTradeHistory(self.szPlayerName, szCheckCode)
  local szMoney = Item:FormatMoney(nMoney) .. "两"
  local szCoin = "<color=yellow>" .. Item:FormatMoney(nCoin) .. "金<color>"
  Txt_SetTxt(self.UIGROUP, self.OTHER_MONEY_TEXT, szMoney)
  Txt_SetTxt(self.UIGROUP, self.TXT_OTHER_COIN, szCoin)
  local szMoneyDesc = Item:FormatMoney(nMoney)
  if nMoney < 10000 then
    szMoneyDesc = "0万" .. szMoneyDesc
  end

  for j = 0, Item.ROOM_TRADE_HEIGHT - 1 do
    for i = 0, Item.ROOM_TRADE_WIDTH - 1 do
      local pItem = me.GetItem(Item.ROOM_TRADECLIENT, i, j)
      local tbObj
      if pItem then
        tbObj = {}
        tbObj.nType = Ui.OBJ_TEMPITEM
        tbObj.pItem = pItem
      end
      self.tbShowItemCont:SetObj(tbObj, i, j)
    end
  end
  self.nOtherLockState = 1
  self:UpdateTradeState()
end

function uiTrade:OnTradeAccept()
  self.nOtherConfirmState = 1
  self:UpdateTradeState()
end

function uiTrade:OnTradeEnd(nSuccess)
  local szMsg = ""
  if self.szPlayerName and (self.szPlayerName ~= "") then
    szMsg = "与" .. self.szPlayerName
  end
  if nSuccess == 0 or nSuccess == 4 then
    szMsg = szMsg .. "交易失败！"
  elseif nSuccess == 1 or nSuccess == 3 then
    szMsg = szMsg .. "交易成功！"
  else
    UiManager:CloseWindow(self.UIGROUP)
    return
  end
  me.Msg(szMsg)
  UiManager:CloseWindow(self.UIGROUP)
end

function uiTrade:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_TRADE_REQUEST, self.OnTradeRequest },
    { UiNotify.emCOREEVENT_TRADE_RESPONSE, self.OnTradeResponse },
    { UiNotify.emCOREEVENT_TRADE_TRADING, self.OnTradeTrading },
    { UiNotify.emCOREEVENT_TRADE_LOCK, self.OnTradeLock },
    { UiNotify.emCOREEVENT_TRADE_CONFIRM, self.OnTradeAccept },
    { UiNotify.emCOREEVENT_TRADE_END, self.OnTradeEnd },
    { UiNotify.emUIEVENT_OBJ_STATE_USE, self.StateRecvUse },
  }
  tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbTradeCont:RegisterEvent())
  return Lib:MergeTable(tbRegEvent, self.tbShowItemCont:RegisterEvent())
end

function uiTrade:RegisterMessage()
  return Lib:MergeTable(self.tbTradeCont:RegisterMessage(), self.tbShowItemCont:RegisterMessage())
end

function uiTrade:StateRecvUse(szUiGroup)
  if szUiGroup == self.UIGROUP then
    return
  end

  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    return
  end

  self.tbTradeCont:SpecialStateRecvUse()
end
