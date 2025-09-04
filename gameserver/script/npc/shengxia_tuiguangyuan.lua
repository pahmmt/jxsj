-------------------------------------------------------------------
--File: tuiguangyuan.lua
--Author: kenmaster
--Date: 2008-06-04 03:00
--Describe: 活动推广员npc脚本
-------------------------------------------------------------------
local tbTuiGuangYuan = Npc:GetClass("shengxia_tuiguangyuan")

function tbTuiGuangYuan:OnDialog()
  local tbOpt = {}
  local szMsg = "您好，有什么可以帮到您呢？"

  table.insert(tbOpt, { "购买奇珍阁道具", self.OnBuyIbShopItem, self })

  if SpecialEvent.tbYanHua:CheckEventTime() == 1 then
    table.insert(tbOpt, { "领取盛夏活动庆祝烟花", SpecialEvent.tbYanHua.DialogLogic, SpecialEvent.tbYanHua })
  end

  if SpecialEvent.HundredKin:CheckEventTime2("award") == 1 then
    table.insert(tbOpt, { "领取百大家族评选奖励", SpecialEvent.HundredKin.DialogLogic, SpecialEvent.HundredKin })
  end

  if Npc.IVER_nShengXiaTuiGuanYuan == 1 then
    if SpecialEvent.ZhongQiu2008:CheckTime() == 1 then
      table.insert(tbOpt, 1, { "使用江湖威望领取中秋月饼材料", SpecialEvent.ZhongQiu2008.OnAward, SpecialEvent.ZhongQiu2008 })
    end

    if SpecialEvent.WangLaoJi:CheckEventTime(4) == 1 then
      table.insert(tbOpt, 1, { "领取王老吉活动奖励", SpecialEvent.WangLaoJi.OnDialog, SpecialEvent.WangLaoJi })
    end

    if SpecialEvent.WangLaoJi:CheckExAward() == 1 then
      table.insert(tbOpt, 1, { "<color=red>领取防上火行动额外奖励", SpecialEvent.WangLaoJi.GetWeekFinishAward, SpecialEvent.WangLaoJi })
    end
  end

  if SpecialEvent.tbWroldCup:GetOpenState() == 1 or SpecialEvent.tbWroldCup:GetOpenState() == 2 then
    table.insert(tbOpt, 1, { "2010年盛夏活动", SpecialEvent.tbWroldCup.tbNpc.OnDialog, SpecialEvent.tbWroldCup.tbNpc })
  end

  table.insert(tbOpt, { "结束对话" })
  Dialog:Say(szMsg, tbOpt)
end

function tbTuiGuangYuan:OnBuyIbShopItem()
  if me.IsAccountLock() ~= 0 then
    Dialog:Say("你的账号处于锁定状态，无法进行该操作！")
    return
  end
  if Account:Account2CheckIsUse(me, 4) == 0 then
    Dialog:Say("你正在使用副密码登陆游戏，设置了权限控制，无法进行该操作！")
    return 0
  end
  local szMsg = "你好，我这里可以购买各种道具，但因为数量有限，你必须拥有购买资格才能购买。有什么需要帮助的呢？"
  local tbOpt = {
    { "购买武林大会英雄令牌", SpecialEvent.BuyItem.BuyOnDialog, SpecialEvent.BuyItem, 1 },
    { "购买2010盛夏纪念徽章", SpecialEvent.BuyItem.BuyOnDialog, SpecialEvent.BuyItem, 2 },
    { "购买黄金智慧精华", SpecialEvent.BuyItem.BuyOnDialog, SpecialEvent.BuyItem, 3 },
    { "购买4988秦陵·和氏璧", SpecialEvent.BuyItem.BuyOnDialog, SpecialEvent.BuyItem, 4 },
    { "购买588和988秦陵·和氏璧", SpecialEvent.BuyHeShiBi.BuyOnDialog, SpecialEvent.BuyHeShiBi },
    { "购买跨服联赛声望白玉", SpecialEvent.BuyItem.BuyOnDialog, SpecialEvent.BuyItem, 5 },
    { "购买巾帼英雄赛24格包", SpecialEvent.BuyItem.BuyOnDialog, SpecialEvent.BuyItem, 12 },
    { "购买储物箱扩展令牌Lv3", SpecialEvent.BuyItem.BuyOnDialog, SpecialEvent.BuyItem, 21 },
    { "购买极品真元箱", SpecialEvent.BuyItem.BuyOnDialog, SpecialEvent.BuyItem, 24 },
    { "结束对话" },
  }
  if EventManager.IVER_bOpenChongzhiPaiZi == 0 then
    tbOpt = {
      { "7级玄晶套餐(7折)", SpecialEvent.BuyItem.BuyOnDialog, SpecialEvent.BuyItem, 6 },
      { "7级玄晶套餐(5折)", SpecialEvent.BuyItem.BuyOnDialog, SpecialEvent.BuyItem, 7 },
      { "魂石箱(100)套餐(7折)", SpecialEvent.BuyItem.BuyOnDialog, SpecialEvent.BuyItem, 8 },
      { "魂石箱(100)套餐(5折)", SpecialEvent.BuyItem.BuyOnDialog, SpecialEvent.BuyItem, 9 },
      { "魂石箱(1000)套餐(7折)", SpecialEvent.BuyItem.BuyOnDialog, SpecialEvent.BuyItem, 10 },
      { "魂石箱(1000)套餐(5折)", SpecialEvent.BuyItem.BuyOnDialog, SpecialEvent.BuyItem, 11 },
      { "精气丸", SpecialEvent.BuyItem.BuyOnDialog, SpecialEvent.BuyItem, 13 },
      { "活气丸", SpecialEvent.BuyItem.BuyOnDialog, SpecialEvent.BuyItem, 14 },
      { "辅修令牌", SpecialEvent.BuyItem.BuyOnDialog, SpecialEvent.BuyItem, 15 },
      { "赤兔马", SpecialEvent.BuyItem.BuyOnDialog, SpecialEvent.BuyItem, 16 },
      { "秦陵·和氏璧", SpecialEvent.BuyItem.BuyOnDialog, SpecialEvent.BuyItem, 18 },
      { "秦陵·摸金符x50", SpecialEvent.BuyItem.BuyOnDialog, SpecialEvent.BuyItem, 19 },
      { "百步穿杨弓x50", SpecialEvent.BuyItem.BuyOnDialog, SpecialEvent.BuyItem, 20 },
      { "结束对话" },
    }
  end
  Dialog:Say(szMsg, tbOpt)
end
