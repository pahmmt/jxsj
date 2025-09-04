-- 文件名　：music.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-02-17 09:07:48
-- 功能    ：

Ui.tbLogic.tbMusic = {}
local tbMusic = Ui.tbLogic.tbMusic
local tbSaveData = Ui.tbLogic.tbSaveData

tbMusic.tbMusciList = {
  [1] = { "【剑侠世界】丰碑", "\\audio\\ui\\jxsj_theme.mp3" },
  [2] = { "【剑侠情缘】大英雄", "\\audio\\ui\\jxqy1Online_theme.mp3" },
  [3] = { "【剑侠情缘】这一生只为你", "\\audio\\ui\\jxqy1Online2_theme.mp3" },
  [4] = { "【剑侠情缘】天仙子", "\\audio\\ui\\jxqy2HD_theme.mp3" },
}

function tbMusic:Init()
  local tbSaveSetting = tbSaveData:Load("ThemeSetting")
  self.nCloseMusic = tbSaveSetting.nCloseMusic or 0
  self.nMusicVolum = tbSaveSetting.nMusicVolum or 7
  self.nSelectNum = tbSaveSetting.nSelectNum or 1
end
