-----------------------------------------------------
--文件名		：	shortcutbar.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-04-19
--功能描述		：	快捷栏界面
------------------------------------------------------

local uiShortcutBar = Ui:GetClass("shortcutbar")
local tbTempItem = Ui.tbLogic.tbTempItem
local tbObject = Ui.tbLogic.tbObject
local tbMouse = Ui.tbLogic.tbMouse
local OBJ_SHORTCUT = "ObjShortcut"

local tbCont = { bLink = 0 } -- 不允许链接操作

function tbCont:FormatItem(tbItem)
  local tbObj = {}
  local pItem = tbItem.pItem
  if not pItem then
    return
  end
  tbObj.szBgImage = pItem.szIconImage
  tbObj.szCdSpin = self.CDSPIN_MEDIUM
  tbObj.szCdFlash = self.CDFLASH_MEDIUM
  tbObj.bShowSubScript = 1 -- 总显示下标数字
  return tbObj
end

function tbCont:UpdateItem(tbItem, nX, nY)
  local pItem = tbItem.pItem
  local nCount = me.GetSameItemCountInBags(pItem)
  ObjGrid_ChangeSubScript(self.szUiGroup, self.szObjGrid, tostring(nCount), nX, nY or 0)
  local nColor = (me.CanUseItem(pItem) ~= 1) and 0x60ff0000 or 0
  ObjGrid_ChangeBgColor(self.szUiGroup, self.szObjGrid, nColor, nX, nY or 0)
  self:UpdateItemCd(pItem.nCdType)
end

function tbCont:UseItem(tbItem, nX, nY)
  local pItem = nil
  local tbResult = me.FindSameItemInBags(tbItem.pItem)
  if tbResult and #tbResult > 0 then
    pItem = tbResult[1].pItem -- 在身上找一个和快捷栏物品一致的道具
  end
  if not pItem then
    return
  end
  UiManager:UseItem(pItem) -- 使用之
  KTask:SendUseShortCut()
end

function tbCont:SwitchMouse(tbMouseObj, tbObj, nX, nY)
  --if self:CheckShortcutObj(tbMouseObj) ~= 1 then
  --	me.Msg("该物不能放入快捷栏！");
  --	return 0;
  --end
  self:PickMouse(tbObj, nX, nY)
  if tbObj.nType == Ui.OBJ_TEMPITEM then
    self:DestroyTempItem(tbObj)
  end
  self:DropMouse(tbMouseObj, nX, nY)
  return 1
end

function tbCont:DropMouse(tbMouseObj, nX, nY)
  --if self:CheckShortcutObj(tbMouseObj) ~= 1 then
  --	me.Msg("该物不能放入快捷栏！");
  --	return 0;
  --end

  --玩家在载具上快捷键栏锁死
  if me.IsInCarrier() == 1 then
    return 0
  end
  if tbMouseObj.nType == Ui.OBJ_OWNITEM then
    local pItem = me.GetItem(tbMouseObj.nRoom, tbMouseObj.nX, tbMouseObj.nY)
    if not pItem then
      Ui:Output("[ERR] Object机制内部错误！!")
      return 0
    end
    local tbObj = self:CreateTempItem(pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel, pItem.nSeries) -- 创建临时道具对象
    self:SetObj(tbObj, nX, nY)
    tbMouse:ResetObj() -- 弹回原道具
  elseif (tbMouseObj.nType == Ui.OBJ_TEMPITEM) or (tbMouseObj.nType == Ui.OBJ_FIGHTSKILL) then
    tbMouse:SetObj(nil) -- 必须先清掉鼠标
    self:SetObj(tbMouseObj, nX, nY)
  else
    return 0
  end
  self:SaveObjTask(nX)
  return 1
end

function tbCont:PickMouse(tbObj, nX, nY)
  --玩家在载具上快捷键栏锁死
  if me.IsInCarrier() == 1 then
    return 0
  end
  self:SetObj(nil, nX, nY) -- 先清掉
  self:SaveObjTask(nX)
  return 1
end

function tbCont:UpdateAll(nRoom, nX, nY) -- 刷新所有格子
  for nPos = 0, Item.SHORTCUTBAR_OBJ_MAX_SIZE - 1 do
    self:Update(nPos)
  end
end

function tbCont:UpdateAllSkillObj()
  for nPos = 0, Item.SHORTCUTBAR_OBJ_MAX_SIZE - 1 do
    local tbObj = self:GetObj(nPos)
    if tbObj and tbObj.nType == Ui.OBJ_FIGHTSKILL then
      self:Update(nPos)
    end
  end
end

function tbCont:CheckShortcutObj(tbObj)
  if tbObj.nType == Ui.OBJ_OWNITEM then
    local pItem = me.GetItem(tbObj.nRoom, tbObj.nX, tbObj.nY)
    if pItem and (pItem.CanBeShortcut() == 1) then
      return 1
    end
  elseif tbObj.nType == Ui.OBJ_TEMPITEM then
    if tbObj.pItem.CanBeShortcut() == 1 then
      return 1
    end
  elseif tbObj.nType == Ui.OBJ_FIGHTSKILL then
    return 1
  end
  return 0
end

function tbCont:SaveObjTask(nPosition)
  local tbObj = self:GetObj(nPosition)
  local nFlags = me.GetTask(Item.TSKGID_SHORTCUTBAR, Item.TSKID_SHORTCUTBAR_FLAG)
  if tbObj and (tbObj.nType == Ui.OBJ_TEMPITEM) then -- Obj是道具，按wwwbb的格式存储Genre, Detail, Particular, Level, Series
    nFlags = Lib:SetBits(nFlags, Item.SHORTCUTBAR_TYPE_ITEM, nPosition * 3, nPosition * 3 + 2)
    local pItem = tbObj.pItem
    local nLow = Lib:SetBits(pItem.nGenre, pItem.nDetail, 16, 31)
    local nHigh = Lib:SetBits(pItem.nParticular, pItem.nLevel, 16, 23)
    nHigh = Lib:SetBits(nHigh, pItem.nSeries, 24, 31)
    me.SetTask(Item.TSKGID_SHORTCUTBAR, Item.TSKID_SHORTCUTBAR_FLAG, nFlags)
    me.SetTask(Item.TSKGID_SHORTCUTBAR, nPosition * 2 + 1, nLow)
    me.SetTask(Item.TSKGID_SHORTCUTBAR, (nPosition + 1) * 2, nHigh)
  elseif tbObj and (tbObj.nType == Ui.OBJ_FIGHTSKILL) then -- Obj是技能，低d存Id，高d不用，置0
    nFlags = Lib:SetBits(nFlags, Item.SHORTCUTBAR_TYPE_SKILL, nPosition * 3, nPosition * 3 + 2)
    me.SetTask(Item.TSKGID_SHORTCUTBAR, Item.TSKID_SHORTCUTBAR_FLAG, nFlags)
    me.SetTask(Item.TSKGID_SHORTCUTBAR, nPosition * 2 + 1, tbObj.nSkillId)
    me.SetTask(Item.TSKGID_SHORTCUTBAR, (nPosition + 1) * 2, 0)
  else -- Obj不存在，清除相应的任务变量
    nFlags = Lib:SetBits(nFlags, Item.SHORTCUTBAR_TYPE_NONE, nPosition * 3, nPosition * 3 + 2)
    me.SetTask(Item.TSKGID_SHORTCUTBAR, Item.TSKID_SHORTCUTBAR_FLAG, nFlags)
    me.SetTask(Item.TSKGID_SHORTCUTBAR, nPosition * 2 + 1, 0)
    me.SetTask(Item.TSKGID_SHORTCUTBAR, (nPosition + 1) * 2, 0)
  end
end

function tbCont:CreateTempItem(nGenre, nDetail, nParticular, nLevel, nSeries)
  local pItem = tbTempItem:Create(nGenre, nDetail, nParticular, nLevel, nSeries) -- 创建临时道具对象
  if not pItem then
    return
  end
  local tbObj = {}
  tbObj.nType = Ui.OBJ_TEMPITEM
  tbObj.pItem = pItem
  return tbObj
end

function tbCont:DestroyTempItem(tbObj)
  if tbObj.nType ~= Ui.OBJ_TEMPITEM then
    return tbObj
  end
  tbTempItem:Destroy(tbObj.pItem) -- 销毁临时道具
  return nil
end

function uiShortcutBar:OnCreate()
  self.tbCont = tbObject:RegisterContainer(self.UIGROUP, OBJ_SHORTCUT, Item.SHORTCUTBAR_OBJ_MAX_SIZE, 1, tbCont)
end

function uiShortcutBar:OnDestroy()
  tbObject:UnregContainer(self.tbCont)
end

function uiShortcutBar:SetSkillUsePoint(nSkillId, nUsePoint)
  if self.tbSkillUsePoint == nil then
    return
  end
  if self.tbSkillUsePoint[nSkillId] == nUsePoint then
    return 0
  elseif type(self.tbSkillUsePoint[nSkillId]) == "number" and self.tbSkillUsePoint[nSkillId] > nUsePoint then -- 次数减少
    self.tbSkillUsePoint[nSkillId] = nUsePoint
    return -1
  elseif type(self.tbSkillUsePoint[nSkillId]) == "number" and self.tbSkillUsePoint[nSkillId] < nUsePoint then -- 次数增加
    self.tbSkillUsePoint[nSkillId] = nUsePoint
    return 1
  else
    self.tbSkillUsePoint[nSkillId] = nUsePoint
    return 1
  end
end

function uiShortcutBar:OnOpen()
  self:ReloadInfo()
  self.tbSkillUsePoint = {}
  if self.nSkillStateTimer then
    Timer:Close(self.nSkillStateTimer)
  end
  self.nSkillStateTimer = Timer:Register(3, self.UpdateAllSkillObj, self)
end

function uiShortcutBar:ReloadInfo()
  local nFlags = nil
  -- 玩家在载具上，读另外一套变量
  if me.IsInCarrier() == 1 then
    nFlags = me.GetTask(Item.TSKGID_SHORTCUTBAR_CARRIER, Item.TSKID_SHORTCUTBAR_FLAG_CARRIER)
  else
    nFlags = me.GetTask(Item.TSKGID_SHORTCUTBAR, Item.TSKID_SHORTCUTBAR_FLAG)
  end

  for nPos = 0, Item.SHORTCUTBAR_OBJ_MAX_SIZE - 1 do
    local nType = Lib:LoadBits(nFlags, nPos * 3, nPos * 3 + 2) -- 每个类型占3位
    local tbObj = nil
    if nType == Item.SHORTCUTBAR_TYPE_ITEM then
      tbObj = self:LoadItemTask(nPos)
    elseif nType == Item.SHORTCUTBAR_TYPE_SKILL then
      tbObj = self:LoadSkillTask(nPos)
    end
    self.tbCont:SetObj(tbObj, nPos)
  end
end

function uiShortcutBar:OnClose()
  for nPos = 0, Item.SHORTCUTBAR_OBJ_MAX_SIZE - 1 do
    local tbObj = self.tbCont:GetObj(nPos)
    if tbObj and (tbObj.nType == Ui.OBJ_TEMPITEM) then
      self.tbCont:SetObj(nil, nPos)
      self.tbCont:DestroyTempItem(tbObj)
    end
  end
  self.tbCont:ClearObj()
  if self.nSkillStateTimer then
    Timer:Close(self.nSkillStateTimer)
    self.nSkillStateTimer = nil
  end
end

function uiShortcutBar:OnUseShortcutObj(nPosition)
  self.tbCont:Use(nPosition)
end

function uiShortcutBar:LoadItemTask(nPosition)
  if (nPosition < 0) or (nPosition >= Item.SHORTCUTBAR_OBJ_MAX_SIZE) then
    return
  end
  local nLow = me.GetTask(Item.TSKGID_SHORTCUTBAR, nPosition * 2 + 1)
  local nHigh = me.GetTask(Item.TSKGID_SHORTCUTBAR, (nPosition + 1) * 2)
  local nGenre = Lib:LoadBits(nLow, 0, 15)
  local nDetail = Lib:LoadBits(nLow, 16, 31)
  local nParticular = Lib:LoadBits(nHigh, 0, 15)
  local nLevel = Lib:LoadBits(nHigh, 16, 23)
  local nSeries = Lib:LoadBits(nHigh, 24, 31)
  return tbCont:CreateTempItem(nGenre, nDetail, nParticular, nLevel, nSeries)
end

function uiShortcutBar:LoadSkillTask(nPosition)
  if (nPosition < 0) or (nPosition >= Item.SHORTCUTBAR_OBJ_MAX_SIZE) then
    return
  end
  local tbSkill = {}
  tbSkill.nType = Ui.OBJ_FIGHTSKILL
  -- 玩家在载具上时
  if me.IsInCarrier() ~= 1 then
    tbSkill.nSkillId = me.GetTask(Item.TSKGID_SHORTCUTBAR, nPosition * 2 + 1)
  else
    tbSkill.nSkillId = me.GetTask(Item.TSKGID_SHORTCUTBAR_CARRIER, nPosition * 2 + 1)
  end
  return tbSkill
end

function uiShortcutBar:OnSyncItem(nRoom, nX, nY)
  self.tbCont:UpdateAll(nRoom, nX, nY)
end

function uiShortcutBar:UpdateAllSkillObj()
  self.tbCont:UpdateAllSkillObj()
end

function uiShortcutBar:OnChangeFactionFinished()
  self:ReloadInfo()
end

-- 快捷键通知
-- 快捷键按下
function uiShortcutBar:OnAliasDown(szAlias, nKey)
  ObjGrid_AddHighLightGrid(self.UIGROUP, OBJ_SHORTCUT, nKey, 0, 1)
end
-- 快捷键释放
function uiShortcutBar:OnAliasUp(szAlias, nKey)
  ObjGrid_RemoveHighLightGrid(self.UIGROUP, OBJ_SHORTCUT, nKey, 0, 1)
end
-- 快捷键事件
function uiShortcutBar:OnShortcutAlias(szAlias, nKey)
  self:OnUseShortcutObj(nKey)
end

function uiShortcutBar:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_CHANGEACTIVEAURA, self.OnSyncItem }, -- 同步技能
    { UiNotify.emCOREEVENT_SYNC_ITEM, self.OnSyncItem }, -- 角色道具同步事件
    { UiNotify.emCOREEVENT_CHANGE_FACTION_FINISHED, self.OnChangeFactionFinished }, -- 切换门派成功
  }
  return Lib:MergeTable(tbRegEvent, self.tbCont:RegisterEvent())
end

function uiShortcutBar:RegisterMessage()
  return self.tbCont:RegisterMessage()
end
