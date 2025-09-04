-- 白虎堂报名NPC
local tbNpc = Npc:GetClass("baihutangbaoming")
tbNpc.tbRVPos = {}
--tbNpc.MAX_NUMBER = 100;
tbNpc.HIGHLEVEL = 90
tbNpc.tbTimeKey = {}

function tbNpc:Init()
  self.tbTimeKey[7] = 8
  self.tbTimeKey[18] = 21
  self.tbTimeKey[19] = 21
  self.tbTimeKey[20] = 21
end

function tbNpc:OnDialog(szParam)
  local tbOpt = {}
  local szMsg = ""
  local nTime = self:GetTime()
  local nOtherTimes = me.GetTask(BaiHuTang.TSKG_PVP_ACT, BaiHuTang.TSK_BaiHuTang_PKTIMES_Ex) or 0

  if self:CheckClose() == 1 then
    return
  end
  if BaiHuTang.nActionState == BaiHuTang.FIGHTSTATE then
    if EventManager.IVER_bOpenTiFu == 1 then
      local nMinute = tonumber(GetLocalDate("%M"))
      if nMinute > 40 then
        szMsg = string.format("勇闯白虎堂活动尚未开始，下一场开始报名的时间是%d:00,请稍后再来吧。", nTime)
      else
        nMinute = 40 - nMinute
        szMsg = string.format("现在一批勇士已经进入白虎堂，堂中大门已经关闭，请%d分钟后再来", nMinute)
      end
    else
      local nMinute = 30 - tonumber(GetLocalDate("%M"))
      if nMinute < 0 then
        --local nTime = self:GetTime();
        szMsg = string.format("勇闯白虎堂活动尚未开始，下一场开始报名的时间是%d:30，请稍后再来吧。", nTime)
      else
        szMsg = string.format("现在一批勇士已经进入白虎堂，堂中大门已经关闭，请%d分钟后再来", nMinute)
      end
    end

    tbOpt[1] = { "结束对话" }
  elseif BaiHuTang.nActionState == BaiHuTang.RESTSTATE then
    if EventManager.IVER_bOpenTiFu == 1 then
      szMsg = string.format("勇闯白虎堂活动尚未开始，下一场开始报名的时间是%d:00,请稍后再来吧。", nTime)
    else
      szMsg = string.format("勇闯白虎堂活动尚未开始，下一场开始报名的时间是%d:30，请稍后再来吧。", nTime)
    end
    tbOpt[1] = { "结束对话" }
  else
    local tbMap = self:GetMapList()
    if not tbMap or #tbMap <= 0 then
      return
    end

    local tbMapInfo = {}
    if szParam == "dong" then
      tbMapInfo.nMapId = tbMap[1][1]
      tbMapInfo.szName = "白虎堂东"
    elseif szParam == "nan" then
      tbMapInfo.nMapId = tbMap[1][2]
      tbMapInfo.szName = "白虎堂南"
    elseif szParam == "xi" then
      tbMapInfo.nMapId = tbMap[1][3]
      tbMapInfo.szName = "白虎堂西"
    elseif szParam == "bei" then
      tbMapInfo.nMapId = tbMap[1][4]
      tbMapInfo.szName = "白虎堂北"
    end
    local nRet = MathRandom(#BaiHuTang.tbPKPos)
    tbMapInfo.tbSect = BaiHuTang.tbPKPos[nRet]
    tbOpt[1] = { "是的，我要参加！", self.JoinAction, self, tbMapInfo }
    tbOpt[2] = { "[活动规则]", self.Rule, self, szParam }
    tbOpt[3] = { "听起来很危险，我还是不参加了。" }
    szMsg = string.format("最近白虎堂里不知道为什么闯入了不少盗贼，我们需要一些人把那些盗贼清理清理，不过话说在前面，你进去了就只有打通白虎堂3层才能出来，不过我们如果半个小时后见你没动静的话会进去救你的，你想参加吗？白虎堂每天可以参加<color=yellow>%s<color>次，你还有额外参加次数<color=yellow>%s<color>次", BaiHuTang.MAX_ONDDAY_PKTIMES, nOtherTimes)
  end
  Dialog:Say(szMsg, tbOpt)
end

-- 99级开放的时候，初级01:30之后就关闭
function tbNpc:CheckClose()
  if TimeFrame:GetStateGS("OpenLevel99") == 0 then
    return 0
  end

  local nNowHour = tonumber(GetLocalDate("%H"))
  if nNowHour >= 1 and nNowHour <= 7 then
    if me.nLevel < self.HIGHLEVEL then
      Dialog:Say("现在很晚了，您早点去休息吧。", {
        { "结束对话" },
      })
      return 1
    end
  end
  return 0
end

--规则显示
function tbNpc:Rule(szParam)
  local tbOpt = {}
  tbOpt[1] = { "返回上一层对话", self.OnDialog, self, szParam }
  tbOpt[2] = { "结束对话" }
  local szMsg = string.format("本活动报名时间<color=green>30<color>分钟，活动时间<color=green>30<color>分钟。活动开始后白虎堂内会出现许多<color=red>闯堂贼<color>，打败他们可以获得道具与经验，在经过一定时间之后会出现<color=red>闯堂贼头领<color>，" .. "打败<color=red>闯堂贼头领<color>后会出现通向二层的出口，白虎堂共3层，如果你把3层的头领都打败的话出来的出口便会打开。要注意的是来闯白虎堂的人都不是什么等闲之辈，进去就会强制开启战斗状态，所以最好组队或者跟家族或者帮会的人一起参加的比较好。（本活动每天最多参加<color=red>%s次<color>）\n<color=red>注：进入初级白虎堂必须加入家族<color>", BaiHuTang.MAX_ONDDAY_PKTIMES)
  Dialog:Say(szMsg, tbOpt)
end

--获取当前的小时数
function tbNpc:GetTime()
  local nNowHour = tonumber(GetLocalDate("%H"))
  local nNowMinute = tonumber(GetLocalDate("%M"))

  local nHour = nNowHour

  if EventManager.IVER_bOpenTiFu == 1 then
    nHour = nHour + 1
  else
    if nNowHour == 7 then
      nHour = 8
    elseif nNowHour == 18 or nNowHour == 19 or nNowHour == 20 then
      nHour = 21
    elseif nNowHour == 6 then
      if nNowMinute >= 30 then
        nHour = 8
      end
    elseif nNowHour == 17 then
      if nNowMinute >= 30 then
        nHour = 21
      end
    else
      if nNowMinute >= 30 then
        nHour = nHour + 1
      end
    end
  end

  if nHour == 24 then
    nHour = 0
  end

  return nHour
end
--参加PK
function tbNpc:JoinAction(tbMapInfo)
  if me.GetTiredDegree1() == 2 then
    Dialog:Say("您太累了，还是休息下吧！")
    return
  end
  if BaiHuTang.nActionState == BaiHuTang.FIGHTSTATE then
    me.Msg("白虎堂活动已经开始，不能再报名了，您就等一下场吧。")
    return
  end

  --死亡就不给进 zounan
  local nDead = me.IsDead() or 1
  if nDead == 1 then
    return
  end

  local nTimes = me.GetTask(BaiHuTang.TSKG_PVP_ACT, BaiHuTang.TSK_BaiHuTang_PKTIMES) or 0
  local nOtherTimes = me.GetTask(BaiHuTang.TSKG_PVP_ACT, BaiHuTang.TSK_BaiHuTang_PKTIMES_Ex) or 0
  local szNowDate = GetLocalDate("%y%m%d")
  local nDate = math.floor(nTimes / 10)
  local nPKTimes = nTimes % 10
  local nNowDate = tonumber(szNowDate)
  if nDate == nNowDate then
    if nPKTimes >= BaiHuTang.MAX_ONDDAY_PKTIMES then
      local nTime = tonumber(GetLocalDate("%H%M"))
      -- 当天23：30分钟前已经参加过了三次
      if nOtherTimes <= 0 then
        if nTime < 2330 then
          me.Msg(string.format("本活动一天只能参加%s次，请明天再来吧。", BaiHuTang.MAX_ONDDAY_PKTIMES))
          return
        else
          me.SetTask(BaiHuTang.TSKG_PVP_ACT, BaiHuTang.TSK_BaiHuTang_PKTIMES, 0)
        end
      end
    end
  else
    me.SetTask(BaiHuTang.TSKG_PVP_ACT, BaiHuTang.TSK_BaiHuTang_PKTIMES, 0)
  end
  --local nTotal  = BaiHuTang.tbNumber[tbMapInfo.nMapId];
  --if (nTotal and nTotal >= tbNpc.MAX_NUMBER) then
  --	me.Msg("这个地图人数已经超过了上限，请换个报名点吧！");
  --	return;
  --end
  self:OnTrans(tbMapInfo)
end
--传送玩家到指定地图
function tbNpc:OnTrans(tbMapInfo)
  local tbSect = tbMapInfo.tbSect
  local nMapId = tbMapInfo.nMapId
  BaiHuTang:JoinGame(me.nMapId, me, nMapId, tbSect.nX / 32, tbSect.nY / 32)
end

function tbNpc:GetMapList()
  local tbMap = {}
  if me.nMapId == 821 then
    tbMap = BaiHuTang.tbBatte[BaiHuTang.Goldlen].MapId
  elseif me.nLevel >= 90 then
    tbMap = BaiHuTang.tbBatte[BaiHuTang.GaoJi].MapId
  elseif me.nMapId == 225 then
    tbMap = BaiHuTang.tbBatte[BaiHuTang.ChuJi].MapId
  elseif me.nMapId == BaiHuTang.ChuJi2 then
    -- 第二场初级的
    if TimeFrame:GetStateGS("CloseBaiHuTangChu2") == 0 then
      tbMap = { { 275, 276, 277, 278 } }
    else
      tbMap = nil
    end
  end
  return tbMap
end
tbNpc:Init()
