Ui.tbLogic.tbMapBar = {}

local tbMapBar = Ui.tbLogic.tbMapBar
tbMapBar.WORLDMAP_GLOBAL = { "金国", "大理国", "西夏蒙古", "宋国西部", "宋国东部" }
tbMapBar.WORLDTITLE = "世界地图"

function tbMapBar:Init()
  self.szCurSelectText = ""
end

function tbMapBar:FillComboBox(szUiGroup, szWnd)
  ClearComboBoxItem(szUiGroup, szWnd)
  local nItemCount = 0
  for i = 1, #self.WORLDMAP_GLOBAL do
    if ComboBoxAddItem(szUiGroup, szWnd, i, self.WORLDMAP_GLOBAL[i]) == 1 then
      nItemCount = nItemCount + 1
    end
  end
  ComboBoxSetCurText(szUiGroup, szWnd, self.szCurSelectText)
  if szUiGroup == Ui.UI_WORLDMAP_GLOBAL then
    ComboBoxSetCurText(szUiGroup, szWnd, self.WORLDTITLE)
  end
  return nItemCount
end

function tbMapBar:SetCurText(szText)
  self.szCurSelectText = szText
end

function tbMapBar:GetItemName(nItem)
  return self.WORLDMAP_GLOBAL[nItem + 1]
end

function tbMapBar:SelectItem(szUiGroup, szWnd, nItem)
  --local nVisible	= UiManager:WindowVisible(szUiGroup);
  self.szCurSelectText = self.WORLDMAP_GLOBAL[nItem + 1]
  UiManager:CloseWindow(szUiGroup)
  UiManager:OpenWindow(Ui.UI_WORLDMAP_AREA, self.WORLDMAP_GLOBAL[nItem + 1])
end

function tbMapBar:SelectCurItem(szUiGroup)
  UiManager:CloseWindow(szUiGroup)
  UiManager:OpenWindow(Ui.UI_WORLDMAP_AREA, self.szCurSelectText)
end

function tbMapBar:OpenSubMap()
  if UiManager:WindowVisible(Ui.UI_WORLDMAP_AREA) == 1 then
    UiManager:CloseWindow(Ui.UI_WORLDMAP_AREA)
  elseif UiManager:WindowVisible(Ui.UI_WORLDMAP_GLOBAL) == 1 then
    UiManager:CloseWindow(Ui.UI_WORLDMAP_GLOBAL)
  else
    local nCurMapId, nWorldPosX, nWorldPosY = me.GetWorldPos()
    if not MODULE_GAMESERVER then
      nCurMapId = me.nTemplateMapId
    end
    UiManager:SwitchWindow(Ui.UI_WORLDMAP_SUB, nCurMapId)
  end
end
