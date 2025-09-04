Require("\\ui\\script\\logic\\messagelist.lua")

local tbMsgList = Ui.tbLogic.tbMessageList

local tbEquipElem = {}

function tbEquipElem:Init(tbInfo, szName)
  self.pItem = self:CreateLink(tbInfo[1])
  -- if (not self.pItem) then
  -- 	return;
  -- end

  local szItemNameColor = "blue"
  if self.pItem then
    self.szText = "<" .. self.pItem.szName .. ">"
    Setting:SetGlobalObj(nil, nil, self.pItem)
    local _, _, szColor = Item:CalcValueInfo(self.pItem.szClass)
    szItemNameColor = szColor
    Setting:RestoreGlobalObj()
  else
    self.szText = "<未知道具>"
  end

  local nId = MessageList_PushBtn(self.tbManager.UIGROUP, self.tbManager.szMessageListName or szName, 0, self.szText, szItemNameColor, "black", 0)
  return nId
end

function tbEquipElem:GetShowMsg(tbInfo)
  local pItem = self:CreateLink(tbInfo)
  local szTempText = ""
  if pItem then
    local szTempText = "<" .. pItem.szName .. ">"
    Ui.tbLogic.tbTempItem:Destroy(pItem)
  else
    local szTempText = "<未知道具>"
  end

  return szTempText
end

function tbEquipElem:CreateLink(tbParams)
  local tbExtraParams = tbParams
  for i, szParam in pairs(tbExtraParams) do
    tbExtraParams[i] = tonumber(szParam)
  end
  local tbGenInfo = {
    tbExtraParams[15],
    tbExtraParams[16],
    tbExtraParams[17],
    tbExtraParams[18],
    tbExtraParams[19],
    tbExtraParams[20],
    tbExtraParams[21],
    tbExtraParams[22],
    tbExtraParams[23],
    tbExtraParams[24],
    tbExtraParams[25],
    tbExtraParams[26],
  }
  local tbRandomMa = { tbExtraParams[27], tbExtraParams[28], tbExtraParams[29], tbExtraParams[30], tbExtraParams[31], tbExtraParams[32], tbExtraParams[14] } -- 最后一位是绑定与否
  local tbTaskData = self:PackageTaskData(tbExtraParams) -- 任务数据
  local pItem = Ui.tbLogic.tbTempItem:Create(tbExtraParams[2], tbExtraParams[3], tbExtraParams[4], tbExtraParams[5], tbExtraParams[6], tbExtraParams[7], tbExtraParams[8], tbGenInfo, tbExtraParams[9], tbExtraParams[10], -1, 0, tbExtraParams[11], tbExtraParams[12], tbExtraParams[13], tbRandomMa, tbTaskData)
  return pItem
end

function tbEquipElem:Clear()
  if self.pItem then
    Ui.tbLogic.tbTempItem:Destroy(self.pItem)
  end
end

function tbEquipElem:LeftClick()
  local pItem = self.pItem
  if not pItem then
    pItem = KItem.CreateTempItem(Item.nGenre, Item.nDetail, Item.nParticular, Item.nLevel, Item.nSeries)
  end
  local szTitle, szTip, szView, szCmpTitle, szCmpTip, szCmpView = pItem.GetCompareTip()
  -- zjq comm 如果要显示聊天栏链接，这里处理数据
  ShowEquipLink(szTitle, szTip, szView, szCmpTitle, szCmpTip, szCmpView)
end

function tbEquipElem:ShiftLeftClick()
  local pItem = self.pItem
  if not pItem then
    pItem = KItem.CreateTempItem(Item.nGenre, Item.nDetail, Item.nParticular, Item.nLevel, Item.nSeries)
  end
  UiCallback:LinkPreView(pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel, pItem.nSeries)
end

-- 组装道具任务数据
function tbEquipElem:PackageTaskData(tbParams)
  local tbTaskData = {}

  local nMainIndex = Item.TASKDATA_MAIN_STONE
  local nSubIndex = 1
  for i = 33, 41 do
    if not Item.tbTaskDataLen[nMainIndex] or Item.tbTaskDataLen[nMainIndex] < nSubIndex then
      break
    end

    tbTaskData = Item:SetItemTaskValue(tbTaskData, nMainIndex, nSubIndex, tbParams[i])
    nSubIndex = nSubIndex + 1

    if Item.tbTaskDataLen[nMainIndex] < nSubIndex then
      nMainIndex = nMainIndex + 1
      nSubIndex = 1
    end
  end

  return tbTaskData
end

tbMsgList:RegisterBaseClass("item", tbEquipElem)
