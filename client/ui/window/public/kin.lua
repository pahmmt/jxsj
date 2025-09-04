-----------------------------------------------------
--文件名		：	kin.lua
--创建者		：	FanJinsong
--创建时间	：	2012-7-23
--功能描述	：	家族面板
------------------------------------------------------

local uiKin = Ui:GetClass("kin")

--对应与 KE_KIN_MAIL_TYPE
local KIN_MEMBER_ALL = 1 -- 全体家族成员
local KIN_SIGLE_FIGUE = 2 -- 单个职位

uiKin.PAGESET_MAIN = "KinPageSet" -- 家族主界面
uiKin.CLOSE_WINDOW_BUTTON = "BtnClose" -- 关闭按钮
uiKin.TXT_KIN_TITLE = "TxtKinName" -- 家族主界面：家族名称（左侧显示）

uiKin.BTN_BADGE = "BtnBadge" -- 设置徽章
uiKin.IMG_BADGE = "ImageBadge" -- 家族徽章
uiKin.TXT_BADGE = "TxtBadge" -- 家族徽章

-- 成员标签页
uiKin.PAGE_KIN_MEMBER = "PageKinMember" -- 成员标签页
uiKin.BTN_PAGE_MEMBER = "BtnPageKinMember" -- 成员标签页按钮
--uiKin.SP_AFFICHE				= "SpAffiche";				-- 成员：家族公告滚动面板
uiKin.TXT_AFFICHE = "TxtAfficheDetail" -- 成员：家族公告
uiKin.BTN_AFFICHE = "BtnAffiche" -- 成员：详细公告
uiKin.BTN_MEMBER_POST = "KinMemberListTitlePost" -- 成员：成员列表-职位
uiKin.BTN_MEMBER_SECT = "KinMemberListTitleSect" -- 成员：成员列表-门派
uiKin.BTN_MEMBER_RANK = "KinMemberListTitleRate" -- 成员：成员列表-等级
uiKin.BTN_MEMBER_RICH = "KinMemberListTitleRich" -- 成员：成员列表-财富等级
uiKin.BTN_MEMBER_TIME = "KinMemberListTitleOnline" -- 成员：成员列表-上次在线时间
uiKin.SP_MEMBER = "KinMemberSP" -- 成员：成员列表滚动面板
uiKin.LST_MEMBER = "KinMemberList" -- 成员：成员列表
uiKin.BTN_MEMBER_REPOSITORY = "BtnRepository" -- 成员：家族仓库
uiKin.BTN_MEMBER_ONLINE = "BtnShowOnline" -- 成员：显示在线成员
uiKin.BTN_MEMBER_QUIT = "BtnKinQuit" -- 成员：退出家族
uiKin.BTN_MEMBER_RECRUITMENT = "BtnRecruitment" -- 成员：家族招募
uiKin.BTN_MEMBER_REQUESTLIST = "BtnRequestList" -- 成员：申请列表
-- end

-- 信息标签页
uiKin.PAGE_KIN_INFO = "PageKinInfo" -- 信息标签页
uiKin.BTN_PAGE_INFO = "BtnPageKinInfo" -- 信息标签页按钮
uiKin.PAGESET_KININFO = "KinInfoPageSet" -- 信息标签页内标签页集

uiKin.BTN_PAGE_INTRO = "BtnPageIntro" -- 家族介绍标签页按钮
uiKin.PAGE_INTRO = "PageKinIntro" -- 家族介绍标签页
uiKin.TXT_KIN_NAME = "TxtName" -- 家族介绍：家族名称
uiKin.TXT_KIN_LEADER = "TxtLeader" -- 家族介绍：族长
uiKin.TXT_KIN_SUBLEADER = "TxtSubLeader" -- 家族介绍：副族长
uiKin.TXT_KIN_CAMP = "TxtCamp" -- 家族介绍：阵营
uiKin.TXT_KIN_REPUTE = "TxtRepute" -- 家族介绍：家族威望
uiKin.TXT_KIN_MEMBER_NUM = "TxtMemberNum" -- 家族介绍：正式成员
uiKin.TXT_KIN_MEMBER_NUMEX = "TxtMemberNumEx" -- 家族介绍：荣誉成员
uiKin.BTN_YY_RUN = "BtnRunYY" -- 家族介绍：启动YY按钮
uiKin.TXT_YY = "TxtYY" -- 家族介绍：YY号
uiKin.BTN_YY_SET = "BtnYY" -- 家族介绍：设置YY号

uiKin.BTN_PAGE_HISTORY = "BtnPageHistory" -- 家族历史标签页按钮
uiKin.PAGE_HISTORY = "PageKinHistory" -- 家族历史标签页
uiKin.SP_HISTORY = "SpHistory" -- 家族历史：家族历史滚动面板
uiKin.EDT_HISTORY = "EdtHistory" -- 家族历史：家族历史编辑框

uiKin.BTN_PAGE_CMLIST = "BtnPageCmlist" -- 家族招募标签页按钮
uiKin.PAGE_CMLIST = "PageCmlist" -- 家族招募标签页
uiKin.BTN_CHECK_LEVEL = "BtnChecklevel" -- 家族招募：等级要求CheckBox
uiKin.BTN_CHECK_WEALTH = "BtnCheckwealth" -- 家族招募：财富要求CheckBox
uiKin.BTN_CHECK_AUTO_AGREE = "BtnCheckAutoAgree" -- 家族招募：同意自动申请CheckBox
uiKin.BTN_ADD_LEVEL = "BtnAddlevel" -- 家族招募：增加等级Btn
uiKin.BTN_SUB_LEVEL = "BtnSublevel" -- 家族招募：减少等级Btn
uiKin.BTN_ADD_WEALTH = "BtnAddwealth" -- 家族招募：增加财富Btn
uiKin.BTN_SUB_WEALTH = "BtnSubwealth" -- 家族招募：减少财富Btn
uiKin.BTN_CLOSE_RECRUIT = "BtnCloserecruit" -- 家族招募：关闭招募Btn
uiKin.BTN_RELEASE_RECRUIT = "BtnRecruit" -- 家族招募：发布招募Btn
uiKin.BTN_REFUSE = "BtnRefuse" -- 家族招募：拒绝申请Btn
uiKin.BTN_AGREE = "BtnAgree" -- 家族招募：招入家族Btn
uiKin.BTN_CHAT = "BtnChat" -- 家族招募：与其交谈Btn
uiKin.EDT_LEVEL = "EdtLevel" -- 家族招募：等级
uiKin.EDT_WEALTH = "EdtWealth" -- 家族招募：财富
uiKin.SP_APPLY = "SpList" -- 家族招募：申请成员滑动面板
uiKin.LST_APPLY = "Lstlist" -- 家族招募：申请成员列表控件
uiKin.BTN_REC_EDIT = "BtnRecEdit" -- 家族招募：编辑
uiKin.BTN_REC_SAVE = "BtnRecSave" -- 家族招募：保存
uiKin.EDT_REC_ANNOUNCE = "EdtRecAnnounce" -- 家族招募：招募公告Edt
-- end

-- 活动标签页
uiKin.PAGE_KIN_ACTION = "PageKinAction" -- 活动标签页
uiKin.BTN_PAGE_ACTION = "BtnPageKinAction" -- 活动标签页按钮
uiKin.PAGESET_KINACTION = "KinActionPageSet" -- 活动标签页内标签页集

uiKin.BTN_PAGE_ACTIONINFO = "BtnPageActionInfo" -- 活动信息标签页按钮
uiKin.PAGE_ACTIONINFO = "PageActionInfo" -- 活动信息标签页
uiKin.TXT_INFO_ATHLETICS = "TxtInfoAthleticsCurMonth" -- 活动信息：本月竞技
uiKin.TXT_INFO_STAGE = "TxtInfoAthleticsStage" -- 活动信息：竞技阶段
uiKin.TXT_INFO_END = "TxtInfoAthleticsEnd" -- 活动信息：阶段结束时间
uiKin.TXT_INFO_START = "TxtInfoAthleticsStart" -- 活动信息：下次活动开启
uiKin.TXT_INFO_REGISTER = "TxtInfoAthleticsRegister" -- 活动信息：活动报名
uiKin.TXT_INFO_JOIN = "TxtInfoAthleticsJoinNumber" -- 活动信息：当天可参加次数
uiKin.TXT_INFO_POINT = "TxtInfoAthleticsCurMonthPoint" -- 活动信息：本月个人积分
uiKin.TXT_INFO_POINT_SUM = "TxtInfoAthleticsPointSum" -- 活动信息：个人总积分

uiKin.TXT_INFO_SILVER = "TxtInfoCurSilver" -- 活动信息：个人现有银锭
uiKin.TXT_INFO_GOLD = "TxtInfoCurGold" -- 活动信息：个人现有金锭
uiKin.TXT_INFO_CUR_SALARY = "TxtInfoCurWeekSalary" -- 活动信息：本周累计工资
uiKin.TXT_INFO_LAST_SALARY = "TxtInfoLastWeekSalary" -- 活动信息：上周累计工资

uiKin.TXT_INFO_LOCATION = "TxtInfoLocation" -- 活动信息：插旗活动地点
uiKin.TXT_INFO_TIME = "TxtInfoTime" -- 活动信息：插旗活动时间
uiKin.TXT_INFO_COORDINATE = "TxtInfoCoordinate" -- 活动信息：插旗活动坐标

uiKin.TXT_CHALLENG_LOCATION = "TxtChallengeAddr" -- 活动信息：家族挑战令地点
uiKin.TXT_CHALLENG_NPC = "TxtChallengeNpc" -- 活动信息：家族挑战令NPC
uiKin.TXT_CHALLENG_TIMES = "TxtChallengeTimes" -- 活动信息：家族挑战令次数

uiKin.SP_INFO_EVENT = "SpInfoEvent" -- 活动信息：滑动面板
uiKin.LST_INFO_EVENT = "LstInfoEvent" -- 活动信息：活动-工资列表

uiKin.BTN_PAGE_ATHLETICS = "BtnPageActionAthletics" -- 家族竞技标签页按钮
uiKin.PAGE_ATHLETICS = "PageActionAthletics" -- 家族竞技标签页
uiKin.TXT_ATHL_ITEM = "TxtAthleticsItem" -- 家族竞技：本月竞技活动
uiKin.TXT_ATHL_END = "TxtAthleticsStageEnd" -- 家族竞技：阶段结束时间
uiKin.TXT_ATHL_START = "TxtAthleticsStageStart" -- 家族竞技：下次活动开启
uiKin.TXT_ATHL_REGISTER = "TxtAthleticsRegister" -- 家族竞技：活动报名
uiKin.TXT_ATHL_STAGE = "TxtAthleticsStage" -- 家族竞技：竞技阶段
uiKin.TXT_ATHL_KPOINT_SUM = "TxtAthleticsCurMonthKinPointSum" -- 家族竞技：本月家族当前总积分
uiKin.TXT_ATHL_JOIN = "TxtAthleticsJoinNumber" -- 家族竞技：当天可参加次数
uiKin.TXT_ATHL_RANK = "TxtAthleticsKinRank" -- 家族竞技：家族当前排名
uiKin.TXT_ATHL_PERSON_POINT = "TxtAthleticsCurMonthPersonPoint" -- 家族竞技：本月个人积分
uiKin.TXT_ATHL_PPOINT_SUM = "TxtAthleticsPersonPointSum" -- 家族竞技：个人总积分
uiKin.TXT_ATHL_TEAM_INFO = "TxtAthleticsKinInfo" -- 家族竞技：家族战队信息
uiKin.BTN_ATHL_LIST_POINT = "BtnAthleticsListTitlePoint" -- 家族竞技：本月积分
uiKin.BTN_ATHL_LIST_TOTAL_POINT = "BtnAthleticsListTitlePointSum" -- 家族竞技：总积分
uiKin.SP_ATHL = "SpAthleticsList" -- 家族竞技：滑动面板
uiKin.LST_ATHL = "LstAthleticsList" -- 家族竞技：玩家列表
uiKin.BTN_ATHL_ONLINE = "BtnShowOnlineAthl" -- 家族竞技：显示在线成员

uiKin.BTN_PAGE_SALARY = "BtnPageActionSalary" -- 家族工资标签页按钮
uiKin.PAGE_SALARY = "PageActionSalary" -- 家族工资标签页
uiKin.TXT_SALA_SILVER = "TxtSalaryPersonSilver" -- 家族工资：个人现有银锭
uiKin.TXT_SALA_GOLD = "TxtSalaryPersonGold" -- 家族工资：个人现有金锭
uiKin.TXT_SALA_CUR_KIN_SALARY = "TxtKinSalaryCurWeek" -- 家族工资：本周家族累计工资
uiKin.TXT_SALA_LAST_KIN_SALARY = "TxtKinSalaryLastWeek" -- 家族工资：上周家族累计工资
uiKin.TXT_SALA_CUR_SALARY = "TxtSalaryCurWeek" -- 家族工资：本周累计工资
uiKin.TXT_SALA_LAST_SALARY = "TxtSalaryLastWeek" -- 家族工资：上周获得工资
uiKin.BTN_SALA_SALARY = "BtnGetSalary" -- 家族工资：领取工资
uiKin.BTN_SALA_SILVERSHOP = "BtnSalarySilverShop" -- 家族工资：银锭商店
uiKin.BTN_SALA_GOLDSHOP = "BtnSalaryGoldShop" -- 家族工资：金锭商店
uiKin.BTN_SALA_CUR_SALARY = "BtnSalaryListTitleSalary" -- 家族工资：本周工资
uiKin.SP_SALA = "SpSalaryList" -- 家族工资：滑动面板
uiKin.LST_SALA = "LstSalaryList" -- 家族工资：玩家周工资列表
uiKin.SP_SALA_EVENT = "SpSalaryEvent" -- 家族工资：滑动面板
uiKin.LST_SALA_EVENT = "LstSalaryEvent" -- 家族工资：活动-工资列表
uiKin.BTN_SALARY_ONLINE = "BtnShowOnlineSalary" -- 家族工资：显示在线成员
-- end

-- 权限标签页
uiKin.PAGE_KIN_AUTHORITY = "PageKinAuthority" -- 权限标签页
uiKin.BTN_PAGE_AUTHORITY = "BtnPageKinAuthority" -- 权限标签页按钮
uiKin.BTN_MEMBER2REGULAR = "BtnMember2Regular" -- 权限：转为正式
uiKin.BTN_SELF_RETIRE = "BtnSelfRetire" -- 权限：主动退隐
uiKin.BTN_QUIT_KIN = "BtnQuitKin" -- 权限：退出家族
uiKin.BTN_ELECTOR = "BtnElector" -- 权限：族长竞选
uiKin.BTN_SENDKINMAIL = "BtnGroupMail" -- 权限：信件
uiKin.BTN_LEADER_RECALL = "BtnLeaderRecall" -- 权限：族长罢免
uiKin.BTN_APPOINT = "BtnAppoint" -- 权限：职位任免
uiKin.BTN_INHERIT = "BtnInherit" -- 权限：族长传位
uiKin.BTN_RETIRE = "BtnRetire" -- 权限：命令退隐
uiKin.BTN_CHANGE_TITLE = "BtnChgTitle" -- 权限：更改头衔
uiKin.BTN_FIRE = "BtnFire" -- 权限：发起开除
uiKin.BTN_QUIT_SOCIETY = "BtnQuitSociety" -- 权限：退出帮会
uiKin.BTN_REP_MANAGER = "BtnRepManager" -- 权限：仓库管理
uiKin.SP_AUTH = "SpAuthorityMemberList" -- 权限：滑动面板
uiKin.LST_AUTH = "LstAuthorityMemberList" -- 权限：家族成员列表
uiKin.BTN_AUTH_ONLINE = "BtnShowOnlineAuth" -- 权限：显示在线成员
-- end

-- 资金标签页
uiKin.PAGE_KIN_FUND = "PageKinFund" -- 资金标签页
uiKin.BTN_PAGE_FUND = "BtnPageKinFund" -- 资金标签页按钮
uiKin.TXT_KIN_FUND = "TxtKinFund" -- 资金：家族资金 总额（银两）
uiKin.BTN_STORAGE = "BtnStorageFund" -- 资金：存入
uiKin.BTN_WITHDRAWAL = "BtnGetFund" -- 资金：取出
uiKin.BTN_DUMP = "BtnStorageFundToTong" -- 资金：转存帮会
uiKin.TXT_TOTAL_ATTENDANCE = "TxtTotalAttendanceNum" -- 资金：总人次
uiKin.TXT_TOTAL_SALARY = "TxtTotalSalaryNum" -- 资金：总金额
uiKin.EDT_ATTENDANCE_AWARD = "EdtAttendanceAward" -- 资金：每人每次出勤奖励
uiKin.BTN_DELIVER = "BtnDeliverSalary" -- 资金：发放
uiKin.TXT_LAST_SALARY_TIME = "TxtLastSalaryTime" -- 资金：上次发放时间
uiKin.SP_ATTENDANCE = "SpAttendanceList" -- 资金：出勤滑动面板
uiKin.LST_ATTENDANCE = "LstMemberAttendance" -- 资金：出勤列表
uiKin.BTN_CLEAR_ATTENDANCE = "BtnClearAttendanceCount" -- 资金：清空次数
uiKin.BTN_REFRESH_ATTENDANCE = "BtnRefreshAttendanceList" -- 资金：刷新
uiKin.BTN_ADD_ATTENDANCE = "BtnAddAttendanceNum" -- 资金：增加出勤次数
uiKin.BTN_DEC_ATTENDANCE = "BtnDecAttendanceNum" -- 资金：减少出勤次数
uiKin.EDT_ATTENDANCE_NUM = "EdtPlayerAttendanceNum" -- 资金：出勤次数
uiKin.BTN_SAVE_ATTENDANCE = "BtnSaveAttendanceCount" -- 资金：全部保存
-- end

-- 技能标签页
uiKin.PAGE_KIN_SKILL = "PageKinSkill" -- 技能标签页
uiKin.BTN_PAGE_SKILL = "BtnPageKinSkill" -- 技能标签页按钮

uiKin.TXT_SKILL = "TxtSkillInfo" -- 技能 信息文本框
uiKin.PAGESET_SKILL_INFO = "PageSetSkillInfo" -- 技能 信息标签页集
uiKin.PAGE_SKILL_UP = "PageKinSkillUp" -- 技能 信息第一页
uiKin.PAGE_SKILL_DOWN = "PageKinSkillDown" -- 技能 信息第二页
uiKin.BTN_SKILL_UP = "BtnSkillUp" -- 技能 上一页
uiKin.BTN_SKILL_DOWN = "BtnSkillDown" -- 技能 下一页
uiKin.BtnSkillTemp = "BtnSkillTemp" -- 技能 信息按钮项

uiKin.PAGE_SKILL_PART = "PageSetSkillPart" -- 技能 装备标签页集
uiKin.PageSkill = "PageSkill" -- 技能 装备项
uiKin.ImageSkill = "ImageSkill" -- 技能 装备图
uiKin.BtnAddSkill = "BtnAddSkill" -- 技能 增加装备值
uiKin.TxtSkilInfo = "TxtSkilInfo" -- 技能 装备描述
uiKin.BTN_SKILL_OK = "BtnSkillOk" -- 技能 确认投点
uiKin.BTN_SKILL_CANCEL = "BtnSkillCancel" -- 技能 取消投点
uiKin.TXT_REPOINT = "TxtRePoint" -- 技能 剩余点数
uiKin.TxtSkillPart = "TxtSkillPart" -- 技能 装备分类标题
uiKin.ImageEffect = "ImageEffect" -- 技能 装备图
-- end

uiKin.REC_MAX_LEVEL = 150 -- 招募等级要求上限
uiKin.REC_MIN_LEVEL = 10 -- 招募等级要求下限

uiKin.REC_MAX_HONOR = 10 -- 招募财富要求上限
uiKin.REC_MIN_HONOR = 0 -- 招募财富要求下限

uiKin.tbRecMember = {} -- 招募成员
uiKin.nRecPublish = 0 -- 是否发布招募公告
uiKin.nRecLevel = 0 -- 招募等级要求
uiKin.nRecWealth = 0 -- 招募财富要求
uiKin.nAutoAgree = 0 -- 是否自动同意申请

uiKin.nTempSkillCount = 10 --大技能表数目
uiKin.nSkillCount = 15 --小技能表数目

local SORT_TYPE_MENU = { "  按职位排列  ", "  按等级排列  ", "  按票数排序  ", " 按仓库权限排序 " } -- 与KE_KIN_MEMBER_DATA_SORT_TYPE对应
local CHANGE_TITLE_MENU = { " 族长 ", " 副族长 ", " 男成员 ", " 女成员 ", "荣誉成员" }
local SENDMAIL_MENU = { " 族长 ", " 副族长 ", "正式成员", "记名成员", "荣誉成员", "全体家族成员" }

uiKin.MAX_ATTENDANCE_NUM = 1000000

-- 周任务个人贡献度的等级划分
uiKin.MAX_OFFER = 999999
uiKin.PERSONAL_LEVEL = {
  { 70, 140, 210, 280, 350, uiKin.MAX_OFFER },
  { 70, 140, 210, 280, 350, uiKin.MAX_OFFER },
  { 70, 140, 210, 280, 350, uiKin.MAX_OFFER },
  { 70, 140, 210, 280, 350, uiKin.MAX_OFFER },
  { 64, 128, 192, 256, 320, uiKin.MAX_OFFER },
}

-- 周任务家族贡献度的等级划分
uiKin.KIN_LEVEL = {
  { 2800, 5600, 8400, 11200, 14000, uiKin.MAX_OFFER },
  { 2800, 5600, 8400, 11200, 14000, uiKin.MAX_OFFER },
  { 2800, 5600, 8400, 11200, 14000, uiKin.MAX_OFFER },
  { 2800, 5600, 8400, 11200, 14000, uiKin.MAX_OFFER },
  { 2560, 5120, 7680, 10240, 12800, uiKin.MAX_OFFER },
}

uiKin.TITLE = {
  [Kin.FIGURE_CAPTAIN] = "族长",
  [Kin.FIGURE_ASSISTANT] = "副族长",
  [Kin.FIGURE_REGULAR] = "正式成员",
  [Kin.FIGURE_RETIRE] = "荣誉成员",
  [Kin.FIGURE_SIGNED] = "记名成员",
}

uiKin.REPAUTHORITY = {
  [-1] = "禁止操作",
  [0] = "无权限",
  [1] = "无权限",
  [2] = "无权限",
  [3] = "无权限",
  [4] = "管理员",
  [5] = "族长",
}

uiKin.tbChallengePos = { 62240 / 32, 104512 / 32 }

uiKin.CAMP = {
  [Kin.CAMP_JUSTICE] = "宋方",
  [Kin.CAMP_EVIL] = "金方",
  [Kin.CAMP_NEUTRALITY] = "中立",
}

uiKin.MEMBER_MENU_ITEM = { " 密聊 ", " 组队 ", " 加好友 ", " 族长投票 ", " 转为正式", " 职位任免", " 命令隐退", " 发起开除", " 仓库管理" }

-- 排序类型
uiKin.tbSort = {}

uiKin.tbSort[0] = {
  __lt = function(tbA, tbB)
    return tbA.nKey < tbB.nKey
  end,
}

uiKin.tbSort[1] = {
  __lt = function(tbA, tbB)
    return tbA.nKey > tbB.nKey
  end,
}

uiKin.tbSort[7] = {
  __lt = function(tbA, tbB)
    if tbA.nKey == tbB.nKey then
      return tbA.nId < tbB.nId
    end
    return tbA.nKey > tbB.nKey
  end,
}

uiKin.tbSort[2] = uiKin.tbSort[1]
uiKin.tbSort[3] = uiKin.tbSort[1]
uiKin.tbSort[4] = uiKin.tbSort[1]
uiKin.tbSort[5] = uiKin.tbSort[7]
uiKin.tbSort[6] = uiKin.tbSort[7]
uiKin.tbSort[8] = uiKin.tbSort[0]
uiKin.tbSort[9] = uiKin.tbSort[7]
uiKin.tbSort[10] = uiKin.tbSort[7]
uiKin.tbSort[10000] = uiKin.tbSort[7]
uiKin.tbSort[10001] = uiKin.tbSort[0]
uiKin.tbSort[10002] = uiKin.tbSort[7]

-- 家族公告长度
uiKin.nAfficheLen = 420

-- 初始化
function uiKin:Init()
  self.pKin = nil
  self.nCurSortType = 0 -- 当前排序类型
  self.tbMember = {} -- 家族成员表
  self.tbMemberEx = {} -- 家族成员表
  self.tbPlatformInfo = {} -- 家族竞技表
  self.nShowOnlineFlag = 0 -- 是否显示在线用户标记
  self.nAttendanceAward = 0 -- 家族成员出勤奖励
  self.nTotalAttendance = 0 -- 出勤总次数
  self.nTotalSalary = 0 -- 家族资金
  self.nAcctiveSkill = 0
  self.tbAddSkillInfo = {}
  self.nFlag = 0
  self.nAfficheFlag = 0
  self.nBadgeFlage = 0
  self.nShowRequestList = 0
end

function uiKin:WriteStatLog()
  Log:Ui_SendLog("F6家族界面", 1)
end

function uiKin:OnOpen()
  self:WriteStatLog()
  self.pKin = KKin.GetSelfKin()
  if not self.pKin then
    self:ClearData()
  end
  local nSelectBadge = self.pKin.GetKinBadge()
  if not nSelectBadge or nSelectBadge == 0 or not Kin.tbKinBadge[nSelectBadge] then
    Wnd_Show(Ui.UI_KIN, Ui(Ui.UI_KIN).TXT_BADGE)
  else
    Wnd_Hide(Ui.UI_KIN, Ui(Ui.UI_KIN).TXT_BADGE)
    Img_SetImage(self.UIGROUP, self.IMG_BADGE, 1, Kin.tbKinBadge[nSelectBadge].BrightBadge)
  end
  self:Refresh()
  Ui(Ui.UI_SIDEBAR):WndOpenCloseCallback(self.UIGROUP, 1)
  Txt_SetTxt(self.UIGROUP, self.TXT_KIN_TITLE, self.pKin.GetName()) -- 主界面左侧显示 家族名称
  PgSet_ActivePage(self.UIGROUP, self.PAGESET_MAIN, self.PAGE_KIN_MEMBER) -- 设置成员标签页为首页
  PgSet_ActivePage(self.UIGROUP, self.PAGESET_KININFO, self.PAGE_INTRO) -- 设置家族介绍标签页为活动页
  PgSet_ActivePage(self.UIGROUP, self.PAGESET_KINACTION, self.PAGE_ACTIONINFO) -- 设置活动信息标签页为活动页
  PgSet_ActivePage(self.UIGROUP, self.PAGESET_SKILL_INFO, self.PAGE_SKILL_UP) -- 设置技能信息第一页为活动页
end

function uiKin:OnClose()
  if self:CheckSalaryHasModify() == 1 then
    self:PromptSave(2)
    return 0
  end
  self.tbOriginalSalary = {} -- 当前服务器上的工资统计
  self.tbMemberSalary = {} -- 当前改变的表
  Ui(Ui.UI_SIDEBAR):WndOpenCloseCallback(self.UIGROUP, 0)
  UiManager:CloseWindow(Ui.UI_BADGE)
end

function uiKin:ClearData()
  self:Init()
  -- 清空所有列表信息
  Lst_Clear(self.UIGROUP, self.LST_MEMBER) -- 成员：家族成员列表
  Lst_Clear(self.UIGROUP, self.LST_APPLY) -- 信息：招募申请列表
  Lst_Clear(self.UIGROUP, self.LST_INFO_EVENT) -- 活动信息：活动-工资列表
  Lst_Clear(self.UIGROUP, self.LST_ATHL) -- 家族竞技：玩家列表
  Lst_Clear(self.UIGROUP, self.LST_SALA) -- 家族工资：玩家周工资列表
  Lst_Clear(self.UIGROUP, self.LST_SALA_EVENT) -- 家族工资：活动-工资列表
  Lst_Clear(self.UIGROUP, self.LST_AUTH) -- 权限：家族成员列表
  Lst_Clear(self.UIGROUP, self.LST_ATTENDANCE) -- 资金：出勤列表

  -- 信息标签页，家族介绍数据清空
  Txt_SetTxt(self.UIGROUP, self.TXT_KIN_NAME, " ")
  Txt_SetTxt(self.UIGROUP, self.TXT_KIN_LEADER, " ")
  Txt_SetTxt(self.UIGROUP, self.TXT_KIN_SUBLEADER, " ")
  Txt_SetTxt(self.UIGROUP, self.TXT_KIN_CAMP, " ")
  Txt_SetTxt(self.UIGROUP, self.TXT_KIN_REPUTE, " ")
  Txt_SetTxt(self.UIGROUP, self.TXT_KIN_MEMBER_NUM, " ")
  Txt_SetTxt(self.UIGROUP, self.TXT_KIN_MEMBER_NUMEX, " ")
  Txt_SetTxt(self.UIGROUP, self.TXT_YY, " ")
  -- end
  -- 活动标签页
  --活动信息数据清空
  Txt_SetTxt(self.UIGROUP, self.TXT_INFO_ATHLETICS, "本月竞技：")
  TxtEx_SetText(self.UIGROUP, self.TXT_INFO_REGISTER, "活动报名:")
  Txt_SetTxt(self.UIGROUP, self.TXT_INFO_JOIN, "当天可参加次数:")
  Txt_SetTxt(self.UIGROUP, self.TXT_INFO_POINT, "本月个人积分:")
  Txt_SetTxt(self.UIGROUP, self.TXT_INFO_SILVER, "个人现有银锭:")
  Txt_SetTxt(self.UIGROUP, self.TXT_INFO_GOLD, "个人现有金锭:")
  Txt_SetTxt(self.UIGROUP, self.TXT_INFO_CUR_SALARY, "本周个人工资:")
  Txt_SetTxt(self.UIGROUP, self.TXT_INFO_LAST_SALARY, "上周个人工资:")
  TxtEx_SetText(self.UIGROUP, self.TXT_INFO_LOCATION, "地点:")
  Txt_SetTxt(self.UIGROUP, self.TXT_INFO_TIME, "时间：")
  Txt_SetTxt(self.UIGROUP, self.TXT_INFO_COORDINATE, "")
  -- 家族竞技数据清空
  Txt_SetTxt(self.UIGROUP, self.TXT_ATHL_ITEM, "本月竞技活动：")
  TxtEx_SetText(self.UIGROUP, self.TXT_ATHL_REGISTER, "活动报名：")
  Txt_SetTxt(self.UIGROUP, self.TXT_ATHL_KPOINT_SUM, "本月家族当前总积分:")
  Txt_SetTxt(self.UIGROUP, self.TXT_ATHL_JOIN, "当天可参加次数：")
  -- 家族工资数据清空
  Txt_SetTxt(self.UIGROUP, self.TXT_SALA_SILVER, "个人现有银锭:")
  Txt_SetTxt(self.UIGROUP, self.TXT_SALA_GOLD, "个人现有金锭:")
  Txt_SetTxt(self.UIGROUP, self.TXT_SALA_CUR_KIN_SALARY, "本周家族工资:")
  Txt_SetTxt(self.UIGROUP, self.TXT_SALA_LAST_KIN_SALARY, "上周家族工资:")
  Txt_SetTxt(self.UIGROUP, self.TXT_SALA_CUR_SALARY, "本周个人工资:")
  Txt_SetTxt(self.UIGROUP, self.TXT_SALA_LAST_SALARY, "上周个人工资:")
  -- end
  -- 资金标签页
  Txt_SetTxt(self.UIGROUP, self.TXT_KIN_FUND, "0两")
  Txt_SetTxt(self.UIGROUP, self.TXT_TOTAL_ATTENDANCE, "0次")
  Txt_SetTxt(self.UIGROUP, self.TXT_TOTAL_SALARY, "0(两)")
  Txt_SetTxt(self.UIGROUP, self.TXT_LAST_SALARY_TIME, "未发放过出勤奖")
  -- end

  -- 设置按钮的状态（是否可用）
  -- 0 表示为不可用；1表示为可用。初始化时，将按钮权限初始化
  Wnd_SetEnable(self.UIGROUP, self.BTN_MEMBER_REQUESTLIST, 0) -- 申请列表
  Wnd_SetEnable(self.UIGROUP, self.BTN_YY_SET, 0) -- 设置YY号
  Wnd_SetEnable(self.UIGROUP, self.BTN_CHECK_LEVEL, 0) -- 等级要求
  Wnd_SetEnable(self.UIGROUP, self.BTN_CHECK_WEALTH, 0) -- 财富要求
  Wnd_SetEnable(self.UIGROUP, self.BTN_CHECK_AUTO_AGREE, 0) -- 自动同意申请
  Wnd_SetEnable(self.UIGROUP, self.BTN_ADD_LEVEL, 0)
  Wnd_SetEnable(self.UIGROUP, self.BTN_SUB_LEVEL, 0)
  Wnd_SetEnable(self.UIGROUP, self.BTN_ADD_WEALTH, 0)
  Wnd_SetEnable(self.UIGROUP, self.BTN_SUB_WEALTH, 0)
  Wnd_SetEnable(self.UIGROUP, self.BTN_CLOSE_RECRUIT, 0) -- 关闭招募
  Wnd_SetEnable(self.UIGROUP, self.BTN_RELEASE_RECRUIT, 0) -- 发布招募
  Wnd_SetEnable(self.UIGROUP, self.BTN_REC_EDIT, 0) -- 编辑
  Wnd_SetEnable(self.UIGROUP, self.BTN_REC_SAVE, 0) -- 保存
  Wnd_SetEnable(self.UIGROUP, self.BTN_REFUSE, 0) -- 拒绝申请
  Wnd_SetEnable(self.UIGROUP, self.BTN_AGREE, 0) -- 招入家族
  Wnd_SetEnable(self.UIGROUP, self.BTN_SALA_SALARY, 0) -- 领取工资

  Wnd_SetEnable(self.UIGROUP, self.BTN_MEMBER2REGULAR, 0) -- 转为正式
  Wnd_SetEnable(self.UIGROUP, self.BTN_ELECTOR, 0) -- 族长竞选
  Wnd_SetEnable(self.UIGROUP, self.BTN_LEADER_RECALL, 0) -- 族长罢免
  Wnd_SetEnable(self.UIGROUP, self.BTN_APPOINT, 0) -- 职位任免
  Wnd_SetEnable(self.UIGROUP, self.BTN_INHERIT, 0) -- 族长传位
  Wnd_SetEnable(self.UIGROUP, self.BTN_RETIRE, 0) -- 命令退隐
  Wnd_SetEnable(self.UIGROUP, self.BTN_REP_MANAGER, 0) --仓库权限
  Wnd_SetEnable(self.UIGROUP, self.BTN_CHANGE_TITLE, 0) -- 更改头衔
  Wnd_SetEnable(self.UIGROUP, self.BTN_FIRE, 0) -- 发起开除
  Wnd_SetEnable(self.UIGROUP, self.BTN_QUIT_SOCIETY, 0) -- 退出帮会

  Wnd_SetEnable(self.UIGROUP, self.BTN_DUMP, 0) -- 转存帮会
  Wnd_SetEnable(self.UIGROUP, self.BTN_DELIVER, 0) -- 发放
  Wnd_SetEnable(self.UIGROUP, self.BTN_CLEAR_ATTENDANCE, 0) -- 清空次数
  Wnd_SetEnable(self.UIGROUP, self.BTN_ADD_ATTENDANCE, 0) -- 增加出勤次数
  Wnd_SetEnable(self.UIGROUP, self.BTN_DEC_ATTENDANCE, 0) -- 减少出勤次数
  Wnd_SetEnable(self.UIGROUP, self.BTN_SAVE_ATTENDANCE, 0) -- 全部保存

  Wnd_SetEnable(self.UIGROUP, self.EDT_ATTENDANCE_NUM, 0) -- 出勤次数
  Wnd_SetEnable(self.UIGROUP, self.EDT_ATTENDANCE_AWARD, 0) -- 每人每次出勤奖励
  Wnd_SetEnable(self.UIGROUP, self.EDT_REC_ANNOUNCE, 0) -- 招募公告
  Edt_SetTxt(self.UIGROUP, self.EDT_HISTORY, "") -- 家族历史
  Edt_SetTxt(self.UIGROUP, self.EDT_REC_ANNOUNCE, "") -- 招募公告
end

function uiKin:GetSelfKinFigure()
  return me.nKinFigure
end

function uiKin:UpdateButtonState()
  local nCaptainPurview = 0 -- 族长权限范围
  local nAsistanPurview = 0 -- 副族长权限范围
  local nFigure = self:GetSelfKinFigure()
  if nFigure == Kin.FIGURE_CAPTAIN then
    nAsistanPurview = 1
    nCaptainPurview = 1
  elseif nFigure == Kin.FIGURE_ASSISTANT then
    nAsistanPurview = 1
  end
  if nFigure <= Kin.FIGURE_REGULAR and nFigure > 0 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_LEADER_RECALL, 1) --罢免族长，正式成员及以上允许
    Wnd_SetEnable(self.UIGROUP, self.BTN_ELECTOR, 1) --族长竞选，正式成员及以上允许
  else
    Wnd_SetEnable(self.UIGROUP, self.BTN_LEADER_RECALL, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_ELECTOR, 0)
  end
  if nFigure == Kin.FIGURE_RETIRE then
    Btn_SetTxt(self.UIGROUP, self.BTN_SELF_RETIRE, "取消退隐")
  else
    Btn_SetTxt(self.UIGROUP, self.BTN_SELF_RETIRE, "主动退隐")
  end
  Wnd_SetEnable(self.UIGROUP, self.BTN_APPOINT, nCaptainPurview) -- 职位任免
  Wnd_SetEnable(self.UIGROUP, self.BTN_INHERIT, nCaptainPurview) -- 族长传位
  Wnd_SetEnable(self.UIGROUP, self.BTN_QUIT_SOCIETY, nCaptainPurview) -- 退出帮会
  if self.pKin and self.pKin.GetApplyQuitTime() ~= 0 then
    Btn_SetTxt(self.UIGROUP, self.BTN_QUIT_SOCIETY, "取消退出")
  else
    Btn_SetTxt(self.UIGROUP, self.BTN_QUIT_SOCIETY, "退出帮会")
  end
  Wnd_SetEnable(self.UIGROUP, self.BTN_MEMBER_RECRUITMENT, 1)

  Wnd_SetEnable(self.UIGROUP, self.BTN_FIRE, nAsistanPurview)
  Wnd_SetEnable(self.UIGROUP, self.BTN_CHANGE_TITLE, nAsistanPurview)
  Wnd_SetEnable(self.UIGROUP, self.BTN_RETIRE, nAsistanPurview)
  Wnd_SetEnable(self.UIGROUP, self.BTN_REP_MANAGER, nCaptainPurview)
  Wnd_SetEnable(self.UIGROUP, self.BTN_SELF_RETIRE, 1)
  Wnd_SetEnable(self.UIGROUP, self.BTN_SENDKINMAIL, 1)
  Wnd_SetEnable(self.UIGROUP, self.BTN_MEMBER_REPOSITORY, 1) -- 仓库
  Wnd_SetEnable(self.UIGROUP, self.BTN_QUIT_KIN, 1) -- 退出家族

  Wnd_SetEnable(self.UIGROUP, self.BTN_DUMP, nCaptainPurview)
  Wnd_SetEnable(self.UIGROUP, self.BTN_DELIVER, nCaptainPurview)
  Wnd_SetEnable(self.UIGROUP, self.BTN_CLEAR_ATTENDANCE, nAsistanPurview)
  Wnd_SetEnable(self.UIGROUP, self.BTN_SAVE_ATTENDANCE, nAsistanPurview)
  Wnd_SetEnable(self.UIGROUP, self.BTN_ADD_ATTENDANCE, nAsistanPurview)
  Wnd_SetEnable(self.UIGROUP, self.BTN_DEC_ATTENDANCE, nAsistanPurview)
  Wnd_SetEnable(self.UIGROUP, self.EDT_ATTENDANCE_NUM, nAsistanPurview)
  Wnd_SetEnable(self.UIGROUP, self.EDT_ATTENDANCE_AWARD, nAsistanPurview)
  Wnd_SetEnable(self.UIGROUP, self.BTN_YY_SET, nAsistanPurview)
  Wnd_SetEnable(self.UIGROUP, self.EDT_REC_ANNOUNCE, 0)
  Wnd_SetEnable(self.UIGROUP, self.BTN_REC_EDIT, nAsistanPurview)
  Wnd_SetEnable(self.UIGROUP, self.BTN_REC_SAVE, nAsistanPurview)
end

function uiKin:UpdateNotePage()
  -- 使按钮处于 按下\未按下 状态
  Btn_Check(self.UIGROUP, self.BTN_AFFICHE, 0)
  --	Btn_Check(self.UIGROUP, self.BTN_PAGE_HISTORY, 0);
  --	Edt_SetTxt(self.UIGROUP, self.EDT_AFFICHE, "");
  Btn_Check(self.UIGROUP, self.BTN_CMLIST, 0)
  Edt_SetTxt(self.UIGROUP, self.EDT_REC_ANNOUNCE, "")
end

-- 右键菜单处理
function uiKin:OnListRClick(szWnd, nParam)
  if szWnd and nParam then
    -- LST_APPLY  家族招募申请列表
    if szWnd ~= self.LST_APPLY and szWnd ~= self.LST_INFO_EVENT and szWnd ~= self.LST_SALA_EVENT then
      Lst_SetCurKey(self.UIGROUP, szWnd, nParam)
      if self:GetSelfKinFigure() <= Kin.FIGURE_CAPTAIN then
        DisplayPopupMenu(self.UIGROUP, szWnd, #self.MEMBER_MENU_ITEM, 0, self.MEMBER_MENU_ITEM[1], 1, self.MEMBER_MENU_ITEM[2], 2, self.MEMBER_MENU_ITEM[3], 3, self.MEMBER_MENU_ITEM[4], 4, self.MEMBER_MENU_ITEM[5], 5, self.MEMBER_MENU_ITEM[6], 6, self.MEMBER_MENU_ITEM[7], 7, self.MEMBER_MENU_ITEM[8], 8, self.MEMBER_MENU_ITEM[9], 9)
      else
        DisplayPopupMenu(self.UIGROUP, szWnd, #self.MEMBER_MENU_ITEM - 4, 0, self.MEMBER_MENU_ITEM[1], 1, self.MEMBER_MENU_ITEM[2], 2, self.MEMBER_MENU_ITEM[3], 3, self.MEMBER_MENU_ITEM[4], 4, self.MEMBER_MENU_ITEM[5], 5)
      end
    end
  end
end

function uiKin:OnButtonClick(szWnd, nParam)
  local tbFundParam = {} -- 家族资金参数表
  tbFundParam.tbTable = self
  tbFundParam.fnAccept = self.AcceptFundInput -- 资金输入框处理函数
  tbFundParam.nType = 0
  tbFundParam.tbRange = { 1, 2000000000 }
  if szWnd == self.CLOSE_WINDOW_BUTTON then -- 关闭按钮
    if self:CheckSalaryHasModify() == 1 then
      self:PromptSave(2)
      return 0
    end
    UiManager:CloseWindow(self.UIGROUP) -- 关闭窗口
  elseif szWnd == self.BTN_BADGE then
    -- 家族徽章
    if self.nBadgeFlage == 0 then
      self.nBadgeFlage = 1
      UiManager:OpenWindow(Ui.UI_BADGE)
    else
      self.nBadgeFlage = 0
      UiManager:CloseWindow(Ui.UI_BADGE)
    end
  elseif szWnd == self.BTN_PAGE_MEMBER then
    -- 成员标签页
    self.nCurSortType = Kin.KIN_MEMBER_SORT_FIGURE
    self:Refresh()
  elseif szWnd == self.BTN_AFFICHE then
    -- 详细公告
    if self.nAfficheFlag == 0 then
      self.nAfficheFlag = 1
      UiManager:OpenWindow(Ui.UI_AFFICHE)
    else
      self.nAfficheFlag = 0
      UiManager:CloseWindow(Ui.UI_AFFICHE)
    end
  elseif szWnd == self.BTN_MEMBER_POST then
    -- 按职位
    self.nCurSortType = Kin.KIN_MEMBER_SORT_FIGURE
    self:Refresh()
  elseif szWnd == self.BTN_MEMBER_SECT then
    -- 按门派
    self.nCurSortType = Kin.KIN_MEMBER_TEMPDATA_FACTION
    self:Refresh()
  elseif szWnd == self.BTN_MEMBER_RANK then
    self.nCurSortType = Kin.KIN_MEMBER_SORT_LEVEL
    self:Refresh()
  elseif szWnd == self.BTN_MEMBER_RICH then
    -- 按财富等级
    self.nCurSortType = Kin.KIN_MEMBER_TEMPDATA_HONORRANK
    self:Refresh()
  elseif szWnd == self.BTN_MEMBER_TIME then
    -- 按上次在线时间
    self.nCurSortType = Kin.KIN_MEMBER_TEMPDATA_LASTONLINETIME
    self:Refresh()
  elseif szWnd == self.BTN_MEMBER_REQUESTLIST then
    -- 成员标签页 申请列表 按钮
    self.nShowRequestList = 1 - self.nShowRequestList
    if self.nShowRequestList == 1 then
      UiManager:OpenWindow(Ui.UI_KINREQUESTLIST)
    else
      UiManager:CloseWindow(Ui.UI_KINREQUESTLIST)
    end
  elseif szWnd == self.BTN_MEMBER_REPOSITORY then
    -- 家族仓库
    KinRepository:OpenRequest()
  elseif (szWnd == self.BTN_MEMBER_ONLINE) or (szWnd == self.BTN_AUTH_ONLINE) or (szWnd == self.BTN_ATHL_ONLINE) or (szWnd == self.BTN_SALARY_ONLINE) then
    -- 显示在线成员(选中为1)

    self.nShowOnlineFlag = 1 - self.nShowOnlineFlag
    Btn_Check(self.UIGROUP, self.BTN_MEMBER_ONLINE, self.nShowOnlineFlag)
    Btn_Check(self.UIGROUP, self.BTN_AUTH_ONLINE, self.nShowOnlineFlag)
    Btn_Check(self.UIGROUP, self.BTN_ATHL_ONLINE, self.nShowOnlineFlag)
    Btn_Check(self.UIGROUP, self.BTN_SALARY_ONLINE, self.nShowOnlineFlag)
    self:UpdateMemberList()
  elseif szWnd == self.BTN_PAGE_INFO then
    -- 信息标签页
    PgSet_ActivePage(self.UIGROUP, self.PAGESET_KININFO, self.PAGE_INTRO) -- 设置家族介绍标签页为活动页
  elseif szWnd == self.BTN_YY_SET then
    tbFundParam.szTitle = "设置YY号"
    UiManager:OpenWindow(Ui.UI_TEXTINPUT, tbFundParam, "SetYYNumber")
  elseif szWnd == self.BTN_YY_RUN then
    if YY_Update() == 0 then
      -- 返回金山登录
      local tbMsg = { szMsg = "更新YY失败，请手动下载YY", tbOptTitle = { "确定" } }
      return
    end
    -- 显示更新界面
    UiManager:OpenWindow(Ui.UI_YY_UPDATE, 2, self.pKin.GetYYNumber() or 0)
  elseif szWnd == self.BTN_PAGE_CMLIST or szWnd == uiKin.BTN_MEMBER_RECRUITMENT then
    if szWnd == uiKin.BTN_MEMBER_RECRUITMENT then
      PgSet_ActivePage(self.UIGROUP, self.PAGESET_MAIN, self.PAGE_KIN_INFO) -- 设置成员标签页为首页
      PgSet_ActivePage(self.UIGROUP, self.PAGESET_KININFO, self.PAGE_CMLIST) --设置招募家族标签页
    end
    -- 家族招募
    self:UpdateRecreuiment()
    if self:GetSelfKinFigure() <= Kin.FIGURE_ASSISTANT then
      Wnd_SetEnable(self.UIGROUP, self.BTN_CHECK_LEVEL, 1)
      Wnd_SetEnable(self.UIGROUP, self.BTN_CHECK_WEALTH, 1)
      Wnd_SetEnable(self.UIGROUP, self.BTN_CHECK_AUTO_AGREE, 1)
      Wnd_SetEnable(self.UIGROUP, self.BTN_ADD_LEVEL, 1)
      Wnd_SetEnable(self.UIGROUP, self.BTN_SUB_LEVEL, 1)
      Wnd_SetEnable(self.UIGROUP, self.BTN_ADD_WEALTH, 1)
      Wnd_SetEnable(self.UIGROUP, self.BTN_SUB_WEALTH, 1)
      Wnd_SetEnable(self.UIGROUP, self.EDT_LEVEL, 1)
      Wnd_SetEnable(self.UIGROUP, self.EDT_WEALTH, 1)
      Wnd_SetEnable(self.UIGROUP, self.BTN_RELEASE_RECRUIT, 1)
      Wnd_SetEnable(self.UIGROUP, self.BTN_CLOSE_RECRUIT, 1)
      Wnd_SetEnable(self.UIGROUP, self.EDT_REC_ANNOUNCE, 0)
      Wnd_SetEnable(self.UIGROUP, self.BTN_REC_EDIT, 1)
      Wnd_SetEnable(self.UIGROUP, self.BTN_AGREE, 1)
      Wnd_SetEnable(self.UIGROUP, self.BTN_REFUSE, 1)
    else
      Wnd_SetEnable(self.UIGROUP, self.BTN_CHECK_LEVEL, 0)
      Wnd_SetEnable(self.UIGROUP, self.BTN_CHECK_WEALTH, 0)
      Wnd_SetEnable(self.UIGROUP, self.BTN_CHECK_AUTO_AGREE, 0)
      Wnd_SetEnable(self.UIGROUP, self.BTN_ADD_LEVEL, 0)
      Wnd_SetEnable(self.UIGROUP, self.BTN_SUB_LEVEL, 0)
      Wnd_SetEnable(self.UIGROUP, self.BTN_ADD_WEALTH, 0)
      Wnd_SetEnable(self.UIGROUP, self.BTN_SUB_WEALTH, 0)
      Wnd_SetEnable(self.UIGROUP, self.EDT_LEVEL, 0)
      Wnd_SetEnable(self.UIGROUP, self.EDT_WEALTH, 0)
      Wnd_SetEnable(self.UIGROUP, self.BTN_RELEASE_RECRUIT, 0)
      Wnd_SetEnable(self.UIGROUP, self.BTN_CLOSE_RECRUIT, 0)
      Wnd_SetEnable(self.UIGROUP, self.EDT_REC_ANNOUNCE, 0)
      Wnd_SetEnable(self.UIGROUP, self.BTN_REC_EDIT, 0)
      Wnd_SetEnable(self.UIGROUP, self.BTN_AGREE, 0)
      Wnd_SetEnable(self.UIGROUP, self.BTN_REFUSE, 0)
    end
    self:UpRecruitmentPage()
    Wnd_SetEnable(self.UIGROUP, self.BTN_REC_SAVE, 0)
    -- 族长副族长 功能权限
    -- 增加等级
  elseif (szWnd == self.BTN_ADD_LEVEL) and self:GetSelfKinFigure() <= Kin.FIGURE_ASSISTANT then
    local nLevel = Edt_GetInt(self.UIGROUP, self.EDT_LEVEL)
    if nLevel + 10 <= self.REC_MAX_LEVEL and nLevel + 10 >= self.REC_MIN_LEVEL then
      Edt_SetInt(self.UIGROUP, self.EDT_LEVEL, nLevel + 10)
    else
      Edt_SetInt(self.UIGROUP, self.EDT_LEVEL, self.REC_MAX_LEVEL)
    end
  -- 减少等级
  elseif (szWnd == self.BTN_SUB_LEVEL) and self:GetSelfKinFigure() <= Kin.FIGURE_ASSISTANT then
    local nLevel = Edt_GetInt(self.UIGROUP, self.EDT_LEVEL)
    if nLevel - 10 <= self.REC_MAX_LEVEL and nLevel - 10 >= self.REC_MIN_LEVEL then
      Edt_SetInt(self.UIGROUP, self.EDT_LEVEL, nLevel - 10)
    else
      Edt_SetInt(self.UIGROUP, self.EDT_LEVEL, self.REC_MIN_LEVEL)
    end
  -- 增加财富等级
  elseif (szWnd == self.BTN_ADD_WEALTH) and self:GetSelfKinFigure() <= Kin.FIGURE_ASSISTANT then
    local nLevel = Edt_GetInt(self.UIGROUP, self.EDT_WEALTH)
    if nLevel + 1 <= self.REC_MAX_HONOR and nLevel + 1 >= self.REC_MIN_HONOR then
      Edt_SetInt(self.UIGROUP, self.EDT_WEALTH, nLevel + 1)
    else
      Edt_SetInt(self.UIGROUP, self.EDT_WEALTH, self.REC_MAX_HONOR)
    end
  -- 减少财富等级
  elseif (szWnd == self.BTN_SUB_WEALTH) and self:GetSelfKinFigure() <= Kin.FIGURE_ASSISTANT then
    local nLevel = Edt_GetInt(self.UIGROUP, self.EDT_WEALTH)
    if nLevel - 1 <= self.REC_MAX_HONOR and nLevel - 1 >= self.REC_MIN_HONOR then
      Edt_SetInt(self.UIGROUP, self.EDT_WEALTH, nLevel - 1)
    else
      Edt_SetInt(self.UIGROUP, self.EDT_WEALTH, self.REC_MIN_HONOR)
    end
  -- 自动同意申请
  elseif (szWnd == self.BTN_CHECK_AUTO_AGREE) and self:GetSelfKinFigure() <= Kin.FIGURE_ASSISTANT then
    Btn_Check(self.UIGROUP, self.BTN_CHECK_AUTO_AGREE, 1 - self.nAutoAgree)
    if Btn_GetCheck(self.UIGROUP, self.BTN_CHECK_AUTO_AGREE) == 1 then
      self.nAutoAgree = 1
    else
      self.nAutoAgree = 0
    end
  -- 发布招募
  elseif (szWnd == self.BTN_RELEASE_RECRUIT) and self:GetSelfKinFigure() <= Kin.FIGURE_ASSISTANT then
    self:SwitchRecruit(1)
  -- 关闭招募
  elseif (szWnd == self.BTN_CLOSE_RECRUIT) and self:GetSelfKinFigure() <= Kin.FIGURE_ASSISTANT then
    self:SwitchRecruit(0)
  -- 招募公告 编辑
  elseif (szWnd == self.BTN_REC_EDIT) and self:GetSelfKinFigure() <= Kin.FIGURE_ASSISTANT then
    local cKin = KKin.GetSelfKin()
    if cKin then
      Edt_SetTxt(self.UIGROUP, self.EDT_REC_ANNOUNCE, cKin.GetRecAnnounce())
    end
    Wnd_SetEnable(self.UIGROUP, self.EDT_REC_ANNOUNCE, 1)
    Wnd_SetEnable(self.UIGROUP, self.BTN_REC_SAVE, 1)
  -- 招募公告 保存
  elseif (szWnd == self.BTN_REC_SAVE) and self:GetSelfKinFigure() <= Kin.FIGURE_ASSISTANT then
    local szRecAnnounce = Edt_GetTxt(self.UIGROUP, self.EDT_REC_ANNOUNCE)
    if #szRecAnnounce > Kin.REC_ANNOUNCE_MAX_LEN then
      me.Msg("招募公告字数大于允许的最大长度")
      return 0
    end
    --是否包含敏感字
    if IsNamePass(szRecAnnounce) ~= 1 then
      me.Msg("对不起，您输入的招募公告包含敏感字词，请重新设定")
      return 0
    end
    local tbMsg = {}
    tbMsg.szMsg = "确定要保存招募公告吗？"
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex, szAffiche)
      if nOptIndex == 2 then
        me.CallServerScript({ "KinCmd", "SetRecAnnounce", szRecAnnounce })
      elseif nOptIndex == 1 then
        local cKin = KKin.GetSelfKin()
        if cKin then
          Edt_SetTxt(Ui.UI_KIN, Ui(Ui.UI_KIN).EDT_REC_ANNOUNCE, cKin.GetRecAnnounce())
        end
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, szRecAnnounce)
    Wnd_SetEnable(self.UIGROUP, self.EDT_REC_ANNOUNCE, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_REC_SAVE, 0)
  -- 召入家族
  elseif (szWnd == self.BTN_AGREE) and self:GetSelfKinFigure() <= Kin.FIGURE_ASSISTANT then
    local nKey = Lst_GetCurKey(self.UIGROUP, self.LST_APPLY)
    if nKey == 0 or not self.tbRecMember[nKey] then
      me.Msg("请选择你要任命的人员")
      return 0
    end
    me.CallServerScript({ "KinCmd", "RecruitmentAgree", self.tbRecMember[nKey].szName })
    self:RefreshRecruitment()
  -- 拒绝申请
  elseif (szWnd == self.BTN_REFUSE) and self:GetSelfKinFigure() <= Kin.FIGURE_ASSISTANT then
    local nKey = Lst_GetCurKey(self.UIGROUP, self.LST_APPLY)
    if nKey == 0 or not self.tbRecMember[nKey] then
      me.Msg("请选择你要拒绝的人员")
      return 0
    end
    me.CallServerScript({ "KinCmd", "RecruitmentReject", self.tbRecMember[nKey].szName })
    self:RefreshRecruitment()
  elseif szWnd == self.BTN_CHAT then
    local nMemberId = Lst_GetCurKey(self.UIGROUP, self.LST_APPLY)
    if nMemberId > 0 then
      local szPlayerName = self.tbRecMember[nMemberId].szName
      if szPlayerName then
        if me.szName == szPlayerName then
          me.Msg("不能密聊自己!")
          return 0
        end
        ChatToPlayer(szPlayerName)
      end
    end
  elseif szWnd == self.BTN_PAGE_ACTION then
    PgSet_ActivePage(self.UIGROUP, self.PAGESET_KINACTION, self.PAGE_ACTIONINFO) -- 设置活动信息标签页为活动页
    self:UpdateActionInfo()
    self.nCurSortType = Kin.KIN_MEMBER_SORT_CURWEEK
    self:Refresh()
  elseif szWnd == self.BTN_PAGE_ATHLETICS then
    -- 家族竞技
    self.nCurSortType = Kin.KIN_MEMBER_SORT_PLATFORM_MONTHSCORE
    self:Refresh()
  elseif szWnd == uiKin.BTN_ATHL_LIST_TOTAL_POINT then
    -- 总积分排序
    self.nCurSortType = Kin.KIN_MEMBER_SORT_PLATFORM_TOTALSCORE
    self:Refresh()
  elseif szWnd == uiKin.BTN_ATHL_LIST_POINT then
    -- 本月积分排序
    self.nCurSortType = Kin.KIN_MEMBER_SORT_PLATFORM_MONTHSCORE
    self:Refresh()
  elseif szWnd == self.BTN_PAGE_SALARY then
    -- 家族工资
    self.nCurSortType = Kin.KIN_MEMBER_SORT_CURWEEK
    Btn_SetTxt(self.UIGROUP, self.BTN_SALA_CUR_SALARY, "本周工资")
    self:Refresh()
    -- 当选中 家族工资标签页 时
  elseif szWnd == uiKin.BTN_SALA_CUR_SALARY then
    if self.nCurSortType == Kin.KIN_MEMBER_SORT_CURWEEK then
      self.nCurSortType = Kin.KIN_MEMBER_SORT_LASTWEEK
      Btn_SetTxt(self.UIGROUP, self.BTN_SALA_CUR_SALARY, "上周工资")
    else
      self.nCurSortType = Kin.KIN_MEMBER_SORT_CURWEEK
      Btn_SetTxt(self.UIGROUP, self.BTN_SALA_CUR_SALARY, "本周工资")
    end
    self:Refresh()
  elseif szWnd == self.BTN_SALA_GOLDSHOP then
    -- 金锭商店
    me.CallServerScript({ "ApplyKinSalaryOpenShop", 240 })
  elseif szWnd == self.BTN_SALA_SILVERSHOP then
    -- 银锭商店
    me.CallServerScript({ "ApplyKinSalaryOpenShop", 241 })
  elseif szWnd == self.BTN_SALA_SALARY then
    -- 领取工资
    me.CallServerScript({ "ApplyKinOpenSalary" })
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_PAGE_AUTHORITY then
    self.nCurSortType = Kin.KIN_MEMBER_SORT_VOTE
    self:Refresh()
    -- 权限标签页
  elseif szWnd == self.BTN_CHANGE_TITLE then
    -- 更改头衔
    DisplayPopupMenu(self.UIGROUP, szWnd, 5, 0, CHANGE_TITLE_MENU[1], 1, CHANGE_TITLE_MENU[2], 2, CHANGE_TITLE_MENU[3], 3, CHANGE_TITLE_MENU[4], 4, CHANGE_TITLE_MENU[5], 5)
  elseif szWnd == self.BTN_APPOINT then
    -- 职位任免
    local nMemberId = Lst_GetCurKey(self.UIGROUP, self.LST_AUTH)

    if nMemberId > 0 then
      if self.tbView then
        nMemberId = self.tbView[nMemberId].nId
      end
      local tbMsg = {}
      tbMsg.nOptCount = 2
      if nMemberId == self.pKin.GetAssistant() then
        tbMsg.szMsg = "确定解除 " .. self.tbMember[nMemberId].szName .. " 副族长的任命吗？"
        function tbMsg:Callback(nOptIndex, nMemberId)
          if nOptIndex == 2 then
            me.CallServerScript({ "KinCmd", "FireAssistant", nMemberId })
          end
        end
      else
        tbMsg.szMsg = "确定任命 " .. self.tbMember[nMemberId].szName .. " 为副族长吗？"
        function tbMsg:Callback(nOptIndex, nMemberId)
          if nOptIndex == 2 then
            me.CallServerScript({ "KinCmd", "SetAssistant", nMemberId })
          end
        end
      end
      UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nMemberId)
    end
  elseif szWnd == self.BTN_INHERIT then
    -- 族长传位
    local nMemberId = Lst_GetCurKey(self.UIGROUP, self.LST_AUTH)

    if nMemberId > 0 then
      if self.tbView then
        nMemberId = self.tbView[nMemberId].nId
      end
      local tbMsg = {}
      tbMsg.szMsg = "确定要传位给 " .. self.tbMember[nMemberId].szName .. " 吗？"
      tbMsg.nOptCount = 2
      function tbMsg:Callback(nOptIndex, nMemberId)
        if nOptIndex == 2 then
          me.CallServerScript({ "KinCmd", "ChangeCaptain", nMemberId })
        end
      end
      UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nMemberId)
    end
  elseif szWnd == self.BTN_QUIT_KIN or szWnd == self.BTN_MEMBER_QUIT then
    me.CallServerScript({ "KinCmd", "MemberLeave", 1 })
  elseif szWnd == self.BTN_RETIRE then
    -- 命令退隐
    local nMemberId = Lst_GetCurKey(self.UIGROUP, self.LST_AUTH)

    if nMemberId > 0 then
      if self.tbView then
        nMemberId = self.tbView[nMemberId].nId
      end
      local _, nId = me.GetKinMember()
      local tbMsg = {}
      tbMsg.nOptCount = 2
      if nMemberId == nId then
        tbMsg.szMsg = "你确定要主动退隐吗？"
        function tbMsg:Callback(nOptIndex, nMemberId)
          if nOptIndex == 2 then
            me.CallServerScript({ "KinCmd", "MemberRetire", nMemberId })
          end
        end
      else
        tbMsg.szMsg = "你确定要命令 " .. self.tbMember[nMemberId].szName .. " 退隐吗？"
        function tbMsg:Callback(nOptIndex, nMemberId)
          if nOptIndex == 2 then
            me.CallServerScript({ "KinCmd", "MemberRetire", nMemberId })
          end
        end
      end
      UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nMemberId)
    end
  elseif szWnd == self.BTN_REP_MANAGER then
    local nMemberId = Lst_GetCurKey(self.UIGROUP, self.LST_AUTH)
    if not nMemberId or nMemberId <= 0 then
      me.Msg("请选择要设置权限的成员")
      return
    end
    if self.tbView then
      nMemberId = self.tbView[nMemberId].nId
    end
    me.CallServerScript({ "KinCmd", "ApplySetMemberRepAuthority", nMemberId })
  elseif szWnd == self.BTN_SELF_RETIRE then
    -- 主动退隐
    local tbParam = {}
    tbParam.nOptCount = 2
    if me.nKinFigure == Kin.FIGURE_RETIRE then
      tbParam.szMsg = "你确定要取消退隐吗？"
      function tbParam:Callback(nOptIndex)
        if nOptIndex == 2 then
          me.CallServerScript({ "KinCmd", "CancelRetire" })
        end
      end
    else
      tbParam.szMsg = "你确定要主动退隐吗？"
      function tbParam:Callback(nOptIndex)
        if nOptIndex == 2 then
          me.CallServerScript({ "KinCmd", "MemberRetire", nMemberId })
        end
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbParam)
  elseif szWnd == self.BTN_ELECTOR then
    -- 族长竞选
    local nMemberId = Lst_GetCurKey(self.UIGROUP, self.LST_AUTH)

    if nMemberId == 0 then
      me.Msg("请选择你要投票的对象")
      return
    end
    if self.tbView then
      nMemberId = self.tbView[nMemberId].nId
    end
    local tbMsg = {}
    tbMsg.szMsg = "你确定要投票给 " .. self.tbMember[nMemberId].szName .. " 吗？"
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex, nMemberId)
      if nOptIndex == 2 then
        me.CallServerScript({ "KinCmd", "CaptainVoteBallot", nMemberId })
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nMemberId)
  elseif szWnd == self.BTN_LEADER_RECALL then
    -- 族长罢免
    local tbMsg = {}
    tbMsg.szMsg = "你确定发起族长罢免吗？"
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex)
      if nOptIndex == 2 then
        me.CallServerScript({ "KinCmd", "FireCaptainInit" })
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
  elseif szWnd == self.BTN_QUIT_SOCIETY then
    -- 退出帮会
    local tbMsg = {}
    if self.pKin and self.pKin.GetApplyQuitTime() ~= 0 then
      tbMsg.szMsg = "你确定要取消退出帮会吗？"
      tbMsg.nOptCount = 2
      function tbMsg:Callback(nOptIndex)
        if nOptIndex == 2 then
          me.CallServerScript({ "KinCmd", "CloseQuitTong" })
        end
      end
    else
      tbMsg.szMsg = "你确定要发起退出帮会吗？"
      tbMsg.nOptCount = 2
      function tbMsg:Callback(nOptIndex)
        if nOptIndex == 2 then
          me.CallServerScript({ "KinCmd", "LeaveTong", 1 })
        end
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
  elseif szWnd == uiKin.BTN_SENDKINMAIL then
    -- 信件
    DisplayPopupMenu(self.UIGROUP, szWnd, 6, 0, SENDMAIL_MENU[1], 1, SENDMAIL_MENU[2], 2, SENDMAIL_MENU[3], 3, SENDMAIL_MENU[4], 4, SENDMAIL_MENU[5], 5, SENDMAIL_MENU[6], 6)
  elseif szWnd == self.BTN_FIRE then
    -- 发起开除
    local nMemberId = Lst_GetCurKey(self.UIGROUP, self.LST_AUTH) -- 获得当前选择玩家在列表中行号

    if nMemberId > 0 then
      if self.tbView then
        nMemberId = self.tbView[nMemberId].nId
      end
      local tbMsg = {}
      tbMsg.szMsg = "确定要将 " .. self.tbMember[nMemberId].szName .. " 开除吗？"
      tbMsg.nOptCount = 2
      function tbMsg:Callback(nOptIndex, nMemberId)
        if nOptIndex == 2 then
          me.CallServerScript({ "KinCmd", "MemberKickInit", nMemberId })
        end
      end
      UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nMemberId)
    end
  elseif szWnd == uiKin.BTN_MEMBER2REGULAR then
    -- 转为正式
    local nMemberId = Lst_GetCurKey(self.UIGROUP, self.LST_AUTH)

    if not nMemberId or nMemberId == 0 then
      me.Msg("请选择要转正的记名成员")
      return
    end
    if self.tbView then
      nMemberId = self.tbView[nMemberId].nId
    end
    me.CallServerScript({ "KinCmd", "Member2Regular", me.dwKinId, nMemberId })
  elseif szWnd == self.BTN_PAGE_FUND then
    -- 资金标签页
    self.nCurSortType = Kin.KIN_MEMBER_SORT_ATTENDANCE
    self:Refresh()
  elseif szWnd == self.BTN_DUMP then
    tbFundParam.szTitle = "转存帮会"
    UiManager:OpenWindow(Ui.UI_TEXTINPUT, tbFundParam, "StorageFundToTong")
  elseif szWnd == self.BTN_STORAGE then
    tbFundParam.szTitle = "资金存入"
    UiManager:OpenWindow(Ui.UI_TEXTINPUT, tbFundParam, "AddFund")
  elseif szWnd == self.BTN_WITHDRAWAL then
    tbFundParam.szTitle = "资金取出"
    UiManager:OpenWindow(Ui.UI_TEXTINPUT, tbFundParam, "TakeFund")
  elseif szWnd == self.BTN_REFRESH_ATTENDANCE then
    -- 刷新按钮
    self:Refresh()
  elseif szWnd == self.BTN_ADD_ATTENDANCE then
    -- 增加出勤次数
    self:AddAttendanceNum()
  elseif szWnd == self.BTN_DEC_ATTENDANCE then
    -- 减少出勤次数
    self:DecAttendanceNum()
  elseif szWnd == self.BTN_REFRESH_ATTENDANCE then
    -- 刷新出勤列表
    self:RefreshSalaryList()
  elseif szWnd == self.BTN_CLEAR_ATTENDANCE then
    -- 清楚出勤次数
    self:ClearSalaryCount()
  elseif szWnd == self.BTN_SAVE_ATTENDANCE then
    -- 保存出勤次数
    self:SaveAllSalaryCount()
  elseif szWnd == self.BTN_DELIVER then
    self:SendSalary()
  elseif szWnd == self.BTN_PAGE_SKILL then
    -- 技能标签页
    if self.nFlag == 0 then
      self.nFlag = 1
      self.nAcctiveSkill = 1
      self:UpdateSkillList()
      Btn_Check(self.UIGROUP, self.BtnSkillTemp .. 1, 1)
      Wnd_SetEnable(self.UIGROUP, self.BTN_SKILL_UP, 0)
    end

    self:UpdateKinSkill()
  elseif szWnd == self.BTN_SKILL_DOWN then
    -- 技能 下一页
    Wnd_SetEnable(self.UIGROUP, self.BTN_SKILL_UP, 1)
    Wnd_SetEnable(self.UIGROUP, self.BTN_SKILL_DOWN, 0)
  elseif szWnd == self.BTN_SKILL_UP then
    -- 技能 上一页
    Wnd_SetEnable(self.UIGROUP, self.BTN_SKILL_UP, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_SKILL_DOWN, 1)
  elseif szWnd == self.BTN_SKILL_OK then
    -- 确认投点
    self:OnSkillOk()
  elseif szWnd == self.BTN_SKILL_CANCEL then
    -- 取消投点
    self:OnSkillCancel()
  else
    for i = 1, self.nTempSkillCount do
      local szBtnName = self.BtnSkillTemp .. i
      if szWnd == szBtnName then
        self.nAcctiveSkill = i
        self:UpdateSkillList()
      end
    end

    for i = 1, self.nTempSkillCount do
      local szBtnName = self.BtnSkillTemp .. i
      if i ~= self.nAcctiveSkill then
        Btn_Check(self.UIGROUP, szBtnName, 0)
      else
        Btn_Check(self.UIGROUP, szBtnName, 1)
      end
    end

    for i = 1, self.nSkillCount do
      local szBtnName = self.BtnAddSkill .. i
      if szWnd == szBtnName then
        self:AddSkill(i)
        self:UpdateSkillList()
      end
    end
  end
end

-- 鼠标掠过列表
function uiKin:OnListOver(szWnd, nItemIndex)
  if (szWnd == self.LST_MEMBER or szWnd == self.LST_ATHL or szWnd == self.LST_AUTH or szWnd == self.LST_ATTENDANCE) and nItemIndex >= 1 then
    local nMemberId = nItemIndex
    if self.tbView then
      nMemberId = self.tbView[nMemberId].nId
    end
    if self.tbMember[nMemberId] then
      local szPlayer = self.tbMember[nMemberId].szName
      local nFaction = self.tbMember[nMemberId].nFaction
      local nLevel = self.tbMember[nMemberId].nLevel
      local nHonor = self.tbMember[nMemberId].nHonor
      local nHonorRank = self.tbMember[nMemberId].nHonorRank
      local nHonorLevel = PlayerHonor:CalcHonorLevel(nHonor, nHonorRank, "money")
      local nSex = self.tbMember[nMemberId].nSex
      local szName = "名字：<color=yellow>" .. szPlayer .. "<color>\n"
      local szTip = "\n"
      local szSex = ""
      local nOnline = self.tbMember[nMemberId].nOnline or 0
      local nGBOnline = self.tbMember[nMemberId].nGBOnline or 0
      if nSex == 0 then
        szSex = "男"
      else
        szSex = "女"
      end
      szTip = szTip .. "性别：<color=yellow>" .. szSex .. "<color>\n"
      szTip = szTip .. "门派：<color=yellow>" .. Player:GetFactionRouteName(nFaction) .. "<color>\n"
      szTip = szTip .. "等级：<color=yellow>" .. nLevel .. "级<color>\n"
      szTip = szTip .. "财富等级：<color=yellow>" .. nHonorLevel .. "级<color>\n"
      if nOnline == 0 and nGBOnline == 1 then
        szTip = szTip .. "<color=125,111,172>跨服中<color>\n"
      end
      Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, szName, szTip)
    end
  end
end

function uiKin:OnMenuItemSelected(szWnd, nItemId, nParam)
  if szWnd == self.BTN_CHANGE_TITLE then
    if (nItemId > 5) or (nItemId < 1) then
      return
    end
    local tbParam = {}
    tbParam.szTitle = "输入新的头衔"
    tbParam.tbTable = self
    tbParam.fnAccept = self.OnChangeTitle
    tbParam.varDefault = ""
    UiManager:OpenWindow(Ui.UI_TEXTINPUT, tbParam, nItemId)
  elseif szWnd == self.BTN_SENDKINMAIL then
    if not nItemId or nItemId > 6 or nItemId <= 0 then
      return
    end
    local tbParam = {}
    tbParam.szMailType = "Kin"
    tbParam.szReceive = SENDMAIL_MENU[nItemId]
    tbParam.nCountNumber = self:GetGroupNumber(nItemId)
    tbParam.nItemId = nItemId
    tbParam.nGroupId = me.GetKinMember()
    if nItemId == 6 then
      tbParam.nGroupType = KIN_MEMBER_ALL -- 全体成员
    else
      tbParam.nGroupType = KIN_SIGLE_FIGUE -- 单个成员
    end
    UiManager:OpenWindow(Ui.UI_GROUPMAILNEW, tbParam)
  elseif szWnd == self.LST_MEMBER or szWnd == self.LST_SALA or szWnd == self.LST_ATHL or szWnd == self.LST_AUTH or szWnd == self.LST_ATTENDANCE then
    local nMemberId = Lst_GetCurKey(self.UIGROUP, szWnd)
    if nMemberId < 0 then
      return 0
    end
    if self.tbView then
      nMemberId = self.tbView[nMemberId].nId
    end
    local szPlayerName = self.tbMember[nMemberId].szName
    if szPlayerName and nItemId > 0 and nItemId <= #self.MEMBER_MENU_ITEM then --要定义一个枚举与每项菜单对应
      if nItemId == 1 then
        if me.szName == szPlayerName then
          me.Msg("不能密聊自己!")
          return 0
        end
        ChatToPlayer(szPlayerName)
      elseif nItemId == 2 then
        if me.szName == szPlayerName then
          me.Msg("不能加自己做队友!")
          return 0
        end
        me.TeamInvite(0, szPlayerName)
      elseif nItemId == 3 then
        if me.szName == szPlayerName then
          me.Msg("不能加自己做好友!")
          return 0
        end
        me.CallServerScript({ "RelationCmd", "AddRelation_C2S", szPlayerName, Player.emKPLAYERRELATION_TYPE_TMPFRIEND })
      elseif nItemId == 4 then
        local nMemberId = Lst_GetCurKey(self.UIGROUP, szWnd)

        if nMemberId == 0 then
          me.Msg("请选择你要投票的对象")
          return
        end
        if self.tbView then
          nMemberId = self.tbView[nMemberId].nId
        end
        local tbMsg = {}
        tbMsg.szMsg = "你确定要投票给 " .. self.tbMember[nMemberId].szName .. " 吗？"
        tbMsg.nOptCount = 2
        function tbMsg:Callback(nOptIndex, nMemberId)
          if nOptIndex == 2 then
            me.CallServerScript({ "KinCmd", "CaptainVoteBallot", nMemberId })
          end
        end
        UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nMemberId)
      elseif nItemId == 5 then
        local nMemberId = Lst_GetCurKey(self.UIGROUP, szWnd)

        if not nMemberId or nMemberId == 0 then
          me.Msg("请选择要转正的记名成员。")
          return
        end
        if self.tbView then
          nMemberId = self.tbView[nMemberId].nId
        end
        me.CallServerScript({ "KinCmd", "Member2Regular", me.dwKinId, nMemberId })
      elseif nItemId == 6 then
        local nMemberId = Lst_GetCurKey(self.UIGROUP, szWnd)

        if not nMemberId or nMemberId == 0 then
          me.Msg("请选择要任免的成员")
          return
        end
        if self.tbView then
          nMemberId = self.tbView[nMemberId].nId
        end
        local tbMsg = {}
        tbMsg.nOptCount = 2
        if nMemberId == self.pKin.GetAssistant() then
          tbMsg.szMsg = "确定解除 " .. self.tbMember[nMemberId].szName .. " 副族长的任命吗？"
          function tbMsg:Callback(nOptIndex, nMemberId)
            if nOptIndex == 2 then
              me.CallServerScript({ "KinCmd", "FireAssistant", nMemberId })
            end
          end
        else
          tbMsg.szMsg = "确定任命 " .. self.tbMember[nMemberId].szName .. " 为副族长吗？"
          function tbMsg:Callback(nOptIndex, nMemberId)
            if nOptIndex == 2 then
              me.CallServerScript({ "KinCmd", "SetAssistant", nMemberId })
            end
          end
        end
        UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nMemberId)
      elseif nItemId == 7 then
        local nMemberId = Lst_GetCurKey(self.UIGROUP, szWnd)

        if not nMemberId or nMemberId == 0 then
          me.Msg("请选择要命令隐退的成员。")
          return
        end
        if self.tbView then
          nMemberId = self.tbView[nMemberId].nId
        end
        local _, nId = me.GetKinMember()
        local tbMsg = {}
        tbMsg.nOptCount = 2
        if nMemberId == nId then
          tbMsg.szMsg = "你确定要主动退隐吗？"
          function tbMsg:Callback(nOptIndex, nMemberId)
            if nOptIndex == 2 then
              me.CallServerScript({ "KinCmd", "MemberRetire", nMemberId })
            end
          end
        else
          tbMsg.szMsg = "你确定要命令 " .. self.tbMember[nMemberId].szName .. " 退隐吗？"
          function tbMsg:Callback(nOptIndex, nMemberId)
            if nOptIndex == 2 then
              me.CallServerScript({ "KinCmd", "MemberRetire", nMemberId })
            end
          end
        end
        UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nMemberId)
      elseif nItemId == 8 then
        local nMemberId = Lst_GetCurKey(self.UIGROUP, szWnd)

        if not nMemberId or nMemberId == 0 then
          me.Msg("请选择要开除的成员。")
          return
        end
        if self.tbView then
          nMemberId = self.tbView[nMemberId].nId
        end
        local tbMsg = {}
        tbMsg.szMsg = "确定要将 " .. self.tbMember[nMemberId].szName .. " 开除吗？"
        tbMsg.nOptCount = 2
        function tbMsg:Callback(nOptIndex, nMemberId)
          if nOptIndex == 2 then
            me.CallServerScript({ "KinCmd", "MemberKickInit", nMemberId })
          end
        end
        UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nMemberId)
      elseif nItemId == 9 then
        local nMemberId = Lst_GetCurKey(self.UIGROUP, szWnd)

        if not nMemberId or nMemberId == 0 then
          me.Msg("请选择要操作仓库权限的成员。")
          return
        end
        if self.tbView then
          nMemberId = self.tbView[nMemberId].nId
        end
        me.CallServerScript({ "KinCmd", "ApplySetMemberRepAuthority", nMemberId })
      end
    end

  -- add 家族招募
  elseif szWnd == self.LST_APPLY then
    local nMemberId = Lst_GetCurKey(self.UIGROUP, self.LST_APPLY)
    if nMemberId < 0 then
      return 0
    end
    local szPlayerName = self.tbRecMember[nMemberId].szName
    if szPlayerName and nItemId > 0 and nItemId <= #self.MEMBER_MENU_ITEM then --要定义一个枚举与每项菜单对应
      if nItemId == 1 then
        if me.szName == szPlayerName then
          me.Msg("不能密聊自己!")
          return 0
        end
        ChatToPlayer(szPlayerName)
      elseif nItemId == 2 then
        if me.szName == szPlayerName then
          me.Msg("不能加自己做队友!")
          return 0
        end
        me.TeamInvite(0, szPlayerName)
      elseif nItemId == 3 then
        if me.szName == szPlayerName then
          me.Msg("不能加自己做好友!")
          return 0
        end
        me.CallServerScript({ "RelationCmd", "AddRelation_C2S", szPlayerName, Player.emKPLAYERRELATION_TYPE_TMPFRIEND })
      elseif nItemId == 4 then
        me.Msg("不能给申请加入的人投票!")
        return 0
      else
        me.Msg("不能对自己进行操作!")
        return 0
      end
    end
  end
end

function uiKin:GetGroupNumber(nGroupType)
  --	local nRegular = 0	    --正式成员
  --	local nSigned = 0		--记名成员
  --	local nRetire = 0		--荣誉成员
  --	local nCaptain = 0		--族长称号
  --	local nAssistant = 0	--副族长称号

  if not self.pKin then
    UiManager:CloseWindow(self.UIGROUP)
    return 0
  end

  local nRetCount = 0
  local nRegular, nSigned, nRetire, nCaptain, nAssistant = self.pKin.GetMemberCount()
  if nGroupType == 1 then
    nRetCount = nCaptain
  elseif nGroupType == 2 then
    nRetCount = nAssistant
  elseif nGroupType == 3 then
    nRetCount = nRegular
  elseif nGroupType == 4 then
    nRetCount = nSigned
  elseif nGroupType == 5 then
    nRetCount = nRetire
  elseif nGroupType == 6 then
    nRetCount = nSigned + nRetire + nRegular
  end
  if nGroupType == 3 then
    if me.nKinFigure <= nGroupType then
      nRetCount = nRetCount - 1
    end
  elseif me.nKinFigure == nGroupType or nGroupType == 6 then
    nRetCount = nRetCount - 1
  end
  if nRetCount < 0 then
    nRetCount = 0
  end
  return nRetCount
end

function uiKin:Refresh()
  if self:CheckSalaryHasModify() == 1 then
    self:PromptSave(1)
    return 0
  end
  KKin.ApplyBaseInfo()
  if self.nCurSortType < 10000 then
    KKin.ApplyMemberData(self.nCurSortType)
  end
  KKin.ApplyWeeklyTaskInfo()
  KKin.ApplyKinBuildFlagInfo()
  me.CallServerScript({ "KinCmd", "RefreshSkillInfo", me.dwKinId })
end

function uiKin:OnChangeTitle(szTitle, nTitleType)
  if KUnify.IsNameWordPass(szTitle) ~= 1 then
    me.Msg("称号只能包含中文简繁体字及· 【 】符号！")
    return 0
  end

  me.CallServerScript({ "KinCmd", "ChangeTitle", nTitleType, szTitle })
end

function uiKin:UpdateAddiche(szAffiche)
  Txt_SetTxt(self.UIGROUP, self.TXT_AFFICHE, "")
  local nCountAscii = 0

  if #szAffiche > 0 and #szAffiche <= self.nAfficheLen then
    Txt_SetTxt(self.UIGROUP, self.TXT_AFFICHE, szAffiche)
  else
    for i = 1, self.nAfficheLen do
      if string.byte(szAffiche, i) and string.byte(szAffiche, i) < 128 then
        nCountAscii = nCountAscii + 1
      end
    end
    local nAddCount = 0
    if math.fmod(nCountAscii, 2) == 1 then
      nAddCount = 1
    end
    Txt_SetTxt(self.UIGROUP, self.TXT_AFFICHE, string.sub(szAffiche, 1, self.nAfficheLen - nAddCount) .. "...")
  end
  Btn_Check(self.UIGROUP, self.BTN_AFFICHE, 0)
  self.nAfficheFlag = 0
end

-- 招募公告
function uiKin:UpdateRecAnnounce(szRecAnnounce)
  Edt_SetTxt(self.UIGROUP, self.EDT_REC_ANNOUNCE, szRecAnnounce)
end

function uiKin:UpBallotList(nMemberId, nBallot)
  self.tbMemberEx[nMemberId] = self.tbMemberEx[nMemberId] or {}
  self.tbMemberEx[nMemberId].nBallot = (self.tbMemberEx[nMemberId].nBallot or 0) + nBallot
  self:UpdateMemberList()
end

function uiKin:UpRepAuthorityList(nMemberId, nRepAuthority)
  self.tbMember[nMemberId] = self.tbMember[nMemberId] or {}
  self.tbMember[nMemberId].nRepAuthority = nRepAuthority
  self:UpdateMemberList()
end

function uiKin:UpdateMemberList()
  local tbView = {}
  if not self.pKin then
    self.pKin = KKin.GetSelfKin()
  end
  if not self.pKin then
    -- 清空所有列表信息
    Lst_Clear(self.UIGROUP, self.LST_MEMBER)
    Lst_Clear(self.UIGROUP, self.LST_ATHL)
    Lst_Clear(self.UIGROUP, self.LST_SALA)
    Lst_Clear(self.UIGROUP, self.LST_INFO_EVENT) -- 家族信息：活动-工资列表
    Lst_Clear(self.UIGROUP, self.LST_SALA_EVENT) -- 家族工资：活动-工资列表
    Lst_Clear(self.UIGROUP, self.LST_AUTH)
    Lst_Clear(self.UIGROUP, self.LST_ATTENDANCE)
    return
  end

  for nId in pairs(self.tbMember) do
    if self.tbMember[nId].nOnline == 1 or self.tbMember[nId].nGBOnline == 1 or self.nShowOnlineFlag == 0 then
      local tbItem = {}
      tbItem.nKey = self.tbMember[nId].nData
      tbItem.nId = nId
      --setmetatable(tbItem, self.tbSort[self.nCurSortType]);
      table.insert(tbView, tbItem)
    end
  end

  if self.nCurSortType == Kin.KIN_MEMBER_SORT_ATTENDANCE then --如果是资金标签页则生成临时工资列表
    self.tbMemberSalary = {}
    self.tbOriginalSalary = {}
    if not self.nAttendanceAward then
      self.nAttendanceAward = 0
    end
    self.nTotalAttendance = 0
    self.nTotalSalary = 0
    for nId in pairs(self.tbMember) do
      self.tbMemberSalary[nId] = {}
      self.tbMemberSalary[nId].szName = self.tbMember[nId].szName
      self.tbMemberSalary[nId].nAttendance = self.tbMember[nId].nData
      self.tbOriginalSalary[nId] = {}
      self.tbOriginalSalary[nId].szName = self.tbMember[nId].szName
      self.tbOriginalSalary[nId].nAttendance = self.tbMember[nId].nData
      self.nTotalAttendance = self.nTotalAttendance + self.tbMember[nId].nData
    end
  end
  if self.tbSort[self.nCurSortType] then
    table.sort(tbView, self.tbSort[self.nCurSortType].__lt)
  end
  self.tbView = tbView
  if self.nCurSortType == Kin.KIN_MEMBER_SORT_FIGURE or self.nCurSortType == Kin.KIN_MEMBER_SORT_LEVEL or self.nCurSortType == Kin.KIN_MEMBER_SORT_REPAUTHORITY or self.nCurSortType == Kin.KIN_MEMBER_TEMPDATA_HONORRANK or self.nCurSortType == Kin.KIN_MEMBER_TEMPDATA_FACTION or self.nCurSortType == Kin.KIN_MEMBER_TEMPDATA_LASTONLINETIME then
    if 1 == Btn_GetCheck(self.UIGROUP, self.BTN_PAGE_MEMBER) then
      -- 家族成员列表
      Lst_Clear(self.UIGROUP, self.LST_MEMBER)
    end
    if (self.nCurSortType == Kin.KIN_MEMBER_SORT_FIGURE and 1 == Btn_GetCheck(self.UIGROUP, self.BTN_PAGE_AUTHORITY)) or self.nCurSortType == Kin.KIN_MEMBER_SORT_REPAUTHORITY or self.nCurSortType == Kin.KIN_MEMBER_SORT_VOTE then
      -- 权限标签页 成员列表
      Lst_Clear(self.UIGROUP, self.LST_AUTH)
    end
  elseif (self.nCurSortType == Kin.KIN_MEMBER_SORT_CURWEEK or self.nCurSortType == Kin.KIN_MEMBER_SORT_LASTWEEK) and 1 == Btn_GetCheck(self.UIGROUP, self.BTN_PAGE_SALARY) then
    -- 家族工资
    Lst_Clear(self.UIGROUP, self.LST_SALA)
  elseif (self.nCurSortType == Kin.KIN_MEMBER_SORT_PLATFORM_MONTHSCORE or self.nCurSortType == Kin.KIN_MEMBER_SORT_PLATFORM_TOTALSCORE) and 1 == Btn_GetCheck(self.UIGROUP, self.BTN_PAGE_ATHLETICS) then
    -- 家族竞技 成员列表
    Lst_Clear(self.UIGROUP, self.LST_ATHL)
  elseif (self.nCurSortType == Kin.KIN_MEMBER_SORT_ATTENDANCE) and 1 == Btn_GetCheck(self.UIGROUP, self.BTN_PAGE_FUND) then
    -- 家族出勤 成员列表
    Lst_Clear(self.UIGROUP, self.LST_ATTENDANCE)
  end
  local nCount = #tbView
  for i = 1, nCount do
    local tbMember = self.tbMember[tbView[i].nId]
    if self.nCurSortType == Kin.KIN_MEMBER_SORT_FIGURE or self.nCurSortType == Kin.KIN_MEMBER_SORT_LEVEL or self.nCurSortType == Kin.KIN_MEMBER_SORT_VOTE or self.nCurSortType == Kin.KIN_MEMBER_SORT_REPAUTHORITY or self.nCurSortType == Kin.KIN_MEMBER_TEMPDATA_HONORRANK or self.nCurSortType == Kin.KIN_MEMBER_TEMPDATA_FACTION or self.nCurSortType == Kin.KIN_MEMBER_TEMPDATA_LASTONLINETIME then
      if 1 == Btn_GetCheck(self.UIGROUP, self.BTN_PAGE_MEMBER) then
        -- 成员标签页：成员列表
        Lst_SetCell(self.UIGROUP, self.LST_MEMBER, i, 0, i) -- 排名
        Lst_SetCell(self.UIGROUP, self.LST_MEMBER, i, 1, tbMember.szName) -- 名字
        Lst_SetCell(self.UIGROUP, self.LST_MEMBER, i, 2, self:GetTitle(tbMember.nFigure)) -- 职位
        Lst_SetCell(self.UIGROUP, self.LST_MEMBER, i, 3, Player:GetFactionRouteName(tbMember.nFaction)) -- 门派
        Lst_SetCell(self.UIGROUP, self.LST_MEMBER, i, 4, tbMember.nLevel) -- 等级
        local nHonorLevel = PlayerHonor:CalcHonorLevel(tbMember.nHonor, tbMember.nHonorRank, "money")
        Lst_SetCell(self.UIGROUP, self.LST_MEMBER, i, 5, nHonorLevel) -- 财富等级
        Lst_SetCell(self.UIGROUP, self.LST_MEMBER, i, 6, self:GetLastOnline(tbMember.nLogOutTime)) -- 上次在线时间

        if tbMember.nOnline == 0 and tbMember.nGBOnline == 0 then
          Lst_SetLineColor(self.UIGROUP, self.LST_MEMBER, i, 0x00808080)
        elseif tbMember.nOnline == 0 and tbMember.nGBOnline == 1 then
          Lst_SetLineColor(self.UIGROUP, self.LST_MEMBER, i, 0x007d6fac) -- 全局服在线
        end
      end
      if (self.nCurSortType == Kin.KIN_MEMBER_SORT_FIGURE and 1 == Btn_GetCheck(self.UIGROUP, self.BTN_PAGE_AUTHORITY)) or self.nCurSortType == Kin.KIN_MEMBER_SORT_REPAUTHORITY or self.nCurSortType == Kin.KIN_MEMBER_SORT_VOTE then
        Lst_SetCell(self.UIGROUP, self.LST_AUTH, i, 0, i)
        Lst_SetCell(self.UIGROUP, self.LST_AUTH, i, 1, tbMember.szName)
        Lst_SetCell(self.UIGROUP, self.LST_AUTH, i, 2, self:GetTitle(tbMember.nFigure))
        Lst_SetCell(self.UIGROUP, self.LST_AUTH, i, 3, self:GetRepauthority(tbMember.nRepAuthority or 0))
        local nBallot = 0
        if self.tbMemberEx[tbView[i].nId] and self.tbMemberEx[tbView[i].nId].nBallot then
          nBallot = self.tbMemberEx[tbView[i].nId].nBallot
        end
        Lst_SetCell(self.UIGROUP, self.LST_AUTH, i, 4, nBallot)

        if tbMember.nOnline == 0 and tbMember.nGBOnline == 0 then
          Lst_SetLineColor(self.UIGROUP, self.LST_AUTH, i, 0x00808080)
        elseif tbMember.nOnline == 0 and tbMember.nGBOnline == 1 then
          Lst_SetLineColor(self.UIGROUP, self.LST_AUTH, i, 0x007d6fac) -- 全局服在线
        end
      end
    elseif (self.nCurSortType == Kin.KIN_MEMBER_SORT_CURWEEK or self.nCurSortType == Kin.KIN_MEMBER_SORT_LASTWEEK) and 1 == Btn_GetCheck(self.UIGROUP, self.BTN_PAGE_SALARY) then
      -- 家族工资
      Lst_SetCell(self.UIGROUP, self.LST_SALA, i, 0, i)
      Lst_SetCell(self.UIGROUP, self.LST_SALA, i, 1, tbMember.szName)
      Lst_SetCell(self.UIGROUP, self.LST_SALA, i, 2, self:GetSortDataString(tbMember.nData)) -- 本周工资

      if tbMember.nOnline == 0 and tbMember.nGBOnline == 0 then
        -- 家族工资
        Lst_SetLineColor(self.UIGROUP, self.LST_SALA, i, 0x00808080)
      elseif tbMember.nOnline == 0 and tbMember.nGBOnline == 1 then
        Lst_SetLineColor(self.UIGROUP, self.LST_SALA, i, 0x007d6fac) -- 全局服在线
      end
    elseif (self.nCurSortType == Kin.KIN_MEMBER_SORT_PLATFORM_MONTHSCORE or self.nCurSortType == Kin.KIN_MEMBER_SORT_PLATFORM_TOTALSCORE) and 1 == Btn_GetCheck(self.UIGROUP, self.BTN_PAGE_ATHLETICS) then
      -- 家族竞技 成员列表
      Lst_SetCell(self.UIGROUP, self.LST_ATHL, i, 0, i)
      Lst_SetCell(self.UIGROUP, self.LST_ATHL, i, 1, tbMember.szName)
      Lst_SetCell(self.UIGROUP, self.LST_ATHL, i, 2, self:GetSortDataString(tbMember.nData)) -- 本月积分

      if tbMember.nOnline == 0 and tbMember.nGBOnline == 0 then
        Lst_SetLineColor(self.UIGROUP, self.LST_ATHL, i, 0x00808080)
      elseif tbMember.nOnline == 0 and tbMember.nGBOnline == 1 then
        Lst_SetLineColor(self.UIGROUP, self.LST_ATHL, i, 0x007d6fac) -- 全局服在线
      end
    elseif (self.nCurSortType == Kin.KIN_MEMBER_SORT_ATTENDANCE) and 1 == Btn_GetCheck(self.UIGROUP, self.BTN_PAGE_FUND) then
      -- 家族出勤 成员列表
      Lst_SetCell(self.UIGROUP, self.LST_ATTENDANCE, i, 0, i)
      Lst_SetCell(self.UIGROUP, self.LST_ATTENDANCE, i, 1, tbMember.szName)
      Lst_SetCell(self.UIGROUP, self.LST_ATTENDANCE, i, 2, self:GetSortDataString(tbMember.nData))

      if tbMember.nOnline == 0 and tbMember.nGBOnline == 0 then
        Lst_SetLineColor(self.UIGROUP, self.LST_ATTENDANCE, i, 0x00808080)
      elseif tbMember.nOnline == 0 and tbMember.nGBOnline == 1 then
        Lst_SetLineColor(self.UIGROUP, self.LST_ATTENDANCE, i, 0x007d6fac) -- 全局服在线
      end
    end
  end
end

function uiKin:GetLastOnline(nTime)
  if nTime <= 0 then
    return "未知"
  end
  local szTime = "0分钟"
  local nMin = 0
  local nHour = 0
  local nDay = 0
  nTime = GetTime() - nTime
  nMin = math.floor(nTime / 60) -- 计算出分钟
  nHour = math.floor(nMin / 60) -- 计算出小时
  nDay = math.floor(nHour / 24) -- 计算出天数

  if nDay == 0 then
    -- 离线时间在一天之内
    if nHour == 0 then
      szTime = string.format("%d分钟前", nMin)
    else
      szTime = string.format("%d小时前", nHour)
    end
  else
    -- 离线时间超过一天
    szTime = string.format("%d天前", nDay)
  end
  return szTime
end

function uiKin:GetTitle(nData)
  return self.TITLE[nData] or nData
end

function uiKin:GetRepauthority(nData)
  return self.REPAUTHORITY[nData] or nData
end

function uiKin:GetSortDataString(nData)
  local szStr = ""
  if self.nCurSortType == Kin.KIN_MEMBER_SORT_FIGURE then
    szStr = szStr .. self.TITLE[nData]
  else -- 等级，票数，贡献度等排序全是直接反映数值
    szStr = szStr .. nData
  end
  return szStr
end

-- 更新基本信息表
function uiKin:UpdateBaseInfo()
  self.pKin = KKin.GetSelfKin()
  if self.pKin then
    self:UpdateButtonState()
  else
    self:Init()
    self:ClearData()
    self.tbMember = {}
    self:UpdateMemberList()
    return
  end
  self.tbMember = {}
  self.tbMemberEx = self.tbMemberEx or {} --无耐之举呀
  if self.nCurSortType == Kin.KIN_MEMBER_SORT_VOTE then
    self.tbMemberEx = {}
  end
  local pMemberIt = self.pKin.GetMemberItor()
  local pMember = pMemberIt.GetCurMember()
  while pMember do
    local nId = pMemberIt.GetCurMemberId()
    assert(nId)
    self.tbMember[nId] = {}
    self.tbMember[nId].szName = pMember.GetName()
    self.tbMember[nId].nFigure = pMember.GetFigure()
    self.tbMember[nId].nOnline = pMember.GetOnline()
    self.tbMember[nId].nGBOnline = pMember.GetGBOnline() --是否全局服在线
    self.tbMember[nId].nLevel = pMember.GetLevel()
    self.tbMember[nId].nHonorRank = pMember.GetHonorRank()
    self.tbMember[nId].nHonor = pMember.GetHonor()
    self.tbMember[nId].nFaction = pMember.GetFaction()
    self.tbMember[nId].nSex = pMember.GetSex()
    self.tbMember[nId].nLogOutTime = pMember.GetLastLogOutTime()

    local nMonthNow = tonumber(GetLocalDate("%m"))
    local nMemGrade = 0
    local nMonth = pMember.GetKinGameMonth()
    if nMonthNow == nMonth then
      nMemGrade = pMember.GetKinGameGrade()
    end

    if self.nCurSortType == Kin.KIN_MEMBER_SORT_FIGURE then
      self.tbMember[nId].nData = pMember.GetFigure()
    elseif self.nCurSortType == Kin.KIN_MEMBER_SORT_LEVEL then
      self.tbMember[nId].nData = pMember.GetLevel()
    elseif self.nCurSortType == Kin.KIN_MEMBER_SORT_VOTE then
      self.tbMember[nId].nData = pMember.GetBallot()
      self.tbMemberEx[nId] = self.tbMemberEx[nId] or {}
      self.tbMemberEx[nId].nBallot = pMember.GetBallot()
    elseif self.nCurSortType == Kin.KIN_MEMBER_SORT_CURWEEK then
      self.tbMember[nId].nData = pMember.GetSalaryCurWeek()
    elseif self.nCurSortType == Kin.KIN_MEMBER_SORT_LASTWEEK then
      self.tbMember[nId].nData = pMember.GetSalaryLastWeek()
    elseif self.nCurSortType == Kin.KIN_MEMBER_SORT_PLATFORM_MONTHSCORE then
      self.tbMember[nId].nData = nMemGrade
    elseif self.nCurSortType == Kin.KIN_MEMBER_SORT_PLATFORM_TOTALSCORE then
      self.tbMember[nId].nData = nMemGrade
    elseif self.nCurSortType == Kin.KIN_MEMBER_SORT_ATTENDANCE then
      self.tbMember[nId].nData = pMember.GetAttendance()
    elseif self.nCurSortType == Kin.KIN_MEMBER_SORT_REPAUTHORITY then
      self.tbMember[nId].nData = pMember.GetFigure() --注意这个违背其他项（刷的仓库权限，确以成员类型为序）
      --self.tbMember[nId].nData = pMember.GetRepAuthority();
      self.tbMember[nId].nRepAuthority = pMember.GetRepAuthority()
    elseif self.nCurSortType == Kin.KIN_MEMBER_TEMPDATA_HONORRANK then --临时表
      local nHonorLevel = PlayerHonor:CalcHonorLevel(pMember.GetHonor(), pMember.GetHonorRank(), "money")
      self.tbMember[nId].nData = nHonorLevel
    elseif self.nCurSortType == Kin.KIN_MEMBER_TEMPDATA_FACTION then --临时表
      self.tbMember[nId].nData = pMember.GetFaction()
    elseif self.nCurSortType == Kin.KIN_MEMBER_TEMPDATA_LASTONLINETIME then
      self.tbMember[nId].nData = pMember.GetLastLogOutTime()
    end
    pMember = pMemberIt.NextMember()
  end

  if self.nCurSortType == Kin.KIN_MEMBER_SORT_VOTE then
    self.nCurSortType = Kin.KIN_MEMBER_SORT_REPAUTHORITY
    self:Refresh()
    return
  end

  self:UpdateMemberList()

  Txt_SetTxt(self.UIGROUP, self.TXT_KIN_TITLE, self.pKin.GetName()) -- 主界面左侧显示 家族名称
  Txt_SetTxt(self.UIGROUP, self.TXT_KIN_NAME, self.pKin.GetName())
  local nLeader = self.pKin.GetCaptain()
  if self.tbMember[nLeader] then
    Txt_SetTxt(self.UIGROUP, self.TXT_KIN_LEADER, self.tbMember[nLeader].szName)
  end

  local nLeaderEx = self.pKin.GetAssistant()
  if self.tbMember[nLeaderEx] then
    Txt_SetTxt(self.UIGROUP, self.TXT_KIN_SUBLEADER, self.tbMember[nLeaderEx].szName)
  else
    Txt_SetTxt(self.UIGROUP, self.TXT_KIN_SUBLEADER, "")
  end
  local nCamp = self.pKin.GetCamp()
  if nCamp <= 3 and nCamp >= 1 then
    Txt_SetTxt(self.UIGROUP, self.TXT_KIN_CAMP, self.CAMP[nCamp])
  else
    Txt_SetTxt(self.UIGROUP, self.TXT_KIN_CAMP, "")
  end
  Txt_SetTxt(self.UIGROUP, self.TXT_KIN_REPUTE, self.pKin.GetTotalRepute())

  local nRegular, _, nRetire = self.pKin.GetMemberCount()
  Txt_SetTxt(self.UIGROUP, self.TXT_KIN_MEMBER_NUM, tostring(nRegular))
  Txt_SetTxt(self.UIGROUP, self.TXT_KIN_MEMBER_NUMEX, tostring(nRetire))

  self:UpdateAddiche(self.pKin.GetAnnounce())
  local nFund = self.pKin.GetMoneyFund()
  local szFund = Item:FormatMoney(nFund)
  Txt_SetTxt(self.UIGROUP, self.TXT_KIN_FUND, szFund)
  local nLastSalaryTime = self.pKin.GetLastSalaryTime()
  if nLastSalaryTime > 0 then
    local tbTempTime = os.date("*t", nLastSalaryTime)
    Txt_SetTxt(self.UIGROUP, self.TXT_LAST_SALARY_TIME, string.format("%s年%s月%s日%s时%s分", tbTempTime.year, tbTempTime.month, tbTempTime.day, tbTempTime.hour, tbTempTime.min))
  end

  if self.nCurSortType == Kin.KIN_MEMBER_SORT_ATTENDANCE then
    self:ShowTotalSalaryInfo(self.nAttendanceAward, self.nTotalAttendance)
  end

  -- 更新YY号
  local nYYNumber = self.pKin.GetYYNumber()
  if nYYNumber then
    Txt_SetTxt(self.UIGROUP, self.TXT_YY, string.format("%s", nYYNumber))
  end

  -- 更新家族徽章
  local nKinBadge = self.pKin.GetKinBadge()
  if nKinBadge and nKinBadge ~= 0 then
    Wnd_Hide(self.UIGROUP, self.TXT_BADGE)
    Wnd_Show(self.UIGROUP, self.IMG_BADGE)
    Img_SetImage(self.UIGROUP, self.IMG_BADGE, 1, Kin.tbKinBadge[nKinBadge].BrightBadge)
  end
end

function uiKin:UpdateActionInfo()
  self:UpdateWeeklyActionInfo()
  self:UpdateKinBuildFlag()
  self:UpdateKinPlatformInfo()
  self:UpdateKinChallengeInfo()
end

-- 更新家族挑战活动相关信息
function uiKin:UpdateKinChallengeInfo(nFlag)
  self.pKin = KKin.GetSelfKin()
  if not self.pKin then
    return 0
  end

  local nTimes = self.pKin.GetChallengeTimes()
  local nUsed, nAll = Lib:LoadBits(nTimes, 16, 31), Lib:LoadBits(nTimes, 0, 15)
  Txt_SetTxt(self.UIGROUP, self.TXT_CHALLENG_TIMES, string.format("可挑战次数：%d/%d", nUsed, nAll))
  TxtEx_SetText(self.UIGROUP, self.TXT_CHALLENG_LOCATION, "<a=infor>地点：家族领地<a>")
  TxtEx_SetText(self.UIGROUP, self.TXT_CHALLENG_NPC, string.format("<link=pos:活动NPC：%s, %d, %d, %d>", "萧汜", 2086, unpack(self.tbChallengePos)))
end

-- 更新家族插旗信息
function uiKin:UpdateKinBuildFlag()
  self.pKin = KKin.GetSelfKin()
  if not self.pKin then
    return 0
  end

  local nBuildFlagTime = self.pKin.GetKinBuildFlagOrderTime()
  if nBuildFlagTime == 0 or not nBuildFlagTime then
    -- 家族插旗活动未定
    TxtEx_SetText(self.UIGROUP, self.TXT_INFO_LOCATION, "地点： --")
    Txt_SetTxt(self.UIGROUP, self.TXT_INFO_TIME, "时间：" .. " --")
    Txt_SetTxt(self.UIGROUP, self.TXT_INFO_COORDINATE, "")
    return 0
  end

  local nBuildFlagTimeHour = math.floor(nBuildFlagTime / 60)
  local nBuildFlagTimeMin = nBuildFlagTime % 60
  local szBuildFlagTime = "时间：" .. nBuildFlagTimeHour
  if nBuildFlagTimeMin == 0 then
    szBuildFlagTime = szBuildFlagTime .. ":00"
  else
    szBuildFlagTime = szBuildFlagTime .. ":" .. nBuildFlagTimeMin
  end

  local nBuildFlagMapId = self.pKin.GetKinBuildFlagMapId()
  if nBuildFlagMapId == 0 or not nBuildFlagMapId then
    return 0
  end
  local szMapName = GetMapNameFormId(nBuildFlagMapId)

  local nBuildFlagMapX = self.pKin.GetKinBuildFlagMapX()
  nBuildFlagMapX = math.floor(nBuildFlagMapX)
  if nBuildFlagMapX == 0 or not nBuildFlagMapX then
    return 0
  end

  local nBuildFlagMapY = self.pKin.GetKinBuildFlagMapY()
  nBuildFlagMapY = math.floor(nBuildFlagMapY)
  if nBuildFlagMapY == 0 or not nBuildFlagMapY then
    return 0
  end
  TxtEx_SetText(self.UIGROUP, self.TXT_INFO_LOCATION, string.format("<link=pos:地点：%s, %d, %d, %d>", szMapName, nBuildFlagMapId, nBuildFlagMapX, nBuildFlagMapY))
  Txt_SetTxt(self.UIGROUP, self.TXT_INFO_TIME, szBuildFlagTime)
  Txt_SetTxt(self.UIGROUP, self.TXT_INFO_COORDINATE, "")
end

-- 更新家族活动页面
function uiKin:UpdateWeeklyActionInfo()
  local tbEventType = {
    [1] = { szKey = "SalaryXiaoyao", szTimes = "TimesXiaoyao", szName = "逍遥谷", nRate = 30, nMaxTimes = 70 },
    [2] = { szKey = "SalaryJunying", szTimes = "TimesJunying", szName = "军营副本", nRate = 150, nMaxTimes = 14 },
    [3] = { szKey = "SalaryBaotu", szTimes = "TimesBaotu", szName = "藏宝图", nRate = 210, nMaxTimes = 10 },
    [4] = { szKey = "SalaryJingji", szTimes = "TimesJingji", szName = "趣味竞技", nRate = 420, nMaxTimes = 5 },
    [5] = { szKey = "SalaryDadao", szTimes = "TimesDadao", szName = "官府通缉", nRate = 30, nMaxTimes = 40 },
    [6] = { szKey = "SalaryYijun", szTimes = "TimesYijun", szName = "义军任务", nRate = 15, nMaxTimes = 80 },
    [7] = { szKey = "SalaryGuanqia", szTimes = "TimesGuanqia", szName = "家族关卡", nRate = 600, nMaxTimes = 2 },
    [8] = { szKey = "SalaryZhongzhi", szTimes = "TimesZhongzhi", szName = "家族种植", nRate = 60, nMaxTimes = 20 },
    [9] = { szKey = "SalaryChaqi", szTimes = "TimesChaqi", szName = "家族插旗", nRate = 15, nMaxTimes = 80 },
  }

  self.pKin = KKin.GetSelfKin()
  if not self.pKin then
    return 0
  end

  local nKinSalaryCurWeek = self.pKin.GetSalaryCurWeek()
  local nKinSalaryLastWeek = self.pKin.GetSalaryLastWeek()
  local nKinSalaryCurTask = self.pKin.GetSalaryCurTask()
  local nKinSalaryCurLevel = self.pKin.GetSalaryCurLevel()
  local nKinSalaryLastLevel = self.pKin.GetSalaryLastLevel()

  -- 家族工资标签页
  Txt_SetTxt(self.UIGROUP, self.TXT_SALA_LAST_KIN_SALARY, string.format("上周家族工资：<color=yellow>%s（%s级）<color>", nKinSalaryLastWeek, nKinSalaryLastLevel))
  Txt_SetTxt(self.UIGROUP, self.TXT_SALA_CUR_KIN_SALARY, string.format("本周家族工资：<color=yellow>%s（%s级）<color>", nKinSalaryCurWeek, nKinSalaryCurLevel))

  local _, nMemberId = me.GetKinMember()
  local pMember = self.pKin.GetMember(nMemberId)
  if not pMember then
    return 0
  end

  for i = 1, #tbEventType do
    if i == nKinSalaryCurTask then
      -- 活动信息标签页 活动-工资列表
      Lst_SetCell(self.UIGROUP, self.LST_INFO_EVENT, i, 0, tbEventType[i].szName .. "【热】")
      Lst_SetLineColor(self.UIGROUP, self.LST_INFO_EVENT, i, 0xFF24f537)
      -- 家族工资标签页 活动-工资列表
      Lst_SetCell(self.UIGROUP, self.LST_SALA_EVENT, i, 0, tbEventType[i].szName .. "【热】")
      Lst_SetLineColor(self.UIGROUP, self.LST_SALA_EVENT, i, 0xFF24f537)
    else
      -- 活动信息标签页 活动-工资列表
      Lst_SetCell(self.UIGROUP, self.LST_INFO_EVENT, i, 0, tbEventType[i].szName)
      -- 家族工资标签页 活动-工资列表
      Lst_SetCell(self.UIGROUP, self.LST_SALA_EVENT, i, 0, tbEventType[i].szName)
    end
    Lst_SetCell(self.UIGROUP, self.LST_SALA_EVENT, i, 1, string.format("%s(%s/%s)", pMember["Get" .. tbEventType[i].szKey](), pMember["Get" .. tbEventType[i].szTimes](), tbEventType[i].nMaxTimes))
    Lst_SetCell(self.UIGROUP, self.LST_INFO_EVENT, i, 1, string.format("%s(%s/%s)", pMember["Get" .. tbEventType[i].szKey](), pMember["Get" .. tbEventType[i].szTimes](), tbEventType[i].nMaxTimes))
  end

  local nMemberSalaryCurWeek = pMember.GetSalaryCurWeek()
  local nMemberSalaryLastWeek = pMember.GetSalaryLastWeek()
  local nMemberSalaryYinDing = me.GetTask(2196, 4)
  local nMemberSalaryJinDing = me.GetTask(2196, 3)

  -- 活动信息标签页
  Txt_SetTxt(self.UIGROUP, self.TXT_INFO_SILVER, string.format("个人现有银锭：<color=yellow>%s<color>", nMemberSalaryYinDing))
  Txt_SetTxt(self.UIGROUP, self.TXT_INFO_GOLD, string.format("个人现有金锭：<color=yellow>%s<color>", nMemberSalaryJinDing))
  Txt_SetTxt(self.UIGROUP, self.TXT_INFO_LAST_SALARY, string.format("上周获得工资：<color=yellow>%s<color>", nMemberSalaryLastWeek))
  Txt_SetTxt(self.UIGROUP, self.TXT_INFO_CUR_SALARY, string.format("本周累计工资：<color=yellow>%s<color>", nMemberSalaryCurWeek))

  -- 家族工资标签页
  Txt_SetTxt(self.UIGROUP, self.TXT_SALA_SILVER, string.format("个人现有银锭：<color=yellow>%s<color>", nMemberSalaryYinDing))
  Txt_SetTxt(self.UIGROUP, self.TXT_SALA_GOLD, string.format("个人现有金锭：<color=yellow>%s<color>", nMemberSalaryJinDing))
  Txt_SetTxt(self.UIGROUP, self.TXT_SALA_LAST_SALARY, string.format("上周获得工资：<color=yellow>%s<color>", nMemberSalaryLastWeek))
  Txt_SetTxt(self.UIGROUP, self.TXT_SALA_CUR_SALARY, string.format("本周累计工资：<color=yellow>%s<color>", nMemberSalaryCurWeek))

  local tbList = {
    [0] = { "0%", "200%" },
    [1] = { "10%", "400%" },
    [2] = { "20%", "500%" },
    [3] = { "30%", "600%" },
  }
  local tbLevel = tbList[nKinSalaryCurLevel]
  if tbLevel then
    Wnd_SetTip(self.UIGROUP, self.TXT_INFO_CUR_SALARY, string.format("家族族长领取加成：%s\n普通成员领取加成：%s", tbLevel[2], tbLevel[1]))
    Wnd_SetTip(self.UIGROUP, self.TXT_SALA_CUR_KIN_SALARY, string.format("家族族长领取加成：%s\n普通成员领取加成：%s", tbLevel[2], tbLevel[1]))
  end

  if me.GetTask(2196, 2) == 1 or nMemberSalaryLastWeek <= 0 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_SALA_SALARY, 0)
  else
    Wnd_SetEnable(self.UIGROUP, self.BTN_SALA_SALARY, 1)
  end
end

function uiKin:UpdateMemberData(nSortType)
  if nSortType and nSortType >= 0 then
    self.nCurSortType = nSortType
  end
  self:UpdateBaseInfo()
end

-- 更新家族活动 竞技信息
function uiKin:UpdateKinPlatformInfo()
  self.pKin = KKin.GetSelfKin()
  local tbEventName = { "赛龙舟", "打雪仗", "守护先祖之魂", "夜岚关" }
  local nState = KGblTask.SCGetDbTaskInt(DBTASD_NEWPLATEVENT_SESSION)
  local szEventName = tbEventName[nState] or ""
  Txt_SetTxt(self.UIGROUP, self.TXT_ATHL_ITEM, string.format("【本月竞技活动：%s】", szEventName))
  TxtEx_SetText(self.UIGROUP, self.TXT_ATHL_REGISTER, "活动报名：<link=npcpos:晏若雪,new,3603>")
  local nAttendCount = me.GetTask(2179, 4)
  Txt_SetTxt(self.UIGROUP, self.TXT_ATHL_JOIN, string.format("当天可参加次数：%d", nAttendCount))

  if not self.pKin then
    Txt_SetTxt(self.UIGROUP, self.TXT_ATHL_KPOINT_SUM, "本月家族当前总积分：") -- 本月家族当前总积分
    Txt_SetTxt(self.UIGROUP, self.TXT_ATHL_RANK, "家族当前排名：") -- 家族当前排名
    return 0
  end

  local _, nMemberId = me.GetKinMember()
  local cMember = self.pKin.GetMember(nMemberId)
  local nMonthNow = tonumber(GetLocalDate("%m"))
  local nMemGrade = 0
  if cMember then
    local nMonth = cMember.GetKinGameMonth()
    if nMonthNow == nMonth then
      nMemGrade = cMember.GetKinGameGrade()
    end
  end
  Txt_SetTxt(self.UIGROUP, self.TXT_ATHL_PERSON_POINT, string.format("本月个人积分：%d", nMemGrade))
  local nGrade = self.pKin.GetKinGameGrade()
  local nMonth = self.pKin.GetKinGameMonth()
  if nMonthNow ~= nMonth then
    nGrade = 0
  end
  Txt_SetTxt(self.UIGROUP, self.TXT_ATHL_KPOINT_SUM, string.format("本月家族当前总积分：%d", nGrade))

  --活动首页
  Txt_SetTxt(self.UIGROUP, self.TXT_INFO_ATHLETICS, string.format("本月竞技：%s", szEventName))
  TxtEx_SetText(self.UIGROUP, self.TXT_INFO_REGISTER, "活动报名：<link=npcpos:晏若雪,new,3603>")
  Txt_SetTxt(self.UIGROUP, self.TXT_INFO_JOIN, string.format("当天可参加次数：%d", nAttendCount))
  Txt_SetTxt(self.UIGROUP, self.TXT_INFO_POINT, string.format("本月个人积分：%d", nMemGrade))
end

function uiKin:GetKinEventPlatformData()
  local tbPlatformInfo = EPlatForm:GetKinEventPlatformData()
  return tbPlatformInfo
end

function uiKin:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_KIN_BASE_INFO, self.UpdateBaseInfo },
    { UiNotify.emCOREEVENT_KIN_MEMBER_DATA, self.UpdateMemberData },
    { UiNotify.emCOREEVENT_KIN_ACTION_INFO, self.UpdateActionInfo },
    { UiNotify.emCOREEVENT_KIN_PLATFORM_INFO, self.UpdateKinPlatformInfo },
    { UiNotify.emCOREEVENT_KINRECRUITMENT_STATE, self.UpdatePublish },
    { UiNotify.emCOREEVENT_KINRECRUITMENT, self.UpdateRecruitment },
  }
  return tbRegEvent
end

-- 输入金钱框的统一处理
function uiKin:AcceptFundInput(szMoney, szFunction)
  local nMoney = tonumber(szMoney)
  if not nMoney or 0 == Lib:IsInteger(nMoney) or nMoney <= 0 or nMoney > 2000000000 then
    me.Msg("可操作资金必须在0到20亿之间！")
    return 0
  end
  me.CallServerScript({ "KinCmd", szFunction, nMoney })
end

function uiKin:OnListSel(szWnd, nParam)
  if nParam <= 0 then
    return
  end
  if szWnd == self.LST_APPLY then
    self:UpRecruitmentPage()
  end
  if szWnd == self.LST_ATTENDANCE then
    if self.tbView then
      nParam = self.tbView[nParam].nId
    end
    Edt_SetInt(self.UIGROUP, self.EDT_ATTENDANCE_NUM, self.tbMemberSalary[nParam].nAttendance)
    self:SetModifyAttendanceState(1)
  end
end

function uiKin:SetModifyAttendanceState(nState)
  local nFigure = self:GetSelfKinFigure()
  if nFigure ~= Kin.FIGURE_CAPTAIN and nFigure ~= Kin.FIGURE_ASSISTANT then
    nState = 0
  end
  Wnd_SetEnable(self.UIGROUP, self.BTN_ADD_ATTENDANCE, nState)
  Wnd_SetEnable(self.UIGROUP, self.BTN_DEC_ATTENDANCE, nState)
  Wnd_SetEnable(self.UIGROUP, self.EDT_ATTENDANCE_NUM, nState)
end

function uiKin:AddAttendanceNum()
  local nMemberId = Lst_GetCurKey(self.UIGROUP, self.LST_ATTENDANCE)

  if nMemberId <= 0 then
    return
  end
  local nMemberIdEx = nMemberId
  if self.tbView then
    nMemberId = self.tbView[nMemberId].nId
  end

  if self.tbMemberSalary[nMemberId].nAttendance + 1 > self.MAX_ATTENDANCE_NUM then
    return
  end
  if (self.nTotalAttendance + 1) * self.nAttendanceAward > 2000000000 then
    return
  end
  self.tbMemberSalary[nMemberId].nAttendance = self.tbMemberSalary[nMemberId].nAttendance + 1
  self.nTotalAttendance = self.nTotalAttendance + 1
  self:ShowModifySalary(nMemberIdEx)
end

function uiKin:DecAttendanceNum()
  local nMemberId = Lst_GetCurKey(self.UIGROUP, self.LST_ATTENDANCE)
  if nMemberId <= 0 then
    return
  end
  local nMemberIdEx = nMemberId
  if self.tbView then
    nMemberId = self.tbView[nMemberId].nId
  end
  if self.tbMemberSalary[nMemberId].nAttendance > 0 then
    self.tbMemberSalary[nMemberId].nAttendance = self.tbMemberSalary[nMemberId].nAttendance - 1
    self.nTotalAttendance = self.nTotalAttendance - 1
    self:ShowModifySalary(nMemberIdEx)
  end
end

function uiKin:ShowModifySalary(nIndex, nType)
  if not nType then
    nType = 1
  end
  local nMemberId = 0

  if nIndex > 0 then
    if self.tbView then
      nMemberId = self.tbView[nIndex].nId
    end
    if nMemberId > 0 then
      Lst_SetCell(self.UIGROUP, self.LST_ATTENDANCE, nIndex, 2, self.tbMemberSalary[nMemberId].nAttendance)
      if self.tbMemberSalary[nMemberId].nAttendance ~= self.tbOriginalSalary[nMemberId].nAttendance then
        Lst_SetLineColor(self.UIGROUP, self.LST_ATTENDANCE, nIndex, 0x00ff0000)
      else
        if self.tbMember[nMemberId].nOnline == 0 then
          Lst_SetLineColor(self.UIGROUP, self.LST_ATTENDANCE, nIndex, 0x00808080)
        else
          Lst_SetLineColor(self.UIGROUP, self.LST_ATTENDANCE, nIndex, 0x00ffffff)
        end
      end
      if nType and nType ~= 0 then
        Edt_SetInt(self.UIGROUP, self.EDT_ATTENDANCE_NUM, self.tbMemberSalary[nMemberId].nAttendance)
      end
    end
  end
  self:ShowTotalSalaryInfo(self.nAttendanceAward, self.nTotalAttendance)
end

function uiKin:ShowTotalSalaryInfo(nAttendanceAward, nTotalAttendance)
  Txt_SetTxt(self.UIGROUP, self.TXT_TOTAL_ATTENDANCE, string.format("%s次", nTotalAttendance))
  local nTotalSalary = nAttendanceAward * nTotalAttendance
  local szMoney = Item:FormatMoney(nTotalSalary)
  Txt_SetTxt(self.UIGROUP, self.TXT_TOTAL_SALARY, szMoney .. "（两）")
end

function uiKin:OnEditChange(szWnd, nParam)
  if szWnd == self.EDT_ATTENDANCE_AWARD then
    local nAttendanceAward = Edt_GetInt(self.UIGROUP, self.EDT_ATTENDANCE_AWARD)
    if nAttendanceAward * self.nTotalAttendance > 2000000000 then
      Edt_SetInt(self.UIGROUP, self.EDT_ATTENDANCE_AWARD, self.nAttendanceAward)
      return
    end
    self.nAttendanceAward = nAttendanceAward
    self:ShowTotalSalaryInfo(self.nAttendanceAward, self.nTotalAttendance)
  elseif szWnd == self.EDT_ATTENDANCE_NUM then
    local nMemberId = Lst_GetCurKey(self.UIGROUP, self.LST_ATTENDANCE)
    local nAttendance = Edt_GetInt(self.UIGROUP, self.EDT_ATTENDANCE_NUM)
    if nAttendance > self.MAX_ATTENDANCE_NUM then
      Edt_SetInt(self.UIGROUP, self.EDT_ATTENDANCE_NUM, self.MAX_ATTENDANCE_NUM)
      return
    end
    local nMemberIdEx = nMemberId
    if self.tbView then
      nMemberId = self.tbView[nMemberId].nId
    end
    local nTemp = self.tbMemberSalary[nMemberId].nAttendance
    local nTotalAttendance = self.nTotalAttendance + nAttendance - nTemp
    if nTotalAttendance * self.nAttendanceAward > 2000000000 then
      Edt_SetInt(self.UIGROUP, self.EDT_ATTENDANCE_NUM, self.tbMemberSalary[nMemberId].nAttendance)
      return
    end
    self.tbMemberSalary[nMemberId].nAttendance = nAttendance
    self.nTotalAttendance = nTotalAttendance
    self:ShowModifySalary(nMemberIdEx, 0)
  -- 家族招募
  elseif szWnd == self.EDT_LEVEL then
    local nLevel = Edt_GetInt(self.UIGROUP, self.EDT_LEVEL)
    if nLevel > self.REC_MAX_LEVEL then
      Edt_SetInt(self.UIGROUP, self.EDT_LEVEL, self.REC_MAX_LEVEL)
    end
    if nLevel < self.REC_MIN_LEVEL then
      Edt_SetInt(self.UIGROUP, self.EDT_LEVEL, self.REC_MIN_LEVEL)
    end
  elseif szWnd == self.EDT_WEALTH then
    local nHonor = Edt_GetInt(self.UIGROUP, self.EDT_WEALTH)
    if nHonor > self.REC_MAX_HONOR then
      Edt_SetInt(self.UIGROUP, self.EDT_WEALTH, self.REC_MAX_HONOR)
    end
    if nHonor < self.REC_MIN_HONOR then
      Edt_SetInt(self.UIGROUP, self.EDT_WEALTH, self.REC_MIN_HONOR)
    end
  end
end

--测试数据是否被修改
function uiKin:CheckSalaryHasModify()
  if not self.tbMemberSalary then
    return 0
  end
  for nIndex, tbMember in pairs(self.tbMemberSalary) do
    if tbMember.nAttendance ~= self.tbOriginalSalary[nIndex].nAttendance then
      return 1
    end
  end
  return 0
end

function uiKin:PromptSave(nType)
  local tbMsg = {}
  tbMsg.szMsg = "修改的出勤次数尚未保存，是否先保存"
  function tbMsg:Callback(nOptIndex, uiSelfKin, nType)
    if nOptIndex == 2 then
      uiSelfKin:SaveSalaryCount(nType)
    else
      uiSelfKin:CancelSaveSalaryCount(nType)
    end
  end
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, self, nType)
end

-- 跳转界面或关闭窗口
function uiKin:SaveSalaryCount(nType)
  local tbMemberData = self:GetSendMemberData()
  if tbMemberData then
    me.CallServerScript({ "KinCmd", "SaveSalaryCount", tbMemberData })
  end
  self.tbMemberSalary = nil
  self.tbOriginalSalary = nil
  if nType == 1 then
    self:Refresh()
  elseif nType == 2 then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiKin:CancelSaveSalaryCount(nType)
  self.tbMemberSalary = nil
  self.tbOriginalSalary = nil
  if nType == 1 then
    self:Refresh()
  elseif nType == 2 then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiKin:RefreshSalaryList()
  if self:CheckSalaryHasModify() == 1 then
    self:PromptSave(1)
    return 0
  end
  self:Refresh()
end

-- 清除出清次数信息
function uiKin:ClearSalaryCount()
  local tbMsg = {}
  tbMsg.szMsg = "确定清空所有成员的出勤次数？"
  function tbMsg:Callback(nOptIndex, uiTempKin)
    if nOptIndex == 2 then
      me.CallServerScript({ "KinCmd", "ClearSalaryCount" })
    end
  end
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, self)
end

-- 获取当前出勤统计
function uiKin:GetSendMemberData()
  if not self.tbMemberSalary then
    return nil
  end
  local tbSendMemberData = {}
  for nId, tbMember in pairs(self.tbMemberSalary) do
    tbSendMemberData[nId] = tbMember.nAttendance
  end
  return tbSendMemberData
end

-- 获取初始服务器端同步的出勤统计
function uiKin:GetOrgSendMemberData()
  if not self.tbOriginalSalary then
    return nil
  end
  local tbSendMemberData = {}
  for nId, tbMember in pairs(self.tbOriginalSalary) do
    tbSendMemberData[nId] = tbMember.nAttendance
  end
  return tbSendMemberData
end

-- 点击保存按钮
function uiKin:SaveAllSalaryCount()
  local tbMemberData = self:GetSendMemberData()
  if not tbMemberData then
    return 0
  end
  local tbMsg = {}
  tbMsg.szMsg = "确定保存当前的出勤次数？"
  function tbMsg:Callback(nOptIndex, tbMemberData)
    if nOptIndex == 2 then
      me.CallServerScript({ "KinCmd", "SaveSalaryCount", tbMemberData })
    end
  end
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, tbMemberData)
end

function uiKin:SendSalary()
  if not self.nAttendanceAward or self.nAttendanceAward <= 0 then
    me.Msg("请先设置每人每次金额")
    return 0
  end
  if not self.nTotalAttendance or self.nTotalAttendance == 0 then
    me.Msg("总人次不能为0，不能发放！")
    return 0
  end
  -- 修改了数据
  if self:CheckSalaryHasModify() == 1 then
    local tbMemberData = self:GetSendMemberData()
    if not tbMemberData then
      me.Msg("数据有误！")
      return 0
    end
    local tbMsg = {}
    tbMsg.szMsg = "修改的出勤次数尚未保存，请先保存！确定保存？"
    function tbMsg:Callback(nOptIndex, tbData)
      if nOptIndex == 2 then
        me.CallServerScript({ "KinCmd", "SaveSalaryCount", tbData })
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, tbMemberData)
    return 0
  end
  -- 未修改数据
  local tbMemberData = self:GetOrgSendMemberData()
  if not tbMemberData then
    me.Msg("数据有误！")
    return 0
  end
  local tbMsg = {}
  tbMsg.szMsg = "确定发放玩家出勤奖励？"
  function tbMsg:Callback(nOptIndex, tbData, nAttendanceAward)
    if nOptIndex == 2 then
      me.CallServerScript({ "KinCmd", "ApplySendSalary", nAttendanceAward, tbData })
    end
  end
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, tbMemberData, self.nAttendanceAward)
end

function uiKin:SaveSuccess_C2()
  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    return
  end
  self.tbMemberSalary = nil
  self.tbOriginalSalary = nil
  self:Refresh()
end
function uiKin:RefreshLastOnline_C2(nTime) end

function uiKin:RefreshBadge_C2(nSelectBadge)
  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    return
  end
  Wnd_Hide(self.UIGROUP, self.TXT_BADGE)
  Img_SetImage(self.UIGROUP, self.IMG_BADGE, 1, Kin.tbKinBadge[nSelectBadge].BrightBadge)
end

function uiKin:RefreshFund_C2(nFund)
  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    return
  end
  local szFund = Item:FormatMoney(nFund)
  Txt_SetTxt(self.UIGROUP, self.TXT_KIN_FUND, szFund)
end

function uiKin:ClearPromt_C2()
  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    return
  end
  self.tbMemberSalary = nil
  self.tbOriginalSalary = nil
  self:Refresh()
  local tbMsg = {}
  tbMsg.szMsg = "出勤奖励已经成功发放，是否清空出勤统计？"
  function tbMsg:Callback(nOptIndex, uiTempKin)
    if nOptIndex == 2 then
      me.CallServerScript({ "KinCmd", "ClearSalaryCount" })
    end
  end
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, self)
end

-- 正在资金申请时叛离提示
function uiKin:MemberLeavePromt_C2()
  local tbMsg = {}
  tbMsg.szMsg = "您有取出家族资金的申请，如果现在离开家族将不能获得家族资金，确定要叛离吗？"
  function tbMsg:Callback(nOptIndex)
    if nOptIndex == 2 then
      me.CallServerScript({ "KinCmd", "MemberLeave", 0 })
    end
  end
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, self)
end

-- 有资金转入申请时出帮提示
function uiKin:LeaveTongPromt_C2()
  local tbMsg = {}
  tbMsg.szMsg = "您的家族有资金转入的申请，如果现在退出帮会将不能活的家族资金，确定现在退出吗？"
  function tbMsg:Callback(nOptIndex)
    if nOptIndex == 2 then
      me.CallServerScript({ "KinCmd", "LeaveTong", 0 })
    end
  end
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, self)
end

-- 更新家族技能界面
function uiKin:UpdateKinSkill()
  local tbInfo = Kin.tbKinSkill.tbInfo
  local nSkillOffer = me.GetTask(Kin.TASK_GROUP, Kin.TASK_SKILLOFFER)
  local szTxt = [[  家族技能：%s级 %s/%s
	
	  家族功勋：%s点（领取家族工资同时可获得家族功勋值）
	]]
  if not self.pKin then
    for i = 1, self.nTempSkillCount do
      local szBtn = self.BtnSkillTemp .. i
      Wnd_SetEnable(self.UIGROUP, szBtn, 0)
    end
    Txt_SetTxt(self.UIGROUP, self.TXT_SKILL, string.format(szTxt, "--", "--", "--", nSkillOffer))
    return
  end
  for i = 1, self.nTempSkillCount do
    local szBtn = self.BtnSkillTemp .. i
    if Kin.tbKinSkill.tbSkillInfo[i] then
      Wnd_SetEnable(self.UIGROUP, szBtn, 1)
      if Kin.tbKinSkill.tbInfo[i] and Kin.tbKinSkill.tbInfo[i].szGenreInfo then
        Wnd_SetTip(self.UIGROUP, szBtn, Kin.tbKinSkill.tbInfo[i].szGenreInfo)
      end
    else
      Wnd_SetEnable(self.UIGROUP, szBtn, 0)
    end
  end
  local nLevel = self.pKin.GetSkillLevel()
  local nExp = self.pKin.GetSkillExp()
  local nAllExp = Kin.tbKinSkill.tbLevelExp[nLevel + 1] or 0
  local _, nMemberId = me.GetKinMember()
  local cMember = self.pKin.GetMember(nMemberId)
  if not cMember then
    return 0
  end
  if nAllExp == 0 then
    nExp = "--"
    nAllExp = "--"
  end
  szTxt = string.format(szTxt, nLevel, nExp, nAllExp, nSkillOffer)
  Txt_SetTxt(self.UIGROUP, self.TXT_SKILL, szTxt)
end

-- 加点确认
function uiKin:OnSkillOk()
  for _, tb in pairs(self.tbAddSkillInfo) do
    table.insert(tb, 1, 1)
  end
  me.CallServerScript({ "KinCmd", "AddSkillLevel", self.tbAddSkillInfo })
  self.tbAddSkillInfo = {}
  --self:UpdateSkillList();
end

-- 加点取消
function uiKin:OnSkillCancel()
  self:ClearAddSkill()
  self:UpdateKinSkill()
end

-- 更新技能列表
function uiKin:UpdateSkillList()
  self.pKin = KKin.GetSelfKin()
  if not self.pKin then
    self:Init()
    self:ClearData()
    return
  end
  local nKinFigure = self:GetSelfKinFigure()
  local nLevel = self.pKin.GetSkillLevel()
  local nUsePoint = self.pKin.GetUsePoint()
  if self.nAcctiveSkill <= 0 then
    return 0
  end

  local tbPartSkillInfo = Kin.tbKinSkill.tbSkillInfo[self.nAcctiveSkill]
  local tbPartSkillName = Kin.tbKinSkill.tbInfo[self.nAcctiveSkill]
  local nAddPoint = 0
  for _, tb in pairs(self.tbAddSkillInfo) do
    nAddPoint = nAddPoint + tb[3]
  end
  nUsePoint = nUsePoint + nAddPoint
  for i = 1, 3 do
    for j = 1, 5 do
      local nIndex = (i - 1) * 5 + j
      local szWnd_Page = self.PageSkill .. nIndex
      local szWnd_Image = self.ImageSkill .. nIndex
      local szWnd_Image_e = self.ImageEffect .. nIndex
      local szWnd_Info = self.TxtSkilInfo .. nIndex
      local szWnd_Btn = self.BtnAddSkill .. nIndex
      if tbPartSkillInfo[i] and tbPartSkillInfo[i][j] then
        local nSkillLevel = self.pKin.GetTask(tbPartSkillInfo[i][j].nTaskId)
        local nPassive = tbPartSkillInfo[i][j].nPassive
        local tbSkillLevel = loadstring(tbPartSkillInfo[i][j].szLevelTable)()
        local nSkillLevelEx, nMaxExp
        if nPassive == 1 and tbSkillLevel and type(tbSkillLevel) == "table" then
          nSkillLevelEx, nMaxExp = self:GetSkillLevelEx(nSkillLevel, tbSkillLevel) --特殊的都统一这样处理，变量上记录的总经验值
        end
        local szLevelInfo = string.format("等级：%s", nSkillLevelEx or nSkillLevel)
        local szMsg = ""
        --pic
        Img_SetImage(self.UIGROUP, szWnd_Image, 1, tbPartSkillInfo[i][j].szSkillSpr)
        if tbPartSkillInfo[i][j].szSkillEffectSpr ~= "" then
          Img_SetImage(self.UIGROUP, szWnd_Image_e, 1, tbPartSkillInfo[i][j].szSkillEffectSpr)
          Wnd_Show(self.UIGROUP, szWnd_Image_e)
        else
          Wnd_Hide(self.UIGROUP, szWnd_Image_e)
        end
        --tip
        if nSkillLevel <= 0 then
          szMsg = "<color=gray>" .. tbPartSkillInfo[i][j].szSkillInfo .. "<color>"
        else
          szMsg = tbPartSkillInfo[i][j].szSkillInfo
        end
        if nMaxExp then
          szMsg = string.format("经验：%s / %s\n\n", nSkillLevel, nMaxExp) .. szMsg
        elseif self.nAcctiveSkill == 2 and i == 2 and (j == 1 or j == 2) then -- 家族仓库逻辑
          szMsg = string.format("建设度：%s\n\n", self.pKin.GetTask(86)) .. szMsg
        end
        Wnd_SetTip(self.UIGROUP, szWnd_Image, szMsg)
        if self.tbAddSkillInfo[nIndex] then
          nSkillLevel = self.tbAddSkillInfo[nIndex][3]
        end
        local nCondition = tbPartSkillInfo[i][j].tbCondition[nSkillLevel + 1] or -1
        -- 等级说明
        if nSkillLevel >= 0 then
          if self.tbAddSkillInfo[nIndex] then
            szLevelInfo = string.format("等级：<color=yellow>%s<color>", self.tbAddSkillInfo[nIndex][3])
          end
          Txt_SetTxt(self.UIGROUP, szWnd_Info, szLevelInfo)
        end

        -- 加点按钮
        if nKinFigure > 2 or nCondition < 0 or nCondition > nUsePoint or nLevel <= nUsePoint then
          Wnd_SetEnable(self.UIGROUP, szWnd_Btn, 0)
          Wnd_Hide(self.UIGROUP, szWnd_Btn)
        else
          Wnd_SetEnable(self.UIGROUP, szWnd_Btn, 1)
          Wnd_Show(self.UIGROUP, szWnd_Btn)
        end
        Wnd_SetEnable(self.UIGROUP, szWnd_Page, 1)
        Wnd_Show(self.UIGROUP, szWnd_Page)
      else
        Wnd_SetEnable(self.UIGROUP, szWnd_Page, 0)
        Wnd_Hide(self.UIGROUP, szWnd_Page)
      end
    end

    if tbPartSkillName then
      local szTxt = self.TxtSkillPart .. i
      Txt_SetTxt(self.UIGROUP, szTxt, tbPartSkillName[i] or "")
    end
  end
  if self.nAcctiveSkill == 1 then
    Wnd_Show(self.UIGROUP, self.BTN_SKILL_OK)
    Wnd_Show(self.UIGROUP, self.BTN_SKILL_CANCEL)
    Wnd_Show(self.UIGROUP, self.TXT_REPOINT)
    if nAddPoint > 0 and nKinFigure <= 2 then
      Wnd_SetEnable(self.UIGROUP, self.BTN_SKILL_OK, 1)
      Wnd_SetEnable(self.UIGROUP, self.BTN_SKILL_CANCEL, 1)
    else
      Wnd_SetEnable(self.UIGROUP, self.BTN_SKILL_OK, 0)
      Wnd_SetEnable(self.UIGROUP, self.BTN_SKILL_CANCEL, 0)
    end
    Txt_SetTxt(self.UIGROUP, self.TXT_REPOINT, string.format("剩余点数：%s", math.max(nLevel - nUsePoint, 0)))
  else
    Wnd_Hide(self.UIGROUP, self.BTN_SKILL_OK)
    Wnd_Hide(self.UIGROUP, self.BTN_SKILL_CANCEL)
    Wnd_Hide(self.UIGROUP, self.TXT_REPOINT)
  end
end

function uiKin:AddSkill(nIndex)
  local nDetailId = math.floor(nIndex / 5)
  local nSkillId = math.mod(nIndex, 5)
  if nSkillId == 0 then
    nSkillId = 5
  else
    nDetailId = nDetailId + 1
  end
  self.tbAddSkillInfo[nIndex] = self.tbAddSkillInfo[nIndex] or {}
  if not self.tbAddSkillInfo[nIndex][3] then
    self.tbAddSkillInfo[nIndex] = { nDetailId, nSkillId, 1 }
  else
    self.tbAddSkillInfo[nIndex][3] = self.tbAddSkillInfo[nIndex][3] + 1
  end
end

function uiKin:GetSkillLevelEx(nSkillLevel, tbSkillLevel)
  local nMaxExp = 0
  local nSkillLevelEx = 0
  for nLevel, nExp in pairs(tbSkillLevel) do
    if nExp >= nSkillLevel then
      if nMaxExp == 0 then
        nSkillLevelEx = nLevel
        nMaxExp = nExp
      elseif nMaxExp > nExp then
        nSkillLevelEx = nLevel
        nMaxExp = nExp
      end
    end
  end
  return nSkillLevelEx, nMaxExp
end

function uiKin:OnSkillCancel()
  self.tbAddSkillInfo = {}
  self:UpdateSkillList()
end

-- 家族招募
function uiKin:UpdateRecreuiment()
  self.nRecLevel = 0
  self.nRecWealth = 0
  self.nAutoAgree = 0
  me.CallServerScript({ "KinCmd", "ApplyRecruitmentPublishInfo" })
  self:RefreshRecruitment()
end

-- 招募开关
function uiKin:SwitchRecruit(nSwitch)
  -- 需求等级
  if Btn_GetCheck(self.UIGROUP, self.BTN_CHECK_LEVEL) == 1 then
    self.nRecLevel = Edt_GetInt(self.UIGROUP, self.EDT_LEVEL)
  else
    self.nRecLevel = self.REC_MIN_LEVEL
  end

  -- 需求荣誉等级
  if Btn_GetCheck(self.UIGROUP, self.BTN_CHECK_WEALTH) == 1 then
    self.nRecWealth = Edt_GetInt(self.UIGROUP, self.EDT_WEALTH)
  else
    self.nRecWealth = self.REC_MIN_HONOR
  end

  -- 自动同意申请
  if Btn_GetCheck(self.UIGROUP, self.BTN_CHECK_AUTO_AGREE) == 1 then
    self.nAutoAgree = 1
  else
    self.nAutoAgree = 0
  end

  -- 发送到服务端
  if nSwitch == 1 then
    me.CallServerScript({ "KinCmd", "RecruitmentPublish", 1, self.nRecLevel, self.nRecWealth, self.nAutoAgree })
  else
    me.CallServerScript({ "KinCmd", "RecruitmentPublish", 0, self.nRecLevel, self.nRecWealth, self.nAutoAgree })
  end
end

-- 更新招募状态
function uiKin:UpdatePublish()
  local pKin = KKin.GetSelfKin()
  self.nRecPublish = pKin.GetRecruitmentPublish()
  self.nRecLevel = pKin.GetRecruitmentLevel()
  self.nRecWealth = pKin.GetRecruitmentHonour()
  self.nAutoAgree = pKin.GetRecruitmentAutoAgree()
  if self.nRecPublish == 1 then
    self.nRecLevel = math.max(self.nRecLevel, self.REC_MIN_LEVEL)
    self.nRecWealth = math.max(self.nRecWealth, self.REC_MIN_HONOR)
    Wnd_SetEnable(self.UIGROUP, self.BTN_RELEASE_RECRUIT, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_CLOSE_RECRUIT, 1)
  else
    Wnd_SetEnable(self.UIGROUP, self.BTN_RELEASE_RECRUIT, 1)
    Wnd_SetEnable(self.UIGROUP, self.BTN_CLOSE_RECRUIT, 0)
  end

  local nFigure = self:GetSelfKinFigure()
  if nFigure > Kin.FIGURE_ASSISTANT then
    Wnd_SetEnable(self.UIGROUP, self.BTN_RELEASE_RECRUIT, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_CLOSE_RECRUIT, 0)
  end

  Edt_SetInt(self.UIGROUP, self.EDT_LEVEL, self.nRecLevel)
  Edt_SetInt(self.UIGROUP, self.EDT_WEALTH, self.nRecWealth)
  if self.nRecLevel > self.REC_MIN_LEVEL and self.nRecPublish == 1 then
    Btn_Check(self.UIGROUP, self.BTN_CHECK_LEVEL, 1)
  else
    Btn_Check(self.UIGROUP, self.BTN_CHECK_LEVEL, 0)
  end
  if self.nRecWealth > self.REC_MIN_HONOR and self.nRecPublish == 1 then
    Btn_Check(self.UIGROUP, self.BTN_CHECK_WEALTH, 1)
  else
    Btn_Check(self.UIGROUP, self.BTN_CHECK_WEALTH, 0)
  end
  Btn_Check(self.UIGROUP, self.BTN_CHECK_AUTO_AGREE, self.nAutoAgree)
end

-- 接收服务器数据，更新客户端
function uiKin:UpdateRecruitment()
  self:UpdatePublish()

  local nCount, tbInducteeTable = KKin.GetRecruitmentData()
  if not tbInducteeTable then
    return
  end

  self.tbRecMember = {}
  Lst_Clear(self.UIGROUP, self.LST_APPLY)

  local nIndex = 1
  local tbSexName = { [0] = "男", [1] = "女" }
  for i, tbInfo in pairs(tbInducteeTable) do
    table.insert(self.tbRecMember, tbInfo)
    Lst_SetCell(self.UIGROUP, self.LST_APPLY, i, 0, tbInfo.szName)
    Lst_SetCell(self.UIGROUP, self.LST_APPLY, i, 1, tbInfo.nLevel)
    Lst_SetCell(self.UIGROUP, self.LST_APPLY, i, 2, Player:GetFactionRouteName(tbInfo.nFaction))
    Lst_SetCell(self.UIGROUP, self.LST_APPLY, i, 3, tbSexName[tbInfo.nSex] or "")
    local nHonorLevel = PlayerHonor:CalcHonorLevel(tbInfo.nHonor, tbInfo.nHonorRank, "money")
    Lst_SetCell(self.UIGROUP, self.LST_APPLY, i, 4, nHonorLevel)
    if tbInfo.nOnline == 0 then
      Lst_SetLineColor(self.UIGROUP, self.LST_APPLY, nIndex, 0x00808080)
    end
    nIndex = nIndex + 1
  end
  Edt_SetTxt(self.UIGROUP, self.EDT_REC_ANNOUNCE, self.pKin.GetRecAnnounce())
end

-- 刷新，客户端发送更新请求
function uiKin:RefreshRecruitment()
  me.CallServerScript({ "KinCmd", "KinRecruitmenClean", me.dwKinId })
  KKin.ApplyKinRecruitment()
end

function uiKin:UpRecruitmentPage()
  local nMemberId = Lst_GetCurKey(self.UIGROUP, self.LST_APPLY)
  if nMemberId <= 0 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_REFUSE, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_CHAT, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_AGREE, 0)
  else
    Wnd_SetEnable(self.UIGROUP, self.BTN_REFUSE, 1)
    Wnd_SetEnable(self.UIGROUP, self.BTN_CHAT, 1)
    Wnd_SetEnable(self.UIGROUP, self.BTN_AGREE, 1)
  end
  --权限不足的始终禁止掉
  if self:GetSelfKinFigure() > Kin.FIGURE_ASSISTANT then
    Wnd_SetEnable(self.UIGROUP, self.BTN_AGREE, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_REFUSE, 0)
  end
end

function uiKin:Link_infor_OnClick(szWnd, szLinkData)
  --print("uiKin:Link_infor_OnClick", szWnd, szLinkData);
  if me.nTemplateMapId == 2086 then
    me.Msg("你已经在家族领地里了！")
    return
  end

  local tbFind = me.FindClassItemInBags("chuansongfu")
  if not tbFind or #tbFind == 0 then
    me.Msg("你身上没有传送符，可以去各大主城通过家族关卡接引人进入家族领地。")
    return
  end

  local tbItem = tbFind[1]
  me.UseItem(tbItem.pItem)
end
