-- 文件名  : shangjin.lua
-- 创建者  : jiazhenwei
-- 创建时间: 2010-06-24 14:23:34
-- 描述    : 赏金界面

local uiShangJin = Ui:GetClass("shangjin")

-- 玩家箱子分配比例
uiShangJin.PLAYER_BOX_RADIO = {
  [1] = { 0.05, 10 },
  [2] = { 0.15, 8 },
  [3] = { 0.30, 6 },
  [4] = { 0.45, 4 },
  [5] = { 0.60, 3 },
  [6] = { 0.80, 2 },
  [7] = { 1.00, 1 },
}
uiShangJin.BINGMONEY = 100000

uiShangJin.Btn_OK = "Btn_OK"
uiShangJin.Btn_Close = "Btn_Close"
uiShangJin.Btn_AddTimes = "Btn_AddTimes"
uiShangJin.Btn_DecTimes = "Btn_DecTimes"
uiShangJin.Btn_FaFang = "Btn_Yes"
uiShangJin.Btn_NotFaFang = "Btn_No"
uiShangJin.Edt_MaxPlayer = "Edt_MaxPlayer"
uiShangJin.Txt_MaxPlayerEX = "Txt_MaxPlayerEX"
uiShangJin.Txt_NeedCoinNum = "Txt_NeedCoinNum"
uiShangJin.Txt_Information = "Txt_Information"
uiShangJin.Txt_ShangjinTimes = "Txt_ShangjinTimes"
uiShangJin.LST_COMPETITIVE = "LstCompetitive"
uiShangJin.Txt_ScanBox = "Txt_ScanBox"

--点击事件
function uiShangJin:OnButtonClick(szWnd, nParam)
  if szWnd == self.Btn_Close then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.Btn_OK then
    local tbAward = {}
    tbAward.nAwardCount = self.tbShangjin.nMaxPlayer or 0
    tbAward.nMultiple = self.tbShangjin.nTimes or 0
    tbAward.nForceSend = self.tbShangjin.nFlag or 0
    tbAward.nExtraBox = 0
    if Edt_GetInt(self.UIGROUP, self.Edt_MaxPlayer) < 20 then
      local tbMsg = {}
      tbMsg.szMsg = "赏金人数最少为20人！"
      tbMsg.nOptCount = 1
      UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
      return
    end
    me.CallServerScript({ "ApplySetMemberAward", self.tbShangjin.nGroupId, tbAward })
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.Btn_AddTimes then
    self:AddTimes()
  elseif szWnd == self.Btn_DecTimes then
    self:DecTimes()
  elseif szWnd == self.Btn_FaFang then
    self:SetFaFangShangjin(1)
  elseif szWnd == self.Btn_NotFaFang then
    self:SetFaFangShangjin(0)
  end
end

function uiShangJin:OnEditChange(szWnd, nParam)
  if szWnd == self.Edt_MaxPlayer then
    local nMaxPlayer = Edt_GetInt(self.UIGROUP, self.Edt_MaxPlayer)
    if nMaxPlayer and nMaxPlayer >= 20 then
      self.tbShangjin.nMaxPlayer = nMaxPlayer
      self:UpdateInfo()
    end
  end
end

function uiShangJin:AddTimes()
  if not self.tbShangjin.nTimes then
    self.tbShangjin.nTimes = 0
  end
  if self.tbShangjin.nTimes >= 5 then
    return
  end
  local nTotalMoney = self:CalcMemberAward(self.tbShangjin.nMaxPlayer, self.tbShangjin.nTimes + 1)
  if nTotalMoney >= 2000000000 then
    return
  end
  self.tbShangjin.nTimes = self.tbShangjin.nTimes + 1
  self:UpdateInfo()
end

function uiShangJin:DecTimes()
  if not self.tbShangjin.nTimes then
    self.tbShangjin.nTimes = 0
  end
  if self.tbShangjin.nTimes <= 0 then
    self.tbShangjin.nTimes = 0
    return
  end
  self.tbShangjin.nTimes = self.tbShangjin.nTimes - 1
  self:UpdateInfo()
end

function uiShangJin:SetFaFangShangjin(nFlag)
  self.tbShangjin.nFlag = nFlag
  self:UpdateInfo()
end

function uiShangJin:UpdateInfo()
  if self.tbShangjin.nMaxPlayer and self.tbShangjin.nMaxPlayer >= 0 then
    Txt_SetTxt(self.UIGROUP, self.Txt_ScanBox, string.format("赏金折算成城战宝箱数量（设置发放人数%s人）", self.tbShangjin.nMaxPlayer))
    Txt_SetTxt(self.UIGROUP, self.Txt_MaxPlayerEX, self.tbShangjin.nMaxPlayer)
  end
  if self.tbShangjin.nTimes and self.tbShangjin.nTimes >= 0 then
    Txt_SetTxt(self.UIGROUP, self.Txt_ShangjinTimes, tostring(self.tbShangjin.nTimes))
  end
  if self.tbShangjin.nFlag and self.tbShangjin.nFlag >= 0 and self.tbShangjin.nFlag <= 1 then
    if self.tbShangjin.nFlag == 0 then
      Btn_Check(self.UIGROUP, self.Btn_FaFang, 0)
      Btn_Check(self.UIGROUP, self.Btn_NotFaFang, 1)
    else
      Btn_Check(self.UIGROUP, self.Btn_FaFang, 1)
      Btn_Check(self.UIGROUP, self.Btn_NotFaFang, 0)
    end
  end

  local nTotalCoin, tbNumBoxList = self:CalcMemberAward(self.tbShangjin.nMaxPlayer, self.tbShangjin.nTimes)
  Txt_SetTxt(self.UIGROUP, self.Txt_NeedCoinNum, Item:FormatMoney(nTotalCoin))

  local szAttention = "说明：\n    1、赏金是每届城战开始前由军团首领设置的针对整个军团的酬劳；\n    2、赏金的形式为军团首领投入跨服绑银，并可以设定战败后是否发放；\n    3、城战结束后，根据该军团参加玩家积分排名来将赏金折算成等额的城战宝箱发放；\n    4、赏金发放人数最少为20人，跨服绑银投入上限为20亿。"
  Txt_SetTxt(self.UIGROUP, self.Txt_Information, szAttention)
  self:ReFreshBoxList(tbNumBoxList)
end

function uiShangJin:ReFreshBoxList(tbNumBoxList)
  local szMsg = ""
  if not tbNumBoxList then
    return szMsg
  end
  local nNum = 1
  Lst_Clear(self.UIGROUP, self.LST_COMPETITIVE)

  for nIndex, tbGroup in pairs(tbNumBoxList) do
    Lst_SetCell(self.UIGROUP, self.LST_COMPETITIVE, nIndex, 0, Lib:StrFillC(string.format("%s—%s名", nNum, tbGroup[1]), 24))
    Lst_SetCell(self.UIGROUP, self.LST_COMPETITIVE, nIndex, 1, Lib:StrFillC(string.format("%s个", tbGroup[2]), 24))
    nNum = tbGroup[1] + 1
  end
  return szMsg
end

function uiShangJin:OnRecvData(nGroupId, tbData)
  self.tbShangjin = {}
  self.tbShangjin.nMaxPlayer = tbData.nAwardCount or 0
  self.tbShangjin.nTimes = tbData.nMultiple or 0
  self.tbShangjin.nFlag = tbData.nForceSend or 0
  self.tbShangjin.nGroupId = nGroupId
  self:UpdateInfo()
end

-- 计算投入与产出
function uiShangJin:CalcMemberAward(nAwardCount, nMultiple)
  if nAwardCount <= 0 then
    return 0
  end
  local nCoin = 0
  local nTotal = 0
  local tbRet = {}
  for nLevel, tbInfo in ipairs(self.PLAYER_BOX_RADIO) do
    local nSort = math.floor(nAwardCount * tbInfo[1])
    local nBox = math.floor(nMultiple * tbInfo[2])
    tbRet[nLevel] = { nSort, nBox }
    nCoin = nCoin + (nSort - nTotal) * nBox * self.BINGMONEY
    nTotal = nSort
  end
  return nCoin, tbRet
end

--查看模式
function uiShangJin:DisableAll()
  Wnd_SetEnable(self.UIGROUP, self.Edt_MaxPlayer, 0)
  Wnd_Visible(self.UIGROUP, self.Edt_MaxPlayer, 1)
  Wnd_SetEnable(self.UIGROUP, self.Btn_AddTimes, 0)
  Wnd_SetEnable(self.UIGROUP, self.Btn_DecTimes, 0)
  Wnd_SetEnable(self.UIGROUP, self.Btn_OK, 0)
  if self.tbShangjin and self.tbShangjin.nFlag then
    if self.tbShangjin.nFlag == 0 then
      Wnd_SetEnable(self.UIGROUP, self.Btn_FaFang, 0)
      Btn_Check(self.UIGROUP, self.Btn_NotFaFang, 1)
    else
      Btn_Check(self.UIGROUP, self.Btn_FaFang, 1)
      Wnd_SetEnable(self.UIGROUP, self.Btn_NotFaFang, 0)
    end
  else
    Wnd_SetEnable(self.UIGROUP, self.Btn_FaFang, 0)
    Btn_Check(self.UIGROUP, self.Btn_NotFaFang, 1)
  end
end
