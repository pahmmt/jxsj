-- 文件名　：guanggun_item_c.lua
-- 创建者　：LQY
-- 创建时间：2012-10-30 11:21:26
-- 说　　明：光棍节物品 客户端
if not MODULE_GAMECLIENT then
  return
end
Require("\\script\\event\\jieri\\201211_guanggunjie\\guanggun_def.lua")
local tbGuangGun = SpecialEvent.GuangGun2012

---爱神箭
local tbItemLoveArrow = Item:GetClass("2012guanggun_lovearrow")
function tbItemLoveArrow:OnClientUse()
  local pNpc = me.GetSelectNpc()
  if not pNpc then
    return 0
  end
  return pNpc.dwId
end
function tbItemLoveArrow:GetTip()
  local nTimes = me.GetTask(tbGuangGun.TASK_GROUP, tbGuangGun.LOVEARROW_COUNT)
  local szMsg = string.format("你已经使用了<color=yellow>%s<color>次，还需要使用<color=yellow>%s<color>次。\n<color=red>(%d/3)<color>", Lib:TransferDigit2CnNum(nTimes), Lib:TransferDigit2CnNum(3 - nTimes), nTimes)
  if nTimes == 3 then
    szMsg = szMsg .. "\n<color=yellow>今天的使用次数已满，右击道具将会消失<color>"
  end
  return szMsg
end

---歌曲
local tbItemSong = Item:GetClass("2012guanggun_song")
function tbItemSong:GetTip()
  local szMsg = ""
  local nH = 0
  local nLightCount = 0
  for n, nId in pairs(tbGuangGun.LIGHTNPC) do
    local nLight = me.GetTask(tbGuangGun.TASK_GROUP, nId)
    local nTxt = ""
    if nLight == 1 then
      nLightCount = nLightCount + 1
      nTxt = "<color=yellow>" .. tbGuangGun.NPCS_NAME[n] .. "<color>"
    else
      nTxt = tbGuangGun.NPCS_NAME[n]
    end
    if nH == 2 then
      szMsg = szMsg .. "\n    " .. nTxt
      nH = 1
    else
      szMsg = szMsg .. "    " .. nTxt
      nH = nH + 1
    end
  end
  if nLightCount == 9 then
    szMsg = szMsg .. "\n\n<color=red>你已经点亮所有名字，右击本道具可以领奖了<color>"
  else
    szMsg = szMsg .. "    \n<color=red>(" .. nLightCount .. "/9)<color>"
  end
  return szMsg
end
