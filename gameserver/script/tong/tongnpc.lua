-------------------------------------------------------------------
--File: tongnpc.lua
--Author: lbh
--Date: 2007-9-19 23:21
--Describe: 帮会相关npc对话逻辑
-------------------------------------------------------------------
if not Tong then --调试需要
  Tong = {}
  print(GetLocalDate("%Y\\%m\\%d  %H:%M:%S") .. " build ok ..")
end

function Tong:DlgCreateTong(bConfirm, szTong, nCamp, bAccept)
  if me.IsCaptain() ~= 1 then
    Dialog:Say("你不是队长，必须由队长来创建！")
    return 0
  end
  local nTeamId = me.nTeamId
  local anPlayerId, nPlayerNum = KTeam.GetTeamMemberList(nTeamId)
  if not anPlayerId or not nPlayerNum or nPlayerNum < 3 then
    Dialog:Say("必须三个以上家族族长组队，才能到我这里报名创建帮会。")
    return 0
  end
  if me.dwTongId ~= 0 then
    Dialog:Say("你已经加入了一个帮会，不能再参与创建帮会。")
    return 0
  end
  local anKinId = {}
  local nSelfKinId, nSelfMemberId = me.GetKinMember()
  local cSelfKin = KKin.GetKin(nSelfKinId)
  if not cSelfKin or cSelfKin.GetCaptain() ~= nSelfMemberId then
    me.Msg("你不是家族族长，不能参与创建帮会！")
    return 0
  end
  table.insert(anKinId, nSelfKinId)
  local aLocalPlayer, nLocalPlayerNum = me.GetTeamMemberList()
  --TODO:判断是否在周围
  if nPlayerNum ~= nLocalPlayerNum then
    Dialog:Say("队伍里所有人必须一同前来，才能创建帮会！")
    return 0
  end
  -- by jiazhenwei  金牌网吧建立帮会80w
  local nMoneyCreat = self.CREATE_TONG_MONEY
  if SpecialEvent.tbGoldBar:CheckPlayer(me) == 1 then
    nMoneyCreat = 800000
  end
  --end
  --创建扣取金钱说明
  if bConfirm ~= 1 then
    Dialog:Say(string.format("创建帮会需先交纳银两%s万，同时在2周的考验期内使帮会建设资金>=1000万，否则帮会将创建失败，<color=yellow>预先交纳的100万以及累积的帮会资金将不会退还，<color>你确定要创建吗？", nMoneyCreat), { { "是的，我要创建", self.DlgCreateTong, self, 1 }, { "让我再考虑一下" } })
    return 0
  end
  if me.nCashMoney < nMoneyCreat then
    Dialog:Say("你身上银两不足<color=yellow>" .. (nMoneyCreat / 10000) .. "万<color>，请带够了钱再来吧。")
    return 0
  end
  for i, cPlayer in ipairs(aLocalPlayer) do
    if cPlayer.nPlayerIndex ~= me.nPlayerIndex then
      if cPlayer.dwTongId ~= 0 then
        Dialog:Say("已加入帮会的家族族长不能参与创建，请让不符合条件的人离队然后找齐合适的人之后再过来找我。")
        return 0
      end
      local nKinId, nMemberId = cPlayer.GetKinMember()
      if Kin:CheckSelfRight(nKinId, nMemberId, 1) ~= 1 then
        me.Msg("队伍中所有成员必须为家族族长（且没被罢免），请让不符合条件的人离队然后找齐合适的人之后再过来找我。")
        return 0
      end
      table.insert(anKinId, nKinId)
    end
  end

  if not szTong or szTong == "" then
    me.CallClientScript({ "Tong:ShowCreateTongDlg" })
    return 0
  end

  ---------------------------------------------------------------------------------------------------------
  local nReturn = 1
  local nKinFund = 0
  for _k, _v in pairs(anKinId) do
    nKinFund = nKinFund + Kin:GetTotalKinStock(_v)
  end

  local nStockPersent = 1
  if not bAccept or bAccept ~= 1 then
    if nKinFund > 0 and nKinFund > self.MAX_BUILD_FUND then
      nStockPersent = self.MAX_BUILD_FUND / nKinFund
      local nTemp = math.floor(nStockPersent * 100)
      local szMsg = "你们申请创建<color=yellow>" .. szTong .. "<color>帮会\n"
      szMsg = szMsg .. "由于你们几个家族的目前总共的建设资金已近超过了帮会的建设资金的上限要求，所以在帮会创建后"
      szMsg = szMsg .. "，你们几个家族所持有的个人资产将会减少。减少为目前的 <color=yellow> " .. nTemp .. "%<color> ！"

      for i, cPlayer in ipairs(aLocalPlayer) do
        local szTemp = szMsg
        szTemp = szTemp .. " \n由队长<color=yellow>【" .. me.szName .. "】<color> 确认！"
        cPlayer.Msg(szTemp)
      end

      local function SayWhat(aPlayer)
        for i, cPlayer in ipairs(aPlayer) do
          local szTemp = " 队长 <color=yellow>【" .. me.szName .. "】<color> 取消了建立帮会！"
          cPlayer.Msg(szTemp)
        end
      end

      Dialog:Say(szMsg, {
        { "创建帮会", self.DlgCreateTong, self, bConfirm, szTong, nCamp, 1 },
        { "取消", SayWhat, aLocalPlayer },
      })
      return 0
    end
  end
  ---------------------------------------------------------------------------------------------------------

  local nRet = self:CreateTong_GS1(anKinId, szTong, nCamp, me.nId)
  if nRet ~= 1 then
    local szMsg = "帮会创建失败！"
    if nRet == -1 then
      szMsg = szMsg .. "输入的帮会名字长度不符合要求（3～6个汉字）！"
    elseif nRet == -2 then
      szMsg = szMsg .. "名称只能包含中文简繁体字及· 【 】符号！"
    elseif nRet == -3 then
      szMsg = szMsg .. "对不起，您输入的帮会名称包含敏感字词，请重新设定"
    elseif nRet == -4 then
      szMsg = szMsg .. "帮会名已被占用！"
    elseif nRet == -5 then
      szMsg = szMsg .. "队伍中有成员已有帮会！"
    end
    Dialog:Say(szMsg)
    return 0
  end
  return 1
end

function Tong:DlgChangeCamp(nCamp)
  local nTongId = me.dwTongId
  if nTongId == 0 then
    Dialog:Say("你没有帮会，不能更改帮会阵营。")
    return 0
  end
  local nKinId, nMemberId = me.GetKinMember()
  if self:CheckSelfRight(nTongId, nKinId, nMemberId, self.POW_CAMP) ~= 1 then
    Dialog:Say("你没有更改阵营的权力。")
    return 0
  end
  if not nCamp then
    Dialog:Say("修改阵营需要消耗" .. (Tong.CHANGE_CAMP / 10000) .. "万建设资金，请选择要改变的阵营:", {
      { "宋方", self.DlgChangeCamp, self, 1 },
      { "金方", self.DlgChangeCamp, self, 2 },
      { "中立", self.DlgChangeCamp, self, 3 },
      { "让我再考虑一下" },
    })
  else
    self:ChangeCamp_GS1(nCamp)
  end
end

-- 领取分红
function Tong:DlgTakeStock(bConfirm)
  local nTongId = me.dwTongId
  local pTong = KTong.GetTong(nTongId)
  if not pTong then
    Dialog:Say("你没有帮会，不能领取分红。")
    return 0
  end

  local nTotalFund = pTong.GetBuildFund()
  local nTotalStock = pTong.GetTotalStock()
  local nKinId, nMemberId = me.GetKinMember()
  local pKin = KKin.GetKin(nKinId)
  local pMember = pKin.GetMember(nMemberId)
  local nPersonalStock = pMember.GetPersonalStock()
  local nCurWeek = tonumber(os.date("%Y%W", GetTime()))
  if nTotalFund == 0 or nTotalStock == 0 or nPersonalStock == 0 then
    Dialog:Say("你没有可领取的分红。")
    return 0
  end
  local nTakePercent = pTong.GetLastTakeStock()
  if nTakePercent <= 0 then
    Dialog:Say("您的帮会上周没有指定分红比例。本周不允许分红。")
    return 0
  end
  local nWeeks = me.GetTask(self.TONG_TASK_GROUP, self.TONG_TAKE_STOCK_WEEKS)
  if nWeeks == nCurWeek then
    Dialog:Say("你已经领取过本周的分红了。")
    return 0
  end
  local szMsg = ""
  local tbOpt = {}
  local nTakeStock = math.floor(nTakePercent * nPersonalStock / 100)
  local nTakeMoney = math.floor(nTakeStock * nTotalFund / nTotalStock)
  local nMoney = math.floor(nPersonalStock * nTotalFund / nTotalStock)
  if pTong.GetBuildFund() < self.MIN_BUILDFUND then
    Dialog:Say("你的帮会建设资金少于" .. self.MIN_BUILDFUND .. "，不能领取分红。")
    return 0
  end
  if not bConfirm then
    szMsg = string.format(
      [[  你们帮主将本周的分红比例设定为<color=green>%d%%<color>。据此，你本周可以领取到帮会的分红为<color=green>%d绑定银两<color>。
			  你可以选择直接领取本次的分红，领取后，你的个人资产和股权比例会相应的减少。]],
      nTakePercent,
      nTakeMoney
    )
    tbOpt = {
      { "领取分红", self.DlgTakeStock, self, 1 },
      { "结束对话。" },
    }
  else
    if bConfirm and bConfirm == 1 then
      if me.GetBindMoney() + nTakeMoney > me.GetMaxCarryMoney() then
        Dialog:Say("对不起，您携带的银两已达上限，请整理后再来领取。")
        return 0
      end
      me.SetTask(self.TONG_TASK_GROUP, self.TONG_TAKE_STOCK_WEEKS, nCurWeek)
      return GCExcute({ "Tong:TakeStock_GC", nTongId, nKinId, nMemberId })
    end
  end
  Dialog:Say(szMsg, tbOpt)
end

function Tong:DlgGreatBonus()
  local pTong = KTong.GetTong(me.dwTongId)
  if not pTong then
    Dialog:Say("你还没有帮会")
    return 0
  end
  Dialog:Say("帮会优秀成员奖励是<color=green>" .. pTong.GetWeekGreatBonus() .. "<color>", {
    { "接受帮会奖励", Tong.ReceiveGreatBonus, Tong },
    { "设置帮会奖励基金比例", Tong.AdjustGreatBonusPercent, Tong },
    { "关闭" },
  })
end
