-- 声望令牌

local tbItem = Item:GetClass("domainrepute")
tbItem.REPUTE_CAMP = 8
tbItem.REPUTE_CLASS = 1

tbItem.tbData = {
  { 500, 10 },
  { 200, 12 },
  { 100, 14 },
}

-- nTimes: 已使用次数
-- nAddTimes: 要增加次数
function tbItem:GetRepute(nTimes, nAddTimes)
  if nTimes < 0 or nAddTimes <= 0 then
    return 0
  end
  local nRepute = 0
  local nBaseIndex
  for i = 1, #self.tbData do
    if nTimes < self.tbData[i][1] then
      nBaseIndex = i
    end
  end
  if nAddTimes + nTimes > self.tbData[1][1] then
    return 0
  end

  local nCurrIndex = nBaseIndex
  while nCurrIndex > 0 do
    local nDiff = (nTimes + nAddTimes) - self.tbData[nCurrIndex][1]
    if nDiff <= 0 then
      nRepute = nRepute + self.tbData[nCurrIndex][2] * nAddTimes
      break
    else
      local nIncrease = self.tbData[nCurrIndex][1] - nTimes
      nRepute = nRepute + self.tbData[nCurrIndex][2] * nIncrease
      nTimes = self.tbData[nCurrIndex][1]
      nAddTimes = nAddTimes - nIncrease
    end

    nCurrIndex = nCurrIndex - 1
  end
  return nRepute
end

local test = function(nTimes, nAddTimes, nRepute)
  assert(tbItem:GetRepute(nTimes, nAddTimes) == nRepute)
end
test(500, 1, 0)
test(0, 1, 14)
test(100, 1, 12)
test(200, 1, 10)
test(220, 1, 10)
test(60, 50, 40 * 14 + 10 * 12)
test(60, 220, 40 * 14 + 100 * 12 + 80 * 10)
test(101, 250, 99 * 12 + 151 * 10)
test(-1, 1, 0)
test(0, -1, 0)
test(-1, -1, 0)
test(50000, 500000, 0)

function tbItem:OnUse()
  if Item:IsBindItemUsable(it, me.dwTongId) == 0 then
    return 0
  end
  local nTimes = me.GetTask(Domain.TASK_GROUP_ID, Domain.USE_NUM)
  local nData = me.GetTask(Domain.TASK_GROUP_ID, Domain.USE_DATE)
  local nCurData = tonumber(os.date("%Y%m%d", GetTime()))
  if nCurData ~= nData then
    nTimes = 0
  end

  local nAddTimes = 1
  if it.nParticular == 376 then
    if me.IsAccountLock() ~= 0 then
      me.Msg("你的账号处于锁定状态，无法使用该物品。")
      return 0
    end
    nAddTimes = 50 -- 50倍穿杨弓
  end

  if nTimes + nAddTimes > self.tbData[1][1] then
    me.Msg("您今天再收藏了宝物的话就会超过500件，还是明天再收藏吧。")
    return 0
  end

  local nRepute = self:GetRepute(nTimes, nAddTimes)
  if nRepute <= 0 then
    me.Msg("使用穿杨弓时出现内部错误，请联系客服:(")
    return
  end

  local nFlag, nReputeExt = Player:AddReputeWithAccelerate(me, self.REPUTE_CAMP, self.REPUTE_CLASS, nRepute)

  if 0 == nFlag then
    return
  elseif 1 == nFlag then
    me.Msg("您已经达到领土争夺战声望最高等级，将无法使用领土争夺战声望令牌")
    return
  end
  me.SetTask(Domain.TASK_GROUP_ID, Domain.USE_DATE, nCurData)
  me.SetTask(Domain.TASK_GROUP_ID, Domain.USE_NUM, nTimes + nAddTimes)
  me.Msg(string.format("您今天收藏了<color=yellow>第%s件<color>领土战宝物！", nTimes + nAddTimes))
  return 1
end
