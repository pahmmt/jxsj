-----------------------------------------------------
--文件名		：	accountsafe.lua
--创建者		：	fenghewen
--创建时间		：	2009-12-1
--功能描述		：	金山帐号安全提示界面
------------------------------------------------------
local uiAccountSafe = Ui:GetClass("accountsafe")
uiAccountSafe.SZ_CARD_JIESUO_URL = "http://ecard.xoyo.com/"
uiAccountSafe.SZ_LINGPAI_JIESUO_URL = "http://ekey.xoyo.com/"
uiAccountSafe.SZ_MIBAOSOFT_URL = "http://www.duba.net/zt/2009/mibao_jxsj2/"
uiAccountSafe.BTN_MIBAOKA = "BtnMiBaoKa"
uiAccountSafe.BTN_LINGPAI = "BtnLingPai"
uiAccountSafe.BTN_CLOSE = "BtnClose"
uiAccountSafe.TEXT_NOTE = "TxtNote"
uiAccountSafe.BTN_MIBAOSOFT = "BtnMibaoSoft"
uiAccountSafe.BTN_SMALL_CLOSE = "BtnSmallClose"

function uiAccountSafe:OnOpen()
  local szDISPROTECT_NOTE_KINGSOFT = "您的账号尚未开启金山密保卡或者令牌功能。\n\n为保障您的虚拟财产安全，强烈建议您免费开通密保卡服务，或者购买金山令牌，以及安装金山密保软件，有效防范木马的入侵。"
  Txt_SetTxt(self.UIGROUP, self.TEXT_NOTE, szDISPROTECT_NOTE_KINGSOFT)
end

function uiAccountSafe:OnButtonClick(szWndName, nParam)
  if szWndName == self.BTN_LINGPAI then
    OpenWebSite(self.SZ_LINGPAI_JIESUO_URL)
  end

  if szWndName == self.BTN_MIBAOKA then
    OpenWebSite(self.SZ_CARD_JIESUO_URL)
  end

  if szWndName == self.BTN_MIBAOSOFT then
    OpenWebSite(self.SZ_MIBAOSOFT_URL)
  end

  if szWndName == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end

  if szWndName == self.BTN_SMALL_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end
end
