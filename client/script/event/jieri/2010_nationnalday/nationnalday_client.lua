--=================================================
-- 文件名　：nationnalday_client.lua
-- 创建者　：furuilei
-- 创建时间：2010-08-25 11:57:30
-- 功能描述：2010国庆活动
--=================================================

SpecialEvent.tbNationnalDay = SpecialEvent.tbNationnalDay or {}
local tbEvent = SpecialEvent.tbNationnalDay or {}

function tbEvent:OpenCollectionWnd_Client()
  self:GetSpeArea_FromGblTask()
  UiManager:OpenWindow(Ui.UI_HOMELAND, self.tbSpeArea)
end
