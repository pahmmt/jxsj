-------------------------------------------------------
-- 文件名　：grouppanel.lua
-- 文件描述：战队成员面板框
-- 创建者　：ZhaoYu2
-- 创建时间：2009-09-24 15:04:46
-------------------------------------------------------
local uiGroupPanel = Ui:GetClass("grouppanel")
local LIST_MEMBER = "LstItems"
local CMB_GROUP = "CmbGroupList"
local BTN_CLOSE = "BtnClose"
local TXT_FRAMETITLE = "TxtFrameTitle"
--szName,szLevel,szMap,szFaction
local tbMemberList = {}
local tbGroupList = {}

function uiGroupPanel:OnOpen()
  tbGroupList = {}
  tbMemberList = {}
  Lst_Clear(self.UIGROUP, LIST_MEMBER)
  ClearComboBoxItem(self.UIGROUP, CMB_GROUP)
  KLeague.ApplyLeagueList()
  return 1
end

function uiGroupPanel:OnClose()
  self:ClearMember()
  self:ClearGroup()
end

function uiGroupPanel:Init() end

function uiGroupPanel:OpenWindow()
  UiManager:OpenWindow(Ui.UI_GROUPPANEL)
  KLeague.ApplyLeagueList()
end

function uiGroupPanel:OnButtonClick(szWnd, nParam)
  if szWnd == BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiGroupPanel:ShowGroupList()
  for _k, _v in ipairs(tbGroupList) do
    ComboBoxAddItem(self.UIGROUP, CMB_GROUP, _k, _v)
  end
end

function uiGroupPanel:AddMember(szName, nLevel, nMap, nFaction, nOnline)
  local szColor
  if nOnline > 0 then
    szColor = "<color=0xffFFFFFF>"
  else
    szColor = "<color=0xffB4B4B4>"
  end

  local szMap = ""
  if nMap > 0 then
    szMap = GetMapNameFormId(nMap)
    if string.len(szMap) > 16 then
      local nCount = 0
      local _, nC = string.gsub(string.sub(szMap, 1, 12), "_", "_")
      nCount = nCount + nC
      local _, nC = string.gsub(string.sub(szMap, 1, 12), "%(", "%(")
      nCount = nCount + nC

      szMap = string.sub(szMap, 1, 12 + nCount % 2) .. "..."
    end
  end
  local tbItem = {}
  local szFaction = Player:GetFactionRouteName(nFaction) or ""
  tbItem.szName = szColor .. szName
  tbItem.szLevel = szColor .. nLevel
  tbItem.szMap = szColor .. szMap
  tbItem.szFaction = szColor .. szFaction
  table.insert(tbMemberList, tbItem)
end

function uiGroupPanel:ClearMember()
  Lst_Clear(self.UIGROUP, LIST_MEMBER)
  tbMemberList = {}
end

function uiGroupPanel:ClearGroup()
  tbGroupList = {}
  ClearComboBoxItem(self.UIGROUP, CMB_GROUP)
end

function uiGroupPanel:ShowMember()
  for _k, _v in ipairs(tbMemberList) do
    Lst_SetCell(self.UIGROUP, LIST_MEMBER, _k, 1, _v.szName)
    Lst_SetCell(self.UIGROUP, LIST_MEMBER, _k, 2, _v.szMap)
    Lst_SetCell(self.UIGROUP, LIST_MEMBER, _k, 3, _v.szFaction)
    Lst_SetCell(self.UIGROUP, LIST_MEMBER, _k, 4, _v.szLevel)
  end
end

function uiGroupPanel:OnGroupUpdate(nNotify)
  if nNotify == 1 then
    self:ClearGroup()
    tbGroupList = KLeague.GetLeagueList()
    self:ShowGroupList()
  elseif nNotify == 2 then
    self:ClearMember()
    local tbList = KLeague.GetMemberInfo()
    for _k, _v in ipairs(tbList) do
      self:AddMember(_v.szName, _v.nLevel, _v.nMap, _v.nFaction, _v.nOL)
    end
    self:ShowMember()
  end
end

function uiGroupPanel:OnComboBoxIndexChange(szWnd, nIndex)
  if szWnd == CMB_GROUP then
    KLeague.ApplyLeagueMemberData(tbGroupList[nIndex + 1])
  end
end

function uiGroupPanel:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_GROUP_UPDATE, self.OnGroupUpdate },
  }
  return tbRegEvent
end
