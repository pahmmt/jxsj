-- 文件名  : treasuremap2_gs.lua
-- 创建者  : huangxiaoming
-- 创建时间: 2012-08-30 11:10:41
-- 描述    :
Require("\\script\\task\\treasuremap2\\treasuremap2_def.lua")

--[[
-- 获取今日藏宝图任务变量
function TreasureMap2:GetTodayTaskID(nPlayerLevel)
	local nLevelIndex = 0;
	for nLevelLimit, _ in pairs(self.LEVEL_TASKIID) do
		if nPlayerLevel >= nLevelLimit and nLevelLimit > nLevelIndex then
			nLevelIndex = nLevelLimit;
		end
	end
	if not #self.LEVEL_TASKIID[nLevelIndex] then
		return nil;
	end
	local nRandSeed = KGblTask.SCGetDbTaskInt(DBTASK_TREASUREMAP_RANDSEED);
	assert(nRandSeed > 0);
	local nRand = math.mod(nRandSeed, #self.LEVEL_TASKIID[nLevelIndex]) + 1;
	local nTaskIndex = self.LEVEL_TASKIID[nLevelIndex][nRand];
	local nTaskGroup = self.TEMPLATE_LIST[nTaskIndex].tbTaskGroupId[1];
	local nTaskId = self.TEMPLATE_LIST[nTaskIndex].tbTaskGroupId[2];
	return nTaskGroup, nTaskId;
end
--]]
