--Tên file		：	selectandnewrole.lua
--Người tạo		：	dịch từ selectandnewrole.lua gốc tiếng Trung
--Thời gian tạo	：	2025-09-03
--Mô tả chức năng：	Giao diện chọn và tạo nhân vật (Bản dịch tiếng Việt)
------------------------------------------------------

local tbSelAndNewRole = Ui:GetClass("selectandnewrole")
local tbLogin = Ui.tbLogic.tbLogin or {}

-- Chọn nhân vật
tbSelAndNewRole.BTN_SEL_OK = "Sel_Ok"
tbSelAndNewRole.BTN_SEL_CANCEL = "Sel_Cancel"
tbSelAndNewRole.BTN_NEW = "New"
tbSelAndNewRole.BTN_SELSVR = "BtnSelSvr"
tbSelAndNewRole.TXT_CURSVR = "TxtCurSvr"
tbSelAndNewRole.FLASH = "Flash"
tbSelAndNewRole.SEL_UI = "Sel_Ui"
tbSelAndNewRole.NEW_UI = "New_Ui"
tbSelAndNewRole.BTN_PKPROMPT = "BtnPKPrompt"

tbSelAndNewRole.MODE_NONE = 0
tbSelAndNewRole.MODE_SELECT_ROLE = 1
tbSelAndNewRole.MODE_NEW_ROLE = 2

-- Tạo nhân vật
tbSelAndNewRole.BTN_NEW_OK = "New_Ok"
tbSelAndNewRole.BTN_NEW_CANCEL = "New_Cancel"
tbSelAndNewRole.EDIT_NAME = "Name"
tbSelAndNewRole.BTN_RANDOM = "btn_random_name"

tbSelAndNewRole.tbNewHome = {
  "Linh Tú Thôn (Tuyến 1)",
  "Linh Tú Thôn (Tuyến 2)",
  "Linh Tú Thôn (Tuyến 3)",
  "Linh Tú Thôn (Tuyến 4)",
  "Linh Tú Thôn (Tuyến 5)",
  "Linh Tú Thôn (Tuyến 6)",
  "Linh Tú Thôn (Tuyến 7)",
}

tbSelAndNewRole.tbNewHomeEx = {
  [1] = 2115,
  [2] = 2116,
  [3] = 2117,
  [4] = 2118,
  [5] = 2119,
  [6] = 2120,
  [7] = 2121,
}

local tbTimer = Ui.tbLogic.tbTimer
local TIMER_TICK = 1 -- Bộ đếm thời gian

function tbSelAndNewRole:Init() end

function tbSelAndNewRole:OnOpen()
  -- Đóng giao diện độc quyền: tạo nhân vật mới
  Flash_LoadMovie(self.UIGROUP, self.FLASH)
  self.nTimerId = 0
  self.nSex = nil
  self.nMapId = 0
  self.tbVillageList = {}
  self.nMode = self.MODE_NONE

  self:ChangeUi(self.MODE_SELECT_ROLE)
  KMath.SetRandSeed(GetTime())
  self.bReSel = false
  Btn_Check(self.UIGROUP, self.BTN_PKPROMPT, 1)
end

function tbSelAndNewRole:OnClose()
  if self.nTimerId > 0 then
    tbTimer:Close(self.nTimerId)
    self.nTimerId = 0
  end
  Flash_ReleaseMovie(self.UIGROUP, self.FLASH)
end

function tbSelAndNewRole:OnEnterExclusiveWnd(szWndName)
  self:OnConfirmSel()
end

-- Xử lý sự kiện nhấn nút
function tbSelAndNewRole:OnButtonClick(szWndName, nParam)
  -- Chức năng chọn nhân vật
  if szWndName == self.BTN_SEL_OK then
    self:OnConfirmSel()
  elseif szWndName == self.BTN_SEL_CANCEL then
    UiManager:CloseWindow(self.UIGROUP)
    tbLogin:CancelConnectBishop()
  elseif szWndName == self.BTN_NEW then
    SetLoginStatus(tbLogin.emLOGINSTATUS_OPT_CREATEROLE)
    self:ChangeUi(self.MODE_NEW_ROLE)
  elseif szWndName == self.BTN_SELSVR then
    UiManager:OpenWindow(Ui.UI_SELECT_SERVER, 2)
    return
  elseif szWndName == self.BTN_PKPROMPT then
    if nParam == 0 then
      Btn_Check(self.UIGROUP, self.BTN_PKPROMPT, 0)
      Wnd_SetEnable(self.UIGROUP, self.BTN_SEL_OK, 0)
      Wnd_SetEnable(self.UIGROUP, self.BTN_NEW, 0)
    else
      Btn_Check(self.UIGROUP, self.BTN_PKPROMPT, 1)
      Wnd_SetEnable(self.UIGROUP, self.BTN_SEL_OK, 1)
      Wnd_SetEnable(self.UIGROUP, self.BTN_NEW, 1)
    end
  -- Chức năng tạo nhân vật
  elseif szWndName == self.BTN_NEW_OK then
    local szName = Edt_GetTxt(self.UIGROUP, self.EDIT_NAME)
    -- Ánh xạ tạm thời
    local tbMsg = {}
    if szName == "" then
      tbMsg.szMsg = "Vui lòng nhập tên nhân vật trước!"
      UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
      return
    end

    local tbVillage = self.tbVillageList[self.nMapId]
    -- Vượt quá giới hạn
    if not tbVillage or tbVillage.nState == 3 then -- Chọn làng tân thủ đã đầy
      tbMsg.szMsg = "Tân Thủ Thôn bạn chọn đã đầy..."
      UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
      return
    end

    local nResult = CreateRole(szName, self.nSex, self.tbVillageList[self.nMapId].nMapId)
    if nResult == 1 then
      UiManager:CloseWindow(self.UIGROUP)
    elseif nResult == -1 then
      tbMsg.szMsg = "Tên nhân vật phải từ 6–16 ký tự, gồm chữ hoặc số!"
      UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
    elseif nResult == -2 then
      tbMsg.szMsg = "Tên nhân vật chỉ gồm chữ không dấu và số!"
      UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
    else
      tbMsg.szMsg = "Lỗi không xác định"
      UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
    end
  elseif szWndName == self.BTN_NEW_CANCEL then -- Quay lại chọn nhân vật
    local nRole, _ = GetRoleList()
    local nZoneRole, _ = GetZoneRoleList()

    if nRole + nZoneRole == 0 then -- Đặc biệt, khi không có nhân vật nào, quay về giao diện đăng nhập
      UiManager:CloseWindow(self.UIGROUP)
      tbLogin:CancelConnectBishop()
    else
      SetLoginStatus(tbLogin.emLOGINSTATUS_SELROLE)
      self:ChangeUi(self.MODE_SELECT_ROLE)
    end
  elseif szWndName == self.BTN_NEW then
  elseif szWndName == self.BTN_RANDOM then
    local szRandomName = self:GetRandomName()
    Edt_SetTxt(self.UIGROUP, self.EDIT_NAME, szRandomName)
  end
end

--------------------------------------------- Chức năng chọn nhân vật --------------------------------
-- Sắp xếp danh sách nhân vật
function tbSelAndNewRole.CompareRole(tbRole1, tbRole2)
  if tbRole1.Level <= tbRole2.Level then
    return false
  else
    return true
  end
end

-- Cập nhật thông tin nhân vật và giao diện
function tbSelAndNewRole:UpdateRoleInfo()
  local nRole, tbRole = GetRoleList()
  local nZoneRole, tbZoneRole = GetZoneRoleList()
  self.nRoleCount = nRole -- Số lượng nhân vật
  self.nZoneRoleCount = nZoneRole -- Số lượng nhân vật khu vực

  table.sort(tbRole, self.CompareRole) -- Sắp xếp nhân vật theo cấp độ

  local szRoleListInfo = ""

  local tbSexName = { [0] = "Nam", [1] = "Nữ", [2] = "Không rõ" }
  local nSelIndex = 0
  for i = 1, nRole do
    if GetLastSelRoleName() == tbRole[i].Name then
      nSelIndex = i - 1
      self.szCurRoleName = tbRole[i].Name
    end
    local nFaction = tbRole[i].Faction -- Điều chỉnh offset
    szRoleListInfo = szRoleListInfo .. string.format("%s,%s cấp,%s,%s,%s,%s;", tbRole[i].Name, tbRole[i].Level, tbRole[i].Sex, nFaction, GetLastSvrTitle(), 1)
  end
  for i = 1, nZoneRole do
    if GetLastSelRoleName() == tbZoneRole[i].Name then
      nSelIndex = nRole + i - 1
      self.szCurRoleName = tbZoneRole[i].Name
    end
    if tbZoneRole[i].Server == "" then
      szRoleListInfo = szRoleListInfo .. string.format("%s,%s,%s,%s,%s,%s;", tbZoneRole[i].Name, "", 0, 0, "", 0)
    else
      szRoleListInfo = szRoleListInfo .. string.format("%s,%s,%s,%s,%s,%s;", tbZoneRole[i].Name, "", 0, 0, tbZoneRole[i].Server, 0)
    end
  end
  if self.szCurRoleName == "" then -- Lần trước chưa chọn nhân vật, chọn nhân vật đầu tiên
    if nRole > 0 then
      self.szCurRoleName = tbRole[1].Name
    elseif nZoneRole > 0 then
      self.szCurRoleName = tbZoneRole[1].Name
    end
  end
  --print(szRoleListInfo, nSelIndex);
  CallFlashFun(self.UIGROUP, self.FLASH, "setRoleData", szRoleListInfo, tostring(nSelIndex))
  if nRole + nZoneRole == 0 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_SEL_OK, 0)
    Wnd_SetTip(self.UIGROUP, self.BTN_SEL_OK, "Vui lòng tạo nhân vật trước")
  else
    Wnd_SetTip(self.UIGROUP, self.BTN_SEL_OK, "")
  end
  if nRole + nZoneRole >= 12 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_NEW, 0)
    Wnd_SetTip(self.UIGROUP, self.BTN_NEW, "Tài khoản này đã đạt giới hạn số lượng nhân vật, không thể tạo thêm")
  else
    Wnd_SetTip(self.UIGROUP, self.BTN_NEW, "")
  end
end

function tbSelAndNewRole:UpdateSelSvr()
  local szSvrTitle = GetLastSvrTitle() -- Nếu không có chuỗi thì làm sao, hiển thị hộp chọn

  local nStart, nEnd = string.find(szSvrTitle, "Mới Mở")
  if nStart and nStart > 0 then
    szSvrTitle = string.sub(szSvrTitle, 1, nStart - 1)
  end

  local nStart, nEnd = string.find(szSvrTitle, "Khuyến Nghị")
  if nStart and nStart > 0 then
    szSvrTitle = string.sub(szSvrTitle, 1, nStart - 1)
  end

  Txt_SetTxt(self.UIGROUP, self.TXT_CURSVR, szSvrTitle)
end

-- callback từ flash
function tbSelAndNewRole:SelectRole(szRoleName)
  --print("Chọn nhân vật："..szRoleName);
  self.szCurRoleName = szRoleName
end

function tbSelAndNewRole:FindRoleIndex(szRoleName)
  local nRole, tbRole = GetRoleList()
  local nZoneRole, tbZoneRole = GetZoneRoleList()

  for i = 1, nRole do
    if tbRole[i].Name == szRoleName then
      return 1, i - 1
    end
  end
  for i = 1, nZoneRole do
    if tbZoneRole[i].Name == szRoleName then
      return 2, i - 1
    end
  end

  return 0
end

function tbSelAndNewRole:_SelectRole(szRoleName)
  local nFindFlag, nIndex = self:FindRoleIndex(szRoleName)
  if nFindFlag == 1 then
    SelectRole(nIndex)
  elseif nFindFlag == 2 then -- Chọn nhân vật khu vực
    local _, tbZoneRole = GetZoneRoleList()
    local szSvrTitle = tbZoneRole[nIndex + 1].Server
    -- todo kết nối máy chủ, thiết lập nhân vật được chọn
    local nRealRegion, tbRealRegion = GetServerList()
    for i = 1, nRealRegion do
      for _, tbSvr in ipairs(tbRealRegion[i]) do
        if tbSvr.Title == szSvrTitle then
          local bRet = AccountLoginSecret(szSvrTitle, tbZoneRole[nIndex + 1].Name)
          return
        end
      end
    end
    local tbMsg = { szMsg = "Nhân vật này không ở máy chủ hiện tại", tbOptTitle = { "Xác nhận" } }
    UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
  else
    local tbMsg = { szMsg = "Vui lòng tạo nhân vật trước", tbOptTitle = { "Xác nhận" } }
    UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
    return
  end
end

-- Xác nhận chọn
function tbSelAndNewRole:OnConfirmSel()
  -- Do việc double-click flash sẽ gọi đến đây, và việc chọn nhân vật sẽ xóa toàn bộ flash, có thể gây crash, nên dùng timer để tránh chồng chéo call stack
  if self.szCurRoleName == "" then
    return
  end
  if Btn_GetCheck(self.UIGROUP, self.BTN_PKPROMPT) == 0 then
    return
  end
  self.nTimerId = tbTimer:Register(TIMER_TICK, self.OnTimer, self) -- Bật timer
end

function tbSelAndNewRole:OnTimer()
  if self.nTimerId > 0 then
    tbTimer:Close(self.nTimerId)
    self.nTimerId = 0
  end
  self:_SelectRole(self.szCurRoleName)
end

------------------------------------------- Tạo nhân vật ----------------------------------
function tbSelAndNewRole:GetRandomName(nSex)
  nSex = nSex or self.nSex
  local szFirstName = self.tbFirstName[MathRandom(1, #self.tbFirstName)]
  local szLastName = ""
  if nSex == 0 then
    szLastName = self.tbMaleName[MathRandom(1, #self.tbMaleName)]
  else
    szLastName = self.tbFemaleName[MathRandom(1, #self.tbFemaleName)]
  end

  -- Random số từ: 2 hoặc 3 từ
  local nWordCount = MathRandom(2, 3)
  local szRstName = ""

  if nWordCount == 2 then
    -- 2 từ: Họ + Tên
    szRstName = string.format("%s%s", szFirstName, szLastName)
  else
    -- 3 từ: Họ + Tên + Từ bổ sung
    local szExtra = self.tbExtraWords[MathRandom(1, #self.tbExtraWords)]
    szRstName = string.format("%s%s%s", szFirstName, szLastName, szExtra)
  end

  local nCurrentLength = string.len(szRstName)

  -- Đảm bảo tên đáp ứng yêu cầu độ dài (6-16 ký tự)
  if nCurrentLength < 6 then
    -- Nếu tên quá ngắn, thêm từ bổ sung
    local szExtra = self.tbExtraWords[MathRandom(1, #self.tbExtraWords)]
    szRstName = szRstName .. szExtra
    nCurrentLength = string.len(szRstName)
  elseif nCurrentLength > 16 then
    -- Nếu tên quá dài, cắt bớt để phù hợp
    szRstName = string.sub(szRstName, 1, 16)
  end

  return szRstName
end

-- Xử lý sự kiện phím đặc biệt
function tbSelAndNewRole:OnSpecialKeyDown(szWndName, nParam)
  if szWndName == self.EDIT_NAME then
    if nParam == Ui.MSG_VK_RETURN then
      self:OnButtonClick(self.BTN_NEW_OK)
    end
  end
end

function tbSelAndNewRole:SelectSex(nSex)
  self.nSex = tonumber(nSex)
  if not self.bReSel then
    self.bReSel = true
    local szName = self:GetRandomName()
    Edt_SetTxt(self.UIGROUP, self.EDIT_NAME, szName)
  end
end

function tbSelAndNewRole:SelectHome(nMapId)
  local nMapId = tonumber(nMapId) + 1
  if nMapId == self.nMapId then
    return
  end

  -- Đã đầy thì không thể chọn được nữa
  if nMapId > #self.tbVillageList then -- Click vào chỗ trống
    CallFlashFun(self.UIGROUP, self.FLASH, "selectSexAndCity", tostring(self.nSex), tostring(self.nMapId - 1))
    return
  end

  local tbVillage = self.tbVillageList[nMapId]
  if not tbVillage or tbVillage.nState == 3 then
    CallFlashFun(self.UIGROUP, self.FLASH, "selectSexAndCity", tostring(self.nSex), tostring(self.nMapId - 1))
    return
  end

  self.nMapId = nMapId
end

function tbSelAndNewRole:PlayComplete()
  -- print("Hoàn thành animation flash tạo nhân vật tbSelAndNewRole:PlayComplete()", GetTime());
  self.m_bLoadComplete = 1
  -- Không phải tạo nhân vật mà đi đến bước này, chắc chắn là tài khoản hoàn toàn mới
  if self.nMode ~= self.MODE_NEW_ROLE then
    SetLoginStatus(tbLogin.emLOGINSTATUS_OPT_CREATEROLE)
    self.nMode = self.MODE_NEW_ROLE
  end

  self:UpdateHomeTownList()
end

-- Chỉ cập nhật khi flash đã load xong
function tbSelAndNewRole:UpdateHomeTownList()
  -- Animation chưa load xong
  if 1 ~= self.m_bLoadComplete then
    return
  end

  -- Không có dữ liệu làng tân thủ
  if not self.tbVillageList or 0 == #self.tbVillageList then
    return
  end

  local szCitys = ""
  local tbHouXuan = {}
  -- Lưu ý: không thể sử dụng ký hiệu "<>" ở đây, lý do không rõ
  for index, tbVillage in ipairs(self.tbVillageList) do
    if tbVillage.nState == 3 then -- Máy chủ đã đầy
      szCitys = szCitys .. tbVillage.szVillage .. "&0xff0000" .. ","
    elseif tbVillage.nState == 2 then -- Quá tải
      szCitys = szCitys .. tbVillage.szVillage .. "&0xf77409" .. ","
      table.insert(tbHouXuan, index)
    else -- Trạng thái tốt
      szCitys = szCitys .. tbVillage.szVillage .. "&0x00ff00" .. ","
      table.insert(tbHouXuan, index)
    end
  end

  szCitys = string.sub(szCitys, 0, -2)

  local bNeedReSelect = 0
  -- Random một bản đồ
  if 0 == self.nMapId or self.nMapId > #self.tbVillageList then
    local nIndex = MathRandom(1, #tbHouXuan)
    self.nMapId = tbHouXuan[nIndex] -- Ứng viên là làng tân thủ có thể vào được
    bNeedReSelect = 1
  end
  -- Random giới tính
  if not self.nSex then
    self.nSex = MathRandom(0, 1)
    bNeedReSelect = 1
  end

  CallFlashFun(self.UIGROUP, self.FLASH, "setCitys", szCitys)

  if 1 == bNeedReSelect then
    CallFlashFun(self.UIGROUP, self.FLASH, "selectSexAndCity", tostring(self.nSex), tostring(self.nMapId - 1))
  end
end

-- Từ bổ sung cho tên kiếm hiệp (không dấu)
tbSelAndNewRole.tbExtraWords = {
  "Kiem",
  "Dao",
  "Phong",
  "Vu",
  "Thien",
  "Long",
  "Phuong",
  "Minh",
  "Huyen",
  "Bao",
  "Kim",
  "Ngoc",
  "Linh",
  "Tu",
  "Hanh",
  "Tieu",
  "Van",
  "Tuyet",
  "Bang",
  "Hoa",
  "Loi",
  "Dien",
  "Son",
  "Ha",
}

-- Họ kiếm hiệp (1 từ đơn, nhiều lựa chọn)
tbSelAndNewRole.tbFirstName = {
  -- Môn phái/Núi
  "Thien",
  "Vo",
  "Thieu",
  "Nga",
  "Con",
  "Hoa",
  "Thai",
  "Hang",
  "Minh",
  "Bach",
  "Huyen",
  "Tu",
  "Kim",
  "Ngoc",
  "Bich",
  "Thanh",
  "Linh",
  "Dia",
  "Bang",
  "Loi",
  "Phong",
  "Van",
  "Cuu",
  "Tam",
  "Don",
  "Cuc",
  "Ma",
  "Tuyet",
  "Thiet",
  "Cang",
  "Gian",
  "Truc",
  "Mai",
  "Lan",
  "Hong",
  "Dao",
  "Duong",
  "Hoang",
  "Xanh",
  "Chu",
  "Co",
  "Sat",
  "Kiet",
  "Am",
  "Ngu",
  "Bat",
  "Long",
  "Ho",
  -- Thêm nhiều từ đơn khác
  "Tien",
  "Than",
  "Vuong",
  "De",
  "Hau",
  "Phi",
  "Nu",
  "Son",
  "Ha",
  "Van",
  "Nguyet",
  "Tinh",
  "Bao",
  "Chau",
  "Tam",
  "Kinh",
  "Minh",
  "Sac",
  "Nhan",
  "Huong",
  "Lien",
  "Nhi",
  "Vu",
  "Chau",
  "Linh",
  "Hau",
  "Dao",
  "Giao",
  "Lam",
  "Cuc",
  "Tu",
  "Vu",
  "Sat",
  "Duong",
  "Am",
  "Quai",
  "Cung",
}

-- Tên nam kiếm hiệp (1 từ đơn, nhiều lựa chọn)
tbSelAndNewRole.tbMaleName = {
  -- Danh hiệu/Võ công
  "Than",
  "Thanh",
  "Van",
  "Ho",
  "Ma",
  "Bong",
  "Kiem",
  "Vuong",
  "Danh",
  "Co",
  "Dich",
  "Ha",
  "Thien",
  "Pha",
  "The",
  "Song",
  "Bai",
  "Ton",
  "Hoang",
  "Lan",
  "Vu",
  "Tuoc",
  "Long",
  "Minh",
  "De",
  "Gioi",
  "Dia",
  "Nhan",
  "Tien",
  "Luu",
  "Dao",
  "Tai",
  "Uu",
  "Kinh",
  "Vi",
  "Khong",
  -- Thêm nhiều từ đơn khác
  "Phong",
  "Loi",
  "Hoa",
  "Bang",
  "Tuyet",
  "Kim",
  "Ngoc",
  "Bao",
  "Hanh",
  "Tieu",
  "Linh",
  "Tu",
  "Cuu",
  "Tam",
  "Don",
  "Cuc",
  "Thiet",
  "Cang",
  "Truc",
  "Mai",
  "Lan",
  "Hong",
  "Duong",
  "Xanh",
  "Chu",
  "Co",
  "Sat",
  "Kiet",
  "Ngu",
  "Bat",
  "Trai",
  "Nghia",
  "Duc",
  "Tin",
  "Nghiem",
  "Uy",
}

-- Tên nữ kiếm hiệp (1 từ đơn, nhiều lựa chọn)
tbSelAndNewRole.tbFemaleName = {
  -- Vẻ đẹp/Phẩm chất
  "Nu",
  "Tu",
  "Tam",
  "Nhi",
  "Vu",
  "Lien",
  "Nhan",
  "Sac",
  "Huong",
  "Hoa",
  "Ngoc",
  "Chau",
  "Linh",
  "Nguyet",
  "Than",
  "Tien",
  "Huyen",
  "Ma",
  "Hau",
  "Phi",
  "Kieu",
  "Hiep",
  "Liet",
  "Dao",
  "Minh",
  "Tinh",
  "Vo",
  "Phat",
  "Thanh",
  "Bang",
  "Tuyet",
  "Phong",
  "Bao",
  "Kim",
  "Hanh",
  "Tieu",
  -- Thêm nhiều từ đơn khác
  "Van",
  "Loi",
  "Dien",
  "Son",
  "Ha",
  "Cuu",
  "Don",
  "Cuc",
  "Thiet",
  "Cang",
  "Truc",
  "Mai",
  "Lan",
  "Hong",
  "Duong",
  "Xanh",
  "Chu",
  "Co",
  "Sat",
  "Kiet",
  "Ngu",
  "Bat",
  "Yen",
  "An",
  "Binh",
  "Thuan",
  "Hoa",
  "Loc",
  "Phuoc",
  "Tho",
  "Khang",
  "Ninh",
  "Ky",
  "Anh",
  "Duc",
  "Tai",
}

------------------------------------------- Chung --------------------------------------
function tbSelAndNewRole:OnFlashCall(szWnd, szFun, ...)
  if szWnd == self.FLASH then
    self[szFun](self, unpack(arg))
  end
end

-- Chuyển đổi đến giao diện tạo hoàn thành
function tbSelAndNewRole:loadCreatingRoleComplete()
  --print("Chuyển đổi đến giao diện tạo hoàn thành！");
  Wnd_Hide(self.UIGROUP, self.SEL_UI)
  Wnd_Show(self.UIGROUP, self.NEW_UI)
end

-- Chuyển đổi đến giao diện chọn hoàn thành
function tbSelAndNewRole:loadSelectingRoleComplete()
  --print("Chuyển đổi đến giao diện chọn hoàn thành！");
  Wnd_Hide(self.UIGROUP, self.NEW_UI)
  Wnd_Show(self.UIGROUP, self.SEL_UI)
end

-- Chức năng chuyển đổi UI
function tbSelAndNewRole:ChangeUi(nMode)
  self.nMode = nMode

  if self.MODE_NEW_ROLE == nMode then
    Wnd_Hide(self.UIGROUP, self.SEL_UI)
    Wnd_Show(self.UIGROUP, self.NEW_UI)

    self.nMapId = 0
    self.m_bLoadComplete = 0
    self.tbVillageList = {}

    CallFlashFun(self.UIGROUP, self.FLASH, "playCreatingRole")
  elseif self.MODE_SELECT_ROLE == nMode then
    Wnd_Hide(self.UIGROUP, self.NEW_UI)
    Wnd_Show(self.UIGROUP, self.SEL_UI)

    self.nRoleCount = 0 -- Số lượng nhân vật
    self.nZoneRoleCount = 0 -- Số lượng nhân vật khu vực
    self.szCurRoleName = "" -- Nhân vật hiện tại được kiểm tra

    self:UpdateRoleInfo()
    self:UpdateSelSvr()
    CallFlashFun(self.UIGROUP, self.FLASH, "playSelectingRole", Ui.szMode)
  elseif self.MODE_NONE == nMode then
    Wnd_Hide(self.UIGROUP, self.NEW_UI)
    Wnd_Hide(self.UIGROUP, self.SEL_UI)
  end
end

function tbSelAndNewRole:trace(szOutput)
  --print(szOutput);
end

function tbSelAndNewRole:OnUpdateHomeTownList()
  local tbHomeTown = GetVillageList()
  -- Cập nhật danh sách làng tân thủ
  for _, tbHome in ipairs(tbHomeTown) do
    local bFound = 0
    for _, tbVillage in ipairs(self.tbVillageList) do
      if tbVillage.nMapId == tbHome.nMapId then
        tbVillage.nPercent = tbHome.nPercent
        tbVillage.nState = tbHome.nState
        bFound = 1
        break
      end
    end

    if 0 == bFound then
      local szName = GetMapNameFormId(tbHome.nMapId)
      if szName and "" ~= szName then
        local tbV = {
          ["nMapId"] = tbHome.nMapId,
          ["nPercent"] = tbHome.nPercent,
          ["nState"] = tbHome.nState,
          ["szVillage"] = szName,
        }

        table.insert(self.tbVillageList, tbV)
      end
    end
  end
  -- Nếu làng tân thủ đã đóng, client sẽ hiển thị đầy, không xóa khỏi danh sách để tránh trải nghiệm không tốt
  for _, tbVillage in ipairs(self.tbVillageList) do
    local bFound = 0
    for _, tbHome in pairs(tbHomeTown) do
      if tbHome.nMapId == tbVillage.nMapId then
        bFound = 1
        break
      end
    end
    -- Không có trong danh sách ứng viên
    if 0 == bFound then
      tbVillage.nPercent = 1.0
      tbVillage.nState = 3
    end
  end

  self:UpdateHomeTownList()
end

function tbSelAndNewRole:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_UPDATE_HOMETOWN_LIST, self.OnUpdateHomeTownList }, -- Cập nhật danh sách làng tân thủ
  }
  return tbRegEvent
end
