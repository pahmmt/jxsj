-- FileName	: detain.lua
-- Author	: 付瑞磊
-- Time		: 2010-5-7 13:56
-- Comment	: 玩家退出游戏的挽留界面（低于20级的玩家）

local uiDetain = Ui:GetClass("detain")
uiDetain.BTN_BUYBAIJU = "BtnBuyBaiju" -- 购买白驹丸
uiDetain.BTN_CHONGZHI = "BtnChongzhi" -- 充值
uiDetain.BTN_BACK2GAME = "BtnBack2Game" -- 返回游戏
uiDetain.BTN_LEAVE = "BtnLeave" -- 离开游戏
uiDetain.TEXT_NOTE = "TxtNote" -- 文字描述
uiDetain.BTN_SMALL_CLOSE = "BtnSmallClose"

function uiDetain:OnOpen()
  local szNotice = string.format("    不练级，不做任务，甚至连游戏都不上也可以获得经验吗？\n    达到20级的玩家可以通过<color=green>%s或绑定%s<color>在奇珍阁购买并使用<color=green>白驹丸<color>，进行离线托管。轻轻松松实现离线升级梦。", IVER_g_szCoinName, IVER_g_szCoinName)
  Txt_SetTxt(self.UIGROUP, self.TEXT_NOTE, szNotice)
end

function uiDetain:OnButtonClick(szWndName, nParam)
  if szWndName == self.BTN_BUYBAIJU then
    -- 购买白驹
    me.CallServerScript({ "Detain_BuyBaiju" })
  end

  if szWndName == self.BTN_CHONGZHI then
    -- 充值
    me.CallServerScript({ "ApplyOpenOnlinePay" })
  end

  if szWndName == self.BTN_BACK2GAME then
    -- 返回游戏
    UiManager:CloseWindow(self.UIGROUP)
  end

  if szWndName == self.BTN_LEAVE then
    -- 退出游戏
    ExitGame()
  end

  if szWndName == self.BTN_SMALL_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end
end
