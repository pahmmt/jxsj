-----------------------------------------------------
--文件名		：	system.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-06-05
--功能描述		：	系统设定界面
------------------------------------------------------

local uiSystem = Ui:GetClass("system")
local tbSaveData = Ui.tbLogic.tbSaveData
local tbTempData = Ui.tbLogic.tbTempData

local PAGESET_MAIN = "PageSetMain" --
local PAGE_SHOW = "PageShow" --

uiSystem.BUTTON_CLOSE = "BtnClose"
uiSystem.BUTTON_APPLYSETTING = "BtnApplySetting"
uiSystem.BUTTON_RETURN = "BtnReturn"
uiSystem.BUTTON_SHOW_LIFE = "BtnShowLife"
uiSystem.BUTTON_SHOW_NAME = "BtnShowName"
uiSystem.BUTTON_FULL_SCREEN = "BtnFullScreen"
uiSystem.BUTTON_WINDOW_MODEL = "BtnWindowMode"
uiSystem.BUTTON_SIMPLE_RES = "BtnSimpleRes"
uiSystem.SCROLL_PLAYER_NUM = "ScrbarPlayerNumber"
uiSystem.SCROLL_VIEW_QUALITY = "ScrbarViewQuality"
uiSystem.BUTTON_CTL_MODEL_1 = "BtnControlModel1"
uiSystem.BUTTON_CTL_MODEL_2 = "BtnControlModel2"
uiSystem.BUTTON_DETAIL_SET = "BtnDetailSetting"
uiSystem.BUTTON_DEFAULT_SET = "BtnDefaultSetting"
uiSystem.BUTTON_OPTIMIZESET = "BtnOptimizeSetting"
uiSystem.SCROLL_MUSIC = "ScrbarMusic"
uiSystem.SCROLL_AUDIO = "ScrbarAudio"
uiSystem.SCROLL_SOUND = "ScrbarSoundControl"
uiSystem.DATA_KEY = "GameOption"
uiSystem.DATA_KEY_OPTIMIZE = "GameOptimize"
uiSystem.BTN_PLUGINNAME = "BtnPluginName"
uiSystem.TXT_PLUGINDESCRIB = "TxtPluginDescr"
uiSystem.TXT_PLUGINLISTPAGE = "TxtPluginPage"
uiSystem.BTN_PLUGINPAGELEFT = "BtnPluginLeft"
uiSystem.BTN_PLUGINPAGERIGHT = "BtnPluginRight"
uiSystem.BTN_PLUGINOPEN = "BtnOpenPlugin"
uiSystem.BTN_PAGEOPERATION = "BtnOperation"
uiSystem.BTN_PAGESHOW = "BtnShow"
uiSystem.BTN_PAGEAUDIO = "BtnAudio"
uiSystem.BTN_PAGEPLUGIN = "BtnPlugin"
uiSystem.BTN_CONFIRMSETTING = "BtnConfirmSetting"
uiSystem.BTN_TEAMPOPMSG = "BtnTeamPopMsg"
uiSystem.BTN_DISABLE_STALL = "BtnDisableStall"
uiSystem.BTN_DISABLE_TEAM = "BtnDisableTeam"
uiSystem.BTN_DISABLE_FRIEND = "BtnDisableFriend"
uiSystem.BTN_TRANSFERMSG = "BtnTransferMsg"

uiSystem.BTN_AUTOOPTIMIZE1 = "BtnAutoOptimize1"
uiSystem.BTN_AUTOOPTIMIZE2 = "BtnAutoOptimize2"
uiSystem.BTN_VERTICALSYNC = "BtnVerticalSync"

uiSystem.BTN_LOAD_LIMIT = "BtnLoadLimit"
uiSystem.BTN_SPACE = "BtnSpace"

uiSystem.BTN_PAGEPREUPDATE = "BtnPreUpdate"
uiSystem.BTN_PREUPDATEONOFF = "BtnPreUpdateOnOff"
uiSystem.TXT_CURUPDATESPEED = "TxtCurSpeed"
uiSystem.TXT_MAXUPDATESPEED = "TxtMaxSpeed"
uiSystem.SCROLL_PREUPDATESPEED = "ScrbarPreUpdate"

uiSystem.BTN_CLOSE_AUDIO = "BtnCloseAudio"
uiSystem.BTN_CLOSE_MUSIC = "BtnCloseMusic"
uiSystem.BTN_CLOSE_ALLSOUND = "BtnCloseAllSound"

uiSystem.BTN_COMMONALL = "BtnCommonAll"
uiSystem.BTN_PERFORMANCEALL = "BtnPerformanceAll"
uiSystem.BTN_CLASSICALMODE = "BtnClassicalMode"
uiSystem.BTN_FASHIONMODE = "BtnFashionMode"
uiSystem.BTN_DISABLETEACHER = "BtnDisableTeacher"

uiSystem.VOLUME_STEP = 7 -- 每一格的音量

-- 预更新最大最小速度
uiSystem.DOWNLOAD_SPEED_MAX = 150
uiSystem.DOWNLOAD_SPEED_MIN = 10

uiSystem.BTN_PLUGINNAME_NUM = 12
--显示设置优化部分
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
uiSystem.AUTODISP = "BtnAuto"
uiSystem.BTNNPCKIND = { "BtnMe", "BtnPlayer", "BtnNpc" }
uiSystem.BTNCONT = { "Btn1", "Btn2", "Btn3", "Btn4", "Btn5", "Btn6", "Btn7", "Btn8" }
uiSystem.SCROLLBARSETTING = "ScrbarSetting"
uiSystem.DISPLAYLEVEL = { 4, 8, 16, 32, 64, 128, 256 }

uiSystem.BTNCOMMONALL = { "Btn1", "Btn2", "Btn3", "Btn4", "BtnTeamPopMsg", "BtnShowLife", "BtnTransferMsg", "BtnShowName" }
uiSystem.BTNPERFORMANCEALL = { "BtnLoadLimit", "BtnSpace", "BtnMe", "BtnPlayer", "BtnNpc", "Btn5", "Btn6", "Btn7", "Btn8" }

-- 场景元素显示模式
local DISPLAY_MODE_NORMAL = 0 -- 正常显示
local DISPLAY_MODE_HIDE = 1 -- 不显示
local DISPLAY_MODE_SIMPLE = 2 -- 简单显示方式

-- Npc显示类型
local NPCKIND_CONFIG_ME = 0
local NPCKIND_CONFIG_PLAYER = 1
local NPCKIND_CONFIG_NPC = 2

-- 场景元素类型
local DISPLAY_CONFIG_ME = 0 -- 玩家自己
local DISPLAY_CONFIG_PLAYER = 1 -- 其他角色
local DISPLAY_CONFIG_NPC = 2 -- NPC
local DISPLAY_CONFIG_SHADOW = 3 -- 人物技能阴影残影
local DISPLAY_CONFIG_SKILLEFFECT = 4 -- 人物技能特效
local DISPLAY_CONFIG_MISSILE = 5 -- 子弹
local DISPLAY_CONFIG_SHORTTIMESTATE = 6 -- 短时间状态特效
local DISPLAY_CONFIG_LONGTIMESTATE = 7 -- 长时间状态特效
local TASK_TEACHER_GROUP = 2181 -- 新手指引任务组ID
local TASK_TEACHER_ID = 1 -- 新手指引ID
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------

function uiSystem:Init()
  self.m_tbOption = {}
  self:InitOptimize()
  tbSaveData:RegistLoadCallback(self.LoadOption, self) -- TODO: 临时做法
  self.nCurPluginPage = 1
  self.tbPluginParam = {}
  self.nRepresentConfig = 0
  self.nDisableStall = 0
  self.nDisableFriend = 0
  --	self.nDisableTeam		= 0;
  self.nDisableTeacher = 0
end

function uiSystem:InitOptimize()
  self.m_tbOptimize = {}
  self.m_tbOptimize.nAutoDisp = 0
  self.m_tbOptimize.tbNpcParam = {}
  self.m_tbOptimize.tbParam = {}
  self.m_tbOptimize.nDisplayAlphaLevel = 0
  self.m_tbOptimize.nBackupAlphaLevel = 0
end

--写log
function uiSystem:WriteStatLog()
  Log:Ui_SendLog("F11系统设置界面", 1)
end

function uiSystem:OnOpen()
  self:WriteStatLog()
  self:LoadOption()
  self.nPluginManagerLoadState = KInterface.GetPluginManagerLoadState()
  Ui(Ui.UI_SIDEBAR):WndOpenCloseCallback(self.UIGROUP, 1)
  local nFullScreen = GetFullScreen()
  if nFullScreen == 1 then
    Btn_Check(self.UIGROUP, self.BUTTON_FULL_SCREEN, 1)
    Btn_Check(self.UIGROUP, self.BUTTON_WINDOW_MODEL, 0)
  else
    Btn_Check(self.UIGROUP, self.BUTTON_FULL_SCREEN, 0)
    Btn_Check(self.UIGROUP, self.BUTTON_WINDOW_MODEL, 1)
  end
  local nUiVersion = GetUiVersionConfig()
  if nUiVersion == Ui.Version001 then
    Btn_Check(self.UIGROUP, self.BTN_CLASSICALMODE, 1)
    Btn_Check(self.UIGROUP, self.BTN_FASHIONMODE, 0)
  else
    Btn_Check(self.UIGROUP, self.BTN_CLASSICALMODE, 0)
    Btn_Check(self.UIGROUP, self.BTN_FASHIONMODE, 1)
  end
  if MINI_CLIENT then
    Wnd_SetEnable(self.UIGROUP, self.BTN_CLASSICALMODE, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_FASHIONMODE, 0)
  end
  self.nRepresentConfig = GetRepresentConfig()
  local nLoadLimit = KLib.GetBit(self.nRepresentConfig, 2)
  local nSpace = KLib.GetBit(self.nRepresentConfig, 1)
  Btn_Check(self.UIGROUP, self.BTN_LOAD_LIMIT, nLoadLimit)
  Btn_Check(self.UIGROUP, self.BTN_SPACE, nSpace)

  Btn_Check(self.UIGROUP, self.BUTTON_SHOW_LIFE, math.mod(self.m_tbOption.nShowLife + 1, 2))
  Btn_Check(self.UIGROUP, self.BUTTON_SHOW_NAME, math.mod(self.m_tbOption.nShowName + 1, 2))
  Btn_Check(self.UIGROUP, self.BTN_TEAMPOPMSG, math.mod(self.m_tbOption.nTeamPopMsg + 1, 2))
  Btn_Check(self.UIGROUP, self.BTN_TRANSFERMSG, math.mod(self.m_tbOption.nTransferMsg + 1, 2))

  if self._no_name_or_life == 0 then -- 禁止改变显示血条选项
    Wnd_SetEnable(self.UIGROUP, self.BUTTON_SHOW_LIFE, 0)
    Wnd_SetEnable(self.UIGROUP, self.BUTTON_SHOW_NAME, 0)
  end

  -- 把一些暂时没用的或无法实现的功能按键禁用掉 By peres

  Wnd_SetEnable(self.UIGROUP, self.BUTTON_SIMPLE_RES)
  Wnd_SetEnable(self.UIGROUP, self.SCROLL_PLAYER_NUM)
  Wnd_SetEnable(self.UIGROUP, self.SCROLL_VIEW_QUALITY)

  Wnd_SetEnable(self.UIGROUP, self.BUTTON_DETAIL_SET)
  Wnd_SetEnable(self.UIGROUP, self.BUTTON_DEFAULT_SET)
  self:SetControlModel(self.m_tbOption.nControlModel)
  PgSet_ActivePage(self.UIGROUP, PAGESET_MAIN, PAGE_SHOW)

  self:UpdateWndOpt()
  self:UpdatePluginParam()

  Btn_Check(self.UIGROUP, self.BTN_DISABLE_STALL, self.nDisableStall)
  Btn_Check(self.UIGROUP, self.BTN_DISABLE_FRIEND, self.nDisableFriend)
  --	Btn_Check(self.UIGROUP, self.BTN_DISABLE_TEAM, self.nDisableTeam);

  --if (not self.tbPluginParam or #self.tbPluginParam <= 0) then
  --	Wnd_Hide(self.UIGROUP, self.BTN_PAGEPLUGIN);
  --end
  if self.nDisableTeacher == 0 then
    Btn_Check(self.UIGROUP, self.BTN_DISABLETEACHER, 0)
  else
    Btn_Check(self.UIGROUP, self.BTN_DISABLETEACHER, 1)
  end
  --预更新
  self:PreUpdateShowCurSpeed()
  self.nTimer_PreUpdate = Ui.tbLogic.tbTimer:Register(Env.GAME_FPS, self.OnTimer_ShowPreUpdateCurSpeed, self)
  Ui.tbLogic.tbPreUpdate:OnShowPreUpdateCfg()
end

function uiSystem:UpdatePluginParam()
  local tbPluginParam = {}
  local tbPluginList = Ui.tbPluginInfoList
  for i = 1, #tbPluginList do
    tbPluginParam[i] = tbPluginList[i].nLoadState
  end
  self.tbPluginParam = tbPluginParam
end

function uiSystem:SavePluginLoadState()
  KInterface.SetPluginManagerLoadState(self.nPluginManagerLoadState, 1)
  for i = 1, #self.tbPluginParam do
    Ui.tbPluginInfoList[i].nLoadState = self.tbPluginParam[i]
  end
  for _, tbInfo in pairs(Ui.tbPluginInfoList) do
    KInterface.SetPluginLoadState(tbInfo.szPluginFileName, tbInfo.nLoadState, 1)
  end
end

function uiSystem:SetDisableTeacher(nState)
  if me.GetTask(TASK_TEACHER_GROUP, TASK_TEACHER_ID) == nState then
    return
  end
  me.SetTask(TASK_TEACHER_GROUP, TASK_TEACHER_ID, nState)
  if 0 == nState then
    me.Msg("您已开启新手指引")
  else
    me.Msg("您已屏蔽新手指引")
  end
end

function uiSystem:SetDisableTeam(nState)
  --	if tbTempData.nDisableTeam == nState then
  --		return;
  --	end
  --	tbTempData.nDisableTeam = nState;
  --	Btn_Check(self.UIGROUP, self.BTN_DISABLE_TEAM, tbTempData.nDisableTeam);
  if 1 == nState then
    me.Msg("您已开启屏蔽组队请求。")
  else
    me.Msg("您已恢复接受组队请求。")
  end
end

function uiSystem:SetDisableFriend(nState)
  if tbTempData.nDisableFriend == nState then
    return
  end
  tbTempData.nDisableFriend = nState
  Btn_Check(self.UIGROUP, self.BTN_DISABLE_FRIEND, tbTempData.nDisableFriend)
  if 1 == nState then
    me.Msg("您已开启屏蔽加好友请求。")
  else
    me.Msg("您已恢复接受加好友请求。")
  end
end

function uiSystem:SetDisableStall(nState)
  if tbTempData.nDisableStall == nState then
    return
  end
  tbTempData.nDisableStall = nState
  Btn_Check(self.UIGROUP, self.BTN_DISABLE_STALL, tbTempData.nDisableStall)
  if 1 == nState then
    me.Msg("您已开启屏蔽交易请求。")
  else
    me.Msg("您已恢复接受交易请求。")
  end
end

function uiSystem:LoadOption()
  local tbOption = tbSaveData:Load(self.DATA_KEY)
  self:CopyTable(self.m_tbOption, tbOption)
  if not self.m_tbOption.nShowLife then -- 设定初始值
    self.m_tbOption.nShowLife = 1
  end

  if not self.m_tbOption.nShowName then
    self.m_tbOption.nShowName = 1
  end

  --读不到保存的配置时，默认音量为70%，以防音量过大引起玩家的不快
  if not self.m_tbOption.nAudioVolume then
    self.m_tbOption.nAudioVolume = 7
  end
  if not self.m_tbOption.nMusicVolume then
    self.m_tbOption.nMusicVolume = 7
  end

  if not self.m_tbOption.nSoundVolume then
    self.m_tbOption.nSoundVolume = 7
  end

  if self.m_tbOption.nSoundVolume < self.m_tbOption.nAudioVolume then
    self.m_tbOption.nSoundVolume = self.m_tbOption.nAudioVolume
  end

  if self.m_tbOption.nSoundVolume < self.m_tbOption.nMusicVolume then
    self.m_tbOption.nSoundVolume = self.m_tbOption.nMusicVolume
  end

  if not self.m_tbOption.nControlModel then
    self.m_tbOption.nControlModel = 1
  end

  if not self.m_tbOption.nTeamPopMsg then
    self.m_tbOption.nTeamPopMsg = 1
  end

  if not self.m_tbOption.nTransferMsg then
    self.m_tbOption.nTransferMsg = 1
  end

  if not self.m_tbOption.nCloseSound then
    self.m_tbOption.nCloseSound = 0
  end

  if not self.m_tbOption.nCloseMusic then
    self.m_tbOption.nCloseMusic = 0
  end

  if not self.m_tbOption.nCloseAudio then
    self.m_tbOption.nCloseAudio = 0
  end

  if not self.m_tbOption.nSelectCommonAll then
    self.m_tbOption.nSelectCommonAll = 0
  end

  if not self.m_tbOption.nSelectPerformanceAll then
    self.m_tbOption.nSelectPerformanceAll = 0
  end

  self:Update()

  self:LoadOptimize()
  self.nDisableStall = tbTempData.nDisableStall
  self.nDisableFriend = tbTempData.nDisableFriend
  --	self.nDisableTeam = tbTempData.nDisableTeam;
  self.nDisableTeacher = me.GetTask(TASK_TEACHER_GROUP, TASK_TEACHER_ID)
end

function uiSystem:LoadOptimize()
  local tbOptimize = tbSaveData:Load(self.DATA_KEY_OPTIMIZE)
  self:CopyTable(self.m_tbOptimize, tbOptimize)
  if not self.m_tbOptimize.tbNpcParam or #self.m_tbOptimize.tbNpcParam <= 0 then
    self.m_tbOptimize.tbNpcParam = { 0, 0, 0 }
  end

  if not self.m_tbOptimize.tbParam or #self.m_tbOptimize.tbParam <= 0 then
    self.m_tbOptimize.tbParam = { 0, 0, 0, 0, 0, 0, 0, 0 }
  end

  local nValue = GetDisplayAlphaLevel()
  local nLevel = self:GetAlphaLevel(nValue)
  self.m_tbOptimize.nDisplayAlphaLevel = self.DISPLAYLEVEL[nLevel]
  self.m_tbOptimize.nBackupAlphaLevel = self.m_tbOptimize.nDisplayAlphaLevel

  self:SaveOptSetting()
end

function uiSystem:CopyTable(tbA, tbB, nCount)
  nCount = nCount or 0
  if nCount > 1000 then
    return
  end
  for k, v in pairs(tbB) do
    if type(v) == "table" then
      tbA[k] = {}
      self:CopyTable(tbA[k], tbB[k], nCount + 1)
    else
      tbA[k] = v
    end
  end
end

function uiSystem:OnClose()
  if self.nTimer_PreUpdate and self.nTimer_PreUpdate ~= 0 then
    Ui.tbLogic.tbTimer:Close(self.nTimer_PreUpdate)
  end
end

function uiSystem:ApplySetting()
  local nFullScreen = Btn_GetCheck(self.UIGROUP, self.BUTTON_FULL_SCREEN)
  nFullScreen = SetFullScreen(nFullScreen)
  Btn_Check(self.UIGROUP, self.BUTTON_FULL_SCREEN, nFullScreen)

  self:SaveOptSetting()
  self:SavePluginLoadState()
  tbSaveData:Save(self.DATA_KEY, self.m_tbOption)
  tbTempData.nTeamPopMsg = self.m_tbOption.nTeamPopMsg -- 组队泡泡
  me.nShowLife = self.m_tbOption.nShowLife -- 角色生命
  me.nShowName = self.m_tbOption.nShowName -- 角色名字
  Ui.tbLogic.tbAutoPath.nTransferMsg = self.m_tbOption.nTransferMsg -- 传送提示
  self:SetControlModel(self.m_tbOption.nControlModel) -- 操作模式
  Ui.tbLogic.tbPreUpdate:SetPreUpdateOn(self.m_tbOption.nPreUpdateOn) -- 预更新
  -- 声音
  if self.m_tbOption.nCloseSound == 1 then
    SetAudioVolume(0)
    SetMusicVolume(0)
  else
    if self.m_tbOption.nCloseAudio == 1 then
      SetAudioVolume(0)
    else
      SetAudioVolume(self.m_tbOption.nAudioVolume * self.VOLUME_STEP)
    end
    if self.m_tbOption.nCloseMusic == 1 then
      SetMusicVolume(0)
    else
      SetMusicVolume(self.m_tbOption.nMusicVolume * self.VOLUME_STEP)
    end
  end

  local tbRepresentconfig = Lib:LoadIniFile("representconfig.ini")
  if tbRepresentconfig == nil then
    tbRepresentconfig = Lib:LoadIniFile("\\setting\\misc\\representconfig.ini")
  end
  if tbRepresentconfig then
    local nTaskLimit = nil
    if tbRepresentconfig["RepresentConfig" .. self.nRepresentConfig] then
      nTaskLimit = tbRepresentconfig["RepresentConfig" .. self.nRepresentConfig]["PerFrameTaskCountLimit"]
      if nTaskLimit then
        SetTaskLimit(nTaskLimit)
      end
    end
    local nMediaSpaceLimit = nil
    if tbRepresentconfig["RepresentConfig" .. self.nRepresentConfig] then
      nMediaSpaceLimit = tbRepresentconfig["RepresentConfig" .. self.nRepresentConfig]["MediaSpaceLimit"]
      if nMediaSpaceLimit then
        SetMediaSpaceLimit(nMediaSpaceLimit)
      end
    end
    local nMediaTimeLimit = nil
    if tbRepresentconfig["RepresentConfig" .. self.nRepresentConfig] then
      nMediaTimeLimit = tbRepresentconfig["RepresentConfig" .. self.nRepresentConfig]["MediaTimeLimit"]
      if nMediaTimeLimit then
        SetMediaTimeLimit(nMediaTimeLimit)
      end
    end
    SetRepresentConfig(self.nRepresentConfig)
  end

  local bVerticalSync = Btn_GetCheck(self.UIGROUP, self.BTN_VERTICALSYNC)
  SetVerticalSync(bVerticalSync)
  --if (1 == GetAutoDispState()) then
  --	return;
  --end
  tbSaveData:Save(self.DATA_KEY_OPTIMIZE, self.m_tbOptimize)
  self:SetDisableStall(self.nDisableStall)
  self:SetDisableFriend(self.nDisableFriend)
  --	self:SetDisableTeam(self.nDisableTeam);
  self:SetDisableTeacher(self.nDisableTeacher)
  local nClassicalMode = Btn_GetCheck(self.UIGROUP, self.BTN_CLASSICALMODE)
  if nClassicalMode == 1 then
    SetUiVersionConfig(1)
  else
    SetUiVersionConfig(2)
  end
  self.m_tbOptimize = {}
  local tbOptimize = tbSaveData:Load(self.DATA_KEY_OPTIMIZE)
  self:CopyTable(self.m_tbOptimize, tbOptimize)
  self.m_tbOption = {}
  local tbOption = tbSaveData:Load(self.DATA_KEY)
  self:CopyTable(self.m_tbOption, tbOption)
end

function uiSystem:Update()
  if self._no_name_or_life ~= 0 then
    me.nShowLife = self.m_tbOption.nShowLife
    Btn_Check(self.UIGROUP, self.BUTTON_SHOW_LIFE, math.mod(self.m_tbOption.nShowLife + 1, 2))

    me.nShowName = self.m_tbOption.nShowName
    Btn_Check(self.UIGROUP, self.BUTTON_SHOW_NAME, math.mod(self.m_tbOption.nShowName + 1, 2))
  end
  if self.m_tbOption.nCloseSound == 1 then
    self.m_tbOption.nCloseMusic = 1
    self.m_tbOption.nCloseAudio = 1
    Wnd_SetEnable(self.UIGROUP, self.BTN_CLOSE_MUSIC, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_CLOSE_AUDIO, 0)
    SetAudioVolume(0)
    SetMusicVolume(0)
  end
  Btn_Check(self.UIGROUP, self.BTN_CLOSE_ALLSOUND, self.m_tbOption.nCloseSound)
  Btn_Check(self.UIGROUP, self.BTN_CLOSE_MUSIC, self.m_tbOption.nCloseMusic)
  Btn_Check(self.UIGROUP, self.BTN_CLOSE_AUDIO, self.m_tbOption.nCloseAudio)
  --	ScrBar_SetValueRange(self.UIGROUP, self.SCROLL_AUDIO, 1, 10);
  ScrBar_SetCurValue(self.UIGROUP, self.SCROLL_AUDIO, self.m_tbOption.nAudioVolume)
  if self.m_tbOption.nCloseAudio == 0 then
    SetAudioVolume(self.m_tbOption.nAudioVolume * self.VOLUME_STEP)
  else
    SetAudioVolume(0)
  end
  ScrBar_SetCurValue(self.UIGROUP, self.SCROLL_MUSIC, self.m_tbOption.nMusicVolume)
  if self.m_tbOption.nCloseMusic == 0 then
    SetMusicVolume(self.m_tbOption.nMusicVolume * self.VOLUME_STEP)
  else
    SetMusicVolume(0)
  end

  ScrBar_SetCurValue(self.UIGROUP, self.SCROLL_SOUND, self.m_tbOption.nSoundVolume)

  self:SetControlModel(self.m_tbOption.nControlModel)

  Ui.tbLogic.tbAutoPath.nTransferMsg = self.m_tbOption.nTransferMsg

  tbTempData.nTeamPopMsg = self.m_tbOption.nTeamPopMsg
  Btn_Check(self.UIGROUP, self.BTN_TEAMPOPMSG, math.mod(self.m_tbOption.nTeamPopMsg + 1, 2))
  Btn_Check(self.UIGROUP, self.BTN_COMMONALL, self.m_tbOption.nSelectCommonAll)
  Btn_Check(self.UIGROUP, self.BTN_PERFORMANCEALL, self.m_tbOption.nSelectPerformanceAll)
end

function uiSystem:OnScorllbarPosChanged(szWnd, nParam)
  if szWnd == self.SCROLL_PLAYER_NUM then
  elseif szWnd == self.SCROLL_VIEW_QUALITY then
  elseif szWnd == self.SCROLL_MUSIC then
    self.m_tbOption.nMusicVolume = nParam
    if self.m_tbOption.nCloseMusic == 0 then
      --SetMusicVolume(self.m_tbOption.nMusicVolume * self.VOLUME_STEP);
    end
    if self.m_tbOption.nMusicVolume > self.m_tbOption.nSoundVolume then
      self.m_tbOption.nSoundVolume = self.m_tbOption.nMusicVolume
      ScrBar_SetCurValue(self.UIGROUP, self.SCROLL_SOUND, self.m_tbOption.nSoundVolume)
    end
  elseif szWnd == self.SCROLL_AUDIO then
    self.m_tbOption.nAudioVolume = nParam
    if self.m_tbOption.nCloseAudio == 0 then
      --SetAudioVolume(self.m_tbOption.nAudioVolume * self.VOLUME_STEP);
    end
    if self.m_tbOption.nAudioVolume > self.m_tbOption.nSoundVolume then
      self.m_tbOption.nSoundVolume = self.m_tbOption.nAudioVolume
      ScrBar_SetCurValue(self.UIGROUP, self.SCROLL_SOUND, self.m_tbOption.nSoundVolume)
    end
  elseif szWnd == self.SCROLL_SOUND then
    self.m_tbOption.nSoundVolume = nParam
    if self.m_tbOption.nSoundVolume < self.m_tbOption.nMusicVolume then
      self.m_tbOption.nMusicVolume = self.m_tbOption.nSoundVolume
      ScrBar_SetCurValue(self.UIGROUP, self.SCROLL_MUSIC, self.m_tbOption.nMusicVolume)
    end
    if self.m_tbOption.nSoundVolume < self.m_tbOption.nAudioVolume then
      self.m_tbOption.nAudioVolume = self.m_tbOption.nSoundVolume
      ScrBar_SetCurValue(self.UIGROUP, self.SCROLL_AUDIO, self.m_tbOption.nAudioVolume)
    end
  elseif szWnd == self.SCROLLBARSETTING then
    self.m_tbOptimize.nDisplayAlphaLevel = self.DISPLAYLEVEL[nParam + 1]
  elseif szWnd == self.SCROLL_PREUPDATESPEED then -- 下载限速
    local nFactor = (self.DOWNLOAD_SPEED_MAX - self.DOWNLOAD_SPEED_MIN) / 10
    --self.m_tbOption.nLimitedUpdateSpeed = self.DOWNLOAD_SPEED_MIN + nFactor * nParam;
    Ui.tbLogic.tbPreUpdate:SetPreUpdateSpeedLimit(self.DOWNLOAD_SPEED_MIN + nFactor * nParam)
  end
end

function uiSystem:QuitGame(szWishFun)
  if not szWishFun then
    szWishFun = "ExitGame"
  end
  if UiManager.IVER_nOpenWanLiu == 0 or (me.nLevel >= 20) then
    self:SavePluginLoadState()
    loadstring(szWishFun .. "()")()
  else
    UiManager:OpenWindow(Ui.UI_DETAIN)
  end
end

function uiSystem:OnButtonClick(szWnd, nParam)
  if szWnd == self.BUTTON_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BUTTON_RETURN then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_CONFIRMSETTING then
    self:ApplySetting()
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BUTTON_APPLYSETTING then
    self:ApplySetting()
  elseif szWnd == self.BTN_CLOSE_ALLSOUND then
    if nParam == 1 then
      Btn_Check(self.UIGROUP, self.BTN_CLOSE_AUDIO, 1)
      Btn_Check(self.UIGROUP, self.BTN_CLOSE_MUSIC, 1)
      self.m_tbOption.nCloseSound = 1
      self.m_tbOption.nCloseAudio = 1
      self.m_tbOption.nCloseMusic = 1
      Wnd_SetEnable(self.UIGROUP, self.BTN_CLOSE_AUDIO, 0)
      Wnd_SetEnable(self.UIGROUP, self.BTN_CLOSE_MUSIC, 0)
    else
      Btn_Check(self.UIGROUP, self.BTN_CLOSE_AUDIO, 0)
      Btn_Check(self.UIGROUP, self.BTN_CLOSE_MUSIC, 0)
      self.m_tbOption.nCloseSound = 0
      self.m_tbOption.nCloseAudio = 0
      self.m_tbOption.nCloseMusic = 0
      Wnd_SetEnable(self.UIGROUP, self.BTN_CLOSE_AUDIO, 1)
      Wnd_SetEnable(self.UIGROUP, self.BTN_CLOSE_MUSIC, 1)
    end
  elseif szWnd == self.BTN_CLOSE_MUSIC then
    self.m_tbOption.nCloseMusic = nParam
  elseif szWnd == self.BTN_CLOSE_AUDIO then
    self.m_tbOption.nCloseAudio = nParam
  elseif szWnd == self.BUTTON_WINDOW_MODEL then
    Btn_Check(self.UIGROUP, self.BUTTON_FULL_SCREEN, 0)
    Btn_Check(self.UIGROUP, self.BUTTON_WINDOW_MODEL, 1)
  elseif szWnd == self.BUTTON_FULL_SCREEN then
    Btn_Check(self.UIGROUP, self.BUTTON_FULL_SCREEN, 1)
    Btn_Check(self.UIGROUP, self.BUTTON_WINDOW_MODEL, 0)
  elseif szWnd == self.BTN_CLASSICALMODE then
    Btn_Check(self.UIGROUP, self.BTN_CLASSICALMODE, 1)
    Btn_Check(self.UIGROUP, self.BTN_FASHIONMODE, 0)
  elseif szWnd == self.BTN_FASHIONMODE then
    Btn_Check(self.UIGROUP, self.BTN_CLASSICALMODE, 0)
    Btn_Check(self.UIGROUP, self.BTN_FASHIONMODE, 1)
  elseif szWnd == self.BTN_LOAD_LIMIT then
    local nLoadLimit = KLib.GetBit(self.nRepresentConfig, 2)
    nLoadLimit = nParam --(nLoadLimit == 1) and 0 or 1;
    self.nRepresentConfig = KLib.SetBit(self.nRepresentConfig, 2, nLoadLimit)
    Btn_Check(self.UIGROUP, self.BTN_LOAD_LIMIT, nLoadLimit)
  elseif szWnd == self.BTN_SPACE then
    local nSpace = KLib.GetBit(self.nRepresentConfig, 1)
    nSpace = nParam --(nSpace == 1) and 0 or 1;
    self.nRepresentConfig = KLib.SetBit(self.nRepresentConfig, 1, nSpace)
    Btn_Check(self.UIGROUP, self.BTN_SPACE, nSpace)
  elseif szWnd == self.BUTTON_SHOW_LIFE then
    self.m_tbOption.nShowLife = math.mod(nParam + 1, 2)
  elseif szWnd == self.BUTTON_SHOW_NAME then
    self.m_tbOption.nShowName = math.mod(nParam + 1, 2)
  elseif szWnd == self.BUTTON_CTL_MODEL_1 then
    self.m_tbOption.nControlModel = 1 -- 设置为操作模式1
    self:UpdateControlModel(self.m_tbOption.nControlModel)
  elseif szWnd == self.BUTTON_CTL_MODEL_2 then
    self.m_tbOption.nControlModel = 2 -- 设置为操作模式2
    self:UpdateControlModel(self.m_tbOption.nControlModel)
  elseif szWnd == self.BUTTON_OPTIMIZESET then
    UiManager:OpenWindow(Ui.UI_OPTIMIZEPANEL)
  elseif szWnd == self.BTN_PAGEPLUGIN then
    self:UpdatePagePlugin()
  elseif szWnd == self.BTN_TEAMPOPMSG then
    self.m_tbOption.nTeamPopMsg = math.mod(nParam + 1, 2)
  elseif szWnd == self.BTN_PLUGINPAGELEFT then
    self.nCurPluginPage = self.nCurPluginPage - 1
    self:UpdatePagePlugin()
  elseif szWnd == self.BTN_PLUGINPAGERIGHT then
    self.nCurPluginPage = self.nCurPluginPage + 1
    self:UpdatePagePlugin()
  elseif szWnd == self.BTN_DISABLE_STALL then
    self.nDisableStall = nParam
  elseif szWnd == self.BTN_DISABLE_FRIEND then
    self.nDisableFriend = nParam
  --	elseif szWnd == self.BTN_DISABLE_TEAM then
  --		self.nDisableTeam = nParam;
  elseif szWnd == self.BTN_DISABLETEACHER then
    self.nDisableTeacher = nParam
  --	自动优化显示配置
  --	elseif szWnd == self.AUTODISP then
  --		if self.m_tbOptimize.nAutoDisp == 0 then
  --			self.m_tbOptimize.nAutoDisp = 1;
  --			self:SetAutoDisp(1);
  --		else
  --			self.m_tbOptimize.nAutoDisp = 0;
  --			Btn_Check(self.UIGROUP, self.AUTODISP, 0);
  --			self:SetAutoDisp(0);
  --		end
  elseif szWnd == self.BTN_PLUGINOPEN then
    if self.nPluginManagerLoadState == 0 then
      self.nPluginManagerLoadState = 1
      self:UpdatePagePlugin()
    else
      self.nPluginManagerLoadState = 0
      self:UpdatePagePlugin()
    end
  elseif szWnd == self.BTN_TRANSFERMSG then
    self.m_tbOption.nTransferMsg = math.mod(nParam + 1, 2)
  elseif szWnd == self.BTN_PAGEPREUPDATE then
    -- self:UpdatePagePreUpdate();
  elseif szWnd == self.BTN_PREUPDATEONOFF then -- 开启预更新
    self.m_tbOption.nPreUpdateOn = nParam
  elseif szWnd == self.BTN_COMMONALL then
    if nParam == 0 then
      for _, szBtnName in ipairs(self.BTNCOMMONALL) do
        if Wnd_IsEnabled(self.UIGROUP, szBtnName) == 1 then
          Btn_Check(self.UIGROUP, szBtnName, 0)
          self:OnButtonClick(szBtnName, 0)
        end
      end
      self.m_tbOption.nSelectCommonAll = 0
    else
      for _, szBtnName in ipairs(self.BTNCOMMONALL) do
        if Wnd_IsEnabled(self.UIGROUP, szBtnName) == 1 then
          Btn_Check(self.UIGROUP, szBtnName, 1)
          self:OnButtonClick(szBtnName, 1)
        end
      end
      self.m_tbOption.nSelectCommonAll = 1
    end
  elseif szWnd == self.BTN_PERFORMANCEALL then
    if nParam == 0 then
      for _, szBtnName in ipairs(self.BTNPERFORMANCEALL) do
        if Wnd_IsEnabled(self.UIGROUP, szBtnName) == 1 then -- 自动优化会控制可用性,不要冲突
          Btn_Check(self.UIGROUP, szBtnName, 0)
          self:OnButtonClick(szBtnName, 0)
        end
      end
      Btn_Check(self.UIGROUP, self.BTN_VERTICALSYNC, 0)
      self.m_tbOption.nSelectPerformanceAll = 0
    else
      for _, szBtnName in ipairs(self.BTNPERFORMANCEALL) do
        if Wnd_IsEnabled(self.UIGROUP, szBtnName) == 1 then
          Btn_Check(self.UIGROUP, szBtnName, 1)
          self:OnButtonClick(szBtnName, 1)
        end
      end
      Btn_Check(self.UIGROUP, self.BTN_VERTICALSYNC, 1)
      self.m_tbOption.nSelectPerformanceAll = 1
    end
  elseif szWnd == self.BTN_AUTOOPTIMIZE1 or szWnd == self.BTN_AUTOOPTIMIZE2 then
    self:SetAutoDisp(nParam)
    Btn_Check(self.UIGROUP, self.BTN_AUTOOPTIMIZE1, nParam)
    Btn_Check(self.UIGROUP, self.BTN_AUTOOPTIMIZE2, nParam)
  elseif szWnd == self.BTN_VERTICALSYNC then
  end

  --	优化Npc类型选择
  for i, szBtnNpc in ipairs(self.BTNNPCKIND) do
    if szWnd == szBtnNpc then
      if nParam == 0 then
        self.m_tbOptimize.tbNpcParam[i] = DISPLAY_MODE_NORMAL
      else
        self.m_tbOptimize.tbNpcParam[i] = DISPLAY_MODE_HIDE
      end
    end
  end

  --	优化显示选择
  for i, szBtn in ipairs(self.BTNCONT) do
    if szWnd == szBtn then
      if nParam == 0 then
        self.m_tbOptimize.tbParam[i] = DISPLAY_MODE_NORMAL
      else
        self.m_tbOptimize.tbParam[i] = DISPLAY_MODE_HIDE
      end
    end
  end

  for i = 1, self.BTN_PLUGINNAME_NUM do
    local szBtn = self.BTN_PLUGINNAME .. i
    if szWnd == szBtn then
      local nIndex = (self.nCurPluginPage - 1) * self.BTN_PLUGINNAME_NUM + i
      local nCheck = self.tbPluginParam[nIndex]

      local tbInfo = Ui.tbPluginInfoList[nIndex]
      local nCanUse = Ui:CheckPluginIsUse(tbInfo)
      if nCanUse == 0 then
        self.tbPluginParam[nIndex] = 0
        Btn_Check(self.UIGROUP, self.BTN_PLUGINNAME .. nIndex, 0)
      elseif nCheck == 0 then
        self.tbPluginParam[nIndex] = 1
      else
        self.tbPluginParam[nIndex] = 0
      end
    end
  end
end

function uiSystem:OnMouseEnter(szWnd)
  for i = 1, self.BTN_PLUGINNAME_NUM do
    local szBtn = self.BTN_PLUGINNAME .. i
    if szWnd == szBtn then
      local nIndex = (self.nCurPluginPage - 1) * self.BTN_PLUGINNAME_NUM + i
      local tbInfo = Ui.tbPluginInfoList[nIndex]
      local szTip = "无具体信息"
      local nCanUse, tbUseInfo = Ui:CheckPluginIsUse(tbInfo) --是否有效
      if tbInfo and tbInfo.szPluginName then
        local szPluginName = tbInfo.szPluginName
        szTip = string.format("%s\n\n<color=yellow>插件路径：%s\n插件更新时间：%s<color>\nPluginDate时间标准格式：YYYYmmdd\n例如：20120716\n", tbInfo.szContext, tbInfo.szPathFileName, tbInfo.nDate)
        if nCanUse == 0 then
          szTip = szTip .. string.format("\n<color=red>[插件已过期失效]\n需进行更新到最新日期：%s\n失效原因：%s<color>", tbUseInfo[1], tbUseInfo[2])
        end
      end
      Wnd_SetTip(self.UIGROUP, szWnd, szTip)
      break
    end
  end
end

function uiSystem:SwitchShowLife()
  if self.m_tbOption.nShowLife == 0 then
    self.m_tbOption.nShowLife = 1
  else
    self.m_tbOption.nShowLife = 0
  end
  me.nShowLife = self.m_tbOption.nShowLife
  Btn_Check(self.UIGROUP, self.BUTTON_SHOW_LIFE, math.mod(self.m_tbOption.nShowLife + 1, 2))
end

function uiSystem:SwitchShowName()
  if self.m_tbOption.nShowName == 0 then
    self.m_tbOption.nShowName = 1
  else
    self.m_tbOption.nShowName = 0
  end
  me.nShowName = self.m_tbOption.nShowName
  Btn_Check(self.UIGROUP, self.BUTTON_SHOW_NAME, math.mod(self.m_tbOption.nShowName + 1, 2))
end

function uiSystem:UpdateControlModel(nControlModel)
  if nControlModel == nil then
    nControlModel = 1
  end
  Btn_Check(self.UIGROUP, self.BUTTON_CTL_MODEL_1, nControlModel - 2)
  Btn_Check(self.UIGROUP, self.BUTTON_CTL_MODEL_2, nControlModel - 1)
end

function uiSystem:SetControlModel(nControlModel)
  if nControlModel == nil then
    nControlModel = 1
  end
  self:UpdateControlModel(nControlModel)
  UiShortcutAlias:SetControlModel(nControlModel)
end

function uiSystem:UpdatePagePlugin()
  local tbPluginInfoList = Ui.tbPluginInfoList
  local nPluginNum = #tbPluginInfoList
  local nPageNum = math.ceil(nPluginNum / self.BTN_PLUGINNAME_NUM)
  local szDescribe = "说明：插件为非官方认可，其安全性没经过官方测试，用户将自行承担因使用插件造成的一切不良后果。如遇到客户端异常情况，请尝试关闭插件。<color=yellow>开关插件都需要重启客户端才能生效。<color><link:url:多玩插件下载专区,点击打开专区页面,http://jxsj.duowan.com/cj/index.html>"

  TxtEx_SetText(self.UIGROUP, self.TXT_PLUGINDESCRIB, szDescribe)
  Txt_SetTxt(self.UIGROUP, self.TXT_PLUGINLISTPAGE, string.format("%d", self.nCurPluginPage))

  if self.nCurPluginPage <= 1 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_PLUGINPAGELEFT, 0)
  else
    Wnd_SetEnable(self.UIGROUP, self.BTN_PLUGINPAGELEFT, 1)
  end

  if self.nCurPluginPage >= nPageNum then
    Wnd_SetEnable(self.UIGROUP, self.BTN_PLUGINPAGERIGHT, 0)
  else
    Wnd_SetEnable(self.UIGROUP, self.BTN_PLUGINPAGERIGHT, 1)
  end

  if self.nPluginManagerLoadState == 1 then
    Btn_Check(self.UIGROUP, self.BTN_PLUGINOPEN, 1)
  else
    Btn_Check(self.UIGROUP, self.BTN_PLUGINOPEN, 0)
  end
  --Wnd_Hide(self.UIGROUP, self.BTN_PLUGINPAGELEFT);
  --Wnd_Hide(self.UIGROUP, self.BTN_PLUGINPAGERIGHT);
  --Wnd_Hide(self.UIGROUP, self.TXT_PLUGINLISTPAGE);
  local nStart = (self.nCurPluginPage - 1) * self.BTN_PLUGINNAME_NUM + 1
  local nEnd = self.nCurPluginPage * self.BTN_PLUGINNAME_NUM

  if nEnd > nPluginNum then
    nEnd = nPluginNum
  end
  local nIndex = 1
  for nIdx = 1, self.BTN_PLUGINNAME_NUM do
    Wnd_Hide(self.UIGROUP, self.BTN_PLUGINNAME .. nIdx)
  end
  for nIdx = nStart, nEnd do
    local tbInfo = tbPluginInfoList[nIdx]
    Wnd_Show(self.UIGROUP, self.BTN_PLUGINNAME .. nIndex)

    local nCanUse = Ui:CheckPluginIsUse(tbInfo) --是否有效

    if tbInfo.szPluginName then
      local szPluginName = tbInfo.szPluginName
      if nCanUse == 0 then
        szPluginName = "<color=red>[已过期失效]<color>" .. szPluginName
      end
      Btn_SetTxt(self.UIGROUP, self.BTN_PLUGINNAME .. nIndex, szPluginName)
    end
    if (self.tbPluginParam[nIdx] == 1) and nCanUse == 1 then
      Btn_Check(self.UIGROUP, self.BTN_PLUGINNAME .. nIndex, 1)
    else
      Btn_Check(self.UIGROUP, self.BTN_PLUGINNAME .. nIndex, 0)
    end

    if self.nPluginManagerLoadState == 1 then
      if nCanUse == 1 then
        Wnd_SetEnable(self.UIGROUP, self.BTN_PLUGINNAME .. nIndex, 1)
      end
    else
      Wnd_SetEnable(self.UIGROUP, self.BTN_PLUGINNAME .. nIndex, 0)
    end
    nIndex = nIndex + 1
  end
end

-- 显示优化
------------------------------------------------------------------------------------

function uiSystem:GetAlphaLevel(nValue)
  local nLevel
  if nValue <= 4 then
    return 1
  end
  if nValue >= 256 then
    return 7
  end
  for i = 3, 7 do
    if nValue >= (2 ^ i) - (2 ^ (i - 2)) and nValue < (2 ^ i) + (2 ^ (i - 1)) then
      return i - 1
    end
  end
end

--	设置是否自动优化显示
function uiSystem:SetAutoDisp(bAuto)
  if bAuto == 1 then
    for i, nParam in ipairs(self.m_tbOptimize.tbNpcParam) do
      Btn_Check(self.UIGROUP, self.BTNNPCKIND[i], 0)
      self.m_tbOptimize.tbNpcParam[i] = 0
      Wnd_SetEnable(self.UIGROUP, self.BTNNPCKIND[i], 0)
    end
    for i, nParam in ipairs(self.m_tbOptimize.tbParam) do
      Btn_Check(self.UIGROUP, self.BTNCONT[i], 0)
      self.m_tbOptimize.tbParam[i] = 0
      Wnd_SetEnable(self.UIGROUP, self.BTNCONT[i], 0)
    end
  else
    for i, nParam in ipairs(self.m_tbOptimize.tbNpcParam) do
      Wnd_SetEnable(self.UIGROUP, self.BTNNPCKIND[i], 1)
    end
    for i, nParam in ipairs(self.m_tbOptimize.tbParam) do
      Wnd_SetEnable(self.UIGROUP, self.BTNCONT[i], 1)
    end
  end
  self.m_tbOptimize.nAutoDisp = bAuto
end

function uiSystem:GetValueByAlphaLevel(nDisplayAlphaLevel)
  for i, v in ipairs(self.DISPLAYLEVEL) do
    if nDisplayAlphaLevel == v then
      return i
    end
  end
  return 256
end

function uiSystem:UpdateWndOpt()
  if self.m_tbOptimize.nAutoDisp == 1 then
    Btn_Check(self.UIGROUP, self.AUTODISP, 1)
  else
    Btn_Check(self.UIGROUP, self.AUTODISP, 0)
  end

  for i, nParam in ipairs(self.m_tbOptimize.tbNpcParam) do
    if nParam == DISPLAY_MODE_NORMAL then
      Btn_Check(self.UIGROUP, self.BTNNPCKIND[i], 0)
    elseif nParam == DISPLAY_MODE_HIDE then
      Btn_Check(self.UIGROUP, self.BTNNPCKIND[i], 1)
    end
  end

  for i, nParam in ipairs(self.m_tbOptimize.tbParam) do
    if nParam == DISPLAY_MODE_NORMAL then
      Btn_Check(self.UIGROUP, self.BTNCONT[i], 0)
    elseif nParam == DISPLAY_MODE_HIDE then
      Btn_Check(self.UIGROUP, self.BTNCONT[i], 1)
    end
  end

  Btn_Check(self.UIGROUP, self.BTN_AUTOOPTIMIZE1, self.m_tbOptimize.nAutoDisp)
  Btn_Check(self.UIGROUP, self.BTN_AUTOOPTIMIZE2, self.m_tbOptimize.nAutoDisp)
  Btn_Check(self.UIGROUP, self.BTN_VERTICALSYNC, GetVerticalSync())

  self:SetAutoDisp(self.m_tbOptimize.nAutoDisp)

  local nValue = self:GetValueByAlphaLevel(self.m_tbOptimize.nDisplayAlphaLevel)
  ScrBar_SetCurValue(self.UIGROUP, self.SCROLLBARSETTING, nValue - 1)
end

function uiSystem:SaveOptSetting()
  if self.m_tbOptimize.nDisplayAlphaLevel ~= self.m_tbOptimize.nBackupAlphaLevel then
    SetDisplayAlphaLevel(self.m_tbOptimize.nDisplayAlphaLevel)
  end

  if GetAutoDispState() ~= self.m_tbOptimize.nAutoDisp then
    ClientOptimizeMgr:ChangOptimizLevel(1)
  end

  SetAutoDispState(self.m_tbOptimize.nAutoDisp or 0)
  --if (self.m_tbOptimize.nAutoDisp == 0) then
  SetNpcDispKindConfig(NPCKIND_CONFIG_ME, self.m_tbOptimize.tbNpcParam[1])
  SetNpcDispKindConfig(NPCKIND_CONFIG_PLAYER, self.m_tbOptimize.tbNpcParam[2])
  SetNpcDispKindConfig(NPCKIND_CONFIG_NPC, self.m_tbOptimize.tbNpcParam[3])

  SetSceneDisplayConfig(DISPLAY_CONFIG_ME, self.m_tbOptimize.tbParam[1])
  SetSceneDisplayConfig(DISPLAY_CONFIG_PLAYER, self.m_tbOptimize.tbParam[2])
  SetSceneDisplayConfig(DISPLAY_CONFIG_NPC, self.m_tbOptimize.tbParam[3])
  SetSceneDisplayConfig(DISPLAY_CONFIG_SHADOW, self.m_tbOptimize.tbParam[4])
  SetSceneDisplayConfig(DISPLAY_CONFIG_SKILLEFFECT, self.m_tbOptimize.tbParam[5])
  SetSceneDisplayConfig(DISPLAY_CONFIG_MISSILE, self.m_tbOptimize.tbParam[6])
  SetSceneDisplayConfig(DISPLAY_CONFIG_SHORTTIMESTATE, self.m_tbOptimize.tbParam[7])
  SetSceneDisplayConfig(DISPLAY_CONFIG_LONGTIMESTATE, self.m_tbOptimize.tbParam[8])
  --end
end

------------------------------------------------------------------------------------

function uiSystem:PreUpdateShowCfg(bPreUpdateOn, nSpeedLimit)
  Btn_Check(self.UIGROUP, self.BTN_PREUPDATEONOFF, bPreUpdateOn)
  self.m_tbOption.nPreUpdateOn = bPreUpdateOn
  local nFactor = (self.DOWNLOAD_SPEED_MAX - self.DOWNLOAD_SPEED_MIN) / 10
  local nParam = (nSpeedLimit - self.DOWNLOAD_SPEED_MIN) / nFactor
  ScrBar_SetCurValue(self.UIGROUP, self.SCROLL_PREUPDATESPEED, nParam)
  self:PreUpdateShowMaxSpeed(nSpeedLimit)
end

function uiSystem:PreUpdateShowMaxSpeed(nSpeed)
  local szMaxSpeed = string.format("限速： %dK/S", nSpeed)
  Txt_SetTxt(self.UIGROUP, self.TXT_MAXUPDATESPEED, szMaxSpeed)
end

function uiSystem:PreUpdateShowCurSpeed()
  local nCurSpeed = Ui.tbLogic.tbPreUpdate:GetCurSpeed()
  local szCurSpeed = string.format("当前下载速度： %dK/S", nCurSpeed)
  Txt_SetTxt(self.UIGROUP, self.TXT_CURUPDATESPEED, szCurSpeed)
end

function uiSystem:OnTimer_ShowPreUpdateCurSpeed()
  self:PreUpdateShowCurSpeed()
end
