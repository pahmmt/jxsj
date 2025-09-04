--机关大师
--孙多良
--2008.08.15

local tbNpc = Npc:GetClass("jiguandashi")
tbNpc.tbArmyBag = { 20, 1, 482, 1 }
tbNpc.tbArmyHandBook = { 20, 1, 483, 1 }
tbNpc.nTaskGroupId = 2044 --随机获得零件的任务变量Group
tbNpc.tbTaskId = {
  --随机获得零件的任务变量
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
}

function tbNpc:OnDialog()
  local szMsg = "天地分阴阳，万物化五行，相辅能相成，相克又相生。机关学的精髓不是巧夺天工的技艺，而是顺应自然的创造。"
  local tbOpt = {
    { "用机关耐久兑换物品", Dialog.OpenShop, Dialog, 129, 10 },
    { "领取机关箱", self.GetArmyBag, self },
    --{"领取机关材料手册", self.GetArmyHandBook, self},
    { "领取机关材料手册的奖励", self.recycleHandBook, self },
    { "结束对话" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:GetArmyBag()
  if me.nLevel < 80 then
    Dialog:Say("机关大师：您必须到达80级才有资格活动机关箱。")
    return 0
  end
  if me.GetTask(1022, 117) ~= 1 then
    Dialog:Say("机关大师：年轻人，你还尚未入门，请先去完成一次新军操练任务吧。")
    return 0
  end
  local tbFind1 = me.FindItemInBags(unpack(self.tbArmyBag))
  local tbFind2 = me.FindItemInRepository(unpack(self.tbArmyBag))
  if #tbFind1 <= 0 and #tbFind2 <= 0 then
    if me.CountFreeBagCell() >= 1 then
      local pItem = me.AddItem(unpack(self.tbArmyBag))
      if pItem then
      end
      Dialog:Say("机关大师：您成功领取了机关箱。")
    else
      Dialog:Say("机关大师：您的背包空间不足。")
    end
  else
    Dialog:Say("机关大师：您已领取了机关箱。")
  end
  return 0
end

function tbNpc:GetArmyHandBook()
  local tbFind1 = me.FindItemInBags(unpack(self.tbArmyHandBook))
  local tbFind2 = me.FindItemInRepository(unpack(self.tbArmyHandBook))
  if #tbFind1 <= 0 and #tbFind2 <= 0 then
    if me.CountFreeBagCell() >= 1 then
      local pItem = me.AddItem(unpack(self.tbArmyHandBook))
      if pItem then
        pItem.Bind(1)
      end
      Dialog:Say("机关大师：您成功领取了机关材料手册。")
    else
      Dialog:Say("机关大师：您的背包空间不足。")
    end
  else
    Dialog:Say("机关大师：您已领取了机关材料手册。")
  end
  return 0
end

function tbNpc:recycleHandBook()
  local tbFind1 = me.FindItemInBags(unpack(self.tbArmyHandBook))
  if #tbFind1 <= 0 then
    Dialog:Say("机关大师：您身上没有机关材料手册啊。")
    return 0
  end
  for i, nTaskId in pairs(self.tbTaskId) do
    if me.GetTask(self.nTaskGroupId, nTaskId) == 0 then
      Dialog:Say("机关大师：您还没有集齐10个机关零件呢，继续加油吧。")
      return 0
    end
  end
  me.ConsumeItemInBags(1, unpack(self.tbArmyHandBook))
  for i, nTaskId in pairs(self.tbTaskId) do
    me.SetTask(self.nTaskGroupId, nTaskId, 0)
  end
  me.AddExp(1000000)
  me.Earn(10000, Player.emKEARN_TASK_ARMYCAMP)
  KStatLog.ModifyAdd("jxb", "[产出]军营任务", "总量", 10000)
  me.AddMachineCoin(150)
  me.AddRepute(1, 3, 150)
  me.Msg("你获得了1000000经验")
  me.Msg("你获得了10000银两")
  me.Msg("你获得了150机关学经验")
  me.Msg("你获得了150机关耐久度")
end
