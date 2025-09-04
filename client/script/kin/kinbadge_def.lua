----------------------------------------------------
-- 文件名　：kinbadge_def.lua
-- 创建者　：FanJinsong
-- 创建时间：2012-08-12
-- 文件功能：家族徽章
----------------------------------------------------

--调试需要
if not Kin then
  Kin = {}
  print(GetLocalDate("%Y/%m/%d/%H/%M/%S") .. " build ok ..")
end

--记录家族徽章脚本临时数据
if not Kin.tbKinBadge then
  Kin.tbKinBadge = {}
end

--load徽章相关表
function Kin:LoadKinBadge()
  local szFileKinBadge = "\\setting\\kin\\kinbadge.txt"
  local tbNumColSet = { ["Rate"] = 1, ["No"] = 1 } --Rate 等级; No 编号
  local tbFile = Lib:LoadTabFile(szFileKinBadge, tbNumColSet) --读取txt文件
  if not tbFile then
    print("【家族徽章】读取文件错误，文件不存在", szFileKinBadge)
    return
  end
  for _, tbInfo in ipairs(tbFile) do
    self.tbKinBadge[tbInfo.Rate * 10000 + tbInfo.No] = tbInfo
  end
  --self.tbKinBadge = Lib:CopyTB1(tbFile);  		--将表数据复制给tbKinBadge
  --	Lib:ShowTB(self.tbKinBadge, "\n");
end

--初始化家族徽章表
function Kin:InitKinBadge()
  self:LoadKinBadge()
end

--初始化家族徽章表
Kin:InitKinBadge()
