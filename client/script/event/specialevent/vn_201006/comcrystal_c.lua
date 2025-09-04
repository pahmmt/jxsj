-- 文件名　：comcrystal_c.lua
-- 创建者　：jiazhenwei
-- 创建时间：2010-05-14 09:16:32
-- 描  述  ：越南6月合成结晶客户端

--VN--

Require("\\script\\event\\specialevent\\vn_201006\\comcrystal_def.lua")

SpecialEvent.tbComCrystal = SpecialEvent.tbComCrystal or {}
local tbComCrystal = SpecialEvent.tbComCrystal
tbComCrystal.tbFirstItemLevel = nil --放入的第一个物品的nLevel

function tbComCrystal:CheckGiftSwith(tbGiftSelf, pPickItem, pDropItem, nX, nY)
  local szMsg = ""
  local szFollowCryStal = string.format("%s,%s,%s", unpack(self.tbItem))
  if pDropItem then
    local szItem = string.format("%s,%s,%s", pDropItem.nGenre, pDropItem.nDetail, pDropItem.nParticular)
    if szFollowCryStal ~= szItem then
      me.Msg("此物品不能放入!")
      return 0
    end
    if pDropItem.nLevel >= 19 then
      me.Msg("已经到最高级了，不能再合成了!")
      return 0
    end
    if self.tbFirstItemLevel then
      me.Msg("只能放一枚水晶或者水晶裂片！")
      return 0
    end
    self.tbFirstItemLevel = pDropItem.nLevel
    szMsg = self:UpdateGiftSwith()
  end
  if pPickItem then
    local szItemEx = string.format("%s,%s,%s", pPickItem.nGenre, pPickItem.nDetail, pPickItem.nParticular)
    if szItemEx == szFollowCryStal then
      self.tbFirstItemLevel = nil
    end
    szMsg = self:UpdateGiftSwith()
  end
  tbGiftSelf:UpdateContent(szMsg)
  return 1
end

function tbComCrystal:Refresh()
  self.tbFirstItemLevel = nil
end

function tbComCrystal:AddItem(nLevel)
  local tbBagBox = { Ui.UI_EXTBAG1, Ui.UI_EXTBAG2, Ui.UI_EXTBAG3 }
  local tbBoxIndex = { 5, 6, 7 }

  local tbFind = me.FindItem(2, self.tbItem[1], self.tbItem[2], self.tbItem[3], nLevel, -1)
  if tbFind[1] then
    local tbObj = Ui(Ui.UI_ITEMBOX).tbMainBagCont.tbObjs[tbFind[1].nY][tbFind[1].nX]
    Ui(Ui.UI_ITEMBOX).tbMainBagCont:UseObj(tbObj, tbFind[1].nX, tbFind[1].nY)
    return 1
  end

  for i, nRoom in ipairs(tbBagBox) do
    if UiManager:WindowVisible(nRoom) == 1 then
      local tbFind = me.FindItem(tbBoxIndex[i], self.tbItem[1], self.tbItem[2], self.tbItem[3], nLevel, -1)
      if tbFind[1] then
        local tbObj = Ui(nRoom).tbExtBagCont.tbObjs[tbFind[1].nY][tbFind[1].nX]
        Ui(nRoom).tbExtBagCont:UseObj(tbObj, tbFind[1].nX, tbFind[1].nY)
        return 1
      end
    end
  end
end

function tbComCrystal:UpdateGiftSwith()
  local szMsg = "合成规则：\n"
  if not self.tbFirstItemLevel then
    szMsg = szMsg .. string.format("水晶裂片+煤+%s银两= 1级水晶\n", self.nComMoney)
    for i = 1, 9 do
      szMsg = szMsg .. string.format("%s级水晶+煤+%s银两=%s级水晶\n", i, self.nComMoney, i + 1)
    end
  else
    if self.tbFirstItemLevel == 11 then
      szMsg = "该水晶已经是最高级了，不能再合成了！"
    else
      szMsg = string.format("本次合成需要收取普通银两：<color=yellow>%s两<color>\n同时本次合成还需要一块<color=yellow>煤<color>。\n合成预测：\n  合成成功获得<color=yellow>%s级水晶<color>\n  合成失败水晶返回为<color=yellow>水晶裂片<color>\n", self.nComMoney, self.tbFirstItemLevel)
    end
  end
  return szMsg
end
