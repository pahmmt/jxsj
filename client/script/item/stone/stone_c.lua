------------------------------------------------------
-- 文件名　：stone_c.lua
-- 创建者　：dengyong
-- 创建时间：2011-05-30 11:48:47
-- 描  述  ：宝石客户端脚本
------------------------------------------------------

Require("\\script\\item\\stone\\define.lua")

Item.tbStone = Item.tbStone or {}
local tbStone = Item.tbStone

function tbStone:UpgradeStone(tbObj)
  if not tbObj then
    return
  end

  local pItem = me.GetItem(tbObj.nRoom, tbObj.nX, tbObj.nY)
  if not pItem then
    return
  end

  if pItem.IsEquip() == 1 then
    local nRet = self:IsFillInStone(pItem)
    if nRet == -1 then
      me.Msg("该装备没有打孔，不能操作！")
    elseif nRet == 0 then
      me.Msg("该装备内没有镶嵌宝石，不能操作！")
    else
      UiManager:OpenWindow(Ui.UI_EQUIPHOLE, Item.HOLE_MODE_STONE_UPGRADE)

      me.SetItem(pItem, Item.ROOM_HOLE_EQUIP, 0, 0)
      Ui(Ui.UI_EQUIPHOLE).tbEquipCont:SetObj(tbObj, 0, 0)
      return
    end
    UiManager:ReleaseUiState(UiManager.UIS_STONE_UPGRADE)
  else
    UiManager:ReleaseUiState(UiManager.UIS_STONE_UPGRADE)

    local nStoneType = pItem.GetStoneType()
    -- 非装备类道具，只能是成品才可操作
    if nStoneType ~= Item.STONE_PRODUCT then
      me.Msg("只能对成品宝石进行升级！")
      return
    end

    me.ApplyStoneOperation(self.emSTONE_OPERATION_UPGRADE, pItem.dwId)
  end
end

function tbStone:ServerUpgradePrepared()
  CoreEventNotify(UiNotify.emCOREEVENT_PREPARE_STONE_UPGRADE)
end

function tbStone:SyncOperationResult(nOperation, nResult)
  CoreEventNotify(UiNotify.emCOREEVENT_STONE_OPERATION_RESULT, nOperation, nResult)
end

-- TODO:宝石升级的结果事件没有UI接收
function tbStone:NotifyOperationResult(nMode, nRes)
  if nMode == self.emSTONE_OPERATION_UPGRADE then
    --CoreEventNotify(UiNotify.emCOREEVENT_STONE_UPGRADE_RESULT, nRes);
    if nRes == 1 then
      me.Msg("宝石升级成功！")
    elseif nRes == 0 then
      me.Msg("宝石升级失败！")
    end
  elseif nMode == self.emSTONE_OPERATION_EXCHANGE then
    CoreEventNotify(UiNotify.emCOREEVENT_STONE_EXCHANGE_REUSTL, nRes)
  elseif nMode == self.emSTONE_OPERATION_BREAKUP then
    CoreEventNotify(UiNotify.emCOREEVENT_ENHANCE_RESULT, Item.ENHANCE_MODE_STONE_BREAKUP, nRes)
  end
end

function tbStone:SwitchBind_Check(pDrop)
  if pDrop then
    if pDrop.GetStoneType() ~= Item.STONE_PRODUCT or pDrop.IsBind() ~= 1 then
      me.Msg("请放入绑定的宝石！")
      return 0
    end
  end

  return 1
end
