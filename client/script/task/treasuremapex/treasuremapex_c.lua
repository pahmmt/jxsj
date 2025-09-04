-- 文件名　：treasuremapex_c.lua
-- 创建者　：LQY
-- 创建时间：2012-11-28 10:45:33
-- 说　　明：藏宝图客户端脚本，用于UI

Require("\\script\\task\\treasuremapex\\treasuremapex_def.lua")
local TreasureMapEx = TreasureMap.TreasureMapEx
if not MODULE_GAMECLIENT then
  return
end
--获取队伍可以进入的星级
function TreasureMapEx:GetTeamStar_C()
  local nAllotModel, tbTeamList = me.GetTeamInfo()
  local nLevel = 999
  local bTeam = 0
  if me.nTeamId > 0 and tbTeamList then
    for _, pTeamPlayer in pairs(tbTeamList) do
      if not pTeamPlayer then
        return -1, "你的队伍不能进入藏宝图，必须所有对友都在附近！"
      end
      if pTeamPlayer.nLevel < nLevel then
        nLevel = pTeamPlayer.nLevel
      end
    end
    bTeam = 1
  else
    nLevel = me.nLevel
    bTeam = 0
  end
  local nStar, nLvlLow, nLvlTop = self:Level2Star(nLevel)
  if nStar == -1 then
    return -1, bTeam, nLevel
  end
  return nStar, bTeam, nLevel
end

function TreasureMapEx:ApplyTreasuremapInfo_C(tbData)
  Ui(Ui.UI_TREASUREMAP):SyncInfo(tbData)
end
