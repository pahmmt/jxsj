local uiOptimizePanel = Ui:GetClass("optimizepanel")

uiOptimizePanel.BTNACCEPT = "BtnAccept"
uiOptimizePanel.BTNCANCEL = "BtnCancel"
uiOptimizePanel.BTNCLOSE = "BtnClose"
uiOptimizePanel.TXTTITLE = "TxtTitle"
uiOptimizePanel.AUTODISP = "BtnAuto"
uiOptimizePanel.MANUALDISP = "BtnManual"
uiOptimizePanel.BTNNPCKIND = { "BtnMe", "BtnPlayer", "BtnNpc" }
uiOptimizePanel.BTNCONT = { "Btn1", "Btn2", "Btn3", "Btn4", "Btn5", "Btn6", "Btn7", "Btn8" }
uiOptimizePanel.SCROLLBAR = "ScrbarSetting"
uiOptimizePanel.DISPLAYLEVEL = { 4, 8, 16, 32, 64, 128, 256 }

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

function uiOptimizePanel:Init()
  self.nAutoDisp = 0
  self.tbNpcParam = {}
  self.tbParam = {}
  self.nDisplayAlphaLevel = 0
  self.nBackupAlphaLevel = 0
end

function uiOptimizePanel:GetAlphaLevel(nValue)
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

function uiOptimizePanel:OnOpen()
  self.nAutoDisp = GetAutoDispState()

  self.tbNpcParam[1] = GetNpcDispKindConfig(NPCKIND_CONFIG_ME)
  self.tbNpcParam[2] = GetNpcDispKindConfig(NPCKIND_CONFIG_PLAYER)
  self.tbNpcParam[3] = GetNpcDispKindConfig(NPCKIND_CONFIG_NPC)

  self.tbParam[1] = GetSceneDisplayConfig(DISPLAY_CONFIG_ME)
  self.tbParam[2] = GetSceneDisplayConfig(DISPLAY_CONFIG_PLAYER)
  self.tbParam[3] = GetSceneDisplayConfig(DISPLAY_CONFIG_NPC)
  self.tbParam[4] = GetSceneDisplayConfig(DISPLAY_CONFIG_SHADOW)
  self.tbParam[5] = GetSceneDisplayConfig(DISPLAY_CONFIG_SKILLEFFECT)
  self.tbParam[6] = GetSceneDisplayConfig(DISPLAY_CONFIG_MISSILE)
  self.tbParam[7] = GetSceneDisplayConfig(DISPLAY_CONFIG_SHORTTIMESTATE)
  self.tbParam[8] = GetSceneDisplayConfig(DISPLAY_CONFIG_LONGTIMESTATE)

  local nValue = GetDisplayAlphaLevel()
  local nLevel = self:GetAlphaLevel(nValue)
  self.nDisplayAlphaLevel = self.DISPLAYLEVEL[nLevel]
  self.nBackupAlphaLevel = self.nDisplayAlphaLevel
  self:UpdateWnd()
end

function uiOptimizePanel:OnScorllbarPosChanged(szWnd, nParam)
  if szWnd == self.SCROLLBAR then
    self.nDisplayAlphaLevel = self.DISPLAYLEVEL[nParam + 1]
  end
end

--	设置是否自动优化显示
function uiOptimizePanel:SetAutoDisp(bAuto)
  if bAuto == 1 then
    for i, nParam in ipairs(self.tbNpcParam) do
      Wnd_SetEnable(self.UIGROUP, self.BTNNPCKIND[i], 0)
    end
    for i, nParam in ipairs(self.tbParam) do
      Wnd_SetEnable(self.UIGROUP, self.BTNCONT[i], 0)
    end
  else
    for i, nParam in ipairs(self.tbNpcParam) do
      Wnd_SetEnable(self.UIGROUP, self.BTNNPCKIND[i], 1)
    end
    for i, nParam in ipairs(self.tbParam) do
      Wnd_SetEnable(self.UIGROUP, self.BTNCONT[i], 1)
    end
  end
end

function uiOptimizePanel:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTNACCEPT then
    self:Save()
    UiManager:CloseWindow(self.UIGROUP)
    return
  end

  --	自动优化显示配置
  if szWnd == self.AUTODISP then
    if self.nAutoDisp == 0 then
      self.nAutoDisp = 1
      Btn_Check(self.UIGROUP, self.MANUALDISP, 0)
      self:SetAutoDisp(1)
    else
      Btn_Check(self.UIGROUP, self.AUTODISP, 0)
    end
  elseif szWnd == self.MANUALDISP then
    if self.nAutoDisp == 1 then
      self.nAutoDisp = 0
      Btn_Check(self.UIGROUP, self.AUTODISP, 0)
      self:SetAutoDisp(0)
    else
      Btn_Check(self.UIGROUP, self.MANUALDISP, 0)
    end
  end

  --	优化Npc类型选择
  for i, szBtnNpc in ipairs(self.BTNNPCKIND) do
    if szWnd == szBtnNpc then
      if nParam == 0 then
        self.tbNpcParam[i] = DISPLAY_MODE_NORMAL
      else
        self.tbNpcParam[i] = DISPLAY_MODE_HIDE
      end
    end
  end

  --	优化显示选择
  for i, szBtn in ipairs(self.BTNCONT) do
    if szWnd == szBtn then
      if nParam == 0 then
        self.tbParam[i] = DISPLAY_MODE_NORMAL
      else
        self.tbParam[i] = DISPLAY_MODE_HIDE
      end
    end
  end

  if szWnd == self.BTNCANCEL or szWnd == self.BTNCLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiOptimizePanel:GetValueByAlphaLevel(nDisplayAlphaLevel)
  for i, v in ipairs(self.DISPLAYLEVEL) do
    if nDisplayAlphaLevel == v then
      return i
    end
  end
  return 256
end

function uiOptimizePanel:UpdateWnd()
  if self.nAutoDisp == 1 then
    Btn_Check(self.UIGROUP, self.AUTODISP, 1)
    Btn_Check(self.UIGROUP, self.MANUALDISP, 0)
  else
    Btn_Check(self.UIGROUP, self.AUTODISP, 0)
    Btn_Check(self.UIGROUP, self.MANUALDISP, 1)
  end

  for i, nParam in ipairs(self.tbNpcParam) do
    if nParam == DISPLAY_MODE_NORMAL then
      Btn_Check(self.UIGROUP, self.BTNNPCKIND[i], 0)
    elseif nParam == DISPLAY_MODE_HIDE then
      Btn_Check(self.UIGROUP, self.BTNNPCKIND[i], 1)
    end
  end

  for i, nParam in ipairs(self.tbParam) do
    if nParam == DISPLAY_MODE_NORMAL then
      Btn_Check(self.UIGROUP, self.BTNCONT[i], 0)
    elseif nParam == DISPLAY_MODE_HIDE then
      Btn_Check(self.UIGROUP, self.BTNCONT[i], 1)
    end
  end

  self:SetAutoDisp(self.nAutoDisp)

  local nValue = self:GetValueByAlphaLevel(self.nDisplayAlphaLevel)
  ScrBar_SetCurValue(self.UIGROUP, self.SCROLLBAR, nValue - 1)
end

function uiOptimizePanel:Save()
  if self.nDisplayAlphaLevel ~= self.nBackupAlphaLevel then
    SetDisplayAlphaLevel(self.nDisplayAlphaLevel)
  end

  SetAutoDispState(self.nAutoDisp)
  SetNpcDispKindConfig(NPCKIND_CONFIG_ME, self.tbNpcParam[1])
  SetNpcDispKindConfig(NPCKIND_CONFIG_PLAYER, self.tbNpcParam[2])
  SetNpcDispKindConfig(NPCKIND_CONFIG_NPC, self.tbNpcParam[3])

  SetSceneDisplayConfig(DISPLAY_CONFIG_ME, self.tbParam[1])
  SetSceneDisplayConfig(DISPLAY_CONFIG_PLAYER, self.tbParam[2])
  SetSceneDisplayConfig(DISPLAY_CONFIG_NPC, self.tbParam[3])
  SetSceneDisplayConfig(DISPLAY_CONFIG_SHADOW, self.tbParam[4])
  SetSceneDisplayConfig(DISPLAY_CONFIG_SKILLEFFECT, self.tbParam[5])
  SetSceneDisplayConfig(DISPLAY_CONFIG_MISSILE, self.tbParam[6])
  SetSceneDisplayConfig(DISPLAY_CONFIG_SHORTTIMESTATE, self.tbParam[7])
  SetSceneDisplayConfig(DISPLAY_CONFIG_LONGTIMESTATE, self.tbParam[8])
end
