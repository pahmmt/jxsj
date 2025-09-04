-- Định nghĩa hằng số cơ bản của thế giới game (Lưu ý giữ sự nhất quán với chương trình)

Env.GAME_FPS = 18 -- Số khung hình mỗi giây của thế giới game

-- Định nghĩa giới tính
Env.SEX_MALE = 0 -- Nam
Env.SEX_FEMALE = 1 -- Nữ

-- Chuỗi mô tả giới tính
Env.SEX_NAME = {
  [Env.SEX_MALE] = "Nam",
  [Env.SEX_FEMALE] = "Nữ",
}

-- Định nghĩa hằng số ngũ hành
Env.SERIES_NONE = 0 -- Vô
Env.SERIES_METAL = 1 -- Kim
Env.SERIES_WOOD = 2 -- Mộc
Env.SERIES_WATER = 3 -- Thủy
Env.SERIES_FIRE = 4 -- Hỏa
Env.SERIES_EARTH = 5 -- Thổ

-- Chuỗi tên ngũ hành
Env.SERIES_NAME = {
  [Env.SERIES_NONE] = "Vô",
  [Env.SERIES_METAL] = "Kim",
  [Env.SERIES_WOOD] = "Mộc",
  [Env.SERIES_WATER] = "Thủy",
  [Env.SERIES_FIRE] = "Hỏa",
  [Env.SERIES_EARTH] = "Thổ",
}

Env.DISPLAY_RESOLUTION = {
  ["a"] = { 800, 600 },
  ["b"] = { 1024, 768 },
  ["c"] = { 1280, 800 },
}

-- Loại tin tức thế giới
Env.NEWSMSG_NORMAL = 0 -- Bình thường
Env.NEWSMSG_COUNT = 1 -- Phát trễ
Env.NEWSMSG_TIMEEND = 2 -- Dừng theo lịch
Env.NEWSMSG_MARRAY = 3 -- Tin nhắn hiệu ứng đặc biệt khi kết hôn

Env.WEIWANG_BATTLE = 1
Env.WEIWANG_MENPAIJINGJI = 2
Env.WEIWANG_DATI = 3
Env.WEIWANG_BAIHUTANG = 4
Env.WEIWANG_TREASURE = 5
Env.WEIWANG_BAOWANTONG = 6
Env.WEIWANG_GUOZI = 7
Env.WEIWANG_BOSS = 8

-- Định nghĩa loại khu vực (mặc định là Viễn Thông)
--	TODO: Hiện chỉ hỗ trợ phiên bản Kingsoft
Env.ZONE_TYPE = {
  [2] = 2,
  [5] = 2,
  [9] = 2,
  [11] = 2,
}

Env.FACTION_ID_NOFACTION = 0
Env.FACTION_ID_SHAOLIN = 1 -- Thiếu Lâm
Env.FACTION_ID_TIANWANG = 2 -- Thiên Vương
Env.FACTION_ID_TANGMEN = 3 -- Đường Môn
Env.FACTION_ID_WUDU = 4 -- Ngũ Độc
Env.FACTION_ID_EMEI = 5 -- Nga Mi
Env.FACTION_ID_CUIYAN = 6 -- Thúy Yên
Env.FACTION_ID_GAIBANG = 7 -- Cái Bang
Env.FACTION_ID_TIANREN = 8 -- Thiên Nhẫn
Env.FACTION_ID_WUDANG = 9 -- Võ Đang
Env.FACTION_ID_KUNLUN = 10 -- Côn Lôn
Env.FACTION_ID_MINGJIAO = 11 -- Minh Giáo
Env.FACTION_ID_DALIDUANSHI = 12 -- Đại Lý Đoàn Thị
Env.FACTION_ID_GUMU = 13 -- Cổ Mộ

Env.FACTION_NUM = 13

-- Định nghĩa tên loại khu vực
--(Đã bỏ, để lấy tên loại khu vực có thể dùng Env:GetZoneTypeName(szGatewayName)
Env.ZONE_TYPE_NAME = {
  [1] = "Viễn Thông",
  [2] = "Netcom",
}

function Env:GetZoneType(szGatewayName)
  local tbInfor = ServerEvent:GetServerInforByGateway(szGatewayName)
  if not tbInfor or not tbInfor.ZoneType then
    --Nếu không có dữ liệu thì dùng phương pháp cũ
    local nZoneId = tonumber(string.sub(szGatewayName, 5, 6))
    return self.ZONE_TYPE[nZoneId] or 1
  end
  return tbInfor.ZoneType
end

function Env:GetZoneTypeName(szGatewayName)
  if ServerEvent:GetServerInforByGateway(szGatewayName) then
    return ServerEvent:GetServerInforByGateway(szGatewayName).ZoneTypeName
  end
  return "Viễn Thông"
end
