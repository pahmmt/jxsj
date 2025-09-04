local tbXisuidashi = Npc:GetClass("xisuidashi")

function tbXisuidashi:OnDialog()
  local tbOpt = {}

  local nChangeGerneIdx = Faction:GetChangeGenreIndex(me)
  if nChangeGerneIdx >= 1 then
    local szMsg
    if Faction:Genre2Faction(me, nChangeGerneIdx) > 0 then --该种类已修
      szMsg = "我要更换辅修门派"
    else
      szMsg = "我要选择辅修门派"
    end
    table.insert(tbOpt, { szMsg, self.OnChangeGenreFaction, self, me })
  end

  table.insert(tbOpt, { "洗潜能点", self.OnResetDian, self, me, 1 })
  table.insert(tbOpt, { "洗技能点", self.OnResetDian, self, me, 2 })
  table.insert(tbOpt, { "洗潜能点和技能点", self.OnResetDian, self, me, 0 })
  table.insert(tbOpt, { "再考虑考虑" })

  local szMsg = "我可帮你洗去已分配的潜能点和技能点，供你重新分配。在后方有一个山洞，可以在其中进行战斗体验测试重新分配后的效果。如果不满意，可以再来找我。当你满意后，可从门派传送人处回到你的门派。"
  Dialog:Say(szMsg, tbOpt)
end

function tbXisuidashi:OnResetDian(pPlayer, nType)
  local szMsg = ""

  -- GM号
  if me.GetCamp() == 6 then
    if me.IsHaveSkill(91) then
      me.DelFightSkill(91) -- 银丝飞蛛
    end
    if me.IsHaveSkill(163) then
      me.DelFightSkill(163) -- 梯云纵
    end
    if me.IsHaveSkill(1417) then
      me.DelFightSkill(1417) -- 1级移形换影
    end
  end

  if 1 == nType then
    pPlayer.SetTask(2, 1, 1)
    pPlayer.UnAssignPotential()
    szMsg = "洗髓成功！你以前已分配的潜能点可以重新分配了。"
  elseif 2 == nType then
    pPlayer.ResetFightSkillPoint()
    szMsg = "洗髓成功！你以前已分配的技能点可以重新分配了。"
  elseif 0 == nType then
    pPlayer.ResetFightSkillPoint()
    pPlayer.SetTask(2, 1, 1)
    pPlayer.UnAssignPotential()
    szMsg = "洗髓成功！你以前已分配的潜能点和技能点可以重新分配了。"
  end

  -- GM号
  if me.GetCamp() == 6 then
    me.AddFightSkill(91, 60) -- 银丝飞蛛
    me.AddFightSkill(163, 60) -- 梯云纵
    me.AddFightSkill(1417, 1) -- 1级移形换影
  end

  Setting:SetGlobalObj(pPlayer)
  Dialog:Say(szMsg)
  Setting:RestoreGlobalObj()
end

function tbXisuidashi:OnChangeGenreFaction(pPlayer)
  local tbOpt = {}
  local nFactionGenre = Faction:GetChangeGenreIndex(pPlayer)
  for nFactionId, tbFaction in ipairs(Player.tbFactions) do
    if Faction:CheckGenreFaction(pPlayer, nFactionGenre, nFactionId) == 1 then
      table.insert(tbOpt, { tbFaction.szName, self.OnChangeGenreFactionSelected, self, pPlayer, nFactionId })
    end
  end
  table.insert(tbOpt, { "结束对话" })

  local szMsg = "符合你自身条件的辅修门派有如下，请选择加入。"

  Setting:SetGlobalObj(pPlayer)
  Dialog:Say(szMsg, tbOpt)
  Setting:RestoreGlobalObj()
end

function tbXisuidashi:OnChangeGenreFactionSelected(pPlayer, nFactionId)
  local nGenreId = Faction:GetChangeGenreIndex(pPlayer)
  local nPrevFaction = Faction:Genre2Faction(pPlayer, nGenreId)
  local nResult, szMsg = Faction:ChangeGenreFaction(pPlayer, nGenreId, nFactionId)
  if nResult == 1 then
    if nPrevFaction == 0 then -- 第一次多修
      szMsg = "你已选择加入%s，使用修炼珠可以进行门派的切换，同时<color=yellow>五行印和披风<color>也会自动切换为相应门派适合的五行，<color=yellow>并保留原有的等级和属性<color>。<enter>切换到辅修门派后，可以自行加点，在<color=yellow>商人<color>处购买合适的武器，并在洗髓岛山洞内试验效果。<enter>如果不满意，可以回来找老夫更换辅修门派。待到满意时，可以找<color=yellow>门派传送人<color>离岛。<enter>离岛后，便正式确定了辅修门派，<color=yellow>不可再度更改<color>，定要慎重抉择。"
    else
      szMsg = "你的辅修门派已更换为%s，使用修炼珠，可以进行门派的切换，同时<color=yellow>五行印和披风<color>也会自动切换为相应门派适合的五行，<color=yellow>并保留原有的等级和属性<color>。<enter>切换到辅修门派后，可以自行加点，在<color=yellow>商人<color>处购买合适的武器，并在洗髓岛山洞内试验效果。<enter>如果不满意，可以回来找老夫更换辅修门派。待到满意时，可以找<color=yellow>门派传送人<color>离岛。<enter>离岛后，便正式确定了辅修门派，<color=yellow>不可再度更改<color>，定要慎重抉择。"
    end
    szMsg = string.format(szMsg, Player.tbFactions[nFactionId].szName)
  end

  Setting:SetGlobalObj(pPlayer)
  Dialog:Say(szMsg)
  Setting:RestoreGlobalObj()
end

local tbXisuimenpai = Npc:GetClass("xisuimenpaichuansongren")

function tbXisuimenpai:OnDialog()
  local nChangeGerne = Faction:GetChangeGenreIndex(me)
  local szMsg
  if nChangeGerne > 0 then -- 我来这儿多修
    szMsg = "当你对辅修门派的选择已经满意后，可以找我把你送回你的门派。"
  else
    szMsg = "当你洗髓已经满意后，可以找我把你送回你的门派。"
  end

  local tbOpt = {
    { "离开洗髓岛", self.OnCheckLeave, self, me },
    { "结束对话" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbXisuimenpai:OnCheckLeave(pPlayer)
  local nChangeGerne = Faction:GetChangeGenreIndex(pPlayer)
  local szMsg, tbOpt
  if nChangeGerne > 0 then -- 我来这儿多修
    if Faction:Genre2Faction(pPlayer, nChangeGerne) <= 0 then
      szMsg = "你还没有选择辅修门派，不能离开洗髓岛。"
    elseif pPlayer.IsAccountLock() == 1 then
      szMsg = "你的帐号处于锁定状态，而且你正在多修，因此暂不能从洗髓岛离开。"
    else
      szMsg = "<enter>离岛后，便正式确定了辅修门派，<color=yellow>不可再度更改<color>，定要慎重抉择。你已确定了辅修门派，想要离开了吗？"
      tbOpt = {
        { "嗯，现在就离开", self.OnLeave, self, pPlayer },
        { "我还要再斟酌一下" },
      }
    end
  else
    szMsg = "你确定洗髓已经满意，想要离开了吗？"
    tbOpt = {
      { "嗯，现在就离开", self.OnLeave, self, pPlayer },
      { "结束对话" },
    }
  end
  Setting:SetGlobalObj(pPlayer)
  Dialog:Say(szMsg, tbOpt)
  Setting:RestoreGlobalObj()
end

function tbXisuimenpai:OnLeave(pPlayer)
  local nChangeFactionIndex = Faction:GetChangeGenreIndex(pPlayer)
  local nChangedFaction
  if nChangeFactionIndex > 0 then -- 我来这儿多修
    nChangedFaction = Faction:Genre2Faction(pPlayer, nChangeFactionIndex)
    Faction:WriteLog(Dbg.LOG_INFO, "tbXisuimenpai:OnLeave", pPlayer.szName, nChangeFactionIndex, nChangedFaction)
    Faction:SetChangeGenreIndex(pPlayer, 0)
  end

  assert(pPlayer.nFaction)
  Npc.tbMenPaiNpc:Transfer(pPlayer.nFaction)

  if nChangeFactionIndex > 0 then
    pPlayer.Msg("你已成功辅修了" .. Player.tbFactions[nChangedFaction].szName)
    --成就
    if nChangeFactionIndex == 2 then
      Achievement:FinishAchievement(pPlayer, 64)
    elseif nChangeFactionIndex == 3 then
      Achievement:FinishAchievement(pPlayer, 65)
    end
    --end
  end
end
