-- 文件名　：addexp.lua
-- 创建者　：jiazhenwei
-- 创建时间：2010-04-29
-- 描  述  ：--Vn--玄真丹 紫真丹 血真单

local tbItem = Item:GetClass("addexp")
function tbItem:OnUse()
  if me.nLevel >= 80 then
    me.Msg("您等级已经超过79级了，不能再使用这个物品了！")
    return 0
  end
  return Item:GetClass("addbaseexp_base"):SureOnUse(0, 2000000000)
end

local tbItem1 = Item:GetClass("addexp1")
function tbItem1:OnUse()
  if me.nLevel < 80 then
    me.Msg("您等级不足80级，还不能使用这个物品！")
    return 0
  end
  return Item:GetClass("addbaseexp_base"):SureOnUse(0, 200000000, 2124, 5, 6, 2)
end

local tbItem2 = Item:GetClass("addexp2")
function tbItem2:OnUse()
  if me.nLevel < 80 then
    me.Msg("您等级不足80级，还不能使用这个物品！")
    return 0
  end
  return Item:GetClass("addbaseexp_base"):SureOnUse(0, 500000000, 2124, 7, 8, 1)
end

function tbItem:GetTip()
  return "<color=green>可获得20亿经验<color>"
end

function tbItem1:GetTip()
  local nNowDate = tonumber(GetLocalDate("%Y%m%d"))
  local nDate = me.GetTask(2124, 5)
  local nTimes = me.GetTask(2124, 6)
  if nDate ~= nNowDate then
    nTimes = 0
  end
  local tbColor = { "green", "green", "gray" }
  local szMsg = string.format("<color=%s>今天已经使用%s/2<color>", tbColor[nTimes + 1], nTimes)
  return szMsg .. "\n<color=green>可获得2亿经验，每天限制使用2个<color>"
end

function tbItem1:InitGenInfo()
  it.SetTimeOut(0, GetTime() + 30 * 24 * 3600)
  return {}
end

function tbItem2:GetTip()
  local nNowDate = tonumber(GetLocalDate("%Y%m%d"))
  local nDate = me.GetTask(2124, 7)
  local nTimes = me.GetTask(2124, 8)
  if nDate ~= nNowDate then
    nTimes = 0
  end
  local tbColor = { "green", "gray" }
  local szMsg = string.format("<color=%s>今天已经使用%s/1<color>", tbColor[nTimes + 1], nTimes)
  return szMsg .. "\n<color=green>可获得5亿经验，每天限制使用1个<color>"
end

function tbItem2:InitGenInfo()
  it.SetTimeOut(0, GetTime() + 30 * 24 * 3600)
  return {}
end
