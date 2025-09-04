-- 文件名　：trap.lua
-- 创建者　：LQY
-- 创建时间：2012-11-07 14:58:10
-- 说　　明：罗刹秘窟
--
Require("\\script\\task\\treasuremap2\\instancing\\minlingtingyuan\\define.lua")
local tbInstancingBase = TreasureMap2:GetInstancingBase(8)
local tbMap = Map:GetClass(2291)

-- 如不改动框架功能，请勿修改
local tbBaseTrap = tbBaseTrap or {}
function tbBaseTrap:OnPlayer()
  if not tbInstancingBase[self.szType] then
    return
  end
  local tbInstancing = TreasureMap2:GetInstancing(me.nMapId)
  --处理Trap点特殊回调
  if tbInstancing.tbTrapEvent[self.szName] then
    for _, tbBack in pairs(tbInstancing.tbTrapEvent[self.szName]) do
      tbBack[1](tbBack[2], me, unpack(tbBack[3]))
    end
  end
  --分发到不同的处理函数
  if tbInstancing[self.szType] then
    tbInstancing[self.szType](tbInstancing, me, self.nStep, unpack(self.tbArg or {}))
  end
end
local function TrapLink()
  for szType, tbData in pairs(tbInstancingBase.tbTraps) do
    for n, tbTraps in pairs(tbData) do
      local tbTrap = tbMap:GetTrapClass(tbTraps[1])
      tbTrap.szType = szType
      tbTrap.nStep = n
      tbTrap.szName = tbTraps[1]
      tbTrap.tbArg = tbTraps[2]
      for szFnc in pairs(tbBaseTrap) do -- 复制函数
        tbTrap[szFnc] = tbBaseTrap[szFnc]
      end
    end
  end
end
TrapLink()
