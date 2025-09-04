if not Task.AutoTest then
  Task.AutoTest = {}
end

local tbAddItems = {} --- 用来记录任务中玩家获得的任务道具与个数
local tbConflict = {} --- 用来解决上一步骤删除物品与下一步马上AddObj给检测带来的冲突
tbConflict.tbItem = {}
tbConflict.nIndex = nil

function Task.AutoTest:DoTarget(tbTargets, tbReferCase, tbStepParams)
  local tbGiveItems = {} --- 记录玩家上交的物品与个数
  local tbStepCases = {}
  local tbStepPath = tbStepParams.tbStepPath

  for _, tbTarget in pairs(tbTargets) do
    local szTargetName = tbTarget.szTargetName
    if szTargetName == "AddObj" then
      --- 在玩家背包中添加道具，并要求在指定地点使用该道具
      local tbItemId = tbTarget.tbItemId
      local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
      local szItemName = tbTarget.szItemName
      local nMapId = tbTarget.nMapId
      local nPosX = tbTarget.nPosX
      local nPosY = tbTarget.nPosY
      local nR = tbTarget.nR

      --- 判断上一次步骤结束是否有删除该物品的操作
      if tbConflict.tbItem ~= {} then
        if Task.AutoTest:IsEqualItem(tbItem, tbConflict.tbItem) then
          table.remove(tbReferCase, tbConflict.nIndex)
          tbConflict.tbItem = {}
          tbConflict.nIndex = nil
        end
      end

      tbStepCases[#tbStepCases + 1] = {}

      if not tbStepPath then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId, "AddObj没有提供寻路坐标")
        assert(tbStepPath, "AddObj没有提供寻路坐标")
      end

      if Task.AutoTest:FindPathByName(tbStepPath, szItemName) then
        local tbPath = Task.AutoTest:FindPathByName(tbStepPath, szItemName)
        tbStepCases[#tbStepCases].bMatch = true
        if tbPath.szType == "pos" then
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        end
        if tbPath.szType == "npcpos" then
          table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
        end
      else
        local tbPath = Task.AutoTest:FindPathByPos(tbStepPath, nMapId, nPosX, nPosY, nR)
        if tbPath then
          tbStepCases[#tbStepCases].bMatch = true
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        end
      end

      if not tbStepCases[#tbStepCases].bMatch then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId)
        print("AddObj找不到匹配的寻路坐标")
        assert(false, "AddObj找不到匹配的寻路坐标")
      end

      table.insert(tbStepCases[#tbStepCases], { "SetFightState", { nState = 0 } }) --- 使用物品时将玩家设为非战斗状态，以免被怪干扰
      table.insert(tbStepCases[#tbStepCases], { "UseItemInBag", { tbItem = tbItem, nDelay = 12 } })
      table.insert(tbStepCases[#tbStepCases], { "SetFightState", { nState = 1 } })
    elseif szTargetName == "AddTaskItem" then
      --- 伴随物品，在玩家背包中添加一个任务道具
      local tbItemId = tbTarget.tbItemId
      local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
    --	table.insert(tbStepCases, {"CheckItemDelta", {tbItem = tbItem, nValue = 1}});
    --	table.insert(tbStepCases, {"SaveStat", {}});
    elseif szTargetName == "AnsewerTheQuestion_A" then
      --- 答题（有错误上限），目前假设只考虑全部答对的情况
      local nNpcId = tbTarget.nNpcTempId
      local szNpcName = tbTarget.szNpcName
      local nMapId = tbTarget.nMapId
      local szOption = tbTarget.szOption
      local szSubTaskName = tbStepParams.szSubTaskName

      if not tbStepPath then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId, "AnsewerTheQuestion_A没有提供寻路坐标")
        assert(tbStepPath, "AnsewerTheQuestion_A没有提供寻路坐标")
      end

      tbStepCases[#tbStepCases + 1] = {}

      -------------========= 一些特殊Case的匹配处理  ==========------------
      local nTaskId = tbStepParams.nTaskId
      local nSubTaskId = tbStepParams.nSubTaskId
      local nStepId = tbStepParams.nStepId

      if nTaskId == 17 and nSubTaskId == 118 and nStepId == 5 then
        --- 【寻人】第5步，只给了一个Trap点，NPC在室内
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      else
        if Task.AutoTest:FindPathByName(tbStepPath, szNpcName) then
          local tbPath = Task.AutoTest:FindPathByName(tbStepPath, szNpcName)
          tbStepCases[#tbStepCases].bMatch = true
          if tbPath.szType == "pos" then
            table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
            table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
            table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
          end
          if tbPath.szType == "npcpos" then
            table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
            table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
            table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
          end
        elseif Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcId) then
          local tbPath = Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcId)
          tbStepCases[#tbStepCases].bMatch = true
          table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
          table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
          table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
        else
          local nX, nY = KNpc.ClientGetNpcPos(nMapId, nNpcId)
          local tbPath = Task.AutoTest:FindPathByPos(tbStepPath, nMapId, nX, nY)
          if tbPath then
            tbStepCases[#tbStepCases].bMatch = true
            table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
            table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
            table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
          end
        end
      end

      if not tbStepCases[#tbStepCases].bMatch then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId)
        print("AnsewerTheQuestion_A找不到匹配的寻路坐标")
        assert(false, "AnsewerTheQuestion_A找不到匹配的寻路坐标")
      end

      table.insert(tbStepCases[#tbStepCases], { "InteractWithNpc", { nNpcId = nNpcId } })
      if szOption == "<subtaskname>" then
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = szSubTaskName } })
      else
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = szOption } })
      end
      table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = "答题" } })

      local tbQLib = tbTarget.tbQLib --- 答题的题库
      for _, tbItem in pairs(tbQLib) do
        local nCorrectIdx = tbItem.nCorrectIdx
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOption", { nOptionNum = nCorrectIdx } })
      end
      table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} }) --- 如果答题完后有黑屏，直接过掉

      local nCostMoney = tbTarget.nCostMoney --- 答题可能扣除玩家的JXB
      if nCostMoney > 0 then
        nCostMoney = nCostMoney * -1
        table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "money", nValue = nCostMoney } })
        table.insert(tbStepCases[#tbStepCases], { "SaveStat", {} })
      end

      --- 答题完后可能会领取任务奖励
      local nStepId = tbStepParams.nStepId
      local nStepCount = tbStepParams.nStepCount
      if nStepId == nStepCount then
        --- 如果是最后一个步骤，需要领取奖励
        local nBagSpaceCount = tbStepParams.nBagSpaceCount
        local tbAwards = tbStepParams.tbAwards

        table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} }) --领奖可能会产生黑屏，要过掉
        if nBagSpaceCount > 0 then
          table.insert(tbStepCases[#tbStepCases], { "BagHasSpace", { nEmptyNum = nBagSpaceCount } })
        end

        if #tbAwards.tbFix ~= 0 then
          --- 领取固定奖励
          table.insert(tbStepCases[#tbStepCases], { "AcceptReward", { bAccept = 1, nSelectedAward = 0, nNpcId = nNpcId, szTaskName = szSubTaskName } })
          local tbAwards = tbAwards.tbFix
          for _, tbAward in pairs(tbAwards) do
            if self:ParseConditionTable(tbAward.tbConditions) then
              if tbAward.szType == "exp" then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "exp", nValue = tbAward.varValue } })
              elseif tbAward.szType == "money" then
                if tbStepParams.nLevel < 30 then
                  table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
                else
                  table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "money", nValue = tbAward.varValue } })
                end
              elseif tbAward.szType == "bindmoney" then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
              elseif tbAward.szType == "makepoint" then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "makepoint", nValue = tbAward.varValue } })
              elseif tbAward.szType == "gatherpoint" then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "gatherpoint", nValue = tbAward.varValue } })
              elseif tbAward.szType == "item" then
                local tbItemId = tbAward.varValue
                local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
                local nItemNum = tbAward.szAddParam1
                assert(nItemNum >= 0, "奖励物品个数填错了")
                if nItemNum == 0 then
                  nItemNum = 1
                end
                table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nItemNum } })
              elseif tbAward.szType == "customizeitem" then
                local tbItemId = tbAward.varValue
                local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
                table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = 1 } })
              elseif tbAward.szType == "title" then
                local tbTitle = tbAward.varValue
              elseif tbAward.szType == "repute" then
                local tbRepute = tbAward.varValue
              elseif tbAward.szType == "taskvalue" then
                local tbTaskValue = tbAward.varValue
              elseif tbAward.szType == "script" then
                local szFnScript = tbAward.varValue
              elseif tbAward.szType == "arrary" then
              elseif tbAward.szType == "KinReputeEntry" then
              else
                for key, value in pairs(tbAward) do
                  print(key, value)
                  if type(value) == "table" then
                    for i, v in pairs(value) do
                      print(i, v)
                    end
                  end
                end
                print(tbStepParams.szSubTaskName)
                assert(false, "Exception Award!")
              end
            end
          end
        elseif #tbAwards.tbOpt ~= 0 then
          --- 领取可选奖励
          local tbAwards = tbAwards.tbOpt
          local nSelectedAward = MathRandom(#tbAwards)

          table.insert(tbStepCases[#tbStepCases], { "AcceptReward", { bAccept = 1, nSelectedAward = nSelectedAward, nNpcId = nNpcId, szTaskName = szSubTaskName } })

          local tbAward = tbAwards[nSelectedAward]
          if self:ParseConditionTable(tbAward.tbConditions) then
            if tbAward.szType == "exp" then
              table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "exp", nValue = tbAward.varValue } })
            elseif tbAward.szType == "money" then
              if tbStepParams.nLevel < 30 then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
              else
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "money", nValue = tbAward.varValue } })
              end
            elseif tbAward.szType == "bindmoney" then
              table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
            elseif tbAward.szType == "makepoint" then
              table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "makepoint", nValue = tbAward.varValue } })
            elseif tbAward.szType == "gatherpoint" then
              table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "gatherpoint", nValue = tbAward.varValue } })
            elseif tbAward.szType == "item" then
              local tbItemId = tbAward.varValue
              local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
              local nItemNum = tbAward.szAddParam1
              assert(nItemNum >= 0, "奖励物品个数填错了")
              if nItemNum == 0 then
                nItemNum = 1
              end
              table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nItemNum } })
            elseif tbAward.szType == "customizeitem" then
              local tbItemId = tbAward.varValue
              local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
              table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = 1 } })
            elseif tbAward.szType == "title" then
              local tbTitle = tbAward.varValue
            elseif tbAward.szType == "repute" then
              local tbRepute = tbAward.varValue
            elseif tbAward.szType == "taskvalue" then
              local tbTaskValue = tbAward.varValue
            elseif tbAward.szType == "script" then
              local szFnScript = tbAward.varValue
            elseif tbAward.szType == "arrary" then
            elseif tbAward.szType == "KinReputeEntry" then
            else
              for key, value in pairs(tbAward) do
                print(key, value)
                if type(value) == "table" then
                  for i, v in pairs(value) do
                    print(i, v)
                  end
                end
              end
              print(tbStepParams.szSubTaskName)
              assert(false, "Exception Award!")
            end
          else
            assert(false, "领取随机奖励失败")
          end
        elseif #tbAwards.tbRand ~= 0 then
          --- 领取随机奖励
          --- TODO: 目前暂时没有随机奖励的设定，暂不做考虑
        else
          print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId)
          print("没有填写任务奖励!")
          --	assert(false,"没有填写任务奖励!");
        end

        --- 领取奖励完后会有黑屏，先要过掉黑屏
        table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} })

        --- 领取奖励后，如果是询问接受任务，且此时子任务不是最后一个子任务，则接受，否则不接受
        local tbExecute = tbStepParams.tbExecute
        if #tbExecute ~= 0 then
          local nReferIdx = tbStepParams.nReferIdx
          local nSubNum = tbStepParams.nSubNum
          if nReferIdx ~= nSubNum then
            table.insert(tbStepCases[#tbStepCases], { "AcceptTask", { bAccept = 1 } })
          else
            table.insert(tbStepCases[#tbStepCases], { "AcceptTask", { bAccept = 0 } })
          end
        end
      end
    elseif szTargetName == "AnsewerTheQuestionWithDesc" then
      --- 带描述的答题（有错误上限），目前假设只考虑全部答对的情况
      local nNpcId = tbTarget.nNpcTempId
      local szNpcName = tbTarget.szNpcName
      local nMapId = tbTarget.nMapId
      local szOption = tbTarget.szOption
      local szChoice = tbTarget.szChoice
      local szSubTaskName = tbStepParams.szSubTaskName

      if not tbStepPath then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId, "AnsewerTheQuestion_A没有提供寻路坐标")
        assert(tbStepPath, "AnsewerTheQuestion_A没有提供寻路坐标")
      end

      tbStepCases[#tbStepCases + 1] = {}

      -------------========= 一些特殊Case的匹配处理  ==========------------
      local nTaskId = tbStepParams.nTaskId
      local nSubTaskId = tbStepParams.nSubTaskId
      local nStepId = tbStepParams.nStepId

      if Task.AutoTest:FindPathByName(tbStepPath, szNpcName) then
        local tbPath = Task.AutoTest:FindPathByName(tbStepPath, szNpcName)
        tbStepCases[#tbStepCases].bMatch = true
        if tbPath.szType == "pos" then
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
          table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
          table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
        end
        if tbPath.szType == "npcpos" then
          table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
          table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
          table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
        end
      elseif Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcId) then
        local tbPath = Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcId)
        tbStepCases[#tbStepCases].bMatch = true
        table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      else
        local nX, nY = KNpc.ClientGetNpcPos(nMapId, nNpcId)
        local tbPath = Task.AutoTest:FindPathByPos(tbStepPath, nMapId, nX, nY)
        if tbPath then
          tbStepCases[#tbStepCases].bMatch = true
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
          table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
          table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
        end
      end

      if not tbStepCases[#tbStepCases].bMatch then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId)
        print("AnsewerTheQuestion_A找不到匹配的寻路坐标")
        assert(false, "AnsewerTheQuestion_A找不到匹配的寻路坐标")
      end

      table.insert(tbStepCases[#tbStepCases], { "InteractWithNpc", { nNpcId = nNpcId } })
      if szOption == "<subtaskname>" then
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = szSubTaskName } })
      else
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = szOption } })
      end
      table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = szChoice } })

      local tbQLib = tbTarget.tbQLib --- 答题的题库
      for _, tbItem in pairs(tbQLib) do
        local nCorrectIdx = tbItem.nCorrectIdx
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOption", { nOptionNum = nCorrectIdx } })
      end
      table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} }) --- 如果答题完后有黑屏，直接过掉

      local nCostMoney = tbTarget.nCostMoney --- 答题可能扣除玩家的JXB
      if nCostMoney > 0 then
        nCostMoney = nCostMoney * -1
        table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "money", nValue = nCostMoney } })
        table.insert(tbStepCases[#tbStepCases], { "SaveStat", {} })
      end

      --- 答题完后可能会领取任务奖励
      local nStepId = tbStepParams.nStepId
      local nStepCount = tbStepParams.nStepCount
      if nStepId == nStepCount then
        --- 如果是最后一个步骤，需要领取奖励
        local nBagSpaceCount = tbStepParams.nBagSpaceCount
        local tbAwards = tbStepParams.tbAwards

        table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} }) --领奖可能会产生黑屏，要过掉
        if nBagSpaceCount > 0 then
          table.insert(tbStepCases[#tbStepCases], { "BagHasSpace", { nEmptyNum = nBagSpaceCount } })
        end

        if #tbAwards.tbFix ~= 0 then
          --- 领取固定奖励
          table.insert(tbStepCases[#tbStepCases], { "AcceptReward", { bAccept = 1, nSelectedAward = 0, nNpcId = nNpcId, szTaskName = szSubTaskName } })
          local tbAwards = tbAwards.tbFix
          for _, tbAward in pairs(tbAwards) do
            if self:ParseConditionTable(tbAward.tbConditions) then
              if tbAward.szType == "exp" then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "exp", nValue = tbAward.varValue } })
              elseif tbAward.szType == "money" then
                if tbStepParams.nLevel < 30 then
                  table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
                else
                  table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "money", nValue = tbAward.varValue } })
                end
              elseif tbAward.szType == "bindmoney" then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
              elseif tbAward.szType == "makepoint" then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "makepoint", nValue = tbAward.varValue } })
              elseif tbAward.szType == "gatherpoint" then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "gatherpoint", nValue = tbAward.varValue } })
              elseif tbAward.szType == "item" then
                local tbItemId = tbAward.varValue
                local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
                local nItemNum = tbAward.szAddParam1
                assert(nItemNum >= 0, "奖励物品个数填错了")
                if nItemNum == 0 then
                  nItemNum = 1
                end
                table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nItemNum } })
              elseif tbAward.szType == "customizeitem" then
                local tbItemId = tbAward.varValue
                local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
                table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = 1 } })
              elseif tbAward.szType == "title" then
                local tbTitle = tbAward.varValue
              elseif tbAward.szType == "repute" then
                local tbRepute = tbAward.varValue
              elseif tbAward.szType == "taskvalue" then
                local tbTaskValue = tbAward.varValue
              elseif tbAward.szType == "script" then
                local szFnScript = tbAward.varValue
              elseif tbAward.szType == "arrary" then
              elseif tbAward.szType == "KinReputeEntry" then
              else
                for key, value in pairs(tbAward) do
                  print(key, value)
                  if type(value) == "table" then
                    for i, v in pairs(value) do
                      print(i, v)
                    end
                  end
                end
                print(tbStepParams.szSubTaskName)
                assert(false, "Exception Award!")
              end
            end
          end
        elseif #tbAwards.tbOpt ~= 0 then
          --- 领取可选奖励
          local tbAwards = tbAwards.tbOpt
          local nSelectedAward = MathRandom(#tbAwards)

          table.insert(tbStepCases[#tbStepCases], { "AcceptReward", { bAccept = 1, nSelectedAward = nSelectedAward, nNpcId = nNpcId, szTaskName = szSubTaskName } })

          local tbAward = tbAwards[nSelectedAward]
          if self:ParseConditionTable(tbAward.tbConditions) then
            if tbAward.szType == "exp" then
              table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "exp", nValue = tbAward.varValue } })
            elseif tbAward.szType == "money" then
              if tbStepParams.nLevel < 30 then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
              else
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "money", nValue = tbAward.varValue } })
              end
            elseif tbAward.szType == "bindmoney" then
              table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
            elseif tbAward.szType == "makepoint" then
              table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "makepoint", nValue = tbAward.varValue } })
            elseif tbAward.szType == "gatherpoint" then
              table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "gatherpoint", nValue = tbAward.varValue } })
            elseif tbAward.szType == "item" then
              local tbItemId = tbAward.varValue
              local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
              local nItemNum = tbAward.szAddParam1
              assert(nItemNum >= 0, "奖励物品个数填错了")
              if nItemNum == 0 then
                nItemNum = 1
              end
              table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nItemNum } })
            elseif tbAward.szType == "customizeitem" then
              local tbItemId = tbAward.varValue
              local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
              table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = 1 } })
            elseif tbAward.szType == "title" then
              local tbTitle = tbAward.varValue
            elseif tbAward.szType == "repute" then
              local tbRepute = tbAward.varValue
            elseif tbAward.szType == "taskvalue" then
              local tbTaskValue = tbAward.varValue
            elseif tbAward.szType == "script" then
              local szFnScript = tbAward.varValue
            elseif tbAward.szType == "arrary" then
            elseif tbAward.szType == "KinReputeEntry" then
            else
              for key, value in pairs(tbAward) do
                print(key, value)
                if type(value) == "table" then
                  for i, v in pairs(value) do
                    print(i, v)
                  end
                end
              end
              print(tbStepParams.szSubTaskName)
              assert(false, "Exception Award!")
            end
          else
            assert(false, "领取随机奖励失败")
          end
        elseif #tbAwards.tbRand ~= 0 then
          --- 领取随机奖励
          --- TODO: 目前暂时没有随机奖励的设定，暂不做考虑
        else
          print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId)
          print("没有填写任务奖励!")
          --	assert(false,"没有填写任务奖励!");
        end

        --- 领取奖励完后会有黑屏，先要过掉黑屏
        table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} })

        --- 领取奖励后，如果是询问接受任务，且此时子任务不是最后一个子任务，则接受，否则不接受
        local tbExecute = tbStepParams.tbExecute
        if #tbExecute ~= 0 then
          local nReferIdx = tbStepParams.nReferIdx
          local nSubNum = tbStepParams.nSubNum
          if nReferIdx ~= nSubNum then
            table.insert(tbStepCases[#tbStepCases], { "AcceptTask", { bAccept = 1 } })
          else
            table.insert(tbStepCases[#tbStepCases], { "AcceptTask", { bAccept = 0 } })
          end
        end
      end
    elseif szTargetName == "BagSpace" then
      --- 检测背包空间
      local nNeedSpaceCount = tbTarget.nNeedSpaceCount
      tbStepCases[#tbStepCases + 1] = {}
      table.insert(tbStepCases[#tbStepCases], { "ThrowAllItemExceptTaskItem", {} })
      table.insert(tbStepCases[#tbStepCases], { "BagHasSpace", { nEmptyNum = nNeedSpaceCount } })
      table.insert(tbStepCases[#tbStepCases], { "SaveStat", {} })
    elseif szTargetName == "CastSkill" then
      --- 释放技能
      local tbItemId = tbTarget.tbItemId
      local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }

      tbStepCases[#tbStepCases + 1] = {}
      table.insert(tbStepCases[#tbStepCases], { "UseItemInBag", { tbItem = tbItem, nDelay = 1 } })
      table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = -1 } })
      --- 释放完技能可能会为玩家添加新的物品，所以此处不保存状态
      --- table.insert(tbStepCases, {"SaveStat", {}});
    elseif szTargetName == "CastSkillAtArea" then
      --- 在指定位置释放技能
      local tbItemId = tbTarget.tbItemId
      local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
      local szItemName = tbTarget.szItemName
      local tbPos = tbTarget.tbPos
      assert(#tbPos ~= 0, "没有指定释放技能的位置")

      if not tbStepPath then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId, "CastSkillAtArea没有提供寻路坐标")
        assert(tbStepPath, "CastSkillAtArea没有提供寻路坐标")
      end

      tbStepCases[#tbStepCases + 1] = {}

      -------------========= 一些特殊Case的匹配处理  ==========------------
      local nTaskId = tbStepParams.nTaskId
      local nSubTaskId = tbStepParams.nSubTaskId
      local nStepId = tbStepParams.nStepId

      if nTaskId == 260 and nSubTaskId == 435 and nStepId == 1 then
        --- 【兵血】第1步，匹配寻路坐标"枫叶林"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      else
        if Task.AutoTest:FindPathByName(tbStepPath, szItemName) then
          local tbPath = Task.AutoTest:FindPathByName(tbStepPath, szItemName)
          tbStepCases[#tbStepCases].bMatch = true
          if tbPath.szType == "pos" then
            table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
          end
          if tbPath.szType == "npcpos" then
            table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
          end
        else
          for _, tbPos in pairs(tbPos) do
            local tbPath = Task.AutoTest:FindPathByPos(tbStepPath, tbPos[1], tbPos[2], tbPos[3], tbPos[4])
            if tbPath then
              tbStepCases[#tbStepCases].bMatch = true
              table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
              break
            end
          end
        end
      end

      if not tbStepCases[#tbStepCases].bMatch then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId)
        print("CastSkillAtArea找不到匹配的寻路坐标")
        assert(false, "CastSkillAtArea找不到匹配的寻路坐标")
      end

      table.insert(tbStepCases[#tbStepCases], { "SetFightState", { nState = 0 } }) --- 使用物品时将玩家设为非战斗状态，以免被怪干扰
      table.insert(tbStepCases[#tbStepCases], { "UseItemInBag", { tbItem = tbItem, nDelay = 12 } })
      table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = -1 } })
      table.insert(tbStepCases[#tbStepCases], { "SetFightState", { nState = 1 } })
      --- 释放完技能可能会为玩家添加新的物品，所以此处不保存状态
      --- table.insert(tbStepCases, {"SaveStat", {}});
    elseif szTargetName == "CastSkillAtAreaWithDesc" then
      --- 带描述的在指定位置释放技能
      local tbItemId = tbTarget.tbItemId
      local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
      local szItemName = tbTarget.szItemName
      local tbPos = tbTarget.tbPos
      assert(#tbPos ~= 0, "没有指定释放技能的位置")

      if not tbStepPath then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId, "CastSkillAtAreaWithDesc没有提供寻路坐标")
        assert(tbStepPath, "CastSkillAtAreaWithDesc没有提供寻路坐标")
      end

      tbStepCases[#tbStepCases + 1] = {}

      -------------========= 一些特殊Case的匹配处理  ==========------------
      local nTaskId = tbStepParams.nTaskId
      local nSubTaskId = tbStepParams.nSubTaskId
      local nStepId = tbStepParams.nStepId

      if nTaskId == 157 and nSubTaskId == 307 and nStepId == 6 then
        --- 【义军老板】第6步，匹配寻路坐标"大老白"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
      else
        if Task.AutoTest:FindPathByName(tbStepPath, szItemName) then
          local tbPath = Task.AutoTest:FindPathByName(tbStepPath, szItemName)
          tbStepCases[#tbStepCases].bMatch = true
          if tbPath.szType == "pos" then
            table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
          end
          if tbPath.szType == "npcpos" then
            table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
          end
        else
          for _, tbPos in pairs(tbPos) do
            local tbPath = Task.AutoTest:FindPathByPos(tbStepPath, tbPos[1], tbPos[2], tbPos[3], tbPos[4])
            if tbPath then
              tbStepCases[#tbStepCases].bMatch = true
              table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
              break
            end
          end
        end
      end

      if not tbStepCases[#tbStepCases].bMatch then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId)
        print("CastSkillAtAreaWithDesc找不到匹配的寻路坐标")
        assert(false, "CastSkillAtAreaWithDesc找不到匹配的寻路坐标")
      end

      table.insert(tbStepCases[#tbStepCases], { "SetFightState", { nState = 0 } }) --- 使用物品时将玩家设为非战斗状态，以免被怪干扰
      table.insert(tbStepCases[#tbStepCases], { "UseItemInBag", { tbItem = tbItem, nDelay = 12 } })
      table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = -1 } })
      table.insert(tbStepCases[#tbStepCases], { "SetFightState", { nState = 1 } })
      --- 释放完技能可能会为玩家添加新的物品，所以此处不保存状态
      --- table.insert(tbStepCases, {"SaveStat", {}});
    elseif szTargetName == "CatchNpc" then
      --- 捕捉
      local nNpcId = tbTarget.nNpcTempId
      local szNpcName = tbTarget.szNpcName
      local nMapId = tbTarget.nMapId
      local tbItemId = tbTarget.tbItemId
      local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
      local szItemName = tbTarget.szItemName
      local nNeedCount = tbTarget.nNeedCount

      if not tbStepPath then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId, "CatchNpc没有提供寻路坐标")
        assert(tbStepPath, "CatchNpc没有提供寻路坐标")
      end

      tbStepCases[#tbStepCases + 1] = {}
      table.insert(tbStepCases[#tbStepCases], { "BagHasSpace", { nEmptyNum = 1 } })

      -------------========= 一些特殊Case的匹配处理  ==========------------
      local nTaskId = tbStepParams.nTaskId
      local nSubTaskId = tbStepParams.nSubTaskId
      local nStepId = tbStepParams.nStepId

      if nTaskId == 2 and nSubTaskId == 12 and nStepId == 5 then
        --- 【高下立判】第5步直接通过寻路坐标找Npc
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 261 and nSubTaskId == 436 and nStepId == 1 then
        --- 【营啸】第1步，匹配寻路坐标"枫叶林"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      else
        if Task.AutoTest:FindPathByName(tbStepPath, szNpcName) then
          local tbPath = Task.AutoTest:FindPathByName(tbStepPath, szNpcName)
          tbStepCases[#tbStepCases].bMatch = true
          if tbPath.szType == "pos" then
            table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
          end
          if tbPath.szType == "npcpos" then
            table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
          end
        elseif Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcId) then
          local tbPath = Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcId)
          tbStepCases[#tbStepCases].bMatch = true
          table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
        else
          local nX, nY = KNpc.ClientGetNpcPos(nMapId, nNpcId)
          local tbPath = Task.AutoTest:FindPathByPos(tbStepPath, nMapId, nX, nY)
          if tbPath then
            tbStepCases[#tbStepCases].bMatch = true
            table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
          end
        end
      end

      if not tbStepCases[#tbStepCases].bMatch then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId)
        print("CatchNpc找不到匹配的寻路坐标")
        assert(false, "CatchNpc找不到匹配的寻路坐标")
      end

      if Task.AutoTest["CatchNpc"].bExtend == true then
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        Task.AutoTest["CatchNpc"].bExtend = false
      else
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
      end
      table.insert(tbStepCases[#tbStepCases], { "KillNpcForItems", { nNpcId = nNpcId, szItemName = szItemName, tbItem = tbItem, nCount = nNeedCount } })
      table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nNeedCount } })

      tbAddItems[#tbAddItems + 1] = {}
      tbAddItems[#tbAddItems].tbItem = tbItem
      tbAddItems[#tbAddItems].nItemNum = nNeedCount
    elseif szTargetName == "Dialog2Fight" then
      ---对话转战斗
      local nMapId = tbTarget.nMapId
      local nMapPosX = tbTarget.nMapPosX
      local nMapPosY = tbTarget.nMapPosY
      local nDialogNpcTempId = tbTarget.nDialogNpcTempId
      local szDialogNpcName = tbTarget.szDialogNpcName
      local szOption = tbTarget.szOption
      local szSubTaskName = tbStepParams.szSubTaskName

      if not tbStepPath then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId, "Dialog2Fight没有提供寻路坐标")
        assert(tbStepPath, "Dialog2Fight没有提供寻路坐标")
      end

      tbStepCases[#tbStepCases + 1] = {}
      if Task.AutoTest:FindPathByName(tbStepPath, szDialogNpcName) then
        local tbPath = Task.AutoTest:FindPathByName(tbStepPath, szDialogNpcName)
        tbStepCases[#tbStepCases].bMatch = true
        if tbPath.szType == "pos" then
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
          table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nDialogNpcTempId } })
          table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nDialogNpcTempId } })
        end
        if tbPath.szType == "npcpos" then
          table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
          table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nDialogNpcTempId } })
          table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nDialogNpcTempId } })
        end
      elseif Task.AutoTest:FindPathByNpcId(tbStepPath, nDialogNpcTempId) then
        local tbPath = Task.AutoTest:FindPathByNpcId(tbStepPath, nDialogNpcTempId)
        tbStepCases[#tbStepCases].bMatch = true
        table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nDialogNpcTempId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nDialogNpcTempId } })
      else
        local tbPath = Task.AutoTest:FindPathByPos(tbStepPath, nMapId, nMapPosX, nMapPosY)
        if tbPath then
          tbStepCases[#tbStepCases].bMatch = true
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
          table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nDialogNpcTempId } })
          table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nDialogNpcTempId } })
        end
      end

      if not tbStepCases[#tbStepCases].bMatch then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId)
        print("Dialog2Fight找不到匹配的寻路坐标")
        assert(false, "Dialog2Fight找不到匹配的寻路坐标")
      end

      table.insert(tbStepCases[#tbStepCases], { "InteractWithNpc", { nNpcId = nDialogNpcTempId } })
      if szOption == "<subtaskname>" then
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = szSubTaskName } })
      else
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = szOption } })
      end
      table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} }) --- 过掉对话时的黑屏

      local nFightNpcTempId = tbTarget.nFightNpcTempId
      table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nFightNpcTempId } })
      table.insert(tbStepCases[#tbStepCases], { "KillNpc", { nNpcId = nFightNpcTempId, nCount = 1 } })
    elseif szTargetName == "DialogNpc2FightNpc" then
      ---对话NPC切换为战斗NPC
      local nMapId = tbTarget.nMapId
      local nMapPosX = tbTarget.nMapPosX
      local nMapPosY = tbTarget.nMapPosY
      local nDialogNpcTempId = tbTarget.nDialogNpcTempId
      local szDialogNpcName = tbTarget.szDialogNpcName
      local szOption = tbTarget.szOption
      local szSubTaskName = tbStepParams.szSubTaskName

      if not tbStepPath then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId, "DialogNpc2FightNpc没有提供寻路坐标")
        assert(tbStepPath, "DialogNpc2FightNpc没有提供寻路坐标")
      end

      tbStepCases[#tbStepCases + 1] = {}
      if Task.AutoTest:FindPathByName(tbStepPath, szDialogNpcName) then
        local tbPath = Task.AutoTest:FindPathByName(tbStepPath, szDialogNpcName)
        tbStepCases[#tbStepCases].bMatch = true
        if tbPath.szType == "pos" then
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
          table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nDialogNpcTempId } })
          table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nDialogNpcTempId } })
        end
        if tbPath.szType == "npcpos" then
          table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
          table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nDialogNpcTempId } })
          table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nDialogNpcTempId } })
        end
      elseif Task.AutoTest:FindPathByNpcId(tbStepPath, nDialogNpcTempId) then
        local tbPath = Task.AutoTest:FindPathByNpcId(tbStepPath, nDialogNpcTempId)
        tbStepCases[#tbStepCases].bMatch = true
        table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nDialogNpcTempId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nDialogNpcTempId } })
      else
        local tbPath = Task.AutoTest:FindPathByPos(tbStepPath, nMapId, nMapPosX, nMapPosY)
        if tbPath then
          tbStepCases[#tbStepCases].bMatch = true
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
          table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nDialogNpcTempId } })
          table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nDialogNpcTempId } })
        end
      end

      if not tbStepCases[#tbStepCases].bMatch then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId)
        print("DialogNpc2FightNpc找不到匹配的寻路坐标")
        assert(false, "DialogNpc2FightNpc找不到匹配的寻路坐标")
      end

      table.insert(tbStepCases[#tbStepCases], { "InteractWithNpc", { nNpcId = nDialogNpcTempId } })
      if szOption == "<subtaskname>" then
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = szSubTaskName } })
      else
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = szOption } })
      end
      table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} }) --- 过掉对话时的黑屏

      local nFightNpcTempId = tbTarget.nFightNpcTempId
      table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nFightNpcTempId } })
      table.insert(tbStepCases[#tbStepCases], { "KillNpc", { nNpcId = nFightNpcTempId, nCount = 1 } })
    elseif szTargetName == "Fight2Dialog" then
      ---战斗转对话
      local nMapId = tbTarget.nMapId
      local nMapPosX = tbTarget.nMapPosX
      local nMapPosY = tbTarget.nMapPosY
      local nFightNpcTempId = tbTarget.nFightNpcTempId
      local szFightNpcName = tbTarget.szFightNpcName

      if not tbStepPath then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId, "Fight2Dialog没有提供寻路坐标")
        assert(tbStepPath, "Fight2Dialog没有提供寻路坐标")
      end

      tbStepCases[#tbStepCases + 1] = {}
      if Task.AutoTest:FindPathByName(tbStepPath, szFightNpcName) then
        local tbPath = Task.AutoTest:FindPathByName(tbStepPath, szFightNpcName)
        tbStepCases[#tbStepCases].bMatch = true
        if tbPath.szType == "pos" then
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        end
        if tbPath.szType == "npcpos" then
          table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
        end
      elseif Task.AutoTest:FindPathByNpcId(tbStepPath, nFightNpcTempId) then
        local tbPath = Task.AutoTest:FindPathByNpcId(tbStepPath, nFightNpcTempId)
        tbStepCases[#tbStepCases].bMatch = true
        table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
      else
        local tbPath = Task.AutoTest:FindPathByPos(tbStepPath, nMapId, nMapPosX, nMapPosY)
        if tbPath then
          tbStepCases[#tbStepCases].bMatch = true
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        end
      end

      if not tbStepCases[#tbStepCases].bMatch then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId)
        print("Fight2Dialog找不到匹配的寻路坐标")
        assert(false, "Fight2Dialog找不到匹配的寻路坐标")
      end

      if Task.AutoTest["Fight2Dialog"].bExtend == true then
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nFightNpcTempId, bExtend = true } })
        Task.AutoTest["Fight2Dialog"].bExtend = false
      else
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nFightNpcTempId } })
      end
      table.insert(tbStepCases[#tbStepCases], { "KillNpc", { nNpcId = nFightNpcTempId, nCount = 1 } })

      local nDialogNpcTempId = tbTarget.nDialogNpcTempId
      local szOption = tbTarget.szOption
      local szSubTaskName = tbStepParams.szSubTaskName
      table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nDialogNpcTempId } })
      table.insert(tbStepCases[#tbStepCases], { "InteractWithNpc", { nNpcId = nDialogNpcTempId } })
      if szOption == "<subtaskname>" then
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = szSubTaskName } })
      else
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = szOption } })
      end
      table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} })

      --- 对话完后可能会领取任务奖励
      local nStepId = tbStepParams.nStepId
      local nStepCount = tbStepParams.nStepCount
      if nStepId == nStepCount then
        --- 如果是最后一个步骤，需要领取奖励
        local nBagSpaceCount = tbStepParams.nBagSpaceCount
        local tbAwards = tbStepParams.tbAwards

        table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} }) --领奖可能会产生黑屏，要过掉
        if nBagSpaceCount > 0 then
          table.insert(tbStepCases[#tbStepCases], { "BagHasSpace", { nEmptyNum = nBagSpaceCount } })
        end

        if #tbAwards.tbFix ~= 0 then
          --- 领取固定奖励
          table.insert(tbStepCases[#tbStepCases], { "AcceptReward", { bAccept = 1, nSelectedAward = 0, nNpcId = nNpcId, szTaskName = szSubTaskName } })
          local tbAwards = tbAwards.tbFix
          for _, tbAward in pairs(tbAwards) do
            if self:ParseConditionTable(tbAward.tbConditions) then
              if tbAward.szType == "exp" then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "exp", nValue = tbAward.varValue } })
              elseif tbAward.szType == "money" then
                if tbStepParams.nLevel < 30 then
                  table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
                else
                  table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "money", nValue = tbAward.varValue } })
                end
              elseif tbAward.szType == "bindmoney" then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
              elseif tbAward.szType == "makepoint" then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "makepoint", nValue = tbAward.varValue } })
              elseif tbAward.szType == "gatherpoint" then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "gatherpoint", nValue = tbAward.varValue } })
              elseif tbAward.szType == "item" then
                local tbItemId = tbAward.varValue
                local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
                local nItemNum = tbAward.szAddParam1
                assert(nItemNum >= 0, "奖励物品个数填错了")
                if nItemNum == 0 then
                  nItemNum = 1
                end
                table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nItemNum } })
              elseif tbAward.szType == "customizeitem" then
                local tbItemId = tbAward.varValue
                local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
                table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = 1 } })
              elseif tbAward.szType == "title" then
                local tbTitle = tbAward.varValue
              elseif tbAward.szType == "repute" then
                local tbRepute = tbAward.varValue
              elseif tbAward.szType == "taskvalue" then
                local tbTaskValue = tbAward.varValue
              elseif tbAward.szType == "script" then
                local szFnScript = tbAward.varValue
              elseif tbAward.szType == "arrary" then
              elseif tbAward.szType == "KinReputeEntry" then
              else
                for key, value in pairs(tbAward) do
                  print(key, value)
                  if type(value) == "table" then
                    for i, v in pairs(value) do
                      print(i, v)
                    end
                  end
                end
                print(tbStepParams.szSubTaskName)
                assert(false, "Exception Award!")
              end
            end
          end
        elseif #tbAwards.tbOpt ~= 0 then
          --- 领取可选奖励
          local tbAwards = tbAwards.tbOpt
          local nSelectedAward = MathRandom(#tbAwards)

          table.insert(tbStepCases[#tbStepCases], { "AcceptReward", { bAccept = 1, nSelectedAward = nSelectedAward, nNpcId = nNpcId, szTaskName = szSubTaskName } })

          local tbAward = tbAwards[nSelectedAward]
          if self:ParseConditionTable(tbAward.tbConditions) then
            if tbAward.szType == "exp" then
              table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "exp", nValue = tbAward.varValue } })
            elseif tbAward.szType == "money" then
              if tbStepParams.nLevel < 30 then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
              else
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "money", nValue = tbAward.varValue } })
              end
            elseif tbAward.szType == "bindmoney" then
              table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
            elseif tbAward.szType == "makepoint" then
              table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "makepoint", nValue = tbAward.varValue } })
            elseif tbAward.szType == "gatherpoint" then
              table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "gatherpoint", nValue = tbAward.varValue } })
            elseif tbAward.szType == "item" then
              local tbItemId = tbAward.varValue
              local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
              local nItemNum = tbAward.szAddParam1
              assert(nItemNum >= 0, "奖励物品个数填错了")
              if nItemNum == 0 then
                nItemNum = 1
              end
              table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nItemNum } })
            elseif tbAward.szType == "customizeitem" then
              local tbItemId = tbAward.varValue
              local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
              table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = 1 } })
            elseif tbAward.szType == "title" then
              local tbTitle = tbAward.varValue
            elseif tbAward.szType == "repute" then
              local tbRepute = tbAward.varValue
            elseif tbAward.szType == "taskvalue" then
              local tbTaskValue = tbAward.varValue
            elseif tbAward.szType == "script" then
              local szFnScript = tbAward.varValue
            elseif tbAward.szType == "arrary" then
            elseif tbAward.szType == "KinReputeEntry" then
            else
              for key, value in pairs(tbAward) do
                print(key, value)
                if type(value) == "table" then
                  for i, v in pairs(value) do
                    print(i, v)
                  end
                end
              end
              print(tbStepParams.szSubTaskName)
              assert(false, "Exception Award!")
            end
          else
            assert(false, "领取随机奖励失败")
          end
        elseif #tbAwards.tbRand ~= 0 then
          --- 领取随机奖励
          --- TODO: 目前暂时没有随机奖励的设定，暂不做考虑
        else
          print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId)
          print("没有填写任务奖励!")
          --	assert(false,"没有填写任务奖励!");
        end

        --- 领取奖励完后会有黑屏，先要过掉黑屏
        table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} })

        --- 领取奖励后，如果是询问接受任务，且此时子任务不是最后一个子任务，则接受，否则不接受
        local tbExecute = tbStepParams.tbExecute
        if #tbExecute ~= 0 then
          local nReferIdx = tbStepParams.nReferIdx
          local nSubNum = tbStepParams.nSubNum
          if nReferIdx ~= nSubNum then
            table.insert(tbStepCases[#tbStepCases], { "AcceptTask", { bAccept = 1 } })
          else
            table.insert(tbStepCases[#tbStepCases], { "AcceptTask", { bAccept = 0 } })
          end
        end
      end
    elseif szTargetName == "FightNpc2DialogNpc" then
      ---战斗NPC转对话NPC
      local nMapId = tbTarget.nMapId
      local nMapPosX = tbTarget.nMapPosX
      local nMapPosY = tbTarget.nMapPosY
      local nFightNpcTempId = tbTarget.nFightNpcTempId
      local szFightNpcName = tbTarget.szFightNpcName

      if not tbStepPath then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId, "FightNpc2DialogNpc没有提供寻路坐标")
        assert(tbStepPath, "FightNpc2DialogNpc没有提供寻路坐标")
      end

      tbStepCases[#tbStepCases + 1] = {}

      -------------========= 一些特殊Case的匹配处理  ==========------------
      local nTaskId = tbStepParams.nTaskId
      local nSubTaskId = tbStepParams.nSubTaskId
      local nStepId = tbStepParams.nStepId

      if nTaskId == 1 and nSubTaskId == 1 and nStepId == 5 then
        --- 【瑛姑归来】第5步需要特殊匹配
        tbStepCases[#tbStepCases].bMatch = true
        Task.AutoTest["FightNpc2DialogNpc"].bExtend = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 21 and nSubTaskId == 150 and nStepId == 3 then
        --- 【密谋】第3步，给的寻路坐标是Trap点"小屋"
        tbStepCases[#tbStepCases].bMatch = true
        Task.AutoTest["FightNpc2DialogNpc"].bExtend = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      else
        --- 正常匹配
        if Task.AutoTest:FindPathByName(tbStepPath, szFightNpcName) then
          local tbPath = Task.AutoTest:FindPathByName(tbStepPath, szFightNpcName)
          tbStepCases[#tbStepCases].bMatch = true
          if tbPath.szType == "pos" then
            table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
          end
          if tbPath.szType == "npcpos" then
            table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
          end
        elseif Task.AutoTest:FindPathByNpcId(tbStepPath, nFightNpcTempId) then
          local tbPath = Task.AutoTest:FindPathByNpcId(tbStepPath, nFightNpcTempId)
          tbStepCases[#tbStepCases].bMatch = true
          table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
        else
          local tbPath = Task.AutoTest:FindPathByPos(tbStepPath, nMapId, nMapPosX, nMapPosY)
          if tbPath then
            tbStepCases[#tbStepCases].bMatch = true
            table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
          end
        end
      end

      if not tbStepCases[#tbStepCases].bMatch then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId)
        print("FightNpc2DialogNpc找不到匹配的寻路坐标")
        assert(false, "FightNpc2DialogNpc找不到匹配的寻路坐标")
      end

      if Task.AutoTest["FightNpc2DialogNpc"].bExtend == true then
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nFightNpcTempId, bExtend = true } })
        Task.AutoTest["FightNpc2DialogNpc"].bExtend = false
      else
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nFightNpcTempId } })
      end
      table.insert(tbStepCases[#tbStepCases], { "KillNpc", { nNpcId = nFightNpcTempId, nCount = 1 } })

      local nDialogNpcTempId = tbTarget.nDialogNpcTempId
      local szOption = tbTarget.szOption
      local szSubTaskName = tbStepParams.szSubTaskName
      table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nDialogNpcTempId } })
      table.insert(tbStepCases[#tbStepCases], { "InteractWithNpc", { nNpcId = nDialogNpcTempId } })
      if szOption == "<subtaskname>" then
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = szSubTaskName } })
      else
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = szOption } })
      end
      table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} })

      --- 对话完后可能会领取任务奖励
      local nStepId = tbStepParams.nStepId
      local nStepCount = tbStepParams.nStepCount
      if nStepId == nStepCount then
        --- 如果是最后一个步骤，需要领取奖励
        local nBagSpaceCount = tbStepParams.nBagSpaceCount
        local tbAwards = tbStepParams.tbAwards

        table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} }) --领奖可能会产生黑屏，要过掉
        if nBagSpaceCount > 0 then
          table.insert(tbStepCases[#tbStepCases], { "BagHasSpace", { nEmptyNum = nBagSpaceCount } })
        end

        if #tbAwards.tbFix ~= 0 then
          --- 领取固定奖励
          table.insert(tbStepCases[#tbStepCases], { "AcceptReward", { bAccept = 1, nSelectedAward = 0, nNpcId = nNpcId, szTaskName = szSubTaskName } })
          local tbAwards = tbAwards.tbFix
          for _, tbAward in pairs(tbAwards) do
            if self:ParseConditionTable(tbAward.tbConditions) then
              if tbAward.szType == "exp" then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "exp", nValue = tbAward.varValue } })
              elseif tbAward.szType == "money" then
                if tbStepParams.nLevel < 30 then
                  table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
                else
                  table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "money", nValue = tbAward.varValue } })
                end
              elseif tbAward.szType == "bindmoney" then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
              elseif tbAward.szType == "makepoint" then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "makepoint", nValue = tbAward.varValue } })
              elseif tbAward.szType == "gatherpoint" then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "gatherpoint", nValue = tbAward.varValue } })
              elseif tbAward.szType == "item" then
                local tbItemId = tbAward.varValue
                local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
                local nItemNum = tbAward.szAddParam1
                assert(nItemNum >= 0, "奖励物品个数填错了")
                if nItemNum == 0 then
                  nItemNum = 1
                end
                table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nItemNum } })
              elseif tbAward.szType == "customizeitem" then
                local tbItemId = tbAward.varValue
                local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
                table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = 1 } })
              elseif tbAward.szType == "title" then
                local tbTitle = tbAward.varValue
              elseif tbAward.szType == "repute" then
                local tbRepute = tbAward.varValue
              elseif tbAward.szType == "taskvalue" then
                local tbTaskValue = tbAward.varValue
              elseif tbAward.szType == "script" then
                local szFnScript = tbAward.varValue
              elseif tbAward.szType == "arrary" then
              elseif tbAward.szType == "KinReputeEntry" then
              else
                for key, value in pairs(tbAward) do
                  print(key, value)
                  if type(value) == "table" then
                    for i, v in pairs(value) do
                      print(i, v)
                    end
                  end
                end
                print(tbStepParams.szSubTaskName)
                assert(false, "Exception Award!")
              end
            end
          end
        elseif #tbAwards.tbOpt ~= 0 then
          --- 领取可选奖励
          local tbAwards = tbAwards.tbOpt
          local nSelectedAward = MathRandom(#tbAwards)

          table.insert(tbStepCases[#tbStepCases], { "AcceptReward", { bAccept = 1, nSelectedAward = nSelectedAward, nNpcId = nNpcId, szTaskName = szSubTaskName } })

          local tbAward = tbAwards[nSelectedAward]
          if self:ParseConditionTable(tbAward.tbConditions) then
            if tbAward.szType == "exp" then
              table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "exp", nValue = tbAward.varValue } })
            elseif tbAward.szType == "money" then
              if tbStepParams.nLevel < 30 then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
              else
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "money", nValue = tbAward.varValue } })
              end
            elseif tbAward.szType == "bindmoney" then
              table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
            elseif tbAward.szType == "makepoint" then
              table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "makepoint", nValue = tbAward.varValue } })
            elseif tbAward.szType == "gatherpoint" then
              table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "gatherpoint", nValue = tbAward.varValue } })
            elseif tbAward.szType == "item" then
              local tbItemId = tbAward.varValue
              local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
              local nItemNum = tbAward.szAddParam1
              assert(nItemNum >= 0, "奖励物品个数填错了")
              if nItemNum == 0 then
                nItemNum = 1
              end
              table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nItemNum } })
            elseif tbAward.szType == "customizeitem" then
              local tbItemId = tbAward.varValue
              local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
              table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = 1 } })
            elseif tbAward.szType == "title" then
              local tbTitle = tbAward.varValue
            elseif tbAward.szType == "repute" then
              local tbRepute = tbAward.varValue
            elseif tbAward.szType == "taskvalue" then
              local tbTaskValue = tbAward.varValue
            elseif tbAward.szType == "script" then
              local szFnScript = tbAward.varValue
            elseif tbAward.szType == "arrary" then
            elseif tbAward.szType == "KinReputeEntry" then
            else
              for key, value in pairs(tbAward) do
                print(key, value)
                if type(value) == "table" then
                  for i, v in pairs(value) do
                    print(i, v)
                  end
                end
              end
              print(tbStepParams.szSubTaskName)
              assert(false, "Exception Award!")
            end
          else
            assert(false, "领取随机奖励失败")
          end
        elseif #tbAwards.tbRand ~= 0 then
          --- 领取随机奖励
          --- TODO: 目前暂时没有随机奖励的设定，暂不做考虑
        else
          print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId)
          print("没有填写任务奖励!")
          --	assert(false,"没有填写任务奖励!");
        end

        --- 领取奖励完后会有黑屏，先要过掉黑屏
        table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} })

        --- 领取奖励后，如果是询问接受任务，且此时子任务不是最后一个子任务，则接受，否则不接受
        local tbExecute = tbStepParams.tbExecute
        if #tbExecute ~= 0 then
          local nReferIdx = tbStepParams.nReferIdx
          local nSubNum = tbStepParams.nSubNum
          if nReferIdx ~= nSubNum then
            table.insert(tbStepCases[#tbStepCases], { "AcceptTask", { bAccept = 1 } })
          else
            table.insert(tbStepCases[#tbStepCases], { "AcceptTask", { bAccept = 0 } })
          end
        end
      end
    elseif szTargetName == "GiveItem" then
      --- 上交指定物品（给予界面）
      --- 上交的物品都是之前获得的，此时不用记录，否则会重复
      local nNpcId = tbTarget.nNpcTempId
      local szNpcName = tbTarget.szNpcName
      local nMapId = tbTarget.nMapId
      local tbItemList = tbTarget.ItemList
      local szOption = tbTarget.szOption
      local szSubTaskName = tbStepParams.szSubTaskName

      if not tbStepPath then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId, "GiveItem没有提供寻路坐标")
        assert(tbStepPath, "GiveItem没有提供寻路坐标")
      end

      tbStepCases[#tbStepCases + 1] = {}

      -------------========= 一些特殊Case的匹配处理  ==========------------
      local nTaskId = tbStepParams.nTaskId
      local nSubTaskId = tbStepParams.nSubTaskId
      local nStepId = tbStepParams.nStepId

      if nTaskId == 12 and nSubTaskId == 94 and nStepId == 7 then
        --- 【神秘贵客】第7步，匹配寻路坐标"春梅雅筑后宅"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      else
        if Task.AutoTest:FindPathByName(tbStepPath, szNpcName) then
          local tbPath = Task.AutoTest:FindPathByName(tbStepPath, szNpcName)
          tbStepCases[#tbStepCases].bMatch = true
          if tbPath.szType == "pos" then
            table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
            table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
            table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
          end
          if tbPath.szType == "npcpos" then
            table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
            table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
            table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
          end
        elseif Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcId) then
          local tbPath = Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcId)
          tbStepCases[#tbStepCases].bMatch = true
          table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
          table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
          table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
        else
          local nX, nY = KNpc.ClientGetNpcPos(nMapId, nNpcId)
          local tbPath = Task.AutoTest:FindPathByPos(tbStepPath, nMapId, nX, nY)
          if tbPath then
            tbStepCases[#tbStepCases].bMatch = true
            table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
            table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
            table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
          end
        end
      end

      if not tbStepCases[#tbStepCases].bMatch then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId)
        print("GiveItem找不到匹配的寻路坐标")
        assert(false, "GiveItem找不到匹配的寻路坐标")
      end

      table.insert(tbStepCases[#tbStepCases], { "InteractWithNpc", { nNpcId = nNpcId } })
      if szOption == "<subtaskname>" then
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = szSubTaskName } })
      else
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = szOption } })
      end
      table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} })

      local tbItems = {}
      for i, tbTempItem in pairs(tbItemList) do
        tbItems[i] = {}
        local tbItem = { tbTempItem[1], tbTempItem[2], tbTempItem[3], tbTempItem[4] }
        local nItemNum = tbTempItem[6]
        tbItems[i].tbItem = tbItem
        tbItems[i].nItemNum = nItemNum

        tbGiveItems[#tbGiveItems + 1] = tbItem
      end

      table.insert(tbStepCases[#tbStepCases], { "GiveItems", { tbItems = tbItems } })

      --- 上交物品后可能会领取任务奖励
      local nStepId = tbStepParams.nStepId
      local nStepCount = tbStepParams.nStepCount
      if nStepId == nStepCount then
        --- 如果是最后一个步骤，需要领取奖励
        local nBagSpaceCount = tbStepParams.nBagSpaceCount
        local tbAwards = tbStepParams.tbAwards

        table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} }) --领奖可能会产生黑屏，要过掉
        if nBagSpaceCount > 0 then
          table.insert(tbStepCases[#tbStepCases], { "BagHasSpace", { nEmptyNum = nBagSpaceCount } })
        end

        if #tbAwards.tbFix ~= 0 then
          --- 领取固定奖励
          table.insert(tbStepCases[#tbStepCases], { "AcceptReward", { bAccept = 1, nSelectedAward = 0, nNpcId = nNpcId, szTaskName = szSubTaskName } })
          local tbAwards = tbAwards.tbFix
          for _, tbAward in pairs(tbAwards) do
            if self:ParseConditionTable(tbAward.tbConditions) then
              if tbAward.szType == "exp" then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "exp", nValue = tbAward.varValue } })
              elseif tbAward.szType == "money" then
                if tbStepParams.nLevel < 30 then
                  table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
                else
                  table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "money", nValue = tbAward.varValue } })
                end
              elseif tbAward.szType == "bindmoney" then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
              elseif tbAward.szType == "makepoint" then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "makepoint", nValue = tbAward.varValue } })
              elseif tbAward.szType == "gatherpoint" then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "gatherpoint", nValue = tbAward.varValue } })
              elseif tbAward.szType == "item" then
                local tbItemId = tbAward.varValue
                local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
                local nItemNum = tbAward.szAddParam1
                assert(nItemNum >= 0, "奖励物品个数填错了")
                if nItemNum == 0 then
                  nItemNum = 1
                end
                table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nItemNum } })
              elseif tbAward.szType == "customizeitem" then
                local tbItemId = tbAward.varValue
                local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
                table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = 1 } })
              elseif tbAward.szType == "title" then
                local tbTitle = tbAward.varValue
              elseif tbAward.szType == "repute" then
                local tbRepute = tbAward.varValue
              elseif tbAward.szType == "taskvalue" then
                local tbTaskValue = tbAward.varValue
              elseif tbAward.szType == "script" then
                local szFnScript = tbAward.varValue
              elseif tbAward.szType == "arrary" then
              elseif tbAward.szType == "KinReputeEntry" then
              else
                for key, value in pairs(tbAward) do
                  print(key, value)
                  if type(value) == "table" then
                    for i, v in pairs(value) do
                      print(i, v)
                    end
                  end
                end
                print(tbStepParams.szSubTaskName)
                assert(false, "Exception Award!")
              end
            end
          end
        elseif #tbAwards.tbOpt ~= 0 then
          --- 领取可选奖励
          local tbAwards = tbAwards.tbOpt
          local nSelectedAward = MathRandom(#tbAwards)

          table.insert(tbStepCases[#tbStepCases], { "AcceptReward", { bAccept = 1, nSelectedAward = nSelectedAward, nNpcId = nNpcId, szTaskName = szSubTaskName } })

          local tbAward = tbAwards[nSelectedAward]
          if self:ParseConditionTable(tbAward.tbConditions) then
            if tbAward.szType == "exp" then
              table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "exp", nValue = tbAward.varValue } })
            elseif tbAward.szType == "money" then
              if tbStepParams.nLevel < 30 then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
              else
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "money", nValue = tbAward.varValue } })
              end
            elseif tbAward.szType == "bindmoney" then
              table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
            elseif tbAward.szType == "makepoint" then
              table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "makepoint", nValue = tbAward.varValue } })
            elseif tbAward.szType == "gatherpoint" then
              table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "gatherpoint", nValue = tbAward.varValue } })
            elseif tbAward.szType == "item" then
              local tbItemId = tbAward.varValue
              local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
              local nItemNum = tbAward.szAddParam1
              assert(nItemNum >= 0, "奖励物品个数填错了")
              if nItemNum == 0 then
                nItemNum = 1
              end
              table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nItemNum } })
            elseif tbAward.szType == "customizeitem" then
              local tbItemId = tbAward.varValue
              local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
              table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = 1 } })
            elseif tbAward.szType == "title" then
              local tbTitle = tbAward.varValue
            elseif tbAward.szType == "repute" then
              local tbRepute = tbAward.varValue
            elseif tbAward.szType == "taskvalue" then
              local tbTaskValue = tbAward.varValue
            elseif tbAward.szType == "script" then
              local szFnScript = tbAward.varValue
            elseif tbAward.szType == "arrary" then
            elseif tbAward.szType == "KinReputeEntry" then
            else
              for key, value in pairs(tbAward) do
                print(key, value)
                if type(value) == "table" then
                  for i, v in pairs(value) do
                    print(i, v)
                  end
                end
              end
              print(tbStepParams.szSubTaskName)
              assert(false, "Exception Award!")
            end
          else
            assert(false, "领取随机奖励失败")
          end
        elseif #tbAwards.tbRand ~= 0 then
          --- 领取随机奖励
          --- TODO: 目前暂时没有随机奖励的设定，暂不做考虑
        else
          print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId)
          print("没有填写任务奖励!")
          --	assert(false,"没有填写任务奖励!");
        end

        --- 领取奖励完后会有黑屏，先要过掉黑屏
        table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} })

        --- 领取奖励后，如果是询问接受任务，且此时子任务不是最后一个子任务，则接受，否则不接受
        local tbExecute = tbStepParams.tbExecute
        if #tbExecute ~= 0 then
          local nReferIdx = tbStepParams.nReferIdx
          local nSubNum = tbStepParams.nSubNum
          if nReferIdx ~= nSubNum then
            table.insert(tbStepCases[#tbStepCases], { "AcceptTask", { bAccept = 1 } })
          else
            table.insert(tbStepCases[#tbStepCases], { "AcceptTask", { bAccept = 0 } })
          end
        end
      end
    elseif szTargetName == "GivePlayerItem" then
      --- 给玩家物品
      local nNpcId = tbTarget.nNpcTempId
      local szNpcName = tbTarget.szNpcName
      local nMapId = tbTarget.nMapId
      local tbItemList = tbTarget.tbItemList
      local tbRealItemList = self:ParseItemList(tbItemList)
      if #tbRealItemList == 0 then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nStepId)
        print("给玩家物品为空")
        assert(false, "给玩家物品为空")
      end
      local nNeedSpaceCount = #tbRealItemList
      local szOption = tbTarget.szOption
      local szSubTaskName = tbStepParams.szSubTaskName

      if not tbStepPath then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId, "GivePlayerItem没有提供寻路坐标")
        assert(tbStepPath, "GivePlayerItem没有提供寻路坐标")
      end

      tbStepCases[#tbStepCases + 1] = {}
      table.insert(tbStepCases[#tbStepCases], { "BagHasSpace", { nEmptyNum = nNeedSpaceCount } })

      -------------========= 一些特殊Case的匹配处理  ==========------------
      local nTaskId = tbStepParams.nTaskId
      local nSubTaskId = tbStepParams.nSubTaskId
      local nStepId = tbStepParams.nStepId

      if nTaskId == 8 and nSubTaskId == 69 and nStepId == 4 then
        --- 【家国大义】第4步，匹配寻路坐标"初祖庵"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 11 and nSubTaskId == 84 and nStepId == 1 then
        --- 【孤家寡人】第1步，匹配寻路坐标"布衣阁"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 12 and nSubTaskId == 85 and nStepId == 2 then
        --- 【罗盘定宝】第2步，匹配寻路坐标"春梅雅筑"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 12 and nSubTaskId == 86 and nStepId == 6 then
        --- 【罗盘定宝】第6步，匹配寻路坐标"春梅雅筑"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 12 and nSubTaskId == 87 and nStepId == 3 then
        --- 【祸起萧墙】第3步，匹配寻路坐标"春梅雅筑"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 12 and nSubTaskId == 89 and nStepId == 3 then
        --- 【玄月大阵】第3步，匹配寻路坐标"春梅雅筑"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 13 and nSubTaskId == 99 and nStepId == 2 then
        --- 【兵不厌诈】第2步，匹配寻路坐标"嘉王"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 14 and nSubTaskId == 105 and nStepId == 8 then
        --- 【秘道】第8步，匹配寻路坐标"嘉王"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[2]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 17 and nSubTaskId == 117 and nStepId == 1 then
        --- 【藏宝游戏】第1步，匹配寻路坐标"瑶纸扇"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[2]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      else
        if Task.AutoTest:FindPathByName(tbStepPath, szNpcName) then
          local tbPath = Task.AutoTest:FindPathByName(tbStepPath, szNpcName)
          tbStepCases[#tbStepCases].bMatch = true
          if tbPath.szType == "pos" then
            table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
            table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
            table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
          end
          if tbPath.szType == "npcpos" then
            table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
            table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
            table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
          end
        elseif Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcId) then
          local tbPath = Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcId)
          tbStepCases[#tbStepCases].bMatch = true
          table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
          table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
          table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
        else
          local nX, nY = KNpc.ClientGetNpcPos(nMapId, nNpcId)
          local tbPath = Task.AutoTest:FindPathByPos(tbStepPath, nMapId, nX, nY)
          if tbPath then
            tbStepCases[#tbStepCases].bMatch = true
            table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
            table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
            table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
          end
        end
      end

      if not tbStepCases[#tbStepCases].bMatch then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId)
        print("GivePlayerItem找不到匹配的寻路坐标")
        assert(false, "GivePlayerItem找不到匹配的寻路坐标")
      end

      table.insert(tbStepCases[#tbStepCases], { "InteractWithNpc", { nNpcId = nNpcId } })
      if szOption == "<subtaskname>" then
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = szSubTaskName } })
      else
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = szOption } })
      end
      table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} }) --- 如果对话完后有黑屏，直接过掉

      for _, tbTempItem in pairs(tbRealItemList) do
        local tbItemId = tbTempItem.tbItem
        local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
        local nItemNum = tbTempItem.nItemNum
        table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nItemNum } })

        tbAddItems[#tbAddItems + 1] = {}
        tbAddItems[#tbAddItems].tbItem = tbItem
        tbAddItems[#tbAddItems].nItemNum = nItemNum
      end

      --- 给物品后可能会领取任务奖励
      local nStepId = tbStepParams.nStepId
      local nStepCount = tbStepParams.nStepCount
      if nStepId == nStepCount then
        --- 如果是最后一个步骤，需要领取奖励
        local nBagSpaceCount = tbStepParams.nBagSpaceCount
        local tbAwards = tbStepParams.tbAwards

        table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} }) --领奖可能会产生黑屏，要过掉
        if nBagSpaceCount > 0 then
          table.insert(tbStepCases[#tbStepCases], { "BagHasSpace", { nEmptyNum = nBagSpaceCount } })
        end

        if #tbAwards.tbFix ~= 0 then
          --- 领取固定奖励
          table.insert(tbStepCases[#tbStepCases], { "AcceptReward", { bAccept = 1, nSelectedAward = 0, nNpcId = nNpcId, szTaskName = szSubTaskName } })
          local tbAwards = tbAwards.tbFix
          for _, tbAward in pairs(tbAwards) do
            if self:ParseConditionTable(tbAward.tbConditions) then
              if tbAward.szType == "exp" then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "exp", nValue = tbAward.varValue } })
              elseif tbAward.szType == "money" then
                if tbStepParams.nLevel < 30 then
                  table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
                else
                  table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "money", nValue = tbAward.varValue } })
                end
              elseif tbAward.szType == "bindmoney" then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
              elseif tbAward.szType == "makepoint" then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "makepoint", nValue = tbAward.varValue } })
              elseif tbAward.szType == "gatherpoint" then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "gatherpoint", nValue = tbAward.varValue } })
              elseif tbAward.szType == "item" then
                local tbItemId = tbAward.varValue
                local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
                local nItemNum = tbAward.szAddParam1
                assert(nItemNum >= 0, "奖励物品个数填错了")
                if nItemNum == 0 then
                  nItemNum = 1
                end
                table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nItemNum } })
              elseif tbAward.szType == "customizeitem" then
                local tbItemId = tbAward.varValue
                local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
                table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = 1 } })
              elseif tbAward.szType == "title" then
                local tbTitle = tbAward.varValue
              elseif tbAward.szType == "repute" then
                local tbRepute = tbAward.varValue
              elseif tbAward.szType == "taskvalue" then
                local tbTaskValue = tbAward.varValue
              elseif tbAward.szType == "script" then
                local szFnScript = tbAward.varValue
              elseif tbAward.szType == "arrary" then
              elseif tbAward.szType == "KinReputeEntry" then
              else
                for key, value in pairs(tbAward) do
                  print(key, value)
                  if type(value) == "table" then
                    for i, v in pairs(value) do
                      print(i, v)
                    end
                  end
                end
                print(tbStepParams.szSubTaskName)
                assert(false, "Exception Award!")
              end
            end
          end
        elseif #tbAwards.tbOpt ~= 0 then
          --- 领取可选奖励
          local tbAwards = tbAwards.tbOpt
          local nSelectedAward = MathRandom(#tbAwards)

          table.insert(tbStepCases[#tbStepCases], { "AcceptReward", { bAccept = 1, nSelectedAward = nSelectedAward, nNpcId = nNpcId, szTaskName = szSubTaskName } })

          local tbAward = tbAwards[nSelectedAward]
          if self:ParseConditionTable(tbAward.tbConditions) then
            if tbAward.szType == "exp" then
              table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "exp", nValue = tbAward.varValue } })
            elseif tbAward.szType == "money" then
              if tbStepParams.nLevel < 30 then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
              else
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "money", nValue = tbAward.varValue } })
              end
            elseif tbAward.szType == "bindmoney" then
              table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
            elseif tbAward.szType == "makepoint" then
              table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "makepoint", nValue = tbAward.varValue } })
            elseif tbAward.szType == "gatherpoint" then
              table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "gatherpoint", nValue = tbAward.varValue } })
            elseif tbAward.szType == "item" then
              local tbItemId = tbAward.varValue
              local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
              local nItemNum = tbAward.szAddParam1
              assert(nItemNum >= 0, "奖励物品个数填错了")
              if nItemNum == 0 then
                nItemNum = 1
              end
              table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nItemNum } })
            elseif tbAward.szType == "customizeitem" then
              local tbItemId = tbAward.varValue
              local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
              table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = 1 } })
            elseif tbAward.szType == "title" then
              local tbTitle = tbAward.varValue
            elseif tbAward.szType == "repute" then
              local tbRepute = tbAward.varValue
            elseif tbAward.szType == "taskvalue" then
              local tbTaskValue = tbAward.varValue
            elseif tbAward.szType == "script" then
              local szFnScript = tbAward.varValue
            elseif tbAward.szType == "arrary" then
            elseif tbAward.szType == "KinReputeEntry" then
            else
              for key, value in pairs(tbAward) do
                print(key, value)
                if type(value) == "table" then
                  for i, v in pairs(value) do
                    print(i, v)
                  end
                end
              end
              print(tbStepParams.szSubTaskName)
              assert(false, "Exception Award!")
            end
          else
            assert(false, "领取随机奖励失败")
          end
        elseif #tbAwards.tbRand ~= 0 then
          --- 领取随机奖励
          --- TODO: 目前暂时没有随机奖励的设定，暂不做考虑
        else
          print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId)
          print("没有填写任务奖励!")
          --	assert(false,"没有填写任务奖励!");
        end

        --- 领取奖励完后会有黑屏，先要过掉黑屏
        table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} })

        --- 领取奖励后，如果是询问接受任务，且此时子任务不是最后一个子任务，则接受，否则不接受
        local tbExecute = tbStepParams.tbExecute
        if #tbExecute ~= 0 then
          local nReferIdx = tbStepParams.nReferIdx
          local nSubNum = tbStepParams.nSubNum
          if nReferIdx ~= nSubNum then
            table.insert(tbStepCases[#tbStepCases], { "AcceptTask", { bAccept = 1 } })
          else
            table.insert(tbStepCases[#tbStepCases], { "AcceptTask", { bAccept = 0 } })
          end
        end
      end
    elseif szTargetName == "GoPos" then
      --- 探索地图
      local nMapId = tbTarget.nMapId
      local nPosX = tbTarget.nPosX
      local nPosY = tbTarget.nPosY
      local nR = tbTarget.nR
      local szPosDesc = tbTarget.szPosDesc

      if not tbStepPath then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId, "GoPos没有提供寻路坐标")
        assert(tbStepPath, "GoPos没有提供寻路坐标")
      end
      tbStepCases[#tbStepCases + 1] = {}

      -------------========= 一些特殊Case的匹配处理  ==========------------
      local nTaskId = tbStepParams.nTaskId
      local nSubTaskId = tbStepParams.nSubTaskId
      local nStepId = tbStepParams.nStepId

      if nTaskId == 14 and nSubTaskId == 101 and nStepId == 3 then
        --- 【勤王】第3步，匹配寻路坐标"分舵内部"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 18 and nSubTaskId == 124 and nStepId == 4 then
        --- 【争夺】第4步，一次匹配寻路坐标"捷径"和"内部"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        tbPath = tbStepPath[2]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      else
        if Task.AutoTest:FindPathByName(tbStepPath, szPosDesc) then
          local tbPath = Task.AutoTest:FindPathByName(tbStepPath, szPosDesc)
          tbStepCases[#tbStepCases].bMatch = true
          if tbPath.szType == "pos" then
            table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
          end
          if tbPath.szType == "npcpos" then
            table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
          end
        elseif Task.AutoTest:FindPathByPos(tbStepPath, nMapId, nPosX, nPosY, nR) then
          local tbPath = Task.AutoTest:FindPathByPos(tbStepPath, nMapId, nPosX, nPosY, nR)
          tbStepCases[#tbStepCases].bMatch = true
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        end
      end

      if not tbStepCases[#tbStepCases].bMatch then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId)
        print("GoPos找不到匹配的寻路坐标")
        assert(false, "GoPos找不到匹配的寻路坐标")
      end
    elseif szTargetName == "GuardNpc" then
      --- 守卫NPC
      local nMapId = tbTarget.nMapId
      local nMapPosX = tbTarget.nMapPosX
      local nMapPosY = tbTarget.nMapPosY
      local nDialogNpcTempId = tbTarget.nDialogNpcTempId
      local szDialogNpcName = tbTarget.szDialogNpcName
      local szOption = tbTarget.szOption
      local szSubTaskName = tbStepParams.szSubTaskName

      if not tbStepPath then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId, "GuardNpc没有提供寻路坐标")
        assert(tbStepPath, "GuardNpc没有提供寻路坐标")
      end

      tbStepCases[#tbStepCases + 1] = {}
      if Task.AutoTest:FindPathByName(tbStepPath, szDialogNpcName) then
        local tbPath = Task.AutoTest:FindPathByName(tbStepPath, szDialogNpcName)
        tbStepCases[#tbStepCases].bMatch = true
        if tbPath.szType == "pos" then
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
          table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nDialogNpcTempId } })
          table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nDialogNpcTempId } })
        end
        if tbPath.szType == "npcpos" then
          table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
          table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nDialogNpcTempId } })
          table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nDialogNpcTempId } })
        end
      elseif Task.AutoTest:FindPathByNpcId(tbStepPath, nDialogNpcTempId) then
        local tbPath = Task.AutoTest:FindPathByNpcId(tbStepPath, nDialogNpcTempId)
        tbStepCases[#tbStepCases].bMatch = true
        table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nDialogNpcTempId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nDialogNpcTempId } })
      else
        local tbPath = Task.AutoTest:FindPathByPos(tbStepPath, nMapId, nMapPosX, nMapPosY)
        if tbPath then
          tbStepCases[#tbStepCases].bMatch = true
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
          table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nDialogNpcTempId } })
          table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nDialogNpcTempId } })
        end
      end

      if not tbStepCases[#tbStepCases].bMatch then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId)
        print("GuardNpc找不到匹配的寻路坐标")
        assert(false, "GuardNpc找不到匹配的寻路坐标")
      end

      table.insert(tbStepCases[#tbStepCases], { "InteractWithNpc", { nNpcId = nDialogNpcTempId } })
      if szOption == "<subtaskname>" then
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = szSubTaskName } })
      else
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = szOption } })
      end
      table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} })

      local nFightNpcTempId = tbTarget.nFightNpcTempId
      local nGuardDuration = tbTarget.nGuardDuration
      table.insert(tbStepCases[#tbStepCases], { "FindNpc", nNpcId = nFightNpcTempId })
      table.insert(tbStepCases[#tbStepCases], { "GuardNpc", { nNpcId = nFightNpcTempId, nGuardDuration = nGuardDuration } })
    elseif szTargetName == "InsightBook" then
      --- 心得书,通过很多途径都可以加心得（如打宋金），直到加满指定心得量完成任务
      local nMaxLimit = tbTarget.nMaxLimit
      local szCmd = "Task : AddInsight(" .. tostring(nMaxLimit) .. ")"
      tbStepCases[#tbStepCases + 1] = {}
      table.insert(tbStepCases[#tbStepCases], { "GMServer", { szCmd = szCmd } })
    elseif szTargetName == "JoinFaction" then
      --- 加入指定门派（目前就教育任务"十二门派"有这个目标，暂时定为加入少林）
      local nFactionId = tbTarget.nFactionId
      --	local szCmd 		= "me.JoinFaction("..tostring(nFactionId)..")";
      local szCmd1 = "me.JoinFaction(1)"
      local szCmd2 = "me.LevelUpFightSkill(2,29)"
      tbStepCases[#tbStepCases + 1] = {}
      table.insert(tbStepCases[#tbStepCases], { "GMServer", { szCmd = szCmd1 } })
      table.insert(tbStepCases[#tbStepCases], { "GMClient", { szCmd = szCmd2 } })
      table.insert(tbStepCases[#tbStepCases], { "SetSkill", { nSkillId = 475 } })
    elseif szTargetName == "KillBoss4Item" then
      --- 杀boss找物品
      local nNpcTempId = tbTarget.nNpcTempId
      local szNpcName = tbTarget.szNpcName
      local nMapId = tbTarget.nMapId
      local tbItemId = tbTarget.tbItemId
      local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
      local szItemName = tbTarget.szItemName
      local nNeedCount = tbTarget.nNeedCount
      local bDelete = tbTarget.bDelete --- 表示目标完成后是否销毁

      if not tbStepPath then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId, "KillBoss4Item没有提供寻路坐标")
        assert(tbStepPath, "KillBoss4Item没有提供寻路坐标")
      end

      tbStepCases[#tbStepCases + 1] = {}
      table.insert(tbStepCases[#tbStepCases], { "BagHasSpace", { nEmptyNum = 1 } })

      -------------========= 一些特殊Case的匹配处理  ==========------------
      local nTaskId = tbStepParams.nTaskId
      local nSubTaskId = tbStepParams.nSubTaskId
      local nStepId = tbStepParams.nStepId

      if nTaskId == 4 and nSubTaskId == 26 and nStepId == 4 then
        --- 【红旗旗主1A】第4步，匹配寻路坐标“冒充五毒教的男人”
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 5 and nSubTaskId == 39 and nStepId == 4 then
        --- 【红旗旗主27】第4步，匹配寻路坐标“冒充五毒教的男人”
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 6 and nSubTaskId == 54 and nStepId == 2 then
        --- 【大变突起】第2步，只给了一个寻路坐标"剑齿峡"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 19 and nSubTaskId == 128 and nStepId == 3 then
        --- 【新发现】第3步，匹配寻路坐标"副旗主"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      else
        if Task.AutoTest:FindPathByName(tbStepPath, szNpcName) then
          local tbPath = Task.AutoTest:FindPathByName(tbStepPath, szNpcName)
          tbStepCases[#tbStepCases].bMatch = true
          if tbPath.szType == "pos" then
            table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
          end
          if tbPath.szType == "npcpos" then
            table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
          end
        elseif Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcTempId) then
          local tbPath = Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcTempId)
          tbStepCases[#tbStepCases].bMatch = true
          table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
        else
          local nX, nY = KNpc.ClientGetNpcPos(nMapId, nNpcTempId)
          local tbPath = Task.AutoTest:FindPathByPos(tbStepPath, nMapId, nX, nY)
          if tbPath then
            tbStepCases[#tbStepCases].bMatch = true
            table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
          end
        end
      end

      if not tbStepCases[#tbStepCases].bMatch then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId)
        print("KillBoss4Item找不到匹配的寻路坐标")
        assert(false, "KillBoss4Item找不到匹配的寻路坐标")
      end

      if Task.AutoTest["KillBoss4Item"].bExtend == true then
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcTempId, bExtend = true } })
        Task.AutoTest["KillBoss4Item"].bExtend = false
      else
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcTempId } })
      end
      table.insert(tbStepCases[#tbStepCases], { "KillNpcForItems", { nNpcId = nNpcTempId, szItemName = szItemName, tbItem = tbItem, nCount = nNeedCount } })

      if not bDelete then
        table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nNeedCount } })

        tbAddItems[#tbAddItems + 1] = {}
        tbAddItems[#tbAddItems].tbItem = tbItem
        tbAddItems[#tbAddItems].nItemNum = nNeedCount
      end
    elseif szTargetName == "KillBoss" then
      --- 杀boss
      local nNpcTempId = tbTarget.nNpcTempId
      local szNpcName = tbTarget.szNpcName
      local nMapId = tbTarget.nMapId
      local nNeedCount = tbTarget.nNeedCount

      if not tbStepPath then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId, "KillBoss没有提供寻路坐标")
        assert(tbStepPath, "KillBoss没有提供寻路坐标")
      end

      tbStepCases[#tbStepCases + 1] = {}

      -------------========= 一些特殊Case的匹配处理  ==========------------
      local nTaskId = tbStepParams.nTaskId
      local nSubTaskId = tbStepParams.nSubTaskId
      local nStepId = tbStepParams.nStepId

      if nTaskId == 1 and nSubTaskId == 1 and nStepId == 4 then
        --- 【瑛姑归来】第4步只个了Trap点坐标
        tbStepCases[#tbStepCases].bMatch = true
        Task.AutoTest["KillBoss"].bExtend = true
        Task.AutoTest["KillBoss"].nCount = Task.AutoTest["KillBoss"].nCount + 1
        if Task.AutoTest["KillBoss"].nCount == 1 then
          local tbPath = tbStepPath[1]
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        end
        if Task.AutoTest["KillBoss"].nCount == 2 then
          local tbPath = tbStepPath[1]
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = 1591, nY = 3227 } })
        end
        if Task.AutoTest["KillBoss"].nCount == 3 then
          local tbPath = tbStepPath[1]
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = 1610, nY = 3206 } })
          Task.AutoTest["KillBoss"].nCount = 0
        end
      elseif nTaskId == 1 and nSubTaskId == 3 and nStepId == 2 then
        --- 【神秘信使】第5步只给了神秘杀手的寻路，boss红狼在神秘杀手附近
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 4 and nSubTaskId == 27 and nStepId == 4 then
        --- 【夷人的狩猎1B】第4步，匹配寻路坐标“三箭岩的高地”
        local tbPath = tbStepPath[1]
        tbStepCases[#tbStepCases].bMatch = true
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 6 and nSubTaskId == 55 and nStepId == 9 then
        --- 【惊心动魄】第9步，匹配寻路坐标"守护者之王"
        local tbPath = tbStepPath[1]
        tbStepCases[#tbStepCases].bMatch = true
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 7 and nSubTaskId == 63 and nStepId == 2 then
        --- 【匪夷所思】第2步，需要匹配寻路坐标"假冒僧人"
        local tbPath = tbStepPath[2]
        tbStepCases[#tbStepCases].bMatch = true
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 8 and nSubTaskId == 65 and nStepId == 2 then
        --- 【雷霆手段】第2步，4个目标只给了一个寻路坐标，4个boss应该都在附近
        local tbPath = tbStepPath[1]
        tbStepCases[#tbStepCases].bMatch = true
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 9 and nSubTaskId == 73 and nStepId == 1 then
        --- 【彪悍之徒】第1步只给了Trap点"蒙古人的牢房"
        tbStepCases[#tbStepCases].bMatch = true
        Task.AutoTest["KillBoss"].bExtend = true
        Task.AutoTest["KillBoss"].nCount = Task.AutoTest["KillBoss"].nCount + 1
        if Task.AutoTest["KillBoss"].nCount == 1 then
          local tbPath = tbStepPath[1]
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        end
        if Task.AutoTest["KillBoss"].nCount == 5 then
          Task.AutoTest["KillBoss"].nCount = 0
        end
      elseif nTaskId == 9 and nSubTaskId == 73 and nStepId == 3 then
        --- 【彪悍之徒】第3步只个了Trap点"地字牢"
        tbStepCases[#tbStepCases].bMatch = true
        Task.AutoTest["KillBoss"].bExtend = true
        Task.AutoTest["KillBoss"].nCount = Task.AutoTest["KillBoss"].nCount + 1
        if Task.AutoTest["KillBoss"].nCount == 1 then
          local tbPath = tbStepPath[1]
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        end
        if Task.AutoTest["KillBoss"].nCount == 4 then
          Task.AutoTest["KillBoss"].nCount = 0
        end
      elseif nTaskId == 12 and nSubTaskId == 90 and nStepId == 3 then
        --- 【擒贼擒王】第3步，要杀"来敌首领"，给的寻路坐标是"钟灵秀"
        local tbPath = tbStepPath[1]
        tbStepCases[#tbStepCases].bMatch = true
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 265 and nSubTaskId == 440 and nStepId == 1 then
        --- 【勇士许俊】第1步，匹配寻路坐标"许俊"
        local tbPath = tbStepPath[1]
        tbStepCases[#tbStepCases].bMatch = true
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      else
        --- 正常的匹配
        if Task.AutoTest:FindPathByName(tbStepPath, szNpcName) then
          local tbPath = Task.AutoTest:FindPathByName(tbStepPath, szNpcName)
          tbStepCases[#tbStepCases].bMatch = true
          if tbPath.szType == "pos" then
            table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
          end
          if tbPath.szType == "npcpos" then
            table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
          end
        elseif Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcTempId) then
          local tbPath = Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcTempId)
          tbStepCases[#tbStepCases].bMatch = true
          table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
        else
          local nX, nY = KNpc.ClientGetNpcPos(nMapId, nNpcTempId)
          local tbPath = Task.AutoTest:FindPathByPos(tbStepPath, nMapId, nX, nY)
          if tbPath then
            tbStepCases[#tbStepCases].bMatch = true
            table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
          end
        end
      end

      if not tbStepCases[#tbStepCases].bMatch then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId)
        print("KillBoss找不到匹配的寻路坐标")
        assert(false, "KillBoss找不到匹配的寻路坐标")
      end

      if Task.AutoTest["KillBoss"].bExtend == true then
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcTempId, bExtend = true } })
        Task.AutoTest["KillBoss"].bExtend = false
      else
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcTempId } })
      end
      table.insert(tbStepCases[#tbStepCases], { "KillNpc", { nNpcId = nNpcTempId, nCount = nNeedCount } })
    elseif szTargetName == "KillNpc4Item" then
      --- 杀怪找任务物品
      local nNpcTempId = tbTarget.nNpcTempId
      local szNpcName = tbTarget.szNpcName
      local nMapId = tbTarget.nMapId
      local tbItemId = tbTarget.tbItemId
      local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
      local szItemName = tbTarget.szItemName
      local nNeedCount = tbTarget.nNeedCount
      local bDelete = tbTarget.bDelete

      tbStepCases[#tbStepCases + 1] = {}
      table.insert(tbStepCases[#tbStepCases], { "BagHasSpace", { nEmptyNum = 1 } })

      if not tbStepPath then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId, "KillNpc4Item没有提供寻路坐标")
        assert(tbStepPath, "KillNpc4Item没有提供寻路坐标")
      end

      -------------========= 一些特殊Case的匹配处理  ==========------------
      local nTaskId = tbStepParams.nTaskId
      local nSubTaskId = tbStepParams.nSubTaskId
      local nStepId = tbStepParams.nStepId

      if nTaskId == 2 and nSubTaskId == 16 and nStepId == 1 then
        ---【影社之秘】第1步直接用寻路坐标找Npc
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 2 and nSubTaskId == 23 and nStepId == 2 then
        ---【遗恨】第2步直接用寻路坐标找Npc
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 4 and nSubTaskId == 34 and nStepId == 2 then
        --- 【又见天王22】第2步直接匹配寻路坐标"入侵武士"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 5 and nSubTaskId == 47 and nStepId == 2 then
        --- 【又见天王2F】第2步直接匹配寻路坐标"入侵武士"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 7 and nSubTaskId == 61 and nStepId == 5 then
        --- 【神僧空无】第5步，匹配Trap点"雷神洞"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        Task.AutoTest["KillNpc4Item"].bExtend = true
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 11 and nSubTaskId == 82 and nStepId == 3 then
        --- 【秋狩】第3步，匹配寻路坐标"狩猎地"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 44 and nSubTaskId == 192 and nStepId == 1 then
        --- 【屠村】第1步，匹配寻路坐标"瑶山部族男子"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 111 and nSubTaskId == 260 and nStepId == 1 then
        --- 【迅狼酒】第1步，匹配寻路坐标"绿洲"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 157 and nSubTaskId == 319 and nStepId == 1 then
        --- 【不堪回首】第1步，匹配寻路坐标"熊瞎子"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
      elseif nTaskId == 202 and nSubTaskId == 365 and nStepId == 1 then
        --- 【江湖往事】第1步，匹配寻路坐标"独孤盟主的遗物"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = 2597 } })
        table.insert(tbStepCases[#tbStepCases], { "InteractWithNpc", { nNpcId = 2597 } })
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = "龙泉村" } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = 3565 } })
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = "杂货" } })
        table.insert(tbStepCases[#tbStepCases], { "SaveSingleStat", { szState = "money", nValue = -500 } })
        table.insert(tbStepCases[#tbStepCases], { "BuyItem", { szItemName = "传送符（城市）", nCount = 1 } })
        table.insert(tbStepCases[#tbStepCases], { "UseItemInBag", { szItemName = "传送符（城市）", nDelay = 1 } })
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = "临安府" } })
        tbPath = tbStepPath[2]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 242 and nSubTaskId == 417 and nStepId == 1 then
        --- 【长歌三杰】第1步，匹配寻路坐标"雪狼豪"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 254 and nSubTaskId == 429 and nStepId == 1 then
        --- 【厉兵秣马】第1步，匹配寻路坐标"神秘军队"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 267 and nSubTaskId == 442 and nStepId == 1 then
        --- 【终有一死】第1步，匹配寻路坐标"紧身玉"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      else
        if Task.AutoTest:FindPathByName(tbStepPath, szNpcName) then
          local tbPath = Task.AutoTest:FindPathByName(tbStepPath, szNpcName)
          tbStepCases[#tbStepCases].bMatch = true
          if tbPath.szType == "pos" then
            table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
          end
          if tbPath.szType == "npcpos" then
            table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
          end
        elseif Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcTempId) then
          local tbPath = Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcTempId)
          tbStepCases[#tbStepCases].bMatch = true
          table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
        else
          local nX, nY = KNpc.ClientGetNpcPos(nMapId, nNpcTempId)
          local tbPath = Task.AutoTest:FindPathByPos(tbStepPath, nMapId, nX, nY)
          if tbPath then
            tbStepCases[#tbStepCases].bMatch = true
            table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
          end
        end
      end

      if not tbStepCases[#tbStepCases].bMatch then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId)
        print("KillNpc4Item找不到匹配的寻路坐标")
        assert(false, "KillNpc4Item找不到匹配的寻路坐标")
      end

      if Task.AutoTest["KillNpc4Item"].bExtend == true then
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcTempId, bExtend = true } })
        Task.AutoTest["KillNpc4Item"].bExtend = false
      else
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcTempId } })
      end
      table.insert(tbStepCases[#tbStepCases], { "KillNpcForItems", { nNpcId = nNpcTempId, szItemName = szItemName, tbItem = tbItem, nCount = nNeedCount } })

      if not bDelete then
        table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nNeedCount } })

        tbAddItems[#tbAddItems + 1] = {}
        tbAddItems[#tbAddItems].tbItem = tbItem
        tbAddItems[#tbAddItems].nItemNum = nNeedCount
      end
    elseif szTargetName == "KillNpc4NormalItem" then
      --- 杀怪找物品
      local nNpcTempId = tbTarget.nNpcTempId
      local szNpcName = tbTarget.szNpcName
      local nMapId = tbTarget.nMapId
      local tbItemId = tbTarget.tbItemId
      local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
      local szItemName = tbTarget.szItemName
      local nNeedCount = tbTarget.nNeedCount
      local bDelete = tbTarget.bDelete

      tbStepCases[#tbStepCases + 1] = {}
      table.insert(tbStepCases[#tbStepCases], { "BagHasSpace", { nEmptyNum = 1 } })

      if not tbStepPath then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId, "KillNpc4NormalItem没有提供寻路坐标")
        assert(tbStepPath, "KillNpc4NormalItem没有提供寻路坐标")
      end

      if Task.AutoTest:FindPathByName(tbStepPath, szNpcName) then
        local tbPath = Task.AutoTest:FindPathByName(tbStepPath, szNpcName)
        tbStepCases[#tbStepCases].bMatch = true
        if tbPath.szType == "pos" then
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        end
        if tbPath.szType == "npcpos" then
          table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
        end
      elseif Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcTempId) then
        local tbPath = Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcTempId)
        tbStepCases[#tbStepCases].bMatch = true
        table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
      else
        local nX, nY = KNpc.ClientGetNpcPos(nMapId, nNpcTempId)
        local tbPath = Task.AutoTest:FindPathByPos(tbStepPath, nMapId, nX, nY)
        if tbPath then
          tbStepCases[#tbStepCases].bMatch = true
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        end
      end

      if not tbStepCases[#tbStepCases].bMatch then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId)
        print("KillNpc4NormalItem找不到匹配的寻路坐标")
        assert(false, "KillNpc4NormalItem找不到匹配的寻路坐标")
      end

      if Task.AutoTest["KillNpc4NormalItem"].bExtend == true then
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcTempId, bExtend = true } })
        Task.AutoTest["KillNpc4NormalItem"].bExtend = false
      else
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcTempId } })
      end
      table.insert(tbStepCases[#tbStepCases], { "KillNpcForItems", { nNpcId = nNpcTempId, szItemName = szItemName, tbItem = tbItem, nCount = nNeedCount } })

      if not bDelete then
        table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nNeedCount } })

        tbAddItems[#tbAddItems + 1] = {}
        tbAddItems[#tbAddItems].tbItem = tbItem
        tbAddItems[#tbAddItems].nItemNum = nNeedCount
      end
    elseif szTargetName == "KillNpc" then
      --- 杀怪
      local nNpcTempId = tbTarget.nNpcTempId
      local szNpcName = tbTarget.szNpcName
      local nMapId = tbTarget.nMapId
      local nNeedCount = tbTarget.nNeedCount

      tbStepCases[#tbStepCases + 1] = {}
      if not tbStepPath then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId, "KillNpc没有提供寻路坐标")
        assert(tbStepPath, "KillNpc没有提供寻路坐标")
      end

      -------------========= 一些特殊Case的匹配处理  ==========------------
      local nTaskId = tbStepParams.nTaskId
      local nSubTaskId = tbStepParams.nSubTaskId
      local nStepId = tbStepParams.nStepId

      if nTaskId == 1 and nSubTaskId == 7 and nStepId == 5 then
        --- 【四面楚歌】第5步只给了盐帮长老的寻路坐标，盐帮杀手应该在附近
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 2 and nSubTaskId == 16 and nStepId == 2 then
        --- 【影社之秘】第2步，白虎的寻路坐标匹配给“困兽之斗”
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 2 and nSubTaskId == 16 and nStepId == 3 then
        --- 【影社之秘】第3步，只给了宝箱的寻路坐标，带剑的异者应该就在附近
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 4 and nSubTaskId == 26 and nStepId == 1 then
        --- 【红旗旗主1A】第1步，匹配坐标“勿归谷”
        tbStepCases[#tbStepCases].bMatch = true
        Task.AutoTest["KillNpc"].bExtend = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 4 and nSubTaskId == 27 and nStepId == 2 then
        --- 【夷人的狩猎1B】第2步，匹配坐标“南夷武士”
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 4 and nSubTaskId == 32 and nStepId == 2 then
        --- 【离奇手书20】第2步，只给了一个寻路坐标，3个KillNpc均匹配这个
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 4 and nSubTaskId == 34 and nStepId == 2 then
        --- 【又见天王22】第2步直接匹配寻路坐标"入侵武士"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 4 and nSubTaskId == 35 and nStepId == 1 then
        --- 【苦战23】第1步直接匹配寻路坐标"入侵武士"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 4 and nSubTaskId == 37 and nStepId == 5 then
        --- 【生死决战25】第5步，只给了一个寻路坐标"胡献姬"，黄旗弟子就在她附近
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 5 and nSubTaskId == 39 and nStepId == 1 then
        --- 【红旗旗主27】第1步，匹配坐标“勿归谷”
        tbStepCases[#tbStepCases].bMatch = true
        Task.AutoTest["KillNpc"].bExtend = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 5 and nSubTaskId == 40 and nStepId == 2 then
        --- 【夷人的狩猎1B】第2步，匹配坐标“南夷武士”
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 5 and nSubTaskId == 45 and nStepId == 2 then
        --- 【离奇手书2D】第2步，只给了一个寻路坐标，3个KillNpc均匹配这个
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 5 and nSubTaskId == 47 and nStepId == 2 then
        --- 【又见天王2F】第2步直接匹配寻路坐标"入侵武士"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 5 and nSubTaskId == 48 and nStepId == 1 then
        --- 【苦战30】第1步直接匹配寻路坐标"入侵武士"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 5 and nSubTaskId == 50 and nStepId == 5 then
        --- 【生死决战32】第5步，只给了一个寻路坐标"胡献姬"，黄旗弟子就在她附近
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 6 and nSubTaskId == 54 and nStepId == 2 then
        --- 【大变突起】第2步，只给了一个寻路坐标"剑齿峡"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 7 and nSubTaskId == 59 and nStepId == 1 then
        --- 【柳暗花明】第1步，只给了一个寻路坐标"虎山石穴"
        tbStepCases[#tbStepCases].bMatch = true
        Task.AutoTest["KillNpc"].bExtend = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 8 and nSubTaskId == 69 and nStepId == 3 then
        --- 【家国大义】第3步，匹配寻路坐标"细作们"
        tbStepCases[#tbStepCases].bMatch = true
        Task.AutoTest["KillNpc"].bExtend = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 9 and nSubTaskId == 71 and nStepId == 2 then
        --- 【皇陵监牢】第2步，匹配寻路坐标"玄字牢内部"，应该是个Trap点
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 9 and nSubTaskId == 72 and nStepId == 2 then
        --- 【惊心之旅】第2步，匹配寻路坐标"天字牢犯人"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 9 and nSubTaskId == 74 and nStepId == 4 then
        --- 【终极营救】第4步，需要匹配4个坐标，去四个方位杀NPC
        tbStepCases[#tbStepCases].bMatch = true
        for i = 1, 4 do
          local tbPath = tbStepPath[i]
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
          table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcTempId } })
          table.insert(tbStepCases[#tbStepCases], { "KillNpc", { nNpcId = nNpcTempId, nCount = 1 } })
        end
        break
      elseif nTaskId == 10 and nSubTaskId == 77 and nStepId == 6 then
        --- 【惊心动魄4D】第6步，没有给寻路坐标，在当前室内找怪杀
        print(tbStepParams.szTaskName, tbStepParams.szSubTaskName, tbStepParams.nStepId, "没有给出寻路坐标")
        tbStepCases[#tbStepCases].bMatch = true
        Task.AutoTest["KillNpc"].bExtend = true
      elseif nTaskId == 11 and nSubTaskId == 83 and nStepId == 4 then
        --- 【意料之外】第4步，匹配寻路坐标"隐者峡"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 12 and nSubTaskId == 86 and nStepId == 1 then
        --- 【游龙出世】第1步，匹配寻路坐标"百花阵入口"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 12 and nSubTaskId == 93 and nStepId == 1 then
        --- 【佳人落难】第1步，匹配寻路坐标"望雪楼"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 12 and nSubTaskId == 93 and nStepId == 4 then
        --- 【佳人落难】第4步，没有给寻路坐标，NPC应该都在附近
        tbStepCases[#tbStepCases].bMatch = true
        Task.AutoTest["KillNpc"].bExtend = true
      elseif nTaskId == 19 and nSubTaskId == 131 and nStepId == 4 then
        --- 【分舵】第4步，匹配寻路坐标"五毒教弟子"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 21 and nSubTaskId == 146 and nStepId == 5 then
        --- 【校场较艺】第5步，匹配寻路坐标"吴德"，要杀的NPC"钢铁兵"应该在他附近
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 29 and nSubTaskId == 177 and nStepId == 3 then
        --- 【猴儿酒】第3步，匹配寻路坐标是Trap点"猴洞"，NPC野猴应该在猴洞里
        tbStepCases[#tbStepCases].bMatch = true
        Task.AutoTest["KillNpc"].bExtend = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 40 and nSubTaskId == 188 and nStepId == 6 then
        --- 【古营寨】第6步，匹配寻路坐标"南夷猎手"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 48 and nSubTaskId == 196 and nStepId == 2 then
        --- 【宋秋石的来历】第2步，匹配寻路坐标"雪山派弟子"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 65 and nSubTaskId == 213 and nStepId == 2 then
        --- 【虎洞迷踪】第2步，匹配寻路坐标"虎群"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 157 and nSubTaskId == 321 and nStepId == 2 then
        --- 【失踪之人】第2步，匹配寻路坐标"刺客"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
      elseif nTaskId == 157 and nSubTaskId == 322 and nStepId == 1 then
        --- 【终惩元凶】第1步，匹配寻路坐标"凶手"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
      elseif nTaskId == 189 and nSubTaskId == 352 and nStepId == 1 then
        --- 【惩治囚犯】第1步，匹配寻路坐标"玄字牢囚犯"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 232 and nSubTaskId == 407 and nStepId == 4 then
        --- 【新朝曙光】第4步，匹配寻路坐标"一伙强人"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 235 and nSubTaskId == 410 and nStepId == 8 then
        --- 【人心难测】第8步，匹配寻路坐标"神秘弓箭手"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 236 and nSubTaskId == 411 and nStepId == 7 then
        --- 【山雨欲来】第7步，匹配寻路坐标"野味"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 237 and nSubTaskId == 412 and nStepId == 6 then
        --- 【背水一战】第6步，匹配寻路坐标"夜探沈府"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 244 and nSubTaskId == 419 and nStepId == 1 then
        --- 【草原英雄】第1步，匹配寻路坐标"亲卫骑兵"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 245 and nSubTaskId == 420 and nStepId == 5 then
        --- 【金国使节】第5步，匹配寻路坐标"亲卫骑兵"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 246 and nSubTaskId == 421 and nStepId == 2 then
        --- 【故辽奇才】第2步，匹配寻路坐标"蜀冈秘境"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 252 and nSubTaskId == 427 and nStepId == 2 then
        --- 【野心勃勃】第2步，匹配寻路坐标"西夏军营"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      else
        if Task.AutoTest:FindPathByName(tbStepPath, szNpcName) then
          local tbPath = Task.AutoTest:FindPathByName(tbStepPath, szNpcName)
          tbStepCases[#tbStepCases].bMatch = true
          if tbPath.szType == "pos" then
            table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
          end
          if tbPath.szType == "npcpos" then
            table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
          end
        elseif Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcTempId) then
          local tbPath = Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcTempId)
          tbStepCases[#tbStepCases].bMatch = true
          table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
        else
          local nX, nY = KNpc.ClientGetNpcPos(nMapId, nNpcTempId)
          --	print(nMapId, nNpcTempId, nX, nY)
          local tbPath = Task.AutoTest:FindPathByPos(tbStepPath, nMapId, nX, nY)
          if tbPath then
            tbStepCases[#tbStepCases].bMatch = true
            table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
          end
        end
      end

      if not tbStepCases[#tbStepCases].bMatch then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId)
        print("KillNpc找不到匹配的寻路坐标")
        assert(false, "KillNpc找不到匹配的寻路坐标")
      end

      if Task.AutoTest["KillNpc"].bExtend == true then
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcTempId, bExtend = true } })
        Task.AutoTest["KillNpc"].bExtend = false
      else
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcTempId } })
      end
      table.insert(tbStepCases[#tbStepCases], { "KillNpc", { nNpcId = nNpcTempId, nCount = nNeedCount } })
    elseif szTargetName == "KillNpcCount" then
      --- 不限量杀怪（此任务目标现在取消了）
      local nNpcTempId = tbTarget.nNpcTempId
      local szNpcName = tbTarget.szNpcName
      local nMapId = tbTarget.nMapId
      local nNeedCount = tbTarget.nNeedCount

      tbStepCases[#tbStepCases + 1] = {}

      if Task.AutoTest:FindPathByName(tbStepPath, szNpcName) then
        local tbPath = Task.AutoTest:FindPathByName(tbStepPath, szNpcName)
        tbStepCases[#tbStepCases].bMatch = true
        if tbPath.szType == "pos" then
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        end
        if tbPath.szType == "npcpos" then
          table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
        end
      elseif Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcTempId) then
        local tbPath = Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcTempId)
        tbStepCases[#tbStepCases].bMatch = true
        table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
      else
        local nX, nY = KNpc.ClientGetNpcPos(nMapId, nNpcTempId)
        local tbPath = Task.AutoTest:FindPathByPos(tbStepPath, nMapId, nX, nY)
        if tbPath then
          tbStepCases[#tbStepCases].bMatch = true
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        end
      end

      if not tbStepCases[#tbStepCases].bMatch then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nSubTaskId, tbStepParams.nStepId)
        print("KillNpcCount找不到匹配的寻路坐标")
        assert(false, "KillNpcCount找不到匹配的寻路坐标")
      end

      table.insert(tbStepCases[#tbStepCases], { "KillNpc", { nNpcId = nNpcTempId, nCount = nNeedCount } })
    elseif szTargetName == "PlayerLevelUp" then
      --- 玩家达到指定等级
      local nLevel = tbTarget.nLevel
      tbStepCases[#tbStepCases + 1] = {}
      table.insert(tbStepCases[#tbStepCases], { "LevelUp", { nLevel = nLevel } })
    elseif szTargetName == "OpenBoxGetItem" then
      --- 开宝箱（此任务目标现在取消了）
      local nBoxId = tbTarget.nNpcTempId
      local szNpcName = tbTarget.szNpcName
      local nMapId = tbTarget.nMapId
      local tbItemList = tbTarget.ItemList
      local tbRealItemList = self:ParseItemList(tbItemList)
      if #tbRealItemList == 0 then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nStepId)
        print("宝箱物品为空")
        assert(false, "宝箱物品为空")
      end
      local nNeedSpaceCount = #tbRealItemList

      tbStepCases[#tbStepCases + 1] = {}
      table.insert(tbStepCases[#tbStepCases], { "BagHasSpace", { nEmptyNum = nNeedCount } })

      assert(tbStepPath, "OpenBoxGetItem没有提供寻路坐标")
      if Task.AutoTest:FindPathByName(tbStepPath, szNpcName) then
        local tbPath = Task.AutoTest:FindPathByName(tbStepPath, szNpcName)
        tbStepCases[#tbStepCases].bMatch = true
        if tbPath.szType == "pos" then
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        end
        if tbPath.szType == "npcpos" then
          table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
        end
      elseif Task.AutoTest:FindPathByNpcId(tbStepPath, nBoxId) then
        local tbPath = Task.AutoTest:FindPathByNpcId(tbStepPath, nBoxId)
        tbStepCases[#tbStepCases].bMatch = true
        table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
      else
        local nX, nY = KNpc.ClientGetNpcPos(nMapId, nBoxId)
        local tbPath = Task.AutoTest:FindPathByPos(tbStepPath, nMapId, nX, nY)
        if tbPath then
          tbStepCases[#tbStepCases].bMatch = true
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        end
      end

      if not tbStepCases[#tbStepCases].bMatch then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId)
        print("OpenBoxGetItem找不到匹配的寻路坐标")
        assert(false, "OpenBoxGetItem找不到匹配的寻路坐标")
      end

      table.insert(tbStepCases[#tbStepCases], { "InteractWithNpc", { nNpcId = nBoxId } })
      table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = "开启" } })

      for _, tbTempItem in pairs(tbRealItemList) do
        local tbItemId = tbTempItem.tbItem
        local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
        local nItemNum = tbTempItem.nItemNum
        table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nItemNum } })

        tbAddItems[#tbAddItems + 1] = {}
        tbAddItems[#tbAddItems].tbItem = tbItem
        tbAddItems[#tbAddItems].nItemNum = nItemNum
      end
    elseif szTargetName == "ProductWithProcess" then
      --- 进度条生产目标
      local nDuration = tbTarget.nDuration / 18
      local tbToke = tbTarget.tbToke
      local nRate = tbTarget.nRate
      local nToolParticular = tbTarget.nToolParticular
      local tbTool = { 20, 1, nToolParticular, 1 }
      local tbStuffs = tbTarget.tbStuffs
      local tbKeyProduct = { tbTarget.tbKeyProduct[1], tbTarget.tbKeyProduct[2], tbTarget.tbKeyProduct[3], tbTarget.tbKeyProduct[4] }
      local nKeyProductNeedCount = tbTarget.nKeyProductNeedCount
      local tbTotleProducts = tbTarget.tbTotleProducts
      local nTotleProductWeight = tbTarget.nTotleProductWeight
      local nArisingsLimitCount = tbTarget.nArisingsLimitCount
      local nNeedProductCount = tbTarget.nNeedProuductCount
      local nMapId = tbTarget.nMapId
      local nPosX = tbTarget.nPosX
      local nPosY = tbTarget.nPosY
      local nR = tbTarget.nRange
      local nModel = tbTarget.nModel
      local nArisingsCount = tbTarget.nArisingsCount

      if not tbStepPath then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId, "ProtectNpc没有提供寻路坐标")
        assert(tbStepPath, "ProtectNpc没有提供寻路坐标")
      end

      tbStepCases[#tbStepCases + 1] = {}

      local tbPath = Task.AutoTest:FindPathByPos(tbStepPath, nMapId, nPosX, nPosY, nR)
      if tbPath then
        tbStepCases[#tbStepCases].bMatch = true
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      end
      if not tbStepCases[#tbStepCases].bMatch then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId)
        print("ProtectNpc找不到匹配的寻路坐标")
        assert(false, "ProtectNpc找不到匹配的寻路坐标")
      end

      table.insert(tbStepCases[#tbStepCases], {
        "Product",
        {
          nDelay = nDuration,
          tbToke = tbToke,
          tbTool = tbTool,
          tbStuffs = tbStuffs,
          tbKeyProduct = tbKeyProduct,
          nKeyProductNeedCount = nKeyProductNeedCount,
          nNeedProductCount = nNeedProductCount,
          tbTotleProducts = tbTotleProducts,
          nModel = nModel,
        },
      })

      tbAddItems[#tbAddItems + 1] = {}
      tbAddItems[#tbAddItems].tbItem = { tbKeyProduct[1], tbKeyProduct[2], tbKeyProduct[3], tbKeyProduct[4] }
      tbAddItems[#tbAddItems].nItemNum = nKeyProductNeedCount
    elseif szTargetName == "ProtectNpc" then
      --- 护送NPC
      local nDialogNpcTempId = tbTarget.nDialogNpcTempId
      local szDialogNpcName = tbTarget.szDialogNpcName
      local nMapId = tbTarget.nMapId
      local nMapPosX = tbTarget.nMapPosX
      local nMapPosY = tbTarget.nMapPosY
      local nMoveNpcTempId = tbTarget.nMoveNpcTempId
      local nAimX = tbTarget.nAimX
      local nAimY = tbTarget.nAimY
      local nAimR = tbTarget.nAimR
      local szOption = tbTarget.szOption
      local szSubTaskName = tbStepParams.szSubTaskName

      if not tbStepPath then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId, "ProtectNpc没有提供寻路坐标")
        assert(tbStepPath, "ProtectNpc没有提供寻路坐标")
      end

      tbStepCases[#tbStepCases + 1] = {}

      -------------========= 一些特殊Case的匹配处理  ==========------------
      local nTaskId = tbStepParams.nTaskId
      local nSubTaskId = tbStepParams.nSubTaskId
      local nStepId = tbStepParams.nStepId

      if nTaskId == 234 and nSubTaskId == 409 and nStepId == 12 then
        ---【旬讲数日】第十二步，需要匹配寻路坐标"朱老先生"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nDialogNpcTempId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nDialogNpcTempId } })
      else
        if Task.AutoTest:FindPathByName(tbStepPath, szDialogNpcName) then
          local tbPath = Task.AutoTest:FindPathByName(tbStepPath, szDialogNpcName)
          tbStepCases[#tbStepCases].bMatch = true
          if tbPath.szType == "pos" then
            table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
            table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nDialogNpcTempId } })
            table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nDialogNpcTempId } })
          end
          if tbPath.szType == "npcpos" then
            table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
            table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nDialogNpcTempId } })
            table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nDialogNpcTempId } })
          end
        elseif Task.AutoTest:FindPathByNpcId(tbStepPath, nDialogNpcTempId) then
          local tbPath = Task.AutoTest:FindPathByNpcId(tbStepPath, nDialogNpcTempId)
          tbStepCases[#tbStepCases].bMatch = true
          table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
          table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nDialogNpcTempId } })
          table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nDialogNpcTempId } })
        else
          local tbPath = Task.AutoTest:FindPathByPos(tbStepPath, nMapId, nMapPosX, nMapPosY)
          if tbPath then
            tbStepCases[#tbStepCases].bMatch = true
            table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
            table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nDialogNpcTempId } })
            table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nDialogNpcTempId } })
          end
        end
      end

      if not tbStepCases[#tbStepCases].bMatch then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId)
        print("ProtectNpc找不到匹配的寻路坐标")
        assert(false, "ProtectNpc找不到匹配的寻路坐标")
      end

      table.insert(tbStepCases[#tbStepCases], { "InteractWithNpc", { nNpcId = nDialogNpcTempId } })
      if szOption == "<subtaskname>" then
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = szSubTaskName } })
      else
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = szOption } })
      end
      table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} })
      --			table.insert(tbStepCases[#tbStepCases], {"FindNpc", {nNpcId = nMoveNpcTempId}});
      table.insert(tbStepCases[#tbStepCases], { "EscortNpc", { nNpcId = nMoveNpcTempId, nX = nAimX, nY = nAimY, nR = nAimR } })
    elseif szTargetName == "RequireTaskValue" then
      --- 指定任务变量改变
      --- TODO：此任务目标会改变玩家的任务变量，目前暂不做任何的检测
      tbStepCases[#tbStepCases + 1] = {}

      -------------========= 一些特殊Case的匹配处理  ==========------------
      local nTaskId = tbStepParams.nTaskId
      local nSubTaskId = tbStepParams.nSubTaskId
      local nStepId = tbStepParams.nStepId

      if nTaskId == 157 and nSubTaskId == 310 and nStepId == 13 then
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "InteractWithNpc", { nNpcId = tbPath.nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = "门派路线指引" } })
        for i = 1, 5 do
          table.insert(tbStepCases[#tbStepCases], { "SaySelectOption", { nOptionNum = 1 } })
        end
        table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} })
      end
    elseif szTargetName == "SayNpc" then
      --- （过时的目标）与NPC对话（Say）
      local nNpcTempId = tbTarget.nNpcTempId
      local szNpcName = tbTarget.szNpcName
      local nMapId = tbTarget.nMapId
      local tbSayContent = tbTarget.tbSayContent
      local szOption = tbTarget.szOption
      local szSubTaskName = tbStepParams.szSubTaskName

      if not tbStepPath then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId, "SayNpc没有提供寻路坐标")
        assert(tbStepPath, "SayNpc没有提供寻路坐标")
      end

      tbStepCases[#tbStepCases + 1] = {}

      if Task.AutoTest:FindPathByName(tbStepPath, szNpcName) then
        local tbPath = Task.AutoTest:FindPathByName(tbStepPath, szNpcName)
        tbStepCases[#tbStepCases].bMatch = true
        if tbPath.szType == "pos" then
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
          table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcTempId } })
          table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcTempId } })
        end
        if tbPath.szType == "npcpos" then
          table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
          table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcTempId } })
          table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcTempId } })
        end
      elseif Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcTempId) then
        local tbPath = Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcTempId)
        tbStepCases[#tbStepCases].bMatch = true
        table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcTempId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcTempId } })
      else
        local nX, nY = KNpc.ClientGetNpcPos(nMapId, nNpcTempId)
        local tbPath = Task.AutoTest:FindPathByPos(tbStepPath, nMapId, nX, nY)
        if tbPath then
          tbStepCases[#tbStepCases].bMatch = true
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
          table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcTempId } })
          table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcTempId } })
        end
      end

      if not tbStepCases[#tbStepCases].bMatch then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId)
        print("SayNpc找不到匹配的寻路坐标")
        assert(false, "SayNpc找不到匹配的寻路坐标")
      end

      table.insert(tbStepCases[#tbStepCases], { "InteractWithNpc", { nNpcId = nNpcTempId } })
      if szOption == "<subtaskname>" then
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = szSubTaskName } })
      else
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = szOption } })
      end
      if #tbSayContent == 1 then
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = "结束对话" } })
      else
        for nIdx, szContent in pairs(tbSayContent) do
          if nIdx == #tbSayContent then
            table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = "结束对话" } })
          else
            table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = "下一页" } })
          end
        end
      end
    elseif szTargetName == "SayWithNpc" then
      --- 与NPC对话（Say）
      local nNpcTempId = tbTarget.nNpcTempId
      local szNpcName = tbTarget.szNpcName
      local nMapId = tbTarget.nMapId
      local tbSayContent = tbTarget.tbSayContent
      local szOption = tbTarget.szOption
      local szSubTaskName = tbStepParams.szSubTaskName

      if not tbStepPath then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId, "SayWithNpc没有提供寻路坐标")
        assert(tbStepPath, "SayWithNpc没有提供寻路坐标")
      end

      tbStepCases[#tbStepCases + 1] = {}

      if Task.AutoTest:FindPathByName(tbStepPath, szNpcName) then
        local tbPath = Task.AutoTest:FindPathByName(tbStepPath, szNpcName)
        tbStepCases[#tbStepCases].bMatch = true
        if tbPath.szType == "pos" then
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
          table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcTempId } })
          table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcTempId } })
        end
        if tbPath.szType == "npcpos" then
          table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
          table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcTempId } })
          table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcTempId } })
        end
      elseif Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcTempId) then
        local tbPath = Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcTempId)
        tbStepCases[#tbStepCases].bMatch = true
        table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcTempId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcTempId } })
      else
        local nX, nY = KNpc.ClientGetNpcPos(nMapId, nNpcTempId)
        local tbPath = Task.AutoTest:FindPathByPos(tbStepPath, nMapId, nX, nY)
        if tbPath then
          tbStepCases[#tbStepCases].bMatch = true
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
          table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcTempId } })
          table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcTempId } })
        end
      end

      if not tbStepCases[#tbStepCases].bMatch then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId)
        print("SayWithNpc找不到匹配的寻路坐标")
        assert(false, "SayWithNpc找不到匹配的寻路坐标")
      end

      table.insert(tbStepCases[#tbStepCases], { "InteractWithNpc", { nNpcId = nNpcTempId } })
      if szOption == "<subtaskname>" then
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = szSubTaskName } })
      else
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = szOption } })
      end
      if #tbSayContent == 1 then
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = "结束对话" } })
      else
        for nIdx, szContent in pairs(tbSayContent) do
          if nIdx == #tbSayContent then
            table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = "结束对话" } })
          else
            table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = "下一页" } })
          end
        end
      end
    elseif szTargetName == "SearchItemBySuffix" then
      --- 找物品带后缀（如“束发.湟光”）
      local szItemName = tbTarget.szItemName
      local szSuffix = tbTarget.szSuffix
      local nNeedCount = tbTarget.nNeedCount
      local bDelete = tbTarget.bDelete

      tbStepCases[#tbStepCases + 1] = {}
      table.insert(tbStepCases[#tbStepCases], { "SearchItemBySuffix", { szItemName = szItemName, szSuffix = szSuffix, nNeedCount = nNeedCount } })
    elseif szTargetName == "SearchItem" then
      --- 找物品
      local tbItemId = tbTarget.tbItemId
      local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
      local szItemName = tbTarget.szItemName
      local nNeedCount = tbTarget.nNeedCount
      local bDelete = tbTarget.bDelete

      tbStepCases[#tbStepCases + 1] = {}
      -------------========= 一些特殊Case的匹配处理  ==========------------
      local nTaskId = tbStepParams.nTaskId
      local nSubTaskId = tbStepParams.nSubTaskId
      local nStepId = tbStepParams.nStepId

      if nTaskId == 157 and nSubTaskId == 312 and nStepId == 2 then
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "SetFightState", { nState = 0 } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "InteractWithNpc", { nNpcId = tbPath.nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = "矿石" } })
        table.insert(tbStepCases[#tbStepCases], { "SaveSingleStat", { szState = "money", nValue = -1 * nNeedCount } })
        table.insert(tbStepCases[#tbStepCases], { "BuyItem", { szItemName = "劣质铜矿石", nCount = nNeedCount } })
        table.insert(tbStepCases[#tbStepCases], { "LifeProduce", { nRecipeId = 1286, nProduceTime = 2, tbItem = tbItem, szItemName = szItemName, nNeedCount = nNeedCount } })

        if not bDelete then
          table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nNeedCount } })
        end
        table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} })
      elseif nTaskId == 157 and nSubTaskId == 312 and nStepId == 3 then
        table.insert(tbStepCases[#tbStepCases], { "LifeProduce", { nRecipeId = 1291, nProduceTime = 3, tbItem = tbItem, szItemName = szItemName, nNeedCount = nNeedCount } })

        if not bDelete then
          table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nNeedCount } })
        end
        table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} })
      elseif nTaskId == 157 and nSubTaskId == 312 and nStepId == 5 then
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "SetFightState", { nState = 0 } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "InteractWithNpc", { nNpcId = tbPath.nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = "毛皮" } })
        table.insert(tbStepCases[#tbStepCases], { "SaveSingleStat", { szState = "money", nValue = -1 * nNeedCount } })
        table.insert(tbStepCases[#tbStepCases], { "BuyItem", { szItemName = "破损的羊毛皮", nCount = nNeedCount } })
        table.insert(tbStepCases[#tbStepCases], { "LifeProduce", { nRecipeId = 1290, nProduceTime = 2, tbItem = tbItem, szItemName = szItemName, nNeedCount = nNeedCount } })

        if not bDelete then
          table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nNeedCount } })
        end
        table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} })
      elseif nTaskId == 157 and nSubTaskId == 312 and nStepId == 6 then
        table.insert(tbStepCases[#tbStepCases], { "LifeProduce", { nRecipeId = 1292, nProduceTime = 3, tbItem = tbItem, szItemName = szItemName, nNeedCount = nNeedCount } })

        if not bDelete then
          table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nNeedCount } })
        end
        table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} })
      elseif nTaskId == 157 and nSubTaskId == 312 and nStepId == 8 then
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "SetFightState", { nState = 0 } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "InteractWithNpc", { nNpcId = tbPath.nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = "原木" } })
        table.insert(tbStepCases[#tbStepCases], { "SaveSingleStat", { szState = "money", nValue = -1 * nNeedCount } })
        table.insert(tbStepCases[#tbStepCases], { "BuyItem", { szItemName = "劣质松木", nCount = nNeedCount } })
        table.insert(tbStepCases[#tbStepCases], { "LifeProduce", { nRecipeId = 1289, nProduceTime = 2, tbItem = tbItem, szItemName = szItemName, nNeedCount = nNeedCount } })

        if not bDelete then
          table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nNeedCount } })
        end
        table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} })
      elseif nTaskId == 157 and nSubTaskId == 312 and nStepId == 9 then
        table.insert(tbStepCases[#tbStepCases], { "LifeProduce", { nRecipeId = 1294, nProduceTime = 3, tbItem = tbItem, szItemName = szItemName, nNeedCount = nNeedCount } })

        if not bDelete then
          table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nNeedCount } })
        end
        table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} })
      elseif nTaskId == 157 and nSubTaskId == 312 and nStepId == 11 then
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "SetFightState", { nState = 0 } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "InteractWithNpc", { nNpcId = tbPath.nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = "药材" } })
        table.insert(tbStepCases[#tbStepCases], { "SaveSingleStat", { szState = "money", nValue = -1 * nNeedCount } })
        table.insert(tbStepCases[#tbStepCases], { "BuyItem", { szItemName = "小藏红花", nCount = nNeedCount } })
        table.insert(tbStepCases[#tbStepCases], { "LifeProduce", { nRecipeId = 1288, nProduceTime = 2, tbItem = tbItem, szItemName = szItemName, nNeedCount = nNeedCount } })

        if not bDelete then
          table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nNeedCount } })
        end
        table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} })
      elseif nTaskId == 157 and nSubTaskId == 312 and nStepId == 12 then
        table.insert(tbStepCases[#tbStepCases], { "LifeProduce", { nRecipeId = 1293, nProduceTime = 3, tbItem = tbItem, szItemName = szItemName, nNeedCount = nNeedCount } })

        if not bDelete then
          table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nNeedCount } })
        end
        table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} })
      elseif nTaskId == 157 and nSubTaskId == 312 and nStepId == 14 then
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "SetFightState", { nState = 0 } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "InteractWithNpc", { nNpcId = tbPath.nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = "棉麻" } })
        table.insert(tbStepCases[#tbStepCases], { "SaveSingleStat", { szState = "money", nValue = -1 * nNeedCount } })
        table.insert(tbStepCases[#tbStepCases], { "BuyItem", { szItemName = "劣质亚麻", nCount = nNeedCount } })
        table.insert(tbStepCases[#tbStepCases], { "LifeProduce", { nRecipeId = 1287, nProduceTime = 2, tbItem = tbItem, szItemName = szItemName, nNeedCount = nNeedCount } })

        if not bDelete then
          table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nNeedCount } })
        end
        table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} })
      elseif nTaskId == 157 and nSubTaskId == 312 and nStepId == 15 then
        table.insert(tbStepCases[#tbStepCases], { "LifeProduce", { nRecipeId = 1295, nProduceTime = 3, tbItem = tbItem, szItemName = szItemName, nNeedCount = nNeedCount } })

        if not bDelete then
          table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nNeedCount } })
        end
        table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} })
      elseif nTaskId == 215 and nSubTaskId == 390 and nStepId == 2 then
        tbAddItems[#tbAddItems + 1] = {}
        tbAddItems[#tbAddItems].tbItem = tbItem
        tbAddItems[#tbAddItems].nItemNum = 1
      else
        table.insert(tbStepCases[#tbStepCases], { "SearchItem", { tbItem = tbItem, nNeedCount = nNeedCount } })
      end
    elseif szTargetName == "SearchItemEx" then
      --- 找物品Ex
      local tbItemId = tbTarget.tbItemId
      local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
      local nNeedCount = tbTarget.nNeedCount
      local bDelete = tbTarget.bDelete

      tbStepCases[#tbStepCases + 1] = {}
      table.insert(tbStepCases[#tbStepCases], { "SearchItem", { tbItem = tbItem, nNeedCount = nNeedCount } })

    --- 暂不检测是否删除物品
    --	if (bDelete) then
    --		nNeedCount = nNeedCount*(-1);
    --		table.insert(tbStepCases, {"CheckItemDelta", {tbItem = tbItem, nValue = nNeedCount}});
    --	end
    elseif szTargetName == "SearchItemWithDesc" then
      --- 带描述的找物品
      local tbItemId = tbTarget.tbItemId
      local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
      local szItemName = tbTarget.szItemName
      local nNeedCount = tbTarget.nNeedCount
      local bDelete = tbTarget.bDelete

      tbStepCases[#tbStepCases + 1] = {}

      -------------========= 一些特殊Case的匹配处理  ==========------------
      local nTaskId = tbStepParams.nTaskId
      local nSubTaskId = tbStepParams.nSubTaskId
      local nStepId = tbStepParams.nStepId

      if nTaskId == 157 and nSubTaskId == 308 and nStepId == 1 then
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "SetFightState", { nState = 0 } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "InteractWithNpc", { nNpcId = tbPath.nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = "食物" } })
        table.insert(tbStepCases[#tbStepCases], { "SaveSingleStat", { szState = "money", nValue = -1 * nNeedCount } })
        table.insert(tbStepCases[#tbStepCases], { "BuyItem", { szItemName = szItemName, nCount = nNeedCount } })

        if not bDelete then
          table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nNeedCount } })
        end
      else
        table.insert(tbStepCases[#tbStepCases], { "SearchItem", { tbItem = tbItem, nNeedCount = nNeedCount } })
      end
    elseif szTargetName == "SearchMapChronicle" then
      --- 收集地图志(目前暂时取消)
      local nMapId = tbTarget.nMapId
      local nNeedCount = tbTarget.nNeedCount

      tbStepCases[#tbStepCases + 1] = {}
      table.insert(tbStepCases[#tbStepCases], { "SearchMapChronicle", { nMapId = nMapId, nNeedCount = nNeedCount } })
    elseif szTargetName == "Send2NewWorld" then
      --- 可多次传送（现在已经取消）
      local nMapId = tbTarget.nMapId
      local nPosX = tbTarget.nPosX
      local nPosY = tbTarget.nPosY
      local nTotalTimes = tbTarget.nTotalTimes
    elseif szTargetName == "Send2Aim" then
      --- 可选择传送
      local nNpcTempId = tbTarget.nNpcTempId
      local szNpcName = tbTarget.szNpcName
      local nNpcMapId = tbTarget.nNpcMapId
      local nAimMapId = tbTarget.nAimMapId
      local szAimMapName = Task:GetMapName(nAimMapId)
      local nAimPosX = tbTarget.nAimPosX
      local nAimPosY = tbTarget.nAimPosY
      local szYesOpt = Lib:StrTrim(tbTarget.szYesOpt, "\n")
      local szCancelOpt = Lib:StrTrim(tbTarget.szCancelOpt, "\n")
      local nFightState = tbTarget.nFightState
      local szOption = tbTarget.szOption
      local szSubTaskName = tbStepParams.szSubTaskName

      if not tbStepPath then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId, "Send2Aim没有提供寻路坐标")
        assert(tbStepPath, "Send2Aim没有提供寻路坐标")
      end

      tbStepCases[#tbStepCases + 1] = {}

      -------------========= 一些特殊Case的匹配处理  ==========------------
      local nTaskId = tbStepParams.nTaskId
      local nSubTaskId = tbStepParams.nSubTaskId
      local nStepId = tbStepParams.nStepId

      if nTaskId == 15 and nSubTaskId == 108 and nStepId == 8 then
        --- 【吴氏】第8步，没有给寻路坐标，NPC韩侂胄应该在附近
        tbStepCases[#tbStepCases].bMatch = true
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcTempId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcTempId } })
      elseif nTaskId == 19 and nSubTaskId == 135 and nStepId == 2 then
        --- 【千里追踪】第2步，目标是Send2Aim，给的是目的地"鸡冠洞"的坐标，如果不能能直接走过去，就算bug
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        break
      elseif nTaskId == 20 and nSubTaskId == 136 and nStepId == 1 then
        --- 【线索】第1步，目标是Send2Aim，给的是目的地"沙漠迷宫"的坐标，如果能直接走不过去，就算bug
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        break
      else
        if Task.AutoTest:FindPathByName(tbStepPath, szNpcName) then
          local tbPath = Task.AutoTest:FindPathByName(tbStepPath, szNpcName)
          tbStepCases[#tbStepCases].bMatch = true
          if tbPath.szType == "pos" then
            table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
            table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcTempId } })
            table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcTempId } })
          end
          if tbPath.szType == "npcpos" then
            table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
          end
        elseif Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcTempId) then
          local tbPath = Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcTempId)
          tbStepCases[#tbStepCases].bMatch = true
          table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
          table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcTempId } })
          table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcTempId } })
        else
          local nX, nY = KNpc.ClientGetNpcPos(nNpcMapId, nNpcTempId)
          local tbPath = Task.AutoTest:FindPathByPos(tbStepPath, nNpcMapId, nX, nY)
          if tbPath then
            tbStepCases[#tbStepCases].bMatch = true
            table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
            table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcTempId } })
            table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcTempId } })
          end
        end
      end

      if not tbStepCases[#tbStepCases].bMatch then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId)
        print("Send2Aim找不到匹配的寻路坐标")
        assert(false, "Send2Aim找不到匹配的寻路坐标")
      end

      table.insert(tbStepCases[#tbStepCases], { "InteractWithNpc", { nNpcId = nNpcTempId } })
      if szOption == "<subtaskname>" then
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = szSubTaskName } })
      else
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = szOption } })
      end
      table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = szYesOpt } })
      --- TODO: 是否需要检查此时玩家传送地点正确，和战斗状态的正确性
      --- table.insert(tbStepCases, {"SaveStat", {}});
    elseif szTargetName == "WithProcessStatic" then
      --- 静态进度条目标(开箱子，只看成功的次数)
      local nNpcTempId = tbTarget.nNpcTempId
      local szNpcName = tbTarget.szNpcName
      local nMapId = tbTarget.nMapId
      local szMapName = tbTarget.szMapName
      local nIntervalTime = tbTarget.nIntervalTime / 18 --- 单位由帧换为秒
      local tbItemList = tbTarget.ItemList
      local tbRealItemList = self:ParseItemList(tbItemList)
      local nNeedSpaceCount = #tbRealItemList
      local nNeedCount = tbTarget.nNeedCount

      tbStepCases[#tbStepCases + 1] = {}

      if nNeedSpaceCount > 0 then
        table.insert(tbStepCases[#tbStepCases], { "BagHasSpace", { nEmptyNum = nNeedSpaceCount } })
      end

      -------------========= 一些特殊Case的匹配处理  ==========------------
      local nTaskId = tbStepParams.nTaskId
      local nSubTaskId = tbStepParams.nSubTaskId
      local nStepId = tbStepParams.nStepId

      if nTaskId == 216 and nSubTaskId == 391 and nStepId == 1 then
        --- 白虎堂任务，不需要寻路坐标
        tbStepCases[#tbStepCases].bMatch = true

        if nNeedSpaceCount > 0 then
          for _, tbTempItem in pairs(tbRealItemList) do
            local tbItemId = tbTempItem.tbItem
            local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
            local nItemNum = tbTempItem.nItemNum
            local nCount = nItemNum * nNeedCount
            table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nCount } })

            tbAddItems[#tbAddItems + 1] = {}
            tbAddItems[#tbAddItems].tbItem = tbItem
            tbAddItems[#tbAddItems].nItemNum = nCount
          end
        end
        break
      elseif nTaskId == 217 and nSubTaskId == 392 and nStepId == 1 then
        --- 宋金任务，不需要寻路坐标
        tbStepCases[#tbStepCases].bMatch = true

        if nNeedSpaceCount > 0 then
          for _, tbTempItem in pairs(tbRealItemList) do
            local tbItemId = tbTempItem.tbItem
            local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
            local nItemNum = tbTempItem.nItemNum
            local nCount = nItemNum * nNeedCount
            table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nCount } })

            tbAddItems[#tbAddItems + 1] = {}
            tbAddItems[#tbAddItems].tbItem = tbItem
            tbAddItems[#tbAddItems].nItemNum = nCount
          end
        end
        break
      else
        if not tbStepPath then
          print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId, "WithProcessStatic没有提供寻路坐标")
          assert(tbStepPath, "WithProcessStatic没有提供寻路坐标")
        end
      end

      if nTaskId == 8 and nSubTaskId == 64 and nStepId == 4 then
        --- 【哀鸿遍野】第4步，匹配寻路坐标"橡树岭"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 17 and nSubTaskId == 117 and nStepId == 1 then
        --- 【藏宝游戏】第1步，需要分别匹配
        tbStepCases[#tbStepCases].bMatch = true
        Task.AutoTest["WithProcessStatic"].nCount = Task.AutoTest["WithProcessStatic"].nCount + 1
        if Task.AutoTest["WithProcessStatic"].nCount == 1 then
          --- 匹配"暖玉佛"
          local tbPath = tbStepPath[1]
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        elseif Task.AutoTest["WithProcessStatic"].nCount == 2 then
          --- 匹配"琉璃珠"
          local tbPath = tbStepPath[4]
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        elseif Task.AutoTest["WithProcessStatic"].nCount == 3 then
          --- 匹配"五彩香囊"
          local tbPath = tbStepPath[3]
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
          Task.AutoTest["WithProcessStatic"].nCount = 0
        end
      elseif nTaskId == 18 and nSubTaskId == 125 and nStepId == 3 then
        --- 【悬疑】第3步，需要分别匹配
        tbStepCases[#tbStepCases].bMatch = true
        Task.AutoTest["WithProcessStatic"].nCount = Task.AutoTest["WithProcessStatic"].nCount + 1
        if Task.AutoTest["WithProcessStatic"].nCount == 1 then
          --- 匹配"唐门弟子的尸体"
          local tbPath = tbStepPath[1]
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        elseif Task.AutoTest["WithProcessStatic"].nCount == 2 then
          --- 匹配"宝箱"
          local tbPath = tbStepPath[2]
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
          Task.AutoTest["WithProcessStatic"].nCount = 0
        end
      elseif nTaskId == 32 and nSubTaskId == 180 and nStepId == 2 then
        --- 【哑老头】第2步，匹配寻路坐标"废铁片"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 124 and nSubTaskId == 273 and nStepId == 1 then
        --- 【寻回圣物】第1步，匹配寻路坐标"苦神雕像"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 136 and nSubTaskId == 285 and nStepId == 4 then
        --- 【轮回】第4步，匹配寻路坐标"塔林"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 170 and nSubTaskId == 333 and nStepId == 1 then
        --- 【天王枪制作】第1步，匹配寻路坐标"锻造所需的铁片"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 171 and nSubTaskId == 334 and nStepId == 1 then
        --- 【橡实】第1步，匹配寻路坐标"橡树岭"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      elseif nTaskId == 259 and nSubTaskId == 434 and nStepId == 1 then
        --- 【编练使】第1步，匹配寻路坐标"枫叶林"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      else
        if Task.AutoTest:FindPathByName(tbStepPath, szNpcName) then
          local tbPath = Task.AutoTest:FindPathByName(tbStepPath, szNpcName)
          tbStepCases[#tbStepCases].bMatch = true
          if tbPath.szType == "pos" then
            table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
          end
          if tbPath.szType == "npcpos" then
            table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
          end
        elseif Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcTempId) then
          local tbPath = Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcTempId)
          tbStepCases[#tbStepCases].bMatch = true
          table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
        else
          local nX, nY = KNpc.ClientGetNpcPos(nMapId, nNpcTempId)
          local tbPath = Task.AutoTest:FindPathByPos(tbStepPath, nMapId, nX, nY)
          if tbPath then
            tbStepCases[#tbStepCases].bMatch = true
            table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
          end
        end
      end

      if not tbStepCases[#tbStepCases].bMatch then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId)
        print("WithProcessStatic找不到匹配的寻路坐标")
        assert(false, "WithProcessStatic找不到匹配的寻路坐标")
      end

      table.insert(tbStepCases[#tbStepCases], { "SetFightState", { nState = 0 } })
      table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcTempId } })
      table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcTempId } })
      for i = 1, nNeedCount do
        table.insert(tbStepCases[#tbStepCases], { "UseItemOnTheGround", { nNpcId = nNpcTempId, nDelay = nIntervalTime } })
      end

      if nNeedSpaceCount > 0 then
        for _, tbTempItem in pairs(tbRealItemList) do
          local tbItemId = tbTempItem.tbItem
          local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
          local nItemNum = tbTempItem.nItemNum
          local nCount = nItemNum * nNeedCount
          table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nCount } })
          table.insert(tbStepCases[#tbStepCases], { "SaveSingleStat", { szState = "item" } })

          tbAddItems[#tbAddItems + 1] = {}
          tbAddItems[#tbAddItems].tbItem = tbItem
          tbAddItems[#tbAddItems].nItemNum = nCount
        end
      end
      table.insert(tbStepCases[#tbStepCases], { "SetFightState", { nState = 1 } })
    elseif szTargetName == "StepEvent" then
      --- 步骤开始信息（信息以广播的形式出现在屏幕中间）
      --- TODO：不做操作，直接过掉
      --- table.insert(tbStepCases, {"SaveStat", {}});
    elseif szTargetName == "TalkNpc" then
      --- 与NPC对话
      local nNpcId = tbTarget.nNpcTempId
      local szNpcName = tbTarget.szNpcName
      local nMapId = tbTarget.nMapId
      local szOption = tbTarget.szOption
      local szSubTaskName = tbStepParams.szSubTaskName

      tbStepCases[#tbStepCases + 1] = {}
      if not tbStepPath then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId)
        assert(tbStepPath, "TalkNpc没有提供寻路坐标")
      end

      if Task.AutoTest:FindPathByName(tbStepPath, szNpcName) then
        local tbPath = Task.AutoTest:FindPathByName(tbStepPath, szNpcName)
        tbStepCases[#tbStepCases].bMatch = true
        if tbPath.szType == "pos" then
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
          table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
          table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
        end
        if tbPath.szType == "npcpos" then
          table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
          table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
          table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
        end
      elseif Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcId) then
        local tbPath = Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcId)
        tbStepCases[#tbStepCases].bMatch = true
        table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      else
        local nX, nY = KNpc.ClientGetNpcPos(nMapId, nNpcId)
        local tbPath = Task.AutoTest:FindPathByPos(tbStepPath, nMapId, nX, nY)
        if tbPath then
          tbStepCases[#tbStepCases].bMatch = true
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
          table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
          table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
        end
      end

      if not tbStepCases[#tbStepCases].bMatch then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nSubTaskId, tbStepParams.nStepId)
        print("TalkNpc找不到匹配的寻路坐标")
        assert(false, "TalkNpc找不到匹配的寻路坐标")
      end

      table.insert(tbStepCases[#tbStepCases], { "InteractWithNpc", { nNpcId = nNpcId } })
      if szOption == "<subtaskname>" then
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = szSubTaskName } })
      else
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = szOption } })
      end
      table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} })

      local nStepId = tbStepParams.nStepId
      local nStepCount = tbStepParams.nStepCount
      if nStepId == nStepCount then
        --- 如果是最后一个步骤，需要领取奖励
        local nBagSpaceCount = tbStepParams.nBagSpaceCount
        local tbAwards = tbStepParams.tbAwards

        table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} }) --领奖可能会产生黑屏，要过掉
        if nBagSpaceCount > 0 then
          table.insert(tbStepCases[#tbStepCases], { "BagHasSpace", { nEmptyNum = nBagSpaceCount } })
        end

        if #tbAwards.tbFix ~= 0 then
          --- 领取固定奖励
          table.insert(tbStepCases[#tbStepCases], { "AcceptReward", { bAccept = 1, nSelectedAward = 0, nNpcId = nNpcId, szTaskName = szSubTaskName } })
          local tbAwards = tbAwards.tbFix
          for _, tbAward in pairs(tbAwards) do
            if self:ParseConditionTable(tbAward.tbConditions) then
              if tbAward.szType == "exp" then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "exp", nValue = tbAward.varValue } })
              elseif tbAward.szType == "money" then
                if tbStepParams.nLevel < 30 then
                  table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
                else
                  table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "money", nValue = tbAward.varValue } })
                end
              elseif tbAward.szType == "bindmoney" then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
              elseif tbAward.szType == "makepoint" then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "makepoint", nValue = tbAward.varValue } })
              elseif tbAward.szType == "gatherpoint" then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "gatherpoint", nValue = tbAward.varValue } })
              elseif tbAward.szType == "item" then
                local tbItemId = tbAward.varValue
                local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
                local nItemNum = tbAward.szAddParam1
                assert(nItemNum >= 0, "奖励物品个数填错了")
                if nItemNum == 0 then
                  nItemNum = 1
                end
                table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nItemNum } })
              elseif tbAward.szType == "customizeitem" then
                local tbItemId = tbAward.varValue
                local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
                table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = 1 } })
              elseif tbAward.szType == "title" then
                local tbTitle = tbAward.varValue
              elseif tbAward.szType == "repute" then
                local tbRepute = tbAward.varValue
              elseif tbAward.szType == "taskvalue" then
                local tbTaskValue = tbAward.varValue
              elseif tbAward.szType == "script" then
                local szFnScript = tbAward.varValue
              elseif tbAward.szType == "arrary" then
              elseif tbAward.szType == "KinReputeEntry" then
              else
                for key, value in pairs(tbAward) do
                  print(key, value)
                  if type(value) == "table" then
                    for i, v in pairs(value) do
                      print(i, v)
                    end
                  end
                end
                print(tbStepParams.szSubTaskName)
                assert(false, "Exception Award!")
              end
            end
          end
        elseif #tbAwards.tbOpt ~= 0 then
          --- 领取可选奖励
          local tbAwards = tbAwards.tbOpt
          local nSelectedAward = MathRandom(#tbAwards)

          table.insert(tbStepCases[#tbStepCases], { "AcceptReward", { bAccept = 1, nSelectedAward = nSelectedAward, nNpcId = nNpcId, szTaskName = szSubTaskName } })

          local tbAward = tbAwards[nSelectedAward]
          if self:ParseConditionTable(tbAward.tbConditions) then
            if tbAward.szType == "exp" then
              table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "exp", nValue = tbAward.varValue } })
            elseif tbAward.szType == "money" then
              if tbStepParams.nLevel < 30 then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
              else
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "money", nValue = tbAward.varValue } })
              end
            elseif tbAward.szType == "bindmoney" then
              table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
            elseif tbAward.szType == "makepoint" then
              table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "makepoint", nValue = tbAward.varValue } })
            elseif tbAward.szType == "gatherpoint" then
              table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "gatherpoint", nValue = tbAward.varValue } })
            elseif tbAward.szType == "item" then
              local tbItemId = tbAward.varValue
              local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
              local nItemNum = tbAward.szAddParam1
              assert(nItemNum >= 0, "奖励物品个数填错了")
              if nItemNum == 0 then
                nItemNum = 1
              end
              table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nItemNum } })
            elseif tbAward.szType == "customizeitem" then
              local tbItemId = tbAward.varValue
              local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
              table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = 1 } })
            elseif tbAward.szType == "title" then
              local tbTitle = tbAward.varValue
            elseif tbAward.szType == "repute" then
              local tbRepute = tbAward.varValue
            elseif tbAward.szType == "taskvalue" then
              local tbTaskValue = tbAward.varValue
            elseif tbAward.szType == "script" then
              local szFnScript = tbAward.varValue
            elseif tbAward.szType == "arrary" then
            elseif tbAward.szType == "KinReputeEntry" then
            else
              for key, value in pairs(tbAward) do
                print(key, value)
                if type(value) == "table" then
                  for i, v in pairs(value) do
                    print(i, v)
                  end
                end
              end
              print(tbStepParams.szSubTaskName)
              assert(false, "Exception Award!")
            end
          else
            assert(false, "领取随机奖励失败")
          end
        elseif #tbAwards.tbRand ~= 0 then
          --- 领取随机奖励
          --- TODO: 目前暂时没有随机奖励的设定，暂不做考虑
        else
          print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId)
          print("没有填写任务奖励!")
          --	assert(false,"没有填写任务奖励!");
        end

        --- 领取奖励完后会有黑屏，先要过掉黑屏
        table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} })

        --- 领取奖励后，如果是询问接受任务，且此时子任务不是最后一个子任务，则接受，否则不接受
        local tbExecute = tbStepParams.tbExecute
        if #tbExecute ~= 0 then
          local nReferIdx = tbStepParams.nReferIdx
          local nSubNum = tbStepParams.nSubNum
          if nReferIdx ~= nSubNum then
            table.insert(tbStepCases[#tbStepCases], { "AcceptTask", { bAccept = 1 } })
          else
            table.insert(tbStepCases[#tbStepCases], { "AcceptTask", { bAccept = 0 } })
          end
        end
      end
    elseif szTargetName == "TalkWithNpc" then
      --- 带描述的与NPC对话
      local nNpcId = tbTarget.nNpcTempId
      local szNpcName = tbTarget.szNpcName
      local nMapId = tbTarget.nMapId
      local szOption = tbTarget.szOption
      local szSubTaskName = tbStepParams.szSubTaskName

      if not tbStepPath then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId, "TalkWithNpc没有提供寻路坐标")
        assert(tbStepPath, "TalkWithNpc没有提供寻路坐标")
      end

      tbStepCases[#tbStepCases + 1] = {}

      -------------========= 一些特殊Case的匹配处理  ==========------------
      local nTaskId = tbStepParams.nTaskId
      local nSubTaskId = tbStepParams.nSubTaskId
      local nStepId = tbStepParams.nStepId

      if nTaskId == 1 and nSubTaskId == 1 and nStepId == 3 then
        --- 【瑛姑归来】第3步直接通过寻路坐标找Npc
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 1 and nSubTaskId == 1 and nStepId == 6 then
        --- 【瑛姑归来】第6步直接通过寻路坐标找Npc
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 2 and nSubTaskId == 12 and nStepId == 1 then
        --- 【高下立判】第一步只寻到Trap点
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 4 and nSubTaskId == 28 and nStepId == 2 then
        --- 【深陷蛇窝1C】第2步只寻到trap点"松涛别院"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 4 and nSubTaskId == 28 and nStepId == 7 then
        --- 【深陷蛇窝1C】第7步只寻到trap点"松涛别院"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 4 and nSubTaskId == 31 and nStepId == 1 then
        --- 【绝壁奇花1F】第1步只寻到trap点"松涛别院"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 4 and nSubTaskId == 31 and nStepId == 3 then
        --- 【绝壁奇花1F】第3步只寻到trap点"松涛别院"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 4 and nSubTaskId == 38 and nStepId == 4 then
        --- 【何去何从26】第4步，没有给白秋林的寻路坐标，暂时飞到龙泉村交任务
        print(tbStepParams.szTaskName, tbStepParams.szSubTaskName, tbStepParams.nStepId, "没有给寻路坐标")
        tbStepCases[#tbStepCases].bMatch = true
        table.insert(tbStepCases[#tbStepCases], { "NewWorld", { nMapId = 7, nX = 1528, nY = 3271 } })
        table.insert(tbStepCases[#tbStepCases], { "SetFightState", { nState = 0 } }) --- NewWorld到城里需要切换为非战斗状态
      elseif nTaskId == 5 and nSubTaskId == 41 and nStepId == 2 then
        --- 【深陷蛇窝29】第2步只寻到trap点"松涛别院"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 5 and nSubTaskId == 41 and nStepId == 7 then
        --- 【深陷蛇窝29】第7步只寻到trap点"松涛别院"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 5 and nSubTaskId == 44 and nStepId == 1 then
        --- 【绝壁奇花2C】第1步只寻到trap点"松涛别院"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 5 and nSubTaskId == 44 and nStepId == 3 then
        --- 【绝壁奇花2C】第3步只寻到trap点"松涛别院"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 5 and nSubTaskId == 51 and nStepId == 4 then
        --- 【何去何从33】第4步，没有给白秋林的寻路坐标，暂时飞到龙泉村交任务
        print(tbStepParams.szTaskName, tbStepParams.szSubTaskName, tbStepParams.nStepId, "没有给寻路坐标")
        tbStepCases[#tbStepCases].bMatch = true
        table.insert(tbStepCases[#tbStepCases], { "NewWorld", { nMapId = 7, nX = 1528, nY = 3271 } })
        table.insert(tbStepCases[#tbStepCases], { "SetFightState", { nState = 0 } }) --- NewWorld到城里需要切换为非战斗状态
      elseif nTaskId == 6 and nSubTaskId == 52 and nStepId == 6 then
        --- 【合宗大典】第6步给的是一个Trap点，要进入室内和NPC对话
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 6 and nSubTaskId == 53 and nStepId == 5 then
        --- 【西北马贼】第5步给的是一个Trap点，要进入室内和NPC对话
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 7 and nSubTaskId == 58 and nStepId == 2 then
        --- 【死局】第2步，匹配寻路坐标"解剑池"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 7 and nSubTaskId == 61 and nStepId == 3 then
        --- 【神僧空无】第3步，给的是一个Trap点，要进入室内和NPC对话
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 7 and nSubTaskId == 63 and nStepId == 3 then
        --- 【匪夷所思】第3步，匹配寻路坐标"重阳道长"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 7 and nSubTaskId == 63 and nStepId == 4 then
        --- 【匪夷所思】第4步，给的是一个Trap点，要进入室内和NPC对话
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 7 and nSubTaskId == 63 and nStepId == 6 then
        --- 【匪夷所思】第6步，给的是一个Trap点，要进入室内和NPC对话
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 8 and nSubTaskId == 65 and nStepId == 4 then
        --- 【雷霆手段】第4步，匹配寻路坐标"澄惠"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 8 and nSubTaskId == 65 and nStepId == 7 then
        --- 【雷霆手段】第7步，匹配寻路坐标"回风角草堂"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 8 and nSubTaskId == 66 and nStepId == 2 then
        --- 【耸人听闻】第2步，匹配寻路坐标"玄慈大师"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 8 and nSubTaskId == 67 and nStepId == 2 then
        --- 【溃堤之谜】第2步，匹配寻路坐标"金刚岭"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 8 and nSubTaskId == 69 and nStepId == 2 then
        --- 【家国大义】第2步，匹配寻路坐标"金刚岭"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 9 and nSubTaskId == 72 and nStepId == 4 then
        --- 【惊心之旅】第4步，匹配寻路坐标"天刑殿"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 9 and nSubTaskId == 72 and nStepId == 6 then
        --- 【惊心之旅】第6步，匹配寻路坐标"中成殿"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 9 and nSubTaskId == 74 and nStepId == 8 then
        --- 【终极营救】第8步，没有给白秋林的寻路坐标，暂时飞到龙泉村交任务
        print(tbStepParams.szTaskName, tbStepParams.szSubTaskName, tbStepParams.nStepId, "没有给寻路坐标")
        tbStepCases[#tbStepCases].bMatch = true
        table.insert(tbStepCases[#tbStepCases], { "NewWorld", { nMapId = 7, nX = 1528, nY = 3271 } })
        table.insert(tbStepCases[#tbStepCases], { "SetFightState", { nState = 0 } }) --- NewWorld到城里需要切换为非战斗状态
      elseif nTaskId == 10 and nSubTaskId == 77 and nStepId == 7 then
        --- 【惊心动魄4D】第7步，匹配寻路坐标"行在内营"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 10 and nSubTaskId == 78 and nStepId == 1 then
        --- 【因爱生恨】第1步，匹配寻路坐标"仇雪的房间"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 11 and nSubTaskId == 79 and nStepId == 5 then
        --- 【遇刺】第5步，匹配寻路坐标"布衣阁"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 11 and nSubTaskId == 80 and nStepId == 2 then
        --- 【怒杀】第2步，匹配寻路坐标"西厢"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 11 and nSubTaskId == 80 and nStepId == 7 then
        --- 【怒杀】第7步，匹配寻路坐标"正厅"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 11 and nSubTaskId == 80 and nStepId == 8 then
        --- 【怒杀】第8步，匹配寻路坐标"布衣阁"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 11 and nSubTaskId == 81 and nStepId == 1 then
        --- 【推陈出新】第1步，匹配寻路坐标"拙者居"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 11 and nSubTaskId == 81 and nStepId == 5 then
        --- 【推陈出新】第5步，匹配寻路坐标"拙者居"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 11 and nSubTaskId == 82 and nStepId == 6 then
        --- 【秋狩】第6步，匹配寻路坐标"拙者居"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 11 and nSubTaskId == 83 and nStepId == 1 then
        --- 【意料之外】第1步，匹配寻路坐标"布衣阁"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 11 and nSubTaskId == 83 and nStepId == 2 then
        --- 【意料之外】第2步，匹配寻路坐标"拙者居"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 11 and nSubTaskId == 83 and nStepId == 3 then
        --- 【意料之外】第3步，匹配寻路坐标"布衣阁"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 11 and nSubTaskId == 83 and nStepId == 9 then
        --- 【意料之外】第9步，匹配寻路坐标"布衣阁"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 11 and nSubTaskId == 84 and nStepId == 4 then
        --- 【孤家寡人】第4步，匹配寻路坐标"布衣阁"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 12 and nSubTaskId == 85 and nStepId == 7 then
        --- 【罗盘定宝】第7步，匹配寻路坐标"春梅雅筑"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 12 and nSubTaskId == 87 and nStepId == 8 then
        --- 【祸起萧墙】第8步，匹配寻路坐标"春梅雅筑"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 12 and nSubTaskId == 90 and nStepId == 5 then
        --- 【擒贼擒王】第5步，匹配寻路坐标"春梅雅筑"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 12 and nSubTaskId == 91 and nStepId == 2 then
        --- 【劫难过后】第2步，匹配寻路坐标"春梅雅筑"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 12 and nSubTaskId == 91 and nStepId == 4 then
        --- 【劫难过后】第4步，匹配寻路坐标"春梅雅筑"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 12 and nSubTaskId == 92 and nStepId == 1 then
        --- 【江湖】第1步，匹配寻路坐标"馆驿"，进入室内与5大掌门对话
        tbStepCases[#tbStepCases].bMatch = true
        Task.AutoTest["TalkWithNpc"].nCount = Task.AutoTest["TalkWithNpc"].nCount + 1
        if Task.AutoTest["TalkWithNpc"].nCount == 1 then
          local tbPath = tbStepPath[1]
          table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        end
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
        if Task.AutoTest["TalkWithNpc"].nCount == 5 then
          Task.AutoTest["TalkWithNpc"].nCount = 0
        end
      elseif nTaskId == 12 and nSubTaskId == 92 and nStepId == 2 then
        --- 【江湖】第2步，匹配寻路坐标"春梅雅筑"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 12 and nSubTaskId == 92 and nStepId == 4 then
        --- 【江湖】第4步，匹配寻路坐标"春梅雅筑"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 12 and nSubTaskId == 93 and nStepId == 2 then
        --- 【佳人落难】第2步，匹配寻路坐标"春梅雅筑后宅"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 12 and nSubTaskId == 93 and nStepId == 7 then
        --- 【佳人落难】第7步，匹配寻路坐标"春梅雅筑后宅"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 12 and nSubTaskId == 94 and nStepId == 4 then
        --- 【神秘贵客】第4步，匹配寻路坐标"春梅雅筑后宅"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 12 and nSubTaskId == 95 and nStepId == 4 then
        --- 【圆满结局】第4步，匹配寻路坐标"品荷堂"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 12 and nSubTaskId == 95 and nStepId == 5 then
        --- 【圆满结局】第5步，匹配寻路坐标"春梅雅筑后宅"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 12 and nSubTaskId == 95 and nStepId == 7 then
        --- 【圆满结局】第7步，没有给白秋林的寻路坐标，暂时飞到龙泉村交任务
        print(tbStepParams.szTaskName, tbStepParams.szSubTaskName, tbStepParams.nStepId, "没有给寻路坐标")
        tbStepCases[#tbStepCases].bMatch = true
        table.insert(tbStepCases[#tbStepCases], { "NewWorld", { nMapId = 7, nX = 1528, nY = 3271 } })
        table.insert(tbStepCases[#tbStepCases], { "SetFightState", { nState = 0 } }) --- NewWorld到城里需要切换为非战斗状态
      elseif nTaskId == 13 and nSubTaskId == 96 and nStepId == 8 then
        --- 【尾随】第8步，匹配寻路坐标"飞龙谷"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 13 and nSubTaskId == 99 and nStepId == 5 then
        --- 【兵不厌诈】第5步，匹配寻路坐标"嘉王"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 14 and nSubTaskId == 101 and nStepId == 5 then
        --- 【勤王】第5步，匹配寻路坐标"豹卫"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 15 and nSubTaskId == 106 and nStepId == 6 then
        --- 【除丧】第6步，匹配寻路坐标"嘉王"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 15 and nSubTaskId == 107 and nStepId == 3 then
        --- 【手谕】第3步，匹配寻路坐标"嘉王"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 15 and nSubTaskId == 107 and nStepId == 7 then
        --- 【手谕】第7步，匹配寻路坐标"嘉王"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 15 and nSubTaskId == 108 and nStepId == 6 then
        --- 【吴氏】第6步，匹配寻路坐标"嘉王"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 15 and nSubTaskId == 108 and nStepId == 9 then
        --- 【吴氏】第9步，匹配寻路坐标"嘉王"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 15 and nSubTaskId == 109 and nStepId == 4 then
        --- 【新朝】第4步，匹配寻路坐标"嘉王"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 15 and nSubTaskId == 109 and nStepId == 9 then
        --- 【新朝】第9步，没有给寻路坐标，NPC嘉王应该就在附近
        print(tbStepParams.szTaskName, tbStepParams.szSubTaskName, tbStepParams.nStepId, "没有给寻路坐标")
        tbStepCases[#tbStepCases].bMatch = true
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 16 and nSubTaskId == 111 and nStepId == 7 then
        --- 【隐秘】第7步，匹配寻路坐标"山庄"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 19 and nSubTaskId == 128 and nStepId == 2 then
        --- 【新发现】第2步，匹配寻路坐标"萧万山"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 19 and nSubTaskId == 130 and nStepId == 3 then
        --- 【寻回】第3步，匹配寻路坐标"萧万山"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 19 and nSubTaskId == 131 and nStepId == 3 then
        --- 【分舵】第3步，匹配寻路坐标"许冠然"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 19 and nSubTaskId == 131 and nStepId == 5 then
        --- 【分舵】第5步，匹配寻路坐标"许冠然"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 19 and nSubTaskId == 132 and nStepId == 2 then
        --- 【佯攻】第2步，匹配寻路坐标"许冠然"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 19 and nSubTaskId == 132 and nStepId == 3 then
        --- 【佯攻】第3步，匹配寻路坐标"萧万千"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 19 and nSubTaskId == 132 and nStepId == 5 then
        --- 【佯攻】第5步，匹配寻路坐标"副旗主"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 20 and nSubTaskId == 136 and nStepId == 2 then
        --- 【线索】第2步，匹配寻路坐标"线索"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 20 and nSubTaskId == 136 and nStepId == 3 then
        --- 【线索】第3步，匹配寻路坐标"树干"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 20 and nSubTaskId == 137 and nStepId == 2 then
        --- 【线索】第3步，匹配寻路坐标"无毒弟子的踪迹"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 20 and nSubTaskId == 137 and nStepId == 5 then
        --- 【线索】第5步，匹配寻路坐标"幸存下来的无毒弟子"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 50 and nSubTaskId == 198 and nStepId == 8 then
        --- 【神秘主人】第8步，匹配寻路坐标"神秘主人"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 71 and nSubTaskId == 220 and nStepId == 2 then
        --- 【试手之战】第2步，匹配寻路坐标"中成殿"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 72 and nSubTaskId == 221 and nStepId == 3 then
        --- 【内忧外患】第3步，匹配寻路坐标"中成殿"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 73 and nSubTaskId == 222 and nStepId == 4 then
        --- 【刺客的下场】第4步，匹配寻路坐标"中成殿"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 75 and nSubTaskId == 224 and nStepId == 1 then
        --- 【峨眉往事】第1步，匹配寻路坐标"无念师太"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 133 and nSubTaskId == 282 and nStepId == 2 then
        --- 【大案之深闺】第2步，寻路坐标是Trap点"徐良家"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 157 and nSubTaskId == 321 and nStepId == 3 then
        --- 【失踪之人】第3步，匹配寻路坐标"白疆先生"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 218 and nSubTaskId == 393 and nStepId == 4 then
        --- 【擂台赛】第4步，匹配寻路坐标"公平子"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 234 and nSubTaskId == 409 and nStepId == 19 then
        --- 【旬讲数日】第十九步，匹配寻路坐标"朱老先生"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 243 and nSubTaskId == 418 and nStepId == 1 then
        --- 【秘访鞑靼】第1步，匹配寻路坐标"赵相"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 244 and nSubTaskId == 419 and nStepId == 3 then
        --- 【草原英雄】第3步，匹配寻路坐标"赵相"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 245 and nSubTaskId == 420 and nStepId == 8 then
        --- 【金国使节】第8步，匹配寻路坐标"赵相"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 246 and nSubTaskId == 421 and nStepId == 3 then
        --- 【故辽奇才】第3步，匹配寻路坐标"赵相"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 249 and nSubTaskId == 424 and nStepId == 5 then
        --- 【分进合击】第5步，匹配寻路坐标"赵相"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 250 and nSubTaskId == 425 and nStepId == 3 then
        --- 【强悍骑兵】第3步，匹配寻路坐标"赵相"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      elseif nTaskId == 263 and nSubTaskId == 438 and nStepId == 2 then
        --- 【妙计捕盗】第2步，匹配寻路坐标"梅花盗的首领"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
      else
        if Task.AutoTest:FindPathByName(tbStepPath, szNpcName) then
          local tbPath = Task.AutoTest:FindPathByName(tbStepPath, szNpcName)
          tbStepCases[#tbStepCases].bMatch = true
          if tbPath.szType == "pos" then
            table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
            table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
            table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
          end
          if tbPath.szType == "npcpos" then
            table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
            table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
            table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
          end
        elseif Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcId) then
          local tbPath = Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcId)
          tbStepCases[#tbStepCases].bMatch = true
          table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
          table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
          table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
        else
          local nX, nY = KNpc.ClientGetNpcPos(nMapId, nNpcId)
          local tbPath = Task.AutoTest:FindPathByPos(tbStepPath, nMapId, nX, nY)
          if tbPath then
            tbStepCases[#tbStepCases].bMatch = true
            table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
            table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcId } })
            table.insert(tbStepCases[#tbStepCases], { "GotoNpc", { nNpcId = nNpcId } })
          end
        end
      end

      if not tbStepCases[#tbStepCases].bMatch then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId)
        print("TalkWithNpc找不到匹配的寻路坐标")
        assert(false, "TalkWithNpc找不到匹配的寻路坐标")
      end

      if nTaskId == 18 and nSubTaskId == 122 and nStepId == 5 then
        --- 【卷轴】第5步，给玩家了一个山泉水
        tbAddItems[#tbAddItems + 1] = {}
        tbAddItems[#tbAddItems].tbItem = { 20, 1, 323, 1 }
        tbAddItems[#tbAddItems].nItemNum = 1
      end

      table.insert(tbStepCases[#tbStepCases], { "InteractWithNpc", { nNpcId = nNpcId } })
      if szOption == "<subtaskname>" then
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = szSubTaskName } })
      else
        table.insert(tbStepCases[#tbStepCases], { "SaySelectOptionKeyword", { szKeyword = szOption } })
      end
      table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} })

      local nStepId = tbStepParams.nStepId
      local nStepCount = tbStepParams.nStepCount
      if nStepId == nStepCount then
        --- 如果是最后一个步骤，需要领取奖励
        local nBagSpaceCount = tbStepParams.nBagSpaceCount
        local tbAwards = tbStepParams.tbAwards

        table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} }) --领奖可能会产生黑屏，要过掉
        if nBagSpaceCount > 0 then
          table.insert(tbStepCases[#tbStepCases], { "BagHasSpace", { nEmptyNum = nBagSpaceCount } })
        end

        if #tbAwards.tbFix ~= 0 then
          --- 领取固定奖励
          table.insert(tbStepCases[#tbStepCases], { "AcceptReward", { bAccept = 1, nSelectedAward = 0, nNpcId = nNpcId, szTaskName = szSubTaskName } })
          local tbAwards = tbAwards.tbFix
          for _, tbAward in pairs(tbAwards) do
            if self:ParseConditionTable(tbAward.tbConditions) then
              if tbAward.szType == "exp" then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "exp", nValue = tbAward.varValue } })
              elseif tbAward.szType == "money" then
                if tbStepParams.nLevel < 30 then
                  table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
                else
                  table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "money", nValue = tbAward.varValue } })
                end
              elseif tbAward.szType == "bindmoney" then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
              elseif tbAward.szType == "makepoint" then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "makepoint", nValue = tbAward.varValue } })
              elseif tbAward.szType == "gatherpoint" then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "gatherpoint", nValue = tbAward.varValue } })
              elseif tbAward.szType == "item" then
                local tbItemId = tbAward.varValue
                local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
                local nItemNum = tbAward.szAddParam1
                assert(nItemNum >= 0, "奖励物品个数填错了")
                if nItemNum == 0 then
                  nItemNum = 1
                end
                table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nItemNum } })
              elseif tbAward.szType == "customizeitem" then
                local tbItemId = tbAward.varValue
                local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
                table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = 1 } })
              elseif tbAward.szType == "title" then
                local tbTitle = tbAward.varValue
              elseif tbAward.szType == "repute" then
                local tbRepute = tbAward.varValue
              elseif tbAward.szType == "taskvalue" then
                local tbTaskValue = tbAward.varValue
              elseif tbAward.szType == "script" then
                local szFnScript = tbAward.varValue
              elseif tbAward.szType == "arrary" then
              elseif tbAward.szType == "KinReputeEntry" then
              else
                for key, value in pairs(tbAward) do
                  print(key, value)
                  if type(value) == "table" then
                    for i, v in pairs(value) do
                      print(i, v)
                    end
                  end
                end
                print(tbStepParams.szSubTaskName)
                assert(false, "Exception Award!")
              end
            end
          end
        elseif #tbAwards.tbOpt ~= 0 then
          --- 领取可选奖励
          local tbAwards = tbAwards.tbOpt
          local nSelectedAward = MathRandom(#tbAwards)

          table.insert(tbStepCases[#tbStepCases], { "AcceptReward", { bAccept = 1, nSelectedAward = nSelectedAward, nNpcId = nNpcId, szTaskName = szSubTaskName } })

          local tbAward = tbAwards[nSelectedAward]
          if self:ParseConditionTable(tbAward.tbConditions) then
            if tbAward.szType == "exp" then
              table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "exp", nValue = tbAward.varValue } })
            elseif tbAward.szType == "money" then
              if tbStepParams.nLevel < 30 then
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
              else
                table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "money", nValue = tbAward.varValue } })
              end
            elseif tbAward.szType == "bindmoney" then
              table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
            elseif tbAward.szType == "makepoint" then
              table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "makepoint", nValue = tbAward.varValue } })
            elseif tbAward.szType == "gatherpoint" then
              table.insert(tbStepCases[#tbStepCases], { "CheckStatDelta", { szType = "gatherpoint", nValue = tbAward.varValue } })
            elseif tbAward.szType == "item" then
              local tbItemId = tbAward.varValue
              local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
              local nItemNum = tbAward.szAddParam1
              assert(nItemNum >= 0, "奖励物品个数填错了")
              if nItemNum == 0 then
                nItemNum = 1
              end
              table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nItemNum } })
            elseif tbAward.szType == "customizeitem" then
              local tbItemId = tbAward.varValue
              local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
              table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = 1 } })
            elseif tbAward.szType == "title" then
              local tbTitle = tbAward.varValue
            elseif tbAward.szType == "repute" then
              local tbRepute = tbAward.varValue
            elseif tbAward.szType == "taskvalue" then
              local tbTaskValue = tbAward.varValue
            elseif tbAward.szType == "script" then
              local szFnScript = tbAward.varValue
            elseif tbAward.szType == "arrary" then
            elseif tbAward.szType == "KinReputeEntry" then
            else
              for key, value in pairs(tbAward) do
                print(key, value)
                if type(value) == "table" then
                  for i, v in pairs(value) do
                    print(i, v)
                  end
                end
              end
              print(tbStepParams.szSubTaskName)
              assert(false, "Exception Award!")
            end
          else
            assert(false, "领取随机奖励失败")
          end
        elseif #tbAwards.tbRand ~= 0 then
          --- 领取随机奖励
          --- TODO: 目前暂时没有随机奖励的设定，暂不做考虑
        else
          print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId)
          print("没有填写任务奖励!")
          --	assert(false,"没有填写任务奖励!");
        end

        --- 领取奖励完后会有黑屏，先要过掉黑屏
        table.insert(tbStepCases[#tbStepCases], { "TalkClose", {} })

        --- 领取奖励后，如果是询问接受任务，且此时子任务不是最后一个子任务，则接受，否则不接受
        local tbExecute = tbStepParams.tbExecute
        if #tbExecute ~= 0 then
          local nReferIdx = tbStepParams.nReferIdx
          local nSubNum = tbStepParams.nSubNum
          if nReferIdx ~= nSubNum then
            table.insert(tbStepCases[#tbStepCases], { "AcceptTask", { bAccept = 1 } })
          else
            table.insert(tbStepCases[#tbStepCases], { "AcceptTask", { bAccept = 0 } })
          end
        end
      end
    elseif szTargetName == "Timer" then
      --- 限时
      local nTotalSec = tbTarget.nTotalSec
      local nMode = tbTarget.nMode
      local fnCall
      if tbTarget.fnCall then
        fnCall = tbTarget.fnCall
      end

      --- TODO: 通知计时器开始计时
      table.insert(tbStepCases, 1, {})
      table.insert(tbStepCases[1], { "SetLimitTime", { nLimitTime = nTotalSec, nMode = nMode, nOpCount = 0 } })
    elseif szTargetName == "TipPopo" then
      --- 提示泡泡

      --- TODO 不做操作，直接过掉
      --- table.insert(tbStepCases, {"SaveStat", {}});
    elseif szTargetName == "UserTrackInfo" then
      --- 任务追踪信息（仅仅作为描述的目标）

      --- TODO 不做操作，直接过掉
      --- table.insert(tbStepCases, {"SaveStat", {}});
    elseif szTargetName == "UseShortcut" then
      --- 使用快捷键（目前没有此目标）
      --- table.insert(tbStepCases, {"SaveStat", {}});
    elseif szTargetName == "WithProcess" then
      --- 进度条目标
      local nNpcTempId = tbTarget.nNpcTempId
      local szNpcName = tbTarget.szNpcName
      local nMapId = tbTarget.nMapId
      local szMapName = tbTarget.szMapName
      local nIntervalTime = tbTarget.nIntervalTime / 18 --- 单位由帧换为秒
      local tbItemList = tbTarget.ItemList
      local tbRealItemList = self:ParseItemList(tbItemList)
      local nSpaceCount = #tbRealItemList
      local nNeedCount = tbTarget.nNeedCount
      local tbNpcSet = tbTarget.tbNpcSet
      assert(#tbNpcSet ~= 0, "NPC刷点坐标集合没有填")

      tbStepCases[#tbStepCases + 1] = {}
      if nSpaceCount > 0 then
        table.insert(tbStepCases[#tbStepCases], { "BagHasSpace", { nEmptyNum = nSpaceCount } })
      end

      if not tbStepPath then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId, "WithProcess没有提供寻路坐标")
        assert(tbStepPath, "WithProcess没有提供寻路坐标")
      end

      -------------========= 一些特殊Case的匹配处理  ==========------------
      local nTaskId = tbStepParams.nTaskId
      local nSubTaskId = tbStepParams.nSubTaskId
      local nStepId = tbStepParams.nStepId

      if nTaskId == 6 and nSubTaskId == 55 and nStepId == 5 then
        --- 【惊心动魄】第5步，没有给寻路坐标
        print(tbStepParams.szTaskName, tbStepParams.szSubTaskName, tbStepParams.nStepId, "没有给寻路坐标")
        tbStepCases[#tbStepCases].bMatch = true
        Task.AutoTest["WithProcess"].bExtend = true
      elseif nTaskId == 167 and nSubTaskId == 330 and nStepId == 1 then
        --- 【影社英灵】第1步，只给一个Trap点"猛虎巷"
        tbStepCases[#tbStepCases].bMatch = true
        local tbPath = tbStepPath[1]
        Task.AutoTest["WithProcess"].bExtend = true
        table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
      else
        if Task.AutoTest:FindPathByName(tbStepPath, szNpcName) then
          local tbPath = Task.AutoTest:FindPathByName(tbStepPath, szNpcName)
          tbStepCases[#tbStepCases].bMatch = true
          if tbPath.szType == "pos" then
            table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
          end
          if tbPath.szType == "npcpos" then
            table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
          end
        elseif Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcTempId) then
          local tbPath = Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcTempId)
          tbStepCases[#tbStepCases].bMatch = true
          table.insert(tbStepCases[#tbStepCases], { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
        else
          for i = 1, #tbNpcSet do
            local tbPath = Task.AutoTest:FindPathByPos(tbStepPath, nMapId, tbNpcSet[i].nX, tbNpcSet[i].nY)
            if tbPath then
              tbStepCases[#tbStepCases].bMatch = true
              table.insert(tbStepCases[#tbStepCases], { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
              break
            end
          end
        end
      end

      if not tbStepCases[#tbStepCases].bMatch then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId)
        print("WithProcess找不到匹配的寻路坐标")
        assert(false, "WithProcess找不到匹配的寻路坐标")
      end

      table.insert(tbStepCases[#tbStepCases], { "SetFightState", { nState = 0 } })

      if Task.AutoTest["WithProcess"].bExtend == true then
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcTempId, bExtend = true } })
      else
        table.insert(tbStepCases[#tbStepCases], { "FindNpc", { nNpcId = nNpcTempId } })
      end
      table.insert(tbStepCases[#tbStepCases], { "GatherItems", { nNpcId = nNpcTempId, nItemNum = nNeedCount, nDelay = nIntervalTime, tbPositions = tbNpcSet } })

      if nSpaceCount > 0 then
        for _, tbTempItem in pairs(tbRealItemList) do
          local tbItemId = tbTempItem.tbItem
          local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
          local nItemNum = tbTempItem.nItemNum
          local nCount = nItemNum * nNeedCount
          table.insert(tbStepCases[#tbStepCases], { "CheckItemDelta", { tbItem = tbItem, nValue = nCount } })
          table.insert(tbStepCases[#tbStepCases], { "SaveSingleStat", { szState = "item" } })

          tbAddItems[#tbAddItems + 1] = {}
          tbAddItems[#tbAddItems].tbItem = tbItem
          tbAddItems[#tbAddItems].nItemNum = nCount
        end
      end
      table.insert(tbStepCases[#tbStepCases], { "SetFightState", { nState = 1 } })
    elseif szTargetName == "ReputeValue" then
      --- 查看军营声望
      local nCampId = tbTarget.nCampId
      local nClassId = tbTarget.nClassId
      local nValue = tbTarget.nValue

      table.insert(tbStepCases[#tbStepCases], { "AddReputeValue", { nCampId = nCampId, nClassId = nClassId, nValue = nValue } })
    else
      print(tbStepParams.nTaskId, tbStepParams.nSubTaskId, tbStepParams.nStepId)
      assert(false, "Exception Target!")
    end
  end

  --- 如果此步骤有限时目标，需要特殊处理
  if #tbStepCases > 0 then
    local tbStepCase = tbStepCases[1][1]
    if tbStepCase == nil then
      print(tbStepParams.nTaskId, tbStepParams.nSubTaskId, tbStepParams.nStepId, tbStepParams.szSubTaskName)
    end
    if tbStepCase[1] == "SetLimitTime" and #tbStepCases > 1 then
      for i = 2, #tbStepCases do
        for j = 1, #tbStepCases[i] do
          tbStepCase[2].nOpCount = tbStepCase[2].nOpCount + 1
          tbStepCases[i][j][2].nOpId = tbStepCase[2].nOpCount
        end
      end
    end
  end

  for i = 1, #tbStepCases do
    for j = 1, #tbStepCases[i] do
      table.insert(tbReferCase, tbStepCases[i][j])
    end
  end

  return tbReferCase, tbAddItems, tbGiveItems
end

function Task.AutoTest:DoExecute(tbStepExecute, tbReferCase, tbAddItems, tbGiveItems, tbStepParams)
  for _, szExecute in pairs(tbStepExecute) do
    if type(szExecute) ~= "string" then
      assert(false)
    end

    if string.find(szExecute, "TaskAct:AddExp") then
      --- 步骤完成后增加经验
      local nExp = loadstring(string.gsub(szExecute, "return TaskAct:AddExp(.+)", "return tonumber(%1)"))()
      table.insert(tbReferCase, { "CheckStatDelta", { szType = "exp", nValue = nExp } })
    elseif string.find(szExecute, "TaskAct:AddMoney") then
      --- 步骤完成后增加金钱
      local nMoney = loadstring(string.gsub(szExecute, "return TaskAct:AddMoney(.+)", "return tonumber(%1)"))()
      if tbStepParams.nLevel < 30 then
        --- 如果任务等级小于30级，给的都是绑定银两
        table.insert(tbReferCase, { "CheckStatDelta", { szType = "bindmoney", nValue = nMoney } })
      else
        table.insert(tbReferCase, { "CheckStatDelta", { szType = "money", nValue = nMoney } })
      end
    elseif string.find(szExecute, "TaskAct:AddItem") and not string.find(szExecute, "TaskAct:AddItems") then
      --- 步骤完成后增加物品
      local tbItemId = loadstring(string.gsub(szExecute, "return TaskAct:AddItem(.+)", "return %1"))()
      local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
      table.insert(tbReferCase, { "CheckItemDelta", { tbItem = tbItem, nValue = 1 } })

      tbAddItems[#tbAddItems + 1] = {}
      tbAddItems[#tbAddItems].tbItem = tbItem
      tbAddItems[#tbAddItems].nItemNum = 1
    elseif string.find(szExecute, "TaskAct:AddItems") then
      --- 步骤完成后增加多个物品
      local tbItemId, nCount = loadstring(string.gsub(szExecute, "return TaskAct:AddItems%((.+)%)", "return %1"))()
      local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
      table.insert(tbReferCase, { "CheckItemDelta", { tbItem = tbItem, nValue = nCount } })

      tbAddItems[#tbAddItems + 1] = {}
      tbAddItems[#tbAddItems].tbItem = tbItem
      tbAddItems[#tbAddItems].nItemNum = nCount
    elseif string.find(szExecute, "TaskAct:AddMakePoint") then
      --- 步骤完成后增加精力
      local nAddPoint = loadstring(string.gsub(szExecute, "return TaskAct:AddMakePoint%((.+)%)", "return %1"))()
      table.insert(tbReferCase, { "CheckStatDelta", { szType = "makepoint", nValue = nAddPoint } })
    elseif string.find(szExecute, "TaskAct:AddGatherPoint") then
      --- 步骤完成后增加活力
      local nAddPoint = loadstring(string.gsub(szExecute, "return TaskAct:AddGatherPoint%((.+)%)", "return %1"))()
      table.insert(tbReferCase, { "CheckStatDelta", { szType = "gatherpoint", nValue = nAddPoint } })
    elseif string.find(szExecute, "TaskAct:Talk") and not string.find(szExecute, "TaskAct:TalkInDark") then
      --- 步骤完成后对话黑屏
      table.insert(tbReferCase, { "TalkClose", {} })
    elseif string.find(szExecute, "TaskAct:TalkInDark") then
      --- 步骤完成后对话黑屏
      table.insert(tbReferCase, { "TalkClose", {} })
    elseif string.find(szExecute, "TaskAct:NormalTalk") then
      --- 策划一般不会填这个
      --- 步骤完成后对话黑屏
      table.insert(tbReferCase, { "TalkClose", {} })
    elseif string.find(szExecute, "TaskAct:AddObj") then
      --- 在当前位置增加一个OBJ（暂时不做检测处理）
    elseif string.find(szExecute, "TaskAct:NewWorld") and not string.find(szExecute, "TaskAct:NewWorldWithState") then
      --- 传送到指定地图（暂时不做检测处理）
    elseif string.find(szExecute, "TaskAct:NewWorldWithState") then
      --- 传送到指定地图转换战斗状态（暂时不做检测处理）
    elseif string.find(szExecute, "TaskAct:DoSkill") then
      --- 释放技能（暂时不做检测处理）
    elseif string.find(szExecute, "TaskAct:SetTaskValue") then
      --- 设置任务变量（暂时不做检测处理）
    elseif string.find(szExecute, "TaskAct:SetPlayerLife") then
      --- 将玩家血量减到指定值
      --			local nCurLife = loadstring(string.gsub(szExecute,"return TaskAct:SetPlayerLife(.+)", "return tonumber(%1)"))();
      --			table.insert(tbReferCase, {"CheckStatDelta", {szType = "life", nValue = nCurLife}});
    elseif string.find(szExecute, "TaskAct:DelItem") then
      --- 删除玩家物品
      local tbTempItem, nCount = loadstring(string.gsub(szExecute, "return TaskAct:DelItem%((.+)%)", "return %1"))()
      local nParticular = tbTempItem[1]
      local tbItem = { 20, 1, nParticular, 1 }

      if not self:IsGiveItem(tbGiveItems, tbItem) then
        if nCount <= 0 then
          nCount = self:FindItemCount(tbAddItems, tbItem)
          if tbStepParams.nTaskId == 157 and tbStepParams.nSubTaskId == 317 and tbStepParams.nStepId == 2 then
            nCount = 8
          end
          assert(nCount > 0, "Error")
        end
        nCount = nCount * -1

        table.insert(tbReferCase, { "CheckItemDelta", { tbItem = tbItem, nValue = nCount } })
        tbConflict.tbItem = tbItem
        tbConflict.nIndex = #tbReferCase
      end
    elseif string.find(szExecute, "TaskAct:AddCustomizeItem") then
      --- 步骤完成后增加自定义物品
      local nGenre, nDetailType, nParticularType, nLevel, nSeries, nLuck, nCount = loadstring(string.gsub(szExecute, "return TaskAct:AddCustomizeItem%((.+)%)", "return %1"))()
      local tbItem = { nGenre, nDetailType, nParticularType, nLevel }

      table.insert(tbReferCase, { "CheckItemDelta", { tbItem = tbItem, nValue = nCount } })

      tbAddItems[#tbAddItems + 1] = {}
      tbAddItems[#tbAddItems].tbItem = tbItem
      tbAddItems[#tbAddItems].nItemNum = nCount
    elseif string.find(szExecute, "TaskAct:AddRecip") then
      --- 增加生活技能的配方（暂时不做检测处理）
    elseif string.find(szExecute, "TaskAct:AddLifeSkill") then
      --- 将指定生活技能提升到指定等级
      local nSkillId, nSkillLevel = loadstring(string.gsub(szExecute, "return TaskAct:AddLifeSkill%((.+)%)", "return %1"))()
      table.insert(tbReferCase, { "CheckLifeSkill", { nSkillId = nSkillId, nSkillLevel = nSkillLevel } })
    elseif string.find(szExecute, "TaskAct:StepOverEvent") then
      --- 步骤结束泡泡（黑色的横条提示）
    elseif string.find(szExecute, "TaskAct:StepOverWithTalk") then
      --- 步骤结束后黑屏（暂时不做检测处理）
      table.insert(tbReferCase, { "TalkClose", {} })
    elseif string.find(szExecute, "TaskAct:AddAnger") then
      --- 增加玩家怒气值（暂时不做检测处理）
    elseif string.find(szExecute, "TaskAct:SelBindMoney") then
      --- 增加玩家绑定银两
      local nMoney, nBind = loadstring(string.gsub(szExecute, "return TaskAct:SelBindMoney%((.+)%)", "return %1"))()
      if not nBind or nBind ~= 1 then
        --- 增加的是非绑定银两
        table.insert(tbReferCase, { "CheckStatDelta", { szType = "money", nValue = nMoney } })
      else
        table.insert(tbReferCase, { "CheckStatDelta", { szType = "bindmoney", nValue = nMoney } })
      end
    else
      print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId)
      assert(false, "Exception Execute!")
    end
  end

  return tbReferCase, tbAddItems
end

--- 每一个子任务的测试放在一个子表中，子表结构如下:
--- { "子任务: ***",
---	  {"步骤一函数名", {参数表}},
---	          ......
---	  {"最后一步函数名", {参数表}},
---	  每一步完成后，如果玩家发生状态改变，需要添加检查
--- }
function Task.AutoTest:ParseSubData(tbSubData, tbReferCase, tbParams)
  local szSubTaskName = tbParams.szSubTaskName
  local szSubTestName = "子任务： " .. szSubTaskName
  if tbParams.nReferIdx ~= 1 then
    table.insert(tbReferCase, szSubTestName)
  end

  local tbExecute = tbSubData.tbExecute
  local tbStartExecute = tbSubData.tbStartExecute
  local tbFailedExecute = tbSubData.tbFailedExecute
  local tbFinishExecute = tbSubData.tbFinishExecute

  local tbSteps = tbSubData.tbSteps
  for nStepId, tbStep in pairs(tbSteps) do
    --- 执行任务目标
    local tbTargets = tbStep.tbTargets
    local tbStepParams = tbParams
    if tbParams.tbStepsPath[nStepId] then
      tbStepParams.tbStepPath = tbParams.tbStepsPath[nStepId]
    end
    tbStepParams.nStepId = nStepId
    tbStepParams.nStepCount = #tbSteps
    tbStepParams.tbExecute = tbExecute
    tbStepParams.nSubTaskId = tbSubData.nId
    local tbGiveItems = {} --- 记录此步骤玩家上交的物品与个数，避免删除重复

    tbReferCase, tbAddItems, tbGiveItems = self:DoTarget(tbTargets, tbReferCase, tbStepParams)

    --- 判断是否能够完成步骤
    local tbEvent = tbStep.tbEvent
    if tbEvent.nType == 1 or tbEvent.nType == 2 then
      --- 如果步骤之间不是自动触发，需要检查是否达到完成条件
      local tbJudge = tbStep.tbJudge
      table.insert(tbReferCase, { "CanStepFinish", { tbJudge = tbJudge } })

      --- 如果达到完成条件，需要和指定的NPC交互触发下一步
      local nNpcId = tbEvent.nValue
      local tbStepPath = tbParams.tbStepsPath[nStepId]
      if not tbStepPath then
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId, "没有提供寻路坐标")
        assert(tbStepPath, "没有提供寻路坐标")
      end
      if Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcId) then
        local tbPath = Task.AutoTest:FindPathByNpcId(tbStepPath, nNpcId)
        table.insert(tbReferCase, { "GotoNpcMap", { szMapInfo = tbPath.szMapInfo, nNpcId = tbPath.nNpcId } })
      elseif tbStepParams.nTaskId == 1 and tbStepParams.nSubTaskId == 4 and tbStepParams.nStepId == 5 then
        --- 【杀机重重】没有给交任务NPC的寻路坐标，NPC就在护送终点处
        table.insert(tbReferCase, { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbReferCase, { "GotoNpc", { nNpcId = nNpcId } })
      elseif tbStepParams.nTaskId == 2 and tbStepParams.nSubTaskId == 14 and tbStepParams.nStepId == 2 then
        --- 【白石山场】交任务的NPC的寻路坐标匹配"白石山场"
        local tbPath = tbStepParams.tbStepPath[2]
        table.insert(tbReferCase, { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbReferCase, { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbReferCase, { "GotoNpc", { nNpcId = nNpcId } })
      elseif tbStepParams.nTaskId == 2 and tbStepParams.nSubTaskId == 20 and tbStepParams.nStepId == 2 then
        --- 【惊天之变】没有给交任务NPC的寻路坐标，NPC就在护送终点处
        table.insert(tbReferCase, { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbReferCase, { "GotoNpc", { nNpcId = nNpcId } })
      elseif tbStepParams.nTaskId == 2 and tbStepParams.nSubTaskId == 22 and tbStepParams.nStepId == 5 then
        --- 【鬼神之卦】交任务的NPC的寻路坐标匹配"柳鬼"
        local tbPath = tbStepParams.tbStepPath[1]
        table.insert(tbReferCase, { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbReferCase, { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbReferCase, { "GotoNpc", { nNpcId = nNpcId } })
      elseif tbStepParams.nTaskId == 6 and tbStepParams.nSubTaskId == 54 and tbStepParams.nStepId == 5 then
        --- 【大变突起】交任务的NPC的寻路坐标匹配"飘萍剑客"
        local tbPath = tbStepParams.tbStepPath[1]
        table.insert(tbReferCase, { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbReferCase, { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbReferCase, { "GotoNpc", { nNpcId = nNpcId } })
      elseif tbStepParams.nTaskId == 6 and tbStepParams.nSubTaskId == 56 and tbStepParams.nStepId == 4 then
        --- 【偷天换日】交任务的NPC的寻路坐标匹配"阴山别院后院"
        local tbPath = tbStepParams.tbStepPath[1]
        table.insert(tbReferCase, { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbReferCase, { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbReferCase, { "GotoNpc", { nNpcId = nNpcId } })
      elseif tbStepParams.nTaskId == 9 and tbStepParams.nSubTaskId == 71 and tbStepParams.nStepId == 8 then
        --- 【皇陵监牢】没有给交任务NPC的寻路坐标，NPC就在护送终点处
        table.insert(tbReferCase, { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbReferCase, { "GotoNpc", { nNpcId = nNpcId } })
      elseif tbStepParams.nTaskId == 10 and tbStepParams.nSubTaskId == 76 and tbStepParams.nStepId == 9 then
        --- 【多情种子】交任务的NPC的寻路坐标匹配"侍卫统领"
        local tbPath = tbStepParams.tbStepPath[1]
        table.insert(tbReferCase, { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbReferCase, { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbReferCase, { "GotoNpc", { nNpcId = nNpcId } })
      elseif tbStepParams.nTaskId == 11 and tbStepParams.nSubTaskId == 80 and tbStepParams.nStepId == 3 then
        --- 【怒杀】交任务的NPC的寻路坐标匹配"西厢"
        local tbPath = tbStepParams.tbStepPath[1]
        table.insert(tbReferCase, { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbReferCase, { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbReferCase, { "GotoNpc", { nNpcId = nNpcId } })
      elseif tbStepParams.nTaskId == 12 and tbStepParams.nSubTaskId == 95 and tbStepParams.nStepId == 1 then
        --- 【圆满结局】交任务的NPC的寻路坐标匹配"春梅雅筑后宅"
        local tbPath = tbStepParams.tbStepPath[1]
        table.insert(tbReferCase, { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbReferCase, { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbReferCase, { "GotoNpc", { nNpcId = nNpcId } })
      elseif tbStepParams.nTaskId == 30 and tbStepParams.nSubTaskId == 178 and tbStepParams.nStepId == 3 then
        --- 【影者】交任务的NPC的寻路坐标匹配"画师"
        local tbPath = tbStepParams.tbStepPath[1]
        table.insert(tbReferCase, { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbReferCase, { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbReferCase, { "GotoNpc", { nNpcId = nNpcId } })
      elseif tbStepParams.nTaskId == 37 and tbStepParams.nSubTaskId == 185 and tbStepParams.nStepId == 2 then
        --- 【季候落难】没有给交任务NPC的寻路坐标，NPC就在护送终点处
        table.insert(tbReferCase, { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbReferCase, { "GotoNpc", { nNpcId = nNpcId } })
      elseif tbStepParams.nTaskId == 51 and tbStepParams.nSubTaskId == 199 and tbStepParams.nStepId == 1 then
        --- 【冰穴悲嚎】没有给交任务NPC的寻路坐标，NPC就在护送终点处
        table.insert(tbReferCase, { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbReferCase, { "GotoNpc", { nNpcId = nNpcId } })
      elseif tbStepParams.nTaskId == 57 and tbStepParams.nSubTaskId == 205 and tbStepParams.nStepId == 4 then
        --- 【神秘窃贼】没有给交任务NPC的寻路坐标，NPC就在护送终点处
        table.insert(tbReferCase, { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbReferCase, { "GotoNpc", { nNpcId = nNpcId } })
      elseif tbStepParams.nTaskId == 59 and tbStepParams.nSubTaskId == 207 and tbStepParams.nStepId == 1 then
        --- 【受伤弟子】没有给交任务NPC的寻路坐标，NPC就在护送终点处
        table.insert(tbReferCase, { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbReferCase, { "GotoNpc", { nNpcId = nNpcId } })
      elseif tbStepParams.nTaskId == 62 and tbStepParams.nSubTaskId == 210 and tbStepParams.nStepId == 3 then
        --- 【彩蝶仙子】没有给交任务NPC的寻路坐标，NPC就在护送终点处
        table.insert(tbReferCase, { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbReferCase, { "GotoNpc", { nNpcId = nNpcId } })
      elseif tbStepParams.nTaskId == 74 and tbStepParams.nSubTaskId == 223 and tbStepParams.nStepId == 2 then
        --- 【灭口】交任务的NPC的寻路坐标匹配"中成殿"
        local tbPath = tbStepParams.tbStepPath[2]
        table.insert(tbReferCase, { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbReferCase, { "FindNpc", { nNpcId = nNpcId, bExtend = true } })
        table.insert(tbReferCase, { "GotoNpc", { nNpcId = nNpcId } })
      --			elseif (tbStepParams.nTaskId == 91
      --				and tbStepParams.nSubTaskId == 240
      --				and tbStepParams.nStepId == 1
      --					) then
      --				--- 【钻天燕子】没有给交任务NPC的寻路坐标，NPC就在当前地图中
      --				table.insert(tbReferCase, {"FindNpc", {nNpcId = nNpcId, bExtend = true}});
      --				table.insert(tbReferCase, {"GotoNpc", {nNpcId = nNpcId}});
      elseif tbStepParams.nTaskId == 99 and tbStepParams.nSubTaskId == 248 and tbStepParams.nStepId == 4 then
        --- 【善意的谎言】没有给交任务NPC的寻路坐标，NPC就在当前地图中
        table.insert(tbReferCase, { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbReferCase, { "GotoNpc", { nNpcId = nNpcId } })
      elseif tbStepParams.nTaskId == 201 and tbStepParams.nSubTaskId == 364 and tbStepParams.nStepId == 3 then
        --- 【宗师】交任务的NPC的寻路坐标匹配"铁匠甜酒叔"
        local tbPath = tbStepParams.tbStepPath[1]
        table.insert(tbReferCase, { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbReferCase, { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbReferCase, { "GotoNpc", { nNpcId = nNpcId } })
      elseif tbStepParams.nTaskId == 238 and tbStepParams.nSubTaskId == 413 and tbStepParams.nStepId == 2 then
        --- 【一念之仁】第2步，时间过后交任务的NPC的寻路坐标匹配"赵府门童"
        local tbPath = tbStepParams.tbStepPath[1]
        table.insert(tbReferCase, { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbReferCase, { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbReferCase, { "GotoNpc", { nNpcId = nNpcId } })
      elseif tbStepParams.nTaskId == 239 and tbStepParams.nSubTaskId == 414 and tbStepParams.nStepId == 8 then
        --- 【功败垂成】第8步，时间过后交任务的NPC的寻路坐标匹配"窦昊门主"
        local tbPath = tbStepParams.tbStepPath[1]
        table.insert(tbReferCase, { "Goto", { nMapId = tbPath.nMapId, nX = tbPath.nX, nY = tbPath.nY } })
        table.insert(tbReferCase, { "FindNpc", { nNpcId = nNpcId } })
        table.insert(tbReferCase, { "GotoNpc", { nNpcId = nNpcId } })
      else
        print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId, tbStepParams.nStepId, "没有提供匹配的寻路坐标")
        assert(false, "没有提供匹配的寻路坐标")
      end
      table.insert(tbReferCase, { "InteractWithNpc", { nNpcId = nNpcId } })
      table.insert(tbReferCase, { "SaySelectOptionKeyword", { szKeyword = szSubTaskName } })
      table.insert(tbReferCase, { "TalkClose", {} })

      --- 如果是最后一步需要领取奖励
      if nStepId == #tbSteps then
        --- 如果是最后一个步骤，需要领取奖励
        local nBagSpaceCount = tbStepParams.nBagSpaceCount
        local tbAwards = tbStepParams.tbAwards

        table.insert(tbReferCase, { "TalkClose", {} }) --领奖可能会产生黑屏，要过掉
        if nBagSpaceCount > 0 then
          table.insert(tbReferCase, { "BagHasSpace", { nEmptyNum = nBagSpaceCount } })
        end

        if #tbAwards.tbFix ~= 0 then
          --- 领取固定奖励
          table.insert(tbReferCase, { "AcceptReward", { bAccept = 1, nSelectedAward = 0, nNpcId = nNpcId, szTaskName = szSubTaskName } })
          local tbAwards = tbAwards.tbFix
          for _, tbAward in pairs(tbAwards) do
            if self:ParseConditionTable(tbAward.tbConditions) then
              if tbAward.szType == "exp" then
                table.insert(tbReferCase, { "CheckStatDelta", { szType = "exp", nValue = tbAward.varValue } })
              elseif tbAward.szType == "money" then
                if tbStepParams.nLevel < 30 then
                  table.insert(tbReferCase, { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
                else
                  table.insert(tbReferCase, { "CheckStatDelta", { szType = "money", nValue = tbAward.varValue } })
                end
              elseif tbAward.szType == "bindmoney" then
                table.insert(tbReferCase, { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
              elseif tbAward.szType == "makepoint" then
                table.insert(tbReferCase, { "CheckStatDelta", { szType = "makepoint", nValue = tbAward.varValue } })
              elseif tbAward.szType == "gatherpoint" then
                table.insert(tbReferCase, { "CheckStatDelta", { szType = "gatherpoint", nValue = tbAward.varValue } })
              elseif tbAward.szType == "item" then
                local tbItemId = tbAward.varValue
                local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
                local nItemNum = tbAward.szAddParam1
                assert(nItemNum >= 0, "奖励物品个数填错了")
                if nItemNum == 0 then
                  nItemNum = 1
                end
                table.insert(tbReferCase, { "CheckItemDelta", { tbItem = tbItem, nValue = nItemNum } })
              elseif tbAward.szType == "customizeitem" then
                local tbItemId = tbAward.varValue
                local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
                table.insert(tbReferCase, { "CheckItemDelta", { tbItem = tbItem, nValue = 1 } })
              elseif tbAward.szType == "title" then
                local tbTitle = tbAward.varValue
              elseif tbAward.szType == "repute" then
                local tbRepute = tbAward.varValue
              elseif tbAward.szType == "taskvalue" then
                local tbTaskValue = tbAward.varValue
              elseif tbAward.szType == "script" then
                local szFnScript = tbAward.varValue
              elseif tbAward.szType == "arrary" then
              elseif tbAward.szType == "KinReputeEntry" then
              else
                for key, value in pairs(tbAward) do
                  print(key, value)
                  if type(value) == "table" then
                    for i, v in pairs(value) do
                      print(i, v)
                    end
                  end
                end
                print(tbStepParams.szSubTaskName)
                assert(false, "Exception Award!")
              end
            end
          end
        elseif #tbAwards.tbOpt ~= 0 then
          --- 领取可选奖励
          local tbAwards = tbAwards.tbOpt
          local nSelectedAward = MathRandom(#tbAwards)

          table.insert(tbReferCase, { "AcceptReward", { bAccept = 1, nSelectedAward = nSelectedAward, nNpcId = nNpcId, szTaskName = szSubTaskName } })

          local tbAward = tbAwards[nSelectedAward]
          if self:ParseConditionTable(tbAward.tbConditions) then
            if tbAward.szType == "exp" then
              table.insert(tbReferCase, { "CheckStatDelta", { szType = "exp", nValue = tbAward.varValue } })
            elseif tbAward.szType == "money" then
              if tbStepParams.nLevel < 30 then
                table.insert(tbReferCase, { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
              else
                table.insert(tbReferCase, { "CheckStatDelta", { szType = "money", nValue = tbAward.varValue } })
              end
            elseif tbAward.szType == "bindmoney" then
              table.insert(tbReferCase, { "CheckStatDelta", { szType = "bindmoney", nValue = tbAward.varValue } })
            elseif tbAward.szType == "makepoint" then
              table.insert(tbReferCase, { "CheckStatDelta", { szType = "makepoint", nValue = tbAward.varValue } })
            elseif tbAward.szType == "gatherpoint" then
              table.insert(tbReferCase, { "CheckStatDelta", { szType = "gatherpoint", nValue = tbAward.varValue } })
            elseif tbAward.szType == "item" then
              local tbItemId = tbAward.varValue
              local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
              local nItemNum = tbAward.szAddParam1
              assert(nItemNum >= 0, "奖励物品个数填错了")
              if nItemNum == 0 then
                nItemNum = 1
              end
              table.insert(tbReferCase, { "CheckItemDelta", { tbItem = tbItem, nValue = nItemNum } })
            elseif tbAward.szType == "customizeitem" then
              local tbItemId = tbAward.varValue
              local tbItem = { tbItemId[1], tbItemId[2], tbItemId[3], tbItemId[4] }
              table.insert(tbReferCase, { "CheckItemDelta", { tbItem = tbItem, nValue = 1 } })
            elseif tbAward.szType == "title" then
              local tbTitle = tbAward.varValue
            elseif tbAward.szType == "repute" then
              local tbRepute = tbAward.varValue
            elseif tbAward.szType == "taskvalue" then
              local tbTaskValue = tbAward.varValue
            elseif tbAward.szType == "script" then
              local szFnScript = tbAward.varValue
            elseif tbAward.szType == "arrary" then
            elseif tbAward.szType == "KinReputeEntry" then
            else
              for key, value in pairs(tbAward) do
                print(key, value)
                if type(value) == "table" then
                  for i, v in pairs(value) do
                    print(i, v)
                  end
                end
              end
              print(tbStepParams.szSubTaskName)
              assert(false, "Exception Award!")
            end
          else
            assert(false, "领取随机奖励失败")
          end
        elseif #tbAwards.tbRand ~= 0 then
          --- 领取随机奖励
          --- TODO: 目前暂时没有随机奖励的设定，暂不做考虑
        else
          print(tbStepParams.szTaskName, tbStepParams.nTaskId, tbStepParams.szSubTaskName, tbStepParams.nSubTaskId)
          print("没有填写任务奖励!")
          --	assert(false,"没有填写任务奖励!");
        end

        --- 领取奖励完后会有黑屏，先要过掉黑屏
        table.insert(tbReferCase, { "TalkClose", {} })

        --- 领取奖励后，如果是询问接受任务，且此时子任务不是最后一个子任务，则接受，否则不接受
        local tbExecute = tbStepParams.tbExecute
        if #tbExecute ~= 0 then
          local nReferIdx = tbStepParams.nReferIdx
          local nSubNum = tbStepParams.nSubNum
          if nReferIdx ~= nSubNum then
            table.insert(tbReferCase, { "AcceptTask", { bAccept = 1 } })
          else
            table.insert(tbReferCase, { "AcceptTask", { bAccept = 0 } })
          end
        end
      end
    end

    --- 执行步骤完成要做的操作
    local tbStepExecute = tbStep.tbExecute
    --		print(tbStepParams.nTaskId, tbStepParams.nSubTaskId, tbStepParams.nStepId);
    tbReferCase, tbAddItems = self:DoExecute(tbStepExecute, tbReferCase, tbAddItems, tbGiveItems, tbStepParams)

    if nStepId == #tbSteps then
      if #tbStartExecute ~= 0 then
        --- 任务结束后要设置任务开启变量(暂时不考虑检测)
        --- table.insert(tbReferCase, {"SaveStat", {}});
      end
      if #tbFailedExecute ~= 0 then
        --- 任务结束后要设置任务失败变量(暂时不考虑检测)
        --- table.insert(tbReferCase, {"SaveStat", {}});
      end
      if #tbFinishExecute ~= 0 then
        --- 任务结束后要设置任务成功变量(暂时不考虑检测)
        --- table.insert(tbReferCase, {"SaveStat", {}});
      end
    end

    -- 如果是最后一步，将不必要的物品清除，保证背包格子充足
    if nStepId == #tbSteps then
      table.insert(tbReferCase, { "ThrowAllItemExceptTaskItem", {} })
    end

    --- 步骤完成后保存一次状态
    table.insert(tbReferCase, { "SaveStat", {} })
  end

  return tbReferCase
end

--- 解析ReferData表信息
function Task.AutoTest:ParseReferData(tbReferData)
  local tbReferCase = {}

  local szSubTaskName = tbReferData.szName
  local szSubTestName = "子任务： " .. szSubTaskName
  local nReferIdx = tbReferData.nReferIdx

  --- nAcceptNpcId和nParticular不会同时有值，即不能物品和Npc都可触发同一个任务
  if tbReferData.nAcceptNpcId and tbReferData.nAcceptNpcId > 0 then
    if nReferIdx == 1 then
      --- 如果读的是第一个子任务，要先去指定NPC处接到主任务
      local nAcceptNpcId = tbReferData.nAcceptNpcId
      table.insert(tbReferCase, szSubTestName)
      table.insert(tbReferCase, { "InitPlayer", {} })
      table.insert(tbReferCase, { "ThrowAllItemExceptTaskItem", {} }) --- 清理背包空间，防止空间不足而接不了任务
      table.insert(tbReferCase, { "SaveStat", {} }) --- 保存角色状态，接任务有可能会改变状态
      table.insert(tbReferCase, { "GotoNpc", { nNpcId = nAcceptNpcId } })
      table.insert(tbReferCase, { "InteractWithNpc", { nNpcId = nAcceptNpcId } })
      table.insert(tbReferCase, { "SaySelectOptionKeyword", { szKeyword = szSubTaskName } })
      table.insert(tbReferCase, { "TalkClose", {} }) --- 如果对话完后有黑屏，直接过掉
      table.insert(tbReferCase, { "AcceptTask", { bAccept = 1 } })
    end
  end
  if tbReferData.nParticular and tbReferData.nParticular > 0 then
    if nReferIdx == 1 then
      --- 如果读的是第一个子任务，要先去指定NPC处接到主任务
      local nParticular = tbReferData.nParticular
      local tbItem = { 20, 1, nParticular, 1 }
      table.insert(tbReferCase, szSubTestName)
      table.insert(tbReferCase, { "InitPlayer", {} })
      table.insert(tbReferCase, { "ThrowAllItemExceptTaskItem", {} }) --- 清理背包空间，防止空间不足而接不了任务
      table.insert(tbReferCase, { "SaveStat", {} }) --- 保存角色状态，接任务有可能会改变状态
      table.insert(tbReferCase, { "GotoNpc", { nNpcId = nParticular } })
      table.insert(tbReferCase, { "InteractWithNpc", { nNpcId = nParticular } })
      table.insert(tbReferCase, { "SaySelectOptionKeyword", { szKeyword = szSubTaskName } })
      table.insert(tbReferCase, { "TalkClose", {} }) --- 如果对话完后有黑屏，直接过掉
      table.insert(tbReferCase, { "AcceptTask", { bAccept = 1 } })
    end
  end

  local tbParams = {}
  tbParams.nReferIdx = nReferIdx
  tbParams.nLevel = tbReferData.nLevel
  tbParams.nBagSpaceCount = tbReferData.nBagSpaceCount
  tbParams.tbAwards = tbReferData.tbAwards
  tbParams.nTaskId = tbReferData.nTaskId
  local tbTaskData = Task.tbTaskDatas[tbParams.nTaskId]
  assert(tbTaskData)
  tbParams.nSubNum = #tbTaskData.tbReferIds
  tbParams.szTaskName = tbTaskData.szName
  tbParams.szSubTaskName = szSubTaskName
  tbParams.tbStepsPath = Task.AutoTest:ParseTaskDesc(tbReferData.tbDesc)

  --- 子任务具体步骤的测试,测试任务奖励也放在这里面
  local nSubTaskId = tbReferData.nSubTaskId
  local tbSubData = Task.tbSubDatas[nSubTaskId]
  if not tbSubData then
    Task:LoadSub(nSubTaskId)
    tbSubData = Task.tbSubDatas[nSubTaskId]
    assert(tbSubData, "LoadSub Failed!")
  end
  tbReferCase = self:ParseSubData(tbSubData, tbReferCase, tbParams)

  return tbReferCase
end

--- 读TaskData表信息
function Task.AutoTest:WriteTaskCase(tbTaskData)
  local szTaskName = tbTaskData.szName
  local szCaseName = szTaskName .. "-测试用例"

  --- 一个主任务的testcase保存在一个TaskCase表中
  local tbTaskCase = {}

  local tbReferIds = tbTaskData.tbReferIds
  for nReferIdx = 1, #tbReferIds do
    local nReferId = tbReferIds[nReferIdx]
    local tbReferData = Task.tbReferDatas[nReferId]
    local tbReferCase = self:ParseReferData(tbReferData)
    tbTaskCase[nReferIdx] = tbReferCase
  end

  return tbTaskCase
end

--- 为每个主任务写测试脚本
function Task.AutoTest:WriteTaskCases()
  if #Task.tbTaskDatas == 0 then
    print("Task Initial failed!")
    assert(false, "Task Initial failed!")
  end

  local tbTaskCases = {} --- 所有的TestCase放在此表中
  local tbTaskDatas = Task.tbTaskDatas
  local nTaskId = 1
  local nCount = 0
  local nTaskCount = 0

  while nTaskId < 301 do
    if nTaskId == 16 and nCount == 0 then
      --- 由于ID为10和11的任务顺序是反的，所以要调整读取任务表的顺序
      nTaskId = 17
      nCount = nCount + 1
    end

    if nTaskId == 52 then
      nTaskId = nTaskId + 2
    end
    if nTaskId == 69 then
      nTaskId = nTaskId + 2
    end
    if nTaskId == 90 then
      nTaskId = nTaskId + 2
    end
    if nTaskId == 187 then
      nTaskId = nTaskId + 1
    end
    if nTaskId == 203 then
      ---门派接引任务、白虎堂、宋金、义军、擂台赛、 中级藏宝图暂时不测试
      nTaskId = nTaskId + 18
    end
    if nTaskId == 224 then
      ---高级藏宝图、军营任务暂时不测试
      nTaskId = nTaskId + 7
    end
    if nTaskId == 268 then
      break
    end

    local tbTaskData = tbTaskDatas[nTaskId]
    if tbTaskData then
      nTaskCount = nTaskCount + 1
      tbTaskCases[nTaskId] = self:WriteTaskCase(tbTaskData)
    end

    if nTaskId == 16 and nCount == 1 then
      nTaskId = nTaskId + 2
    elseif nTaskId == 17 then
      nTaskId = 16
    else
      nTaskId = nTaskId + 1
    end
  end

  print(string.format("成功加载测试案例，一共加载%i个测试案例", nTaskCount))
  return tbTaskCases
end
