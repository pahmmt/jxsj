-------------------------------------------------------
----文件名		：	xuanjingcompose.lua
----创建者		：	xuantao@kingsoft.com
----创建时间	：	2012/7/6 10:08:30
----功能描述	：	玄晶合成，特权合玄
--------------------------------------------------------

local uiWnd = Ui:GetClass("xuanjingcompose")
local tbObject = Ui.tbLogic.tbObject
local tbMouse = Ui.tbLogic.tbMouse
local tbTempItem = Ui.tbLogic.tbTempItem
local ENHITEM_INDEX = { nGenre = Item.SCRIPTITEM, nDetail = 1, nParticular = 114 } -- 玄晶
local ENHITEM_CLASS = Item.STRENGTHEN_STUFF_CLASS -- 强化道具类型：玄晶
local ENHANCE_DISCOUNT = "enhancediscount" --强化道具类型：强化优惠符

uiWnd.BTN_CLOSE = "Btn_Close"
uiWnd.BTN_OK = "Btn_OK"
uiWnd.BTN_CANCEL = "Btn_Cancel"
uiWnd.BTN_BIND_MONEY = "Btn_Bind_Money" -- 绑定银两
uiWnd.BTN_NORMAL_MONEY = "Btn_Normal_Money" -- 普通银两
uiWnd.OBJ_ITEM_GRID = "Obj_Item_Grid" -- 物品网格
uiWnd.TXT_DETAIL_DESC = "Txt_Detail_Desc" -- 操作详细描述

local tbCont = { bUse = 1, bLink = 1, bSwitch = 1, bShowCd = 0, bSendToGift = 1, nRoom = Item.ROOM_ENHANCE_ITEM }

function tbCont:CheckSwitchItem(pDrop, pPick, nX, nY)
  if not pDrop then
    return 1
  elseif pDrop.szClass ~= Item.STRENGTHEN_STUFF_CLASS then
    me.Msg("只能放置需要的玄晶！")
    return 0
  elseif pDrop.nLevel >= 12 then
    me.Msg("只有12级以下玄晶才能合成！")
    return 0
  end

  return 1
end

function tbCont:GetItemCount()
  local nCount = 0
  for j = 0, Item.ROOM_ENHANCE_ITEM_HEIGHT - 1 do
    for i = 0, Item.ROOM_ENHANCE_ITEM_WIDTH - 1 do
      local pEnhItem = me.GetEnhanceItem(i, j)
      if pEnhItem then
        nCount = nCount + 1
      end
    end
  end
  return nCount
end

function uiWnd:OnCreate()
  self.tbCont = tbObject:RegisterContainer(self.UIGROUP, self.OBJ_ITEM_GRID, Item.ROOM_ENHANCE_ITEM_WIDTH, Item.ROOM_ENHANCE_ITEM_HEIGHT, tbCont, "itemroom")
end

function uiWnd:OnDestroy()
  tbObject:UnregContainer(self.tbCont)
  self.tbCont = nil
end

function uiWnd:OnOpen(nMoneyType)
  UiManager:SetUiState(UiManager.UIS_EQUIP_COMPOSE)
  self:UpdateState()
  self:SelectMoney(nMoneyType or Item.BIND_MONEY)
  UiManager:OpenWindow(Ui.UI_ITEMBOX)
end

function uiWnd:OnClose()
  self.tbCont:ClearRoom()
  UiManager:ReleaseUiState(UiManager.UIS_EQUIP_COMPOSE)
  me.ApplyEnhance(Item.ENHANCE_MODE_NONE, 0) -- 通知服务端取消强化/剥离操作
  UiManager:CloseWindow(Ui.UI_ITEMBOX)
end

function uiWnd:OnOk()
  if self.nMoneyEnoughFlag == 0 then
    local szMoney = ""
    if self.nMoneyType == Item.BIND_MONEY then
      szMoney = "绑定银两"
    else
      szMoney = "银两"
    end

    me.Msg("您的" .. szMoney .. "不足以支付玄晶合成的费用，无法进行玄晶合成。")
    return
  end

  if self.bShowBindMsg == 1 then
    local tbMsg = {}
    local szReason = ""
    tbMsg.szMsg = ""

    if self.nMoneyType == Item.BIND_MONEY then
      szReason = "绑定银两"
    else
      szReason = "绑定的玄晶"
    end
    tbMsg.szMsg = tbMsg.szMsg .. string.format("您使用了<color=red>%s<color>进行玄晶合成，合成后的玄晶也将<color=red>绑定<color>，", szReason)
    tbMsg.szMsg = tbMsg.szMsg .. "是否继续？"
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex, nMode, nMoneyType, nProb)
      if nOptIndex == 2 then
        me.ApplyEnhance(nMode, nMoneyType, (nProb or 0))
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, Item.ENHANCE_MODE_COMPOSE, self.nMoneyType, self.nProb)
  else
    me.ApplyEnhance(Item.ENHANCE_MODE_COMPOSE, self.nMoneyType, (self.nProb or 0))
  end
end

function uiWnd:OnCancel()
  if self.tbCont:GetItemCount() > 0 then
    self.tbCont:ClearRoom()
  else
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiWnd:OnButtonClick(szWnd)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_CANCEL then
    self:OnCancel()
  elseif szWnd == self.BTN_OK then
    self:OnOk()
  elseif szWnd == self.BTN_BIND_MONEY then
    self:SelectMoney(Item.BIND_MONEY)
  elseif szWnd == self.BTN_NORMAL_MONEY then
    self:SelectMoney(Item.NORMAL_MONEY)
  end
end

function uiWnd:SelectMoney(nMoneyType)
  self.nMoneyType = nMoneyType
  self:UpdateState()

  Btn_Check(self.UIGROUP, self.BTN_BIND_MONEY, 0)
  Btn_Check(self.UIGROUP, self.BTN_NORMAL_MONEY, 0)
  if nMoneyType == Item.BIND_MONEY then
    Btn_Check(self.UIGROUP, self.BTN_BIND_MONEY, 1)
  else
    Btn_Check(self.UIGROUP, self.BTN_NORMAL_MONEY, 1)
  end
end

function uiWnd:UpdateState()
  local tbEnhItem = {}
  local bMaxLevelForbid = 0
  for j = 0, Item.ROOM_ENHANCE_ITEM_HEIGHT - 1 do
    for i = 0, Item.ROOM_ENHANCE_ITEM_WIDTH - 1 do
      local pEnhItem = me.GetEnhanceItem(i, j)
      if pEnhItem and (pEnhItem.szClass == ENHITEM_CLASS) then
        table.insert(tbEnhItem, pEnhItem)
      end
    end
  end

  Wnd_SetEnable(self.UIGROUP, self.BTN_OK, 0)

  if #tbEnhItem <= 0 then
    Txt_SetTxt(self.UIGROUP, self.TXT_DETAIL_DESC, "◆请在下面的格子中放入玄晶。")
  else
    local nMinLevel, nMinLevelRate, nMaxLevel, nMaxLevelRate, nFee, bBind, tbAbsTime = Item:GetComposeBudget(tbEnhItem, self.nMoneyType)
    local nMaxLevelInComItem = Item:GetComItemMaxLevel(tbEnhItem)
    if nMinLevel <= 0 then
      return 0
    end

    if self.nMoneyType == Item.BIND_MONEY then
      self.nMoneyEnoughFlag = (me.GetBindMoney() >= nFee) and 1 or 0
    elseif self.nMoneyType == Item.NORMAL_MONEY then
      self.nMoneyEnoughFlag = (me.nCashMoney >= nFee) and 1 or 0
    else
      print(debug.traceback())
      self.nMoneyEnoughFlag = 0
    end

    if nMinLevel == 0 then
      Txt_SetTxt(self.UIGROUP, self.TXT_DETAIL_DESC, "◆合成物中有非玄晶道具，不能合成！")
    else
      local nMinRate = math.ceil(100 * nMinLevelRate / (nMinLevelRate + nMaxLevelRate))
      local szMsg = string.format("◆本次合成需要收取<color=yellow>%s银两<color>%s%d两%s。(目前银两汇率是<color=yellow>%d<color>)\n◆合成预测：\n  %d%%获得%d级玄晶 ", (self.nMoneyType == Item.NORMAL_MONEY) and "普通" or "绑定", (self.nMoneyEnoughFlag == 1) and "" or "<color=red>", nFee, (self.nMoneyEnoughFlag == 1) and "" or "<color>", Item:GetJbPrice() * 100, nMinRate, nMinLevel)
      if nMaxLevelInComItem == nMinLevel and (100 - nMinRate) < 1 then
        bMaxLevelForbid = 1
      end

      if nMaxLevel > 0 then
        szMsg = szMsg .. string.format("\n  %d%%获得%d级玄晶", 100 - nMinRate, nMaxLevel)
      end

      if tbAbsTime then
        szMsg = szMsg .. string.format("\n◆合成物有效至 <color=yellow>%d年%d月%d日%d时%d分<color>", unpack(tbAbsTime))
      end
      if nMaxLevel == 12 and nMinLevelRate == 0 then
        szMsg = szMsg .. "\n◆你已经可以合成最高级的玄晶了\n"
      elseif bMaxLevelForbid == 1 then
        szMsg = szMsg .. "\n◆当前合成率无法合成更高级的玄晶\n"
      else
        szMsg = szMsg .. "\n◆若想获得更高级玄晶，可以放入更多的玄晶\n"
      end
      self.bShowBindMsg = bBind

      Txt_SetTxt(self.UIGROUP, self.TXT_DETAIL_DESC, szMsg)

      if (#tbEnhItem > 0) and bMaxLevelForbid == 0 then
        Wnd_SetEnable(self.UIGROUP, self.BTN_OK, 1)
      end
    end
  end
end

function uiWnd:OnEventStateRecvUse(szUiGroup)
  if szUiGroup == self.UIGROUP then
    return
  end

  if 1 ~= UiManager:WindowVisible(self.UIGROUP) then
    return
  end

  local tbObj = tbMouse:GetObj()
  if not tbObj or tbObj.nType ~= Ui.OBJ_OWNITEM then
    return
  end

  self.tbCont:SpecialStateRecvUse()
  self:UpdateState()
end

function uiWnd:OnEventUpdateState()
  if 1 ~= UiManager:WindowVisible(self.UIGROUP) then
    return
  end

  self:UpdateState()
end

function uiWnd:OnEventResult(nMode, nResult)
  if 1 ~= UiManager:WindowVisible(self.UIGROUP) or Item.ENHANCE_MODE_COMPOSE ~= nMode then
    return
  end
  self.tbCont:ClearRoom()
  if nResult > 0 then
    me.Msg("你成功合成一个" .. nResult .. "级玄晶！")
  end
end

-- 注册事件
function uiWnd:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_ITEM, self.OnEventUpdateState }, -- 角色道具同步事件
    { UiNotify.emCOREEVENT_MONEY_CHANGED, self.OnEventUpdateState }, -- 金钱发生改变
    { UiNotify.emUIEVENT_OBJ_STATE_USE, self.OnEventStateRecvUse }, -- 道具switch
    { UiNotify.emCOREEVENT_ENHANCE_RESULT, self.OnEventResult }, -- 同步强化/剥离操作结果
  }

  Lib:MergeTable(tbRegEvent, self.tbCont:RegisterEvent())

  return tbRegEvent
end

function uiWnd:RegisterMessage()
  local tbRegMsg = {}
  Lib:MergeTable(tbRegMsg, self.tbCont:RegisterMessage())
  return tbRegMsg
end
