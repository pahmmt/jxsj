local uiAutoEquip = Ui:GetClass("autoequip")
local tbTimer = Ui.tbLogic.tbTimer

uiAutoEquip.Obj_Item = "Obj_Item"
uiAutoEquip.Btn_Close = "Btn_Close"
uiAutoEquip.Btn_Equip = "Btn_Equip"
uiAutoEquip.nAction = 1
uiAutoEquip.tbItem = {}

function uiAutoEquip:OnOpen(tbItem)
  if not tbItem or #tbItem < 4 then
    return 0
  end
  self.tbItem = self.tbItem or {}
  table.insert(self.tbItem, tbItem)

  self:UpDate(tbItem)
end

function uiAutoEquip:UpDate(tbItem)
  if self.bUpdate and self.bUpdate == 1 then
    return
  end
  local tbPos = me.FindItemInBags(unpack(tbItem))
  if #tbPos <= 0 then
    UiManager:CloseWindow(self.UIGROUP)
    return
  end
  local pItem = tbPos[1].pItem
  if pItem then
    ObjMx_AddObject(self.UIGROUP, self.Obj_Item, Ui.CGOG_ITEM, pItem.nIndex, 0, 0)
  end
  if me.CanUseItem(pItem) ~= 1 then
    Btn_SetTxt(self.UIGROUP, self.Btn_Equip, "先放背包吧")
    self.nAction = 0
  else
    Btn_SetTxt(self.UIGROUP, self.Btn_Equip, "现在就穿上")
    self.nAction = 1
  end
  self.bUpdate = 1
end

function uiAutoEquip:OnButtonClick(szWnd, nParam)
  if szWnd == self.Btn_Equip then
    self:AutoEquip()
  elseif szWnd == self.Btn_Close then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiAutoEquip:AutoEquip()
  if self.nAction ~= 0 then
    local tbPos = me.FindItemInBags(unpack(self.tbItem[1]))
    if tbPos[1] then
      me.UseItem(tbPos[1].nRoom, tbPos[1].nX, tbPos[1].nY)
      Tutorial:AutoEquip(self.tbItem[1][2])

      if self.tbItem[1][1] == Item.EQUIP_GENERAL and self.tbItem[1][2] == 14 then
        if not self.nTimer_TutorialUseSkill or self.nTimer_TutorialUseSkill <= 0 then
          self.nTimer_TutorialUseSkill = tbTimer:Register(18 * 1, self.TutorialUseSkill, self)
        end
      end
    end
  end
  table.remove(self.tbItem, 1)
  self.bUpdate = 0
  if #self.tbItem <= 0 then
    UiManager:CloseWindow(self.UIGROUP)
  else
    self:UpDate(self.tbItem[1])
  end
end

function uiAutoEquip:TutorialUseSkill()
  if me.IsHaveSkill(10) == 1 then
    me.nRightSkill = 10
    Tutorial:UseSkillTutorial(10000)
  end
  self.nTimer_TutorialUseSkill = 0
  return 0
end

function uiAutoEquip:OnObjHover(szWnd, uGenre, uId, nX, nY)
  local pItem = KItem.GetItemObj(uId)
  if pItem then
    Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, pItem.GetCompareTip(Item.TIPS_BINDGOLD_SECTION))
  end
end
