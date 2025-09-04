local uiWorldMap_Global = Ui:GetClass("worldmap_global")
local tbMapBar = Ui.tbLogic.tbMapBar

uiWorldMap_Global.IMAGE_WORLDMAP = "ImgWorldMap"
uiWorldMap_Global.IMAGE_MARK = "ImgMark"
uiWorldMap_Global.BTN_CLOSE = "BtnClose"
uiWorldMap_Global.BTN_SEARCH = "BtnSearch"
uiWorldMap_Global.COMBOBOX_WORLDMAP = "ComboxCountry"
uiWorldMap_Global.BTN_SUB = "BtnWorldMap_Sub"
uiWorldMap_Global.BTN_DOMAIN = "BtnWorldMap_Domain"
uiWorldMap_Global.BTN_AREA = "BtnWorldMap_Area"

uiWorldMap_Global.PIC_WORLD_MAIN = "\\image\\ui\\002a\\worldmap\\global\\main" .. UiManager.IVER_szVnSpr
uiWorldMap_Global.IMGPATH = "\\image\\ui\\001a\\worldmap\\icon\\"
uiWorldMap_Global.WORLDMAPSETPATH = "worldmap\\player.txt"
uiWorldMap_Global.MARKOFFSETPOSX = 0
uiWorldMap_Global.MARKOFFSETPOSY = 25
uiWorldMap_Global.WND_COUNT = 50
uiWorldMap_Global.BTNCONT = { "BtnJin", "BtnDaLi", "BtnMengGu", "BtnSong1", "BtnSong2" }

function uiWorldMap_Global:Init()
  self.tbMapInfo = {}
  self.nCurSong1Count = 1
  self.nCurSong2Count = 11
  self.nJinCount = 21
  self.nDaLiCount = 31
  self.nMengGuCount = 41
  self.nShowMapId = 0
  self.tbGlobalMap_MapCont = {}
  for i = 1, #tbMapBar.WORLDMAP_GLOBAL do
    self.tbGlobalMap_MapCont[i] = { tbMapBar.WORLDMAP_GLOBAL[i], self.BTNCONT[i] }
  end

  local szFile = GetActualPath(self.WORLDMAPSETPATH)
  local pTabFile = KIo.OpenTabFile(szFile)
  if not pTabFile then
    return 0
  end

  local nHeight = pTabFile.GetHeight()
  for i = 2, nHeight do
    local nMapId = pTabFile.GetInt(i, 1)
    local nXpos = pTabFile.GetInt(i, 2)
    local nYpos = pTabFile.GetInt(i, 3)
    self.tbMapInfo[i - 1] = { nMapId, nXpos, nYpos }
  end
  KIo.CloseTabFile(pTabFile) -- 释放对象
end

function uiWorldMap_Global:WriteStatLog()
  Log:Ui_SendLog("打开大地图", 1)
end

function uiWorldMap_Global:OnOpen(nMapId)
  self:WriteStatLog()
  local szMapName, szCountry = Ui(Ui.UI_WORLDMAP_SUB):GetMapNameByMapId(nMapId)
  if szCountry == "" then
    Wnd_SetEnable(self.UIGROUP, self.BTN_AREA, 0)
  else
    self.nShowMapId = nMapId
  end
  Img_SetImage(self.UIGROUP, self.IMAGE_WORLDMAP, 1, self.PIC_WORLD_MAIN)
  tbMapBar:FillComboBox(self.UIGROUP, self.COMBOBOX_WORLDMAP)
  self:MarkPos()
end

function uiWorldMap_Global:OnEscExclusiveWnd(szWnd)
  UiManager:CloseWindow(self.UIGROUP)
end

function uiWorldMap_Global:OnComboBoxIndexChange(szWnd, nIndex)
  if szWnd == self.COMBOBOX_WORLDMAP then
    tbMapBar:SelectItem(self.UIGROUP, szWnd, nIndex)
  end
end

function uiWorldMap_Global:OnButtonClick(szWndName, nParam)
  if szWndName == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end

  if szWndName == self.BTN_DOMAIN then
    UiManager:OpenWindow(Ui.UI_WORLDMAP_DOMAIN, self.nShowMapId)
    UiManager:CloseWindow(self.UIGROUP)
  end

  if szWndName == self.BTN_AREA then
    tbMapBar:SelectCurItem(self.UIGROUP)
  end

  if szWndName == self.BTN_SUB then
    UiManager:OpenWindow(Ui.UI_WORLDMAP_SUB, me.nTemplateMapId)
    UiManager:CloseWindow(self.UIGROUP)
  end

  for i = 1, #self.tbGlobalMap_MapCont do
    if self.tbGlobalMap_MapCont[i][2] == szWndName then
      tbMapBar:SelectItem(self.UIGROUP, szWnd, i - 1)
    end
  end
end

function uiWorldMap_Global:MarkPos()
  local nNowMap = me.GetWorldPos()
  if not MODULE_GAMESERVER then
    nNowMap = me.nTemplateMapId
  end
  if self.tbMapInfo then
    for i = 1, #self.tbMapInfo do
      if nNowMap == self.tbMapInfo[i][1] then
        Wnd_SetPos(self.UIGROUP, self.IMAGE_MARK, self.tbMapInfo[i][2] - self.MARKOFFSETPOSX, self.tbMapInfo[i][3] - self.MARKOFFSETPOSY)
        Img_PlayAnimation(self.UIGROUP, self.IMAGE_MARK, 1)
      end
    end
  end
end

function uiWorldMap_Global:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_CURRENTMAP, self.MarkPos },
  }
  return tbRegEvent
end
