--充值送江湖威望令牌
--孙多良
--当月充值玩家，根据充值额度可在npc礼官处有一次机会领取江湖威望令牌；
--充值15元以上48元以下可领取1个绑定的江湖威望令牌，充值48元以上可领取3个绑定的江湖威望令牌。

SpecialEvent.ChongZhiRepute = {}
local tbChongZhi = SpecialEvent.ChongZhiRepute
tbChongZhi.TSK_GROUP = 2027
tbChongZhi.TSK_DATE = 52
tbChongZhi.TSK_COUNT = 53
tbChongZhi.DEF_COUNT_MAX = { 1, 3 }

tbChongZhi.DEF_WEEK_REPUTE = { 10, 30 }
tbChongZhi.TSK_WEEK = 54
tbChongZhi.TSK_REPUTE_SUM = 55

function tbChongZhi:Check2()
  local nExt = me.GetExtMonthPay()
  if nExt < IVER_g_nPayLevel1 then
    return -1, 0
  end
  local nCurWeek = tonumber(GetLocalDate("%Y%W"))
  if nCurWeek > me.GetTask(self.TSK_GROUP, self.TSK_WEEK) then
    me.SetTask(self.TSK_GROUP, self.TSK_WEEK, nCurWeek)
    me.SetTask(self.TSK_GROUP, self.TSK_REPUTE_SUM, 0)
  end
  local nMaxSum = 0
  local nSum = me.GetTask(self.TSK_GROUP, self.TSK_REPUTE_SUM)
  if nExt >= IVER_g_nPayLevel1 and nExt < IVER_g_nPayLevel2 then
    nMaxSum = self.DEF_WEEK_REPUTE[1]
  elseif nExt >= IVER_g_nPayLevel2 then
    nMaxSum = self.DEF_WEEK_REPUTE[2]
  end
  local nNum = nMaxSum - nSum
  if nNum < 0 then
    nNum = 0
  end
  return nNum, nSum
end

function tbChongZhi:CheckIsSetExt()
  return me.GetActiveValue(3)
end

function tbChongZhi:CheckISCanGetRepute()
  if IVER_g_nSdoVersion == 1 then
    return 1
  end
  local nDate = me.GetTask(Player.TSK_PAYACTION_GROUP, Player.TSK_PAYACTION_EXT_ID[3])
  local nCurDate = tonumber(GetLocalDate("%Y%m"))
  if nDate == nCurDate then
    return 1
  end
  return 0
end

function tbChongZhi:SetJiHuoPerMonth()
  me.SetActiveValue(3, 1)
  local nCurDate = tonumber(GetLocalDate("%Y%m"))
  me.SetTask(Player.TSK_PAYACTION_GROUP, Player.TSK_PAYACTION_EXT_ID[3], nCurDate)
  Dbg:WriteLog("SpecialEvent.ChongZhiRepute", "领取江湖威望", me.szName, "成功激活了本月领取江湖威望资格", nCurDate)
  me.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, string.format("成功激活了本月领取江湖威望资格:%s", nCurDate))
end

function tbChongZhi:OnDialog()
  local szExMsg = ""
  local tbOpt = {
    { "领取江湖威望", self.GetRepute, self },
    { "随便看看" },
  }
  if IVER_g_nSdoVersion == 0 then
    szExMsg = string.format("<color=yellow>每个帐号下只允许一个角色领取，每个月只能激活一次。<color>")
    table.insert(tbOpt, 1, { "激活角色领取江湖威望", self.OnJiHuoGetRepute, self })
  end
  local szMsg = string.format("等级达到60级的玩家%s可享受如下福利：\n\n每月%s<color=yellow>满%s<color>每周送<color=yellow>10点江湖威望<color>；\n\n%s<color=yellow>满%s<color>每周送<color=yellow>30点江湖威望<color>。\n\n%s", IVER_g_szPayName, IVER_g_szPayName, IVER_g_szPayLevel1, IVER_g_szPayName, IVER_g_szPayLevel2, szExMsg)

  Dialog:Say(szMsg, tbOpt)
end

function tbChongZhi:OnJiHuoGetRepute(nFlag)
  if self:CheckISCanGetRepute() == 1 then
    Dialog:Say("你当前角色已经成功激活过领取江湖威望资格。", { { "返回上层", self.OnDialog, self }, { "结束对话" } })
    return 0
  end

  if self:CheckIsSetExt() == 1 then
    Dialog:Say("你的帐号下其他角色已经激活了领取江湖威望资格，一个帐号下只允许一个角色激活。", { { "返回上层", self.OnDialog, self }, { "结束对话" } })
    return 0
  end

  if not nFlag then
    local szMsg = "每个帐号每月只能选择一个角色激活领取江湖威望资格并领取江湖威望。\n\n你是否要激活本月领取江湖威望资格，激活本角色后，你所在帐号下的其他角色本月将无法再激活领取资格，<color=red>你确定要当前角色激活领奖资格吗？<color>"
    local tbOpt = {
      { "确定要激活", self.OnJiHuoGetRepute, self, 1 },
      { "我再考虑一下" },
    }
    Dialog:Say(szMsg, tbOpt)
    return 0
  end
  self:SetJiHuoPerMonth()
  Dialog:Say("你的角色成功激活了领取江湖威望资格，请充值后领取本月赠送江湖威望。", { { "返回上层", self.OnDialog, self }, { "结束对话" } })
end

function tbChongZhi:GetRepute()
  --local nResult, nCount = self:Check();
  if self:CheckISCanGetRepute() == 0 then
    Dialog:Say("你的角色没有激活领取江湖威望资格。", { { "返回上层", self.OnDialog, self }, { "结束对话" } })
    return 0
  end

  local nResultRepute, nSumRepute = self:Check2()

  if me.nLevel < 60 then
    Dialog:Say("必须达到60级才能领取。")
    return 0
  end

  if nResultRepute < 0 then
    local szMsg = string.format("本月%s达到%s才可以领取江湖威望哦，你好像并没有充这么多。", IVER_g_szPayName, IVER_g_szPayLevel1)
    Dialog:Say(szMsg, { { "返回上层", self.OnDialog, self }, { "结束对话" } })
    return 0
  end

  if nResultRepute == 0 then
    Dialog:Say(string.format("按你的%s额度，您本周已经领取了%s点江湖威望了。", IVER_g_szPayName, nSumRepute), { { "返回上层", self.OnDialog, self }, { "结束对话" } })
    return 0
  end
  local nOrgRepute = me.nPrestige
  me.SetTask(self.TSK_GROUP, self.TSK_REPUTE_SUM, me.GetTask(self.TSK_GROUP, self.TSK_REPUTE_SUM) + nResultRepute)
  me.AddKinReputeEntry(nResultRepute)
  Dbg:WriteLog("SpecialEvent.ChongZhiRepute", "领取江湖威望", me.szName, "领取了江湖威望点数:", nResultRepute)
  me.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, string.format("领取福利江湖威望，[%s]玩家的声望由%s增加到%s", me.szName, nOrgRepute, nOrgRepute + nResultRepute))
  Dialog:Say(string.format("礼官：成功获得了%d点江湖威望。", nResultRepute), { { "返回上层", self.OnDialog, self }, { "结束对话" } })
end
