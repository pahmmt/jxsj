-------------------------------------------------------------------
--File: kinnpc.lua
--Author: lbh
--Date: 2007-7-4 11:47
--Describe: 帮会相关npc对话逻辑
-------------------------------------------------------------------
if not Kin then --调试需要
  Kin = {}
  print(GetLocalDate("%Y/%m/%d/%H/%M/%S") .. " build ok ..")
end

Kin.AwardCount = {
  { { 1, 1, 2, 2, 3 }, { 1, 1, 2, 3, 4 }, { 1, 2, 3, 4, 5 } },
  { { 1, 2, 4, 6, 9 }, { 1, 2, 4, 8, 12 }, { 1, 3, 6, 10, 15 } },
}

function Kin:DlgCreateKin(szKin, nCamp)
  if me.GetCamp() == 0 then
    Dialog:Say("新手不能创建家族！")
    return 0
  end
  if me.IsCaptain() ~= 1 then
    Dialog:Say("你不是队长，必须由队长来创建！")
    return 0
  end
  local nTeamId = me.nTeamId
  local anPlayerId, nPlayerNum = KTeam.GetTeamMemberList(nTeamId)
  if not anPlayerId or not nPlayerNum or nPlayerNum < 3 or me.nLevel < self.MIN_PLAYER_LEVEL then
    Dialog:Say(string.format("必须三个%s级以上玩家组队，才能到我这里报名创建家族", self.MIN_PLAYER_LEVEL))
    return 0
  end
  local aLocalPlayer, nLocalPlayerNum = me.GetTeamMemberList()
  --TODO:判断是否在周围
  if nPlayerNum ~= nLocalPlayerNum then
    Dialog:Say("队伍里所有人必须一同前来，才能创建家族！")
    return 0
  end
  -- by jiazhenwei  金牌网吧建立家族5w
  local nMoneyCreat = self.CREATE_KIN_MONEY
  if SpecialEvent.tbGoldBar:CheckPlayer(me) == 1 then
    nMoneyCreat = math.min(nMoneyCreat, 50000)
  end
  --end
  --by jiazhenwei 某个日期之前建立家族折扣(不可以和物品及金牌网吧的叠加，取最小值)
  local tbBuffer = GetGblIntBuf(GBLINTBUF_LOGIN_AWARD, 0)
  if not tbBuffer or type(tbBuffer) ~= "table" then
    tbBuffer = {}
  end
  local nMoneyDiscount = 0
  if tbBuffer[2] and tbBuffer[2][1] and Lib:GetDate2Time(tbBuffer[2][1]) > GetTime() then
    nMoneyDiscount = math.floor(self.CREATE_KIN_MONEY * tbBuffer[2][2] / 10000)
    nMoneyCreat = math.min(nMoneyCreat, nMoneyDiscount)
  end
  --end
  if me.nCashMoney < nMoneyCreat then
    Dialog:Say("创建家族需交纳<color=yellow>" .. nMoneyCreat .. "<color>，请带够了钱再来吧。")
    return 0
  end
  local function _FindIndex(nId)
    for i, v in ipairs(anPlayerId) do
      if v == nId then
        return i
      end
    end
  end
  local anStoredRepute = {}
  for i, cPlayer in ipairs(aLocalPlayer) do
    if cPlayer.nPlayerIndex ~= me.nPlayerIndex then
      if cPlayer.nLevel < self.MIN_PLAYER_LEVEL then
        Dialog:Say(string.format("队伍中有%s级以下的队员，不能创建！", self.MIN_PLAYER_LEVEL))
        return 0
      end
      if cPlayer.GetCamp() == 0 then
        Dialog:Say("队伍中有新手，不能创建家族！")
        return 0
      end
      if EventManager.IVER_bOpenTiFu ~= 1 then
        local nFavor = me.GetFriendFavor(cPlayer.szName)
        if not nFavor or nFavor < 100 then
          Dialog:Say("你与队伍中各个队员的亲密度必须都在2级以上，才能创建！")
          return 0
        end
      end
      local nKinId = cPlayer.GetKinMember()
      if nKinId and nKinId ~= 0 then
        Dialog:Say("你队伍中有某个家族的成员，不能创建！")
        return 0
      end
    end
    local j = _FindIndex(cPlayer.nId)
    if not j then
      return 0
    end
    --按anPlayerId的次序记录缓存的江湖威望
    anStoredRepute[j] = cPlayer.nPrestige
  end
  if not szKin or szKin == "" then
    me.CallClientScript({ "Kin:ShowCreateKinDlg" })
    return 0
  end
  local nRet = self:CreateKin_GS1(anPlayerId, anStoredRepute, szKin, nCamp, me.nId)
  if nRet ~= 1 then
    local szMsg = "家族创建失败！"
    if nRet == -1 then
      szMsg = szMsg .. "输入的家族名字长度不符合要求（3～6个汉字）！"
    elseif nRet == -2 then
      szMsg = szMsg .. "名称只能包含中文简繁体字及· 【 】符号！"
    elseif nRet == -3 then
      szMsg = szMsg .. "对不起，您输入的家族名称包含敏感字词，请重新设定"
    elseif nRet == -4 then
      szMsg = szMsg .. "家族名已被占用！"
    elseif nRet == -5 then
      szMsg = szMsg .. "队伍中有成员已有家族！"
    end
    Dialog:Say(szMsg)
    return 0
  end
  return 1
end

-- 获取要领取的奖励索引
function Kin:GetAwardIndex()
  local nFigure = me.nKinFigure
  local nFirstIndex = 1
  local nSecIndex = 1
  if 1 == nFigure then -- 族长
    nFirstIndex = 2
  else
    nFirstIndex = 1
  end
  local nKinId = me.dwKinId
  local cKin = KKin.GetKin(nKinId)
  local nLastTaskLevel = cKin.GetLastTaskLevel()
  if Kin.TASK_LEVEL_LOW == nLastTaskLevel then -- 上周周任务目标等级
    nSecIndex = 1
  elseif Kin.TASK_LEVEL_MID == nLastTaskLevel then
    nSecIndex = 2
  elseif Kin.TASK_LEVEL_HIGH == nLastTaskLevel then
    nSecIndex = 3
  end
  return nFirstIndex, nSecIndex
end

-- 家族活动相关
function Kin:DlgAboutWeeklyAction()
  local szMsg = "鉴于各位对家族做出了卓越贡献，每周都会论功行赏，所以大家赶快行动起来吧。\n对了，你是来干什么的？"
  Dialog:Say(szMsg, {
    { "修改家族周活动目标等级", self.DlgModifyTaskLevel, self },
    { "领取家族周活动目标奖励", self.DlgGetWeeklyActionAward, self, 0 },
  })
end

-- 修改家族周活动目标等级
function Kin:DlgModifyTaskLevel()
  local szMsg = "初级家族周活动目标适合平均等级在50-79级之间的家族选择；中级周活动目标时候平均等级在80-89级之间的家族选择；高级家族周活动目标适合平均等级超过90级的家族选择。" .. "当然，随着等级的提高，奖励也会相应增加。现在要修改吗？如果修改了将从下周开始执行。"
  Dialog:Say(szMsg, {
    { "修改为初级家族周活动目标", self.ModifyLevel, self, Kin.TASK_LEVEL_LOW },
    { "修改为中级家族周活动目标", self.ModifyLevel, self, Kin.TASK_LEVEL_MID },
    { "修改为高级家族周活动目标", self.ModifyLevel, self, Kin.TASK_LEVEL_HIGH },
    { "我再考虑一下" },
  })
end

function Kin:ModifyLevel(nTaskLevel)
  local nKinId, nMemberId = me.GetKinMember()
  if self:CheckSelfRight(nKinId, nMemberId, 2) ~= 1 then
    Dialog:Say("你没有权限修改这个内容或者权限被冻结，请让你们族长或副族长来吧。")
    return 0
  end

  if nTaskLevel ~= Kin.TASK_LEVEL_LOW and nTaskLevel ~= Kin.TASK_LEVEL_MID and nTaskLevel ~= Kin.TASK_LEVEL_HIGH then
    return 0
  end

  local szMsg = ""
  if 0 == TimeFrame:GetState("OpenLevel89") and (nTaskLevel == Kin.TASK_LEVEL_MID or nTaskLevel == Kin.TASK_LEVEL_HIGH) then
    szMsg = szMsg .. "目前本服没有开启89级上限，不能把周活动目标等级修改为中级或高级。"
  elseif 0 == TimeFrame:GetState("OpenLevel99") and nTaskLevel == Kin.TASK_LEVEL_HIGH then
    szMsg = szMsg .. "目前本服没有开启99级上限，不能把周活动目标等级修改为高级。"
  end
  if "" ~= szMsg then
    Dialog:Say(szMsg)
    return 0
  end
  local nKinId = me.dwKinId
  local cKin = KKin.GetKin(nKinId)
  GCExcute({ "Kin:SetNewTaskLevel_GC", nKinId, nTaskLevel })
  local szLevel = ""
  if Kin.TASK_LEVEL_LOW == nTaskLevel then
    szLevel = szLevel .. "初级"
  elseif Kin.TASK_LEVEL_MID == nTaskLevel then
    szLevel = szLevel .. "中级"
  elseif Kin.TASK_LEVEL_HIGH == nTaskLevel then
    szLevel = szLevel .. "高级"
  end
  szMsg = "您所属家族的周活动目标等级已经成功修改为<color=yellow>" .. szLevel .. "<color>，将于下周生效。"
  Dialog:Say(szMsg)
end
-- 家族更换阵营
function Kin:DlgChangeCamp(nCamp)
  local nKinId, nExcutorId = me.GetKinMember()
  local nRet, cKin = self:CheckSelfRight(nKinId, nExcutorId, 1)

  if nRet ~= 1 then
    Dialog:Say("只有家族族长才能更换家族阵营")
    return 0
  end
  if cKin.GetBelongTong() ~= 0 then
    Dialog:Say("家族在帮会中，不能更改家族阵营！")
    return 0
  end
  local nDate = tonumber(Lib:GetLocalDay(GetTime()))
  if cKin.GetChangeCampDate() == nDate then
    Dialog:Say("一天只能更改家族阵营一次，今天已经更改过一次阵营了。")
    return 0
  end
  if me.nCashMoney < self.CHANGE_CAMP then
    Dialog:Say("修改阵营需要交纳<color=red>" .. (self.CHANGE_CAMP / 10000) .. "万<color>剑侠币，你身上没有足够的剑侠币！")
    return 0
  end
  if not nCamp then
    Dialog:Say("修改阵营需要交纳<color=red>" .. (self.CHANGE_CAMP / 10000) .. "万<color>剑侠币，请选择要改变的阵营:", {
      { "宋方", self.DlgChangeCamp, self, 1 },
      { "金方", self.DlgChangeCamp, self, 2 },
      { "中立", self.DlgChangeCamp, self, 3 },
      { "让我再考虑一下" },
    })
  else
    if cKin.GetCamp() == nCamp then
      Dialog:Say("你的家族已经是属于该阵营，不需要更换！")
      return 0
    end
    -- 先扣钱了……GC挂了会导致吞钱~写个log吧
    me.CostMoney(self.CHANGE_CAMP, Player.emKPAY_KIN_CAMP)
    Dbg:WriteLog("家族", "扣取更换阵营费用" .. self.CHANGE_CAMP, "角色名:" .. me.szName, "帐号:" .. me.szAccount, "家族ID:" .. nKinId)
    GCExcute({ "Kin:ChangeCamp_GC", nKinId, nExcutorId, nCamp })
  end
end

-- 家族令牌相关选择
function Kin:DlgKinExp()
  local nKinId, nMemberId = me.GetKinMember()
  if nKinId == 0 then
    Dialog:Say("你还没加入家族")
  end

  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end

  -- 判断需不需要收费给牌子 如果没设置预定时间，则不用收费，否则则要收费清空预定时间再给牌子
  local tbSay = {}
  if cKin.GetKinBuildFlagOrderTime() == 0 then
    table.insert(tbSay, { "领取家族令牌", self.DlgGetKinExp, self, 0 })
  else
    table.insert(tbSay, { "修改家族插旗活动时间以及地点", self.DlgChangBuildFlagSetting, self, 0 })
  end
  table.insert(tbSay, { "结束对话" })

  Dialog:Say("为了您更方便的开启家族插旗活动，在您领取家族令牌并使用它的时候，可以设置以后自动开启家族插旗活动的时间。当然，如果不满意已经设置的时间，您可以修改它，当然修改时我们会收取一点手续费。那么，现在您想干什么呢？", tbSay)
end

-- 家族插旗时间修改
function Kin:DlgChangBuildFlagSetting(bConfirm)
  local nKinId, nMemberId = me.GetKinMember()
  if nKinId == 0 then
    Dialog:Say("你还没加入家族")
  end

  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    return 0
  end

  local nRet, cKin = self:CheckSelfRight(nKinId, nMemberId, 2)
  if nRet ~= 1 then
    Dialog:Say("只有族长或副族长才能领取家族令牌!")
    return 0
  end

  local nTime = GetTime()
  local nNowDay = tonumber(os.date("%m%d", nTime))

  -- 如果今天已经领过了
  if cKin.GetGainExpState() == nNowDay then
    Dialog:Say("你的家族今天已经领取过家族令牌了, 如果你想修改的话，请明天再来领吧。")
    return 0
  end

  if bConfirm ~= 1 then
    Dialog:Say("修改这种大型活动的时间和地点是很劳民伤财的，所以请您准备好100000两银两再来吧。", { { "我带来了足够的银两", self.ConfirmBuildFlagSetting, self }, { "我还是先去考虑考虑吧" } })
    return 0
  end

  -- 如果包包不足
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("你的背包空间不足!")
    return 0
  end

  if me.CostMoney(100000, Player.emKPAY_BUILD_FLAG_TIME) ~= 1 then
    me.Msg("修改这种大型活动的时间和地点是很劳民伤财的，所以请您准备好100000两银两再来吧。")
    return 0
  end

  Dbg:WriteLog("Kin", "PlayerID:" .. me.nId, "Account:" .. me.szAccount .. "修改插旗预定时间花费：100000银两")

  return GCExcute({ "Kin:ChangeKinExpState_GC", me.nId, nKinId, nMemberId })
end

function Kin:ConfirmBuildFlagSetting()
  Dialog:Say("您确定要改？不会后悔？", { { "是的，我不会后悔", self.DlgChangBuildFlagSetting, self, 1 }, { "我后悔了" } })
end

-- 家族令牌的领取
function Kin:DlgGetKinExp(bConfirm)
  local nKinId, nMemberId = me.GetKinMember()
  if nKinId == 0 then
    Dialog:Say("你还没加入家族")
    return 0
  end

  local nRet, cKin = self:CheckSelfRight(nKinId, nMemberId, 2)
  if nRet ~= 1 then
    Dialog:Say("只有族长或副族长才能领取家族令牌!")
    return 0
  end

  local nTime = GetTime()
  local nNowDay = tonumber(os.date("%m%d", nTime))

  --  家族已经领取过了的情况要重新处理,领过了但没设置时间 和 领过了并设置了时间的要分开处理
  local nOrderTime = cKin.GetKinBuildFlagOrderTime()
  if bConfirm ~= 1 and cKin.GetGainExpState() == nNowDay then
    Dialog:Say("你的家族已经领取过了。请尽快设置家族插旗活动的时间及地点")
    return 0
  end

  -- 还没领
  if bConfirm ~= 1 and cKin.GetGainExpState() ~= nNowDay then
    Dialog:Say("在您使用“家族令牌”的同时，请设置自动开启家族插旗活动的时间，地点我们会自动帮您记录，以便今后为您的家族自动开启这项活动。", { { "是的，我要领取", self.DlgGetKinExp, Kin, 1 }, { "等下再来领取" } })
    return 0
  end

  -- 如果包包不足
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("你的背包空间不足!")
    return 0
  end

  return GCExcute({ "Kin:GetKinLingPai_GC", nKinId, nMemberId })
end

function Kin:DlgShowKinRecruitmentList()
  me.CallClientScript({ "UiManager:OpenWindow", "UI_KINRCM_LIST" })
end
