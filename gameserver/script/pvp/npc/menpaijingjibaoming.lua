-------------------------------------------------------------------
--File: 	menpaizhanbaomingdian.lua
--Author: 	zhengyuhua
--Date: 	2008-1-9 9:32
--Describe:	门派战报名点端脚本
-------------------------------------------------------------------

local tbNpc = Npc:GetClass("menpaijingjibaoming")

function tbNpc:OnDialog()
  local nFaction = tonumber(him.GetSctiptParam())
  local tbData = FactionBattle:GetFactionData(nFaction)
  if not tbData then
    Dialog:Say("目前没有门派竞技赛", {
      { "我要离开本门竞技场", FactionBattle.LeaveMap, FactionBattle, nFaction },
      { "我再考虑一下" },
    })
    return 0
  end
  local nCount = tbData:GetAttendPlayuerCount()
  local tbOpt = {
    { "我要报名参加门派竞技赛", FactionBattle.SignUp, FactionBattle, nFaction },
    { "我要离开本门竞技场", FactionBattle.LeaveMap, FactionBattle, nFaction },
    { "我再考虑一下" },
  }
  if tbData.nState == FactionBattle.SIGN_UP then
    table.insert(tbOpt, 2, { "我要取消报名", FactionBattle.CancelSignUp, FactionBattle, nFaction })
  end

  if FactionBattle._MODEL_NEW == FactionBattle.FACTIONBATTLE_MODLE then
    table.insert(tbOpt, #tbOpt - 1, { "新赛制说明", FactionBattle.DescribNewModel, FactionBattle, nFaction })
  end

  Dialog:Say("当前已报名参赛人数为" .. nCount .. "人", tbOpt)
end
