-------------------------------------------------------
-- 文件名　：atlantis_npc_city.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2011-03-15 16:35:12
-- 文件描述：
-------------------------------------------------------

if not MODULE_GAMESERVER then
  return
end

Require("\\script\\boss\\atlantis\\atlantis_def.lua")

local tbNpc = Npc:GetClass("atlantis_npc_city")

function tbNpc:OnDialog()
  local szMsg = "    嘿，这位大侠，你有没有听说过此处往西的那片神秘荒漠中有关<color=yellow>楼兰古城<color>的传说？自从一品堂的那些小喽罗们去了之后，现在失踪这么多天了依旧尸骨未寻。我可不愿意背上把他们引向死路的骂名呀……你愿意去帮我探寻那片神秘的土地，看看能给我带回来些好玩的东西么？"
  local tbOpt = {
    { "<color=yellow>前往楼兰古城<color>", Atlantis.PlayerEnter, Atlantis },
    { "<color=yellow>兑换楼兰珍宝<color>", self.OnChangeChip, self },
    { "<color=yellow>兑换同伴装备<color>", self.OnChangeEquip, self },
    { "<color=yellow>楼兰装备兑换珍宝<color>", self.OnChangeBack, self },
    { "我知道了" },
  }
  Dialog:Say(szMsg, tbOpt)
end

-- 兑换同伴碎片
function tbNpc:OnChangeChip()
  local tbOpt = {}
  local szMsg = "    你将在古城里找到的<color=yellow>楼兰珍宝<color>再加上一些<color=yellow>月影之石<color>给我，我就可以让你得到你想要的<color=yellow>同伴装备碎片<color>哦～ "
  for nIndex, tbInfo in ipairs(Atlantis.CHANGE_LIST) do
    table.insert(tbOpt, { string.format("兑换<color=yellow>[%s]<color>", tbInfo.szName), self.OnGiftChip, self, nIndex })
  end
  tbOpt[#tbOpt + 1] = { "我知道了" }
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:OnGiftChip(nIndex)
  if me.IsAccountLock() ~= 0 then
    Dialog:Say("你的账号处于锁定状态，无法进行该操作！")
    return 0
  end
  Dialog:AskNumber("请输入数量：", 50, self.DoChangeChip, self, nIndex)
end

function tbNpc:DoChangeChip(nIndex, nInput, nSure)
  local tbInfo = Atlantis.CHANGE_LIST[nIndex]
  if not tbInfo or nInput <= 0 then
    Dialog:Say("请输入正确的数量。")
    return 0
  end

  local nNeedChip = tbInfo.nNeedChip * nInput
  local nNeedMoon = tbInfo.nNeedMoon * nInput

  if not nSure then
    local szMsg = string.format(
      [[
    嘿嘿，这确实是好东西，你也知道我不会让你们这么辛苦白跑一趟的，你现在只要给我：
    <color=yellow>%s个%s<color>
    <color=yellow>%s个月影之石<color>
    我就可以给你：<color=yellow>%s个%s<color>。怎么样，这个交易不错吧？]],
      nNeedChip,
      tbInfo.szBase,
      nNeedMoon,
      nInput,
      tbInfo.szName
    )
    local tbOpt = {
      { "<color=yellow>确定<color>", self.DoChangeChip, self, nIndex, nInput, 1 },
      { "我再想想" },
    }
    Dialog:Say(szMsg, tbOpt)
    return 0
  end

  local nCount = me.GetItemCountInBags(unpack(tbInfo.tbBaseId))
  if nCount < nNeedChip then
    Dialog:Say(string.format("    你身上哪有<color=yellow>%s个%s<color>，你骗我！！你骗我！！！", tbInfo.szBase, nNeedChip))
    return 0
  end

  nCount = me.GetItemCountInBags(unpack(Atlantis.ITEM_MOON_ID))
  if nCount < nNeedMoon then
    Dialog:Say(string.format("    你身上哪有<color=yellow>%s个月影之石<color>，你骗我！！你骗我！！！", nNeedMoon))
    return 0
  end

  local nNeedSpace = KItem.GetNeedFreeBag(tbInfo.tbItemId[1], tbInfo.tbItemId[2], tbInfo.tbItemId[3], tbInfo.tbItemId[4], nil, nInput)
  if me.CountFreeBagCell() < nNeedSpace then
    Dialog:Say(string.format("请留出<color=yellow>%s格<color>背包空间。", nNeedSpace))
    return 0
  end

  local nRet = me.ConsumeItemInBags2(nNeedChip, tbInfo.tbBaseId[1], tbInfo.tbBaseId[2], tbInfo.tbBaseId[3], tbInfo.tbBaseId[4])
  if nRet ~= 0 then
    Dbg:WriteLog("楼兰古城", "Atlantis", me.szAccount, me.szName, string.format("扣除%s个%s失败", tbInfo.szBase, nNeedChip))
  end

  nRet = me.ConsumeItemInBags2(nNeedMoon, Atlantis.ITEM_MOON_ID[1], Atlantis.ITEM_MOON_ID[2], Atlantis.ITEM_MOON_ID[3], Atlantis.ITEM_MOON_ID[4])
  if nRet ~= 0 then
    Dbg:WriteLog("楼兰古城", "Atlantis", me.szAccount, me.szName, string.format("扣除%s个月影之石失败", nNeedMoon))
  end

  me.AddStackItem(tbInfo.tbItemId[1], tbInfo.tbItemId[2], tbInfo.tbItemId[3], tbInfo.tbItemId[4], nil, nInput)

  Dbg:WriteLog("Atlantis", "楼兰古城", me.szAccount, me.szName, "兑换同伴碎片", string.format("%s个%s", nInput, tbInfo.szName))
  StatLog:WriteStatLog("stat_info", "loulangucheng", "gain", me.nId, me.GetHonorLevel(), tbInfo.szName, nInput)
  StatLog:WriteStatLog("stat_info", "yueyingxiaohao", "exchange", me.nId, nNeedMoon, tbInfo.szName, nInput)
end

-- 兑换同伴装备
function tbNpc:OnChangeEquip()
  local tbNewland = Npc:GetClass("newland_npc_city")
  tbNewland:ExchangePartnerEq()
end

-- 同伴装备兑换材料
function tbNpc:OnChangeBack()
  Dialog:OpenGift("请放入楼兰同伴装备<color=yellow>（绑定的同伴装备只能兑换绑定的珍宝）<color>", nil, { self.DoChangeBack, self })
end

function tbNpc:DoChangeBack(tbItem, nSure)
  local tbPartnerEquip = {
    [1] = { "碧血护腕", { 5, 22, 1, 1 }, { 18, 1, 1237, 1 }, 45 },
    [2] = { "碧血戒指", { 5, 21, 1, 1 }, { 18, 1, 1240, 1 }, 45 },
    [3] = { "金鳞护腕", { 5, 22, 1, 2 }, { 18, 1, 1238, 1 }, 45 },
    [4] = { "金鳞戒指", { 5, 21, 1, 2 }, { 18, 1, 1241, 1 }, 45 },
  }

  local nBind = 0
  local nValue = 0
  local tbEquip = nil
  for _, tbTmpItem in pairs(tbItem) do
    local pItem = tbTmpItem[1]
    if Partner:GetPartnerEquipParam(pItem) ~= 1 then
      local szKey = string.format("%s,%s,%s,%s", pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel)
      for _, tbInfo in pairs(tbPartnerEquip) do
        if szKey == string.format("%s,%s,%s,%s", unpack(tbInfo[2])) then
          nValue = nValue + 1
          tbEquip = tbInfo
          nBind = pItem.IsBind() or 0
        end
      end
    end
  end

  if nValue ~= 1 then
    Dialog:Say("请放入正确的楼兰同伴装备，每次只能放入一件。")
    return 0
  end

  local nNeed = KItem.GetNeedFreeBag(tbEquip[3][1], tbEquip[3][2], tbEquip[3][3], tbEquip[3][4], { bForceBind = nBind }, tbEquip[4])
  if me.CountFreeBagCell() < nNeed then
    Dialog:Say(string.format("请留出%s格背包空间。", nNeed))
    return 0
  end

  if not nSure then
    local szMsg = string.format("你打算将<color=yellow>%s<color>兑换为<color=yellow>%s个<color>珍宝吗？", tbEquip[1], tbEquip[4])
    local tbOpt = {
      { "<color=yellow>确定<color>", self.DoChangeBack, self, tbItem, 1 },
      { "我再想想" },
    }
    Dialog:Say(szMsg, tbOpt)
    return 0
  end

  for _, tbTmpItem in pairs(tbItem) do
    local pItem = tbTmpItem[1]
    if Partner:GetPartnerEquipParam(pItem) ~= 1 then
      local szKey = string.format("%s,%s,%s,%s", pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel)
      if szKey == string.format("%s,%s,%s,%s", unpack(tbEquip[2])) then
        if me.DelItem(pItem) == 1 then
          me.AddStackItem(tbEquip[3][1], tbEquip[3][2], tbEquip[3][3], tbEquip[3][4], { bForceBind = nBind }, tbEquip[4])
          Dbg:WriteLog("Atlantis", "楼兰古城", me.szAccount, me.szName, "同伴装备兑换珍宝", tbEquip[1], tbEquip[4], nBind)
          StatLog:WriteStatLog("stat_info", "partnerequip", "reback", me.nId, tbEquip[1], tbEquip[4], nBind)
        else
          Dbg:WriteLog("Atlantis", "楼兰古城", me.szAccount, me.szName, "同伴装备兑换珍宝扣除失败", tbEquip[1], tbEquip[4], nBind)
        end
        break
      end
    end
  end
end
