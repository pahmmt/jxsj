-- 文件名　：guanggun_item.lua
-- 创建者　：LQY
-- 创建时间：2012-10-30 11:20:40
-- 说　　明：光棍节物品
if not MODULE_GAMESERVER then
  return
end
Require("\\script\\event\\jieri\\201211_guanggunjie\\guanggun_def.lua")
local tbGuangGun = SpecialEvent.GuangGun2012

----爱神之箭
local tbItemLoveArrow = Item:GetClass("2012guanggun_lovearrow")

function tbItemLoveArrow:OnUse(nNpcId)
  local n, szMsg = tbGuangGun:CheckTime()
  if n ~= 1 then
    Dialog:Say(szMsg)
    return
  end
  if tbGuangGun:IsMapOk(me.nMapId) == 0 then
    Dialog:Say("只能在城市或者新手村使用！")
    return
  end
  local nCount = me.GetTask(tbGuangGun.TASK_GROUP, tbGuangGun.LOVEARROW_COUNT)
  if nCount >= 3 then
    Dialog:Say("今天的使用次数已满。")
    return 1
  end
  local nLastTime = me.GetTask(tbGuangGun.TASK_GROUP, tbGuangGun.LASTUSEARROW)
  if GetTime() - nLastTime < tbGuangGun.nLoveArrow_Time / Env.GAME_FPS then
    Dialog:Say(string.format("你还需要等待%s才能再次使用！", Lib:TimeFullDescEx(tbGuangGun.nLoveArrow_Time / Env.GAME_FPS - (GetTime() - nLastTime))))
    return
  end
  if nNpcId == 0 then
    Dialog:Say("要选中异性使用道具，爱神之箭才能发送哦！")
    return
  end
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    Dialog:Say("要选中异性使用道具，爱神之箭才能发送哦！")
    return
  end
  local pPlayer = pNpc.GetPlayer()
  if not pPlayer then
    Dialog:Say("要选中异性玩家使用才有效哦！")
    return
  end
  if pPlayer.nSex == me.nSex then
    Dialog:Say("咳咳，要选中<color=yellow>异性<color>使用道具，爱神之箭才能发送！")
    return
  end
  local nDis = tbGuangGun:GetDis(me, pPlayer)
  if nDis > tbGuangGun.nArrowDis then
    Dialog:Say("与对方距离太远了，无法使用爱神之箭！")
    return
  end
  if pPlayer.GetSkillState(tbGuangGun.nLoveState) ~= -1 then
    Dialog:Say("" .. pPlayer.szName .. "已中爱神之箭，还是再找找其他人吧。")
    return
  end

  GeneralProcess:StartProcess("使用爱神之箭...", tbGuangGun.nArrowTime, { self.ArrowFinsh, self, pPlayer.nId, it.dwId }, nil, tbGuangGun.tbEvent)
end

--射箭读条
function tbItemLoveArrow:ArrowFinsh(nTagId, nItem)
  local pItem = KItem.GetObjById(nItem)
  if not pItem then
    Dialog:Say("你的爱神之箭不见了。")
    return
  end
  local nCount = me.GetTask(tbGuangGun.TASK_GROUP, tbGuangGun.LOVEARROW_COUNT)
  local pPlayer = KPlayer.GetPlayerObjById(nTagId)
  if not pPlayer then
    Dialog:Say("对方已离开，无法使用爱神之箭！")
    return
  end
  if pPlayer.nSex == me.nSex then
    Dialog:Say("咳咳，要选中<color=yellow>异性<color>使用道具，爱神之箭才能发送！")
    return
  end
  local nDis = tbGuangGun:GetDis(me, pPlayer)
  if nDis > tbGuangGun.nArrowDis then
    Dialog:Say("与对方距离太远了，无法使用爱神之箭！")
    return
  end
  if pPlayer.GetSkillState(tbGuangGun.nLoveState) ~= -1 then
    Dialog:Say("玩家" .. pPlayer.szName .. "已中爱神之箭，还是再找找其他人吧。")
    return
  end
  if nCount == 2 then
    if pItem.Delete(me) ~= 1 then
      Dialog:Say("爱神之箭射偏了，请重新发射。")
      return
    end
  end
  me.SetTask(tbGuangGun.TASK_GROUP, tbGuangGun.LASTUSEARROW, GetTime())
  me.SetTask(tbGuangGun.TASK_GROUP, tbGuangGun.LOVEARROW_COUNT, nCount + 1)
  pPlayer.AddSkillState(tbGuangGun.nLoveState, 1, 1, tbGuangGun.nLoveArrow_Time, 1)
  Dialog:SendBlackBoardMsg(me, "你成功对" .. pPlayer.szName .. "释放了爱神之箭。")
  Dialog:SendBlackBoardMsg(pPlayer, me.szName .. "对你释放了爱神之箭。")
  --埋点 2012年光棍节活动参与（脱光活动）
  StatLog:WriteStatLog("stat_info", "single_2012", "single", me.nId, 1)
  self:GetAward(me, nCount + 1)
  if nCount + 1 == 3 then
    me.Msg("今天的爱神之箭已发送完毕，祝您明年不过光棍节。")
  end
end

-- 爱神箭奖励
function tbItemLoveArrow:GetAward(pPlayer, nTimes)
  local nGold = 0
  local nExpTime = 0
  if nTimes <= 2 then
    nGold = tbGuangGun.tbArrowAward[nTimes][1]
    nExpTime = tbGuangGun.tbArrowAward[nTimes][2]
  else
    local nNum = MathRandom(1, 100)
    if nNum <= tbGuangGun.tbArrowAward[4][1] then
      nGold = tbGuangGun.tbArrowAward[4][2]
      nExpTime = tbGuangGun.tbArrowAward[4][3]
      --公告
      KDialog.NewsMsg(1, Env.NEWSMSG_MARRAY, string.format(tbGuangGun.ANNOUN[9], pPlayer.szName))
    else
      nGold = tbGuangGun.tbArrowAward[3][1]
      nExpTime = tbGuangGun.tbArrowAward[3][2]
    end
  end
  pPlayer.AddBindCoin(nGold)
  pPlayer.AddExp(nExpTime * pPlayer.GetBaseAwardExp())
  --埋点 产出 绑金
  StatLog:WriteStatLog("stat_info", "single_2012", "output", me.nId, "bindcoin", nGold)
end

function tbItemLoveArrow:InitGenInfo()
  local nDate = tonumber(GetLocalDate("%Y%m%d"))
  local nValidTime = Lib:GetDate2Time(nDate) + 24 * 3600 - 1
  it.SetTimeOut(0, nValidTime)
end

-------
------歌曲道具
local tbItemSong = Item:GetClass("2012guanggun_song")
function tbItemSong:InitGenInfo()
  local nDate = tonumber(GetLocalDate("%Y%m%d"))
  local nValidTime = Lib:GetDate2Time(nDate) + 24 * 3600 - 1
  it.SetTimeOut(0, nValidTime)
end
function tbItemSong:OnUse()
  if self:CanGetAward() == 1 then
    if me.CountFreeBagCell() < 1 then
      Dialog:Say("请整理出一格背包再打开！")
      return
    end
    Dialog:SendBlackBoardMsg(me, "你获得了一个情缘宝盒")
    me.AddItem(unpack(tbGuangGun.BoxId))
    if me.nSex == 1 then
      local nCount = me.GetTask(tbGuangGun.TASK_GROUP, tbGuangGun.GIRLGETCOUNT)
      if nCount + 1 >= 2 then
        return 1
      else
        me.SetTask(tbGuangGun.TASK_GROUP, tbGuangGun.GIRLGETCOUNT, nCount + 1)
        for _, nId in pairs(tbGuangGun.LIGHTNPC) do --点亮情况归零
          me.SetTask(tbGuangGun.TASK_GROUP, nId, 0)
        end
        Dialog:Say("你获得了一个情缘宝盒。女性角色每日可参加2次此活动，赶快再寻找一名有缘人，继续送出光棍节的祝福之声吧！")
        return
      end
    end
    return 1
  end
  if me.nSex == 1 then
    if me.nTeamId == 0 then
      Dialog:Say("本道具必须和男生一起使用哦，去找个伴组队吧！")
      return
    else
      Dialog:Say("本道具必须由队伍里的男生使用！")
      return
    end
  end
  local n, szMsg = tbGuangGun:CheckTime()
  if n ~= 1 then
    Dialog:Say(szMsg)
    return
  end
  if tbGuangGun:IsTimeOk() == 0 then
    Dialog:Say("不在活动期间，每天12:00-14:00,19:00-23:00才是本活动时间段。")
    return
  end
  local pGirl, szMsg = self:CheckGirl()
  if pGirl == 0 then
    Dialog:Say(szMsg)
    return
  end
  local tbItemId = { it.nGenre, it.nDetail, it.nParticular, it.nLevel }
  ----道具判断
  local tbFind = pGirl.FindItemInBags(unpack(tbItemId))
  if not tbFind[1] then
    Dialog:Say("队伍里的女性角色没有携带和你相同的祝福歌曲词，无法共同合唱。")
    return
  end
  --绑银上限
  local n, szMsg = tbGuangGun:BindMoneyOut(me, pGirl, tbGuangGun.nSongMoney)
  if n == 0 then
    Dialog:Say(szMsg)
    return
  end
  local dwGirlItemId = tbFind[1].pItem.dwId
  --寻找NPC
  local tbNpc = KNpc.GetAroundNpcList(me, tbGuangGun.nArrowDis)
  local pTarget = nil
  local nNpcNum = 0
  for n, pNpc in pairs(tbNpc) do
    if tbGuangGun.NPCS_ID[pNpc.nTemplateId] then
      pTarget = pNpc
      nNpcNum = tbGuangGun.NPCS_ID[pNpc.nTemplateId]
      break
    end
  end
  if not pTarget then
    Dialog:Say("请到指定NPC旁才能使用道具，送出光棍节祝福。")
    return
  end
  local nMeSonged = me.GetTask(tbGuangGun.TASK_GROUP, tbGuangGun.LIGHTNPC[nNpcNum])
  local nGirlSonged = pGirl.GetTask(tbGuangGun.TASK_GROUP, tbGuangGun.LIGHTNPC[nNpcNum])
  if nMeSonged == 1 and nGirlSonged == 1 then
    Dialog:Say("你们已经对这个人唱过歌了，还是换个人吧。")
    return
  end
  me.AddSkillState(tbGuangGun.nSonging, 1, 1, tbGuangGun.nSongTime)
  pGirl.AddSkillState(tbGuangGun.nSonging, 1, 1, tbGuangGun.nSongTime)
  --开始唱歌~~
  Dialog:SendBlackBoardMsg(pGirl, "你们开始了唱歌…")
  GeneralProcess:StartProcess("唱歌中...", tbGuangGun.nSongTime, { self.SongFinish, self, 1, it.dwId, dwGirlItemId, nNpcNum, pTarget.dwId }, { self.SongFinish, self, 0, it.dwId, dwGirlItemId, nNpcNum, pTarget.dwId }, tbGuangGun.tbEvent)
end

--唱完了
function tbItemSong:SongFinish(bSongFinish, dwItemId, dwGirlItemId, nNpcNum, dwNpcId)
  local pGirl, szMsg = self:CheckGirl()
  if pGirl == 0 then
    Dialog:Say(szMsg)
    return
  end
  if bSongFinish == 0 then --被打断了
    me.RemoveSkillState(tbGuangGun.nSonging)
    pGirl.RemoveSkillState(tbGuangGun.nSonging)
    return
  end
  local pItem = KItem.GetObjById(dwItemId)
  local pGirlItem = KItem.GetObjById(dwGirlItemId)
  if not pItem or not pGirlItem then
    Dialog:Say("有个人的歌曲道具消失了。")
    return
  end
  --绑银上限
  local n, szMsg = tbGuangGun:BindMoneyOut(me, pGirl, tbGuangGun.nSongMoney)
  if n == 0 then
    Dialog:Say(szMsg)
    return
  end
  local pNpc = KNpc.GetById(dwNpcId)
  if pNpc then
    pNpc.SendChat(tbGuangGun.tbNpcListen[MathRandom(1, #tbGuangGun.tbNpcListen)], 1)
  end
  --埋点 2012年光棍节活动参与（祝福活动）
  StatLog:WriteStatLog("stat_info", "single_2012", "blessing", me.nId, pGirl.szName)

  local nMeSonged = me.GetTask(tbGuangGun.TASK_GROUP, tbGuangGun.LIGHTNPC[nNpcNum])
  local nGirlSonged = pGirl.GetTask(tbGuangGun.TASK_GROUP, tbGuangGun.LIGHTNPC[nNpcNum])
  if nMeSonged ~= 1 then
    local nValue = tbGuangGun.nSongMoney
    if me.GetBindMoney() + nValue > me.GetMaxCarryMoney() then
      me.Msg("您的携带的绑定银两过多。")
      nValue = me.GetMaxCarryMoney() - me.GetBindMoney()
    end
    Dialog:SendBlackBoardMsg(me, "成功对<color=yellow>" .. tbGuangGun.NPCS_NAME[nNpcNum] .. "<color>高歌了一曲")
    me.AddBindMoney(nValue)
    me.AddExp(tbGuangGun.nSongExp * me.GetBaseAwardExp())
    --埋点 产出 绑银
    StatLog:WriteStatLog("stat_info", "single_2012", "output", me.nId, "bindmoney", nValue)
  else
    Dialog:SendBlackBoardMsg(me, "你已经对ta唱过歌了，所以没有奖励。再找找其他人唱吧")
  end
  if nGirlSonged ~= 1 then
    local nValue = tbGuangGun.nSongMoney
    if pGirl.GetBindMoney() + nValue > pGirl.GetMaxCarryMoney() then
      pGirl.Msg("您的携带的绑定银两过多。")
      nValue = pGirl.GetMaxCarryMoney() - pGirl.GetBindMoney()
    end
    Dialog:SendBlackBoardMsg(pGirl, "成功对<color=yellow>" .. tbGuangGun.NPCS_NAME[nNpcNum] .. "<color>高歌了一曲")
    pGirl.AddBindMoney(nValue)
    pGirl.AddExp(tbGuangGun.nSongExp * pGirl.GetBaseAwardExp())
    --埋点 产出 绑银
    StatLog:WriteStatLog("stat_info", "single_2012", "output", pGirl.nId, "bindmoney", nValue)
  else
    Dialog:SendBlackBoardMsg(pGirl, "你已经对ta唱过歌了，所以没有奖励。再找找其他人唱吧")
  end
  me.SetTask(tbGuangGun.TASK_GROUP, tbGuangGun.LIGHTNPC[nNpcNum], 1)
  pGirl.SetTask(tbGuangGun.TASK_GROUP, tbGuangGun.LIGHTNPC[nNpcNum], 1)
end

function tbItemSong:CheckGirl()
  if me.nTeamId == 0 then
    return 0, "必须和一名女性角色组队才能共同合唱，快去找个和你有一样祝福歌曲的人吧！"
  end
  local tbPlayerId, nTeamCount = KTeam.GetTeamMemberList(me.nTeamId)
  if nTeamCount > 2 then
    return 0, "必须和一名女生两人组队才能合唱，你的队伍里人太多了！"
  end
  if not tbPlayerId[2] then
    return 0, "必须和一名女性角色组队才能共同合唱，快去找个和你有一样祝福歌曲的人吧！"
  end
  local pGirl = nil
  if me.IsCaptain() == 1 then
    pGirl = KPlayer.GetPlayerObjById(tbPlayerId[2])
  else
    pGirl = KPlayer.GetPlayerObjById(tbPlayerId[1])
  end
  if not pGirl then
    return 0, "队员不在附近，快叫ta过来吧！"
  end
  if pGirl.nSex ~= 1 then
    return 0, "必须和一名女性角色组队才能共同合唱，快去找个和你有一样祝福歌曲的人吧！"
  end
  if tbGuangGun:GetDis(me, pGirl) > tbGuangGun.nArrowDis then
    return 0, "队友距离你太远了，叫她靠近点吧！"
  end
  return pGirl
end
--能否领奖
function tbItemSong:CanGetAward()
  local nCount = 0
  for n, nId in pairs(tbGuangGun.LIGHTNPC) do
    local nLight = me.GetTask(tbGuangGun.TASK_GROUP, nId)
    if nLight == 1 then
      nCount = nCount + 1
    end
  end
  if nCount == 9 then
    return 1
  end
  return 0
end

--------------
--礼包道具
local tbItemBox = Item:GetClass("2012guanggun_box")
function tbItemBox:InitGenInfo()
  local nValidTime = GetTime() + 7 * 24 * 60 * 60
  it.SetTimeOut(0, nValidTime)
end
function tbItemBox:OnUse()
  if tbGuangGun:IsMapOk(me.nMapId) == 0 then
    Dialog:Say("只能在城市或者新手村使用！")
    return
  end
  if me.CountFreeBagCell() < 2 then
    Dialog:Say("请整理出两格背包再打开！")
    return
  end
  if self:GetAPos() == 0 then
    Dialog:Say("这个位置会把其他人挡住，还是挪个地方吧。")
    return
  end
  if me.GetBindMoney() + 2990000 > me.GetMaxCarryMoney() then
    Dialog:Say("你的绑银即将超出上限，请整理一下再打开吧！")
    return
  end
  --给奖励
  local szMsg = "  感谢你为那些光棍们高歌一曲，这里的奖励你拿去吧。<enter>  此外，你还可以在烛光中许下一个愿望，只有非常真诚，幸运之神才会帮你实现愿望哦。"
  local tbOpt = {
    { "打开宝盒并许愿<color=yellow>（想要一个帅哥）<color>", self.GetAword, self, 1, it.dwId, me.nId },
    { "打开宝盒并许愿<color=yellow>（想要一个美女）<color>", self.GetAword, self, 2, it.dwId, me.nId },
  }
  Dialog:Say(szMsg, tbOpt)
end

--获取奖励
function tbItemBox:GetAword(nBoG, dwItemId, nPlayerId)
  local pItem = KItem.GetObjById(dwItemId)
  if not pItem then
    Dialog:Say("物品消失了。")
    return
  end
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    Dialog:Say("人消失了。")
    return
  end
  if pItem.Delete(pPlayer) ~= 1 then
    return
  end
  local tbName = {
    [1] = "帅哥",
    [2] = "美女",
  }
  pPlayer.SendMsgToFriend(string.format(tbGuangGun.ANNOUN[6], pPlayer.szName, tbName[nBoG]))
  Player:SendMsgToKinOrTong(pPlayer, string.format(tbGuangGun.ANNOUN[5], pPlayer.szName, tbName[nBoG]), 0)
  local nMapId, nPosX, nPosY = me.GetWorldPos()
  local pNpc = KNpc.Add2(tbGuangGun.nLaZhuId, 1, -1, nMapId, nPosX, nPosY)
  if pNpc then
    pNpc.SetLiveTime(tbGuangGun.nLaZhuLiveTime)
  end
  local nFind = 0
  local nAdd = 0
  local nRand = MathRandom(1, 100)
  local AWARD_LIST = (pPlayer.nSex == 0) and tbGuangGun.AWARDBOY or tbGuangGun.AWARDGIRL
  for i = 1, #AWARD_LIST do
    nAdd = nAdd + AWARD_LIST[i][4]
    if nAdd >= nRand then
      nFind = i
      break
    end
  end
  --发放奖励
  if nFind >= 0 then
    local tbAward = AWARD_LIST[nFind]
    -- add award
    if tbAward[1] == "stone" then
      local nStone = tbAward[5]
      if nStone == 9 then
        KDialog.NewsMsg(1, Env.NEWSMSG_MARRAY, string.format(tbGuangGun.ANNOUN[7], pPlayer.szName, tbAward[6]))
      end
      pPlayer.AddStackItem(tbGuangGun.tbGiveStone[nStone][1], tbGuangGun.tbGiveStone[nStone][2], tbGuangGun.tbGiveStone[nStone][3], tbGuangGun.tbGiveStone[nStone][4], nil, tbAward[3])
      --埋点 产出 玄晶
      local szGDPL = string.format("%d_%d_%d_%d", unpack(tbGuangGun.tbGiveStone[nStone]))
      StatLog:WriteStatLog("stat_info", "single_2012", "output", me.nId, nStone .. "玄", szGDPL)
    end
    if tbAward[1] == "money" then
      local nValue = tbAward[3]
      if nValue == 2990000 then
        KDialog.NewsMsg(1, Env.NEWSMSG_MARRAY, string.format(tbGuangGun.ANNOUN[7], pPlayer.szName, tbAward[6]))
      end
      if pPlayer.GetBindMoney() + nValue > pPlayer.GetMaxCarryMoney() then
        pPlayer.Msg("您的携带的绑定银两过多。")
        nValue = pPlayer.GetMaxCarryMoney() - pPlayer.GetBindMoney()
      end
      pPlayer.AddBindMoney(nValue)

      --埋点 产出 绑银
      StatLog:WriteStatLog("stat_info", "single_2012", "output", me.nId, "bindmoney", nValue)
    end
    if tbAward[6] then
      local szAwardName = tbAward[6]
      pPlayer.SendMsgToFriend(string.format(tbGuangGun.ANNOUN[2], pPlayer.szName, szAwardName))
      Player:SendMsgToKinOrTong(pPlayer, string.format(tbGuangGun.ANNOUN[1], pPlayer.szName, szAwardName), 0)
    end
  end
  --随机跟宠
  if pPlayer.GetTask(tbGuangGun.TASK_GROUP, tbGuangGun.GETPARTNER) ~= 1 then
    nRand = MathRandom(1, 100)
    local nRandNum = (pPlayer.nSex == 0) and tbGuangGun.PARTBOY or tbGuangGun.PARTGIRL
    if nRand <= nRandNum then
      local pItemp = pPlayer.AddItem(unpack(tbGuangGun.BoxPar[nBoG]))
      if not pItemp then
        return
      end
      --埋点 产出 跟宠
      local szGDPL = string.format("%d_%d_%d_%d", unpack(tbGuangGun.BoxPar[nBoG]))
      StatLog:WriteStatLog("stat_info", "single_2012", "output", me.nId, "item", szGDPL)
      pPlayer.SetTask(tbGuangGun.TASK_GROUP, tbGuangGun.GETPARTNER, 1)
      Dialog:SendBlackBoardMsg(me, "你获得了一个" .. tbName[nBoG] .. "跟宠礼物盒")
      pPlayer.SendMsgToFriend(string.format(tbGuangGun.ANNOUN[11], pPlayer.szName, tbName[nBoG]))
      Player:SendMsgToKinOrTong(pPlayer, string.format(tbGuangGun.ANNOUN[10], pPlayer.szName, tbName[nBoG]), 0)
      KDialog.NewsMsg(1, Env.NEWSMSG_MARRAY, string.format(tbGuangGun.ANNOUN[8], pPlayer.szName, tbName[nBoG]))
    end
  end
end

-- 在pPlayer周围是否有功能NPC
function tbItemBox:GetAPos()
  local tbNpcList = KNpc.GetAroundNpcList(me, 15)
  for _, pNpc in ipairs(tbNpcList) do
    if pNpc.nKind == 3 or pNpc.nKind == 4 then
      return 0, "这个位置会把其他人挡住，还是挪个地方吧。"
    end
  end
  return 1
end
------------
--跟宠礼包
local tbItemPar = Item:GetClass("2012guanggun_partner")
function tbItemPar:InitGenInfo()
  local nValidTime = GetTime() + 7 * 24 * 60 * 60
  it.SetTimeOut(0, nValidTime)
end
function tbItemPar:OnUse()
  local nValue = it.GetExtParam(1)
  if not tbGuangGun.tbPartner[nValue] then
    return
  end
  local nNowDate = tonumber(GetLocalDate("%m%d"))
  if nNowDate < 1111 then
    Dialog:Say("只能在11月11日0点以后才能打开！")
    return
  end
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("请整理出一格背包再打开！")
    return
  end
  local tbName = {
    [1] = "帅哥",
    [2] = "美女",
  }
  local tbItemId = tbGuangGun.tbPartner[nValue][MathRandom(1, 2)]
  local pItem = me.AddItem(unpack(tbItemId))
  if pItem then
    pItem.SetTimeOut(0, GetTime() + 24 * 60 * 60)
    pItem.Sync()
  else
    return
  end
  Dialog:SendBlackBoardMsg(me, "你获得了一个" .. tbName[nValue] .. "跟宠")
  return 1
end
