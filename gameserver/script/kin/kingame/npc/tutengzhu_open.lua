local tbNpc = Npc:GetClass("tulengzhu_open")

function tbNpc:OnDialog()
  self:OnSwitch(him.dwId)
end

local tbEvent = {
  Player.ProcessBreakEvent.emEVENT_MOVE,
  Player.ProcessBreakEvent.emEVENT_ATTACK,
  Player.ProcessBreakEvent.emEVENT_SITE,
  Player.ProcessBreakEvent.emEVENT_USEITEM,
  Player.ProcessBreakEvent.emEVENT_ARRANGEITEM,
  Player.ProcessBreakEvent.emEVENT_DROPITEM,
  Player.ProcessBreakEvent.emEVENT_SENDMAIL,
  Player.ProcessBreakEvent.emEVENT_TRADE,
  Player.ProcessBreakEvent.emEVENT_CHANGEFIGHTSTATE,
  Player.ProcessBreakEvent.emEVENT_CLIENTCOMMAND,
  Player.ProcessBreakEvent.emEVENT_LOGOUT,
  Player.ProcessBreakEvent.emEVENT_DEATH,
  Player.ProcessBreakEvent.emEVENT_ATTACKED,
}

function tbNpc:OnSwitch(nNpcId)
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    return 0
  end
  local tbTmp = pNpc.GetTempTable("KinGame")
  if tbTmp.OnOpenFlag ~= nil then
    Dialog:SendBlackBoardMsg(me, "这个柱子的机关已经被人开动过了。")
    return 0
  end
  if tbTmp.tbLockTable and tbTmp.tbLockTable.tbRoom.nRoomId == 1 then
    local tbFind = me.FindItemInBags(unpack(KinGame.OPEN_KEY_ITEM))
    if #tbFind < 1 then
      return 0
    end
    local nCount = tbTmp.tbLockTable.tbRoom.tbGame:GetPlayerCount()
    if nCount < KinGame.MIN_PLAYER then
      Dialog:SendBlackBoardMsg(me, "现在人手还不够，还是再等一会吧")
      return 0
    end
    if bConfirm ~= 1 then
      Dialog:Say("这个奇怪的柱子上有个钥匙孔，旁边潦草的写着：“经过我仔细的观察，这根东西是开启前面的门用的，不过开启后进来的路就会关闭。但是奇怪的是就算不用钥匙一段时间后这个机关也会自己开启，这又是为什么呢？<color=red>开启后外面的家族成员就不能进入了", {
        { "插钥匙进去试试", self.DoOnSwitch, self, nNpcId },
        { "结束对话" },
      })
      return 0
    end
  end
  GeneralProcess:StartProcess("开启中...", 30 * Env.GAME_FPS, { self.DoOnSwitch, self, nNpcId }, nil, tbEvent)
end

function tbNpc:DoOnSwitch(nNpcId)
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    return 0
  end
  local tbTmp = pNpc.GetTempTable("KinGame")
  if tbTmp.OnOpenFlag ~= nil then
    return 0
  end
  if tbTmp.tbLockTable and tbTmp.tbLockTable.tbRoom.nRoomId == 1 then
    local tbFind = me.FindItemInBags(unpack(KinGame.OPEN_KEY_ITEM))
    if #tbFind < 1 then
      return 0
    end
    me.DelItem(tbFind[1].pItem, Player.emKLOSEITEM_TYPE_EVENTUSED)
  end
  local tbTmp = pNpc.GetTempTable("KinGame")
  tbTmp.OnOpenFlag = 1
  Dialog:SendBlackBoardMsg(me, "你听到了“咔！”的一声脆响。")
  KinGame:NpcUnLockMulti(pNpc)
end
