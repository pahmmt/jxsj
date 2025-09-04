-- 文件名　：jxsjkeju.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-11-01 09:44:50
-- 功能说明：剑侠世界科举考试

local uiKeju = Ui:GetClass("jxsjkeju")
local JxsjKeju = SpecialEvent.JxsjKeju

uiKeju.TxtEx_Question = "TxtEx_Question"
uiKeju.Btn_Select = "Btn_Select"
uiKeju.Img_Select = "Img_Select"
uiKeju.BtnClose = "BtnClose"
uiKeju.Txt_Title = "Txt_Title"
uiKeju.Btn_ChanceWrong = "Btn_ChanceWrong"
uiKeju.Btn_ChanceRight = "Btn_ChanceRight"
uiKeju.TxtEx_GradeInfo = "TxtEx_GradeInfo"
uiKeju.Txt_Time = "Txt_Time"
uiKeju.Btn_Add = "Btn_right"
uiKeju.Btn_Dec = "Btn_left"
uiKeju.Img_Result = "Img_Result"

uiKeju.szBtnPic = "\\image\\ui\\002a\\JxsjKeju\\btn_keju.spr"
uiKeju.tbType = { "科举阶段：乡试", "科举阶段：殿试" }
uiKeju.tbQuestionEg = { "例题", "剑侠世界是那一年正式开始对外公测的？", "2008年", "2009年", "2010年", "2007年" }
uiKeju.tbTitleAnswer = { "A、", "B、", "C、", "D、" }
uiKeju.tbRegisterId = {}

uiKeju.tbQuestion = {} --原本的选项
uiKeju.tbQuestionEx = {} --打乱的选项
uiKeju.tbWrongAnswer = {} --错误的答案
uiKeju.tbGradeInfo = {} --答题详细信息
uiKeju.nJourNum = 0 --流水号
uiKeju.nTime = 0 --倒计时时间
uiKeju.nQuestionType = 1 --答题类型
uiKeju.nPageNum = 1 --页数
uiKeju.nMaxPageNum = 1 --最大页数
uiKeju.nTimerId = 0 --倒计时timer
uiKeju.nSelectAnswerId = 0 --选择答案
uiKeju.nWeeklyGrade = 0 --周积分
uiKeju.nDayGrade = 0 --当前积分
uiKeju.nAllCount = 0 --当前顺序
uiKeju.nTimerId = 0 --倒计时timer

--玩家进入游戏事件（注册按钮闪动事件）
function uiKeju:OnEnterGame()
  --注册每分钟timer到点了开打btn
  self.nBtnTimerId = Timer:Register(60 * Env.GAME_FPS, self.RegisterBtn, self)
  --活动期间要打开btn
  local nWeek = tonumber(GetLocalDate("%w"))
  local nHour = tonumber(GetLocalDate("%H%M"))
  local nDate = tonumber(GetLocalDate("%Y%m%d"))
  local nType = JxsjKeju.tbEventWeeklyType[nWeek]
  for i, tb in ipairs(JxsjKeju.tbReadyTime) do
    if (1 == nType and (i == 1 or i == 3)) or (2 == nType and i == 2) then
      if nHour >= tb[1] and nHour < JxsjKeju.tbEndTime[i] then
        local nRegisterId = Ui(Ui.UI_BTNMSG):RegisterOpenBtn(self.szBtnPic, [[me.CallServerScript({"ApplyTransfer_Keju"})]], 1)
        if nRegisterId > 0 then
          self.tbRegisterId[nRegisterId] = 1
          self.nCloseBtnTimerId = Timer:Register((Lib:GetDate2Time(nDate * 10000 + JxsjKeju.tbEndTime[i]) - Lib:GetDate2Time(nDate * 10000 + nHour)) * Env.GAME_FPS, self.RegisterCloseBtn, self, nRegisterId)
          return
        end
      end
    end
  end
end

--玩家退出事件
function uiKeju:OnLeaveGame()
  if self.tbRegisterId then
    for nRegisterId, _ in pairs(self.tbRegisterId) do
      Ui(Ui.UI_BTNMSG):UnRegisterOpenBtn(nRegisterId)
    end
    self.tbRegisterId = {}
  end

  if self.nBtnTimerId then
    Timer:Close(self.nBtnTimerId)
    self.nBtnTimerId = nil
  end

  if self.nCloseBtnTimerId then
    Timer:Close(self.nCloseBtnTimerId)
    self.nCloseBtnTimerId = nil
  end
end

function uiKeju:RegisterBtn()
  local nWeek = tonumber(GetLocalDate("%w"))
  local nHour = tonumber(GetLocalDate("%H%M"))
  local nDate = tonumber(GetLocalDate("%Y%m%d"))
  local nType = JxsjKeju.tbEventWeeklyType[nWeek]
  for i, tb in ipairs(JxsjKeju.tbReadyTime) do
    if (1 == nType and (i == 1 or i == 3)) or (2 == nType and i == 2) then
      if nHour == tb[1] then
        local nRegisterId = Ui(Ui.UI_BTNMSG):RegisterOpenBtn(self.szBtnPic, [[me.CallServerScript({"ApplyTransfer_Keju"})]], 1)
        if nRegisterId > 0 then
          self.tbRegisterId[nRegisterId] = 1
          self.nCloseBtnTimerId = Timer:Register((Lib:GetDate2Time(nDate * 10000 + JxsjKeju.tbEndTime[i]) - Lib:GetDate2Time(nDate * 10000 + nHour)) * Env.GAME_FPS, self.RegisterCloseBtn, self, nRegisterId)
          return
        end
      end
    end
  end
  return
end

function uiKeju:RegisterCloseBtn(nRegisterId)
  Ui(Ui.UI_BTNMSG):UnRegisterOpenBtn(nRegisterId)
  self.tbRegisterId[nRegisterId] = nil
end

function uiKeju:OnOpen(nType, nTimeEx, tbQuestion, nJourNum, nAllCount, bFinish, nDayGrade, nWeeklyGrade, tbGradeInfo)
  self.nQuestionType = nType
  local bDisable = 0
  if nTimeEx and tbQuestion then
    self.tbQuestion = tbQuestion
    self:SmashQuesetion()
    self.nJourNum = nJourNum
    self.nTime = nTimeEx
    self.nAllCount = nAllCount or 0
    self.nTimerId = Timer:Register(Env.GAME_FPS, self.UpdateTimer, self)
    self.nDayGrade = nDayGrade
    self.nWeeklyGrade = nWeeklyGrade
    self.tbGradeInfo = tbGradeInfo
    self.nMaxPageNum = math.ceil(#tbGradeInfo / 5)
    bDisable = bFinish
  else
    self.tbQuestion = {} --原本的选项
    self.tbQuestionEx = {} --打乱的选项
    self.nJourNum = 0
    self.nTime = 0 --倒计时时间
    self.nAllCount = 0 --当前顺序
    self.nTimerId = 0 --倒计时timer
    self.nWeeklyGrade = 0 --周积分
    self.nDayGrade = 0 --当前积分
    self.nMaxPageNum = 1 --最大页数
    self.tbGradeInfo = {} --答题详细信息
  end
  self.nPageNum = 1 --页数
  self.tbWrongAnswer = {} --错误的答案
  self:Update(bDisable)
end

--更新界面
function uiKeju:Update(bDisable)
  --没有题目时使用例题
  if #self.tbQuestionEx == 0 then
    self.tbQuestionEx = self.tbQuestionEg
  end
  --类型不对，直接关闭界面
  if not self.tbType[self.nQuestionType] then
    UiManager:CloseWindow(self.UIGROUP)
  end
  --设置考试类型
  Txt_SetTxt(self.UIGROUP, self.Txt_Title, self.tbType[self.nQuestionType])

  --更新题目
  local nDoubleGradeNum = me.GetTask(JxsjKeju.nTaskGroup, JxsjKeju.nDoubleGradeNum)
  local nDoubleStateDate = math.floor(nDoubleGradeNum / 100)
  local nJourNumDouble = math.fmod(nDoubleGradeNum, 100)

  if nDoubleStateDate == tonumber(GetLocalDate("%y%m%d%H")) and nJourNumDouble == self.nJourNum then
    TxtEx_SetText(self.UIGROUP, self.TxtEx_Question, string.format("题目类型：<color=239,180,52>%s<color>（%s/%s）：<color=green>【本题获得双倍积分】<color>\n%s", self.tbQuestionEx[1], self.nAllCount, JxsjKeju.tbQuestionCountPre[self.nQuestionType], self.tbQuestionEx[2]))
  else
    TxtEx_SetText(self.UIGROUP, self.TxtEx_Question, string.format("题目类型：<color=239,180,52>%s<color>（%s/%s）：\n%s", self.tbQuestionEx[1], self.nAllCount, JxsjKeju.tbQuestionCountPre[self.nQuestionType], self.tbQuestionEx[2]))
  end

  --更新选项
  for i = 1, 4 do
    if self.tbQuestionEx[i + 2] ~= "" then
      local szAnswerTxt = self.tbQuestionEx[i + 2]
      if self.nJourNum <= 0 or bDisable == 1 then
        Wnd_SetEnable(self.UIGROUP, self.Btn_Select .. i, 0)
        Img_SetFrame(self.UIGROUP, self.Btn_Select .. i, 2)
      else
        Wnd_SetEnable(self.UIGROUP, self.Btn_Select .. i, 1)
        Img_SetFrame(self.UIGROUP, self.Btn_Select .. i, 0)
      end
      if self.tbWrongAnswer[i] == 1 then
        szAnswerTxt = string.format("<color=red>%s【错误】<color>", szAnswerTxt)
      end
      Wnd_Show(self.UIGROUP, self.Btn_Select .. i)
      Btn_SetTxt(self.UIGROUP, self.Btn_Select .. i, self.tbTitleAnswer[i] .. szAnswerTxt)
    else
      Wnd_Hide(self.UIGROUP, self.Btn_Select .. i)
    end
    Img_SetFrame(self.UIGROUP, self.Img_Select .. i, 1)
  end

  --更新双倍积分和选择两个错误答案
  self:UpdateDGAndS2W(bDisable)

  --更新积分信息
  self:UpdateGradeList()

  --倒计时信息
  if self.nTime <= 0 then
    Txt_SetTxt(self.UIGROUP, self.Txt_Time, "<color=red>科举考试即将开始，请保持界面打开状态<color>")
  else
    Txt_SetTxt(self.UIGROUP, self.Txt_Time, string.format("答题<color=red>剩余时间%s秒<color>" .. self:GetAteendInfo(), self.nTime))
  end

  --结果图标隐藏
  Wnd_Hide(self.UIGROUP, self.Img_Result)
end

--更新倒计时
function uiKeju:UpdateTimer()
  self.nTime = self.nTime - 1
  if self.nTime <= 0 then
    return 0
  end
  Txt_SetTxt(self.UIGROUP, self.Txt_Time, string.format("答题<color=red>剩余时间%s秒<color>" .. self:GetAteendInfo(), self.nTime))
  return
end

--更新题目
function uiKeju:UpdateQuesetion(nType, tbQuestion, nJourNum, tbGradeInfo, nLastQuestionResult, nAllCount, nDayGrade, nWeeklyGrade)
  self.nQuestionType = nType
  self.tbQuestion = tbQuestion
  self:SmashQuesetion()
  self.nJourNum = nJourNum
  self.tbGradeInfo = tbGradeInfo
  self.nMaxPageNum = math.ceil(#tbGradeInfo / 5)
  self.nTime = 30
  self.tbWrongAnswer = {}
  self.nSelectAnswerId = 0
  self.nDayGrade = nDayGrade or 0
  self.nWeeklyGrade = nWeeklyGrade or 0
  self.nAllCount = nAllCount or 0
  self:Update()
  if self.nTimerId > 0 and Timer:GetRestTime(self.nTimerId) > 0 then
    Timer:Close(self.nTimerId)
  end
  self.nTimerId = Timer:Register(Env.GAME_FPS, self.UpdateTimer, self)
  return 0
end

--打乱题目答案
function uiKeju:SmashQuesetion()
  local tb = { 3, 4, 5, 6 }
  Lib:SmashTable(tb)
  self.tbQuestionEx = { self.tbQuestion[1], self.tbQuestion[2], self.tbQuestion[tb[1]], self.tbQuestion[tb[2]], self.tbQuestion[tb[3]], self.tbQuestion[tb[4]], tb }
end

function uiKeju:OnButtonClick(szWnd, nParam)
  if szWnd == self.BtnClose then -- 关闭按钮
    local tbMsg = {}
    tbMsg.szMsg = "您确定要离开，停止答题？"
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex)
      if nOptIndex == 2 then
        UiManager:CloseWindow(Ui.UI_JXSJKEJU)
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
  elseif szWnd == self.Btn_ChanceRight then
    self:DoubleGrade()
  elseif szWnd == self.Btn_ChanceWrong then
    self:Select2Wrong()
  elseif szWnd == self.Btn_Dec then
    local nOldNum = self.nPageNum
    self.nPageNum = self.nPageNum - 1
    if self.nPageNum <= 0 then
      self.nPageNum = 1
    end
    if nOldNum ~= self.nPageNum then
      self:UpdateGradeList()
    end
  elseif szWnd == self.Btn_Add then
    local nOldNum = self.nPageNum
    self.nPageNum = math.min(self.nPageNum + 1, self.nMaxPageNum)
    if nOldNum ~= self.nPageNum then
      self:UpdateGradeList()
    end
  else
    for i = 1, 4 do
      local szSelectBtn = self.Btn_Select .. i
      if szSelectBtn == szWnd then
        self:SelectAnswer(i)
      end
    end
  end
end

--更新积分页面和左右按钮
function uiKeju:UpdateGradeList()
  --排名信息
  local szExMsg = ""
  for i = (self.nPageNum - 1) * 5 + 1, self.nPageNum * 5 do
    if self.tbGradeInfo[i] then
      szExMsg = szExMsg .. self.tbGradeInfo[i][1] .. "  " .. self.tbGradeInfo[i][2] .. "\n"
    end
  end
  if szExMsg == "" then
    szExMsg = "此处为本次答题的具体详细信息及相关说明"
  end
  TxtEx_SetText(self.UIGROUP, self.TxtEx_GradeInfo, szExMsg)

  --翻页功能
  if self.nPageNum >= self.nMaxPageNum then
    Wnd_SetEnable(self.UIGROUP, self.Btn_Add, 0)
    Wnd_Hide(self.UIGROUP, self.Btn_Add)
  else
    Wnd_SetEnable(self.UIGROUP, self.Btn_Add, 1)
    Wnd_Show(self.UIGROUP, self.Btn_Add)
  end
  if self.nPageNum <= 1 then
    Wnd_SetEnable(self.UIGROUP, self.Btn_Dec, 0)
    Wnd_Hide(self.UIGROUP, self.Btn_Dec)
  else
    Wnd_SetEnable(self.UIGROUP, self.Btn_Dec, 1)
    Wnd_Show(self.UIGROUP, self.Btn_Dec)
  end
end

--更新双倍积分和去掉2个错误答案
function uiKeju:UpdateDGAndS2W(bDisable)
  --去掉2个错误答案次数
  local nTime = tonumber(GetLocalDate("%y%m%d"))
  local nChanceWrong = me.GetTask(JxsjKeju.nTaskGroup, JxsjKeju.nSelect2Wrong)
  local nChanceWrongDate = math.floor(nChanceWrong / 100)
  local nChanceWrongCount = math.fmod(nChanceWrong, 100)
  if nTime ~= nChanceWrongDate then
    nChanceWrongCount = 0
  end
  --双倍积分次数
  local nDoubleGradeNum = me.GetTask(JxsjKeju.nTaskGroup, JxsjKeju.nDoubleGrade)
  local nDoubleGradeDate = math.floor(nDoubleGradeNum / 100)
  local nDoubleGradeCount = math.fmod(nDoubleGradeNum, 100)
  if nTime ~= nDoubleGradeDate then
    nDoubleGradeCount = 0
  end
  local szSelectWrong = string.format("去掉两个错误答案（%s/3）", nChanceWrongCount)
  local szDoubleGrade = string.format("双倍积分（%s/3）", nDoubleGradeCount)
  Btn_SetTxt(self.UIGROUP, self.Btn_ChanceWrong, szSelectWrong)
  Btn_SetTxt(self.UIGROUP, self.Btn_ChanceRight, szDoubleGrade)
  if nDoubleGradeCount >= JxsjKeju.nDoubleGradeMaxNumPer or bDisable == 1 then
    Wnd_SetEnable(self.UIGROUP, self.Btn_ChanceRight, 0)
  else
    Wnd_SetEnable(self.UIGROUP, self.Btn_ChanceRight, 1)
  end
  if nChanceWrongCount >= JxsjKeju.nSelect2WrongMaxNumPer or bDisable == 1 then
    Wnd_SetEnable(self.UIGROUP, self.Btn_ChanceWrong, 0)
  else
    Wnd_SetEnable(self.UIGROUP, self.Btn_ChanceWrong, 1)
  end
end

--去掉2个错误答案
function uiKeju:Select2Wrong()
  me.CallServerScript({ "ApplySelect2Wrong_Keju" })
end

function uiKeju:Select2Wrong_C(nNum1, nNum2, nCount)
  local tbSmashTB = self.tbQuestionEx[7]
  for i, n in ipairs(tbSmashTB) do
    if n == nNum1 + 2 then
      self.tbWrongAnswer[i] = 1
    end
    if n == nNum2 + 2 then
      self.tbWrongAnswer[i] = 1
    end
  end
  self:Update()

  --次数变量可能不对，这里需要重置，同时禁止掉按钮
  local szSelectWrong = string.format("去掉两个错误答案（%s/3）", nCount)
  Btn_SetTxt(self.UIGROUP, self.Btn_ChanceWrong, szSelectWrong)
  Wnd_SetEnable(self.UIGROUP, self.Btn_ChanceWrong, 0)
end

--双倍积分
function uiKeju:DoubleGrade()
  me.CallServerScript({ "ApplyDoubleGrade_Keju" })
end

function uiKeju:DoubleGrade_C(nCount)
  TxtEx_SetText(self.UIGROUP, self.TxtEx_Question, string.format("题目类型：<color=239,180,52>%s<color>（%s/%s）：<color=green>【本题获得双倍积分】<color>\n%s", self.tbQuestionEx[1], self.nAllCount, JxsjKeju.tbQuestionCountPre[self.nQuestionType], self.tbQuestionEx[2]))

  --次数变量可能不对，这里需要重置，同时禁止掉按钮
  local szDoubleGrade = string.format("双倍积分（%s/3）", nCount)
  Btn_SetTxt(self.UIGROUP, self.Btn_ChanceRight, szDoubleGrade)
  Wnd_SetEnable(self.UIGROUP, self.Btn_ChanceRight, 0)
end

function uiKeju:GetAteendInfo()
  if self.nQuestionType == 1 then
    return string.format("  本周乡试累计积分：<color=yellow>%s<color>  本场乡试积分：<color=yellow>%s<color>", self.nWeeklyGrade, self.nDayGrade)
  else
    return string.format("  本场殿试积分：<color=yellow>%s<color>", self.nDayGrade)
  end
end

--选择答案
function uiKeju:SelectAnswer(nId)
  if not self.tbQuestionEx[7] then
    return
  end
  local nIndex = self.tbQuestionEx[7][nId] - 2
  self.nSelectAnswerId = nId
  me.CallServerScript({ "ApplySelectAnswerId_Keju", nIndex })
  for i = 1, 4 do
    Wnd_SetEnable(self.UIGROUP, self.Btn_Select .. i, 0)
    Img_SetFrame(self.UIGROUP, self.Btn_Select .. i, 2)
  end
  Wnd_SetEnable(self.UIGROUP, self.Btn_ChanceRight, 0)
  Wnd_SetEnable(self.UIGROUP, self.Btn_ChanceWrong, 0)
  Img_SetFrame(self.UIGROUP, self.Btn_Select .. nId, 3)
end

function uiKeju:OnClose()
  me.SetTask(JxsjKeju.nTaskGroup, JxsjKeju.nOpenUiFalg, 0)
  if self.nTimerId > 0 and Timer:GetRestTime(self.nTimerId) > 0 then
    Timer:Close(self.nTimerId)
  end
end

function uiKeju:UpdateQuestionAnswer(nLastQuestionResult, bCloseUI)
  if self.nAllCount <= 0 then
    return
  end
  local nJourNum = math.floor(nLastQuestionResult / 100)
  local nFlag = math.fmod(nLastQuestionResult, 100)
  if self.nJourNum == nJourNum and nFlag == 1 then
    self:ShowResult(1, bCloseUI)
    me.Msg("恭喜你答对了。")
  else
    self:ShowResult(0, bCloseUI)
    me.Msg("很遗憾你答错了。")
  end
end

--显示答题结果
function uiKeju:ShowResult(nResult, bCloseUI)
  local szImgFile = "\\image\\ui\\002a\\jxsjkeju\\img_right.spr"
  if nResult == 0 then
    szImgFile = "\\image\\ui\\002a\\jxsjkeju\\img_wrong.spr"
  end
  Img_SetImage(self.UIGROUP, self.Img_Result, 1, szImgFile)
  Wnd_Show(self.UIGROUP, self.Img_Result)
  Img_PlayAnimation(self.UIGROUP, self.Img_Result, 0, 0, 0, -1)
  Timer:Register(Env.GAME_FPS, self.CloseShowResult, self, bCloseUI)
end

function uiKeju:CloseShowResult(bCloseUI)
  Wnd_Hide(self.UIGROUP, self.Img_Result)
  if bCloseUI then
    UiManager:CloseWindow(self.UIGROUP)
  end
  return 0
end

function uiKeju:OnMouseEnter(szWnd)
  if string.find(szWnd, self.Btn_Select) then
    Img_SetFrame(self.UIGROUP, szWnd, 3)
    local nId = string.sub(szWnd, 11, string.len(szWnd))
    Img_SetFrame(self.UIGROUP, self.Img_Select .. nId, 0)
  end
end

function uiKeju:OnMouseLeave(szWnd)
  if string.find(szWnd, self.Btn_Select) and Wnd_IsEnabled(self.UIGROUP, szWnd) == 1 then
    Img_SetFrame(self.UIGROUP, szWnd, 0)
    local nId = string.sub(szWnd, 11, string.len(szWnd))
    Img_SetFrame(self.UIGROUP, self.Img_Select .. nId, 1)
  end
end

function JxsjKeju:UpdateQuesetion_C(nType, tbQuestion, nJourNum, tbGradeInfo, nLastQuestionResult, nAllCount, nDayGrade, nWeeklyGrade)
  Ui(Ui.UI_JXSJKEJU):UpdateQuestionAnswer(nLastQuestionResult)
  Timer:Register(Env.GAME_FPS, Ui(Ui.UI_JXSJKEJU).UpdateQuesetion, Ui(Ui.UI_JXSJKEJU), nType, tbQuestion, nJourNum, tbGradeInfo, nLastQuestionResult, nAllCount, nDayGrade, nWeeklyGrade)
end

function JxsjKeju:EndQuesetion_C(nType, nLastQuestionResult, bMsg)
  if bMsg then
    Ui:ServerCall("UI_TASKTIPS", "Begin", "恭喜您已经打完今天所有题目了。")
  else
    if nType == 1 then
      Ui:ServerCall("UI_TASKTIPS", "Begin", "科举考试已经结束了，您可以到考官处领取奖励了。")
    elseif nType == 2 then
      Ui:ServerCall("UI_TASKTIPS", "Begin", "科举考试已经结束了，您可以到御题金榜处领取奖励了。")
    end
  end
  Ui(Ui.UI_JXSJKEJU):UpdateQuestionAnswer(nLastQuestionResult, 1)
end

function JxsjKeju:DoubleGrade_C(nCount)
  Ui(Ui.UI_JXSJKEJU):DoubleGrade_C(nCount)
end

function JxsjKeju:Select2Wrong_C(nNum1, nNum2, nCount)
  Ui(Ui.UI_JXSJKEJU):Select2Wrong_C(nNum1, nNum2, nCount)
end
