-----------------------------------------------------
--文件名		：	playerstate.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-04-19
--功能描述		：	主角头像界面
------------------------------------------------------

local tbPlayerState = Ui:GetClass("playerstate")
local tbTimer = Ui.tbLogic.tbTimer
local tbViewPlayerMgr = Ui.tbLogic.tbViewPlayerMgr
local TXT_LEVEL = "TxtLevel"
local TXT_LIFE = "TxtLife"
local TXT_MANA = "TxtMana"
local TXT_STAMINA = "TxtStamina"
local TXT_EXP = "TxtExp"
local IMG_PORTRAIT = "ImgPortrait"
local PRG_LIFE = "ImgPartLife"
local PRG_MANA = "ImgPartMana"
local PRG_STAMINA = "ImgPartStamina"
local PRG_EXP = "ImgPartExp"
local BTN_HELP = "BtnHelp"
local BTN_GM = "BtnGm"
local BTN_LOCK = "BtnLock"
local BTN_PARTNER = "BtnPartner"
local BTN_FIGHTPOWER = "BtnFightPower"
local TXT_FIGHTPOWER = "TxtFightPower"
local BTN_ZHENYUAN = "BtnZhenYuan"
local szLockSprPath = "\\image\\ui\\001a\\protect\\"
local POPTIP_DELAYTIME = Env.GAME_FPS * 30 -- 泡泡延时显示时间

function tbPlayerState:OnOpen()
  self:UpdateAll()
  Timer:Register(Env.GAME_FPS, Ui(Ui.UI_LOCKACCOUNT).StartOpenTimer4Tip, Ui(Ui.UI_LOCKACCOUNT))
end

function tbPlayerState:OnClose()
  Ui(Ui.UI_LOCKACCOUNT):CloseTimerTip()
end

function tbPlayerState:OnMouseEnter(szWnd)
  if szWnd == PRG_EXP then
    local nExp = me.GetExp()
    local nUpLevelExp = me.GetUpLevelExp()
    Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, "", "当前角色经验：" .. nExp .. "\n升级所需经验：" .. nUpLevelExp)
  end
end

function tbPlayerState:OnMouseLeave(szWnd)
  Wnd_HideMouseHoverInfo()
end

function tbPlayerState:UpdateAll()
  self:UpdateLife()
  self:UpdateMana()
  self:UpdateStamina()
  self:UpdateLevel()
  self:UpdatePortrait()
  self:UpdateExp()
  self:UpdateLock()

  -- 显示战斗力
  if not self.nFightPower then
    self.nFightPower = 0
  end
  self:UpdateFightPower(self.nFightPower)
end

function tbPlayerState:OnTimer()
  UiNotify:OnNotify(UiNotify.emCOREEVENT_SET_POPTIP, 42)
  tbTimer:Close(self.nTimerId)
end

function tbPlayerState:UpdateLock()
  if me.IsAccountLock() == 1 then
    Img_SetImage(self.UIGROUP, BTN_LOCK, 1, szLockSprPath .. "locked_state.spr")
  else
    Img_SetImage(self.UIGROUP, BTN_LOCK, 1, szLockSprPath .. "unlock_state.spr")
  end
  if me.IsAccountLockOpen() ~= 1 and not self.bAccountNotified then
    self.bAccountNotified = 1
    self.nTimerId = tbTimer:Register(POPTIP_DELAYTIME, self.OnTimer, self)
  elseif me.IsAccountLock() == 1 and not self.bAccountNotified then
    self.bAccountNotified = 1
    UiNotify:OnNotify(UiNotify.emCOREEVENT_SET_POPTIP, 44)
  end
end

function tbPlayerState:UpdateExp()
  local nExp = me.GetExp()
  local nUpLevelExp = me.GetUpLevelExp()
  local nExpPercent = 0

  if nUpLevelExp > 0 then
    nExpPercent = math.floor(nExp / nUpLevelExp * 10000)
  end
  local nWholeNumber = math.floor(math.abs(nExpPercent) / 100)

  local szSign = ""
  local nDecimal
  if nExpPercent < 0 then
    nDecimal = 100 - (nExpPercent % 100)
    szSign = "-"
  else
    nDecimal = nExpPercent % 100
  end
  Txt_SetTxt(self.UIGROUP, TXT_EXP, string.format("%s%d.%02d%%", szSign, nWholeNumber, nDecimal))
  Prg_SetPos(self.UIGROUP, PRG_EXP, nExpPercent / 10)
end

function tbPlayerState:UpdateLife()
  Prg_SetPos(self.UIGROUP, PRG_LIFE, me.nCurLife / me.nMaxLife * 1000)
  Txt_SetTxt(self.UIGROUP, TXT_LIFE, me.nCurLife .. "/" .. me.nMaxLife)
end

function tbPlayerState:UpdateMana()
  Prg_SetPos(self.UIGROUP, PRG_MANA, me.nCurMana / me.nMaxMana * 1000)
  Txt_SetTxt(self.UIGROUP, TXT_MANA, me.nCurMana .. "/" .. me.nMaxMana)
end

function tbPlayerState:UpdateStamina()
  Prg_SetPos(self.UIGROUP, PRG_STAMINA, me.nCurStamina / me.nMaxStamina * 1000)
  Txt_SetTxt(self.UIGROUP, TXT_STAMINA, me.nCurStamina .. "/" .. me.nMaxStamina)
end

function tbPlayerState:UpdateLevel()
  Txt_SetTxt(self.UIGROUP, TXT_LEVEL, me.nLevel)
end

function tbPlayerState:UpdateFightPower(nPower)
  self.nFightPower = nPower
  --nPower = nPower / 100;
  local szFightPower = string.format("%d", nPower)
  Txt_SetTxt(self.UIGROUP, TXT_FIGHTPOWER, szFightPower)
end

function tbPlayerState:UpdatePortrait()
  local szSpr, nType = tbViewPlayerMgr:GetMyPortraitSpr(me.nPortrait, me.nSex)

  Img_SetImage(self.UIGROUP, IMG_PORTRAIT, nType, szSpr)
end

function tbPlayerState:OnHelpOpen()
  Btn_Check(self.UIGROUP, BTN_HELP, 1)
end

function tbPlayerState:OnHelpClose()
  Btn_Check(self.UIGROUP, BTN_HELP, 0)
end

function tbPlayerState:OnButtonClick(szWnd, nParam)
  if szWnd == BTN_HELP then
    UiManager:SwitchWindow(Ui.UI_HELPSPRITE)
  end
  if szWnd == BTN_PARTNER then
    if Partner.bOpenPartner == 1 then
      UiManager:SwitchWindow(Ui.UI_PARTNER)
    end
  elseif BTN_FIGHTPOWER == szWnd then
    if UiManager:WindowVisible(Ui.UI_FIGHTPOWER) == 1 then
      UiManager:CloseWindow(Ui.UI_FIGHTPOWER)
    else
      if 1 == Player.tbFightPower:IsFightPowerValid() then
        UiManager:OpenWindow(Ui.UI_FIGHTPOWER)
      else
        Ui:ServerCall("UI_TASKTIPS", "Begin", "战斗力系统还未开放，敬请期待")
      end
      --UiManager:OpenWindow(Ui.UI_FIGHTPOWER);
    end
  elseif szWnd == BTN_ZHENYUAN then
    UiManager:SwitchWindow(Ui.UI_ZHENYUAN)
  end
  if szWnd == BTN_GM then
    --[[
		local nNowDate = tonumber(GetLocalDate("%y%m%d%H%M"))
		if Ui(Ui.UI_MSGBOARD).tbDate[me.nId] == nil then
			Ui(Ui.UI_MSGBOARD).tbDate[me.nId] = 0;
		end
		if (nNowDate - Ui(Ui.UI_MSGBOARD).tbDate[me.nId]) < 10 then
			Dialog:Say("您好，您上次留言已收到，请耐心等待客服人员回复。GM留言板发言有时间限制，如有其他问题，建议您稍后再留言。")
		else
		--]]
    UiManager:OpenWindow(Ui.UI_MSGBOARD)
    --end
  end

  if IVER_g_nSdoVersion == 0 and szWnd == BTN_LOCK then
    UiManager:OpenWindow(Ui.UI_LOCKACCOUNT)
  end
end

function tbPlayerState:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_LIFE, self.UpdateLife },
    { UiNotify.emCOREEVENT_SYNC_MANA, self.UpdateMana },
    { UiNotify.emCOREEVENT_SYNC_STAMINA, self.UpdateStamina },
    { UiNotify.emCOREEVENT_SYNC_SEX, self.UpdatePortrait },
    { UiNotify.emCOREEVENT_SYNC_PORTRAIT, self.UpdatePortrait },
    { UiNotify.emCOREEVENT_SYNC_LEVEL, self.UpdateLevel },
    { UiNotify.emCOREEVENT_SYNC_EXP, self.UpdateExp },
    { UiNotify.emCOREEVENT_SYNC_LOCK, self.UpdateLock },
  }
  return tbRegEvent
end
