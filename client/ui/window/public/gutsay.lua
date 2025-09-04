-----------------------------------------------------
--文件名		：	gutsay.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-8-15 15:55:08
--功能描述		：	对话面板。
------------------------------------------------------

local uiGutSay = Ui:GetClass("gutsay")

local IMAGE_PORTRAIT = "ImgPortrait"
local TEXT_DIALOG = "TxtDialog"
local LIST_ANSWER = "LstAnswer"

local TB_ANSWER_END = { 65536, "超级无敌结束对话" }

function uiGutSay:OnOpen(tbParam)
  local szPortrait, szPic, szContent = self:ParseQuestion(tbParam[1])
  Img_SetImage(self.UIGROUP, IMAGE_PORTRAIT, 1, szPortrait)
  Txt_SetTxt(self.UIGROUP, TEXT_DIALOG, szContent)
  Lst_Clear(self.UIGROUP, LIST_ANSWER)
  for i, v in ipairs(tbParam[2]) do
    Lst_SetCell(self.UIGROUP, LIST_ANSWER, i, 1, v)
  end
  Lst_SetCell(self.UIGROUP, LIST_ANSWER, TB_ANSWER_END[1], 1, TB_ANSWER_END[2])
end

function uiGutSay:ParseQuestion(szQuestion)
  local _, i, szHeadImg = string.find(szQuestion, "<head:([^>]*)>")
  local _, j, szPic = string.find(szQuestion, "<pic:([^>]*)>")

  if not i then
    i = 0
  end
  if not j then
    j = 0
  end

  local nOffset = math.max(i, j) + 1
  local szQues = string.sub(szQuestion, nOffset, -1)
  if not szHeadImg then
    szHeadImg = ""
  end
  if not szPic then
    szPic = ""
  end
  if not szQues then
    szQues = ""
  end

  return szHeadImg, szPic, szQues
end

function uiGutSay:OnButtonClick(szWnd, nParam)
  if szWnd == LIST_ANSWER then
    local nId = Lst_GetCurKey(self.UIGROUP, LIST_ANSWER)
    if nId == TB_ANSWER_END[1] then
      Ui(Ui.UI_GUTMODEL):GutEnd()
    else
      me.AnswerQestion(nId - 1)
    end
    UiManager:CloseWindow(self.UIGROUP)
  end
end
