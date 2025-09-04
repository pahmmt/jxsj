------------------------------------------------------
-- 文件名　：zhenyuan_c.lua
-- 创建者　：dengyong
-- 创建时间：2010-07-14 11:05:59
-- 功能    ：真元客户端脚本
------------------------------------------------------

if not MODULE_GAMECLIENT then
  return
end

Item.tbZhenYuan = Item.tbZhenYuan or {}
local tbZhenYuan = Item.tbZhenYuan

-- 申请炼化，客户端点击炼化按钮后，进入到这里
function tbZhenYuan:ApplyRefine(pDestItem, pSrcItem, nAttriId)
  if not pDestItem or not pSrcItem then
    return
  end

  if not nAttriId then
    me.Msg("请选择您需要炼化的属性资质进行炼化！")
    return
  end
  local nRes, varMsg, _, _, _, nBalanceValue = self:CalcRefineInfo(pDestItem, pSrcItem, nAttriId)
  if nRes ~= 1 then
    me.Msg(varMsg)
    if nRes == 2 then
      Ui:ServerCall("UI_TASKTIPS", "Begin", varMsg)
    end
    return
  end
  local nStarLevelAdded = varMsg
  -- 炼化结果超过1.5星的话，给玩家一个确认提示框
  if nStarLevelAdded == self.REFINE_MAXLEVELUP and nBalanceValue > 0 or nStarLevelAdded > self.REFINE_MAXLEVELUP then
    local tbMsg = {}
    local nDestAttribIndex = self:GetAttribIndex(pDestItem, nAttriId)
    tbMsg.szMsg = string.format("您的副真元总价值量较高！但主真元的<color=green>%s资质<color>提升不能超过<color=gold>1.5星<color>！确定炼化吗？", self:GetAttribTipName(pDestItem.GetBaseAttrib()[nDestAttribIndex].szName))
    if pDestItem.IsBind() + pSrcItem.IsBind() == 1 then
      tbMsg.szMsg = tbMsg.szMsg .. "<color=green>您的主真元或副真元是绑定的，炼化后真元将绑定。<color>"
    end
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex, nAttriId)
      if nOptIndex == 2 then
        me.ApplyZhenYuanEnhance(Item.tbZhenYuan.emZHENYUAN_ENHANCE_REFINE, nAttriId)
      end
    end

    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nAttriId)
    return
  end

  if pDestItem.IsBind() + pSrcItem.IsBind() == 1 then
    local tbMsg = {}
    tbMsg.szMsg = "您的主真元或副真元是绑定的，炼化后真元将绑定，确定炼化吗？"
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex, nAttriId)
      if nOptIndex == 2 then
        me.ApplyZhenYuanEnhance(Item.tbZhenYuan.emZHENYUAN_ENHANCE_REFINE, nAttriId)
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nAttriId)
    return
  end
  -- 没有浪费的可能性，直接申请炼化
  me.ApplyZhenYuanEnhance(self.emZHENYUAN_ENHANCE_REFINE, nAttriId)
end

-- 真元炼化结果处理，客户端函数
function tbZhenYuan:RefineResult(tbRefineRoom1, tbRefineRoom2)
  -- 炼化后，主真元里的OBJ要被交换到下面的格子中
  local pItem = me.GetItem(Item.ROOM_ZHENYUAN_REFINE_MAIN, 0, 0)
  local pObj = tbRefineRoom1:GetObj(0, 0)
  me.SetItem(pItem, Item.ROOM_ZHENYUAN_REFINE_RESULT, 0, 0) -- 主位置的真元被挪到了下面位置
  me.SetItem(nil, Item.ROOM_ZHENYUAN_REFINE_MAIN, 0, 0)

  -- 交换OBJ
  tbRefineRoom2:SetObj(pObj, 0, 0)
  tbRefineRoom1:SetObj(nil, 0, 0)
end

-- 计算炼化时，副真元对主真主名属性的强化预览
function tbZhenYuan:GetAttribRefineInfo(pDest, pSrc)
  local tbInfo = {}
  if self:CheckRefineItem(pDest, 1) ~= 1 then
    return
  end
  if self:CheckRefineItem(pSrc, 2, pDest) ~= 1 then
    return
  end

  for i = 1, self.ATTRIB_COUNT do
    local nAttribId = self:GetAttribMagicId(pDest, i)
    local nStrIndex = self:GetAttribIndex(pSrc, nAttribId)
    if nStrIndex >= 1 and nStrIndex <= self.ATTRIB_COUNT then
      -- 计算能提升的资质星级
      local nRes, nLeft, nRight, nLeftRate, nRightRate, nBalanceValue = self:CalcRefineInfo(pDest, pSrc, nAttribId, 1)
      if nRes == 1 then
        table.insert(tbInfo, i, { { nLeft, nLeftRate }, { nRight, nRightRate } })
      end
    end
  end

  return tbInfo
end

function tbZhenYuan:NotifyLiLianResult()
  if UiManager:WindowVisible(Ui.UI_ZHENYUAN) == 1 then
    Ui(Ui.UI_ZHENYUAN):UpdateLiLianInfo()
    local tbExpBook = Ui(Ui.UI_ZHENYUAN):GetExpBookTab()
    Ui(Ui.UI_ZHENYUAN):UpdateXiuLianTip(me.GetItem(Item.ROOM_ZHENYUAN_XIULIAN_ZHENYUAN, 0, 0), tbExpBook)
  end
end

function tbZhenYuan:UpdateHelpPage()
  if UiManager:WindowVisible(Ui.UI_ZHENYUAN) == 1 then
    Ui(Ui.UI_ZHENYUAN):UpdateHelpPage()
  end
end

-- 这里检查要放入的道具是否是装备着的真元，如果是，不能放入
function tbZhenYuan:SwitchBind_Check(pDropItem)
  if pDropItem then
    for i = Item.EQUIPPOS_ZHENYUAN_MAIN, Item.EQUIPPOS_ZHENYUAN_SUB2 do
      local pItem = me.GetItem(Item.ROOM_EQUIP, i, 0)
      if pItem and pItem.dwId == pDropItem.dwId then
        me.Msg("装备着的真元不能解绑！")
        return 0
      end
    end
  end
  return 1
end
