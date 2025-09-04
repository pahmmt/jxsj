Require("\\script\\player\\player.lua")
if MODULE_GAMECLIENT then
  -- C
  -- Bắt đầu tỷ thí
  function Player:StartExerciseMsg(szName)
    local szMsg = "Ngươi đã thiết lập quan hệ tỷ thí với <color=yellow>" .. szName .. "<color>."
    UiManager:OpenWindow(Ui.UI_INFOBOARD, szMsg)
  end

  -- C
  -- Chuẩn bị cừu sát
  function Player:PreEnmityMsg(szName)
    local szMsg = "<color=yellow>" .. szName .. "<color> sẽ thiết lập quan hệ cừu sát với ngươi sau 10 giây!"
    UiManager:OpenWindow(Ui.UI_INFOBOARD, szMsg)
  end

  -- Bắt đầu cừu sát
  function Player:StartEnmityMsg(szName)
    local szMsg = "Ngươi đã thiết lập quan hệ cừu sát với <color=yellow>" .. szName .. "<color>."
    UiManager:OpenWindow(Ui.UI_INFOBOARD, szMsg)
  end
end

--S
if MODULE_GAMESERVER then
  -- Tỷ thí kết thúc
  function Player:CloseExerciseMsg(pWinPlayer, pLosePlayer)
    local szMsg = "Quan hệ tỷ thí kết thúc, ngươi đã chiến thắng <color=yellow>" .. pLosePlayer.szName .. "<color>"
    Dialog:SendInfoBoardMsg(pWinPlayer, szMsg)

    local szMsg = "Quan hệ tỷ thí kết thúc, ngươi đã bại bởi <color=yellow>" .. pWinPlayer.szName .. "<color>"
    Dialog:SendInfoBoardMsg(pLosePlayer, szMsg)
  end

  function Player:SucStealState(pLauncher, pTarget, nSkillId, nSkillLevel)
    local szMsg = "Đã trộm thành công <color=yellow>" .. FightSkill:GetSkillName(nSkillId) .. "<color> cấp " .. nSkillLevel .. " từ " .. pTarget.szName
    Dialog:SendInfoBoardMsg(pLauncher, szMsg)
  end

  function Player:StealStateTimeOut() end

  function Player:StealFailed(pLauncher)
    local szMsg = "Lần trộm này thất bại!"
    Dialog:SendInfoBoardMsg(pLauncher, szMsg)
  end
end
