-------------------------------------------------------
-- 文件名　 : superbattle.lua
-- 创建者　 : zhangjinpin@kingsoft
-- 创建时间 : 2011-06-11 17:02:47
-- 文件描述 :
-------------------------------------------------------

local uiSuperBattle = Ui:GetClass("superbattle")

uiSuperBattle.BTN_CLOSE = "BtnClose" -- close按钮
uiSuperBattle.TXT_BATTLE_NAME = "TxtBattleName" -- 战局名
uiSuperBattle.TXT_BATTLE_MODE = "TxtBattleMode" -- 模式
uiSuperBattle.TXT_MYCAMP_NUM = "TxtMyCampNum" -- 我方人数
uiSuperBattle.TXT_ENEMYCAMP_NUM = "TxtEnemyCampNum" -- 敌方人数
uiSuperBattle.TXT_REMAIN_TIME = "TxtRemainTime" -- 战局剩余时间
uiSuperBattle.TXT_POINT = "TxtPoint" -- 个人积分
uiSuperBattle.TXT_LIST_RANK = "TxtListRank" -- 排名
uiSuperBattle.TXT_MAX_SERIESKILL = "TxtMaxSeriesKill" -- 最大连斩数
uiSuperBattle.TXT_SERIESKILL = "TxtSeriesKill" -- 当前连斩
uiSuperBattle.TXT_TOP_TITLE = "TxtTopTitle"
uiSuperBattle.TXT_LIST_TITLE = "TxtListTitle"
uiSuperBattle.TXT_KILL_COUNT = "TxtKillCount"
uiSuperBattle.TXT_KILL_POINT = "TxtKillPoint"
uiSuperBattle.TXT_CAMP_POINT = "TxtCampPoint"
uiSuperBattle.TXT_ADMIRAL_POINT = "TxtAdmiralPoint"
uiSuperBattle.TXT_MARSHAL_POINT = "TxtMarshalPoint"
uiSuperBattle.TXT_TOTALSONG_POINT = "TxtTotalSongPoint"
uiSuperBattle.TXT_TOTALJIN_POINT = "TxtTotalJinPoint"
uiSuperBattle.TXT_CAMPSONG_POINT = "TxtCampSongPoint"
uiSuperBattle.TXT_CAMPJIN_POINT = "TxtCampJinPoint"
uiSuperBattle.LST_PLAYER_LIST = "LstPlayerList"

uiSuperBattle.CAMP_NAME = { "宋", "金", "未知" }
uiSuperBattle.BATTLE_MODE = { "杀戮模式" }

function uiSuperBattle:Init()
  self.tbPlayerInfo = {
    ["szBattleName"] = "梦回采石矶", -- 战局名
    ["nCamp"] = 3, -- 玩家所在的阵营
    ["nBattleMode"] = 1, -- 模式
    ["nMyCampNum"] = 0, -- 本方人数
    ["nEnemyCampNum"] = 0, -- 敌方人数
    ["nRemainTime"] = 0, -- 战局剩余时间（秒）
    ["nKillPlayerNum"] = 0, -- 伤敌玩家
    ["nKillPlayerPoint"] = 0, -- 伤敌玩家奖励积分
    ["nCampPoint"] = 0, -- 护卫营地积分
    ["nAdmiralPoint"] = 0, -- 护卫将军积分
    ["nMarshalPoint"] = 0, -- 护卫元帅积分
    ["nPoint"] = 0, -- 个人积分
    ["nListRank"] = 0, -- 排名
    ["nMaxSeriesKill"] = 0, -- 最大连斩
    ["nSeriesKill"] = 0, -- 当前连斩
    ["nTotalSongPoint"] = 0, -- 宋方积分
    ["nTotalJinPoint"] = 0, -- 金方积分
    ["nCampSongPoint"] = 0, -- 宋阵营分
    ["nCampJinPoint"] = 0, -- 金阵营分
  }
  self.tbPlayerList = {}
end

function uiSuperBattle:OnRecvData(tbPlayerList, tbPlayerInfo)
  self.tbPlayerInfo = tbPlayerInfo
  self.tbPlayerList = tbPlayerList
  self:OnUpdate()
end

function uiSuperBattle:OnOpen()
  local szType, tbData = me.GetCampaignDate()
  if not tbData or szType ~= "superbattle_report" then
    return 0
  end
  self:OnRecvData(tbData.tbPlayerList, tbData.tbPlayerInfo)
end

function uiSuperBattle:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiSuperBattle:OnEscExclusiveWnd(szWnd)
  UiManager:CloseWindow(self.UIGROUP)
end

function uiSuperBattle:OnUpdate()
  local tbInfo = self.tbPlayerInfo

  Txt_SetTxt(self.UIGROUP, self.TXT_BATTLE_NAME, tbInfo.szBattleName)
  Txt_SetTxt(self.UIGROUP, self.TXT_BATTLE_MODE, self.BATTLE_MODE[tbInfo.nBattleMode] or self.BATTLE_MODE[1])
  Txt_SetTxt(self.UIGROUP, self.TXT_MYCAMP_NUM, string.format("本方人数：%s", tbInfo.nMyCampNum))
  Txt_SetTxt(self.UIGROUP, self.TXT_ENEMYCAMP_NUM, string.format("敌方人数：%s", tbInfo.nEnemyCampNum))
  Txt_SetTxt(self.UIGROUP, self.TXT_REMAIN_TIME, string.format("剩余时间：%s", self:GetLeftTime(tbInfo.nRemainTime)))
  Txt_SetTxt(self.UIGROUP, self.TXT_KILL_COUNT, tbInfo.nKillPlayerNum)
  Txt_SetTxt(self.UIGROUP, self.TXT_KILL_POINT, tbInfo.nKillPlayerPoint)
  Txt_SetTxt(self.UIGROUP, self.TXT_CAMP_POINT, tbInfo.nCampPoint)
  Txt_SetTxt(self.UIGROUP, self.TXT_ADMIRAL_POINT, tbInfo.nAdmiralPoint)
  Txt_SetTxt(self.UIGROUP, self.TXT_MARSHAL_POINT, tbInfo.nMarshalPoint)
  Txt_SetTxt(self.UIGROUP, self.TXT_TOTALSONG_POINT, tbInfo.nTotalSongPoint)
  Txt_SetTxt(self.UIGROUP, self.TXT_TOTALJIN_POINT, tbInfo.nTotalJinPoint)
  Txt_SetTxt(self.UIGROUP, self.TXT_CAMPSONG_POINT, tbInfo.nCampSongPoint)
  Txt_SetTxt(self.UIGROUP, self.TXT_CAMPJIN_POINT, tbInfo.nCampJinPoint)
  Txt_SetTxt(self.UIGROUP, self.TXT_POINT, string.format("个人积分（%s）：%s", self.CAMP_NAME[tbInfo.nCamp], tbInfo.nPoint))
  Txt_SetTxt(self.UIGROUP, self.TXT_LIST_RANK, string.format("个人排名：%s", tbInfo.nListRank))
  Txt_SetTxt(self.UIGROUP, self.TXT_MAX_SERIESKILL, string.format("最大连斩：%s", tbInfo.nMaxSeriesKill))
  Txt_SetTxt(self.UIGROUP, self.TXT_SERIESKILL, string.format("当前连斩：%s", tbInfo.nSeriesKill))

  Lst_Clear(self.UIGROUP, self.LST_PLAYER_LIST)
  for nIndex, tbLine in ipairs(self.tbPlayerList) do
    Lst_SetCell(self.UIGROUP, self.LST_PLAYER_LIST, nIndex, 0, self.CAMP_NAME[tbLine.nCamp])
    Lst_SetCell(self.UIGROUP, self.LST_PLAYER_LIST, nIndex, 1, tbLine.szFaction)
    Lst_SetCell(self.UIGROUP, self.LST_PLAYER_LIST, nIndex, 2, tbLine.szPlayerName)
    Lst_SetCell(self.UIGROUP, self.LST_PLAYER_LIST, nIndex, 3, ServerEvent:GetServerNameByGateway(tbLine.szGateway))
    Lst_SetCell(self.UIGROUP, self.LST_PLAYER_LIST, nIndex, 4, tbLine.nKillCount)
    Lst_SetCell(self.UIGROUP, self.LST_PLAYER_LIST, nIndex, 5, tbLine.nMaxSeriesKill)
    Lst_SetCell(self.UIGROUP, self.LST_PLAYER_LIST, nIndex, 6, tbLine.nPoint)
  end
end

function uiSuperBattle:GetLeftTime(nTime)
  if not nTime or nTime <= 0 then
    return "-"
  end
  return string.format("%s分钟", math.floor(nTime / 60))
end

function uiSuperBattle:SyncCampaignDate(szType)
  if szType == "superbattle_report" then
    local _, tbData = me.GetCampaignDate()
    if tbData then
      self:OnRecvData(tbData.tbPlayerList, tbData.tbPlayerInfo)
    end
  end
end

function uiSuperBattle:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_CAMPAIGN_DATE, self.SyncCampaignDate },
  }
  return tbRegEvent
end

UiShortcutAlias:RegisterCampaignUi("superbattle_report", Ui.UI_SUPERBATTLE)
