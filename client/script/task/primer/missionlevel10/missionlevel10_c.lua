-- 文件名　：missionlevel10_c.lua
-- 创建者　：zhangjunjie
-- 创建时间：2011-09-29 09:53:45
-- 描述：客户端一些东西

if not MODULE_GAMECLIENT then
  return 0
end

Task.PrimerLv10 = Task.PrimerLv10 or {}

local PrimerLv10 = Task.PrimerLv10

local tbLv10FightSkillId = --不同门派路线的10级技能id
  {
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

function PrimerLv10:SetLeftSkill()
  local nFaction = me.nFaction
  local nRouteId = me.nRouteId
  local nSkillId = tbLv10FightSkillId[nFaction] and tbLv10FightSkillId[nFaction][nRouteId] or nil
  if not nSkillId then
    return 0
  end
  if me.IsHaveSkill(nSkillId) == 1 and me.nLeftSkill ~= nSkillId then
    me.nLeftSkill = nSkillId
  end
end

--设置迷你客户端标记
function PrimerLv10:SetMiniClientSign()
  if MINI_CLIENT then
    me.SetTask(2180, 1, 1)
  else
    me.SetTask(2180, 1, 0)
  end
end
