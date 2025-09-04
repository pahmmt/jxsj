-- ====================== 文件信息 ======================

-- 万花谷副本 ITEM 脚本
-- Edited by peres
-- 2008/11/10 PM 01:50

-- 她的眼泪轻轻地掉落下来
-- 抚摸着自己的肩头，寂寥的眼神
-- 是，褪掉繁华和名利带给的空洞安慰，她只是一个一无所有的女子
-- 不爱任何人，亦不相信有人会爱她

-- ======================================================

local tbItem_Key = Item:GetClass("wanhuagu_key") -- 钥匙
local tbItem_BearSkin = Item:GetClass("wanhuagu_bearskin") -- 熊皮
local tbItem_Medicament = Item:GetClass("wanhuagu2_medicament") -- 隐身药
local tbItem_Drink = Item:GetClass("wanhuagu2_drink") -- 女儿红
local tbItem_Flute = Item:GetClass("wanhuagu2_flute") -- 笛子

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

function tbItem_Medicament:OnUse()
  local nMapId, nMapX, nMapY = me.GetWorldPos()
  local tbInstancing = TreasureMap2:GetInstancing(nMapId)
  if not tbInstancing or tbInstancing.nTreasureId ~= 4 then
    Dialog:SendInfoBoardMsg(me, "该物品只能在<color=yellow>万花谷中<color>使用！")
    return
  end
  GeneralProcess:StartProcess("吞服药剂中……", Env.GAME_FPS * 10, { self.ItemUsed, self, it.dwId, me.nId }, nil, tbEvent)
end

function tbItem_Medicament:ItemUsed(nItemId, nId)
  local pItem = KItem.GetObjById(nItemId)
  local pPlayer = KPlayer.GetPlayerObjById(nId)
  if not pItem or not pPlayer then
    return 0
  end

  local nMapId, nMapX, nMapY = pPlayer.GetWorldPos()
  local tbInstancing = TreasureMap2:GetInstancing(nMapId)
  if not tbInstancing then
    return
  end

  -- 加隐身技能
  pPlayer.GetNpc().CastSkill(122, 30, -1, pPlayer.GetNpc().nIndex)
  pItem.Delete(pPlayer)
  TreasureMap2:NotifyAroundPlayer(pPlayer, "<color=yellow>" .. pPlayer.szName .. "吞下了药剂，身体变得轻盈起来！<color>")
end

function tbItem_Drink:OnUse()
  local nMapId, nMapX, nMapY = me.GetWorldPos()
  local tbInstancing = TreasureMap2:GetInstancing(nMapId)
  if not tbInstancing or tbInstancing.nTreasureId ~= 4 then
    Dialog:SendInfoBoardMsg(me, "该物品只能在<color=yellow>万花谷中<color>使用！")
    return
  end

  local _, nDistance = TreasureMap2:GetDirection({ nMapX, nMapY }, { 1609, 3042 })

  if nDistance > 10 then
    Dialog:SendInfoBoardMsg(me, "<color=red>不能在这里使用！<color>")
    return
  end

  GeneralProcess:StartProcess("打开女儿红……", Env.GAME_FPS * 10, { self.ItemUsed, self, it.dwId, me.nId, nMapId }, nil, tbEvent)
end

function tbItem_Drink:ItemUsed(nItemId, nId, nMapId)
  local pItem = KItem.GetObjById(nItemId)
  local pPlayer = KPlayer.GetPlayerObjById(nId)
  if not pItem or not pPlayer then
    return 0
  end

  local nMapId, nMapX, nMapY = pPlayer.GetWorldPos()
  local tbInstancing = TreasureMap2:GetInstancing(nMapId)
  if not tbInstancing then
    return
  end

  if not tbInstancing.nBoss_6_Ready then
    tbInstancing.nBoss_6_Ready = 0
  end

  if tbInstancing.nBoss_6_Ready == 1 then
    return
  end

  --KNpc.Add2(2773, 100, 4, nMapId, 1610, 3042, 0, 0, 1);

  local nNpcLevel = tbInstancing.nNpcLevel -- 	TreasureMap2.TEMPLATE_LIST[tbInstancing.nTreasureId].tbNpcLevel[tbInstancing.nTreasureLevel] ;

  local pNpc = KNpc.Add2(6995, nNpcLevel, 4, nMapId, 1610, 3042, 0, 0, 1)
  if pNpc then
    pNpc.GetTempTable("TreasureMap2").nNpcScore = 90
  end
  tbInstancing.nBoss_6_Ready = 1
  pItem.Delete(pPlayer)
end

function tbItem_Flute:OnUse()
  local nMapId, nMapX, nMapY = me.GetWorldPos()
  local tbInstancing = TreasureMap2:GetInstancing(nMapId)
  if not tbInstancing or tbInstancing.nTreasureId ~= 4 then
    Dialog:SendInfoBoardMsg(me, "该物品只能在<color=yellow>万花谷中<color>使用！")
    return
  end

  local _, nDistance = TreasureMap:GetDirection({ nMapX, nMapY }, { 1595, 2890 })

  if nDistance > 36 then
    Dialog:SendInfoBoardMsg(me, "<color=yellow>在这里吹响的话，花豹听不到笛声<color>")
    return
  end

  GeneralProcess:StartProcess("吹响笛子……", Env.GAME_FPS * 10, { self.ItemUsed, self, it.dwId, me.nId }, nil, tbEvent)
end

function tbItem_Flute:ItemUsed(nItemId, nId)
  local pItem = KItem.GetObjById(nItemId)
  local pPlayer = KPlayer.GetPlayerObjById(nId)
  if not pItem or not pPlayer then
    return 0
  end

  local nMapId, nMapX, nMapY = pPlayer.GetWorldPos()
  local tbInstancing = TreasureMap2:GetInstancing(nMapId)
  if not tbInstancing then
    return
  end

  if tbInstancing.nBoss_5_Ready == 1 then
    return
  end

  if tbInstancing then
    local pNpc_1 = KNpc.GetById(tbInstancing.dwIdLeopard_1)
    local pNpc_2 = KNpc.GetById(tbInstancing.dwIdLeopard_2)
    if pNpc_1 and pNpc_2 then
      pNpc_1.Delete()
      pNpc_2.Delete()
      TreasureMap:NotifyAroundPlayer(pPlayer, "<color=yellow>" .. pPlayer.szName .. "吹响笛子，使得花豹冷静了下来！<color>")
    end

    local nNpcLevel = tbInstancing.nNpcLevel -- 	TreasureMap2.TEMPLATE_LIST[tbInstancing.nTreasureId].tbNpcLevel[tbInstancing.nTreasureLevel] ;

    local pNpc = KNpc.Add2(6994, nNpcLevel, 3, nMapId, 1588, 2887, 0, 0, 1)
    if pNpc then
      pNpc.GetTempTable("TreasureMap2").nNpcScore = 70
    end

    tbInstancing.nBoss_5_Ready = 1
    pItem.Delete(pPlayer)
  end
end
