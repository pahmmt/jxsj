-- Lớp kịch bản Npc

Require("\\script\\npc\\define.lua")

if not Npc.tbClassBase then -- Ngăn chặn việc phá hủy dữ liệu hiện có khi tải lại tệp
  -- Mẫu Npc cơ bản, được định nghĩa chi tiết trong default.lua
  Npc.tbClassBase = {}

  -- Thư viện mẫu Npc
  Npc.tbClass = {
    -- Mẫu mặc định, có thể được sử dụng trực tiếp
    default = Npc.tbClassBase,
    [""] = Npc.tbClassBase,
  }
end

-- Lấy mẫu Npc với tên lớp cụ thể
function Npc:GetClass(szClassName, bNotCreate)
  local tbClass = self.tbClass[szClassName]
  -- Nếu không có bNotCreate, một mẫu mới sẽ được tạo tự động khi không tìm thấy mẫu được chỉ định
  if not tbClass and bNotCreate ~= 1 then
    -- Mẫu mới được kế thừa từ mẫu cơ bản
    tbClass = Lib:NewClass(self.tbClassBase)
    -- Thêm vào thư viện mẫu
    self.tbClass[szClassName] = tbClass
  end
  return tbClass
end

-- Bất kỳ cuộc đối thoại Npc nào, hệ thống sẽ gọi ở đây
function Npc:OnDialog(szClassName, szParam)
  -- Ở đây có thể thêm một số sự kiện đối thoại Npc chung
  --Chế độ khán giả không cho phép đối thoại;
  if Looker:IsLooker(me) > 0 then
    Dialog:Say("Ai????? Sao nghe thấy tiếng mà không thấy người đâu???")
    return 0
  end
  --Chống nghiện game, không được phép đối thoại với bất kỳ npc nào
  if me.GetTiredDegree() == 2 then
    Dialog:Say("Bạn đã online quá 5h, bạn không nhận được bất cứ hiệu quả nào.")
    return 0
  end

  if szClassName == "yijunshouling" then
    SpecialEvent.ActiveGift:AddCounts(me, 9) --Độ sôi nổi đối thoại
  elseif szClassName == "longwutaiye" then
    SpecialEvent.ActiveGift:AddCounts(me, 44) --Độ sôi nổi đối thoại
  end

  local tbOpt = {}
  local nEventFlag = 0
  local nTaskFlag = 0

  if Task:AppendNpcMenu(tbOpt) == 1 then
    nTaskFlag = 1
  end

  local tbNpc = EventManager:GetNpcClass(him.nTemplateId)
  local tbNpcType = EventManager:GetNpcClass(szClassName)

  if tbNpc and EventManager.tbFun:MergeDialog(tbOpt, tbNpc) == 1 then
    nEventFlag = 1
  end

  if tbNpcType and EventManager.tbFun:MergeDialog(tbOpt, tbNpcType) == 1 then
    nEventFlag = 1
  end

  if EventManager.IVER_bOpenTiFu == 1 then
    if him.nTemplateId == 3570 then
      local tbTiFu = Npc:GetClass("tmpnpc_tifu")
      nTaskFlag = 1
      table.insert(tbOpt, 1, { "<color=yellow>Nhận nhân vật trải nghiệm máy chủ thử nghiệm<color>", tbTiFu.OnDialog, tbTiFu })
    end
  end
  local nSpecFlag = 0
  if self.tbSpecDialog[him.nTemplateId] then
    for szMsg, tbSpec in pairs(self.tbSpecDialog[him.nTemplateId]) do
      if tbSpec.check() == 1 then
        nSpecFlag = 1
        table.insert(tbOpt, 1, { szMsg, tbSpec.fun, tbSpec.obj, him })
      end
    end
  end
  local nCeilFlag = 0
  -- Tìm mẫu cụ thể dựa trên szClassName
  local tbClass = self.tbClass[szClassName]
  if tbClass and tbClass.GenTopDialogOpt then
    local tbCeilOpt = tbClass:GenTopDialogOpt() -- Cuộc đối thoại này phải xuất hiện có điều kiện, không được phép đưa vào đối thoại vĩnh viễn
    if tbCeilOpt and #tbCeilOpt > 0 then
      nCeilFlag = 1
      for _, tbTempOpt in ipairs(tbCeilOpt) do
        table.insert(tbOpt, 1, tbTempOpt)
      end
    end
  end

  if nEventFlag == 1 or nTaskFlag == 1 or nSpecFlag == 1 or nCeilFlag == 1 then
    local szMsg = ""
    local szMsg2 = ""
    if nEventFlag == 1 and nTaskFlag == 1 and nSpecFlag == 1 then
      szMsg = string.format("%s: Ngươi đến đúng lúc lắm, ta có vài hoạt động và nhiệm vụ muốn ngươi làm.", him.szName)
      szMsg2 = "Ta không muốn tham gia hoạt động và nhiệm vụ"
    elseif nEventFlag == 1 then
      szMsg = string.format("%s: Ngươi đến đúng lúc lắm, ta có vài hoạt động muốn ngươi làm.", him.szName)
      szMsg2 = "Ta muốn hỏi chuyện khác"
    elseif nTaskFlag == 1 then
      szMsg = string.format("%s: Ngươi đến đúng lúc lắm, ta có vài nhiệm vụ muốn ngươi làm.", him.szName)
      szMsg2 = "Ta không muốn làm nhiệm vụ"
    elseif nSpecFlag == 1 or nCeilFlag == 1 then
      szMsg = string.format("%s: Ngươi đến đúng lúc lắm, ta có vài hoạt động muốn ngươi làm.", him.szName)
      szMsg2 = "Ta muốn hỏi chuyện khác"
    end
    tbOpt[#tbOpt + 1] = { szMsg2, self.OriginalDialog, self, szClassName, him }
    --if nTaskFlag == 1 then
    --	tbOpt[#tbOpt+1]	= {"Kết thúc đối thoại"};
    --end
    Dialog:Say(szMsg, tbOpt)
    return
  end

  Dbg:Output("Npc", "OnDialog", szClassName, tbClass)
  if tbClass then
    -- Gọi hàm đối thoại được chỉ định của mẫu
    tbClass:OnDialog(szParam)
  end
end

-- Đăng ký một nhóm npc chặn đối thoại
function Npc:RegisterSpecDialog(tbNpcGroup, fnSpec, fnCheck, tbSpec, szMsg)
  for _, nNpcId in pairs(tbNpcGroup or {}) do
    if not self.tbSpecDialog[nNpcId] then
      self.tbSpecDialog[nNpcId] = {}
    end
    self.tbSpecDialog[nNpcId][szMsg] = { fun = fnSpec, check = fnCheck, obj = tbSpec }
  end
end

function Npc:OnBubble(szClassName)
  local tbClass = self.tbClass[szClassName]
  if tbClass then
    tbClass:OnTriggerBubble()
  end
end

function Npc:AddBubble(szClassName, nIndex, szMsg) end
-- Đối thoại Npc gốc, dùng cho "Ta không muốn làm nhiệm vụ", sẽ không bị chặn đối thoại
function Npc:OriginalDialog(szClassName, pNpc)
  -- TODO: FanZai	Cần kiểm tra con trỏ Npc
  Setting:SetGlobalObj(nil, pNpc)
  --him	= pNpc;
  self.tbClass[szClassName]:OnDialog()
  Setting:RestoreGlobalObj()
  --him	= nil;
end

-- Bất kỳ Npc nào chết, hệ thống sẽ gọi ở đây
function Npc:OnDeath(szClassName, szParam, ...)
  local pOldHim = him
  -- Tìm mẫu cụ thể dựa trên szClassName
  local tbClass = self.tbClass[szClassName]
  -- TODO:Viết ở đây không tốt, sau này phải sửa!!!
  -- Nếu NPC này đang bị thuyết phục khi chết, xóa trạng thái bị thuyết phục
  if him.GetTempTable("Partner").nPersuadeRefCount then
    him.RemoveTaskState(Partner.nBePersuadeSkillId)
    him.GetTempTable("Partner").nPersuadeRefCount = 0
  end

  -- Ở đây có thể thêm một số sự kiện Npc chết chung
  local tbOnDeath = him.GetTempTable("Npc").tbOnDeath
  Dbg:Output("Npc", "OnDeath", szClassName, tbClass, tbOnDeath)
  if tbOnDeath then
    local tbCall = { unpack(tbOnDeath) }
    Lib:MergeTable(tbCall, arg)
    local bOK, nRet = Lib:CallBack(tbCall) -- Gọi lại
    if not bOK or nRet ~= 1 then
      him.GetTempTable("Npc").tbOnDeath = nil
    end
  end

  -- Chèn gọi lại khi xe chết
  if him.IsCarrier() == 1 then
    Npc.tbCarrier:OnDeath(him.GetCarrierTemplate())
  end

  if tbClass then
    -- Gọi hàm chết được chỉ định của mẫu
    tbClass:OnDeath(unpack(arg))
    -- Chèn hàm xử lý rơi đồ thêm khi chết
    if tbClass.ExternDropOnDeath then
      tbClass:ExternDropOnDeath(unpack(arg))
    end
  end

  --Sự kiện kích hoạt thêm khi npc chết
  Lib:CallBack({ "SpecialEvent.ExtendEvent:DoExecute", "Npc_Death", him, arg[1] })

  if not arg[1] then
    return
  end

  local pNpc = arg[1]
  local nNpcType = him.GetNpcType()
  local pPlayer = pNpc.GetPlayer()
  if not pPlayer then
    return
  end

  if 1 == nNpcType then
    self:AwardXinDe(pPlayer, 100000)
    self:AwardTeamXinDe(pPlayer, 100000)
    self:AddActive(pPlayer, 5) --Độ sôi nổi khi tiêu diệt tinh anh
  elseif 2 == nNpcType then
    self:AwardXinDe(pPlayer, 200000)
    self:AwardTeamXinDe(pPlayer, 200000)
    self:AddActive(pPlayer, 5) --Độ sôi nổi khi tiêu diệt thủ lĩnh
  end

  --Hệ thống hoạt động gọi
  EventManager:NpcDeathApi(szClassName, him, pPlayer, unpack(arg))

  --Độ sôi nổi khi tiêu diệt boss thế giới
  if szClassName == "uniqueboss" then
    self:AddActive(pPlayer, 24)
  end

  -- Hệ thống thành tựu gọi
  --	local nMapIndex = SubWorldID2Idx(him.nMapId);
  --	local nMapTemplateId = SubWorldIdx2MapCopy(nMapIndex);
  Achievement:OnKillNpc(pPlayer, pOldHim.nTemplateId)
  --Dấu hiệu giết quái hàng ngày
  SpecialEvent.tbPJoinEventTimes:OnKillNpc(pPlayer, szClassName)
  --Gọi phần thưởng pet khi giết npc
  Npc.tbFollowPartner:AddAward(pPlayer, "killnpc")
end

function Npc:AddActive(pPlayer, nIndex)
  if not pPlayer or not nIndex then
    return
  end
  if pPlayer.nTeamId > 0 then
    local tbMember = KTeam.GetTeamMemberList(pPlayer.nTeamId)
    if tbMember then
      for i = 1, #tbMember do
        local pPlayer = KPlayer.GetPlayerObjById(tbMember[i])
        if pPlayer then
          SpecialEvent.ActiveGift:AddCounts(pPlayer, nIndex)
        end
      end
    end
  else
    SpecialEvent.ActiveGift:AddCounts(pPlayer, nIndex)
  end
end

function Npc:AwardTeamXinDe(pPlayer, nXinDe)
  if nXinDe <= 0 then
    return
  end

  local nTeamId = pPlayer.nTeamId
  local tbPlayerId, nMemberCount = KTeam.GetTeamMemberList(nTeamId)
  if not tbPlayerId then
    return
  end
  local nNpcMapId, nNpcX, nNpcY = pPlayer.GetWorldPos()
  for i, nPlayerId in pairs(tbPlayerId) do
    local pTPlayer = KPlayer.GetPlayerObjById(nPlayerId)
    if pTPlayer and pTPlayer.nId ~= pPlayer.nId then
      local nPlayerMapId, nPlayerX, nPlayerY = pTPlayer.GetWorldPos()
      if nPlayerMapId == nNpcMapId then
        local nDisSquare = (nNpcX - nPlayerX) ^ 2 + (nNpcY - nPlayerY) ^ 2
        if nDisSquare < 16 * 16 then -- Người chơi trong phạm vi 9 màn hình
          self:AwardXinDe(pTPlayer, nXinDe)
        end
      end
    end
  end
end

function Npc:AwardXinDe(pPlayer, nXinDe)
  if nXinDe <= 0 then
    return
  end
  Setting:SetGlobalObj(pPlayer)
  Task:AddInsight(nXinDe)
  Setting:RestoreGlobalObj()
end

function Npc:OnArrive(szClassName, pNpc)
  --print ("Npc:OnArrive", szClassName, pNpc);
  local tbOnArrive = pNpc.GetTempTable("Npc").tbOnArrive
  Setting:SetGlobalObj(me, pNpc, it)
  if tbOnArrive then
    Lib:CallBack(tbOnArrive)
  end
  Setting:RestoreGlobalObj()
end

-- Khi Npc giảm máu đến đây sẽ kích hoạt
function Npc:OnLifePercentReduceHere(szClassName, pNpc, nPercent)
  Setting:SetGlobalObj(me, pNpc, it)
  local tbOnLifePercentReduce = him.GetTempTable("Npc").tbOnLifePercentReduce
  if tbOnLifePercentReduce and tbOnLifePercentReduce[nPercent] then
    local tbCall = { unpack(tbOnLifePercentReduce[nPercent]) }
    Lib:MergeTable(tbCall, { nPercent })
    local bOK, nRet = Lib:CallBack(tbCall) -- Gọi lại
    if not bOK or nRet ~= 1 then
      him.GetTempTable("Npc").tbOnLifePercentReduce[nPercent] = nil
    end
  end
  Setting:RestoreGlobalObj()
  local tbClass = self.tbClass[szClassName]
  if not tbClass then
    Dbg:WriteLogEx(Dbg.LOG_ERROR, "Npc", string.format("Npc[%s] không tìm thấy！", szClassName))
    return 0
  end

  Setting:SetGlobalObj(me, pNpc, it)
  if tbClass.OnLifePercentReduceHere then
    tbClass:OnLifePercentReduceHere(nPercent)
  end
  --Đặc biệt: gọi lại đăng ký máu npc Tiêu Dao Cốc, by Egg
  local tbXoyoPercent = him.GetTempTable("XoyoGame").tbPercentInfo
  local szXoyoGroup = him.GetTempTable("XoyoGame").szGroup
  local tbRoom = him.GetTempTable("XoyoGame").tbRoom
  if szXoyoGroup and tbXoyoPercent and tbRoom then
    for _, tbInfo in pairs(tbXoyoPercent) do
      if tbInfo[1] == nPercent then
        tbRoom:OnNpcBloodPercent(szXoyoGroup, nPercent, tbInfo[2], unpack(tbInfo, 3))
      end
    end
  end
  Setting:RestoreGlobalObj()
end

--Thiết lập AI đi lại ngẫu nhiên cho npc
--nMapId		:Id bản đồ
--nX			:Tọa độ X 32-bit
--nY			:Tọa độ Y 32-bit
--nAINpcId	:Id npc đi lại ngẫu nhiên (npc chiến đấu có AI)
--nChatSec		:Bao nhiêu giây lặp lại một lần, (0 hoặc nil là 5) (thời gian tồn tại của AInpc được quyết định bởi nChatSec*nChatCount)
--nChatCount	:Tổng cộng lặp lại bao nhiêu lần, (0 hoặc nil là 1)
--nMaxSec		:Tổng thời gian tồn tại (bao gồm cả AInpc và npc đối thoại (giây), 0 là vô hạn)
--nRange		:Phạm vi ngẫu nhiên mỗi lần của npc (32-bit, phạm vi ngẫu nhiên, (0 hoặc nil là 1000))
--nDialogNpcId	:Id của npc đối thoại được chuyển đổi (0 là không có chuyển đổi npc đối thoại, sẽ luôn là AInpc)
--nDialogSec	:Thời gian tồn tại của npc đối thoại (giây) (0 hoặc nil là 10 giây)
--tbChat		:Nội dung nói chuyện của npc (nội dung nói chuyện trong quá trình AInpc đi lại, ngẫu nhiên trong bảng)
--example		:local nMapId,nX,nY = me.GetWorldPos(); Npc:OnSetFreeAI(nMapId, nX*32, nY*32, 598, 0, 0, 0, 0, 2964, 0, {"Haizzz～～～"});
function Npc:OnSetFreeAI(nMapId, nX, nY, nAINpcId, nChatSec, nChatCount, nMaxSec, nRange, nDialogNpcId, nDialogSec, tbChat)
  --Giá trị mặc định;
  nChatSec = ((nChatSec == 0 or not nChatSec) and 5) or nChatSec
  nChatCount = ((nChatCount == 0 or not nChatCount) and 1) or nChatCount
  nRange = ((nRange == 0 or not nRange) and 1000) or nRange
  nDialogSec = ((nDialogSec == 0 or not nDialogSec) and 10) or nDialogSec

  local pNpc = KNpc.Add(nAINpcId, 100, -1, SubWorldID2Idx(nMapId), nX, nY)
  if pNpc then
    local tbRX = { math.floor(MathRandom(-nRange, -math.floor(nRange * 0.6))), math.floor(MathRandom(math.floor(nRange * 0.6), nRange)) }
    local tbRY = { math.floor(MathRandom(-nRange, -math.floor(nRange * 0.6))), math.floor(MathRandom(math.floor(nRange * 0.6), nRange)) }
    local nTrX = tbRX[math.floor(MathRandom(1, 2))] or 0
    local nTrY = tbRY[math.floor(MathRandom(1, 2))] or 0
    local nMovX = nX + nTrX
    local nMovY = nY + nTrY
    pNpc.AI_AddMovePos(nMovX, nMovY)
    pNpc.SetNpcAI(9, 0, 1, -1, 0, 0, 0, 0, 0, 0, 0)
    pNpc.GetTempTable("Npc").tbNpcFreeAI = {}
    pNpc.GetTempTable("Npc").tbNpcFreeAI.nCalcChatCount = 0
    pNpc.GetTempTable("Npc").tbNpcFreeAI.nChatCount = nChatCount
    pNpc.GetTempTable("Npc").tbNpcFreeAI.nMaxSec = nMaxSec
    pNpc.GetTempTable("Npc").tbNpcFreeAI.nAINpcId = nAINpcId
    pNpc.GetTempTable("Npc").tbNpcFreeAI.nChatSec = nChatSec
    pNpc.GetTempTable("Npc").tbNpcFreeAI.nRange = nRange
    pNpc.GetTempTable("Npc").tbNpcFreeAI.nDialogNpcId = nDialogNpcId
    pNpc.GetTempTable("Npc").tbNpcFreeAI.nDialogSec = nDialogSec
    pNpc.GetTempTable("Npc").tbNpcFreeAI.tbChat = tbChat
    local nTimerId = Timer:Register(nChatSec * Env.GAME_FPS, self.OnTimerFreeAI, self, pNpc.dwId, 1)
    self._tbDebugFreeAITimer = self._tbDebugFreeAITimer or {}
    self._tbDebugFreeAITimer2 = self._tbDebugFreeAITimer2 or {}
    self._tbDebugFreeAITimer[nTimerId] = pNpc.dwId
    self._tbDebugFreeAITimer2[pNpc.dwId] = nTimerId
    Npc.tbFreeAINpcList = Npc.tbFreeAINpcList or {}
    Npc.tbFreeAINpcList[pNpc.dwId] = 1
  end
  return 0
end

function Npc:OnTimerFreeAI(nNpcId, nNpcType)
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    local nTimerId = self._tbDebugFreeAITimer2[nNpcId]
    if nTimerId then
      self._tbDebugFreeAITimer[nTimerId] = nil
    end
    self._tbDebugFreeAITimer2[nNpcId] = nil
    return 0
  end

  local nCalcChatCount = pNpc.GetTempTable("Npc").tbNpcFreeAI.nCalcChatCount
  local nChatCount = pNpc.GetTempTable("Npc").tbNpcFreeAI.nChatCount
  local nMaxSec = pNpc.GetTempTable("Npc").tbNpcFreeAI.nMaxSec
  local nAINpcId = pNpc.GetTempTable("Npc").tbNpcFreeAI.nAINpcId
  local nChatSec = pNpc.GetTempTable("Npc").tbNpcFreeAI.nChatSec
  local nRange = pNpc.GetTempTable("Npc").tbNpcFreeAI.nRange
  local nDialogNpcId = pNpc.GetTempTable("Npc").tbNpcFreeAI.nDialogNpcId
  local nDialogSec = pNpc.GetTempTable("Npc").tbNpcFreeAI.nDialogSec
  local tbChat = pNpc.GetTempTable("Npc").tbNpcFreeAI.tbChat
  local nMapId = pNpc.nMapId
  local nX, nY = pNpc.GetMpsPos()
  local tbSec = { [1] = nChatSec, [2] = nDialogSec }

  if nMaxSec > 0 then
    nMaxSec = nMaxSec - tbSec[nNpcType]
    if nMaxSec == 0 then
      nMaxSec = -1
    end
  end

  if nMaxSec < 0 then
    Npc.tbFreeAINpcList[pNpc.dwId] = nil

    ---Gỡ lỗi
    local nTimerId = self._tbDebugFreeAITimer2[pNpc.dwId]
    self._tbDebugFreeAITimer[nTimerId] = nil
    self._tbDebugFreeAITimer2[pNpc.dwId] = nil
    ---

    pNpc.Delete()
    return 0
  end

  if nNpcType == 2 then
    Npc.tbFreeAINpcList[pNpc.dwId] = nil

    ---Gỡ lỗi
    local nTimerId = self._tbDebugFreeAITimer2[pNpc.dwId]
    self._tbDebugFreeAITimer[nTimerId] = nil
    self._tbDebugFreeAITimer2[pNpc.dwId] = nil
    ---

    pNpc.Delete()
    self:OnSetFreeAI(nMapId, nX, nY, nAINpcId, nChatSec, nChatCount, nMaxSec, nRange, nDialogNpcId, nDialogSec, tbChat)
    return 0
  end

  pNpc.GetTempTable("Npc").tbNpcFreeAI.nMaxSec = nMaxSec
  if not nDialogNpcId or nDialogNpcId == 0 or nCalcChatCount < nChatCount then
    if nDialogNpcId > 0 then
      pNpc.GetTempTable("Npc").tbNpcFreeAI.nCalcChatCount = pNpc.GetTempTable("Npc").tbNpcFreeAI.nCalcChatCount + 1
    end
    if type(tbChat) == "table" and #tbChat > 0 then
      local szChar = tbChat[math.floor(MathRandom(1, #tbChat))] or ""
      pNpc.SendChat(szChar)
    end
    return
  end

  Npc.tbFreeAINpcList[pNpc.dwId] = nil
  ---Gỡ lỗi
  local nTimerId = self._tbDebugFreeAITimer2[pNpc.dwId]
  self._tbDebugFreeAITimer[nTimerId] = nil
  self._tbDebugFreeAITimer2[pNpc.dwId] = nil
  ---

  pNpc.Delete()

  local pNpcDialog = KNpc.Add(nDialogNpcId, 100, -1, SubWorldID2Idx(nMapId), nX, nY)
  if pNpcDialog then
    pNpcDialog.GetTempTable("Npc").tbNpcFreeAI = {}
    pNpcDialog.GetTempTable("Npc").tbNpcFreeAI.nChatCount = nChatCount
    pNpcDialog.GetTempTable("Npc").tbNpcFreeAI.nMaxSec = nMaxSec
    pNpcDialog.GetTempTable("Npc").tbNpcFreeAI.nAINpcId = nAINpcId
    pNpcDialog.GetTempTable("Npc").tbNpcFreeAI.nChatSec = nChatSec
    pNpcDialog.GetTempTable("Npc").tbNpcFreeAI.nRange = nRange
    pNpcDialog.GetTempTable("Npc").tbNpcFreeAI.nDialogNpcId = nDialogNpcId
    pNpcDialog.GetTempTable("Npc").tbNpcFreeAI.nDialogSec = nDialogSec
    pNpcDialog.GetTempTable("Npc").tbNpcFreeAI.tbChat = tbChat
    local nTimerId = Timer:Register(nDialogSec * Env.GAME_FPS, self.OnTimerFreeAI, self, pNpcDialog.dwId, 2)

    --Gỡ lỗi
    self._tbDebugFreeAITimer[nTimerId] = pNpcDialog.dwId
    self._tbDebugFreeAITimer2[pNpcDialog.dwId] = nTimerId
    --Gỡ lỗi

    Npc.tbFreeAINpcList[pNpcDialog.dwId] = 1
  end
  return 0
end

--Xóa AINpc hoặc DialogNpc ngẫu nhiên;
--nNpcId：	Xóa id mẫu của npc, nếu có npc đối thoại, cần xóa cả AINpc và Npc đối thoại, nếu không điền id mẫu npc mặc định sẽ xóa tất cả AINpc và Npc đối thoại;
function Npc:OnClearFreeAINpc(nNpcId)
  if Npc.tbFreeAINpcList then
    for dwId in pairs(Npc.tbFreeAINpcList) do
      local pNpc = KNpc.GetById(dwId)
      if pNpc then
        if not nNpcId then
          pNpc.Delete()
        end

        if nNpcId and pNpc.nTemplateId == nNpcId then
          pNpc.Delete()
        end
      end
    end
  end
  return 0
end

-- Lấy dữ liệu cấp độ
--	tbParam:{szAIParam, szSkillParam, szPropParam, szScriptParam}
function Npc:GetLevelData(szClassName, szKey, nSeries, nLevel, tbParam)
  -- Tìm mẫu cụ thể dựa trên szClassName
  local tbClass = self.tbClass[szClassName]
  if not tbClass then
    Dbg:WriteLogEx(Dbg.LOG_ERROR, "Npc", string.format("Npc[%s] không tìm thấy！", szClassName))
    return 0
  end

  -- Thử tìm trực tiếp định nghĩa thuộc tính trong lớp này
  local tbData = nil

  if szClassName == "" then
    tbClass = { _tbBase = tbClass }
  end

  local tbBaseClasses = {
    rawget(tbClass, "tbLevelData"),
    self.tbAIBase[tbParam[1]],
    self.tbSkillBase[tbParam[2]],
    self.tbPropBase[tbParam[3]],
    tbClass._tbBase and tbClass._tbBase.tbLevelData,
  }
  for i = 1, 5 do
    local tbBase = tbBaseClasses[i]
    tbData = tbBase and tbBase[szKey]
    if tbData then
      break
    end
  end
  if not tbData then
    Dbg:WriteLogEx(Dbg.LOG_ERROR, "Npc", string.format("Npc[%s]:[%s] không tìm thấy！", szClassName, szKey))
    return 0
  end
  if type(tbData) == "function" then
    return tbData(nSeries, nLevel, tbParam[4])
  else
    return Lib.Calc:Link(nLevel, tbData)
  end
end

-- Đăng ký gọi lại theo tỷ lệ phần trăm máu cụ thể
function Npc:RegPNpcLifePercentReduce(pNpc, nPercent, ...)
  local tbPNpcData = pNpc.GetTempTable("Npc")
  tbPNpcData.tbOnLifePercentReduce = tbPNpcData.tbOnLifePercentReduce or {}
  assert(not tbPNpcData.tbOnLifePercentReduce[nPercent], "quá nhiều OnLifePercentReduce đăng ký trên npc:" .. pNpc.szName)
  pNpc.AddLifePObserver(nPercent)
  tbPNpcData.tbOnLifePercentReduce[nPercent] = arg
end

-- Hủy đăng ký gọi lại theo tỷ lệ phần trăm máu cụ thể
function Npc:UnRegPNpcLifePercentReduce(pNpc, nPercent)
  if pNpc.GetTempTable("Npc").tbOnLifePercentReduce and pNpc.GetTempTable("Npc").tbOnLifePercentReduce[nPercent] then
    pNpc.GetTempTable("Npc").tbOnLifePercentReduce[nPercent] = nil
  end
end

-- Đăng ký gọi lại khi Npc cụ thể chết
function Npc:RegPNpcOnDeath(pNpc, ...)
  local tbPNpcData = pNpc.GetTempTable("Npc")
  assert(not tbPNpcData.tbOnDeath, "quá nhiều OnDeath đăng ký trên npc:" .. pNpc.szName)
  tbPNpcData.tbOnDeath = arg
end

-- Hủy đăng ký gọi lại khi Npc cụ thể chết
function Npc:UnRegPNpcOnDeath(pNpc)
  pNpc.GetTempTable("Npc").tbOnDeath = nil
end

-- Gọi lại khi Npc chết và rơi vật phẩm
function Npc:DeathLoseItem(szDropFile, szClassName, pNpc, tbLoseItem)
  if szDropFile and szDropFile ~= "" then
    self:LoseItem_XuanJingLog(szDropFile, pNpc, tbLoseItem)
  end

  local tbDeathLoseItem = pNpc.GetTempTable("Npc").tbDeathLoseItem
  if tbDeathLoseItem then
    local tbCall = { unpack(tbDeathLoseItem) }
    Lib:MergeTable(tbCall, { pNpc, tbLoseItem })
    local bOK, nRet = Lib:CallBack(tbCall) -- Gọi lại
    if not bOK or nRet ~= 1 then
      pNpc.GetTempTable("Npc").tbDeathLoseItem = nil
    end
  end
  --	if (not tbClass) then
  --		Dbg:WriteLogEx(Dbg.LOG_ERROR, "Npc", string.format("Npc[%s] không tìm thấy！", szClassName));
  --		return 0;
  --	end;
  local tbClass = self.tbClass[szClassName]
  if tbClass then
    Setting:SetGlobalObj(me, pNpc, it)
    if tbClass.DeathLoseItem then
      tbClass:DeathLoseItem(tbLoseItem)
    end
    Setting:RestoreGlobalObj()
  end
end

function Npc:RegDeathLoseItem(pNpc, ...)
  local tbPNpcData = pNpc.GetTempTable("Npc")
  assert(not tbPNpcData.tbDeathLoseItem, "quá nhiều DeathLoseItem đăng ký trên npc:" .. pNpc.szName)
  tbPNpcData.tbDeathLoseItem = arg
end

function Npc:UnRegDeathLoseItem(pNpc)
  pNpc.GetTempTable("Npc").tbDeathLoseItem = nil
end

function Npc:LoseItem_XuanJingLog(szDropFile, pNpc, tbLoseItem)
  if not szDropFile or szDropFile == "" then
    return
  end
  local tbSystemMsgItem = {
    ["18,1,1276,1"] = 1, --Rương Mã Bài Bôn Tiêu
    ["1,12,33,4"] = 1, --Phiên Vũ
    ["18,1,1282,1"] = 1, --Hổ Phách Thiên Tinh Phù (Kim)
    ["18,1,1282,2"] = 1, --Hổ Phách Thiên Tinh Phù (Mộc)
    ["18,1,1282,3"] = 1, --Hổ Phách Thiên Tinh Phù (Thủy)
    ["18,1,1282,4"] = 1, --Hổ Phách Thiên Tinh Phù (Hỏa)
    ["18,1,1282,5"] = 1, --Hổ Phách Thiên Tinh Phù (Thổ)
    ["2,7,503,10"] = 1, --Bá Vương Phá Trận Ngoa (Kim)
    ["2,7,504,10"] = 1, --Huyền Nữ Vũ Ảnh Hài (Kim)
    ["2,7,505,10"] = 1, --Bá Vương Phá Trận Ngoa (Mộc)
    ["2,7,506,10"] = 1, --Huyền Nữ Vũ Ảnh Hài (Mộc)
    ["2,7,507,10"] = 1, --Bá Vương Phá Trận Ngoa (Thủy)
    ["2,7,508,10"] = 1, --Huyền Nữ Vũ Ảnh Hài (Thủy)
    ["2,7,509,10"] = 1, --Bá Vương Phá Trận Ngoa (Hỏa)
    ["2,7,510,10"] = 1, --Huyền Nữ Vũ Ảnh Hài (Hỏa)
    ["2,7,511,10"] = 1, --Bá Vương Phá Trận Ngoa (Thổ)
    ["2,7,512,10"] = 1, --Huyền Nữ Vũ Ảnh Hài (Thổ)
    ["18,1,541,4"] = 1, --Xuyên Châu Ngân Thiếp (cấp 2)
    ["18,1,1,10"] = 1, --Huyền Tinh cấp 10
  }

  local szStoneLogInfo
  for _, nItemId in pairs(tbLoseItem.Item or {}) do
    local pItem = KItem.GetObjById(nItemId)
    if pItem and pItem.szClass == "xuanjing" then
      local nBind, nUnBind = 0, 0
      if pItem.IsBind() == 1 or KItem.IsItemBindByBindType(pItem.nBindType) == 1 then
        nBind = nBind + pItem.nCount
      else
        nUnBind = nUnBind + pItem.nCount
      end

      Item:InsertXJRecordMemory(Item.emITEM_XJRECORD_DROPRATE, szDropFile, pItem.nLevel, nBind, nUnBind)
    end

    --Thông báo hệ thống khi rơi đồ (vn tạm thời thêm vào đây, cân nhắc thêm vào bảng rơi đồ như một mục nếu có nhu cầu)
    if pItem then
      local szItem = string.format("%s,%s,%s,%s", pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel)
      if tbSystemMsgItem[szItem] then
        KDialog.NewsMsg(1, Env.NEWSMSG_NORMAL, string.format("【%s】 bị tiêu diệt, trước khi chết đã để lại một vật rất quý giá 【%s】", pNpc.szName, pItem.szName))
      end
    end

    --		if pItem and Item.tbStone.tbStoneLogItem[pItem.SzGDPL()] then
    --			szStoneLogInfo = szStoneLogInfo or "";
    --			szStoneLogInfo = szStoneLogInfo..string.format("%d_%d_%d_%d,", pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel)
    --		end
  end

  --	if szStoneLogInfo then
  --		szStoneLogInfo =szStoneLogInfo..string.format("%d,%d", pNpc.nMapId, pNpc.nTemplateId);
  --		-- Điểm dữ liệu todo zjq log ở đây có thể bỏ đi
  --		StatLog:WriteStatLog("stat_info", "baoshixiangqian", "drop", 0, szStoneLogInfo);
  --	end
end

function Npc:OnFollowPartnerTalk(nNpcId)
  Npc.tbFollowPartner:OnFollowPartnerTalk(nNpcId)
end

function Npc:OnFollowPartnerSkill(nNpcId)
  Npc.tbFollowPartner:OnFollowPartnerSkill(nNpcId)
end

if MODULE_GAMESERVER then
  function Npc:LoadDropFileRecordList()
    local tbFile = Lib:LoadTabFile(self.DROPFILE_RECORD_LIST)
    if not tbFile then
      print("tải " .. self.DROPFILE_RECORD_LIST .. " thất bại!")
      return
    end

    local tb = {}
    for _, tbData in pairs(tbFile) do
      local tbTemp = {}
      tbTemp.szDropFile = tbData.DropFile
      tbTemp.ID = assert(tonumber(tbData.ID))

      table.insert(tb, tbTemp)
    end

    KNpc.InitDropFileRecordList(tb)
  end

  Npc:LoadDropFileRecordList()
  Npc.tbSpecDialog = Npc.tbSpecDialog or {}
end
