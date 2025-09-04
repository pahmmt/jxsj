----interface.lua
----作者：孙多良
----2012-06-07
----info：插件开关
--可以指定功能的插件，必须更新时间在需求之后的才允许使用，否则不起效。
--配置文件在：\\setting\\misc\\plugindef.txt
Ui.tbPluginState = {
  --插件名PluginName, 需求最新更新时间PluginDate（YYYYMMDD）
  --["自动游龙"] 				= {"20121111","测试关闭"}
  --["财富荣誉显示"] 			= {"20110729","和新版F1声望界面冲突"}
  --["系统优化,老包缩小"] 	= {"20121212","和插件界面冲突"};
}

function Ui:LoadPluginDefFile()
  Ui.tbPluginState = {}
  local tbFile = Lib:LoadTabFile("\\setting\\misc\\plugindef.txt")
  for _, tbInfo in ipairs(tbFile) do
    local bUse = tonumber(tbInfo.bUse) or 0
    local szName = tbInfo.Name
    local szInfo = tbInfo.info or ""
    local nDate = tonumber(tbInfo.Date) or 0
    if bUse == 1 then
      Ui.tbPluginState[szName] = { nDate, szInfo }
    end
  end
end
Ui:LoadPluginDefFile()
