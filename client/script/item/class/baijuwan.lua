-- 文件名　：baijuwan.lua
-- 创建者　：FanZai
-- 创建时间：2007-12-25 09:14:32
-- 文件说明：白驹丸

local tbItem = Item:GetClass("baijuwan")

function tbItem:OnUse()
  local tbOffline = Player.tbOffline
  local tbBaiJu = tbOffline.BAIJU_DEFINE[it.nLevel]
  local nRestTime = me.GetTask(tbOffline.TSKGID, tbBaiJu.nTaskId) + tbOffline.TIME_BAJUWAN_ADD
  local szMsg = string.format("你获得了%s的离线修炼功能。<color=White>%s<color>的离线托管时间增加到%s", tbOffline:GetDTimeDesc(tbOffline.TIME_BAJUWAN_ADD), tbBaiJu.szName, tbOffline:GetDTimeDesc(nRestTime))
  me.Msg(szMsg)
  me.SetTask(tbOffline.TSKGID, tbBaiJu.nTaskId, nRestTime)
  return 1
end
