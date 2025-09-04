local uiKinBattleReport = Ui:GetClass("kinbattlereport")

uiKinBattleReport.Btn_Close = "BtnClose" -- close按钮
uiKinBattleReport.Txt_KinName = "TxtKinName"
uiKinBattleReport.Txt_KinNameMate = "TxtKinNameMate"
uiKinBattleReport.Lst_PlayerInfo = "LstPlayerInfo"
uiKinBattleReport.Txt_RemainTime = "TxtRemainTime"
uiKinBattleReport.Txt_KinPlayerCount = "TxtSelfKinPlayerCount"
uiKinBattleReport.Txt_KinPlayerCountMate = "TxtOppKinPlayerCount"
uiKinBattleReport.Txt_PlayerKillCount = "TxtKillCount"
uiKinBattleReport.Txt_PlayerBeKillCount = "TxtBeKillCount"
uiKinBattleReport.Txt_PlayerJiuZhuanCount = "TxtJiuZhuanCount"
uiKinBattleReport.Txt_PlayerSeries = "TxtSeries"
uiKinBattleReport.Txt_PlayerMaxSeries = "TxtMaxSeries"
uiKinBattleReport.Txt_KinKillCount = "TxtKinKillCount"
uiKinBattleReport.Txt_KinBeKillCount = "TxtKinBeKillCount"
uiKinBattleReport.Txt_KinJiuZhuanCount = "TxtKinJiuZhuanCount"
uiKinBattleReport.Txt_KinKillCountMate = "TxtKinMateKillCount"
uiKinBattleReport.Txt_KinBeKillCountMate = "TxtKinMateBeKillCount"
uiKinBattleReport.Txt_KinJiuZhuanCountMate = "TxtKinMateJiuZhuanCount"
uiKinBattleReport.Txt_PlayerBeKillerHonor = "TxtKillHonor"

function uiKinBattleReport:Init()
  self.tbPlayerInfo = {
    szName = "", -- 玩家名字
    szRank = 1, -- 玩家排名
    nKillCount = 0, -- 杀敌总数
    nBeKillCount = 0, -- 死亡次数
    nMaxSeries = 0, -- 最大连斩数
    nSeries = 0, -- 当前连斩数
    nJiuZhuanCount = 0, -- 使用九转个数
    -- 杀死的披风等级
    tbBeKillerHonor = {
      [1] = 0,
      [2] = 0,
      [3] = 0,
      [4] = 0,
      [5] = 0,
      [6] = 0,
      [7] = 0,
      [8] = 0,
      [9] = 0,
      [10] = 0,
    },
    nRemainTime = 0, -- 离比赛结束剩余时间
  }
  self.tbKinInfo = -- 玩家所在家族信息
    {
      szName = "", -- 家族名
      nPlayerCount = 0, -- 玩家总数
      nKillCount = 0, -- 杀敌总数
      nBeKillCount = 0, -- 被杀总数
      nJiuZhuanCount = 0, -- 使用九转总数
    }
  self.tbKinInfoMate = -- 玩家对战家族信息
    {
      szName = "", -- 家族名
      nPlayerCount = 0, -- 玩家总数
      nKillCount = 0, -- 杀敌总数
      nBeKillCount = 0, -- 被杀总数
      nJiuZhuanCount = 0, -- 使用九转总数
    }
  self.tbPlayerInfoList = {} --排行榜信息
end

--接受传过来的数据，赋值给本地数据
function uiKinBattleReport:OnData(tbPlayerInfo, tbKinInfo, tbKinInfoMate, tbPlayerInfoList)
  self.tbPlayerInfo = tbPlayerInfo
  self.tbKinInfo = tbKinInfo
  self.tbKinInfoMate = tbKinInfoMate
  self.tbPlayerInfoList = tbPlayerInfoList

  self:OnUpdate()
end

function uiKinBattleReport:OnOpen()
  local szType, tbData = me.GetCampaignDate()
  if not tbData or szType ~= "KinBattle" then
    return 0
  end
  self:OnData(tbData.tbInfo.tbPlayerInfo, tbData.tbInfo.tbKinInfo, tbData.tbInfo.tbKinInfoMate, tbData.tbPlayerInfoList)
end

-- 点击关闭按钮关闭界面
function uiKinBattleReport:OnButtonClick(szWnd, nParam)
  if szWnd == self.Btn_Close then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiKinBattleReport:GetLeftTime(nLeftSec)
  if not nLeftSec or nLeftSec <= 0 then
    return 0
  end
  local nLeftMin = math.ceil(nLeftSec / 60 / Env.GAME_FPS) -- 剩余分钟数
  local szRet = string.format("%s分钟", nLeftMin)
  return szRet
end

function uiKinBattleReport:OnUpdate()
  Txt_SetTxt(self.UIGROUP, self.Txt_KinName, self.tbKinInfo.szName)
  Txt_SetTxt(self.UIGROUP, self.Txt_KinNameMate, self.tbKinInfoMate.szName)
  Txt_SetTxt(self.UIGROUP, self.Txt_KinPlayerCount, self.tbKinInfo.nPlayerCount)
  Txt_SetTxt(self.UIGROUP, self.Txt_KinPlayerCountMate, self.tbKinInfoMate.nPlayerCount)
  Txt_SetTxt(self.UIGROUP, self.Txt_PlayerKillCount, self.tbPlayerInfo.nKillCount)
  Txt_SetTxt(self.UIGROUP, self.Txt_PlayerBeKillCount, self.tbPlayerInfo.nBeKillCount)
  Txt_SetTxt(self.UIGROUP, self.Txt_PlayerJiuZhuanCount, self.tbPlayerInfo.nJiuZhuanCount)
  Txt_SetTxt(self.UIGROUP, self.Txt_PlayerSeries, self.tbPlayerInfo.nSeries)
  Txt_SetTxt(self.UIGROUP, self.Txt_PlayerMaxSeries, self.tbPlayerInfo.nMaxSeries)
  Txt_SetTxt(self.UIGROUP, self.Txt_KinKillCount, self.tbKinInfo.nKillCount)
  Txt_SetTxt(self.UIGROUP, self.Txt_KinBeKillCount, self.tbKinInfo.nBeKillCount)
  Txt_SetTxt(self.UIGROUP, self.Txt_KinJiuZhuanCount, self.tbKinInfo.nJiuZhuanCount)
  Txt_SetTxt(self.UIGROUP, self.Txt_KinKillCountMate, self.tbKinInfoMate.nKillCount)
  Txt_SetTxt(self.UIGROUP, self.Txt_KinBeKillCountMate, self.tbKinInfoMate.nBeKillCount)
  Txt_SetTxt(self.UIGROUP, self.Txt_KinJiuZhuanCountMate, self.tbKinInfoMate.nJiuZhuanCount)
  for i = 1, #self.tbPlayerInfo.tbBeKillerHonor do
    Txt_SetTxt(self.UIGROUP, self.Txt_PlayerBeKillerHonor .. i, self.tbPlayerInfo.tbBeKillerHonor[i])
  end
  local szRemainTime = self:GetLeftTime(self.tbPlayerInfo.nRemainTime)
  Txt_SetTxt(self.UIGROUP, self.Txt_RemainTime, szRemainTime)
  Lst_Clear(self.UIGROUP, self.Lst_PlayerInfo)
  self:UpdatePlayerInfoList()
end

function uiKinBattleReport:UpdatePlayerInfoList()
  for nIndex, tbPlayerInfo in ipairs(self.tbPlayerInfoList) do
    if tbPlayerInfo.szName == self.tbPlayerInfo.szName then
      Lst_SetCell(self.UIGROUP, self.Lst_PlayerInfo, nIndex, 0, "<color=yellow>" .. Lib:StrFillR(string.format("%s", nIndex), 3) .. "<color>")
      Lst_SetCell(self.UIGROUP, self.Lst_PlayerInfo, nIndex, 1, "<color=yellow>" .. Lib:StrFillC(tbPlayerInfo.szName, 18) .. "<color>")
      Lst_SetCell(self.UIGROUP, self.Lst_PlayerInfo, nIndex, 2, "<color=yellow>" .. Lib:StrFillC(tbPlayerInfo.szKinName, 14) .. "<color>")
      Lst_SetCell(self.UIGROUP, self.Lst_PlayerInfo, nIndex, 3, "<color=yellow>" .. Lib:StrFillC(tbPlayerInfo.szFacName, 12) .. "<color>")
      Lst_SetCell(self.UIGROUP, self.Lst_PlayerInfo, nIndex, 4, "<color=yellow>" .. Lib:StrFillC(tbPlayerInfo.nKillCount, 10) .. "<color>")
      Lst_SetCell(self.UIGROUP, self.Lst_PlayerInfo, nIndex, 5, "<color=yellow>" .. Lib:StrFillC(tbPlayerInfo.nSeries, 10) .. "<color>")
      Lst_SetCell(self.UIGROUP, self.Lst_PlayerInfo, nIndex, 6, "<color=yellow>" .. Lib:StrFillC(tbPlayerInfo.nMaxSeries, 10) .. "<color>")
      Lst_SetCell(self.UIGROUP, self.Lst_PlayerInfo, nIndex, 7, "<color=yellow>" .. Lib:StrFillC(tbPlayerInfo.nJiuZhuanCount, 10) .. "<color>")
    else
      Lst_SetCell(self.UIGROUP, self.Lst_PlayerInfo, nIndex, 0, Lib:StrFillR(string.format("%s", nIndex), 3))
      Lst_SetCell(self.UIGROUP, self.Lst_PlayerInfo, nIndex, 1, Lib:StrFillC(tbPlayerInfo.szName, 18))
      Lst_SetCell(self.UIGROUP, self.Lst_PlayerInfo, nIndex, 2, Lib:StrFillC(tbPlayerInfo.szKinName, 14))
      Lst_SetCell(self.UIGROUP, self.Lst_PlayerInfo, nIndex, 3, Lib:StrFillC(tbPlayerInfo.szFacName, 12))
      Lst_SetCell(self.UIGROUP, self.Lst_PlayerInfo, nIndex, 4, Lib:StrFillC(tbPlayerInfo.nKillCount, 10))
      Lst_SetCell(self.UIGROUP, self.Lst_PlayerInfo, nIndex, 5, Lib:StrFillC(tbPlayerInfo.nSeries, 10))
      Lst_SetCell(self.UIGROUP, self.Lst_PlayerInfo, nIndex, 6, Lib:StrFillC(tbPlayerInfo.nMaxSeries, 10))
      Lst_SetCell(self.UIGROUP, self.Lst_PlayerInfo, nIndex, 7, Lib:StrFillC(tbPlayerInfo.nJiuZhuanCount, 10))
    end
  end
end

-- 同步活动数据
function uiKinBattleReport:SyncCampaignData(szType)
  if szType == "KinBattle" then
    local _, tbData = me.GetCampaignDate()
    if not tbData then
      return
    end
    self:OnData(tbData.tbInfo.tbPlayerInfo, tbData.tbInfo.tbKinInfo, tbData.tbInfo.tbKinInfoMate, tbData.tbPlayerInfoList)
  end
end

function uiKinBattleReport:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_CAMPAIGN_DATE, self.SyncCampaignData },
  }
  return tbRegEvent
end

UiShortcutAlias:RegisterCampaignUi("KinBattle", Ui.UI_KINBATTLEREPORT)
