-- UI Object容器：对应角色道具空间的容器基类

Require("\\ui\\script\\logic\\objcont\\base.lua")

local tbObject = Ui.tbLogic.tbObject
local tbMouse = Ui.tbLogic.tbMouse
local tbItemRoom = tbObject:NewContainerClass("itemroom", "base")

local MAPPING_ROOM = -- 该表注册所有的映射道具空间，即不存放道具实体，而只含有映射，在这些空间中放有映射的道具一律不显示在实际空间中
  {
    Item.ROOM_MAIL, -- 信件附件
    Item.ROOM_TRADE, -- 交易栏
    Item.ROOM_TRADECLIENT, -- 交易过程中对方的交易栏
    Item.ROOM_GIFT, -- 客户端给予界面
    Item.ROOM_ENHANCE_EQUIP, -- 装备强化/玄晶剥离装备栏空间
    Item.ROOM_ENHANCE_ITEM, -- 装备强化/玄晶剥离玄晶放置空间
    Item.ROOM_BREAKUP, -- 装备拆解空间
    Item.ROOM_AUCTION,
    Item.ROOM_IBSHOPCART,
    Item.ROOM_ZHENYUAN_XIULIAN_ZHENYUAN,
    Item.ROOM_ZHENYUAN_XIULIAN_ITEM,
    Item.ROOM_ZHENYUAN_REFINE_MAIN, -- 真元炼化空间，主真元
    Item.ROOM_ZHENYUAN_REFINE_CONSUME, -- 真元炼化空间，副真元
    Item.ROOM_ZHENYUAN_REFINE_RESULT,
    Item.ROOM_HOLE_EQUIP, -- 装备打孔的装备
    Item.ROOM_STONE_EXCHANGE_ORG,
    Item.ROOM_STALL_SALE_SETTING,
    Item.ROOM_OFFER_BUY_SETTING,
  }

local MAPPING_STATE = -- 该表注册所有的映射道具空间操作状态，此种情况下不能移动角色道具
  {
    UiManager.UIS_TRADE_PLAYER, -- 交易状态
    UiManager.UIS_ACTION_GIFT, -- 给予界面状态
    UiManager.UIS_MAIL_NEW, -- 新建信件状态
    UiManager.UIS_EQUIP_BREAKUP, -- 装备拆解状态
    UiManager.UIS_EQUIP_ENHANCE, -- 装备强化
    UiManager.UIS_EQUIP_PEEL, -- 玄晶剥离
    UiManager.UIS_EQUIP_COMPOSE, -- 玄晶合成
    UiManager.UIS_EQUIP_UPGRADE, -- 印鉴升级
    UiManager.UIS_EQUIP_REFINE, -- 装备炼化
    UiManager.UIS_EQUIP_STRENGTHEN, -- 装备改造
    UiManager.UIS_IBSHOP_CART,
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
    UiManager.UIS_EQUIP_CAST, -- 装备精铸
  }

------------------------------------------------------------------------------------------

function tbItemRoom:init()
  self.nRoom = Item.ROOM_MAINBAG -- 该容器所对应角色道具空间，默认是主背包
  self.nOffsetX = 0 -- 该容器所对应空间X坐标偏移
  self.nOffsetY = 0 -- 该容器所对应空间Y坐标偏移
  self.tbItemMap = {} -- 道具映射表（仅对映射空间容器有效）
end

-- 可覆盖方法：检查是否可以交换
function tbItemRoom:CheckSwitchItem(pDrop, pPick, nX, nY)
  return 1
end

-- 公有方法：更新整个空间
function tbItemRoom:UpdateRoom()
  for j = 0, self.nLine - 1 do
    for i = 0, self.nRow - 1 do
      local nX = i + self.nOffsetX
      local nY = j + self.nOffsetY
      local pItem = me.GetItem(self.nRoom, nX, nY)
      local tbObj = nil
      if pItem then
        tbObj = {}
        tbObj.nType = Ui.OBJ_OWNITEM
        tbObj.nRoom = self.nRoom
        tbObj.nX = nX
        tbObj.nY = nY
      end
      self:SetObj(tbObj, i, j)
    end
  end
end

-- 公有方法：清空整个空间
function tbItemRoom:ClearRoom()
  if self:IsMappingRoom() ~= 1 then
    self:ClearObj() -- 如果不是映射道具空间，只需要清除Object
    return
  end

  -- 映射道具空间，需要自己清空间并通知更新
  local tbFind = me.FindItem(self.nRoom)
  local tbItem = {}
  if tbFind then
    for _, tb in ipairs(tbFind) do
      local tbObj = me.IsHaveItem(tb.pItem)
      if tbObj then
        table.insert(tbItem, tbObj)
      end
    end
  end

  self:ClearObj()
  me.ClearRoom(self.nRoom, self.nOffsetX, self.nOffsetY, self.nRow, self.nLine) -- 注意只能清除容器自己所占有的那部分空间
  self.tbItemMap = {}

  for _, tb in ipairs(tbItem) do
    UiNotify:OnNotify(UiNotify.emCOREEVENT_SYNC_ITEM, tb.nRoom, tb.nX, tb.nY) -- TODO: xyf 临时做法
  end
end

------------------------------------------------------------------------------------------
-- 覆盖方法

function tbItemRoom:CanSetObj(tbObj, nX, nY)
  if not tbObj then -- 如果是拿出，总是允许
    return 1
  end

  if tbObj.nType ~= Ui.OBJ_OWNITEM then
    return 0 -- 不是角色道具不能放入
  end

  return 1
end

function tbItemRoom:PreSetObj(tbObj)
  if not tbObj then
    return
  end

  local pItem = me.GetItem(tbObj.nRoom, tbObj.nX, tbObj.nY)
  if not pItem then
    return -- 找不到道具
  end

  local tbMouseObj = tbMouse.tbObj
  if tbMouseObj and (tbMouseObj.nType == Ui.OBJ_OWNITEM) then
    local pMouse = me.GetItem(tbMouseObj.nRoom, tbMouseObj.nX, tbMouseObj.nY)
    if pMouse then
      if pMouse.nIndex == pItem.nIndex then
        return -- 和鼠标上道具一致
      end
    end
  end

  if self:IsMappingRoom() ~= 1 then -- 如果不是映射道具空间，遍历映射空间中的道具，如果存在一致道具则不允许放入
    for _, nRoom in ipairs(MAPPING_ROOM) do
      local tb = me.FindItem(nRoom)
      if tb then
        for _, tbItem in ipairs(tb) do
          if tbItem.pItem.nIndex == pItem.nIndex then
            return -- 在映射道具空间中发现一致道具
          end
        end
      end
    end
  end

  return tbObj
end

function tbItemRoom:DoSetObj(nX, nY, tbObj)
  self.tbObjs[nY][nX] = tbObj

  if self:IsMappingRoom() ~= 1 then
    return
  end

  -- 先清除位置映射表对应项
  for i, tbMap in pairs(self.tbItemMap) do
    if (tbMap.nMapX == nX) and (tbMap.nMapY == nY) then
      self.tbItemMap[i] = nil
      break
    end
  end

  -- 把新东西加入映射表
  if tbObj then
    local pItem = me.GetItem(tbObj.nRoom, tbObj.nX, tbObj.nY)
    local tbMap = {
      dwId = pItem.dwId, -- 以ID来标识是否同一个东西
      nRoom = tbObj.nRoom,
      nX = tbObj.nX,
      nY = tbObj.nY,
      nMapX = nX,
      nMapY = nY,
    }
    table.insert(self.tbItemMap, tbMap) -- 记录到位置映射表
  end
end

function tbItemRoom:CheckMouse(tbMouseObj)
  if tbMouseObj.nType ~= Ui.OBJ_OWNITEM then
    return 0 -- 鼠标上不是角色道具不允许交换
  end

  local pItem = me.GetItem(tbMouseObj.nRoom, tbMouseObj.nX, tbMouseObj.nY)
  if not pItem then
    Ui:Output("[ERR] Object机制内部错误！")
    tbMouse:SetObj(nil)
    return 0
  end

  -- 给予界面状态或交易状态不能移动角色道具
  for _, nState in ipairs(MAPPING_STATE) do
    if UiManager:GetUiState(nState) == 1 then -- 处于映射空间操作状态
      local bMouseMap = self:IsMappingRoom(tbMouseObj.nRoom) -- 鼠标道具是否来自映射空间
      local bRoomMap = self:IsMappingRoom() -- 当前道具容器是否映射空间
      if bMouseMap == 1 then -- 如果鼠标道具来自映射空间
        me.SetItem(nil, tbMouseObj.nRoom, tbMouseObj.nX, tbMouseObj.nY) -- 清掉映射道具
      end
      if bRoomMap == 1 then -- 如果是放入映射空间
        return 1 -- 总是允许该动作
      else -- 如果是放入非映射空间
        tbMouse:SetObj(nil) -- 先清掉鼠标，才能做后面的刷新动作
        local tbPos = me.IsHaveItem(pItem)
        if tbPos then
          if nState == UiManager.UIS_STALL_SALE then
            me.MarkStallItemPrice(pItem.nIndex, 0)
          elseif nState == UiManager.UIS_OFFER_BUY then
            if me.GetOfferReq(pItem) then
              me.MarkOfferItemPrice(pItem.nIndex, 0, 0)
            end
          end
          UiNotify:OnNotify(UiNotify.emCOREEVENT_SYNC_ITEM, tbPos.nRoom, tbPos.nX, tbPos.nY) -- TODO: xyf 临时做法
        end
        return 0 -- 刷新道具实际所在位置，不允许该动作
      end
      return 0
    end
  end

  return 1
end

function tbItemRoom:ClickMouse(tbObj, nX, nY)
  if tbObj.nType ~= Ui.OBJ_OWNITEM then
    return 0 -- 不是角色道具不允许交换
  end

  if self:IsMappingRoom() == 1 then
    return self:ClickMouseMappingRoom(tbObj, nX, nY)
  end

  local tbMouseObj = tbMouse.tbObj
  local pItem = me.GetItem(tbObj.nRoom, tbObj.nX, tbObj.nY)

  for _, nState in ipairs(MAPPING_STATE) do
    if UiManager:GetUiState(nState) == 1 then
      return self:ClickMouseMappingState(tbObj, nX, nY, nState)
    end
  end

  if (UiManager:GetUiState(UiManager.UIS_OPEN_REPOSITORY) == 1) or (UiManager:IsIdleState() == 1) then
    return 1
  elseif UiManager:GetUiState(UiManager.UIS_OPEN_KINREPOSITORY) == 1 then
    if UiManager:GetUiState(UiManager.UIS_KINREPITEM_SPLIT) == 1 then
      if not pItem then
        return 0
      end
      if pItem.nCount <= 1 then
        me.Msg("该物品不能拆分！")
        return 0
      end
      print(tbObj.nRoom, tbObj.nX, tbObj.nY)
      if self:CheckKinRepositoryRoom(tbObj.nRoom) ~= 1 then
        me.Msg("只能拆分家族仓库的道具！")
        return 0
      end
      local tbParam = {}
      tbParam.varDefault = 1
      tbParam.tbTable = Ui(Ui.UI_KINREPOSITORY)
      tbParam.fnAccept = Ui(Ui.UI_KINREPOSITORY).SplitItem
      tbParam.szBanner = pItem.szName
      tbParam.szTitle = "拆分"
      tbParam.szTip = "数量"
      tbParam.nType = 0
      tbParam.bIncDec = 1
      tbParam.tbRange = { 1, pItem.nCount - 1 }
      UiManager:OpenWindow(Ui.UI_TEXTINPUT_BANNER, tbParam, pItem, tbObj.nRoom, tbObj.nX, tbObj.nY)
      UiManager:ReleaseUiState(UiManager.UIS_KINREPITEM_SPLIT)
    else
      return 1
    end
  elseif UiManager:GetUiState(UiManager.UIS_TRADE_BUY) == 1 then
  elseif UiManager:GetUiState(UiManager.UIS_TRADE_SELL) == 1 then
    if me.IsAccountLock() == 1 then
      Account:OpenLockWindow()
      me.Msg("您目前处于锁定状态，不能卖出物品！")
      return 0
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

    local nPrice = me.GetShopSellItemPrice(pItem)

    if nPrice then
      if nPrice + me.nCashMoney > 2000000000 then
        me.Msg("你卖出所得与背包银两相加超过官府许可。")
        return 0
      end
    else
      me.Msg("此物品不可出卖。")
      return 0
    end
    me.ShopSellItem(pItem, 1)
  elseif UiManager:GetUiState(UiManager.UIS_TRADE_REPAIR) == 1 then
    me.RepairEquipment(Item.REPAIR_COMMON, 1, { pItem.nIndex })
  elseif UiManager:GetUiState(UiManager.UIS_TRADE_REPAIR_EX) == 1 then
    me.RepairEquipment(Item.REPAIR_SPECIAL, 1, { pItem.nIndex })
  elseif UiManager:GetUiState(UiManager.UIS_TRADE_NPC) == 1 then
    local nShiftKey = GetKeyState(UiManager.VK_SHIFT)
    if nShiftKey >= 0 then
      UiManager:OpenWindow(Ui.UI_SHOPSELL, pItem)
    else
      me.ShopSellItem(pItem, 1)
    end
  elseif UiManager:GetUiState(UiManager.UIS_STALL_BUY) == 1 then
  elseif UiManager:GetUiState(UiManager.UIS_STALL_SETPRICE) == 1 then
    if not pItem then
      return 0
    end
    --if tbObj.nRoom ~= Item.ROOM_MAINBAG then
    --	me.Msg("不能对扩展背包中的物品进行标价。");
    --	return 0;
    --end
    if not (Ui.tbNewBag:CheckNewBagMapingRoom(tbObj.nRoom) == 1 or tbObj.nRoom == Item.ROOM_MAINBAG or tbObj.nRoom == Item.ROOM_EXTBAG1 or tbObj.nRoom == Item.ROOM_EXTBAG2 or tbObj.nRoom == Item.ROOM_EXTBAG3) then
      me.Msg("只能对背包和扩展背包的物品进行标价。")
      return 0
    end
    if (pItem.IsForbitTrade() ~= 0) or (pItem.nGenre == Item.TASKQUEST) then
      me.Msg("此物品不能交易")
      return 0
    end
    local tbParam = {}
    tbParam.varDefault = me.GetStallPrice(pItem)
    tbParam.tbTable = Ui(Ui.UI_ITEMBOX)
    tbParam.fnAccept = Ui(Ui.UI_ITEMBOX).StallMarkPrice
    tbParam.szBanner = pItem.szName
    tbParam.szTitle = "贩卖设定"
    tbParam.szTip = "单价"
    tbParam.nType = 0
    tbParam.bIncDec = 0
    tbParam.nMaxLen = 10
    UiManager:OpenWindow(Ui.UI_TEXTINPUT_BANNER, tbParam, pItem.nIndex)
  elseif UiManager:GetUiState(UiManager.UIS_OFFER_SELL) == 1 then
  --		UiManager:OpenWindow(Ui.UI_OFFERSELL, tbItem);		-- TODO: xyf 这里完全是乱糟糟的，再说
  elseif UiManager:GetUiState(UiManager.UIS_OFFER_SETPRICE) == 1 then
    if tbObj.nRoom ~= Item.ROOM_MAINBAG then
      me.Msg("不能对扩展背包中的物品进行标价。")
      return 0
    end
    if (0 ~= pItem.IsLock()) or (0 ~= pItem.IsBind()) or (pItem.nGenre == Item.TASKQUEST) then
      me.Msg("此物品不能交易")
      return 0
    end
    if me.CheckCanBeOffer(pItem.nIndex) ~= 1 then
      return 0
    end
    UiManager:OpenWindow(Ui.UI_OFFERMARKPRICE, pItem)
  elseif UiManager:GetUiState(UiManager.UIS_ITEM_REPAIR) == 1 then
    UiManager:ReleaseUiState(UiManager.UIS_ITEM_REPAIR)
    me.RepairEquipment(Item.REPAIR_ITEM, 1, { pItem.nIndex })
  elseif UiManager:GetUiState(UiManager.UIS_BEGIN_STALL) == 1 then
  elseif UiManager:GetUiState(UiManager.UIS_BEGIN_OFFER) == 1 then
  elseif UiManager:GetUiState(UiManager.UIS_ITEM_SPLIT) == 1 then
    if not pItem then
      return 0
    end
    if pItem.nCount <= 1 then
      me.Msg("该物品不能拆分！")
      return 0
    end
    local tbParam = {}
    tbParam.varDefault = 1
    tbParam.tbTable = Ui(Ui.UI_ITEMBOX)
    tbParam.fnAccept = Ui(Ui.UI_ITEMBOX).SplitItem
    tbParam.szBanner = pItem.szName
    tbParam.szTitle = "拆分"
    tbParam.szTip = "数量"
    tbParam.nType = 0
    tbParam.bIncDec = 1
    tbParam.tbRange = { 1, pItem.nCount - 1 }
    UiManager:OpenWindow(Ui.UI_TEXTINPUT_BANNER, tbParam, pItem)
  elseif UiManager:GetUiState(UiManager.UIS_STONE_UPGRADE) == 1 then
    Item.tbStone:UpgradeStone(tbObj)
  end

  return 0
end

-- 鼠标点击映射空间的obj
function tbItemRoom:ClickMouseMappingRoom(tbObj, nX, nY)
  if UiVersion ~= Ui.Version002 then -- 只在2模式需要区分
    return 1
  end
  if self.nRoom == Item.ROOM_STALL_SALE_SETTING then -- 摆摊贩卖界面
    if UiManager:GetUiState(UiManager.UIS_BEGIN_STALL) == 1 and UiManager.bForceSend ~= 1 then -- 摆摊过程中无法点击
      return 0
    end
    if UiManager:GetUiState(UiManager.UIS_STALL_SETPRICE) == 1 then
      local tbMouseObj = tbMouse.tbObj
      local pItem = me.GetItem(tbObj.nRoom, tbObj.nX, tbObj.nY)
      if not pItem then
        return 0
      end
      if Ui.tbNewBag:GetTrueRoomPosByMaping(tbObj.nRoom, tbObj.nX, tbObj.nY) ~= Item.ROOM_MAINBAG then
        me.Msg("不能对扩展背包中的物品进行标价。")
        return 0
      end
      if (pItem.IsForbitTrade() ~= 0) or (pItem.nGenre == Item.TASKQUEST) then
        me.Msg("此物品不能交易")
        return 0
      end
      local tbParam = {}
      tbParam.nPrice = me.GetStallPrice(pItem)
      tbParam.szName = pItem.szName
      tbParam.nNum = pItem.nCount
      tbParam.nMaxLen = 10
      UiManager:OpenWindow(Ui.UI_STALLMARKPRICE, tbParam, pItem.nIndex, nX, nY)
      return 0
    end
  elseif self.nRoom == Item.ROOM_OFFER_BUY_SETTING then
    if UiManager:GetUiState(UiManager.UIS_BEGIN_OFFER) == 1 and UiManager.bForceSend ~= 1 then
      return 0
    end
    if UiManager:GetUiState(UiManager.UIS_OFFER_SETPRICE) == 1 then
      local tbMouseObj = tbMouse.tbObj
      local pItem = me.GetItem(tbObj.nRoom, tbObj.nX, tbObj.nY)
      if not pItem then
        return 0
      end
      if Ui.tbNewBag:GetTrueRoomPosByMaping(tbObj.nRoom, tbObj.nX, tbObj.nY) ~= Item.ROOM_MAINBAG then
        me.Msg("不能对扩展背包中的物品进行标价222。")
        return 0
      end
      if (pItem.IsForbitTrade() ~= 0) or (pItem.nGenre == Item.TASKQUEST) then
        me.Msg("此物品不能收购")
        return 0
      end
      if me.CheckCanBeOffer(pItem.nIndex) ~= 1 then
        return 0
      end
      UiManager:OpenWindow(Ui.UI_OFFERMARKPRICE, pItem)
      return 0
    end
  end
  return 1 -- 是映射道具空间则不需要下面的逻辑
end

-- 鼠标点击obj是映射状态
function tbItemRoom:ClickMouseMappingState(tbObj, nX, nY, nState)
  if UiVersion ~= Ui.Version002 then
    return 1
  end
  if nState == UiManager.UIS_STALL_SALE then -- 非可摆摊物品不能映射
    if UiManager:GetUiState(UiManager.UIS_BEGIN_STALL) == 1 and UiManager.bForceSend ~= 1 then
      return 0
    end
    local tbMouseObj = tbMouse.tbObj
    local pItem = me.GetItem(tbObj.nRoom, tbObj.nX, tbObj.nY)
    if not pItem then
      return 0
    end
    if Ui.tbNewBag:GetTrueRoomPosByMaping(tbObj.nRoom, tbObj.nX, tbObj.nY) ~= Item.ROOM_MAINBAG then
      me.Msg("不能对扩展背包中的物品进行标价。")
      return 0
    end
    if (pItem.IsForbitTrade() ~= 0) or (pItem.nGenre == Item.TASKQUEST) then
      me.Msg("此物品不能贩卖")
      return 0
    end
  elseif nState == UiManager.UIS_OFFER_BUY then
    if UiManager:GetUiState(UiManager.UIS_BEGIN_OFFER) == 1 and UiManager.bForceSend ~= 1 then
      return 0
    end
    local tbMouseObj = tbMouse.tbObj
    local pItem = me.GetItem(tbObj.nRoom, tbObj.nX, tbObj.nY)
    if not pItem then
      return 0
    end
    if Ui.tbNewBag:GetTrueRoomPosByMaping(tbObj.nRoom, tbObj.nX, tbObj.nY) ~= Item.ROOM_MAINBAG then
      me.Msg("不能对扩展背包中的物品进行标价。")
      return 0
    end
    if (pItem.IsForbitTrade() ~= 0) or (pItem.nGenre == Item.TASKQUEST) then
      me.Msg("此物品不能收购")
      return 0
    end
    if me.CheckCanBeOffer(pItem.nIndex) ~= 1 then
      return 0
    end
  end
  return 1 -- 如果是映射道具空间操作状态则允许切换
end

function tbItemRoom:SwitchMouse(tbMouseObj, tbObj, nX, nY)
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
    -- 是真元且是第一次被装备时，给出提示对话框
    if (pItem.nDetail == Item.EQUIP_ZHENYUAN) and tbMouseObj.nRoom == Item.ROOM_EQUIP and (Item.tbZhenYuan:GetEquiped(pItem) == 0 or pItem.IsBind() == 0) then
      local tbMsg = {}
      if Item.tbZhenYuan:GetEquiped(pItem) == 0 then
        tbMsg.szMsg = "装备后变为护体真元，护体真元将绑定且不能作为副真元炼化，确定装备吗？"
      elseif pItem.IsBind() == 0 then
        tbMsg.szMsg = "装备后护体真元自动绑定，你确定要装备吗？"
      end
      tbMsg.nOptCount = 2
      function tbMsg:Callback(nOptIndex, tbMouseObj, tbObj)
        if (nOptIndex == 2) and tbObj then
          me.UseItem(me.GetItem(tbObj.nRoom, tbObj.nX, tbObj.nY))
          tbMouse:ResetObj()
        end
      end
      UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, tbMouseObj, tbObj)
      return
    end

    if (pItem.nGenre == Item.EQUIP_PARTNER) and tbMouseObj.nRoom == Item.ROOM_PARTNEREQUIP and (pItem.IsBind() == 0) then
      local tbMsg = {}
      tbMsg.szMsg = "同伴装备装备后自动绑定，你确定要装备吗？"
      tbMsg.nOptCount = 2
      function tbMsg:Callback(nOptIndex, tbMouseObj, tbObj)
        if (nOptIndex == 2) and tbObj then
          me.UseItem(me.GetItem(tbObj.nRoom, tbObj.nX, tbObj.nY))
          tbMouse:ResetObj()
        end
      end
      UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, tbMouseObj, tbObj)
      return
    end

    -- 如果不是映射道具空间，调用CORE接口请求交换操作
    -- 002版本交换时将鼠标上的空间坐标转换为真实坐标，处理背包改变时obj的映射坐标改变
    if UiVersion == Ui.Version002 then
      tbMouseObj.nRoom, tbMouseObj.nX, tbMouseObj.nY = Ui.tbNewBag:GetTrueRoomPosByMaping(tbMouseObj.nRoom, tbMouseObj.nX, tbMouseObj.nY)
    end
    -- 家族仓库单独接口
    if self:CheckKinRepositoryRoom(tbMouseObj.nRoom) == 1 or self:CheckKinRepositoryRoom(tbObj.nRoom) == 1 then
      if self:KinRepSwitchItem(tbMouseObj, tbObj.nRoom, tbObj.nX, tbObj.nY) ~= 1 then
        tbMouse:ResetObj()
        return 0
      end
    else
      if me.SwitchItem(tbMouseObj.nRoom, tbMouseObj.nX, tbMouseObj.nY, tbObj.nRoom, tbObj.nX, tbObj.nY) ~= 1 then
        tbMouse:ResetObj() -- 交换失败，立刻把鼠标上的东西弹回
        return 0
      end
    end
  else
    -- 映射道具空间，对空间道具进行处理
    me.SetItem(pMouseItem, self.nRoom, nX + self.nOffsetX, nY + self.nOffsetY) -- 设置道具空间
    tbMouse:SetObj(tbObj) -- 先把容器道具放到鼠标上
    self:SetObj(tbMouseObj, nX, nY) -- 再把鼠标道具放入容器
  end

  return 1
end

function tbItemRoom:DropMouse(tbMouseObj, nX, nY)
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
    -- 家族仓库单独接口
    if self:CheckKinRepositoryRoom(tbMouseObj.nRoom) == 1 or self:CheckKinRepositoryRoom(self.nRoom) == 1 then
      if self:KinRepSwitchItem(tbMouseObj, self.nRoom, nX, nY) ~= 1 then
        tbMouse:ResetObj()
        return 0
      end
    else
      if me.SwitchItem(tbMouseObj.nRoom, tbMouseObj.nX, tbMouseObj.nY, self.nRoom, nX + self.nOffsetX, nY + self.nOffsetY) ~= 1 then
        -- 交换失败，立刻把鼠标上的东西弹回
        tbMouse:ResetObj()
        return 0
      end
    end
    if UiManager:GetUiState(UiManager.UIS_STALL_SALE) == 1 and me.GetStallPrice(pItem) then
      me.MarkStallItemPrice(pItem.nIndex, 0)
    elseif UiManager:GetUiState(UiManager.UIS_OFFER_BUY) == 1 and me.GetOfferReq(pItem) then
      me.MarkOfferItemPrice(pItem.nIndex, 0, 0)
    end
  else
    -- 映射道具空间，对空间道具进行处理
    me.SetItem(pItem, self.nRoom, nX + self.nOffsetX, nY + self.nOffsetY) -- 设置道具空间
    tbMouse:SetObj(nil) -- 先清掉鼠标
    self:SetObj(tbMouseObj, nX, nY) -- 再把鼠标道具放入容器
    if UiVersion == Ui.Version002 then
      if self.nRoom == Item.ROOM_STALL_SALE_SETTING and UiManager:GetUiState(UiManager.UIS_STALL_SALE) == 1 then
        if not me.GetStallPrice(pItem) then
          local tbParam = {}
          tbParam.nPrice = me.GetStallPrice(pItem)
          tbParam.szName = pItem.szName
          tbParam.nNum = pItem.nCount
          tbParam.nMaxLen = 10
          UiManager:OpenWindow(Ui.UI_STALLMARKPRICE, tbParam, pItem.nIndex)
        end
      elseif self.nRoom == Item.ROOM_OFFER_BUY_SETTING and UiManager:GetUiState(UiManager.UIS_OFFER_BUY) == 1 then
        if not me.GetOfferReq(pItem) then
          UiManager:OpenWindow(Ui.UI_OFFERMARKPRICE, pItem)
        end
      end
    end
  end
  return 1
end

function tbItemRoom:PickMouse(tbObj, nX, nY)
  if self:CheckSwitch(nil, tbObj, nX, nY) ~= 1 then
    return 0
  end

  if self:IsMappingRoom() == 1 then
    me.SetItem(nil, self.nRoom, nX + self.nOffsetX, nY + self.nOffsetY) -- 映射道具空间，清掉映射
  end

  return 1
end

------------------------------------------------------------------------------------------
-- 私有方法

-- 检查指定Room是否映射道具空间
function tbItemRoom:IsMappingRoom(nRoom)
  if not nRoom then
    nRoom = self.nRoom
  end
  for _, n in ipairs(MAPPING_ROOM) do
    if nRoom == n then
      return 1
    end
  end
  return 0
end

function tbItemRoom:CheckSwitch(tbDrop, tbPick, nX, nY)
  local pDrop = nil
  local pPick = nil
  if tbDrop then
    pDrop = me.GetItem(tbDrop.nRoom, tbDrop.nX, tbDrop.nY)
  end
  if tbPick then
    pPick = me.GetItem(tbPick.nRoom, tbPick.nX, tbPick.nY)
  end
  if (not pDrop) and not pPick then
    return 0
  end
  return self:CheckSwitchItem(pDrop, pPick, nX, nY)
end

function tbItemRoom:RefreshItem(nRoom, nX, nY)
  if UiManager:WindowVisible(self.szUiGroup) ~= 1 then
    return -- TODO: xyf 窗口不显示的时候不应该接消息，以后统一处理
  end
  if Ui.tbNewBag:CheckNewBagMapingRoom(self.nRoom) == 1 then -- 程序传回来的始终是真实空间
    nRoom, nX, nY = Ui.tbNewBag:GetMapingRoomPosByTrue(nRoom, nX, nY)
  end
  if not nRoom or not nX or not nY then
    return
  end
  local pItem = me.GetItem(nRoom, nX, nY) -- 在人身上找
  local tbOver = tbMouse.tbOverObj -- 鼠标悬停Object
  local bMapping = self:IsMappingRoom() -- 是否映射空间
  local bRedirect = 0 -- 是否需要将空间更新事件重定向到映射空间
  local nOrgRoom = nRoom
  local nOrgX = nX
  local nOrgY = nY

  if (bMapping == 1) and (nRoom ~= self.nRoom) then
    -- 映射空间需更新道具映射
    for i, tbMap in pairs(self.tbItemMap) do
      if self:CheckRoomPosSame(tbMap.nRoom, tbMap.nX, tbMap.nY, nRoom, nX, nY) == 1 then
        if pItem and (pItem.dwId ~= tbMap.dwId) then
          pItem = nil
        end
        -- 如果道具已经不存在或者仍然是先前的那个道具，更新到映射容器里
        nRoom = self.nRoom
        nX = tbMap.nMapX + self.nOffsetX
        nY = tbMap.nMapY + self.nOffsetY
        bRedirect = 1
        break
      end
    end
  end

  if (nRoom ~= self.nRoom) or (nX < self.nOffsetX) or (nY < self.nOffsetY) then
    return -- 该道具位置不在容器对应范围之内
  end

  if tbOver and (tbOver.nType == Ui.OBJ_OWNITEM) and (tbOver.nRoom == nOrgRoom) and (tbOver.nX == nOrgX) and (tbOver.nY == nOrgY) then
    -- 发现刷新道具Obj与鼠标悬停道具Obj一致
    Wnd_HideMouseHoverInfo() -- 先关闭Tip
    if not pItem then
      tbMouse.tbOverObj = nil -- 如果道具已经不存在，则清掉鼠标悬停道具
    else
      self:ShowItemTip(pItem) -- 否则自动更新Tip
    end
  end

  -- 看是不是在鼠标上
  if tbMouse.tbObj and tbMouse.tbObj.nType == Ui.OBJ_OWNITEM then
    if (tbMouse.tbObj.nRoom == nOrgRoom) and (tbMouse.tbObj.nX == nOrgX) and (tbMouse.tbObj.nY == nOrgY) then
      if not pItem then
        tbMouse:SetObj(nil) -- 道具已经不在了，删掉鼠标上的
      else
        local tbObj = {}
        tbObj.nType = Ui.OBJ_OWNITEM
        tbObj.nRoom = nOrgRoom
        tbObj.nX = nOrgX
        tbObj.nY = nOrgY
        tbMouse:SetObj(tbObj)
        tbMouse:Refresh()
      end
    end
  end

  local i = nX - self.nOffsetX -- 道具在容器中的实际X坐标
  local j = nY - self.nOffsetY -- 道具在容器中的实际Y坐标
  local tbObj = self:GetObj(i, j)

  if not pItem then
    if bRedirect == 1 then
      me.SetItem(nil, nRoom, nX, nY)
    end
    self:SetObj(nil, i, j) -- 对应道具已经不在了，从容器里删除
    return
  end

  if (not tbObj) and not pItem then
    return -- 身上和容器里都没，结束处理
  end

  if not tbObj then -- 重建Object数据结构
    tbObj = {}
    tbObj.nType = Ui.OBJ_OWNITEM
    tbObj.nRoom = nRoom
    tbObj.nX = nX
    tbObj.nY = nY
  end

  if tbObj.nType == Ui.OBJ_OWNITEM then
    if bRedirect == 1 then
      me.SetItem(pItem, nRoom, nX, nY)
    end
    self:SetObj(tbObj, i, j) -- 以覆盖方式更新Object数据
    --		self:UpdateItemCd(pItem.nCdType);	-- 更新CD时间特效	-- TODO: xyf 因为效率问题先注释掉
  end
end

function tbItemRoom:CheckRoomPosSame(nRoom1, nX1, nY1, nRoom2, nX2, nY2)
  local _Room1, _nX1, _nY1 = Ui.tbNewBag:GetTrueRoomPosByMaping(nRoom1, nX1, nY1)
  local _Room2, _nX2, _nY2 = Ui.tbNewBag:GetTrueRoomPosByMaping(nRoom2, nX2, nY2)
  if _Room1 == _Room2 and _nX1 == _nX2 and _nY1 == _nY2 then
    return 1
  end
  return 0
end

function tbItemRoom:GetFreePos()
  local nX, nY
  for j = 0, self.nLine - 1 do
    if nX and nY then
      break
    end
    for i = 0, self.nRow - 1 do
      if not self.tbObjs[j] then
        self.tbObjs[j] = {}
      end
      local tbObj = self.tbObjs[j][i]
      if not tbObj then
        nX = i
        nY = j
        break
      end
    end
  end
  return nX, nY
end

function tbItemRoom:SpecialStateRecvUse()
  local nX, nY = self:GetFreePos()
  if not nX or not nY then
    me.Msg("目标空间已满！")
    tbMouse:ResetObj()
    return 0
  else
    self:SwitchObj(nX, nY)
  end
end

function tbItemRoom:CanSendStateUse()
  local bCanSendUse = 0
  for i, nState in ipairs(MAPPING_STATE) do
    if UiManager:GetUiState(nState) == 1 then
      bCanSendUse = 1
      break
    end
  end
  return bCanSendUse
end

function tbItemRoom:CheckKinRepositoryRoom(nRoom)
  if nRoom >= Item.ROOM_KIN_REPOSITORY1 and nRoom <= Item.ROOM_KIN_REPOSITORY10 then
    return 1
  end
  return 0
end

function tbItemRoom:CheckBagRoom(nRoom)
  if nRoom == Item.ROOM_MAINBAG or nRoom == Item.ROOM_EXTBAG1 or nRoom == Item.ROOM_EXTBAG2 or nRoom == Item.ROOM_EXTBAG3 then
    return 1
  end
  return 0
end

-- tbPick表示拿再在手上的坐标
function tbItemRoom:KinRepSwitchItem(tbPick, nRoom, nX, nY)
  if not tbPick then
    return 0
  end
  if UiVersion == Ui.Version002 then
    tbPick.nRoom, tbPick.nX, tbPick.nY = Ui.tbNewBag:GetTrueRoomPosByMaping(tbPick.nRoom, tbPick.nX, tbPick.nY)
    nRoom, nX, nY = Ui.tbNewBag:GetTrueRoomPosByMaping(nRoom, nX, nY)
  end
  if self:CheckKinRepositoryRoom(tbPick.nRoom) ~= 1 and self:CheckKinRepositoryRoom(nRoom) ~= 1 then
    return 0
  end
  print(tbPick.nRoom, tbPick.nX, tbPick.nY, nRoom, nX, nY)
  local pPick = nil
  local pDrop = nil

  pPick = me.GetItem(tbPick.nRoom, tbPick.nX, tbPick.nY)
  pDrop = me.GetItem(nRoom, nX, nY)
  if not pPick then -- 操作的道具一定要存在
    return 0
  end
  if self:CheckKinRepositoryRoom(tbPick.nRoom) == 1 then
    if self:CheckBagRoom(nRoom) == 1 then -- 仓库往背包
      if not pDrop then -- 取东西
        KKinRepository.TakeItem(tbPick.nRoom, tbPick.nX, tbPick.nY, nRoom, nX, nY)
      else --交换
        KKinRepository.SwitchBagItem(tbPick.nRoom, tbPick.nX, tbPick.nY, nRoom, nX, nY)
      end
    elseif self:CheckKinRepositoryRoom(nRoom) == 1 then -- 仓库往仓库
      if tbPick.nRoom ~= nRoom then
        me.Msg("只能交换同一页道具")
        return 0
      end
      KKinRepository.SwitchRepItem(nRoom, tbPick.nX, tbPick.nY, nX, nY)
    end
  --背包往仓库
  elseif self:CheckBagRoom(tbPick.nRoom) == 1 then
    if not pDrop then
      KKinRepository.StoreItem(tbPick.nRoom, tbPick.nX, tbPick.nY, nRoom, nX, nY)
    else
      KKinRepository.SwitchBagItem(tbPick.nRoom, tbPick.nX, tbPick.nY, nRoom, nX, nY)
    end
  end
  return 0
end

function tbItemRoom:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_ITEM, self.RefreshItem, self }, -- 角色道具同步事件
  }
  local tbBaseReg = tbItemRoom._tbBase.RegisterEvent(self)
  return Lib:MergeTable(tbBaseReg, tbRegEvent)
end

------------------------------------------------------------------------------------------
