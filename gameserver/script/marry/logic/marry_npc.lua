-------------------------------------------------------
-- 文件名　：marry_npc.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2010-01-05 00:29:41
-- 文件描述：
-------------------------------------------------------

Require("\\script\\marry\\logic\\marry_def.lua")

if not MODULE_GAMESERVER then
  return 0
end

local tbNpc = Marry.DialogNpc or {}
Marry.DialogNpc = tbNpc

-- 判断求婚
function tbNpc:CheckQiuhun()
  -- 系统开关
  if Marry:CheckState() ~= 1 then
    return 0
  end

  local szOptMsg = [[


<color=yellow>纳吉条件：<color>
    1、男女双方等级均达到<color=yellow>69<color>级；
    2、男女双方均为<color=yellow>单身<color>状态，没有纳吉、侠侣关系；
    3、双方<color=yellow>亲密度<color>达到<color=yellow>3级<color>。
]]
  -- 我没有结婚
  if me.IsMarried() == 1 then
    Dialog:Say("你已经与他人结为侠侣了，不能再纳吉" .. szOptMsg)
    return 0
  end

  -- 等级69级
  if me.nLevel < 69 then
    Dialog:Say("你的等级不足69级，不能纳吉。" .. szOptMsg)
    return 0
  end

  -- 俩人组队
  local tbMemberList, nMemberCount = me.GetTeamMemberList()
  if not tbMemberList or nMemberCount ~= 2 then
    Dialog:Say("还是你们两人组队，再进行纳吉比较好吧。" .. szOptMsg)
    return 0
  end

  local pTeamMate = nil
  for _, pMember in pairs(tbMemberList) do
    if pMember.szName ~= me.szName then
      pTeamMate = pMember
    end
  end

  if not pTeamMate then
    return 0
  end

  -- 同性恋
  if me.nSex == pTeamMate.nSex then
    Dialog:Say("性别不符，不能纳吉。" .. szOptMsg)
    return 0
  end

  -- 对方没有结婚
  if pTeamMate.IsMarried() == 1 then
    Dialog:Say("哎，人家已经名花有主了，你还是去找别人吧。" .. szOptMsg)
    return 0
  end

  -- 等级69级
  if pTeamMate.nLevel < 69 then
    Dialog:Say("对方等级不足69级，不能纳吉。" .. szOptMsg)
    return 0
  end

  -- 我已经订婚
  if me.GetTaskStr(Marry.TASK_GROUP_ID, Marry.TASK_QIUHUN_NAME) ~= "" then
    Dialog:Say("你已经确定了纳吉关系，不能再进行纳吉了。" .. szOptMsg)
    return 0
  end

  -- 对方已经订婚
  if pTeamMate.GetTaskStr(Marry.TASK_GROUP_ID, Marry.TASK_QIUHUN_NAME) ~= "" then
    Dialog:Say("对方已经确认了纳吉关系，不能再进行纳吉了。" .. szOptMsg)
    return 0
  end

  -- 亲密度3级
  if me.GetFriendFavorLevel(pTeamMate.szName) < 3 then
    Dialog:Say("你跟对方的亲密度不满3级，无法进行纳吉。" .. szOptMsg)
    return 0
  end

  -- 在附近
  local nNearby = 0
  local tbPlayerList = KPlayer.GetAroundPlayerList(me.nId, 50)
  if tbPlayerList then
    for _, pPlayer in ipairs(tbPlayerList) do
      if pPlayer.szName == pTeamMate.szName then
        nNearby = 1
      end
    end
  end

  if nNearby ~= 1 then
    Dialog:Say("你们距离太远了，再靠近一点，靠近一点。。。" .. szOptMsg)
    return 0
  end

  return 1
end

-- 求婚对话
function tbNpc:OnQiuhun(nItemId)
  if self:CheckQiuhun() ~= 1 then
    return 0
  end

  local tbMemberList, nMemberCount = me.GetTeamMemberList()
  local pTeamMate = nil
  for _, pMember in pairs(tbMemberList) do
    if pMember.szName ~= me.szName then
      pTeamMate = pMember
    end
  end

  local szMsg = string.format("你确定要向<color=green>%s<color>纳吉么？", pTeamMate.szName)
  local tbOpt = {
    { "确定", self.OnConfirmQiuhun, self, me.nId, pTeamMate.nId, nItemId },
    { "我再想想" },
  }

  Dialog:Say(szMsg, tbOpt)
end

-- 确认求婚
function tbNpc:OnConfirmQiuhun(nSuitorId, nTeamMateId, nItemId)
  local pSuitor = KPlayer.GetPlayerObjById(nSuitorId)
  local pTeamMate = KPlayer.GetPlayerObjById(nTeamMateId)

  if not pSuitor or not pTeamMate then
    return 0
  end

  -- 只要使用了求婚卡片，不论对方是否同意都得删除
  local pItem = KItem.GetObjById(nItemId)
  if pItem then
    pItem.Delete(pSuitor)
  end

  local szMsg = string.format("<color=green>%s<color>向你纳吉，要答应么？", pSuitor.szName)
  local tbOpt = {
    { "是的，我答应", self.OnAcceptQiuhun, self, nSuitorId, nTeamMateId },
    { "我拒绝", self.OnRefuseQiuhun, self, nSuitorId, nTeamMateId },
  }

  Setting:SetGlobalObj(pTeamMate)
  Dialog:Say(szMsg, tbOpt)
  Setting:RestoreGlobalObj()
end

-- 接受求婚
function tbNpc:OnAcceptQiuhun(nSuitorId, nTeamMateId)
  local pSuitor = KPlayer.GetPlayerObjById(nSuitorId)
  local pTeamMate = KPlayer.GetPlayerObjById(nTeamMateId)

  if not pSuitor or not pTeamMate then
    return 0
  end

  -- 增加求婚关系
  if pSuitor.nSex == 0 then
    Marry:AddQiuhun(pSuitor, me)
    pSuitor.Msg(string.format("恭喜！纳吉成功，你已经是<color=yellow>%s<color>的心上人了。男方可以去购买典礼礼包，找江津村老月预订典礼了。", pTeamMate.szName))
    pTeamMate.Msg(string.format("恭喜！纳吉成功，你已经是<color=yellow>%s<color>的心上人了。男方可以去购买典礼礼包，找江津村老月预订典礼了。", pSuitor.szName))
  else
    Marry:AddQiuhun(me, pSuitor)
    pSuitor.Msg(string.format("恭喜！纳吉成功，你已经是<color=yellow>%s<color>的心上人了。男方可以去购买典礼礼包，找江津村老月预订典礼了。", pTeamMate.szName))
    pTeamMate.Msg(string.format("恭喜！纳吉成功，你已经是<color=yellow>%s<color>的心上人了。男方可以去购买典礼礼包，找江津村老月预订典礼了。", pSuitor.szName))
  end

  pSuitor.SendMsgToFriend(string.format("您的好友<color=yellow>%s<color>向<color=yellow>%s<color>纳吉成功。", pSuitor.szName, pTeamMate.szName))
  Player:SendMsgToKinOrTong(pSuitor, string.format("向<color=yellow>%s<color>纳吉成功。", pTeamMate.szName))
  pSuitor.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, string.format("与 %s 确定求婚关系", pTeamMate.szName))

  pTeamMate.SendMsgToFriend(string.format("您的好友<color=yellow>%s<color>接受了<color=yellow>%s<color>的纳吉。", pTeamMate.szName, pSuitor.szName))
  Player:SendMsgToKinOrTong(me, string.format("接受了<color=yellow>%s<color>的纳吉。", pSuitor.szName))
  pTeamMate.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, string.format("与 %s 确定求婚关系", pSuitor.szName))

  -- 频道公告
  Dialog:SendBlackBoardMsg(pSuitor, string.format("恭喜你，<color=yellow>%s<color>答应了你的纳吉！", pTeamMate.szName))
  KDialog.NewsMsg(1, Env.NEWSMSG_NORMAL, string.format("<color=green>[%s]<color>答应了<color=green>[%s]<color>的纳吉，让我们衷心地祝福这对才子佳人吧！", pTeamMate.szName, pSuitor.szName))

  Dbg:WriteLog("Marry", "结婚系统", pSuitor.szName, pSuitor.szAccount, pTeamMate.szName, pTeamMate.szAccount, "求婚成功")
end

-- 拒接求婚
function tbNpc:OnRefuseQiuhun(nSuitorId, nTeamMateId)
  local pSuitor = KPlayer.GetPlayerObjById(nSuitorId)
  local pTeamMate = KPlayer.GetPlayerObjById(nTeamMateId)

  if not pSuitor or not pTeamMate then
    return 0
  end

  Dialog:SendBlackBoardMsg(pSuitor, string.format("很遗憾，<color=green>%s<color>拒绝了你的纳吉。", pTeamMate.szName))
end

-- 解除求婚关系
function tbNpc:OnRemoveQiuhun(nSure)
  -- 系统开关
  if Marry:CheckState() ~= 1 then
    return 0
  end

  -- 俩人组队
  local tbMemberList, nMemberCount = me.GetTeamMemberList()
  if not tbMemberList or nMemberCount ~= 2 then
    Dialog:Say("必须男女双方组队，才能来这解除纳吉关系。")
    return 0
  end

  local pTeamMate = nil
  for _, pMember in pairs(tbMemberList) do
    if pMember.szName ~= me.szName then
      pTeamMate = pMember
    end
  end

  if not pTeamMate then
    return 0
  end

  if Marry:CheckQiuhun(me, pTeamMate) ~= 1 then
    Dialog:Say("你们之间不存在纳吉关系，不要来捣乱了。")
    return 0
  end

  if Marry:CheckPreWedding(me.szName) == 1 or Marry:CheckPreWedding(pTeamMate.szName) == 1 then
    Dialog:Say("你们已经预订了典礼，不能再申请解除纳吉关系。")
    return 0
  end

  if not nSure then
    local szMsg = string.format("你确定要和<color=yellow>%s<color>解除纳吉关系吗？你们每人需要花费<color=yellow>10万<color>银两。", pTeamMate.szName)
    local tbOpt = {
      { "确定", self.OnRemoveQiuhun, self, 1 },
      { "我再想想" },
    }
    Dialog:Say(szMsg, tbOpt)
    return 0
  end

  if me.nCashMoney < Marry.CANCEL_QIUHUN_COST then
    Dialog:Say("你身上的银子不足10万，无法申请解除纳吉。")
    return 0
  end

  if pTeamMate.nCashMoney < Marry.CANCEL_QIUHUN_COST then
    Dialog:Say(string.format("%s身上的银子不足10万，无法申请解除纳吉。", pTeamMate.szName))
    return 0
  end

  me.CostMoney(Marry.CANCEL_QIUHUN_COST, Player.emKPAY_EVENT)
  pTeamMate.CostMoney(Marry.CANCEL_QIUHUN_COST, Player.emKPAY_EVENT)

  me.Msg(string.format("你和<color=yellow>%s<color>的纳吉关系已经解除了，扣除手续费<color=yellow>%s<color>银两。", pTeamMate.szName, Marry.CANCEL_QIUHUN_COST))
  pTeamMate.Msg(string.format("你和<color=yellow>%s<color>的纳吉关系已经解除了，扣除手续费<color=yellow>%s<color>银两。", me.szName, Marry.CANCEL_QIUHUN_COST))

  me.RemoveSpeTitle(string.format("%s的心上人", pTeamMate.szName))
  pTeamMate.RemoveSpeTitle(string.format("%s的心上人", me.szName))

  Marry:RemoveQiuhun(me, pTeamMate)

  Dbg:WriteLog("Marry", "结婚系统", me.szName, me.szAccount, pTeamMate.szName, pTeamMate.szAccount, "双方解除求婚")
end

-- 单方面解除求婚关系
function tbNpc:OnSingleRemoveQiuhun(nSure)
  -- 系统开关
  if Marry:CheckState() ~= 1 then
    return 0
  end

  local szQiuhunName = me.GetTaskStr(Marry.TASK_GROUP_ID, Marry.TASK_QIUHUN_NAME)
  if szQiuhunName == "" then
    Dialog:Say("你尚未向其他人纳吉，不需要解除纳吉关系。")
    return 0
  end

  if Marry:CheckPreWedding(me.szName) == 1 then
    Dialog:Say("你已经预订典礼了，不能再申请解除纳吉关系。")
    return 0
  end

  -- 另一方自动触发解除求婚关系
  local szKeyName = Marry.tbProposalBuffer[me.szName]
  if szKeyName and szKeyName == szQiuhunName then
    me.SetTaskStr(Marry.TASK_GROUP_ID, Marry.TASK_QIUHUN_NAME, "")
    if me.nSex == 0 then
      me.RemoveSpeTitle(string.format("%s的心上人", szQiuhunName))
    else
      me.RemoveSpeTitle(string.format("%s的心上人", szQiuhunName))
    end
    me.Msg(string.format("你和<color=yellow>%s<color>的纳吉关系已经解除了。", szQiuhunName))
    Marry:RemoveProposal_GS(me.szName)
    return 0
  end

  if not nSure then
    local szMsg = "你决心单方面解除纳吉关系么？你需要花费<color=yellow>20万<color>银两。"
    local tbOpt = {
      { "确定", self.OnSingleRemoveQiuhun, self, 2 },
      { "我再想想" },
    }
    Dialog:Say(szMsg, tbOpt)
    return 0
  end

  if me.nCashMoney < Marry.SINGLE_QIUHUN_COST then
    Dialog:Say("你身上的银子不足20万，无法申请单方面解除纳吉关系。")
    return 0
  end

  me.CostMoney(Marry.SINGLE_QIUHUN_COST, Player.emKPAY_EVENT)
  me.SetTaskStr(Marry.TASK_GROUP_ID, Marry.TASK_QIUHUN_NAME, "")
  me.Msg(string.format("你和<color=yellow>%s<color>的纳吉关系已经单方面解除了，扣除手续费<color=yellow>%s<color>银两。", szQiuhunName, Marry.SINGLE_QIUHUN_COST))

  if me.nSex == 0 then
    me.RemoveSpeTitle(string.format("%s的心上人", szQiuhunName))
  else
    me.RemoveSpeTitle(string.format("%s的心上人", szQiuhunName))
  end

  KPlayer.SendMail(szQiuhunName, "单方面解除纳吉关系", string.format("很遗憾，<color=gold>%s<color>已经单方面解除了与您的纳吉关系。<color=gold>您下线后将自动解除与此人的纳吉关系。您也可以去找江津村红姨立即解除。<color>\n<color=green>人生难免风浪，打起精神来！祝您幸福！<color>", me.szName))

  Marry:AddProposal_GS(szQiuhunName, me.szName)

  Dbg:WriteLog("Marry", "结婚系统", me.szName, me.szAccount, "单方解除求婚")
end

-- 解除婚姻关系
function tbNpc:OnDivorce(nSure)
  -- 系统开关
  if Marry:CheckState() ~= 1 then
    return 0
  end

  -- 俩人组队
  local tbMemberList, nMemberCount = me.GetTeamMemberList()
  if not tbMemberList or nMemberCount ~= 2 then
    Dialog:Say("必须男女双方组队，才能来这解除侠侣关系。")
    return 0
  end

  local pTeamMate = nil
  for _, pMember in pairs(tbMemberList) do
    if pMember.szName ~= me.szName then
      pTeamMate = pMember
    end
  end

  if not pTeamMate then
    return 0
  end

  if me.IsAccountLock() ~= 0 or pTeamMate.IsAccountLock() ~= 0 then
    Dialog:Say("你们的账号处于锁定状态，无法申请解除。")
    return 0
  end

  if me.IsMarried() ~= 1 or pTeamMate.IsMarried() ~= 1 or me.GetCoupleName() ~= pTeamMate.szName then
    Dialog:Say("对不起，你们并非侠侣关系，无法申请解除。")
    return 0
  end

  if me.GetTask(Marry.TASK_GROUP_ID, Marry.TASK_DIVORCE_INTERVAL) == 1 then
    Dialog:Say("对不起，每月只有一次申请解除侠侣关系的机会。")
    return 0
  end

  local nTimes = me.GetTask(Marry.TASK_GROUP_ID, Marry.TASK_DIVORCE_TIMES)
  if nTimes > Marry.MAX_DIVORCE_TIMES then
    nTimes = Marry.MAX_DIVORCE_TIMES
  end
  local nCostCount = 2 ^ nTimes
  if not nSure then
    local szMsg = string.format("你确定要和<color=yellow>%s<color>解除侠侣关系吗？本次申请将扣除<color=yellow>%s个<color>破碎之心。", pTeamMate.szName, nCostCount)
    local tbOpt = {
      { "确定", self.OnDivorce, self, 1 },
      { "我再想想" },
    }
    Dialog:Say(szMsg, tbOpt)
    return 0
  end

  local nFindItem = 0
  local tbFind = me.FindItemInBags(18, 1, 719, 1)
  for _, tbItem in pairs(tbFind or {}) do
    if tbItem.pItem then
      nFindItem = nFindItem + 1
    end
  end

  if nFindItem < nCostCount then
    Dialog:Say("对不起，请在月影商店购买破碎的心，再来解除侠侣关系。")
    return 0
  end

  local nCostItem = 0
  for _, tbItem in pairs(tbFind or {}) do
    if tbItem.pItem then
      me.DelItem(tbItem.pItem)
      nCostItem = nCostItem + 1
      if nCostItem >= nCostCount then
        break
      end
    end
  end

  Marry:DoDivorce(me, pTeamMate.szName)
  Marry:DoDivorce(pTeamMate, me.szName)

  Relation:DelRelation_GS(me.szName, pTeamMate.szName, Player.emKPLAYERRELATION_TYPE_COUPLE, 1)
  Dbg:WriteLog("Marry", "结婚系统", me.szName, me.szAccount, pTeamMate.szName, pTeamMate.szAccount, "双方解除婚姻关系")
end

-- 单方面离婚
function tbNpc:OnSingleDivorce(nSure)
  -- 系统开关
  if Marry:CheckState() ~= 1 then
    return 0
  end

  if me.IsAccountLock() ~= 0 then
    Dialog:Say("你的账号处于锁定状态，无法申请解除。")
    return 0
  end

  if me.IsMarried() ~= 1 then
    Dialog:Say("你尚未与他人结成侠侣，无法申请解除。")
    return 0
  end

  local szCoupleName = me.GetCoupleName()
  local szKeyName = Marry.tbDivorceBuffer[me.szName]
  if szKeyName then
    Marry:DoDivorce(me, szCoupleName)
    Marry:RemoveDivorce_GS(me.szName)
    return 0
  end

  if me.GetTask(Marry.TASK_GROUP_ID, Marry.TASK_DIVORCE_INTERVAL) == 1 then
    Dialog:Say("对不起，每月只有一次申请解除侠侣关系的机会。")
    return 0
  end

  local nTimes = me.GetTask(Marry.TASK_GROUP_ID, Marry.TASK_DIVORCE_TIMES)
  if nTimes > Marry.MAX_DIVORCE_TIMES then
    nTimes = Marry.MAX_DIVORCE_TIMES
  end

  local nCostCount = 2 ^ nTimes * 2
  if not nSure then
    local szMsg = string.format("你决心单方面解除侠侣关系么？本次申请将扣除<color=yellow>%s个<color>破碎之心。", nCostCount)
    local tbOpt = {
      { "确定", self.OnSingleDivorce, self, 1 },
      { "我再想想" },
    }
    Dialog:Say(szMsg, tbOpt)
    return 0
  end

  local nFindItem = 0
  local tbFind = me.FindItemInBags(18, 1, 719, 1)
  for _, tbItem in pairs(tbFind or {}) do
    if tbItem.pItem then
      nFindItem = nFindItem + 1
    end
  end

  if nFindItem < nCostCount then
    Dialog:Say("对不起，请在月影商店购买破碎的心，再来解除侠侣关系。")
    return 0
  end

  local nCostItem = 0
  for _, tbItem in pairs(tbFind or {}) do
    if tbItem.pItem then
      me.DelItem(tbItem.pItem)
      nCostItem = nCostItem + 1
      if nCostItem >= nCostCount then
        break
      end
    end
  end

  local pCouple = KPlayer.GetPlayerByName(szCoupleName)
  if pCouple then
    Marry:DoDivorce(pCouple, me.szName)
  else
    Marry:AddDivorce_GS(szCoupleName, me.szName)
  end

  Marry:DoDivorce(me, szCoupleName)
  Relation:DelRelation_GS(me.szName, szCoupleName, Player.emKPLAYERRELATION_TYPE_COUPLE, 1)
  KPlayer.SendMail(szCoupleName, "单方面解除侠侣关系", string.format("很遗憾，<color=gold>%s<color>已经单方面解除了与您的侠侣关系。\n<color=green>人生难免风浪，打起精神来！祝您幸福！<color>", me.szName))
  Dbg:WriteLog("Marry", "结婚系统", me.szName, me.szAccount, "单方面解除婚姻关系")
end

function Marry:DoDivorce(pPlayer, szCoupleName)
  if not pPlayer then
    return 0
  end

  -- 清除婚期
  Marry:RemovePlayerWedding(pPlayer.szName)
  pPlayer.RemoveSpeTitle(string.format("%s的知己", szCoupleName))
  pPlayer.Msg(string.format("你和<color=yellow>%s<color>的侠侣关系已经解除了。", szCoupleName))

  -- 任务变量门清
  for i = 1, 24 do
    pPlayer.SetTask(Marry.TASK_GROUP_ID, i, 0)
  end

  local nTimes = pPlayer.GetTask(Marry.TASK_GROUP_ID, Marry.TASK_DIVORCE_TIMES)
  if nTimes < Marry.MAX_DIVORCE_TIMES then
    nTimes = nTimes + 1
  end
  pPlayer.SetTask(Marry.TASK_GROUP_ID, Marry.TASK_DIVORCE_TIMES, nTimes)
  pPlayer.SetTask(Marry.TASK_GROUP_ID, Marry.TASK_DIVORCE_INTERVAL, 1)
end
