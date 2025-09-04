-- 状态显示相关

-- 状态描述定义
FightSkill.tbState = {}

-- 状态描述函数，0为默认
FightSkill.tbState.tbTipFunc = {
  [0] = function(self, nId, nSkillId, nLevel, szMsg, bBuff, nType, nLeftTime, nTotalTime)
    local szTip = self:MsgDesc(szMsg, bBuff)
    szTip = szTip .. self:LevelDesc(nLevel) .. "\n"
    szTip = szTip .. self:AttribDesc(nSkillId, nLevel)
    if nTotalTime > 0 then
      szTip = szTip .. "剩余时间：" .. Lib:FrameTimeDesc(nLeftTime)
    end
    return szTip
  end,
  [49] = function(self, nId, nSkillId, nLevel, szMsg, bBuff, nType, nLeftTime, nTotalTime)
    local szTip = self:MsgDesc(szMsg, bBuff)
    return szTip
  end,
  [65] = function(self, nId, nSkillId, nLevel, szMsg, bBuff, nType, nLeftTime, nTotalTime)
    local szTip = self:MsgDesc(szMsg, bBuff)
    szTip = szTip .. self:LevelDesc(nLevel) .. "\n"
    szTip = szTip .. self:AttribDesc(nSkillId, nLevel)
    if nTotalTime > 0 then
      szTip = szTip .. "剩余时间：" .. Lib:FrameTimeDesc(nLeftTime) .. "\n"
    end
    return szTip .. "剩余经验：<color=gold>" .. me.GetTask(1023, 3) .. "点<color>"
  end,
  --阵法相关技能
  [78] = function(self, nId, nSkillId, nLevel, szMsg, bBuff, nType, nLeftTime, nTotalTime)
    local tbSkillInfo = KFightSkill.GetSkillInfo(nSkillId, nLevel)
    local szTip = "<color=green>" .. tbSkillInfo.szName .. "<color>"
    szTip = szTip .. self:LevelDesc(nLevel) .. "\n"
    szTip = szTip .. self:AttribDesc2(tbSkillInfo)
    return szTip
  end,
  [148] = function(self, nId, nSkillId, nLevel, szMsg, bBuff, nType, nLeftTime, nTotalTime)
    return "升级五行印时，魂石效果提高20%\n强化装备费用减少20%\n每天可在修炼珠中额外领取0.5小时修炼时间\n使用义军令牌、白虎堂令牌、家族令牌、宋金令牌、门派竞技令牌获得的声望增加50%\n剩余时间：" .. Lib:FrameTimeDesc(nLeftTime)
  end,
  -- 装备剥离延迟：by zhangjinpin@kingsoft
  [342] = function(self, nId, nSkillId, nLevel, szMsg, bBuff, nType, nLeftTime, nTotalTime)
    if nLeftTime > (Item.MAX_PEEL_TIME - Item.VALID_PEEL_TIME) * Env.GAME_FPS then
      local nTime = Lib:FrameTimeDesc(nLeftTime - (Item.MAX_PEEL_TIME - Item.VALID_PEEL_TIME) * Env.GAME_FPS)
      return string.format("<color=yellow>%s<color=red>后可以转移或者剥离一件强化等级12或12以上的装备或者剥离一件青铜武器。<color>", nTime)
    else
      return "当前状态下可以转移或者剥离强化等级12或以上装备或者剥离一件青铜武器，剩余时间：" .. Lib:FrameTimeDesc(nLeftTime)
    end
  end,
  --偷取技能状态
  [303] = function(self, nId, nSkillId, nLevel, szMsg, bBuff, nType, nLeftTime, nTotalTime)
    nSkillId, nLevel = me.GetNpc().GetStealSkill()
    szMsg = FightSkill:GetSkillName(nSkillId)
    local szTip = self:MsgDesc(szMsg, bBuff)
    szTip = "当前已偷取：" .. szTip
    szTip = szTip .. self:LevelDesc(nLevel) .. "\n"
    szTip = szTip .. self:AttribDesc3(nSkillId, nLevel)
    if nTotalTime > 0 then
      szTip = szTip .. "剩余可用时间：" .. Lib:FrameTimeDesc(nLeftTime)
    end
    return szTip
  end,
  [430] = function(self, nId, nSkillId, nLevel, szMsg, bBuff, nType, nLeftTime, nTotalTime)
    local nValid_TIME = Partner.DEL_USABLE_MAXTIME - Partner.DEL_USABLE_MINTIME
    if nLeftTime > nValid_TIME * Env.GAME_FPS then
      local nTime = Lib:FrameTimeDesc(nLeftTime - nValid_TIME * Env.GAME_FPS)
      return string.format("<color=yellow>%s<color=red>后可以删除一个%0.1f星级以上或%d技能以上的同伴。<color>", nTime, Partner.DELLIMITSTARLEVEL, Partner.DELLIMITSKILLCOUNT)
    else
      return string.format("当前状态下可以删除一个%0.1f星级以上或%d技能以上的同伴，剩余时间：%s", Partner.DELLIMITSTARLEVEL, Partner.DELLIMITSKILLCOUNT, Lib:FrameTimeDesc(nLeftTime))
    end
  end,
  [431] = function(self, nId, nSkillId, nLevel, szMsg, bBuff, nType, nLeftTime, nTotalTime)
    local nValid_TIME = Partner.PEEL_USABLE_MAXTIME - Partner.PEEL_USABLE_MINTIME
    if nLeftTime > nValid_TIME * Env.GAME_FPS then
      local nTime = Lib:FrameTimeDesc(nLeftTime - nValid_TIME * Env.GAME_FPS)
      return string.format("<color=yellow>%s<color=red>后可以重生一个%0.1f星级或以上的同伴。<color>", nTime, Partner.PEELLIMITSTARLEVEL)
    else
      return string.format("当前状态下可以重生一个%0.1f星级或以上的同伴，剩余时间：%s", Partner.PEELLIMITSTARLEVEL, Lib:FrameTimeDesc(nLeftTime))
    end
  end,
  [432] = function(self, nId, nSkillId, nLevel, szMsg, bBuff, nType, nLeftTime, nTotalTime)
    local szTip = self:MsgDesc(szMsg, bBuff)
    return szTip
  end,
  [470] = function(self, nId, nSkillId, nLevel, szMsg, bBuff, nType, nLeftTime, nTotalTime)
    local nValid_TIME = Partner.BIND_PARTNERQUIP_MAXTIME - Partner.BIND_PARTNERQUIP_MINTIME
    if nLeftTime > nValid_TIME * Env.GAME_FPS then
      local nTime = Lib:FrameTimeDesc(nLeftTime - nValid_TIME * Env.GAME_FPS)
      return string.format("<color=yellow>%s<color=red>后可以解绑一件同伴装备。<color>", nTime)
    else
      return string.format("当前状态下可以解绑一件同伴装备，剩余时间：%s", Lib:FrameTimeDesc(nLeftTime))
    end
  end,
  [476] = function(self, nId, nSkillId, nLevel, szMsg, bBuff, nType, nLeftTime, nTotalTime)
    local nValid_TIME = Item.tbZhenYuan.UNBIND_MAX_TIME - Item.tbZhenYuan.UNBIND_MIN_TIME
    if nLeftTime > nValid_TIME * Env.GAME_FPS then
      local nTime = Lib:FrameTimeDesc(nLeftTime - nValid_TIME * Env.GAME_FPS)
      return string.format("<color=yellow>%s<color=red>后可以解绑真元。<color>", nTime)
    else
      return string.format("当前状态下可以解绑真元，剩余时间：%s", Lib:FrameTimeDesc(nLeftTime))
    end
  end,
  [576] = function(self, nId, nSkillId, nLevel, szMsg, bBuff, nType, nLeftTime, nTotalTime)
    local nValid_TIME = Item.tbStone.UNBIND_MAX_TIME - Item.tbStone.UNBIND_MIN_TIME
    if nLeftTime > nValid_TIME * Env.GAME_FPS then
      local nTime = Lib:FrameTimeDesc(nLeftTime - nValid_TIME * Env.GAME_FPS)
      return string.format("<color=yellow>%s<color=red>后可以解绑宝石。<color>", nTime)
    else
      return string.format("当前状态下可以解绑宝石，剩余时间：%s", Lib:FrameTimeDesc(nLeftTime))
    end
  end,
  [577] = function(self, nId, nSkillId, nLevel, szMsg, bBuff, nType, nLeftTime, nTotalTime)
    local nValid_TIME = Item.tbStone.BREAKUP_MAX_TIME - Item.tbStone.BREAKUP_MIN_TIME
    if nLeftTime > nValid_TIME * Env.GAME_FPS then
      local nTime = Lib:FrameTimeDesc(nLeftTime - nValid_TIME * Env.GAME_FPS)
      return string.format("<color=yellow>%s<color=red>后可以拆解高级原石。<color>", nTime)
    else
      return string.format("当前状态下可以拆解高级原石，剩余时间：%s", Lib:FrameTimeDesc(nLeftTime))
    end
  end,
  [584] = function(self, nId, nSkillId, nLevel, szMsg, bBuff, nType, nLeftTime, nTotalTime)
    return string.format("<color=green>正在参与家族高级副本的冒险<color>[%s级]\n剩余时间：%s", nLevel, Lib:FrameTimeDesc(nLeftTime))
  end,
  [587] = function(self, nId, nSkillId, nLevel, szMsg, bBuff, nType, nLeftTime, nTotalTime)
    return string.format("<color=green>战鼓\n参加家族副本有一定几率获得额外的古钱币或古金币<color>\n剩余时间：%s", Lib:FrameTimeDesc(nLeftTime))
  end,
  [588] = function(self, nId, nSkillId, nLevel, szMsg, bBuff, nType, nLeftTime, nTotalTime)
    return string.format("<color=green>秦洼的祝福<color>\n<color=yellow>在钓鱼活动中有机率钓到更好的鱼<color>\n<color=green>剩余时间：%s<color>", Lib:FrameTimeDesc(nLeftTime))
  end,
  [602] = function(self, nId, nSkillId, nLevel, szMsg, bBuff, nType, nLeftTime, nTotalTime)
    return string.format("<color=green>饮酒经验加成<color>\n在篝火燃烧时，在篝火旁可以获得额外的篝火经验加成。\n若同一队伍都喝酒，可获得最大160%%队伍篝火经验加成。\n剩余时间：%s<color>", Lib:FrameTimeDesc(nLeftTime))
  end,
  [714] = function(self, nId, nSkillId, nLevel, szMsg, bBuff, nType, nLeftTime, nTotalTime)
    return string.format("<color=green>战神酒<color>\n在新手村以及城市中的战神酒火塘旁自动可获得经验。重复使用战神酒获得经验的持续时间会累加。\n剩余时间：%s<color>", Lib:FrameTimeDesc(nLeftTime))
  end,
  [604] = function(self, nId, nSkillId, nLevel, szMsg, bBuff, nType, nLeftTime, nTotalTime)
    if nLeftTime > (Item.MAX_PEEL_TIME - Item.VALID_PEEL_TIME) * Env.GAME_FPS then
      local nTime = Lib:FrameTimeDesc(nLeftTime - (Item.MAX_PEEL_TIME - Item.VALID_PEEL_TIME) * Env.GAME_FPS)
      return string.format("<color=yellow>%s<color=red>后可以将一个护体真元降星转化为非护体真元。<color>", nTime)
    else
      return "当前状态下可以将一个护体真元降星转化为非护体真元，剩余时间：" .. Lib:FrameTimeDesc(nLeftTime)
    end
  end,
}

function FightSkill.tbState:MsgDesc(szMsg, bBuff)
  return string.format("<color=%s>%s<color>", (bBuff == 1 and "green") or "red", szMsg)
end

function FightSkill.tbState:AttribDesc(nSkillId, nLevel)
  if nSkillId <= 0 then
    return ""
  end
  local tbInfo = KFightSkill.GetStateInfo(nSkillId, nLevel)

  return self:AttribDesc2(tbInfo)
end

function FightSkill.tbState:AttribDesc2(tbSkillInfo)
  local tbMsg = {}
  local szSkillMsg = ""
  local tbDefault = FightSkill:GetClass("default")
  tbDefault:GetAllMagicsDesc(tbMsg, tbSkillInfo, 1)
  for _, szDesc in ipairs(tbMsg) do
    szSkillMsg = szSkillMsg .. szDesc .. "\n"
  end

  return szSkillMsg
end

function FightSkill.tbState:AttribDesc3(nSkillId, nLevel)
  if nSkillId <= 0 then
    return "当前没有偷取技能\n"
  end
  if not (self:GetSkillLevel(1212)) or (self:GetSkillLevel(1212) == 0) then
    return "当前没有习得偷龙转凤，无法使用\n"
  end
  local tbInfo = KFightSkill.GetSkillInfo(nSkillId, nLevel)
  local nTrueTime = KFightSkill.GetSkillInfo(1212, self:GetSkillLevel(1212)).nStateTime
  if tbInfo.nIsAura == 1 then
    nTrueTime = nTrueTime
  else
    nTrueTime = math.min(nTrueTime, tbInfo.nStateTime)
  end
  nTrueTime = math.floor(nTrueTime / Env.GAME_FPS * 10) / 10
  local szTimeTip = string.format("<color=white>持续时间：<color><color=gold>%s秒<color>\n", nTrueTime)

  return self:AttribDesc2(tbInfo) .. szTimeTip
end

function FightSkill.tbState:LevelDesc(nLevel)
  if nLevel <= 0 then
    return ""
  end
  return string.format(" [%d级]", nLevel)
end

-- 供程序调用，形成状态描述
function FightSkill.tbState:GetTip(nId, nSkillId, nLevel, szMsg, bBuff, nType, nLeftTime, nTotalTime)
  local fnTip = self.tbTipFunc[nId] or self.tbTipFunc[0]
  return fnTip(self, nId, nSkillId, nLevel, szMsg, bBuff, nType, nLeftTime, nTotalTime)
end

--查询指定技能
function FightSkill.tbState:GetSkillLevel(nSkillId)
  local fnFindSkillLevel = function(tbSkillList)
    for _, tbSkill in pairs(tbSkillList) do
      if tbSkill.uId == nSkillId then
        return tbSkill.nLevel
      end
    end
  end
  for i = 0, 2 do
    local tbSkillList = me.GetFightSkillList(i)
    local nLevel = fnFindSkillLevel(tbSkillList)
    if nLevel then
      return nLevel
    end
  end
end
