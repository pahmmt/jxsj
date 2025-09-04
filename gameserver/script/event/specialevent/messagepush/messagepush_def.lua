-- 文件名　：messagepush_def.lua
-- 创建者　：huangxiaoming
-- 创建时间：2012-11-2 15:29:00
-- 描  述  ：推送界面 客户端服务端公用定义

local tbMessagePush = SpecialEvent.tbMessagePush or {}
SpecialEvent.tbMessagePush = tbMessagePush

tbMessagePush.IS_OPEN = 1 -- 开关，跨服时关闭
-- 1位存一个活动状态，总活动个数是n*32个，需要时再扩展
tbMessagePush.TASK_GROUP_LIFE = 2210 -- 任务变量组
tbMessagePush.TASK_GROUP_MONTH = 2211 -- 第一个任务变量记得是月份，第二个开始才是任务信息
tbMessagePush.TASK_GROUP_WEEK = 2212 -- 第一个任务变量记得是周数，第二个开始才是任务信息
tbMessagePush.TASK_GROUP_DAY = 2213 -- 第一个任务变量记得是天数，第二个开始才是任务信息
tbMessagePush.MAX_TASK_COUNT_LIFE = 10 -- 伴随一生的最多任务变量个数
tbMessagePush.MAX_TASK_COUNT_MONTH = 10 -- 每月的最多任务变量个数
tbMessagePush.MAX_TASK_COUNT_WEEK = 10 -- 每周的最多任务变量个数
tbMessagePush.MAX_TASK_COUNT_DAY = 10 -- 每日的最多任务变量个数
