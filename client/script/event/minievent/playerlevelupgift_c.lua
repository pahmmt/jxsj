if not MODULE_GAMECLIENT then
  return
end

Require("\\script\\event\\minievent\\playerlevelupgift.lua")

local tbGift = Item:GetClass("playerlevelupgift")

function tbGift:GetTip()
  return string.format("右键点击可以查看<color=orange>%d级<color>的升级礼物。", it.GetGenInfo(1))
end

SpecialEvent.PlayerLevelUpGift = SpecialEvent.PlayerLevelUpGift or {}
local PlayerLevelUpGift = SpecialEvent.PlayerLevelUpGift

function PlayerLevelUpGift:OpenWindow(nMonthPay, dwItemId)
  UiManager:OpenWindow(Ui.UI_LEVELUPGIFT, nMonthPay, dwItemId)
end
