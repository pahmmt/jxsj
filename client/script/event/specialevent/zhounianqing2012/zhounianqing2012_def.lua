SpecialEvent.ZhouNianQing2012 = SpecialEvent.ZhouNianQing2012 or {}
local ZhouNianQing2012 = SpecialEvent.ZhouNianQing2012

ZhouNianQing2012.nEventStartTime = 20121009
ZhouNianQing2012.nEventEndTime = 20121021

-- 大天灯活动时间
ZhouNianQing2012.tbDaTianDengEventTime = {
  { 1300, 1425 },
  { 2000, 2125 },
}

ZhouNianQing2012.tbXiaoTianDengEventTime = {
  { 1330, 1427 },
  { 2030, 2127 },
}

ZhouNianQing2012.MAX_YANHUA_USE_COUNT = 4
ZhouNianQing2012.MAX_HONGZHU_USE_COUNT = 3
ZhouNianQing2012.MAX_ZIKA_DAY_COUNT = 8

ZhouNianQing2012.TASK_GROUP_ID = 2167
ZhouNianQing2012.TASK_ID_YANHUA_GET_TIME = 11 -- 烟花获取时间
ZhouNianQing2012.TASK_ID_YANHUA_USE_COUNT = 12 -- 使用次数
ZhouNianQing2012.TASK_ID_PROMISE_TYPE = 13 -- 许愿类型
ZhouNianQing2012.TASK_ID_PROMISE_TIME = 14 -- 许愿时间
ZhouNianQing2012.TASK_ID_HONGZHU_USE_COUNT = 15 -- 点燃小天灯次数
ZhouNianQing2012.TASK_ID_HEBI_USE_TIME = 16 -- 合璧时间
ZhouNianQing2012.TASK_ID_HEBI_USE_COUNT = 17 -- 合璧次数
ZhouNianQing2012.TASK_ID_GET_HONGBAO = 18 -- 获取红包时间
ZhouNianQing2012.TASK_ID_PROMISE_AWARD = 19 -- 许愿奖励标记
ZhouNianQing2012.TASK_ID_HONGZHU_USE_TIME = 20 -- 红烛使用时间

ZhouNianQing2012.TASK_GROUP_ID_ZIKA = 2205
ZhouNianQing2012.TASK_ID_ZIKA_DATE = 5 -- 字卡获得时间
ZhouNianQing2012.TASK_ID_ZIKA_COUNT = 6 -- 字卡获得数量

ZhouNianQing2012.MAX_HEBI_COUNT = 2

ZhouNianQing2012.tbItem_YanHua = { 18, 1, 1829, 1 }
ZhouNianQing2012.tbItem_HongZhu = { 18, 1, 1830, 1 } -- 红烛
ZhouNianQing2012.tbItem_XiaoTianDengLiBao = { 18, 1, 1835, 1 } -- 小天灯礼包
ZhouNianQing2012.nTime_XiaoTianDengLiBao = 3600 * 24 * 30

ZhouNianQing2012.nJoinLevel = 30
ZhouNianQing2012.tbDaTianDengNormalAward = { 18, 1, 1833, 1 }

ZhouNianQing2012.tbDoubleBi = {
  { 18, 1, 1827, 1 },
  { 18, 1, 1827, 2 },
}
ZhouNianQing2012.tbFinalBi = { 18, 1, 1827, 3 }
ZhouNianQing2012.tbDaHongBao = { 18, 1, 1828, 1 }
ZhouNianQing2012.tbHongBaoMsg = {
  "喜迎剑世四周年，大红礼包大黄金",
  "剑世四年，感谢有你，共闯江湖",
  "剑世四周年，绑金滚滚来",
  "谢谢CCXV，谢谢我的好友",
  "剑侠四周年，邀旧友再江湖！",
}

ZhouNianQing2012.tbMeiGuiHua = { 18, 1, 1655, 1 }

ZhouNianQing2012.nXiaoTianDeng1 = 11156
ZhouNianQing2012.nXiaoTianDeng2 = 11165

ZhouNianQing2012.tbXiaoTianDengNpcId = {
  [ZhouNianQing2012.nXiaoTianDeng1] = 1980,
  [ZhouNianQing2012.nXiaoTianDeng2] = 1981,
}

ZhouNianQing2012.tbXiaoTianDengNpcObj = {}
