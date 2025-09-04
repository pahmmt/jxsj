-- 文件名  : christmas_c.lua
-- 创建者  : jiazhenwei
-- 创建时间: 2010-11-17 11:26:36
-- 描述    :  vn 圣诞节

---------------------------------------------------------------
--火柴

local tbHuoChai = Item:GetClass("HuoChai_vn")
tbHuoChai.TASKGID = 2147
tbHuoChai.TASK_HONGNUAN_DATA = 12 -- 烘暖小妹日期
tbHuoChai.TASK_HONGNUAN_COUNT = 13 -- 烘暖小妹每天次数
tbHuoChai.TASK_HONGNUAN_ALLCOUNT = 14 -- 烘暖小妹总次数

function tbHuoChai:GetTip(nState)
  local nCurDate = tonumber(GetLocalDate("%Y%m%d"))
  local nCurCount = me.GetTask(self.TASKGID, self.TASK_HONGNUAN_COUNT)
  if me.GetTask(self.TASKGID, self.TASK_HONGNUAN_DATA) < nCurDate then
    nCurCount = 0
  end
  local nCount = it.GetGenInfo(2)
  local szColor = "green"
  if nCount < 3 then
    szColor = "gray"
  end
  local szTip = string.format("<color=%s>烘暖卖火柴小妹%s/3<color>\n<color=yellow>今天已烘暖卖火柴小妹次数:%s\n总共烘暖卖火柴小妹次数:%s<color>", szColor, nCount, nCurCount, me.GetTask(self.TASKGID, self.TASK_HONGNUAN_ALLCOUNT))
  return szTip
end
