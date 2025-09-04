local tbTimer = Ui.tbLogic.tbTimer
local uiBuy = Ui:GetClass("offerbuysetting") -- 摆摊贩卖设置界面
local tbObject = Ui.tbLogic.tbObject
local tbMouse = Ui.tbLogic.tbMouse
uiBuy.OBJ_BUY_ROOM = "ObjBuyRoom"
uiBuy.CLOSE_WINDOW_BUTTON = "BtnClose"
uiBuy.BTN_SETPRICE = "BtnSetPrice"
uiBuy.BTN_STARTCANCELOFFER = "BtnStartCancelOffer"
uiBuy.EDT_ADV = "EdtAdv"
uiBuy.BTN_BUYLIST = "BtnBuyList"
uiBuy.TXT_COSTMONEY = "TxtCostMoney"
uiBuy.TXT_REMAINTIME = "TxtRemainTime"

uiBuy.TIME_NOTIFY = 36

local tbBuyCont = { bUse = 0, nRoom = Item.ROOM_OFFER_BUY_SETTING, bSendToGift = 1 } -- 不可使用

function tbBuyCont:CheckSwitchItem(pDrop, pPick, nX, nY)
  return 1
end

function uiBuy:Init() end

function uiBuy:OnCreate()
  self.tbBuyCont = tbObject:RegisterContainer(self.UIGROUP, self.OBJ_BUY_ROOM, Item.ROOM_STALL_WIDTH, Item.ROOM_STALL_HEIGHT, tbBuyCont, "itemroom")
end

function uiBuy:OnOpen(nFlag)
  if UiManager:WindowVisible(Ui.UI_ITEMBOX) ~= 1 then
    return 0
  end
  UiManager:SetUiState(UiManager.UIS_OFFER_BUY)
  Wnd_SetFocus(self.UIGROUP, self.EDT_ADV)
  if nFlag ~= 1 then
    self.m_szAdvContent = me.GetAdv()
  end
  Edt_SetTxt(self.UIGROUP, self.EDT_ADV, self.m_szAdvContent)
  Txt_SetTxt(self.UIGROUP, self.TXT_COSTMONEY, "0两")
  self.tbBuyCont:UpdateRoom()
  local nStateOffer = UiManager:GetUiState(UiManager.UIS_BEGIN_OFFER)
  if nStateOffer == 1 then
    self:UpdateOfferStateCallback(nStateOffer)
  end
  self:UpdateCostMoney()
  self:UpdateStallRemainTime()
  if not self.nTimerRegId then
    self.nTimerRegId = tbTimer:Register(self.TIME_NOTIFY, self.UpdateStallRemainTime, self)
  end
end

function uiBuy:OnClose()
  self.tbBuyCont:ClearRoom()
  UiManager:ReleaseUiState(UiManager.UIS_OFFER_BUY)
  self.m_szAdvContent = Edt_GetTxt(self.UIGROUP, self.EDT_ADV)
  if UiManager:GetUiState(UiManager.UIS_BEGIN_OFFER) == 1 then
    UiManager:CloseWindow(Ui.UI_ITEMBOX)
  else
    if UiManager:WindowVisible(Ui.UI_ITEMBOX) == 1 then
      Ui(Ui.UI_ITEMBOX):UpdateBtnState()
      Ui(Ui.UI_ITEMBOX):UpdateRoom()
    end
  end
  if UiManager:WindowVisible(Ui.UI_STALLOFFERLIST) == 1 then
    UiManager:CloseWindow(Ui.UI_STALLOFFERLIST)
  end
  self:ResetUiState()
  if UiManager:WindowVisible(Ui.UI_OFFERMARKPRICE) == 1 then
    UiManager:CloseWindow(Ui.UI_OFFERMARKPRICE)
  end
  if self.nTimerRegId then
    tbTimer:Close(self.nTimerRegId)
    self.nTimerRegId = nil
  end
end

function uiBuy:OnButtonClick(szWnd, nParam)
  if szWnd == self.CLOSE_WINDOW_BUTTON then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_SETPRICE then
    if UiManager:GetUiState(UiManager.UIS_STALL_SETPRICE) == 1 then
      UiManager:ReleaseUiState(UiManager.UIS_OFFER_SETPRICE)
    else
      UiManager:SetUiState(UiManager.UIS_OFFER_SETPRICE)
    end
  elseif szWnd == self.BTN_STARTCANCELOFFER then
    if me.IsAccountLock() ~= 0 then
      me.Msg("你的账号处于锁定状态，无法进行该操作！")
      Account:OpenLockWindow()
      return
    end
    if UiManager:WindowVisible(Ui.UI_MAILVIEW) ~= 0 or UiManager:WindowVisible(Ui.UI_MAIL) ~= 0 then
      me.Msg("在打开邮箱的情况下，无法进行该操作！")
      return
    end
    local szNewAdv = Edt_GetTxt(self.UIGROUP, self.EDT_ADV)
    if not szNewAdv or szNewAdv == "" then
      me.Msg("请先设置广告语")
      return
    end
    if Stall:ChenckPermit() == 1 then
      me.SetAdv(szNewAdv)
      self.m_szAdvContent = szNewAdv
      self:OnSwitchOfferState()
      if UiManager:GetUiState(UiManager.UIS_BEGIN_OFFER) ~= 1 then
        uiBuy.tbBuyList = {} -- 清空收购统计列表
      end
    end
  elseif szWnd == self.BTN_BUYLIST then
    if UiManager:WindowVisible(Ui.UI_STALLOFFERLIST) == 1 then
      UiManager:CloseWindow(Ui.UI_STALLOFFERLIST)
      return
    end
    local tbList = self:GetBuyList()
    if not tbList or #tbList == 0 then
      me.Msg("没有交易记录")
      return
    end
    local tbShowList = {}
    for i = 1, #tbList do
      local tbTemp = tbList[i]
      table.insert(tbShowList, string.format("%s  %s", Lib:StrFillL(string.format("%s*%s", tbTemp[2], tbTemp[4]), 40), tbTemp[3] * tbTemp[4]))
    end
    UiManager:OpenWindow(Ui.UI_STALLOFFERLIST, tbShowList)
  end
end

function uiBuy:OnSwitchOfferState()
  local bRet = me.SwitchOffer()
  if bRet == 0 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_SETPRICE, 1)
    Btn_Check(self.UIGROUP, self.BTN_SETPRICE, 0)
  end
  self:ResetUiState()
end

function uiBuy:ResetUiState()
  UiManager:ReleaseUiState(UiManager.UIS_STALL_SETPRICE)
  UiManager:ReleaseUiState(UiManager.UIS_OFFER_SETPRICE)
  UiManager:ReleaseUiState(UiManager.UIS_ITEM_REPAIR)
  UiManager:ReleaseUiState(UiManager.UIS_ITEM_SPLIT)
  UiManager:ReleaseUiState(UiManager.UIS_KINREPITEM_SPLIT)
end

function uiBuy:ClearRoom()
  self.tbBuyCont:ClearRoom()
end

function uiBuy:OnOfferStateChanged(nFlag)
  self:UpdateOfferStateCallback(nFlag)
  self:UpdateRoomItem()
  self:UpdateCostMoney()
  if nFlag == 1 then
    if not self.nTimerId then
      local nLeftTime = me.GetTask(Stall.TASK_GROUP_ID, Stall.TASK_TOTAL_TIME)
      if nLeftTime > 0 then
        self.nTimerId = tbTimer:Register(nLeftTime * Env.GAME_FPS, self.TimerStallOver, self)
      end
    end
  else
    if self.nTimerId then
      tbTimer:Close()
      self.nTimerId = nil
    end
  end
end

function uiBuy:UpdateOfferStateCallback(nFlag)
  if nFlag ~= 1 then
    UiManager:ReleaseUiState(UiManager.UIS_BEGIN_OFFER)
    Btn_SetTxt(self.UIGROUP, self.BTN_STARTCANCELOFFER, "开始收购")
    Wnd_SetEnable(self.UIGROUP, self.BTN_SETPRICE, 1)
    Btn_Check(self.UIGROUP, self.BTN_SETPRICE, 0)
    Wnd_SetEnable(self.UIGROUP, self.EDT_ADV, 1)
  else
    UiManager:SetUiState(UiManager.UIS_BEGIN_OFFER)
    Btn_SetTxt(self.UIGROUP, self.BTN_STARTCANCELOFFER, "结束收购")
    Wnd_SetEnable(self.UIGROUP, self.BTN_SETPRICE, 0)
    Wnd_SetEnable(self.UIGROUP, self.EDT_ADV, 0)
  end
end

function uiBuy:UpdateRoomItem()
  for i = 0, Item.ROOM_MAINBAG_WIDTH do
    for j = 0, Item.ROOM_MAINBAG_HEIGHT do
      local pItem = me.GetItem(Item.ROOM_OFFER_BUY_SETTING, i, j)
      if pItem then
        local tbPos = me.IsHaveItem(pItem)
        if not tbPos then
          self.tbBuyCont:SetObj(nil, i, j)
          me.SetItem(nil, Item.ROOM_OFFER_BUY_SETTING, i, j)
        else
          if me.GetOfferReq(pItem) then
            local tbItem = {}
            tbItem.nType = Ui.OBJ_ITEM
            tbItem.pItem = pItem
            self.tbBuyCont:UpdateItem(tbItem, i, j)
            local pTemp = me.GetItem(tbPos.nRoom, tbPos.nX, tbPos.nY)
            local a, b = me.GetOfferReq(pTemp)
          else
            self.tbBuyCont:SetObj(nil, i, j)
            me.SetItem(nil, Item.ROOM_OFFER_BUY_SETTING, i, j)
          end
        end
      else
        self.tbBuyCont:SetObj(nil, i, j)
      end
    end
  end
end

function uiBuy:OnSyncItem(nRoom, nX, nY)
  if UiManager:GetUiState(UiManager.UIS_BEGIN_OFFER) == 1 and (nRoom == Item.ROOM_MAINBAG or nRoom == Item.ROOM_EXTBAG1 or nRoom == Item.ROOM_EXTBAG2 or nRoom == Item.ROOM_EXTBAG3) then
    self:UpdateRoomItem()
  end
end

function uiBuy:UpdateCostMoney()
  local tbList = self:GetBuyList()
  local nMoney = 0
  if not tbList or #tbList == 0 then
    Txt_SetTxt(self.UIGROUP, self.TXT_COSTMONEY, "0两")
    return 0
  end
  for i = 1, #tbList do
    nMoney = nMoney + tbList[i][3] * tbList[i][4]
  end
  local szMoney = Item:FormatMoney(nMoney)
  Txt_SetTxt(self.UIGROUP, self.TXT_COSTMONEY, szMoney .. "两")
  return 0
end

function uiBuy:StateRecvUse(szUiGroup)
  if szUiGroup == self.UIGROUP then
    return
  end
  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    return
  end
  self.tbBuyCont:SpecialStateRecvUse()
end

-- 已收购的清单
function uiBuy:GetBuyList()
  uiBuy.tbBuyList = uiBuy.tbBuyList or {}
  return uiBuy.tbBuyList
end

-- 统计收购物品信息
function uiBuy:OnOfferBuyInfo(szShopper, szItemName, dwItemId, nPrice, nCount)
  local tbBuyList = self:GetBuyList()
  for k, v in pairs(tbBuyList) do
    if v[1] == dwItemId and v[2] == szItemName and v[3] == nPrice then
      tbBuyList[k][4] = tbBuyList[k][4] + nCount
      return
    end
  end
  local tbTemp = { dwItemId, szItemName, nPrice, nCount }
  table.insert(tbBuyList, tbTemp)
  self:UpdateCostMoney()
end

function uiBuy:OnDestroy()
  tbObject:UnregContainer(self.tbBuyCont)
end

function uiBuy:UpdateStallRemainTime()
  local nTime = me.GetTask(Stall.TASK_GROUP_ID, Stall.TASK_TOTAL_TIME)
  if nTime <= 0 then
    Txt_SetTxt(self.UIGROUP, self.TXT_REMAINTIME, "0分钟")
    return 0
  end
  local szDesc = ""
  if self.nTimerId then
    local nLeftTime = tonumber(Timer:GetRestTime(self.nTimerId))
    if nLeftTime <= 0 then
      Txt_SetTxt(self.UIGROUP, self.TXT_REMAINTIME, "0分钟")
      return 0
    end
    nTime = math.floor(nLeftTime / Env.GAME_FPS)
  end
  local nHour = math.floor(nTime / 3600)
  local nMinute = math.ceil(math.mod(nTime, 3600) / 60)

  if nHour > 0 then
    szDesc = nHour .. "小时"
  end
  szDesc = szDesc .. nMinute .. "分钟"
  Txt_SetTxt(self.UIGROUP, self.TXT_REMAINTIME, szDesc)
end

function uiBuy:TimerStallOver()
  Txt_SetTxt(self.UIGROUP, self.TXT_REMAINTIME, "0分钟")
  return 0
end

function uiBuy:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SWITCH_OFFER, self.OnOfferStateChanged },
    { UiNotify.emCOREEVENT_SYNC_ITEM, self.OnSyncItem }, -- 角色道具同步事件
    { UiNotify.emUIEVENT_OBJ_STATE_USE, self.StateRecvUse },
    { UiNotify.emCOREEVENT_OFFER_BUY_INFO, self.OnOfferBuyInfo },
  }
  return Lib:MergeTable(tbRegEvent, self.tbBuyCont:RegisterEvent())
end

function uiBuy:RegisterMessage()
  return self.tbBuyCont:RegisterMessage()
end
