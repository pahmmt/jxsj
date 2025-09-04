-------------------------------------------------------
-- 文件名　: homeland_map.lua
-- 创建者　：huangxiaoming
-- 创建时间：2011-07-07 10:23:16
-- 文件描述：
-------------------------------------------------------

if not MODULE_GAMESERVER then
  return
end

Require("\\script\\kin\\homeland\\homeland_def.lua")

local tbMap = Map:GetClass(HomeLand.MAP_TEMPLATE)
HomeLand.Map = tbMap

function tbMap:OnEnter()
  local nTargetMapId = HomeLand:GetMapIdByPlayerId(me.nId)
  if nTargetMapId == 0 or nTargetMapId ~= me.nMapId then -- 不是自己的家族领地
    Dialog:SendBlackBoardMsg(me, "这不是你的家族领地，我还是送你回去吧。")
    me.NewWorld(unpack(HomeLand.DEFAULT_POS))
    return
  end
  me.SetFightState(0)
  local nKinId, nMemberId = me.GetKinMember()
  local cKin = KKin.GetKin(nKinId)
  SpecialEvent.tbKinPlant_2011:AddGroundNpc(nKinId, me.nMapId)
  KinPlant:AddGroundNpc(nKinId, me.nMapId)
  if cKin then
    StatLog:WriteStatLog("stat_info", "jiazulingdi", "comein", me.nId, cKin.GetName())
  end

  -- 为家族挑战令设置临时复活点
  me.SetTmpDeathPos(me.nMapId, unpack(HomeLand.CHALLENGE_REVIVE_POS))
  local tbTemp = me.GetTempTable("HomeLand")
  if not tbTemp.nOnDeathRegId then
    tbTemp.nOnDeathRegId = PlayerEvent:Register("OnDeath", HomeLand.OnChallengeDeath, HomeLand)
  end

  --进入的时候地图加植物坐标点
  local tbPlantPoint = KinPlant:GetSelfPlant()
  local tbWritePoint = {}
  for i, tbPos in ipairs(tbPlantPoint) do
    local bNear = 0
    for _, tbPosEx in ipairs(tbWritePoint) do
      if (tbPosEx[1] - tbPos[1]) * (tbPosEx[1] - tbPos[1]) + (tbPosEx[2] - tbPos[2]) * (tbPosEx[2] - tbPos[2]) <= 100 then
        bNear = 1
      end
    end
    if bNear == 0 then
      me.SetHighLightPoint(tbPos[1], tbPos[2], 12, i, "农作物", -1)
    else
      me.SetHighLightPoint(tbPos[1], tbPos[2], 12, i, " ", -1)
    end
    table.insert(tbWritePoint, tbPos)
  end
  tbTemp.__tbPlantPoint = { unpack(tbWritePoint) }
end

-- 离开地图的时候恢复角色复活点
function tbMap:OnLeave()
  local nRevMapId, nRevPointId = me.GetRevivePos()
  me.SetRevivePos(nRevMapId, nRevPointId)

  local tbTemp = me.GetTempTable("HomeLand")
  if tbTemp.nOnDeathRegId then
    PlayerEvent:UnRegister("OnDeath", tbTemp.nOnDeathRegId)
    tbTemp.nOnDeathRegId = nil
  end

  --出去的时候清掉地图上的植物坐标点
  if tbTemp.__tbPlantPoint then
    for i, tbPos in ipairs(tbTemp.__tbPlantPoint) do
      me.SetHighLightPoint(tbPos[1], tbPos[2], 0, i, "", 0)
    end
  end

  Dialog:ShowBattleMsg(me, 0, 0)
end
