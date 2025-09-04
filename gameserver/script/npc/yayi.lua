-- 衙役

local tbNpc = Npc:GetClass("yayi")

tbNpc.nLinanYayiId = 29 -- 临安府衙役的地图ID
tbNpc.nBianjingYayiId = 23 -- 汴京府衙役的地图ID
tbNpc.nYayiX_Linan = 1688 -- 临安府衙役的X坐标
tbNpc.nYayiY_Linan = 3771 -- 临安府衙役的Y坐标
tbNpc.nYayiX_Bianjing = 1639 -- 汴京府衙役的X坐标
tbNpc.nYayiY_Bianjing = 3094 -- 汴京府衙役的Y坐标

tbNpc.nLinanDalaoId = 223 -- 临安府大牢的地图ID
tbNpc.nBianjingDalaoId = 222 -- 汴京府大牢的地图ID
tbNpc.nDalaoX = 1651 -- 大牢的X坐标
tbNpc.nDalaoY = 3260 -- 大牢的Y坐标

function tbNpc:OnDialog()
  Dialog:Say("衙门最近多了不少捕快，四处捉拿杀人越货的凶徒，这世道现在倒有些不太平了！", {
    { "我来自首", self.Zishou, self },
    { "没什么事了" },
  })
end

-- 玩家自首,与衙役的对话
function tbNpc:Zishou()
  local nExpPercent = math.floor(me.GetExp() * -100 / me.GetUpLevelExp())

  -- 恶名值不大于0,不用坐牢
  if me.nPKValue <= 0 then
    Dialog:Say("玩家：日前我曾经不小心误伤他人，特来自首。<enter><enter>" .. "衙役：我家大人已派人巡查，认为你那属于正常防卫，只要下次小心一些，不必太过自责。你去吧。")
    return
  end
  -- 异常情况下越狱了
  if me.GetTempTable("Npc").nNpcYuzuTimerId ~= nil then
    Dialog:Say("衙役：你尚未赎清罪孽，还是回大牢继续反省吧！")
    self:TransferPos(me.GetMapId(), me)
    return
  end
  -- 负经验值低于50%
  if nExpPercent > 50 then
    me.Msg("朝廷有令：负经验超过50%者，不允许自首赎罪！")
    Dialog:Say("衙役：象你这样血债累累的惯犯还想自首赎罪？哼哼，等着被人追杀吧！")
    return
  end
  Dialog:Say("玩家：日前我曾经不小心误伤他人，特来认罪，还望大人从轻发落", { "继续对话", self.FollowWithYayiDialog, self })
end

-- 自首的玩家和衙役继续对话
function tbNpc:FollowWithYayiDialog()
  local tbNpcYuzu = Npc:GetClass("yuzu")
  local nReduceOnePkHour, nSumTimer = tbNpcYuzu:OnePkTime(me.nPKValue)
  local szXiaoshi, szShichen = Lib:GetCnTime(nSumTimer)
  local szMsg = string.format("衙役：你双手沾有血腥，必须经过官府判决，自己在大牢之中静心悔过方可赎罪。鉴于你诚心悔过，俯首认罪，判决如下：%s当前恶名值为：%s，须关押在大牢之中静心悔过共计：%s。", me.szName, me.nPKValue, szXiaoshi)
  Dialog:Say(szMsg, {
    { "俯首认罪，进入大牢", self.Renzui, self },
    { "就地潜逃" },
  })
end

-- 认罪
function tbNpc:Renzui()
  local tbNpcYuzu = Npc:GetClass("yuzu")
  me.SetTask(tbNpcYuzu.tbTaskIdReduceOnePkSec[1], tbNpcYuzu.tbTaskIdReduceOnePkSec[2], 0)
  self:TransferPos(me.GetMapId(), me)
end

function tbNpc:TransferPos(nMapId, pPlayer)
  if nMapId == self.nLinanYayiId then -- 从临安府衙役处进大牢
    pPlayer.NewWorld(self.nLinanDalaoId, self.nDalaoX, self.nDalaoY)
  elseif nMapId == self.nBianjingYayiId then -- 从汴京府衙役处进大牢
    pPlayer.NewWorld(self.nBianjingDalaoId, self.nDalaoX, self.nDalaoY)
  elseif nMapId == self.nLinanDalaoId then -- 从临安府大牢处出来至临安符的衙役处
    pPlayer.NewWorld(self.nLinanYayiId, self.nYayiX_Linan, self.nYayiY_Linan)
  else -- 从汴京府大牢处出来至汴京府的衙役处
    pPlayer.NewWorld(self.nBianjingYayiId, self.nYayiX_Bianjing, self.nYayiY_Bianjing)
  end

  me.SetFightState(0)
end
