-- 文件名　：globalstat.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-10-11 09:59:21
-- 描述：全局统计表封装接口，需要先定义在使用
--\setting\player\globalstatlist.txt

if not MODULE_GC_SERVER then
  return
end

Globalstat.tbList = {}

function Globalstat:Init()
  local tbData = Lib:LoadTabFile("\\setting\\player\\globalstatlist.txt", { Id = 1 })
  if not tbData then
    print("全局表统计文件读取失败，\\setting\\player\\globalstatlist.txt")
    return
  end
  for _, tbRow in ipairs(tbData) do
    if self.tbList[tbRow.PrimeKey] and self.tbList[tbRow.PrimeKey][tbRow.SubKey] then
      print("全局表统计key值重复\\setting\\player\\globalstatlist.txt")
    end
    self.tbList[tbRow.PrimeKey] = self.tbList[tbRow.PrimeKey] or {}
    self.tbList[tbRow.PrimeKey][tbRow.SubKey] = tbRow.Format
  end
end

Globalstat:Init()

--查数据表
--nType: 0为统计表, 1为结果表
function Globalstat:Query(nType, szPrimeKey, szSubKey, szAccount, szPlayerName)
  if not self.tbList[szPrimeKey] or not self.tbList[szPrimeKey][szSubKey] then
    assert("invalid key: " .. szPrimeKey .. "," .. szSubKey)
  end
  return GlobalStatQuery(nType, szPrimeKey, szSubKey, szAccount or "", szPlayerName or "", self.tbList[szPrimeKey][szSubKey])
end

--删数据表
--nType: 0为统计表, 1为结果表
function Globalstat:Remove(nType, szPrimeKey, szSubKey, szAccount, szPlayerName)
  if not self.tbList[szPrimeKey] or not self.tbList[szPrimeKey][szSubKey] then
    assert("invalid key: " .. szPrimeKey .. "," .. szSubKey)
  end
  return GlobalStatRemove(nType, szPrimeKey, szSubKey, szAccount, szPlayerName)
end

--写数据表
function Globalstat:Collect(szPrimeKey, szSubKey, szAccount, szPlayerName, tbData)
  if not self.tbList[szPrimeKey] or not self.tbList[szPrimeKey][szSubKey] then
    assert("invalid key: " .. szPrimeKey .. "," .. szSubKey)
  end
  return GlobalStatCollect(szPrimeKey, szSubKey, szAccount, szPlayerName, tbData)
end

--注册回调函数
--szPrimeKey	大类
--szSudKey	小类
--nType		类型（1一次性，注册后删除该回调，2永久性，每次回调都以这个返回）
--fnStartFun	回调函数
function Globalstat:RegisterGlobalStatEventCallBack(szPrimeKey, szSubKey, fnStartFun, ...)
  if not self.tbList[szPrimeKey] or not self.tbList[szPrimeKey][szSubKey] then
    assert("invalid key: " .. szPrimeKey .. "," .. szSubKey)
  end
  GCEvent:RegisterGlobalStatEventCallBack(szPrimeKey, szSubKey, fnStartFun, unpack(arg))
end
