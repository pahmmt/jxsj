-- 秦陵白银、黄金物品增加声望物品
-- By Peres 2009/06/13
-- 何不食肉糜

local tbItem = Item:GetClass("qinling_arm_item")

tbItem.tbData = {
  [369] = { 100, 2 }, -- 玉符，每次 100 点，最高加到 2 级
  [377] = { 100, 3 }, -- 和氏璧，每次 100 点，最高加到 3 级
  [1453] = { 20, 2 }, -- 蓝田美玉，每次 20 点，最高加到 3 级
}

function tbItem:OnUse()
  if me.IsAccountLock() ~= 0 then
    me.Msg("你的账号处于锁定状态，无法使用该物品。")
    return 0
  end
  if not self.tbData[it.nParticular] then
    me.Msg("使用出错！")
    return 0
  end

  local nReputeLevel = me.GetReputeLevel(9, 2)
  if nReputeLevel >= self.tbData[it.nParticular][2] then
    me.Msg("使用<color=yellow>" .. it.szName .. "<color>只能使<color=green>秦始皇陵·发丘门<color>声望最高增加到<color=yellow>" .. self.tbData[it.nParticular][2] .. "<color>级！")
    return 0
  end

  local nUseMeiyu = me.GetTask(Boss.Qinshihuang.TASK_GROUP_ID, Boss.Qinshihuang.TASK_USE_MEIYU)
  if it.nParticular == 1453 and nUseMeiyu >= 30 then
    me.Msg("您今天已经使用了<color=yellow>30<color>块蓝田美玉，请明天再用吧！")
    return 0
  end

  local nFlag = Player:AddRepute(me, 9, 2, self.tbData[it.nParticular][1])
  if nFlag == 0 then
    return 0
  elseif nFlag == 1 then
    me.Msg("您的<color=green>秦始皇陵·发丘门<color>声望已经达到最高级，不能再增加了！")
    return 0
  end

  me.SetTask(Boss.Qinshihuang.TASK_GROUP_ID, Boss.Qinshihuang.TASK_USE_MEIYU, nUseMeiyu + 1)
  return 1
end
