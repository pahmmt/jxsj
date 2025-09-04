-- 文件名　：crosstimeroom_item.lua
-- 创建者　：zhangjunjie
-- 创建时间：2011-08-12 16:59:46
-- 描述：时光屋item

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

----对紫轩伤害的道具
local tbDamageItem = Item:GetClass("crosstimeroom_damage")

function tbDamageItem:OnUse()
  local nMapIndex = SubWorldID2Idx(me.nMapId)
  local nMapTemplateId = SubWorldIdx2MapCopy(nMapIndex)
  if nMapTemplateId ~= CrossTimeRoom.nTemplateMapId then
    me.Msg("当前无法使用该道具!")
    return 0
  end
  if me.nFightState == 0 then
    me.Msg("非战斗状态无法使用该道具!")
    return 0
  end
  return 0
end

function tbDamageItem:InitGenInfo()
  it.SetTimeOut(1, 20 * 60) --时长20分钟
  return {}
end

----蓝天玉
local tbStone = Item:GetClass("crosstimeroom_stone")

function tbStone:OnUse()
  local szMsg = ""
  local tbOpt = {
    { "我要制作", self.MakeStone, self, me.nId, it.dwId },
    { "我再想想" },
  }
  if it.IsBind() == 1 then
    table.insert(tbOpt, 1, { "我要解绑", self.FreeStone, self, me.nId, it.dwId })
    szMsg = string.format("    您可以使用<color=yellow>沧海锥<color>将它变为<color=yellow>不绑定<color>的蓝田玉。\n    也可以消耗精力、活力各%s点，将它打磨成一块<color=yellow>蓝田美玉<color>（<color=red>绑定<color>），可增加20点秦始皇陵·发丘门声望。", CrossTimeRoom.nMakeStoneJinghuo)
  else
    szMsg = string.format("    您可以消耗精力、活力各%s点，将它打磨成一块<color=yellow>蓝田美玉<color>（<color=green>不绑定<color>），可增加20点秦始皇陵·发丘门声望。", CrossTimeRoom.nMakeStoneJinghuo)
  end
  Dialog:Say(szMsg, tbOpt)
  return 0
end

function tbStone:FreeStone(nPlayerId, nItemId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return 0
  end
  local pItem = KItem.GetObjById(nItemId)
  if not pItem then
    return 0
  end
  local nCount = me.GetItemCountInBags(18, 1, 1452, 3)
  if nCount < 1 then
    Dialog:SendInfoBoardMsg(pPlayer, "解绑蓝田玉需要<color=yellow>沧海锥<color>，可以在家族金锭商店中购买。")
    return 0
  end
  local nNeed = 1
  if pPlayer.CountFreeBagCell() < nNeed then
    Dialog:SendInfoBoardMsg(pPlayer, string.format("请留出%s格背包空间。", nNeed))
    return 0
  end
  local nRet = pPlayer.ConsumeItemInBags(1, 18, 1, 1452, 3)
  if nRet ~= 0 then
    return 0
  end
  nRet = pPlayer.ConsumeItemInBags(1, 18, 1, 1452, 1)
  if nRet ~= 0 then
    return 0
  end
  pPlayer.AddItem(18, 1, 1452, 2)
end

function tbStone:MakeStone(nPlayerId, nItemId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return 0
  end
  local pItem = KItem.GetObjById(nItemId)
  if not pItem then
    return 0
  end
  local bCanMake, szError = self:CheckCanMake(pPlayer)
  if bCanMake ~= 1 then
    Dialog:Say(szError)
    return 0
  end
  GeneralProcess:StartProcess("打磨中...", 5 * Env.GAME_FPS, { self.DoMake, self, nPlayerId, pItem.dwId }, nil, tbEvent)
end

function tbStone:DoMake(nPlayerId, nItemId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return 0
  end
  local pItem = KItem.GetObjById(nItemId)
  if not pItem then
    return 0
  end
  local nBind = pItem.IsBind()
  local bCanMake, szError = self:CheckCanMake(pPlayer)
  if bCanMake ~= 1 then
    Dialog:Say(szError)
    return 0
  end
  local nNeedGTPMKP = CrossTimeRoom.nMakeStoneJinghuo
  local nCount = pItem.nCount or 0
  if nCount <= 0 then
    Dbg:WriteLog("CrossTimeRoom", "Item Not Found!", me.nId, me.szName)
    return 0
  end
  if nCount > 1 then
    if pItem.SetCount(nCount - 1) ~= 1 then
      Dbg:WriteLog("CrossTimeRoom", "Item Delete Failed!", me.nId, me.szName)
      return 0
    end
  else
    if me.DelItem(pItem, Player.emKLOSEITEM_USE) ~= 1 then
      Dbg:WriteLog("CrossTimeRoom", "Item Delete Failed!", me.nId, me.szName)
      return 0
    end
  end
  me.ChangeCurGatherPoint(-nNeedGTPMKP)
  me.ChangeCurMakePoint(-nNeedGTPMKP)
  local tbStoneInfo = (nBind == 1) and { 18, 1, 1453, 1 } or { 18, 1, 1453, 2 }
  local pAddItem = me.AddItem(unpack(tbStoneInfo))
  if pAddItem then
    CrossTimeRoom:RecordAward(0, me.nId, pAddItem.szName)
  end
  return 1
end

function tbStone:CheckCanMake(pPlayer)
  if not pPlayer then
    return 0
  end
  if GetMapType(pPlayer.nMapId) ~= "city" and GetMapType(pPlayer.nMapId) ~= "village" then
    return 0, "只能在各大新手村和城市才能进行制作！"
  end
  local szErrMsg = ""
  if pPlayer.CountFreeBagCell() < 1 then
    szErrMsg = "请保证留出<color=yellow>1格<color>背包空间！"
    return 0, szErrMsg
  end
  local nNeedGTPMKP = CrossTimeRoom.nMakeStoneJinghuo
  if pPlayer.dwCurGTP < nNeedGTPMKP or pPlayer.dwCurMKP < nNeedGTPMKP then
    szErrMsg = string.format("你的精活不足，打磨蓝田美玉需要消耗精力和活力各<color=yellow>%s点<color>。", nNeedGTPMKP)
    return 0, szErrMsg
  end
  return 1
end

local tbMeiyu = Item:GetClass("crosstimeroom_item_meiyu")

function tbMeiyu:OnUse()
  local szMsg = "    这是一块绑定的蓝田美玉，你可以使用<color=yellow>沧海锥<color>将它解绑，也可直接使用，增加20点秦始皇陵·发丘门声望。"
  local tbOpt = {
    { "我要解绑", self.FreeMeiyu, self, me.nId, it.dwId },
    { "直接使用", self.UseMeiyu, self, me.nId, it.dwId },
    { "我再想想" },
  }
  Dialog:Say(szMsg, tbOpt)
  return 0
end

function tbMeiyu:FreeMeiyu(nPlayerId, dwItemId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return 0
  end
  local pItem = KItem.GetObjById(dwItemId)
  if not pItem then
    return 0
  end
  local nCount = me.GetItemCountInBags(18, 1, 1452, 3)
  if nCount < 1 then
    Dialog:SendInfoBoardMsg(pPlayer, "解绑蓝田美玉需要<color=yellow>沧海锥<color>，可以在家族金锭商店中购买。")
    return 0
  end
  local nNeed = 1
  if pPlayer.CountFreeBagCell() < nNeed then
    Dialog:SendInfoBoardMsg(pPlayer, string.format("请留出%s格背包空间。", nNeed))
    return 0
  end
  local nRet = pPlayer.ConsumeItemInBags(1, 18, 1, 1452, 3)
  if nRet ~= 0 then
    return 0
  end
  nRet = pPlayer.ConsumeItemInBags(1, 18, 1, 1453, 1)
  if nRet ~= 0 then
    return 0
  end
  pPlayer.AddItem(18, 1, 1453, 2)
end

function tbMeiyu:UseMeiyu(nPlayerId, dwItemId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return 0
  end
  local pItem = KItem.GetObjById(dwItemId)
  if not pItem then
    return 0
  end
  local nReputeLevel = pPlayer.GetReputeLevel(9, 2)
  if nReputeLevel >= 2 then
    pPlayer.Msg("使用<color=yellow>蓝田美玉<color>只能使<color=green>秦始皇陵·发丘门<color>声望最高增加到<color=yellow>2<color>级！")
    return 0
  end
  local nUseMeiyu = pPlayer.GetTask(Boss.Qinshihuang.TASK_GROUP_ID, Boss.Qinshihuang.TASK_USE_MEIYU)
  if nUseMeiyu >= 30 then
    pPlayer.Msg("您今天已经使用了<color=yellow>30<color>块蓝田美玉，请明天再用吧！")
    return 0
  end
  local nRet = pPlayer.ConsumeItemInBags(1, 18, 1, 1453, 1)
  if nRet ~= 0 then
    return 0
  end
  local nFlag = Player:AddRepute(me, 9, 2, 20)
  if nFlag == 1 then
    pPlayer.Msg("您的<color=green>秦始皇陵·发丘门<color>声望已经达到最高级，不能再增加了！")
    return 0
  end
  pPlayer.SetTask(Boss.Qinshihuang.TASK_GROUP_ID, Boss.Qinshihuang.TASK_USE_MEIYU, nUseMeiyu + 1)
end

--------------记录产出点
function CrossTimeRoom:RecordAward(bAdd, nId, szItemName)
  if bAdd and bAdd == 1 then
    StatLog:WriteStatLog("stat_info", "yinyangshiguangdian", "gain", nId, szItemName or "蓝天玉", 1) --数据埋点
  else
    StatLog:WriteStatLog("stat_info", "yinyangshiguangdian", "process", nId, szItemName or "蓝天美玉", 1) --数据埋点
  end
end
