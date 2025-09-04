-----------------------------------------------------------
-- 文件名　：zhunbeiqunpc.lua
-- 文件描述：准备区脚本 [路路通] [留一半]
-- 创建者　：ZhangDeheng
-- 创建时间：2008-11-26 20:21:59
-----------------------------------------------------------

-- 路路通
local tbNpc = Npc:GetClass("lulutong")
-- 传送的位置
tbNpc.tbPos = {
  { "碧蜈峰", 1714, 2980 },
  { "神蛛峰", 1876, 2991 },
  { "灵蝎峰", 1936, 2723 },
  { "天绝峰", 1777, 2739 },
}

function tbNpc:OnDialog()
  local nSubWorld, _, _ = him.GetWorldPos()
  local tbInstancing = Task.tbArmyCampInstancingManager:GetInstancing(nSubWorld)
  if not tbInstancing then
    return
  end
  assert(tbInstancing)

  local szMsg = "这是一条通往副本内各个地方的捷径，如果你或你的队友已经开启了通关的条件，便可以通过这条捷径直接前往那里。但需支付500两银子。"
  local tbOpt = {}
  for i = 1, #self.tbPos do
    tbOpt[#tbOpt + 1] = { "前往" .. self.tbPos[i][1], tbNpc.Send, self, i, tbInstancing, me.nId }
  end
  tbOpt[#tbOpt + 1] = { "结束对话" }
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:Send(nPos, tbInstancing, nPlayerId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return
  end

  if pPlayer.nCashMoney < 500 then
    Task.tbArmyCampInstancingManager:Warring(pPlayer, "你身上的钱不够！")
    return
  end

  if nPos == 1 and tbInstancing.nTaoHuaShiPass == 1 then
    self:SendToNewPos(nPos, tbInstancing.nMapId, nPlayerId)
    return
  elseif nPos == 2 and tbInstancing.nBiWuFengPass == 1 then
    self:SendToNewPos(nPos, tbInstancing.nMapId, nPlayerId)
    return
  elseif nPos == 3 and tbInstancing.nShenZhuFengPass == 1 then
    self:SendToNewPos(nPos, tbInstancing.nMapId, nPlayerId)
    return
  elseif nPos == 4 and tbInstancing.nLingXieFengPass == 1 then
    self:SendToNewPos(nPos, tbInstancing.nMapId, nPlayerId)
    return
  end

  Task.tbArmyCampInstancingManager:Warring(pPlayer, "只有通过关卡之后才可使用捷径")
end

function tbNpc:SendToNewPos(nPos, nMapId, nPlayerId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return
  end

  assert(pPlayer.CostMoney(500, Player.emKPAY_CAMPSEND) == 1)
  pPlayer.NewWorld(pPlayer.nMapId, tbNpc.tbPos[nPos][2], tbNpc.tbPos[nPos][3])
  pPlayer.SetFightState(1)
end

local tbLiuYiBan = Npc:GetClass("liuyiban")

tbLiuYiBan.tbLifePresentText = {
  [99] = "不要，不要靠近我！我这里什么都没有！",
  [80] = { "打不过我就跑", "你们真是阴魂不散的跟着我" },
  [60] = { "有本事就追上来！", "你们还真的追上来了！" },
  [40] = { "我跑！我再跑！", "能不能歇一会啊！" },
  [20] = { "不行了，我打累了！", "你们真是阴魂不散的跟着我！" },
  [0] = "你们……给我留一半啊……",
}

tbLiuYiBan.tbDrop = {
  { "setting\\npc\\droprate\\renwudiaoluo\\jindi_lv1.txt", 8 },
  { "setting\\npc\\droprate\\renwudiaoluo\\jindi_lv2.txt", 8 },
  { "setting\\npc\\droprate\\renwudiaoluo\\jindi_lv3.txt", 8 },
  { "setting\\npc\\droprate\\renwudiaoluo\\jindi_lv4.txt", 8 },
  { "setting\\npc\\droprate\\renwudiaoluo\\jindi_lv5.txt", 8 },
}

function tbLiuYiBan:OnDeath(pNpc)
  local nSubWorld, _, _ = him.GetWorldPos()
  local tbInstancing = Task.tbArmyCampInstancingManager:GetInstancing(nSubWorld)
  if not tbInstancing then
    return
  end
  assert(tbInstancing)

  if tbInstancing.nLiuYiBanOutCount > 5 then
    return
  end

  him.SendChat(self.tbLifePresentText[0])

  local tbPlayList, nCount = KPlayer.GetMapPlayer(tbInstancing.nMapId)
  for _, teammate in ipairs(tbPlayList) do
    teammate.Msg(self.tbLifePresentText[0], him.szName)
  end

  local nId = 0
  if pNpc and pNpc.GetPlayer() then
    nId = pNpc.GetPlayer().nId
  else
    nId = tbPlayList[1].nId
  end
  him.DropRateItem(self.tbDrop[tbInstancing.nLiuYiBanOutCount][1], self.tbDrop[tbInstancing.nLiuYiBanOutCount][2], -1, -1, nId)
end

function tbLiuYiBan:OnLifePercentReduceHere(nLifePercent)
  local nSubWorld, _, _ = him.GetWorldPos()
  local tbInstancing = Task.tbArmyCampInstancingManager:GetInstancing(nSubWorld)
  if not tbInstancing then
    return
  end
  assert(tbInstancing)

  if tbInstancing.nLiuYiBanOutCount == 0 or tbInstancing.nLiuYiBanOutCount >= 5 then
    return
  end
  if nLifePercent == 99 then
    him.SendChat(self.tbLifePresentText[nLifePercent])
    return
  end

  him.SendChat(self.tbLifePresentText[nLifePercent][1])

  local tbPlayList, nCount = KPlayer.GetMapPlayer(tbInstancing.nMapId)
  for _, teammate in ipairs(tbPlayList) do
    teammate.Msg(self.tbLifePresentText[nLifePercent][1], him.szName)
  end
  -- 掉落物品
  him.DropRateItem(self.tbDrop[tbInstancing.nLiuYiBanOutCount][1], self.tbDrop[tbInstancing.nLiuYiBanOutCount][2], -1, -1, tbPlayList[1].nId)
  tbInstancing.nLiuYiBanOutCount = tbInstancing.nLiuYiBanOutCount + 1
  him.Delete()
end
