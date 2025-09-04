-- 文件名　：addzhenyuanbaseexp_base.lua
-- 创建者　：jiazhenwei
-- 创建时间：2011-07-12 15:54:29
-- 功能    ：真元历练累计值
local tbBase = Item:GetClass("addzhenyuanbaseexp_base")
tbBase.Task_Group = 2171
tbBase.Task_UseData = 1
tbBase.Task_UseCount = 2
tbBase.nMaxCountDay = 100 --每天限制使用多少

function tbBase:OnUse()
  local nValue = tonumber(it.GetExtParam(1))
  if nValue <= 0 then
    Dialog:Say("道具有问题，请联系GM！")
    return 0
  end
  local nRet = Player:CheckTask(self.Task_Group, self.Task_UseData, "%Y%m%d", self.Task_UseCount, self.nMaxCountDay)
  if nRet == 0 then
    me.Msg(string.format("每天只能使用%s个", self.nMaxCountDay))
    return 0
  end

  local nOrg = me.GetTask(Item.tbZhenYuan.EXPSTORE_TASK_MAIN, Item.tbZhenYuan.EXPSTORE_TASK_SUB)
  local nNew = nOrg + nValue
  if nNew > Item.tbZhenYuan.EXPSTORE_MAX then
    me.Msg("你的累积历练经验已经够多了，不能再使用该道具！")
    return 0
  end
  local nCount = me.GetTask(self.Task_Group, self.Task_UseCount)
  me.SetTask(Item.tbZhenYuan.EXPSTORE_TASK_MAIN, Item.tbZhenYuan.EXPSTORE_TASK_SUB, nNew)
  if nNew == Item.tbZhenYuan.EXPSTORE_MAX then
    me.CallClientScript({ "PopoTip:ShowPopo", 28 })
  end
  me.SetTask(self.Task_Group, self.Task_UseCount, nCount + 1)
  me.Msg(string.format("本次获得历练经验%s分钟。", nValue))
  return 1
end

function tbBase:GetTip()
  local nValue = tonumber(it.GetExtParam(1))
  if nValue <= 0 then
    return ""
  end
  local nNowDate = tonumber(GetLocalDate("%Y%m%d"))
  local nDate = me.GetTask(self.Task_Group, self.Task_UseData)
  local nCount = me.GetTask(self.Task_Group, self.Task_UseCount)
  if nDate ~= nNowDate then
    nCount = 0
  end
  local szMsg = string.format("每天限制使用：%s/%s\n\n<color>", nCount, self.nMaxCountDay)
  if nCount >= self.nMaxCountDay then
    szMsg = "<color=red>" .. szMsg
  else
    szMsg = "<color=green>" .. szMsg
  end
  return szMsg .. string.format("<color=green>可以增加真元累计历练经验<color><color=yellow>%s<color><color=green>分钟<color>", nValue)
end
