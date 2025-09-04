-----------------------------------------------------
--文件名		：	repository.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-03-17
--功能描述		：	储物箱。
------------------------------------------------------

local tbRepository = Ui:GetClass("repository")
local tbObject = Ui.tbLogic.tbObject

local BTN_CLOSE = "BtnClose"
local OBJ_REPOSITORY = "ObjRepository"
local BTN_LEFTPAGE = "BtnLeftPage"
local BTN_RIGHTPAGE = "BtnRightPage"
local BTN_TAKEMONEY = "BtnTakeMoney"
local BTN_SAVEMONEY = "BtnSaveMoney"
local TXT_PAGENUM = "TxtPageNum"
local TXT_MONEY = "TxtMoney"
local TXT_MONEY1 = "TxtMoney1"
local TXT_MONEY2 = "TxtMoney2"
local IMG_BINDMONEY = "ImgBindMoney"
local IMG_BINDCOIN = "ImgBindCoin"
local BTN_SAVE1 = "BtnSave1"
local BTN_SAVE2 = "BtnSave2"
local BTN_TAKE1 = "BtnTake1"
local BTN_TAKE2 = "BtnTake2"
local IMG_SHADOW = "WndShadowImage"
local BTN_ZHANHUN = "btnZhanHun"
local PAGE2ROOM = {
  Item.ROOM_REPOSITORY,
  Item.ROOM_EXTREP1,
  Item.ROOM_EXTREP2,
  Item.ROOM_EXTREP3,
  Item.ROOM_EXTREP4,
  Item.ROOM_EXTREP5,
}

local tbReseverCtr = {
  TXT_MONEY1,
  TXT_MONEY2,
  IMG_BINDCOIN,
  IMG_BINDMONEY,
  BTN_SAVE1,
  BTN_SAVE2,
  BTN_TAKE1,
  BTN_TAKE2,
}

local tbRepCont = { bUse = 0, nRoom = Item.ROOM_REPOSITORY, bSendToGift = 1 }

function tbRepository:Init()
  self.nCurPage = 1
  self.nMaxPage = 6
  self.nBind1 = 0
  self.nBind2 = 0
end

function tbRepository:OnCreate()
  me.GetTempTable("Item").bHasOpened = 0
  self.tbRepCont = tbObject:RegisterContainer(
    self.UIGROUP,
    OBJ_REPOSITORY,
    Item.ROOM_REPOSITORY_WIDTH,
    Item.ROOM_REPOSITORY_HEIGHT,
    tbRepCont, -- 不可使用
    "itemroom"
  )
end

function tbRepCont:CanSendStateUse()
  return 1
end

function tbRepository:OnDestroy()
  tbObject:UnregContainer(self.tbRepCont)
end

function tbRepository:OnOpen(...)
  local nType = unpack(arg)
  self.nType = nType or 0
  --self:RefreshExtRepState(me.nExtRepState);
  self:UpdatePageNumber()
  self:UpdateMoney()
  self.tbRepCont.nRoom = self.nType == 0 and PAGE2ROOM[self.nCurPage] or Item.ROOM_REPOSITORY_EXT
  self.tbRepCont:UpdateRoom()
  UiManager:OpenWindow(Ui.UI_ITEMBOX)
  UiManager:SetUiState(UiManager.UIS_OPEN_REPOSITORY)
  if Player.tbFightPower:IsFightPowerValid() == 1 then
    Wnd_Show(self.UIGROUP, BTN_ZHANHUN)
  else
    Wnd_Hide(self.UIGROUP, BTN_ZHANHUN)
  end
  if not me.GetTempTable("Item").bHasOpened or me.GetTempTable("Item").bHasOpened == 0 or self.nType ~= 0 then
    me.CallServerScript({ "PlayerCmd", "ApplyRepositoryInfo", me.nId, self.nType })
    me.GetTempTable("Item").bHasOpened = (self.nType == 0 and 1 or 0)
  end

  for _, szCtrl in pairs(tbReseverCtr) do
    Wnd_Hide(self.UIGROUP, szCtrl)
  end

  if self.nType == 1 then
    Wnd_Hide(self.UIGROUP, BTN_ZHANHUN)
    Wnd_Hide(self.UIGROUP, BTN_TAKEMONEY)
    Wnd_Hide(self.UIGROUP, BTN_SAVEMONEY)
    Wnd_Hide(self.UIGROUP, BTN_LEFTPAGE)
    Wnd_Hide(self.UIGROUP, BTN_RIGHTPAGE)
    for _, szCtrl in pairs(tbReseverCtr) do
      Wnd_Show(self.UIGROUP, szCtrl)
    end
    Txt_SetTxt(self.UIGROUP, TXT_PAGENUM, "1/1")
    self:UpdateBindInfo(self.nBind1, self.nBind2)
  end
end

function tbRepository:OnClose()
  me.CloseRepository()
  UiManager:ReleaseUiState(UiManager.UIS_OPEN_REPOSITORY)
  self.tbRepCont:ClearRoom()
  UiManager:CloseWindow(Ui.UI_ZHANHUNBAG)
end

function tbRepository:OnButtonClick(szWnd, nParam)
  if szWnd == BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == BTN_TAKEMONEY then
    local tbParam = {}
    tbParam.tbTable = self
    tbParam.fnAccept = self.TakeMoneyAccept
    tbParam.szTitle = "取钱"
    tbParam.varDefault = 0
    tbParam.nType = 0
    tbParam.tbRange = { 0, me.nSaveMoney }
    UiManager:OpenWindow(Ui.UI_TEXTINPUT, tbParam)
  elseif szWnd == BTN_SAVEMONEY then
    local tbParam = {}
    tbParam.tbTable = self
    tbParam.fnAccept = self.SaveMoneyAccept
    tbParam.szTitle = "存钱"
    tbParam.varDefault = 0
    tbParam.nType = 0
    tbParam.tbRange = { 0, me.nCashMoney }
    UiManager:OpenWindow(Ui.UI_TEXTINPUT, tbParam)
  elseif szWnd == BTN_LEFTPAGE then
    if self.nCurPage <= 1 then
      return
    end
    self.nCurPage = self.nCurPage - 1
    self.tbRepCont.nRoom = PAGE2ROOM[self.nCurPage]
    self:UpdatePageNumber()
    self.tbRepCont:UpdateRoom()
  elseif szWnd == BTN_RIGHTPAGE then
    if self.nCurPage >= self.nMaxPage then
      return
    end
    self.nCurPage = self.nCurPage + 1
    self.tbRepCont.nRoom = PAGE2ROOM[self.nCurPage]
    self:UpdatePageNumber()
    self.tbRepCont:UpdateRoom()
  elseif szWnd == BTN_ZHANHUN then
    if UiManager:WindowVisible(Ui.UI_ZHANHUNBAG) == 1 then
      UiManager:CloseWindow(Ui.UI_ZHANHUNBAG)
    else
      UiManager:OpenWindow(Ui.UI_ZHANHUNBAG)
    end
  elseif szWnd == BTN_SAVE1 or szWnd == BTN_SAVE2 or szWnd == BTN_TAKE1 or szWnd == BTN_TAKE2 then
    local nOperate, _nType, nRangeMax, szTitle
    if szWnd == BTN_TAKE1 or szWnd == BTN_SAVE1 then
      _nType = 1
    else
      _nType = 2
    end

    if szWnd == BTN_SAVE1 or szWnd == BTN_SAVE2 then
      nOperate = 1
      nRangeMax = _nType == 1 and me.GetBindMoney() or me.nBindCoin
      szTitle = "存钱"
    else
      nOperate = 2
      nRangeMax = _nType == 1 and self.nBind1 or self.nBind2
      szTitle = "取钱"
    end

    if not nOperate or not _nType then
      return
    end

    local tbParam = {}
    tbParam.tbTable = self
    tbParam.fnAccept = self.BindOperate
    tbParam.szTitle = szTitle
    tbParam.varDefault = 0
    tbParam.nType = 0
    tbParam.tbRange = { 0, nRangeMax }
    UiManager:OpenWindow(Ui.UI_TEXTINPUT, tbParam, nOperate, _nType)
  end
end

function tbRepository:BuildItem(szWnd, uGenre, uId, nX, nY)
  local tbItem = {}
  tbItem.uGenre = uGenre
  tbItem.uId = uId
  tbItem.nX = nX
  tbItem.nY = nY
  tbItem.nRoom = PAGE2ROOM[self.nCurPage]
  return tbItem
end

function tbRepository:UpdateMoney()
  local szMoney = Item:FormatMoney(me.nSaveMoney)
  Txt_SetTxt(self.UIGROUP, TXT_MONEY, szMoney)
end

function tbRepository:UpdatePageNumber()
  if self.nCurPage > me.nExtRepState + 1 then
    self:SetGridBgVisible(1)
  else
    self:SetGridBgVisible(0)
  end

  Wnd_SetEnable(self.UIGROUP, BTN_LEFTPAGE, (self.nCurPage == 1) and 0 or 1)
  Wnd_SetEnable(self.UIGROUP, BTN_RIGHTPAGE, (self.nCurPage == self.nMaxPage) and 0 or 1)
  Txt_SetTxt(self.UIGROUP, TXT_PAGENUM, string.format("%d/%d", self.nCurPage, self.nMaxPage))
end

function tbRepository:OpenRepository(nType)
  UiManager:OpenWindow(self.UIGROUP, nType)
end

function tbRepository:TakeMoneyAccept(szText)
  local nMoney = tonumber(szText)
  if (not nMoney) or (nMoney <= 0) then
    return
  end
  if me.TakeMoney(nMoney) ~= 1 then
    me.Msg("取钱失败。")
  end
end

function tbRepository:SaveMoneyAccept(szText)
  local nMoney = tonumber(szText)
  if (not nMoney) or (nMoney <= 0) then
    return
  end
  if me.SaveMoney(nMoney) ~= 1 then
    me.Msg("存钱失败。")
  end
end

function tbRepository:BindOperate(szText, ...)
  local nCount = tonumber(szText)
  local nOperate, nType = unpack(arg)
  me.CallServerScript({ "ApplyBindBankOperate", nOperate, nType, nCount })
end

function tbRepository:StateRecvUse(szUiGroup)
  if szUiGroup == self.UIGROUP then
    return
  end

  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    return
  end
  self.tbRepCont:SpecialStateRecvUse()
end

function tbRepository:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_OPEN_REPOSITORY, self.OpenRepository },
    { UiNotify.emCOREEVENT_EXTREPSTATE_CHANGED, self.UpdatePageNumber },
    { UiNotify.emCOREEVENT_MONEY_CHANGED, self.UpdateMoney },
    { UiNotify.emUIEVENT_OBJ_STATE_USE, self.StateRecvUse },
  }
  tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbRepCont:RegisterEvent())
  return tbRegEvent
end

function tbRepository:RegisterMessage()
  return self.tbRepCont:RegisterMessage()
end

function tbRepository:OnMouseEnter(szWnd)
  local szTip = ""
  if szWnd == TXT_MONEY then
    szTip = "最大携带量：" .. Item:FormatMoney(me.GetMaxCarryMoney())
  elseif szWnd == TXT_PAGENUM then
    if self.nCurPage > me.nExtRepState + 1 then
      szTip = "您目前还不能使用该扩展页！"
    end
  end

  if szTip ~= "" then
    Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, "", szTip)
  end
end

-- 设置没激活的储物箱的格子背景
function tbRepository:SetGridBgVisible(bVisible)
  for nWidth = 0, Item.ROOM_REPOSITORY_WIDTH do
    for nHeight = 0, Item.ROOM_REPOSITORY_HEIGHT do
      local szImgName = IMG_SHADOW .. nHeight .. nWidth
      Wnd_SetVisible(self.UIGROUP, szImgName, bVisible)
    end
  end
end

function tbRepository:UpdateBindInfo(nBind1, nBind2)
  self.nBind1, self.nBind2 = nBind1, nBind2
  local szBind1 = Item:FormatMoney(self.nBind1)
  local szBind2 = Item:FormatMoney(self.nBind2)
  Txt_SetTxt(self.UIGROUP, TXT_MONEY1, szBind1)
  Txt_SetTxt(self.UIGROUP, TXT_MONEY2, szBind2)
end
