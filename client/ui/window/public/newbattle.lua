-- 文件名　：newbattle.lua
-- 创建者　：LQY
-- 创建时间：2012-08-13 17:37:56
-- 说　　明：甘罗战场战报UI逻辑

local uiNewBattle = Ui:GetClass("newbattle")

uiNewBattle.BTN_CLOSE = "BtnClose" -- close按钮
uiNewBattle.TXT_BATTLE_NAME = "TxtBattleName" -- 战局名
uiNewBattle.TXT_BATTLE_MODE = "TxtBattleMode" -- 模式
uiNewBattle.TXT_MYCAMP_NUM = "TxtMyCampNum" -- 我方人数
uiNewBattle.TXT_ENEMYCAMP_NUM = "TxtEnemyCampNum" -- 敌方人数
uiNewBattle.TXT_REMAIN_TIME = "TxtRemainTime" -- 战局剩余时间
uiNewBattle.TXT_POINT = "TxtPoint" -- 个人积分
uiNewBattle.TXT_LIST_RANK = "TxtListRank" -- 排名
uiNewBattle.TXT_MAX_SERIESKILL = "TxtMaxSeriesKill" -- 最大连斩数
uiNewBattle.TXT_SERIESKILL = "TxtSeriesKill" -- 当前连斩
uiNewBattle.TXT_TOP_TITLE = "TxtTopTitle"
uiNewBattle.TXT_LIST_TITLE = "TxtListTitle"
uiNewBattle.TXT_KILL_COUNT = "TxtKillCount" -- 击杀玩家数量
uiNewBattle.TXT_KILL_POINT = "TxtKillPoint" -- 击杀玩家得分
uiNewBattle.LST_PLAYER_LIST = "LstPlayerList" -- 排行榜

uiNewBattle.TXT_PAOTAI_COUNT = "TxtMarshalCount" -- 摧毁炮台数量
uiNewBattle.TXT_PAOTAI_POINT = "TxtMarshalPoint" -- 摧毁炮台得分

uiNewBattle.TXT_JIANTA_COUNT = "TxtCampCount" -- 摧毁箭塔数量
uiNewBattle.TXT_JIANTA_POINT = "TxtCampPoint" -- 摧毁箭塔得分

uiNewBattle.TXT_ZHANCHE_COUNT = "TxtAdmiralCount" -- 摧毁战车数量
uiNewBattle.TXT_ZHANCHE_POINT = "TxtAdmiralPoint" -- 摧毁战车得分

uiNewBattle.TXT_DEF_LONGMAI = "TxtCampSongPoint" --守护龙脉
uiNewBattle.TXT_DEF_PAOTAI = "TxtTotalSongPoint" --守护炮台
uiNewBattle.TXT_DEF_SHOUHUZHE = "TxtTotalJinPoint" --守护守护者

uiNewBattle.TXT_SUGGESTION = "TxtSuggestion" --提示条

uiNewBattle.CAMP_NAME = { "宋", "金", "未知" }
uiNewBattle.BATTLE_MODE = { "冰火天堑" }

uiNewBattle.SUGGESTION = {
  "如果你的实力不足，使用载具将使你变得强大。",
  "战车上第一个位置为攻击位，第二个位置为移动位。",
  "冰火天堑中的箭塔、炮塔、龙脉只能使用战车进行攻击。",
  "使用战车摧毁敌方建筑将会获得海量积分。",
  "占领召唤石后可通过后营召唤师快速传送到召唤石周围。",
  "合理使用箭塔可以有效阻止战车的不断推进。",
  "炮塔是不可再生的重要资源，防守好炮塔才能立于不败之地。",
  "龙脉守护者是通往龙脉的最后一道防线，一定要保证万无一失！",
  "采用不同的策略最大化战车能力会带来出乎意料的效果。",
}

function uiNewBattle:Init()
  self.tbPlayerInfo = {
    ["szBattleName"] = "宋金战场", -- 战局名
    ["nCamp"] = 3, -- 玩家所在的阵营
    ["nBattleMode"] = 1, -- 模式
    ["nMyCampNum"] = 0, -- 本方人数
    ["nEnemyCampNum"] = 0, -- 敌方人数
    ["nRemainTime"] = 0, -- 战局剩余时间（秒）
    ["nKillPlayerNum"] = 0, -- 伤敌玩家
    ["nKillPlayerPoint"] = 0, -- 伤敌玩家奖励积分
    ["nKillJianTaCount"] = 0, -- 摧毁箭塔数
    ["nKillJianTaPoint"] = 0, -- 摧毁箭塔得分
    ["nKillZhanCheCount"] = 0, -- 摧毁战车数
    ["nKillZhanChePoint"] = 0, -- 摧毁战车得分
    ["nKillPaoTaiCount"] = 0, -- 摧毁炮台数
    ["nKillPaoTaiPoint"] = 0, -- 摧毁炮台得分
    ["nDefPaoTaiPoint"] = 0, -- 护卫炮台积分
    ["nDefShouHuzhePoint"] = 0, -- 护卫守护者积分
    ["nDefLongMaiPoint"] = 0, -- 护卫龙脉积分
    ["nPoint"] = 0, -- 个人积分
    ["nListRank"] = 0, -- 排名
    ["nMaxSeriesKill"] = 0, -- 最大连斩
    ["nSeriesKill"] = 0, -- 当前连斩
    ["nBattleState"] = 0, -- 战场状态
  }
  self.tbPlayerList = {}
end

function uiNewBattle:OnRecvData(tbPlayerList, tbPlayerInfo)
  self.tbPlayerInfo = tbPlayerInfo
  self.tbPlayerList = tbPlayerList
  self:OnUpdate()
end

function uiNewBattle:OnOpen()
  local szType, tbData = me.GetCampaignDate()
  if not tbData or szType ~= "newbattle_report" then
    return 0
  end
  self:OnRecvData(tbData.tbPlayerList, tbData.tbPlayerInfo)
  self.nSugLen = 0
  self.nWaitTime = 0
  self.nSugNum = 1
  self.szSugTxt = self.SUGGESTION[1]
  self.nRunTimer = Timer:Register(1, self.RunTxt, self)
end

function uiNewBattle:OnClose()
  if self.nRunTimer then
    Timer:Close(self.nRunTimer)
  end
end

function uiNewBattle:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiNewBattle:OnEscExclusiveWnd(szWnd)
  UiManager:CloseWindow(self.UIGROUP)
end

function uiNewBattle:OnUpdate()
  local tbInfo = self.tbPlayerInfo

  Txt_SetTxt(self.UIGROUP, self.TXT_BATTLE_NAME, tbInfo.szBattleName)
  Txt_SetTxt(self.UIGROUP, self.TXT_BATTLE_MODE, self.BATTLE_MODE[tbInfo.nBattleMode] or self.BATTLE_MODE[1])
  Txt_SetTxt(self.UIGROUP, self.TXT_MYCAMP_NUM, string.format("本方人数：%s", tbInfo.nMyCampNum))
  Txt_SetTxt(self.UIGROUP, self.TXT_ENEMYCAMP_NUM, string.format("敌方人数：%s", tbInfo.nEnemyCampNum))
  Txt_SetTxt(self.UIGROUP, self.TXT_REMAIN_TIME, string.format("剩余时间：%s", self:GetLeftTime(tbInfo.nRemainTime)))
  Txt_SetTxt(self.UIGROUP, self.TXT_KILL_COUNT, tbInfo.nKillPlayerNum)
  Txt_SetTxt(self.UIGROUP, self.TXT_KILL_POINT, tbInfo.nKillPlayerPoint)

  Txt_SetTxt(self.UIGROUP, self.TXT_JIANTA_COUNT, tbInfo.nKillJianTaCount)
  Txt_SetTxt(self.UIGROUP, self.TXT_JIANTA_POINT, tbInfo.nKillJianTaPoint)

  Txt_SetTxt(self.UIGROUP, self.TXT_ZHANCHE_COUNT, tbInfo.nKillZhanCheCount)
  Txt_SetTxt(self.UIGROUP, self.TXT_ZHANCHE_POINT, tbInfo.nKillZhanChePoint)

  Txt_SetTxt(self.UIGROUP, self.TXT_PAOTAI_COUNT, tbInfo.nKillPaoTaiCount)
  Txt_SetTxt(self.UIGROUP, self.TXT_PAOTAI_POINT, tbInfo.nKillPaoTaiPoint)

  Txt_SetTxt(self.UIGROUP, self.TXT_DEF_PAOTAI, tbInfo.nDefPaoTaiPoint)
  Txt_SetTxt(self.UIGROUP, self.TXT_DEF_SHOUHUZHE, tbInfo.nDefShouHuzhePoint)
  Txt_SetTxt(self.UIGROUP, self.TXT_DEF_LONGMAI, tbInfo.nDefLongMaiPoint)

  Txt_SetTxt(self.UIGROUP, self.TXT_POINT, string.format("个人积分（%s）：%s", self.CAMP_NAME[tbInfo.nCamp], tbInfo.nPoint))
  Txt_SetTxt(self.UIGROUP, self.TXT_LIST_RANK, string.format("个人排名：%s", tbInfo.nListRank))
  Txt_SetTxt(self.UIGROUP, self.TXT_MAX_SERIESKILL, string.format("最大连斩：%s", tbInfo.nMaxSeriesKill))
  Txt_SetTxt(self.UIGROUP, self.TXT_SERIESKILL, string.format("当前连斩：%s", tbInfo.nSeriesKill))
  Lst_Clear(self.UIGROUP, self.LST_PLAYER_LIST)
  for nIndex, tbLine in ipairs(self.tbPlayerList) do
    local tbColor = { "", "" }
    if tbLine.szPlayerName == me.szName then
      tbColor = { "<color=gold>", "<color>" }
    end
    Lst_SetCell(self.UIGROUP, self.LST_PLAYER_LIST, nIndex, 0, tbColor[1] .. self.CAMP_NAME[tbLine.nCamp] .. tbColor[2])
    Lst_SetCell(self.UIGROUP, self.LST_PLAYER_LIST, nIndex, 1, tbColor[1] .. tbLine.szFaction .. tbColor[2])
    Lst_SetCell(self.UIGROUP, self.LST_PLAYER_LIST, nIndex, 2, tbColor[1] .. tbLine.szPlayerName .. tbColor[2] .. ((tbLine.bFirstBlood == 1) and "<color=yellow><bclr=red>(一斩)<bclr><color>" or ""))
    Lst_SetCell(self.UIGROUP, self.LST_PLAYER_LIST, nIndex, 3, tbColor[1] .. tbLine.szTong .. tbColor[2])
    Lst_SetCell(self.UIGROUP, self.LST_PLAYER_LIST, nIndex, 4, tbColor[1] .. tbLine.nKillCount .. tbColor[2])
    Lst_SetCell(self.UIGROUP, self.LST_PLAYER_LIST, nIndex, 5, tbColor[1] .. tbLine.nMaxSeriesKill .. tbColor[2])
    Lst_SetCell(self.UIGROUP, self.LST_PLAYER_LIST, nIndex, 6, tbColor[1] .. tbLine.nPoint .. tbColor[2])
  end
end

function uiNewBattle:GetLeftTime(nTime)
  if not nTime or nTime <= 0 then
    return "-"
  end
  return string.format("%s分钟", math.floor(nTime / 60))
end

function uiNewBattle:SyncCampaignDate(szType)
  if szType == "newbattle_report" then
    local _, tbData = me.GetCampaignDate()
    if tbData then
      self:OnRecvData(tbData.tbPlayerList, tbData.tbPlayerInfo)
    end
  end
end

function uiNewBattle:RunTxt()
  --只在准备期间显示
  if self.tbPlayerInfo.nBattleState ~= 2 then
    self.nRunTimer = nil
    return 0
  end
  if self.nSugLen < string.len(self.szSugTxt) then
    self.nSugLen = self.nSugLen + 2
  else
    self.nWaitTime = self.nWaitTime + 1
    if self.nWaitTime > 50 then
      self.nWaitTime = 0
      self.nSugLen = 2
      if self.nSugNum < #self.SUGGESTION then
        self.nSugNum = self.nSugNum + 1
      else
        self.nSugNum = 1
      end
      self.szSugTxt = self.SUGGESTION[self.nSugNum]
    end
  end
  self.szSugTxtRun = string.sub(self.szSugTxt, 1, self.nSugLen)
  Txt_SetTxt(self.UIGROUP, uiNewBattle.TXT_SUGGESTION, "<color=yellow>提示：<color>" .. self.szSugTxtRun)
end

function uiNewBattle:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_CAMPAIGN_DATE, self.SyncCampaignDate },
  }
  return tbRegEvent
end

UiShortcutAlias:RegisterCampaignUi("newbattle_report", Ui.UI_NEWBATTLE)
