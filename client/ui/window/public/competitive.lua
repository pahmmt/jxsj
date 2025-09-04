-------------------------------------------------------
-- 文件名　：competitive.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2010-05-04 11:30:01
-- 文件描述：
-------------------------------------------------------

local uiCompetitive = Ui:GetClass("competitive")

-- const
uiCompetitive.TXT_INDEX = "TxtIndex"
uiCompetitive.TXT_NAME = "TxtName"
uiCompetitive.TXT_GATE = "TxtGate"
uiCompetitive.TXT_COIN = "TxtCoin"
uiCompetitive.TXT_ATTENTION = "TxtAttention"

-- variable
uiCompetitive.TXT_MYCOIN = "TxtMyCoin"
uiCompetitive.TXT_MYINDEX = "TxtMyIndex"
uiCompetitive.TXT_MYHOLD = "TxtMyHold"
uiCompetitive.LST_COMPETITIVE = "LstCompetitive"
uiCompetitive.BTN_JOIN = "BtnJoin"
uiCompetitive.EDT_JOIN = "EdtJoin"
uiCompetitive.BTN_CLOSE = "BtnClose"

function uiCompetitive:UpdateUI(nRank)
  local nComp = me.GetTask(2125, 12)
  Txt_SetTxt(self.UIGROUP, self.TXT_MYCOIN, string.format("您当前的竞标额：%s", nComp))
  Txt_SetTxt(self.UIGROUP, self.TXT_MYINDEX, string.format("您当前的排名：%s", nRank))
  Txt_SetTxt(self.UIGROUP, self.TXT_MYHOLD, string.format("您拥有的金币：%s", me.nCoin))
end

function uiCompetitive:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_JOIN then
    self:OnJoinCompetitive()
  end
end

function uiCompetitive:OnJoinCompetitive()
  local nMyJoin = Edt_GetInt(self.UIGROUP, self.EDT_JOIN)
  if not nMyJoin then
    return 0
  end
  local tbMsg = {}
  tbMsg.szMsg = string.format("您确定竞标<color=yellow>%s<color>金币么？", nMyJoin)
  tbMsg.nOptCount = 2
  function tbMsg:Callback(nOptIndex)
    if nOptIndex == 2 then
      me.CallServerScript({ "ApplyCompetitiveJoin", nMyJoin })
    end
  end
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
end

function uiCompetitive:UpdateCompetitve(tbList)
  if not tbList or #tbList == 0 then
    return 0
  end

  self.tbCompetitveList = tbList
  Lst_Clear(self.UIGROUP, self.LST_COMPETITIVE)

  for nIndex, tbInfo in ipairs(self.tbCompetitveList) do
    Lst_SetCell(self.UIGROUP, self.LST_COMPETITIVE, nIndex, 0, Lib:StrFillC(nIndex, 6))
    Lst_SetCell(self.UIGROUP, self.LST_COMPETITIVE, nIndex, 1, Lib:StrFillC(tbInfo.szPlayerName, 20))
    Lst_SetCell(self.UIGROUP, self.LST_COMPETITIVE, nIndex, 2, Lib:StrFillC(ServerEvent:GetServerNameByGateway(tbInfo.szGateway), 10))
    Lst_SetCell(self.UIGROUP, self.LST_COMPETITIVE, nIndex, 3, Lib:StrFillC(tbInfo.nCompetitive, 16))
  end
end

function uiCompetitive:OnRecvData(nRank, tbList)
  self:UpdateUI(nRank)
  self:UpdateCompetitve(tbList)
end

function uiCompetitive:DisableAll()
  Wnd_SetEnable(self.UIGROUP, self.BTN_JOIN, 0)
  Wnd_SetEnable(self.UIGROUP, self.EDT_JOIN, 0)
end
