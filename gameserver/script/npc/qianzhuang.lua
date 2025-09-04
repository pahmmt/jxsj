local tbNpc = Npc:GetClass("qianzhuang")

function tbNpc:OnDialog()
  if me.IsAccountLock() ~= 0 then
    Dialog:Say("你的账号处于锁定状态，无法进行该操作！")
    Account:OpenLockWindow(me)
    return
  end
  local tbOpt = {
    { "魂石商店", self.OnOpenShop, self, me },
    { "兑换五行魂石", Dialog.Gift, Dialog, "Item.ChangeGift" },
    { "披风兑换魂石", self.SaleMantle, self },
    { "结束对话" },
  }
  if IVER_g_nSdoVersion == 0 then
    table.insert(tbOpt, 1, { "剑侠钱庄", self.OpenBank, self })
  end
  if Task.TaskExp.Open == 1 then
    table.insert(tbOpt, 1, { "<color=yellow>任务平台<color>", Task.TaskExp.OnDialog, Task.TaskExp, me })
  end
  Dialog:Say(me.szName .. "，找我有什么事？", tbOpt)
end

function tbNpc:SaleMantle()
  Shop.MantleGift:OnOpen()
end

function tbNpc:OpenBank()
  if Bank.nBankState == 0 then
    me.Msg("钱庄暂时没有开放。")
    return
  end
  me.CallClientScript({ "UiManager:OpenWindow", "UI_BANK" })
end

function tbNpc:OnOpenShop(pPlayer)
  local nSeries = pPlayer.nSeries
  if nSeries == 0 then
    Dialog:Say("请加入门派后再来！")
    return
  end

  if 1 == nSeries then
    pPlayer.OpenShop(140, 3)
  elseif 2 == nSeries then
    pPlayer.OpenShop(141, 3)
  elseif 3 == nSeries then
    pPlayer.OpenShop(142, 3)
  elseif 4 == nSeries then
    pPlayer.OpenShop(143, 3)
  elseif 5 == nSeries then
    pPlayer.OpenShop(144, 3)
  else
    Dbg:WriteLogEx(Dbg.LOG_INFO, "Npc qianzhuang", pPlayer.szName, "There is no Series", nSeries)
  end
end
