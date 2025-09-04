-----------------------------------------------------
--文件名		：	uiGutAward.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-8-17 17:39:42
--功能描述		：	任务接取，任务奖励，跳过任务奖励
------------------------------------------------------

local uiGutAward = Ui:GetClass("gutaward")
local tbObject = Ui.tbLogic.tbObject
local tbAwardInfo = Ui.tbLogic.tbAwardInfo

local BTN_ACCEPT = "zBtnAccept"
local BTN_IGNORE = "zBtnIgnore"
local BTN_CLOSE = "BtnClose"
local TEXT_TASK_DESC = "TxtDialog"
local TEXT_HEADDESC = "TxtHeadDesc"
local WND_HIGHT_LIGHT = "zImgHightLight"

local WND_FIX_AWARD = {
  "WndFixAward",
  { "ObjFix1", "ObjFix2", "ObjFix3", "ObjFix4", "ObjFix5" },
  { "ImgFix1Bg", "ImgFix2Bg", "ImgFix3Bg", "ImgFix4Bg", "ImgFix5Bg" },
}

local WND_RANDOM_AWARD = {
  "WndRandomAward",
  { "ObjRandom1", "ObjRandom2", "ObjRandom3", "ObjRandom4", "ObjRandom5" },
  { "ImgRandom1Bg", "ImgRandom2Bg", "ImgRandom3Bg", "ImgRandom4Bg", "ImgRandom5Bg" },
}

local WND_OPTIONAL_AWARD = {
  "WndOptionalAward",
  { "ObjOptional1", "ObjOptional2", "ObjOptional3", "ObjOptional4", "ObjOptional5" },
  { "ImgOptional1Bg", "ImgOptional2Bg", "ImgOptional3Bg", "ImgOptional4Bg", "ImgOptional5Bg" },
}

function uiGutAward:OnCreate()
  self.tbFixCont = {}
  self.tbOptionalCont = {}
  self.tbRandomCont = {}
  for i, tbAward in ipairs(WND_FIX_AWARD[2]) do
    self.tbFixCont[i] = tbObject:RegisterContainer(self.UIGROUP, tbAward, 4, 2, nil, "award")
  end
  for i, tbAward in ipairs(WND_OPTIONAL_AWARD[2]) do
    self.tbOptionalCont[i] = tbObject:RegisterContainer(self.UIGROUP, tbAward, 4, 2, nil, "award")
  end
  for i, tbAward in ipairs(WND_RANDOM_AWARD[2]) do
    self.tbRandomCont[i] = tbObject:RegisterContainer(self.UIGROUP, tbAward, 4, 2, nil, "award")
  end
end

function uiGutAward:OnDestroy()
  for _, tbCont in ipairs(self.tbFixCont) do
    tbObject:UnregContainer(tbCont)
  end
  for _, tbCont in ipairs(self.tbOptionalCont) do
    tbObject:UnregContainer(tbCont)
  end
  for _, tbCont in ipairs(self.tbRandomCont) do
    tbObject:UnregContainer(tbCont)
  end
end

function uiGutAward:Init()
  self.nTaskId = 0
  self.nReferId = 0
  self.nSelectedAward = -1
  self.bTaskAccept = 0
  self.tbAwards = {}
  self.szMsg = ""
end

function uiGutAward:OnOpen(tbParam)
  if tbParam[1] == 0 then -- 任务ID == 0 表示任务链
    self.nTaskId = 0
    self.nReferId = 0
    self.szMsg = tbParam[2] -- 奖励时的文字
    self.tbAwards = me.GetChainTaskAward()
    self.bTaskAccept = 0 -- 领取奖励
    if not self.tbAwards then
      return 0
    end
  else
    self.nTaskId = tbParam[1]
    self.nReferId = tbParam[2]
    self.bTaskAccept = tbParam[3] -- 为0时完成任务领取奖励，为1接取任务，为2跳过任务直接领奖
  end

  Wnd_Hide(self.UIGROUP, WND_HIGHT_LIGHT)
  if self.bTaskAccept == 0 or self.bTaskAccept == 2 then -- 领取奖励
    Btn_SetTxt(self.UIGROUP, BTN_ACCEPT, " 领 取 ")
    Btn_SetTxt(self.UIGROUP, BTN_IGNORE, " 取 消 ")
  else -- 接受任务
    Btn_SetTxt(self.UIGROUP, BTN_ACCEPT, " 接 受 ")
    Btn_SetTxt(self.UIGROUP, BTN_IGNORE, " 拒 绝 ")
  end
  self:UpdateTaskAward()
  --新手任务指引
  if self.bTaskAccept ~= 2 then
    Tutorial:CheckSepcialEvent("gutaward", { self.nTaskId, self.bTaskAccept })
  end
end

function uiGutAward:OnClose()
  for i in ipairs(WND_FIX_AWARD[2]) do
    self:RemoveTempItem(self.tbFixCont[i])
  end
  for i in ipairs(WND_OPTIONAL_AWARD[2]) do
    self:RemoveTempItem(self.tbOptionalCont[i])
  end
  for i in ipairs(WND_RANDOM_AWARD[2]) do
    self:RemoveTempItem(self.tbRandomCont[i])
  end
end

function uiGutAward:OnButtonClick(szWndName, nParam)
  if szWndName == BTN_ACCEPT then -- 接受一个任务
    if self.bTaskAccept == 0 then
      self:OnAcceptAward()
    elseif self.bTaskAccept == 2 then
      self:OnSkipTaskGetAward()
    else
      self:OnAcceptTask()
    end
  elseif szWndName == BTN_IGNORE or szWndName == BTN_CLOSE then -- 放弃，按钮为一个任务添加一子任务
    if self.bTaskAccept == 0 then
      self:OnCancelAward()
    elseif self.bTaskAccept == 1 then
      self:OnIgnoreTask()
    elseif self.bTaskAccept == 2 then
      self:OnCancelSkipAward()
    end
  elseif self.bTaskAccept == 0 or self.bTaskAccept == 2 then
    for i = 1, #WND_OPTIONAL_AWARD[2] do -- 选择任务奖励
      if szWndName == WND_OPTIONAL_AWARD[2][i] then
        if 1 == self:IsSpeOptAward(i) then
          self:OnSelectSpeOptAward(i)
        else
          self:OnAcceptOptAward(i)
        end
        break
      end
    end
  end
end

-- 选择可选奖励的操作
function uiGutAward:OnAcceptOptAward(nOptIndex)
  local nParentX, nParentY, _, _ = Wnd_GetPos(self.UIGROUP, WND_OPTIONAL_AWARD[1])
  local nObjX, nObjY, _, _ = Wnd_GetPos(self.UIGROUP, WND_OPTIONAL_AWARD[3][nOptIndex])
  Wnd_SetPos(self.UIGROUP, WND_HIGHT_LIGHT, nParentX + nObjX + 3, nParentY + nObjY + 3)
  Wnd_Show(self.UIGROUP, WND_HIGHT_LIGHT)
  self.nSelectedAward = nOptIndex
end

-- 判断是否有资格选择可选奖励
function uiGutAward:IsSpeOptAward(nOptIndex)
  local tbOpt = self.tbAwards.tbOpt[nOptIndex]
  if not tbOpt then
    return
  end
  local nTaskId = self.nTaskId or 0
  local nReferId = self.nReferId or 0
  local nIndex
  local varTmpValue = tbOpt.varValue
  if type(varTmpValue) == "table" then
    nIndex = varTmpValue[1]
  end
  return Task:IsSpeOptAward(nTaskId, nReferId, nIndex)
end

-- 选择了需要特殊处理的可选奖励（门派装备）
function uiGutAward:OnSelectSpeOptAward(nOptIndex)
  local tbOpt = self.tbAwards.tbOpt[nOptIndex]
  if not tbOpt then
    return
  end
  local nTaskId = self.nTaskId or 0
  local nReferId = self.nReferId or 0
  local nIndex = tbOpt.varValue[1] or 0

  local tbInfo = Task:GetSpeOptInfo(nTaskId, nReferId, nIndex)
  if not tbInfo then
    return
  end

  if not tbInfo.tbCostGDPL or Lib:CountTB(tbInfo.tbCostGDPL) ~= 4 then
    return
  end
  local nCostNum = tbInfo.nCost
  if nCostNum == 0 then
    self:OnAcceptOptAward(nOptIndex)
    return
  end

  local szCostName = KItem.GetNameById(unpack(tbInfo.tbCostGDPL))
  if not szCostName then
    return
  end

  local tbMsg = {}
  tbMsg.szMsg = string.format("注意：选择这项奖励将会扣除<color=yellow>%s<color>个<color=yellow>%s<color>（奇珍阁%s区有售），你确定要选吗？", nCostNum, szCostName, IVER_g_szCoinName)
  tbMsg.nOptCount = 2
  tbMsg.tbOptTitle = { "取消", "确定" }
  function tbMsg:Callback(nIndex, nOptIndex, tbSelf)
    if nIndex == 2 then
      tbSelf.OnAcceptOptAward(tbSelf, nOptIndex)
    end
  end
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nOptIndex, self)
end

function uiGutAward:OnAcceptTask()
  KTask.SendAccept(me, self.nTaskId, self.nReferId, 1)
  UiManager:CloseWindow(self.UIGROUP)
  -- TODO: liuchang 关闭剧情模式
end

function uiGutAward:OnIgnoreTask()
  KTask.SendAccept(me, self.nTaskId, self.nReferId, 0)
  UiManager:CloseWindow(self.UIGROUP)
  -- TODO: liuchang 关闭剧情模式
end

-- 直接跳过任务获取奖励
function uiGutAward:OnSkipTaskGetAward()
  local tbAwards = self.tbAwards
  if tbAwards.tbOpt and #tbAwards.tbOpt > 0 then -- 有可选奖励
    if self.nSelectedAward > 0 then
      if self.nTaskId ~= 0 then
        KTask.SendSkipAward(me, self.nTaskId, self.nReferId, self.nSelectedAward)
      end
      UiManager:CloseWindow(self.UIGROUP)
    else
      me.Msg("请在可选奖励中挑你喜欢的一项。")
    end
  else -- 没有可选奖励
    if self.nTaskId ~= 0 then
      KTask.SendSkipAward(me, self.nTaskId, self.nReferId, 0)
    end
    UiManager:CloseWindow(self.UIGROUP)
  end
end
function uiGutAward:OnCancelSkipAward()
  if self.nTaskId ~= 0 then
    KTask.SendSkipAward(me, self.nTaskId, self.nReferId, -1)
  end
  UiManager:CloseWindow(self.UIGROUP)
end
function uiGutAward:OnAcceptAward()
  local tbAwards = self.tbAwards
  if tbAwards.tbOpt and #tbAwards.tbOpt > 0 then -- 有可选奖励
    if self.nSelectedAward > 0 then
      if self.nTaskId ~= 0 then
        Task:SendAward(self.nTaskId, self.nReferId, self.nSelectedAward)
      else
        KTask.SendGeneralAward(me, self.nSelectedAward)
      end
      UiManager:CloseWindow(self.UIGROUP)
    else
      me.Msg("请在可选奖励中挑你喜欢的一项。")
    end
  else -- 没有可选奖励
    if self.nTaskId ~= 0 then
      Task:SendAward(self.nTaskId, self.nReferId, 0)
    else
      KTask.SendGeneralAward(me, 0)
    end
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiGutAward:OnCancelAward()
  if self.nTaskId ~= 0 then
    Task:SendAward(self.nTaskId, self.nReferId, -1)
  end
  UiManager:CloseWindow(self.UIGROUP)

  -- TODO: liuchang 关闭剧情模式	(如果是任务炼(m_nTaskId == 0)则没进入剧情模式，不需要关闭)
end

function uiGutAward:UpdateTaskAward()
  if self.nReferId ~= 0 then
    local szRefSubTaskName = Task:GetManSubName(self.nReferId)
    if self.bTaskAccept == 1 then
      local szRefSubTaskDesc = Task:GetManSubDesc(self.nReferId)
      Txt_SetTxt(self.UIGROUP, TEXT_TASK_DESC, "<color=yellow>任务：" .. szRefSubTaskName .. "<color><enter><enter>" .. szRefSubTaskDesc .. "<enter>") -- 任务描述
      Txt_SetTxt(self.UIGROUP, TEXT_HEADDESC, "任 务 接 受")
    else
      local strDesc = "领取<color=yellow>" .. szRefSubTaskName .. "<color>任务的奖励："
      if self.bTaskAccept == 2 then
        local _, strTmp = Task:GetSkipDesc(self.nTaskId, self.nReferId)
        strDesc = strDesc .. "\n\n\n\n\n\n\n\n\n\n\n\n\n" .. strTmp
      end

      Txt_SetTxt(self.UIGROUP, TEXT_TASK_DESC, strDesc)
      Txt_SetTxt(self.UIGROUP, TEXT_HEADDESC, "任 务 奖 励")
    end
    if Task:GetPlayerTask(me).tbTasks[self.nTaskId] then
      self.tbAwards = Task:GetAwardsForMe(self.nTaskId)
    else
      self.tbAwards = Task:GetAwards(self.nReferId)
    end
  else
    Txt_SetTxt(self.UIGROUP, TEXT_TASK_DESC, self.szMsg)
    Txt_SetTxt(self.UIGROUP, TEXT_HEADDESC, "任 务 奖 励")
  end

  -- 固定奖励
  for i = 1, #WND_FIX_AWARD[2] do
    if self.tbAwards.tbFix and self.tbAwards.tbFix[i] then
      local tbAward = self.tbAwards.tbFix[i]
      self:AddAwardObj(self.tbFixCont[i], tbAward)
      Wnd_Show(self.UIGROUP, WND_FIX_AWARD[3][i])
    else
      Wnd_Hide(self.UIGROUP, WND_FIX_AWARD[3][i])
    end
  end
  if self.tbAwards.tbFix and #self.tbAwards.tbFix > 0 then
    Wnd_Show(self.UIGROUP, WND_FIX_AWARD[1])
  else
    Wnd_Hide(self.UIGROUP, WND_FIX_AWARD[1])
  end

  -- 可选奖励
  for i = 1, #WND_OPTIONAL_AWARD[2] do
    if self.tbAwards.tbOpt and self.tbAwards.tbOpt[i] then
      local tbAward = self.tbAwards.tbOpt[i]
      self:AddAwardObj(self.tbOptionalCont[i], tbAward)
      Wnd_Show(self.UIGROUP, WND_OPTIONAL_AWARD[3][i])
    else
      Wnd_Hide(self.UIGROUP, WND_OPTIONAL_AWARD[3][i])
    end
  end
  if self.tbAwards.tbOpt and #self.tbAwards.tbOpt > 0 then
    Wnd_Show(self.UIGROUP, WND_OPTIONAL_AWARD[1])
  else
    Wnd_Hide(self.UIGROUP, WND_OPTIONAL_AWARD[1])
  end

  -- 随机奖励
  for i = 1, #WND_RANDOM_AWARD[2] do
    if self.tbAwards.tbRand and self.tbAwards.tbRand[i] then
      local tbAward = self.tbAwards.tbRand[i]
      self:AddAwardObj(self.tbRandomCont[i], tbAward)
      Wnd_Show(self.UIGROUP, WND_RANDOM_AWARD[3][i])
    else
      Wnd_Hide(self.UIGROUP, WND_RANDOM_AWARD[3][i])
    end
  end
  if self.tbAwards.tbRand and #self.tbAwards.tbRand > 0 then
    Wnd_Show(self.UIGROUP, WND_RANDOM_AWARD[1])
  else
    Wnd_Hide(self.UIGROUP, WND_RANDOM_AWARD[1])
  end
end

function uiGutAward:AddAwardObj(tbCont, tbAward)
  self:RemoveTempItem(tbCont) -- 容器里原来有东西则回收
  if not tbAward then
    return
  end
  local tbObj = tbAwardInfo:GetAwardInfoObj(tbAward, self.nTaskId, self.nReferId)
  if not tbObj then
    return
  end
  tbCont:SetObj(tbObj)
end

function uiGutAward:RemoveTempItem(tbCont)
  local tbObj = tbCont:GetObj()
  tbAwardInfo:DelAwardInfoObj(tbObj)
  tbCont:SetObj(nil)
end

function uiGutAward:OnTaskAccept(nTaskId, nReferId)
  UiManager:OpenWindow(self.UIGROUP, { nTaskId, nReferId, 1 })
end

function uiGutAward:OnTaskAwrad(nTaskId, varParam1, varParam2)
  if nTaskId ~= 0 then
    UiManager:OpenWindow(self.UIGROUP, { nTaskId, varParam1, 0 })
  else
    UiManager:OpenWindow(self.UIGROUP, { nTaskId, varParam1, 0 })
  end
end

function uiGutAward:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_TASK_ACCEPT, self.OnTaskAccept },
    { UiNotify.emCOREEVENT_TASK_AWARD, self.OnTaskAwrad },
  }
  for i in ipairs(WND_FIX_AWARD[2]) do
    tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbFixCont[i]:RegisterEvent())
  end
  for i in ipairs(WND_OPTIONAL_AWARD[2]) do
    tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbOptionalCont[i]:RegisterEvent())
  end
  for i in ipairs(WND_RANDOM_AWARD[2]) do
    tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbRandomCont[i]:RegisterEvent())
  end
  return tbRegEvent
end

function uiGutAward:RegisterMessage()
  local tbRegMsg = {}
  for i in ipairs(WND_FIX_AWARD[2]) do
    tbRegMsg = Lib:MergeTable(tbRegMsg, self.tbFixCont[i]:RegisterMessage())
  end
  for i in ipairs(WND_OPTIONAL_AWARD[2]) do
    tbRegMsg = Lib:MergeTable(tbRegMsg, self.tbOptionalCont[i]:RegisterMessage())
  end
  for i in ipairs(WND_RANDOM_AWARD[2]) do
    tbRegMsg = Lib:MergeTable(tbRegMsg, self.tbRandomCont[i]:RegisterMessage())
  end
  return tbRegMsg
end
