-------------------------------------------------------
-- 文件名　：keyimen_item.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2012-02-22 11:31:58
-- 文件描述：
-------------------------------------------------------

if not MODULE_GAMESERVER then
  return
end

Require("\\script\\boss\\keyimen\\keyimen_def.lua")

local tbPad = Item:GetClass("keyimen_item_pad")

function tbPad:InitGenInfo()
  it.SetTimeOut(0, Lib:GetDate2Time(GetLocalDate("%Y%m%d")) + 3600 * 24)
  return {}
end

function tbPad:OnUse()
  if Keyimen:CheckPeriod() ~= 1 then
    return 0
  end

  local szMapClass = GetMapType(me.nMapId) or ""
  if szMapClass ~= "village" and szMapClass ~= "city" and szMapClass ~= "battle_wild" then
    Keyimen:SendMessage(me, self.MSG_CHANNEL, "令旗只能在城市、新手村、克夷门战场使用。")
    return 0
  end

  local nKinId, nMemberId = me.GetKinMember()
  local pKin = KKin.GetKin(nKinId)
  if not pKin then
    Keyimen:SendMessage(me, self.MSG_CHANNEL, "对不起，你没有家族，无法使用令旗。")
    return 0
  end

  if me.dwTongId <= 0 then
    Keyimen:SendMessage(me, self.MSG_CHANNEL, "对不起，你没有帮会，无法使用令旗。")
    return 0
  end

  local tbOpt = { { "我知道了" } }
  local szMsg = "    <color=yellow>族长和副族长<color>可以使用军令在<color=yellow>敌对阵营<color>放置一面旗子，家族成员可以在一定时间内直接传送到旗子周围。"
  local nTime, tbPos = Keyimen:GetKinFlagPos(nKinId)
  if nTime == 0 then
    table.insert(tbOpt, 1, { "<color=gray>传到旗子<color>" })
  else
    table.insert(tbOpt, 1, { string.format("<color=yellow>传到旗子（%s秒）<color>", nTime), self.FlyFlag, self })
  end

  if Kin:CheckSelfRight(nKinId, nMemberId, 2) == 1 then
    local nRet = Keyimen:CheckKinFlag_GS(me, me.dwTongId, nKinId)
    if nRet == 0 then
      table.insert(tbOpt, 1, { "<color=gray>放置旗子<color>" })
    elseif nRet == 1 then
      table.insert(tbOpt, 1, { "<color=yellow>放置旗子<color>", self.SetFlag, self })
    else
      table.insert(tbOpt, 1, { string.format("<color=gray>插旗间隔（%s秒）<color>", 0 - nRet) })
    end
  end

  Dialog:Say(szMsg, tbOpt)
end

function tbPad:FlyFlag()
  local nKinId, nMemberId = me.GetKinMember()
  local pKin = KKin.GetKin(nKinId)
  if not pKin then
    return 0
  end
  local nTime, tbPos = Keyimen:GetKinFlagPos(nKinId)
  if nTime == 0 then
    return 0
  end
  if me.nFightState > 0 then
    local tbBreakEvent = {
      Player.ProcessBreakEvent.emEVENT_MOVE,
      Player.ProcessBreakEvent.emEVENT_ATTACK,
      Player.ProcessBreakEvent.emEVENT_SIT,
      Player.ProcessBreakEvent.emEVENT_RIDE,
      Player.ProcessBreakEvent.emEVENT_USEITEM,
      Player.ProcessBreakEvent.emEVENT_ARRANGEITEM,
      Player.ProcessBreakEvent.emEVENT_DROPITEM,
      Player.ProcessBreakEvent.emEVENT_CHANGEEQUIP,
      Player.ProcessBreakEvent.emEVENT_SENDMAIL,
      Player.ProcessBreakEvent.emEVENT_TRADE,
      Player.ProcessBreakEvent.emEVENT_CHANGEFIGHTSTATE,
      Player.ProcessBreakEvent.emEVENT_ATTACKED,
      Player.ProcessBreakEvent.emEVENT_DEATH,
      Player.ProcessBreakEvent.emEVENT_LOGOUT,
      Player.ProcessBreakEvent.emEVENT_REVIVE,
      Player.ProcessBreakEvent.emEVENT_CLIENTCOMMAND,
    }
    GeneralProcess:StartProcess("传送中", 5 * Env.GAME_FPS, { self.DoFly, self, tbPos }, nil, tbBreakEvent)
  else
    me.SetFightState(1)
    self:DoFly(tbPos)
  end
end

function tbPad:DoFly(tbPos)
  me.NewWorld(unpack(tbPos))
end

function tbPad:SetFlag(nClose)
  local nKinId, nMemberId = me.GetKinMember()
  local pKin = KKin.GetKin(nKinId)
  if not pKin then
    return 0
  end
  if Kin:CheckSelfRight(nKinId, nMemberId, 2) ~= 1 then
    return 0
  end
  local nTongId = me.dwTongId
  if nTongId <= 0 then
    return 0
  end
  if Keyimen:CheckKinFlag_GS(me, nTongId, nKinId) == 1 then
    Keyimen:KinFlag_GS(me, nTongId, nKinId)
  end
end

-- 工资银锭
local tbSalaryItem = Item:GetClass("keyimen_item_salary")
function tbSalaryItem:OnUse()
  local nAddYinDing = math.floor(Keyimen.BASE_SALARY * Lib:_GetXuanEnlarge(Kinsalary:GetOpenDay()))
  local nCurYinDing = me.GetTask(Kinsalary.TASK_GID, Kinsalary.TASK_YINDING)
  if nCurYinDing + nAddYinDing > Kinsalary.MAX_NUMBER then
    Dialog:Say("您的家族银锭将超出上限，请在银锭商店中消费一些才可继续获得。")
    return 0
  end
  me.SetTask(Kinsalary.TASK_GID, Kinsalary.TASK_YINDING, nCurYinDing + nAddYinDing)
  Kinsalary:SendMessage(me, Kinsalary.MSG_CHANNEL, string.format("你获得了%s家族银锭", nAddYinDing))
  return 1
end

-- 龙锦玉匣
local tbYuxia = Item:GetClass("keyimen_Item_yuxia")
function tbYuxia:OnUse()
  if IpStatistics:CheckStudioRole(me) ~= 1 then
    return Item:GetClass("randomitem"):SureOnUse(357)
  else
    return Item:GetClass("randomitem"):SureOnUse(358)
  end
end

-- 龙魂侠影声望
local tbReputeItem = Item:GetClass("keyimen_Item_repute")
function tbReputeItem:OnUse()
  me.AddRepute(15, 1, 20)
  return 1
end
