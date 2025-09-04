-- Sử dụng cho máy chủ test
if EventManager.IVER_bOpenTiFu ~= 1 then
  return
end

-- Nhân vật chuyên dùng cho trải nghiệm Tống Kim

local tbNpcBai = Npc:GetClass("tmpnpc_tifu")

tbNpcBai.nTaskGroupId = 2051
tbNpcBai.nTaskId1 = 1 -- Cờ hiệu nhận Mã Bài
tbNpcBai.nTaskId2 = 2 -- Cờ hiệu nhận túi đồ, Bạc
tbNpcBai.nTaskId3 = 5 -- Cờ hiệu nhận vật phẩm cơ bản
tbNpcBai.nTaskIdFactionRoutes = 6 -- Ghi lại biến sử dụng cho mỗi hướng của tất cả môn phái (6 - 30)!!!!!!!!!!!
tbNpcBai.nTaskIdFactionRoutesEnd = 30
tbNpcBai.nSongjin_70Level = 130 -- Cấp độ người chơi được nâng lên trong trải nghiệm Tống Kim
tbNpcBai.nWeaponLevel = 10 -- Cấp vũ khí trong trải nghiệm Tống Kim
tbNpcBai.nArmor_Level = 10 -- Cấp phòng cụ trong trải nghiệm Tống Kim
tbNpcBai.nEnhanceLevel = 14 -- Cấp cường hóa trang bị trong trải nghiệm Tống Kim (15 sửa)
tbNpcBai.nMijiLevel = 110 -- Cấp Mật Tịch
tbNpcBai.nTaskId_Partner = 10 -- Biến nhiệm vụ trang bị đồng hành
tbNpcBai.nPartnerTemp = 6801 -- ID khuôn mẫu NPC tặng đồng hành
tbNpcBai.nPotentialMax = 218

tbNpcBai.tbSkillList = {
  { 1493, 1504, 1511, 1515, 1517, 1522 }, -- Kim
  { 1496, 1507, 1511, 1515, 1518, 1522 }, -- Mộc
  { 1495, 1506, 1511, 1515, 1519, 1522 }, -- Thủy
  { 1492, 1503, 1511, 1515, 1520, 1522 }, -- Hỏa
  { 1494, 1505, 1511, 1515, 1521, 1522 }, -- Thổ
}

tbNpcBai.tbHorse_60Level = {
  { 1, 12, 5, 3, -1 },
  { 1, 12, 6, 3, -1 },
  { 1, 12, 7, 3, -1 },
  { 1, 12, 8, 3, -1 },
  { 1, 12, 9, 3, -1 },
} -- Ngựa cấp 90
tbNpcBai.tbExbag_20Grid = { 21, 8, 1, 1 } -- Túi 20 ô
tbNpcBai.nAddedKarmaPerTime = 3000 -- Mỗi lần tăng 500 điểm tu vi
tbNpcBai.nAddedMoney = 1000000 -- Mỗi lần chọn tùy chọn tặng Đồng có thể nhận 100w Đồng
tbNpcBai.nBindMoney = 10000000 -- Bạc khóa
tbNpcBai.nBindCoin = 10000 -- Đồng khóa
tbNpcBai.nExbagItem = {} -- Túi 20 ô
tbNpcBai.tbAddedItem = { -- Trang bị tím cấp 60
  { -- Thiếu Lâm
    { -- Đao Thiếu Lâm
      [0] = { -- Nam
        { 2, 1, 727 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 }, -- meleeweapon.txt
        { 2, 3, 828 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 }, -- Áo armor
        { 2, 9, 826 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 }, -- Nón helm
        { 2, 8, 406 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 }, -- Đai lưng belt
        { 2, 7, 408 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 }, -- Giày boots
        { 2, 10, 680 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 }, -- Bao tay cuff
        { 2, 5, 206 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 }, -- Dây chuyền necklace
        { 2, 4, 250 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 }, -- Nhẫn ring
        { 2, 11, 406 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 }, -- Ngọc Bội pendant
        { 2, 6, 207 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 }, -- Bùa hộ thân amulet
        { 1, 14, 1, 2, -1 },
      },
      [1] = { -- Nữ
        { 2, 1, 727 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 838 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 836 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 416 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 418 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 685 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 206 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 250 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 416 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 207 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 1, 2, -1 },
      },
    },
    { -- 	Côn Thiếu Lâm
      [0] = {
        { 2, 1, 737 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 808 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 806 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 406 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 408 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 680 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 206 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 250 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 406 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 207 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 2, 2, -1 },
      },
      [1] = {
        { 2, 1, 737 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 818 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 816 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 416 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 418 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 685 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 206 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 250 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 416 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 207 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 2, 2, -1 },
      },
    },
  },
  { -- Thiên Vương
    { -- 	Thương Thiên Vương
      [0] = {
        { 2, 1, 747 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 808 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 806 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 406 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 408 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 680 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 206 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 250 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 406 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 207 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 3, 2, -1 },
      },
      [1] = {
        { 2, 1, 747 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 818 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 816 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 416 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 418 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 685 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 206 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 250 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 416 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 207 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 3, 2, -1 },
      },
    },
    { --	Chùy Thiên Vương
      [0] = {
        { 2, 1, 757 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 808 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 806 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 406 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 408 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 680 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 206 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 250 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 506 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 207 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 4, 2, -1 },
      },
      [1] = {
        { 2, 1, 757 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 818 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 816 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 416 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 418 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 685 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 206 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 250 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 416 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 207 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 4, 2, -1 },
      },
    },
  },
  { -- Đường Môn
    { -- Bẫy Đường Môn
      [0] = {
        { 2, 2, 86 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 }, -- rangeweapon.txt
        { 2, 3, 848 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 846 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 426 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 428 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 683 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 216 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 247 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 426 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 217 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 5, 2, -1 },
      },
      [1] = {
        { 2, 2, 86 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 858 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 856 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 436 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 438 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 688 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 216 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 247 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 436 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 217 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 5, 2, -1 },
      },
    },
    { -- 	Tụ Tiễn Đường
      [0] = {
        { 2, 2, 96 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 }, -- rangeweapon.txt
        { 2, 3, 848 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 846 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 426 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 428 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 683 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 216 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 247 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 426 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 217 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 6, 2, -1 },
      },
      [1] = {
        { 2, 2, 96 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 858 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 856 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 436 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 438 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 688 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 216 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 247 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 436 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 217 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 6, 2, -1 },
      },
    },
  },
  { -- Ngũ Độc
    { -- Đao Độc
      [0] = {
        { 2, 1, 767 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 848 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 846 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 426 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 428 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 683 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 216 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 247 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 426 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 217 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 7, 2, -1 },
      },
      [1] = {
        { 2, 1, 767 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 858 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 856 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 436 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 438 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 688 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 216 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 447 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 436 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 217 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 7, 2, -1 },
      },
    },
    { -- Chưởng Độc
      [0] = {
        { 2, 1, 777 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 868 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 866 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 426 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 428 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 428 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 216 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 216 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 426 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 217 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 8, 2, -1 },
      },
      [1] = {
        { 2, 1, 777 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 878 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 876 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 436 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 438 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 438 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 216 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 216 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 436 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 217 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 8, 2, -1 },
      },
    },
  },
  { -- Nga Mi
    { -- Chưởng Nga Mi
      [0] = {
        { 2, 1, 807 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 908 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 906 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 446 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 448 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 448 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 226 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 226 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 446 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 227 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 9, 2, -1 },
      },
      [1] = {
        { 2, 1, 807 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 918 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 916 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 456 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 458 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 458 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 226 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 226 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 456 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 227 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 9, 2, -1 },
      },
    },
    { -- Hỗ trợ
      [0] = {
        { 2, 1, 817 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 908 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 906 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 446 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 448 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 448 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 226 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 226 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 446 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 227 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 10, 2, -1 },
      },
      [1] = {
        { 2, 1, 817 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 918 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 916 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 456 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 458 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 458 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 226 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 226 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 456 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 227 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 10, 2, -1 },
      },
    },
  },
  { -- Thúy Yên
    { -- Kiếm Thúy
      [0] = {
        { 2, 1, 817 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 908 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 906 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 446 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 448 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 448 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 226 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 226 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 446 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 227 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 11, 2, -1 },
      },
      [1] = {
        { 2, 1, 817 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 918 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 916 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 456 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 458 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 458 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 226 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 226 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 456 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 227 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 11, 2, -1 },
      },
    },
    { -- Đao Thúy
      [0] = {
        { 2, 1, 787 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 908 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 906 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 446 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 448 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 682 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 226 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 251 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 446 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 227 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 12, 2, -1 },
      },
      [1] = {
        { 2, 1, 787 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 918 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 916 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 456 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 458 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 687 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 226 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 251 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 456 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 227 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 12, 2, -1 },
      },
    },
  },
  { -- Cái Bang
    { -- Chưởng Cái
      [0] = {
        { 2, 1, 847 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 748 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 746 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 366 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 368 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 468 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 186 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 236 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 366 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 187 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 13, 2, -1 },
      },
      [1] = {
        { 2, 1, 847 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 758 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 756 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 376 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 378 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 478 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 186 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 236 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 376 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 187 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 13, 2, -1 },
      },
    },
    { -- Côn Cái
      [0] = {
        { 2, 1, 827 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 748 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 746 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 366 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 368 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 679 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 186 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 249 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 366 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 187 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 14, 2, -1 },
      },
      [1] = {
        { 2, 1, 827 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 758 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 756 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 376 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 378 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 684 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 186 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 249 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 376 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 187 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 14, 2, -1 },
      },
    },
  },
  { -- Thiên Nhẫn
    { -- Chiến Nhẫn
      [0] = {
        { 2, 1, 837 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 728 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 726 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 366 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 368 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 679 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 186 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 249 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 366 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 187 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 15, 2, -1 },
      },
      [1] = {
        { 2, 1, 837 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 738 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 736 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 376 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 378 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 684 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 186 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 249 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 376 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 187 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 15, 2, -1 },
      },
    },
    { -- Ma Nhẫn
      [0] = {
        { 2, 1, 857 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 748 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 746 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 366 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 368 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 468 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 186 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 236 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 366 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 187 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 16, 2, -1 },
      },
      [1] = {
        { 2, 1, 857 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 758 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 756 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 376 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 378 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 478 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 186 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 236 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 376 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 187 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 16, 2, -1 },
      },
    },
  },
  { -- Võ Đang
    { -- Khí Võ
      [0] = {
        { 2, 1, 887 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 988 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 986 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 486 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 488 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 488 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 246 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 246 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 486 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 247 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 17, 2, -1 },
      },
      [1] = {
        { 2, 1, 887 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 998 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 996 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 496 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 498 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 498 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 246 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 246 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 496 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 247 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 17, 2, -1 },
      },
    },
    { -- Kiếm Võ
      [0] = {
        { 2, 1, 877 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 968 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 966 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 486 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 488 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 681 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 246 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 248 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 486 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 247 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 18, 2, -1 },
      },
      [1] = {
        { 2, 1, 877 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 978 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 976 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 496 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 498 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 686 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 246 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 248 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 496 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 247 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 18, 2, -1 },
      },
    },
  },
  { -- Côn Lôn
    { -- Đao Côn
      [0] = {
        { 2, 1, 867 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 988 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 986 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 486 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 488 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 681 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 246 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 248 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 486 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 247 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 19, 2, -1 },
      },
      [1] = {
        { 2, 1, 867 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 998 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 996 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 496 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 498 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 686 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 246 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 248 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 496 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 247 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 19, 2, -1 },
      },
    },
    { -- Kiếm Côn
      [0] = {
        { 2, 1, 897 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 988 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 986 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 486 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 488 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 488 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 246 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 246 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 486 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 247 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 20, 2, -1 },
      },
      [1] = {
        { 2, 1, 897 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 998 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 996 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 496 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 498 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 498 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 246 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 246 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 496 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 247 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 20, 2, -1 },
      },
    },
  },
  { -- Minh Giáo
    { -- Chùy Minh Giáo
      [0] = {
        { 2, 1, 987 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 848 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 846 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 426 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 428 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 683 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 216 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 247 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 426 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 217 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 21, 2, -1 },
      },
      [1] = {
        { 2, 1, 987 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 858 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 856 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 436 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 438 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 688 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 216 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 247 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 436 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 217 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 21, 2, -1 },
      },
    },
    { -- Kiếm Minh Giáo
      [0] = {
        { 2, 1, 977 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 868 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 866 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 426 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 428 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 428 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 216 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 216 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 426 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 217 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 22, 2, -1 },
      },
      [1] = {
        { 2, 1, 977 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 878 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 876 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 436 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 438 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 438 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 216 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 216 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 436 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 217 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 22, 2, -1 },
      },
    },
  },
  { -- Đoàn Thị
    { -- Chỉ Đoàn Thị
      [0] = {
        { 2, 1, 797 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 908 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 906 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 446 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 448 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 682 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 226 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 251 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 446 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 227 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 23, 2, -1 },
      },
      [1] = {
        { 2, 1, 797 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 918 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 916 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 456 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 458 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 687 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 226 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 251 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 456 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 227 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 23, 2, -1 },
      },
    },
    { -- Khí Đoàn Thị
      [0] = {
        { 2, 1, 817 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 908 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 906 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 446 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 448 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 448 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 226 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 226 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 446 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 227 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 24, 2, -1 },
      },
      [1] = {
        { 2, 1, 817 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 918 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 916 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 456 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 458 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 458 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 226 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 226 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 456 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 227 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 24, 2, -1 },
      },
    },
  },
  { -- Cổ Mộ
    { -- Kiếm Cổ Mộ
      [0] = {
        { 2, 1, 1512 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 1472 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 1086 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 641 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 488 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 488 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 336 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 246 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 699 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 247 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 25, 2, -1 },
      },
      [1] = {
        { 2, 1, 1512 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 1462 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 1096 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 646 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 498 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 498 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 336 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 246 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 692 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 247 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 26, 2, -1 },
      },
    },
    { -- Châm Cổ Mộ
      [0] = {
        { 2, 2, 210 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 1472 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 1086 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 641 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 488 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 488 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 336 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 246 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 699 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 247 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 24, 2, -1 },
      },
      [1] = {
        { 2, 2, 210 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 },
        { 2, 3, 1462 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 9, 1096 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 8, 646 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 7, 498 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 10, 498 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 5, 336 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 4, 246 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 11, 692 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 2, 6, 247 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
        { 1, 14, 24, 2, -1 },
      },
    },
  },
}

tbNpcBai.tbArmorsList = { --series,sex,physical,Nguyên liệu,Genre,DetailType,ParticularType,Level
  { 1, 0, 1, -1, 4, 10, 1, 10 },
  { 2, 0, 1, -1, 4, 10, 7, 10 },
  { 3, 0, 1, -1, 4, 10, 19, 10 },
  { 4, 0, 1, -1, 4, 10, 31, 10 },
  { 5, 0, 1, -1, 4, 10, 43, 10 },
  { 1, 1, 1, -1, 4, 10, 2, 10 },
  { 2, 1, 1, -1, 4, 10, 8, 10 },
  { 3, 1, 1, -1, 4, 10, 20, 10 },
  { 4, 1, 1, -1, 4, 10, 32, 10 },
  { 5, 1, 1, -1, 4, 10, 44, 10 },
  { 1, 1, 2, -1, 4, 10, 436, 10 },
  { 2, 1, 2, -1, 4, 10, 10, 10 },
  { 3, 1, 2, -1, 4, 10, 22, 10 },
  { 4, 1, 2, -1, 4, 10, 34, 10 },
  { 5, 1, 2, -1, 4, 10, 46, 10 },
  { 1, 0, 2, -1, 4, 10, 435, 10 },
  { 2, 0, 2, -1, 4, 10, 9, 10 },
  { 3, 0, 2, -1, 4, 10, 21, 10 },
  { 4, 0, 2, -1, 4, 10, 33, 10 },
  { 5, 0, 2, -1, 4, 10, 45, 10 },
  { 1, 0, -1, -1, 4, 11, 1, 10 },
  { 2, 0, -1, -1, 4, 11, 7, 10 },
  { 3, 0, -1, -1, 4, 11, 13, 10 },
  { 4, 0, -1, -1, 4, 11, 19, 10 },
  { 5, 0, -1, -1, 4, 11, 25, 10 },
  { 1, 1, -1, -1, 4, 11, 2, 10 },
  { 2, 1, -1, -1, 4, 11, 8, 10 },
  { 3, 1, -1, -1, 4, 11, 14, 10 },
  { 4, 1, -1, -1, 4, 11, 20, 10 },
  { 5, 1, -1, -1, 4, 11, 26, 10 },
  { 1, 0, -1, -1, 4, 7, 1, 10 },
  { 2, 0, -1, -1, 4, 7, 7, 10 },
  { 3, 0, -1, -1, 4, 7, 13, 10 },
  { 4, 0, -1, -1, 4, 7, 19, 10 },
  { 5, 0, -1, -1, 4, 7, 25, 10 },
  { 1, 1, -1, -1, 4, 7, 2, 10 },
  { 2, 1, -1, -1, 4, 7, 8, 10 },
  { 3, 1, -1, -1, 4, 7, 14, 10 },
  { 4, 1, -1, -1, 4, 7, 20, 10 },
  { 5, 1, -1, -1, 4, 7, 26, 10 },
  { 2, 0, -1, "Vải", 4, 3, 35, 10 },
  { 3, 0, -1, "Vải", 4, 3, 41, 10 },
  { 5, 0, -1, "Vải", 4, 3, 47, 10 },
  { 1, 0, -1, "Da", 4, 3, 53, 10 },
  { 2, 0, -1, "Da", 4, 3, 59, 10 },
  { 4, 0, -1, "Da", 4, 3, 65, 10 },
  { 1, 0, -1, "Thiết", 4, 3, 71, 10 },
  { 3, 0, -1, "Thiết", 4, 3, 77, 10 },
  { 4, 0, -1, "Thiết", 4, 3, 83, 10 },
  { 5, 0, -1, "Thiết", 4, 3, 89, 10 },
  { 2, 1, -1, "Vải", 4, 3, 36, 10 },
  { 3, 1, -1, "Vải", 4, 3, 42, 10 },
  { 5, 1, -1, "Vải", 4, 3, 48, 10 },
  { 1, 1, -1, "Da", 4, 3, 54, 10 },
  { 2, 1, -1, "Da", 4, 3, 60, 10 },
  { 4, 1, -1, "Da", 4, 3, 66, 10 },
  { 1, 1, -1, "Thiết", 4, 3, 72, 10 },
  { 3, 1, -1, "Thiết", 4, 3, 78, 10 },
  { 4, 1, -1, "Thiết", 4, 3, 84, 10 },
  { 5, 1, -1, "Thiết", 4, 3, 90, 10 },
  { 1, -1, -1, -1, 4, 6, 94, 10 },
  { 2, -1, -1, -1, 4, 6, 99, 10 },
  { 3, -1, -1, -1, 4, 6, 104, 10 },
  { 4, -1, -1, -1, 4, 6, 109, 10 },
  { 5, -1, -1, -1, 4, 6, 114, 10 },
  { 1, -1, 1, -1, 4, 4, 118, 10 },
  { 2, -1, 1, -1, 4, 4, 121, 10 },
  { 3, -1, 1, -1, 4, 4, 127, 10 },
  { 4, -1, 1, -1, 4, 4, 133, 10 },
  { 5, -1, 1, -1, 4, 4, 139, 10 },
  { 1, -1, 2, -1, 4, 4, 443, 10 },
  { 2, -1, 2, -1, 4, 4, 124, 10 },
  { 3, -1, 2, -1, 4, 4, 130, 10 },
  { 4, -1, 2, -1, 4, 4, 136, 10 },
  { 5, -1, 2, -1, 4, 4, 142, 10 },
  { 2, 0, -1, "Vải", 4, 9, 197, 10 },
  { 3, 0, -1, "Vải", 4, 9, 217, 10 },
  { 5, 0, -1, "Vải", 4, 9, 257, 10 },
  { 1, 0, -1, "Da", 4, 9, 177, 10 },
  { 2, 0, -1, "Da", 4, 9, 195, 10 },
  { 4, 0, -1, "Da", 4, 9, 237, 10 },
  { 1, 0, -1, "Thiết", 4, 9, 175, 10 },
  { 3, 0, -1, "Thiết", 4, 9, 215, 10 },
  { 4, 0, -1, "Thiết", 4, 9, 235, 10 },
  { 5, 0, -1, "Thiết", 4, 9, 255, 10 },
  { 1, 0, -1, -1, 4, 8, 341, 10 },
  { 2, 0, -1, -1, 4, 8, 361, 10 },
  { 3, 0, -1, -1, 4, 8, 381, 10 },
  { 4, 0, -1, -1, 4, 8, 401, 10 },
  { 5, 0, -1, -1, 4, 8, 421, 10 },
  { 1, 1, -1, -1, 4, 8, 342, 10 },
  { 2, 1, -1, -1, 4, 8, 362, 10 },
  { 3, 1, -1, -1, 4, 8, 382, 10 },
  { 4, 1, -1, -1, 4, 8, 402, 10 },
  { 5, 1, -1, -1, 4, 8, 422, 10 },
  { 1, -1, 1, -1, 4, 5, 266, 10 },
  { 2, -1, 1, -1, 4, 5, 274, 10 },
  { 3, -1, 1, -1, 4, 5, 290, 10 },
  { 4, -1, 1, -1, 4, 5, 306, 10 },
  { 5, -1, 1, -1, 4, 5, 322, 10 },
  { 1, -1, 2, -1, 4, 5, 446, 10 },
  { 2, -1, 2, -1, 4, 5, 282, 10 },
  { 3, -1, 2, -1, 4, 5, 298, 10 },
  { 4, -1, 2, -1, 4, 5, 314, 10 },
  { 5, -1, 2, -1, 4, 5, 330, 10 },
  { 2, 1, -1, "Vải", 4, 9, 198, 10 },
  { 3, 1, -1, "Vải", 4, 9, 218, 10 },
  { 5, 1, -1, "Vải", 4, 9, 258, 10 },
  { 1, 1, -1, "Da", 4, 9, 182, 10 },
  { 2, 1, -1, "Da", 4, 9, 200, 10 },
  { 4, 1, -1, "Da", 4, 9, 242, 10 },
  { 1, 1, -1, "Thiết", 4, 9, 180, 10 },
  { 3, 1, -1, "Thiết", 4, 9, 220, 10 },
  { 4, 1, -1, "Thiết", 4, 9, 240, 10 },
  { 5, 1, -1, "Thiết", 4, 9, 260, 10 },
  { 6, 0, 3, "Da", 4, 9, 267, 10 },
  { 6, 1, 3, "Da", 4, 9, 268, 10 },
  { 6, 0, 3, "Da", 4, 3, 247, 10 },
  { 6, 1, 3, "Da", 4, 3, 248, 10 },
  { 6, 0, 3, "Da", 4, 8, 429, 10 },
  { 6, 1, 3, "Da", 4, 8, 430, 10 },
  { 6, 0, 3, "Da", 4, 10, 43, 10 },
  { 6, 1, 3, "Da", 4, 10, 44, 10 },
  { 6, 0, 3, "Da", 4, 7, 25, 10 },
  { 6, 1, 3, "Da", 4, 7, 26, 10 },
  { 6, 0, 3, "Da", 4, 5, 326, 10 },
  { 6, 1, 3, "Da", 4, 5, 327, 10 },
  { 6, 0, 3, "Da", 4, 4, 139, 10 },
  { 6, 1, 3, "Da", 4, 4, 140, 10 },
  { 6, 0, 3, "Da", 4, 11, 25, 10 },
  { 6, 1, 3, "Da", 4, 11, 26, 10 },
  { 6, 0, 3, "Da", 4, 6, 114, 10 },
  { 6, 1, 3, "Da", 4, 6, 115, 10 },
  { 6, 0, 4, "Da", 4, 9, 267, 10 },
  { 6, 1, 4, "Da", 4, 9, 268, 10 },
  { 6, 0, 4, "Da", 4, 3, 247, 10 },
  { 6, 1, 4, "Da", 4, 3, 248, 10 },
  { 6, 0, 4, "Da", 4, 8, 429, 10 },
  { 6, 1, 4, "Da", 4, 8, 430, 10 },
  { 6, 0, 4, "Da", 4, 10, 45, 10 },
  { 6, 1, 4, "Da", 4, 10, 46, 10 },
  { 6, 0, 4, "Da", 4, 7, 25, 10 },
  { 6, 1, 4, "Da", 4, 7, 26, 10 },
  { 6, 0, 4, "Da", 4, 5, 330, 10 },
  { 6, 1, 4, "Da", 4, 5, 330, 10 },
  { 6, 0, 4, "Da", 4, 4, 142, 10 },
  { 6, 1, 4, "Da", 4, 4, 142, 10 },
  { 6, 0, 4, "Da", 4, 11, 25, 10 },
  { 6, 1, 4, "Da", 4, 11, 26, 10 },
  { 6, 0, 4, "Da", 4, 6, 114, 10 },
  { 6, 1, 4, "Da", 4, 6, 114, 10 },
}

tbNpcBai.tbFixList = {
  -- Hướng, Ngũ hành, Nội ngoại công, Giáp vải da
  { "Đao Thiếu", 1, 1, "Da" },
  { "Côn Thiếu", 1, 1, "Thiết" },
  { "Thương Thiên", 1, 1, "Thiết" },
  { "Chùy Thiên", 1, 1, "Thiết" },
  { "Bẫy Đường", 2, 1, "Da" },
  { "Tụ Tiễn", 2, 1, "Da" },
  { "Đao Độc", 2, 1, "Da" },
  { "Chưởng Độc", 2, 2, "Da" },
  { "Chưởng Nga", 3, 2, "Vải" },
  { "Hỗ Trợ Nga", 3, 2, "Vải" },
  { "Kiếm Thúy", 3, 2, "Vải" },
  { "Đao Thúy", 3, 1, "Vải" },
  { "Chưởng Cái", 4, 2, "Da" },
  { "Côn Cái", 4, 1, "Da" },
  { "Chiến Nhẫn", 4, 1, "Da" },
  { "Ma Nhẫn", 4, 2, "Da" },
  { "Khí Võ", 5, 2, "Vải" },
  { "Kiếm Võ", 5, 1, "Vải" },
  { "Đao Côn", 5, 1, "Vải" },
  { "Kiếm Côn", 5, 2, "Vải" },
  { "Chùy Minh", 2, 1, "Da" },
  { "Kiếm Minh", 2, 2, "Da" },
  { "Chỉ Đoàn", 3, 1, "Vải" },
  { "Khí Đoàn", 3, 2, "Vải" },
  { "Cổ Kiếm", 6, 3, "Da" }, -- Ngũ hành ở đây được phân biệt riêng (xung đột với hệ Thổ)
  { "Cổ Châm", 6, 4, "Da" }, -- Ngũ hành ở đây được phân biệt riêng (xung đột với hệ Thổ)
}

tbNpcBai.tbMidBook = { -- ID kỹ năng Mật Tịch Trung Cấp
  1200,
  1201,
  1202,
  1202,
  1203,
  1204,
  1205,
  1206,
  1207,
  1208,
  1209,
  1210,
  1211,
  1212,
  1213,
  1214,
  1215,
  1216,
  1217,
  1218,
  1219,
  1220,
  1221,
  1222,
  2815,
  2826,
}

tbNpcBai.tbHighBookSkill = { -- ID kỹ năng Mật Tịch Cao Cấp
  1241,
  1242,
  1243,
  1244,
  1245,
  1246,
  1247,
  1248,
  1249,
  1250,
  1251,
  1252,
  1253,
  1254,
  1255,
  1256,
  1257,
  1258,
  1259,
  1260,
  1261,
  1262,
  1263,
  1264,
  2816,
  2838,
}
-- Đối thoại
function tbNpcBai:OnDialog()
  -- Phải lên cấp 30 mới có tư cách
  if me.nLevel < 30 then
    Dialog:Say("Cấp độ không đủ 30, ngài có thể chọn tiếp tục trải nghiệm nhiệm vụ tân thủ rồi quay lại.")
    return
  end
  Dialog:Say("Phương án nhân vật máy chủ test", {
    { "<color=yellow>Nâng cấp thành nhân vật máy chủ test<color>", self.LevelUpPlayer, self, 1 },
    { "Nhận kỹ năng Mã Bài phái Cổ Mộ", self.GetGumuSkill, self },
    { "Nhận trang bị máy chủ test", self.GetEquipFaction, self, 1 },
    { "Nhận Mật Tịch Trung Cấp và Cao Cấp", self.GetMiJiBook, self },
    --	{"Nhận ngựa cấp 90", self.GetHorse_60Level, self},
    { "Tăng cấp Mật Tịch", self.LevelUpBook, self },
    { "Nhận Tu Luyện Châu để tẩy điểm vô hạn", self.GetXiuLianZhu, self },
    { "Nhận vật phẩm thường dùng", self.GetDailyItem, self },
    { "Mua Long Văn Ngân Tệ", self.SellLongwen, self },
    --{"Rời khỏi Linh Tú Thôn", self.GoOther, self},
    --{"Nhận và nâng cấp Ngũ Hành Ấn", self.UpDateWuXingYin, self},
    --{"Nhận vật phẩm cơ bản", self.GetSundries, self},
    --{"Nhận Dạ Minh Châu", self.GetYemingzhu, self},
    --{"Nhận đồng hành cấp 120", self.OnSelectPartner, self},
    --{"Nhận Tinh Phách đồng hành", self.GetJingpo, self},
    --{"Nhận Đồng và mở rộng túi đồ", self.AddMoneyAndExbag, self};
    { "Kết thúc đối thoại" },
  })
end

function tbNpcBai:GetGumuSkill()
  if me.nFaction ~= 13 then
    Dialog:Say("Chỉ có phái Cổ Mộ mới có thể nhận.")
    return
  end
  if me.GetSkillState(2894) > 0 then
    Dialog:Say("Ngài đã nhận rồi.")
    return
  end
  if me.nFaction == 13 then
    for i = 2894, 2899 do
      me.AddFightSkill(i, 50)
    end
  end
end

function tbNpcBai:GoOther()
  Npc:GetClass("chefu"):OnDialog()
end

function tbNpcBai:SellLongwen()
  me.OpenShop(177, 1)
end

function tbNpcBai:GetDailyItem()
  Dialog:Say("Nhận vật phẩm thường dùng", {
    { "Nhận áo choàng và đồng hành", self.GetMantleAndPartner, self },
    { "Nhận Tinh Phách đồng hành", self.GetJingpo, self },
    { "Nhận Dạ Minh Châu", self.GetYemingzhu, self },
    { "Nhận Giải Ngọc Chùy", self.GetJieYuChui, self },
    { "Nhận Kim Cang Toản", self.GetJInGangZ, self },
  })
end

function tbNpcBai:GetMantleAndPartner()
  local nNowDate = tonumber(GetLocalDate("%Y%m%d"))
  if me.GetTask(self.nTaskGroupId, self.nTaskId1) == nNowDate then
    Dialog:Say("Mỗi ngày chỉ có thể nhận một lần.")
    return 0
  end
  if me.GetHonorLevel() <= 7 then
    Dialog:Say("Cấp bậc Vinh Dự của ngài cần đạt Tiềm Long mới có thể nhận.")
    return 0
  end
  local pMantle = me.AddItem(1, 17, me.nSeries * 2 + me.nSex - 1, me.GetHonorLevel())
  if pMantle then
    pMantle.Bind(1)
    me.SetItemTimeout(pMantle, 24 * 60, 0)
  end
  self:GetPartners(me.GetHonorLevel() - 4) -- Đồng hành cấp 3

  me.SetTask(self.nTaskGroupId, self.nTaskId1, nNowDate)
end

function tbNpcBai:GetJieYuChui()
  if me.CountFreeBagCell() < 10 then
    Dialog:Say("Túi đồ của ngài không đủ 10 ô trống.")
    return 0
  end
  me.AddStackItem(18, 1, 1312, 1, { bForceBind = 1 }, 10)
end

function tbNpcBai:GetJInGangZ()
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("Túi đồ của ngài không đủ chỗ.")
    return 0
  end
  me.AddStackItem(18, 1, 1311, 1, { bForceBind = 1 }, 10)
end

-- Thêm đồng hành
function tbNpcBai:GetPartners(nSkillLevel)
  if me.nRouteId <= 0 then
    Dialog:Say("Chọn hướng tu luyện trước rồi hãy đến.", tbOpt)
    return
  end
  if not me.GetPartner(0) then
    Partner:AddPartner(me.nId, 2025, -1)
  end
  local pPartner = me.GetPartner(0)
  pPartner.DeleteAllSkill()
  Partner:AddFriendship(pPartner, 110 * 100)
  pPartner.SetValue(2, 120)
  local tbPartnerSkill = {
    { 1493, 1504, 1511, 1515, 1517, 1522 }, -- Kim
    { 1496, 1507, 1511, 1515, 1518, 1522 }, -- Mộc
    { 1495, 1506, 1511, 1515, 1519, 1522 }, -- Thủy
    { 1492, 1503, 1511, 1515, 1520, 1522 }, -- Hỏa
    { 1494, 1505, 1511, 1515, 1521, 1522 }, -- Thổ
  }

  local tbSkillId = tbPartnerSkill[me.nSeries]
  for i = 1, 6 do
    pPartner.AddSkill({ nId = tbSkillId[i], nLevel = nSkillLevel })
  end

  local INTTOALPOTENTIAL = 218 -- Tổng tiềm năng đồng hành
  local tbFactionPotential = {}
  local tbData = Lib:LoadTabFile("\\setting\\player\\attrib_route.txt")
  local nPot_v
  for _, tbRow in ipairs(tbData) do
    local nFaction = tonumber(tbRow.FACTION)
    local nRoute = tonumber(tbRow.ROUTE)
    local tbFaction = tbFactionPotential[nFaction]
    if not tbFaction then
      tbFaction = {}
      tbFactionPotential[nFaction] = tbFaction
    end
    tbFaction[nRoute] = {
      tonumber(tbRow.POTENTIAL_STRENGTH),
      tonumber(tbRow.POTENTIAL_DEXTERITY),
      tonumber(tbRow.POTENTIAL_VITALITY),
      tonumber(tbRow.POTENTIAL_ENERGY),
    }
  end
  for i = 1, 4 do
    nPot_v = INTTOALPOTENTIAL * tbFactionPotential[me.nFaction][me.nRouteId][i] / 10
    me.GetPartner(0).SetAttrib(i - 1, nPot_v)
  end
end

function tbNpcBai:OnSelectPartner()
  local nTask = me.GetTask(self.nTaskGroupId, self.nTaskId_Partner)
  if nTask >= 1 then
    me.Msg("Ngươi đã nhận phần thưởng này rồi!")
    return
  end

  if me.nSeries < 1 or me.nFaction < 1 then
    Partner:SendClientMsg("Hãy gia nhập môn phái trước rồi hãy đến!")
    me.Msg("Hãy gia nhập môn phái trước rồi hãy đến!")
    return
  end

  if me.nRouteId < 1 then
    Partner:SendClientMsg("Hãy chọn hướng tu luyện của môn phái trước!")
    me.Msg("Hãy chọn hướng tu luyện của môn phái trước!")
    return
  end

  if me.nPartnerCount >= me.nPartnerLimit then
    Partner:SendClientMsg("Số lượng đồng hành của ngươi đã đạt giới hạn!")
    me.Msg("Số lượng đồng hành của ngươi đã đạt giới hạn!")
    return
  end

  if Partner:AddPartner(me.nId, self.nPartnerTemp, me.nSeries) == 1 then
    local pPartner = me.GetPartner(me.nPartnerCount - 1) -- Lấy đồng hành vừa thêm
    self:SetPartnerAttrib(pPartner, me.nSeries)

    Partner:SendClientMsg(string.format("Ngươi đã nhận được đồng hành %s!", pPartner.szName))
    me.Msg(string.format("Ngươi đã nhận được đồng hành %s!", pPartner.szName))
  end

  me.SetTask(self.nTaskGroupId, self.nTaskId_Partner, 1)
end

function tbNpcBai:SetPartnerAttrib(pPartner, nSeries)
  -- Thiết lập cấp độ
  pPartner.SetValue(Partner.emKPARTNERATTRIBTYPE_LEVEL, 120)

  -- Thiết lập kỹ năng
  for i = 1, pPartner.nSkillCount do
    local tbSkill = pPartner.GetSkill(i - 1)
    tbSkill.nLevel = 3
    tbSkill.nId = self.tbSkillList[nSeries][i]
    pPartner.SetSkill(i - 1, tbSkill)
  end

  -- Thiết lập tiềm năng
  local tbCurPoten = Player.tbFactionPotential[me.nFaction][me.nRouteId]
  local nPotentailTemp = 0
  for nId, tb in pairs(Partner.tbPotentialTemp) do
    if tb.nStrength == tbCurPoten[1] and tb.nDexterity == tbCurPoten[2] and tb.nVitality == tbCurPoten[3] and tb.nEnergy == tbCurPoten[4] then
      nPotentailTemp = nId
      break
    end
  end
  pPartner.SetValue(Partner.emKPARTNERATTRIBTYPE_PotentialTemp, nPotentailTemp)
  for nAttribIndex = 0, 3 do
    pPartner.SetAttrib(nAttribIndex, 0)
  end
  -- Phân phối lại
  Partner:AddPotential_Pure(pPartner.nPartnerIndex, self.nPotentialMax)
end

function tbNpcBai:GetSundries()
  if me.GetTask(self.nTaskGroupId, self.nTaskId3) == 1 then
    Dialog:Say("Ngài đã nhận rồi.")
    return 0
  end
  if me.nRouteId <= 0 then
    Dialog:Say("Gia nhập môn phái trước rồi hãy đến.", tbOpt)
    return
  end
  if me.CountFreeBagCell() < 21 then
    Dialog:Say("Túi đồ của ngài không đủ chỗ.")
    return 0
  end
  -- Võ Lâm Mật Tịch và Tẩy Tủy Kinh
  for i = 1, 5 do
    me.AddItem(18, 1, 191, 1).Bind(1)
  end
  for i = 1, 5 do
    me.AddItem(18, 1, 191, 2).Bind(1)
  end
  for i = 1, 5 do
    me.AddItem(18, 1, 192, 1).Bind(1)
  end
  for i = 1, 5 do
    me.AddItem(18, 1, 192, 2).Bind(1)
  end
  -- Một chiếc áo choàng Sồ Phụng
  me.AddItem(1, 17, me.nSeries * 2 + me.nSex - 1, 7).Bind(1)
  me.SetTask(self.nTaskGroupId, self.nTaskId3, 1)
end

function tbNpcBai:GetYemingzhu()
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("Túi đồ của ngài không đủ chỗ.")
    return 0
  end
  me.AddStackItem(18, 1, 357, 1, { bForceBind = 1 }, 100)
end

function tbNpcBai:GetJingpo()
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("Túi đồ của ngài không đủ chỗ.")
    return 0
  end
  me.AddStackItem(18, 1, 544, 3, { bForceBind = 1 }, 10)
end

function tbNpcBai:GetItems(tbItemList, nFaction, nRouteId, nSex, nQianghua)
  if nRouteId <= 0 then
    return
  end
  for i = 1, #tbItemList do
    local nItemRouteId = (nFaction - 1) * 2 + nRouteId
    if nRouteId ~= 0 then
      if tbItemList[i][1] == self.tbFixList[nItemRouteId][2] or tbItemList[i][1] == -1 then
        if tbItemList[i][2] == nSex or tbItemList[i][2] == -1 then
          if tbItemList[i][3] == self.tbFixList[nItemRouteId][3] or tbItemList[i][3] == -1 then
            if tbItemList[i][4] == self.tbFixList[nItemRouteId][4] or tbItemList[i][4] == -1 then
              me.AddItem(tbItemList[i][5], tbItemList[i][6], tbItemList[i][7], tbItemList[i][8], -1, nQianghua).Bind(1)
            end
          end
        end
      end
    end
  end
end

function tbNpcBai:UpDateWuXingYin()
  local tbOpt = {
    { "Nhận Ngũ Hành Ấn cấp tối đa", self.GetWuXingYin, self },
    { "Ta chỉ xem qua thôi" },
  }
  Dialog:Say("Ngài muốn gì?", tbOpt)
end

function tbNpcBai:GetWuXingYin()
  if me.nFaction <= 0 then
    Dialog:Say("Phải gia nhập môn phái mới có thể nhận Ngũ Hành Ấn.")
    return 0
  end
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("Túi đồ của ngài không đủ chỗ.")
    return 0
  end
  local pItem = me.AddItem(1, 16, me.nFaction, 1)
  if pItem then
    pItem.Bind(1)
    Item:SetSignetMagic(pItem, 1, 1000, 0)
    Item:SetSignetMagic(pItem, 2, 1000, 0)
  end
  Dialog:Say("Ngài đã nhận thành công Ngũ Hành Ấn cấp tối đa.")
end

function tbNpcBai:UpWuXingYin(nMagicIndex)
  local pSignet = me.GetItem(Item.ROOM_EQUIP, Item.EQUIPPOS_SIGNET, 0)
  if not pSignet then
    Dialog:Say("Trên người ngài không có Ngũ Hành Ấn.")
    return 0
  end
  local nLevel = pSignet.GetGenInfo(nMagicIndex * 2 - 1, 0)
  if nLevel >= 1000 then
    Dialog:Say("Thuộc tính này của Ngũ Hành Ấn đã đạt cấp tối đa.")
    return 0
  end
  nLevel = nLevel + 150
  if nLevel > 1000 then
    nLevel = 1000
  end
  Item:SetSignetMagic(pSignet, nMagicIndex, nLevel, 0)
  Dialog:Say("Nâng cấp thuộc tính Ngũ Hành Ấn thành công, nếu thuộc tính chưa tối đa, ngài có thể tiếp tục tìm ta để nâng cấp.")
end

function tbNpcBai:GetXiuLianZhu()
  local nCount = me.GetItemCountInBags(18, 1, 16, 1)
  if nCount == 0 then
    local tbXiulianzhuItem = { 18, 1, 16, 1 }
    local tbBaseProp = KItem.GetItemBaseProp(unpack(tbXiulianzhuItem))
    if not tbBaseProp then
      return
    end

    local tbItem = {
      nGenre = tbXiulianzhuItem[1],
      nDetail = tbXiulianzhuItem[2],
      nParticular = tbXiulianzhuItem[3],
      nLevel = tbXiulianzhuItem[4],
      nSeries = (tbBaseProp.nSeries > 0) and tbBaseProp.nSeries or 0,
      bBind = KItem.IsItemBindByBindType(tbBaseProp.nBindType),
      nCount = 1,
    }

    if 0 == me.CanAddItemIntoBag(tbItem) then
      me.Msg("Túi đồ đã đầy")
      return
    end

    tbXiulianzhuItem[5] = tbItem.nSeries
    me.AddItem(unpack(tbXiulianzhuItem))
    me.Msg("Ngươi nhận được một viên Tu Luyện Châu!")
  else
    Dialog:Say("<color=red>Ngươi đã có Tu Luyện Châu rồi!<color>")
  end
end

function tbNpcBai:AddMoneyAndExbag()
  if me.GetTask(self.nTaskGroupId, self.nTaskId2) ~= 0 then
    Dialog:Say("Đã nhận Đồng và túi mở rộng rồi.")
    return 0
  end
  if me.CountFreeBagCell() < 3 then
    Dialog:Say("Túi đồ của ngài không đủ chỗ.")
    return 0
  end
  me.AddBindMoney(self.nBindMoney)
  me.AddBindCoin(self.nBindCoin)
  for i = 1, 3 do
    local pItem = me.AddItem(unpack(self.tbExbag_20Grid))
    if pItem then
      pItem.Bind(1)
    end
  end
  me.SetTask(self.nTaskGroupId, self.nTaskId2, 1)
end

function tbNpcBai:GetMiJiBook()
  if me.nFaction >= 1 and me.nFaction <= 13 then
    if me.CountFreeBagCell() < 4 then
      me.Msg("Túi đồ không đủ, vui lòng dọn ít nhất 4 ô trống!")
      return
    end

    -- Mật Tịch Trung Cấp
    me.AddItem(1, 14, me.nFaction * 2 - 1, 2)
    me.AddItem(1, 14, me.nFaction * 2, 2)

    -- Mật Tịch Cao Cấp
    me.AddItem(1, 14, me.nFaction * 2 - 1, 3)
    me.AddItem(1, 14, me.nFaction * 2, 3)

    -- Khinh công
    me.AddFightSkill(10, 20)

    -- Kỹ năng Mật Tịch Trung Cấp
    me.AddFightSkill(tbNpcBai.tbMidBook[me.nFaction * 2 - 1], 10) -- Kỹ năng Mật Tịch Trung Cấp
    me.AddFightSkill(tbNpcBai.tbMidBook[me.nFaction * 2], 10) -- Kỹ năng Mật Tịch Trung Cấp

    -- Kỹ năng Mật Tịch Cao Cấp
    me.AddFightSkill(tbNpcBai.tbHighBookSkill[me.nFaction * 2 - 1], 10) -- Kỹ năng Mật Tịch Trung Cấp
    me.AddFightSkill(tbNpcBai.tbHighBookSkill[me.nFaction * 2], 10) -- Kỹ năng Mật Tịch Trung Cấp
  elseif me.nFaction == 0 then
    Dialog:Say("Gia nhập môn phái trước mới có thể nhận Mật Tịch")
  end
end
-- Nâng cấp nhân vật
function tbNpcBai:LevelUpPlayer(nPosStartIdx)
  --if (me.nLevel >= self.nSongjin_70Level) then
  --	Dialog:Say("Đã lên đến cấp chỉ định.");
  --	return;
  --end

  if me.nFaction ~= 0 then
    self:JoinFactionLevelUp(me.nFaction)
    return
  end

  local tbOpt = {}
  local nCount = 9
  for i = nPosStartIdx, Player.FACTION_NUM do
    if nCount <= 0 then
      tbOpt[#tbOpt] = { "Trang sau", self.LevelUpPlayer, self, i - 1 }
      break
    end
    tbOpt[#tbOpt + 1] = { Player:GetFactionRouteName(i), self.JoinFactionLevelUp, self, i }
    nCount = nCount - 1
  end
  tbOpt[#tbOpt + 1] = { "Kết thúc đối thoại" }
  Dialog:Say("Gia nhập môn phái", tbOpt)
end

-- Gia nhập môn phái
function tbNpcBai:JoinFactionLevelUp(nIndex)
  if me.GetTask(self.nTaskGroupId, self.nTaskId2) ~= 0 then
    Dialog:Say("Đã lên cấp và nhận Đồng cùng túi mở rộng rồi.")
    return 0
  end
  if me.CountFreeBagCell() < 3 then
    Dialog:Say("Túi đồ của ngài không đủ chỗ.")
    return 0
  end
  if me.nFaction == 0 then
    local nSexLimit = Player.tbFactions[nIndex].nSexLimit
    if nSexLimit >= 0 and nSexLimit ~= me.nSex then
      me.Msg("Xin lỗi, môn phái này không nhận đệ tử " .. Player.SEX[me.nSex] .. "!")
      return
    end
    me.JoinFaction(nIndex)
    if nIndex == 13 then
      for i = 2894, 2899 do
        me.AddFightSkill(i, 50)
      end
    end
  end
  local nLevelUp = self.nSongjin_70Level - me.nLevel
  me.DirectChangeLevel(nLevelUp)
  me.CallClientScript({ "me.DirectChangeLevel", nLevelUp })
  me.AddBindMoney(self.nBindMoney)
  me.AddBindCoin(self.nBindCoin)
  for i = 1, 3 do
    local pItem = me.AddItem(unpack(self.tbExbag_20Grid))
    if pItem then
      pItem.Bind(1)
    end
  end
  me.SetTask(self.nTaskGroupId, self.nTaskId2, 1)
  me.SetTask(1022, 215, 4095) -- Học kỹ năng 110
  me.AddRepute(7, 1, 9000) -- Danh vọng liên đấu
  me.AddRepute(8, 1, 9000) -- Danh vọng lãnh thổ
  me.AddRepute(5, 3, 9000) -- Danh vọng Tiêu Dao
  me.AddRepute(9, 1, 12000) -- Danh vọng Tần Thủy Hoàng Lăng - Quan Phủ
  -- Tặng 100 triệu Bạc khóa
  me.AddGlbBindMoney(100000000)

  --me.SetTask(2027,230, 1);	--Có thể ra ngoài thông qua chuyên viên đổi tuyến
end

-- Nhận trang bị tím cấp 60 của môn phái
function tbNpcBai:GetEquipFaction(nPosStartIdx)
  local tbOpt = {}
  local nCount = 9
  if me.nFaction == 0 then
    Dialog:Say("Vui lòng nâng cấp nhân vật và gia nhập môn phái trước.")
    return 0
  end
  if me.nRouteId <= 0 then
    Dialog:Say("Chọn hướng tu luyện trước rồi hãy đến.")
    return
  end
  if me.GetTask(self.nTaskGroupId, self.nTaskIdFactionRoutes) == 1 then
    Dialog:Say("Mỗi nhân vật chỉ có thể nhận một bộ trang bị, ngài đã nhận rồi, không thể nhận thêm!")
    return 0
  end
  self:GetEquipRoute(me.nFaction, 1)
end

-- Nhận trang bị tím cấp 60 của hướng
function tbNpcBai:GetEquipRoute(nFactionId, nPosStartIdx)
  if me.nFaction ~= 0 then
    Faction:InitChangeFaction(me)
  end

  local tbOpt = {}
  local nCount = 9
  local nMajorFaction = Faction:Genre2Faction(me, 1)
  local nMinorFaction = Faction:Genre2Faction(me, 2)
  local tbFactions = { nMajorFaction }
  if nMinorFaction > 0 then
    table.insert(tbFactions, nMinorFaction)
  end

  for _, nFactionId in ipairs(tbFactions) do
    for i = nPosStartIdx, #Player.tbFactions[nFactionId].tbRoutes do
      if nCount <= 0 then
        tbOpt[#tbOpt] = { "Trang sau", self.GetEquipRoute, self, nFactionId, i - 1 }
        break
      end
      tbOpt[#tbOpt + 1] = {
        "Trang bị và vũ khí cấp 90 của " .. Player:GetFactionRouteName(nFactionId, i),
        self.GetEquip,
        self,
        nFactionId,
        i,
      }
      nCount = nCount - 1
    end
  end

  tbOpt[#tbOpt + 1] = { "Kết thúc đối thoại" }

  local szMsg = "Chọn hướng trang bị ngài cần. <color=yellow>Mỗi nhân vật chỉ có thể nhận một bộ trang bị, vui lòng chọn cẩn thận!<color>"
  Dialog:Say(szMsg, tbOpt)
end

-- Nhận trang bị tím cấp 90
function tbNpcBai:GetEquip(nFactionId, nRouteId)
  --local nEquipNum = me.GetTask(self.nTaskGroupId,self.nTaskIdFactionRoutes + (((nFactionId-1) * 2 + nRouteId) - 1));
  --if  nEquipNum ~= 0 then
  --	Dialog:Say("Ngài đã nhận trang bị của hướng này rồi, mỗi hướng chỉ được nhận một bộ.");
  --	return 0;
  --end
  if me.GetTask(self.nTaskGroupId, self.nTaskIdFactionRoutes) == 1 then
    Dialog:Say("Mỗi nhân vật chỉ có thể nhận một bộ trang bị, ngài đã nhận rồi, không thể nhận thêm!")
    return 0
  end

  local tbEquip = self.tbAddedItem[nFactionId][nRouteId][me.nSex]
  if not tbEquip then
    return
  end
  if me.CountFreeBagCell() < 35 then
    Dialog:Say("Túi đồ của ngài không đủ chỗ, cần 35 ô trống để nhận trang bị.")
    return 0
  end

  -- Trang bị ban đầu chỉ thêm vũ khí
  local g, d, p, l, s = unpack(tbEquip[1])
  local pItem = me.AddItem(g, d, p, l, s, 14) -- Vũ khí xử lý đặc biệt
  if pItem then
    pItem.Bind(1)
  end
  -- Áo choàng Sồ Phụng
  local pMantle = me.AddItem(1, 17, me.nSeries * 2 + me.nSex - 1, 7)
  if pMantle then
    pMantle.Bind(1)
  end
  self:GetPartners(3) -- Đồng hành cấp 3
  -- Võ Lâm Mật Tịch
  for i = 1, 5 do
    me.AddItem(18, 1, 191, 1).Bind(1)
  end
  for i = 1, 5 do
    me.AddItem(18, 1, 191, 2).Bind(1)
  end
  for i = 1, 5 do
    me.AddItem(18, 1, 192, 1).Bind(1)
  end
  for i = 1, 5 do
    me.AddItem(18, 1, 192, 2).Bind(1)
  end
  -- Ngũ Hành Ấn
  local pItem = me.AddItem(1, 16, me.nFaction, 1)
  if pItem then
    pItem.Bind(1)
    Item:SetSignetMagic(pItem, 1, 1000, 0)
    Item:SetSignetMagic(pItem, 2, 1000, 0)
  end
  -- Thần Hành Phù vô hạn
  local pTransfer = me.AddItem(18, 1, 195, 1)
  if pTransfer then
    pTransfer.Bind(1)
  end
  -- Xích Thố
  local pHorse = me.AddItem(1, 12, 67, 1)
  if pHorse then
    pHorse.Bind(1)
  end
  local pZhenfa = me.AddItem(18, 1, 320, 3)
  if pZhenfa then
    pZhenfa.Bind(1)
  end
  -- Trang bị
  self:GetItems(self.tbArmorsList, nFactionId, nRouteId, me.nSex, tbNpcBai.nEnhanceLevel)

  me.SetTask(self.nTaskGroupId, self.nTaskIdFactionRoutes, 1)

  --me.SetTask(self.nTaskGroupId,self.nTaskIdFactionRoutes + (((nFactionId-1) * 2 + nRouteId) - 1), 1);
end

-- Nhận ngựa cấp 60
function tbNpcBai:GetHorse_60Level()
  if me.GetTask(self.nTaskGroupId, self.nTaskId1) ~= 0 then
    Dialog:Say("Đã nhận Mã Bài rồi.")
    return 0
  end
  if me.CountFreeBagCell() < 5 then
    Dialog:Say("Túi đồ của ngài không đủ chỗ. Cần 5 ô trống.")
    return 0
  end
  for ni, tbItem in pairs(self.tbHorse_60Level) do
    local pItem = me.AddItem(unpack(tbItem))
    if pItem then
      pItem.Bind(1)
    end
  end
  me.SetTask(self.nTaskGroupId, self.nTaskId1, 1)
end

-- Tăng cấp Mật Tịch
function tbNpcBai:LevelUpBook()
  local pItem = me.GetEquip(Item.EQUIPPOS_BOOK)
  if not pItem then
    me.Msg("Trên người ngài không có Mật Tịch, nâng cấp thất bại, vui lòng trang bị Mật Tịch trước!")
    return
  end
  local nLevel = pItem.GetGenInfo(1)
  if nLevel >= self.nMijiLevel then
    me.Msg("Mật Tịch của ngài đã đạt cấp chỉ định!")
    return
  end
  for i = 1, 1000 do
    local nLevel = pItem.GetGenInfo(1) -- Cấp hiện tại của Mật Tịch
    if nLevel >= self.nMijiLevel then
      break
    end
    Item:AddBookKarma(me, self.nAddedKarmaPerTime)
  end
end
