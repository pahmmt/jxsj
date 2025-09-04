-- 文件名　：roletransfer_item.lua
-- 创建者　：jiazhenwei
-- 创建时间：2011-07-20 09:32:25
-- 功能    ：角色转移资格证

local tbItem = Item:GetClass("roletransfer_item")

function tbItem:GetTip()
  local szMsg = "<color=green>未申请角色转移<color>"
  local nApplyTime = it.GetGenInfo(1)
  if nApplyTime <= 0 then
    return szMsg
  end
  return string.format("<color=red>申请转移角色时间：%s<color>", os.date("%Y年%m月%d日%H时%M分%S秒", it.GetGenInfo(1)))
end

--神仙绳
local tbItemEx = Item:GetClass("roletransfer_item_out")

function tbItemEx:OnUse()
  return 1
end
