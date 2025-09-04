Require("\\script\\task\\xiakedaily\\xiakedaily_def.lua")

function XiakeDaily:GetTask(nTaskId)
  return me.GetTask(self.TASK_GROUP, nTaskId)
end

function XiakeDaily:SetTask(nTaskId, nValue)
  me.SetTask(self.TASK_GROUP, nTaskId, nValue)
end

function XiakeDaily:OnAccept()
  if MODULE_GAMESERVER then
    local nTaskDay, nTask1, nTask2 = self:GetTaskValue()
    local szBlackMsg = "<npc=7346>：“或许你只身闯荡江湖，打遍武林高手；或许你少年成名，武功无人能敌。但以一己之力终究难以拯救大宋于水火。靖康耻，犹未雪；臣子恨，何时灭？”<end>"
    szBlackMsg = szBlackMsg .. string.format("<npc=7346>：“我只信不积跬步无以至千里，现在，我需要江湖各位侠客的鼎力相助，铲奸除恶，扬我大宋之威，从今日做起。今日你且前去完成%s和%s任务，我会尽我所能回报你的。”<end>", self.TaskFile[nTask1].szDynamicDesc, self.TaskFile[nTask2].szDynamicDesc)
    szBlackMsg = szBlackMsg .. "<playername>：“行侠仗义、除暴安良是我的责任，我定然全力以赴。”"
    TaskAct:Talk(szBlackMsg)
    self:LoadDate(self.TASK_MAIN_ID, nTask1, nTask2)
    self:SetTask(self.TASK_STATE, 1)
    self:SetTask(self.TASK_ACCEPT_DAY, nTaskDay)
    self:SetTask(self.TASK_ACCEPT_COUNT, self:GetTask(self.TASK_ACCEPT_COUNT) - 1)
  end
end

function XiakeDaily:DoAccept(tbTask, nTaskId, nReferId)
  if nTaskId == self.TASK_MAIN_ID and nReferId == self.TASK_MAIN_ID then
    XiakeDaily:OnAccept()
  end
end

function XiakeDaily:FinishExecute()
  if MODULE_GAMESERVER then
    XiakeDaily:SetWeekTimes()
  end
end
