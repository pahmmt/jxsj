Ui.tbLogic.tbCoverMgr = {}
local tbCoverMgr = Ui.tbLogic.tbCoverMgr

tbCoverMgr.tbDreamMap = { 570, 571, 572, 587, 2088, 2089 }
tbCoverMgr.tbDreamSpr = {
  a = "\\image\\ui\\001a\\cover\\dream_cover.spr",
  b = "\\image\\ui\\001b\\cover\\dream_cover.spr",
  c = "\\image\\ui\\001c\\cover\\dream_cover.spr",
}

function tbCoverMgr:Init()
  self.nMode = 0
  UiNotify:RegistNotify(UiNotify.emCOREEVENT_COVER_BEGIN, self.OnCoverBegin, self)
  UiNotify:RegistNotify(UiNotify.emCOREEVENT_COVER_END, self.OnCoverEnd, self)
  UiNotify:RegistNotify(UiNotify.emCOREEVENT_SYNC_CURRENTMAP, self.OnMapChange, self)
end

function tbCoverMgr:OnMapChange()
  local nCurMapId, nWorldPosX, nWorldPosY = me.GetWorldPos()
  local bInDream = 0
  for i, nMapId in ipairs(self.tbDreamMap) do
    if nCurMapId == nMapId then -- 当前进入了梦境
      bInDream = 1
    end
  end
  if bInDream == 1 then
    if UiManager:WindowVisible(Ui.UI_COVER) == 1 then
      return
    end
    Img_SetImage(Ui.UI_COVER, "Main", 1, "")
    Img_SetImage(Ui.UI_COVER, "Main", 1, self.tbDreamSpr[Ui.szMode])
    UiManager:OpenWindow(Ui.UI_COVER)
  else
    UiManager:CloseWindow(Ui.UI_COVER)
  end
end

function tbCoverMgr:OnCoverBegin()
  UiManager:OpenWindow(Ui.UI_COVER)
end

function tbCoverMgr:OnCoverEnd()
  UiManager:CloseWindow(Ui.UI_COVER)
end
