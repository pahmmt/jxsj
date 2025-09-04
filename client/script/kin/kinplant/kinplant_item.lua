-- 文件名　：kinplant_item.lua
-- 创建者　：jiazhenwei
-- 创建时间：2011-10-12 17:23:39
-- 功能    ：道具相关

local tbSeed = Item:GetClass("KinPlantSeed")

function tbSeed:OnUse()
  --time
  if KinPlant:GetState() == 0 then
    Dialog:Say("不在活动期。", { "知道了" })
    return 0
  end
  --level
  if me.nLevel < KinPlant.nAttendMinLevel then
    Dialog:Say(string.format("您等级不足%s级，是不能种植的！", KinPlant.nAttendMinLevel), { "知道了" })
    return 0
  end
  if me.nFaction == 0 then
    Dialog:Say("您还是先入门派吧。", { "知道了" })
    return 0
  end
  self:PlantTree(me, it.dwId)
  return 0
end

function tbSeed:PlantTree(pPlayer, dwItemId)
  local pItem = KItem.GetObjById(dwItemId)
  if not pItem then
    Dialog:Say("你的种子过期了。")
    return
  end

  local nRes, szMsg = KinPlant:CanPlantTree(pPlayer, pItem)
  if nRes == 1 then
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
    }
    GeneralProcess:StartProcess("种植中...", 3 * Env.GAME_FPS, { KinPlant.Plant1stTree, KinPlant, pPlayer, dwItemId }, nil, tbEvent)
  elseif szMsg then
    Dialog:Say(szMsg)
  end
end

function tbSeed:GetTip()
  local nIndex = tonumber(it.GetExtParam(1))
  if not nIndex or not KinPlant.tbPlantNpcInfo[nIndex] then
    return "这粒种子已经过期。"
  end
  local tbName = { "粮食", "水果", "鲜花" }
  local tbTypeInfo = { "经验较多", "玄晶较多", "绑银较多" }
  local tbWeather = { "雨天", "烈日", "雪天" }
  local tbGrade = KinPlant.tbPlantNpcInfo[nIndex].tbGrade
  local nType = KinPlant.tbPlantNpcInfo[nIndex].nType
  local tbExp = KinPlant.tbPlantNpcInfo[nIndex].tbExp
  local tbWeatherInfo = KinPlant.tbPlantNpcInfo[nIndex].tbWeather
  local nDredging = KinPlant.tbPlantNpcInfo[nIndex].nDredging
  local nMaxAwardCount = KinPlant.tbPlantNpcInfo[nIndex].nMaxAwardCount
  local tbTime = KinPlant.tbPlantNpcInfo[nIndex].tbTime
  local nChengzhang = 0
  local nChengshu = tbTime[#tbTime]
  for i = 1, #tbTime - 1 do
    nChengzhang = nChengzhang + tbTime[i]
  end
  local tbDredgingFigure = { [0] = "不可以被铲掉", [1] = "族长", [2] = "副族长以上", [3] = "正式成员以上", [4] = "荣誉成员以上", [5] = "所有成员" }
  local szMsg = ""
  local nExpMsg = ""
  local nWeatherMsg = ""
  szMsg = szMsg .. "<color=blue>" .. tbName[nType] .. "类\n\n<color>"
  for i = 1, 3 do
    local szColor = "green"
    local szColorExp = "White"
    if tbGrade[i] and tbGrade[i] > 0 then
      if me.GetReputeLevel(14, i) < tbGrade[i] then
        szColor = "red"
      end
      if it.GetGenInfo(1) ~= 1 then
        szMsg = szMsg .. string.format("<color=%s>专精需求：%s专精（%s级）<color>\n", szColor, tbName[i], tbGrade[i])
      end
      if me.GetReputeLevel(14, i) ~= tbGrade[i] then
        szColorExp = "gray"
      end
    end
    if tbExp[i] > 0 then
      nExpMsg = nExpMsg .. string.format("专精成长：<color=%s>%s <color> \n", szColorExp, tbName[i])
    end
    local szInfo = ""
    local szWeatherColor = ""
    if tbWeatherInfo[i] < 0 then
      szInfo = "降产"
      szWeatherColor = "red"
    elseif tbWeatherInfo[i] > 0 then
      szInfo = "增产"
      szWeatherColor = "green"
    end
    if szInfo ~= "" and szColor ~= "" then
      nWeatherMsg = nWeatherMsg .. string.format("<color=%s>天气状况：%s（%s）<color>\n", szWeatherColor, tbWeather[i], szInfo)
    end
  end
  if it.GetGenInfo(1) == 1 then
    szMsg = szMsg .. "<color=green>订单作物不需求种植专精\n<color>"
  end
  szMsg = szMsg .. "\n"
  szMsg = szMsg .. nExpMsg
  szMsg = szMsg .. nWeatherMsg
  --szMsg = szMsg..string.format("其他人铲除：%s\n", tbDredgingFigure[nDredging]);
  szMsg = szMsg .. string.format("普通最大产量：%s\n", nMaxAwardCount)
  szMsg = szMsg .. string.format("奖励比重：%s\n", tbTypeInfo[nType])
  szMsg = szMsg .. string.format("成长时间：%s时%s分%s秒\n", Lib:TransferSecond2NormalTime(nChengzhang))
  szMsg = szMsg .. string.format("成熟时长：%s时%s分%s秒\n", Lib:TransferSecond2NormalTime(nChengshu))
  return szMsg
end
