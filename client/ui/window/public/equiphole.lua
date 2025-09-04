-----------------------------------------------------
--文件名		：	equiphole.lua
--创建者		：	zhongjunqi@kingsoft.com
--创建时间		：	2011-05-26
--功能描述		：	装备打孔/宝石镶嵌/宝石剥离
------------------------------------------------------

local uiEquipHole = Ui:GetClass("equiphole")
local tbObject = Ui.tbLogic.tbObject
local tbMouse = Ui.tbLogic.tbMouse
local tbTempItem = Ui.tbLogic.tbTempItem

local TXT_TITLE = "TxtTitle"
local TXT_MESSAGE = "TxtMessage"
local BTN_CONFIRM = "BtnOk"
local BTN_CLOSE = "BtnClose"
local IMG_EFFECT = "ImgEffect"
local OBJ_EQUIP = "ObjEquip"
local OBJ_HOLE1 = "ObjHole1"
local OBJ_HOLE2 = "ObjHole2"
local OBJ_HOLE3 = "ObjHole3"
local OBJ_STONE1 = "ObjStone1"
local OBJ_STONE2 = "ObjStone2"
local OBJ_STONE3 = "ObjStone3"
local BTN_MAKEHOLE1 = "BtnMakeHole1"
local BTN_MAKEHOLE2 = "BtnMakeHole2"
local BTN_MAKEHOLE3 = "BtnMakeHole3"
local IMG_HOLEMASK1 = "ImgHoleMask1"
local IMG_HOLEMASK2 = "ImgHoleMask2"
local IMG_HOLEMASK3 = "ImgHoleMask3"
local BTN_UPGRADHOLE = "BtnUpgradHole"
local BTN_PEELSTONE = "BtnPeelStone"

local MODE_TEXT = {
  [Item.HOLE_MODE_MAKEHOLE] = "装备打孔",
  [Item.HOLE_MODE_MAKEHOLEEX] = "装备打孔",
  [Item.HOLE_MODE_ENCHASE] = "宝石镶嵌/剥离",
  [Item.HOLE_MODE_STONE_UPGRADE] = "宝石升级",
}

function uiEquipHole:Init()
  self.nMode = Item.HOLE_MODE_NONE
  self.tbTempItem = {} -- 用于保存创建的临时变量
  self.tbPeelHoleFlag = {}
end

local tbEquipCont = { bUse = 0, nRoom = Item.ROOM_HOLE_EQUIP, bSendToGift = 1 }
local tbHoleCont = {} -- 用于宝石镶嵌剥离
local tbStoneCont = {} -- 用于打孔

function tbEquipCont:CheckSwitchItem(pDrop, pPick, nX, nY)
  local uiHole = Ui(Ui.UI_EQUIPHOLE)
  if (not uiHole) or (uiHole.nMode == Item.HOLE_MODE_STONE_UPGRADE) then
    return 0 -- 不能拿出也不能放入
  end
  if not pDrop then
    uiHole.tbPeelHoleFlag = {}
    uiHole:CheckShowCtrl(nil)
    Wnd_SetTip(uiHole.UIGROUP, OBJ_EQUIP, "在此处放入装备")
    Txt_SetTxt(uiHole.UIGROUP, "TxtDesc", "把装备放入下面的格子，然后进行镶嵌/剥离")
    return 1 -- 只是把东西拿出来，总是成功
  end
  local bRet, szMsg = Item:CheckCanEnchaseStone(pDrop, uiHole.nExpectEquipPos)
  if bRet ~= 1 then
    me.Msg(szMsg)
    return 0
  end
  uiHole.tbPeelHoleFlag = {}
  uiHole:CheckShowCtrl(pDrop)
  Wnd_SetTip(uiHole.UIGROUP, OBJ_EQUIP, "")
  if uiHole.nMode == Item.HOLE_MODE_ENCHASE then
    Txt_SetTxt(uiHole.UIGROUP, "TxtDesc", "把宝石放入格子里镶嵌，选中宝石后可剥离")
  end
  return 1
end

-- 宝石放入obj的事件
function tbHoleCont:OnDrop(tbMouseObj, nX, nY)
  if Ui(Ui.UI_EQUIPHOLE).nMode ~= Item.HOLE_MODE_STONE_UPGRADE then
    local pItem = me.GetItem(tbMouseObj.nRoom, tbMouseObj.nX, tbMouseObj.nY)
    if not pItem then
      return 0
    end
    local pEquip = me.GetItem(Item.ROOM_HOLE_EQUIP, 0, 0)
    if not pEquip then
      return 0
    end
    local tbMsg = {}
    if pItem.IsBind() == 1 and pEquip.IsBind() ~= 1 then -- 宝石是绑定的，装备不绑定
      tbMsg.szMsg = "镶嵌会导致装备与你绑定，是否确定镶嵌？"
    elseif pItem.IsBind() ~= 1 and pEquip.IsBind() ~= 1 then
      tbMsg.szMsg = "镶嵌会导致装备和宝石都与你绑定，是否确定镶嵌？"
    elseif pItem.IsBind() ~= 1 then
      tbMsg.szMsg = "镶嵌会导致宝石与你绑定，是否确定镶嵌？"
    else
      me.ApplyEnchaseStone(self.nHoleId, pItem.dwId)
      return 1
    end
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex, nHoleId, dwStoneId)
      if nOptIndex == 2 then
        me.ApplyEnchaseStone(nHoleId, dwStoneId) -- 向服务器申请镶嵌宝石,是否可以镶嵌宝石，CheckSwitchItem已经判断过了
      else
        me.SetItem(pItem, tbMouseObj.nRoom, tbMouseObj.nX, tbMouseObj.nY)
      end
    end
    -- 询问是否绑定
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, self.nHoleId, pItem.dwId)
  end

  return 1
end

-- 点击格子的事件
function tbHoleCont:OnPick(tbObj, nX, nY)
  if not tbObj then
    return 0
  end

  if Ui(Ui.UI_EQUIPHOLE).nMode == Item.HOLE_MODE_STONE_UPGRADE then
    if UiManager:GetUiState(UiManager.UIS_STONE_UPGRADE) ~= 1 then
      return 0
    end

    local pItem = me.GetItem(Item.ROOM_HOLE_EQUIP, 0, 0)
    if not pItem then
      return 0
    end

    me.ApplyStoneOperation(Item.tbStone.emSTONE_OPERATION_UPGRADE, pItem.dwId, self.nHoleId)

    -- 释放鼠标状态
    UiManager:ReleaseUiState(UiManager.UIS_STONE_UPGRADE)
  end

  return 0 -- 一定要返回0，保证不能捡起OBJ
end

function tbHoleCont:CheckSwitchItem(pDrop, pPick, nX, nY)
  local uiHole = Ui(Ui.UI_EQUIPHOLE)
  if not uiHole then
    return 0
  end

  if not pDrop then
    if uiHole.nMode == Item.HOLE_MODE_STONE_UPGRADE then
      return 1
    elseif uiHole.nMode == Item.HOLE_MODE_ENCHASE then
      -- 如果是拿起东西，绘制下光圈
      if pPick then
        if not uiHole.tbPeelHoleFlag[self.nHoleId] then
          -- 绘制光圈
          uiHole.tbPeelHoleFlag[self.nHoleId] = 1
        else
          -- 隐藏绘制光圈
          uiHole.tbPeelHoleFlag[self.nHoleId] = nil
        end
        uiHole:ShowSelectHole()
      end
    end
    return 0 -- 永远无法拿起东西
  end

  if uiHole.nMode ~= Item.HOLE_MODE_ENCHASE then
    return 0
  end

  local pEquip = me.GetItem(Item.ROOM_HOLE_EQUIP, 0, 0) -- 放入的装备
  if pEquip == nil then
    me.Msg("请先放入要镶嵌的装备！")
    return 0
  end

  -- 判断是否可以镶嵌这个宝石
  local bRet, szMsg = Item:CanEnchaseStone(pEquip, self.nHoleId, pDrop)
  if bRet ~= 1 then
    me.Msg(szMsg)
    return 0
  end
  -- 如果已经镶嵌了宝石，判断背包空间是否足够放拿下的宝石
  local _, dwStone = pEquip.GetHoleStone(self.nHoleId)
  if dwStone ~= 0 then
    if me.CountFreeBagCell() < 1 then
      me.Msg("背包空间不足，请准备好至少1个位置。")
      return 0
    end
  end

  return 1
end

-- 不允许交换，这里只不过为了给提示而已
function tbStoneCont:CheckSwitchItem(pDrop, pPick, nX, nY)
  UiManager:OpenWindow("UI_INFOBOARD", "<color=yellow>在宝石镶嵌/剥离界面里才能操作，ALT+左键点击装备可打开该界面<color>")
  me.Msg("<color=yellow>在宝石镶嵌/剥离界面里面才能操作，ALT+左键点击装备可打开该界面。<color>")
  return 0
end

function uiEquipHole:OnCreate()
  self.tbEquipCont = tbObject:RegisterContainer(self.UIGROUP, OBJ_EQUIP, Item.ROOM_HOLE_EQUIP_WIDTH, Item.ROOM_HOLE_EQUIP_HEIGHT, tbEquipCont, "itemroom")
  self.tbHoleCont1 = tbObject:RegisterContainer(self.UIGROUP, OBJ_HOLE1, 1, 1, tbHoleCont, "stoneroom")
  self.tbHoleCont1.nHoleId = 1

  self.tbHoleCont2 = tbObject:RegisterContainer(self.UIGROUP, OBJ_HOLE2, 1, 1, tbHoleCont, "stoneroom")
  self.tbHoleCont2.nHoleId = 2

  self.tbHoleCont3 = tbObject:RegisterContainer(self.UIGROUP, OBJ_HOLE3, 1, 1, tbHoleCont, "stoneroom")
  self.tbHoleCont3.nHoleId = 3

  self.tbStone1Cont = tbObject:RegisterContainer(self.UIGROUP, OBJ_STONE1, 1, 1, tbStoneCont, "stoneroom")

  self.tbStone2Cont = tbObject:RegisterContainer(self.UIGROUP, OBJ_STONE2, 1, 1, tbStoneCont, "stoneroom")

  self.tbStone3Cont = tbObject:RegisterContainer(self.UIGROUP, OBJ_STONE3, 1, 1, tbStoneCont, "stoneroom")
end

function uiEquipHole:OnDestroy()
  tbObject:UnregContainer(self.tbEquipCont)
  tbObject:UnregContainer(self.tbHoleCont1)
  tbObject:UnregContainer(self.tbHoleCont2)
  tbObject:UnregContainer(self.tbHoleCont3)
  tbObject:UnregContainer(self.tbStone1Cont)
  tbObject:UnregContainer(self.tbStone2Cont)
  tbObject:UnregContainer(self.tbStone3Cont)
  self:DeleteTempAllStuff()
  self.nMode = Item.HOLE_MODE_NONE
  self.tbPeelHoleFlag = {}
end

-- nMode 模式，nExpectEquipType 预期的装备位置类型，
function uiEquipHole:OnOpen(nMode, nExpectEquipPos)
  if Item.tbStone:GetOpenDay() == 0 then
    return
  end
  if nMode == Item.HOLE_MODE_MAKEHOLE then
    UiManager:SetUiState(UiManager.UIS_HOLE_MAKEHOLE)
  elseif nMode == Item.HOLE_MODE_MAKEHOLEEX then
    UiManager:SetUiState(UiManager.UIS_HOLE_MAKEHOLEEX)
  elseif nMode == Item.HOLE_MODE_ENCHASE then
    UiManager:SetUiState(UiManager.UIS_HOLE_ENCHASE)
    Wnd_Show(self.UIGROUP, BTN_PEELSTONE)
  elseif nMode == Item.HOLE_MODE_STONE_UPGRADE then -- 升级装备孔内的宝石
  else
    return 0
  end
  self.nMode = nMode
  self.tbEquipCont.nMode = nMode
  if nExpectEquipPos == 0xFF or nExpectEquipPos == nil then
    self.nExpectEquipPos = nil
  else
    self.nExpectEquipPos = nExpectEquipPos -- 只能是这个装备
  end
  self:CheckShowCtrl()
  UiManager:OpenWindow(Ui.UI_ITEMBOX)
  local szTitle = MODE_TEXT[nMode]
  if self.nExpectEquipPos then
    szTitle = MODE_TEXT[nMode] .. "(" .. (Item.EQUIPPOS_NAME[self.nExpectEquipPos] or "未知") .. ")"
  end
  Txt_SetTxt(self.UIGROUP, TXT_TITLE, szTitle)
  if nMode == Item.HOLE_MODE_MAKEHOLE or nMode == Item.HOLE_MODE_MAKEHOLEEX then
    Txt_SetTxt(self.UIGROUP, "TxtDesc", "把装备放入下面的格子，点击锁头进行打孔")
  elseif nMode == Item.HOLE_MODE_ENCHASE then
    Txt_SetTxt(self.UIGROUP, "TxtDesc", "把装备放入下面的格子，然后进行镶嵌/剥离")
  elseif nMode == Item.HOLE_MODE_STONE_UPGRADE then
    Txt_SetTxt(self.UIGROUP, "TxtDesc", "鼠标单击孔内的宝石可进行升级")
  end

  Wnd_SetTip(self.UIGROUP, OBJ_EQUIP, "在此处放入装备")
end

function uiEquipHole:OnClose()
  me.ApplyMakeHole(Item.HOLE_MODE_NONE, 0)
  self.tbEquipCont:ClearRoom()
  self.tbHoleCont1:ClearObj()
  self.tbHoleCont2:ClearObj()
  self.tbHoleCont3:ClearObj()
  self.tbStone1Cont:ClearObj()
  self.tbStone2Cont:ClearObj()
  self.tbStone3Cont:ClearObj()
  self:DeleteTempAllStuff()

  if self.nMode == Item.HOLE_MODE_MAKEHOLE then
    UiManager:ReleaseUiState(UiManager.UIS_HOLE_MAKEHOLE)
  elseif self.nMode == Item.HOLE_MODE_MAKEHOLEEX then
    UiManager:ReleaseUiState(UiManager.UIS_HOLE_MAKEHOLEEX)
  elseif self.nMode == Item.HOLE_MODE_ENCHASE then
    UiManager:ReleaseUiState(UiManager.UIS_HOLE_ENCHASE)
  end
  self.nMode = Item.HOLE_MODE_NONE
  self.tbPeelHoleFlag = {}
end

function uiEquipHole:Update()
  local pEquip = me.GetItem(Item.ROOM_HOLE_EQUIP)
  if self.nMode == Item.HOLE_MODE_MAKEHOLE then
    self:CheckShowCtrl(pEquip, 0) -- 检测显示打孔按钮
  elseif self.nMode == Item.HOLE_MODE_MAKEHOLEEX then
    self:CheckShowCtrl(pEquip, 1) -- 检测显示打孔按钮
  end
  self:CheckShowCtrl(pEquip)
end

function uiEquipHole:OnSyncItem(nRoom, nX, nY)
  -- 直接更新算了，反正这种情况不多
  self:Update()
end

-- 装备打孔结果
function uiEquipHole:OnMakeHoleResult(byHoleId, byMode, byUpgrad, byResult)
  if byResult == 1 then
    Wnd_Show(self.UIGROUP, IMG_EFFECT)
    Img_PlayAnimation(self.UIGROUP, IMG_EFFECT) -- 播放动画特效

    local nHoleLevel = self:GetCurEquipHoleLevel() -- 得到应该打孔的等级
    if nHoleLevel == 0 then -- 可能装备被拿走了
      me.Msg("打孔成功。")
      return
    end
    if byUpgrad == 1 then
      me.Msg(string.format("升级成功，可镶嵌%s级及%s级以下的普通和特殊宝石。", nHoleLevel, nHoleLevel))
    else
      me.Msg(string.format("打孔成功，可镶嵌%s级及%s级以下的普通宝石。", nHoleLevel, nHoleLevel))
    end
  else
    me.Msg("打孔失败。")
  end
end

function uiEquipHole:OnAnimationOver(szWnd)
  Wnd_Hide(self.UIGROUP, szWnd) -- 播放完毕，隐藏图像
end

-- 宝石镶嵌/剥离结果
function uiEquipHole:OnEnchaseStoneResult(byHoleId, dwEquipId, byMode, dwStoneId, byResult)
  if byResult == 1 then
    if byMode == 1 then
      if byHoleId == 1 then
        Wnd_Show(self.UIGROUP, "ImgEffect1Ex")
        Img_PlayAnimation(self.UIGROUP, "ImgEffect1Ex") -- 播放动画特效
      end
      local szEffect = "ImgEffect" .. byHoleId
      Wnd_Show(self.UIGROUP, szEffect)
      Img_PlayAnimation(self.UIGROUP, szEffect) -- 播放动画特效
      me.Msg("宝石镶嵌成功。")
    else
      me.Msg("宝石剥离成功。")
    end
  else
    if byMode == 1 then
      me.Msg("宝石镶嵌失败。")
    else
      me.Msg("宝石剥离失败。")
    end
    self:Update()
  end
end

-- 使用物品消息
function uiEquipHole:StateRecvUse(szGroup)
  if szUiGroup == self.UIGROUP then
    return
  end

  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    return
  end

  local tbObj = tbMouse:GetObj()
  if not tbObj then
    return
  end
  local pItem = me.GetItem(tbObj.nRoom, tbObj.nX, tbObj.nY)
  -- 如果可以放入才进行交换
  local bRet, szMsg = Item:CheckCanEnchaseStone(pItem, self.nExpectEquipPos)
  if bRet ~= 1 then
    tbMouse:ResetObj()
    me.Msg(szMsg)
    return
  end

  self.tbEquipCont:ClearRoom()
  self.tbEquipCont:SpecialStateRecvUse()
end

function uiEquipHole:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_ITEM, self.OnSyncItem }, -- 角色道具同步事件
    { UiNotify.emCOREEVENT_MAKEHOLE_RESULT, self.OnMakeHoleResult }, -- 打孔结果
    { UiNotify.emCOREEVENT_ENCHASESTONE_RESULT, self.OnEnchaseStoneResult }, -- 宝石镶嵌/剥离结果
    --		{ UiNotify.emCOREEVENT_MONEY_CHANGED,	self.UpdateItem },		-- 金钱发生改变?
    { UiNotify.emUIEVENT_OBJ_STATE_USE, self.StateRecvUse },
    --		{ UiNotify.emCOREEVENT_RECAST_RESULT,self.OnReCastResult}, -- 重铸发生变化
  }
  Lib:MergeTable(tbRegEvent, self.tbEquipCont:RegisterEvent())
  Lib:MergeTable(tbRegEvent, self.tbHoleCont1:RegisterEvent())
  Lib:MergeTable(tbRegEvent, self.tbHoleCont2:RegisterEvent())
  Lib:MergeTable(tbRegEvent, self.tbHoleCont3:RegisterEvent())
  Lib:MergeTable(tbRegEvent, self.tbStone1Cont:RegisterEvent())
  Lib:MergeTable(tbRegEvent, self.tbStone2Cont:RegisterEvent())
  Lib:MergeTable(tbRegEvent, self.tbStone3Cont:RegisterEvent())

  return tbRegEvent
end

function uiEquipHole:RegisterMessage()
  local tbRegMsg = {}
  Lib:MergeTable(tbRegMsg, self.tbEquipCont:RegisterMessage())
  Lib:MergeTable(tbRegMsg, self.tbHoleCont1:RegisterMessage())
  Lib:MergeTable(tbRegMsg, self.tbHoleCont2:RegisterMessage())
  Lib:MergeTable(tbRegMsg, self.tbHoleCont3:RegisterMessage())
  Lib:MergeTable(tbRegMsg, self.tbStone1Cont:RegisterMessage())
  Lib:MergeTable(tbRegMsg, self.tbStone2Cont:RegisterMessage())
  Lib:MergeTable(tbRegMsg, self.tbStone3Cont:RegisterMessage())
  return tbRegMsg
end

-- 重置按钮状态，隐藏所有按钮
function uiEquipHole:ResetBtnState()
  for i = 1, Item.nMaxHoleCount do -- 隐藏所有按钮图片
    Wnd_Hide(self.UIGROUP, "BtnMakeHole" .. i)
    Wnd_Hide(self.UIGROUP, "ImgDisableBtn" .. i)
  end

  Wnd_Hide(self.UIGROUP, BTN_UPGRADHOLE) -- 隐藏打孔升级按钮
  self:HideAllObjHole()

  self:HideStoneCont()
  self:HideMask() -- 隐藏所有选择图片
  self:HideHole() -- 隐藏所有孔的图片
end

-- 隐藏所有镶嵌宝石的obj
function uiEquipHole:HideAllObjHole()
  Wnd_Hide(self.UIGROUP, OBJ_HOLE1) -- 隐藏宝石obj容器
  Wnd_Hide(self.UIGROUP, OBJ_HOLE2) -- 隐藏宝石obj容器
  Wnd_Hide(self.UIGROUP, OBJ_HOLE3) -- 隐藏宝石obj容器
end

-- 显示所有镶嵌宝石的obj
function uiEquipHole:ShowAllObjHole()
  Wnd_Show(self.UIGROUP, OBJ_HOLE1) -- 隐藏宝石obj容器
  Wnd_SetTip(self.UIGROUP, OBJ_HOLE1, "")
  Wnd_Show(self.UIGROUP, OBJ_HOLE2) -- 隐藏宝石obj容器
  Wnd_SetTip(self.UIGROUP, OBJ_HOLE2, "")
  Wnd_Show(self.UIGROUP, OBJ_HOLE3) -- 隐藏宝石obj容器
  Wnd_SetTip(self.UIGROUP, OBJ_HOLE3, "")
end

function uiEquipHole:HideStoneCont()
  Wnd_Hide(self.UIGROUP, OBJ_STONE1) -- 隐藏宝石的obj
  Wnd_Hide(self.UIGROUP, OBJ_STONE2) -- 隐藏宝石的obj
  Wnd_Hide(self.UIGROUP, OBJ_STONE3) -- 隐藏宝石的obj
end

-- 隐藏所有孔的图片
function uiEquipHole:HideHole()
  Wnd_Hide(self.UIGROUP, "ImgHole1")
  Wnd_Hide(self.UIGROUP, "ImgHole2")
  Wnd_Hide(self.UIGROUP, "ImgHole3")
  Wnd_Hide(self.UIGROUP, "ImgHoleSpecial")
end

function uiEquipHole:HideMask()
  Wnd_Hide(self.UIGROUP, IMG_HOLEMASK1) -- 隐藏高亮选择
  Wnd_Hide(self.UIGROUP, IMG_HOLEMASK2) -- 隐藏高亮选择
  Wnd_Hide(self.UIGROUP, IMG_HOLEMASK3) -- 隐藏高亮选择
  Wnd_Hide(self.UIGROUP, "ImgHoleMaskSpecial") -- 隐藏高亮选择
end

-- 检测显示打孔按钮, pEquip 要打孔的装备
function uiEquipHole:CheckShowCtrl(pEquip)
  self:ResetBtnState()
  if self.nMode == Item.HOLE_MODE_MAKEHOLE or self.nMode == Item.HOLE_MODE_MAKEHOLEEX then
    if pEquip == nil then
      self:ShowStoneItem(nil)
      Wnd_Show(self.UIGROUP, "ImgHole1") -- 显示普通孔图片
      Wnd_Show(self.UIGROUP, "ImgHole2") -- 显示普通孔图片
      Wnd_Show(self.UIGROUP, "ImgHole3") -- 显示普通孔图片
      return
    end
    local nCount = Item.tbEquipHoleCount[pEquip.nLevel]
    if not nCount then
      return -- 装备传入错误
    end
    local i = 0
    self:ShowStoneItem(pEquip, 1)
  elseif self.nMode == Item.HOLE_MODE_ENCHASE then
    self:ShowAllObjHole() -- 显示宝石的obj
    if pEquip == nil then
      self:ShowStoneItem(nil)
      Wnd_Show(self.UIGROUP, "ImgHole1") -- 显示普通孔图片
      Wnd_Show(self.UIGROUP, "ImgHole2") -- 显示普通孔图片
      Wnd_Show(self.UIGROUP, "ImgHole3") -- 显示普通孔图片
      return
    end
    self:ShowStoneItem(pEquip) -- 根据装备的属性创建临时对象
    self:ShowSelectHole()
  elseif self.nMode == Item.HOLE_MODE_STONE_UPGRADE then
    if pEquip == nil then
      return
    end
    self:ShowAllObjHole() -- 显示宝石的obj
    self:ShowStoneItem(pEquip) -- 根据装备的属性创建临时对象
  end
end

-- 根据孔的信息显示背景图
function uiEquipHole:ShowHoleBgByHoleInfo(pEquip, nHoleId, dwHoleInfo)
  if dwHoleInfo == 0 then -- 没打孔
    Wnd_Show(self.UIGROUP, "BtnMakeHole" .. nHoleId) -- 显示按钮
    if self.nMode == Item.HOLE_MODE_ENCHASE then -- 剥离界面，显示一个不能操作的按钮
      Wnd_Hide(self.UIGROUP, "BtnMakeHole" .. nHoleId)
      Wnd_Hide(self.UIGROUP, "ObjHole" .. nHoleId) -- 隐藏obj，否则显示不出tip
      Wnd_Show(self.UIGROUP, "ImgDisableBtn" .. nHoleId)
      if nHoleId >= 3 then
        Wnd_SetTip(self.UIGROUP, "ImgDisableBtn" .. nHoleId, "需要到家族领地里面找<color=yellow>夏菲烟<color>打孔")
      else
        Wnd_SetTip(self.UIGROUP, "ImgDisableBtn" .. nHoleId, "需要到新手村找<color=yellow>宝石工匠<color>打孔")
      end
      return
    end
    if not pEquip then
      return
    end
    local tbBaseProp = KItem.GetEquipBaseProp(pEquip.nGenre, pEquip.nDetail, pEquip.nParticular, pEquip.nLevel)
    if Item.tbEquipHoleCount[pEquip.nLevel] < nHoleId then -- 该装备打不了的孔
      Wnd_Hide(self.UIGROUP, "BtnMakeHole" .. nHoleId)
      Wnd_Show(self.UIGROUP, "ImgDisableBtn" .. nHoleId)
      Wnd_SetTip(self.UIGROUP, "ImgDisableBtn" .. nHoleId, "本装备无法打这个孔。")
    else
      if nHoleId == 2 then -- 必须前面的孔都打完了才能打后面的孔
        local dwHole1Info, _ = pEquip.GetHoleStone(1)
        if dwHole1Info == 0 then
          Wnd_Hide(self.UIGROUP, "BtnMakeHole" .. nHoleId)
          Wnd_Show(self.UIGROUP, "ImgDisableBtn" .. nHoleId)
          Wnd_SetTip(self.UIGROUP, "ImgDisableBtn" .. nHoleId, "需要先打第一个孔")
          return
        end
      end
      if nHoleId == 3 then
        local dwHole1Info, _ = pEquip.GetHoleStone(2)
        if dwHole1Info == 0 then
          Wnd_Hide(self.UIGROUP, "BtnMakeHole" .. nHoleId)
          Wnd_Show(self.UIGROUP, "ImgDisableBtn" .. nHoleId)
          Wnd_SetTip(self.UIGROUP, "ImgDisableBtn" .. nHoleId, "需要先打第二个孔")
          return
        end
        if self.nMode == Item.HOLE_MODE_MAKEHOLEEX then -- 第三个孔，并且是高级打孔师
          Wnd_SetEnable(self.UIGROUP, "BtnMakeHole3", 1)
          local nGongXun = self:GetMake3HoleConsumeValue(pEquip)
          Wnd_SetTip(self.UIGROUP, "BtnMakeHole3", "打孔将花费" .. Item:FormatMoney(Item.tbMakeHoleMoney[tbBaseProp.nQualityPrefix][nHoleId]) .. "银两和" .. nGongXun .. "点家族功勋")
        else
          -- 显示一个不能用的按钮
          Wnd_Hide(self.UIGROUP, "BtnMakeHole" .. nHoleId)
          Wnd_Show(self.UIGROUP, "ImgDisableBtn" .. nHoleId)
          Wnd_SetTip(self.UIGROUP, "ImgDisableBtn" .. nHoleId, "需要到家族领地里面找<color=yellow>夏菲烟<color>打孔")
        end
      else
        Wnd_SetEnable(self.UIGROUP, "BtnMakeHole" .. nHoleId, 1)
        Wnd_SetTip(self.UIGROUP, "BtnMakeHole" .. nHoleId, "打孔将花费" .. Item:FormatMoney(Item.tbMakeHoleMoney[tbBaseProp.nQualityPrefix][nHoleId]) .. "银两")
      end
    end
  else
    -- 显示一个已经打孔的背景
    if nHoleId == 1 then -- 第一个是特殊孔
      if KLib.GetByte(dwHoleInfo, 2) == Item.nNormalHole then
        if self.nMode == Item.HOLE_MODE_MAKEHOLE or self.nMode == Item.HOLE_MODE_MAKEHOLEEX then
          if pEquip.nLevel >= Item.nCanMakeSupuerHoleLevel then -- 10级以上装备
            Wnd_Show(self.UIGROUP, BTN_UPGRADHOLE) -- 显示升级特殊孔按钮
            Wnd_SetTip(self.UIGROUP, BTN_UPGRADHOLE, "升级需要消耗一个<color=yellow>金刚钻<color>")
          end
        end
        Wnd_Show(self.UIGROUP, "ImgHole" .. nHoleId) -- 显示普通孔图片
      else
        Wnd_Show(self.UIGROUP, "ImgHoleSpecial") -- 显示特殊孔图片
        Img_PlayAnimation(self.UIGROUP, "ImgSpecialEffect", 1) -- 显示特殊孔特效
      end
    else
      Wnd_Show(self.UIGROUP, "ImgHole" .. nHoleId) -- 显示普通孔图片
    end
  end
end

-- 显示被选中的
function uiEquipHole:ShowSelectHole()
  self:HideMask()
  for i, _ in pairs(self.tbPeelHoleFlag) do
    Wnd_Show(self.UIGROUP, "ImgHoleMask" .. i)
    if i == 1 then
      Wnd_Show(self.UIGROUP, "ImgHoleMaskSpecial") -- 隐藏高亮选择
    end
  end
end

function uiEquipHole:OnButtonClick(szWnd, nParam)
  if szWnd == BTN_MAKEHOLE1 then -- 打第一个孔
    self:AskMakeHole(self.nMode, 1)
  elseif szWnd == BTN_MAKEHOLE2 then -- 打第二个孔
    self:AskMakeHole(self.nMode, 2)
  elseif szWnd == BTN_MAKEHOLE3 then -- 打第三个孔
    self:AskMakeHole(self.nMode, 3)
  elseif szWnd == BTN_UPGRADHOLE then -- 升级为特殊孔
    self:AskMakeHole(self.nMode, 1, 1)
  elseif szWnd == BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == BTN_PEELSTONE then -- 剥离宝石
    local nCount = 0
    for i, _ in pairs(self.tbPeelHoleFlag) do
      nCount = nCount + 1
    end
    if nCount <= 0 then
      me.Msg("请先选择要剥离的宝石。")
      return
    end
    if me.CountFreeBagCell() < nCount then
      me.Msg("背包空间不足，请准备好至少" .. nCount .. "个位置。")
      return
    end
    me.ApplyPeelStone(self.tbPeelHoleFlag[1] or 0, self.tbPeelHoleFlag[2] or 0, self.tbPeelHoleFlag[3] or 0)
    self.tbPeelHoleFlag = {}
  end
end

-- 询问是否打孔
function uiEquipHole:AskMakeHole(nMode, nHoleId, nUpgrad)
  local pEquip = me.GetItem(Item.ROOM_HOLE_EQUIP)
  if pEquip == nil then
    me.Msg("请放入要打孔的装备。")
    return
  end
  local bRet, szMsg, nQuality = Item:CanMakeHole(pEquip, nMode, nHoleId, nUpgrad)
  if bRet == 0 then
    me.Msg(szMsg)
    return
  end
  local tbMsg = {}
  if nUpgrad == 1 then
    tbMsg.szMsg = "本次升级将扣除一个<color=yellow>金刚钻<color>，是否继续？"
  else
    local tbBaseProp = KItem.GetEquipBaseProp(pEquip.nGenre, pEquip.nDetail, pEquip.nParticular, pEquip.nLevel)
    if nHoleId == 3 then -- 第三个孔，需要功勋
      local nGongXun = self:GetMake3HoleConsumeValue(pEquip)
      tbMsg.szMsg = "本次打孔将花费<color=yellow>" .. Item:FormatMoney(Item.tbMakeHoleMoney[tbBaseProp.nQualityPrefix][nHoleId]) .. "<color>银两和<color=yellow>" .. nGongXun .. "<color>点家族功勋，是否继续？"
    else
      tbMsg.szMsg = "本次打孔将花费<color=yellow>" .. Item:FormatMoney(Item.tbMakeHoleMoney[tbBaseProp.nQualityPrefix][nHoleId]) .. "<color>银两，是否继续？"
    end
  end

  tbMsg.nOptCount = 2
  function tbMsg:Callback(nOptIndex, nMode, nHoleId, nUpgrad)
    if nOptIndex == 2 then
      me.ApplyMakeHole(nMode, nHoleId, nUpgrad or 0)
    end
  end

  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nMode, nHoleId, nUpgrad)
end

-- 创建临时对象,bMakeHoleShow:仅用于打孔的时候，玩家无法操作，以后想办法统一
function uiEquipHole:ShowStoneItem(pEquip, bMakeHoleShow)
  self:DeleteTempAllStuff()
  self.tbHoleCont1:ClearObj()
  self.tbHoleCont2:ClearObj()
  self.tbHoleCont3:ClearObj()
  self.tbStone1Cont:ClearObj()
  self.tbStone2Cont:ClearObj()
  self.tbStone3Cont:ClearObj()
  if not pEquip then
    return
  end
  for i = 1, Item.nMaxHoleCount do
    local dwHoleInfo, dwStone = pEquip.GetHoleStone(i)
    self:ShowHoleBgByHoleInfo(pEquip, i, dwHoleInfo)
    if dwStone and dwStone ~= 0 then -- 有宝石
      local tbGDPL = Item.tbStone:ParseStoneInfoInHole(dwStone)
      -- 创建宝石的临时变量
      local pItem = self:CreateTempItem({ bForceBind = 1 }, unpack(tbGDPL))
      if pItem then
        table.insert(self.tbTempItem, pItem) -- 为了释放而记录之
        local tbObj = {}
        tbObj.nType = Ui.OBJ_TEMPITEM
        tbObj.pItem = pItem
        if not bMakeHoleShow or bMakeHoleShow == 0 then
          if i == 1 then
            Wnd_Show(self.UIGROUP, OBJ_HOLE1)
            self.tbHoleCont1:SetObj(tbObj, 0, 0) -- 设置到obj上面
          elseif i == 2 then
            Wnd_Show(self.UIGROUP, OBJ_HOLE2)
            self.tbHoleCont2:SetObj(tbObj, 0, 0) -- 设置到obj上面
          elseif i == 3 then
            Wnd_Show(self.UIGROUP, OBJ_HOLE3)
            self.tbHoleCont3:SetObj(tbObj, 0, 0) -- 设置到obj上面
          end
        else -- 为了显示打孔时候的宝石，好难看的写法
          if i == 1 then
            Wnd_Show(self.UIGROUP, OBJ_STONE1)
            self.tbStone1Cont:SetObj(tbObj, 0, 0) -- 设置到obj上面
          elseif i == 2 then
            Wnd_Show(self.UIGROUP, OBJ_STONE2)
            self.tbStone2Cont:SetObj(tbObj, 0, 0) -- 设置到obj上面
          elseif i == 3 then
            Wnd_Show(self.UIGROUP, OBJ_STONE3)
            self.tbStone3Cont:SetObj(tbObj, 0, 0) -- 设置到obj上面
          end
        end
      end
    elseif dwHoleInfo ~= 0 then
      if bMakeHoleShow == 1 then -- 显示obj，用于提示玩家
        Wnd_Show(self.UIGROUP, "ObjStone" .. i)
      else
        -- 没宝石，放tip
        local nHoleLevel = KLib.GetByte(dwHoleInfo, 1)
        if KLib.GetByte(dwHoleInfo, 2) == Item.nNormalHole then
          Wnd_SetTip(self.UIGROUP, "ObjHole" .. i, string.format("可镶嵌%s级及%s级以下的普通宝石", nHoleLevel, nHoleLevel))
        else
          Wnd_SetTip(self.UIGROUP, "ObjHole" .. i, string.format("可镶嵌%s级及%s级以下的普通和特殊宝石", nHoleLevel, nHoleLevel))
        end
      end
    end
  end
end

function uiEquipHole:DeleteTempAllStuff()
  for _, pTemp in pairs(self.tbTempItem) do
    tbTempItem:Destroy(pTemp)
  end
  self.tbTempItem = {}
end

function uiEquipHole:CreateTempItem(tbItemInfo, ...)
  local pItem = tbTempItem:CreateEx(tbItemInfo, unpack(arg))
  if not pItem then
    return
  end
  return pItem
end

function uiEquipHole:GetCurEquipHoleLevel()
  local pEquip = me.GetItem(Item.ROOM_HOLE_EQUIP, 0, 0)
  if not pEquip then
    return 0
  end
  local tbBaseProp = KItem.GetEquipBaseProp(pEquip.nGenre, pEquip.nDetail, pEquip.nParticular, pEquip.nLevel)
  if not tbBaseProp or pEquip.nLevel < Item.nEquipHoleMinLevel or tbBaseProp.nQualityPrefix < Item.nEquipHoleMinQuality then
    return 0
  end

  local nHoleLevel = Item.tbEquipHoleLevel[tbBaseProp.nQualityPrefix or 100] or 1 -- 得到应该打孔的等级
  return nHoleLevel
end

-- 获取第三个孔的消耗
function uiEquipHole:GetMake3HoleConsumeValue(pEquip)
  if pEquip.IsEquip == 0 then
    return 0
  end
  return Item.EQUIPPOS_MAKEHOLE_KIN_SKILLLEVEL[pEquip.nEquipPos][2]
end
