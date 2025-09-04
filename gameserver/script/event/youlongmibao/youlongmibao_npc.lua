-------------------------------------------------------
-- 文件名　：youlongmibao_npc.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2009-11-05 23:22:33
-- 文件描述：
-------------------------------------------------------

Require("\\script\\event\\youlongmibao\\youlongmibao_def.lua")

-- 九公主芊芊
local tbNpc = Npc:GetClass("qianqian_dialog")

function tbNpc:OnDialog()
  local szMsg = "喂，你是来挑战我堂堂游龙阁九公主的么？我这里宝贝是很多，可是也要掂量掂量自己有几斤几两，等会可不要哭爹喊娘~~~哼哼！\n\n"
  Youlongmibao:RefreshCanYoulongCount(me)
  local nNowCount = me.GetTask(Youlongmibao.TASK_GROUP_ID, Youlongmibao.TASK_CAN_YOULONG_COUNT)
  szMsg = string.format("%s每天为每个角色累积<color=yellow>200次<color>游龙挑战机会，最多能累积<color=yellow>1400次<color>。\n当前剩余挑战机会为：<color=yellow>%s个<color>。", szMsg, nNowCount)
  local tbOpt = {
    { "我是来和你比武的", self.StartGame, self },
    { "月影之石换取战书", self.Challenge, self },
    { "游龙阁声望令交换", self.Shengwang, self },
    { "声望令换游龙古币", self.ChangeCoin, self },
    { "我要离开这里", self.LeaveHere, self },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:StartGame()
  if me.GetTiredDegree1() == 2 then
    Dialog:Say("您太累了，跟你打别人会说我欺负你的！")
    return
  end
  if KGblTask.SCGetDbTaskInt(DBTASD_EVENT_YOULONGGESWITCH) == 1 then
    local nFlag = Player:CheckTask(Youlongmibao.TASK_GROUP_ID, Youlongmibao.TASK_ATTEND_DATE, "%Y%m%d", Youlongmibao.TASK_ATTEND_NUM, 10)
    if nFlag == 0 then
      Dialog:Say("今天打的够多了，你不累我都累了，还是明天再来吧！")
      return
    end
  end
  if Youlongmibao.tbPlayerList[me.nId] then
    Youlongmibao:RecoverAward(me)
  else
    Youlongmibao:Continue(me)
  end
end

function tbNpc:GetAward()
  local nGetAward = Youlongmibao:CheckGetAward(me)

  if nGetAward == 1 then
    Youlongmibao:RecoverAward(me)
  else
    Dialog:Say("你已经领过奖励了，宝贝不好是你运气不行，可不要怪我。走开，走开，我现在烦死了。")
  end
end

function tbNpc:Challenge()
  if me.IsAccountLock() ~= 0 then
    Dialog:Say("你的账号处于锁定状态，无法进行该操作！")
    return 0
  end
  Dialog:OpenGift("这里可以利用“月影之石”换取“战书：游龙密室”，可以一次换取多个。", nil, { Youlongmibao.OnChallenge, Youlongmibao })
end

function tbNpc:LeaveHere()
  local tbOpt = {
    { "是的", Youlongmibao.OnPlayerLeave, Youlongmibao },
    { "我再想想" },
  }
  Dialog:Say("你确定要离开这里么？", tbOpt)
end

function tbNpc:Shengwang()
  local szMsg = "在这里你可以利用任一<color=yellow>游龙阁声望令<color>与奇珍阁道具<color=yellow>“游龙阁声望交换凭证”<color>交换其他声望令。那么你想交换哪种声望令呢？"
  local tbOpt = {
    { "交换游龙阁声望令[护身符]", self.OnShengwang, self, 1 },
    { "交换游龙阁声望令[帽子]", self.OnShengwang, self, 2 },
    { "交换游龙阁声望令[衣服]", self.OnShengwang, self, 3 },
    { "交换游龙阁声望令[腰带]", self.OnShengwang, self, 4 },
    { "交换游龙阁声望令[鞋子]", self.OnShengwang, self, 5 },
    { "交换游龙阁声望令[项链]", self.OnShengwang, self, 6 },
    { "交换游龙阁声望令[护腕]", self.OnShengwang, self, 7 },
    { "我不想换了" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:OnShengwang(nType)
  if me.IsAccountLock() ~= 0 then
    Dialog:Say("你的账号处于锁定状态，无法进行该操作！")
    return 0
  end
  Dialog:OpenGift("请放入游龙阁声望令及游龙阁声望交换凭证各一个", nil, { Youlongmibao.OnShengwang, Youlongmibao, nType })
end

function tbNpc:ChangeCoin()
  Dialog:OpenGift("请放入游龙阁声望令牌（大小牌子均可以兑换）", nil, { Youlongmibao.OnChangeCoin, Youlongmibao })
end
