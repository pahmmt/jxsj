-- 文件名  : castlefight_update.lua
-- 创建者  : zounan
-- 创建时间: 2010-11-11 15:00:46
-- 描述    : 升级道具

local tbItem = Item:GetClass("castlefight_skill")
function tbItem:OnUse()
  local tbMission = CastleFight:GetPlayerTempTable(me).tbMission
  if not tbMission then
    me.Msg("不在活动中，不能使用。")
    return
  end

  if tbMission:IsPlaying() == 0 then
    me.Msg("时机不对，还使用不了！")
    return 0
  end

  if me.nFightState ~= 1 then
    me.Msg("必须在战斗状态下才能使用。")
    return
  end

  local nCurTimes = CastleFight:GetFinalSkillTimes(me)
  if nCurTimes <= 0 then
    me.Msg("您的大招次数已经用完，不能继续使用")
    return
  end

  local _, nX, nY = me.GetWorldPos()
  me.CastSkill(CastleFight.FINAL_SKILL_ID, 1, nX, nY)

  tbMission:BroadcastSystemMsg(string.format("<color=yellow>%s<color>使用了倾城必杀技", me.szName))
  tbMission:BroadcastBlackBoardMsg(string.format("<color=yellow>%s<color>使用了倾城必杀技", me.szName))
  tbMission:ConsumSkillCount(me.nId, 1)
  CastleFight:SetFinalSkillTimes(me, nCurTimes - 1)
end

function tbItem:InitGenInfo()
  it.SetTimeOut(0, GetTime() + CastleFight.ITEM_TIMEOUT)
  return {}
end
