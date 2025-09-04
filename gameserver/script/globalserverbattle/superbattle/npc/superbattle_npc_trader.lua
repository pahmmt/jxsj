-------------------------------------------------------
-- 文件名　 : superbattle_npc_trader.lua
-- 创建者　 : zhangjinpin@kingsoft
-- 创建时间 : 2011-06-09 16:49:21
-- 文件描述 :
-------------------------------------------------------

if not MODULE_GAMESERVER then
  return
end

Require("\\script\\globalserverbattle\\superbattle\\superbattle_def.lua")

local tbNpc = Npc:GetClass("superbattle_npc_trader")

function tbNpc:OnDialog()
  local szMsg = "大家好，每场战役可以从我这里领取<color=yellow>2箱<color>免费药品，也可以购买更高级的药物。"
  local tbOpt = {
    { "<color=yellow>领取药箱<color>", self.GetMedicine, self },
    { "购买药物", self.OpenShop, self },
    { "我知道了" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:GetMedicine()
  local nMedicine = SuperBattle:GetPlayerTypeData(me, "nMedicine")
  if nMedicine <= 0 then
    Dialog:Say("对不起，你的免费药品已经领取完了，请打开商店购买吧。")
    return 0
  end

  local szMsg = "你打算领取哪一种药品？"
  local tbOpt = {}
  for i, tbInfo in ipairs(SuperBattle.MEDICINE_ID) do
    table.insert(tbOpt, { tbInfo[1], self.DoGetMedicine, self, i })
  end
  tbOpt[#tbOpt + 1] = { "我知道了" }

  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:DoGetMedicine(nType)
  local tbInfo = SuperBattle.MEDICINE_ID[nType]
  if not tbInfo then
    return 0
  end

  local nNeed = 1
  if me.CountFreeBagCell() < nNeed then
    Dialog:Say(string.format("请留出%s格背包空间。", nNeed))
    return 0
  end

  me.AddItem(unpack(tbInfo[2]))
  SuperBattle:AddPlayerTypeDate(me, "nMedicine", -1)
end

function tbNpc:OpenShop()
  me.OpenShop(164, 7)
end
