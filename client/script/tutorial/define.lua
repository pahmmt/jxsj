if MODULE_GAMESERVER or MODULE_GC_SERVER then
  return
end

Tutorial.nGroupId = 2181 --任务变量组
Tutorial.nOpenId = 1 --开关任务变量
Tutorial.nAutoFight = 2 -- 自动战斗记录次数
Tutorial.nCreateRoleTime = 3 -- 设置玩家创建时间
Tutorial.nTeQuan_CaiTime = 4 -- 菜指引的判断时间
Tutorial.nTeQuan_ChuWuXiangTime = 5 -- 储物箱指引的判断时间
Tutorial.nTeQuan_XuanJingTime = 6 -- 玄晶特权指引的判断时间

Tutorial.tbEvent = Tutorial.tbEvent or {} --指引的所有类型
Tutorial.nTaskId = Tutorial.nTaskId or 0 --当前指引大类
Tutorial.nSubId = Tutorial.nSubId or 0 --当前指引小类
Tutorial.nTimer = Tutorial.nTimer or 0 --当前指引时钟
Tutorial.szLastTurorial = Tutorial.szLastTurorial or "" --上次指引类型
Tutorial.nLock = Tutorial.nLock or 0 --锁（对话和按钮默认锁住指引，防止自动触发的多余步骤）
Tutorial.tbParamFinishAction = Tutorial.tbParamFinishAction or {} --触发类条件
Tutorial.tbDialogAuto = Tutorial.tbDialogAuto or {} --对话自动触发管理table
Tutorial.tbTaskListAuto = Tutorial.tbTaskListAuto or {} --任务列表自动触发管理table

Tutorial.tbFinishAction = Tutorial.tbFinishAction or {} --完成指引事件
Tutorial.tbCloseAction = Tutorial.tbCloseAction or {} --打断关闭指引事件
Tutorial.tbReAction = Tutorial.tbReAction or {} --重新开始指引事件
Tutorial.tbActionWnd = Tutorial.tbActionWnd or {} --显示tip的控件

Tutorial.tbPopRec = Tutorial.tbPopRec or {}

function Tutorial:GetState()
  return me.GetTask(self.nGroupId, self.nOpenId)
end
