Ui.tbLogic.tbAcutionLink = {}
local tbAcutionLink = Ui.tbLogic.tbAcutionLink
local tbTempItem = Ui.tbLogic.tbTempItem

function tbAcutionLink:Init()
  self.szKey = ""
  self.nOnePrice = 0
end

function tbAcutionLink:Buy(szKey, nOnePrice)
  local tbMsg = {}
  tbMsg.szMsg = "是否一口价购买？"
  tbMsg.nOptCount = 2
  function tbMsg:Callback(nOptIndex, szKey, nOnePrice)
    if nOptIndex == 2 then
      print("[Auction] 广告购买: 暂时只支持银两。", nOnePrice, szKey)
      KAuction.OnePriceBuyByAdvs(szKey, nOnePrice, 1)
      UiManager:CloseWindow(Ui.UI_MSGBOXWITHOBJ)
    end
  end
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, szKey, nOnePrice)
end

function tbAcutionLink:OnePriceBuy(szkey, nPrice, tbItemList)
  self.szKey = szkey
  self.nOnePrice = nPrice

  -- zjq comm 如果拍卖行的任务数据要显示，就需要修改这里
  local pItem = tbTempItem:Create(tbItemList[1], tbItemList[2], tbItemList[3], tbItemList[4], tbItemList[5], tbItemList[6], tbItemList[7], tbItemList[13], tbItemList[8], tbItemList[9], -1, tbItemList[10], 0, tbItemList[11], tbItemList[12], tbItemList[14], tbItemList[15]) -- 创建临时道具对象
  if not pItem then
    return
  end

  self.pTempItem = pItem
  local tbObj = nil
  if pItem then
    tbObj = {}
    tbObj.nType = Ui.OBJ_ITEM
    tbObj.pItem = pItem
  end

  local tbApplyMsg = {}
  tbApplyMsg.tgObj = tbObj
  tbApplyMsg.szObjName = pItem.szName
  tbApplyMsg.szMsg = "您确认以一口价：<color=255,167,0>" .. Item:FormatMoney(self.nOnePrice) .. "<color>(两)来购买这件物品？"
  tbApplyMsg.szTitle = "竞拍物品"
  tbApplyMsg.nOptCount = 2
  tbApplyMsg.bObjEdt = 0
  tbApplyMsg.bClose = 0
  function tbApplyMsg:Callback(nOptIndex, msgWnd, Wnd)
    if nOptIndex == 2 then
      if me.nCashMoney < Wnd.nOnePrice then
        UiManager:OpenWindow(Ui.UI_INFOBOARD, "你没有足够的银两！")
      else
        Wnd:Buy(Wnd.szKey, Wnd.nOnePrice)
      end
    end

    if nOptIndex == 99 then
      tbTempItem:Destroy(Wnd.pTempItem)
    end
  end
  UiManager:OpenWindow(Ui.UI_MSGBOXWITHOBJ, tbApplyMsg, self)
end
