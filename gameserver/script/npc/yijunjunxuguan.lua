-------------------------------------------------------------------
--File: 	yijunjunxuguan.lua
--Author: 	sunduoliang
--Date: 	2008-3-14
--Describe:	义军军需官
-------------------------------------------------------------------

local tbjunxuguan = Npc:GetClass("yijunjunxuguan")

function tbjunxuguan:OnDialog()
  TreasureMap.TreasureMapEx:OpenUI()
end

--[[非UI军需官接口
function tbjunxuguan:OnDialog()
	local tbOpt = {};
	if TreasureMap2.IS_OPEN   == 1 and me.nLevel >= 25 then
		table.insert(tbOpt,{"[藏宝图]闯入藏宝图", TreasureMap.TreasureMapEx.OnDialog, TreasureMap.TreasureMapEx});
		table.insert(tbOpt,{"[藏宝图评价]进入得悦舫", FightAfter.EnterRoomForMeReady, FightAfter});
		table.insert(tbOpt,{"UI TEST", TreasureMap.TreasureMapEx.OpenUI, TreasureMap.TreasureMapEx});
	end
	if CrossTimeRoom:GetCrossTimeRoomOpenState() == 1 then
		table.insert(tbOpt,{"领取高级副本令牌",self.OnGetMissionItem,self});
	end
	table.insert(tbOpt, {"[秘境]闯入秘境", Task.FourfoldMap.OnDialog, Task.FourfoldMap});
	if (Task.IVER_nCloseExchangeNoemal == 0) then
		table.insert(tbOpt, {"我要兑换银票", self.ApplyEchangeYinPia, self, me.nId});
	end
	--table.insert(tbOpt,{"<color=red>藏宝图重整测试<color>", TreasureMap.TreasureMapEx.Test, TreasureMap.TreasureMapEx});
	table.insert(tbOpt,{"结束对话"});
	Dialog:Say("当你为义军做了足够的贡献，义军声望达到一定程度时，可以在我这里购买为义军提供的装备。",tbOpt);
end


function tbjunxuguan:OnGetMissionItem()
	local szMsg = "你想领取什么副本的令牌？";
	local tbOpt = {};
	tbOpt[#tbOpt + 1] = {"领取阴阳时光殿令牌",CrossTimeRoom.GiveCrossTimeRoomItem,CrossTimeRoom,me.nId};
	tbOpt[#tbOpt + 1] = {"领取辰虫镇令牌",ChenChongZhen.GiveChenChongZhenItem,ChenChongZhen};
	tbOpt[#tbOpt + 1] = {"我再想想"};
	Dialog:Say(szMsg,tbOpt);
end

function tbjunxuguan:OnTreasureDialog(nType)
	if me.nLevel < 25 then
		return;
	end
	local tbOpt = {};
	if not nType then
		if me.GetTask(TreasureMap2.TASK_GROUP, TreasureMap2.TASK_ID_COUNTWEEK) < Lib:GetLocalWeek() then
			table.insert(tbOpt, {"领取本周通用藏宝图次数", self.OnTreasureDialog, self, 1});
		else
			table.insert(tbOpt, {"<color=gray>领取本周通用藏宝图次数<color>", self.OnTreasureDialog, self, 1});
		end
		if me.GetTask(TreasureMap2.TASK_GROUP, TreasureMap2.TASK_ID_COUNTDAY) < KGblTask.SCGetDbTaskInt(DBTASK_TREASUREMAP_RANDDAY) then
			table.insert(tbOpt, {"领取今日藏宝图次数", self.OnTreasureDialog, self, 2});
		else
			table.insert(tbOpt, {"<color=gray>领取今日藏宝图次数<color>", self.OnTreasureDialog, self, 2});
		end
		table.insert(tbOpt, {"我再考虑一下"});
		Dialog:Say("我每周都会送你2次通用的藏宝图次数，每天都会随机送你1次副本次数。", tbOpt);
		return;
	end
	if nType == 1 then
		local nAddCount, szMsg = TreasureMap2:AddWeekCommonCount(me);
		Dialog:Say(szMsg);
	elseif nType == 2 then
		local nAddCount, szMsg = TreasureMap2:AddDayRandCount(me);
		Dialog:Say(szMsg);
	end
end
--]]
