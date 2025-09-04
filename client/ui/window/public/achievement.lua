--=================================================
-- 文件名　：achievement.lua
-- 创建者　：furuilei
-- 创建时间：2010-07-15 16:39:30
-- 功能描述：成就系统界面
--=================================================

local uiAchievement = Ui:GetClass("achievement")

uiAchievement.MAXCOUNT_PAGE = 10

-- 模式，1表示是查看自己的成就，2表示是和别人的成就对比
uiAchievement.VIEWMODE_SELF = 1
uiAchievement.VIEWMODE_OTHER = 2

-- 选择查看模式，1表示显示所有成就，2表示显示已完成成就，3表示显示未完成成就
uiAchievement.SELECTMODE_ALL = 1
uiAchievement.SELECTMODE_FINISH = 2
uiAchievement.SELECTMODE_UNFINISH = 3
uiAchievement.tbSelectMode = {
  [uiAchievement.SELECTMODE_ALL] = "显示全部",
  [uiAchievement.SELECTMODE_FINISH] = "显示已完成",
  [uiAchievement.SELECTMODE_UNFINISH] = "显示未完成",
}

uiAchievement.SPANEL_GROUP = "SPanel_Group"
uiAchievement.SPANEL_ACHIEVEINFO = "SPanel_AchiveInfo"
uiAchievement.OUTLOOK_GROUP = "OutLook_Group"
uiAchievement.CBOX_SELECT = "CBox_Select"
uiAchievement.BTN_CLOSE = "Btn_Close"
uiAchievement.TXT_RANKNUM = "Txt_RankNum"
uiAchievement.TXT_TOTALPOINT = "Txt_TotalPoint"
uiAchievement.BTN_RANK = "Btn_Rank"
uiAchievement.BTN_PREPAGE = "Btn_PrePage"
uiAchievement.BTN_NEXTPAGE = "Btn_NextPage"
uiAchievement.TXT_CURPAGE = "Txt_CurPage"
uiAchievement.TXT_TITLE = "Txt_Title"
uiAchievement.TXT_CONSUMABLEPOINT = "Txt_ConsumablePoint"

uiAchievement.SET_ACHIEVEMENTINFO = {}
for i = 1, uiAchievement.MAXCOUNT_PAGE do
  local tbTempInfo = {}
  tbTempInfo.SET_ACHIEVEMENTINFO = "Set_AchiveInfo_" .. i
  tbTempInfo.IMG_CUPBIG = "Img_CupBig_" .. i
  tbTempInfo.IMB_CUPSMALL = "Img_CubSmall_" .. i
  tbTempInfo.TXT_ACHIEVEDSC = "Txt_AchiveDsc_" .. i
  tbTempInfo.IMG_MARK = "Img_Mark_" .. i
  tbTempInfo.TXT_POINT = "Txt_Point_" .. i
  tbTempInfo.IMG_PRGBG = "Img_Prgbg_" .. i
  tbTempInfo.PRG_ACHIEVE = "Prg_Achive_" .. i
  tbTempInfo.TXT_PRG = "Txt_Prg_" .. i
  tbTempInfo.TXT_ACHIEVENAME = "Txt_AchiveName_" .. i
  tbTempInfo.IMG_TIP = "Img_Tip_" .. i
  tbTempInfo.TXT_LEVEL = "Txt_Level_" .. i

  uiAchievement.SET_ACHIEVEMENTINFO[i] = tbTempInfo
end

--=================================================

-- onclose 之后调用
function uiAchievement:Init()
  self.nViewMode = 1
  self.nGroupId = 1
  self.nSubGroupId = 1
  self.nIndex = 0
  self.szDstName = ""
  self.tbDstInfo = {}
  self.nMaxId = 0

  self.nSelectMode = self.SELECTMODE_ALL
  self.nCurPage = 1
end

function uiAchievement:CanOpenWnd()
  if not Achievement.FLAG_OPEN or Achievement.FLAG_OPEN == 0 then
    Ui:ServerCall("UI_TASKTIPS", "Begin", "成就系统还未开放，敬请期待")
    return 0
  end
  return 1
end

-- onopen之前调用
function uiAchievement:PreOpen(nViewMode, nGroupId, nSubGroupId, nIndex, szDstName, tbDstInfo)
  if nViewMode and (nViewMode ~= 1 and nViewMode ~= 2) then
    return
  end

  self.nViewMode = nViewMode or 1
  self.nGroupId = nGroupId or 1
  self.nSubGroupId = nSubGroupId or 1
  self.nIndex = nIndex or 0
  self.szDstName = szDstName or ""
  self.tbDstInfo = tbDstInfo or {}
  self.nMaxId = Achievement:GetMaxId() or 0
  self.tbAllGroupInfo = {}
  self.tbCurPageInfo = {}

  self.nSelectMode = self.SELECTMODE_ALL
  self.nCurPage = 1
  self.nTotalPage = 1
end

function uiAchievement:OnOpen()
  self:Update_Title()
  self:Update_SelectMode()
  self:Update_Group()
  self:FixPos_Group()
  self:Update()

  self.nIndex = 0
end

function uiAchievement:OnButtonClick(szWnd)
  if not szWnd then
    return
  end

  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_RANK then
    self:OpenRank()
  elseif szWnd == self.BTN_PREPAGE then
    self:PrePage()
  elseif szWnd == self.BTN_NEXTPAGE then
    self:NextPage()
  else
    for i = 1, self.MAXCOUNT_PAGE do
      local tbCurSet = self.SET_ACHIEVEMENTINFO[i] or {}
      if tbCurSet.IMG_CUPBIG and tbCurSet.IMG_CUPBIG == szWnd then
        local nCtrl = KLib.GetBit(GetKeyState(UiManager.VK_CONTROL), 16)
        if 1 == nCtrl then
          self:SendChatMsg_Achievement(i)
        end
      end
    end
  end
end

function uiAchievement:OnClose() end

function uiAchievement:OnComboBoxIndexChange(szWnd, nIndex)
  if szWnd == self.CBOX_SELECT then
    self.nSelectMode = nIndex + 1
  end
  self.nCurPage = 1
  self:Update()
end

function uiAchievement:OnOutLookItemSelected(szWnd, nGroupIndex, nItemIndex)
  if not szWnd or szWnd ~= self.OUTLOOK_GROUP then
    return
  end

  self.nCurPage = 1
  self.nGroupId = (nGroupIndex or 0) + 1
  self.nSubGroupId = (nItemIndex or 0) + 1
  OutLookPanelSelItem(self.UIGROUP, self.OUTLOOK_GROUP, nGroupIndex, nItemIndex)
  self:Update()
end

function uiAchievement:OnMouseEnter(szWnd)
  if not szWnd then
    return
  end

  for i = 1, self.MAXCOUNT_PAGE do
    local tbCurSet = self.SET_ACHIEVEMENTINFO[i] or {}
    if tbCurSet.IMG_TIP and tbCurSet.IMG_TIP == szWnd then
      local szAward = self:GetAwardInfo(i)
      Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, "", szAward)
      break
    end

    if tbCurSet.IMG_CUPBIG and tbCurSet.IMG_CUPBIG == szWnd then
      local szTip = self:GetIntroductTip(i)
      Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, "", szTip)
      break
    end
  end
end

function uiAchievement:GetIntroductTip(nIndex)
  if not nIndex or nIndex <= 0 or nIndex > self.MAXCOUNT_PAGE then
    return
  end

  local tbInfo = self.tbCurPageInfo[nIndex]
  if not tbInfo then
    return
  end

  local nAchievementId = tbInfo.nAchievementId
  if not nAchievementId or nAchievementId <= 0 then
    return
  end

  local bFinished = Achievement:CheckFinished(nAchievementId)
  local szTip = ""
  if bFinished and bFinished == 1 then
    szTip = "<color=green>已完成该成就<color>"
  else
    szTip = "<color=red>未完成该成就<color>"
  end
  szTip = szTip .. "\nctrl + 鼠标左键，可以获取此成就链接"

  return szTip
end

function uiAchievement:GetAwardInfo(nIndex)
  if not nIndex or nIndex <= 0 or nIndex > self.MAXCOUNT_PAGE then
    return
  end

  local tbInfo = self.tbCurPageInfo[nIndex]
  if not tbInfo then
    return
  end

  local szAward = "完成奖励如下：\n"
  local nPoint = tbInfo.nPoint or 0
  local nExp = tbInfo.nExp or 0
  local nBindMoney = tbInfo.nBindMoney or 0
  local nBindCoin = tbInfo.nBindCoin or 0
  local nTitleId = tbInfo.nTitleId or 0
  local nConsumablePoint = (tbInfo.nLevel or 0) or 1
  if nPoint > 0 then
    szAward = szAward .. string.format("成就点数：<color=yellow>%s<color>点\n", nPoint)
  end
  if nExp > 0 then
    szAward = szAward .. string.format("成奖励经验：<color=yellow>%s<color>\n", nExp)
  end
  if nBindMoney > 0 then
    szAward = szAward .. string.format("绑定银两：<color=yellow>%s<color>两\n", nBindMoney)
  end
  if nBindCoin > 0 then
    szAward = szAward .. string.format("绑定金币：<color=yellow>%s<color>\n", nBindCoin)
  end
  if nTitleId > 0 then
    local tbAward_Title = Achievement.tbAwardInfo[self.INDEX_AWARD_TITLE] or {}
    local tbInfo = tbAward_Title[nTitleId]
    local szTitle = tbInfo.szTitle
    if szTitle then
      szAward = szAward .. string.format("奖励称号：<color=yellow>%s<color>\n", szTitle)
    end
  end
  szAward = szAward .. string.format("侠义值：<color=yellow>%s点<color>", nConsumablePoint)

  return szAward
end

-- 上一页
function uiAchievement:PrePage()
  if self.nCurPage <= 1 then
    return
  end
  self.nCurPage = self.nCurPage - 1
  self:Update()
end

-- 下一页
function uiAchievement:NextPage()
  self.nCurPage = self.nCurPage + 1
  local tbAchievementInfo = self:GetCurPageAchievementInfo()
  if not tbAchievementInfo or #tbAchievementInfo <= 0 then
    self.nCurPage = self.nCurPage - 1
    return
  end
  self:Update()
end

-- shift + left 发送成就信息到聊天频道
function uiAchievement:SendChatMsg_Achievement(nIndex)
  if not nIndex or nIndex <= 0 then
    return
  end

  local tbInfo = self.tbCurPageInfo[nIndex]
  if not tbInfo then
    return
  end

  local nAchievementId = tbInfo.nAchievementId
  if not nAchievementId or nAchievementId <= 0 then
    return
  end

  local szAchivementName = tbInfo.szAchivementName or ""
  local szMsg = "<" .. szAchivementName .. ">"
  local szInfo = "<achievementdsc=" .. nAchievementId .. ">"

  Ui.tbLogic.tbMsgChannel:AddAchievementMsgInfo(szMsg, szInfo)
  InsertChatMsg(szMsg)
end

--=================================================

-- 打开成就排行榜
function uiAchievement:OpenRank()
  UiManager:SwitchWindow(Ui.UI_LADDER, 7, 2)
end

--=================================================

-- 根据成就id获取成就信息
function uiAchievement:GetAchievementInfoById(nAchievementId)
  if not nAchievementId or nAchievementId <= 0 then
    return
  end

  local nGroupId, nSubGroupId, nIndex = Achievement:GetIndexInfoById(nAchievementId)
  return self:GetAchievementInfoByIndex(nGroupId, nSubGroupId, nIndex)
end

-- 根据成就nGroupId, nSubGroupId, nIndex 来获取成就信息
function uiAchievement:GetAchievementInfoByIndex(nGroupId, nSubGroupId, nIndex)
  if not nGroupId or not nSubGroupId or not nIndex or nGroupId <= 0 or nSubGroupId <= 0 or nIndex <= 0 then
    return
  end

  return Achievement:GetAchievementInfo(nGroupId, nSubGroupId, nIndex)
end

-- 获取指定小类下的所有成就
function uiAchievement:GetSubGroupAchievementInfo(nGroupId, nSubGroupId)
  if not nGroupId or not nSubGroupId or nGroupId <= 0 or nSubGroupId <= 0 then
    return
  end

  return Achievement.tbAchievementInfo[nGroupId][nSubGroupId]
end

-- 获取tbCondInfo 中对应nAchievementId 的信息
function uiAchievement:GetCondInfoById(nAchievementId)
  if not nAchievementId or nAchievementId <= 0 then
    return
  end

  local tbAchievementInfo = self:GetAchievementInfoById(nAchievementId)
  if not tbAchievementInfo then
    return
  end

  local nCondType = tbAchievementInfo.nCondType or 0
  local nCondIndex = tbAchievementInfo.nCondIndex or 0
  if nCondType == 0 or nCondIndex == 0 then
    return
  end

  if Achievement.tbCondInfo and Achievement.tbCondInfo[nCondType] and Achievement.tbCondInfo[nCondType][nCondIndex] then
    return Achievement.tbCondInfo[nCondType][nCondIndex]
  end
end

function uiAchievement:GetGroupInfo()
  local tbRet = {}
  local tbAchievementInfo = Achievement.tbAchievementInfo
  if not tbAchievementInfo or Lib:CountTB(tbAchievementInfo) <= 0 then
    return
  end

  local nTotalNum_Group = 0
  local nFinishedNum_Group = 0
  local nTotalNum_SubGroup = 0
  local nFinishedNum_SubGroup = 0
  for nGroupId, tbGroupInfo in pairs(tbAchievementInfo) do
    tbRet[nGroupId] = tbRet[nGroupId] or {}
    tbRet[nGroupId].tbSubGroupInfo = tbRet[nGroupId].tbSubGroupInfo or {}
    for nSubGroupId, tbSubGroupInfo in pairs(tbGroupInfo) do
      tbRet[nGroupId].tbSubGroupInfo[nSubGroupId] = tbRet[nGroupId].tbSubGroupInfo[nSubGroupId] or {}
      for _, tbInfo in pairs(tbSubGroupInfo) do
        local szGroupName = tbInfo.szGroupName or ""
        local szSubGroupName = tbInfo.szSubGroupName or ""

        local nAchievementId = tbInfo.nAchievementId or 0
        local bFinished = self:CheckFinished(nAchievementId)
        nTotalNum_Group = nTotalNum_Group + 1
        nTotalNum_SubGroup = nTotalNum_SubGroup + 1
        if bFinished and bFinished == 1 then
          nFinishedNum_Group = nFinishedNum_Group + 1
          nFinishedNum_SubGroup = nFinishedNum_SubGroup + 1
        end

        tbRet[nGroupId].szName = szGroupName .. string.format("（%s / %s）", nFinishedNum_Group, nTotalNum_Group)
        tbRet[nGroupId].tbSubGroupInfo[nSubGroupId].szName = szSubGroupName .. string.format("（%s / %s）", nFinishedNum_SubGroup, nTotalNum_SubGroup)
      end
      nTotalNum_SubGroup = 0
      nFinishedNum_SubGroup = 0
    end
    nTotalNum_Group = 0
    nFinishedNum_Group = 0
  end
  return tbRet
end

--=================================================

function uiAchievement:Update()
  self.tbCurPageInfo = {}
  self:FixPos_AchievementInfo()
  self:Update_AchieveInfo()
  self:Update_Page()
  self:Update_RankInfo()
end

function uiAchievement:FixPos_AchievementInfo()
  if not self.nIndex or self.nIndex == 0 then
    return
  end

  local tbAchievementInfo = self:GetAllPageAchievementInfo()
  if not tbAchievementInfo or #tbAchievementInfo <= 0 then
    return
  end

  local nIndex = 0
  for i = 1, #tbAchievementInfo do
    local tbInfo = tbAchievementInfo[i]
    nIndex = nIndex + 1
    if self.nIndex == tbInfo.nIndex then
      break
    end
  end

  local nPageNo = math.floor((nIndex - 1) / self.MAXCOUNT_PAGE) + 1
  self.nCurPage = nPageNo
end

function uiAchievement:Update_RankInfo()
  local nRankNum = me.GetTask(Player.tbFightPower.TASK_GROUP, Player.tbFightPower.TASK_ACHIEVEMENT_RANK)
  local nPoint = Achievement:GetAchievementPoint(me) or 0
  local nConsumable = Achievement:GetConsumeablePoint(me) or 0

  local szRankNum = string.format("我的成就排名：<color=yellow>%s<color>", nRankNum)
  local szTotalPoint = string.format("当前成就点数：<color=yellow>%s<color>", nPoint)
  local szConsumablePoint = string.format("当前侠义值：<color=yellow>%s<color>", nConsumable)

  Txt_SetTxt(self.UIGROUP, self.TXT_RANKNUM, szRankNum)
  Txt_SetTxt(self.UIGROUP, self.TXT_TOTALPOINT, szTotalPoint)
  Txt_SetTxt(self.UIGROUP, self.TXT_CONSUMABLEPOINT, szConsumablePoint)
end

function uiAchievement:Update_SelectMode()
  ClearComboBoxItem(self.UIGROUP, self.CBOX_SELECT)
  for i = 1, #self.tbSelectMode do
    ComboBoxAddItem(self.UIGROUP, self.CBOX_SELECT, i, self.tbSelectMode[i])
  end
  ComboBoxSelectItem(self.UIGROUP, self.CBOX_SELECT, 0)
  self.nSelectMode = 1
end

function uiAchievement:Update_Title()
  local szTitle = "成    就"
  if self.szDstName and self.szDstName ~= "" then
    szTitle = string.format("<color=gold>『%s』<color>的成就", self.szDstName)
  end
  Txt_SetTxt(self.UIGROUP, self.TXT_TITLE, szTitle)
end

function uiAchievement:Update_Page()
  local tbAchievementInfo = self:GetAllPageAchievementInfo()
  if not tbAchievementInfo or #tbAchievementInfo <= 0 then
    return
  end

  self.nTotalPage = math.ceil(#tbAchievementInfo / self.MAXCOUNT_PAGE)
  if not self.nTotalPage or self.nTotalPage <= 0 then
    self.nTotalPage = 1
  end

  local szPageInfo = string.format("%s / %s", self.nCurPage or 1, self.nTotalPage or 1)
  Txt_SetTxt(self.UIGROUP, self.TXT_CURPAGE, szPageInfo)
end

function uiAchievement:Update_Group()
  OutLookPanelClearAll(self.UIGROUP, self.OUTLOOK_GROUP)
  AddOutLookPanelColumnHeader(self.UIGROUP, self.OUTLOOK_GROUP, "")
  SetOutLookHeaderWidth(self.UIGROUP, self.OUTLOOK_GROUP, 0, 20)
  local tbAllGroupInfo = self:GetGroupInfo()
  if not tbAllGroupInfo or Lib:CountTB(tbAllGroupInfo) <= 0 then
    return
  end
  self.tbAllGroupInfo = tbAllGroupInfo

  for nGroupId, tbGroupInfo in pairs(tbAllGroupInfo) do
    local szGroupName = tbGroupInfo.szName or ""
    AddOutLookGroup(self.UIGROUP, self.OUTLOOK_GROUP, szGroupName)
    for nSubGroupId, tbSubGroupInfo in pairs(tbGroupInfo.tbSubGroupInfo or {}) do
      local szSubGroupName = tbSubGroupInfo.szName or ""
      AddOutLookItem(self.UIGROUP, self.OUTLOOK_GROUP, nGroupId - 1, { szSubGroupName })
    end
  end

  OutLookPanelSelItem(self.UIGROUP, self.OUTLOOK_GROUP, self.nGroupId - 1, self.nSubGroupId - 1)
end

function uiAchievement:FixPos_Group()
  if not self.tbAllGroupInfo or Lib:CountTB(self.tbAllGroupInfo) <= 0 then
    return
  end

  local nTotalSubGroup = 0
  local nCurSubGroupIndex = 0
  for nGroupId, tbGroupInfo in pairs(self.tbAllGroupInfo) do
    for nSubGroupId, tbSubGroupInfo in pairs(tbGroupInfo.tbSubGroupInfo or {}) do
      if nGroupId < self.nGroupId then
        nCurSubGroupIndex = nCurSubGroupIndex + 1
      elseif nGroupId == self.nGroupId and nSubGroupId <= self.nSubGroupId then
        nCurSubGroupIndex = nCurSubGroupIndex + 1
      end
      nTotalSubGroup = nTotalSubGroup + 1
    end
  end

  local nPercent = 0
  if nTotalSubGroup > 0 and nCurSubGroupIndex >= 0 then
    nPercent = nCurSubGroupIndex / nTotalSubGroup * 100
  end

  ScrPanel_FixSlidePos(self.UIGROUP, self.SPANEL_GROUP, nPercent)
end

function uiAchievement:Update_AchieveInfo()
  for i = 1, self.MAXCOUNT_PAGE do
    Wnd_Hide(self.UIGROUP, self.SET_ACHIEVEMENTINFO[i].SET_ACHIEVEMENTINFO)
  end

  local tbAchievementInfo = self:GetCurPageAchievementInfo()
  if not tbAchievementInfo or #tbAchievementInfo <= 0 then
    return
  end

  self.tbCurPageInfo = tbAchievementInfo
  for nShowIndex, tbInfo in ipairs(tbAchievementInfo) do
    self:Update_OneAchievementInfo(nShowIndex, tbInfo)
  end

  local nPercent = 0
  if self.nIndex and self.nIndex ~= 0 then
    for i = 1, #tbAchievementInfo do
      local tbInfo = tbAchievementInfo[i]
      if tbInfo.nIndex and tbInfo.nIndex == self.nIndex then
        nPercent = (i - 1) / (self.MAXCOUNT_PAGE - 1) * 100
        break
      end
    end
  end
  ScrPanel_FixSlidePos(self.UIGROUP, self.SPANEL_ACHIEVEINFO, nPercent)
end

function uiAchievement:CheckFinished(nAchievementId)
  if not nAchievementId or nAchievementId <= 0 then
    return
  end

  local bFinished = 0
  if self.nViewMode == self.VIEWMODE_SELF then
    bFinished = Achievement:CheckFinished(nAchievementId)
  elseif self.nViewMode == self.VIEWMODE_OTHER then
    bFinished = self.tbDstInfo[nAchievementId] or 0
  end

  return bFinished
end

-- 显示一个成就信息条目，nShowIndex 表示是界面上显示的第几个条目
function uiAchievement:Update_OneAchievementInfo(nShowIndex, tbAchievementInfo)
  local tbCurSet = self.SET_ACHIEVEMENTINFO[nShowIndex] or {}
  Wnd_Show(self.UIGROUP, tbCurSet.SET_ACHIEVEMENTINFO)

  local nAchievementId = tbAchievementInfo.nAchievementId or 0
  local bFinished = self:CheckFinished(nAchievementId)
  local bFinished_Self = Achievement:CheckFinished(nAchievementId)
  local szAchivementName = tbAchievementInfo.szAchivementName or ""
  local nPoint = tbAchievementInfo.nPoint or 0
  local szDesc = tbAchievementInfo.szDesc or ""
  local nLevel = tbAchievementInfo.nLevel or 0
  local bProcess = tbAchievementInfo.bProcess or 0
  local szLevle = ""

  -- 对比成就的时候，不显示进度条
  if self.nViewMode == self.VIEWMODE_OTHER then
    bProcess = 0
  end

  if self.nViewMode == self.VIEWMODE_SELF then
    Wnd_Hide(self.UIGROUP, tbCurSet.IMB_CUPSMALL)
  elseif self.nViewMode == self.VIEWMODE_OTHER and bFinished_Self == 1 then
    Wnd_Show(self.UIGROUP, tbCurSet.IMB_CUPSMALL)
  else
    Wnd_Hide(self.UIGROUP, tbCurSet.IMB_CUPSMALL)
  end

  if bProcess == 0 then
    Wnd_Hide(self.UIGROUP, tbCurSet.IMG_PRGBG)
    Wnd_Hide(self.UIGROUP, tbCurSet.TXT_PRG)
  else
    Wnd_Show(self.UIGROUP, tbCurSet.IMG_PRGBG)
    Wnd_Show(self.UIGROUP, tbCurSet.TXT_PRG)
  end
  if bFinished == 0 then
    Wnd_Hide(self.UIGROUP, tbCurSet.IMG_MARK)
    Img_SetFrame(self.UIGROUP, tbCurSet.SET_ACHIEVEMENTINFO, 1)
    Img_SetFrame(self.UIGROUP, tbCurSet.IMG_CUPBIG, 1)
    Img_SetFrame(self.UIGROUP, tbCurSet.IMG_TIP, 1)
  else
    Wnd_Show(self.UIGROUP, tbCurSet.IMG_MARK)
    Img_SetFrame(self.UIGROUP, tbCurSet.SET_ACHIEVEMENTINFO, 0)
    Img_SetFrame(self.UIGROUP, tbCurSet.IMG_CUPBIG, 0)
    Img_SetFrame(self.UIGROUP, tbCurSet.IMG_TIP, 0)
  end

  for i = 1, nLevel do
    szLevle = szLevle .. "<color=gold>★<color>"
  end
  Txt_SetTxt(self.UIGROUP, tbCurSet.TXT_ACHIEVENAME, szAchivementName)
  Txt_SetTxt(self.UIGROUP, tbCurSet.TXT_LEVEL, szLevle)
  Txt_SetTxt(self.UIGROUP, tbCurSet.TXT_ACHIEVEDSC, szDesc)
  Txt_SetTxt(self.UIGROUP, tbCurSet.TXT_POINT, nPoint)
  if bProcess == 1 then
    local nFinishNum, nMaxNum = self:GetPrgInfo(tbAchievementInfo)
    if bFinished == 1 then
      nFinishNum = nMaxNum
    end
    if nFinishNum and nMaxNum and nFinishNum <= nMaxNum then
      Prg_SetPos(self.UIGROUP, tbCurSet.PRG_ACHIEVE, nFinishNum / nMaxNum * 1000)
      local szPercent = string.format("%s / %s", nFinishNum, nMaxNum)
      Txt_SetTxt(self.UIGROUP, tbCurSet.TXT_PRG, szPercent)
    end
  end
end

-- 获取进度条的完成情况，返回值两个，一个是当前的完成值，一个是最大值
function uiAchievement:GetPrgInfo(tbAchievementInfo)
  if not tbAchievementInfo or not tbAchievementInfo.nCondType or not tbAchievementInfo.nCondIndex then
    return
  end
  local nMaxNum = 0
  local nFinishNum = Achievement:GetFinishNum(me, tbAchievementInfo.nAchievementId)
  local nCondType = tbAchievementInfo.nCondType
  local nCondIndex = tbAchievementInfo.nCondIndex
  if nCondType == 0 or nCondIndex == 0 then
    nMaxNum = tbAchievementInfo.nMaxCount
    return nFinishNum, nMaxNum
  end

  if Achievement.tbCondInfo and Achievement.tbCondInfo[nCondType] and Achievement.tbCondInfo[nCondType][nCondIndex] then
    nMaxNum = Achievement.tbCondInfo[nCondType][nCondIndex].nCount
  end
  return nFinishNum, nMaxNum
end

function uiAchievement:GetCurPageAchievementInfo()
  self.nGroupId = self.nGroupId or 1
  self.nSubGroupId = self.nSubGroupId or 1
  self.nCurPage = self.nCurPage or 1
  local tbAchievementInfo = self:GetSubGroupAchievementInfo(self.nGroupId, self.nSubGroupId)
  if not tbAchievementInfo or Lib:CountTB(tbAchievementInfo) <= 0 then
    return
  end

  local nCurNum = 1
  local nBeginNum = (self.nCurPage - 1) * self.MAXCOUNT_PAGE + 1
  local nTotalNum = Lib:CountTB(tbAchievementInfo)

  local tbRet = {}
  for _, tbInfo in pairs(tbAchievementInfo) do
    if nCurNum >= nBeginNum and nCurNum < (nBeginNum + self.MAXCOUNT_PAGE) then
      local nAchievementId = tbInfo.nAchievementId or 0
      local bFinished = self:CheckFinished(nAchievementId)
      if self.nSelectMode == self.SELECTMODE_ALL then
        table.insert(tbRet, tbInfo)
        nCurNum = nCurNum + 1
      elseif self.nSelectMode == self.SELECTMODE_FINISH and bFinished == 1 then
        table.insert(tbRet, tbInfo)
        nCurNum = nCurNum + 1
      elseif self.nSelectMode == self.SELECTMODE_UNFINISH and bFinished == 0 then
        table.insert(tbRet, tbInfo)
        nCurNum = nCurNum + 1
      end
    elseif nCurNum < nBeginNum then
      local nAchievementId = tbInfo.nAchievementId or 0
      local bFinished = self:CheckFinished(nAchievementId)
      if self.nSelectMode == self.SELECTMODE_ALL then
        nCurNum = nCurNum + 1
      elseif self.nSelectMode == self.SELECTMODE_FINISH and bFinished == 1 then
        nCurNum = nCurNum + 1
      elseif self.nSelectMode == self.SELECTMODE_UNFINISH and bFinished == 0 then
        nCurNum = nCurNum + 1
      end
    else
      break
    end
  end

  return tbRet
end

-- 获取当前所有页面的成就信息
function uiAchievement:GetAllPageAchievementInfo()
  self.nGroupId = self.nGroupId or 1
  self.nSubGroupId = self.nSubGroupId or 1
  local tbAchievementInfo = self:GetSubGroupAchievementInfo(self.nGroupId, self.nSubGroupId)
  if not tbAchievementInfo or Lib:CountTB(tbAchievementInfo) <= 0 then
    return
  end

  local tbRet = {}
  for _, tbInfo in pairs(tbAchievementInfo) do
    local nAchievementId = tbInfo.nAchievementId or 0
    local bFinished = self:CheckFinished(nAchievementId)
    if self.nSelectMode == self.SELECTMODE_ALL then
      table.insert(tbRet, tbInfo)
    elseif self.nSelectMode == self.SELECTMODE_FINISH and bFinished == 1 then
      table.insert(tbRet, tbInfo)
    elseif self.nSelectMode == self.SELECTMODE_UNFINISH and bFinished == 0 then
      table.insert(tbRet, tbInfo)
    end
  end

  return tbRet
end

function uiAchievement:IsAchievementAvalable(tbAchievementInfo)
  if not tbAchievementInfo then
    return 0
  end

  if not tbAchievementInfo.bEffective or tbAchievementInfo.bEffective == 0 then
    return 0
  end

  local nAchievementId = tbAchievementInfo.nAchievementId
  if not nAchievementId or nAchievementId == 0 then
    return 0
  end

  local bFinished = Achievement:CheckFinished(nAchievementId)
  if self.nSelectMode == self.SELECTMODE_FINISH and bFinished == 0 then
    return 0
  end
  if self.nSelectMode == self.SELECTMODE_UNFINISH and bFinished == 1 then
    return 0
  end

  return 1
end
