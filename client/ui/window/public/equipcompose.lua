-------------------------------------------------------
----文件名		：	equipcompose.lua
----创建者		：	xuantao@kingsoft.com
----创建时间	：	2012/6/25 12:50:18
----功能描述	：	装备合成，整合在一起，注意，窗口中空间的位置和显示关系，都是逻辑控制的
--------------------------------------------------------

local uiWnd = Ui:GetClass("equipcompose")
local tbObject = Ui.tbLogic.tbObject
local tbMouse = Ui.tbLogic.tbMouse
local tbTempItem = Ui.tbLogic.tbTempItem
local ENHITEM_INDEX = { nGenre = Item.SCRIPTITEM, nDetail = 1, nParticular = 114 } -- 玄晶
local ENHITEM_CLASS = Item.STRENGTHEN_STUFF_CLASS -- 强化道具类型：玄晶
local ENHANCE_DISCOUNT = "enhancediscount" --强化道具类型：强化优惠符
local ENHANCE_DELAY_BUFF = 342 -- 强化延迟buff，使用buff可能会出现异常情况
local ENHANCE_DELAY_SKILL = 1358 -- 强化延迟技能状态

uiWnd.BTN_ENHANCE_COMPOSE = "Btn_Enhance_Compose" -- 强化合成
uiWnd.BTN_SPLIT_TRANSFER = "Btn_Split_Transfer" -- 拆解转移
uiWnd.BTN_REFINE_RECAST = "Btn_Refine_Recast" -- 炼化重铸
uiWnd.BTN_CLOSE = "Btn_Close"

uiWnd.BTN_EQUIP_ENHANCE = "Btn_Equi_Enhance" -- 装备强化
uiWnd.BTN_EQUIP_GAIZHAO = "Btn_Equip_Gaizhao" -- 装备改造
uiWnd.BTN_YINJIAN_LEVELUP = "Btn_Yinjian_Levelup" -- 印鉴升级
uiWnd.BTN_XUANJIN_COMPOSE = "Btn_Xuanjin_Compose" -- 玄晶合成

uiWnd.BTN_XUANJIN_SPLIT = "Btn_Xuanjin_Split" -- 玄晶拆解
uiWnd.BTN_ENHANCE_TRANSFER = "Btn_Enhance_Transfer" -- 强化转移
uiWnd.BTN_WEAPON_SPLIT = "Btn_Weapon_Split" -- 武器拆解
uiWnd.BTN_GAOJI_XUANJIN_SPLIT = "Btn_Gaoji_Xuanjin_Split" -- 高级玄晶拆解

uiWnd.BTN_EQUIP_RECAST = "Btn_Equip_Recast" -- 装备重铸
uiWnd.BTN_EQUIP_LIANHUA = "Btn_Equip_Lianhua" -- 装备炼化
uiWnd.BTN_YINJIAN_RECAST = "Btn_Yinjian_Recast" -- 印鉴重铸

uiWnd.BTN_OK = "Btn_OK"
uiWnd.BTN_CANCEL = "Btn_Cancel"
uiWnd.BTN_SPLIT_APPLY = "Btn_Split_Apply" -- 申请拆解

uiWnd.BTN_SELECT_LEFT = "Z_Btn_Select_Left" -- 选择左边的装备
uiWnd.BTN_SELECT_RIGHT = "Z_Btn_Select_Right" -- 选择右边的装备

-- 五行印的熟悉选择
uiWnd.BTN_SERIES_STRENGTH = "Btn_Series_Strength" -- 五行相克强化
uiWnd.BTN_SERIES_WEEK = "Btn_Series_Week" -- 五行相克弱化

uiWnd.IMG_ENHANCE_CONPOSE = "Img_Enhance_Compose" -- 强化组合按钮组
uiWnd.IMG_SPLIT_TRANSFER = "Img_Split_Transfer" -- 拆解转移按钮组
uiWnd.IMG_REFINE_RECAST = "Img_Refine_Recast" -- 炼化重铸按钮组
uiWnd.IMG_TARGET_SET = "Img_Target_Set" -- 目标道具空间
uiWnd.IMG_SRC_SET = "Img_Src_Set" -- 原始道具空间
uiWnd.IMG_HELPER_SET = "Img_Helper_Set" -- 辅助道具空间
uiWnd.IMG_OBJ_GRID = "Img_Obj_Grid"
uiWnd.IMG_GRID = "Img_Grid"
uiWnd.IMG_MONEY = "Img_Money"
uiWnd.IMG_OP_OBJ = "Img_Op_Obj"
uiWnd.IMG_RECAST_VIEW = "Img_Recast_View" -- 重铸预览
uiWnd.IMG_SUCCESS_EFFECT = "Z_Img_Sucess_Effect" -- 成功特效

-- 箭头
uiWnd.IMG_ARROW_GAIZHAO = "Img_Arrow_Equip_Gaizhao"
uiWnd.IMG_ARROW_TRANS_L = "Img_Arrow_Trans_L"
uiWnd.IMG_ARROW_TRANS_R = "Img_Arrow_Trans_R"
uiWnd.IMG_ARROW_RECAST_L = "Img_Arrow_Recast_L"
uiWnd.IMG_ARROW_RECAST_R = "Img_Arrow_Recast_R"
uiWnd.IMG_ARROW_YINJIAN = "Img_Arrow_Yinjian"

uiWnd.OBJ_ITEM_GRID = "Obj_Item_Grid" -- 物品网格
uiWnd.BTN_BIND_MONEY = "Btn_Bind_Money" -- 绑定银两
uiWnd.BTN_NORMAL_MONEY = "Btn_Normal_Money" -- 普通银两

uiWnd.BTN_SRC_TRANSFER_LST = "Btn_Src_Transfer_Lst" -- 转移道具列表按钮
uiWnd.BTN_TARGET_EQUIP_LST = "Btn_Target_Equip_Lst" -- 目标装备列表按钮
uiWnd.OBJ_ITEM_GRID_TRANSFER = "Obj_Item_Grid_Transfer" -- 转移模拟的道具列表
uiWnd.OBJ_TRANSFER_HELPER = "Obj_Transfer_Helper" -- 转移辅助道具
uiWnd.OBJ_SRC_TRANSFER_EQUIP = "Obj_Src_Transfer_Equip" -- 原始转移装备
uiWnd.OBJ_TARGET_EQUIP = "Obj_Target_Equip" -- 目标转移装备
uiWnd.OBJ_ITEM_GRID_SPLIT = "Obj_Item_Grid_Split" -- 剥离输出结果
uiWnd.OBJ_RECAST_VIEW = "Obj_Recast_View" -- 装备重铸预览

uiWnd.IMG_YINJIAN = "Img_Yingjian" -- 印鉴属性选择列表
uiWnd.LST_YINJIAN = "Lst_Yingjian_Sel" -- 印鉴属性选择列表

uiWnd.TXT_DETAIL_DESC = "Txt_Detail_Desc" -- 操作详细描述
uiWnd.TXT_TARGET_DESC = "A_Txt_Target_Desc" -- 目标道具描述
uiWnd.TXT_SRC_DESC = "A_Txt_Src_Desc" -- 原始道具描述
uiWnd.TXT_HELPER_DESC = "A_Txt_Helper_Desc" -- 辅助道具描述
uiWnd.TXT_VIEW_RECAST_L = "A_Txt_Recast_L" -- 重铸生成装备描述
uiWnd.TXT_VIEW_RECAST_R = "A_Txt_Recast_R"
uiWnd.TXT_OP_DESC = "Txt_Op_Desc"
---------------------------------------------------------------------------------------------
-- 各个模式下的窗口配置
local tbOpWndPosInfo = {
  -- 装备强化
  [Item.ENHANCE_MODE_ENHANCE] = {
    -- wnd, pos_x, pos_y
    { uiWnd.IMG_TARGET_SET, 128, 024 },
    { uiWnd.BTN_TARGET_EQUIP_LST, nil, nil },
    { uiWnd.IMG_MONEY, 024, 082 },
    { uiWnd.TXT_DETAIL_DESC, 024, 113 },
    { uiWnd.OBJ_ITEM_GRID, nil, nil },
    { uiWnd.IMG_SUCCESS_EFFECT, nil, nil },
  },
  -- 玄晶合成
  [Item.ENHANCE_MODE_COMPOSE] = {
    { uiWnd.IMG_MONEY, 024, 026 },
    { uiWnd.TXT_DETAIL_DESC, 024, 074 },
    { uiWnd.OBJ_ITEM_GRID, nil, nil },
  },
  -- 印鉴升级
  [Item.ENHANCE_MODE_UPGRADE] = {
    { uiWnd.IMG_TARGET_SET, 128, 024 },
    { uiWnd.TXT_DETAIL_DESC, 024, 088 },
    { uiWnd.IMG_YINJIAN, nil, nil },
    { uiWnd.OBJ_ITEM_GRID, nil, nil },
    { uiWnd.IMG_SUCCESS_EFFECT, nil, nil },
  },
  -- 装备改造
  [Item.ENHANCE_MODE_STRENGTHEN] = {
    { uiWnd.IMG_TARGET_SET, 192, 021 },
    { uiWnd.BTN_TARGET_EQUIP_LST, nil, nil },
    { uiWnd.IMG_MONEY, 024, 082 },
    { uiWnd.TXT_DETAIL_DESC, 024, 111 },
    { uiWnd.IMG_HELPER_SET, 059, 021 },
    { uiWnd.OBJ_ITEM_GRID_TRANSFER, nil, nil },
    { uiWnd.IMG_SUCCESS_EFFECT, nil, nil },
    { uiWnd.IMG_ARROW_GAIZHAO, nil, nil },
  },
  -- 强化转移
  [Item.ENHANCE_MODE_ENHANCE_TRANSFER] = {
    { uiWnd.IMG_TARGET_SET, 128, 005 },
    { uiWnd.IMG_SRC_SET, 065, 063 },
    { uiWnd.BTN_SRC_TRANSFER_LST, nil, nil },
    { uiWnd.IMG_HELPER_SET, 192, 063 },
    { uiWnd.OBJ_ITEM_GRID_TRANSFER, nil, nil },
    { uiWnd.TXT_DETAIL_DESC, 024, 110 },
    { uiWnd.IMG_SUCCESS_EFFECT, nil, nil },
    { uiWnd.IMG_ARROW_TRANS_L, nil, nil },
    { uiWnd.IMG_ARROW_TRANS_R, nil, nil },
    { uiWnd.BTN_SPLIT_APPLY, nil, nil },
  },
  -- 玄晶剥离
  [Item.ENHANCE_MODE_PEEL] = {
    { uiWnd.IMG_TARGET_SET, 128, 035 },
    { uiWnd.BTN_TARGET_EQUIP_LST, nil, nil },
    { uiWnd.TXT_DETAIL_DESC, 024, 111 },
    { uiWnd.OBJ_ITEM_GRID_SPLIT, nil, nil },
    { uiWnd.BTN_SPLIT_APPLY, nil, nil },
    { uiWnd.IMG_SUCCESS_EFFECT, nil, nil },
  },
  -- 青铜武器剥离
  [Item.ENHANCE_MODE_WEAPON_PEEL] = {
    { uiWnd.IMG_TARGET_SET, 128, 035 },
    { uiWnd.BTN_TARGET_EQUIP_LST, nil, nil },
    { uiWnd.TXT_DETAIL_DESC, 024, 111 },
    { uiWnd.OBJ_ITEM_GRID_SPLIT, nil, nil },
    { uiWnd.BTN_SPLIT_APPLY, nil, nil },
  },
  -- 高级玄晶拆解
  [Item.ENHANCE_MODE_BREAKUP_XUAN] = {
    { uiWnd.IMG_TARGET_SET, 128, 035 },
    { uiWnd.TXT_DETAIL_DESC, 024, 111 },
    { uiWnd.OBJ_ITEM_GRID_SPLIT, nil, nil },
  },
  -- 装备炼化
  [Item.ENHANCE_MODE_REFINE] = {
    { uiWnd.IMG_SRC_SET, 065, 069 },
    { uiWnd.BTN_SRC_TRANSFER_LST, nil, nil },
    { uiWnd.TXT_DETAIL_DESC, 024, 124 },
    { uiWnd.IMG_HELPER_SET, 192, 069 },
    { uiWnd.OBJ_ITEM_GRID_TRANSFER, nil, nil },
    { uiWnd.IMG_RECAST_VIEW, 076, 009 },
    { uiWnd.IMG_SUCCESS_EFFECT, nil, nil },
    { uiWnd.IMG_ARROW_TRANS_L, nil, nil },
    { uiWnd.IMG_ARROW_TRANS_R, nil, nil },
  },
  -- 重铸道具
  [Item.ENHANCE_MODE_EQUIP_RECAST] = {
    { uiWnd.IMG_SRC_SET, 042, 169 },
    { uiWnd.BTN_SRC_TRANSFER_LST, nil, nil },
    { uiWnd.IMG_HELPER_SET, 211, 169 },
    { uiWnd.IMG_RECAST_VIEW, 076, 080 },
    { uiWnd.TXT_DETAIL_DESC, 024, 224 },
    { uiWnd.IMG_SUCCESS_EFFECT, nil, nil },
    { uiWnd.IMG_ARROW_RECAST_L, nil, nil },
    { uiWnd.IMG_ARROW_RECAST_R, nil, nil },
  },
  -- 印鉴重铸
  [Item.ENHANCE_MODE_YINJIAN_RECAST] = {
    { uiWnd.IMG_SRC_SET, 047, 099 },
    { uiWnd.IMG_TARGET_SET, 191, 099 },
    { uiWnd.TXT_DETAIL_DESC, 024, 180 },
    { uiWnd.IMG_SUCCESS_EFFECT, nil, nil },
    { uiWnd.IMG_ARROW_YINJIAN, nil, nil },
  },
}
---------------------------------------------------------------------------------------------
-- 操作基类
local tbBase = {}
-- 获得当前模式
function tbBase:GetMode()
  print("纯虚函数，子类必须实现")
  print(debug.traceback())
end
-- 构造
function tbBase:OnInit(tbWnd, szParticular, szDetail)
  self.tbWnd = tbWnd
  self.szParticular = szParticular -- 操作对应的按钮
  self.szDetail = szDetail
  self.nMoneyType = Item.BIND_MONEY
end
-- 进入模式
function tbBase:Enter()
  Btn_Check(self.tbWnd.UIGROUP, self.szDetail, 1)

  -- 隐藏所有操作窗口
  for _, tbCfg in pairs(tbOpWndPosInfo) do
    for _, tbWnd in pairs(tbCfg) do
      if tbWnd[1] then
        Wnd_Hide(self.tbWnd.UIGROUP, tbWnd[1])
      end
    end
  end

  local tbCfg = tbOpWndPosInfo[self:GetMode()]
  if not tbCfg then
    print(debug.traceback())
    return 0
  end
  -- 根据配置设置窗口布局
  for _, tbWnd in pairs(tbCfg) do
    if tbWnd[1] then
      Wnd_Show(self.tbWnd.UIGROUP, tbWnd[1])
    end
    if tbWnd[1] and tbWnd[2] and tbWnd[3] then
      Wnd_SetPos(self.tbWnd.UIGROUP, tbWnd[1], tbWnd[2], tbWnd[3])
    end
  end

  -- 清空描述
  Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "")
  Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_TARGET_DESC, "")
  Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_SRC_DESC, "")
  Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_HELPER_DESC, "")
  Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_OP_DESC, self:GetDesc())
  -- 特效窗口还是要隐藏的
  Wnd_Hide(self.tbWnd.UIGROUP, self.tbWnd.IMG_SUCCESS_EFFECT)
  -- 新版的界面
  if UiVersion == Ui.Version001 then
    Wnd_Hide(self.tbWnd.UIGROUP, self.tbWnd.BTN_TARGET_EQUIP_LST)
    Wnd_Hide(self.tbWnd.UIGROUP, self.tbWnd.BTN_SRC_TRANSFER_LST)
  end

  -- 每次都默认是绑定银两
  self.nMoneyType = Item.BIND_MONEY
end

-- 离开模式
function tbBase:Leave()
  Btn_Check(self.tbWnd.UIGROUP, self.szDetail, 0)
end
-- 确认，点击确认按钮
function tbBase:OnOk() end
-- 取消，点击取消按钮
function tbBase:OnCancel()
  UiManager:CloseWindow(self.tbWnd.UIGROUP)
end
-- 结果通知
function tbBase:OnResult(nResult, ...) end
-- 申请拆解，点击申请拆解按钮
function tbBase:ApplySplit()
  local nSplit = self:_CanSplit()
  local tbMsg = {}
  local tbFun = {}
  tbMsg.szTitle = "提  示"
  tbMsg.nOptCount = 2
  -- 如果已经申请，对应的就是取消申请
  if -1 == nSplit or 1 == nSplit then
    tbFun = { "ItemCmd", "CancelPeel" }
    tbMsg.szMsg = "你是否要取消剥离申请？取消后无法剥离强化等级12或以上的装备或青铜武器"
    tbMsg.bApply = 0
  else -- 申请操作
    tbFun = { "ItemCmd", "ApplyPeel" }
    tbMsg.szMsg = "强化等级12或以上的装备或青铜武器剥离起来颇为麻烦，我需要准备一个半时辰<color=red>(3小时)<color>，之后的四个时辰内我可以给你剥离，过时不候。一次申请只能剥<color=red>一件<color>装备。"
    tbMsg.bApply = 1
  end

  function tbMsg:Callback(nOptIndex, tbFun, tbOp)
    if nOptIndex == 2 then
      if not tbFun then
        return 0
      end
      me.CallServerScript(tbFun)
    end
  end

  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, tbFun, self)
end
-- 选择银两类型
function tbBase:SelectMoney(nType)
  self.nMoneyType = nType
  self:UpdateState()
end
-- 选择道具,就是点击列出装备,选择身上的装备
function tbBase:SelectBodyEquip(pEquip)
  return 0
end
-- 检测道具能否放下，返回1 or 0
function tbBase:CheckSwitch(tbCont, pDrop, pPick, nX, nY)
  return 0
end
-- 同步道具
function tbBase:OnSyncItem(nRoom, nX, nY)
  self:UpdateState()
end
-- 更新状态
function tbBase:UpdateState() end
-- 获取该操作的描述
function tbBase:GetDesc()
  return ""
end
-- 格式化道具
function tbBase:FormatItem(tbCont, tbItem)
  return tbCont._tbBase.FormatItem(tbCont, tbItem)
end
-- 更新道具
function tbBase:UpdateItem(tbCont, tbItem, nX, nY)
  tbCont._tbBase.UpdateItem(tbCont, tbItem, nX, nY)
end
-- 更新英两状态，也就是够不够，只是简单的判断
function tbBase:UpdateMoneyFlag(nMoney)
  if self.nMoneyType == Item.BIND_MONEY then
    self.nMoneyEnoughFlag = (me.GetBindMoney() >= nMoney) and 1 or 0
  elseif self.nMoneyType == Item.NORMAL_MONEY then
    self.nMoneyEnoughFlag = (me.nCashMoney >= nMoney) and 1 or 0
  elseif self.nMoneyType == Item.emEQUIP_RECAST_CURRENCY_LONGHUN then
    local nCount = me.GetItemCountInBags(unpack(Item.tbLonghunCurrencyItemId))
    self.nMoneyEnoughFlag = (nCount >= nMoney) and 1 or 0
  else
    print(debug.traceback())
    self.nMoneyEnoughFlag = 0
  end
end

function tbBase:StateReciveUse(pItem) end

function tbBase:CanLeave()
  return 1
end

function tbBase:OnBuffChange() end

-- 判定现在能够剥离青铜武器或高级装备剥离
--  0：表示没有申请
--  1：表示可以
-- -2：表示申请超时，需要重新申请，这个暂时实现不了了
-- -1：表示申请时间还没有到，需要耐心等待
function tbBase:_CanSplit()
  local nLevel, nType, nLeftTime = me.GetSkillState(ENHANCE_DELAY_SKILL)
  if not nLevel or nLevel <= 0 then
    return 0
  end

  if nLeftTime > (Item.MAX_PEEL_TIME - Item.VALID_PEEL_TIME) * Env.GAME_FPS then
    return -1
  else
    return 1
  end
end
-- 目标道具
function tbBase:_GetTargetItem()
  return me.GetEnhanceEquip()
end
-- 原始道具
function tbBase:_GetSrcItem()
  local tbCont = self.tbWnd:GetCont(self.tbWnd.OBJ_SRC_TRANSFER_EQUIP)
  local tbObj = tbCont:GetObj(0, 0)

  if tbObj and tbObj.nType == 5 then
    return me.GetItem(tbObj.nRoom, tbObj.nX, tbObj.nY)
  else
    return nil
  end
end
-- 辅助道具
function tbBase:_GetHelperItem()
  local tbCont = self.tbWnd:GetCont(self.tbWnd.OBJ_TRANSFER_HELPER)
  local tbObj = tbCont:GetObj(0, 0)

  if tbObj and tbObj.nType == 5 then
    return me.GetItem(tbObj.nRoom, tbObj.nX, tbObj.nY)
  else
    return nil
  end
end

---------------------------------------------------------------------------------------------
-- 强化装备
local tbEnhanceEquip = Lib:NewClass(tbBase)

function tbEnhanceEquip:GetMode()
  return Item.ENHANCE_MODE_ENHANCE
end

function tbEnhanceEquip:Enter()
  self.nDisCountEnhance = 0
  self._tbBase.Enter(self)

  Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_TARGET_DESC, "请放入装备")

  UiManager:SetUiState(UiManager.UIS_EQUIP_ENHANCE)
end

function tbEnhanceEquip:Leave()
  self._tbBase.Leave(self)
  self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):ClearRoom()
  self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID):ClearRoom()
  UiManager:ReleaseUiState(UiManager.UIS_EQUIP_ENHANCE)
end

function tbEnhanceEquip:OnOk()
  if self.nMoneyEnoughFlag == 0 then
    local szMoney = ""
    if self.nMoneyType == Item.BIND_MONEY then
      szMoney = "绑定银两"
    else
      szMoney = "银两"
    end

    me.Msg("您的" .. szMoney .. "不足以支付装备强化的费用，无法进行装备强化。")
  elseif self.bShowHighForbidden == 1 or self.bShowLowForbidden == 1 then
    local tbMsg = {}
    tbMsg.szMsg = ""
    if self.bShowHighForbidden == 1 then
      tbMsg.szMsg = "您放入的玄晶过多，请勿浪费。"
    elseif self.bShowLowForbidden == 1 then
      tbMsg.szMsg = "本次强化成功率过低，不可强化。"
    end
    tbMsg.nOptCount = 1
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
  elseif self.bMustPer100 and self.bMustPer100 == 1 then
    local tbMsg = {}
    tbMsg.szMsg = "使用强化优惠符强化需要成功率超过100%才能强化！"
    tbMsg.nOptCount = 1
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
  elseif self.nDisCountErrorFlag and self.nDisCountErrorFlag > 0 then
    local tbMsg = {}
    tbMsg.szMsg = ""
    if self.nDisCountErrorFlag == Item.ERROR_FLAG_ENHANCE_NOT_SAME_EHN_TIMES then
      tbMsg.szMsg = "你放入的强化符不是当前可以优惠的强化等级！"
    elseif self.nDisCountErrorFlag == Item.ERROR_FLAG_ENHANCE_NOT_SAME_EHN_EQUIP then
      tbMsg.szMsg = "你放入的强化符与当前强化的物品类型不一致！"
    end
    tbMsg.nOptCount = 1
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
  elseif self.bShowBindMsg == 1 or self.bShowWarnning == 1 then
    local tbMsg = {}
    local szReason = ""
    tbMsg.szMsg = ""
    if self.bShowWarnning == 1 then
      tbMsg.szMsg = "您这次强化<color=red>成功率不足100%<color>，"
    end
    if self.bShowBindMsg == 1 then
      if self.nMoneyType == Item.BIND_MONEY then
        szReason = "绑定银两"
      else
        szReason = "绑定的玄晶"
      end
      tbMsg.szMsg = tbMsg.szMsg .. string.format("使用<color=red>%s<color>强化装备，该装备与您<color=red>绑定<color>，", szReason)
    end

    tbMsg.szMsg = tbMsg.szMsg .. "是否继续？"
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex, nMode, nMoneyType, nProb)
      if nOptIndex == 2 then
        me.ApplyEnhance(nMode, nMoneyType, (nProb or 0))
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, Item.ENHANCE_MODE_ENHANCE, self.nMoneyType, self.nProb)
  else
    me.ApplyEnhance(Item.ENHANCE_MODE_ENHANCE, self.nMoneyType, (self.nProb or 0))
  end
end

function tbEnhanceEquip:OnCancel()
  if 1 == self.tbWnd:IsAllContEmpy() then
    UiManager:CloseWindow(self.tbWnd.UIGROUP)
    return
  end
  self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):ClearRoom()
  self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID):ClearRoom()
  self:UpdateState()
end

function tbEnhanceEquip:OnResult(nResult)
  self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID):ClearRoom()
  self.nDisCountEnhance = 0
  if nResult == 1 then
    self.tbWnd:PlayAnimation()
    me.Msg("你的装备强化成功！")
  elseif nResult == 0 then
    me.Msg("很遗憾，您这次装备强化失败了。")
  else
    me.Msg("无法进行装备强化！")
  end
end

function tbEnhanceEquip:StateReciveUse(pItem)
  if 1 == pItem.IsEquip() then
    if 1 == self:_CheckEquip(pItem) then
      self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):ClearRoom()
      self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):SpecialStateRecvUse()
    else
      tbMouse:ResetObj()
    end
  else
    if 1 == self:_CheckItem(pItem) then
      self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID):SpecialStateRecvUse()
    else
      tbMouse:ResetObj()
    end
  end
end

function tbEnhanceEquip:CheckSwitch(tbCont, pDrop, pPick, nX, nY)
  if not pDrop then
    --拿出来的是强化优惠符要做计数操作
    if pPick and pPick.szClass == "enhancediscount" then
      self.nDisCountEnhance = self.nDisCountEnhance - 1
      if self.nDisCountEnhance < 0 then
        self.nDisCountEnhance = 0
      end
    end
    return 1 -- 只是把东西拿出来，总是成功
  end

  if tbCont.szObjGrid == self.tbWnd.OBJ_ITEM_GRID then
    if 1 ~= self:_CheckItem(pDrop) then
      return 0
    end
    --放下的是优惠符
    self.nDisCountEnhance = self.nDisCountEnhance or 0
    if pDrop.szClass == "enhancediscount" then
      if self.nDisCountEnhance >= 1 then
        me.Msg("每次只能放入一个强化优惠符。")
        return 0
      end
      self.nDisCountEnhance = self.nDisCountEnhance + 1
    end
    --拿起的是优惠符
    if pPick and pPick.szClass == "enhancediscount" then
      if self.nDisCountEnhance < 1 then
        self.nDisCountEnhance = 1
      end
      self.nDisCountEnhance = self.nDisCountEnhance - 1
    end
  elseif tbCont.szObjGrid == self.tbWnd.OBJ_TARGET_EQUIP then
    if 1 ~= self:_CheckEquip(pDrop) then
      return 0
    end
  else
    assert(false)
    return 0
  end

  return 1
end
-- 检测能否放入装备
function tbEnhanceEquip:_CheckEquip(pEquip)
  if 1 ~= pEquip.IsEquip() then
    me.Msg("只能放置需要强化的装备！")
    return 0
  end
  if 1 == pEquip.IsWhite() then
    me.Msg("该物品不能强化！")
    return 0
  end
  if pEquip.GetLockIntervale() > 0 and self.nMoneyType == Item.BIND_MONEY then
    me.Msg("该装备只能用不绑银和不绑玄强化！")
    return 0
  end
  if pEquip.nEnhTimes >= Item:CalcMaxEnhanceTimes(pEquip) then
    me.Msg("该装备已经强化到极限了！")
    return 0
  end
  local nOpen = KGblTask.SCGetDbTaskInt(DBTASK_ENHANCESIXTEEN_OPEN)
  if nOpen == 1 and pEquip.nEnhTimes >= Item.nEnhTimesLimitOpen - 1 then
    me.Msg("强16功能暂不开放。")
    return 0
  end
  if (pEquip.nDetail < Item.MIN_COMMON_EQUIP) or (pEquip.nDetail > Item.MAX_COMMON_EQUIP) then
    me.Msg("参与五行激活的装备才能强化！")
    return 0
  end
  return 1
end
-- 检测能否放入道具
function tbEnhanceEquip:_CheckItem(pItem)
  if pItem.szClass ~= "enhancediscount" and pItem.szClass ~= Item.STRENGTHEN_STUFF_CLASS then
    me.Msg("只能放置需要的玄晶或强化优惠符！")
    return 0
  end
  if pItem.szClass == "enhancediscount" and self.nDisCountEnhance >= 1 then
    me.Msg("每次只能放入一个强化优惠符。")
    return 0
  end
  return 1
end
-- 更新状态
function tbEnhanceEquip:UpdateState()
  local pEquip = me.GetEnhanceEquip()
  Wnd_SetEnable(self.tbWnd.UIGROUP, self.tbWnd.BTN_OK, 0)

  if pEquip and (pEquip.nEnhTimes >= Item:CalcMaxEnhanceTimes(pEquip)) then -- 在刚刚执行完最高级别强化操作时容器里的装备是不能再进行强化的
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "◆您的装备已经成功地被强化到了极限！")
    return
  end

  local tbEnhItem = {}
  for j = 0, Item.ROOM_ENHANCE_ITEM_HEIGHT - 1 do
    for i = 0, Item.ROOM_ENHANCE_ITEM_WIDTH - 1 do
      local pEnhItem = me.GetEnhanceItem(i, j)
      if pEnhItem and (pEnhItem.szClass == "enhancediscount" or pEnhItem.szClass == Item.STRENGTHEN_STUFF_CLASS) then
        table.insert(tbEnhItem, pEnhItem)
      end
    end
  end

  if (not pEquip) and (#tbEnhItem <= 0) then
    local szReason = ""
    if self.nMoneyType == Item.BIND_MONEY then
      szReason = "目前是用绑定银两进行强化，强化成功后装备会与您绑定"
    else
      szReason = "请注意，使用绑定的玄晶强化未绑定的装备时，该装备也会被绑定。"
    end
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, string.format("◆请把要强化的装备放到上面的格子，玄晶放入下面的格子，然后点击“确定”进行强化。\n<color=yellow>%s", szReason))
  elseif (not pEquip) and (#tbEnhItem > 0) then
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "◆请在上面的格子中放入需要强化的装备。")
  elseif pEquip and (#tbEnhItem <= 0) then
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "◆请在下面的格子中放入玄晶。")
  else
    -- by zhangjinpin@kingsoft
    local nProb, nMoney, bBind, _, nValue, nTrueProb, bHasDisItem, nDisCountErrorFlag = Item:CalcEnhanceProb(pEquip, tbEnhItem, self.nMoneyType)

    self.nProb = nProb
    if self.nMoneyType == Item.BIND_MONEY then
      self.nMoneyEnoughFlag = (me.GetBindMoney() >= nMoney) and 1 or 0
    else
      self.nMoneyEnoughFlag = (me.nCashMoney >= nMoney) and 1 or 0
    end

    local szMsg = string.format("◆本次强化需要收取<color=yellow>%s银两<color>%s%d两%s。(目前银两汇率是<color=yellow>%d<color>)\n◆强化成功率预测：%d%%。\n", (self.nMoneyType == Item.NORMAL_MONEY) and "普通" or "绑定", (self.nMoneyEnoughFlag == 1) and "" or "<color=red>", nMoney, (self.nMoneyEnoughFlag == 1) and "" or "<color>", Item:GetJbPrice() * 100, nProb)

    -- *******合服优惠，合服7天后过期*******
    if GetTime() < KGblTask.SCGetDbTaskInt(DBTASK_COZONE_TIME) + 7 * 24 * 60 * 60 then
      szMsg = "<color=yellow>◆合并服务器优惠活动，你强化装备将减少20%费用\n<color>" .. szMsg
    end
    -- *************************************

    -- by zhangjinpin@kingsoft
    if nProb < 10 then
      self.bShowLowForbidden = 1
    else
      self.bShowLowForbidden = 0
    end

    if nTrueProb > 120 and nValue > 16796 then
      self.bShowHighForbidden = 1
    else
      self.bShowHighForbidden = 0
    end

    if nProb < 100 then
      szMsg = szMsg .. "◆若想提高成功率，可以放入更多的玄晶。\n"
    end
    if nProb < 100 and pEquip.nEnhTimes >= 11 then
      self.bShowWarnning = 1
    else
      self.bShowWarnning = 0
    end

    if nProb < 100 and bHasDisItem == 1 then
      self.bMustPer100 = 1
    else
      self.bMustPer100 = 0
    end

    if nDisCountErrorFlag > 0 then
      self.nDisCountErrorFlag = nDisCountErrorFlag
    else
      self.nDisCountErrorFlag = 0
    end

    if pEquip.IsBind() == 1 then -- 装备本身绑定的不提示
      self.bShowBindMsg = 0
    else
      self.bShowBindMsg = bBind
    end
    local szTime = me.GetItemAbsTimeout(pEquip) or me.GetItemRelTimeout(pEquip)
    if szTime then
      self.bShowTimeMsg = 1
    else
      self.bShowTimeMsg = 0
    end
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, szMsg)
    Wnd_SetEnable(self.tbWnd.UIGROUP, self.tbWnd.BTN_OK, 1)
  end
end

function tbEnhanceEquip:GetDesc()
  return "使用玄晶银两提升装备基础属性，每到一定阶段还能激活装备的强化属性。"
end

function tbEnhanceEquip:SelectBodyEquip(tbObj)
  if tbObj and tbObj.pItem and 1 == self:_CheckEquip(tbObj.pItem) then
    self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):ClearRoom()
    tbMouse:SetObj(tbObj)
    self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):SpecialStateRecvUse()
    return 1
  else
    return 0
  end
end

function tbEnhanceEquip:OnSyncItem(nRoom, nX, nY)
  if nRoom ~= Item.ROOM_ENHANCE_EQUIP and nRoom ~= Item.ROOM_ENHANCE_ITEM then
    return
  end

  self:UpdateState()
end
---------------------------------------------------------------------------------------------
-- 玄晶合成
local tbXuanjingCompose = Lib:NewClass(tbBase)

function tbXuanjingCompose:GetMode()
  return Item.ENHANCE_MODE_COMPOSE -- 玄晶合成
end

function tbXuanjingCompose:Enter()
  self._tbBase.Enter(self)

  UiManager:SetUiState(UiManager.UIS_EQUIP_COMPOSE)
end

function tbXuanjingCompose:Leave()
  self._tbBase.Leave(self)
  self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID):ClearRoom()
  UiManager:ReleaseUiState(UiManager.UIS_EQUIP_COMPOSE)
end

function tbXuanjingCompose:OnOk()
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
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, self:GetMode(), self.nMoneyType, self.nProb)
  else
    me.ApplyEnhance(self:GetMode(), self.nMoneyType, (self.nProb or 0))
  end
end

function tbXuanjingCompose:OnCancel()
  if 1 == self.tbWnd:IsAllContEmpy() then
    UiManager:CloseWindow(self.tbWnd.UIGROUP)
    return
  end
  self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID):ClearRoom()
  self:UpdateState()
end

function tbXuanjingCompose:OnResult(nResult)
  self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID):ClearRoom()
  if nResult > 0 then
    me.Msg("你成功合成一个" .. nResult .. "级玄晶！")
  end
end

function tbXuanjingCompose:StateReciveUse(pItem)
  self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID):SpecialStateRecvUse()
end

function tbXuanjingCompose:CheckSwitch(tbCont, pDrop, pPick, nX, nY)
  if not pDrop then
    return 1
  elseif tbCont.szObjGrid ~= self.tbWnd.OBJ_ITEM_GRID then
    return 0
  elseif pDrop.szClass ~= Item.STRENGTHEN_STUFF_CLASS then
    me.Msg("只能放置需要的玄晶！")
    return 0
  elseif pDrop.nLevel >= 12 then
    me.Msg("只有12级以下玄晶才能合成！")
    return 0
  end

  return 1
end

function tbXuanjingCompose:UpdateState()
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

  Wnd_SetEnable(self.tbWnd.UIGROUP, self.tbWnd.BTN_OK, 0)

  if #tbEnhItem <= 0 then
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "◆请在下面的格子中放入玄晶。")
  else
    local nMinLevel, nMinLevelRate, nMaxLevel, nMaxLevelRate, nFee, bBind, tbAbsTime = Item:GetComposeBudget(tbEnhItem, self.nMoneyType)
    local nMaxLevelInComItem = Item:GetComItemMaxLevel(tbEnhItem)
    if nMinLevel <= 0 then
      return 0
    end

    self:UpdateMoneyFlag(nFee)

    if nMinLevel == 0 then
      Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "◆合成物中有非玄晶道具，不能合成！")
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

      Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, szMsg)

      if (#tbEnhItem > 0) and bMaxLevelForbid == 0 then
        Wnd_SetEnable(self.tbWnd.UIGROUP, self.tbWnd.BTN_OK, 1)
      end
    end
  end
end

function tbXuanjingCompose:GetDesc()
  return "将低级的玄晶合成为高级的玄晶，高级玄晶能节省玩家背包空间，同时也方便于高阶段的装备强化。"
end
---------------------------------------------------------------------------------------------
-- 印鉴升级
local tbYinJianLevelUp = Lib:NewClass(tbBase)

function tbYinJianLevelUp:GetMode()
  return Item.ENHANCE_MODE_UPGRADE -- 印鉴升级
end

function tbYinJianLevelUp:Enter()
  self._tbBase.Enter(self)

  Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_TARGET_DESC, "请放入印鉴")
  self.nCurSel = nil
  self:_ClearSelect()

  UiManager:SetUiState(UiManager.UIS_EQUIP_UPGRADE)
end

function tbYinJianLevelUp:Leave()
  self._tbBase.Leave(self)
  self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID):ClearRoom()
  self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):ClearRoom()
  UiManager:ReleaseUiState(UiManager.UIS_EQUIP_UPGRADE)
end

function tbYinJianLevelUp:OnOk()
  if not self.nCurSel or self.nCurSel == 0 then
    me.Msg("请选择要升级的熟悉！")
    return 0
  end
  me.ApplyUpgradeSignet(self.nCurSel, self.nMoneyType)
end

function tbYinJianLevelUp:OnCancel()
  if 1 == self.tbWnd:IsAllContEmpy() then
    UiManager:CloseWindow(self.tbWnd.UIGROUP)
    return
  end
  self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID):ClearRoom()
  self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):ClearRoom()
  self:UpdateState()
end

function tbYinJianLevelUp:OnResult(nResult)
  if nResult > 0 then
    local pEquip = me.GetEnhanceEquip()
    self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID):ClearRoom()
    self.tbWnd:PlayAnimation()

    me.Msg("您的印鉴升级成功！")
  else
    me.Msg("您的印鉴升级失败！")
  end
end

function tbYinJianLevelUp:StateReciveUse(pItem)
  if 1 == pItem.IsEquip() then
    if 1 == self:_CheckEquip(pItem) then
      self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):ClearRoom()
      self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):SpecialStateRecvUse()
    else
      tbMouse:ResetObj()
    end
  else
    if 1 == self:_CheckItem(pItem) then
      self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID):SpecialStateRecvUse()
    else
      tbMouse:ResetObj()
    end
  end
end

function tbYinJianLevelUp:CheckSwitch(tbCont, pDrop, pPick, nX, nY)
  -- 拿起
  if not pDrop then
    return 1
  elseif tbCont.szObjGrid == self.tbWnd.OBJ_TARGET_EQUIP then
    return self:_CheckEquip(pDrop)
  elseif tbCont.szObjGrid == self.tbWnd.OBJ_ITEM_GRID then
    return self:_CheckItem(pDrop)
  else
    return 0
  end
  return 1
end

function tbYinJianLevelUp:_CheckEquip(pItem)
  if pItem.nDetail ~= Item.EQUIP_SIGNET then
    me.Msg("只能放入印鉴进行升级！")
    return 0
  end
  return 1
end

function tbYinJianLevelUp:_CheckItem(pItem)
  if pItem.szClass ~= Item.UPGRADE_ITEM_CLASS then
    me.Msg("只能放置魂石！")
    return 0
  end
  return 1
end

function tbYinJianLevelUp:UpdateState()
  local pEquip = me.GetEnhanceEquip()
  Wnd_SetEnable(self.tbWnd.UIGROUP, self.tbWnd.BTN_OK, 0)
  if not pEquip then
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "◆请在上方的格子中放入印鉴！")
    self:_ClearSelect()
    return
  end

  local nItemNum = 0
  for j = 0, Item.ROOM_ENHANCE_ITEM_HEIGHT - 1 do
    for i = 0, Item.ROOM_ENHANCE_ITEM_WIDTH - 1 do
      local pItem = me.GetEnhanceItem(i, j)
      if pItem and pItem.szClass == Item.UPGRADE_ITEM_CLASS then
        nItemNum = nItemNum + pItem.nCount
      end
    end
  end
  if nItemNum == 0 then
    self:_ClearSelect()
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "◆请放入五行魂石:")
    return 0
  end

  local tbAttrib = pEquip.GetBaseAttrib()
  for i, tbMA in ipairs(tbAttrib) do
    local szDesc = FightSkill:GetMagicDesc(tbAttrib[i].szName, tbAttrib[i].tbValue, nil, 1)
    if szDesc ~= "" then
      if 1 == i then
        Wnd_Show(self.tbWnd.UIGROUP, self.tbWnd.BTN_SERIES_STRENGTH)
        Btn_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.BTN_SERIES_STRENGTH, szDesc)
      elseif 2 == i then
        Wnd_Show(self.tbWnd.UIGROUP, self.tbWnd.BTN_SERIES_WEEK)
        Btn_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.BTN_SERIES_WEEK, szDesc)
      else
        print("印鉴升级不支持超过三个选项")
        print(debug.traceback())
      end
    end
  end

  if not self.nCurSel then
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "◆请选择升级哪条属性:")
    return 0
  end

  local nCurLevel, nCurExp, nCurUpGradeExp = Item:CalcUpgrade(pEquip, self.nCurSel, 0)
  if nCurLevel >= Item.tbMAX_SIGNET_LEVEL[pEquip.nLevel] then
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "◆该属性已升级到极限！")
    return
  end

  local tbAttrib = pEquip.GetBaseAttrib()
  local szDesc = FightSkill:GetMagicDesc(tbAttrib[self.nCurSel].szName, tbAttrib[self.nCurSel].tbValue, nil, 1)
  local nLevel, nExp, nUpgradeExp = Item:CalcUpgrade(pEquip, self.nCurSel, nItemNum)
  local szIsFull = tonumber(nUpgradeExp)
  if nLevel >= Item.tbMAX_SIGNET_LEVEL[pEquip.nLevel] then
    szIsFull = "<属性已经到上限>"
  end
  local szMsg = string.format("◆%s(%d/%d)\n<color=gold>  →增加%d点(%d/%s)<color>", szDesc, nCurExp, nCurUpGradeExp, nLevel, nExp, szIsFull)

  Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, szMsg)
  Wnd_SetEnable(self.tbWnd.UIGROUP, self.tbWnd.BTN_OK, 1)
end

function tbYinJianLevelUp:GetDesc()
  return "使用五行魂石提高印鉴的五行相克属性。"
end

function tbYinJianLevelUp:_SelectSeries(szBtn)
  Btn_Check(self.tbWnd.UIGROUP, self.tbWnd.BTN_SERIES_STRENGTH, 0)
  Btn_Check(self.tbWnd.UIGROUP, self.tbWnd.BTN_SERIES_WEEK, 0)
  if szBtn == self.tbWnd.BTN_SERIES_STRENGTH then
    self.nCurSel = 1
    Btn_Check(self.tbWnd.UIGROUP, self.tbWnd.BTN_SERIES_STRENGTH, 1)
  elseif szBtn == self.tbWnd.BTN_SERIES_WEEK then
    self.nCurSel = 2
    Btn_Check(self.tbWnd.UIGROUP, self.tbWnd.BTN_SERIES_WEEK, 1)
  end
  self:UpdateState()
end

function tbYinJianLevelUp:_ClearSelect()
  Btn_Check(self.tbWnd.UIGROUP, self.tbWnd.BTN_SERIES_STRENGTH, 0)
  Btn_Check(self.tbWnd.UIGROUP, self.tbWnd.BTN_SERIES_WEEK, 0)
  Wnd_Hide(self.tbWnd.UIGROUP, self.tbWnd.BTN_SERIES_STRENGTH)
  Wnd_Hide(self.tbWnd.UIGROUP, self.tbWnd.BTN_SERIES_WEEK)
  self.nCurSel = nil
end
---------------------------------------------------------------------------------------------
-- 装备改造
local tbEquipGaiZhao = Lib:NewClass(tbBase)

function tbEquipGaiZhao:GetMode()
  return Item.ENHANCE_MODE_STRENGTHEN -- 装备改造
end

function tbEquipGaiZhao:Enter()
  self._tbBase.Enter(self)
  Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_TARGET_DESC, "强15的装备")
  Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_HELPER_DESC, "请放入改造符")
  UiManager:SetUiState(UiManager.UIS_EQUIP_STRENGTHEN)
end

function tbEquipGaiZhao:Leave()
  self._tbBase.Leave(self)
  self.tbWnd:GetCont(self.tbWnd.OBJ_TRANSFER_HELPER):ClearObj()
  self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID_TRANSFER):ClearObj()
  self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):ClearRoom()
  self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID):ClearRoom()
  UiManager:ReleaseUiState(UiManager.UIS_EQUIP_STRENGTHEN)
end

function tbEquipGaiZhao:OnOk()
  local tbMsg = {}
  tbMsg.szMsg = ""
  if self.nMoneyEnoughFlag == 0 then
    local szMoney = ""
    if self.nMoneyType == Item.BIND_MONEY then
      szMoney = "绑定银两"
    else
      szMoney = "银两"
    end
    me.Msg("您的" .. szMoney .. "不足以支付装备改造的费用，无法进行装备改造。")
  elseif self.bShowHighForbidden == 1 then
    tbMsg.szMsg = "您放入的玄晶过多，请勿浪费。"
    tbMsg.nOptCount = 1
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, self.nMode, self.nMoneyType)
  elseif self.bShowBindMsg == 1 then
    local tbMsg = {}
    local szReason = ""
    tbMsg.szMsg = ""
    if self.nMoneyType == Item.BIND_MONEY then
      szReason = "绑定银两"
    else
      szReason = "绑定的玄晶"
    end

    tbMsg.szMsg = tbMsg.szMsg .. string.format("使用<color=red>%s<color>改在装备，该装备与您<color=red>绑定<color>，", szReason)

    tbMsg.szMsg = tbMsg.szMsg .. "是否继续？"
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex, nMode, nMoneyType, nProb)
      if nOptIndex == 2 then
        me.ApplyEnhance(nMode, nMoneyType, (nProb or 0))
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, Item.ENHANCE_MODE_STRENGTHEN, self.nMoneyType, self.nProb)
  else
    me.ApplyEnhance(Item.ENHANCE_MODE_STRENGTHEN, self.nMoneyType, (self.nProb or 0))
  end
end

function tbEquipGaiZhao:OnCancel()
  if 1 == self.tbWnd:IsAllContEmpy() then
    UiManager:CloseWindow(self.tbWnd.UIGROUP)
    return
  end
  self.tbWnd:GetCont(self.tbWnd.OBJ_TRANSFER_HELPER):ClearObj()
  self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID_TRANSFER):ClearObj()
  self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):ClearRoom()
  self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID):ClearRoom()
  self:UpdateState()
end

function tbEquipGaiZhao:OnResult(nResult)
  if nResult > 0 then
    self.tbWnd:GetCont(self.tbWnd.OBJ_TRANSFER_HELPER):ClearObj()
    self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID_TRANSFER):ClearObj()
    self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID):ClearRoom()
    self.tbWnd:PlayAnimation()
    me.Msg("你的装备改造成功！")
  elseif nResult == 0 then
    me.Msg("装备改造失败！")
  end
end

function tbEquipGaiZhao:StateReciveUse(pItem)
  if 1 == pItem.IsEquip() then
    if 1 == self:_CheckEquip(pItem) then
      self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):ClearRoom()
      self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):SpecialStateRecvUse()
    else
      tbMouse:ResetObj()
    end
  elseif Item.STRENGTHEN_RECIPE_CALSS[pItem.szClass] then
    self.tbWnd:GetCont(self.tbWnd.OBJ_TRANSFER_HELPER):SwitchObj(0, 0)
  else
    if 1 == self:_CheckItem(pItem) then
      self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID_TRANSFER):SpecialStateRecvUse()
    else
      tbMouse:ResetObj()
    end
  end
end

function tbEquipGaiZhao:CheckSwitch(tbCont, pDrop, pPick, nX, nY)
  if not pDrop then
    return 1
  elseif tbCont.szObjGrid == self.tbWnd.OBJ_TARGET_EQUIP then
    return self:_CheckEquip(pDrop)
  elseif tbCont.szObjGrid == self.tbWnd.OBJ_TRANSFER_HELPER then
    return self:_CheckHelp(pDrop)
  elseif tbCont.szObjGrid == self.tbWnd.OBJ_ITEM_GRID_TRANSFER then
    return self:_CheckItem(pDrop)
  elseif tbCont.szObjGrid == self.tbWnd.OBJ_ITEM_GRID then
    if (pDrop.szClass == Item.STRENGTHEN_STUFF_CLASS) or Item.STRENGTHEN_RECIPE_CALSS[pDrop.szClass] then
      return 1
    else
      me.Msg("只能放置需要的玄晶或改造符")
      return 0
    end
  else
    assert(false)
    return 0
  end
  return 1
end

function tbEquipGaiZhao:_CheckEquip(pItem)
  if 1 ~= pItem.IsEquip() then
    return 0
  end
  if 1 == pItem.IsWhite() then
    me.Msg("该物品不能改造！")
    return 0
  end
  if pItem.GetLockIntervale() > 0 and self.nMoneyType == Item.BIND_MONEY then
    me.Msg("该装备只能用不绑银和不绑玄改造！")
    return 0
  end
  if pItem.nEnhTimes <= 0 then
    me.Msg("未强化过装备不能改造！")
    return 0
  end
  if (pItem.nDetail < Item.MIN_COMMON_EQUIP) or (pItem.nDetail > Item.MAX_COMMON_EQUIP) then
    me.Msg("参与五行激活的装备才能进行改造！")
    return 0
  end
  return 1
end

function tbEquipGaiZhao:_CheckItem(pItem)
  if pItem.szClass ~= Item.STRENGTHEN_STUFF_CLASS then
    me.Msg("只能放置需要的玄晶或改造符")
    return 0
  end
  return 1
end

function tbEquipGaiZhao:_CheckHelp(pItem)
  if not Item.STRENGTHEN_RECIPE_CALSS[pItem.szClass] then
    me.Msg("只能放置需要的改造符")
    return 0
  end
  return 1
end

function tbEquipGaiZhao:UpdateState()
  local tbStrItem = {}
  for j = 0, Item.ROOM_ENHANCE_ITEM_HEIGHT - 1 do
    for i = 0, Item.ROOM_ENHANCE_ITEM_WIDTH - 1 do
      local pStrItem = me.GetEnhanceItem(i, j)
      if pStrItem then
        table.insert(tbStrItem, pStrItem)
      end
    end
  end

  Wnd_SetEnable(self.tbWnd.UIGROUP, self.tbWnd.BTN_OK, 0)

  local pEquip = self:_GetTargetItem()
  local pHelper = self:_GetHelperItem()

  if (not pEquip) and (#tbStrItem <= 0) then
    local szReason = ""
    if self.nMoneyType == Item.BIND_MONEY then
      szReason = "目前是用绑定银两进行改造，改造成功后装备会与您绑定"
    else
      szReason = "请注意，使用绑定的玄晶改造未绑定的装备时，该装备也会被绑定。"
    end
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, string.format("◆请把要改造的装备放到上面的格子，玄晶放入下面的格子，然后点击“确定”进行改造。\n<color=yellow>%s", szReason))
  elseif not pEquip then
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "◆请在上面的格子中放入需要改造的装备。")
  elseif Item:CheckStrengthenEquip(pEquip) ~= 1 then
    local _, szMsg = Item:CheckStrengthenEquip(pEquip)
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "<color=yellow>◆" .. szMsg .. "<color>")
  elseif not pHelper then
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "◆请在上面的格子中放入改造符。")
  elseif #tbStrItem <= 1 then
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "◆请在下面的格子中放入玄晶。")
  elseif Item:CalStrengthenStuff(pEquip, tbStrItem) == 0 then
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "◆您放入的道具不能够完成改造。<color=red>请查看改造符和道具是否匹配<color>")
  else
    local nRes, szMsg, nValue, bBind, tbStuffItem, pStrengthenRecipe = Item:CalStrengthenStuff(pEquip, tbStrItem)
    local nProb, nMoney, nTrueProb = Item:CalcProb(pEquip, nValue, Item.ENHANCE_MODE_STRENGTHEN)
    if self.nMoneyType == Item.BIND_MONEY then
      bBind = 1
    end
    self.nProb = nProb
    -- 只要判断钱够不够
    self:UpdateMoneyFlag(nMoney)

    local szMsg = string.format("◆本次改造需要收取<color=yellow>%s银两<color>%s%d两%s。(目前银两汇率是<color=yellow>%d<color>)\n◆当前改造度为：%d%%。\n", (self.nMoneyType == Item.NORMAL_MONEY) and "普通" or "绑定", (self.nMoneyEnoughFlag == 1) and "" or "<color=red>", nMoney, (self.nMoneyEnoughFlag == 1) and "" or "<color>", Item:GetJbPrice() * 100, nProb)

    -- *******合服优惠，合服7天后过期*******
    if GetTime() < KGblTask.SCGetDbTaskInt(DBTASK_COZONE_TIME) + 7 * 24 * 60 * 60 then
      szMsg = "<color=yellow>◆合并服务器优惠活动，你改造装备将减少20%费用\n<color>" .. szMsg
    end
    -- *************************************

    if nTrueProb > 120 then
      self.bShowHighForbidden = 1
    else
      self.bShowHighForbidden = 0
    end

    if nProb < 100 then
      szMsg = szMsg .. "◆若想提高改造度，可以放入更多的玄晶。\n"
    end

    if pEquip.IsBind() == 1 then -- 装备本身绑定的不提示
      self.bShowBindMsg = 0
    else
      self.bShowBindMsg = bBind
    end
    local szTime = me.GetItemAbsTimeout(pEquip) or me.GetItemRelTimeout(pEquip)
    if szTime then
      self.bShowTimeMsg = 1
    else
      self.bShowTimeMsg = 0
    end
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, szMsg)
    if nProb >= 100 and pStrengthenRecipe then
      Wnd_SetEnable(self.tbWnd.UIGROUP, self.tbWnd.BTN_OK, 1)
    end
  end
end

function tbEquipGaiZhao:GetDesc()
  return "当装备强到+15时，只要在奇珍阁购买一个强15改造符，就能用相对较少的玄晶银两令你的装备获得不俗的提升。"
end

function tbEquipGaiZhao:SelectBodyEquip(tbObj)
  if tbObj and tbObj.pItem and 1 == self:_CheckEquip(tbObj.pItem) then
    self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):ClearRoom()
    tbMouse:SetObj(tbObj)
    self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):SpecialStateRecvUse()
    return 1
  else
    return 0
  end
end

---------------------------------------------------------------------------------------------
-- 强化转移
local tbEnhanceTransfer = Lib:NewClass(tbBase)

function tbEnhanceTransfer:GetMode()
  return Item.ENHANCE_MODE_ENHANCE_TRANSFER -- 强化转移
end

function tbEnhanceTransfer:Enter()
  self._tbBase.Enter(self)
  self.nTransferLowEquit = 0

  Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_TARGET_DESC, "被转移的装备")
  Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_SRC_DESC, "转移的装备")
  Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_HELPER_DESC, "强化传承符")

  UiManager:SetUiState(UiManager.UIS_EQUIP_TRANSFER)
end

function tbEnhanceTransfer:Leave()
  self._tbBase.Leave(self)

  self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID_TRANSFER):ClearObj()
  self.tbWnd:GetCont(self.tbWnd.OBJ_SRC_TRANSFER_EQUIP):ClearObj()
  self.tbWnd:GetCont(self.tbWnd.OBJ_TRANSFER_HELPER):ClearObj()
  self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):ClearRoom()
  self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID):ClearRoom()

  UiManager:ReleaseUiState(UiManager.UIS_EQUIP_TRANSFER)
end

function tbEnhanceTransfer:OnOk()
  if self.nMoneyEnoughFlag == 0 then
    me.Msg("您的银两不足以支付强化转移的费用，无法进行强化转移。")
    return
  end
  local tbMsg = {}
  tbMsg.szMsg = ""
  if self.bShowHighForbidden == 1 then
    tbMsg.szMsg = "您放入的玄晶过多，请勿浪费。"
    tbMsg.nOptCount = 1
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, self.nMode, self.nMoneyType)
  end
  tbMsg.szMsg = "转移后的装备会<color=green>强制与您绑定<color>，"
  if self.nMoneyEnoughFlag == 1 then
    tbMsg.szMsg = "<color=red>将消费银两来代替绑银不足部分，<color>"
  end
  tbMsg.szMsg = tbMsg.szMsg .. "是否继续？"
  tbMsg.nOptCount = 2

  function tbMsg:Callback(nOptIndex, nMode, nMoneyType, nProb)
    if nOptIndex == 2 then
      me.ApplyEnhance(nMode, nMoneyType, (nProb or 0))
    end
  end

  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, Item.ENHANCE_MODE_ENHANCE_TRANSFER, self.nMoneyType, self.nProb)
end

function tbEnhanceTransfer:OnCancel()
  if 1 == self.tbWnd:IsAllContEmpy() then
    UiManager:CloseWindow(self.tbWnd.UIGROUP)
    return
  end
  self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID_TRANSFER):ClearObj()
  self.tbWnd:GetCont(self.tbWnd.OBJ_SRC_TRANSFER_EQUIP):ClearObj()
  self.tbWnd:GetCont(self.tbWnd.OBJ_TRANSFER_HELPER):ClearObj()
  self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):ClearRoom()
  self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID):ClearRoom()
  self:UpdateState()
end

function tbEnhanceTransfer:OnResult(nResult)
  self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID_TRANSFER):ClearObj()
  self.tbWnd:GetCont(self.tbWnd.OBJ_SRC_TRANSFER_EQUIP):ClearObj()
  self.tbWnd:GetCont(self.tbWnd.OBJ_TRANSFER_HELPER):ClearObj()
  self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID):ClearRoom()

  if nResult > 0 then
    self.tbWnd:PlayAnimation()
  elseif nResult == 0 then
    me.Msg("装备转移失败！")
  end
end

function tbEnhanceTransfer:StateReciveUse(pItem)
  if pItem.szClass == Item.ENHANCE_TRANSFER then
    self.tbWnd:GetCont(self.tbWnd.OBJ_TRANSFER_HELPER):SwitchObj(0, 0)
    tbMouse:ResetObj()
  elseif 1 == pItem.IsEquip() then
    if nil == self:_GetTargetItem() then
      if 1 == self:_CheckDest(pItem) then
        self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):SpecialStateRecvUse()
      else
        tbMouse:ResetObj()
      end
    else
      if 1 == self:_CheckSrc(pItem) then
        self.tbWnd:GetCont(self.tbWnd.OBJ_SRC_TRANSFER_EQUIP):SwitchObj(0, 0)
        tbMouse:ResetObj()
      else
        tbMouse:ResetObj()
      end
    end
  else
    if 1 == self:_CheckXuanjin(pItem) then
      self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID_TRANSFER):SpecialStateRecvUse()
    else
      tbMouse:ResetObj()
    end
  end
end

function tbEnhanceTransfer:_CheckDest(pItem)
  if 1 ~= pItem.IsEquip() then
    me.Msg("只能放入装备！")
    return 0
  end
  if 1 == pItem.IsWhite() then
    me.Msg("参与五行激活的装备才能进行转移！")
    return 0
  end
  if (pItem.nDetail < Item.MIN_COMMON_EQUIP) or (pItem.nDetail > Item.MAX_COMMON_EQUIP) then
    me.Msg("参与五行激活的装备才能进行转移！")
    return 0
  end
  if pItem.nEnhTimes == Item:CalcMaxEnhanceTimes(pItem) then
    me.Msg("该装备已强化到极限，不可被强化转移！")
    return 0
  end

  local pSrcEquip = self:_GetSrcItem()
  if pSrcEquip then
    if Item:GetEquipType(pSrcEquip) ~= Item:GetEquipType(pItem) then
      me.Msg("只能进行同类型装备间的强化转移！")
      return 0
    end
    if pSrcEquip.nEnhTimes <= pItem.nEnhTimes then
      me.Msg("被转移的装备强化等级需低于要转移的装备！")
      return 0
    end
  end
  return 1
end

function tbEnhanceTransfer:_CheckSrc(pItem)
  if 1 ~= pItem.IsEquip() then
    me.Msg("只能放入装备！")
    return 0
  end
  if pItem.nDetail < Item.MIN_COMMON_EQUIP or pItem.nDetail > Item.MAX_COMMON_EQUIP then
    me.Msg("参与五行激活的装备才能进行转移！")
    return 0
  end
  if pItem.nLevel > 9 and pItem.nEnhTimes < 8 then
    me.Msg("不可以转移强化小于8级且装备等级为10级的装备")
    return 0
  end

  local pDesEquip = self:_GetTargetItem()
  if pDesEquip then
    if Item:GetEquipType(pDesEquip) ~= Item:GetEquipType(pItem) then
      me.Msg("只能进行同类型装备间的强化转移！")
      return 0
    elseif pDesEquip.nEnhTimes >= pItem.nEnhTimes then
      me.Msg("被转移的装备强化等级需低于要转移的装备！")
      return 0
    elseif pItem.nEnhTimes > Item:CalcMaxEnhanceTimes(pDesEquip) then
      me.Msg("转移装备的强化等级不能高于被转移装备的最大强化等级！")
      return 0
    end
  end
  return 1
end

function tbEnhanceTransfer:_CheckXuanjin(pItem)
  if pItem.szClass ~= Item.STRENGTHEN_STUFF_CLASS then
    me.Msg("只能放置玄晶！")
    return 0
  end
  return 1
end

function tbEnhanceTransfer:_CheckHelper(pItem)
  if pItem.szClass ~= Item.ENHANCE_TRANSFER then
    me.Msg("只能放置强化传承符！")
    return 0
  end
  return 1
end

function tbEnhanceTransfer:_CheckItem(pItem)
  if pItem.IsEquip() == 1 then
    if pItem.nDetail < Item.MIN_COMMON_EQUIP or pItem.nDetail > Item.MAX_COMMON_EQUIP then
      me.Msg("参与五行激活的装备才能进行转移！")
      return 0
    elseif pItem.nLevel > 9 and pItem.nEnhTimes < 8 then
      me.Msg("不可以转移强化小于8级且装备等级为10级的装备")
      return 0
    end
  elseif pItem.szClass ~= Item.ENHANCE_TRANSFER and pItem.szClass ~= Item.STRENGTHEN_STUFF_CLASS then
    me.Msg("只能放置需要转移的装备或玄晶或强化传承符！")
    return 0
  end
  return 1
end

function tbEnhanceTransfer:CheckSwitch(tbCont, pDrop, pPick, nX, nY)
  if not pDrop then
    if tbCont.szObjGrid == self.tbWnd.OBJ_TARGET_EQUIP then
    elseif tbCont.szObjGrid == self.tbWnd.OBJ_SRC_TRANSFER_EQUIP then
      self.nTransferLowEquit = 0
    end
    return 1
  elseif tbCont.szObjGrid == self.tbWnd.OBJ_TARGET_EQUIP then
    return self:_CheckDest(pDrop)
  elseif tbCont.szObjGrid == self.tbWnd.OBJ_SRC_TRANSFER_EQUIP then
    if 1 ~= self:_CheckSrc(pDrop) then
      return 0
    end
    if pDrop.nEnhTimes < 8 then
      self.nTransferLowEquit = 1
    end
  elseif tbCont.szObjGrid == self.tbWnd.OBJ_TRANSFER_HELPER then
    return self:_CheckHelper(pDrop)
  elseif tbCont.szObjGrid == self.tbWnd.OBJ_ITEM_GRID then
    return self:_CheckItem(pDrop)
  elseif tbCont.szObjGrid == self.tbWnd.OBJ_ITEM_GRID_TRANSFER then
    return self:_CheckXuanjin(pDrop)
  else
    assert(false)
    return 0
  end
  return 1
end

function tbEnhanceTransfer:OnBuffChange()
  self:UpdateState()
end

function tbEnhanceTransfer:UpdateState()
  local tbTransferItem = {}
  for j = 0, Item.ROOM_ENHANCE_ITEM_HEIGHT - 1 do
    for i = 0, Item.ROOM_ENHANCE_ITEM_WIDTH - 1 do
      local pItem = me.GetEnhanceItem(i, j)
      if pItem then
        table.insert(tbTransferItem, pItem)
      end
    end
  end
  local nRet, szCheckMsg = Item:CheckDropItem(tbTransferItem)
  local pRegionEquip, bHasTransferItem = Item:GetRegionEquip(tbTransferItem)
  local pEquip = me.GetEnhanceEquip()
  local pSrcEquip = self:_GetSrcItem()
  local pHelper = self:_GetHelperItem()
  local nSplit = self:_CanSplit()
  Wnd_SetEnable(self.tbWnd.UIGROUP, self.tbWnd.BTN_OK, 0)

  -- 更新申请按钮
  if -1 == nSplit or 1 == nSplit then
    Btn_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.BTN_SPLIT_APPLY, "取消申请")
  else
    Btn_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.BTN_SPLIT_APPLY, "申请剥离")
  end

  -- 强化12以上的装备
  if pSrcEquip and pSrcEquip.nEnhTimes >= 12 and 1 ~= nSplit then
    if (pEquip and pEquip.nLevel >= 10) or (pSrcEquip.nLevel >= 10) or (pEquip and pEquip.IsBind() ~= 1) or pSrcEquip.IsBind() ~= 1 then
      local szMsg = ""
      if 0 == nSplit then
        szMsg = "◆<color=red>您选择的转移的装备属于高强化装备，需要先申请高强化装备剥离。<color>"
      elseif -1 == nSplit then
        szMsg = "◆<color=red>您选择的转移的装备属于高强化装备，您的申请正在处理中。<color>"
      elseif -2 == nSplit then
        szMsg = "◆<color=red>您选择的转移的装备属于高强化装备，您的申请已经超时，需要重新申请。<color>"
      end
      Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, szMsg)
      return 0
    end
  end

  if (not pEquip) and (#tbTransferItem <= 0) then
    local szReason = ""
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, string.format("◆请把要被转移的装备放到上面的格子，玄晶和转移的装备放入下面的格子，加入强化传承符可以减少玄晶损耗，然后点击“确定”进行转移。\n<color=yellow>%s", szReason))
  elseif not pEquip then
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "◆请在上面的格子中放入要被转移的装备。")
  elseif not pSrcEquip then
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "◆请在上面的格子中放入要转移的装备。")
  elseif nRet ~= 1 then
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "◆" .. szCheckMsg)
  elseif (not pEquip) and (#tbTransferItem > 0) then
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "◆请在上面的格子中放入要被转移的装备。")
  elseif pEquip and (#tbTransferItem <= 0) then
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "◆请在下面的格子中放入玄晶。")
  elseif pEquip and pEquip.nEnhTimes == 16 then
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "◆您的装备已被转移至极限。")
  elseif pRegionEquip and pEquip then
    local nProb = Item:CalcTransferProb(pEquip, tbTransferItem)
    local nTransferDiscount = me.GetSkillState(2220)
    if nTransferDiscount ~= 1 then
      nTransferDiscount = me.GetSkillState(2263)
    end
    local nOtherRebate = Item:CheckHasOtherRebate(pEquip, tbTransferItem)
    local nMoney = Item:CalcTransferCost(pEquip, pRegionEquip, bHasTransferItem, nOtherRebate)
    ----强化传承优惠100%折扣
    if ((nTransferDiscount == 1 and nOtherRebate == 0) or (nOtherRebate == 1 and pEquip.nLevel <= Item.nDisCount and pRegionEquip.nLevel <= Item.nDisCount)) and bHasTransferItem == 1 then
      --非返还不扣钱
      if nMoney > 0 then
        nMoney = 0
      end
      --转移度不够直接设为1
      if nProb < 1 then
        nProb = 1
      end
    end
    self.nProb = math.floor(nProb * 100)
    if self.nProb < 0 then
      self.nProb = 0
    end
    -- 银两使用标志
    if me.GetBindMoney() >= nMoney then
      self.nMoneyEnoughFlag = 2
    else
      self.nMoneyEnoughFlag = (me.nCashMoney + me.GetBindMoney() >= nMoney) and 1 or 0
    end

    local szMsg = ""
    if nMoney >= 0 then
      szMsg = string.format("◆本次转移需要<color=yellow>银两<color>%s%d两%s。(优先使用绑定银两)(目前银两汇率是<color=yellow>%d<color>)\n", (self.nMoneyEnoughFlag > 0) and "" or "<color=red>", nMoney, (self.nMoneyEnoughFlag > 0) and "" or "<color>", Item:GetJbPrice() * 100)
    else
      szMsg = string.format("◆本次转移将返还<color=yellow>绑银<color>%d两。\n)", math.abs(nMoney))
    end
    if self.nProb < 100 then
      szMsg = szMsg .. string.format("◆<color=red>当前转移度为：<color=yellow>%d<color>。(转移度过100方可转移)<color>\n", self.nProb)
    else
      szMsg = szMsg .. string.format("◆当前转移度为：<color=yellow>%d<color>。(转移度过100方可转移)\n", self.nProb)
    end
    -- *******合服优惠，合服7天后过期*******
    if GetTime() < KGblTask.SCGetDbTaskInt(DBTASK_COZONE_TIME) + 7 * 24 * 60 * 60 then
      szMsg = "<color=yellow>◆合服优惠活动，你转移装备将减少20%费用\n<color>" .. szMsg
    end
    -- *************************************

    if self.nProb >= 120 then
      self.bShowHighForbidden = 1
      szMsg = szMsg .. "◆<color=red>当前转移度过高，不可进行转移。<color>\n"
    else
      self.bShowHighForbidden = 0
    end

    local szTime = me.GetItemAbsTimeout(pEquip) or me.GetItemRelTimeout(pEquip)
    if szTime then
      self.bShowTimeMsg = 1
    else
      self.bShowTimeMsg = 0
    end

    if pEquip.nLevel > 9 and pRegionEquip.nEnhTimes < 8 then
      szMsg = szMsg .. "◆<color=red>10级装备转移需要强化等级大于8的装备。<color>\n"
    elseif pRegionEquip.nEnhTimes < 8 and Item.bHasOtherTransferItem ~= 1 then
      --  这里的Item.bHasOtherTransferItem是在Item/function/enhance_transfer.lua中
      szMsg = szMsg .. "◆<color=red>您放入的装备为强化小于8的装备，需要初级强化传承符才能转移。<color>\n"
    elseif self.nProb < 100 then
      szMsg = szMsg .. "◆<color=red>若想提高转移度，可以放入更多的玄晶。<color>\n"
      if not pHelper then
        szMsg = szMsg .. "◆使用强化传承符可以降低玄晶的消耗。\n"
      end
    elseif self.nProb >= 100 and self.nProb < 120 then
      Wnd_SetEnable(self.tbWnd.UIGROUP, self.tbWnd.BTN_OK, 1)
    end

    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, szMsg)
  end
end

function tbEnhanceTransfer:GetDesc()
  return "将旧装备的强化等级转到新装备去，装备更换更方便，消耗更低（使用强化传承符可以大大减少转移时的玄晶银两消耗）。"
end

function tbEnhanceTransfer:SelectBodyEquip(tbObj)
  if tbObj and tbObj.pItem and 1 == self:_CheckSrc(tbObj.pItem) then
    tbMouse:SetObj(tbObj)
    self.tbWnd:GetCont(self.tbWnd.OBJ_SRC_TRANSFER_EQUIP):SwitchObj(0, 0)
    tbMouse:ResetObj()
    return 1
  else
    return 0
  end
end
---------------------------------------------------------------------------------------------
-- 玄晶剥离
local tbXuanjingSplit = Lib:NewClass(tbBase)

function tbXuanjingSplit:GetMode()
  return Item.ENHANCE_MODE_PEEL -- 玄晶剥离
end

function tbXuanjingSplit:Enter()
  self._tbBase.Enter(self)

  Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_TARGET_DESC, "强化过的装备")

  UiManager:SetUiState(UiManager.UIS_EQUIP_PEEL)
end

function tbXuanjingSplit:Leave()
  self._tbBase.Leave(self)
  self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID_SPLIT):ClearRoom()
  self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):ClearRoom()
  UiManager:ReleaseUiState(UiManager.UIS_EQUIP_PEEL)
end

function tbXuanjingSplit:OnOk()
  me.ApplyEnhance(Item.ENHANCE_MODE_PEEL, 1, 0)
end

function tbXuanjingSplit:OnCancel()
  if 1 == self.tbWnd:IsAllContEmpy() then
    UiManager:CloseWindow(self.tbWnd.UIGROUP)
    return
  end
  self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID_SPLIT):ClearRoom()
  self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):ClearRoom()
  self:UpdateState()
end

function tbXuanjingSplit:OnResult(nResult) end

function tbXuanjingSplit:StateReciveUse(pItem)
  if 1 == self:_CheckEquip(pItem) then
    self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):ClearRoom()
    self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):SpecialStateRecvUse()
  else
    tbMouse:ResetObj()
  end
end

function tbXuanjingSplit:_CheckEquip(pItem)
  if 1 == pItem.IsWhite() then
    me.Msg("该物品不能剥离！")
    return 0
  end
  if pItem.nEnhTimes <= 0 then
    me.Msg("未强化过装备不能剥离！")
    return 0
  end
  if (pItem.nDetail < Item.MIN_COMMON_EQUIP) or (pItem.nDetail > Item.MAX_COMMON_EQUIP) then
    me.Msg("参与五行激活的装备才能进行剥离！")
    return 0
  end
  return 1
end

function tbXuanjingSplit:CheckSwitch(tbCont, pDrop, pPick, nX, nY)
  if not pDrop then
    return 1
  elseif tbCont.szObjGrid == self.tbWnd.OBJ_TARGET_EQUIP then
    return self:_CheckEquip(pDrop)
  else
    assert(false)
    return 0
  end

  return 1
end

function tbXuanjingSplit:OnBuffChange()
  self:UpdateState()
end

function tbXuanjingSplit:UpdateState()
  -- 释放先前所占用的临时道具
  self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID_SPLIT):ClearRoom()
  Wnd_SetEnable(self.tbWnd.UIGROUP, self.tbWnd.BTN_OK, 0)

  local nSplit = self:_CanSplit()
  -- 更新申请按钮
  if -1 == nSplit or 1 == nSplit then
    Btn_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.BTN_SPLIT_APPLY, "取消申请")
  else
    Btn_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.BTN_SPLIT_APPLY, "申请剥离")
  end

  local pEquip = me.GetEnhanceEquip()
  if not pEquip then
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "◆请把需要剥离的已强化装备放到上面的格子，下面的格子将能看到剥离后的结果。")
    return
  end

  if pEquip.nEnhTimes <= 0 then -- 在刚刚执行完剥离操作时容器里的装备是不能剥离的
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "◆您的装备已经成功地执行了玄晶剥离操作。")
    return
  end

  -- 剥离
  local tbEnhItem, nMoney, nBind = Item:CalcPeelItem(pEquip)
  if not tbEnhItem then
    return
  end

  local nX = 0
  local nY = 0
  -- 先展示剥离效果
  for nLevel, nCount in pairs(tbEnhItem) do
    if nCount > 0 then
      self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID_SPLIT):AddTempObj(Item.SCRIPTITEM, 1, 114, nLevel, tostring(nCount))
      if nX < Item.ROOM_ENHANCE_ITEM_WIDTH then
        nX = nX + 1
      else
        nX = 0
        nY = nY + 1
      end
      if nY > Item.ROOM_ENHANCE_ITEM_HEIGHT then
        break
      end
    end
  end

  if pEquip.nEnhTimes >= 12 and 1 ~= nSplit then
    local szMsg = ""
    if 0 == nSplit then
      szMsg = "◆<color=red>您选择的剥离的装备属于高强化装备，需要先申请高强化装备剥离。<color>"
    elseif -1 == nSplit then
      szMsg = "◆<color=red>您选择的剥离的装备属于高强化装备，您的申请正在处理中。<color>"
    elseif -2 == nSplit then
      szMsg = "◆<color=red>您选择的剥离的装备属于高强化装备，您的申请已经超时，需要重新申请。<color>"
    end
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, szMsg)
    return
  end

  --	local tbEnhItem, nMoney, nBind = Item:CalcPeelItem(pEquip);
  --	if (not tbEnhItem) then
  --		return;
  --	end

  local szMsg = string.format("◆玄晶剥离会使装备<color=yellow>恢复到未强化状态<color>，同时您还将获得下面格子中的玄晶。\n" .. "◆本次剥离将<color=yellow>返还%d两<color>，请确认背包中有足够的空间，然后点击“确定”进行剥离。\n" .. "◆<color=yellow>注意：剥离所得玄晶为绑定状态<color>\n", nMoney)

  Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, szMsg)

  --	local nX = 0;
  --	local nY = 0;
  --
  --	for nLevel, nCount in pairs(tbEnhItem) do
  --		if nCount > 0 then
  --			self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID_SPLIT):AddTempObj(Item.SCRIPTITEM,	1, 114,	nLevel, tostring(nCount));
  --			if nX < Item.ROOM_ENHANCE_ITEM_WIDTH then
  --				nX = nX + 1;
  --			else
  --				nX = 0;
  --				nY = nY + 1;
  --			end
  --			if nY > Item.ROOM_ENHANCE_ITEM_HEIGHT then
  --				break;
  --			end
  --		end
  --	end

  Wnd_SetEnable(self.tbWnd.UIGROUP, self.tbWnd.BTN_OK, 1)
end

function tbXuanjingSplit:GetDesc()
  return "将已用于强化装备的玄晶剥下来，装备打回原形，马上获得大量玄晶，剥离高强化装备还能获得一定量的绑银返还。"
end

function tbXuanjingSplit:SelectBodyEquip(tbObj)
  if tbObj and tbObj.pItem and 1 == self:_CheckEquip(tbObj.pItem) then
    self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):ClearRoom()
    tbMouse:SetObj(tbObj)
    self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):SpecialStateRecvUse()
    return 1
  else
    return 0
  end
end

---------------------------------------------------------------------------------------------
-- 武器剥离
local tbWeaponSplit = Lib:NewClass(tbBase)

function tbWeaponSplit:GetMode()
  return Item.ENHANCE_MODE_WEAPON_PEEL -- 武器玄晶剥离
end

function tbWeaponSplit:Enter()
  self._tbBase.Enter(self)

  Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_TARGET_DESC, "青铜武器")

  UiManager:SetUiState(UiManager.UIS_WEAPON_PEEL)
end

function tbWeaponSplit:Leave()
  self._tbBase.Leave(self)

  self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID_SPLIT):ClearRoom()
  self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):ClearRoom()

  UiManager:ReleaseUiState(UiManager.UIS_WEAPON_PEEL)
end

function tbWeaponSplit:OnOk()
  if me.CountFreeBagCell() < 1 then
    me.Msg("您的背包空间不足，需要1格背包空间。")
    return 0
  end

  local tbMsg = {}
  tbMsg.szMsg = ""
  tbMsg.szMsg = "请确认剥离青铜武器？"
  tbMsg.nOptCount = 2
  function tbMsg:Callback(nOptIndex, nMode, nMoneyType, nProb)
    if nOptIndex == 2 then
      me.ApplyEnhance(nMode, nMoneyType, (nProb or 0))
    end
  end
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, self:GetMode(), self.nMoneyType, self.nProb)
end

function tbWeaponSplit:OnCancel()
  if 1 == self.tbWnd:IsAllContEmpy() then
    UiManager:CloseWindow(self.tbWnd.UIGROUP)
    return
  end
  self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID_SPLIT):ClearRoom()
  self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):ClearRoom()
  self:UpdateState()
end

function tbWeaponSplit:OnResult(nResult)
  if nResult == 1 then
    me.Msg("青铜武器剥离操作成功！")
  elseif nResult == 0 then
    me.Msg("很遗憾，您这次青铜武器剥离失败了。")
  else
    me.Msg("无法进行青铜武器剥离！")
  end
end

function tbWeaponSplit:StateReciveUse(pItem)
  if 1 == self:_CheckEquip(pItem) then
    self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):ClearRoom()
    self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):SpecialStateRecvUse()
  else
    tbMouse:ResetObj()
  end
end

function tbWeaponSplit:CheckSwitch(tbCont, pDrop, pPick, nX, nY)
  if not pDrop then
    return 1
  end

  if tbCont.szObjGrid ~= self.tbWnd.OBJ_TARGET_EQUIP then
    return self:_CheckEquip(pDrop)
  end

  return 1
end

function tbWeaponSplit:OnBuffChange()
  self:UpdateState()
end

function tbWeaponSplit:UpdateState()
  self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID_SPLIT):ClearRoom()
  Wnd_SetEnable(self.tbWnd.UIGROUP, self.tbWnd.BTN_OK, 0)

  local nSplit = self:_CanSplit()
  -- 更新申请按钮
  if -1 == nSplit or 1 == nSplit then
    Btn_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.BTN_SPLIT_APPLY, "取消申请")
  else
    Btn_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.BTN_SPLIT_APPLY, "申请剥离")
  end

  local pEquip = me.GetEnhanceEquip()
  -- 有装备，且不是青铜武器，则表示刚刚剥离过
  if pEquip and 0 == Item:CheckIsQinTongWep(pEquip) then
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "◆您的青铜武器已经成功剥离。")
    return 0
  end

  -- 先展示结果
  if pEquip then
    self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID_SPLIT):AddTempObj(22, 1, 81, 1, "5")
  end

  -- 有条件的哟
  if 1 ~= nSplit then
    local szMsg = ""
    if 0 == nSplit then
      szMsg = "◆<color=red>青铜武器属于高级装备，剥离前需要先申请高强化装备剥离。<color>"
    elseif -1 == nSplit then
      szMsg = "◆<color=red>青铜武器属于高级装备，您的申请正在处理中。<color>"
    elseif -2 == nSplit then
      szMsg = "◆<color=red>青铜武器属于高级装备，您的申请已经超时，需要重新申请。<color>"
    end
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, szMsg)
    return 0
  end

  if not pEquip then
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "◆请把需要剥离的青铜武器放到上面的格子，下面的格子将能看到剥离后的结果。")
    return 0
  end

  local szMsg = string.format("◆青铜武器剥离会使装备<color=yellow>恢复到未炼化状态<color>。\n" .. "◆本次剥离将<color=yellow>返还5个和氏玉<color>，请确认背包中有足够的空间，然后点击“确定”进行剥离。\n" .. "◆<color=yellow>注意：剥离所得和氏玉为绑定状态<color>\n", nMoney)

  Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, szMsg)
  --	self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID_SPLIT):AddTempObj(22, 1, 81, 1, "5");
  Wnd_SetEnable(self.tbWnd.UIGROUP, self.tbWnd.BTN_OK, 1)
end

function tbWeaponSplit:_CheckEquip(pItem)
  local bIsQinTongWep = Item:CheckIsQinTongWep(pItem)
  local nSplit = self:_CanSplit()
  if 0 == nSplit then
    me.Msg("请先申请高级装备剥离。")
    return 0
  elseif -1 == nSplit then -- 申请正在处理中
    me.Msg("尚未到可剥离时间，请稍等。")
    return 0
  elseif -2 == nSplit then -- 过了申请期
    me.Msg("您的上次剥离申请已经超时，请重新申请。")
    return 0
  end

  if 1 ~= bIsQinTongWep then
    me.Msg("只有青铜武器才可以剥离。")
    return 0
  end
  return 1
end

function tbWeaponSplit:GetDesc()
  return "将消耗在青铜武器上的和氏玉剥出来。"
end

function tbWeaponSplit:SelectBodyEquip(tbObj)
  if tbObj and tbObj.pItem and 1 == self:_CheckEquip(tbObj.pItem) then
    self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):ClearRoom()
    tbMouse:SetObj(tbObj)
    self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):SpecialStateRecvUse()
    return 1
  else
    return 0
  end
end
---------------------------------------------------------------------------------------------
-- 高级玄晶拆解
local tbGaojiXuanSplit = Lib:NewClass(tbBase)

function tbGaojiXuanSplit:GetMode()
  return Item.ENHANCE_MODE_BREAKUP_XUAN -- 高级玄晶拆解
end

function tbGaojiXuanSplit:Enter()
  self._tbBase.Enter(self)

  Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_TARGET_DESC, "10至12级玄晶")

  UiManager:SetUiState(UiManager.UIS_EQUIP_PEEL)
end

function tbGaojiXuanSplit:Leave()
  self._tbBase.Leave(self)

  self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):ClearRoom()
  self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID_SPLIT):ClearRoom()

  UiManager:ReleaseUiState(UiManager.UIS_EQUIP_PEEL)
end

function tbGaojiXuanSplit:OnOk()
  local pXuan = me.GetEnhanceEquip()
  if not pXuan or 1 ~= self:_CheckEquip(pXuan) then
    return 0
  end

  local tbMsg = {}
  tbMsg.szTitle = "确  认"
  tbMsg.nOptCount = 2
  tbMsg.szMsg = "您确定要拆解玄晶？"

  function tbMsg:Callback(nOptIndex, nMode)
    if nOptIndex == 2 then
      me.ApplyEnhance(nMode, 0, 0)
    end
  end

  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, self:GetMode())
end

function tbGaojiXuanSplit:OnCancel()
  if 1 == self.tbWnd:IsAllContEmpy() then
    UiManager:CloseWindow(self.tbWnd.UIGROUP)
    return
  end
  self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):ClearRoom()
  self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID_SPLIT):ClearRoom()
  self:UpdateState()
end

function tbGaojiXuanSplit:OnResult(nResult)
  -- 这里没有什么成功不成功的哈
  self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):ClearRoom()
  self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID_SPLIT):ClearRoom()
end

function tbGaojiXuanSplit:StateReciveUse(pItem)
  if 1 == self:_CheckEquip(pItem) then
    self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):ClearRoom()
    self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):SpecialStateRecvUse()
  else
    tbMouse:ResetObj()
  end
end

function tbGaojiXuanSplit:CheckSwitch(tbCont, pDrop, pPick, nX, nY)
  if not pDrop then
    return 1
  elseif tbCont.szObjGrid == self.tbWnd.OBJ_TARGET_EQUIP then
    return self:_CheckEquip(pDrop)
  end

  return 0
end

function tbGaojiXuanSplit:UpdateState()
  local tbCont = self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID_SPLIT)
  tbCont:ClearRoom()
  Wnd_SetEnable(self.tbWnd.UIGROUP, self.tbWnd.BTN_OK, 0)

  local pXuan = me.GetEnhanceEquip()
  if not pXuan then
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "请放入要拆解的玄晶。只能放10级至12级的绑定玄晶。")
    return
  end

  local tbBreakUpItem = Item:ValueToItem(pXuan.nValue, 3, 1) -- 最后一个参数是标志位，表示是拆玄
  local szMsg = ""
  local nNum = 0
  for i = 1, 12 do
    if tbBreakUpItem[i] and tbBreakUpItem[i] > 0 then
      szMsg = szMsg .. "    " .. i .. "级玄晶" .. tbBreakUpItem[i] .. "个\n"
      nNum = nNum + tbBreakUpItem[i]
    end
  end

  szMsg = "您可以拆解成：\n<color=yellow>" .. szMsg .. "<color>" --需要"..nNum.."个空间来存放。";
  Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, szMsg)

  for i = 1, 12 do
    if tbBreakUpItem[i] and tbBreakUpItem[i] > 0 then
      tbCont:AddTempObj(Item.SCRIPTITEM, 1, 114, i, tostring(tbBreakUpItem[i]))
    end
  end

  if me.CountFreeBagCell() < nNum then
    szMsg = szMsg .. "<color=red>需要" .. nNum .. "个空间来存放。<color>"
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, szMsg)
  else
    szMsg = szMsg .. "需要" .. nNum .. "个空间来存放。"
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, szMsg)
    Wnd_SetEnable(self.tbWnd.UIGROUP, self.tbWnd.BTN_OK, 1)
  end
  Wnd_SetEnable(self.tbWnd.UIGROUP, self.tbWnd.BTN_OK, 1)
end

function tbGaojiXuanSplit:GetDesc()
  return "将高级玄晶拆解为多个低级玄晶，需要低等级玄晶时可使用此功能。"
end

function tbGaojiXuanSplit:_CheckEquip(pItem)
  if pItem.szClass ~= Item.STRENGTHEN_STUFF_CLASS or pItem.nLevel < 10 or pItem.nLevel > 12 or 1 ~= pItem.IsBind() then
    me.Msg("<color=red>只能放10级至12级的绑定玄晶！<color>", "系统")
    return 0
  end
  return 1
end

---------------------------------------------------------------------------------------------
-- 装备炼化
local tbEquipRefine = Lib:NewClass(tbBase)

function tbEquipRefine:GetMode()
  return Item.ENHANCE_MODE_REFINE -- 装备炼化
end

function tbEquipRefine:Enter()
  self._tbBase.Enter(self)

  Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_SRC_DESC, "需炼化的装备")
  Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_HELPER_DESC, "炼化图")
  Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_VIEW_RECAST_L, "炼化装备一")
  Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_VIEW_RECAST_R, "炼化装备二")
  -- 目前只支持两件装备
  self.nCurSelEquip = nil
  self.tbTempItem = {}
  self.nMoneyType = Item.BIND_MONEY -- 普通银两

  self.tbWnd:GetCont(self.tbWnd.OBJ_RECAST_VIEW):SetViewMode(1)
  UiManager:SetUiState(UiManager.UIS_EQUIP_REFINE)
end

function tbEquipRefine:Leave()
  self._tbBase.Leave(self)

  self:_ClearTempItem()

  self.tbWnd:GetCont(self.tbWnd.OBJ_SRC_TRANSFER_EQUIP):ClearObj()
  self.tbWnd:GetCont(self.tbWnd.OBJ_TRANSFER_HELPER):ClearObj()
  self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID_SPLIT):ClearObj()
  self.tbWnd:GetCont(self.tbWnd.OBJ_RECAST_VIEW):ClearObj()
  self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID):ClearRoom()
  self.tbWnd:GetCont(self.tbWnd.OBJ_RECAST_VIEW):SetViewMode(0)

  UiManager:ReleaseUiState(UiManager.UIS_EQUIP_REFINE)
end

function tbEquipRefine:OnOk()
  local nIndex = self.nCurSelEquip
  if not nIndex then
    me.Msg("请选择炼化后的装备！")
    return 0
  end

  if not self.pEquip or not self.tbProduce or not self.tbProduce[nIndex] then
    print("异常！")
    return 0
  end

  local nMoney = self.tbProduce[nIndex].nFee + Item:CalcRefineMoney(self.pEquip)
  if me.GetBindMoney() + me.nCashMoney < nMoney then
    me.Msg("银两不足，不能炼化装备！")
    return 0
  end

  local szMsg = "炼化后的装备会<color=green>强制与您绑定<color>，你是否要继续炼化？"
  if me.GetBindMoney() < nMoney then
    szMsg = "绑定银两不足，<color=red>将消费银两来代替绑银不足部分，<color>" .. szMsg
  end

  local tbMsg = {}
  tbMsg.szMsg = szMsg
  tbMsg.nOptCount = 2
  function tbMsg:Callback(nOptIndex, nIdx)
    if nOptIndex == 2 then
      me.ApplyRefine(nIdx)
    end
  end
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, self.tbProduce[nIndex].nIdx)
end

function tbEquipRefine:OnCancel()
  if 1 == self.tbWnd:IsAllContEmpy() then
    UiManager:CloseWindow(self.tbWnd.UIGROUP)
    return
  end
  self:_ClearTempItem()

  self.tbWnd:GetCont(self.tbWnd.OBJ_SRC_TRANSFER_EQUIP):ClearObj()
  self.tbWnd:GetCont(self.tbWnd.OBJ_TRANSFER_HELPER):ClearObj()
  self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID_TRANSFER):ClearObj()
  self.tbWnd:GetCont(self.tbWnd.OBJ_RECAST_VIEW):ClearObj()
  self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID):ClearRoom()
  self:UpdateState()
end

function tbEquipRefine:OnResult(nResult)
  if nResult >= 1 then
    self.tbWnd:GetCont(self.tbWnd.OBJ_SRC_TRANSFER_EQUIP):ClearObj()
    self.tbWnd:GetCont(self.tbWnd.OBJ_TRANSFER_HELPER):ClearObj()
    self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID_TRANSFER):ClearObj()
    self.tbWnd:GetCont(self.tbWnd.OBJ_RECAST_VIEW):ClearObj()
    self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID):ClearRoom()
  end
end

function tbEquipRefine:StateReciveUse(pItem)
  if 1 == pItem.IsEquip() then
    self.tbWnd:GetCont(self.tbWnd.OBJ_SRC_TRANSFER_EQUIP):SwitchObj(0, 0)
  elseif Item.REFINE_RECIPE_CALSS == pItem.szClass then
    self.tbWnd:GetCont(self.tbWnd.OBJ_TRANSFER_HELPER):SwitchObj(0, 0)
  else
    self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID_TRANSFER):SpecialStateRecvUse()
  end
  tbMouse:ResetObj()
end

function tbEquipRefine:CheckSwitch(tbCont, pDrop, pPick, nX, nY)
  if not pDrop then
    return 1
  end

  if tbCont.szObjGrid == self.tbWnd.OBJ_SRC_TRANSFER_EQUIP then
    return self:_CheckEquip(pDrop)
  elseif tbCont.szObjGrid == self.tbWnd.OBJ_TRANSFER_HELPER then
    return self:_CheckHelper(pDrop)
  else
    return self:_CheckItem(pDrop)
  end

  return 0
end

function tbEquipRefine:UpdateState()
  Wnd_SetEnable(self.tbWnd.UIGROUP, self.tbWnd.BTN_OK, 0)
  Wnd_SetEnable(self.tbWnd.UIGROUP, self.tbWnd.BTN_SELECT_LEFT, 0)
  Wnd_SetEnable(self.tbWnd.UIGROUP, self.tbWnd.BTN_SELECT_RIGHT, 0)

  local nCurSelEquip = self.nCurSelEquip
  self:_ClearTempItem()

  local tbRefineItem = {}
  for j = 0, Item.ROOM_ENHANCE_ITEM_HEIGHT - 1 do
    for i = 0, Item.ROOM_ENHANCE_ITEM_WIDTH - 1 do
      local pEnhItem = me.GetEnhanceItem(i, j)
      if pEnhItem then
        table.insert(tbRefineItem, pEnhItem)
      end
    end
  end

  if #tbRefineItem == 0 then
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "◆请把需要炼化的装备、改造图放至指定的格子里！")
    return
  end

  local pSrc = self:_GetSrcItem()
  local pHelper = self:_GetHelperItem()
  if not pSrc then
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "◆请放入需要炼化的装备！")
    return 0
  elseif not pHelper then
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "◆请放入炼化图！")
    return 0
  end

  local pEquip, pRefineItem, tbProduce, tbRefineStuff, tbRequireItem, nRefineDegree = Item:CalcRefineItem(tbRefineItem)
  self.pEquip = pEquip
  self.nRefineDegree = nRefineDegree
  self.tbProduce = tbProduce

  if not pEquip then
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "◆目前的材料不能炼化出任何装备！")
    return
  end

  for _, tbProduceItem in pairs(tbProduce) do
    local tbTaskData = Item:GetItemTaskData(pEquip) or {}
    if pEquip.IsExEquip() == 1 then
      tbTaskData = Item:SetItemTaskValue(tbTaskData, Item.TASKDATA_MAIN_EQUIPEX, Item.ITEM_TASKVAL_EX_SUBID_ExRefLevel, tbProduceItem.tbEquip[5])
    end
    tbTaskData = Item:FullFilTable(tbTaskData)

    -- 创建临时道具对象
    local pItem = tbTempItem:Create(tbProduceItem.tbEquip[1], tbProduceItem.tbEquip[2], tbProduceItem.tbEquip[3], tbProduceItem.tbEquip[4], pEquip.nSeries, pEquip.nEnhTimes, pEquip.nLucky, nil, 0, pEquip.dwRandSeed, pEquip.nIndex, pEquip.nStrengthen, pEquip.nCount, pEquip.nCurDur, pEquip.nMaxDur, pEquip.GetRandomInfo(), tbTaskData)

    if not pItem then
      print("创建零时对象失败~")
      return
    end
    table.insert(self.tbTempItem, pItem) -- 为了释放而记录之
  end

  if 0 == #self.tbTempItem then
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "◆目前的材料不能炼化出任何装备！")
    return 0
  end

  if self.tbTempItem[1] then
    local tbObj = {}
    tbObj.nType = Ui.OBJ_TEMPITEM
    tbObj.pItem = self.tbTempItem[1]
    if self.tbTempItem[2] then
      tbObj.szCmpSuffix = "<color=yellow>左侧的道具<color>"
    end
    self.tbWnd:GetCont(self.tbWnd.OBJ_RECAST_VIEW):SetObj(tbObj, 0, 0)
    Wnd_SetEnable(self.tbWnd.UIGROUP, self.tbWnd.BTN_SELECT_LEFT, 1)
  end

  if self.tbTempItem[2] then
    local tbObj = {}
    tbObj.nType = Ui.OBJ_TEMPITEM
    tbObj.pItem = self.tbTempItem[2]
    tbObj.szCmpSuffix = "<color=yellow>右侧的道具<color>"
    self.tbWnd:GetCont(self.tbWnd.OBJ_RECAST_VIEW):SetObj(tbObj, 1, 0)
    Wnd_SetEnable(self.tbWnd.UIGROUP, self.tbWnd.BTN_SELECT_RIGHT, 1)
  end

  if not nCurSelEquip or nCurSelEquip > #self.tbTempItem then
    self:SelectEquip(0, 0)
  else
    self:SelectEquip(nCurSelEquip - 1, 0)
  end
end

function tbEquipRefine:GetDesc()
  return "提升装备属性的一重要途径，炼化后能让一般装备变成套装装备，激活套装属性，同一套装的装备数量越多，能力提升效果越明显。"
end

function tbEquipRefine:SelectBodyEquip(tbObj)
  if tbObj and tbObj.pItem and 1 == self:_CheckEquip(tbObj.pItem) then
    tbMouse:SetObj(tbObj)
    self.tbWnd:GetCont(self.tbWnd.OBJ_SRC_TRANSFER_EQUIP):SwitchObj(0, 0)
    tbMouse:ResetObj()
    return 1
  else
    return 0
  end
end

function tbEquipRefine:SelectEquip(nX, nY)
  local tbCont = self.tbWnd:GetCont(self.tbWnd.OBJ_RECAST_VIEW)
  Btn_Check(self.tbWnd.UIGROUP, self.tbWnd.BTN_SELECT_LEFT, 0)
  Btn_Check(self.tbWnd.UIGROUP, self.tbWnd.BTN_SELECT_RIGHT, 0)

  if tbCont:GetObj(nX, nY) then
    tbCont:SetObjHightLight(nX, nY)
    if 0 == nX then
      Btn_Check(self.tbWnd.UIGROUP, self.tbWnd.BTN_SELECT_LEFT, 1)
    else
      Btn_Check(self.tbWnd.UIGROUP, self.tbWnd.BTN_SELECT_RIGHT, 1)
    end

    self.nCurSelEquip = nX + 1
    self:_UpdateState()
  end
end

function tbEquipRefine:_UpdateState()
  local pItem = self.tbTempItem[self.nCurSelEquip]
  if not pItem or not self.tbProduce or not self.tbProduce[self.nCurSelEquip] then
    return
  end

  local nMoney = self.tbProduce[self.nCurSelEquip].nFee + Item:CalcRefineMoney(self.pEquip)
  if me.GetBindMoney() >= nMoney then
    self.nMoneyEnoughFlag = 2
  else
    self.nMoneyEnoughFlag = (me.nCashMoney + me.GetBindMoney() >= nMoney) and 1 or 0
  end

  local szRefineDegreeMsg = "◆炼化度：<color=gold>" .. self.nRefineDegree .. "%<color>"
  if self.nRefineDegree ~= 100 then
    szRefineDegreeMsg = szRefineDegreeMsg .. "（不足100%，需要补充玄晶）\n"
  else
    szRefineDegreeMsg = szRefineDegreeMsg .. "\n"
    Wnd_SetEnable(self.tbWnd.UIGROUP, self.tbWnd.BTN_OK, 1)
  end

  local szMsg = string.format("◆本次炼化需要收取<color=yellow>银两<color>%s%d两%s。(优先使用绑定银两)\n", (self.nMoneyEnoughFlag > 0) and "" or "<color=red>", nMoney, (self.nMoneyEnoughFlag > 0) and "" or "<color>")

  -- *******合服优惠，合服7天后过期*******
  if GetTime() < KGblTask.SCGetDbTaskInt(DBTASK_COZONE_TIME) + 7 * 24 * 60 * 60 then
    szMsg = szMsg .. "<color=yellow>◆合并服务器优惠活动，你炼化装备将减少20%费用\n<color>"
  end
  -- *************************************

  Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, szRefineDegreeMsg .. szMsg)
end

function tbEquipRefine:_CheckEquip(pItem)
  -- 还不知道怎么判定道具是否可以炼化
  if 1 ~= pItem.IsEquip() then
    me.Msg("需要放入可炼化的装备！")
    return 0
  end
  return 1
end

function tbEquipRefine:_CheckHelper(pItem)
  if pItem.szClass ~= Item.REFINE_RECIPE_CALSS then
    me.Msg("需要放入炼化图！")
    return 0
  end
  return 1
end

function tbEquipRefine:_CheckItem(pItem)
  if 1 == pItem.IsEquip() or pItem.szClass == Item.REFINE_RECIPE_CALSS or pItem.szClass == Item.REFINE_XUANJING_CALSS then
    return 1
  end
  me.Msg("炼化操作只能放入装备、炼化图和玄晶！")
  return 0
end

function tbEquipRefine:_ClearTempItem()
  for _, pItem in pairs(self.tbTempItem) do
    tbTempItem:Destroy(pItem)
  end

  self.tbTempItem = {}
  self.nCurSelEquip = nil
  self.tbWnd:GetCont(self.tbWnd.OBJ_RECAST_VIEW):ClearObj()
end

---------------------------------------------------------------------------------------------
-- 装备重铸
local tbEquipRecast = Lib:NewClass(tbBase)

function tbEquipRecast:GetMode()
  return Item.ENHANCE_MODE_EQUIP_RECAST -- 装备重铸
end

function tbEquipRecast:Enter()
  self._tbBase.Enter(self)
  -- 装备重铸
  self.pOldEquip = nil -- 旧道具
  self.pNewEquip = nil -- 新道具，是创建的零时道具
  self.nCurSelEquip = nil -- 当前选择的装备

  Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_SRC_DESC, "需重铸的装备")
  Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_HELPER_DESC, "重铸符")
  Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_VIEW_RECAST_L, "重铸前的装备")
  Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_VIEW_RECAST_R, "重铸后的装备")
  self.tbWnd:GetCont(self.tbWnd.OBJ_RECAST_VIEW):SetViewMode(0)

  UiManager:SetUiState(UiManager.UIS_EQUIP_RECAST)
end

function tbEquipRecast:Leave()
  self._tbBase.Leave(self)

  -- 强制取消
  self:OnCancel(1)

  UiManager:ReleaseUiState(UiManager.UIS_EQUIP_RECAST)
end

function tbEquipRecast:OnOk()
  local tbReCastTips = {
    [Item.emEQUIP_RECAST_CURRENCY_MONEY] = { "普通银两", "两" },
    [Item.emEQUIP_RECAST_CURRENCY_LONGHUN] = { "龙纹银币", "个" },
  }

  if self.pNewEquip then
    if not self.pOldEquip then
      me.Msg("要重铸的装备已经不存在！")
      me.CallServerScript({ "ReceiveRecastError", 1 })
      UiManager:CloseWindow(self.tbWnd.UIGROUP)
      return
    end
    if not self.nCurSelEquip then
      me.Msg("请选择您想要的装备！")
      return
    end

    local nIndex = self.nCurSelEquip + 1
    local tbTemp = { self.pOldEquip, self.pNewEquip }
    local tbMsg = {}
    -- nindex == 1为旧装备，nindex == 2 为新装备，这个和我们的列表是相反的
    local tbFun = { "ConfirmRecast", 1, self.pOldEquip.dwId, nIndex }
    tbMsg.szMsg = "<color=yellow>确定选择该装备，是否继续？选择取消可以返回重新选择。<color>"
    tbMsg.szTitle = "提  示"
    tbMsg.tgObj = {}
    tbMsg.tgObj.nType = Ui.OBJ_TEMPITEM
    tbMsg.tgObj.pItem = tbTemp[nIndex]
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex, tbMsg, tbFun, tbOp)
      if nOptIndex == 2 then
        if not tbFun then
          return 0
        end
        me.CallServerScript(tbFun)
        tbOp:OnCancel(1)
        --				UiManager:CloseWindow(szUiGroup);
      end
    end

    UiManager:OpenWindow(Ui.UI_MSGBOXWITHOBJ2, tbMsg, tbFun, self)
  elseif 0 == self.nMoneyEnoughFlag then
    local szMoney = tbReCastTips[self.nMoneyType][1]
    me.Msg("您的" .. szMoney .. "不足以支付装备重铸的费用，无法进行装备重铸。")
    return
  else
    local tbMsg = {}

    tbMsg.szMsg = ""
    if self.bShowBindMsg == 1 then
      tbMsg.szMsg = "重铸后的装备会<color=green>强制与您绑定<color>，"
    end

    tbMsg.szMsg = tbMsg.szMsg .. string.format("<color=red>本次重铸将扣除您的%s，<color>", tbReCastTips[self.nMoneyType][1])
    tbMsg.szMsg = tbMsg.szMsg .. "是否继续？"
    tbMsg.nOptCount = 2

    function tbMsg:Callback(nOptIndex, nMode, nMoneyType, nProb)
      if nOptIndex == 2 then
        me.ApplyEnhance(nMode, nMoneyType, (nProb or 0))
      end
    end

    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, self:GetMode(), self.nMoneyType, self.nProb)
  end
end

function tbEquipRecast:OnCancel(bForce)
  if 1 ~= bForce and 1 == self.tbWnd:IsAllContEmpy() then
    UiManager:CloseWindow(self.tbWnd.UIGROUP)
    return
  end

  -- 如果重铸了装备
  if self.pNewEquip and 1 == bForce then
    if self.pNewEquip then
      tbTempItem:Destroy(self.pNewEquip)
      self.pNewEquip = nil
    end
  end

  if self.pNewEquip then
    local tbMsg = {}
    local tbFun = { "ConfirmRecast", 0, self.pOldEquip.dwId, 1 }

    tbMsg.szMsg = "<color=red>取消后，重铸的新装备消失，原装备保留。<color>"
    tbMsg.szMsg = tbMsg.szMsg .. "是否继续？"
    tbMsg.nOptCount = 2

    function tbMsg:Callback(nOptIndex, tbFun, tbOp)
      if nOptIndex == 2 then
        me.CallServerScript(tbFun)
        --				UiManager:CloseWindow(szUiGroup);
        tbOp:OnCancel(1)
      end
    end

    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, tbFun, self)
  else
    self.tbWnd:GetCont(self.tbWnd.OBJ_SRC_TRANSFER_EQUIP):ClearObj()
    self.tbWnd:GetCont(self.tbWnd.OBJ_TRANSFER_HELPER):ClearObj()
    self.tbWnd:GetCont(self.tbWnd.OBJ_RECAST_VIEW):ClearObj()
    self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID):ClearRoom()

    self:SelectEquip(0, 0) -- 把选择项取消掉
    self.pOldEquip = nil -- 旧道具
    self.pNewEquip = nil -- 新道具，是创建的零时道具
    self.nCurSelEquip = nil -- 当前选择的装备
  end
end

function tbEquipRecast:OnResult(nResult, nNewSeed, ...)
  if nResult == 1 then
    local tbRandMa = {}
    if not self.pOldEquip then
      me.Msg("您要重铸的装备已经不存在！")
      me.CallServerScript({ "ReceiveRecastError", 1 })
      UiManager:CloseWindow(self.tbWnd.UIGROUP)
      return 0
    end

    if not nNewSeed then
      me.Msg("您的客户端存在异常！")
      me.CallServerScript({ "ReceiveRecastError", 1 })
      UiManager:CloseWindow(self.tbWnd.UIGROUP)
      return 0
    end

    for i = 1, Item.emITEM_COUNT_RANDOM do
      tbRandMa[i] = arg[i]
    end

    if self.pNewEquip then
      tbTempItem:Destroy(self.pNewEquip)
      self.pNewEquip = nil
    end

    local tbTaskData = Item:GetItemTaskData(self.pOldEquip) or {}
    tbTaskData = Item:FullFilTable(tbTaskData)
    self.pNewEquip = tbTempItem:Create(self.pOldEquip.nGenre, self.pOldEquip.nDetail, self.pOldEquip.nParticular, self.pOldEquip.nLevel, self.pOldEquip.nSeries, self.pOldEquip.nEnhTimes, self.pOldEquip.nLucky, self.pOldEquip.GetGenInfo(), 0, KLib.Number2UInt(nNewSeed), -1, self.pOldEquip.nStrengthen, 0, 1000, 1000, tbRandMa, tbTaskData)
    if not self.pNewEquip then
      me.Msg("您的装备重铸失败！")
      me.CallServerScript({ "ReceiveRecastError", 1 })
      UiManager:CloseWindow(self.tbWnd.UIGROUP)
      return 0
    end

    me.Msg("你的装备重铸成功，请确定要选择的装备！")
  else
    if self.pNewEquip then
      tbTempItem:Destroy(self.pNewEquip) --如果返回失败，则清楚临时道具
      self.pNewEquip = nil
    end
    me.Msg("你的装备重铸失败！")
    return 0
  end
end

function tbEquipRecast:StateReciveUse(pItem)
  if 1 == pItem.IsEquip() then
    if 1 == self:_CheckEquip(pItem) then
      -- 模拟
      self.tbWnd:GetCont(self.tbWnd.OBJ_SRC_TRANSFER_EQUIP):SwitchObj(0, 0)
    else
      tbMouse:ResetObj()
    end
  else
    if 1 == self:_CheckItem(pItem) then
      -- 模拟
      self.tbWnd:GetCont(self.tbWnd.OBJ_TRANSFER_HELPER):SwitchObj(0, 0)
    else
      tbMouse:ResetObj()
    end
  end
end

function tbEquipRecast:CheckSwitch(tbCont, pDrop, pPick, nX, nY)
  if not pDrop then
    return 1
  end

  if tbCont.szObjGrid == self.tbWnd.OBJ_SRC_TRANSFER_EQUIP then
    return self:_CheckEquip(pDrop)
  elseif tbCont.szObjGrid == self.tbWnd.OBJ_TRANSFER_HELPER then
    return self:_CheckHelper(pDrop)
  elseif tbCont.szObjGrid == self.tbWnd.OBJ_ITEM_GRID then
    return self:_CheckItem(pDrop)
  else
    assert(false)
    return 0
  end

  return 1
end

function tbEquipRecast:UpdateState()
  Wnd_SetEnable(self.tbWnd.UIGROUP, self.tbWnd.BTN_OK, 0)
  Wnd_SetEnable(self.tbWnd.UIGROUP, self.tbWnd.BTN_SELECT_LEFT, 0)
  Wnd_SetEnable(self.tbWnd.UIGROUP, self.tbWnd.BTN_SELECT_RIGHT, 0)

  if self.pOldEquip and self.pNewEquip then -- 重铸完成了
    self.tbWnd:GetCont(self.tbWnd.OBJ_SRC_TRANSFER_EQUIP):ClearObj()
    self.tbWnd:GetCont(self.tbWnd.OBJ_TRANSFER_HELPER):ClearObj()
    self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID):ClearRoom()

    local tbObj_New = {}
    tbObj_New.nType = Ui.OBJ_TEMPITEM
    tbObj_New.pItem = self.pNewEquip
    tbObj_New.szCmpSuffix = "<color=yellow>重铸后的新装备<color>"
    self.tbWnd:GetCont(self.tbWnd.OBJ_RECAST_VIEW):SetObj(tbObj_New, 1, 0)

    local tbObj_Old = {}
    tbObj_Old.nType = Ui.OBJ_TEMPITEM
    tbObj_Old.pItem = self.pOldEquip
    tbObj_Old.szCmpSuffix = "<color=red>重铸前的旧装备<color>"
    self.tbWnd:GetCont(self.tbWnd.OBJ_RECAST_VIEW):SetObj(tbObj_Old, 0, 0)
    -- 默认选择一个
    if not self.nCurSelEquip then
      self:SelectEquip(0, 0)
    end
    Wnd_SetEnable(self.tbWnd.UIGROUP, self.tbWnd.BTN_OK, 1)
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "<color=yellow>◆请确定要选择的装备：<color>\n<color=yellow>◆若新装备属性低于原装备，可以选择取消放弃保留原装备<color>")

    Wnd_SetEnable(self.tbWnd.UIGROUP, self.tbWnd.BTN_SELECT_LEFT, 1)
    Wnd_SetEnable(self.tbWnd.UIGROUP, self.tbWnd.BTN_SELECT_RIGHT, 1)

    return 0
  end

  local tbRecastItem = {}
  for j = 0, Item.ROOM_ENHANCE_ITEM_HEIGHT - 1 do
    for i = 0, Item.ROOM_ENHANCE_ITEM_WIDTH - 1 do
      local pEnhItem = me.GetEnhanceItem(i, j)
      if pEnhItem then
        table.insert(tbRecastItem, pEnhItem)
      end
    end
  end

  local pSrc = self:_GetSrcItem()
  local pHelper = self:_GetHelperItem()
  if not pSrc and not pHelper then
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "◆请把需要重铸的<color=red>装备、重铸符<color>放至指定的格子里！")
    return 0
  elseif not pSrc then
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "◆请把需要重铸的<color=red>装备<color>放至指定的格子里！")
    return 0
  elseif not pHelper then
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "◆请把需要<color=red>重铸符<color>放至指定的格子里！")
    return 0
  elseif 0 == Item:CheckDropRecastItem(tbRecastItem) then
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "◆目前的材料不足，不能进行重铸操作！")
    return 0
  end

  local pOldEquip = Item:GetOldEquip(tbRecastItem)
  local nMoney, nMoneyType = Item:CalcRecastMoney(pOldEquip)
  self.nMoneyType = nMoneyType or Item.emEQUIP_RECAST_CURRENCY_MONEY
  if not pOldEquip then
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, "◆目前的材料不足，不能进行重铸操作！")
    return 0
  end

  local pRecastItem = Item:GetRecastItem(tbRecastItem)
  self.bShowBindMsg = pRecastItem.IsBind()
  self.pOldEquip = pOldEquip

  self:UpdateMoneyFlag(nMoney)
  local szMsg = ""
  if pOldEquip.nEnhTimes < 8 then
    szMsg = szMsg .. "<color=yellow>◆您放入的装备强化等级过低，建议对高强化的装备进行重铸，以免浪费。<color>\n"
  end

  local tbReCastTips = {
    [Item.emEQUIP_RECAST_CURRENCY_MONEY] = { "普通银两", "两" },
    [Item.emEQUIP_RECAST_CURRENCY_LONGHUN] = { "龙纹银币", "个" },
  }

  szMsg = szMsg .. string.format("◆本次重铸需要收取<color=yellow>%s<color>%s%d%s%s。", tbReCastTips[self.nMoneyType][1], (self.nMoneyEnoughFlag > 0) and "" or "<color=red>", nMoney, tbReCastTips[self.nMoneyType][2], (self.nMoneyEnoughFlag > 0) and "" or "<color>")

  Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, szMsg)
  if self.nMoneyEnoughFlag == 1 then
    Wnd_SetEnable(self.tbWnd.UIGROUP, self.tbWnd.BTN_OK, 1)
  end
end

function tbEquipRecast:GetDesc()
  return "重新随机装备的基础属性，随机后不满意可以选择保留原属性。"
end

function tbEquipRecast:SelectBodyEquip(tbObj)
  if tbObj and tbObj.pItem and 1 == self:_CheckEquip(tbObj.pItem) then
    tbMouse:SetObj(tbObj)
    self.tbWnd:GetCont(self.tbWnd.OBJ_SRC_TRANSFER_EQUIP):SwitchObj(0, 0)
    tbMouse:ResetObj()
    return 1
  else
    return 0
  end
end

function tbEquipRecast:CanLeave()
  if self.pOldEquip and self.pNewEquip then
    self:OnCancel()
    return 0
  else
    return 1
  end
end

function tbEquipRecast:SelectEquip(nX, nY)
  local tbCont = self.tbWnd:GetCont(self.tbWnd.OBJ_RECAST_VIEW)
  Btn_Check(self.tbWnd.UIGROUP, self.tbWnd.BTN_SELECT_LEFT, 0)
  Btn_Check(self.tbWnd.UIGROUP, self.tbWnd.BTN_SELECT_RIGHT, 0)

  if tbCont:GetObj(nX, nY) then
    tbCont:SetObjHightLight(nX, nY)
    if 0 == nX then
      Btn_Check(self.tbWnd.UIGROUP, self.tbWnd.BTN_SELECT_LEFT, 1)
    else
      Btn_Check(self.tbWnd.UIGROUP, self.tbWnd.BTN_SELECT_RIGHT, 1)
    end

    self.nCurSelEquip = nX
  end
end

function tbEquipRecast:_CheckEquip(pItem)
  if 1 ~= pItem.IsEquip() then
    return 0
  elseif pItem.nDetail < Item.MIN_COMMON_EQUIP or pItem.nDetail > Item.MAX_COMMON_EQUIP then
    me.Msg("参与五行激活的装备才能进行重铸！")
    return 0
  elseif pItem.nGenre == 1 then
    me.Msg("该装备不能参与重铸！")
    return 0
  end
  return 1
end

function tbEquipRecast:_CheckHelper(pItem)
  if pItem.szClass ~= Item.RECAST_ITEM_CLASS then
    me.Msg("请放入重铸符！")
    return 0
  end
  return 1
end

function tbEquipRecast:_CheckItem(pItem)
  -- 表明已经重铸了装备，但是玩家还没有选择到底要哪一个，所有呢，不能放入物品
  if self.pOldEquip and self.pNewEquip then
    return 0
  end

  if pItem.IsEquip() == 1 then
    if pItem.nDetail < Item.MIN_COMMON_EQUIP or pItem.nDetail > Item.MAX_COMMON_EQUIP then
      me.Msg("参与五行激活的装备才能进行重铸！")
      return 0
    end
    if pItem.nGenre == 1 then
      me.Msg("该装备不能参与重铸！")
      return 0
    end
  elseif pItem.szClass ~= Item.RECAST_ITEM_CLASS then
    me.Msg("只能放置重铸的装备和重铸符！")
    return 0
  end
  return 1
end
---------------------------------------------------------------------------------------------
-- 重铸印鉴
local tbYinJianRecast = Lib:NewClass(tbBase)

function tbYinJianRecast:GetMode()
  return Item.ENHANCE_MODE_YINJIAN_RECAST -- 印鉴重铸
end

function tbYinJianRecast:Enter()
  self._tbBase.Enter(self)

  Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_TARGET_DESC, "高级印鉴")
  Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_SRC_DESC, "低级印鉴")

  UiManager:SetUiState(UiManager.UIS_EQUIP_PEEL)
end

function tbYinJianRecast:Leave()
  self._tbBase.Leave(self)

  self.tbWnd:GetCont(self.tbWnd.OBJ_SRC_TRANSFER_EQUIP):ClearObj()
  self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID):ClearRoom()
  self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):ClearRoom()

  UiManager:ReleaseUiState(UiManager.UIS_EQUIP_PEEL)
end

function tbYinJianRecast:OnOk()
  local pDest = self:_GetTargetItem()
  local pSrc = self:_GetSrcItem()
  if not pDest or not pSrc or pDest.nLevel <= pSrc.nLevel then
    me.Msg("您放置的印鉴不符合要求！")
    return 0
  end

  local tbMsg = {}
  tbMsg.szTitle = "确  认"
  tbMsg.nOptCount = 2
  tbMsg.szMsg = "您确定要重铸印鉴吗？"

  function tbMsg:Callback(nOptIndex, nMode)
    if nOptIndex == 2 then
      me.ApplyEnhance(nMode, 0, 0)
    end
  end

  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, self:GetMode())
end

function tbYinJianRecast:OnCancel()
  if 1 == self.tbWnd:IsAllContEmpy() then
    UiManager:CloseWindow(self.tbWnd.UIGROUP)
    return
  end
  self.tbWnd:GetCont(self.tbWnd.OBJ_SRC_TRANSFER_EQUIP):ClearObj()
  self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID):ClearRoom()
  self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):ClearRoom()
  self:UpdateState()
end

function tbYinJianRecast:OnResult(nResult)
  if 1 == nResult then
    self.tbWnd:GetCont(self.tbWnd.OBJ_SRC_TRANSFER_EQUIP):ClearObj()
    self.tbWnd:GetCont(self.tbWnd.OBJ_ITEM_GRID):ClearRoom()
    self.tbWnd:PlayAnimation()
  else
    print("印鉴重铸失败，原因未知")
  end
end

function tbYinJianRecast:StateReciveUse(pItem)
  local pSrc = self:_GetSrcItem()
  if pSrc then
    if 1 == self:_CheckDes(pItem) then
      self.tbWnd:GetCont(self.tbWnd.OBJ_TARGET_EQUIP):SwitchObj(0, 0)
    else
      tbMouse:ResetObj()
    end
  else
    self.tbWnd:GetCont(self.tbWnd.OBJ_SRC_TRANSFER_EQUIP):SwitchObj(0, 0)
  end
end

function tbYinJianRecast:CheckSwitch(tbCont, pDrop, pPick, nX, nY)
  if not pDrop then
    return 1
  end

  if tbCont.szObjGrid == self.tbWnd.OBJ_TARGET_EQUIP then
    return self:_CheckDes(pDrop)
  elseif tbCont.szObjGrid == self.tbWnd.OBJ_SRC_TRANSFER_EQUIP then
    return self:_CheckSrc(pDrop)
  elseif tbCont.szObjGrid == self.tbWnd.OBJ_ITEM_GRID then
    return 1
  end

  return 0
end

function tbYinJianRecast:UpdateState()
  local szMsg = "◆请放入两种不同装备等级的印鉴，我将为您重铸印鉴，使高级的印鉴具有低级印鉴的能力。"
  Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, szMsg)
  Wnd_SetEnable(self.tbWnd.UIGROUP, self.tbWnd.BTN_OK, 0)

  local pDest = self:_GetTargetItem()
  local pSrc = self:_GetSrcItem()
  if not pDest or not pSrc then
    return
  end

  if pDest.nLevel <= pSrc.nLevel then
    szMsg = szMsg .. "\n◆<color=red>高级印鉴应该比低级印鉴的装备等级高！<color>"
    Txt_SetTxt(self.tbWnd.UIGROUP, self.tbWnd.TXT_DETAIL_DESC, szMsg)
  else
    Wnd_SetEnable(self.tbWnd.UIGROUP, self.tbWnd.BTN_OK, 1)
  end
end

function tbYinJianRecast:GetDesc()
  return "将低级印鉴的强化效果全部转移到高级印鉴去。"
end

function tbYinJianRecast:_CheckDes(pItem)
  if 1 ~= pItem.nGenre or 16 ~= pItem.nDetail then
    return 0
  end

  local pSrc = self:_GetSrcItem()
  if pSrc and pSrc.nLevel >= pItem.nLevel then
    me.Msg("需要放入高装备等级的印鉴！")
    return 0
  end

  return 1
end

function tbYinJianRecast:_CheckSrc(pItem)
  if 1 ~= pItem.nGenre or 16 ~= pItem.nDetail then
    return 0
  end

  local pDest = self:_GetTargetItem()
  if pDest and pDest.nLevel <= pItem.nLevel then
    me.Msg("需要放入低装备等级的印鉴！")
    return 0
  end

  return 1
end

---------------------------------------------------------------------------------------------
-- 容器基类
local tbCont = { bUse = 0, bLink = 0, bSwitch = 0, bShowCd = 0, bSendToGift = 1 }

function tbCont:OnInit(tbWnd)
  self.tbWnd = tbWnd
end

function tbCont:CheckSwitchItem(pDrop, pPick, nX, nY)
  return self.tbWnd:GetCurOp():CheckSwitch(self, pDrop, pPick, nX, nY)
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
-------------------------------------------------------------------------------------------------------------
-- 强化转移的容器需要做特殊处理
local tbTransCont = { bUse = 0, bLink = 1, bShowCd = 0, bSwitch = 1, bSendToGift = 1, tbTargetCont = nil }
function tbTransCont:OnInit(tbWnd)
  self.tbWnd = tbWnd
  self.tbTargetCont = tbWnd:GetCont(tbWnd.OBJ_ITEM_GRID)
end

function tbTransCont:CheckSwitchItem(pDrop, pPick, nX, nY)
  return self.tbWnd:GetCurOp():CheckSwitch(self, pDrop, pPick, nX, nY)
end

function tbTransCont:CheckMouse(tbMouseObj)
  if tbMouseObj.nType ~= Ui.OBJ_OWNITEM then
    return 0 -- 鼠标上不是角色道具不允许交换
  end

  local pItem = me.GetItem(tbMouseObj.nRoom, tbMouseObj.nX, tbMouseObj.nY)
  if not pItem then
    Ui:Output("[ERR] Object机制内部错误！")
    tbMouse:SetObj(nil)
    return 0
  end

  return 1
end

function tbTransCont:CheckSwitch(tbDrop, tbPick, nX, nY)
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

function tbTransCont:SwitchObj(nX, nY)
  local tbObj = self:GetObj(nX, nY)
  local tbMouseObj = tbMouse.tbObj
  assert(tbMouseObj == tbMouse.tbObj) -- 对上面两个函数是否对鼠标Object作了改动的检查

  if 1 ~= self:CheckSwitchItem(pDrop, pPick, nX, nY) then
    return 0
  end

  if tbMouseObj then
    if tbMouseObj.nType ~= 5 or 1 ~= self:CheckMouse(tbMouseObj) or 1 ~= self:CheckSwitch(tbMouseObj, tbObj, nX, nY) then
      return
    end

    local _nX, _nY = nil, nil
    if tbObj then
      _nX = tbObj.nRefX
      _nY = tbObj.nRefY
    else
      _nX, _nY = self.tbTargetCont:GetFreePos()
    end

    if not _nX or not _nY then
      me.Msg("目标空间已满！")
      tbMouse:ResetObj()
    else
      self.tbTargetCont:SwitchObj(_nX, _nY)
      local tbNewObj = self.tbTargetCont:GetObj(_nX or -1, _nY or -1)
      if tbNewObj and _nX and _nY then
        tbNewObj.nRefX = _nX
        tbNewObj.nRefY = _nY
      end
      self:SetObj(tbNewObj, nX, nY)
    end
  elseif tbObj then
    if 1 ~= self:CheckSwitch(tbMouseObj, tbObj, nX, nY) then
      return
    end

    self.tbTargetCont:SwitchObj(tbObj.nRefX, tbObj.nRefY)
    local tbNewObj = self.tbTargetCont:GetObj(tbObj.nRefX, tbObj.nRefY)
    if tbNewObj then
      tbNewObj.nRefX = tbObj.nRefX
      tbNewObj.nRefY = tbObj.nRefY
    end

    self:SetObj(tbNewObj, nX, nY)
  end

  self.tbWnd:OnEventUpdateItem()
end

function tbTransCont:OnObjGridUse(nX, nY)
  local tbObj = self:GetObj(nX, nY)
  if not tbObj then
    return
  end

  self.tbTargetCont:OnObjGridUse(tbObj.nRefX, tbObj.nRefY)
  local tbRef = self.tbTargetCont:GetObj(tbObj.nRefX, tbObj.nRefY)
  -- 可能再使用过程中发生改变
  if tbRef then
    tbRef.nRefX = tbObj.nRefX
    tbRef.nRefY = tbObj.nRefY
  end
  self:SetObj(tbRef, nX, nY)
  self.tbWnd:OnEventUpdateItem()
end

function tbTransCont:Update(nX, nY)
  local tbObj = self:GetObj(nX, nY)
  if not tbObj then
    return
  end

  if not self.tbTargetCont:GetObj(tbObj.nRefX, tbObj.nRefY) then
    self:SetObj(nil, nX, nY)
  else
    self:UpdateObj(tbObj, nX, nY)
  end
end

function tbTransCont:SpecialStateRecvUse()
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

  if not nX or not nY then
    me.Msg("目标空间已满！")
    tbMouse:ResetObj()
    return 0
  else
    self:SwitchObj(nX, nY)
  end
end

function tbTransCont:ClearRoom()
  --assert(false)
  print("这里不支持这个操作！")
  print(debug.traceback())
end
-------------------------------------------------------------------------------------------------------------
-- 拆解物品是，接收显示的物品
local tbSplitCont = { bUse = 0, bLink = 0, bSwitch = 0, bShowCd = 0, bSendToGift = 1 }
function tbSplitCont:OnInit(tbWnd)
  self.tbWnd = tbWnd
end

local nCounter = 0

function tbSplitCont:ClearRoom()
  for y = 0, self.nLine - 1 do
    for x = 0, self.nRow - 1 do
      local tbObj = self:GetObj(x, y)
      if tbObj then
        nCounter = nCounter - 1
        tbTempItem:Destroy(tbObj.pItem)
      end
    end
  end

  self:ClearObj()
end

function tbSplitCont:AddTempObj(nGenre, nDetail, nParticular, nLevel, szSubScript)
  local pItem = tbTempItem:Create(nGenre, nDetail, nParticular, nLevel)
  if not pItem then
    return 0
  end

  nCounter = nCounter + 1

  local tbObj = {}
  tbObj.nType = Ui.OBJ_TEMPITEM
  tbObj.pItem = pItem
  if szSubScript and "" ~= szSubScript then
    tbObj.szSubScript = szSubScript
    tbObj.bShowSubScript = 1
    tbObj.szBgImage = pItem.szIconImage
  end

  local nX, nY = self:GetFreePos()
  if not nX or not nY then
    tbTempItem:Destroy(pItem)
  else
    self:SetObj(tbObj, nX, nY)
  end
end

function tbSplitCont:GetFreePos()
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

function tbSplitCont:UpdateItem(tbItem, nX, nY)
  local pItem = tbItem.pItem
  if tbItem.szSubScript then
    ObjGrid_ChangeSubScript(self.szUiGroup, self.szObjGrid, tbItem.szSubScript, nX, nY)
  end

  local nColor = (me.CanUseItem(pItem) ~= 1) and 0x60ff0000 or 0
  ObjGrid_ChangeBgColor(self.szUiGroup, self.szObjGrid, nColor, nX, nY)
  ObjGrid_SetTransparency(self.szUiGroup, self.szObjGrid, pItem.szTransparencyIcon, nX, nY)
end

function tbSplitCont:FormatItem(tbItem)
  local tbObj = {}
  local pItem = tbItem.pItem
  if not pItem then
    return
  end
  tbObj.szBgImage = pItem.szIconImage
  tbObj.bShowSubScript = 1 -- 总显示下标数字
  return tbObj
end
-------------------------------------------------------------------------------------------------------------
-- 重铸展示容器，专为重铸功能提供的
local tbRecastCont = { bUse = 0, bLink = 0, bSwitch = 0, bShowCd = 0, bSendToGift = 0, bCanSel = 1 }
function tbRecastCont:OnInit(tbWnd)
  self.tbWnd = tbWnd
  self.nSelX = 0
  self.nSelY = 0
end

function tbRecastCont:EnterItem(tbItem, nX, nY)
  -- 普通的查看模式
  if 1 == self.bNormalView then
    self._tbBase.EnterItem(self, tbItem, nX, nY)
  else -- 比较查看模式
    local tbOp = self.tbWnd:GetCurOp()
    local tbObj_1 = self:GetObj(0, 0)
    local tbObj_2 = self:GetObj(1, 0)

    local pItem_1 = nil
    local pItem_2 = nil

    if tbObj_1 and tbObj_1.pItem then
      pItem_1 = tbObj_1.pItem
    end

    if tbObj_2 and tbObj_2.pItem then
      pItem_2 = tbObj_2.pItem
    end

    if pItem_1 and pItem_2 then
      local szNewTitle, szNewTip, szNewView = pItem_1.GetTip(Item.TIPS_NORMAL, "")
      local szOldTitle, szOldTip, szOldView = pItem_2.GetTip(Item.TIPS_NORMAL, "")
      if tbObj_1.szCmpSuffix then
        szNewTip = szNewTip .. "\n" .. tbObj_1.szCmpSuffix
      end
      if tbObj_2.szCmpSuffix then
        szOldTip = szOldTip .. "\n" .. tbObj_2.szCmpSuffix
      end
      Wnd_ShowMouseHoverInfo(self.szUiGroup, self.szObjGrid, szOldTitle, szOldTip, szOldView, szNewTitle, szNewTip, szNewView)
    elseif pItem_1 then
      Wnd_ShowMouseHoverInfo(self.szUiGroup, self.szObjGrid, pItem_1.GetTip(Item.TIPS_NORMAL, ""))
    elseif pItem_2 then
      Wnd_ShowMouseHoverInfo(self.szUiGroup, self.szObjGrid, pItem_2.GetTip(Item.TIPS_NORMAL, ""))
    else
      self._tbBase.EnterItem(self, tbItem, nX, nY)
    end
  end
end
-- 鼠标离开道具Object
function tbRecastCont:LeaveItem(tbItem, nX, nY)
  Wnd_HideMouseHoverInfo()
end
-- 选择道具
function tbRecastCont:SwitchObj(nX, nY)
  local tbObj = self:GetObj(nX, nY)
  if not tbObj or 1 ~= self.bCanSel then
    return
  end

  self.tbWnd:GetCurOp():SelectEquip(nX, nY)
  self:SetObjHightLight(nX, nY)
end
-- 选择
function tbRecastCont:OnObjGridUse(nX, nY)
  self:SwitchObj(nX, nY)
end
-- 情况容器
function tbRecastCont:ClearObj()
  ObjGrid_RemoveHighLightGrid(self.szUiGroup, self.szObjGrid, self.nSelX, self.nSelY, 1)
  self.nSelX = 0
  self.nSelY = 0
  self._tbBase.ClearObj(self)
end

function tbRecastCont:SetObjHightLight(nX, nY)
  ObjGrid_RemoveHighLightGrid(self.szUiGroup, self.szObjGrid, self.nSelX, self.nSelY, 1)
  ObjGrid_AddHighLightGrid(self.szUiGroup, self.szObjGrid, nX, nY, 1)
  self.nSelX = nX
  self.nSelY = nY
end

-- 设置查看模式
function tbRecastCont:SetViewMode(bNormal)
  self.bNormalView = bNormal
end

---------------------------------------------------------------------------------------------
-- 窗口操作
function uiWnd:OnCreate()
  -- 构建容器
  local tbItemCont = Lib:CopyTB1(tbCont)
  tbItemCont.nRoom = Item.ROOM_ENHANCE_ITEM
  tbItemCont.bSwitch = 1
  tbItemCont.bLink = 1
  local tbEquipCont = Lib:CopyTB1(tbCont)
  tbEquipCont.nRoom = Item.ROOM_ENHANCE_EQUIP
  tbEquipCont.bSwitch = 1
  tbEquipCont.bLink = 1

  self.tbWnd2Cont = {
    [self.OBJ_ITEM_GRID] = tbObject:RegisterContainer(self.UIGROUP, self.OBJ_ITEM_GRID, Item.ROOM_ENHANCE_ITEM_WIDTH, Item.ROOM_ENHANCE_ITEM_HEIGHT, tbItemCont, "itemroom", self),
    [self.OBJ_TARGET_EQUIP] = tbObject:RegisterContainer(self.UIGROUP, self.OBJ_TARGET_EQUIP, Item.ROOM_ENHANCE_EQUIP_WIDTH, Item.ROOM_ENHANCE_EQUIP_HEIGHT, tbEquipCont, "itemroom"),
    [self.OBJ_SRC_TRANSFER_EQUIP] = tbObject:RegisterContainer(self.UIGROUP, self.OBJ_SRC_TRANSFER_EQUIP, 1, 1, tbTransCont, ""),
    [self.OBJ_TRANSFER_HELPER] = tbObject:RegisterContainer(self.UIGROUP, self.OBJ_TRANSFER_HELPER, 1, 1, tbTransCont, ""),
    [self.OBJ_ITEM_GRID_TRANSFER] = tbObject:RegisterContainer(self.UIGROUP, self.OBJ_ITEM_GRID_TRANSFER, Item.ROOM_ENHANCE_ITEM_WIDTH, Item.ROOM_ENHANCE_ITEM_HEIGHT, tbTransCont, ""),
    [self.OBJ_ITEM_GRID_SPLIT] = tbObject:RegisterContainer(self.UIGROUP, self.OBJ_ITEM_GRID_SPLIT, 4, 4, tbSplitCont, ""),
    [self.OBJ_RECAST_VIEW] = tbObject:RegisterContainer(self.UIGROUP, self.OBJ_RECAST_VIEW, 2, 1, tbRecastCont, ""),
  }
  for _, tbCont in pairs(self.tbWnd2Cont) do
    tbCont:OnInit(self)
  end

  -----------------------------------------------------------------------------------------------
  -- 操作集合
  self.tbOpSet = {
    [self.BTN_ENHANCE_COMPOSE] = {
      [self.BTN_EQUIP_ENHANCE] = tbEnhanceEquip,
      [self.BTN_XUANJIN_COMPOSE] = tbXuanjingCompose,
      [self.BTN_YINJIAN_LEVELUP] = tbYinJianLevelUp,
      [self.BTN_EQUIP_GAIZHAO] = tbEquipGaiZhao,
    },
    [self.BTN_SPLIT_TRANSFER] = {
      [self.BTN_ENHANCE_TRANSFER] = tbEnhanceTransfer,
      [self.BTN_XUANJIN_SPLIT] = tbXuanjingSplit,
      [self.BTN_WEAPON_SPLIT] = tbWeaponSplit,
      [self.BTN_GAOJI_XUANJIN_SPLIT] = tbGaojiXuanSplit,
    },
    [self.BTN_REFINE_RECAST] = {
      [self.BTN_EQUIP_LIANHUA] = tbEquipRefine,
      [self.BTN_EQUIP_RECAST] = tbEquipRecast,
      [self.BTN_YINJIAN_RECAST] = tbYinJianRecast,
    },
  }

  for szPar, tbOpRef in pairs(self.tbOpSet) do
    for szDetail, tbOp in pairs(tbOpRef) do
      tbOp:OnInit(self, szPar, szDetail)
    end
  end

  self.szCurParticular = ""
  self.szCurDetail = ""
end

function uiWnd:OnDestroy()
  for _, tbCont in pairs(self.tbWnd2Cont) do
    tbObject:UnregContainer(tbCont)
  end
  self.tbWnd2Cont = nil
end

function uiWnd:OnOpen(nMode, nMoneyType)
  nMode = nMode or Item.ENHANCE_MODE_COMPOSE -- 默认为玄晶合成
  if not nMoneyType or nMoneyType ~= Item.BIND_MONEY then
    nMoneyType = Item.NORMAL_MONEY
  end

  self.nMoneyType = nMoneyType
  if nMode == Item.ENHANCE_MODE_ALLOW_ALL then
    nMode = Item.ENHANCE_MODE_COMPOSE
  end

  if nMode == Item.ENHANCE_MODE_ENHANCE then -- 强化
    self:ChangeOp(self.BTN_ENHANCE_COMPOSE, self.BTN_EQUIP_ENHANCE)
  elseif nMode == Item.ENHANCE_MODE_PEEL then -- 玄晶剥离
    self:ChangeOp(self.BTN_SPLIT_TRANSFER, self.BTN_XUANJIN_SPLIT)
  elseif nMode == Item.ENHANCE_MODE_COMPOSE then -- 玄晶合成
    self:ChangeOp(self.BTN_ENHANCE_COMPOSE, self.BTN_XUANJIN_COMPOSE)
  elseif nMode == Item.ENHANCE_MODE_UPGRADE then -- 印鉴审计
    self:ChangeOp(self.BTN_ENHANCE_COMPOSE, self.BTN_YINJIAN_LEVELUP)
  elseif nMode == Item.ENHANCE_MODE_REFINE then -- 炼化
    self:ChangeOp(self.BTN_REFINE_RECAST, self.BTN_EQUIP_LIANHUA)
  elseif nMode == Item.ENHANCE_MODE_STRENGTHEN then -- 装备改造
    self:ChangeOp(self.BTN_ENHANCE_COMPOSE, self.BTN_EQUIP_GAIZHAO)
  elseif nMode == Item.ENHANCE_MODE_ENHANCE_TRANSFER then -- 强化转移
    self:ChangeOp(self.BTN_SPLIT_TRANSFER, self.BTN_ENHANCE_TRANSFER)
  elseif nMode == Item.ENHANCE_MODE_EQUIP_RECAST then -- 装备重铸
    self:ChangeOp(self.BTN_REFINE_RECAST, self.BTN_EQUIP_RECAST)
  elseif nMode == Item.ENHANCE_MODE_WEAPON_PEEL then -- 青铜武器剥离
    self:ChangeOp(self.BTN_SPLIT_TRANSFER, self.BTN_WEAPON_SPLIT)
  elseif nMode == Item.ENHANCE_MODE_BREAKUP_XUAN then -- 高级玄晶拆解
    self:ChangeOp(self.BTN_SPLIT_TRANSFER, self.BTN_GAOJI_XUANJIN_SPLIT)
  elseif nMode == Item.ENHANCE_MODE_YINJIAN_RECAST then -- 印鉴重铸
    self:ChangeOp(self.BTN_REFINE_RECAST, self.BTN_YINJIAN_RECAST)
  else -- 默认为玄晶合成
    self:ChangeOp(self.BTN_ENHANCE_COMPOSE, self.BTN_XUANJIN_COMPOSE)
  end

  self:UpdateWndState()
  UiManager:OpenWindow(Ui.UI_ITEMBOX)

  Tutorial:DoNewEquipEnhance() --强化界面指引
end

function uiWnd:OnClose()
  self:ChangeOp("", "")
  me.ApplyEnhance(Item.ENHANCE_MODE_NONE, 0) -- 通知服务端取消强化/剥离操作
  if UiVersion ~= Ui.Version001 then
    if UiManager:WindowVisible(Ui.UI_ENHANCESELECTEQUIP) == 1 then
      UiManager:CloseWindow(Ui.UI_ENHANCESELECTEQUIP)
    end
  end
  -- 关闭背包
  UiManager:CloseWindow(Ui.UI_ITEMBOX)
end

-- 鼠标点击操作
function uiWnd:OnButtonClick(szWnd)
  if szWnd == self.szCurDetail then
    Btn_Check(self.UIGROUP, szWnd, 1)
    return
  end

  if szWnd == self.szCurParticular then
    Btn_Check(self.UIGROUP, szWnd, 1)
    return
  end

  if self.BTN_EQUIP_GAIZHAO == szWnd and 1 ~= Item.IVER_nEquipStrengthen then
    me.Msg("装备改造尚未开放，敬请期待！")
    Btn_Check(self.UIGROUP, szWnd, 0)
    self:UpdateWndState()
    return
  end

  if self.tbOpSet[self.szCurParticular] and self.tbOpSet[self.szCurParticular][szWnd] then
    self:ChangeOp(self.szCurParticular, szWnd)
    return
  end

  if szWnd == self.BTN_ENHANCE_COMPOSE then
    self:ChangeOp(self.BTN_ENHANCE_COMPOSE, self.BTN_EQUIP_ENHANCE)
  elseif szWnd == self.BTN_SPLIT_TRANSFER then
    self:ChangeOp(self.BTN_SPLIT_TRANSFER, self.BTN_ENHANCE_TRANSFER)
  elseif szWnd == self.BTN_REFINE_RECAST then
    self:ChangeOp(self.BTN_REFINE_RECAST, self.BTN_EQUIP_LIANHUA)
  elseif szWnd == self.BTN_BIND_MONEY then
    self.nMoneyType = Item.BIND_MONEY
    self:GetCurOp():SelectMoney(Item.BIND_MONEY)
  elseif szWnd == self.BTN_NORMAL_MONEY then
    self.nMoneyType = Item.NORMAL_MONEY
    self:GetCurOp():SelectMoney(Item.NORMAL_MONEY)
  elseif szWnd == self.BTN_OK then
    self:GetCurOp():OnOk()
  elseif szWnd == self.BTN_CANCEL then
    self:GetCurOp():OnCancel()
  elseif szWnd == self.BTN_SPLIT_APPLY then
    self:GetCurOp():ApplySplit()
  elseif szWnd == self.BTN_SRC_TRANSFER_LST or szWnd == self.BTN_TARGET_EQUIP_LST then
    local _, _, nX, nY = Wnd_GetPos(self.UIGROUP, szWnd)
    local nWidth, nHeight = Wnd_GetSize(self.UIGROUP, szWnd)
    UiManager:SwitchWindow(Ui.UI_ENHANCESELECTEQUIP, self.UIGROUP, nX + nWidth, nY + nHeight)
  elseif szWnd == self.BTN_CLOSE and 1 == self:CanDirectClose() then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_SELECT_LEFT then
    self:GetCurOp():SelectEquip(0, 0)
  elseif szWnd == self.BTN_SELECT_RIGHT then
    self:GetCurOp():SelectEquip(1, 0)
  elseif szWnd == self.BTN_SERIES_WEEK or szWnd == self.BTN_SERIES_STRENGTH then
    self:GetCurOp():_SelectSeries(szWnd)
  end

  self:UpdateWndState()
end

function uiWnd:OnListSel(szWnd, nParam)
  self:GetCurOp():UpdateState()
end

function uiWnd:OnAnimationOver(szWnd)
  Wnd_Hide(self.UIGROUP, szWnd)
end

function uiWnd:OnEventSyncItem(nRoom, nX, nY)
  if 1 == UiManager:WindowVisible(self.UIGROUP) then
    self:GetCurOp():UpdateState()
  end
end

function uiWnd:OnEventUpdateItem()
  if 1 == UiManager:WindowVisible(self.UIGROUP) then
    self:GetCurOp():UpdateState()
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

  local pItem = me.GetItem(tbObj.nRoom, tbObj.nX, tbObj.nY)
  if pItem then
    self:GetCurOp():StateReciveUse(pItem)
    self:GetCurOp():UpdateState()
  end
end
-- 结果反馈
function uiWnd:OnEventResult(nMode, nResult)
  if 1 ~= UiManager:WindowVisible(self.UIGROUP) then
    return
  end

  if self:GetCurOp():GetMode() ~= nMode then
    print(debug.traceback())
    return
  else
    self:GetCurOp():OnResult(nResult)
    self:GetCurOp():UpdateState()
  end
end
-- 结果反馈
function uiWnd:OnEventReCastResult(nResult, nNewSeed, ...)
  if 1 ~= UiManager:WindowVisible(self.UIGROUP) then
    return
  end

  if self:GetCurOp():GetMode() ~= Item.ENHANCE_MODE_EQUIP_RECAST then
    print(debug.traceback())
    return
  else
    self:GetCurOp():OnResult(nResult, nNewSeed, unpack(arg))
    self:GetCurOp():UpdateState()
  end
end
-- buff状态改变
function uiWnd:OnEventBuffChange()
  if 1 ~= UiManager:WindowVisible(self.UIGROUP) then
    return
  end

  self:GetCurOp():OnBuffChange()
end

function uiWnd:PlayAnimation(...)
  Wnd_Show(self.UIGROUP, self.IMG_SUCCESS_EFFECT)
  Img_PlayAnimation(self.UIGROUP, self.IMG_SUCCESS_EFFECT) -- 播放动画特效
end

function uiWnd:UpdateWndState()
  Btn_Check(self.UIGROUP, self.BTN_ENHANCE_COMPOSE, 0)
  Btn_Check(self.UIGROUP, self.BTN_SPLIT_TRANSFER, 0)
  Btn_Check(self.UIGROUP, self.BTN_REFINE_RECAST, 0)

  Btn_Check(self.UIGROUP, self.szCurParticular, 1)

  Btn_Check(self.UIGROUP, self.BTN_BIND_MONEY, 0)
  Btn_Check(self.UIGROUP, self.BTN_NORMAL_MONEY, 0)

  if Item.BIND_MONEY == self.nMoneyType then
    Btn_Check(self.UIGROUP, self.BTN_BIND_MONEY, 1)
  else
    Btn_Check(self.UIGROUP, self.BTN_NORMAL_MONEY, 1)
  end

  if self.szCurParticular == self.BTN_ENHANCE_COMPOSE then
    Wnd_Show(self.UIGROUP, self.IMG_ENHANCE_CONPOSE)
    Wnd_Hide(self.UIGROUP, self.IMG_SPLIT_TRANSFER)
    Wnd_Hide(self.UIGROUP, self.IMG_REFINE_RECAST)
  elseif self.szCurParticular == self.BTN_SPLIT_TRANSFER then
    Wnd_Hide(self.UIGROUP, self.IMG_ENHANCE_CONPOSE)
    Wnd_Show(self.UIGROUP, self.IMG_SPLIT_TRANSFER)
    Wnd_Hide(self.UIGROUP, self.IMG_REFINE_RECAST)
  else
    Wnd_Hide(self.UIGROUP, self.IMG_ENHANCE_CONPOSE)
    Wnd_Hide(self.UIGROUP, self.IMG_SPLIT_TRANSFER)
    Wnd_Show(self.UIGROUP, self.IMG_REFINE_RECAST)
  end
end

function uiWnd:ChangeOp(szParticular, szDetail)
  local tbOp = self:GetCurOp()
  if tbOp then
    tbOp:Leave()
  end

  self.szCurParticular = szParticular
  self.szCurDetail = szDetail

  tbOp = self:GetCurOp()
  if tbOp then
    tbOp:Enter()
    tbOp:SelectMoney(self.nMoneyType)
    tbOp:UpdateState()
  end
end

function uiWnd:GetCurOp()
  local tbParticular = self.tbOpSet[self.szCurParticular or ""]
  if tbParticular then
    return tbParticular[self.szCurDetail or ""]
  else
    return nil
  end
end

function uiWnd:GetCont(szContWnd)
  return self.tbWnd2Cont[szContWnd or ""]
end
-- 能否直接关闭
function uiWnd:CanDirectClose()
  return self:GetCurOp():CanLeave()
end
-- 选择身上的装备
function uiWnd:SelectBodyEquip(tbObj)
  return self:GetCurOp():SelectBodyEquip(tbObj)
end
-- 是否所有容器都是空的
function uiWnd:IsAllContEmpy()
  local nCount = 0
  for _, tbCont in pairs(self.tbWnd2Cont) do
    nCount = nCount + self:GetObjCount(tbCont)
  end
  if 0 == nCount then
    return 1
  else
    return 0
  end
end
-- 获取容器内的个数
function uiWnd:GetObjCount(tbCont)
  local nWidth = tbCont.nRow
  local nHeight = tbCont.nLine
  local nCount = 0
  for nY = 0, nHeight do
    for nX = 0, nWidth do
      if tbCont:GetObj(nX, nY) then
        nCount = nCount + 1
      end
    end
  end
  return nCount
end

-- 注册事件
function uiWnd:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_ITEM, self.OnEventUpdateItem }, -- 角色道具同步事件
    { UiNotify.emCOREEVENT_MONEY_CHANGED, self.OnEventUpdateItem }, -- 金钱发生改变
    { UiNotify.emUIEVENT_OBJ_STATE_USE, self.OnEventStateRecvUse }, -- 道具switch
    { UiNotify.emCOREEVENT_ENHANCE_RESULT, self.OnEventResult }, -- 同步强化/剥离操作结果
    { UiNotify.emCOREEVENT_RECAST_RESULT, self.OnEventReCastResult }, -- 重铸发生变化
    { UiNotify.emCOREEVENT_BUFF_CHANGE, self.OnEventBuffChange }, -- buff状态改变
  }

  for _, tbCont in pairs(self.tbWnd2Cont) do
    Lib:MergeTable(tbRegEvent, tbCont:RegisterEvent())
  end

  return tbRegEvent
end

function uiWnd:RegisterMessage()
  local tbRegMsg = {}
  for _, tbCont in pairs(self.tbWnd2Cont) do
    Lib:MergeTable(tbRegMsg, tbCont:RegisterMessage())
  end
  return tbRegMsg
end
