--修炼丹
--sunduoliang
--2008.11.24

local tbItem = Item:GetClass("xiuliandan")
tbItem.TaskGourp = 2024
tbItem.TaskId_Day = 18
tbItem.TaskId_Count = 19
tbItem.Use_Max = EventManager.IVER_nXiulindanMaxUse

function tbItem:OnUse()
  local nDate = tonumber(GetLocalDate("%y%m%d"))
  if me.GetTask(self.TaskGourp, self.TaskId_Day) < nDate then
    me.SetTask(self.TaskGourp, self.TaskId_Day, nDate)
    me.SetTask(self.TaskGourp, self.TaskId_Count, 0)
  end
  local nCount = me.GetTask(self.TaskGourp, self.TaskId_Count)
  if nCount >= self.Use_Max then
    Dialog:Say(string.format("每天最多只能使用%d个修炼丹。", tbItem.Use_Max))
    return 0
  end

  local tbXiuLianZhu = Item:GetClass("xiulianzhu")
  if tbXiuLianZhu:GetReTime() > 12 then
    Dialog:Say("您的修炼时间还剩余12小时以上，不能使用修炼丹！")
    return 0
  end
  tbXiuLianZhu:AddRemainTime(120)
  me.Msg(string.format("您的修炼时间增加了<color=green>2小时<color>，您今天已使用了<color=yellow>%s颗<color>修炼丹。", nCount + 1))
  me.SetTask(self.TaskGourp, self.TaskId_Count, nCount + 1)
  return 1
end

function tbItem:GetTip(nState)
  return string.format("神丹，服用后可<color=gold>增加2小时<color>修炼珠的修炼时间，每天最多服用<color=gold>%d瓶<color>。<enter><color=gold>累计修炼时间不可超过14小时。<color>", self.Use_Max)
end
