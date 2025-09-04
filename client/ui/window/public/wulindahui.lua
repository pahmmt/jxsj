-----------------------------------------------------
--文件名		：	wulindahui.lua
--创建者		：	jiazhenwei
--创建时间		：	2009-9-14
--功能描述		：	武林大会战报
------------------------------------------------------

local uiWuLinDaHui = Ui:GetClass("wulindahui")

local TEXT_TEAM = "TxtVS"
local IMG_RESULT1 = "Img_Result1_"
local IMG_RESULT2 = "Img_Result2_"
local TEXT_KING = "TxtVSKing"
local SPR_PATH = "\\image\\ui\\001a\\leaguematch\\"
local BUTTON_CLOSE = "BtnClose"

local NUM = 32 --	总共32强赛
local nPosion = { [4] = 56, [8] = 48, [16] = 32, [32] = 0 } --每轮对阵对应ini文件中控件的开始位置
--如4强赛就是从TxtVS57到TxtVS60
local ResultTable = {
  "victory" .. UiManager.IVER_szVnSpr,
  "equal" .. UiManager.IVER_szVnSpr,
  "fail" .. UiManager.IVER_szVnSpr,
}

function uiWuLinDaHui:OnOpen()
  local _, tbDate = me.GetCampaignDate()
  if not tbDate then
    return 0
  end
  self:Update(tbDate)
end

function uiWuLinDaHui:OnButtonClick(szWnd)
  if szWnd == BUTTON_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiWuLinDaHui:Update(tbDate)
  if not tbDate then
    return
  end
  local szText
  if tbDate[1][1] then
    Txt_SetTxt(self.UIGROUP, TEXT_KING, "冠军：" .. tbDate[1][1].szName)
  end

  if tbDate[2][1] then
    Txt_SetTxt(self.UIGROUP, TEXT_TEAM .. 61, tbDate[2][1].szName)
    for i = 1, 3 do
      local nResult1 = tbDate[2][1].tbResult[i]
      if nResult1 then
        Img_SetImage(self.UIGROUP, IMG_RESULT1 .. i, 1, SPR_PATH .. ResultTable[nResult1])
      end
    end
  end

  if tbDate[2][2] then
    Txt_SetTxt(self.UIGROUP, TEXT_TEAM .. 62, tbDate[2][2].szName)
    for i = 1, 3 do
      local nResult2 = tbDate[2][2].tbResult[i]
      if nResult2 then
        Img_SetImage(self.UIGROUP, IMG_RESULT2 .. i, 1, SPR_PATH .. ResultTable[nResult2])
      end
    end
  end

  for i = 4, NUM do --匹配4-32强对手到相应的控件中
    if tbDate[i] then
      for j = 1, i / 2 do
        local nLast = i / 2 --上一级表
        local nIndexA = nPosion[i] + j
        szText = TEXT_TEAM .. nIndexA
        if tbDate[i][j] then
          Txt_SetTxt(self.UIGROUP, szText, tbDate[i][j].szName)
          for k, _ in ipairs(tbDate[nLast]) do --和上一级表对比，胜出的颜色设为黄色
            if tbDate[nLast][k] and tbDate[i][j].szName == tbDate[nLast][k].szName then
              Txt_SetTxtColor(self.UIGROUP, szText, "yellow")
            end
          end
        end
        local nIndexB = nPosion[i] + i - j + 1
        szText = TEXT_TEAM .. nIndexB
        if tbDate[i][i - j + 1] then
          Txt_SetTxt(self.UIGROUP, szText, tbDate[i][i - j + 1].szName)
          for k, _ in ipairs(tbDate[nLast]) do --和上一级表对比，胜出的颜色设为黄色
            if tbDate[nLast][k] and tbDate[i][i - j + 1].szName == tbDate[nLast][k].szName then
              Txt_SetTxtColor(self.UIGROUP, szText, "yellow")
            end
          end
        end
      end
    end
  end
end

-- 同步活动数据
function uiWuLinDaHui:SyncCampaignDate(szType)
  if szType == "WuLinDaHui" then
    local _, tbDate = me.GetCampaignDate()
    self:Update(tbDate)
  end
end

function uiWuLinDaHui:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_CAMPAIGN_DATE, self.SyncCampaignDate },
  }
  return tbRegEvent
end

-- 注册活动界面，才能用 ` 键打开
UiShortcutAlias:RegisterCampaignUi("WuLinDaHui", Ui.UI_WULINDAHUI)
