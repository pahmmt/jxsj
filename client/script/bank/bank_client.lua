-- 文件名　：bank_client.lua
-- 创建者　：furuilei
-- 创建时间：2008-11-25 19:01:53

-- 更新银两区信息
function Bank:UpdateInfo(nChangeCoin)
  if nChangeCoin then
    if nChangeCoin > 0 then
      me.Msg("您成功存入" .. nChangeCoin .. "个金币")
    elseif nChangeCoin < 0 then
      me.Msg("您成功取出" .. math.abs(nChangeCoin) .. "个金币")
    end
  end
  CoreEventNotify(UiNotify.emCOREEVENT_UPDATEBANKINFO)
end

-- 玩家登录的提示信息
function Bank:LoginMsg()
  local nGoldEfficientTime = me.GetTask(Bank.TASK_GROUP, Bank.TASK_ID_GOLD_EFFICIENT_DAY)
  local nSilverEfficientTime = me.GetTask(Bank.TASK_GROUP, Bank.TASK_ID_SILVER_EFFICIENT_DAY)
  local nTime = GetTime()
  if nTime < nGoldEfficientTime then
    local szMsg = "请注意：您在钱庄有一个未生效的金币支取上限。"
    me.Msg(szMsg)
  end
  if nTime < nSilverEfficientTime then
    local szMsg = "请注意：您在钱庄有一个未生效的银两支取上限。"
    me.Msg(szMsg)
  end
end
