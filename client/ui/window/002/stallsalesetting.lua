local tbTimer = Ui.tbLogic.tbTimer
local uiSale = Ui:GetClass("stallsalesetting") -- 摆摊贩卖设置界面
local tbObject = Ui.tbLogic.tbObject
local tbMouse = Ui.tbLogic.tbMouse
uiSale.OBJ_SALE_ROOM = "ObjSaleRoom"
uiSale.CLOSE_WINDOW_BUTTON = "BtnClose"
uiSale.BTN_SETPRICE = "BtnSetPrice"
uiSale.BTN_STARTCANCELSTALL = "BtnStartCancelStall"
uiSale.EDT_ADV = "EdtAdv"
uiSale.BTN_SELLLIST = "BtnSellList"
uiSale.TXT_EARNMONEY = "TxtEarnMoney"
uiSale.TXT_REMAINTIME = "TxtRemainTime"
uiSale.tbStallSaleList = {}

uiSale.TIME_NOTIFY = 36

local tbSaleCont = { bUse = 0, nRoom = Item.ROOM_STALL_SALE_SETTING, bSendToGift = 1 } -- 不可使用
function tbSaleCont:CheckSwitchItem(pDrop, pPick, nX, nY)
  return 1
end

function uiSale:Init() end

function uiSale:OnCreate()
  self.tbSaleCont = tbObject:RegisterContainer(self.UIGROUP, self.OBJ_SALE_ROOM, Item.ROOM_STALL_WIDTH, Item.ROOM_STALL_HEIGHT, tbSaleCont, "itemroom")
end

function uiSale:OnOpen(nFlag)
  if UiManager:WindowVisible(Ui.UI_ITEMBOX) ~= 1 then
    return 0
  end
  UiManager:SetUiState(UiManager.UIS_STALL_SALE)
  Wnd_SetFocus(self.UIGROUP, self.EDT_ADV)
  if nFlag ~= 1 then
    self.m_szAdvContent = me.GetAdv()
  end
  Edt_SetTxt(self.UIGROUP, self.EDT_ADV, self.m_szAdvContent)
  self.tbSaleCont:UpdateRoom()
  local nStateStall = UiManager:GetUiState(UiManager.UIS_BEGIN_STALL)
  if nStateStall == 1 then
    self:UpdateStallStateCallback(nStateStall)
  end
  self:UpdateEarnMoney()
  self:UpdateStallRemainTime()
  if not self.nTimerRegId then
    self.nTimerRegId = tbTimer:Register(self.TIME_NOTIFY, self.UpdateStallRemainTime, self)
  end
end

function uiSale:OnClose()
  self.m_szAdvContent = Edt_GetTxt(self.UIGROUP, self.EDT_ADV)
  self.tbSaleCont:ClearRoom()
  UiManager:ReleaseUiState(UiManager.UIS_STALL_SALE)
  if UiManager:GetUiState(UiManager.UIS_BEGIN_STALL) == 1 then
    UiManager:CloseWindow(Ui.UI_ITEMBOX)
  else
    if UiManager:WindowVisible(Ui.UI_ITEMBOX) == 1 then
      Ui(Ui.UI_ITEMBOX):UpdateBtnState()
    end
  end
  if UiManager:WindowVisible(Ui.UI_STALLOFFERLIST) == 1 then
    UiManager:CloseWindow(Ui.UI_STALLOFFERLIST)
  end
  self:ResetUiState()
  if UiManager:WindowVisible(Ui.UI_STALLMARKPRICE) == 1 then
    UiManager:CloseWindow(Ui.UI_STALLMARKPRICE)
  end
  if self.nTimerRegId then
    tbTimer:Close(self.nTimerRegId)
    self.nTimerRegId = nil
  end
end

function uiSale:UpdateStallRemainTime()
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

function uiSale:TimerStallOver()
  Txt_SetTxt(self.UIGROUP, self.TXT_REMAINTIME, "0分钟")
  return 0
end

function uiSale:OnButtonClick(szWnd, nParam)
  if szWnd == self.CLOSE_WINDOW_BUTTON then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_SETPRICE then
    if UiManager:GetUiState(UiManager.UIS_STALL_SETPRICE) == 1 then
      UiManager:ReleaseUiState(UiManager.UIS_STALL_SETPRICE)
    else
      UiManager:SetUiState(UiManager.UIS_STALL_SETPRICE)
    end
  elseif szWnd == self.BTN_STARTCANCELSTALL then
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
      self:OnSwitchStallState()
      if UiManager:GetUiState(UiManager.UIS_BEGIN_STALL) ~= 1 then
        uiSale.tbSaleList = {} -- 清空贩卖统计列表
      end
    end
  elseif szWnd == self.BTN_SELLLIST then
    if UiManager:WindowVisible(Ui.UI_STALLOFFERLIST) == 1 then
      UiManager:CloseWindow(Ui.UI_STALLOFFERLIST)
      return
    end
    local tbList = self:GetSaleList()
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

function uiSale:OnSwitchStallState()
  local bRet = me.SwitchStall()
  if bRet == 0 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_SETPRICE, 1)
    Btn_Check(self.UIGROUP, self.BTN_SETPRICE, 0)
  end
  self:ResetUiState()
end

function uiSale:ResetUiState()
  UiManager:ReleaseUiState(UiManager.UIS_STALL_SETPRICE)
  UiManager:ReleaseUiState(UiManager.UIS_OFFER_SETPRICE)
  UiManager:ReleaseUiState(UiManager.UIS_ITEM_REPAIR)
  UiManager:ReleaseUiState(UiManager.UIS_ITEM_SPLIT)
  UiManager:ReleaseUiState(UiManager.UIS_KINREPITEM_SPLIT)
end

function uiSale:OnStallStateChanged(nFlag)
  self:UpdateStallStateCallback(nFlag)
  self:UpdateRoomItem()
  self:UpdateEarnMoney()
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

function uiSale:ClearRoom()
  self.tbSaleCont:ClearRoom()
end

function uiSale:UpdateStallStateCallback(nFlag)
  if nFlag ~= 1 then
    UiManager:ReleaseUiState(UiManager.UIS_BEGIN_STALL)
    Btn_SetTxt(self.UIGROUP, self.BTN_STARTCANCELSTALL, "开始贩卖")
    Wnd_SetEnable(self.UIGROUP, self.BTN_SETPRICE, 1)
    Btn_Check(self.UIGROUP, self.BTN_SETPRICE, 0)
    Wnd_SetEnable(self.UIGROUP, self.EDT_ADV, 1)
  else
    UiManager:SetUiState(UiManager.UIS_BEGIN_STALL)
    Btn_SetTxt(self.UIGROUP, self.BTN_STARTCANCELSTALL, "结束贩卖")
    Wnd_SetEnable(self.UIGROUP, self.BTN_SETPRICE, 0)
    Wnd_SetEnable(self.UIGROUP, self.EDT_ADV, 0)
  end
end

function uiSale:OnSyncItem(nRoom, nX, nY)
  if nRoom == Item.ROOM_MAINBAG and UiManager:GetUiState(UiManager.UIS_BEGIN_STALL) == 1 then
    self:UpdateRoomItem()
  end
end

function uiSale:UpdateRoomItem()
  for i = 0, Item.ROOM_MAINBAG_WIDTH do
    for j = 0, Item.ROOM_MAINBAG_HEIGHT do
      local pItem = me.GetItem(Item.ROOM_STALL_SALE_SETTING, i, j)
      if pItem then
        local tbPos = me.IsHaveItem(pItem)
        if not tbPos then
          self.tbSaleCont:SetObj(nil, i, j)
          me.SetItem(nil, Item.ROOM_STALL_SALE_SETTING, i, j)
        else
          local tbItem = {}
          tbItem.nType = Ui.OBJ_ITEM
          tbItem.pItem = pItem
          self.tbSaleCont:UpdateItem(tbItem, i, j)
        end
      else
        self.tbSaleCont:SetObj(nil, i, j)
      end
    end
  end
end

-- 已卖出的清单
function uiSale:GetSaleList()
  uiSale.tbSaleList = uiSale.tbSaleList or {}
  return uiSale.tbSaleList
end

function uiSale:UpdateEarnMoney()
  local tbList = self:GetSaleList()
  local nMoney = 0
  if not tbList or #tbList == 0 then
    Txt_SetTxt(self.UIGROUP, self.TXT_EARNMONEY, "0银两（税前）")
    return
  end
  for i = 1, #tbList do
    nMoney = nMoney + tbList[i][3] * tbList[i][4]
  end
  local szMoney = Item:FormatMoney(nMoney)
  Txt_SetTxt(self.UIGROUP, self.TXT_EARNMONEY, szMoney .. "银两（税前）")
end

function uiSale:StateRecvUse(szUiGroup)
  if szUiGroup == self.UIGROUP then
    return
  end
  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    return
  end
  self.tbSaleCont:SpecialStateRecvUse()
end

-- 贩卖信息统计
function uiSale:OnStallSuccess(szShopper, szItemName, dwItemID, nPrice, nCount)
  local tbSaleList = self:GetSaleList()
  for k, v in pairs(tbSaleList) do
    if v[1] == dwItemID and v[2] == szItemName and v[3] == nPrice then
      tbSaleList[k][4] = tbSaleList[k][4] + nCount
      return
    end
  end
  local tbTemp = { dwItemID, szItemName, nPrice, nCount }
  table.insert(tbSaleList, tbTemp)
  self:UpdateEarnMoney()
end

function uiSale:OnDestroy()
  tbObject:UnregContainer(self.tbSaleCont)
end

function uiSale:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SWITCH_STALL, self.OnStallStateChanged },
    { UiNotify.emCOREEVENT_SYNC_ITEM, self.OnSyncItem }, -- 角色道具同步事件
    { UiNotify.emUIEVENT_OBJ_STATE_USE, self.StateRecvUse },
    { UiNotify.emCOREEVENT_STALL_SALE_INFO, self.OnStallSuccess },
  }
  return Lib:MergeTable(tbRegEvent, self.tbSaleCont:RegisterEvent())
end

function uiSale:RegisterMessage()
  return self.tbSaleCont:RegisterMessage()
end
