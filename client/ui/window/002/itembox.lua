local tbItemBox = Ui:GetClass("itembox")
local tbObject = Ui.tbLogic.tbObject
local tbMouse = Ui.tbLogic.tbMouse
local WND_MAIN = "Main"
local OBJ_EXTBAGBAR = "ObjExtBagBar"
local OBJ_EXBAGCELL = "ObjExtBagCell"
local OBJ_EXBAGLASTROW = "ObjExtBagLastRow"
local WNDANIMATE_TAIL = "Tail"
local BTN_SPLIT = "BtnSplit"
local BTN_CLASSIFICATION = "BtnClassification"
local BTN_SELL = "BtnSell"
local BTN_BUY = "BtnBuy"
local TXT_TITLEROOM = "TxtTitleRoom"
local BTN_CLOSE = "BtnClose"
local IMG_BINDCOIN = "ImgBindCoin"
local TXT_BINDCOIN = "TxtBindCoin"
local IMG_BINDMONEY = "ImgBindMoney"
local TXT_BINDMONEY = "TxtBindMoney"
local BTN_COIN = "BtnCoin"
local TXT_COIN = "TxtCoin"
local IMG_MONEY = "ImgMoney"
local TXT_MONEY = "TxtMoney"

local MAX_BAG_SIZE = 112

local nMainWidth = 475 -- 主界面宽度
local nObjGridHeight = 39 -- obj控件高度
local nHeadHeight = 45
local nTailHeight = 90
local nExtBagLeft = 24

tbItemBox.nIsCoinBtnOpen = UiManager.IVER_nIsCoinBtnOpen

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
    UiManager.UIS_STALL_SALE, -- 贩卖设置价格
    UiManager.UIS_OFFER_BUY, -- 收购设置价格
    UiManager.UIS_TRADE_PLAYER, -- 交易状态
    UiManager.UIS_EQUIP_CAST, -- 装备精炼
    UiManager.UIS_OPEN_KINREPOSITORY, -- 打开家族仓库
  }
local tbExtBagBarCont = { nRoom = Item.ROOM_EXTBAGBAR }
local tbBagExContCopy = { bSendToGift = 1 }

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
      print("bagex switchitem:", nDRoom, nDX, nDY, nPRoom, nPX, nPY)
      me.SwitchItem(nDRoom, nDX, nDY, nPRoom, nPX, nPY)
    end
  end

  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, tbDrop.nRoom, tbDrop.nX, tbDrop.nY, self.nRoom, nX + self.nOffsetX, nY + self.nOffsetY)
  return 0
end

function tbBagExContCopy:CanSendStateUse()
  local bCanSendUse = 0
  for i, nState in ipairs(STATE_USE) do
    if UiManager:GetUiState(nState) == 1 then
      bCanSendUse = 1
      break
    end
  end
  return bCanSendUse
end

local tbBagExCont = {}

function tbItemBox:LinkBagExCont()
  for i = 1, 11 do
    tbBagExCont[i] = {}
    for szKey, _ in pairs(tbBagExContCopy) do
      tbBagExCont[i][szKey] = tbBagExContCopy[szKey]
      tbBagExCont[i]["nRoom"] = Item.ROOM_INTEGRATIONBAG1 + i - 1
    end
  end
end

tbItemBox:LinkBagExCont()

function tbItemBox:OnCreate() end

function tbItemBox:OnDestroy() end

function tbItemBox:Init()
  self.tbBagExCont = nil
  self.tbExtBagBarCont = nil
  self.nCurState = 0
end

function tbItemBox:OnOpen()
  Ui(Ui.UI_SIDEBAR):WndOpenCloseCallback(self.UIGROUP, 1)
  local nBagSize = self:GetBagCount()
  local nItemCount = nBagSize - me.CountFreeBagCell()
  self:SetTitle(nBagSize, nItemCount)
  local nHeight = self:GetWndHeight(nBagSize)
  Wnd_SetSize(self.UIGROUP, WND_MAIN, nMainWidth, nHeight)
  local nBagHeight = math.floor(nBagSize / Item.ROOM_INTEGRATIONBAG_WIDTH)
  local nBagRemain = math.mod(nBagSize, Item.ROOM_INTEGRATIONBAG_WIDTH)
  self.tbBagExCont = {}
  for i = 1, nBagHeight do
    self.tbBagExCont[i] = tbObject:RegisterContainer(self.UIGROUP, OBJ_EXBAGCELL .. i, Item.ROOM_INTEGRATIONBAG_WIDTH, 1, tbBagExCont[i], "itemroom")
    local tbRegEvent = self.tbBagExCont[i]:RegisterEvent()
    for _, tbEvent in pairs(tbRegEvent) do
      UiNotify:RegistNotify(tbEvent[1], tbEvent[2], tbEvent[3])
    end
  end
  for i = 1, 11 do
    if i <= nBagHeight then
      Wnd_Show(self.UIGROUP, OBJ_EXBAGCELL .. i)
    else
      Wnd_Hide(self.UIGROUP, OBJ_EXBAGCELL .. i)
    end
  end
  if nBagRemain > 0 then
    self.tbBagExCont[nBagHeight + 1] = tbObject:RegisterContainer(self.UIGROUP, OBJ_EXBAGLASTROW .. nBagRemain, nBagRemain, 1, tbBagExCont[nBagHeight + 1], "itemroom")
    local tbRegEvent = self.tbBagExCont[nBagHeight + 1]:RegisterEvent()
    for _, tbEvent in pairs(tbRegEvent) do
      UiNotify:RegistNotify(tbEvent[1], tbEvent[2], tbEvent[3])
    end
  end
  local nPosY = nBagHeight * nObjGridHeight + nHeadHeight
  for i = 1, 10 do
    if nBagRemain == i then
      Wnd_Show(self.UIGROUP, OBJ_EXBAGLASTROW .. i)
      Wnd_SetPos(self.UIGROUP, OBJ_EXBAGLASTROW .. i, 24, nPosY)
    else
      Wnd_Hide(self.UIGROUP, OBJ_EXBAGLASTROW .. i)
    end
  end
  for i = 1, 11 do
    if self.tbBagExCont[i] then
      self.tbBagExCont[i]:UpdateRoom()
    end
  end
  if nBagRemain > 0 then
    nPosY = nPosY + nObjGridHeight
  end
  nPosY = nPosY + 3
  Wnd_SetPos(self.UIGROUP, OBJ_EXTBAGBAR, nExtBagLeft, nPosY)
  Wnd_SetPos(self.UIGROUP, IMG_BINDCOIN, 325, nPosY + 2)
  Wnd_SetPos(self.UIGROUP, TXT_BINDCOIN, 235, nPosY)
  Wnd_SetPos(self.UIGROUP, BTN_COIN, 325, nPosY + 22)
  Wnd_SetPos(self.UIGROUP, TXT_COIN, 235, nPosY + 20)
  Wnd_SetPos(self.UIGROUP, IMG_BINDMONEY, 435, nPosY + 2)
  Wnd_SetPos(self.UIGROUP, TXT_BINDMONEY, 345, nPosY)
  Wnd_SetPos(self.UIGROUP, IMG_MONEY, 435, nPosY + 22)
  Wnd_SetPos(self.UIGROUP, TXT_MONEY, 345, nPosY + 20)
  nPosY = nPosY + 46
  Wnd_SetPos(self.UIGROUP, BTN_SPLIT, 24, nPosY)
  Wnd_SetPos(self.UIGROUP, BTN_CLASSIFICATION, 92, nPosY)
  Wnd_SetPos(self.UIGROUP, BTN_SELL, 335, nPosY)
  Wnd_SetPos(self.UIGROUP, BTN_BUY, 403, nPosY)
  nPosY = nPosY + 20
  Wnd_SetPos(self.UIGROUP, WNDANIMATE_TAIL, 0, nPosY)
  self.tbExtBagBarCont = tbObject:RegisterContainer(self.UIGROUP, OBJ_EXTBAGBAR, Item.EXTBAGPOS_NUM, 1, tbExtBagBarCont, "itemroom")
  local tbRegEvent = self.tbExtBagBarCont:RegisterEvent()
  for _, tbEvent in pairs(tbRegEvent) do
    UiNotify:RegistNotify(tbEvent[1], tbEvent[2], tbEvent[3])
  end
  self.tbExtBagBarCont:UpdateRoom()
  self:UpdateBind()
  self:UpdateJbCoin()
  self:UpdateCashMoney()
  local nStateStall = UiManager:GetUiState(UiManager.UIS_BEGIN_STALL)
  local nStateOffer = UiManager:GetUiState(UiManager.UIS_BEGIN_OFFER)
  if nStateStall == 1 then
    self:UpdateStallStateCallback(nStateStall)
    if UiManager:WindowVisible(Ui.UI_STALLSALESETTING) ~= 1 then
      Timer:Register(1, self.OpenStallSaleWindow, self)
    end
  elseif nStateOffer == 1 then
    self:UpdateOfferStateCallback(nStateOffer)
    if UiManager:WindowVisible(Ui.UI_OFFERBUYSETTING) ~= 1 then
      Timer:Register(1, self.OpenOfferBuyWindow, self)
    end
  end

  Tutorial:ProcessNewGiftEx()
end

-- 延迟一帧开启贩卖界面
function tbItemBox:OpenStallSaleWindow()
  UiManager:OpenWindow(Ui.UI_STALLSALESETTING)
  self:MoveMarkPriceItem2StallSale() -- 同步标价物品到映射空间
  Ui(Ui.UI_STALLSALESETTING):UpdateEarnMoney()
  return 0
end

-- 延迟一帧开启收购界面
function tbItemBox:OpenOfferBuyWindow()
  UiManager:OpenWindow(Ui.UI_OFFERBUYSETTING)
  self:MoveMarkPriceItem2OfferBuy()
  Ui(Ui.UI_OFFERBUYSETTING):UpdateCostMoney()
  return 0
end

function tbItemBox:UpdateRoom()
  if not self.tbBagExCont then
    return
  end
  for i = 1, 11 do
    if self.tbBagExCont[i] then
      self.tbBagExCont[i]:UpdateRoom()
    end
  end
end

-- 扩展背包有改变
function tbItemBox:ExtBagUpdate()
  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    return
  end
  local tbPos = {}
  tbPos[1], tbPos[2], tbPos[3], tbPos[4] = Wnd_GetPos(self.UIGROUP, WND_MAIN)
  UiManager:CloseWindow(self.UIGROUP)
  UiManager:OpenWindow(self.UIGROUP, tbPos)
  Wnd_SetPos(self.UIGROUP, WND_MAIN, tbPos[1], tbPos[2])
end

function tbItemBox:OnSyncItem(nRoom, nX, nY)
  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    return
  end
  if nRoom == Item.ROOM_MAINBAG or nRoom == Item.ROOM_EXTBAG1 or nRoom == Item.ROOM_EXTBAG2 or nRoom == Item.ROOM_EXTBAG3 then -- 不是背包空间的物品改变不更新
    if self.tbBagExCont then
      for i = 1, 11 do
        if self.tbBagExCont[i] then
          self.tbBagExCont[i]:UpdateRoom()
        end
      end
    end
    self:SetTitle()
  elseif nRoom == Item.ROOM_EXTBAGBAR then
    self:ExtBagUpdate()
  end
end

function tbItemBox:OnCollateRoom()
  if UiManager:WindowVisible(Ui.UI_ITEMBOX) ~= 1 then
    UiManager:OpenWindow(Ui.UI_ITEMBOX)
  end
end

function tbItemBox:UpdateBind()
  local szBindCoin = Lib:StrFillR(Item:FormatMoney(me.nBindCoin), 15)
  Txt_SetTxt(self.UIGROUP, TXT_BINDCOIN, string.format("%s", szBindCoin))
  local szBindMoney = Lib:StrFillR(Item:FormatMoney(me.GetBindMoney()), 15)
  Txt_SetTxt(self.UIGROUP, TXT_BINDMONEY, string.format("%s", szBindMoney))
end

function tbItemBox:UpdateJbCoin()
  local szJbCoin = Lib:StrFillR(Item:FormatMoney(me.GetJbCoin()), 15)
  Txt_SetTxt(self.UIGROUP, TXT_COIN, string.format("%s", szJbCoin))
end

function tbItemBox:UpdateCashMoney()
  local szCashMoney = Lib:StrFillR(Item:FormatMoney(me.nCashMoney), 15)
  Txt_SetTxt(self.UIGROUP, TXT_MONEY, string.format("%s", szCashMoney))
end

function tbItemBox:OnClose()
  for i = 1, 11 do
    if self.tbBagExCont[i] then
      self.tbBagExCont[i]:ClearRoom()
      tbObject:UnregContainer(self.tbBagExCont[i])
      local tbRegEvent = self.tbBagExCont[i]:RegisterEvent()
      for _, tbEvent in pairs(tbRegEvent) do
        UiNotify:UnRegistNotify(tbEvent[1], tbEvent[2], tbEvent[3])
      end
    end
  end
  self.tbExtBagBarCont:ClearRoom()
  tbObject:UnregContainer(self.tbExtBagBarCont)
  local tbRegEvent = self.tbExtBagBarCont:RegisterEvent()
  for _, tbEvent in pairs(tbRegEvent) do
    UiNotify:UnRegistNotify(tbEvent[1], tbEvent[2], tbEvent[3])
  end
  Ui(Ui.UI_SIDEBAR):WndOpenCloseCallback(self.UIGROUP, 0)
  UiManager:ReleaseUiState(UiManager.UIS_ITEM_SPLIT)
end

-- 设置标题栏
function tbItemBox:SetTitle(nBagSize, nItemCount)
  nBagSize = nBagSize or self:GetBagCount()
  nItemCount = nItemCount or (nBagSize - me.CountFreeBagCell())
  Txt_SetTxt(self.UIGROUP, TXT_TITLEROOM, string.format("(%s/%s)", nItemCount, nBagSize))
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
    Btn_Check(self.UIGROUP, BTN_SPLIT, 1)
  else -- 处于拆分道具的状态则释放之
    UiManager:ReleaseUiState(UiManager.UIS_ITEM_SPLIT)
    Btn_Check(self.UIGROUP, BTN_SPLIT, 0)
  end
end

function tbItemBox:OnButtonClick(szWnd, nParam)
  if szWnd == BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == BTN_COIN or szWnd == TXT_COIN then
    if self.nIsCoinBtnOpen == 1 then
      if GblTask:GetUiFunSwitch(Ui.UI_PAYONLINE) == 1 then
        me.CallServerScript({ "ApplyOpenOnlinePay" })
      else
        Ui:GetClass("payonline"):PreOpen()
      end
    end
  elseif szWnd == BTN_SPLIT then
    if me.IsAccountLock() ~= 0 then
      me.Msg("你的账号处于锁定状态，无法进行该操作！")
      Btn_Check(self.UIGROUP, szWnd, 0)
      Account:OpenLockWindow()
      return
    end
    if UiManager:WindowVisible(Ui.UI_SHOP) == 1 then
      UiManager:CloseWindow(Ui.UI_SHOP)
    end
    if UiManager:GetUiState(UiManager.UIS_ITEM_SPLIT) == 1 then
      UiManager:ReleaseUiState(UiManager.UIS_ITEM_SPLIT)
      Btn_Check(self.UIGROUP, BTN_SPLIT, 0)
    else
      Btn_Check(self.UIGROUP, BTN_SPLIT, 1)
      UiManager:SetUiState(UiManager.UIS_ITEM_SPLIT)
    end
  elseif szWnd == BTN_SELL then
    if UiManager:WindowVisible(Ui.UI_STALLSALESETTING) == 1 then
      UiManager:CloseWindow(Ui.UI_STALLSALESETTING)
    else
      if me.nFightState == 0 then
        UiManager:OpenWindow(Ui.UI_STALLSALESETTING)
        self:MoveMarkPriceItem2StallSale() -- 同步标价物品到映射空间
        Ui(Ui.UI_STALLSALESETTING):UpdateEarnMoney()
      else
        me.Msg("您只能在城镇里进行摆摊！")
      end
    end
    self:UpdateBtnState()
  elseif szWnd == BTN_BUY then
    if UiManager:WindowVisible(Ui.UI_OFFERBUYSETTING) == 1 then
      UiManager:CloseWindow(Ui.UI_OFFERBUYSETTING)
    else
      if me.nFightState == 0 then
        UiManager:OpenWindow(Ui.UI_OFFERBUYSETTING)
        self:MoveMarkPriceItem2OfferBuy() -- 同步标价物品到映射空间
        Ui(Ui.UI_OFFERBUYSETTING):UpdateCostMoney()
      else
        me.Msg("您只能在城镇里进行摆摊！")
      end
    end
    self:UpdateBtnState()
  elseif szWnd == BTN_CLASSIFICATION then
    if self:CheckCanCollate() == 1 then
      local tbCollateMode = {
        "全部整理    ",
        1,
        "部分整理[5] ",
        2,
        "部分整理[10]",
        3,
      }
      DisplayPopupMenu(self.UIGROUP, szWnd, #tbCollateMode / 2, 0, unpack(tbCollateMode))
    end
  end
end

function tbItemBox:CheckCanCollate()
  if self.nCollateTime then
    if self.nCollateTime + 10 > GetTime() then
      me.Msg("你整理的太频繁了！")
      return 0
    end
  end
  return 1
end

-- 响应弹出菜单的选择动作
function tbItemBox:OnMenuItemSelected(szWnd, nItemId, nParam)
  if szWnd == BTN_CLASSIFICATION then
    if nItemId >= 1 and nItemId <= 3 then
      me.CollateBag(nItemId)
      self.nCollateTime = GetTime()
    end
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

function tbItemBox:UpdateStallStateCallback(nFlag)
  if nFlag ~= 1 then
    Wnd_SetEnable(self.UIGROUP, BTN_SPLIT, 1)
    Wnd_SetEnable(self.UIGROUP, BTN_CLASSIFICATION, 1)
    Wnd_SetEnable(self.UIGROUP, BTN_BUY, 1)
    Btn_Check(self.UIGROUP, BTN_SPLIT, 0)
    Btn_Check(self.UIGROUP, BTN_CLASSIFICATION, 0)
    Btn_Check(self.UIGROUP, BTN_BUY, 0)
  else
    UiManager:SetUiState(UiManager.UIS_BEGIN_STALL)
    Wnd_SetEnable(self.UIGROUP, BTN_SPLIT, 0)
    Wnd_SetEnable(self.UIGROUP, BTN_CLASSIFICATION, 0)
    Wnd_SetEnable(self.UIGROUP, BTN_BUY, 0)
  end
end

function tbItemBox:UpdateOfferStateCallback(nFlag)
  if nFlag ~= 1 then
    Wnd_SetEnable(self.UIGROUP, BTN_SPLIT, 1)
    Wnd_SetEnable(self.UIGROUP, BTN_CLASSIFICATION, 1)
    Wnd_SetEnable(self.UIGROUP, BTN_SELL, 1)
    Btn_Check(self.UIGROUP, BTN_SPLIT, 0)
    Btn_Check(self.UIGROUP, BTN_CLASSIFICATION, 0)
    Btn_Check(self.UIGROUP, BTN_SELL, 0)
  else
    UiManager:SetUiState(UiManager.UIS_BEGIN_OFFER)
    Wnd_SetEnable(self.UIGROUP, BTN_SPLIT, 0)
    Wnd_SetEnable(self.UIGROUP, BTN_CLASSIFICATION, 0)
    Wnd_SetEnable(self.UIGROUP, BTN_SELL, 0)
  end
end

function tbItemBox:ResetUiState()
  UiManager:ReleaseUiState(UiManager.UIS_STALL_SETPRICE)
  UiManager:ReleaseUiState(UiManager.UIS_OFFER_SETPRICE)
  UiManager:ReleaseUiState(UiManager.UIS_ITEM_REPAIR)
  UiManager:ReleaseUiState(UiManager.UIS_ITEM_SPLIT)
  UiManager:ReleaseUiState(UiManager.UIS_KINREPITEM_SPLIT)
end

function tbItemBox:StallMarkPrice(nPrice, nItemIdx, nX, nY)
  if nPrice >= 1000000000 then
    me.Msg("物品贩卖单价不能超过10亿两。")
    --self:MoveMarkPriceItem2StallSale()
    return 1
  elseif me.CheckStallOverFlow(nItemIdx, nPrice) == 1 then
    me.Msg("您贩卖所得与背包银两相加将超过官府许可，请更改定价。")
    --self:MoveMarkPriceItem2StallSale();
    return 1
  else
    me.MarkStallItemPrice(nItemIdx, nPrice)
    local nOrgX, nOrgY = Wnd_GetPos(Ui.UI_STALLSALESETTING)
    UiManager:OpenWindow(Ui.UI_STALLSALESETTING, 1)
    Wnd_SetPos(Ui.UI_STALLSALESETTING, "Main", nOrgX, nOrgY)
    UiManager:SetUiState(UiManager.UIS_STALL_SALE)
    self:MoveMarkPriceItem2StallSale()
    Ui(Ui.UI_STALLSALESETTING):UpdateEarnMoney()
    return 0
  end
end

function tbItemBox:CancelStallMarkPrice()
  UiManager:OpenWindow(Ui.UI_STALLSALESETTING, 1)
  UiManager:SetUiState(UiManager.UIS_STALL_SALE)
  self:MoveMarkPriceItem2StallSale()
end

function tbItemBox:UpdateBtnState()
  -- 摆摊贩卖和收购是互斥的
  if UiManager:GetUiState(UiManager.UIS_STALL_SALE) == 1 then
    Wnd_SetEnable(self.UIGROUP, BTN_SPLIT, 0)
    Wnd_SetEnable(self.UIGROUP, BTN_CLASSIFICATION, 0)
    Wnd_SetEnable(self.UIGROUP, BTN_BUY, 0)
    Btn_Check(self.UIGROUP, BTN_SELL, 1)
    UiManager:ReleaseUiState(UiManager.UIS_OFFER_BUY)
    UiManager:ReleaseUiState(UiManager.UIS_ITEM_REPAIR)
    UiManager:ReleaseUiState(UiManager.UIS_ITEM_SPLIT)
  elseif UiManager:GetUiState(UiManager.UIS_OFFER_BUY) == 1 then
    Wnd_SetEnable(self.UIGROUP, BTN_SPLIT, 0)
    Wnd_SetEnable(self.UIGROUP, BTN_CLASSIFICATION, 0)
    Wnd_SetEnable(self.UIGROUP, BTN_SELL, 0)
    Btn_Check(self.UIGROUP, BTN_BUY, 1)
    UiManager:ReleaseUiState(UiManager.UIS_ITEM_REPAIR)
    UiManager:ReleaseUiState(UiManager.UIS_ITEM_SPLIT)
  elseif UiManager:GetUiState(UiManager.UIS_ITEM_SPLIT) == 1 then
    Wnd_SetEnable(self.UIGROUP, BTN_SPLIT, 1)
    Wnd_SetEnable(self.UIGROUP, BTN_CLASSIFICATION, 1)
    Wnd_SetEnable(self.UIGROUP, BTN_BUY, 1)
    Wnd_SetEnable(self.UIGROUP, BTN_SELL, 1)
    Btn_Check(self.UIGROUP, BTN_SPLIT, 1)
    Btn_Check(self.UIGROUP, BTN_BUY, 0)
    Btn_Check(self.UIGROUP, BTN_SELL, 0)
  else
    Wnd_SetEnable(self.UIGROUP, BTN_SPLIT, 1)
    Wnd_SetEnable(self.UIGROUP, BTN_CLASSIFICATION, 1)
    Wnd_SetEnable(self.UIGROUP, BTN_BUY, 1)
    Wnd_SetEnable(self.UIGROUP, BTN_SELL, 1)
    Btn_Check(self.UIGROUP, BTN_SPLIT, 0)
    Btn_Check(self.UIGROUP, BTN_BUY, 0)
    Btn_Check(self.UIGROUP, BTN_SELL, 0)
  end
end

function tbItemBox:OnStallStateChanged(nFlag)
  self:UpdateStallStateCallback(nFlag)
  self:UpdateRoom()
end

function tbItemBox:OnOfferStateChaned(nFlag)
  self:UpdateOfferStateCallback(nFlag)
  self:UpdateRoom()
end

-- 将主背包中的标价物品映射的贩卖界面
function tbItemBox:MoveMarkPriceItem2StallSale()
  if UiManager:WindowVisible(Ui.UI_STALLSALESETTING) ~= 1 then
    return 0
  end

  for k = 1, 11 do
    if self.tbBagExCont[k] then
      for j = 0, self.tbBagExCont[k].nLine - 1 do
        for i = 0, self.tbBagExCont[k].nRow - 1 do
          local nX = i
          local nY = j
          if Ui.tbNewBag:GetTrueRoomPosByMaping(self.tbBagExCont[k].nRoom, nX, nY) ~= Item.ROOM_MAINBAG then
            break
          end
          local pItem = me.GetItem(self.tbBagExCont[k].nRoom, nX, nY)
          if pItem and me.GetStallPrice(pItem) then
            UiManager.bForceSend = 1
            self.tbBagExCont[k]:OnObjGridUse(nX, nY)
            UiManager.bForceSend = 0
          end
        end
      end
    end
  end
end

-- 将主背包中的标价物品映射到收购界面
function tbItemBox:MoveMarkPriceItem2OfferBuy()
  if UiManager:WindowVisible(Ui.UI_OFFERBUYSETTING) ~= 1 then
    return 0
  end
  for k = 1, 11 do
    if self.tbBagExCont[k] then
      for j = 0, self.tbBagExCont[k].nLine - 1 do
        for i = 0, self.tbBagExCont[k].nRow - 1 do
          local nX = i
          local nY = j
          if Ui.tbNewBag:GetTrueRoomPosByMaping(self.tbBagExCont[k].nRoom, nX, nY) ~= Item.ROOM_MAINBAG then
            break
          end
          local pItem = me.GetItem(self.tbBagExCont[k].nRoom, nX, nY)
          if pItem and me.GetOfferReq(pItem) then
            UiManager.bForceSend = 1
            self.tbBagExCont[k]:OnObjGridUse(nX, nY)
            UiManager.bForceSend = 0
          end
        end
      end
    end
  end
end

function tbItemBox:RegisterMessage()
  local tbRegMsg = {}
  if not self.tbBagExCont then
    return tbRegMsg
  end
  for i = 1, 11 do
    if self.tbBagExCont[i] then
      tbRegMsg = Lib:MergeTable(tbRegMsg, self.tbBagExCont[i]:RegisterMessage())
    end
  end
  if self.tbExtBagBarCont then
    tbRegMsg = Lib:MergeTable(tbRegMsg, self.tbExtBagBarCont:RegisterMessage())
  end
  return tbRegMsg
end

function tbItemBox:StateRecvUse(szUiGroup)
  if szUiGroup == self.UIGROUP then
    return
  end

  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    return
  end
  local nFreeRoomIndex = 1
  for i = 1, 11 do
    if self.tbBagExCont[i] then
      local nX, nY = self.tbBagExCont[i]:GetFreePos()
      if nX and nY then
        nFreeRoomIndex = i
        break
      end
    end
  end
  self.tbBagExCont[nFreeRoomIndex]:SpecialStateRecvUse()
  tbMouse:ResetObj()
end

function tbItemBox:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SWITCH_OFFER, self.OnOfferStateChaned },
    { UiNotify.emCOREEVENT_SWITCH_STALL, self.OnStallStateChanged },
    { UiNotify.emCOREEVENT_SYNC_ITEM, self.OnSyncItem },
    { UiNotify.emUIEVENT_OBJ_STATE_USE, self.StateRecvUse },
    { UiNotify.emCOREEVENT_MONEY_CHANGED, self.UpdateCashMoney },
    { UiNotify.emCOREEVENT_JBCOIN_CHANGED, self.UpdateJbCoin },
    { UiNotify.emCOREEVENT_SYNC_BINDCOINANDMONEY, self.UpdateBind },
    { UiNotify.emCOREEVENT_ITEM_COLLATEROOM_REUSTL, self.OnCollateRoom },
  }
  return tbRegEvent
end

function tbItemBox:GetWndHeight(nBagSize)
  local nRow = math.floor(nBagSize / Item.ROOM_INTEGRATIONBAG_WIDTH)
  local nLine = math.mod(nBagSize, Item.ROOM_INTEGRATIONBAG_WIDTH)
  if nLine > 0 then
    nRow = nRow + 1
  end
  local nHeight = nHeadHeight + nObjGridHeight * nRow + nTailHeight
  return nHeight
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

function tbItemBox:OnMouseEnter(szWnd)
  local szTip = ""
  if szWnd == TXT_MONEY or szWnd == IMG_MONEY then
    szTip = "银两：剑侠世界的流通货币\n\n最大携带量：" .. Item:FormatMoney(me.GetMaxCarryMoney())
  elseif szWnd == TXT_BINDMONEY or szWnd == IMG_BINDMONEY then
    szTip = "绑定银两：绑定的银两，可以用来修理装备、强化装备、玄晶合成和玄晶剥离\n\n最大携带量：" .. Item:FormatMoney(me.GetMaxCarryMoney())
  elseif szWnd == TXT_COIN or szWnd == BTN_COIN then
    if self.nIsCoinBtnOpen == 1 then
      szTip = string.format("%s：可以在奇珍阁%s区购买各种道具，可以通过%s交易所出售,<color=yellow>点击可快速获得%s<color>", IVER_g_szCoinName, IVER_g_szCoinName, IVER_g_szCoinName, IVER_g_szCoinName)
    else
      szTip = string.format("%s：可以在奇珍阁%s区购买各种道具，可以通过%s交易所出售", IVER_g_szCoinName, IVER_g_szCoinName, IVER_g_szCoinName)
      if IVER_g_nSdoVersion == 1 then
        szTip = string.format("%s：可以在奇珍阁%s区购买各种道具", IVER_g_szCoinName, IVER_g_szCoinName)
      end
    end
  elseif szWnd == TXT_BINDCOIN or szWnd == IMG_BINDCOIN then
    szTip = string.format("绑定%s：可以在奇珍阁绑定%s区购买各种道具，但不可以出售", IVER_g_szCoinName, IVER_g_szCoinName)
  end
  if szTip ~= "" then
    Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, "", szTip)
  end
end

function tbItemBox:OnMouseLeave(szWnd) end

function tbItemBox:ShowHighLight(nX, nY)
  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    return
  end

  local tbBegPos, tbEndPos = self:GetExBagPos(nX)
  if not tbBegPos or not tbEndPos then
    return
  end
  local nLastRowHeight, nLastRowWidth = self:GetLastRowInfo()
  local nFlag = 0 -- 最后一行是否是特殊行
  if nLastRowWidth ~= 0 and tbEndPos[1] == nLastRowHeight then
    nFlag = 1
  end
  if tbEndPos[1] == tbBegPos[1] then
    for i = tbBegPos[2], tbEndPos[2] do
      if nFlag == 1 then
        ObjGrid_AddHighLightGrid(self.UIGROUP, OBJ_EXBAGLASTROW .. nLastRowWidth, i, 0)
      else
        ObjGrid_AddHighLightGrid(self.UIGROUP, OBJ_EXBAGCELL .. tbEndPos[1], i, 0)
      end
    end
  elseif tbEndPos[1] > tbBegPos[1] then
    for i = tbBegPos[2], 10 do
      ObjGrid_AddHighLightGrid(self.UIGROUP, OBJ_EXBAGCELL .. tbBegPos[1], i, 0)
    end
    for i = 0, tbEndPos[2] do
      if nFlag == 1 then
        ObjGrid_AddHighLightGrid(self.UIGROUP, OBJ_EXBAGLASTROW .. nLastRowWidth, i, 0)
      else
        ObjGrid_AddHighLightGrid(self.UIGROUP, OBJ_EXBAGCELL .. tbEndPos[1], i, 0)
      end
    end
    for i = tbBegPos[1] + 1, tbEndPos[1] - 1 do
      for j = 0, 10 do
        ObjGrid_AddHighLightGrid(self.UIGROUP, OBJ_EXBAGCELL .. i, j, 0)
      end
    end
  end
end

function tbItemBox:HideHighLight(nX, nY)
  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    return
  end
  local tbBegPos, tbEndPos = self:GetExBagPos(nX)
  if not tbBegPos or not tbEndPos then
    return
  end
  local nLastRowHeight, nLastRowWidth = self:GetLastRowInfo()
  local nFlag = 0 -- 最后一行是否是特殊行
  if nLastRowWidth ~= 0 and tbEndPos[1] == nLastRowHeight then
    nFlag = 1
  end
  for i = tbBegPos[1], tbEndPos[1] do
    if nFlag == 1 and i == tbEndPos[1] then
      ObjGrid_ClearHighLightGrid(self.UIGROUP, OBJ_EXBAGLASTROW .. nLastRowWidth)
    else
      ObjGrid_ClearHighLightGrid(self.UIGROUP, OBJ_EXBAGCELL .. i)
    end
  end
end

-- 拿起背包时高亮背包栏空间
function tbItemBox:SetExBagBarHighLight(tbObj)
  local nRet = 1
  if not tbObj or tbObj.nType ~= Ui.OBJ_OWNITEM then
    ObjGrid_ClearHighLightGrid(self.UIGROUP, OBJ_EXTBAGBAR)
    return
  end
  local pItem = me.GetItem(tbObj.nRoom, tbObj.nX, tbObj.nY)
  if not pItem then
    ObjGrid_ClearHighLightGrid(self.UIGROUP, OBJ_EXTBAGBAR)
    return
  end
  if pItem.nGenre ~= Item.EXTBAG then
    ObjGrid_ClearHighLightGrid(self.UIGROUP, OBJ_EXTBAGBAR)
    return
  end
  if pItem.GetBagPosLimit() == -1 then
    for i = 0, 2 do
      ObjGrid_AddHighLightGrid(self.UIGROUP, OBJ_EXTBAGBAR, i, 0)
    end
  elseif pItem.GetBagPosLimit() > 0 then
    ObjGrid_AddHighLightGrid(self.UIGROUP, OBJ_EXTBAGBAR, pItem.GetBagPosLimit() - 1, 0)
  else
    ObjGrid_ClearHighLightGrid(self.UIGROUP, OBJ_EXTBAGBAR)
  end
end

function tbItemBox:GetExBagPos(nPos)
  local tbBegPos, tbEndPos
  local nBeg = Item.ROOM_MAINBAG_WIDTH * Item.ROOM_MAINBAG_HEIGHT
  local nEnd = nBeg
  for i = 0, nPos do
    nBeg = nEnd + 1
    local pExtBag = me.GetExtBag(i)
    if pExtBag then
      local nType = pExtBag.nDetail
      local nExtSize = Ui.tbNewBag:GetExtBagSize(nType)
      nEnd = nEnd + nExtSize
    end
  end
  if nEnd <= nBeg then
    return nil
  end
  local nBegHeight = math.floor(nBeg / Item.ROOM_INTEGRATIONBAG_WIDTH)
  local nBegRemain = math.mod(nBeg, Item.ROOM_INTEGRATIONBAG_WIDTH)
  if nBegRemain > 0 then
    tbBegPos = {}
    tbBegPos[1] = nBegHeight + 1
    tbBegPos[2] = nBegRemain - 1
  elseif nBegRemain == 0 then
    tbBegPos = {}
    tbBegPos[1] = nBegHeight
    tbBegPos[2] = 10
  end
  local nEndHeight = math.floor(nEnd / Item.ROOM_INTEGRATIONBAG_WIDTH)
  local nEndRemain = math.mod(nEnd, Item.ROOM_INTEGRATIONBAG_WIDTH)
  if nEndRemain > 0 then
    tbEndPos = {}
    tbEndPos[1] = nEndHeight + 1
    tbEndPos[2] = nEndRemain - 1
  elseif nEndRemain == 0 then
    tbEndPos = {}
    tbEndPos[1] = nEndHeight
    tbEndPos[2] = 10
  end
  return tbBegPos, tbEndPos
end

-- 获取最后一行所在行数和列数
function tbItemBox:GetLastRowInfo()
  local nBagSize = self:GetBagCount()
  local nBagHeight = math.floor(nBagSize / Item.ROOM_INTEGRATIONBAG_WIDTH)
  local nBagRemain = math.mod(nBagSize, Item.ROOM_INTEGRATIONBAG_WIDTH)
  if nBagRemain > 0 then
    return nBagHeight + 1, nBagRemain
  end
  return nBagHeight, 0
end

-- 获取玩家的背包总格子数
function tbItemBox:GetBagCount()
  local nBagSize = Item.ROOM_MAINBAG_WIDTH * Item.ROOM_MAINBAG_HEIGHT
  for i = 0, 2 do
    local pExtBag = me.GetExtBag(i)
    if pExtBag then
      local nType = pExtBag.nDetail
      local nExtSize = Ui.tbNewBag:GetExtBagSize(nType)
      nBagSize = nBagSize + nExtSize
    end
  end
  return nBagSize
end
