local tbMapId = {
  167,
  168,
  169,
  170,
  171,
  172,
  173,
  174,
  175,
  176,
  177,
  178,
  179,
  180,
  181,
  182,
  183,
  184,
  185,
  186,
  187,
  188,
  189,
  190,
  191,
  192,
  193,
  194,
  195,
  399,
  1635,
  1636,
  1637,
  1638,
  1639,
  1640,
  1641,
  1642,
  1643,
} --ID bản đồ không thể mở
local tbMapTempId = { 557, 560 } -- ID mẫu bản đồ cấm mở thư

Mail.tbc2sFun = {}
Mail.tbMapIdKey = {}
Mail.tbMapTempIdKey = {}
local tbMapIdNoSend = { -- Bản đồ cấm gửi thư
  [1497] = 1,
  [1498] = 1,
  [1499] = 1,
  [1500] = 1,
  [1501] = 1,
  [1502] = 1,
  [1503] = 1,
}
local tbMapIdNoFetch = { -- Bản đồ cấm nhận tệp đính kèm
  [1497] = 1,
  [1498] = 1,
  [1499] = 1,
  [1500] = 1,
  [1501] = 1,
  [1502] = 1,
  [1503] = 1,
}

for i, v in ipairs(tbMapId) do
  Mail.tbMapIdKey[v] = 1
end

for i, v in ipairs(tbMapTempId) do
  Mail.tbMapTempIdKey[v] = 1
end

function Mail:AcceptApplyOpen()
  local nAccept = self:ForbitManger()
  me.CallClientScript({ "Mail:OnAcceptOpen", nAccept })
end
Mail.tbc2sFun["ApplyOpen"] = Mail.AcceptApplyOpen

function Mail:AcceptApplyOpenNewMail()
  if self:ForbitManger() == 0 or tbMapIdNoSend[me.nMapId] then
    me.Msg("Bản đồ hiện tại không thể tạo thư mới!")
    return
  end

  me.CallClientScript({ "Mail:OnAcceptOpenNewMail" })
end
Mail.tbc2sFun["ApplyOpenNewMail"] = Mail.AcceptApplyOpenNewMail

function Mail:CheckMailUsable(pPlayer)
  if not pPlayer then
    return 0
  end

  local szMap = GetMapType(pPlayer.nMapId)
  if Map.tbMapItemState[szMap] and (Map.tbMapItemState[szMap].tbForbiddenUse["MAIL"] or Map.tbMapItemState[szMap].tbForbiddenUse["ALL_ITEM"]) then
    return 0
  end

  return 1
end

function Mail:OnFetchItemProcess(nMailId, nItemIndex)
  assert(type(nMailId) == "number")
  assert(math.ceil(nMailId) == math.floor(nMailId))
  assert(type(nItemIndex) == "number")
  assert(nItemIndex >= 0)
  if 0 == me.nFightState then
    self:MailFetchItem(nMailId, nItemIndex)
    return
  end
  local tbEvent = {
    Player.ProcessBreakEvent.emEVENT_MOVE,
    Player.ProcessBreakEvent.emEVENT_ATTACK,
    Player.ProcessBreakEvent.emEVENT_USEITEM,
    Player.ProcessBreakEvent.emEVENT_ARRANGEITEM,
    Player.ProcessBreakEvent.emEVENT_DROPITEM,
    Player.ProcessBreakEvent.emEVENT_SENDMAIL,
    Player.ProcessBreakEvent.emEVENT_TRADE,
    Player.ProcessBreakEvent.emEVENT_CHANGEFIGHTSTATE,
    Player.ProcessBreakEvent.emEVENT_ATTACKED,
    Player.ProcessBreakEvent.emEVENT_CLIENTCOMMAND,
  }
  GeneralProcess:StartProcess("Đang nhận tệp đính kèm...", 3 * Env.GAME_FPS, { self.MailFetchItem, self, nMailId, nItemIndex }, nil, tbEvent)
end
Mail.tbc2sFun["ApplyProcess"] = Mail.OnFetchItemProcess

function Mail:MailFetchItem(nMailId, nItemIndex)
  if self:ForbitManger() == 0 or tbMapIdNoFetch[me.nMapId] then
    me.Msg("Bản đồ hiện tại không thể nhận tệp đính kèm!")
    return
  elseif me.MailFetchItem(nMailId, nItemIndex) == 1 then
    me.Msg("Nhận tệp đính kèm thành công!")
  else
    me.Msg("Nhận tệp đính kèm thất bại!")
  end
end

function Mail:ForbitManger(pPlayer)
  if not pPlayer then
    pPlayer = me
  end

  if self.tbMapIdKey[pPlayer.nMapId] and 1 == self.tbMapIdKey[pPlayer.nMapId] then
    return 0
  end

  local nMapIndex = SubWorldID2Idx(pPlayer.nMapId)
  local nMapTemplateId = SubWorldIdx2MapCopy(nMapIndex)
  if nMapTemplateId <= 0 or (self.tbMapTempIdKey[nMapTemplateId] and 1 == self.tbMapTempIdKey[nMapTemplateId]) then
    return 0
  end

  if self:CheckMailUsable(pPlayer) ~= 1 then
    return 0
  end

  return 1
end

function Mail:CanSendMail(pPlayer)
  if not pPlayer then
    return 0
  end
  if pPlayer.IsAccountLock() ~= 0 then
    pPlayer.Msg("Tài khoản của bạn hiện đang bị khóa, không thể gửi thư.")
    Account:OpenLockWindow(pPlayer)
    return 0
  end
  if Account:Account2CheckIsUse(pPlayer, 5) == 0 then
    pPlayer.Msg("Bạn đang đăng nhập bằng mật khẩu phụ, đã thiết lập kiểm soát quyền, không thể thực hiện thao tác này!")
    return 0
  end
  if pPlayer.GetArrestTime() > 0 then
    pPlayer.Msg("Bản đồ bạn đang ở không cho phép gửi thư.")
    return 0
  end
  if self:ForbitManger(pPlayer) == 0 then
    pPlayer.Msg("Bản đồ này cấm gửi thư.")
    return 0
  end
  return 1
end
