-----------------------------------------------------
--文件名		：	LeagueMatch.lua
--创建者		：	huangxin
--创建时间		：	2009-2-11
--功能描述		：	武林联赛战报
------------------------------------------------------

local uiLeagueMatch = Ui:GetClass("leaguematch")

local TEXT_TEAM = "TxtVS"
local IMG_RESULT1 = "Img_Result1_"
local IMG_RESULT2 = "Img_Result2_"
local TEXT_KING = "TxtVSKing"
local SPR_PATH = "\\image\\ui\\001a\\leaguematch\\"
local BUTTON_CLOSE = "BtnClose"

local VS_TABLE8 = {
  1,
  8,
  3,
  6,
  2,
  7,
  4,
  5,
}

local VS_TABLE4 = {
  1,
  3,
  2,
  4,
}

local ResultTable = {
  "victory" .. UiManager.IVER_szVnSpr,
  "equal" .. UiManager.IVER_szVnSpr,
  "fail" .. UiManager.IVER_szVnSpr,
  "equal" .. UiManager.IVER_szVnSpr,
}

function uiLeagueMatch:OnOpen()
  local _, tbDate = me.GetCampaignDate()
  if not tbDate then
    return 0
  end
  self:Update(tbDate)
end

function uiLeagueMatch:OnButtonClick(szWnd)
  if szWnd == BUTTON_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiLeagueMatch:Update(tbDate)
  if not tbDate then
    return
  end
  local szText
  if tbDate[1][1] then
    Txt_SetTxt(self.UIGROUP, TEXT_KING, "冠军：" .. tbDate[1][1].szName)
  end

  if tbDate[2][1] then
    Txt_SetTxt(self.UIGROUP, TEXT_TEAM .. 13, tbDate[2][1].szName)
    for i = 1, 3 do
      local nResult1 = tbDate[2][1].tbResult[i]
      if nResult1 then
        Img_SetImage(self.UIGROUP, IMG_RESULT1 .. i, 1, SPR_PATH .. ResultTable[nResult1])
      end
    end
  end

  if tbDate[2][2] then
    Txt_SetTxt(self.UIGROUP, TEXT_TEAM .. 14, tbDate[2][2].szName)
    for i = 1, 3 do
      local nResult2 = tbDate[2][2].tbResult[i]
      if nResult2 then
        Img_SetImage(self.UIGROUP, IMG_RESULT2 .. i, 1, SPR_PATH .. ResultTable[nResult2])
        --elseif tbDate[2][1].tbResult[i] then
        --	Img_SetImage(self.UIGROUP, IMG_RESULT2..i, 1, SPR_PATH..ResultTable[3]);
      end
    end
  end

  for i, nValue in ipairs(VS_TABLE4) do
    local nIndex = 8 + i
    szText = TEXT_TEAM .. nIndex
    if tbDate[4][nValue] then
      Txt_SetTxt(self.UIGROUP, szText, tbDate[4][nValue].szName)
    end
  end

  for i, nValue in ipairs(VS_TABLE8) do
    szText = TEXT_TEAM .. i
    if tbDate[8][nValue] then
      Txt_SetTxt(self.UIGROUP, szText, tbDate[8][nValue].szName)
      Txt_SetTxtColor(self.UIGROUP, szText, "yellow")
    end
  end
end

-- 同步活动数据
function uiLeagueMatch:SyncCampaignDate(szType)
  if szType == "LeagueMatch" then
    local _, tbDate = me.GetCampaignDate()
    self:Update(tbDate)
  end
end

function uiLeagueMatch:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_CAMPAIGN_DATE, self.SyncCampaignDate },
  }
  return tbRegEvent
end

-- 注册活动界面，才能用 ` 键打开
UiShortcutAlias:RegisterCampaignUi("LeagueMatch", Ui.UI_LEAGUEMATCH)
