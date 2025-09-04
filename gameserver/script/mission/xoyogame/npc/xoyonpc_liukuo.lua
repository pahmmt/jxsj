local tbNpc = Npc:GetClass("heixinshangren_lv1")

function tbNpc:OnDialog()
  local nDifficulty = XoyoGame:GetDifficuty(me.nTeamId)
  local nFlag = me.GetTask(XoyoGame.TASK_GROUP, XoyoGame.EXCHANGE_ROOM_LEVEL)
  if XoyoGame.XINGSHENSHI_OPEN == 1 and GetMapType(me.nMapId) == "xoyogame" and nDifficulty >= XoyoGame.HUANSHENDAN_MIN_DIFFICULTY and nFlag >= 0 then
    local szMsg = "给我一枚生活技能药剂合成制作的“逍遥醒神石”，我就可以送你返回关卡，协助队友继续战斗。"
    local tbOpt = {
      { "送我返回战斗", self.GoFighting, self },
      { "打开药品商店", self.OpenMedicineShop, self },
      { "我只是路过的" },
    }
    Dialog:Say(szMsg, tbOpt)
  else
    self:OpenMedicineShop()
  end
end

function tbNpc:GoFighting(nCheck)
  local nPlayerId = me.nId
  local tbGame = XoyoGame:GetPlayerGame(nPlayerId)
  if not tbGame then
    Dialog:Say("你当老夫眼花了吗，你都没在逍遥中！")
    return 0
  end
  local tbRoom = tbGame:GetPlayerRoom(nPlayerId)
  if not tbRoom then
    Dialog:Say("你们队伍都没人在逍遥房间中，没有你可以去的地方，老实待着吧！")
    return 0
  end

  local nHasExchangeTimes = me.GetTask(XoyoGame.TASK_GROUP, XoyoGame.EXCHANGE_TIMES)
  local nRoomLevel = me.GetTask(XoyoGame.TASK_GROUP, XoyoGame.EXCHANGE_ROOM_LEVEL)
  local nLevel = tbRoom.tbSetting.nRoomLevel
  if nRoomLevel > 0 then
    Dialog:Say(string.format("你在当前关卡已经食用过逍遥醒神石，同一场战斗中只能使用一次！"))
    return 0
  end
  if nHasExchangeTimes >= XoyoGame.HUANSHENDAN_GAME_USETIMES then
    Dialog:Say(string.format("你这场逍遥已经用过%s颗逍遥醒神石了，不能再使用了", nHasExchangeTimes))
    return 0
  end
  local tbFind = me.FindItemInBags(unpack(XoyoGame.ITEM_HUANSHENDAN))
  if not tbFind[1] then
    Dialog:Say("你身上没有逍遥醒神石，我无法送你回去。")
    return 0
  end
  local tbMember, nNum = KTeam.GetTeamMemberList(me.nTeamId)
  local tbTeammateList = {}
  for j = 1, nNum do
    local pPlayer = KPlayer.GetPlayerObjById(tbMember[j])
    if pPlayer and GetMapType(pPlayer.nMapId) == "xoyogame" and pPlayer.nFightState == 1 and tbGame == XoyoGame:GetPlayerGame(pPlayer.nId) and tbRoom == tbGame:GetPlayerRoom(pPlayer.nId) then
      table.insert(tbTeammateList, pPlayer)
    end
  end
  if #tbTeammateList == 0 then
    Dialog:Say("没有合适的队友可以传送，还是耐心等一下吧")
    return 0
  end
  if nCheck and nCheck == 1 then
    local nRand = MathRandom(#tbTeammateList)
    if tbRoom:ReviveBackRoom(nPlayerId) ~= 1 then
      return 0
    end
    me.ConsumeItemInBags(1, unpack(XoyoGame.ITEM_HUANSHENDAN))
    local nMapId, nPosX, nPosY = tbTeammateList[nRand].GetWorldPos()
    me.NewWorld(nMapId, nPosX, nPosY)
    me.SetFightState(1)
    Player:AddProtectedState(me, XoyoGame.SUPER_TIME)
    me.SetTask(XoyoGame.TASK_GROUP, XoyoGame.EXCHANGE_ROOM_LEVEL, nLevel)
    me.SetTask(XoyoGame.TASK_GROUP, XoyoGame.EXCHANGE_TIMES, me.GetTask(XoyoGame.TASK_GROUP, XoyoGame.EXCHANGE_TIMES) + 1)
  else
    local tbOpt = {
      { "确定", self.GoFighting, self, 1 },
      { "取消" },
    }
    Dialog:Say(string.format("你本场逍遥还能使用<color=yellow>%s<color>枚逍遥醒神石，确定使用吗？", XoyoGame.HUANSHENDAN_GAME_USETIMES - nHasExchangeTimes), tbOpt)
  end
end

function tbNpc:OpenMedicineShop()
  Dialog:Say(self.tbMap[0].szMsg, self.tbMap[0].tbOpt)
end
