Require("\\script\\task\\merchant\\merchant_define.lua")

local MerchantNpc = {}

Merchant.Npc = MerchantNpc
local tbNpc = Npc:GetClass("merchant")
function tbNpc:OnDialog()
  local tbOpt = {
    { "商会任务介绍", Merchant.Npc.About, Merchant.Npc },
    { "补领商会信笺", Merchant.Npc.GetDervielItem, Merchant.Npc },
    { "领取商会令牌收集盒", Merchant.Npc.GetMerchantBox, Merchant.Npc },
    { "换点绑银花花", Shop.SellItem.OnOpenSell, Shop.SellItem },
    --{"取消任务", Merchant.Npc.CancelTask, Merchant.Npc},
    { "结束对话" },
  }
  local szMsg = [[商会老板：帮助商会完成40个步骤的任务即可获得大量银两和玄晶奖励。
	参加商会任务必须达到以下条件：<color=yellow>
		1.等级达到60级。
		2.江湖威望达到50。
		3.一周只能领取一次商会任务。
		<color>]]
  Dialog:Say(szMsg, tbOpt)
end

function MerchantNpc:GetMerchantBox()
  local tbFind1 = me.FindItemInBags(unpack(Merchant.MERCHANT_BOX_ITEM))
  local tbFind2 = me.FindItemInRepository(unpack(Merchant.MERCHANT_BOX_ITEM))
  if #tbFind1 > 0 or #tbFind2 > 0 then
    Dialog:Say("您已经有商会令牌收集盒了。")
    return 0
  end
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("您的背包空间不足，无法拿到商会令牌收集盒，请整理背包再领取。")
    return 0
  end
  me.AddItem(unpack(Merchant.MERCHANT_BOX_ITEM))
  Dialog:Say("成功领取了商会令牌收集盒。")
end

function MerchantNpc:GetDervielItem()
  if Merchant:GetTask(Merchant.TASK_OPEN) == 1 then
    Dialog:Say("您不需要商会信笺")
    return 0
  end

  if Merchant:GetTask(Merchant.TASK_TYPE) ~= Merchant.TYPE_DELIVERITEM and Merchant:GetTask(Merchant.TASK_TYPE) ~= Merchant.TYPE_DELIVERITEM_NEW then
    Dialog:Say("您不需要商会信笺")
    return 0
  end

  local tbFind1 = me.FindItemInBags(unpack(Merchant.DERIVEL_ITEM))
  local tbFind2 = me.FindItemInRepository(unpack(Merchant.DERIVEL_ITEM))
  if #tbFind1 > 0 or #tbFind2 > 0 then
    Dialog:Say("您已经有商会信笺了。")
    return 0
  end
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("您的背包空间不足，无法拿到商会信笺，请到商人处再领取。")
    return 0
  end
  me.AddItem(unpack(Merchant.DERIVEL_ITEM))
end

function MerchantNpc:CancelTask()
  Task:CloseTask(Merchant.TASKDATA_ID, "giveup")
  Merchant:SetTask(Merchant.TASK_OPEN, 0)
  Merchant:SetTask(Merchant.TASK_STEP_COUNT, 0)
  Merchant:SetTask(Merchant.TASK_TYPE, 0)
  Merchant:SetTask(Merchant.TASK_STEP, 0)
  Merchant:SetTask(Merchant.TASK_LEVEL, 0)
  Merchant:SetTask(Merchant.TASK_NOWTASK, 0)
end

function MerchantNpc:About()
  local szMsg = [[帮助商会完成40个步骤的任务即可获得大量银两和玄晶奖励。
	参加商会任务必须达到以下条件：<color=yellow>
		1.等级达到60级。
		2.江湖威望达到50。
		3.一周只能领取一次商会任务。
		<color>
	商会任务有以下任务类型：<color=yellow>
		1.送信：将商会信笺送到指定人处（商会接头人将会在指定地图出现）
		2.寻物：帮商会收集指定道具（各种相应活动中可获得）
		3.采集：去指定地点采集指定物品（物品有怪物守护,请务必组队前往）
		<color>]]
  Dialog:Say(szMsg)
end
