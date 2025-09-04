-- zhouchenfei
-- 2012/9/24 15:30:59
-- 烟花活动
Require("\\script\\event\\specialevent\\zhounianqing2012\\zhounianqing2012_public.lua")

if not MODULE_GAMESERVER then
  return 0
end

local ZhouNianQing2012 = SpecialEvent.ZhouNianQing2012

ZhouNianQing2012.tbYanHuaSkill = { 307, 1532, 1540, 1596 }

ZhouNianQing2012.nMaxRandomNum = 10000
ZhouNianQing2012.tbRandom_XiaoTianDengKa = {
  { 500, { 18, 1, 1824, 2 } },
  { 500, { 18, 1, 1824, 3 } },
  { 500, { 18, 1, 1824, 4 } },
  { 500, { 18, 1, 1824, 5 } },
}

ZhouNianQing2012.tbRandom_HeBiKa = {
  { 10, { 18, 1, 1824, 1 } },
  { 2495, { 18, 1, 1824, 2 } },
  { 2495, { 18, 1, 1824, 3 } },
  { 2500, { 18, 1, 1824, 4 } },
  { 2500, { 18, 1, 1824, 5 } },
}

ZhouNianQing2012.tbRandomAward_YanHua = {
  {
    { 0, "bindcoin", 150 },
    { 0, "baseexp", 30 },
  },
  {
    { 0, "bindcoin", 200 },
    { 0, "baseexp", 30 },
  },
  {
    { 0, "bindcoin", 350 },
    { 0, "baseexp", 60 },
  },
  {
    { 9000, "bindcoin", 500 },
    { 1000, "bindcoin", 1888 },
    { 0, "baseexp", 120 },
  },
}

ZhouNianQing2012.nChangeSkillId = 2257
ZhouNianQing2012.nChangeMaxLevel = 4
ZhouNianQing2012.nChangeTime = 60

ZhouNianQing2012.nTeShiNpcId = 11154
ZhouNianQing2012.nDaTianDengNpcId = 11155
ZhouNianQing2012.MAX_XIAOTIANDENG_COUNT = 125

ZhouNianQing2012.tbTeShiPos = {
  { 23, 1566, 3093 },
  { 24, 1763, 3526 },
  { 29, 1627, 3934 },
}
ZhouNianQing2012.tbDaTianDengPos = {
  { 23, 1627, 3023 },
  { 24, 1787, 3544 },
  { 29, 1490, 3787 },
}
ZhouNianQing2012.szXiaoTianDengFile = "\\setting\\event\\specialevent\\zhounianqing2012\\xiaotiandengpos.txt"

function ZhouNianQing2012:LoadPosFile()
  self:LoadXiaoTianDengPos()
end

function ZhouNianQing2012:LoadXiaoTianDengPos()
  self.tbXiaoTianDeng_PosList = {}
  local tbFile = Lib:LoadTabFile(self.szXiaoTianDengFile)
  if not tbFile then
    return
  end
  for nId, tbParam in ipairs(tbFile) do
    local nMapId = tonumber(tbParam.MapId) or 0
    local nX = tonumber(tbParam.PosX) or 0
    local nY = tonumber(tbParam.PosY) or 0
    if nMapId > 0 then
      local tbMapInfo = self.tbXiaoTianDeng_PosList[nMapId]
      if not tbMapInfo then
        tbMapInfo = {}
        self.tbXiaoTianDeng_PosList[nMapId] = tbMapInfo
      end
      table.insert(tbMapInfo, { nX, nY })
    end
  end
  return 1
end

function ZhouNianQing2012:FireYanHua(pPlayer)
  if not pPlayer then
    return 0
  end
  local nRand = MathRandom(1, #self.tbYanHuaSkill)
  local nSkillId = self.tbYanHuaSkill[nRand]
  pPlayer.CastSkill(nSkillId, 1, -1, pPlayer.GetNpc().nIndex)
  return 1
end

-- 增加小天灯
function ZhouNianQing2012:OnAddXiaoTianDeng()
  local nFlag, szError = self:IsOpenEvent()
  if 1 ~= nFlag then
    return 0
  end

  local szAnncone = string.format("小天灯出现，大家快去汴京、凤翔、临安，找到小天灯点燃吧！")
  Dialog:GlobalNewsMsg_GS(szAnncone)
  for nMapId, tbPosList in pairs(self.tbXiaoTianDeng_PosList) do
    if SubWorldID2Idx(nMapId) >= 0 then
      print("[ZhouNianQing2012] AddXiaoTianDeng ", nMapId)
      if not self.tbXiaoTianDengNpcObj then
        self.tbXiaoTianDengNpcObj = {}
      end
      Lib:SmashTable(tbPosList)
      local nXiaoTianDengCount = 0
      for nIndex, tbPos in pairs(tbPosList) do
        if nXiaoTianDengCount > ZhouNianQing2012.MAX_XIAOTIANDENG_COUNT then
          break
        end
        local nNpcId_XiaoTianDeng = self.nXiaoTianDeng1
        local nRand = MathRandom(100)
        if nRand <= 50 then
          nNpcId_XiaoTianDeng = self.nXiaoTianDeng2
        end
        local pNpc = KNpc.Add2(nNpcId_XiaoTianDeng, 90, -1, nMapId, tbPos[1], tbPos[2])
        if pNpc then
          table.insert(self.tbXiaoTianDengNpcObj, pNpc.dwId)
        end
        nXiaoTianDengCount = nXiaoTianDengCount + 1
      end
    end
  end
end

-- 删除小天灯
function ZhouNianQing2012:OnClearXiaoTianDeng()
  if not self.tbXiaoTianDengNpcObj then
    return 0
  end
  for _, dwNpcId in pairs(self.tbXiaoTianDengNpcObj) do
    local pNpc = KNpc.GetById(dwNpcId)
    if pNpc then
      pNpc.Delete()
    end
  end
  self.tbXiaoTianDengNpcObj = {}
  return 1
end

function ZhouNianQing2012:UpdateZiKaCount(pPlayer)
  if not pPlayer then
    return 0
  end
  local nLastDate = self:GetZiKaTime(pPlayer)
  local nNowTime = GetTime()
  local nNowDate = tonumber(os.date("%Y%m%d", nNowTime))
  if nNowDate == nLastDate then
    return 0
  end

  self:SetZiKaTime(pPlayer, nNowDate)
  self:SetZiKaCount(pPlayer, 0)
end

function ZhouNianQing2012:IsCanAddZiKa(pPlayer)
  local nCount = self:GetZiKaCount(pPlayer)
  if nCount >= self.MAX_ZIKA_DAY_COUNT then
    return 0, string.format("已经到达今天收集最大张数了，不能再收集！")
  end
  return 1
end

function ZhouNianQing2012:AddZiKa_XiaoTianDeng(pPlayer)
  if not pPlayer then
    return 0
  end
  self:UpdateZiKaCount(pPlayer)
  local nFlag, szError = self:IsCanAddZiKa(pPlayer)
  if 1 ~= nFlag then
    return 0
  end
  local tbRandomItem = self:GetMyRandomItem(self.tbRandom_XiaoTianDengKa)
  if not tbRandomItem then
    return 0
  end
  local nCount = self:GetZiKaCount(pPlayer)
  self:SetZiKaCount(pPlayer, nCount + 1)
  local pItem = pPlayer.AddItem(unpack(tbRandomItem))
  local nKind = 1
  if tbRandomItem[4] > 1 then
    nKind = 2
  end
  StatLog:WriteStatLog("stat_info", "sizhounian_2012", "jizika_get", pPlayer.nId, string.format("%s,5", nKind))

  if not pItem then
    Dbg:WriteLog("ZhouNianQing2012", "AddZiKa_XiaoTianDeng", "AddZiKaFailed", pPlayer.szName, unpack(tbRandomItem))
    return 0
  end
  pItem.Bind(1)
  pItem.Sync()
end

function ZhouNianQing2012:AddZiKa_HeBiEvent(pPlayer)
  if not pPlayer then
    return 0
  end
  self:UpdateZiKaCount(pPlayer)
  local nFlag, szError = self:IsCanAddZiKa(pPlayer)
  if 1 ~= nFlag then
    return 0
  end
  local tbRandomItem = self:GetMyRandomItem(self.tbRandom_HeBiKa)
  if not tbRandomItem then
    return 0
  end
  local nCount = self:GetZiKaCount(pPlayer)
  self:SetZiKaCount(pPlayer, nCount + 1)
  local pItem = pPlayer.AddItem(unpack(tbRandomItem))
  local nKind = 1
  if tbRandomItem[4] > 1 then
    nKind = 2
  end
  StatLog:WriteStatLog("stat_info", "sizhounian_2012", "jizika_get", pPlayer.nId, string.format("%s,6", nKind))
  if not pItem then
    Dbg:WriteLog("ZhouNianQing2012", "AddZiKa_HeBiEvent", "AddZiKaFailed", pPlayer.szName, unpack(tbRandomItem))
    return 0
  end
  pItem.Bind(1)
  pItem.Sync()
  return 0
end

function ZhouNianQing2012:GetMyRandomItem(tbRandomItemList)
  if not tbRandomItemList then
    return
  end
  local nRand = MathRandom(1, self.nMaxRandomNum)
  local nPro = 0
  for _, tbInfo in pairs(tbRandomItemList) do
    nPro = nPro + tbInfo[1]
    if nRand <= nPro then
      return tbInfo[2]
    end
  end
  return tbItem
end

function ZhouNianQing2012:ChangeRandomFeature(pPlayer)
  if not pPlayer then
    return 0
  end
  local nSkillLevel = MathRandom(1, self.nChangeMaxLevel)
  pPlayer.AddSkillState(self.nChangeSkillId, nSkillLevel, 0, self.nChangeTime * 18, 1, 1)
  return 1
end

function ZhouNianQing2012:OnAddZhouNianQingTeShi()
  for _, tbInfo in pairs(self.tbTeShiPos) do
    if SubWorldID2Idx(tbInfo[1]) > 0 then
      local pNpc = KNpc.Add2(self.nTeShiNpcId, 90, -1, tbInfo[1], tbInfo[2], tbInfo[3])
    end
  end
end

function ZhouNianQing2012:OnAddZhouNianQingDaTianDeng()
  for _, tbInfo in pairs(self.tbDaTianDengPos) do
    if SubWorldID2Idx(tbInfo[1]) > 0 then
      local pNpc = KNpc.Add2(self.nDaTianDengNpcId, 90, -1, tbInfo[1], tbInfo[2], tbInfo[3])
    end
  end
end

function ZhouNianQing2012:GetRandomItem(pPlayer, nIndex)
  local tbRandomItem = self.tbRandomAward_YanHua[nIndex]
  if not tbRandomItem then
    return 0
  end
  local nRandom = MathRandom(1, self.nMaxRandomNum)
  local nTotalRandom = 0
  local nGiveRandomItem = 0
  for i, tbInfo in ipairs(tbRandomItem) do
    nTotalRandom = nTotalRandom + tbInfo[1]
    if tbInfo[1] == 0 then
      self:AwardFun(pPlayer, tbInfo)
    elseif nGiveRandomItem ~= 1 and nRandom <= nTotalRandom then
      self:AwardFun(pPlayer, tbInfo)
      nGiveRandomItem = 1
    end
  end
  return 1
end

function ZhouNianQing2012:AwardFun(pPlayer, tbInfo)
  if "bindcoin" == tbInfo[2] then
    local nAddCoin = pPlayer.AddBindCoin(tbInfo[3], Player.emKBINDCOIN_ADD_RANDOM_ITEM) -- 只会加绑金
    local szAnnouce = string.format("恭喜您获得了<color=yellow>%s<color>绑定%s", tbInfo[3], IVER_g_szCoinName)
    pPlayer.Msg(szAnnouce)
    StatLog:WriteStatLog("stat_info", "sizhounian_2012", "yanhuo_fire", pPlayer.nId, string.format("BindCoin,%s", tbInfo[3]))
    if nAddCoin == 1 then
      Dbg:WriteLog("ZhouNianQing2012", "AwardFun", string.format("%s,%s,%s,%s", "bindcoin", pPlayer.szName, "success", tbInfo[3]))
    else
      Dbg:WriteLog("ZhouNianQing2012", "AwardFun", string.format("%s,%s,%s,%s", "bindcoin", pPlayer.szName, "failed", tbInfo[3]))
    end
  elseif "baseexp" == tbInfo[2] then
    local nExp = me.GetBaseAwardExp() * tbInfo[3]
    pPlayer.AddExp(nExp)
    local szAnnouce = string.format("恭喜您获得了<color=yellow>%s<color>经验", nExp)
    pPlayer.Msg(szAnnouce)
    Dbg:WriteLog("ZhouNianQing2012", "AwardFun", string.format("%s,%s,%s,%s", "baseexp", pPlayer.szName, "success", nExp))
  end
end

-- 双人合璧活动
function ZhouNianQing2012:IsHaveDoubleBi(pPlayer)
  for nIndex, tbItem in pairs(self.tbDoubleBi) do
    local tbResult = pPlayer.FindItemInBags(unpack(tbItem))
    if #tbResult > 0 then
      return nIndex
    end
  end
  return 0
end

function ZhouNianQing2012:IsCanHaveBi(pPlayer)
  local nNowTime = GetTime()
  local nLastHeBiTime = self:GetHeBiTime(pPlayer)
  local nLastHeBiDay = Lib:GetLocalDay(nLastHeBiTime)
  local nNowDay = Lib:GetLocalDay(nNowTime)
  if nNowDay ~= nLastHeBiDay then
    self:SetHeBiTime(pPlayer, nNowTime)
    self:SetHeBiCount(pPlayer, 0)
  end

  local nHeBiCount = self:GetHeBiCount(pPlayer)
  if nHeBiCount >= self.MAX_HEBI_COUNT then
    return 0
  end
  return 1
end

function ZhouNianQing2012:OnGSStartEvent()
  --	self:OnAddZhouNianQingTeShi();
  --	self:OnAddZhouNianQingDaTianDeng();
end

ZhouNianQing2012:LoadXiaoTianDengPos()
--ServerEvent:RegisterServerStartFunc(ZhouNianQing2012.OnGSStartEvent, ZhouNianQing2012);
