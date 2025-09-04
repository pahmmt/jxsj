-- 文件名　：dts_money.lua
-- 创建者　：jiazhenwei
-- 创建时间：2009-10-28 09:43:52
-- 描  述  ：大逃杀货币

local tbMoney = Item:GetClass("faguangtongqian")
tbMoney.szInfo = "货币交易给队友！"

function tbMoney:OnUse()
  --	local tbOpt = {
  --			{"交易给队友",	self.SelectPlayer, self},
  --			{"关闭"},
  --	};
  --
  --	Dialog:Say(self.szInfo,tbOpt);
  --
  self:SelectPlayer()
  return 0
end
function tbMoney:SelectPlayer()
  local tbOpt = {}
  local tbDialog = {}
  if me.nTeamId == 0 then
    return 0
  end

  if DaTaoSha:IsPlayerDeath(me) == 1 then
    me.Msg("您此时重伤，无力交易货币给队友。")
    return 0
  end

  local tbPlayerIdList = KTeam.GetTeamMemberList(me.nTeamId)
  for _, nPlayerId in pairs(tbPlayerIdList) do
    local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
    if pPlayer and pPlayer.szName ~= me.szName and DaTaoSha:IsPlayerDeath(pPlayer) == 0 then
      table.insert(tbDialog, { pPlayer.szName, self.Trade, self, pPlayer.nId })
    end
  end
  table.insert(tbDialog, { "关闭" })
  tbOpt = Lib:MergeTable(tbOpt, tbDialog)
  Dialog:Say(self.szInfo, tbOpt)
  return 0
end

function tbMoney:Trade(nId)
  local nMoneyNum = me.GetItemCountInBags(DaTaoSha.MONEY[1], DaTaoSha.MONEY[2], DaTaoSha.MONEY[3], DaTaoSha.MONEY[4], nil, -1)
  if nMoneyNum > 0 then
    Dialog:AskNumber("请交易给队友的数量", nMoneyNum, self.TradeEx, self, nId)
  else
    me.Msg("您的货币不足！")
  end
end

function tbMoney:TradeEx(nPlayerId, nCount)
  if nCount <= 0 then
    return 0
  end

  local nMoneyNum = me.GetItemCountInBags(DaTaoSha.MONEY[1], DaTaoSha.MONEY[2], DaTaoSha.MONEY[3], DaTaoSha.MONEY[4], nil, -1)
  if nMoneyNum < nCount then
    me.Msg("您的货币不足！")
    return 0
  end

  if DaTaoSha:IsPlayerDeath(me) == 1 then
    me.Msg("您此时重伤，无力交易货币给队友。")
    return 0
  end

  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if pPlayer then
    if DaTaoSha:IsPlayerDeath(pPlayer) == 1 then
      me.Msg("该队友此时重伤，不能交易货币给他。")
      return 0
    end
    local nAddCount = pPlayer.AddStackItem(DaTaoSha.MONEY[1], DaTaoSha.MONEY[2], DaTaoSha.MONEY[3], DaTaoSha.MONEY[4], nil, nCount)
    if nAddCount == 0 then
      me.Msg("对方背包已满，不能给对方寒武符石!")
      return
    end
    local szMsg = string.format("队友<color=yellow>%s<color>交易给<color=yellow>%s<color> %s 枚寒武符石！", me.szName, pPlayer.szName, nAddCount)
    KTeam.Msg2Team(me.nTeamId, szMsg)
    me.ConsumeItemInBags2(nAddCount, DaTaoSha.MONEY[1], DaTaoSha.MONEY[2], DaTaoSha.MONEY[3], DaTaoSha.MONEY[4], nil, -1)
  end
end
