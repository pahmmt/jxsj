-- Vật phẩm tạm thời
local tb = Item:GetClass("tempitem")

local _tbMap = {
  { "Chiến trường", "Báo danh Tống (Dương Châu 1)", 181, 1654, 3314 },
  { "Chiến trường", "Báo danh Tống (Tương Dương 1)", 183, 1654, 3314 },
  { "Chiến trường", "Báo danh Tống (Phượng Tường 1)", 182, 1654, 3314 },
  { "Chiến trường", "Báo danh Kim (Dương Châu 1)", 184, 1654, 3314 },
  { "Chiến trường", "Báo danh Kim (Tương Dương 1)", 186, 1654, 3314 },
  { "Chiến trường", "Báo danh Kim (Phượng Tường 1)", 185, 1654, 3314 },
  { "Chiến trường", "Báo danh Tống (Dương Châu 2)", 257, 1654, 3314 },
  { "Chiến trường", "Báo danh Tống (Tương Dương 2)", 259, 1654, 3314 },
  { "Chiến trường", "Báo danh Tống (Phượng Tường 2)", 258, 1654, 3314 },
  { "Chiến trường", "Báo danh Kim (Dương Châu 2)", 260, 1654, 3314 },
  { "Chiến trường", "Báo danh Kim (Tương Dương 2)", 262, 1654, 3314 },
  { "Chiến trường", "Báo danh Kim (Phượng Tường 2)", 261, 1654, 3314 },
  { "Chiến trường", "Bàn Long Cốc (Dương Châu 1)", 193, 2335, 3481 },
  { "Chiến trường", "Bàn Long Cốc (Tương Dương 1)", 195, 2335, 3481 },
  { "Chiến trường", "Bàn Long Cốc (Phượng Tường 1)", 194, 2335, 3481 },
  { "Chiến trường", "Ngũ Trượng Nguyên (Dương Châu 1)", 190, 1767, 2977 },
  { "Chiến trường", "Ngũ Trượng Nguyên (Tương Dương 1)", 192, 1767, 2977 },
  { "Chiến trường", "Ngũ Trượng Nguyên (Phượng Tường 1)", 191, 1767, 2977 },
  { "Chiến trường", "Cửu Khúc (Dương Châu 1)", 187, 1435, 3748 },
  { "Chiến trường", "Cửu Khúc (Tương Dương 1)", 189, 1435, 3748 },
  { "Chiến trường", "Cửu Khúc (Phượng Tường 1)", 188, 1435, 3748 },
  { "Chiến trường", "Bàn Long Cốc (Dương Châu 2)", 263, 2335, 3481 },
  { "Chiến trường", "Bàn Long Cốc (Tương Dương 2)", 265, 2335, 3481 },
  { "Chiến trường", "Bàn Long Cốc (Phượng Tường 2)", 264, 2335, 3481 },
  { "Chiến trường", "Ngũ Trượng Nguyên (Dương Châu 2)", 266, 1767, 2977 },
  { "Chiến trường", "Ngũ Trượng Nguyên (Tương Dương 2)", 268, 1767, 2977 },
  { "Chiến trường", "Ngũ Trượng Nguyên (Phượng Tường 2)", 267, 1767, 2977 },
  { "Chiến trường", "Cửu Khúc (Dương Châu 2)", 269, 1435, 3748 },
  { "Chiến trường", "Cửu Khúc (Tương Dương 2)", 271, 1435, 3748 },
  { "Chiến trường", "Cửu Khúc (Phượng Tường 2)", 270, 1435, 3748 },
  { "Chiến trường", "Báo danh Tống (Dương Châu 3)", 282, 1654, 3314 },
  { "Chiến trường", "Báo danh Kim (Dương Châu 3)", 283, 1654, 3314 },
  { "Chiến trường", "Cửu Khúc (Dương Châu 3)", 284, 1435, 3748 },
  { "Chiến trường", "Ngũ Trượng Nguyên (Dương Châu 3)", 285, 1767, 2977 },
  { "Chiến trường", "Bàn Long Cốc (Dương Châu 3)", 286, 2335, 3481 },
  { "Chiến trường", "Báo danh Tống (Phượng Tường 3)", 288, 1654, 3314 },
  { "Chiến trường", "Báo danh Kim (Phượng Tường 3)", 289, 1654, 3314 },
  { "Chiến trường", "Cửu Khúc (Phượng Tường 3)", 290, 1435, 3748 },
  { "Chiến trường", "Ngũ Trượng Nguyên (Phượng Tường 3)", 291, 1767, 2977 },
  { "Chiến trường", "Bàn Long Cốc (Tương Dương 3)", 292, 2335, 3481 },
  { "Chiến trường", "Báo danh Tống (Tương Dương 3)", 293, 1654, 3314 },
  { "Chiến trường", "Báo danh Kim (Tương Dương 3)", 294, 1654, 3314 },
  { "Chiến trường", "Cửu Khúc (Tương Dương 3)", 295, 1435, 3748 },
  { "Chiến trường", "Ngũ Trượng Nguyên (Tương Dương 3)", 296, 1767, 2977 },
  { "Chiến trường", "Bàn Long Cốc (Phượng Tường 3)", 297, 2335, 3481 },
  { "Bản đồ dã ngoại", "Mông Cổ Vương Đình", 130, 1601, 3721 },
  { "Bản đồ dã ngoại", "Nguyệt Nha Tuyền", 131, 1938, 3621 },
  { "Bản đồ dã ngoại", "Tàn Tích Cung A Phòng", 132, 1572, 3513 },
  { "Bản đồ dã ngoại", "Lương Sơn Bạc", 133, 1789, 3739 },
  { "Bản đồ dã ngoại", "Thần Nữ Phong", 134, 1777, 3194 },
  { "Bản đồ dã ngoại", "Phế Tích Dạ Lang", 135, 1603, 3687 },
  { "Bản đồ dã ngoại", "Cổ Lãng Tự", 136, 1588, 3169 },
  { "Bản đồ dã ngoại", "Đào Hoa Nguyên", 137, 1848, 3261 },
  { "Bản đồ dã ngoại", "Mạc Bắc Thảo Nguyên", 122, 1797, 3757 },
  { "Bản đồ dã ngoại", "Đôn Hoàng Cổ Thành", 123, 1928, 3366 },
  { "Bản đồ dã ngoại", "Hoạt Tử Nhân Mộ", 124, 1734, 3326 },
  { "Bản đồ dã ngoại", "Đại Vũ Đài", 125, 1750, 3855 },
  { "Bản đồ dã ngoại", "Tam Hiệp Sạn Đạo", 126, 1523, 3592 },
  { "Bản đồ dã ngoại", "Xi Vưu Động", 127, 1605, 3227 },
  { "Bản đồ dã ngoại", "Tỏa Vân Uyên", 128, 1935, 3406 },
  { "Bản đồ dã ngoại", "Phục Lưu Động", 129, 1897, 3586 },
  { "Bản đồ dã ngoại", "Sắc Lặc Xuyên", 114, 1669, 3788 },
  { "Bản đồ dã ngoại", "Gia Dụ Quan", 115, 1440, 3121 },
  { "Bản đồ dã ngoại", "Hoa Sơn", 116, 1658, 3425 },
  { "Bản đồ dã ngoại", "Thục Cương Bí Cảnh", 117, 1548, 3327 },
  { "Bản đồ dã ngoại", "Phong Đô Quỷ Thành", 118, 1554, 3615 },
  { "Bản đồ dã ngoại", "Miêu Lĩnh", 119, 1833, 3727 },
  { "Bản đồ dã ngoại", "Võ Di Sơn", 120, 1744, 3830 },
  { "Bản đồ dã ngoại", "Võ Lăng Sơn", 121, 1548, 3327 },
  { "Bản đồ dã ngoại", "Chú Kiếm Phường", 44, 1556, 3509 },
  { "Bản đồ dã ngoại", "Trấn Đông Mộ Viên", 38, 1569, 3529 },
  { "Bản đồ dã ngoại", "Nhạc Dương Lâu", 45, 1615, 3823 },
  { "Bản đồ dã ngoại", "Rừng Nguyên Sinh - Tây", 74, 1882, 3234 },
  { "Bản đồ dã ngoại", "Rừng Nguyên Sinh - Đông", 64, 1882, 3234 },
  { "Bản đồ dã ngoại", "Dược Vương Động", 93, 1913, 3717 },
  { "Bản đồ dã ngoại", "Yến Tử Ổ - Trung", 70, 1612, 2699 },
  { "Bản đồ dã ngoại", "Yến Tử Ổ - Ngoại", 60, 1612, 2699 },
  { "Bản đồ dã ngoại", "Nhạn Đãng Long T湫", 36, 1613, 3938 },
  { "Bản đồ dã ngoại", "Hưởng Thủy Động", 97, 1720, 3793 },
  { "Bản đồ dã ngoại", "Tây Hạ Hoàng Lăng", 108, 1670, 3214 },
  { "Bản đồ dã ngoại", "Đồng Quan", 40, 1816, 3883 },
  { "Bản đồ dã ngoại", "Thiên Trụ Phong", 49, 1618, 3927 },
  { "Bản đồ dã ngoại", "Thiên Nhẫn Giáo Cấm Địa", 47, 1661, 3679 },
  { "Bản đồ dã ngoại", "Thiên Long Tự", 112, 1913, 3537 },
  { "Bản đồ dã ngoại", "Thái Hành Cổ Kính", 86, 1951, 3913 },
  { "Bản đồ dã ngoại", "Tháp Lâm - Tây", 66, 1995, 3287 },
  { "Bản đồ dã ngoại", "Tháp Lâm - Đông", 56, 1995, 3287 },
  { "Bản đồ dã ngoại", "Thục Nam Trúc Hải", 42, 2028, 3430 },
  { "Bản đồ dã ngoại", "Thục Cương Sơn", 103, 1802, 3907 },
  { "Bản đồ dã ngoại", "Sa Mạc Mê Cung", 101, 1624, 3877 },
  { "Bản đồ dã ngoại", "Thanh Loa Đảo", 55, 1926, 3760 },
  { "Bản đồ dã ngoại", "Kỳ Liên Sơn", 39, 2035, 3252 },
  { "Bản đồ dã ngoại", "Bành Lễ Cổ Trạch", 99, 1626, 2433 },
  { "Bản đồ dã ngoại", "Nam Di Bộ Lạc", 54, 1824, 3201 },
  { "Bản đồ dã ngoại", "Mai Hoa Lĩnh", 33, 1988, 4048 },
  { "Bản đồ dã ngoại", "Lô Vĩ Đãng - Tây Bắc", 75, 1974, 3724 },
  { "Bản đồ dã ngoại", "Lô Vĩ Đãng - Đông Nam", 65, 1974, 3724 },
  { "Bản đồ dã ngoại", "Long Môn Thạch Quật", 107, 1968, 3824 },
  { "Bản đồ dã ngoại", "Long Môn Khách Sạn", 31, 2034, 3550 },
  { "Bản đồ dã ngoại", "Long Hổ Huyễn Cảnh - Tây", 69, 1588, 3170 },
  { "Bản đồ dã ngoại", "Long Hổ Huyễn Cảnh - Đông", 59, 1588, 3170 },
  { "Bản đồ dã ngoại", "Quân Mã Trường", 32, 1611, 3966 },
  { "Bản đồ dã ngoại", "Cư Diên Trạch", 94, 1786, 3958 },
  { "Bản đồ dã ngoại", "Cửu Nghi Khê", 106, 1929, 3324 },
  { "Bản đồ dã ngoại", "Cửu Lão Phong", 51, 1776, 3133 },
  { "Bản đồ dã ngoại", "Cửu Lão Động - Tầng 1", 61, 1638, 3828 },
  { "Bản đồ dã ngoại", "Cửu Lão Động - Tầng 2", 71, 1638, 3828 },
  { "Bản đồ dã ngoại", "Kim Quốc Hoàng Lăng - Tầng 1", 57, 1678, 3237 },
  { "Bản đồ dã ngoại", "Kim Quốc Hoàng Lăng - Tầng 2", 67, 1678, 3237 },
  { "Bản đồ dã ngoại", "Tiến Cúc Động", 110, 1382, 3279 },
  { "Bản đồ dã ngoại", "Kiếm Môn Quan", 111, 1611, 3269 },
  { "Bản đồ dã ngoại", "Kiếm Các Thục Đạo", 104, 1546, 3717 },
  { "Bản đồ dã ngoại", "Kiến Tính Phong", 48, 1875, 3725 },
  { "Bản đồ dã ngoại", "Kê Quan Động", 102, 1599, 3208 },
  { "Bản đồ dã ngoại", "Hoàng Hạc Lâu", 109, 1929, 3545 },
  { "Bản đồ dã ngoại", "Hoán Hoa Khê", 90, 1963, 3559 },
  { "Bản đồ dã ngoại", "Hoài Thủy Sa Châu", 41, 1973, 3377 },
  { "Bản đồ dã ngoại", "Hổ Khâu Kiếm Trì", 96, 1798, 3971 },
  { "Bản đồ dã ngoại", "Bờ Hồ Trúc Lâm - Tây", 73, 1775, 3241 },
  { "Bản đồ dã ngoại", "Bờ Hồ Trúc Lâm - Đông", 63, 1775, 3241 },
  { "Bản đồ dã ngoại", "Hậu Sơn Cấm Địa", 46, 2006, 3306 },
  { "Bản đồ dã ngoại", "Hán Thủy Cổ Độ", 88, 1901, 3335 },
  { "Bản đồ dã ngoại", "Hàn Sơn Cổ Sát", 89, 1528, 3386 },
  { "Bản đồ dã ngoại", "Cổ Chiến trường", 30, 1623, 4041 },
  { "Bản đồ dã ngoại", "Cô Tô Thủy Tạ", 50, 1833, 3140 },
  { "Bản đồ dã ngoại", "Phục Ngưu Sơn", 95, 1603, 3275 },
  { "Bản đồ dã ngoại", "Phong Lăng Độ", 100, 1974, 3264 },
  { "Bản đồ dã ngoại", "Phỉ Thúy Hồ", 53, 1861, 3207 },
  { "Bản đồ dã ngoại", "Nhĩ Hải Ma Nham", 91, 1975, 3437 },
  { "Bản đồ dã ngoại", "Đoàn Thị Hoàng Lăng", 105, 1397, 3544 },
  { "Bản đồ dã ngoại", "Bờ Hồ Động Đình", 37, 1788, 3255 },
  { "Bản đồ dã ngoại", "Điểm Thương Sơn", 98, 1926, 3801 },
  { "Bản đồ dã ngoại", "Đại Tản Quan", 87, 1596, 3382 },
  { "Bản đồ dã ngoại", "Thung Lũng Trường Giang", 34, 1689, 3407 },
  { "Bản đồ dã ngoại", "Trà Mã Cổ Đạo", 43, 1958, 3830 },
  { "Bản đồ dã ngoại", "Thái Thạch Ky", 92, 2069, 3447 },
  { "Bản đồ dã ngoại", "Băng Huyệt Mê Cung - Tầng 1", 58, 1633, 3368 },
  { "Bản đồ dã ngoại", "Băng Huyệt Mê Cung - Tầng 2", 68, 1633, 3368 },
  { "Bản đồ dã ngoại", "Bang Nguyên Bí Động", 113, 1893, 3383 },
  { "Bản đồ dã ngoại", "Bách Hoa Trận - Ngoại Trận", 62, 2378, 3768 },
  { "Bản đồ dã ngoại", "Bách Hoa Trận - Nội Trận", 72, 2378, 3768 },
  { "Bản đồ dã ngoại", "Bách Hoa Cốc", 52, 1957, 3738 },
  { "Bản đồ dã ngoại", "Bạch Tộc Chợ", 35, 2024, 3979 },
  { "Tân Thủ Thôn", "Vân Trung Trấn", 1, 1389, 3102 },
  { "Tân Thủ Thôn", "Vĩnh Lạc Trấn", 3, 1693, 3288 },
  { "Tân Thủ Thôn", "Thạch Cổ Trấn", 6, 1572, 3106 },
  { "Tân Thủ Thôn", "Long Tuyền Thôn", 7, 1510, 3268 },
  { "Tân Thủ Thôn", "Long Môn Trấn", 2, 1785, 3586 },
  { "Tân Thủ Thôn", "Giang Tân Thôn", 5, 1597, 3131 },
  { "Tân Thủ Thôn", "Đạo Hương Thôn", 4, 1624, 3253 },
  { "Tân Thủ Thôn", "Ba Lăng Huyện", 8, 1721, 3381 },
  { "Tân Thủ Thôn", "Linh Tú Thôn", 2115, 1608, 3283 },
  { "Môn phái", "Tây Hạ Nhất Phẩm Đường", 13, 1679, 3292 },
  { "Môn phái", "Võ Đang Phái", 14, 1435, 2991 },
  { "Môn phái", "Ngũ Độc Giáo", 20, 1574, 3145 },
  { "Môn phái", "Thiên Vương Bang", 22, 1663, 3039 },
  { "Môn phái", "Thiên Nhẫn Giáo", 10, 1658, 3324 },
  { "Môn phái", "Đường Môn", 18, 1633, 3179 },
  { "Môn phái", "Thiếu Lâm Phái", 9, 1702, 3093 },
  { "Môn phái", "Tát Mãn Giáo", 11, 1645, 3196 },
  { "Môn phái", "Côn Lôn Phái", 12, 1700, 3080 },
  { "Môn phái", "Cái Bang", 15, 1606, 3245 },
  { "Môn phái", "Nga Mi Phái", 16, 1584, 3041 },
  { "Môn phái", "Đại Lý Đoàn Thị", 19, 1618, 3120 },
  { "Môn phái", "Thúy Yên Môn", 17, 1487, 3093 },
  { "Môn phái", "Trường Ca Môn", 21, 1631, 3404 },
  { "Môn phái", "Minh Giáo", 224, 1625, 3181 },
  { "Môn phái", "Cổ Mộ", 2261, 1733, 3054 },
  { "Lôi đài", "Võ Lâm Lôi Đài (Dương Châu)", 170, 1646, 3177 },
  { "Lôi đài", "Võ Lâm Lôi Đài (Tương Dương)", 169, 1646, 3177 },
  { "Lôi đài", "Võ Lâm Lôi Đài (Lâm An)", 173, 1646, 3177 },
  { "Lôi đài", "Võ Lâm Lôi Đài (Phượng Tường)", 168, 1646, 3177 },
  { "Lôi đài", "Võ Lâm Lôi Đài (Đại Lý)", 172, 1646, 3177 },
  { "Lôi đài", "Võ Lâm Lôi Đài (Thành Đô)", 171, 1646, 3177 },
  { "Lôi đài", "Võ Lâm Lôi Đài (Biện Kinh)", 167, 1646, 3177 },
  { "Lôi đài", "Thiết Sách Sạn Kiều (Dương Châu)", 177, 1608, 3216 },
  { "Lôi đài", "Thiết Sách Sạn Kiều (Tương Dương)", 176, 1608, 3216 },
  { "Lôi đài", "Thiết Sách Sạn Kiều (Lâm An)", 180, 1608, 3216 },
  { "Lôi đài", "Thiết Sách Sạn Kiều (Phượng Tường)", 175, 1608, 3216 },
  { "Lôi đài", "Thiết Sách Sạn Kiều (Đại Lý)", 179, 1608, 3216 },
  { "Lôi đài", "Thiết Sách Sạn Kiều (Thành Đô)", 178, 1608, 3216 },
  { "Lôi đài", "Thiết Sách Sạn Kiều (Biện Kinh)", 174, 1608, 3216 },
  { "Thành thị", "Dương Châu Phủ", 26, 1641, 3129 },
  { "Thành thị", "Tương Dương Phủ", 25, 1630, 3169 },
  { "Thành thị", "Lâm An Phủ", 29, 1605, 3946 },
  { "Thành thị", "Phượng Tường Phủ", 24, 1767, 3540 },
  { "Thành thị", "Đại Lý Phủ", 28, 1439, 3366 },
  { "Thành thị", "Thành Đô Phủ", 27, 1666, 3260 },
  { "Thành thị", "Biện Kinh Phủ", 23, 1486, 3179 },
}

tb.tbItems = {
  "Vật phẩm Nhiệm vụ",
  {
    {
      "Chữ B",
      {
        { "Trứng Rắn Trắng", 79 },
        { "Bách Nghiệm Linh Dược", 355 },
        { "Ban Ban", 316 },
        { "Bản đồ Bang Nguyên Bí Động", 389 },
        { "Lương thực Bang Nguyên Bí Động", 395 },
        { "Vũ khí Bang Nguyên Bí Động", 394 },
        { "Chìa khóa Rương Báu", 126 },
        { "Chìa khóa Rương Báu", 148 },
        { "Chìa khóa Rương Báu", 393 },
        { "Cờ hiệu phương Bắc", 76 },
        { "Trâm ngọc bị cướp", 94 },
        { "Cống phẩm bị cướp", 329 },
        { "Lương thảo bị cướp", 48 },
        { "Tài sản bị cướp", 49 },
        { "Cỏ Tránh Cổ", 370 },
        { "Biện Kinh Trắc Thiên Đài", 381 },
        { "Bặc Toán Tử", 361 },
        { "Pháo hoa của Bất Động tiên sinh", 406 },
        { "Thương của Bố Giả", 7 },
      },
    },
    {
      "Chữ C",
      {
        { "Mảnh Tàng Bảo Đồ", 1158 },
        { "Mảnh Tàng Bảo Đồ 2", 159 },
        { "Mảnh Tàng Bảo Đồ 3", 160 },
        { "Mảnh Tàng Bảo Đồ 4", 161 },
        { "Cỏ khô", 123 },
        { "Kinh Siêu Độ Vong Hồn", 141 },
        { "Túi bạc nặng trĩu", 22 },
        { "Rượu mạnh lâu năm", 187 },
        { "Trần Niên Trúc Diệp Thanh", 70 },
        { "Ghi chép xuất cung", 310 },
        { "Xuân Tuyệt Tâm Pháp", 63 },
        { "Thư Hùng Song Kiếm", 103 },
        { "Người giấy làm vội", 352 },
        { "Bánh giòn", 311 },
      },
    },
    {
      "Chữ D",
      {
        { "Thư của Đại Giới Thiền Sư", 124 },
        { "Đại Lý Trắc Thiên Đài", 382 },
        { "Tín phù Đại nội", 87 },
        { "Đại Thanh Đâu", 33 },
        { "Y phục đạo sĩ", 400 },
        { "Thư mới đến của Đăng Sát Khẩu", 165 },
        { "Bản đồ Tích Thủy Động", 150 },
        { "Sách tranh bản đồ", 12 },
        { "Chìa khóa Địa huyệt", 2 },
        { "Lệnh bài của Điệp Phiêu Phiêu", 168 },
        { "Cờ hiệu phương Đông", 73 },
        { "Chú giải Thơ Đông Pha", 186 },
        { "Động Thiên Ngọc Giản", 375 },
        { "Cỏ Độc Hỏa", 135 },
        { "Độc dược", 115 },
        { "Lai lịch của Độc Y", 55 },
      },
    },
    {
      "Chữ E~F",
      {
        { "Bài ca Nga Hoàng", 23 },
        { "Sách ghi chép nhân vật Nga Mi", 54 },
        { "Cọc của đội 2", 338 },
        { "Chìa khóa Miếu hoang", 39 },
        { "Hoa Dạ Lai Hương", 18 },
        { "Phượng Tường Trắc Thiên Đài", 384 },
        { "Mảnh Phượng Nhãn Châu", 147 },
        { "Bút vẽ bùa", 349 },
        { "Nước bùa", 114 },
        { "Giấy vẽ bùa", 350 },
        { "Cỏ Phúc Long", 366 },
        { "Da rắn bụng", 179 },
      },
    },
    {
      "Chữ G",
      {
        { "Ngọc bội của Cáo Nam", 108 },
        { "Mệnh lệnh của Cách Tây", 336 },
        { "Mật hàm gửi Hắc Hổ", 397 },
        { "Thư gửi Cừu Chỉ Thủy", 136 },
        { "Thư gửi Thạch Hiên Viên", 137 },
        { "Thư gửi Tiểu Hiển", 120 },
        { "Mật thư cấu kết", 356 },
        { "Cổ Kiếm Trường Thanh", 29 },
        { "Cổ Kiếm Vô Ngân", 175 },
        { "Cổ Cầm", 399 },
        { "Sách cổ thiện bản", 358 },
        { "Thư tay của Cổ Nữ", 371 },
        { "Thư mới đến của ải 1", 162 },
        { "Thư mới đến của ải 2", 163 },
        { "Thư mới đến của ải 3", 164 },
        { "Giỏ trái cây", 132 },
      },
    },
    {
      "Chữ H",
      {
        { "Kim yêu bài Hàn phủ", 98 },
        { "Mật hàm của Hàn Trung", 322 },
        { "Hãn Huyết Bảo Mã", 205 },
        { "Cỏ rất rất độc", 354 },
        { "Hoa Hợp Hoan", 192 },
        { "Máu chó đen", 95 },
        { "Thư giới thiệu của Hắc Hổ", 398 },
        { "Hắc Long Triền", 185 },
        { "Hắc y nhân", 203 },
        { "Hoa Bông Đỏ", 72 },
        { "Rượu khỉ", 9 },
        { "Thịt khỉ", 409 },
        { "Cỏ Hồ Điệp", 143 },
        { "Da hổ", 197 },
        { "Thịt hổ", 411 },
        { "Hoàng Bảng", 97 },
        { "Sơ đồ tình hình Hoàng Hạc Lâu", 130 },
        { "Xương sói vàng", 151 },
        { "Chìa khóa đồng Bính", 27 },
        { "Chìa khóa đồng Giáp", 25 },
        { "Chìa khóa đồng Ất", 26 },
        { "Sách về Hỏa Khí", 71 },
        { "Cọc lửa", 347 },
      },
    },
    {
      "Chữ J",
      {
        { "Trục cơ quan", 116 },
        { "Sổ tay cơ mật", 83 },
        { "Cực Lạc Đan", 402 },
        { "Cực Lạc Hoàn", 342 },
        { "Cỏ Gióng Lúa", 312 },
        { "Tín phù Kiếm Trủng", 301 },
        { "Ấn tín Kiếm Trủng", 306 },
        { "Đầu của Khương Tam", 58 },
        { "Sổ sách giao dịch", 391 },
        { "Tán Nối Gân Nối Mạch", 180 },
        { "Túi gấm của đệ tử tiếp dẫn", 407 },
        { "Sổ ghi nhớ của sứ giả tiếp dẫn", 404 },
        { "Thuốc giải độc", 318 },
        { "Kim Cang Thiền Trượng (Khai quang)", 36 },
        { "Kim Cang Thiền Trượng (Chưa khai quang)", 35 },
        { "Kim Cang Kinh", 140 },
        { "Đầu lâu của người Kim", 153 },
        { "Quặng vàng", 90 },
        { "Túi thêu kim tuyến", 189 },
        { "Cọc vàng", 344 },
        { "Cửu Tiết Xương Bồ", 32 },
        { "Chìa khóa hầm rượu", 335 },
        { "Tình báo tuyệt mật", 332 },
        { "Lò đào băng", 62 },
        { "Sổ quân tịch", 309 },
        { "Bùa chú tìm thấy trong quân doanh", 396 },
        { "Vật tư quân dụng", 96 },
      },
    },
    {
      "Chữ K",
      {
        { "Tay nải của khách", 204 },
        { "Giấy trắng", 379 },
        { "Bình rỗng", 313 },
        { "Thuốc giải của Khấu Duệ", 300 },
        { "Cờ ngựa cánh xương khô", 93 },
        { "Tượng Khổ Thần", 111 },
        { "Chìa khóa cơ quan mỏ", 101 },
      },
    },
    {
      "Chữ L",
      {
        { "Ống thư sáp ong", 134 },
        { "Ấn giám của Lan Tùng Lâm", 170 },
        { "Thư của lão giả", 177 },
        { "Đầu của Lý A Đại", 80 },
        { "Mặt nạ Lý Thăng Dương", 365 },
        { "Cỏ Liên Căn", 178 },
        { "Đầu lâu của Lương Hạng Lâm", 363 },
        { "Lâm An Trắc Thiên Đài", 380 },
        { "Linh Phong Cổ Kính", 319 },
        { "Ngọn lửa linh hồn", 125 },
        { "Linh Chi", 37 },
        { "Lục Súc Bất Ninh Tán (Lâm An)", 385 },
        { "Lục Súc Bất Ninh Tán (Tương Dương)", 387 },
        { "Lục Súc Bất Ninh Tán (Dương Châu)", 386 },
        { "Long Châu", 146 },
        { "Thư nhà của Lư Tiếu Bần", 191 },
        { "Lộc Nhung", 196 },
        { "Thịt hươu", 315 },
        { "Tay nải của Lộ Hiểu Nhiên", 42 },
        { "Thư tín của Lộ Hiểu Nhiên", 41 },
        { "Lục Phúc Xà Đảm", 367 },
        { "Hoa Lục Thiểm Nhi", 167 },
        { "Lục Ngọc Như Ý", 305 },
        { "Thư của La Phong", 78 },
        { "La Bàn", 199 },
        { "La Bàn 2", 209 },
        { "La Bàn 3", 210 },
        { "La Bàn 4", 211 },
        { "Hài cốt của La Tiểu Hổ", 326 },
        { "Hài cốt của La Tiểu Anh", 327 },
      },
    },
    {
      "Chữ M",
      {
        { "Lệnh bài Mã tặc", 173 },
        { "Bát ăn của mèo", 317 },
        { "Bút lông", 10 },
        { "Xương nai", 152 },
        { "Thịt nai", 410 },
        { "Huyết chú bí pháp", 91 },
        { "Sách kế hoạch bí mật", 88 },
        { "Quân lệnh bí mật", 122 },
        { "Danh sách bí mật", 127 },
        { "Tài liệu niêm phong", 113 },
        { "Mật chiếu", 112 },
        { "Tranh chữ của danh nhân", 359 },
        { "Đầu người không rõ", 331 },
        { "Đầu của Mạc Kỳ Tiêu Thanh Phương", 119 },
        { "Linh kiện người gỗ", 40 },
        { "Chìa khóa Mộc Nhân Trận", 303 },
        { "Cọc gỗ", 345 },
        { "Trường kiếm của Mộ Dung Thị", 52 },
      },
    },
    {
      "Chữ N~R",
      {
        { "Cờ hiệu phương Nam", 74 },
        { "Tim nữ tế tư", 84 },
        { "Hài cốt phụ nữ", 77 },
        { "Tóc nữ phù thủy", 24 },
        { "Đầu lâu của Bì La Các", 86 },
        { "Tờ giấy da cừu cũ - trên", 105 },
        { "Tờ giấy da cừu cũ - dưới", 106 },
        { "Thất Bảo Lưu Ly", 50 },
        { "Thất Tinh Thương Phổ", 138 },
        { "Thân Tử Bồn", 128 },
        { "Đầu của Tần Tướng Nhân", 61 },
        { "Thanh Minh Bảo Kiếm", 44 },
        { "Bao kiếm Thanh Minh", 45 },
        { "Danh sách tù nhân", 46 },
        { "Chìa khóa phòng giam", 321 },
        { "Thư của Cừu Chỉ Thủy", 4 },
        { "Của hồi môn của Như Ý", 190 },
      },
    },
    {
      "Chữ S",
      {
        { "Sái Vân Thủ", 64 },
        { "Cọc của đội 3", 339 },
        { "Bản nhạc phổ lộn xộn", 403 },
        { "Bản đồ Sa Mạc Mê Cung", 117 },
        { "Sơn Dược", 31 },
        { "Đao tệ thời Thương", 51 },
        { "Khăn tay thần bí", 109 },
        { "Thư nhà thần bí", 408 },
        { "Thuốc giải của thần y", 369 },
        { "Vật phẩm tìm được trên thi thể", 307 },
        { "Hoa Thi Dụ", 401 },
        { "Bia đá", 19 },
        { "Cơ quan tượng đá", 174 },
        { "Sơ đồ phân bố thế lực", 374 },
        { "Xá lợi của Thích Ca Mâu Ni", 121 },
        { "Nón của Thích Giả", 38 },
        { "Trang sách", 66 },
        { "Soái ấn", 89 },
        { "Thịt của Song Thủ", 360 },
        { "Cọc nước", 346 },
        { "Sợi tơ", 34 },
        { "Cọc của đội 4", 340 },
        { "Tượng Tứ Phương", 201 },
        { "Tượng Tứ Phương 2", 212 },
        { "Tượng Tứ Phương 3", 213 },
        { "Tượng Tứ Phương 4", 214 },
        { "Đầu của người Tống", 59 },
        { "Tín phù của Tùy Phong", 405 },
      },
    },
    {
      "Chữ T",
      {
        { "Quà của Đường Như", 67 },
        { "Ngân phiếu của đào phạm", 176 },
        { "Hòa thượng bỏ trốn", 183 },
        { "Bạc của Đào Hoa Kiếm", 390 },
        { "Thư của Thiên Mục đạo trưởng", 188 },
        { "Thiên Nhẫn Mật Lệnh", 184 },
        { "Cờ nhỏ Thiên Nhẫn", 1 },
        { "Trang phục Thiên Vương Bang", 323 },
        { "Yêu bài Thiên Vương Bang", 171 },
        { "Thư từ Thiên Vương phân đà", 133 },
        { "Hài cốt của tăng nhân Thiên Trúc", 107 },
        { "Chìa khóa rương sắt", 328 },
        { "Gương đồng", 353 },
        { "Cơ quan gương đồng", 202 },
        { "Cơ quan gương đồng 2", 215 },
        { "Cơ quan gương đồng 3", 216 },
        { "Cơ quan gương đồng 4", 217 },
        { "Thổ Phục Linh", 30 },
        { "Cọc đất", 348 },
      },
    },
    {
      "Chữ V",
      {
        { "Phù Siêu Độ Vong Linh", 110 },
        { "Cỏ Vong Ưu", 15 },
        { "Thuốc giải Vong Ưu Đan", 92 },
        { "Thư liên lạc giả mạo", 5 },
        { "Thư không đề tên", 169 },
        { "Cỏ Ôn Nhuận", 181 },
        { "Ô Kim Trường Kiếm", 47 },
        { "Cỏ vô danh", 320 },
        { "Cờ hiệu Ngũ Độc Giáo", 14 },
        { "Cọc của đội 5", 341 },
        { "Sách Ngũ Hành", 413 },
        { "Hài cốt của cao thủ võ lâm", 155 },
      },
    },
    {
      "Chữ X",
      {
        { "Cờ hiệu phương Tây", 75 },
        { "Dưa hấu", 8 },
        { "Danh sách gián điệp", 53 },
        { "Túi thơm Tiên Hương", 21 },
        { "Hương khói", 82 },
        { "Quả sồi", 182 },
        { "Tiêu Thạch Tán", 324 },
        { "Pháo hoa của Tiểu Man", 333 },
        { "Cỏ Tiểu Thiệt", 157 },
        { "Giấy bùa đầy bùa chú", 351 },
        { "Đầu của Tạ Phi", 60 },
        { "Thư của Tạ Vũ Điền", 28 },
        { "Tâm Ý Chi Gian", 65 },
        { "Tín phù", 343 },
        { "Bồ câu đưa thư", 330 },
        { "Nhật ký của tín sứ", 334 },
        { "Cỏ Tinh Tinh", 17 },
        { "Cỏ Hùng Đảm", 3 },
        { "Thịt gấu", 412 },
        { "Tay gấu", 198 },
        { "Giấy Tuyên", 11 },
        { "Cáo thị treo thưởng", 373 },
        { "Tai đẫm máu", 357 },
      },
    },
    {
      "Chữ Y",
      {
        { "Pháo hoa", 145 },
        { "Pháo hoa 2_Ngoại trủng", 206 },
        { "Pháo hoa 3_Ngoại trủng", 207 },
        { "Pháo hoa 4_Ngoại trủng", 208 },
        { "Thuốc rắn hổ mang", 172 },
        { "Di thư của Yến Tiểu Lục", 131 },
        { "Bản đồ Yến Tử Ổ", 149 },
        { "Dương Châu Trắc Thiên Đài", 383 },
        { "Dương Phù", 69 },
        { "Đầu nam tử Dao Sơn Bộ", 20 },
        { "Đầu của Diệp Long Tiên", 56 },
        { "Dạ Quang Bôi", 364 },
        { "Dạ Minh Châu", 102 },
        { "Cọc của đội 1", 337 },
        { "Một lá thư", 85 },
        { "Một vạn lượng bạc", 142 },
        { "Một tờ giấy (Chín mươi chín)", 104 },
        { "Âm Phù", 68 },
        { "Ngân Thiềm Yêu Bài", 154 },
        { "Ngân phiếu", 129 },
        { "Ám ký của Ảnh Giả", 13 },
        { "Du Long Quyết", 200 },
        { "Du Long Quyết", 325 },
        { "Mật hàm của Ngu Tẩu", 302 },
        { "Tiền Du", 6 },
        { "Phật Ngọc", 376 },
        { "Bản dịch Ngọc Giản", 378 },
        { "Ngọc Tủy Phi Phụng", 392 },
        { "Gối của Dụ bà bà", 81 },
        { "Quạt ngự ban", 308 },
        { "Dụng cụ ngự dụng", 372 },
      },
    },
    {
      "Chữ Z",
      {
        { "Tặc Huyệt Tàng Trân", 304 },
        { "Đầu lâu của Trương Sinh", 362 },
        { "Râu của Chân Nhân", 43 },
        { "Giấy và bút", 388 },
        { "Đầu của Chu Quang Chiếu", 57 },
        { "Chu Hồng Đan", 166 },
        { "Chu Hồng Quả", 156 },
        { "Thư tay của Chu Hy", 100 },
        { "Bình chứa đầy Linh Tuyền", 314 },
        { "Bình chứa bột lạ", 368 },
        { "Túy hán bắt được", 144 },
        { "Tử La Lan", 16 },
        { "Tử Tinh Mẫu Đơn", 139 },
        { "Tử Ngọc Băng Xà", 118 },
        { "Quặng Tử Ngọc", 99 },
      },
    },
  },
}

local _tbSkillItems = {
  { "Tay", { 1, 1, 1, 1, 1, 0, 255, nil, 0, 0 } },
  { "Kiếm", { 1, 1, 2, 1, 1, 0, 255, nil, 0, 0 } },
  { "Đao", { 1, 1, 3, 1, 1, 0, 255, nil, 0, 0 } },
  { "Côn", { 1, 1, 4, 1, 1, 0, 255, nil, 0, 0 } },
  { "Thương", { 1, 1, 5, 1, 1, 0, 255, nil, 0, 0 } },
  { "Chùy", { 1, 1, 6, 1, 1, 0, 255, nil, 0, 0 } },
  { "Phi tiêu", { 1, 2, 1, 1, 1, 0, 255, nil, 0, 0 } },
  { "Phi đao", { 1, 2, 2, 1, 1, 0, 255, nil, 0, 0 } },
  { "Tụ tiễn", { 1, 2, 3, 1, 1, 0, 255, nil, 0, 0 } },
}

local _tbHorseItems = {
  {
    { "Mã bài (Táo Hồng Mã)", { 1, 12, 1, 1 } },
    { "Mã bài (Thanh Mã)", { 1, 12, 2, 1 } },
    { "Mã bài (Đại Uyển Mã)", { 1, 12, 3, 2 } },
    { "Mã bài (Ô Truy)", { 1, 12, 4, 2 } },
    { "Mã bài (Ô Vân Đạp Tuyết)", { 1, 12, 5, 3 } },
    { "Mã bài (Đích Lô)", { 1, 12, 6, 3 } },
  },
  {
    { "Mã bài (Tuyệt Ảnh)", { 1, 12, 7, 3 } },
    { "Mã bài (Dạ Chiếu Ngọc Sư Tử)", { 1, 12, 8, 3 } },
    { "Mã bài (Hãn Huyết Bảo Mã)", { 1, 12, 9, 3 } },
    { "Mã bài (Xích Thố)", { 1, 12, 10, 4 } },
    { "Mã bài (Bôn Tiêu)", { 1, 12, 11, 4 } },
    { "Mã bài (Phiên Vũ)", { 1, 12, 12, 4 } },
  },
}

tb.tbMap = {}
for _, tbPos in ipairs(_tbMap) do
  local tbMap = tb.tbMap[tbPos[1]]
  if not tbMap then
    tbMap = {}
    tb.tbMap[tbPos[1]] = tbMap
  end
  tbMap[tbPos[2]] = { unpack(tbPos, 2) }
end

function tb:OnUse()
  if it.nParticular == 3 then
    self:OnTransPak(self.tbMap)
  elseif it.nParticular == 4 then
    self:OnSkillPak()
  elseif it.nParticular == 12 then
    self:OnTaskItemPak(self.tbItems)
  end
  return 0
end

function tb:OnTransPak(tbPosTb, szFrom)
  if type(tbPosTb[1]) == "string" then
    local nRet, szMsg = Map:CheckTagServerPlayerCount(tbPosTb[2])
    if nRet ~= 1 then
      me.Msg(szMsg)
      return 0
    end
    me.Msg(string.format("Ngồi cho vững, %s! (%d,%d,%d)", unpack(tbPosTb)))
    me.NewWorld(unpack(tbPosTb, 2))
    return
  end
  local tbOpt = {}
  local nCount = 9
  for szName, tbPos in next, tbPosTb, szFrom do
    if nCount <= 0 then
      tbOpt[#tbOpt] = { "Trang sau", self.OnTransPak, self, tbPosTb, tbOpt[#tbOpt - 1][1] }
      break
    end
    tbOpt[#tbOpt + 1] = { szName, self.OnTransPak, self, tbPos }
    nCount = nCount - 1
  end
  local tbGMItem = Item:GetClass("gmcard")
  tbOpt[#tbOpt + 1] = { "Chức năng thẻ GM", tbGMItem.OnUse, tbGMItem }
  tbOpt[#tbOpt + 1] = { "Kết thúc đối thoại" }
  Dialog:Say("Thích đi đâu thì đi đó! <pic=48>", tbOpt)
end

function tb:OnSkillPak()
  Dialog:Say("Học kỹ năng rồi, không gì là không thể! <pic=20>", {
    { "Tăng lên cấp 130!", self.LevelUp, self },
    { "Nhận trang bị vật phẩm", self.OpenItemAssit, self },
    --{"Các loại vũ khí (thỏa mãn giới hạn vũ khí của kỹ năng)", self.SelectItem, self},
    { "Rời môn phái & Tẩy điểm", self.ClearCall, self },
    { "Gia nhập môn phái", "Npc.tbMenPaiNpc:FactionDialog", Npc.tbMenPaiNpc.DialogMaster },
    { "Học tất cả kỹ năng sống", self.AddLifeSkill, self },
    (me.nFightState == 1 and { "Hủy trạng thái chiến đấu", me.SetFightState, 0 }) or { "Vào trạng thái chiến đấu", me.SetFightState, 1 },
    --{"Nhận Mã bài", self.SelectHorse, self, 1},
    { "Nhận 10 Cửu Chuyển Tục Mệnh Hoàn", self.AddItemJiuzhuan, self },
    { "Vứt bỏ tất cả vật phẩm trong túi", me.ThrowAllItem },
    { "Kết thúc đối thoại" },
  })
end

function tb:OnTaskItemPak(tbItems, nFrom)
  if type(tbItems[2]) == "number" then
    Dialog:AskNumber(string.format("Bao nhiêu [%s]?", tbItems[1]), 1, 100, self._OnAskItem, self, me, tbItems)
    me.Msg("Nếu client của ngài không hiển thị ô nhập số, hãy nhấn Enter, mặc định nhận một cái!")
    return
  end
  local tbOpt = {}
  local nCount = 9
  for nIndex = nFrom or 1, #tbItems[2] do
    if nCount <= 0 then
      tbOpt[#tbOpt] = { "Trang sau", self.OnTaskItemPak, self, tbItems, nIndex }
      break
    end
    tbOpt[#tbOpt + 1] = { tbItems[2][nIndex][1], self.OnTaskItemPak, self, tbItems[2][nIndex] }
    nCount = nCount - 1
  end
  tbOpt[#tbOpt + 1] = { "Kết thúc đối thoại" }
  Dialog:Say("Nhiệm vụ vô tận, tình duyên không dứt~<pic=11>\nVui lòng chọn vật phẩm nhiệm vụ ngài cần.", tbOpt)
end

function tb:LevelUp()
  ST_LevelUp(130 - me.nLevel)
  Timer:Register(18, self._OnTimer, self)
end

function tb:SelectItem()
  local tbOpt = {}
  for _, tbItem in pairs(_tbSkillItems) do
    tbOpt[#tbOpt + 1] = { tbItem[1], Item.AddPlayerItem, me, unpack(tbItem[2]) }
  end
  tbOpt[#tbOpt + 1] = { "Kết thúc đối thoại" }
  Dialog:Say("Ngươi muốn loại vũ khí nào <pic=44>", tbOpt)
end

function tb:SelectHorse(nPageIdx)
  local tbOpt = {}
  for _, tbItem in pairs(_tbHorseItems[nPageIdx]) do
    tbItem[2][8] = 0
    tbOpt[#tbOpt + 1] = { tbItem[1], Item.AddPlayerItem, me, unpack(tbItem[2]) }
  end
  if nPageIdx == 1 then
    tbOpt[#tbOpt + 1] = { "Trang sau>>", self.SelectHorse, self, 2 }
  else
    tbOpt[#tbOpt + 1] = { "<<Trang trước", self.SelectHorse, self, 1 }
  end
  tbOpt[#tbOpt + 1] = { "Kết thúc đối thoại" }
  Dialog:Say("Ngươi muốn loại Mã bài nào <pic=44>", tbOpt)
end

function tb:SelectHorse(nPageIdx)
  local tbOpt = {}
  for _, tbItem in pairs(_tbHorseItems[nPageIdx]) do
    tbOpt[#tbOpt + 1] = { tbItem[1], Item.AddPlayerItem, me, unpack(tbItem[2]) }
  end
  if nPageIdx == 1 then
    tbOpt[#tbOpt + 1] = { "Trang sau>>", self.SelectHorse, self, 2 }
  else
    tbOpt[#tbOpt + 1] = { "<<Trang trước", self.SelectHorse, self, 1 }
  end
  tbOpt[#tbOpt + 1] = { "Kết thúc đối thoại" }
  Dialog:Say("Ngươi muốn loại Mã bài nào <pic=44>", tbOpt)
end

function tb:ClearCall()
  me.ResetFightSkillPoint()
  me.JoinFaction(0)
  me.SetTask(2, 1, 1)
  me.UnAssignPotential()
  me.Msg("Ngươi đã trở thành gà mờ!")
end

function tb:OpenItemAssit()
  me.CallClientScript({ "UiManager:OpenWindow", "UI_ITEM_ASSIT" })
end

function tb:AddLifeSkill()
  for i = 1, 10 do
    LifeSkill:AddLifeSkill(me, i, 1)
  end
  for i = 1, 23 do
    LifeSkill:AddSkillExp(me, i, 3000000)
  end
  me.Msg("Ngươi đã không gì là không thể!")
end

function tb:_OnTimer()
  me.RestoreMana()
  me.RestoreLife()
  me.RestoreStamina()
  return 0
end

function tb:_OnAskItem(pPlayer, tbItem, nCount)
  pPlayer.Msg(string.format("Cất cho kỹ, %s x %d！(20,1,%d,1)", tbItem[1], nCount, tbItem[2]))
  for i = 1, nCount do
    pPlayer.AddQuest(1, tbItem[2], 1)
  end
end

function tb:AddItemJiuzhuan()
  for i = 1, 10 do
    Item.AddPlayerItem(me, 18, 1, 24, 1)
  end
end

function Item.AddPlayerItem(pPlayer, nGenre, nDetail, nParticular, nLevel, nSeries, nEnhTimes, nLucky, nVersion, uRandSeed)
  return KItem.AddPlayerItem(pPlayer, nGenre, nDetail, nParticular, nLevel, nSeries or Env.SERIES_NONE, nEnhTimes or 0, nLucky or 0, nil, nil, nVersion or 0, uRandSeed or 0)
end
