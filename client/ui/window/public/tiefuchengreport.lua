-------------------------------------------------------
-- 文件名　：tiefuchengreport.lua
-- 创建者　：huangxiaoming
-- 创建时间：2010-09-29 15:40:13
-- 文件描述：
-------------------------------------------------------

local uiTieFuChengReport = Ui:GetClass("tiefuchengreport")

uiTieFuChengReport.Btn_Close = "BtnClose"
uiTieFuChengReport.Txt_RemainTime = "TxtRemainTime"
uiTieFuChengReport.Txt_SelfTongName = "TxtSelfTongName"
uiTieFuChengReport.Txt_TongPlayerCount = "TxtTongPlayerCount"
uiTieFuChengReport.Lst_SelfResult = "LstSelfResult"
uiTieFuChengReport.Txt_SelfMark = "TxtSelfMark"
uiTieFuChengReport.Txt_ListRank = "TxtListRank"
uiTieFuChengReport.Txt_KillNum = "TxtKillNum"
uiTieFuChengReport.Txt_KillBouns = "TxtKillBouns"
uiTieFuChengReport.Txt_ProtectLongZhuNum = "TxtProtectLongZhuNum"
uiTieFuChengReport.Txt_ProtectLongZhuBouns = "TxtProtectLongZhuBouns"
uiTieFuChengReport.Txt_SeizeLongZhuNum = "TxtSeizeLongZhuNum"
uiTieFuChengReport.Txt_SeizeLongZhuBouns = "TxtSeizeLongZhuBouns"
uiTieFuChengReport.Txt_SeizeWangZuoNum = "TxtSeizeWangZuoNum"
uiTieFuChengReport.Txt_SeizeWangZuoBouns = "TxtSeizeWangZuoBouns"
uiTieFuChengReport.Txt_SelfMark = "TxtSelfMark"
uiTieFuChengReport.Txt_ListRank = "TxtListRank"
uiTieFuChengReport.Lst_AllTong1 = "LstAllTong1"
uiTieFuChengReport.Lst_AllTong2 = "LstAllTong2"
uiTieFuChengReport.Lst_AllTong3 = "LstAllTong3"
uiTieFuChengReport.Txt_AllTongTitle1 = "TxtAllTongTitle1"
uiTieFuChengReport.Txt_AllTongTitle2 = "TxtAllTongTitle2"
uiTieFuChengReport.Txt_AllTongTitle3 = "TxtAllTongTitle3"

function uiTieFuChengReport:Init()
  self.tbPlayerInfo = {
    ["szTongName"] = "", --帮会名字
    ["nTongPlayerCount"] = 0, --帮会人数
    ["nRemainTime"] = 0, --剩余时间
    ["nKillNum"] = 0, --伤敌玩家
    ["nKillBouns"] = 0, --伤敌玩家积分
    ["nSeizeLongZhuNum"] = 0, --占领龙柱数
    ["nSeizeLongZhuBouns"] = 0, --占领龙柱积分
    ["nProtectLongZhuNum"] = 0, --保护龙柱数
    ["nProtectLongZhuBouns"] = 0, --保护龙柱积分
    ["nSeizeWangZuoNum"] = 0, --占领王座数
    ["nSeizeWangZuoBouns"] = 0, --占领王座积分
    ["nTotalBouns"] = 0, --个人总积分
    ["nListRank"] = 0, --个人排名
  }
  self.tbTongInfo = {}
end

function uiTieFuChengReport:OnOpen()
  local _, tbData = me.GetCampaignDate()
  if tbData then
    self:OnRecvData(tbData)
  end
end

function uiTieFuChengReport:OnButtonClick(szWnd, nParam)
  if szWnd == uiTieFuChengReport.Btn_Close then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiTieFuChengReport:OnRecvData(tbData)
  if not tbData then
    return 0
  end

  local tbPlayerInfo = {}
  tbPlayerInfo.szTongName = tbData.szTongName
  tbPlayerInfo.nTongPlayerCount = tbData.nMemberCount
  tbPlayerInfo.nRemainTime = tbData.nRemainTime
  tbPlayerInfo.nKillNum = tbData.tbPlayerScore.tbKiller.nCount
  tbPlayerInfo.nKillBouns = tbData.tbPlayerScore.tbKiller.nScore
  tbPlayerInfo.nSeizeLongZhuNum = tbData.tbPlayerScore.tbPole.nCount
  tbPlayerInfo.nSeizeLongZhuBouns = tbData.tbPlayerScore.tbPole.nScore
  tbPlayerInfo.nProtectLongZhuNum = tbData.tbPlayerScore.tbProtect.nCount
  tbPlayerInfo.nProtectLongZhuBouns = tbData.tbPlayerScore.tbProtect.nScore
  tbPlayerInfo.nSeizeWangZuoNum = tbData.tbPlayerScore.tbThrone.nCount
  tbPlayerInfo.nSeizeWangZuoBouns = tbData.tbPlayerScore.tbThrone.nScore
  tbPlayerInfo.nTotalBouns = tbData.tbPlayerScore.nPoint
  tbPlayerInfo.nListRank = tbData.tbPlayerScore.nSort

  self.tbPlayerInfo = tbPlayerInfo
  self.tbTongInfo = tbData.tbGroupScore

  self:OnUpdate()
end

function uiTieFuChengReport:OnUpdate()
  Lst_Clear(self.UIGROUP, self.Lst_AllTong1)
  Lst_Clear(self.UIGROUP, self.Lst_AllTong2)
  Lst_Clear(self.UIGROUP, self.Lst_AllTong3)
  self:UpdateBaseInfo()
  self:UpdateSelfInfo()
  self:UpdateTongInfo()
end

function uiTieFuChengReport:GetLeftTime(nLeftSec)
  if not nLeftSec or nLeftSec <= 0 then
    return 0
  end
  local nLeftMin = math.floor(nLeftSec / 60) -- 剩余分钟数
  local nLeftHour = math.floor(nLeftMin / 60) -- 剩余消失数
  nLeftMin = math.mod(nLeftMin, 60)
  local szRet = string.format("%s小时%s分钟", nLeftHour, nLeftMin)
  return szRet
end

function uiTieFuChengReport:UpdateBaseInfo()
  Txt_SetTxt(self.UIGROUP, self.Txt_SelfTongName, "本帮会：" .. self.tbPlayerInfo.szTongName)
  Txt_SetTxt(self.UIGROUP, self.Txt_TongPlayerCount, string.format("本帮会人数：%s人", self.tbPlayerInfo.nTongPlayerCount))
  local szTime = self:GetLeftTime(self.tbPlayerInfo.nRemainTime)
  Txt_SetTxt(self.UIGROUP, self.Txt_RemainTime, "战局剩余时间：" .. szTime)
end

function uiTieFuChengReport:UpdateSelfInfo()
  Txt_SetTxt(self.UIGROUP, self.Txt_KillNum, self.tbPlayerInfo.nKillNum)
  Txt_SetTxt(self.UIGROUP, self.Txt_KillBouns, self.tbPlayerInfo.nKillBouns)
  Txt_SetTxt(self.UIGROUP, self.Txt_SeizeLongZhuNum, self.tbPlayerInfo.nSeizeLongZhuNum)
  Txt_SetTxt(self.UIGROUP, self.Txt_SeizeLongZhuBouns, self.tbPlayerInfo.nSeizeLongZhuBouns)
  Txt_SetTxt(self.UIGROUP, self.Txt_ProtectLongZhuNum, self.tbPlayerInfo.nProtectLongZhuNum)
  Txt_SetTxt(self.UIGROUP, self.Txt_ProtectLongZhuBouns, self.tbPlayerInfo.nProtectLongZhuBouns)
  Txt_SetTxt(self.UIGROUP, self.Txt_SeizeWangZuoNum, self.tbPlayerInfo.nSeizeWangZuoNum)
  Txt_SetTxt(self.UIGROUP, self.Txt_SeizeWangZuoBouns, self.tbPlayerInfo.nSeizeWangZuoBouns)
  Txt_SetTxt(self.UIGROUP, self.Txt_SelfMark, string.format("个人积分：%s", self.tbPlayerInfo.nTotalBouns))
  Txt_SetTxt(self.UIGROUP, self.Txt_ListRank, string.format("个人排名：%s", self.tbPlayerInfo.nListRank))
end

function uiTieFuChengReport:UpdateTongInfo()
  self:GenerateRowTitle(#self.tbTongInfo)
  for nIndex, tbInfo in ipairs(self.tbTongInfo) do
    local nFactIndex = 0
    local Lst_FactAllTong = ""
    if nIndex < 16 then
      nFactIndex = nIndex
      Lst_FactAllTong = self.Lst_AllTong1
    elseif nIndex < 31 then
      nFactIndex = nIndex - 15
      Lst_FactAllTong = self.Lst_AllTong2
    elseif nIndex < 46 then
      nFactIndex = nIndex - 30
      Lst_FactAllTong = self.Lst_AllTong3
    end
    if nFactIndex > 0 and Lst_FactAllTong ~= "" then
      if tbInfo.szTongName == self.tbPlayerInfo.szTongName then
        Lst_SetCell(self.UIGROUP, Lst_FactAllTong, nFactIndex, 0, "<color=yellow>" .. Lib:StrFillR(string.format("%s", nIndex), 3) .. "<color>")
        Lst_SetCell(self.UIGROUP, Lst_FactAllTong, nFactIndex, 1, "<color=yellow>" .. Lib:StrFillC(tbInfo.szTongName, 16) .. "<color>")
        Lst_SetCell(self.UIGROUP, Lst_FactAllTong, nFactIndex, 2, "<color=yellow>" .. Lib:StrFillC(tbInfo.nPoint, 6) .. "<color>")
      else
        Lst_SetCell(self.UIGROUP, Lst_FactAllTong, nFactIndex, 0, Lib:StrFillR(string.format("%s", nIndex), 3))
        Lst_SetCell(self.UIGROUP, Lst_FactAllTong, nFactIndex, 1, Lib:StrFillC(tbInfo.szTongName, 16))
        Lst_SetCell(self.UIGROUP, Lst_FactAllTong, nFactIndex, 2, Lib:StrFillC(tbInfo.nPoint, 6))
      end
    end
  end
end

function uiTieFuChengReport:GenerateRowTitle(nRowCount)
  local szTitle = " 排名      帮会名称        积分"
  if nRowCount >= 0 and nRowCount < 16 then
    Txt_SetTxt(self.UIGROUP, self.Txt_AllTongTitle1, szTitle)
    Txt_SetTxt(self.UIGROUP, self.Txt_AllTongTitle2, "")
    Txt_SetTxt(self.UIGROUP, self.Txt_AllTongTitle3, "")
  elseif nRowCount < 31 then
    Txt_SetTxt(self.UIGROUP, self.Txt_AllTongTitle1, szTitle)
    Txt_SetTxt(self.UIGROUP, self.Txt_AllTongTitle2, szTitle)
    Txt_SetTxt(self.UIGROUP, self.Txt_AllTongTitle3, "")
  elseif nRowCount < 46 then
    Txt_SetTxt(self.UIGROUP, self.Txt_AllTongTitle1, szTitle)
    Txt_SetTxt(self.UIGROUP, self.Txt_AllTongTitle2, szTitle)
    Txt_SetTxt(self.UIGROUP, self.Txt_AllTongTitle3, szTitle)
  end
end

function uiTieFuChengReport:SyncCampaignDate(szType)
  if szType == "Newland_report" then
    local _, tbData = me.GetCampaignDate()
    if not tbData then
      return 0
    end
    self:OnRecvData(tbData)
  end
end

function uiTieFuChengReport:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_CAMPAIGN_DATE, self.SyncCampaignDate },
  }
  return tbRegEvent
end

UiShortcutAlias:RegisterCampaignUi("Newland_report", Ui.UI_TIEFUCHENGREPORT)
