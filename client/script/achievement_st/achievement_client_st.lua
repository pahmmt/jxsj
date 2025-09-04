-- 文件名　：achievement_client.lua
-- 创建者　：furuilei
-- 创建时间：2009-10-22 09:16:07

if not MODULE_GAMECLIENT then
  return
end

function Achievement_ST:SyncAchievementInfo(tbAchievementInfo)
  if not tbAchievementInfo then
    return
  end

  CoreEventNotify(UiNotify.emCOREEVENT_SYNC_ACHIEVEMENTINFO, tbAchievementInfo)
end
