-- author:	zhaoyu
-- date:	2010/4/7 9:54:47
-- comments:

local uiBuyIcon = Ui:GetClass("globalchatbuy")

uiBuyIcon.szBtnBuy = "BuyIcon"

function uiBuyIcon:OnOpen() end

function uiBuyIcon:OnClose() end

function uiBuyIcon:OnButtonClick(szWndName, nParam)
  local tbMsg = {}
  tbMsg.szMsg = string.format("您是否要直接消费<color=red>499%s<color>获得2次大区公聊机会？", IVER_g_szCoinName)
  tbMsg.nOptCount = 2
  function tbMsg:Callback(nOptIndex)
    if nOptIndex == 2 then
      if me.IsAccountLock() ~= 0 then
        UiNotify:OnNotify(UiNotify.emCOREEVENT_SET_POPTIP, 44)
        me.Msg("你的账号处于锁定状态，无法进行该操作！")
        Account:OpenLockWindow()
        return
      end
      if IVER_g_nSdoVersion == 0 then
        if me.nCoin >= 499 then
          me.CallServerScript({ "ApplyBuyQianLiChuanYin" })
        else
          me.Msg("您身上的金币数不够。")
        end
      else
        me.CallServerScript({ "ApplyBuyQianLiChuanYin" })
      end
    end
  end
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
end
