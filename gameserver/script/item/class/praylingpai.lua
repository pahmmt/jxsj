-- 文件名　：prayitem.lua
-- 创建者　：zhouchenfei
-- 创建时间：2008-10-09 10:53:33
-- 祈福道具，增加祈福次数

local tbItem = Item:GetClass("praylingpai")
tbItem.tbLevelItem = {
  --等级, 声望, 次数
  [1] = { 30, 5 },
  [2] = { 200, 10 },
  [3] = { 640, 20 },
  [4] = { 30, 5 },
  [5] = { 200, 10 },
}

function tbItem:OnUse()
  local pPlayer = me
  local nNowTime = GetTime()
  local nType = it.nLevel
  local nRepute = self.tbLevelItem[nType][1]
  local nCount = self.tbLevelItem[nType][2]
  if nType >= 2 then
    if me.IsAccountLock() ~= 0 then
      me.Msg("你的账号处于锁定状态，无法使用该物品。")
      return 0
    end
  end
  if 1 == Task.tbPlayerPray:CheckLingPaiUsed(pPlayer, nNowTime) then
    pPlayer.Msg("祈福令牌每天只能使用一次，今天你不能使用了！")
    return 0
  end

  local nFlag, nReputeExt = Player:AddReputeWithAccelerate(pPlayer, 5, 4, nRepute)

  if 1 == nFlag then
    pPlayer.Msg("您已经达到祈福声望最高等级，将无法获得声望，但能继续获得相应的祈福机会！")
  end

  Task.tbPlayerPray:AddCountByLingPai(pPlayer, nCount)
  Task.tbPlayerPray:SetLingPaiUsedTime(pPlayer, nNowTime)

  pPlayer.Msg(string.format("你获得了%d次祈福机会！", nCount))

  return 1
end
