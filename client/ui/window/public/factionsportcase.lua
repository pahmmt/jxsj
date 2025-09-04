-----------------------------------------------------
--文件名		：	factionsportcase.lua
--创建者		：	zhengyuhua
--创建时间		：	2008-3-4
--功能描述		：	门派竞技活动界面
------------------------------------------------------

local uiFactionSportcase = Ui:GetClass("factionsportcase")

local TEXT_PLAYER = "TxtPlayer%s_%s"
local BUTTON_CLOSE = "BtnClose"

local VS_TABLE = {
  1,
  16,
  8,
  9,
  4,
  13,
  5,
  12,
  2,
  15,
  7,
  10,
  3,
  14,
  6,
  11,
}

local CLEAR_PLAYER_NAME = "预赛第%s名"
local NUM = 16

function uiFactionSportcase:OnOpen()
  local _, tbDate = me.GetCampaignDate()
  if not tbDate then
    self:ClearDate()
    return 0
  end
  self:Update(tbDate)
end

function uiFactionSportcase:OnButtonClick(szWnd)
  if szWnd == BUTTON_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiFactionSportcase:ClearDate()
  local nIndex = 16
  local szText
  while nIndex > 0 do
    for i = 1, nIndex do
      szText = string.format(TEXT_PLAYER, nIndex, i)
      local szPlayer = ""
      if nIndex == 16 then
        szPlayer = string.format(CLEAR_PLAYER_NAME, VS_TABLE[i])
      end
      Txt_SetTxt(self.UIGROUP, szText, szPlayer)
    end
    nIndex = nIndex / 2
  end
end

function uiFactionSportcase:Update(tbDate)
  self:ClearDate()
  if not tbDate then
    return
  end
  local szText
  --Lib:ShowTB(tbDate);
  for i = 1, 16 do
    local nIndex = i
    if tbDate[i] then
      szText = string.format(TEXT_PLAYER, 16, nIndex)
      Txt_SetTxt(self.UIGROUP, szText, tbDate[i].szName)
      nIndex = math.ceil(nIndex / 2)
      if tbDate[i].nWinCount > 0 then
        szText = string.format(TEXT_PLAYER, 8, nIndex)
        Txt_SetTxt(self.UIGROUP, szText, tbDate[i].szName)
        nIndex = math.ceil(nIndex / 2)
      end
      if tbDate[i].nWinCount > 1 then
        szText = string.format(TEXT_PLAYER, 4, nIndex)
        Txt_SetTxt(self.UIGROUP, szText, tbDate[i].szName)
        nIndex = math.ceil(nIndex / 2)
      end
      if tbDate[i].nWinCount > 2 then
        szText = string.format(TEXT_PLAYER, 2, nIndex)
        Txt_SetTxt(self.UIGROUP, szText, tbDate[i].szName)
        nIndex = math.ceil(nIndex / 2)
      end
      if tbDate[i].nWinCount > 3 then
        szText = string.format(TEXT_PLAYER, 1, nIndex)
        Txt_SetTxt(self.UIGROUP, szText, tbDate[i].szName)
        nIndex = math.ceil(nIndex / 2)
      end
    end
  end
end

-- 同步活动数据
function uiFactionSportcase:SyncCampaignDate(szType)
  if szType == "FactionBattle" then
    local _, tbDate = me.GetCampaignDate()
    self:Update(tbDate)
  end
end

function uiFactionSportcase:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_CAMPAIGN_DATE, self.SyncCampaignDate },
  }
  return tbRegEvent
end

-- 注册活动界面，才能用 ` 键打开
UiShortcutAlias:RegisterCampaignUi("FactionBattle", Ui.UI_FACTION_SPORTCASE) -- 不能用uiFactionSportcase.UIGROUP，还没加载的
