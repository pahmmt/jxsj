local tbPreView = Ui:GetClass("preview")
local tbObject = Ui.tbLogic.tbObject
local tbPreViewMgr = Ui.tbLogic.tbPreViewMgr

local OBJ_EQUIP_PREVIEW = "ObjPreview"
local BTN_CLOSE = "BtnClose"
local BTN_RESET = "BtnReset"
local BTN_LEFT = "BtnLeft"
local BTN_RIGHT = "BtnRight"
local TXT_NAME = "TxtName"
local MAXDIRVIEW = 7

function tbPreView:Init()
  self.nDirView = 0
end

-- 创建期，创建OBJ容器
function tbPreView:OnCreate()
  self.tbObjPreView = {}
  self.tbObjPreView = tbObject:RegisterContainer(self.UIGROUP, OBJ_EQUIP_PREVIEW)
end

function tbPreView:OnDestroy()
  tbObject:UnregContainer(self.tbObjPreView)
end

function tbPreView:OnOpen()
  self.nDirView = 0
  Txt_SetTxt(self.UIGROUP, TXT_NAME, me.szName)
end

function tbPreView:OnClose()
  tbPreViewMgr:Clear()
end

function tbPreView:SetPreViewItem(pItem) end

function tbPreView:OnButtonClick(szWnd, nParam)
  if BTN_CLOSE == szWnd then
    UiManager:CloseWindow(self.UIGROUP)
  elseif BTN_RESET == szWnd then
    tbPreViewMgr:ResetPreViewPart()
    tbPreViewMgr:Clear()
    self.nDirView = 0
  elseif BTN_LEFT == szWnd then
    self:ChangeView(-1)
  elseif BTN_RIGHT == szWnd then
    self:ChangeView(1)
  end
end

function tbPreView:ChangeView(nChange)
  if nChange == -1 then
    self.nDirView = self.nDirView - 1
  elseif nChange == 1 then
    self.nDirView = self.nDirView + 1
  end

  if self.nDirView > MAXDIRVIEW then
    self.nDirView = 0
  end

  if self.nDirView < 0 then
    self.nDirView = MAXDIRVIEW
  end

  --[[if self.nDirView == 0 then
		Wnd_SetEnable(self.UIGROUP, BTN_LEFT, 0);
	else
		Wnd_SetEnable(self.UIGROUP, BTN_LEFT, 1);
	end
	
	if self.nDirView == MAXDIRVIEW then
		Wnd_SetEnable(self.UIGROUP, BTN_RIGHT, 0);
	else
		Wnd_SetEnable(self.UIGROUP, BTN_RIGHT, 1);
	end]]
  self:OnUpdatePreView(self.nDirView)
end

function tbPreView:OnUpdatePreView(nDir)
  local tbPart, nTemplateId = tbPreViewMgr:GetPreViewPart()

  local nSex = me.nSex
  local tbObj = {}
  tbObj.nType = Ui.OBJ_NPCRES
  tbObj.nTemplateId = nTemplateId or ((nSex == 0) and -1 or -2)
  tbObj.nAction = Npc.ACT_STAND1
  tbObj.tbPart = tbPart
  tbObj.nDir = nDir or 0
  tbObj.bRideHorse = 0
  self.tbObjPreView:SetObj(tbObj)
  UiManager:OnActiveWnd(self.UIGROUP, 1)
end

function tbPreView:RegisterEvent()
  local tbRegEvent = {}
  tbRegEvent = self.tbObjPreView:RegisterEvent()
  return tbRegEvent
end

function tbPreView:RegisterMessage()
  local tbRegMsg = {}
  tbRegMsg = self.tbObjPreView:RegisterMessage()
  return tbRegMsg
end

function tbPreView:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emUIEVENT_PREVIEW_CHANGED, self.OnUpdatePreView },
  }
  return Lib:MergeTable(tbRegEvent, self.tbObjPreView:RegisterEvent())
end
