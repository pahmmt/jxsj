-- npc_shenmixiake.lua
-- huangxiaoming
-- 报名npc
-- 2011/01/10 09:36:08

Require("\\script\\mission\\castlefight\\castlefight_def.lua")

local tbNpc = Npc:GetClass("shenmixiake")

tbNpc.DEF_EVENT_TYPE = CastleFight.DEF_EVENT_TYPE

function tbNpc:OnDialog()
  if GetMapType(me.nMapId) ~= "castlefight" then
    return 0
  end
  local szMsg = "醉里挑灯看剑，梦回吹角连营，八百里分麾下炙，五十弦翻塞外生，沙场秋点兵。\n<color=yellow>侠客，你在我这里可以清理背包或者补领缺失的道具。<color>"
  local tbOpt = {
    { "补领道具", self.RestoreItem, self },
    { "销毁物品", self.DeleteItem, self },
    { "我知道了" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:RestoreItem()
  if GetMapType(me.nMapId) ~= "castlefight" then
    return 0
  end
  for _, tbInfo in ipairs(CastleFight.ITEM_LIST) do
    local tbFind = me.FindItemInAllPosition(unpack(tbInfo))
    if not tbFind[1] then
      if me.CountFreeBagCell() < 1 then
        Dialog:Say("对不起，您的背包空间不足，请确保你有足够的背包空间再来领取道具")
        return 0
      end
      local pItem = me.AddItem(unpack(tbInfo))
      if pItem then
        pItem.Bind(1)
      end
    end
  end
  Dialog:Say("你身上的道具齐全了。")
end

function tbNpc:DeleteItem()
  if GetMapType(me.nMapId) ~= "castlefight" then
    return 0
  end
  local szContent = "请放入你要销毁的物品，只可以销毁<color=yellow>菜、药和5级以下玄晶<color>"
  Dialog:OpenGift(szContent, nil, { self.OnOpenGiftOk, self })
end

function tbNpc:OnOpenGiftOk(tbItemObj)
  for _, tbItem in pairs(tbItemObj) do -- tbItem[1].nLevel
    if tbItem[1].szClass ~= "medicine" and tbItem[1].szClass ~= "xuanjing" and tbItem[1].szClass ~= "skillitem" then
      Dialog:Say("你放入的物品不符合要求，只能放入<color=yellow>菜、药和5级以下玄晶<color>")
      return 0
    end
    if tbItem[1].szClass == "xuanjing" then
      if tbItem[1].nLevel > CastleFight.DELETE_XUANJING_LEVEL then
        Dialog:Say("你放入的物品不符合要求，只能放入<color=yellow>菜、药和5级以下玄晶<color>")
        return 0
      end
    end
  end
  for _, tbItem in pairs(tbItemObj) do
    tbItem[1].Delete(me)
  end
  me.Msg("成功销毁物品")
end
