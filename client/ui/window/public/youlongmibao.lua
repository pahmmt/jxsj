-------------------------------------------------------
-- 文件名　：youlongmibao.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2009-11-06 11:52:59
-- 文件描述：
-------------------------------------------------------

local uiYoulongmibao = Ui:GetClass("youlongmibao")
local tbObject = Ui.tbLogic.tbObject
local tbTempItem = Ui.tbLogic.tbTempItem
local tbAwardInfo = Ui.tbLogic.tbAwardInfo

-- const
uiYoulongmibao.GRID_COUNT = 26

-- text
uiYoulongmibao.TXT_SHOWAWARD = "TxtShowAward"

-- button
uiYoulongmibao.BTN_GETAWARD = "BtnGetAward"
uiYoulongmibao.BTN_CONTINUE = "BtnContinue"
uiYoulongmibao.BTN_RESTART = "BtnRestart"
uiYoulongmibao.BTN_LEAVEHERE = "BtnLeaveHere"
uiYoulongmibao.BTN_CLOSE = "BtnClose"
uiYoulongmibao.BTN_CONFIRMAWARD = "BtnConfirmAward"
uiYoulongmibao.BTN_CHANGECOIN = "BtnChangeCoin"

-- 25 grid
uiYoulongmibao.IMG_GRID = {}
for i = 1, uiYoulongmibao.GRID_COUNT do
  uiYoulongmibao.IMG_GRID[i] = { "ImgGrid" .. i, "ObjGrid" .. i }
end

-- obj name to index
uiYoulongmibao.OBJ_INDEX = {}
for i = 1, uiYoulongmibao.GRID_COUNT do
  uiYoulongmibao.OBJ_INDEX["ObjGrid" .. i] = i
end

-- effect
uiYoulongmibao.IMG_EFFECT_SPR = {
  [0] = "",
  [3] = "\\image\\effect\\other\\new_cheng2.spr",
  [4] = "\\image\\effect\\other\\new_jin1.spr",
  [5] = "\\image\\effect\\other\\new_jin3.spr",
  [6] = "\\image\\effect\\other\\new_jin3.spr",
  [7] = "\\image\\effect\\other\\new_jin3.spr",
  [8] = "\\image\\effect\\other\\new_jin3.spr",
  [9] = "\\image\\effect\\other\\new_jin3.spr",
  [10] = "\\image\\effect\\other\\new_jin3.spr",
}
-------------------------------------------------------
-- beautiful line
-------------------------------------------------------

-- init
function uiYoulongmibao:Init()
  self.bOpen = 0
end

-- on create
function uiYoulongmibao:OnCreate()
  self.tbGridCont = {}
  for i, tbGrid in pairs(self.IMG_GRID) do
    self.tbGridCont[i] = tbObject:RegisterContainer(self.UIGROUP, tbGrid[2], 1, 1, nil, "award")
    self.tbGridCont[i].OnObjGridEnter = self.OnObjGridEnter
  end
end

-- on destroy
function uiYoulongmibao:OnDestroy()
  for _, tbCont in pairs(self.tbGridCont) do
    tbObject:UnregContainer(tbCont)
  end
end

-- on open
function uiYoulongmibao:OnOpen()
  self.bOpen = 1
end

-- on close
function uiYoulongmibao:OnClose()
  self:ClearGrid()
end

-- tips callback
function uiYoulongmibao:OnObjGridEnter(szWnd, nX, nY)
  local nIndex = self.OBJ_INDEX[szWnd]
  local tbObj = self.tbGridCont[nIndex]:GetObj(nX, nY)

  if not tbObj then
    return 0
  end

  local pItem = tbObj.pItem
  if not pItem then
    return 0
  end

  Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, pItem.GetCompareTip(Item.TIPS_NORMAL, tbObj.szBindType))
end

-- trigger click event
function uiYoulongmibao:OnButtonClick(szWnd, nParam)
  if self.BTN_CLOSE == szWnd then
    UiManager:CloseWindow(self.UIGROUP)
    return 0
  end

  -- show award
  if self.BTN_GETAWARD == szWnd then
    me.CallServerScript({ "ApplyYoulongmibaoShowAward" })

  -- get award
  elseif self.BTN_CONFIRMAWARD == szWnd then
    me.CallServerScript({ "ApplyYoulongmibaoGetAward", 1 })

  -- change coin
  elseif self.BTN_CHANGECOIN == szWnd then
    me.CallServerScript({ "ApplyYoulongmibaoGetAward", 2 })

  -- continue
  elseif self.BTN_CONTINUE == szWnd then
    local tbMsg = {}
    tbMsg.szMsg = "继续比武，是否确定？"
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex)
      if nOptIndex == 2 then
        me.CallServerScript({ "ApplyYoulongmibaoContinue" })
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)

  -- restart
  elseif self.BTN_RESTART == szWnd then
    local tbMsg = {}
    tbMsg.szMsg = "重新比武，次数将重新计算，是否确定？"
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex)
      if nOptIndex == 2 then
        me.CallServerScript({ "ApplyYoulongmibaoRestart" })
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)

  -- leave here
  elseif self.BTN_LEAVEHERE == szWnd then
    local tbMsg = {}
    tbMsg.szMsg = "离开密室，是否确定？"
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex)
      if nOptIndex == 2 then
        me.CallServerScript({ "ApplyYoulongmibaoLeaveHere" })
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
  end
end

-- receive server data
function uiYoulongmibao:OnGetResult(tbResult)
  if not tbResult then
    return
  end

  self.tbResult = tbResult
  self:ClearGrid()

  -- get award
  if tbResult.nStep == 1 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_GETAWARD, 1)
    Wnd_SetEnable(self.UIGROUP, self.BTN_CONTINUE, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_RESTART, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_LEAVEHERE, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_CONFIRMAWARD, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_CHANGECOIN, 0)

  -- continue
  elseif tbResult.nStep == 2 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_GETAWARD, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_CONTINUE, 1)
    Wnd_SetEnable(self.UIGROUP, self.BTN_RESTART, 1)
    Wnd_SetEnable(self.UIGROUP, self.BTN_LEAVEHERE, 1)
    Wnd_SetEnable(self.UIGROUP, self.BTN_CONFIRMAWARD, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_CHANGECOIN, 0)

  -- times over four
  elseif tbResult.nStep == 3 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_GETAWARD, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_CONTINUE, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_RESTART, 1)
    Wnd_SetEnable(self.UIGROUP, self.BTN_LEAVEHERE, 1)
    Wnd_SetEnable(self.UIGROUP, self.BTN_CONFIRMAWARD, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_CHANGECOIN, 0)
  end

  for i, tbItem in pairs(tbResult) do
    if type(tbItem) == "table" then
      local tbItemId = Lib:SplitStr(tbItem.Id, ",")
      local tbObj = self:CreateTempItem(tonumber(tbItemId[1]), tonumber(tbItemId[2]), tonumber(tbItemId[3]), tonumber(tbItemId[4]), tonumber(tbItem.BindType) or 0)
      if tbObj then
        self.tbGridCont[i]:SetObj(tbObj)
        if self.IMG_EFFECT_SPR[tonumber(tbItem.Level)] then
          ObjGrid_SetTransparency(self.UIGROUP, self.IMG_GRID[i][2], self.IMG_EFFECT_SPR[tonumber(tbItem.Level)], 0, 0)
        end
        Wnd_Show(self.UIGROUP, self.IMG_GRID[i][2])
      end
    end
  end
end

function uiYoulongmibao:OnShowAward(tbItem)
  if not tbItem then
    return
  end
  local tbItemId = Lib:SplitStr(tbItem.Id, ",")
  local tbObj = self:CreateTempItem(tonumber(tbItemId[1]), tonumber(tbItemId[2]), tonumber(tbItemId[3]), tonumber(tbItemId[4]), tonumber(tbItem.BindType) or 0)
  if tbObj then
    self.tbGridCont[26]:SetObj(tbObj)
    if self.IMG_EFFECT_SPR[tonumber(tbItem.Level)] then
      ObjGrid_SetTransparency(self.UIGROUP, self.IMG_GRID[26][2], self.IMG_EFFECT_SPR[tonumber(tbItem.Level)], 0, 0)
    end
    Wnd_Show(self.UIGROUP, self.IMG_GRID[26][2])
  end

  Wnd_SetEnable(self.UIGROUP, self.BTN_GETAWARD, 0)
  Wnd_SetEnable(self.UIGROUP, self.BTN_CONTINUE, 0)
  Wnd_SetEnable(self.UIGROUP, self.BTN_RESTART, 0)
  Wnd_SetEnable(self.UIGROUP, self.BTN_LEAVEHERE, 0)
  Wnd_SetEnable(self.UIGROUP, self.BTN_CONFIRMAWARD, 1)
  Wnd_SetEnable(self.UIGROUP, self.BTN_CHANGECOIN, 1)

  local szTxt = string.format("不错，你获得了<color=224,181,100>%s<color>的奖励，可以换取<color=224,181,100>%s<color>枚游龙古币，你是要领奖还是换取游龙古币？", tbItem.Name, tbItem.ChangeCoin)
  if UiVersion == Ui.Version001 then
    szTxt = string.format("不错，你获得了<color=yellow>%s<color>的奖励，可以换取<color=yellow>%s<color>枚游龙古币，你是要领奖还是换取游龙古币？", tbItem.Name, tbItem.ChangeCoin)
  end

  Txt_SetTxt(self.UIGROUP, self.TXT_SHOWAWARD, szTxt)
end

-- clear all grid obj
function uiYoulongmibao:ClearGrid()
  for i = 1, self.GRID_COUNT do
    local tbObj = self.tbGridCont[i]:GetObj()
    tbAwardInfo:DelAwardInfoObj(tbObj)
    self.tbGridCont[i]:SetObj(nil)
    Wnd_Hide(self.UIGROUP, self.IMG_GRID[i][2])
  end
end

-- create temp item
function uiYoulongmibao:CreateTempItem(nGenre, nDetail, nParticular, nLevel, nBind)
  local pItem = tbTempItem:Create(nGenre, nDetail, nParticular, nLevel, -1)
  if not pItem then
    return
  end

  local tbObj = {}
  tbObj.nType = Ui.OBJ_TEMPITEM
  tbObj.pItem = pItem
  tbObj.nCount = 1

  if nBind == 1 then
    tbObj.szBindType = "获取绑定"
  end

  return tbObj
end

-- register event
function uiYoulongmibao:RegisterEvent()
  local tbRegEvent = {}
  for i, tbWnd in ipairs(self.IMG_GRID) do
    tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbGridCont[i]:RegisterEvent())
  end
  return tbRegEvent
end

-- register message
function uiYoulongmibao:RegisterMessage()
  local tbRegMsg = {}
  for i, tbWnd in ipairs(self.IMG_GRID) do
    tbRegMsg = Lib:MergeTable(tbRegMsg, self.tbGridCont[i]:RegisterEvent())
  end
  return tbRegMsg
end
