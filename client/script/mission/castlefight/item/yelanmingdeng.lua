-- yelanmingdeng.lua
-- zhouchenfei
-- 2010-12-27 15:37:43
-- 夜岚明灯脚本

local tbItem = Item:GetClass("yelanmingdeng")
function tbItem:OnUse()
  if it.nLevel < 3 then
    local tbOpt = {
      { "确认", NewEPlatForm.ItemChangeOther, NewEPlatForm, it },
      { "我再想想" },
    }
    Dialog:Say(string.format("道具<color=yellow>%s<color>为家族竞技道具，现在开放新家族趣味竞技，道具可以兑换为新属性道具，您确定兑换吗？", it.szName), tbOpt)
    return
  elseif it.nLevel >= 3 then
    local tbOpt = {
      { "兑换为别的道具", NewEPlatForm.ItemChange, NewEPlatForm, it },
      { "我再想想" },
    }
    local nRet, szString = NewEPlatForm:CheckCanUpdate(it)
    if nRet == 1 then
      table.insert(tbOpt, 2, { "升级道具<item=" .. szString .. ">", NewEPlatForm.ItemUpdate, NewEPlatForm, it })
    end
    Dialog:Say(string.format("道具<color=yellow>%s<color>可进行下列操作，请问您需要什么操作？", it.szName), tbOpt)
    return
  end
end

--function tbItem:OnUse()
--	local tbConsole = CastleFight:GetConsole();
--	if (not tbConsole) then
--		Dialog:Say("目前活动未开放！不能使用道具！");
--		return 0;
--	end
--
--	if (tbConsole:CheckState() ~= 1) then
--		Dialog:Say("目前活动尚未开放！不能使用道具！");
--		return 0;
--	end
--
--
--	local nTotal = me.GetTask(CastleFight.TSK_GROUP, CastleFight.TSK_ATTEND_TOTAL);
--	local nCountSum, nCount, nCountEx = CastleFight:IsSignUpByTask(me);
--	if (nTotal + nCountSum >= CastleFight.DEF_MAX_TOTAL_NUM) then
--		me.Msg(string.format("您已经参加活动的次数和剩余挑战资格已经超过最大参加活动的次数，不能使用！"));
--		return 0;
--	end
--
--	local nTimes		= me.GetTask(CastleFight.TSK_GROUP, CastleFight.TSK_USE_ITEM_TIMES);
--
--	if (nTimes <= 0) then
--		Dialog:Say("您已经用完了今天使用夜岚明灯的次数，不能使用夜岚明灯！");
--		return 0;
--	end
--
--	me.SetTask(CastleFight.TSK_GROUP, CastleFight.TSK_ATTEND_EXCOUNT, me.GetTask(CastleFight.TSK_GROUP, CastleFight.TSK_ATTEND_EXCOUNT) + CastleFight.DEF_CHANGENUME);
--
--	nTimes = nTimes - 1;
--	if (nTimes < 0) then
--		nTimes = 0;
--	end
--
--	me.SetTask(CastleFight.TSK_GROUP, CastleFight.TSK_USE_ITEM_TIMES, nTimes);
--	Dbg:WriteLog("CastleFight", "yelanmingdeng", me.szName.."夜岚明灯换取三次次数");
--	me.Msg(string.format("您获得了决战夜岚关的%s次机会！", CastleFight.DEF_CHANGENUME));
--	return 1;
--end

function tbItem:GetTip(nState)
  local szTip = ""
  local nNowCount = it.GetGenInfo(1, 0)
  nNowCount = 10 - nNowCount
  szTip = string.format("参加活动的次数还剩下<color=red>%d<color>次", nNowCount)
  return szTip
end
