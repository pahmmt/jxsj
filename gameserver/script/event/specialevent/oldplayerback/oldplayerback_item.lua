-- 文件名　：oldplayerback_item.lua
-- 创建者　：jiazhenwei
-- 创建时间：2011-03-09 15:34:06
--老玩家召回贴

if MODULE_GAMECLIENT then
  local tbItem = Item:GetClass("oldplayerback")
  tbItem.tbNameGate = { "\n逍遥谷通关：", "\n通过白虎堂2层：", "\n完成官府通缉：", "\n宋金战场：", "\n侠客任务：" }

  function tbItem:GetTip()
    local nReturnNum = me.GetTask(2138, 11)
    local szMsg = string.format("\n<color=green>消费返还剩余的绑金数量为：%s<color>\n", nReturnNum)
    local nActivateTime = me.GetTask(2138, 157)
    if GetTime() - nActivateTime <= 30 * 24 * 3600 then
      szMsg = szMsg .. "\n参与活动情况：\n<color=red>注：激活老玩家30天且加入家族并成为正式成员时参与有效。<color>\n"
      for i = 150, 154 do
        local nCount = me.GetTask(2138, i)
        local szColor = "gray"
        if nCount > 0 and nCount < 2 then
          szColor = "white"
        elseif nCount >= 2 then
          szColor = "green"
        end
        szMsg = szMsg .. string.format("<color=%s>%s%s/2<color>", szColor, self.tbNameGate[i - 149], nCount)
      end
    end
    return szMsg
  end
end

if MODULE_GAMESERVER then
  local tbLiBao = Item:GetClass("oldplayerback_gumulibao")

  function tbLiBao:OnUse()
    -- 检查充值
    if me.GetExtMonthPay() <= 0 then
      Dialog:Say("只有充值玩家才能使用", { { "我要充值", self.OpenOnLinePay, self }, { "我再考虑一下" } })
      return
    end
    local nEquipFlag = it.GetGenInfo(1, 0)
    local nEnhanceFlag = it.GetGenInfo(2, 0)
    local tbOpt = {}
    if nEquipFlag == 1 then
      table.insert(tbOpt, { "<color=gray>领取古墓武器<color>", self.GetEuip, self, it.dwId })
    else
      table.insert(tbOpt, { "领取古墓武器", self.GetEuip, self, it.dwId })
    end
    if nEnhanceFlag == 1 then
      table.insert(tbOpt, { "<color=gray>领取强化转移优惠<color>", self.GetEnhance, self, it.dwId })
    else
      table.insert(tbOpt, { "领取强化转移优惠", self.GetEnhance, self, it.dwId })
    end
    table.insert(tbOpt, { "我再考虑一下" })
    Dialog:Say("领取以下道具，可以方便你辅修古墓派", tbOpt)
  end

  function tbLiBao:OpenOnLinePay()
    if IVER_g_nSdoVersion == 1 then
      me.CallClientScript({ "OpenSDOWidget" })
      return
    end
    local szZoneName = GetZoneName()
    me.CallClientScript({ "Ui:ServerCall", "UI_PAYONLINE", "OnRecvZoneOpen", szZoneName })
  end

  function tbLiBao:GetEuip(dwItemId, nSeries, nIndex)
    local pItemLiBao = KItem.GetObjById(dwItemId)
    if not pItemLiBao then
      return
    end
    local nFlag = pItemLiBao.GetGenInfo(1, 0)
    local nEnhanceFlag = pItemLiBao.GetGenInfo(2, 0)
    if nFlag == 1 then
      Dialog:Say("你已经领取了装备。")
      return
    end
    if not nSeries then
      local tbOpt = {
        { "金系", self.GetEuip, self, dwItemId, 1 },
        { "木系", self.GetEuip, self, dwItemId, 2 },
        { "土系", self.GetEuip, self, dwItemId, 3 },
        { "水系", self.GetEuip, self, dwItemId, 4 },
        { "火系", self.GetEuip, self, dwItemId, 5 },
        { "我再考虑一下" },
      }
      Dialog:Say("选择你想要的武器五行：", tbOpt)
      return
    end
    if not nIndex then
      local tbOpt = {
        { "针古墓", self.GetEuip, self, dwItemId, nSeries, 1 },
        { "剑古墓", self.GetEuip, self, dwItemId, nSeries, 2 },
        { "我再考虑一下" },
      }
      Dialog:Say("选择你想要的门派路线，我会给你对应的武器", tbOpt)
      return
    end
    if me.CountFreeBagCell() < 1 then
      Dialog:Say("您的背包空间不足，需要1格背包空间。")
      return
    end
    local tbItemList = {
      [1] = { { 2, 2, 217, 10 }, { 2, 1, 1170, 10 } },
      [2] = { { 2, 2, 220, 10 }, { 2, 1, 1175, 10 } },
      [3] = { { 2, 2, 204, 10 }, { 2, 1, 1506, 10 } },
      [4] = { { 2, 2, 223, 10 }, { 2, 1, 1180, 10 } },
      [5] = { { 2, 2, 226, 10 }, { 2, 1, 1185, 10 } },
    }
    local pItem = me.AddItem(unpack(tbItemList[nSeries][nIndex]))
    if pItem then
      pItem.Bind(1)
    else
      Dbg:WriteLog("gumuqingyuanlibao add equip fail", me.szName, nIndex)
    end
    pItemLiBao.SetGenInfo(1, 1)
    if nEnhanceFlag == 1 then
      pItemLiBao.Delete(me)
    end
  end

  function tbLiBao:GetEnhance(dwItemId)
    local pItemLiBao = KItem.GetObjById(dwItemId)
    if not pItemLiBao then
      return
    end
    if me.CountFreeBagCell() < 1 then
      Dialog:Say("您的背包空间不足，需要1格背包空间。")
      return
    end
    local nFlag = pItemLiBao.GetGenInfo(2, 0)
    local nEquipFlag = pItemLiBao.GetGenInfo(1, 0)
    if nFlag == 1 then
      Dialog:Say("你已经领取了强化传承优惠。")
      return
    end
    local pItem = me.AddItem(18, 1, 1198, 1)
    if pItem then
      pItem.Bind(1)
    else
      Dbg:WriteLog("gumuqingyuanlibao add enhance fail", me.szName)
    end
    me.AddSkillState(2263, 1, 2, 24 * 3600 * Env.GAME_FPS, 1, 0, 1)
    me.Msg("恭喜你获得了强化传承优惠状态，转移一件装备后会自动消失")
    pItemLiBao.SetGenInfo(2, 1)
    if nEquipFlag == 1 then
      pItemLiBao.Delete(me)
    end
  end
end
