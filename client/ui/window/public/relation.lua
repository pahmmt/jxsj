-----------------------------------------------------
--文件名		：	friend.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-04-19
--功能描述		：	人际关系脚本。
------------------------------------------------------

do
  return
end

local uiRelation = Ui.tbWnd[Ui.UI_RELATION] or Ui:GetClass("relation")

uiRelation.LIST_NAME = "ListName"
uiRelation.CLOSE_BUTTON = "BtnClose"
uiRelation.CURRENT_LIST_TEXT = "TxtCurList"
uiRelation.BTN_PRE_PAGE = "BtnLeft"
uiRelation.BTN_NEXT_PAGE = "BtnRight"
uiRelation.TEXT_CUR_PAGE = "TxtPage"
uiRelation.BUTTON_HIDE = "BtnHide"
uiRelation.BUTTON_TEACHER = "BtnTeacher"
uiRelation.BUTTON_ADDFRIEND = "BtnAddFriend"
uiRelation.NUMBER_PER_PAGE = 20
uiRelation.POPUPMUNE_CALLBACK = {}

-- 为了方便遍历uiRelation.PAGES表，以下枚举必须从1开始并且连续
uiRelation.PAGE_FRIENDS = 1
uiRelation.PAGE_ENEMEY = 2
uiRelation.PAGE_BLACKLIST = 3
uiRelation.PAGE_TRAIN = 4
uiRelation.PAGE_BUDDY = 5
uiRelation.PAGE_COUPLE = 6
uiRelation.PAGE_GLOBAL = 7

uiRelation.PAGES = {
  [uiRelation.PAGE_FRIENDS] = "BtnPage1",
  [uiRelation.PAGE_ENEMEY] = "BtnPage2",
  [uiRelation.PAGE_BLACKLIST] = "BtnPage3",
  [uiRelation.PAGE_TRAIN] = "BtnPage4",
  [uiRelation.PAGE_BUDDY] = "BtnPage5",
  [uiRelation.PAGE_COUPLE] = "BtnPage6",
  [uiRelation.PAGE_GLOBAL] = "BtnPage7",
}

uiRelation.tbPageName = {
  [uiRelation.PAGE_FRIENDS] = "BtnPage1",
  [uiRelation.PAGE_ENEMEY] = "BtnPage2",
  [uiRelation.PAGE_BLACKLIST] = "BtnPage3",
  [uiRelation.PAGE_TRAIN] = "BtnPage4",
  [uiRelation.PAGE_BUDDY] = "BtnPage5",
  [uiRelation.PAGE_COUPLE] = "BtnPage6",
  [uiRelation.PAGE_GLOBAL] = "BtnPage7",
}

uiRelation.MENU_ITEM = { " 密聊 ", " 信件 ", " 组队 ", " 删除 ", " 申请拜师  ", " 申请收徒 " }

function uiRelation:Init()
  self.nCurPage = nil
  self.nListCurPage = 1
  self.tbSortList = {}
  self.tbRelationList = {}
  self.tbRelationTypes = {}
end

---------------------------------------------------------
--写log
function uiRelation:WriteStatLog()
  Log:Ui_SendLog("F5人际界面", 1)
end

function uiRelation:OnOpen()
  self:WriteStatLog()
  Ui(Ui.UI_SIDEBAR):WndOpenCloseCallback(self.UIGROUP, 1)
  me.RequestTrainingOption()
  Btn_Check(self.UIGROUP, self.BUTTON_HIDE, GetInvisibleLogin())
  self:UpdatePanel()
end

function uiRelation:OnClose()
  Ui(Ui.UI_SIDEBAR):WndOpenCloseCallback(self.UIGROUP, 0)
end

function uiRelation:OnDelFriendFavor(szPlayer)
  me.Relation_SetRelationInfo(szPlayer, nil)
  self:UpdatePanel()
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

function uiRelation:InsertToBuddyList(tbBuddyList, tbListEx)
  if not tbBuddyList then
    return 0
  end
  if not self.tbRelationTypes then
    self.tbRelationTypes = {}
  end
  if tbListEx then
    for szPlayer, tbRelation in pairs(tbListEx) do
      tbBuddyList[szPlayer] = tbRelation
      if not self.tbRelationTypes[szPlayer] then
        self.tbRelationTypes[szPlayer] = {}
      end
      table.insert(self.tbRelationTypes[szPlayer], tbRelation.nType)
    end
  end
  return tbBuddyList
end

-- 获取某一页的玩家列表
function uiRelation:GetPageData(nPage)
  local tbList = {}
  local tbListEx = {}
  local tbRelationList, tbInfo = me.Relation_GetRelationList()
  if (not tbRelationList) and (nPage ~= self.PAGE_GLOBAL) then
    return
  end
  if nPage == self.PAGE_FRIENDS then
    tbList = self:MergeTable(tbRelationList[Player.emKPLAYERRELATION_TYPE_BIDFRIEND], tbRelationList[Player.emKPLAYERRELATION_TYPE_TMPFRIEND])
    --tbListEx = self:_GetPlayerList(Player.emKPLAYERRELATION_TYPE_INTRODUCTION, 1);	-- nRole = 1 代表是次位
    tbList = self:MergeTable(tbList, tbRelationList[Player.emKPLAYERRELATION_TYPE_INTRODUCTION])

    -- 合并密友、师徒、伴侣
    local tbTmpList1 = self:MergeTable(tbRelationList[Player.emKPLAYERRELATION_TYPE_COUPLE], tbRelationList[Player.emKPLAYERRELATION_TYPE_BUDDY]) -- 伴侣+密友
    local tbTmpList2 = self:MergeTable(tbRelationList[Player.emKPLAYERRELATION_TYPE_TRAINING], tbRelationList[Player.emKPLAYERRELATION_TYPE_TRAINED]) -- 师徒
    tbListEx = self:MergeTable(tbTmpList1, tbTmpList2)
    tbList = self:MergeTable(tbList, tbListEx)
  elseif nPage == self.PAGE_ENEMEY then
    tbList = tbRelationList[Player.emKPLAYERRELATION_TYPE_ENEMEY]
  elseif nPage == self.PAGE_BLACKLIST then
    local tbOrgList = tbRelationList[Player.emKPLAYERRELATION_TYPE_BLACKLIST] or {}
    tbList = Lib:CopyTB1(tbOrgList)
    local tbBlackList = Player.tbGlobalFriends.tbBlackList
    for _k, _v in pairs(tbBlackList) do
      tbList[_v] = { szPlayer = _v }
    end
  elseif nPage == self.PAGE_TRAIN then
    tbList = self:MergeTable(tbRelationList[Player.emKPLAYERRELATION_TYPE_TRAINING], tbRelationList[Player.emKPLAYERRELATION_TYPE_TRAINED])
    -- furuilei 把出师之后的师徒关系也调整到师徒页面显示
    --tbListEx = self:_GetPlayerList(Player.emKPLAYERRELATION_TYPE_TRAINED, 0);
    --tbList = self:MergeTable(tbList, tbListEx);
  elseif nPage == self.PAGE_BUDDY then
    self.tbRelationTypes = {}
    self:InsertToBuddyList(tbList, tbRelationList[Player.emKPLAYERRELATION_TYPE_BUDDY])
    --tbListEx = self:_GetPlayerList(Player.emKPLAYERRELATION_TYPE_TRAINING, 0);	-- nRole = 1 代表是次位
    --self:InsertToBuddyList(tbList, tbListEx);
    -- tbListEx = self:_GetPlayerList(Player.emKPLAYERRELATION_TYPE_TRAINED, 0);	-- nRole = 1 代表是次位
    -- self:InsertToBuddyList(tbList, tbListEx);
    tbListEx = self:_GetPlayerList(Player.emKPLAYERRELATION_TYPE_INTRODUCTION, 0) -- nRole = 1 代表是次位
    self:InsertToBuddyList(tbList, tbListEx)
  elseif nPage == self.PAGE_COUPLE then
    tbList = tbRelationList[Player.emKPLAYERRELATION_TYPE_COUPLE]
  elseif nPage == self.PAGE_GLOBAL then
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
  end
  local tbSortList = self:NormalSort(tbList)
  return tbSortList, tbList
end

-- 比较函数
uiRelation._Cmp = function(pPlayerA, pPlayerB)
  local bRet = 0

  if pPlayerA.nOnline == pPlayerB.nOnline then
    bRet = pPlayerA.nFavor > pPlayerB.nFavor
  else
    bRet = pPlayerA.nOnline > pPlayerB.nOnline
  end
  return bRet
end

function uiRelation:NormalSort(tbList)
  local _, tbInfo = me.Relation_GetRelationList()
  tbInfo = tbInfo or {}
  local tbSortList = {}
  local tbTempFriend = {}

  if tbList then
    for szPlayer, tbRelation in pairs(tbList) do
      local tbItem = {}
      tbItem.szPlayer = szPlayer
      tbItem.nOnline = tbRelation.nOnline

      if tbInfo[szPlayer] then
        tbItem.nFavor = tbInfo[szPlayer].nFavor
        table.insert(tbSortList, tbItem)
      else
        table.insert(tbTempFriend, tbItem)
      end
    end

    if #tbSortList > 1 then
      table.sort(tbSortList, self._Cmp)
    end
  end
  for _, pPlayer in ipairs(tbTempFriend) do
    table.insert(tbSortList, pPlayer)
  end

  return tbSortList
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

function uiRelation:UpdatePanel()
  if not self.nCurPage then
    self.nCurPage = 1
    self.nListCurPage = 1
    Btn_Check(self.UIGROUP, self.PAGES[self.nCurPage], 1)
  end
  if self.nCurPage == self.PAGE_TRAIN then
    Wnd_Show(self.UIGROUP, self.BUTTON_TEACHER)
  else
    Wnd_Hide(self.UIGROUP, self.BUTTON_TEACHER)
  end

  if self.nCurPage == self.PAGE_FRIENDS then
    Btn_SetTxt(self.UIGROUP, self.BUTTON_ADDFRIEND, "输名字添加好友")
    Wnd_Show(self.UIGROUP, self.BUTTON_ADDFRIEND)
  elseif self.nCurPage == self.PAGE_GLOBAL then
    Btn_SetTxt(self.UIGROUP, self.BUTTON_ADDFRIEND, "添加大区好友")
    Wnd_Show(self.UIGROUP, self.BUTTON_ADDFRIEND)
  else
    Wnd_Hide(self.UIGROUP, self.BUTTON_ADDFRIEND)
  end

  local szText = Btn_GetTxt(self.UIGROUP, self.PAGES[self.nCurPage])
  if self.nCurPage == self.PAGE_BLACKLIST then
    Txt_SetTxt(self.UIGROUP, self.CURRENT_LIST_TEXT, "黑名单列表")
  elseif self.nCurPage == self.PAGE_ENEMEY then
    Txt_SetTxt(self.UIGROUP, self.CURRENT_LIST_TEXT, "仇人列表")
  elseif self.nCurPage == self.PAGE_GLOBAL then
    Txt_SetTxt(self.UIGROUP, self.CURRENT_LIST_TEXT, "大区好友列表")
  else
    Txt_SetTxt(self.UIGROUP, self.CURRENT_LIST_TEXT, tostring(szText) .. "列表")
  end

  self.tbSortList, self.tbRelationList = self:GetPageData(self.nCurPage)

  if not self.tbSortList or #self.tbSortList < 1 then
    self:ClearList()
    Txt_SetTxt(self.UIGROUP, self.TEXT_CUR_PAGE, "0")
    return
  end

  local nPlayerCount = #self.tbSortList

  if self.nListCurPage < 1 then -- 调整页码
    self.nListCurPage = 1
    return
  end

  local nCurPageFirstPlayer = (self.nListCurPage - 1) * self.NUMBER_PER_PAGE + 1
  local nCurPageLastPlayer = self.nListCurPage * self.NUMBER_PER_PAGE
  if nPlayerCount < nCurPageFirstPlayer then
    self.nListCurPage = self.nListCurPage - 1
    self:UpdatePanel()
    return
  end

  local nTotalPageCount = 0
  if nPlayerCount > 0 then
    nTotalPageCount = math.ceil(nPlayerCount / self.NUMBER_PER_PAGE)
  end
  Txt_SetTxt(self.UIGROUP, self.TEXT_CUR_PAGE, self.nListCurPage .. "/" .. nTotalPageCount)
  if nPlayerCount < nCurPageLastPlayer then
    nCurPageLastPlayer = nPlayerCount
  end

  assert(nCurPageFirstPlayer <= nCurPageLastPlayer)
  self:ShowHighLight(nCurPageFirstPlayer, nCurPageLastPlayer)
end

function uiRelation:ShowHighLight(nCurPageFirstPlayer, nCurPageLastPlayer)
  self:ClearList()
  local _, tbInfoList = me.Relation_GetRelationList()
  for i = nCurPageFirstPlayer, nCurPageLastPlayer do
    local tbRelation = self.tbRelationList[self.tbSortList[i].szPlayer]
    assert(tbRelation)
    local szBuffer = tbRelation.szPlayer
    -- 高亮显示有点问题
    -- 正式好友的特殊显示处理
    if (tbRelation.nType == Player.emKPLAYERRELATION_TYPE_BIDFRIEND) or (tbRelation.nType == Player.emKPLAYERRELATION_TYPE_INTRODUCTION) or (tbRelation.nType == Player.emKPLAYERRELATION_TYPE_TRAINING) or (tbRelation.nType == Player.emKPLAYERRELATION_TYPE_TRAINED) or (tbRelation.nType == Player.emKPLAYERRELATION_TYPE_COUPLE) or (tbRelation.nType == Player.emKPLAYERRELATION_TYPE_BUDDY) then
      if tbRelation.nOnline == 0 then -- 离线状态
        szBuffer = "<color=0xffB4B4B4>" .. szBuffer
      else
        szBuffer = "<color=0xffffff01>" .. szBuffer
      end
    elseif tbRelation.nType == Player.emKPLAYERRELATION_TYPE_ENEMEY then
      if tbRelation.nOnline == 0 then -- 离线状态
        szBuffer = "<color=0xff828282>" .. szBuffer
      else
        szBuffer = "<color=0xffffffff>" .. szBuffer
      end
    end

    local nKey = i - nCurPageFirstPlayer + 1
    if Sns.bIsOpen == 1 then
      if self.nCurPage ~= self.PAGE_GLOBAL then
        local szButton = string.format("Sns_%02d", nKey)
        Wnd_Show(self.UIGROUP, szButton)
        local tb = tbInfoList[tbRelation.szPlayer]
        local nEnable = (tb and tb.nSnsBind ~= 0 and 1) or 0
        Wnd_SetVisible(self.UIGROUP, szButton, nEnable)
        if Sns.bInGame == 1 and nEnable == 1 then
          if type(Sns.tbHasNewTweet[tbRelation.szPlayer]) == "table" then
            self:BlinkWnd(szButton, 5)
          end
        end
      end
    end
    Lst_SetCell(self.UIGROUP, self.LIST_NAME, nKey, 0, szBuffer)
    Lst_SetLineData(self.UIGROUP, self.LIST_NAME, nKey, i)
  end
end

function uiRelation:BlinkWnd(szWnd, nSecond)
  Img_PlayAnimation(self.UIGROUP, szWnd, 1, 250, 1, 2)
  local function StopAnimation()
    Img_StopAnimation(self.UIGROUP, szWnd)
    return 0
  end
  Ui.tbLogic.tbTimer:Register(18 * nSecond, StopAnimation)
end

function uiRelation:ClearList()
  Lst_Clear(self.UIGROUP, self.LIST_NAME)
  for i = 1, self.NUMBER_PER_PAGE do
    Wnd_Hide(self.UIGROUP, string.format("Sns_%02d", i))
  end
end

function uiRelation:GetRelationTableFromListIndex(nIndex)
  if not self.tbSortList or not self.tbSortList[nIndex] then
    return
  end
  if not self.tbRelationList then
    return
  end
  local tbRelation = self.tbRelationList[self.tbSortList[nIndex].szPlayer]
  return tbRelation
end

function uiRelation:AddFriendByName(szName)
  if IsValidRoleName(szName) == 0 then
    me.Msg("输入的名字不符合规范。")
    return
  end

  AddFriendByName(szName)
end

function uiRelation:AddGlobalFriendByName(szName)
  if IsValidRoleName(szName) == 0 then
    me.Msg("输入的名字不符合规范。")
  end

  Player.tbGlobalFriends:ApplyAddFriend(me.szName, szName)
end

function uiRelation:OnButtonClick(szWnd, nParam)
  if szWnd == self.CLOSE_BUTTON then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_PRE_PAGE then
    self.nListCurPage = self.nListCurPage - 1
    self:UpdatePanel()
  elseif szWnd == self.BTN_NEXT_PAGE then
    self.nListCurPage = self.nListCurPage + 1
    self:UpdatePanel()
  elseif szWnd == self.BUTTON_HIDE then
    SetInvisibleLogin(Btn_GetCheck(self.UIGROUP, self.BUTTON_HIDE))
    Btn_Check(self.UIGROUP, self.BUTTON_HIDE, GetInvisibleLogin())
  elseif szWnd == self.BUTTON_TEACHER then
    local bFlag = Btn_GetCheck(self.UIGROUP, self.BUTTON_TEACHER)
    if bFlag == 1 then
      UiManager:OpenWindow(Ui.UI_TEACHER)
    else
      UiManager:CloseWindow(Ui.UI_TEACHER)
    end
  elseif szWnd == self.BUTTON_ADDFRIEND then
    local tbParam = {}
    tbParam.tbTable = self
    tbParam.fnAccept = self.AddFriendByName
    tbParam.nType = 2
    tbParam.szTitle = "请输入对方名字"
    UiManager:OpenWindow(Ui.UI_TEXTINPUT, tbParam)
  elseif string.sub(szWnd, 1, 4) == "Sns_" then
    if Sns.bIsOpen == 1 then
      local nKey = tonumber(string.sub(szWnd, 5))
      local nIndex = (self.nListCurPage - 1) * self.NUMBER_PER_PAGE + nKey
      local szPlayer = self.tbSortList[nIndex].szPlayer
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
  else
    for i = 1, #self.PAGES do
      if szWnd == self.PAGES[i] then
        if self.nCurPage then
          Btn_Check(self.UIGROUP, self.PAGES[self.nCurPage], 0)
        end
        Btn_Check(self.UIGROUP, self.PAGES[i], 1)
        self.nCurPage = i
        self.nListCurPage = 1
        self:UpdatePanel()
      end
    end
  end
end

function uiRelation:WndOpenCloseCallback(szWnd, nParam)
  if szWnd == Ui.UI_TEACHER then
    Btn_Check(self.UIGROUP, self.BUTTON_TEACHER, nParam)
  end
end

-- Tip
function uiRelation:OnListOver(szWnd, nItemIndex)
  if szWnd == self.LIST_NAME and nItemIndex >= 0 then
    local tbRelationList, tbInfoList = me.Relation_GetRelationList()
    tbInfoList = tbInfoList or {}
    if not tbInfoList then
      return 0
    end
    local nIndex = (self.nListCurPage - 1) * self.NUMBER_PER_PAGE + nItemIndex
    local szPlayer
    if self.tbSortList[nIndex] then
      szPlayer = self.tbSortList[nIndex].szPlayer
    end
    if szPlayer == nil then
      return
    end
    if self.nCurPage == self.PAGE_GLOBAL then
      local szName = "名字：<color=yellow>" .. szPlayer .. "<color>\n"
      local szTip = "\n"
      local tbPlayerInfo = Player.tbGlobalFriends.tbPlayerInfo[szPlayer] or {}
      if tbPlayerInfo.nFaction ~= nil then
        szTip = szTip .. "门派：<color=yellow>" .. Player:GetFactionRouteName(tbPlayerInfo.nFaction) .. "<color>\n"
      else
        szTip = szTip .. "门派：<color=yellow>未知的<color>\n"
      end
      szTip = szTip .. "所在区服：<color=yellow>" .. (GetServerNameByGatewayName(tbPlayerInfo.szGateway or "") or "【未知服务器】") .. "<color>\n"
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
    local tbInfo = tbInfoList[szPlayer]
    if not tbInfo then
      return
    end
    local nLevel = math.ceil(math.sqrt(tbInfo.nFavor / 100))
    local nFavorExpConf = me.GetFavorExpConf(tbInfo.nFavor) / 100
    local nNextLevelFavor = nLevel * nLevel * 100 + 1
    local szName = "名字：<color=yellow>" .. szPlayer .. "<color>\n"
    local szTip = "\n"
    if self.nCurPage == self.PAGE_FRIENDS then
      szTip = szTip .. "门派：<color=yellow>" .. Player:GetFactionRouteName(tbInfo.nFaction) .. "<color>\n"
      szTip = szTip .. "等级：<color=yellow>" .. tbInfo.nLevel .. "级<color>\n"
      szTip = szTip .. "亲密度等级：<color=yellow>" .. nLevel .. "级（" .. tbInfo.nFavor .. "/" .. nNextLevelFavor .. "）<color>\n"
      szTip = szTip .. "组队时好友打怪分得经验加成：<color=yellow>" .. nFavorExpConf .. "倍<color>\n"
    elseif self.nCurPage == self.PAGE_COUPLE then
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
    elseif self.nCurPage == self.PAGE_TRAIN then
      local szRelation = ""
      if self.tbRelationList[szPlayer] == Player.emKPLAYERRELATION_TYPE_TRAINED then
        szRelation = "出师弟子"
      elseif self.tbRelationList[szPlayer].nRole == 0 then
        szRelation = "徒弟"
      else
        szRelation = "师傅"
      end
      szTip = szTip .. "关系：<color=yellow>" .. szRelation .. "<color>\n"
      szTip = szTip .. "门派：<color=yellow>" .. Player:GetFactionRouteName(tbInfo.nFaction) .. "<color>\n"
      szTip = szTip .. "等级：<color=yellow>" .. tbInfo.nLevel .. "级<color>\n"
      szTip = szTip .. "亲密度等级：<color=yellow>" .. nLevel .. "级（" .. tbInfo.nFavor .. "/" .. nNextLevelFavor .. "）<color>\n"
      szTip = szTip .. "组队时好友打怪分得经验加成：<color=yellow>" .. nFavorExpConf .. "倍<color>\n"
    elseif self.nCurPage == self.PAGE_BUDDY then
      local szRelation = ""
      for i = 1, #self.tbRelationTypes[szPlayer] do
        local nType = self.tbRelationTypes[szPlayer][i]
        if szRelation ~= "" then
          szRelation = szRelation .. "，"
        end
        if nType == Player.emKPLAYERRELATION_TYPE_TRAINED or nType == Player.emKPLAYERRELATION_TYPE_TRAINING then
          szRelation = szRelation .. "师徒"
        end
        if Player.emKPLAYERRELATION_TYPE_INTRODUCTION == nType then
          szRelation = szRelation .. "被介绍人"
        end
        if Player.emKPLAYERRELATION_TYPE_BUDDY == nType then
          szRelation = szRelation .. "指定密友"
        end
      end
      szTip = szTip .. "关系：<color=yellow>" .. szRelation .. "<color>\n"
      szTip = szTip .. "门派：<color=yellow>" .. Player:GetFactionRouteName(tbInfo.nFaction) .. "<color>\n"
      szTip = szTip .. "等级：<color=yellow>" .. tbInfo.nLevel .. "级<color>\n"
      szTip = szTip .. "亲密度等级：<color=yellow>" .. nLevel .. "级（" .. tbInfo.nFavor .. "/" .. nNextLevelFavor .. "）<color>\n"
      szTip = szTip .. "组队时好友打怪分得经验加成：<color=yellow>" .. nFavorExpConf .. "倍<color>\n"
    elseif self.nCurPage == self.PAGE_BLACKLIST then
      return
    end
    local szPath = GetPortraitSpr(tbInfo.nPortrait, tbInfo.nSex)
    if not szPath then
      return
    end
    Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, szName, szTip, szPath)
  end
end

function uiRelation:OnListDClick(szWnd, nListItem)
  local nIndex = Lst_GetLineData(self.UIGROUP, self.LIST_NAME, nListItem)
  local tbRelation = self:GetRelationTableFromListIndex(nIndex)
  if tbRelation then
    local nSendMail = UiManager:WindowVisible(Ui.UI_MAILNEW)
    if nSendMail ~= 0 then
      Ui(Ui.UI_MAILNEW):SetReceiver(tbRelation.szPlayer)
    else
      self:CmdWhisper(tbRelation)
    end
  end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--< 右键菜单处理
--  更改了脚本实现之后，右键菜单处理的实现是不安全的，因为某玩家的Id可能这处理过程中就会变
--	解决方案是在脚本中记下处理当前右键选中的玩家的名字，因为同一时间右键菜单肯定只有一个

function uiRelation:OnListRClick(szWnd, nParam)
  if szWnd and nParam then
    local nCount = Lst_GetLineCount(self.UIGROUP, szWnd)
    if nParam > nCount then
      return
    end

    Lst_SetCurKey(self.UIGROUP, szWnd, nParam)
    if self.nCurPage == self.PAGE_TRAIN or self.nCurPage == self.PAGE_COUPLE then
      DisplayPopupMenu(self.UIGROUP, szWnd, 3, nParam, self.MENU_ITEM[1], 1, self.MENU_ITEM[2], 2, self.MENU_ITEM[3], 3)
    elseif self.nCurPage == self.PAGE_BUDDY then
      DisplayPopupMenu(self.UIGROUP, szWnd, 3, nParam, self.MENU_ITEM[1], 1, self.MENU_ITEM[2], 2, self.MENU_ITEM[3], 3)
    elseif self.nCurPage == self.PAGE_FRIENDS then
      local nIndex = Lst_GetLineData(self.UIGROUP, szWnd, nParam)
      local tbRelation = self:GetRelationTableFromListIndex(nIndex)
      if tbRelation then
        if Player.emKPLAYERRELATION_TYPE_TMPFRIEND == tbRelation.nType then
          DisplayPopupMenu(self.UIGROUP, szWnd, 4, nParam, self.MENU_ITEM[1], 1, self.MENU_ITEM[2], 2, self.MENU_ITEM[3], 3, self.MENU_ITEM[4], 4)
          return
        end
        local _, tbInfoList = me.Relation_GetRelationList()
        local tbPlayerInfo = tbInfoList[tbRelation.szPlayer]

        assert(tbPlayerInfo)
        local nLevel = me.nLevel
        DisplayPopupMenu(self.UIGROUP, szWnd, 4, nParam, self.MENU_ITEM[1], 1, self.MENU_ITEM[2], 2, self.MENU_ITEM[3], 3, self.MENU_ITEM[4], 4)
      end
    elseif self.nCurPage == self.PAGE_BLACKLIST then
      DisplayPopupMenu(self.UIGROUP, szWnd, 1, nParam, self.MENU_ITEM[4], 4)
    elseif self.nCurPage == self.PAGE_GLOBAL then
      DisplayPopupMenu(self.UIGROUP, szWnd, 2, nParam, self.MENU_ITEM[1], 1, self.MENU_ITEM[4], 4)
    else
      DisplayPopupMenu(self.UIGROUP, szWnd, 4, nParam, self.MENU_ITEM[1], 1, self.MENU_ITEM[2], 2, self.MENU_ITEM[3], 3, self.MENU_ITEM[4], 4)
    end
  end
end

function uiRelation:CheckMyTeacher()
  local nResult = 0
  local tbList = self:GetPageData(self.PAGE_TRAIN)
  if #tbList > 0 then
    nResult = 1
  end
  return nResult
end

function uiRelation:OnMenuItemSelected(szWnd, nItemId, nListItem)
  local nIndex = Lst_GetLineData(self.UIGROUP, self.LIST_NAME, nListItem)
  local tbRelation = self:GetRelationTableFromListIndex(nIndex)
  if tbRelation and nItemId > 0 and nItemId <= 6 then -- 6为右键菜单的最大项数，要定义一个枚举与每项菜单对应
    self.POPUPMUNE_CALLBACK[nItemId](self, tbRelation)
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

function uiRelation:CmdDelFriend(tbPlayer)
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

function uiRelation:CmdApplyTeacher(tbPlayer) end

function uiRelation:CmdApplyStudent(tbPlayer) end

uiRelation.POPUPMUNE_CALLBACK[1] = uiRelation.CmdWhisper
uiRelation.POPUPMUNE_CALLBACK[2] = uiRelation.CmdMail
uiRelation.POPUPMUNE_CALLBACK[3] = uiRelation.CmdInviteTeam
uiRelation.POPUPMUNE_CALLBACK[4] = uiRelation.CmdDelFriend
uiRelation.POPUPMUNE_CALLBACK[5] = uiRelation.CmdApplyTeacher
uiRelation.POPUPMUNE_CALLBACK[6] = uiRelation.CmdApplyStudent

-- 右键菜单处理

function uiRelation:OnRefreshTraining()
  Ui(Ui.UI_TEACHER):RefreshTraining()
end

function uiRelation:OnRelationOnline(szPlayer, nType, nRole, bOnline)
  me.Relation_SetOnlineState(szPlayer, bOnline)
  self:UpdatePanel()
  if bOnline == 1 then
    me.Msg(szPlayer .. "上线了！")
  else
    me.Msg(szPlayer .. "下线了！")
  end
end

function uiRelation:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_RELATION_UPDATEPANEL, self.UpdatePanel },
    { UiNotify.emCOREEVENT_RELATION_REFRESHTRAIN, self.OnRefreshTraining },
    { UiNotify.emCOREEVENT_RELATION_ONLINE, self.OnRelationOnline },
  }
  return tbRegEvent
end
