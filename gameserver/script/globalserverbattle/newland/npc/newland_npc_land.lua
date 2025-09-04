-------------------------------------------------------
-- 文件名　：newland_npc_land.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2010-09-06 17:04:23
-- 文件描述：
-------------------------------------------------------

if not MODULE_GAMESERVER then
  return
end

Require("\\script\\globalserverbattle\\newland\\newland_def.lua")

local tbNpc = Npc:GetClass("newland_npc_land")

-------------------------------------------------------
-- 1. 进入铁浮城
-- 2. 领取庆祝烟花
-------------------------------------------------------
function tbNpc:OnDialog()
  if Newland:CheckIsOpen() ~= 1 or Newland:CheckIsGlobal() ~= 1 then
    Dialog:Say("当日龙蛇归草莽，此时琴剑付高楼。")
    return 0
  end

  local szMsg = "铁浮城已千疮百孔，急待它真正的主人出现！您就是那位英雄吗？<color=green>（请回到本服铁浮城远征大将处领取奖励）<color>"
  local tbOpt = {
    { "<color=yellow>进入铁浮城<color>", self.JoinWar, self },
    { "领取烟花", self.GetYanhua, self },
    { "我知道了" },
  }

  Dialog:Say(szMsg, tbOpt)
end

-- 进入比赛场
function tbNpc:JoinWar(nSure)
  -- 判断开战与否
  if Newland:GetWarState() == Newland.WAR_END then
    Dialog:Say("铁浮城争夺战尚未开始，请届时再来。<enter><color=gold>详情按F12-详细帮助-跨服城战查询<color>")
    return 0
  end

  -- 等级限制
  if me.nLevel < 100 then
    Dialog:Say(string.format("<color=yellow>对不起，您的等级不足。<color><enter>%s", Newland.CONDITION_JOIN_NEWLAMD))
    return 0
  end

  -- 门派限制
  if me.nFaction <= 0 then
    Dialog:Say(string.format("<color=yellow>对不起，您还未加入门派。<color><enter>%s", Newland.CONDITION_JOIN_NEWLAMD))
    return 0
  end

  -- 判断披风(雏凤)
  local pItem = me.GetItem(Item.ROOM_EQUIP, Item.EQUIPPOS_MANTLE, 0)
  if not pItem or pItem.nLevel < Newland.MANTLE_LEVEL then
    Dialog:Say(string.format("<color=yellow>此去极其凶险，您没有足以保护自己的披风，怎能匆忙应战？<color><enter>%s", Newland.CONDITION_JOIN_NEWLAMD))
    return 0
  end

  -- 帮会名字
  local szTongName = me.GetTaskStr(Newland.TASK_GID, Newland.TASK_TONGNAME)
  if not szTongName then
    Dialog:Say(string.format("<color=yellow>此去极其凶险，您没有加入帮会，怎能匆忙应战？<color><enter>%s", Newland.CONDITION_JOIN_NEWLAMD))
    return 0
  end

  -- 检查帮会是否报名
  local nGroupIndex = Newland:GetGroupIndexByTongName(szTongName)
  if nGroupIndex <= 0 then
    Dialog:Say("对不起，您所在的帮会没有参战资格，无法进入。")
    return 0
  end

  -- 设置军团编号
  if Newland:GetPlayerGroupIndex(me) ~= nGroupIndex then
    me.SetTask(Newland.TASK_GID, Newland.TASK_GROUP_INDEX, nGroupIndex)
  end

  -- 传送进复活点
  local nMapId = Newland:GetLevelMapIdByIndex(nGroupIndex, 1)
  local tbTree = Newland:GetMapTreeByIndex(nGroupIndex)
  if nMapId and tbTree then
    local nOk, szError = Map:CheckTagServerPlayerCount(nMapId)
    if nOk ~= 1 then
      Dialog:Say(szError)
      return 0
    end
    local nMapX, nMapY = unpack(Newland.REVIVAL_LIST[tbTree[0]])
    me.SetTask(Newland.TASK_GID, Newland.TASK_LAND_ENTER, 1)
    -- balance
    if Newland:CheckIsBalance() == 1 then
      Newland:AddBalance(me)
    end
    me.NewWorld(nMapId, nMapX, nMapY)
  end
end

-- 领取烟花
function tbNpc:GetYanhua()
  if Newland:GetDailyPeriod() ~= Newland.PERIOD_WAR_OPEN or Newland:GetPeriod() ~= Newland.PERIOD_WAR_REST then
    Dialog:Say("对不起，只有城战结束的当晚可以领取烟花。")
    return 0
  end

  if me.CountFreeBagCell() < 1 then
    Dialog:Say("请留出至少一格背包空间再来领取")
    return 0
  end

  me.AddItem(unpack(Newland.YANHUA_ID))
end
