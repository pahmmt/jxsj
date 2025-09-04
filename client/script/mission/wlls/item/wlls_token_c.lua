if not MODULE_GAMECLIENT then
  return
end

local tbClass = Item:GetClass("wlls_token")

function tbClass:GetTip()
  if TimeFrame:GetServerOpenDay() <= 365 then
    return ""
  end
  local nAccelerate = me.GetTask(2184, 2)
  local szTip = string.format("<color=green>剩余累积声望奖励%s点<color>", nAccelerate / 100)
  return szTip
end
