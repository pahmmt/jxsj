-- 文件名　：plantform_npc.lua
-- 创建者　：jiazhenwei
-- 创建时间：2011-09-20 20:20:24
-- 功能    ：无差别竞技

local tbNpc = NewEPlatForm.tbNpc or {}
NewEPlatForm.tbNpc = tbNpc
tbNpc.tbMsg = {
  "家族趣味竞技活动还没开启，敬请期待。",
  "本届家族趣味活动为：<color=yellow>%s<color>\n您已经累计的参加次数：<color=yellow>%s<color>\n本月已经参加的场次数：<color=yellow>%s/24<color>\n",
}

function tbNpc:OnDialog()
  Player.tbOnlineExp:CloseOnlineExp()
  NewEPlatForm:ChangeEventCount(me)
  local nCount = NewEPlatForm:GetPlayerEventCount(me)
  local nAllCount = NewEPlatForm:GetPlayerTotalCount(me)
  local nMacthType = NewEPlatForm:GetMacthType()
  local tbMacth = NewEPlatForm:GetMacthTypeCfg(nMacthType)
  local nReturn, szMsgInFor = self:CreateMsg(me)
  local szMsg = ""
  if tbMacth then
    szMsg = string.format(self.tbMsg[2], tbMacth.szName, nCount, nAllCount)
    if nReturn == 0 then
      szMsg = szMsg .. "\n<color=green>当前活动状态：\n" .. szMsgInFor .. "<color>"
    elseif nReturn == 2 then
      szMsg = szMsg .. "\n<color=red>很遗憾，您暂时没有参赛资格！\n请检查您的等级、是否有家族、比赛次数和比赛道具！<color>"
    elseif nReturn == 1 then
      szMsg = szMsg .. "\n<color=green>" .. szMsgInFor .. "<color>"
    end
  else
    szMsg = self.tbMsg[1]
  end

  local tbOpt = {
    { "参加家族趣味竞技", self.AttendGame, self, nMacthType },
    { "领取家族月度奖励", NewEPlatForm.GetPlayerAward_Month, NewEPlatForm },
    { "【银两】活动道具商店", self.BuyEventItem, self },
    { "【绑定银两】活动道具商店", self.BuyEventItem, self, 1 },
    { "购买家族竞技声望装备", self.BuyReputeItem, self },
    { "购买民族大团圆声望鞋子", self.BuyReputeItem, self, 1 },
    { "查询活动相关", self.Query, self },
    { "结束对话" },
  }
  local nSec = tonumber(KGblTask.SCGetDbTaskInt(DBTASD_SERVER_STARTTIME))
  local nServerOpenDate = tonumber(os.date("%Y%m", nSec))
  if me.nKinFigure == 1 and nServerOpenDate == Kin.GOLD_LS_SERVERDAY then
    table.insert(tbOpt, 1, { "<color=yellow>查询金牌家族赛成员积分<color>", SpecialEvent.tbGoldBar.QueryKinGrade, SpecialEvent.tbGoldBar, me })
  end
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:BuyEventItem(nFlag)
  if not nFlag then
    me.OpenShop(239, 1, 100)
    return
  end
  me.OpenShop(239, 7, 100)
end

function tbNpc:BuyReputeItem(nFlag)
  if not nFlag then
    local nFaction = me.nFaction
    if nFaction <= 0 then
      Dialog:Say("加入门派的玩家才能购买家族竞技装备")
      return 0
    end
    me.OpenShop(233 + me.nSeries - 1, 1, 100, me.nSeries) --使用声望购买
  else
    me.OpenShop(215, 1, 100)
  end
end

function tbNpc:AttendGame(nMacthType, nAttendType, nFlag)
  if not nAttendType and (nMacthType == 3 or nMacthType == 4) then
    local tbMacth = NewEPlatForm:GetMacthTypeCfg(nMacthType)
    Dialog:Say(string.format("本周家族趣味竞技为：<color=yellow>%s<color>，你可以选择组队参加或者单人参加？", tbMacth.szName), { "我一个人参加", self.AttendGame, self, nMacthType, 1 }, { "我们组队一起参加", self.AttendGame, self, nMacthType, 2 }, { "我再想想" })
    return
  end
  if not nAttendType or nAttendType == 1 then
    if NewEPlatForm:CheckMonthAward(me) == 1 then
      Dialog:Say("您上月家族奖励还没有领取，需要现在领取吗？", { { "领取", NewEPlatForm.GetPlayerAward_Month, NewEPlatForm }, { "我再想想" } })
      return 0
    end

    local nReturn, szMsgInFor = self:CreateMsg(me)
    if nReturn == 2 then
      Dialog:Say("您" .. szMsgInFor)
      return 0
    elseif nReturn == 0 then
      Dialog:Say(szMsgInFor)
      return 0
    end

    if not nFlag then
      for _, tbItem in pairs(NewEPlatForm.ForbidItem) do
        if #me.FindItemInBags(unpack(tbItem)) > 0 then
          local szMsg = "您身上带有<color=red>禁止使用的药箱<color>，进入比赛将无法使用该类药箱，您确定要进入赛场吗？"
          local tbOpt = {
            { "确定进入赛场", self.AttendGame, self, nMacthType, nAttendType, 1 },
            { "我再想想" },
          }
          Dialog:Say(szMsg, tbOpt)
          return 0
        end
      end
    end
    GCExcute({ "NewEPlatForm:EnterReadyMap", { me.nId }, me.szName, me.nMapId })
  elseif nAttendType == 2 then
    if me.nTeamId <= 0 then
      Dialog:Say("您没有队伍吧。")
      return
    end
    if me.IsCaptain() == 0 then
      Dialog:Say("你不是队长哦，让你们队长过来报名吧。")
      return 0
    end
    local tbPlayerList = KTeam.GetTeamMemberList(me.nTeamId)
    if Lib:CountTB(tbPlayerList) > NewEPlatForm.DEF_PLAYER_TEAM then
      Dialog:Say("你们队伍人太多了，只能是四个人前去的。")
      return 0
    end
    local tbPlayerId = {}
    local bForbidItem = 0
    local szDialogMsg = ""
    local szItemInfo = "队伍拥有的道具组合："
    local nMapId, nPosX, nPosY = me.GetWorldPos()
    for _, nPlayerId in pairs(tbPlayerList) do
      local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
      if not pPlayer then
        Dialog:Say("你们队伍有人没来啊，我们还不能出发，等等他吧。")
        return 0
      end
      local nMapId2, nPosX2, nPosY2 = pPlayer.GetWorldPos()
      local nDisSquare = (nPosX - nPosX2) ^ 2 + (nPosY - nPosY2) ^ 2
      if nMapId2 ~= nMapId or nDisSquare > 400 then
        Dialog:Say("您的所有队友必须在这附近。")
        return 0
      end
      --local nAwardFlag = pPlayer.GetTask(NewEPlatForm.TASKID_GROUP, NewEPlatForm.TASKID_AWARDFLAG);
      --if (0 < nAwardFlag) then
      --	Dialog:Say("玩家<color=yellow>"..pPlayer.szName.."<color>上场奖励还没有领取。");
      --	return 0;
      --end
      if NewEPlatForm:CheckMonthAward(pPlayer) == 1 then
        Dialog:Say("玩家<color=yellow>" .. pPlayer.szName .. "<color>上月家族奖励还没有领取。")
        return 0
      end
      local nReturn, szMsgInFor, szItemName = self:CreateMsg(pPlayer)
      if nReturn == 2 then
        Dialog:Say("玩家<color=yellow>" .. pPlayer.szName .. "<color>" .. szMsgInFor)
        return 0
      elseif nReturn == 0 then
        Dialog:Say(szMsgInFor)
        return 0
      end
      if szDialogMsg == "" then
        szDialogMsg = szMsgInFor
      end
      szItemInfo = szItemInfo .. pPlayer.szName .. "：" .. szItemName .. "\n"
      table.insert(tbPlayerId, nPlayerId)
      for _, tbItem in pairs(NewEPlatForm.ForbidItem) do
        if bForbidItem == 0 and #pPlayer.FindItemInBags(unpack(tbItem)) > 0 then
          bForbidItem = 1
          break
        end
      end
    end
    if not nFlag then
      local szMsg = "您确定要进入赛场吗？"
      local tbOpt = {
        { "确定进入赛场", self.AttendGame, self, nMacthType, nAttendType, 1 },
        { "我再想想" },
      }
      Dialog:Say(szDialogMsg .. "\n" .. szItemInfo .. "\n" .. szMsg, tbOpt)
      return 0
    end
    GCExcute({ "NewEPlatForm:EnterReadyMap", tbPlayerId, me.szName, me.nMapId })
  end
end

function tbNpc:CreateMsg(pPlayer)
  if NewEPlatForm:GetMatchState() == NewEPlatForm.DEF_STATE_CLOSE then
    return 0, "趣味活动还未开启，敬请期待。"
  end

  if NewEPlatForm:GetMacthSession() <= 0 then
    return 0, "趣味活动还未开启，敬请期待。"
  end

  local nMacthType = NewEPlatForm:GetMacthType()
  local tbMacth = NewEPlatForm:GetMacthTypeCfg(nMacthType)

  if not tbMacth then
    return 0, "趣味活动还未开启，敬请期待。"
  end

  local nWeek = tonumber(GetLocalDate("%w"))
  if not NewEPlatForm.tbStartTime[nWeek] then
    return 0, "比赛日为每周一、三、五、日，今天为比赛间歇期，请稍后再来。"
  end

  local tbMacthCfg = tbMacth.tbMacthCfg

  if pPlayer.nLevel < tbMacthCfg.nMinLevel then
    return 2, string.format("修为不足，%d级之后才能参加！", tbMacthCfg.nMinLevel)
  end

  if pPlayer.nFaction <= 0 then
    return 2, "目前尚未加入门派，武艺不精，还是等加入门派后再来吧！"
  end
  if pPlayer.nKinFigure <= 0 then
    return 2, "没有家族，不能参加家族趣味竞技。"
  end
  if tbMacthCfg.nBagNeedFree and tbMacthCfg.nBagNeedFree > 0 then
    if pPlayer.CountFreeBagCell() < tbMacthCfg.nBagNeedFree then
      return 2, string.format("的背包空间不足%s格，请整理之后再来吧！", tbMacthCfg.nBagNeedFree)
    end
  end

  local szItemName = ""
  if tbMacthCfg and tbMacthCfg.tbJoinItem and #tbMacthCfg.tbJoinItem > 0 then
    local nEnterFlag = NewEPlatForm:CheckEnterCount(pPlayer, tbMacthCfg.tbJoinItem)
    local szMsg = ""
    local nNameCount = 0
    for _, tbItemInfo in pairs(tbMacthCfg.tbJoinItem) do
      if tbItemInfo.tbItem then
        local szName = NewEPlatForm:GetItemName(tbItemInfo.tbItem)
        if szName and string.len(szName) > 0 then
          if nNameCount > 0 then
            szMsg = string.format("%s<color=white>或<color>", szMsg)
          end

          szMsg = string.format("%s%s", szMsg, szName)
          nNameCount = nNameCount + 1
          szItemName = szName
        end
      end
    end
    if string.len(szMsg) <= 0 then
      szMsg = "活动道具"
    end
    if nEnterFlag <= 0 then
      return 2, string.format("身上没有<color=yellow>%s<color>，不能参加活动", szMsg)
    elseif nEnterFlag > 1 then
      return 2, string.format("身上<color=yellow>%s<color>携带数量只能是一个，请取出背包中多余的道具，再来参加活动吧！", szMsg)
    end

    local nItemFlag, szItemMsg = NewEPlatForm:ProcessItemCheckFun(pPlayer, tbMacthCfg.tbJoinItem)
    if 0 == nItemFlag then
      return 2, "的<color=yellow>" .. szItemMsg .. "<color>还需要改造。"
    else
      szItemName = szItemMsg
    end
  end

  local nTime = GetTime()
  local nWeek = tonumber(os.date("%w", nTime))
  local nHourMin = tonumber(os.date("%H%M", nTime))
  local nDay = tonumber(os.date("%d", nTime))

  NewEPlatForm:ChangeEventCount(pPlayer)

  local nCount = NewEPlatForm:GetPlayerEventCount(pPlayer)

  if nCount <= 0 then
    return 2, string.format("今天已经参加多次<color=yellow>%s<color>活动了，回去休息下明天再来吧。", tbMacth.szName)
  end

  local nAllCount = NewEPlatForm:GetPlayerTotalCount(pPlayer)
  if nAllCount >= NewEPlatForm.nMaxAllCount then
    return 2, string.format("本月已经参加了<color=yellow>%s<color>次活动了，下个月再来吧。", NewEPlatForm.nMaxAllCount)
  end

  if pPlayer.GetEquip(Item.EQUIPPOS_MASK) then
    return 2, string.format("佩戴了面具，%s不允许戴面具参加。", tbMacth.szName)
  end

  if NewEPlatForm.ReadyTimerId > 0 then
    local nRestTime = math.floor(Timer:GetRestTime(NewEPlatForm.ReadyTimerId) / Env.GAME_FPS)
    if nRestTime >= NewEPlatForm.MACTH_TIME_READY_LASTENTER / Env.GAME_FPS then
      return 1, string.format("比赛正在报名阶段，等待您的报名。\n离比赛开始还剩余<color=yellow>%s<color>，请尽快报名参赛。", Lib:TimeFullDesc(nRestTime)), szItemName
    end
  end

  local tbCalemdar = NewEPlatForm.CALEMDAR

  local szGameStart = tbMacth.szName
  local nFlag = 0
  for nReadyId, tbMissions in pairs(NewEPlatForm.MissionList) do
    for _, tbMission in pairs(tbMissions) do
      if tbMission:IsOpen() ~= 0 then
        nFlag = 1
        break
      end
    end
    if 1 == nFlag then
      break
    end
  end
  if nFlag == 1 then
    szGameStart = szGameStart .. "比赛已经开始了！\n\n"
  end

  if nHourMin > tbCalemdar[#tbCalemdar] then
    return 0, "\n今天的趣味活动场次已全部结束，请明天再来参赛！"
  end

  if nHourMin < tbCalemdar[1] then
    return 0, string.format("下场比赛的时间为<color=yellow>%s<color>！", NewEPlatForm.Fun:Number2Time(tbCalemdar[1]))
  end

  for nId, nMatchTime in ipairs(tbCalemdar) do
    if nHourMin > nMatchTime and tbCalemdar[nId + 1] and nHourMin <= tbCalemdar[nId + 1] then
      return 0, string.format("下场比赛的时间为<color=yellow>%s<color>！", NewEPlatForm.Fun:Number2Time(tbCalemdar[nId + 1]))
    end
  end
  return 0, "请稍等，比赛马上就要开始！"
end

--查询
function tbNpc:Query()
  local nMacthType = NewEPlatForm:GetMacthType()
  local tbEvent = { "赛龙舟", "打雪仗", "守护先祖之魂", "夜岚关" }
  local szMsg = "趣味活动活动顺序为："
  for i, szName in ipairs(tbEvent) do
    if nMacthType == i then
      szMsg = szMsg .. "<color=yellow>" .. szName .. "<color>."
    else
      szMsg = szMsg .. szName .. "."
    end
  end
  szMsg = szMsg .. "\n活动以周为单位，每周一个类型。\n活动开启时间：<color=green>开放服务器同时开放<color>\n每天场次时间：<color=green>11:00-14:00 17:00-22:30每15分和45分各一场<color>"
  Dialog:Say(szMsg)
end
