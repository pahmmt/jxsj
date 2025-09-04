-- 文件名　：guoqing2012_item_c.lua
-- 创建者　：huangxiaoming
-- 创建时间：2012-09-18 09:31:20
-- 描  述  ：

if not MODULE_GAMECLIENT then
  return
end
local tbItemLantern = Item:GetClass("guoqing2012_lantern")

function tbItemLantern:GetTip()
  local nTask = me.GetTask(2027, 255)
  local szMapName = GetMapNameFormId(nTask) or ""
  local szTip = string.format("<color=green>指定地点：%s<color>", szMapName)
  return szTip
end

local tbItemMoonCake = Item:GetClass("guoqing2012_mooncake")

function tbItemMoonCake:GetTip()
  local nTask = me.GetTask(2027, 255)
  local szName = Player:GetFactionRouteName(nTask) or ""
  local szTip = string.format("<color=green>指定门派：%s<color>", szName)
  return szTip
end

local tbItemHuiLiuBook = Item:GetClass("guoqing2012_huiliubook")

function tbItemHuiLiuBook:GetTip()
  local nTaskValue = me.GetTask(2027, 259)
  local tbInfo = {
    [1] = "欢度国庆·一马当先",
    [2] = "欢度国庆·两全其美",
    [3] = "欢度国庆·三星在天",
    [4] = "欢度国庆·四海升平",
    [5] = "欢度国庆·五谷丰登",
  }
  for i = 1, 5 do
    if i > 1 then
      nTaskValue = math.floor(nTaskValue / 10)
    end
    local nFlag = math.mod(nTaskValue, 10)
    if nFlag == 1 then
      tbInfo[i] = string.format("<color=green>%s<color>", tbInfo[i])
    elseif nFlag == 2 then
      tbInfo[i] = string.format("<color=red>%s<color>", tbInfo[i])
    end
  end
  local szMsg = ""
  for i = 1, 5 do
    szMsg = szMsg .. tbInfo[i] .. "\n"
  end
  return szMsg
end
