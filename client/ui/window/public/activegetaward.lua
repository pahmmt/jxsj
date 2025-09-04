-- 文件名　：levelupgift.lua
-- 创建者　：jiazhenwei
-- 创建时间：2011-10-31 14:53:31
-- 功能    ：

local uiActiveGetAward = Ui:GetClass("activegetaward")
uiActiveGetAward.BtnClose = "BtnClose"
uiActiveGetAward.ObjItem = "ObjItem"
uiActiveGetAward.ImageItem = "ImageItem"
uiActiveGetAward.ItemCount = "TxtTimes"
uiActiveGetAward.ImageObj = "ImageObj"

uiActiveGetAward.nMaxItem = 8 --最多放12个物品

uiActiveGetAward.tbPicture = {
  [1] = "\\image\\icon\\task\\prize_money.spr", --绑定银两
  [2] = "\\image\\item\\other\\scriptitem\\jintiao_xiao.spr", --绑金
  [3] = "\\image\\item\\other\\merchant\\techan_023.spr", --称号
  [4] = "\\image\\icon\\task\\prize_expens.spr", --经验
  [5] = "\\image\\icon\\task\\prize_repute.spr", --威望
  [6] = "\\image\\item\\other\\scriptitem\\xiakeling.spr", --侠义值
}
uiActiveGetAward.tbEffect = {
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

function uiActiveGetAward:OnOpen(tbAward)
  self.bEnterFlag = 0
  self.tbAward = tbAward
  self:Update()
end

function uiActiveGetAward:OnButtonClick(szWnd, nParam)
  if szWnd == self.BtnClose then
    UiManager:CloseWindow(self.UIGROUP)
  end
end
function uiActiveGetAward:Update()
  local nCount = 1
  for _, tbItem in pairs(self.tbAward) do
    local ObjItem = self.ObjItem .. nCount
    local ImgItem = self.ImageItem .. nCount
    local TxtCount = self.ItemCount .. nCount
    local ImgObj = self.ImageObj .. nCount

    if tbItem[1] == "bindcoin" then
      Wnd_SetEnable(self.UIGROUP, ImgItem, 1)
      Wnd_SetVisible(self.UIGROUP, ImgItem, 1)
      Img_SetImage(self.UIGROUP, ImgItem, 1, self.tbPicture[2])
      Wnd_SetTip(self.UIGROUP, ImgItem, " 绑定金币：" .. tbItem[2])
      Wnd_SetEnable(self.UIGROUP, ObjItem, 0)
      ObjMx_Clear(self.UIGROUP, ObjItem)
    elseif tbItem[1] == "prestige" then
      Wnd_SetEnable(self.UIGROUP, ImgItem, 1)
      Wnd_SetVisible(self.UIGROUP, ImgItem, 1)
      Img_SetImage(self.UIGROUP, ImgItem, 1, self.tbPicture[5])
      Wnd_SetTip(self.UIGROUP, ImgItem, " 江湖威望：" .. tbItem[2])
      Wnd_SetEnable(self.UIGROUP, ObjItem, 0)
      ObjMx_Clear(self.UIGROUP, ObjItem)
    elseif tbItem[1] == "xiayi" then
      Wnd_SetEnable(self.UIGROUP, ImgItem, 1)
      Wnd_SetVisible(self.UIGROUP, ImgItem, 1)
      Img_SetImage(self.UIGROUP, ImgItem, 1, self.tbPicture[6])
      Wnd_SetTip(self.UIGROUP, ImgItem, " 侠义值：" .. tbItem[2])
      Wnd_SetEnable(self.UIGROUP, ObjItem, 0)
      ObjMx_Clear(self.UIGROUP, ObjItem)
    elseif tbItem[1] == "exp" then
      Wnd_SetEnable(self.UIGROUP, ImgItem, 1)
      Wnd_SetVisible(self.UIGROUP, ImgItem, 1)
      Img_SetImage(self.UIGROUP, ImgItem, 1, self.tbPicture[4])
      Wnd_SetTip(self.UIGROUP, ImgItem, " 经验：" .. tbItem[2])
      Wnd_SetEnable(self.UIGROUP, ObjItem, 0)
      ObjMx_Clear(self.UIGROUP, ObjItem)
    elseif tbItem[1] == "expbase" then
      Wnd_SetEnable(self.UIGROUP, ImgItem, 1)
      Wnd_SetVisible(self.UIGROUP, ImgItem, 1)
      Img_SetImage(self.UIGROUP, ImgItem, 1, self.tbPicture[4])
      Wnd_SetTip(self.UIGROUP, ImgItem, "经验：" .. me.GetBaseAwardExp() * tbItem[2])
      Wnd_SetEnable(self.UIGROUP, ObjItem, 0)
      ObjMx_Clear(self.UIGROUP, ObjItem)
    elseif tbItem[1] == "bindmoney" then
      Wnd_SetEnable(self.UIGROUP, ImgItem, 1)
      Wnd_SetVisible(self.UIGROUP, ImgItem, 1)
      Img_SetImage(self.UIGROUP, ImgItem, 1, self.tbPicture[1])
      Wnd_SetTip(self.UIGROUP, ImgItem, " 绑定银两：" .. tbItem[2])
      Wnd_SetEnable(self.UIGROUP, ObjItem, 0)
      ObjMx_Clear(self.UIGROUP, ObjItem)
    elseif tbItem[1] == "titlename" then
      Wnd_SetEnable(self.UIGROUP, ImgItem, 1)
      Wnd_SetVisible(self.UIGROUP, ImgItem, 1)
      Img_SetImage(self.UIGROUP, ImgItem, 1, self.tbPicture[3])
      Wnd_SetTip(self.UIGROUP, ImgItem, " 称号：" .. tbItem[2])
      Wnd_SetEnable(self.UIGROUP, ObjItem, 0)
      ObjMx_Clear(self.UIGROUP, ObjItem)
    elseif tbItem[1] == "customItem" then
      local tbItem = SpecialEvent.ActiveGift:GetCustomItem(me, tbItem[2])
      if tbItem then
        local pItem = KItem.CreateTempItem(tbItem[1], tbItem[2], tbItem[3], tbItem[4], 0)
        if pItem then
          Wnd_SetEnable(self.UIGROUP, ObjItem, 1)
          ObjMx_AddObject(self.UIGROUP, ObjItem, Ui.CGOG_ITEM, pItem.nIndex, 0, 0)
          Txt_SetTxt(self.UIGROUP, TxtCount, "×1")
          Img_SetImage(self.UIGROUP, ImgObj, 1, self.tbEffect[tbItem[4]])
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
    elseif tbItem[1] == "binditem" then
      local pItem = KItem.CreateTempItem(tbItem[2][1], tbItem[2][2], tbItem[2][3], tbItem[2][4], 0)
      if pItem then
        Wnd_SetEnable(self.UIGROUP, ObjItem, 1)
        ObjMx_AddObject(self.UIGROUP, ObjItem, Ui.CGOG_ITEM, pItem.nIndex, 0, 0)
        Txt_SetTxt(self.UIGROUP, TxtCount, string.format("×%s", tbItem[2][6] or 1))
        if pItem.IsEquip() == 1 then
          Img_SetImage(self.UIGROUP, ImgObj, 1, self.tbEffect[tbItem[2][4]])
          Img_PlayAnimation(self.UIGROUP, ImgObj, 1)
        else
          Wnd_SetVisible(self.UIGROUP, ImgObj, 0)
          Wnd_SetEnable(self.UIGROUP, ImgObj, 0)
        end
        Wnd_SetVisible(self.UIGROUP, ImgItem, 0)
        Wnd_SetEnable(self.UIGROUP, ImgItem, 0)
      else
        Wnd_SetVisible(self.UIGROUP, ImgItem, 0)
        Wnd_SetEnable(self.UIGROUP, ImgItem, 0)
        Wnd_SetEnable(self.UIGROUP, ObjItem, 0)
        ObjMx_Clear(self.UIGROUP, ObjItem)
      end
    elseif tbItem[1] == "title" then
      Wnd_SetVisible(self.UIGROUP, ImgItem, 0)
      Wnd_SetEnable(self.UIGROUP, ImgItem, 0)
      Wnd_SetEnable(self.UIGROUP, ObjItem, 0)
      ObjMx_Clear(self.UIGROUP, ObjItem)
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
    ObjMx_Clear(self.UIGROUP, ObjItem)
  end
end

function uiActiveGetAward:OnObjHover(szWnd, uGenre, uId, nX, nY)
  local pItem = KItem.GetItemObj(uId)
  if pItem then
    Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, pItem.GetCompareTip(Item.TIPS_BINDGOLD_SECTION))
  end
end

function uiActiveGetAward:OnMouseEnter(szWnd)
  if "Main" == szWnd then
    self.bEnterFlag = 1
  end
end

function uiActiveGetAward:OnMouseLeave(szWnd)
  if "Main" == szWnd then
    UiManager:CloseWindow(self.UIGROUP)
  end
end
