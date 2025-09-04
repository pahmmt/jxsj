-- 文件名　：carrieroff.lua
-- 创建者　：LQY
-- 创建时间：2012-08-27 17:32:58
-- 说　　明：离开载具按钮
local uiNewBattle = Ui:GetClass("carrieroff")
uiNewBattle.BTN_CARRIEROFF = "carrieroff" -- 下车按钮
function uiNewBattle:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CARRIEROFF then
    UiManager:OnNKeyDown()
  end
end
