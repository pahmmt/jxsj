-----------------------------------------------------
--文件名		：	expbar.lua
--创建者		：	zhangyuming
--创建时间		：	2010-08-18
--功能描述		：	经验条
------------------------------------------------------

local uiExpbar = Ui:GetClass("expbar")

local tbObject = Ui.tbLogic.tbObject
local tbMouse = Ui.tbLogic.tbMouse

local TXT_EXP = "TxtExp"
local PRG_EXP = "ImgPartExp"

function uiExpbar:OnOpen()
  self:UpdateExp()
end

function uiExpbar:OnClose() end

function uiExpbar:UpdateExp()
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

function uiExpbar:OnMouseEnter(szWnd)
  local nExp = me.GetExp()
  local nUpLevelExp = me.GetUpLevelExp()
  Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, "", "当前角色经验：" .. nExp .. "\n升级所需经验：" .. nUpLevelExp)
end

function uiExpbar:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_EXP, self.UpdateExp },
  }
  return tbRegEvent
end
