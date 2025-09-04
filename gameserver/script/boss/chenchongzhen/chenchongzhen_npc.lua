-- 文件名　：chenchongzhen_npc.lua
-- 创建者　：zhangjunjie
-- 创建时间：2012-02-20 15:22:36
-- 描述：npc

local tbEvent = {
  Player.ProcessBreakEvent.emEVENT_MOVE,
  Player.ProcessBreakEvent.emEVENT_ATTACK,
  Player.ProcessBreakEvent.emEVENT_SITE,
  Player.ProcessBreakEvent.emEVENT_USEITEM,
  Player.ProcessBreakEvent.emEVENT_ARRANGEITEM,
  Player.ProcessBreakEvent.emEVENT_DROPITEM,
  Player.ProcessBreakEvent.emEVENT_SENDMAIL,
  Player.ProcessBreakEvent.emEVENT_TRADE,
  Player.ProcessBreakEvent.emEVENT_CHANGEFIGHTSTATE,
  Player.ProcessBreakEvent.emEVENT_CLIENTCOMMAND,
  Player.ProcessBreakEvent.emEVENT_LOGOUT,
  Player.ProcessBreakEvent.emEVENT_DEATH,
  Player.ProcessBreakEvent.emEVENT_ATTACKED,
}

local tbNpc = Npc:GetClass("chenchongzhen_npc")

function tbNpc:OnDialog()
  if KGblTask.SCGetDbTaskInt(DBTASK_CROSSTIMEROOM_CLOSESTATE) ~= 0 then
    Dialog:Say(string.format("老妪：你好，%s!", me.szName))
    return 0
  end
  if TimeFrame:GetState("OpenBoss120") ~= 1 then
    Dialog:Say(string.format("老妪：你好，%s!", me.szName))
    return 0
  else
    local nOpenBoss120Week = Lib:GetLocalWeek(TimeFrame:GetTime("OpenBoss120"))
    local nNowWeek = Lib:GetLocalWeek(GetTime())
    if nNowWeek <= nOpenBoss120Week then
      Dialog:Say(string.format("老妪：你好，%s!", me.szName))
      return 0
    end
  end
  local szMsg = "    ……如今皆是生前梦，一任风霜了烟尘。回首云开枫映色，不见当年紫衣深。\n   恩？你问商会的商队？老身还真没见过。这可是不让人迷失在海市蜃楼的辟魑锁？可否借老身一看？"
  local tbOpt = {}
  local nLastGetTime = Lib:GetLocalWeek(me.GetTask(ChenChongZhen.nTaskGroupId, ChenChongZhen.nTaskGetItemTime))
  local nNowWeekTime = Lib:GetLocalWeek()
  if nLastGetTime ~= nNowWeekTime then
    tbOpt[#tbOpt + 1] = { "领取辰虫镇令牌", ChenChongZhen.GiveChenChongZhenItem, ChenChongZhen }
  end
  tbOpt[#tbOpt + 1] = { "老人家请过目[开启辰虫镇]", self.Process, self }
  tbOpt[#tbOpt + 1] = { "我再想想" }
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:Process()
  local szMsg = "我可以带你去辰虫镇!"
  local tbOpt = {}
  if me.nFaction <= 0 then
    Dialog:Say("想进入辰虫镇，先加了门派再来找我！")
    return 0
  end
  if me.nLevel < 100 then
    Dialog:Say("想进入辰虫镇，等你达到100级再来找我吧！")
    return 0
  end
  local nTeamId = me.nTeamId
  if nTeamId <= 0 then
    Dialog:Say("想进入辰虫镇，请组队前来！")
    return 0
  end
  local pGame = ChenChongZhen:GetGameObjByTeamId(me.nTeamId)
  if not pGame then
    tbOpt[#tbOpt + 1] = { "开启辰虫镇", self.ApplyGame, self }
  else
    tbOpt[#tbOpt + 1] = { "进入辰虫镇", self.Transfer, self }
  end
  tbOpt[#tbOpt + 1] = { "我再想想" }
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:ApplyGame()
  if me.nFaction <= 0 then
    Dialog:Say("想进入辰虫镇，先加了门派再来找我！")
    return 0
  end
  if me.nLevel < 100 then
    Dialog:Say("想进入辰虫镇，等你达到100级再来找我吧！")
    return 0
  end
  if me.nTeamId <= 0 then
    Dialog:Say("想进入辰虫镇，请组队前来！")
    return 0
  end
  if me.IsCaptain() ~= 1 then
    Dialog:Say("想进入辰虫镇，请队长前来报名！")
    return 0
  end
  local nRet, szError = ChenChongZhen:CheckCanApply()
  if nRet ~= 1 then
    Dialog:Say(szError)
    return 0
  end
  local nNearby = 0
  local tbMemberId, nCount = KTeam.GetTeamMemberList(me.nTeamId)
  local tbPlayerList = KPlayer.GetAroundPlayerList(me.nId, 40)
  for _, tbRound in pairs(tbPlayerList or {}) do
    for _, nMemberId in pairs(tbMemberId) do
      local pMember = KPlayer.GetPlayerObjById(nMemberId)
      if pMember and pMember.szName == tbRound.szName then
        nNearby = nNearby + 1
      end
    end
  end
  if nNearby ~= nCount then
    Dialog:Say("对不起，有队友不在身边！")
    return 0
  end
  --todo,检查队友身上次数，和队友身上道具是否符合条件
  local nIsPlayerHasNoItem, tbNoItemPlayerName = 0, {}
  local nIsPlayerNoGetLevel, tbNoGetLevelPlayerName = 0, {}
  local nIsPlayerNoFaction, tbNoFactionPlayerName = 0, {}
  local nIsPlayerNotGetTask, tbNoTaskPlayerName = 0, {}
  for _, nMemberId in pairs(tbMemberId) do
    local pMember = KPlayer.GetPlayerObjById(nMemberId)
    if pMember then
      if ChenChongZhen:CheckHaveJoinItem(pMember) ~= 1 then
        nIsPlayerHasNoItem = 1
        table.insert(tbNoItemPlayerName, pMember.szName)
      end
      if pMember.nLevel < 100 then
        nIsPlayerNoGetLevel = 1
        table.insert(tbNoGetLevelPlayerName, pMember.szName)
      end
      if pMember.nFaction <= 0 then
        nIsPlayerNoFaction = 1
        table.insert(tbNoFactionPlayerName, pMember.szName)
      end
      if not Task:GetPlayerTask(pMember).tbTasks[ChenChongZhen.nHaveTaskId] or Task:GetPlayerTask(pMember).tbTasks[ChenChongZhen.nHaveTaskId].nCurStep ~= ChenChongZhen.nTaskNeedStep then
        nIsPlayerNotGetTask = 1
        table.insert(tbNoTaskPlayerName, pMember.szName)
      end
    end
  end
  if nIsPlayerNoGetLevel == 1 then --有等级未达到的
    local szMsg = ""
    for _, szName in pairs(tbNoGetLevelPlayerName) do
      szMsg = szMsg .. "<color=yellow>" .. szName .. "<color>等级未达到100级。\n"
    end
    Dialog:Say(szMsg)
    return 0
  end
  if nIsPlayerNoFaction == 1 then --有未加入门派的
    local szMsg = ""
    for _, szName in pairs(tbNoFactionPlayerName) do
      szMsg = szMsg .. "<color=yellow>" .. szName .. "<color>未加入任何门派。\n"
    end
    Dialog:Say(szMsg)
    return 0
  end
  if nIsPlayerHasNoItem == 1 then
    local szMsg = ""
    for _, szName in pairs(tbNoItemPlayerName) do
      szMsg = szMsg .. "<color=yellow>" .. szName .. "<color>身上没有辰虫镇令牌。\n"
    end
    Dialog:Say(szMsg)
    return 0
  end
  if nIsPlayerNotGetTask == 1 then
    local szMsg = ""
    for _, szName in pairs(tbNoTaskPlayerName) do
      szMsg = szMsg .. "<color=yellow>" .. szName .. "<color>没有接取辰虫镇任务或者接取的任务未到达指定步骤。\n"
    end
    Dialog:Say(szMsg)
    return 0
  end
  local pGame = ChenChongZhen:GetGameObjByTeamId(me.nTeamId)
  if not pGame then
    local nNum = ChenChongZhen:GetGameNum(GetServerId())
    if nNum >= ChenChongZhen.MAX_GAME then
      Dialog:Say("当前活动场地已满！")
      return 0
    end
    GCExcute({ "ChenChongZhen:ApplyGame_GC", me.nId, GetServerId(), me.nMapId })
    return 1
  else
    Dialog:Say("队长已经开启过副本了！")
    return 0
  end
end

function tbNpc:Transfer()
  ChenChongZhen:JoinGame()
end

--------room1 end的对话npc
local tbRoom1End = Npc:GetClass("chenchongzhen_room1_end")

function tbRoom1End:OnDialog()
  local szMsg = "    各位大侠稍安勿躁，你们寻的商队乃镇外风岫居士所擒。尔等只是听命行事，绝非本意。"
  local tbOpt = {}
  tbOpt[#tbOpt + 1] = { "风岫居士？哼，竟如此行事险恶。绑我商队在先，现又设计我们。且会他一会。", self.EndRoom, self }
  tbOpt[#tbOpt + 1] = { "看起来好像很厉害的样子……还是算了吧。" }
  Dialog:Say(szMsg, tbOpt)
end

function tbRoom1End:EndRoom()
  local pGame = ChenChongZhen:GetGameObjByMapId(me.nMapId) --获得对象
  if not pGame then
    return 0
  end
  pGame:StartRoom(2) --开启第二关
end

---room2 开启的对话npc
local tbRoom2Start = Npc:GetClass("chenchongzhen_room2_start")

function tbRoom2Start:OnDialog()
  local pGame = ChenChongZhen:GetGameObjByMapId(me.nMapId) --获得对象
  if not pGame then
    return 0
  end
  pGame:ProcessRoom2Start(him.dwId)
end

-----room4
local tbStarManager = Npc:GetClass("chenchongzhen_room4_start")

function tbStarManager:OnDialog()
  local pGame = ChenChongZhen:GetGameObjByMapId(me.nMapId) --获得对象
  if not pGame then
    return 0
  end
  local szMsg = ""
  local tbOpt = {}
  if pGame:GetRoom4LightIsBegin() ~= 1 then
    szMsg = "    唉。你们听信谗言，误闯我灯棋阵。此阵一旦开启极难停止，众位若要离开，<color=yellow>须点燃这棋盘中的某些座烛台，击毁阵眼——我的幻影。<color>\n\n    我无法关闭此阵，只可提示诸位需要点燃的灯座位置。<color=yellow>如若忘了位置，我自可提点三次，不过每次均会重启此阵。三次之后灯阵将会变化再启。<color>\n\n    途中自燃的灯座均为害人之物，还请各位慎重，及时将之损毁。  "
    tbOpt[#tbOpt + 1] = { "开启灯棋阵", self.BeginLight, self, him.dwId }
    tbOpt[#tbOpt + 1] = { "哼。恐怕都是你安排的吧。休听他蛊惑" }
  else
    szMsg = "    如若忘了位置，我自可提点三次，不过每次均会重启此阵。三次之后灯棋阵将会变化再启。\n    途中自燃的灯座均为害人之物，还请各位慎重，及时将之损毁。"
    tbOpt[#tbOpt + 1] = { "需燃灯座的位置，还请先生提点一二", self.ViewLightOrder, self, him.dwId }
    tbOpt[#tbOpt + 1] = { "请问先生，我们还有几次机会", self.ViewErrorCount, self, him.dwId }
    tbOpt[#tbOpt + 1] = { "我没啥好问的了" }
  end
  Dialog:Say(szMsg, tbOpt)
end

function tbStarManager:BeginLight(nNpcId, bSure)
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    return 0
  end
  local pGame = ChenChongZhen:GetGameObjByMapId(me.nMapId) --获得对象
  if not pGame then
    return 0
  end
  if pGame:GetRoom4LightIsBegin() == 1 then
    return 0
  end
  if bSure and bSure == 1 then
    pGame:StartRoom4Light()
  else
    local szMsg = "确定要开启我的灯棋阵？"
    local tbOpt = {}
    tbOpt[#tbOpt + 1] = { "确定开启", self.BeginLight, self, nNpcId, 1 }
    tbOpt[#tbOpt + 1] = { "我再想想" }
    Dialog:Say(szMsg, tbOpt)
  end
end

function tbStarManager:ViewLightOrder(nNpcId, bSure)
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    return 0
  end
  local pGame = ChenChongZhen:GetGameObjByMapId(me.nMapId) --获得对象
  if not pGame then
    return 0
  end
  if bSure and bSure == 1 then
    pGame:ProcessRoom4NotifyLight()
  else
    local szMsg = "如若忘了位置，我自可提点三次，不过每次均会重启此阵！"
    local tbOpt = {}
    tbOpt[#tbOpt + 1] = { "确定重启", self.ViewLightOrder, self, nNpcId, 1 }
    tbOpt[#tbOpt + 1] = { "我再想想" }
    Dialog:Say(szMsg, tbOpt)
  end
end

function tbStarManager:ViewErrorCount(nNpcId)
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    return 0
  end
  local pGame = ChenChongZhen:GetGameObjByMapId(me.nMapId) --获得对象
  if not pGame then
    return 0
  end
  local szMsg = string.format("唉，灯棋阵已经被打乱了<color=yellow>%s<color>了，要多加小心啊！", pGame:GetRoom4ErrorLightCount())
  Dialog:Say(szMsg, { "我知道了" })
end

--灯座
local tbLight = Npc:GetClass("chenchongzhen_room4_light")

function tbLight:OnDialog()
  local pGame = ChenChongZhen:GetGameObjByMapId(me.nMapId) --获得对象
  if not pGame then
    return 0
  end
  GeneralProcess:StartProcess("点灯中...", 5 * Env.GAME_FPS, { self.FireLight, self, him.dwId }, nil, tbEvent)
end

function tbLight:FireLight(nNpcId)
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    return 0
  end
  local pGame = ChenChongZhen:GetGameObjByMapId(me.nMapId) --获得对象
  if not pGame then
    return 0
  end
  local nIsNeed = pNpc.GetTempTable("ChenChongZhen").nIsNeedFire or 0
  local _, nX, nY = pNpc.GetWorldPos()
  pGame:ProcessRoom4FireLight(nIsNeed, nNpcId, nX, nY)
end

-----马匹
local tbHorse = Npc:GetClass("chenchongzhen_room7_horse")

tbHorse.tbGdpl = { 1, 12, 62, 1 } --给的马匹

tbHorse.nHorseItemTime = 5 * 60 --给的马匹的时间

function tbHorse:OnDialog()
  local pGame = ChenChongZhen:GetGameObjByMapId(me.nMapId) --获得对象
  if not pGame then
    return 0
  end
  local nRet, szError = self:CheckCanGetHorse()
  if nRet ~= 1 then
    Dialog:Say(szError)
    return 0
  end
  GeneralProcess:StartProcess("驯马中...", 5 * Env.GAME_FPS, { self.GetHorse, self, him.dwId }, nil, tbEvent)
end

function tbHorse:GetHorse(nNpcId)
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    return 0
  end
  local pGame = ChenChongZhen:GetGameObjByMapId(me.nMapId) --获得对象
  if not pGame then
    return 0
  end
  local nRet, szError = self:CheckCanGetHorse()
  if nRet ~= 1 then
    Dialog:Say(szError)
    return 0
  end
  local pItem = me.AddItemEx(self.tbGdpl[1], self.tbGdpl[2], self.tbGdpl[3], self.tbGdpl[4], nil, nil, GetTime() + self.nHorseItemTime)
  if pItem then
    me.AutoEquip(pItem) --自动装备上
    me.RideHorse(1) --自动上马
  end
  pNpc.Delete()
end

function tbHorse:CheckCanGetHorse()
  if me.CountFreeBagCell() < 1 then
    return 0, "需要<color=green>1格<color>背包空间，整理下再来！"
  end
  local pHorse = me.GetEquip(Item.EQUIPPOS_HORSE)
  local nIsEquipHorse = 0
  if pHorse and pHorse.SzGDPL() == string.format("%s,%s,%s,%s", self.tbGdpl[1], self.tbGdpl[2], self.tbGdpl[3], self.tbGdpl[4]) then
    nIsEquipHorse = 1
  end
  local tbFind = me.FindItemInAllPosition(unpack(self.tbGdpl))
  if #tbFind > 0 or nIsEquipHorse == 1 then
    return 0, "你已经领取过一匹马了！"
  end
  return 1
end

---机关
local tbSwitch = Npc:GetClass("chenchongzhen_room7_machine")

function tbSwitch:OnDialog()
  local pGame = ChenChongZhen:GetGameObjByMapId(me.nMapId) --获得对象
  if not pGame then
    return 0
  end
  if pGame:IsPlayerOpenedRoom7Switch(me.nId) == 1 then
    Dialog:Say("你已经开过机关了！")
    return 0
  end
  GeneralProcess:StartProcess("开机关中...", 5 * Env.GAME_FPS, { self.OpenSwitch, self, him.dwId }, nil, tbEvent)
end

function tbSwitch:OpenSwitch(nNpcId)
  local pGame = ChenChongZhen:GetGameObjByMapId(me.nMapId) --获得对象
  if not pGame then
    return 0
  end
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    return 0
  end
  if pGame:IsPlayerOpenedRoom7Switch(me.nId) == 1 then
    Dialog:Say("你已经开过机关了！")
    return 0
  end
  pGame:ProcessRoom7Switch(me.nId)
  pNpc.Delete()
  return 1
end

---路路通
local tbLulutong = Npc:GetClass("chenchongzhen_llt")

tbLulutong.tbTransferPos = {
  [1] = {},
  [2] = { "市集广场", { 1618, 3191 } },
  [3] = { "镇外仙际", { 56512 / 32, 96832 / 32 } },
  [4] = { "灯棋迷阵", { 1786, 2940 } },
  [5] = { "隐居之所", { 45920 / 32, 102176 / 32 } },
  [6] = { "劫后辰虫", { 58944 / 32, 102080 / 32 } },
  [7] = {},
}

function tbLulutong:OnDialog()
  local pGame = ChenChongZhen:GetGameObjByMapId(me.nMapId) --获得对象
  if not pGame then
    return 0
  end
  local nStepId = pGame.nTransferRoomMaxId
  if not nStepId then
    return 0
  end
  local tbInfo = {}
  for i = 1, nStepId do
    if #self.tbTransferPos[i] ~= 0 then
      table.insert(tbInfo, self.tbTransferPos[i])
    end
  end

  if #tbInfo <= 0 then
    local szMsg = "    你好，路程不算太远，自己跑过去，就当锻炼身体了。"
    local tbOpt = {}
    tbOpt[#tbOpt + 1] = { "我要离开", self.LeaveGame, self }
    tbOpt[#tbOpt + 1] = { "我知道了" }
    Dialog:Say(szMsg, tbOpt)
    return 0
  elseif pGame:CheckAllPlayerLock() == 0 and me.GetTask(2191, 5) == 1 then
    Dialog:Say("请等待当前关卡结束后，再使用路路通传送。")
    return 0
  else
    local szMsg = "    日行百里不含糊，想去哪，我可以免费送你一程！"
    local tbOpt = {}
    for _, tbPos in ipairs(tbInfo) do
      tbOpt[#tbOpt + 1] = { "送我去<color=yellow>" .. tbPos[1] .. "<color>", self.Transfer, self, tbPos[2] }
    end
    tbOpt[#tbOpt + 1] = { "我要离开", self.LeaveGame, self }
    tbOpt[#tbOpt + 1] = { "我知道了" }
    Dialog:Say(szMsg, tbOpt)
    return 0
  end
end

function tbLulutong:LeaveGame(bSure)
  if not bSure or bSure ~= 1 then
    local szMsg = "确定要离开么？"
    local tbOpt = {}
    tbOpt[#tbOpt + 1] = { "确定", self.LeaveGame, self, 1 }
    tbOpt[#tbOpt + 1] = { "我再想想" }
    Dialog:Say(szMsg, tbOpt)
  else
    local pGame = ChenChongZhen:GetGameObjByMapId(me.nMapId) --获得对象
    if not pGame then
      return 0
    end
    pGame:KickPlayer(me)
  end
end

function tbLulutong:Transfer(tbPos)
  if not tbPos then
    return 0
  end
  local pGame = ChenChongZhen:GetGameObjByMapId(me.nMapId) --获得对象
  if not pGame then
    return 0
  end
  me.NewWorld(me.nMapId, tbPos[1], tbPos[2])
  if me.nFightState == 0 then
    me.SetFightState(1)
  end
  if pGame:CheckAllPlayerLock() == 1 then
    pGame:UnlockAllPlayer()
  else
    me.SetTask(2191, 5, 0)
  end
  me.RemoveSkillState(2566)
  me.RemoveSkillState(2587)
end

--解debuff 的灯
local tbLightHelper = Npc:GetClass("chenchongzhen_room4_lighthelper")

tbLightHelper.nDebuffId = 2733

tbLightHelper.tbEvent = {
  Player.ProcessBreakEvent.emEVENT_MOVE,
  Player.ProcessBreakEvent.emEVENT_ATTACK,
  Player.ProcessBreakEvent.emEVENT_SITE,
  Player.ProcessBreakEvent.emEVENT_USEITEM,
  Player.ProcessBreakEvent.emEVENT_ARRANGEITEM,
  Player.ProcessBreakEvent.emEVENT_DROPITEM,
  Player.ProcessBreakEvent.emEVENT_SENDMAIL,
  Player.ProcessBreakEvent.emEVENT_TRADE,
  Player.ProcessBreakEvent.emEVENT_CHANGEFIGHTSTATE,
  Player.ProcessBreakEvent.emEVENT_CLIENTCOMMAND,
  Player.ProcessBreakEvent.emEVENT_LOGOUT,
  Player.ProcessBreakEvent.emEVENT_DEATH,
}

function tbLightHelper:OnDialog()
  local pGame = ChenChongZhen:GetGameObjByMapId(me.nMapId) --获得对象
  if not pGame then
    return 0
  end
  if me.GetSkillState(self.nDebuffId) <= 0 then
    return 0
  end
  GeneralProcess:StartProcess("解毒中...", 2 * Env.GAME_FPS, { self.RemoveDebuff, self, him.dwId }, nil, self.tbEvent)
end

function tbLightHelper:RemoveDebuff(nNpcId)
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    return 0
  end
  local pGame = ChenChongZhen:GetGameObjByMapId(me.nMapId) --获得对象
  if not pGame then
    return 0
  end
  if me.GetSkillState(self.nDebuffId) <= 0 then
    return 0
  end
  me.RemoveSkillState(self.nDebuffId)
end

------宝箱
local tbBox = Npc:GetClass("chenchongzhen_box")

function tbBox:OnDialog()
  local pGame = ChenChongZhen:GetGameObjByMapId(me.nMapId) --获得对象
  if not pGame then
    return 0
  end
  local tbPlayer = KNpc.GetAroundPlayerList(him.dwId, 32)
  if #tbPlayer ~= pGame:GetUnlockPlayerCount() then
    Dialog:Say("请队伍中的成员聚在宝箱周围方能开启。")
    return 0
  end
  local _, nTeamCount = KTeam.GetTeamMemberList(me.nTeamId)
  if nTeamCount < pGame:GetUnlockPlayerCount() then
    Dialog:Say("你没有队伍或者副本内有人不在你的队伍中！")
    return 0
  end
  for _, pPlayer in pairs(tbPlayer) do
    if pPlayer.nTeamId ~= me.nTeamId then
      Dialog:Say("副本内有人不在你的队伍中！")
      return 0
    end
  end
  GeneralProcess:StartProcess("鉴宝中...", 5 * Env.GAME_FPS, { self.DropItem, self, him.dwId }, nil, tbEvent)
end

function tbBox:DropItem(nNpcId)
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    return 0
  end
  local pGame = ChenChongZhen:GetGameObjByMapId(me.nMapId) --获得对象
  if not pGame then
    return 0
  end
  local nRoomId = pNpc.GetTempTable("ChenChongZhen").nRoomId or 1
  local tbInfo = ChenChongZhen.tbDropRateInfo[nRoomId]
  if not tbInfo then
    return 0
  end
  -- add
  --	local nMapId, nMapX, nMapY = pNpc.GetWorldPos();
  --	pGame:MoveAllPlayer(nMapId, nMapX, nMapY);
  local tbPlayer = KNpc.GetAroundPlayerList(pNpc.dwId, 32)
  if #tbPlayer ~= pGame:GetUnlockPlayerCount() then
    Dialog:Say("请队伍中的成员聚在宝箱周围方能开启。")
    return 0
  end
  local _, nTeamCount = KTeam.GetTeamMemberList(me.nTeamId)
  if nTeamCount < pGame:GetUnlockPlayerCount() then
    Dialog:Say("你没有队伍或者副本内有人不在你的队伍中！")
    return 0
  end
  for _, pPlayer in pairs(tbPlayer) do
    if pPlayer.nTeamId ~= me.nTeamId then
      Dialog:Say("副本内有人不在你的队伍中！")
      return 0
    end
  end
  local nLevel = #tbPlayer
  local nCount = tbInfo[1]
  local szFile = ChenChongZhen.tbDropRateInfoLevel[nLevel]
  if szFile and nCount then
    pNpc.DropRateItem(szFile, nCount, 0, -1, me.nId)
  end
  if tbInfo[2] then
    local nExCount = tbInfo[2][nLevel]
    local szExFile = ChenChongZhen.szDropRateInfoExtra
    if szExFile and nExCount then
      pNpc.DropRateItem(szExFile, nExCount, 0, -1, me.nId)
    end
  end
  local tbExpLevel = ChenChongZhen.tbDropRateInfoExp[nLevel]
  if tbExpLevel then
    local nExp = tbExpLevel[nRoomId]
    for _, pPlayer in pairs(tbPlayer) do
      pPlayer.AddExperience(nExp)
    end
  end
  pGame.tbRoomOpenBox[pNpc.GetTempTable("ChenChongZhen").nRoomId] = 1
  -- end
  pNpc.Delete()
end
