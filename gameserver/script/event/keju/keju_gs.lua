-- 文件名　：keju_gs.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-10-24 15:22:56
-- 功能说明：剑侠世界科举考试

if not MODULE_GAMESERVER then
  return
end

Require("\\script\\event\\keju\\keju_public.lua")

SpecialEvent.JxsjKeju = SpecialEvent.JxsjKeju or {}
local JxsjKeju = SpecialEvent.JxsjKeju

--参加活动
function JxsjKeju:AttendEvent(nType)
  me.AddWaitGetItemNum(1)
  GCExcute({ "SpecialEvent.JxsjKeju:AttendEvent_GC", nType, me.nId })
end

function JxsjKeju:AttendEvent_GS(nType, nId)
  local pPlayer = KPlayer.GetPlayerObjById(nId)
  if pPlayer then
    pPlayer.AddWaitGetItemNum(-1)

    pPlayer.SetTask(self.nTaskGroup, self.nAskJourNum, 0) --询问流水号置空
    pPlayer.SetTask(self.nTaskGroup, self.nAnswerJourNum, 0) --答题流水号置空
    pPlayer.SetTask(self.nTaskGroup, self.nSelect2WrongNum, 0) --双倍积分流水号置空
    pPlayer.SetTask(self.nTaskGroup, self.nDoubleGradeNum, 0) --选择两个错误答案的流水号置空

    local nDateNow = tonumber(GetLocalDate("%Y%m%d"))
    pPlayer.SetTask(self.nTaskGroup, self.nGradePre, 0) --基础积分置空
    pPlayer.SetTask(self.nTaskGroup, self.nGradeTime, 0) --时间积分置空
    pPlayer.SetTask(self.nTaskGroup, self.nAnswerTime, 0) --答题消耗时间置空
    pPlayer.SetTask(self.nTaskGroup, self.nGradeDate, nDateNow) --参加为当前时间

    --打开界面
    pPlayer.SetTask(self.nTaskGroup, self.nOpenUiFalg, 1) --打开ui界面置1
    pPlayer.CallClientScript({ "UiManager:OpenWindow", "UI_JXSJKEJU", nType })
    --活跃度
    SpecialEvent.ActiveGift:AddCounts(pPlayer, 50)
    StatLog:WriteStatLog("stat_info", "keju", "join", nId, nType)
  end
  self.tbAttendList[nId] = 1
end

--问答
function JxsjKeju:AskPlayerQuestion_GS(tbQuestion, nJourNum)
  self.tbQuestionDay[nJourNum] = tbQuestion
  self.nQuestionTime = GetTime() --当前题目时间戳
  self.nJourNum = nJourNum --当前题目号
  local tbQuestionEx = { tbQuestion[1], tbQuestion[3], tbQuestion[4], tbQuestion[5], tbQuestion[6], tbQuestion[7] }
  --计算排名
  self:SortWeekGrade(self.nQuestionType)

  local tbPlayerGradeList = {}
  for i = 1, 10 do
    local tb = self.tbJxsjKejuGrade[self.nQuestionType][i]
    if tb then
      local nPlayerId = KGCPlayer.GetPlayerIdByRoleId(tb[1])
      if nPlayerId then
        local szName = KGCPlayer.GetPlayerName(nPlayerId)
        if szName then
          table.insert(tbPlayerGradeList, { szName, tb[2] })
        end
      end
    end
  end
  for nPlayerId, _ in pairs(self.tbAttendList) do
    local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
    if pPlayer then
      if self:CheckIsNear(pPlayer) == 1 and self:CheckIsOver(pPlayer) == 0 and self:CheckIsOpenUi(pPlayer) == 1 then
        --当天的答题数目+1
        local nGradePre = pPlayer.GetTask(self.nTaskGroup, self.nGradePre)
        pPlayer.SetTask(self.nTaskGroup, self.nGradePre, nGradePre + 10000)
        --累计时间加30秒
        pPlayer.SetTask(self.nTaskGroup, self.nAnswerTime, pPlayer.GetTask(self.nTaskGroup, self.nAnswerTime) + self.nTimeAskS)
        --记录询问变量
        pPlayer.SetTask(self.nTaskGroup, self.nAskJourNum, tonumber(GetLocalDate("%m%d%H")) * 1000 + nJourNum)
        --当天成绩
        local nGradePreEx = math.fmod(nGradePre, 10000)
        local nAllCount = math.floor(nGradePre / 10000) + 1
        local nTimeGrade = pPlayer.GetTask(self.nTaskGroup, self.nGradeTime)
        --周成绩
        local nWeeklyGrade = pPlayer.GetTask(self.nTaskGroup, self.nWeeklyGrade)
        if self.nQuestionType == 2 then
          nAllCount = self.nJourNum
        end
        pPlayer.CallClientScript({
          "SpecialEvent.JxsjKeju:UpdateQuesetion_C",
          self.nQuestionType,
          tbQuestionEx,
          nJourNum,
          tbPlayerGradeList,
          pPlayer.GetTask(self.nTaskGroup, self.nAnswerJourNum),
          nAllCount,
          nGradePreEx + nTimeGrade,
          nWeeklyGrade,
        })
      elseif self:CheckIsOver(pPlayer) == 1 and self:CheckIsOpenUi(pPlayer) == 1 then
        pPlayer.CallClientScript({ "SpecialEvent.JxsjKeju:EndQuesetion_C", self.nQuestionType, pPlayer.GetTask(self.nTaskGroup, self.nAnswerJourNum), 1 })
      end
    end
  end
end

function JxsjKeju:OnReadyEvent_GS(nType, nIndex)
  --参加的人员初始化
  self.tbAttendList = {}
  --成绩单重置
  self.tbJxsjKejuGrade[nType] = {}
  self.tbJxsjKejuGradeEx = {}
  --初始化试题库
  self.tbQuestionDay = {}
  --考试类型
  self.nQuestionType = nType

  if #self.tbZhuoziNpcList > 0 then
    self:DeleteNpc()
  end

  if nIndex ~= 2 and nType == 1 then
    self:UpNpc()
  end
end

--开始活动，初始化题库等
function JxsjKeju:StartEvent_GS(nType)
  if nType == 1 then
    self:Msg2World2GS(4)
  else
    self:Msg2World2GS(5)
  end
end

--刷新考试npc
function JxsjKeju:UpNpc()
  for i, tb in ipairs(self.tbZhuoziPos) do
    if IsMapLoaded(tb[1]) == 1 then
      local pNpc = KNpc.Add2(self.nZhouziId, 50, -1, tb[1], tb[2], tb[3])
      if pNpc then
        table.insert(self.tbZhuoziNpcList, pNpc.dwId)
      end
    end
  end
end

--考试结束删掉npc
function JxsjKeju:DeleteNpc()
  for i, nNpcId in ipairs(self.tbZhuoziNpcList) do
    local pNpc = KNpc.GetById(nNpcId)
    if pNpc then
      pNpc.Delete()
    end
  end
  self.tbZhuoziNpcList = {}
end

--活动结束(这里需要同步殿试名单，防止出现分数一样的情况，导致领奖问题，以gc排序为准)
function JxsjKeju:EndEvent_GS(nType)
  for nPlayerId, _ in pairs(self.tbAttendList) do
    local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
    if pPlayer then
      if self:CheckIsNear(pPlayer) == 1 then
        local nGradePre = pPlayer.GetTask(self.nTaskGroup, self.nGradePre)
        local nGradeTime = pPlayer.GetTask(self.nTaskGroup, self.nGradeTime)
        local nGrade = math.fmod(nGradePre, 10000)
        local nCount = math.floor(nGrade / self.nPerQueGrade)
        if nType == 1 then
          pPlayer.Msg(string.format("您在本次乡试中答对%s题，乡试成绩为%s分，请前往乡试知贡举处领取奖励。", nCount, nGrade + nGradeTime))
        elseif nType == 2 then
          pPlayer.Msg(string.format("您在本次殿试中答对%s题，殿试成绩为%s分，请前往御题金榜处领取奖励。", nCount, nGrade + nGradeTime))
        end
        pPlayer.CallClientScript({ "SpecialEvent.JxsjKeju:EndQuesetion_C", nType, pPlayer.GetTask(self.nTaskGroup, self.nAnswerJourNum) })
      end
    end
  end

  --删除掉增加的桌子npc
  self:DeleteNpc()

  --loadbuff
  self:LoadBuffer()

  self:SortWeekGrade(nType)

  if nType == 1 and self.tbJxsjKejuGrade[1] and self.tbJxsjKejuGrade[1][1] then
    local nPlayerId = KGCPlayer.GetPlayerIdByRoleId(self.tbJxsjKejuGrade[1][1][1])
    if nPlayerId then
      local szName = KGCPlayer.GetPlayerName(nPlayerId)
      if szName then
        self:Msg2World2GS(0, string.format("本次乡试答题结束，恭喜【%s】荣登桂榜榜首！", szName))
      end
    end
  end

  --前三名广播
  if nType == 2 and self.tbJxsjKejuGrade[2] and self.tbJxsjKejuGrade[2][1] and self.tbJxsjKejuGrade[2][1][2] >= self.nMinAwardGradeType2 then
    local nPlayerId = KGCPlayer.GetPlayerIdByRoleId(self.tbJxsjKejuGrade[2][1][1])
    if nPlayerId then
      local szName = KGCPlayer.GetPlayerName(nPlayerId)
      if szName then
        self:Msg2World2GS(0, string.format("【%s】才高八斗，荣获殿试第一名，御赐状元及第！", szName))
        self:StartWelFare(szName) --殿试结束开启花车活动
      end
    end
  elseif nType == 2 and self.tbJxsjKejuGrade[2] and self.tbJxsjKejuGrade[2][1] and self.tbJxsjKejuGrade[2][1][2] < self.nMinAwardGradeType2 then
    self:Msg2World2GS(0, "今日殿试成绩不理想，皇上大怒，没有状元产生。")
    return
  end
  if nType == 2 and self.tbJxsjKejuGrade[2] and self.tbJxsjKejuGrade[2][2] and self.tbJxsjKejuGrade[2][1][2] >= self.nMinAwardGradeType2 then
    local nPlayerId = KGCPlayer.GetPlayerIdByRoleId(self.tbJxsjKejuGrade[2][2][1])
    if nPlayerId then
      local szName = KGCPlayer.GetPlayerName(nPlayerId)
      if szName then
        self:Msg2World2GS(0, string.format("【%s】七步成诗，荣获殿试第二名，御赐榜眼及第！", szName))
      end
    end
  end
  if nType == 2 and self.tbJxsjKejuGrade[2] and self.tbJxsjKejuGrade[2][3] and self.tbJxsjKejuGrade[2][1][2] >= self.nMinAwardGradeType2 then
    local nPlayerId = KGCPlayer.GetPlayerIdByRoleId(self.tbJxsjKejuGrade[2][3][1])
    if nPlayerId then
      local szName = KGCPlayer.GetPlayerName(nPlayerId)
      if szName then
        self:Msg2World2GS(0, string.format("【%s】学富五车，荣获殿试第三名，御赐探花及第！", szName))
      end
    end
  end
end

--活动提示
function JxsjKeju:Msg2World2GS(nNum, szWorldMsg)
  local tbMsg = {
    "本次的乡试科举即将开启，请各位秀才赶紧去参加科举考试。",
    "今日的殿试科举即将开启，请各位贡士赶紧去参加科举考试。",
    "今日的科举考试暂时关闭，敬请谅解。",
    "本次的乡试科举正式开启。请各位参加科举的秀才开始答题。",
    "今日的殿试科举正式开启，请各位参加科举的贡士开始答题。",
  }
  local szMsg = tbMsg[nNum]
  if szWorldMsg then
    szMsg = szWorldMsg
  end
  if not szMsg then
    return 0
  end
  KDialog.NewsMsg(0, Env.NEWSMSG_NORMAL, szMsg)
  KDialog.Msg2SubWorld(szMsg)
end

--单个人员同步成绩单
function JxsjKeju:GradeStatistics_GS(nType, nNum, szRoleId, nGrade)
  self.tbJxsjKejuGrade[nType] = self.tbJxsjKejuGrade[nType] or {}
  if nType == 1 and nNum ~= 1 then
    return
  end
  self.tbJxsjKejuGrade[nType][nNum] = { szRoleId, nGrade }
end

--启动gs后发现是在活动期间时候给gc要一次名单
function JxsjKeju:SynGradeList_GS(nJourNum, nQuestionType)
  if not nJourNum or not nQuestionType then
    return
  end
  self.nJourNum = nJourNum
  self.nQuestionType = nQuestionType
  --分数这里直接loadbuff
  self:LoadBuffer()
  self:SortWeekGrade(self.nQuestionType)
end

function JxsjKeju:SynGradeListEx_GS(tbAttendList)
  if not tbAttendList then
    return
  end
  Lib:MergeTable2(self.tbAttendList, tbAttendList)
end

--服务器启动事件
ServerEvent:RegisterServerStartFunc(SpecialEvent.JxsjKeju.LoadBuffer, SpecialEvent.JxsjKeju)

------------------------------------------------------------------------------------------
--c2s
------------------------------------------------------------------------------------------

--答题
function JxsjKeju:AnswerQuesetion(nId)
  --都不在活动期间，肯定无效了
  if self:CheckIsOpen(2) == 0 then
    return
  end
  --不再附近或者已经答题完毕的
  if self:CheckIsNear(me) == 0 or self:CheckIsOver(me) == 1 then
    return
  end
  --答题时间不在作答时间范围内，答案不做参考
  if GetTime() <= self.nQuestionTime or GetTime() >= self.nQuestionTime + self.nTimeAskS then
    return
  end
  --检查答和问的流水号必须为当前题目流水号
  if self:CheckQuestionIsRight() == 0 then
    return
  end
  --检查本题是第一次答题
  if self:CheckIsFirstAnswer() == 0 then
    return
  end
  --取当前题目
  local tbQuestion = self.tbQuestionDay[self.nJourNum]
  if not tbQuestion then
    return 0
  end
  if tbQuestion[2] == nId then
    --当前流水号的题目答题情况
    me.SetTask(self.nTaskGroup, self.nAnswerJourNum, self.nJourNum * 100 + 1)
    --时间积分计算
    local nTimeGrade = me.GetTask(self.nTaskGroup, self.nGradeTime)
    local nTimeAnswer = GetTime() - self.nQuestionTime
    local nTimeGradeCur = self.tbGradeAdd4Time[nTimeAnswer] or 0
    --双倍积分流水号一致表示本题用了双倍积分
    local nTimes = 1
    local nDoubleGradeNum = me.GetTask(self.nTaskGroup, self.nDoubleGradeNum)
    local nDoubleStateDate = math.floor(nDoubleGradeNum / 100)
    local nJourNumDouble = math.fmod(nDoubleGradeNum, 100)
    if nDoubleStateDate == tonumber(GetLocalDate("%y%m%d%H")) and nJourNumDouble == self.nJourNum then
      nTimes = 2
    end
    me.SetTask(self.nTaskGroup, self.nGradeTime, nTimeGrade + nTimeGradeCur * nTimes + (self.nPerQueGrade * (nTimes - 1))) --双倍积分也算到时间积分里面去
    --当天的答对数目+1
    local nGradePre = me.GetTask(self.nTaskGroup, self.nGradePre)
    local nGradePreEx = math.fmod(nGradePre, 10000)
    local nAllCount = math.floor(nGradePre / 10000)
    me.SetTask(self.nTaskGroup, self.nGradePre, nGradePre + self.nPerQueGrade)
    --周成绩累加
    local nWeeklyGrade = me.GetTask(self.nTaskGroup, self.nWeeklyGrade)
    me.SetTask(self.nTaskGroup, self.nWeeklyGrade, nWeeklyGrade + (self.nPerQueGrade + nTimeGradeCur) * nTimes)
    --累计时间计算
    local nUseTime = me.GetTask(self.nTaskGroup, self.nAnswerTime)
    me.SetTask(self.nTaskGroup, self.nAnswerTime, nUseTime - self.nTimeAskS + nTimeAnswer)
    --GC统计成绩
    GCExcute({ "SpecialEvent.JxsjKeju:GradeStatistics_GC", me.szRoleId, nGradePreEx + self.nPerQueGrade * nTimes + nTimeGrade + nTimeGradeCur * nTimes })
  else
    me.SetTask(self.nTaskGroup, self.nAnswerJourNum, self.nJourNum * 100 + 0)
  end

  --记录log
  local nGradePre = me.GetTask(self.nTaskGroup, self.nGradePre)
  local nTimeGrade = me.GetTask(self.nTaskGroup, self.nGradeTime)
  local nUseTime = me.GetTask(self.nTaskGroup, self.nAnswerTime)
  local nGradePreEx = math.fmod(nGradePre, 10000)
  local nAllCount = math.floor(nGradePre / 10000)
  local nSortNum = 0
  if self.nQuestionType == 1 and self.tbJxsjKejuGrade[1] and self.tbJxsjKejuGrade[1][1] == me.szRoleId then
    nSortNum = 1
  end
  if self.bLogFlag == 1 or (self.bLogFlag == 2 and nAllCount == self.tbQuestionCountPre[self.nQuestionType]) then
    StatLog:WriteStatLog("stat_info", "keju", "finish", me.nId, self.nQuestionType, nUseTime, math.floor(nGradePreEx / self.nPerQueGrade), nGradePreEx + nTimeGrade, self.tbJxsjKejuGradeEx[me.szRoleId] or nSortNum)
  end
end

--传送到指定考试地点
function JxsjKeju:Transfer2Pos(nMapId, nX, nY)
  if self:CheckIsOpen(1) == 0 then
    return
  end
  if GetMapType(me.nMapId) ~= "city" and GetMapType(me.nMapId) ~= "village" and GetMapType(me.nMapId) ~= "fight" then
    Dialog:Say("只能在各大新手村、城市及野外地图使用。")
    return
  end
  if not nMapId then
    local tbPos = {
      { "江津村", self.Transfer2Pos, self, 5, 1599, 3094 },
      { "云中镇", self.Transfer2Pos, self, 1, 1355, 3078 },
      { "永乐镇", self.Transfer2Pos, self, 3, 1591, 3201 },
      { "我再想想" },
    }
    if self.tbEventWeeklyType[tonumber(GetLocalDate("%w"))] == 2 then
      tbPos = {
        { "临安府", self.Transfer2Pos, self, 29, 1557, 3676 },
        { "扬州府", self.Transfer2Pos, self, 26, 1665, 3213 },
        { "我再想想" },
      }
    end
    Dialog:Say("科举考试开始了，这里是快捷通道可以快速传送到考试官员跟前。", tbPos)
    return
  end
  if 0 == me.nFightState then
    self:Transfer2PosEx(nMapId, nX, nY)
    return
  end
  local tbEvent = {
    Player.ProcessBreakEvent.emEVENT_MOVE,
    Player.ProcessBreakEvent.emEVENT_ATTACK,
    Player.ProcessBreakEvent.emEVENT_SITE,
    Player.ProcessBreakEvent.emEVENT_USEITEM,
    Player.ProcessBreakEvent.emEVENT_ARRANGEITEM,
    Player.ProcessBreakEvent.emEVENT_DROPITEM,
    Player.ProcessBreakEvent.emEVENT_SENDMAIL,
    Player.ProcessBreakEvent.emEVENT_TRADE,
    Player.ProcessBreakEvent.emEVENT_CHANGEFIGHTSTATE,
    Player.ProcessBreakEvent.emEVENT_CLIENTCOMMAND,
    Player.ProcessBreakEvent.emEVENT_LOGOUT,
    Player.ProcessBreakEvent.emEVENT_DEATH,
    Player.ProcessBreakEvent.emEVENT_ATTACKED,
  }
  GeneralProcess:StartProcess("正在传送...", 10 * Env.GAME_FPS, { self.Transfer2PosEx, self, nMapId, nX, nY }, nil, tbEvent)
end

function JxsjKeju:Transfer2PosEx(nMapId, nX, nY)
  local tbMap = GetLocalServerMapInfo()
  local nServerId = tbMap[nMapId]
  if not nServerId then
    me.Msg("前方道路不通!")
    return 0
  end
  local tbServerPlayerCount = GetServerPlayerCount()
  if tbServerPlayerCount[nServerId] and tbServerPlayerCount[nServerId] > KPlayer.GetMaxPlayerCount() then
    me.Msg("前方人满为患。!")
    return 0
  end
  me.NewWorld(nMapId, nX, nY)
end

--去掉2个错误答案
function JxsjKeju:Select2Wrong()
  --都不在活动期间，肯定无效了
  if self:CheckIsOpen(2) == 0 then
    return
  end

  --不再附近或者已经答题完毕的
  if self:CheckIsNear(me) == 0 or self:CheckIsOver(me) == 1 then
    return
  end

  --检查答和问的流水号必须为当前题目流水号
  if self:CheckQuestionIsRight() == 0 then
    return
  end

  --答题时间不在作答时间范围内
  if GetTime() <= self.nQuestionTime or GetTime() >= self.nQuestionTime + self.nTimeAskS then
    return
  end

  --检查本题是第一次答题
  if self:CheckIsFirstAnswer() == 0 then
    me.Msg("本题您已经作答，不能使用去掉两个错误答案了。")
    return
  end

  local nTime = tonumber(GetLocalDate("%y%m%d"))
  local nSelect2WrongNum = me.GetTask(self.nTaskGroup, self.nSelect2Wrong)
  local nDate = math.floor(nSelect2WrongNum / 100)
  local nCount = math.fmod(nSelect2WrongNum, 100)
  if nDate ~= nTime then
    nCount = 0
  end
  if nCount >= self.nSelect2WrongMaxNumPer then
    me.Msg("您当天的去掉2个错误答案次数已经使用完了。")
    return 0
  end

  local nSelect2WrongNum = me.GetTask(self.nTaskGroup, self.nSelect2WrongNum)
  local nSelect2WrongStateDate = math.floor(nSelect2WrongNum / 100)
  local nSelect2WrongJourNum = math.fmod(nSelect2WrongNum, 100)
  if nSelect2WrongStateDate == tonumber(GetLocalDate("%y%m%d%H")) and nSelect2WrongJourNum == self.nJourNum then
    me.Msg("同一道题目不可以使用两次去掉2个错误答案。")
    return 0
  end

  --取当前题目
  local tbQuestion = self.tbQuestionDay[self.nJourNum]
  if not tbQuestion then
    return 0
  end
  --题目答案数小于3个的不能使用剔除2个选项的
  if #tbQuestion < 6 then
    me.Msg("题目答案数小于3个，不能使用去除2个错误答案功能。")
    return 0
  end
  local tb = { 1, 2, 3, 4 }
  if #tbQuestion == 6 then --为了支持3个答案的题目
    table.remove(tb, 4)
  end
  table.remove(tb, tbQuestion[2])
  Lib:SmashTable(tb)
  me.CallClientScript({ "SpecialEvent.JxsjKeju:Select2Wrong_C", tb[1], tb[2], nCount + 1 })
  me.SetTask(self.nTaskGroup, self.nSelect2WrongNum, tonumber(GetLocalDate("%y%m%d%H")) * 100 + self.nJourNum)
  me.SetTask(self.nTaskGroup, self.nSelect2Wrong, nTime * 100 + nCount + 1)
end

--双倍积分
function JxsjKeju:DoubleGrade()
  --都不在活动期间，肯定无效了
  if self:CheckIsOpen(2) == 0 then
    return
  end

  --不再附近或者已经答题完毕的
  if self:CheckIsNear(me) == 0 or self:CheckIsOver(me) == 1 then
    return
  end

  --检查答和问的流水号必须为当前题目流水号
  if self:CheckQuestionIsRight() == 0 then
    return
  end

  --答题时间不在作答时间范围内
  if GetTime() <= self.nQuestionTime or GetTime() >= self.nQuestionTime + self.nTimeAskS then
    return
  end

  --检查本题是第一次答题
  if self:CheckIsFirstAnswer() == 0 then
    me.Msg("本题您已经作答，不能使用双倍积分了。")
    return
  end

  local nTime = tonumber(GetLocalDate("%y%m%d"))
  local nDoubleGradeNum = me.GetTask(self.nTaskGroup, self.nDoubleGrade)
  local nDate = math.floor(nDoubleGradeNum / 100)
  local nCount = math.fmod(nDoubleGradeNum, 100)
  if nDate ~= nTime then
    nCount = 0
  end
  if nCount >= self.nDoubleGradeMaxNumPer then
    me.Msg("您当天的双倍积分次数已经使用完了。")
    return 0
  end

  local nDoubleGradeNum = me.GetTask(self.nTaskGroup, self.nDoubleGradeNum)
  local nDoubleStateDate = math.floor(nDoubleGradeNum / 100)
  local nJourNumDouble = math.fmod(nDoubleGradeNum, 100)
  if nDoubleStateDate == tonumber(GetLocalDate("%y%m%d%H")) and nJourNumDouble == self.nJourNum then
    me.Msg("同一道题目不可以使用两次双倍积分。")
    return 0
  end

  me.SetTask(self.nTaskGroup, self.nDoubleGradeNum, tonumber(GetLocalDate("%y%m%d%H")) * 100 + self.nJourNum)
  me.Msg("您开启本道题双倍积分。")
  me.CallClientScript({ "SpecialEvent.JxsjKeju:DoubleGrade_C", nCount + 1 })
  me.SetTask(self.nTaskGroup, self.nDoubleGrade, nTime * 100 + nCount + 1)
end
