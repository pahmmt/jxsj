---client file--------------
if not MODULE_GAMECLIENT then
  return
end
KinRepository.AUTHORITY_ASSISTANT = 4
KinRepository.REPTYPE_FREE = 1
KinRepository.REPTYPE_LIMIT = 2
KinRepository.MAX_ROOM_SIZE = 48 -- 每页空间上限
KinRepository.TAKE_REPOSITOR_AUTHORITY_LAST = 5 * 60 -- 申请成功之后可操作持续时间
KinRepository.FREE_ROOM_SET = {
  Item.ROOM_KIN_REPOSITORY1,
  Item.ROOM_KIN_REPOSITORY2,
  Item.ROOM_KIN_REPOSITORY3,
  Item.ROOM_KIN_REPOSITORY4,
}

KinRepository.LIMIT_ROOM_SET = {
  Item.ROOM_KIN_REPOSITORY5,
  Item.ROOM_KIN_REPOSITORY6,
  Item.ROOM_KIN_REPOSITORY7,
  Item.ROOM_KIN_REPOSITORY8,
}
KinRepository.ROOM_SET = {
  [KinRepository.REPTYPE_FREE] = KinRepository.FREE_ROOM_SET,
  [KinRepository.REPTYPE_LIMIT] = KinRepository.LIMIT_ROOM_SET,
}

local szErrorList = {
  [1] = "位置错误",
  [2] = "家族成员正在使用家族仓库，请等待",
  [3] = "你操作的太快，先等待当前操作完成",
  [4] = "你的仓库数据太旧了，请重新打开",
  [5] = "上一操作超时",
  [6] = "操作位置不一致",
  [7] = "你操作的太频繁，请耐心等待",
  [8] = "对不起，你没有家族",
  [9] = "对不起，你的家族发生了改变",
  [1013] = "绑定和有时限的道具不能存入仓库",
  [1018] = "当前无法存取，请点击[我要存取]按钮申请",
  [2001] = "两次存取需要1秒的间隔",
}

-- 错误提示
function KinRepository:ErrorPrompt(eType)
  if not eType then
    return 0
  end
  if szErrorList[eType] then
    me.Msg(szErrorList[eType])
  end
end

function KinRepository:UpdateRecord_C2(tbRecord, nRoomType, nCurPage, nMaxPage)
  Lib:ShowTB1(tbRecord)
  self.tbViewRecord = tbRecord
  self.nMaxPage = nMaxPage
  self.nCurPage = nCurPage
  self.nIsFree = nIsFree
  Lib:ShowTB1(tbRecord)
  Ui(Ui.UI_KINREPRECORD):Update(tbRecord, nRoomType, nCurPage, nMaxPage)
end

-- 获取权限操作剩余操作时间
function KinRepository:GetRemainTakeAuthority()
  local nTime = me.GetTask(2063, 23)
  local nRemain = nTime + self.TAKE_REPOSITOR_AUTHORITY_LAST - GetTime()
  if nRemain <= 0 then
    return 0
  end
  return nRemain
end

function KinRepository:GetRoomSize(nRoom)
  local nRoomIndex = nRoom - Item.ROOM_KIN_REPOSITORY1 + 1
  if not self.tbRoomInfo or not self.tbRoomInfo[nRoomIndex] then
    return self.MAX_ROOM_SIZE
  end
  return self.tbRoomInfo[nRoomIndex].nRoomSize
end

function KinRepository:UpdateRepInfo_C2(tbRoomInfo, nAuthority, nOpenState)
  self.tbRoomInfo = tbRoomInfo
  self.nAuthority = nAuthority
  self.nOpenState = nOpenState
  Ui(Ui.UI_KINREPOSITORY):UpdatePageState()
end

function KinRepository:UpdateRepOpenState_C2(nOpenState)
  self.nOpenState = nOpenState
  Ui(Ui.UI_KINREPOSITORY):UpdatePageState()
end

function KinRepository:OpenRequest()
  me.CallServerScript({ "KinCmd", "RefreshRepositoryInfo" })
  KKinRepository.OpenRoomRequest(self.LIMIT_ROOM_SET[1])
end
