-- 文件名　：create_serverlist_c.lua
-- 创建者　：sunduoliang
-- 创建时间：2011-01-06 11:35:20
-- 金山版本到这里下载服务器列表：http://jxsj.autoupdate.kingsoft.com/jxsj/serverlist/serverlist.ini
--然后通过以下接口转成\\setting\\serverlistcfg.txt

--原有基础上进行增加修改，保留主服
function ServerEvent:CSList_Modiff(szListInit)
  local tbFile = Lib:LoadIniFile(szListInit)
  if not tbFile then
    me.Msg(szListInit .. "文件不存在!!!")
    print("文件不存在")
    return 0
  end
  local tbOrgFile = Lib:LoadTabFile("\\setting\\serverlistcfg.txt")
  local tbOrgCfg = {}
  local tbGlobalArea = {}
  if tbOrgFile then
    for i = 1, #tbOrgFile do
      local szGate = tbOrgFile[i].GatewayId
      local nMainServer = tonumber(tbOrgFile[i].MainServer) or 0
      local szServerName = tbOrgFile[i].ServerName
      if nMainServer == 1 then
        tbOrgCfg[szGate] = szServerName
      end
      tbGlobalArea[szGate] = tbGlobalArea[szGate] or tonumber(tbOrgFile[i].GlobalArea) or 0
    end
  end

  local tbCfg = {}
  local tbGate = {}
  local tbZoneServer = {}
  for Ri = 1, tbFile.List.RegionCount do
    local szReg = "Region_" .. Ri
    if tbFile[szReg] then
      local szDefautZoneName = tbFile.List[szReg]
      for i = 1, tbFile[szReg].Count do
        local szTitle = tbFile[szReg][i .. "_Title"]
        local szGate = tbFile[szReg][i .. "_GatewayName"]
        local tbParam = Lib:SplitStr(szTitle, " ")
        local szZoneName = tbParam[1]
        local szServerName = tbParam[2]

        if szZoneName and not szServerName then
          szServerName = szZoneName
          szZoneName = szDefautZoneName
        end
        --特殊处理掉【】
        local _, nE = string.find(szZoneName, "【")
        if nE then
          szZoneName = string.sub(szZoneName, nE + 1, -1)
        end
        local nS, _ = string.find(szZoneName, "】")
        if nS then
          szZoneName = string.sub(szZoneName, 1, nS - 1)
        end

        local _, nE = string.find(szServerName, "【")
        if nE then
          szServerName = string.sub(szServerName, nE + 1, -1)
        end
        local nS, _ = string.find(szServerName, "】")
        if nS then
          szServerName = string.sub(szServerName, 1, nS - 1)
        end
        local nAreaNew = 8
        local nZoneType = 1
        local szZoneTypeName = "电信"
        if string.find(szZoneName, "网通") then
          nZoneType = 2
          szZoneTypeName = "网通"
          nAreaNew = 9
        end
        local nGlobalArea = tbGlobalArea[szGate] or nAreaNew
        if not tbZoneServer[szZoneName .. szServerName] then
          local nMainServer = 0
          if tbOrgCfg[szGate] then
            if tbOrgCfg[szGate] == szServerName and not tbGate[szGate] then
              nMainServer = 1
              tbGate[szGate] = 1
            end
          elseif not tbGate[szGate] then
            nMainServer = 1
            tbGate[szGate] = 1
          end
          local nCount = #tbCfg + 1
          tbCfg[nCount] = {
            ZoneName = szZoneName or "",
            ServerName = szServerName or "",
            GatewayId = szGate,
            ZoneType = nZoneType,
            ZoneTypeName = szZoneTypeName,
            ListId = Ri,
            MainServer = nMainServer,
            GlobalArea = nGlobalArea,
          }
          tbZoneServer[szZoneName .. szServerName] = 1
        end
      end
    end
  end
  local function OnSort(tbA, tbB)
    --if tbA.ListId ~= tbB.ListId then
    --	return tbA.ListId < tbB.ListId;
    --end
    if tbA.GatewayId ~= tbB.GatewayId then
      return tbA.GatewayId < tbB.GatewayId
    end

    if tbA.ZoneName ~= tbB.ZoneName then
      return tbA.ZoneName < tbB.ZoneName
    end

    if tbA.MainServer ~= tbB.MainServer then
      return tbA.MainServer > tbB.MainServer
    end

    return tbA.ServerName < tbB.ServerName
  end
  table.sort(tbCfg, OnSort)
  local szPath = "\\setting\\serverlistcfg.txt"
  local szText = "ZoneType\tZoneTypeName\tZoneName\tServerName\tGatewayId\tMainServer\tGlobalArea\r\n"
  for _, tbParam in ipairs(tbCfg) do
    szText = szText .. string.format(
      "%s\t%s\t%s\t%s\t%s\t%s\t%s\r\n",
      --tbParam.ListId,
      tbParam.ZoneType,
      tbParam.ZoneTypeName,
      tbParam.ZoneName,
      tbParam.ServerName,
      tbParam.GatewayId,
      tbParam.MainServer,
      tbParam.GlobalArea
    )
  end
  KFile.WriteFile(szPath, szText)
  me.Msg(szPath .. "文件生成成功!!!")
end

function ServerEvent:CSList(szListInit)
  local tbFile = Lib:LoadIniFile(szListInit)
  if not tbFile then
    me.Msg(szListInit .. "文件不存在!!!")
    print("文件不存在")
    return 0
  end
  local tbOrgFile = Lib:LoadTabFile("\\setting\\serverlistcfg.txt")
  local tbOrgCfg = {}
  local tbGlobalArea = {}
  if tbOrgFile then
    for i = 1, #tbOrgFile do
      local szGate = tbOrgFile[i].GatewayId
      tbGlobalArea[szGate] = tbGlobalArea[szGate] or tonumber(tbOrgFile[i].GlobalArea) or 0
    end
  end

  local tbGate = {}
  local tbZoneServer = {}
  local tbGlobalArea = {}
  for Ri = 1, tbFile.List.RegionCount do
    local szReg = "Region_" .. Ri
    if tbFile[szReg] then
      local szDefautZoneName = tbFile.List[szReg]
      for i = 1, tbFile[szReg].Count do
        local szTitle = tbFile[szReg][i .. "_Title"]
        local szGate = tbFile[szReg][i .. "_GatewayName"]
        local tbParam = Lib:SplitStr(szTitle, " ")
        local szZoneName = tbParam[1]
        local szServerName = tbParam[2]
        if szZoneName and not szServerName then
          szServerName = szZoneName
          szZoneName = szDefautZoneName
        end
        --特殊处理掉【】
        local _, nE = string.find(szZoneName, "【")
        if nE then
          szZoneName = string.sub(szZoneName, nE + 1, -1)
        end
        local nS, _ = string.find(szZoneName, "】")
        if nS then
          szZoneName = string.sub(szZoneName, 1, nS - 1)
        end

        local _, nE = string.find(szServerName, "【")
        if nE then
          szServerName = string.sub(szServerName, nE + 1, -1)
        end
        local nS, _ = string.find(szServerName, "】")
        if nS then
          szServerName = string.sub(szServerName, 1, nS - 1)
        end
        if not tbZoneServer[szZoneName .. szServerName] then
          local nZoneType = 1
          local nAreaNew = 8
          local szZoneTypeName = "电信"
          if string.find(szZoneName, "网通") then
            nZoneType = 2
            szZoneTypeName = "网通"
            nAreaNew = 9
          end
          local nGlobalArea = tbGlobalArea[szGate] or nAreaNew
          local nMainServer = 0
          if not tbGate[szGate] then
            nMainServer = 1
            tbGate[szGate] = 1
          end
          local nCount = #tbCfg + 1
          tbCfg[nCount] = {
            ZoneName = szZoneName or "",
            ServerName = szServerName or "",
            GatewayId = szGate,
            ZoneType = nZoneType,
            ZoneTypeName = szZoneTypeName,
            ListId = Ri,
            MainServer = nMainServer,
            GlobalArea = nGlobalArea,
          }
          tbZoneServer[szZoneName .. szServerName] = 1
        end
      end
    end
  end

  local function OnSort(tbA, tbB)
    --if tbA.ListId ~= tbB.ListId then
    --	return tbA.ListId < tbB.ListId;
    --end
    if tbA.GatewayId ~= tbB.GatewayId then
      return tbA.GatewayId < tbB.GatewayId
    end

    if tbA.ZoneName ~= tbB.ZoneName then
      return tbA.ZoneName < tbB.ZoneName
    end

    if tbA.MainServer ~= tbB.MainServer then
      return tbA.MainServer > tbB.MainServer
    end

    return tbA.ServerName < tbB.ServerName
  end
  table.sort(tbCfg, OnSort)
  local szPath = "\\setting\\serverlistcfg.txt"
  local szText = "ZoneType\tZoneTypeName\tZoneName\tServerName\tGatewayId\tMainServer\tGlobalArea\r\n"
  for _, tbParam in ipairs(tbCfg) do
    szText = szText .. string.format(
      "%s\t%s\t%s\t%s\t%s\t%s\t%s\r\n",
      --tbParam.ListId,
      tbParam.ZoneType,
      tbParam.ZoneTypeName,
      tbParam.ZoneName,
      tbParam.ServerName,
      tbParam.GatewayId,
      tbParam.MainServer,
      tbParam.GlobalArea
    )
  end
  KFile.WriteFile(szPath, szText)
  me.Msg(szPath .. "文件生成成功!!!")
end

function ServerEvent:CreateTaskList()
  local tbTaskType = { [1] = "主线任务", [2] = "世界任务", [3] = "江湖任务", [4] = "随机任务", [5] = "军营任务" }
  local szOutFile = "\\TaskList.txt"
  local szContext = "任务名字\t主任务Id\t子任务Id\t子任务名字\t任务类别\t重复接取\t是否可分享\t任务等级\n"
  KFile.WriteFile(szOutFile, szContext)
  for nTaskId, tbTaskDatas in pairs(Task.tbTaskDatas) do
    local szName = tbTaskDatas.szName
    local Share = tbTaskDatas.tbAttribute.Share
    if Share == true then
      Share = "可分享"
    elseif Share == false then
      Share = "不可分享"
    end
    local Repeat = tbTaskDatas.tbAttribute.Repeat
    if Repeat == true then
      Repeat = "可重复"
    elseif Repeat == false then
      Repeat = "不可重复"
    end
    local TaskType = tbTaskDatas.tbAttribute.TaskType
    for _, nReferId in pairs(tbTaskDatas.tbReferIds) do
      local tbReferInfo = Task.tbReferDatas[nReferId]
      local szSubName = tbReferInfo.szName
      local nLevel = tbReferInfo.nLevel
      local szOut = string.format("%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", szName, nTaskId, nReferId, szSubName, tbTaskType[TaskType] or "未知", Repeat, Share, nLevel)
      KFile.AppendFile(szOutFile, szOut)
    end
  end
  Dialog:Say("任务列表生成完毕，路径在您客户端根目录，文件名为：TaskList.txt")
end

function ServerEvent:CreateAchievementList()
  local szContext = "nAchievementId\tnGroupId\tnSubGroupId\tnIndex\tnLevel\tszGroupName\tszSubGroupName\tszAchivementName\tszDesc\tnPoint\tbTrack\tbProcess\tnMaxCount\tnCondType\tnCondIndex\tnExp\tnBindMoney\tnBindCoin\tnTitleId\tbIsSubAchievement\tbEffective\n"
  local szOutFile = "\\AchievementList.txt"
  KFile.WriteFile(szOutFile, szContext)
  for nGroupId, tbGroup in ipairs(Achievement.tbAchievementInfo) do
    for nSubGroupId, tbSubGroup in ipairs(tbGroup) do
      for nIndex, tbInfo in ipairs(tbSubGroup) do
        local szOut = string.format("%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", tbInfo.nAchievementId, tbInfo.nGroupId, tbInfo.nSubGroupId, tbInfo.nIndex, tbInfo.nLevel, tbInfo.szGroupName, tbInfo.szSubGroupName, tbInfo.szAchivementName, tbInfo.szDesc, tbInfo.nPoint, tbInfo.bTrack, tbInfo.bProcess, tbInfo.nMaxCount, tbInfo.nCondType, tbInfo.nCondIndex, tbInfo.nExp, tbInfo.nBindMoney, tbInfo.nBindCoin, tbInfo.nTitleId, tbInfo.bIsSub, tbInfo.bEffective)
        KFile.AppendFile(szOutFile, szOut)
      end
    end
  end
  Dialog:Say("成就列表生成完毕，路径在您客户端根目录，文件名为：AchievementList.txt")
end
