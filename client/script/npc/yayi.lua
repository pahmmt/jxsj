-- 衙役

local tbNpc = Npc:GetClass("yayi")

tbNpc.nHuiluMoney = 5000 -- 贿赂的银两

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
    --					{"我来探监", self.Tanjian, self},
    { "没什么事了" },
  })
end

-- 玩家自首,与衙役的对话
function tbNpc:Zishou()
  local nExpPercent = math.floor(me.GetExp() * -100 / me.GetUpLevelExp())

  if me.nPKValue <= 0 then -- 恶名值不大于0,不用坐牢
    Dialog:Say("玩家：日前我曾经不小心误伤他人，特来自首。<enter><enter>" .. "衙役：我家大人已派人巡查，认为你那属于正常防卫，只要下次小心一些，不必太过自责。你去吧。")
    return
  end

  if me.GetTempTable("Npc").nNpcYuzuTimerId ~= nil then -- 异常情况下越狱了
    Dialog:Say("衙役：你尚未赎清罪孽，还是回大牢继续反省吧！")
    self:TransferPos(me.GetMapId(), me)
    return
  end

  if nExpPercent > 50 then -- 负经验值低于50%
    me.Msg("朝廷有令：负经验超过50%者，不允许自首赎罪！")
    Dialog:Say("衙役：象你这样血债累累的惯犯还想自首赎罪？哼哼，等着被人追杀吧！")
    return
  end

  Dialog:Say("玩家：日前我曾经不小心误伤他人，特来认罪，还望大人从轻发落", { "继续对话", self.FollowWithYayiDialog, self })
end

-- 自首的玩家和衙役继续对话
function tbNpc:FollowWithYayiDialog()
  local tbNpcYuzu = Npc:GetClass("yuzu")
  local nReduceOnePkHour, nSumHourTime = tbNpcYuzu:OnePkTime(me.nPKValue) -- nReduceOnePkHour表示当前Pk值降低一点所需要的时间(小时); nSumHourTime表示自首玩家要坐牢的时间(小时)
  local szXiaoshi, szShichen = Lib:GetCnTime(nSumHourTime)
  local szMsg = string.format("衙役：你双手沾有血腥，必须经过官府判决，自己在大牢之中静心悔过方可赎罪。鉴于你诚心悔过，俯首认罪，判决如下：%s当前恶名值为：%s，须关押在大牢之中静心悔过共计：%s。", me.szName, me.nPKValue, szXiaoshi)
  Dialog:Say(szMsg, {
    { "俯首认罪，进入大牢", self.Renzui, self, math.floor(nReduceOnePkHour * 3600) },
    { "就地潜逃" },
  })
end

-- 认罪
function tbNpc:Renzui(nReduceOnePkSec)
  local tbNpcYuzu = Npc:GetClass("yuzu")
  local nTime = math.floor(nReduceOnePkSec)
  tbNpcYuzu:StartPrison(nTime)
  self:TransferPos(me.GetMapId(), me)
end

-- 探监
function tbNpc:Tanjian()
  Dialog:Say("衙役：衙门重地，闲人退散！这里面都是官府捉拿的要犯，探什么探，是不是同党啊！", {
    { "贿赂" .. self.nHuiluMoney .. "两银子", self.Huilu, self },
    { "走开" },
  })
end

-- 贿赂
function tbNpc:Huilu()
  if me.CostMoney(self.nHuiluMoney) == 1 then
    local tbNpcYuzu = Npc:GetClass("yuzu")
    me.SetTask(tbNpcYuzu.tbTaskIdTanjian[1], tbNpcYuzu.tbTaskIdTanjian[2], 1)
    me.Msg("贿赂衙役" .. tbNpc.nHuiluMoney .. "两银子，进入大牢探监！")
    Dialog:Say("衙役：你说什么？原来你的朋友在牢里生病了？既然这样，那你去探望一下也算是人之常情吧。记住不要做什么偷偷摸摸的勾当啊。")

    self:TransferPos(me.GetMapId(), me)
  else
    Dialog:Say("衙役：快走开！探什么探！是不是一定要我把你当凶犯同党抓进去才高兴！")
  end
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
