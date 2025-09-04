-------------------------------------------------------------------
--File: wulinmengzhu.lua
--Author: luobaohang
--Date: 2007-9-19 16:36
--Describe: 武林盟主
-------------------------------------------------------------------

--	武林盟主;
local tbWuLinMengZhu = Npc:GetClass("wulinmengzhu")

tbWuLinMengZhu.tbYanXiaoLou = { 18, 1, 666, 11 }
tbWuLinMengZhu.nChangePoint = 8000000
tbWuLinMengZhu.nMinHonorLevel = 9
tbWuLinMengZhu.nOpenChangeDay = 150

function tbWuLinMengZhu:OnDialog()
  local szMsg = "只要是志同道合的朋友，亲密度达到100，等级达到30就可以组队到我这创建家族。三个以上家族族长组队就可以来我这创建帮会哦。"
  if EventManager.IVER_bOpenTiFu == 1 then
    szMsg = "只要是志同道合的朋友，等级达到30就可以组队到我这创建家族。三个以上家族族长组队就可以来我这创建帮会哦。"
  end

  local nOpenServerTime = KGblTask.SCGetDbTaskInt(DBTASD_SERVER_STARTTIME)
  local nServerDay = Lib:GetLocalDay(nOpenServerTime)
  local nNowDay = Lib:GetLocalDay(GetTime())

  local tbOpt = {
    { "创建家族", Kin.DlgCreateKin, Kin },
    { "创建帮会", Tong.DlgCreateTong, Tong },
    { "更改家族阵营", Kin.DlgChangeCamp, Kin },
    { "更改帮会阵营", Tong.DlgChangeCamp, Tong },
    { "领取家族令牌", Kin.DlgKinExp, Kin },
    { "领取帮会分红", Tong.DlgTakeStock, Tong },
    { "帮会评优奖励", Tong.DlgGreatBonus, Tong },
    { "关闭" },
  }
  if (nNowDay - nServerDay) >= self.nOpenChangeDay then
    table.insert(tbOpt, 1, { "<color=yellow>兑换燕小楼（七技能同伴）<color>", self.OnChangeYanXiaoLou, self })
  end

  Dialog:Say(szMsg, tbOpt)
end

function tbWuLinMengZhu:NoAccept()
  Dialog:Say("呵呵，暂不受理此业务，请迟些再来吧。")
end

function tbWuLinMengZhu:OnChangeYanXiaoLou()
  local nFlag, szMsg = self:IsCanChangeYanXiaoLou()
  if 1 ~= nFlag then
    Dialog:Say(szMsg)
    return 0
  end
  local nPoint = Spreader:GetConsumeMoney()
  Dialog:Say(string.format("您当前奇珍阁消耗积分为<color=yellow>%s分<color>，你确定使用<color=yellow>800万<color>奇珍阁消耗积分兑换<color=yellow>1个燕小楼（七技能同伴）<color>吗？\n\n<color=red>注意：每个角色只允许拥有一个七技能同伴！<color>", nPoint), {
    { "确定兑换", self.OnSureChange, self },
    { "我再考虑考虑" },
  })
end

function tbWuLinMengZhu:IsCanChangeYanXiaoLou()
  local nPoint = Spreader:GetConsumeMoney()
  local nOpenServerTime = KGblTask.SCGetDbTaskInt(DBTASD_SERVER_STARTTIME)
  local nServerDay = Lib:GetLocalDay(nOpenServerTime)
  local nNowDay = Lib:GetLocalDay(GetTime())

  if (nNowDay - nServerDay) < self.nOpenChangeDay then
    return 0, string.format(string.format("开服<color=yellow>%s天<color>后开启奇珍阁消耗积分兑换燕小楼。", self.nOpenChangeDay))
  end

  if nPoint < self.nChangePoint then
    return 0, string.format("您当前奇珍阁消耗积分为<color=yellow>%s分<color>，不足<color=yellow>800万分<color>，无法兑换", nPoint)
  end

  local nHonorLevel = me.GetHonorLevel()
  if nHonorLevel < self.nMinHonorLevel then
    return 0, string.format("兑换燕小楼需要<color=yellow>财富荣誉、武林荣誉、领袖荣誉<color>其中一种的等级达到<color=yellow>%s级<color>才能兑换！", self.nMinHonorLevel)
  end

  local nIsHaveSevenPartner, szMsg = self:IsHaveSevenPartner(me)
  if 1 == nIsHaveSevenPartner then
    return 0, szMsg
  end

  if 1 > me.CountFreeBagCell() then
    return 0, string.format("您的背包剩余空间不足<color=yellow>1<color>格，请整理后再来领取！")
  end
  return 1
end

function tbWuLinMengZhu:OnSureChange()
  local nFlag, szMsg = self:IsCanChangeYanXiaoLou()
  if 1 ~= nFlag then
    Dialog:Say(szMsg)
    return 0
  end

  Spreader:DecConsume(self.nChangePoint)
  local pItem = me.AddItem(unpack(self.tbYanXiaoLou))
  if not pItem then
    Dbg:WriteLog("changeyanxiaolou", string.format("扣除%s分积分，兑换%s，增加燕小楼失败", self.nChangePoint, me.szName))
    return 0
  end

  pItem.Bind(1)
  pItem.Sync()
  Dialog:Say("恭喜你获得燕小楼！")
  Dbg:WriteLog("changeyanxiaolou", string.format("扣除%s分积分，兑换%s，增加燕小楼成功", self.nChangePoint, me.szName))
  return 0
end

function tbWuLinMengZhu:IsHaveSevenPartner(pPlayer)
  for i = 1, pPlayer.nPartnerCount do
    local pPartner = pPlayer.GetPartner(i - 1)
    if pPartner and pPartner.nSkillCount == 7 then
      return 1, "每个角色只允许拥有<color>1个七技能同伴<color>，无法兑换！"
    end
  end

  local tbResult = me.FindItemInAllPosition(unpack(self.tbYanXiaoLou))
  if #tbResult > 0 then
    return 1, "您的背包或者仓库里已经拥有<color=yellow>1个燕小楼（七技能同伴）<color>了，不能兑换，<color=red>每个角色只允许拥有1个七技能同伴<color>！"
  end
  return 0
end
