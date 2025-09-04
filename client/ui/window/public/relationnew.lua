-----------------------------------------------------
--文件名		：	friend.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-04-19
--功能描述		：	人际关系脚本。
------------------------------------------------------

local tbSaveData = Ui.tbLogic.tbSaveData
local tbTimer = Ui.tbLogic.tbTimer
local tbViewPlayerMgr = Ui.tbLogic.tbViewPlayerMgr
local uiRelation = Ui:GetClass("relationnew")

uiRelation.CLOSE_BUTTON = "BtnClose"
uiRelation.BUTTON_TEACHER = "BtnMaster"
uiRelation.BUTTON_ADDFRIEND = "BtnAddFriend"
uiRelation.OUTLOOK_MEMBERSHOWLIST = "OutLookMemberShowList"
uiRelation.BTN_CHANGE_STATE = "BtnOnlineState"
uiRelation.IMG_CHANGE_STATE = "ImgOnlineState"
uiRelation.BTN_MICROBLOG = "BtnMicroblog"
uiRelation.BTN_SHOW_ONLINE_PLAYER = "BtnShowOnlineFriend"
uiRelation.PAGE_SET_MAIN = "PageSetMain"
uiRelation.PAGE_ALLPLAYER = "PageAllFriends"
uiRelation.PAGE_LASTPLAYER = "PageLastPlayer"
uiRelation.BTN_PAGE_LAST_PLAYER = "BtnShowLastLinkman"
uiRelation.BTN_SEL_PORTRAIT = "BtnSelPortrait"
uiRelation.IMG_PLAYER_PORTRAIT = "ImgPortrait"
uiRelation.TXT_PLAYERNAME = "TxtPlayerName"
uiRelation.SCR_RELATION_LST = "RelationListScrollPanel"

uiRelation.Edt_SearchFriend = "EdtSearchFriend"
uiRelation.List_SearchName = "ListSearchName"
uiRelation.Scr_NameLookup = "ScorllNameLookUp"
uiRelation.BTN_SEARCHNAME = "BtnSearchName"
uiRelation.BTN_ADDGROUP = "BtnAddGroup"

uiRelation.BTN_INIVITEPLAYER = "Btn_InivitePlayer"
uiRelation.szUrl_InivitePlayer = "http://zt.xoyo.com/jxsj/callback/index.php?k="
uiRelation.tbIniviteTime = { 20121011, 20121021 }

uiRelation.BTN_YY = "Btn_YY"
uiRelation.szUrl_YY = "http://yy.com/#5050/"

uiRelation.DATA_KEY = "Relationnew"

uiRelation.POPUPMUNE_CALLBACK = {}
uiRelation.POPUPMUNE_CALLBACK_EX = {} -- 给自定义好友的

uiRelation.nSnsTimerId = 0
uiRelation.SNS_TIME = 18 * 10

uiRelation.nCurPage = 1

uiRelation.PAGE_INDEX_FRIENDS = 1
uiRelation.PAGE_INDEX_MYGROUP1 = 2
uiRelation.PAGE_INDEX_TRAIN = 3
uiRelation.PAGE_INDEX_GLOBAL = 4
uiRelation.PAGE_INDEX_ENEMY = 5
uiRelation.PAGE_INDEX_BLACKLIST = 6

uiRelation.PER_LINE_HEIGHT = 14 -- 每行间隔14

uiRelation.FLAG_MAIN_GROUP_OUTLOOK = 65535

uiRelation.szDefaultPlayerName = "搜索好友"

uiRelation.PLAYER_STATE_ONLINE = 1
uiRelation.PLAYER_STATE_INVISIBLE = 2
uiRelation.PLAYER_STATE_OFFLINEONLINE = 3

uiRelation.IMG_ONLINE = "\\image\\ui\\002a\\relation\\img_onlinestate.spr"
uiRelation.IMG_STEALTH = "\\image\\ui\\002a\\relation\\img_stealthstate.spr"
uiRelation.IMG_OFFLINE = "\\image\\ui\\002a\\relation\\img_afkstate.spr"
uiRelation.IMG_SNS_RELATION = "\\image\\ui\\001a\\sns\\btn_sns_relation.spr"

uiRelation.tbImgPlayer = {
  [Env.SEX_MALE] = "\\image\\ui\\002a\\relation\\img_man.spr",
  [Env.SEX_FEMALE] = "\\image\\ui\\002a\\relation\\img_female.spr",
}

uiRelation.tbDefaultMyImg = {
  [1] = "\\image\\ui\\002a\\playerpanel\\protrait_myportrait_tenc.spr",
  [2] = "\\image\\ui\\002a\\playerpanel\\protrait_myportrait_sina.spr",
}

uiRelation.IMG_AFK = "\\image\\ui\\002a\\relation\\img_afk.spr"

uiRelation.MENU_INDEX_MILIAO = 1
uiRelation.MENU_INDEX_MAIL = 2
uiRelation.MENU_INDEX_TEAM = 3
uiRelation.MENU_INDEX_DEL = 4
uiRelation.MENU_INDEX_APPLYTEACHER = 5
uiRelation.MENU_INDEX_APPLYSTDUDENT = 6
uiRelation.MENU_INDEX_CREATE_MYGROUP = 7
uiRelation.MENU_INDEX_COPY_MYGROUP1 = 8
uiRelation.MENU_INDEX_RENAME = 9
uiRelation.MENU_INDEX_DELGROUP = 10

uiRelation.MENU_INDEX_MAX = 11

uiRelation.MENU_ITEM = {
  [uiRelation.MENU_INDEX_MILIAO] = " 密聊 ",
  [uiRelation.MENU_INDEX_MAIL] = " 信件 ",
  [uiRelation.MENU_INDEX_TEAM] = " 组队 ",
  [uiRelation.MENU_INDEX_DEL] = " 删除 ",
  [uiRelation.MENU_INDEX_APPLYTEACHER] = " 申请拜师  ",
  [uiRelation.MENU_INDEX_APPLYSTDUDENT] = " 申请收徒 ",
  [uiRelation.MENU_INDEX_CREATE_MYGROUP] = " 增加自定义分组 ",
  [uiRelation.MENU_INDEX_COPY_MYGROUP1] = " 复制到自定义1 ",
  [uiRelation.MENU_INDEX_RENAME] = " 重命名 ",
  [uiRelation.MENU_INDEX_DELGROUP] = " 删除此分组 ",
}

uiRelation.tbPageManager = {
  [uiRelation.PAGE_INDEX_FRIENDS] = {
    szGroupName = "好友",
    nUnFold = 0,
    nIsShow = 1,
    nOutLookGroupId = 0,
  },
  [uiRelation.PAGE_INDEX_MYGROUP1] = {
    szGroupName = "自定义分组1",
    nIsShow = 0,
    nGroupId = 1,
    nUnFold = 0,
    nMenuIndex = uiRelation.MENU_INDEX_COPY_MYGROUP1,
    nOutLookGroupId = 0,
  },
  [uiRelation.PAGE_INDEX_TRAIN] = {
    szGroupName = "师徒",
    nUnFold = 0,
    nIsShow = 1,
    nOutLookGroupId = 0,
  },
  [uiRelation.PAGE_INDEX_GLOBAL] = {
    szGroupName = "大区好友",
    nUnFold = 0,
    nIsShow = 1,
    nOutLookGroupId = 0,
  },
  [uiRelation.PAGE_INDEX_ENEMY] = {
    szGroupName = "仇人",
    nUnFold = 0,
    nIsShow = 1,
    nOutLookGroupId = 0,
  },
  [uiRelation.PAGE_INDEX_BLACKLIST] = {
    szGroupName = "黑名单",
    nUnFold = 0,
    nIsShow = 1,
    nOutLookGroupId = 0,
  },
}

uiRelation.tbPage2MyGroupId = {
  [uiRelation.PAGE_INDEX_MYGROUP1] = 1,
}

uiRelation.tbGroupIndex2PageIndex = {}
uiRelation.tbRelationGroup = {}
uiRelation.tbOutLookStruct = {}

function uiRelation:Init()
  self.nCurPage = 1
  self.tbSortList = {}
  self.tbRelationList = {}
  self.tbRelationTypes = {}
  self.tbRelationSetting = {}
  self.tbSearchList = {}
  self.tbSearchNameCandidate = {}
  self.nIsShowOnlinePlayer = 0
  self.nSearchSelIndex = 0
  self.szOldNameKeyword = ""
  self.nKefuFriend = 0
  tbSaveData:RegistLoadCallback(self.LoadConfig, self)
end

---------------------------------------------------------
--写log
function uiRelation:WriteStatLog()
  Log:Ui_SendLog("F5人际界面", 1)
end

function uiRelation:GetRelationScrLstTop()
  return ScrPanel_GetDocumentTopLen(self.UIGROUP, self.SCR_RELATION_LST)
end

function uiRelation:SetRelationScrLstTop(nNewTop)
  ScrPanel_SetWndDocumentAbsoluteTop(self.UIGROUP, self.SCR_RELATION_LST, nNewTop)
end

function uiRelation:OnOpen()
  self.nDefaultTop = self:GetRelationScrLstTop()
  self.nCurScrollTop = 0
  Txt_SetTxt(self.UIGROUP, self.TXT_PLAYERNAME, me.szName)
  self:WriteStatLog()
  Ui(Ui.UI_SIDEBAR):WndOpenCloseCallback(self.UIGROUP, 1)
  self:LoadConfig()
  Btn_Check(self.UIGROUP, self.BTN_SHOW_ONLINE_PLAYER, self.nIsShowOnlinePlayer)
  PgSet_ActivePage(self.UIGROUP, self.PAGE_SET_MAIN, self.PAGE_ALLPLAYER)
  Wnd_SetEnable(self.UIGROUP, self.BTN_PAGE_LAST_PLAYER, 0)
  me.RequestTrainingOption()
  Edt_SetTxt(self.UIGROUP, self.Edt_SearchFriend, self.szDefaultPlayerName)
  local nPlayerState = GetInvisibleLogin()
  if nPlayerState == 1 then
    self:SetPlayerState(self.PLAYER_STATE_INVISIBLE)
  else
    self:SetPlayerState(self.PLAYER_STATE_ONLINE)
  end

  self:UpdateRelationPanel(1)

  local nNowDate = tonumber(GetLocalDate("%Y%m%d"))
  if nNowDate >= self.tbIniviteTime[1] and nNowDate <= self.tbIniviteTime[2] then
    Wnd_Show(self.UIGROUP, self.BTN_INIVITEPLAYER)
  else
    Wnd_Hide(self.UIGROUP, self.BTN_INIVITEPLAYER)
  end
end

function uiRelation:LoadConfig()
  self.tbRelationSetting = tbSaveData:Load(self.DATA_KEY) or {}
  if not self.tbRelationSetting.nIsShowOnlinePlayer then
    self.tbRelationSetting.nIsShowOnlinePlayer = 0
  end
  self.nIsShowOnlinePlayer = self.tbRelationSetting.nIsShowOnlinePlayer
end

function uiRelation:OnClose()
  tbSaveData:Save(self.DATA_KEY, self.tbRelationSetting or {})
  Ui(Ui.UI_SIDEBAR):WndOpenCloseCallback(self.UIGROUP, 0)

  if UiVersion == Ui.Version002 then
    UiManager:CloseWindow(Ui.UI_CHOOSEPORTRAIT)
  else
    OnSelPortrait(0) -- 参数 1 打开头像选择界面, 0 为关闭选择界面
  end
end

function uiRelation:OnTimer_ProcessSns()
  Sns:DownloadPlayerImg()
  return
end

function uiRelation:OnEnterGame()
  self:ResetRelationGroup()
  self:ClearOutLookGroupIdInTable()
  if Sns.bIsOpen == 1 then
    self.nSnsTimerId = tbTimer:Register(self.SNS_TIME, self.OnTimer_ProcessSns, self)
  end
end

function uiRelation:OnLeaveGame()
  if self.nSnsTimerId > 0 then
    tbTimer:Close(self.nSnsTimerId)
  end
end

function uiRelation:OnButtonClick(szWnd, nParam)
  if szWnd == self.CLOSE_BUTTON then
    UiManager:CloseWindow(self.UIGROUP)
    UiManager:CloseWindow(Ui.UI_RELATIONADDFRIEND)
    if UiVersion == Ui.Version002 then
      UiManager:CloseWindow(Ui.UI_CHOOSEPORTRAIT)
    else
      OnSelPortrait(0) -- 参数 1 打开头像选择界面, 0 为关闭选择界面
    end
  --	elseif szWnd == self.BUTTON_HIDE then
  --		SetInvisibleLogin(Btn_GetCheck(self.UIGROUP, self.BUTTON_HIDE));
  --		Btn_Check(self.UIGROUP, self.BUTTON_HIDE, GetInvisibleLogin());
  elseif szWnd == self.BTN_SEARCHNAME then
    self:OnFriendSearch()
  elseif szWnd == self.BUTTON_TEACHER then
    local bFlag = Btn_GetCheck(self.UIGROUP, self.BUTTON_TEACHER)
    if bFlag == 1 then
      UiManager:OpenWindow(Ui.UI_TEACHER)
    else
      UiManager:CloseWindow(Ui.UI_TEACHER)
    end
  elseif szWnd == self.BUTTON_ADDFRIEND then
    UiManager:OpenWindow(Ui.UI_RELATIONADDFRIEND)
  elseif szWnd == self.BTN_CHANGE_STATE then
    self:OpenStateList(szWnd, nParam)
  elseif szWnd == self.BTN_MICROBLOG then
    Ui(Ui.UI_SNS_ENTRANCE):OpenSNSmain()
  elseif szWnd == self.BTN_SHOW_ONLINE_PLAYER then
    self.nIsShowOnlinePlayer = nParam
    self:SetShowOnlinePlayerState(nParam)
    self:UpdateRelationPanel()
  elseif szWnd == self.BTN_SEL_PORTRAIT then -- 打开头像选择界面
    if UiVersion == Ui.Version002 then
      UiManager:OpenWindow(Ui.UI_CHOOSEPORTRAIT)
    else
      OnSelPortrait() -- 参数 1 打开头像选择界面, 0 为关闭选择界面
    end
  elseif szWnd == self.BTN_ADDGROUP then
    local nHaveGroup = self:GetMyGroupCount()
    if nHaveGroup < Relation.DEF_MAX_RELATIONGROUP_COUNT then
      self:CmdCreateNewGroup()
    end
  elseif szWnd == self.BTN_INIVITEPLAYER then
    local szBase64 = TOOLS_EncryptBase64(me.szAccount .. "&" .. GetGatewayName() .. "&" .. me.szName)
    local szEncode = UrlEncode(szBase64)
    OpenWebSite(self.szUrl_InivitePlayer .. szEncode)
  elseif szWnd == self.BTN_YY then
    OpenWebSite(self.szUrl_YY)
  end
end

function uiRelation:GetSearchPlayerList()
  local tbSearchList = {}
  local nPage = self.PAGE_INDEX_FRIENDS
  local tbPage = self.tbPageManager[nPage]
  if not tbPage or not tbPage.tbRelationList then
    return tbSearchList
  end
  for szName, tbInfo in pairs(tbPage.tbRelationList) do
    tbSearchList[#tbSearchList + 1] = { nPage, tbInfo.nOnline, tbInfo.szPlayer }
  end
  return tbSearchList
end

function uiRelation:OnEditChange(szWndName)
  if szWndName == self.Edt_SearchFriend then
    local szFriendName = Edt_GetTxt(self.UIGROUP, self.Edt_SearchFriend)
    if szFriendName and (szFriendName ~= "") then
      if self.szOldNameKeyword ~= szFriendName then
        self.szOldNameKeyword = szFriendName
        self.tbSearchNameCandidate = {}
        local nCount = 0
        self.nSearchSelIndex = 0
        local bFiterColor = 1
        MessageList_Clear(self.UIGROUP, self.List_SearchName)
        for nIndex, tbName in pairs(self.tbSearchList) do
          if MatchStringSuggestion(szFriendName, tbName[3]) == 1 then
            table.insert(self.tbSearchNameCandidate, tbName)
            MessageList_AddNewLine(self.UIGROUP, self.List_SearchName)
            MessageList_PushString(self.UIGROUP, self.List_SearchName, 0, tbName[3], "", "", bFiterColor)
            MessageList_PushOver(self.UIGROUP, self.List_SearchName)
            nCount = nCount + 1
          end
        end
        if #self.tbSearchNameCandidate > 0 then
          self.nSearchSelIndex = 1
          MessageList_SetSelectedIndex(self.UIGROUP, self.List_SearchName, self.nSearchSelIndex)
          Wnd_SetVisible(self.UIGROUP, self.Scr_NameLookup, 1)
        else
          Wnd_SetVisible(self.UIGROUP, self.Scr_NameLookup, 0)
        end
      end
    else
      Wnd_SetVisible(self.UIGROUP, self.Scr_NameLookup, 0)
      self.szOldNameKeyword = ""
      self.tbSearchNameCandidate = {}
    end
  end
end

function uiRelation:OnEditEnter(szWndName)
  if szWndName == self.Edt_SearchFriend then
    self:OnFriendSearch()
  end
end

function uiRelation:OnMouseEnter(szWndName)
  if szWndName == self.List_SearchName then
    local nIndex = MessageList_GetSelectedIndex(self.UIGROUP, self.List_SearchName)
    if nIndex then
      self.nSearchSelIndex = nIndex
    end
  end
end

function uiRelation:OnMsgListLineClick(szWndName)
  if szWndName == self.List_SearchName then
    local text = self.tbSearchNameCandidate[self.nSearchSelIndex][3]
    Edt_SetTxt(self.UIGROUP, self.Edt_SearchFriend, text)
    self.szOldNameKeyword = text
    Wnd_SetVisible(self.UIGROUP, self.Scr_NameLookup, 0)
    Edt_MoveHome(self.UIGROUP, self.Edt_SearchFriend)
  end
end

function uiRelation:OnSpecialKeyDown(szWndName, nParam)
  if szWndName == self.Edt_SearchFriend then
    if (nParam == Ui.MSG_VK_UP) or (nParam == Ui.MSG_VK_DOWN) then
      if (nParam == Ui.MSG_VK_UP) and (self.nSearchSelIndex > 1) then
        self.nSearchSelIndex = self.nSearchSelIndex - 1
      elseif (nParam == Ui.MSG_VK_DOWN) and (self.nSearchSelIndex < #self.tbSearchNameCandidate) then
        self.nSearchSelIndex = self.nSearchSelIndex + 1
      end
      MessageList_SetSelectedIndex(self.UIGROUP, self.List_SearchName, self.nSearchSelIndex)
    end
  end
end

function uiRelation:OnEditFocus(szWndName)
  if szWndName == self.Edt_SearchFriend then
    local szMap = Edt_GetTxt(self.UIGROUP, self.Edt_SearchFriend)
    if szMap == self.szDefaultPlayerName then
      Edt_SetTxt(self.UIGROUP, self.Edt_SearchFriend, "")
      self.tbSearchNameCandidate = {}
      self.nSearchSelIndex = 0
      self.szOldNameKeyword = ""
    end
  end
end

function uiRelation:OnFriendSearch()
  local szSearchName = ""
  local tbSearchList = {}
  local tbSearchIdCandidate = {}
  local nSelIndex = 0
  szSearchName = Edt_GetTxt(self.UIGROUP, self.Edt_SearchFriend)
  tbSearchList = self.tbSearchList
  tbSearchIdCandidate = self.tbSearchNameCandidate
  nSelIndex = self.nSearchSelIndex

  if szSearchName and (szSearchName ~= "") and (szSearchName ~= self.szDefaultPlayerName) then
    if (nSelIndex > 0) and (nSelIndex <= #tbSearchIdCandidate) and tbSearchIdCandidate then
      local tbInfo = tbSearchIdCandidate[nSelIndex]
      self:LocateName(tbInfo)
    else
      UiManager:OpenWindow(Ui.UI_INFOBOARD, "未查找到符合命名的好友")
      return 0, 0
    end
  else
    UiManager:OpenWindow(Ui.UI_INFOBOARD, "请输入玩家名")
    return 0, 0
  end
end

function uiRelation:FindPlayerIndex(nPage, szName, nOnline)
  local tbPage = self.tbPageManager[nPage]
  local tbSortList = tbPage.tbSortList
  for i, tbInfo in pairs(tbSortList) do
    if szName == tbInfo.szPlayer then
      return i
    end
  end
  return 0
end

function uiRelation:LocateName(tbInfo)
  if not tbInfo then
    return
  end

  local nBaseDet = 20
  local nPage = tbInfo[1]
  local nNewLen = 0
  local nIndex = self:FindPlayerIndex(nPage, tbInfo[3], tbInfo[2])
  for i = 1, nPage do
    if i > 1 then
      nNewLen = nNewLen + nBaseDet
    end
    local tbPage = self.tbPageManager[nPage]
    if i == nPage then
      self.tbPageManager[nPage].nUnFold = 1
      nNewLen = nNewLen + nIndex * nBaseDet
      self:SetCollapseState(nPage)
      OutLookPanelSelItem(self.UIGROUP, self.OUTLOOK_MEMBERSHOWLIST, self.tbPageManager[nPage].nOutLookGroupId - 1, nIndex - 1)
    else
      if tbPage.nUnFold == 1 then
        if tbPage.tbSortList then
          nNewLen = nNewLen + #tbPage.tbSortList
        end
      end
    end
  end
  Wnd_SetVisible(self.UIGROUP, self.Scr_NameLookup, 0)
  self:SetRelationScrLstTop(nNewLen)
end

function uiRelation:AddFriendByName(szName)
  if IsValidRoleName(szName) == 0 then
    me.Msg("输入的名字不符合规范。")
  elseif self.nCurPage == self.PAGE_INDEX_FRIENDS then
    AddFriendByName(szName)
  elseif self.nCurPage == self.PAGE_INDEX_GLOBAL then
    Player.tbGlobalFriends:ApplyAddFriend(me.szName, szName)
  end
end

function uiRelation:SetShowOnlinePlayerState(nState)
  self.tbRelationSetting.nIsShowOnlinePlayer = nState
  Btn_Check(self.UIGROUP, self.BTN_SHOW_ONLINE_PLAYER, nState)
end

function uiRelation:OpenStateList(szWnd, nParam)
  DisplayPopupMenu(self.UIGROUP, szWnd, 2, nParam, "在线", 1, "隐身", 2)
end

function uiRelation:OnMouseEnter(szWnd, nParam)
  if szWnd == self.OUTLOOK_MEMBERSHOWLIST then
    self:ShowTips(szWnd, nParam)
  end
end

uiRelation.tbVersion002 = {
  [Env.SEX_MALE] = {
    [0] = "\\image\\ui\\002a\\playerpanel\\protrait_men_01.spr",
    [1] = "\\image\\ui\\002a\\playerpanel\\protrait_men_01.spr",
    [2] = "\\image\\ui\\002a\\playerpanel\\protrait_men_02.spr",
    [3] = "\\image\\ui\\002a\\playerpanel\\protrait_men_03.spr",
    [4] = "\\image\\ui\\002a\\playerpanel\\protrait_men_04.spr",
    [5] = "\\image\\ui\\002a\\playerpanel\\protrait_men_05.spr",
    [6] = "\\image\\ui\\002a\\playerpanel\\protrait_men_06.spr",
    [7] = "\\image\\ui\\002a\\playerpanel\\protrait_men_07.spr",
    [8] = "\\image\\ui\\002a\\playerpanel\\protrait_men_08.spr",
    [9] = "\\image\\ui\\002a\\playerpanel\\protrait_men_09.spr",
  },
  [Env.SEX_FEMALE] = {
    [0] = "\\image\\ui\\002a\\playerpanel\\protrait_woman_01.spr",
    [1] = "\\image\\ui\\002a\\playerpanel\\protrait_woman_01.spr",
    [2] = "\\image\\ui\\002a\\playerpanel\\protrait_woman_02.spr",
    [3] = "\\image\\ui\\002a\\playerpanel\\protrait_woman_03.spr",
    [4] = "\\image\\ui\\002a\\playerpanel\\protrait_woman_04.spr",
    [5] = "\\image\\ui\\002a\\playerpanel\\protrait_woman_05.spr",
    [6] = "\\image\\ui\\002a\\playerpanel\\protrait_woman_06.spr",
    [7] = "\\image\\ui\\002a\\playerpanel\\protrait_woman_07.spr",
    [8] = "\\image\\ui\\002a\\playerpanel\\protrait_woman_08.spr",
  },
}

function uiRelation:UpdateBasicPortrait()
  local szSpr, nType = tbViewPlayerMgr:GetMyPortraitSpr(me.nPortrait, me.nSex)

  if UiVersion == Ui.Version001 then
    if nType == 1 then
      if me.nPortrait <= 100 then
        szSpr = self.tbVersion002[me.nSex][me.nPortrait]
      else
        szSpr = self.tbDefaultMyImg[me.nPortrait - 100]
      end
    end
  end

  Img_SetImage(self.UIGROUP, self.BTN_SEL_PORTRAIT, nType, szSpr)

  if 1 == nType then
    if me.nPortrait > 100 then
      Img_SetImgOffsetX(self.UIGROUP, self.BTN_SEL_PORTRAIT, 0)
    else
      Img_SetImgOffsetX(self.UIGROUP, self.BTN_SEL_PORTRAIT, -9)
    end
  else
    Img_SetImgOffsetX(self.UIGROUP, self.BTN_SEL_PORTRAIT, 0)
  end
end

function uiRelation:ShowFriendTip(szWnd, nGroupIndex, nItemIndex)
  local tbRelationList, tbInfoList = me.Relation_GetRelationList()
  if not tbInfoList then
    return
  end

  local nPage = self.tbGroupIndex2PageIndex[nGroupIndex + 1]
  local szPlayer = self.tbOutLookStruct[nGroupIndex + 1][nItemIndex + 1]

  if szPlayer == nil then
    return
  end

  local tbOnePageGroup = self.tbPageManager[nPage]

  if not tbOnePageGroup then
    return
  end

  local tbRelationList = tbOnePageGroup.tbRelationList

  if not tbRelationList then
    return
  end

  local tbInfo = tbInfoList[szPlayer]
  if not tbInfo then
    return
  end

  local nLevel = math.ceil(math.sqrt(tbInfo.nFavor / 100))
  local nFavorExpConf = me.GetFavorExpConf(tbInfo.nFavor) / 100
  local nNextLevelFavor = nLevel * nLevel * 100 + 1
  local szName = "名字：<color=yellow>" .. szPlayer .. "<color>\n"
  local szTip = "\n"
  local tbRelation = tbRelationList[szPlayer]
  if nPage == self.PAGE_INDEX_FRIENDS or nPage == self.PAGE_INDEX_MYGROUP1 then
    if Player.emKPLAYERRELATION_TYPE_BIDFRIEND == tbRelation.nType or Player.emKPLAYERRELATION_TYPE_TMPFRIEND == tbRelation.nType then
      szTip = szTip .. "门派：<color=yellow>" .. Player:GetFactionRouteName(tbInfo.nFaction) .. "<color>\n"
      szTip = szTip .. "等级：<color=yellow>" .. tbInfo.nLevel .. "级<color>\n"
      szTip = szTip .. "亲密度等级：<color=yellow>" .. nLevel .. "级（" .. tbInfo.nFavor .. "/" .. nNextLevelFavor .. "）<color>\n"
      szTip = szTip .. "组队时好友打怪分得经验加成：<color=yellow>" .. nFavorExpConf .. "倍<color>\n"
      if tbRelation.nGBOnline == 1 and tbRelation.nOnline == 0 then
        szTip = szTip .. "<color=125,111,172>此好友正在跨服中<color>\n"
      end
    elseif Player.emKPLAYERRELATION_TYPE_COUPLE == tbRelation.nType then
      local nExpRate = nFavorExpConf
      local nCoupleExpRate = me.GetTask(2114, 16)
      if nCoupleExpRate > 0 then
        nExpRate = nCoupleExpRate * nExpRate / 100
      end

      szTip = szTip .. "关系：<color=yellow>侠侣<color>\n"
      szTip = szTip .. "门派：<color=yellow>" .. Player:GetFactionRouteName(tbInfo.nFaction) .. "<color>\n"
      szTip = szTip .. "等级：<color=yellow>" .. tbInfo.nLevel .. "级<color>\n"
      szTip = szTip .. "亲密度等级：<color=yellow>" .. nLevel .. "级（" .. tbInfo.nFavor .. "/" .. nNextLevelFavor .. "）<color>\n"
      szTip = szTip .. "组队时好友打怪分得经验加成：<color=yellow>" .. nExpRate .. "倍<color>\n"
      if tbRelation.nGBOnline == 1 and tbRelation.nOnline == 0 then
        szTip = szTip .. "<color=125,111,172>此好友正在跨服中<color>\n"
      end
    elseif Player.emKPLAYERRELATION_TYPE_BUDDY == tbRelation.nType then
      local szRelation = "指定密友"
      szTip = szTip .. "关系：<color=yellow>" .. szRelation .. "<color>\n"
      szTip = szTip .. "门派：<color=yellow>" .. Player:GetFactionRouteName(tbInfo.nFaction) .. "<color>\n"
      szTip = szTip .. "等级：<color=yellow>" .. tbInfo.nLevel .. "级<color>\n"
      szTip = szTip .. "亲密度等级：<color=yellow>" .. nLevel .. "级（" .. tbInfo.nFavor .. "/" .. nNextLevelFavor .. "）<color>\n"
      szTip = szTip .. "组队时好友打怪分得经验加成：<color=yellow>" .. nFavorExpConf .. "倍<color>\n"
      if tbRelation.nGBOnline == 1 and tbRelation.nOnline == 0 then
        szTip = szTip .. "<color=125,111,172>此好友正在跨服中<color>\n"
      end
    elseif tbRelation.nType == Player.emKPLAYERRELATION_TYPE_TRAINED or tbRelation.nType == Player.emKPLAYERRELATION_TYPE_TRAINING then
      local szRelation = "师徒"
      szTip = szTip .. "关系：<color=yellow>" .. szRelation .. "<color>\n"
      szTip = szTip .. "门派：<color=yellow>" .. Player:GetFactionRouteName(tbInfo.nFaction) .. "<color>\n"
      szTip = szTip .. "等级：<color=yellow>" .. tbInfo.nLevel .. "级<color>\n"
      szTip = szTip .. "亲密度等级：<color=yellow>" .. nLevel .. "级（" .. tbInfo.nFavor .. "/" .. nNextLevelFavor .. "）<color>\n"
      szTip = szTip .. "组队时好友打怪分得经验加成：<color=yellow>" .. nFavorExpConf .. "倍<color>\n"
      if tbRelation.nGBOnline == 1 and tbRelation.nOnline == 0 then
        szTip = szTip .. "<color=125,111,172>此好友正在跨服中<color>\n"
      end
    elseif Player.emKPLAYERRELATION_TYPE_INTRODUCTION == tbRelation.nType then
      local szRelation = "被介绍人"
      szTip = szTip .. "关系：<color=yellow>" .. szRelation .. "<color>\n"
      szTip = szTip .. "门派：<color=yellow>" .. Player:GetFactionRouteName(tbInfo.nFaction) .. "<color>\n"
      szTip = szTip .. "等级：<color=yellow>" .. tbInfo.nLevel .. "级<color>\n"
      szTip = szTip .. "亲密度等级：<color=yellow>" .. nLevel .. "级（" .. tbInfo.nFavor .. "/" .. nNextLevelFavor .. "）<color>\n"
      szTip = szTip .. "组队时好友打怪分得经验加成：<color=yellow>" .. nFavorExpConf .. "倍<color>\n"
      if tbRelation.nGBOnline == 1 and tbRelation.nOnline == 0 then
        szTip = szTip .. "<color=125,111,172>此好友正在跨服中<color>\n"
      end
    else
      return
    end
  end
  local szPath, nType = tbViewPlayerMgr:GetPortraitSpr(szPlayer, tbInfo.nPortrait, tbInfo.nSex)
  local szBadge = ""
  if tbInfo.nKinBadge > 0 then
    local nLevel = math.floor(tbInfo.nKinBadge / 10000)
    local nNum = tbInfo.nKinBadge % 10000
    szBadge = string.format("                                <pic=%s>", 187 + (nLevel - 1) * 30 + nNum)
  end
  Wnd_ShowMouseHoverInfoEx(self.UIGROUP, szWnd, szName, szBadge .. szTip, szPath, nType)

  return szTip
end

function uiRelation:ShowGlobalFriendTip(szWnd, nGroupIndex, nItemIndex)
  local nPage = self.tbGroupIndex2PageIndex[nGroupIndex + 1]
  local szPlayer = self.tbOutLookStruct[nGroupIndex + 1][nItemIndex + 1]

  if szPlayer == nil then
    return
  end

  local szName = "名字：<color=yellow>" .. szPlayer .. "<color>\n"
  local szTip = "\n"
  local tbPlayerInfo = Player.tbGlobalFriends.tbPlayerInfo[szPlayer] or {}
  if tbPlayerInfo.nFaction ~= nil then
    szTip = szTip .. "门派：<color=yellow>" .. Player:GetFactionRouteName(tbPlayerInfo.nFaction) .. "<color>\n"
  else
    szTip = szTip .. "门派：<color=yellow>未知的<color>\n"
  end
  local szServerName = GetServerNameByGatewayName(tbPlayerInfo.szGateway or "")
  if not szServerName or szServerName == "" then
    szServerName = "【未知服务器】"
  end
  szTip = szTip .. "所在区服：<color=yellow>" .. szServerName .. "<color>\n"
  szTip = szTip .. "                         \n"
  local szPath
  if tbPlayerInfo.nPortrait == nil and tbPlayerInfo.nSex == nil then
    szPath = GetPortraitSpr(1, 0)
  else
    szPath = GetPortraitSpr(0, tbPlayerInfo.nSex)
  end
  if not szPath then
    return
  end
  Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, szName, szTip, szPath)
  return
end

function uiRelation:ShowTrainTip(szWnd, nGroupIndex, nItemIndex)
  local tbRelationList, tbInfoList = me.Relation_GetRelationList()
  if not tbInfoList then
    return 0
  end

  local nPage = self.tbGroupIndex2PageIndex[nGroupIndex + 1]
  local szPlayer = self.tbOutLookStruct[nGroupIndex + 1][nItemIndex + 1]
  local tbOnePageGroup = self.tbPageManager[nPage]
  if not tbOnePageGroup then
    return
  end

  local tbRelationList = tbOnePageGroup.tbRelationList

  if not tbRelationList then
    return
  end

  if szPlayer == nil then
    return
  end

  local tbInfo = tbInfoList[szPlayer]
  if not tbInfo then
    return
  end

  local nLevel = math.ceil(math.sqrt(tbInfo.nFavor / 100))
  local nFavorExpConf = me.GetFavorExpConf(tbInfo.nFavor) / 100
  local nNextLevelFavor = nLevel * nLevel * 100 + 1
  local szName = "名字：<color=yellow>" .. szPlayer .. "<color>\n"
  local szTip = "\n"

  local szRelation = ""
  if tbRelationList[szPlayer] == Player.emKPLAYERRELATION_TYPE_TRAINED then
    szRelation = "出师弟子"
  elseif tbRelationList[szPlayer].nRole == 0 then
    szRelation = "徒弟"
  else
    szRelation = "师傅"
  end
  szTip = szTip .. "关系：<color=yellow>" .. szRelation .. "<color>\n"
  szTip = szTip .. "门派：<color=yellow>" .. Player:GetFactionRouteName(tbInfo.nFaction) .. "<color>\n"
  szTip = szTip .. "等级：<color=yellow>" .. tbInfo.nLevel .. "级<color>\n"
  szTip = szTip .. "亲密度等级：<color=yellow>" .. nLevel .. "级（" .. tbInfo.nFavor .. "/" .. nNextLevelFavor .. "）<color>\n"
  szTip = szTip .. "组队时好友打怪分得经验加成：<color=yellow>" .. nFavorExpConf .. "倍<color>\n"

  local szPath, nType = tbViewPlayerMgr:GetPortraitSpr(szPlayer, tbInfo.nPortrait, tbInfo.nSex)
  Wnd_ShowMouseHoverInfoEx(self.UIGROUP, szWnd, szName, szTip, szPath, nType)
end

function uiRelation:ShowTips(szWnd, nParam)
  local nGroupIndex = Lib:LoadBits(nParam, 0, 15)
  local nItemIndex = Lib:LoadBits(nParam, 16, 31)

  if szWnd == self.OUTLOOK_MEMBERSHOWLIST and nItemIndex >= 0 and nItemIndex < self.FLAG_MAIN_GROUP_OUTLOOK then
    local nPage = self.tbGroupIndex2PageIndex[nGroupIndex + 1]
    if nPage == self.PAGE_INDEX_GLOBAL then
      self:ShowGlobalFriendTip(szWnd, nGroupIndex, nItemIndex)
    elseif nPage == self.PAGE_INDEX_FRIENDS or nPage == self.PAGE_INDEX_MYGROUP1 then
      self:ShowFriendTip(szWnd, nGroupIndex, nItemIndex)
    elseif nPage == self.PAGE_INDEX_TRAIN then
      self:ShowTrainTip(szWnd, nGroupIndex, nItemIndex)
    elseif self.nCurPage == self.PAGE_INDEX_BLACKLIST then
      return
    end
  end
end

function uiRelation:WndOpenCloseCallback(szWnd, nParam)
  if szWnd == Ui.UI_TEACHER then
    Btn_Check(self.UIGROUP, self.BUTTON_TEACHER, nParam)
  end
end

function uiRelation:SetRelationScores(tbRelationList)
  if not tbRelationList then
    return
  end
  for nType, tbList in pairs(tbRelationList) do
    local nScores = 0
    if Player.emKPLAYERRELATION_TYPE_COUPLE == nType then
      nScores = 100
    elseif Player.emKPLAYERRELATION_TYPE_BUDDY == nType then
      nScores = 90
    elseif Player.emKPLAYERRELATION_TYPE_INTRODUCTION == nType then
      nScores = 89
    end
    for szPlayer, tbInfo in pairs(tbList) do
      tbInfo.nScores = nScores
    end
  end
  return tbRelationList
end

-- 合并两个关系列表tbA，tbB
function uiRelation:MergeTable(tbA, tbB)
  local tbList = {}
  if tbA then
    for varIndex, varItem in pairs(tbA) do
      tbList[varIndex] = varItem
    end
  end

  if tbB then
    for varIndex, varItem in pairs(tbB) do
      tbList[varIndex] = varItem
    end
  end
  return tbList
end

function uiRelation:GetPlayerRelationList(nPage)
  local tbList = {}
  local tbListEx = {}
  local nTotalCount = 0
  local nOnlineCount = 0
  local tbRelationList, tbInfo = me.Relation_GetRelationList()
  if (not tbRelationList) and (nPage ~= self.PAGE_INDEX_GLOBAL) then
    return
  end

  local tbTempList = self:SetRelationScores(tbRelationList)

  self.tbRelationTypes = {}

  if nPage ~= self.PAGE_INDEX_GLOBAL then
    self:InsertToBuddyList(tbRelationList[Player.emKPLAYERRELATION_TYPE_BUDDY])
    tbListEx = self:_GetPlayerList(Player.emKPLAYERRELATION_TYPE_INTRODUCTION, 0) -- nRole = 1 代表是次位
    self:InsertToBuddyList(tbListEx)
  end

  if nPage == self.PAGE_INDEX_FRIENDS then
    tbList = self:MergeTable(tbTempList[Player.emKPLAYERRELATION_TYPE_BIDFRIEND], tbTempList[Player.emKPLAYERRELATION_TYPE_TMPFRIEND])
    tbList = self:MergeTable(tbList, tbTempList[Player.emKPLAYERRELATION_TYPE_INTRODUCTION])

    local tbTmpList1 = self:MergeTable(tbTempList[Player.emKPLAYERRELATION_TYPE_BUDDY], tbTempList[Player.emKPLAYERRELATION_TYPE_COUPLE]) -- 伴侣+密友

    -- 合并密友、师徒、伴侣
    local tbTmpList2 = self:MergeTable(tbTempList[Player.emKPLAYERRELATION_TYPE_TRAINING], tbTempList[Player.emKPLAYERRELATION_TYPE_TRAINED]) -- 师徒

    tbListEx = self:MergeTable(tbTmpList2, tbTmpList1)
    tbList = self:MergeTable(tbList, tbListEx)
  elseif nPage == self.PAGE_INDEX_ENEMY then
    tbList = tbRelationList[Player.emKPLAYERRELATION_TYPE_ENEMEY]
  elseif nPage == self.PAGE_INDEX_BLACKLIST then
    local tbOrgList = tbRelationList[Player.emKPLAYERRELATION_TYPE_BLACKLIST] or {}
    tbList = Lib:CopyTB1(tbOrgList)
    local tbBlackList = Player.tbGlobalFriends.tbBlackList
    for _k, _v in pairs(tbBlackList) do
      tbList[_v] = { szPlayer = _v }
    end
  elseif nPage == self.PAGE_INDEX_TRAIN then
    tbList = self:MergeTable(tbRelationList[Player.emKPLAYERRELATION_TYPE_TRAINING], tbRelationList[Player.emKPLAYERRELATION_TYPE_TRAINED])
  elseif nPage == self.PAGE_INDEX_GLOBAL then
    local tbFriendList = me.GlobalFriends_GetList()
    tbList = {}
    for _k, _v in pairs(tbFriendList) do
      if Player.tbGlobalFriends.tbPlayerInfo[_v.szName] then
        tbList[_k] = {
          szPlayer = _v.szName,
          nFaction = Player.tbGlobalFriends.tbPlayerInfo[_v.szName].nFaction,
          nSex = Player.tbGlobalFriends.tbPlayerInfo[_v.szName].nSex,
          nType = Player.emKPLAYERRELATION_TYPE_GLOBALFRIEND,
        }
      else
        tbList[_k] = {
          szPlayer = _v.szName,
          nFaction = 0,
          nSex = 0,
          nType = Player.emKPLAYERRELATION_TYPE_GLOBALFRIEND,
        }
      end
    end
  elseif nPage == self.PAGE_INDEX_MYGROUP1 then
    local nGroupId = self.tbPageManager[nPage].nGroupId
    local tbRelationGroup = me.Relation_GetRelationGroupList(nGroupId)
    if tbRelationGroup and tbRelationGroup.tbGroup then
      local tbFriendList = {}
      tbFriendList = self:MergeTable(tbRelationList[Player.emKPLAYERRELATION_TYPE_BIDFRIEND], tbRelationList[Player.emKPLAYERRELATION_TYPE_TMPFRIEND])
      tbFriendList = self:MergeTable(tbFriendList, tbRelationList[Player.emKPLAYERRELATION_TYPE_INTRODUCTION])

      -- 合并密友、师徒、伴侣
      local tbTmpList1 = self:MergeTable(tbRelationList[Player.emKPLAYERRELATION_TYPE_COUPLE], tbRelationList[Player.emKPLAYERRELATION_TYPE_BUDDY]) -- 伴侣+密友
      local tbTmpList2 = self:MergeTable(tbRelationList[Player.emKPLAYERRELATION_TYPE_TRAINING], tbRelationList[Player.emKPLAYERRELATION_TYPE_TRAINED]) -- 师徒
      tbListEx = self:MergeTable(tbTmpList1, tbTmpList2)
      tbFriendList = self:MergeTable(tbFriendList, tbListEx)
      for szPlayerName, _ in pairs(tbRelationGroup.tbGroup) do
        tbList[szPlayerName] = tbFriendList[szPlayerName]
      end
    end
  end
  local tbSortList, nTotalCount, nOnlineCount = self:NormalSort(tbList)
  return tbSortList, tbList, nTotalCount, nOnlineCount
end

-- 比较函数
uiRelation._Cmp = function(pPlayerA, pPlayerB)
  local bRet = 0
  local nAOnline = pPlayerA.nOnline + pPlayerA.nGBOnline
  local nBOnline = pPlayerB.nOnline + pPlayerB.nGBOnline
  if nAOnline == nBOnline then
    if pPlayerA.nScores == pPlayerB.nScores then
      bRet = pPlayerA.nFavor > pPlayerB.nFavor
    else
      bRet = pPlayerA.nScores > pPlayerB.nScores
    end
  else
    bRet = nAOnline > nBOnline
  end
  return bRet
end

function uiRelation:NormalSort(tbList)
  local _, tbInfo = me.Relation_GetRelationList()
  tbInfo = tbInfo or {}
  local tbSortList = {}
  local tbTempFriend = {}
  local nOnlineCount = 0
  local nTotalCount = 0

  if tbList then
    for szPlayer, tbRelation in pairs(tbList) do
      local tbItem = {}
      tbItem.szPlayer = szPlayer
      tbItem.nOnline = tbRelation.nOnline
      tbItem.nGBOnline = tbRelation.nGBOnline

      nTotalCount = nTotalCount + 1
      if tbItem.nOnline == 1 or tbItem.nGBOnline == 1 then
        nOnlineCount = nOnlineCount + 1
      end

      local nInsertFlag = 1

      if self.nIsShowOnlinePlayer == 1 and tbItem.nOnline == 0 and tbItem.nGBOnline == 0 then
        nInsertFlag = 0
      end

      if nInsertFlag == 1 then
        if tbInfo[szPlayer] then
          tbItem.nFavor = tbInfo[szPlayer].nFavor
          tbItem.nScores = tbRelation.nScores or 0
          table.insert(tbSortList, tbItem)
        else
          table.insert(tbTempFriend, tbItem)
        end
      end
    end

    if #tbSortList > 1 then
      table.sort(tbSortList, self._Cmp)
    end
  end
  for _, pPlayer in ipairs(tbTempFriend) do
    table.insert(tbSortList, pPlayer)
  end

  return tbSortList, nTotalCount, nOnlineCount
end

function uiRelation:UpdateRelationData()
  for nPage, tbPage in pairs(self.tbPageManager) do
    local tbSortList, tbRelationList, nTotalCount, nOnlineCount = self:GetPlayerRelationList(nPage)
    tbPage.tbSortList = tbSortList
    tbPage.tbRelationList = tbRelationList
    tbPage.nTotalCount = nTotalCount or 0
    tbPage.nOnlineCount = nOnlineCount or 0
    if nPage == 1 and self:GetKefuFriend() == 1 then
      tbPage.nOnlineCount = tbPage.nOnlineCount + 1
      tbPage.nTotalCount = tbPage.nTotalCount + 1
    end
  end
end

function uiRelation:UpdateMyGroupData()
  for nPage, tbGroup in pairs(self.tbPageManager) do
    if tbGroup.nGroupId then
      tbGroup.nIsShow = 0
      local tbMyGroup = me.Relation_GetRelationGroupList(tbGroup.nGroupId)
      if tbMyGroup then
        tbGroup.nIsShow = 1
        tbGroup.szGroupName = tbMyGroup.szName
      end
    end
  end
end

function uiRelation:UpdateRelationPanel(bDirectOpen)
  if bDirectOpen ~= 1 and UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    return
  end

  self.nCurScrollTop = self:GetRelationScrLstTop()

  self:UpdateBasicPortrait()
  self:UpdateMyGroupData()
  self:UpdateRelationData()
  self.tbSearchList = self:GetSearchPlayerList()
  self:ShowRelationList()
  self:SetRelationScrLstTop(self.nCurScrollTop)

  local nHaveGroup = self:GetMyGroupCount()

  if nHaveGroup < Relation.DEF_MAX_RELATIONGROUP_COUNT then
    Wnd_SetEnable(self.UIGROUP, self.BTN_ADDGROUP, 1)
  else
    Wnd_SetEnable(self.UIGROUP, self.BTN_ADDGROUP, 0)
  end
end

function uiRelation:ShowGroupName(nPage, nOutLookGroupId)
  local tbOneRelation = self.tbPageManager[nPage]
  if not tbOneRelation then
    return nOutLookGroupId
  end

  self.tbPageManager[nPage].nOutLookGroupId = 0

  if tbOneRelation.nIsShow == 0 then
    return nOutLookGroupId
  end

  local szGroupName = string.format("%s[%s/%s]", tbOneRelation.szGroupName, tbOneRelation.nOnlineCount, tbOneRelation.nTotalCount)
  if nPage == self.PAGE_INDEX_GLOBAL or nPage == self.PAGE_INDEX_BLACKLIST then
    szGroupName = string.format("%s[%s]", tbOneRelation.szGroupName, tbOneRelation.nTotalCount)
  end
  AddOutLookGroup(self.UIGROUP, self.OUTLOOK_MEMBERSHOWLIST, szGroupName)
  nOutLookGroupId = nOutLookGroupId + 1
  if not self.tbOutLookStruct[nOutLookGroupId] then
    self.tbOutLookStruct[nOutLookGroupId] = {}
  end
  self.tbPageManager[nPage].nOutLookGroupId = nOutLookGroupId
  self.tbGroupIndex2PageIndex[nOutLookGroupId] = nPage
  return nOutLookGroupId
end

function uiRelation:ClearList()
  self:SaveOrgCollapseState()
  self:ClearOutLookGroupIdInTable()

  OutLookPanelClearAll(self.UIGROUP, self.OUTLOOK_MEMBERSHOWLIST)

  AddOutLookPanelColumnHeader(self.UIGROUP, self.OUTLOOK_MEMBERSHOWLIST, "")
  AddOutLookPanelColumnHeader(self.UIGROUP, self.OUTLOOK_MEMBERSHOWLIST, "")
  AddOutLookPanelColumnHeader(self.UIGROUP, self.OUTLOOK_MEMBERSHOWLIST, "")
  AddOutLookPanelColumnHeader(self.UIGROUP, self.OUTLOOK_MEMBERSHOWLIST, "")
  SetOutLookHeaderWidth(self.UIGROUP, self.OUTLOOK_MEMBERSHOWLIST, 0, 17)
  SetOutLookHeaderWidth(self.UIGROUP, self.OUTLOOK_MEMBERSHOWLIST, 1, 20)
  SetOutLookHeaderWidth(self.UIGROUP, self.OUTLOOK_MEMBERSHOWLIST, 2, 145)
  SetOutLookHeaderWidth(self.UIGROUP, self.OUTLOOK_MEMBERSHOWLIST, 3, 14)
end

function uiRelation:ShowGroupPlayer(nPage, nOutLookGroupId)
  local tbOneRelation = self.tbPageManager[nPage]
  if not tbOneRelation then
    return nOutLookGroupId
  end

  if tbOneRelation.nIsShow == 0 then
    return nOutLookGroupId
  end
  local tbSortList = tbOneRelation.tbSortList
  local tbRelationList = tbOneRelation.tbRelationList

  if not tbSortList or not tbRelationList then
    return nOutLookGroupId
  end

  local _, tbInfoList = me.Relation_GetRelationList()
  if nPage == 1 and self:GetKefuFriend() == 1 then
    AddOutLookItem(self.UIGROUP, self.OUTLOOK_MEMBERSHOWLIST, nOutLookGroupId - 1, { "", "", "<color=green>☆剑世小助手☆<color>", "" })
    self.tbOutLookStruct[nOutLookGroupId][1] = "<color=green>☆剑世小助手☆<color>"
    SetOutLookPanelItemButtonCount(self.UIGROUP, self.OUTLOOK_MEMBERSHOWLIST, nOutLookGroupId - 1, 0, 1)
    SetOutLookPanelItemButtonInfo(self.UIGROUP, self.OUTLOOK_MEMBERSHOWLIST, nOutLookGroupId - 1, 0, 0, 1, 11, 13, self.tbImgPlayer[Env.SEX_FEMALE])
    self.nKefuFriend = 1
  end
  for j, tbInfo in ipairs(tbSortList) do
    local i = j
    if self.nKefuFriend == 1 then
      i = j + 1
    end
    local tbRelation = tbRelationList[tbInfo.szPlayer]
    assert(tbRelation)
    local szBuffer = tbRelation.szPlayer
    -- 高亮显示有点问题
    -- 正式好友的特殊显示处理
    if (tbRelation.nType == Player.emKPLAYERRELATION_TYPE_BIDFRIEND) or (tbRelation.nType == Player.emKPLAYERRELATION_TYPE_INTRODUCTION) or (tbRelation.nType == Player.emKPLAYERRELATION_TYPE_TRAINING) or (tbRelation.nType == Player.emKPLAYERRELATION_TYPE_TRAINED) or (tbRelation.nType == Player.emKPLAYERRELATION_TYPE_COUPLE) or (tbRelation.nType == Player.emKPLAYERRELATION_TYPE_BUDDY) then
      if tbRelation.nOnline == 0 and tbRelation.nGBOnline == 0 then -- 离线状态
        szBuffer = "<color=0xff565656>" .. szBuffer
      elseif tbRelation.nOnline == 0 and tbRelation.nGBOnline == 1 then -- 全局服在线
        szBuffer = "<color=125,111,172>" .. szBuffer
      else
        --				if (tbRelation.nType == Player.emKPLAYERRELATION_TYPE_BIDFRIEND) then
        --					szBuffer = "<color=0xF677E3>"..szBuffer;
        --				elseif (tbRelation.nType == Player.emKPLAYERRELATION_TYPE_COUPLE) then
        --					szBuffer = "<color=0xFA0606>"..szBuffer;
        --				else
        szBuffer = "<color=220,220,220>" .. szBuffer
        --				end
      end
    elseif tbRelation.nType == Player.emKPLAYERRELATION_TYPE_ENEMEY then
      if tbRelation.nOnline == 0 then -- 离线状态
        szBuffer = "<color=0xff565656>" .. szBuffer
      else
        szBuffer = "<color=0xffdcdcdc>" .. szBuffer
      end
    elseif tbRelation.nType == Player.emKPLAYERRELATION_TYPE_TMPFRIEND then
      szBuffer = "<color=0xff752e07>" .. szBuffer
    end

    local szPlayerRelation = ""
    if tbRelation.nType == Player.emKPLAYERRELATION_TYPE_COUPLE then
      szPlayerRelation = "<color=250,6,6>侣<color>"
    elseif tbRelation.nType == Player.emKPLAYERRELATION_TYPE_BUDDY or tbRelation.nType == Player.emKPLAYERRELATION_TYPE_INTRODUCTION then
      szPlayerRelation = "<color=246,119,227>密<color>"
    end

    local szPlayerStateBtn = self.IMG_AFK

    if tbInfoList then
      local tbRelationInfo = tbInfoList[tbRelation.szPlayer]
      if tbRelationInfo and (tbRelation.nOnline == 1 or tbRelation.nGBOnline == 1) then
        szPlayerStateBtn = self.tbImgPlayer[tbRelationInfo.nSex]
      end
    end

    local nBtnCount = 0
    local nIsShowSnsBtn = 0
    local nIsTempFriend = 1

    AddOutLookItem(self.UIGROUP, self.OUTLOOK_MEMBERSHOWLIST, nOutLookGroupId - 1, { szPlayerRelation, "", szBuffer, "" })

    if tbRelation.nType ~= Player.emKPLAYERRELATION_TYPE_TMPFRIEND then
      local nBtnCount = 1
      local nIsShowSnsBtn = 0
      if tbInfoList then
        if Sns.bIsOpen == 1 then
          if self.nCurPage ~= self.PAGE_INDEX_GLOBAL then
            local tb = tbInfoList[tbRelation.szPlayer]
            local nEnable = (tb and tb.nSnsBind ~= 0 and 1) or 0
            if Sns.bInGame == 1 and nEnable == 1 then
              nBtnCount = nBtnCount + 1
              nIsShowSnsBtn = 1
            end
          end
        end
      end
      SetOutLookPanelItemButtonCount(self.UIGROUP, self.OUTLOOK_MEMBERSHOWLIST, nOutLookGroupId - 1, i - 1, nBtnCount)
      SetOutLookPanelItemButtonInfo(self.UIGROUP, self.OUTLOOK_MEMBERSHOWLIST, nOutLookGroupId - 1, i - 1, 0, 1, 11, 13, szPlayerStateBtn)
      if nBtnCount > 1 and nIsShowSnsBtn == 1 then
        SetOutLookPanelItemButtonInfo(self.UIGROUP, self.OUTLOOK_MEMBERSHOWLIST, nOutLookGroupId - 1, i - 1, 1, 3, 14, 14, self.IMG_SNS_RELATION)
      end
    end

    self.tbOutLookStruct[nOutLookGroupId][i] = tbRelation.szPlayer
  end
end

function uiRelation:OnOutLookItemBtnClicked(szWndName, nGIdx, nItemIndex, nBtnIdx)
  if nGIdx == 0 and nItemIndex == 0 and self.nKefuFriend == 1 then
    UiManager:OpenWindow("UI_LIVE800")
  end
  local nPage = self.tbGroupIndex2PageIndex[nGIdx + 1]
  if 3 == nBtnIdx then -- 这个是微博按钮
    if Sns.bIsOpen == 1 then
      local tbPage = self.tbPageManager[nPage]
      local szPlayer = self.tbOutLookStruct[nGIdx + 1][nItemIndex + 1]
      local tbPlayerAccount = Sns.tbHasNewTweet[szPlayer]
      if type(tbPlayerAccount) == "table" then
        for nSnsId, szAccount in pairs(tbPlayerAccount) do
          if szAccount then
            local tbSns = Sns:GetSnsObject(nSnsId)
            local szUrl = tbSns:GetAccountTweetPageUrl(szAccount)
            Sns.tbHasNewTweet[szPlayer] = nil
            Sns:GoToUrl(szUrl)
            break
          end
        end
      else
        UiManager:OpenWindow(Ui.UI_BLOGVIEWPLAYER, szPlayer)
      end
    end
  end
end

function uiRelation:SetCollapseStateValue(nPage, nUnFold)
  local nOutLookGroupId = self.tbPageManager[nPage].nOutLookGroupId
  if not nOutLookGroupId or nOutLookGroupId <= 0 then
    return 0
  end
  self.tbPageManager[nPage].nUnFold = nUnFold or 0
end

function uiRelation:ResetRelationGroup()
  for nPage, tbPage in pairs(self.tbPageManager) do
    if nPage == self.PAGE_INDEX_MYGROUP1 then
      tbPage.szGroupName = "自定义分组1"
      tbPage.nIsShow = 0
    end
    tbPage.nUnFold = 0
  end
end

function uiRelation:ClearOutLookGroupIdInTable()
  for nPage, tbPage in pairs(self.tbPageManager) do
    tbPage.nOutLookGroupId = 0
  end
end

function uiRelation:SaveOrgCollapseState()
  for nPage, tbPage in pairs(self.tbPageManager) do
    local nOutLookGroupId = tbPage.nOutLookGroupId
    tbPage.nUnFold = 0
    if nOutLookGroupId > 0 then
      tbPage.nUnFold = GetOutLookGroupCollapseState(self.UIGROUP, self.OUTLOOK_MEMBERSHOWLIST, nOutLookGroupId - 1)
    end
  end
end

function uiRelation:SetCollapseState(nPage)
  local nOutLookGroupId = self.tbPageManager[nPage].nOutLookGroupId
  if not nOutLookGroupId or nOutLookGroupId <= 0 then
    return 0
  end
  local nUnFold = self.tbPageManager[nPage].nUnFold
  if not nUnFold then
    nUnFold = 0
  end
  SetGroupCollapseState(self.UIGROUP, self.OUTLOOK_MEMBERSHOWLIST, nOutLookGroupId - 1, nUnFold)
end

function uiRelation:ShowOneRelationList(nPage, nOutLookGroupId)
  local tbOneRelation = self.tbPageManager[nPage]
  if not tbOneRelation then
    return nOutLookGroupId
  end

  if tbOneRelation.nIsShow == 0 then
    return nOutLookGroupId
  end
  local nRet = self:ShowGroupName(nPage, nOutLookGroupId)
  if nRet == nOutLookGroupId then
    return nOutLookGroupId
  end
  nOutLookGroupId = nRet
  self:ShowGroupPlayer(nPage, nOutLookGroupId)
  self:SetCollapseState(nPage)
  return nOutLookGroupId
end

function uiRelation:ShowRelationList()
  self:ClearList()
  self.tbCellIndex2PageIndex = {}
  self.tbGroupIndex2PageIndex = {}
  self.tbOutLookStruct = {}
  self.nOutLookGroupId = 0
  local nOutLookGroupId = 0
  for nPage, tbPage in ipairs(self.tbPageManager) do
    nOutLookGroupId = self:ShowOneRelationList(nPage, nOutLookGroupId)
  end
  self.nOutLookGroupId = nOutLookGroupId
end

function uiRelation:OnRefreshTraining()
  Ui(Ui.UI_TEACHER):RefreshTraining()
end

function uiRelation:OnRelationOnline(szPlayer, nType, nRole, nOnline, nGBOnline)
  nGBOnline = nGBOnline or 0
  me.Relation_SetOnlineState(szPlayer, nOnline, nGBOnline)
  self:UpdateRelationPanel()
  if nOnline == 1 and nGBOnline == 0 then
    me.Msg(szPlayer .. "上线了！")
  elseif nOnline == 1 and nGBOnline == 1 then
    me.Msg(szPlayer .. "从跨服战区回来了！")
  elseif nOnline == 0 and nGBOnline == 1 then
    me.Msg(szPlayer .. "去跨服战区了！")
  else
    me.Msg(szPlayer .. "下线了！")
  end
end

-- 根据nType和nRole获取玩家列表（关系类型和关系子类型）
function uiRelation:_GetPlayerList(nType, nRole)
  local tbList = {}
  local tbRelationList = me.Relation_GetRelationList()
  if not tbRelationList then
    return tbList
  end
  if tbRelationList[nType] then
    for szPlayer, tbInfo in pairs(tbRelationList[nType]) do
      if tbInfo.nRole == nRole then
        tbList[szPlayer] = tbInfo
      end
    end
  end
  return tbList
end

function uiRelation:InsertToBuddyList(tbListEx)
  if not self.tbRelationTypes then
    self.tbRelationTypes = {}
  end
  if tbListEx then
    for szPlayer, tbRelation in pairs(tbListEx) do
      if not self.tbRelationTypes[szPlayer] then
        self.tbRelationTypes[szPlayer] = {}
      end
      table.insert(self.tbRelationTypes[szPlayer], tbRelation.nType)
    end
  end
end

----------------------------------------------------------
-- outlook event

function uiRelation:OnOutLookItemRBClicked(szWndName, nGroupIndex, nItemIndex)
  if nGroupIndex == 0 and nItemIndex == 0 and self.nKefuFriend == 1 then
    UiManager:OpenWindow("UI_LIVE800")
  end
  local tbMenu = self:GetMenuItemList(szWndName, nGroupIndex, nItemIndex)
  if not tbMenu then
    return
  end
  DisplayPopupMenu(unpack(tbMenu))
end

function uiRelation:OnOutLookItemLDClicked(szWndName, nGroupIndex, nItemIndex)
  if nGroupIndex == 0 and nItemIndex == 0 and self.nKefuFriend == 1 then
    UiManager:OpenWindow("UI_LIVE800")
  end
  if szWndName == self.OUTLOOK_MEMBERSHOWLIST then
    local tbRelation = self:GetRelationTableFromListIndex(nGroupIndex, nItemIndex)
    if tbRelation then
      local nSendMail = UiManager:WindowVisible(Ui.UI_MAILNEW)
      if nSendMail ~= 0 then
        Ui(Ui.UI_MAILNEW):SetReceiver(tbRelation.szPlayer)
      else
        self:CmdWhisper(tbRelation)
      end
    end
  end
end

function uiRelation:SetKeyMenuNum(nGroupIndex, nItemIndex)
  local nRet = 0
  nRet = Lib:SetBits(nRet, nGroupIndex, 11, 15)
  nRet = Lib:SetBits(nRet, nItemIndex, 0, 10)
  return nRet
end

function uiRelation:GetKeyMenuNum(nKeyNum)
  local nGroupId = Lib:LoadBits(nKeyNum, 11, 15)
  local nTempIndex = Lib:LoadBits(nKeyNum, 0, 10)
  return nGroupId, nTempIndex
end

function uiRelation:GetMenuItemList(szWndName, nGroupIndex, nItemIndex)
  local nPage = self.tbGroupIndex2PageIndex[nGroupIndex + 1]
  if not nPage then
    return
  end

  local nTempIndex = nItemIndex
  if nTempIndex == self.FLAG_MAIN_GROUP_OUTLOOK then
    nTempIndex = -1
  end
  local nMenuKeyNum = self:SetKeyMenuNum(nGroupIndex + 1, nTempIndex + 1)
  local tbTempMenu = nil

  local tbMenu = { self.UIGROUP, szWndName, 0, nMenuKeyNum }

  if nPage == self.PAGE_INDEX_FRIENDS then
    tbTempMenu = self:GetFriendMenu(szWndName, nGroupIndex, nItemIndex)
  elseif nPage == self.PAGE_INDEX_MYGROUP1 then
    tbTempMenu = self:GetMyGroupMenu(szWndName, nGroupIndex, nItemIndex)
  elseif nPage == self.PAGE_INDEX_TRAIN then
    tbTempMenu = self:GetTrainMenu(szWndName, nGroupIndex, nItemIndex)
  elseif nPage == self.PAGE_INDEX_GLOBAL then
    tbTempMenu = self:GetGlobalMenu(szWndName, nGroupIndex, nItemIndex)
  elseif nPage == self.PAGE_INDEX_ENEMY then
    -- 目前没有操作
    tbTempMenu = self:GetEnemyMenu(szWndName, nGroupIndex, nItemIndex)
  elseif nPage == self.PAGE_INDEX_BLACKLIST then
    tbTempMenu = self:GetBlackList(szWndName, nGroupIndex, nItemIndex)
  else
    -- 目前没有操作
  end

  if not tbTempMenu then
    return
  end

  local nMenuCount = #tbTempMenu

  nMenuCount = math.floor(nMenuCount / 2)
  tbMenu[3] = nMenuCount

  for _, value in ipairs(tbTempMenu) do
    tbMenu[#tbMenu + 1] = value
  end

  return tbMenu
end

function uiRelation:GetMyGroupCount()
  local nHaveGroup = 0
  for nPage, tbTempPage in pairs(self.tbPageManager) do
    if tbTempPage.nGroupId then
      local tbInfo = me.Relation_GetRelationGroupList(tbTempPage.nGroupId)
      if tbInfo then
        nHaveGroup = nHaveGroup + 1
      end
    end
  end
  return nHaveGroup
end

function uiRelation:GetMyGroupMenuItem(tbRelation)
  local tbMenuItem = {}

  if not tbRelation then
    return tbMenuItem
  end

  for nPage, tbTempPage in pairs(self.tbPageManager) do
    if tbTempPage.nGroupId then
      local tbInfo = me.Relation_GetRelationGroupList(tbTempPage.nGroupId)
      if tbInfo then
        if not tbInfo.tbGroup or not tbInfo.tbGroup[tbRelation.szPlayer] then
          tbMenuItem[tbTempPage.nMenuIndex] = "复制到" .. tbInfo.szName
        end
      end
    end
  end

  return tbMenuItem
end

function uiRelation:GetFriendMenu(szWndName, nGroupIndex, nItemIndex)
  local nPage = self.tbGroupIndex2PageIndex[nGroupIndex + 1]
  local tbOutLookGroup = self.tbOutLookStruct[nGroupIndex + 1]
  local tbMyGroupList = {}
  local nMenuCount = 4
  local tbMenu = {}

  local nHaveGroup = self:GetMyGroupCount()

  if nItemIndex == self.FLAG_MAIN_GROUP_OUTLOOK then
    if nHaveGroup < Relation.DEF_MAX_RELATIONGROUP_COUNT then
      tbMenu = { self.MENU_ITEM[self.MENU_INDEX_CREATE_MYGROUP], self.MENU_INDEX_CREATE_MYGROUP }
      return tbMenu
    end
    return
  end

  local tbRelation = self:GetRelationTableFromListIndex(nGroupIndex, nItemIndex)
  if not tbRelation then
    return
  end

  local tbMenuItem = self:GetMyGroupMenuItem(tbRelation)

  tbMenu = {
    self.MENU_ITEM[self.MENU_INDEX_MILIAO],
    self.MENU_INDEX_MILIAO,
    self.MENU_ITEM[self.MENU_INDEX_MAIL],
    self.MENU_INDEX_MAIL,
    self.MENU_ITEM[self.MENU_INDEX_TEAM],
    self.MENU_INDEX_TEAM,
  }

  if Player.emKPLAYERRELATION_TYPE_BUDDY ~= tbRelation.nType and Player.emKPLAYERRELATION_TYPE_COUPLE ~= tbRelation.nType and Player.emKPLAYERRELATION_TYPE_TRAINED ~= tbRelation.nType and Player.emKPLAYERRELATION_TYPE_TRAINING ~= tbRelation.nType then
    tbMenu[#tbMenu + 1] = self.MENU_ITEM[self.MENU_INDEX_DEL]
    tbMenu[#tbMenu + 1] = self.MENU_INDEX_DEL
  end

  if Player.emKPLAYERRELATION_TYPE_TMPFRIEND == tbRelation.nType then
    for nIndex, value in pairs(tbMenuItem) do
      tbMenu[#tbMenu + 1] = value
      tbMenu[#tbMenu + 1] = nIndex
    end
    return tbMenu
  end

  local _, tbInfoList = me.Relation_GetRelationList()
  local tbPlayerInfo = tbInfoList[tbRelation.szPlayer]

  assert(tbPlayerInfo)

  for nIndex, value in pairs(tbMenuItem) do
    tbMenu[#tbMenu + 1] = value
    tbMenu[#tbMenu + 1] = nIndex
  end

  return tbMenu
end

function uiRelation:GetMyGroupMenu(szWndName, nGroupIndex, nItemIndex)
  local nHaveGroup = self:GetMyGroupCount()

  if nItemIndex == self.FLAG_MAIN_GROUP_OUTLOOK then
    local tbMenu = nil
    if nHaveGroup > 0 then
      tbMenu = {
        self.MENU_ITEM[self.MENU_INDEX_RENAME],
        self.MENU_INDEX_RENAME,
        self.MENU_ITEM[self.MENU_INDEX_DELGROUP],
        self.MENU_INDEX_DELGROUP,
      }
    end

    if nHaveGroup < Relation.DEF_MAX_RELATIONGROUP_COUNT then
      tbMenu[#tbMenu + 1] = self.MENU_ITEM[self.MENU_INDEX_CREATE_MYGROUP]
      tbMenu[#tbMenu + 1] = self.MENU_INDEX_CREATE_MYGROUP
      return tbMenu
    end

    return tbMenu
  end

  local tbMenu = {
    self.MENU_ITEM[self.MENU_INDEX_MILIAO],
    self.MENU_INDEX_MILIAO,
    self.MENU_ITEM[self.MENU_INDEX_MAIL],
    self.MENU_INDEX_MAIL,
    self.MENU_ITEM[self.MENU_INDEX_TEAM],
    self.MENU_INDEX_TEAM,
    self.MENU_ITEM[self.MENU_INDEX_DEL],
    self.MENU_INDEX_DEL,
  }
  return tbMenu
end

function uiRelation:GetTrainMenu(szWndName, nGroupIndex, nItemIndex)
  local nHaveGroup = self:GetMyGroupCount()

  if nItemIndex == self.FLAG_MAIN_GROUP_OUTLOOK then
    if nHaveGroup < Relation.DEF_MAX_RELATIONGROUP_COUNT then
      local tbMenu = { self.MENU_ITEM[self.MENU_INDEX_CREATE_MYGROUP], self.MENU_INDEX_CREATE_MYGROUP }
      return tbMenu
    end
    return
  end

  local tbMenu = {
    self.MENU_ITEM[self.MENU_INDEX_MILIAO],
    self.MENU_INDEX_MILIAO,
    self.MENU_ITEM[self.MENU_INDEX_MAIL],
    self.MENU_INDEX_MAIL,
    self.MENU_ITEM[self.MENU_INDEX_TEAM],
    self.MENU_INDEX_TEAM,
  }
  return tbMenu
end

function uiRelation:GetGlobalMenu(szWndName, nGroupIndex, nItemIndex)
  local nHaveGroup = self:GetMyGroupCount()

  if nItemIndex == self.FLAG_MAIN_GROUP_OUTLOOK then
    if nHaveGroup < Relation.DEF_MAX_RELATIONGROUP_COUNT then
      local tbMenu = { self.MENU_ITEM[self.MENU_INDEX_CREATE_MYGROUP], self.MENU_INDEX_CREATE_MYGROUP }
      return tbMenu
    end
    return
  end
  local tbMenu = { self.MENU_ITEM[self.MENU_INDEX_MILIAO], self.MENU_INDEX_MILIAO, self.MENU_ITEM[self.MENU_INDEX_DEL], self.MENU_INDEX_DEL }
  return tbMenu
end

function uiRelation:GetEnemyMenu(szWndName, nGroupIndex, nItemIndex)
  local nHaveGroup = self:GetMyGroupCount()

  if nItemIndex == self.FLAG_MAIN_GROUP_OUTLOOK then
    if nHaveGroup < Relation.DEF_MAX_RELATIONGROUP_COUNT then
      local tbMenu = { self.MENU_ITEM[self.MENU_INDEX_CREATE_MYGROUP], self.MENU_INDEX_CREATE_MYGROUP }
      return tbMenu
    end
    return
  end

  local tbMenu = {
    self.MENU_ITEM[self.MENU_INDEX_MILIAO],
    self.MENU_INDEX_MILIAO,
    self.MENU_ITEM[self.MENU_INDEX_MAIL],
    self.MENU_INDEX_MAIL,
    self.MENU_ITEM[self.MENU_INDEX_TEAM],
    self.MENU_INDEX_TEAM,
    self.MENU_ITEM[self.MENU_INDEX_DEL],
    self.MENU_INDEX_DEL,
  }

  return tbMenu
end

function uiRelation:GetBlackList(szWndName, nGroupIndex, nItemIndex)
  local nHaveGroup = self:GetMyGroupCount()

  if nItemIndex == self.FLAG_MAIN_GROUP_OUTLOOK then
    if nHaveGroup < Relation.DEF_MAX_RELATIONGROUP_COUNT then
      local tbMenu = { self.MENU_ITEM[self.MENU_INDEX_CREATE_MYGROUP], self.MENU_INDEX_CREATE_MYGROUP }
      return tbMenu
    end
    return
  end

  local tbMenu = { self.MENU_ITEM[self.MENU_INDEX_DEL], self.MENU_INDEX_DEL }

  return tbMenu
end

----------------------------------------------------------
-- menu event

function uiRelation:OnMenuItemSelected(szWnd, nItemId, nListItem)
  if szWnd == self.BTN_CHANGE_STATE then
    self:SetPlayerState(nItemId)
  elseif szWnd == self.OUTLOOK_MEMBERSHOWLIST then
    local nGroupIndex, nItemIndex = self:GetKeyMenuNum(nListItem)
    --	local nIndex = Lst_GetLineData(self.UIGROUP, self.LIST_NAME, nListItem);
    local tbRelation = self:GetRelationTableFromListIndex(nGroupIndex - 1, nItemIndex - 1)

    if nItemId == self.MENU_INDEX_CREATE_MYGROUP then
      self.POPUPMUNE_CALLBACK[nItemId](self)
      return 0
    end

    if nItemId == self.MENU_INDEX_RENAME or nItemId == self.MENU_INDEX_DELGROUP then
      local nPage = self.tbGroupIndex2PageIndex[nGroupIndex]
      self.POPUPMUNE_CALLBACK_EX[nItemId](self, nPage)
      return 0
    end

    if tbRelation and nItemId >= self.MENU_INDEX_MILIAO and nItemId <= self.MENU_INDEX_MAX then -- 6为右键菜单的最大项数，要定义一个枚举与每项菜单对应
      local nPage = self.tbGroupIndex2PageIndex[nGroupIndex]
      if nPage == self.PAGE_INDEX_MYGROUP1 then
        self.POPUPMUNE_CALLBACK_EX[nItemId](self, tbRelation, nPage)
      else
        self.POPUPMUNE_CALLBACK[nItemId](self, tbRelation, nPage)
      end
    end
  end
end

function uiRelation:GetRelationTableFromListIndex(nGroupIndex, nItemIndex)
  local nPage = self.tbGroupIndex2PageIndex[nGroupIndex + 1]
  local tbOutLookGroup = self.tbOutLookStruct[nGroupIndex + 1]

  if not nPage or nPage <= 0 then
    return
  end

  local tbOneRelation = self.tbPageManager[nPage]
  if not tbOneRelation then
    return
  end

  local tbRelationList = tbOneRelation.tbRelationList
  local tbSortList = tbOneRelation.tbSortList

  local tbRelation = tbRelationList[tbOutLookGroup[nItemIndex + 1]]
  return tbRelation
end

function uiRelation:SetPlayerState(nState)
  if self.PLAYER_STATE_ONLINE == nState then
    SetInvisibleLogin(0)
    Img_SetImage(self.UIGROUP, self.BTN_CHANGE_STATE, 1, self.IMG_ONLINE)
  elseif self.PLAYER_STATE_INVISIBLE == nState then
    SetInvisibleLogin(1)
    Img_SetImage(self.UIGROUP, self.BTN_CHANGE_STATE, 1, self.IMG_STEALTH)
  end
end

function uiRelation:CmdWhisper(tbPlayer)
  ChatToPlayer(tbPlayer.szPlayer)
end

function uiRelation:CmdMail(tbPlayer)
  if me.GetMailBoxLoadOk() == 0 then
    me.Msg("邮件还没有加载完成，请稍后再发！")
    return 0
  end
  local tbParam = {}
  tbParam.szTitle = ""
  tbParam.szSender = tbPlayer.szPlayer
  Mail:RequestOpenNewMail(tbParam)
end

function uiRelation:CmdInviteTeam(tbPlayer)
  me.TeamInvite(0, tbPlayer.szPlayer)
end

function uiRelation:CmdDelFriend(tbPlayer, nPage)
  if nPage == self.PAGE_INDEX_MYGROUP1 then
    return 0
  end
  if tbPlayer.nType == Player.emKPLAYERRELATION_TYPE_BIDFRIEND then
    local tbMsg = {}
    tbMsg.szMsg = "确定删除" .. tbPlayer.szPlayer .. "吗？"
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex, szPlayer, nType)
      if nOptIndex == 2 then
        me.CallServerScript({ "RelationCmd", "DelRelation_C2S", szPlayer, nType })
        me.Msg("删除" .. Player.RELATION_NAME[nType] .. szPlayer .. "。")
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, tbPlayer.szPlayer, tbPlayer.nType)
  elseif tbPlayer.nType == Player.emKPLAYERRELATION_TYPE_GLOBALFRIEND then
    Player.tbGlobalFriends:ApplyDeleteFriend(tbPlayer.szPlayer)
    me.Msg("删除大区好友" .. "[" .. tbPlayer.szPlayer .. "]。")
  else
    for _k, _v in pairs(Player.tbGlobalFriends.tbBlackList) do
      if _v == tbPlayer.szPlayer then
        Player.tbGlobalFriends.tbBlackList[_k] = nil
        Player.tbGlobalFriends:SaveBlackList()
        CoreEventNotify(UiNotify.emCOREEVENT_RELATION_UPDATEPANEL)
        return
      end
    end
    me.CallServerScript({ "RelationCmd", "DelRelation_C2S", tbPlayer.szPlayer, tbPlayer.nType })
    me.Msg("删除" .. Player.RELATION_NAME[tbPlayer.nType] .. "[" .. tbPlayer.szPlayer .. "]。")
  end
end

function uiRelation:CmdDelGroupPlayer(tbPlayer, nPage)
  local tbPage = self.tbPageManager[nPage]
  local nGroupId = tbPage.nGroupId
  if nGroupId <= 0 then
    return 0
  end
  me.Relation_DelRelationGroupPlayer(nGroupId, tbPlayer.szPlayer)
  me.Msg("[" .. tbPlayer.szPlayer .. "]从自定义组中删除。")
end

function uiRelation:CmdApplyTeacher(tbPlayer) end

function uiRelation:CmdApplyStudent(tbPlayer) end

function uiRelation:CmdMoveToMyGroup1(tbPlayer, nPage)
  local tbPage = self.tbPageManager[self.PAGE_INDEX_MYGROUP1]
  local nGroupId = 0
  if not tbPage then
    return
  end

  nGroupId = tbPage.nGroupId
  me.Relation_ApplyAddRelationGroupPlayer(nGroupId, tbPlayer.szPlayer)
end

function uiRelation:CmdCreateNewGroup()
  local nGroupId = 0
  for i = 1, Relation.DEF_MAX_RELATIONGROUP_COUNT do
    local tbInfo = me.Relation_GetRelationGroupList(i)
    if not tbInfo then
      nGroupId = i
      break
    end
  end

  if nGroupId > 0 then
    me.Relation_ApplyCreateRelationGroup(nGroupId)
  end
end

function uiRelation:CmdRenameGroupName(nPage)
  local tbPage = self.tbPageManager[nPage]
  if not tbPage then
    return 0
  end
  local nGroupId = tbPage.nGroupId
  if not nGroupId or nGroupId <= 0 then
    return 0
  end
  me.Relation_ApplyRenameRelationGroup(nGroupId)
end

function uiRelation:CmdDelGroup(nPage)
  local tbPage = self.tbPageManager[nPage]
  if not tbPage then
    return 0
  end
  local nGroupId = tbPage.nGroupId
  if not nGroupId or nGroupId <= 0 then
    return 0
  end
  me.Relation_ApplyDelRelationGroup(nGroupId)
end

--客服好友存在时间
function uiRelation:GetKefuFriend()
  if TimeFrame:GetServerOpenDay() <= 30 then
    return 1
  end
  return 0
end

uiRelation.POPUPMUNE_CALLBACK[uiRelation.MENU_INDEX_MILIAO] = uiRelation.CmdWhisper
uiRelation.POPUPMUNE_CALLBACK[uiRelation.MENU_INDEX_MAIL] = uiRelation.CmdMail
uiRelation.POPUPMUNE_CALLBACK[uiRelation.MENU_INDEX_TEAM] = uiRelation.CmdInviteTeam
uiRelation.POPUPMUNE_CALLBACK[uiRelation.MENU_INDEX_DEL] = uiRelation.CmdDelFriend
uiRelation.POPUPMUNE_CALLBACK[uiRelation.MENU_INDEX_APPLYTEACHER] = uiRelation.CmdApplyTeacher
uiRelation.POPUPMUNE_CALLBACK[uiRelation.MENU_INDEX_APPLYSTDUDENT] = uiRelation.CmdApplyStudent
uiRelation.POPUPMUNE_CALLBACK[uiRelation.MENU_INDEX_CREATE_MYGROUP] = uiRelation.CmdCreateNewGroup
uiRelation.POPUPMUNE_CALLBACK[uiRelation.MENU_INDEX_COPY_MYGROUP1] = uiRelation.CmdMoveToMyGroup1

uiRelation.POPUPMUNE_CALLBACK_EX[uiRelation.MENU_INDEX_MILIAO] = uiRelation.POPUPMUNE_CALLBACK[uiRelation.MENU_INDEX_MILIAO]
uiRelation.POPUPMUNE_CALLBACK_EX[uiRelation.MENU_INDEX_MAIL] = uiRelation.POPUPMUNE_CALLBACK[uiRelation.MENU_INDEX_MAIL]
uiRelation.POPUPMUNE_CALLBACK_EX[uiRelation.MENU_INDEX_TEAM] = uiRelation.POPUPMUNE_CALLBACK[uiRelation.MENU_INDEX_TEAM]
uiRelation.POPUPMUNE_CALLBACK_EX[uiRelation.MENU_INDEX_DEL] = uiRelation.CmdDelGroupPlayer
uiRelation.POPUPMUNE_CALLBACK_EX[uiRelation.MENU_INDEX_APPLYTEACHER] = uiRelation.POPUPMUNE_CALLBACK[uiRelation.MENU_INDEX_APPLYTEACHER]
uiRelation.POPUPMUNE_CALLBACK_EX[uiRelation.MENU_INDEX_APPLYSTDUDENT] = uiRelation.POPUPMUNE_CALLBACK[uiRelation.MENU_INDEX_APPLYSTDUDENT]
uiRelation.POPUPMUNE_CALLBACK_EX[uiRelation.MENU_INDEX_CREATE_MYGROUP] = uiRelation.POPUPMUNE_CALLBACK[uiRelation.MENU_INDEX_CREATE_MYGROUP]
uiRelation.POPUPMUNE_CALLBACK_EX[uiRelation.MENU_INDEX_RENAME] = uiRelation.CmdRenameGroupName
uiRelation.POPUPMUNE_CALLBACK_EX[uiRelation.MENU_INDEX_DELGROUP] = uiRelation.CmdDelGroup

function uiRelation:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_RELATION_UPDATEPANEL, self.UpdateRelationPanel },
    { UiNotify.emCOREEVENT_RELATION_REFRESHTRAIN, self.OnRefreshTraining },
    { UiNotify.emCOREEVENT_RELATION_ONLINE, self.OnRelationOnline },
    { UiNotify.emCOREEVENT_SYNC_PORTRAIT, self.UpdateBasicPortrait },
  }
  return tbRegEvent
end
