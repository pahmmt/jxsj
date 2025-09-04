-------------------------------------------------------
-- 文件名　 : kin_recruit_players.lua
-- 创建者　 : zhangjinpin@kingsoft
-- 创建时间 : 2011-09-02 15:31:01
-- 文件描述 :
-------------------------------------------------------

local uiKinPlayersList = Ui:GetClass("kin_recruit_players")

uiKinPlayersList.LST_MEMBER = "LstMember"
uiKinPlayersList.BTN_CLOSE = "BtnClose"
uiKinPlayersList.BTN_BACK = "BtnBack"

uiKinPlayersList.SEX_NAME = {
  [0] = "男",
  [1] = "女",
}

uiKinPlayersList.FIGURE_NAME = {
  [1] = "族长",
  [2] = "副族长",
  [3] = "正式成员",
  [4] = "记名成员",
  [5] = "荣誉成员",
}

function uiKinPlayersList:OnRecvData(tbDetail)
  if not tbDetail then
    return 0
  end
  Lst_Clear(self.UIGROUP, self.LST_MEMBER)
  for i, tbInfo in ipairs(tbDetail) do
    Lst_SetCell(self.UIGROUP, self.LST_MEMBER, i, 0, i)
    Lst_SetCell(self.UIGROUP, self.LST_MEMBER, i, 1, tbInfo[1])
    Lst_SetCell(self.UIGROUP, self.LST_MEMBER, i, 2, self.SEX_NAME[tbInfo[2]] or "")
    Lst_SetCell(self.UIGROUP, self.LST_MEMBER, i, 3, self.FIGURE_NAME[tbInfo[3]] or "")
    Lst_SetCell(self.UIGROUP, self.LST_MEMBER, i, 4, tbInfo[4])
  end
end

function uiKinPlayersList:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_BACK then
    UiManager:CloseWindow(self.UIGROUP)
    UiManager:OpenWindow(Ui.UI_KINRCM_LIST)
  end
end
