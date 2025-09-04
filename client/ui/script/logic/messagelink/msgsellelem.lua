Require("\\ui\\script\\logic\\messagelist.lua")

local tbMsgList = Ui.tbLogic.tbMessageList

local tbSellElem = {}

function tbSellElem:Init(tbInfo)
  self.pItem = self:CreateLink(tbInfo[1])
  if not self.pItem then
    return
  end

  self.szText = "<" .. self.pItem.szName .. ">"
  self.szKey = tbInfo[1][43]
  self.szSellerName = tbInfo[1][44]
  self.nOnePrice = tonumber(tbInfo[1][45])
  -- 如果没有货币类型的话，表示错误
  if not tbInfo[1][46] then
    print("没有货币类型")
    return
  end
  self.nCurrency = tonumber(tbInfo[1][46])
  if not (self.nCurrency == 1 or self.nCurrency == 2) then
    self.nCurrency = nil
    print("货币类型错误")
    return
  end
  self.IsSystem = tbInfo[5]
  Setting:SetGlobalObj(nil, nil, self.pItem)
  local _1, _2, szItemNameColor = Item:CalcValueInfo(self.pItem.szClass)
  Setting:RestoreGlobalObj()

  local nId = MessageList_PushBtn(self.tbManager.UIGROUP, self.tbManager.szMessageListName, 0, self.szText, szItemNameColor, "black", 0)
  return nId
end

function tbSellElem:CreateLink(tbParams)
  local tbExtraParams = tbParams
  for i, szParam in pairs(tbExtraParams) do
    if i < 42 then
      tbExtraParams[i] = tonumber(szParam)
    end
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
  local tbRandomMa = { tbExtraParams[27], tbExtraParams[28], tbExtraParams[29], tbExtraParams[30], tbExtraParams[31], tbExtraParams[32], tbExtraParams[14] }
  --local tbHoleInfo = { tbExtraParams[33], tbExtraParams[34], tbExtraParams[35], tbExtraParams[36], tbExtraParams[37], tbExtraParams[38],};
  local tbTaskData = self:PackageTaskData(tbExtraParams)

  local pItem = Ui.tbLogic.tbTempItem:Create(tbExtraParams[2], tbExtraParams[3], tbExtraParams[4], tbExtraParams[5], tbExtraParams[6], tbExtraParams[7], tbExtraParams[8], tbGenInfo, tbExtraParams[9], tbExtraParams[10], -1, 0, tbExtraParams[11], tbExtraParams[12], tbExtraParams[13], tbRandomMa, tbTaskData)
  return pItem
end

function tbSellElem:Clear()
  if self.pItem then
    Ui.tbLogic.tbTempItem:Destroy(self.pItem)
  end
end

function tbSellElem:GetShowMsg(tbInfo)
  local pItem = self:CreateLink(tbInfo)
  local szTempText = "<" .. pItem.szName .. ">"
  Ui.tbLogic.tbTempItem:Destroy(pItem)

  return szTempText
end

function tbSellElem:LeftClick()
  local nPrice = self.nOnePrice
  local szKey = self.szKey
  -- 2010/10/28 17:23:10 xuantao
  local nCurrency = self.nCurrency
  if (not nPrice) or not szKey or not nCurrency or self.IsSystem == 0 then
    return
  end

  local tbObj = nil
  if self.pItem then
    tbObj = {}
    tbObj.nType = Ui.OBJ_ITEM
    tbObj.pItem = self.pItem
  end
  local tbApplyMsg = {}
  tbApplyMsg.tgObj = tbObj
  tbApplyMsg.szObjName = self.pItem.szName
  if nCurrency == 1 then
    tbApplyMsg.szMsg = "您确认以一口价：<color=255,167,0>" .. Item:FormatMoney(nPrice) .. "<color>(两)来购买这件物品？"
  else
    tbApplyMsg.szMsg = "您确认以一口价：<color=yellow>" .. Item:FormatMoney(nPrice) .. "(金)<color>来购买这件物品？"
    tbApplyMsg.szWarmingTxt = "<color=yellow>注意：将扣除您的金币<color>"
  end
  tbApplyMsg.szTitle = "竞拍物品"
  tbApplyMsg.nOptCount = 2
  tbApplyMsg.bObjEdt = 0
  tbApplyMsg.bClose = 0
  function tbApplyMsg:Callback(nOptIndex, msgWnd, Wnd)
    local bOk = 0
    if nOptIndex == 2 then
      if 1 == Wnd.nCurrency and me.nCashMoney < Wnd.nOnePrice then
        UiManager:OpenWindow(Ui.UI_INFOBOARD, "你没有足够的银两！")
      elseif 2 == Wnd.nCurrency and me.nCoin < Wnd.nOnePrice then
        UiManager:OpenWindow(Ui.UI_INFOBOARD, "你没有足够的金币！")
      elseif Wnd.nCurrency == 1 or Wnd.nCurrency == 2 then
        bOk = 1
      end
      if 1 == bOk then
        Wnd:Buy(Wnd.szKey, tonumber(Wnd.nOnePrice), Wnd.nCurrency)
      end
    end
    if nOptIndex == 99 then
      Ui.tbLogic.tbTempItem:Destroy(Wnd.pTempItem)
    end
  end
  UiManager:OpenWindow(Ui.UI_MSGBOXWITHOBJ, tbApplyMsg, self)
end

function tbSellElem:Buy(szKey, nOnePrice, nCurrency)
  local tbMsg = {}
  tbMsg.szMsg = "是否一口价购买？"
  tbMsg.nOptCount = 2
  function tbMsg:Callback(nOptIndex, szKey, nOnePrice)
    if nOptIndex == 2 then
      KAuction.OnePriceBuyByAdvs(szKey, nOnePrice, nCurrency)
      UiManager:CloseWindow(Ui.UI_MSGBOXWITHOBJ)
    end
  end
  if nCurrency and nCurrency == 2 then
    tbMsg.szMsg = "是否用<color=yellow>金币<color>一口价购买？"
  else
    tbMsg.szMsg = "是否用<color=255,167,0>银两<color>一口价购买？"
  end
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, szKey, nOnePrice)
end

-- 组装道具任务数据
function tbSellElem:PackageTaskData(tbParams)
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

tbMsgList:RegisterBaseClass("sell", tbSellElem)
