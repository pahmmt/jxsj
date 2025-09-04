local uiServerSpeed = Ui:GetClass("serverspeed")
local tbTimer = Ui.tbLogic.tbTimer

local INTERVAl = Env.GAME_FPS * 3 -- 3秒刷新一次
local IMG_SPEED = "ImgSpeed"
local FAST = 300
local NORMAL = 800

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

--	录像机状态
local REPLAY_STATE_INIT = 0
local REPLAY_STATE_RACING = 1
local REPLAY_STATE_SAVING = 2
local REPLAY_STATE_OPENNING = 3
local REPLAY_STATE_PREDRAW = 4
local REPLAY_STATE_PLAYING = 5
local REPLAY_STATE_PAUSEREC = 6

local AUTO_DISP_CFG_TIME = 5 --	自动优化配置间隔 3*AUTO_DISP_CFG_TIME 秒
local OPTIMIZE_FPS_LOW = 20 --	自动优化最低帧
local OPTIMIZE_FPS_HIGH = 50 --	自动优化最高帧
local OPTIMIZE_MAX_LEVEL = 3 --	显示优化最高级别（从0级最低开始）

function uiServerSpeed:Init()
  self.nTimerId = 0
  self.nDispTime = 0 --	刷新次数计数
  self.nTotleFps = 0 --	帧数和
  self.nOptimizeLevel = OPTIMIZE_MAX_LEVEL --	显示优化级别
  self.nOldAutoDisp = 0
end

function uiServerSpeed:OnOpen()
  self:UpdateState()
  self.nTimerId = tbTimer:Register(INTERVAl, self.OnTimer, self)
end

function uiServerSpeed:OnTimer()
  self:UpdateState()
end

--	载入优化配置
function uiServerSpeed:LoadOptimizeCfg(nOptLevel)
  if nOptLevel == 0 then
    SetNpcDispKindConfig(NPCKIND_CONFIG_ME, DISPLAY_MODE_NORMAL)
    SetNpcDispKindConfig(NPCKIND_CONFIG_PLAYER, DISPLAY_MODE_HIDE)
    SetNpcDispKindConfig(NPCKIND_CONFIG_NPC, DISPLAY_MODE_NORMAL)
    SetSceneDisplayConfig(DISPLAY_CONFIG_ME, DISPLAY_MODE_NORMAL)
    SetSceneDisplayConfig(DISPLAY_CONFIG_PLAYER, DISPLAY_MODE_HIDE)
    SetSceneDisplayConfig(DISPLAY_CONFIG_NPC, DISPLAY_MODE_NORMAL)
    SetSceneDisplayConfig(DISPLAY_CONFIG_SHADOW, DISPLAY_MODE_NORMAL)
    SetSceneDisplayConfig(DISPLAY_CONFIG_SKILLEFFECT, DISPLAY_MODE_HIDE)
    SetSceneDisplayConfig(DISPLAY_CONFIG_MISSILE, DISPLAY_MODE_HIDE)
    SetSceneDisplayConfig(DISPLAY_CONFIG_SHORTTIMESTATE, DISPLAY_MODE_NORMAL)
    SetSceneDisplayConfig(DISPLAY_CONFIG_LONGTIMESTATE, DISPLAY_MODE_HIDE)
  elseif nOptLevel == 1 then
    SetNpcDispKindConfig(NPCKIND_CONFIG_ME, DISPLAY_MODE_NORMAL)
    SetNpcDispKindConfig(NPCKIND_CONFIG_PLAYER, DISPLAY_MODE_HIDE)
    SetNpcDispKindConfig(NPCKIND_CONFIG_NPC, DISPLAY_MODE_NORMAL)
    SetSceneDisplayConfig(DISPLAY_CONFIG_ME, DISPLAY_MODE_NORMAL)
    SetSceneDisplayConfig(DISPLAY_CONFIG_PLAYER, DISPLAY_MODE_NORMAL)
    SetSceneDisplayConfig(DISPLAY_CONFIG_NPC, DISPLAY_MODE_NORMAL)
    SetSceneDisplayConfig(DISPLAY_CONFIG_SHADOW, DISPLAY_MODE_NORMAL)
    SetSceneDisplayConfig(DISPLAY_CONFIG_SKILLEFFECT, DISPLAY_MODE_HIDE)
    SetSceneDisplayConfig(DISPLAY_CONFIG_MISSILE, DISPLAY_MODE_HIDE)
    SetSceneDisplayConfig(DISPLAY_CONFIG_SHORTTIMESTATE, DISPLAY_MODE_NORMAL)
    SetSceneDisplayConfig(DISPLAY_CONFIG_LONGTIMESTATE, DISPLAY_MODE_HIDE)
  elseif nOptLevel == 2 then
    SetNpcDispKindConfig(NPCKIND_CONFIG_ME, DISPLAY_MODE_NORMAL)
    SetNpcDispKindConfig(NPCKIND_CONFIG_PLAYER, DISPLAY_MODE_HIDE)
    SetNpcDispKindConfig(NPCKIND_CONFIG_NPC, DISPLAY_MODE_NORMAL)
    SetSceneDisplayConfig(DISPLAY_CONFIG_ME, DISPLAY_MODE_NORMAL)
    SetSceneDisplayConfig(DISPLAY_CONFIG_PLAYER, DISPLAY_MODE_NORMAL)
    SetSceneDisplayConfig(DISPLAY_CONFIG_NPC, DISPLAY_MODE_NORMAL)
    SetSceneDisplayConfig(DISPLAY_CONFIG_SHADOW, DISPLAY_MODE_NORMAL)
    SetSceneDisplayConfig(DISPLAY_CONFIG_SKILLEFFECT, DISPLAY_MODE_NORMAL)
    SetSceneDisplayConfig(DISPLAY_CONFIG_MISSILE, DISPLAY_MODE_NORMAL)
    SetSceneDisplayConfig(DISPLAY_CONFIG_SHORTTIMESTATE, DISPLAY_MODE_NORMAL)
    SetSceneDisplayConfig(DISPLAY_CONFIG_LONGTIMESTATE, DISPLAY_MODE_HIDE)
  elseif nOptLevel == 3 then
    SetNpcDispKindConfig(NPCKIND_CONFIG_ME, DISPLAY_MODE_NORMAL)
    SetNpcDispKindConfig(NPCKIND_CONFIG_PLAYER, DISPLAY_MODE_NORMAL)
    SetNpcDispKindConfig(NPCKIND_CONFIG_NPC, DISPLAY_MODE_NORMAL)
    SetSceneDisplayConfig(DISPLAY_CONFIG_ME, DISPLAY_MODE_NORMAL)
    SetSceneDisplayConfig(DISPLAY_CONFIG_PLAYER, DISPLAY_MODE_NORMAL)
    SetSceneDisplayConfig(DISPLAY_CONFIG_NPC, DISPLAY_MODE_NORMAL)
    SetSceneDisplayConfig(DISPLAY_CONFIG_SHADOW, DISPLAY_MODE_NORMAL)
    SetSceneDisplayConfig(DISPLAY_CONFIG_SKILLEFFECT, DISPLAY_MODE_NORMAL)
    SetSceneDisplayConfig(DISPLAY_CONFIG_MISSILE, DISPLAY_MODE_NORMAL)
    SetSceneDisplayConfig(DISPLAY_CONFIG_SHORTTIMESTATE, DISPLAY_MODE_NORMAL)
    SetSceneDisplayConfig(DISPLAY_CONFIG_LONGTIMESTATE, DISPLAY_MODE_NORMAL)
  end
end

--	重写设置优化等级
function uiServerSpeed:ResetLevel()
  if self.nOldAutoDisp == 0 and GetAutoDispState() == 1 then
    self.nOptimizeLevel = OPTIMIZE_MAX_LEVEL
  end
  self.nOldAutoDisp = GetAutoDispState()
end

--	降低配置
function uiServerSpeed:LowerCfg()
  if self.nOptimizeLevel > 0 then
    self.nOptimizeLevel = self.nOptimizeLevel - 1
  end
  self:LoadOptimizeCfg(self.nOptimizeLevel)
end

--	提高配置
function uiServerSpeed:HigherCfg()
  if self.nOptimizeLevel < OPTIMIZE_MAX_LEVEL then
    self.nOptimizeLevel = self.nOptimizeLevel + 1
  end
  self:LoadOptimizeCfg(self.nOptimizeLevel)
end

--	自动调整显示优化配置
function uiServerSpeed:AutoDispCfg()
  --	local nAverageFps = self.nTotleFps / self.nDispTime;
  --	if nAverageFps < OPTIMIZE_FPS_LOW then
  --		self:LowerCfg();
  --	elseif nAverageFps > OPTIMIZE_FPS_HIGH then
  --		self:HigherCfg();
  --	end
end

function uiServerSpeed:UpdateState()
  local ndelay = GetPing()
  local nFps = GetFps()
  if nFps and ndelay then
    local szDate = "\n网络延迟：" .. ndelay .. " ms\n\n游戏帧数：" .. nFps .. " fps"
    local szInfoText = "\n\n<color=green>您当前的网络顺畅。<color>"
    local nAutoDisp = GetAutoDispState()
    local nReplayState = GetJxReplayerState()

    if nFps < 20 then
      szInfoText = "\n\n<color=yellow>您的游戏运行速度较慢，建议您提高系统配置以获得更快的运行速度。<color>"
    end

    --	时间间隔AUTO_DISP_CFG_TIME进行配置优化
    self:ResetLevel()
    if self.nDispTime >= AUTO_DISP_CFG_TIME then
      if nReplayState == REPLAY_STATE_INIT and nAutoDisp == 1 then
        self:AutoDispCfg()
      end
      self.nDispTime = 0
      self.nTotleFps = 0
    else
      self.nDispTime = self.nDispTime + 1
      self.nTotleFps = self.nTotleFps + nFps
    end

    if ndelay > NORMAL then
      szInfoText = "\n\n<color=yellow>您当前的网络延迟较高，无法正常进行游戏，建议您检查网络相关的配置。<color>"
    end

    Wnd_SetTip(self.UIGROUP, IMG_SPEED, szDate .. szInfoText)
    --Wnd_SetTip(self.UIGROUP, self.TXT_SYSTIME, szDate);

    if ndelay <= FAST then
      Img_SetFrame(self.UIGROUP, IMG_SPEED, 0)
    elseif ndelay > FAST and ndelay <= NORMAL then
      Img_SetFrame(self.UIGROUP, IMG_SPEED, 1)
    elseif ndelay > NORMAL then
      Img_SetFrame(self.UIGROUP, IMG_SPEED, 2)
    end
  end
end

function uiServerSpeed:OnClose()
  tbTimer:Close(self.nTimerId)
end
