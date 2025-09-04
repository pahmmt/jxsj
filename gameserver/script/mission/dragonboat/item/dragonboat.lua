-- 文件名　：dragonboat.lua
-- 创建者　：sunduoliang
-- 创建时间：2009-05-04 14:49:00
-- 描  述  ：龙舟

local tbItem = Item:GetClass("dragonboat")
local GEN_WEAR = 1
local GEN_SKILL_ATTACK1 = 2
local GEN_SKILL_ATTACK2 = 3
local GEN_SKILL_DEFEND1 = 4

function tbItem:OnUse()
  if it.nLevel < 5 then
    local tbOpt = {
      { "确认", NewEPlatForm.ItemChangeOther, NewEPlatForm, it },
      { "我再想想" },
    }
    Dialog:Say(string.format("道具<color=yellow>%s<color>为家族竞技道具，现在开放新家族趣味竞技，道具可以兑换为新属性道具，您确定兑换吗？", it.szName), tbOpt)
    return
  elseif it.nLevel >= 5 then
    local tbOpt = {
      { "改造", Npc:GetClass("dragonboat_signup").ProductBoat, Npc:GetClass("dragonboat_signup") },
      { "兑换为别的道具", NewEPlatForm.ItemChange, NewEPlatForm, it },
      { "我再想想" },
    }
    local nRet, szString = NewEPlatForm:CheckCanUpdate(it)
    if nRet == 1 then
      table.insert(tbOpt, 3, { "升级道具<item=" .. szString .. ">", NewEPlatForm.ItemUpdate, NewEPlatForm, it })
    end
    Dialog:Say(string.format("道具<color=yellow>%s<color>可进行下列操作，请问您需要什么操作？", it.szName), tbOpt)
    return
  end
end

function tbItem:GetGenId(nSel, pItem)
  if not pItem then
    return 0
  end
  local tbProp = Esport.DragonBoat.PRODUCT_BOAT[pItem.nLevel]

  local tbSkillAttack = {}
  for _, nGenId in ipairs(Esport.DragonBoat.GEN_SKILL_ATTACK) do
    table.insert(tbSkillAttack, { nGenId, pItem.GetGenInfo(nGenId, 0) })
  end

  local tbSkillDefend = {}
  for _, nGenId in ipairs(Esport.DragonBoat.GEN_SKILL_DEFEND) do
    table.insert(tbSkillDefend, { nGenId, pItem.GetGenInfo(nGenId, 0) })
  end

  if nSel == 1 then
    for i = 1, tbProp[2] do
      if tbSkillAttack[i] and tbSkillAttack[i][2] <= 0 then
        return tbSkillAttack[i][1]
      end
    end
  elseif nSel == 2 then
    for i = 1, tbProp[3] do
      if tbSkillDefend[i] and tbSkillDefend[i][2] <= 0 then
        return tbSkillDefend[i][1]
      end
    end
  end
  return 0
end

function tbItem:GetTip()
  local szTip = ""
  local tbProp = Esport.DragonBoat.PRODUCT_BOAT[it.nLevel]
  local nWear = tbProp[1] - it.GetGenInfo(Esport.DragonBoat.GEN_WEAR, 0)
  local szWear = string.format("耐久度：%s", nWear)
  if nWear >= 10 then
    szWear = string.format("\n<color=green>%s<color>", szWear)
  elseif nWear >= 5 then
    szWear = string.format("\n%s", szWear)
  else
    szWear = string.format("\n<color=red>%s<color>", szWear)
  end

  szTip = szTip .. szWear
  szTip = szTip .. self:GetSkillTip(it)
  return szTip
end

function tbItem:GetSkillTip(pItem)
  local tbProp = Esport.DragonBoat.PRODUCT_BOAT[pItem.nLevel]
  local nWear = tbProp[1] - pItem.GetGenInfo(Esport.DragonBoat.GEN_WEAR, 0)

  local tbSkillAttack = {}
  for _, nGenId in ipairs(Esport.DragonBoat.GEN_SKILL_ATTACK) do
    table.insert(tbSkillAttack, pItem.GetGenInfo(nGenId, 0))
  end

  local tbSkillDefend = {}
  for _, nGenId in ipairs(Esport.DragonBoat.GEN_SKILL_DEFEND) do
    table.insert(tbSkillDefend, pItem.GetGenInfo(nGenId, 0))
  end
  local szTip = ""
  for i = 1, tbProp[2], 1 do
    if tbSkillAttack[i] > 0 then
      szTip = szTip .. string.format("\n<color=green>攻击性改造：%s<color>", KFightSkill.GetSkillName(tbSkillAttack[i]))
    else
      szTip = szTip .. string.format("\n<color=gray>攻击性改造：未改造<color>")
    end
  end

  for i = 1, tbProp[3], 1 do
    if tbSkillDefend[i] > 0 then
      szTip = szTip .. string.format("\n<color=green>防御性改造：%s<color>", KFightSkill.GetSkillName(tbSkillDefend[i]))
    else
      szTip = szTip .. string.format("\n<color=gray>防御性改造：未改造<color>")
    end
  end
  return szTip
end

-- 用于竞技平台活动的物品检查函数，不同的活动类型，不同的物品可能需要不同的检查机制
function tbItem:ItemCheckFun(pItem)
  if not pItem then
    return 0, "龙舟物品不存在。"
  end
  local nUseBoat = 0
  local nGenId1 = self:GetGenId(1, pItem)
  local nGenId2 = self:GetGenId(2, pItem)
  if nGenId1 <= 0 and nGenId2 <= 0 then
    nUseBoat = 1
  end
  if nUseBoat == 0 then
    return 0, "额，你的龙舟还没改造过啊，拿来参加比赛很吃亏的。先改造一下再来参赛吧。"
  end
  return 1
end
