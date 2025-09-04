local tbMap = Map:GetClass(1535)
local tbTrap = tbMap:GetTrapClass("trap_obj")

function tbTrap:OnPlayer()
  local tbMis = Esport.DragonBoat:GetPlayerMission(me)
  if tbMis and tbMis:IsOpen() == 1 then
    local nTime = GetTime()
    if tbMis:GetObjTime() + 5 <= nTime then
      tbMis:SetObjTime(nTime)
      local m, x, y = me.GetWorldPos()
      me.CastSkill(1384, 11, x * 32, y * 32) --眩晕3秒
      Dialog:SendBlackBoardMsg(me, "吖～你的龙舟撞到了岸边的礁石！")
      me.Msg("<color=blue>龙舟撞到了岸边的礁石！<color>")
    end
  end
end

local tbMap1 = Map:GetClass(2107)
local tbTrap1 = tbMap1:GetTrapClass("trap_obj")

function tbTrap1:OnPlayer()
  local tbMis = Esport.DragonBoat:GetPlayerMission(me)
  if tbMis and tbMis:IsOpen() == 1 then
    local nTime = GetTime()
    if tbMis:GetObjTime() + 5 <= nTime then
      tbMis:SetObjTime(nTime)
      local m, x, y = me.GetWorldPos()
      me.CastSkill(1384, 11, x * 32, y * 32) --眩晕3秒
      Dialog:SendBlackBoardMsg(me, "吖～你的龙舟撞到了岸边的礁石！")
      me.Msg("<color=blue>龙舟撞到了岸边的礁石！<color>")
    end
  end
end
