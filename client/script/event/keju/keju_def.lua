-- 文件名　：keju_def.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-10-24 15:23:04
-- 功能说明：剑侠世界科举考试

SpecialEvent.JxsjKeju = SpecialEvent.JxsjKeju or {}
local JxsjKeju = SpecialEvent.JxsjKeju

--Task
JxsjKeju.nTaskGroup = 2216 --任务变量组
JxsjKeju.nAttendCount = 1 --每周参加的数目
JxsjKeju.nAttendWeekDate = 2 --每周参加的日期
JxsjKeju.nWeeklyGrade = 3 --本周成绩
JxsjKeju.nSelect2Wrong = 4 --选择两个错误答案
JxsjKeju.nDoubleGrade = 5 --双倍积分
JxsjKeju.nAskJourNum = 6 --每天询问的流水号
JxsjKeju.nDoubleGradeNum = 7 --双倍积分流水号
JxsjKeju.nGradeDate = 8 --成绩日期
JxsjKeju.nGradePre = 9 --分数990099
JxsjKeju.nGradeTime = 10 --成绩时间积分
JxsjKeju.nGetAwardDay = 11 --获得乡试活动奖励
JxsjKeju.nGetAwardWeek = 12 --获得殿试奖励
JxsjKeju.nSelect2WrongNum = 13 --选择两个错误答案的流水号
JxsjKeju.nAnswerJourNum = 14 --每天答题的流水号
JxsjKeju.nAnswerTime = 15 --累计时间
JxsjKeju.nOpenUiFalg = 16 --玩家打开ui答题

--常量
JxsjKeju.nMaxWeeklyCount = 3 --每周参加的最大次数
JxsjKeju.nMinAtWeeklyCount = 1200 --每周参加殿试的最低要求
JxsjKeju.szQuesetionFilePath = "\\setting\\event\\kejuquestion.txt" --题库资料
JxsjKeju.tbReadyTime = { { 1220, 1230 }, { 1550, 1600 }, { 1820, 1830 } } --准备时间
JxsjKeju.tbStartTime = { 1230, 1600, 1830 } --开始时间
JxsjKeju.tbEndTime = { 1300, 1615, 1900 } --结束时间
JxsjKeju.tbEndStartTime = { 1255, 1610, 1855 } --结束时间
JxsjKeju.tbType2GetAwardTime = { 1615, 1625 } --殿试领奖时间
JxsjKeju.tbEventWeeklyType = { [1] = 1, [2] = 1, [3] = 1, [4] = 1, [5] = 1, [6] = 0, [0] = 2 } --每周活动的类型：1为乡试，2为殿试，0为间歇期
JxsjKeju.tbKaoguanPoint = { [1] = { { 1, 1355, 3078 }, { 5, 1599, 3094 }, { 3, 1591, 3201 } }, [2] = { { 29, 1552, 3692 }, { 26, 1665, 3213 } } } --考官位置，只有这个周围的人才能参加科考
JxsjKeju.nTimeAsk = 30 * Env.GAME_FPS --每轮答题时间
JxsjKeju.nTimeAskS = 30 --每轮答题时间
JxsjKeju.nWeekQuestionCount = 90 --每周乡试题数目
JxsjKeju.tbWeekRule = { { 8, 12 }, { 8, 12 }, { 8, 12 }, { 8, 12 }, { 8, 12 } } --每周题库规则
JxsjKeju.tbWeeklyRule = { 20, 10 } --每周殿试题库规则
JxsjKeju.tbQuestionCountPre = { 20, 30 } --每次考试题数量
JxsjKeju.nFirstAddNum = 12 --第一周的第一天需要做偏移8题

JxsjKeju.nDoubleGradeMaxNumPer = 3 --双倍积分每天次数
JxsjKeju.nSelect2WrongMaxNumPer = 3 --去掉两个错误答案每天次数

JxsjKeju.nAttendLevelMin = 30 --参加活动最低等级

JxsjKeju.nMinAwardGradeType2 = 500 --殿试奖励最低分
JxsjKeju.nMinAwardGradeType1 = 400 --乡试奖励最低分

JxsjKeju.tbGradeAdd4Time = { 3, 3, 3, 3, 3, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 } --积分规则
JxsjKeju.nPerQueGrade = 30 --每一题的基准分

JxsjKeju.tbWeekAwardItem = { 18, 1, 1872, 1 } --周末活动奖章
JxsjKeju.tbPartnerItem = { 18, 1, 1869, 1 } --同伴
JxsjKeju.szPartnerItem = "18_1_1869_1"
JxsjKeju.tbFirstHorse = { 1, 12, 71, 4 } --马牌
JxsjKeju.nZhouziId = 11225

JxsjKeju.tb18Box = { 21, 7, 12, 1 }
JxsjKeju.tb15Box = { 21, 6, 12, 1 }

JxsjKeju.bLogFlag = 1 --1表示每条都写，2表示最后答题时才写

JxsjKeju.tbWeeklyAward = {
  [1] = { 800, 120, 8, 20 },
  [2] = { 600, 90, 6, 10 },
  [3] = { 500, 75, 5, 5 },
  [4] = { 400, 60, 4, 2 },
}

--考桌npc刷新的点
JxsjKeju.tbZhuoziPos = {
  { 1, 1351, 3086 },
  { 1, 1360, 3078 },
  { 1, 1364, 3083 },
  { 1, 1355, 3091 },
  { 5, 1593, 3096 },
  { 5, 1601, 3087 },
  { 5, 1598, 3084 },
  { 5, 1590, 3092 },
  { 3, 1590, 3196 },
  { 3, 1595, 3201 },
  { 3, 1597, 3189 },
  { 3, 1601, 3196 },
}

JxsjKeju._Cmp = function(tbA, tbB)
  return tbA[2] > tbB[2]
end

--数据
JxsjKeju.nQuestionType = 0 --科举类型
JxsjKeju.nJourNum = 0 --流水号
JxsjKeju.tbMaxGradeDay = {} --每日的得分最多的信息
JxsjKeju.tbGradeList = {} --殿试的前十成绩单
JxsjKeju.tbQuestionDay = {} --每天的试题
JxsjKeju.nQuestionTime = 0 --出题时间

JxsjKeju.tbZhuoziNpcList = {} --每次考试考桌npc

--数据table表
JxsjKeju.tbQuestion = JxsjKeju.tbQuestion or {} --题库
JxsjKeju.tbOldQuestion = JxsjKeju.tbOldQuestion or {} --旧题库
JxsjKeju.tbQuestion[1] = JxsjKeju.tbQuestion[1] or {} --题库乡试
JxsjKeju.tbQuestion[2] = JxsjKeju.tbQuestion[2] or {} --题库殿试
JxsjKeju.tbQuestionEx = JxsjKeju.tbQuestionEx or {} --题库题目反索引
JxsjKeju.tbJxsjKejuGrade = JxsjKeju.tbJxsjKejuGrade or {} --成绩单
JxsjKeju.tbJxsjKejuGrade[1] = JxsjKeju.tbJxsjKejuGrade[1] or {} --成绩单：日成绩单
JxsjKeju.tbJxsjKejuGrade[2] = JxsjKeju.tbJxsjKejuGrade[2] or {} --成绩单：周成绩单
JxsjKeju.tbJxsjKejuGradeEx = JxsjKeju.tbJxsjKejuGradeEx or {} --成绩单：周成绩单反索引
JxsjKeju.tbJxsjKejuGrade_Week = JxsjKeju.tbJxsjKejuGrade_Week or {} --周成绩单缓存

JxsjKeju.tbAttendList = JxsjKeju.tbAttendList or {} --参加的名单

-------------------------------------------------------------------------------------------------------------------
--花车
-------------------------------------------------------------------------------------------------------------------

JxsjKeju.nGetExpTime = 5 * Env.GAME_FPS
JxsjKeju.nGetAwardTime = 10 * Env.GAME_FPS
JxsjKeju.nAllTime = 600 * Env.GAME_FPS

JxsjKeju.nWelFareGiveExpRate = 1.5 * 5
JxsjKeju.nWelFareGiveExpCount = 60
JxsjKeju.nWelFareGetPrizeRange = 10
JxsjKeju.nWelSkillId = 1564 --发箱子时候放的特效

JxsjKeju.nHuaCheTemplateId = 11236
JxsjKeju.nHuaCheMapId = 29
JxsjKeju.tbStartPos = { 1464, 3761 }

JxsjKeju.tbWelFareAiPosInfo = {
  { 1477, 3774 },
  { 1503, 3799 },
  { 1523, 3814 },
  { 1550, 3843 },
  { 1566, 3860 },
  { 1582, 3876 },
  { 1600, 3896 },
  { 1624, 3925 },
  { 1639, 3909 },
  { 1650, 3921 },
  { 1662, 3935 },
  { 1647, 3951 },
  { 1630, 3964 },
  { 1621, 3951 },
  { 1622, 3924 },
  { 1612, 3909 },
  { 1590, 3880 },
  { 1569, 3865 },
  { 1548, 3843 },
  { 1528, 3825 },
  { 1516, 3808 },
  { 1490, 3787 },
  { 1477, 3774 },
  { 1465, 3762 },
}
