-- 阵法，通用功能脚本

Require("\\script\\item\\class\\equip.lua")

------------------------------------------------------------------------------------------
-- initialize

local tbBook = Item:NewClass("zhen", "equip")

------------------------------------------------------------------------------------------
-- public

function tbBook:GetTip(nState) -- 获取秘籍Tip
  local szTip = ""
  local nId = it.GetExtParam(1)

  szTip = szTip .. self:Tip_ReqAttrib()
  szTip = szTip .. self:Tip_BaseAttrib(nState)

  -- 属性信息
  local nNearSkillId, nMapSkillId, nMaxLevel = GetZhenSkillInfo(nId)

  if nNearSkillId <= 0 then
    return szTip
  end

  --	szTip = szTip.."<color=greenyellow>";
  local szMsg = "\n<color=cyan>1级<color>\n"
  if nMapSkillId > 0 then
    szMsg = szMsg .. "<color=green>全地图效果<color>\n"
    szMsg = szMsg .. self:GetZhenFaSkillInfo(nMapSkillId, 1)
    szMsg = szMsg .. "\n"
  end
  if nNearSkillId > 0 then
    szMsg = szMsg .. "<color=green>近距离额外效果<color>\n"
    szMsg = szMsg .. self:GetZhenFaSkillInfo(nNearSkillId, 1)
    szMsg = szMsg .. "\n"
  end

  szMsg = szMsg .. string.format("\n<color=cyan>%s级<color>[<color=red>最高级<color>]\n", nMaxLevel)
  if nMapSkillId > 0 then
    szMsg = szMsg .. "<color=green>全地图效果<color>\n"
    szMsg = szMsg .. self:GetZhenFaSkillInfo(nMapSkillId, nMaxLevel)
    szMsg = szMsg .. "\n"
  end
  if nNearSkillId > 0 then
    szMsg = szMsg .. "<color=green>近距离额外效果<color>\n"
    szMsg = szMsg .. self:GetZhenFaSkillInfo(nNearSkillId, nMaxLevel)
    szMsg = szMsg .. "\n"
  end

  --szMsg = string.gsub(szMsg, "持续时间：%a*%d*%d*秒", "");
  szMsg = string.gsub(szMsg, "<color=white>持续时间：<color><color=gold>%d*秒<color>\n", "") --以后的技能tips中的持续时间格式
  szMsg = string.gsub(szMsg, "持续时间：<color=gold>%d*秒<color>\n", "") --现在的技能tips中的持续时间格式
  szTip = szTip .. szMsg
  return szTip
end

function tbBook:GetZhenFaSkillInfo(nSkillId, nLevel)
  local tbInfo = nil

  if nLevel > 0 then
    tbInfo = KFightSkill.GetSkillInfo(nSkillId, nLevel)
  else
    nLevel = 0
  end

  if not tbInfo then
    return
  end

  local szClassName = tbInfo.szClassName
  local tbSkill = assert(FightSkill.tbClass[szClassName], "Skill{" .. szClassName .. "} not found!")
  local tbMsg = {}
  tbSkill:GetDescAboutLevel(tbMsg, tbInfo)
  return table.concat(tbMsg, "\n")
end

function tbBook:CalcValueInfo()
  local nValue = it.nOrgValue
  local nStarLevel, szNameColor, szTransIcon = Item:CalcStarLevelInfo(it.nVersion, it.nDetail, it.nLevel, nValue)
  return nValue, nStarLevel, szNameColor, szTransIcon
end
