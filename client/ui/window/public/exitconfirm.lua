local uiExitConfirm = Ui:GetClass("exitconfirm")

uiExitConfirm.BTN_BUYBAIJU = "BtnBuyBaiju" -- 购买白驹丸
uiExitConfirm.BTN_CHONGZHI = "BtnChongzhi" -- 充值
uiExitConfirm.BTN_BACK2GAME = "BtnBack2Game" -- 返回游戏
uiExitConfirm.BTN_LEAVE = "BtnLeave" -- 离开游戏
uiExitConfirm.TEXT_NOTE = "TxtNote" -- 文字描述
uiExitConfirm.BTN_SMALL_CLOSE = "BtnSmallClose"

function uiExitConfirm:OnOpen()
  local szNotice = "点击<color=yellow>进入巴哈姆特<color>将会进入巴哈姆特并退出，点击<color=yellow>进入剑侠世界官网<color>将会进入官网并退出，点击<color=yellow>直接离开<color>就直接离开游戏了，确定退出吗？"
  Txt_SetTxt(self.UIGROUP, self.TEXT_NOTE, szNotice)
end

function uiExitConfirm:OnButtonClick(szWndName, nParam)
  if szWndName == self.BTN_BUYBAIJU then
    -- 购买白驹
    OpenWebSite("http://forum.gamer.com.tw/B.php?bsn=16509")
    Ui(Ui.UI_SYSTEM):QuitGame("Exit")
  end

  if szWndName == self.BTN_CHONGZHI then
    -- 充值
    OpenWebSite("http://jxw.gameflier.com/")
    Ui(Ui.UI_SYSTEM):QuitGame("Exit")
  end

  if szWndName == self.BTN_BACK2GAME then
    -- 返回游戏
  end

  if szWndName == self.BTN_LEAVE then
    -- 退出游戏
    Ui(Ui.UI_SYSTEM):QuitGame("Exit")
  end

  if szWndName == self.BTN_SMALL_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
    return
  end

  UiManager:CloseWindow(self.UIGROUP)
end
