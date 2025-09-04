--竞技赛npc
--孙多良
--2008.12.25

--报名
function TowerDefence:OnDialog_SignUp(nSure)
  if self:CheckState() == 0 then
    Dialog:Say("我休息一下吧，守护先祖之魂已经结束了。")
    return 0
  end

  if self.nReadyTimerId <= 0 or Timer:GetRestTime(self.nReadyTimerId) <= TowerDefence.DEF_READY_TIME_ENTER then
    Dialog:Say("比赛时间为<color=yellow>上午10点—14点，下午17点—午夜23点<color>；每半个小时进行一次，整点和半点开始报名。报名时间4分钟30秒。\n\n<color=red>现在不在报名阶段<color>")
    return 0
  end

  if me.nTeamId <= 0 then
    if nSure == 1 then
      self:OnDialogApplySignUp()
      return 0
    end
    if me.nLevel < self.DEF_PLAYER_LEVEL or me.nFaction <= 0 then
      Dialog:Say("你的修为不足哦，60级并加入门派以后我一定带你去哦。")
      return 0
    end
    if self:IsSignUpByAward(me) == 1 then
      Dialog:Say("你上次比赛的奖励还没领呢，不准不要我的礼物哦，我会生气不带你去的。")
      return 0
    end
    if self:IsSignUpByTask(me) == 0 then
      Dialog:Say("你今天已经去了这么多次了，回去休息下明天再来吧。")
      return 0
    end

    if me.GetEquip(Item.EQUIPPOS_MASK) then
      Dialog:Say("不允许戴面具参加，请把面具摘下再来找我吧。")
      return 0
    end
    local tbOpt = {
      { "我要加入", self.OnDialog_SignUp, self, 1 },
      { "我再考虑考虑" },
    }
    Dialog:Say("你想加入义军抗击怪物的行列吗？", tbOpt)
    return 0
  end

  if me.IsCaptain() == 0 then
    Dialog:Say("你不是队长哦，去叫你们队长来报名吧。")
    return 0
  end
  local tbPlayerList = KTeam.GetTeamMemberList(me.nTeamId)

  if nSure == 1 then
    self:OnDialogApplySignUp(tbPlayerList)
    return 0
  end

  local tbOpt = {
    { "我们要前往", self.OnDialog_SignUp, self, 1 },
    { "我们再考虑考虑" },
  }
  Dialog:Say(string.format("你们队伍想加入义军抗击怪物的行列吗？队伍有<color=yellow>%s人<color>，请确定队员在这里。", #tbPlayerList), tbOpt)
  return 0
end

function TowerDefence:OnDialogApplySignUp(tbPlayerList)
  if not tbPlayerList then
    GCExcute({ "TowerDefence:ApplySignUp", { me.nId } })
    return 0
  end
  if Lib:CountTB(tbPlayerList) > self.DEF_PLAYER_TEAM then
    Dialog:Say("你们队伍人太多了，只能是四个人前去的。")
    return 0
  end
  local nMapId, nPosX, nPosY = me.GetWorldPos()
  for _, nPlayerId in pairs(tbPlayerList) do
    local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
    if not pPlayer then
      Dialog:Say("你们队伍有人没来啊，我们还不能出发，等等他吧。")
      return 0
    end
    if pPlayer.nLevel < self.DEF_PLAYER_LEVEL or pPlayer.nFaction <= 0 then
      Dialog:Say(string.format("啊，那个<color=yellow>%s<color>太弱小了吧，如果遇到怪物就危险了，60级并加入门派以后再来吧。", pPlayer.szName))
      return 0
    end
    if self:IsSignUpByAward(pPlayer) == 1 then
      Dialog:Say(string.format("<color=yellow>%s<color>上次比赛的奖励还没领呢，不准不要我的礼物哦，我会生气不带你们去玩的。", pPlayer.szName))
      return 0
    end

    if self:IsSignUpByTask(pPlayer) == 0 then
      Dialog:Say(string.format("啊，<color=yellow>%s<color>你今天去好多次了，明天再来吧。", pPlayer.szName))
      return 0
    end
    if pPlayer.GetEquip(Item.EQUIPPOS_MASK) then
      Dialog:Say(string.format("%s不允许戴面具参加，请把面具摘下再来找我吧。", pPlayer.szName))
      return 0
    end
    local nMapId2, nPosX2, nPosY2 = pPlayer.GetWorldPos()
    local nDisSquare = (nPosX - nPosX2) ^ 2 + (nPosY - nPosY2) ^ 2
    if nMapId2 ~= nMapId or nDisSquare > 400 then
      Dialog:Say("您的所有队友必须在这附近。")
      return 0
    end
    if not pPlayer or pPlayer.nMapId ~= nMapId then
      Dialog:Say("您的所有队友必须在这附近。")
      return 0
    end
  end
  GCExcute({ "TowerDefence:ApplySignUp", tbPlayerList })
  return 0
end

function TowerDefence:IsSignUpByTask(pPlayer)
  TowerDefence:TaskDayEvent()
  local nCount = pPlayer.GetTask(self.TSK_GROUP, self.TSK_ATTEND_COUNT)
  local nExCount = pPlayer.GetTask(self.TSK_GROUP, self.TSK_ATTEND_EXCOUNT)
  if nCount <= 0 and nExCount <= 0 then
    return 0, 0, 0
  end
  return nCount + nExCount, nCount, nExCount
end

function TowerDefence:IsSignUpByAward(pPlayer)
  return pPlayer.GetTask(self.TSK_GROUP, self.TSK_ATTEND_AWARD)
end

function TowerDefence:Npc_ProductTD()
  local tbITem = Item:GetClass("td_fuzou")
  local szMsg = "在这里，你只需要花少量的钱就可以对先祖庇护符进行改造，从而使其具有特殊的能力，帮助你取得比赛的胜利！"
  local tbOpt = {
    { "了解先祖庇护符改造", TowerDefence.OnAbout, TowerDefence },
    { "进行先祖庇护符改造", tbITem.OpenProduct, tbITem, 1 },
    { "随便看看" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function TowerDefence:OnAbout()
  local szMSg = "义军正在禅境花园守护先祖之魂，你要了解哪些内容呢？"
  local tbOpt = {}
  for i, tbMsg in pairs(self.tbAbout) do
    table.insert(tbOpt, { tbMsg[1], self.AboutInfo, self, i })
  end
  table.insert(tbOpt, { "我明白了" })
  Dialog:Say(szMSg, tbOpt)
end

function TowerDefence:AboutInfo(nSel)
  local szMSg = self.tbAbout[nSel][2]
  Dialog:Say(szMSg, { { "我知道了", self.OnAbout, self } })
end

TowerDefence.tbAbout = {
  {
    "何谓“守卫先祖之魂”",
    [[
    每到一年的这个时节，白秋琳都会召集义军上下将士在伏牛山后山祭奠先祖之魂，多年来，义军正是秉承了先祖的“驱除鞑虏，还我家园”的坚定意志，坚持着对异族侵略者进行着艰苦卓绝的抵抗。
    时辰将近，突然收到龙五太爷线人密报，一伙由金人操纵的僵尸和机械怪兽军团正在以围剿之势接近这里，企图借助怪物之力打击义军主力，并威胁先祖之魂。预计大批怪兽将在清明节子时到达这里，大厦将倾，山雨欲来。
    据与怪物接触过的先头部队的反馈，普通兵器对这些怪物们攻击无效，只有依靠五毒教秘制的植物才能抵御，并对僵尸军团造成打击，突出重围。白秋琳果断下令，义军所有将士，立即投入工作，在后山建立防御工事，抵御怪物入侵。
]],
  },
  { "活动开启时间", string.format([[11：00~~14：00，17：00~~23：00为比赛时间。]]) },
  {
    "如何参加比赛",
    [[
    活动开启后，30级以上的玩家可以去各新手村找晏若雪报名参加，活动日每天有2次机会。参加比赛必须有自己的专属先祖庇护符，先祖庇护符可以采取一定方式获得，同时还能进行额外改造，使其具有各种特殊能力。]],
  },
  {
    "如何获得专属先祖庇护符",
    [[
    先祖庇护符的获取方式：在晏若雪处商店购买先祖庇护，您可以花费500金币升级为先祖庇护·凤凰。
    ]],
  },
  {
    "了解先祖庇护符改造",
    [[
    先祖庇护符改造共有五个技能可供选择。
    <color=yellow>可供选择的技能改造：<color>
    先祖庇护·定：对被击中的怪物造成一定伤害同时产生定身效果；
    先祖庇护·退：对被击中的怪物造成一定伤害同时产生后退效果；
    先祖庇护·缓：对被击中的怪物造成一定伤害同时产生迟缓效果；
    先祖庇护·乱：对被击中的怪物造成一定伤害同时产生混乱效果；
    先祖庇护·晕：对被击中的怪物造成一定伤害同时产生眩晕效果；
    <color=yellow>注意：<color>先祖庇护与先祖庇护·凤凰的区别就在于普通的先祖庇护只能改造一种攻击技能，而先祖庇护·凤凰可以同时选择改造两种技能。]],
  },
  {
    "比赛如何玩",
    [[
    怪物从起始区进入防御工事，然后沿通道两侧移动，每一边的怪物总量是相同的，走到争夺区汇合，然后稍作停留后，会走出终点，怪物消失。
    关卡开启后，30秒过后开始刷怪，怪物每一分钟刷一次，一共刷12次，其中精英和首领怪是会释放范围攻击技能来伤害植物的。玩家通过种植物，来攻击怪物。如果一波怪物很快打完了，那就立即刷新一波。
    在比赛过程中，购买植物需要用军饷在地图中的五毒秘术商人处来购买，每一波怪在被消灭后所有玩家都会获得军饷。获得的军饷会在客户端界面上实时显示，以方便玩家知道自己目前的军饷数。]],
  },
  { "胜负及奖励", [[
    消灭怪物的玩家会获得积分，活动结束后按照本场玩家所获得的积分排名，领取奖励。]] },
}
