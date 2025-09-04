-------------------------------------------------------
--文件名		：	tong.lua
--创建者		：	zhengyuhua
--创建时间		：	2007-09-17
--功能描述		：	帮会界面
------------------------------------------------------

local uiTong = Ui:GetClass("tong")

uiTong.BUTTON_CLOSE = "BtnClose"
uiTong.BUTTON_PAGE_NOTE = "BtnPageNote"
uiTong.BUTTON_PAGE_INFO = "BtnPageInfo"
uiTong.BUTTON_PAGE_OPERATION = "BtnPageOperation"
uiTong.BUTTON_PAGE_POSITION = "BtnPagePosition"
uiTong.BUTTON_SHOWONLINE = "BtnShowOnline"
uiTong.BUTTON_SHOWHANDUP = "BtnShowHandUp"
uiTong.BUTTON_REFRESH = "BtnRefresh"
--uiTong.BUTTON_SORT_TYPE			= "BtnSortType";
uiTong.BUTTON_SEARCH = "BtnSearch"
uiTong.BUTTON_PREVIOUS_PAGE = "BtnPrePage"
uiTong.BUTTON_NEXT_PAGE = "BtnNextPage"
uiTong.BUTTON_SAVE_AFFICHE = "BtnSaveAffiche"
--uiTong.BUTTON_INHERIT			= "BtnInherit";
uiTong.BUTTON_DEL_KIN = "BtnFireKin"
uiTong.BUTTON_CHANGE_TITEL = "BtnChangeTitle"
uiTong.BUTTON_FIRE_LEADER = "BtnFireLeader"
uiTong.BUTTON_DISBAND_TONG = "BtnDisbandTong"
uiTong.BUTTON_APOINT_ASSISTANT = "BtnApointAssistant"
uiTong.BUTTON_SAVE_ASSISTANT = "BtnSaveAssistant"
uiTong.BUTTON_EDIT_AFFICHE = "BtnEditAffiche"
uiTong.BUTTON_CHANGE_E_TITLE = "BtnChangeEmissaryTitle"
uiTong.BUTTON_FIRE_EMISSARY = "BtnFireEmissary"
uiTong.BUTTON_FIRE_ALL_EMISSARY = "BtnFireAllEmissary"
uiTong.BUTTON_APOINT_EMISSARY = "BtnApointEmissary"
uiTong.BUTTON_STORAGE_FUND = "BtnStorageFund"
uiTong.BUTTON_GET_FUND = "BtnGetFund"
uiTong.BUTTON_STORAGE_FUND_TO_KIN = "BtnStorageFundToKin"
--uiTong.BUTTON_DISPENSE			= "BtnDispense";
--uiTong.BUTTON_TRANCE_TO_SF	= "BtnTranceToSF";
--uiTong.BUTTON_STORAGE_SF_FUND	= "BtnStorageSF";
uiTong.BUTTON_STORAGE_REPUTE = "BtnStorageRepute"
--uiTong.BUTTON_DISPENSE_OFFER	= "BtnDispenseOffer";
uiTong.BUTTON_SET_WAGE_LEVEL = "BtnSetWageLevel"
uiTong.BUTTON_HAND_UP = "BtnHandUp"
uiTong.BUTTON_REQUEST_LIST = "BtnRequestList"
uiTong.BUTTON_ELECT_MASTER = "BtnElectMaster"
uiTong.BUTTON_ELECT_GREAT_MEMBER = "BtnElectGreatMember"
uiTong.BUTTON_CLEAR_HAND_UP = "BtnClearHandUp"
uiTong.BUTTON_STOP_LEAGUE = "BtnStopLeague"
uiTong.BUTTON_SEND_TONGMAIL = "BtnSendTongMail"
uiTong.BUTTON_SET_C_FUND_LIMIT = "BtnSetConstructFundLimit"
uiTong.BUTTON_AFFICHE = "BtnShowAffiche"
uiTong.BUTTON_HISTORY = "BtnShowHistory"
uiTong.BUTTON_EVENT = "BtnShowEvent"
uiTong.BUTTON_HISTORY_PRE_PAGE = "BtnHistoryPrePage"
uiTong.BUTTON_HISTORY_NEXT_PAGE = "BtnHistoryNextPage"
uiTong.BUTTON_EVENT_PRE_PAGE = "BtnEventPrePage"
uiTong.BUTTON_EVENT_NEXT_PAGE = "BtnEventNextPage"
uiTong.BUTTON_ANNOUNCE = "BtnAnnounce"

uiTong.LIST_MEMBER = "LstMember"
uiTong.LIST_ASSISTANT = "LstAssistant"
uiTong.LIST_EMISSARY = "LstEmissary"
uiTong.LIST_EMISSARY_MEMBER = "LstEmissaryMember"
uiTong.LIST_OFFICIAL = "LstOfficial"
uiTong.LIST_HISTORY = "LstHistory"
uiTong.LIST_EVENT = "LstEvent"

uiTong.PAGESET_MAIN = "TongPageSet"
uiTong.PAGE_TONG_NOTE = "PageTongNote"
uiTong.PAGE_TONG_INFO = "PageTongInfo"
uiTong.PAGE_TONG_OPERATION = "PageTongOperation"
uiTong.PAGE_TONG_POSITION = "PageTongPosition"
uiTong.PAGESET_POSITION = "TonPositionPageSet"
uiTong.PAGESET_NOTE = "TonNotePageSet"

uiTong.TEXT_TITLE = "TxtTitle"
uiTong.TEXT_MEMBERLIST_TITLE = "TxtMemberListTitle"
uiTong.TEXT_PAGE_NUMBER = "TxtPageNum"
uiTong.TEXT_BASE_INFO = "TxtBaseInfo"
uiTong.TEXT_NAME = "TxtName"
uiTong.TEXT_LEADER = "TxtLeader"
uiTong.TEXT_LEAGUE = "TxtLeague"
uiTong.TEXT_CAMP = "TxtCamp"
uiTong.TEXT_KIN_NUM = "TxtKinNum"
uiTong.TEXT_MEMBER_NUM = "TxtMemberNum"
uiTong.TEXT_ECONOMY_INFO = "TxtEconomyInfo"
uiTong.TEXT_TONG_FUND = "TxtTongFund"
uiTong.TEXT_CONSTRUCT_FUND = "TxtConstructFund"
--uiTong.TEXT_CONTRIBUTE			= "TxtContribute";
uiTong.TEXT_WAGE_INDEX = "TxtWageIndex"
uiTong.TEXT_REPUTE_INFO = "TxtReputeInfo"
uiTong.TEXT_TONG_REPUTE = "TxtTongRepute"
uiTong.TEXT_ACTION = "TxtAction"
uiTong.TEXT_PERSONAL_INFO = "TxtPersonalInfo"
uiTong.TEXT_PERSONAL_REPUTE = "TxtPersonalRepute"
uiTong.TEXT_PERSONAL_CONTRIBUTE = "TxtPersonalContribute"
uiTong.TEXT_ASSISTANT_NAME = "TxtAssistantName"
uiTong.TEXT_APOINT_A_NAME = "TxtApointAName"
uiTong.TEXT_ASSISTANT_POW = "TxtAssistantPow"
uiTong.TEXT_EMISSARY_MEMBER = "TxtEmissaryMember"
uiTong.TEXT_PRESIDENT = "TxtPresident"
uiTong.TEXT_OFFICIAL = "TxtOfficial"
uiTong.TEXT_OFFICIAL_TITLE = "TxtOfficialTitle"
uiTong.TEXT_GREAT_BOUNS = "TxtGreatBonus"
uiTong.TEXT_HISTORY_PAGE_NUM = "TxtHistoryPageNum"
uiTong.TEXT_EVENT_PAGE_NUM = "TxtEventPageNum"

uiTong.EDIT_FINDNAME = "EdtFindName"
uiTong.EDIT_AFFICHE = "EdtAffiche"
uiTong.EDIT_MEMBER_NAME = "EdtMemberName"
uiTong.EDIT_ASSISTANT_TITLE = "EdtAssistantTitle"
uiTong.EDIT_EMISSARY_TITLE = "EdtEmissaryTitle"

uiTong.BUTTON_POW = {} -- 权力按扭的定义
for i = 1, 16 do
  if i ~= 10 then
    uiTong.BUTTON_POW[i] = "BtnPow" .. i
  end
end

uiTong.CMB_SORTTYPE = "CmbSortType"
uiTong.MEMBER_MENU_ITEM = { " 密聊 ", " 组队 ", " 加好友 ", " 帮主投票 ", " 评优投票 " }
uiTong.SORT_TYPE_MENU = { "  按职位排列  ", "  按威望排列 ", "  帮会竞选排名  ", "  股权排名", "  评优竞选排名" }
uiTong.NUM_PER_PAGE = 23 -- 每页显示多少个成员
uiTong.QUOTIETY = 10000 -- 转化到KEY值的一个系数，KEY = KinIndex * uiTong.QUOTIETY + MemberId;
uiTong.MAX_BUILD_FUND = 2000000000 -- 建设资金上限 20E

uiTong.tbSort = {}

uiTong.tbSort[0] = {
  __lt = function(tbA, tbB)
    return tbA.nKey < tbB.nKey
  end,
}

uiTong.tbSort[1] = {
  __lt = function(tbA, tbB)
    return tbA.nKey > tbB.nKey
  end,
}

uiTong.tbSort[2] = uiTong.tbSort[1]
uiTong.tbSort[3] = uiTong.tbSort[1]
uiTong.tbSort[4] = uiTong.tbSort[1]
uiTong.SENDMAIL_MENU = { "帮会长老层", "全体掌令使", "全体帮会成员" }

function uiTong:Init()
  self.pTong = nil
  self.tbMember = {}
  self.tbIndexToId = {}
  self.tbKin = {}
  self.tbView = {}
  self.tbFigure = {} -- 长老映射表
  self.tbEmissary = {} -- 掌令使映射表
  self.tbHandUp = {}
  self.nPageNum = 0
  self.nPageCount = 0
  self.nSortType = 0
  self.nShowOnlineFlag = 0
  self.nShowHandUpFlag = 0
  self.nPageSetNo = Tong.NO_PAGE_TONG_NONE -- 更新同步策略依据
  self.nNotePageNo = Tong.TONG_NOTE_PAGE_NONE -- 帮会记录更新同步策略依据
  self.nCurHistoryPage = 1
  self.nTotleHistoryPage = 1
  self.nCurEventPage = 1
  self.nTotleEventPage = 1
end

function uiTong:OnOpen()
  PgSet_ActivePage(self.UIGROUP, self.PAGESET_MAIN, Tong.NO_PAGE_TONG_NOTE) -- 设置首页
  PgSet_ActivePage(self.UIGROUP, self.PAGESET_POSITION, 0)
  self.nPageSetNo = Tong.NO_PAGE_TONG_NOTE
  self.nNotePageNo = Tong.TONG_NOTE_PAGE_AFFICHE
  ClearComboBoxItem(self.UIGROUP, self.CMB_SORTTYPE)
  for i = 1, #self.SORT_TYPE_MENU do
    ComboBoxAddItem(self.UIGROUP, self.CMB_SORTTYPE, i, self.SORT_TYPE_MENU[i])
  end
  ComboBoxSelectItem(self.UIGROUP, self.CMB_SORTTYPE, 0)

  local tbTemp = me.GetTempTable("Tong")
  if tbTemp then
    if not tbTemp.Tong_tbHandUp then
      tbTemp.Tong_tbHandUp = {}
    end
    self.tbHandUp = tbTemp.Tong_tbHandUp
  end

  self.pTong = KTong.GetSelfTong()
  self:SetButtonStates()
  self:Refresh()
end

--根据玩家的职位设置各个按扭和编辑框的状态
function uiTong:SetButtonStates()
  if not self.pTong then
    self:EnableNormalButton(0)
    Wnd_SetEnable(self.UIGROUP, self.BUTTON_SET_C_FUND_LIMIT, 0) -- 调整建设资金上限
    Wnd_SetEnable(self.UIGROUP, self.BUTTON_FIRE_LEADER, 0) -- 罢免帮主
    return 0
  end

  --	-- 首领特权
  --	local bIsPresident = 0;
  --	if Tong:IsPresident_C() == 1 then
  --		bIsPresident = 1;
  --	end
  --	Wnd_SetEnable(self.UIGROUP, self.BUTTON_SET_C_FUND_LIMIT, bIsPresident);   -- 调整建设资金上限
  --	Wnd_SetEnable(self.UIGROUP, self.BUTTON_FIRE_LEADER, bIsPresident); -- 罢免帮主

  Wnd_SetEnable(self.UIGROUP, self.BUTTON_ELECT_GREAT_MEMBER, 1) -- 评优投票

  local nFigure = me.nKinFigure
  if nFigure ~= 1 then -- 如果不是族长
    self:EnableNormalButton(1)
    return 0
  end

  self:EnableNormalButton(2)
  local nPowTitle = self.pTong.GetSelfPower(Tong.POW_TITLE)
  local nPowAnnounce = self.pTong.GetSelfPower(Tong.POW_ANNOUNCE)
  local nPowEnvoy = self.pTong.GetSelfPower(Tong.POW_ENVOY)
  local nPowWage = self.pTong.GetSelfPower(Tong.POW_WAGE)
  local nPowFund = self.pTong.GetSelfPower(Tong.POW_FUN)
  local nPowUnion = self.pTong.GetSelfPower(Tong.POW_UNION)
  local nPowSplit = self.pTong.GetSelfPower(Tong.POW_SPLIT)
  local nPowMaster = self.pTong.GetSelfPower(Tong.POW_MASTER)

  -- 长老公共权力
  --Wnd_SetEnable(self.UIGROUP, self.BUTTON_FIRE_LEADER, 1);				-- 发起罢免帮主
  -- 帮主特有权力
  Wnd_SetEnable(self.UIGROUP, self.BUTTON_DEL_KIN, nPowMaster) -- 开除家族
  Wnd_SetEnable(self.UIGROUP, self.BUTTON_APOINT_ASSISTANT, nPowMaster) -- 任命长老
  Wnd_SetEnable(self.UIGROUP, self.BUTTON_SAVE_ASSISTANT, nPowMaster) -- 更改长老设置
  Wnd_SetEnable(self.UIGROUP, self.BUTTON_DISBAND_TONG, nPowMaster) -- 解散帮会
  -- 联盟
  --Wnd_SetEnable(self.UIGROUP, self.BUTTON_STOP_LEAGUE, nPowUnion);		-- 解除联盟
  Wnd_SetEnable(self.UIGROUP, self.BUTTON_STOP_LEAGUE, 0)
  -- 资金权力
  --	Wnd_SetEnable(self.UIGROUP, self.BUTTON_DISPENSE, nPowFund);			-- 发放资金权
  Wnd_SetEnable(self.UIGROUP, self.BUTTON_GET_FUND, nPowFund) -- 取资金
  Wnd_SetEnable(self.UIGROUP, self.BUTTON_STORAGE_FUND_TO_KIN, nPowFund) -- 转存家族
  -- 工资权力
  Wnd_SetEnable(self.UIGROUP, self.BUTTON_SET_WAGE_LEVEL, nPowWage) -- 修改分红比例
  -- 更改称号权力
  Wnd_SetEnable(self.UIGROUP, self.BUTTON_CHANGE_TITEL, nPowTitle) -- 更改帮众称号
  -- 掌令使权力
  Wnd_SetEnable(self.UIGROUP, self.BUTTON_CHANGE_E_TITLE, nPowEnvoy) -- 更改掌令使名称
  Wnd_SetEnable(self.UIGROUP, self.BUTTON_FIRE_EMISSARY, nPowEnvoy) -- 卸职掌令使
  Wnd_SetEnable(self.UIGROUP, self.BUTTON_FIRE_ALL_EMISSARY, nPowEnvoy) -- 全部卸职掌令使
  Wnd_SetEnable(self.UIGROUP, self.BUTTON_APOINT_EMISSARY, nPowEnvoy) -- 任命掌使
  -- 公告
  Wnd_SetEnable(self.UIGROUP, self.BUTTON_EDIT_AFFICHE, nPowAnnounce) -- 修改公告
  return 1
end

function uiTong:EnableNormalButton(bEnable)
  Wnd_SetEnable(self.UIGROUP, self.BUTTON_SET_C_FUND_LIMIT, 1) -- 调整建设资金上限
  Wnd_SetEnable(self.UIGROUP, self.BUTTON_FIRE_LEADER, 1) -- 罢免帮主
  Wnd_SetEnable(self.UIGROUP, self.BUTTON_SEND_TONGMAIL, bEnable)
  Wnd_SetEnable(self.UIGROUP, self.BUTTON_ELECT_MASTER, bEnable)
  Wnd_SetEnable(self.UIGROUP, self.BUTTON_SEARCH, bEnable)
  Wnd_SetEnable(self.UIGROUP, self.BUTTON_HAND_UP, bEnable)
  Wnd_SetEnable(self.UIGROUP, self.BUTTON_NEXT_PAGE, bEnable)
  Wnd_SetEnable(self.UIGROUP, self.BUTTON_PREVIOUS_PAGE, bEnable)
  Wnd_SetEnable(self.UIGROUP, self.BUTTON_SHOWHANDUP, bEnable)
  Wnd_SetEnable(self.UIGROUP, self.BUTTON_SHOWONLINE, bEnable)
  Wnd_SetEnable(self.UIGROUP, self.BUTTON_STORAGE_FUND, bEnable)
  Wnd_SetEnable(self.UIGROUP, self.BUTTON_CLEAR_HAND_UP, bEnable)
  Wnd_SetEnable(self.UIGROUP, self.BUTTON_REQUEST_LIST, bEnable)
  Wnd_SetEnable(self.UIGROUP, self.BUTTON_SAVE_AFFICHE, 0)
  Wnd_SetEnable(self.UIGROUP, self.EDIT_AFFICHE, 0)
  Wnd_SetEnable(self.UIGROUP, self.BUTTON_ANNOUNCE, 1)

  if bEnable ~= 2 then
    Wnd_SetEnable(self.UIGROUP, self.BUTTON_DEL_KIN, 0)
    Wnd_SetEnable(self.UIGROUP, self.BUTTON_DISBAND_TONG, 0)
    Wnd_SetEnable(self.UIGROUP, self.BUTTON_APOINT_ASSISTANT, 0)
    Wnd_SetEnable(self.UIGROUP, self.BUTTON_SAVE_ASSISTANT, 0)
    Wnd_SetEnable(self.UIGROUP, self.BUTTON_STOP_LEAGUE, 0)
    --		Wnd_SetEnable(self.UIGROUP, self.BUTTON_DISPENSE, 0);
    Wnd_SetEnable(self.UIGROUP, self.BUTTON_GET_FUND, 0)
    Wnd_SetEnable(self.UIGROUP, self.BUTTON_STORAGE_FUND_TO_KIN, 0)
    Wnd_SetEnable(self.UIGROUP, self.BUTTON_SET_WAGE_LEVEL, 0)
    Wnd_SetEnable(self.UIGROUP, self.BUTTON_CHANGE_TITEL, 0)
    Wnd_SetEnable(self.UIGROUP, self.BUTTON_CHANGE_E_TITLE, 0)
    Wnd_SetEnable(self.UIGROUP, self.BUTTON_FIRE_EMISSARY, 0)
    Wnd_SetEnable(self.UIGROUP, self.BUTTON_FIRE_ALL_EMISSARY, 0)
    Wnd_SetEnable(self.UIGROUP, self.BUTTON_APOINT_EMISSARY, 0)
    Wnd_SetEnable(self.UIGROUP, self.BUTTON_EDIT_AFFICHE, 0)
    Wnd_SetEnable(self.UIGROUP, self.BUTTON_REQUEST_LIST, 0)
    Wnd_SetEnable(self.UIGROUP, self.BUTTON_ANNOUNCE, 0)
  end
end

function uiTong:InitBaseInfo()
  Lst_Clear(self.UIGROUP, self.LIST_MEMBER)
  Lst_Clear(self.UIGROUP, self.LIST_EMISSARY)
  Lst_Clear(self.UIGROUP, self.LIST_EMISSARY_MEMBER)
  Lst_Clear(self.UIGROUP, self.LIST_ASSISTANT)
  Lst_Clear(self.UIGROUP, self.LIST_OFFICIAL)
  Lst_Clear(self.UIGROUP, self.LIST_HISTORY)
  Lst_Clear(self.UIGROUP, self.LIST_EVENT)

  Txt_SetTxt(self.UIGROUP, self.EDIT_AFFICHE, "")
  Txt_SetTxt(self.UIGROUP, self.TEXT_NAME, "帮会：")
  Txt_SetTxt(self.UIGROUP, self.TEXT_LEADER, "帮主：")
  Txt_SetTxt(self.UIGROUP, self.TEXT_LEAGUE, "联盟：")
  Txt_SetTxt(self.UIGROUP, self.TEXT_CAMP, "阵营：")
  Txt_SetTxt(self.UIGROUP, self.TEXT_KIN_NUM, "家族数：")
  Txt_SetTxt(self.UIGROUP, self.TEXT_MEMBER_NUM, "成员数：")
  Txt_SetTxt(self.UIGROUP, self.TEXT_TONG_FUND, "帮会资金：")
  Txt_SetTxt(self.UIGROUP, self.TEXT_CONSTRUCT_FUND, "建设资金：")
  Txt_SetTxt(self.UIGROUP, self.TEXT_WAGE_INDEX, "分红比例：")
  Txt_SetTxt(self.UIGROUP, self.TEXT_TONG_REPUTE, "帮会总威望：")
  Txt_SetTxt(self.UIGROUP, self.TEXT_ACTION, "帮会行动力：")
  Txt_SetTxt(self.UIGROUP, self.TEXT_PERSONAL_REPUTE, "生产效率：")
  Txt_SetTxt(self.UIGROUP, self.TEXT_PERSONAL_CONTRIBUTE, "个人资产：")
  Txt_SetTxt(self.UIGROUP, self.TEXT_GREAT_BOUNS, "奖励基金：")
  Txt_SetTxt(self.UIGROUP, self.TEXT_HISTORY_PAGE_NUM, "0/0")
  Txt_SetTxt(self.UIGROUP, self.TEXT_EVENT_PAGE_NUM, "0/0")

  Edt_SetTxt(self.UIGROUP, self.EDIT_AFFICHE, "")
end

-- 右键菜单处理
function uiTong:OnListRClick(szWnd, nParam)
  if szWnd == uiTong.LIST_MEMBER and nParam then
    Lst_SetCurKey(self.UIGROUP, szWnd, nParam)

    DisplayPopupMenu(self.UIGROUP, szWnd, #self.MEMBER_MENU_ITEM, nParam, self.MEMBER_MENU_ITEM[1], 1, self.MEMBER_MENU_ITEM[2], 2, self.MEMBER_MENU_ITEM[3], 3, self.MEMBER_MENU_ITEM[4], 4, self.MEMBER_MENU_ITEM[5], 5)
  end
end

-- 鼠标掠过列表
function uiTong:OnListOver(szWnd, nIndex)
  if szWnd == self.LIST_MEMBER and nIndex > 0 then
    local nKey = nIndex
    local nId = nKey % self.QUOTIETY
    local nIndex = (nKey - nId) / self.QUOTIETY
    local nKinId = self.tbIndexToId[nIndex]
    if self.tbMember[nKinId][nId] then
      local szPlayer = self.tbMember[nKinId][nId].szName
      local nFaction = self.tbMember[nKinId][nId].nFaction
      local nLevel = self.tbMember[nKinId][nId].nLevel
      local nHonor = self.tbMember[nKinId][nId].nHonor
      local nHonorRank = self.tbMember[nKinId][nId].nHonorRank
      local nHonorLevel = PlayerHonor:CalcHonorLevel(nHonor, nHonorRank, "money")
      local nSex = self.tbMember[nKinId][nId].nSex
      local szName = "名字：<color=yellow>" .. szPlayer .. "<color>\n"
      local szTip = "\n"
      local szSex = ""
      local nOnline = self.tbMember[nKinId][nId].nOnline
      local nGBOnline = self.tbMember[nKinId][nId].nGBOnline
      if nSex == 0 then
        szSex = "男"
      else
        szSex = "女"
      end
      szTip = szTip .. "性别：<color=yellow>" .. szSex .. "<color>\n"
      szTip = szTip .. "门派：<color=yellow>" .. Player:GetFactionRouteName(nFaction) .. "<color>\n"
      szTip = szTip .. "等级：<color=yellow>" .. nLevel .. "级<color>\n"
      szTip = szTip .. "财富等级：<color=yellow>" .. nHonorLevel .. "级<color>\n"
      if nOnline == 0 and nGBOnline == 1 then
        szTip = szTip .. "<color=125,111,172>跨服中<color>\n"
      end
      Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, szName, szTip)
    end
  end
end

-- 通过成员列表ID获得该成员的信息
function uiTong:GetPlayerNameFromListIndex(nIndex)
  local nId = nIndex % self.QUOTIETY
  local nIndex = (nIndex - nId) / self.QUOTIETY
  local nKinId = self.tbIndexToId[nIndex]
  if nKinId then
    return self.tbMember[nKinId][nId].szName
  end
  return nil
end

-- 鼠标进入指定控件区域
function uiTong:OnMouseEnter(szWnd)
  local szTip = ""
  if szWnd == self.TEXT_GREAT_BOUNS then
    szTip = "本周奖励比例：" .. self.pTong.GetGreatBonusPercent() .. "%"
  end
  if szTip ~= "" then
    Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, "", szTip)
  end
end

-- 按扭响应
function uiTong:OnButtonClick(szWnd, nParam)
  local tbFundParam = {}
  tbFundParam.tbTable = self
  tbFundParam.fnAccept = self.AcceptFundInput
  tbFundParam.nType = 0

  if szWnd == self.BUTTON_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BUTTON_PAGE_NOTE then
    local nPageNo = PgSet_GetActivePage(self.UIGROUP, self.PAGESET_MAIN)
    if nPageNo ~= self.nPageSetNo then
      self.nPageSetNo = nPageNo
      --			self.nNotePageNo = self.TONG_NOTE_PAGE_NONE;
      self:Refresh(0) -- 公告内容与列表无关，不用申请成员列表数据
    end
  elseif szWnd == self.BUTTON_AFFICHE or szWnd == self.BUTTON_HISTORY or szWnd == self.BUTTON_EVENT then
    local nNotePageNo = PgSet_GetActivePage(self.UIGROUP, self.PAGESET_NOTE)
    if nNotePageNo ~= self.nNotePageNo then
      self.nNotePageNo = nNotePageNo
      self:Refresh(0)
    end
  elseif szWnd == self.BUTTON_HISTORY_PRE_PAGE then
    if self.nCurHistoryPage < self.nTotleHistoryPage then
      self.nCurHistoryPage = self.nCurHistoryPage + 1
      self:Refresh(0)
    end
  elseif szWnd == self.BUTTON_HISTORY_NEXT_PAGE then
    if self.nCurHistoryPage > 1 then
      self.nCurHistoryPage = self.nCurHistoryPage - 1
      self:Refresh(0)
    end
  elseif szWnd == self.BUTTON_EVENT_PRE_PAGE then
    if self.nCurEventPage < self.nTotleEventPage then
      self.nCurEventPage = self.nCurEventPage + 1
      self:Refresh(0)
    end
  elseif szWnd == self.BUTTON_EVENT_NEXT_PAGE then
    if self.nCurEventPage > 1 then
      self.nCurEventPage = self.nCurEventPage - 1
      self:Refresh(0)
    end
  elseif szWnd == self.BUTTON_PAGE_INFO then
    local nPageNo = PgSet_GetActivePage(self.UIGROUP, self.PAGESET_MAIN)
    if nPageNo ~= self.nPageSetNo then
      self.nPageSetNo = nPageNo
      self:Refresh()
    end
  elseif szWnd == self.BUTTON_PAGE_POSITION then
    local nPageNo = PgSet_GetActivePage(self.UIGROUP, self.PAGESET_MAIN)
    if nPageNo ~= self.nPageSetNo then
      self.nPageSetNo = nPageNo
      self:Refresh()
    end
  elseif szWnd == self.BUTTON_SHOWONLINE then
    self.nShowOnlineFlag = Btn_GetCheck(self.UIGROUP, szWnd)
    self:UpdateMemberList()
  elseif szWnd == self.BUTTON_SHOWHANDUP then
    self.nShowHandUpFlag = Btn_GetCheck(self.UIGROUP, szWnd)
    self:UpdateMemberList()
  elseif szWnd == self.BUTTON_REFRESH then
    self:Refresh()
  elseif szWnd == self.BUTTON_NEXT_PAGE then
    if self.nPageCount < self.nPageNum then
      self.nPageCount = self.nPageCount + 1
    end
    self:ShowPage()
  elseif szWnd == self.BUTTON_PREVIOUS_PAGE then
    if self.nPageCount > 1 then
      self.nPageCount = self.nPageCount - 1
    end
    self:ShowPage()
  elseif szWnd == self.BUTTON_SEARCH then
    local szFindName = Edt_GetTxt(self.UIGROUP, self.EDIT_FINDNAME)
    self:FindNext(szFindName)
  elseif szWnd == self.BUTTON_DEL_KIN then
    UiManager:OpenWindow(Ui.UI_DELETEKIN, self.tbKin, self.tbIndexToId)
  elseif szWnd == self.BUTTON_DISBAND_TONG then
    me.CallServerScript({ "TongCmd", "ApplyDisbandTong" })
  elseif szWnd == self.BUTTON_APOINT_ASSISTANT then
    local nKey = Lst_GetCurKey(self.UIGROUP, self.LIST_MEMBER)
    if nKey == 0 then
      me.Msg("请选择你要任命的成员")
      Txt_SetTxt(self.UIGROUP, self.TEXT_APOINT_A_NAME, "请选择你要任命的成员")
      return 0
    end
    local szAssistant, nAssistantId = self:UpdateEdtAssistantTitle()
    if szAssistant == 0 then
      me.Msg("请选择要任命的职位！")
      return 0
    end
    local tbMember, nKinId, nId = self:KeyToTable(nKey)
    local tbMsg = {}
    tbMsg.szMsg = "你确定要任命" .. tbMember.szName .. "为" .. szAssistant .. "吗？"
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex, nAssistantId, nKinId, nId, fnResetWnd, tbSelf)
      if nOptIndex == 2 then
        me.CallServerScript({ "TongCmd", "ApointAssistant", nAssistantId, nKinId, nId })
        fnResetWnd(tbSelf)
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nAssistantId, nKinId, nId, self.ResetWnd, self)
  elseif szWnd == self.BUTTON_APOINT_EMISSARY then
    local nEmissaryId = Lst_GetCurKey(self.UIGROUP, self.LIST_EMISSARY)
    if (not nEmissaryId) or (nEmissaryId == 0) then
      me.Msg("请选择要任命的掌令使职位")
    end
    local nKey = Lst_GetCurKey(self.UIGROUP, self.LIST_MEMBER)
    if nKey == 0 then
      me.Msg("请选择你要任命的成员")
      Txt_SetTxt(self.UIGROUP, self.TEXT_APOINT_A_NAME, "请选择你要任命的成员")
      return 0
    end
    local nId = nKey % self.QUOTIETY
    local nIndex = (nKey - nId) / self.QUOTIETY
    local nKinId = self.tbIndexToId[nIndex]
    local szTagetPlayer = self.tbMember[nKinId][nId].szName
    local szEmissary = self.pTong.GetEnvoyTitle(nEmissaryId)
    if (not szTagetPlayer) or not szEmissary then
      return 0
    end
    local tbMsg = {}
    tbMsg.szMsg = "你确定要任命" .. szTagetPlayer .. "为" .. szEmissary .. "吗？"
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex, nKinId, nId, nEmissaryId, fnResetWnd, tbSelf)
      if nOptIndex == 2 then
        me.CallServerScript({ "TongCmd", "ApointEmissary", nKinId, nId, nEmissaryId })
        fnResetWnd(tbSelf)
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nKinId, nId, nEmissaryId, self.ResetWnd, self)
  elseif szWnd == self.BUTTON_SAVE_AFFICHE then
    local szAnnounce = Edt_GetTxt(self.UIGROUP, self.EDIT_AFFICHE)
    if #szAnnounce > Tong.ANNOUNCE_MAX_LEN then
      me.Msg("公告字数超过允许的最大长度")
      return 0
    end
    local tbMsg = {}
    tbMsg.szMsg = "你确定要保存公告吗？"
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex, fnResetWnd, fnUpdateAnnounce, tbSelf, szAnnounce)
      if nOptIndex == 2 then
        me.CallServerScript({ "TongCmd", "SaveAnnouce", szAnnounce })
        fnResetWnd(tbSelf)
      elseif nOptIndex == 1 then
        fnUpdateAnnounce(tbSelf)
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, self.ResetWnd, self.UpdateAnnounce, self, szAnnounce)
  elseif szWnd == self.BUTTON_SAVE_ASSISTANT then
    local nAssistantId = Lst_GetCurKey(self.UIGROUP, self.LIST_ASSISTANT)
    if nAssistantId == 0 then
      return 0
    end
    local nPow = self:GetCurPow()
    local szAssistant = Edt_GetTxt(self.UIGROUP, self.EDIT_ASSISTANT_TITLE)
    local tbMsg = {}
    tbMsg.szMsg = "你确定要保存当前职位的设置？"
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex, nAssistantId, nPow, szAssistant, fnResetWnd, tbSelf)
      if nOptIndex == 2 then
        me.CallServerScript({ "TongCmd", "ChangeAssistant", nAssistantId, nPow, szAssistant })
        fnResetWnd(tbSelf)
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nAssistantId, nPow, szAssistant, self.ResetWnd, self)
  elseif szWnd == self.BUTTON_CHANGE_E_TITLE then
    local nEmissaryId = Lst_GetCurKey(self.UIGROUP, self.LIST_EMISSARY)
    if nEmissaryId == 0 then
      return 0
    end
    local szEmissary = Edt_GetTxt(self.UIGROUP, self.EDIT_EMISSARY_TITLE)
    if not szEmissary then
      return 0
    end
    local tbMsg = {}
    tbMsg.szMsg = "你确定要保存掌令使的设置？"
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex, nEmissaryId, szEmissary, fnResetWnd, tbSelf)
      if nOptIndex == 2 then
        me.CallServerScript({ "TongCmd", "ChangeEmissary", nEmissaryId, szEmissary })
        fnResetWnd(tbSelf)
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nEmissaryId, szEmissary, self.ResetWnd, self)
  elseif szWnd == self.BUTTON_FIRE_EMISSARY then
    local nKey = Lst_GetCurKey(self.UIGROUP, self.LIST_EMISSARY_MEMBER)
    if nKey == 0 then
      return 0
    end
    local nId = nKey % self.QUOTIETY
    local nIndex = (nKey - nId) / self.QUOTIETY
    local nKinId = self.tbIndexToId[nIndex]
    if not nKinId then
      return 0
    end
    local tbMember = self.tbMember[nKinId][nId]
    if not tbMember then
      return 0
    end
    local tbMsg = {}
    tbMsg.szMsg = "你确定要卸去" .. tbMember.szName .. "的掌令使职位吗？"
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex, nKinId, nId, fnResetWnd, tbSelf)
      if nOptIndex == 2 then
        me.CallServerScript({ "TongCmd", "FireEmissary", nKinId, nId })
        fnResetWnd(tbSelf)
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nKinId, nId, self.ResetWnd, self)
  elseif szWnd == self.BUTTON_FIRE_ALL_EMISSARY then
    local nKey = Lst_GetCurKey(self.UIGROUP, self.LIST_EMISSARY)
    if nKey == 0 then
      return 0
    end
    local tbMsg = {}
    tbMsg.szMsg = "你确定要卸去" .. self.pTong.GetEnvoyTitle(nKey) .. "掌令使职位下所有成员的职位吗？"
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex, nKey, fnResetWnd, tbSelf)
      if nOptIndex == 2 then
        me.CallServerScript({ "TongCmd", "FireAllEmissary", nKey })
        fnResetWnd(tbSelf)
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nKey, self.ResetWnd, self)
  elseif szWnd == self.BUTTON_SET_WAGE_LEVEL then
    if self.pTong then
      UiManager:OpenWindow(Ui.UI_CHANGEWAGE, self.pTong.GetTakeStock(), self.pTong.GetBuildFund())
    end
  elseif szWnd == self.BUTTON_STORAGE_FUND then
    tbFundParam.szTitle = "资金存入"
    UiManager:OpenWindow(Ui.UI_TEXTINPUT, tbFundParam, "AddFund")
  elseif szWnd == self.BUTTON_GET_FUND then
    tbFundParam.szTitle = "资金取出"
    UiManager:OpenWindow(Ui.UI_TEXTINPUT, tbFundParam, "TakeFund")
  elseif szWnd == self.BUTTON_STORAGE_FUND_TO_KIN then
    local tbShowKinList = {}
    self.tbFundKinList = {}
    local nIt = 4
    for nKinId, tbKin in pairs(self.tbKin) do
      table.insert(tbShowKinList, tbKin.szKinName)
      table.insert(tbShowKinList, nIt)
      self.tbFundKinList[nIt] = nKinId
      nIt = nIt + 1
    end
    DisplayPopupMenu(self.UIGROUP, szWnd, #tbShowKinList / 2, 0, unpack(tbShowKinList))
  --	elseif szWnd == self.BUTTON_DISPENSE then
  --
  --		if (not self.pTong) then
  --			return 0;
  --		end
  --		local tbCrowd = self.pTong.GetCrowdCount(nil);
  --		if not tbCrowd then
  --			return 0;
  --		end
  --		tbCrowd.nType = Tong.DISPENSE_FUND;
  --		UiManager:OpenWindow(Ui.UI_TONGDISPENSE, tbCrowd);
  --		UiManager:OpenWindow(Ui.UI_TONGDISPENSE, tbCrowd);
  elseif szWnd == self.BUTTON_HAND_UP then
    me.CallServerScript({ "TongCmd", "HandUp" })
  elseif szWnd == self.BUTTON_CLEAR_HAND_UP then
    local tbTemp = me.GetTempTable("Tong")
    if tbTemp then
      tbTemp.Tong_tbHandUp = {}
      self.tbHandUp = tbTemp.Tong_tbHandUp
      self:UpdateMemberList()
    end
  elseif szWnd == self.BUTTON_ELECT_MASTER then
    local nKey = Lst_GetCurKey(self.UIGROUP, self.LIST_MEMBER)
    if nKey == 0 then
      me.Msg("请选择你要投票的对象!")
      return 0
    end
    local tbMember, nKinId, nId = self:KeyToTable(nKey)
    local tbMsg = {}
    tbMsg.szMsg = "你确定要投票给" .. tbMember.szName .. "吗？"
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex, nKinId, nId, fnResetWnd, tbSelf)
      if nOptIndex == 2 then
        me.CallServerScript({ "TongCmd", "ElectMaster", nKinId, nId })
        fnResetWnd(tbSelf)
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nKinId, nId, self.ResetWnd, self)
  elseif szWnd == self.BUTTON_CHANGE_TITEL then
    DisplayPopupMenu(self.UIGROUP, szWnd, 4, 0, Tong.TITLE_MENU[1], 2, Tong.TITLE_MENU[2], 3, Tong.TITLE_MENU[3], 4, Tong.TITLE_MENU[4], 5)
  elseif szWnd == self.BUTTON_REQUEST_LIST then
    UiManager:OpenWindow(Ui.UI_TONGREQUESTLIST)
  elseif szWnd == self.BUTTON_EDIT_AFFICHE then
    Wnd_SetEnable(self.UIGROUP, self.EDIT_AFFICHE, 1)
    Wnd_SetEnable(self.UIGROUP, self.BUTTON_SAVE_AFFICHE, 1)
  elseif szWnd == self.BUTTON_SEND_TONGMAIL then
    local tbMailReceiveList = {}
    for i = 1, 3 do
      table.insert(tbMailReceiveList, self.SENDMAIL_MENU[i])
      table.insert(tbMailReceiveList, i)
    end
    self.tbMapKinId = {}
    local nIt = 4
    for nKinId, tbKin in pairs(self.tbKin) do
      table.insert(tbMailReceiveList, tbKin.szKinName)
      table.insert(tbMailReceiveList, nIt)
      self.tbMapKinId[nIt] = nKinId
      nIt = nIt + 1
    end
    DisplayPopupMenu(self.UIGROUP, szWnd, #tbMailReceiveList / 2, 0, unpack(tbMailReceiveList))
  elseif szWnd == self.BUTTON_FIRE_LEADER then
    self:FireMaster()
  elseif szWnd == self.BUTTON_SET_C_FUND_LIMIT then
    if not self.pTong then
      return
    end

    local tbParam = {}
    tbParam.szTitle = "建设资金使用上限"
    tbParam.tbTable = self
    tbParam.fnAccept = self.SetBuildFundLimit
    tbParam.varDefault = 0
    tbParam.nType = 0
    tbParam.tbRange = { 0, self.MAX_BUILD_FUND }
    UiManager:OpenWindow(Ui.UI_TEXTINPUT, tbParam)
  elseif szWnd == self.BUTTON_ELECT_GREAT_MEMBER then
    local nKey = Lst_GetCurKey(self.UIGROUP, self.LIST_MEMBER)
    if nKey == 0 then
      me.Msg("请选择你要投票的对象!")
      return 0
    end
    local tbMember, nKinId, nMemberId = self:KeyToTable(nKey)
    local tbMsg = {}
    tbMsg.szMsg = "你确定要投票给" .. tbMember.szName .. "吗？"
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex, nKinId, nMemberId, fnResetWnd, tbSelf)
      if nOptIndex == 2 then
        me.CallServerScript({ "TongCmd", "ElectGreatMember", nKinId, nMemberId })
        fnResetWnd(tbSelf)
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nKinId, nMemberId, self.ResetWnd, self)
  elseif szWnd == self.BUTTON_ANNOUNCE then
    print("OpenWindow(Ui.UI_TONGANNOUNCE)")
    UiManager:OpenWindow(Ui.UI_TONGANNOUNCE)
  end
end

function uiTong:SetBuildFundLimit(szText)
  local nMoney = tonumber(szText)
  local nKinId, nMemberId = me.GetKinMember()
  if not nKinId or not nMemberId or nMoney > self.MAX_BUILD_FUND then
    return
  end
  me.CallServerScript({ "TongCmd", "SetBuildFundLimit", me.dwTongId, nKinId, nMemberId, nMoney })
end

function uiTong:FireMaster()
  if not self.pTong then
    return
  end

  local tbMsg = {}
  tbMsg.szMsg = "你确定要罢免帮主吗？"
  tbMsg.nOptCount = 2
  function tbMsg:Callback(nOptIndex, fnResetWnd, tbSelf)
    if nOptIndex == 2 then
      me.CallServerScript({ "TongCmd", "FireMaster" })
      fnResetWnd(tbSelf)
    end
  end
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, self.ResetWnd, self)
end

function uiTong:OnComboBoxIndexChange(szWnd, nIndex)
  if szWnd == self.CMB_SORTTYPE then
    self.nPageCount = 1
    self:Refresh(1, nIndex)
  end
end

function uiTong:OnListSel(szWnd, nParam)
  if szWnd == self.LIST_MEMBER then
    self:UpdateEdtAName()
  elseif szWnd == self.LIST_ASSISTANT then
    self:UpdateEdtAssistantTitle()
  elseif szWnd == self.LIST_EMISSARY then
    self:UpdateEmissaryMember(nParam)
  elseif szWnd == self.LIST_OFFICIAL then
    self:UpdateOfficial()
  end
end

-- 输入金钱框的统一处理
function uiTong:AcceptFundInput(szMoney, szFunction)
  me.CallServerScript({ "TongCmd", szFunction, tonumber(szMoney) })
end

-- 根据权限按扭的状态获取当前设置的权限
function uiTong:GetCurPow()
  local nPow = 0
  local n = 1
  for i = 1, 16 do
    if i ~= 10 then
      nPow = nPow + Btn_GetCheck(self.UIGROUP, self.BUTTON_POW[i]) * n
    end
    n = n * 2
  end
  return nPow
end

-- 更新与选中长老相关的信息
function uiTong:UpdateEdtAssistantTitle()
  local nKey = Lst_GetCurKey(self.UIGROUP, self.LIST_ASSISTANT)
  if nKey == 0 then
    Edt_SetTxt(self.UIGROUP, self.EDIT_ASSISTANT_TITLE, "")
    return 0, nKey
  end
  if not self.pTong then
    return 0, nKey
  end
  local szAssistant = self.pTong.GetCaptainTitle(nKey)
  if not szAssistant then
    return 0, nKey
  end
  Edt_SetTxt(self.UIGROUP, self.EDIT_ASSISTANT_TITLE, szAssistant)
  Txt_SetTxt(self.UIGROUP, self.TEXT_ASSISTANT_NAME, "职位名称：" .. szAssistant)
  Txt_SetTxt(self.UIGROUP, self.TEXT_ASSISTANT_POW, szAssistant .. "的权限")
  self:UpdatePowButton(nKey)
  return szAssistant, nKey
end

-- 根据长老权限设置权限按扭
function uiTong:UpdatePowButton(nAssistantId)
  if not nAssistantId then
    Edt_SetTxt(self.UIGROUP, self.EDIT_ASSISTANT_TITLE, "")
    Txt_SetTxt(self.UIGROUP, self.TEXT_ASSISTANT_NAME, "职位名称：")
    Txt_SetTxt(self.UIGROUP, self.TEXT_ASSISTANT_POW, "职位权限:")
    for i = 1, 16 do
      if i ~= 10 then
        Wnd_SetEnable(self.UIGROUP, self.BUTTON_POW[i], 0)
      end
    end
  end
  for i = 1, 16 do
    if i ~= 10 then
      Btn_Check(self.UIGROUP, self.BUTTON_POW[i], self.pTong.GetCaptainPower(nAssistantId, i))
    end
  end
  return 1
end

-- 更新长老名称编辑框的显示
function uiTong:UpdateEdtAName()
  local nKey = Lst_GetCurKey(self.UIGROUP, self.LIST_MEMBER)
  local tbMember
  if nKey ~= 0 then
    tbMember = self:KeyToTable(nKey)
  end
  if not tbMember then
    Txt_SetTxt(self.UIGROUP, self.TEXT_APOINT_A_NAME, "请选择你要任命的成员")
    return 0
  end
  Txt_SetTxt(self.UIGROUP, self.TEXT_APOINT_A_NAME, tbMember.szName)
  return tbMember.szName, tbMember.nFigure
end

-- 响应弹出菜单的选择动作
function uiTong:OnMenuItemSelected(szWnd, nItemId, nParam)
  if szWnd == self.BUTTON_CHANGE_TITEL then
    if (nItemId >= 2) and (nItemId <= 5) then
      local tbParam = {}
      tbParam.szTitle = "输入新的称号"
      tbParam.tbTable = self
      tbParam.fnAccept = self.OnChangeTitle
      UiManager:OpenWindow(Ui.UI_TEXTINPUT, tbParam, nItemId)
    end
  elseif szWnd == self.LIST_MEMBER then
    local szPlayerName = self:GetPlayerNameFromListIndex(nParam)
    if szPlayerName and nItemId > 0 and nItemId <= #self.MEMBER_MENU_ITEM then --要定义一个枚举与每项菜单对应
      if nItemId == 1 then
        if me.szName == szPlayerName then
          me.Msg("不能密聊自己!")
          return 0
        end
        ChatToPlayer(szPlayerName)
      elseif nItemId == 2 then
        if me.szName == szPlayerName then
          me.Msg("不能加自己做队友!")
          return 0
        end
        me.TeamInvite(0, szPlayerName)
      elseif nItemId == 3 then
        if me.szName == szPlayerName then
          me.Msg("不能加自己做好友!")
          return 0
        end
        me.CallServerScript({ "RelationCmd", "AddRelation_C2S", szPlayerName, Player.emKPLAYERRELATION_TYPE_TMPFRIEND })
      elseif nItemId == 4 then
        local nKey = Lst_GetCurKey(self.UIGROUP, self.LIST_MEMBER)
        if nKey == 0 then
          me.Msg("请选择你要投票的对象!")
          return 0
        end
        local tbMember, nKinId, nId = self:KeyToTable(nKey)
        local tbMsg = {}
        tbMsg.szMsg = "你确定要投票给" .. tbMember.szName .. "吗？"
        tbMsg.nOptCount = 2
        function tbMsg:Callback(nOptIndex, nKinId, nId, fnResetWnd, tbSelf)
          if nOptIndex == 2 then
            me.CallServerScript({ "TongCmd", "ElectMaster", nKinId, nId })
            fnResetWnd(tbSelf)
          end
        end
        UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nKinId, nId, self.ResetWnd, self)
      elseif nItemId == 5 then
        local nKey = Lst_GetCurKey(self.UIGROUP, self.LIST_MEMBER)
        if nKey == 0 then
          me.Msg("请选择你要投票的对象!")
          return 0
        end
        local tbMember, nKinId, nMemberId = self:KeyToTable(nKey)
        local tbMsg = {}
        tbMsg.szMsg = "你确定要投票给" .. tbMember.szName .. "吗？"
        tbMsg.nOptCount = 2
        function tbMsg:Callback(nOptIndex, nKinId, nMemberId, fnResetWnd, tbSelf)
          if nOptIndex == 2 then
            me.CallServerScript({ "TongCmd", "ElectGreatMember", nKinId, nMemberId })
            fnResetWnd(tbSelf)
          end
        end
        UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nKinId, nMemberId, self.ResetWnd, self)
      end
    end
  elseif szWnd == self.BUTTON_SEND_TONGMAIL then
    local tbParam = {}
    tbParam.szMailType = "Tong"
    local tbCrowdCount = {}
    tbCrowdCount = self.pTong.GetCrowdCount(1)
    local nKinCount, nMemberCount = self.pTong.GetMemberCount()
    if nItemId >= 1 and nItemId <= 3 then
      tbParam.szReceive = self.SENDMAIL_MENU[nItemId]
      tbParam.nGroupId = 0
      local nKinId, nMemberId = me.GetKinMember()
      local pTong = KTong.GetSelfTong()
      local cKin = pTong.GetKin(nKinId)
      if not cKin then
        return
      end
      local cMember = cKin.GetMember(nMemberId)
      if not cMember then
        return
      end

      tbParam.nItemId = nItemId
      if nItemId == 1 then
        tbParam.nCountNumber = tbCrowdCount[1]
        if cMember.GetFigure() == 1 then
          tbParam.nCountNumber = tbParam.nCountNumber - 1
        end
      elseif nItemId == 2 then
        tbParam.nCountNumber = tbCrowdCount[2]
        if cMember.GetEnvoyFigure() ~= 0 then
          tbParam.nCountNumber = tbParam.nCountNumber - 1
        end
      else
        tbParam.nCountNumber = nMemberCount - 1
      end
    elseif nItemId > 3 and nItemId <= 3 + nKinCount then
      local nKinID = self.tbMapKinId[nItemId]
      tbParam.szReceive = self.tbKin[nKinID].szKinName
      tbParam.nGroupId = nKinID
      tbParam.nItemId = nItemId
      tbParam.nCountNumber = self.m_tbEachKinCount[nKinID]
      local nKinId = me.GetKinMember()
      if nKinId == nKinID then
        tbParam.nCountNumber = tbParam.nCountNumber - 1
      end
    else
      return
    end
    UiManager:OpenWindow(Ui.UI_GROUPMAILNEW, tbParam)
  elseif szWnd == self.BUTTON_STORAGE_FUND_TO_KIN then
    if nItemId > 0 then
      local nKinId = self.tbFundKinList[nItemId]
      self:StorageFundToKin(nKinId)
    end
  end
end

function uiTong:OnChangeTitle(szTitle, nTitleType)
  --	local nLen = #szTitle;
  --	if nLen > 8 then
  --		me.Msg("称号不能大于4汉字的长度");
  --		return 0
  --	end
  --称号名字合法性检查
  if KUnify.IsNameWordPass(szTitle) ~= 1 then
    me.Msg("称号只能包含中文简繁体字及· 【 】符号！")
    return 0
  end
  me.CallServerScript({ "TongCmd", "ChangeTitle", nTitleType, szTitle })
end

-- 查询
function uiTong:FindNext(szFindName)
  local nKey = Lst_GetCurKey(self.UIGROUP, self.LIST_MEMBER)
  local nBegin
  if nKey == 0 then
    nBegin = 1
  else
    local tbMember = self:KeyToTable(nKey)
    if not tbMember then
      return 0
    end
    nBegin = tbMember.nIndex
  end
  local nSize = #self.tbView
  local bIsFind = 0
  for i = nBegin, nBegin + nSize do
    local nIndex = i % nSize + 1
    local pMember = self.tbMember[self.tbView[nIndex].nKinId][self.tbView[nIndex].nMemberId]
    if string.find(pMember.szName, szFindName) then
      self.nPageCount = math.floor((nIndex - 1) / self.NUM_PER_PAGE) + 1
      self:ShowPage()
      Lst_SetCurKey(self.UIGROUP, self.LIST_MEMBER, pMember.nListKey)
      bIsFind = 1
      break
    end
  end
  if bIsFind == 0 then
    me.Msg("找不到该名字的成员！")
  end
end

-- 刷新数据
-- bRefreshMember为是否更新成员列表，1为更新， 0为不更新，默认（不填）更新；
-- nSortType为申请的排序类型，默认（不填）为当前类型（self.m_nSortType）
function uiTong:Refresh(bRefreshMember, nSortType)
  if not bRefreshMember then
    bRefreshMember = 1
  end
  if not nSortType then
    nSortType = self.nSortType
  end
  if bRefreshMember == 1 then
    KTong.ApplyMemberData(nSortType)
  end
  if self.nPageSetNo == Tong.NO_PAGE_TONG_INFO then
    KTong.ApplyBaseInfo()
  elseif self.nPageSetNo == Tong.NO_PAGE_TONG_POSITION then
    KTong.ApplyFigureData()
  elseif self.nPageSetNo == Tong.NO_PAGE_TONG_NOTE then
    if self.nNotePageNo == Tong.TONG_NOTE_PAGE_AFFICHE then
      self:UpdateAnnounce()
      KTong.ApplyNoteData()
    elseif self.nNotePageNo == Tong.TONG_NOTE_PAGE_HISTORY then
      KTong.ApplyHistoryData(tonumber(self.nCurHistoryPage), 1)
    elseif self.nNotePageNo == Tong.TONG_NOTE_PAGE_EVENT then
      KTong.ApplyHistoryData(tonumber(self.nCurEventPage), 0)
    end
  end
end

-- 刷新成员列表
function uiTong:UpdateMemberList()
  self.tbView = {}
  if not self.pTong then
    Lst_Clear(self.UIGROUP, self.LIST_MEMBER)
    self:UpdateEdtAName()
    return
  end

  if self.nSortType == Tong.SORT_VOTED then
    for nKinId, tbKin in pairs(self.tbKin) do
      local tbItem = {}
      tbItem.nKey = tbKin.nVote + (tbKin.nJourNum / 10) -- 附加数量以排序（9个家族,nJourNum）应该不会超过9
      tbItem.nKinId = nKinId
      tbItem.nMemberId = tbKin.nCaptainId
      if self.tbHandUp[nKinId] and self.tbHandUp[nKinId][nMemberId] then
        tbItem.nHandUp = 1
      end
      self.tbMember[nKinId][tbKin.nCaptainId].nData = tbKin.nVote
      setmetatable(tbItem, self.tbSort[self.nSortType])
      table.insert(self.tbView, tbItem)
    end
  else
    for nKinId, tbMember in pairs(self.tbMember) do
      for nMemberId, tbInfo in pairs(tbMember) do
        local nFlag = 0
        if (self.nShowOnlineFlag == 0 or tbInfo.nOnline ~= 0 or tbInfo.nGBOnline == 1) and (self.nShowHandUpFlag == 0) then
          nFlag = 1
        elseif (self.nShowOnlineFlag == 0 or tbInfo.nOnline ~= 0 or tbInfo.nGBOnline == 1) and (self.tbHandUp[nKinId] and self.tbHandUp[nKinId][nMemberId]) then
          nFlag = 1
        end
        if nFlag ~= 0 then
          local tbItem = {}
          tbItem.nKey = tbInfo.nData
          tbItem.nKinId = nKinId
          tbItem.nMemberId = nMemberId
          if self.nSortType == Tong.SORT_STOCK then
            tbItem.nStockFigure = tbInfo.nStockFigure --记录股权职位
          end

          if self.tbHandUp[nKinId] and self.tbHandUp[nKinId][nMemberId] then
            tbItem.nHandUp = 1
          end
          setmetatable(tbItem, self.tbSort[self.nSortType])
          table.insert(self.tbView, tbItem)
        end
      end
    end
  end
  -- 按nData做KEY排列
  --Lib:ShowTB(self.tbView);
  table.sort(self.tbView)

  --修正页数
  local nTableSize = #self.tbView
  self.nPageNum = math.ceil(nTableSize / self.NUM_PER_PAGE)
  if self.nPageNum < 1 then
    self.nPageNum = 1
    self.nPageCount = 1
    Lst_Clear(self.UIGROUP, self.LIST_MEMBER)
    return 0
  end

  if self.nPageCount < 1 then
    self.nPageCount = 1
  elseif self.nPageCount > self.nPageNum then
    self.nPageCount = self.nPageNum
  end

  self:ShowPage()
end

function uiTong:ShowPage()
  local nTableSize = #self.tbView
  Txt_SetTxt(self.UIGROUP, self.TEXT_PAGE_NUMBER, " " .. self.nPageCount .. "/" .. self.nPageNum .. " ")
  local nSize = 0

  if self.nSortType == Tong.SORT_VOTED then
    nSize = math.min(3, nTableSize)
  else
    nSize = math.min((self.nPageCount * self.NUM_PER_PAGE), nTableSize)
  end

  Lst_Clear(self.UIGROUP, self.LIST_MEMBER)
  self:UpdateEdtAName()

  for i = (self.nPageCount - 1) * self.NUM_PER_PAGE + 1, nSize do
    local pMember = self.tbMember[self.tbView[i].nKinId][self.tbView[i].nMemberId]
    pMember.nIndex = i --	搜索之用

    Lst_SetCell(self.UIGROUP, self.LIST_MEMBER, pMember.nListKey, 1, i)
    Lst_SetCell(self.UIGROUP, self.LIST_MEMBER, pMember.nListKey, 2, pMember.szName)
    Lst_SetCell(self.UIGROUP, self.LIST_MEMBER, pMember.nListKey, 3, self:GetSortDataString(pMember.nData))

    -- 如果按股权排列
    if self.nSortType == Tong.SORT_STOCK then
      Lst_SetCell(self.UIGROUP, self.LIST_MEMBER, pMember.nListKey, 4, self:GetStockFigureName(pMember.nStockFigure, pMember.nData))
    else
      Lst_SetCell(self.UIGROUP, self.LIST_MEMBER, pMember.nListKey, 4, self.tbKin[self.tbView[i].nKinId].szKinName)
    end

    -- 给予举手的成员颜色
    if self.tbView[i].nHandUp then
      Lst_SetLineColor(self.UIGROUP, self.LIST_MEMBER, pMember.nListKey, 0xff80FFFF)
    elseif pMember.nOnline ~= 0 then
      Lst_SetLineColor(self.UIGROUP, self.LIST_MEMBER, pMember.nListKey, 0xffFFFFFF)
    elseif pMember.nGBOnline == 1 and pMember.nOnline == 0 then
      --跨服在线
      Lst_SetLineColor(self.UIGROUP, self.LIST_MEMBER, pMember.nListKey, 0x007d6fac)
    else
      Lst_SetLineColor(self.UIGROUP, self.LIST_MEMBER, pMember.nListKey, 0xff808080)
    end
  end
end

function uiTong:GetSortDataString(nData)
  local szReturn
  self.pTong = KTong.GetSelfTong()
  if self.nSortType == Tong.SORT_POSITION then
    if nData == Tong.TONG_FIGURE_MASTER then
      szReturn = "帮主"
    elseif nData <= Tong.TONG_FIGURE_CAPTAIN_END then
      szReturn = "长老"
    elseif nData <= Tong.TONG_FIGURE_ENVOY_END then
      szReturn = "掌令使"
    elseif nData == Tong.TONG_FIGURE_EXCELLENCT then
      szReturn = "精英帮众"
    elseif nData <= Tong.TONG_FIGURE_NORMAL then
      szReturn = "正式帮众"
    elseif nData == Tong.TONG_FIGURE_SIGNED then
      szReturn = "记名帮众"
    elseif nData == Tong.TONG_FIGURE_RETIRE then
      szReturn = "荣誉帮众"
    else
      szReturn = ""
    end
  elseif self.nSortType == Tong.SORT_STOCK then
    if not self.pTong.GetTotalStock() or self.pTong.GetTotalStock() == 0 then
      szReturn = "0%"
    else
      szReturn = string.format("%0.2f%%", nData / self.pTong.GetTotalStock() * 100)
    end
  else
    szReturn = "" .. nData
  end
  return szReturn
end

-- 获得股权职位名字
function uiTong:GetStockFigureName(nStockFigure, nPesonalStock)
  local szReturn
  if nStockFigure == Tong.NONE_STOCK_RIGHT then
    if not nPesonalStock or nPesonalStock <= 0 then
      szReturn = "普通成员"
    else
      szReturn = "股东"
    end
  elseif nStockFigure == Tong.PRESIDENT then
    szReturn = "首领"
  elseif nStockFigure == Tong.DIRECTORATE then
    szReturn = "股东会成员"
  elseif nStockFigure == Tong.PRESIDENT_CANDIDATE then
    szReturn = "首领候选人"
  else
    szReturn = ""
  end
  return szReturn
end

--更新基本数据
function uiTong:UpdateBaseInfo()
  local pTong = KTong.GetSelfTong()
  if not pTong then
    self:InitBaseInfo()
    return
  end

  self.pTong = pTong
  Txt_SetTxt(self.UIGROUP, self.TEXT_NAME, "帮会：" .. self.pTong.GetName())

  local nMasterKinId = self.pTong.GetMaster()
  local nKinId = self.pTong.GetPresidentKin()
  local nPresidentId = self.pTong.GetPresidentMember()
  if self.tbKin[nKinId] then
    if self.tbMember[nKinId] and self.tbMember[nKinId][nPresidentId] then
      Txt_SetTxt(self.UIGROUP, self.TEXT_PRESIDENT, "首领：" .. self.tbMember[nKinId][nPresidentId].szName)
    else
      Txt_SetTxt(self.UIGROUP, self.TEXT_PRESIDENT, "首领：")
    end
  end

  if self.tbKin[nMasterKinId] then
    local nMasterId = self.tbKin[nMasterKinId].nCaptainId
    if nMasterId and self.tbMember[nMasterKinId][nMasterId] then
      Txt_SetTxt(self.UIGROUP, self.TEXT_LEADER, "帮主：" .. self.tbMember[nMasterKinId][nMasterId].szName)
    end
  end

  local nCamp = self.pTong.GetCamp()
  if nCamp >= 1 and nCamp <= 3 then
    Txt_SetTxt(self.UIGROUP, self.TEXT_CAMP, "阵营：" .. Tong.CAMP[nCamp])
  end
  local nKinNum, nMemberNum = self.pTong.GetMemberCount()
  Txt_SetTxt(self.UIGROUP, self.TEXT_LEAGUE, "联盟：" .. self.pTong.GetUnionName())
  Txt_SetTxt(self.UIGROUP, self.TEXT_KIN_NUM, "家族数：" .. nKinNum)
  Txt_SetTxt(self.UIGROUP, self.TEXT_MEMBER_NUM, "成员数：" .. nMemberNum)

  Txt_SetTxt(self.UIGROUP, self.TEXT_TONG_FUND, "帮会资金：" .. self.pTong.GetMoneyFund())
  Txt_SetTxt(self.UIGROUP, self.TEXT_CONSTRUCT_FUND, "建设资金：" .. self.pTong.GetBuildFund())
  Txt_SetTxt(self.UIGROUP, self.TEXT_WAGE_INDEX, "分红比例：" .. self.pTong.GetTakeStock() .. "%")
  Txt_SetTxt(self.UIGROUP, self.TEXT_GREAT_BOUNS, "奖励基金：" .. self.pTong.GetGreatBonus())

  Txt_SetTxt(self.UIGROUP, self.TEXT_TONG_REPUTE, "帮会总威望：" .. self.pTong.GetTotalRepute())
  Txt_SetTxt(self.UIGROUP, self.TEXT_ACTION, "帮会行动力：" .. self.pTong.GetEnergy())

  Txt_SetTxt(self.UIGROUP, self.TEXT_PERSONAL_REPUTE, "生产效率：" .. me.GetProductivity())
  if self.pTong.GetTotalStock() ~= 0 then
    Txt_SetTxt(self.UIGROUP, self.TEXT_PERSONAL_CONTRIBUTE, "个人资产：" .. math.floor(self.pTong.GetBuildFund() * me.GetPlayerStock() / self.pTong.GetTotalStock()))
  else
    Txt_SetTxt(self.UIGROUP, self.TEXT_PERSONAL_CONTRIBUTE, "个人资产：0")
  end
end

function uiTong:KeyToTable(nKey)
  local nId = nKey % self.QUOTIETY
  local nIndex = (nKey - nId) / self.QUOTIETY
  local nKinId = self.tbIndexToId[nIndex]
  return self.tbMember[nKinId][nId], nKinId, nId
end

function uiTong:ResetWnd()
  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    return
  end
  Wnd_SetEnable(self.UIGROUP, self.BUTTON_SAVE_AFFICHE, 0)
  Wnd_SetEnable(self.UIGROUP, self.EDIT_AFFICHE, 0)
end

-- 更新显示所有家族成员信息
function uiTong:UpdateAllKinInfo(nSortType)
  if not nSortType then
    nSortType = self.nSortType
  end

  -- 实际排序数据到达才进行换标题
  if nSortType == Tong.SORT_POSITION then
    Txt_SetTxt(self.UIGROUP, self.TEXT_MEMBERLIST_TITLE, "  排名        姓名           职位        家族名")
  elseif nSortType == Tong.SORT_REPUTE then
    Txt_SetTxt(self.UIGROUP, self.TEXT_MEMBERLIST_TITLE, "  排名        姓名           威望        家族名")
  elseif nSortType == Tong.SORT_VOTED then
    Txt_SetTxt(self.UIGROUP, self.TEXT_MEMBERLIST_TITLE, "  排名        姓名         帮主票数      家族名")
  elseif nSortType == Tong.SORT_STOCK then
    Txt_SetTxt(self.UIGROUP, self.TEXT_MEMBERLIST_TITLE, "  股权排名    姓名         股权比例      职位  ")
  elseif nSortType == Tong.SORT_GREAT_MEMBER_VOTED then
    Txt_SetTxt(self.UIGROUP, self.TEXT_MEMBERLIST_TITLE, "  排名        姓名         优秀票数      家族名")
  else
    return 0
  end
  self.nSortType = nSortType
  self.pTong = KTong.GetSelfTong()
  self:SetButtonStates()
  self.tbMember = {}
  self.tbIndexToId = {}
  self.tbKin = {}
  self.tbFigure = {}
  self.tbEmissary = {}
  self.m_tbEachKinCount = {}
  local pKinIt = self.pTong.GetKinItor()
  local pCurKin = pKinIt.GetCurKin()
  local nIndex = 1
  while pCurKin do
    local nKinId = pKinIt.GetCurKinId()
    assert(nKinId)
    self.tbMember[nKinId] = {}
    self.tbKin[nKinId] = {}
    self.tbIndexToId[nIndex] = nKinId -- 建立映射表
    self.tbKin[nKinId].szKinName = pCurKin.GetName() -- 缓存家族名称
    self.tbKin[nKinId].nCaptainId = pCurKin.GetCaptain() -- 缓存族长ID
    self.tbKin[nKinId].nVote = pCurKin.GetTongVoteBallot() -- 缓存各家族票数
    self.tbKin[nKinId].nJourNum = pCurKin.GetTongVoteJourNum()
    local nRegular, nSigned, nRetire, nCaptain, nAssistant = pCurKin.GetMemberCount()
    self.m_tbEachKinCount[nKinId] = nRegular + nSigned + nRetire
    local pMemberIt = pCurKin.GetMemberItor()
    local pMember = pMemberIt.GetCurMember()
    --缓存成员信息
    while pMember do
      local nMemberId = pMemberIt.GetCurMemberId()
      assert(nMemberId)
      self.tbMember[nKinId][nMemberId] = {}
      self.tbMember[nKinId][nMemberId].szName = pMember.GetName()
      self.tbMember[nKinId][nMemberId].nListKey = nIndex * self.QUOTIETY + nMemberId -- 保存列表内用的KEY值
      self.tbMember[nKinId][nMemberId].nLevel = pMember.GetLevel()
      self.tbMember[nKinId][nMemberId].nHonor = pMember.GetHonor()
      self.tbMember[nKinId][nMemberId].nHonorRank = pMember.GetHonorRank()
      self.tbMember[nKinId][nMemberId].nSex = pMember.GetSex()
      self.tbMember[nKinId][nMemberId].nFigure = pMember.GetFigure() * 1000 --乘1000为了职位排序能区分家族职位和帮会职位的大小
      if self.tbMember[nKinId][nMemberId].nFigure == 1000 then --如果为族长，职位定义改变
        local nFigure = pCurKin.GetTongFigure()
        if nFigure ~= 0 then
          self.tbFigure[nFigure] = self.tbMember[nKinId][nMemberId].nListKey -- 职位表与key建立映射
        else
          nFigure = 20
        end
        self.tbMember[nKinId][nMemberId].nFigure = nFigure
      elseif pMember.GetEnvoyFigure() ~= 0 then
        local nEnvoy = pMember.GetEnvoyFigure()
        self.tbMember[nKinId][nMemberId].nFigure = nEnvoy + 20
        if not self.tbEmissary[nEnvoy] then
          self.tbEmissary[nEnvoy] = {} -- 建立掌令使与key的映射表
        end
        local nKey = self.tbMember[nKinId][nMemberId].nListKey
        self.tbEmissary[nEnvoy][nKey] = 1 -- 暂时……
      elseif pMember.GetBitExcellent() == 1 then
        self.tbMember[nKinId][nMemberId].nFigure = Tong.TONG_FIGURE_EXCELLENCT
      end

      self.tbMember[nKinId][nMemberId].nOnline = pMember.GetOnline()
      self.tbMember[nKinId][nMemberId].nGBOnline = pMember.GetGBOnline()
      self.tbMember[nKinId][nMemberId].nLevel = pMember.GetLevel()
      self.tbMember[nKinId][nMemberId].nHonor = pMember.GetHonor()
      self.tbMember[nKinId][nMemberId].nHonorRank = pMember.GetHonorRank()
      self.tbMember[nKinId][nMemberId].nFaction = pMember.GetFaction()
      self.tbMember[nKinId][nMemberId].nSex = pMember.GetSex()

      if self.nSortType == Tong.SORT_POSITION then
        self.tbMember[nKinId][nMemberId].nData = self.tbMember[nKinId][nMemberId].nFigure
      elseif self.nSortType == Tong.SORT_REPUTE then
        self.tbMember[nKinId][nMemberId].nData = pMember.GetClientRepute()
      elseif self.nSortType == Tong.SORT_VOTED then
        self.tbMember[nKinId][nMemberId].nData = pMember.GetBallot()
      elseif self.nSortType == Tong.SORT_STOCK then
        self.tbMember[nKinId][nMemberId].nData = pMember.GetPersonalStock()
        self.tbMember[nKinId][nMemberId].nStockFigure = pMember.GetStockFigure()
      elseif self.nSortType == Tong.SORT_GREAT_MEMBER_VOTED then
        self.tbMember[nKinId][nMemberId].nData = pMember.GetGreatMemberVote()
      else
        self.tbMember[nKinId][nMemberId].nData = 0
      end

      pMember = pMemberIt.NextMember()
    end
    --Lib:ShowTB(self.tbMember[nKinId])
    pCurKin = pKinIt.NextKin()
    nIndex = nIndex + 1 -- 家族索引自加
  end
  self:UpdateMemberList()
  if self.nPageSetNo == Tong.NO_PAGE_TONG_INFO then
    self:UpdateBaseInfo()
  elseif self.nPageSetNo == Tong.NO_PAGE_TONG_POSITION then
    self:UpdateFigureInfo()
  end
end

function uiTong:UpdateFigureInfo()
  local pTong = KTong.GetSelfTong()
  if not pTong then
    return
  end

  self.pTong = pTong
  Lst_Clear(self.UIGROUP, self.LIST_ASSISTANT)
  self:UpdateEdtAssistantTitle()

  for i = 2, 15 do -- 14个长老职位
    Lst_SetCell(self.UIGROUP, self.LIST_ASSISTANT, i, 1, self.pTong.GetCaptainTitle(i))
    local nKey = self.tbFigure[i]
    if nKey then
      local tbMember = self:KeyToTable(nKey)
      if tbMember then
        Lst_SetCell(self.UIGROUP, self.LIST_ASSISTANT, i, 2, tbMember.szName)
      end
    end
  end

  Lst_Clear(self.UIGROUP, self.LIST_EMISSARY)

  for i = 1, 14 do -- 14个掌令使
    Lst_SetCell(self.UIGROUP, self.LIST_EMISSARY, i, 1, "" .. i)
    Lst_SetCell(self.UIGROUP, self.LIST_EMISSARY, i, 1, self.pTong.GetEnvoyTitle(i))
  end

  local nEmissaryId = Lst_GetCurKey(self.UIGROUP, self.LIST_EMISSARY)
  self:UpdateEmissaryMember(nEmissaryId)

  Lst_Clear(self.UIGROUP, self.LIST_OFFICIAL)
  self:UpdateOfficial()
end

function uiTong:UpdateEmissaryMember(nEmissaryId)
  if nEmissaryId == 0 then
    Txt_SetTxt(self.UIGROUP, self.TEXT_EMISSARY_MEMBER, "")
    Edt_SetTxt(self.UIGROUP, self.EDIT_EMISSARY_TITLE, szEmissary)
    Lst_Clear(self.UIGROUP, self.LIST_EMISSARY_MEMBER)
  end
  local tbEmissary = self.tbEmissary[nEmissaryId]
  local szEmissary = self.pTong.GetEnvoyTitle(nEmissaryId)
  Txt_SetTxt(self.UIGROUP, self.TEXT_EMISSARY_MEMBER, "[" .. szEmissary .. "]下的成员")
  Edt_SetTxt(self.UIGROUP, self.EDIT_EMISSARY_TITLE, szEmissary)
  Lst_Clear(self.UIGROUP, self.LIST_EMISSARY_MEMBER)
  if tbEmissary then
    for i, j in pairs(tbEmissary) do
      local tbMember = self:KeyToTable(i)
      if tbMember and j == 1 then
        Lst_SetCell(self.UIGROUP, self.LIST_EMISSARY_MEMBER, i, 1, tbMember.szName)
      end
    end
  end
end

function uiTong:UpdateAnnounce()
  local pTong = KTong.GetSelfTong()
  if not pTong then
    return
  end
  self.pTong = pTong
  local szAnnounce = self.pTong.GetAnnounce()
  if not szAnnounce then
    szAnnounce = ""
  end
  Edt_SetTxt(self.UIGROUP, self.EDIT_AFFICHE, szAnnounce)
end

-- 官衔面板相关更新
function uiTong:UpdateOfficial()
  local pTong = KTong.GetSelfTong()
  if not pTong then
    return
  end

  local nPreLevel = pTong.GetPreOfficialLevel()
  for i = 1, Tong.MAX_TONG_OFFICIAL_NUM do
    -- 股份职位
    local szOfficialRankName = Tong.OFFICIAL_RANK_NAME[i] or " "
    Lst_SetCell(self.UIGROUP, self.LIST_OFFICIAL, i, 1, szOfficialRankName)

    -- 角色名
    local nOfficialKinId = pTong.GetOfficialKin(i)
    local nOfficialMemberId = pTong.GetOfficialMember(i)
    if self.tbMember[nOfficialKinId] and self.tbMember[nOfficialKinId][nOfficialMemberId] then
      local pMember = self.tbMember[nOfficialKinId][nOfficialMemberId]
      Lst_SetCell(self.UIGROUP, self.LIST_OFFICIAL, i, 2, pMember.szName)
    end

    -- 官衔名
    local nPersonalLevel = Tong:GetPersonalOfficialLevel(nPreLevel, i)
    local szOfficialTitle = ""
    if nPersonalLevel ~= 0 then
      if i == 1 and Tong.OFFICIAL_TITLE[nPersonalLevel] then
        szOfficialTitle = Tong.OFFICIAL_TITLE[nPersonalLevel]
      elseif i > 1 and Tong.OFFICIAL_TITLE_NP[nPersonalLevel] then
        szOfficialTitle = Tong.OFFICIAL_TITLE_NP[nPersonalLevel]
      end
    end
    Lst_SetCell(self.UIGROUP, self.LIST_OFFICIAL, i, 3, szOfficialTitle)
  end

  local nLevel = pTong.GetOfficialLevel() or 0
  local szNextWeekDescription = "下周帮会官衔信息：\n  <color=yellow>帮会官衔等级： " .. nLevel .. "<color>\n    <color=170,230,130>官职       官衔       维护费用<color>\n<color=white>"
  for i = 1, Tong.MAX_TONG_OFFICIAL_NUM do
    -- 股份职位
    local szOfficialRankName = Tong.OFFICIAL_RANK_NAME[i] or ""
    szNextWeekDescription = szNextWeekDescription .. "  " .. szOfficialRankName

    -- 官衔名
    local nPersonalLevel = Tong:GetPersonalOfficialLevel(nLevel, i)
    local szOfficialTitle = ""
    if nPersonalLevel ~= 0 then
      if i == 1 and Tong.OFFICIAL_TITLE[nPersonalLevel] then
        szOfficialTitle = Tong.OFFICIAL_TITLE[nPersonalLevel]
      elseif i > 1 and Tong.OFFICIAL_TITLE_NP[nPersonalLevel] then
        szOfficialTitle = Tong.OFFICIAL_TITLE_NP[nPersonalLevel]
      end
    end
    szOfficialTitle = Lib:StrFillC(szOfficialTitle, 8, " ")
    szNextWeekDescription = szNextWeekDescription .. "   " .. szOfficialTitle

    -- 官衔维护费用
    local szOfficialCharge = ""
    if Tong.OFFICIAL_CHARGE[nPersonalLevel] then
      szOfficialCharge = string.format("%d", Tong.OFFICIAL_CHARGE[nPersonalLevel])
    end
    szNextWeekDescription = szNextWeekDescription .. "     " .. szOfficialCharge .. "\n"
  end
  szNextWeekDescription = szNextWeekDescription .. "<color>本周设置的帮会官衔等级将在下周一生效，维护费用在新官衔生效时由系统自动扣除。"
  Txt_SetTxt(self.UIGROUP, self.TEXT_OFFICIAL, szNextWeekDescription)
end

function uiTong:UpdateHistory(bIsHistory, nCurPage, nTotlePage)
  local pTong = KTong.GetSelfTong()
  if not pTong then
    return 0
  end

  Lst_Clear(self.UIGROUP, self.LIST_HISTORY)
  Lst_Clear(self.UIGROUP, self.LIST_EVENT)

  local tbHistory = pTong.GetTongHistory()
  local nNum = 1
  local nCellIndex = 1
  local nHistoryYear = 0
  local nEventYear = 0
  while nNum <= #tbHistory do
    local tbRecord = tbHistory[nNum]
    local nTime, szContent = Tong:ParseHistory(tbRecord)
    local nYear = tonumber(os.date("%Y", nTime))
    if nYear > nHistoryYear and bIsHistory == 1 then
      nHistoryYear = nYear
      local szTitle = nYear .. "年:"
      Lst_SetCell(self.UIGROUP, self.LIST_HISTORY, nCellIndex, 1, szTitle)
    elseif nYear > nEventYear and bIsHistory ~= 1 then
      nEventYear = nYear
      local szTitle = nYear .. "年:"
      Lst_SetCell(self.UIGROUP, self.LIST_EVENT, nCellIndex, 1, szTitle)
    else
      local szTime = string.format("%s", os.date("%m月%d日", nTime))
      nNum = nNum + 1
      if bIsHistory == 1 then
        Lst_SetCell(self.UIGROUP, self.LIST_HISTORY, nCellIndex, 1, szTime)
        Lst_SetCell(self.UIGROUP, self.LIST_HISTORY, nCellIndex, 2, szContent)
        self.nCurHistoryPage = nCurPage
        self.nTotleHistoryPage = nTotlePage
        Txt_SetTxt(self.UIGROUP, self.TEXT_HISTORY_PAGE_NUM, (nTotlePage - nCurPage + 1) .. "/" .. nTotlePage)
      else
        Lst_SetCell(self.UIGROUP, self.LIST_EVENT, nCellIndex, 1, szTime)
        Lst_SetCell(self.UIGROUP, self.LIST_EVENT, nCellIndex, 2, szContent)
        self.nCurEventPage = nCurPage
        self.nTotleEventPage = nTotlePage
        Txt_SetTxt(self.UIGROUP, self.TEXT_EVENT_PAGE_NUM, (nTotlePage - nCurPage + 1) .. "/" .. nTotlePage)
      end
    end
    nCellIndex = nCellIndex + 1
  end
end

function uiTong:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_TONG_BASE_INFO, self.UpdateBaseInfo },
    { UiNotify.emCOREEVENT_TONG_ALL_KIN_INFO, self.UpdateAllKinInfo },
    { UiNotify.emCOREEVENT_TONG_FIGURE_INFO, self.UpdateFigureInfo },
    { UiNotify.emCOREEVENT_TONG_ANNOUNCE_INFO, self.UpdateAnnounce },
    { UiNotify.emCOREEVENT_TONGHISTORY, self.UpdateHistory },
  }
  return tbRegEvent
end

function uiTong:StorageFundToKin(nKinId)
  if not nKinId or not self.tbKin or not self.tbKin[nKinId] then
    return
  end
  local szKinName = self.tbKin[nKinId].szKinName
  local tbFundToKinParam = {}
  tbFundToKinParam.tbTable = self
  tbFundToKinParam.fnAccept = self.AcceptFundToKinInput
  tbFundToKinParam.nType = 0
  tbFundToKinParam.szTitle = "帮会资金转存家族"
  tbFundToKinParam.tbRange = { 1, 2000000000 }
  UiManager:OpenWindow(Ui.UI_TEXTINPUT, tbFundToKinParam, nKinId, szKinName)
end

--往家族转存资金
function uiTong:AcceptFundToKinInput(szMoney, nKinId, szKinName)
  local tbMsg = {}
  tbMsg.szMsg = "确定要将<color=yellow>" .. szMoney .. "<color>两帮会资金转移到[<color=yellow>" .. szKinName .. "<color>]家族吗？"
  function tbMsg:Callback(nOptIndex, nKinId, nMoney)
    if nOptIndex == 2 then
      if nMoney <= 0 or nMoney > 2000000000 then
        me.Msg("请输入有效资金数量！")
        return 0
      end
      me.CallServerScript({ "TongCmd", "StorageFundToKin", nMoney, nKinId })
    end
  end
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nKinId, tonumber(szMoney))
end
