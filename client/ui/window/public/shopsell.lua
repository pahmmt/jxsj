------------------------------------------------------
--文件名		：	shopsell.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-3-27
--功能描述		：	商店中的出售界面脚本。
------------------------------------------------------

local tbShopSell = Ui:GetClass("shopsell")

local BTN_ACCEPT = "BtnAccept"
local BTN_CANCEL = "BtnCancel"
local TXT_ITEM = "TxtItem"
local EDT_NUMBER = "EdtNumber"
local TXT_PRICE = "TxtMoney"
local BTN_CLOSE = "BtnClose"
local BTN_ADD = "BtnAdd"
local BTN_DEC = "BtnDec"

local MAX_MONEY = 2000000000

function tbShopSell:Init()
  self.pItem = nil
  self.nNum = 0
  self.nPrice = 0
  self.nMaxNumber = 0
  self.szUnit = ""
end

function tbShopSell:OnOpen(pItem)
  if not pItem then
    return 0
  end

  Wnd_SetFocus(self.UIGROUP, EDT_NUMBER)
  self.pItem = pItem
  self.nNum = 1

  if pItem.IsBind() == 1 or pItem.nGenre == 24 then -- 宝石特殊处理
    self.szUnit = "绑定银两"
  else
    self.szUnit = "银两"
  end

  if pItem.nEnhTimes > 0 then
    me.Msg("强化过的装备不能售店！")
    return 0
  end

  if pItem.IsEquipHasStone() == 1 then
    me.Msg("镶嵌有宝石的装备不能售店！")
    return 0
  end

  if pItem.IsPartnerEquip() == 1 and pItem.IsBind() == 1 then
    me.Msg("此装备已被锁定，不能出售，请先解除锁定！")
    return 0
  end

  self.nPrice = me.GetShopSellItemPrice(pItem)
  if not self.nPrice then
    me.Msg("该物品不能出售!")
    return 0
  end

  if me.IsAccountLock() == 1 then
    me.Msg("您目前处于锁定状态，不能卖出物品！")
    Account:OpenLockWindow()
    return 0
  end

  if pItem.IsEquip() == 1 then
    self.nMaxNumber = 1
  else
    self.nMaxNumber = me.GetItemCountInBags(pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel, pItem.nSeries, pItem.IsBind())
  end

  self:UpdatePanel()
end

function tbShopSell:OnButtonClick(szWnd, nParam)
  if szWnd == BTN_ACCEPT then
    if me.IsAccountLock() == 1 then
      me.Msg("您目前处于锁定状态，不能卖出物品！")
      Account:OpenLockWindow()
      return 0
    end
    me.ShopSellItem(self.pItem, self.nNum)
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == BTN_CANCEL then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == BTN_ADD then
    Edt_SetInt(self.UIGROUP, EDT_NUMBER, self.nNum + 1)
  elseif szWnd == BTN_DEC then
    Edt_SetInt(self.UIGROUP, EDT_NUMBER, self.nNum - 1)
  elseif szWnd == BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function tbShopSell:OnEditEnter(szWnd)
  if szWnd == EDT_NUMBER then
    self:OnButtonClick(BTN_ACCEPT, 0)
  end
end

function tbShopSell:OnEditChange(szWndName, nParam)
  if szWndName == EDT_NUMBER then
    local nNum = Edt_GetInt(self.UIGROUP, EDT_NUMBER)
    if nNum == self.nNum then -- 防止死循环
      return
    end
    if nNum < 0 then
      nNum = 0
    end
    if nNum < self.nMaxNumber then
      self.nNum = nNum
    else
      self.nNum = self.nMaxNumber
    end
    self:UpdatePanel()
  end
end

function tbShopSell:UpdatePanel()
  local szPrice = Item:FormatMoney(self.nPrice * self.nNum)
  Txt_SetTxt(self.UIGROUP, TXT_PRICE, szPrice .. "<color=blue>" .. self.szUnit .. "<color>")
  Edt_SetInt(self.UIGROUP, EDT_NUMBER, self.nNum)
  Wnd_SetEnable(self.UIGROUP, BTN_ACCEPT, self.nNum)
  Txt_SetTxt(self.UIGROUP, TXT_ITEM, self.pItem.szName)

  local nCashMoney = me.nCashMoney
  if nCashMoney + self.nPrice * self.nNum > MAX_MONEY then -- 金钱上限
    me.Msg("背包中银两达到上限了，不能再卖出物品。")
    Wnd_SetEnable(self.UIGROUP, BTN_ACCEPT, 0)
  end
end

function tbShopSell:OnChangeMap()
  UiManager:CloseWindow(self.UIGROUP)
end

function tbShopSell:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_CURRENTMAP, self.OnChangeMap },
  }
  return tbRegEvent
end
