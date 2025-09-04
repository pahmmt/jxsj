-- 文件名　：dragonboatfestival_item_c.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-06-07 17:29:23
-- 功能    ：

SpecialEvent.tbDragonBoatFestival2012 = SpecialEvent.tbDragonBoatFestival2012 or {}
local tbDragonBoatFestival2012 = SpecialEvent.tbDragonBoatFestival2012

local tbBook = Item:GetClass("DragonB2012_book")

function tbBook:OnClientUse()
  local nRet, szMsg = tbDragonBoatFestival2012:CheckTime()
  if nRet == 0 then
    Dialog:Say(szMsg)
    return
  end
  local tbOpt = { "我再想想" }
  local tbPosition = tbDragonBoatFestival2012.tbPosition
  local nDayNow = tonumber(GetLocalDate("%Y%m%d"))
  local nPosition = 0
  local nDay = me.GetTask(tbDragonBoatFestival2012.TASKID_GROUP, tbDragonBoatFestival2012.TASKID_TIME)
  for i = tbDragonBoatFestival2012.TASKID_POSITION_START, tbDragonBoatFestival2012.TASKID_POSITION_END do
    local nFlag = me.GetTask(tbDragonBoatFestival2012.TASKID_GROUP, i)
    if nDay ~= nDayNow then
      nFlag = 0
    end
    if nFlag == 0 then
      nPosition = nPosition + 1
      local tb = tbPosition[i - tbDragonBoatFestival2012.TASKID_POSITION_START + 1]
      table.insert(tbOpt, 1, { tb[4], self.AutoPath, self, tb[5] })
    end
  end
  if nPosition > 0 then
    Dialog:Say("请选择您要去的投粽子点：", tbOpt)
  else
    Dialog:Say("您今天端午投粽子活动已经做完了，还是休息下明天再来吧。")
  end
  return
end

function tbBook:AutoPath(tbPositon)
  Ui.tbLogic.tbAutoPath:GotoPos({ nMapId = tbPositon[1], nX = tbPositon[2], nY = tbPositon[3] })
end

function tbBook:GetTip()
  local szTip = "已经投过粽子的地点：\n"
  local tbPosition = tbDragonBoatFestival2012.tbPosition
  local nDayNow = tonumber(GetLocalDate("%Y%m%d"))
  local nDay = me.GetTask(tbDragonBoatFestival2012.TASKID_GROUP, tbDragonBoatFestival2012.TASKID_TIME)
  local nCount = 0
  for i = tbDragonBoatFestival2012.TASKID_POSITION_START, tbDragonBoatFestival2012.TASKID_POSITION_END do
    local nFlag = me.GetTask(tbDragonBoatFestival2012.TASKID_GROUP, i)
    if nDay ~= nDayNow then
      nFlag = 0
    end
    if nFlag == 1 then
      local tb = tbPosition[i - tbDragonBoatFestival2012.TASKID_POSITION_START + 1]
      szTip = szTip .. string.format("<color=green>%-20s<color>", tb[4])
      nCount = nCount + 1
      if math.fmod(nCount, 2) == 0 then
        szTip = szTip .. "\n"
      end
    end
  end
  if nCount == tbDragonBoatFestival2012.TASKID_POSITION_END - tbDragonBoatFestival2012.TASKID_POSITION_START + 1 then
    szTip = "<color=red>您今天投了15个粽子，已达上限。<color>"
  end
  return szTip
end
