-----------------------------------------------------
-- 文件名		: NewCalendarView.lua
-- 创建者　		: zhonghuajian
-- 创建时间		：2012/9/24 22:25
-- 功能描述		: 剑侠日历改造  窗口部分
-----------------------------------------------------
local uiNewCalendarView = Ui:GetClass("newcalendarview")
local tbNewCalendar = Ui.tbLogic.tbNewCalendar

uiNewCalendarView.TIME_UP = 100 -- 上延一小时
uiNewCalendarView.TIME_DOWN = 200 -- 下延2小时

------ 常量定义 ------

-- 变量
uiNewCalendarView.nMAXMATCH = 50 -- 最大活动项
uiNewCalendarView.nACTMATCH = 0 -- 实际显示活动项
uiNewCalendarView.nMAXSTAR = 6 -- 最大星星数
uiNewCalendarView.nCURY = 33 -- 活动项Y轴偏移
uiNewCalendarView.bISCLICKMATCH = true -- 单击活动项
uiNewCalendarView.bNOCLICKMATCH = false -- 没单击活动项
uiNewCalendarView.tbMatch = {} -- 活动项信息存放表
uiNewCalendarView.bIsBtnClick = false -- 是否单击

uiNewCalendarView.emNOSHOW_ALLSTAR = -1 -- 不显示全部
uiNewCalendarView.emSHOW_ALLSTAR = 1 -- 显示全部

uiNewCalendarView.emSORTTYPE_ALLSTAR = 1 -- 点击全部
uiNewCalendarView.emSORTTYPE_POPULARITYSTAR = 2 -- 点击声望
uiNewCalendarView.emSORTTYPE_XUANJINGSTAR = 3 -- 点击玄晶
uiNewCalendarView.emSORTTYPE_EXPERIENCESTAR = 4 -- 点击经验
uiNewCalendarView.emSORTTYPE_BINDMONEYSTAR = 5 -- 点击绑银
uiNewCalendarView.emSORTTYPE_PRESTIGESTAR = 6 -- 点击江湖威望
uiNewCalendarView.emSORTTYPE_NONE = -1 -- 点击不在分栏按钮和是否显示全部按钮上

uiNewCalendarView.strPVESPR = "image\\ui\\002a\\newcalendar\\pve.spr" -- pvp spr
uiNewCalendarView.strPVPSPR = "image\\ui\\002a\\newcalendar\\pvp.spr" -- pve spr

uiNewCalendarView.nMatchId = 0 -- 活动项id
uiNewCalendarView.nMatchIdHelp = 0 -- 活动项id(专用于帮助)
uiNewCalendarView.nInfoOnlyId = -1 -- 信息id
uiNewCalendarView.nNil = -1 -- 特殊判断符号
-- end

-- 窗口标识
uiNewCalendarView.BTN_CLOSE = "BtnClose" -- byebye
uiNewCalendarView.PAGE_MAIN = "Main" -- 整个窗口
uiNewCalendarView.SCORLL_TASKPANEL = "TaskScrollPanel" -- 列表框
uiNewCalendarView.TXT_CONDITION = "TxtCondition" -- 参加条件
uiNewCalendarView.BTN_ALL = "BtnAll" -- 全部按钮
uiNewCalendarView.BTN_POPULARITY = "BtnPopularity" -- 声望按钮
uiNewCalendarView.BTN_CRYSTAL = "BtnCrystal" -- 玄晶按钮
uiNewCalendarView.BTN_EXP = "BtnExp" -- 经验按钮
uiNewCalendarView.BTN_BINDMONEYSTAR = "BtnVersus" -- 绑银按钮
uiNewCalendarView.BTN_PRESTIGESTAR = "BtnPerstige" -- 江湖威望按钮
uiNewCalendarView.BTN_SHOWALL = "ShowAll" -- 显示全部活动
uiNewCalendarView.TXT_RECOMMEND = "Recommend" -- 推荐项目的改变
uiNewCalendarView.SCORLL_TASKSHOW = "TaskShow" -- 滑动窗口
uiNewCalendarView.BTN_TASK = "BtnTask"
uiNewCalendarView.BTN_HELP = "Help"
uiNewCalendarView.TXT_TIMERFRAME = "TxtInfoRemainDay"
uiNewCalendarView.TXT_OPENDAY = "TxtInfoDay"
uiNewCalendarView.SET_LSTMATCH = "SetLstMatch" -- 活动项名称
uiNewCalendarView.IMG_STAR = "StarSpar" -- 星星项名称
uiNewCalendarView.IMG_STARTXT = "StarText" -- 星星项文字
uiNewCalendarView.TXT_LINK = "Txtlink" -- 参加名称
-- end

-- 奖励图片
uiNewCalendarView.IMAGE = {}
uiNewCalendarView.IMAGE[1] = "Image1"
uiNewCalendarView.IMAGE[2] = "Image2"
uiNewCalendarView.IMAGE[3] = "Image3"
uiNewCalendarView.IMAGE[4] = "Image4"
uiNewCalendarView.IMAGE[5] = "Image5"
uiNewCalendarView.IMAGE[6] = "Image6"
uiNewCalendarView.IMAGE[7] = "Image7"
uiNewCalendarView.IMAGE[8] = "Image8"
-- end

-- 活动信息
uiNewCalendarView.SET_LSTMATCHPAG = {}
for i = 1, uiNewCalendarView.nMAXMATCH do
  local tbTempLst = {}
  tbTempLst.SET_LSTMATCH = "SetLstMatch" .. i
  tbTempLst.BTN_TASK = "BtnTask" .. i
  tbTempLst.TXT_NAME = "TxtName" .. i
  tbTempLst.TXT_TIME = "TxtTime" .. i
  tbTempLst.TXT_COUNT = "TxtCount" .. i
  tbTempLst.IMG_ICON = "MatchIcon" .. i
  tbTempLst.TXT_TYPE = "MatchType" .. i
  tbTempLst.IMG_STAR = "StarSpar" .. i
  tbTempLst.nOnlyId = 0

  uiNewCalendarView.SET_LSTMATCHPAG[i] = tbTempLst
end
-- end

------ 功能定义 ------

uiNewCalendarView.tbAttendFunctionList = {
  ["OpenWindow"] = "OnAttendOpenWindow", -- 打开指定窗口
  ["ClientAutoPath"] = "OnAttendClientAutoPath", -- 客户端寻路
  ["ServerAutoPath"] = "OnAttendServerAutoPath", -- 无线传送符寻路
  ["JXCiDian"] = "OnAttendJXCiDian", -- 剑侠辞典
  ["KinSalary"] = "OnAttendKinSalary", -- 家族工资
  ["KinFlag"] = "OnAttendKinFlag", -- 家族插旗
  ["CallServerScript"] = "OnAttendCallServerScript", -- 掉服务端脚本
}

-- 基本功能
function uiNewCalendarView:Init()
  self.nSwitchState = self.emSORTTYPE_ALLSTAR -- 当前状态
  self.nSwitchLastState = self.emSORTTYPE_ALLSTAR -- 上一个状态
  self.nIsShowAll = self.emNOSHOW_ALLSTAR -- 是否显示全部
  self.tbMatch = nil -- 清空表
  self.bIsBtnClick = self.bNOCLICKMATCH
  self.nMatchId = 0 -- 活动项id
  self.nMatchIdHelp = 0 -- 帮助id
  self.nInfoOnlyId = self.nNil
end

function uiNewCalendarView:OnOpen()
  self:Init()
  self:GetMatchFullList() -- 加载全表
  self:UpdataMatchColumn(self.nSwitchState)
  self:ApplyServerInfo()
  Btn_Check(self.UIGROUP, self.BTN_ALL, 1)
  self:ShowTimeFrame(GetTime())
end
function uiNewCalendarView:OnClose() end

function uiNewCalendarView:OnButtonClick(szWnd, nParam)
  self:GetMatchId(szWnd)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_ALL then
    self.nSwitchState = self.emSORTTYPE_ALLSTAR -- 全部按钮
    self:ApplyServerInfo()
  elseif szWnd == self.BTN_POPULARITY then
    self.nSwitchState = self.emSORTTYPE_POPULARITYSTAR -- 声望按钮
    self:ApplyServerInfo()
  elseif szWnd == self.BTN_CRYSTAL then
    self.nSwitchState = self.emSORTTYPE_XUANJINGSTAR -- 玄晶按钮
    self:ApplyServerInfo()
  elseif szWnd == self.BTN_EXP then
    self.nSwitchState = self.emSORTTYPE_EXPERIENCESTAR -- 经验按钮
    self:ApplyServerInfo()
  elseif szWnd == self.BTN_BINDMONEYSTAR then
    self.nSwitchState = self.emSORTTYPE_BINDMONEYSTAR -- 绑银按钮
    self:ApplyServerInfo()
  elseif szWnd == self.BTN_PRESTIGESTAR then
    self.nSwitchState = self.emSORTTYPE_PRESTIGESTAR -- 江湖威望按钮
    self:ApplyServerInfo()
  elseif szWnd == self.BTN_SHOWALL then
    self.nIsShowAll = self.nIsShowAll * -1
    self.nSwitchState = self.nSwitchLastState
    self:ApplyServerInfo()
  elseif szWnd == self.BTN_HELP then
    self:ClickBtnHelp(szWnd)
    self.nSwitchState = self.emSORTTYPE_NONE
  else
    self.nSwitchState = self.emSORTTYPE_NONE -- 不在分栏哪儿
  end

  self:ChangeState(szWnd)
end

-- 鼠标移动，只更新参加条件和奖励
function uiNewCalendarView:OnMouseEnter(szWnd)
  if self.bIsBtnClick == self.bISCLICKMATCH then
    return
  end

  self:GetMatchId(szWnd)
  self:UpdataConditionAndAward()
end

-- 状态的改变(单击)
function uiNewCalendarView:ChangeState(szWnd)
  if self.nSwitchState ~= self.emSORTTYPE_NONE then
    self:GetMatchFullList() -- 重新加载全表
    self:SetColumnBtnState()
    self.nSwitchLastState = self.nSwitchState -- 分栏项选择更新
  elseif (string.sub(szWnd, 1, string.len(self.SET_LSTMATCH)) == self.SET_LSTMATCH) or (string.sub(szWnd, 1, string.len(self.BTN_TASK)) == self.BTN_TASK) or (string.sub(szWnd, 1, string.len(self.TXT_LINK)) == self.TXT_LINK) then
    self:SetMatchColumState(szWnd, self.nSwitchState)
    self.nSwitchState = self.nSwitchLastState -- 分栏项选择倒置
  end
end

-- id获取条件
function uiNewCalendarView:GetIdConditions(szWnd)
  if (string.sub(szWnd, 1, string.len(self.SET_LSTMATCH)) ~= self.SET_LSTMATCH) and (string.sub(szWnd, 1, string.len(self.BTN_TASK)) ~= self.BTN_TASK) then
    return false
  else
    return true
  end
end

-- 帮助按钮响应
function uiNewCalendarView:ClickBtnHelp(szWnd)
  if (szWnd == self.BTN_HELP) and (self.nMatchIdHelp ~= nil) then
    self:LinkHelp(self.tbMatch[self.nMatchIdHelp].nLinkHelpType, self.tbMatch[self.nMatchIdHelp].szLinkHelpName)
  end
end

-- 设置参加按钮对活动项的改变
function uiNewCalendarView:SetBtnTaskMatchChange()
  if self.nMatchId then
    Btn_Check(self.UIGROUP, self.SET_LSTMATCHPAG[self.nMatchId].SET_LSTMATCH, 1)
  else
    Btn_Check(self.UIGROUP, self.SET_LSTMATCHPAG[self.nMatchId].SET_LSTMATCH, 0)
  end
end

-- 设置帮助按钮对活动项的不改变
function uiNewCalendarView:SetBtnHelpNoChange()
  if self.nMatchId then
    Btn_Check(self.UIGROUP, self.SET_LSTMATCHPAG[self.nMatchId].SET_LSTMATCH, 1)
  else
    Btn_Check(self.UIGROUP, self.SET_LSTMATCHPAG[self.nMatchId].SET_LSTMATCH, 0)
  end
end

-- 获取Match表 (全表:读取的操作) clear
function uiNewCalendarView:GetMatchFullList()
  self.nMatchId = nil -- id清空
  self.nMatchIdHelp = nil

  local bIsShowAll = 0
  if self.nIsShowAll == self.emSHOW_ALLSTAR then
    bIsShowAll = 1
  end

  local tbMatch = tbNewCalendar:GetMatchList(self.nSwitchState, me.nLevel, bIsShowAll)
  if #tbMatch == nil then
    return
  end

  self.tbMatch = tbMatch
  return tbMatch
end

-- 获取Match信息 (单项)clear
-- return(szName, szTime, nCurCount, nMaxCount, szStar, tbAward, tbExtendAward，szType, nIcon)
function uiNewCalendarView:GetMatchRowInfo(nMatchId)
  local tbMatch = self.tbMatch
  local nMatch = #tbMatch

  if not tbMatch then
    return
  end

  local szName = tbMatch[nMatchId].szName
  local szTime = tbMatch[nMatchId].szNextTime
  local szCountInfo = ""
  if tbMatch[nMatchId].nRemainTime then
    local nHour, nMinute, nSecond = Lib:TransferSecond2NormalTime(tbMatch[nMatchId].nRemainTime)
    if nHour > 0 then
      szCountInfo = string.format("%s小时%s分", nHour, nMinute)
    elseif nMinute > 0 then
      szCountInfo = string.format("%s分%s秒", nMinute, nSecond)
    else
      szCountInfo = string.format("%s秒", nSecond)
    end
  else
    szCountInfo = string.format("%s/%s", tbMatch[nMatchId].nCurCount, tbMatch[nMatchId].nMaxCount)
  end
  local szStar = tbMatch[nMatchId].szStarDesc

  -- 类型和图片
  local szType = tbMatch[nMatchId].szTypeName
  local nIcon = tbMatch[nMatchId].nIsPVP

  local tbAward = tbMatch[nMatchId].tbAward
  local tbExtendAward = tbMatch[nMatchId].tbExtendAward
  local szStarDesc = tbMatch[nMatchId].szStarDesc
  local nId = tbMatch[nMatchId].nMatchId
  local szFunce = tbMatch[nMatchId].tbAttend.szFunc

  return szName, szTime, szCountInfo, szStar, tbAward, tbExtendAward, szType, nIcon, nId, szFunce
end

-- 状态对窗口的文字改变 clear
function uiNewCalendarView:ChangeTaskSrollPanel(nSwitchState)
  if nSwitchState == self.emSORTTYPE_POPULARITYSTAR then
    Wnd_SetSize(self.UIGROUP, self.TXT_RECOMMEND, 75, 17)
    Txt_SetTxt(self.UIGROUP, self.TXT_RECOMMEND, "装备部位")
  elseif nSwitchState == self.emSORTTYPE_PRESTIGESTAR then
    Wnd_SetSize(self.UIGROUP, self.TXT_RECOMMEND, 110, 17)
    Txt_SetTxt(self.UIGROUP, self.TXT_RECOMMEND, "本周还可获得")
  else
    Wnd_SetSize(self.UIGROUP, self.TXT_RECOMMEND, 40, 17)
    Txt_SetTxt(self.UIGROUP, self.TXT_RECOMMEND, "推荐")
  end
end

-- 活动项目按钮按下的检测
function uiNewCalendarView:SetMatchColumState(szWnd)
  -- 全部设置为不亮
  for i = 1, self.nMAXMATCH do
    Btn_Check(self.UIGROUP, self.SET_LSTMATCHPAG[i].SET_LSTMATCH, 0)
  end

  -- 判断id来设置亮
  if self.nMatchId ~= nil then
    self:SetBtnTaskMatchChange() -- 点击参加按钮是活动项高亮
    Btn_Check(self.UIGROUP, szWnd, 1)
    self.nMatchIdHelp = self.nMatchId -- 将id赋予帮助
    self.bIsBtnClick = self.bISCLICKMATCH -- 点击在活动项上
    self.nInfoOnlyId = self.SET_LSTMATCHPAG[self.nMatchId].nId
  else
    self.bIsBtnClick = self.bNOCLICKMATCH -- 点击不在活动项上
  end

  self:UpdataConditionAndAward() -- 更新条件跟奖励项

  ------具体操作 参加按钮
  if string.sub(szWnd, 1, string.len(self.BTN_TASK)) == self.BTN_TASK then
    self:ClickAttend()
  end
end

-- 参加操作 clear
function uiNewCalendarView:ClickAttend()
  local tbAttend = self.tbMatch[self.nMatchId].tbAttend -- 参加响应放在这儿先
  if tbAttend.szFunc then
    local szFuncName = self.tbAttendFunctionList[tbAttend.szFunc]
    if szFuncName then
      self[szFuncName](self, tbAttend.tbParam)
    end
  end
end

-- 分栏项目按钮按下的刷新 clear
-- 1.	分栏项按钮弹起状态更新
-- 2.	改变活动栏文字说明
-- 3.	重新加载活动项信息
-- 4.	初始活动项为默认状态（不亮）
-- 5.	判断显示是星星还是文字
function uiNewCalendarView:SetColumnBtnState()
  Btn_Check(self.UIGROUP, self.BTN_ALL, 0)
  Btn_Check(self.UIGROUP, self.BTN_POPULARITY, 0)
  Btn_Check(self.UIGROUP, self.BTN_CRYSTAL, 0)
  Btn_Check(self.UIGROUP, self.BTN_EXP, 0)
  Btn_Check(self.UIGROUP, self.BTN_BINDMONEYSTAR, 0)
  Btn_Check(self.UIGROUP, self.BTN_PRESTIGESTAR, 0)

  if self.nSwitchState == self.emSORTTYPE_ALLSTAR then
    Btn_Check(self.UIGROUP, self.BTN_ALL, 1)
  elseif self.nSwitchState == self.emSORTTYPE_POPULARITYSTAR then
    Btn_Check(self.UIGROUP, self.BTN_POPULARITY, 1)
  elseif self.nSwitchState == self.emSORTTYPE_XUANJINGSTAR then
    Btn_Check(self.UIGROUP, self.BTN_CRYSTAL, 1)
  elseif self.nSwitchState == self.emSORTTYPE_EXPERIENCESTAR then
    Btn_Check(self.UIGROUP, self.BTN_EXP, 1)
  elseif self.nSwitchState == self.emSORTTYPE_BINDMONEYSTAR then
    Btn_Check(self.UIGROUP, self.BTN_BINDMONEYSTAR, 1)
  elseif self.nSwitchState == self.emSORTTYPE_PRESTIGESTAR then
    Btn_Check(self.UIGROUP, self.BTN_PRESTIGESTAR, 1)
  end

  self:ChangeTaskSrollPanel(self.nSwitchState) -- 改变窗口说明

  self.bIsBtnClick = self.bNOCLICKMATCH -- 重设活动项是否点击
  self:UpdataMatchColumn() -- 更新加载活动项

  if self.nMatchIdHelp ~= nil then
    Btn_Check(self.UIGROUP, self.SET_LSTMATCHPAG[self.nMatchIdHelp].SET_LSTMATCH, 1)
  end

  if self.nSwitchState ~= self.nSwitchLastState then
    self.nInfoOnlyId = self.nNil
    self.nMatchId = nil
  end

  self:UpdataSelectMatchStates()
end

-- 更新设置选中状态
function uiNewCalendarView:UpdataSelectMatchStates(nMatchId)
  local ntag = 1
  self.nMatchId = nil
  self.nInfoOnlyId = nMatchId or self.nInfoOnlyId
  -- 活动项全部设置为不亮
  for i = 1, self.nACTMATCH do
    if (self.SET_LSTMATCHPAG[i].nId == self.nInfoOnlyId) and (self.nSwitchState == self.nSwitchLastState) and (ntag == 1) then
      Btn_Check(self.UIGROUP, self.SET_LSTMATCHPAG[i].SET_LSTMATCH, 1)
      self.bIsBtnClick = self.bISCLICKMATCH -- 重设活动项是否点击
      self.nMatchId = i
      self.nMatchIdHelp = self.nMatchId
      ntag = 0
    else
      Btn_Check(self.UIGROUP, self.SET_LSTMATCHPAG[i].SET_LSTMATCH, 0)
    end
  end

  self:UpdataConditionAndAward()
end

-- 把信息填入活动项 clear
function uiNewCalendarView:SetMatchColumn()
  for i = 1, self.nMAXMATCH do
    Wnd_Show(self.UIGROUP, self.SET_LSTMATCHPAG[i].SET_LSTMATCH)
  end

  local nMatchNum = #self.tbMatch
  if nMatchNum == nil then
    return
  end

  for i = 1, nMatchNum do
    self:UpdateOneMatch(i)
  end

  for i = nMatchNum + 1, self.nMAXMATCH do
    Wnd_Hide(self.UIGROUP, self.SET_LSTMATCHPAG[i].SET_LSTMATCH)
  end
end

-- 单独更新某个项信息 clear
function uiNewCalendarView:UpdateOneMatch(nNum)
  local szName, szTime, szCountInfo, szStar, _, _, szType, nIcon, nId, szFunce = self.GetMatchRowInfo(self, nNum)
  Txt_SetTxt(self.UIGROUP, self.SET_LSTMATCHPAG[nNum].TXT_NAME, szName)
  Txt_SetTxt(self.UIGROUP, self.SET_LSTMATCHPAG[nNum].TXT_TIME, szTime)
  Txt_SetTxt(self.UIGROUP, self.SET_LSTMATCHPAG[nNum].TXT_COUNT, szCountInfo)
  self.SET_LSTMATCHPAG[nNum].nId = nId -- 保存唯一 Id

  if nIcon == 0 then
    Img_SetImage(self.UIGROUP, self.SET_LSTMATCHPAG[nNum].IMG_ICON, 1, self.strPVESPR)
  else
    Img_SetImage(self.UIGROUP, self.SET_LSTMATCHPAG[nNum].IMG_ICON, 1, self.strPVPSPR)
  end

  Txt_SetTxt(self.UIGROUP, self.SET_LSTMATCHPAG[nNum].TXT_TYPE, szType)
  -- 判断显示星星还是文字
  if self.nSwitchState == self.emSORTTYPE_POPULARITYSTAR or self.nSwitchState == self.emSORTTYPE_PRESTIGESTAR then
    Wnd_Hide(self.UIGROUP, self.IMG_STAR .. nNum)
    Wnd_Show(self.UIGROUP, self.IMG_STARTXT .. nNum)
    Txt_SetTxt(self.UIGROUP, self.IMG_STARTXT .. nNum, szStar)
  else
    Wnd_Show(self.UIGROUP, self.IMG_STAR .. nNum)
    Wnd_Hide(self.UIGROUP, self.IMG_STARTXT .. nNum)
    local nStar = math.floor(self.tbMatch[nNum].nStar / 10) -- 星级是放大了10倍存的，个位是权重用来排序
    local strStar = "image\\ui\\002a\\newcalendar\\blingbling\\" .. nStar .. ".spr"
    Img_SetImage(self.UIGROUP, self.SET_LSTMATCHPAG[nNum].IMG_STAR, 1, strStar)
    Img_PlayAnimation(self.UIGROUP, self.SET_LSTMATCHPAG[nNum].IMG_STAR, 1)
  end

  if (szFunce == nil) or (szFunce == "") then
    Wnd_SetEnable(self.UIGROUP, self.SET_LSTMATCHPAG[nNum].BTN_TASK, 0)
    TxtEx_SetText(self.UIGROUP, "Txtlink" .. nNum, "<a=infor><lclr=gray>    <a>")
    Btn_SetTxt(self.UIGROUP, self.SET_LSTMATCHPAG[nNum].BTN_TASK, "<color=gray>参加<color>")
  else
    Wnd_SetEnable(self.UIGROUP, self.SET_LSTMATCHPAG[nNum].BTN_TASK, 1)
    TxtEx_SetText(self.UIGROUP, "Txtlink" .. nNum, "<a=infor><lclr=green>    <a>")
    Btn_SetTxt(self.UIGROUP, self.SET_LSTMATCHPAG[nNum].BTN_TASK, "<color=green>参加<color>")
  end
end

-- 对活动项进行排序 clear -2-
function uiNewCalendarView:MatchSort()
  local nCount = -1
  for i = 1, self.nACTMATCH do
    nCount = nCount + 1
    Wnd_SetPos(self.UIGROUP, self.SET_LSTMATCHPAG[i].SET_LSTMATCH, 0, (nCount * self.nCURY + 1))
  end
end

-- 加载活动项 -2-
function uiNewCalendarView:UpdataMatchColumn()
  local nMatchNum = #self.tbMatch
  if not nMatchNum then
    return
  end

  self.nACTMATCH = nMatchNum
  self:SetMatchColumn() -- 把信息填入活动项
  self:MatchSort() -- 信息项排列

  -- 滑动窗口的Size改变
  local nX = Wnd_GetSize(self.UIGROUP, self.SCORLL_TASKSHOW)
  Wnd_SetSize(self.UIGROUP, self.SCORLL_TASKSHOW, nX, self.nCURY * nMatchNum)
end

-- 更新图片和条件说明 clear	-1-
function uiNewCalendarView:UpdataConditionAndAward()
  self:GetAwardTip()
  self:GetCondition()
  self:SetHelpButton()
end

-- 帮助的显示
function uiNewCalendarView:SetHelpButton()
  if (self.nMatchId ~= nil) and (self.tbMatch[self.nMatchId].nLinkHelpType ~= -1) then
    Wnd_Show(self.UIGROUP, self.BTN_HELP)
  else
    Wnd_Hide(self.UIGROUP, self.BTN_HELP)
  end
end

-- Tip、图片 的改变 szWnd是判断在那个图片上 clear -1-
function uiNewCalendarView:GetAwardTip()
  if self.nMatchId == nil then
    for i = 1, #self.IMAGE do
      Img_SetImage(self.UIGROUP, self.IMAGE[i], 1, "")
      Wnd_SetTip(self.UIGROUP, self.IMAGE[i], "")
    end
    return
  end

  local tb = self.tbMatch
  if not tb then
    return
  end

  local nNum = self.nMatchId
  local szTip
  -- Tip 输出
  for i = 1, #tb[nNum].tbAward do
    szTip = tb[nNum].tbAward[i].szTip
    if szTip ~= nil then
      Wnd_SetTip(self.UIGROUP, self.IMAGE[i], szTip)
    end
  end
  for i = 1, #tb[nNum].tbExtendAward do
    szTip = tb[nNum].tbExtendAward[i].szTip
    if szTip ~= nil then
      Wnd_SetTip(self.UIGROUP, self.IMAGE[i + 5], szTip)
    end
  end

  local szSpr
  -- 图片输出
  for i = 1, 5 do -- 上下四个不同分区图片
    if i <= #tb[nNum].tbAward then
      szSpr = tb[nNum].tbAward[i].szImage
      Wnd_Show(self.UIGROUP, self.IMAGE[i])
      Img_SetImage(self.UIGROUP, self.IMAGE[i], 1, szSpr)
    else
      szSpr = ""
      Wnd_Hide(self.UIGROUP, self.IMAGE[i])
    end
  end
  for i = 1, 3 do
    if i <= #tb[nNum].tbExtendAward then
      szSpr = tb[nNum].tbExtendAward[i].szImage
      Wnd_Show(self.UIGROUP, self.IMAGE[i + 5])
      Img_SetImage(self.UIGROUP, self.IMAGE[i + 5], 1, szSpr)
    else
      szSpr = ""
      Wnd_Hide(self.UIGROUP, self.IMAGE[i + 5])
    end
  end
end

-- Condition 参加条件  clear -1-
function uiNewCalendarView:GetCondition()
  if #self.tbMatch == nil then
    return
  end

  local nMatchId = self.nMatchId
  local szCondition
  if nMatchId == nil then
    szCondition = ""
  else
    szCondition = self.tbMatch[nMatchId].szCondition
  end

  Txt_SetTxt(self.UIGROUP, self.TXT_CONDITION, szCondition)
end

-- 获取活动项的序号 clear
function uiNewCalendarView:GetMatchId(szWnd)
  if self:GetIdConditions(szWnd) ~= true then
    self.nMatchId = nil
    return
  end

  local nLstMatchSize = string.len(self.SET_LSTMATCH)
  local nBtnTaskSize = string.len(self.BTN_TASK)
  local nTxtLink = string.len(self.TXT_LINK)

  if string.sub(szWnd, 1, string.len(self.SET_LSTMATCH)) == self.SET_LSTMATCH then
    self.nMatchId = string.sub(szWnd, nLstMatchSize + 1, string.len(szWnd))
  elseif string.sub(szWnd, 1, string.len(self.TXT_LINK)) == self.TXT_LINK then
    self.nMatchId = string.sub(szWnd, nTxtLink + 1, string.len(szWnd))
  else
    self.nMatchId = string.sub(szWnd, nBtnTaskSize + 1, string.len(szWnd))
  end

  self.nMatchId = tonumber(self.nMatchId)
  return self.nMatchId
end

-- 请求客户端未知的数据
function uiNewCalendarView:ApplyServerInfo()
  me.CallServerScript({ "PlayerCmd", "ApplyCalendarInfo" })
end

-- 更新客户端数据，很多活动是否完成无法再客户端判断，只有服务器返回成功后我们再更新
function uiNewCalendarView:OnServerInfoUpdate(nKinGameTimes, nKinBossTimes)
  if UiManager:WindowVisible(Ui.UI_NEWCALENDARVIEW) ~= 1 then
    return
  end

  local tbUpdate = {}
  local nAchieveChageFlag = 0
  local j = 1
  local nCount = #self.tbMatch
  for i = 1, nCount do
    if self.tbMatch[j] and self.tbMatch[j].nMatchId == 28 then -- 家族关卡次数
      self.tbMatch[i].nCurCount = nKinGameTimes or 0
      if nKinGameTimes == tonumber(self.tbMatch[j].nMaxCount) then
        nAchieveChageFlag = 1
        table.remove(self.tbMatch, j)
      else
        table.insert(tbUpdate, j)
      end
    elseif self.tbMatch[j] and self.tbMatch[j].nMatchId == 41 then
      self.tbMatch[i].nCurCount = nKinBossTimes or 0
      if nKinBossTimes == tonumber(self.tbMatch[j].nMaxCount) then
        nAchieveChageFlag = 1
        table.remove(self.tbMatch, j)
      else
        table.insert(tbUpdate, j)
      end
    end
    j = j + 1
  end
  if nAchieveChageFlag == 0 then
    for _, i in ipairs(tbUpdate) do
      self:UpdateOneMatch(i)
    end
  else
    self:UpdataMatchColumn()
    self:UpdataSelectMatchStates()
  end
end

-- 跨服宋金服务器回调更新.特殊逻辑，单独处理
function uiNewCalendarView:OnGlobalSongJinUpdate(nOpen, nAttend, nQueue, nState, nTime)
  if UiManager:WindowVisible(Ui.UI_NEWCALENDARVIEW) ~= 1 then
    return
  end
  for i = 1, #self.tbMatch do
    if self.tbMatch[i].nMatchId == 15 then -- 跨服宋金
      self.tbMatch[i].nCurCount = nAttend
      if nAttend >= tonumber(self.tbMatch[i].nMaxCount) then
        table.remove(self.tbMatch, i)
        self:UpdataMatchColumn()
        self:UpdataSelectMatchStates()
      else
        self:UpdateOneMatch(i)
      end
      break
    end
  end
end

-- 进入游戏回调
function uiNewCalendarView:OnEnterGame()
  if me.nLevel < 60 then
    Timer:Register(120 * 18, self.Timer_CalendarFlicker, self)
  end
end

function uiNewCalendarView:Timer_CalendarFlicker(nFlag)
  if UiVersion == Ui.Version001 then
    return 0
  end
  if not nFlag then
    Img_PlayAnimation("UI_SIDESYSBAR", "BtnMenology", 1, Env.GAME_FPS * 30, 0, 1)
    Timer:Register(18 * 30, self.Timer_CalendarFlicker, self, 1)
  else
    Img_PlayAnimation("UI_SIDESYSBAR", "BtnMenology", 0)
  end
  return 0
end

function uiNewCalendarView:SplitStr(szParam)
  if not szParam then
    return {}
  end
  local nAssert = 0
  local t = {}
  while self:SplitStrMatch(szParam) and nAssert < 100000 do
    nAssert = nAssert + 1
    t[#t + 1], szParam = self:SplitStrMatch(szParam)
  end
  return t
end

function uiNewCalendarView:SplitStrMatch(szParam)
  szParam = string.gsub(szParam, '\\"', "<doublequ>")
  local nStart_n, nEnd_n, szRet_n, sz_n = string.find(szParam, "(-?%d+)(.*)")
  local nStart_sz, nEnd_sz, szR_sz, sz_sz = string.find(szParam, '(%b"")(.*)')
  if nStart_n and (nStart_sz and nStart_n < nStart_sz or not nStart_sz) then
    return tonumber(szRet_n), sz_n
  else
    if szR_sz then
      szR_sz = string.gsub(szR_sz, '"(.*)"', "%1")
      szR_sz = string.gsub(szR_sz, "<doublequ>", '"')
    end
    return szR_sz, sz_sz
  end
end

function uiNewCalendarView:ShowTimeFrame(nCurTime)
  local nDate_ServerStart = tonumber(KGblTask.SCGetDbTaskInt(DBTASD_SERVER_STARTTIME)) or 0
  local bShowTxt = 0
  for _, tbTimeFrame in ipairs(tbNewCalendar.tbTimeFrame) do
    local nSec = tbNewCalendar:GetTime(tbTimeFrame.nTimeFrameDay, tbTimeFrame.nTimeFrameTime, nDate_ServerStart)
    if nSec > nCurTime then
      self:ShowTimeFrameEx(tbTimeFrame, nCurTime, nSec)
      bShowTxt = 1
      break
    end
  end
  if bShowTxt == 0 then
    Wnd_Hide(self.UIGROUP, self.TXT_TIMERFRAME)
  end
  Txt_SetTxt(self.UIGROUP, self.TXT_OPENDAY, string.format("开服天数：%s", TimeFrame:GetServerOpenDay()))
end

function uiNewCalendarView:ShowTimeFrameEx(tbTimeFrame, nCurTime, nTmpTime)
  local szText = ""
  if tbTimeFrame.nState == 1 then
    szText = "本服已" .. tbTimeFrame.szName
  else
    local nDetDay = Lib:GetLocalDay(nTmpTime) - Lib:GetLocalDay(nCurTime)
    nDetDay = math.abs(nDetDay)
    if nDetDay == 0 then
      szText = string.format("<a=timeframe>本服即将%s<a>", tbTimeFrame.szName)
    else
      szText = string.format("<a=timeframe>本服距%s还有%d天<a>", tbTimeFrame.szName, nDetDay)
    end
  end
  TxtEx_SetText(self.UIGROUP, self.TXT_TIMERFRAME, szText)
end

-- 超链接 -- 还有多少天开..
function uiNewCalendarView:Link_timeframe_OnClick(szWnd)
  Task.tbHelp:OpenNews_C(5, "时间轴")
end

function uiNewCalendarView:LinkHelp(nType, szName)
  if nType and nType ~= -1 then
    Task.tbHelp:OpenNews_C(nType, szName)
  end
end

-- 点击参加按钮函数响应
-- 打开指定窗口
function uiNewCalendarView:OnAttendOpenWindow(tbParam)
  UiManager:OpenWindow(tbParam[1])
end

-- 客户端显示寻路
function uiNewCalendarView:OnAttendClientAutoPath(tbParam)
  local tbPathInfo = {}
  local tbOpt = {}
  for i = 1, #tbParam do
    local szParam = tbParam[i]
    local nSit = string.find(szParam, ":")
    if nSit and nSit > 0 then
      local szDesc = string.sub(szParam, 1, nSit - 1)
      local szContent = string.sub(szParam, nSit + 1, string.len(szParam))
      local tbPos = self:SplitStr(szContent)
      table.insert(tbOpt, { szDesc, Ui.tbLogic.tbAutoPath.ProcessClick, Ui.tbLogic.tbAutoPath, { nMapId = tonumber(tbPos[1]), nX = tonumber(tbPos[2]), nY = tonumber(tbPos[3]) } })
    end
  end
  table.insert(tbOpt, "我再考虑一下")
  Dialog:Say("请选择你要去的地点：", tbOpt)
end

-- 打开服务端传寻路
function uiNewCalendarView:OnAttendServerAutoPath(tbParam)
  me.CallServerScript({ "PlayerCmd", "GoFubenEnter", tonumber(tbParam[1]), tonumber(tbParam[2]) })
end

-- 打开剑侠辞典
function uiNewCalendarView:OnAttendJXCiDian(tbParam)
  local tbQuestions, nCount = HelpQuestion:GetTitleTable(me)
  if nCount > 0 then
    local tbOpt = {}
    for nGroupId, szGroupTitle in pairs(tbQuestions) do
      table.insert(tbOpt, { string.format("<color=green>[问答]<color>%s", szGroupTitle), self.OnQuestion, self, nGroupId })
    end
    table.insert(tbOpt, { "我只是随便看看" })
    Dialog:Say("我想回答：", tbOpt)
  end
end

function uiNewCalendarView:OnQuestion(nGroupId)
  me.CallServerScript({ "HlpQue", nGroupId })
end

-- 家族工资
function uiNewCalendarView:OnAttendKinSalary(tbParam)
  if me.dwKinId <= 0 then
    Dialog:Say("请先加入家族")
    return
  end
  UiManager:OpenWindow(Ui.UI_KIN)
  PgSet_ActivePage(Ui.UI_KIN, "KinPageSet", "PageKinAction")
  PgSet_ActivePage(Ui.UI_KIN, "KinActionPageSet", "PageActionSalary")
end

-- 家族插旗
function uiNewCalendarView:OnAttendKinFlag(tbParam)
  if me.dwKinId <= 0 then
    Dialog:Say("请先加入家族")
    return
  end
  UiManager:OpenWindow(Ui.UI_KIN)
  PgSet_ActivePage(Ui.UI_KIN, "KinPageSet", "PageKinAction")
  PgSet_ActivePage(Ui.UI_KIN, "KinActionPageSet", "PageActionInfo")
end

-- 调服务端脚本
function uiNewCalendarView:OnAttendCallServerScript(tbParam)
  local tb = {}
  for i = 2, #tbParam do
    tb[i - 1] = tbNewCalendar:GetVar(tbParam[i])
  end
  me.CallServerScript({ tbParam[1], unpack(tb) })
end
