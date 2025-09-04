-------------------------------------------------------------------
--File: jbexchange_client.lua
--Author: ZouYing
--Date: 2008-3-6
--Describe: 金币交易所客户端的逻辑
-------------------------------------------------------------------
if not JbExchange then
  JbExchange = {}
end

JbExchange.IsClose = 0
JbExchange.nAvgPrice = 100

-- 同步玩家的交易单
function JbExchange:SyncPlayerBillInfo(tbPlayerInfo)
  me.SetPlayerBillInfo(tbPlayerInfo)
  CoreEventNotify(UiNotify.emCOREEVENT_UPDATE_PLAYERBILLINFO)
end

-- 同步交易所内的交易单信息
function JbExchange:SyncShowBillList(tbInfo, tbShowList)
  me.SetShowBillList(tbInfo, tbShowList)
  CoreEventNotify(UiNotify.emCOREEVENT_UPDATE_SHOWBILLLIST)
end

function JbExchange:GetBClose(bClose)
  JbExchange.IsClose = bClose
end

function JbExchange:SetPrvAvgPrice(nPrvPrice)
  self.nAvgPrice = nPrvPrice
end

function JbExchange:MsgToChangeCoin(nCoin)
  local szMsg = "<color=red>有" .. nCoin .. "的绑定金币转到你的帐号中。<color>"
  --UiManager:OpenWindow(Ui.UI_INFOBOARD, szMsg);
  me.Msg(szMsg)
end

function JbExchange:CanOpenJbExchange(nCanOpen)
  if nCanOpen and 1 == nCanOpen then
    UiManager:OpenWindow(Ui.UI_JBEXCHANGE)
  else
    me.Msg("当前地图不允许操作金币交易所。")
  end
end
