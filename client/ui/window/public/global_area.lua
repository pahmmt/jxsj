----global_area.lua
----作者：孙多良
----2012-15-08
----info：

local tbArea = Ui:GetClass("global_area")
tbArea.Txt_AchiveInfo = "Txt_AchiveInfo_"
tbArea.Txt_AchiveDsc = "Txt_AchiveDsc_"
tbArea.Btn_Close = "Btn_Close"
tbArea.Edt_FindServer = "Edt_FindServer"
tbArea.Lst_ServerList = "Lst_ServerList"
tbArea.Scr_SerLookup = "ScorllSerLookup"
tbArea.SPanel_AchiveInfo = "SPanel_AchiveInfo"
tbArea.MyServerInfo = "MyServerInfo"
tbArea.Txt_MyServerInfo_STAR = "Txt_MyServerInfo_STAR"
tbArea.Txt_START = "Txt_START_"

tbArea.MaxArea = 9 --最大战区
tbArea.tbAreaHeightAndSort = {
  --战区所在控件的高度位置(顺序，高度, 全星，半星)
  [1] = { 1, 0, 5, 0 },
  [2] = { 2, 0, 4, 1 },
  [3] = { 3, 191, 4, 0 },
  [4] = { 4, 191, 3, 1 },
  [5] = { 5, 382, 3, 0 }, --电信5
  [6] = { 7, 573, 4, 1 }, --网通1
  [7] = { 8, 573, 4, 0 }, --网通2
  [8] = { 6, 382, 3, 0 }, --电信6
  [9] = { 9, 764, 3, 0 }, --网通3
}

tbArea.tbFndList = {}
function tbArea:OnOpen()
  self.tbFndList = {}
  Wnd_SetVisible(self.UIGROUP, self.Scr_SerLookup, 0)
  local szMyGate = GetGatewayName()
  local szMyAreaName = string.format("本服所属战区:%s", ServerEvent:GetGlobalAreaName(szMyGate))
  Txt_SetTxt(self.UIGROUP, self.MyServerInfo, szMyAreaName)
  local nAreaId = ServerEvent:GetGlobalAreaId(szGate)
  TxtEx_SetText(self.UIGROUP, self.Txt_MyServerInfo_STAR, self:GetStartTip(nAreaId))
  self:UpdateArea(szMyGate, 0)
end

function tbArea:GetStartTip(nAreaId)
  local szTip = ""
  if not self.tbAreaHeightAndSort[nAreaId] then
    return szTip
  end
  if self.tbAreaHeightAndSort[nAreaId][3] > 0 then
    for i = 1, self.tbAreaHeightAndSort[nAreaId][3] do
      szTip = szTip .. "<pic=155>"
    end
  end
  if self.tbAreaHeightAndSort[nAreaId][4] > 0 then
    for i = 1, self.tbAreaHeightAndSort[nAreaId][4] do
      szTip = szTip .. "<pic=154>"
    end
  end
  return szTip
end

function tbArea:UpdateArea(szGate, nType)
  local szServerTip = "输入服务器名，可输入全称或关键字。"
  local nMyGatewayHeight = 0
  for nAreaId = 1, self.MaxArea do
    local szAreaName = ServerEvent:GetGlobalAreaNameById(nAreaId)
    local nGbTask = ServerEvent:GetGlobalAreaGbTaskById(nAreaId)
    local tbGateList = ServerEvent.tbGlobalArea[nAreaId] or {}
    local nShowId = self.tbAreaHeightAndSort[nAreaId][1]
    Txt_SetTxt(self.UIGROUP, self.Txt_AchiveInfo .. nShowId, szAreaName)
    TxtEx_SetText(self.UIGROUP, self.Txt_START .. nShowId, self:GetStartTip(nAreaId))
    local szCityer = KGblTask.SCGetDbTaskStr(nGbTask)
    if szCityer == "" then
      szCityer = "暂无"
    end
    local szInfo = string.format(" <color=yellow>铁浮城主：%s<color>\n", szCityer)
    local nCount = 0
    for szgateway, tbinfo in pairs(tbGateList) do
      local szServerName = string.format("【%s %s】", tbinfo.ZoneName, tbinfo.ServerName)
      if nCount % 2 == 1 then
        szServerName = szServerName .. "\n"
      else
        szServerName = Lib:StrFillL(szServerName, 24, szFilledChar)
      end
      if szGate == szgateway then
        szServerName = string.format("<color=232,128,24>%s<color>", szServerName)
        nMyGatewayHeight = self.tbAreaHeightAndSort[nAreaId][2] or 0
        szServerTip = string.format("<color=green>所属主服：%s\n<color>", tbinfo.ServerName)
        szServerTip = szServerTip .. string.format("\n主服下所有区服：\n   %s", table.concat(tbinfo.tbAllServerName, "\n   "))
      end
      szInfo = szInfo .. szServerName
      nCount = nCount + 1
    end
    Txt_SetTxt(self.UIGROUP, self.Txt_AchiveDsc .. nShowId, szInfo)
  end
  ScrPanel_SetWndDocumentAbsoluteTop(self.UIGROUP, self.SPanel_AchiveInfo, nMyGatewayHeight)
  if nType == 1 then
    Wnd_SetTip(self.UIGROUP, self.Edt_FindServer, szServerTip)
  end
end

function tbArea:OnButtonClick(szWnd, nParam)
  if szWnd == self.Btn_Close then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function tbArea:OnEditChange(szWndName)
  local szFindServer = Edt_GetTxt(self.UIGROUP, self.Edt_FindServer)
  Lst_Clear(self.UIGROUP, self.Lst_ServerList)
  self.tbFndList = {}
  if string.len(szFindServer) <= 1 then
    Wnd_SetVisible(self.UIGROUP, self.Scr_SerLookup, 0)
    return
  end
  local nIndex = 1
  for szZone, tbServerList in pairs(ServerEvent:GetServerNameList()) do
    for szServerName, szGateway in pairs(tbServerList) do
      local nFind = string.find(szServerName, szFindServer)
      if nFind and nFind > 0 then
        Lst_SetCell(self.UIGROUP, self.Lst_ServerList, nIndex, 0, szServerName)
        table.insert(self.tbFndList, { nRegId, nListId, szServerName, szGateway })
        nIndex = nIndex + 1
        print(self.UIGROUP, self.Lst_ServerList, nIndex, 0, szServerName)
      end
    end
  end
  if #self.tbFndList > 0 then
    Wnd_SetVisible(self.UIGROUP, self.Scr_SerLookup, 1)
  else
    Wnd_SetVisible(self.UIGROUP, self.Scr_SerLookup, 0)
  end
end

local szDefaultName = "搜索服务器"
function tbArea:OnEditFocus(szWndName)
  local szMap = Edt_GetTxt(self.UIGROUP, self.Edt_FindServer)
  if szMap == szDefaultName then
    Edt_SetTxt(self.UIGROUP, self.Edt_FindServer, "")
  end
end

function tbArea:OnListSel(szWnd, nIndex)
  local tbLastRegionIndex = self.tbFndList[nIndex]
  if tbLastRegionIndex then
    local szZoneServer = tbLastRegionIndex[3]
    Edt_SetTxt(self.UIGROUP, self.Edt_FindServer, szZoneServer)
    self:UpdateArea(tbLastRegionIndex[4], 1)
  end
  self.tbFndList = {}
  Wnd_SetVisible(self.UIGROUP, self.Scr_SerLookup, 0)
end
