-- 文件名  : xindeshu.lua
-- 创建者  : jiazhenwei
-- 创建时间: 2010-07-02 11:41:17
-- 描述    : 心得书

--未修炼的经验书
local tbXinDeShu = Item:GetClass("xindeshu")

function tbXinDeShu:OnUse()
  if me.nLevel < Task.TaskExp.nLevel_UseXindeshu then
    Dialog:Say(string.format("您的等级不足%s级，不能使用心得书！", Task.TaskExp.nLevel_UseXindeshu), { "知道了" })
    return
  end
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("需要1格背包空间！", { "知道了" })
    return 0
  end
  local nRegisterId = me.GetTask(Task.TaskExp.TASK_GID, Task.TaskExp.TASK_TASKID)
  if nRegisterId <= 0 then
    nRegisterId = PlayerEvent:Register("OnAddInsightNew", Task.TaskExp.OnAddInsight, Task.TaskExp)
    me.SetTask(Task.TaskExp.TASK_GID, Task.TaskExp.TASK_TASKID, nRegisterId)
  end
  me.AddItem(unpack(Task.TaskExp.tbXinDeShu_ing))
  return 1
end
-------------------------------------------------------------------------------------------------------------------
--正在修炼的经验书
local tbXinDeShuing = Item:GetClass("xindeshuing")
function tbXinDeShuing:GetTip()
  local nCurInsight = it.GetGenInfo(1) --当前经验值
  local nMaxLimit = Task.TaskExp.tbExp[me.nLevel][1]
  return string.format("<color=green>修炼经验：%s/%s<color>", nCurInsight, nMaxLimit)
end

-------------------------------------------------------------------------------------------------------------------
--修炼好的经验书
local tbXinDeShued = Item:GetClass("xindeshued")
tbXinDeShued.DISUSELEVEL = Item.IVER_nInsightbookLevel --低于书多少级才能使用

function tbXinDeShued:OnUse()
  if Player:CheckTask(Task.TaskExp.TASK_GID, Task.TaskExp.TASK_DATE, "%Y%m%d", Task.TaskExp.TASK_USENUM, Task.TaskExp.nUseXindeMaxNum) == 0 then
    me.Msg("你已经达到了本日使用心得书的上限，请明天再试。")
    return 0
  end
  local nTodayUsedCount = me.GetTask(Task.TaskExp.TASK_GID, Task.TaskExp.TASK_USENUM)
  if me.nLevel < Task.TaskExp.nLevel_UseXindeshued then
    me.Msg(string.format("只有%s级以上玩家可以使用心得书。", Task.TaskExp.nLevel_UseXindeshued))
    return 0
  end

  local nCreatLevel = it.GetGenInfo(1)
  local nCanUseLevel = nCreatLevel - self.DISUSELEVEL + 1
  if me.nLevel >= nCanUseLevel then
    me.Msg("你的等级已经超过这本心得书的使用等级，书中内容已经不能带给你什么。")
    return 0
  end

  me.SetTask(Task.TaskExp.TASK_GID, Task.TaskExp.TASK_USENUM, nTodayUsedCount + 1)

  local nAddExp = Task.TaskExp.tbExp[me.nLevel][2]

  -- 当玩家等级与心得书等级的奖励倍率
  local nDelta = nCreatLevel - me.nLevel
  if nDelta >= 50 then -- 心得书等级-角色等级 >=30且<50，则获得2倍经验
    nAddExp = nAddExp * 3
  elseif nDelta >= 30 then -- 心得书等级-角色等级 >=50，则获得3倍经验
    nAddExp = nAddExp * 2
  end

  -- 如果是使用师傅修炼的心得书，那么增加亲密度并且获得的经验是原来的两倍
  local szCreaterName = it.szCustomString
  local szTeacherName = me.GetTrainingTeacher()
  if szCreaterName and szTeacherName and szCreaterName == szTeacherName then
    Relation:AddFriendFavor(me.szName, szTeacherName, Task.TaskExp.nFAVOR)
    me.Msg("由于这本心得书是你的师傅制作，使用后你们之间亲密度增加<color=yellow>" .. Task.TaskExp.nFAVOR .. "点<color>。")
    nAddExp = nAddExp * 2
  end

  me.AddExp(nAddExp)
  me.Msg(string.format("你通过参悟书中心得，功力大涨！你获得了（%d）点经验！", nAddExp))

  return 1
end

--	显示使用等级以及使用后能获得的经验数，并提示玩家一天内最多能使用多少本心得书
function tbXinDeShued:GetTip()
  local nCreatLevel = it.GetGenInfo(1)
  local nAddExp = Task.TaskExp.tbExp[me.nLevel][2]
  local nTodayUsedCount = me.GetTask(Task.TaskExp.TASK_GID, Task.TaskExp.TASK_USENUM)

  local szTip = ""
  if me.nLevel < Task.TaskExp.nLevel_UseXindeshued then
    return "<color=0x8080ff>必须在" .. Task.TaskExp.nLevel_UseXindeshued .. "级以上方可使用心得书<color>\n\n"
  end
  local nCanUseLevel = nCreatLevel - self.DISUSELEVEL + 1
  if nCanUseLevel > 0 then
    szTip = szTip .. "<color=0x8080ff>使用等级：小于" .. nCreatLevel .. "级<color>\n\n"
  end

  szTip = szTip .. "<color=0x8080ff>可获得经验：" .. nAddExp .. "<color>\n\n"
  szTip = szTip .. "<color=0x8080ff>今天已经使用了：" .. nTodayUsedCount .. "/" .. Task.TaskExp.nUseXindeMaxNum .. "次<color>\n\n"

  local nLimitLevel = 0
  local nTimes = 1
  local szMsg = ""
  nLimitLevel = nCreatLevel - 30
  if nLimitLevel >= Task.TaskExp.nLevel_UseXindeshued then -- 心得书等级-角色等级 >=30且<50，则获得2倍经验
    nTimes = 2
    szTip = szTip .. "使用者等级不超过<color=yellow>" .. nLimitLevel .. "<color>级，可以获得<color=yellow>" .. nTimes .. "<color>倍效果\n\n"
  end

  nLimitLevel = nCreatLevel - 50
  if nLimitLevel > Task.TaskExp.nLevel_UseXindeshued then -- 心得书等级-角色等级 >=50，则获得3倍经验
    nTimes = 3
    szTip = szTip .. "使用者等级不超过<color=yellow>" .. nLimitLevel .. "<color>级，可以获得<color=yellow>" .. nTimes .. "<color>倍效果\n\n"
  end

  szTip = szTip .. "<color=orange>" .. it.szCustomString .. "<color> <color=green>制作<color>"
  return szTip
end

--修炼好的经验书
local tbXinDeShuZD = Item:GetClass("xindeshuzhuangding")

function tbXinDeShuZD:OnUse()
  if Player:CheckTask(Task.TaskExp.TASK_GID, Task.TaskExp.TASK_DATE, "%Y%m%d", Task.TaskExp.TASK_USENUM, Task.TaskExp.nUseXindeMaxNum) == 0 then
    me.Msg("你已经达到了本日使用心得书的上限，请明天再试。")
    return 0
  end
  local nTodayUsedCount = me.GetTask(Task.TaskExp.TASK_GID, Task.TaskExp.TASK_USENUM)
  if me.nLevel < Task.TaskExp.nLevel_UseXindeshued then
    me.Msg(string.format("只有%s级以上玩家可以使用心得书。", Task.TaskExp.nLevel_UseXindeshued))
    return 0
  end
  me.SetTask(Task.TaskExp.TASK_GID, Task.TaskExp.TASK_USENUM, nTodayUsedCount + 1)

  local nAddExp = Task.TaskExp.tbExp[me.nLevel][2]

  me.AddExp(nAddExp)
  me.Msg(string.format("你通过参悟书中心得，功力大涨！你获得了（%d）点经验！", nAddExp))

  return 1
end

function tbXinDeShuZD:GetTip()
  local nAddExp = Task.TaskExp.tbExp[me.nLevel][2]
  local nTodayUsedCount = me.GetTask(Task.TaskExp.TASK_GID, Task.TaskExp.TASK_USENUM)
  local szTip = ""
  if me.nLevel < Task.TaskExp.nLevel_UseXindeshued then
    return "<color=0x8080ff>必须在" .. Task.TaskExp.nLevel_UseXindeshued .. "级以上方可使用心得书<color>\n\n"
  end
  szTip = szTip .. "<color=0x8080ff>可获得经验：" .. nAddExp .. "<color>\n\n"
  szTip = szTip .. "<color=0x8080ff>今天已经使用了：" .. nTodayUsedCount .. "/" .. Task.TaskExp.nUseXindeMaxNum .. "次<color>\n\n"

  return szTip
end
