-- 文件名　：gold_qiandai.lua
-- 创建者　：zhangjunjie
-- 创建时间：2011-06-15 17:17:39
-- 描述：家族古金币袋

local tbItem = Item:GetClass("kingame_qianxiang")

function tbItem:GetTip()
  local nCount = me.GetTask(KinGame2.TASK_GROUP_ID, KinGame2.TASK_GOLD_COIN)
  local szTip = ""
  szTip = szTip .. string.format("<color=0x8080ff>装古金币的钱袋<color>\n")
  szTip = szTip .. string.format("<color=yellow>古金币装载量: %d/%d<color>", nCount, KinGame2.MAX_GOLD_COIN)
  return szTip
end
