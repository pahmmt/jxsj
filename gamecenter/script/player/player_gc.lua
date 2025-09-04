-- Player GC脚本

-- 帮会商店GC回调
function Player:Buy_GC(nCurrencyType, nCost, nEnergyCost, dwTongId, nSelfKinId, nSelfMemberId, nPlayerId, nBuy, nBuyIndex, nCount)
  local cTong = KTong.GetTong(dwTongId)
  if not cTong then
    return 0
  end

  if nCurrencyType == 9 then
    local nEnergy = cTong.GetEnergy()
    local nEnergyLeft = nEnergy - nEnergyCost * nCount
    if nEnergyLeft < 0 then
      return 0
    end
    if Tong:CostBuildFund_GC(dwTongId, nSelfKinId, nSelfMemberId, nCost * nCount, 0) ~= 1 then
      return 0
    end
    cTong.SetEnergy(nEnergyLeft)
    GlobalExcute({ "Player:Buy_GS2", nCurrencyType, dwTongId, nPlayerId, nBuy, nBuyIndex, nCost, nEnergyLeft, nCount })
  end
end

-- 跨区服数据同步_全局GC
function Player:Gb_DataSync_GC(szName, nValue)
  local nPlayerId = KGCPlayer.GetPlayerIdByName(szName)
  if nPlayerId and nValue and GLOBAL_AGENT then
    -- 如果是全局GC，则广播给各个普通GC
    local nConnetId = KGCPlayer.OptGetTask(nPlayerId, KGCPlayer.TSK_CONNET_ID)
    if nConnetId > 0 then
      GlobalGCExcute(nConnetId, { "Player:Nor_DataSync_GC", szName, nValue })
    else
      GlobalGCExcute(-1, { "Player:Nor_DataSync_GC", szName, nValue })
    end
  end
end

-- 跨区服数据同步_普通GC
function Player:Nor_DataSync_GC(szName, nValue)
  local nPlayerId = KGCPlayer.GetPlayerIdByName(szName)
  if nPlayerId and nValue then
    local nCurrentMoney = KGCPlayer.OptGetTask(nPlayerId, KGCPlayer.TSK_CURRENCY_MONEY)
    nCurrentMoney = nCurrentMoney + nValue
    KGCPlayer.OptSetTask(nPlayerId, KGCPlayer.TSK_CURRENCY_MONEY, nCurrentMoney)
    Dbg:WriteLog("Nor_DataSync_GC", szName, nValue, KGCPlayer.OptGetTask(nPlayerId, KGCPlayer.TSK_CURRENCY_MONEY))
    GlobalExcute({ "Player:DataSync_GS2", szName, nCurrentMoney })
  end
end

function Player:CollectGatesInfo_GC(tbGatesInfo)
  local tbBuff = GetGblIntBuf(GBLINTBUF_NAMESERER_MODIFY, 0) or {}

  -- 理论上一个GC只有一个正确的网关名
  assert(Lib:CountTB(tbGatesInfo) <= 1)

  for szCorrectGates, tbInfo in pairs(tbGatesInfo) do
    tbBuff[szCorrectGates] = tbBuff[szCorrectGates] or {}
    for szGate, _ in pairs(tbInfo) do
      if not tbBuff[szCorrectGates][szGate] then
        tbBuff[szCorrectGates][szGate] = 1
      end
    end
  end

  --assert(Lib:CountTB(tbBuff) <= 1);
  SetGblIntBuf(GBLINTBUF_NAMESERER_MODIFY, 0, 1, tbBuff)
end

function Player:ResetAllPlayerDragonBallState_GC()
  GlobalExcute({ "Player:OnResetAllPlayerDragonBallState" })
end

function Player:OnNameServerModifyResult(key, bSucc)
  if not self.tbNameServerCallBack then
    return
  end
  local tb = self.tbNameServerCallBack[key]
  if tb then
    table.insert(tb, bSucc)
    Lib:CallBack(tb)
    self.tbNameServerCallBack[key] = nil
  end
end

function Player:InsertNameSeverResultCallBack(key, tbCallBack)
  self.tbNameServerCallBack = self.tbNameServerCallBack or {}
  self.tbNameServerCallBack[key] = tbCallBack
end

function Player:_TestResCallBack(bSucc)
  print("----Player:_TestResCallBack-----", bSucc)
end

function Player:_TestApplyModify()
  local key = ApplyModifyNameServerGate("dengyong3", "dengyong", "")
  self:InsertNameSeverResultCallBack(key, { "Player:_TestResCallBack" })
end

function Player:UpdateCoZoneRefreshPlayerGateWayCallBack(bSucc) end

function Player:UpdateCoZoneRefreshPlayerGateWay()
  local nGbCoZoneTime = KGblTask.SCGetDbTaskInt(DBTASK_COZONE_TIME)
  local nNowTime = GetTime()
  -- 合服七天后就不执行这条指令
  if nNowTime < nGbCoZoneTime or nNowTime >= nGbCoZoneTime + 7 * 24 * 60 * 60 then
    return 0
  end

  if not self.nUpdateCoZoneRefreshPlayerGateWayId or self.nUpdateCoZoneRefreshPlayerGateWayId <= 0 then
    self.nUpdateCoZoneRefreshPlayerGateWayId = Timer:Register(Env.GAME_FPS * 5, self.UpdateCoZoneRefreshPlayerGateWay, self)
  end

  local szSubGateWay = KGblTask.SCGetDbTaskStr(DBTASK_COZONE_SUB_ZONE_GATEWAY)
  if not szSubGateWay or szSubGateWay == "" then
    return 0
  end

  local szMainGateWay = GetGatewayName()
  if not szMainGateWay or szMainGateWay == "" then
    return 0
  end

  print("[GCEvent] start UpdateCoZoneRefreshPlayerGateWay", szSubGateWay, szMainGateWay)
  local key = ApplyModifyNameServerGate(szSubGateWay, szMainGateWay, "")
  self:InsertNameSeverResultCallBack(key, { "Player:UpdateCoZoneRefreshPlayerGateWayCallBack" })
  self.nUpdateCoZoneRefreshPlayerGateWayId = 0
  return 0
end

function Player:ApplySnsImgAddress(szDstPlayerName, nSnsId, szSrcPlayer)
  if not self.tbPlayerName2SnsIdAddress then
    self.tbPlayerName2SnsIdAddress = {}
  end

  if not self.tbPlayerName2SnsIdAddress[szSrcPlayer] then
    self.tbPlayerName2SnsIdAddress[szSrcPlayer] = {}
  end

  if not self.tbPlayerName2SnsIdAddress[szSrcPlayer][nSnsId] then
    GlobalExcute({ "Sns:ApplyPlayerImg_GS", szDstPlayerName, nSnsId, szSrcPlayer })
  else
    GlobalExcute({ "Sns:SendSnsImg", szDstPlayerName, nSnsId, szSrcPlayer, self.tbPlayerName2SnsIdAddress[szSrcPlayer][nSnsId] })
  end
end

function Player:ApplyUpdateSnsImgAddress_GC(szSrcPlayerName, nSnsId, szHttpAddress)
  if not self.tbPlayerName2SnsIdAddress then
    self.tbPlayerName2SnsIdAddress = {}
  end

  if not self.tbPlayerName2SnsIdAddress[szSrcPlayerName] then
    self.tbPlayerName2SnsIdAddress[szSrcPlayerName] = {}
  end

  self.tbPlayerName2SnsIdAddress[szSrcPlayerName][nSnsId] = szHttpAddress
end

Player.tbNameServerCallBack = {}

GCEvent:RegisterGCServerStartFunc(Player.UpdateCoZoneRefreshPlayerGateWay, Player)

function Player:OnAlterInfoResult(nPlayerId, nRes, tbAlterInfo)
  local nAlterType = tbAlterInfo[1]

  -- 最低位为1，表示改名字
  if nAlterType % 2 == 1 then -- 是要改名字的
    local szOldName = tbAlterInfo[4]
    local szNewName = tbAlterInfo[3]
    -- 修改领土雕像资格BUFF
    Domain.tbStatuary:AlterRoleName(szOldName, szNewName)

    -- 修改跨服宋金积分BUFF
    SuperBattle:AlterRoleName(szOldName, szNewName)

    -- 抽奖数据修改
    NewLottery:AlterRoleName(szOldName, szNewName)

    -- 帐号BUFF数据
    Account:AlterRoleName(szOldName, szNewName, nPlayerId)

    -- 任务发布平台BUFF
    Task.TaskExp:AlterRoleName(szOldName, szNewName)

    -- 霸主之印缴纳最多
    if KGblTask.SCGetDbTaskStr(DBTASK_BAZHUZHIYIN_MAX) == szOldName then
      KGblTask.SCSetDbTaskStr(DBTASK_BAZHUZHIYIN_MAX, szNewName)
    end
    -- 跨服联赛最多投票数
    if KGblTask.SCGetDbTaskStr(DBTASD_GBWLLS_GUESS_MAX_TICKET) == szOldName then
      KGblTask.SCSetDbTaskStr(DBTASD_GBWLLS_GUESS_MAX_TICKET, szNewName)
    end
    -- 新坐骑所属者
    if KGblTask.SCGetDbTaskStr(DBTASK_NEW_HORSE_OWNER) == szOldName then
      KGblTask.SCSetDbTaskStr(DBTASK_NEW_HORSE_OWNER, szNewName)
    end

    -- 离开联赛战队
    local szLeagueName = League:GetMemberLeague(Wlls.LGTYPE, szOldName)
    if szLeagueName then
      local nGameLevel = League:GetLeagueTask(Wlls.LGTYPE, szLeagueName, Wlls.LGTASK_MLEVEL)
      Wlls:LeaveLeague(szOldName, nGameLevel)
    end

    -- 记录角色改名历史
    if not GLOBAL_AGENT then
      Globalstat:Collect("PlayerAlter", "AlterName", KGCPlayer.GetPlayerAccount(nPlayerId), szOldName, { szNewName })
    end
  end
end

function Player:GetGlobalLoginState_Normal(nPlayerId)
  return KGCPlayer.GetPlayerGlobalLoginState_Normal(nPlayerId)
end

function Player:ClearPlayerGlobalLoginState_Normal_GC()
  KGCPlayer.ClearGlobalPlayerLoginStateKinTongCount_Normal()
  KGCPlayer.ClearGlobalPlayerLoginState_Normal()
  GlobalExcute({ "Player:ClearPlayerGlobalLoginState_Normal_GS" })
end

function Player:Login_GlobalServer_Normal_GC(nPlayerId, dwTongId, dwKinId)
  self:SetGlobalLoginState_Normal_GC(nPlayerId, self.nGlobalLoginState_Login)
  self:AddGlobalPlayerKinTong_Normal_GC(dwTongId, dwKinId)
end

function Player:Logout_GlobalServer_Normal_GC(nPlayerId, dwTongId, dwKinId)
  self:SetGlobalLoginState_Normal_GC(nPlayerId, self.nGlobalLoginState_Logout)
  self:DelGlobalPlayerKinTong_Normal_GC(dwTongId, dwKinId)
end

function Player:SetGlobalLoginState_Normal_GC(nPlayerId, nState)
  KGCPlayer.SetPlayerGlobalLoginState_Normal(nPlayerId, nState)
  GlobalExcute({ "Player:SetGlobalLoginState_Normal_GS", nPlayerId, nState })
end

function Player:DelGlobalPlayerKinTong_Normal_GC(dwTongId, dwKinId)
  KGCPlayer.DelPlayerGlobalLoginKinCount_Normal(dwKinId, 1)
  KGCPlayer.DelPlayerGlobalLoginTongCount_Normal(dwTongId, 1)
end

function Player:AddGlobalPlayerKinTong_Normal_GC(dwTongId, dwKinId)
  KGCPlayer.AddPlayerGlobalLoginKinCount_Normal(dwKinId, 1)
  KGCPlayer.AddPlayerGlobalLoginTongCount_Normal(dwTongId, 1)
end

function Player:Login_GlobalServer_Global_GC(szGateway, nPlayerId, szTongName, szKinName)
  KGCPlayer.ProcessGlobalPlayerLogin_Global(szGateway, nPlayerId, szTongName, szKinName)
  GlobalExcute({ "Player:Login_GlobalServer_Global_GS", szGateway, nPlayerId, szTongName, szKinName })
  ChannelQuery_GC(nPlayerId)
end

function Player:Logout_GlobalServer_Global_GC(nPlayerId)
  KGCPlayer.ProcessGlobalPlayerLogout_Global(nPlayerId)
  GlobalExcute({ "Player:Logout_GlobalServer_Global_GS", nPlayerId })
end

function Player:UpdatePlayerKinInTong_Global_GC(szGateway, szTongName, szKinName)
  --全局服调整家族和帮会关系
  KGCPlayer.UpdateGlobaPlayerKinInTong(szGateway, szTongName, szKinName)
  GlobalExcute({ "Player:UpdatePlayerKinInTong_Global_GS", szGateway, szTongName, szKinName })
end

Player.tbNameServerCallBack = {}

GCEvent:RegisterGCServerStartFunc(Player.UpdateCoZoneRefreshPlayerGateWay, Player)
