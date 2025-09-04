-- 文件名　：newplayergiftex_c.lua
-- 创建者　：jiazhenwei
-- 创建时间：2011-11-02 19:26:49
-- 功能    ：

local tbGift = Item:GetClass("NewPlayerGiftEx")

function tbGift:GetTip()
  return string.format("右键点击可以查看<color=orange>%d级<color>的升级礼物。", it.GetGenInfo(1))
end

SpecialEvent.NewPlayerGiftEx = SpecialEvent.NewPlayerGiftEx or {}
local NewPlayerGiftEx = SpecialEvent.NewPlayerGiftEx

function NewPlayerGiftEx:OpenWindow(dwId, nItemLevel, tbItems)
  UiManager:OpenWindow(Ui.UI_LEVELUPGIFT, dwId, nItemLevel, tbItems)
  local nX, nY = Wnd_GetPos("UI_ITEMBOX", "Main")
  if nX >= 180 and nY > 0 then
    UiManager:MoveWindow(Ui.UI_LEVELUPGIFT, math.max(nX - 270, 0), nY)
  elseif nX < 180 and nY > 0 then
    UiManager:MoveWindow(Ui.UI_LEVELUPGIFT, nX + 475, nY)
  end
end
