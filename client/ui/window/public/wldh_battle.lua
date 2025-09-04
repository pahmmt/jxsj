-------------------------------------------------------
-- 文件名　：wldh_battle.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2009-09-22 14:15:35
-- 文件描述：
-------------------------------------------------------

local uiBattle = Ui:GetClass("wldh_battle")

uiBattle.TXT_LEAGUE_NAME = {
  [1] = { { "TxtLeague1", "TxtLeague4" }, { "TxtLeague2", "TxtLeague3" } },
  [2] = { "TxtLeagueF1", "TxtLeagueF2" },
  [3] = { "TxtLeagueG1" },
}

uiBattle.BUTTON_CLOSE = "BtnClose"

function uiBattle:OnOpen()
  local _, tbDate = me.GetCampaignDate()
  if not tbDate then
    return 0
  end
  self:Update(tbDate)
end

function uiBattle:OnButtonClick(szWnd)
  if szWnd == self.BUTTON_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiBattle:Update(tbDate)
  if not tbDate then
    return
  end

  if tbDate[1] then
    Txt_SetTxt(self.UIGROUP, self.TXT_LEAGUE_NAME[1][1][1], tbDate[1][1][1])
    Txt_SetTxt(self.UIGROUP, self.TXT_LEAGUE_NAME[1][1][2], tbDate[1][1][2])
    Txt_SetTxt(self.UIGROUP, self.TXT_LEAGUE_NAME[1][2][1], tbDate[1][2][1])
    Txt_SetTxt(self.UIGROUP, self.TXT_LEAGUE_NAME[1][2][2], tbDate[1][2][2])
  end

  if tbDate[2] then
    Txt_SetTxt(self.UIGROUP, self.TXT_LEAGUE_NAME[2][1], tbDate[2][1])
    Txt_SetTxt(self.UIGROUP, self.TXT_LEAGUE_NAME[2][2], tbDate[2][2])
  end

  if tbDate[3] then
    Txt_SetTxt(self.UIGROUP, self.TXT_LEAGUE_NAME[3][1], tbDate[3][1])
  end
end

function uiBattle:SyncCampaignDate(szType)
  if szType == "wldh_battle" then
    local _, tbDate = me.GetCampaignDate()
    self:Update(tbDate)
  end
end

function uiBattle:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_CAMPAIGN_DATE, self.SyncCampaignDate },
  }
  return tbRegEvent
end

UiShortcutAlias:RegisterCampaignUi("wldh_battle", Ui.UI_WLDH_BATTLE)
