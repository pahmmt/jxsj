-- ====================== 文件信息 ======================

-- 千琼宫副本 NPC 脚本
-- Edited by peres
-- 2008/07/25 AM 11:39

-- 她的眼泪轻轻地掉落下来
-- 抚摸着自己的肩头，寂寥的眼神
-- 是，褪掉繁华和名利带给的空洞安慰，她只是一个一无所有的女子
-- 不爱任何人，亦不相信有人会爱她

-- ======================================================

local tbNpc_Bag = Npc:GetClass("purepalace2_bag") -- 装有钥匙的袋子
local tbNpc_1 = Npc:GetClass("purepalace2_xiaolian_npc") -- 第一个对话类型 NPC
local tbNpc_2 = Npc:GetClass("purepalace2_xiaolian_fight") -- 护送 NPC

local tbNpc_Hiding = Npc:GetClass("purepalace2_hiding") -- 隐匿之处传送点
local tbNpc_Outside = Npc:GetClass("purepalace2_outside") -- 副本出口

local tbNpc_Task = Npc:GetClass("purepalace2_lixianglan")

tbNpc_1.tbTrack = {
  { 1629, 3044 },
  { 1640, 3030 },
  { 1618, 3008 },
  { 1596, 2981 },
  { 1571, 2956 },
}

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
  Player.ProcessBreakEvent.emEVENT_ATTACKED,
  Player.ProcessBreakEvent.emEVENT_DEATH,
  Player.ProcessBreakEvent.emEVENT_LOGOUT,
}

function tbNpc_1:OnDialog()
  local nMapId, nMapX, nMapY = him.GetWorldPos()
  local tbInstancing = TreasureMap2:GetInstancing(nMapId)

  if tbInstancing.tbBossDown[1] == 1 and tbInstancing.tbBossDown[2] == 0 and tbInstancing.nGirlProStep == 0 then
    local nKeys = me.GetItemCountInBags(18, 1, 183, 1)
    if nKeys > 0 then
      Dialog:Say("你们拿到解药了吗？", {
        { "来，你服下这解药试试", self.Release, self, him.dwId },
        { "再等等" },
      })
    else
      Dialog:Say("我被困这里已经很久了，不懂她们用了一种什么毒药，全身麻痹得不能动弹。你们帮帮我好吗？我真不明白，与她们无冤无仇为何这样对我。")
      return
    end
  end

  if tbInstancing.tbBossDown[2] == 1 and tbInstancing.nGirlProStep == 1 then
    local nKeys = me.GetItemCountInBags(18, 1, 184, 1)
    if nKeys > 0 and tbInstancing.tbBossDown[5] == 1 then
      Dialog:Say("你们帮我找到那颗宝珠了吗？", {
        { "来，你再服下这颗宝珠试试", self.Finish, self, him.dwId },
        { "再等等" },
      })
    else
      Dialog:Say("我还是觉得全身乏力，看来这一解毒散远远不能彻底根治我体内的毒，听说这千琼宫里有一颗<color=yellow>千年宝珠<color>，人服食了之后可解万疾，好心的人，你能帮我找到这颗宝珠吗？")
      return
    end
  end
end

function tbNpc_1:Release(nNpcId)
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    return
  end

  local nMapId, nMapX, nMapY = him.GetWorldPos()
  local tbInstancing = TreasureMap2:GetInstancing(nMapId)

  local nKeys = me.GetItemCountInBags(18, 1, 183, 1)

  if nKeys <= 0 then
    Dialog:Say("可是你身上并没有那个解药呀？")
    return
  end

  me.ConsumeItemInBags(1, 18, 1, 183, 1)

  local nCurMapId, nCurPosX, nCurPosY = him.GetWorldPos()
  him.Delete()

  local pFightNpc = KNpc.Add2(6968, 20, -1, nCurMapId, nCurPosX, nCurPosY, 0, 0, 1)

  -- 在这里记录小怜的 ID
  tbInstancing.nGirlId = pFightNpc.dwId

  pFightNpc.szName = "小怜"
  pFightNpc.SetTitle("由<color=yellow>" .. me.szName .. "<color>的队伍保护")
  pFightNpc.SetCurCamp(0)

  pFightNpc.RestoreLife()

  --	pFightNpc.GetTempTable("Npc").tbOnArrive = {tbNpc.OnArrive, tbNpc, pFightNpc, me};

  pFightNpc.AI_ClearPath()

  for _, Pos in ipairs(self.tbTrack) do
    if Pos[1] and Pos[2] then
      pFightNpc.AI_AddMovePos(tonumber(Pos[1]) * 32, tonumber(Pos[2]) * 32)
    end
  end

  pFightNpc.SetNpcAI(9, 50, 1, -1, 25, 25, 25, 0, 0, 0, me.GetNpc().nIndex)

  tbInstancing.nGirlProStep = 1
end

function tbNpc_1:Finish(nNpcId)
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    return
  end

  local nMapId, nMapX, nMapY = pNpc.GetWorldPos()
  local tbInstancing = TreasureMap2:GetInstancing(nMapId)

  local nKeys = me.GetItemCountInBags(18, 1, 184, 1)

  if nKeys <= 0 then
    Dialog:Say("可是你身上并没有那颗宝珠呀？")
    return
  end

  me.ConsumeItemInBags(1, 18, 1, 184, 1)

  local nCurMapId, nCurPosX, nCurPosY = pNpc.GetWorldPos()
  pNpc.Delete()

  TreasureMap2:NotifyAroundPlayer(me, "<color=yellow>小怜吞食了宝珠后，大笑一声，忽然不见踪影！<color>")

  local nNpcLevel = tbInstancing.nNpcLevel --	TreasureMap2.TEMPLATE_LIST[tbInstancing.nTreasureId].tbNpcLevel[tbInstancing.nTreasureLevel] ;

  -- 加隐藏 BOSS
  local pBoss = KNpc.Add2(6969, nNpcLevel, 3, nMapId, 1822, 2907)

  if pBoss then
    pBoss.GetTempTable("TreasureMap2").nNpcScore = 50
  end

  -- 加一个传送点
  local pSendPos = KNpc.Add2(6971, 1, -1, nMapId, nMapX, nMapY)
  pSendPos.szName = "神秘的入口"

  tbInstancing.nGirlProStep = 2
end

-- 护送 NPC 小怜被杀死
function tbNpc_2:OnDeath(pNpc)
  local nMapId, nMapX, nMapY = him.GetWorldPos()
  local tbInstancing = TreasureMap2:GetInstancing(nMapId)
  assert(tbInstancing)

  tbInstancing.nGirlKilled = 1
end

-- 打开袋子拿到解药
function tbNpc_Bag:OnDialog()
  local nFreeCell = me.CountFreeBagCell()
  if nFreeCell < 2 then
    Dialog:SendInfoBoardMsg(me, "请把背包清理出<color=yellow> 2 格或以上的空间<color>！")
    return
  end

  -- TODO:liucahng 10写到head中去
  GeneralProcess:StartProcess("开启中……", 10 * 18, { self.OnOpen, self, me.nId, him.dwId }, { me.Msg, "开启被打断" }, tbEvent)
end

function tbNpc_Bag:OnOpen(nPlayerId, dwNpcId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return
  end

  local nFreeCell = pPlayer.CountFreeBagCell()
  if nFreeCell < 2 then
    Dialog:SendInfoBoardMsg(pPlayer, "请把背包清理出<color=yellow> 2 格或以上的空间<color>！")
    return
  end

  local pNpc = KNpc.GetById(dwNpcId)

  if pNpc and pNpc.nIndex > 0 then
    local nMapId, nMapX, nMapY = pNpc.GetWorldPos()
    local tbInstancing = TreasureMap2:GetInstancing(nMapId)
    assert(tbInstancing)

    if tbInstancing.tbBossDown[1] == 1 and tbInstancing.tbBossDown[5] == 0 then
      pPlayer.AddItem(18, 1, 183, 1)
      pPlayer.Msg("<color=yellow>你得到了一瓶解药！<color>")
      -- 通知附近的玩家
      TreasureMap2:NotifyAroundPlayer(pPlayer, "<color=yellow>" .. pPlayer.szName .. "得到了一瓶解药！<color>")
    elseif tbInstancing.tbBossDown[5] == 1 then
      pPlayer.AddItem(18, 1, 184, 1)
      pPlayer.Msg("<color=yellow>你得到了一颗宝珠！<color>")
      -- 通知附近的玩家
      TreasureMap2:NotifyAroundPlayer(pPlayer, "<color=yellow>" .. pPlayer.szName .. "得到了一颗宝珠！<color>")
    end
    pNpc.Delete()
  end
end

function tbNpc_Task:OnDialog()
  Dialog:Say(string.format("%s，你好。", me.szName))
end

function tbNpc_Hiding:OnDialog()
  local nMapId, nMapX, nMapY = him.GetWorldPos()

  Dialog:Say("你想进入这不懂通向何方的入口吗？", {
    { "是的", self.Inside, self, nMapId },
    { "不了" },
  })
end

function tbNpc_Hiding:Inside(nMapId)
  me.NewWorld(nMapId, 1732, 2913)
end

function tbNpc_Outside:OnDialog()
  local nCaptainId = me.GetTempTable("TreasureMap2").nCaptainId
  if not nCaptainId then
    print("ERROR,qianqionggong outside dialog")
    return
  end

  local tbInstancing = TreasureMap2:GetInstancingByPlayerId(nCaptainId)
  if not tbInstancing then
    return
  end
  --	local nMapId, nMapX, nMapY	= tbInstancing.tbLeavePos[1],tbInstancing.tbLeavePos[2],tbInstancing.tbLeavePos[3];

  --	Dialog:Say(
  --	"你现在要离开这里吗？",
  --		{"是的", self.SendOut, self, me, nMapId, nMapX, nMapY},
  --		{"暂不"}
  --	);
end
