--固定预先加载的脚本，会是所有脚本加载的第一个

print("Preload client script files...")

-- Client、GS通用
Require("\\script\\misc\\clientevent.lua")
Require("\\script\\player\\kluaplayer.lua")
Require("\\script\\npc\\npc.lua")
Require("\\script\\player\\player.lua")
Require("\\script\\item\\item.lua")
Require("\\script\\obj\\obj.lua")
Require("\\script\\task\\task.lua")
Require("\\script\\fightskill\\fightskill.lua")
Require("\\script\\map\\map.lua")
Require("\\script\\lib\\gift.lua")
Require("\\script\\event\\manager\\define.lua")
Require("\\script\\task\\help\\help.lua")

-- Client专用
if MODULE_GAMECLIENT then
  Require("\\ui\\script\\ui.lua")
end
