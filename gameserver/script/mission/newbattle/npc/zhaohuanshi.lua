-- 文件名　：zhaohuanshi.lua
-- 创建者　：LQY
-- 创建时间：2012-07-22 08:42:01
-- 说　　明：召唤师

local tbNpc = Npc:GetClass("NewBattle_zhaohuanshi")

function tbNpc:OnDialog()
  local nMapId = him.GetWorldPos()
  local tbMission = NewBattle.tbMission[nMapId]
  if not tbMission then
    NewBattle:MovePlayerOut(me)
    return
  end
  local tbInfo = him.GetTempTable("Npc")
  local nPower = nil
  if tbMission:IsOpen() == 1 then
    nPower = tbMission:GetPlayerGroupId(me)
  end
  if nPower == -1 or nPower ~= tbInfo.nPower then
    Dialog:Say("大胆！你是怎么混进我方大营的？！来人啊！！抓住他！")
    return
  end
  local szDialogMsg = "侠士，选择你想要去的地方，我可以把你传送过去。"
  local tbDialogOpt = {
    { "传送到<color=yellow>召唤石<color>", self.GoTransfer, self, nMapId },
    { "冰火天堑规则", self.Guize, self, nMapId },
    { "返回到报名点", self.GoBaoMingDian, self, nPower, nMapId },
  }
  if tbInfo.nIo == 0 then --大营召唤师
    table.insert(tbDialogOpt, { "传送到保护区", self.GoBackCamp, self })
  end
  table.insert(tbDialogOpt, { "只是看看" })
  Dialog:Say(szDialogMsg, tbDialogOpt)
end

--传送到前线
function tbNpc:GoTransfer(nMapId)
  local tbMission = NewBattle.tbMission[nMapId]
  if tbMission.nBattle_State ~= NewBattle.BATTLE_STATES.FIGHT then
    Dialog:Say("对不起，不在战斗阶段，无法传送。")
    return
  end
  local tbInfo = him.GetTempTable("Npc")
  local nPower = tbMission:GetPlayerGroupId(me)
  if nPower == -1 or nPower ~= tbInfo.nPower or tbMission.nTransStoneOwner ~= nPower then
    Dialog:Say("对不起，<color=yellow>召唤石<color>非我方占领，无法传送。")
    return
  end
  local tbPlayer = tbMission.tbCPlayers[me.nId]
  if not tbPlayer then
    Dialog:Say("来人啊！有细作！！")
    return
  end
  local n, nSec = tbPlayer:CanUseStone()
  if n == 0 then
    Dialog:Say(string.format("不要着急，你还需要等待<color=red>%d<color>秒才能进行传送。", nSec))
    return
  end
  GeneralProcess:StartProcess("传送到前线……", 5 * 18, { self.GoTransferProcess, self, me.nId, tbInfo.nPower, nMapId }, nil, NewBattle.tbCarrierBreakEvent)
end
--传送到前线读条回调
function tbNpc:GoTransferProcess(nPlayerId, nNpcPower, nMapId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return
  end
  local tbMission = NewBattle.tbMission[nMapId]
  local nPower = tbMission:GetPlayerGroupId(pPlayer)
  if nPower == -1 or nPower ~= nNpcPower or tbMission.nTransStoneOwner ~= nPower then
    Dialog:Say("对不起，<color=yellow>召唤石<color>非我方占领，无法传送。")
    return
  end
  me.SetFightState(1)
  me.Msg("冰与火的召唤~")
  Player:AddProtectedState(me, NewBattle.PLAYERPROTECTEDTIME)
  me.NewWorld(tbMission.nMapId, unpack(NewBattle:GetRandomPoint(NewBattle.POS_CHUANSONG)))
end

--回到报名点
function tbNpc:GoBaoMingDian(nPower, nMapId)
  me.SetFightState(0)
  --me.SetLogoutRV(0);
  NewBattle.tbMission[nMapId]:KickPlayer(me)
end

-- 战场规则
function tbNpc:Guize()
  Dialog:Say([[
		
				         <color=yellow>冰火天堑规则简介<color>	

 <color=yellow>·<color>开战后两边阵营会刷出<color=green>战车、箭塔、
   炮塔<color>载具，选中你要驾驶的载具，
   按<color=red>“N”键<color>可以快速上下载具。
   	   
 <color=yellow>·<color>中间区域有<color=green>召唤石<color>，占领方可在后
   营点击<color=green>召唤师<color>传送到召唤石位置。
   
 <color=yellow>·<color>击杀敌对<color=green>玩家、战车、炮塔<color>等可以
   获得战场<color=red>积分<color>，守卫本方<color=green>炮塔、龙
   脉<color>也可以获得战场积分。
   
 <color=yellow>·<color>玩家<color=red>无法攻击<color>敌方<color=green>箭塔、炮塔、龙
   脉<color>，只有<color=red>战车<color>才能攻击敌方<color=green>箭塔、
   炮塔、龙脉<color>。
   
 <color=yellow>·<color>任意方<color=yellow>龙脉<color>被摧毁，则战场结束，
   摧毁敌方龙脉的一方获得<color=red>胜利<color>。
   	  
 <color=yellow>·<color>开战时双方龙脉受<color=red>保护状态<color>无法被
   攻击，只有摧毁敌方炮塔，击杀<color=green>龙
   脉守护者<color>后才能攻击龙脉。
]])
end
