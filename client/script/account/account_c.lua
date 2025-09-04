-------------------------------------------------------------------
--File: account_c.lua
--Author: zhouchenfei
--Date: 2010-10-13 9:54:45
--Describe: ¿Í»§¶Ë
-------------------------------------------------------------------

function Account:OpenLockWindow(pPlayer)
  if EventManager.IVER_nOpenLockWnd == 1 then
    UiManager:OpenWindow(Ui.UI_LOCKACCOUNT)
  end
end
