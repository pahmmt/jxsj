local uiDomainReport = Ui:GetClass("domainreport")
local TXT_TONGDOMAINS = "TxtTongDomains" -- 帮会 帮会领土数
local TXT_SELFOFFER = "TxtSelfOffer" -- 目前功勋
local TXT_KILLTOWER = "TxtKillTower"
local TXT_KILLPLAYER = "TxtKillPlayer"
local TXTEX_MAPCOINNOTE_1 = "TxtexMapCoinNote_1"
local TXTEX_MAPCOINNOTE_2 = "TxtexMapCoinNote_2"
local TXTEX_TONGCOINNOTE_1 = "TxtexTongCoinNote_1"
local TXTEX_TONGCOINNOTE_2 = "TxtexTongCoinNote_2"
local TXTEX_TONGCOINNOTE_3 = "TxtexTongCoinNote_3"
local TXTEX_SORTNOTE = "TxtexSortNote"
local BTN_CLOSE = "BtnClose"
local TASK_GROUP = Domain.TASK_GROUP_ID
local TASK_ID = Domain.SCORE_ID
local TASK_ID_KILL_TOWER = Domain.KILL_TOWER -- 所在队伍攻下龙柱的次数
local TASK_ID_KILL_PLAYER = Domain.KILL_PLAYER -- 所在队伍杀玩家的个数

function uiDomainReport:Init() end

function uiDomainReport:OnOpen()
  self:UpdateBattleInfo()
end

function uiDomainReport:OnButtonClick(szWnd, nParam)
  if szWnd == BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiDomainReport:OnClose() end

function uiDomainReport:UpdateSocer()
  local nScore = me.GetTask(TASK_GROUP, TASK_ID)
  if nScore then
    Txt_SetTxt(self.UIGROUP, TXT_SELFOFFER, "目前功勋：" .. tostring(nScore))
  end

  local nKillTowerScore = me.GetTask(TASK_GROUP, TASK_ID_KILL_TOWER)
  if nKillTowerScore then
    Txt_SetTxt(self.UIGROUP, TXT_KILLTOWER, "攻下龙柱个数：" .. tostring(nKillTowerScore))
  end

  local nKillPlayerScore = me.GetTask(TASK_GROUP, TASK_ID_KILL_PLAYER)
  if nKillPlayerScore then
    Txt_SetTxt(self.UIGROUP, TXT_KILLPLAYER, "击败敌人数：" .. tostring(nKillPlayerScore))
  end
end

function uiDomainReport:UpdateBattleInfo()
  local szBattleType, tbReportInfo = me.GetCampaignDate()
  if szBattleType ~= "DomainBattle" then
    return 0
  end
  if tbReportInfo then
    local szCurMapTongSort_1 = ""
    local szCurMapTongSort_2 = ""
    local szCurMapTongSort_3 = ""
    local nTongCount = 0
    if tbReportInfo.tbSortInfo then
      for i, tbTongScore in ipairs(tbReportInfo.tbSortInfo) do
        if tbTongScore then
          nTongCount = nTongCount + 1
          if nTongCount <= 5 then
            szCurMapTongSort_1 = szCurMapTongSort_1 .. Lib:StrFillL(tbTongScore.szName, 14, " ") .. "    " .. Lib:StrFillL(tostring(tbTongScore.nScore), 8, " ") .. "<enter>"
          elseif nTongCount > 5 and nTongCount <= 10 then
            szCurMapTongSort_2 = szCurMapTongSort_2 .. Lib:StrFillL(tbTongScore.szName, 14, " ") .. "    " .. Lib:StrFillL(tostring(tbTongScore.nScore), 8, " ") .. "<enter>"
          end
        end
      end
    end

    TxtEx_SetText(self.UIGROUP, TXTEX_MAPCOINNOTE_1, szCurMapTongSort_1)
    TxtEx_SetText(self.UIGROUP, TXTEX_MAPCOINNOTE_2, szCurMapTongSort_2)

    local szMyTongScore_1 = ""
    local szMyTongScore_2 = ""
    local szMyTongScore_3 = ""
    local nMapCount = 0

    if tbReportInfo.tbMinInfo then
      for nMapId, nScore in pairs(tbReportInfo.tbMinInfo) do
        if nMapId and nScore then
          local szMapName, szMapPath = GetMapPath(nMapId)
          local szColor = "<color=red>"
          nMapCount = nMapCount + 1
          if tbReportInfo.tbMapSort[nMapId] and tbReportInfo.tbMapSort[nMapId] == 1 then
            szColor = "<color=green>"
          end

          if tbReportInfo.tbMapSort[nMapId] then
            if nMapCount <= 15 then
              szMyTongScore_1 = szMyTongScore_1 .. szColor .. Lib:StrFillL(szMapName, 14, " ") .. "    " .. Lib:StrFillL(tostring(nScore), 8, " ") .. tbReportInfo.tbMapSort[nMapId] .. "<color><enter>"
            elseif nMapCount > 15 and nMapCount <= 30 then
              szMyTongScore_2 = szMyTongScore_2 .. szColor .. Lib:StrFillL(szMapName, 14, " ") .. "    " .. Lib:StrFillL(tostring(nScore), 8, " ") .. tbReportInfo.tbMapSort[nMapId] .. "<color><enter>"
            elseif nMapCount > 30 and nMapCount <= 45 then
              szMyTongScore_3 = szMyTongScore_3 .. szColor .. Lib:StrFillL(szMapName, 14, " ") .. "    " .. Lib:StrFillL(tostring(nScore), 8, " ") .. tbReportInfo.tbMapSort[nMapId] .. "<color><enter>"
            end
          else
            if nMapCount <= 15 then
              szMyTongScore_1 = szMyTongScore_1 .. szColor .. Lib:StrFillL(szMapName, 14, " ") .. "    " .. Lib:StrFillL(tostring(nScore), 8, " ") .. "<color><enter>"
            elseif nMapCount > 15 and nMapCount <= 30 then
              szMyTongScore_2 = szMyTongScore_2 .. szColor .. Lib:StrFillL(szMapName, 14, " ") .. "    " .. Lib:StrFillL(tostring(nScore), 8, " ") .. "<color><enter>"
            elseif nMapCount > 30 and nMapCount <= 45 then
              szMyTongScore_3 = szMyTongScore_3 .. szColor .. Lib:StrFillL(szMapName, 14, " ") .. "    " .. Lib:StrFillL(tostring(nScore), 8, " ") .. "<color><enter>"
            end
          end
        end
      end
    end
    TxtEx_SetText(self.UIGROUP, TXTEX_TONGCOINNOTE_1, szMyTongScore_1)
    TxtEx_SetText(self.UIGROUP, TXTEX_TONGCOINNOTE_2, szMyTongScore_2)
    TxtEx_SetText(self.UIGROUP, TXTEX_TONGCOINNOTE_3, szMyTongScore_3)
  end
  self:UpdateSocer()
end

UiShortcutAlias:RegisterCampaignUi("DomainBattle", Ui.UI_DOMAINREPORT)

function uiDomainReport:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_DOMAINREPORT, self.UpdateBattleInfo },
  }
  return tbRegEvent
end
