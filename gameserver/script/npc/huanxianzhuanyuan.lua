-- 文件名　：huanxianzhuanyuan.lua
-- 创建者　：jiazhenwei
-- 创建时间：2011-10-26 14:24:10
-- 功能    ：

local tbNpc = Npc:GetClass("huanxianzhuanyuan")

if not MODULE_GAMESERVER then
  return
end

tbNpc.tbMap = {
  [1] = { 2115, "灵秀村（1线）" },
  [2] = { 2116, "灵秀村（2线）" },
  [3] = { 2117, "灵秀村（3线）" },
  [4] = { 2118, "灵秀村（4线）" },
  [5] = { 2119, "灵秀村（5线）" },
  [6] = { 2120, "灵秀村（6线）" },
  [7] = { 2121, "灵秀村（7线）" },
}

tbNpc.tbMap2 = {
  [1] = { 2154, "桃溪镇（1线）" },
  [2] = { 2254, "桃溪镇（2线）" },
  [3] = { 2255, "桃溪镇（3线）" },
  [4] = { 2256, "桃溪镇（4线）" },
  [5] = { 2257, "桃溪镇（5线）" },
  [6] = { 2258, "桃溪镇（6线）" },
  [7] = { 2259, "桃溪镇（7线）" },
}

function tbNpc:OnDialog()
  local szMsg = "千嶂横叠阡陌重，谁知身在灵秀中。大侠若嫌此村喧闹，小女可送大侠到另一处灵秀村，大侠想去哪一处呢？"
  local tbOpt = {}
  local nMapType = 0
  for _, tb in ipairs(self.tbMap) do
    if tb[1] ~= me.nMapId then
      table.insert(tbOpt, { tb[2], self.ChangeMap, self, tb[1], 1609, 3268 })
    elseif tb[1] == me.nMapId then
      nMapType = 1
    end
  end

  if nMapType == 0 then
    tbOpt = {}
  end

  local nMapId, nX, nY = me.GetWorldPos()
  for _, tb in ipairs(self.tbMap2) do
    if tb[1] ~= me.nMapId then
      if (nX - 1814) * (nX - 1814) + (nY - 3476) * (nY - 3476) < 100 then
        table.insert(tbOpt, { tb[2], self.ChangeMap, self, tb[1], 1812, 3472 })
      else
        table.insert(tbOpt, { tb[2], self.ChangeMap, self, tb[1], 1678, 3236 })
      end
    end
  end

  if me.GetTask(2027, 230) == 1 or me.GetTask(1000, 528) == 747 then
    table.insert(tbOpt, { "返回云中镇", self.ComeBackYunZhong, self })
  end

  table.insert(tbOpt, { "我再想想" })
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:ChangeMap(nMapId, nX, nY)
  me.NewWorld(nMapId, nX, nY)
end

function tbNpc:ComeBackYunZhong()
  me.NewWorld(1, 1386, 3100)
end
