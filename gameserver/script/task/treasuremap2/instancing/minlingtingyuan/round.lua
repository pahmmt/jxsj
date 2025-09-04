-- 文件名　：round.lua
-- 创建者　：LQY
-- 创建时间：2012-11-12 16:54:27
-- 说　　明：关卡逻辑
Require("\\script\\task\\treasuremap2\\instancing\\minlingtingyuan\\define.lua")
Require("\\script\\task\\treasuremap2\\instancing\\minlingtingyuan\\main.lua")
local tbInstancing = TreasureMap2:GetInstancingBase(8)
local tbRound1 = tbInstancing.tbRound1
local tbRound2 = tbInstancing.tbRound2
local tbRound3 = tbInstancing.tbRound3
local tbRound4 = tbInstancing.tbRound4
local tbRound5 = tbInstancing.tbRound5
local tbRound6 = tbInstancing.tbRound6
local tbRound7 = tbInstancing.tbRound7
----第一关
local Round1 = tbInstancing:GetRound(1)
-- 开始
function Round1:Begin(nType)
  self.tbInstancing:SendBlackBoardMsgByTeam("听得古嫣然与人争论桃溪镇下毒一事，不想竟发现此处。")
  local nCount1, _, tbNpc1 = self:AddNpc("duwu1", self.Rond1DuwuDead, self)
  local nCount2, _, tbNpc2 = self:AddNpc("duwu2", self.Rond1DuwuDead, self)
  self.nRound1DuWu = nCount1 + nCount2
  self.tbRound1DuWu = Lib:MergeTable(tbNpc1, tbNpc2)
  self:AddRoundTimer(tbRound1.TIME_AFTER, self.Round1Npc, self)
end

--召唤NPC
function Round1:Round1Npc()
  local _, _, _, tbPNpcs = self:AddNpc("dianming1")
  local pNpc = tbPNpcs[1]
  if not pNpc then
    return
  end
  self.tbInstancing:SendMsgByTeam("炼毒人出现！被点名的玩家速将之带到毒草处。")
  self:CreatFightFollow(nil, pNpc, 0, 150, 1, { self.DianMingLost, self })
  pNpc.SetLiveTime(tbRound1.TIME_NAMENPC_TIME)
  for _, nId in pairs(self.tbRound1DuWu) do
    local pNpcDw = KNpc.GetById(nId)
    if pNpcDw then
      pNpcDw.AddSkillState(1850, 1, 0, tbRound1.TIME_NAMENPC_TIME, 0, 1, 0, 0, 1)
      pNpcDw.Sync()
    end
  end
  self.tbInstancing:SendBlackBoardMsgByTeam("速引炼毒人至毒火花处，以毒攻毒！")
  return
end

--跟随失去目标
function Round1:DianMingLost(dwNpc)
  local pNpc = KNpc.GetById(dwNpc)
  if not pNpc then
    return
  end
  local tbPlayers = self.tbInstancing:GetPlayerList()
  local pPlayer = tbPlayers[MathRandom(1, #tbPlayers)]
  if pPlayer then
    self:NpcChat(pNpc, { pPlayer.szName .. "？桃溪镇幸存的小娃儿，可惜你即将葬身于此！" })
    self:ChangeFightFollow(pNpc, pPlayer)
  end
end

--毒物死亡回调
function Round1:Rond1DuwuDead(pNpc)
  for n, nId in pairs(self.tbRound1DuWu) do
    if pNpc.dwId == nId then
      table.remove(self.tbRound1DuWu, n)
      break
    end
  end
  self.nRound1DuWu = self.nRound1DuWu - 1
  if self.nRound1DuWu == 0 then
    self:RoundEnd()
  end
end

-- 第一关结束
function Round1:End()
  self.tbInstancing:SendBlackBoardMsgByTeam("一池诡异的毒草，慢慢化为毒气氤氲开来，必须离开此地继续前进！")
end

----第二关
-- 开始
local Round2 = tbInstancing:GetRound(2)
function Round2:Begin(nType)
  self.tbInstancing:SendBlackBoardMsgByTeam("诸位大侠！请、请救我……呜呜……救我啊……")
  self:AddFire()
  local _, _, _, tbNpcs = self:AddNpc("boss2", self.Rond2BossDead, self)
  local _, _, _, tbNpcs2 = self:AddNpc("beikungirl1")
  self.pGirl = tbNpcs2[1]
  --self.pGirl.SetCurCamp(6);
  local pNpc = tbNpcs[1]
  self.pBoss = pNpc
  -- 注册血量触发事件，80 60 40 20
  Npc:RegPNpcLifePercentReduce(pNpc, 99, self.OnLifePercentReduce, self, pNpc, 1)
  Npc:RegPNpcLifePercentReduce(pNpc, 80, self.OnLifePercentReduce, self, pNpc, 2)
  Npc:RegPNpcLifePercentReduce(pNpc, 50, self.OnLifePercentReduce, self, pNpc, 3)
  Npc:RegPNpcLifePercentReduce(pNpc, 20, self.OnLifePercentReduce, self, pNpc, 4)
end

--BOSS死亡回调
function Round2:Rond2BossDead(pNpc)
  self.tbInstancing:AddKillBossNum(pNpc)
  self.pGirl.Delete()
  --self.pGirl.SendChat("各位大侠的救命之恩小女子没齿难忘！谢谢！");
  local _, _, _, tbNpcs2 = self:AddNpc("beikungirl2")
  self.pGirl = tbNpcs2[1]
  self.pGirl.SendChat("各位大侠的救命之恩小女子没齿难忘！谢谢！")
  local tbPlayers = self.tbInstancing:GetPlayerList()
  if tbPlayers then
    self.tbInstancing:CreatFightFollow(0, tbPlayers[1], self.pGirl, 0, 100, 5, { self.GirlLost, self })
  end
  self:RoundEnd()
end

--女孩迷路，直接删掉
function Round2:GirlLost(dwId)
  local pNpc = KNpc.GetById(dwId)
  if pNpc then
    pNpc.Delete()
  end
end

--BOSS血量触发
function Round2:OnLifePercentReduce(pNpc, nType)
  if nType == 1 then
    self:NpcChat(pNpc, { "无知小儿，五仙教内事务怎容尔等插手！" })
  end
  if nType == 2 then
    self.pGirl.SendChat("救救我！")
  end
  if nType == 3 then
    self.pGirl.SendChat("呜呜呜呜~~")
  end
  if nType == 4 then
    self.pGirl.SendChat("救命啊~")
  end
end

--召唤BUG，汗
function Round2:CallBug()
  --没有特殊处理的NPC，可以直接注册死亡回调到加分上
  local _, _, _, tbPNpcs = self:AddNpc("boss2_bug", self.tbInstancing.AddKillNpc)
  local pBug1 = tbPNpcs[1]
  local pBug2 = tbPNpcs[2]
  pBug1.AI_AddMovePos(unpack(tbRound2.tbBugTarget))
  pBug1.GetTempTable("Npc").tbOnArrive = { self.OnBugArrive, self, pBug1 }
  pBug1.SetNpcAI(9, 0, 0, 0, 0, 0, 0, 0, 0, 0)
  pBug2.AI_AddMovePos(unpack(tbRound2.tbBugTarget))
  pBug2.GetTempTable("Npc").tbOnArrive = { self.OnBugArrive, self, pBug2 }
  pBug2.SetNpcAI(9, 0, 0, 0, 0, 0, 0, 0, 0, 0)
  self.nBugArrive = 0
  pBug1.SetLiveTime(10 * 18)
  pBug2.SetLiveTime(10 * 18)
  self.tbInstancing:SendBlackBoardMsgByTeam("出现两人手持雷火，切不可让此两人汇合！")
end

--BUG走到了
function Round2:OnBugArrive(pBug)
  self.nBugArrive = self.nBugArrive + 1
  if self.nBugArrive == 2 then
    local _, nX, nY = self.pBoss.GetWorldPos()
    self.pBoss.CastSkill(1746, 1, nX * 32, nY * 32)
    --print("两只毒虫相遇爆炸鸟~~~墨绿色的粘稠汁液四处飞溅着，模糊了你的双眼。湿润了你的嘴唇。");
  end
  pBug.Delete()
end

--加火
function Round2:AddFire()
  for _, tbP in pairs(tbRound2.tbFires) do
    local pNpc = KNpc.Add2(tbRound2.nFireNpc, 1, 0, self.tbInstancing.nMapId, unpack(tbP[1]))
    if pNpc then
      pNpc.szName = ""
      pNpc.GetTempTable("TreasureMap2").tbTarg = tbP[2]
      pNpc.GetTempTable("TreasureMap2").tbFireSkill = tbP[3]
      self.tbInstancing:AddRoundTimer(0, tbRound2.nFireTime1, self.Fire, self, pNpc)
    end
  end
  self.nFireTime = tbRound2.nFireTime1
end
--开火
function Round2:Fire(pNpc)
  if pNpc then
    local tbTarg = pNpc.GetTempTable("TreasureMap2").tbTarg
    if not tbTarg then
      return
    end
    local tbFireSkill = pNpc.GetTempTable("TreasureMap2").tbFireSkill
    pNpc.CastSkill(tbFireSkill[1], tbFireSkill[2], unpack(tbTarg))
  end
  return self.nFireTime
end

-- 第二关结束
function Round2:End()
  self.tbInstancing:SendBlackBoardMsgByTeam("元凰回头看了被困女子一眼，竟任由身体化为飞灰。")
  self.nFireTime = tbRound2.nFireTime2
  local tbPlayers = self.tbInstancing:GetPlayerList()
  for _, pPlayer in pairs(tbPlayers) do
    pPlayer.RemoveSkillState(1747)
  end
end

----第三关
-- 开始
local Round3 = tbInstancing:GetRound(3)
function Round3:Begin(nType)
  self.tbInstancing:SendBlackBoardMsgByTeam("凄厉的狼嚎，幽暗的囚室，是生机？还是死地？")
  local _, _, _, tbNpc = self:AddNpc("boss3", self.BossDeath, self)
  self.pBoss = tbNpc[1]
end
--BOSS死亡
function Round3:BossDeath(pNpc)
  self.tbInstancing:AddKillBossNum(pNpc)
  self:RoundEnd()
end

--召唤动物
function Round3:CallAnimal(szType)
  local tbAnimal = {
    [1] = "dog",
    [2] = "rabbit",
    [3] = "deer",
  }
  if not szType then
    szType = tbAnimal[MathRandom(1, 3)]
  end
  local _, _, _, tbNpc = self:AddNpc(szType, self.AnimalDeadth, self, szType)
  local pNpc = tbNpc[1]
  if not pNpc then
    return
  end
  self.tbAnimal = self.tbAnimal or {}
  table.insert(self.tbAnimal, pNpc.dwId)
  if szType == "dog" then
    self.tbInstancing:SendBlackBoardMsgByTeam("献祭·犬出现了！不可让其走到火狼王身边！")
    pNpc.GetTempTable("Npc").tbOnArrive = { self.OnDogArrive, self, pNpc.dwId }
    pNpc.AI_ClearPath()
    pNpc.AI_AddMovePos(tbRound3.tbBossPos[1] * 32, tbRound3.tbBossPos[2] * 32)
    pNpc.SetNpcAI(9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    return
  end
  if szType == "deer" then
    self.tbInstancing:SendBlackBoardMsgByTeam("献祭·鹿出现了！诸位大侠快分散开！")
    self:CreatFightFollow(nil, pNpc, 0, 50, 1, { self.DeerLost, self })
    return
  end
  if szType == "rabbit" then
    self.tbInstancing:SendBlackBoardMsgByTeam("献祭·兔出现了！切莫要伤它！")
    pNpc.GetTempTable("Npc").tbOnArrive = {
      function()
        pNpc.Delete()
        print("delete 3")
      end,
    }
    pNpc.AI_ClearPath()
    pNpc.AI_AddMovePos(tbRound3.tbBossPos[1] * 32, tbRound3.tbBossPos[2] * 32)
    pNpc.SetNpcAI(9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    return
  end
end

--鹿迷路了
function Round3:DeerLost(dwNpc)
  local pNpc = KNpc.GetById(dwNpc)
  if not pNpc then
    return
  end
  local tbPlayers = self.tbInstancing:GetPlayerList()
  local pPlayer = tbPlayers[MathRandom(1, #tbPlayers)]
  pNpc.SendChat(pPlayer.szName .. "不要跑！")
  self:ChangeFightFollow(pNpc, pPlayer)
  self:AddMeetEvent(pNpc, pPlayer, nil, self.OnDeerMeet, self, pNpc.dwId, pPlayer)
end

--鹿碰到人
function Round3:OnDeerMeet(dwNpc, pPlayer)
  local pNpc = KNpc.GetById(dwNpc)
  if not pNpc then
    return
  end
  self.pBoss.CastSkill(1746, 1, tbRound3.tbBossPos[1] * 32, tbRound3.tbBossPos[2] * 32)
  pNpc.Delete()
end

--狗走到了中间
function Round3:OnDogArrive(dwNpc)
  local pNpc = KNpc.GetById(dwNpc)
  if not pNpc then
    return
  end
  self.pBoss.CastSkill(1746, 1, tbRound3.tbBossPos[1] * 32, tbRound3.tbBossPos[2] * 32)
  pNpc.Delete()
end

--动物死鸟
function Round3:AnimalDeadth(pNpc, szType)
  if szType == "dog" then
    return
  end
  if szType == "rabbit" then
    self.tbInstancing:SendBlackBoardMsgByTeam("火狼王回血了，切莫伤害献祭·兔")
    self.pBoss.AddSkillState(98, 6, 0, 18, 1, 1, 0, 0, 1)
    return
  end
  if szType == "deer" then
    --pNpc.CastSkill(1746,1);
    return
  end
end
--第三关结束
function Round3:End(nType)
  for _, nId in pairs(self.tbAnimal or {}) do
    local pNpc = KNpc.GetById(nId)
    if pNpc then
      pNpc.Delete()
    end
  end
  local tbPlayers = self.tbInstancing:GetPlayerList()
  for _, pPlayer in pairs(tbPlayers) do
    pPlayer.RemoveSkillState(1747)
  end
  self.tbInstancing:SendBlackBoardMsgByTeam("火狼王不甘心的怒吼，成了它此生最后的挽歌。")
  self:AddNpc("baoku4", self.tbInstancing.AddKillNpc) --走廊小怪
end
--使用扇形技能
function Round3:CastSector()
  local pNpc = KNpc.Add2(tbRound2.nFireNpc, 1, 0, self.tbInstancing.nMapId, unpack(tbRound3.tbBossPos))
  if pNpc then
    pNpc.szName = ""
    self.nSectorNum = 1
    self:AddRoundTimer(tbRound3.nFireTime, self.SectorFire, self, pNpc)
  end
end
--扇形技能计时器
function Round3:SectorFire(pNpc)
  if not pNpc then
    return
  end
  local tbPos = self.tbInstancing:Get6Pos(tbRound3.tbBossPos, 5)
  pNpc.CastSkill(tbRound3.nSectorId, 10, tbPos[self.nSectorNum][1] * 32, tbPos[self.nSectorNum][2] * 32)
  if self.nSectorNum == 6 then
    self.nSectorNum = 1
  else
    self.nSectorNum = self.nSectorNum + 1
  end
end
--使用火墙
function Round3:CastFireWall()
  local tbNpcs = {}
  for _, tbPos in pairs(tbRound3.tbFireWallPos) do
    local pNpc = KNpc.Add2(tbRound2.nFireNpc, 1, 0, self.tbInstancing.nMapId, unpack(tbPos))
    if pNpc then
      pNpc.szName = ""
      pNpc.SetLiveTime(10 * 18)
      tbNpcs[#tbNpcs + 1] = pNpc
    end
  end
  self:AddRoundTimer(1 * 18, self.FireWall, self, tbNpcs)
end
function Round3:FireWall(tbNpcs)
  for _, pNpc in pairs(tbNpcs) do
    pNpc.CastSkill(tbRound3.nFireWallId, 1, tbRound3.tbBossPos[1] * 32, tbRound3.tbBossPos[2] * 32)
  end
  return 0
end

----第四关
-- 开始 11247 11264
local Round4 = tbInstancing:GetRound(4)
function Round4:Begin(nType)
  self.tbInstancing:SendBlackBoardMsgByTeam("诸位务必力保四角灯烛不熄！")
  local nCount1, _, _, tbPNpc1 = self:AddNpc("box41")
  local nCount2, _, _, tbPNpc2 = self:AddNpc("box42")
  --确定钥匙位置
  local nKey = MathRandom(1, nCount1 + nCount2)
  local tbPNpc = Lib:MergeTable(tbPNpc1, tbPNpc2)
  tbPNpc[nKey].GetTempTable("TreasureMap2").bKey = 1
  --tbPNpc[nKey].szName = "★在我这里";--test用
  --n秒后刷出所有灯
  self:AddRoundTimer(tbRound4.nAddLightTime, self.AddLight, self)
  self.bCantOpen = 0
end

--刷灯
function Round4:AddLight(szLightType)
  if not szLightType then
    self.tbInstancing:SendBlackBoardMsgByTeam("四角的灯都已点亮。")
  end
  for szType, tbPos in pairs(tbRound4.tbLightPos) do
    if not szLightType or (szLightType and szLightType == szType) then
      local pNpc = KNpc.Add2(tbRound4.nLightNpc, 1, 0, self.tbInstancing.nMapId, unpack(tbPos))
      if pNpc then
        pNpc.GetTempTable("TreasureMap2").szLightType = szType
        local tbTimer = self:AddRoundTimer(tbRound4.nTellLightOffTime, self.OffLight, self, pNpc)
        pNpc.GetTempTable("TreasureMap2").tbLightTimer = tbTimer
        pNpc.GetTempTable("TreasureMap2").bTell = 0
      end
    end
  end
  return 0
end

--熄灯
function Round4:OffLight(pNpc)
  if not pNpc then
    return
  end
  local szType = pNpc.GetTempTable("TreasureMap2").szLightType
  local bTell = pNpc.GetTempTable("TreasureMap2").bTell or 0
  local tbTypesz = {
    LD = "左下",
    LU = "左上",
    RD = "右下",
    RU = "右上",
  }
  if bTell == 0 then
    self.tbInstancing:SendMsgByTeam(string.format("<color=yellow>%s<color>方的灯还有<color=red>%d<color>秒熄灭。", tbTypesz[szType], (tbRound4.nLightOffTime - tbRound4.nTellLightOffTime) / Env.GAME_FPS))
    pNpc.GetTempTable("TreasureMap2").bTell = 1
    return tbRound4.nLightOffTime - tbRound4.nTellLightOffTime
  end
  local nMapId, nX, nY = pNpc.GetWorldPos()
  pNpc.Delete()
  local pNewNpc = KNpc.Add2(tbRound4.nUnLightNpc, 1, 0, nMapId, nX, nY)
  if pNewNpc then
    pNewNpc.GetTempTable("TreasureMap2").szLightType = szType
    pNewNpc.GetTempTable("TreasureMap2").tbTimer = self:AddRoundTimer(tbRound4.nAddMonsterTime, self.AddMonster, self)
  end
  self.tbInstancing:SendBlackBoardMsgByTeam(string.format("<color=yellow>%s<color>角的灯已熄灭。", tbTypesz[szType]))
  if self.bCantOpen ~= 1 then
    self:AddMonster()
  end
  return 0
end

--刷小怪
function Round4:AddMonster()
  self.tbInstancing:SendBlackBoardMsgByTeam("宝库灯座熄灭！宝库守卫竟纷涌而至！快去把灯点亮！")
  self.tbMonsterId = self.tbMonsterId or {}
  if #self.tbMonsterId <= 9 * 3 then --控制在刷四次
    local _, _, tbNpcId = self:AddNpc("xiaoguai4", self.OnMonsterDeath, self)
    for _, nId in pairs(tbNpcId) do
      table.insert(self.tbMonsterId, nId)
    end
  end
end

--小怪死亡
function Round4:OnMonsterDeath(pNpc)
  for n, nId in pairs(self.tbMonsterId) do
    if nId == pNpc.dwId then
      table.remove(self.tbMonsterId, n)
    end
  end
end
--点灯
function Round4:OnLight(nNpcId)
  if self.tbInstancing:IsOpen() ~= 1 then
    return
  end
  if self.bCantOpen == 1 then
    Dialog:Say("钥匙已经找到，赶快离开这个地方！")
    return
  end
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    return
  end
  if pNpc.nTemplateId == tbRound4.nLightNpc then
    local tbTimer = pNpc.GetTempTable("TreasureMap2").tbLightTimer
    Lib:CallBack({ tbTimer.Close, tbTimer })
    pNpc.GetTempTable("TreasureMap2").bTell = 0
    local tbTimer2 = self:AddRoundTimer(tbRound4.nTellLightOffTime, self.OffLight, self, pNpc)
    pNpc.GetTempTable("TreasureMap2").tbLightTimer = tbTimer2
    me.Msg("这盏灯变得明亮了一些。")
    return
  end
  if pNpc.nTemplateId == tbRound4.nUnLightNpc then
    local szType = pNpc.GetTempTable("TreasureMap2").szLightType
    pNpc.Delete()
    self:AddLight(szType)
    local tbTimer = pNpc.GetTempTable("TreasureMap2").tbTimer
    Lib:CallBack({ tbTimer.Close, tbTimer })
    me.Msg("重新点亮了这盏灯。")
  end
end

--打开宝箱
function Round4:OpenBox(nNpcId)
  if self.tbInstancing:IsOpen() ~= 1 then
    return
  end
  if self.bCantOpen == 1 then
    Dialog:Say("钥匙已经找到，赶快离开这个地方！")
    return
  end
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    Dialog:Say("箱子不见了。")
    return
  end
  local bKey = pNpc.GetTempTable("TreasureMap2").bKey or 0
  pNpc.Delete()
  if bKey == 1 then
    self.bCantOpen = 1
    local nScore = self.tbInstancing:AddKillNpc(pNpc) or 0
    self.tbInstancing:SendMsgByTeam("你的队伍找到钥匙获得战斗积分<color=white>" .. nScore .. "<color>分。")
    local szTalk = "<color=red>" .. me.szName .. "<color>:我找到钥匙了！大家快离开这个地方！"
    self.tbInstancing:SendBlackBoardMsgByTeam(szTalk)
    self:RoundEnd()
    return
  end
  me.Msg("箱子里面装满了耀眼的财宝，但没有看到钥匙。")
  self.tbInstancing:AddInstanceScore(1) --空箱子给一分
  self.tbInstancing:SendMsgByTeam("你的队伍打开一个箱子获得战斗积分<color=white>1<color>分。")
end

function Round4:End(nType)
  for _, nId in pairs(self.tbMonsterId or {}) do
    local pNpc = KNpc.GetById(nId)
    if pNpc then
      pNpc.Delete()
    end
  end
  self.tbInstancing:SendBlackBoardMsgByTeam("藏宝室的门打开，我隐约看见被困女子眼中的阴霾……")
end

----第五关
-- 开始
local Round5 = tbInstancing:GetRound(5)
function Round5:Begin(nType)
  local Round = self.tbInstancing:GetRound(2)
  Round.pGirl.Delete()
  self:AddFire()
  local _, _, _, tbPNpc = self:AddNpc("boss5", self.BossDeath, self)
  self.pBoss = tbPNpc[1]
  self:NpcChat(self.pBoss, { "没想到你们真的能走到这里，呵，桃溪镇下毒之事……可不是你们管得起的！" })
end

--踩到返回点
function Round5:OnTrapEnter5(pPlayer)
  pPlayer.GetTempTable("TreasureMap2").tbFightFollow = {}
end
-- 花雨技能
function Round5:CallFlower()
  self.tbInstancing:SendBlackBoardMsgByTeam("小心躲避地上蓝色光斑")
  --召唤npc
  self:CallMonster()
  --令各玩家客户端释放10秒全屏花雨
  local tbPlayers = self.tbInstancing:GetPlayerList()
  if tbPlayers then
    for key, pPlayer in pairs(tbPlayers) do
      pPlayer.CallClientScript({ "GM:DoCommand", "Map.DropEffect:Show(2928, 32, 10*18)" })
    end
  end
  local nMapId, nMapX, nMapY = self.pBoss.GetWorldPos()
  for i = 1, 4 do
    local nRadius = MathRandom(0 * 100, 20 * 100) / 100 --对半径1到半径2之间的区域释放
    local nAngle = MathRandom(0, math.pi * 100 * 2) / 100
    local x = nRadius * math.cos(nAngle) * 32
    local y = nRadius * math.sin(nAngle) * 32
    local nSkillId, nSkillLv = 1757, 20
    self.pBoss.CastSkill(nSkillId, nSkillLv, nMapX * 32 + x, nMapY * 32 + y)
    --him.CastSkill(nSkillId, nSkillLv, nMapX*32+x, nMapY*32-y);
    --him.CastSkill(nSkillId, nSkillLv, nMapX*32-x, nMapY*32+y);
    --him.CastSkill(nSkillId, nSkillLv, nMapX*32-x, nMapY*32-y);
  end
end

--召唤小怪/重新选人
function Round5:CallMonster(dwNpc)
  if not dwNpc then
    local _, _, _, tbPNpc = self:AddNpc("xiaoguai5")
    local pNpc = tbPNpc[1]
    self:CreatFightFollow(nil, pNpc, 0, 50, 1, { self.CallMonster, self })
    self:AddRoundTimer(2 * 18, self.DisCheck, self, pNpc.dwId)
    self:AddRoundTimer(7 * 18, self.CallBomb, self, pNpc.dwId) --过7秒加上8秒后自爆的技能，一共是15秒
    pNpc.SetLiveTime(16 * 18)
    return
  end
  if dwNpc then
    local pNpc = KNpc.GetById(dwNpc)
    if not pNpc then
      return
    end
    local tbPlayers = self.tbInstancing:GetPlayerList()
    local pPlayer = tbPlayers[MathRandom(1, #tbPlayers)]
    if pPlayer then
      self:NpcChat(pNpc, { pPlayer.szName .. "成为嗜月者的饵食吧！" })
      self.tbInstancing:SendBlackBoardMsgByTeam("被点名的侠士速速远离人群，小心地上光斑！")
      self:ChangeFightFollow(pNpc, pPlayer)
    end
  end
end
--加上自爆技能
function Round5:CallBomb(dwNpc)
  local pNpc = KNpc.GetById(dwNpc)
  if pNpc then
    local _, nX, nY = pNpc.GetWorldPos()
    pNpc.CastSkill(1762, 60, nX * 32, nY * 32)
  end
  return 0
end
--距离判断，NPC距离BOSS太远，就拉回来并重新点名
function Round5:DisCheck(dwNpc)
  local pNpc = KNpc.GetById(dwNpc)
  if not pNpc then
    return
  end
  local nDis = self.tbInstancing:GetDis(pNpc, self.pBoss)
  if nDis == 9999 then
    return 0
  end
  if nDis > 25 then
    pNpc.NewWorld(self.pBoss.GetWorldPos())
    self:CallMonster(dwNpc)
  end
end

--BOSS死亡
function Round5:BossDeath(pNpc)
  local _, _, _, tbPNpc = self:AddNpc("boss5_chat")
  self:AddNpc("boss5_light")
  self.tbInstancing:AddKillBossNum(pNpc)
  self.tbInstancing:SendBlackBoardMsgByTeam("吟荷的低诉止住了我的脚步，当年之事或许早该埋葬在那场火中")
  self:NpcChat(tbPNpc[1], {
    "我并非真正的嗜月沼看守……我亦义军安插在五毒教的暗探。我以为、我以为让你知晓桃溪镇一事，你们会放过他的……",
    "你们走吧……我不会再回义军了。这里一片花海，是他为了真正的吟荷种的啊……",
  })
  self:AddRoundTimer(10 * 18, self.RoundEnd, self)
end

--加火
function Round5:AddFire()
  for _, tbP in pairs(tbRound5.tbFires) do
    local pNpc = KNpc.Add2(tbRound5.nFireNpc, 1, 0, self.tbInstancing.nMapId, unpack(tbP[1]))
    if pNpc then
      pNpc.szName = ""
      pNpc.GetTempTable("TreasureMap2").tbTarg = tbP[2]
      pNpc.GetTempTable("TreasureMap2").tbFireSkill = tbP[3]
      self.tbInstancing:AddRoundTimer(0, tbRound5.nFireTime1, self.Fire, self, pNpc)
    end
  end
  self.nFireTime = tbRound5.nFireTime1
end
--开火
function Round5:Fire(pNpc)
  if pNpc then
    local tbTarg = pNpc.GetTempTable("TreasureMap2").tbTarg
    if not tbTarg then
      return
    end
    local tbFireSkill = pNpc.GetTempTable("TreasureMap2").tbFireSkill
    pNpc.CastSkill(tbFireSkill[1], tbFireSkill[2], unpack(tbTarg))
  end
  return self.nFireTime
end

--结束
function Round5:End()
  self.nFireTime = tbRound5.nFireTime2
  self.tbInstancing:SendBlackBoardMsgByTeam("是非对错情爱痴嗔，孰能理清，无奈只得留她离去。")
end

----第六关
-- 开始
local Round6 = tbInstancing:GetRound(6)
function Round6:Begin(nType)
  self.tbInstancing:SendBlackBoardMsgByTeam("祭台中央缓缓爬出毒虫，消灭毒虫同时救出少女！")
  local tbTimer = self:AddRoundTimer(tbRound6.nLimitTime, self.TimeOver, self)
  self.tbInstancing:SetLimitTimer("\n<color=red>关卡剩余时间：<color><color=white>%s<color>\n", tbTimer)
  self.tbTimer = tbTimer
  local _, _, tbNpcId, tbNpcP = self:AddNpc("girl6")
  self.tbGirls = tbNpcId
  for _, pGirl in pairs(tbNpcP) do
    pGirl.AddSkillState(1163, 30, 0, 50 * 60 * 18, 0, 1, 0, 0, 1)
    pGirl.Sync()
  end
  self:AddRoundTimer(tbRound6.nAddBugTime, self.AddBug, self)
  self.nKillBugCount = 0
  self.bSaveGirl = 0
end

--地下钻出一只虫
function Round6:AddBug()
  local _, _, _, tbNpc = self:AddNpc("bug6", self.OnKillBug, self)
  local pNpc = tbNpc[1]
  local nGirl = self.tbGirls[MathRandom(1, #self.tbGirls)]
  local pGirl = KNpc.GetById(nGirl)
  if pGirl then
    local _, nX, nY = pGirl.GetWorldPos()
    pNpc.AI_ClearPath()
    pNpc.AI_AddMovePos(nX * 32, nY * 32)
    pNpc.GetTempTable("TreasureMap2").nRound6Girl = pGirl.dwId
    pNpc.GetTempTable("Npc").tbOnArrive = { self.OnBugArrive, self, pNpc.dwId }
    pNpc.SetNpcAI(9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
  else
    self:CreatFightFollow(nil, pNpc, 0, 50, 1, { self.OnBugLost, self })
    pNpc.SetLiveTime(tbRound6.nBugBoomTime + 18)
    self:AddRoundTimer(tbRound6.nBugBoomTime, self.BugBoom, self, pNpc.dwId)
  end
end

--打死一只虫子
function Round6:OnKillBug()
  self.nKillBugCount = self.nKillBugCount + 1
  if self.nKillBugCount == tbRound6.nKillBug then
    for _, nId in pairs(self.tbGirls) do
      local pGirl = KNpc.GetById(nId)
      if pGirl then
        pGirl.RemoveSkillState(1163)
        pGirl.Sync()
      end
    end
    self.bSaveGirl = 1 --可以救妹子了
    self.tbInstancing:SendBlackBoardMsgByTeam("禁锢似乎已经解除了，快去救人！")
  end
end

--虫子走到妹子处
function Round6:OnBugArrive(dwNpc)
  local pNpc = KNpc.GetById(dwNpc)
  if not pNpc then
    return
  end
  local nGirl = pNpc.GetTempTable("TreasureMap2").nRound6Girl
  local pGirl = KNpc.GetById(nGirl)
  if pGirl and pGirl.GetTempTable("TreasureMap2").bSave ~= 1 then
    pGirl.Delete()
    for n, nId in pairs(self.tbGirls) do
      if nId == nGirl then
        table.remove(self.tbGirls, n)
        break
      end
    end
  end
  if self.Finished ~= 1 then
    self:CreatFightFollow(nil, pNpc, 0, 50, 1, { self.OnBugLost, self })
    pNpc.SetLiveTime(self.tbInstancing.tbRound6.nBugBoomTime + 18)
    local _, nX, nY = pNpc.GetWorldPos()
    pNpc.CastSkill(1761, 60, nX * 32, nY * 32)
    --self:AddRoundTimer(self.tbInstancing.tbRound6.nBugBoomTime, self.BugBoom, self, pNpc.dwId);
    if #self.tbGirls == 0 then
      self:RoundEnd()
    end
  else
    pNpc.Delete()
  end
end
--虫子爆炸
function Round6:BugBoom(dwId)
  local pNpc = KNpc.GetById(dwId)
  if pNpc then
    local _, nX, nY = pNpc.GetWorldPos()
    pNpc.CastSkill(1762, 60, nX * 32, nY * 32)
  end
  return 0
end
--虫子迷路了
function Round6:OnBugLost(dwNpc)
  local pNpc = KNpc.GetById(dwNpc)
  if not pNpc then
    return
  end
  local tbPlayers = self.tbInstancing:GetPlayerList()
  local pPlayer = tbPlayers[MathRandom(1, #tbPlayers)]
  pNpc.SendChat(pPlayer.szName .. "不要跑！")
  self:ChangeFightFollow(pNpc, pPlayer)
end

--解救少女
function Round6:SaveGirl(nGirl)
  if self.tbInstancing:IsOpen() ~= 1 then
    return
  end
  if Round6.Finished == 1 then
    Dialog:Say("已经来不及了。。")
    return
  end
  local pGirl = KNpc.GetById(nGirl)
  if pGirl then
    pGirl.SendChat("多谢大侠相救！")
    pGirl.GetTempTable("TreasureMap2").bSave = 1
    pGirl.SetLiveTime(2 * 18)
    for n, nId in pairs(self.tbGirls) do
      if nId == nGirl then
        table.remove(self.tbGirls, n)
        break
      end
    end
    me.Msg("因为接触了少女，你已身中剧毒，需要等一段时间才能消除。")
    me.AddSkillState(tbRound6.nSavebuff, 1, 1, tbRound6.nSaveBuffTime, 1, 1)
    local nScore = self.tbInstancing:AddKillNpc(pGirl)
    self.tbInstancing:SendMsgByTeam(string.format("你的队伍解救了一个少女获得了<color=yellow>%d分<color>的战斗积分。", nScore))
    if #self.tbGirls == 0 then
      self:RoundEnd()
    end
  end
end

--时间到
function Round6:TimeOver()
  self:RoundEnd()
end

--结束
function Round6:End()
  Lib:CallBack({ self.tbTimer.Close, self.tbTimer })
  for n, nId in pairs(self.tbGirls) do
    local pGirl = KNpc.GetById(nId)
    if pGirl then
      pGirl.Delete()
    end
  end
  self.tbInstancing:CloseLimitTimer()
  self.tbInstancing:SendBlackBoardMsgByTeam("少女们或被救或被献祭，只是此生恐怕再无法忘却此地。")
end

----第七关第一部分
-- 开始
local Round7 = tbInstancing:GetRound(7)
function Round7:Begin(nType)
  self.tbInstancing:SendBlackBoardMsgByTeam("前方大殿一片死寂，除去中央诡异的灯座！")
  local _, _, _, tbNpc = self:AddNpc("light7", self.OnLight, self)
  tbNpc[1].SetNpcAI(9, 10, 0, 0, 0, 0, 0, 0, 0)
  local _, _, tbNpcId, tbNpcP = self:AddNpc("xiaoguai7", self.KillXiaoGuai, self)
  self.tbXiaoGuai = tbNpcId
  for _, pNpc in pairs(tbNpcP) do
    pNpc.SetCurCamp(0)
    pNpc.SetNpcAI(9, 0, 0, 0, 0, 0, 0, 0, 0)
  end
end
--打掉灯
function Round7:OnLight()
  for _, nNpcId in pairs(self.tbXiaoGuai) do
    local pNpc = KNpc.GetById(nNpcId)
    if pNpc then
      pNpc.SetCurCamp(5)
      pNpc.SetNpcAI(2)
    end
  end
  self.tbInstancing:SendBlackBoardMsgByTeam("灯座熄灭，周围的冥灵使突然朝你们攻击！")
end

--杀死小怪
function Round7:KillXiaoGuai(pNpc)
  self.tbInstancing:AddKillNpc(pNpc)
  for n, nNpcId in pairs(self.tbXiaoGuai) do
    if nNpcId == pNpc.dwId then
      table.remove(self.tbXiaoGuai, n)
    end
  end
  if #self.tbXiaoGuai == 0 then
    self:RoundEnd()
  end
end

--结束
function Round7:End()
  self.tbInstancing:SendBlackBoardMsgByTeam(" “哈哈，几年不见！”熟悉而亲切的声音，是故人？")
end

----第七关第二部分
-- 开始
local Round8 = tbInstancing:GetRound(8)
function Round8:Begin(nType)
  local _, _, _, tbPNpc = self:AddNpc("boss7", self.OnBossDead, self)
  self.pBoss = tbPNpc[1]
  local _, _, tbNpcId = self:AddNpc("boss7_deng")
  self.tbLightId = tbNpcId
  self:AddRoundTimer(tbRound7.nOnLight, self.TrunOnLight, self)
  self:NpcChat(self.pBoss, { "哈哈哈哈", "好小子，勿怪老夫不与你叙旧，要怪就怪阳关大道你不走，偏要来闯鬼门关！" })
  self.tbInstancing:SendBlackBoardMsgByTeam("……出现在眼前的，竟然是桃溪镇的老卦师……")
end
--BOSS死亡
function Round8:OnBossDead(pBoss)
  self.tbInstancing:AddKillBossNum(pBoss)
  self.tbInstancing:SendBlackBoardMsgByTeam("老卦师死前的笑容让人心惊，而桃溪镇下毒之事再无解答。")
  self:AddRoundTimer(5 * 18, self.RoundEnd, self)
end
--点灯
function Round8:TrunOnLight()
  local nN = MathRandom(1, #self.tbLightId)
  local nId = self.tbLightId[nN]
  local pNpc = KNpc.GetById(nId)
  if pNpc then
    local nMap, nX, nY = pNpc.GetWorldPos()
    pNpc.Delete()
    table.remove(self.tbLightId, n)
    local pLight = KNpc.Add2(tbRound7.nOnLightId, self.tbInstancing.nNpcLevel, 0, nMap, nX, nY)
    if pLight then
      Npc:RegPNpcOnDeath(pLight, self.OffLight, self)
    end
    self.tbInstancing:SendBlackBoardMsgByTeam("一盏灯悄悄燃起，隐秘的寒光翩然而至。")
  end
end

--显示队友伤害的黑条
function Round8:ShowBlack()
  self.tbInstancing:SendBlackBoardMsgByTeam("突然，你与队友的内力相互反噬！速速远离队友！")
end

--熄灯
function Round8:OffLight()
  local nMap, nX, nY = him.GetWorldPos()
  local pLight = KNpc.Add2(tbRound7.nOffLightId, 1, 0, nMap, nX, nY)
  if pLight then
    table.insert(self.tbLightId, pLight.dwId)
  end
end
--召唤小怪
function Round8:CallMonster()
  self:NpcChat(self.pBoss, { "出来吧！我的追随者！在桃溪镇你就早该死了！" })
  self.tbInstancing:SendBlackBoardMsgByTeam("跟随者出现，所有武功招式对老卦师无效了。")
  local _, _, _, tbPNpc = self:AddNpc("boss7_guai")
  local pNpc = tbPNpc[1]
  pNpc.GetTempTable("Npc").tbOnArrive = { self.MonsterDead, self, pNpc }
  pNpc.AI_AddMovePos(59072, 107232)
  pNpc.SetNpcAI(9, 0, 0, 0, 0, 0, 0, 0, 0)
  Npc:RegPNpcOnDeath(pNpc, self.MonsterDead, self)
  self.pBoss.AddSkillState(1850, 1, 0, 50 * 60 * 18, 0, 1, 0, 0, 1)
end
--小怪已死
function Round8:MonsterDead(pNpc)
  if pNpc then
    pNpc.Delete()
  end
  self.pBoss.RemoveSkillState(1850)
  self.pBoss.SendChat("啧，果真无用。老夫亲自送你们一程！")
end

-- 结束
function Round8:End()
  self.tbInstancing:MissionComplete()
end
