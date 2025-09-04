Require("\\ui\\script\\logic\\objcont\\base.lua")

local tbObject = Ui.tbLogic.tbObject
local tbMouse = Ui.tbLogic.tbMouse
local tbStoneRoom = tbObject:NewContainerClass("stoneroom", "base")

------------------------------------------------------------------------------------------

function tbStoneRoom:init()
  self.bUse = 0 -- 不可使用
  self.bSwitch = 1 -- 允许交换
  self.bShowCd = 0 -- 不显示CD时间
  self.bLink = 0 -- 不允许链接
end

------------------------------------------------------------------------------------------
-- 覆盖方法
function tbStoneRoom:CheckSwitchItem(pDropItem, pPickItem, nX, nY)
  return 1
end

-- 鼠标放下道具的事件
function tbStoneRoom:OnDrop(tbMouseObj, nX, nY)
  return 1
end

-- 鼠标点击格子事件（鼠标上没有OBJ，格子中有OBJ时，点击格子才会触发这个事件）
function tbStoneRoom:OnPick(tbObj, nX, nY)
  return 1
end

-- 两边都有东西
function tbStoneRoom:SwitchMouse(tbMouseObj, tbObj, nX, nY)
  if tbObj.nType ~= Ui.OBJ_TEMPITEM then -- 目标上面的必须是临时道具
    return 0
  end
  if tbMouseObj.nType ~= Ui.OBJ_OWNITEM then -- 鼠标上不是自己的道具,不让放
    return 0
  end
  local pStoneItem = me.GetItem(tbMouseObj.nRoom, tbMouseObj.nX, tbMouseObj.nY)
  if not pStoneItem then
    return 0
  end

  if self:CheckSwitchItem(pStoneItem, tbObj.pItem, nX, nY) == 0 then
    return 0
  end

  tbMouse:SetObj(nil) -- 鼠标要在前设置，以免被过滤
  --self:SetObj(nil, nX, nY);

  self:OnDrop(tbMouseObj, nX, nY)
  return 1
end

-- 鼠标有,目标没有
function tbStoneRoom:DropMouse(tbMouseObj, nX, nY)
  if tbMouseObj.nType ~= Ui.OBJ_OWNITEM then -- 鼠标上不是自己的道具,不让放
    return 0
  end
  local pStoneItem = me.GetItem(tbMouseObj.nRoom, tbMouseObj.nX, tbMouseObj.nY)
  if not pStoneItem then
    return 0
  end
  if self:CheckSwitchItem(pStoneItem, nil, nX, nY) == 0 then
    return 0
  end
  tbMouse:SetObj(nil) -- 先清掉鼠标下面的才能设置成功
  --self:SetObj(nil, nX, nY);	-- 等待服务器更新

  self:OnDrop(tbMouseObj, nX, nY)
  return 1
end

-- 目标有,鼠标没有
function tbStoneRoom:PickMouse(tbObj, nX, nY)
  if tbObj.nType ~= Ui.OBJ_TEMPITEM then
    return 0
  end

  if self:CheckSwitchItem(nil, tbObj.pItem, nX, nY) ~= 1 then
    return 0
  end

  if self:OnPick(tbObj, nX, nY) ~= 1 then
    return 0
  end

  return 1
end

------------------------------------------------------------------------------------------
