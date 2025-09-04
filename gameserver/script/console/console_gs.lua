-- Tên tệp　：console_gs.lua
-- Người tạo　：sunduoliang
-- Thời gian tạo：2009-04-23 10:04:41
-- Mô tả  ：--Bảng điều khiển

if MODULE_GC_SERVER then
  return 0
end

--Báo danh vào sân
function Console:ApplySignUp(nDegree, tbPlayerIdList)
  GCExcute({ "Console:ApplySignUp", nDegree, tbPlayerIdList })
end

function Console:StartSignUp(nDegree)
  self:GetBase(nDegree):StartSignUp()
end

function Console:OnStartMission(nDegree)
  self:GetBase(nDegree):OnStartMission()
  return 0
end

function Console:SignUpFail(tbPlayerList)
  for _, nPlayerId in pairs(tbPlayerList) do
    local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
    if pPlayer then
      pPlayer.Msg("Số lượng người tham gia hoạt động đã đủ.")
      Dialog:SendBlackBoardMsg(pPlayer, "Số lượng người tham gia hoạt động đã đủ")
      return 0
    end
  end
end

function Console:SignUpSucess(nDegree, nReadyMapId, tbPlayerList)
  local tbBase = self:GetBase(nDegree)
  for _, nPlayerId in pairs(tbPlayerList) do
    local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
    if pPlayer then
      if tbBase:IsOpen() == 0 then
        pPlayer.Msg("Đường đi phía trước không thuận lợi, không thể đến bản đồ hoạt động, vui lòng tham gia lần sau.")
      else
        pPlayer.NewWorld(nReadyMapId, unpack(tbBase.tbCfg.tbMap[nReadyMapId].tbInPos))
        tbBase:OnSingUpSucess(nPlayerId)
      end
    end
  end
end

function Console:OnDyJoin(nDegree, me, nDyId, tbPos, GroupId)
  local tbBase = self:GetBase(nDegree)
  tbBase:OnDyJoin(me, nDyId, tbPos, GroupId)
end

--Yêu cầu phụ bản
function Console:ApplyDyMap(nDegree, nMapId)
  local tbBase = self:GetBase(nDegree)
  local nDyCount = tbBase.tbCfg.nMaxDynamic
  local nDynamicMap = tbBase.tbCfg.nDynamicMap
  local nCurCount = #tbBase.tbDynMapLists[nMapId]
  if nCurCount < nDyCount then
    for i = 1, (nDyCount - nCurCount) do
      if Map:LoadDynMap(1, nDynamicMap, { self.OnLoadMapFinish, self, nDegree, nMapId }) ~= 1 then
        print("Tải bản đồ phụ bản hoạt động thất bại..", nDegree, nMapId)
      end
    end
  end
  return 0
end

--Tải động bản đồ thi đấu thành công
function Console:OnLoadMapFinish(nDegree, nMapId, nDyMapId)
  local tbBase = self:GetBase(nDegree)
  tbBase.tbDynMapLists[nMapId] = tbBase.tbDynMapLists[nMapId] or {}
  table.insert(tbBase.tbDynMapLists[nMapId], nDyMapId)
end
