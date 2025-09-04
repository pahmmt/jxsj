Require("\\script\\task\\autotest\\tasktest_tb.lua")

----------------------- 任务测试中要用到的全局变量 ----------------------
Task.AutoTest["CatchNpc"] = {}
Task.AutoTest["CatchNpc"].nCount = 0
Task.AutoTest["CatchNpc"].bExtend = false

Task.AutoTest["Fight2Dialog"] = {}
Task.AutoTest["Fight2Dialog"].nCount = 0
Task.AutoTest["Fight2Dialog"].bExtend = false

Task.AutoTest["FightNpc2DialogNpc"] = {}
Task.AutoTest["FightNpc2DialogNpc"].nCount = 0
Task.AutoTest["FightNpc2DialogNpc"].bExtend = false

Task.AutoTest["KillBoss4Item"] = {}
Task.AutoTest["KillBoss4Item"].nCount = 0
Task.AutoTest["KillBoss4Item"].bExtend = false

Task.AutoTest["KillBoss"] = {}
Task.AutoTest["KillBoss"].nCount = 0
Task.AutoTest["KillBoss"].bExtend = false

Task.AutoTest["KillNpc4Item"] = {}
Task.AutoTest["KillNpc4Item"].nCount = 0
Task.AutoTest["KillNpc4Item"].bExtend = false

Task.AutoTest["KillNpc4NormalItem"] = {}
Task.AutoTest["KillNpc4NormalItem"].nCount = 0
Task.AutoTest["KillNpc4NormalItem"].bExtend = false

Task.AutoTest["KillNpc"] = {}
Task.AutoTest["KillNpc"].nCount = 0
Task.AutoTest["KillNpc"].bExtend = false

Task.AutoTest["TalkWithNpc"] = {}
Task.AutoTest["TalkWithNpc"].nCount = 0
Task.AutoTest["TalkWithNpc"].bExtend = false

Task.AutoTest["WithProcessStatic"] = {}
Task.AutoTest["WithProcessStatic"].nCount = 0
Task.AutoTest["WithProcessStatic"].bExtend = false

Task.AutoTest["WithProcess"] = {}
Task.AutoTest["WithProcess"].nCount = 0
Task.AutoTest["WithProcess"].bExtend = false
-------------------------------------------------------------------------

function Task.AutoTest:IsEqualItem(tbItem1, tbItem2)
  if #tbItem1 ~= #tbItem2 then
    return false
  else
    for i = 1, #tbItem1 do
      if tbItem1[i] ~= tbItem2[i] then
        return false
      end
    end
  end

  return true
end

function Task.AutoTest:FindItemCount(tbAddItems, tbItemId)
  if #tbAddItems == 0 then
    local szItemName = KItem.GetNameById(tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4])
    print(szItemName)
    assert(false, "Empty tbAddItems!")
    return -1
  end

  for _, tbAddItem in pairs(tbAddItems) do
    if self:IsEqualItem(tbItemId, tbAddItem.tbItem) then
      return tbAddItem.nItemNum
    end
  end

  --- 如果运行到此，说明记录中不存在要删除的物品

  local szItemName = KItem.GetNameById(tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4])
  print(tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4], szItemName)
  assert(false, "FindItemCount", "Can't find the item!")
  return 0
end

function Task.AutoTest:IsGiveItem(tbGiveItems, tbItem)
  if #tbGiveItems == 0 then
    --	print("Empty tbGiveItems!");
    return false
  else
    for _, tbGiveItem in pairs(tbGiveItems) do
      if self:IsEqualItem(tbGiveItem, tbItem) then
        return true
      end
    end

    return false
  end
end

function Task.AutoTest:ParseItemList(tbItemList)
  if #tbItemList == 0 then
    --	assert(false, "Empty ItemList!");
    return {}
  end

  local tbRet = {}
  local tbPrevItem = tbItemList[1]
  assert(tbPrevItem)
  local nItemNum = 0
  for _, tbItem in pairs(tbItemList) do
    if self:IsEqualItem(tbItem, tbPrevItem) then
      nItemNum = nItemNum + 1
    else
      local tbTempItem = {}
      tbTempItem.tbItem = tbPrevItem
      tbTempItem.nItemNum = nItemNum
      tbRet[#tbRet + 1] = tbTempItem
      tbPrevItem = tbItem
      nItemNum = 1
    end
  end
  local tbTempItem = {}
  tbTempItem.tbItem = tbPrevItem
  tbTempItem.nItemNum = nItemNum
  tbRet[#tbRet + 1] = tbTempItem

  return tbRet
end

function Task.AutoTest:ParseConditionTable(tbConditions)
  local bResult = true
  for _, szCondition in pairs(tbConditions) do
    bResult = bResult and assert(loadstring(szCondition))()
    if not bResult then
      return bResult
    end
  end

  return bResult
end

function Task.AutoTest:PrintTaskCase(tbTaskCase)
  for i, v in pairs(tbTaskCase) do
    print(i, v)
    for i = 1, #v do
      print(i, v[i])
    end
  end
end

function Task.AutoTest:ParsePosString(szPos)
  local tbPos = {}
  tbPos = loadstring(string.gsub(szPos, ".+,(.+),(.+),(.+)", 'return {nMapId = tonumber(%1),nX = tonumber(%2),nY = tonumber(%3), szType = "pos"}'))()
  local nStart = string.find(szPos, ",")
  tbPos.szDesc = string.sub(szPos, 1, nStart - 1)
  return tbPos
end

function Task.AutoTest:ParseNpcPosString(szNpcPos)
  local tbNpcPos = {}
  local tbPosInfo = Lib:SplitStr(szNpcPos)
  tbNpcPos.szDesc = tbPosInfo[1]
  tbNpcPos.szMapInfo = tbPosInfo[2]
  tbNpcPos.nNpcId = tonumber(tbPosInfo[3])
  tbNpcPos.szType = "npcpos"

  return tbNpcPos
end

function Task.AutoTest:FindPosPath(szStepDesc)
  local nStart, nEnd
  local tbRet = {}

  nStart, nEnd = string.find(szStepDesc, "<pos=")
  if not nStart then
    return nil
  else
    while nStart do
      nStart = nEnd + 1
      nEnd = string.find(szStepDesc, ">", nStart)
      local szPos = string.sub(szStepDesc, nStart, nEnd - 1)
      tbRet[#tbRet + 1] = self:ParsePosString(szPos)
      nStart, nEnd = string.find(szStepDesc, "<pos=", nEnd + 1)
    end

    return tbRet
  end
end

function Task.AutoTest:FindNpcPosPath(szStepDesc)
  local nStart, nEnd
  local tbRet = {}

  nStart, nEnd = string.find(szStepDesc, "<npcpos=")
  if not nStart then
    return nil
  else
    while nStart do
      nStart = nEnd + 1
      nEnd = string.find(szStepDesc, ">", nStart)
      local szPos = string.sub(szStepDesc, nStart, nEnd - 1)
      tbRet[#tbRet + 1] = self:ParseNpcPosString(szPos)
      nStart, nEnd = string.find(szStepDesc, "<npcpos=", nEnd + 1)
    end

    return tbRet
  end
end

-------------------------------------------------------------------------
--	// @LuaApiName		: ParseTaskDesc
--	// @Description		: 将子任务描述中各步骤的自动寻路信息解析出来
--	// @ReturnCode		: tbStepsPath
--	// @ArgumentFlag	: d
--	// @ArgumentComment	: tbDesc(子任务描述信息)
--	// @LuaMarkEnd
-------------------------------------------------------------------------
function Task.AutoTest:ParseTaskDesc(tbDesc)
  local tbStepsPath = {}

  if not tbDesc.tbStepsDesc or #tbDesc.tbStepsDesc == 0 then
    return tbStepsPath
  else
    for nStepIdx, szStepDesc in pairs(tbDesc.tbStepsDesc) do
      local nPosStart, nPosEnd = string.find(szStepDesc, "<pos=")
      local nNpcPosStart, nNpcPosEnd = string.find(szStepDesc, "<npcpos=")

      if nPosStart or nNpcPosStart then
        tbStepsPath[nStepIdx] = {}
        while nPosStart or nNpcPosStart do
          if nPosStart and nNpcPosStart then
            if nPosStart < nNpcPosStart then
              local szPath = string.sub(szStepDesc, nPosStart, nNpcPosStart)
              local tbPosPath = self:FindPosPath(szPath)
              for i = 1, #tbPosPath do
                table.insert(tbStepsPath[nStepIdx], tbPosPath[i])
              end

              szStepDesc = string.sub(szStepDesc, nNpcPosStart)
              nPosStart, nPosEnd = string.find(szStepDesc, "<pos=")
              nNpcPosStart, nNpcPosEnd = string.find(szStepDesc, "<npcpos=")
            else
              local szPath = string.sub(szStepDesc, nNpcPosStart, nPosStart)
              local tbNpcPosPath = self:FindNpcPosPath(szPath)
              for i = 1, #tbNpcPosPath do
                table.insert(tbStepsPath[nStepIdx], tbNpcPosPath[i])
              end

              szStepDesc = string.sub(szStepDesc, nPosStart)
              nPosStart, nPosEnd = string.find(szStepDesc, "<pos=")
              nNpcPosStart, nNpcPosEnd = string.find(szStepDesc, "<npcpos=")
            end
          end

          if nPosStart and not nNpcPosStart then
            local tbPosPath = self:FindPosPath(szStepDesc)

            for _, tbPath in pairs(tbPosPath) do
              table.insert(tbStepsPath[nStepIdx], tbPath)
            end

            nPosStart = nil
          end

          if nNpcPosStart and not nPosStart then
            local tbNpcPosPath = self:FindNpcPosPath(szStepDesc)

            for _, tbPath in pairs(tbNpcPosPath) do
              table.insert(tbStepsPath[nStepIdx], tbPath)
            end

            nNpcPosStart = nil
          end
        end
      end
    end

    return tbStepsPath
  end
end

-------------------------------------------------------------------------
--	// @LuaApiName		: FindNpcByTemplateId
--	// @Description		: 通过指定NpcId，找玩家周围24格范围内，离玩家最近的Npc
--	// @ReturnCode		: pNpc，如果找不到返回nil
--	// @ArgumentFlag	: ddd
--	// @ArgumentComment	: 指定Npc的TemplateId
--	// @ArgumentComment	: 是否需要扩大范围搜索。true表示扩大,false表示只在玩家所在的一屏范围内搜索
--	// @ArgumentComment	: 如果该参数不为空，说明要搜寻的Npc的dwId不能是该参数
--	// @LuaMarkEnd
-------------------------------------------------------------------------
function Task.AutoTest:FindNpcByTemplateId(nNpcId, bExtend, dwId)
  local tbNpc, nCount
  if bExtend then
    tbNpc, nCount = KNpc.GetAroundNpcList(me, 1000)
  else
    tbNpc, nCount = KNpc.GetAroundNpcList(me, 32)
  end

  local _, nPosX, nPosY = me.GetWorldPos()
  local tbNpcList = {}

  if nCount == 0 then
    return nil
  else
    for nIndex = 1, nCount do
      local pNpc = tbNpc[nIndex]
      if dwId then
        while pNpc.dwId == dwId do
          nIndex = nIndex + 1
          if nIndex > nCount then
            pNpc = nil
            break
          else
            pNpc = tbNpc[nIndex]
          end
        end
      end
      if pNpc and pNpc.nTemplateId == nNpcId then
        if pNpc.nDoing ~= 10 and pNpc.nDoing ~= 20 then
          --- 找到的Npc不能是死亡或者重生状态
          local nX, nY = pNpc.GetMpsPos()
          local nDistance = ((nPosX - nX / 32) ^ 2 + (nPosY - nY / 32) ^ 2) ^ 0.5
          table.insert(tbNpcList, { pNpc = pNpc, nDistance = nDistance })
        end
      end
    end

    if #tbNpcList == 0 then
      --- 没有找到符合要求的Npc
      return nil
    else
      if dwId then
        local nIndex = MathRandom(#tbNpcList)
        return tbNpcList[nIndex].pNpc
      else
        local nDistance = tbNpcList[1].nDistance
        local pNpc = tbNpcList[1].pNpc
        for _, tbNpc in pairs(tbNpcList) do
          if nDistance > tbNpc.nDistance then
            nDistance = tbNpc.nDistance
            pNpc = tbNpc.pNpc
          end
        end

        return pNpc
      end
    end
  end
end

--找要保护的NPC附近的敌对NPC
function Task.AutoTest:FindNpcNearBy(nRange)
  local tbNpc, nCount = KNpc.GetAroundNpcList(me, 48, 8)

  local _, nPosX, nPosY = me.GetWorldPos()
  local tbNpcList = {}

  if nCount == 0 then
    return nil
  else
    for nIndex = 1, nCount do
      local pNpc = tbNpc[nIndex]
      if pNpc and pNpc.nDoing ~= 10 and pNpc.nDoing ~= 20 then
        --- 找到的Npc不能是死亡或者重生状态
        local nX, nY = pNpc.GetMpsPos()
        local nDistance = ((nPosX - nX / 32) ^ 2 + (nPosY - nY / 32) ^ 2) ^ 0.5
        if not nRange or (nRange and nDistance <= nRange) then
          table.insert(tbNpcList, { pNpc = pNpc, nDistance = nDistance })
        end
      end
    end

    if #tbNpcList == 0 then
      --- 没有找到符合要求的Npc
      return nil
    else
      local nDistance = tbNpcList[1].nDistance
      local pNpc = tbNpcList[1].pNpc
      for _, tbNpc in pairs(tbNpcList) do
        if nDistance > tbNpc.nDistance then
          nDistance = tbNpc.nDistance
          pNpc = tbNpc.pNpc
        end
      end

      return pNpc
    end
  end
end

-------------------------------------------------------------------------
--	// @LuaApiName		: FindPathByName
--	// @Description		: 通过目标名找到匹配的寻路坐标
--	// @ReturnCode		: tbPath（匹配的寻路坐标）,找不到返回nil
--	// @ArgumentFlag	: dd
--	// @ArgumentComment	: tbStepPath（单步骤的所有寻路坐标）
--	// @ArgumentComment	: szName（目标名）
--	// @LuaMarkEnd
-------------------------------------------------------------------------
function Task.AutoTest:FindPathByName(tbStepPath, szName)
  local tbPath
  for i = 1, #tbStepPath do
    tbPath = tbStepPath[i]
    if string.find(tbPath.szDesc, szName) or string.find(szName, tbPath.szDesc) then
      return tbPath
    end
  end

  return nil
end

-------------------------------------------------------------------------
--	// @LuaApiName		: FindPathByPos
--	// @Description		: 通过任务表中提供的目标坐标找到匹配的寻路坐标
--	// @ReturnCode		: tbPath（匹配的寻路坐标）,找不到返回nil
--	// @ArgumentFlag	: ddddd
--	// @ArgumentComment	: tbStepPath（单步骤的所有寻路坐标）
--	// @ArgumentComment	: nMapId（目标地图Id）
--	// @ArgumentComment	: nX（目标X坐标）
--	// @ArgumentComment	: nY（目标Y坐标）
--	// @ArgumentComment	: nR（目标有效范围半径，只针对释放技能、AddObj和探索地图）
--	// @LuaMarkEnd
-------------------------------------------------------------------------
function Task.AutoTest:FindPathByPos(tbStepPath, nMapId, nX, nY, nR)
  local tbPath
  for i = 1, #tbStepPath do
    tbPath = tbStepPath[i]
    --	print(tbPath.szType, tbPath.nMapId, tbPath.nX, tbPath.nY)
    if tbPath.szType == "pos" and tbPath.nMapId == nMapId then
      local nDeltaX = tbPath.nX - nX
      local nDeltaY = tbPath.nY - nY
      if nR then
        local nDistance = (nDeltaX ^ 2 + nDeltaY ^ 2) ^ 0.5
        if nDistance <= nR then
          return tbPath, i
        end
      elseif math.abs(nDeltaX) <= 16 and math.abs(nDeltaY) <= 24 then
        return tbPath
      end
    end
  end

  return nil
end

-------------------------------------------------------------------------
--	// @LuaApiName		: FindPathByNpcId
--	// @Description		: 通过目标Id找到匹配的寻路坐标
--	// @ReturnCode		: tbPath（匹配的寻路坐标）,找不到返回nil
--	// @ArgumentFlag	: dd
--	// @ArgumentComment	: tbStepPath（单步骤的所有寻路坐标）
--	// @ArgumentComment	: nNpcId（目标NpcId）
--	// @LuaMarkEnd
-------------------------------------------------------------------------
function Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcId)
  local tbPath
  for i = 1, #tbStepPath do
    tbPath = tbStepPath[i]
    if tbPath.szType == "npcpos" and tbPath.nNpcId == nNpcId then
      return tbPath
    end
  end

  return nil
end

----==== 以下是用来CallNpc的命令，任务测试暂时不允许这样做 ====-----
function c2s:CallTaskNpc(nNpcId, nMapId, nPosX, nPosY)
  local pNpc = KNpc.Add2(nNpcId, 1, -1, nMapId, nPosX, nPosY)
  assert(pNpc)
  me.CallClientScript({ "Task:SetNewNpcId", pNpc.dwId })
end

function Task:CallNpc(nNpcId, nMapId, nPosX, nPosY)
  if not nMapId then
    nMapId, nPosX, nPosY = me.GetWorldPos()
  end

  me.CallServerScript({ "CallTaskNpc", nNpcId, nMapId, nPosX, nPosY })
end

function Task:SetNewNpcId(nNpcId)
  Task.nNewNpcId = nNpcId
end
