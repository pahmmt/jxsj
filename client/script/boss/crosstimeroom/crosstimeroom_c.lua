-- 文件名　：crosstimeroom_c.lua
-- 创建者　：zhangjunjie
-- 创建时间：2011-10-11 10:33:56
-- 描述：client

if not MODULE_GAMECLIENT then
  return 0
end

function CrossTimeRoom:GetCrossTimeRoomOpenState()
  local nOpenBoss120Week = Lib:GetLocalWeek(TimeFrame:GetTime("OpenBoss120"))
  local nNowWeek = Lib:GetLocalWeek(GetTime())
  if KGblTask.SCGetDbTaskInt(DBTASK_CROSSTIMEROOM_CLOSESTATE) ~= 0 then
    return 0
  end
  if TimeFrame:GetState("OpenBoss120") ~= 1 then
    return 0
  end
  if nNowWeek <= nOpenBoss120Week then
    return 0
  end
  return 1
end
