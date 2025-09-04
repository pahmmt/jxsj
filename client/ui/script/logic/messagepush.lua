-- 文件名　：messagepush.lua
-- 创建者　：huangxiaoming
-- 创建时间：2012-11-2 15:29:00
-- 描  述  ：推送界面 逻辑部分

Require("\\script\\event\\specialevent\\messagepush\\messagepush_def.lua")

local tbMessagePush = Ui.tbLogic.tbMessagePush or {}
Ui.tbLogic.tbMessagePush = tbMessagePush
local tbMessagePushLogic = SpecialEvent.tbMessagePush -- 客户端服务端公用逻辑
local tbNewCalendar = Ui.tbLogic.tbNewCalendar

tbMessagePush.MAX_VIEW_COUNT = 3 -- 最多显示3个

tbMessagePush.szMessageListPath = "\\setting\\task\\messagepush\\messagelist.txt"
tbMessagePush.szImageListPath = "\\setting\\task\\messagepush\\imagetype.txt"

function tbMessagePush:Init()
  self:LoadInitFile()
end

function tbMessagePush:LoadInitFile()
  self.tbMessageList = self:LoadAllMessage() or {}
  self.tbImagePathList = self:LoadAllImagePath() or {}
end

function tbMessagePush:LoadAllImagePath()
  local tbFile = Lib:LoadTabFile(self.szImageListPath)
  if not tbFile then
    print("【MessagePush Error】读取文件错误,LoadAllImagePath", self.szImageListPath)
    return
  end
  local tbImagePathList = {}
  for nId, tbParam in ipairs(tbFile) do
    if nId > 1 then
      tbImagePathList[tonumber(tbParam.Type)] = tbParam.Path
    end
  end
  return tbImagePathList
end

function tbMessagePush:LoadAllMessage()
  local tbFile = Lib:LoadTabFile(self.szMessageListPath)
  if not tbFile then
    print("【MessagePush Error】读取文件错误,LoadAllMessage", self.szMessageListPath)
    return
  end
  local tbMessageList = {}
  local tbIdList = {}
  for nId, tbParam in ipairs(tbFile) do
    local nEndTime = tonumber(tbParam.EndTime) or -1
    if nId > 1 and (nEndTime == -1 or tonumber(GetLocalDate("%Y%m%d%H%M")) < nEndTime) then -- 没有超过结束日期的加载进来
      local tbTemp = {}
      tbTemp.nId = tonumber(tbParam.Id)
      tbTemp.nRelateMatchId = tonumber(tbParam.RelateMatchId) or -1
      tbTemp.szName = tbParam.Name or ""
      tbTemp.nImageType = tonumber(tbParam.ImageType) or 1
      tbTemp.nBeginTime = tonumber(tbParam.BeginTime) or -1
      tbTemp.nEndTime = nEndTime
      tbTemp.nTaskType = tonumber(tbParam.TaskType) or 0
      tbTemp.nTaskIndex = tonumber(tbParam.TaskIndex) or -1
      tbTemp.nWeight = tonumber(tbParam.Weight) or 0
      local tbTrigger = {}
      tbTrigger.nMinLevel = tonumber(tbParam.Trigger_MinLevel) or -1
      tbTrigger.nMaxLevel = tonumber(tbParam.Trigger_MaxLevel) or -1
      tbTrigger.nMinOpenDay = tonumber(tbParam.Trigger_MinOpenDay) or -1
      tbTrigger.nMaxOpenDay = tonumber(tbParam.Trigger_MaxOpenDay) or -1
      tbTrigger.szTimeFrame = tbParam.Trigger_TimeFrame or ""
      tbTrigger.nKinTong = tonumber(tbParam.Trigger_KinTong) or 0
      tbTrigger.nHonorLimit = tonumber(tbParam.Trigger_Honor) or 0
      local tbWeekDay = {}
      -- 周几显示，用逗号做区分
      local szWeekDay = tbParam.Trigger_WeekDay or ""
      if szWeekDay ~= "" then
        local tbResult = Lib:SplitStr(szWeekDay, ",")
        for k, v in ipairs(tbResult) do
          local nV = tonumber(v)
          if not nV then
            print(string.format("Line:%s, WeekDay Error", nId))
          else
            tbWeekDay[#tbWeekDay + 1] = nV
          end
        end
      end
      tbTrigger.tbWeekDay = tbWeekDay
      local tbMonthDay = {}
      local szMonthDay = tbParam.Trigger_MonthDay or ""
      if szMonthDay ~= "" then
        local tbResult = Lib:SplitStr(szMonthDay, ",")
        for k, v in ipairs(tbResult) do
          local nV = tonumber(v)
          if not nV then
            print(string.format("Line:%s, MonthDay Error", nId))
          else
            tbMonthDay[#tbMonthDay + 1] = nV
          end
        end
      end
      tbTrigger.tbMonthDay = tbMonthDay
      local tbRemainMonthDay = {}
      local szRemainMonthDay = tonumber(tbParam.Trigger_RemainMonthDay) or ""
      if szRemainMonthDay ~= "" then
        local tbResult = Lib:SplitStr(szRemainMonthDay, ",")
        for k, v in ipairs(tbResult) do
          local nV = tonumber(v)
          if not nV then
            print(string.format("Line:%s, MonthDay Error", nId))
          else
            tbRemainMonthDay[#tbRemainMonthDay + 1] = nV
          end
        end
      end
      tbTrigger.tbRemainMonthDay = tbRemainMonthDay
      tbTemp.tbTrigger = tbTrigger
      tbTemp.nClickDisappear = tonumber(tbParam.ClickDisappear) or 0
      tbTemp.szTip = tbParam.Tip or ""
      tbTemp.szClickEvent = tbParam.Click_Event
      tbTemp.tbClickParam = {}
      for i = 1, 4 do
        local szParam = "Click_Param" .. i
        if tbParam[szParam] and tbParam[szParam] ~= "" then
          local nParamCount = #tbTemp.tbClickParam
          tbTemp.tbClickParam[nParamCount + 1] = tbParam[szParam]
        end
      end
      if tbIdList[tbTemp.nId] then
        print(string.format("Line:%s, Id(%s, %s) 重复被忽略了", nId, tbTemp.nId, tbTemp.szName))
      else
        tbIdList[tbTemp.nId] = 1
        table.insert(tbMessageList, tbTemp)
      end
    end
  end
  -- 按权重排序，用于优化GetPushMessageList函数，超过3个可以直接返回
  table.sort(tbMessageList, self._MatchCmp)
  return tbMessageList
end

function tbMessagePush:GetPushMessageList()
  if tbMessagePushLogic.IS_OPEN ~= 1 then
    return {}
  end
  local tbMessageList = {}
  for nIndex, tbTemp in ipairs(self.tbMessageList) do
    local nAchieveFlag = self:GetTaskValue(tbTemp.nTaskType, tbTemp.nTaskIndex)
    if nAchieveFlag == 0 then -- 已完成的直接过滤
      local tbTrigger = tbTemp.tbTrigger
      local nNowDateTime = tonumber(GetLocalDate("%Y%m%d%H%M"))
      local nServerOpenDay = TimeFrame:GetServerOpenDay()
      if (tbTemp.nBeginTime == -1 or nNowDateTime >= tbTemp.nBeginTime) and (tbTemp.nEndTime == -1 or nNowDateTime < tbTemp.nEndTime) and (tbTrigger.nMinLevel == -1 or me.nLevel >= tbTrigger.nMinLevel) and (tbTrigger.nMaxLevel == -1 or me.nLevel < tbTrigger.nMaxLevel) and (tbTrigger.nHonorLimit == -1 or me.GetHonorLevel() >= tbTrigger.nHonorLimit) and (tbTrigger.nMinOpenDay == -1 or nServerOpenDay >= tbTrigger.nMinOpenDay) and (tbTrigger.nMaxOpenDay == -1 or nServerOpenDay <= tbTrigger.nMaxOpenDay) and (not tbTrigger.szTimeFrame or tbTrigger.szTimeFrame == "" or TimeFrame:GetState(tbTrigger.szTimeFrame) == 1) and self:CheckKinTong(tbTrigger.nKinTong) == 1 then
        -- 检查星期,月天数，月剩余天数
        if self:CheckWeekDay(tbTrigger.tbWeekDay) == 1 and self:CheckMonthDay(tbTrigger.tbMonthDay) == 1 and self:CheckRemainMonthDay(tbTrigger.tbRemainMonthDay) == 1 then
          -- 定时条件检查是否在提示时间
          if self:CheckTimingActive(tbTemp.nRelateMatchId) == 1 then
            local tbMessage = {}
            tbMessage.nId = tbTemp.nId
            tbMessage.szName = tbTemp.szName
            tbMessage.szImagePath = self.tbImagePathList[tbTemp.nImageType] or ""
            tbMessage.nWeight = tbTemp.nWeight
            tbMessage.nClickDisappear = tbTemp.nClickDisappear
            tbMessage.szTip = tbTemp.szTip
            tbMessage.nTaskType = tbTemp.nTaskType
            tbMessage.nTaskIndex = tbTemp.nTaskIndex
            tbMessage.szClickEvent = tbTemp.szClickEvent
            tbMessage.tbClickParam = tbTemp.tbClickParam
            table.insert(tbMessageList, tbMessage)
            if #tbMessageList >= self.MAX_VIEW_COUNT then -- 超过3个可以直接返回了，权重在读表时排过序了
              break
            end
          end
        end
      end
    end
  end
  return tbMessageList
end

tbMessagePush._MatchCmp = function(tbA, tbB)
  if tbA.nWeight == tbB.nWeight then
    return tbA.nId < tbB.nId
  end
  return tbA.nWeight > tbB.nWeight
end

-- 完成指定消息任务
function tbMessagePush:AchieveTask(nType, nIndex)
  if nType == 1 then
    tbMessagePushLogic:AchieveLifeTask(nIndex)
  elseif nType == 2 then
    tbMessagePushLogic:AchieveMonthTask(nIndex)
  elseif nType == 3 then
    tbMessagePushLogic:AchieveWeekTask(nIndex)
  elseif nType == 4 then
    tbMessagePushLogic:AchieveDayTask(nIndex)
  end
end

-- 充值指定小小控制变量
function tbMessagePush:ResetTask(nType, nIndex)
  if nType == 1 then
    tbMessagePushLogic:ResetLifeTask(nIndex)
  elseif nType == 2 then
    tbMessagePushLogic:ResetMonthTask(nIndex)
  elseif nType == 3 then
    tbMessagePushLogic:ResetWeekTask(nIndex)
  elseif nType == 4 then
    tbMessagePushLogic:ResetDayTask(nIndex)
  end
end

-- 获取指定消息控制变量值
function tbMessagePush:GetTaskValue(nType, nIndex)
  local nValue = 0
  if nType == 1 then
    nValue = tbMessagePushLogic:GetLifeTask(nIndex)
  elseif nType == 2 then
    nValue = tbMessagePushLogic:GetMonthTask(nIndex)
  elseif nType == 3 then
    nValue = tbMessagePushLogic:GetWeekTask(nIndex)
  elseif nType == 4 then
    nValue = tbMessagePushLogic:GetDayTask(nIndex)
  end
  return nValue
end

-- 检查家族帮会条件
function tbMessagePush:CheckKinTong(nFlag)
  if nFlag == 0 then
    return 1
  end
  if nFlag == 1 then
    if me.dwKinId > 0 then
      return 1
    else
      return 0
    end
  end
  if nFlag == 2 then
    if me.dwKinId > 0 then
      return 0
    else
      return 1
    end
  end
  if nFlag == 3 then
    if me.dwTongId > 0 then
      return 0
    else
      return 1
    end
  end
  if nFlag == 4 then
    if me.dwKinId <= 0 then
      return 0
    elseif me.dwTongId > 0 then
      return 0
    else
      return 1
    end
  end
  print("messagepush error kintong type", nFlag)
  return 0
end

-- 检查星期
function tbMessagePush:CheckWeekDay(tbWeekDay)
  if #tbWeekDay == 0 then
    return 1
  end
  local nNowWeekDay = tonumber(GetLocalDate("%w"))
  for _, nWeekDay in ipairs(tbWeekDay) do
    if nWeekDay == nNowWeekDay then
      return 1
    end
  end
  return 0
end

-- 检查月天数
function tbMessagePush:CheckMonthDay(tbMonthDay)
  if #tbMonthDay == 0 then
    return 1
  end
  local nNowMonthDay = tonumber(GetLocalDate("%d"))
  for _, nMonthDay in ipairs(tbMonthDay) do
    if nMonthDay == nNowMonthDay then
      return 1
    end
  end
  return 0
end

-- 检查月倒数天数
function tbMessagePush:CheckRemainMonthDay(tbRemainMonthDay)
  if #tbRemainMonthDay == 0 then
    return 1
  end
  local nNowMonthDay = tonumber(GetLocalDate("%d"))
  local nNowMonth = tonumber(GetLocalDate("%m"))
  local nNowYear = tonumber(GetLocalDate("%Y"))
  local nNextMonth = nNowMonth + 1
  if nNowMonth == 12 then
    nNextMonth = 1
    nNowYear = nNowYear + 1
  end
  local nNextMonthTime = nNowYear * 10000 + nNextMonth * 100 + 1
  local nNextMonthSec = Lib:GetDate2Time(nNextMonthTime)
  local nNextMonthDay = Lib:GetLocalDay(nNextMonthSec)
  local nNowDay = Lib:GetLocalDay()
  for _, nRemainMonthDay in ipairs(tbRemainMonthDay) do
    if nRemainMonthDay == (nNextMonthDay - nNowDay) then
      return 1
    end
  end
  return 0
end

-- 检查定时活动是否在提醒期
function tbMessagePush:CheckTimingActive(nRelationMatchId)
  if nRelationMatchId == -1 then
    return 1
  end
  return tbNewCalendar:CheckMatchActive(nRelationMatchId, me.nLevel)
end
