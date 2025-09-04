-- 文件名　：questionnaires.lua
-- 创建者　：sunduoliang
-- 创建时间：2009-12-17 09:47:03
-- 描述　  ：调查问卷

SpecialEvent.Questionnaires = SpecialEvent.Questionnaires or {}
local tbQuest = SpecialEvent.Questionnaires

function tbQuest:OnOpen(szUrl)
  UiManager:OpenWindow(Ui.UI_QUESTIONS, szUrl)
end
