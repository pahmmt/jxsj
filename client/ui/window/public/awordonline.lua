-----------------------------------------------------
-- 文件名　：awordonline.lua
-- 创建者　：jiazhenwei
-- 创建时间：2010-04-26 15:36:43
-- 描  述  ：在线领奖
------------------------------------------------------

local uiAwordOnline = Ui:GetClass("awordonline")
SpecialEvent.tbAwordOnline = SpecialEvent.tbAwordOnline or {}
local tbAwordOnline = SpecialEvent.tbAwordOnline

uiAwordOnline.BTN_SIT = "aword"

function uiAwordOnline:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_SIT then
    me.CallServerScript({ "ApplyDayBackAward" })
  end
end
