local uiTaskTrack = Ui:GetClass("tasktrack")
local uiTaskTracktmp = Ui:GetClass("tasktracktmp")
local tbTimer = Ui.tbLogic.tbTimer
local tbTempData = Ui.tbLogic.tbTempData
local tbObject = Ui.tbLogic.tbObject
local tbTempItem = Ui.tbLogic.tbTempItem
local tbAutoPath = Ui.tbLogic.tbAutoPath

uiTaskTrack.TEXTE_MSG = "TxtMsg"
uiTaskTrack.COLOR_TASKNAME = "Gold" --	任务名,黄色
uiTaskTrack.COLOR_FINISHED = "Green" --	已完成,绿色
uiTaskTrack.COLOR_UNFINISHED = "Red" --	未完成,红
uiTaskTrack.MAX_TRACK_TASK = 3 --	最多可跟踪的任务数目
uiTaskTrack.REFRESHTIME = Env.GAME_FPS * 2 --	目标刷新间隔时间
uiTaskTrack.TXX_INFOR = "TxtExInFor"

uiTaskTrack.ISTRACK = true

--任务跟踪道具
uiTaskTrack.OBJ_ItemListIndexName = uiTaskTrack.OBJ_ItemListIndexName or {}
uiTaskTrack.OBJ_ItemListIndexId = uiTaskTrack.OBJ_ItemListIndexId or {}
uiTaskTrack.ContainerList = uiTaskTrack.ContainerList or {}
uiTaskTrack.HangHeight = 19 --每一行的高度包括行间距
uiTaskTrack.TxtInFor = 30 --"我还可以干什么"的高度；
uiTaskTrack.nItemCount = 3 --  如果一个任务需要用多个道具暂不支持。
for i = 1, uiTaskTrack.nItemCount do
  uiTaskTrack.OBJ_ItemListIndexName[i] = "ObjItem" .. i
  uiTaskTrack.OBJ_ItemListIndexId["ObjItem" .. i] = i
end

uiTaskTrack.szNewTaskMsg = " <pos=请前往花灯会,taoxizhen,1925,3460>\n"

-- 战场即时消息相关 --
uiTaskTrack.TIME_TEMPCHANGE = Env.GAME_FPS * 3 --	临时改变模式的恢复时间

-- 道具配置表信息存在临时表中
uiTaskTrack.tbObjItem = uiTaskTrack.tbObjItem or {}

-- 载入任务道具相关的信息
function uiTaskTrack:LoadInfo()
  local tbFileData = Lib:LoadTabFile("\\setting\\task\\tasktrack_item.txt")
  if not tbFileData then
    print("[任务面板]tasktrack_item加载失败")
    return
  end
  for _, tbRow in ipairs(tbFileData) do
    local nTaskId = tonumber(tbRow.TaskId) or 0
    local nReferId = tonumber(tbRow.ReferId) or 0
    local nCurStep = tonumber(tbRow.CurStep) or 0
    local nGenre = tonumber(tbRow.Genre) or 0
    local nDetailType = tonumber(tbRow.DetailType) or 0
    local nParticularType = tonumber(tbRow.ParticularType) or 0
    local nLevel = tonumber(tbRow.Level) or 0
    local nBind = tonumber(tbRow.Bind) or 1
    local nCount = tonumber(tbRow.Count) or 1
    local szPic = tbRow.Icon
    if nGenre <= 0 or nDetailType <= 0 or nParticularType <= 0 or nLevel <= 0 then
      return
    end
    if not self.tbObjItem[nTaskId] then
      self.tbObjItem[nTaskId] = {}
    end
    if not self.tbObjItem[nTaskId][nReferId] then
      self.tbObjItem[nTaskId][nReferId] = {}
    end
    self.tbObjItem[nTaskId][nReferId][nCurStep] = { nGenre, nDetailType, nParticularType, nLevel, nBind, nCount, zPic }
  end
end

uiTaskTrack:LoadInfo()

-- 检查该任务是不是有任务道具
function uiTaskTrack:CheckTaskItem(nTaskId, nReferId, nCurStep)
  if (not self.tbObjItem[nTaskId]) or not self.tbObjItem[nTaskId][nReferId] or not self.tbObjItem[nTaskId][nReferId][nCurStep] then
    return
  end

  local tbItemInfo = self.tbObjItem[nTaskId][nReferId][nCurStep]
  return tbItemInfo
end

-- OnObjGridEnter事件
function uiTaskTrack:OnObjGridEnter(szObjName, nX, nY)
  local tbObj = nil
  if self.OBJ_ItemListIndexId[szObjName] then
    local nIndex = self.OBJ_ItemListIndexId[szObjName]
    tbObj = self.ContainerList[nIndex]:GetObj(nX, nY)
  end

  if not tbObj then
    return 0
  end

  local pItem = tbObj.pItem
  if not pItem then
    return 0
  end

  Wnd_ShowMouseHoverInfo(self.UIGROUP, szObjName, pItem.GetCompareTip(Item.TIPS_NORMAL, tbObj.szBindType))
end

-- OnObjGridUse事件
function uiTaskTrack:OnObjGridUse(szObjName, nX, nY)
  local tbObj = nil
  local szLinkInfo = nil
  if self.OBJ_ItemListIndexId[szObjName] then
    local nIndex = self.OBJ_ItemListIndexId[szObjName]
    tbObj = self.ContainerList[nIndex]:GetObj(nX, nY)
    szLinkInfo = self.ContainerList[nIndex].szLinkInfo
  end
  if not tbObj then
    return 0
  end
  local pItem = tbObj.pItem
  if not pItem then
    return 0
  end
  local tbFind = me.FindItemInBags(pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel)
  if #tbFind < 1 then
    return
  end
  if szLinkInfo then
    self:OnLinkClick(szObjName, szLinkInfo)
    tbAutoPath.tbCallBack = { self.UseItem, self, tbFind[1] }
    return
  end
  local pItem = me.GetItem(tbFind[1].nRoom, tbFind[1].nX, tbFind[1].nY)
  if pItem then
    me.UseItem(pItem)
  end
end

function uiTaskTrack:UseItem(tbItem)
  local pItem = me.GetItem(tbItem.nRoom, tbItem.nX, tbItem.nY)
  if pItem then
    me.UseItem(pItem)
  end
end

function uiTaskTrack:OnCreate()
  uiTaskTrack.ContainerList = {}
  for i, ObjName in pairs(self.OBJ_ItemListIndexName) do
    self.ContainerList[i] = tbObject:RegisterContainer(self.UIGROUP, ObjName, 1, 1, nil, "tasktrack")
    self.ContainerList[i].OnObjGridEnter = self.OnObjGridEnter
    self.ContainerList[i].OnObjGridUse = self.OnObjGridUse
  end
end

function uiTaskTrack:OnDestroy()
  for _, tbCont in pairs(self.ContainerList) do
    tbObject:UnregContainer(tbCont)
  end
end

function uiTaskTrack:Init()
  self.nCurrTaskId = -1
end

if not Task.tbTrackTaskSet then
  Task.tbTrackTaskSet = {}
end

function uiTaskTrack:OnOpen(nType)
  if not nType then
    self:Refresh()
    if UiManager:WindowVisible(Ui.UI_TASKTRACKTMP) == 1 then -- 不能同时显示两个界面 故如果活动界面已经显示的话则不显示任务界面了
      return 0
    end
  end
end

-- 从任务面板打开窗口的时候必须设置这个Id
function uiTaskTrack:SetTaskId(nTaskId)
  self.nCurrTaskId = nTaskId
end

-- 得到目前目标面板的任务Id
function uiTaskTrack:GetTaskId()
  return self.nCurrTaskId
end

function uiTaskTrack:Refresh()
  if tbTempData.bInBattle ~= 1 then
    self:RefreshTask()
  else
    self:RefreshBattle()
    Wnd_SetVisible(self.UIGROUP, self.TXX_INFOR, 0)
  end
  Tutorial:RefreshLinkClick(tbTempData.bInBattle)
end

-- 当跟踪的任务发生变化,通知这个函数,它会更新它所有跟踪的任务
function uiTaskTrack:RefreshTask()
  local tbPlayerTask = Task:GetPlayerTask(me) --获得一个玩家所有的任务
  for i = 1, 3 do
    Wnd_SetEnable(self.UIGROUP, self.OBJ_ItemListIndexName[i], 0)
    Wnd_Hide(self.UIGROUP, self.OBJ_ItemListIndexName[i])
  end
  local szMsg = ""
  local szTaskNameTu = ""
  local bAutoTutorial = 0
  local tbEveryHight = { 0 }
  for nNumberRow, nTaskIdItem in ipairs(Task.tbTrackTaskSet) do -- 遍历所跟踪的任务,然后刷新
    local szTaskMsg, szTaskNameTuTmp = self:GetTaskMsg(nTaskIdItem, tbEveryHight, nNumberRow)
    szMsg = szMsg .. szTaskMsg .. "\n"
    szTaskNameTu = szTaskNameTuTmp
    if Tutorial.tbTaskListAuto[szTaskNameTu] and bAutoTutorial == 0 and Tutorial:CanTutorialDialog(szTaskNameTu) == 1 then
      Tutorial:AutoTaskTutorial(szTaskNameTu)
      bAutoTutorial = 1
    end
  end
  TxtEx_SetText(self.UIGROUP, self.TXX_INFOR, "<a=infor>我还能做什么？<a>")
  if me.nLevel <= 60 and me.nLevel >= 25 and szMsg ~= "" then
    Wnd_SetVisible(self.UIGROUP, self.TXX_INFOR, 1)
  else
    Wnd_SetVisible(self.UIGROUP, self.TXX_INFOR, 0)
  end

  self:SetTxtMsg(szMsg, 1)
end

-------------------------------------------------
-- 功能函数
-------------------------------------------------

-- 判断一个任务是否正在被追踪
function uiTaskTrack:IsBeTracked(nTaskId)
  for _, nExistId in ipairs(Task.tbTrackTaskSet) do
    if nExistId == nTaskId then
      return 1
    end
  end
end

-- 增加一个被跟踪的任务,添加成功返回true未添加成功则返回false;
function uiTaskTrack:AddTrackedTask(nTaskId)
  for _, nTaskIdItem in ipairs(Task.tbTrackTaskSet) do
    if nTaskIdItem == nTaskId then
      return 0
    end
  end
  if #Task.tbTrackTaskSet >= self.MAX_TRACK_TASK then
    local nRemovedTaskId = Task.tbTrackTaskSet[1]
    self:RemoveTrackedTask(nRemovedTaskId)
  end
  -- 添加到任务跟踪表中
  if #Task.tbTrackTaskSet >= self.MAX_TRACK_TASK then
    return
  end
  me.SetTask(2062, #Task.tbTrackTaskSet + 1, nTaskId)

  Task.tbTrackTaskSet[#Task.tbTrackTaskSet + 1] = nTaskId
  self:ShowTempMode(0) -- 强制切换到任务模式，并刷新

  return 1
end

-- 删除一个被跟踪的任务,删除成功返回true,否则返回false
function uiTaskTrack:RemoveTrackedTask(nTaskId)
  for i = 1, self.MAX_TRACK_TASK do
    if nTaskId == me.GetTask(2062, i) then
      me.SetTask(2062, i, 0)
    end
  end
  for i = 1, #Task.tbTrackTaskSet do
    if Task.tbTrackTaskSet[i] == nTaskId then
      -- 从任务表中删除 并将后面的数据前移
      for j = i, #Task.tbTrackTaskSet - 1 do
        me.SetTask(2062, j, me.GetTask(2062, j + 1))
      end
      me.SetTask(2062, #Task.tbTrackTaskSet, 0)

      table.remove(Task.tbTrackTaskSet, i)
      self:ShowTempMode(0) -- 强制切换到任务模式，并刷新
      return 1
    end
  end
  Tutorial:RefreshLinkClick()
  return 0
end

-- 定时刷新
function uiTaskTrack:OnTimeRefresh()
  tbTimer:Register(self.REFRESHTIME, self.OnTimer, self)
end

function uiTaskTrack:OnTimer()
  if tbTempData.bInBattle ~= 1 then
    self:Refresh()
  end
  return 0
end

function uiTaskTrack:GetTaskMsg(nShowTaskId, tbEveryHight, nNumberRow)
  local szTaskNameTu = ""
  local szTaskMsg = ""
  local tbPlayerTask = Task:GetPlayerTask(me)
  if nShowTaskId > 0 and tbPlayerTask.tbTasks[nShowTaskId] then
    local tbTask = tbPlayerTask.tbTasks[nShowTaskId]
    local tbCurTags = tbTask.tbCurTags -- 子任务目标集合
    local szRefSubTaskName = tbTask.tbReferData.szName -- 子任务名
    local tbSubTaskData = tbTask.tbSubData
    local tbTagInfo = {} --这个表保存的目标是按为完成到完成排列
    if tbTask.nCurStep > 0 then
      for _, tbCurTag in ipairs(tbCurTags) do
        if tbCurTag:GetDesc() ~= "" then
          local tbPosInfo = Task:GetPosInfo(tbTask.nTaskId, szRefSubTaskName, tbTask.nCurStep)
          local szDesc = tbCurTag:GetDesc()
          if tbPosInfo and Lib:CountTB(tbPosInfo) > 0 then
            szDesc = Task:GetFinalDesc(szDesc, tbPosInfo)
          end
          if tbCurTag:IsDone() then
            table.insert(tbTagInfo, { 1, szDesc })
          else
            table.insert(tbTagInfo, 1, { 0, szDesc })
          end
        end
      end

      -- 执行到这里已获得一个任务所有的数据了.下面是显示
      local szStepDesc = "步骤："
      if tbTask.nTaskId == Merchant.TASKDATA_ID then
        szStepDesc = szStepDesc .. Merchant:GetTask(Merchant.TASK_STEP_COUNT) .. "/" .. Merchant.TASKDATA_MAXCOUNT
      else
        local szCurStep = tostring(tbTask.nCurStep)
        local szTotleStep = tostring(#tbSubTaskData.tbSteps)
        --新手任务特殊处理
        if me.nTemplateMapId ~= 2253 and tbTask.nTaskId == 528 and ((tbTask.nReferId == 745 and tbTask.nCurStep > 1) or tbTask.nReferId == 747) then
          szStepDesc = ""
        else
          szStepDesc = szStepDesc .. szCurStep .. "/" .. szTotleStep
        end
      end
      local szTotleMsg = szRefSubTaskName .. " " .. szStepDesc
      szTaskMsg = szTaskMsg .. string.format("<color=%s>%s<color>\n", self.COLOR_TASKNAME, szTotleMsg) -- 插入任务名
      szTaskNameTu = szTotleMsg
      local IsNotInMap = 1
      for _, tagInfo in ipairs(tbTagInfo) do
        --新手任务特殊处理
        if me.nTemplateMapId ~= 2253 and tbTask.nTaskId == 528 and ((tbTask.nReferId == 745 and tbTask.nCurStep > 1) or tbTask.nReferId == 747) then
          szTaskMsg = szTaskMsg .. self.szNewTaskMsg
          IsNotInMap = 0
          break
        end
        szTaskMsg = szTaskMsg .. string.format("<color=%s>%s<color>\n", (tagInfo[1] == 1 and self.COLOR_FINISHED) or self.COLOR_UNFINISHED, tagInfo[2])
      end
      --计算每个追踪任务的行数
      local nCountNumber = 1
      for s in string.gfind(szTaskMsg, "\n") do
        nCountNumber = nCountNumber + 1
      end
      table.insert(tbEveryHight, nCountNumber + tbEveryHight[#tbEveryHight])
      -- 判断是否需要道具
      local tbItemInfo = self:CheckTaskItem(nShowTaskId, tbTask.nReferId, tbTask.nCurStep)

      if tbItemInfo and #me.FindItemInBags(tbItemInfo[1], tbItemInfo[2], tbItemInfo[3], tbItemInfo[4]) >= 1 and IsNotInMap == 1 then
        local tbObj = self:CreateTempItem(tbItemInfo[1], tbItemInfo[2], tbItemInfo[3], tbItemInfo[4], tbItemInfo[5], tbItemInfo[6])
        if tbObj then
          self.ContainerList[nNumberRow]:SetObj(tbObj)
          self.ContainerList[nNumberRow].szLinkInfo = self:SubLink(tbTagInfo[1][2])
          Wnd_SetPos(self.UIGROUP, self.OBJ_ItemListIndexName[nNumberRow], 0, tbEveryHight[nNumberRow] * self.HangHeight + self.TxtInFor)
          ObjGrid_SetTransparency(self.UIGROUP, self.OBJ_ItemListIndexName[nNumberRow], "\\image\\icon\\other\\autoskill.spr", 0, 0)
          Wnd_SetEnable(self.UIGROUP, self.OBJ_ItemListIndexName[nNumberRow], 1)
          Wnd_Show(self.UIGROUP, self.OBJ_ItemListIndexName[nNumberRow])
        end
      else
        Wnd_SetEnable(self.UIGROUP, self.OBJ_ItemListIndexName[nNumberRow], 0)
        Wnd_Hide(self.UIGROUP, self.OBJ_ItemListIndexName[nNumberRow])
      end
      for i = nNumberRow + 1, 3 do
        Wnd_SetEnable(self.UIGROUP, self.OBJ_ItemListIndexName[i], 0)
        Wnd_Hide(self.UIGROUP, self.OBJ_ItemListIndexName[i])
      end
    elseif tbTask.nCurStep == -1 then
      --特殊任务处理
      local szTotleMsg = szRefSubTaskName .. " (未领奖)"
      if me.nTemplateMapId ~= 2253 and tbTask.nTaskId == 528 and tbTask.nReferId == 745 then
        szTotleMsg = szRefSubTaskName
        szTaskMsg = szTaskMsg .. string.format("<color=%s>%s<color>\n", self.COLOR_TASKNAME, szTotleMsg)
        szTaskMsg = szTaskMsg .. self.szNewTaskMsg
      else
        szTaskMsg = szTaskMsg .. string.format("<color=%s>%s<color>\n", self.COLOR_TASKNAME, szTotleMsg) -- 插入任务名
        if tbTask.tbReferData.nReplyNpcId and tbTask.tbReferData.nReplyNpcId > 0 then
          local szNpcName = KNpc.GetNameByTemplateId(tbTask.tbReferData.nReplyNpcId)
          szTaskMsg = szTaskMsg .. string.format("<color=%s>到<npcpos=%s,0,%d>处领奖<color>\n", self.COLOR_UNFINISHED, szNpcName, tbTask.tbReferData.nReplyNpcId)
        end
      end
      szTaskNameTu = szTotleMsg
    end
  end
  return szTaskMsg, szTaskNameTu
end

function uiTaskTrack:SubLink(szInfo)
  local nFirst1, _ = string.find(szInfo, "<")
  local nFirst2, _ = string.find(szInfo, ">")
  if not nFirst1 or not nFirst2 then
    return
  end
  return string.sub(szInfo, nFirst1 + 1, nFirst2 - 1)
end

-- 战场即时消息相关 --

function uiTaskTrack:RefreshBattle()
  local szMsg = ""
  local tbInfo = {}
  local nShowTime = 0
  if tbTempData.tbTimerFrame then
    for i in pairs(tbTempData.tbTimerFrame) do
      if tbTempData.tbTimerFrame[i] < 3600 * Env.GAME_FPS then
        tbInfo[i] = Lib:FrameTimeDesc(tbTempData.tbTimerFrame[i])
      else
        local nHour = tbTempData.tbTimerFrame[i] / (3600 * Env.GAME_FPS)
        local nMini = (tbTempData.tbTimerFrame[i] % (3600 * Env.GAME_FPS)) / (60 * Env.GAME_FPS)
        tbInfo[i] = string.format("%s小时%s分", math.floor(nHour), math.floor(nMini))
      end
      nShowTime = 1
    end
    if 1 == nShowTime then
      szMsg = szMsg .. string.format(self.szBattleTimerFmt, unpack(tbInfo)) .. "\n"
    end
  end
  tbTempData.szBattleTimeMsg = szMsg
  szMsg = szMsg .. tbTempData.szBattleMsg -- 常规即时消息
  local nType, szMsgBattle = self:GetAllTaskMsg(szMsg)
  self:SetTxtMsg(szMsgBattle, nType)
end

function uiTaskTrack:GetAllTaskMsg(szMsg)
  local nType = 2
  local nSaftCount = 1
  local tbEveryHight = { 0 }
  repeat
    local nTaskIdA, nTaskIdB = string.find(szMsg, "<taskid=%d+>")
    if nTaskIdA and nTaskIdA > 0 then
      local szTaskFlag = string.sub(szMsg, nTaskIdA, nTaskIdB)
      local nFlagA, nFlagB = string.find(szTaskFlag, "%d+")
      local nShowTaskId = tonumber(string.sub(szTaskFlag, nFlagA, nFlagB)) or 0
      local szTaskMsg = self:GetTaskMsg(nShowTaskId, tbEveryHight, nSaftCount)
      szMsg = string.sub(szMsg, 1, nTaskIdA - 1) .. szTaskMsg .. string.sub(szMsg, nTaskIdB + 1, -1)
      nType = 1
    end
    nSaftCount = nSaftCount + 1
  until not nTaskIdA or nTaskIdA < 0 or nSaftCount > 10
  szMsg = szMsg .. "\n"
  return nType, szMsg
end

-- 切换是否要按照战场模式显示
function uiTaskTrack:OnSwitchInBattle()
  local bInBattle = tbTempData.bInBattle
  tbTempData.bInBattle = 1 - bInBattle -- （0变1，1变0）
  self:Refresh()
  tbTempData.nBattleTempTimer = nil
  return 0 -- 关闭Timer
end

-- 改变是否在战场的状态，可以设定等待时间（秒）
function uiTaskTrack:ChangeInBattle(bInBattle, nWaitFrame)
  if tbTempData.bInBattle == bInBattle then -- 当前显示状态一致，不需要等待
    nWaitFrame = nil
  elseif not nWaitFrame or nWaitFrame <= 0 then -- 没有需求等待，直接设定
    tbTempData.bInBattle = bInBattle
    nWaitFrame = nil
    self:Refresh()
  elseif tbTempData.nBattleTempTimer then -- 当前是临时改变状态，等待自然恢复
    return
  end

  -- 关闭旧计时器
  if tbTempData.nBattleTempTimer then
    tbTimer:Close(tbTempData.nBattleTempTimer)
    tbTempData.nBattleTempTimer = nil
  end

  -- 开新计时器
  if nWaitFrame then
    tbTempData.nBattleTempTimer = tbTimer:Register(nWaitFrame, self.OnSwitchInBattle, self)
  end
end

-- 临时切换到某状态，并刷新
function uiTaskTrack:ShowTempMode(bInBattle)
  -- 关闭旧计时器，恢复临时状态
  if tbTempData.nBattleTempTimer then
    tbTempData.bInBattle = 1 - tbTempData.bInBattle -- （0变1，1变0）
    tbTimer:Close(tbTempData.nBattleTempTimer)
    tbTempData.nBattleTempTimer = nil
  end

  if tbTempData.bInBattle ~= bInBattle then -- 显示状态要临时改变
    tbTempData.bInBattle = bInBattle
    tbTempData.nBattleTempTimer = tbTimer:Register(self.TIME_TEMPCHANGE, self.OnSwitchInBattle, self)
  end

  -- 无论是否真的改变了状态，都刷新一下
  self:Refresh()
end

-- 收到战场即时消息
function uiTaskTrack:OnReceiveBattleMsg(szMsg, nRefreshMsgOnly)
  tbTempData.szBattleMsg = szMsg
  if not nRefreshMsgOnly or nRefreshMsgOnly == 0 then
    self:Refresh()
  else
    szMsg = tbTempData.szBattleTimeMsg .. szMsg -- 常规即时消息
    local nType, szMsgBattle = self:GetAllTaskMsg(szMsg)
    self:SetTxtMsg(szMsgBattle, nType)
  end
end

-- 设定战场计时器
function uiTaskTrack:OnReceiveBattleTimer(szTimerFmt, tbTimerFrame)
  if tbTempData.nBattleRefreshTimer and tbTempData.nBattleRefreshTimer > 0 then -- 注销原有刷新Timer
    tbTimer:Close(tbTempData.nBattleRefreshTimer)
    tbTempData.nBattleRefreshTimer = 0
  end

  if not tbTimerFrame then -- 只是需要关闭，并没有要打开新的计时器
    tbTempData.tbTimerFrame = {}
    if tbTempData.bInBattle == 1 then
      self:Refresh()
    end
    return
  end

  -- 设定新的计时器
  tbTempData.tbTimerFrame = tbTimerFrame or {}
  self.szBattleTimerFmt = szTimerFmt

  -- 寻找最大时间作为定时器
  tbTempData.nBattleTimerFrame = 0
  tbTempData.nBattleTimerFrameReFresh = 0 --最小时间做为刷新时间

  for i in pairs(tbTimerFrame) do
    if tbTimerFrame[i] > tbTempData.nBattleTimerFrame then
      tbTempData.nBattleTimerFrame = tbTimerFrame[i]
    end
    if tbTimerFrame[i] < tbTempData.nBattleTimerFrameReFresh or tbTempData.nBattleTimerFrameReFresh == 0 then
      tbTempData.nBattleTimerFrameReFresh = tbTimerFrame[i]
    end
  end

  -- 刷新一次，并得到下次触发的时间
  local nRefreshFrame = self:OnBattleTimerRefresh()

  -- 注册新的刷新Timer
  tbTempData.nBattleRefreshTimer = tbTimer:Register(nRefreshFrame, self.OnBattleTimerRefresh, self)
end

function uiTaskTrack:OnButtonClick(szWnd)
  if self.OBJ_ItemListIndexId[szWnd] then
    self:OnObjGridUse(szWnd, 0, 0)
  end
end

-- 战场计时器刷新，返回下次刷新需要的时间
function uiTaskTrack:OnBattleTimerRefresh()
  if tbTempData.bInBattle == 1 then
    self:Refresh()
  end

  if (not tbTempData.nBattleTimerFrame) or (tbTempData.nBattleTimerFrame <= 0) then -- 计时结束，关闭刷新Timer
    tbTempData.nBattleRefreshTimer = 0
    return 0
  end

  -- 计算当前刷新的间隔时间最大值
  local nRefreshMax = 0
  if tbTempData.nBattleTimerFrameReFresh / Env.GAME_FPS <= 3600 then
    nRefreshMax = Env.GAME_FPS -- 不超过1小时，每秒刷新
  else
    nRefreshMax = Env.GAME_FPS * 60 * 1 -- 否则，每1分钟刷新
  end

  -- 计算本次刷新应该等多久
  local nRefreshFrame = math.mod(tbTempData.nBattleTimerFrame, nRefreshMax)
  if nRefreshFrame <= 0 then -- 整除了，按照最大等待时间
    nRefreshFrame = nRefreshMax
  end

  -- 扣除剩余时间
  tbTempData.nBattleTimerFrame = tbTempData.nBattleTimerFrame - nRefreshFrame
  -- 扣除倒计时间列表的时间
  if tbTempData.tbTimerFrame then
    for i in pairs(tbTempData.tbTimerFrame) do
      tbTempData.tbTimerFrame[i] = tbTempData.tbTimerFrame[i] - nRefreshFrame
      if tbTempData.tbTimerFrame[i] < 0 then
        tbTempData.tbTimerFrame[i] = 0
      end
    end
  end
  return nRefreshFrame
end

function uiTaskTrack:OnRefreshTask(nTaskId, nReferId, nParam)
  if self.ISTRACK then
    if self:IsBeTracked(nTaskId) then
      if nParam == 0 then
        self:RemoveTrackedTask(nTaskId)
      else
        self:OnTimeRefresh()
      end
    end
  end
end

function uiTaskTrack:OnTaskTrack(nTaskId)
  if self.ISTRACK then
    if not self:IsBeTracked(nTaskId) then
      self:AddTrackedTask(nTaskId)
    end
    if #Task.tbTrackTaskSet > 0 then
      Task.tbTrackTaskSet = Task.tbTrackTaskSet
      UiManager:OpenWindow(self.UIGROUP)
    end
  end
end

function uiTaskTrack:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_TASK_REFRESH, self.OnRefreshTask },
    { UiNotify.emCOREEVENT_TASK_TRACK, self.OnTaskTrack },
  }
  return tbRegEvent
end

function uiTaskTrack:SetTrack(bTrack)
  self.ISTRACK = bTrack

  -- 从保存的任务跟踪表中读取
  if bTrack then
    Task.tbTrackTaskSet = {}
    for i = 1, self.MAX_TRACK_TASK do
      if me.GetTask(2062, i) ~= 0 then
        Task.tbTrackTaskSet[#Task.tbTrackTaskSet + 1] = me.GetTask(2062, i)
      end
    end
    self:Refresh()
  end
end

function uiTaskTrack:OnLinkClick(szWnd, szLinkInfo)
  local tbLinkClass, szLink = self:ParseLink(szLinkInfo)
  tbLinkClass:OnClick(szLink)
  Tutorial:TaskLinkClick(szLink)
end

function uiTaskTrack:OnLinkRClick(szWnd, szLinkInfo)
  local tbLinkClass, szLink = self:ParseLink(szLinkInfo)
  if tbLinkClass.OnRClick then
    tbLinkClass:OnRClick(szLink)
  end
end

-- 超链接Tip
function uiTaskTrack:OnLinkHover(szWnd, szLinkInfo)
  local tbLinkClass, szLink = self:ParseLink(szLinkInfo)
  local szTip = tbLinkClass:GetTip(szLink)
  Wnd_ShowMouseHoverInfo(self.UIGROUP, self.WND_TASK_INFO or "Main", "", szTip or "")
end

-- 解析超链接
function uiTaskTrack:ParseLink(szLinkInfo)
  local tbSplit = Lib:SplitStr(szLinkInfo, "=")

  local tbLinkClass = UiManager.tbLinkClass[tbSplit[1]]
  local szLink = tbSplit[2]
  return tbLinkClass, szLink
end

function uiTaskTrack:SetTxtMsg(szMsg, nType)
  if nType == 1 then
    UiManager:CloseWindow(Ui.UI_TASKTRACKTMP)
    if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
      UiManager:OpenWindow(self.UIGROUP, nType)
    end
    LinkPanelSetText(self.UIGROUP, self.TEXTE_MSG, szMsg)
  else
    UiManager:CloseWindow(self.UIGROUP)
    if UiManager:WindowVisible(Ui.UI_TASKTRACKTMP) ~= 1 then
      UiManager:OpenWindow(Ui.UI_TASKTRACKTMP)
    end
    Txt_SetTxt(Ui.UI_TASKTRACKTMP, self.TEXTE_MSG, szMsg)
  end
end

function uiTaskTrack:Link_infor_OnClick(szWnd, szLinkData)
  UiManager:OpenWindow(Ui.UI_NEWCALENDARVIEW)
end

function uiTaskTrack:CreateTempItem(nGenre, nDetail, nParticular, nLevel, nBind, nCount)
  local pItem = tbTempItem:Create(nGenre, nDetail, nParticular, nLevel, -1)
  if not pItem then
    return
  end

  local tbObj = {}
  tbObj.nType = Ui.OBJ_TEMPITEM
  tbObj.pItem = pItem
  tbObj.nCount = nCount or 1

  if nBind == 1 then
    tbObj.szBindType = "获取绑定"
  end
  return tbObj
end
