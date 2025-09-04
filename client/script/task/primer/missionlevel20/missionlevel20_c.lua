-- 文件名　：missionlevel20_c.lua
-- 创建者　：lgy
-- 创建时间：2012-03-29 09:53:45
-- 描述：客户端一些东西

if not MODULE_GAMECLIENT then
  return 0
end

Task.PrimerLv20 = Task.PrimerLv20 or {}
local PrimerLv20 = Task.PrimerLv20

--不同门派路线的10级技能id
PrimerLv20.tbLv10FightSkillId = {
  [1] = { [1] = 21, [2] = 29 },
  [2] = { [1] = 38, [2] = 50 },
  [3] = { [1] = 69, [2] = 59 },
  [4] = { [1] = 76, [2] = 86 },
  [5] = { [1] = 96, [2] = 107 },
  [6] = { [1] = 111, [2] = 120 },
  [7] = { [1] = 128, [2] = 137 },
  [8] = { [1] = 143, [2] = 151 },
  [9] = { [1] = 159, [2] = 167 },
  [10] = { [1] = 175, [2] = 188 },
  [11] = { [1] = 194, [2] = 205 },
  [12] = { [1] = 213, [2] = 226 },
  [13] = { [1] = 2803, [2] = 2821 },
}

function PrimerLv20:SetLeftSkill()
  if me.nFaction <= 0 or me.nRouteId <= 0 then
    return 0
  end
  local nSkillId = self.tbLv10FightSkillId[me.nFaction][me.nRouteId]
  if me.IsHaveSkill(nSkillId) == 1 and me.nLeftSkill ~= nSkillId then
    me.nLeftSkill = nSkillId
  end
end
