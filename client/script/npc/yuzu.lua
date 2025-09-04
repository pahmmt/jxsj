-- 狱卒

local tbNpc = Npc:GetClass("yuzu")

tbNpc.tbTaskIdTanjian = { 2000, 1 } -- 进入大牢的玩家的探监状态的任务变量的id
tbNpc.tbTaskIdReduceOnePkSec = { 2000, 2 } -- 洗一点Pk的剩余时间的任务变量的Id
tbNpc.tbLingpai = { -- 刑部令牌
  ["nGenre"] = 18,
  ["nDetailType"] = 1,
  ["nParticularType"] = 17,
  ["nLevel"] = 1,
}

function tbNpc:OnDialog()
  if self:IsTanjian(me) ~= 1 then -- 来的是自首玩家
    self:ZishouPlayerWithYuzu()
  else
    self:TanjianPlayerWithYuzu() -- 来的是探监玩家
  end
end

-- 自首玩家和狱卒的对话
function tbNpc:ZishouPlayerWithYuzu()
  if me.nPKValue > 0 then
    Dialog:Say("狱卒：罪孽未清之犯人，不得随意走动！", {
      { "询问当前时辰", self.ZishouAskTime, self },
      { "出示刑部令牌,离开大牢", self.ShowLingpai, self, me },
      { "马上回去坐好" },
    })
  else
    me.Msg("在深刻反省之后，你终于被释放出狱。")
    Dialog:Say("狱卒：你！收拾收拾行李，已经可以出狱了！\n\n玩家：多谢狱卒大哥，那么我就走了！", {
      { "确定", self.LeavePrison, self, me },
      { "结束对话" },
    })
  end
end

-- 自首的玩家向狱卒询问时间
function tbNpc:ZishouAskTime()
  local tbTmp = me.GetTempTable("Npc")
  local nRestReduceOnePkSec = Timer:GetRestTime(tbTmp.nNpcYuzuTimerId) / Env.GAME_FPS
  local nHour, nMin, nSec = Lib:TransferSecond2NormalTime(nRestReduceOnePkSec)
  me.Msg("要降低1点恶名值还需" .. nHour .. "小时" .. nMin .. "分" .. nSec .. "秒！")
  Dialog:Say("玩家：这位大哥，我想问一下现在是什么时辰了?\n\n狱卒：你想要减低1点恶名值，都还差" .. nHour .. "小时" .. nMin .. "分" .. nSec .. "秒，赶紧回去坐好！")
end

-- 坐牢的玩家出示令牌
function tbNpc:ShowLingpai(pPlayer)
  -- 没有令牌
  if pPlayer.GetItemCountInBags(self.tbLingpai.nGenre, self.tbLingpai.nDetailType, self.tbLingpai.nParticularType, self.tbLingpai.nLevel) <= 0 then
    Dialog:Say("狱卒：你根本就没有刑部令牌，居然敢来戏耍本大爷，还不滚开！")
    return
  end

  Dialog:Say("狱卒：果然是刑部令牌，之前多有得罪，还望大侠多多包涵！您现在要离开大牢吗？", {
    { "离开大牢", self.LeavePrisonByLingpai, self, pPlayer },
    { "容我再考虑一下" },
  })
end

function tbNpc:LeavePrisonByLingpai(pPlayer)
  if pPlayer.ConsumeItemInBags(1, self.tbLingpai.nGenre, self.tbLingpai.nDetailType, self.tbLingpai.nParticularType, self.tbLingpai.nLevel) ~= 0 then -- 删除一块令牌失败，记录错误，处理并停止逻辑
    pPlayer.Msg("删除刑部令牌失败！")
    return
  end
  pPlayer.Msg(pPlayer.szName .. "使用了刑部令牌，离开大牢！")
  self:LeavePrison(pPlayer)
end

-- 探监的玩家和狱卒对话
function tbNpc:TanjianPlayerWithYuzu()
  Dialog:Say("狱卒：探望好了没有，快点走吧！", {
    { "多谢狱卒大哥成全，我这就走", self.LeavePrison, self, me },
    { "还请狱卒大哥多担待，我再待会" },
  })
end

function tbNpc:IsTanjian(pPlayer)
  return pPlayer.GetTask(self.tbTaskIdTanjian[1], self.tbTaskIdTanjian[2])
end

function tbNpc:StartPrison(nReduceOnePkSec)
  if self:IsTanjian(me) ~= 1 then
    local tbTmp = me.GetTempTable("Npc")
    tbTmp.nNpcYuzuTimerId = Timer:Register(nReduceOnePkSec * Env.GAME_FPS, self.OnTimer, self, me.nId)
    tbTmp.nNpcYuzuLogoutId = PlayerEvent:Register("OnLogout", self.OnLogout, self)
  end
end

function tbNpc:StopPrison(pPlayer)
  if self:IsTanjian(pPlayer) ~= 1 then
    local tbTmp = pPlayer.GetTempTable("Npc")
    if tbTmp.nNpcYuzuTimerId then
      Timer:Close(tbTmp.nNpcYuzuTimerId)
      tbTmp.nNpcYuzuTimerId = nil
    end
    PlayerEvent:UnRegister("OnLogout", tbTmp.nNpcYuzuLogoutId)
  end
end

function tbNpc:LeavePrison(pPlayer)
  local tbNpcYayi = Npc:GetClass("yayi")
  self:StopPrison(pPlayer)
  me.SetTask(self.tbTaskIdTanjian[1], self.tbTaskIdTanjian[2], 0)
  tbNpcYayi:TransferPos(pPlayer.GetMapId(), pPlayer)
end

function tbNpc:OnLogin()
  local nRestReduceOnePkSec = me.GetTask(self.tbTaskIdReduceOnePkSec[1], self.tbTaskIdReduceOnePkSec[2])
  if nRestReduceOnePkSec == 0 then
    return
  end
  me.SetTask(self.tbTaskIdReduceOnePkSec[1], self.tbTaskIdReduceOnePkSec[2], 0)
  self:StartPrison(nRestReduceOnePkSec)
end

function tbNpc:OnLogout()
  local tbTmp = me.GetTempTable("Npc")
  if tbTmp.nNpcYuzuTimerId then
    local nRestReduceOnePkSec = Timer:GetRestTime(tbTmp.nNpcYuzuTimerId) / Env.GAME_FPS
    me.SetTask(self.tbTaskIdReduceOnePkSec[1], self.tbTaskIdReduceOnePkSec[2], nRestReduceOnePkSec)
  end
  self:StopPrison(me)
end

-- Pk值到达某一点时,每降低一点所需要的时间
function tbNpc:OnePkTime(nPkValue)
  if nPkValue == 0 then
    return 0, 0
  end
  local tbReducePkTime = -- 分成几段来消Pk值, 得到Pk值中每降低1点所需要的时间(小时)
    {
      { 7, 2 }, -- Pk值大于7的时候,每降低1点需要2小时
      { 4, 1 }, -- Pk值大于4, 并且小于等于7的时候,每降低1点需要1小时
      { 0, 0.5 }, -- Pk值大于0, 并且小于等于4的时候,每降低1点需要0.5小时
    }
  local nReduceOnePkHour = 0
  local nSumHourTime = 0

  for i = 1, #tbReducePkTime do
    if nPkValue > tbReducePkTime[i][1] then
      nSumHourTime = nSumHourTime + (nPkValue - tbReducePkTime[i][1]) * tbReducePkTime[i][2]
      nPkValue = tbReducePkTime[i][1]
      if nReduceOnePkHour == 0 then
        nReduceOnePkHour = tbReducePkTime[i][2]
      end
    end
  end

  return nReduceOnePkHour, nSumHourTime
end

function tbNpc:OnTimer(nPlayerId) -- 时间到会调用此函数
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return
  end
  pPlayer.AddPkValue(-1)
  if pPlayer.nPKValue <= 0 then -- 返回0，表示要关闭此Timer
    local tbTmp = me.GetTempTable("Npc")
    tbTmp.nNpcYuzuTimerId = nil
    return 0
  end
  return math.floor(3600 * self:OnePkTime(pPlayer.nPKValue) * Env.GAME_FPS)
end
