-- 文件名　：dragonboat.lua
-- 创建者　：sunduoliang
-- 创建时间：2009-05-04 14:49:00
-- 描  述  ：先祖庇护符

local tbItem = Item:GetClass("td_fuzou")
local GEN_WEAR = 1
local GEN_SKILL_ATTACK1 = 2
local GEN_SKILL_ATTACK2 = 3
tbItem.ITEM_BOAT_ID = { 18, 1, 638 }
tbItem.PRODUCT_SKILL = {

  --攻击性
  [1] = {
    --技能Id，名称，描述，改造等级,需要绑定银两
    { 1611, "定", "使目标定身3秒，定点攻击。", { [1] = 1, [2] = 1, [3] = 1, [4] = 1 }, 15000 },
    { 1612, "退", "使目标击退距离，定点攻击。", { [1] = 1, [2] = 1, [3] = 1, [4] = 1 }, 15000 },
    { 1613, "缓", "使目标迟缓5秒，定点攻击。", { [1] = 1, [2] = 1, [3] = 1, [4] = 1 }, 15000 },
    { 1614, "乱", "使目标混乱2秒，定点攻击。", { [1] = 1, [2] = 1, [3] = 1, [4] = 1 }, 15000 },
    { 1615, "晕", "使目标眩晕2秒，定点攻击。", { [1] = 1, [2] = 1, [3] = 1, [4] = 1 }, 15000 },
  },
}

tbItem.PRODUCT_BOAT = {
  --耐久，攻击改造，防御改造，是否可重造
  [1] = { 10, 1, 0, { 1383, 1 } }, --1级,15耐久，2次攻击性改造，0次防御行改造，变身技能
  [2] = { 10, 2, 0, { 1383, 2 } }, --2级,15耐久，1次攻击性改造，1次防御行改造，变身技能
  [3] = { 10, 1, 0, { 1383, 1 } }, --1级,15耐久，2次攻击性改造，0次防御行改造，变身技能
  [4] = { 10, 2, 0, { 1383, 2 } }, --2级,15耐久，1次攻击性改造，1次防御行改造，变身技能
}

tbItem.GEN_WEAR = 1
tbItem.GEN_SKILL_ATTACK = { 2, 3 }

function tbItem:OnUse()
  if it.nLevel < 3 then
    local tbOpt = {
      { "确认", NewEPlatForm.ItemChangeOther, NewEPlatForm, it },
      { "我再想想" },
    }
    Dialog:Say(string.format("道具<color=yellow>%s<color>为家族竞技道具，现在开放新家族趣味竞技，道具可以兑换为新属性道具，您确定兑换吗？", it.szName), tbOpt)
    return
  elseif it.nLevel >= 3 then
    local tbOpt = {
      { "改造", TowerDefence.Npc_ProductTD, TowerDefence },
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
  local tbProp = self.PRODUCT_BOAT[pItem.nLevel]

  local tbSkillAttack = {}
  for _, nGenId in ipairs(Esport.DragonBoat.GEN_SKILL_ATTACK) do
    table.insert(tbSkillAttack, { nGenId, pItem.GetGenInfo(nGenId, 0) })
  end

  if nSel == 1 then
    for i = 1, tbProp[2] do
      if tbSkillAttack[i] and tbSkillAttack[i][2] <= 0 then
        return tbSkillAttack[i][1]
      end
    end
  end
  return 0
end

function tbItem:GetTip()
  local szTip = ""
  local tbProp = self.PRODUCT_BOAT[it.nLevel]
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
  local tbProp = self.PRODUCT_BOAT[pItem.nLevel]
  local nWear = tbProp[1] - pItem.GetGenInfo(self.GEN_WEAR, 0)

  local tbSkillAttack = {}
  for _, nGenId in ipairs(self.GEN_SKILL_ATTACK) do
    table.insert(tbSkillAttack, pItem.GetGenInfo(nGenId, 0))
  end

  local szTip = ""
  for i = 1, tbProp[2], 1 do
    if tbSkillAttack[i] > 0 then
      szTip = szTip .. string.format("\n<color=green>攻击性改造：%s<color>", KFightSkill.GetSkillName(tbSkillAttack[i]))
    else
      szTip = szTip .. string.format("\n<color=gray>攻击性改造：未改造<color>")
    end
  end

  return szTip
end

function tbItem:CheckSkill(pItem, nSkillId)
  for _, nGenId in pairs(self.GEN_SKILL_ATTACK) do
    if pItem.GetGenInfo(nGenId, 0) == nSkillId then
      return 1
    end
  end
  return 0
end

-- 用于竞技平台活动的物品检查函数，不同的活动类型，不同的物品可能需要不同的检查机制
function tbItem:ItemCheckFun(pItem)
  if not pItem then
    return 0, "守护灵主之魂物品不存在。"
  end
  local nUseBoat = 0
  local nGenId1 = self:GetGenId(1, pItem)
  local nGenId2 = self:GetGenId(2, pItem)
  if nGenId1 <= 0 and nGenId2 <= 0 then
    nUseBoat = 1
  end
  if nUseBoat == 0 then
    return 0, "额，你的先祖庇护符还没改造过啊，拿来参加比赛很吃亏的。先改造一下再来参赛吧。"
  end
  return 1
end

--改造
function tbItem:OpenProduct(nType)
  Dialog:OpenGift("放入需要改造的先祖庇护符", nil, { self.OnProduct, self, nType })
end

function tbItem:OnProduct(nType, tbItem)
  if #tbItem <= 0 or #tbItem >= 2 then
    Dialog:Say("请放入需要改造的先祖庇护符，只需要给我一个先祖庇护符。")
    return 0
  end
  local pItem = tbItem[1][1]
  local szKey = string.format("%s,%s,%s", pItem.nGenre, pItem.nDetail, pItem.nParticular)
  if szKey ~= string.format("%s,%s,%s", unpack(self.ITEM_BOAT_ID)) then
    Dialog:Say("请放入需要改造的先祖庇护符，你放入的不是先祖庇护符。")
    return 0
  end
  local nGenId1 = self:GetGenId(nType, pItem)
  if nGenId1 <= 0 then
    Dialog:Say("你的先祖庇护符性能已改造完成了，不能再进行改造。")
    return 0
  end
  self:OnProduct1(nType, pItem.dwId)
  return 0
end

function tbItem:OnProduct1(nSel, nItemId)
  local pItem = KItem.GetObjById(nItemId)
  if not pItem then
    return 0
  end
  local nGenId = self:GetGenId(nSel, pItem)
  if nGenId <= 0 then
    Dialog:Say("你的先祖庇护符本类型技能改造已完成，不能再进行改造。", { { "返回上层", self.OnProductSel, self, nItemId }, { "结束对话" } })
    return 0
  end

  local tbOpt = {}
  for nSelSkill, tbSkill in pairs(self.PRODUCT_SKILL[nSel]) do
    if tbSkill[4][pItem.nLevel] then
      local szSelect = "改造-" .. tbSkill[2]
      if self:CheckSkill(pItem, tbSkill[1]) > 0 then
        szSelect = string.format("<color=green>%s<color>", szSelect)
      end
      table.insert(tbOpt, { szSelect, self.OnProduct2, self, nSel, nSelSkill, nItemId })
    end
  end
  --table.insert(tbOpt, {"返回上层", self.OnProduct1, self, nSel, nItemId});
  table.insert(tbOpt, { "结束对话" })
  Dialog:Say("你需要进行哪项改造呢？改造需要花费少许银两哦，希望你带钱来了，呵呵~~", tbOpt)
end

function tbItem:OnProduct2(nSel, nSelSkill, nItemId)
  local pItem = KItem.GetObjById(nItemId)
  if not pItem then
    return 0
  end
  local nSkillId = self.PRODUCT_SKILL[nSel][nSelSkill][1]
  local szSkillName = self.PRODUCT_SKILL[nSel][nSelSkill][2]
  local szSkillDesc = self.PRODUCT_SKILL[nSel][nSelSkill][3]
  local nNeedBindMoney = self.PRODUCT_SKILL[nSel][nSelSkill][5]

  if self:CheckSkill(pItem, nSkillId) > 0 then
    Dialog:Say("你的先祖庇护符已经改造了这个技能,不能同时改造同一技能", { { "继续改造这个先祖庇护符", self.OnProduct1, self, nSel, nItemId }, { "结束对话" } })
    return 0
  end

  local szMsg = string.format("你选择的技能是：<color=yellow>%s<color>\n\n技能效果：<color=yellow>%s<color>\n\n改造费用：<color=yellow>%s绑定银两<color>", szSkillName, szSkillDesc, nNeedBindMoney)
  local tbOpt = {
    { "我要进行改造", self.OnProduct3, self, nSel, nSelSkill, nItemId },
    { "返回上层", self.OnProduct1, self, nSel, nItemId },
    { "我再考虑考虑" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbItem:OnProduct3(nSel, nSelSkill, nItemId)
  local pItem = KItem.GetObjById(nItemId)
  if not pItem then
    return 0
  end
  local nSkillId = self.PRODUCT_SKILL[nSel][nSelSkill][1]
  local nNeedBindMoney = self.PRODUCT_SKILL[nSel][nSelSkill][5]
  if me.GetBindMoney() < nNeedBindMoney then
    Dialog:Say(string.format("改造这个技能需要<color=yellow>%s绑定银两<color>，你的绑定银两不足，无法改造。", nNeedBindMoney))
    return 0
  end

  me.CostBindMoney(nNeedBindMoney, Player.emKBINDMONEY_COST_EVENT)

  local nGenId = self:GetGenId(nSel, pItem)
  if nGenId <= 0 then
    return 0
  end

  pItem.SetGenInfo(nGenId, nSkillId)
  if pItem.IsBind() ~= 1 then
    pItem.Bind(1)
  end
  pItem.Sync()
  Dialog:Say("你成功改造了这个先祖庇护符。")
end
