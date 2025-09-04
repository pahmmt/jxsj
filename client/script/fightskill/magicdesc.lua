local tbSeriesColor = {
  [Env.SERIES_NONE] = "white",
  [Env.SERIES_METAL] = "gold",
  [Env.SERIES_WOOD] = "wood",
  [Env.SERIES_WATER] = "water",
  [Env.SERIES_FIRE] = "fire",
  [Env.SERIES_EARTH] = "earth",
}

local function Add1(value1, value2, bEx2)
  if type(value1) == "table" then
    value1 = value1.nPoint
  end
  if type(value2) == "table" then
    value2 = value2.nPoint
  end
  if (not value2) or (value1 == value2) then
    local str = ""
    if value1 > 0 then
      str = "增加"
    elseif value1 < 0 then
      value1 = -value1
      str = "减少"
    end
    str = str .. value1
    return str
  else
    if value1 * value2 < 0 then
      assert(false)
      return
    end
    local str = ""
    if value2 > 0 then
      str = "增加"
    elseif value2 < 0 then
      value1 = -value1
      value2 = -value2
      str = "减少"
    end
    return string.format("%s%s%s%s", str, value1, (bEx2 == 1) and "→" or "到", value2)
  end
end

local function Add2(value1, value2, bEx2)
  if type(value1) == "table" then
    value1 = value1.nPoint
  end
  if type(value2) == "table" then
    value2 = value2.nPoint
  end
  if (not value2) or (value1 == value2) then
    local str = ""
    if value1 > 0 then
      str = "减少"
    elseif value1 < 0 then
      value1 = -value1
      str = "增加"
    end
    str = str .. value1
    return str
  else
    if value1 * value2 < 0 then
      assert(false)
      return
    end
    local str = ""
    if value2 > 0 then
      str = "减少"
    elseif value2 < 0 then
      value1 = -value1
      value2 = -value2
      str = "增加"
    end
    return string.format("%s%s%s%s", str, value1, (bEx2 == 1) and "→" or "到", value2)
  end
end

local function Add3(value1, value2, bEx2)
  if type(value1) == "table" then
    value1 = value1.nPoint
  end
  if type(value2) == "table" then
    value2 = value2.nPoint
  end
  if (not value2) or (value1 == value2) then
    local str = ""
    if value1 > 0 then
      str = "增强"
    elseif value1 < 0 then
      str = "削弱"
    end
    str = str .. value1
    return str
  else
    if value1 * value2 < 0 then
      assert(false)
      return
    end
    local str = ""
    if value2 > 0 then
      str = "增强"
    elseif value2 < 0 then
      value1 = -value1
      value2 = -value2
      str = "削弱"
    end
    return string.format("%s%s%s%s", str, value1, (bEx2 == 1) and "→" or "到", value2)
  end
end

local function Add4(value1, value2, bEx2)
  if type(value1) == "table" then
    value1 = value1.nPoint
  end
  if type(value2) == "table" then
    value2 = value2.nPoint
  end
  if (not value2) or (value1 == value2) then
    return tostring(value1)
  end
  return string.format("%s%s%s", value1, (bEx2 == 1) and "→" or "到", value2)
end

local function Add5(value1, value2, bEx2)
  if type(value1) == "table" then
    value1 = value1.nPoint
  end
  if type(value2) == "table" then
    value2 = value2.nPoint
  end
  if (not value2) or (value1 == value2) then
    local str = ""
    if value1 > 0 then
      str = "放大"
    elseif value1 < 0 then
      value1 = -value1
      str = "缩小"
    end
    str = str .. value1
    return str
  else
    if value1 * value2 < 0 then
      assert(false)
      return
    end
    local str = ""
    if value2 > 0 then
      str = "放大"
    elseif value2 < 0 then
      value1 = -value1
      value2 = -value2
      str = "缩小"
    end
    return string.format("%s%s%s%s", str, value1, (bEx2 == 1) and "→" or "到", value2)
  end
end

local function Add6(value1, value2, bEx2)
  if type(value1) == "table" then
    value1 = value1.nPoint
  end
  if type(value2) == "table" then
    value2 = value2.nPoint
  end
  if (not value2) or (value1 == value2) then
    local str = ""
    if value1 > 0 then
      str = "缩小"
    elseif value1 < 0 then
      value1 = -value1
      str = "放大"
    end
    str = str .. value1
    return str
  else
    if value1 * value2 < 0 then
      assert(false)
      return
    end
    local str = ""
    if value2 > 0 then
      str = "缩小"
    elseif value2 < 0 then
      value1 = -value1
      value2 = -value2
      str = "放大"
    end
    return string.format("%s%s%s%s", str, value1, (bEx2 == 1) and "→" or "到", value2)
  end
end

local function ChangeMagicTableToValue(tbMagic)
  if not tbMagic then
    return nil
  end
  for i = 2, 4 do
    if tbMagic[i] and type(tbMagic[i]) == "table" then
      tbMagic[i] = tbMagic[i].nPoint
    end
  end
  return tbMagic
end

local function Frame2Sec(value)
  if type(value) == "table" then
    value = value.nPoint
  end
  return math.floor(value / Env.GAME_FPS * 10) / 10
end

--毒伤时间转化为次数
local function Frame2Times(value)
  return math.floor(value * 2 / Env.GAME_FPS) + 1
end

--五行印点数转换为比例
local function v2p(value)
  local nP2 = KFightSkill.GetSetting().SeriesTrimParam2
  local nP3 = KFightSkill.GetSetting().SeriesTrimParam3
  local nMaxPer = KFightSkill.GetSetting().SeriesTrimMax
  --me.nLevel实际上是指目标的等级
  return math.min(nMaxPer, math.floor(10000 * value / (nP2 * me.nLevel + nP3)) / 100)
end

local function Frame2Sec2(value)
  if type(value) == "table" then
    if value.nType == 1 then
      local nValue = math.floor(value.nPoint / Env.GAME_FPS * 10) / 10
      if nValue >= 0 then
        return "增加" .. nValue .. "秒"
      else
        return "减少" .. -nValue .. "秒"
      end
    elseif value.nType == 2 then
      if value.nPoint >= 0 then
        return "增加" .. value.nPoint .. "%"
      else
        return "减少" .. -value.nPoint .. "%"
      end
    elseif value.nType == 3 then
      return "变为" .. value.nPoint .. "秒"
    end
  else
    local nNo = math.floor(value / Env.GAME_FPS * 10) / 10
    if nNo >= 0 then
      return "增加" .. nNo .. "秒"
    else
      return "减少" .. -nNo .. "秒"
    end
  end
  return "未知"
end

local function GetSkillName(value)
  if type(value) == "table" then
    value = value.nPoint
  end
  local szName = KFightSkill.GetSkillName(value)
  local tbTrueName = Lib:SplitStr(szName, "&")
  return tbTrueName[1]
end

local function EnchantType(value)
  --print("nType = ", value)
  local tbS1 = { "增加", "放大", "变为" }
  local tbS2 = { "减少", "减小", "变为" }
  local tbE = { "", "%", "" }

  local szEnh = ""
  if value.nPoint >= 0 then
    szEnh = tbS1[value.nType] .. math.abs(value.nPoint) .. tbE[value.nType]
  else
    szEnh = tbS2[value.nType] .. math.abs(value.nPoint) .. tbE[value.nType]
  end
  return szEnh
end

local function EnchantTypeV(value)
  --print("nType = ", value)
  local tbS1 = { "增加", "放大", "变为" }
  local tbS2 = { "减少", "减小", "变为" }
  local tbE = { "", "%", "" }

  local szEnh = ""
  if value.nPoint >= 0 then
    szEnh = tbS1[value.nType] .. math.abs(value.nPoint) .. tbE[value.nType]
  else
    szEnh = tbS2[value.nType] .. math.abs(value.nPoint) .. tbE[value.nType]
  end
  return szEnh
end
local function EnchantTypeP(value)
  --print("nType = ", value)
  local tbS1 = { "增加", "放大", "变为" }
  local tbS2 = { "减少", "减小", "变为" }
  local tbE = { "%", "%", "%" }

  local szEnh = ""
  if value.nPoint >= 0 then
    szEnh = tbS1[value.nType] .. math.abs(value.nPoint) .. tbE[value.nType]
  else
    szEnh = tbS2[value.nType] .. math.abs(value.nPoint) .. tbE[value.nType]
  end
  return szEnh
end

local function GetSkillNameByParam(value1)
  local tbRandomSkill = Lib:LoadTabFile("setting\\fightskill\\randomskill.txt")
  local szMsg = ""
  for i = 1, #tbRandomSkill do
    --print(i , tbRandomSkill[i].nFactionId , #tbRandomSkill)
    if tonumber(tbRandomSkill[i].nFactionId) == me.nFaction then
      if tonumber(tbRandomSkill[i].nRouteId) == me.nRouteId then
        if tonumber(tbRandomSkill[i].nIndex) == value1 then
          szMsg = KFightSkill.GetSkillName(tonumber(tbRandomSkill[i].nSkillId))
          break
        end
      end
    elseif tonumber(tbRandomSkill[i].nFactionId) == 0 and tonumber(tbRandomSkill[i].nRouteId) == 0 and tonumber(tbRandomSkill[i].nIndex) == value1 then
      szMsg = KFightSkill.GetSkillName(tonumber(tbRandomSkill[i].nSkillId))
      break
    end
  end
  szMsg = "" and szMsg or "未知技能"
  return szMsg
end

local tbParamToLevel = {
  "10级",
  "30级",
  "40级",
  "50级",
  "60级",
  "70级",
  "90级",
  "100级",
  "110级",
  "120级",
  "初级秘籍",
  "中级秘籍",
  "高级秘籍",
}

local function CastSkill(nSkillId, nLevel)
  local str = "包含"
  local tbSkillInfo = KFightSkill.GetSkillInfo(nSkillId, nLevel)
  local nActualLevel = me.GetSkillLevel(nSkillId)
  local nSkillLevel = nLevel
  if nSkillLevel > nActualLevel then
    nSkillLevel = nActualLevel
  end

  if nSkillLevel < 0 then
    nSkillLevel = 0
  end
  --填成63就不显示最高多少级了...
  if nLevel >= 63 then
    str = str .. "<color=green>[" .. tbSkillInfo.szName .. "]<color>：<color=gold>" .. nSkillLevel .. "级<color>"
  else
    str = str .. "<color=green>[" .. tbSkillInfo.szName .. "]<color>：<color=gold>" .. nSkillLevel .. "级<color>，" .. "最高<color=gold>" .. nLevel .. "级<color>"
  end
  return str
end

local function GetIgnoreAttackDesc(tbSkillInfo)
  if tbSkillInfo.nLevel > 6 then
    return
  end

  local szMsg = "以一定概率化解来自<color=gold>%s级及以下官衔<color>玩家的攻击"
  local szLevel = tostring(tbSkillInfo.nLevel + 1)
  szMsg = string.format(szMsg, szLevel)

  return szMsg
end

local function EnchantDesc(tbMagic)
  if not tbMagic then
    return ""
  end

  local szClassName = SkillEnchant:GetNameById(tbMagic[1])
  local tbData = SkillEnchant:GetClass(szClassName)
  if not tbData then
    return ""
  end

  local tbDesc = {}
  local szDesc = ""
  for _, tb in pairs(tbData.tbEnchantData) do
    for szName, tbMgc in pairs(tb.magic) do
      if type(tbMgc) == "table" then
        local tbData = {}
        tbData[1] = tb.RelatedSkillId
        if tbMgc.value1 then
          local tbPoint1 = {}
          for _, tbP in pairs(tbMgc.value1[2]) do
            tbPoint1[#tbPoint1 + 1] = { tbP[1], tbP[2] }
          end
          tbData[2] = {}
          tbData[2].nType = tbMgc.value1[1]
          tbData[2].nPoint = Lib.Calc:Link(tbMagic[2], tbPoint1)
        end

        if tbMgc.value2 then
          local tbPoint2 = {}
          for _, tbP in pairs(tbMgc.value2[2]) do
            tbPoint2[#tbPoint2 + 1] = { tbP[1], tbP[2] }
          end
          tbData[3] = {}
          tbData[3].nType = tbMgc.value2[1]
          tbData[3].nPoint = Lib.Calc:Link(tbMagic[2], tbPoint2)
        end

        if tbMgc.value3 then
          local tbPoint3 = {}
          for _, tbP in pairs(tbMgc.value3[2]) do
            tbPoint3[#tbPoint3 + 1] = { tbP[1], tbP[2] }
          end
          tbData[4] = {}
          tbData[4].nType = tbMgc.value3[1]
          tbData[4].nPoint = Lib.Calc:Link(tbMagic[2], tbPoint3)
        end

        local szMsg, nGroupId, nNum = FightSkill:GetMagicDesc(szName, tbData, nil, nil, true)
        if szMsg and szMsg ~= "" then
          tbDesc[#tbDesc + 1] = { tb.RelatedSkillId, nGroupId, nNum, szMsg }
          --if (szDesc ~= "") then
          --	szDesc = szDesc .. "\n";
          --end;
          --szDesc = szDesc .. szMsg;
        end
      end
    end
  end
  local function _sort(a, b)
    if a[1] ~= b[1] then
      return a[1] < b[1]
    end
    if a[2] ~= b[2] then
      return a[2] < b[2]
    end
    return a[3] < b[3]
  end
  table.sort(tbDesc, _sort)
  for i = 1, #tbDesc do
    szDesc = szDesc .. tbDesc[i][4] .. (i ~= #tbDesc and "\n" or "")
  end
  return szDesc
end

local tbSkillParam1_Desc = {
  "<color=orange>%s<color>的冲刺速度：<color=gold>%s<color>",
  "<color=orange>%s<color>的瞬移距离：<color=gold>%s%%<color>",
}

local function SkillParam1(tbMagic1)
  if tbMagic1 and type(tbMagic1[1]) == "table" then
    tbMagic1[1] = tbMagic1[1].nPoint
  end
  if tbMagic1 and type(tbMagic1[2]) == "table" then
    tbMagic1[2] = tbMagic1[2].nPoint
  end
  local nNo = 0
  if tbMagic1 and tbMagic1[1] == 41 then --天王
    nNo = 1
  elseif tbMagic1[1] == 64 then
    nNo = 2
  end
  if nNo ~= 0 then
    local szSkillName = GetSkillName(tbMagic1[1])
    return string.format(tbSkillParam1_Desc[nNo], szSkillName, Add1(tbMagic1[2]))
  end
  return ""
end

local function MissileRange(tbMagic1)
  --[[local nNo = 0;
	for i = 2, 4 do
		if tbMagic1[i] and type(tbMagic1[i]) == "table" then
			tbMagic1[i] = tbMagic1[i].nPoint;
		end
	end
	
	
	if (tbMagic1[2]) then
		nNo = 2;
	end;
	if (tbMagic1[4]) then
		nNo = 4;
	end;
	if (nNo ~= 0) then
		return string.format(
					"<color=orange>%s<color>的效果范围：<color=gold>%s格<color>",
					GetSkillName(tbMagic1[1]),
					Add1(tbMagic1[nNo])
				);
	end;]]
  tbMagic1 = ChangeMagicTableToValue(tbMagic1)
  assert(tbMagic1[4])
  local nNo = tbMagic1[2] and 2 or 4
  local szMsg = ""
  szMsg = string.format("<color=orange>%s<color>的%s范围：<color=gold>%s格<color>", GetSkillName(tbMagic1[1]), ((nNo == 4) and "伤害" or "效果"), Add1(tbMagic1[nNo]))
  return szMsg --..(tbMagic1[3] or 0);
end

local function AddedwithEnemyCount(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
  if type(tbMagic1[2]) == "table" then
    tbMagic1[2] = tbMagic1[2].nPoint
  end
  local szMsg = "周围每多一个敌方玩家增加一份如下属性，"
  szMsg = szMsg .. "最多叠加<color=gold>" .. tbMagic1[2] .. "份<color>" .. "效果\n"
  local tbInfo = nil
  if tbMagic1[2] > 0 then
    tbInfo = KFightSkill.GetSkillInfo(tbMagic1[1], tbSkillInfo.nLevel)
  else
    tbMagic1[2] = 0
  end
  if not tbInfo then
    return
  end

  local szClassName = tbInfo.szClassName
  local tbSkill = assert(FightSkill.tbClass[szClassName], "Skill{" .. szClassName .. "} not found!")
  local tbMsg = {}
  tbSkill:GetDescAboutLevel(tbMsg, tbInfo)
  szMsg = szMsg .. table.concat(tbMsg, "\n") .. "\n"
  szMsg = string.gsub(szMsg, "持续时间：<color=gold>%d*.*%d*秒<color>\n", "")
  szMsg = string.gsub(szMsg, "<color=white>持续时间：<color><color=gold>%d*秒<color>\n", "") --以后的技能tips中的持续时间格式
  return szMsg
end

FightSkill.ENCHANT_DESCS = {
  --技能设置1
  [1] = {
    { "missile_ablility", { "<color=orange>%s<color>有<color=gold>%s%%<color>的几率穿透目标", { "getskillname", 1 }, 2 } },
    {
      "skill_param1_v",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        return SkillParam1(tbMagic1)
      end,
    },
    {
      "missile_range",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        return MissileRange(tbMagic1)
      end,
    },
    --{"<color=orange>%s<color>的冲刺速度：<color=gold>%s<color>", {"getskillname", 1}, {"add1", 2}}},
    {
      "skill_maxmissile",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        tbMagic1 = ChangeMagicTableToValue(tbMagic1)
        if tbMagic1[2] == 0 then
          return ""
        end
        return string.format("<color=orange>%s<color>的最多布置数：<color=gold>增加%s<color>", GetSkillName(tbMagic1[1]), tbMagic1[2])
      end,
    },
    { "missile_speed_v", { "<color=orange>%s<color>的飞行速度：<color=gold>%s<color>", { "getskillname", 1 }, { "add1", 2 } } },
    { "skill_missilenum_v", { "<color=orange>%s<color>的数量：<color=gold>%s<color>", { "getskillname", 1 }, { "add1", 2 } } },
    { "skill_mintimepercast_v", { "<color=orange>%s<color>的施展间隔：<color=gold>%s<color>", { "getskillname", 1 }, { "frame2sec2", 2 } } },
    { "skill_mintimepercastonhorse_v", { "<color=orange>%s<color>的骑马施展间隔：<color=gold>%s<color>", { "getskillname", 1 }, { "frame2sec2", 2 } } },

    {
      "missile_lifetime_v",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        tbMagic1 = ChangeMagicTableToValue(tbMagic1)
        if tbMagic1[2] == 0 then
          return ""
        end
        return string.format("<color=orange>%s<color>的持续时间：<color=gold>增加%s秒<color>", GetSkillName(tbMagic1[1]), Frame2Sec(tbMagic1[2]))
      end,
    },
    { "skill_attackradius", { "<color=orange>%s<color>的施放距离：<color=gold>%s<color>", { "getskillname", 1 }, { "add1", 2 } } },
    { "keephide", { "<color=orange>%s<color>使用时不会打破隐身", { "getskillname", 1 } } },
    { "skill_cost_v", { "<color=orange>%s<color>的技能消耗：<color=gold>%s<color>", { "getskillname", 1 }, { "enchanttypev", 2 } } },
    { "missile_hitcount", { "<color=orange>%s<color>的每个招式作用人数：<color=gold>%s<color>", { "getskillname", 1 }, { "enchanttypev", 2 } } },
    {
      "skill_cost_buff1layers_v",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        tbMagic1 = ChangeMagicTableToValue(tbMagic1)
        local szMsg = (tbMagic1[4] == 0) and "需要消耗" or "会扣除"
        szMsg = string.format("<color=orange>%s<color>释放时%s<color=gold>%s层<color><color=green>[%s]<color>", GetSkillName(tbMagic1[1]), szMsg, tbMagic1[3], GetSkillName(tbMagic1[2]))
        return szMsg
      end,
    },
  },
  --立即生效
  [2] = {
    { "appenddamage_p", { "<color=orange>%s<color>的发挥基础攻击力：<color=gold>%s<color>", { "getskillname", 1 }, { "enchanttypep", 2 } } },
    {
      "state_drag_attack",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        tbMagic1 = ChangeMagicTableToValue(tbMagic1)
        return string.format("<color=orange>%s<color>的拉回几率：<color=gold>%s%%<color>，最大距离<color=gold>%d<color>", GetSkillName(tbMagic1[1]), tbMagic1[2], tbMagic1[3] * tbMagic1[4])
      end,
    },
    {
      "state_knock_attack",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        tbMagic1 = ChangeMagicTableToValue(tbMagic1)
        return string.format("<color=orange>%s<color>的击退几率：<color=gold>%s%%<color>，击退距离<color=gold>%d<color>", GetSkillName(tbMagic1[1]), tbMagic1[2], tbMagic1[3] * tbMagic1[4])
      end,
    },
    { "state_slowall_attack", { "<color=orange>%s<color>的迟缓几率：<color=gold>%s%%<color>", { "getskillname", 1 }, { "add1", 2 } } },
    {
      "state_palsy_attack",
      {
        "<color=orange>%s<color>的麻痹几率：<color=gold>%s%%<color>，持续<color=gold>%s秒<color>",
        { "getskillname", 1 },
        { "add1", 2 },
        { "frame2sec", 3 },
      },
    },
    {
      "state_fixed_attack",
      {
        "<color=orange>%s<color>的定身几率：<color=gold>%s%%<color>，持续<color=gold>%s秒<color>",
        { "getskillname", 1 },
        { "add1", 2 },
        {
          "frame2sec",
          3,
        },
      },
    },
    {
      "state_zhican_attack",
      {
        "<color=orange>%s<color>的致残几率：<color=gold>%s%%<color>，持续<color=gold>%s秒<color>",
        { "getskillname", 1 },
        { "add1", 2 },
        {
          "frame2sec",
          3,
        },
      },
    },
  },
  --状态属性
  [3] = {
    {
      "allspecialstateresistrate",
      { "<color=orange>%s<color>追加受到负面状态的几率：<color=gold>%s<color>", { "getskillname", 1 }, { "add2", 2 } },
    },
    {
      "allspecialstateresisttime",
      { "<color=orange>%s<color>追加受到负面状态的时间：<color=gold>%s<color>", { "getskillname", 1 }, { "add2", 2 } },
    },
    { "damage_inc_p", { "<color=orange>%s<color>附加造成的伤害：<color=gold>%s%%<color>", { "getskillname", 1 }, { "add5", 2 } } },
    { "skilldamageptrim", { "<color=orange>%s<color>附加发挥基础攻击力：<color=gold>%s%%<color>", { "getskillname", 1 }, { "add1", 2 } } },
    { "fastwalkrun_p", { "<color=orange>%s<color>使敌人移动速度：<color=gold>%s%%<color>", { "getskillname", 1 }, { "add1", 2 } } },
    { "lifereplenish_p", { "<color=orange>%s<color>使敌人生命回复效率：<color=gold>%s%%<color>", { "getskillname", 1 }, { "add1", 2 } } },
    { "lifereplenish_p", { "<color=orange>%s<color>使目标生命回复效率：<color=gold>%s%%<color>", { "getskillname", 1 }, { "add1", 2 } } },
    { "redeivedamage_dec_p2", { "<color=orange>%s<color>使目标所受五行伤害：<color=gold>%s%%<color>", { "getskillname", 1 }, { "add6", 2 } } },
    { "allseriesstateresisttime", { "<color=orange>%s<color>的受到五行状态的时间：<color=gold>%s<color>", { "getskillname", 1 }, { "add1", 2 } } },
    { "state_hurt_resisttime", { "<color=orange>%s<color>的受到受伤的时间：<color=gold>%s<color>", { "getskillname", 1 }, { "add1", 2 } } },
    { "state_weak_resisttime", { "<color=orange>%s<color>的受到虚弱的时间：<color=gold>%s<color>", { "getskillname", 1 }, { "add1", 2 } } },
    { "state_burn_resisttime", { "<color=orange>%s<color>的受到灼伤的时间：<color=gold>%s<color>", { "getskillname", 1 }, { "add1", 2 } } },
    { "state_stun_resisttime", { "<color=orange>%s<color>的受到眩晕的时间：<color=gold>%s<color>", { "getskillname", 1 }, { "add1", 2 } } },
    { "state_slowall_resisttime", { "<color=orange>%s<color>的受到迟缓的时间：<color=gold>%s<color>", { "getskillname", 1 }, { "add1", 2 } } },
    { "damage_all_resist", { "<color=orange>%s<color>的所有抗性：<color=gold>%s<color>", { "getskillname", 1 }, { "add1", 2 } } },
    { "fastmanareplenish_v", { "<color=orange>%s<color>的每半秒内力回复：<color=gold>%s<color>", { "getskillname", 1 }, { "enchanttypev", 2 } } },
    { "fastlifereplenish_v", { "<color=orange>%s<color>的每半秒生命回复：<color=gold>%s<color>", { "getskillname", 1 }, { "enchanttypev", 2 } } },
    { "replenishlifebymaxhp_p", { "<color=orange>%s<color>的每半秒生命回复：<color=gold>%s<color>", { "getskillname", 1 }, { "enchanttypev", 2 } } },
    { "lifemax_p", { "<color=orange>%s<color>的生命上限：<color=gold>%s%%<color>", { "getskillname", 1 }, { "add1", 2 } } },
    { "manamax_p", { "<color=orange>%s<color>的内力上限：<color=gold>%s%%<color>", { "getskillname", 1 }, { "add1", 2 } } },
    { "ignoreskill", { "<color=orange>%s<color>的完全闪避几率：<color=gold>%s%%<color>", { "getskillname", 1 }, { "add1", 2 } } },
    --有问题,暂时用不到,先放着
    {
      "autoskill",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        tbMagic1 = ChangeMagicTableToValue(tbMagic1)
        local tbAutoInfo = KFightSkill.GetAutoInfo(tbMagic1[2], tbMagic1[3])
        tbSkillInfo = KFightSkill.GetSkillInfo(tbAutoInfo.nSkillId, tbAutoInfo.nSkillLevel)
        local szClassName = (tbSkillInfo and tbSkillInfo.szClassName) or "default"
        local szMsg = FightSkill.tbClass[szClassName]:GetAutoDesc(tbAutoInfo, tbSkillInfo)
        return string.format("%s追加自动触发效果：\n%s", GetSkillName(tbMagic1[1]), szMsg)
      end,
    },
    {
      "autoskill2",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        tbMagic1 = ChangeMagicTableToValue(tbMagic1)
        local tbAutoInfo = KFightSkill.GetAutoInfo(tbMagic1[2], tbMagic1[3])
        tbSkillInfo = KFightSkill.GetSkillInfo(tbAutoInfo.nSkillId, tbAutoInfo.nSkillLevel)
        local szClassName = (tbSkillInfo and tbSkillInfo.szClassName) or "default"
        local szMsg = FightSkill.tbClass[szClassName]:GetAutoDesc2(tbAutoInfo, tbSkillInfo)
        return string.format("%s追加自动触发效果：\n%s", GetSkillName(tbMagic1[1]), szMsg)
      end,
    },
  },
  --技能设置2
  [4] = {
    { "superposemagic", { "<color=orange>%s<color>的可叠加次数：<color=gold>%s次<color>", { "getskillname", 1 }, { "add1", 2 } } },
    { "skill_statetime", { "<color=orange>%s<color>持续时间：<color=gold>增加%s秒<color>", { "getskillname", 1 }, { "frame2sec", 2 } } },
  },
}
FightSkill.MAGIC_DESCS = { --数字索引必须连续...
  --技能设置
  [1] = {
    --{"missile_range", {"技能碰撞范围<color=orange>%s/%s/%s<color>", 1, 2,3}},
    --{"missile_range", {"技能碰撞范围：<color=gold>%s格<color>\n技能范围：<color=gold>%s格<color>\n"}},
    {
      "skill_cost_buff1layers_v",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local szMsg = (tbMagic1[3] == 0) and "消耗" or "扣除"
        szMsg = string.format("<color=blue>状态需求：<color><color=gold>%s%s层<color><color=green>[%s]<color>", szMsg, tbMagic1[2], GetSkillName(tbMagic1[1]))
        return szMsg
      end,
    },
    {
      "skill_cost_buff2layers_v",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local szMsg = (tbMagic1[3] == 0) and "需要消耗" or "会扣除"
        szMsg = string.format("<color=blue>状态需求：<color><color=gold>%s%s层<color><color=green>[%s]<color>", szMsg, tbMagic1[2], GetSkillName(tbMagic1[1]))
        return szMsg
      end,
    },
    {
      "skill_cost_buff3layers_v",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local szMsg = (tbMagic1[3] == 0) and "需要消耗" or "会扣除"
        szMsg = string.format("<color=blue>状态需求：<color><color=gold>%s%s层<color><color=green>[%s]<color>", szMsg, tbMagic1[2], GetSkillName(tbMagic1[1]))
        return szMsg
      end,
    },
    --保持隐身
    {
      "keephide",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        if tbMagic1[1] == 1 then
          return string.format("使用此技能不会打破隐身")
        end
      end,
    },
    --攻击力基础&五行相克属性
    {
      "seriesdamage_r",
      function(tbMagic, tbSkillInfo, tbMagic2, bEx2)
        local szMsg = ""
        local szSeries = ""
        --[[if (tbMagic[1] == 0) then
					return "";
				end
				szMsg = string.format("五行相克：<color=gold>%s<color>", tbMagic[1]);
				if(tbSkillInfo.nSeries ~= 0) then
					-- or 后面的部分用于出错保护
					szSeries	= string.format("<color=gold>(<color><color=%s>%s<color><color=gold>)<color>", 
							tbSeriesColor[tbSkillInfo.nSeries] or "",
							Env.SERIES_NAME[tbSkillInfo.nSeries] or tostring(tbSkillInfo.nSeries));
				end]]
        if tbSkillInfo.nSeries ~= 0 then
          szMsg = string.format("技能五行：")
          -- or 后面的部分用于出错保护
          szSeries = string.format("<color=%s>%s<color>", tbSeriesColor[tbSkillInfo.nSeries] or "", Env.SERIES_NAME[tbSkillInfo.nSeries] or tostring(tbSkillInfo.nSeries))
          szMsg = szMsg .. szSeries
        end
        return szMsg
      end,
    },
    { "seriesenhance_r", { "攻击被克方时攻击技能的相克值：<color=gold>%s<color>", { "add1", 1 } } },
  },
  --立即生效属性
  [2] = {
    --命中类属性
    { "attackrating_v", { "攻击命中值点数：<color=gold>%s点<color>", { "add1", 1 } } },
    { "attackrating_p", { "攻击命中值比例：<color=gold>%s%%<color>", { "add1", 1 } } },
    --忽略闪避类属性
    { "ignoredefense_p", { "忽略对手闪避值：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "ignoredefense_v", { "忽略对手闪避值：<color=gold>%s<color>", { "add1", 1 } } },
    --召唤稻草人转伤害
    {
      "magic_calldummy",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        return string.format("玩家受伤害比例：<color=gold>%s%%<color><enter>怪物受伤害比例：<color=gold>%s%%<color>", tbMagic1[2] / 10 * 4, tbMagic1[2] / 10)
      end,
    },
    --吸血吸内,作为状态属性居然也可生效...
    {
      "steallife_p",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local szMsg = (tbMagic1[2] < 100) and (Add4(tbMagic1[2], tbMagic2 and tbMagic2[2], bEx2) .. "%将") or ""
        szMsg = szMsg .. "造成的伤害的<color=gold>"
        szMsg = szMsg .. ((tbMagic1[1] >= 0) and Add4(tbMagic1[1], tbMagic2 and tbMagic2[1], bEx2) or Add4(-tbMagic1[1], tbMagic2 and -tbMagic2[1], bEx2))
        szMsg = szMsg .. "%<color>转化为生命" .. ((tbMagic1[1] >= 0) and "回复" or "损失")
        return szMsg
      end,
    },
    {
      "stealmana_p",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local szMsg = (tbMagic1[2] < 100) and (Add4(tbMagic1[2], tbMagic2 and tbMagic2[2], bEx2) .. "%将") or ""
        szMsg = szMsg .. "造成的伤害的<color=gold>"
        szMsg = szMsg .. ((tbMagic1[1] >= 0) and Add4(tbMagic1[1], tbMagic2 and tbMagic2[1], bEx2) or Add4(-tbMagic1[1], tbMagic2 and -tbMagic2[1], bEx2))
        szMsg = szMsg .. "%<color>转化为内力" .. ((tbMagic1[1] >= 0) and "回复" or "损失")
        return szMsg
      end,
    },
    {
      "stealstamina_p",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local szMsg = (tbMagic1[2] < 100) and (Add4(tbMagic1[2], tbMagic2 and tbMagic2[2], bEx2) .. "%将") or ""
        szMsg = szMsg .. "造成的伤害的<color=gold>"
        szMsg = szMsg .. ((tbMagic1[1] >= 0) and Add4(tbMagic1[1], tbMagic2 and tbMagic2[1], bEx2) or Add4(-tbMagic1[1], tbMagic2 and -tbMagic2[1], bEx2))
        szMsg = szMsg .. "%<color>转化为体力" .. ((tbMagic1[1] >= 0) and "回复" or "损失")
        return szMsg
      end,
    },

    --五行伤害百分比类属性
    {
      "physicsenhance_p",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        if tbMagic1[1] == 0 then
          return ""
        end
        return string.format("普攻攻击：<color=gold>%s%%<color>", Add1(tbMagic1[1], tbMagic2 and tbMagic2[1], bEx2))
      end,
    },
    --五行伤害点数类属性,除普攻外不区分内外功
    { "physicsdamage_v", { "普攻攻击：<color=gold>增加%s到%s点<color>", 1, 3 } }, --内功系用
    { "physicsenhance_v", { "普攻攻击：<color=gold>增加%s到%s点<color>", 1, 3 } },
    --{ "poisondamage_v", { "毒攻攻击：<color=gold>增加%s点/半秒<color>，持续<color=gold>%s秒<color>", 1 ,{ "frame2sec", 2}} },
    { "poisondamage_v", { "毒攻攻击：<color=gold>%s点<color>，毒发<color=gold>%s次<color>", { "add1", 1 }, { "frame2times", 2 } } },
    { "colddamage_v", { "冰攻攻击：<color=gold>增加%s到%s点<color>", 1, 3 } },
    { "firedamage_v", { "火攻攻击：<color=gold>增加%s到%s点<color>", 1, 3 } },
    { "lightingdamage_v", { "雷攻攻击：<color=gold>增加%s到%s点<color>", 1, 3 } },
    { "magicdamage_v", { "五行攻击：<color=gold>增加%s到%s点<color>", 1, 3 } },
    --发挥基础攻击力
    {
      "appenddamage_p",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local szMsg = ""
        local nAppend = tbSkillInfo.nAppenDamageP or tbMagic1[1]
        if tbSkillInfo.IsOpenFloatDamage == 1 then
          szMsg = ""
        elseif nAppend == 0 then
          szMsg = "<color=gray>不受基础攻击影响<color>"
        else
          --local nAddApp = math.floor(nAppend * me.nWeaponBaseDamageTrim/100*10)/10
          szMsg = string.format("发挥基础攻击力：<color=gold>%s%%<color>", nAppend)
          if tbSkillInfo.bIsPhysical == 1 then
            szMsg = szMsg .. "外功攻击"
          elseif tbSkillInfo.bIsPhysical == 0 then
            szMsg = szMsg .. "内功攻击"
          end
        end
        return szMsg
      end,
    },
    {
      "floatdamage_p",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local szMsg = ""
        local nAppendMin, nAppendMax = tbSkillInfo.nFloatDamageMinP, tbSkillInfo.nFloatDamageMaxP
        if tbSkillInfo.IsOpenFloatDamage == 0 then
          szMsg = ""
        elseif (nAppendMin == 0) and (nAppendMax == 0) then
          szMsg = "<color=gray>不受基础攻击影响<color>"
        else
          --local nAddApp = math.floor(nAppend * me.nWeaponBaseDamageTrim/100*10)/10
          if nAppendMin ~= nAppendMax then
            szMsg = string.format("发挥基础攻击力：<color=gold>%s%%到%s%%<color>", nAppendMin / 10, nAppendMax / 10)
          else
            szMsg = string.format("发挥基础攻击力：<color=gold>%s%%<color>", nAppendMin / 10)
          end
          if tbSkillInfo.bIsPhysical == 1 then
            szMsg = szMsg .. "外功攻击"
          elseif tbSkillInfo.bIsPhysical == 0 then
            szMsg = szMsg .. "内功攻击"
          end
        end
        return szMsg
      end,
    },
    --冲刺后加攻击力
    { "runattack_damageadded", { "每冲刺一个目标后攻击：<color=gold>%s%%<color>", { "add1", 1 } } },
    --百分比掉血
    {
      "reducepercentonmaxhp_p",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local szMsg = ""
        if tbMagic1[1] > 0 then
          szMsg = szMsg .. "扣除血量上限的" .. tbMagic1[1] .. "%"
          szMsg = szMsg .. (tbMagic1[2] + tbMagic1[3] > 0 and "\n" or "")
        end
        if tbMagic1[2] > 0 then
          szMsg = szMsg .. "扣除内力上限的" .. tbMagic1[2] .. "%"
          szMsg = szMsg .. (tbMagic1[3] > 0 and "\n" or "")
        end
        if tbMagic1[3] > 0 then
          szMsg = szMsg .. "扣除体力上限的" .. tbMagic1[3] .. "%"
        end
        return string.format("<color=red>%s<color>", szMsg)
      end,
    },
    {
      "reducepercentoncurhp_p",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local szMsg = ""
        if tbMagic1[1] > 0 then
          szMsg = szMsg .. "扣除当前血量值的" .. tbMagic1[1] .. "%"
          szMsg = szMsg .. (tbMagic1[2] + tbMagic1[3] > 0 and "\n" or "")
        end
        if tbMagic1[2] > 0 then
          szMsg = szMsg .. "扣除当前内力值的" .. tbMagic1[2] .. "%"
          szMsg = szMsg .. (tbMagic1[3] > 0 and "\n" or "")
        end
        if tbMagic1[3] > 0 then
          szMsg = szMsg .. "扣除当前体力值的" .. tbMagic1[3] .. "%"
        end
        return string.format("<color=red>%s<color>", szMsg)
      end,
    },
    { "wastemanap", { "抽掉目标当前内力值：<color=gold>%s%%<color>", 1 } },

    --造成五行状态
    { "state_hurt_attack", { "造成受伤的几率：<color=gold>%s%%<color>，持续<color=gold>%s秒<color>", 1, { "frame2sec", 2 } } },
    { "state_weak_attack", { "造成虚弱的几率：<color=gold>%s%%<color>，持续<color=gold>%s秒<color>", 1, { "frame2sec", 2 } } },
    --{ "state_slowall_attack", { "造成迟缓的几率：<color=gold>%s%%<color>，持续<color=gold>%s秒<color>", 1,{ "frame2sec", 2} } },
    {
      "state_slowall_attack",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local nRate = tbMagic1[1]
        local szInfo = string.format("造成迟缓的几率：<color=gold>%s%%<color>，持续<color=gold>%s秒<color>", nRate, Frame2Sec(tbMagic1[2]))

        return szInfo
      end,
    },
    { "state_burn_attack", { "造成灼伤的几率：<color=gold>%s%%<color>，持续<color=gold>%s秒<color>", 1, { "frame2sec", 2 } } },
    { "state_stun_attack", { "造成眩晕的几率：<color=gold>%s%%<color>，持续<color=gold>%s秒<color>", 1, { "frame2sec", 2 } } },
    --造成负面状态
    { "state_fixed_attack", { "造成定身的几率：<color=gold>%s%%<color>，持续<color=gold>%s秒<color>", 1, { "frame2sec", 2 } } },
    { "state_palsy_attack", { "造成麻痹的几率：<color=gold>%s%%<color>，持续<color=gold>%s秒<color>", 1, { "frame2sec", 2 } } },
    { "state_slowrun_attack", { "造成跑速降低的几率：<color=gold>%s%%<color>，持续<color=gold>%s秒<color>", 1, { "frame2sec", 2 } } },
    { "state_freeze_attack", { "造成冻结的几率：<color=gold>%s%%<color>，持续<color=gold>%s秒<color>", 1, { "frame2sec", 2 } } },
    { "state_confuse_attack", { "造成混乱的几率：<color=gold>%s%%<color>，持续<color=gold>%s秒<color>", 1, { "frame2sec", 2 } } },
    --击退属性,参数2是击退时间,参数3是击退速度,参数3上限为32
    {
      "state_knock_attack",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        return string.format("造成击退的几率：<color=gold>%s%%<color>，击退距离<color=gold>%s<color>", tbMagic1[1], tbMagic1[2] * tbMagic1[3])
      end,
    },
    --拉回属性,参数2是时间,参数3是速度
    --如果是一般的拉回(拉回到角色位置),速度=距离/时间,最大32,如果技能距离较远,有可能时间*32<距离,导致拉回停止
    --如果是missile_drage,速度就是实际移动速度,最大32
    {
      "state_drag_attack",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        return string.format("造成拉回的几率：<color=gold>%s%%<color>，最大距离<color=gold>%s<color>", tbMagic1[1], tbMagic1[2] * tbMagic1[3])
      end,
    },
    { "state_silence_attack", { "造成沉默的几率：<color=gold>%s%%<color>，持续<color=gold>%s秒<color>", 1, { "frame2sec", 2 } } },
    { "state_zhican_attack", { "造成致残的几率：<color=gold>%s%%<color>，持续<color=gold>%s秒<color>", 1, { "frame2sec", 2 } } },
    { "state_float_attack", { "造成浮空的几率：<color=gold>%s%%<color>，持续<color=gold>%s秒<color>", 1, { "frame2sec", 2 } } },
    --根据距离加成攻击效果
    {
      "addmagicbydist",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local tbState = {
          [0] = "受伤",
          [1] = "虚弱",
          [2] = "迟缓",
          [3] = "灼伤",
          [4] = "眩晕",
          [5] = "定身",
          [6] = "麻痹",
          [7] = "减跑速",
          [8] = "冻结",
          [9] = "混乱",
          [10] = "击退",
          [11] = "拉扯",
          [12] = "沉默",
          [13] = "致残",
          [14] = "浮空",
        }
        return string.format("<color=gold>%s<color>时间延长：<color=gold>(双方距离/%s)%%<color>，最大不超过<color=gold>%s%%<color>", tbState[tbMagic1[1]], tbMagic1[2] / 100, math.floor(tbMagic1[3] / tbMagic1[2] * 100))
      end,
    },
    --内力护盾
    { "removeshield", { "移除内力护盾" } },
    { "clearhide", { "解除隐身" } },
    {
      "staticmagicshieldcur_p",
      {
        "消耗85%%的当前内力转化为相当于消耗内力值<color=gold>%s%%<color>的护盾以抵御受到的伤害，持续时间：<color=gold>%s秒<color>",
        1,
        { "frame2sec", 2 },
      },
    },
    {
      "staticmagicshieldmax_p",
      { "生成<color=gold>内力上限*%s%%<color>的护盾抵御伤害，持续时间：<color=gold>%s秒<color>", 1, { "frame2sec", 2 } },
    },

    --立刻影响其他技能
    --改变已有的buff叠加层数,到0层会删除
    { "change_bufflayers_v", { "<color=gold>%s层<color><color=green>[%s]<color>", { "add1", 2 }, { "getskillname", 1 } } },
    {
      "change_bufflayers_p",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local szMsg = ""
        if tbMagic1[2] == 0 then
          return ""
        end
        szMsg = (tbMagic1[2] > 0) and "增加" or "减少"
        szMsg = "<color=gold>" .. szMsg .. "<color=green>[" .. GetSkillName(tbMagic1[1]) .. "]<color>技能当前叠加层数的<color=gold>" .. tbMagic1[2] .. "%<color>"
        return szMsg
      end,
    },
    --回复技能使用次数
    {
      "recover_usepoint",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        return string.format("<color=orange>%s<color>可用次数回复：<color=gold>%s<color>", GetSkillName(tbMagic1[1]), tbMagic1[2] / 100)
      end,
    },
    { "reducenextcasttime_p", { "使<color=gold>%s<color>剩余冷却时间：<color=gold>%s%%<color>", { "getskillname", 1 }, { "add2", 2 } } },
    { "reducenextcasttime_p2", { "使<color=gold>%s<color>剩余冷却时间：<color=gold>%s%%<color>", { "getskillname", 1 }, { "add2", 2 } } },
    { "reducenextcasttime_p3", { "使<color=gold>%s<color>剩余冷却时间：<color=gold>%s%%<color>", { "getskillname", 1 }, { "add2", 2 } } },
    { "reducenextcasttime_v", { "使<color=gold>%s<color>剩余冷却时间：<color=gold>减少%s秒<color>", { "getskillname", 1 }, { "frame2sec", 2 } } },
    { "reducenextcasttime_v2", { "使<color=gold>%s<color>剩余冷却时间：<color=gold>减少%s秒<color>", { "getskillname", 1 }, { "frame2sec", 2 } } },
    { "reducenextcasttime_v3", { "使<color=gold>%s<color>剩余冷却时间：<color=gold>减少%s秒<color>", { "getskillname", 1 }, { "frame2sec", 2 } } },
    --偷技能
    {
      "stealstate",
      {
        "随机偷取非怪物敌人的<color=gold>最高%s级<color>的1个辅助状态\n再次对自身或友方施放则把偷取的状态附加给目标",
        3,
      },
    },
    { "stealskillstate", { "已成功偷取状态，再次使用释放偷取的状态" } },

    --即死
    { "suddendeath", { "承受此状态的目标<color=gold>%s秒<color>后有<color=gold>%s%%<color>的几率立即重伤", { "frame2sec", 2 }, 1 } },
    --立刻回复生命内力,但是不会考虑当前血量上限等因素..
    {
      "immediatereplbymaxstate_p",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local szMsg = ""
        if tbMagic1[1] > 0 then
          szMsg = szMsg .. "回复生命上限值的<color=gold>" .. tbMagic1[1] .. "%<color>"
          szMsg = szMsg .. (tbMagic1[2] + tbMagic1[3] > 0 and "\n" or "")
        end
        if tbMagic1[2] > 0 then
          szMsg = szMsg .. "回复内力上限值的<color=gold>" .. tbMagic1[2] .. "%<color>"
          szMsg = szMsg .. (tbMagic1[3] > 0 and "\n" or "")
        end
        if tbMagic1[3] > 0 then
          szMsg = szMsg .. "回复体力上限值的<color=gold>" .. tbMagic1[3] .. "%<color>"
        end
        return szMsg
      end,
    },
    --立刻回复生命内力,但是不会考虑当前血量上限等因素..
    { "life_v", { "当前生命：<color=gold>%s点<color>", { "add1", 1 } } },
    { "mana_v", { "当前内力：<color=gold>%s点<color>", { "add1", 1 } } },
    { "stamina_v", { "体力回复：<color=gold>%s点<color>", { "add1", 1 } } },
    --复活
    {
      "revive",
      function(tbMagic, tbSkillInfo, tbMagic2, bEx2)
        return string.format("以<color=gold>%s%%<color>的几率复活并回复<color=gold>%s%%<color>的生命，<color=gold>%s%%<color>的内力，<color=gold>%s%%<color>的体力", KFightSkill.GetMissileRate(tbSkillInfo.nId, tbSkillInfo.nLevel), Add4(tbMagic[1], tbMagic2 and tbMagic2[1], bEx2), Add4(tbMagic[2], tbMagic2 and tbMagic2[2], bEx2), Add4(tbMagic[3], tbMagic2 and tbMagic2[3], bEx2))
      end,
    },
  },
  --立即生效后本身再以状态属性作用
  [3] = {
    --清cd..
    { "clear_cd", { "清除所有武功的施展间隔，且施展武功无间隔" } },

    { "ignorecurse", { "以<color=gold>%s%%<color>的几率随机驱散<color=gold>%s个诅咒<color>并免疫诅咒", 1, 3 } },
    {
      "ignoreinitiative",
      function(tbMagic, tbSkillInfo, tbMagic2, bEx2)
        return string.format(
          --"以<color=gold>%s%%的<color>几率随机清除<color=gold>%s个主动辅助技能<color>并使其不能再获得已清除的技能",
          "清除<color=gold>%s个<color>主动辅助状态并使其不能再获得已清除的技能",
          --KFightSkill.GetMissileRate(tbSkillInfo.nId, tbSkillInfo.nLevel),
          Add4(tbMagic[1], tbMagic2 and tbMagic2[1], bEx2)
        )
      end,
    },
    --技能的非基础攻击力部分加成
    { "skill_appendskill", { "%s", { "castskill", 1, 2 } } },
    { "skill_appendskill2", { "%s", { "castskill", 1, 2 } } },
    { "skill_appendskill3", { "%s", { "castskill", 1, 2 } } },
    { "skill_appendskill4", { "%s", { "castskill", 1, 2 } } },
    { "skill_appendskill5", { "%s", { "castskill", 1, 2 } } },
    { "skill_appendskill6", { "%s", { "castskill", 1, 2 } } },
  },
  --状态属性
  [4] = {
    --持续伤害
    --参数1是发挥基础攻击,参数2是调用技能id,参数3是作用次数
    --{ "timingdamage",  { "每半秒持续伤害：<color=gold>%s%%<color>", 1 } },
    {
      "timingdamage",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local szMsg = ""
        szMsg = string.format("每半秒持续伤害：<color=gold>%s%%<color>", tbMagic1[1])
        if tbSkillInfo.bIsPhysical == 1 then
          szMsg = szMsg .. "外功攻击"
        elseif tbSkillInfo.bIsPhysical == 0 then
          szMsg = szMsg .. "内功攻击"
        end
        return szMsg
      end,
    },
    --加潜能
    { "strength_v", { "力量：<color=gold>%s点<color>", { "add1", 1 } } },
    { "dexterity_v", { "身法：<color=gold>%s点<color>", { "add1", 1 } } },
    { "vitality_v", { "外功：<color=gold>%s点<color>", { "add1", 1 } } },
    { "energy_v", { "内功：<color=gold>%s点<color>", { "add1", 1 } } },
    --攻击力基础&五行相克属性
    {
      "seriesenhance",
      function(tbMagic, tbSkillInfo, tbMagic2, bEx2)
        if tbMagic[1] == 0 then
          return ""
        end
        return string.format("五行相克强化：<color=gold>%s<color>点", Add1(tbMagic[1], tbMagic2 and tbMagic2[1], bEx2))
      end,
    },
    {
      "seriesabate",
      function(tbMagic, tbSkillInfo, tbMagic2, bEx2)
        if tbMagic[1] == 0 then
          return ""
        end
        return string.format("五行相克弱化：<color=gold>%s<color>点", Add1(tbMagic[1], tbMagic2 and tbMagic2[1], bEx2))
      end,
    },
    --命中类属性
    { "attackratingenhance_v", { "攻击命中值点数：<color=gold>%s点<color>", { "add1", 1 } } },
    { "attackratingenhance_p", { "攻击命中值比例：<color=gold>%s%%<color>", { "add1", 1 } } },
    --忽略闪避类属性
    { "ignoredefenseenhance_p", { "忽略对手闪避值：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "ignoredefenseenhance_v", { "忽略对手闪避值：<color=gold>%s<color>", { "add1", 1 } } },
    --出招动作属性
    { "attackspeed_v", { "外功系出招速度：<color=gold>%s<color>", { "add1", 1 } } },
    { "castspeed_v", { "内功系出招速度：<color=gold>%s<color>", { "add1", 1 } } },

    --五行伤害百分比类属性
    { "addphysicsdamage_p", { "外功系普攻攻击：<color=gold>%s%%<color>", { "add1", 1 } } },
    {
      "add_physicpoisondamage_p",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local szMsg = string.format("外功系毒攻攻击：<color=gold>%s%%<color>", Add1(tbMagic1[1], tbMagic2 and tbMagic2[1], bEx2))
        if tbMagic1[2] > 0 then
          --szMsg = szMsg.."<color=gold>/半秒<color>，持续<color=gold>"..frame2sec(tbMagic1[2]).."秒<color>";
          szMsg = szMsg .. "，毒发<color=gold>" .. frame2times(tbMagic1[2]) .. "次<color>"
        end
        return szMsg
      end,
    },
    { "add_physiccolddamage_p", { "外功系冰攻攻击：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "add_physicfiredamage_p", { "外功系火攻攻击：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "add_physiclightdamage_p", { "外功系雷攻攻击：<color=gold>%s%%<color>", { "add1", 1 } } },

    { "addphysicsmagic_p", { "内功系普攻攻击：<color=gold>%s%%<color>", { "add1", 1 } } },
    {
      "add_magicpoisondamage_p",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local szMsg = string.format("内功系毒攻攻击：<color=gold>%s%%<color>", Add1(tbMagic1[1], tbMagic2 and tbMagic2[1], bEx2))
        if tbMagic1[2] > 0 then
          --szMsg = szMsg.."<color=gold>/半秒<color>，持续<color=gold>"..frame2sec(tbMagic1[2]).."秒<color>";
          szMsg = szMsg .. "，毒发<color=gold>" .. frame2times(tbMagic1[2]) .. "次<color>"
        end
        return szMsg
      end,
    },
    { "add_magiccolddamage_p", { "内功系冰攻攻击：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "add_magicfiredamage_p", { "内功系火攻攻击：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "add_magiclightdamage_p", { "内功系雷攻攻击：<color=gold>%s%%<color>", { "add1", 1 } } },
    --五行伤害点数属性
    { "addphysicsdamage_v", { "外功系普攻攻击：<color=gold>%s点<color>", { "add1", 1 } } },
    --{ "addpoisondamage_v", { "外功系毒攻攻击：<color=gold>%s点/半秒<color>，持续<color=gold>%s秒<color>", { "add1", 1 },{ "frame2sec", 2} } },
    { "addpoisondamage_v", { "外功系毒攻攻击：<color=gold>%s点<color>，毒发<color=gold>%s次<color>", { "add1", 1 }, { "frame2times", 2 } } },
    { "addcolddamage_v", { "外功系冰攻攻击：<color=gold>%s点<color>", { "add1", 1 } } },
    { "addfiredamage_v", { "外功系火攻攻击：<color=gold>%s点<color>", { "add1", 1 } } },
    { "addlightingdamage_v", { "外功系雷攻攻击：<color=gold>%s点<color>", { "add1", 1 } } },
    { "addphysicsmagic_v", { "内功系普攻攻击：<color=gold>%s点<color>", { "add1", 1 } } },
    --{ "addpoisonmagic_v", { "内功系毒攻攻击：<color=gold>%s点/半秒<color>，持续<color=gold>%s秒<color>", { "add1", 1 },{ "frame2sec", 2} } },
    { "addpoisonmagic_v", { "内功系毒攻攻击：<color=gold>%s点<color>，毒发<color=gold>%s次<color>", { "add1", 1 }, { "frame2times", 2 } } },
    { "addcoldmagic_v", { "内功系冰攻攻击：<color=gold>%s点<color>", { "add1", 1 } } },
    { "addfiremagic_v", { "内功系火攻攻击：<color=gold>%s点<color>", { "add1", 1 } } },
    { "addlightingmagic_v", { "内功系雷攻攻击：<color=gold>%s点<color>", { "add1", 1 } } },
    --武器攻击点数
    { "weapondamagemin_v", { "最小外功攻击力：<color=gold>%s点<color>", { "add1", 1 } } },
    { "weapondamagemax_v", { "最大外功攻击力：<color=gold>%s点<color>", { "add1", 1 } } },
    { "weaponmagicmin_v", { "最小内功攻击力：<color=gold>%s点<color>", { "add1", 1 } } },
    { "weaponmagicmax_v", { "最大内功攻击力：<color=gold>%s点<color>", { "add1", 1 } } },
    { "weaponbasedamagetrim", { "武器基础攻击力：<color=gold>%s点<color>", { "add1", 1 } } },
    --攻击五行转换
    { "magic_turnphysicaldammage", { "普攻攻击转化成其他五行攻击：<color=gold>%s%%<color>", { "add1", 1 } } },
    --各种攻击力加成
    { "skilldamageptrim", { "发挥基础攻击力：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "skillselfdamagetrim", { "发挥技能攻击力：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "damage_inc_p", { "造成的伤害：<color=gold>%s%%<color>", { "add5", 1 } } },
    {
      "attackenhancebycostmana_p",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        return string.format("提升<color=gold>(当前内力百分比 * %s%%)<color>的总攻击力", tbMagic1[1])
      end,
    },
    { "ignoreresist_p", { "攻击忽略<color=gold>%s%%<color>抗性几率：<color=gold>%s%%<color>", 1, { "add1", 2 } } },
    {
      "npcdamageadded",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local szMsg = "对怪物伤害：<color=gold>" .. Add1(tbMagic1[1], tbMagic2 and tbMagic2[1], bEx2) .. "%<color>"
        if tbMagic1[1] < -300 then
          szMsg = "对怪物伤害降低至<color=gold>1<color>"
        end
        return szMsg
      end,
    },
    --会心几率和会心伤害
    { "deadlystrikeenhance_r", { "攻击会心一击值：<color=gold>%s<color>", { "add1", 1 } } },
    { "deadlystrikedamageenhance_p", { "会心一击时攻击：<color=gold>%s%%<color>", { "add1", 1 } } },
    --反弹
    { "meleedamagereturn_v", { "受近身攻击反弹：<color=gold>%s点<color>", { "add1", 1 } } },
    { "meleedamagereturn_p", { "受近身攻击反弹：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "rangedamagereturn_v", { "受远程攻击反弹：<color=gold>%s点<color>", { "add1", 1 } } },
    { "rangedamagereturn_p", { "受远程攻击反弹：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "poisondamagereturn_v", { "受毒伤害时反弹：<color=gold>%s点<color>", { "add1", 1 } } },
    { "poisondamagereturn_p", { "受毒伤害时反弹：<color=gold>%s%%<color>", { "add1", 1 } } },
    --传染
    { "poison2decmana_p", { "使目标受到毒伤害的同时以<color=gold>%s%%<color>比例损失内力，持续<color=gold>#f2-秒<color>", 1 } },

    --吸血吸内
    {
      "steallifeenhance_p",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local szMsg = (tbMagic1[2] < 100) and (Add4(tbMagic1[2], tbMagic2 and tbMagic2[2], bEx2) .. "%将") or ""
        szMsg = szMsg .. "造成的伤害的<color=gold>"
        szMsg = szMsg .. ((tbMagic1[1] >= 0) and Add4(tbMagic1[1], tbMagic2 and tbMagic2[1], bEx2) or Add4(-tbMagic1[1], tbMagic2 and -tbMagic2[1], bEx2))
        szMsg = szMsg .. "%<color>转化为生命" .. ((tbMagic1[1] >= 0) and "回复" or "损失")
        return szMsg
      end,
    },
    {
      "stealmanaenhance_p",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local szMsg = (tbMagic1[2] < 100) and (Add4(tbMagic1[2], tbMagic2 and tbMagic2[2], bEx2) .. "%将") or ""
        szMsg = szMsg .. "造成的伤害的<color=gold>"
        szMsg = szMsg .. ((tbMagic1[1] >= 0) and Add4(tbMagic1[1], tbMagic2 and tbMagic2[1], bEx2) or Add4(-tbMagic1[1], tbMagic2 and -tbMagic2[1], bEx2))
        szMsg = szMsg .. "%<color>转化为内力" .. ((tbMagic1[1] >= 0) and "回复" or "损失")
        return szMsg
      end,
    },
    {
      "stealstaminaenhance_p",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local szMsg = (tbMagic1[2] < 100) and (Add4(tbMagic1[2], tbMagic2 and tbMagic2[2], bEx2) .. "%将") or ""
        szMsg = szMsg .. "造成的伤害的<color=gold>"
        szMsg = szMsg .. ((tbMagic1[1] >= 0) and Add4(tbMagic1[1], tbMagic2 and tbMagic2[1], bEx2) or Add4(-tbMagic1[1], tbMagic2 and -tbMagic2[1], bEx2))
        szMsg = szMsg .. "%<color>转化为体力" .. ((tbMagic1[1] >= 0) and "回复" or "损失")
        return szMsg
      end,
    },
    --生命内力体力
    { "lifemax_v", { "生命最大值点数：<color=gold>%s点<color>", { "add1", 1 } } },
    {
      "lifemax_p",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local nLifeMax = tbMagic1[1]
        return string.format("生命最大值比例：<color=gold>增加%s%%<color>", nLifeMax)
      end,
    },
    { "addmaxhpbymaxmp_p", { "生命最大值点数：<color=gold>内力上限*%s%%<color>", { "add1", 1 } } },
    {
      "lifemax_permillage",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local nLifeMax_p = math.floor(tbMagic1[1] * 10) / 100
        return string.format("生命最大值比例：<color=gold>增加%s%%<color>", nLifeMax_p)
      end,
    },
    { "manamax_v", { "内力最大值点数：<color=gold>%s点<color>", { "add1", 1 } } },
    {
      "manamax_p",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local nManaMax = tbMagic1[1]
        return string.format("内力最大值比例：<color=gold>增加%s%%<color>", nManaMax)
      end,
    },
    {
      "manamax_permillage",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local nManaMax_p = math.floor(tbMagic1[1] * 10) / 100
        return string.format("内力最大值比例：<color=gold>增加%s%%<color>", nManaMax_p)
      end,
    },
    { "staminamax_v", { "体力最大值点数：<color=gold>%s点<color>", { "add1", 1 } } },
    { "staminamax_p", { "体力最大值比例：<color=gold>%s%%<color>", { "add1", 1 } } },
    --生命内力体力回复
    { "lifereplenish_v", { "每五秒生命回复：<color=gold>%s点<color>", { "add1", 1 } } },
    {
      "fastlifereplenish_v",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local nLifeUp = 0
        if not tbSkillInfo then
          nLifeUp = tbMagic1[1]
        else
          nLifeUp = tbMagic1[1]
        end
        return string.format("每半秒生命回复：<color=gold>%s点<color>", Add1(nLifeUp, tbMagic2 and tbMagic2[1], bEx2))
      end,
    },
    {
      "replenishlifebymaxhp_p",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local nLifeUp = 0
        local nLifeUpTrue = tbMagic1[3]
        if not tbSkillInfo then
          nLifeUp = tbMagic1[1]
        else
          nLifeUp = tbMagic1[1]
        end
        if nLifeUpTrue == 0 then
          nLifeUpTrue = math.floor(me.nCurLife * nLifeUp / 1000)
          return string.format("每半秒生命回复：<color=gold>%s%%*生命上限<color>", Add1(nLifeUp / 10))
          --return string.format("每半秒生命回复：<color=gold>%s<color>",Add1(nLifeUpTrue));
        else
          nLifeUpTrue = math.floor(nLifeUpTrue * nLifeUp / 1000)
          return string.format("每半秒生命回复：<color=gold>%s<color>", Add1(nLifeUpTrue))
        end
      end,
    },
    { "manareplenish_v", { "每五秒内力回复：<color=gold>%s点<color>", { "add1", 1 } } },
    { "fastmanareplenish_v", { "每半秒内力回复：<color=gold>%s点<color>", { "add1", 1 } } },
    { "staminareplenish_v", { "每五秒体力回复：<color=gold>%s点<color>", { "add1", 1 } } },
    { "faststaminareplenish_v", { "每半秒体力回复：<color=gold>%s点<color>", { "add1", 1 } } },
    { "lifepotion_v", { "每半秒生命回复：<color=gold>%s点<color>，持续<color=gold>%s秒<color>", { "add1", 1 }, { "frame2sec", 2 } } },
    { "manapotion_v", { "每半秒内力回复：<color=gold>%s点<color>，持续<color=gold>%s秒<color>", { "add1", 1 }, { "frame2sec", 2 } } },
    { "lifegrow_v", { "每半秒生命恢复：<color=gold>%s点<color>，持续<color=gold>%s秒<color>", { "add1", 1 }, { "frame2sec", 2 } } },
    { "managrow_v", { "每半秒内力恢复：<color=gold>%s点<color>，持续<color=gold>%s秒<color>", { "add1", 1 }, { "frame2sec", 2 } } },
    { "staminagrow_v", { "每半秒体力恢复：<color=gold>%s点<color>，持续<color=gold>%s秒<color>", { "add1", 1 }, { "frame2sec", 2 } } },
    { "damage2addmana_p", { "受到伤害转化为内力回复：<color=gold>%s%%<color>", { "add1", 1 } } },
    --闪避
    { "adddefense_v", { "闪避值：<color=gold>%s点<color>", { "add1", 1 } } },
    { "adddefense_p", { "闪避值：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "armordefense_v", { "闪避值：<color=gold>%s点<color>", { "add1", 1 } } }, --马用的都是这个,没任何区别.....
    --五行抗性
    { "damage_all_resist", { "所有抗性：<color=gold>%s<color>", { "add1", 1 } } },
    {
      "damage_series_resist",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local tbResist = { "普攻抗性", "火攻抗性", "冰攻抗性", "雷攻抗性", "毒攻抗性" }
        local szResist = tbResist[tbMagic1[3] + 1]
        if not szResist then
          return string.format("对应五行抗性：<color=gold>%s<color>", Add1(tbMagic1[1], tbMagic2 and tbMagic2[1], bEx2))
        end
        return string.format("%s：<color=gold>%s<color>", szResist, Add1(tbMagic1[1], tbMagic2 and tbMagic2[1], bEx2))
      end,
    },
    { "damage_physics_resist", { "普攻抗性：<color=gold>%s<color>", { "add1", 1 } } },
    { "damage_poison_resist", { "毒攻抗性：<color=gold>%s<color>", { "add1", 1 } } },
    { "damage_cold_resist", { "冰攻抗性：<color=gold>%s<color>", { "add1", 1 } } },
    { "damage_fire_resist", { "火攻抗性：<color=gold>%s<color>", { "add1", 1 } } },
    { "damage_light_resist", { "雷攻抗性：<color=gold>%s<color>", { "add1", 1 } } },
    { "damage_return_receive_p", { "受到的反弹伤害：<color=gold>%s%%<color>", { "add1", 1 } } }, --修改了反弹伤害抗性的描述
    --回复效率
    { "lifereplenish_p", { "生命回复的效率：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "manareplenish_p", { "内力回复的效率：<color=gold>%s%%<color>", { "add1", 1 } } },
    --该属性只对按比例伤害有效（内力，体力无效），与redeivedamage_dec_p或redeivedamage_dec_p2一起使用，该状态没有tip描述
    { "percentreducelife_percent", { "受到按比例扣血伤害：<color=gold>%s%%<color>", { "add5", 1 } } }, --正数为放大
    --额外的防御
    { "redeivedamage_dec_p", { "受到的伤害：<color=gold>%s%%<color>", { "add6", 1 } } },
    { "redeivedamage_dec_p2", { "所受五行伤害：<color=gold>%s%%<color>", { "add6", 1 } } },
    --令dmg为原伤害,ris_p=1.7*防御方抗性/(200+攻击方等级*10+防御方抗性),防御方抗性不计五行相克和忽抗
    --当自身defence_level属性值大于等于目标defence_level属性值时
    --伤害放大公式为dmg=dmg*(1-ris_p*DefenceLevelConstValue/100)/(1-ris_p)
    {
      "defence_level",
      {
        "抗性洞察：<color=gold>%s<color>\n<color=gray>  攻击敌人时，根据目标抗性放大伤害；自身洞察大于等于敌方洞察时，放大比例会较高<color>",
        { "add1", 1 },
      },
    },
    --无敌
    { "prop_invincibility", { "<color=gold>不受任何伤害技能影响<color>" } },
    --会心防御
    { "cri_resist", { "受到的会心一击值：<color=gold>%s<color>", { "add2", 1 } } },
    { "defencedeadlystrikedamagetrim", { "受会心一击伤害：<color=gold>%s%%<color>", { "add2", 1 } } },
    --各种护盾
    { "manashield_p", { "内力大于15%%时以内力吸收伤害：<color=gold>%s%%<color>", { "add1", 1 } } },
    {
      "dynamicmagicshieldbymaxhp_p",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local szMsg = string.format("化解<color=gold>%d%%<color>伤害，最大值为<color=gold>%s%%*生命上限<color>", tbMagic1[2], tbMagic1[1] / 10)
        return szMsg
      end,
    },
    {
      "dynamicmagicshield_v",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local szMsg = "化解伤害值点数：<color=gold>" .. Add1(tbMagic1[1], tbMagic2 and tbMagic2[1], bEx2) .. "点<color>"
        if tbMagic1[2] < 99 then
          szMsg = szMsg .. "，最多不超过原伤害的<color=gold>" .. tbMagic1[2] .. "%<color>"
        end
        if tbMagic1[1] > 100000 then
          szMsg = "化解<color=gold>" .. tbMagic1[2] .. "%<color>伤害值"
        end
        return szMsg
      end,
    },
    {
      "posionweaken",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local szMsg = "化解持续毒伤点数：<color=gold>" .. Add1(tbMagic1[1], tbMagic2 and tbMagic2[1], bEx2) .. "点<color>"
        if tbMagic1[2] < 99 then
          szMsg = szMsg .. "，最多不超过原伤害的<color=gold>" .. tbMagic1[2] .. "%<color>"
        end
        if tbMagic1[1] > 100000 then
          szMsg = "化解<color=gold>" .. tbMagic1[2] .. "%<color>持续毒伤害"
        end
        return szMsg
      end,
    },
    --闪避技能
    --参数1是闪避概率,参数2表示是否获得时清除,参数3表示关联buff类型
    {
      "ignoreskill",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local nRateMin = tbMagic1[1]
        local nRateMax
        if tbMagic2 and tbMagic2[1] then
          nRateMax = tbMagic2[1]
        end
        local tbIgnoreString = {
          [1] = string.format("清除<color=gold>%d<color>个光环状态\n无法获得光环状态概率：<color=gold>%s%%<color>", tbMagic1[2], tbMagic1[1]),
          [2] = string.format("完全闪避内功系攻击概率：<color=gold>%s%%<color>", Add1(nRateMin, nRateMax, bEx2)),
          [3] = string.format("完全闪避内外功系攻击概率：<color=gold>%s%%<color>", Add1(nRateMin, nRateMax, bEx2)),
          [4] = string.format("完全闪避外功系攻击概率：<color=gold>%s%%<color>", Add1(nRateMin, nRateMax, bEx2)),
          [5] = string.format("以<color=gold>%s%%<color>的几率获得100%%闪避陷阱状态", KFightSkill.GetMissileRate(tbSkillInfo.nId, tbSkillInfo.nLevel)),
          [6] = string.format("完全闪避远程攻击概率：<color=gold>%s%%<color>", Add1(nRateMin, nRateMax, bEx2)),
          [7] = string.format("无法获得主动辅助状态概率：<color=gold>%s%%<color>", Add1(nRateMin, nRateMax, bEx2)),
          [8] = string.format("完全闪避状态技能概率：<color=gold>%s%%<color>", Add1(nRateMin, nRateMax, bEx2)), --闲置
          [9] = string.format("完全闪避极效攻击概率：<color=gold>%s%%<color>", Add1(nRateMin, nRateMax, bEx2)),
        }
        if tbIgnoreString[tbMagic1[3]] then
          if (tbMagic1[3] == 1) or (tbMagic1[1] ~= 0) then
            return tbIgnoreString[tbMagic1[3]]
          else
            return ""
          end
        else
          print("[ERROR]unknown ignoreskill style:", tbMagic1[3])
          return ""
        end
      end,
    },
    { "magic_duck_skill", { "闪避<color=gold>%s<color>", { "getskillname", 1 } } },
    {
      "ignore_skillstyle_bydist",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        return string.format("完全闪避内外功系攻击几率：<color=gold>(双方距离/%s)%%<color>", tbMagic1[1] / 100)
      end,
    },
    { "ignoreattackontime", { "每隔<color=gold>%s秒<color>可以忽略半秒的攻击", { "frame2sec", 1 } } },
    { "returnskill_p", { "反弹诅咒的几率：<color=gold>%s%%<color>", { "add1", 1 } } },
    --官印抵御
    {
      "ignoreattack",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        return GetIgnoreAttackDesc(tbSkillInfo)
      end,
    },
    --挡子弹
    { "destory_missile", { "被飞行技能伤害时使该技能无法继续伤害几率：<color=gold>%s%%<color>", 1 } },

    --锁状态,以buff形式存在的限制属性
    {
      "locked_state",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local szMsg = ""
        if tbMagic1[1] == 1 then
          szMsg = szMsg .. "无法移动"
          szMsg = szMsg .. (tbMagic1[2] + tbMagic1[3] > 0 and "\n" or "")
        end
        if tbMagic1[2] == 1 then
          szMsg = szMsg .. "无法使用技能"
          szMsg = szMsg .. (tbMagic1[3] > 0 and "\n" or "")
        end
        if tbMagic1[3] == 1 then
          szMsg = szMsg .. "无法使用道具"
        end
        return string.format("<color=red>%s<color>", szMsg)
      end,
    },

    --忽略对手五行几率抗性
    { "state_hurt_resisttargetrate", { "忽略对手受伤几率抗性：<color=gold>%s<color>", { "add1", 1 } } },
    { "state_weak_resisttargetrate", { "忽略对手虚弱几率抗性：<color=gold>%s<color>", { "add1", 1 } } },
    { "state_slowall_resisttargetrate", { "忽略对手迟缓几率抗性：<color=gold>%s<color>", { "add1", 1 } } },
    { "state_burn_resisttargetrate", { "忽略对手灼伤几率抗性：<color=gold>%s<color>", { "add1", 1 } } },
    { "state_stun_resisttargetrate", { "忽略对手眩晕几率抗性：<color=gold>%s<color>", { "add1", 1 } } },
    --造成五行状态的几率
    { "state_hurt_attackrate", { "造成受伤的几率：<color=gold>%s<color>", { "add1", 1 } } },
    { "state_weak_attackrate", { "造成虚弱的几率：<color=gold>%s<color>", { "add1", 1 } } },
    { "state_slowall_attackrate", { "造成迟缓的几率：<color=gold>%s<color>", { "add1", 1 } } },
    { "state_burn_attackrate", { "造成灼伤的几率：<color=gold>%s<color>", { "add1", 1 } } },
    { "state_stun_attackrate", { "造成眩晕的几率：<color=gold>%s<color>", { "add1", 1 } } },
    { "allseriesstateattackrate", { "造成五行状态的几率：<color=gold>%s<color>", { "add1", 1 } } },
    {
      "seriesstate_added",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local tbMsg = {
          "造成受伤的几率：增加<color=gold>",
          "造成虚弱的几率：增加<color=gold>",
          "造成迟缓的几率：增加<color=gold>",
          "造成灼伤的几率：增加<color=gold>",
          "造成眩晕的几率：增加<color=gold>",
          "造成对应五行效果的几率：增加<color=gold>",
        }
        local nSeries = me.nSeries
        if nSeries > 6 or nSeries <= 0 then
          nSeries = 6
        end
        local szMsg = tbMsg[nSeries] .. tbMagic1[1] .. "<color>"
        return szMsg
      end,
    },
    --造成负面状态的几率
    { "state_fixed_attackrate", { "造成定身的几率：<color=gold>%s<color>", { "add1", 1 } } },
    { "state_palsy_attackrate", { "造成麻痹的几率：<color=gold>%s%<color>", { "add1", 1 } } },
    { "state_slowrun_attackrate", { "造成跑速降低的几率：<color=gold>%s<color>", { "add1", 1 } } },
    { "state_freeze_attackrate", { "造成冻结的几率：<color=gold>%s<color>", { "add1", 1 } } },
    { "state_confuse_attackrate", { "造成混乱的几率：<color=gold>%s<color>", { "add1", 1 } } },
    { "state_knock_attackrate", { "造成击退的几率：<color=gold>%s<color>", { "add1", 1 } } },
    { "state_drag_attackrate", { "造成拉回的几率：<color=gold>%s<color>", { "add1", 1 } } },
    { "state_silence_attackrate", { "造成沉默的几率：<color=gold>%s<color>", { "add1", 1 } } },
    { "allspecialstateattackrate", { "造成负面状态的几率：<color=gold>%s<color>", { "add1", 1 } } },
    --忽略对手五行时间抗性
    { "state_hurt_resisttargettime", { "忽略对手受伤时间抗性：<color=gold>%s<color>", { "add1", 1 } } },
    { "state_weak_resisttargettime", { "忽略对手虚弱时间抗性：<color=gold>%s<color>", { "add1", 1 } } },
    { "state_slowall_resisttargettime", { "忽略对手迟缓时间抗性：<color=gold>%s<color>", { "add1", 1 } } },
    { "state_burn_resisttargettime", { "忽略对手灼伤时间抗性：<color=gold>%s<color>", { "add1", 1 } } },
    { "state_stun_resisttargettime", { "忽略对手眩晕时间抗性：<color=gold>%s<color>", { "add1", 1 } } },
    --造成五行状态的时间
    { "state_hurt_attacktime", { "造成受伤的时间：<color=gold>%s<color>", { "add1", 1 } } },
    { "state_weak_attacktime", { "造成虚弱的时间：<color=gold>%s<color>", { "add1", 1 } } },
    { "state_slowall_attacktime", { "造成迟缓的时间：<color=gold>%s<color>", { "add1", 1 } } },
    { "state_burn_attacktime", { "造成灼伤的时间：<color=gold>%s<color>", { "add1", 1 } } },
    { "state_stun_attacktime", { "造成眩晕的时间：<color=gold>%s<color>", { "add1", 1 } } },
    { "seriesstate_time_added", { "造成五行状态的时间：<color=gold>%s<color>", { "add1", 1 } } },
    { "allseriesstateattacktime", { "造成五行效果的时间：<color=gold>%s<color>", { "add1", 1 } } },
    --造成负面状态的时间
    { "state_fixed_attacktime", { "造成定身的时间：<color=gold>%s<color>", { "add1", 1 } } },
    { "state_palsy_attacktime", { "造成麻痹的时间：<color=gold>%s<color>", { "add1", 1 } } },
    { "state_slowrun_attacktime", { "造成跑速降低的时间：<color=gold>%s<color>", { "add1", 1 } } },
    { "state_freeze_attacktime", { "造成冻结的时间：<color=gold>%s<color>", { "add1", 1 } } },
    { "state_confuse_attacktime", { "造成混乱的时间：<color=gold>%s<color>", { "add1", 1 } } },
    { "state_knock_attacktime", { "造成击退的时间：<color=gold>%s<color>", { "add1", 1 } } },
    { "state_drag_attacktime", { "造成拉回的时间：<color=gold>%s<color>", { "add1", 1 } } },
    { "state_silence_attacktime", { "造成沉默的时间：<color=gold>%s<color>", { "add1", 1 } } },
    { "allspecialstateattacktime", { "造成负面状态的时间：<color=gold>%s<color>", { "add1", 1 } } },

    --五行状态几率抗性
    { "state_hurt_resistrate", { "受到受伤的几率：<color=gold>%s<color>", { "add2", 1 } } },
    { "state_weak_resistrate", { "受到虚弱的几率：<color=gold>%s<color>", { "add2", 1 } } },
    { "state_slowall_resistrate", { "受到迟缓的几率：<color=gold>%s<color>", { "add2", 1 } } },
    { "state_burn_resistrate", { "受到灼伤的几率：<color=gold>%s<color>", { "add2", 1 } } },
    { "state_stun_resistrate", { "受到眩晕的几率：<color=gold>%s<color>", { "add2", 1 } } },
    { "allseriesstateresistrate", { "受到五行状态的几率：<color=gold>%s<color>", { "add2", 1 } } },
    --负面状态几率抗性
    { "state_fixed_resistrate", { "受到定身的几率：<color=gold>%s<color>", { "add2", 1 } } },
    { "state_palsy_resistrate", { "受到麻痹的几率：<color=gold>%s<color>", { "add2", 1 } } },
    { "state_slowrun_resistrate", { "受到跑速降低的几率：<color=gold>%s<color>", { "add2", 1 } } },
    { "state_freeze_resistrate", { "受到冻结的几率：<color=gold>%s<color>", { "add2", 1 } } },
    { "state_confuse_resistrate", { "受到混乱的几率：<color=gold>%s<color>", { "add2", 1 } } },
    { "state_knock_resistrate", { "受到击退的几率：<color=gold>%s<color>", { "add2", 1 } } },
    { "state_drag_resistrate", { "受到拉回的几率：<color=gold>%s<color>", { "add2", 1 } } },
    { "state_silence_resistrate", { "受到沉默的几率：<color=gold>%s<color>", { "add2", 1 } } },
    { "allspecialstateresistrate", { "受到负面状态的几率：<color=gold>%s<color>", { "add2", 1 } } },
    --五行状态时间抗性
    { "state_hurt_resisttime", { "受到受伤的时间：<color=gold>%s<color>", { "add2", 1 } } },
    { "state_weak_resisttime", { "受到虚弱的时间：<color=gold>%s<color>", { "add2", 1 } } },
    { "state_slowall_resisttime", { "受到迟缓的时间：<color=gold>%s<color>", { "add2", 1 } } },
    { "state_burn_resisttime", { "受到灼伤的时间：<color=gold>%s<color>", { "add2", 1 } } },
    { "state_stun_resisttime", { "受到眩晕的时间：<color=gold>%s<color>", { "add2", 1 } } },
    { "allseriesstateresisttime", { "受到五行状态的时间：<color=gold>%s<color>", { "add2", 1 } } },
    --负面状态时间抗性
    { "state_fixed_resisttime", { "受到定身的时间：<color=gold>%s<color>", { "add2", 1 } } },
    { "state_palsy_resisttime", { "受到麻痹的时间：<color=gold>%s<color>", { "add2", 1 } } },
    { "state_slowrun_resisttime", { "受到跑速降低的时间：<color=gold>%s<color>", { "add2", 1 } } },
    { "state_freeze_resisttime", { "受到冻结的时间：<color=gold>%s<color>", { "add2", 1 } } },
    { "state_confuse_resisttime", { "受到混乱的时间：<color=gold>%s<color>", { "add2", 1 } } },
    { "state_knock_resisttime", { "受到击退的时间：<color=gold>%s<color>", { "add2", 1 } } },
    { "state_drag_resisttime", { "受到拉回的时间：<color=gold>%s<color>", { "add2", 1 } } },
    { "state_silence_resisttime", { "受到沉默的时间：<color=gold>%s<color>", { "add2", 1 } } },
    { "allspecialstateresisttime", { "受到负面状态的时间：<color=gold>%s<color>", { "add2", 1 } } },
    --免疫五行状态
    { "state_hurt_ignore", { "清除并免疫受伤" } },
    { "state_weak_ignore", { "清除并免疫虚弱" } },
    { "state_slowall_ignore", { "清除并免疫迟缓" } },
    { "state_burn_ignore", { "清除并免疫灼伤" } },
    { "state_stun_ignore", { "清除并免疫眩晕" } },
    --免疫负面状态
    { "state_fixed_ignore", { "清除并免疫定身" } },
    { "state_palsy_ignore", { "清除并免疫麻痹" } },
    { "state_slowrun_ignore", { "清除并免疫跑速降低" } },
    { "state_freeze_ignore", { "清除并免疫冻结" } },
    { "state_confuse_ignore", { "清除并免疫混乱" } },
    { "state_knock_ignore", { "清除并免疫击退" } },
    { "state_drag_ignore", { "清除并免疫拉回" } },
    { "state_silence_ignore", { "清除并免疫沉默" } },
    --免疫一系列状态
    {
      "ignoredebuff",
      --多个生效的话是数个数字相加
      --Lib:LoadBits(tbMagic1[1],i,i) ==1
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local tbValue2 = {}
        local tbState = {
          [0] = "受伤",
          [1] = "虚弱",
          [2] = "迟缓",
          [3] = "灼伤",
          [4] = "眩晕",
          [5] = "定身",
          [6] = "麻痹",
          [7] = "减跑速",
          [8] = "冻结",
          [9] = "混乱",
          [10] = "击退",
          [11] = "拉扯",
          [12] = "沉默",
          [13] = "致残",
          [14] = "浮空",
        }
        local nValue = tbMagic1[1]
        do
          local i = 0
          repeat
            if nValue == 2 * math.floor(nValue / 2) then
              tbValue2[i] = 0
              nValue = math.floor(nValue / 2)
              i = i + 1
            else
              tbValue2[i] = 1
              nValue = math.floor(nValue / 2)
              i = i + 1
            end
          until nValue == 0
        end
        local szMsg = ""
        local nNum = #tbValue2
        do
          local bS1, bS2 = 1, 1
          --五行全有就显示免疫五行,不单独显示
          for i = 0, 4 do
            bS1 = tbValue2[i] and bS1 * tbValue2[i] or 0
          end
          if bS1 == 1 then
            szMsg = szMsg .. ((szMsg ~= "") and "\n" or "") .. "<color=gold>清除并免疫五行状态<color>"
            for i = 0, 4 do
              tbValue2[i] = 0
            end
          end

          --负面全有就显示免疫负面,不单独显示
          for i = 5, 14 do
            bS2 = tbValue2[i] and bS2 * tbValue2[i] or 0
          end
          if bS2 == 1 then
            szMsg = szMsg .. ((szMsg ~= "") and "\n" or "") .. "<color=gold>清除并免疫负面状态<color>"
            for i = 5, 14 do
              tbValue2[i] = 0
            end
          end
        end

        for i = 0, nNum do
          if tbValue2[i] == 1 then
            szMsg = szMsg .. ((szMsg ~= "") and "\n" or "") .. "<color=gold>清除并免疫" .. (tbState[i] or "未知状态") .. "<color>"
          end
        end
        return string.format("%s", szMsg)
      end,
    },

    --跑速
    { "fastwalkrun_v", { "移动速度：<color=gold>%s<color>", { "add1", 1 } } },
    {
      "fastwalkrun_p",
      function(tbMagic, tbSkillInfo, tbMagic2, bEx2)
        if tbMagic[1] == 0 then
          return ""
        end
        return string.format("移动速度：<color=gold>%s%%<color>", Add1(tbMagic[1], tbMagic2 and tbMagic2[1], bEx2))
      end,
    },
    --技能+n
    {
      "allskill_v",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        --多个生效的话是数个数字相加
        if FightSkill.MAGIC_INVALID == tbMagic1[3] then
          local tbAddSkillType = {
            [0] = "所有", --0
            [1] = "门派", --1
            [2] = "秘籍", --2
            [3] = "同伴", --4
          }
          local szMsg = ""
          for i = 0, 31 do
            if tbMagic1[2] == 0 then
              szMsg = szMsg .. tbAddSkillType[0]
              break
            end
            if Lib:LoadBits(tbMagic1[2], i, i) == 1 then
              if szMsg == "" then
                szMsg = tbAddSkillType[i + 1]
              else
                szMsg = szMsg .. "及" .. tbAddSkillType[i + 1]
              end
            end
          end
          szMsg = string.format("%s技能：<color=gold>%s级<color>", szMsg, Add1(tbMagic1[1], tbMagic2 and tbMagic2[1], bEx2))
          return szMsg
        end
        local szSkillName = GetSkillName(tbMagic1[3])
        return string.format("<color=blue>%s<color>等级：<color=gold>%s级<color>", szSkillName, Add1(tbMagic1[1], tbMagic2 and tbMagic2[1], bEx2))
      end,
    },
    {
      "hide",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local nLastTime = tbMagic1[2] + KFightSkill.GetAddSkillHideTime(tbSkillInfo.nId)
        if tbMagic1[3] == 1 then
          return string.format("隐身<color=gold>%s秒<color>，队友可见，主动发招后显形", Frame2Sec(nLastTime))
        elseif tbMagic1[3] == 2 then
          return string.format("隐身<color=gold>%s秒<color>，同阵营可见，主动发招后显形", Frame2Sec(nLastTime))
        end
        return ""
      end,
    },
    { "prop_showhide", { "能发现隐身对手" } },
    --改变战斗关系
    { "defense_state", { "不受攻击(可以攻击敌人)" } },
    --变身
    --参数1,变身npcid,参数2变身npc等级,参数3变身类型:1变外观,2变属性,4改变技能
    --{ "domainchangeself",  { "变身为npc<color=gold>%s%%<color>", { "add1", 1 } } },
    --特殊的状态属性,非战斗属性
    { "expenhance_p", { "杀死怪物的经验：<color=gold>%s%%<color>", { "add1", 1 } } },
    {
      "expxiuwei_v",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        return string.format("开启修为获取   剩余<color=gold>%s<color>点", me.GetTask(1023, 4))
      end,
    },
    { "subexplose", { "重伤的经验损失：<color=gold>%s%%<color>", { "add2", 1 } } },
    { "addexpshare", { "获得队友杀怪的分享经验：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "magic_item_abrade_p", { "装备耐久的磨损速度：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "lucky_v", { "幸运值：<color=gold>%s点<color>", { "add1", 1 } } },
    --激活
    { "active_all_ornament", "激活所有首饰的暗属性" },
    { "active_all_hide_attrib", "激活所有装备的暗属性" },
    {
      "active_suit",
      function(tbMagic, tbSkillInfo, tbMagic2, bEx2)
        local tbSuiteAttrib = KItem.GetPlayerGreenSuiteAttrib(me, tbMagic[1])
        if tbSuiteAttrib then
          return string.format("<color=gold>激活<color=green>%s<color>上的<color=green>%d<color>条套装属性<color>", tbSuiteAttrib.szName, tbMagic[2])
        end
        return ""
      end,
    },
    --改变外观
    {
      "disguise_part_base",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        if Item.szResPart[tbMagic1[2]] then
          return string.format("可以改变%s的外观", Item.szResPart[tbMagic1[2]])
        end
        return ""
      end,
    },
    { "disguise_part_effect", "" },
  },
  --状态属性2,技能加成类放后面好看点儿
  [5] = {
    --技能加成
    {
      "addenchant",
      function(tbMagic, tbSkillInfo, tbMagic2, bEx2)
        return EnchantDesc(tbMagic, tbSkillInfo, tbMagic2, bEx2)
      end,
    },
    { "addmissilethroughrate", { "<color=orange>%s<color>有<color=gold>%s%%<color>的几率穿透目标", { "getskillname", 1 }, 2 } },
    {
      "addpowerwhencol",
      {
        "<color=orange>%s<color>每次穿透目标后攻击力<color=gold>%s%%<color>，累加上限为<color=gold>%s%%<color>",
        { "getskillname", 1 },
        { "add1", 2 },
        3,
      },
    },
    {
      "addrangewhencol",
      {
        "<color=orange>%s<color>每次穿透目标后效果范围<color=gold>%s格<color>，累加上限为<color=gold>%s格<color>",
        { "getskillname", 1 },
        { "add1", 2 },
        3,
      },
    },
    { "decautoskillcdtime", { "<color=orange>%s<color>的触发间隔时间：<color=gold>减少%s秒<color>", { "getskillname", 1 }, { "frame2sec", 3 } } },
    {
      "changecdtype",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local szMsg = string.format("<color=orange>%s<color>使用模式变更：", GetSkillName(tbMagic1[1]))
        if tbMagic1[3] ~= 0 then
          szMsg = szMsg .. "\n    每次冷却可用次数回复：<color=gold>" .. (tbMagic1[3] / 100) .. "次<color>"
        else
          szMsg = szMsg .. "\n    冷却不会回复可用次数"
        end
        szMsg = szMsg .. "\n    最大使用次数：<color=gold>" .. (math.floor(tbMagic1[2] / 100)) .. "次<color>"
        return szMsg
      end,
    },
    {
      "changecdtype2",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local szMsg = string.format("<color=orange>%s<color>使用模式变更：", GetSkillName(tbMagic1[1]))
        if tbMagic1[3] ~= 0 then
          szMsg = szMsg .. "\n    每次冷却可用次数回复：<color=gold>" .. (tbMagic1[3] / 100) .. "次<color>"
        end
        szMsg = szMsg .. "\n    最大使用次数：<color=gold>" .. (math.floor(tbMagic1[2] / 100)) .. "次<color>"
        return szMsg
      end,
    },
    {
      "changecdtype3",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local szMsg = string.format("<color=orange>%s<color>使用模式变更：", GetSkillName(tbMagic1[1]))
        if tbMagic1[3] ~= 0 then
          szMsg = szMsg .. "\n    每次冷却可用次数回复：<color=gold>" .. (tbMagic1[3] / 100) .. "次<color>"
        end
        szMsg = szMsg .. "\n    最大使用次数：<color=gold>" .. (math.floor(tbMagic1[2] / 100)) .. "次<color>"
        return szMsg
      end,
    },
    {
      "changecdtype4",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local szMsg = string.format("<color=orange>%s<color>使用模式变更：", GetSkillName(tbMagic1[1]))
        if tbMagic1[3] ~= 0 then
          szMsg = szMsg .. "\n    每次冷却可用次数回复：<color=gold>" .. (tbMagic1[3] / 100) .. "次<color>"
        end
        szMsg = szMsg .. "\n    最大使用次数：<color=gold>" .. (math.floor(tbMagic1[2] / 100)) .. "次<color>"
        return szMsg
      end,
    },
    --调用其他技能
    {
      "addedwith_enemycount",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        return AddedwithEnemyCount(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
      end,
    },
    {
      "rdclifewithdis",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        return string.format("移动时每半秒根据移动距离而受到伤害\n发挥基础攻击力：<color=gold>移动距离 * %s%%<color>，最大不超过<color=gold>%s%%<color>", tbMagic1[1] / 100, math.floor(tbMagic1[1] / 100 * tbMagic1[2]))
      end,
    },
    {
      "autoskill",
      function(tbMagic, tbSkillInfo, tbMagic2, bEx2)
        local tbAutoInfo = KFightSkill.GetAutoInfo(tbMagic[1], tbMagic[2])
        local szClassName = (tbSkillInfo and tbSkillInfo.szClassName) or "default"
        return FightSkill.tbClass[szClassName]:GetAutoDesc(tbAutoInfo, tbSkillInfo)
      end,
    },
    {
      "autoskill2",
      function(tbMagic, tbSkillInfo, tbMagic2, bEx2)
        local tbAutoInfo = KFightSkill.GetAutoInfo(tbMagic[1], tbMagic[2])
        local szClassName = (tbSkillInfo and tbSkillInfo.szClassName) or "default"
        return FightSkill.tbClass[szClassName]:GetAutoDesc2(tbAutoInfo, tbSkillInfo)
      end,
    },
    {
      "addstartskill",
      function(tbMagic, tbSkillInfo, tbMagic2, bEx2)
        local tbMsg = {}
        local tbChildInfo = KFightSkill.GetSkillInfo(tbMagic[2], tbMagic[3])
        FightSkill:GetClass("default"):GetDescAboutLevel(tbMsg, tbChildInfo, 0)
        local szSkillInfo = table.concat(tbMsg, "\n") .. "\n"
        --特定的加成描述隐藏起来
        local tbHide = {
          { 2806, 2818 }, --寒山独立加成红袖缠获得绝
          --{182,1660},--以前的回风拂柳加成啸风三连击
        }
        for _, tb in pairs(tbHide) do
          if tbMagic[1] == tb[1] and tbMagic[2] == tb[2] then
            return
          end
        end
        return string.format("<color=orange>%s<color>时同时释放：\n<color=green>[%s] %s级<color>\n%s", GetSkillName(tbMagic[1]), GetSkillName(tbMagic[2]), tbMagic[3], szSkillInfo)
      end,
    },
    {
      "addflyskill",
      function(tbMagic, tbSkillInfo, tbMagic2, bEx2)
        local tbMsg = {}
        local tbChildInfo = KFightSkill.GetSkillInfo(tbMagic[2], tbMagic[3])
        FightSkill:GetClass("default"):GetDescAboutLevel(tbMsg, tbChildInfo, 0)
        local szSkillInfo = table.concat(tbMsg, "\n") .. "\n"
        return string.format("<color=orange>%s<color>过程中释放：\n<color=green>[%s] %s级<color>\n%s", GetSkillName(tbMagic[1]), GetSkillName(tbMagic[2]), tbMagic[3], szSkillInfo)
      end,
    },
    {
      "addvanishskill",
      function(tbMagic, tbSkillInfo, tbMagic2, bEx2)
        local tbMsg = {}
        local tbChildInfo = KFightSkill.GetSkillInfo(tbMagic[2], tbMagic[3])
        FightSkill:GetClass("default"):GetDescAboutLevel(tbMsg, tbChildInfo, 0)
        local szSkillInfo = table.concat(tbMsg, "\n") .. "\n"
        return string.format("<color=orange>%s<color>结束时释放：\n<color=green>[%s] %s级<color>\n%s", GetSkillName(tbMagic[1]), GetSkillName(tbMagic[2]), tbMagic[3], szSkillInfo)
      end,
    },
  },
  --比较适合放在后面的技能设置
  [6] = {
    { "missile_dmginterval", { "招式作用间隔：<color=gold>%s秒<color>", { "frame2sec", 1 } } },
    { "missile_lifetime_v", { "招式持续时间：<color=gold>%s秒<color>", { "frame2sec", 1 } } },
    { "missile_collzheight", { "对处于空中的目标有效" } }, --至少要参数填的比较大,填个9999差不多够了,目标高度小于等于p时才会与子弹碰撞
    {
      "missile_random",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        if tbMagic1[2] == 0 then
          return string.format("每个招式出现几率：<color=gold>%s%%<color>", tbMagic1[1])
        elseif tbMagic1[2] == 1 then
          return string.format("所有招式随机出现其中的<color=gold>%s%%<color>", tbMagic1[1])
        else
          return string.format("未知随机子弹出现类型")
        end
        return ""
      end,
    },
    {
      "superposemagic",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        local szMsg = ""
        if tbMagic1[1] <= 1 then
          return ""
        elseif tbMagic1[2] > 0 then
          szMsg = string.format("当前叠加：<color=gold>%s/%s层<color>", tbMagic1[2], tbMagic1[1])
        else --if tbMagic1[2] <= 0 then
          szMsg = string.format("最多叠加：<color=gold>%s层<color>", tbMagic1[1])
          if tbMagic1[3] > 1 then
            szMsg = string.format("每次叠加<color=gold>%s层<color>，", tbMagic1[3]) .. szMsg
          end
        end
        return szMsg
      end,
    },
  },
  --确定无效或很可能无效的属性
  [7] = {
    ---------------------应该有效,但不知道怎么用----------------
    { "fatallystrike_p", { "致命一击的几率：<color=gold>%s%%，使攻击忽略抗性%s", 1, 3 } },
    { "infectpoison", { "传染<color=gold>%s%%<color>受伤的毒攻", 1 } },
    {
      "addignoreskill",
      function(tbMagic1, tbSkillInfo, tbMagic2, bEx2)
        if tbMagic1[3] == 1 then
          return string.format("使<color=orange>%s<color>以<color=gold>%s%%<color>的几率立即驱散<color=gold>%s个<color>诅咒，并以<color=gold>%s%%<color>的几率免疫诅咒", KFightSkill.GetMissileRate(tbSkillInfo.nId, tbSkillInfo.nLevel), Add4(tbMagic1[2], tbMagic2 and tbMagic2[2], bEx2), Add4(tbMagic1[1], tbMagic2 and tbMagic2[1], bEx2))
        elseif tbMagic1[3] == 2 then
          return string.format("使<color=orange>%s<color>以<color=gold>%s%%<color>的几率闪避内功系攻击", GetSkillName(tbMagic1[1]), Add4(tbMagic1[2], tbMagic2 and tbMagic2[2], bEx2))
        elseif tbMagic1[3] == 3 then
          return string.format("使<color=orange>%s<color>以<color=gold>%s%%<color>的几率闪避外功系和内功系攻击", GetSkillName(tbMagic1[1]), Add4(tbMagic1[2], tbMagic2 and tbMagic2[2], bEx2))
        end
        print("[ERROR]unknown ignoreskill style:", tbMagic1[3])
        return ""
      end,
    },
    ----------------------------虽然有效,不过有了技能加成机制,这些也不需要了-------------------------------
    { "addmissilenum", { "<color=orange>%s<color>的数量：<color=gold>%s<color>", { "getskillname", 1 }, { "add1", 2 } } },
    { "addrestorelife", { "<color=orange>%s<color>的回血效果：<color=gold>%s%%<color>", { "getskillname", 1 }, { "add1", 2 } } },
    { "addmaxlife", { "<color=orange>%s<color>的生命上限：<color=gold>%s%%<color>", { "getskillname", 1 }, { "add1", 3 } } },
    { "addmaxmana", { "<color=orange>%s<color>的内力上限：<color=gold>%s%%<color>", { "getskillname", 1 }, { "add1", 3 } } },
    { "addmissilerange", { "<color=orange>%s<color>的效果范围：<color=gold>%s格<color>", { "getskillname", 1 }, { "add1", 2 } } },
    { "addmissilerange2", { "<color=orange>%s<color>的效果范围：<color=gold>%s格<color>", { "getskillname", 1 }, { "add1", 2 } } },
    { "addmissilerange3", { "<color=orange>%s<color>的效果范围：<color=gold>%s格<color>", { "getskillname", 1 }, { "add1", 2 } } },
    { "addmissilerange4", { "<color=orange>%s<color>的效果范围：<color=gold>%s格<color>", { "getskillname", 1 }, { "add1", 2 } } },
    { "addmissilerange5", { "<color=orange>%s<color>的效果范围：<color=gold>%s格<color>", { "getskillname", 1 }, { "add1", 2 } } },
    { "addmissilerange6", { "<color=orange>%s<color>的效果范围：<color=gold>%s格<color>", { "getskillname", 1 }, { "add1", 2 } } },
    { "addskillslowstaterate", { "<color=orange>%s<color>的迟缓几率：<color=gold>%s%%<color>", { "getskillname", 1 }, { "add1", 3 } } },
    { "addskillcastrange", { "<color=orange>%s<color>的施放距离：<color=gold>%s<color>", { "getskillname", 1 }, { "add1", 3 } } },
    { "addrunattackspeed", { "<color=orange>%s<color>的冲刺速度：<color=gold>%s<color>", { "getskillname", 1 }, { "add1", 3 } } },
    { "addmoveposdistance", { "<color=orange>%s<color>的瞬移距离：<color=gold>%s%%<color>", { "getskillname", 1 }, { "add1", 2 } } },
    { "addmissilespeed", { "<color=orange>%s<color>的飞行速度：<color=gold>%s<color>", { "getskillname", 1 }, { "add1", 3 } } },
    { "addignoreskillrate", { "<color=orange>%s<color>的完全闪避几率：<color=gold>%s%%<color>", { "getskillname", 1 }, { "add1", 3 } } },
    { "addmissilelifetime", { "<color=orange>%s<color>的持续时间：<color=gold>增加%s秒<color>", { "getskillname", 1 }, { "frame2sec", 3 } } },
    { "adddragspeed", { "<color=orange>%s<color>的拉人速度：<color=gold>%s<color>", { "getskillname", 1 }, { "add1", 3 } } },
    { "addmissilecolrange", { "<color=orange>%s<color>的碰撞范围：<color=gold>%s格<color>", { "getskillname", 1 }, { "add1", 2 } } },
    { "addmissiledamagerange", { "<color=orange>%s<color>的伤害范围：<color=gold>%s格<color>", { "getskillname", 1 }, { "add1", 2 } } },
    { "addskillhidetime", { "<color=orange>%s<color>的隐身持续时间：<color=gold>增加%s秒<color>", { "getskillname", 1 }, { "frame2sec", 2 } } },
    { "decreaseskillcasttime", { "<color=orange>%s<color>的释放间隔时间：<color=gold>减少%s秒<color>", { "getskillname", 1 }, { "frame2sec", 2 } } },
    --		{"addstartskill", {"<color=orange>%s<color>时发出：<color=gold>%s级<color><color=green>%s<color>", {"getskillname", 1},  3, {"getskillname", 2}}},
    {
      "addfastmanareplenish_v",
      { "使<color=orange>%s<color>让对手的每半秒内力回复：<color=gold>%s点<color>", { "getskillname", 1 }, { "add1", 2 } },
    },

    ---------------------确定无效的--------------------
    -- 增加受到伤害百分比
    { "damage_physics_receive_p", { "受到的普攻伤害：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "damage_poison_receive_p", { "受到的毒攻伤害：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "damage_cold_receive_p", { "受到的冰攻伤害：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "damage_fire_receive_p", { "受到的火攻伤害：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "damage_light_receive_p", { "受到的雷攻伤害：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "physicsresmax_p", { "普攻抗性最大值：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "coldresmax_p", { "冰攻抗性最大值：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "fireresmax_p", { "火攻抗性最大值：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "lightingresmax_p", { "雷攻抗性最大值：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "poisonresmax_p", { "毒攻抗性最大值：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "allresmax_p", { "所有抗性最大值：<color=gold>%s%%<color>", { "add1", 1 } } },

    ---------------------可能无效的--------------------
    { "knockback_p", { "攻击震退对手几率：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "drag_p", { "攻击拉回对手几率：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "stun_p", { "攻击致昏对手几率：<color=gold>%s%%<color>", { "add1", 1 } } },

    { "poisonres_p", { "毒防：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "fireres_p", { "火防：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "lightingres_p", { "雷防：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "physicsres_p", { "普防：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "coldres_p", { "冰防：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "freezetimereduce_p", { "迟缓时间：<color=gold>%s%%<color>", { "add2", 1 } } },
    { "poisontimereduce_p", { "中毒时间：<color=gold>%s%%<color>", { "add2", 1 } } },
    { "poisontimeenhance_p", { "毒持续时间：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "poisondamagereduce_v", { "毒伤害：<color=gold>%s<color>", { "add2", 1 } } },
    { "stuntimereduce_p", { "眩晕时间：<color=gold>%s%%<color>", { "add2", 1 } } },

    { "fasthitrecover_v", { "受伤动作时间：<color=gold>%s<color>", { "add2", 1 } } },
    { "allres_p", { "所有抗性：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "slowmissile_b", { "减缓气功飞行速度" } },
    { "changecamp_b", { "迷惑对手" } },
    { "physicsarmor_v", { "物理护甲：<color=gold>%s点<color>", { "add1", 1 } } },
    { "coldarmor_v", { "冰护甲：<color=gold>%s点<color>", { "add1", 1 } } },
    { "firearmor_v", { "火护甲：<color=gold>%s点<color>", { "add1", 1 } } },
    { "poisonarmor_v", { "毒护甲：<color=gold>%s点<color>", { "add1", 1 } } },
    { "lightingarmor_v", { "电护甲：<color=gold>%s点<color>", { "add1", 1 } } },
    { "lucky_v_partner", { "幸运值：<color=gold>%s点<color>", { "add1", 1 } } },
    {
      "skilllevel_added",
      function(tbMagic, tbSkillInfo, tbMagic2, bEx2)
        if tbMagic[1] == 0 then
          return ""
        end
        if me.nRouteId == 0 then
          return string.format("门派<color=gold>%s<color>技能：增加1级", tbParamToLevel[tbMagic[1]])
        else
          return string.format("%s：<color=gold>%s级<color>", GetSkillNameByParam(tbMagic[1]), Add1(tbMagic[2], tbMagic2 and tbMagic2[2], bEx2))
        end
      end,
    },
    { "metalskill_v", { "金系武功等级：<color=gold>%s级<color>", { "add1", 1 } } },
    { "woodskill_v", { "木系武功等级：<color=gold>%s级<color>", { "add1", 1 } } },
    { "waterskill_v", { "水系武功等级：<color=gold>%s级<color>", { "add1", 1 } } },
    { "fireskill_v", { "火系武功等级：<color=gold>%s级<color>", { "add1", 1 } } },
    { "earthskill_v", { "土系武功等级：<color=gold>%s级<color>", { "add1", 1 } } },
    { "knockback_p", { "攻击震退对手几率：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "drag_p", { "攻击拉回对手几率：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "badstatustimereduce_v", { "不良状态持续时间：<color=gold>%s秒<color>", { "add2", 1 } } },
    { "coldenhance_p", { "迟缓时间：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "fireenhance_p", { "火伤害上限：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "lightingenhance_p", { "雷伤害下限：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "poisonenhance_p", { "毒发间隔的时间：<color=gold>%s%%<color>", { "add2", 1 } } },
    { "knockbackenhance_p", { "命中对手震退对方的几率：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "dragenhance_p", { "命中对手拉回对方的几率：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "stunenhance_p", { "命中对手致晕对方的几率：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "fatallystrikeenhance_p", { "攻击致命一击率：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "magicenhance_p", { "五行伤害：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "fatallystrikeres_p", { "致命一击抵抗力：<color=gold>%s%%<color>", { "add1", 1 } } },
    { "addstealfeatureskill", { "伪装技能剩余使用次数：<color=gold>%s次<color>", 1 } },
    { "clearnegativestate", { "以<color=gold>%s%%<color>的几率清除周围一定范围内友方玩家的异常状态", 1 } },
    { "prop_ignoretrap", { "有%s%%的几率不触发陷阱", 1 } },
    { "prop_evadeattack", { "有%s%%的几率完全闪避任何攻击和负面技能", 1 } },
    {
      "infectcurse",
      function(tbMagic, tbSkillInfo, tbMagic2, bEx2)
        return string.format("以<color=gold>%d%%<color>的几率将自身的<color=gold>%s个<color>诅咒传染给附近对手\n每次传染最多影响<color=gold>%d个<color>目标", KFightSkill.GetMissileRate(tbSkillInfo.nId, tbSkillInfo.nLevel), Add4(tbMagic[1], tbMagic2 and tbMagic2[1], bEx2), tbSkillInfo.tbWholeMagic["missile_hitcount"][1])
      end,
    },
  },
}

FightSkill.tbStr2Fun = {
  ["add1"] = Add1,
  ["add2"] = Add2,
  ["add3"] = Add3,
  ["add4"] = Add4,
  ["add5"] = Add5,
  ["add6"] = Add6,
  ["frame2sec"] = Frame2Sec,
  ["frame2sec2"] = Frame2Sec2,
  ["castskill"] = CastSkill,
  ["getskillname"] = GetSkillName,
  ["frame2times"] = Frame2Times,
  ["enchanttype"] = EnchantType,
  ["enchanttypev"] = EnchantTypeV,
  ["enchanttypep"] = EnchantTypeP,
  ["v2p"] = v2p,
}

function FightSkill:ParingDesc(tbParams, tbMagicData)
  local strDescSrc = tbParams[1]
  local strResult = ""
  local strNow = strDescSrc
  local strTrans = { strDescSrc }
  local nCount = 1
  local nFindCur = 0
  while true do
    nFindCur = string.find(strDescSrc, "%%s", nFindCur + 1)
    if not nFindCur then
      break
    end

    nCount = nCount + 1
    strTrans[nCount] = ""
    if type(tbParams[nCount]) == "table" then
      local funPas = {}
      for i = 1, #tbParams[nCount] - 1 do
        funPas[i] = tbMagicData[tbParams[nCount][i + 1]]
      end
      if #funPas < 1 then
        return ""
      end

      if type(tbParams[nCount][1]) == "string" then
        if type(self.tbStr2Fun[tbParams[nCount][1]]) == "function" then
          strTrans[nCount] = self.tbStr2Fun[tbParams[nCount][1]](unpack(funPas))
          --print(nCount, strTrans[nCount]);
        else
          print("FightSkill:ParingDesc can not find func", tbParams[nCount][1])
        end
      elseif type(tbParams[nCount][1]) == "table" then
        strTrans[nCount] = tbParams[nCount][1][funPas[1]] or tostring(funPas[1])
      end
    else
      if type(tbMagicData[tbParams[nCount]]) == "table" then
        strTrans[nCount] = tbMagicData[tbParams[nCount]].nPoint
      else
        strTrans[nCount] = tbMagicData[tbParams[nCount]]
      end
    end
  end

  if not strTrans then
    print("FightSkill:ParingDesc strTrans is nill")
    return "null"
  end
  return string.format(unpack(strTrans))
end

function FightSkill:GetMagicDesc(szMagicName, tbMagicData, tbSkillInfo, bNoColor, bEnchantMagic, nMode)
  local szMsg = ""
  local nGroupId = 0
  local szDesc = ""
  local varMagicDesc, nNum
  if bEnchantMagic and bEnchantMagic == true then
    varMagicDesc, nGroupId, nNum = self:GetEnchantMaigcDesc(szMagicName, nMode)
  else
    varMagicDesc, nGroupId, nNum = self:GetOriginalMagicDesc(szMagicName, nMode)
  end
  if (not varMagicDesc) and (szMagicName ~= "") then
    print(string.format("magic[%s] not found!", tostring(szMagicName)))
    return ""
  end

  if type(varMagicDesc) == "table" then
    local tbParams = { varMagicDesc[1] }
    for i = 2, #varMagicDesc do
      tbParams[i] = varMagicDesc[i]
    end
    szDesc = self:ParingDesc(tbParams, tbMagicData, tbSkillInfo)
  elseif type(varMagicDesc) == "function" then
    szDesc = varMagicDesc(tbMagicData, tbSkillInfo)
  elseif type(varMagicDesc) == "string" then
    szDesc = "" .. varMagicDesc
  end
  if szDesc and szDesc ~= "" then
    szMsg = szMsg .. szDesc
    --szMsg = szMsg.."["..nGroupId.."."..nNum.."]"..szDesc;
  end

  if 1 ~= bNoColor then
    return szMsg, nGroupId, nNum
  end
  return string.gsub(szMsg, "<color([^>]*)>", ""), nGroupId, nNum
end

-- nMode为1时表示取详细模式，nMode为0时取简略模式，默认是详细模式
function FightSkill:GetOriginalMagicDesc(szDescMagicName, nMode)
  nMode = nMode or 1
  local nGroupId, nNum = 0, 0
  for nGroupId, tbMagicGroup in ipairs(FightSkill.MAGIC_DESCS) do
    if type(tbMagicGroup) == "table" then
      for nNum, tbMagicDesc in pairs(tbMagicGroup) do
        local szMagicName = tbMagicDesc[1]
        local MagicDesc = tbMagicDesc[2]
        if nMode == 0 and tbMagicDesc[3] then
          MagicDesc = tbMagicDesc[3]
        end

        if szMagicName == szDescMagicName then
          return MagicDesc, nGroupId, nNum
        end
      end
    end
  end
end

function FightSkill:GetEnchantMaigcDesc(szDescMagicName)
  local tbDesc = ""
  local nGroupId, nNum = 0, 0
  for nGroupId, tbMagicGroup in ipairs(FightSkill.ENCHANT_DESCS) do
    if type(tbMagicGroup) == "table" then
      for nNum, tbMagicDesc in pairs(tbMagicGroup) do
        local szMagicName = tbMagicDesc[1]
        local MagicDesc = tbMagicDesc[2]
        if szMagicName == szDescMagicName then
          tbDesc = MagicDesc
          return MagicDesc, nGroupId, nNum
        end
      end
    end
  end
  return tbDesc, nGroupId, nNum
end

function FightSkill:GetExtentMagicDesc(szMagicName, tbMagicDataLow, tbMagicDataHigh, bEx2)
  local varMagicDesc = self:GetOriginalMagicDesc(szMagicName)
  local szDesc = ""

  if (not varMagicDesc) and (szMagicName ~= "") then
    print(string.format("magic[%s] not found!", tostring(szMagicName)))
    return ""
  end

  if type(varMagicDesc) == "table" then
    local tbParams = { varMagicDesc[1] }
    for i = 2, #varMagicDesc do
      tbParams[i] = varMagicDesc[i]
    end
    szDesc = self:ParingExtentDesc(tbParams, tbMagicDataLow, tbMagicDataHigh, bEx2)
  elseif type(varMagicDesc) == "function" then
    -- TODO: liuchang 还没完
    szDesc = varMagicDesc(tbMagicDataLow, tbSkillInfo, tbMagicDataHigh, bEx2)
  elseif type(varMagicDesc) == "string" then
    szDesc = "" .. varMagicDesc
  end

  if bEx2 == 1 then
    szDesc = string.gsub(szDesc, "<color([^>]*)>", "")
    szDesc = string.gsub(szDesc, "→", "<color=gold>→<color>")
  end

  return szDesc
end

function FightSkill:ParingExtentDesc(tbParams, tbMagicDataLow, tbMagicDataHigh, bEx2)
  local strDescSrc = tbParams[1]
  local strResult = ""
  local strNow = strDescSrc
  local strTrans = { strDescSrc }
  local nCount = 1
  local nFindCur = 0

  while true do
    nFindCur = string.find(strDescSrc, "%%s", nFindCur + 1)
    if not nFindCur then
      break
    end

    nCount = nCount + 1
    strTrans[nCount] = ""

    if type(tbParams[nCount]) == "table" then
      local funPasLow = {}
      local funPasUp = {}

      for i = 1, #tbParams[nCount] - 1 do
        funPasLow[i] = tbMagicDataLow[tbParams[nCount][i + 1]]
        funPasUp[i] = tbMagicDataHigh[tbParams[nCount][i + 1]]
      end

      if type(tbParams[nCount][1]) == "string" then
        if type(self.tbStr2Fun[tbParams[nCount][1]]) == "function" then
          strTrans[nCount] = self.tbStr2Fun[tbParams[nCount][1]](unpack(funPasLow), unpack(funPasUp), bEx2)
        else
          print("FightSkill:ParingDesc can not find func", tbParams[nCount][1])
        end
      end
    end
  end

  if not strTrans then
    print("FightSkill:ParingDesc strTrans is nill")
    return "null"
  end

  return string.format(unpack(strTrans))
end
