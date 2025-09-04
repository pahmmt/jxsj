Require("\\ui\\script\\logic\\autopath.lua")

local uiWorldMap_Sub = Ui:GetClass("worldmap_sub")
local tbAutoPath = Ui.tbLogic.tbAutoPath
local tbMapBar = Ui.tbLogic.tbMapBar
local tbMap = Ui.tbLogic.tbMap
local tbTimer = Ui.tbLogic.tbTimer
local szSearchTypeMap = "Map"
local szSearchTypeNpc = "Npc"
local szDefaultMapName = "请输入地图名"
local szDefaultNpcName = "输入NPC名"

uiWorldMap_Sub.IMAGE_SUBMAP = "ImgSubMap"
uiWorldMap_Sub.IMAGE_MARK = "ImgMark"
uiWorldMap_Sub.IMAGE_TARGET_MARK = "ImgTargetMark"
uiWorldMap_Sub.COMBOBOX_WORLDMAP = "ComboxSub"
uiWorldMap_Sub.IMAGE_FRAME = "ImgSubFrame"
uiWorldMap_Sub.BTN_CLOSE = "BtnClose"
uiWorldMap_Sub.TXT_AREA = "TxtArea"
uiWorldMap_Sub.BTN_WORLDMAP_SUB = "BtnWorldMap_Sub"
uiWorldMap_Sub.BTN_WORLDMAP_GlOBAL = "BtnWorldMap_Global"
uiWorldMap_Sub.BTN_WORLDMAP_AREA = "BtnWorldMap_Area"
uiWorldMap_Sub.BTN_DOMAIN = "BtnWorldMap_Domain"

uiWorldMap_Sub.TXT_CURPOS = "TxtCurPos"
uiWorldMap_Sub.BTN_AUTOPATH = "BtnAutoPath"
uiWorldMap_Sub.Edt_PosX = "EdtPosX"
uiWorldMap_Sub.Edt_PosY = "EdtPosY"

uiWorldMap_Sub.Edt_MapName = "EdtMapName"
uiWorldMap_Sub.Btn_MapSearch = "BtnMapSearch"
uiWorldMap_Sub.List_MapLookup = "ListMapLookupName"
uiWorldMap_Sub.Scr_MapLookup = "ScorllMapLookup"

uiWorldMap_Sub.Edt_NpcName = "EdtNpcName"
uiWorldMap_Sub.Btn_NpcSearch = "BtnNpcSearch"
uiWorldMap_Sub.List_NpcLookup = "ListNpcLookupName"
uiWorldMap_Sub.Scr_NpcLookup = "ScorllNpcLookup"

uiWorldMap_Sub.IMAGE_SUBMAP_WIDTH = 789
uiWorldMap_Sub.IMAGE_SUBMAP_HEIGHT = 534
uiWorldMap_Sub.IMAGE_MARK_HALF_WIDTH = 18
uiWorldMap_Sub.IMAGE_MARK_HALF_HEIGHT = 34
uiWorldMap_Sub.FLAGSPRPATH = "\\image\\ui\\001a\\minimap\\mark_flag.spr"
uiWorldMap_Sub.MAP_LOCATION_PATH = "worldmap\\player.txt"
uiWorldMap_Sub.MAP_LIST_PATH = "\\setting\\map\\maplist.txt"

uiWorldMap_Sub.NOAREAMAPSETPATH = "worldmap\\no_area_map.txt"
uiWorldMap_Sub.AREAMAPSETPATH = "\\setting\\map\\minimap.txt"
uiWorldMap_Sub.RESETTIME = 18 * 4 -- TODO: 地图拖动复原的时间间隔
uiWorldMap_Sub.TEAMMATETIME = 18 / 2 -- 地图上人物刷新时间
uiWorldMap_Sub.NPCCOLORPATH = "worldmap\\npc_color.txt"

uiWorldMap_Sub.nCurMapId = nil

-- 切换地图需要重新装载的
--uiWorldMap_Sub.tbNpcInfo			= nil;
--uiWorldMap_Sub.tbCanvasId			= {};
--uiWorldMap_Sub.tbWorldMap 		= {};
--uiWorldMap_Sub.tbTeamMatePoint	= {};
--uiWorldMap_Sub.tbPlayerPoint		= {};
--uiWorldMap_Sub.tbHighLightPoint	= {};
--uiWorldMap_Sub.tbLastNpcEffect 	= {};
--uiWorldMap_Sub.tbAnimation		= {};
--uiWorldMap_Sub.tbNpcAliasInfo		= {};
--uiWorldMap_Sub.tbMapIdCandidate = {};
--uiWorldMap_Sub.tbNpcIdCandidate = {};

-- 只需要装在一次的
uiWorldMap_Sub.tbSubMapList = nil
uiWorldMap_Sub.tbNpcColor = nil
uiWorldMap_Sub.tbNoAreaMapId = nil
uiWorldMap_Sub.tbNpcAliasAllInfo = {}

function uiWorldMap_Sub:Init()
  self.nOrgX = 0
  self.nOrgY = 0
  self.nCurPosX = 0
  self.nCurPosY = 0
  self.bCurMap = 0
  self.CurShowMapId = 0
  self.nMapControlId = 0
  self.nCanvasFlagId = 0
  self.nCanvasLineId = 0
  self.nFlagWidth = 0
  self.nFlagHeight = 0
  self.nFlagDestPosX = 0
  self.nFlagDestPosY = 0
  self.nTimerId = 0
  self.nTeamTimerId = 0
  self.bDisable = 0
  self.nMapSelIndex = 0
  self.nNpcSelIndex = 0
  self.tbCanvasId = {}
  self.tbWorldMap = {}
  self.tbTeamMatePoint = {}
  self.tbPlayerPoint = {}
  self.tbHighLightPoint = {}
  self.tbLastNpcEffect = {}
  self.tbAnimation = {}
  self.szOldMapKeyword = ""
  self.tbMapIdCandidate = {}
  self.tbNpcIdCandidate = {}
end

function uiWorldMap_Sub:CleanUp()
  self.tbNpcInfo = nil
  self.tbNpcAliasInfo = {}
end

function uiWorldMap_Sub:LoadMiniMapFile()
  --为了让抓点方便GM模式情况下可以自动重读,ctrl+3,开启GM调试模式
  self.tbMiniMapList = {}
  local tbTabFile = Lib:LoadTabFile(self.AREAMAPSETPATH)
  if tbTabFile then
    for ni, tbMapinfo in ipairs(tbTabFile) do
      local nMapId = tonumber(tbMapinfo.MapId) or 0
      self.tbMiniMapList[nMapId] = self.tbMiniMapList[nMapId] or {}
      table.insert(self.tbMiniMapList[nMapId], tbMapinfo)
    end
  end
end
uiWorldMap_Sub:LoadMiniMapFile()

function uiWorldMap_Sub:RemoveWhiteSpace(text) end

function uiWorldMap_Sub:ReadNpcInfo(nReadMapId)
  if not self.tbMiniMapList or Ui.DebugMode == 1 then
    self:LoadMiniMapFile()
  end

  if not self.tbMiniMapList[nReadMapId] then
    self.tbNpcInfo = {}
    return nil
  end

  if self.tbNpcInfo ~= nil then
    return 1
  end

  self.tbNpcInfo = {}
  for nMapId, tbMapinfo in ipairs(self.tbMiniMapList[nReadMapId]) do
    local nIsDisable = tonumber(tbMapinfo.IsDisable) or 0
    if nIsDisable == 0 then
      local nPosType = tonumber(tbMapinfo.PosType) or 0
      local nSprPosX = tonumber(tbMapinfo.PosX) or 0
      local nSprPosY = tonumber(tbMapinfo.PosY) or 0
      local szName = string.gsub(tbMapinfo.Text, " ", "")
      local nFont = tonumber(tbMapinfo.Size) or 0
      local szColor = tbMapinfo.Color
      local szSprName = tbMapinfo.Icon
      local nTextPosXDis = tonumber(tbMapinfo.PosXDis) or 0
      local nTextPosYDis = tonumber(tbMapinfo.PosYDis) or 0

      if nPosType == 1 then
        nSprPosX, nSprPosY = tbMap:WorldPosToImgPos(self.nMapControlId, nSprPosX, nSprPosY)
      end
      local nTextPosX = nSprPosX + nTextPosXDis
      local nTextPosY = nSprPosY + nTextPosYDis - 16
      if string.len(szSprName) <= 4 or string.sub(szSprName, -4, -1) ~= ".spr" then
        nSprPosX, nSprPosY = nTextPosX, nTextPosY
      end
      if szName ~= "" then
        table.insert(self.tbNpcInfo, { nSprPosX, nSprPosY, szName, nFont, szColor, szSprName, nTextPosX, nTextPosY })
      end
    end
  end
  return 1
end

function uiWorldMap_Sub:ReadNpcAliasInfo(nMapId)
  if not self.tbNpcAliasAllInfo[nMapId] then
    local szMapFilePath = GetMapInfoFileNameFormId(nMapId)
    local tbTabFile = Lib:LoadTabFile(szMapFilePath)
    self.tbNpcAliasAllInfo[nMapId] = {}
    if tabTabFile then
      for ni, tbMapinfo in ipairs(tbTabFile) do
        local szNpcName = tbMapinfo.NpcName
        local nNpcId = tbMapinfo.NpcTemplateId
        local nClass = tonumber(tbMapinfo.Class) or 0
        local nNpcType = tonumber(tbMapinfo.NpcType) or 0
        local nSprPosX = tonumber(tbMapinfo.XPos) or 0
        local nSprPosY = tonumber(tbMapinfo.YPos) or 0
        local szNpcPosFile = tbMapinfo.NpcPosFile
        if nSprPosX == 0 and nSprPosY == 0 and szNpcPosFile then
          local tbPosInfoFile = Lib:LoadTabFile(szNpcPosFile)
          if tbPosInfoFile then
            local n = table.getn(tbPosInfoFile)
            nSprPosX = tonumber(tbPosInfoFile[n].TRAPX)
            nSprPosY = tonumber(tbPosInfoFile[n].TRAPY)
          end
        end
        local szNoNumName = string.gsub(szNpcName, "%d", "")
        if nClass == 0 and (nNpcType == 3 or nNpcType == 4 or nNpcType == 0) and szNoNumName ~= "" then
          if (nSprPosX > 0) and (nSprPosY > 0) then
            nSprPosX, nSprPosY = tbMap:WorldPosToImgPos(self.nMapControlId, nSprPosX / 32, nSprPosY / 32)
          end
          table.insert(self.tbNpcAliasAllInfo[nMapId], { nSprPosX, nSprPosY, szNpcName })
        end
      end
    end
  end
  return 1
end

function uiWorldMap_Sub:SetNpcSearchButton()
  local tbMapInfo = self.tbSubMapList[self.CurShowMapId]
  if not tbMapInfo then
    return 0
  end

  if not tbMapInfo[3] then
    return 0
  end
  local szMapType = tbMapInfo[3]
  if szMapType == "village" or szMapType == "faction" or szMapType == "city" or szMapType == "fight" or szMapType == "taskfight" or szMapType == "tasksafe" or szMapType == "xisuidao" or szMapType == "xisuidao_shandong" or szMapType == "battle_signup" then
    Wnd_SetEnable(self.UIGROUP, self.Btn_NpcSearch, 1)
  else
    Wnd_SetEnable(self.UIGROUP, self.Btn_NpcSearch, 0)
  end
end

-- The subMap info will be stored in tbSubMapList, with index of nMapId and content of (szMapName, szCountry)
function uiWorldMap_Sub:ReadSubMapInfo()
  -- load the sub map info
  if self.tbSubMapList ~= nil then
    self:SetNpcSearchButton()
    return 1
  end
  self.tbSubMapList = {}
  local tbTabFile = Lib:LoadTabFile(self.MAP_LIST_PATH)
  if not tbTabFile then
    Ui:Output("[ERR] uiWorldMap_Sub MapList 配置路径不正确: " .. self.MAP_LIST_PATH)
    return 0
  end
  for ni, tbMapinfo in ipairs(tbTabFile) do
    local szMapName = tbMapinfo.MapName or ""
    local nMapId = tonumber(tbMapinfo.TemplateId) or 0
    local szMapType = tbMapinfo.MapType or ""
    --if (szMapType == "village") or (szMapType == "faction") or
    --	(szMapType == "city") or (szMapType == "fight") then
    self.tbSubMapList[nMapId] = { szMapName, "", szMapType }
    --end
  end

  -- load the map location
  local szFile = GetActualPath(self.MAP_LOCATION_PATH)
  local pTabFile = KIo.OpenTabFile(szFile)
  if not pTabFile then
    Ui:Output("[ERR] uiWorldMap_Sub MapLocation 配置路径不正确: " .. szFile)
    return 0
  end
  local tMapLocation = {}
  local nHeight = pTabFile.GetHeight()
  -- Valid map name on the world: village, faction, city, fight
  for i = 2, nHeight do
    local nMapId = pTabFile.GetInt(i, 1)
    local szMapName = pTabFile.GetStr(i, 4)
    local szCountry = pTabFile.GetStr(i, 5)
    if self.tbSubMapList[nMapId] and (self.tbSubMapList[nMapId][1] == szMapName) then
      self.tbSubMapList[nMapId][2] = szCountry
    end
  end
  KIo.CloseTabFile(pTabFile) -- 释放对象
  return 1
end

function uiWorldMap_Sub:ReadNoAreaMapId(szMapName)
  if self.tbNoAreaMapId ~= nil then
    return 1
  end
  self.tbNoAreaMapId = {}
  local szFile = GetActualPath(szMapName)
  local pTabFile = KIo.OpenTabFile(szFile)
  if not pTabFile then
    Ui:Output("[ERR] NoAreaMapId配置路径不正确: " .. szFile)
    return 0
  end
  local nHeight = pTabFile.GetHeight()
  for i = 2, nHeight do
    local nMapId = pTabFile.GetInt(i, 1)
    self.tbNoAreaMapId[i - 1] = nMapId
  end
  KIo.CloseTabFile(pTabFile) -- 释放对象
  return 1
end

function uiWorldMap_Sub:ReadNpcColor(szNpcColorFile)
  if self.tbNpcColor ~= nil then
    return 1
  end
  self.tbNpcColor = {}
  local szFile = GetActualPath(szNpcColorFile)
  local pTabFile = KIo.OpenTabFile(szFile)
  if not pTabFile then
    Ui:Output("[ERR] uiWorldMap_Sub Npc颜色配置文件路径不正确: " .. szFile)
    return 0
  end
  local nHeight = pTabFile.GetHeight()
  for i = 2, nHeight do
    local nTypeId = pTabFile.GetInt(i, 1)
    local szColor = pTabFile.GetStr(i, 3)
    self.tbNpcColor[nTypeId] = szColor
  end
  KIo.CloseTabFile(pTabFile) -- 释放对象
  return 1
end

function uiWorldMap_Sub:GetMapNameByMapId(nMapId)
  if self.tbSubMapList and self.tbSubMapList[nMapId] then
    return self.tbSubMapList[nMapId][1], self.tbSubMapList[nMapId][2]
  end
  return "", ""
end

function uiWorldMap_Sub:OnSearch(szSearchType)
  if not szSearchType then
    return
  end
  local szSearchName = ""
  local tbSearchList = {}
  local tbSearchIdCandidate = {}
  local nSelIndex = 0
  if szSearchType and (szSearchType == szSearchTypeMap) then
    szSearchName = Edt_GetTxt(self.UIGROUP, self.Edt_MapName)
    tbSearchList = self.tbSubMapList
    tbSearchIdCandidate = self.tbMapIdCandidate
    nSelIndex = self.nMapSelIndex
  elseif szSearchType and (szSearchType == szSearchTypeNpc) then
    szSearchName = Edt_GetTxt(self.UIGROUP, self.Edt_NpcName)
    tbSearchList = self.tbNpcInfo
    tbSearchIdCandidate = self.tbNpcIdCandidate
    nSelIndex = self.nNpcSelIndex
  end
  if szSearchName and (szSearchName ~= "") and (szSearchType == szSearchTypeMap and szSearchName ~= szDefaultMapName or szSearchType == szSearchTypeNpc and szSearchName ~= szDefaultNpcName) then
    if (nSelIndex > 0) and (nSelIndex <= #tbSearchIdCandidate) and tbSearchIdCandidate then
      local nSelId = tbSearchIdCandidate[nSelIndex]
      if szSearchType == szSearchTypeMap then
        self:LocateMap(nSelId)
      elseif szSearchType == szSearchTypeNpc then
        if nSelId[1] == 1 then
        else
          tbSearchList = self.tbNpcAliasInfo
        end
        Edt_SetTxt(self.UIGROUP, self.Edt_NpcName, tbSearchList[nSelId[2]][3])
        self.szOldNpcKeyword = tbSearchList[nSelId[2]][3]
        local nWorldPosX, nWorldPosY = tbSearchList[nSelId[2]][1], tbSearchList[nSelId[2]][2]
        if nWorldPosX ~= 0 and nWorldPosY ~= 0 then
          nWorldPosX, nWorldPosY = tbMap:ImgPosToWorldPos(self.nMapControlId, nWorldPosX, nWorldPosY)
          local tbPos = {
            nMapId = self.CurShowMapId,
            nX = nWorldPosX,
            nY = nWorldPosY,
          }
          tbAutoPath:ProcessClick(tbPos)
          self:SetTimer()
          Wnd_SetVisible(self.UIGROUP, self.Scr_NpcLookup, 0)
        else
          UiManager:OpenWindow(Ui.UI_INFOBOARD, "NPC行迹诡异，无法捉摸")
        end
        return nWorldPosX, nWorldPosY
      end
    else
      if szSearchType == szSearchTypeMap then
        UiManager:OpenWindow(Ui.UI_INFOBOARD, "未查找到符合命名的地图")
      elseif szSearchType == szSearchTypeNpc then
        UiManager:OpenWindow(Ui.UI_INFOBOARD, "在当前地图未查找到符合命名的NPC")
      end
      return 0, 0
    end
  else
    if szSearchType == szSearchTypeMap then
      UiManager:OpenWindow(Ui.UI_INFOBOARD, "请输入地图名")
    elseif szSearchType == szSearchTypeNpc then
      UiManager:OpenWindow(Ui.UI_INFOBOARD, "请输入NPC名")
    end
    return 0, 0
  end
end

function uiWorldMap_Sub:ShowTarget(nX, nY)
  if nX == 0 and nY == 0 then
    Wnd_SetVisible(self.UIGROUP, self.IMAGE_TARGET_MARK, 0)
  else
    local nImageWidth, nImageHeight = Wnd_GetSize(self.UIGROUP, self.IMAGE_TARGET_MARK)
    Wnd_SetPos(self.UIGROUP, self.IMAGE_TARGET_MARK, nX - nImageWidth / 2 + 2, nY - nImageHeight / 2 - 1)
    Img_PlayAnimation(self.UIGROUP, self.IMAGE_TARGET_MARK, 1)
    self:StopTimer()
    tbMap:ShowTarget(self.nMapControlId)
    tbMap:ChangeImgPos(self.nMapControlId, nX, nY)
    Wnd_SetVisible(self.UIGROUP, self.IMAGE_TARGET_MARK, 1)
  end
end

function uiWorldMap_Sub:LocateMap(nMapId)
  if not self.tbSubMapList then
    self:ReadSubMapInfo()
  end
  if nMapId then
    if self.tbSubMapList and self.tbSubMapList[nMapId] then
      local szCountry = self.tbSubMapList[nMapId][2]
      UiManager:CloseWindow(self.UIGROUP)
      UiManager:OpenWindow(Ui.UI_WORLDMAP_AREA, szCountry, nMapId)
    else
      UiManager:OpenWindow(Ui.UI_INFOBOARD, "未查找到符合命名的地图")
    end
  end
end

function uiWorldMap_Sub:OnEditEnter(szWndName)
  if szWndName == self.Edt_MapName then
    self:OnSearch(szSearchTypeMap)
  elseif szWndName == self.Edt_NpcName then
    self:OnSearch(szSearchTypeNpc)
  end
end

function uiWorldMap_Sub:OnMouseEnter(szWndName)
  if szWndName == self.List_MapLookup then
    local nIndex = MessageList_GetSelectedIndex(self.UIGROUP, self.List_MapLookup)
    if nIndex then
      self.nMapSelIndex = nIndex
    end
  elseif szWndName == self.List_NpcLookup then
    local nIndex = MessageList_GetSelectedIndex(self.UIGROUP, self.List_NpcLookup)
    self:SelectNpc(nIndex)
  end
end

function uiWorldMap_Sub:SelectNpc(nIndex)
  if nIndex then
    self.nNpcSelIndex = nIndex
    local nNpcId = self.tbNpcIdCandidate[self.nNpcSelIndex]
    if nNpcId[1] == 1 then
      self:ShowTarget(self.tbNpcInfo[nNpcId[2]][1], self.tbNpcInfo[nNpcId[2]][2])
      return self.tbNpcInfo[nNpcId[2]][3]
    else
      self:ShowTarget(self.tbNpcAliasInfo[nNpcId[2]][1], self.tbNpcAliasInfo[nNpcId[2]][2])
      return self.tbNpcAliasInfo[nNpcId[2]][3]
    end
  end
end

function uiWorldMap_Sub:OnMsgListLineClick(szWndName)
  if szWndName == self.List_MapLookup then
    local text = self.tbSubMapList[self.tbMapIdCandidate[self.nMapSelIndex]][1]
    Edt_SetTxt(self.UIGROUP, self.Edt_MapName, text)
    self.szOldMapKeyword = text
    Wnd_SetVisible(self.UIGROUP, self.Scr_MapLookup, 0)
    Edt_MoveHome(self.UIGROUP, self.Edt_MapName)
  elseif szWndName == self.List_NpcLookup then
    local text = self:SelectNpc(self.nNpcSelIndex)
    self.szOldNpcKeyword = text
    Edt_SetTxt(self.UIGROUP, self.Edt_NpcName, text)
    Wnd_SetVisible(self.UIGROUP, self.Scr_NpcLookup, 0)
    Edt_MoveHome(self.UIGROUP, self.Edt_NpcName)
  end
end

function uiWorldMap_Sub:OnSpecialKeyDown(szWndName, nParam)
  if szWndName == self.Edt_MapName then
    if (nParam == Ui.MSG_VK_UP) or (nParam == Ui.MSG_VK_DOWN) then
      if (nParam == Ui.MSG_VK_UP) and (self.nMapSelIndex > 1) then
        self.nMapSelIndex = self.nMapSelIndex - 1
      elseif (nParam == Ui.MSG_VK_DOWN) and (self.nMapSelIndex < #self.tbMapIdCandidate) then
        self.nMapSelIndex = self.nMapSelIndex + 1
      end
      MessageList_SetSelectedIndex(self.UIGROUP, self.List_MapLookup, self.nMapSelIndex)
      if (self.nMapSelIndex <= #self.tbMapIdCandidate) and self.tbSubMapList[self.tbMapIdCandidate[self.nMapSelIndex]] then
      end
    end
  elseif szWndName == self.Edt_NpcName then
    if (nParam == Ui.MSG_VK_UP) or (nParam == Ui.MSG_VK_DOWN) then
      if (nParam == Ui.MSG_VK_UP) and (self.nNpcSelIndex > 1) then
        self.nNpcSelIndex = self.nNpcSelIndex - 1
      elseif (nParam == Ui.MSG_VK_DOWN) and (self.nNpcSelIndex < #self.tbNpcIdCandidate) then
        self.nNpcSelIndex = self.nNpcSelIndex + 1
      end
      MessageList_SetSelectedIndex(self.UIGROUP, self.List_NpcLookup, self.nNpcSelIndex)
      if self.nNpcSelIndex <= #self.tbNpcIdCandidate then
        local nNpcId = self.tbNpcIdCandidate[self.nNpcSelIndex]
        if nNpcId[1] == 1 then
          self:ShowTarget(self.tbNpcInfo[nNpcId[2]][1], self.tbNpcInfo[nNpcId[2]][2])
        else
          self:ShowTarget(self.tbNpcAliasInfo[nNpcId[2]][1], self.tbNpcAliasInfo[nNpcId[2]][2])
        end
      end
    end
  end
end

function uiWorldMap_Sub:OnEditFocus(szWndName)
  if szWndName == self.Edt_MapName then
    local szMap = Edt_GetTxt(self.UIGROUP, self.Edt_MapName)
    if szMap == szDefaultMapName then
      Edt_SetTxt(self.UIGROUP, self.Edt_MapName, "")
      self.tbMapIdCandidate = {}
      self.nMapSelIndex = 0
      self.szOldMapKeyword = ""
    end
  elseif szWndName == self.Edt_NpcName then
    local szNpc = Edt_GetTxt(self.UIGROUP, self.Edt_NpcName)
    if szNpc == szDefaultNpcName then
      Edt_SetTxt(self.UIGROUP, self.Edt_NpcName, "")
      self.tbNpcIdCandidate = {}
      self.nNpcSelIndex = 0
      self.szOldNpcKeyword = ""
    end
  end
end

function uiWorldMap_Sub:OnEditChange(szWndName)
  if szWndName == self.Edt_MapName then
    local szMapName = Edt_GetTxt(self.UIGROUP, self.Edt_MapName)
    if szMapName and (szMapName ~= "") then
      if self.szOldMapKeyword ~= szMapName then
        self.szOldMapKeyword = szMapName
        self.tbMapIdCandidate = {}
        self.nMapSelIndex = 0
        local bFiterColor = 1
        MessageList_Clear(self.UIGROUP, self.List_MapLookup)
        for nMapId, mapContent in pairs(self.tbSubMapList) do
          if MatchStringSuggestion(szMapName, mapContent[1]) == 1 and mapContent[2] ~= "" then
            table.insert(self.tbMapIdCandidate, nMapId)
            local szMapFullName = mapContent[1] .. "(" .. mapContent[2] .. ")"
            MessageList_AddNewLine(self.UIGROUP, self.List_MapLookup)
            MessageList_PushString(self.UIGROUP, self.List_MapLookup, 0, szMapFullName, "", "", bFiterColor)
            MessageList_PushOver(self.UIGROUP, self.List_MapLookup)
          end
        end
        if #self.tbMapIdCandidate > 0 then
          self.nMapSelIndex = 1
          MessageList_SetSelectedIndex(self.UIGROUP, self.List_MapLookup, self.nMapSelIndex)
          Wnd_SetVisible(self.UIGROUP, self.Scr_MapLookup, 1)
        else
          Wnd_SetVisible(self.UIGROUP, self.Scr_MapLookup, 0)
        end
      end
    else
      Wnd_SetVisible(self.UIGROUP, self.Scr_MapLookup, 0)
      self.szOldMapKeyword = ""
      self.tbMapIdCandidate = {}
    end
  elseif szWndName == self.Edt_NpcName then
    local szNpcName = Edt_GetTxt(self.UIGROUP, self.Edt_NpcName)
    if szNpcName and (szNpcName ~= "") then
      if self.szOldNpcKeyword ~= szNpcName then
        self.szOldNpcKeyword = szNpcName
        self.tbNpcIdCandidate = {}
        self.nNpcSelIndex = 0
        local bFiterColor = 1
        MessageList_Clear(self.UIGROUP, self.List_NpcLookup)
        for nNpcId, npcContent in pairs(self.tbNpcInfo) do
          if MatchStringSuggestion(szNpcName, npcContent[3]) == 1 then
            table.insert(self.tbNpcIdCandidate, { 1, nNpcId })
            MessageList_AddNewLine(self.UIGROUP, self.List_NpcLookup)
            MessageList_PushString(self.UIGROUP, self.List_NpcLookup, 0, npcContent[3], "", "", bFiterColor)
            MessageList_PushOver(self.UIGROUP, self.List_NpcLookup)
          end
        end
        for nNpcId, npcContent in pairs(self.tbNpcAliasInfo) do
          if MatchStringSuggestion(szNpcName, npcContent[3]) == 1 then
            if self:AlreadyNpcCandidate(npcContent[3], self.tbNpcAliasInfo[nNpcId][1], self.tbNpcAliasInfo[nNpcId][2]) == 0 then
              table.insert(self.tbNpcIdCandidate, { 2, nNpcId })
              MessageList_AddNewLine(self.UIGROUP, self.List_NpcLookup)
              MessageList_PushString(self.UIGROUP, self.List_NpcLookup, 0, npcContent[3], "", "", bFiterColor)
              MessageList_PushOver(self.UIGROUP, self.List_NpcLookup)
            end
          end
        end
        if #self.tbNpcIdCandidate > 0 then
          self.nNpcSelIndex = 1
          MessageList_SetSelectedIndex(self.UIGROUP, self.List_NpcLookup, self.nNpcSelIndex)
          Wnd_SetVisible(self.UIGROUP, self.Scr_NpcLookup, 1)
          local nNpcId = self.tbNpcIdCandidate[1]
          if nNpcId[1] == 1 then
            self:ShowTarget(self.tbNpcInfo[nNpcId[2]][1], self.tbNpcInfo[nNpcId[2]][2])
          else
            self:ShowTarget(self.tbNpcAliasInfo[nNpcId[2]][1], self.tbNpcAliasInfo[nNpcId[2]][2])
          end
        else
          Wnd_SetVisible(self.UIGROUP, self.Scr_NpcLookup, 0)
          Wnd_SetVisible(self.UIGROUP, self.IMAGE_TARGET_MARK, 0)
        end
      end
    else
      Wnd_SetVisible(self.UIGROUP, self.Scr_NpcLookup, 0)
      Wnd_SetVisible(self.UIGROUP, self.IMAGE_TARGET_MARK, 0)
      self.szOldNpcKeyword = ""
      self.tbNpcIdCandidate = {}
    end
  end
end

function uiWorldMap_Sub:AlreadyNpcCandidate(szNpcName, nX, nY)
  for nIndex, nNpcId in pairs(self.tbNpcIdCandidate) do
    if nNpcId[1] == 1 then
      if self:NearPosition(nX, nY, self.tbNpcInfo[nNpcId[2]][1], self.tbNpcInfo[nNpcId[2]][2]) and szNpcName == self.tbNpcInfo[nNpcId[2]][3] then
        return 1
      end
    else
      if self:NearPosition(nX, nY, self.tbNpcAliasInfo[nNpcId[2]][1], self.tbNpcAliasInfo[nNpcId[2]][2]) and szNpcName == self.tbNpcAliasInfo[nNpcId[2]][3] then
        return 1
      end
    end
  end
  return 0
end

function uiWorldMap_Sub:NearPosition(nX1, nY1, nX2, nY2)
  return (math.abs(nX1 + nY1 - nX2 - nY2) <= 4) and (math.abs(nX1 - nX2) <= 4)
end

function uiWorldMap_Sub:OnFrameScroll(szWnd)
  if (szWnd == self.IMAGE_FRAME) and self.nMapControlId and (self.nMapControlId ~= 0) then
    self:StopTimer()
    tbMap:ScrollMap(self.nMapControlId)
  end
end

function uiWorldMap_Sub:OnFrameStopScroll(szWnd)
  if (szWnd == self.IMAGE_FRAME) and self.nMapControlId and (self.nMapControlId ~= 0) then
    self:SetTimer()
  end
end

function uiWorldMap_Sub:SetTimer()
  if not self.nTimerId or self.nTimerId == 0 then
    self.nTimerId = tbTimer:Register(self.RESETTIME, self.OnTimer, self)
  end
end

function uiWorldMap_Sub:OnTimer()
  tbMap:StopScrollMap(self.nMapControlId)
end

function uiWorldMap_Sub:StopTimer()
  if self.nTimerId and self.nTimerId ~= 0 then
    tbTimer:Close(self.nTimerId)
    self.nTimerId = 0
  end
end

function uiWorldMap_Sub:OnButtonClick(szWndName, nParam)
  if szWndName == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end

  if szWndName == self.BTN_WORLDMAP_SUB then
    UiManager:CloseWindow(self.UIGROUP)
    UiManager:OpenWindow(Ui.UI_WORLDMAP_SUB, me.nTemplateMapId)
  end
  if szWndName == self.BTN_DOMAIN then
    UiManager:OpenWindow(Ui.UI_WORLDMAP_DOMAIN, self.CurShowMapId)
    UiManager:CloseWindow(self.UIGROUP)
  end

  if szWndName == self.BTN_WORLDMAP_GlOBAL then
    UiManager:OpenWindow(Ui.UI_WORLDMAP_GLOBAL, self.CurShowMapId)
    UiManager:CloseWindow(self.UIGROUP)
  end
  if szWndName == self.BTN_WORLDMAP_AREA then
    tbMapBar:SelectCurItem(self.UIGROUP)
  end

  if szWndName == self.BTN_AUTOPATH then
    local nPosX = tonumber(Edt_GetTxt(self.UIGROUP, self.Edt_PosX))
    local nPosY = tonumber(Edt_GetTxt(self.UIGROUP, self.Edt_PosY))
    if nPosX and nPosY then
      if self.bCurMap == 1 then
        if self.nCanvasFlagId and self.nCanvasFlagId ~= 0 then
          self:ClearFlagAndLine()
        end
      end
      self:DrawFlag(nPosX * 8, nPosY * 16)
    end
  end

  if szWndName == self.Btn_MapSearch then
    self:OnSearch(szSearchTypeMap)
  end
  if szWndName == self.Btn_NpcSearch then
    self:OnSearch(szSearchTypeNpc)
  end
end

function uiWorldMap_Sub:OnOpen(nMapId, nX, nY)
  if nMapId ~= self.nCurMapId then
    self.nCurMapId = nMapId
    self:CleanUp()
  end
  self.CurShowMapId = nMapId
  self.nMapControlId = tbMap:CreateMapControl(self.CurShowMapId, self.UIGROUP, self.IMAGE_FRAME, self.IMAGE_SUBMAP, self.IMAGE_MARK)
  Wnd_SetEnable(self.UIGROUP, self.BTN_WORLDMAP_SUB, 0)
  if self.nMapControlId and (self.nMapControlId ~= 0) then
    local nCurMapId, nWorldPosX, nWorldPosY = me.GetWorldPos()
    if not MODULE_GAMESERVER then
      nCurMapId = me.nTemplateMapId
    end
    if nMapId == nCurMapId then
      self.bCurMap = 1
      Wnd_Show(self.UIGROUP, self.IMAGE_MARK)
      tbMap:InitControl(self.nMapControlId, 1)
      tbMap:SetMePos(self.nMapControlId, nWorldPosX, nWorldPosY)
      tbMap:ChangePos(self.nMapControlId, nWorldPosX, nWorldPosY)
    else
      tbMap:InitControl(self.nMapControlId, 0)
      Wnd_Hide(self.UIGROUP, self.IMAGE_MARK)
      Wnd_SetEnable(self.UIGROUP, self.BTN_WORLDMAP_SUB, 1)
    end
  end

  local szMapName, szMapPath = GetMapPath(nMapId)
  local bReadSuccess = self:ReadNpcInfo(nMapId) -- TODO: 取得地图所对应的配置文件
  if bReadSuccess then
    bReadSuccess = self:ReadNpcAliasInfo(nMapId)
  end
  self.nFlagWidth, self.nFlagHeight = Canvas_GetImageSize(self.UIGROUP, self.IMAGE_SUBMAP, self.FLAGSPRPATH)

  if bReadSuccess then
    self.tbNpcAliasInfo = self.tbNpcAliasAllInfo[nMapId]
    for i = 1, #self.tbNpcInfo do
      local szSprPath = self.tbNpcInfo[i][6]
      local nImageWidth, nImageHeight = Canvas_GetImageSize(self.UIGROUP, self.IMAGE_SUBMAP, szSprPath)
      --改为0，0不显示
      self.tbCanvasId[i] = {}
      if self.tbNpcInfo[i][1] > 0 and self.tbNpcInfo[i][2] > 0 then
        local nImagePosX = self.tbNpcInfo[i][1] - nImageWidth / 2
        local nImagePosY = self.tbNpcInfo[i][2] - nImageHeight / 2
        local nImageId = Canvas_CreateImage(self.UIGROUP, self.IMAGE_SUBMAP, nImagePosX, nImagePosY, szSprPath, 1)
        self.tbCanvasId[i][1] = nImageId
      end
      local nFontSize = self.tbNpcInfo[i][4]
      local szText = self.tbNpcInfo[i][3]
      if self.tbNpcInfo[i][7] > 0 and self.tbNpcInfo[i][8] > 0 then
        local nTextPosX = self.tbNpcInfo[i][7] - (nFontSize * #szText) / 4 -- TODO: 把中心X坐标转换成左上角绘制X坐标
        local nTextPosY = self.tbNpcInfo[i][8] - nFontSize / 2 -- TODO: 把中心Y坐标转换成左上角绘制Y坐标
        local nTextId = Canvas_CreateText(self.UIGROUP, self.IMAGE_SUBMAP, nFontSize, szText, self.tbNpcInfo[i][5], nTextPosX, nTextPosY)
        self.tbCanvasId[i][2] = nTextId
      end
    end
  end

  self:ReadSubMapInfo()
  self:ReadNpcColor(self.NPCCOLORPATH)

  self:ReadNoAreaMapId(self.NOAREAMAPSETPATH) -- TODO: 读取没有对应二级地图的配置文件

  Wnd_SetEnable(self.UIGROUP, self.BTN_WORLDMAP_AREA, 1)
  Wnd_SetEnable(self.UIGROUP, self.BTN_WORLDMAP_GlOBAL, 1)
  local szMapName, szCountry = self:GetMapNameByMapId(nMapId)
  if szCountry == "" then
    Wnd_SetEnable(self.UIGROUP, self.BTN_WORLDMAP_AREA, 0)
  end
  Txt_SetTxt(self.UIGROUP, self.TXT_AREA, szMapName)
  Edt_SetTxt(self.UIGROUP, self.Edt_MapName, szDefaultMapName)
  Edt_SetTxt(self.UIGROUP, self.Edt_NpcName, szDefaultNpcName)

  tbMapBar:SetCurText(szCountry)
  tbMapBar:FillComboBox(self.UIGROUP, self.COMBOBOX_WORLDMAP)

  local nDestX, nDestY = me.GetCurAutoPath()
  if nDestX then
    self:DrawFlag(nDestX, nDestY)
  end

  if self.bCurMap == 1 then
    self.nTeamTimerId = tbTimer:Register(self.TEAMMATETIME, self.OnTimerTeam, self)
  end

  Wnd_SetVisible(self.UIGROUP, self.Scr_MapLookup, 0)
  Wnd_SetVisible(self.UIGROUP, self.Scr_NpcLookup, 0)
  Wnd_SetVisible(self.UIGROUP, self.IMAGE_TARGET_MARK, 0)
  self:Sync_Position()
  if nX and nY then
    local nSprPosX, nSprPosY = tbMap:WorldPosToImgPos(self.nMapControlId, nX, nY)
    self:ShowTarget(nSprPosX, nSprPosY)
  end
end

function uiWorldMap_Sub:OnClose()
  tbMap:DestroyMapControl(self.nMapControlId)
  for i = 1, #self.tbCanvasId do
    if self.tbCanvasId[i][1] then
      Canvas_DestroyImage(self.UIGROUP, self.IMAGE_SUBMAP, self.tbCanvasId[i][1])
    end
    if self.tbCanvasId[i][2] then
      Canvas_DestroyText(self.UIGROUP, self.IMAGE_SUBMAP, self.tbCanvasId[i][2])
    end
  end
  self.tbCanvasId = {} --关闭时清空
  if self.nCanvasLineId ~= 0 then
    Canvas_DestroyLine(self.UIGROUP, self.IMAGE_SUBMAP, self.nCanvasLineId)
  end

  if self.nCanvasFlagId ~= 0 then
    Canvas_DestroyImage(self.UIGROUP, self.IMAGE_SUBMAP, self.nCanvasFlagId)
  end

  if self.nTimerId and self.nTimerId ~= 0 then
    tbTimer:Close(self.nTimerId)
    self.nTimerId = 0
  end

  if self.nTeamTimerId and self.nTeamTimerId ~= 0 then
    tbTimer:Close(self.nTeamTimerId)
    self.nTeamTimerId = 0
    self:OnCancelPlayer()
    self:OnCancelTeam()
    self:OnCancelHighLight()
  end
  self:DestoryNpcEffect()
end

function uiWorldMap_Sub:OnComboBoxIndexChange(szWnd, nIndex)
  if szWnd == self.COMBOBOX_WORLDMAP then
    tbMapBar:SelectItem(self.UIGROUP, szWnd, nIndex)
  end
end

function uiWorldMap_Sub:OnEscExclusiveWnd(szWnd)
  UiManager:CloseWindow(self.UIGROUP)
end

function uiWorldMap_Sub:OnCancelTeam()
  if self.tbTeamMatePoint then
    for i, tbId in ipairs(self.tbTeamMatePoint) do
      Canvas_DestroyPoint(self.UIGROUP, self.IMAGE_SUBMAP, tbId[1])
      Canvas_DestroyText(self.UIGROUP, self.IMAGE_SUBMAP, tbId[2])
    end
  end
  self.tbTeamMatePoint = {}
end

function uiWorldMap_Sub:OnCancelPlayer()
  if self.tbPlayerPoint then
    for i, nId in ipairs(self.tbPlayerPoint) do
      Canvas_DestroyPoint(self.UIGROUP, self.IMAGE_SUBMAP, nId)
    end
  end
  self.tbPlayerPoint = {}
end

function uiWorldMap_Sub:OnCancelHighLight()
  if self.tbHighLightPoint then
    for i, tbHighLight in ipairs(self.tbHighLightPoint) do
      Canvas_DestroyImage(self.UIGROUP, self.IMAGE_SUBMAP, tbHighLight[1])
      Canvas_DestroyText(self.UIGROUP, self.IMAGE_SUBMAP, tbHighLight[2])
    end
  end
  self.tbHighLightPoint = {}
end

function uiWorldMap_Sub:OnTimerTeam()
  self:OnCancelTeam()
  self:OnCancelPlayer()
  self:OnCancelHighLight()
  self:ShowPlayerInfo()
  self:DrawNpcEffect()
  self:DrawHighLight()
end

function uiWorldMap_Sub:ShowPlayerInfo()
  if self.bDisable == 1 then
    return
  end
  local tbNpc, tbFriend
  local nFontId = 12
  tbNpc = SyncNpcInfo()
  if tbNpc then
    for i, tbNpcInfo in ipairs(tbNpc) do
      if tbNpcInfo then
        local nPosX, nPosY = tbMap:WorldPosToImgPos(self.nMapControlId, tbNpcInfo.nX / 2, tbNpcInfo.nY)
        if tbNpcInfo.szName then -- 队友
          local absTxtPosX = nPosX - ((nFontId / 2) * (string.len(tbNpcInfo.szName) / 2)) / 2
          local absTxtPosY = nPosY + (nFontId / 2)
          local nTextId = Canvas_CreateText(self.UIGROUP, self.IMAGE_SUBMAP, nFontId, tbNpcInfo.szName, self.tbNpcColor[0], absTxtPosX, absTxtPosY)
          local nPointId = Canvas_CreatePoint(self.UIGROUP, self.IMAGE_SUBMAP, self.tbNpcColor[0], nPosX, nPosY)
          self.tbTeamMatePoint[#self.tbTeamMatePoint + 1] = { nPointId, nTextId }
        else
          --if tbNpcInfo.nType ~= 2 then --  普通npc不显示
          local nPointId = Canvas_CreatePoint(self.UIGROUP, self.IMAGE_SUBMAP, self.tbNpcColor[tbNpcInfo.nType], nPosX, nPosY)
          self.tbPlayerPoint[#self.tbPlayerPoint + 1] = nPointId
          --end
        end
      end
    end
  end
end

function uiWorldMap_Sub:Sync_Position()
  if self.nMapControlId and (self.nMapControlId ~= 0) and (self.bCurMap == 1) then
    local nMapId, nCurWorldPosX, nCurWorldPosY = me.GetWorldPos()
    if not MODULE_GAMESERVER then
      nMapId = me.nTemplateMapId
    end
    if self.nCanvasFlagId and self.nCanvasFlagId ~= 0 then
      self:DrawLine()
    end

    tbMap:SetMePos(self.nMapControlId, nCurWorldPosX, nCurWorldPosY)
    tbMap:ChangePos(self.nMapControlId, nCurWorldPosX, nCurWorldPosY)

    local nX = math.floor(nCurWorldPosX / 8)
    local nY = math.floor(nCurWorldPosY / 16)
    Txt_SetTxt(self.UIGROUP, self.TXT_CURPOS, "当前位置：" .. nX .. "/" .. nY)
  end
end

function uiWorldMap_Sub:DrawLine()
  local nMapId, nCurWorldPosX, nCurWorldPosY = me.GetWorldPos()
  if not MODULE_GAMESERVER then
    nMapId = me.nTemplateMapId
  end
  if nMapId ~= self.CurShowMapId then
    --如果不是同一个地图，只标旗，不画线
    return 0
  end
  if self.nCanvasLineId and self.nCanvasLineId ~= 0 then
    Canvas_DestroyLine(self.UIGROUP, self.IMAGE_SUBMAP, self.nCanvasLineId)
    self.nCanvasLineId = 0
  end
  local nX, nY = tbMap:WorldPosToImgPos(self.nMapControlId, nCurWorldPosX, nCurWorldPosY)
  self.nCanvasLineId = Canvas_CreateLine(self.UIGROUP, self.IMAGE_SUBMAP, nX, nY, self.nFlagDestPosX, self.nFlagDestPosY, 0xFF84D729)
end

function uiWorldMap_Sub:OnCanvasClick(szWnd, nX, nY)
  if szWnd == self.IMAGE_SUBMAP then
    local nWorldPosX, nWorldPosY = tbMap:ImgPosToWorldPos(self.nMapControlId, nX, nY)
    CoreEventNotify(UiNotify.emCOREEVENT_UI_MINIMAP_CLICK, nWorldPosX, nWorldPosY, self.CurShowMapId)
  end
end

function uiWorldMap_Sub:ClearFlagAndLine()
  if UiManager:WindowVisible(self.UIGROUP) == 1 then
    if self.nCanvasFlagId and self.nCanvasFlagId ~= 0 then
      Canvas_DestroyImage(self.UIGROUP, self.IMAGE_SUBMAP, self.nCanvasFlagId)
      self.nCanvasFlagId = 0
    end

    if self.nCanvasLineId and self.nCanvasLineId ~= 0 then
      Canvas_DestroyLine(self.UIGROUP, self.IMAGE_SUBMAP, self.nCanvasLineId)
      self.nCanvasLineId = 0
    end
  end
end

function uiWorldMap_Sub:Change_Map()
  if UiManager:WindowVisible(self.UIGROUP) == 1 then
    UiManager:CloseWindow(Ui.UI_WORLDMAP_SUB)
    local nCurMapId, nWorldPosX, nWorldPosY = me.GetWorldPos()
    if not MODULE_GAMESERVER then
      nCurMapId = me.nTemplateMapId
    end
    UiManager:OpenWindow(Ui.UI_WORLDMAP_SUB, nCurMapId)
  end
end

function uiWorldMap_Sub:Disable(bOk)
  self.bDisable = bOk
end

function uiWorldMap_Sub:StartAutoPath(nX, nY)
  if UiManager:WindowVisible(self.UIGROUP) == 1 then
    if tbAutoPath.tbMiniMapDesPos.nMapId and tbAutoPath.tbMiniMapDesPos.nMapId == self.CurShowMapId then
      nX = tbAutoPath.tbMiniMapDesPos.nX
      nY = tbAutoPath.tbMiniMapDesPos.nY
    end
    self:DrawFlag(nX, nY)
  end
end

function uiWorldMap_Sub:DrawFlag(nX, nY)
  local nImgX, nImgY = tbMap:WorldPosToImgPos(self.nMapControlId, nX, nY)
  self.nFlagDestPosX = nImgX
  self.nFlagDestPosY = nImgY
  local nDrawFlagX = self.nFlagDestPosX -- 实际坐标转换成绘制时的左上角坐标
  local nDrawFlagY = self.nFlagDestPosY - self.nFlagHeight
  self:ClearFlagAndLine()
  self.nCanvasFlagId = Canvas_CreateImage(self.UIGROUP, self.IMAGE_SUBMAP, nDrawFlagX, nDrawFlagY, self.FLAGSPRPATH, 1)
  self:DrawLine()
end

function uiWorldMap_Sub:DrawNpcEffect()
  local tbDestroyCont = {}
  local tbCreateCont = {}

  local tbCurNpcEffect = GetNpcMapEffect()

  -- 取得需要取消, 以及效果有更新的Npc 效果数据
  for i, tbLastEffect in ipairs(self.tbLastNpcEffect) do
    local bDestory = 1
    for j, tbCurEffect in ipairs(tbCurNpcEffect) do
      if (tbLastEffect.nNpcId == tbCurEffect.nNpcId) and (tbLastEffect.szEffectSpr == tbCurEffect.szEffectSpr) then
        bDestory = 0
        break
      end
    end
    if bDestory == 1 then
      tbDestroyCont[#tbDestroyCont + 1] = tbLastEffect
    end
  end

  -- 取得新创建的, 以及效果有更新的Npc 效果数据
  for i, tbCurEffect in ipairs(tbCurNpcEffect) do
    local bCreate = 1
    for j, tbLastEffect in ipairs(self.tbLastNpcEffect) do
      if (tbLastEffect.nNpcId == tbCurEffect.nNpcId) and (tbLastEffect.szEffectSpr == tbCurEffect.szEffectSpr) then
        bCreate = 0
        break
      end
    end
    if bCreate == 1 then
      tbCreateCont[#tbCreateCont + 1] = tbCurEffect
    end
  end

  -- 删除当前与上次刷新有改变的 Animation
  for i, tbDestroy in ipairs(tbDestroyCont) do
    if tbDestroy then
      Canvas_DestroyAnimation(self.UIGROUP, self.IMAGE_SUBMAP, self.tbAnimation[tbDestroy.nNpcId])
      self.tbAnimation[tbDestroy.nNpcId] = nil
      for i, tbRemove in ipairs(self.tbLastNpcEffect) do
        if tbRemove and tbRemove.nNpcId == tbDestroy.nNpcId and tbRemove.szEffectSpr == tbDestroy.szEffectSpr then
          table.remove(self.tbLastNpcEffect, i)
        end
      end
    end
  end

  -- 创建当前与上次刷新有改变的 Animation
  for i, tbCreate in ipairs(tbCreateCont) do
    if tbCreate then
      local nImgX, nImgY = tbMap:WorldPosToImgPos(self.nMapControlId, tbCreate.nX / 2, tbCreate.nY)
      local nEffectSprWidth, nEffectSprHeight = Canvas_GetImageSize(self.UIGROUP, self.IMAGE_SUBMAP, tbCreate.szEffectSpr)
      nImgX = nImgX - nEffectSprWidth / 2
      nImgY = nImgY - nEffectSprHeight / 2
      local nAnimationId = Canvas_CreateAnimation(self.UIGROUP, self.IMAGE_SUBMAP, nImgX, nImgY, tbCreate.szEffectSpr, 1)
      self.tbAnimation[tbCreate.nNpcId] = nAnimationId
      table.insert(self.tbLastNpcEffect, tbCreate)
    end
  end
end

function uiWorldMap_Sub:DestoryNpcEffect()
  for i, nAnimationId in pairs(self.tbAnimation) do
    if nAnimationId then
      Canvas_DestroyAnimation(self.UIGROUP, self.IMAGE_SUBMAP, nAnimationId)
    end
  end
end

function uiWorldMap_Sub:DrawHighLight()
  local tbHighLightCont = tbMap:GetMapHighLightCont()
  local nCurTime = GetCurrentTime()
  if tbHighLightCont then
    for nId, tbHighLight in pairs(tbHighLightCont) do
      if nId and (tbHighLight[5] > nCurTime or tbHighLight[5] == -1) then
        local nWorldPosX, nWorldPosY = GetSpecificNpcPos(nId)
        if nWorldPosX and nWorldPosY then
          tbHighLight[2] = nWorldPosX
          tbHighLight[3] = nWorldPosY
        end
        local nPointX, nPointY = tbMap:WorldPosToImgPos(self.nMapControlId, tbHighLight[2], tbHighLight[3])
        local nSprWidth, nSprHeight = Canvas_GetImageSize(self.UIGROUP, self.IMAGE_SUBMAP, tbHighLight[4])
        local nImgX = nPointX - nSprWidth / 2
        local nImgY = nPointY - nSprHeight / 2
        local nImgHighLightId = Canvas_CreateImage(self.UIGROUP, self.IMAGE_SUBMAP, nImgX, nImgY, tbHighLight[4], 1)
        local nFontSize = 14
        local nTxtX = nPointX - (string.len(tbHighLight[1]) * nFontSize / 4)
        local nTxtY = nImgY + nSprHeight
        local nTextHighLightId = Canvas_CreateText(self.UIGROUP, self.IMAGE_SUBMAP, nFontSize, tbHighLight[1], 0xff00ffff, nTxtX, nTxtY)

        self.tbHighLightPoint[#self.tbHighLightPoint + 1] = { nImgHighLightId, nTextHighLightId }
      else
        tbMap:DelMapHighLightById(nId)
      end
    end
  end
end

function uiWorldMap_Sub:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_POSITION, self.Sync_Position },
    { UiNotify.emCOREEVENT_SYNC_CURRENTMAP, self.Change_Map },
    { UiNotify.emCOREEVENT_STOP_AUTOPATH, self.ClearFlagAndLine },
    { UiNotify.emCOREEVENT_START_AUTOPATH, self.StartAutoPath },
  }
  return tbRegEvent
end
