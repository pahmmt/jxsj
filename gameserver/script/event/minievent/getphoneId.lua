-- 文件名　：getphoneId.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-11-08 09:06:04
-- 功能说明：收集手机号

if not MODULE_GAMESERVER then
  return
end

--app.jxsj.xoyo.com/app/api/jxsj/prize/?info=xxx&token=yyy&ct=time
--info:base64(account|rnd)  以|分割帐号和随机数
--token:md5(rnd|key)，以|分割随机数和约定密钥
--ct=time，防止表单缓存
--app.jxsj.xoyo.com/app/api/jxsj/prize/?token=[token]
--token: md5(key|account|rnd) 以|分割密钥、帐号和随机数
--key:GetphoneID

SpecialEvent.tbGetPhoneId_2012 = SpecialEvent.tbGetPhoneId_2012 or {}
local tbGetPhoneId_2012 = SpecialEvent.tbGetPhoneId_2012
tbGetPhoneId_2012.nRandomMax = 100000

tbGetPhoneId_2012.nTaskGroupId = 2214
tbGetPhoneId_2012.nTaskGetAward = 1 --获得奖励标志
tbGetPhoneId_2012.nTaskRandom = 2 --随机数
tbGetPhoneId_2012.nTaskOpenFlag = 3 --打开标志（客户端用）

tbGetPhoneId_2012.szKey = "GetphoneID"
tbGetPhoneId_2012.szUrl = "http://app.jxsj.xoyo.com/app/api/jxsj/prize/?"
tbGetPhoneId_2012.szBackUrl = "http://app.jxsj.xoyo.com/app/api/jxsj/prize/?"
tbGetPhoneId_2012.nTimerMsg = 0
tbGetPhoneId_2012.nTimerMsgEx = 15 * 3600 --公告间隔

--登陆函数
function tbGetPhoneId_2012:OnLogIn()
  if GLOBAL_AGENT then
    return
  end
  if self:CheckIsCollect() == 0 then
    return
  end
  --建号时间大于两个周就不显示了
  local nRoleCreatTime = Lib:GetDate2Time(me.GetRoleCreateDate())
  if GetTime() - nRoleCreatTime >= 14 * 24 * 3600 then
    return
  end
  local nRandom = MathRandom(self.nRandomMax)
  me.SetTask(self.nTaskGroupId, self.nTaskRandom, nRandom)
  me.SetTask(self.nTaskGroupId, self.nTaskOpenFlag, 1)
  --打开窗口
  me.CallClientScript({ "SpecialEvent.tbGetPhoneId_2012:OpenWindow", self:GetUrl(1, nRandom), nRandom })
end

--合成url
function tbGetPhoneId_2012:GetUrl(nType, nRandom)
  local szUrl = ""
  if nType == 1 then
    szUrl = self.szUrl .. "info=%s" .. "&token=" .. string.lower(StringToMD5(nRandom .. "|" .. self.szKey)) .. "&ct=" .. GetTime()
  elseif nType == 2 then
    szUrl = self.szBackUrl .. "token=" .. string.lower(StringToMD5(self.szKey .. "|" .. string.lower(me.szAccount) .. "|" .. nRandom))
  end
  return szUrl
end

--检查是不是已经收集了手机的
function tbGetPhoneId_2012:CheckIsCollect()
  local nFlag = me.GetTask(self.nTaskGroupId, self.nTaskGetAward)
  if nFlag == 1 then
    return 0
  end
  local nAccountFlag = Account:GetIntValue(me.szAccount, "GetPhoneId.Flag")
  if nAccountFlag == 1 then
    return 0
  end
  return 1
end

--检查是不是跳转的url
function tbGetPhoneId_2012:CheckRebackUrl(szBackUrl)
  local nOpenFlag = me.GetTask(self.nTaskGroupId, self.nTaskOpenFlag)
  if nOpenFlag == 0 then
    return
  end
  if self:CheckIsCollect() == 0 then
    return 0
  end

  local nRandom = me.GetTask(self.nTaskGroupId, self.nTaskRandom)
  local szUrl = self:GetUrl(2, nRandom)
  if szUrl ~= szBackUrl then
    return 0
  end
  me.AddBindCoin(3000)
  me.Msg("恭喜成功验证手机号，您获得3000绑定金币。")
  me.SetTask(self.nTaskGroupId, self.nTaskGetAward, 1)
  Account:ApplySetIntValue(me.szAccount, "GetPhoneId.Flag", 1)
  me.SetTask(self.nTaskGroupId, self.nTaskOpenFlag, 0) --客户端校验，打开的或者发协议的都直接return掉
  me.CallClientScript({ "SpecialEvent.tbGetPhoneId_2012:CloseWindow" })
  Dbg:WriteLog("SpecialEvent", "GetPhoneId", "收集手机号成功", me.szAccount, me.szName)
  if GetTime() - self.nTimerMsg > self.nTimerMsgEx then
    GlobalExcute({ "SpecialEvent.tbGetPhoneId_2012:Msg2World2", me.szName })
  end
  return 1
end

function tbGetPhoneId_2012:Msg2World2(szName)
  self.nTimerMsg = GetTime()
  local szMsg = string.format("恭喜玩家[%s]成功留下了手机号，获得了3000绑定金币。", szName)
  Dialog:GlobalNewsMsg_GS(szMsg)
  Dialog:GlobalMsg2SubWorld_GS(szMsg)
  return
end

--登陆检查是不是已经收集过了，没收集过要打开界面
PlayerEvent:RegisterGlobal("OnLoginOnly", SpecialEvent.tbGetPhoneId_2012.OnLogIn, SpecialEvent.tbGetPhoneId_2012)
