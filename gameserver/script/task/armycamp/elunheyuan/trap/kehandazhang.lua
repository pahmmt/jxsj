local tbMap = Map:GetClass(2152)
-- 可汗大帐入口
local tbTrap_1 = tbMap:GetTrapClass("kehandazhang_enter")
tbTrap_1.tbSendPos = { 1702, 3249 }
function tbTrap_1:OnPlayer()
  local nSubWorld, _, _ = me.GetWorldPos()
  local tbInstancing = Task.tbArmyCampInstancingManager:GetInstancing(nSubWorld)
  assert(tbInstancing)
  if tbInstancing.tbTollgateReset[6] ~= 2 then
    me.NewWorld(me.nMapId, self.tbSendPos[1], self.tbSendPos[2])
    Dialog:SendBlackBoardMsg(me, "只有了解我们草原的人才能进入我的大帐")
  elseif tbInstancing.tbTollgateReset[7] == 0 then
    me.NewWorld(me.nMapId, self.tbSendPos[1], self.tbSendPos[2])
    Dialog:SendBlackBoardMsg(me, "神使战斗中不喜欢有人打扰")
  end
end

-- 可汗大帐出口
local tbTrap_1 = tbMap:GetTrapClass("kehandazhang_exit")
tbTrap_1.tbSendPos = { 1712, 3233 }
function tbTrap_1:OnPlayer()
  local nSubWorld, _, _ = me.GetWorldPos()
  local tbInstancing = Task.tbArmyCampInstancingManager:GetInstancing(nSubWorld)
  assert(tbInstancing)
  if tbInstancing.tbTollgateReset[6] ~= 2 then
    me.NewWorld(me.nMapId, self.tbSendPos[1], self.tbSendPos[2])
    Dialog:SendBlackBoardMsg(me, "现在想走可是晚了")
  elseif tbInstancing.tbTollgateReset[7] == 0 then
    me.NewWorld(me.nMapId, self.tbSendPos[1], self.tbSendPos[2])
    Dialog:SendBlackBoardMsg(me, "想从这里出去可没那么容易")
  end
end
