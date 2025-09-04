--军营令牌
--孙多良
--2008.08.19

local tbItem = Item:GetClass("army_token")
tbItem.tbItemId = {
  [606] = 0, --单次
  [607] = 1, --无限军营令牌
  [195] = 1, --无限传送符
  [235] = 1,
}
-- （此表会被其它模块引用）
tbItem.tbTransMap = {
  { "军营【凤翔】", 24, 1917, 3444 },
  { "军营【襄阳】", 25, 1464, 3061 },
  { "军营【临安】", 29, 1606, 4139 },
}
tbItem.nTime = 5

-- （此函数会被其它模块调用）
function tbItem:OnUse()
  local szMsg = "请选择您想前往的军营，如需前往<color=yellow>伏牛山军营<color>请前往<color=green>新手村军营传送官<color>处传送。"
  local tbOpt = {}
  for i, tbItem in ipairs(self.tbTransMap) do
    table.insert(tbOpt, { tbItem[1], self.OnTrans, self, it.dwId, i, 0 })
  end

  Lib:SmashTable(tbOpt)

  table.insert(tbOpt, { "结束对话" })
  Dialog:Say(szMsg, tbOpt)
end

function tbItem:OnTrans(nItemId, nTransId, nWithOutItem)
  local pPlayer = me

  if pPlayer.nLevel < 60 then
    pPlayer.Msg("未满60级玩家不能进入军营")
    return
  end
  local tbEvent = { -- 会中断延时的事件
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
  if 0 == pPlayer.nFightState then -- 玩家在非战斗状态下传送无延时正常传送
    self:TransSure(nItemId, nTransId, pPlayer.nId, nWithOutItem)
    return 0
  end

  GeneralProcess:StartProcess("正在传送去军营...", self.nTime * Env.GAME_FPS, { self.TransSure, self, nItemId, nTransId, pPlayer.nId, nWithOutItem }, nil, tbEvent) -- 在战斗状态下需要nTime秒的延时
end

function tbItem:TransSure(nItemId, nTransId, nPlayerId, nWithOutItem)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if nWithOutItem ~= 1 then
    local pItem = KItem.GetObjById(nItemId)
    if not pItem or not pPlayer then
      return 0
    end
    if self.tbItemId[pItem.nParticular] ~= 1 then
      local nCount = pItem.nCount
      if nCount <= 1 then
        if pPlayer.DelItem(pItem, Player.emKLOSEITEM_USE) ~= 1 then
          pPlayer.Msg("删除传送符失败！")
          return 0
        end
      else
        pItem.SetCount(nCount - 1, Item.emITEM_DATARECORD_REMOVE)
        pItem.Sync()
      end
    end
  end
  pPlayer.NewWorld(self.tbTransMap[nTransId][2], self.tbTransMap[nTransId][3], self.tbTransMap[nTransId][4])
end
