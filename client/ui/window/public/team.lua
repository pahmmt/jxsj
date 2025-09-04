-----------------------------------------------------
--文件名		：	team.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-02-06
--功能描述		：	队伍面板。
------------------------------------------------------

local tbSaveData = Ui.tbLogic.tbSaveData
local tbTempData = Ui.tbLogic.tbTempData
local uiTeam = Ui:GetClass("team")

uiTeam.PAGE_SET_MAIN = "PageSetMain"
uiTeam.CLOSE_WINDOW_BUTTON = "BtnClose" -- 关闭窗口按钮
uiTeam.TEAM_MEMBER_PAGE = "PageTeamMember"
uiTeam.TEAM_MEMBER_PAGE_BUTTON = "BtnTeamMemberPage" -- 组队页面按钮
uiTeam.JOIN_TEAM_PAGE_BUTTON = "BtnJoinTeamPage" -- 寻求组队页面按钮
uiTeam.CONSCRIBE_MEMBER_PAGE_BUTTON = "BtnConscribeMemberPage" -- 招募队员页面按钮
uiTeam.MATCH_TEAM_PAGE_BUTTON = "BtnMatchTeamPage" -- 联赛求组页面按钮
uiTeam.LIST_ITEM_NUMBER_PER_PAGE = 6

uiTeam.MENU_ITEM_LIST = { "申请入队", "邀请加入", "离队" }

-- 队伍成员页面
uiTeam.PLAYER_NAME_SIZE = 16
uiTeam.PLAYER_LEVEL_SIZE = 8
uiTeam.PLAYER_FACTION_SIZE = 16
uiTeam.PLAYER_LOCATION_SIZE = 2

uiTeam.TEAM_MEMBER_LIST = "LstTeamMember" -- 队友列表
uiTeam.INVITE_PLAYER_BUTTON = "BtnInvitePlayer" -- 邀请加入按钮
uiTeam.KICK_MEMBER_BUTTON = "BtnKickMember" -- 踢出队伍按钮
uiTeam.CHANGE_LEADER_BUTTON = "BtnChangeLeader" -- 队长移交按钮
uiTeam.QUIT_TEAM_BUTTON = "BtnQuitTeam" -- 离开队伍按钮
uiTeam.BTN_CREATE_TEAM = "BtnCreateTeam" -- 刷新队员列表按钮

uiTeam.NEARBY_PLAYER_LIST = "LstAroundPlayer" -- 附近玩家列表
uiTeam.UPDATE_PLAYER_LIST_BUTTON = "BtnUpdatePlayerList" -- 更新附近玩家列表按钮
uiTeam.BTN_TEAM_LINK = "BtnTeamLink"
uiTeam.BTN_AUTO_TEAM = "BtnAutoTeam"
uiTeam.DATA_KEY = "GameTeamConfig"
uiTeam.BTN_DISABLE_TEAM = "BtnDisableTeam"

uiTeam.TEAM_ALLOT_BUTTON_TABLE = {
  "BtnTeamAllot", -- 队伍共享分配方式按钮
  "BtnPersonalAllot", -- 个人保护分配方式按钮
}

-- 寻求组队页面
uiTeam.JOIN_PLAYER_NAME_SIZE = 16
uiTeam.JOIN_PLAYER_LEVEL_SIZE = 8
uiTeam.JOIN_PLAYER_FACTION_SIZE = 16
uiTeam.JOIN_PLAYER_LOCATION_SIZE = 16
uiTeam.WANT_JOIN_TEAM_BUTTON = "BtnWantJoinTeam" -- 我要寻求组队按钮
uiTeam.JOIN_TEAM_TEXT = "EdtJoinTeamText" -- 寻求组队文本信息
uiTeam.UPDATE_JOIN_TEXT = "BtnUpdateJoinText" -- 更新寻求组队文本按钮
uiTeam.JOIN_TEAM_PALYER_LIST = "LstJoinTeamPlayer" -- 寻求组队列表
uiTeam.UPDATE_JOIN_LIST = "BtnUpdateJoinPlayerList" -- 更新组队列表按钮
uiTeam.INVITE_JOIN_BUTTON = "BtnInviteJoin" -- 邀请加入
uiTeam.JOIN_TEAM_PREVIOUS_VIEW = "BtnJoinPlayerPreviousView" -- 上一页
uiTeam.JOIN_TEAM_NEXT_VIEW = "BtnJoinPlayerNextView" -- 下一页
uiTeam.JOINTEAM_SCROLLBAR = "SclJoinTeamPlayer" -- 组队列表滚动条
uiTeam.JOIN_PLAYER_PAGE_NUM = "TxtJoinPlayerPageNum" -- 列表当前页码

-- 招募成员页面
uiTeam.WANT_CONSCRIBE_BUTTON = "BtnWantConscribe" -- 我要招募成员按钮
uiTeam.LEVEL_MIN_EDIT = "EdtLevelMin" -- 最低等级限制
uiTeam.LEVEL_MAX_EDIT = "EdtLevelMax" -- 最高等级限制
uiTeam.CHECK_LEVEL_LIMIT = "BtnConscribeUnlimit" -- 招募无等级限制
uiTeam.UPDATE_LEVEL_BUTTON = "BtnUpdateLevel" -- 更新等级限制
uiTeam.CONSCRIBE_TEXT_EDIT = "EdtConscribeTxet" -- 招募的广告文本
uiTeam.UPDATE_CONSCRIBE_TEXT_BUTTON = "BtnUpdateConscribeText" -- 更新招募文本
uiTeam.UPDATE_CONSCRIBE = "BtnUpdateConscribe" -- 更新招募信息
uiTeam.JOIN_CONSCRIBE = "BtnJoinConscribe" -- 申请加入

uiTeam.CONSCRIBE_NAME_SIZE = 16
uiTeam.CONSCRIBE_LEVEL_SIZE = 8
uiTeam.CONSCRIBE_FACTION_SIZE = 16
uiTeam.CONSCRIBE_LOCATION_SIZE = 8

uiTeam.FACTION_LIST = {
  { "BtnTongSL", Player.FACTION_SHAOLIN }, --	少林
  { "BtnTongTW", Player.FACTION_TIANWANG }, --	天王
  { "BtnTongTM", Player.FACTION_TANGMEN }, --	唐门
  { "BtnTongWDU", Player.FACTION_WUDU }, --	五毒
  { "BtnTongEM", Player.FACTION_EMEI }, --	峨眉
  { "BtnTongCY", Player.FACTION_CUIYAN }, --	翠烟
  { "BtnTongGB", Player.FACTION_GAIBANG }, --	丐帮
  { "BtnTongTR", Player.FACTION_TIANREN }, --	天忍
  { "BtnTongWD", Player.FACTION_WUDANG }, --	武当
  { "BtnTongKL", Player.FACTION_KUNLUN }, -- 昆仑
  { "BtnTongMJ", Player.FACTION_MINGJIAO }, -- 明教
  { "BtnTongDS", Player.FACTION_DUANSHI }, -- 段式
}

uiTeam.FACTION_SHORT_NAME = {
  [Player.FACTION_NONE] = "无",
  [Player.FACTION_SHAOLIN] = "少",
  [Player.FACTION_TIANWANG] = "王",
  [Player.FACTION_TANGMEN] = "唐",
  [Player.FACTION_WUDU] = "毒",
  [Player.FACTION_EMEI] = "峨",
  [Player.FACTION_CUIYAN] = "烟",
  [Player.FACTION_GAIBANG] = "丐",
  [Player.FACTION_TIANREN] = "忍",
  [Player.FACTION_WUDANG] = "武",
  [Player.FACTION_KUNLUN] = "昆",
  [Player.FACTION_MINGJIAO] = "明",
  [Player.FACTION_DUANSHI] = "段",
}

uiTeam.CONSCRIBE_MEMBER_LIST = "LstConscribeMember" -- 招募成员列表
uiTeam.UPDATE_CONDCRIBE_LIST_BUTTON = "BtnUpdateConscribeList" -- 更新招募成员的列表
uiTeam.CONSCRIBE_PREVIOUS_VIEW = "BtnConscribePreviousView" -- 上一页
uiTeam.CONSCRIBE_NEXT_VIEW = "BtnConscribeNextView" -- 下一页
uiTeam.CONSCRIBE_SCROLLBAR = "SclConscribePlayer" -- 招募成员列表的滚动条
uiTeam.CONSCRIBE_LIST_PAGE_NUM = "TxtConscribePageNum" -- 当前页码
uiTeam.CONSCRIBE_ADDTEAMMATE = "BtnAddTeamMate" -- 添加队友

-- 联赛求组页面
uiTeam.WANT_JOIN_MATCH_BUTTON = "BtnWantJoinMatch" -- 我要联赛求组按钮
uiTeam.JOIN_MATCH_TEXT = "EdtMacthTeamText" -- 求组的宣传文字
uiTeam.UPDATE_JOIN_MATCH_TEXT_BUTTON = "BtnUpdateMatchText" -- 更新求组文字按钮
uiTeam.MATCH_TEAM_LIST = "LstMatchTeamPlayer" -- 联赛队伍列表
uiTeam.UPDATE_MATCH_TEAM_LIST_BUTTON = "BtnUpdateMatchPlayerList" -- 更新联赛队伍列表按钮
uiTeam.MATCH_TEAM_PREVIOUS_VIEW = "BtnMatchPlayerPreviousView" -- 上一页
uiTeam.MATCH_TEAM_NEXT_VIEW = "BtnMatchPlayerNextView" -- 下一页
uiTeam.MATCH_TEAM_SCROLLBAR = "SclMatchTeamPlayer" -- 滚动条
uiTeam.MATCH_TEAM_PAGE_NUM = "TxtMatchPlayerPageNum" -- 当前页码

uiTeam.KTEAM_SEARCH_JOIN = 0 -- 寻求
uiTeam.KTEAM_SEARCH_INVITE = 1 -- 招募
uiTeam.KTEAM_SEARCH_LEAGUE = 2 -- 联赛求组

uiTeam.KTEAM_SEARCH_SORTBYNAME = 0 -- 以姓名排序
uiTeam.KTEAM_SEARCH_SORTBYLEVEL = 1 -- 以等级排序
uiTeam.KTEAM_SEARCH_SORTBYFACTION = 2 -- 以门派排序
uiTeam.KTEAM_SEARCH_SORTBYMAP = 3 -- 以地图排序

uiTeam.SORT_BUTTON = {
  { "BtnSort1_1", "BtnSort1_2", "BtnSort1_3", "BtnSort1_4" },
  { "BtnSort2_1", "BtnSort2_2", "BtnSort2_3", "BtnSort2_4" },
  { "BtnSort3_1", "BtnSort3_2", "BtnSort3_3", "BtnSort3_4" },
  { "BtnSort4_1", "BtnSort4_2", "BtnSort4_3", "BtnSort4_4" },
}

uiTeam.MINLEVEL = 1
uiTeam.MAXLEVEL = 150

function uiTeam:Init()
  self.m_tbTeamConfig = {}
  self.m_tbTeamConfig.nAutoAcceptTeam = 0
  self.tbData = {
    NearbyPlayer = { nCurPageNum = 1, nCurSortType = 1 },
    JoinPlayer = { nCurPageNum = 1, nCurSortType = 1 },
    ConscribePlayer = { nCurPageNum = 1, nCurSortType = 1 },
    MatchPlayer = { nCurPageNum = 1, nCurSortType = 1 },
    tbNearbyPlayer = {},
  }
  self.bReverscSort = 0 -- 反序排序
  self.nLastX = 0
  self.nLastY = 0
  self.bDisable = 0
  self.nDisableTeam = 0
  self.tbIdToIndex = {} -- 附近玩家Id与Index的映射表

  tbSaveData:RegistLoadCallback(self.LoadConfig, self)
end

function uiTeam:CopyTable(tbA, tbB, nCount)
  nCount = nCount or 0
  if nCount > 1000 then
    return
  end
  for k, v in pairs(tbB) do
    if type(v) == "table" then
      tbA[k] = {}
      self:CopyTable(tbA[k], tbB[k], nCount + 1)
    else
      tbA[k] = v
    end
  end
end

function uiTeam:LoadConfig()
  local tbOption = tbSaveData:Load(self.DATA_KEY)
  self:CopyTable(self.m_tbTeamConfig, tbOption)

  if not self.m_tbTeamConfig.nAutoAcceptTeam then
    self.m_tbTeamConfig.nAutoAcceptTeam = 0
  end
  tbTempData.nAutoTeamFlag = self.m_tbTeamConfig.nAutoAcceptTeam
  self.nDisableTeam = tbTempData.nDisableTeam
  -- self.nDisableTeacher = me.GetTask(TASK_TEACHER_GROUP, TASK_TEACHER_ID);
end

function uiTeam:SetDisableTeam(nState)
  if tbTempData.nDisableTeam == nState then
    return
  end
  tbTempData.nDisableTeam = nState
  Btn_Check(self.UIGROUP, self.BTN_DISABLE_TEAM, tbTempData.nDisableTeam)
  if 1 == nState then
    me.Msg("您已开启屏蔽组队请求。")
  else
    me.Msg("您已恢复接受组队请求。")
  end
end

--写log
function uiTeam:WriteStatLog()
  Log:Ui_SendLog("P组队界面", 1)
end

function uiTeam:OnOpen(bActivateAutoTeamTab)
  self:WriteStatLog()
  self:LoadConfig()
  Ui(Ui.UI_SIDEBAR):WndOpenCloseCallback(self.UIGROUP, 1)
  PgSet_ActivePage(self.UIGROUP, self.PAGE_SET_MAIN, self.TEAM_MEMBER_PAGE)
  local tbTemp = me.GetTempTable("Relation")
  if tbTemp.Team_Table and tbTemp.Team_Table.bDisable then
    self.bDisable = tbTemp.Team_Table.bDisable
  end
  self:FixUI()
  self:UpdateTeamInfo()
  self:UpdateNearbyPlayerInfo()

  --自动组队
  --self:RefreshAutoTeam();

  --if bActivateAutoTeamTab == 1 then
  --	self:ShowAutoTeamPage();
  --end
end

function uiTeam:OnClose()
  tbSaveData:Save(self.DATA_KEY, self.m_tbTeamConfig)
  self:SetDisableTeam(self.nDisableTeam)
  Ui(Ui.UI_SIDEBAR):WndOpenCloseCallback(self.UIGROUP, 0)
end

--------------------------------------------------------------
-- 回调
function uiTeam:TeamInfoChangedCallback()
  self:UpdateTeamInfo()
  self:UpdateNearbyPlayerInfo()
end

function uiTeam:TeamAllotModelChangedCallback(nShareFlag)
  self:UpdateTeamAllotModel(nShareFlag)
end

function uiTeam:TeamSearchInfoUpdateCallback(nSearchType, nSortType, nPage, bHaveNextPage)
  if nSearchType == self.KTEAM_SEARCH_JOIN then
    self.tbData.JoinPlayer.nCurPageNum = nPage
    self.tbData.JoinPlayer.bHaveNextPage = bHaveNextPage

    self:UpdateJoinTeamList()
  elseif nSearchType == self.KTEAM_SEARCH_INVITE then
    self.tbData.ConscribePlayer.nCurPageNum = nPage
    self.tbData.ConscribePlayer.bHaveNextPage = bHaveNextPage

    self:UpdateConscribeList()
  elseif nSearchType == self.KTEAM_SEARCH_LEAGUE then
    self.tbData.MatchPlayer.nCurPageNum = nPage
    self.tbData.MatchPlayer.bHaveNextPage = bHaveNextPage

    self:UpdateMatchTeamList()
  end
end

function uiTeam:AddTeamMateByName(szName)
  if szName == me.szName then
    me.Msg("你已经在队伍中。")
    return
  end

  if IsValidRoleName(szName) == 0 then
    me.Msg("输入的名字不符合规范。")
  else
    me.TeamInvite(0, szName)
  end
end

function uiTeam:IsTeamLeader()
  local nAllotModel, tbMemberList = me.GetTeamInfo()
  if nAllotModel and tbMemberList then
    local tLeader = tbMemberList[1]
    if tLeader.szName == me.szName then
      return 1
    end
  end
  return 0
end

-- 响应按钮点击事件
function uiTeam:OnButtonClick(szWndName, nParam)
  if szWndName == self.CLOSE_WINDOW_BUTTON then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWndName == self.INVITE_PLAYER_BUTTON then
    self:InviteNearbyPlayer()
  elseif szWndName == self.QUIT_TEAM_BUTTON then
    me.TeamLeave()
  elseif szWndName == self.CHANGE_LEADER_BUTTON then
    self:ChangeLeader()
  elseif szWndName == self.KICK_MEMBER_BUTTON then
    self:KickTeamMember()
  elseif szWndName == self.BTN_CREATE_TEAM then
    me.CreateTeam()
  elseif szWndName == self.UPDATE_PLAYER_LIST_BUTTON then
    self:UpdateNearbyPlayerInfo()
  elseif szWndName == self.QUIT_TEAM_BUTTON then
    self:OnQuitTeam()

  -- 寻求组队
  elseif szWndName == self.JOIN_TEAM_PAGE_BUTTON then
    Wnd_SetFocus(self.UIGROUP, self.JOIN_TEAM_TEXT)
    self:UpdateJoinTeamList()
  elseif szWndName == self.WANT_JOIN_TEAM_BUTTON then
    self:SearchTeamToJoin(nParam)
  elseif szWndName == self.UPDATE_JOIN_TEXT then
    local nEnable = Btn_GetCheck(self.UIGROUP, self.WANT_JOIN_TEAM_BUTTON)
    if nEnable > 0 then
      self:SearchTeamToJoin(1)
    end
  elseif szWndName == self.UPDATE_JOIN_LIST then
    self:RefreshJoinTeamList()
  elseif szWndName == self.JOIN_TEAM_PREVIOUS_VIEW then
    self.tbData.JoinPlayer.nCurPageNum = self.tbData.JoinPlayer.nCurPageNum - 1
    self.tbData.JoinPlayer.bHaveNextPage = 1
    self:UpdateJoinTeamList()
  elseif szWndName == self.JOIN_TEAM_NEXT_VIEW then
    self.tbData.JoinPlayer.nCurPageNum = self.tbData.JoinPlayer.nCurPageNum + 1
    self:UpdateJoinTeamList()
  elseif szWndName == self.INVITE_JOIN_BUTTON then
    local nListIndex = Lst_GetCurKey(self.UIGROUP, self.JOIN_TEAM_PALYER_LIST)
    if nListIndex and nListIndex >= 0 then
      self:OnMenuItemSelected(self.JOIN_TEAM_PALYER_LIST, 2, nListIndex)
    end

  -- 招募成员
  elseif szWndName == self.CONSCRIBE_MEMBER_PAGE_BUTTON then
    Wnd_SetFocus(self.UIGROUP, self.CONSCRIBE_TEXT_EDIT)
    me.SyncSelfSearchInfo(self.KTEAM_SEARCH_INVITE)
    self:UpdateConscribeList()
  elseif szWndName == self.WANT_CONSCRIBE_BUTTON then
    self:SearchConscribe(nParam)
  elseif szWndName == self.UPDATE_CONSCRIBE or szWndName == self.UPDATE_LEVEL_BUTTON then
    local nEnable = Btn_GetCheck(self.UIGROUP, self.WANT_CONSCRIBE_BUTTON)
    if nEnable > 0 then
      self:SearchConscribe(1)
    end
  elseif szWndName == self.UPDATE_CONDCRIBE_LIST_BUTTON then
    self:RefreshConscribeList()
  elseif szWndName == self.CONSCRIBE_PREVIOUS_VIEW then
    self.tbData.ConscribePlayer.nCurPageNum = self.tbData.ConscribePlayer.nCurPageNum - 1
    self.tbData.ConscribePlayer.bHaveNextPage = 1
    self:UpdateConscribeList()
  elseif szWndName == self.CONSCRIBE_ADDTEAMMATE then
    if self:IsTeamLeader() == 1 then
      local tbParam = {}
      tbParam.tbTable = self
      tbParam.fnAccept = self.AddTeamMateByName
      tbParam.nType = 2
      tbParam.szTitle = "输入名字邀请组队"
      UiManager:OpenWindow(Ui.UI_TEXTINPUT, tbParam)
    else
      me.Msg("只有队长才可以邀请他人加入队伍！")
    end
  elseif szWndName == self.CONSCRIBE_NEXT_VIEW then
    self.tbData.ConscribePlayer.nCurPageNum = self.tbData.ConscribePlayer.nCurPageNum + 1
    self:UpdateConscribeList()
  elseif szWndName == self.JOIN_CONSCRIBE then
    local nListIndex = Lst_GetCurKey(self.UIGROUP, self.CONSCRIBE_MEMBER_LIST)
    if nListIndex < 0 then
      return 0
    end
    self:OnMenuItemSelected(self.CONSCRIBE_MEMBER_LIST, 1, nListIndex)

  -- 联赛求组
  elseif szWndName == self.MATCH_TEAM_PAGE_BUTTON then
    Wnd_SetFocus(self.UIGROUP, self.CONSCRIBE_TEXT_EDIT)
    self:UpdateMatchTeamList()
  elseif szWndName == self.WANT_JOIN_MATCH_BUTTON then
    self:SearchMatch(nParam)
  elseif szWndName == self.UPDATE_JOIN_MATCH_TEXT_BUTTON then
    local nEnable = Btn_GetCheck(self.UIGROUP, self.WANT_JOIN_MATCH_BUTTON)
    if nEnable > 0 then
      self:SearchMatch(1)
    end
  elseif szWndName == self.UPDATE_MATCH_TEAM_LIST_BUTTON then
    self:RefreshMatchTeamList()
  elseif szWndName == self.MATCH_TEAM_PREVIOUS_VIEW then
    self.tbData.MatchPlayer.nCurPageNum = self.tbData.MatchPlayer.nCurPageNum - 1
    self.tbData.MatchPlayer.bHaveNextPage = 1
    self:UpdateMatchTeamList()
  elseif szWndName == self.MATCH_TEAM_NEXT_VIEW then
    self.tbData.MatchPlayer.nCurPageNum = self.tbData.MatchPlayer.nCurPageNum + 1
    self:UpdateMatchTeamList()

  -- 自动组队
  --elseif szWndName == self.BUTTON_JOIN_AUTOTEAM then
  --	self:JoinAutoTeam();
  --elseif szWndName == self.BUTTON_LEAVE_AUTOTEAM then
  --	self:LeaveAutoTeam();
  elseif szWndName == self.BTN_TEAM_LINK then
    self:AnnounceTeamLink()
  elseif szWndName == self.BTN_AUTO_TEAM then
    self.m_tbTeamConfig.nAutoAcceptTeam = nParam
    tbTempData.nAutoTeamFlag = self.m_tbTeamConfig.nAutoAcceptTeam
  elseif szWndName == self.BTN_DISABLE_TEAM then
    self.nDisableTeam = nParam
    self:SetDisableTeam(self.nDisableTeam)
  else
    self:ChangeSortType(szWndName)
  end
end

function uiTeam:AnnounceTeamLink()
  if not me.nTeamId or me.nTeamId <= 0 then
    me.Msg("您没有队伍无法发布招募链接！")
    return 0
  end
  local szText = "<#申请入队#>"
  InsertChatMsg(szText)
end

function uiTeam:OnListOver(szWndName, nItemIndex)
  if not szWndName or not nItemIndex or nItemIndex < 0 then
    return
  end
  local nItemData, szName = self:GetTeamListDataByIndex(szWndName, nItemIndex)
  if nItemData < 1 then
    return
  end

  if szWndName == self.TEAM_MEMBER_LIST then
    -- 暂无
  elseif szWndName == self.NEARBY_PLAYER_LIST then
    -- 暂无
  elseif szWndName == self.JOIN_TEAM_PALYER_LIST then
    for i = 1, #self.tbData.JoinPlayer.tbList do
      if self.tbData.JoinPlayer.tbList[i].nPlayerID == nItemData then
        local szTip = self:GetJoinTeamTipFormatedString(self.tbData.JoinPlayer.tbList[i])
        Wnd_SetTip(self.UIGROUP, szWndName, szTip)
      end
    end
  elseif szWndName == self.CONSCRIBE_MEMBER_LIST then
    for i = 1, #self.tbData.ConscribePlayer.tbList do
      if self.tbData.ConscribePlayer.tbList[i].nPlayerID == nItemData then
        local szTip = self:GetConscribeTipFormatedString(self.tbData.ConscribePlayer.tbList[i])
        Wnd_SetTip(self.UIGROUP, szWndName, szTip)
      end
    end
  elseif szWndName == self.MATCH_TEAM_LIST then
    -- 暂无
  end
end

function uiTeam:OnMenuItemSelected(szWndName, nItemId, nListIndex)
  local nItemData, szName = self:GetTeamListDataByIndex(szWndName, nListIndex)
  if nItemData < 1 then
    return
  end
  if nItemId == 1 then
    me.TeamApply(nItemData, szName)
  elseif nItemId == 2 then
    me.TeamInvite(nItemData, szName)
  elseif nItemId == 3 then
    Ui:Output("[INF]  (" .. szName .. ")离队  " .. nItemId)
  end
end

function uiTeam:OnListRClick(szWndName, nParam)
  local nIndex = self.tbIdToIndex[nParam]
  local nItemData, szName = self:GetTeamListDataByIndex(szWndName, nParam)
  if nItemData < 1 then
    return
  end

  if szWndName == self.TEAM_MEMBER_LIST then
    -- 暂无
  elseif szWndName == self.NEARBY_PLAYER_LIST then
  --		Lst_SetCurKey(self.UIGROUP, szWndName, nIndex);
  --		DisplayPopupMenu(self.UIGROUP, szWndName, 1, nIndex, self.MENU_ITEM_LIST[2], 2);
  elseif szWndName == self.JOIN_TEAM_PALYER_LIST then
    -- 如果是自己不弹菜单
    if szName == me.szName then
      return
    end
    DisplayPopupMenu(self.UIGROUP, szWndName, 1, nParam, self.MENU_ITEM_LIST[2], 2)
  elseif szWndName == self.CONSCRIBE_MEMBER_LIST then
    local nAllotModel, tbMemberList = me.GetTeamInfo()
    if tbMemberList ~= nil then
      me.Msg("你已经加入队伍, 不能申请入队!")
      return
    end
    DisplayPopupMenu(self.UIGROUP, szWndName, 1, nParam, self.MENU_ITEM_LIST[1], 1)
  elseif szWndName == self.MATCH_TEAM_LIST then
    DisplayPopupMenu(self.UIGROUP, szWndName, 1, nParam, self.MENU_ITEM_LIST[2], 2)
  end
end

-- 更新队友数据及界面
function uiTeam:UpdateTeamInfo()
  Lst_Clear(self.UIGROUP, self.TEAM_MEMBER_LIST)
  local nEnable
  if self.bDisable ~= 0 then
    nEnable = 0
  else
    nEnable = 1
  end

  Wnd_SetEnable(self.UIGROUP, self.TEAM_MEMBER_PAGE_BUTTON, nEnable)
  Wnd_SetEnable(self.UIGROUP, self.JOIN_TEAM_PAGE_BUTTON, nEnable)
  Wnd_SetEnable(self.UIGROUP, self.CONSCRIBE_MEMBER_PAGE_BUTTON, nEnable)
  Wnd_SetEnable(self.UIGROUP, self.BTN_CREATE_TEAM, nEnable)

  -- 设置按钮状态
  Wnd_SetEnable(self.UIGROUP, self.BTN_CREATE_TEAM, nEnable)
  Wnd_SetEnable(self.UIGROUP, self.KICK_MEMBER_BUTTON, 0)
  Wnd_SetEnable(self.UIGROUP, self.CHANGE_LEADER_BUTTON, 0)
  Wnd_SetEnable(self.UIGROUP, self.QUIT_TEAM_BUTTON, 0)
  Wnd_SetEnable(self.UIGROUP, self.INVITE_PLAYER_BUTTON, nEnable)

  local nAllotModel, tbMemberList = me.GetTeamInfo()
  self:UpdateTeamAllotModel(nAllotModel)

  Btn_Check(self.UIGROUP, self.BTN_AUTO_TEAM, tonumber(self.m_tbTeamConfig.nAutoAcceptTeam) or 0)
  Btn_Check(self.UIGROUP, self.BTN_DISABLE_TEAM, self.nDisableTeam)
  --Wnd_SetEnable(self.UIGROUP, self.BTN_AUTO_TEAM, 0);
  Wnd_SetEnable(self.UIGROUP, self.BTN_TEAM_LINK, 0)

  if not tbMemberList then
    return
  end

  if me.nTeamId > 0 then
    if self:IsTeamLeader() == 1 then
      Wnd_SetEnable(self.UIGROUP, self.BTN_AUTO_TEAM, 1)
    end
    if #tbMemberList < 6 then
      Wnd_SetEnable(self.UIGROUP, self.BTN_TEAM_LINK, 1)
    end
  end

  -- 更新按钮状态
  Wnd_SetEnable(self.UIGROUP, self.BTN_CREATE_TEAM, 0)
  Wnd_SetEnable(self.UIGROUP, self.QUIT_TEAM_BUTTON, nEnable)
  Wnd_SetEnable(self.UIGROUP, self.INVITE_PLAYER_BUTTON, 0)

  for i = 1, #tbMemberList do
    if tbMemberList[i].szName and tbMemberList[i].nPlayerID then
      local szBuf = tbMemberList[i].szName .. " "
      if tbMemberList[i].nLeader == 1 then
        szBuf = szBuf .. "(队长)"
        if tbMemberList[i].szName == me.szName then
          local nCurSel = Lst_GetCurKey(self.UIGROUP, self.TEAM_MEMBER_LIST)
          if nCurSel == 0 then
            Wnd_SetEnable(self.UIGROUP, self.KICK_MEMBER_BUTTON, 0)
            Wnd_SetEnable(self.UIGROUP, self.CHANGE_LEADER_BUTTON, 0)
          else
            Wnd_SetEnable(self.UIGROUP, self.KICK_MEMBER_BUTTON, nEnable)
            Wnd_SetEnable(self.UIGROUP, self.CHANGE_LEADER_BUTTON, nEnable)
          end
          Wnd_SetEnable(self.UIGROUP, self.INVITE_PLAYER_BUTTON, nEnable)
        end
      end
      Lst_SetCell(self.UIGROUP, self.TEAM_MEMBER_LIST, i, 1, szBuf)
      Lst_SetLineData(self.UIGROUP, self.TEAM_MEMBER_LIST, i, tbMemberList[i].nPlayerID)
      Lst_SetCell(self.UIGROUP, self.TEAM_MEMBER_LIST, i, 2, string.format("%s级", tbMemberList[i].nLevel))
    end
  end
end

function uiTeam:InviteNearbyPlayer()
  local nId = Lst_GetCurKey(self.UIGROUP, self.NEARBY_PLAYER_LIST)
  if not nId or nId == 0 then
    return
  end
  local nIndex = self.tbIdToIndex[nId]
  local tbPlayer = self.tbData.tbNearbyPlayer[nIndex]
  if tbPlayer.nCaptainFlag == 1 then
    me.TeamApply(nId, tbPlayer.szName)
  else
    me.TeamInvite(nId, tbPlayer.szName)
  end
end

-- 移交队长
function uiTeam:ChangeLeader()
  local nPlayerID, szName = self:GetTeamListSelectedData(self.TEAM_MEMBER_LIST)
  if nPlayerID and szName then
    me.TeamAppoint(nPlayerID)
  end
end

function uiTeam:KickTeamMember()
  local nPlayerID, szName = self:GetTeamListSelectedData(self.TEAM_MEMBER_LIST)
  if nPlayerID and szName then
    me.TeamKick(nPlayerID)
  end
end

local function _OnSortA(tbA, tbB)
  if tbA.nRank ~= tbB.nRank then
    return tbA.nRank < tbB.nRank
  end
  return tbA.nTeamNum < tbB.nTeamNum
end

function uiTeam:GetNearTeamInfo()
  local tbNearTeam = me.GetNearTeamInfobyPlayer()
  local nAllotModel, tbMemberList = me.GetTeamInfo()
  local tbSearchList = {}

  if not tbNearTeam then
    return
  end

  if tbMemberList then
    for i, tbInfo in pairs(tbMemberList) do
      tbSearchList[tbInfo.szName] = 1
    end
  end

  local tbSortTeam = {}
  for i, tbInfo in pairs(tbNearTeam) do
    if not tbSearchList[tbInfo.szName] then
      if tbInfo.nTeamNum > 0 then
        if tbInfo.nCaptainFlag == 1 then
          tbInfo.nRank = 1
        else
          tbInfo.nRank = 3
        end
      else
        tbInfo.nRank = 2
      end

      tbSortTeam[#tbSortTeam + 1] = tbInfo
    end
  end
  table.sort(tbSortTeam, _OnSortA)

  --	tbNearTeam = {};
  --	for i=1, 100 do
  --		local tbInfo = {};
  --		tbInfo.szName = "我是谁" .. i;
  --		tbInfo.nPlayerID = i;
  --		tbInfo.nLevel = 100;
  --		tbInfo.nFaction = 1;
  --		tbInfo.nCaptainFlag = 1;
  --		tbInfo.nTeamNum = 6;
  --		table.insert(tbNearTeam, tbInfo);
  --	end

  return tbSortTeam
end

-- 更新附近玩家数据
function uiTeam:UpdateNearbyPlayerInfo()
  if self.tbData.NearbyPlayer.nCurPageNum < 1 then
    self.tbData.NearbyPlayer.nCurPageNum = 1
  end

  Lst_Clear(self.UIGROUP, self.NEARBY_PLAYER_LIST)
  self.tbData.tbNearbyPlayer = self:GetNearTeamInfo()
  if not self.tbData.tbNearbyPlayer then
    self.tbData.NearbyPlayer.nCurPageNum = 1
    return
  end

  for i = 1, #self.tbData.tbNearbyPlayer do
    if self.tbData.tbNearbyPlayer[i].szName and self.tbData.tbNearbyPlayer[i].nPlayerID then
      local nId = self.tbData.tbNearbyPlayer[i].nPlayerID
      self.tbIdToIndex[nId] = i --	记录映射
      Lst_SetCell(self.UIGROUP, self.NEARBY_PLAYER_LIST, nId, 0, i)
      Lst_SetCell(self.UIGROUP, self.NEARBY_PLAYER_LIST, nId, 1, self.tbData.tbNearbyPlayer[i].szName .. " ")
      Lst_SetCell(self.UIGROUP, self.NEARBY_PLAYER_LIST, nId, 2, self.tbData.tbNearbyPlayer[i].nLevel .. "级")
      Lst_SetCell(self.UIGROUP, self.NEARBY_PLAYER_LIST, nId, 3, Player:GetFactionRouteName(self.tbData.tbNearbyPlayer[i].nFaction))
      local szState = "未组队"
      if self.tbData.tbNearbyPlayer[i].nTeamNum > 0 then
        szState = "在队伍中"
        if self.tbData.tbNearbyPlayer[i].nCaptainFlag == 1 then
          szState = string.format("队长(%s/6)", self.tbData.tbNearbyPlayer[i].nTeamNum)
        end
      end
      local nRank = self.tbData.tbNearbyPlayer[i].nRank
      Lst_SetCell(self.UIGROUP, self.NEARBY_PLAYER_LIST, nId, 4, szState)
      if nRank then
        if nRank == 1 then -- 队长
          Lst_SetLineColor(self.UIGROUP, self.NEARBY_PLAYER_LIST, nId, 0xFFDFCBB7)
        elseif nRank == 2 then -- 未组队
          Lst_SetLineColor(self.UIGROUP, self.NEARBY_PLAYER_LIST, nId, 0xFFFFFFFF)
        elseif nRank == 3 then -- 有队不是队长
          Lst_SetLineColor(self.UIGROUP, self.NEARBY_PLAYER_LIST, nId, 0xFFB5B0A7)
        end
      end
    end
  end
end

-- 生成显示附近玩家列表的格式化字符串
function uiTeam:GetPlayerFormatedString(tbPlayer)
  if (not tbPlayer) or not tbPlayer.szName or not tbPlayer.nLevel or not tbPlayer.nFaction then
    return
  end

  local szName = self:FormatStringByLength(tbPlayer.szName, self.PLAYER_NAME_SIZE)
  local szLevel = self:FormatStringByLength(tostring(tbPlayer.nLevel), self.PLAYER_LEVEL_SIZE, 1)
  local szFaction = self:FormatStringByLength(Player:GetFactionRouteName(tbPlayer.nFaction), self.PLAYER_FACTION_SIZE)

  return szName .. " " .. szLevel .. " " .. szFaction
end

-- 设置队伍物品分配方式
function uiTeam:UpdateTeamAllotModel(nShareFlag) end

function uiTeam:GetTeamListSelectedData(szWnd)
  local nIndex = Lst_GetCurKey(self.UIGROUP, szWnd)
  local nItemData, szName = self:GetTeamListDataByIndex(szWnd, nIndex)
  return nItemData, szName
end

function uiTeam:GetTeamListDataByIndex(szWnd, nIndex)
  if (not nIndex) or (nIndex < 0) then
    return
  end
  local szString = Lst_GetCell(self.UIGROUP, szWnd, nIndex, 1)

  if (not szString) or (szString == "") then
    return 0
  end
  local nItemData = Lst_GetLineData(self.UIGROUP, szWnd, nIndex)
  local nOffset, _ = string.find(szString, " ")
  if not nOffset then
    return 0
  end
  local szName = string.sub(szString, 1, nOffset - 1)

  return nItemData, szName
end

-- 寻求组队页面
function uiTeam:SearchTeamToJoin(nEnable)
  if nEnable > 0 then
    local nMsg = Edt_GetTxt(self.UIGROUP, self.JOIN_TEAM_TEXT)
    if #nMsg > 0 then
      local nRet = me.SendTeamSearchInfo(self.KTEAM_SEARCH_JOIN, nMsg)
      if nRet == 0 then
        Btn_Check(self.UIGROUP, self.WANT_JOIN_TEAM_BUTTON, 0)
      else
        Btn_Check(self.UIGROUP, self.WANT_JOIN_TEAM_BUTTON, 1)
      end
    else
      me.Msg("请填写寻求组队信息!")
      Btn_Check(self.UIGROUP, self.WANT_JOIN_TEAM_BUTTON, 0)
    end
  else
    me.CancelTeamSearch(self.KTEAM_SEARCH_JOIN)
  end
end

-- 更新寻求组队信息
function uiTeam:UpdateJoinTeamList()
  me.SyncSelfSearchInfo(self.KTEAM_SEARCH_JOIN)

  if self.tbData.JoinPlayer.nCurPageNum < 1 then
    self.tbData.JoinPlayer.nCurPageNum = 1
  end

  Txt_SetTxt(self.UIGROUP, self.JOIN_PLAYER_PAGE_NUM, self.tbData.JoinPlayer.nCurPageNum)

  Lst_Clear(self.UIGROUP, self.JOIN_TEAM_PALYER_LIST)

  local tbInfoList = me.GetTeamSearchInfoList(0, self.KTEAM_SEARCH_JOIN, self.tbData.JoinPlayer.nCurSortType, self.tbData.JoinPlayer.nCurPageNum, self.bReverscSort)

  if tbInfoList == nil then
    if self.tbData.JoinPlayer.nCurPageNum > 1 then
      self.tbData.JoinPlayer.nCurPageNum = self.tbData.JoinPlayer.nCurPageNum - 1
      Wnd_SetEnable(self.UIGROUP, self.JOIN_TEAM_NEXT_VIEW, 0)
      self:UpdateJoinTeamList()
    end
    return
  else
    self.tbData.JoinPlayer.tbList = tbInfoList
  end

  for i = 1, #tbInfoList do
    local szPlayerInfo = self:GetJoinTeamFormatedString(tbInfoList[i])
    if szPlayerInfo then
      Lst_SetCell(self.UIGROUP, self.JOIN_TEAM_PALYER_LIST, i, 1, szPlayerInfo .. tbInfoList[i].szMsg)
      Lst_SetLineData(self.UIGROUP, self.JOIN_TEAM_PALYER_LIST, i, tbInfoList[i].nPlayerID)
    end
  end

  -- SetEnable "上一页"
  if self.tbData.JoinPlayer.nCurPageNum == 1 then
    Wnd_SetEnable(self.UIGROUP, self.JOIN_TEAM_PREVIOUS_VIEW, 0)
  else
    Wnd_SetEnable(self.UIGROUP, self.JOIN_TEAM_PREVIOUS_VIEW, 1)
  end

  -- SetEnable "下一页"
  if self.tbData.JoinPlayer.bHaveNextPage == 0 or #tbInfoList < 6 then
    Wnd_SetEnable(self.UIGROUP, self.JOIN_TEAM_NEXT_VIEW, 0)
  else
    Wnd_SetEnable(self.UIGROUP, self.JOIN_TEAM_NEXT_VIEW, 1)
  end
end

function uiTeam:RefreshJoinTeamList()
  Lst_Clear(self.UIGROUP, self.JOIN_TEAM_PALYER_LIST)

  me.GetTeamSearchInfoList(1, self.KTEAM_SEARCH_JOIN, self.tbData.JoinPlayer.nCurSortType, self.tbData.JoinPlayer.nCurPageNum, self.bReverscSort)
end

function uiTeam:GetJoinTeamFormatedString(tbPlayer)
  if (not tbPlayer) or not tbPlayer.szName or not tbPlayer.nLevel or not tbPlayer.nFaction or not tbPlayer.nMapID then
    return
  end
  local szName = self:FormatStringByLength(tbPlayer.szName, self.JOIN_PLAYER_NAME_SIZE)
  local szLevel = self:FormatStringByLength(tostring(tbPlayer.nLevel), self.JOIN_PLAYER_LEVEL_SIZE, 1)
  local szFaction = self:FormatStringByLength(Player:GetFactionRouteName(tbPlayer.nFaction), self.JOIN_PLAYER_FACTION_SIZE)
  local szMapID = self:FormatStringByLength(tbPlayer.nMapID, self.JOIN_PLAYER_LOCATION_SIZE)
  return szName .. " " .. szLevel
end

function uiTeam:GetJoinTeamTipFormatedString(tbPlayer)
  if (not tbPlayer) or not tbPlayer.szName or not tbPlayer.nLevel or not tbPlayer.nFaction or not tbPlayer.nMapID then
    return
  end
  return tbPlayer.szName .. " " .. tbPlayer.nLevel .. " " .. Player:GetFactionRouteName(tbPlayer.nFaction) .. "\n" .. tbPlayer.szMsg
end

-- 招募成员页面

function uiTeam:SearchConscribe(nEnable)
  if nEnable > 0 then
    local nMsg = Edt_GetTxt(self.UIGROUP, self.CONSCRIBE_TEXT_EDIT)

    if #nMsg > 0 then
      local szFaction = ""

      for i = 1, #self.FACTION_LIST do
        local nChecked = Btn_GetCheck(self.UIGROUP, self.FACTION_LIST[i][1])
        if nChecked > 0 then
          szFaction = szFaction .. self.FACTION_LIST[i][2] .. ","
        end
      end

      local nMinLevel = Edt_GetInt(self.UIGROUP, self.LEVEL_MIN_EDIT)
      local nMaxLevel = Edt_GetInt(self.UIGROUP, self.LEVEL_MAX_EDIT)

      if nMinLevel == 0 and nMaxLevel == 0 then
        Btn_Check(self.UIGROUP, self.CHECK_LEVEL_LIMIT, 1)
      end
      if Btn_GetCheck(self.UIGROUP, self.CHECK_LEVEL_LIMIT) > 0 then
        nMinLevel = self.MINLEVEL
        nMaxLevel = self.MAXLEVEL
      end
      if nMinLevel < self.MINLEVEL then
        nMinLevel = self.MINLEVEL
      elseif nMinLevel > self.MAXLEVEL then
        nMinLevel = self.MAXLEVEL
      end
      if nMaxLevel < self.MINLEVEL then
        nMaxLevel = self.MINLEVEL
      elseif nMaxLevel > self.MAXLEVEL then
        nMaxLevel = self.MAXLEVEL
      end
      if nMaxLevel < nMinLevel then
        nMaxLevel = nMinLevel
      end

      Edt_SetInt(self.UIGROUP, self.LEVEL_MIN_EDIT, nMinLevel)
      Edt_SetInt(self.UIGROUP, self.LEVEL_MAX_EDIT, nMaxLevel)

      local nRet = me.SendTeamSearchInfo(self.KTEAM_SEARCH_INVITE, nMsg, nMinLevel, nMaxLevel, szFaction)
      if nRet == 0 then
        Btn_Check(self.UIGROUP, self.WANT_CONSCRIBE_BUTTON, 0)
      else
        Btn_Check(self.UIGROUP, self.WANT_CONSCRIBE_BUTTON, 1)
      end
    else
      me.Msg("请填写招募信息!")
      Btn_Check(self.UIGROUP, self.WANT_CONSCRIBE_BUTTON, 0)
    end
  else
    me.CancelTeamSearch(self.KTEAM_SEARCH_INVITE)
  end
end

-- 更新信息
function uiTeam:UpdateConscribeList()
  if self.tbData.ConscribePlayer.nCurPageNum < 1 then
    self.tbData.ConscribePlayer.nCurPageNum = 1
  end

  Txt_SetTxt(self.UIGROUP, self.CONSCRIBE_LIST_PAGE_NUM, self.tbData.ConscribePlayer.nCurPageNum)
  Lst_Clear(self.UIGROUP, self.CONSCRIBE_MEMBER_LIST)
  local tbInfoList = me.GetTeamSearchInfoList(0, self.KTEAM_SEARCH_INVITE, self.tbData.ConscribePlayer.nCurSortType, self.tbData.ConscribePlayer.nCurPageNum, self.bReverscSort)

  if tbInfoList == nil then
    if self.tbData.ConscribePlayer.nCurPageNum > 1 then
      self.tbData.ConscribePlayer.nCurPageNum = self.tbData.ConscribePlayer.nCurPageNum - 1
      Wnd_SetEnable(self.UIGROUP, self.CONSCRIBE_NEXT_VIEW, 0)
      self.tbData.ConscribePlayer.bHaveNextPage = 0
      self:UpdateConscribeList()
    end
    return
  else
    self.tbData.ConscribePlayer.tbList = tbInfoList
  end

  for i = 1, #self.tbData.ConscribePlayer.tbList do
    local szPlayerInfo = self:GetConscribeFormatedString(tbInfoList[i])
    if szPlayerInfo then
      Lst_SetCell(self.UIGROUP, self.CONSCRIBE_MEMBER_LIST, i, 1, szPlayerInfo .. tbInfoList[i].szMsg)
      Lst_SetLineData(self.UIGROUP, self.CONSCRIBE_MEMBER_LIST, i, tbInfoList[i].nPlayerID)
    end
  end

  -- SetEnable "下一页"
  if self.tbData.ConscribePlayer.bHaveNextPage == 0 or #tbInfoList < 6 then
    Wnd_SetEnable(self.UIGROUP, self.CONSCRIBE_NEXT_VIEW, 0)
  else
    Wnd_SetEnable(self.UIGROUP, self.CONSCRIBE_NEXT_VIEW, 1)
  end

  -- SetEnable "上一页"
  if self.tbData.ConscribePlayer.nCurPageNum == 1 then
    Wnd_SetEnable(self.UIGROUP, self.CONSCRIBE_PREVIOUS_VIEW, 0)
  else
    Wnd_SetEnable(self.UIGROUP, self.CONSCRIBE_PREVIOUS_VIEW, 1)
  end
end

function uiTeam:RefreshConscribeList()
  Lst_Clear(self.UIGROUP, self.CONSCRIBE_MEMBER_LIST)
  me.GetTeamSearchInfoList(1, self.KTEAM_SEARCH_INVITE, self.tbData.ConscribePlayer.nCurSortType, self.tbData.ConscribePlayer.nCurPageNum, self.bReverscSort)
end

function uiTeam:GetConscribeFormatedString(tbPlayer)
  if (not tbPlayer) or not tbPlayer.szName or not tbPlayer.nMinLevel or not tbPlayer.nMaxLevel or not tbPlayer.szFaction or not tbPlayer.nMapID then
    return
  end

  local szName = self:FormatStringByLength(tbPlayer.szName, self.CONSCRIBE_NAME_SIZE)
  local szLevel = self:FormatStringByLength(tbPlayer.nMinLevel .. "-" .. tbPlayer.nMaxLevel, self.CONSCRIBE_LEVEL_SIZE, 1)

  local szFaction = ""
  local szFactionList = tbPlayer.szFaction
  while true do
    local nOffset, _ = string.find(szFactionList, ",")
    if nOffset == nil then
      break
    end

    local nFaction = string.sub(szFactionList, 0, nOffset - 1)
    nFaction = tonumber(nFaction)
    szFaction = szFaction .. (self.FACTION_SHORT_NAME[nFaction] or "")
    szFactionList = string.sub(szFactionList, nOffset + 1)
  end
  szFaction = self:FormatStringByLength(szFaction, self.CONSCRIBE_FACTION_SIZE)
  local szMapID = self:FormatStringByLength(tbPlayer.nMapID, self.CONSCRIBE_LOCATION_SIZE)

  return szName .. " " .. szLevel
end

function uiTeam:GetConscribeTipFormatedString(tbPlayer)
  if (not tbPlayer) or not tbPlayer.szName or not tbPlayer.nMinLevel or not tbPlayer.nMaxLevel or not tbPlayer.szFaction or not tbPlayer.nMapID then
    return
  end
  local szLevel = tbPlayer.nMinLevel .. "-" .. tbPlayer.nMaxLevel

  local szFaction = ""
  local szFactionList = tbPlayer.szFaction
  while true do
    local nOffset, _ = string.find(szFactionList, ",")
    if nOffset == nil then
      break
    end

    local nFaction = string.sub(szFactionList, 0, nOffset - 1)
    nFaction = tonumber(nFaction)
    szFaction = szFaction .. (self.FACTION_SHORT_NAME[nFaction] or "")
    szFactionList = string.sub(szFactionList, nOffset + 1)
  end

  return tbPlayer.szName .. " " .. szLevel .. " " .. szFaction .. "\n" .. tbPlayer.szMsg
end

-- 联赛求组页面

function uiTeam:SearchMatch(nEnable)
  if nEnable > 0 then
    local nMsg = Edt_GetTxt(self.UIGROUP, self.JOIN_MATCH_TEXT)
    if #nMsg > 0 then
      local nRet = me.SendTeamSearchInfo(self.KTEAM_SEARCH_LEAGUE, nMsg)
      if nRet == 0 then
        Btn_Check(self.UIGROUP, self.WANT_JOIN_MATCH_BUTTON, 0)
      else
        Btn_Check(self.UIGROUP, self.WANT_JOIN_MATCH_BUTTON, 1)
      end
    else
      me.Msg("请填写寻求联赛组队信息!")
      Btn_Check(self.UIGROUP, self.WANT_JOIN_MATCH_BUTTON, 0)
    end
  else
    me.CancelTeamSearch(self.KTEAM_SEARCH_LEAGUE)
  end
end

-- 更新联赛求组信息
function uiTeam:UpdateMatchTeamList()
  me.SyncSelfSearchInfo(self.KTEAM_SEARCH_LEAGUE)
  if self.tbData.MatchPlayer.nCurPageNum < 1 then
    self.tbData.MatchPlayer.nCurPageNum = 1
  end
  Txt_SetTxt(self.UIGROUP, self.MATCH_TEAM_PAGE_NUM, self.tbData.MatchPlayer.nCurPageNum)

  Lst_Clear(self.UIGROUP, self.MATCH_TEAM_LIST)
  local tbInfoList = me.GetTeamSearchInfoList(0, self.KTEAM_SEARCH_LEAGUE, self.tbData.MatchPlayer.nCurSortType, self.tbData.MatchPlayer.nCurPageNum, self.bReverscSort)
  if tbInfoList == nil then
    debug.traceback("UpdateMatchTeamList: tbInfoList == nil")
    if self.tbData.MatchPlayer.nCurPageNum > 1 then
      self.tbData.MatchPlayer.nCurPageNum = self.tbData.MatchPlayer.nCurPageNum - 1
      self.tbData, MatchPlayer.bHaveNextPage = 0
      Wnd_SetEnable(self.UIGROUP, self.MATCH_TEAM_NEXT_VIEW, 0)
      self:UpdateMatchTeamList()
    end
    return
  end

  for i = 1, #tbInfoList do
    local szPlayerInfo = self:GetJoinTeamFormatedString(tbInfoList[i])
    if szPlayerInfo then
      --			LstOld_AddStr(self.UIGROUP, self.MATCH_TEAM_LIST, i - 1, szPlayerInfo..tbInfoList[i].szMsg);
      --			LstOld_SetItemData(self.UIGROUP, self.MATCH_TEAM_LIST, i - 1, tbInfoList[i].nPlayerID);
    end
  end
  -- SetEnable "下一页"
  if self.tbData.MatchPlayer.bHaveNextPage == 0 or #tbInfoList < 6 then
    Wnd_SetEnable(self.UIGROUP, self.MATCH_TEAM_NEXT_VIEW, 0)
  else
    Wnd_SetEnable(self.UIGROUP, self.MATCH_TEAM_NEXT_VIEW, 1)
  end
  -- SetEnable "上一页"
  if self.tbData.MatchPlayer.nCurPageNum == 1 then
    Wnd_SetEnable(self.UIGROUP, self.MATCH_TEAM_PREVIOUS_VIEW, 0)
  else
    Wnd_SetEnable(self.UIGROUP, self.MATCH_TEAM_PREVIOUS_VIEW, 1)
  end
end

function uiTeam:RefreshMatchTeamList()
  if self.tbData.MatchPlayer.nCurPageNum < 1 then
    self.tbData.MatchPlayer.nCurPageNum = 1
  end
  Txt_SetTxt(self.UIGROUP, self.MATCH_TEAM_PAGE_NUM, self.tbData.MatchPlayer.nCurPageNum)
  Lst_Clear(self.UIGROUP, self.MATCH_TEAM_LIST)
  me.GetTeamSearchInfoList(1, self.KTEAM_SEARCH_LEAGUE, self.tbData.MatchPlayer.nCurSortType, self.tbData.MatchPlayer.nCurPageNum, self.bReverscSort)
end

function uiTeam:ChangeSortType(szWnd)
  local _, _, nX, nY = string.find(szWnd, "BtnSort(%d)_(%d)")
  if (not nX) or not nY then
    return
  end

  nX = tonumber(nX)
  nY = tonumber(nY)

  for i = 1, #self.SORT_BUTTON[nX] do
    Btn_Check(self.UIGROUP, self.SORT_BUTTON[nX][i], 0)
  end

  Btn_Check(self.UIGROUP, self.SORT_BUTTON[nX][nY], 1)

  if nX == self.nLastX and nY == self.nLastY then
    self.bReverscSort = 1 - self.bReverscSort
  else
    self.bReverscSort = 0
  end

  self.nLastX = nX
  self.nLastY = nY

  if nX == 1 then
    self.tbData.NearbyPlayer.nCurSortType = nY - 1
  elseif nX == 2 then
    self.tbData.JoinPlayer.nCurSortType = nY - 1
    self:UpdateJoinTeamList()
  elseif nX == 3 then
    self.tbData.ConscribePlayer.nCurSortType = nY - 1
    self:UpdateConscribeList()
  elseif nX == 4 then
    self.tbData.MatchPlayer.nCurSortType = nY - 1
    self:UpdateMatchTeamList()
  end
end

-- 得到规定长度的字符串
function uiTeam:FormatStringByLength(szBuffer, nLength, bCenter)
  szBuffer = tostring(szBuffer)
  self.szBlankString = "                                                                          "

  local nBufferLength = #szBuffer
  if nBufferLength < nLength then
    if bCenter == 1 then
      local nOffset = math.floor((nLength - nBufferLength) / 2)
      szBuffer = string.sub(self.szBlankString, 0, nOffset) .. szBuffer .. string.sub(self.szBlankString, 0, nLength - nBufferLength - nOffset)
    else
      szBuffer = szBuffer .. string.sub(self.szBlankString, 0, nLength - nBufferLength)
    end
  elseif nBufferLength > nLength then
    szBuffer = string.sub(szBuffer, 0, nLength)
  end

  return szBuffer
end

function uiTeam:FixUI()
  Wnd_SetEnable(self.UIGROUP, self.MATCH_TEAM_PAGE_BUTTON, 0) -- 禁用联赛页

  -- 隐藏 招募的2个更新
  Wnd_Hide(self.UIGROUP, self.UPDATE_LEVEL_BUTTON)
  Wnd_Hide(self.UIGROUP, self.UPDATE_CONSCRIBE_TEXT_BUTTON)

  -- 隐藏 下面列表的后2个表头 并修改第2列文字
  Btn_SetTxt(self.UIGROUP, self.SORT_BUTTON[2][3], "信息")
  Wnd_SetEnable(self.UIGROUP, self.SORT_BUTTON[2][3], 0)
  Wnd_Hide(self.UIGROUP, self.SORT_BUTTON[2][4])
  Btn_SetTxt(self.UIGROUP, self.SORT_BUTTON[3][3], "信息")
  Wnd_SetEnable(self.UIGROUP, self.SORT_BUTTON[3][3], 0)
  Wnd_Hide(self.UIGROUP, self.SORT_BUTTON[3][4])
  Btn_SetTxt(self.UIGROUP, self.SORT_BUTTON[4][3], "信息")
  Wnd_SetEnable(self.UIGROUP, self.SORT_BUTTON[4][3], 0)
  Wnd_Hide(self.UIGROUP, self.SORT_BUTTON[4][4])

  for i = 1, #self.FACTION_LIST do
    Btn_Check(self.UIGROUP, self.FACTION_LIST[i][1], 1)
  end

  Wnd_SetEnable(self.UIGROUP, self.JOIN_TEAM_PREVIOUS_VIEW, 0)
  Wnd_SetEnable(self.UIGROUP, self.CONSCRIBE_PREVIOUS_VIEW, 0)
  Wnd_SetEnable(self.UIGROUP, self.MATCH_TEAM_PREVIOUS_VIEW, 0)
  Wnd_SetEnable(self.UIGROUP, self.JOIN_TEAM_NEXT_VIEW, 0)
  Wnd_SetEnable(self.UIGROUP, self.CONSCRIBE_NEXT_VIEW, 0)
  Wnd_SetEnable(self.UIGROUP, self.MATCH_TEAM_NEXT_VIEW, 0)
end

function uiTeam:SelfSearchUpdateCallback(nSearchType, szMsg)
  local sBtn = nil
  local sTxt = nil
  if nSearchType == 0 then
    sBtn = self.WANT_JOIN_TEAM_BUTTON
    sTxt = self.JOIN_TEAM_TEXT
  elseif nSearchType == 1 then
    sBtn = self.WANT_CONSCRIBE_BUTTON
    sTxt = self.CONSCRIBE_TEXT_EDIT
  elseif nSearchType == 2 then
    sBtn = self.WANT_JOIN_MATCH_BUTTON
    sTxt = self.JOIN_MATCH_TEXT
  else
    return
  end

  local bEnable = 0
  if szMsg ~= "" then
    bEnable = 1
    Edt_SetTxt(self.UIGROUP, sTxt, szMsg)
  end

  Btn_Check(self.UIGROUP, sBtn, bEnable)
end

function uiTeam:OnListSel(szWndName, nParam)
  if szWndName == self.TEAM_MEMBER_LIST then
    local nAllotModel, tbMemberList = me.GetTeamInfo()
    if nAllotModel and tbMemberList then
      local tLeader = tbMemberList[1]
      if tLeader.szName == me.szName then
        if nParam == 0 then -- 队长选了队长自己
          Wnd_SetEnable(self.UIGROUP, self.KICK_MEMBER_BUTTON, 0)
          Wnd_SetEnable(self.UIGROUP, self.CHANGE_LEADER_BUTTON, 0)
        else
          Wnd_SetEnable(self.UIGROUP, self.KICK_MEMBER_BUTTON, 1)
          Wnd_SetEnable(self.UIGROUP, self.CHANGE_LEADER_BUTTON, 1)
        end
      end
    end
  elseif szWndName == self.NEARBY_PLAYER_LIST then
    Wnd_SetEnable(self.UIGROUP, self.INVITE_PLAYER_BUTTON, 0)
    local nId = nParam
    local nIndex = self.tbIdToIndex[nId]
    if not nIndex then
      return 0
    end

    local nIsCaptain = self:IsTeamLeader()

    if me.nTeamId > 0 then
      Btn_SetTxt(self.UIGROUP, self.INVITE_PLAYER_BUTTON, "邀请加入")
    else
      Btn_SetTxt(self.UIGROUP, self.INVITE_PLAYER_BUTTON, "邀请组队")
    end

    if self.tbData.tbNearbyPlayer[nIndex].nTeamNum > 0 then
      if self.tbData.tbNearbyPlayer[nIndex].nCaptainFlag == 1 then
        if me.nTeamId <= 0 then
          Btn_SetTxt(self.UIGROUP, self.INVITE_PLAYER_BUTTON, "申请加入")
          Wnd_SetEnable(self.UIGROUP, self.INVITE_PLAYER_BUTTON, 1)
        end
      end
    else
      Wnd_SetEnable(self.UIGROUP, self.INVITE_PLAYER_BUTTON, 1)
      if me.nTeamId > 0 and nIsCaptain ~= 1 then
        Wnd_SetEnable(self.UIGROUP, self.INVITE_PLAYER_BUTTON, 0)
      end
    end
  end
end

function uiTeam:OnTeamDataChanged(szQuestion, tbAnswers)
  uiTeam:TeamInfoChangedCallback()
  if nParam > 0 then
    UiManager:OpenWindow(Ui.UI_TEAMPORTRAIT)
  else
    UiManager:CloseWindow(Ui.UI_TEAMPORTRAIT)
  end
end

function uiTeam:OnTeamSearchUpdated(nSearchType, nSortType, nPage, bHaveNextPage)
  self:TeamSearchInfoUpdateCallback(nSearchType, nSortType, nPage, bHaveNextPage)
end

function uiTeam:OnSelfSearchUpdated(nSearchType, szMsg)
  self:SelfSearchUpdateCallback(nSearchType, szMsg)
end

function uiTeam:OnTeamDisable(bDisable)
  UiManager:CloseWindow(self.UIGROUP)
  local tbTemp = me.GetTempTable("Relation")
  if not tbTemp then
    return 0
  end
  if not tbTemp.Team_Table then
    tbTemp.Team_Table = {}
  end
  tbTemp.Team_Table.bDisable = bDisable
  self.bDisable = tbTemp.Team_Table.bDisable
end

function uiTeam:OnTeamShellModelChanged(nShareFlag)
  self:TeamAllotModelChangedCallback(nShareFlag)
end

function uiTeam:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_TEAM, self.OnTeamDataChanged },
    { UiNotify.emCOREEVENT_TEAM_SEARCH_INFO, self.OnTeamSearchUpdated },
    { UiNotify.emCOREEVENT_SELF_SEARCH_INFO, self.OnSelfSearchUpdated },
    { UiNotify.emCOREEVENT_TEAM_DISABLE_STATE, self.OnTeamDisable },
    { UiNotify.emCOREEVENT_TEAM_SHARE_RESPONSE, self.OnTeamShellModelChanged },
  }
  return tbRegEvent
end

---------------------------------------------------------------------------------------------
--	自动组队 by wangzhiguang

--	Comment:
--	由于是在原有的组队界面上添加自动组队内容，
--	并删除了“寻求组队”、“招募成员”、“联赛求组"三个tab的内容：
--		1.为了提高开发效率，避免引入bug，只删除ini中的内容，原有的脚本逻辑不做删除和改写。
--		2.为了提高可读性，自动组队的相关UI脚本逻辑统一写在下面，和已有代码尽量保持分离。
---------------------------------------------------------------------------------------------
--
--
--uiTeam.PAGE_BUTTON_AUTOTEAM			= "BtnAutoTeamPage";	--自动组队tab按钮
--uiTeam.PAGE_AUTOTEAM				= "PageAutoTeam";		--自动组队分页
--
--uiTeam.BUTTON_JOIN_AUTOTEAM			= "BtnJoinAutoTeam";	--“参与组队”按钮
--uiTeam.BUTTON_LEAVE_AUTOTEAM		= "BtnLeaveAutoTeam";	--“退出组队”按钮
--
--uiTeam.LIST_AUTOTEAM_FUNCTION		= "LstAutoTeamFunction";	--可自动组队的功能列表
--uiTeam.LIST_AUTOTEAM_MEMER			= "LstAutoTeamMember";		--队员列表
--
----key为LIST_AUTOTEAM_FUNCTION中对应行的index, value为自动组队的nTeamType
--uiTeam.tbAutoTeamTypeMap =
--{
--	[2]	= AutoTeam.ARMY_FUNIUSHAN,
--	[3]	= AutoTeam.ARMY_BAIMANSHAN,
--	[4]	= AutoTeam.ARMY_HAIWANGLINGMU,
--
--	[6]	= AutoTeam.XOYO_PUTONG,
--	[7]	= AutoTeam.XOYO_KUNNAN,
--	[8]	= AutoTeam.XOYO_CHUANSHUO,
--	[9] = AutoTeam.XOYO_DIYU,
--};
--
--function uiTeam:RefreshAutoTeam()
--	self:InitAutoTeamFunctionList();
--	self:UpdateAutoTeamData();
--	self:RefreshAutoTeamButtons();
--end
--
----初始化可自动组队的功能列表
--function uiTeam:InitAutoTeamFunctionList()
--	local szUiGroup = self.UIGROUP;
--	local szWnd = self.LIST_AUTOTEAM_FUNCTION;
--
--	Lst_Clear(szUiGroup, self.LIST_AUTOTEAM_FUNCTION);
--
--	local nTeamType = AutoTeam.nCurrentTeamType;
--	for i = 1, 9 do
--		if nTeamType and self.tbAutoTeamTypeMap[i] == nTeamType then
--			Lst_SetCell(szUiGroup, szWnd, i, 1, "组队中");
--			Lst_SetCurKey(szUiGroup, szWnd, i);
--		else
--			Lst_SetCell(szUiGroup, szWnd, i, 1, "");
--		end
--	end
--
--	Lst_SetCell(szUiGroup, szWnd, 1, 0, "军营副本");
--		Lst_SetCell(szUiGroup, szWnd, 2, 0, "    伏牛山后山");
--		Lst_SetCell(szUiGroup, szWnd, 3, 0, "    百蛮山");
--		Lst_SetCell(szUiGroup, szWnd, 4, 0, "    海陵王墓");
--
--	Lst_SetCell(szUiGroup, szWnd, 5, 0, "逍遥谷");
--		Lst_SetCell(szUiGroup, szWnd, 6, 0, "    普通逍遥谷");
--		Lst_SetCell(szUiGroup, szWnd, 7, 0, "    困难逍遥谷");
--		Lst_SetCell(szUiGroup, szWnd, 8, 0, "    传说逍遥谷");
--		Lst_SetCell(szUiGroup, szWnd, 9, 0, "    地狱逍遥谷");
--end
--
----autoteam_client.lua调用此函数
--function uiTeam:UpdateAutoTeamData()
--	if AutoTeam.tbAutoTeamData then
--		self:RefreshListAutoTeamMember(AutoTeam.tbAutoTeamData);
--	else
--		Lst_Clear(self.UIGROUP, self.LIST_AUTOTEAM_MEMER);
--	end
--end
--
--function uiTeam:RefreshListAutoTeamMember(tbTeam)
--	local szUiGroup = self.UIGROUP;
--	local szWnd = self.LIST_AUTOTEAM_MEMER;
--
--	Lst_Clear(szUiGroup, szWnd);
--
--	local szName, nLevel, szFaction;
--	for n, tbMemberInfo in ipairs(tbTeam.tbMember) do
--		szName = tbMemberInfo.szName;
--		nLevel = tbMemberInfo.nLevel;
--		szFaction = Player:GetFactionRouteName(tbMemberInfo.nFaction);
--		Lst_SetCell(szUiGroup, szWnd, n, 0, szName);
--
--		local szConfirmed = "";
--		if tbMemberInfo.bConfirmed == 1 then
--			szConfirmed = "已确认";
--		end
--		Lst_SetCell(szUiGroup, szWnd, n, 1, szConfirmed);
--	end
--end
--
--function uiTeam:RefreshAutoTeamButtons()
--	if AutoTeam:IsAllowedMap(me.nMapId) ~= 1 then
--		Wnd_SetEnable(self.UIGROUP, self.BUTTON_JOIN_AUTOTEAM, 0);
--		Wnd_SetEnable(self.UIGROUP, self.BUTTON_LEAVE_AUTOTEAM, 0);
--		return;
--	end
--
--	local nTeamType = AutoTeam.nCurrentTeamType;
--	if nTeamType then
--		Wnd_SetEnable(self.UIGROUP, self.BUTTON_JOIN_AUTOTEAM, 0);
--		Wnd_SetEnable(self.UIGROUP, self.BUTTON_LEAVE_AUTOTEAM, 1);
--	else
--		Wnd_SetEnable(self.UIGROUP, self.BUTTON_JOIN_AUTOTEAM, 1);
--		Wnd_SetEnable(self.UIGROUP, self.BUTTON_LEAVE_AUTOTEAM, 0);
--	end
--end
--
--function uiTeam:GetSelectedTeamType()
--	local nKey = Lst_GetCurKey(self.UIGROUP, self.LIST_AUTOTEAM_FUNCTION);
--	if nKey then
--		return self.tbAutoTeamTypeMap[nKey];
--	end
--end
--
--function uiTeam:JoinAutoTeam()
--	local nTeamType = self:GetSelectedTeamType();
--	if nTeamType then
--		AutoTeam:JoinAutoTeam(nTeamType);
--	else
--		me.Msg("请选择要自动组队的活动。");
--	end
--end
--
--function uiTeam:LeaveAutoTeam()
--	if AutoTeam.nCurrentTeamType then
--		AutoTeam:LeaveAutoTeam();
--	end
--end
--
--function uiTeam:ShowAutoTeamPage()
--	PgSet_ActivePage(self.UIGROUP, self.PAGE_SET_MAIN, self.PAGE_AUTOTEAM);
--end
