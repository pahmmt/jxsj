-- 文件名　：calendarview.lua
-- 创建者　：zounan
-- 创建时间：2010-03-10 14:58:08
-- 描  述  ：活动日历 窗口部分

local uiCalendar = Ui:GetClass("calendar")
local tbCalendar = Ui.tbLogic.tbCalendar

--uiCalendar.TIME_UP   = 100; -- 上延一小时
uiCalendar.TIME_DOWN = 200 -- 下延2小时

uiCalendar.szFilePath = "\\setting\\task\\help\\test.txt"

uiCalendar.TXX_MATCH = "TxtExMatchText"
uiCalendar.TXX_MISC = "TxtExDescText"

uiCalendar.BTN_CLOSE = "BtnClose"
uiCalendar.PAGE_BUTTON_KEY_STR = "BtnHelpPage"
uiCalendar.PAGE_BUTTON_MAX_NUMBER = 3
uiCalendar.TXT_SYSTIME = "TextSysTime"
uiCalendar.TXT_TIMERFRAME = "TextTimerFrame"
uiCalendar.TXT_SHOWMATCHNAME = "TextShowMatchName"
uiCalendar.IE_NEWPLAYER = "IENewPlayer"
uiCalendar.IE_ANNOUNCE = "IEAnnounce"
uiCalendar.OUTLOOKPANEL = "OutLookPanel"
uiCalendar.HISTORYSCRPANEL = "HistoryScrollPanel"
uiCalendar.BTN_CHECKREMIND = "BtnRemind"
uiCalendar.BTN_CHECKREMINDALL = "BtnAllRemind"

uiCalendar.MAX_STAR_NUM = 10
uiCalendar.nCurPageIndex = 1
uiCalendar.tbOutLookPanel = {}
uiCalendar.tbQaFold = {}

uiCalendar.tbHideGroup = {
  "Page",
  "TextShowMatch4",
  "BtnRemind",
  "TextShowMatch1",
  "TextShowMatch2",
  "TextShowMatch3",
  "TextShowMatch4",
  "ScrollMatchText",
  "TextShowMatchName",
  "ScrollDescText",
  "BtnAllRemind",
  "HistoryScrollPanel",
}

uiCalendar.IE_CTL_BACKGROUND = "MainChild"

uiCalendar.tbMatchSate = {
  [1] = "<color=0xff6D6D6D>未开启<color>",
  [2] = "<color=green>可参加<color>",
  [3] = "<color=orange>已开始<color>",
  [4] = "已关闭",
}

uiCalendar.STR_DEFAULT_TEXT = "\t<bclr=blue>剑侠日历<bclr>"

--== 窗体逻辑 ==--
local function fnStrValue(szVal)
  local varType = loadstring("return " .. szVal)()
  if type(varType) == "function" then
    return varType()
  else
    return varType
  end
end

--写log
function uiCalendar:WriteStatLog()
  --Log:Ui_SendLog("F12帮助系统界面", 1);
  Log:Ui_SendLog("点击剑侠日历首页", 1)
  me.CallServerScript({ "HelpManCmd", me.szName })
end

function uiCalendar:OnOpen()
  if GblTask:GetUiFunSwitch("UI_HELPSPRITE_ZHIDAO") == 0 then
    Wnd_Hide(self.UIGROUP, self.PAGE_BUTTON_KEY_STR .. 4) -- 暂不开放此功能
  end
  --	self:WriteStatLog();
  self.nCurPageIndex = 1
  self:UpdatePage(1)
  --	self:SetStaticTxt();
  self:UpdateSysTime()
  --	self:ShowMisc();
  self.nTimerRegId = Timer:Register(10 * Env.GAME_FPS, self.OnTimer, self)
end

function uiCalendar:OnTimer()
  if UiManager:WindowVisible(self.UIGROUP) == 1 then
    self:UpdateSysTime()
    return
  end
  return 0
end

function uiCalendar:OnClose()
  Wnd_SetExclusive(self.UIGROUP, "Main", 0)
end

function uiCalendar:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  --elseif szWnd == self.BTN_CHECKREMIND then
  --	self:OnUpdateCheckBtnRemind(nParam);
  --elseif szWnd == self.BTN_CHECKREMINDALL then
  --	self:OnUpdateCheckBtnRemindAll(nParam);
  else
    local _, _, szBtnIndex = string.find(szWnd, self.PAGE_BUTTON_KEY_STR .. "(%d+)")
    if szBtnIndex then
      self.nCurPageIndex = tonumber(szBtnIndex)
      self:UpdatePage(1)
      return
    end
  end
end

-- 更新系统时间
function uiCalendar:UpdateSysTime()
  local nNowDate = GetTime()
  local nWeekDay = tonumber(os.date("%w", nNowDate))
  local szWeekDay = "日"
  if nWeekDay ~= 0 then
    szWeekDay = Lib:Transfer4LenDigit2CnNum(nWeekDay)
  end
  local szTime = os.date("%H:%M", nNowDate)
  local szDate = os.date("%Y年%m月%d日", nNowDate)
  szDate = string.format("%s %s 星期%s", szDate, szTime, szWeekDay)
  Txt_SetTxt(self.UIGROUP, self.TXT_SYSTIME, szDate)
  self:ShowTimeFrame(nNowDate) --时间轴显示 也扔这了
end

function uiCalendar:HideAndShow(nIndex)
  if nIndex == 1 then
    Wnd_Hide(self.UIGROUP, self.IE_CTL_BACKGROUND)
    for _, szUiName in pairs(self.tbHideGroup) do
      if Wnd_Visible(self.UIGROUP, szUiName) ~= 1 then
        Wnd_Show(self.UIGROUP, szUiName)
      end
    end
  else
    Wnd_Show(self.UIGROUP, self.IE_CTL_BACKGROUND)
    for _, szUiName in pairs(self.tbHideGroup) do
      if Wnd_Visible(self.UIGROUP, szUiName) == 1 then
        Wnd_Hide(self.UIGROUP, szUiName)
      end
    end
  end
end

-- 更新标签页
function uiCalendar:UpdatePage(nRefreshFlag)
  Wnd_Hide(self.UIGROUP, self.IE_NEWPLAYER)
  Wnd_Hide(self.UIGROUP, self.IE_ANNOUNCE)
  for i = 1, self.PAGE_BUTTON_MAX_NUMBER do
    local nChecked = 0
    if i == self.nCurPageIndex then
      self["OnUpdatePage_Page" .. string.format("%d", self.nCurPageIndex)](self)
      nChecked = 1
    end
    Btn_Check(self.UIGROUP, self.PAGE_BUTTON_KEY_STR .. i, nChecked)
  end
  --	if (nRefreshFlag == 1) then
  --		self:SetContentText("");
  --	end
  if self.nCurPageIndex == 1 then
    Wnd_SetExclusive(self.UIGROUP, "Main", 0)
  else
    Wnd_SetExclusive(self.UIGROUP, "Main", 1)
  end
  if UiVersion == Ui.Version002 then
    self:HideAndShow(self.nCurPageIndex)
  end
end

local function OnSortByName(tb1, tb2)
  if tb1.nWeight ~= tb2.nWeight then
    return tb1.nWeight > tb2.nWeight
  end
  return tb1.nId < tb2.nId
end

function uiCalendar:GetStrVal(szText)
  local szListText = ""
  if szText then
    szListText = string.gsub(szText, "<%%(.-)%%>", fnStrValue)
  end
  return szListText
end

-- 剑侠日历
function uiCalendar:OnUpdatePage_Page1()
  self:OnUpdateTotalMatch()
end

-- 热点推荐
function uiCalendar:OnUpdatePage_Page2()
  Wnd_Show(self.UIGROUP, self.IE_ANNOUNCE)
  local szRetUrl = "http://kefu.xoyo.com/gonggao/jxsj/clientView/clientView.shtml"
  IE_Navigate(self.UIGROUP, self.IE_ANNOUNCE, szRetUrl)
end

--新手私塾
function uiCalendar:OnUpdatePage_Page3()
  Wnd_Show(self.UIGROUP, self.IE_NEWPLAYER)
  local szRetUrl = "http://jxsj.xoyo.com/sishu/"
  IE_Navigate(self.UIGROUP, self.IE_NEWPLAYER, szRetUrl)
end

function uiCalendar:OnEscExclusiveWnd(szWnd)
  UiManager:CloseWindow(self.UIGROUP)
end

function uiCalendar:OnUpdateTotalMatch()
  OutLookPanelClearAll(self.UIGROUP, self.OUTLOOKPANEL)
  AddOutLookPanelColumnHeader(self.UIGROUP, self.OUTLOOKPANEL, "")
  AddOutLookPanelColumnHeader(self.UIGROUP, self.OUTLOOKPANEL, "")
  AddOutLookPanelColumnHeader(self.UIGROUP, self.OUTLOOKPANEL, "")
  AddOutLookPanelColumnHeader(self.UIGROUP, self.OUTLOOKPANEL, "")
  SetOutLookHeaderWidth(self.UIGROUP, self.OUTLOOKPANEL, 0, 80)
  SetOutLookHeaderWidth(self.UIGROUP, self.OUTLOOKPANEL, 1, 60)
  SetOutLookHeaderWidth(self.UIGROUP, self.OUTLOOKPANEL, 2, 40)
  SetOutLookHeaderWidth(self.UIGROUP, self.OUTLOOKPANEL, 3, 70)

  --显示用的

  self.tbTimingMatch = {}
  self.tbDailyMatch = {}
  -- local nCurTime =  tonumber(GetLocalDate("%H%M"));
  self:OnUpdateDailyMatch()
  local nFixPos, nShowCount = self:OnUpdateTimingMatch()
  self.tbTotalMatch = {
    [1] = self.tbDailyMatch,
    [2] = self.tbTimingMatch,
  }
  if nShowCount > 0 then
    local nPercent = OutLookPanelGetItemHeightPercent(self.UIGROUP, self.OUTLOOKPANEL, 1, nFixPos)
    OutLookPanelSelItem(self.UIGROUP, self.OUTLOOKPANEL, 1, nFixPos)
    if nPercent and nPercent ~= -1 then
      ScrPanel_FixSlidePos(self.UIGROUP, self.HISTORYSCRPANEL, nPercent)
    end
  else
    --Wnd_Hide(self.UIGROUP,self.BTN_CHECKREMIND);
    self:SetTxtEx(self.TXX_MATCH, self.STR_DEFAULT_TEXT)
  end
  --Btn_Check(self.UIGROUP, self.BTN_CHECKREMINDALL, tbCalendar.bMatchNotifyAll or 0);
end

--定时活动
function uiCalendar:OnUpdateTimingMatch()
  self.tbTimingMatch = {}
  local nCurTime = tonumber(GetLocalDate("%H%M"))
  local nFixPos = -1
  local tbTimingMatch = tbCalendar.tbTimingMatch
  AddOutLookGroup(self.UIGROUP, self.OUTLOOKPANEL, "定时活动")
  local tbViewed = {} --过滤table，每次只显示最近的一次
  --只显示当前时间附近的活动
  for j, tbMatchView in ipairs(tbTimingMatch.tbView) do
    local nId = tbMatchView.nIndexId
    local tbMatch = tbTimingMatch.tbMatch[nId]
    local nMatchOpen = tonumber(tbCalendar:GetVar(tbMatch.varMatchOpen, 0))

    -- modify  zouan 2010.10.12  --日期也增加了是否开启判断
    if nMatchOpen == 1 and tbCalendar:CheckConidtion(tbMatchView.tbTime[4]) == 1 then
      local nState = 1
      if tbCalendar:IsTimeBetween(nCurTime, tbMatchView.tbTime[1], tbMatchView.tbTime[3]) == 0 then
        if nCurTime >= tbMatchView.tbTime[3] then
          nState = 4
        else
          nState = 1
        end
      elseif tbCalendar:IsTimeBetween(nCurTime, tbMatchView.tbTime[1], tbMatchView.tbTime[2]) == 1 then
        nState = 2
      else
        nState = 3
      end
      if nState ~= 4 and not tbViewed[tbMatch.szName] then
        local nCurCount = tbCalendar:GetVar(tbMatch.varCurCount, 0)
        local nMaxCount = tbCalendar:GetVar(tbMatch.varMaxCount, 0)
        local szCounts = string.format("%02s/%02s", nCurCount, nMaxCount)
        local nMinLevel = tbCalendar:GetVar(tbMatch.varMinLevel, 0)
        local nVisible = tbCalendar:GetVar(tbMatch.varVisible, 0)
        table.insert(self.tbTimingMatch, tbMatchView)
        if nFixPos == -1 and nState ~= 4 then
          nFixPos = #self.tbTimingMatch - 1
        end
        if tonumber(nVisible) == 1 and nState == 3 then
          nState = 2
        end
        AddOutLookItem(self.UIGROUP, self.OUTLOOKPANEL, 1, { tbMatch.szName, self:Num2Time(tbMatchView.tbTime[2]), nMinLevel, self.tbMatchSate[nState], szCounts })
        tbViewed[tbMatch.szName] = 1
      end
    end
  end

  --显示隔天的 悲剧
  if nCurTime > (2400 - self.TIME_DOWN) then
    local nViewTime = nCurTime + self.TIME_DOWN - 2400
    for j, tbMatchView in ipairs(tbTimingMatch.tbView) do
      local nId = tbMatchView.nIndexId
      local tbMatch = tbTimingMatch.tbMatch[nId]
      local nMatchOpen = tonumber(tbCalendar:GetVar(tbMatch.varMatchOpen, 0))
      if tbMatchView.tbTime[2] > nViewTime then --如果超过显示时间就不显示了
        break
      end

      if nMatchOpen == 1 and tbCalendar:CheckConidtion(tbMatchView.tbTime[4]) == 1 and not tbViewed[tbMatch.szName] then
        table.insert(self.tbTimingMatch, tbMatchView)
        local nCurCount = tbCalendar:GetVar(tbMatch.varCurCount, 0)
        local nMaxCount = tbCalendar:GetVar(tbMatch.varMaxCount, 0)
        local szCounts = string.format("%02s/%02s", nCurCount, nMaxCount)
        local nMinLevel = tbCalendar:GetVar(tbMatch.varMinLevel, 0)
        local nVisible = tbCalendar:GetVar(tbMatch.varVisible, 0)
        local nState = 1
        if tbCalendar:IsTimeBetween(nCurTime, tbMatchView.tbTime[1], tbMatchView.tbTime[3]) == 0 then
          if nCurTime >= tbMatchView.tbTime[3] then
            nState = 4
          else
            nState = 1
          end
        elseif tbCalendar:IsTimeBetween(nCurTime, tbMatchView.tbTime[1], tbMatchView.tbTime[2]) == 1 then
          nState = 2
        else
          nState = 3
        end
        if nFixPos == -1 and nState ~= 4 then
          nFixPos = #self.tbTimingMatch - 1
        end
        if tonumber(nVisible) == 1 and nState == 3 then --特殊处理，持续开启的活动，一直显示可参加
          nState = 2
        end
        AddOutLookItem(self.UIGROUP, self.OUTLOOKPANEL, 1, { tbMatch.szName, self:Num2Time(tbMatchView.tbTime[2]), nMinLevel, self.tbMatchSate[nState], szCounts })
        tbViewed[tbMatch.szName] = 1
      end
    end
  end

  if nFixPos == -1 then
    nFixPos = 0
  end

  return nFixPos, #self.tbTimingMatch
end

function uiCalendar:OnUpdateDailyMatch()
  AddOutLookGroup(self.UIGROUP, self.OUTLOOKPANEL, "日常活动") --tbMatchType.szTitle);
  local tbDailyMatch = tbCalendar.tbDailyMatch
  if tbDailyMatch.tbView then
    for j, tbMatchView in ipairs(tbDailyMatch.tbView) do
      local nId = tbMatchView.nIndexId
      local tbMatch = tbDailyMatch.tbMatch[nId]
      local nMatchOpen = tonumber(tbCalendar:GetVar(tbMatch.varMatchOpen, 0))
      if nMatchOpen == 1 then
        local nCurCount = tbCalendar:GetVar(tbMatch.varCurCount, 0)
        local nMaxCount = tbCalendar:GetVar(tbMatch.varMaxCount, 0)
        local nMinLevel = tbCalendar:GetVar(tbMatch.varMinLevel, 0)
        local szCounts = string.format("%02s/%02s", nCurCount, nMaxCount)
        AddOutLookItem(self.UIGROUP, self.OUTLOOKPANEL, 0, { tbMatch.szName, "全天", nMinLevel, self.tbMatchSate[2], szCounts })
        table.insert(self.tbDailyMatch, tbMatchView)
      end
    end
  end
end

function uiCalendar:Num2Time(nTime)
  local nHour = math.floor(nTime / 100)
  local nMin = nTime % 100
  local szTime = string.format("%02d:%02d", nHour, nMin)
  return szTime
end

function uiCalendar:SetTxt(szWnd, szText)
  Txt_SetTxt(self.UIGROUP, szWnd, szText)
end

function uiCalendar:SetTxtEx(szWnd, szText)
  szText = self:GetStrVal(szText)
  Ui.tbLogic.tbTimer:Register(1, self.OnTimer_SetText, self, szWnd, szText)
end

--延迟处理
function uiCalendar:OnTimer_SetText(szWnd, szText)
  if szText and string.len(szText) > 0 then
    TxtEx_SetText(self.UIGROUP, szWnd, szText)
  end
  return 0
end

function uiCalendar:OnOutLookItemSelected(szWndName, nGroupIndex, nItemIndex)
  if szWndName ~= self.OUTLOOKPANEL then
    return
  end
  self.nGroupIndex_OutLook = nGroupIndex
  self.nItemIndex_OutLook = nItemIndex
  local tbMatchView = (self.tbTotalMatch[nGroupIndex + 1])[nItemIndex + 1]
  local tbMatch = tbCalendar.tbTotalMatch[nGroupIndex + 1].tbMatch[tbMatchView.nIndexId]
  local nMatchId = tbMatch.nMatchId
  --if nGroupIndex == 1 then
  --	Wnd_Show(self.UIGROUP,self.BTN_CHECKREMIND);
  --	if not tbCalendar.tbMatchNotify[nMatchId] then
  --		tbCalendar.tbMatchNotify[nMatchId] = 1;
  --	end
  --	Btn_Check(self.UIGROUP, self.BTN_CHECKREMIND, tbCalendar.tbMatchNotify[nMatchId]);
  --else
  --	Wnd_Hide(self.UIGROUP,self.BTN_CHECKREMIND);
  --end

  --self:SetTxt(self.TXT_SHOWMATCHNAME, tbMatch.szName);
  self:Link_match_OnClick(nil, string.format("%d,%d,0", nGroupIndex + 1, tbMatchView.nIndexId))
end

function uiCalendar:Link_match_OnClick(szWnd, szLink)
  local tbSplit = Lib:SplitStr(szLink)
  local nMatchType = tonumber(tbSplit[1])
  local nIndexId = tonumber(tbSplit[2])
  local nQaIdx = tonumber(tbSplit[3]) or 0
  local tbMInfo = tbCalendar.tbTotalMatch[nMatchType].tbMatch[nIndexId]
  local szText = "\n"
  --szText	= szText .. "<bclr=green><font=14>游戏介绍<font><bclr>\n\n";
  szText = szText .. "<bclr=blue>活动名<bclr>：" .. tbMInfo.szName .. "\n\n"
  local szLinkNpc = tbCalendar:GetVar(tbMInfo.varLinkNpc, "")
  if szLinkNpc ~= "" then
    szLinkNpc = string.gsub(szLinkNpc, "|", ",")
    szText = szText .. "<bclr=blue>报名NPC<bclr>：<font=18>" .. szLinkNpc .. "<font><color=green>(点击npc即可参加活动)<color>" .. "\n\n"
  end
  if tbMInfo.szName == "祈福" then
    szText = szText .. "<a=infor>我要祈福<a>\n\n"
  elseif tbMInfo.szName == "跨服宋金" then
    szText = szText .. "<a=infor>我要参加跨服宋金<a>\n\n"
  elseif tbMInfo.szName == "剑侠词典" then
    local tbQuestions = HelpQuestion:GetTitleTable(me)
    local nFlag = 0
    for nGroupId, szGroupTitle in pairs(tbQuestions) do
      nFlag = 1
      szText = szText .. string.format("<tab=15>我想回答<tab><a=question:%d>%s<a>\n", nGroupId, szGroupTitle)
    end
    if nFlag == 0 then
      szText = szText .. "<color=green>你暂时没有问题可以回答<color>\n"
    end
    szText = szText .. "\n"
  end
  szText = szText .. tbCalendar:GetVar(tbMInfo.varGuide, "") .. "<color>\n\n"

  local nLeftCount = tbCalendar:MatchCountSuit(tbMInfo)
  if nLeftCount ~= -1 then
    szText = szText .. "<bclr=blue>参加次数<bclr>：\n"
    szText = szText .. "今天剩余次数：" .. nLeftCount .. "\n\n"
  end
  szText = szText .. "<bclr=blue>奖励说明<bclr>：\n" .. tbCalendar:GetVar(tbMInfo.varAward, "") .. "<color>\n\n"

  --[[ 常见问题不要
	szText	= szText .. "\n<color=white><font=14>常见问题<font><color>\n";	
	if not tbMInfo.tbQA then
		tbMInfo.tbQA = {};
	end

	local tbQaFold	= self.tbQaFold;
	if (nQaIdx == 0) then
		tbQaFold		= {};
		self.tbQaFold	= tbQaFold;
	elseif (tbQaFold[nQaIdx]) then
		tbQaFold[nQaIdx]	= nil;
	else
		tbQaFold[nQaIdx]	= 1;
	end

	for nIdx, tb in pairs(tbMInfo.tbQA) do
		szText	= szText .. string.format("<a=match:%d,%d,%d>%s<a>\n", nMatchType,nIndexId, nIdx, tb[1]);
		if (tbQaFold[nIdx]) then
			szText	= szText .. tb[2] .. "\n\n";
		end
	end
	--]]
  self:SetTxtEx(self.TXX_MATCH, szText)
end

function uiCalendar:GetSelItemMatchId()
  local nGroupIndex, nItemIndex = GetOutLookCurSelItemIdx(self.UIGROUP, self.OUTLOOKPANEL)
  return self:GetItemMatchId(nGroupIndex, nItemIndex)
end

function uiCalendar:GetItemMatchId(nGroupIndex, nItemIndex)
  local tbView = (self.tbTotalMatch[nGroupIndex + 1])[nItemIndex + 1]
  return tbCalendar.tbTotalMatch[nGroupIndex + 1].tbMatch[tbView.nIndexId].nMatchId
end

function uiCalendar:OnUpdateCheckBtnRemind(nParam)
  local nMatchId = self:GetSelItemMatchId()
  tbCalendar.tbMatchNotify[nMatchId] = nParam
end

function uiCalendar:OnUpdateCheckBtnRemindAll(nParam)
  for nMatchId in pairs(tbCalendar.tbMatchNotify) do
    tbCalendar.tbMatchNotify[nMatchId] = nParam
  end
  tbCalendar.bMatchNotifyAll = nParam
  self:OnUpdateTotalMatch()
end

function uiCalendar:ShowMisc()
  local szText = string.format("本周家族目标: %s 本月竞技活动: %s", self:GetKinWeeklyAction(), self:GetEPlatFormAction())

  self:SetTxtEx(self.TXX_MISC, szText)
end

function uiCalendar:GetKinWeeklyAction()
  local szWeeklyAction = " 无 "
  local tbWeeklyAction = {
    [1] = "白虎堂",
    [2] = "宋金战场",
    [3] = "通缉任务",
    [4] = "逍遥谷",
    [5] = "军营副本",
  }
  local pKin = KKin.GetSelfKin()
  if not pKin then
    return szWeeklyAction
  end

  local nWeeklyAction = pKin.GetWeeklyTask()
  if not nWeeklyAction or nWeeklyAction < 1 or nWeeklyAction > 5 then
    return szWeeklyAction
  end

  szWeeklyAction = tbWeeklyAction[nWeeklyAction]
  return szWeeklyAction
end

function uiCalendar:GetEPlatFormAction()
  EPlatForm:GetKinEventPlatformData()
  local tbPlatformInfo = EPlatForm.tbPlatformInfo or {}
  local szEventName = tbPlatformInfo.szEventName or " 无 "
  return szEventName
end

function uiCalendar:ShowTimeFrame(nCurTime)
  local nDate_ServerStart = tonumber(KGblTask.SCGetDbTaskInt(DBTASD_SERVER_STARTTIME)) or 0
  local bShowTxt = 0
  for _, tbTimeFrame in ipairs(tbCalendar.tbTimeFrame) do
    local nSec = tbCalendar:GetTime(tbTimeFrame.nTimeFrameDay, tbTimeFrame.nTimeFrameTime, nDate_ServerStart)
    if nSec > nCurTime then
      self:ShowTimeFrameEx(tbTimeFrame, nCurTime, nSec)
      bShowTxt = 1
      break
    end
  end
  if bShowTxt == 0 then
    self:SetTxt(self.TXT_TIMERFRAME, "")
  end
end

function uiCalendar:ShowTimeFrameEx(tbTimeFrame, nCurTime, nTmpTime)
  local szText = ""
  if tbTimeFrame.nState == 1 then
    szText = "本服已" .. tbTimeFrame.szName
  else
    local nDetDay = Lib:GetLocalDay(nTmpTime) - Lib:GetLocalDay(nCurTime)
    nDetDay = math.abs(nDetDay)
    if nDetDay == 0 then
      szText = string.format("本服即将%s", tbTimeFrame.szName)
    else
      szText = string.format("本服距%s还有%d天", tbTimeFrame.szName, nDetDay)
    end
  end
  self:SetTxt(self.TXT_TIMERFRAME, szText)
end

function uiCalendar:Link_infor_OnClick(szWnd, szLinkData)
  if not self.nGroupIndex_OutLook or not self.nItemIndex_OutLook then
    return
  end
  local tbMatchView = (self.tbTotalMatch[self.nGroupIndex_OutLook + 1])[self.nItemIndex_OutLook + 1]
  local tbMatch = tbCalendar.tbTotalMatch[self.nGroupIndex_OutLook + 1].tbMatch[tbMatchView.nIndexId]
  if not tbMatch then
    return
  end
  if tbMatch.szName == "祈福" then
    UiManager:OpenWindow(Ui.UI_PLAYERPRAY)
  elseif tbMatch.szName == "跨服宋金" then
    UiManager:OpenWindow(Ui.UI_SPBATTLE_SIGNUP)
  end
end

-- 超链接 —— 帮助问答
function uiCalendar:Link_question_OnClick(szWnd, szGroupId)
  local nGroupId = tonumber(szGroupId)
  me.CallServerScript({ "HlpQue", nGroupId })
end
