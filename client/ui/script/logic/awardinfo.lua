-----------------------------------------------------
--文件名		：	awardinfo.lua
--创建者		：	zhengyuhua
--创建时间		：	2008-01-08
--功能描述		：
------------------------------------------------------

Ui.tbLogic.tbAwardInfo = {}
local tbAwardInfo = Ui.tbLogic.tbAwardInfo
local tbTempItem = Ui.tbLogic.tbTempItem

-- 任务奖励图标索引
tbAwardInfo.AWARD_ICON_INDEX = {
  exp = 1,
  money = 2,
  bindmoney = 2,
  activemoney = 2,
  gatherpoint = 4,
  linktask_repute = 4,
  linktask_cancel = 11,
  makepoint = 4,
  repute = 4,
  title = 3,
  taskvalue = 2,
  script = 4,
  arrary = 4,
  KinReputeEntry = 1,
}

-- 道具类型，会创建临时道具
function tbAwardInfo:GetItemObj(tbAward)
  local tbItem = tbAward.varValue
  if not tbItem then
    return
  end
  local nLevel = tbItem[4] or 0
  local nSeries = tbItem[5] or -1
  if nLevel == 0 then
    nLevel = 1
  end
  local pItem = tbTempItem:Create(tbItem[1], tbItem[2], tbItem[3], nLevel, nSeries) -- 创造临时道具
  if not pItem then
    return
  end
  local tbObj = {}
  tbObj.nType = Ui.OBJ_TEMPITEM
  tbObj.pItem = pItem
  tbObj.nCount = tonumber(tbAward.szAddParam1) or 1 -- 物品个数

  if pItem.szClass == "xuanjing" or pItem.IsEquip() == 1 or Task:IsNeedBind(tbItem) == 1 then
    tbObj.szBindType = "获取绑定"
  end
  if tbItem[11] == 1 then -- 绑定的
    tbObj.szBindType = "获取绑定"
  end
  return tbObj
end

function tbAwardInfo:GetAwardInfoObj(tbAwards, nTaskId, nReferId)
  local tbObj = {}
  tbObj.nType = Ui.OBJ_TASKICON
  if tbAwards.szType == "customizeitem" or tbAwards.szType == "item" then
    return self:GetItemObj(tbAwards)
  elseif tbAwards.szType == "repute" or tbAwards.szType == "title" or tbAwards.szType == "taskvalue" or tbAwards.szType == "script" or tbAwards.szType == "arrary" or tbAwards.szType == "KinReputeEntry" or tbAwards.szType == "bindcoin" then
    if tonumber(tbAwards.nSprIdx) and tonumber(tbAwards.nSprIdx) > 0 then
      tbObj.nIndex = tonumber(tbAwards.nSprIdx)
    end
  elseif tbAwards.szType == "factionequip" and nTaskId and nReferId and nTaskId > 0 and nReferId > 0 and tbAwards.varValue and tbAwards.varValue[1] then
    local nIndex = tbAwards.varValue[1]
    return self:GetSpcOptInfoObj(nTaskId, nReferId, nIndex)
  elseif tbAwards.szType == "customequip" and nTaskId and nReferId and nTaskId > 0 and nReferId > 0 and tbAwards.varValue and tbAwards.varValue[1] then
    local nIndex = tbAwards.varValue[1]
    return self:GetCustomInfoObj(nTaskId, nReferId, nIndex)
  else
    tbObj.nIndex = self.AWARD_ICON_INDEX[tbAwards.szType]
  end

  tbObj.szTip = KTask.GetAwardTip(tbAwards)

  return tbObj
end

function tbAwardInfo:DelAwardInfoObj(tbObj)
  if tbObj and tbObj.nType == Ui.OBJ_TEMPITEM then
    tbTempItem:Destroy(tbObj.pItem) -- 释放临时道具
  end
end

function tbAwardInfo:GetSpcOptInfoObj(nTaskId, nReferId, nIndex)
  if not nTaskId or not nReferId or not nIndex then
    return
  end

  local tbSpeOptInfo = Task:GetSpeOptInfo(nTaskId, nReferId, nIndex)
  if not tbSpeOptInfo then
    return
  end

  local tbGDPL = tbSpeOptInfo.tbGDPL
  if not tbSpeOptInfo.tbGDPL then
    return
  end

  local pItem = tbTempItem:Create(tbGDPL[1], tbGDPL[2], tbGDPL[3], tbGDPL[4], me.nSeries) -- 创造临时道具
  if not pItem then
    return
  end
  local tbObj = {}
  tbObj.nType = Ui.OBJ_TEMPITEM
  tbObj.pItem = pItem
  tbObj.nCount = 1 -- 物品个数

  if pItem.szClass == "xuanjing" or pItem.IsEquip() == 1 or Task:IsNeedBind(tbGDPL) == 1 then
    tbObj.szBindType = "获取绑定"
  end
  return tbObj
end

function tbAwardInfo:GetCustomInfoObj(nTaskId, nReferId, nIndex)
  if not nTaskId or not nReferId or not nIndex then
    return
  end
  local nFaction = math.max(me.nFaction, 1)
  local nRoute = math.max(me.nRouteId, 1)
  local nSex = me.nSex
  if not Task.tbCustomEquip[nIndex] or not Task.tbCustomEquip[nIndex][nFaction] or not Task.tbCustomEquip[nIndex][nFaction][nRoute] or not Task.tbCustomEquip[nIndex][nFaction][nRoute][nSex] then
    return
  end

  local tbGDPL = Task.tbCustomEquip[nIndex][nFaction][nRoute][nSex]

  local pItem = tbTempItem:Create(tbGDPL[1], tbGDPL[2], tbGDPL[3], tbGDPL[4], me.nSeries) -- 创造临时道具
  if not pItem then
    return
  end
  local tbObj = {}
  tbObj.nType = Ui.OBJ_TEMPITEM
  tbObj.pItem = pItem
  tbObj.nCount = 1 -- 物品个数

  if pItem.szClass == "xuanjing" or pItem.IsEquip() == 1 or Task:IsNeedBind(tbGDPL) == 1 then
    tbObj.szBindType = "获取绑定"
  end
  return tbObj
end
