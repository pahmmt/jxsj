local uiWorldMap_Area = Ui:GetClass("worldmap_area")
local tbMapBar = Ui.tbLogic.tbMapBar

uiWorldMap_Area.IMAGE_MARK = "ImgMark"
uiWorldMap_Area.IMAGE_AREAMAP = "ImgAreaMap"
uiWorldMap_Area.BTN_CLOSE = "BtnClose"
uiWorldMap_Area.TXT_AREA = "TxtArea"

uiWorldMap_Area.BTN_WORLDMAP_SUB = "BtnWorldMap_Sub"
uiWorldMap_Area.BTN_WORLDMAP_GlOBAL = "BtnWorldMap_Global"
uiWorldMap_Area.BTN_DOMAIN = "BtnWorldMap_Domain"

uiWorldMap_Area.COMBOBOX_WORLDMAP = "ComboxArea"

uiWorldMap_Area.IMGPATH = "\\image\\ui\\002a\\worldmap\\icon\\"
uiWorldMap_Area.IMGSUBMAPPATH = "\\image\\ui\\002a\\worldmap\\area\\"
uiWorldMap_Area.AREAMAPSETPATH = "worldmap\\"
uiWorldMap_Area.MARKOFFSETPOSX = 0
uiWorldMap_Area.MARKOFFSETPOSY = 15
uiWorldMap_Area.SPRCONT = { "jin.spr", "dali.spr", "xixia.spr", "song_1.spr", "song_2.spr" }
uiWorldMap_Area.SEARCH_MARK = "\\image\\ui\\001a\\worldmap\\worldmap_search_mark.spr"
uiWorldMap_Area.TABLEFILECONT = {
  "area_jin.txt",
  "area_dali.txt",
  "area_xixia_menggu.txt",
  "area_song_1.txt",
  "area_song_2.txt",
}

uiWorldMap_Area.TABLEFILECONTEXIT = {
  "exit_area_jin.txt",
  "exit_area_dali.txt",
  "exit_area_xixia_menggu.txt",
  "exit_area_song_1.txt",
  "exit_area_song_2.txt",
}

function uiWorldMap_Area:Init()
  self.tbAreaMap_MapSetting = {}
  self.tbMapInfo = {}
  self.tbMapExitInfo = {}
  self.tbCanvasId = {}
  self.tbCanvasExitId = {}

  for i = 1, #tbMapBar.WORLDMAP_GLOBAL do
    self.tbAreaMap_MapSetting[i] = {
      tbMapBar.WORLDMAP_GLOBAL[i],
      self.SPRCONT[i],
      self.TABLEFILECONT[i],
      self.TABLEFILECONTEXIT[i],
    }
  end
end

function uiWorldMap_Area:ReadMapInfo(szMapName)
  local szFile = GetActualPath(szMapName)
  local pTabFile = KIo.OpenTabFile(szFile)
  if not pTabFile then
    Ui:Output("[ERR] uiWorldMap_Area配置路径不正确: " .. szFile)
    return 0
  end
  local nHeight = pTabFile.GetHeight()
  for i = 2, nHeight do
    local nId = pTabFile.GetInt(i, 1)
    local nMapId = pTabFile.GetInt(i, 2)
    local nIconPosX = pTabFile.GetInt(i, 3)
    local nIconPosY = pTabFile.GetInt(i, 4)
    local szSprPath = pTabFile.GetStr(i, 5)
    local szTxtMapName = pTabFile.GetStr(i, 6)
    local szTxtPosX = pTabFile.GetInt(i, 7)
    local szTxtPosY = pTabFile.GetInt(i, 8)
    local nTxtFontId = pTabFile.GetInt(i, 9)
    local szTxtColor = pTabFile.GetStr(i, 10)
    self.tbMapInfo[nId] = { nMapId, nIconPosX, nIconPosY, szSprPath, szTxtMapName, szTxtPosX, szTxtPosY, nTxtFontId, szTxtColor }
  end
  KIo.CloseTabFile(pTabFile) -- 释放对象
  return 1
end

function uiWorldMap_Area:ReadMapExitInfo(szMapName)
  local szFile = GetActualPath(szMapName)
  local pTabFile = KIo.OpenTabFile(szFile)
  if not pTabFile then
    Ui:Output("[ERR] uiWorldMap_Area配置路径不正确: " .. szFile)
    return 0
  end
  local nHeight = pTabFile.GetHeight()
  for i = 2, nHeight do
    local nId = pTabFile.GetInt(i, 1)
    local nMapId = pTabFile.GetInt(i, 2)
    local nXpos = pTabFile.GetInt(i, 3)
    local nYpos = pTabFile.GetInt(i, 4)
    local szMapPath = pTabFile.GetStr(i, 5)
    local szText = pTabFile.GetStr(i, 6)
    local szarrange = pTabFile.GetStr(i, 7)
    self.tbMapExitInfo[nId] = { nMapId, nXpos, nYpos, szMapPath, szText, szarrange }
  end
  KIo.CloseTabFile(pTabFile) -- 释放对象
  return 1
end

function uiWorldMap_Area:MarkPos(nSetMapId)
  local nNowMap, nNowPosX, nNowPosY = me.GetWorldPos()
  if not MODULE_GAMESERVER then
    nNowMap = me.nTemplateMapId
  end

  local nMarkMapId = 0
  if self.bSearchMode and self.bSearchMode == 1 then
    nMarkMapId = self.nSearchId
    Img_SetImage(self.UIGROUP, self.IMAGE_MARK, 1, self.SEARCH_MARK)
  else
    nMarkMapId = nNowMap
  end

  if tonumber(nSetMapId) and tonumber(nSetMapId) > 0 then
    nMarkMapId = nSetMapId
    Img_SetImage(self.UIGROUP, self.IMAGE_MARK, 1, self.SEARCH_MARK)
  end

  if self.tbMapInfo then
    for i = 1, #self.tbMapInfo do
      if nMarkMapId == self.tbMapInfo[i][1] then
        Wnd_Show(self.UIGROUP, self.IMAGE_MARK)
        Wnd_BringTop(self.UIGROUP, self.IMAGE_MARK)
        Wnd_SetPos(self.UIGROUP, self.IMAGE_MARK, self.tbMapInfo[i][2] - self.MARKOFFSETPOSX, self.tbMapInfo[i][3] - self.MARKOFFSETPOSY)
        Img_PlayAnimation(self.UIGROUP, self.IMAGE_MARK, 1)
      end
    end
  end
end

function uiWorldMap_Area:MarkSearchPos() end

function uiWorldMap_Area:CancelMark()
  Wnd_SetPos(self.UIGROUP, self.IMAGE_MARK, 0, 0)
end

function uiWorldMap_Area:OnOpen(szAreaName, nMapId)
  self.bSearchMode = 0
  if nMapId then
    self.bSearchMode = 1
    self.nSearchId = nMapId
  end
  tbMapBar:FillComboBox(self.UIGROUP, self.COMBOBOX_WORLDMAP)
  self:LoadSetting(szAreaName)
end

function uiWorldMap_Area:LoadSetting(szAreaName)
  Wnd_Hide(self.UIGROUP, self.IMAGE_MARK)
  self:ClearCanvas()
  self:Init()
  local bReadSuccess = 0
  for i = 1, #self.tbAreaMap_MapSetting do
    if self.tbAreaMap_MapSetting[i][1] == szAreaName then
      Img_SetImage(self.UIGROUP, self.IMAGE_AREAMAP, 1, self.IMGSUBMAPPATH .. self.tbAreaMap_MapSetting[i][2])
      bReadSuccess = self:ReadMapInfo(self.AREAMAPSETPATH .. self.tbAreaMap_MapSetting[i][3])
      self:ReadMapExitInfo(self.AREAMAPSETPATH .. self.tbAreaMap_MapSetting[i][4])
      break
    end
  end
  if bReadSuccess ~= 0 then
    Canvas_DestroyAllButton(self.UIGROUP, self.IMAGE_AREAMAP)
    for i = 1, #self.tbMapInfo do
      local szMapName, _ = GetMapPath(self.tbMapInfo[i][1])
      local szSprPath = self.IMGPATH .. self.tbMapInfo[i][4]
      local nImageWidth, nImageHeight = Canvas_GetImageSize(self.UIGROUP, self.IMAGE_AREAMAP, szSprPath)
      local nButtonId = Canvas_CreateButton(self.UIGROUP, self.IMAGE_AREAMAP, self.tbMapInfo[i][2], self.tbMapInfo[i][3], nImageWidth, nImageHeight, "", szSprPath, 0)

      local nTextId = Canvas_CreateText(self.UIGROUP, self.IMAGE_AREAMAP, self.tbMapInfo[i][8], self.tbMapInfo[i][5], self.tbMapInfo[i][9], self.tbMapInfo[i][6], self.tbMapInfo[i][7])
      self.tbCanvasId[i] = { self.tbMapInfo[i][1], nImageId, nTextId, nButtonId }
    end
    for i = 1, #self.tbMapExitInfo do
      if self.tbMapExitInfo[i][4] ~= "" then
        local szSprPath = self.IMGPATH .. self.tbMapExitInfo[i][4]
        local nImageWidth, nImageHeight = Canvas_GetImageSize(self.UIGROUP, self.IMAGE_AREAMAP, szSprPath)
        local nButtonId = Canvas_CreateButton(self.UIGROUP, self.IMAGE_AREAMAP, self.tbMapExitInfo[i][2], self.tbMapExitInfo[i][3], nImageWidth, nImageHeight, "", szSprPath, 0)
        table.insert(self.tbCanvasExitId, { self.tbMapExitInfo[i][1], self.tbMapExitInfo[i][6], nButtonId })
      end
    end

    self:MarkPos()
  end
  Txt_SetTxt(self.UIGROUP, self.TXT_AREA, szAreaName)
end

function uiWorldMap_Area:OnComboBoxIndexChange(szWnd, nIndex)
  if szWnd == self.COMBOBOX_WORLDMAP then
    local szAreaName
    szAreaName = tbMapBar:GetItemName(nIndex)
    self:LoadSetting(szAreaName)
  end
end

function uiWorldMap_Area:OnButtonClick(szWndName, nParam)
  if szWndName == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end
  if szWndName == self.BTN_WORLDMAP_GlOBAL then
    UiManager:CloseWindow(self.UIGROUP)
    UiManager:OpenWindow(Ui.UI_WORLDMAP_GLOBAL, me.nTemplateMapId)
  end

  if szWndName == self.BTN_WORLDMAP_SUB then
    UiManager:CloseWindow(self.UIGROUP)
    UiManager:OpenWindow(Ui.UI_WORLDMAP_SUB, me.nTemplateMapId)
  end

  if szWndName == self.BTN_DOMAIN then
    UiManager:CloseWindow(self.UIGROUP)
    UiManager:OpenWindow(Ui.UI_WORLDMAP_DOMAIN, me.nTemplateMapId)
  end
end

function uiWorldMap_Area:OnCanvasRectClick(szWnd, nButtonId)
  for i = 1, #self.tbCanvasId do
    if self.tbCanvasId[i][4] == nButtonId then
      UiManager:OpenWindow(Ui.UI_WORLDMAP_SUB, self.tbCanvasId[i][1])
      UiManager:CloseWindow(self.UIGROUP)
      break
    end
  end
  for i = 1, #self.tbCanvasExitId do
    if self.tbCanvasExitId[i][3] == nButtonId then
      local nMapId = self.tbCanvasExitId[i][1]
      self:LoadSetting(self.tbCanvasExitId[i][2])
      self:MarkPos(nMapId)
      break
    end
  end
end

function uiWorldMap_Area:ClearCanvas()
  for i = 1, #self.tbCanvasId do
    Canvas_DestroyText(self.UIGROUP, self.IMAGE_AREAMAP, self.tbCanvasId[i][3])
  end

  --for i = 1, #self.tbCanvasExitId do
  --	Canvas_DestroyText(self.UIGROUP, self.IMAGE_AREAMAP, self.tbCanvasExitId[i][3]);
  --end
end

function uiWorldMap_Area:OnClose()
  self:ClearCanvas()
  self:CancelMark()
end

function uiWorldMap_Area:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_CURRENTMAP, self.MarkPos },
  }
  return tbRegEvent
end
