-- 文件名　：levelupgift.lua
-- 创建者　：jiazhenwei
-- 创建时间：2011-10-31 14:53:31
-- 功能    ：

local uiLevelUpGift = Ui:GetClass("levelupgift")
local tbTempData = Ui.tbLogic.tbTempData
uiLevelUpGift.BtnClose = "BtnClose"
uiLevelUpGift.BtnOk = "BtnOk"
uiLevelUpGift.BtnCancel = "BtnCancel"
uiLevelUpGift.ObjItem = "ObjItem"
uiLevelUpGift.ImageItem = "ImageItem"
uiLevelUpGift.ItemCount = "TxtTimes"
uiLevelUpGift.ImageObj = "ImageObj"
uiLevelUpGift.TxtLevelTitle = "TxtLevelTitle"
uiLevelUpGift.BtnLeftPage = "BtnLeftPage"
uiLevelUpGift.BtnRightPage = "BtnRightPage"

uiLevelUpGift.PagePayGift = "PagePayGift"
uiLevelUpGift.ImagePayItem = "ImagePayItem"
uiLevelUpGift.ObjPayItem = "ObjPayItem"
uiLevelUpGift.ImagePayObj = "ImagePayObj"
uiLevelUpGift.PayItemCount = "TxtPayTimes"
uiLevelUpGift.TxtPayTitle = "TxtPayTitle"
uiLevelUpGift.TxtPayDesc = "TxtPayDesc"
uiLevelUpGift.BtnPayOk = "BtnPayOk"
uiLevelUpGift.PayAwardObj = "PayAwardObj"
uiLevelUpGift.TxtBoxRankName = "TxtBoxRankName"
uiLevelUpGift.TxtFreeRankValue = "TxtRankValue"
uiLevelUpGift.ImgNumber = "ImgNumber"
uiLevelUpGift.TxtPayRankValue = "TxtPayRankValue"

uiLevelUpGift.nMaxNumberBit = 5
uiLevelUpGift.nOrgMainWide = 350
uiLevelUpGift.nOrgMainHeight = 400

uiLevelUpGift.nNewMainWide = 350
uiLevelUpGift.nNewMainHeight = 280

uiLevelUpGift.nPayMonthMoneyLimit = 50

uiLevelUpGift.nMaxItem = 8 --最多放12个物品
uiLevelUpGift.nMaxPayItem = 3 --最多放12个物品

uiLevelUpGift.tbPicture = {
  [1] = "\\image\\icon\\task\\prize_money.spr", --绑定银两
  [2] = "\\image\\item\\other\\scriptitem\\jintiao_xiao.spr", --绑金
  [3] = "\\image\\item\\other\\merchant\\techan_023.spr", --称号
}
uiLevelUpGift.tbEffect = {
  [1] = "\\image\\effect\\other\\new_cheng1.spr",
  [2] = "\\image\\effect\\other\\new_cheng1.spr",
  [3] = "\\image\\effect\\other\\new_cheng1.spr",
  [4] = "\\image\\effect\\other\\new_cheng1.spr",
  [5] = "\\image\\effect\\other\\new_cheng1.spr",
  [6] = "\\image\\effect\\other\\new_cheng2.spr",
  [7] = "\\image\\effect\\other\\new_cheng2.spr",
  [8] = "\\image\\effect\\other\\new_jin1.spr",
  [9] = "\\image\\effect\\other\\new_jin2.spr",
  [10] = "\\image\\effect\\other\\new_jin3.spr",
}

function uiLevelUpGift:OnOpen(nMonthPay, dwItemId)
  self.nMonthPay = nMonthPay or 0
  self.dwItemId = dwItemId
  self.nAwardIndex = SpecialEvent.PlayerLevelUpGift:GetCurrFreeAwardIndex(me)
  if not self.nAwardIndex then
    self.nAwardIndex = SpecialEvent.PlayerLevelUpGift:GetCanGetPayAwardIndex(me) or 1
  end
  self:UpdatePanel()
end

function uiLevelUpGift:OnButtonClick(szWnd, nParam)
  if szWnd == self.BtnClose then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BtnLeftPage then
    self.nAwardIndex = self.nAwardIndex - 1
    if self.nAwardIndex < 1 then
      self.nAwardIndex = 1
    end
    self:UpdatePanel()
  elseif szWnd == self.BtnRightPage then
    self.nAwardIndex = self.nAwardIndex + 1
    self.nMaxAwardIndex = SpecialEvent.PlayerLevelUpGift:GetMaxAwardIndex()
    if self.nAwardIndex > self.nMaxAwardIndex then
      self.nAwardIndex = self.nMaxAwardIndex
    end
    self:UpdatePanel()
  elseif szWnd == self.BtnOk then
    self:OnOk()
  elseif szWnd == self.BtnPayOk then
    self:OnPayAwardOk()
  end
end

function uiLevelUpGift:UpdatePanel()
  local nLevel = SpecialEvent.PlayerLevelUpGift:GetAwardInfoPlayerLevel(self.nAwardIndex)
  if not nLevel then
    return
  end
  Txt_SetTxt(self.UIGROUP, self.TxtBoxRankName, string.format("【%s级新手礼包】", nLevel))
  Wnd_SetEnable(self.UIGROUP, self.BtnLeftPage, 1)
  Wnd_SetEnable(self.UIGROUP, self.BtnRightPage, 1)

  self.nMaxAwardIndex = SpecialEvent.PlayerLevelUpGift:GetMaxAwardIndex()
  if self.nAwardIndex <= 1 then
    Wnd_SetEnable(self.UIGROUP, self.BtnLeftPage, 0)
  end

  if self.nAwardIndex >= self.nMaxAwardIndex then
    Wnd_SetEnable(self.UIGROUP, self.BtnRightPage, 0)
  end

  self:UpdateFreeAward()
  self:UpdatePayAward()
end

function uiLevelUpGift:UpdateFreeAward()
  local nLevel, tbAward = SpecialEvent.PlayerLevelUpGift:GetFreeAwardInfo(self.nAwardIndex)
  if not nLevel or not tbAward then
    return 0
  end

  local nCount = 1
  for _, tbItem in pairs(tbAward.tbAwardList) do
    local ObjItem = self.ObjItem .. nCount
    local ImgItem = self.ImageItem .. nCount
    local TxtCount = self.ItemCount .. nCount
    local ImgObj = self.ImageObj .. nCount
    Wnd_SetVisible(self.UIGROUP, ObjItem, 0)
    Wnd_SetVisible(self.UIGROUP, ImgItem, 0)
    if tbItem.szType == "BindCoin" then
      Wnd_SetEnable(self.UIGROUP, ImgItem, 1)
      Wnd_SetVisible(self.UIGROUP, ImgItem, 1)
      Img_SetImage(self.UIGROUP, ImgItem, 1, self.tbPicture[2])
      Wnd_SetTip(self.UIGROUP, ImgItem, " 绑定金币" .. tbItem.nValue)
      Wnd_SetEnable(self.UIGROUP, ObjItem, 0)
      ObjMx_Clear(self.UIGROUP, ObjItem)
    elseif tbItem.szType == "BindMoney" then
      Wnd_SetEnable(self.UIGROUP, ImgItem, 1)
      Wnd_SetVisible(self.UIGROUP, ImgItem, 1)
      Img_SetImage(self.UIGROUP, ImgItem, 1, self.tbPicture[1])
      Wnd_SetTip(self.UIGROUP, ImgItem, " 绑定银两" .. tbItem.nValue)
      Wnd_SetEnable(self.UIGROUP, ObjItem, 0)
      ObjMx_Clear(self.UIGROUP, ObjItem)
    elseif tbItem.szType == "Title" then
      Wnd_SetEnable(self.UIGROUP, ImgItem, 1)
      Wnd_SetVisible(self.UIGROUP, ImgItem, 1)
      Img_SetImage(self.UIGROUP, ImgItem, 1, self.tbPicture[3])
      Wnd_SetTip(self.UIGROUP, ImgItem, " 称号：" .. tbItem.szTitle)
      Wnd_SetEnable(self.UIGROUP, ObjItem, 0)
      ObjMx_Clear(self.UIGROUP, ObjItem)
    elseif tbItem.szType == "CustomEquip" then
      local tbCustomItem = SpecialEvent.ActiveGift:GetCustomItem(me, tbItem.nValue)
      if tbItem then
        local pItem = KItem.CreateTempItem(tbCustomItem[1], tbCustomItem[2], tbCustomItem[3], tbCustomItem[4], 0)
        if pItem then
          Wnd_SetVisible(self.UIGROUP, ImgObj, 1)
          Wnd_SetEnable(self.UIGROUP, ImgObj, 1)
          Wnd_SetVisible(self.UIGROUP, ObjItem, 1)
          Wnd_SetEnable(self.UIGROUP, ObjItem, 1)
          ObjMx_AddObject(self.UIGROUP, ObjItem, Ui.CGOG_ITEM, pItem.nIndex, 0, 0)
          Txt_SetTxt(self.UIGROUP, TxtCount, "×1")
          Img_SetImage(self.UIGROUP, ImgObj, 1, self.tbEffect[tbCustomItem[4]])
          Img_PlayAnimation(self.UIGROUP, ImgObj, 1)
          Wnd_SetVisible(self.UIGROUP, ImgItem, 0)
          Wnd_SetEnable(self.UIGROUP, ImgItem, 0)
        else
          Wnd_SetVisible(self.UIGROUP, ImgItem, 0)
          Wnd_SetEnable(self.UIGROUP, ImgItem, 0)
          Wnd_SetEnable(self.UIGROUP, ObjItem, 0)
          ObjMx_Clear(self.UIGROUP, ObjItem)
        end
      end
    else
      local nSex = me.nSex + 1
      local tbSexItem = tbItem.tbItemList[nSex]
      local pItem = KItem.CreateTempItem(tbSexItem[1], tbSexItem[2], tbSexItem[3], tbSexItem[4], 0)
      if pItem then
        Wnd_SetVisible(self.UIGROUP, ObjItem, 1)
        Wnd_SetEnable(self.UIGROUP, ObjItem, 1)
        ObjMx_AddObject(self.UIGROUP, ObjItem, Ui.CGOG_ITEM, pItem.nIndex, 0, 0)
        Txt_SetTxt(self.UIGROUP, TxtCount, string.format("×%s", tbSexItem[5]))
        if pItem.IsEquip() == 1 then
          Wnd_SetVisible(self.UIGROUP, ImgObj, 1)
          Wnd_SetEnable(self.UIGROUP, ImgObj, 1)
          Img_SetImage(self.UIGROUP, ImgObj, 1, self.tbEffect[tbSexItem[4]])
          Img_PlayAnimation(self.UIGROUP, ImgObj, 1)
        else
          if tbItem.nEffect > 0 then
            Wnd_SetVisible(self.UIGROUP, ImgObj, 1)
            Wnd_SetEnable(self.UIGROUP, ImgObj, 1)
            Img_SetImage(self.UIGROUP, ImgObj, 1, self.tbEffect[tbItem.nEffect])
            Img_PlayAnimation(self.UIGROUP, ImgObj, 1)
          else
            Wnd_SetVisible(self.UIGROUP, ImgObj, 0)
            Wnd_SetEnable(self.UIGROUP, ImgObj, 0)
          end
        end
        Wnd_SetVisible(self.UIGROUP, ImgItem, 0)
        Wnd_SetEnable(self.UIGROUP, ImgItem, 0)
      else
        Wnd_SetVisible(self.UIGROUP, ImgItem, 0)
        Wnd_SetEnable(self.UIGROUP, ImgItem, 0)
        Wnd_SetEnable(self.UIGROUP, ObjItem, 0)
        ObjMx_Clear(self.UIGROUP, ObjItem)
      end
    end
    nCount = nCount + 1
  end

  --其他未用的空间不可见，不可用
  for i = nCount, self.nMaxItem do
    local ObjItem = self.ObjItem .. i
    local ImgItem = self.ImageItem .. i
    Wnd_SetVisible(self.UIGROUP, ImgItem, 0)
    Wnd_SetEnable(self.UIGROUP, ImgItem, 0)
    Wnd_SetEnable(self.UIGROUP, ObjItem, 0)
    Wnd_SetVisible(self.UIGROUP, ObjItem, 0)
    ObjMx_Clear(self.UIGROUP, ObjItem)
  end

  local nCurIndex = SpecialEvent.PlayerLevelUpGift:GetCurrFreeAwardIndex(me)
  local szBtnOk = ""
  local nCanGet = 0
  if not nCurIndex then
    szBtnOk = "已领取"
    nCanGet = 0
  elseif nCurIndex == self.nAwardIndex then
    szBtnOk = "全部领取"
    nCanGet = 1
  elseif nCurIndex > self.nAwardIndex then
    szBtnOk = "已领取"
    nCanGet = 0
  else
    szBtnOk = "全部领取"
    nCanGet = 0
  end

  Txt_SetTxt(self.UIGROUP, self.TxtFreeRankValue, string.format("价值 <color=239,180,52>%s<color> 元", math.ceil(tbAward.nValue / 10)))

  --设置ok按钮
  Wnd_SetEnable(self.UIGROUP, self.BtnOk, 0)
  if nCanGet == 1 and me.nLevel >= nLevel then
    Wnd_SetEnable(self.UIGROUP, self.BtnOk, 1)
  end
  Btn_SetTxt(self.UIGROUP, self.BtnOk, szBtnOk)
  self:UpdateTotalValue()
end

function uiLevelUpGift:UpdateTotalValue()
  local nTotalValue = SpecialEvent.PlayerLevelUpGift:GetAwardTotalValue()
  nTotalValue = math.ceil(nTotalValue / 10)
  for nCurBit = self.nMaxNumberBit, 1, -1 do
    if 0 == nTotalValue then
      Wnd_SetVisible(self.UIGROUP, self.ImgNumber .. nCurBit, 0)
    else
      Wnd_SetVisible(self.UIGROUP, self.ImgNumber .. nCurBit, 1)
      local nCurNumber = math.fmod(nTotalValue, 10)
      local nFrame = nCurNumber
      Img_SetFrame(self.UIGROUP, self.ImgNumber .. nCurBit, nFrame)
    end
    nTotalValue = math.floor(nTotalValue / 10)
  end
end

function uiLevelUpGift:UpdatePayAward()
  local nLevel, tbAward = SpecialEvent.PlayerLevelUpGift:GetPayAwardInfo(self.nAwardIndex)

  if not nLevel or not tbAward then
    Wnd_Hide(self.UIGROUP, self.PagePayGift)
    --		Wnd_SetVisible(self.UIGROUP, self.PagePayGift, 0);
    --		Wnd_SetEnable(self.UIGROUP, self.PagePayGift, 0);
    Wnd_SetSize(self.UIGROUP, "Main", self.nOrgMainWide, self.nOrgMainHeight)
    --Wnd_SetHeight(self.UIGROUP, "Main", self.nOrgMainHeight, self.nNewMainHeight);
    return 0
  end

  Wnd_SetSize(self.UIGROUP, "Main", self.nOrgMainWide, self.nOrgMainHeight)
  --	Wnd_SetVisible(self.UIGROUP, self.PagePayGift, 1);
  --	Wnd_SetEnable(self.UIGROUP, self.PagePayGift, 1);
  Wnd_Show(self.UIGROUP, self.PagePayGift)
  Wnd_Show(self.UIGROUP, self.BtnPayOk)
  Wnd_Show(self.UIGROUP, self.TxtPayDesc)
  Wnd_Show(self.UIGROUP, self.TxtPayTitle)

  for i = 1, self.nMaxPayItem do
    Wnd_Show(self.UIGROUP, self.PayAwardObj .. i)
  end

  local nCount = 1
  for _, tbItem in pairs(tbAward.tbAwardList) do
    local ObjItem = self.ObjPayItem .. nCount
    local ImgItem = self.ImagePayItem .. nCount
    local TxtCount = self.PayItemCount .. nCount
    local ImgObj = self.ImagePayObj .. nCount

    Wnd_SetVisible(self.UIGROUP, ObjItem, 0)
    Wnd_SetVisible(self.UIGROUP, ImgItem, 0)
    if tbItem.szType == "BindCoin" then
      Wnd_SetEnable(self.UIGROUP, ImgItem, 1)
      Wnd_SetVisible(self.UIGROUP, ImgItem, 1)
      Img_SetImage(self.UIGROUP, ImgItem, 1, self.tbPicture[2])
      Wnd_SetTip(self.UIGROUP, ImgItem, " 绑定金币" .. tbItem.nValue)
      Wnd_SetEnable(self.UIGROUP, ObjItem, 0)
      ObjMx_Clear(self.UIGROUP, ObjItem)
    elseif tbItem.szType == "BindMoney" then
      Wnd_SetEnable(self.UIGROUP, ImgItem, 1)
      Wnd_SetVisible(self.UIGROUP, ImgItem, 1)
      Img_SetImage(self.UIGROUP, ImgItem, 1, self.tbPicture[1])
      Wnd_SetTip(self.UIGROUP, ImgItem, " 绑定银两" .. tbItem.nValue)
      Wnd_SetEnable(self.UIGROUP, ObjItem, 0)
      ObjMx_Clear(self.UIGROUP, ObjItem)
    elseif tbItem.szType == "Title" then
      Wnd_SetEnable(self.UIGROUP, ImgItem, 1)
      Wnd_SetVisible(self.UIGROUP, ImgItem, 1)
      Img_SetImage(self.UIGROUP, ImgItem, 1, self.tbPicture[3])
      Wnd_SetTip(self.UIGROUP, ImgItem, " 称号：" .. tbItem.szTitle)
      Wnd_SetEnable(self.UIGROUP, ObjItem, 0)
      ObjMx_Clear(self.UIGROUP, ObjItem)
    elseif tbItem.szType == "CustomEquip" then
      local tbCustomItem = SpecialEvent.ActiveGift:GetCustomItem(me, tbItem.nValue)
      if tbItem then
        local pItem = KItem.CreateTempItem(tbCustomItem[1], tbCustomItem[2], tbCustomItem[3], tbCustomItem[4], 0)
        if pItem then
          Wnd_SetVisible(self.UIGROUP, ImgObj, 1)
          Wnd_SetEnable(self.UIGROUP, ImgObj, 1)
          Wnd_SetVisible(self.UIGROUP, ObjItem, 1)
          Wnd_SetEnable(self.UIGROUP, ObjItem, 1)
          ObjMx_AddObject(self.UIGROUP, ObjItem, Ui.CGOG_ITEM, pItem.nIndex, 0, 0)
          Txt_SetTxt(self.UIGROUP, TxtCount, "×1")
          Img_SetImage(self.UIGROUP, ImgObj, 1, self.tbEffect[tbCustomItem[4]])
          Img_PlayAnimation(self.UIGROUP, ImgObj, 1)
          Wnd_SetVisible(self.UIGROUP, ImgItem, 0)
          Wnd_SetEnable(self.UIGROUP, ImgItem, 0)
        else
          Wnd_SetVisible(self.UIGROUP, ImgItem, 0)
          Wnd_SetEnable(self.UIGROUP, ImgItem, 0)
          Wnd_SetEnable(self.UIGROUP, ObjItem, 0)
          ObjMx_Clear(self.UIGROUP, ObjItem)
        end
      end
    else
      local nSex = me.nSex + 1
      local tbSexItem = tbItem.tbItemList[nSex]
      local pItem = KItem.CreateTempItem(tbSexItem[1], tbSexItem[2], tbSexItem[3], tbSexItem[4], 0)
      if pItem then
        Wnd_SetVisible(self.UIGROUP, ObjItem, 1)
        Wnd_SetEnable(self.UIGROUP, ObjItem, 1)
        ObjMx_AddObject(self.UIGROUP, ObjItem, Ui.CGOG_ITEM, pItem.nIndex, 0, 0)
        Txt_SetTxt(self.UIGROUP, TxtCount, string.format("×%s", tbSexItem[5]))
        if pItem.IsEquip() == 1 then
          Wnd_SetVisible(self.UIGROUP, ImgObj, 1)
          Wnd_SetEnable(self.UIGROUP, ImgObj, 1)
          Img_SetImage(self.UIGROUP, ImgObj, 1, self.tbEffect[tbSexItem[4]])
          Img_PlayAnimation(self.UIGROUP, ImgObj, 1)
        else
          if tbItem.nEffect > 0 then
            Wnd_SetVisible(self.UIGROUP, ImgObj, 1)
            Wnd_SetEnable(self.UIGROUP, ImgObj, 1)
            Img_SetImage(self.UIGROUP, ImgObj, 1, self.tbEffect[tbItem.nEffect])
            Img_PlayAnimation(self.UIGROUP, ImgObj, 1)
          else
            Wnd_SetVisible(self.UIGROUP, ImgObj, 0)
            Wnd_SetEnable(self.UIGROUP, ImgObj, 0)
          end
        end
        Wnd_SetVisible(self.UIGROUP, ImgItem, 0)
        Wnd_SetEnable(self.UIGROUP, ImgItem, 0)
      else
        Wnd_SetVisible(self.UIGROUP, ImgItem, 0)
        Wnd_SetEnable(self.UIGROUP, ImgItem, 0)
        Wnd_SetEnable(self.UIGROUP, ObjItem, 0)
        ObjMx_Clear(self.UIGROUP, ObjItem)
      end
    end
    nCount = nCount + 1
  end

  --其他未用的空间不可见，不可用
  for i = nCount, self.nMaxPayItem do
    local ObjItem = self.ObjPayItem .. i
    local ImgItem = self.ImagePayItem .. i
    Wnd_SetVisible(self.UIGROUP, ImgItem, 0)
    Wnd_SetEnable(self.UIGROUP, ImgItem, 0)
    Wnd_SetEnable(self.UIGROUP, ObjItem, 0)
    Wnd_SetVisible(self.UIGROUP, ObjItem, 0)
    ObjMx_Clear(self.UIGROUP, ObjItem)
  end

  local szBtnOk = ""
  local nCanGet = 1

  local nGetFlag = SpecialEvent.PlayerLevelUpGift:GetPayAwardFlag(me, self.nAwardIndex)
  if nGetFlag == 0 then
    szBtnOk = "全部领取"
  else
    szBtnOk = "已领取"
    nCanGet = 0
  end

  --设置ok按钮
  Wnd_SetEnable(self.UIGROUP, self.BtnPayOk, 0)
  if nCanGet == 1 and me.nLevel >= nLevel then
    Wnd_SetEnable(self.UIGROUP, self.BtnPayOk, 1)
  end
  Txt_SetTxt(self.UIGROUP, self.TxtPayTitle, string.format("【%s级充值礼包】", nLevel))
  Txt_SetTxt(self.UIGROUP, self.TxtPayDesc, string.format("* 充值 <color=239,180,52>%s<color> 元即可领取%s级充值礼包", self.nPayMonthMoneyLimit, nLevel))
  Btn_SetTxt(self.UIGROUP, self.BtnPayOk, szBtnOk)
  Txt_SetTxt(self.UIGROUP, self.TxtPayRankValue, string.format("价值 <color=239,180,52>%s<color> 元", math.ceil(tbAward.nValue / 10)))
end

function uiLevelUpGift:OnOk()
  me.CallServerScript({ "GetLevelUpGiftGift", self.nAwardIndex, SpecialEvent.PlayerLevelUpGift.INDEX_AWARD_CLASS_FREE, self.dwItemId })
  UiManager:CloseWindow(self.UIGROUP)
end

function uiLevelUpGift:OnPayAwardOk()
  me.CallServerScript({ "GetLevelUpGiftGift", self.nAwardIndex, SpecialEvent.PlayerLevelUpGift.INDEX_AWARD_CLASS_PAY, self.dwItemId })
  UiManager:CloseWindow(self.UIGROUP)
end

function uiLevelUpGift:OnObjHover(szWnd, uGenre, uId, nX, nY)
  local pItem = KItem.GetItemObj(uId)
  if pItem then
    Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, pItem.GetCompareTip(Item.TIPS_BINDGOLD_SECTION))
  end
end

function uiLevelUpGift:Link_infor_OnClick(szWnd, szLinkData)
  me.CallServerScript({ "Dialog2TuiGuanyuan" })
end
