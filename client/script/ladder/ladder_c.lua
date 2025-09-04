-- 文件名　：ladder_c.lua
-- 创建者　：zhouchenfei
-- 创建时间：2008-03-19 23:13:44

if not MODULE_GAMECLIENT then
  return
end

if not Ladder.tbSaveLadder then
  Ladder.tbSaveLadder = {}
end

if not Ladder.tbSaveList then
  Ladder.tbSaveList = {}
end

if not Ladder.tbLadderPlanName then
  Ladder.tbLadderPlanName = {}
end

function Ladder:InitLadderName()
  local tbData = Lib:LoadTabFile("\\setting\\player\\ladderid.txt")
  if not tbData then
    return
  end
  local tbPList = {}
  for _, tbRow in ipairs(tbData) do
    local nHugeId = tonumber(tbRow.HUGE_ID)
    local tbHuge = tbPList[nHugeId]
    if not tbHuge then
      tbHuge = {}
      tbPList[nHugeId] = tbHuge
    end
    local nMidId = tonumber(tbRow.MID_ID)
    local nSmallId = tonumber(tbRow.SMALL_ID)
    local szLadderName = tostring(tbRow.LADDER_NAME)
    local szUnit = tostring(tbRow.LADDER_UNIT)
    local nMode = tonumber(tbRow.SEARCHMOD)
    local nIsable = tonumber(tbRow.ISABLE)

    if not tbPList[nHugeId][nMidId] then
      tbPList[nHugeId][nMidId] = {}
    end

    if not tbPList[nHugeId][nMidId][nSmallId] then
      tbPList[nHugeId][nMidId][nSmallId] = {}
    end
    --		tbPList[nHugeId][nMidId][nSmallId].szLadderName = szLadderName;
    tbPList[nHugeId][nMidId][nSmallId].szUnit = szUnit
    tbPList[nHugeId][nMidId][nSmallId].nModeFlag = nMode
    tbPList[nHugeId][nMidId][nSmallId].nModeState = 0
    tbPList[nHugeId][nMidId][nSmallId].szShowName = szLadderName
    tbPList[nHugeId][nMidId][nSmallId].nIsable = nIsable
    tbPList[nHugeId][nMidId][nSmallId].nShowFlag = 0
    if 0 == nSmallId then
      tbPList[nHugeId][nMidId][nSmallId].nShowFlag = 1
    end
  end
  self.tbLadderPlanName.tbLadder = tbPList
  self.tbSavedPropLadder = {}
end

function Ladder:GetClassByType(nLadderType)
  local nClass = KLib.GetByte(nLadderType, 3)
  local nType = KLib.GetByte(nLadderType, 2)
  local nNum = KLib.GetByte(nLadderType, 1)
  local nClassType = nLadderType - nClass * 2 ^ 16 - nType * 2 ^ 8 - nNum
  return nClassType, nClass, nType, nNum
end

function Ladder:OnSyncLadderName(tbLadderName)
  if not tbLadderName then
    return
  end
  for nType, szName in pairs(tbLadderName) do
    local nClassType, nClass, nType, nNum = self:GetClassByType(nType)
    -- 如果这里报错那说明排行榜有问题了
    self.tbLadderPlanName.tbLadder[nClass][nType][nNum].szShowName = szName
  end
end

function Ladder:OnSyncLadderNameShowFlag(tbLadderNameFlag, nSaveTime, bNotify)
  if not tbLadderNameFlag then
    return
  end

  local tbPList = self.tbLadderPlanName.tbLadder
  for nHugeId, tbHugeList in pairs(tbPList) do
    for nMidId, tbMidList in pairs(tbHugeList) do
      for nSmallId, tbSmallList in pairs(tbMidList) do
        if type(nSmallId) == "number" and nSmallId > 0 then
          tbSmallList.nShowFlag = 0
        end
      end
    end
  end

  for _, nType in pairs(tbLadderNameFlag) do
    local nClassType, nClass, nType, nNum = self:GetClassByType(nType)
    -- 如果这里报错那说明排行榜有问题了
    self.tbLadderPlanName.tbLadder[nClass][nType][nNum].nShowFlag = 1
  end
  self.tbLadderPlanName.nSaveTime = nSaveTime
  if bNoNotify then
    return
  end
  CoreEventNotify(UiNotify.emCOREEVENT_LADDERPLANREFRESH)
end

function Ladder:OnSyncLadderPlan(tbLadder, bNoNotify)
  self.tbLadderPlanName = tbLadder
  if bNoNotify then
    return
  end
  CoreEventNotify(UiNotify.emCOREEVENT_LADDERPLANREFRESH)
end

function Ladder:GetLadderByType(nType)
  local nNowTime = GetTime()
  local tbLadder = self.tbSaveLadder[nType]

  if tbLadder and nNowTime - tbLadder.nSaveTime <= 10 then
    return tbLadder
  end

  local nSaveTime = self.tbLadderPlanName.nSaveTime
  if not nSaveTime then
    nSaveTime = 0
  end

  me.CallServerScript({ "LadderApplyCmd", nType, nSaveTime })
  return nil
end

function Ladder:OnSyncLadder(tbLadder)
  if not tbLadder then
    return
  end
  local nNowTime = GetTime()
  tbLadder.nSaveTime = nNowTime
  self.tbSaveLadder[tbLadder.nLadderType] = tbLadder
  CoreEventNotify(UiNotify.emCOREEVENT_LADDERREFRESH)
end

-- 根据第几页查找具体的排名列表		nMaxNumPerPage:每页玩家的个数 10 or 20  默认的是20个
function Ladder:GetListLadder(nType, nPage, nMaxNumPerPage)
  local nNowTime = GetTime()
  local tbLadder = self.tbSaveList[nType]

  local nPageOrig = nPage
  local nOffset = 0

  -- 纠正一下页码
  if nMaxNumPerPage and 20 ~= nMaxNumPerPage then
    nPage = nPage / 2
    if nPage ~= math.floor(nPage) then
      nPage = math.floor(nPage) + 1
    else
      nOffset = 10
    end
  end

  if tbLadder and tbLadder[nPage] and nNowTime - tbLadder[nPage].nSaveTime <= 10 then
    if not nMaxNumPerPage or nMaxNumPerPage == 20 then
      -- 每页20
      return tbLadder[nPage]
    else
      -- 每页10
      return self:GetCorrectedPage(tbLadder[nPage], nOffset)
    end
  end
  me.CallServerScript({ "LadderListApplyCmd", nType, nPage }) -- 程序里写死了，每次取一页--20个！！！
  return nil
end

function Ladder:OnSyncList(tbList)
  if not tbList then
    return
  end
  local nNowTime = GetTime()
  tbList.nSaveTime = nNowTime
  if not self.tbSaveList[tbList.nLadderType] then
    self.tbSaveList[tbList.nLadderType] = {}
  end
  self.tbSaveList[tbList.nLadderType][tbList.nPage] = tbList
  CoreEventNotify(UiNotify.emCOREEVENT_LADDERREFRESH)
end

function Ladder:GetCorrectedPage(tbPageSrc, nOffset)
  if not tbPageSrc then
    return nil
  end
  local tbPageCorrected = nil

  if #tbPageSrc.tbLadder >= nOffset then
    tbPageCorrected = {}
    tbPageCorrected.nMaxLadder = tbPageSrc.nMaxLadder
    tbPageCorrected.nLadderType = tbPageSrc.nLadderType
    tbPageCorrected.szContext = tbPageSrc.szContext
    tbPageCorrected.tbLadder = {}
  end

  for i = 1, 10 do
    local tbCont = tbPageSrc.tbLadder[nOffset + i]
    if tbCont then
      if not tbPageCorrected then
        tbPageCorrected = {}
        tbPageCorrected.tbLadder = {}
      end
      tbPageCorrected.tbLadder[i] = tbCont
    end
  end

  return tbPageCorrected
end

-- 根据玩家名查找
function Ladder:ApplySearchListByName(nType, szName)
  me.CallServerScript({ "LadderSearchListApplyCmd", nType, szName })
end

function Ladder:ApplySearchLadder(nCurPageIndex, nCurGenreIndex, nCurSubjectIndex, szName)
  me.CallServerScript({ "LadderApplyAdvSearchCmd", nCurPageIndex, nCurGenreIndex, nCurSubjectIndex, szName })
end

function Ladder:OnSyncSearchResult(tbList, szName)
  if not tbList then
    return
  end
  local nNowTime = GetTime()
  tbList.nSaveTime = nNowTime
  if not self.tbSaveList[tbList.nLadderType] then
    self.tbSaveList[tbList.nLadderType] = {}
  end
  self.tbSaveList[tbList.nLadderType][tbList.nPage] = tbList
  self.tbSearchResult = {}
  self.tbSearchResult.szName = szName
  self.tbSearchResult.nLadderType = tbList.nLadderType
  self.tbSearchResult.nPage = tbList.nPage
  self.tbSearchResult.tbLadder = tbList.tbLadder
  CoreEventNotify(UiNotify.emCOREEVENT_LADDERSEARCHREFRESH)
end

function Ladder:ClearLadder()
  self.tbSaveLadder = {}
  self.tbSaveList = {}
end

Ladder:InitLadderName()

function Ladder:_PR(tbLadder, szContext)
  if not tbLadder then
    print("没有排行榜")
    return
  end
  print("---------------------------------")
  print("szContext = ", szContext)
  for key, value in pairs(tbLadder) do
    print(key)
    if value then
      for ke, pv in pairs(value) do
        print(ke, pv)
      end
    end
  end
  print("---------------------------------")
end

-- 获真元排行榜
function Ladder:GetPropLadderByType(nType, nPage)
  if 1 > nPage then
    return nil
  end

  if not self.tbSavedPropLadder[nType] then
    self.tbSavedPropLadder[nType] = {}
  end
  local nCurTime = GetTime()
  local tbPropLadder = self.tbSavedPropLadder[nType]
  local nApplyPageNum = 2
  local nBegPage = nPage

  if tbPropLadder and tbPropLadder[nPage] and nCurTime - tbPropLadder[nPage].nSavedTime <= 10 then
    return tbPropLadder[nPage]
  end

  local nBegin = Ui(Ui.UI_LADDER).PLAYER_FPLIST_MAX_NUMBER * (nBegPage - 1) -- 默认获取数据范围起点
  local Count = Ui(Ui.UI_LADDER).PLAYER_FPLIST_MAX_NUMBER -- 默认获取数据范围长度

  me.CallServerScript({ "LadderGuidCmd", "ApplyData", nType, nBegin, Count, "Ladder:PropLadderCallback" })
  return nil
end

function Ladder:PropLadderCallback(tbPropLadder)
  --Lib:ShowTB(tbPropLadder);
  local nBeginId = tbPropLadder.nBeginId
  local nType = tbPropLadder.nType
  local nCurPage = math.floor(tbPropLadder.nBeginId / 10) + 1

  if not self.tbSavedPropLadder[nType] then
    self.tbSavedPropLadder[nType] = {}
  end

  local tbLocalLadder = {}
  tbLocalLadder.nMaxLadder = tbPropLadder.nMaxLadder
  tbLocalLadder.szContext = tbPropLadder.szContext
  tbLocalLadder.nSavedTime = GetTime()
  tbLocalLadder.tbLadder = {}
  tbLocalLadder.nLadderType = nType

  local nLocalId = 1
  for id = nBeginId, nBeginId + 10 do
    if tbPropLadder[id] then
      tbLocalLadder.tbLadder[nLocalId] = {}
      tbLocalLadder.tbLadder[nLocalId].dwValue = tbPropLadder[id][2]
      tbLocalLadder.tbLadder[nLocalId].szPlayerName = tbPropLadder[id][1]
      nLocalId = nLocalId + 1
    end
  end

  self.tbSavedPropLadder[nType][nCurPage] = tbLocalLadder

  CoreEventNotify(UiNotify.emCOREEVENT_LADDERREFRESH)
end
