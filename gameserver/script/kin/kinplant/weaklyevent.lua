-- 文件名　：weaklyevent.lua
-- 创建者　：jiazhenwei
-- 创建时间：2011-12-13 16:49:06
-- 功能    ：周末家族活动

if not MODULE_GAMESERVER then
  return
end

Require("\\script\\kin\\kinplant\\kinplant_def.lua")

--load家族周末活动表
function KinPlant:LoadWeeklyEvent()
  local szFileName = "\\setting\\kin\\kinplant\\weeklyevent.txt"
  local tbFile = Lib:LoadTabFile(szFileName)
  if not tbFile then
    print("【家族种植】读取文件错误，文件不存在", szFileName)
    return
  end
  for nId, tbParam in ipairs(tbFile) do
    if nId > 1 then
      local nLevel = tonumber(tbParam.nLevel) or 0
      local nTime = tonumber(tbParam.nTime) or 0
      local nCount = tonumber(tbParam.nCount) or 0
      local nMinCount = tonumber(tbParam.nMinCount) or 0
      local nMaxStep = tonumber(tbParam.nMaxStep) or 0
      self.tbWeeklyEvent[nLevel] = self.tbWeeklyEvent[nLevel] or {}
      self.tbWeeklyEvent[nLevel] = { nTime = nTime, nCount = nCount, nMinCount = nMinCount, nMaxStep = nMaxStep }
    end
  end
end

--load家族周末活动表
function KinPlant:LoadWeeklyNpcPos()
  local szFileName = "\\setting\\kin\\kinplant\\weeklynpcpos.txt"
  local tbFile = Lib:LoadTabFile(szFileName)
  if not tbFile then
    print("【家族种植】读取文件错误，文件不存在", szFileName)
    return
  end
  for nId, tbParam in ipairs(tbFile) do
    if nId > 1 then
      local nMapId = tonumber(tbParam.nMapId) or 0
      local nPosX = tonumber(tbParam.TRAPX) or 0
      local nPosY = tonumber(tbParam.TRAPY) or 0
      if nMapId > 0 and nPosX > 0 and nPosY > 0 then
        self.tbWeeklyNpcPoint[nMapId] = self.tbWeeklyNpcPoint[nMapId] or {}
        table.insert(self.tbWeeklyNpcPoint[nMapId], { math.floor(nPosX / 32), math.floor(nPosY / 32) })
      end
    end
  end
end

KinPlant:LoadWeeklyEvent()
KinPlant:LoadWeeklyNpcPos()

--族长领取周末富禄之种
function KinPlant:GetSeedWeekly()
  if me.IsAccountLock() ~= 0 then
    Dialog:Say("你的账号处于锁定状态，无法进行该操作。")
    return 0
  end
  local nWeek = tonumber(GetLocalDate("%w"))
  if nWeek > 0 and nWeek < 6 then
    Dialog:Say("对不起，您只能在周六00:00之后才能领取福禄树种。")
    return 0
  end
  if me.nKinFigure ~= 1 then
    Dialog:Say("对不起，只有族长才能领取福禄之树的树种。")
    return 0
  end
  local cKin = KKin.GetKin(me.dwKinId)
  if not cKin then
    return 0
  end
  local nFlag = math.fmod(cKin.GetHandInCount(), 10)
  local nWeek = math.floor(math.fmod(cKin.GetHandInCount(), 1000) / 10)
  local nCount = math.floor(cKin.GetHandInCount() / 1000)
  local nNowWeek = tonumber(GetLocalDate("%W"))
  if nNowWeek ~= nWeek then
    nCount = 0
    nFlag = 0
  end
  if nFlag >= 1 then
    Dialog:Say("本周家族的福禄种子已经领取过了。")
    return 0
  end
  if nCount < self.nKinMaxTreeWeekly then
    Dialog:Say(string.format("对不起，您的家族本周收获次数为%s，还没有达到领取福禄树种的标准，只有收获次数达到%s次才能领取。", nCount, self.nKinMaxTreeWeekly))
    return 0
  end
  if me.CountFreeBagCell() < 2 then
    Dialog:Say("背包空间不足2格，请清理下再来。")
    return 0
  end
  for i = 1, 2 do
    local pItem = me.AddItem(unpack(self.tbWeeklySeed))
    if pItem then
      me.SetItemTimeout(pItem, 2 * 24 * 60, 0)
    end
  end
  GCExcute({ "KinPlant:SetKinFlag", me.dwKinId })
  StatLog:WriteStatLog("stat_info", "spe_tree", "get_tree", me.nId, 1)
  KKin.Msg2Kin(me.dwKinId, "族长在吕丰年处领取了福禄树种。", 0)
end

--种周末的树
function KinPlant:PlantWeekly(nLevel, nItemLevel)
  if not nLevel or not self.tbWeeklyEvent[nLevel] then
    Dialog:Say("你选择的等级异常。")
    return 0
  end
  if me.dwKinId <= 0 then
    Dialog:Say("你没有家族，不能种植这粒种子。")
    return 0
  end
  --time
  if nItemLevel <= 1 then --特殊树种这里不做周末限制
    local nDate = tonumber(GetLocalDate("%w"))
    if not self.tbWeeklyDate[nDate] then
      Dialog:Say("该树种只能在周末种植。")
      return 0
    end
  end
  --map
  local nMapId, x, y = me.GetWorldPos()
  if not self.tbWeaklyMap[nMapId] then
    Dialog:Say("只能在凤翔府和成都府种植这粒种子。")
    return 0
  end
  --npc
  local tbNpcList = KNpc.GetAroundNpcList(me, 10)
  for _, pNpc in ipairs(tbNpcList) do
    if pNpc.nKind == 3 then
      Dialog:Say("在这种会把<color=green>" .. pNpc.szName .. "<color>给挡住了，还是挪个地方吧。")
      return 0
    end
  end
  local pNpc = KNpc.Add2(self.nWeeklyTempNpcId, 1, -1, nMapId, x, y)
  if not pNpc then
    return 0
  end
  pNpc.SetLiveTime(30 * 60 * 18) --树只存在30分钟
  local nAddTime = 0
  if self.nTimer_ReFreshNpc then
    nAddTime = math.max(math.floor(Timer:GetRestTime(self.nTimer_ReFreshNpc) / Env.GAME_FPS), 0)
  end
  local nTimerId = Timer:Register((self.tbWeeklyEvent[nLevel].nTime + nAddTime) * Env.GAME_FPS, self.Rand, self, pNpc.dwId, nLevel)
  local tbTemp = pNpc.GetTempTable("Npc")
  tbTemp.tbWeekly = {
    ["nLevel"] = nLevel,
    ["dwKinId"] = me.dwKinId,
    ["nTimerId"] = nTimerId,
    ["nFinish"] = 0,
    ["nStep"] = 0,
    ["nCount1"] = 0,
    ["nCount2"] = 0,
    ["nCount3"] = 0,
    ["tbPlayer"] = {},
    ["tbAward"] = {},
    ["tbStepCount"] = {},
  }
  local szKinName = ""
  local cKin = KKin.GetKin(me.dwKinId)
  if cKin then
    szKinName = cKin.GetName()
  end
  if szKinName ~= "" then
    pNpc.szName = szKinName .. "家族的" .. pNpc.szName
  end
  return 1
end

--增加步骤
function KinPlant:AddStep(dwNpcId)
  local pNpc = KNpc.GetById(dwNpcId)
  if not pNpc then
    return
  end
  local tbTemp = pNpc.GetTempTable("Npc")
  if not tbTemp.tbWeekly then
    return
  end
  tbTemp.tbWeekly.nStep = tbTemp.tbWeekly.nStep + 1
  local nLevel = tbTemp.tbWeekly.nLevel
  --已经最后一波了
  if self.tbWeeklyEvent[nLevel].nMaxStep + 1 <= tbTemp.tbWeekly.nStep then
    return 1
  end
  --已经达标
  if self.tbWeeklyEvent[nLevel].nMinCount <= tbTemp.tbWeekly.nFinish then
    return 2
  end
  return
end

--随即刷道具，需求物品
function KinPlant:Rand(dwNpcId, nLevel)
  local pNpc = KNpc.GetById(dwNpcId)
  if not pNpc then
    return 0
  end
  local tbTemp = pNpc.GetTempTable("Npc")
  if not tbTemp.tbWeekly then
    return 0
  end
  local cKin = KKin.GetKin(tbTemp.tbWeekly.dwKinId)
  local nStep = self:AddStep(dwNpcId)
  if nStep then
    local szMsg = ""
    if nStep == 1 then
      szMsg = "福禄植树趣味活动已经结束，很遗憾没能成功。"
      if cKin then
        --StatLog:WriteStatLog("stat_info", "spe_tree", "tree_end", me.nId, string.format("0,%s", tbTemp.tbWeekly.nLevel));
        WriteStatLog("stat_info", "spe_tree", "tree_end", string.format("NONE\tNONE\t%s,0,%s", cKin.GetName(), tbTemp.tbWeekly.nLevel))
      end
    else
      szMsg = "福禄植树趣味活动成功结束，本家族表现精彩，请参与的人员领取奖励。"
      if cKin then
        local tbName = { "出尘", "惊世", "雏凤", "潜龙", "至尊", "无双" }
        local szWorldMsg = string.format("[%s]家族成功通过[%s]难度的丰收之神试炼，成功种植福禄之树，整个家族喜迎丰收！", cKin.GetName(), tbName[tbTemp.tbWeekly.nLevel])
        KDialog.NewsMsg(0, Env.NEWSMSG_NORMAL, szWorldMsg)
        Dialog:GlobalMsg2SubWorld_GS(szWorldMsg)
        --StatLog:WriteStatLog("stat_info", "spe_tree", "tree_end", me.nId, string.format("1,%s", tbTemp.tbWeekly.nLevel));
        WriteStatLog("stat_info", "spe_tree", "tree_end", string.format("NONE\tNONE\t%s,1,%s", cKin.GetName(), tbTemp.tbWeekly.nLevel))
      end
    end
    KKin.Msg2Kin(tbTemp.tbWeekly.dwKinId, szMsg, 0)
    self:CloseAddNpc()
    return 0
  end
  self:RandItem(dwNpcId)
  if tbTemp.tbWeekly.nStep == 1 then
    self:AddNpc(pNpc.nMapId)
    KKin.Msg2Kin(tbTemp.tbWeekly.dwKinId, string.format("可以给福禄之树上交资源了，请家族各位侠客赶紧行动。", tbTemp.tbWeekly.nStep), 0)
  else
    KKin.Msg2Kin(tbTemp.tbWeekly.dwKinId, string.format("福禄种植第%s轮开始了，请尽快交够物品。", tbTemp.tbWeekly.nStep), 0)
  end
  return self.tbWeeklyEvent[nLevel].nTime * Env.GAME_FPS
end

--随即需求的道具
function KinPlant:RandItem(dwNpcId)
  local pNpc = KNpc.GetById(dwNpcId)
  if not pNpc then
    return
  end
  local tbTemp = pNpc.GetTempTable("Npc")
  if not tbTemp.tbWeekly then
    return
  end
  local nLevel = tbTemp.tbWeekly.nLevel
  local nCount1 = 0
  local nCount2 = 0
  local nCount3 = 0
  --需求的总数
  local nCount = self.tbWeeklyEvent[nLevel].nCount
  nCount1 = MathRandom(nCount) --随即第1种
  nCount = nCount - nCount1
  if nCount > 0 then
    nCount2 = MathRandom(nCount) --随即第2种
    nCount3 = nCount - nCount2 --剩余的为第3种
  end

  local tbCount = { nCount1, nCount2, nCount3 }
  Lib:SmashTable(tbCount) --打乱随即的物品
  tbTemp.tbWeekly.nCount1 = tbCount[1]
  tbTemp.tbWeekly.nCount2 = tbCount[2]
  tbTemp.tbWeekly.nCount3 = tbCount[3]
  return
end

--每个家族第一阶段掉进来
function KinPlant:AddNpc(nMapId)
  if self.nNum_KinPlant <= 0 then
    self.nTimer_ReFreshNpc = Timer:Register(1, self.AddNpcTime, self, nMapId)
  end
  self.nNum_KinPlant = self.nNum_KinPlant + 1
end

--每个家族完成或者失败掉进来
function KinPlant:CloseAddNpc()
  self.nNum_KinPlant = math.max(self.nNum_KinPlant - 1, 0) -- 保证不会出现负值
end

--补充npc数量，保持每种4个
function KinPlant:AddNpcTime(nMapId)
  --如果发现已经没有家族在进行任务了关掉刷npc的timer
  if self.nNum_KinPlant <= 0 then
    return 0
  end
  for i = 1, 8 do
    local nIndex = self:RandomPos(nMapId) --随即一个不重复的点
    local x, y = unpack(self.tbWeeklyNpcPoint[nMapId][nIndex])
    local pNpc = KNpc.Add2(self.tbWeeklyNpcId[math.fmod(i, 2) + 1], 1, -1, nMapId, x, y)
    if pNpc then
      pNpc.SetLiveTime(3 * 60 * 18) --只存在2分钟
      self.tbManagerNpc[i] = nIndex
    end
  end
  --没有加过，或者上次出现的时间不满足现在情况
  for j = 9, 12 do
    local nIndex = self:RandomPos(nMapId) --随即一个不重复的点
    local nX, nY = unpack(self.tbWeeklyNpcPoint[nMapId][nIndex])
    Npc:OnSetFreeAI(nMapId, nX * 32, nY * 32, 9873, 0, 0, 180, 0, 9890, 10, {})
    self.tbManagerNpc[j] = nIndex
  end
  return 3 * 60 * Env.GAME_FPS
end

--随即点
function KinPlant:RandomPos(nMapId)
  local nRand = MathRandom(#self.tbWeeklyNpcPoint[nMapId])
  for i = 1, 5 do
    if self.tbManagerNpc[i] and self.tbManagerNpc[i] == nRand then
      nRand = nRand + 1
      nRand = math.fmod(nRand, #self.tbWeeklyNpcPoint[nMapId]) + 1 --防止出现超过最大值的点
    end
  end
  return nRand
end

--检查身上是不是有有材料
function KinPlant:CheckItemInBag()
  if #GM:GMFindAllRoom({ 18, 1, 1587, 1 }) > 0 then
    return 1
  end
  if #GM:GMFindAllRoom({ 18, 1, 1588, 1 }) > 0 then
    return 1
  end
  if #GM:GMFindAllRoom({ 18, 1, 1589, 1 }) > 0 then
    return 1
  end
  return 0
end

----------------------------------------------------------------------
--npc
local tbNpc = Npc:GetClass("weeklyplant")

function tbNpc:OnDialog()
  local tbName = { "出尘", "惊世", "雏凤", "潜龙", "至尊", "<color=yellow>无双<color>" }
  local tbItemName = { "清水", "肥料", "除虫药粉" }
  local tbTemp = him.GetTempTable("Npc")
  if not tbTemp.tbWeekly then
    Dialog:Say("树处于病态。")
    return
  end
  if tbTemp.tbWeekly.dwKinId ~= me.dwKinId then
    Dialog:Say("这棵树不是你们家族的。")
    return 0
  end
  local nLevel = tbTemp.tbWeekly.nLevel
  local szMsg = ""
  local nMaxStep = KinPlant.tbWeeklyEvent[nLevel].nMaxStep
  local nMinCount = KinPlant.tbWeeklyEvent[nLevel].nMinCount
  local nFlag = 0
  if tbTemp.tbWeekly.nStep <= 0 then
    szMsg = "福禄之树（难度" .. tbName[nLevel] .. "）趣味挑战即将开始：" .. string.format("%s时%s分%s秒", Lib:TransferSecond2NormalTime(math.floor(Timer:GetRestTime(tbTemp.tbWeekly.nTimerId) / 18)))
  elseif tbTemp.tbWeekly.nStep <= nMaxStep and tbTemp.tbWeekly.nFinish < nMinCount then
    szMsg = string.format(
      "福禄之树趣味挑战已经开始：\n福禄之树成长的每个阶段都需求一定数量的<color=green>水，肥料，除虫药粉<color>。在每阶段规定时限内上交足够的资源，福禄之树即可获得<color=yellow>1点成长点数<color>。达到成长点数需求即给予家族奖励。\n<color=red>每名家族成员只能同时携带数量为1的一种资源，每轮每位侠客最多上交2个资源。<color>\n<color=yellow>【水和肥料】<color>：在城市里的水桶，肥料袋堆处采集获得\n<color=yellow>【除虫药粉】<color>：与城市中散步的吕丰年对话获得\n当前难度：<color=yellow>%s<color>，最低需求成长值%s\n当前阶段：第<color=yellow>%s/%s<color>轮，成长值<color=yellow>%s<color>\n还需要水：<color=yellow>%s<color>桶\n还需要肥料：<color=yellow>%s<color>包\n除虫药粉：<color=yellow>%s<color>包\n本轮剩余时间：%s时%s分%s秒",
      tbName[nLevel],
      nMinCount,
      tbTemp.tbWeekly.nStep,
      nMaxStep,
      tbTemp.tbWeekly.nFinish,
      tbTemp.tbWeekly.nCount1,
      tbTemp.tbWeekly.nCount2,
      tbTemp.tbWeekly.nCount3,
      Lib:TransferSecond2NormalTime(math.floor(Timer:GetRestTime(tbTemp.tbWeekly.nTimerId) / 18))
    )
    if tbTemp.tbWeekly.nCount1 == 0 and tbTemp.tbWeekly.nCount2 == 0 and tbTemp.tbWeekly.nCount3 == 0 then
      szMsg = string.format(
        "福禄之树趣味挑战已经开始：\n福禄之树成长的每个阶段都需求一定数量的<color=green>水，肥料，除虫药粉<color>。在每阶段规定时限内上交足够的资源，福禄之树即可获得<color=yellow>1点成长点数<color>。达到成长点数需求即给予家族奖励。\n<color=red>每名家族成员只能同时携带数量为1的一种资源，每轮每位侠客最多上交2个资源。<color>\n<color=yellow>【水和肥料】<color>：在城市里的水桶，肥料袋堆处采集获得\n<color=yellow>【除虫药粉】<color>：与城市中散步的吕丰年对话获得\n当前难度：<color=yellow>%s<color>，最低需求成长值%s\n当前阶段：第<color=yellow>%s/%s<color>轮，成长值<color=yellow>%s<color>\n<color=green>本轮上交已完成<color>\n本轮剩余时间：%s时%s分%s秒",
        tbName[nLevel],
        nMinCount,
        tbTemp.tbWeekly.nStep,
        nMaxStep,
        tbTemp.tbWeekly.nFinish,
        Lib:TransferSecond2NormalTime(math.floor(Timer:GetRestTime(tbTemp.tbWeekly.nTimerId) / 18))
      )
    end
    nFlag = 1
  else
    if tbTemp.tbWeekly.nFinish >= nMinCount then
      szMsg = "你们的辛勤劳动得到了丰收之神的认可，这健康成长的福禄之树就是对你们劳动的回报。勤劳的人们，都来收获丰收的喜悦吧。"
      nFlag = 3
    else
      szMsg = "很遗憾，你们还差一点点的努力，这一次没有种植成功，不能获得丰收之神的奖励。不要气馁，下一次再努力吧。愿丰收之神保佑你！"
      nFlag = 2
    end
  end

  local tbOpt = {}
  if nFlag > 0 then
    table.insert(tbOpt, { "查看参与种植的侠客", self.Quely, self, him.dwId })
  end
  if nFlag == 1 then
    table.insert(tbOpt, 1, { "上交资源", self.HandInItem, self, him.dwId })
  elseif nFlag >= 2 then
    table.insert(tbOpt, { "领取奖励", self.GetAward, self, him.dwId, nFlag })
  end
  table.insert(tbOpt, { "查看活动规则", self.QuelyRule, self })
  table.insert(tbOpt, { "我知道了" })
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:QuelyRule()
  Dialog:Say("每一个阶段，福禄之树都会需求一定数量的水，肥料，除虫药粉。水和肥料需要在城市里的<color=green>水桶<color>，<color=green>肥料袋堆<color>处采集获得；除虫药粉需要与在城市中散步的<color=green>吕丰年<color>对话获得。\n  如果在当前阶段的时限内，整个家族的玩家获取并上交了足够数量的水，肥料等资源，则福禄之树获得<color=yellow>1点成长值<color>。当新的阶段开始时，上一阶段玩家上交的水，肥料等资源数量均清空。")
end

function tbNpc:Quely(dwNpcId)
  local pNpc = KNpc.GetById(dwNpcId)
  if not pNpc then
    return 0
  end
  local tbTemp = pNpc.GetTempTable("Npc")
  if not tbTemp.tbWeekly then
    Dialog:Say("树处于病态。")
    return
  end
  local szMsg = "已上交物品的玩家：\n"
  local tb = {}
  for szName, nCount in pairs(tbTemp.tbWeekly.tbPlayer) do
    table.insert(tb, { szName, nCount })
  end
  if #tb > 1 then
    table.sort(tb, function(a, b)
      return a[2] > b[2]
    end)
  end
  for i, tbInfo in pairs(tb) do
    szMsg = szMsg .. "第" .. i .. "名：  " .. tbInfo[1] .. "  " .. tbInfo[2] .. "个\n"
  end
  Dialog:Say(szMsg)
  return
end

function tbNpc:HandInItem(dwNpcId)
  Dialog:OpenGift("请上交物品", nil, { self.OnOpenGiftOk, self, dwNpcId })
end

function tbNpc:OnOpenGiftOk(dwNpcId, tbItemObj)
  local pNpc = KNpc.GetById(dwNpcId)
  if not pNpc then
    return 0
  end
  local tbTemp = pNpc.GetTempTable("Npc")
  if not tbTemp.tbWeekly then
    return 0
  end
  if tbTemp.tbWeekly.dwKinId ~= me.dwKinId then
    Dialog:Say("这棵树不是你们家族的。")
    return 0
  end
  if me.nKinFigure == 0 or me.nKinFigure == Kin.FIGURE_SIGNED then
    Dialog:Say("只有荣誉成员和正式成员才能参加活动。")
    return 0
  end
  if Lib:CountTB(tbItemObj) ~= 1 then
    Dialog:Say("每次只能上交一个物品。")
    return 0
  end
  local nStep = tbTemp.tbWeekly.nStep
  if tbTemp.tbWeekly.tbStepCount[me.szName] then
    if nStep == tbTemp.tbWeekly.tbStepCount[me.szName][1] and tbTemp.tbWeekly.tbStepCount[me.szName][2] >= KinPlant.nMaxStepCount then
      Dialog:Say(string.format("每轮只可以上交%s个资源。", KinPlant.nMaxStepCount))
      return 0
    end
  end
  local nParticular = 0
  for _, pItem in pairs(tbItemObj) do
    local szItem = string.format("%s,%s,%s,%s", pItem[1].nGenre, pItem[1].nDetail, pItem[1].nParticular, pItem[1].nLevel)
    if szItem ~= "18,1,1587,1" and szItem ~= "18,1,1588,1" and szItem ~= "18,1,1589,1" then
      Dialog:Say("你上交的物品不对。")
      return 0
    end
    nParticular = pItem[1].nParticular
  end
  for _, pItem in pairs(tbItemObj) do
    pItem[1].Delete(me)
  end

  for i = 1, 3 do
    if nParticular == 1586 + i and tbTemp.tbWeekly["nCount" .. i] > 0 then
      tbTemp.tbWeekly["nCount" .. i] = tbTemp.tbWeekly["nCount" .. i] - 1
      tbTemp.tbWeekly.tbPlayer[me.szName] = tbTemp.tbWeekly.tbPlayer[me.szName] or 0
      tbTemp.tbWeekly.tbPlayer[me.szName] = tbTemp.tbWeekly.tbPlayer[me.szName] + 1
      --每次步骤只能交两次
      tbTemp.tbWeekly.tbStepCount[me.szName] = tbTemp.tbWeekly.tbStepCount[me.szName] or { nStep, 0 }
      if nStep ~= tbTemp.tbWeekly.tbStepCount[me.szName][1] then
        tbTemp.tbWeekly.tbStepCount[me.szName] = { nStep, 0 }
      end
      tbTemp.tbWeekly.tbStepCount[me.szName][2] = tbTemp.tbWeekly.tbStepCount[me.szName][2] + 1
      --因为每次最多上交1个，所以在这里做判断不会出问题
      self:CheckIsFinish(dwNpcId)
      local tbItemName = { " 水", "肥料", "除虫药粉" }
      Dialog:SendBlackBoardMsg(me, string.format("您上交了1个资源：%s", tbItemName[i]))
      StatLog:WriteStatLog("stat_info", "spe_tree", "tree_join", me.nId, i)
    end
  end
end

--每次交种子都判断本次是不是成功
function tbNpc:CheckIsFinish(dwNpcId)
  local pNpc = KNpc.GetById(dwNpcId)
  if not pNpc then
    return 0
  end
  local tbTemp = pNpc.GetTempTable("Npc")
  if not tbTemp.tbWeekly then
    return 0
  end
  local nFlag = 0
  for i = 1, 3 do
    if tbTemp.tbWeekly["nCount" .. i] ~= 0 then
      nFlag = 1
      break
    end
  end
  if nFlag == 0 then
    tbTemp.tbWeekly.nFinish = tbTemp.tbWeekly.nFinish + 1
    KKin.Msg2Kin(me.dwKinId, "捷报！本轮福禄之树所需物资已全部上交。", 0)
  end
end

function tbNpc:GetAward(dwNpcId, nFlag)
  local pNpc = KNpc.GetById(dwNpcId)
  if not pNpc then
    return
  end
  local tbTemp = pNpc.GetTempTable("Npc")
  if not tbTemp.tbWeekly then
    return
  end
  if not KinPlant.tbWeeklyAward[tbTemp.tbWeekly.nLevel] then
    return
  end
  local tbAward = KinPlant.tbWeeklyAward[tbTemp.tbWeekly.nLevel]
  if tbTemp.tbWeekly.tbAward[me.szName] then
    Dialog:Say("你已经领取过奖励了。")
    return
  end
  if me.CountFreeBagCell() < 3 + nFlag then
    Dialog:Say(string.format("背包空间不足%s格，请清理下再来。", 3 + nFlag))
    return
  end
  if not tbTemp.tbWeekly.tbPlayer[me.szName] then
    Dialog:Say("对不起，只有上交过物品才能领奖喔亲~")
    return
  end
  if nFlag == 3 then
    me.AddStackItem(tbAward[2][1], tbAward[2][2], tbAward[2][3], tbAward[2][4], nil, tbAward[1])
    me.AddKinReputeEntry(10)
    Achievement:FinishAchievement(me, 472) --缘起缘落
    Achievement:FinishAchievement(me, 473) --福泽广被
    Achievement:FinishAchievement(me, 473 + tbTemp.tbWeekly.nLevel) --泽被苍生1-5,苦尽甘来
  end
  me.AddStackItem(18, 1, 80, 1, nil, 5)
  tbTemp.tbWeekly.tbAward[me.szName] = 1
  me.Msg("恭喜你，你将获得丰收之神的奖励。")
end

--清水
local tbWarter = Npc:GetClass("weeklywarter")

function tbWarter:OnDialog(_, nFlag)
  if KinPlant:CheckItemInBag() == 1 then
    Dialog:Say("每个人身上每次只能携带一个材料。")
    return 0
  end
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("背包空间不足1格，请清理下再来。")
    return
  end
  if not nFlag then
    local tbEvent = {
      Player.ProcessBreakEvent.emEVENT_MOVE,
      Player.ProcessBreakEvent.emEVENT_ATTACK,
      Player.ProcessBreakEvent.emEVENT_SITE,
      Player.ProcessBreakEvent.emEVENT_USEITEM,
      Player.ProcessBreakEvent.emEVENT_ARRANGEITEM,
      Player.ProcessBreakEvent.emEVENT_DROPITEM,
      Player.ProcessBreakEvent.emEVENT_SENDMAIL,
      Player.ProcessBreakEvent.emEVENT_TRADE,
      Player.ProcessBreakEvent.emEVENT_CHANGEFIGHTSTATE,
      Player.ProcessBreakEvent.emEVENT_CLIENTCOMMAND,
      Player.ProcessBreakEvent.emEVENT_LOGOUT,
      Player.ProcessBreakEvent.emEVENT_DEATH,
    }
    GeneralProcess:StartProcess("拿取中...", 3 * Env.GAME_FPS, { self.OnDialog, self, _, 1 }, nil, tbEvent)
    return
  end
  local pItem = me.AddItem(18, 1, 1587, 1)
  if pItem then
    me.SetItemTimeout(pItem, 3, 0)
    Dialog:SendBlackBoardMsg(me, string.format("您成功收集了1个资源：%s", pItem.szName))
  end
end

--肥料
local tbFertilizer = Npc:GetClass("weeklyfertilizer")

function tbFertilizer:OnDialog(_, nFlag)
  if KinPlant:CheckItemInBag() == 1 then
    Dialog:Say("每个人身上每次只能携带一个材料。")
    return 0
  end
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("背包空间不足1格，请清理下再来。")
    return
  end
  if not nFlag then
    local tbEvent = {
      Player.ProcessBreakEvent.emEVENT_MOVE,
      Player.ProcessBreakEvent.emEVENT_ATTACK,
      Player.ProcessBreakEvent.emEVENT_SITE,
      Player.ProcessBreakEvent.emEVENT_USEITEM,
      Player.ProcessBreakEvent.emEVENT_ARRANGEITEM,
      Player.ProcessBreakEvent.emEVENT_DROPITEM,
      Player.ProcessBreakEvent.emEVENT_SENDMAIL,
      Player.ProcessBreakEvent.emEVENT_TRADE,
      Player.ProcessBreakEvent.emEVENT_CHANGEFIGHTSTATE,
      Player.ProcessBreakEvent.emEVENT_CLIENTCOMMAND,
      Player.ProcessBreakEvent.emEVENT_LOGOUT,
      Player.ProcessBreakEvent.emEVENT_DEATH,
    }
    GeneralProcess:StartProcess("拿取中...", 3 * Env.GAME_FPS, { self.OnDialog, self, _, 1 }, nil, tbEvent)
    return
  end
  local pItem = me.AddItem(18, 1, 1588, 1)
  if pItem then
    me.SetItemTimeout(pItem, 3, 0)
    Dialog:SendBlackBoardMsg(me, string.format("您成功收集了1个资源：%s", pItem.szName))
  end
end

--药粉
local tbPower = Npc:GetClass("weeklypower")

function tbPower:OnDialog(_, nFlag)
  if not nFlag then
    Dialog:Say("你是来讨<color=yellow>除虫药粉<color>的吗？这个可是很珍贵的，一次只能给你一包，愿丰收之神保佑你们。", { { "领取除虫药粉", self.OnDialog, self, nil, 1 }, { "我再想想" } })
    return 0
  end
  if KinPlant:CheckItemInBag() == 1 then
    Dialog:Say("每个人身上每次只能携带一个材料。")
    return 0
  end
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("背包空间不足1格，请清理下再来。")
    return
  end
  local pItem = me.AddItem(18, 1, 1589, 1)
  if pItem then
    me.SetItemTimeout(pItem, 3, 0)
    Dialog:SendBlackBoardMsg(me, string.format("您成功收集了1个资源：%s", pItem.szName))
  end
end
----------------------------------------------------------------------
--item

local tbSeed = Item:GetClass("WeeklySeed")

function tbSeed:OnUse(nLevel, dwItemId)
  local tbName = { "出尘", "惊世", "雏凤", "潜龙", "至尊", "<color=yellow>无双<color>" }
  local szMsg = "福禄之种趣味挑战，每个周末你可以在凤翔府和成都府处种植，<color=yellow>请选择要挑战的难度<color>。\n\n<color=yellow>【活动规则】<color>：种植过程持续30分钟分为10阶段。每1阶段，福禄之树都会需求一定数量的<color=green>水，肥料，除虫药粉<color>。\n<color=yellow>水和肥料<color>：在城市里的水桶，肥料袋堆处采集获得\n<color=yellow>除虫药粉<color>：与城市中散步的吕丰年对话获得\n  如果在当前阶段的时限内，整个家族的玩家获取并上交了足够数量的水，肥料等资源，则福禄之树获得<color=yellow>一点成长值<color>。\n<color=red>玩家身上同时只能携带1个某一种资源<color>。"
  local tbOpt = {}
  if not dwItemId then
    for i = 1, 6 do
      table.insert(tbOpt, { tbName[i], self.OnUse, self, i, it.dwId })
    end
    table.insert(tbOpt, { "我再考虑下" })
    Dialog:Say(szMsg, tbOpt)
    return 0
  end
  if not dwItemId then
    return
  end
  local pItem = KItem.GetObjById(dwItemId)
  if not pItem then
    return
  end
  if KinPlant:PlantWeekly(nLevel, pItem.nLevel) == 1 then
    pItem.Delete(me)
    local cKin = KKin.GetKin(me.dwKinId)
    if cKin then
      local tbMap = { [24] = "凤翔府", [27] = "成都府" }
      local szWorldMsg = string.format("[%s]家族开始在[%s]种植福禄之树，家族成员群策群力，热情高涨！", cKin.GetName(), tbMap[me.nMapId])
      KDialog.NewsMsg(0, Env.NEWSMSG_NORMAL, szWorldMsg)
      Dialog:GlobalMsg2SubWorld_GS(szWorldMsg)
    end
    StatLog:WriteStatLog("stat_info", "spe_tree", "seed_use", me.nId, 1)
    KKin.Msg2Kin(me.dwKinId, "福禄之种趣味挑战已经开始，请家族成员赶快参加。", 0)
  end
end

local tbSource = Item:GetClass("WeeklySource")

function tbSource:OnUse()
  Dialog:Say(" 你想销毁这个资源吗？", { { "销毁", self.Destroy, self, it.dwId }, { "取消" } })
  return 0
end

function tbSource:Destroy(dwId)
  local pItem = KItem.GetObjById(dwId)
  if pItem then
    local szName = pItem.szName
    pItem.Delete(me)
    me.Msg("你销毁了" .. szName)
  end
end
