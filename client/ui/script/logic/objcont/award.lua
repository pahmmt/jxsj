Require("\\ui\\script\\logic\\objcont\\base.lua")

local tbObject = Ui.tbLogic.tbObject
local tbMouse = Ui.tbLogic.tbMouse
local tbAward = tbObject:NewContainerClass("award", "base")

------------------------------------------------------------------------------------------

function tbAward:init()
  self.bUse = 0 -- 不可使用
  self.bSwitch = 0 -- 不可交换
  self.bShowCd = 0 -- 不显示CD时间
  self.bLink = 0 -- 不允许链接
end

------------------------------------------------------------------------------------------
-- 覆盖方法

function tbAward:UpdateItem(tbItem, nX, nY)
  local pItem = tbItem.pItem
  if tbItem.nType == Ui.OBJ_TEMPITEM and tbItem.nCount then
    ObjGrid_ChangeSubScript(self.szUiGroup, self.szObjGrid, tostring(tbItem.nCount), nX, nY)
  end
  local nColor = (me.CanUseItem(pItem) ~= 1) and 0x60ff0000 or 0
  ObjGrid_ChangeBgColor(self.szUiGroup, self.szObjGrid, nColor, nX, nY)
  ObjGrid_SetTransparency(self.szUiGroup, self.szObjGrid, pItem.szTransparencyIcon, nX, nY)
end

function tbAward:FormatItem(tbItem)
  local tbObj = {}
  local pItem = tbItem.pItem
  if not pItem then
    return
  end
  tbObj.szBgImage = pItem.szIconImage
  if tbItem.nType == Ui.OBJ_TEMPITEM and tbItem.nCount > 1 then
    tbObj.bShowSubScript = 1 -- 显示下标数字
  end
  return tbObj
end

function tbAward:CanSetObj(tbObj, nX, nY)
  if tbObj and tbObj.nType ~= Ui.OBJ_TASKICON and tbObj.nType ~= Ui.OBJ_TEMPITEM then
    return 0
  end
  return 1
end

function tbAward:EnterItem(tbObj, nX, nY)
  if tbObj.nType ~= Ui.OBJ_TEMPITEM or not tbObj.pItem then
    return 0
  end
  Wnd_ShowMouseHoverInfo(self.szUiGroup, self.szObjGrid, tbObj.pItem.GetCompareTip(Item.TIPS_PREVIEW, tbObj.szBindType))
end

------------------------------------------------------------------------------------------
