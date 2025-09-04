-- 文件名　：bianshen.lua
-- 创建者　：xiewen
-- 创建时间：2008-11-07 10:46:46

-- 变身道具

local tbBianshen = Item:GetClass("bianshenlingpai")

tbBianshen.nSkillId = 889

function tbBianshen:OnUse()
  tbBianshen.nDuration = Env.GAME_FPS * it.GetExtParam(1)

  local pNpc = me.GetNpc()
  if not pNpc or pNpc.GetRangeDamageFlag() ~= 1 then
    me.Msg("您必须在征战状态下使用该道具。")
    return 0
  end

  if me.nLevel < it.nReqLevel then
    me.Msg("等级不够，无法使用变身道具.")
    return 0
  end

  if Item:IsBindItemUsable(it, me.dwTongId) ~= 1 then
    return 0
  end

  local tbOpenState = Domain:GetOpenStateTable()
  if not tbOpenState then
    print("Domain:GetOpenStateTable() failed")
    return 0
  end
  local a, b = it.GetTimeOut()
  if b == 0 then
    me.SetItemTimeout(it, os.date("%Y/%m/%d/%H/%M/00", GetTime() + 3600 * 24)) -- 领取当天有效
    it.Sync()
  end
  it.Bind(1) -- 强制绑定
  me.AddSkillState(tbBianshen.nSkillId, tbOpenState.nSkillLevel, 0, tbBianshen.nDuration, 1, 1)
  return 0
end

-- TODO
function tbBianshen:GetTip(nState)
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
