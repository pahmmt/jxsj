-- 文件名　：zhounianqing2012_def.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-09-24 16:15:55
-- 描述：四周年庆-抽奖

SpecialEvent.tbZhouNianQing2012 = SpecialEvent.tbZhouNianQing2012 or {}
local tbZhouNianQing2012 = SpecialEvent.tbZhouNianQing2012

tbZhouNianQing2012.nGroupId = 2205
tbZhouNianQing2012.nChangCardDate = 1 --兑换卡牌的日期
tbZhouNianQing2012.nPlayerBackActiveFlag = 2 --回归玩家激活领取资格
tbZhouNianQing2012.nPlayerBackGetCardFlag = 3 --回归玩家领取资格
tbZhouNianQing2012.nMsgTime = 4 --提醒玩家邀请成功，去领奖
tbZhouNianQing2012.nGetCardDate = 5 --字卡获得时间
tbZhouNianQing2012.nGetCardCount = 6 --字卡获得数量
tbZhouNianQing2012.nPlayerBackGetAwardFlag = 7 --提醒玩家去领取回归奖励

tbZhouNianQing2012.tbCardGDP = { 18, 1, 1824 } --卡片ID
tbZhouNianQing2012.tbIniviteBox = { 18, 1, 1825 } --邀请礼包
tbZhouNianQing2012.tbAwardBoxGDP = { 18, 1, 1826 } --奖励箱子
--兑换规则
tbZhouNianQing2012.tbDuihuanList = {
  [1] = { 3 },
  [2] = { 2, 3 },
  [3] = { 2, 3, 4, 5 },
  [4] = { 1, 2, 3, 4, 5 },
}

--声望牌子
tbZhouNianQing2012.tbHonor = {
  { { 18, 1, 1251, 1 }, "小游龙阁声望令[护身符]" },
  { { 18, 1, 1251, 2 }, "小游龙阁声望令[帽子] " },
  { { 18, 1, 1251, 3 }, "小游龙阁声望令[衣服]" },
  { { 18, 1, 1251, 4 }, "小游龙阁声望令[腰带]" },
  { { 18, 1, 1251, 5 }, "小游龙阁声望令[鞋子]" },
  { { 18, 1, 1251, 6 }, "小游龙阁声望令[项链]" },
  { { 18, 1, 1251, 7 }, "小游龙阁声望令[戒指]" },
  { { 18, 1, 1251, 8 }, "小游龙阁声望令[护腕]" },
  { { 18, 1, 1251, 9 }, "小游龙阁声望令[腰坠]" },
}
tbZhouNianQing2012.tbValue = { 50000, 100000, 150000, 200000 } --每个箱子对应奖励
tbZhouNianQing2012.tbCardName = { "新", "剑", "侠", "世", "界" }

tbZhouNianQing2012.EXT_POINT = 7 --7号扩展点
tbZhouNianQing2012.nMaxCount = 10 --每天最多获得牌子奖励
tbZhouNianQing2012.nStartTime = 20121011 --开始日期
tbZhouNianQing2012.nEndTime = 20121021 --结束日期
tbZhouNianQing2012.nChangeHour = 19 --兑换卡片奖励时间
tbZhouNianQing2012.nMsgTime2World = 60 * Env.GAME_FPS --广播获奖名单时间

tbZhouNianQing2012.SZ_INIVITE_URL = "http://jxsj.xoyo.com/zt/2012/09/29/index.shtml"
--数据表
tbZhouNianQing2012.tbInvitePlayerList = tbZhouNianQing2012.tbInvitePlayerList or {} --邀请玩家列表
tbZhouNianQing2012.tbInvitePlayerCount = tbZhouNianQing2012.tbInvitePlayerCount or {} --邀请玩家数量表
tbZhouNianQing2012.tbLottoryList = tbZhouNianQing2012.tbLottoryList or {} --中奖名单
