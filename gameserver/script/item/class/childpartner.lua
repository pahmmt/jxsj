------------------------------------------------------
-- 文件名　：childpartner.lua
-- 创建者　：dengyong
-- 创建时间：2010-01-06 10:31:19
-- 描  述  ：稚嫩的同伴 道具
------------------------------------------------------

-- 生成信息：
-- 1号：	同伴的模板ID（不是NPC的模板ID）
-- 2号：	同伴的名字
-- 3-7号：	同伴的技能，每个值的高16位和低16位各存一个技能ID，由于同伴最多有10个技能，所以预留5位存技能信息。

local tbItem = Item:GetClass("childpartner")

tbItem.GENINFO_TEMPID = 1
tbItem.GENINFO_POTENTIAL = 2
tbItem.GENINFO_SKILL_MIN = 3
tbItem.GENINFO_SKILL_MAX = 7
tbItem.GENINFO_MAKERID = 12

function tbItem:GetTip(nTipState)
  local nPartnerTempId, nPotentialTemp, tbSkillId = self:ParseGenInfo()

  local szName = KNpc.GetNameByTemplateId(Partner.tbPartnerAttrib[nPartnerTempId].nEffectNpcId)
  local szTip = string.format("稚嫩的同伴 <color=yellow>%s<color>（%d个技能）\n", szName, #tbSkillId)

  -- 乘以10转化成百分比的格式
  local szStrength = tostring(Partner.tbPotentialTemp[nPotentialTemp].nStrength * 10) -- 力量
  local szVitality = tostring(Partner.tbPotentialTemp[nPotentialTemp].nVitality * 10) -- 外功
  local szDexterity = tostring(Partner.tbPotentialTemp[nPotentialTemp].nDexterity * 10) -- 身法
  local szEnergy = tostring(Partner.tbPotentialTemp[nPotentialTemp].nEnergy * 10) -- 内功

  szTip = szTip .. Lib:StrFillL("力量：" .. szStrength .. "%", 15)
  szTip = szTip .. Lib:StrFillL("外功：" .. szVitality .. "%", 15) .. "\n"
  szTip = szTip .. Lib:StrFillL("身法：" .. szDexterity .. "%", 15)
  szTip = szTip .. Lib:StrFillL("内功：" .. szEnergy .. "%", 15) .. "\n\n"

  szTip = szTip .. "同伴技能：\n"
  for i = 1, #tbSkillId do
    if Partner.tbPartnerSkillTip[tbSkillId[i]] then
      szTip = szTip .. "<color=green>" .. Partner.tbPartnerSkillTip[tbSkillId[i]].szName .. "<color>："
      szTip = szTip .. "<color=yellow>" .. Partner.tbPartnerSkillTip[tbSkillId[i]].szDesc .. "<color>\n"
    end
  end

  return szTip
end

function tbItem:GetTitle(nTipState)
  local szTip = string.format("<color=0x%x>", it.nNameColor)
  szTip = szTip .. it.szName
  return szTip .. "<color>\n"
end

function tbItem:OnUse()
  if Partner.bOpenPartner ~= 1 then
    Dialog:Say("现在同伴活动已经关闭，无法使用物品")
    return 0
  end

  if me.nLevel < Partner.PERSUADELEVELLIMIT then
    Dialog:Say("您的等级未到100，不能获得同伴！")
    --Partner:SendClientMsg("您的等级未到100，不能获得同伴！");
    return 0
  end

  if me.nFaction == 0 then
    Dialog:Say("您没有加入门派，不能获得同伴！")
    --Partner:SendClientMsg("您没有加入门派，不能获得同伴！");
    return 0
  end

  if me.nPartnerCount == me.nPartnerLimit then
    Dialog:Say("您的同伴列表已满，不能获得新同伴！")
    --Partner:SendClientMsg("您的同伴列表已满，不能获得新同伴！");
    return 0
  end

  local szMsg = "使用稚嫩的同伴后你会获得该同伴，确定使用吗？"
  local tbOpt = {
    { "确定", self.AddPartnerByItem, self, it.dwId },
    { "我再看看" },
  }

  Dialog:Say(szMsg, tbOpt)
  return 0
end

function tbItem:AddPartnerByItem(dwId)
  local pItem = KItem.GetObjById(dwId)
  if not pItem then
    return
  end

  local nPartnerTempId, nPotentialTemp, tbSkillId = self:ParseGenInfo(pItem)
  if Partner:TurnItemToPartner(me, nPartnerTempId, nPotentialTemp, tbSkillId) ~= 1 then
    return 0
  end

  local szName = pItem.szName
  if me.DelItem(pItem) == 1 then
    Dbg:WriteLog("同伴Log:", string.format("%s使用%s获得一个新同伴", me.szName, szName))
  end

  return 1
end

-- 解析道具稚嫩的同伴的生成信息，获取同伴的属性
function tbItem:ParseGenInfo(pItem)
  pItem = pItem or it
  if not pItem then
    return
  end

  -- 先解析道具中同伴的属性信息
  local nParnterTempId = pItem.GetGenInfo(self.GENINFO_TEMPID)
  local nPotentialTemp = pItem.GetGenInfo(self.GENINFO_POTENTIAL)
  local tbSkillId = {} -- 存放同伴的技能ID
  for i = self.GENINFO_SKILL_MIN, self.GENINFO_SKILL_MAX do
    local nSkillId1 = Lib:LoadBits(pItem.GetGenInfo(i), 0, 15)
    local nSkillId2 = Lib:LoadBits(pItem.GetGenInfo(i), 16, 31)
    if nSkillId1 == 0 then
      break
    end
    table.insert(tbSkillId, nSkillId1)
    if nSkillId2 == 0 then
      break
    end
    table.insert(tbSkillId, nSkillId2)
  end

  return nParnterTempId, nPotentialTemp, tbSkillId
end
