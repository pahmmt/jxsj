if not Ui.tbLogic then -- UE模拟环境
  Ui.tbLogic = {}
  function UiNotify:RegistNotify() end
  Require("\\script\\item\\class\\chuansongfu.lua")
end

local tbAutoPath = Ui.tbLogic.tbAutoPath or {} -- 支持重载
Ui.tbLogic.tbAutoPath = tbAutoPath

tbAutoPath.DISTANCE_CHANGEMAP_TIME = 30 -- 换地图假定所需时间（按照等效移动距离计算）

tbAutoPath.tbGotoPos = nil
tbAutoPath.tbCurGoPos = nil
tbAutoPath.tbCallBack = nil
tbAutoPath.tbAllMapTrans = {}
tbAutoPath.tbBaseToAllTrans = {}
tbAutoPath.tbMiniMapDesPos = {}
tbAutoPath.nTimerRegisterId = nil
tbAutoPath.nTimerStartTime = nil
tbAutoPath.nWaitingTrans = 0

tbAutoPath.nLastTipTime = 0
tbAutoPath.tbLastTipPos = {}
tbAutoPath.szLastTipMsg = ""

tbAutoPath.nTransferMsg = tbAutoPath.nTransferMsg or 0

local tbChuangsongfu = Item:GetClass("chuansongfu")
tbAutoPath.tbAllBaseMap = tbChuangsongfu.tbBaseMap

-- 【接口】向某坐标寻路
-- 参数：tbPos, 回调函数（寻路终止时被调用）
--		tbPos = {nMapId, nX, nY}
-- 返回：失败返回nil, szMsg；成功返回nDistance, szRoute
function tbAutoPath:GotoPos(tbPos, ...)
  tbPos = { -- 重整一次，去掉小数，避免影响原table
    nMapId = math.floor(tbPos.nMapId),
    nX = tbPos.nX,
    nY = tbPos.nY,
  }
  if tbPos.nX then
    tbPos.nX = math.floor(tbPos.nX)
    tbPos.nY = math.floor(tbPos.nY)
  end
  self:OutF("GotoPos: %s", self:GetPosStr(tbPos))

  -- 停止可能存在的寻路
  self:StopGoto("New")

  -- 停止自动战斗
  if me.nAutoFightState == 1 then -- 当前自动战斗中
    local tbAutoFightData = Ui.tbLogic.tbAutoFightData
    tbAutoFightData:Load()
    tbAutoFightData.LoadData.nAutoFight = 0
    AutoAi:UpdateCfg(tbAutoFightData.LoadData)
  end
  AutoAi.SetTargetIndex(0) -- 清除目标，停止攻击

  -- 变量初始化
  self.tbGotoPos = tbPos
  self.tbCallBack = arg

  -- 尝试走第一步
  self:GoNextStep()
end

-- 【接口】结束自动寻路
function tbAutoPath:StopGoto(szReason)
  me.StopAutoPath(szReason)

  self.tbGotoPos = nil
  self.tbCurGoPos = nil
  self.tbCallBack = nil
  self.nWaitingTrans = 0

  self:CloseTimer()
end

-- 【接口】获取向特定坐标寻路的Tip
-- 参数：tbPos, szDesc
--		tbPos = {nMapId, nX, nY}
-- 返回：nDistance, szTip	（不可达时nDistance为-1）
function tbAutoPath:GetTip(tbPos, szDesc)
  local tbMyPos = self:GetMyPos()
  local tbMapRoute, nDistance, bNeedTrans = self:CalcPosToPos(tbMyPos, tbPos)
  if not tbMapRoute then
    return -1, "需自行前往：" .. GetMapNameFormId(tbPos.nMapId)
  end

  if nDistance <= 0 then
    return 0, "已到达：" .. szDesc
  end

  local szTip = self:GetRouteMapName(tbMapRoute, szDesc)
  szTip = szTip .. string.format(" <color=gray>(%d,%d)<color>\n", tbPos.nX / 8, tbPos.nY / 16)

  if bNeedTrans ~= 1 then -- 可以直接走
    local szPosName
    if tbMapRoute[2] then
      szPosName = GetMapNameFormId(tbMapRoute[2].nMapId)
    else
      szPosName = szDesc
    end
    szTip = szTip .. "点击前往 <color=LightGreen>" .. szPosName
  else
    szTip = szTip .. "点击<bclr=red>飞往<bclr> <color=LightGreen>" .. GetMapNameFormId(tbMapRoute[1].nMapId)
  end

  szTip = szTip .. string.format("<color>  距离：<color=yellow>%d<color> 丈\n", nDistance)

  local bCanUse, szMsg = self:CanUseUnlimitedTrans()
  if bCanUse ~= 1 then
    szTip = szTip .. string.format("\n<color=blue>使用传送符将获得更佳效果（%s）<color>", szMsg)
  end

  return nDistance, szTip
end

-- 处理点信息，对不确定地图、坐标的情况定值
function tbAutoPath:ParseLink(tbLink)
  local tbPos = {
    nMapId = tbLink.nMapId,
    nX = tbLink.nX,
    nY = tbLink.nY,
  }

  -- 不确定地图信息转换
  if not tbPos.nMapId then
    tbPos.nMapId = self:GetMapId(tbLink.varMap)
  end

  -- 不确定坐标计算
  if not tbPos.nX then
    local nMapId = (tbPos.nMapId > 0 and tbPos.nMapId) or me.nTemplateMapId --获取模板id，之前的GetMapTemplateId()是错误的....by Egg
    local nX, nY = KNpc.ClientGetNpcPos(nMapId, tbLink.nNpcId or 0)
    if nX > 0 and nY > 0 then -- 可以找到此Npc
      tbPos.nMapId = nMapId
      tbPos.nX = nX
      tbPos.nY = nY
    end
  end

  if not tbPos.nMapId or tbPos.nMapId <= 0 then
    self:OutF("UnkownMap:%s", tbLink.varMap or "nil")
    return nil, "需自行前往特定地图。"
  end

  return tbPos, tbLink.szDesc
end

-- 配合GoPos使用的Npc处理回调
function tbAutoPath:CBNpc(varNpc, szDesc)
  self:OutF("CBNpc(%s)", varNpc)

  local tbAroundNpc = KNpc.GetAroundNpcList(me, 20)
  for _, pNpc in ipairs(tbAroundNpc) do
    if pNpc.nKind == 3 and (pNpc.nTemplateId == varNpc or pNpc.szName == varNpc or (szDesc and string.find(szDesc, pNpc.szName))) then -- 正是要找的人
      self:OutF("find npc: %s(%d)", pNpc.szName, pNpc.nKind)
      AutoAi.SetTargetIndex(pNpc.nIndex)
      return
    end
  end

  self:OutF("can not find npc: %s", tostring(varNpc))
end

-- 地图内自动寻路开始
function tbAutoPath:OnStart(nDestX, nDestY)
  self:OutF("OnStart(%d,%d)", nDestX, nDestY)
  me.AddSkillEffect(Player.HEAD_STATE_AUTOPATH)
  self.tbDelaynfo = nil
end

-- 地图内自动寻路结束
function tbAutoPath:OnStop(szReason)
  self:OutF("OnStop(%s) goto? %s", szReason, (self.tbGotoPos and "yes") or "no")
  me.RemoveSkillEffect(Player.HEAD_STATE_AUTOPATH)

  -- 不是跨图寻路中
  if not self.tbGotoPos then
    return
  end

  -- 各种情况处理
  if szReason == "Finish" then
    -- 已是最后一步
    if self:IsSamePos(self.tbCurGoPos, self.tbGotoPos) == 1 then
      self:OnFinished() -- 认为完成了
      return
    end

    -- 到达步骤目标，什么都没发生。尝试乱跑
    self:StartTimer("OnTimer_RandRun", 2)
  elseif szReason == "ChangeMap" then
    return -- 此时还没装载完，没有具体坐标，无法处理。稍后OnChangePos再处理
  elseif szReason == "New" then
    return -- 另一个寻路开始，这里不用处理
  elseif szReason == "DelayLoad" then
    self.tbDelaynfo = {}
    self.tbDelaynfo.tbGotoPos = self.tbGotoPos
    self.tbDelaynfo.tbCurGoPos = self.tbCurGoPos
    self.tbDelaynfo.tbCallBack = self.tbCallBac
    self.tbDelaynfo.nWaitingTrans = self.nWaitingTrans
    self:StopGoto(szReason)
  else
    local szStopMsg
    if szReason == "User" then
      szStopMsg = "寻路被打断。"
    else -- Failed
      szStopMsg = "寻路失败。"
    end
    me.Msg(szStopMsg)
    self:StopGoto(szReason)
  end
end

function tbAutoPath:OnChatClick(tbPos)
  self:ProcessClick(tbPos)
end

function tbAutoPath:OnLinkClick(tbLink, ...)
  local tbPos = self:ParseLink(tbLink)
  self:ProcessClick(tbPos, ...)
end

function tbAutoPath:OnLinkRClick(tbLink, ...)
  local tbPos = self:ParseLink(tbLink)
  UiManager:OpenWindow(Ui.UI_WORLDMAP_SUB, tbPos.nMapId, tbPos.nX, tbPos.nY)
end

function tbAutoPath:GetLinkTip(tbLink)
  local tbPos, szDesc = self:ParseLink(tbLink)
  if not tbPos then
    return szDesc
  end

  local nTimeNow = GetTime()
  if nTimeNow == self.nLastTipTime and self:IsSamePos(self.tbLastTipPos, tbPos) == 1 then
    return self.szLastTipMsg -- 短时间内不刷新Tip
  end

  local nDistance, szTip = self:GetTip(tbPos, szDesc)
  self.nLastTipTime = nTimeNow
  self.tbLastTipPos = tbPos
  self.szLastTipMsg = szTip
  return szTip
end

function tbAutoPath:OnMiniMapClick(nX, nY, nMapId)
  local tbPos = {
    nMapId = nMapId,
    nX = nX,
    nY = nY,
  }
  self.tbMiniMapDesPos = tbPos
  self:ProcessClick(tbPos)
end

-- 处理点击事件，支持shift、ctrl组合键
function tbAutoPath:ProcessClick(tbPos, ...)
  --禁止客户端操作时无效
  if me.GetTask(2000, 5) == 1 then
    return
  end

  if not tbPos then -- 不让报错zounan
    print("tbAutoPath:ProcessClick tbPos is nil")
    return
  end
  local nShift = KLib.GetBit(GetKeyState(UiManager.VK_SHIFT), 16)
  local nCtrl = KLib.GetBit(GetKeyState(UiManager.VK_CONTROL), 16)
  self:OutF("ProcessClick(%s) %d %d", self:GetPosStr(tbPos), nShift, nCtrl)
  if nShift == 1 then -- GM指令
    if not tbPos.nX then
      tbPos = Map.tbAllBaseMap[tbPos.nMapId]
      if not tbPos then
        me.Msg("此地图无传送点信息。")
        return
      end
    end
    local szMsg
    if tbPos.nMapId and tbPos.nMapId ~= me.nTemplateMapId then
      szMsg = string.format("?pl local nMapId	= %d;" .. "local nRet, szMsg	= Map:CheckTagServerPlayerCount(nMapId);" .. "if (nRet ~= 1) then me.Msg(szMsg); return; end;" .. "me.NewWorld2(nMapId, %d, %d);", tbPos.nMapId, tbPos.nX, tbPos.nY)
    else
      szMsg = string.format("?pl me.NewWorld2(me.nMapId, %d, %d)", tbPos.nX, tbPos.nY)
    end
    SendChannelMsg("GM", szMsg)
  elseif nCtrl == 1 then -- 坐标链接
    local szMsg
    if tbPos.nX then
      szMsg = string.format("<pos=%d,%d,%d>", tbPos.nMapId or me.nTemplateMapId, tbPos.nX, tbPos.nY)
    else
      szMsg = string.format("<pos=%d>", tbPos.nMapId)
    end
    --SendChatMsg(szMsg);
    InsertChatMsg(szMsg)
  elseif not tbPos.nMapId then -- 本地图寻路
    me.StartAutoPath(tbPos.nX, tbPos.nY)
  else -- 跨地图寻路
    me.StopAutoPath("User")
    self:GotoPos(tbPos, ...)
  end
end

-- 尝试走下一步
function tbAutoPath:GoNextStep()
  local tbMyPos = self:GetMyPos()
  local tbMapRoute, nDistance, bNeedTrans = tbAutoPath:CalcPosToPos(tbMyPos, self.tbGotoPos)
  local tbGoPos = (tbMapRoute or {})[1]
  if bNeedTrans == 1 and tbGoPos then
    tbGoPos = self.tbAllBaseMap[tbGoPos.nMapId]
  end
  self:OutF("GoNextStep: %s rest:%d trans:%s", self:GetPosStr(tbGoPos), nDistance, bNeedTrans)

  if not tbGoPos then
    me.Msg("此地无法自动到达。")
    self:StopGoto("Failed")
    return
  end

  -- 清掉Timer
  self.nWaitingTrans = 0
  self:CloseTimer()

  self.tbCurGoPos = tbGoPos

  if bNeedTrans == 1 then -- 需要传送
    self:UseTrans(tbGoPos.nMapId)
  elseif nDistance <= 0 then -- 已到达
    self:StartTimer("OnFinished", 1) -- 下一帧处理
  elseif me.StartAutoPath(tbGoPos.nX, tbGoPos.nY) ~= 1 then -- 尝试开走
    self:OutF("StartAutoPath failed! %s => %s", self:GetPosStr(tbMyPos), self:GetPosStr(tbGoPos))
    me.Msg("寻路失败。")
    self:StopGoto("Failed")
  end
end

-- 定时随机跑动
function tbAutoPath:OnTimer_RandRun()
  -- 较久仍未传送
  if GetTime() > self.nTimerStartTime + 3 then
    me.Msg("寻路无法进入下一步骤。")
    self:StopGoto("Failed")
    return 0
  end

  -- 找一个附近的随机点跑
  local tbMyPos = self:GetMyPos()
  local tbGoPos = self.tbCurGoPos
  local nDx = tbGoPos.nX - tbMyPos.nX + MathRandom(-5, 5)
  local nDy = tbGoPos.nY - tbMyPos.nY + MathRandom(-5, 5)
  local nDir = math.fmod(64 - math.atan2(nDx, nDy) * 32 / math.pi, 64)
  MoveTo(nDir, 0)
end

-- 传送符超时无响应
function tbAutoPath:OnTimer_TransTimeOut()
  me.Msg("传送符无法使用。")
  self:StopGoto("Failed")
end

-- 当发生瞬移时（包括地图切换和非地图切换）
function tbAutoPath:OnChangePos(nOldMapId, nOldX, nOldY)
  local tbOldPos = {}
  tbOldPos.nMapId, tbOldPos.nX, tbOldPos.nY = nOldMapId, nOldX, nOldY

  -- 不是跨图寻路中
  if not self.tbGotoPos then
    if self.tbDelaynfo then
      self.tbDelaynfo.tbOldPos = tbOldPos
    end
    return
  end

  -- 计算传送前距离最终目标点的距离
  local nDistance = math.huge
  if nOldMapId == self.tbGotoPos.nMapId then
    nDistance = self:GetDistance(self.tbGotoPos, tbOldPos)
  end

  self:OutF("OnChangePos: %s -- %d", self:GetPosStr(self:GetMyPos()), nDistance)

  -- 是否是最终目标附近发生传送
  if nDistance < 5 then
    self:OnFinished() -- 认为是完成了
  else
    self:GoNextStep() -- 走下一步
  end
end

-- mini延迟加载成功
function tbAutoPath:OnDelayLoadSucc()
  if not self.tbDelaynfo then
    return
  end

  self.tbGotoPos = self.tbDelaynfo.tbGotoPos
  self.tbCurGoPos = self.tbDelaynfo.tbCurGoPos
  self.tbCallBack = self.tbDelaynfo.tbCallBack
  self.nWaitingTrans = self.tbDelaynfo.nWaitingTrans

  local tbOldPos = self.tbDelaynfo.tbOldPos
  self.tbDelaynfo = nil

  if tbOldPos then
    self:OnChangePos(tbOldPos.nMapId, tbOldPos.nX, tbOldPos.nY)
  else
    self:GoNextStep()
  end
end

-- 当抵达目的地时
function tbAutoPath:OnFinished()
  me.Msg("安全抵达目的地。")

  local tbCallBack = self.tbCallBack

  self:StopGoto("Finish")

  if tbCallBack and tbCallBack[1] then
    Lib:CallBack(tbCallBack)
  end
  local bIsOpenAutoF = 0
  local bIsInDialogNpc = 0
  local nNpcId = tbCallBack[3]

  --针对npc寻路
  if type(nNpcId) == "number" then
    local tbNpcList = KNpc.GetAroundNpcList(me, 5, 16)
    for _, ptmp in pairs(tbNpcList) do
      if ptmp.nKind == 3 then
        bIsInDialogNpc = 1
        break
      end
    end
  end

  --不是对话npc或其他寻路情况
  if bIsInDialogNpc == 0 then
    local tbNpcList = KNpc.GetAroundNpcList(me, 20)
    for _, ptmp in pairs(tbNpcList) do
      if ptmp.nKind == 0 then
        bIsOpenAutoF = 1
        break
      end
    end
  end

  if bIsOpenAutoF == 1 then
    local tbDate = Ui.tbLogic.tbAutoFightData:ShortKey()
    tbDate.nAutoFight = 1
    tbDate.nPvpMode = 0
    AutoAi:UpdateCfg(tbDate)
  end
end

-- 当开启进度条时
function tbAutoPath:OnStartProgress()
  -- 不是跨图寻路中
  if not self.tbGotoPos then
    return
  end

  self:OutF("OnStartProgress")

  -- 正在等传送
  if self.nWaitingTrans == 1 then
    self.nWaitingTrans = 2
    self:CloseTimer()
  end
end

-- 当中断进度条时
function tbAutoPath:OnStopProgress()
  -- 不是跨图寻路中
  if not self.tbGotoPos then
    return
  end

  self:OutF("OnStopProgress")

  -- 正在等进度条
  if self.nWaitingTrans == 2 then
    me.Msg("传送被打断。")
    self:StopGoto("User")
  end
end

-- 载入时初始化
function tbAutoPath:Init()
  self:LoadTransmitData()
  self:LoadBaseMapData()
end

-- 载入地图间连接信息
function tbAutoPath:LoadTransmitData()
  -- 读取“Form”或“To”地图信息
  local function fnReadPosData(tbRow, szFromOrTo)
    if not tonumber(tbRow[szFromOrTo .. "MapId"]) then -- 空行？
      return nil
    end
    local tbPos = {
      nMapId = tonumber(tbRow[szFromOrTo .. "MapId"]),
      nX = tonumber(tbRow[szFromOrTo .. "PosX"]) / 32,
      nY = tonumber(tbRow[szFromOrTo .. "PosY"]) / 32,
    }
    return tbPos
  end

  local tbFileData = Lib:LoadTabFile("\\setting\\map\\transmit.txt")
  local tbAllMapTrans = self.tbAllMapTrans -- 全部地图连接
  local nAllCount = 0
  for _, tbRow in ipairs(tbFileData) do
    local tbFromPos = fnReadPosData(tbRow, "From")
    local tbToPos = fnReadPosData(tbRow, "To")
    if tbFromPos and tbToPos then
      local tbMapTrans = tbAllMapTrans[tbFromPos.nMapId] or {}
      tbAllMapTrans[tbFromPos.nMapId] = tbMapTrans
      local nTransIdx = nAllCount + 1
      tbMapTrans[nTransIdx] = {
        tbFromPos = tbFromPos,
        tbToPos = tbToPos,
        nTransIdx = nTransIdx,
      }
      nAllCount = nAllCount + 1
    end
  end

  self:OutF("%d transmit loaded!", nAllCount)
end

-- 从传送符数据载入基础地图（可直接传送到的地图）信息
function tbAutoPath:LoadBaseMapData()
  -- 初始计算各个基础地图向外延伸的情况
  local nAllCount = 0
  for _, tbPos in pairs(self.tbAllBaseMap) do
    nAllCount = nAllCount + 1
    self:CalcPosToAllTrans(tbPos, self.tbBaseToAllTrans)
  end

  self:OutF("%d basemap loaded!", nAllCount)
end

-- 计算两点间最优路线
-- 返回值：路线表，距离，是否需要飞
function tbAutoPath:CalcPosToPos(tbFromPos, tbToPos)
  local tbAllTransInfo = self:CalcPosToAllTrans(tbFromPos)
  local tbMapRoute1, nDistance1 = self:CalcMapPath(tbAllTransInfo, tbToPos) -- 走路路径
  local tbMapRoute2, nDistance2 = nil, math.huge
  if self:CanUseUnlimitedTrans() == 1 then -- 有传送符
    tbMapRoute2, nDistance2 = self:CalcMapPath(self.tbBaseToAllTrans, tbToPos) -- 飞行路径
  end
  if tbMapRoute2 then
    if me.nFightState == 1 then -- 战斗状态
      nDistance2 = nDistance2 + 100 -- 传送需要等待进度条，还要冒着被打断的危险。。。
    end
    nDistance2 = nDistance2 + self:GetTransTime(tbFromPos, tbMapRoute2[1])
  end
  if nDistance2 <= nDistance1 then -- 找短的（同为不可达时，返回飞行、距离无限）
    return tbMapRoute2, nDistance2, 1
  else
    return tbMapRoute1, nDistance1, 0
  end
end

-- 通过可达传送点情况计算到达一点的实际路径
--	返回：路由，距离
function tbAutoPath:CalcMapPath(tbAllTransInfo, tbToPos)
  if not tbAllTransInfo[tbToPos.nMapId] then -- 不可到达
    return nil, math.huge
  end

  local tbCurTransInfo
  local nMinDistance = math.huge

  for nTransIdx, tbTransInfo in pairs(tbAllTransInfo[tbToPos.nMapId]) do
    local nTotalDistance = tbTransInfo.nDistance
    if tbToPos.nX then
      nTotalDistance = nTotalDistance + self:GetDistance(tbTransInfo.tbToPos, tbToPos)
    end
    if nTotalDistance < nMinDistance then
      tbCurTransInfo = tbTransInfo
      nMinDistance = nTotalDistance
    end
  end

  local tbMapRoute = { tbToPos }

  while true do
    local tbFromPos = tbCurTransInfo.tbFromPos
    if not tbFromPos then -- 这个是起点
      break
    end
    table.insert(tbMapRoute, 1, tbFromPos)
    tbCurTransInfo = tbCurTransInfo.tbLastTransInfo
  end

  return tbMapRoute, nMinDistance
end

-- 计算一个点所有可到达传送点的情况
function tbAutoPath:CalcPosToAllTrans(tbPos, tbAllTransInfo)
  tbAllTransInfo = tbAllTransInfo or {} -- 到所有点情况

  local tbProcessTrans = {} -- 待处理传送点

  -- 加入一个可到达传送点
  local function fnAddTrans(tbTransInfo, nDistance, tbLastTransInfo)
    local nToMapId = tbTransInfo.tbToPos.nMapId
    local nTransIdx = tbTransInfo.nTransIdx
    local tbTransInfo = {
      tbFromPos = tbTransInfo.tbFromPos,
      tbToPos = tbTransInfo.tbToPos,
      nTransIdx = nTransIdx,
      nDistance = nDistance,
      tbLastTransInfo = tbLastTransInfo,
    }
    if not tbAllTransInfo[nToMapId] then
      tbAllTransInfo[nToMapId] = {}
    end
    tbAllTransInfo[nToMapId][nTransIdx] = tbTransInfo
    tbProcessTrans[nTransIdx] = tbTransInfo
  end

  fnAddTrans({ tbToPos = tbPos, nTransIdx = 0 }, 0) -- 可到达起点位置

  local tbAllMapTrans = self.tbAllMapTrans

  while true do
    local nCurTransIdx, tbCurTransInfo = next(tbProcessTrans)
    if not nCurTransIdx then -- 待处理传送点已空
      break
    end
    tbProcessTrans[nCurTransIdx] = nil
    for nTransIdx, tbTransInfo in pairs(tbAllMapTrans[tbCurTransInfo.tbToPos.nMapId] or {}) do
      local nTotalDistance = self:GetDistance(tbCurTransInfo.tbToPos, tbTransInfo.tbFromPos)
      nTotalDistance = nTotalDistance + tbCurTransInfo.nDistance + self:GetTransTime(tbTransInfo.tbFromPos, tbTransInfo.tbToPos)
      local tbExistTransInfo = (tbAllTransInfo[tbTransInfo.tbToPos.nMapId] or {})[nTransIdx]
      if not tbExistTransInfo or nTotalDistance < tbExistTransInfo.nDistance then -- 找到更优方案
        fnAddTrans(tbTransInfo, nTotalDistance, tbCurTransInfo)
      end
    end
  end

  return tbAllTransInfo
end

-- 判断是同否一个坐标
function tbAutoPath:IsSamePos(tbPos1, tbPos2)
  if tbPos1.nMapId == tbPos2.nMapId and tbPos1.nX == tbPos2.nX and tbPos1.nY == tbPos2.nY then
    return 1
  end
  return 0
end

-- 计算两坐标距离（同地图）
function tbAutoPath:GetDistance(tbPos1, tbPos2)
  assert(tbPos1.nMapId == tbPos2.nMapId)
  if not tbPos1.nX or not tbPos2.nX then
    return math.huge
  end
  return math.sqrt((tbPos1.nX - tbPos2.nX) ^ 2 + (tbPos1.nY - tbPos2.nY) ^ 2)
end

-- 计算传送所需时间（按照等效长度计算）
function tbAutoPath:GetTransTime(tbFromPos, tbToPos)
  if tbFromPos.nMapId == tbToPos.nMapId then
    return 10 -- 同地图
  else
    return self.DISTANCE_CHANGEMAP_TIME -- 不同地图
  end
end

-- 给出指定路程的地图名信息
function tbAutoPath:GetRouteMapName(tbMapRoute, szTargetName)
  local szRoute = ""
  for _, tbPos in ipairs(tbMapRoute) do
    szRoute = szRoute .. GetMapNameFormId(tbPos.nMapId) .. " => "
  end
  szRoute = szRoute .. szTargetName

  return szRoute
end

-- 根据地图标识（可能是字符串）得到地图ID
function tbAutoPath:GetMapId(varMap)
  local tbMapId = Map.tbTypeMap[varMap]
  if not tbMapId then -- 不是特定的类型
    return tonumber(varMap) or 0
  end

  -- 算距离，找最近的一或多张地图
  local tbAllTransInfo = self:CalcPosToAllTrans(self:GetMyPos())
  local tbMinMapId = {}
  local nMinDistance = math.huge
  for _, nMapId in ipairs(tbMapId) do
    local _, nDistance = self:CalcMapPath(tbAllTransInfo, { nMapId = nMapId })
    if nDistance < nMinDistance then
      tbMinMapId = { nMapId }
      nMinDistance = nDistance
    elseif nDistance == nMinDistance then
      table.insert(tbMinMapId, nMapId)
    end
  end

  -- 没找到可达地图？
  if #tbMinMapId < 1 then
    return 0
  end

  -- 以当前地图来随机选地图（如果只有一个地图，下面算法不随机）
  return tbMinMapId[math.mod(me.nTemplateMapId, #tbMinMapId) + 1]
end

-- 检查是否有无限传送符
function tbAutoPath:CanUseUnlimitedTrans()
  if me.IsInCarrier() == 1 then
    return 0, "在载具之上时不能使用传送"
  end
  local nCanUse = KItem.CheckLimitUse(me.nTemplateMapId, "chuansong", 0)
  if nCanUse == 0 then
    return 0, "当前地图禁止使用传送符"
  end
  if not tbChuangsongfu:GetUnlimitedTrans() then
    return 0, "当前尚未装备无限传送符"
  end
  return 1
end

-- 使用无限传送符
function tbAutoPath:UseTrans(nMapId, bSure)
  if bSure ~= 1 and self.nTransferMsg == 1 then
    local tbMsg = {}
    tbMsg.szMsg = "　　　自动寻路功能将使用传送符。\n　　<color=blue>（可在系统设置中禁用此提示）"
    tbMsg.nOptCount = 2
    tbMsg.tbOptTitle = { "取消", "确定" }
    function tbMsg:Callback(nOptIndex)
      if nOptIndex == 1 then
        tbAutoPath:StopGoto("User")
      elseif nOptIndex == 2 then
        tbAutoPath:UseTrans(nMapId, 1)
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
    return
  end
  me.CallServerScript({ "UseUnlimitedTrans", nMapId })
  self.nWaitingTrans = 1
  self:StartTimer("OnTimer_TransTimeOut", Env.GAME_FPS * 3)
end

-- 开启计时器
function tbAutoPath:StartTimer(szFunName, nInterval)
  self.nTimerStartTime = GetTime()
  self.nTimerRegisterId = Ui.tbLogic.tbTimer:Register(nInterval, 1, self[szFunName], self)
end

-- 关闭计时器
function tbAutoPath:CloseTimer()
  if self.nTimerRegisterId then
    Ui.tbLogic.tbTimer:Close(self.nTimerRegisterId)
    self.nTimerRegisterId = nil
  end
end

-- 获取自身坐标
function tbAutoPath:GetMyPos()
  local tbMyPos = {}
  tbMyPos.nMapId, tbMyPos.nX, tbMyPos.nY = me.GetWorldPos()
  if not MODULE_GAMESERVER then
    tbMyPos.nMapId = me.nTemplateMapId
  end
  return tbMyPos
end

-- 获得坐标显示串，用于调试
function tbAutoPath:GetPosStr(tbPos)
  if not tbPos then
    return "nil"
  end
  return string.format("%s(%s)<%s,%s>", GetMapNameFormId(tbPos.nMapId or 0), tbPos.nMapId or "nil", tbPos.nX or "nil", tbPos.nY or "nil")
end

-- 格式化输出
function tbAutoPath:OutF(...)
  --print("[AutoPath]", string.format(...));
end

-- 重载脚本
function tbAutoPath:Reload()
  DoScript("\\ui\\script\\logic\\autopath.lua")
end

function tbAutoPath:CBFollow(nPlayerId)
  local pNpc = KNpc.GetByPlayerId(nPlayerId)
  if pNpc then -- 距离很近，尝试直接跟随
    if ProcessNpcById(pNpc.dwId, UiManager.emACTION_FOLLOW) == 1 then
      return
    end
  end
  local tbMember = me.GetTeamMemberInfo()
  for _, tbMemberPlayer in ipairs(tbMember) do
    if tbMemberPlayer.nPlayerID == nPlayerId then
      local tbPos = {
        nMapId = tbMemberPlayer.nMapId,
      }
      for _, tbNpc in ipairs(SyncNpcInfo() or {}) do
        if tbNpc.szName == tbMemberPlayer.szName then
          tbPos.nX = tbNpc.nX / 2
          tbPos.nY = tbNpc.nY
          break
        end
      end
      Ui.tbLogic.tbAutoPath:GotoPos(tbPos, self.CBFollow, self, nPlayerId)
      return
    end
  end
  me.Msg("该玩家已消失得无影无踪！")
end

-- 注册UI消息回调
if not tbAutoPath.bReged then
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_START_AUTOPATH, "OnStart" },
    { UiNotify.emCOREEVENT_STOP_AUTOPATH, "OnStop" },
    { UiNotify.emCOREEVENT_UI_MINIMAP_CLICK, "OnMiniMapClick" },
    { UiNotify.emCOREEVENT_SYNC_CURRENTMAP, "OnChangePos" },
    { UiNotify.emCOREEVENT_SYNC_TRANS_POSITION, "OnChangePos" },
    { UiNotify.emCOREEVENT_PROGRESSBAR_TIMER, "OnStartProgress" },
    { UiNotify.emCOREEVENT_STOPGENERALPROCESS, "OnStopProgress" },
    { UiNotify.emCOREEVENT_AUTOPATH_DELAYLOAD_SUCC, "OnDelayLoadSucc" },
  }
  for _, tb in ipairs(tbRegEvent) do
    -- 此写法为了支持重载
    local szFunName = tb[2]
    local function fnReg(self, ...)
      self[szFunName](self, ...)
    end
    UiNotify:RegistNotify(tb[1], fnReg, tbAutoPath)
  end
  tbAutoPath.bReged = 1
end

tbAutoPath:Init()
