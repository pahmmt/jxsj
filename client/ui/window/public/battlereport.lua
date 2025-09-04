-----------------------------------------------------
--文件名		：	battlereport.lua
--创建者		：	zongbeilei
--创建时间		：	2007-10-13
--功能描述		：	宋金战场中即时战报的界面
--					@ 一共有三种模式,为了简化,把它分为4个部分,第1和第3个部分在三种模式下都一样;第2和第4部分要特殊处理,各自判断
------------------------------------------------------

local uiBattleReport = Ui:GetClass("battlereport")

uiBattleReport.CLOSE_BUTTON = "BtnClose" -- close按钮
uiBattleReport.TXTBTNAME = "TxtBTName" -- 战局名
uiBattleReport.TXTBTMODE = "TxtBTMode" -- 模式
uiBattleReport.TXTMYCAMPNUM = "TxtMyCampNum" -- 我方人数
uiBattleReport.TXTENEMYCAMPNUM = "TxtEnemyCampNum" -- 敌方人数
uiBattleReport.TXTREMAINBTTIME = "TxtRemainBTTime" -- 战局剩余时间
uiBattleReport.TXTBOUNS = "TxtBouns" -- 个人积分
uiBattleReport.TXTLISTRANK = "TxtListRank" -- 排名
uiBattleReport.TXTMAXSERIESKILL = "TxtMaxSeriesKill" -- 最大连斩数
uiBattleReport.TXTSERIESKILL = "TxtSeriesKill" -- 当前连斩
uiBattleReport.TXTRESULTNAME_SELF = "TxtResultName_self" -- 第2部分的列名
uiBattleReport.TXTRESULT_SELF = "TxtResult_self" -- 第2部分的内容
uiBattleReport.TXTRESULTNAME_ALL = "TxtResultName_all" -- 第4部分的列名
uiBattleReport.TXTRESULT_ALL = "TxtResult_all" -- 第4部分的内容

uiBattleReport.FILLED_CHAR = " " -- 补齐的字符
uiBattleReport.CAMP_NAME = { "（宋）", "（金）", "" } -- 玩家所属的阵营(宋方/金方)
uiBattleReport.BATTLE_MODE = { "杀戮模式", "元帅保卫模式", "护旗模式", "武林团体赛", "大侠保卫战", "保护龙柱模式" } -- 传进来的战役模式是数值,把它转化为字符串
uiBattleReport.FILLED_SIDE = { Center = 0, Left = 1 } -- 标记是列名还是内容(列名居中对齐,内容左对齐)

-- 功能:	初始化
function uiBattleReport:Init()
  self.tbPlayerInfo = -- 接收传入的个人信息(tbPlayerInfo)
    {
      ["szBTName"] = "[未开始]", -- 战局名：
      ["nCamp"] = 3, -- 玩家所在的阵营
      ["nBTMode"] = 1, -- 模式：
      ["nMyCampNum"] = 0, -- 本方人数：
      ["nEnemyCampNum"] = 0, -- 敌方人数：
      ["nRemainBTTime"] = 0, -- 战局剩余时间（秒）：
      ["nKillPlayerNum"] = 0, -- 伤敌玩家：
      ["nKillPlayerBouns"] = 0, -- 伤敌玩家奖励积分：
      ["nTriSeriesNum"] = 0, -- 三连斩：
      ["nSeriesBouns"] = 0, -- 三连斩奖励积分：
      ["nTotalSongBouns"] = 0, -- 宋方积分：
      ["nTotalJinBouns"] = 0, -- 金方积分：
      ["nBouns"] = 0, -- 个人积分：
      ["nListRank"] = 0, -- 排名：
      ["nMaxSeriesKill"] = 0, -- 最大连斩：
      ["nSeriesKill"] = 0, -- 当前连斩：
      ["nKillNpcNum"] = 0, -- 杀敌NPC：
      ["nKillNpcBouns"] = 0, -- 杀敌NPC奖励积分：
      ["nFlagNum"] = 0, -- 成功护旗：
      ["nFlagsBouns"] = 0, -- 成功护旗奖励积分：
      ["nTotalSongFlags"] = 0, -- 宋方护旗：
      ["nTotalJinFlags"] = 0, -- 金方护旗：
      ["nProtectBouns"] = 0, -- 护卫奖励
      ["nPlayerNpcKillNum"] = 0, -- 变身击伤玩家个数
    }
  self.tbPlayerInfoList = {} -- 接收传入的排行榜信息(tbPlayerInfoList)
end

-- 功能:	接收传过来的数据,赋给本地数据
-- 参数:	tbPlayerInfo	玩家个人信息
-- 参数:	tbInfoWidth		排行榜信息
function uiBattleReport:OnData(tbPlayerInfoList, tbPlayerInfo)
  self.tbPlayerInfo = tbPlayerInfo -- 接收tbPlayerInfo
  self.tbPlayerInfoList = tbPlayerInfoList -- 接收tbPlayerInfoList
  self:OnUpdate()
end

function uiBattleReport:OnOpen()
  --	self.tbPlayerInfo = tbPlayerInfo;			-- 打开页面也需要接收tbPlayerInfo和tbPlayerInfoList
  --	self.tbPlayerInfoList = tbPlayerInfoList;
  local szType, tbDate = me.GetCampaignDate()
  if not tbDate or szType ~= "SongJinBattle" then
    return 0
  end
  self:OnData(tbDate.tbPlayerInfoList, tbDate.tbPlayerInfo)
end

-- 功能:	点击关闭按钮关闭界面
function uiBattleReport:OnButtonClick(szWnd, nParam)
  if szWnd == self.CLOSE_BUTTON then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiBattleReport:OnEscExclusiveWnd(szWnd)
  UiManager:CloseWindow(self.UIGROUP)
end

-- 功能:	更新界面
function uiBattleReport:OnUpdate()
  local tbModeInfo = {} -- 当前模式下第2和第4部分要填入的信息
  self:FillOtherInfo() -- 第1和第3部分在任何模式下都一样
  self:OnInitDate() -- 定义;
  if self.tbPlayerInfo.nBTMode == 1 then
    tbModeInfo = self:UpdateKillMode() -- 杀戮模式
  elseif self.tbPlayerInfo.nBTMode == 2 then
    tbModeInfo = self:UpdateLeaderMode() -- 元帅保卫模式
  elseif self.tbPlayerInfo.nBTMode == 3 then
    tbModeInfo = self:UpdateProtectFlagMode() -- 护旗模式

  -- by zhangjinpin@kingsoft
  elseif self.tbPlayerInfo.nBTMode == 4 then
    tbModeInfo = self:UpdateWldhBattleMode() -- 武林大会团体赛
  elseif self.tbPlayerInfo.nBTMode == 5 then
    tbModeInfo = self:UpdateDaXiaBattleMode() -- 元帅保卫模式
  elseif self.tbPlayerInfo.nBTMode == 6 then
    tbModeInfo = self:UpdateProtectTotemMode() -- 保护龙柱模式
  end

  -- 分别把当前模式下第2部分的列名,第2部分的内容,第4部分的列名,第4部分的内容, 通过调用TypesetFilledInfo整理好内容, 逐一填入对应的文字条
  Txt_SetTxt(self.UIGROUP, self.TXTRESULTNAME_SELF, self:TypesetFilledInfo(1, tbModeInfo, self.FILLED_SIDE.Center))
  Txt_SetTxt(self.UIGROUP, self.TXTRESULT_SELF, self:TypesetFilledInfo(2, tbModeInfo, self.FILLED_SIDE.Left))
  Txt_SetTxt(self.UIGROUP, self.TXTRESULTNAME_ALL, self:TypesetFilledInfo(3, tbModeInfo, self.FILLED_SIDE.Center))
  Txt_SetTxt(self.UIGROUP, self.TXTRESULT_ALL, self:TypesetFilledInfo(4, tbModeInfo, self.FILLED_SIDE.Left))
end

function uiBattleReport:OnInitDate()
  self.tbTitleLen = {
    ["default"] = 8,
    ["个人战绩"] = 10,
    ["数量"] = 6,
    ["奖励积分"] = 8,
    ["当前战况"] = 22,
    ["伤敌玩家"] = 10,
    ["宋方积分"] = 8,
    ["有效三连斩"] = 10,
    ["金方积分"] = 8,
    ["势力"] = 4,
    ["门派路线"] = 8,
    ["玩家姓名"] = 16,
    ["家族/帮会"] = 24,
    ["最大连斩数"] = 10,
    ["个人积分"] = 8,
    ["区服战队"] = 8,
    ["伤敌"] = 4,
    ["连斩"] = 4,
    ["杀NPC"] = 5,
    ["护卫"] = 5,
    ["积分"] = 5,
    ["杀敌NPC"] = 10,
    ["成功护旗"] = 10,
    ["护旗"] = 5,
    ["伤敌数"] = 8,
    ["变身伤敌"] = 8,

    ["nKillPlayerNum"] = 6,
    ["nKillPlayerBouns"] = 8,
    ["nTotalSongBouns"] = 8,
    ["nTriSeriesNum"] = 6,
    ["nSeriesBouns"] = 8,
    ["nTotalJinBouns"] = 8,
    ["nKillNpcNum"] = 6,
    ["nKillNpcBouns"] = 8,
    ["nProtectBouns"] = 6,
    ["nFlagNum"] = 6,
    ["nFlagsBouns"] = 8,
    ["nTotalSongFlags"] = 8,
    ["nTotalJinFlags"] = 8,
    ["nPlayerNpcKillNum"] = 8,
  }

  --字符规格倍数
  for szKey, nValue in pairs(self.tbTitleLen) do
    self.tbTitleLen.szKey = nValue * UiManager.IVER_nBattleReport
  end

  self.tbTitleFun = {
    ["nKillPlayerNum"] = self.tbPlayerInfo.nKillPlayerNum,
    ["nKillPlayerBouns"] = self.tbPlayerInfo.nKillPlayerBouns,
    ["nTotalSongBouns"] = self.tbPlayerInfo.nTotalSongBouns,
    ["nTriSeriesNum"] = self.tbPlayerInfo.nTriSeriesNum,
    ["nSeriesBouns"] = self.tbPlayerInfo.nSeriesBouns,
    ["nTotalJinBouns"] = self.tbPlayerInfo.nTotalJinBouns,
    ["nKillNpcNum"] = self.tbPlayerInfo.nKillNpcNum,
    ["nKillNpcBouns"] = self.tbPlayerInfo.nKillNpcBouns,
    ["nProtectBouns"] = self.tbPlayerInfo.nProtectBouns,
    ["nFlagNum"] = self.tbPlayerInfo.nFlagNum,
    ["nFlagsBouns"] = self.tbPlayerInfo.nFlagsBouns,
    ["nTotalSongFlags"] = self.tbPlayerInfo.nTotalSongFlags,
    ["nTotalJinFlags"] = self.tbPlayerInfo.nTotalJinFlags,
    ["nPlayerNpcKillNum"] = self.tbPlayerInfo.nPlayerNpcKillNum,
  }
end

-- 功能:	杀戮模式下更新数据
function uiBattleReport:UpdateKillMode()
  local tbModeInfo = {
    [1] = {
      ["SpaceLen"] = string.rep(self.FILLED_CHAR, 6),
      ["FilledInfo"] = {
        { "个人战绩", "数量", "奖励积分", "当前战况" },
      },
    },
    [2] = {
      ["SpaceLen"] = string.rep(self.FILLED_CHAR, 6),
      ["FilledInfo"] = {
        { "伤敌玩家", "nKillPlayerNum", "nKillPlayerBouns", "宋方积分", "nTotalSongBouns" },
        { "有效三连斩", "nTriSeriesNum", "nSeriesBouns", "金方积分", "nTotalJinBouns" },
      },
    },
    [3] = {
      ["SpaceLen"] = string.rep(self.FILLED_CHAR, 5),
      ["FilledInfo"] = {
        { "势力", "门派路线", "玩家姓名", "家族/帮会", "伤敌数", "最大连斩数", "个人积分" },
      },
    },
    [4] = {
      ["SpaceLen"] = string.rep(self.FILLED_CHAR, 5),
      ["FilledInfo"] = self.tbPlayerInfoList,
    },
  }
  return tbModeInfo
end

-- by zhangjinpin@kingsoft
function uiBattleReport:UpdateWldhBattleMode()
  local tbModeInfo = {
    [1] = {
      ["SpaceLen"] = string.rep(self.FILLED_CHAR, 6),
      ["FilledInfo"] = {
        { "个人战绩", "数量", "奖励积分", "当前战况" },
      },
    },
    [2] = {
      ["SpaceLen"] = string.rep(self.FILLED_CHAR, 6),
      ["FilledInfo"] = {
        { "伤敌玩家", "nKillPlayerNum", "nKillPlayerBouns", "宋方积分", "nTotalSongBouns" },
        { "有效三连斩", "nTriSeriesNum", "nSeriesBouns", "金方积分", "nTotalJinBouns" },
      },
    },
    [3] = {
      ["SpaceLen"] = string.rep(self.FILLED_CHAR, 2),
      ["FilledInfo"] = {
        { "势力", "门派路线", "玩家姓名", "区服战队", "伤敌玩家", "最大连斩数", "个人积分" },
      },
    },
    [4] = {
      ["SpaceLen"] = string.rep(self.FILLED_CHAR, 2),
      ["FilledInfo"] = self.tbPlayerInfoList,
    },
  }
  return tbModeInfo
end

-- 功能:	元帅护卫模式下更新数据
function uiBattleReport:UpdateLeaderMode()
  local tbModeInfo = {
    [1] = {
      ["SpaceLen"] = string.rep(self.FILLED_CHAR, 6),
      ["FilledInfo"] = {
        { "个人战绩", "数量", "奖励积分", "当前战况" },
      },
    },
    [2] = {
      ["SpaceLen"] = string.rep(self.FILLED_CHAR, 6),
      ["FilledInfo"] = {
        { "伤敌玩家", "nKillPlayerNum", "nKillPlayerBouns", "宋方积分", "nTotalSongBouns" },
        { "有效三连斩", "nTriSeriesNum", "nSeriesBouns", "金方积分", "nTotalJinBouns" },
        { "杀敌NPC", "nKillNpcNum", "nKillNpcBouns" },
        --	TODO			{ "珍宝奖励", 	self.tbPlayerInfo.nTreasureNum, 	self.tbPlayerInfo.nTreasureBouns },
        { "护卫奖励", "nProtectBouns" },
      },
    },
    [3] = {
      ["SpaceLen"] = string.rep(self.FILLED_CHAR, 2),
      ["FilledInfo"] = {
        { "势力", "门派路线", "玩家姓名", "家族/帮会", "伤敌", "连斩", "杀NPC", "护卫", "积分" },
      },
    },
    [4] = {
      ["SpaceLen"] = string.rep(self.FILLED_CHAR, 2),
      ["FilledInfo"] = self.tbPlayerInfoList,
    },
  }
  return tbModeInfo
end

-- 功能:	护旗模式下更新数据
function uiBattleReport:UpdateProtectFlagMode()
  local tbModeInfo = {
    [1] = {
      ["SpaceLen"] = string.rep(self.FILLED_CHAR, 6),
      ["FilledInfo"] = {
        { "个人战绩", "数量", "奖励积分", "当前战况" },
      },
    },
    [2] = {
      ["SpaceLen"] = string.rep(self.FILLED_CHAR, 6),
      ["FilledInfo"] = {
        { "伤敌玩家", "nKillPlayerNum", "nKillPlayerBouns", "宋方护旗", "nTotalSongFlags" },
        { "有效三连斩", "nTriSeriesNum", "nSeriesBouns", "金方护旗", "nTotalJinFlags" },
        { "杀敌NPC", "nKillNpcNum", "nKillNpcBouns", "宋方积分", "nTotalSongBouns" },
        { "成功护旗", "nFlagNum", "nFlagsBouns", "金方积分", "nTotalJinBouns" },
        --	TODO			{ "珍宝获取", self.tbPlayerInfo.nTreasureNum, self.tbPlayerInfo.nTreasureBouns },
      },
    },
    [3] = {
      ["SpaceLen"] = string.rep(self.FILLED_CHAR, 2),
      ["FilledInfo"] = {
        { "势力", "门派路线", "玩家姓名", "家族/帮会", "伤敌", "连斩", "杀NPC", "护旗", "积分" },
      },
    },
    [4] = {
      ["SpaceLen"] = string.rep(self.FILLED_CHAR, 2),
      ["FilledInfo"] = self.tbPlayerInfoList,
    },
  }
  return tbModeInfo
end

-- 功能:	大侠保卫战下更新数据
function uiBattleReport:UpdateDaXiaBattleMode()
  local tbModeInfo = {
    [1] = {
      ["SpaceLen"] = string.rep(self.FILLED_CHAR, 6),
      ["FilledInfo"] = {
        { "个人战绩", "数量", "奖励积分", "当前战况" },
      },
    },
    [2] = {
      ["SpaceLen"] = string.rep(self.FILLED_CHAR, 6),
      ["FilledInfo"] = {
        { "伤敌玩家", "nKillPlayerNum", "nKillPlayerBouns", "宋方积分", "nTotalSongBouns" },
        { "有效三连斩", "nTriSeriesNum", "nSeriesBouns", "金方积分", "nTotalJinBouns" },
        { "杀敌NPC", "nKillNpcNum", "nKillNpcBouns" },
        --	TODO			{ "珍宝奖励", 	self.tbPlayerInfo.nTreasureNum, 	self.tbPlayerInfo.nTreasureBouns },
        { "护卫奖励", "nProtectBouns" },
        { "变身伤敌", "nPlayerNpcKillNum" },
      },
    },
    [3] = {
      ["SpaceLen"] = string.rep(self.FILLED_CHAR, 2),
      ["FilledInfo"] = {
        { "势力", "门派路线", "玩家姓名", "家族/帮会", "伤敌", "连斩", "杀NPC", "积分", "变身伤敌" },
      },
    },
    [4] = {
      ["SpaceLen"] = string.rep(self.FILLED_CHAR, 2),
      ["FilledInfo"] = self.tbPlayerInfoList,
    },
  }
  return tbModeInfo
end

-- 功能:	保护龙柱模式下更新数据
function uiBattleReport:UpdateProtectTotemMode()
  local tbModeInfo = {
    [1] = {
      ["SpaceLen"] = string.rep(self.FILLED_CHAR, 6),
      ["FilledInfo"] = {
        { "个人战绩", "数量", "奖励积分", "当前战况" },
      },
    },
    [2] = {
      ["SpaceLen"] = string.rep(self.FILLED_CHAR, 6),
      ["FilledInfo"] = {
        { "伤敌玩家", "nKillPlayerNum", "nKillPlayerBouns", "宋方积分", "nTotalSongBouns" },
        { "有效三连斩", "nTriSeriesNum", "nSeriesBouns", "金方积分", "nTotalJinBouns" },
      },
    },
    [3] = {
      ["SpaceLen"] = string.rep(self.FILLED_CHAR, 2),
      ["FilledInfo"] = {
        { "势力", "门派路线", "玩家姓名", "家族/帮会", "伤敌数", "最大连斩数", "个人积分" },
      },
    },
    [4] = {
      ["SpaceLen"] = string.rep(self.FILLED_CHAR, 2),
      ["FilledInfo"] = self.tbPlayerInfoList,
    },
  }
  return tbModeInfo
end

-- 功能:	当进入宋金战场但是还没有开始比赛的时候,界面显示为一个空界面
function uiBattleReport:ShowEmptyReport()
  Txt_SetTxt(self.UIGROUP, self.TXTBTNAME, "") -- 战局名
  Txt_SetTxt(self.UIGROUP, self.TXTBTMODE, "") -- 模式(传进来是数字,通过(uiBattleReport.BATTLE_MODE)转化成对应的字符串)
  Txt_SetTxt(self.UIGROUP, self.TXTMYCAMPNUM, "") -- 本方人数
  Txt_SetTxt(self.UIGROUP, self.TXTENEMYCAMPNUM, "") -- 敌方人数
  Txt_SetTxt(self.UIGROUP, self.TXTREMAINBTTIME, "") -- 战局剩余时间(**分钟的形式,最多60分钟)
  Txt_SetTxt(self.UIGROUP, self.TXTBOUNS, "") -- 个人积分
  Txt_SetTxt(self.UIGROUP, self.TXTLISTRANK, "") -- 排名
  Txt_SetTxt(self.UIGROUP, self.TXTMAXSERIESKILL, "") -- 最大连斩数
  Txt_SetTxt(self.UIGROUP, self.TXTSERIESKILL, "") -- 当前连斩数
  Txt_SetTxt(self.UIGROUP, self.TXTRESULTNAME_SELF, "") -- 第2部分的列名
  Txt_SetTxt(self.UIGROUP, self.TXTRESULT_SELF, "") -- 第2部分的内容
  Txt_SetTxt(self.UIGROUP, self.TXTRESULTNAME_ALL, "") -- 第4部分的列名
  Txt_SetTxt(self.UIGROUP, self.TXTRESULT_ALL, "") -- 第4部分的内容
end

-- 功能:	填充第1和第3部分的信息,由于它们在不同模式下也没有变化,所以合在一起写
function uiBattleReport:FillOtherInfo()
  local szPlayerMode = self.BATTLE_MODE[self.tbPlayerInfo.nBTMode]
  local szTime = "-"
  local szCamp = "个人积分" .. self.CAMP_NAME[self.tbPlayerInfo.nCamp] .. " " .. self.tbPlayerInfo.nBouns -- 获得自己的阵营
  if self.tbPlayerInfo.nRemainBTTime > 0 then
    szTime = math.ceil(self.tbPlayerInfo.nRemainBTTime / 60) .. "分钟"
  end

  Txt_SetTxt(self.UIGROUP, self.TXTBTNAME, self.tbPlayerInfo.szBTName) -- 战局名
  Txt_SetTxt(self.UIGROUP, self.TXTBTMODE, szPlayerMode) -- 模式(传进来是数字,通过(uiBattleReport.BATTLE_MODE)转化成对应的字符串)
  Txt_SetTxt(self.UIGROUP, self.TXTMYCAMPNUM, "本方人数 " .. self.tbPlayerInfo.nMyCampNum) -- 本方人数
  Txt_SetTxt(self.UIGROUP, self.TXTENEMYCAMPNUM, "敌方人数 " .. self.tbPlayerInfo.nEnemyCampNum) -- 敌方人数
  Txt_SetTxt(self.UIGROUP, self.TXTREMAINBTTIME, "战局剩余时间 " .. szTime) -- 战局剩余时间(**分钟的形式,最多60分钟)
  Txt_SetTxt(self.UIGROUP, self.TXTBOUNS, szCamp) -- 个人积分
  Txt_SetTxt(self.UIGROUP, self.TXTLISTRANK, "排名 " .. self.tbPlayerInfo.nListRank) -- 排名
  Txt_SetTxt(self.UIGROUP, self.TXTMAXSERIESKILL, "最大连斩数 " .. self.tbPlayerInfo.nMaxSeriesKill) -- 最大连斩数
  Txt_SetTxt(self.UIGROUP, self.TXTSERIESKILL, "当前连斩 " .. self.tbPlayerInfo.nSeriesKill) -- 当前有效连斩数
end

function uiBattleReport:GetStringTipFun(szFillWord)
  if not szFillWord then
    return ""
  end
  if self.tbTitleFun[szFillWord] then
    return self.tbTitleFun[szFillWord]
  end
  return szFillWord
end

function uiBattleReport:GetStringColumnWidth(szFillWord)
  if self.tbTitleLen[szFillWord] then
    return self.tbTitleLen[szFillWord]
  end
  return self.tbTitleLen["default"]
end

-- 功能:	把要显示在某个文字条中的数据按照一定规则排版
-- 参数:	tbModeInfo	要显示的文字,每列的给定的列长,列间距
-- 参数:	nFilledSide	标记传进来的是列名还是内容(nFilledSide = 1表示是列名,居中对齐;否则表示的是内容,左对齐)
function uiBattleReport:TypesetFilledInfo(nType, tbModeInfo, nFilledSide)
  local szOutputInfo = "" --	满足规则,输出在文字条中的字符串
  local szSpaceBtwCol = tbModeInfo[nType].SpaceLen --	列间隔(字符串)
  local tbFilledInfo = tbModeInfo[nType].FilledInfo --	需要被规则排列,然后输出在对应的文字条中的信息

  for i = 1, #tbFilledInfo do
    local szTempOutput = ""
    for j = 1, #tbFilledInfo[i] do
      local szFillWord = self:GetStringTipFun(tbFilledInfo[i][j])
      if j == 1 and i ~= 1 then
        szOutputInfo = szOutputInfo .. "\n" -- 遍历tbFilledInfo这个table的内容,当遍历到tbFilledInfo[i][1](i~=1)的时候,前面加一个"\n"表示已经另起一行
      end
      if j ~= 1 then
        szTempOutput = szTempOutput .. szSpaceBtwCol -- 当遍历到tbFilledInfo[i][j]列(j~=1)的时候,前面加一个列间距
      end
      local szColumnWord = tbFilledInfo[1][j]

      if nType == 4 then
        szColumnWord = self:GetStringTipFun(tbModeInfo[3].FilledInfo[1][j]) --第四列依据第三列的间距
      end

      if nFilledSide == self.FILLED_SIDE.Center then -- 加上tbFilledInfo[i][j]的值(如果是列名部分,要居中排列)
        szFillWord = Lib:StrFillC(szFillWord, self:GetStringColumnWidth(szColumnWord), self.FILLED_CHAR)
      elseif nFilledSide == self.FILLED_SIDE.Left then -- 加上tbFilledInfo[i][j]的值(如果是内容部分,要右对齐)
        szFillWord = Lib:StrFillL(szFillWord, self:GetStringColumnWidth(szColumnWord), self.FILLED_CHAR)
      end
      if tbFilledInfo[i].nC and 1 == tbFilledInfo[i].nC then
        szFillWord = "<color=yellow>" .. szFillWord .. "<color>"
      end
      szTempOutput = szTempOutput .. szFillWord
    end
    szOutputInfo = szOutputInfo .. szTempOutput
  end

  return szOutputInfo
end

-- 切换窗口状态，开着的关掉，关着的开起来
function uiBattleReport:SwitchWindow()
  local szUiGroup = Ui.UI_BATTLEREPORT
  local nVisible = UiManager:WindowVisible(szUiGroup)

  if nVisible == 0 then
    local nInBattle = Battle:IsRelatedMap(me.nMapId)
    if nInBattle == 0 then
      me.Msg("宋金战场外无法察看战报")
    else
      UiManager:OpenWindow(szUiGroup)
    end
  else
    UiManager:CloseWindow(szUiGroup)
  end
end

-- 同步活动数据
function uiBattleReport:SyncCampaignDate(szType)
  if szType == "SongJinBattle" then
    local _, tbDate = me.GetCampaignDate()
    if not tbDate then
      return
    end
    self:OnData(tbDate.tbPlayerInfoList, tbDate.tbPlayerInfo)
  end
end

function uiBattleReport:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_CAMPAIGN_DATE, self.SyncCampaignDate },
  }
  return tbRegEvent
end

UiShortcutAlias:RegisterCampaignUi("SongJinBattle", Ui.UI_BATTLEREPORT)
