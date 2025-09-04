-- ====================== 文件信息 ======================

-- 功能按键区 Tips
-- Edited by peres
-- 2007/10/24 PM 01:08

-- 在人群里，一对对年轻的情侣，彼此紧紧地纠缠在一起，旁若无人地接吻。
-- 爱情如此美丽，似乎可以拥抱取暖到天明。
-- 我们原可以就这样过下去，闭起眼睛，抱住对方，不松手亦不需要分辨。
-- 因为一旦睁开眼睛，看到的只是彼岸升起的一朵烟花。
-- 无法触摸，亦不可永恒……

-- ======================================================

local uiSideBarTips = Ui:GetClass("sidebartips")

function uiSideBarTips:OnMouseEnter(szWnd)
  UiManager:CloseWindow(self.UIGROUP)
end

function uiSideBarTips:OnButtonClick(szWnd, nParam)
  UiManager:CloseWindow(self.UIGROUP)
end
