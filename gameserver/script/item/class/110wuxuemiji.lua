-- 110wuxuemiji.lua
-- 2012/10/10 14:49:07
-- zhouchenfei
-- 110武学秘籍

local tbItem = Item:GetClass("110wuxuemiji")

tbItem.nTaskGroupId_110Skill = 1022
tbItem.nTaskId_110Skill = 215
tbItem.nMinLevel = 110
tbItem.nTaskGroupId_110Task = 1000
tbItem.tb110TaskId = {
  [Env.FACTION_ID_SHAOLIN] = 430,
  [Env.FACTION_ID_TIANWANG] = 431,
  [Env.FACTION_ID_TANGMEN] = 432,
  [Env.FACTION_ID_WUDU] = 433,
  [Env.FACTION_ID_EMEI] = 434,
  [Env.FACTION_ID_CUIYAN] = 435,
  [Env.FACTION_ID_GAIBANG] = 436,
  [Env.FACTION_ID_TIANREN] = 437,
  [Env.FACTION_ID_WUDANG] = 438,
  [Env.FACTION_ID_KUNLUN] = 439,
  [Env.FACTION_ID_MINGJIAO] = 440,
  [Env.FACTION_ID_DALIDUANSHI] = 441,
}

tbItem.tb110StepTaskId = {
  [Env.FACTION_ID_SHAOLIN] = 203,
  [Env.FACTION_ID_TIANWANG] = 204,
  [Env.FACTION_ID_TANGMEN] = 205,
  [Env.FACTION_ID_WUDU] = 206,
  [Env.FACTION_ID_EMEI] = 207,
  [Env.FACTION_ID_CUIYAN] = 208,
  [Env.FACTION_ID_GAIBANG] = 209,
  [Env.FACTION_ID_TIANREN] = 210,
  [Env.FACTION_ID_WUDANG] = 211,
  [Env.FACTION_ID_KUNLUN] = 212,
  [Env.FACTION_ID_MINGJIAO] = 213,
  [Env.FACTION_ID_DALIDUANSHI] = 214,
}

function tbItem:OnUse()
  local nFlag, szError = self:IsCanUseItem(me)
  if 1 ~= nFlag then
    me.Msg(szError)
    return 0
  end

  local szMsg = string.format("一本流失已久的武学秘籍，凡习者可学会当前职业<color=yellow>110级<color>技能，并且会<color=red>删除当前接的110级技能修炼任务<color>，你确定使用吗？")
  Dialog:Say(szMsg, {
    { "确定使用", self.OnSureUse, self, it.dwId },
    { "再考虑考虑" },
  })
  return 0
end

function tbItem:IsCanUseItem(pPlayer)
  if pPlayer.nFaction <= 0 then
    return 0, "少侠还未入门派，请入门派后再使用物品！"
  end

  if pPlayer.nFaction == Env.FACTION_ID_GUMU then
    return 0, "少侠你已经学会了这个门派路线的110级技能！"
  end

  if pPlayer.nLevel < self.nMinLevel then
    return 0, string.format("少侠等级未到达%s级，不能使用物品！", self.nMinLevel)
  end

  local nValue = pPlayer.GetTask(self.nTaskGroupId_110Skill, self.nTaskId_110Skill)
  local nFlag = KLib.GetBit(nValue, pPlayer.nFaction)
  if nFlag == 1 then
    local szRouteName = Player:GetFactionRouteName(pPlayer.nFaction)
    return 0, string.format("少侠你已经可以使用<color=yellow>%s<color>的110级武学技能了，无法使用此物品！", szRouteName)
  end

  if GetMapType(pPlayer.nMapId) ~= "city" and GetMapType(pPlayer.nMapId) ~= "village" and GetMapType(pPlayer.nMapId) ~= "faction" then
    return 0, "该物品只能在各大新手村、城市和门派使用。"
  end
  return 1
end

function tbItem:OnSureUse(dwItemId)
  local pItem = KItem.GetObjById(dwItemId)
  if not pItem then
    Dialog:Say("你的110武学秘籍异常！")
    return 0
  end

  local nFlag, szError = self:IsCanUseItem(me)
  if 1 ~= nFlag then
    Dialog:Say(szError)
    return 0
  end

  local nRet = pItem.Delete(me)
  if nRet ~= 1 then
    Dbg:WriteLog("110wuxuemiji", me.szName, "110武学秘籍扣除失败")
    return 0
  end

  local n110TaskId = self.tb110TaskId[me.nFaction]
  local n110TaskIdStep = self.tb110StepTaskId[me.nFaction]
  local n110TaskStep = me.GetTask(self.nTaskGroupId_110Skill, n110TaskIdStep)

  -- me.SetTask(1022,215,4095,1)--允许投点110技能
  Task:CloseTask(n110TaskId, "giveup") -- 放弃任务
  me.SetTask(self.nTaskGroupId_110Task, n110TaskId, 1) -- 设置任务完成标记
  local nValue = me.GetTask(self.nTaskGroupId_110Skill, self.nTaskId_110Skill) -- 设置上学会技能
  nValue = KLib.SetBit(nValue, me.nFaction, 1)
  me.SetTask(self.nTaskGroupId_110Skill, self.nTaskId_110Skill, nValue, 1)
  Dialog:Say(string.format("恭喜您学会了<color=yellow>110级<color>技能！"))
  Dbg:WriteLog("110wuxuemiji", me.szName, string.format("%s,%s,%s,%s,110武学秘籍使用成功", me.nFaction, n110TaskId, n110TaskIdStep, n110TaskStep))
  return 1
end
