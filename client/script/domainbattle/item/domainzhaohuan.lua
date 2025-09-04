-- 召唤道具
-- zhengyuhua

local tbItem = Item:GetClass("domainzhaohuan")

function tbItem:OnUse()
  if Item:IsBindItemUsable(it, me.dwTongId) ~= 1 then
    return 0
  end
  if Domain:GetBattleState() ~= Domain.BATTLE_STATE then
    me.Msg("现在不是征战期，不能使用召唤令牌")
    return 0
  end
  local nMapId, nX, nY = me.GetWorldPos()
  local bFight = Domain:HasBattleRight(me.dwTongId, nMapId)
  if bFight ~= 1 then
    me.Msg("你不在征战的区域内，无法使用召唤令牌")
    return 0
  end
  local tbOpenState = Domain:GetOpenStateTable()
  if not tbOpenState then
    return 0
  end
  local nTemplateId = it.GetExtParam(1)
  if Domain.tbGame[me.nMapId] then
    local pNpc = Domain.tbGame[me.nMapId]:AddTongNpc(nTemplateId, tbOpenState.nNpcLevel, me.dwTongId, nX, nY, 0, 2)
    if pNpc then
      local pOwner = KUnion.GetUnion(me.dwUnionId) or KTong.GetTong(me.dwTongId)
      if pOwner then
        pNpc.SetTitle(pOwner.GetName())
      end
      return 1
    end
  end
  return 0
end

-- TODO
function tbItem:GetTip(nState)
  local nOwnerTongId = KLib.Number2UInt(it.GetGenInfo(Item.TASK_OWNER_TONGID, 0))
  if nState == Item.TIPS_SHOP then
    return "<color=gold>该道具购买后将会与<color=red>帮会绑定<color>，本帮以外的玩家不可使用！<color>"
  elseif nOwnerTongId == 0 then
    return "<color=gold>该道具没与任何帮会绑定，任何人都可以使用<color>"
  elseif nOwnerTongId == me.dwTongId then
    return "<color=gold>该道具已和您的帮会绑定，其他帮会成员无法使用<color>"
  else
    return "<color=red>该道具已和其他帮会绑定，您不能使用！<color>"
  end
end
