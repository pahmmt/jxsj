-- 文件名　：eventnews.lua
-- 创建者　：sunduoliang
-- 创建时间：2009-03-30 16:11:23
-- 描  述  ：
local tbNews = {}
EventManager.News = EventManager.News or tbNews
EventManager.News.NEWSID = 10000 --从10000开始
function tbNews:Init()
  self.HelpSprite = {}
  self.NewsInfo = {}
  self:LoadHelpSprite()
  self:LoadNewsInfo()

  --活动系统，从10000开始
  for nNewsId, tbNInfo in ipairs(self.HelpSprite) do
    local uiHelpSprite = Ui:GetClass("helpsprite")
    uiHelpSprite.tbNewsInfo[self.NEWSID + nNewsId] = tbNInfo
  end
end

function tbNews:GetNewsData()
  local tbData = {}
  local nNowDate = tonumber(os.date("%Y%m%d%H%M", GetTime()))
  for _, tbNInfo in ipairs(self.NewsInfo) do
    local nFlag, nTimer = EventManager.tbFun:CheckTime(tbNInfo.szTimeFrame)
    if nFlag == 0 and tbNInfo.nStartDate >= 0 and tbNInfo.nEndDate >= 0 and (nNowDate >= tbNInfo.nStartDate) and (nNowDate < tbNInfo.nEndDate or tbNInfo.nEndDate == 0) then
      table.insert(tbData, { tbNInfo.szName, tbNInfo.varContent })
    end
  end
  return tbData
end

function tbNews:LoadHelpSprite()
  local tbFile = EventManager.tbFun:LoadTabFile("\\setting\\event\\manager\\helpsprite.txt")
  if not tbFile then
    return 0
  end
  local nNowDate = tonumber(os.date("%Y%m%d%H%M", GetTime()))
  for i, tbParam in ipairs(tbFile) do
    if i >= 2 then
      local nEventId = tonumber(tbParam.EventId)
      local nNewsId = tonumber(tbParam.NewsId)

      local szTitle = EventManager.tbFun:ClearString(tbParam.Title)
      local szDesc = EventManager.tbFun:ClearString(tbParam.Desc)
      if EventManager.EventManager.tbParam[nEventId] then
        local nStartDate = EventManager.EventManager.tbParam[nEventId].nStartDate
        local nEndDate = EventManager.EventManager.tbParam[nEventId].nEndDate
        local szTimeFrame = EventManager.EventManager.tbParam[nEventId].szTimeFrame
        --by jiazhenwei 启动的时候判定下时间轴是否满足，不满足return
        if nStartDate >= 0 and nEndDate >= 0 and (nNowDate < nEndDate or nEndDate == 0) and szTitle ~= "" then
          table.insert(self.HelpSprite, {
            szName = szTitle,
            nLifeTime = -1,
            varWeight = function()
              local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
              local nFlag, nTimer = EventManager.tbFun:CheckTime(szTimeFrame)
              if nFlag == 0 and nCurTime > nStartDate and (nCurTime < nEndDate or nEndDate == 0) then
                return 10
              end
              return 0
            end,
            varContent = szDesc,
          })
        end
      end
    end
  end
end

local function localsort(tbA, tbB)
  if tbA.nEventId == tbB.nEventId then
    return tbA.nNewsId < tbB.nNewsId
  end
  return tbA.nEventId > tbB.nEventId
end

function tbNews:LoadNewsInfo()
  local tbFile = EventManager.tbFun:LoadTabFile("\\setting\\event\\manager\\newaction.txt")
  if not tbFile then
    return 0
  end
  local nNowDate = tonumber(os.date("%Y%m%d%H%M", GetTime()))
  for i, tbParam in ipairs(tbFile) do
    if i >= 2 then
      local nEventId = tonumber(tbParam.EventId)
      local nNewsId = tonumber(tbParam.NewsId)
      local szTitle = EventManager.tbFun:ClearString(tbParam.Title)
      local szDesc = EventManager.tbFun:ClearString(tbParam.Desc)

      if EventManager.EventManager.tbParam[nEventId] then
        local nStartDate = EventManager.EventManager.tbParam[nEventId].nStartDate
        local nEndDate = EventManager.EventManager.tbParam[nEventId].nEndDate
        local szTimeFrame = EventManager.EventManager.tbParam[nEventId].szTimeFrame
        if nStartDate >= 0 and nEndDate >= 0 and (nNowDate < nEndDate or nEndDate == 0) and szTitle ~= "" then
          table.insert(self.NewsInfo, {
            nEventId = nEventId,
            nNewsId = nNewsId,
            szName = szTitle,
            nStartDate = nStartDate,
            nEndDate = nEndDate,
            szTimeFrame = szTimeFrame,
            varContent = szDesc,
          })
        end
      end
    end
  end
  table.sort(self.NewsInfo, localsort)
end
