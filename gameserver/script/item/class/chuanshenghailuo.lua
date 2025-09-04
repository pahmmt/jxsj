-- 传声海螺
local tbWhelk = Item:GetClass("chuanshenghailuo")

local TASK_CHAT = 2030 -- 1:上次公聊的日期，YYYYMMDD; 2:付费次数*1000+免费次数; 3:上次聊天的级别

function tbWhelk:OnUse()
  local nTaskChat = me.GetTask(TASK_CHAT, 2)
  local nPayCount = math.floor(nTaskChat / 1000) -- 附加次数
  local nFreeCount = nTaskChat % 1000 -- 免费次数
  local nAddCount = 0

  local nLevel = it.nLevel
  local szName = ""
  if nLevel == 1 then -- 小海螺
    nAddCount = 10
    szName = "传声海螺（小）"
  elseif nLevel == 2 then -- 中海螺
    nAddCount = 100
    szName = "传声海螺（中）"
  elseif nLevel == 3 then -- 大海螺
    nAddCount = 500
    szName = "传声海螺（大）"
  else
    return 0
  end

  nPayCount = nPayCount + nAddCount
  if nPayCount > 3000 then
    me.Msg("您的附加公聊次数将超过3000次上限，暂时不能使用传声海螺。")
    return 0
  end

  me.SetTask(TASK_CHAT, 2, nPayCount * 1000 + nFreeCount)
  me.Msg("您使用了" .. szName .. "，您的附加公聊次数增加到" .. nPayCount .. "次。")
  return 1
end
