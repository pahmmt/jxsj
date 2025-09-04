-------------------------------------------------------
-- 文件名　：youlongmibao_item.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2009-11-09 14:45:39
-- 文件描述：
-------------------------------------------------------

Require("\\script\\event\\youlongmibao\\youlongmibao_mapmgr.lua")

local tbItem = Item:GetClass("youlongzhanshu")

function tbItem:OnUse()
  -- 城市和新手村
  local szMapClass = GetMapType(me.nMapId) or ""
  if szMapClass ~= "village" and szMapClass ~= "city" then
    me.Msg("游龙战书只能在城市或新手村使用!")
    return 0
  end

  -- 角色50级
  if me.nLevel < 50 then
    me.Msg("你的等级不满50级，不能使用游龙战书!")
    return 0
  end

  -- 加入门派
  if me.nFaction <= 0 then
    me.Msg("你必须加入门派才能使用游龙战书!")
    return 0
  end

  local tbOpt = {
    { "是的", Youlongmibao.Manager.JoinPlayer, Youlongmibao.Manager, me },
    { "我再想想" },
  }

  Dialog:Say("你决心前往游龙密室么？", tbOpt)

  return 0
end
