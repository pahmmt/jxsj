-----------------------------------------------------
--文件名		：	uiLadder.lua
--创建者		：	tongxuehu@kingsoft.com
--创建时间		：	2008-03-07
--功能描述		：	排行榜界面
------------------------------------------------------

local uiLadder = Ui:GetClass("ladder")

uiLadder.CLOSE_BUTTON = "BtnClose"

uiLadder.PAGE_BUTTON_KEY_STR = "BtnPage"
uiLadder.PAGE_BUTTON_MAX_NUMBER = 7 -- 下标从1开始

uiLadder.GENRE_BUTTON_KEY_STR = "BtnGenre"
uiLadder.GENRE_BUTTON_MAX_NUMBER = 6

uiLadder.SUBJECT_BUTTON_KEY_STR = "BtnSubject"
uiLadder.SUBJECT_BUTTON_MAX_NUMBER = 13
uiLadder.SUBJECT_PER_PAGE_BUTTON = "BtnSubjectPre"
uiLadder.SUBJECT_NEXT_PAGE_BUTTON = "BtnSubjectNext"

uiLadder.PLAYER_BUTTON_KEY_STR = "BtnPlayer"
uiLadder.PLAYER_INDEX_KEY_STR = "TxtPlayerIndex"
uiLadder.PLAYER_PORTRAIT_KEY_STR = "ImgPlayerPortrait"
uiLadder.PLAYER_NAME_KEY_STR = "TxtPlayerName"
uiLadder.PLAYER_INFO_KEY_STR = "TxtPlayerInfo"
uiLadder.PLAYER_LIST_MAX_NUMBER = 10

uiLadder.PLAYER_LISTBUTTON_KEY_STR = "BtnListPlayer"
uiLadder.PLAYER_LISTBUTTON_TXT = "TxtListPlayerInfo"
uiLadder.PLAYER_LISTMODE_MAX_NUMBER = 20

uiLadder.PLAYER_FACTION_KEY_STR = "TxtPlayerSkillRoute"
uiLadder.PLAYER_KIN_KEY_STR = "TxtPlayerKin"
uiLadder.PLAYER_TONG_KEY_STR = "TxtPlayerTong"
uiLadder.PLAYER_LEVEL_KEY_STR = "TxtPlayerLevel"
uiLadder.PLAYER_EVENT_KEY_STR = "TxtPlayerEventDetail"
uiLadder.PAGE_BUTTON_LISTNEXT_STR = "BtnPlayerListNextPage"
uiLadder.PAGE_BUTTON_LISTPRE_STR = "BtnPlayerListPrePage"
uiLadder.TXT_LIST_PAGE = "TxtPlayerListPage"
uiLadder.BTN_MODECHANGE = "BtnLadderMode"
uiLadder.BTN_SEARCHMINE = "BtnSearchMine"
uiLadder.BTN_SEARCHOTHER = "BtnSearchOther"
uiLadder.IMG_BG_PLAYERPLANT = "ImgBgSelectedPlayer"
uiLadder.PAGE_COMMON = "PageCommon"
uiLadder.PAGE_FIGHTPOWER = "PageFightPower"
uiLadder.TXT_FIGHTPOWERRANK_KEY_STR = "TxtListFightPowerRank"
uiLadder.PLAYER_FPLIST_MAX_NUMBER = 10
uiLadder.SP_POWERREFERENCE = "ScrollInstructionLfp"
uiLadder.LST_POWERREFERENCE = "LstInstructionLfp"
uiLadder.Txt_CHEAD_PLAYERNAME = "TxtCheadPlayerName"
uiLadder.Txt_CHEAD_VALUE = "TxtCheadValue"
uiLadder.TXT_TIPFTP = "TxtTipFtp" -- 战斗力排行榜更新Tip
uiLadder.TXT_LEVELPOWERINTRO = "TxtLevelPowerIntro"

uiLadder.tbPlayerPlantMode = -- 用来控制排行榜玩家显示细节
  {
    nModeClassic = 0, -- 0=经典模式，
    nModeList = 1, -- 1=列表模式)
    nModeListFtp = 2, -- 2=战斗力排行榜模式
  }

uiLadder.tbChead = {
  { szName = "侠士", szValue = "战斗力" },
  { szName = "侠士", szValue = "成就点数" },
  { szName = "拥有者", szValue = "真元总价值" },
  { szName = "侠士", szValue = "等级" },
}

uiLadder.tbPorList = {
  [0] = {
    [1] = "\\image\\ui\\002a\\ladder\\imgportrait\\img_men_big_02.spr",
    [2] = "\\image\\ui\\002a\\ladder\\imgportrait\\img_men_small_02.spr",
  },
  [1] = {
    [1] = "\\image\\ui\\002a\\ladder\\imgportrait\\img_woman_big_04.spr",
    [2] = "\\image\\ui\\002a\\ladder\\imgportrait\\img_woman_small_04.spr",
  },
  [2] = {
    [1] = "\\image\\item\\other\\quest\\quest_0012_s.spr",
    [2] = "\\image\\item\\other\\quest\\quest_0012_s.spr",
  },
}

uiLadder.PLAYER_TXT_SUBTITLE_STR = "TxtSubTitle"

uiLadder.nCurPageIndex = 6

uiLadder.tbGenreList = {}
uiLadder.nCurGenreIndex = 1 -- 当前选定

uiLadder.tbSubjectList = {}
uiLadder.nCurFirstSubjectIndex = 0
uiLadder.nCurSubjectIndex = 0

uiLadder.tbPlayerList = {}
uiLadder.tbPlayerLadder = {}
uiLadder.nCurPlayerListPage = 1

uiLadder.tbPlantList = {}

uiLadder.nCurPlayerBtn = 1

uiLadder.nCurListMode = 0 -- 当前排行榜模式

uiLadder.tbCurSubjectMapList = {} --subject按钮与真实索引映射表
uiLadder.PageIdFightPower = 7

uiLadder.PageIdOther = 2
uiLadder.GenerIdKinRepute = 4
uiLadder.GenerIdKinEPlatForm = 3

-- 排行榜显示分页序号到ladderid.txt中nHugeId的映射
uiLadder.tbShowId2ReadHugeId = { --	ladderid.txt读取的nHugeId
  4,
  5,
  6,
  3,
  2,
  7,
  1,
}

uiLadder.tbReadHugeId2ShowId = { --
  7,
  5,
  4,
  1,
  2,
  3,
  6,
}

function uiLadder:Init()
  self.tbPlantList = {}
  self.tbSavedPropLadder = {}
end
-- 更新面板这块需要改进
function uiLadder:OnRefreshLadderPlan()
  self:OnOpen()
end

function uiLadder:OnOpen(nPageIndex, nGenIndex)
  if not self.tbPowerReference then
    self:LoadPowerRefTable()
  end
  self.tbPlantList = Ladder.tbLadderPlanName.tbLadder
  for nLoop = 1, self.PAGE_BUTTON_MAX_NUMBER do
    Wnd_Hide(self.UIGROUP, (self.PAGE_BUTTON_KEY_STR .. nLoop))
  end
  for nLoop = 1, #self.tbPlantList do
    if self.tbPlantList[nLoop] and self.tbPlantList[nLoop][0] and self.tbPlantList[nLoop][0][0] and self.tbPlantList[nLoop][0][0].szShowName and self.tbPlantList[nLoop][0][0].nIsable == 1 then
      Wnd_Show(self.UIGROUP, self:GetPageBtnName(nLoop))
      Btn_SetTxt(self.UIGROUP, self:GetPageBtnName(nLoop), self.tbPlantList[nLoop][0][0].szShowName)
    end
  end
  self.nCurPageIndex = nPageIndex or 6 -- 默认是财富榜
  -- 是否显示战斗力分页
  if 1 == Player.tbFightPower:IsFightPowerValid() then
    self.nCurPageIndex = nPageIndex or self.PageIdFightPower -- 若战斗力开了，默认战斗力榜
    Wnd_Show(self.UIGROUP, self:GetPageBtnName(self.PageIdFightPower))
  else
    Wnd_Hide(self.UIGROUP, self:GetPageBtnName(self.PageIdFightPower))
    if self.PageIdFightPower == nPageIndex then
      return
    end
  end

  self.nCurPlayerListPage = 1 -- 当前排行榜在第几页
  self.nCurListMode = self.tbPlayerPlantMode.nModeClassic -- 当前排行榜模式
  if self.PageIdFightPower == self.nCurPageIndex then
    self.nCurListMode = self.tbPlayerPlantMode.nModeListFtp
  else
    self.nCurListMode = self.tbPlayerPlantMode.nModeClassic -- 当前排行榜模式
  end
  self:UpdatePage(nGenIndex)
end

function uiLadder:GetLadderByType(nLadderType)
  local tbLadder = Ladder:GetLadderByType(nLadderType)
  return tbLadder
end

-- 添加一个参数，nMaxNumPerPage:每页玩家的个数  默认的是20个
function uiLadder:GetListByType(nLadderType, nPage, nMaxNumPerPage)
  local tbLadder = Ladder:GetListLadder(nLadderType, nPage, nMaxNumPerPage)
  return tbLadder
end

function uiLadder:OnRefresh()
  self:RequestPlayerList()
  self:UpdatePlayerList()
end

function uiLadder:OnSearchRefresh()
  self.tbSearchResult = Ladder.tbSearchResult
  if not self.tbSearchResult then
    return
  end
  local nRefCurSubjectIndex = self.tbCurSubjectMapList[self.nCurSubjectIndex] or self.nCurSubjectIndex
  local nType = self:GetType(0, self.nCurPageIndex, self.nCurGenreIndex, nRefCurSubjectIndex)
  if self.tbSearchResult.nLadderType ~= nType then
    self.tbSearchResult = nil
    return
  end
  if self.tbPlayerPlantMode.nModeListFtp == self.nCurListMode then
    -- 纠正页码
    local nPageCorr = (self.tbSearchResult.nPage - 1) * 2
    local tbLadder = self.tbSearchResult.tbLadder
    local nCnt = 0
    for i = 1, #tbLadder do
      local tbPlayer = tbLadder[i]
      if tbPlayer.szPlayerName == self.tbSearchResult.szName then
        nCnt = i
        break
      end
    end
    self.nCurPlayerListPage = nPageCorr + 1 + (math.floor(nCnt / 11))
  else
    --self.nCurListMode = self.tbPlayerPlantMode.nModeClassic;	--??
    self.nCurPlayerListPage = self.tbSearchResult.nPage
  end

  --self:SetModeBtnTxt();

  self:RequestPlayerList()
  self:UpdatePlayerList()
  self.tbSearchResult = nil
end

function uiLadder:OnButtonClick(szWnd, nParam)
  if szWnd == self.CLOSE_BUTTON then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.SUBJECT_PER_PAGE_BUTTON then
    self.nCurFirstSubjectIndex = self.nCurFirstSubjectIndex - 2
    self:UpdateSubject()
  elseif szWnd == self.SUBJECT_NEXT_PAGE_BUTTON then
    self.nCurFirstSubjectIndex = self.nCurFirstSubjectIndex + 2
    self:UpdateSubject()
  elseif szWnd == self.PAGE_BUTTON_LISTNEXT_STR then
    self.nCurPlayerListPage = self.nCurPlayerListPage + 1
    self:UpdateSubject()
    self:OnRefresh()
  elseif szWnd == self.PAGE_BUTTON_LISTPRE_STR then
    self.nCurPlayerListPage = self.nCurPlayerListPage - 1
    self:UpdateSubject()
    self:OnRefresh()
  elseif szWnd == self.BTN_MODECHANGE then
    if self.nCurListMode == self.tbPlayerPlantMode.nModeListFtp then
      if 1 == self.nCurGenreIndex then
        if 1 == Player.tbFightPower:IsFightPowerValid() then
          UiManager:SwitchWindow(Ui.UI_FIGHTPOWER)
        end
      elseif 2 == self.nCurGenreIndex then -- todo
        -- 打开我的成就面板
        UiManager:OpenWindow(Ui.UI_ACHIEVEMENT)
      elseif 3 == self.nCurGenreIndex then
        -- 打开真元面板
        UiManager:SwitchWindow(Ui.UI_ZHENYUAN)
      elseif 4 == self.nCurGenreIndex then
        -- 打开经验任务发布面板
        UiManager:OpenWindow(Ui.UI_EXPTASK, 1)
      end
    elseif self.nCurListMode == self.tbPlayerPlantMode.nModeClassic then
      self.nCurListMode = self.tbPlayerPlantMode.nModeList
    else
      self.nCurListMode = self.tbPlayerPlantMode.nModeClassic
    end
    self:SetModeBtnTxt()
    self:OnRefresh()
  elseif szWnd == self.BTN_SEARCHMINE then
    local szName = ""
    local nCurPage = self.nCurPageIndex
    local nCurGen = self.nCurGenreIndex
    local nCurSub = self.tbCurSubjectMapList[self.nCurSubjectIndex] or self.nCurSubjectIndex
    if self:CheckLadderMode(nCurPage, nCurGen, nCurSub) == 1 then
      local nLadderType = self:GetType(0, nCurPage, nCurGen, nCurSub)
      Ladder:ApplySearchListByName(nLadderType, me.szName)
    end
  elseif szWnd == self.BTN_SEARCHOTHER then
    local szName = ""
    local nCurPage = self.nCurPageIndex
    local nCurGen = self.nCurGenreIndex
    local nCurSub = self.tbCurSubjectMapList[self.nCurSubjectIndex] or self.nCurSubjectIndex
    if self:CheckLadderMode(nCurPage, nCurGen, nCurSub) == 1 and self.tbPlantList and self.tbPlantList[nCurPage] and self.tbPlantList[nCurPage][nCurGen] and self.tbPlantList[nCurPage][nCurGen][nCurSub] and self.tbPlantList[nCurPage][nCurGen][nCurSub].szShowName and string.len(self.tbPlantList[nCurPage][nCurGen][nCurSub].szShowName) > 0 and self.tbPlantList[nCurPage][nCurGen][nCurSub].nShowFlag > 0 then
      szName = self.tbPlantList[nCurPage][nCurGen][nCurSub].szShowName
      Ladder:ApplySearchLadder(nCurPage, nCurGen, nCurSub, szName)
    end
  else
    local _, _, szBtnIndex = string.find(szWnd, self.PAGE_BUTTON_KEY_STR .. "(%d+)")
    if szBtnIndex then
      self.nCurPageIndex = tonumber(szBtnIndex)
      -- showId到nHugeId的转换
      if self.tbShowId2ReadHugeId then
        self.nCurPageIndex = self.tbShowId2ReadHugeId[self.nCurPageIndex]
      end

      if self.PageIdFightPower == self.nCurPageIndex then
        self.nCurListMode = self.tbPlayerPlantMode.nModeListFtp
      else
        self.nCurListMode = self.tbPlayerPlantMode.nModeClassic
      end
      self:UpdatePage()
      return
    end

    _, _, szBtnIndex = string.find(szWnd, self.GENRE_BUTTON_KEY_STR .. "(%d+)")
    if szBtnIndex then
      self.nCurGenreIndex = tonumber(szBtnIndex)
      if self.tbPlayerPlantMode.nModeClassic ~= self.nCurListMode then
        self.nCurPlayerListPage = 1
      end
      self:UpdateGenre()
      return
    end

    _, _, szBtnIndex = string.find(szWnd, self.SUBJECT_BUTTON_KEY_STR .. "(%d+)")
    if szBtnIndex then
      local nBtnIndex = tonumber(szBtnIndex)
      self.nCurSubjectIndex = self.nCurFirstSubjectIndex + nBtnIndex - 1
      if self.tbPlayerPlantMode.nModeClassic ~= self.nCurListMode then
        self.nCurPlayerListPage = 1
      end
      self:UpdateSubject()
      self:OnRefresh()
      return
    end

    _, _, szBtnIndex = string.find(szWnd, self.PLAYER_BUTTON_KEY_STR .. "(%d+)")
    if szBtnIndex then
      self.nCurPlayerBtn = tonumber(szBtnIndex)
      self:UpdatePlayer()
      return
    end
  end
end

function uiLadder:UpdatePage(nGenId)
  for i = 1, self.PAGE_BUTTON_MAX_NUMBER do
    local nChecked = 0
    if i == self.nCurPageIndex then
      nChecked = 1
    end
    Btn_Check(self.UIGROUP, self:GetPageBtnName(i), nChecked)
  end
  self.nCurGenreIndex = nGenId or 1

  self:UpdateGenre()
end

function uiLadder:UpdateGenre()
  local nCurPage = self.nCurPageIndex
  for i = 1, self.GENRE_BUTTON_MAX_NUMBER do
    local szBtnName = self.GENRE_BUTTON_KEY_STR .. i
    local nChecked = 0
    if self.tbPlantList[nCurPage] and self.tbPlantList[nCurPage][i] and self.tbPlantList[nCurPage][i][0].szShowName and self.tbPlantList[nCurPage][i][0].nShowFlag > 0 then
      if i == self.nCurGenreIndex then
        nChecked = 1
      end
      Btn_SetTxt(self.UIGROUP, szBtnName, self.tbPlantList[nCurPage][i][0].szShowName)
      Wnd_Show(self.UIGROUP, szBtnName)
    else
      Wnd_Hide(self.UIGROUP, szBtnName)
    end
    Btn_Check(self.UIGROUP, szBtnName, nChecked)
  end
  self.nCurSubjectIndex = 0
  if self.PageIdFightPower == nCurPage and 3 == self.nCurGenreIndex then
    self.nCurSubjectIndex = 1 -- 真元
  end
  -- 家族威望榜特殊处理
  if self.PageIdOther == nCurPage and (self.GenerIdKinRepute == self.nCurGenreIndex or self.GenerIdKinEPlatForm == self.nCurGenreIndex) then
    Btn_SetTxt(self.UIGROUP, self.BTN_SEARCHMINE, "查询自己家族")
    Btn_SetTxt(self.UIGROUP, self.BTN_SEARCHOTHER, "查询其他家族")
  else
    Btn_SetTxt(self.UIGROUP, self.BTN_SEARCHMINE, "查询自己排名")
    Btn_SetTxt(self.UIGROUP, self.BTN_SEARCHOTHER, "查询他人排名")
  end
  self:UpdateSubject()
  self:OnRefresh()
end

function uiLadder:UpdateSubject()
  self.tbCurSubjectMapList = {}
  Wnd_SetEnable(self.UIGROUP, self.SUBJECT_NEXT_PAGE_BUTTON, 0)
  Wnd_SetEnable(self.UIGROUP, self.SUBJECT_PER_PAGE_BUTTON, 0)
  local nCurPage = self.nCurPageIndex
  local nCurGen = self.nCurGenreIndex
  if not self.tbPlantList[nCurPage][nCurGen] then
    Wnd_Hide(self.UIGROUP, self.SUBJECT_NEXT_PAGE_BUTTON)
    Wnd_Hide(self.UIGROUP, self.SUBJECT_PER_PAGE_BUTTON)
    for i = 1, self.SUBJECT_BUTTON_MAX_NUMBER do
      local szBtnName = self.SUBJECT_BUTTON_KEY_STR .. i
      local nChecked = 0
      Wnd_Hide(self.UIGROUP, szBtnName)
      Btn_Check(self.UIGROUP, szBtnName, nChecked)
    end
    --		Txt_SetTxt(self.UIGROUP, self.PLAYER_TXT_SUBTITLE_STR, "");
    self.nCurPlayerBtn = 0
    self:UpdatePlayerList()
    self:OnRefresh()
    return
  end
  local tbSubjectList = self.tbPlantList[nCurPage][nCurGen]
  --权宜之计：客户端手动配置nshowflag值
  if self.nCurPageIndex == 7 and self.nCurGenreIndex == 3 then
    for i = 1, #tbSubjectList do
      tbSubjectList[i].nShowFlag = 1
    end
  end
  self.tbCurSubjectMapList = self:GetSujectMapList(tbSubjectList)
  if #self.tbCurSubjectMapList <= self.SUBJECT_BUTTON_MAX_NUMBER then
    Wnd_SetEnable(self.UIGROUP, self.SUBJECT_NEXT_PAGE_BUTTON, 0)
    Wnd_SetEnable(self.UIGROUP, self.SUBJECT_PER_PAGE_BUTTON, 0)
    Wnd_Hide(self.UIGROUP, self.SUBJECT_NEXT_PAGE_BUTTON)
    Wnd_Hide(self.UIGROUP, self.SUBJECT_PER_PAGE_BUTTON)
  else
    Wnd_Show(self.UIGROUP, self.SUBJECT_NEXT_PAGE_BUTTON)
    Wnd_Show(self.UIGROUP, self.SUBJECT_PER_PAGE_BUTTON)
    Wnd_SetEnable(self.UIGROUP, self.SUBJECT_NEXT_PAGE_BUTTON, 1)
    Wnd_SetEnable(self.UIGROUP, self.SUBJECT_PER_PAGE_BUTTON, 1)
  end
  local nLastOfFirstSujectIndex = #tbSubjectList - self.SUBJECT_BUTTON_MAX_NUMBER + 1
  if math.fmod(nLastOfFirstSujectIndex, 2) == 0 then -- 使他是奇数，不然可能会上下跳动
    nLastOfFirstSujectIndex = nLastOfFirstSujectIndex + 1
  end
  if self.nCurFirstSubjectIndex >= nLastOfFirstSujectIndex then
    self.nCurFirstSubjectIndex = nLastOfFirstSujectIndex
    Wnd_SetEnable(self.UIGROUP, self.SUBJECT_NEXT_PAGE_BUTTON, 0)
  end
  if self.nCurFirstSubjectIndex <= 1 then
    self.nCurFirstSubjectIndex = 1
    Wnd_SetEnable(self.UIGROUP, self.SUBJECT_PER_PAGE_BUTTON, 0)
  end

  local nIndex = self.nCurFirstSubjectIndex
  local nPosIndex = 1
  for i = 1, self.SUBJECT_BUTTON_MAX_NUMBER do
    local szBtnName = self.SUBJECT_BUTTON_KEY_STR .. i
    local nChecked = 0
    if nIndex <= #self.tbCurSubjectMapList then
      local nTrueIndex = self.tbCurSubjectMapList[nIndex]
      if nIndex == self.nCurSubjectIndex then
        nChecked = 1
      end
      Btn_SetTxt(self.UIGROUP, szBtnName, tbSubjectList[nTrueIndex].szShowName)
      Wnd_Show(self.UIGROUP, szBtnName)
      Btn_Check(self.UIGROUP, szBtnName, nChecked)
    else
      Wnd_Hide(self.UIGROUP, szBtnName)
    end
    nIndex = nIndex + 1
  end
  self.nCurPlayerBtn = 1
  self:UpdatePlayerList()
end

function uiLadder:GetSujectMapList(tbSubjectList)
  local tbSujectMapList = {}
  local nIndex = 1
  for nSubjectIndex = 1, #tbSubjectList do
    if tbSubjectList[nSubjectIndex] and tbSubjectList[nSubjectIndex].szShowName and string.len(tbSubjectList[nSubjectIndex].szShowName) > 0 and tbSubjectList[nSubjectIndex].nShowFlag > 0 then
      tbSujectMapList[nIndex] = nSubjectIndex
      nIndex = nIndex + 1
    end
  end
  return tbSujectMapList
end

function uiLadder:UpdatePlayer()
  for nIndex = 1, self.PLAYER_LIST_MAX_NUMBER do
    local nChecked = 0
    if nIndex == self.nCurPlayerBtn then
      nChecked = 1
    end
    Btn_Check(self.UIGROUP, self.PLAYER_BUTTON_KEY_STR .. nIndex, nChecked)
  end

  if self.nCurPlayerBtn == 0 then
    return
  end

  local nPlayerIndex = (self.nCurPlayerListPage - 1) * self.PLAYER_LIST_MAX_NUMBER + self.nCurPlayerBtn
  local tbPlayer = self.tbPlayerLadder.tbLadder[nPlayerIndex]
  if not tbPlayer then
    return
  end
  local szSpr = self.tbPorList[tbPlayer.dwImgType][1]
  if szSpr then
    Img_SetImage(self.UIGROUP, self.PLAYER_PORTRAIT_KEY_STR, 1, szSpr)
  end

  --local szLevel = self:CorrectPlayerLevel(tbPlayer.szTxt3);

  Txt_SetTxt(self.UIGROUP, self.PLAYER_NAME_KEY_STR, tbPlayer.szName)
  Txt_SetTxt(self.UIGROUP, self.PLAYER_FACTION_KEY_STR, tbPlayer.szTxt2)
  Txt_SetTxt(self.UIGROUP, self.PLAYER_LEVEL_KEY_STR, tbPlayer.szTxt3)
  Txt_SetTxt(self.UIGROUP, self.PLAYER_KIN_KEY_STR, tbPlayer.szTxt4)
  Txt_SetTxt(self.UIGROUP, self.PLAYER_TONG_KEY_STR, tbPlayer.szTxt5)
  Txt_SetTxt(self.UIGROUP, self.PLAYER_EVENT_KEY_STR, tbPlayer.szContext)
end

function uiLadder:RefreshPlayerPlant()
  local szSpr = self.tbPorList[0][1]
  if szSpr then
    Img_SetImage(self.UIGROUP, self.PLAYER_PORTRAIT_KEY_STR, 1, "")
  end
  Txt_SetTxt(self.UIGROUP, self.PLAYER_NAME_KEY_STR, " ")
  Txt_SetTxt(self.UIGROUP, self.PLAYER_FACTION_KEY_STR, " ")
  Txt_SetTxt(self.UIGROUP, self.PLAYER_LEVEL_KEY_STR, " ")
  Txt_SetTxt(self.UIGROUP, self.PLAYER_EVENT_KEY_STR, " ")
  Txt_SetTxt(self.UIGROUP, self.PLAYER_KIN_KEY_STR, " ")
  Txt_SetTxt(self.UIGROUP, self.PLAYER_TONG_KEY_STR, " ")
end

function uiLadder:RequestPlayerList()
  local nType = 0
  local nCurPageIndex = self.nCurPageIndex
  local nCurGenreIndex = self.nCurGenreIndex
  local nCurSubjectIndex = self.tbCurSubjectMapList[self.nCurSubjectIndex] or self.nCurSubjectIndex
  nType = self:GetType(nType, nCurPageIndex, nCurGenreIndex, nCurSubjectIndex)
  local tbPlayerLadder = nil

  if self.tbPlayerPlantMode.nModeListFtp == self.nCurListMode then --战斗力排行榜
    if 3 == nCurGenreIndex then
      -- 真元用单独的接口
      local tbPropLadder = self:GetPropLadder(nCurSubjectIndex, self.nCurPlayerListPage)
      if tbPropLadder then
        self.tbPropList = tbPropLadder
      end
    else
      tbPlayerLadder = self:GetListByType(nType, self.nCurPlayerListPage, 10)
      if tbPlayerLadder then
        self.tbPlayerList = tbPlayerLadder
      end
    end
    return
  end

  -- 除战斗力之外的排行榜
  if self:CheckLadderMode(nCurPageIndex, nCurGenreIndex, nCurSubjectIndex) == 0 then
    tbPlayerLadder = self:GetLadderByType(nType)
  else
    if self.nCurListMode == 1 then -- 列表模式
      tbPlayerLadder = self:GetListByType(nType, self.nCurPlayerListPage)
      if tbPlayerLadder then
        self.tbPlayerList = tbPlayerLadder
      else
        self.tbPlayerList = { nLadderType = nType, nMaxLen = 0 }
      end
      return
    else
      tbPlayerLadder = self:GetLadderByType(nType)
    end
  end
  if tbPlayerLadder then
    self.tbPlayerLadder = tbPlayerLadder
  else
    self.tbPlayerLadder = { nLadderType = nType }
  end
end

function uiLadder:CheckLadderMode(nCurPage, nCurGen, nCurSub)
  if self.tbPlantList and self.tbPlantList[nCurPage] and self.tbPlantList[nCurPage][nCurGen] and self.tbPlantList[nCurPage][nCurGen][nCurSub] and self.tbPlantList[nCurPage][nCurGen][nCurSub].nModeFlag and self.tbPlantList[nCurPage][nCurGen][nCurSub].nModeFlag == 1 then
    return 1
  end
  return 0
end

function uiLadder:GetType(nType, nPage, nGen, nSub)
  if nPage == 4 and nGen == 3 then -- 因为不能移植联赛排行榜，所以干脆就做特殊处理
    nPage = 3
  end
  if 7 == nPage and 4 == nGen then -- 战斗力排行榜中的等级排行榜沿用老的
    nPage = 2
    nGen = 1
  end

  nType = KLib.SetByte(nType, 3, nPage)
  nType = KLib.SetByte(nType, 2, nGen)
  nType = KLib.SetByte(nType, 1, nSub)
  return nType
end

function uiLadder:UpdatePlayerList()
  local szContext = ""
  local nCurPage = self.nCurPageIndex
  local nCurGen = self.nCurGenreIndex
  local nCurSub = self.tbCurSubjectMapList[self.nCurSubjectIndex] or self.nCurSubjectIndex

  self:SetModeBtnTxt()

  if self.tbPlayerPlantMode.nModeListFtp == self.nCurListMode then -- 战斗力排行榜
    Wnd_Hide(self.UIGROUP, self.PAGE_COMMON)
    Wnd_Show(self.UIGROUP, self.PAGE_FIGHTPOWER)
    Wnd_SetEnable(self.UIGROUP, self.BTN_SEARCHMINE, 1)
    Wnd_SetEnable(self.UIGROUP, self.BTN_SEARCHOTHER, 1)
    Wnd_SetEnable(self.UIGROUP, self.BTN_MODECHANGE, 1)
    self:SwitchPowerReference()
    self:UpdateFightPowerRank(nCurPage, nCurGen, nCurSub)
  else -- 除战斗力之外的排行榜
    Wnd_Show(self.UIGROUP, self.PAGE_COMMON)
    Wnd_Hide(self.UIGROUP, self.PAGE_FIGHTPOWER)

    if self.tbPlantList and self.tbPlantList[nCurPage] and self.tbPlantList[nCurPage][nCurGen] and self.tbPlantList[nCurPage][nCurGen][nCurSub] and self.tbPlantList[nCurPage][nCurGen][nCurSub].nModeFlag and self.tbPlantList[nCurPage][nCurGen][nCurSub].nModeFlag == 1 then
      if self.tbPlayerPlantMode.nModeClassic == self.nCurListMode then
        Wnd_SetEnable(self.UIGROUP, self.BTN_SEARCHMINE, 0)
        Wnd_SetEnable(self.UIGROUP, self.BTN_SEARCHOTHER, 0)
        self:UpdatePlayerList_Mode_Detail(nCurPage, nCurGen, nCurSub)
      elseif self.tbPlayerPlantMode.nModeList == self.nCurListMode then
        Wnd_SetEnable(self.UIGROUP, self.BTN_SEARCHMINE, 1)
        Wnd_SetEnable(self.UIGROUP, self.BTN_SEARCHOTHER, 1)
        self:UpdatePlayerList_Mode_List(nCurPage, nCurGen, nCurSub)
      end
      Wnd_SetEnable(self.UIGROUP, self.BTN_MODECHANGE, 1)
      return
    end
    self:UpdatePlayerList_Mode_Detail(nCurPage, nCurGen, nCurSub)
    Wnd_SetEnable(self.UIGROUP, self.BTN_MODECHANGE, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_SEARCHMINE, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_SEARCHOTHER, 0)
  end
end

-- 列表模式
function uiLadder:UpdatePlayerList_Mode_List(nCurPage, nCurGen, nCurSub)
  local szContext = ""
  local nCurListPage = self.nCurPlayerListPage
  if self.tbPlantList and self.tbPlantList[nCurPage] and self.tbPlantList[nCurPage][nCurGen] and self.tbPlantList[nCurPage][nCurGen][nCurSub] and self.tbPlantList[nCurPage][nCurGen][nCurSub].szShowName and string.len(self.tbPlantList[nCurPage][nCurGen][nCurSub].szShowName) > 0 and self.tbPlantList[nCurPage][nCurGen][nCurSub].nShowFlag > 0 then
    szContext = self.tbPlantList[nCurPage][nCurGen][nCurSub].szShowName
  end
  Txt_SetTxt(self.UIGROUP, self.PLAYER_TXT_SUBTITLE_STR, szContext)
  for i = 1, self.PLAYER_LIST_MAX_NUMBER do
    Wnd_Hide(self.UIGROUP, self.PLAYER_BUTTON_KEY_STR .. i)
  end
  self:RefreshPlayerPlant()
  if not self.tbPlayerList or not self.tbPlayerList.tbLadder or #self.tbPlayerList.tbLadder <= 0 then
    for i = 1, self.PLAYER_LISTMODE_MAX_NUMBER do
      Wnd_Hide(self.UIGROUP, self.PLAYER_LISTBUTTON_KEY_STR .. i)
    end

    Txt_SetTxt(self.UIGROUP, self.TXT_LIST_PAGE, "1/1")
    Wnd_SetEnable(self.UIGROUP, self.PAGE_BUTTON_LISTNEXT_STR, 0)
    Wnd_SetEnable(self.UIGROUP, self.PAGE_BUTTON_LISTPRE_STR, 0)
    self:RefreshPlayerPlant()
    return
  end
  local nType = self:GetType(0, nCurPage, nCurGen, nCurSub)
  local tbPlayerLadder = self.tbPlayerList
  if nType <= 0 or tbPlayerLadder.nLadderType ~= nType then
    for i = 1, self.PLAYER_LISTMODE_MAX_NUMBER do
      Wnd_Hide(self.UIGROUP, self.PLAYER_LISTBUTTON_KEY_STR .. i)
    end
    return
  end
  local nMaxPageNumber = tbPlayerLadder.nMaxLadder / self.PLAYER_LISTMODE_MAX_NUMBER

  if nMaxPageNumber > math.floor(nMaxPageNumber) then
    nMaxPageNumber = math.floor(nMaxPageNumber) + 1
  end

  if self.nCurPlayerListPage < 1 then
    self.nCurPlayerListPage = 1
  elseif self.nCurPlayerListPage > nMaxPageNumber then
    self.nCurPlayerListPage = nMaxPageNumber
  end

  if self.nCurPlayerListPage == 1 then
    Wnd_SetEnable(self.UIGROUP, self.PAGE_BUTTON_LISTPRE_STR, 0)
  else
    Wnd_SetEnable(self.UIGROUP, self.PAGE_BUTTON_LISTPRE_STR, 1)
  end

  if self.nCurPlayerListPage == nMaxPageNumber then
    Wnd_SetEnable(self.UIGROUP, self.PAGE_BUTTON_LISTNEXT_STR, 0)
  else
    Wnd_SetEnable(self.UIGROUP, self.PAGE_BUTTON_LISTNEXT_STR, 1)
  end

  Txt_SetTxt(self.UIGROUP, self.TXT_LIST_PAGE, self.nCurPlayerListPage .. "/" .. nMaxPageNumber)

  local nPageIndex = 0
  for i = 1, self.PLAYER_LISTMODE_MAX_NUMBER do
    local nPlayerIndex = nPageIndex + i
    local tbPlayer = tbPlayerLadder.tbLadder[nPlayerIndex]
    if tbPlayer then
      local tbSpace = { 0, 4, 16 }
      local nRank = nPlayerIndex + (self.nCurPlayerListPage - 1) * self.PLAYER_LISTMODE_MAX_NUMBER
      local szTxt = self:GetFormatTxt(tbSpace, nRank, tbPlayer.szPlayerName, tostring(tbPlayer.dwValue))
      if self.tbSearchResult then
        --if (KLib.FindStr(self.tbSearchResult.szName, tbPlayer.szPlayerName)) then
        if self.tbSearchResult.szName == tbPlayer.szPlayerName then
          szTxt = "<color=yellow>" .. szTxt .. "<color>"
        end
      end
      Txt_SetTxt(self.UIGROUP, self.PLAYER_LISTBUTTON_TXT .. i, szTxt)
      Wnd_Show(self.UIGROUP, self.PLAYER_LISTBUTTON_KEY_STR .. i)
      Btn_Check(self.UIGROUP, self.PLAYER_LISTBUTTON_KEY_STR .. i, 0)
    else
      Wnd_Hide(self.UIGROUP, self.PLAYER_LISTBUTTON_KEY_STR .. i)
    end
  end
end

function uiLadder:GetFormatTxt(tbSpace, nRank, szName, szValue, szDiff)
  local szTxt = ""
  if tbSpace[1] and tbSpace[1] > 0 then
    for i = 1, tbSpace[1] do
      szTxt = szTxt .. " "
    end
  end
  local szRank = string.format("%d", nRank)
  local nRankLen = GetTextShowLen(szRank)
  szTxt = szTxt .. szRank
  if tbSpace[2] then
    for i = 1, tbSpace[2] - nRankLen do
      szTxt = szTxt .. " "
    end
  end
  local nNameSize = GetTextShowLen(szName)
  szTxt = szTxt .. " " .. szName
  if tbSpace[3] then
    for i = 1, tbSpace[3] - nNameSize do
      szTxt = szTxt .. " "
    end
  end
  --local szValue = string.format("%d", nValue);
  local nValueSize = GetTextShowLen(szValue)
  szTxt = szTxt .. "  " .. szValue
  if tbSpace[4] then
    for i = 1, tbSpace[4] - nValueSize do
      szTxt = szTxt .. " "
    end
  end
  if szDiff then
    szTxt = szTxt .. " " .. szDiff
  end
  return szTxt
end

-- 垂直居中对齐
function uiLadder:GetFormatTxtEx(tbCont)
  local szTxt = ""
  if not tbCont then
    return szTxt
  end
  for id = 1, #tbCont do
    local nStrLen = GetTextShowLen(tbCont[id][2])
    local nSize = tbCont[id][1]
    local nSpaceall = nSize - nStrLen
    if nSpaceall < 0 then
      nSpaceall = 0
    end
    local nSpace = nSpaceall / 2
    for i = 1, nSpace do
      szTxt = szTxt .. " "
    end
    szTxt = szTxt .. tbCont[id][2]
    for i = 1, nSpace do
      szTxt = szTxt .. " "
    end
  end
  return szTxt
end

-- 经典模式
function uiLadder:UpdatePlayerList_Mode_Detail(nCurPage, nCurGen, nCurSub)
  local szContext = ""
  if self.tbPlantList and self.tbPlantList[nCurPage] and self.tbPlantList[nCurPage][nCurGen] and self.tbPlantList[nCurPage][nCurGen][nCurSub] and self.tbPlantList[nCurPage][nCurGen][nCurSub].szShowName and string.len(self.tbPlantList[nCurPage][nCurGen][nCurSub].szShowName) > 0 and self.tbPlantList[nCurPage][nCurGen][nCurSub].nShowFlag > 0 then
    szContext = self.tbPlantList[nCurPage][nCurGen][nCurSub].szShowName
  end
  for i = 1, self.PLAYER_LISTMODE_MAX_NUMBER do
    Wnd_Hide(self.UIGROUP, self.PLAYER_LISTBUTTON_KEY_STR .. i)
  end
  Txt_SetTxt(self.UIGROUP, self.PLAYER_TXT_SUBTITLE_STR, szContext)
  if not self.tbPlayerLadder or not self.tbPlayerLadder.tbLadder or #self.tbPlayerLadder.tbLadder <= 0 then
    for i = 1, self.PLAYER_LIST_MAX_NUMBER do
      Wnd_Hide(self.UIGROUP, self.PLAYER_BUTTON_KEY_STR .. i)
    end
    Txt_SetTxt(self.UIGROUP, self.TXT_LIST_PAGE, "1/1")
    Wnd_SetEnable(self.UIGROUP, self.PAGE_BUTTON_LISTNEXT_STR, 0)
    Wnd_SetEnable(self.UIGROUP, self.PAGE_BUTTON_LISTPRE_STR, 0)
    self:RefreshPlayerPlant()
    return
  end
  local nType = self:GetType(0, nCurPage, nCurGen, nCurSub)
  local tbPlayerLadder = self.tbPlayerLadder
  if nType <= 0 or tbPlayerLadder.nLadderType ~= nType then
    for i = 1, self.PLAYER_LIST_MAX_NUMBER do
      Wnd_Hide(self.UIGROUP, self.PLAYER_BUTTON_KEY_STR .. i)
    end
    return
  end
  --	local nMaxPageNumber = #tbPlayerLadder.tbLadder / self.PLAYER_LIST_MAX_NUMBER;
  local nMaxPageNumber = 1

  if nMaxPageNumber > math.floor(nMaxPageNumber) then
    nMaxPageNumber = math.floor(nMaxPageNumber) + 1
  end

  if self.nCurPlayerListPage < 1 then
    self.nCurPlayerListPage = 1
  elseif self.nCurPlayerListPage > nMaxPageNumber then
    self.nCurPlayerListPage = nMaxPageNumber
  end

  if self.nCurPlayerListPage == 1 then
    Wnd_SetEnable(self.UIGROUP, self.PAGE_BUTTON_LISTPRE_STR, 0)
  end

  if self.nCurPlayerListPage == nMaxPageNumber then
    Wnd_SetEnable(self.UIGROUP, self.PAGE_BUTTON_LISTNEXT_STR, 0)
  end

  Txt_SetTxt(self.UIGROUP, self.TXT_LIST_PAGE, self.nCurPlayerListPage .. "/" .. nMaxPageNumber)
  if string.len(tbPlayerLadder.szContext) > 0 and tbPlayerLadder.szContext ~= "_ " then
    Txt_SetTxt(self.UIGROUP, self.PLAYER_TXT_SUBTITLE_STR, tbPlayerLadder.szContext)
  end

  local nPageIndex = 0
  for i = 1, self.PLAYER_LIST_MAX_NUMBER do
    local nPlayerIndex = nPageIndex + i
    local tbPlayer = tbPlayerLadder.tbLadder[nPlayerIndex]
    if tbPlayer then
      Txt_SetTxt(self.UIGROUP, self.PLAYER_INDEX_KEY_STR .. i, nPlayerIndex)
      local szSpr = self.tbPorList[tbPlayer.dwImgType][2]
      if szSpr then
        Img_SetImage(self.UIGROUP, self.PLAYER_PORTRAIT_KEY_STR .. i, 1, szSpr)
      end
      --local szLevel = self:CorrectPlayerLevel(tbPlayer.szTxt1);
      Txt_SetTxt(self.UIGROUP, self.PLAYER_NAME_KEY_STR .. i, tbPlayer.szName)
      Txt_SetTxt(self.UIGROUP, self.PLAYER_INFO_KEY_STR .. i, tbPlayer.szTxt1)
      Wnd_Show(self.UIGROUP, self.PLAYER_BUTTON_KEY_STR .. i)
      Btn_Check(self.UIGROUP, self.PLAYER_BUTTON_KEY_STR .. i, 0)
    else
      Wnd_Hide(self.UIGROUP, self.PLAYER_BUTTON_KEY_STR .. i)
    end
  end
  self:UpdatePlayer()
end

function uiLadder:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_LADDERREFRESH, self.OnRefresh },
    { UiNotify.emCOREEVENT_LADDERSEARCHREFRESH, self.OnSearchRefresh },
    { UiNotify.emCOREEVENT_LADDERPLANREFRESH, self.OnRefreshLadderPlan },
    --		{ UiNotify.emCOREEVENT_LADDERPLANTINITANDREFRESH,	self.OnInitLadderPlant		},
  }
  return tbRegEvent
end

-- 切换等级战斗力加成说明文字
function uiLadder:SwitchPowerReference()
  local nGen = self.nCurGenreIndex - 1
  if 1 == self.nCurGenreIndex then
    Wnd_Hide(self.UIGROUP, self.SP_POWERREFERENCE)
    Wnd_Show(self.UIGROUP, self.TXT_TIPFTP)
    Wnd_Hide(self.UIGROUP, self.TXT_LEVELPOWERINTRO)
  else
    Wnd_Hide(self.UIGROUP, self.TXT_TIPFTP)
    Wnd_Show(self.UIGROUP, self.SP_POWERREFERENCE)
    Lst_Clear(self.UIGROUP, self.LST_POWERREFERENCE)
    if self.nCurGenreIndex == 4 then
      Wnd_Show(self.UIGROUP, self.TXT_LEVELPOWERINTRO)
    else
      Wnd_Hide(self.UIGROUP, self.TXT_LEVELPOWERINTRO)
    end
    local tbReference = self.tbPowerReference[nGen]
    if tbReference then
      for i = 1, #tbReference do
        Lst_SetCell(self.UIGROUP, self.LST_POWERREFERENCE, i, 1, tbReference[i].level)
        Lst_SetCell(self.UIGROUP, self.LST_POWERREFERENCE, i, 2, tbReference[i].power)
      end
    end
  end
end

function uiLadder:UpdateFightPowerRank(nCurPage, nCurGen, nCurSub)
  self:UpdateComHeadFtpl(nCurGen)

  -- begin将排行榜各控件显示数字恢复到初始状态
  for i = 1, self.PLAYER_FPLIST_MAX_NUMBER do
    Wnd_Hide(self.UIGROUP, self.TXT_FIGHTPOWERRANK_KEY_STR .. i)
  end
  --Txt_SetTxt(self.UIGROUP, self.TXT_LIST_PAGE, "1/1");
  --Wnd_SetEnable(self.UIGROUP, self.PAGE_BUTTON_LISTPRE_STR, 0);
  --Wnd_SetEnable(self.UIGROUP, self.PAGE_BUTTON_LISTNEXT_STR, 0);
  --Txt_SetTxt(self.UIGROUP, self.PLAYER_TXT_SUBTITLE_STR, "");

  local nType = self:GetType(0, nCurPage, nCurGen, nCurSub)
  --local tbPlayerLadder = self.tbPlayerList;
  local tbCurLadder = {}
  if 3 == nCurGen then
    -- 真元排行榜
    tbCurLadder = self.tbPropList
    nType = nCurSub
  else
    tbCurLadder = self.tbPlayerList
  end

  -- 尚未取得排行榜玩家数据
  if not tbCurLadder or not tbCurLadder.tbLadder or #tbCurLadder.tbLadder <= 0 then
    for i = 1, self.PLAYER_FPLIST_MAX_NUMBER do
      Wnd_Hide(self.UIGROUP, self.TXT_FIGHTPOWERRANK_KEY_STR .. i)
    end

    Txt_SetTxt(self.UIGROUP, self.TXT_LIST_PAGE, "1/1")
    Wnd_SetEnable(self.UIGROUP, self.PAGE_BUTTON_LISTNEXT_STR, 0)
    Wnd_SetEnable(self.UIGROUP, self.PAGE_BUTTON_LISTPRE_STR, 0)
    return
  end
  if nType <= 0 or tbCurLadder.nLadderType ~= nType then
    for i = 1, self.PLAYER_LISTMODE_MAX_NUMBER do
      Wnd_Hide(self.UIGROUP, self.TXT_FIGHTPOWERRANK_KEY_STR .. i)
    end
    return
  end

  if 1 == self.nCurGenreIndex then
    if 1 == Player.tbFightPower:IsFightPowerValid() then
      Wnd_SetEnable(self.UIGROUP, self.BTN_MODECHANGE, 1)
    else
      Wnd_SetEnable(self.UIGROUP, self.BTN_MODECHANGE, 0)
    end
  end

  -- 总页数
  local nMaxPageNumber = tbCurLadder.nMaxLadder / self.PLAYER_FPLIST_MAX_NUMBER
  if nMaxPageNumber > math.floor(nMaxPageNumber) then
    nMaxPageNumber = math.floor(nMaxPageNumber) + 1
  end

  -- 调整页码及按钮
  if self.nCurPlayerListPage < 1 then
    self.nCurPlayerListPage = 1
  elseif self.nCurPlayerListPage > nMaxPageNumber then
    self.nCurPlayerListPage = nMaxPageNumber
  end
  if self.nCurPlayerListPage == 1 then
    Wnd_SetEnable(self.UIGROUP, self.PAGE_BUTTON_LISTPRE_STR, 0)
  else
    Wnd_SetEnable(self.UIGROUP, self.PAGE_BUTTON_LISTPRE_STR, 1)
  end
  if self.nCurPlayerListPage == nMaxPageNumber then
    Wnd_SetEnable(self.UIGROUP, self.PAGE_BUTTON_LISTNEXT_STR, 0)
  else
    Wnd_SetEnable(self.UIGROUP, self.PAGE_BUTTON_LISTNEXT_STR, 1)
  end
  Txt_SetTxt(self.UIGROUP, self.TXT_LIST_PAGE, (self.nCurPlayerListPage .. "/" .. nMaxPageNumber))

  if tbCurLadder.szContext and #tbCurLadder.szContext > 0 and tbCurLadder.szContext ~= "_ " then
    Txt_SetTxt(self.UIGROUP, self.PLAYER_TXT_SUBTITLE_STR, tbCurLadder.szContext)
  elseif not tbCurLadder or #tbCurLadder.tbLadder == 0 then
    Txt_SetTxt(self.UIGROUP, self.PLAYER_TXT_SUBTITLE_STR, "")
  end

  -- 填写玩家数据到控件
  for i = 1, self.PLAYER_FPLIST_MAX_NUMBER do
    local nPlayerIndex = i
    local tbPlayer = tbCurLadder.tbLadder[nPlayerIndex]
    if tbPlayer then
      local tbSpace = { 5, 9, 17, 12 }
      local dwValue = tbPlayer.dwValue
      local szValue = tostring(dwValue)
      if 4 == nCurGen then -- 等级
        dwValue = self:CorrectPlayerLevel(dwValue)
        szValue = string.format("%g", dwValue)
      elseif 1 == nCurGen then -- 总战斗力
        dwValue = dwValue / 100
        szValue = (((dwValue == math.floor(dwValue)) and tostring(dwValue)) or string.format("%g", dwValue))
      end
      local szDiff = self:GetDiff(dwValue)
      local nRank = nPlayerIndex + (self.nCurPlayerListPage - 1) * self.PLAYER_FPLIST_MAX_NUMBER
      local szTxt = self:GetFormatTxt(tbSpace, nRank, tbPlayer.szPlayerName, szValue, szDiff)
      --local tbCont	= {{8, nRank}, {30,tbPlayer.szPlayerName}, {25,szValue}, {20,szDiff}};
      --local szTxt		= self:GetFormatTxtEx(tbCont);
      if self.tbSearchResult then
        --if (KLib.FindStr(self.tbSearchResult.szName, tbPlayer.szPlayerName)) then
        if self.tbSearchResult.szName == tbPlayer.szPlayerName then
          szTxt = "<color=yellow>" .. szTxt .. "<color>"
        end
      end
      Txt_SetTxt(self.UIGROUP, self.TXT_FIGHTPOWERRANK_KEY_STR .. i, szTxt)
      Wnd_Show(self.UIGROUP, self.TXT_FIGHTPOWERRANK_KEY_STR .. i)
    else
      Wnd_Hide(self.UIGROUP, self.TXT_FIGHTPOWERRANK_KEY_STR .. i)
    end
  end

  -- 真元排行榜，不能查询名次
  if 3 == nCurGen then
    Wnd_SetEnable(self.UIGROUP, self.BTN_SEARCHMINE, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_SEARCHOTHER, 0)
  else
    Wnd_SetEnable(self.UIGROUP, self.BTN_SEARCHMINE, 1)
    Wnd_SetEnable(self.UIGROUP, self.BTN_SEARCHOTHER, 1)
  end
end

function uiLadder:GetDiff(nValue)
  local szTxt = ""
  if 1 == self.nCurGenreIndex then -- 总战斗力
    local nMyFightPower = Player.tbFightPower:GetFightPower(me)
    nMyFightPower = math.floor(nMyFightPower * 100) / 100
    local nDiff = math.floor((nValue - nMyFightPower) * 100) / 100
    szTxt = string.format("%g", nDiff)
  elseif 2 == self.nCurGenreIndex then -- 成就
    local nMyArchiev = Achievement:GetAchievementPoint(me)
    local nDiff = nValue - nMyArchiev
    szTxt = string.format("%d", nDiff)
  elseif 3 == self.nCurGenreIndex then -- 真元
    szTxt = "--"
  elseif 4 == self.nCurGenreIndex then -- 等级
    local nExp = me.GetExp()
    local nUpLevelExp = me.GetUpLevelExp()
    local nExpPercent = 0
    if nUpLevelExp > 0 then
      nExpPercent = math.floor(nExp / nUpLevelExp * 100) / 100
    end
    local nMyLevel = me.nLevel + nExpPercent
    local nDiff = nValue - nMyLevel
    szTxt = string.format("%g", nDiff)
  end
  return szTxt
end

-- 设置切换列表模式按钮上的文字
function uiLadder:SetModeBtnTxt()
  local szTxt = ""
  if self.tbPlayerPlantMode.nModeClassic == self.nCurListMode then
    szTxt = "列表模式"
  elseif self.tbPlayerPlantMode.nModeList == self.nCurListMode then
    szTxt = "经典模式"
  elseif self.tbPlayerPlantMode.nModeListFtp == self.nCurListMode then -- 切换到战斗力排行榜
    if 1 == self.nCurGenreIndex then -- 总战斗力
      szTxt = "我的详情"
    elseif 2 == self.nCurGenreIndex then -- 成就
      szTxt = "我的成就"
    elseif 3 == self.nCurGenreIndex then -- 真元
      szTxt = "提升真元"
    elseif 4 == self.nCurGenreIndex then -- 等级
      szTxt = "我要升级"
    end
  end
  Btn_SetTxt(self.UIGROUP, self.BTN_MODECHANGE, szTxt)
end

-- 初始化等级加权参照表
function uiLadder:LoadPowerRefTable()
  local tbFile = Lib:LoadTabFile("\\setting\\fightpower\\powertab.txt")
  if not tbFile then
    print("[uiLadder]Failed to load file powertab.txt")
  else
    local tbInfo = {}
    local nId = 0
    local nLastType = 0
    for _, tbRow in ipairs(tbFile) do
      local nType = tonumber(tbRow.typeid)
      local szLevel = tostring(tbRow.level)
      local szPower = tostring(tbRow.power)

      if nLastType ~= nType then
        nLastType = nType
        nId = 0
      end
      nId = nId + 1

      if not tbInfo[nType] then
        tbInfo[nType] = {}
      end
      if not tbInfo[nType][nId] then
        tbInfo[nType][nId] = {}
      end
      tbInfo[nType][nId].level = szLevel
      tbInfo[nType][nId].power = szPower
    end

    self.tbPowerReference = tbInfo
  end

  -- 防止文件错误
  if not self.tbPowerReference then
    self.tbPowerReference = {}
  end
end

function uiLadder:CorrectPlayerLevel(szLevel)
  if tonumber(szLevel) then
    return tonumber(szLevel) / 100
  end
  local nStart, nEnd, nLevel = string.find(szLevel, "(.*)级")
  if not nStart then
    return szLevel
  else
    return tonumber(nLevel) / 100
  end
end

function uiLadder:UpdateComHeadFtpl(nGen)
  local szCHeadName = self.tbChead[nGen].szName
  local szCHeadValue = self.tbChead[nGen].szValue
  Txt_SetTxt(self.UIGROUP, self.Txt_CHEAD_PLAYERNAME, szCHeadName)
  Txt_SetTxt(self.UIGROUP, self.Txt_CHEAD_VALUE, szCHeadValue)
end

function uiLadder:GetPropLadder(nType, nPage)
  local tbLadder = Ladder:GetPropLadderByType(nType, nPage)
  return tbLadder
end

function uiLadder:GetPageBtnName(nHugeId)
  local nShowId = nHugeId
  if self.tbReadHugeId2ShowId then
    nShowId = self.tbReadHugeId2ShowId[nHugeId]
  end
  if nShowId then
    return self.PAGE_BUTTON_KEY_STR .. nShowId
  else
    return ""
  end
end
