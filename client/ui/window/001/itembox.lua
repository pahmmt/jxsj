-----------------------------------------------------
--文件名		：	tbItemBox.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-03-17
--功能描述		：	背包功能脚本。
------------------------------------------------------

local tbItemBox = Ui:GetClass("itembox")
local tbObject = Ui.tbLogic.tbObject
local tbMouse = Ui.tbLogic.tbMouse
local tbExtBagLayout = Ui.tbLogic.tbExtBagLayout

local OBJ_MAINBAG = "ObjMainBag"
local OBJ_EXTBAGBAR = "ObjExtBagBar"
local TXT_MONEY = "TxtMoney"
local TXT_BINDMONEY = "TxtBindMoney"
local BTN_JBCOIN = "BtnJbCoin" --改成按钮
local TXT_JBCOIN = "TxtJbCoin" --按钮上加文字 与银两等对齐方式一样
local TXT_BINDCOIN = "TxtBindCoin"
local BTN_CLOSE = "BtnClose"
local BTN_START_SALE = "BtnStartSale"
local BTN_START_BUY = "BtnStartBuy"
local BTN_SET_ADV = "BtnAdvertisement"
local BTN_SALE_SETTING = "BtnSaleSetting"
local BTN_BUY_SETTING = "BtnBuySetting"
local BTN_SPLIT_ITEM = "BtnSplitItem" -- 拆分道具按钮
local BTN_OPEN_EXTBAG = "BtnOpenExtBag"
tbItemBox.nIsCoinBtnOpen = UiManager.IVER_nIsCoinBtnOpen

local tbBtn2State = {
  { "BtnSplitItem", UiManager.UIS_ITEM_SPLIT },
  { "BtnSaleSetting", UiManager.UIS_STALL_SETPRICE },
  { "BtnBuySetting", UiManager.UIS_OFFER_SETPRICE },
}

local STATE_USE = -- 该表注册所有需要鼠标右键快速放物品的状态
  {
    UiManager.UIS_ACTION_GIFT, -- 给予界面状态
    UiManager.UIS_EQUIP_BREAKUP, -- 装备拆解状态
    UiManager.UIS_EQUIP_ENHANCE, -- 装备强化
    UiManager.UIS_EQUIP_PEEL, -- 玄晶剥离
    UiManager.UIS_EQUIP_COMPOSE, -- 玄晶合成
    UiManager.UIS_EQUIP_UPGRADE, -- 印鉴升级
    UiManager.UIS_EQUIP_REFINE, -- 装备炼化
    UiManager.UIS_EQUIP_STRENGTHEN, -- 装备改造
    UiManager.UIS_OPEN_REPOSITORY, -- 打开储物箱
    UiManager.UIS_ZHENYUAN_XIULIAN, -- 真元修炼
    UiManager.UIS_ZHENYUAN_REFINE, -- 真元炼化
    UiManager.UIS_EQUIP_TRANSFER, -- 强化转移
    UiManager.UIS_EQUIP_RECAST, -- 装备重铸
    UiManager.UIS_HOLE_MAKEHOLE, -- 装备打孔
    UiManager.UIS_HOLE_MAKEHOLEEX, -- 高级装备打孔
    UiManager.UIS_HOLE_ENCHASE, -- 宝石镶嵌
    UiManager.UIS_STONE_EXCHAGNE, -- 宝石兑换
    UiManager.UIS_STONE_BREAK_UP, -- 宝石拆解
    UiManager.UIS_WEAPON_PEEL, --青铜武器剥离
    UiManager.UIS_EQUIP_CAST, -- 装备精炼
    UiManager.UIS_OPEN_KINREPOSITORY, -- 打开家族仓库
  }

local tbExtBagBarCont = { nRoom = Item.ROOM_EXTBAGBAR }
local tbMainBagCont = { bSendToGift = 1 }

function tbExtBagBarCont:PickMouse(tbObj)
  local tbRoom = { Item.ROOM_EXTBAG1, Item.ROOM_EXTBAG2, Item.ROOM_EXTBAG3 }
  local nRoom = tbRoom[tbObj.nX + 1]
  if (not nRoom) or (me.GetItemCount(nRoom) ~= 0) then
    return 0 -- 扩展背包里有东西则不能拿起来
  end
  return 1
end

function tbExtBagBarCont:CheckSwitch(tbDrop, tbPick, nX, nY)
  local pDrop = nil
  if tbDrop then
    pDrop = me.GetItem(tbDrop.nRoom, tbDrop.nX, tbDrop.nY)
  end
  if not pDrop then
    return 1 -- 拿起操作
  end

  if pDrop.nGenre ~= Item.EXTBAG then
    return 0 -- 放下的不是装备或不能装备
  end

  if pDrop.GetBagPosLimit() > 0 and pDrop.GetBagPosLimit() - 1 ~= nX then
    me.Msg("放置背包失败！该背包不允许放在这个背包栏中！")
    return 0
  end

  if (pDrop.nBindType == Item.BIND_NONE) or (pDrop.IsBind() == 1) then
    return 1 -- 已经绑定或不需要绑定
  end

  local tbMsg = {}
  tbMsg.szMsg = "该背包将与你绑定，绑定后的背包不可丢弃和交易给其他玩家，是否确定？"
  tbMsg.nOptCount = 2
  function tbMsg:Callback(nOptIndex, nDRoom, nDX, nDY, nPRoom, nPX, nPY)
    if nOptIndex == 2 then
      me.SwitchItem(nDRoom, nDX, nDY, nPRoom, nPX, nPY)
    end
  end

  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, tbDrop.nRoom, tbDrop.nX, tbDrop.nY, self.nRoom, nX + self.nOffsetX, nY + self.nOffsetY)
  return 0
end

function tbMainBagCont:CanSendStateUse()
  local bCanSendUse = 0
  for i, nState in ipairs(STATE_USE) do
    if UiManager:GetUiState(nState) == 1 then
      bCanSendUse = 1
      break
    end
  end
  return bCanSendUse
end

function tbItemBox:OnCreate()
  self.tbMainBagCont = tbObject:RegisterContainer(self.UIGROUP, OBJ_MAINBAG, Item.ROOM_MAINBAG_WIDTH, Item.ROOM_MAINBAG_HEIGHT, tbMainBagCont, "itemroom")
  self.tbExtBagBarCont = tbObject:RegisterContainer(self.UIGROUP, OBJ_EXTBAGBAR, Item.EXTBAGPOS_NUM, 1, tbExtBagBarCont, "itemroom")
end

function tbItemBox:OnDestroy()
  tbObject:UnregContainer(self.tbMainBagCont)
  tbObject:UnregContainer(self.tbExtBagBarCont)
end

function tbItemBox:Init()
  self.nCurState = 0
end

function tbItemBox:UpdateStallStateCallback(nFlag)
  Btn_Check(self.UIGROUP, BTN_START_SALE, nFlag)
  if nFlag ~= 1 then
    UiManager:ReleaseUiState(UiManager.UIS_BEGIN_STALL)
    Btn_SetTxt(self.UIGROUP, BTN_START_SALE, "  开始贩卖")
    Wnd_SetEnable(self.UIGROUP, BTN_SALE_SETTING, 1)
    Wnd_SetEnable(self.UIGROUP, BTN_BUY_SETTING, 1)
    Btn_Check(self.UIGROUP, BTN_SALE_SETTING, 0)
    Btn_Check(self.UIGROUP, BTN_BUY_SETTING, 0)
  else
    UiManager:SetUiState(UiManager.UIS_BEGIN_STALL)
    Btn_SetTxt(self.UIGROUP, BTN_START_SALE, "  结束贩卖")
    Wnd_SetEnable(self.UIGROUP, BTN_SALE_SETTING, 0)
    Wnd_SetEnable(self.UIGROUP, BTN_BUY_SETTING, 0)
  end
end

function tbItemBox:UpdateOfferStateCallback(nFlag)
  Btn_Check(self.UIGROUP, BTN_START_BUY, nFlag)
  if nFlag ~= 1 then
    UiManager:ReleaseUiState(UiManager.UIS_BEGIN_OFFER)
    Btn_SetTxt(self.UIGROUP, BTN_START_BUY, "  开始收购")
    Wnd_SetEnable(self.UIGROUP, BTN_SALE_SETTING, 1)
    Wnd_SetEnable(self.UIGROUP, BTN_BUY_SETTING, 1)
    Btn_Check(self.UIGROUP, BTN_SALE_SETTING, 0)
    Btn_Check(self.UIGROUP, BTN_BUY_SETTING, 0)
  else
    UiManager:SetUiState(UiManager.UIS_BEGIN_OFFER)
    Btn_SetTxt(self.UIGROUP, BTN_START_BUY, "  结束收购")
    Wnd_SetEnable(self.UIGROUP, BTN_SALE_SETTING, 0)
    Wnd_SetEnable(self.UIGROUP, BTN_BUY_SETTING, 0)
  end
end

--写log
function tbItemBox:WriteStatLog()
  Log:Ui_SendLog("F2物品界面", 1)
end

function tbItemBox:OnOpen()
  self:WriteStatLog()
  Ui(Ui.UI_SIDEBAR):WndOpenCloseCallback(self.UIGROUP, 1)
  self.tbMainBagCont:UpdateRoom()
  self.tbExtBagBarCont:UpdateRoom()
  self:UpdateCashMoney()
  self:UpDateBind()
  self:UpdateJbCoin()
  self:UpdateExtBag()
  --self:UpdateOpenExtBagState();
  local nStateStall = UiManager:GetUiState(UiManager.UIS_BEGIN_STALL)
  local nStateOffer = UiManager:GetUiState(UiManager.UIS_BEGIN_OFFER)

  if nStateOffer == 1 or nStateStall == 1 then
    if nStateStall == 1 then
      self:UpdateStallStateCallback(nStateStall)
      Btn_Check(self.UIGROUP, BTN_START_SALE, 1)
    else
      self:UpdateOfferStateCallback(nStateOffer)
      Btn_Check(self.UIGROUP, BTN_START_BUY, 1)
    end
    Wnd_SetEnable(self.UIGROUP, BTN_SALE_SETTING, 0)
    Wnd_SetEnable(self.UIGROUP, BTN_BUY_SETTING, 0)
  else
    Wnd_SetEnable(self.UIGROUP, BTN_SALE_SETTING, 1)
    Wnd_SetEnable(self.UIGROUP, BTN_BUY_SETTING, 1)
    self:UpdateOfferStateCallback(0)
    self:UpdateStallStateCallback(0)
  end
  local nEnable = 1
  if (UiManager:GetUiState(UiManager.UIS_TRADE_PLAYER) == 1) or (UiManager:GetUiState(UiManager.UIS_TRADE_NPC) == 1) then
    nEnable = 0
  end
end

function tbItemBox:OnClose()
  self:ResetUiState()
  self.tbMainBagCont:ClearRoom()
  self.tbExtBagBarCont:ClearRoom()
  tbExtBagLayout:Close()
  Ui(Ui.UI_SIDEBAR):WndOpenCloseCallback(self.UIGROUP, 0)
end

function tbItemBox:OnButtonClick(szWnd, nParam)
  if szWnd == BTN_SET_ADV then
    if me.IsAccountLock() ~= 0 then
      me.Msg("你的账号处于锁定状态，无法进行该操作！")
      Account:OpenLockWindow()
      return
    end
    UiManager:OpenWindow(Ui.UI_STALLOFFERADV)
  --	elseif (szWnd == BTN_SALE_SETTING) then
  --		self:OnMarkStallPrice(nParam);
  --	elseif (szWnd == BTN_BUY_SETTING) then
  --		self:OnMarkOfferPrice(nParam);
  elseif szWnd == BTN_START_SALE then
    if me.IsAccountLock() ~= 0 then
      me.Msg("你的账号处于锁定状态，无法进行该操作！")
      Account:OpenLockWindow()
      return
    end
    if UiManager:WindowVisible(Ui.UI_MAILVIEW) ~= 0 or UiManager:WindowVisible(Ui.UI_MAIL) ~= 0 then
      me.Msg("在打开邮箱的情况下，无法进行该操作！")
      Btn_Check(self.UIGROUP, BTN_START_SALE, 0)
      return
    end
    if Stall:ChenckPermit() == 1 then
      self:OnSwitchStallState()
    else
      Btn_Check(self.UIGROUP, BTN_START_SALE, 0)
    end
  elseif szWnd == BTN_START_BUY then
    if me.IsAccountLock() ~= 0 then
      me.Msg("你的账号处于锁定状态，无法进行该操作！")
      Account:OpenLockWindow()
      return
    end
    if UiManager:WindowVisible(Ui.UI_MAILVIEW) ~= 0 or UiManager:WindowVisible(Ui.UI_MAIL) ~= 0 then
      me.Msg("在打开邮箱的情况下，无法进行该操作！")
      Btn_Check(self.UIGROUP, BTN_START_BUY, 0)
      return
    end

    if Stall:ChenckPermit() == 1 then
      self:OnSwitchOfferState()
    else
      Btn_Check(self.UIGROUP, BTN_START_BUY, 0)
    end
  elseif szWnd == BTN_OPEN_EXTBAG then
    self:UpdateOpenExtBagState()
  --elseif (szWnd == BTN_SPLIT_ITEM) then
  --	self:SwitchSplitItemState();
  elseif szWnd == BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == BTN_JBCOIN then
    if self.nIsCoinBtnOpen == 1 then
      if GblTask:GetUiFunSwitch(Ui.UI_PAYONLINE) == 1 then
        me.CallServerScript({ "ApplyOpenOnlinePay" })
      else
        Ui:GetClass("payonline"):PreOpen()
      end
    end
  else
    for i = 1, #tbBtn2State do
      if szWnd == tbBtn2State[i][1] then
        if me.IsAccountLock() ~= 0 then
          me.Msg("你的账号处于锁定状态，无法进行该操作！")
          Btn_Check(self.UIGROUP, szWnd, 0)
          Account:OpenLockWindow()
          break
        end

        if UiManager:WindowVisible(Ui.UI_SHOP) == 1 then
          UiManager:CloseWindow(Ui.UI_SHOP)
        end

        if i == self.nCurState then
          UiManager:ReleaseUiState(tbBtn2State[i][2])
          self.nCurState = 0
        else
          if tbBtn2State[self.nCurState] then -- 释放已有状态
            UiManager:ReleaseUiState(tbBtn2State[self.nCurState][2])
            Btn_Check(self.UIGROUP, tbBtn2State[self.nCurState][1], 0)
          end
          UiManager:SetUiState(tbBtn2State[i][2])
          self.nCurState = i
        end
        Btn_Check(self.UIGROUP, szWnd, self.nCurState)
        break
      end
    end
  end
end

function tbItemBox:UpdateCashMoney()
  local szMoney = "银两：" .. Item:FormatMoney(me.nCashMoney)
  Txt_SetTxt(self.UIGROUP, TXT_MONEY, szMoney)
end

function tbItemBox:UpdateJbCoin()
  local nCoin = 0
  if IVER_g_nSdoVersion == 1 then
    nCoin = GetSndaCoin() --Txt_SetTxt(self.UIGROUP, self.TXT_NUMBER_GOLD, me.nCoin);
  else
    nCoin = me.GetJbCoin()
  end
  local szJbCoin = IVER_g_szCoinName .. "：" .. Item:FormatMoney(nCoin)
  Txt_SetTxt(self.UIGROUP, TXT_JBCOIN, szJbCoin)
end

function tbItemBox:UpdateExtBag()
  if tbExtBagLayout:Visible() == 1 then
    tbExtBagLayout:Show()
    Img_SetFrame(self.UIGROUP, BTN_OPEN_EXTBAG, 1)
    Wnd_SetTip(self.UIGROUP, BTN_OPEN_EXTBAG, "关闭背包")
  else
    tbExtBagLayout:Hide()
    Img_SetFrame(self.UIGROUP, BTN_OPEN_EXTBAG, 0)
    Wnd_SetTip(self.UIGROUP, BTN_OPEN_EXTBAG, "打开背包")
  end
end

function tbItemBox:OnMarkStallPrice(nEnable)
  if nEnable > 0 then
    if me.IsAccountLock() ~= 0 then
      me.Msg("你的账号处于锁定状态，无法进行该操作！")
      Account:OpenLockWindow()
      return
    end
    UiManager:SetUiState(UiManager.UIS_STALL_SETPRICE)
    Wnd_SetEnable(self.UIGROUP, BTN_BUY_SETTING, 0)
  else
    UiManager:ReleaseUiState(UiManager.UIS_STALL_SETPRICE)
    Wnd_SetEnable(self.UIGROUP, BTN_BUY_SETTING, 1)
  end
end

function tbItemBox:OnMarkOfferPrice(nEnable)
  if nEnable > 0 then
    if me.IsAccountLock() ~= 0 then
      me.Msg("你的账号处于锁定状态，无法进行该操作！")
      Account:OpenLockWindow()
      return
    end
    UiManager:SetUiState(UiManager.UIS_OFFER_SETPRICE)
    Wnd_SetEnable(self.UIGROUP, BTN_SALE_SETTING, 0)
  else
    UiManager:ReleaseUiState(UiManager.UIS_OFFER_SETPRICE)
    Wnd_SetEnable(self.UIGROUP, BTN_SALE_SETTING, 1)
  end
end

function tbItemBox:UpdateBtnState()
  local bEnable = 1
  if (UiManager:GetUiState(UiManager.UIS_TRADE_PLAYER) == 1) or (UiManager:GetUiState(UiManager.UIS_ACTION_GIFT) == 1) or (UiManager:GetUiState(UiManager.UIS_TRADE_NPC) == 1) then
    bEnable = 0
  end

  for i, tbCont in ipairs(tbBtn2State) do
    if UiManager:GetUiState(tbCont[2]) == 1 then
      Btn_Check(self.UIGROUP, tbCont[1], 1)
    else
      Btn_Check(self.UIGROUP, tbCont[1], 0)
    end
  end

  --	Wnd_SetEnable(self.UIGROUP, BTN_START_SALE,	bEnable);
  --	Wnd_SetEnable(self.UIGROUP, BTN_START_BUY,	bEnable);
  --	Wnd_SetEnable(self.UIGROUP, BTN_SET_ADV,	bEnable);
  --	Wnd_SetEnable(self.UIGROUP, OBJ_EXTBAGBAR,		bEnable);
end

function tbItemBox:ResetUiState()
  UiManager:ReleaseUiState(UiManager.UIS_STALL_SETPRICE)
  UiManager:ReleaseUiState(UiManager.UIS_OFFER_SETPRICE)
  UiManager:ReleaseUiState(UiManager.UIS_ITEM_REPAIR)
  UiManager:ReleaseUiState(UiManager.UIS_ITEM_SPLIT)
end

function tbItemBox:OnSwitchStallState()
  local bRet = me.SwitchStall()
  self.tbMainBagCont:UpdateRoom()
  if bRet == 0 then
    Wnd_SetEnable(self.UIGROUP, BTN_SALE_SETTING, 1)
    Wnd_SetEnable(self.UIGROUP, BTN_BUY_SETTING, 1)
    Btn_Check(self.UIGROUP, BTN_SALE_SETTING, 0)
    Btn_Check(self.UIGROUP, BTN_BUY_SETTING, 0)
    Btn_Check(self.UIGROUP, BTN_START_SALE, 0)
    Btn_Check(self.UIGROUP, BTN_START_BUY, 0)
  end
  self:ResetUiState()
  --Stall:ShowMsg();
end

function tbItemBox:OnSwitchOfferState()
  local bRet = me.SwitchOffer()
  self.tbMainBagCont:UpdateRoom()
  if bRet == 0 then
    Wnd_SetEnable(self.UIGROUP, BTN_SALE_SETTING, 1)
    Wnd_SetEnable(self.UIGROUP, BTN_BUY_SETTING, 1)
    Btn_Check(self.UIGROUP, BTN_SALE_SETTING, 0)
    Btn_Check(self.UIGROUP, BTN_BUY_SETTING, 0)
    Btn_Check(self.UIGROUP, BTN_START_SALE, 0)
    Btn_Check(self.UIGROUP, BTN_START_BUY, 0)
  end
  self:ResetUiState()
  --Stall:ShowMsg();
end

-- 切换切分道具的UI状态
function tbItemBox:SwitchSplitItemState()
  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    return
  end

  if UiManager:WindowVisible(Ui.UI_SHOP) == 1 then
    UiManager:CloseWindow(Ui.UI_SHOP)
  end

  if UiManager:GetUiState(UiManager.UIS_ITEM_SPLIT) ~= 1 then -- 不在拆分道具的状态则进入其状态
    self:ResetUiState()
    UiManager:SetUiState(UiManager.UIS_ITEM_SPLIT)
    Btn_Check(self.UIGROUP, BTN_SPLIT_ITEM, 1)
  else -- 处于拆分道具的状态则释放之
    UiManager:ReleaseUiState(UiManager.UIS_ITEM_SPLIT)
    Btn_Check(self.UIGROUP, BTN_SPLIT_ITEM, 0)
  end
end

function tbItemBox:UpdateOpenExtBagState()
  if tbExtBagLayout:Visible() == 1 then
    tbExtBagLayout:Hide()
    Wnd_SetTip(self.UIGROUP, BTN_OPEN_EXTBAG, "打开背包")
    Img_SetFrame(self.UIGROUP, BTN_OPEN_EXTBAG, 0)
  else
    tbExtBagLayout:Show()
    Wnd_SetTip(self.UIGROUP, BTN_OPEN_EXTBAG, "关闭背包")
    Img_SetFrame(self.UIGROUP, BTN_OPEN_EXTBAG, 1)
  end
end

function tbItemBox:ViewItem(pItem) -- TODO: xyf 最终要和Object机制合并，这里要删掉
  if not pItem then
    return
  end

  local nTipType = Item.TIPS_NORMAL

  if UiManager:GetUiState(UiManager.UIS_TRADE_REPAIR) == 1 then
    nTipType = Item.TIPS_CREPAIR
  elseif UiManager:GetUiState(UiManager.UIS_TRADE_REPAIR_EX) == 1 then
    nTipType = Item.TIPS_SREPAIR
  elseif UiManager:GetUiState(UiManager.UIS_ITEM_REPAIR) == 1 then
    nTipType = Item.TIPS_IREPAIR
  elseif UiManager:GetUiState(UiManager.UIS_TRADE_BUY) == 1 then
    nTipType = Item.TIPS_SHOP
  elseif UiManager:GetUiState(UiManager.UIS_TRADE_SELL) == 1 then
    nTipType = Item.TIPS_SHOP
  elseif UiManager:GetUiState(UiManager.UIS_TRADE_NPC) == 1 then --与NPC交易打开默认状态  ZouYing
    nTipType = Item.TIPS_SHOP
  elseif UiManager:GetUiState(UiManager.UIS_STALL_BUY) == 1 then
    nTipType = Item.TIPS_STALL
  elseif UiManager:GetUiState(UiManager.UIS_STALL_SETPRICE) == 1 then
    nTipType = Item.TIPS_STALL
  elseif UiManager:GetUiState(UiManager.UIS_OFFER_SELL) == 1 then
    nTipType = Item.TIPS_OFFER
  elseif UiManager:GetUiState(UiManager.UIS_OFFER_SETPRICE) == 1 then
    nTipType = Item.TIPS_OFFER
  elseif UiManager:GetUiState(UiManager.UIS_BEGIN_STALL) == 1 then
    nTipType = Item.TIPS_STALL
  elseif UiManager:GetUiState(UiManager.UIS_BEGIN_OFFER) == 1 then
    nTipType = Item.TIPS_OFFER
  end

  return pItem.GetTip(nTipType)
end

function tbItemBox:StallMarkPrice(nPrice, nItemIdx)
  if nPrice >= 1000000000 then
    me.Msg("物品贩卖单价不能超过10亿两。")
    return 1
  elseif me.CheckStallOverFlow(nItemIdx, nPrice) == 1 then
    me.Msg("您贩卖所得与背包银两相加将超过官府许可，请更改定价。")
    return 1
  else
    me.MarkStallItemPrice(nItemIdx, nPrice)
    return 0
  end
end

function tbItemBox:SplitItem(nSplitCount, pItem)
  if not pItem then
    return
  end
  if me.CountFreeBagCell() < 1 then
    me.Msg("你的背包没有空闲的格子放置拆分道具！")
    return 0
  end
  me.SplitItem(pItem, nSplitCount)
  return 0
end

function tbItemBox:OnStallStateChanged(nFlag)
  self:UpdateStallStateCallback(nFlag)
  self.tbMainBagCont:UpdateRoom()
end

function tbItemBox:OnOfferStateChanged(nFlag)
  self:UpdateOfferStateCallback(nFlag)
  self.tbMainBagCont:UpdateRoom()
end

function tbItemBox:OnSyncItem(nRoom, nX, nY)
  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    return
  end
  if nRoom == Item.ROOM_EXTBAGBAR then
    tbExtBagLayout:Update()
  end
end

function tbItemBox:UpDateBind()
  local szBindCoin = string.format("绑定%s：", IVER_g_szCoinName) .. Item:FormatMoney(me.nBindCoin)
  Txt_SetTxt(self.UIGROUP, TXT_BINDCOIN, szBindCoin)

  local szBindMoney = "绑定银两：" .. Item:FormatMoney(me.GetBindMoney())
  Txt_SetTxt(self.UIGROUP, TXT_BINDMONEY, szBindMoney)
end

-- 似乎这里写到外面比较好
function tbItemBox:StateRecvUse(szUiGroup)
  if szUiGroup == self.UIGROUP or szUiGroup == "UI_EXTBAG1" or szUiGroup == "UI_EXTBAG2" or szUiGroup == "UI_EXTBAG3" then
    return
  end

  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    return
  end

  local nX, nY = self.tbMainBagCont:GetFreePos()
  if nX and nY then
    self.tbMainBagCont:SpecialStateRecvUse()
  end

  if UiManager:WindowVisible(Ui.UI_EXTBAG1) == 1 then
    local nX, nY = Ui(Ui.UI_EXTBAG1).tbExtBagCont:GetFreePos()
    if nX and nY then
      Ui(Ui.UI_EXTBAG1).tbExtBagCont:SpecialStateRecvUse()
      return
    end
  end

  if UiManager:WindowVisible(Ui.UI_EXTBAG2) == 1 then
    local nX, nY = Ui(Ui.UI_EXTBAG2).tbExtBagCont:GetFreePos()
    if nX and nY then
      Ui(Ui.UI_EXTBAG2).tbExtBagCont:SpecialStateRecvUse()
      return
    end
  end

  if UiManager:WindowVisible(Ui.UI_EXTBAG3) == 1 then
    local nX, nY = Ui(Ui.UI_EXTBAG3).tbExtBagCont:GetFreePos()
    if nX and nY then
      Ui(Ui.UI_EXTBAG3).tbExtBagCont:SpecialStateRecvUse()
      return
    end
  end

  tbMouse:ResetObj()
end

function tbItemBox:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SWITCH_STALL, self.OnStallStateChanged },
    { UiNotify.emCOREEVENT_SWITCH_OFFER, self.OnOfferStateChanged },
    { UiNotify.emCOREEVENT_MONEY_CHANGED, self.UpdateCashMoney },
    { UiNotify.emCOREEVENT_JBCOIN_CHANGED, self.UpdateJbCoin },
    { UiNotify.emCOREEVENT_SYNC_ITEM, self.OnSyncItem },
    { UiNotify.emCOREEVENT_SYNC_BINDCOINANDMONEY, self.UpDateBind },
    { UiNotify.emUIEVENT_OBJ_STATE_USE, self.StateRecvUse },
  }
  tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbMainBagCont:RegisterEvent())
  tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbExtBagBarCont:RegisterEvent())
  return tbRegEvent
end

function tbItemBox:RegisterMessage()
  local tbRegMsg = Lib:MergeTable(self.tbMainBagCont:RegisterMessage(), self.tbExtBagBarCont:RegisterMessage())
  return tbRegMsg
end

function tbItemBox:OnMouseEnter(szWnd)
  local szTip = ""
  if szWnd == TXT_MONEY then
    szTip = "银两：剑侠世界的流通货币\n\n最大携带量：" .. Item:FormatMoney(me.GetMaxCarryMoney())
  elseif szWnd == TXT_BINDMONEY then
    szTip = "绑定银两：绑定的银两，可以用来修理装备、强化装备、玄晶合成和玄晶剥离\n\n最大携带量：" .. Item:FormatMoney(me.GetMaxCarryMoney())
  elseif szWnd == BTN_JBCOIN then
    if self.nIsCoinBtnOpen == 1 then
      szTip = string.format("%s：可以在奇珍阁%s区购买各种道具，可以通过%s交易所出售,<color=yellow>点击可快速获得%s<color>", IVER_g_szCoinName, IVER_g_szCoinName, IVER_g_szCoinName, IVER_g_szCoinName)
    else
      szTip = string.format("%s：可以在奇珍阁%s区购买各种道具，可以通过%s交易所出售", IVER_g_szCoinName, IVER_g_szCoinName, IVER_g_szCoinName)
      if IVER_g_nSdoVersion == 1 then
        szTip = string.format("%s：可以在奇珍阁%s区购买各种道具", IVER_g_szCoinName, IVER_g_szCoinName)
      end
    end
  elseif szWnd == TXT_BINDCOIN then
    szTip = string.format("绑定%s：可以在奇珍阁绑定%s区购买各种道具，但不可以出售", IVER_g_szCoinName, IVER_g_szCoinName)
  end
  if szTip ~= "" then
    Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, "", szTip)
  end
end
