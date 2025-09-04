local tbKinRepository = Ui:GetClass("kinrepository")
local tbObject = Ui.tbLogic.tbObject
local tbMouse = Ui.tbLogic.tbMouse

local BTN_CLOSE = "BtnClose"
local OBJ_REPOSITORY = "ObjRepository"
local BTN_LEFTPAGE = "BtnLeftPage"
local BTN_RIGHTPAGE = "BtnRightPage"
local TXT_PAGENUM = "TxtPageNum"
local IMG_SHADOW = "WndShadowImage"
local BTN_SPLIT = "BtnApplySplit"
local BTN_APPLYOPERATE = "BtnApplyOperate"
local BTN_APPLYTAKE = "BtnApplyTake"
local BTN_FREEROOM = "BtnFreeRoom"
local BTN_LIMITROOM = "BtnLimitRoom"
local BTN_VIEWRECORD = "BtnViewRecord"
local IMG_SHADOW = "WndShadowImage"
local BTN_EXTEND = "BtnExtend"
local TXT_PROMPT = "TxtPrompt"
local TXT_AUTHTIME = "TxtAuthTime"

local tbRepCont = { bUse = 0, nRoom = Item.ROOM_KIN_REPOSITORY1, bSendToGift = 1 }

function tbKinRepository:Init()
  self.nRoomType = 1
  self.nCurPage = 1
  self.nMaxPage = 2
end

function tbKinRepository:OnCreate()
  self.tbRepCont = tbObject:RegisterContainer(
    self.UIGROUP,
    OBJ_REPOSITORY,
    Item.ROOM_KIN_REPOSITORY_WIDTH,
    Item.ROOM_KIN_REPOSITORY_HEIGHT,
    tbRepCont, -- 不可使用
    "itemroom"
  )
end

function tbRepCont:CanSendStateUse()
  return 1
end

function tbKinRepository:OnDestroy()
  tbObject:UnregContainer(self.tbRepCont)
end

function tbKinRepository:OnOpen(nRoom)
  nRoom = nRoom or Item.ROOM_KIN_REPOSITORY1
  -- 把家族仓库的道具设置到玩家空间
  self.nRoomType, self.nCurPage, self.nMaxPage = self:GetRoomIndex(nRoom)
  self:UpdatePageNumber()
  self:UpdateButtonState()
  self.tbRepCont.nRoom = nRoom
  self:UpdateKinRepRoom(nRoom, 0)
  --UiManager:OpenWindow(Ui.UI_ITEMBOX);
  UiManager:SetUiState(UiManager.UIS_OPEN_KINREPOSITORY)
  self.nTakeBtnTimer = Timer:Register(18, self.UpdateButtonStateTimer, self)
end

-- 1代表自由仓库，2代表限制仓库
function tbKinRepository:GetRoomIndex(nRoom)
  for nIndex, nTemp in ipairs(KinRepository.FREE_ROOM_SET) do
    if nTemp == nRoom then
      return 1, nIndex, #KinRepository.FREE_ROOM_SET
    end
  end
  for nIndex, nTemp in ipairs(KinRepository.LIMIT_ROOM_SET) do
    if nTemp == nRoom then
      return 2, nIndex, #KinRepository.LIMIT_ROOM_SET
    end
  end
  return 0
end

--更新指定room的道具
function tbKinRepository:UpdateKinRepRoom(nRoom, bOpen, bCanOperate)
  nRoom = nRoom or Item.ROOM_KIN_REPOSITORY1
  if bCanOperate == 1 then
    if UiManager:WindowVisible(Ui.UI_ITEMBOX) ~= 1 then
      UiManager:OpenWindow(Ui.UI_ITEMBOX)
    end
  end
  if bOpen == 1 then
    if UiManager:WindowVisible(Ui.UI_KINREPOSITORY) ~= 1 then
      UiManager:OpenWindow(Ui.UI_KINREPOSITORY, nRoom)
      return
    else
      -- 仓库已经打开了则刷新到指定页
      self.tbRepCont.nRoom = nRoom
      self.nRoomType, self.nCurPage, self.nMaxPage = self:GetRoomIndex(nRoom)
      self:UpdatePageNumber()
      self:UpdateButtonState()
      me.CallServerScript({ "KinCmd", "RefreshRepositoryInfo" })
    end
  end
  if self.tbRepCont.nRoom ~= nRoom then -- 不是当前页的当局更新不要刷新
    return
  end
  self.tbRepCont:UpdateRoom()
  -- 如果鼠标上的道具是这个空间的话则更新一下鼠标的道具
  local tbMouseObj = tbMouse.tbObj
  if tbMouseObj and tbMouseObj.nRoom == nRoom then
    tbMouse:Refresh()
  end
  self:SetGridBgVisible(nRoom)
end

function tbKinRepository:OnClose()
  KKinRepository.CloseRepository()
  self.tbRepCont:ClearRoom()
  UiManager:ReleaseUiState(UiManager.UIS_OPEN_KINREPOSITORY)
  local tbMouseObj = tbMouse.tbObj
  if tbMouseObj and tbMouseObj.nRoom >= Item.ROOM_KIN_REPOSITORY1 and tbMouseObj.nRoom <= Item.ROOM_KIN_REPOSITORY10 then
    tbMouse:Clear()
  end
  Timer:Close(self.nTakeBtnTimer)
end

function tbKinRepository:StateRecvUse(szUiGroup)
  if szUiGroup == self.UIGROUP then
    return
  end
  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    return
  end
  self.tbRepCont:SpecialStateRecvUse()
end

function tbKinRepository:OnButtonClick(szWnd, nParam)
  if szWnd == BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == BTN_LEFTPAGE then
    if self.nCurPage <= 1 then
      return 0
    end
    self.nCurPage = self.nCurPage - 1
    self:UpdatePageNumber()
    self.tbRepCont.nRoom = KinRepository.ROOM_SET[self.nRoomType][self.nCurPage]
    self:UpdateKinRepRoom(self.tbRepCont.nRoom)
    KKinRepository.OpenRoomRequest(self.tbRepCont.nRoom)
  elseif szWnd == BTN_RIGHTPAGE then
    if self.nCurPage >= self.nMaxPage then
      return
    end
    self.nCurPage = self.nCurPage + 1
    self:UpdatePageNumber()
    self.tbRepCont.nRoom = KinRepository.ROOM_SET[self.nRoomType][self.nCurPage]
    self:UpdateKinRepRoom(self.tbRepCont.nRoom)
    KKinRepository.OpenRoomRequest(self.tbRepCont.nRoom)
  elseif szWnd == BTN_SPLIT then
    if self.nRoomType == KinRepository.REPTYPE_LIMIT and KinRepository:GetRemainTakeAuthority() == 0 then
      me.Msg("请先点击[权限申请]按钮申请取出操作")
      return
    end
    self:SwitchSplitItemState()
  elseif szWnd == BTN_FREEROOM then
    self:SwitchFreeLimitState(KinRepository.REPTYPE_FREE)
  elseif szWnd == BTN_LIMITROOM then
    self:SwitchFreeLimitState(KinRepository.REPTYPE_LIMIT)
  elseif szWnd == BTN_VIEWRECORD then
    me.CallServerScript({ "KinCmd", "ApplyViewRecord", self.nRoomType, 1 })
  elseif szWnd == BTN_APPLYTAKE then
    me.CallServerScript({ "KinCmd", "ApplyRepTakeAuthority" })
  elseif szWnd == BTN_APPLYOPERATE then
    local nRoomSize = KinRepository:GetRoomSize(self.tbRepCont.nRoom)
    if nRoomSize <= 0 then
      me.Msg("本页仓库还未开放，无法存取")
      return
    end
    KKinRepository.ApplyRepositoryOpearte(KinRepository.ROOM_SET[self.nRoomType][self.nCurPage])
  elseif szWnd == BTN_EXTEND then
    me.CallServerScript({ "KinCmd", "ApplyExtendRep" })
  end
end

-- 切换自由仓库和限制仓库
function tbKinRepository:SwitchFreeLimitState(nRoomType)
  if self.nRoomType == nRoomType then
    self:UpdateButtonState()
    return
  end
  self.nRoomType = nRoomType
  self.nCurPage = 1
  self.nMaxPage = #KinRepository.ROOM_SET[nRoomType]
  self:UpdateButtonState()
  self:UpdatePageNumber()
  self.tbRepCont.nRoom = KinRepository.ROOM_SET[self.nRoomType][self.nCurPage]
  self:UpdateKinRepRoom(self.tbRepCont.nRoom)
  KKinRepository.OpenRoomRequest(KinRepository.ROOM_SET[nRoomType][1])
end

-- 切换切分道具的UI状态
function tbKinRepository:SwitchSplitItemState()
  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    return
  end

  if UiManager:WindowVisible(Ui.UI_SHOP) == 1 then
    UiManager:CloseWindow(Ui.UI_SHOP)
  end

  if UiManager:GetUiState(UiManager.UIS_KINREPITEM_SPLIT) ~= 1 then -- 不在拆分道具的状态则进入其状态
    self:ResetUiState()
    UiManager:SetUiState(UiManager.UIS_KINREPITEM_SPLIT)
    Btn_Check(self.UIGROUP, BTN_SPLIT, 1)
  else -- 处于拆分道具的状态则释放之
    UiManager:ReleaseUiState(UiManager.UIS_KINREPITEM_SPLIT)
    Btn_Check(self.UIGROUP, BTN_SPLIT, 0)
  end
end

function tbKinRepository:ResetUiState()
  UiManager:ReleaseUiState(UiManager.UIS_STALL_SETPRICE)
  UiManager:ReleaseUiState(UiManager.UIS_OFFER_SETPRICE)
  UiManager:ReleaseUiState(UiManager.UIS_ITEM_REPAIR)
  UiManager:ReleaseUiState(UiManager.UIS_ITEM_SPLIT)
  UiManager:ReleaseUiState(UiManager.UIS_KINREPITEM_SPLIT)
end

-- 更新按钮状态
function tbKinRepository:UpdateButtonState()
  local nRemain = KinRepository:GetRemainTakeAuthority()
  if self.nRoomType == KinRepository.REPTYPE_FREE then
    Btn_Check(self.UIGROUP, BTN_FREEROOM, 1)
    Btn_Check(self.UIGROUP, BTN_LIMITROOM, 0)
    Wnd_Hide(self.UIGROUP, BTN_APPLYTAKE)
    Txt_SetTxt(self.UIGROUP, TXT_AUTHTIME, "")
  elseif self.nRoomType == KinRepository.REPTYPE_LIMIT then
    Btn_Check(self.UIGROUP, BTN_FREEROOM, 0)
    Btn_Check(self.UIGROUP, BTN_LIMITROOM, 1)
    Wnd_Show(self.UIGROUP, BTN_APPLYTAKE)
    if not KinRepository.nAuthority or KinRepository.nAuthority < KinRepository.AUTHORITY_ASSISTANT then
      Wnd_SetEnable(self.UIGROUP, BTN_APPLYTAKE, 0)
      Btn_SetTxt(self.UIGROUP, BTN_APPLYTAKE, "权限申请")
    else
      if nRemain > 0 then
        Wnd_SetEnable(self.UIGROUP, BTN_APPLYTAKE, 0)
        Btn_SetTxt(self.UIGROUP, BTN_APPLYTAKE, "已有权限")
        Txt_SetTxt(self.UIGROUP, TXT_AUTHTIME, "权限操作剩余时间：" .. nRemain .. "秒")
      else
        Wnd_SetEnable(self.UIGROUP, BTN_APPLYTAKE, 1)
        Btn_SetTxt(self.UIGROUP, BTN_APPLYTAKE, "权限申请")
        Txt_SetTxt(self.UIGROUP, TXT_AUTHTIME, "")
      end
    end
  end

  Wnd_SetEnable(self.UIGROUP, BTN_EXTEND, 1)

  -- 权限被冻结了，怎么都不能存取
  if KinRepository.nAuthority and KinRepository.nAuthority == -1 then
    Txt_SetTxt(self.UIGROUP, TXT_PROMPT, "当前权限<color=red>已被禁止<color>")
    Wnd_SetEnable(self.UIGROUP, BTN_SPLIT, 0)
  else
    if KinRepository.nOpenState and KinRepository.nOpenState == 1 then
      if self.nRoomType == KinRepository.REPTYPE_LIMIT and KinRepository:GetRemainTakeAuthority() <= 0 then
        Wnd_SetEnable(self.UIGROUP, BTN_SPLIT, 0)
        Txt_SetTxt(self.UIGROUP, TXT_PROMPT, "当前权限<color=green>【可存】<color>/<color=red>【不可取】<color>")
      else
        if KinRepository.nAuthority and KinRepository.nAuthority >= 2 then
          Wnd_SetEnable(self.UIGROUP, BTN_SPLIT, 1)
          Txt_SetTxt(self.UIGROUP, TXT_PROMPT, "当前权限<color=green>【可存】<color>/<color=green>【可取】<color>")
        else
          Wnd_SetEnable(self.UIGROUP, BTN_SPLIT, 1)
          Txt_SetTxt(self.UIGROUP, TXT_PROMPT, "当前权限<color=green>【可存】<color>/<color=red>【不可取】<color>")
        end
      end
    else
      Wnd_SetEnable(self.UIGROUP, BTN_SPLIT, 0)
      Txt_SetTxt(self.UIGROUP, TXT_PROMPT, "点击[我要存取]按钮即可开始存取物品")
    end
  end
end

-- 申请权限按钮更新
function tbKinRepository:UpdateButtonStateTimer()
  if UiManager:WindowVisible(Ui.UI_KINREPOSITORY) ~= 1 then
    return 0
  end
  self:UpdateButtonState()
  return 18
end

function tbKinRepository:UpdatePageNumber()
  Wnd_SetEnable(self.UIGROUP, BTN_LEFTPAGE, (self.nCurPage == 1) and 0 or 1)
  Wnd_SetEnable(self.UIGROUP, BTN_RIGHTPAGE, (self.nCurPage == self.nMaxPage) and 0 or 1)
  Txt_SetTxt(self.UIGROUP, TXT_PAGENUM, string.format("%d/%d", self.nCurPage, self.nMaxPage))
end

function tbKinRepository:SplitItem(nSplitCount, pItem, nPickRoom, nPickX, nPickY)
  if not pItem then
    return
  end
  if me.CountFreeBagCell() < 1 then
    me.Msg("请空出1个背包以放置拆分的道具！")
    return 0
  end
  local nDropRoom, nDropX, nDropY = self:GetFreeBagPos()
  if not nDropRoom or not nDropX or not nDropY then
    return 0
  end
  KKinRepository.SplitItem(nPickRoom, nPickX, nPickY, nDropRoom, nDropX, nDropY, nSplitCount)
  return 0
end

function tbKinRepository:GetFreeBagPos()
  if UiVersion == Ui.Version002 then
    if UiManager:WindowVisible(Ui.UI_ITEMBOX) == 1 then
      for i = 1, 11 do
        if Ui(Ui.UI_ITEMBOX).tbBagExCont[i] then
          local nX, nY = Ui(Ui.UI_ITEMBOX).tbBagExCont[i]:GetFreePos()
          if nX and nY then
            return Ui.tbNewBag:GetTrueRoomPosByMaping(i + Item.ROOM_INTEGRATIONBAG1 - 1, nX, nY)
          end
        end
      end
    end
  else
    if UiManager:WindowVisible(Ui.UI_ITEMBOX) == 1 then
      local nX, nY = Ui(Ui.UI_ITEMBOX).tbExtBagBarCont:GetFreePos()
      if nX and nY then
        return Item.ROOM_MAINBAG, nX, nY
      end
    end
    if UiManager:WindowVisible(Ui.UI_EXTBAG1) == 1 then
      local nX, nY = Ui(Ui.UI_EXTBAG1).tbExtBagCont:GetFreePos()
      if nX and nY then
        return Item.ROOM_EXTBAG1, nX, nY
      end
    end
    if UiManager:WindowVisible(Ui.UI_EXTBAG2) == 1 then
      local nX, nY = Ui(Ui.UI_EXTBAG2).tbExtBagCont:GetFreePos()
      if nX and nY then
        return Item.ROOM_EXTBAG2, nX, nY
      end
    end

    if UiManager:WindowVisible(Ui.UI_EXTBAG3) == 1 then
      local nX, nY = Ui(Ui.UI_EXTBAG3).tbExtBagCont:GetFreePos()
      if nX and nY then
        return Item.ROOM_EXTBAG3, nX, nY
      end
    end
  end
end

function tbKinRepository:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_KINREPOSITORY_CHANGE, self.UpdateKinRepRoom },
    { UiNotify.emUIEVENT_OBJ_STATE_USE, self.StateRecvUse },
  }
  tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbRepCont:RegisterEvent())
  return tbRegEvent
end

function tbKinRepository:RegisterMessage()
  return self.tbRepCont:RegisterMessage()
end

-- 更新页面状态
function tbKinRepository:UpdatePageState()
  if UiManager:WindowVisible(Ui.UI_KINREPOSITORY) ~= 1 then
    return
  end
  self:UpdateButtonState()
  self:SetGridBgVisible(KinRepository.ROOM_SET[self.nRoomType][self.nCurPage])
end

-- 设置没激活的储物箱的格子背景
function tbKinRepository:SetGridBgVisible(nRoom)
  local nRoomSize = KinRepository:GetRoomSize(nRoom)
  if not nRoomSize then
    return
  end
  local nRoomIndex = 0
  for nHeight = 0, Item.ROOM_KIN_REPOSITORY_HEIGHT - 1 do
    for nWidth = 0, Item.ROOM_KIN_REPOSITORY_WIDTH - 1 do
      local szImgName = IMG_SHADOW .. nHeight .. nWidth
      if nRoomIndex < nRoomSize then
        Wnd_SetVisible(self.UIGROUP, szImgName, 0)
      else
        Wnd_SetVisible(self.UIGROUP, szImgName, 1)
      end
      nRoomIndex = nRoomIndex + 1
    end
  end
end
