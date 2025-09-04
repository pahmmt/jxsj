-------------------------------------------------------------------
--File: jiu.lua
--Author: zongbeilei
--Date: 2007-12-21 21:59
--Describe: 酒脚本
-------------------------------------------------------------------
local tbJiuItem = Item:GetClass("jiu")
local JIU_AVOID_TIME = 1.5 * 3600 -- 酒的有效期限

--普通酒
tbJiuItem.nJiuSkillId = 378
tbJiuItem.nLastTime = 180 -- 各种酒使用后的持续时间
tbJiuItem.nMaxLastStateTime = 1800 -- 叠加酒最多时间
tbJiuItem.tbJiuId = { 48, 49, 50, 51, 52 } -- 各种酒的Id
tbJiuItem.tbJiuName = { "陈年西北望", "陈年稻花香", "陈年女儿红", "陈年杏花村", "陈年烧刀子" } -- 每一种酒的Name
tbJiuItem.tbQuotiety = { -- 同时喝一种酒的数量对应的加经验的倍数(百分比)
  [0] = 100,
  [1] = 110,
  [2] = 120,
  [3] = 130,
  [4] = 140,
  [5] = 150,
  [6] = 160,
}

--任务酒
tbJiuItem.nTaskJiuSkillId = 477 --任务专用酒就能Id
tbJiuItem.ntaskLastTime = 120 --任务专用酒持续时间
tbJiuItem.tbTaskJiuId = 97 -- 任务专用酒
tbJiuItem.tbTaskJiuName = { "战神酒" }
tbJiuItem.tbTaskQuotiety = { -- 同时喝一种酒的数量对应的加经验的倍数(百分比)
  [0] = 100,
  [1] = 100,
  [2] = 110,
  [3] = 120,
  [4] = 130,
  [5] = 140,
  [6] = 150,
}

--活动酒
tbJiuItem.nEventJiuSkillId = 799 --任务专用酒就能Id
tbJiuItem.nEventLastTime = 300 --任务专用酒持续时间
tbJiuItem.tbEventJiuId = 196 -- 活动酒－王老吉
tbJiuItem.tbEventJiuName = { "王老吉凉茶" }
tbJiuItem.tbEventQuotiety = { -- 同时喝一种酒的数量对应的在原有基础上加经验的倍数(百分比)
  [0] = 0,
  [1] = 10,
  [2] = 10,
  [3] = 10,
  [4] = 10,
  [5] = 10,
  [6] = 10,
}

function tbJiuItem:InitGenInfo()
  -- 设定酒的有效期限

  -- modified by dengyong: 战神酒不设定有效期
  if it.nParticular ~= self.tbTaskJiuId then
    it.SetTimeOut(1, JIU_AVOID_TIME)
  end
  return {}
end

-- 右键点击时
function tbJiuItem:OnUse()
  if it.nParticular == self.tbTaskJiuId then
    if GetMapType(me.nMapId) ~= "village" and GetMapType(me.nMapId) ~= "city" then
      Dialog:SendInfoBoardMsg(me, "请回城市和新手村的战神酒火塘附近饮用战神酒。")
      me.Msg("请回城市和新手村的战神酒火塘附近饮用战神酒。")
      return 0
    end
    me.AddSkillState(self.nTaskJiuSkillId, 1, 1, self.ntaskLastTime * Env.GAME_FPS, 0)
    self:HintMsg(self.tbTaskJiuName[1])
    return 1
  end

  if it.nParticular == self.tbEventJiuId then
    me.AddSkillState(self.nEventJiuSkillId, 1, 1, self.nEventLastTime * Env.GAME_FPS, 0, 1)
    self:HintMsg(self.tbEventJiuName[1])
    return 1
  end

  for i = 1, #self.tbJiuId do
    if it.nParticular == self.tbJiuId[i] then
      --  技能Id, 等级, 状态类型(类型为0取的是表中时间,1取的是后面自定义时间), 时间, 死亡后是否消失, 覆盖原技能效果.
      local nSkillLevel, nStateType, nEndTime = me.GetSkillState(self.nJiuSkillId)
      local nLastTime = self.nLastTime * Env.GAME_FPS
      if nSkillLevel > 0 then
        nLastTime = nEndTime + nLastTime
        if nLastTime > self.nMaxLastStateTime * Env.GAME_FPS then
          me.Msg("你快要醉了，不能再喝酒了，等你清醒点再喝吧。")
          return 0
        end
      end
      me.AddSkillState(self.nJiuSkillId, i, 1, nLastTime, 1, 1)
      local nMin = math.floor(nLastTime / (60 * Env.GAME_FPS))
      local nSec = math.mod(nLastTime, 60)
      local szMsg = string.format("您喝了一瓶<color=blue>%s<color>，当前经验加成剩余时间<color=yellow>%s分%s秒<color>", self.tbJiuName[i], nMin, nSec)
      me.Msg(szMsg)
      if me.nFightState == 0 then
        return 1
      end
      self:HintMsg(self.tbJiuName[i])
      break
    end
  end

  return 1 -- OnUse函数中返回0不删除;返回1表示删除
end

-- 显示队友喝酒后的提示信息
function tbJiuItem:HintMsg(szJiuName)
  if me.nTeamId > 0 then
    local tbPlayerIdList = KTeam.GetTeamMemberList(me.nTeamId)
    for _, nPlayerId in pairs(tbPlayerIdList) do
      local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
      if pPlayer then
        pPlayer.Msg(string.format("[%s]喝了一瓶%s,将会获得篝火高额经验。", me.szName, szJiuName))
      end
    end
  else
    me.Msg(string.format("您喝了一瓶%s,将会获得篝火高额经验。", szJiuName))
  end
end

-- 功能:	计算同时喝一种酒的最大玩家的数量
-- 参数:	tbPlayerId	队伍玩家的Id
function tbJiuItem:CalcQuotiety(tbPlayerId)
  local tbDrinkedNum = { 0, 0, 0, 0, 0 }
  if #tbPlayerId == 0 then
    return 0, 100
  end
  local nMaxTimes = 0
  local tbPlayerName = {}
  for i, nPlayerId in pairs(tbPlayerId) do
    local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
    if pPlayer then
      local nSkillLevel = pPlayer.GetSkillState(self.nJiuSkillId)
      if nSkillLevel > 0 then
        nMaxTimes = nMaxTimes + 1
        tbDrinkedNum[nSkillLevel] = tbDrinkedNum[nSkillLevel] + 1
        if tbPlayerName[self.tbJiuName[nSkillLevel]] == nil then
          tbPlayerName[self.tbJiuName[nSkillLevel]] = {}
        end
        table.insert(tbPlayerName[self.tbJiuName[nSkillLevel]], pPlayer.szName)
      end
    end
  end

  if nMaxTimes > 6 then
    nMaxTimes = 6
  end
  return nMaxTimes, self.tbQuotiety[nMaxTimes], "陈年美酒", tbPlayerName
end

function tbJiuItem:CalcTaskQuotiety(tbPlayerId)
  if #tbPlayerId == 0 then
    return 0, 100
  end
  local nDrinkedNum = 0
  for i, nPlayerId in pairs(tbPlayerId) do
    local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
    if pPlayer then
      local nTaskSkillLevel = pPlayer.GetSkillState(self.nTaskJiuSkillId)
      if nTaskSkillLevel > 0 then
        nDrinkedNum = nDrinkedNum + 1
      end
    end
  end
  return nDrinkedNum, self.tbTaskQuotiety[nDrinkedNum], self.tbTaskJiuName[1]
end

function tbJiuItem:CalcEventQuotiety(tbPlayerId)
  if #tbPlayerId == 0 then
    return 0, 100
  end
  local nDrinkedNum = 0
  local szEventJiuName
  for i, nPlayerId in pairs(tbPlayerId) do
    local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
    if pPlayer then
      local nEventSkillLevel = pPlayer.GetSkillState(self.nEventJiuSkillId)
      if nEventSkillLevel > 0 then
        nDrinkedNum = nDrinkedNum + 1
        szEventJiuName = self.tbEventJiuName[1]
      end
    end
  end
  return nDrinkedNum, self.tbEventQuotiety[nDrinkedNum], szEventJiuName
end

--通用
function tbJiuItem:CalcOtherQuotiety(tbPlayerId, nSkillId)
  if #tbPlayerId == 0 then
    return 0
  end
  local nDrinkedNum = 0
  for i, nPlayerId in pairs(tbPlayerId) do
    local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
    if pPlayer then
      local nTaskSkillLevel = pPlayer.GetSkillState(nSkillId)
      if nTaskSkillLevel > 0 then
        nDrinkedNum = nDrinkedNum + 1
      end
    end
  end
  return nDrinkedNum
end
