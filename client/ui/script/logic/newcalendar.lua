-- 文件名　：newcalendar.lua
-- 创建者　：huangxiaoming
-- 创建时间：2012-09-25 15:29:00
-- 描  述  ：新活动日历 逻辑部分

local tbCalendar = Ui.tbLogic.tbNewCalendar or {}
Ui.tbLogic.tbNewCalendar = tbCalendar

tbCalendar.szAllMatchPath = "\\setting\\task\\newcalendar\\match.txt"
tbCalendar.szTimeFramePath = "\\setting\\task\\newcalendar\\timeframe.txt"
tbCalendar.szEquipDescPath = "\\setting\\task\\newcalendar\\desc\\equipdesc.txt"
tbCalendar.szPrestigeDescPath = "\\setting\\task\\newcalendar\\desc\\prestigedesc.txt"
tbCalendar.szWllsMatchPath = "\\setting\\mission\\wlls\\league_table.txt"

tbCalendar.emSORTTYPE_ALLSTAR = 1
tbCalendar.emSORTTYPE_EQUIPSTAR = 2
tbCalendar.emSORTTYPE_XUANJINGSTAR = 3
tbCalendar.emSORTTYPE_EXPERIENCESTAR = 4
tbCalendar.emSORTTYPE_BINDMONEYSTAR = 5
tbCalendar.emSORTTYPE_PRESTIGESTAR = 6

tbCalendar.szTimingDesc_end = "已结束"
tbCalendar.szTimingDesc_rest = "间歇期"

function tbCalendar:Init()
  self:LoadInitFile()
end

function tbCalendar:LoadInitFile()
  self.tbTotalMatch = self:LoadAllMatch() or {}
  self.tbTimeFrame = self:LoadTimeFrame() or {}
  self.tbEquipDesc = self:LoadEquipDesc() or {}
  self.tbPrestigeDesc = self:LoadPrestigeDesc() or {}
  self.tbWllsMatch = self:LoadMatchFile() or {}
end

function tbCalendar:LoadAllMatch()
  local tbFile = Lib:LoadTabFile(self.szAllMatchPath)
  if not tbFile then
    print("【NewCalendar Error】读取文件错误,LoadAllMatch", self.szAllMatchPath)
    return
  end
  local tbAllMatch = {}
  for nId, tbParam in ipairs(tbFile) do
    if nId > 1 then
      local tbTemp = {}
      tbTemp.nMatchId = tonumber(tbParam.MatchId)
      tbTemp.szName = tbParam.Name -- 活动名称
      tbTemp.varIsOpen = tbParam.IsOpen -- 开服天数限制
      tbTemp.varMatchOpen = tbParam.MatchOpen
      tbTemp.varAchieveState = tbParam.AchieveState or 0
      tbTemp.varCanJoin = tbParam.CanJoin or 0
      tbTemp.nMinLevel = tonumber(tbParam.MinLevel) or 0
      tbTemp.nCountType = tonumber(tbParam.CountType)
      if tbTemp.nCountType == 1 then
        tbTemp.varCurCount = tbParam.CurCount
        tbTemp.varMaxCount = tbParam.MaxCount
      elseif tbTemp.nCountType == 2 then
        tbTemp.varRemainTime = tbParam.RemainTime
      end
      tbTemp.tbStarList = {} -- 星级列表，用于排序
      for i = 1, 3 do
        tbTemp.tbStarList[i] = {}
        tbTemp.tbStarList[i][self.emSORTTYPE_ALLSTAR] = tonumber(tbParam["AllStar" .. i]) or 0
        tbTemp.tbStarList[i][self.emSORTTYPE_EQUIPSTAR] = tonumber(tbParam["EquipStar" .. i]) or 0
        tbTemp.tbStarList[i][self.emSORTTYPE_XUANJINGSTAR] = tonumber(tbParam["XuanJingStar" .. i]) or 0
        tbTemp.tbStarList[i][self.emSORTTYPE_EXPERIENCESTAR] = tonumber(tbParam["ExperienceStar" .. i]) or 0
        tbTemp.tbStarList[i][self.emSORTTYPE_BINDMONEYSTAR] = tonumber(tbParam["BindMoneyStar" .. i]) or 0
        tbTemp.tbStarList[i][self.emSORTTYPE_PRESTIGESTAR] = tonumber(tbParam["PrestigeStar" .. i]) or 0
      end
      tbTemp.nIsPVP = tonumber(tbParam.IsPVP) or 0
      tbTemp.nTypeId = self:GetMatchTypeId(tbParam.TypeDesc)
      tbTemp.nTimeType = tonumber(tbParam.TimeType) or 2
      if tbTemp.nTimeType == 1 then
        tbTemp.tbTimeList = self:LoadMatchTime(tbParam.TimeParam)
      else
        tbTemp.szTimeDesc = tbParam.TimeParam
      end
      tbTemp.szCondition = tbParam.Condition -- 条件
      -- 生成奖励表
      tbTemp.tbAward = {}
      for i = 1, 5 do
        local szAwardImage = "Award" .. i .. "Image"
        if tbParam[szAwardImage] and tbParam[szAwardImage] ~= "" then
          local nAwardCount = #tbTemp.tbAward
          tbTemp.tbAward[nAwardCount + 1] = {}
          tbTemp.tbAward[nAwardCount + 1].szImage = tbParam[szAwardImage]
          tbTemp.tbAward[nAwardCount + 1].szTip = tbParam["Award" .. i .. "Desc"] or ""
        end
      end
      tbTemp.varOpenExtendAward = tbParam.OpenExtendAward
      -- 生成限制条件奖励表
      tbTemp.tbExtendAward = {}
      for i = 1, 3 do
        local szAwardImage = "ExtendAward" .. i .. "Image"
        if tbParam[szAwardImage] and tbParam[szAwardImage] ~= "" then
          local nAwardCount = #tbTemp.tbExtendAward
          tbTemp.tbExtendAward[nAwardCount + 1] = {}
          tbTemp.tbExtendAward[nAwardCount + 1].szImage = tbParam[szAwardImage]
          tbTemp.tbExtendAward[nAwardCount + 1].szTip = tbParam["ExtendAward" .. i .. "Desc"] or ""
        end
      end
      -- 点击参加
      tbTemp.szAttendFunc = tbParam.AttendFunc
      tbTemp.tbAttendFuncParam = {}
      for i = 1, 8 do
        local szParam = "Param" .. i
        if tbParam[szParam] and tbParam[szParam] ~= "" then
          local nParamCount = #tbTemp.tbAttendFuncParam
          tbTemp.tbAttendFuncParam[nParamCount + 1] = tbParam[szParam]
        end
      end
      tbTemp.nLinkHelpType = tonumber(tbParam.LinkHelpType) or -1
      tbTemp.szLinkHelpName = tbParam.LinkHelpName
      table.insert(tbAllMatch, tbTemp)
    end
  end
  return tbAllMatch
end

-- 获取活动类型的ID，动态生成的ID,用于建立筛选列表，暂时没用到
function tbCalendar:GetMatchTypeId(szTypeName)
  self.tbMatchTypeSet = self.tbMatchTypeSet or {}
  for nId, szName in ipairs(self.tbMatchTypeSet) do
    if szTypeName == szName then
      return nId
    end
  end
  local nCount = #self.tbMatchTypeSet
  nCount = nCount + 1
  self.tbMatchTypeSet[nCount] = szTypeName
  return nCount
end

-- 加载比赛时间
function tbCalendar:LoadMatchTime(szPath)
  local tbTime = {}
  local tbFile = Lib:LoadTabFile(szPath)
  if not tbFile then
    print("【newcalendarCalendar Error】读取文件错误，LoadMatchTime", szPath)
    return
  end
  for nId, tbParam in ipairs(tbFile) do
    if nId > 1 then
      table.insert(tbTime, { tonumber(tbParam.JoinTime), tonumber(tbParam.StartTime), tonumber(tbParam.EndTime), tbParam.IsOpen or "" })
    end
  end
  return tbTime
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

function tbCalendar:LoadTimeFrame()
  local tbFile = Lib:LoadTabFile(self.szTimeFramePath)
  if not tbFile then
    print("【NewCalendar Error】读取文件错误,LoadTimeFrame", self.szTimeFramePath)
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

function tbCalendar:LoadEquipDesc()
  local tbDesc = {}
  local tbFile = Lib:LoadTabFile(self.szEquipDescPath)
  if not tbFile then
    print("【newcalendarCalendar Error】读取文件错误，LoadEquipDesc", self.szEquipDescPath)
    return
  end
  for nId, tbParam in ipairs(tbFile) do
    if nId > 1 then
      tbDesc[tonumber(tbParam.MatchId)] = tbParam.EquipName
    end
  end
  return tbDesc
end

function tbCalendar:LoadPrestigeDesc()
  local tbDesc = {}
  local tbFile = Lib:LoadTabFile(self.szPrestigeDescPath)
  if not tbFile then
    print("【newcalendarCalendar Error】读取文件错误，LoadPrestigeDesc", self.szPrestigeDescPath)
    return
  end
  for nId, tbParam in ipairs(tbFile) do
    if nId > 1 then
      tbDesc[tonumber(tbParam.MatchId)] = { tbParam.CurCount, tbParam.MaxCount }
    end
  end
  return tbDesc
end

-- 获取活动列表，nSortType：排序类型, nPlayerLevel:玩家等级，bShowAll:是否显示那些时间轴到了，但是不是活动日期的活动
function tbCalendar:GetMatchList(nSortType, nPlayerLevel, bShowAll)
  bShowAll = bShowAll or 0
  local tbUsableMatch = {} -- 筛选出所有当前可参加的活动
  local nStarIndex = self:GetStarIndexByPlayerLevel(nPlayerLevel)
  for _, tbMatch in ipairs(self.tbTotalMatch) do
    -- 排除时间轴还未到的
    local nIsOpen = tonumber(self:GetVar(tbMatch.varIsOpen))
    if nIsOpen == 1 then
      local nIsMatchOpen = self:GetVar(tbMatch.varMatchOpen)
      local szNextTime = nil
      if tbMatch.nTimeType == 1 then
        szNextTime = self:GetNextOpenTime(tbMatch.tbTimeList)
      else
        szNextTime = tbMatch.szTimeDesc
      end
      local nAchieveState = tonumber(self:GetVar(tbMatch.varAchieveState))
      if
        (bShowAll == 1 or (tonumber(self:GetVar(tbMatch.varMatchOpen)) == 1 and nPlayerLevel >= tbMatch.nMinLevel and nAchieveState ~= 1 and (szNextTime ~= self.szTimingDesc_end and szNextTime ~= self.szTimingDesc_rest))) -- 全部显示或显示满足条件的
        and tbMatch.tbStarList[nStarIndex][nSortType] > 0
      then
        local tbTemp = {}
        tbTemp.nMatchId = tbMatch.nMatchId
        tbTemp.szName = tbMatch.szName
        tbTemp.nAchieveState = nAchieveState
        tbTemp.nStar = tbMatch.tbStarList[nStarIndex][nSortType]
        tbTemp.szStarDesc = self:GetStarViewDesc(tbTemp.nMatchId, nSortType, tbTemp.nStar)
        tbTemp.szTypeName = self.tbMatchTypeSet[tbMatch.nTypeId]
        tbTemp.nIsPVP = tbMatch.nIsPVP
        if tbMatch.nCountType == 1 then
          tbTemp.nCurCount = self:GetVar(tbMatch.varCurCount)
          tbTemp.nMaxCount = self:GetVar(tbMatch.varMaxCount)
        else
          tbTemp.nRemainTime = tonumber(self:GetVar(tbMatch.varRemainTime))
        end
        tbTemp.nTimeType = tbMatch.nTimeType
        tbTemp.szNextTime = szNextTime
        tbTemp.szCondition = tbMatch.szCondition
        tbTemp.tbAward = {}
        for i = 1, #tbMatch.tbAward do
          tbTemp.tbAward[i] = Lib:CopyTB1(tbMatch.tbAward[i])
        end
        tbTemp.tbExtendAward = {}
        if tonumber(self:GetVar(tbMatch.varOpenExtendAward)) == 1 then
          for i = 1, #tbMatch.tbExtendAward do
            tbTemp.tbExtendAward[i] = Lib:CopyTB1(tbMatch.tbExtendAward[i])
          end
        end
        tbTemp.tbAttend = {}
        tbTemp.tbAttend.szFunc = tbMatch.szAttendFunc
        tbTemp.tbAttend.tbParam = {}
        for i = 1, #tbMatch.tbAttendFuncParam do
          tbTemp.tbAttend.tbParam[i] = tbMatch.tbAttendFuncParam[i]
        end
        tbTemp.nLinkHelpType = tbMatch.nLinkHelpType
        tbTemp.szLinkHelpName = tbMatch.szLinkHelpName
        table.insert(tbUsableMatch, tbTemp)
      end
    end
  end
  table.sort(tbUsableMatch, self._MatchCmp)
  return tbUsableMatch
end

tbCalendar._MatchCmp = function(tbA, tbB)
  if tbA.szNextTime ~= tbB.szNextTime and (tbA.szNextTime == tbCalendar.szTimingDesc_end or tbB.szNextTime == tbCalendar.szTimingDesc_end) then
    return tbB.szNextTime == tbCalendar.szTimingDesc_end
  end
  if tbA.szNextTime ~= tbB.szNextTime and (tbA.szNextTime == tbCalendar.szTimingDesc_rest or tbB.szNextTime == tbCalendar.szTimingDesc_rest) then
    return tbB.szNextTime == tbCalendar.szTimingDesc_rest
  end
  if tbA.nAchieveState == tbB.nAchieveState then
    if tbA.nTimeType ~= tbB.nTimeType then
      return tbA.nTimeType < tbB.nTimeType
    end
    if tbA.nStar == tbB.nStar then
      return tbA.nMatchId < tbB.nMatchId
    end
    return tbA.nStar > tbB.nStar
  end
  return tbA.nAchieveState < tbB.nAchieveState
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

local function fnStrValue(szVal)
  local varType = loadstring(szVal)
  if type(varType) == "function" then
    return varType()
  else
    print(">>NewCalendar:fnStrValue type error>>>>>>>", szVal)
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
    varResult = string.gsub(var, "<%%(.-)%%>", fnStrValue) -- 替换目标是函数表示匹配的字符串做为函数参数调用
  elseif szType == "number" then
    varResult = var
  else
    print("【Error】tbCalendar:GetStrVal", var) --,debug.traceback());
  end
  return varResult or varDefault
end

-- 定时类型获取下一场副本活动时间
function tbCalendar:GetNextOpenTime(tbTime)
  local nCount = #tbTime
  local nCurTime = tonumber(GetLocalDate("%H%M"))
  local nNextTime = -1
  for i = 1, nCount do -- 找一个最接近的时间
    if tonumber(self:GetVar(tbTime[i][4])) ~= 0 then
      if self:IsTimeBetween(nCurTime, tbTime[i][1], tbTime[i][3]) == 0 then
        if nCurTime < tbTime[i][1] then -- 属于报名间歇期
          nNextTime = -2
          break
        end
      else
        nNextTime = tbTime[i][2]
        break
      end
    end
  end
  if nNextTime == -1 then
    return self.szTimingDesc_end
  end
  if nNextTime == -2 then
    return self.szTimingDesc_rest
  end
  if nNextTime >= 2400 then -- 24点之后是第二天开始时间
    nNextTime = nNextTime - 2400
  end
  local nHour = math.floor(nNextTime / 100)
  local nMinute = math.mod(nNextTime, 100)
  return string.format("%02s:%02s", nHour, nMinute)
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

-- 根据玩家等级获取推荐星级表的索引
function tbCalendar:GetStarIndexByPlayerLevel(nLevel)
  if nLevel >= 100 then
    return 3
  end
  if nLevel >= 50 then
    return 2
  end
  return 1
end

-- 获取星级项对应的描述
function tbCalendar:GetStarViewDesc(nMatchId, nMatchType, nStar)
  local szDesc = ""
  if nMatchType == self.emSORTTYPE_EQUIPSTAR then -- 装备
    szDesc = self.tbEquipDesc[nMatchId] or ""
  elseif nMatchType == self.emSORTTYPE_PRESTIGESTAR then -- 声望
    local nCurCount = "--"
    local nMaxCount = "--"
    if self.tbPrestigeDesc[nMatchId] then
      nCurCount = self:GetVar(self.tbPrestigeDesc[nMatchId][1]) or "--"
      nMaxCount = self:GetVar(self.tbPrestigeDesc[nMatchId][2]) or "--"
    end
    szDesc = string.format("%s/%s", nCurCount, nMaxCount)
  end
  return szDesc
end

-- 检查指定ID的match是否在活动时间内
function tbCalendar:CheckMatchActive(nMatchId, nPlayerLevel)
  local nResult = 0
  local nStarIndex = self:GetStarIndexByPlayerLevel(nPlayerLevel)
  for _, tbMatch in ipairs(self.tbTotalMatch) do
    if tbMatch.nMatchId == nMatchId then
      if tonumber(self:GetVar(tbMatch.varIsOpen)) ~= 1 then
        break
      end
      if tonumber(self:GetVar(tbMatch.varMatchOpen)) ~= 1 then
        break
      end
      if tonumber(self:GetVar(tbMatch.varAchieveState)) ~= 0 then
        break
      end
      if tbMatch.tbStarList[nStarIndex][1] <= 0 then
        break
      end
      if tbMatch.nTimeType == 1 then
        local szNextTime = self:GetNextOpenTime(tbMatch.tbTimeList)
        if szNextTime == self.szTimingDesc_end or szNextTime == self.szTimingDesc_rest then
          break
        end
      end
      nResult = 1
      break
    end
  end
  return nResult
end
