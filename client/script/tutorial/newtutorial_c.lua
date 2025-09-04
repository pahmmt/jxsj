if MODULE_GAMESERVER or MODULE_GC_SERVER then
  return
end

Require("\\script\\tutorial\\define.lua")

Tutorial.tbInterFaceFun = {
  --触发事件
  ["ButtonClick"] = "ButtonClick", --点击按钮
  ["OpenWindow"] = "OpenWindow", --打开窗口
  ["GetObj"] = "GetObj", --拿起obj
  ["DropObj"] = "DropObj", --放入obj
  ["MoveWindow"] = "MoveWindow", --移动窗口
  ["CloseWindow"] = "CloseWindow", --关闭窗口
  ["UseShortcut"] = "UseShortcut", --使用快捷
  ["DialogClick"] = "DialogClick", --点击对话连接
  ["TaskLinkClick"] = "TaskLinkClick", --点击任务连接
  ["RefreshLinkClick"] = "RefreshLinkClick", --跟新任务列表
  ["ShopObjClick"] = "ShopObjClick", --shop类点击obj
  ["CustomEvent"] = "CustomEvent", --自定义事件，目前只支持第二个button响应完成事件：todo

  --显示事件
  ["ShowWindow"] = "ShowWindow", --显示屏幕某点
  ["ShowButton"] = "ShowButton", --显示按钮上
  ["ShowItem"] = "ShowItem", --显示背包道具
  ["ShowShot"] = "ShowShot", --快捷栏物品
  ["ShowObj"] = "ShowObj", --显示背包道具
  ["ShowDialog"] = "ShowDialog", --对话框
  ["ShowTaskList"] = "ShowTaskList", --任务列表
}

Tutorial.tbWaitCloseTransparencyList = {}

-----------触发事件-------------------------------------------------------------
function Tutorial:Action(szType, szAction, nIndex)
  if self.tbFinishAction[szType] then
    if szAction == self.tbFinishAction[szType][nIndex] then
      if self.nLock == 1 then
        self.nLock = 0
      end
      self:StarEvent(self.nTaskId)
    end
  end
  if self.tbReAction[szType] then
    if szAction == self.tbReAction[szType][nIndex] then
      if self.nLock == 1 then
        self.nLock = 0
      end
      self:StarEvent(self.nTaskId, -1)
    end
  end
  if self.tbCloseAction[szType] then
    if szAction == self.tbCloseAction[szType][nIndex] then
      self:CloseEvent()
    end
  end
  return
end

function Tutorial:CustomEvent(szType, tbParam)
  local tb = self.tbFinishAction["CustomEvent"]
  if tb and tb[1] == szType then
    if tbParam[1] == tb[2] and string.find(tbParam[2], tb[3]) then
      if self.nLock == 1 then
        self.nLock = 0
      end
      self:StarEvent(self.nTaskId)
    end
  end
  tb = self.tbReAction["CustomEvent"]
  if tb and tb[1] == szType then
    if tbParam[1] == tb[2] and string.find(tbParam[2], tb[3]) then
      if self.nLock == 1 then
        self.nLock = 0
      end
      self:StarEvent(self.nTaskId, -1)
    end
  end
  tb = self.tbCloseAction["CustomEvent"]
  if tb and tb[1] == szType then
    if tbParam[1] == tb[2] and string.find(tbParam[2], tb[3]) then
      if self.nLock == 1 then
        self.nLock = 0
      end
      self:CloseEvent(self.nTaskId)
    end
  end
  return
end

function Tutorial:ShopObjClick(szUiGroup, szObjGrid, nX, nY)
  if self.tbFinishAction["ShopObjClick"] then
    if szUiGroup == self.tbFinishAction["ShopObjClick"][1] and szObjGrid == self.tbFinishAction["ShopObjClick"][2] and nX == tonumber(self.tbFinishAction["ShopObjClick"][3]) and nY == tonumber(self.tbFinishAction["ShopObjClick"][4]) then
      if self.nLock == 1 then
        self.nLock = 0
      end
      self:StarEvent(self.nTaskId)
    end
  end
  if self.tbReAction["ShopObjClick"] then
    if szUiGroup == self.tbFinishAction["ShopObjClick"][1] and szObjGrid == self.tbFinishAction["ShopObjClick"][2] and nX == tonumber(self.tbFinishAction["ShopObjClick"][3]) and nY == tonumber(self.tbFinishAction["ShopObjClick"][4]) then
      if self.nLock == 1 then
        self.nLock = 0
      end
      self:StarEvent(self.nTaskId, -1)
    end
  end
  if self.tbCloseAction["ShopObjClick"] then
    if szUiGroup == self.tbFinishAction["ShopObjClick"][1] and szObjGrid == self.tbFinishAction["ShopObjClick"][2] and nX == tonumber(self.tbFinishAction["ShopObjClick"][3]) and nY == tonumber(self.tbFinishAction["ShopObjClick"][4]) then
      self:CloseEvent()
    end
  end
  return
end

function Tutorial:RefreshLinkClick(nFlag)
  if 1 ~= nFlag then
    if self.tbReAction["RefreshLinkClick"] then
      if self.nLock == 1 then
        self.nLock = 0
      end
      self:StarEvent(self.nTaskId, -1)
    end
  else
    if self.tbCloseAction["RefreshLinkClick"] then
      self:CloseEvent()
    end
  end
  return
end

function Tutorial:TaskLinkClick(szLink)
  if self.tbFinishAction["TaskLinkClick"] then
    if string.find(szLink, self.tbFinishAction["TaskLinkClick"][1]) then
      if self.nLock == 1 then
        self.nLock = 0
      end
      self:StarEvent(self.nTaskId)
    end
  end
  if self.tbReAction["TaskLinkClick"] then
    if szLink == self.tbReAction["TaskLinkClick"][1] then
      if self.nLock == 1 then
        self.nLock = 0
      end
      self:StarEvent(self.nTaskId, -1)
    end
  end
  if self.tbCloseAction["TaskLinkClick"] then
    if szLink == self.tbCloseAction["TaskLinkClick"][1] then
      self:CloseEvent()
    end
  end
  return
end

function Tutorial:DialogClick(nParam)
  return self:Action("DialogClick", nParam, 1)
end

function Tutorial:UseShortcut(fnCmd, szCmd, szAlias)
  local szShortcut = UiShortcutAlias:FindShortcut(szAlias)
  local i = 1
  if UiShortcutAlias.m_nControlMode == 2 then
    i = i + 1
  end
  return self:Action("UseShortcut", szShortcut, i)
end

function Tutorial:MoveWindow(szUiGroup)
  return self:Action("MoveWindow", szUiGroup, 1)
end

function Tutorial:CloseWindow(szUiGroup)
  return self:Action("CloseWindow", szUiGroup, 1)
end

function Tutorial:ButtonClick(szFunc, szUiGroup, szWnd)
  if szFunc ~= "OnButtonClick" then
    return
  end
  if self.tbFinishAction["ButtonClick"] then
    if szUiGroup == self.tbFinishAction["ButtonClick"][1] and szWnd == self.tbFinishAction["ButtonClick"][2] then
      if self.nLock == 1 then
        self.nLock = 0
      end
      self:StarEvent(self.nTaskId)
    end
  end
  if self.tbReAction["ButtonClick"] then
    if szUiGroup == self.tbReAction["ButtonClick"][1] and szWnd == self.tbReAction["ButtonClick"][2] then
      if self.nLock == 1 then
        self.nLock = 0
      end
      self:StarEvent(self.nTaskId, -1)
    end
  end
  if self.tbCloseAction["ButtonClick"] then
    if szUiGroup == self.tbCloseAction["ButtonClick"][1] and szWnd == self.tbCloseAction["ButtonClick"][2] then
      self:CloseEvent()
    end
  end
  self:CustomEvent("ButtonClick", { szUiGroup, szWnd })
  return
end

function Tutorial:OpenWindow(szUiGroup)
  return self:Action("OpenWindow", szUiGroup, 1)
end

function Tutorial:DropObj(szUiGroup, szObjGrid, nX, nY)
  if self.tbFinishAction["DropObj"] then
    local tb = self.tbFinishAction["DropObj"]
    if szUiGroup == tb[1] and szObjGrid == tb[2] and (not tb[3] or nX == tonumber(tb[3])) and (not tb[4] or nY == tonumber(tb[4])) then
      if self.nLock == 1 then
        self.nLock = 0
      end
      self:StarEvent(self.nTaskId)
    end
  end
  if self.tbCloseAction["DropObj"] then
    local tb = self.tbCloseAction["DropObj"]
    if szUiGroup == tb[1] and szObjGrid == tb[2] and (not tb[3] or nX == tonumber(tb[3])) and (not tb[4] or nY == tonumber(tb[4])) then
      self:CloseEvent()
    end
  end
  if self.tbReAction["DropObj"] then
    local tb = self.tbReAction["DropObj"]
    if szUiGroup == tb[1] and szObjGrid == tb[2] and (not tb[3] or nX == tonumber(tb[3])) and (not tb[4] or nY == tonumber(tb[4])) then
      if self.nLock == 1 then
        self.nLock = 0
      end
      self:StarEvent(self.nTaskId, -1)
    end
  end
  return
end

function Tutorial:GetObj(szUiGroup, szObjGrid, nX, nY)
  if self.tbFinishAction["GetObj"] then
    local tb = self.tbFinishAction["GetObj"]
    if szUiGroup == tb[1] and szObjGrid == tb[2] and (not tb[3] or nX == tonumber(tb[3])) and (not tb[4] or nY == tonumber(tb[4])) then
      if self.nLock == 1 then
        self.nLock = 0
      end
      self:StarEvent(self.nTaskId)
    end
  end
  if self.tbReAction["GetObj"] then
    local tb = self.tbReAction["GetObj"]
    if szUiGroup == tb[1] and szObjGrid == tb[2] and (not tb[3] or nX == tonumber(tb[3])) and (not tb[4] or nY == tonumber(tb[4])) then
      self:CloseEvent()
    end
  end
  if self.tbCloseAction["GetObj"] then
    local tb = self.tbCloseAction["GetObj"]
    if szUiGroup == tb[1] and szObjGrid == tb[2] and (not tb[3] or nX == tonumber(tb[3])) and (not tb[4] or nY == tonumber(tb[4])) then
      if self.nLock == 1 then
        self.nLock = 0
      end
      self:StarEvent(self.nTaskId, -1)
    end
  end
  return
end

-------------显示事件--------------------------------------------------------------

function Tutorial:ShowShot(tbParam)
  local nType1, nType2 = self:SplitType(tbParam[1])
  local nPos = tonumber(tbParam[2]) or 0
  local szMsg = tbParam[3]
  local nTime = tonumber(tbParam[4]) or 0
  local szControl = "TxtNum%d"
  if nPos < 0 or nTime <= 0 or nType1 < 0 or nType2 < 0 then
    return
  end
  szControl = string.format(szControl, nPos)
  self:ShowPopTips(Ui.UI_SHORTCUTBAR, "ObjShortcut", szMsg, nType1, nTime, 36 * nPos - 18, 0)
  ObjGrid_SetTransparency("UI_SHORTCUTBAR", "ObjShortcut", "\\image\\icon\\other\\autoskill.spr", nPos - 1, 0)
end

function Tutorial:GetWindowPos(szUiGroup, szWnd)
  if szUiGroup == "Minimap" then
    return Minimap_Btn_Pos(szWnd)
  end
  local _, _, nAbsX, nAbsY = Wnd_GetPos(szUiGroup, szWnd)
  return nAbsX, nAbsY
end

function Tutorial:GetWindowSize(szUiGroup, szWnd)
  if szUiGroup == "Minimap" then
    return Minimap_Btn_Size(szWnd)
  end
  return Wnd_GetSize(szUiGroup, szWnd)
end

function Tutorial:ShowWindow(tbParam)
  local nX, nY = 0, 0
  local tbFinishAction = {}
  local nType1, nType2 = self:SplitType(tbParam[1])
  local szFinishEvent = ""
  local nWidth, nHeight = 0, 0

  if nType2 == 1 then
    local tbX = self:SplitTable(tbParam[2])
    local tbY = self:SplitTable(tbParam[3])
    tbFinishAction = Lib:SplitStr(tbParam[4])
    szFinishEvent = tbParam[5]
    if Ui.szMode == "a" then
      nX = tbX[1]
      nY = tbY[1]
    elseif Ui.szMode == "b" then
      nX = tbX[2]
      nY = tbY[2]
    elseif Ui.szMode == "c" then
      nX = tbX[3]
      nY = tbY[3]
    elseif Ui.szMode == "d" then
      nX = tbX[4]
      nY = tbY[4]
    end
  elseif nType2 == 2 then
    local tbWnd = Lib:SplitStr(tbParam[2])
    tbFinishAction = Lib:SplitStr(tbParam[3])
    nX, nY = self:GetWindowPos(tbWnd[1], tbWnd[2])
    nWidth, nHeight = self:GetWindowSize(tbWnd[1], tbWnd[2])
  end

  if nType1 <= 0 then
    return
  end
  self:ShowWindowEx(nType1, nX, nY, nWidth, nHeight, 1)
  self.tbFinishAction["OpenWindow"] = { tbFinishAction[1] }
  local tbFinishActionEx = self:SplitEvent(szFinishEvent)
  for szType, tb in pairs(tbFinishActionEx) do
    self.tbFinishAction[szType] = tb
  end
end

function Tutorial:ShowWindowEx(nType, nX, nY, nWidth, nHeight, nFlag)
  local tbPos = { { 20, 0 }, { 20, 70 }, { 70, 20 }, { 0, 20 } } --偏移
  if nWidth and nHeight then
    if not nFlag then
      tbPos = { { 20, 0 - nHeight / 2 }, { 20, 70 - nHeight / 2 }, { 70 - nWidth / 2, 20 - nHeight / 2 }, { 0 + nWidth / 2, 20 - nHeight / 2 } }
    else
      tbPos = { { 20 - nWidth / 2, -nHeight }, { 20 - nWidth / 2, 70 }, { 70, 20 - nHeight / 2 }, { -nWidth, 20 - nHeight / 2 } }
    end
  end
  UiManager:OpenWindow(Ui.UI_WEDDING, nType + 1)
  UiManager:MoveWindow(Ui.UI_WEDDING, nX - tbPos[nType][1], nY - tbPos[nType][2])
end

function Tutorial:ShowButton(tbParam)
  local nType1, nType2 = self:SplitType(tbParam[1])
  local szGroup = tbParam[2]
  local szWnd = tbParam[3]
  local szMsg = tbParam[4]
  local nTime = tonumber(tbParam[5]) or 0
  local szFinishEvent = tbParam[6]
  local szCloseEvent = tbParam[7]
  local szReEvent = tbParam[8]
  if szGroup == "" or szWnd == "" or nTime <= 0 or nType1 < 0 or nType2 < 0 then
    return
  end
  if UiManager:WindowVisible(Ui[szGroup]) ~= 1 then
    return
  end
  local nX1, nY1, nX, nY = self:GetWndPos(szGroup, szWnd)
  local nWidth, nHeight = Wnd_GetSize(szGroup, szWnd)
  self:ShowPopTips(szGroup, szWnd, szMsg, nType1, nTime)
  self:ShowWindowEx(nType2, nX, nY, nWidth, nHeight, 1)
  self.szFinishAction = "ButtonClick"
  self.tbParamFinishAction = { szGroup, szWnd }
  self.tbActionWnd = { szGroup, szWnd }
  self.tbFinishAction["ButtonClick"] = { szGroup, szWnd }
  local tbFinishActionEx = self:SplitEvent(szFinishEvent)
  for szType, tb in pairs(tbFinishActionEx) do
    self.tbFinishAction[szType] = tb
  end
  self.tbCloseAction = self:SplitEvent(szCloseEvent)
  self.tbReAction = self:SplitEvent(szReEvent)
  self.nLock = 1
end

function Tutorial:ShowObj(tbParam)
  local nType1, nType2 = self:SplitType(tbParam[1])
  local szGroup = tbParam[2]
  local szWnd = tbParam[3]
  local nX = tonumber(tbParam[4]) or -1
  local nY = tonumber(tbParam[5]) or -1
  local szMsg = tbParam[6]
  local nTime = tonumber(tbParam[7]) or 0
  local szFinishEvent = tbParam[8]
  local szCloseEvent = tbParam[9]
  local szReEvent = tbParam[10]
  if szGroup == "" or szWnd == "" or nTime <= 0 or nX < 0 or nY < 0 or nType1 < 0 or nType2 < 0 then
    return
  end
  local _, _, nX1, nY1 = self:GetWndPos(szGroup, szWnd)
  self:ShowPopTips(szGroup, szWnd, szMsg, nType1, nTime, nX * 36 + 18, nY * 36 + 18)
  self:ShowWindowEx(nType2, nX1 + nX * 36, nY1 + nY * 36, 36, 36)
  self.tbActionWnd = { szGroup, szWnd }
  self.tbFinishAction = self:SplitEvent(szFinishEvent)
  self.tbCloseAction = self:SplitEvent(szCloseEvent)
  self.tbReAction = self:SplitEvent(szReEvent)
  self.nLock = 1
end

-- 获取最后一行所在行数和列数
function Tutorial:GetLastRowInfo()
  local nBagSize = self:GetBagCount()
  local nBagHeight = math.floor(nBagSize / Item.ROOM_INTEGRATIONBAG_WIDTH)
  local nBagRemain = math.mod(nBagSize, Item.ROOM_INTEGRATIONBAG_WIDTH)
  if nBagRemain > 0 then
    return nBagHeight + 1, nBagRemain
  end
  return nBagHeight, 0
end

-- 获取玩家的背包总格子数
function Tutorial:GetBagCount()
  local nBagSize = Item.ROOM_MAINBAG_WIDTH * Item.ROOM_MAINBAG_HEIGHT
  for i = 0, 2 do
    local pExtBag = me.GetExtBag(i)
    if pExtBag then
      local nType = pExtBag.nDetail
      local nExtSize = Ui.tbNewBag:GetExtBagSize(nType)
      nBagSize = nBagSize + nExtSize
    end
  end
  return nBagSize
end

function Tutorial:ProcessNewGiftEx()
  if UiVersion == Ui.Version001 then
    return 0
  end

  local tbItem = { 18, 1, 1509, 1 }
  local tbPos = me.FindItemInBags(unpack(tbItem))

  if not tbPos or not tbPos[1] then
    return
  end

  local pItem = nil

  local nRoom, nX, nY = Ui.tbNewBag:GetMapingRoomPosByTrue(tbPos[1].nRoom, tbPos[1].nX, tbPos[1].nY)
  if not nRoom then
    return
  end

  pItem = tbPos[1].pItem

  if not pItem then
    return
  end

  if pItem.GetGenInfo(1) > me.nLevel then
    return 0
  end

  local szWnd = self:GetBoxPosInfo(nRoom)
  self:ShowPopTips("UI_ITEMBOX", szWnd, "打开升级礼包获取丰厚礼物", 2, 10 * 18, (nX + 1) * 36 + 18, nY * 36 + 18)
  local nHeight, nBagRemain = self:GetLastRowInfo()

  local szObj = "ObjExtBagCell" .. (nRoom - 32)
  if nRoom - 33 + 1 == nHeight and nBagRemain > 0 then
    szObj = "ObjExtBagLastRow" .. nBagRemain
  end

  ObjGrid_SetTransparency("UI_ITEMBOX", szObj, "\\image\\icon\\other\\autoskill.spr", nX, nY)
end

function Tutorial:ShowItem(tbParam)
  local nType1, nType2 = self:SplitType(tbParam[1])
  local tbItem = self:SplitTable(tbParam[2])
  local szMsg = tbParam[3]
  local nTime = tonumber(tbParam[4]) or 0
  local szCloseEvent = tbParam[5]
  local szReEvent = tbParam[6]
  if not tbItem or nTime <= 0 or nType1 < 0 or nType2 < 0 then
    return
  end
  self:OpenWdow(Ui.UI_ITEMBOX)
  local tbPos = me.FindItemInBags(unpack(tbItem))
  local nRoom, nX, nY = Ui.tbNewBag:GetMapingRoomPosByTrue(tbPos[1].nRoom, tbPos[1].nX, tbPos[1].nY)
  if not nRoom then
    return
  end
  local szWnd = self:GetBoxPosInfo(nRoom)
  self:ShowPopTips("UI_ITEMBOX", szWnd, szMsg, nType1, nTime, (nX + 1) * 36 + 18, nY * 36 + 18)
  local _, _, nX1, nY1 = self:GetWndPos("UI_ITEMBOX", szWnd)
  self:ShowWindowEx(nType2, nX1 + nX * 36, nY1 + nY * 36, 36, 36)
  self.tbActionWnd = { "UI_ITEMBOX", szWnd }
  self.tbFinishAction["GetObj"] = { "UI_ITEMBOX", szWnd, nX, nY }
  self.tbCloseAction = self:SplitEvent(szCloseEvent)
  self.tbReAction = self:SplitEvent(szReEvent)
  self.nLock = 1
end

function Tutorial:ShowDialog(tbParam)
  local nType1, nType2 = self:SplitType(tbParam[1])
  local szAnswer = tbParam[2]
  local szMsg = tbParam[3]
  local nTime = tonumber(tbParam[4]) or 0
  local szCloseEvent = tbParam[5]
  local szReEvent = tbParam[6]
  if not szAnswer or nTime <= 0 or nType1 < 0 or nType2 < 0 then
    return
  end
  if UiManager:WindowVisible("UI_SAYPANEL") ~= 1 then
    return
  end
  local _, _, nX, nY = self:GetWndPos("UI_SAYPANEL", "LstSelectArray")
  local nWidth, nHeight = Wnd_GetSize("UI_SAYPANEL", "LstSelectArray")
  local nHeightEx1 = self:GetDialog(szAnswer)
  local nHeightEx2 = nHeightEx1 * 24
  if nHeightEx2 <= 0 or nHeightEx1 > 10 then
    return
  end
  self:ShowPopTips("UI_SAYPANEL", "LstSelectArray", szMsg, nType1, nTime, nWidth / 2, nHeightEx2 - 12)
  self:ShowWindowEx(nType2, nX + math.floor(nWidth * 3 / 4), nY + nHeightEx2 - 12)
  self.tbActionWnd = { "UI_SAYPANEL", "LstSelectArray" }
  self.tbFinishAction["DialogClick"] = { nHeightEx1 }
  self.tbCloseAction = self:SplitEvent(szCloseEvent)
  self.tbReAction = self:SplitEvent(szReEvent)
  self.nLock = 1
end

function Tutorial:GetDialog(szAnswer)
  for i = 1, #Ui(Ui.UI_SAYPANEL).tbNowInfo[2] do
    local szTemp, tbTemp = self:GetListContent(Ui(Ui.UI_SAYPANEL).tbNowInfo[2][i])
    if szTemp == szAnswer then
      return i
    end
  end
  return 0
end

function Tutorial:GetListContent(szOpt)
  local szTemp = ""
  local szTips = ""
  local tbTemp = {}
  local nItemBegin, nItemEnd = string.find(szOpt, "<item=([^>]*)>")
  local nTipBegin, nTipEnd = string.find(szOpt, "<tip=([^>]*)>")
  if not nItemBegin and not nTipBegin then
    szTemp = szOpt
  else
    szTemp = string.sub(szOpt, 1, math.min(nItemBegin or #szOpt, nTipBegin or #szOpt) - 1)
    szTips = string.sub(szOpt, math.min(nItemBegin or #szOpt, nTipBegin or #szOpt), math.min(nItemEnd or #szOpt, nTipEnd or #szOpt))
    tbTemp = self:GetTipParam(szTips)
  end
  return szTemp, tbTemp
end

function Tutorial:ShowTaskList(tbParam)
  local nType1, nType2 = self:SplitType(tbParam[1])
  local szLink = tbParam[2]
  local szAction = tbParam[3]
  local szMsg = tbParam[4]
  local nTime = tonumber(tbParam[5]) or 0
  local szCloseEvent = tbParam[6]
  if not szLink or nTime <= 0 or nType1 < 0 or nType2 < 0 then
    return
  end
  self:OpenWdow(Ui.UI_TASKTRACK)
  local nHeight = GetLinkPanelTextHight("UI_TASKTRACK", "TxtMsg", szLink)
  if nHeight <= 0 then
    self:CloseEvent()
    return
  end
  local nX1, nY1, nX, nY = self:GetWndPos("UI_TASKTRACK", "TxtMsg")
  self:ShowWindowEx(nType2, nX - 36, nY + nHeight)
  self:ShowPopTips("UI_TASKTRACK", "TxtMsg", szMsg, nType1, nTime, 0, nHeight)
  self.tbActionWnd = { "UI_TASKTRACK", "TxtMsg" }
  self.tbFinishAction["TaskLinkClick"] = { szAction }
  self.tbCloseAction = self:SplitEvent(szCloseEvent)
  self.tbCloseAction["RefreshLinkClick"] = { 1 }
  self.tbReAction["RefreshLinkClick"] = { 1 }
end

function Tutorial:GetBoxPosInfo(nRoom)
  local nTureRoom = nRoom - 32
  local nBagSize = self:GetBagCount()
  local nRow = math.floor(nBagSize / Item.ROOM_INTEGRATIONBAG_WIDTH)
  local nBagRemain = math.fmod(nBagSize, Item.ROOM_INTEGRATIONBAG_WIDTH)
  if nTureRoom ~= nRow + 1 or nBagRemain == 0 then
    return "ObjExtBagCell" .. nTureRoom
  else
    return "ObjExtBagLastRow" .. nBagRemain
  end
end

--打开背包
function Tutorial:OpenWdow(szUiGroup)
  if UiManager:WindowVisible(szUiGroup) ~= 1 then
    UiManager:OpenWindow(szUiGroup)
  end
end

-- 外加一层覆盖，用以保存记录poptips
function Tutorial:ShowPopTips(szWndGroup, szControl, szCustomTip, nArrow, nTimer, nX, nY)
  assert(szWndGroup and szCustomTip)
  if not self.tbPopRec[szWndGroup] then
    self.tbPopRec[szWndGroup] = {}
    self.tbPopRec[szWndGroup][szControl] = 1
  else
    self.tbPopRec[szWndGroup][szControl] = 1
  end
  return Ui.tbLogic.tbPopMgr:ShowWndPopTip(szWndGroup, szControl, szCustomTip, nArrow, nTimer, nX, nY)
end

--把szItem转化为tbItem
function Tutorial:SplitTable(szTable)
  local tbType = Lib:SplitStr(szTable)
  local tb = {}
  for i, nInfo in ipairs(tbType) do
    table.insert(tb, tonumber(nInfo) or 0)
  end
  return tb
end

function Tutorial:SplitType(szType)
  local tbType = Lib:SplitStr(szType, "|")
  return tonumber(tbType[1]) or -1, tonumber(tbType[2]) or -1
end

function Tutorial:SplitEvent(szEvent)
  local tbType = Lib:SplitStr(szEvent, "|")
  local tbEvent = {}
  for _, sz in ipairs(tbType) do
    local tb = Lib:SplitStr(sz)
    if tb[1] then
      tbEvent[tb[1]] = {}
      for i, tbEx in ipairs(tb) do
        if i > 1 then
          table.insert(tbEvent[tb[1]], tbEx)
        end
      end
    end
  end
  return tbEvent
end

--获得控件位置
function Tutorial:GetWndPos(szUiGroup, szWnd)
  return Wnd_GetPos(szUiGroup, szWnd)
end

--有任务id要求的dialog
function Tutorial:CanTutorialDialog(szTemp)
  local tbEvent = Tutorial.tbDialogAuto[szTemp]
  if not tbEvent or not tbEvent[3] or tbEvent[3] <= 0 or not tbEvent[4] or tbEvent[4] <= 0 or not tbEvent[5] or tbEvent[5] <= 0 then
    return 1
  end
  local tbPlayerTask = Task:GetPlayerTask(me)
  if not tbPlayerTask then
    return 0
  end
  for nTaskId, tb in pairs(tbPlayerTask.tbTasks or {}) do
    if tbEvent[3] == nTaskId and tb.nSubTaskId == tbEvent[4] and tb.nCurStep == tbEvent[5] then
      return 1
    end
  end
  return 0
end

--自动触发对话指引
function Tutorial:AutoDialogTutorial(szTemp, nFlag)
  if not nFlag then
    Timer:Register(9, self.AutoDialogTutorial, self, szTemp, 1)
    return
  end
  local tbEvent = self.tbDialogAuto[szTemp]
  if self:CanTutorialDialog(szTemp) == 0 then
    return 0
  end
  self:StarEvent(tbEvent[1], 0)
  return 0
end

--自动触发任务指引
function Tutorial:AutoTaskTutorial(szTemp, nFlag)
  if szTemp == self.szTaskListTutorial then
    return 0
  end
  if not nFlag then
    Timer:Register(9, self.AutoTaskTutorial, self, szTemp, 1)
    return 0
  end
  local tbEvent = Tutorial.tbTaskListAuto[szTemp]
  self:StarEvent(tbEvent[1], 0)
  self.szTaskListTutorial = szTemp
  return 0
end

------------------------------------------------------------------
--specialevent新手指引特殊处理
Tutorial.tbSpecialEvent = {
  ["ItemGift"] = "DoItemGift",
  ["gutaward"] = "DoGutaward",
  ["shop"] = "DoShop",
  ["shopbuy"] = "DoShopBuy",
  ["schooldemo"] = "DoSchoolDemo",
  ["equipenhance"] = "DoEquipEnhance",
  ["FightSkill"] = "DoFightSkill",
}

function Tutorial:CheckSepcialEvent(szType, tbParam)
  local fnFunc = self.tbSpecialEvent[szType]
  fnFunc = Tutorial[fnFunc]
  if type(fnFunc) == "function" then
    fnFunc(Tutorial, tbParam)
  end
end

--交鲜花触发指引
function Tutorial:DoItemGift(tbParam)
  if tbParam[1] == "把1个一束鲜花交给大老白" and self:CheckTaskStep(480, 676, 5) == 1 then
    self:DoEvent(108)
  end
end

--新手任务触发领取和接任务指引
function Tutorial:DoGutaward(tbParam)
  if tbParam[1] == 480 or tbParam[1] == 526 or tbParam[1] == 527 or tbParam[1] == 528 then
    if tbParam[2] == 0 then
      self:DoEvent(2)
    else
      self:DoEvent(1)
    end
  end
end

--购买药触发指引(不同与一般指引)
function Tutorial:DoShop(tbParam)
  if self:CheckTaskStep(480, 676, 7) == 0 and self:CheckTaskStep(480, 677, 1) == 0 then
    return
  end

  for i, tbGood in ipairs(tbParam[1]) do
    local tbGoods = me.GetShopBuyItemInfo(tbGood.nId)
    --金创药
    if tbGoods.nGenre == 17 and tbGoods.nDetail == 1 and tbGoods.nParticular == 1 and tbGoods.nLevel == 1 and self:CheckTaskStep(480, 676, 7) == 1 then
      self:DoEvent(110)
      break
    end
    --素竹炒肉
    if tbGoods.nGenre == 19 and tbGoods.nDetail == 3 and tbGoods.nParticular == 1 and tbGoods.nLevel == 1 and self:CheckTaskStep(480, 677, 1) == 1 then
      self:DoEvent(113)
      break
    end
  end
end

--购买药触发指引
function Tutorial:DoShopBuy(tbParam)
  if tbParam[1] == "金创药（小）" and self:CheckTaskStep(480, 676, 7) == 1 then
    self:DoEvent(111)
  end
  if tbParam[1] == "素炒竹肉" and self:CheckTaskStep(480, 677, 1) == 1 then
    self:DoEvent(114)
  end
end

function Tutorial:DoSchoolDemo()
  self:DoEvent(127)
end

--强化步骤时打开强化界面开启指引
function Tutorial:DoEquipEnhance()
  if self:CheckTaskStep(480, 685, 5) == 1 then
    self:DoEvent(132)
  end
end

--新强化步骤时打开强化界面开启指引
function Tutorial:DoNewEquipEnhance()
  if self:CheckTaskStep(538, 756, 3) == 1 then
    self:DoEvent(250)
  end
end

function Tutorial:DoEvent(nEventId, nFlag)
  if self:GetState() > 0 then
    return
  end
  if not nFlag then
    Timer:Register(9, self.DoEvent, self, nEventId, 1)
    return
  end
  self:StarEvent(nEventId, 0)
  return 0
end

--检查是否有任务步骤
function Tutorial:CheckTaskStep(nTaskId, nSubId, nStep)
  local tbPlayerTask = Task:GetPlayerTask(me)
  if not tbPlayerTask or not tbPlayerTask.tbTasks or not tbPlayerTask.tbTasks[nTaskId] then
    return 0
  end
  if nSubId and tbPlayerTask.tbTasks[nTaskId].nReferId ~= nSubId then
    return 0
  end
  if nStep and tbPlayerTask.tbTasks[nTaskId].nCurStep ~= nStep then
    return 0
  end
  return 1
end

function Tutorial:DoFightSkill()
  if self:CheckTaskStep(480, 682, 4) == 1 or self:CheckTaskStep(526, 741, 5) == 1 then
    self:DoEvent(133)
  end
end

function Tutorial:OnLevelUp(nFlag)
  if not nFlag then
    local nTimerFlag = 0
    if me.nLevel >= 60 then
      Img_PlayAnimation("UI_SIDEBAR", "BtnPlayer", 1, Env.GAME_FPS * 30, 0, 1)
      self:ShowPopTips("UI_SIDEBAR", "BtnPlayer", "恭喜你升级了，增加了新的潜能点", 1, 360)
      nTimerFlag = 1
    end
    if me.nFaction > 0 then
      Img_PlayAnimation("UI_SIDEBAR", "BtnSkill", 1, Env.GAME_FPS * 30, 0, 1)
      self:ShowPopTips("UI_SIDEBAR", "BtnSkill", "恭喜你升级了，增加了新的技能点", 3, 360)
      nTimerFlag = 1
    end
    local tb = { 10, 15, 20, 25, 30, 40, 50, 60, 70, 80, 90 }

    for _, nLevel in ipairs(tb) do
      if me.nLevel == nLevel then
        Img_PlayAnimation("UI_SIDEBAR", "BtnItemBox", 1, Env.GAME_FPS * 30, 0, 1)
        self:ShowPopTips("UI_SIDEBAR", "BtnItemBox", string.format("恭喜升级到<color=yellow>%s<color>级，打开升级礼包获取精美礼品。", me.nLevel), 3, 360, 0, 14)
        nTimerFlag = 1
      end
    end

    local nDet = math.fmod(me.nLevel, 5)
    if me.nLevel >= 25 and me.nLevel <= 60 and nDet == 0 then
      Img_PlayAnimation("UI_SIDESYSBAR", "BtnMenology", 1, Env.GAME_FPS * 30, 0, 1)
      self:ShowPopTips("UI_SIDESYSBAR", "BtnMenology", string.format("你能参加更多活动了！海量奖励等你拿！", me.nLevel), 2, 360, 30, 0)
      nTimerFlag = 1
    end

    if nTimerFlag == 1 then
      Timer:Register(360, self.OnLevelUp, self, 1)
    end
    return
  end
  Img_PlayAnimation("UI_SIDEBAR", "BtnSkill", 0)
  Img_PlayAnimation("UI_SIDEBAR", "BtnItemBox", 0)
  Img_PlayAnimation("UI_SIDEBAR", "BtnPlayer", 0)
  Img_PlayAnimation("UI_SIDESYSBAR", "BtnMenology", 0)
  return 0
end

function Tutorial:OnGetItem(nFlag)
  if not nFlag then
    Img_PlayAnimation("UI_SIDEBAR", "BtnItemBox", 1, Env.GAME_FPS * 30, 0, 1)
    self:ShowPopTips("UI_SIDEBAR", "BtnItemBox", "恭喜您获得<color=yellow>精美礼物<color>，赶紧打开查看礼物。", 3, 360, 0, 14)
    Timer:Register(360, self.OnGetItem, self, 1)
    return
  end
  Img_PlayAnimation("UI_SIDEBAR", "BtnItemBox", 0)
  return 0
end

function Tutorial:OnGetItem_Cai(nFlag)
  if not nFlag then
    Img_PlayAnimation("UI_SIDEBAR", "BtnItemBox", 1, Env.GAME_FPS * 30, 0, 1)
    self:ShowPopTips("UI_SIDEBAR", "BtnItemBox", "食用背包中的<color=yellow>素炒竹肉<color>可快速<color=yellow>回血回内<color>。", 3, 360, 0, 14)
    Timer:Register(360, self.OnGetItem, self, 1)
    return
  end
  Img_PlayAnimation("UI_SIDEBAR", "BtnItemBox", 0)
  return 0
end

function Tutorial:KeyTutorial(nType, nX, nY, szMsg, tb, nArrow)
  UiManager:CloseWindow(Ui.UI_KEYTUTORIAL)
  if self.tbKeyPop then
    Wnd_CancelPopTip(self.tbKeyPop[1], self.tbKeyPop[2])
  end

  if not nArrow then
    nArrow = 4
  end

  UiManager:OpenWindow(Ui.UI_KEYTUTORIAL, nType)
  UiManager:MoveWindow(Ui.UI_KEYTUTORIAL, nX, nY)
  self:ShowPopTips("UI_KEYTUTORIAL", "ImgGrid" .. nType, szMsg, nArrow, 144, tb[1], tb[2])
  self.tbKeyPop = { "UI_KEYTUTORIAL", "ImgGrid" .. nType }
  return 0
end

--配对出现的键位说明，根据tutorial_tasklist.txt中的两个id匹配，表示同时出现指引的同时出现键位说明
--nId*10+nSubId（理论不会出现大于10步的指引）
Tutorial.tbKeyTutorial = {
  [1000] = {
    1,
    { { 350, 50 }, { 450, 150 }, { 600, 150 }, { 600, 150 } },
    "点击<color=yellow>F<color>按钮可以打开或者关闭<color=green>自动战斗<color>",
    { 60, 60 },
  },
  [271] = {
    2,
    { { 350, 50 }, { 450, 150 }, { 600, 150 }, { 600, 150 } },
    "点击<color=yellow>F1<color>按钮可以打开或者关闭<color=green>角色属性面板<color>",
    { 60, 60 },
  },
  [201] = {
    3,
    { { 350, 50 }, { 450, 150 }, { 600, 150 }, { 600, 150 } },
    "点击<color=yellow>F2<color>按钮可以打开或者关闭<color=green>背包面板<color>",
    { 60, 60 },
  },
  [431] = {
    4,
    { { 350, 50 }, { 450, 150 }, { 600, 150 }, { 600, 150 } },
    "点击<color=yellow>F3<color>按钮可以打开或者关闭<color=green>技能面板<color>",
    { 60, 60 },
  },
  [41] = {
    5,
    { { 350, 50 }, { 450, 150 }, { 600, 150 }, { 600, 150 } },
    "点击<color=yellow>F4<color>按钮可以打开或者关闭<color=green>任务面板<color>",
    {
      60,
      60,
    },
  },
  [291] = {
    6,
    { { 250, 50 }, { 400, 150 }, { 550, 150 }, { 550, 150 } },
    "点击<color=yellow>空格键<color>可以<color=green>拾取地上掉落的物品<color>",
    {
      200,
      50,
    },
  },
  [51] = {
    7,
    { { 350, 50 }, { 450, 150 }, { 600, 150 }, { 600, 150 } },
    "点击<color=yellow>Tab<color>按钮可以打开或者关闭<color=green>地图面板<color>",
    { 100, 60 },
  },
  [1292] = {
    4,
    { { 350, 50 }, { 450, 150 }, { 600, 150 }, { 600, 150 } },
    "点击<color=yellow>F3<color>按钮可以打开或者关闭<color=green>技能面板<color>",
    { 60, 60 },
  },
  [8] = { 8, { { 350, 50 }, { 450, 150 }, { 600, 150 }, { 600, 150 } }, "点击鼠标左键可以释放技能或者进行其他操作", { 44, 78 } },
  [9] = { 9, { { 350, 50 }, { 450, 150 }, { 600, 150 }, { 600, 150 } }, "点击鼠标右键可以释放技能", { 44, 78 } },
  [1671] = {
    5,
    { { 350, 50 }, { 450, 150 }, { 600, 150 }, { 600, 150 } },
    "点击<color=yellow>F4<color>按钮可以打开或者关闭<color=green>任务面板<color>",
    { 60, 60 },
  },
  [1681] = {
    3,
    { { 350, 50 }, { 450, 150 }, { 600, 150 }, { 600, 150 } },
    "点击<color=yellow>F2<color>按钮可以打开或者关闭<color=green>背包面板<color>",
    { 60, 60 },
  },
  [1701] = {
    2,
    { { 350, 50 }, { 450, 150 }, { 600, 150 }, { 600, 150 } },
    "点击<color=yellow>F1<color>按钮可以打开或者关闭<color=green>角色属性面板<color>",
    { 60, 60 },
  },
  [1871] = {
    6,
    { { 250, 50 }, { 400, 150 }, { 550, 150 }, { 550, 150 } },
    "点击<color=yellow>空格键<color>可以<color=green>拾取地上掉落的物品<color>",
    { 200, 50 },
  },
  [1741] = {
    7,
    { { 350, 50 }, { 450, 150 }, { 600, 150 }, { 600, 150 } },
    "点击<color=yellow>Tab<color>按钮可以打开或者关闭<color=green>地图面板<color>",
    { 100, 60 },
  },
  [2141] = {
    10,
    { { 350, 50 }, { 450, 150 }, { 600, 150 }, { 600, 150 } },
    "点击<color=yellow>M<color>按钮可以<color=green>上下马<color>",
    { 60, 60 },
  },
  --[1871] = {8, {{350,50},{450,150},{600,150},{600,150}}, "点击鼠标左键可以释放技能或者进行其他操作", {44,78}},
  [2482] = {
    4,
    { { 350, 50 }, { 450, 150 }, { 600, 150 }, { 600, 150 } },
    "点击<color=yellow>F3<color>按钮可以打开或者关闭<color=green>技能面板<color>",
    { 60, 60 },
  },
  [10000] = {
    9,
    { { 450, 400 }, { 540, 600 }, { 620, 420 }, { 620, 420 } },
    "在野外点击<color=yellow>鼠标右键<color>可以使用<color=yellow>轻功跳跃<color>",
    { 35, 40 },
  }, -- 技能指引
  [10001] = {
    8,
    { { 450, 360 }, { 540, 600 }, { 620, 420 }, { 620, 420 } },
    "在野外点击<color=yellow>鼠标左键<color>可以释放<color=yellow>技能<color>",
    {
      25,
      40,
    },
  }, -- 技能指引
}

--任务步骤触发按键指引
function Tutorial:AutoKeyTutorial()
  local nType = self.nTaskId * 10 + self.nSubId
  if self.nKeyType == nType and self.nKeyType ~= 0 then
    return
  end
  if self.tbKeyTutorial[nType] then
    local nX, nY = 0, 0
    if Ui.szMode == "a" then
      nX, nY = unpack(self.tbKeyTutorial[nType][2][1])
    elseif Ui.szMode == "b" then
      nX, nY = unpack(self.tbKeyTutorial[nType][2][2])
    elseif Ui.szMode == "c" then
      nX, nY = unpack(self.tbKeyTutorial[nType][2][3])
    elseif Ui.szMode == "d" then
      nX, nY = unpack(self.tbKeyTutorial[nType][2][4])
    end
    self:KeyTutorial(self.tbKeyTutorial[nType][1], nX, nY, self.tbKeyTutorial[nType][3], self.tbKeyTutorial[nType][4])
    self.nKeyType = nType
  end
end

--自动战斗开启提示
function Tutorial:AutoFightkey()
  if self:GetState() > 0 then
    return
  end
  if me.nLevel <= 20 and me.GetSkillState(476) <= 0 and #me.FindItemInBags(19, 3, 1, 1) > 0 then
    self:OnGetItem_Cai() --20级下自动战斗时没有药的状态并且包里面有菜的时候都默认提示
  end
  if me.nLevel > 20 or me.GetTask(self.nGroupId, self.nAutoFight) >= 3 then
    return
  end
  if self.tbKeyTutorial[1000] then
    local nX, nY = 0, 0
    if Ui.szMode == "a" then
      nX, nY = unpack(self.tbKeyTutorial[1000][2][1])
    elseif Ui.szMode == "b" then
      nX, nY = unpack(self.tbKeyTutorial[1000][2][2])
    elseif Ui.szMode == "c" then
      nX, nY = unpack(self.tbKeyTutorial[1000][2][3])
    elseif Ui.szMode == "d" then
      nX, nY = unpack(self.tbKeyTutorial[1000][2][4])
    end
    self:KeyTutorial(self.tbKeyTutorial[1000][1], nX, nY, self.tbKeyTutorial[1000][3], self.tbKeyTutorial[1000][4])
    me.SetTask(self.nGroupId, self.nAutoFight, me.GetTask(self.nGroupId, self.nAutoFight) + 1)
  end
  self:OnGetItem_Cai() --每次自动战斗的时候提示吃菜，前三次
end

--自动战斗开启提示
function Tutorial:UseSkillTutorial(nType)
  if UiVersion == Ui.Version001 then
    return
  end

  if self:GetState() > 0 then
    return
  end

  if me.nLevel > 20 then
    return
  end

  if self.tbKeyTutorial[nType] then
    local nX, nY = 0, 0
    if Ui.szMode == "a" then
      nX, nY = unpack(self.tbKeyTutorial[nType][2][1])
    elseif Ui.szMode == "b" then
      nX, nY = unpack(self.tbKeyTutorial[nType][2][2])
    elseif Ui.szMode == "c" then
      nX, nY = unpack(self.tbKeyTutorial[nType][2][3])
    elseif Ui.szMode == "d" then
      nX, nY = unpack(self.tbKeyTutorial[nType][2][4])
    end
    self:KeyTutorial(self.tbKeyTutorial[nType][1], nX, nY, self.tbKeyTutorial[nType][3], self.tbKeyTutorial[nType][4])
  end
end

Tutorial.tbEquipType = {
  "ObjWeapon", -- 近程武器
  "ObjWeapon", -- 远程武器
  "ObjBody", -- 衣服
  "ObjRing", -- 戒指
  "ObjNecklace", -- 项链
  "ObjAmulet", -- 护身符
  "ObjFoot", -- 鞋子
  "ObjBelt", -- 腰带
  "ObjHead", -- 头盔
  "ObjCuff", -- 护腕
  "ObjPendant", -- 腰坠
  "ObjHorse", -- 马匹
  "ObjMask",
  "ObjBook", -- 秘籍
}

--自动装备后打开F1界面显示装备换掉了
function Tutorial:AutoEquip(nType, nFlag)
  if self:GetState() > 0 then
    return
  end
  local szWnd = self.tbEquipType[nType]
  if not szWnd or me.nLevel > 20 then
    return 0
  end
  if not nFlag then
    self:OpenWdow(Ui.UI_PLAYERPANEL)
    self:ShowPopTips(Ui.UI_PLAYERPANEL, szWnd, "恭喜您成功穿上了最新的装备", 4, 180)
    Timer:Register(9, self.AutoEquip, self, nType, 1)
    return
  end
  ObjGrid_SetTransparency("UI_PLAYERPANEL", szWnd, "\\image\\icon\\other\\autoskill.spr", 0, 0)
  return 0
end

Tutorial.tbCaiList = {
  [1] = { 1, { 19, 3, 1, 1 }, 139 },
  [2] = { 30, { 19, 3, 1, 2 }, 140 },
  [3] = { 50, { 19, 3, 1, 3 }, 141 },
  [4] = { 70, { 19, 3, 1, 4 }, 142 },
  [5] = { 90, { 19, 3, 1, 5 }, 143 },
}

Tutorial.nTime_ProcessPlayerTutorial = 2
Tutorial.nTime_ProcessPlayerTutorial_Cai = 60 * 20
Tutorial.nSkill_CaiBuf_Id = 476
Tutorial.nFreeDay = 3

function Tutorial:Login_OpenTimerProcessPlayerTutorial()
  if UiVersion == Ui.Version001 then
    return 0
  end

  if self:CheckFreeTeQuan() ~= 1 then
    return 0
  end
  if self.nTimer_ProcessPlayerTutorial and Timer:GetRestTime(self.nTimer_ProcessPlayerTutorial) > 0 then
    Timer:Close(self.nTimer_ProcessPlayerTutorial)
    self.nTimer_ProcessPlayerTutorial = 0
  end
  self.nTimer_ProcessPlayerTutorial = Timer:Register(18 * self.nTime_ProcessPlayerTutorial, self.Timer_PlayerProcessTutorialEvent, self)
end

function Tutorial:Timer_PlayerProcessTutorialEvent()
  if UiVersion == Ui.Version001 then
    return 0
  end

  if self:CheckFreeTeQuan() ~= 1 then
    self.nTimer_ProcessPlayerTutorial = 0
    return 0
  end

  if me.nLevel >= 50 then
    return 0
  end

  self:CloseShotLight()

  self:ProcessTeQuan_ChuWuXiang()
  self:ProcessTeQuan_Xuanjing()
  self:ProcessTeQuan_Cai()
  return
end

function Tutorial:CloseShotLight()
  local tbLeaveList = {}
  local tbHaveList = {}

  if #self.tbWaitCloseTransparencyList <= 0 then
    return 0
  end

  for i, tbInfo in pairs(self.tbWaitCloseTransparencyList) do
    tbInfo[2] = tbInfo[2] - self.nTime_ProcessPlayerTutorial
    if tbInfo[2] <= 0 then
      tbLeaveList[#tbLeaveList + 1] = tbInfo
    else
      tbHaveList[#tbHaveList + 1] = tbInfo
    end
  end
  for i, tbInfo in pairs(tbLeaveList) do
    ObjGrid_SetTransparency("UI_SHORTCUTBAR", "ObjShortcut", "  ", tbInfo[1], 0)
  end

  self.tbWaitCloseTransparencyList = tbHaveList
end

function Tutorial:ProcessTeQuan_Cai(nForce)
  local nNowTime = GetTime()
  local nCaiLastTime = me.GetTask(self.nGroupId, self.nTeQuan_CaiTime)
  if not nForce or nForce ~= 1 then
    if nNowTime - nCaiLastTime < self.nTime_ProcessPlayerTutorial_Cai then
      return 0
    end
  end

  local nPerLift = math.floor(me.nCurLife / me.nMaxLife * 100)
  local nSkillLevel = me.GetSkillState(self.nSkill_CaiBuf_Id)
  if nPerLift < 60 and nSkillLevel <= 0 then
    -- 先判断有没有菜
    -- 在判断快捷栏里有没有菜
    local nUseCai = 0
    local nLevel = me.nLevel
    for i, tbInfo in ipairs(self.tbCaiList) do
      if nLevel < tbInfo[1] then
        break
      end

      local tbPos = me.FindItemInBags(unpack(tbInfo[2]))
      if tbPos[1] then
        nUseCai = i
      end
    end

    if nUseCai > 0 then
      local tbCai = self.tbCaiList[nUseCai]
      local nHaveShotBar = -1
      local nFlags = me.GetTask(Item.TSKGID_SHORTCUTBAR, Item.TSKID_SHORTCUTBAR_FLAG)
      for nPos = 0, Item.SHORTCUTBAR_OBJ_MAX_SIZE - 1 do
        local nType = Lib:LoadBits(nFlags, nPos * 3, nPos * 3 + 2) -- 每个类型占3位
        if nType == Item.SHORTCUTBAR_TYPE_ITEM then
          local nLow = me.GetTask(Item.TSKGID_SHORTCUTBAR, nPos * 2 + 1)
          local nHigh = me.GetTask(Item.TSKGID_SHORTCUTBAR, (nPos + 1) * 2)
          local nGenre = Lib:LoadBits(nLow, 0, 15)
          local nDetail = Lib:LoadBits(nLow, 16, 31)
          local nParticular = Lib:LoadBits(nHigh, 0, 15)
          local nLevel = Lib:LoadBits(nHigh, 16, 23)
          if nGenre == tbCai[2][1] and nDetail == tbCai[2][2] and nParticular == tbCai[2][3] and nLevel == tbCai[2][4] then
            nHaveShotBar = nPos
            break
          end
        end
      end

      if nHaveShotBar >= 0 then
        self:ShowShot({ "2|1", nHaveShotBar + 1, "右键点击<color=yellow>吃菜<color>可持续恢复<color=yellow>血量和内力<color>", 20 * 18 })
        self.tbWaitCloseTransparencyList[#self.tbWaitCloseTransparencyList + 1] = { nHaveShotBar, 20 }
      else
        self:StarEvent(tbCai[3], 0)
      end
    else -- 没有菜
      local nCount = me.GetTask(2038, 11)
      if nCount < 5 then
        self:StarEvent(144, 0)
      else
        UiManager:OpenWindow(Ui.UI_INFOBOARD, "您今日可领取的练级菜已领完，快去<color=yellow>【酒楼老板】<color>处看看吧。")
      end
    end

    me.SetTask(self.nGroupId, self.nTeQuan_CaiTime, GetTime())
  end

  return 1
end

Tutorial.tbXuanjingList = {
  [1] = { 18, 1, 114, 1 },
  [2] = { 18, 1, 114, 2 },
  [3] = { 18, 1, 114, 3 },
  [4] = { 18, 1, 114, 4 },
  [5] = { 18, 1, 1, 1 },
  [6] = { 18, 1, 1, 2 },
  [7] = { 18, 1, 1, 3 },
  [8] = { 18, 1, 1, 4 },
}

function Tutorial:ProcessTeQuan_Xuanjing()
  if me.nFightState ~= 0 then
    return
  end

  local szMapType = GetMapType(me.nMapId)
  if szMapType == "village_mini" or szMapType == "village" or szMapType == "city" then
    return
  end

  local nLastTime = me.GetTask(self.nGroupId, self.nTeQuan_XuanJingTime)
  if GetTime() - nLastTime < self.nTime_ProcessPlayerTutorial_Cai * 3 then
    return
  end

  local nCanCombine = 0
  for i, tbInfo in pairs(self.tbXuanjingList) do
    local tbFind = me.FindItemInBags(unpack(tbInfo))
    if #tbFind >= 8 then
      nCanCombine = 1
      break
    end
  end

  if nCanCombine == 1 then
    Ui:ServerCall("UI_TASKTIPS", "Begin", "你可以使用玄晶特权将拥有的玄晶合成为更高等级的玄晶。")
    self:StarEvent(147, 0)
    me.SetTask(self.nGroupId, self.nTeQuan_XuanJingTime, GetTime())
  end
end

Tutorial.nTime_ProcessPlayerTutorial_ChuWuXiang = 60 * 3

function Tutorial:ProcessTeQuan_ChuWuXiang()
  if me.nFightState ~= 0 then
    return
  end

  local szMapType = GetMapType(me.nMapId)
  if szMapType == "village_mini" or szMapType == "village" or szMapType == "city" then
    return
  end

  if me.CountFreeBagCell() >= 2 then
    return
  end

  local nLastTime = me.GetTask(self.nGroupId, self.nTeQuan_ChuWuXiangTime)
  if GetTime() - nLastTime < self.nTime_ProcessPlayerTutorial_ChuWuXiang then
    return
  end

  Ui:ServerCall("UI_TASKTIPS", "Begin", "您的背包已经满了。")
  self:StarEvent(146, 0)

  me.SetTask(self.nGroupId, self.nTeQuan_ChuWuXiangTime, GetTime())
end

Tutorial.tbTaskToTutorial = {
  [2] = 151,
  [3] = 165,
  [5] = 154,
  [8] = 157,
  [11] = 160,
  [14] = 163,
}

function Tutorial:ProcessLifeSkillTutorial()
  local tbTasks = Task:GetPlayerTask(me)
  if not tbTasks then
    return
  end

  if not tbTasks.tbTasks then
    return
  end

  local tbTask = tbTasks.tbTasks[482]
  if not tbTask then
    return
  end

  local nCurStep = tbTask.nCurStep
  if not self.tbTaskToTutorial[nCurStep] then
    return
  end

  self:StarEvent(self.tbTaskToTutorial[nCurStep], 0)
end

function Tutorial:CheckFreeTeQuan()
  local nDate = me.GetTask(self.nGroupId, self.nCreateRoleTime)
  local nDisDate = math.floor((Lib:GetDate2Time(os.date("%Y%m%d", GetTime())) - Lib:GetDate2Time(nDate)) / 86400)
  if (self.nFreeDay - nDisDate) > 0 then
    return 1
  end
  return 0
end
