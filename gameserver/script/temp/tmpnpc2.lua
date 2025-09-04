--Sử dụng cho máy chủ test

-- Nhân vật chuyên dùng cho trải nghiệm Tống Kim

local tbNpcBai = Npc:GetClass("tmpnpc2")

tbNpcBai.nTaskGroupId = 2051
tbNpcBai.nTaskId1 = 10 --Cờ hiệu nhận Mã Bài
tbNpcBai.nTaskId2 = 20 --Cờ hiệu nhận túi đồ, Bạc
tbNpcBai.nTaskIdRoute = {
  [1] = 30, --Cờ hiệu nhận trang bị một hướng
  [2] = 40, --Cờ hiệu nhận trang bị hướng còn lại
}
tbNpcBai.nTaskId3 = 50 --Nhận Bùa Hộ Thân Cầu Phúc

tbNpcBai.nSongjin_70Level = 120 -- Cấp độ người chơi được nâng lên trong trải nghiệm Tống Kim
tbNpcBai.nWeaponLevel = 10 -- Cấp vũ khí trong trải nghiệm Tống Kim
tbNpcBai.nArmor_Level = 10 -- Cấp phòng cụ trong trải nghiệm Tống Kim
tbNpcBai.nEnhanceLevel = 8 -- Cấp cường hóa trang bị trong trải nghiệm Tống Kim
tbNpcBai.nMijiLevel = 100 -- Cấp Mật Tịch
tbNpcBai.tbQiFuItem = {
  { 2, 6, 257, 10 }, --Kim
  { 2, 6, 258, 10 }, --Mộc
  { 2, 6, 259, 10 }, --Thủy
  { 2, 6, 260, 10 }, --Hỏa
  { 2, 6, 261, 10 }, --Thổ
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
tbNpcBai.nBindCoin = 5000 -- Đồng khóa
tbNpcBai.nExbagItem = {} -- Túi 20 ô
tbNpcBai.tbAddedItem = { -- Trang bị tím cấp 60
  { -- Thiếu Lâm
    { -- Đao Thiếu Lâm
      [0] = { --Nam
        { 2, 1, 727 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 }, --Vũ khí cận chiến meleeweapon.txt
        { 2, 3, 828 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 }, --Áo armor
        { 2, 9, 826 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 }, --Nón helm
        { 2, 8, 406 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 }, --Đai lưng belt
        { 2, 7, 408 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 }, --Giày boots
        { 2, 10, 680 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 }, --Bao tay cuff
        { 2, 5, 206 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 }, --Dây chuyền necklace
        { 2, 4, 250 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 }, --Nhẫn ring
        { 2, 11, 406 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 }, --Ngọc Bội pendant
        { 2, 6, 207 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 }, --Bùa hộ thân amulet
        { 1, 14, 1, 2, -1 },
      },
      [1] = { --Nữ
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
        { 2, 11, 406 - 6 + tbNpcBai.nArmor_Level, tbNpcBai.nArmor_Level, -1 },
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
        { 2, 2, 86 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 }, --Vũ khí tầm xa rangeweapon.txt
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
        { 2, 2, 96 - 6 + tbNpcBai.nWeaponLevel, tbNpcBai.nWeaponLevel, -1 }, --Vũ khí tầm xa rangeweapon.txt
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
}

tbNpcBai.tbArmorsList = {
  --series	,	sex	,	IsPhysical	,	Nguyên liệu	,	Genre	,	DetailType	,	ParticularType	,	Level
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
}
tbNpcBai.tbArmorsListPurple = {
  --{	series	,	sex	,	physical	,	Nguyên liệu	,	Genre	,	DetailType	,	ParticularType	,	Level	,},
  { 1, -1, -1, -1, 2, 6, 152, 1 },
  { 2, -1, -1, -1, 2, 6, 162, 1 },
  { 3, -1, -1, -1, 2, 6, 172, 1 },
  { 4, -1, -1, -1, 2, 6, 182, 1 },
  { 5, -1, -1, -1, 2, 6, 192, 1 },
  { 1, 0, -1, "Thiết", 2, 3, 603, 1 },
  { 1, 1, -1, "Thiết", 2, 3, 613, 1 },
  { 1, 0, -1, "Da", 2, 3, 623, 1 },
  { 1, 1, -1, "Da", 2, 3, 633, 1 },
  { 2, 0, -1, "Da", 2, 3, 643, 1 },
  { 2, 1, -1, "Da", 2, 3, 653, 1 },
  { 2, 0, -1, "Vải", 2, 3, 663, 1 },
  { 2, 1, -1, "Vải", 2, 3, 673, 1 },
  { 3, 0, -1, "Da", 2, 3, 683, 1 },
  { 3, 1, -1, "Da", 2, 3, 693, 1 },
  { 3, 0, -1, "Vải", 2, 3, 703, 1 },
  { 3, 1, -1, "Vải", 2, 3, 713, 1 },
  { 4, 0, -1, "Da", 2, 3, 723, 1 },
  { 4, 1, -1, "Da", 2, 3, 733, 1 },
  { 4, 0, -1, "Da", 2, 3, 743, 1 },
  { 4, 1, -1, "Da", 2, 3, 753, 1 },
  { 5, 0, -1, "Thiết", 2, 3, 763, 1 },
  { 5, 1, -1, "Thiết", 2, 3, 773, 1 },
  { 5, 0, -1, "Vải", 2, 3, 783, 1 },
  { 5, 1, -1, "Vải", 2, 3, 793, 1 },
  { 1, 0, -1, -1, 2, 8, 301, 1 },
  { 1, 1, -1, -1, 2, 8, 311, 1 },
  { 2, 0, -1, -1, 2, 8, 321, 1 },
  { 2, 1, -1, -1, 2, 8, 331, 1 },
  { 3, 0, -1, -1, 2, 8, 341, 1 },
  { 3, 1, -1, -1, 2, 8, 351, 1 },
  { 4, 0, -1, -1, 2, 8, 361, 1 },
  { 4, 1, -1, -1, 2, 8, 371, 1 },
  { 5, 0, -1, -1, 2, 8, 381, 1 },
  { 5, 1, -1, -1, 2, 8, 391, 1 },
  { 1, 0, -1, -1, 2, 7, 303, 1 },
  { 1, 1, -1, -1, 2, 7, 313, 1 },
  { 2, 0, -1, -1, 2, 7, 323, 1 },
  { 2, 1, -1, -1, 2, 7, 333, 1 },
  { 3, 0, -1, -1, 2, 7, 343, 1 },
  { 3, 1, -1, -1, 2, 7, 353, 1 },
  { 4, 0, -1, -1, 2, 7, 363, 1 },
  { 4, 1, -1, -1, 2, 7, 373, 1 },
  { 5, 0, -1, -1, 2, 7, 383, 1 },
  { 5, 1, -1, -1, 2, 7, 393, 1 },
  { 1, 0, -1, -1, 2, 10, 303, 1 },
  { 1, 1, -1, -1, 2, 10, 313, 1 },
  { 2, 0, -1, -1, 2, 10, 323, 1 },
  { 2, 1, -1, -1, 2, 10, 333, 1 },
  { 3, 0, -1, -1, 2, 10, 343, 1 },
  { 3, 1, -1, -1, 2, 10, 353, 1 },
  { 4, 0, -1, -1, 2, 10, 363, 1 },
  { 4, 1, -1, -1, 2, 10, 373, 1 },
  { 5, 0, -1, -1, 2, 10, 383, 1 },
  { 5, 1, -1, -1, 2, 10, 393, 1 },
  { 1, 0, -1, "Thiết", 2, 9, 601, 1 },
  { 1, 1, -1, "Thiết", 2, 9, 611, 1 },
  { 1, 0, -1, "Da", 2, 9, 621, 1 },
  { 1, 1, -1, "Da", 2, 9, 631, 1 },
  { 2, 0, -1, "Da", 2, 9, 641, 1 },
  { 2, 1, -1, "Da", 2, 9, 651, 1 },
  { 2, 0, -1, "Vải", 2, 9, 661, 1 },
  { 2, 1, -1, "Vải", 2, 9, 671, 1 },
  { 3, 0, -1, "Da", 2, 9, 681, 1 },
  { 3, 1, -1, "Da", 2, 9, 691, 1 },
  { 3, 0, -1, "Vải", 2, 9, 701, 1 },
  { 3, 1, -1, "Vải", 2, 9, 711, 1 },
  { 4, 0, -1, "Da", 2, 9, 721, 1 },
  { 4, 1, -1, "Da", 2, 9, 731, 1 },
  { 4, 0, -1, "Da", 2, 9, 741, 1 },
  { 4, 1, -1, "Da", 2, 9, 751, 1 },
  { 5, 0, -1, "Thiết", 2, 9, 761, 1 },
  { 5, 1, -1, "Thiết", 2, 9, 771, 1 },
  { 5, 0, -1, "Vải", 2, 9, 781, 1 },
  { 5, 1, -1, "Vải", 2, 9, 791, 1 },
  { 1, -1, -1, -1, 2, 5, 151, 1 },
  { 2, -1, -1, -1, 2, 5, 161, 1 },
  { 3, -1, -1, -1, 2, 5, 171, 1 },
  { 4, -1, -1, -1, 2, 5, 181, 1 },
  { 5, -1, -1, -1, 2, 5, 191, 1 },
  { 1, 0, -1, -1, 2, 11, 301, 1 },
  { 1, 1, -1, -1, 2, 11, 311, 1 },
  { 2, 0, -1, -1, 2, 11, 321, 1 },
  { 2, 1, -1, -1, 2, 11, 331, 1 },
  { 3, 0, -1, -1, 2, 11, 341, 1 },
  { 3, 1, -1, -1, 2, 11, 351, 1 },
  { 4, 0, -1, -1, 2, 11, 361, 1 },
  { 4, 1, -1, -1, 2, 11, 371, 1 },
  { 5, 0, -1, -1, 2, 11, 381, 1 },
  { 5, 1, -1, -1, 2, 11, 391, 1 },
  { 1, -1, -1, -1, 2, 4, 151, 1 },
  { 2, -1, -1, -1, 2, 4, 161, 1 },
  { 3, -1, -1, -1, 2, 4, 171, 1 },
  { 4, -1, -1, -1, 2, 4, 181, 1 },
  { 5, -1, -1, -1, 2, 4, 191, 1 },
}
tbNpcBai.tbArmorsListSilver = {
  --	series		sex		Physical		Nguyên liệu		Genre		DetailType		ParticularType		Level
  { 1, -1, -1, -1, 4, 6, 94, 10 },
  { 2, -1, -1, -1, 4, 6, 99, 10 },
  { 3, -1, -1, -1, 4, 6, 104, 10 },
  { 4, -1, -1, -1, 4, 6, 109, 10 },
  { 5, -1, -1, -1, 4, 6, 114, 10 },
  { 1, 1, -1, -1, 4, 3, 143, 10 },
  { 2, 1, -1, -1, 4, 3, 144, 10 },
  { 3, 1, -1, -1, 4, 3, 145, 10 },
  { 4, 1, -1, -1, 4, 3, 146, 10 },
  { 5, 1, -1, -1, 4, 3, 147, 10 },
  { 1, 0, -1, -1, 4, 3, 153, 10 },
  { 2, 0, -1, -1, 4, 3, 154, 10 },
  { 3, 0, -1, -1, 4, 3, 155, 10 },
  { 4, 0, -1, -1, 4, 3, 156, 10 },
  { 5, 0, -1, -1, 4, 3, 157, 10 },
  { 1, 0, -1, -1, 4, 8, 351, 10 },
  { 1, 1, -1, -1, 4, 8, 352, 10 },
  { 2, 0, -1, -1, 4, 8, 371, 10 },
  { 2, 1, -1, -1, 4, 8, 372, 10 },
  { 3, 0, -1, -1, 4, 8, 391, 10 },
  { 3, 1, -1, -1, 4, 8, 392, 10 },
  { 4, 0, -1, -1, 4, 8, 411, 10 },
  { 4, 1, -1, -1, 4, 8, 412, 10 },
  { 5, 0, -1, -1, 4, 8, 431, 10 },
  { 5, 1, -1, -1, 4, 8, 432, 10 },
  { 1, 0, -1, -1, 4, 8, 457, 10 },
  { 1, 1, -1, -1, 4, 8, 458, 10 },
  { 2, 0, -1, -1, 4, 8, 461, 10 },
  { 2, 1, -1, -1, 4, 8, 462, 10 },
  { 3, 0, -1, -1, 4, 8, 465, 10 },
  { 3, 1, -1, -1, 4, 8, 466, 10 },
  { 4, 0, -1, -1, 4, 8, 469, 10 },
  { 4, 1, -1, -1, 4, 8, 470, 10 },
  { 5, 0, -1, -1, 4, 8, 473, 10 },
  { 5, 1, -1, -1, 4, 8, 474, 10 },
  { 1, 0, -1, -1, 4, 9, 477, 10 },
  { 1, 1, -1, -1, 4, 9, 478, 10 },
  { 2, 0, -1, -1, 4, 9, 479, 10 },
  { 2, 1, -1, -1, 4, 9, 480, 10 },
  { 3, 0, -1, -1, 4, 9, 481, 10 },
  { 3, 1, -1, -1, 4, 9, 482, 10 },
  { 4, 0, -1, -1, 4, 9, 483, 10 },
  { 4, 1, -1, -1, 4, 9, 484, 10 },
  { 5, 0, -1, -1, 4, 9, 485, 10 },
  { 5, 1, -1, -1, 4, 9, 486, 10 },
  { 1, 0, -1, -1, 4, 3, 223, 10 },
  { 2, 0, -1, -1, 4, 3, 224, 10 },
  { 3, 0, -1, -1, 4, 3, 225, 10 },
  { 4, 0, -1, -1, 4, 3, 226, 10 },
  { 5, 0, -1, -1, 4, 3, 227, 10 },
  { 1, 1, -1, -1, 4, 3, 228, 10 },
  { 2, 1, -1, -1, 4, 3, 229, 10 },
  { 3, 1, -1, -1, 4, 3, 230, 10 },
  { 4, 1, -1, -1, 4, 3, 231, 10 },
  { 5, 1, -1, -1, 4, 3, 232, 10 },
  { 1, -1, 1, -1, 4, 4, 444, 10 },
  { 1, -1, 2, -1, 4, 4, 445, 10 },
  { 2, -1, 1, -1, 4, 4, 446, 10 },
  { 2, -1, 2, -1, 4, 4, 447, 10 },
  { 3, -1, 1, -1, 4, 4, 448, 10 },
  { 3, -1, 2, -1, 4, 4, 449, 10 },
  { 4, -1, 1, -1, 4, 4, 450, 10 },
  { 4, -1, 2, -1, 4, 4, 451, 10 },
  { 5, -1, 1, -1, 4, 4, 452, 10 },
  { 5, -1, 2, -1, 4, 4, 453, 10 },
  { 1, 0, -1, -1, 4, 7, 31, 10 },
  { 1, 1, -1, -1, 4, 7, 32, 10 },
  { 2, 0, -1, -1, 4, 7, 33, 10 },
  { 2, 1, -1, -1, 4, 7, 34, 10 },
  { 3, 0, -1, -1, 4, 7, 35, 10 },
  { 3, 1, -1, -1, 4, 7, 36, 10 },
  { 4, 0, -1, -1, 4, 7, 37, 10 },
  { 4, 1, -1, -1, 4, 7, 38, 10 },
  { 5, 0, -1, -1, 4, 7, 39, 10 },
  { 5, 1, -1, -1, 4, 7, 40, 10 },
  { 1, -1, 1, -1, 4, 5, 447, 10 },
  { 1, -1, 2, -1, 4, 5, 448, 10 },
  { 2, -1, 1, -1, 4, 5, 449, 10 },
  { 2, -1, 2, -1, 4, 5, 450, 10 },
  { 3, -1, 1, -1, 4, 5, 451, 10 },
  { 3, -1, 2, -1, 4, 5, 452, 10 },
  { 4, -1, 1, -1, 4, 5, 453, 10 },
  { 4, -1, 2, -1, 4, 5, 454, 10 },
  { 5, -1, 1, -1, 4, 5, 455, 10 },
  { 5, -1, 2, -1, 4, 5, 456, 10 },
  { 1, 0, -1, -1, 4, 11, 61, 10 },
  { 1, 1, -1, -1, 4, 11, 62, 10 },
  { 2, 0, -1, -1, 4, 11, 63, 10 },
  { 2, 1, -1, -1, 4, 11, 64, 10 },
  { 3, 0, -1, -1, 4, 11, 65, 10 },
  { 3, 1, -1, -1, 4, 11, 66, 10 },
  { 4, 0, -1, -1, 4, 11, 67, 10 },
  { 4, 1, -1, -1, 4, 11, 68, 10 },
  { 5, 0, -1, -1, 4, 11, 69, 10 },
  { 5, 1, -1, -1, 4, 11, 70, 10 },
  { 1, 0, -1, -1, 4, 11, 71, 10 },
  { 1, 1, -1, -1, 4, 11, 72, 10 },
  { 2, 0, -1, -1, 4, 11, 73, 10 },
  { 2, 1, -1, -1, 4, 11, 74, 10 },
  { 3, 0, -1, -1, 4, 11, 75, 10 },
  { 3, 1, -1, -1, 4, 11, 76, 10 },
  { 4, 0, -1, -1, 4, 11, 77, 10 },
  { 4, 1, -1, -1, 4, 11, 78, 10 },
  { 5, 0, -1, -1, 4, 11, 79, 10 },
  { 5, 1, -1, -1, 4, 11, 80, 10 },
  { 1, 0, 1, -1, 4, 10, 95, 10 },
  { 1, 1, 1, -1, 4, 10, 96, 10 },
  { 1, 0, 2, -1, 4, 10, 97, 10 },
  { 1, 1, 2, -1, 4, 10, 98, 10 },
  { 2, 0, 1, -1, 4, 10, 99, 10 },
  { 2, 1, 1, -1, 4, 10, 100, 10 },
  { 2, 0, 2, -1, 4, 10, 101, 10 },
  { 2, 1, 2, -1, 4, 10, 102, 10 },
  { 3, 0, 1, -1, 4, 10, 103, 10 },
  { 3, 1, 1, -1, 4, 10, 104, 10 },
  { 3, 0, 2, -1, 4, 10, 105, 10 },
  { 3, 1, 2, -1, 4, 10, 106, 10 },
  { 4, 0, 1, -1, 4, 10, 107, 10 },
  { 4, 1, 1, -1, 4, 10, 108, 10 },
  { 4, 0, 2, -1, 4, 10, 109, 10 },
  { 4, 1, 2, -1, 4, 10, 110, 10 },
  { 5, 0, 1, -1, 4, 10, 111, 10 },
  { 5, 1, 1, -1, 4, 10, 112, 10 },
  { 5, 0, 2, -1, 4, 10, 113, 10 },
  { 5, 1, 2, -1, 4, 10, 114, 10 },
}
tbNpcBai.tbArmorsListGold = {
  --	series		sex		IsPhysical		Nguyên liệu		Genre		DetailType		ParticularType		Level
  { 1, -1, -1, -1, 4, 6, 95, 10 },
  { 2, -1, -1, -1, 4, 6, 100, 10 },
  { 3, -1, -1, -1, 4, 6, 105, 10 },
  { 4, -1, -1, -1, 4, 6, 110, 10 },
  { 5, -1, -1, -1, 4, 6, 115, 10 },
  { 1, 1, -1, -1, 4, 3, 148, 10 },
  { 2, 1, -1, -1, 4, 3, 149, 10 },
  { 3, 1, -1, -1, 4, 3, 150, 10 },
  { 4, 1, -1, -1, 4, 3, 151, 10 },
  { 5, 1, -1, -1, 4, 3, 152, 10 },
  { 1, 0, -1, -1, 4, 3, 158, 10 },
  { 2, 0, -1, -1, 4, 3, 159, 10 },
  { 3, 0, -1, -1, 4, 3, 160, 10 },
  { 4, 0, -1, -1, 4, 3, 161, 10 },
  { 5, 0, -1, -1, 4, 3, 162, 10 },
  { 1, 0, -1, -1, 4, 8, 353, 10 },
  { 1, 1, -1, -1, 4, 8, 354, 10 },
  { 2, 0, -1, -1, 4, 8, 373, 10 },
  { 2, 1, -1, -1, 4, 8, 374, 10 },
  { 3, 0, -1, -1, 4, 8, 393, 10 },
  { 3, 1, -1, -1, 4, 8, 394, 10 },
  { 4, 0, -1, -1, 4, 8, 413, 10 },
  { 4, 1, -1, -1, 4, 8, 414, 10 },
  { 5, 0, -1, -1, 4, 8, 433, 10 },
  { 5, 1, -1, -1, 4, 8, 434, 10 },
  { 1, 0, -1, -1, 4, 8, 459, 10 },
  { 1, 1, -1, -1, 4, 8, 460, 10 },
  { 2, 0, -1, -1, 4, 8, 463, 10 },
  { 2, 1, -1, -1, 4, 8, 464, 10 },
  { 3, 0, -1, -1, 4, 8, 467, 10 },
  { 3, 1, -1, -1, 4, 8, 468, 10 },
  { 4, 0, -1, -1, 4, 8, 471, 10 },
  { 4, 1, -1, -1, 4, 8, 472, 10 },
  { 5, 0, -1, -1, 4, 8, 475, 10 },
  { 5, 1, -1, -1, 4, 8, 476, 10 },
  { 1, 0, -1, -1, 4, 9, 487, 10 },
  { 1, 1, -1, -1, 4, 9, 488, 10 },
  { 2, 0, -1, -1, 4, 9, 489, 10 },
  { 2, 1, -1, -1, 4, 9, 490, 10 },
  { 3, 0, -1, -1, 4, 9, 491, 10 },
  { 3, 1, -1, -1, 4, 9, 492, 10 },
  { 4, 0, -1, -1, 4, 9, 493, 10 },
  { 4, 1, -1, -1, 4, 9, 494, 10 },
  { 5, 0, -1, -1, 4, 9, 495, 10 },
  { 5, 1, -1, -1, 4, 9, 496, 10 },
  { 1, 0, -1, -1, 4, 3, 233, 10 },
  { 2, 0, -1, -1, 4, 3, 234, 10 },
  { 3, 0, -1, -1, 4, 3, 235, 10 },
  { 4, 0, -1, -1, 4, 3, 236, 10 },
  { 5, 0, -1, -1, 4, 3, 237, 10 },
  { 1, 1, -1, -1, 4, 3, 238, 10 },
  { 2, 1, -1, -1, 4, 3, 239, 10 },
  { 3, 1, -1, -1, 4, 3, 240, 10 },
  { 4, 1, -1, -1, 4, 3, 241, 10 },
  { 5, 1, -1, -1, 4, 3, 242, 10 },
  { 1, -1, 1, -1, 4, 4, 454, 10 },
  { 1, -1, 2, -1, 4, 4, 455, 10 },
  { 2, -1, 1, -1, 4, 4, 456, 10 },
  { 2, -1, 2, -1, 4, 4, 457, 10 },
  { 3, -1, 1, -1, 4, 4, 458, 10 },
  { 3, -1, 2, -1, 4, 4, 459, 10 },
  { 4, -1, 1, -1, 4, 4, 460, 10 },
  { 4, -1, 2, -1, 4, 4, 461, 10 },
  { 5, -1, 1, -1, 4, 4, 462, 10 },
  { 5, -1, 2, -1, 4, 4, 463, 10 },
  { 1, 0, -1, -1, 4, 7, 41, 10 },
  { 1, 1, -1, -1, 4, 7, 42, 10 },
  { 2, 0, -1, -1, 4, 7, 43, 10 },
  { 2, 1, -1, -1, 4, 7, 44, 10 },
  { 3, 0, -1, -1, 4, 7, 45, 10 },
  { 3, 1, -1, -1, 4, 7, 46, 10 },
  { 4, 0, -1, -1, 4, 7, 47, 10 },
  { 4, 1, -1, -1, 4, 7, 48, 10 },
  { 5, 0, -1, -1, 4, 7, 49, 10 },
  { 5, 1, -1, -1, 4, 7, 50, 10 },
  { 1, -1, 1, -1, 4, 5, 457, 10 },
  { 1, -1, 2, -1, 4, 5, 458, 10 },
  { 2, -1, 1, -1, 4, 5, 459, 10 },
  { 2, -1, 2, -1, 4, 5, 460, 10 },
  { 3, -1, 1, -1, 4, 5, 461, 10 },
  { 3, -1, 2, -1, 4, 5, 462, 10 },
  { 4, -1, 1, -1, 4, 5, 463, 10 },
  { 4, -1, 2, -1, 4, 5, 464, 10 },
  { 5, -1, 1, -1, 4, 5, 465, 10 },
  { 5, -1, 2, -1, 4, 5, 466, 10 },
  { 1, 0, -1, -1, 4, 11, 81, 10 },
  { 1, 1, -1, -1, 4, 11, 82, 10 },
  { 2, 0, -1, -1, 4, 11, 83, 10 },
  { 2, 1, -1, -1, 4, 11, 84, 10 },
  { 3, 0, -1, -1, 4, 11, 85, 10 },
  { 3, 1, -1, -1, 4, 11, 86, 10 },
  { 4, 0, -1, -1, 4, 11, 87, 10 },
  { 4, 1, -1, -1, 4, 11, 88, 10 },
  { 5, 0, -1, -1, 4, 11, 89, 10 },
  { 5, 1, -1, -1, 4, 11, 90, 10 },
  { 1, 0, -1, -1, 4, 11, 91, 10 },
  { 1, 1, -1, -1, 4, 11, 92, 10 },
  { 2, 0, -1, -1, 4, 11, 93, 10 },
  { 2, 1, -1, -1, 4, 11, 94, 10 },
  { 3, 0, -1, -1, 4, 11, 95, 10 },
  { 3, 1, -1, -1, 4, 11, 96, 10 },
  { 4, 0, -1, -1, 4, 11, 97, 10 },
  { 4, 1, -1, -1, 4, 11, 98, 10 },
  { 5, 0, -1, -1, 4, 11, 99, 10 },
  { 5, 1, -1, -1, 4, 11, 100, 10 },
  { 1, 0, 1, -1, 4, 10, 95, 10 },
  { 1, 1, 1, -1, 4, 10, 96, 10 },
  { 1, 0, 2, -1, 4, 10, 97, 10 },
  { 1, 1, 2, -1, 4, 10, 98, 10 },
  { 2, 0, 1, -1, 4, 10, 99, 10 },
  { 2, 1, 1, -1, 4, 10, 100, 10 },
  { 2, 0, 2, -1, 4, 10, 101, 10 },
  { 2, 1, 2, -1, 4, 10, 102, 10 },
  { 3, 0, 1, -1, 4, 10, 103, 10 },
  { 3, 1, 1, -1, 4, 10, 104, 10 },
  { 3, 0, 2, -1, 4, 10, 105, 10 },
  { 3, 1, 2, -1, 4, 10, 106, 10 },
  { 4, 0, 1, -1, 4, 10, 107, 10 },
  { 4, 1, 1, -1, 4, 10, 108, 10 },
  { 4, 0, 2, -1, 4, 10, 109, 10 },
  { 4, 1, 2, -1, 4, 10, 110, 10 },
  { 5, 0, 1, -1, 4, 10, 111, 10 },
  { 5, 1, 1, -1, 4, 10, 112, 10 },
  { 5, 0, 2, -1, 4, 10, 113, 10 },
  { 5, 1, 2, -1, 4, 10, 114, 10 },
}

tbNpcBai.tbWeaponsList = {
  --,Genre,DetailType,ParticularType,Level
  { 2, 1, 551, 10 },
  { 2, 1, 561, 10 },
  { 2, 1, 571, 10 },
  { 2, 1, 581, 10 },
  { 2, 2, 70, 10 },
  { 2, 2, 80, 10 },
  { 2, 1, 591, 10 },
  { 2, 1, 601, 10 },
  { 2, 1, 631, 10 },
  { 2, 1, 641, 10 },
  { 2, 1, 641, 10 },
  { 2, 1, 611, 10 },
  { 2, 1, 671, 10 },
  { 2, 1, 651, 10 },
  { 2, 1, 661, 10 },
  { 2, 1, 681, 10 },
  { 2, 1, 711, 10 },
  { 2, 1, 701, 10 },
  { 2, 1, 691, 10 },
  { 2, 1, 721, 10 },
  { 2, 1, 971, 10 },
  { 2, 1, 981, 10 },
  { 2, 1, 621, 10 },
  { 2, 1, 641, 10 },
  { 2, 1, 731, 10 },
  { 2, 1, 741, 10 },
  { 2, 1, 751, 10 },
  { 2, 1, 761, 10 },
  { 2, 2, 90, 10 },
  { 2, 2, 100, 10 },
  { 2, 1, 771, 10 },
  { 2, 1, 781, 10 },
  { 2, 1, 811, 10 },
  { 2, 1, 821, 10 },
  { 2, 1, 821, 10 },
  { 2, 1, 791, 10 },
  { 2, 1, 851, 10 },
  { 2, 1, 831, 10 },
  { 2, 1, 841, 10 },
  { 2, 1, 861, 10 },
  { 2, 1, 891, 10 },
  { 2, 1, 881, 10 },
  { 2, 1, 871, 10 },
  { 2, 1, 901, 10 },
  { 2, 1, 991, 10 },
  { 2, 1, 1001, 10 },
  { 2, 1, 801, 10 },
  { 2, 1, 821, 10 },
}
tbNpcBai.tbWeaponsListSilver = {
  --	Genre	,	DetailType	,	ParticularType	,	Level	},
  { 2, 1, 1265, 10 },
  { 2, 1, 1266, 10 },
  { 2, 1, 1267, 10 },
  { 2, 1, 1268, 10 },
  { 2, 2, 145, 10 },
  { 2, 2, 146, 10 },
  { 2, 1, 1269, 10 },
  { 2, 1, 1270, 10 },
  { 2, 1, 1273, 10 },
  { 2, 1, 1274, 10 },
  { 2, 1, 1274, 10 },
  { 2, 1, 1271, 10 },
  { 2, 1, 1277, 10 },
  { 2, 1, 1275, 10 },
  { 2, 1, 1276, 10 },
  { 2, 1, 1278, 10 },
  { 2, 1, 1281, 10 },
  { 2, 1, 1280, 10 },
  { 2, 1, 1279, 10 },
  { 2, 1, 1282, 10 },
  { 2, 1, 1283, 10 },
  { 2, 1, 1284, 10 },
  { 2, 1, 1272, 10 },
  { 2, 1, 1274, 10 },
}
tbNpcBai.tbWeaponsListGold = {
  --	Genre	,	DetailType	,	ParticularType	,	Level	},
  { 2, 1, 1335, 10 },
  { 2, 1, 1336, 10 },
  { 2, 1, 1337, 10 },
  { 2, 1, 1338, 10 },
  { 2, 2, 147, 10 },
  { 2, 2, 148, 10 },
  { 2, 1, 1339, 10 },
  { 2, 1, 1340, 10 },
  { 2, 1, 1343, 10 },
  { 2, 1, 1344, 10 },
  { 2, 1, 1344, 10 },
  { 2, 1, 1341, 10 },
  { 2, 1, 1347, 10 },
  { 2, 1, 1345, 10 },
  { 2, 1, 1346, 10 },
  { 2, 1, 1348, 10 },
  { 2, 1, 1351, 10 },
  { 2, 1, 1350, 10 },
  { 2, 1, 1349, 10 },
  { 2, 1, 1352, 10 },
  { 2, 1, 1353, 10 },
  { 2, 1, 1354, 10 },
  { 2, 1, 1342, 10 },
  { 2, 1, 1344, 10 },
}

tbNpcBai.tbBeltList = {
  --series,sex,physical,Nguyên liệu,Genre	,DetailType,ParticularType,Level
  { 1, 0, -1, -1, 4, 8, 457, 10 },
  { 1, 1, -1, -1, 4, 8, 458, 10 },
  { 2, 0, -1, -1, 4, 8, 461, 10 },
  { 2, 1, -1, -1, 4, 8, 462, 10 },
  { 3, 0, -1, -1, 4, 8, 465, 10 },
  { 3, 1, -1, -1, 4, 8, 466, 10 },
  { 4, 0, -1, -1, 4, 8, 469, 10 },
  { 4, 1, -1, -1, 4, 8, 470, 10 },
  { 5, 0, -1, -1, 4, 8, 473, 10 },
  { 5, 1, -1, -1, 4, 8, 474, 10 },
}

tbNpcBai.tbHorseList = {
  { 1, 12, 4, 2, -1 }, -- Ngựa cấp 60
  { 1, 12, 9, 3, -1 }, -- Ngựa cấp 90
}

tbNpcBai.tbFixList = {
  --Hướng,Ngũ hành,Nội ngoại công,Giáp vải da
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
}

-- Đối thoại
function tbNpcBai:OnDialog()
  Dialog:Say("Phương án nhân vật chuyên dùng cho Tống Kim 2", {
    { "Nâng cấp thành nhân vật máy chủ test", self.LevelUpPlayer, self, 1, 120 },
    { "Bộ trang bị Tống Kim", self.SjEquip, self },
    { "Cấu hình nhân vật dùng cho test ngoại mạng", self.WaiwangCeshi, self },
    { "Test phiên bản thu phí", self.DianKaBanTest, self },
    { "Nhận ngựa cấp 90", self.GetHorse_60Level, self },
    { "Tăng cấp Mật Tịch", self.LevelUpBook, self },
    { "Nhận Tu Luyện Châu để tẩy điểm vô hạn", self.GetXiuLianZhu, self },
    { "Nhận Bùa Hộ Thân Cầu Phúc", self.GetQiFuRing, self },
    { "Nhận và nâng cấp Ngũ Hành Ấn", self.UpDateWuXingYin, self },
    --{"Nhận Đồng và mở rộng túi đồ", self.AddMoneyAndExbag, self};
    { "Kết thúc đối thoại" },
  })
end

--Bộ trang bị Tống Kim
function tbNpcBai:SjEquip()
  local tbOpt = {
    { "Nhận trang bị chuyên dùng Tống Kim +4", self.GetEquipFaction, self, 1, 4 },
    { "Nhận trang bị chuyên dùng Tống Kim +8", self.GetEquipFaction, self, 1, 8 },
    { "Nhận trang bị chuyên dùng Tống Kim +10", self.GetEquipFaction, self, 1, 10 },
    { "Nhận trang bị chuyên dùng Tống Kim +12", self.GetEquipFaction, self, 1, 12 },
    { "Nhận trang bị chuyên dùng Tống Kim +14", self.GetEquipFaction, self, 1, 14 },
    { "Nhận trang bị chuyên dùng Tống Kim +16", self.GetEquipFaction, self, 1, 16 },
    { "Ta chỉ xem qua thôi" },
  }
  Dialog:Say("Ngài muốn gì?", tbOpt)
end

--Test phiên bản thu phí
function tbNpcBai:DianKaBanTest()
  local tbOpt = {
    { "Nâng cấp thành nhân vật cấp 79", self.LevelUpPlayer, self, 1, 79 },
    { "Nhận vật phẩm sinh hoạt cấp 79", self.GetSundries79, self },
    { "Trang bị nhân vật cấp 79 phiên bản thu phí", self.DianKaBanCeShi79, self },
    { "Nâng cấp thành nhân vật cấp 109", self.LevelUpPlayer, self, 1, 109 },
    { "Nhận vật phẩm sinh hoạt cấp 109", self.GetSundries109, self },
    { "Trang bị nhân vật cấp 109 phiên bản thu phí", self.DianKaBanCeShi109, self },
    { "Nhận Mật Tịch Trung Cấp và nâng cấp kỹ năng Mật Tịch", self.GetMiji, self },
    { "Tăng cấp Mật Tịch", self.LevelUpBook, self },
    { "Tẩy điểm", self.Xidian, self },
    { "Ta chỉ xem qua thôi" },
  }
  Dialog:Say("Ngài muốn gì?", tbOpt)
end

--Cấu hình nhân vật dùng cho test ngoại mạng
function tbNpcBai:WaiwangCeshi()
  local tbOpt = {
    { "Nâng cấp thành nhân vật cấp 120", self.LevelUpPlayer, self, 1, 120 },

    { "Nhận bộ trang bị cam +14 và vật phẩm khác", self.GetPurple, self },
    { "Nhận bộ trang bị Bạch Ngân +16 và vật phẩm khác", self.GetSilver, self },
    { "Nhận bộ trang bị Hoàng Kim +16 và vật phẩm khác", self.GetGold, self },

    { "Nhận các loại trang bị ->", self.GetSomeEquip, self },

    { "Tăng cấp Mật Tịch", self.LevelUpBook, self },
    { "Tẩy điểm", self.Xidian, self },
    { "Ta chỉ xem qua thôi" },
  }
  Dialog:Say("Ngài muốn gì?", tbOpt)
end

function tbNpcBai:GetSomeEquip()
  local tbOpt = {
    { "Nhận vật phẩm sinh hoạt", self.GetSundries, self },
    { "Nhận đồng hành 6 kỹ năng cấp 3", self.GetPartners, self, 3 },
    { "Nhận đồng hành 6 kỹ năng cấp 6", self.GetPartners, self, 6 },

    { "Nhận vũ khí cam +14", self.GetWeapons, self, self.tbWeaponsList, 14 },
    { "Nhận vũ khí cam +15", self.GetWeapons, self, self.tbWeaponsList, 15 },

    { "Nhận đai lưng +1", self.GetItems, self, self.tbBeltList, 14 },
    { "Nhận vũ khí Bạch Ngân +16", self.GetWeapons, self, self.tbWeaponsListSilver, 16 },
    { "Nhận phòng cụ, trang sức Bạch Ngân +16", self.GetItems, self, self.tbArmorsListSilver, 16 },
    { "Nhận vũ khí Hoàng Kim +16", self.GetWeapons, self, self.tbWeaponsListGold, 16 },
    { "Nhận phòng cụ, trang sức Hoàng Kim +16", self.GetItems, self, self.tbArmorsListGold, 16 },

    { "Nhận phòng cụ luyện hóa +1, +12", self.GetItems, self, self.tbArmorsList, 12 },
    { "Nhận phòng cụ luyện hóa +1, +14", self.GetItems, self, self.tbArmorsList, 14 },
    --{"Nhận phòng cụ luyện hóa +1, +16", 	self.GetItems, self, self.tbArmorsList, 16},

    { "Nhận Mật Tịch Trung/Cao Cấp và nâng cấp kỹ năng Mật Tịch", self.GetMiji, self },

    { "Trang trước", self.WaiwangCeshi, self },
    { "Ta chỉ xem qua thôi" },
  }
  Dialog:Say("Ngài muốn gì?", tbOpt)
end

--Trang bị phiên bản thu phí cấp 79
function tbNpcBai:DianKaBanCeShi79()
  local tbOpt = {
    { "Nhận vũ khí cam cấp 7 +10", self.GetWeapons, self, self.tbWeaponsList, 10, 7 },
    { "Nhận phòng cụ cam cấp 8 +10", self.GetItems, self, self.tbArmorsListPurple, 10, 8 },

    { "Ta chỉ xem qua thôi" },
  }
  Dialog:Say("Ngài muốn gì?", tbOpt)
end

--Trang bị phiên bản thu phí cấp 109
function tbNpcBai:DianKaBanCeShi109()
  local tbOpt = {
    { "Nhận vũ khí cam +12", self.GetWeapons, self, self.tbWeaponsList, 12 },
    { "Nhận phòng cụ luyện hóa +1, +12", self.GetItems, self, self.tbArmorsList, 12 },

    { "Ta chỉ xem qua thôi" },
  }
  Dialog:Say("Ngài muốn gì?", tbOpt)
end

function tbNpcBai:GetSundries()
  if me.nRouteId <= 0 then
    Dialog:Say("Chọn hướng tu luyện trước rồi hãy đến", tbOpt)
    return
  end
  --Võ Lâm Mật Tịch và Tẩy Tủy Kinh
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
  --Ngựa cấp 90
  local pItem = me.AddItem(unpack(tbNpcBai.tbHorseList[2])).Bind(1)
  --Áo choàng Sồ Phụng, Hỗn Thiên, Ngự Không mỗi loại một chiếc
  --me.AddItem(1,17,me.nSeries*2+me.nSex-1,5).Bind(1);
  --me.AddItem(1,17,me.nSeries*2+me.nSex-1,6).Bind(1);
  me.AddItem(1, 17, me.nSeries * 2 + me.nSex - 1, 7).Bind(1)
  me.AddItem(1, 17, 11 + me.nSex, 9).Bind(1) --Áo choàng Công Thành Chiến, đổi môn phái không cần đổi áo choàng
  --Thần Hành Phù vô hạn
  me.AddItem(18, 1, 235, 1).Bind(1)
  --Nhận túi đồ
  --for i=1,3 do me.AddItem(21,7,1,1).Bind(1) end
  --Nhận Ngũ Hành Ấn
  --local a = me.AddItem(1,16,me.nFaction,1);
  --for i=1,2 do Item: SetSignetMagic(a,i,300,0) end;
  --local b = me.AddItem(1,16,me.nFaction,1);
  --for i=1,2 do Item: SetSignetMagic(b,i,500,0) end;
end

function tbNpcBai:GetSundries79()
  if me.nRouteId <= 0 then
    Dialog:Say("Chọn hướng tu luyện trước rồi hãy đến", tbOpt)
    return
  end
  --Võ Lâm Mật Tịch và Tẩy Tủy Kinh
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
  --Ngựa cấp 60
  local pItem = me.AddItem(unpack(self.tbHorseList[1])).Bind(1)
  --Áo choàng Lăng Tuyệt
  me.AddItem(1, 17, me.nSeries * 2 + me.nSex - 1, 4).Bind(1)
  --Thần Hành Phù vô hạn
  me.AddItem(18, 1, 235, 1).Bind(1)
  --Nhận túi đồ
  --for i=1,3 do me.AddItem(21,7,1,1).Bind(1) end

  tbNpcBai:GetWeapons(self.tbWeaponsList, 10, 7)
  tbNpcBai:GetItems(self.tbArmorsListPurple, 10, 8)
  local tbEquip = self.tbAddedItem[me.nFaction][me.nRouteId][me.nSex]
  local tbTmp = { unpack(tbEquip[#tbEquip]) }
  local tmpMiji = me.AddItem(unpack(tbTmp))
end

function tbNpcBai:GetSundries109()
  if me.nRouteId <= 0 then
    Dialog:Say("Chọn hướng tu luyện trước rồi hãy đến", tbOpt)
    return
  end
  --Võ Lâm Mật Tịch và Tẩy Tủy Kinh
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
  --Ngựa cấp 90
  me.AddItem(unpack(self.tbHorseList[2])).Bind(1)
  --Áo choàng Ngự Không
  me.AddItem(1, 17, me.nSeries * 2 + me.nSex - 1, 5).Bind(1)
  --Thần Hành Phù vô hạn
  me.AddItem(18, 1, 235, 1).Bind(1)
  --Nhận túi đồ
  --for i=1,3 do me.AddItem(21,7,1,1).Bind(1) end

  tbNpcBai:GetWeapons(self.tbWeaponsList, 12)
  tbNpcBai:GetItems(self.tbArmorsList, 12)
  local tbEquip = self.tbAddedItem[me.nFaction][me.nRouteId][me.nSex]
  local tbTmp = { unpack(tbEquip[#tbEquip]) }
  local tmpMiji = me.AddItem(unpack(tbTmp))
end

function tbNpcBai:Xidian()
  me.ResetFightSkillPoint()
  me.SetTask(2, 1, 1)
  me.UnAssignPotential()
end

function tbNpcBai:GetWeapons(tbItemList, nQianghua, nLevel)
  local nItemRouteId = (me.nFaction - 1) * 2 + me.nRouteId
  if me.nRouteId <= 0 then
    Dialog:Say("Chọn hướng tu luyện trước rồi hãy đến", tbOpt)
    return
  end
  local tmpItem = { unpack(tbItemList[nItemRouteId]) }
  --Nếu không điền nLevel, sẽ lấy trực tiếp id vật phẩm trong bảng
  nLevel = nLevel or 10
  tmpItem[3] = tmpItem[3] + nLevel - 10
  tmpItem[4] = tmpItem[4] + nLevel - 10
  tmpItem[6] = nQianghua or 0
  me.AddItem(unpack(tmpItem)).Bind(1)
end

function tbNpcBai:GetItems(tbItemList, nQianghua, nLevel)
  if me.nRouteId <= 0 then
    Dialog:Say("Chọn hướng tu luyện trước rồi hãy đến", tbOpt)
    return
  end
  --Nếu không điền nLevel, sẽ lấy trực tiếp id vật phẩm trong bảng
  nLevel = nLevel or 1
  for i = 1, #tbItemList do
    local nItemRouteId = (me.nFaction - 1) * 2 + me.nRouteId
    if me.nRouteId ~= 0 then
      if tbItemList[i][1] == self.tbFixList[nItemRouteId][2] or tbItemList[i][1] == -1 then --Kiểm tra Ngũ hành có phù hợp không
        if tbItemList[i][2] == me.nSex or tbItemList[i][2] == -1 then --Kiểm tra giới tính có phù hợp không
          if tbItemList[i][3] == self.tbFixList[nItemRouteId][3] or tbItemList[i][3] == -1 then --Kiểm tra nội ngoại công có phù hợp không
            if tbItemList[i][4] == self.tbFixList[nItemRouteId][4] or tbItemList[i][4] == -1 then --Kiểm tra giáp vải/da/sắt có phù hợp không
              me.AddItem(tbItemList[i][5], tbItemList[i][6], tbItemList[i][7] + nLevel - 1, tbItemList[i][8] + nLevel - 1, -1, nQianghua).Bind(1)
            end
          end
        end
      end
    end
  end
end

function tbNpcBai:GetBelt(tbItemList)
  self:GetItems(tbItemList, 14)
end

--Thêm đồng hành
function tbNpcBai:GetPartners(nSkillLevel)
  if me.nRouteId <= 0 then
    Dialog:Say("Chọn hướng tu luyện trước rồi hãy đến", tbOpt)
    return
  end
  Partner:AddPartner(me.nId, 2025, -1)
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

  local INTTOALPOTENTIAL = 218 --Tổng tiềm năng đồng hành
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

function tbNpcBai:GetMiji()
  if me.nRouteId == 0 then
    Dialog:Say("Chọn hướng tu luyện trước rồi hãy đến", tbOpt)
    return
  end
  local tbEquip = self.tbAddedItem[me.nFaction][me.nRouteId][me.nSex]
  local tbTmp = { unpack(tbEquip[#tbEquip]) }
  local tmpMiji = me.AddItem(unpack(tbTmp))
  --Khinh công và Mật Tịch Trung Cấp
  me.AddFightSkill(10, 20)
  for i = 1200, 1222 do
    me.AddFightSkill(i, 10)
  end

  --me.AddItem(1,14,me.nFaction*2+me.nRouteId-2,2)--Mật Tịch Trung Cấp
  --me.AddFightSkill(819+(me.nFaction*2+me.nRouteId-3)*2,10)--Kỹ năng cấp 110
  --me.AddFightSkillPoint(-10)
  me.SetTask(1022, 215, 4095, 1)
  me.AddItem(1, 14, me.nFaction * 2 + me.nRouteId - 2, 3) --Mật Tịch Cao Cấp
  me.AddFightSkill(1240 + me.nFaction * 2 + me.nRouteId - 2, 10) --Kỹ năng Mật Tịch Cao Cấp
end

function tbNpcBai:GetPurple()
  tbNpcBai:GetSundries()
  tbNpcBai:GetPartners(3)
  local tbItemList = tbNpcBai.tbWeaponsList
  tbNpcBai:GetWeapons(tbItemList, 14)
  local tbItemList = tbNpcBai.tbArmorsList
  tbNpcBai:GetItems(tbItemList, 14)
  tbNpcBai:GetMiji()
end

function tbNpcBai:GetSilver()
  tbNpcBai:GetSundries()
  tbNpcBai:GetPartners(6)
  local tbItemList = tbNpcBai.tbWeaponsListSilver
  tbNpcBai:GetWeapons(tbItemList, 16)
  local tbItemList = tbNpcBai.tbArmorsListSilver
  tbNpcBai:GetItems(tbItemList, 16)
  tbNpcBai:GetMiji()
end

function tbNpcBai:GetGold()
  tbNpcBai:GetSundries()
  tbNpcBai:GetPartners(6)
  local tbItemList = tbNpcBai.tbWeaponsListGold
  tbNpcBai:GetWeapons(tbItemList, 16)
  local tbItemList = tbNpcBai.tbArmorsListGold
  tbNpcBai:GetItems(tbItemList, 16)
  tbNpcBai:GetMiji()
end

function tbNpcBai:UpDateWuXingYin()
  local tbOpt = {
    { "Nhận Ngũ Hành Ấn", self.GetWuXingYin, self },
    { "Nâng cấp Ngũ Hành Ấn - Tương khắc cường hóa", self.UpWuXingYin, self, 1 },
    { "Nâng cấp Ngũ Hành Ấn - Tương khắc nhược hóa", self.UpWuXingYin, self, 2 },
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
  end
  Dialog:Say("Ngài đã nhận thành công Ngũ Hành Ấn.")
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
  nLevel = nLevel + 300
  if nLevel > 1000 then
    nLevel = 1000
  end
  Item:SetSignetMagic(pSignet, nMagicIndex, nLevel, 0)
  Dialog:Say("Nâng cấp thuộc tính Ngũ Hành Ấn thành công, nếu thuộc tính chưa tối đa, ngài có thể tiếp tục tìm ta để nâng cấp.")
end

function tbNpcBai:GetQiFuRing()
  if me.GetTask(self.nTaskGroupId, self.nTaskId3) ~= 0 then
    Dialog:Say("Đã nhận Bùa Hộ Thân Cầu Phúc rồi.")
    return 0
  end
  if me.nFaction <= 0 or me.nSeries == 0 then
    Dialog:Say("Phải gia nhập môn phái mới có thể nhận Bùa Hộ Thân Cầu Phúc.")
    return 0
  end
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("Túi đồ của ngài không đủ chỗ.")
    return 0
  end
  local pItem = me.AddItem(unpack(self.tbQiFuItem[me.nSeries]))
  if pItem then
    pItem.Bind(1)
    me.SetTask(self.nTaskGroupId, self.nTaskId3, 1)
  end
  Dialog:Say("Ngài đã nhận thành công Bùa Hộ Thân Cầu Phúc.")
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
    Dialog:Say("<color=red>Ngươi đã có Tu Luyện Châu rồi！<color>")
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

-- Nâng cấp nhân vật
function tbNpcBai:LevelUpPlayer(nPosStartIdx, nSjLevel)
  --if (me.nLevel >= self.nSongjin_70Level) then
  --	Dialog:Say("Đã lên đến cấp chỉ định.");
  --	return;
  --end
  me.SetTask(1022, 215, 4095, 1)
  if me.nFaction ~= 0 then
    self:JoinFactionLevelUp(me.nFaction, nSjLevel)
    return
  end

  local tbOpt = {}
  local nCount = 9
  for i = nPosStartIdx, Player.FACTION_NUM do
    if nCount <= 0 then
      tbOpt[#tbOpt] = { "Trang sau", self.LevelUpPlayer, self, i - 1, nSjLevel }
      break
    end
    tbOpt[#tbOpt + 1] = { Player:GetFactionRouteName(i), self.JoinFactionLevelUp, self, i, nSjLevel }
    nCount = nCount - 1
  end
  tbOpt[#tbOpt + 1] = { "Kết thúc đối thoại" }
  Dialog:Say("Gia nhập môn phái", tbOpt)
end

-- Gia nhập môn phái
function tbNpcBai:JoinFactionLevelUp(nIndex, nSjLevel)
  if me.nFaction == 0 then
    local nSexLimit = Player.tbFactions[nIndex].nSexLimit
    if nSexLimit >= 0 and nSexLimit ~= me.nSex then
      me.Msg("Xin lỗi, môn phái này không nhận đệ tử " .. Player.SEX[me.nSex] .. "!")
      return
    end
    me.JoinFaction(nIndex)
  end
  ST_LevelUp(nSjLevel - me.nLevel)
  me.AddBindMoney(self.nBindMoney)
  me.AddBindCoin(self.nBindCoin)
  me.Earn(100, Player.emKEARN_EVENT)
  for i = 1, 3 do
    local pItem = me.AddItem(unpack(self.tbExbag_20Grid))
    if pItem then
      pItem.Bind(1)
    end
  end
  me.SetTask(self.nTaskGroupId, self.nTaskId2, 1)
  --for i=1,5 do me.AddItem(18,1,191,1) end;
  --for i=1,5 do me.AddItem(18,1,191,2) end;
  --for i=1,5 do me.AddItem(18,1,192,1) end;
  --for i=1,5 do me.AddItem(18,1,192,2) end;
  --me.AddItem(1,17,me.nSeries*2+me.nSex-1,5);
end

-- Nhận trang bị tím cấp 60 của môn phái
function tbNpcBai:GetEquipFaction(nPosStartIdx, nQiangHua)
  local tbOpt = {}
  local nCount = 9
  for i = nPosStartIdx, Player.FACTION_NUM do
    if nCount <= 0 then
      tbOpt[#tbOpt] = { "Trang sau", self.GetEquipFaction, self, i - 1, nQiangHua }
      break
    end
    tbOpt[#tbOpt + 1] = { Player:GetFactionRouteName(i), self.GetEquipRoute, self, i, 1, nQiangHua }
    nCount = nCount - 1
  end
  tbOpt[#tbOpt + 1] = { "Kết thúc đối thoại" }
  Dialog:Say("Chọn môn phái của trang bị tím ngài cần", tbOpt)
end

-- Nhận trang bị tím cấp 60 của hướng
function tbNpcBai:GetEquipRoute(nFactionId, nPosStartIdx, nQiangHua)
  local tbOpt = {}
  local nCount = 9
  for i = nPosStartIdx, #Player.tbFactions[nFactionId].tbRoutes do
    if nCount <= 0 then
      tbOpt[#tbOpt] = { "Trang sau", self.GetEquipRoute, self, nFactionId, i - 1, nQiangHua }
      break
    end
    tbOpt[#tbOpt + 1] = {
      "Bộ trang bị tím cấp 60 của " .. Player:GetFactionRouteName(nFactionId, i),
      self.GetEquip,
      self,
      nFactionId,
      i,
      nQiangHua,
    }
    nCount = nCount - 1
  end
  tbOpt[#tbOpt + 1] = { "Kết thúc đối thoại" }
  Dialog:Say("Chọn hướng của trang bị tím ngài cần", tbOpt)
end

-- Nhận trang bị tím cấp 60
function tbNpcBai:GetEquip(nFactionId, nRouteId, nQiangHua)
  local tbEquip = self.tbAddedItem[nFactionId][nRouteId][me.nSex]
  if not tbEquip then
    return
  end
  for i = 1, #tbEquip do
    local tbTmp = { unpack(tbEquip[i]) }
    tbTmp[6] = tbTmp[6] or nQiangHua
    me.AddItem(unpack(tbTmp))
  end
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
