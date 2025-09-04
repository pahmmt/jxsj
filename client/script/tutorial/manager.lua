-- 文件名　：manager.lua
-- 创建者　：jiazhenwei
-- 创建时间：2011-09-26 14:50:04
-- 功能    ：指引管理

if MODULE_GAMESERVER or MODULE_GC_SERVER then
  return
end

function Tutorial:LoadFile()
  local tbFile = Lib:LoadTabFile("\\setting\\tutorial\\tutorial_tasklist.txt")
  if not tbFile then
    print("指引文件读取错误！")
    return
  end
  for nId, tbParam in ipairs(tbFile) do
    if nId >= 1 then
      local nTaskId = tonumber(tbParam.nId) or 0
      local nSubId = tonumber(tbParam.nSubId) or 0
      local nTaskGroupId = tonumber(tbParam.nTaskGroupId) or 0
      local nTaskSubId = tonumber(tbParam.nTaskSubId) or 0
      local szClassName = tbParam.szClassName or ""
      local szType = tbParam.szType or ""
      self.tbEvent[nTaskId] = self.tbEvent[nTaskId] or {}
      self.tbEvent[nTaskId][nSubId] = self.tbEvent[nTaskId][nSubId] or {}
      self.tbEvent[nTaskId][nSubId].nTaskGroupId = nTaskGroupId
      self.tbEvent[nTaskId][nSubId].nTaskSubId = nTaskSubId
      self.tbEvent[nTaskId][nSubId].szClassName = szClassName
      self.tbEvent[nTaskId][nSubId].tbParam = self.tbEvent[nTaskId][nSubId].tbParam or {}
      for i = 1, 15 do
        local szExparam = "ExParam" .. i
        szExparam = tbParam[szExparam]
        self.tbEvent[nTaskId][nSubId].tbParam[i] = szExparam
      end
      --对话自动触发
      if szClassName == "ShowDialog" then
        local szTitle = self.tbEvent[nTaskId][nSubId].tbParam[2]
        if szTitle ~= "" then
          Tutorial.tbDialogAuto[szTitle] = { nTaskId, nSubId }
          local szConditionTaskId = self.tbEvent[nTaskId][nSubId].tbParam[7] --需要主任务id条件时才显示
          local szConditionSubId = self.tbEvent[nTaskId][nSubId].tbParam[8] --需要子任务id条件时才显示
          local szConditionStep = self.tbEvent[nTaskId][nSubId].tbParam[9] --需要任务步骤条件时才显示
          if szConditionTaskId ~= "" and szConditionSubId ~= "" then
            Tutorial.tbDialogAuto[szTitle][3] = tonumber(szConditionTaskId)
            Tutorial.tbDialogAuto[szTitle][4] = tonumber(szConditionSubId)
            Tutorial.tbDialogAuto[szTitle][5] = tonumber(szConditionStep)
          end
        end
      end
      --任务列表自动触发
      if szClassName == "ShowTaskList" then
        local szTitle = self.tbEvent[nTaskId][nSubId].tbParam[2]
        if szTitle ~= "" then
          Tutorial.tbTaskListAuto[szTitle] = { nTaskId, nSubId }
        end
      end
    end
  end
end

Tutorial:LoadFile()

--开启某个指引
function Tutorial:StarEvent(nTaskId, nStep)
  if self:GetState() > 0 then
    return
  end
  if self.nLock == 1 then
    return
  end
  self:CloseEvent()
  if self.nTaskId ~= nTaskId then
    self.nSubId = 0
  end
  self.nTaskId = nTaskId
  --finish
  self.nSubId = self.nSubId + 1 + (nStep or 0)
  if nStep == 0 then
    self.nSubId = 1
  end
  if self.tbEvent[self.nTaskId][self.nSubId] and self.tbEvent[self.nTaskId][self.nSubId].tbParam[15] then
    GM:DoCommand(self.tbEvent[self.nTaskId][self.nSubId].tbParam[15])
  end
  if not self.tbEvent[nTaskId] or not self.tbEvent[nTaskId][self.nSubId] then
    self:CloseEvent()
    return
  end
  self:StarNewTimer() --开启timer默认一分钟不触发表示放弃当前指引
  local fnFunc = self.tbInterFaceFun[self.tbEvent[nTaskId][self.nSubId].szClassName]
  fnFunc = Tutorial[fnFunc]
  if type(fnFunc) == "function" then
    fnFunc(Tutorial, self.tbEvent[nTaskId][self.nSubId].tbParam)
    self:AutoKeyTutorial()
  end
end

--开启某个指引
function Tutorial:StarEventEx(nTaskId, nStep)
  if self.nLock == 1 then
    return
  end
  self:CloseEvent()
  self.nTaskId = nTaskId
  self.nSubId = nStep
  if nStep == 0 then
    self.nSubId = 1
  end
  if not self.tbEvent[nTaskId] or not self.tbEvent[nTaskId][self.nSubId] then
    self:CloseEvent()
    return
  end
  self:StarNewTimer() --开启timer默认一分钟不触发表示放弃当前指引
  local fnFunc = self.tbInterFaceFun[self.tbEvent[nTaskId][self.nSubId].szClassName]
  fnFunc = Tutorial[fnFunc]
  if type(fnFunc) == "function" then
    fnFunc(Tutorial, self.tbEvent[nTaskId][self.nSubId].tbParam)
  end
end

--开启新的timer
function Tutorial:StarNewTimer()
  if self.nTimer > 0 then
    Timer:Close(self.nTimer)
    self.nTimer = 0
  end
  self.nTimer = Timer:Register(60 * 18, self.CloseEvent, self)
end

--关闭触发事件
function Tutorial:CloseEvent()
  UiManager:CloseWindow(Ui.UI_WEDDING)
  if #self.tbActionWnd > 0 then
    Wnd_CancelPopTip(self.tbActionWnd[1] or "", self.tbActionWnd[2] or "")
  end
  self.tbActionWnd = {}
  self.tbFinishAction = {}
  self.tbCloseAction = {}
  self.tbReAction = {}
  if self.nLock == 1 then
    self.nLock = 0
  end
  if self.nTimer > 0 then
    Timer:Close(self.nTimer)
    self.nTimer = 0
  end
  return 0
end
