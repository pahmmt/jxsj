-- 文件名　：wedding.lua
-- 创建者　：furuilei
-- 创建时间：2009-12-09 19:17:21

local uiWedding = Ui:GetClass("wedding")
local tbTimer = Ui.tbLogic.tbTimer

uiWedding.NUM_EFFECT = 5

uiWedding.IMG_GRID = {}
for i = 1, uiWedding.NUM_EFFECT do
  uiWedding.IMG_GRID[i] = "ImgGrid" .. i
end

-- effect
-- {XXX（特效图素）, XXX（特效播放次数）, XXX（最多持续多少时间）}
uiWedding.IMG_EFFECT_SPR = {
  [0] = "",
  [1] = { "\\image\\effect\\other\\lipaoyanhua.spr", 4, 11 },
  [2] = { "\\image\\ui\\001a\\main\\popo\\up.spr", nil, 20 },
  [3] = { "\\image\\ui\\001a\\main\\popo\\down.spr", nil, 20 },
  [4] = { "\\image\\ui\\001a\\main\\popo\\right.spr", nil, 20 },
  [5] = { "\\image\\ui\\001a\\main\\popo\\left.spr", nil, 20 },
}

function uiWedding:Init()
  self.nFlashTimes = 0
end

function uiWedding:OnOpen(nSprId)
  if not nSprId or nSprId <= 0 or nSprId > self.NUM_EFFECT then
    return
  end
  Img_SetImage(self.UIGROUP, self.IMG_GRID[nSprId], 1, self.IMG_EFFECT_SPR[nSprId][1])
  Img_PlayAnimation(self.UIGROUP, self.IMG_GRID[nSprId])
  self.nTimerId = tbTimer:Register(Env.GAME_FPS * self.IMG_EFFECT_SPR[nSprId][3], self.ReachTimeClose, self)
end

function uiWedding:ReachTimeClose()
  UiManager:CloseWindow(self.UIGROUP)
  return 0
end

function uiWedding:OnClose()
  if self.nTimerId > 0 then
    tbTimer:Close(self.nTimerId)
    self.nTimerId = 0
  end
end

function uiWedding:OnAnimationOver(szWnd)
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
