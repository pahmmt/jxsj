--
-- FileName: qingming_c.lua
-- Author: lqy
-- Time: 2012/3/22 16:53
-- Comment: 2012清明节英魂简客户端变现
--
local tbItem = Item:GetClass("qingming_yinghunjian_2012")
local tbTask = { 9, 10, 11, 12, 13, 14, 15, 16 }
local tbCity = {
  "云中镇",
  "龙门镇",
  "永乐镇",
  "稻香村",
  "江津村",
  "石鼓镇",
  "龙泉村",
  "巴陵县",
}

function tbItem:GetTip()
  local szTip = ""
  local nHighCount = 0
  local nH = 1
  for n, szName in pairs(tbCity) do
    local szCh = (nH == 5) and "\n " or " "
    local nV = me.GetTask(2192, tbTask[n])
    if nV == 1 then
      szTip = szTip .. szCh .. "<color=yellow>[" .. szName .. "]<color>"
      nHighCount = nHighCount + 1
    else
      szTip = szTip .. szCh .. "<color=gray>[" .. szName .. "]<color>"
    end
    if nH == 5 then
      nH = 1
    else
      nH = nH + 1
    end
  end
  szTip = szTip .. "\n<color=gold>(" .. nHighCount .. "/8)<color>"
  if nHighCount == 8 then
    szTip = szTip .. "\n\n <color=red>(你已完成本日所有祭祀，右击领取奖励吧!)<color>"
  else
    szTip = szTip .. "\n\n   <color=red>(尚未完成本日所有祭祀,加油哦！)<color>"
  end
  return szTip
end
