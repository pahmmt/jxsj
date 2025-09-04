-- 文件名　：thememusic.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-02-16 15:02:31
-- 功能    ：主题曲面板

local tbThemeMusic = Ui:GetClass("thememusic")
local tbSaveData = Ui.tbLogic.tbSaveData
local tbMusic = Ui.tbLogic.tbMusic

tbThemeMusic.DATA_KEY = "ThemeSetting"
tbThemeMusic.Btn_Close = "Btn_Close"
tbThemeMusic.Btn_Stop = "Btn_Stop"
tbThemeMusic.Btn_Close1 = "BtnClose"

--music list
tbThemeMusic.ScrollPanel_Music = "ScrollPanel_Music"
tbThemeMusic.List_Music = "List_Music"

tbThemeMusic.Progress_Volum = "Progress_Volum"

--音量进度
tbThemeMusic.ScrbarMusic = "ScrbarMusic"

tbThemeMusic.nMaxMusicVolum = 14

function tbThemeMusic:OnOpen()
  self:UpList()
  self:UpScorllbar()
  if tbMusic.nCloseMusic == 1 then
    Btn_Check(self.UIGROUP, self.Btn_Stop, 1)
    Wnd_SetEnable(self.UIGROUP, self.ScrbarMusic, 0)
  else
    Btn_Check(self.UIGROUP, self.Btn_Stop, 0)
    Wnd_SetEnable(self.UIGROUP, self.ScrbarMusic, 1)
  end
end

function tbThemeMusic:OnButtonClick(szWnd, nParam)
  if szWnd == self.Btn_Close or szWnd == self.Btn_Close1 then
    self:SaveSetting()
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.Btn_Stop then
    self:ChangeVolum()
  end
end

function tbThemeMusic:ChangeVolum()
  local nState = Btn_GetCheck(self.UIGROUP, self.Btn_Stop)
  if nState == 1 then
    SetMusicVolume(0)
    Wnd_SetEnable(self.UIGROUP, self.ScrbarMusic, 0)
    Img_SetFrame(Ui.UI_ACCOUNT_LOGIN, Ui(Ui.UI_ACCOUNT_LOGIN).BUTTON_THEMEMUSIC, 4)
    tbMusic.nCloseMusic = 1
  else
    SetMusicVolume(tbMusic.nMusicVolum * 7)
    Wnd_SetEnable(self.UIGROUP, self.ScrbarMusic, 1)
    Img_SetFrame(Ui.UI_ACCOUNT_LOGIN, Ui(Ui.UI_ACCOUNT_LOGIN).BUTTON_THEMEMUSIC, 0)
    tbMusic.nCloseMusic = 0
  end
end

function tbThemeMusic:UpList()
  for nId, tbInfo in ipairs(tbMusic.tbMusciList) do
    Lst_SetCell(self.UIGROUP, self.List_Music, nId, 0, tbInfo[1])
  end
  Lst_SetCurKey(self.UIGROUP, self.List_Music, tbMusic.nSelectNum)
end

function tbThemeMusic:OnListSel(szWnd, nParam)
  if szWnd == self.List_Music then
    local tbMusicEx = tbMusic.tbMusciList[nParam]
    if tbMusicEx and tbMusic.nSelectNum ~= nParam then
      tbMusic.nSelectNum = nParam
      PlayAMusic(tbMusicEx[2], 1)
    end
  end
end

function tbThemeMusic:UpScorllbar()
  Prg_SetPos(self.UIGROUP, self.Progress_Volum, (tbMusic.nMusicVolum + 2) / self.nMaxMusicVolum * 1000)
  ScrBar_SetCurValue(self.UIGROUP, self.ScrbarMusic, tbMusic.nMusicVolum)
end

function tbThemeMusic:OnScorllbarPosChanged(szWnd, nParam)
  if szWnd == self.ScrbarMusic then
    if nParam ~= tbMusic.nMusicVolum then
      tbMusic.nMusicVolum = nParam
      SetMusicVolume(tbMusic.nMusicVolum * 7)
      Prg_SetPos(self.UIGROUP, self.Progress_Volum, (tbMusic.nMusicVolum + 2) / self.nMaxMusicVolum * 1000)
    end
  end
end

function tbThemeMusic:SaveSetting()
  local tbSaveSetting = {}
  tbSaveSetting.nMusicVolum = tbMusic.nMusicVolum
  tbSaveSetting.nSelectNum = tbMusic.nSelectNum
  tbSaveSetting.nCloseMusic = tbMusic.nCloseMusic
  tbSaveData:Save(self.DATA_KEY, tbSaveSetting)
end
