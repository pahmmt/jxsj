-- 文件名　：zhounianqing2012_gc.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-09-24 16:15:44
-- 描述：四周年庆-抽奖

if not MODULE_GC_SERVER then
  return
end

Require("\\script\\event\\specialevent\\zhounianqing_lottory2012\\zhounianqing2012_def.lua")

SpecialEvent.tbZhouNianQing2012 = SpecialEvent.tbZhouNianQing2012 or {}
local tbZhouNianQing2012 = SpecialEvent.tbZhouNianQing2012

--判断邀请个数和领奖个数
function tbZhouNianQing2012:OnIniviteAward(szAccount, szPlayerName)
  --Gc做玩家邀请个数的校验
  if not self.tbInvitePlayerCount[szAccount] then
    GlobalExcute({ "SpecialEvent.tbZhouNianQing2012:OnIniviteAwardFailed", szAccount, szPlayerName })
    return
  end
  local nAccountFlag = Account:GetIntValue(szAccount, "Account.IniviteFlag")
  local nIniviteCount = math.floor(nAccountFlag / 10)
  if self.tbInvitePlayerCount[szAccount] <= nIniviteCount then
    GlobalExcute({ "SpecialEvent.tbZhouNianQing2012:OnIniviteAwardFailed", szAccount, szPlayerName, 1 })
    return
  end
  GlobalExcute({ "SpecialEvent.tbZhouNianQing2012:OnIniviteAwardEx", szAccount, szPlayerName, self.tbInvitePlayerCount[szAccount] })
  return 1
end

--提示邀请奖励领取
function tbZhouNianQing2012:CheckIniviteAward(szAccount, szPlayerName, nIniviteCount)
  --Gc做玩家邀请个数的校验
  if not self.tbInvitePlayerCount[szAccount] then
    return
  end
  if self.tbInvitePlayerCount[szAccount] > nIniviteCount then
    SendMailGC(szPlayerName, "老友悬赏令奖励领取通知", "诚邀旧友，与之同游。恭喜侠士成功召回江湖老友，您现在可从礼官处，领取金兰嵌玉匣和“新”字卡。集齐“新剑侠世界”五张字卡，会获得庆·新剑世八宝匣和赢取iphone5等大奖的机会，参加游戏内四周年活动即可轻松获得其他字卡。")
    return
  end
  return 1
end

function tbZhouNianQing2012:CanGetHonor(nPlayerId, nItemId)
  local nGetAwardInfo = KGblTask.SCGetDbTaskInt(DBTASK_INIVITE_OTHERAWARD)
  local nDate = math.floor(nGetAwardInfo / 100)
  local nAllCount = math.fmod(nGetAwardInfo, 100)
  local nNowDate = tonumber(GetLocalDate("%y%m%d"))
  if nNowDate ~= nDate then
    nAllCount = 0
  end
  if nAllCount >= self.nMaxCount then
    GlobalExcute({ "SpecialEvent.tbZhouNianQing2012:AddRandomItem", nPlayerId, nItemId })
    return
  end
  GlobalExcute({ "SpecialEvent.tbZhouNianQing2012:AddAward", nPlayerId, nItemId })
  KGblTask.SCSetDbTaskInt(DBTASK_INIVITE_OTHERAWARD, nNowDate * 100 + nAllCount + 1)
end

--定点读取活动数值
function tbZhouNianQing2012:WriteUseCard(szAccount, szPlayerName)
  Globalstat:Collect("OldPlayerBack", "UseCard", szAccount, szPlayerName, { 1 })
end

--查询回调事件
function tbZhouNianQing2012:GlobalMsgAwardList(tbDate)
  self.tbLottoryList = {}
  local nNowDate = tonumber(GetLocalDate("%Y%m%d"))
  for i, tb in ipairs(tbDate) do
    if tb.szData and tb.szData[1] and tonumber(tb.szData[1]) == nNowDate then
      self.tbLottoryList[nNowDate] = self.tbLottoryList[nNowDate] or {}
      table.insert(self.tbLottoryList[nNowDate], { tb.szGateway, tb.szAccount, tb.szRole })
    end
  end
  --每15分钟广播一个
  if self.tbLottoryList[nNowDate] and #self.tbLottoryList[nNowDate] > 0 then
    self.Msg2WorldCount = 1
    Timer:Register(self.nMsgTime2World, self.Msg2World, self, nNowDate)
  else
    GlobalExcute({ "SpecialEvent.tbZhouNianQing2012:Msg2World2GS", 4 })
  end
end

function tbZhouNianQing2012:Msg2World(nNowDate)
  if not self.tbLottoryList[nNowDate] then
    return 0
  end
  if not self.tbLottoryList[nNowDate][self.Msg2WorldCount] then
    GlobalExcute({ "SpecialEvent.tbZhouNianQing2012:Msg2World2GS", 3 })
    Timer:Register(self.nMsgTime2World * 15, self.Msg2WorldEx, self, nNowDate)
    return 0
  end
  GlobalExcute({
    "SpecialEvent.tbZhouNianQing2012:Msg2World2GS",
    2,
    self.tbLottoryList[nNowDate][self.Msg2WorldCount][1],
    self.tbLottoryList[nNowDate][self.Msg2WorldCount][3],
    self.Msg2WorldCount,
  })
  if KGCPlayer.GetPlayerIdByName(self.tbLottoryList[nNowDate][self.Msg2WorldCount][3]) then
    SendMailGC(self.tbLottoryList[nNowDate][self.Msg2WorldCount][3], "获得iPhone5大奖通知", "洪福天降，与君共享。恭喜侠士在集字卡赢iphone5活动中赢得iphone5实物大奖，我们的客服会主动与您取得联系，告知您领奖的相关事宜，如果您的账号没有绑定手机号，或绑定手机号不能联系到您，请主动与客服取得联系，客服电话：028-85437733-1-4。")
  end
  self.Msg2WorldCount = self.Msg2WorldCount + 1
  return
end

function tbZhouNianQing2012:Msg2WorldEx(nMsgDate)
  local nNowDate = tonumber(GetLocalDate("%Y%m%d"))
  if nMsgDate ~= nNowDate then
    return 0
  end
  if not self.tbLottoryList[nNowDate] then
    return 0
  end
  local szPlayerList = ""
  for i, tb in ipairs(self.tbLottoryList[nNowDate]) do
    szPlayerList = szPlayerList .. tb[3]
    if i > 3 then
      szPlayerList = szPlayerList .. "等"
      break
    end
    if i < #self.tbLottoryList[nNowDate] then
      szPlayerList = szPlayerList .. "、"
    end
  end
  GlobalExcute({ "SpecialEvent.tbZhouNianQing2012:Msg2World2GS", 6, "", "", szPlayerList })
end

--读取邀请信息
function tbZhouNianQing2012:ReadInVitePlayerList(szFilePath)
  local tbFile = Lib:LoadTabFile(szFilePath)
  if not tbFile then
    print("【邀请老玩家】读取文件错误，文件不存在", szFilePath)
    return
  end
  local tbInvitePlayerList = {}
  local tbInvitePlayerCount = {}
  for nId, tbParam in ipairs(tbFile) do
    local szOriAccount = string.lower(tbParam.OriAccount or "")
    local szOriName = tbParam.OriName or ""
    local szInviteAccount = string.lower(tbParam.InviteAccount or "")
    local szInviteName = tbParam.InviteName or ""
    local szTime = tbParam.Time or ""
    tbInvitePlayerCount[szOriAccount] = tbInvitePlayerCount[szOriAccount] or 0
    tbInvitePlayerCount[szOriAccount] = tbInvitePlayerCount[szOriAccount] + 1
    tbInvitePlayerList[szOriAccount] = tbInvitePlayerList[szOriAccount] or {}
    table.insert(tbInvitePlayerList[szOriAccount], { szOriAccount, szOriName, szInviteAccount, szInviteName, szTime })
  end
  self.tbInvitePlayerList = tbInvitePlayerList
  self.tbInvitePlayerCount = tbInvitePlayerCount
  self:SaveBuff()
end

function SpecialEvent:OnZhounian2012_GetAwardList()
  local nNowTime = tonumber(GetLocalDate("%Y%m%d"))
  if nNowTime > self.tbZhouNianQing2012.nEndTime or nNowTime < self.tbZhouNianQing2012.nStartTime then
    return
  end
  Globalstat:Query(1, "OldPlayerBack", "AwardIphone")
  GlobalExcute({ "SpecialEvent.tbZhouNianQing2012:Msg2World2GS", 1 })
end

function SpecialEvent:OnZhounian2012_ReadyMsg(nNum)
  GlobalExcute({ "SpecialEvent.tbZhouNianQing2012:Msg2World2GS", 5, "", "", 11 - nNum })
end

--gc启动，loadbuff，注册定时事件
function tbZhouNianQing2012:ServerStartFun()
  local nNowTime = tonumber(GetLocalDate("%Y%m%d"))
  if nNowTime > self.nEndTime then
    return
  end
  local nTaskId = KScheduleTask.AddTask("SpecialEvent", "SpecialEvent", "OnZhounian2012_GetAwardList")
  KScheduleTask.RegisterTimeTask(nTaskId, 2100, 1)
  local nTaskIdEx = KScheduleTask.AddTask("SpecialEvent", "SpecialEvent", "OnZhounian2012_ReadyMsg")
  for i = 1, 10 do
    KScheduleTask.RegisterTimeTask(nTaskIdEx, 2049 + i, i)
  end
  self:LoadBuffer_GC()
end

function tbZhouNianQing2012:LoadBuffer_GC()
  local tbBuffer = GetGblIntBuf(GBLINTBUF_INIVITE_PLAYERLIST, 0)
  if tbBuffer and type(tbBuffer) == "table" then
    self.tbInvitePlayerCount = tbBuffer
  end
end

--存buff
function tbZhouNianQing2012:SaveBuff()
  SetGblIntBuf(GBLINTBUF_INIVITE_PLAYERLIST, 0, 0, self.tbInvitePlayerCount)
end

--GCEvent:RegisterGCServerStartFunc(SpecialEvent.tbZhouNianQing2012.ServerStartFun, SpecialEvent.tbZhouNianQing2012);
--注册查询数据回调
--Globalstat:RegisterGlobalStatEventCallBack("OldPlayerBack", "AwardIphone", SpecialEvent.tbZhouNianQing2012.GlobalMsgAwardList, SpecialEvent.tbZhouNianQing2012);
