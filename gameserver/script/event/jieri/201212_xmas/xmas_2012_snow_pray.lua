-- 文件名　：xmas_2012_snow_pray.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-12-10 19:44:17
-- 功能说明：雪人的祝福

local tbItem = Item:GetClass("xmas_2012_snow_pray")
tbItem.nDuration = 60 * 60 * Env.GAME_FPS
tbItem.tbNpcTemplateId = { [11291] = 1, [11292] = 1 }
tbItem.nNpcTemplateId = 11291
tbItem.nStarLiveTime = 30 * 60 * Env.GAME_FPS
tbItem.tbMaskId = { 1, 13, 163, 10 }
tbItem.nMaxRandomNum = 10000
tbItem.nRate = 100

function tbItem:OnUse()
  local nMapId, nX, nY = me.GetWorldPos()
  local szMapType = GetMapType(nMapId)
  if szMapType ~= "village" and szMapType ~= "city" then
    Dialog:Say("该道具只能在新手村和各大城市使用！")
    return 0
  end
  local tbNpcList = KNpc.GetAroundNpcList(me, 10)
  for _, pNpc in ipairs(tbNpcList) do
    if pNpc.nKind == 3 or self.tbNpcTemplateId[pNpc.nTemplateId] then
      Dialog:Say("这里貌似太过拥挤了，还是换一个地方试试吧！")
      return 0
    end
  end
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("你身上的背包空间不足，需要1格背包空间。")
    return 0
  end

  local nMapId, nX, nY = me.GetWorldPos()
  local pNpc = KNpc.Add2(self.nNpcTemplateId, 1, -1, nMapId, nX, nY)
  if pNpc then
    pNpc.SetLiveTime(self.nStarLiveTime)
  end
  if MathRandom(self.nMaxRandomNum) <= self.nRate then
    local pMask = me.AddItemEx(unpack(self.tbMaskId))
    if pMask then
      me.SetItemTimeout(pMask, 3 * 24 * 60, 0)
    end
  end
  me.AddSkillState(385, 6, 2, self.nDuration, 1, 0, 1)
  me.AddSkillState(386, 6, 2, self.nDuration, 1, 0, 1)
  me.AddSkillState(387, 6, 2, self.nDuration, 1, 0, 1)
  return 1
end
