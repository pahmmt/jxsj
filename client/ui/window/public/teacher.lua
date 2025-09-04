-----------------------------------------------------
--文件名		：	teacher.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-08-01
--功能描述		：	师徒界面
------------------------------------------------------

local uiTeacher = Ui:GetClass("teacher")
local tbMsgInfo = Ui.tbLogic.tbMsgInfo

uiTeacher.PAGESET_MAIN = "PageSetMain"
uiTeacher.BUTTON_CLOSE = "BtnClose"
uiTeacher.GET_STUDENT_BUTTON = "BtnGetStudent" -- 我要收徒按钮
uiTeacher.GET_TEACHER_BUTTON = "BtnGetTeacher" -- 我要拜师按钮

-- PageStudentInfo 我是徒弟页面
uiTeacher.PAGE_STUDENT_INFO = "PageStudentInfo"
uiTeacher.BTN_STUDENT_INFO_PAGE = "BtnStudentInfoPage" -- 我是徒弟页面按钮
-- uiTeacher.TEXT_FINISH_CHUANGONG		= "TxtFinishChuanGong";		-- 完成师徒修炼信息
uiTeacher.TEXT_TEACHER_LEVEL = "TxtTeacherLevel" -- 师傅等级
uiTeacher.TEXT_TEACHER_NAME = "TxtTeacherName" -- 师傅名字
uiTeacher.ACHIEVEMENT_INFO = "LstAchievementInfo" -- 师徒成就列表

uiTeacher.szTxtTeacherName = "您的师傅："
uiTeacher.szTxtTeacherLevel = "等级："
uiTeacher.szTxtFinChuanGong = "本周完成的师徒修炼："

-- PageFindStudent 寻找徒弟页面
uiTeacher.PAGE_FIND_STUDENT = "PageFindStudent"
uiTeacher.FIND_STUDENT_PAGE_BUTTON = "BtnFindStudent" -- 寻找徒弟页面
uiTeacher.TEACHER_LIST = "LstTeacher" -- 师傅列表
uiTeacher.TALK_TEACHER_BUTTON = "BtnTalkTeacher" -- 开始交谈按钮
uiTeacher.APPLY_TEACHER_BUTTON = "BtnApplyTeacher" -- 申请刷新师傅按钮

-- PageFindTeacher 寻找师傅页面
uiTeacher.PAGE_FIND_TEACHER = "PageFindTeacher"
uiTeacher.FIND_TEACHER_PAGE_BUTTON = "BtnFindTeacher" -- 寻找师傅页按钮
uiTeacher.STUDENT_LIST = "LstStudent" -- 徒弟列表
uiTeacher.TALK_STUDENT_BUTTON = "BtnTalkStudent" -- 开始交谈按钮
uiTeacher.APPLY_STUDENT_BUTTON = "BtnApplyStudent" -- 申请刷新徒弟按钮

-- PageTeacherInfo 我是师傅页面
uiTeacher.PAGE_TEACHER_INFO = "PageTeacherInfo"
uiTeacher.BTN_TEACHER_INFO_PAGE = "BtnTeacherInfoPage" -- 我是师傅页面按钮
uiTeacher.MY_STUDENT_LIST = "LstMyStudent" -- 未出师徒弟列表
uiTeacher.BTN_FIRE_STUDENT = "BtnFireStudent" -- 开除徒弟按钮

function uiTeacher:Init()
  self.m_tbTeacherList = {}
  self.m_tbStudentList = {}
  self.m_nTeacherCount = 0
  self.m_nCurStudentCount = 0
  self.m_nEndStudentCount = 0
  self.m_tbTraining = {} -- 获取师徒关系的列表
  self.m_tMyStudentList = {} -- 我的未出师徒弟列表
end

function uiTeacher:OnOpen()
  Achievement_ST:LoadInfo()
  self:RefreshTraining()
  me.RequestTrainingOption()
  UiNotify:OnNotify(UiNotify.emCOREEVENT_SET_POPTIP, 43) -- TODO: 临时做法
  Ui(Ui.UI_RELATIONNEW):WndOpenCloseCallback(self.UIGROUP, 1)
  PgSet_ActivePage(self.UIGROUP, self.PAGESET_MAIN, self.PAGE_STUDENT_INFO)
  --	self:UpdateAchevementInfo();
  self:UpdateMyTeacherInfo()
  me.CallServerScript({ "AchievementCmd_ST", "GetAchievementInfo_C2S", me.nId })
  Lst_Clear(self.UIGROUP, self.TEACHER_LIST)
  Lst_Clear(self.UIGROUP, self.STUDENT_LIST)
  self:UpdateOption()
end

function uiTeacher:OnClose()
  Ui(Ui.UI_RELATIONNEW):WndOpenCloseCallback(self.UIGROUP, 0)
end

-- 是否具有学生的资格
function uiTeacher:CanBeStudent()
  local szMsg = ""
  if me.nLevel < 20 then
    szMsg = "你的等级还不满20级，不能拜师"
    return 0, szMsg
  end
  if me.nLevel >= 60 then
    szMsg = "你的等级已经超过了60级，不能再拜师"
    return 0, szMsg
  end
  if self.m_nTeacherCount > 0 then
    szMsg = "你已经有师傅了，不能再拜师"
    return 0, szMsg
  end
  return 1, szMsg
end

-- 是否具有老师的资格
function uiTeacher:CanBeTeacher()
  local szMsg = ""
  if me.nLevel < 60 then
    szMsg = "你等级不足60级，暂时不能接受弟子"
    return 0, szMsg
  end
  if self.m_nCurStudentCount > 3 then
    szMsg = "你已经有了3个弟子，不能再接受弟子"
    return 0, szMsg
  end
  return 1
end

function uiTeacher:UpdateOption()
  Wnd_SetEnable(self.UIGROUP, self.GET_TEACHER_BUTTON, self:CanBeStudent())
  Wnd_SetEnable(self.UIGROUP, self.GET_STUDENT_BUTTON, self:CanBeTeacher())
  Wnd_SetEnable(self.UIGROUP, self.FIND_TEACHER_PAGE_BUTTON, self:CanBeStudent())
  Wnd_SetEnable(self.UIGROUP, self.FIND_STUDENT_PAGE_BUTTON, self:CanBeTeacher())
  Btn_Check(self.UIGROUP, self.GET_TEACHER_BUTTON, self:CanBeTeacher())
  Btn_Check(self.UIGROUP, self.GET_STUDENT_BUTTON, self:CanBeStudent())
end

-- 刷新师徒关系的列表数据
function uiTeacher:RefreshTraining()
  self.m_tbTraining = me.Relation_GetTrainingRelation()
  self:UpdateTrainCount()
end

-- 刷新我的师傅和我的徒弟的个数
function uiTeacher:UpdateTrainCount()
  self.m_tbTraining = me.Relation_GetTrainingRelation()
  self.m_nTeacherCount = 0
  self.m_nCurStudentCount = 0
  self.m_nEndStudentCount = 0
  if not self.m_tbTraining then
    return
  end
  for i = 1, #self.m_tbTraining do
    local nIndex = 0
    if (self.m_tbTraining[i].nRole == 0) and (self.m_tbTraining[i].nType == Player.emKPLAYERRELATION_TYPE_TRAINED) then
      self.m_nEndStudentCount = self.m_nEndStudentCount + 1
      nIndex = 2
    elseif self.m_tbTraining[i].nRole == 1 then
      self.m_nTeacherCount = self.m_nTeacherCount + 1
      nIndex = 0
    else
      self.m_nCurStudentCount = self.m_nCurStudentCount + 1
      nIndex = 1
    end
  end
end

function uiTeacher:OnButtonClick(szWnd, nParam)
  if szWnd == self.BUTTON_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.GET_TEACHER_BUTTON then
    Btn_Check(self.UIGROUP, szWnd, 0)
    self:OnChgTeacherOption(nParam)
  elseif szWnd == self.GET_STUDENT_BUTTON then
    Btn_Check(self.UIGROUP, szWnd, 0)
    self:OnChgStudentOption(nParam)
  elseif szWnd == self.BTN_STUDENT_INFO_PAGE then
    self:UpdateMyTeacherInfo()
    me.CallServerScript({ "AchievementCmd_ST", "GetAchievementInfo_C2S", me.nId })
  elseif szWnd == self.BTN_TEACHER_INFO_PAGE then
    self:UpdateMyStudentList()
  elseif szWnd == self.FIND_TEACHER_PAGE_BUTTON or szWnd == self.APPLY_TEACHER_BUTTON then
    Lst_Clear(self.UIGROUP, self.TEACHER_LIST)
    self:ApplyTeacherList()
  elseif szWnd == self.FIND_STUDENT_PAGE_BUTTON or szWnd == self.APPLY_STUDENT_BUTTON then
    Lst_Clear(self.UIGROUP, self.STUDENT_LIST)
    self:ApplyStudentList()
  elseif szWnd == self.BTN_FIRE_STUDENT then
    local nIndex = Lst_GetCurKey(self.UIGROUP, self.MY_STUDENT_LIST)
    if self.m_tMyStudentList[nIndex] and self.m_tMyStudentList[nIndex].szName ~= "" then
      local szStudentName = self.m_tMyStudentList[nIndex].szName
      -- me.CallServerScript({ "RelationCmd", "DelRelation_C2S", szStudentName, Player.emKPLAYERRELATION_TYPE_TRAINING, 1 });
      me.CallServerScript({ "RelationCmd", "DelTrainingStudent", szStudentName })
    else
      me.Msg("请选择你要开除的徒弟。")
    end
  elseif szWnd == self.TALK_TEACHER_BUTTON then
    local nKey = Lst_GetCurKey(self.UIGROUP, self.TEACHER_LIST)
    if self.m_tbTeacherList[nKey] then
      me.TrainingRequest(1, self.m_tbTeacherList[nKey].szName)
    end
  elseif szWnd == self.TALK_STUDENT_BUTTON then
    local nKey = Lst_GetCurKey(self.UIGROUP, self.STUDENT_LIST)
    if self.m_tbStudentList[nKey] then
      me.TrainingRequest(2, self.m_tbStudentList[nKey].szName)
    end
  end
end

function uiTeacher:OnListRClick(szWnd, nKey)
  --	if szWnd == self.TEACHER_LIST and self.m_tbTeacherList[nKey] then
  --		DisplayPopupMenu(self.UIGROUP, szWnd, 1, nKey, "申请拜师", 1);
  --	elseif szWnd == self.STUDENT_LIST and self.m_tbStudentList[nKey] then
  --		DisplayPopupMenu(self.UIGROUP, szWnd, 1, nKey, "申请收徒", 1);
  --	end
end

function uiTeacher:OnMenuItemSelected(szWnd, nItemId, nKey)
  if szWnd == self.TEACHER_LIST and nItemId == 1 and self.m_tbTeacherList[nKey] then
    me.TrainingRequest(1, self.m_tbTeacherList[nKey].szName)
  elseif szWnd == self.STUDENT_LIST and nItemId == 1 and self.m_tbStudentList[nKey] then
    me.TrainingRequest(2, self.m_tbStudentList[nKey].szName)
  end
end

function uiTeacher:OnChgTeacherOption(nEnable)
  local nCan, szMsg = self:CanBeStudent()
  if nCan == 0 then
    me.Msg(szMsg)
    return
  end

  Btn_Check(self.UIGROUP, self.GET_TEACHER_BUTTON, nEnable)
  me.SetTrainingOption(1, nEnable)
  me.RequestTrainingOption()
end

function uiTeacher:OnChgStudentOption(nEnable)
  local nCan, szMsg = self:CanBeTeacher()
  if nCan == 0 then
    me.Msg(szMsg)
    return
  end
  Btn_Check(self.UIGROUP, self.GET_STUDENT_BUTTON, nEnable)
  me.SetTrainingOption(0, nEnable)
  me.RequestTrainingOption()
end

-- 申请寻找的师傅列表
function uiTeacher:ApplyTeacherList()
  if me.nLevel < 20 then
    me.Msg("你的等级还不满20级，不能拜师")
    return
  end
  if me.nLevel >= 60 then
    me.Msg("你的等级已经超过了60级，不能再拜师")
    return
  end
  if self.m_nTeacherCount > 0 then
    me.Msg("你已经有师傅了，不能再拜师")
    return
  end

  self:RefreshTraining()
  me.SearchTraining(1)
end

-- 申请寻找的徒弟列表
function uiTeacher:ApplyStudentList()
  if me.nLevel < 60 then
    me.Msg("你等级不足60级，暂时不能接受弟子")
    return
  end
  if self.m_nCurStudentCount > 3 then
    me.Msg("你已经有了3个弟子，不能再接受弟子")
    return
  end

  self:RefreshTraining()
  me.SearchTraining(0)
end

-- 更新我的师傅信息
function uiTeacher:UpdateMyTeacherInfo()
  Txt_SetTxt(self.UIGROUP, self.TEXT_TEACHER_NAME, self.szTxtTeacherName)
  Txt_SetTxt(self.UIGROUP, self.TEXT_TEACHER_LEVEL, self.szTxtTeacherLevel)
  -- Txt_SetTxt(self.UIGROUP, self.TEXT_FINISH_CHUANGONG, self.szTxtFinChuanGong);

  self.m_tbTraining = me.Relation_GetTrainingRelation()

  for i = 1, #self.m_tbTraining do
    if self.m_tbTraining[i].nRole == 1 and self.m_tbTraining[i].nType == Player.emKPLAYERRELATION_TYPE_TRAINING then
      Txt_SetTxt(self.UIGROUP, self.TEXT_TEACHER_NAME, self.szTxtTeacherName .. self.m_tbTraining[i].szPlayer)
      Txt_SetTxt(self.UIGROUP, self.TEXT_TEACHER_LEVEL, self.szTxtTeacherName .. self.m_tbTraining[i].nLevel .. "级")

      --			local nChuanGongCount = me.GetTask(Relation.TASK_GROUP, Relation.TASK_ID_SHITU_CHUANGONG_COUNT);
      --			if nChuanGongCount then
      --				Txt_SetTxt(self.UIGROUP, self.TEXT_FINISH_CHUANGONG,
      --					self.szTxtFinChuanGong..nChuanGongCount.."/"..Relation.nMax_ChuanGong_Time);
      --			end
    end
  end
end

-- 更新师徒成就
function uiTeacher:UpdateAchevementInfo(tbAchievement)
  -- 只有在存在师徒关系，并且当前身份是弟子的情况下才能查看师徒成就
  if self.m_nTeacherCount <= 0 then
    return
  end

  if not tbAchievement then
    return
  end

  local tbConstAchievement = {}
  local tbChoseAchievement = {}
  local tbOutAchievement = {}

  local tbInfo = {}
  for i, tbOneAchievement in ipairs(tbAchievement) do
    local tbTemp = Achievement_ST.tbAchievementInfo[tbOneAchievement.nAchievementId]
    if not tbTemp then
      break
    end
    local szInfo = tbTemp.szAchievement
    if tbOneAchievement.bAchieve == 1 then
      szInfo = szInfo .. "<color=green>(已完成)<color>"
    else
      szInfo = szInfo .. "<color=red>(未完成)<color>"
    end

    if not tbInfo[tbTemp.szType] then
      tbInfo[tbTemp.szType] = {}
    end
    table.insert(tbInfo[tbTemp.szType], szInfo)
  end

  Lst_Clear(self.UIGROUP, self.ACHIEVEMENT_INFO)

  local nIndex = 1
  for szType, tbSpeAchievement in pairs(tbInfo) do
    Lst_SetCell(self.UIGROUP, self.ACHIEVEMENT_INFO, nIndex, 0, "                       " .. "<color=yellow>" .. szType .. "<color>")
    nIndex = nIndex + 1
    for _, szAchievementInfo in ipairs(tbSpeAchievement) do
      Lst_SetCell(self.UIGROUP, self.ACHIEVEMENT_INFO, nIndex, 0, szAchievementInfo)
      nIndex = nIndex + 1
    end
  end
end

-- 更新目前未出师徒弟列表
function uiTeacher:UpdateMyStudentList()
  Lst_Clear(self.UIGROUP, self.MY_STUDENT_LIST)
  self.m_tbTraining = me.Relation_GetTrainingRelation()
  for i = 1, #self.m_tbTraining do
    if (self.m_tbTraining[i].nRole == 0) and (self.m_tbTraining[i].nType == Player.emKPLAYERRELATION_TYPE_TRAINING) then
      local tbPlayer = {}
      tbPlayer.szName = self.m_tbTraining[i].szPlayer
      tbPlayer.nLevel = self.m_tbTraining[i].nLevel
      table.insert(self.m_tMyStudentList, tbPlayer)
      Lst_SetCell(self.UIGROUP, self.MY_STUDENT_LIST, i, 0, tbPlayer.szName)
      Lst_SetCell(self.UIGROUP, self.MY_STUDENT_LIST, i, 1, tbPlayer.nLevel .. "级")
    end
  end
end

-- 更新师傅列表
function uiTeacher:UpdateTeacherList(nPlayerId, szName, nSex, nLevel, nFaction, nHisStudentCount, nCurStudentCount, nAllStudentCount)
  self.m_tbTeacherList[nPlayerId] = {}
  self.m_tbTeacherList[nPlayerId].szName = szName
  self.m_tbTeacherList[nPlayerId].nSex = nSex
  self.m_tbTeacherList[nPlayerId].nLevel = nLevel
  self.m_tbTeacherList[nPlayerId].nFaction = nFaction
  self.m_tbTeacherList[nPlayerId].szTong = szTong
  self.m_tbTeacherList[nPlayerId].nHisStudentCount = nHisStudentCount
  self.m_tbTeacherList[nPlayerId].nCurStudentCount = nCurStudentCount
  self.m_tbTeacherList[nPlayerId].nAllStudentCount = nAllStudentCount
  self:LstAddLine(self.TEACHER_LIST, nPlayerId, self.m_tbTeacherList[nPlayerId])
end

-- 更新徒弟列表
function uiTeacher:UpdateStudentList(nPlayerId, szName, nSex, nLevel, nFaction, szTong)
  self.m_tbStudentList[nPlayerId] = {}
  self.m_tbStudentList[nPlayerId].szName = szName
  self.m_tbStudentList[nPlayerId].nSex = nSex
  self.m_tbStudentList[nPlayerId].nLevel = nLevel
  self.m_tbStudentList[nPlayerId].nFaction = nFaction
  self.m_tbStudentList[nPlayerId].szTong = szTong
  self:LstAddLine(self.STUDENT_LIST, nPlayerId, self.m_tbStudentList[nPlayerId])
end

function uiTeacher:LstAddLine(szWnd, nIndex, tbData)
  Lst_SetCell(self.UIGROUP, szWnd, nIndex, 0, tbData.szName)
  Lst_SetCell(self.UIGROUP, szWnd, nIndex, 1, Player.SEX[tbData.nSex])
  Lst_SetCell(self.UIGROUP, szWnd, nIndex, 2, tbData.nLevel)
  Lst_SetCell(self.UIGROUP, szWnd, nIndex, 3, Player:GetFactionRouteName(tbData.nFaction))
  if szWnd == self.TEACHER_LIST then
    local szBuffer = tbData.nCurStudentCount .. "/" .. tbData.nHisStudentCount
    Lst_SetCell(self.UIGROUP, szWnd, nIndex, 4, szBuffer)
  else
    Lst_SetCell(self.UIGROUP, szWnd, nIndex, 4, tbData.szTong)
  end
end

---- 更新我要收徒和我要拜师2个按钮状态
--function uiTeacher:UpdateOption(nTeacher, nStudent)
--	if me.nLevel >= 80 then
--		nTeacher = 0;
--	end
--	Btn_Check(self.UIGROUP, self.GET_TEACHER_BUTTON, nTeacher);
--	Btn_Check(self.UIGROUP, self.GET_STUDENT_BUTTON, nStudent);
--end

function uiTeacher:ApplyForTeacher(szPlayer)
  local tbMsg = {}
  tbMsg.nOptCount = 2
  tbMsg.tbOptTitle = { "不同意", "同意" }
  function tbMsg:Callback(nOptIndex, szPlayer)
    me.CallServerScript({ "RelationCmd", "TrainingResponse_C2S", 1, szPlayer, nOptIndex - 1 })
  end

  tbMsg.szMsg = szPlayer .. "希望拜你为师，"

  local tbData = me.Relation_GetTrainingRelation()
  local nStudentCount = 0
  if tbData then
    for _, tbPlayer in ipairs(tbData) do
      if tbPlayer.nRole == 0 then -- 0 是徒弟
        nStudentCount = nStudentCount + 1
      end
    end
  end

  tbMsg.szMsg = tbMsg.szMsg .. "您是否同意？"
  --if nStudentCount >= 2 then
  --	tbMsg.szMsg = tbMsg.szMsg.."您累计弟子数已超过2名，如果您同意，将收取您10000两银子，您是否同意？";
  --else
  --end

  tbMsgInfo:AddMsg(tbMsg.szMsg, tbMsg, szPlayer)
end

function uiTeacher:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_TEACHER_LIST, self.UpdateTeacherList },
    { UiNotify.emCOREEVENT_SYNC_STUDENT_LIST, self.UpdateStudentList },
    { UiNotify.emCOREEVENT_SYNC_TRAINING_OPTION, self.UpdateOption },
    { UiNotify.emCOREEVENT_SYNC_RELATION_LIST, self.RefreshTraining },
    --		{ UiNotify.emCOREEVENT_RELATION_UPDATEPANEL,		self.RefreshTraining },
    { UiNotify.emCOREEVENT_DELETE_RELATION, self.UpdateMyStudentList },
    { UiNotify.emCOREEVENT_TRAINING_APPLYFORTEACHER, self.ApplyForTeacher },
    { UiNotify.emCOREEVENT_SYNC_ACHIEVEMENTINFO, self.UpdateAchevementInfo },
  }
  return tbRegEvent
end
