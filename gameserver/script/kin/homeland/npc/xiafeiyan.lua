Require("\\script\\kin\\homeland\\homeland_def.lua")

local tbNpc = Npc:GetClass("xiafeiyan")

function tbNpc:OnDialog()
  if Item.tbStone:GetOpenDay() == 0 then
    local tbOpt = {
      { "以后再来" },
    }
    Dialog:Say("本店正在积极筹备中，暂未开放。", tbOpt)
    return
  end
  Kin:RefreshSkillInfo(me.dwKinId) -- 在这里同步到客户端
  local bFangJuEnable = 0
  local bShouShiEnable = 0
  local bWeaponEnable = 0
  local nSkillPoint = 0
  for nPos, tbCon in pairs(Item.EQUIPPOS_MAKEHOLE_KIN_SKILLLEVEL) do
    if tbCon[1][2] == 1 then
      local nSkillLevel = Kin:GetSkillLevel(me.dwKinId, unpack(tbCon[1]))
      if nSkillLevel > 0 then
        bFangJuEnable = 1
        nSkillPoint = nSkillPoint + 1
      end
    elseif tbCon[1][2] == 2 then
      local nSkillLevel = Kin:GetSkillLevel(me.dwKinId, unpack(tbCon[1]))
      if nSkillLevel > 0 then
        bShouShiEnable = 1
        nSkillPoint = nSkillPoint + 1
      end
    elseif tbCon[1][2] == 3 then
      local nSkillLevel = Kin:GetSkillLevel(me.dwKinId, unpack(tbCon[1]))
      if nSkillLevel > 0 then
        bWeaponEnable = 1
        nSkillPoint = nSkillPoint + 1
      end
    end
  end
  local tbOpt = {}
  if bFangJuEnable == 1 then
    table.insert(tbOpt, { "防具打孔", self.ShowMakeHoleList, self, 1 })
  else
    table.insert(tbOpt, { "<color=gray>防具打孔<color>", self.OnRefuse, self })
  end

  if bShouShiEnable == 1 then
    table.insert(tbOpt, { "首饰打孔", self.ShowMakeHoleList, self, 2 })
  else
    table.insert(tbOpt, { "<color=gray>首饰打孔<color>", self.OnRefuse, self })
  end

  if bWeaponEnable == 1 then
    table.insert(tbOpt, { "武器打孔", self.CheckPermission, self, { self.PreMakeHole, self, 3 } })
  else
    table.insert(tbOpt, { "<color=gray>武器打孔<color>", self.OnRefuse, self })
  end
  table.insert(tbOpt, { "离开" })
  local szMsg = "    我这里可以帮你进行装备第三个宝石孔的改造。\n"
  szMsg = szMsg .. "    家族技能【装备打孔】的加点情况可以决定你现在可以改造哪些类型的装备。\n"
  szMsg = szMsg .. "    我只负责给家族正式成员和荣誉成员服务，祝你好运。\n"
  szMsg = szMsg .. "    家族当前习得技能：<color=yellow>【" .. nSkillPoint .. "/10】<color>\n"
  szMsg = szMsg .. "    您的家族功勋值为：<color=yellow>【" .. me.GetKinSkillOffer() .. "】<color>"

  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:ShowMakeHoleList(nEquipType)
  if me.dwKinId == 0 then -- 没家族，不知道怎么进来的
    return
  end
  local tbOpt = {}
  for nPos, tbCon in pairs(Item.EQUIPPOS_MAKEHOLE_KIN_SKILLLEVEL) do
    if tbCon[1][2] == nEquipType then -- 相应的类型
      local tbInsert = nil
      local nSkillLevel = Kin:GetSkillLevel(me.dwKinId, unpack(tbCon[1]))
      if nSkillLevel > 0 then -- 学习了技能了
        tbInsert = { Item.EQUIPPOS_NAME[nPos], self.CheckPermission, self, { self.PreMakeHole, self, nPos } }
      else
        tbInsert = { "<color=gray>" .. Item.EQUIPPOS_NAME[nPos] .. "<color>", self.OnRefuse2, self, nEquipType }
      end
      table.insert(tbOpt, tbInsert)
    end
  end

  table.insert(tbOpt, { "返回上层", self.OnDialog, self })
  Dialog:Say("请选择需要打孔的装备", tbOpt)
end

function tbNpc:PreMakeHole(nEquipPos)
  me.OpenEquipHole(Item.HOLE_MODE_MAKEHOLEEX, nEquipPos)
end

function tbNpc:CheckPermission(tbOption)
  if me.IsAccountLock() ~= 0 then
    Dialog:Say("你的账号处于锁定状态，无法进行该操作！")
    Account:OpenLockWindow(me)
    return
  end
  Lib:CallBack(tbOption)
end

function tbNpc:OnRefuse()
  local tbOpt = {
    { "返回", self.OnDialog, self },
  }
  Dialog:Say("您的家族尚未开放该部件打孔。", tbOpt)
end

function tbNpc:OnRefuse2(nEquipType)
  local tbOpt = {
    { "返回", self.ShowMakeHoleList, self, nEquipType },
  }
  Dialog:Say("您的家族尚未开放该部件打孔。", tbOpt)
end
