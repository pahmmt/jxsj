--=================================================
-- 文件名　：achievement_client.lua
-- 创建者　：furuilei
-- 创建时间：2010-07-09 10:59:18
-- 功能描述：成就系统_客户端逻辑
--=================================================

-- 比较成就
function Achievement:CompAchievement(szDstName)
  if not szDstName then
    return
  end

  me.CallServerScript({ "AchievementCmd", "CompAchievement_GS", szDstName })
end

function Achievement:CompAchievement_C(szDstName, tbInfo)
  if not szDstName or not tbInfo or Lib:CountTB(tbInfo) <= 0 then
    return
  end

  UiManager:OpenWindow(Ui.UI_ACHIEVEMENT, 2, 1, 1, 1, szDstName, tbInfo)
end

function Achievement:FinishAchievement_C(nAchievementId)
  if not nAchievementId or nAchievementId <= 0 then
    return
  end

  UiManager:OpenWindow(Ui.UI_FINISHACHIEVE, nAchievementId)
end
