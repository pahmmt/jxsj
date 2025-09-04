if not MODULE_GAMECLIENT then
  return
end

ClientOptimizeMgr.tbNpcType = { -- 角色类型
  emNPCKIND_CONFIG_ME = 0, -- 玩家自己
  emNPCKIND_CONFIG_PLAYER = 1, -- 其他角色
  emNPCKIND_CONFIG_NPC = 2, -- NPC
}

ClientOptimizeMgr.tbSceneOption = { -- 场景渲染
  emDISPLAY_CONFIG_ME = 0, -- 玩家自己
  emDISPLAY_CONFIG_PLAYER = 1, -- 其他角色
  emDISPLAY_CONFIG_NPC = 2, -- NPC
  emDISPLAY_CONFIG_SHADOW = 3, -- 人物技能阴影残影
  emDISPLAY_CONFIG_SKILLEFFECT = 4, -- 人物技能特效
  emDISPLAY_CONFIG_MISSILE = 5, -- 子弹
  emDISPLAY_CONFIG_SHORTTIMESTATE = 6, -- 短时间状态特效
  emDISPLAY_CONFIG_LONGTIMESTATE = 7, -- 长时间状态特效
}

function ClientOptimizeMgr:Init()
  self.tbOptimizeLevel = {
    -- nUpLevelFps = 上调等级的帧数, nDownLevelFps = 下调帧数, nChangeTime=当前等级持续多久开始变化（秒）
    [1] = {
      nUpLevelFps = 50,
      nDownLevelFps = 30,
      tbOptimize = { -- 显示全部效果，空表
        [1] = {},
        [2] = {},
      },
    }, -- 效果全开
    [2] = {
      nUpLevelFps = 50,
      nDownLevelFps = 30,
      tbOptimize = { -- 1级优化
        [1] = { self.tbNpcType.emNPCKIND_CONFIG_PLAYER },
        [2] = { self.tbSceneOption.emDISPLAY_CONFIG_SHADOW },
      },
    },
    [3] = {
      nUpLevelFps = 50,
      nDownLevelFps = 30,
      tbOptimize = { -- 2级优化
        [1] = { self.tbNpcType.emNPCKIND_CONFIG_PLAYER, self.tbNpcType.emNPCKIND_CONFIG_NPC },
        [2] = {
          self.tbSceneOption.emDISPLAY_CONFIG_SHADOW,
          self.tbSceneOption.emDISPLAY_CONFIG_PLAYER,
          self.tbSceneOption.emDISPLAY_CONFIG_SKILLEFFECT,
          self.tbSceneOption.emDISPLAY_CONFIG_SHORTTIMESTATE,
          self.tbSceneOption.emDISPLAY_CONFIG_LONGTIMESTATE,
        },
      },
    },
    [4] = {
      nUpLevelFps = 50,
      nDownLevelFps = 30,
      tbOptimize = { -- 3级优化
        [1] = { self.tbNpcType.emNPCKIND_CONFIG_PLAYER, self.tbNpcType.emNPCKIND_CONFIG_NPC, self.tbNpcType.emDISPLAY_CONFIG_ME },
        [2] = {
          self.tbSceneOption.emDISPLAY_CONFIG_SHADOW,
          self.tbSceneOption.emDISPLAY_CONFIG_PLAYER,
          self.tbSceneOption.emDISPLAY_CONFIG_NPC,
          --self.tbSceneOption.emDISPLAY_CONFIG_ME,
          self.tbSceneOption.emDISPLAY_CONFIG_SKILLEFFECT,
          self.tbSceneOption.emDISPLAY_CONFIG_MISSILE,
          self.tbSceneOption.emDISPLAY_CONFIG_SHORTTIMESTATE,
          self.tbSceneOption.emDISPLAY_CONFIG_LONGTIMESTATE,
        },
      },
    }, -- 3级优化
  }
  self.nChangeTime = 2 -- 趋势状态持续多久好开始调整等级，NotifyOptimizeInfo的次数
  self.nCurLevel = 1 -- 当前的优化等级
  self.nTobeLevel = 0 -- 要趋向的等级
  self.nTobeLevelTimes = 0 -- 趋势形成的时间（NotifyOptimizeInfo的次数），到达时间后会进行等级调整
  self.nPlayerNum = 0
  SetAutoDispState(1)
end

-- 游戏通知运行状况,每10秒一次
function ClientOptimizeMgr:NotifyOptimizeInfo(nAvgFps, bActiveWnd, nPlayerNum)
  if bActiveWnd == 0 then
    return
  end
  if nPlayerNum - self.nPlayerNum > 10 then -- 人数忽然猛增，降低效果
    self.nPlayerNum = nPlayerNum
    self:ChangOptimizLevel(3)
    return
  else
    self.nPlayerNum = nPlayerNum
  end
  local nUpLevelFps = self.tbOptimizeLevel[self.nCurLevel].nUpLevelFps
  local nDownLevelFps = self.tbOptimizeLevel[self.nCurLevel].nDownLevelFps
  if nAvgFps >= nUpLevelFps and self.nCurLevel > 1 then -- 调高显示效果
    if self.nTobeLevel == self.nCurLevel - 1 then
      self.nTobeLevelTimes = self.nTobeLevelTimes + 1
    else
      self.nTobeLevel = self.nCurLevel - 1
      self.nTobeLevelTimes = 1
    end
    if self.nChangeTime <= self.nTobeLevelTimes then
      -- 调整等级，设置参数
      self:ChangOptimizLevel(self.nTobeLevel)
    end
  elseif nAvgFps <= nDownLevelFps and self.nCurLevel < 4 then -- 调低显示效果
    if self.nTobeLevel == self.nCurLevel + 1 then
      self.nTobeLevelTimes = self.nTobeLevelTimes + 1
    else
      self.nTobeLevel = self.nCurLevel + 1
      self.nTobeLevelTimes = 1
    end
    if self.nChangeTime <= self.nTobeLevelTimes then
      -- 调整等级，设置参数
      self:ChangOptimizLevel(self.nTobeLevel)
    end
  else -- 不高不低，重置统计次数和趋向
    self.nTobeLevel = 0
    self.nTobeLevelTimes = 0
  end
  --print("平均帧数=" .. nAvgFps .. "　窗口状态="..bActiveWnd .. " 玩家数量="..nPlayerNum.." 当前等级="..self.nCurLevel.." 趋向等级="..self.nTobeLevel.." 趋向次数="..self.nTobeLevelTimes);
end

-- 设置优化级别
function ClientOptimizeMgr:ChangOptimizLevel(nOptimizeLevel)
  if nOptimizeLevel < 1 or nOptimizeLevel > 4 then
    return
  end
  --print("*******设置优化等级为*****", nOptimizeLevel);
  SetOptimizeNone()
  local tbOptimize = self.tbOptimizeLevel[nOptimizeLevel].tbOptimize
  if tbOptimize then
    if tbOptimize[1] then
      for _, v in ipairs(tbOptimize[1]) do
        SetNpcDispKindConfig(v, 1) -- 隐藏该选项
      end
    end
    if tbOptimize[2] then
      for _, v in ipairs(tbOptimize[2]) do
        SetSceneDisplayConfig(v, 1) -- 隐藏该选项
      end
    end
  end
  self.nCurLevel = nOptimizeLevel
  self.nTobeLevel = 0
  self.nTobeLevelTimes = 0
end

ClientOptimizeMgr:Init()
