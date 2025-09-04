--参数1的值 = BaseValue1*multiple^(nLevel-1)
--local function jiecheng(multiple, BaseValue1, BaseValue2, BaseValue3)
--	multiple = multiple or 1.1;
--	BaseValue2 = BaseValue2 or 0;
--	BaseValue3 = BaseValue3 or 0;
--	local tb = {};
--	tb[1], tb[2], tb[3] = {}, {}, {};
--
--	tb[1][1] = {1, math.floor(BaseValue1/3)};
--	tb[2][1] = {1, math.floor(BaseValue2/3)};
--	tb[3][1] = {1, math.floor(BaseValue3/3)};
--	for i=2,64 do
--		tb[1][i] = {i, math.floor(BaseValue1*multiple^(i-1))};
--		tb[2][i] = {i, math.floor(BaseValue2)};
--		tb[3][i] = {i, math.floor(BaseValue3)};
--	end
--	return tb;
--end
if MODULE_GC_SERVER then
  return
end

local tbGemValue = Lib:LoadTabFile("\\setting\\item\\001\\magic\\stonevalue.txt")

----
local function GetGemValue(szIndex)
  local tb = {}
  tb[1], tb[2], tb[3] = {}, {}, {}
  for i, _ in pairs(tbGemValue) do
    tb[1][i] = { i, tonumber(tbGemValue[i][szIndex]) }
    tb[2][i] = { i, 0 }
    tb[3][i] = { i, 0 }
  end
  return tb
end

--宝石相关属性

-- 定制的属性，已经生成好数值的
local tbFix = {
  --特殊宝石数值比普通宝石要高20%
  --生命内力宝石_千分比形式
  lifeandmana_p = {
    lifemax_permillage = GetGemValue("lifeandmana_p"),
    manamax_permillage = GetGemValue("lifeandmana_p"),
  },
  --生命内力宝石_点数形式
  lifeandmana_v = {
    lifemax_v = GetGemValue("lifeandmana_v"),
    manamax_v = GetGemValue("lifeandmana_v"),
  },
  resist0 = { damage_all_resist = GetGemValue("resist0") },
  resist1 = { damage_physics_resist = GetGemValue("resist1") },
  resist2 = { damage_poison_resist = GetGemValue("resist2") },
  resist3 = { damage_cold_resist = GetGemValue("resist3") },
  resist4 = { damage_fire_resist = GetGemValue("resist4") },
  resist5 = { damage_light_resist = GetGemValue("resist5") },
  --减时间
  --resist_time0	= {allseriesstateresisttime	= GetGemValue("resist_time0")},
  resist_time1 = { state_hurt_resisttime = GetGemValue("resist_time1") },
  resist_time2 = { state_weak_resisttime = GetGemValue("resist_time2") },
  resist_time3 = { state_slowall_resisttime = GetGemValue("resist_time3") },
  resist_time4 = { state_burn_resisttime = GetGemValue("resist_time4") },
  resist_time5 = { state_stun_resisttime = GetGemValue("resist_time5") },
  --减几率
  --resist_rate0	= {allseriesstateresistrate	= GetGemValue("resist_rate0")},
  resist_rate1 = { state_hurt_resistrate = GetGemValue("resist_rate1") },
  resist_rate2 = { state_weak_resistrate = GetGemValue("resist_rate2") },
  resist_rate3 = { state_slowall_resistrate = GetGemValue("resist_rate3") },
  resist_rate4 = { state_burn_resistrate = GetGemValue("resist_rate4") },
  resist_rate5 = { state_stun_resistrate = GetGemValue("resist_rate5") },
  --加时间
  attack_time0 = { allseriesstateattacktime = GetGemValue("attack_time0") },
  --加几率
  attack_rate0 = { allseriesstateattackrate = GetGemValue("attack_rate0") },
  --减负面时间和几率
  resist_time0_sp = { allspecialstateresisttime = GetGemValue("resist_time0_sp") },
  resist_rate0_sp = { allspecialstateresistrate = GetGemValue("resist_rate0_sp") },
  --加负面时间和几率
  attack_time0_sp = { allspecialstateattacktime = GetGemValue("attack_time0_sp") },
  attack_rate0_sp = { allspecialstateattackrate = GetGemValue("attack_rate0_sp") },
  --外功系五行伤害百分比
  phy_atk_p1 = { addphysicsdamage_p = GetGemValue("phy_atk_p1") },
  phy_atk_p2 = { add_physicpoisondamage_p = GetGemValue("phy_atk_p2") },
  phy_atk_p3 = { add_physiccolddamage_p = GetGemValue("phy_atk_p3") },
  phy_atk_p4 = { add_physicfiredamage_p = GetGemValue("phy_atk_p4") },
  phy_atk_p5 = { add_physiclightdamage_p = GetGemValue("phy_atk_p5") },
  --内功系五行伤害百分比
  mag_atk_p1 = { addphysicsmagic_p = GetGemValue("mag_atk_p1") },
  mag_atk_p2 = { add_magicpoisondamage_p = GetGemValue("mag_atk_p2") },
  mag_atk_p3 = { add_magiccolddamage_p = GetGemValue("mag_atk_p3") },
  mag_atk_p4 = { add_magicfiredamage_p = GetGemValue("mag_atk_p4") },
  mag_atk_p5 = { add_magiclightdamage_p = GetGemValue("mag_atk_p5") },

  --经验宝石
  addexp_p = { expenhance_p = { { { 1, 5 }, { 2, 5 } } } },

  add_cri = { deadlystrikeenhance_r = GetGemValue("add_cri") },
  reduce_cri = { cri_resist = GetGemValue("reduce_cri") },

  --增加技能等级，除20级和80级门派技能
  level10_added = { skilllevel_added = { { { 1, 1 }, { 2, 1 } }, { { 1, 1 }, { 2, 1 } } } },
  level30_added = { skilllevel_added = { { { 1, 2 }, { 2, 2 } }, { { 1, 1 }, { 2, 1 } } } },
  level40_added = { skilllevel_added = { { { 1, 3 }, { 2, 3 } }, { { 1, 1 }, { 2, 1 } } } },
  level50_added = { skilllevel_added = { { { 1, 4 }, { 2, 4 } }, { { 1, 1 }, { 2, 1 } } } },
  level60_added = { skilllevel_added = { { { 1, 5 }, { 2, 5 } }, { { 1, 1 }, { 2, 1 } } } },
  level70_added = { skilllevel_added = { { { 1, 6 }, { 2, 6 } }, { { 1, 1 }, { 2, 1 } } } },
  level90_added = { skilllevel_added = { { { 1, 7 }, { 2, 7 } }, { { 1, 1 }, { 2, 1 } } } },
  level100_added = { skilllevel_added = { { { 1, 8 }, { 2, 8 } }, { { 1, 1 }, { 2, 1 } } } },
  level110_added = { skilllevel_added = { { { 1, 9 }, { 2, 9 } }, { { 1, 1 }, { 2, 1 } } } },
  level120_added = { skilllevel_added = { { { 1, 10 }, { 2, 10 } }, { { 1, 1 }, { 2, 1 } } } },
  jumplevel_added = { skilllevel_added = { { { 1, 11 }, { 2, 11 } }, { { 1, 1 }, { 2, 1 } } } },
  midbooklevel_added = { skilllevel_added = { { { 1, 12 }, { 2, 12 } }, { { 1, 1 }, { 2, 1 } } } },
  adbooklevel_added = { skilllevel_added = { { { 1, 13 }, { 2, 13 } }, { { 1, 1 }, { 2, 1 } } } },
}
Item.tbStone = Item.tbStone or {}
Item.tbStone.tbStoneMagic = {}
Item.tbStone.tbStoneMagic["fix"] = tbFix
Item.tbStone.tbStoneMagic["line"] = tbLine
