-------------------------------------------------------------------
--File		: stall_client.lua
--Author	: ZouYing
--Date		: 2008-6-10 11:48
--Describe	: 摆摊客户端脚本
-------------------------------------------------------------------

Stall.TASK_GROUP_ID = 2032
Stall.TASK_TOTAL_TIME = 1 -- 许可摆摊累计时间,记录是分钟数

function Stall:ChenckPermit()
  if me.nLevel < 25 then
    me.Msg("官告：为整洁市容和避免商业欺诈行为，25 级以下民众一律禁止摆摊！")
    return
  end
  local nTotalTime = me.GetTask(Stall.TASK_GROUP_ID, Stall.TASK_TOTAL_TIME)
  if nTotalTime <= 0 then
    me.Msg("为整洁市容，请您在奇珍阁购买摆摊许可证使用后再摆摊。")
    return 0
  end
  return 1
end
