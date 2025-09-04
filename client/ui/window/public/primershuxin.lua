-- 文件名　：primershuxin.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-08-09 14:35:00
-- 功能    ：

local uiPrimerShuXin = Ui:GetClass("primershuxin")

uiPrimerShuXin.Txt_Msg = "Txt_Msg"
uiPrimerShuXin.Btn_Close = "Btn_Close"
uiPrimerShuXin.TXX_INFOR = "TxtExInFor"
uiPrimerShuXin.nMaxWidth = 260
uiPrimerShuXin.nMaxHeight = 280
uiPrimerShuXin.nPerAdd = 1

uiPrimerShuXin.szMsg = [[

    一别三月，行军百日，昨得太爷手札，方闻【%s】武功精进，不可同日而语，乃偷闲数日之功邪？秋姨浅薄，只知武学之道，一悟一勤， 均不可废。

    【%s】弱冠即近，秋姨一事相托，望尔谨记。
    桃溪水贼之扰已久，幸得吕家仁义，并未酿成大害。而今局势动荡，吕家恐遭人觊觎。秋姨托付之事，即于义军拔营回前，保吕家孙子书青无恙。无须告之他人，多加提防即可。
                             
                     秋姨上
]]

function uiPrimerShuXin:OnOpen(szMsg)
  if not szMsg then
    szMsg = string.format(self.szMsg, me.szName, me.szName)
  end
  Txt_SetTxt(self.UIGROUP, self.Txt_Msg, szMsg)
  Wnd_Hide(self.UIGROUP, self.Btn_Close)
  self.nTxtSize = 20
  Wnd_SetSize(self.UIGROUP, self.Txt_Msg, self.nMaxWidth, self.nTxtSize)
  self.nTimer = Timer:Register(2, self.ShowTxt, self)
end

function uiPrimerShuXin:OnClose()
  if self.nTimer and self.nTimer > 0 then
    Timer:Close(self.nTimer)
  end
end

function uiPrimerShuXin:OnButtonClick(szWnd, nParam)
  if szWnd == self.Btn_Close then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiPrimerShuXin:ShowTxt()
  self.nTxtSize = self.nTxtSize + self.nPerAdd
  Wnd_SetSize(self.UIGROUP, self.Txt_Msg, self.nMaxWidth, self.nTxtSize)
  if self.nTxtSize < self.nMaxHeight then
    return
  end
  Wnd_Show(self.UIGROUP, self.Btn_Close)
  self.nTimer = 0
  return 0
end
