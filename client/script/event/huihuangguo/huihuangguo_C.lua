-- 文件名　：huihuangguo_C.lua
-- 创建者　：zhongchaolong
-- 创建时间：2007-12-20 11:31:24
--只放客户端
Require("\\script\\event\\huihuangguo\\huihuangzhiguo_head.lua")
function HuiHuangZhiGuo:GetHuiHuangGuoUseCount() --得到辉煌果使用次数,返回x,y 使用了x个 ，还能使用y个
  local nCount = me.GetTask(HuiHuangZhiGuo.TSKG_HuiHuangZhiGuo_ACT, HuiHuangZhiGuo.TSK_HuiHuangGuo_UseCount)
  return nCount, HuiHuangZhiGuo.MaxHuiHuangGuoUseCount - nCount
end
