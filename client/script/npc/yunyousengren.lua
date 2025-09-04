-- 云游僧人

local tbYunyousengren = Npc:GetClass("yunyousengren")

tbYunyousengren.nDelayTime = 5 -- 进度条延时的时间为5(秒)
tbYunyousengren.tbTaskIdUsedCount = { 2007, 1 } -- 一天里使用的慈悲心经的数量的任务变量的Id
tbYunyousengren.tbCibeiItem = { -- 慈悲心经
  ["nGenre"] = 18,
  ["nDetailType"] = 1,
  ["nParticularType"] = 18,
  ["nLevel"] = 1,
}
tbYunyousengren.tbProbability = { -- 每天使用地慈悲心经的数目对应的概率
  100,
  80,
  70,
  60,
  50,
  40,
  30,
}

function tbYunyousengren:OnDialog()
  local tbCibeixinjing = Item:GetClass("cibeixinjing")
  local tbOpt = {
    { "我要忏悔罪过，降低恶名", self.Repent, self },
    { "结束对话" },
  }
  Dialog:Say(him.szName .. "：我近年来云游四方，诵经讲法，唯愿度化信众，涤荡罪孽，普渡众生，以证我佛慈悲之道。", tbOpt)
end

-- 忏悔
function tbYunyousengren:Repent()
  -- 临时判断特殊地图限制
  local nCurMapId = me.GetMapId()
  if (nCurMapId >= 167 and nCurMapId <= 180) or (nCurMapId >= 187 and nCurMapId <= 195) then
    me.Msg("此地禁止使用该物品。")
    return 0
  end
  -- 恶名值为0,不需要忏悔
  if 0 >= me.nPKValue then
    Dialog:Say("施主并无恶名在身，不需诵经忏悔。")
    return
  end
  -- 经验达到或超过-50%,不允许忏悔
  local nExpPercent = math.floor(me.GetExp() * -100 / me.GetUpLevelExp())
  if nExpPercent > 50 then
    Dialog:Say(him.szName .. "：你的负经验目前超过50%，忏悔罪过也只是无用之功，还是以后再来吧！")
    return
  end
  -- 没有慈悲心经，不能忏悔
  if me.GetItemCountInBags(self.tbCibeiItem.nGenre, self.tbCibeiItem.nDetailType, self.tbCibeiItem.nParticularType, self.tbCibeiItem.nLevel) <= 0 then
    Dialog:Say(him.szName .. "：施主身上并无经文，还是速速取来《慈悲心经》重新诵读为好。")
    return
  end

  Dialog:Say(him.szName .. "：施主需要虔诚诵读《慈悲心经》，忏悔自身罪孽，心怀善意，自然可以降低恶名。你现在要开始诵读经文吗？", {
    { "我要诵读《慈悲心经》", self.DelayTime, self },
    { "我过一会再来" },
  })
end

-- self.nDelayTime(秒)的延时
function tbYunyousengren:DelayTime()
  local tbEvent = {
    Player.ProcessBreakEvent.emEVENT_MOVE,
    Player.ProcessBreakEvent.emEVENT_ATTACK,
    Player.ProcessBreakEvent.emEVENT_SIT,
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
  GeneralProcess:StartProcess("正在诵读慈悲心经...", self.nDelayTime * Env.GAME_FPS, { self.UseItem, self }, nil, tbEvent)
end

function tbYunyousengren:UseItem()
  if me.ConsumeItemInBags(1, self.tbCibeiItem.nGenre, self.tbCibeiItem.nDetailType, self.tbCibeiItem.nParticularType, self.tbCibeiItem.nLevel) ~= 0 then
    Dbg:WriteLogEx(Dbg.LOG_ERROR, "tbYunyousengren", "cibeixinjing not found！")
    return
  end

  local nReadedAmount = me.GetTask(self.tbTaskIdUsedCount[1], self.tbTaskIdUsedCount[2]) + 1 -- 获得任务变量的值
  me.SetTask(self.tbTaskIdUsedCount[1], self.tbTaskIdUsedCount[2], nReadedAmount) -- 每使用一个慈悲心经，记录每天使用次数的任务变量要加1

  local nProbability = 0 -- 概率（如果成功率是20%，nProbability的值为20）
  if nReadedAmount > #self.tbProbability then
    nProbability = self.tbProbability[#self.tbProbability]
  else
    nProbability = self.tbProbability[nReadedAmount]
  end

  if math.random(100) <= nProbability then
    me.AddPkValue(-1)
    me.Msg("你虔诚诵读《慈悲心经》，心中善意大盛，深悔旧日罪过，恶名值降低1点！")
  else
    me.Msg("你诵读了1篇《慈悲心经》，心中杀意未减，毫无任何效果！")
  end
end
