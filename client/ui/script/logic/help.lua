local tbHelp = Ui.tbLogic.tbHelp or {}
Ui.tbLogic.tbHelp = tbHelp
local tbTimer = Ui.tbLogic.tbTimer

tbHelp.TIME_NOTIFY = 10 * Env.GAME_FPS

tbHelp.POPTIP_WNDNAME = "UI_PLAYERSTATE"
tbHelp.POPTIP_CONTROL = "BtnHelp"

tbHelp.SPR_RIGHTDOWN = "\\image\\ui\\001a\\main\\popo\\popo_RD.spr"
tbHelp.SPR_LEFTDOWN = "\\image\\ui\\001a\\main\\popo\\popo_LD.spr"
tbHelp.SPR_RIGHTUP = "\\image\\ui\\001a\\main\\popo\\popo_RU.spr"
tbHelp.SPR_LEFTUP = "\\image\\ui\\001a\\main\\popo\\popo_LU.spr"

tbHelp.ARROW_RIGHTDOWN = 1
tbHelp.ARROW_LEFTDOWN = 2
tbHelp.ARROW_RIGHTUP = 3
tbHelp.ARROW_LEFTUP = 4
tbHelp.SHOWTIPTIME = 10 * Env.GAME_FPS

function tbHelp:Init()
  if self.nTimerRegId then
    return
  end
  self.nMsgOpenFlag = 0
  self.nSysOpenFlag = 0
  self.nOpenFlag = 0
  self.nSysCount = 0
  self.nTimerRegId = 0
  self.IsSysOpen = 0
  self.nPopTimerId = 0

  self.tbSystemNewsList = {} -- 保存上一次系统消息的数组
  self.tbTempNewsList = {} -- 保存上一次消息的数组
  self.tbTempDNewsList = {} -- 保存上一次动态消息

  self.tbPopTip_List = {}
end

function tbHelp:SetOpenFlag()
  self.IsSysOpen = 0
end

function tbHelp:OnTimer()
  if me.GetLastLoginTime() == 0 then
    return
  else
    if UiManager:WindowVisible(Ui.UI_HELPSPRITE) == 1 then
      Ui(Ui.UI_HELPSPRITE):UpdateSysTime()
    end
    local nLastLoginTime = me.GetLastLoginTime()
    local nNowTime = GetTime()
    if nNowTime - nLastLoginTime <= 60 then
      return
    end
  end

  -- 这段是显示静态消息的泡泡
  local szMsg = ""
  local nImportant = 0 -- 消息显示权重值
  local nIsNeedOpen = 0
  local tbTempNewList = {}
  for nNewsId, tbNInfo in pairs(Ui(Ui.UI_HELPSPRITE).tbNewsInfo) do
    local tbNew = Ui(Ui.UI_HELPSPRITE):GetNewsInfo(nNewsId)
    if tbNew and tbNew.bReaded ~= 1 then
      local szNewsMsg = tbNew.szMsg
      if szNewsMsg then
        if not self.tbTempNewsList[szNewsMsg] then
          nImportant = 1
          nIsNeedOpen = 1
          szMsg = szNewsMsg
        end
        tbTempNewList[szNewsMsg] = 1
      end
    end
  end
  self.tbTempNewsList = tbTempNewList

  -- 这段显示动态消息泡泡
  local tbTempDNewsList = {}
  if Task.tbHelp.tbNewsList then
    local tbNewsList = Task.tbHelp.tbNewsList
    for nId, tbNewsInfo in pairs(tbNewsList) do
      if tbNewsInfo and tbNewsInfo.nEndTime > GetTime() then
        local bReaded = Task.tbHelp:GetDNewsReaded(nId)
        if bReaded ~= 1 then
          local szTitle = tbNewsInfo.szTitle
          if not self.tbTempDNewsList[szTitle] then
            nImportant = 99
            nIsNeedOpen = 1
            szMsg = szTitle
          end
          tbTempDNewsList[szTitle] = 1
        end
      end
    end
  end
  self.tbTempDNewsList = tbTempDNewsList

  -- 这段显示系统推荐泡泡
  local tbTempSysList = {}
  for nId, tbMInfo in pairs(Ui(Ui.UI_HELPSPRITE).tbRecInfo) do
    local nExpStar = Ui(Ui.UI_HELPSPRITE):GetVar(tbMInfo.varExpStar, 0)
    local nMoneyStar = Ui(Ui.UI_HELPSPRITE):GetVar(tbMInfo.varMoneyStar, 0)
    local nSort = Ui(Ui.UI_HELPSPRITE):GetVar(tbMInfo.varSortStar, 0)
    local nStar = nExpStar + nMoneyStar -- 星级和
    local nShowType = Ui(Ui.UI_HELPSPRITE):GetVar(tbMInfo.varShowType, 0)
    if nExpStar > 0 and nMoneyStar > 0 then
      local szSysName = Ui(Ui.UI_HELPSPRITE):GetVar(tbMInfo.szName)
      tbTempSysList[szSysName] = 1
      if not self.tbSystemNewsList[szSysName] then -- 不存在
        if nSort > nImportant and nShowType == 1 then
          szMsg = Ui(Ui.UI_HELPSPRITE):GetVar(tbMInfo.varPopMsg, 0)
          nImportant = nSort
          nIsNeedOpen = 1
        end
      end
    end
  end
  self.tbSystemNewsList = tbTempSysList
  if nIsNeedOpen == 1 then
    -- 马来没有最新消息
    if UiManager.IVER_nReciveNews == 1 then
      self:ShowPopoTip(szMsg)
    end

    self.nOpenFlag = 1
  end
end

function tbHelp:ShowPopoTip(szPopTipTxt)
  local nLineWidth = 200
  if IsWndExist(self.POPTIP_WNDNAME, self.POPTIP_CONTROL) ~= 1 then
    return
  end
  local nWnd_Width, nWnd_Height = Wnd_GetSize(self.POPTIP_WNDNAME, self.POPTIP_CONTROL)
  Wnd_SetPopTip(self.POPTIP_WNDNAME, self.POPTIP_CONTROL, nWnd_Width - 46, nWnd_Height - 5, self.SPR_LEFTUP, 15, 28, szPopTipTxt, nLineWidth)
  if self.nPopTimerId <= 0 then
    self.nPopTimerId = tbTimer:Register(self.SHOWTIPTIME, self.Timer_PopClose, self)
  end
end

function tbHelp:HidePopTip()
  Wnd_CancelPopTip(self.POPTIP_WNDNAME, self.POPTIP_CONTROL)
end

function tbHelp:Timer_PopClose()
  self:HidePopTip()
  if self.nPopTimerId and self.nPopTimerId > 0 then
    tbTimer:Close(self.nPopTimerId)
    self.nPopTimerId = 0
  end
  self.nOpenFlag = 0
end

function tbHelp:OnShowNewsTip(nNewsId)
  assert(Ui(Ui.UI_HELPSPRITE).tbNewsInfo[nNewsId])
  local szMsg = Ui(Ui.UI_HELPSPRITE).tbNewsInfo[nNewsId].varContent
end

function tbHelp:OnEnterGame()
  assert(self.nTimerRegId == 0)
  self.nTimerRegId = tbTimer:Register(self.TIME_NOTIFY, self.OnTimer, self)
  Ui(Ui.UI_HELPSPRITE):InitHelpData()
end

function tbHelp:OnLeaveGame()
  if self.nTimerRegId ~= 0 then
    tbTimer:Close(self.nTimerRegId)
    self.nTimerRegId = 0
  end

  if self.nPopTimerId and self.nPopTimerId > 0 then
    tbTimer:Close(self.nPopTimerId)
    self.nPopTimerId = 0
  end
end

-- 解析tabfile的函数
function tbHelp:LoadHelpTabFile(szFileName)
  local szTxtContent = KIo.ReadTxtFile(szFileName)
  if not szTxtContent then
    return
  end
  local tbFileData = {}
  for nRowId, szLine in ipairs(Lib:SplitStr(szTxtContent, "\tEndTag\r\n")) do
    if szLine == "" then
      break
    end
    local tbPart = {}
    for nColId, szTxt in ipairs(Lib:SplitStr(szLine, "\t")) do
      if string.sub(szTxt, 1, 1) == '"' and string.sub(szTxt, -1) == '"' then -- 防止配置文件误出现引号
        szTxt = Lib:ReplaceStr(string.sub(szTxt, 2, -2), '""', '"')
      end
      tbPart[nColId] = szTxt
    end
    tbFileData[nRowId] = tbPart
  end
  return tbFileData
end

-- 开放89级等级上线的时间点 + 7天，距离周六，周日还有几天
function tbHelp:GetTimeInfoTitle()
  local nDetDay = self:GetDetDomainOpenDay()
  local szMsg = ""
  if nDetDay >= 0 then
    szMsg = "已经开始了"
  else
    szMsg = "离开始还有 " .. math.abs(nDetDay) .. " 天"
  end
  return szMsg
end

function tbHelp:GetDetDomainOpenDay()
  local nShowTime = 1236873600 -- 2009 3 13
  local nFlag = 0
  local nCurTime = GetTime()
  local nNeedDay = EventManager.IVER_nDomainBattleDay + 1

  if nNeedDay > 7 then
    nNeedDay = 1
  end

  -- 开放89级上限后在过七天
  local nTmpTime = TimeFrame:GetTime("OpenLevel89") + 3600 * 7 * 24
  local tbTmpTime = os.date("*t", nTmpTime)
  local nwDay = tbTmpTime.wday
  local nFinalShowTime = 0
  if tbTmpTime.wday > 1 and tbTmpTime.wday < nNeedDay then
    nTmpTime = nTmpTime + (nNeedDay - tbTmpTime.wday) * 3600 * 24
    nwDay = nNeedDay
  end

  if tbTmpTime.wday <= 7 and tbTmpTime.wday > nNeedDay then
    nwDay = 1
  end

  nFinalShowTime = nTmpTime
  if nShowTime > nFinalShowTime then
    nFinalShowTime = nShowTime
  end

  local nDetTime = Lib:GetLocalDay(nCurTime) - Lib:GetLocalDay(nFinalShowTime)
  if nDetTime >= 0 and nDetTime <= 30 then
    nFlag = 1
  end

  local nDetDay = Lib:GetLocalDay(nCurTime) - Lib:GetLocalDay(nTmpTime)
  return nDetDay, nwDay, nFlag
end

function tbHelp:GetDetQinTombOpenDay()
  --20090623开始放消息
  local nShowTime = 1236873600 + 102 * 3600 * 24 -- 2009 6 22
  local nFlag = 0
  local nCurTime = GetTime()
  --开放时间：150级开放后的60天
  local nTmpTime = TimeFrame:GetTime("OpenLevel150") + 3600 * 60 * 24

  local nFinalShowTime = nTmpTime

  if nShowTime > nFinalShowTime then
    nFinalShowTime = nShowTime
  end

  --消息显示一个月有效期
  local nDetTime = Lib:GetLocalDay(nCurTime) - Lib:GetLocalDay(nFinalShowTime)
  if nDetTime >= 0 and nDetTime <= 30 then
    nFlag = 1
  end

  local nDetDay = Lib:GetLocalDay(nCurTime) - Lib:GetLocalDay(nTmpTime)
  return nDetDay, nFlag
end
