-- 文件名　：crosstimeromm_chest.lua
-- 创建者　：LQY
-- 创建时间：2012-09-24 14:55:21
-- 说　　明：奖励宝箱
local tbNpc = Npc:GetClass("shiguangdian_box")
function tbNpc:OnDialog()
  local tbBreakEvent = {
    Player.ProcessBreakEvent.emEVENT_MOVE,
    Player.ProcessBreakEvent.emEVENT_ATTACK,
    Player.ProcessBreakEvent.emEVENT_SIT,
    Player.ProcessBreakEvent.emEVENT_RIDE,
    Player.ProcessBreakEvent.emEVENT_USEITEM,
    Player.ProcessBreakEvent.emEVENT_ARRANGEITEM,
    Player.ProcessBreakEvent.emEVENT_DROPITEM,
    Player.ProcessBreakEvent.emEVENT_CHANGEEQUIP,
    Player.ProcessBreakEvent.emEVENT_SENDMAIL,
    Player.ProcessBreakEvent.emEVENT_TRADE,
    Player.ProcessBreakEvent.emEVENT_CHANGEFIGHTSTATE,
    Player.ProcessBreakEvent.emEVENT_ATTACKED,
    Player.ProcessBreakEvent.emEVENT_DEATH,
    Player.ProcessBreakEvent.emEVENT_LOGOUT,
    Player.ProcessBreakEvent.emEVENT_REVIVE,
    Player.ProcessBreakEvent.emEVENT_CLIENTCOMMAND,
  }
  local tbData = him.GetTempTable("Npc")
  local tbAroundPlayers = KNpc.GetAroundPlayerList(him.dwId, 32)
  --理论上是不会出现这种情况的
  if not tbData.tbBase then
    return
  end
  local tbBasePlyaers = tbData.tbBase:GetPlayerList()
  if #tbAroundPlayers ~= #tbBasePlyaers then
    Dialog:Say("必须所有队员都附近才能开启！")
    return
  end
  local _, nTeamCount = KTeam.GetTeamMemberList(me.nTeamId)
  if nTeamCount < #tbBasePlyaers then
    Dialog:Say("你没有队伍或者副本内有人不在你的队伍中！")
    return
  end
  for _, pPlayer in pairs(tbAroundPlayers) do
    if pPlayer.nTeamId ~= me.nTeamId then
      Dialog:Say("副本内有人不在你的队伍中！")
      return
    end
  end
  GeneralProcess:StartProcess("开启中", 5 * Env.GAME_FPS, { CrossTimeRoom.GiveReward, CrossTimeRoom, tbData.nRoom or 0, tbData.tbBase, him.dwId }, nil, tbBreakEvent)
end
