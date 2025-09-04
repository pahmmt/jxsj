local uiKeyTutorial = Ui:GetClass("keytutorial")
local tbTimer = Ui.tbLogic.tbTimer

uiKeyTutorial.NUM_EFFECT = 10

uiKeyTutorial.IMG_GRID = {}
for i = 1, uiKeyTutorial.NUM_EFFECT do
  uiKeyTutorial.IMG_GRID[i] = "ImgGrid" .. i
end

-- effect
-- {XXX（特效图素）, XXX（特效播放次数）, XXX（最多持续多少时间）}
uiKeyTutorial.IMG_EFFECT_SPR = {
  [0] = "",
  [1] = { "\\image\\ui\\001a\\main\\popo\\f.spr", nil, 8 },
  [2] = { "\\image\\ui\\001a\\main\\popo\\f1.spr", nil, 8 },
  [3] = { "\\image\\ui\\001a\\main\\popo\\f2.spr", nil, 8 },
  [4] = { "\\image\\ui\\001a\\main\\popo\\f3.spr", nil, 8 },
  [5] = { "\\image\\ui\\001a\\main\\popo\\f4.spr", nil, 8 },
  [6] = { "\\image\\ui\\001a\\main\\popo\\sparce.spr", nil, 8 },
  [7] = { "\\image\\ui\\001a\\main\\popo\\tab.spr", nil, 8 },
  [8] = { "\\image\\ui\\001a\\main\\popo\\lmouse.spr", nil, 8 },
  [9] = { "\\image\\ui\\001a\\main\\popo\\rmouse.spr", nil, 8 },
  [10] = { "\\image\\ui\\001a\\main\\popo\\m.spr", nil, 8 },
}

function uiKeyTutorial:Init()
  self.nFlashTimes = 0
end

function uiKeyTutorial:OnOpen(nSprId)
  if not nSprId or nSprId <= 0 or nSprId > self.NUM_EFFECT then
    return
  end
  Img_SetImage(self.UIGROUP, self.IMG_GRID[nSprId], 1, self.IMG_EFFECT_SPR[nSprId][1])
  Img_PlayAnimation(self.UIGROUP, self.IMG_GRID[nSprId])
  self.nTimerId = tbTimer:Register(Env.GAME_FPS * self.IMG_EFFECT_SPR[nSprId][3], self.ReachTimeClose, self)
end

function uiKeyTutorial:ReachTimeClose()
  UiManager:CloseWindow(self.UIGROUP)
  return 0
end

function uiKeyTutorial:OnClose()
  if self.nTimerId > 0 then
    tbTimer:Close(self.nTimerId)
    self.nTimerId = 0
  end
end

function uiKeyTutorial:OnAnimationOver(szWnd)
  for nIndex, _ in pairs(self.IMG_GRID) do
    if szWnd == self.IMG_GRID[nIndex] then
      self.nFlashTimes = self.nFlashTimes + 1
      if self.IMG_EFFECT_SPR[nIndex][2] and self.nFlashTimes >= self.IMG_EFFECT_SPR[nIndex][2] then
        self.nFlashTimes = 0
        Wnd_SetVisible(self.UIGROUP, self.IMG_GRID[nIndex], 0)
        UiManager:CloseWindow(self.UIGROUP)
      else
        Img_PlayAnimation(self.UIGROUP, self.IMG_GRID[nIndex])
      end
    end
  end
end
