-- 文件名　：calendar.lua
-- 创建者　：zounan
-- 创建时间：2010-03-10 14:38:33
-- 描  述  ：活动日历 逻辑部分

local tbCalendar = Ui.tbLogic.tbCalendar or {}
Ui.tbLogic.tbCalendar = tbCalendar
local tbTimer = Ui.tbLogic.tbTimer
local tbSaveData = Ui.tbLogic.tbSaveData

tbCalendar.HORNTIP_CTRL = "horntip"
tbCalendar.szTimingMatchPath = "\\setting\\task\\calendar\\timingmatch.txt"
tbCalendar.szTimeFramePath = "\\setting\\task\\calendar\\timeframe.txt"
tbCalendar.szDailyMatchPath = "\\setting\\task\\calendar\\dailymatch.txt"
tbCalendar.szWllsMatchPath = "\\setting\\mission\\wlls\\league_table.txt"
tbCalendar.DATA_KEY = "Calendar"
tbCalendar.DATA_KEY_2 = "CalendarReMindAll"
tbCalendar.START_NOTIFY = 10 -- 活动开始前10分钟提醒
tbCalendar.TIME_NOTIFY = 40 * Env.GAME_FPS --40s一次轮询

function tbCalendar:Init()
  if UiManager.IVER_bOpenCalendar == 0 then
    return
  end
  if self.nTimerRegId then
    return
  end
  self:LoadInitFile()
  self.tbMatchNotify = {} -- 以活动ID为索引
  self.nTimerRegId = 0
end

function tbCalendar:OnTimer()
  local nLastLoginTime = me.GetLastLoginTime()
  if nLastLoginTime == 0 then
    return
  end

  if UiManager:WindowVisible(Ui.UI_CALENDAR) == 1 then
    Ui(Ui.UI_CALENDAR):UpdateSysTime()
  end

  --	local nNowTimeDesc	= GetTime();
  --	if (nNowTimeDesc - nLastLoginTime <= 60) then
  --		return;
  --	end

  local nCurTime = tonumber(GetLocalDate("%H%M"))

  --定时活动提醒
  for nIndexId, tbMatch in ipairs(self.tbTimingMatch.tbMatch) do
    local nIsNotify = self.tbMatchNotify[tbMatch.nMatchId] or 1
    local nCanJoin = tonumber(self:GetVar(tbMatch.varCanJoin, 0))
    local nMatchOpen = tonumber(tbCalendar:GetVar(tbMatch.varMatchOpen, 0))
    local nCountSuit = self:MatchCountSuit(tbMatch)

    if nCanJoin and nCanJoin == 1 and nCountSuit ~= 0 and nMatchOpen == 1 then
      if not self.tbNotifyMatch[nIndexId] then
        for nTimeIndex, tbTimeInfo in ipairs(tbMatch.tbTime) do
          if (self:IsTimeNotify(nCurTime, tbTimeInfo[2]) == 1) and self:CheckConidtion(tbTimeInfo[4]) == 1 then
            self.tbNotifyMatch[nIndexId] = { nTimeIndex = nTimeIndex, nIsShow = 0, nIsNotify = nIsNotify }
            break
          end
        end
      else
        local nTimeIndex = self.tbNotifyMatch[nIndexId].nTimeIndex
        if (self:IsTimeNotify(nCurTime, tbMatch.tbTime[nTimeIndex][2]) == 1) and self:CheckConidtion(tbMatch.tbTime[nTimeIndex][4]) == 1 then
          self.tbNotifyMatch[nIndexId].nIsNotify = nIsNotify
        else
          self.tbNotifyMatch[nIndexId] = nil
        end
      end
    end
  end

  self:ShowHornTip(self.tbNotifyMatch)
end

function tbCalendar:ShowHornTip(tbNotifyMatch)
  local szName = ""
  local nCount = 0
  for nIndex, tbInfo in pairs(tbNotifyMatch) do
    if tbInfo.nIsNotify == 1 and tbInfo.nIsShow == 0 then
      if szName == "" then
        szName = self.tbTimingMatch.tbMatch[nIndex].szName
      end
      nCount = nCount + 1
    end
  end
  if nCount == 0 then
    UiManager:CloseWindow(Ui.UI_HORNTIP)
    return
  end
  if UiManager:WindowVisible(Ui.UI_HORNTIP) == 1 then
    return 0
  end

  UiManager:OpenWindow(Ui.UI_HORNTIP, tbNotifyMatch, szName)
  return 0
end

function tbCalendar:OnEnterGame()
  if UiManager.IVER_bOpenCalendar == 0 then
    return
  end
  self.tbMatchNotify = tbSaveData:Load(self.DATA_KEY) or {}
  for _, tbMatch in ipairs(self.tbTimingMatch.tbMatch) do
    self.tbMatchNotify[tbMatch.nMatchId] = self.tbMatchNotify[tbMatch.nMatchId] or 1
  end
  self.bMatchNotifyAll = tonumber(tbSaveData:Load(self.DATA_KEY_2)) or 0
  self.tbNotifyMatch = {}
  assert(self.nTimerRegId == 0)
  --	self.nTimerRegId = tbTimer:Register(self.TIME_NOTIFY, self.OnTimer, self);
  --	Ui(Ui.UI_HELPSPRITE):InitHelpData();
  EPlatForm:GetKinEventPlatformData() --同步用
end

function tbCalendar:OnLeaveGame()
  if UiManager.IVER_bOpenCalendar == 0 then
    return
  end
  if self.nTimerRegId ~= 0 then
    tbTimer:Close(self.nTimerRegId)
    self.nTimerRegId = 0
  end
  self.tbNotifyMatch = {}
  tbSaveData:Save(self.DATA_KEY, self.tbMatchNotify or {})
  tbSaveData:Save(self.DATA_KEY_2, self.bMatchNotifyAll or 1)
end

function tbCalendar:Parse2str(tbMatch, tbParam, str)
  if not tbParam[str] then
    return
  end
  local _, _, sznIndex = string.find(tbParam[str], "lua:(%d+)")
  if sznIndex then
    --		print(">>todo>>");
    return
  end
  local szVar = "var" .. str
  tbMatch[szVar] = tbParam[str]
end

function tbCalendar:LoadInitFile()
  self.tbTotalMatch = {}
  self.tbDailyMatch = {}
  self.tbWllsMatch = {}
  --	self.tbBenifitsMatch = {};
  --  self.tbSpecialMatch  = {};
  self.tbTimingMatch = self:LoadTimingFile()
  self.tbDailyMatch = self:LoadDailyFile()
  self.tbWllsMatch = self:LoadMatchFile()
  self.tbTotalMatch[1] = self.tbDailyMatch
  self.tbTotalMatch[2] = self.tbTimingMatch
  self.tbTimeFrame = self:LoadTimeFrame() or {}
end

function tbCalendar:LoadMatchFile()
  local tbFile = Lib:LoadTabFile(self.szWllsMatchPath)
  if not tbFile then
    print("【Calendar Error】读取文件错误,WllsMatchPath", self.szWllsMatchPath)
    return
  end
  local tbMatch = {}
  for nId, tbParam in ipairs(tbFile) do
    if nId > 1 then
      local nSession = tonumber(tbParam.Session)
      local nLeagueType = tonumber(tbParam.LeagueType)
      local nTimeType = 1
      if nLeagueType == 2 or nLeagueType == 3 then
        nTimeType = 2
      end
      if nSession and nTimeType then
        tbMatch[nSession] = tbMatch[nSession] or nTimeType
      end
    end
  end
  return tbMatch
end

function tbCalendar:LoadTimingFile()
  local tbFile = Lib:LoadTabFile(self.szTimingMatchPath)
  if not tbFile then
    print("【Calendar Error】读取文件错误,LoadTimingFile", self.szTimingMatchPath)
    return
  end
  local tbTimingMatch = {}
  tbTimingMatch.tbMatch = {}
  for nId, tbParam in ipairs(tbFile) do
    if nId > 1 then
      local tbMatch = {}
      tbMatch.szName = tbParam.Name --活动的名称
      tbMatch.nMatchId = tonumber(tbParam.MatchId) --ID
      tbMatch.szMatchSpr = tbParam.MatchSpr
      self:Parse2str(tbMatch, tbParam, "MatchOpen")
      self:Parse2str(tbMatch, tbParam, "CanJoin")
      self:Parse2str(tbMatch, tbParam, "CurCount")
      self:Parse2str(tbMatch, tbParam, "MaxCount")
      self:Parse2str(tbMatch, tbParam, "Guide")
      self:Parse2str(tbMatch, tbParam, "Award")
      self:Parse2str(tbMatch, tbParam, "LinkNpc")
      self:Parse2str(tbMatch, tbParam, "MinLevel")
      self:Parse2str(tbMatch, tbParam, "Visible")
      if tbParam.TimeLink and tbParam.TimeLink ~= "" then
        tbMatch.tbTime = self:LoadMatchTime(tbParam.TimeLink)
      end
      tbMatch.tbQA = {}
      --	if tbParam.QALink and tbParam.QALink ~= "" then
      --		tbMatch.tbQA   = self:LoadQA(tbParam.QALink); QA不要了
      --	end
      table.insert(tbTimingMatch.tbMatch, tbMatch)
    end
  end
  self:InitTimingViewTable(tbTimingMatch)
  return tbTimingMatch
end

function tbCalendar:LoadDailyFile()
  local tbFile = Lib:LoadTabFile(self.szDailyMatchPath)
  if not tbFile then
    print("【Calendar Error】读取文件错误,LoadDailyFile", self.szDailyMatchPath)
    return
  end
  local tbDailyMatch = {}
  tbDailyMatch.tbMatch = {}
  for nId, tbParam in ipairs(tbFile) do
    if nId > 1 then
      local tbMatch = {}
      tbMatch.szName = tbParam.Name --活动的名称
      tbMatch.nMatchId = tonumber(tbParam.MatchId) --ID
      tbMatch.szMatchSpr = tbParam.MatchSpr
      self:Parse2str(tbMatch, tbParam, "MatchOpen")
      self:Parse2str(tbMatch, tbParam, "CanJoin")
      self:Parse2str(tbMatch, tbParam, "CurCount")
      self:Parse2str(tbMatch, tbParam, "MaxCount")
      self:Parse2str(tbMatch, tbParam, "Guide")
      self:Parse2str(tbMatch, tbParam, "Award")
      self:Parse2str(tbMatch, tbParam, "LinkNpc")
      self:Parse2str(tbMatch, tbParam, "MinLevel")
      tbMatch.tbQA = {}
      --	if tbParam.QALink and tbParam.QALink ~= "" then
      --		tbMatch.tbQA   = self:LoadQA(tbParam.QALink);
      --	end
      table.insert(tbDailyMatch.tbMatch, tbMatch)
    end
  end
  tbDailyMatch.tbView = {}
  for nIndex, tbMatch in ipairs(tbDailyMatch.tbMatch) do
    tbDailyMatch.tbView[nIndex] = { nIndexId = nIndex }
  end
  return tbDailyMatch
end

--合成一个以时间为基准的table 类似归并排序
function tbCalendar:InitTimingViewTable(tbMatchType)
  local tbOff = {}
  local tbMatch = tbMatchType.tbMatch
  tbMatchType.tbView = {} -- 以时间为基准的table,显示用
  local tbView = tbMatchType.tbView
  local nLength = 0
  for i = 1, #tbMatch do
    tbOff[i] = 1 -- 偏移量先置为1
    nLength = nLength + #tbMatch[i].tbTime -- 计算需循环几次
  end
  local nMin = 1
  for i = 1, nLength do
    nMin = 0
    for j = 1, #tbOff do
      if tbOff[j] <= #tbMatch[j].tbTime then
        if nMin == 0 or (tbMatch[j].tbTime[tbOff[j]])[2] < (tbMatch[nMin].tbTime[tbOff[nMin]])[2] then -- 以开始时间排序
          nMin = j
        end
      end
    end
    if nMin ~= 0 then
      table.insert(tbView, { tbTime = tbMatch[nMin].tbTime[tbOff[nMin]], nIndexId = nMin })
      tbOff[nMin] = tbOff[nMin] + 1
    end
  end
end

-- 加载比赛时间
function tbCalendar:LoadMatchTime(szPath)
  local tbTime = {}
  local tbFile = Lib:LoadTabFile(szPath)
  if not tbFile then
    print("【Calendar Error】读取文件错误，LoadMatchTime", szPath)
    return
  end

  for nId, tbParam in ipairs(tbFile) do
    if nId > 1 then
      table.insert(tbTime, { tonumber(tbParam.JoinTime), tonumber(tbParam.StartTime), tonumber(tbParam.EndTime), tbParam.IsOpen or "" })
    end
  end
  return tbTime
end

-- 加载QA
function tbCalendar:LoadQA(szPath)
  local tbQA = {}
  local tbFile = Lib:LoadTabFile(szPath)
  if not tbFile then
    print("【Calendar Error】读取文件错误，LoadQA", szPath)
    return
  end

  for nId, tbParam in ipairs(tbFile) do
    if nId > 1 then
      table.insert(tbQA, { tbParam.Question, tbParam.Answer })
    end
  end
  return tbQA
end

function tbCalendar:LoadTimeFrame()
  local tbFile = Lib:LoadTabFile(self.szTimeFramePath)
  if not tbFile then
    print("【Calendar Error】读取文件错误,LoadTimeFrame", self.szTimeFramePath)
    return
  end
  local tbTimeFrame = {}
  for nId, tbParam in ipairs(tbFile) do
    if nId > 1 then
      local tbFrame = {}
      tbFrame.szName = tbParam.Name
      tbFrame.nTimeFrameDay = tonumber(tbParam.TimeFrameDay)
      tbFrame.nTimeFrameTime = tonumber(tbParam.TimeFrameTime)
      tbFrame.nState = tonumber(tbParam.State)
      table.insert(tbTimeFrame, tbFrame)
    end
  end
  return tbTimeFrame
end

local function fnStrValue(szVal)
  local varType = loadstring(szVal)
  if type(varType) == "function" then
    return varType()
  else
    print(">>Calendar:fnStrValue type error>>>>>>>")
    return varType
  end
end

function tbCalendar:GetVar(var, varDefault)
  local szType = type(var)
  local varResult = nil
  if szType == "function" then
    local bOk, varRet = Lib:CallBack({ var })
    if bOk then
      varResult = varRet
    end
  elseif szType == "string" then
    varResult = string.gsub(var, "<%%(.-)%%>", fnStrValue)
  elseif szType == "number" then
    --	varResult = string.format("%s",var);
    varResult = var
  else
    print("【Error】tbCalendar:GetStrVal", var) --,debug.traceback());
  end
  return varResult or varDefault
end

--查看该时间是否可以提醒
function tbCalendar:IsTimeNotify(nCurTime, nStartTime)
  local nNotifyTime = 0
  local nMinute = nStartTime % 100 - self.START_NOTIFY
  local nHour = math.floor(nStartTime / 100)
  if nMinute < 0 then
    nMinute = nMinute + 60
    nHour = nHour - 1
    if nHour < 0 then
      nHour = nHour + 24
    end
  end
  nNotifyTime = nHour * 100 + nMinute
  return self:IsTimeBetween(nCurTime, nNotifyTime, nStartTime)
end

--判断curTime　是不是在　FirstTime 和 SecondTime 之间 是则返回 1 否则返回0
function tbCalendar:IsTimeBetween(nCurTime, nFirstTime, nSecondTime)
  if nFirstTime > nSecondTime then
    if nCurTime < nSecondTime or nCurTime >= nFirstTime then
      return 1
    end
  else
    if nCurTime >= nFirstTime and nCurTime < nSecondTime then
      return 1
    end
  end
  return 0
end

--参加次数是否还有剩余 0表示没有 -1表示无次数限制
function tbCalendar:MatchCountSuit(tbMatch)
  local nCountSuit = -1
  local nCurCount = tonumber(self:GetVar(tbMatch.varCurCount))
  local nMaxCount = tonumber(self:GetVar(tbMatch.varMaxCount))
  if not nMaxCount then
    return nCountSuit
  end
  nCountSuit = nMaxCount - (nCurCount or 0)
  if nCountSuit <= 0 then
    nCountSuit = 0
  end
  return nCountSuit
end

function tbCalendar:CheckConidtion(var)
  if (tonumber(self:GetVar(var, 1)) or 1) == 1 then
    return 1
  end

  return 0
end

--判断当前时间是否已过了时间轴
function tbCalendar:CheckTimerFrame(nFrameDay, nFrameTime)
  nFrameTime = nFrameTime or 0
  local nDate_ServerStart = tonumber(KGblTask.SCGetDbTaskInt(DBTASD_SERVER_STARTTIME)) or 0
  local nSec = self:GetTime(nFrameDay, nFrameTime, nDate_ServerStart)
  if GetTime() > nSec then
    return 1
  end
  return 0
end

--获得某时间轴类开启时间，秒数
function tbCalendar:GetTime(nFrameDay, nFrameTime, nDate_ServerStart)
  local nHour = math.floor(nFrameTime / 100)
  local nMin = math.mod(nFrameTime, 100)
  local nSec = 0
  if nFrameDay == 0 then
    nSec = nDate_ServerStart
  else
    nSec = nDate_ServerStart + (nFrameDay - 1) * 86400 + (nHour * 3600 + nMin * 60)
  end
  return nSec
end
