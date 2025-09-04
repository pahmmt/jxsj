-- ====================== 文件信息 ======================

-- 任务记录面板
-- Edited by peres
-- 2007/10/21 PM 09:33

-- 在人群里，一对对年轻的情侣，彼此紧紧地纠缠在一起，旁若无人地接吻。
-- 爱情如此美丽，似乎可以拥抱取暖到天明。
-- 我们原可以就这样过下去，闭起眼睛，抱住对方，不松手亦不需要分辨。
-- 因为一旦睁开眼睛，看到的只是彼岸升起的一朵烟花。
-- 无法触摸，亦不可永恒……

-- ======================================================
local uiTaskPanel = Ui:GetClass("taskpanel")
local tbObject = Ui.tbLogic.tbObject
local tbTempData = Ui.tbLogic.tbTempData
local tbAwardInfo = Ui.tbLogic.tbAwardInfo

uiTaskPanel.WND_TASK_INFO = "ScrollTaskInfo"
uiTaskPanel.WND_TASK_DESC = "ScrollTaskDesc"
uiTaskPanel.TXT_TASK_NUM = "TxtTaskNum" -- 任务的总数量
uiTaskPanel.OUTLOOK_TASK_LIST = "OutLookTask" -- OUTLOOK 控件的 TaskList
uiTaskPanel.OUTLOOK_TASK_SCROLL = "TaskList"
uiTaskPanel.TXT_TASK_TEXT = "TaskText" -- 任务的文字描述
uiTaskPanel.TXT_TASK_DESC = "TaskDesc" -- 任务的详细步骤描述
uiTaskPanel.BTN_TASK_INFO = "BtnTaskInfo"
uiTaskPanel.BTN_TASK_DESC = "BtnTaskDesc"
uiTaskPanel.BTN_SHARE_TASK = "BtnShareTask"
uiTaskPanel.BTN_GIVEUP_TASK = "BtnGiveupTask"
uiTaskPanel.BTN_TRACK_TASK = "BtnTrackTask"
uiTaskPanel.BTN_CLOSE = "BtnClose"
uiTaskPanel.BTN_MY_ATASK = "BtnMyATask" --已接任务
uiTaskPanel.BTN_CAN_ATASK = "BtnCanATask" --可接任务
uiTaskPanel.BTN_SKIP_TASK = "BtnSkipTask" --跳过任务按钮

uiTaskPanel.WND_FIX_AWARD = {
  "WndFixAward",
  { "ObjFix1", "ObjFix2", "ObjFix3", "ObjFix4", "ObjFix5" },
  { "ImgFix1Bg", "ImgFix2Bg", "ImgFix3Bg", "ImgFix4Bg", "ImgFix5Bg" },
}

uiTaskPanel.WND_OPTIONAL_AWARD = {
  "WndOptionalAward",
  { "ObjOptional1", "ObjOptional2", "ObjOptional3", "ObjOptional4", "ObjOptional5" },
  { "ImgOptional1Bg", "ImgOptional2Bg", "ImgOptional3Bg", "ImgOptional4Bg", "ImgOptional5Bg" },
}

uiTaskPanel.MAP_INFO_NEW = -1 -- 表示地图需要自行回到新手村才开始寻
uiTaskPanel.MAP_INFO_CITY = -2 -- 表示地图需要自行回到城市才开始寻
uiTaskPanel.MAP_INFO_FACTION = -3 -- 表示地图需要自行回到门派才开始寻
function uiTaskPanel:OnCreate()
  self.tbFixCont = {}
  self.tbOptionalCont = {}
  for i, tbAward in ipairs(self.WND_FIX_AWARD[2]) do
    self.tbFixCont[i] = tbObject:RegisterContainer(self.UIGROUP, tbAward, 4, 2, nil, "award")
  end
  for i, tbAward in ipairs(self.WND_OPTIONAL_AWARD[2]) do
    self.tbOptionalCont[i] = tbObject:RegisterContainer(self.UIGROUP, tbAward, 4, 2, nil, "award")
  end
end

function uiTaskPanel:OnDestroy()
  for _, tbCont in ipairs(self.tbFixCont) do
    tbObject:UnregContainer(tbCont)
  end
  for _, tbCont in ipairs(self.tbOptionalCont) do
    tbObject:UnregContainer(tbCont)
  end
end

function uiTaskPanel:Init()
  self.m_tbTaskIdMap = { [1] = {}, [2] = {}, [3] = {}, [4] = {}, [5] = {} }
  self.tbAwardInfo = {} -- 显示物品 Tips 所专用的 table
  self.nInitDone = 0 -- 判断界面是否已经初始化完毕，包括控件，如果 OUTLOOK 控件没有初始化，则不能做任何东西
end

function uiTaskPanel:WriteStatLog()
  Log:Ui_SendLog("F4任务界面", 1)
end

function uiTaskPanel:OnOpen()
  self.nTaskPanelType = 0 --0，已接任务，1，可接任务
  self:WriteStatLog()
  Ui(Ui.UI_SIDEBAR):WndOpenCloseCallback(self.UIGROUP, 1)
  --self.nTaskPanelType = 0;
  self:EmptyTaskInfo()
  self:InitData()
  self:ShowTotalTaskNum()

  -- 先把详细步骤隐藏掉
  Wnd_Show(self.UIGROUP, self.WND_TASK_INFO)
  Wnd_Hide(self.UIGROUP, self.WND_TASK_DESC)

  Wnd_Hide(self.UIGROUP, self.BTN_SKIP_TASK)
  -- 记录上一次的选择任务，如果还存在，则在界面任务列表里选中它
  if self:HaveThisTask(tbTempData.nSelectTaskId) and (tbTempData.nSelectTaskId > 0) then
    local nGroupIdx, nItemIdx = self:GetItemLocalByTask(tbTempData.nSelectTaskId)
    if nGroupIdx >= 0 and nGroupIdx <= 5 and nItemIdx >= 0 then
      OutLookPanelSelItem(self.UIGROUP, self.OUTLOOK_TASK_LIST, nGroupIdx, nItemIdx)
      self:SelectTask(tbTempData.nSelectTaskId)
    end
    return
  end

  -- 如果没有记录任何上次选择的 ID，则直接找第一个任务进行选择
  local nSelIdx = 0
  for i = 0, 4 do
    if GetOutLookGroupItemCount(self.UIGROUP, self.OUTLOOK_TASK_LIST, i) ~= 0 then
      nSelIdx = i
      break
    end
  end
  OutLookPanelSelItem(self.UIGROUP, self.OUTLOOK_TASK_LIST, nSelIdx, 0)
end

function uiTaskPanel:OnClose()
  Ui(Ui.UI_SIDEBAR):WndOpenCloseCallback(self.UIGROUP, 0)
end

-- 初始化左边的任务列表 OUTLOOK 控件
function uiTaskPanel:UpdateTaskList()
  OutLookPanelClearAll(self.UIGROUP, self.OUTLOOK_TASK_LIST)
  AddOutLookPanelColumnHeader(self.UIGROUP, self.OUTLOOK_TASK_LIST, "")
  SetOutLookHeaderWidth(self.UIGROUP, self.OUTLOOK_TASK_LIST, 0, 20)
  --AddOutLookGroup(self.UIGROUP, self.OUTLOOK_TASK_LIST, "任务指引");
  AddOutLookGroup(self.UIGROUP, self.OUTLOOK_TASK_LIST, "军营任务")
  AddOutLookGroup(self.UIGROUP, self.OUTLOOK_TASK_LIST, "主线剧情")
  AddOutLookGroup(self.UIGROUP, self.OUTLOOK_TASK_LIST, "世界任务")
  AddOutLookGroup(self.UIGROUP, self.OUTLOOK_TASK_LIST, "江湖任务")
  AddOutLookGroup(self.UIGROUP, self.OUTLOOK_TASK_LIST, "随机事件")
  AddOutLookGroup(self.UIGROUP, self.OUTLOOK_TASK_LIST, "传说流言")
end

-- 当选择了列表中的一个任务时
function uiTaskPanel:OnOutLookItemSelected(szWndName, nGroupIndex, nItemIndex)
  local nTaskId = self.m_tbTaskIdMap[nGroupIndex + 1][nItemIndex + 1]
  if nTaskId then
    tbTempData.nSelectTaskId = nTaskId
    tbTempData.nSelGroupIdx = nil
    tbTempData.nSelItemIdx = nil
    local nGroupIdx, nItemIdx = self:GetItemLocalByTask(tbTempData.nSelectTaskId)
    if nGroupIdx >= 0 and nGroupIdx <= 5 and nItemIdx >= 0 then
      tbTempData.nSelGroupIdx = nGroupIdx
      tbTempData.nSelItemIdx = nItemIdx
    end
    self:LayoutTaskInfo(nTaskId)
  end
  if self.nTaskPanelType == 0 then
    local tbPlayerTask = Task:GetPlayerTask(me)
    local tbTask = tbPlayerTask.tbTasks[nTaskId]
    if not tbTask.tbReferData.bCanGiveUp then
      Wnd_SetEnable(self.UIGROUP, self.BTN_GIVEUP_TASK, 0)
    else
      Wnd_SetEnable(self.UIGROUP, self.BTN_GIVEUP_TASK, 1)
    end

    local tbTaskData = Task.tbTaskDatas[nTaskId]
    if tbTaskData and tbTaskData.tbAttribute then
      if tbTaskData.tbAttribute.Share and tbTaskData.tbAttribute.Share == true then
        Wnd_SetEnable(self.UIGROUP, self.BTN_SHARE_TASK, 1)
      else
        Wnd_SetEnable(self.UIGROUP, self.BTN_SHARE_TASK, 0)
      end
    end
    Wnd_Hide(self.UIGROUP, self.BTN_SKIP_TASK)
  elseif self.nTaskPanelType == 1 then
    tbTempData.nScrollHeight = ScrPanel_GetDocumentTopLen(self.UIGROUP, self.OUTLOOK_TASK_SCROLL) --记录可接任务面板滚动条位置
    local nReferId = Task:GetReferID(nTaskId, Task:GetFinishedIdx(nTaskId) + 1)
    if not nReferId then
      return
    end
    if Task:IsTaskCanSkip(nTaskId, nReferId) ~= 1 then
      Wnd_Show(self.UIGROUP, self.BTN_SKIP_TASK)
      Wnd_SetEnable(self.UIGROUP, self.BTN_SKIP_TASK, 0)
    else
      Wnd_Show(self.UIGROUP, self.BTN_SKIP_TASK)
      Wnd_SetEnable(self.UIGROUP, self.BTN_SKIP_TASK, 1)
    end
  end
end

-- 获取当前玩家所接的所有任务数量
function uiTaskPanel:ShowTotalTaskNum()
  Txt_SetTxt(self.UIGROUP, self.TXT_TASK_NUM, "任务数量：" .. Task:GetPlayerTask(me).nCount .. " / " .. 20)
end

-- 布局一个任务的内容
function uiTaskPanel:LayoutTaskInfo(nTaskId)
  local szGoalWndName = self.TXT_TASK_TEXT
  local szDescWndName = ""
  local bFix, bChoice
  self:EmptyTaskInfo()
  if Task:GetTaskType(nTaskId) == "Task" then
    self:FormatGoal(nTaskId)
    bFix, bChoice = self:FillAwardGroup(nTaskId)
    self:FormatDesc(nTaskId)
  elseif Task:GetTaskType(nTaskId) == "LinkTask" then
    -- 针对任务链的特殊处理
    local szLinkTask = self:LinkTaskTextOut()
    szLinkTask = szLinkTask .. Lib:StrTrim(self:GetCurTargetDesc(nTaskId), "\n")
    LinkPanelSetText(self.UIGROUP, szGoalWndName, szLinkTask)
  elseif Task:GetTaskType(nTaskId) == "WantedTask" then
    local szText = "任务名称：" .. self:GetCurRefName(nTaskId) .. "\n\n"
    szText = szText .. "任务描述：\n    " .. self:GetSubDesc(nTaskId) .. "\n\n"
    szText = szText .. "任务目标：\n" .. Lib:StrTrim(self:GetCurTargetDesc(nTaskId), "\n") .. "\n\n" --目标
    LinkPanelSetText(self.UIGROUP, szGoalWndName, szText)
  end

  -- 描述框
  local nMainDescLeft, nMainDescTop = Wnd_GetPos(self.UIGROUP, szGoalWndName)
  local _, nMainDescHeight = Wnd_GetSize(self.UIGROUP, szGoalWndName) -- 获得任务描述
  local nCurrTop = nMainDescTop + nMainDescHeight + 10

  -- 奖励
  local nGroupLeft, nGroupTop = Wnd_GetPos(self.UIGROUP, self.WND_FIX_AWARD[1])
  if bFix == 1 then
    Wnd_SetPos(self.UIGROUP, self.WND_FIX_AWARD[1], nGroupLeft, nCurrTop)
    local nGroupWidth, nGroupHeight = Wnd_GetSize(self.UIGROUP, self.WND_FIX_AWARD[1])
    nCurrTop = nCurrTop + nGroupHeight + 10
  else
    Wnd_SetPos(self.UIGROUP, self.WND_FIX_AWARD[1], nGroupLeft, 0)
  end
  if bChoice == 1 then
    Wnd_SetPos(self.UIGROUP, self.WND_OPTIONAL_AWARD[1], nGroupLeft, nCurrTop)
  else
    Wnd_SetPos(self.UIGROUP, self.WND_OPTIONAL_AWARD[1], nGroupLeft, 0)
  end
  ScrPnl_Update(self.UIGROUP, self.WND_TASK_INFO)
end

function uiTaskPanel:CheckFinishTask(nTaskId)
  local tbPlayerTask = Task:GetPlayerTask(me) --获得一个玩家所有的任务

  if not tbPlayerTask then
    return 0
  end

  local tbTask = tbPlayerTask.tbTasks[nTaskId]

  if not tbTask then
    return 0
  end

  local tbSubTaskData = tbTask.tbSubData

  if not tbSubTaskData then
    return 0
  end

  if tbTask.nCurStep > 0 then
    if nTaskId == Merchant.TASKDATA_ID then
      if Merchant:GetTask(Merchant.TASK_STEP_COUNT) == Merchant.TASKDATA_MAXCOUNT then
        return 1
      end
    else
      if tbTask.nCurStep == #tbSubTaskData.tbSteps then
        return 1
      end
    end
  else
    return 1
  end
  return 0
end

-- 格式引用子任务名，当前步骤目标，当前步骤描述，
function uiTaskPanel:FormatGoal(nTaskId)
  local szGoalWndName = self.TXT_TASK_TEXT
  if self.nTaskPanelType == 1 then
    local tbInfo = self.tbTaskCanAppectList[nTaskId]
    if tbInfo then
      local strDesc = "<color=yellow>" .. tbInfo[2] .. "<color=White>\n\n" .. tbInfo[3] .. "\n\n\n\n"
      local nReferId = Task:GetReferID(nTaskId, Task:GetFinishedIdx(nTaskId) + 1)
      if Task:IsTaskCanSkip(nTaskId, nReferId) then
        local strTmp = Task:GetSkipDesc(nTaskId, nReferId)
        strDesc = strDesc .. "<color=Gold>此任务支持直接完成\n<color>" .. strTmp .. "\n"
      else
        strDesc = strDesc .. "\n"
      end
      LinkPanelSetText(self.UIGROUP, szGoalWndName, strDesc)
    end
    return 0
  end

  local szTotleDesc = ""
  local szStepState = ""
  local tbPlayerTask = Task:GetPlayerTask(me) --获得一个玩家所有的任务
  local tbTask = tbPlayerTask.tbTasks[nTaskId]
  local tbSubTaskData = tbTask.tbSubData

  if tbTask.nCurStep > 0 then
    if nTaskId == Merchant.TASKDATA_ID then
      szStepState = Merchant:GetTask(Merchant.TASK_STEP_COUNT) .. " / " .. Merchant.TASKDATA_MAXCOUNT
    else
      local szCurStep = tostring(tbTask.nCurStep)
      local szTotleStep = tostring(#tbSubTaskData.tbSteps)
      szStepState = szCurStep .. " / " .. szTotleStep
    end
  else
    szStepState = "(未领奖)"
  end

  local szDegree = self:GetCurRefDegree(nTaskId)
  if szDegree ~= "" then
    szDegree = " 【" .. szDegree .. "】"
  end

  szTotleDesc = szTotleDesc .. self:GetTaskName(nTaskId) .. "\n"
  szTotleDesc = szTotleDesc .. "子任务名称：" .. self:GetCurRefName(nTaskId) .. szDegree .. "\n\n"
  szTotleDesc = szTotleDesc .. "当前步骤（" .. szStepState .. "）：" .. Lib:StrTrim(self:GetCurStepDesc(nTaskId), "\n") .. "\n\n" --步骤描述
  szTotleDesc = szTotleDesc .. "任务目标：\n" .. Lib:StrTrim(self:GetCurTargetDesc(nTaskId), "\n") .. "\n\n" --目标
  szTotleDesc = szTotleDesc .. self:GetStepAwardDesc(nTaskId)
  LinkPanelSetText(self.UIGROUP, szGoalWndName, szTotleDesc)
end

-- 任务描述，子任务描述，到目前为止所有步骤描述
function uiTaskPanel:FormatDesc(nTaskId)
  if self.nTaskPanelType == 1 then
    return 0
  end
  local szDescWndName = self.TXT_TASK_DESC
  local szTotleDesc = ""

  -- 任务名,任务描述
  --szTotleDesc = szTotleDesc..self:GetTaskName(nTaskId).."\n";
  --szTotleDesc = szTotleDesc..self:GetTaskDesc(nTaskId).."\n";

  -- 为了调试方便，加入任务Id,引用子任务Id,子任务Id
  -- 子任务名，子任务描述
  szTotleDesc = szTotleDesc .. self:GetCurRefName(nTaskId) .. "\n"
  szTotleDesc = szTotleDesc .. self:GetCurRefDesc(nTaskId) .. "\n"
  szTotleDesc = szTotleDesc .. self:GetCurTotleStepDesc(nTaskId) .. "\n" -- 步骤描述
  LinkPanelSetText(self.UIGROUP, szDescWndName, szTotleDesc)
end

-- 布局任务奖励
function uiTaskPanel:FillAwardGroup(nTaskId)
  local tbAwards
  if self.nTaskPanelType == 1 then
    -- 获取可接任务的第一个可接子任务的ID
    local referId = Task:GetReferID(nTaskId, Task:GetFinishedIdx(nTaskId) + 1)
    if not referId then
      return 0
    end
    tbAwards = Task:GetAwards(referId)
  elseif self.nTaskPanelType == 0 then
    -- 已接任务（维持原版行为）
    tbAwards = Task:GetAwardsForMe(nTaskId)
  end

  if tbAwards == nil then
    return 0
  end

  local bFix = 0
  local bChoice = 0
  -- 固定奖励
  for i = 1, #self.WND_FIX_AWARD[2] do
    if tbAwards.tbFix and tbAwards.tbFix[i] then
      local tbAward = tbAwards.tbFix[i]
      self:AddAwardObj(self.tbFixCont[i], tbAward)
      Wnd_Show(self.UIGROUP, self.WND_FIX_AWARD[3][i])
    else
      Wnd_Hide(self.UIGROUP, self.WND_FIX_AWARD[3][i])
    end
  end
  if tbAwards.tbFix and #tbAwards.tbFix > 0 then
    Wnd_Show(self.UIGROUP, self.WND_FIX_AWARD[1])
    bFix = 1
  else
    Wnd_Hide(self.UIGROUP, self.WND_FIX_AWARD[1])
  end

  -- 可选奖励
  for i = 1, #self.WND_OPTIONAL_AWARD[2] do
    if tbAwards.tbOpt and tbAwards.tbOpt[i] then
      local tbAward = tbAwards.tbOpt[i]
      self:AddAwardObj(self.tbOptionalCont[i], tbAward)
      Wnd_Show(self.UIGROUP, self.WND_OPTIONAL_AWARD[3][i])
    else
      Wnd_Hide(self.UIGROUP, self.WND_OPTIONAL_AWARD[3][i])
    end
  end
  if tbAwards.tbOpt and #tbAwards.tbOpt > 0 then
    Wnd_Show(self.UIGROUP, self.WND_OPTIONAL_AWARD[1])
    bChoice = 1
  else
    Wnd_Hide(self.UIGROUP, self.WND_OPTIONAL_AWARD[1])
  end
  return bFix, bChoice
end

function uiTaskPanel:AddAwardObj(tbCont, tbAward)
  self:RemoveTempItem(tbCont) -- 容器里原来有东西则回收
  if not tbAward then
    return
  end
  local nTaskId = self:GetCurrTaskId()
  if not nTaskId or nTaskId <= 0 then
    return
  end

  local nReferId
  if self.nTaskPanelType == 0 then
    local tbPlayerTask = Task:GetPlayerTask(me)
    local tbTask = tbPlayerTask.tbTasks[nTaskId]
    if not tbTask then
      return
    end
    nReferId = tbTask.nReferId
  elseif self.nTaskPanelType == 1 then
    nReferId = Task:GetReferID(nTaskId, Task:GetFinishedIdx(nTaskId) + 1)
    if not nReferId then
      return
    end
  end
  local tbObj = tbAwardInfo:GetAwardInfoObj(tbAward, nTaskId, nReferId)
  if not tbObj then
    return
  end
  tbCont:SetObj(tbObj)
end

function uiTaskPanel:RemoveTempItem(tbCont)
  local tbObj = tbCont:GetObj()
  tbAwardInfo:DelAwardInfoObj(tbObj)
  tbCont:SetObj(nil)
end

function uiTaskPanel:EmptyTaskInfo()
  for i in ipairs(self.WND_FIX_AWARD[2]) do
    self:RemoveTempItem(self.tbFixCont[i])
    Wnd_Hide(self.UIGROUP, self.WND_FIX_AWARD[3][i])
  end
  Wnd_Hide(self.UIGROUP, self.WND_FIX_AWARD[1])
  for i in ipairs(self.WND_OPTIONAL_AWARD[2]) do
    self:RemoveTempItem(self.tbOptionalCont[i])
    Wnd_Hide(self.UIGROUP, self.WND_OPTIONAL_AWARD[3][i])
  end
  Wnd_Hide(self.UIGROUP, self.WND_OPTIONAL_AWARD[1])
  LinkPanelSetText(self.UIGROUP, self.TXT_TASK_TEXT, "")
end

-- 按钮按下触发事件
function uiTaskPanel:OnButtonClick(szWndName, nParam)
  if szWndName == self.BTN_TASK_INFO then
    Wnd_Hide(self.UIGROUP, self.WND_TASK_DESC)
    Wnd_Show(self.UIGROUP, self.WND_TASK_INFO)
  elseif szWndName == self.BTN_TASK_DESC then
    Wnd_Hide(self.UIGROUP, self.WND_TASK_INFO)
    Wnd_Show(self.UIGROUP, self.WND_TASK_DESC)
  elseif szWndName == self.BTN_SHARE_TASK then --共享, 按钮为添加一任务
    local nTaskId = self:GetCurrTaskId()
    if nTaskId == nil or nTaskId <= 0 then
      return
    end
    self:OnShareTask(nTaskId)
  elseif szWndName == self.BTN_GIVEUP_TASK then -- 放弃一个任务
    local nTaskId = self:GetCurrTaskId()
    if nTaskId == nil or nTaskId <= 0 then
      return
    end
    local tbPlayerTask = Task:GetPlayerTask(me)
    local tbTask = tbPlayerTask.tbTasks[nTaskId]
    if not tbTask.tbReferData.bCanGiveUp then
      me.Msg("放弃失败：本任务不可放弃")
      return
    end
    local tbMsg = {}
    tbMsg.szMsg = "确定放弃此任务吗？"
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex, nTaskId)
      if (nOptIndex == 2) and nTaskId and (nTaskId > 0) then
        local tbPlayerTask = Task:GetPlayerTask(me)
        local nReferId = tbPlayerTask.tbTasks[nTaskId].nReferId
        KTask.SendGiveUp(me, nTaskId, nReferId, 1)
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nTaskId)
  elseif szWndName == self.BTN_TRACK_TASK then -- 追踪，
    self:OnTrackTask()
  elseif szWndName == self.BTN_CLOSE then -- 关闭按钮
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWndName == self.BTN_MY_ATASK then
    self.nTaskPanelType = 0
    self:EmptyTaskInfo()
    self:InitData()
    Wnd_SetEnable(self.UIGROUP, self.BTN_CAN_ATASK, 1)
    Wnd_SetEnable(self.UIGROUP, self.BTN_MY_ATASK, 0)
    Btn_Check(self.UIGROUP, self.BTN_MY_ATASK, 1)
    Btn_Check(self.UIGROUP, self.BTN_CAN_ATASK, 0)
    Wnd_Show(self.UIGROUP, self.BTN_TASK_DESC)
    Wnd_Show(self.UIGROUP, self.BTN_SHARE_TASK)
    Wnd_Show(self.UIGROUP, self.BTN_GIVEUP_TASK)
    Wnd_Show(self.UIGROUP, self.BTN_TRACK_TASK)
    Wnd_Show(self.UIGROUP, self.BTN_TASK_INFO)
    Wnd_Show(self.UIGROUP, self.TXT_TASK_NUM)
    Wnd_Show(self.UIGROUP, self.WND_TASK_INFO)
    Wnd_Hide(self.UIGROUP, self.WND_TASK_DESC)
    Wnd_Hide(self.UIGROUP, self.BTN_SKIP_TASK)
  elseif szWndName == self.BTN_CAN_ATASK then
    self.nTaskPanelType = 1
    self:EmptyTaskInfo()
    self:InitData()
    Wnd_SetEnable(self.UIGROUP, self.BTN_MY_ATASK, 1)
    Wnd_SetEnable(self.UIGROUP, self.BTN_CAN_ATASK, 0)
    Btn_Check(self.UIGROUP, self.BTN_MY_ATASK, 0)
    Btn_Check(self.UIGROUP, self.BTN_CAN_ATASK, 1)
    Wnd_Hide(self.UIGROUP, self.BTN_TASK_DESC)
    Wnd_Hide(self.UIGROUP, self.BTN_SHARE_TASK)
    Wnd_Hide(self.UIGROUP, self.BTN_GIVEUP_TASK)
    Wnd_Hide(self.UIGROUP, self.BTN_TRACK_TASK)
    Wnd_Hide(self.UIGROUP, self.BTN_TASK_INFO)
    Wnd_Hide(self.UIGROUP, self.TXT_TASK_NUM)
    Wnd_Show(self.UIGROUP, self.WND_TASK_INFO)
    Wnd_Hide(self.UIGROUP, self.WND_TASK_DESC)
    Wnd_Show(self.UIGROUP, self.BTN_SKIP_TASK)
    Wnd_SetEnable(self.UIGROUP, self.BTN_SKIP_TASK, 0)
  elseif szWndName == self.BTN_SKIP_TASK then
    local nTaskId = self:GetCurrTaskId()
    local nReferId = Task:GetReferID(nTaskId, Task:GetFinishedIdx(nTaskId) + 1)
    if not nReferId then
      return
    end
    --发送跳过请求给服务器
    KTask.SkipTask(me, nTaskId, nReferId)
  end
end

-- ================================================
--                任务相关功能函数
-- ================================================

-- 初始化数据
function uiTaskPanel:InitData()
  local nOutLookIdx, szTaskName = 0, ""
  self:UpdateTaskList()
  self:Init()
  if self.nTaskPanelType == 0 then
    local tbPlayerTask = Task:GetPlayerTask(me)
    for _, tbTask in pairs(tbPlayerTask.tbTasks) do
      nOutLookIdx, szTaskName = self:AddTask(tbTask.nTaskId)
      if Ui(Ui.UI_TASKTRACK):IsBeTracked(tbTask.nTaskId) then
        szTaskName = "★" .. szTaskName
      else
        szTaskName = "  " .. szTaskName
      end

      if self:CheckFinishTask(tbTask.nTaskId) == 1 then
        szTaskName = string.format("<color=green>%s<color>", szTaskName)
      end

      AddOutLookItem(self.UIGROUP, self.OUTLOOK_TASK_LIST, nOutLookIdx - 1, { szTaskName })
    end
  end
  if self.nTaskPanelType == 1 then
    self.tbTaskCanAppectList = {}
    local tbRangeCamp = Task:GetMaxLevelCampTaskInfo(me)
    for _, tbTask in ipairs(tbRangeCamp) do
      nOutLookIdx, szTaskName = self:AddTask(tbTask[4])
      self.tbTaskCanAppectList[tbTask[4]] = tbTask
      AddOutLookItem(self.UIGROUP, self.OUTLOOK_TASK_LIST, nOutLookIdx - 1, { "  【" .. tbTask[1] .. "级】" .. szTaskName })
    end

    local tbRangeDesc = Task:GetAllMainTaskInfo(me)
    for _, tbTask in ipairs(tbRangeDesc) do
      nOutLookIdx, szTaskName = self:AddTask(tbTask[4])
      self.tbTaskCanAppectList[tbTask[4]] = tbTask
      AddOutLookItem(self.UIGROUP, self.OUTLOOK_TASK_LIST, nOutLookIdx - 1, { "  【" .. tbTask[1] .. "级】" .. szTaskName })
    end
    local tbRangeDesc2 = Task:GetBranchTaskTable(me)
    for _, tbTask in ipairs(tbRangeDesc2) do
      nOutLookIdx, szTaskName = self:AddTask(tbTask[4])
      self.tbTaskCanAppectList[tbTask[4]] = tbTask
      local nTaskId = tbTask[4]
      local nReferId = Task:GetReferID(nTaskId, Task:GetFinishedIdx(nTaskId) + 1)
      local strDesc
      if Task:IsTaskCanSkip(nTaskId, nReferId) == 1 then
        strDesc = { "<color=GREEN>  【" .. tbTask[1] .. "级】" .. szTaskName .. "<color>" }
      else
        strDesc = { "  【" .. tbTask[1] .. "级】" .. szTaskName }
      end
      AddOutLookItem(self.UIGROUP, self.OUTLOOK_TASK_LIST, nOutLookIdx - 1, strDesc)
    end
  end
  self.nInitDone = 1
end

-- 任务更新的时候nSaveGroup为0表示删除一个任务，否则看本地有无此任务，有刷新，没有添加
function uiTaskPanel:RefreshTask(nTaskId, nReferId, nSaveGroup)
  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    return
  end
  if self.nTaskPanelType == 1 then
    if self:HaveThisTask(nTaskId) == 1 then
      self:InitData()
    end
    return
  end

  local nHaveThisTask = self:HaveThisTask(nTaskId)

  if nSaveGroup == 0 then
    if nHaveThisTask then
      self:RemoveTask(nTaskId)
      self:InitData()
    end
  else
    if nHaveThisTask then
      if self:GetCurrTaskId() == nTaskId then
        self:SelectTask(nTaskId)
      end

      if Ui(Ui.UI_TASKTRACK):IsBeTracked(nTaskId) then
        Ui(Ui.UI_TASKTRACK):Refresh()
      end
    else
      local nOutLookIdx, szTaskName = self:AddTask(nTaskId)
      if (self.nInitDone == 1) and (nOutLookIdx - 1 >= 0) then
        if Ui(Ui.UI_TASKTRACK):IsBeTracked(nTaskId) then
          szTaskName = "★" .. szTaskName
        else
          szTaskName = "  " .. szTaskName
        end

        if self:CheckFinishTask(nTaskId) == 1 then
          szTaskName = string.format("<color=green>%s<color>", szTaskName)
        end
        AddOutLookItem(self.UIGROUP, self.OUTLOOK_TASK_LIST, nOutLookIdx - 1, { szTaskName })
        local nGroupIdx, nItemIdx = self:GetItemLocalByTask(nTaskId)
        if nGroupIdx >= 0 and nGroupIdx <= 5 then
          OutLookPanelSelItem(self.UIGROUP, self.OUTLOOK_TASK_LIST, nGroupIdx, nItemIdx)
          self:SelectTask(nTaskId)
        end
      end
    end
  end
  self:ShowTotalTaskNum()
end

-- 选中指定Id的任务
function uiTaskPanel:SelectTask(nTaskId)
  self:LayoutTaskInfo(nTaskId)
end

-- 增加一个任务(任务所有属性可以通过Id区分，包括图像位置，任务类型等。引用子任务...)
function uiTaskPanel:AddTask(nTaskId)
  local nTaskIconIdx = self:GetTaskIconIdx(nTaskId)
  local szTaskName = self:GetTaskName(nTaskId)
  local nTaskType = self:GetTaskType(nTaskId)
  local nTaskMapIndex = self:GetTaskMapIndex(nTaskType)

  for i = 1, #self.m_tbTaskIdMap do
    if nTaskMapIndex == i then
      if (self.m_tbTaskIdMap[i] ~= {}) and (self.m_tbTaskIdMap[i] ~= nil) then
        for j, tbTaskMap in pairs(self.m_tbTaskIdMap[i]) do -- 如果已经有这个任务，则返回
          if tbTaskMap == nTaskId then
            return i, szTaskName, j
          end
        end
      end
      table.insert(self.m_tbTaskIdMap[i], nTaskId)
      return i, szTaskName, j
    end
  end
end

function uiTaskPanel:GetTaskMapIndex(nTaskType)
  if nTaskType == Task.emType_Main then
    return 2
  elseif nTaskType == Task.emType_Branch then
    return 3
  elseif nTaskType == Task.emType_World then
    return 4
  elseif nTaskType == Task.emType_Random then
    return 5
  elseif nTaskType == Task.emType_Camp then
    return 1
  end

  return 5
end

-- 当前任务界面是否存在这个任务
function uiTaskPanel:HaveThisTask(nDestTaskId)
  for i = 1, #self.m_tbTaskIdMap do
    if self.m_tbTaskIdMap[i] then
      for _, nTaskId in pairs(self.m_tbTaskIdMap[i]) do -- 如果已经有这个任务，则返回
        if nTaskId == nDestTaskId then
          return 1
        end
      end
    end
  end
end

-- 根据任务 id 得到其在界面中属于哪个 Group 和 Item
function uiTaskPanel:GetItemLocalByTask(nTaskId)
  for j, tbTaskMap in ipairs(self.m_tbTaskIdMap) do
    for i = 1, #tbTaskMap do
      if tbTaskMap[i] == nTaskId then
        return j - 1, i - 1
      end
    end
  end
end

-- 寻找目前玩家接到的任务中第一个，用于打开界面后始终有任务显示
-- 返回任务 ID
function uiTaskPanel:FindFirstTask()
  if Task:GetPlayerTask(me).nCount <= 0 then
    return 0
  end
  for j, tbTaskMap in ipairs(self.m_tbTaskIdMap) do
    for i = 1, #tbTaskMap do
      if tbTaskMap[i] > 0 then
        return tbTaskMap[i]
      end
    end
  end
end

-- 删除一个任务
function uiTaskPanel:RemoveTask(nTaskId)
  for j, tbTaskMap in ipairs(self.m_tbTaskIdMap) do
    for i = 1, #tbTaskMap do
      if tbTaskMap[i] == nTaskId then
        if self:GetCurrTaskId() == nTaskId then
          self:EmptyTaskInfo()
          LinkPanelSetText(self.UIGROUP, self.TXT_TASK_TEXT, "")
          LinkPanelSetText(self.UIGROUP, self.TXT_TASK_DESC, "")
        end
        table.remove(tbTaskMap, i)
        if self.nInitDone == 1 then
          DelOutLookItem(self.UIGROUP, self.OUTLOOK_TASK_LIST, j, i - 1)
        end
        return
      end
    end
  end
end

-- 用户选择共享任务
function uiTaskPanel:OnShareTask(nTaskId)
  if nTaskId and nTaskId > 0 then
    local tbPlayerTask = Task:GetPlayerTask(me)
    local nReferId = tbPlayerTask.tbTasks[nTaskId].nReferId
    KTask.SendShare(me, nTaskId, nReferId, 1)
  end
end

-- 用户选择追踪任务
function uiTaskPanel:OnTrackTask()
  local nCurrTaskId = self:GetCurrTaskId()
  if nCurrTaskId == nil or nCurrTaskId <= 0 then
    return
  end
  -- 如果这个任务正在被跟踪则取消跟踪它
  if Ui(Ui.UI_TASKTRACK):IsBeTracked(nCurrTaskId) then
    Ui(Ui.UI_TASKTRACK):RemoveTrackedTask(nCurrTaskId)
  else
    Ui(Ui.UI_TASKTRACK):AddTrackedTask(nCurrTaskId)
  end
  self:InitData()
end

-- 用户点击超链接
function uiTaskPanel:OnLinkClick(szWnd, szLinkInfo)
  local tbLinkClass, szLink = self:ParseLink(szLinkInfo)
  tbLinkClass:OnClick(szLink)
end

function uiTaskPanel:OnLinkRClick(szWnd, szLinkInfo)
  local tbLinkClass, szLink = self:ParseLink(szLinkInfo)
  tbLinkClass:OnRClick(szLink)
end

-- 超链接Tip
function uiTaskPanel:OnLinkHover(szWnd, szLinkInfo)
  local tbLinkClass, szLink = self:ParseLink(szLinkInfo)
  local szTip = tbLinkClass:GetTip(szLink)
  Wnd_ShowMouseHoverInfo(self.UIGROUP, self.WND_TASK_INFO, "", szTip)
end

-- 解析超链接
function uiTaskPanel:ParseLink(szLinkInfo)
  local tbSplit = Lib:SplitStr(szLinkInfo, "=")

  local tbLinkClass = UiManager.tbLinkClass[tbSplit[1]]
  local szLink = tbSplit[2]
  return tbLinkClass, szLink
end

-- 得到当前选择的任务 ID
function uiTaskPanel:GetCurrTaskId()
  return tbTempData.nSelectTaskId
end

-- 收到服务器信息，打开跳过任务的窗口
function uiTaskPanel:OnSkipTaskCallBack(nTaskId, nReferId)
  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    -- 若考虑用插件自动跳任务，可不用这个判断
    return
  end
  local tbParm = { nTaskId, nReferId, 2 } --参数为2，表示跳过任务直接领奖
  UiManager:OpenWindow(Ui.UI_GUTAWARD, tbParm)
end

--收到服务器完成了跳过任务领奖，刷新任务面板
function uiTaskPanel:OnCompleteGetSkipAward() --不知参数如何
  if UiManager:WindowVisible(self.UIGROUP) ~= 1 or self.nTaskPanelType ~= 1 then
    return
  end
  local nPreSelGroupIdx = tbTempData.nSelGroupIdx
  local nPreSelItemIdx = tbTempData.nSelItemIdx
  self:EmptyTaskInfo()
  self:InitData()
  local nTaskId = self.m_tbTaskIdMap[nPreSelGroupIdx + 1][nPreSelItemIdx + 1]

  if tbTempData.nScrollHeight then
    ScrPanel_SetWndDocumentAbsoluteTop(self.UIGROUP, self.OUTLOOK_TASK_SCROLL, tbTempData.nScrollHeight) --恢复可接任务面板滚动条位置
  end

  if nTaskId ~= nil then
    OutLookPanelSelItem(self.UIGROUP, self.OUTLOOK_TASK_LIST, nPreSelGroupIdx, nPreSelItemIdx)
    self:SelectTask(nTaskId)
  end
end
-- ================================================
--                     子函数
-- ================================================

-- 获得一个任务的类型(剧情任务， 地图任务， 随机任务， 江湖任务， 流言任务)
function uiTaskPanel:GetTaskType(nTaskId)
  return tonumber(Task.tbTaskDatas[nTaskId].tbAttribute.TaskType)
end

-- 获得一个任务的名字
function uiTaskPanel:GetTaskName(nTaskId)
  return Task:GetTaskName(nTaskId)
end

-- 获得一个任务的描述
function uiTaskPanel:GetTaskDesc(nTaskId)
  return Task:GetTaskDesc(nTaskId)
end

-- 获得当前任务中的引用子任务名字
function uiTaskPanel:GetCurRefName(nTaskId)
  local tbPlayerTask = Task:GetPlayerTask(me)

  local tbTask = tbPlayerTask.tbTasks[nTaskId]
  return tbTask.tbReferData.szName
end

function uiTaskPanel:GetCurRefDegree(nTaskId)
  local tbPlayerTask = Task:GetPlayerTask(me)

  local tbTask = tbPlayerTask.tbTasks[nTaskId]

  local szDegreeDesc = Task:GetRefSubTaskDegreeDesc(tbTask.tbReferData.nReferId) or ""

  return szDegreeDesc
end

-- 获得当前任务中的引用子任务描述
function uiTaskPanel:GetCurRefDesc(nTaskId)
  local tbPlayerTask = Task:GetPlayerTask(me)
  local tbTask = tbPlayerTask.tbTasks[nTaskId]
  local tbStepsDesc = tbTask.tbReferData.tbDesc.szMainDesc
  return tbStepsDesc or ""
end

function uiTaskPanel:GetSubDesc(nTaskId)
  local tbPlayerTask = Task:GetPlayerTask(me)
  local nReferId = tbPlayerTask.tbTasks[nTaskId].nReferId
  local nSubTaskId = Task.tbReferDatas[nReferId].nSubTaskId
  if Task.tbSubDatas[nSubTaskId] then
    return Task.tbSubDatas[nSubTaskId].szDesc
  end
  return ""
end

-- 获得指定任务当前步骤的描述
function uiTaskPanel:GetCurStepDesc(nTaskId)
  local tbPlayerTask = Task:GetPlayerTask(me)
  local tbTask = tbPlayerTask.tbTasks[nTaskId]
  if tbTask.nCurStep > 0 then
    local tbStepsDesc = tbTask.tbReferData.tbDesc.tbStepsDesc
    if tbStepsDesc then
      local szDsc = Task:ReplaceName_Link(tbStepsDesc[tbTask.nCurStep])
      return szDsc or ""
    end
  else
    local szDsc = Task:ReplaceName_Link(tbTask.tbReferData.szReplyDesc)
    return szDsc or ""
  end
  return ""
end

function uiTaskPanel:GetStepAwardDesc(nTaskId)
  local tbPlayerTask = Task:GetPlayerTask(me)
  local tbTask = tbPlayerTask.tbTasks[nTaskId]
  local tbSubData = tbTask.tbSubData
  local tbCurStep = tbSubData.tbSteps[tbTask.nCurStep]

  if tbCurStep then
    if tbCurStep.szAwardDesc and tbCurStep.szAwardDesc ~= "" then
      local szTotleDesc = "<color=Gold>步骤奖励：<color=White>\n"
      return Lib:StrTrim(szTotleDesc .. tbCurStep.szAwardDesc, "\n")
    else
      return ""
    end
  else
    return ""
  end
end

-- 获得指定任务当前目标
function uiTaskPanel:GetCurTargetDesc(nTaskId)
  local szTotleDesc = ""
  local tbPlayerTask = Task:GetPlayerTask(me)
  local tbTask = tbPlayerTask.tbTasks[nTaskId]

  local tbCurTags = tbTask.tbCurTags
  for _, tbCurTag in ipairs(tbCurTags) do
    local szFinishTag = "   (已完成)"
    local szTagDesc = tbCurTag:GetDesc()
    if szTagDesc and szTagDesc ~= "" then
      if tbCurTag:IsDone() then
        szTotleDesc = szTotleDesc .. "<color=Green>" .. tbCurTag:GetDesc() .. szFinishTag .. "<color=White>\n"
      else
        szTotleDesc = szTotleDesc .. "<color=Red>" .. tbCurTag:GetDesc() .. "<color=White>\n"
      end
    end
  end

  if szTotleDesc then
    szTotleDesc = string.gsub(szTotleDesc, "秋姨", "白秋琳")
  end

  return szTotleDesc or ""
end

-- 获得指定任务当前步骤的积累描述(包括之前的步骤)
function uiTaskPanel:GetCurTotleStepDesc(nTaskId)
  local tbPlayerTask = Task:GetPlayerTask(me)
  local tbTask = tbPlayerTask.tbTasks[nTaskId]
  local tbStepsDesc = tbTask.tbReferData.tbDesc.tbStepsDesc

  local szStepsDesc = ""
  if tbStepsDesc then
    for i = 1, tbTask.nCurStep do
      if tbStepsDesc[i] then
        --szStepsDesc = szStepsDesc.."步骤"..tostring(i).."："..tbStepsDesc[i].."\n";
        szStepsDesc = szStepsDesc .. "  " .. tbStepsDesc[i] .. "\n"
      end
    end
  end

  Lib:StrTrim(szStepsDesc, "\n")
  return szStepsDesc or ""
end

-- 获得一个任务的图片索引
function uiTaskPanel:GetTaskIconIdx(nTaskId)
  return tonumber(Task.tbTaskDatas[nTaskId].tbAttribute.TaskIconIndex)
end

-- 获得任务系统图片路径
function uiTaskPanel:GetAwardIconPath(nIconIndex)
  return KTask.GetIconPath(nIconIndex)
end

-- 获得一个物品奖励的信息
-- 如果 tbAwardInfo 表里有，则直接返回该字符串，如果没有才创建一个 pItem 对象
function uiTaskPanel:GetItemAwardInfo(nTaskId, tbItem, nItemType)
  local nGenre, nDetail, nParticular, nLevel, nSeries = unpack(tbItem)

  if nLevel == 0 then
    nLevel = 1
  end
  if nSeries == -1 then
    nSeries = 0
  end

  local pItem = nil

  if not self.tbAwardInfo[nTaskId] then
    self.tbAwardInfo[nTaskId] = {}
  end

  local szItemKey = tostring(nGenre .. "," .. nDetail .. "," .. nParticular .. "," .. nLevel)

  if not self.tbAwardInfo[nTaskId][szItemKey] then
    self.tbAwardInfo[nTaskId][szItemKey] = {}
    pItem = KItem.CreateTempItem(nGenre, nDetail, nParticular, nLevel, nSeries)
    if not pItem then
      return ""
    end
    self.tbAwardInfo[nTaskId][szItemKey] = { pItem.szName, pItem.szIconImage }
    -- 删除对象
    pItem.Remove()
  end

  return unpack(self.tbAwardInfo[nTaskId][szItemKey])
end

-- 任务链的特殊处理
function uiTaskPanel:LinkTaskTextOut()
  local szMainText = "包万同的任务：\n\n义军一直坚持在江北各地与金国军队交战。常年的征战下来，军饷、补给、死伤病患的抚恤耗光了从各处募得的钱粮。\n\n由于两国时战时和，消耗甚巨，捐助钱粮的商人们却没有见到义军有任何实质性进展，便逐渐减少了供给。迫得白秋琳只能自筹军饷，以解燃眉之急。\n\n目前唯一可行的方法是由义军成员包万同来出面遍邀天下豪杰，为义军筹措物资，为了帮秋姨排忧解难，还是尽可能的完成包万同交待的任务吧。\n\n"

  szMainText = szMainText .. "当前包万同交给你的任务是：\n"

  return szMainText
end

function uiTaskPanel:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_TASK_REFRESH, self.RefreshTask },
    { UiNotify.emCOREEVENT_TASK_SKIP, self.OnSkipTaskCallBack }, --收到弹出跳过任务窗口
    { UiNotify.emCOREEVENT_TASK_SKIPAWARD, self.OnCompleteGetSkipAward }, --成功获取跳过任务奖励后回调，用于刷新窗口
  }
  for i in ipairs(self.WND_FIX_AWARD[2]) do
    tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbFixCont[i]:RegisterEvent())
  end
  for i in ipairs(self.WND_OPTIONAL_AWARD[2]) do
    tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbOptionalCont[i]:RegisterEvent())
  end
  return tbRegEvent
end

function uiTaskPanel:RegisterMessage()
  local tbRegMsg = {}
  for i in ipairs(self.WND_FIX_AWARD[2]) do
    tbRegMsg = Lib:MergeTable(tbRegMsg, self.tbFixCont[i]:RegisterMessage())
  end
  for i in ipairs(self.WND_OPTIONAL_AWARD[2]) do
    tbRegMsg = Lib:MergeTable(tbRegMsg, self.tbOptionalCont[i]:RegisterMessage())
  end
  return tbRegMsg
end
