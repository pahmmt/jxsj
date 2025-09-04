-- 文件名　：lmfjnpc.lua
-- 创建者　：zhangjunjie
-- 创建时间：2011-10-27 19:40:54
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
}

-------------荆棘林入口npc
local tbStep2EnterNpc = Npc:GetClass("lmfj_step2_enter")

function tbStep2EnterNpc:OnDialog()
  local pGame = TreasureMap2:GetInstancing(me.nMapId) --获得对象
  if not pGame then
    return 0
  end
  local pRoom = pGame.tbRoom
  if not pRoom then
    return 0
  end
  if pRoom.nStepId ~= 2 then
    return 0
  end
  local szMsg = "    …莫言…金香玉…凌雁秋…乱世红尘红尘乱世……哈哈……\n    莫言花、金玉草、烟秋草、落影花、剑草。不找齐这些草药，炼制成御魂香，你是过不去骷髅穴口的……"
  Dialog:Say(szMsg, { "我知道了" })
end

--------------草药
local tbStep2Grass = Npc:GetClass("lmfj_step2_grass")

function tbStep2Grass:OnDialog()
  local pGame = TreasureMap2:GetInstancing(me.nMapId) --获得对象
  if not pGame then
    return 0
  end
  local pRoom = pGame.tbRoom
  if not pRoom then
    return 0
  end
  if pRoom.nStepId ~= 2 then
    return 0
  end
  GeneralProcess:StartProcess("采集中...", 1 * Env.GAME_FPS, { self.GetGrass, self, him.dwId }, nil, tbEvent)
end

function tbStep2Grass:GetGrass(nNpcId)
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    return 0
  end
  local pGame = TreasureMap2:GetInstancing(me.nMapId) --获得对象
  if not pGame then
    return 0
  end
  local pRoom = pGame.tbRoom
  if not pRoom then
    return 0
  end
  if pRoom.nStepId ~= 2 then
    return 0
  end
  local tbItem = pRoom.tbGrassItem[pNpc.nTemplateId]
  if not tbItem then
    return 0
  end
  if me.CountFreeBagCell() < 1 then
    local szMsg = "背包空间不足。"
    me.Msg(szMsg)
    return 0
  end
  local pItem = me.AddItem(unpack(tbItem)) --加草药
  if pItem then
    Dialog:SendBlackBoardMsg(me, "出口处有一炼香炉，把草药放入其中炼制试试...")
    pNpc.Delete()
  end
end

---------------收集草药的瓶子
local tbStep2Bottle = Npc:GetClass("lmfj_step2_bottle")

tbStep2Bottle.tbInputGDPL = --需要放入的材料gdpl
  {
    "18,1,1510,1",
    "18,1,1510,2",
    "18,1,1510,3",
    "18,1,1510,4",
    "18,1,1510,5",
  }

function tbStep2Bottle:OnDialog()
  local szMsg = string.format("    放入5种不同的草药(<color=yellow>莫言花，金玉草，烟秋草，落影花，剑草<color>)，可炼制御魂香，进入骷髅穴口！")
  local tbOpt = {}
  tbOpt[#tbOpt + 1] = { "放入草药", self.InputMaterial, self, him.dwId }
  tbOpt[#tbOpt + 1] = { "我知道了" }
  Dialog:Say(szMsg, tbOpt)
end

function tbStep2Bottle:InputMaterial()
  local pGame = TreasureMap2:GetInstancing(me.nMapId) --获得对象
  if not pGame then
    return 0
  end
  local pRoom = pGame.tbRoom
  if not pRoom then
    return 0
  end
  local tbHasGiveItem = pRoom.tbHasGiveGrass
  if pRoom.nNeedGrassCount - #tbHasGiveItem <= 0 then
    Dialog:Say(string.format("你已经收集齐%s种草药了，可以继续向前走了！", pRoom.nNeedGrassCount), { "我知道了" })
    return 0
  end
  local szNeed = ""
  for szName, nNeed in pairs(pRoom.tbGiveGrassName) do
    if nNeed == 1 then
      szNeed = szNeed .. szName .. "，"
    end
  end
  szNeed = string.sub(szNeed, 1, -3)
  local szMsg = string.format("你已经收集了%d种草药，还需要<color=yellow>%s<color>，快去荆棘林中寻找！", #tbHasGiveItem, szNeed)
  Dialog:OpenGift(szMsg, nil, { self.OnInputMaterial, self, him.dwId })
end

function tbStep2Bottle:CheckCanDel(szGDPL)
  if not szGDPL or #szGDPL == 0 then
    return 0
  end
  local bCanDel = 0
  for _, sz in pairs(self.tbInputGDPL) do
    if sz == szGDPL then
      bCanDel = 1
      break
    end
  end
  return bCanDel
end

function tbStep2Bottle:OnInputMaterial(nNpcId, tbItemObj)
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    return 0
  end
  local pGame = TreasureMap2:GetInstancing(me.nMapId) --获得对象
  if not pGame then
    return 0
  end
  local pRoom = pGame.tbRoom
  local nRoomId = pRoom.nStepId
  if not pRoom or nRoomId ~= 2 then
    return 0
  end
  for nCount, pItem in pairs(tbItemObj) do
    local szGDPL = pItem[1].SzGDPL()
    local szName = pItem[1].szName
    local nIsExisted = 0
    for _, szGrass in pairs(pRoom.tbHasGiveGrass) do
      if szGDPL == szGrass then
        nIsExisted = 1
        break
      end
    end
    if self:CheckCanDel(szGDPL) == 1 then
      if nIsExisted ~= 1 then
        table.insert(pRoom.tbHasGiveGrass, szGDPL)
        pRoom.tbGiveGrassName[szName] = 0
      end
      me.DelItem(pItem[1], 0)
    end
  end
  pRoom:ProcessGrass()
end

-----------------------------------------第三关接引人
local tbStep3EnterNpc = Npc:GetClass("lmfj_step3_enter")

function tbStep3EnterNpc:OnDialog()
  local pGame = TreasureMap2:GetInstancing(me.nMapId) --获得对象
  if not pGame then
    return 0
  end
  local pRoom = pGame.tbRoom
  if not pRoom then
    return 0
  end
  if pRoom.nStepId ~= 2 then --开启后nStepId为3，就不能再开第二次了
    return 0
  end
  pRoom:ProcessStep3()
end

------------------------------------------第三关骨头
local tbStep3Bone = Npc:GetClass("lmfj_step3_bone")

function tbStep3Bone:OnDialog()
  local pGame = TreasureMap2:GetInstancing(me.nMapId) --获得对象
  if not pGame then
    return 0
  end
  local pRoom = pGame.tbRoom
  if not pRoom then
    return 0
  end
  GeneralProcess:StartProcess("解毒中...", 1 * Env.GAME_FPS, { self.RemoveBuff, self, him.dwId }, nil, tbEvent)
end

function tbStep3Bone:RemoveBuff(nNpcId, nPlayerId)
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    return 0
  end
  --判断buff，清楚buff,删掉npc
  if me.GetSkillState(2407) > 0 then
    me.RemoveSkillState(2407)
  end
end

--------------------------第四关接引人
local tbStep4EnterNpc = Npc:GetClass("lmfj_step4_enter")

function tbStep4EnterNpc:OnDialog()
  local pGame = TreasureMap2:GetInstancing(me.nMapId) --获得对象
  if not pGame then
    return 0
  end
  local pRoom = pGame.tbRoom
  if not pRoom then
    return 0
  end
  local tbOrder = pRoom.tbNeedOpenStep4Order
  local szOrder = ""
  for i = 1, #tbOrder do
    szOrder = szOrder .. pRoom.tbSwitchName[tbOrder[i]] .. "，"
  end
  szOrder = string.sub(szOrder, 1, -3)
  local szMsg = string.format("    前方乃丹霞迷宫，据说按照<color=yellow>%s<color>的顺序开启机关，方能通过!\n    之前进去的人都成了噬人的怪物，<color=yellow>不消灭肮脏的怪物，宝藏和机关都不会出现的……<color>", szOrder)
  Dialog:Say(szMsg, { "我知道了" })
end

--------------------------------------机关
local tbStep4Switch = Npc:GetClass("lmfj_step4_switch")

function tbStep4Switch:OnDialog()
  local pGame = TreasureMap2:GetInstancing(me.nMapId) --获得对象
  if not pGame then
    return 0
  end
  local pRoom = pGame.tbRoom
  if not pRoom then
    return 0
  end
  if pRoom.nStepId ~= 4 then
    return 0
  end
  GeneralProcess:StartProcess("开启中...", 3 * Env.GAME_FPS, { self.OpenSwitch, self, him.dwId, me.nId }, nil, tbEvent)
end

function tbStep4Switch:OpenSwitch(nNpcId, nPlayerId)
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    return 0
  end
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return 0
  end
  local pGame = TreasureMap2:GetInstancing(pPlayer.nMapId) --获得对象
  if not pGame then
    return 0
  end
  local pRoom = pGame.tbRoom
  if not pRoom then
    return 0
  end
  if pRoom.nStepId ~= 4 then
    return 0
  end
  KTeam.Msg2Team(pPlayer.nTeamId, string.format("<color=yellow>%s<color>开启了机关<color=yellow>“%s”<color>", pPlayer.szName, pNpc.szName))
  pRoom:ProcessOpenSwitch(nNpcId, pPlayer.szName)
end

----------------------------------------------------宝箱
local tbStep4Box = Npc:GetClass("lmfj_step4_box")

tbStep4Box.tbBoxAward = {
  [1] = { 10000, { 500, 3600 } },
  [2] = { 20000, { 2900, 14900 } },
  [3] = { 30000, { 5000, 16500 } },
}

function tbStep4Box:OnDialog()
  local pGame = TreasureMap2:GetInstancing(me.nMapId) --获得对象
  if not pGame then
    return 0
  end
  local pRoom = pGame.tbRoom
  if not pRoom then
    return 0
  end
  if pGame.tbOpenBoxPlayer[me.nId] and pGame.tbOpenBoxPlayer[me.nId] >= pRoom.nOpenBoxMaxCount then
    me.Msg(string.format("你已经开启过%s次箱子了，不要太贪心了。", pRoom.nOpenBoxMaxCount))
    return 0
  end
  GeneralProcess:StartProcess("开启中...", 3 * Env.GAME_FPS, { self.OpenBox, self, him.dwId, me.nId }, nil, tbEvent)
end

function tbStep4Box:OpenBox(nNpcId, nPlayerId)
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    return 0
  end
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return 0
  end
  local pGame = TreasureMap2:GetInstancing(pPlayer.nMapId) --获得对象
  if not pGame then
    return 0
  end
  local pRoom = pGame.tbRoom
  if not pRoom then
    return 0
  end
  pGame:AddInstanceScore(2) --箱子给2分
  pGame:SendMsgByTeam("你的队伍打开一个箱子获得战斗积分<color=white>2<color>分。")
  pGame:AddOpenBoxPlayer(nPlayerId) --记录开过的玩家

  if pNpc.GetTempTable("TreasureMap2").nMaxOpenedCount >= pRoom.nBoxOpenedMaxCount then
    pNpc.Delete()
  end
  return 1
end

---------------------第5关去除buff的npc
local tbStep5Grass = Npc:GetClass("lmfj_step5_grass")

function tbStep5Grass:OnDialog()
  local pGame = TreasureMap2:GetInstancing(me.nMapId) --获得对象
  if not pGame then
    return 0
  end
  local pRoom = pGame.tbRoom
  if not pRoom then
    return 0
  end
  if pRoom.nStepId ~= 5 then
    return 0
  end
  --判断buff，清楚buff
  if me.GetSkillState(2410) <= 0 then
    return 0
  end
  GeneralProcess:StartProcess("解毒中...", 1 * Env.GAME_FPS, { self.RemoveBuff, self, him.dwId }, nil, tbEvent)
end

function tbStep5Grass:RemoveBuff(nNpcId)
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    return 0
  end
  --判断buff，清楚buff
  if me.GetSkillState(2410) > 0 then
    me.RemoveSkillState(2410)
  end
end

---------------------传入npc
local tbStep7TransferNpc = Npc:GetClass("lmfj_step7_transfer")

function tbStep7TransferNpc:OnDialog()
  local pGame = TreasureMap2:GetInstancing(me.nMapId) --获得对象
  if not pGame then
    return 0
  end
  local pRoom = pGame.tbRoom
  if not pRoom then
    return 0
  end
  if pRoom.nStepId ~= 7 then
    return 0
  end
  local tbPos = pRoom.tbTransferPos
  if not tbPos then
    return 0
  end
  local szMsg = "确定要进入龙门客栈么？？"
  local tbOpt = {}
  tbOpt[#tbOpt + 1] = { "是的，我要进去", self.Transfer, self, pGame.nMapId, tbPos }
  tbOpt[#tbOpt + 1] = { "我再想想" }
  Dialog:Say(szMsg, tbOpt)
end

function tbStep7TransferNpc:Transfer(nMapId, tbPos)
  if not nMapId or not tbPos then
    return 0
  end
  me.NewWorld(nMapId, tbPos[1], tbPos[2]) --传送到室内
  Player:AddProtectedState(me, 3) --加个3秒保护时间
end

---------------路路通
local tbLulutong = Npc:GetClass("lmfj_llt")

tbLulutong.tbTransferPos = {
  [1] = {},
  [2] = {},
  [3] = { "骷髅穴口", { 47104 / 32, 99488 / 32 } },
  [4] = {},
  [5] = { "新月绿洲", { 47424 / 32, 89056 / 32 } },
  [6] = {},
  [7] = { "龙门镖局分舵", { 50496 / 32, 92608 / 32 } },
}

function tbLulutong:OnDialog()
  local pGame = TreasureMap2:GetInstancing(me.nMapId) --获得对象
  if not pGame then
    return 0
  end
  local pRoom = pGame.tbRoom
  if not pRoom then
    return 0
  end
  local nStepId = pRoom.nStepId
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
    Dialog:Say(szMsg, { "我知道了" })
    return 0
  else
    local szMsg = "    日行百里不含糊，想去哪，我可以免费送你一程！"
    local tbOpt = {}
    for _, tbPos in ipairs(tbInfo) do
      tbOpt[#tbOpt + 1] = { "送我去<color=yellow>" .. tbPos[1] .. "<color>", self.Transfer, self, pGame.nMapId, tbPos[2] }
    end
    tbOpt[#tbOpt + 1] = { "我还是自己跑过去吧" }
    Dialog:Say(szMsg, tbOpt)
    return 0
  end
end

function tbLulutong:Transfer(nMapId, tbPos)
  if not nMapId or not tbPos then
    return 0
  end
  me.NewWorld(nMapId, tbPos[1], tbPos[2])
  Player:AddProtectedState(me, 3) --加个3秒保护时间
end
