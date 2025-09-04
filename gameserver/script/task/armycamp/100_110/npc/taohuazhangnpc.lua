-----------------------------------------------------------
-- 文件名　：taohuazhangnpc.lua
-- 文件描述：桃花瘴区脚本 [鼎]
-- 创建者　：ZhangDeheng
-- 创建时间：2008-11-26 20:23:33
-----------------------------------------------------------

-- 桃花瘴区鼎
local tbNpc = Npc:GetClass("jiuningding")

tbNpc.tbNeedItemList = {
  { 20, 1, 623, 1, 10 },
}
function tbNpc:OnDialog()
  local nSubWorld, _, _ = him.GetWorldPos()
  local tbInstancing = Task.tbArmyCampInstancingManager:GetInstancing(nSubWorld)
  assert(tbInstancing)

  if tbInstancing.nTaoHuaZhangPass == 0 then
    Dialog:Say("此鼎可制作消除毒气伤害的解药！", {
      { "【制药】", self.Pharmacy, self, tbInstancing, me.nId },
      { "【结束对话】" },
    })
  end
end

function tbNpc:Pharmacy(tbInstancing, nPlayerId)
  Task:OnGift("放入10枚摄空草。", self.tbNeedItemList, { self.Pass, self, tbInstancing, nPlayerId }, nil, { self.CheckRepeat, self, tbInstancing }, true)
end

function tbNpc:Pass(tbInstancing, nPlayerId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  assert(pPlayer)

  local tbPlayList, _ = KPlayer.GetMapPlayer(tbInstancing.nMapId)
  for _, teammate in ipairs(tbPlayList) do
    Task.tbArmyCampInstancingManager:ShowTip(teammate, "制药完成, 您将不会再受到毒瘴的伤害！")
  end
  -- 删除桃花瘴的瘴气
  for i = 1, 3 do
    if tbInstancing.tbZhangQiId[i] then
      local pNpc = KNpc.GetById(tbInstancing.tbZhangQiId[i])
      if pNpc then
        pNpc.Delete()
      end
    end
  end

  -- 删除禁制
  if tbInstancing.nJinZhiTaoHuaLin then
    local pNpc = KNpc.GetById(tbInstancing.nJinZhiTaoHuaLin)
    if pNpc then
      pNpc.Delete()
    end
  end
  -- 添加天绝使
  local pTianJueShi = KNpc.Add2(4150, tbInstancing.nNpcLevel, -1, tbInstancing.nMapId, 1710, 3100) -- 天绝使
  local tbTianJueShi = Npc:GetClass("tianjueshi")
  tbInstancing:NpcSay(pTianJueShi.dwId, tbTianJueShi.tbText)
  pTianJueShi.GetTempTable("Task").tbSayOver = { tbTianJueShi.SayOver, tbTianJueShi, tbInstancing, pTianJueShi.dwId, nPlayerId }

  -- 设置桃花瘴可以通过
  tbInstancing.nTaoHuaZhangPass = 1
end

function tbNpc:CheckRepeat(tbInstancing)
  if tbInstancing.nTaoHuaZhangPass == 1 then
    return 0
  end
  return 1
end

-- 桃花瘴 天绝使
local tbTianJueShi = Npc:GetClass("tianjueshi")

tbTianJueShi.tbText = {
  "你们是谁？你们怎么会知道进山的方法？",
  "难道？不！不可能！",
  "不好了！有人闯山了！",
}
tbTianJueShi.tbTrack = { { 1704, 3095 }, { 1697, 3089 } }

function tbTianJueShi:SayOver(tbInstancing, nNpcId, nPlayerId)
  assert(nNpcId and nPlayerId)
  local pNpc = KNpc.GetById(nNpcId)
  assert(pNpc)

  tbInstancing:Escort(nNpcId, nPlayerId, self.tbTrack)
  pNpc.GetTempTable("Npc").tbOnArrive = { self.OnArrive, self, nNpcId, nPlayerId }
end

function tbTianJueShi:OnArrive(nNpcId, nPlayerId)
  assert(nNpcId and nPlayerId)
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    return
  end

  pNpc.Delete()
end

-- 桃花瘴指引
local tbTaoHusLinZhiYin = Npc:GetClass("taohualinzhiyin")

tbTaoHusLinZhiYin.szText = "    前面是百蛮山的天险桃花林，林内的桃花瘴气人畜难过，好在我们知道了通行之法。\n\n    你需要<color=red>将桃花林特有的碧鳞蛇口中的摄空草取10株来，投入到九凝鼎内，<color>炼化出的药气便可以以毒攻毒将瘴气驱散。"

function tbTaoHusLinZhiYin:OnDialog()
  local tbOpt = { { "结束对话" } }
  Dialog:Say(self.szText, tbOpt)
end
